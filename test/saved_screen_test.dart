import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/favorite_model.dart';
import 'package:vybe/data/repositories/favorite_repository_impl.dart';
import 'package:vybe/domain/repositories/favorite_repository.dart';
import 'package:vybe/presentation/common/widgets/vybe_empty_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_save_button.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/saved/saved_screen.dart';
import 'package:vybe/presentation/saved/viewmodels/saved_viewmodel.dart';
import 'package:vybe/presentation/saved/widgets/saved_explore_button.dart';
import 'package:vybe/presentation/saved/widgets/saved_list_card.dart';
import 'package:vybe/presentation/saved/widgets/saved_skeleton.dart';
import 'package:vybe/presentation/saved/widgets/saved_toolbar.dart';

/// 찜 탭 — 빈 상태(공용 카드 + CTA → 홈 탭 요청) · 목록(카드 + 찜 해제) · 스켈레톤.
///
/// 썸네일 URL 은 비워 둔다 — 테스트에선 네트워크 이미지 provider 가 끝나지 않는다.

ClubModel _club(String id, String name) => ClubModel(
  clubId: id,
  name: name,
  description: '',
  address: '',
  area: '홍대',
  phone: '',
  instagramUrl: '',
  lat: 0,
  lng: 0,
  geohash: '',
  genre: '힙합',
  rating: 4.5,
  entryFeeMin: 0,
  entryFeeMax: 0,
  imageUrls: const [],
  thumbnailUrl: '',
  tags: const [],
  favoriteCount: 0,
  isActive: true,
  isVybeRecommended: false,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

SavedEntry _entry(String id, String name, {int day = 1}) => SavedEntry(
  club: _club(id, name),
  favorite: FavoriteModel(
    favoriteId: 'f_$id',
    userId: 'u',
    clubId: id,
    createdAt: DateTime(2026, 1, day),
  ),
);

/// 찜 해제만 기록하는 대역 — 나머지는 호출되지 않는다.
class _FakeFavoriteRepository implements FavoriteRepository {
  final List<String> unsaved = [];

  @override
  Future<void> removeFavorite(String userId, String clubId) async =>
      unsaved.add(clubId);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

Widget _app(Stream<List<SavedEntry>> entries, _FakeFavoriteRepository repo) =>
    ProviderScope(
      overrides: [
        savedClubsProvider.overrideWith((_) => entries),
        currentUidProvider.overrideWithValue('u'),
        favoriteRepositoryProvider.overrideWithValue(repo),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => const MaterialApp(home: SavedScreen()),
      ),
    );

void main() {
  // 2026-10-03 결정 ⑫ 묶음 — 디자인 PLACE-020 은 찜이 0곳이어도 헤더·툴바를 그대로 둔다
  // (베타만 숨겼고 코드에 '디자인과 다름' 주석이 있었다). 기대값을 디자인 쪽으로 바꿨다.
  // CTA 는 push 화면이 되어 '닫고 → 홈 탭'이라 탭 요청은 그대로 0 이다.
  testWidgets('빈 목록 — 공용 빈 카드 + 둘러보기 CTA, 툴바는 그대로, CTA 탭이 홈 탭을 요청한다',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final repo = _FakeFavoriteRepository();
    await tester.pumpWidget(_app(Stream.value(const []), repo));
    await tester.pump();

    expect(find.byType(VybeEmptyCard), findsOneWidget);
    expect(find.text('아직 찜한 클럽이 없어요'), findsOneWidget);
    expect(find.byType(SavedToolbar), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SavedScreen)),
    );
    await tester.tap(find.byType(SavedExploreButton));
    await tester.pump();
    expect(container.read(tabSwitchRequestProvider), 0);
  });

  testWidgets('목록 — 카드에 이름이 뜨고 찜 해제 버튼이 clubId 로 unsave 를 부른다',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final repo = _FakeFavoriteRepository();
    await tester.pumpWidget(
      // 기본 정렬은 최근 찜 순 — c1 을 더 늦게 찜해 첫 카드로 둔다.
      _app(
        Stream.value([_entry('c1', '클럽 알파', day: 2), _entry('c2', '클럽 베타')]),
        repo,
      ),
    );
    await tester.pump();

    expect(find.byType(SavedListCard), findsNWidgets(2));
    expect(find.text('클럽 알파'), findsOneWidget);
    expect(find.byType(SavedToolbar), findsOneWidget);

    await tester.tap(find.byType(VybeSaveButton).first);
    await tester.pump();
    expect(repo.unsaved, ['c1']);
  });

  testWidgets('로딩 중엔 스켈레톤을 그린다', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // 아무것도 내보내지 않는 스트림 = 로딩 유지.
    final pending = StreamController<List<SavedEntry>>();
    addTearDown(pending.close);
    await tester.pumpWidget(_app(pending.stream, _FakeFavoriteRepository()));
    await tester.pump();

    expect(find.byType(SavedSkeleton), findsOneWidget);
  });
}
