import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_poster_sliver_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/kpop/widgets/vybe_club_poster_grid.dart';

/// 포스터 그리드 — sliver 로 바꾼 뒤에도 칩 다중 선택 · 개수 · 가까운 순 정렬 ·
/// 로딩 스켈레톤이 그대로인지.

class _FixedLocation extends UserLocationNotifier {
  @override
  UserLocation build() => const UserLocation(lat: 37.55, lng: 126.92);
}

ClubModel _club(String id, {double lat = 37.55, bool vybe = false}) =>
    ClubModel(
      clubId: id,
      name: id,
      description: '',
      address: '',
      area: '홍대',
      phone: '',
      instagramUrl: '',
      lat: lat,
      lng: 126.92,
      geohash: '',
      genre: 'K-POP',
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
      isFreeEntry: true,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

Widget _app(List<ClubModel> clubs, {bool loading = false}) => ProviderScope(
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
            VybeClubPosterGrid(
              clubs: clubs,
              loading: loading,
              filters: const [vybeRecommendedFilter, vybeFreeEntryFilter],
              accent: VybeColors.mainLime500,
            ),
          ],
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('가까운 순 정렬 · 칩 개수 · 다중 선택 필터', (tester) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // far 는 북쪽으로 0.1도(≈11km) — 가까운 near 가 먼저 와야 한다.
    await tester.pumpWidget(
      _app([_club('far', lat: 37.65, vybe: true), _club('near')]),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('2곳 · 내 위치에서 가까운 순'), findsOneWidget);
    final cards = tester
        .widgetList<VybeClubPosterCard>(find.byType(VybeClubPosterCard))
        .map((c) => c.club.id)
        .toList();
    expect(cards, ['near', 'far']);
    // 추천 1곳 · 무료입장 2곳.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // 추천 칩을 고르면 far 만 남고, 개수는 전체 기준 그대로.
    await tester.tap(find.text(vybeRecommendedFilter.label));
    await tester.pump();
    expect(find.byType(VybeClubPosterCard), findsOneWidget);
    expect(find.text('1곳 · 내 위치에서 가까운 순'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('로딩 중엔 칩 줄·그리드 자리에 스켈레톤', (tester) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(const [], loading: true));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(VybeChipRowSkeleton), findsOneWidget);
    expect(find.byType(VybePosterSliverGridSkeleton), findsOneWidget);
    expect(find.byType(VybeClubPosterCard), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
