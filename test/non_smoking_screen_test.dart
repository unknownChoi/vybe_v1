import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_map_section.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_poster_sliver_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_recommend_badge.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/non_smoking/non_smoking_models.dart';
import 'package:vybe/presentation/non_smoking/widgets/non_smoking_genre_grid.dart';

class _FixedLocation extends UserLocationNotifier {
  @override
  UserLocation build() => const UserLocation(lat: 37.55, lng: 126.92);
}

/// 좌표 없는 클럽(lat·lng 0) — 지도 섹션이 핀을 못 찍어 NaverMap(플랫폼 뷰 · 테스트 불가)을
/// 안 만들고 빈 지도 안내를 그린다. 그리드는 거리를 재야 하니 내 위치 좌표를 준다.
ClubModel _club(
  String id, {
  String genre = '힙합',
  bool located = true,
  bool vybe = false,
}) => ClubModel(
  clubId: id,
  name: id,
  description: '',
  address: '',
  area: '홍대',
  phone: '',
  instagramUrl: '',
  lat: located ? 37.55 : 0,
  lng: located ? 126.92 : 0,
  geohash: '',
  genre: genre,
  rating: 4.0,
  reviewCount: 1,
  entryFeeMin: 0,
  entryFeeMax: 0,
  imageUrls: const [],
  thumbnailUrl: '',
  tags: const [],
  favoriteCount: 0,
  isActive: true,
  isVybeRecommended: vybe,
  isNonSmoking: true,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

/// 화면 본문 두 섹션을 금연 페이지와 같은 인자로 조립한다.
/// (`NonSmokingScreen` 자체를 띄우면 히어로 아래 NaverMap이 테스트에서 못 만들어진다)
Widget _app({
  required List<ClubModel> mapClubs,
  required List<ClubModel> gridClubs,
  bool loading = false,
}) => ProviderScope(
  overrides: [
    currentUidProvider.overrideWithValue(null),
    userLocationProvider.overrideWith(_FixedLocation.new),
  ],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (_, __) => MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: VybeClubMapSection(
                clubs: mapClubs,
                loading: loading,
                title: '위치별로 금연 클럽 확인',
                subject: '금연 클럽',
                accent: kNonSmokingAccent,
              ),
            ),
            NonSmokingGenreGrid(clubs: gridClubs, loading: loading),
          ],
        ),
      ),
    ),
  ),
);

void main() {
  test('장르 칩은 실제 클럽이 있는 장르만 — 디자인 순서 4종 먼저, 나머지 이름순', () {
    final genres = nonSmokingGenresOf([
      _club('a', genre: '테크노'),
      _club('b', genre: '하이브리드'),
      _club('c', genre: 'EDM'),
      _club('d', genre: 'R&B'),
      _club('e', genre: ''),
    ]);
    expect(genres, ['EDM', '하이브리드', 'R&B', '테크노']);
    expect(nonSmokingGenresOf(const []), isEmpty);
  });

  testWidgets('문구 · 장르 칩 · 금연 뱃지 · VYBE 추천 뱃지가 나온다', (tester) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _app(
        mapClubs: [_club('a', located: false)],
        gridClubs: [
          _club('a'),
          _club('b', vybe: true),
          _club('c', genre: 'EDM'),
        ],
      ),
    );
    await tester.pump(const Duration(milliseconds: 350));

    // 지도 섹션 — 제목은 디자인 문구, 빈 지도 안내는 subject 로(K-POP 문구 잔재 0).
    expect(find.text('위치별로 금연 클럽 확인'), findsOneWidget);
    expect(find.text('지도에 표시할 금연 클럽이 없어요'), findsOneWidget);
    expect(find.textContaining('K-POP'), findsNothing);

    // 그리드 — 첫 칩(EDM)이 기본 선택, 부제가 그 장르 기준.
    expect(find.text('장르별로 금연 클럽 확인'), findsOneWidget);
    expect(find.text('EDM · 1곳 · 가까운 순'), findsOneWidget);
    expect(find.byType(VybeClubPosterCard), findsOneWidget);
    // 카드 하단은 #태그 대신 금연 뱃지.
    expect(find.text('실내 금연'), findsOneWidget);
    expect(find.textContaining('#'), findsNothing);

    // 칩을 바꾸면 그 장르 목록으로 — 추천 클럽은 주변 탭과 같은 공용 뱃지.
    await tester.tap(find.text('힙합'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('힙합 · 2곳 · 가까운 순'), findsOneWidget);
    expect(find.byType(VybeClubPosterCard), findsNWidgets(2));
    expect(find.byType(VybeRecommendBadge), findsOneWidget);
    expect(find.text('실내 금연'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('로딩 중엔 칩 줄·지도·그리드 자리에 스켈레톤이 깔린다', (tester) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _app(mapClubs: const [], gridClubs: const [], loading: true),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(VybeChipRowSkeleton), findsNWidgets(2));
    expect(find.byType(VybePosterSliverGridSkeleton), findsOneWidget);
    expect(find.byType(VybeClubPosterCard), findsNothing);
    expect(find.text('가까운 순'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
