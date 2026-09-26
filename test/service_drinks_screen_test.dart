import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/operating_hours.dart';
import 'package:vybe/data/models/service_drink.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_poster_sliver_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/service_drinks/service_drinks_models.dart';
import 'package:vybe/presentation/service_drinks/service_drinks_screen.dart';
import 'package:vybe/presentation/service_drinks/viewmodels/service_drinks_viewmodel.dart';

/// 서비스 음료 페이지(리뉴얼) — 종류 칩 · 제공 문구 뱃지 · 빈 안내 · 스켈레톤.
///
/// 클럽 좌표는 (0,0) — 지도 섹션이 핀을 못 찍어 NaverMap(플랫폼 뷰 · 테스트 불가)을
/// 안 만들고 빈 지도 안내를 그린다. Firestore를 타지 않도록 뷰모델을 가짜로 갈아 끼운다.

const _open24 = OperatingHours(
  mon: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  tue: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  wed: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  thu: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  fri: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  sat: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  sun: DayHours(isOpen: true, open: '00:00', close: '24:00'),
);

ClubModel _club({
  required String id,
  required String name,
  required String comment,
  required List<String> drinks,
}) => ClubModel(
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
  operatingHours: _open24,
  entryFeeMin: 20000,
  entryFeeMax: 30000,
  imageUrls: const [],
  thumbnailUrl: '',
  tags: const [],
  favoriteCount: 0,
  isActive: true,
  isVybeRecommended: false,
  serviceDrink: ServiceDrink(isOffered: true, comment: comment, drinks: drinks),
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

class _FixedLocation extends UserLocationNotifier {
  @override
  UserLocation build() =>
      const UserLocation(lat: 37.55, lng: 126.92, area: '홍대');
}

Widget _app(Future<List<ClubModel>> Function() load) => ProviderScope(
  overrides: [
    serviceDrinksViewModelProvider.overrideWith((ref) => load()),
    // 비로그인 — mergedFavoriteIds 가 Firestore 스트림을 건드리지 않게 한다.
    currentUidProvider.overrideWithValue(null),
    userLocationProvider.overrideWith(_FixedLocation.new),
  ],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (_, __) => const MaterialApp(home: ServiceDrinksScreen()),
  ),
);

/// 스켈레톤 shimmer 가 반복이라 pumpAndSettle 대신 정해진 만큼만 돌린다.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 300));
  }
}

/// 격자는 sliver 라 화면 밖 카드는 offstage — 캐시 범위 안이면 만들어져는 있다.
Finder _cards() => find.byType(VybeClubPosterCard, skipOffstage: false);

final _clubs = [
  _club(id: 'a', name: '위스키클럽', comment: '양주 1병 서비스', drinks: const ['양주']),
  _club(
    id: 'b',
    name: '맥주클럽',
    comment: '테이블당 맥주 6병',
    drinks: const ['맥주', '양주'],
  ),
  _club(id: 'c', name: '샴페인클럽', comment: '샴페인 1병', drinks: const ['샴페인']),
];

void main() {
  test('종류 칩은 실제로 주는 클럽이 있는 것만 — 디자인 순서, 모르는 값은 뒤에', () {
    expect(serviceDrinkTypesOf(_clubs), ['양주', '샴페인', '맥주']);
    expect(
      serviceDrinkTypesOf([
        _club(id: 'x', name: 'x', comment: '', drinks: const ['소주', '와인']),
      ]),
      ['와인', '소주'],
    );
    expect(serviceDrinkTypesOf(const []), isEmpty);
  });

  testWidgets('첫 칩(양주) 기준 목록 · 제공 문구 뱃지 · 칩 전환', (tester) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(() async => _clubs));
    await _settle(tester);

    // 지도 섹션 — 좌표 없는 클럽뿐이라 빈 지도 안내(K-POP 문구 잔재 0).
    expect(find.text('내 주변 서비스 음료 클럽'), findsOneWidget);
    expect(find.text('지도에 표시할 서비스 음료 클럽이 없어요'), findsOneWidget);
    expect(find.textContaining('K-POP'), findsNothing);

    // 그리드 — 첫 칩(양주)이 기본 선택, 양주를 주는 두 곳만.
    expect(find.text('음료 종류별로 무료 클럽 확인'), findsOneWidget);
    expect(find.text('양주 · 2곳 · 가까운 순'), findsOneWidget);
    expect(_cards(), findsNWidgets(2));
    // 카드 하단은 #태그 대신 제공 문구.
    expect(find.text('양주 1병 서비스', skipOffstage: false), findsOneWidget);
    expect(find.text('테이블당 맥주 6병', skipOffstage: false), findsOneWidget);
    expect(find.textContaining('#'), findsNothing);

    // 칩을 바꾸면 그 음료 목록으로.
    await tester.tap(find.text('샴페인'));
    await _settle(tester);
    expect(find.text('샴페인 · 1곳 · 가까운 순'), findsOneWidget);
    expect(_cards(), findsOneWidget);
    expect(find.text('샴페인 1병', skipOffstage: false), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('제공 클럽이 없으면 안내 문구를 보여준다', (tester) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(() async => const []));
    await _settle(tester);

    expect(find.text('이 음료를 주는 클럽이 아직 없어요'), findsOneWidget);
    expect(_cards(), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('로딩 중엔 칩 줄·지도·그리드 자리에 스켈레톤이 깔린다', (tester) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // 끝나지 않는 Future — 로딩 상태 고정.
    await tester.pumpWidget(_app(() => Completer<List<ClubModel>>().future));
    await tester.pump(const Duration(milliseconds: 100));

    // 히어로·지도 스켈레톤 아래라 뷰포트 밖 — sliver 는 트리엔 있으니 offstage 포함.
    expect(find.byType(VybeChipRowSkeleton), findsNWidgets(2));
    expect(
      find.byType(VybePosterSliverGridSkeleton, skipOffstage: false),
      findsOneWidget,
    );
    expect(_cards(), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
