import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/navigation/swipe_back_page_route.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/performance_model.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_button.dart';
import 'package:vybe/presentation/common/widgets/vybe_image_hero.dart';
import 'package:vybe/presentation/common/widgets/vybe_poster_sliver_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/hip_hop/hip_hop_gradients.dart';
import 'package:vybe/presentation/hip_hop/hip_hop_style.dart';
import 'package:vybe/presentation/hip_hop/hip_hop_view_models.dart';
import 'package:vybe/presentation/hip_hop/today_lineup_screen.dart';
import 'package:vybe/presentation/hip_hop/viewmodels/hip_hop_viewmodel.dart';
import 'package:vybe/presentation/hip_hop/widgets/hip_hop_chrome.dart';
import 'package:vybe/presentation/hip_hop/widgets/hip_hop_dj_rail.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/nearby/viewmodels/nearby_search_provider.dart';

// 힙합 — 오늘 밤 헤드라인 공연 + DJ 라인업 + 지역별 인기 클럽.
// claude.ai/design hip_hop.html 디자인 기반. UI는 디자인(393 기준) 값 그대로 매핑.
// 데이터: hero/rail은 performances(오늘 공연), 그리드는 clubs + 오늘 라인업 머지.

class HipHopScreen extends ConsumerStatefulWidget {
  const HipHopScreen({super.key});

  @override
  ConsumerState<HipHopScreen> createState() => _HipHopScreenState();
}

class _HipHopScreenState extends ConsumerState<HipHopScreen> {
  String _area = kHipHopAreas.first;

  /// 하트 — 화면 상태뿐(찜 미연동). 카드의 버튼만 구독하므로 누를 때
  /// 화면·그리드가 다시 돌지 않는다.
  final _saved = ValueNotifier<Set<Object>>({});

  // 포스터 매핑(haversine × N)은 데이터·내 위치가 바뀔 때만 다시 한다.
  Object? _memoData;
  ({double lat, double lng})? _memoOrigin;
  List<VybeClubPoster> _source = const [];

  @override
  void dispose() {
    _saved.dispose();
    super.dispose();
  }

  void _toggleSave(Object id) {
    final next = {..._saved.value};
    next.contains(id) ? next.remove(id) : next.add(id);
    _saved.value = next;
  }

  // '지도에서 보기' → TOP 10 클럽을 주변 탭 지도 핀으로 표시 + 탭 전환.
  void _showOnMap(List<VybeClubPoster> grid, List<ClubModel> clubs) {
    final byId = {for (final c in clubs) c.clubId: c};
    final picked = grid.map((g) => byId[g.id]).whereType<ClubModel>().toList();
    if (picked.isEmpty) return;
    final keyword = _area == kHipHopAreas.first
        ? '힙합 인기 TOP 10'
        : '$_area 힙합 인기 TOP 10';
    ref
        .read(nearbySearchResultProvider.notifier)
        .showClubs(keyword: keyword, clubs: picked);
    // 주변 탭(index 1)으로 전환 — MainScaffold가 listen해 점프.
    ref.read(tabSwitchRequestProvider.notifier).request(1);
  }

  // 지역 필터 → 평점 desc → 리뷰수 desc → 상위 10개.
  List<VybeClubPoster> _grid() {
    final base = _area == kHipHopAreas.first
        ? _source
        : _source.where((c) => c.area == _area).toList();
    final sorted = base.toList()
      ..sort((a, b) {
        final r = b.rating.compareTo(a.rating);
        return r != 0 ? r : b.reviews.compareTo(a.reviews);
      });
    return sorted.take(10).toList();
  }

  void _openLineup() => Navigator.of(
    context,
  ).push(SwipeBackPageRoute(builder: (_) => const TodayLineupScreen()));

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom + 90.h;
    final async = ref.watch(hipHopViewModelProvider);
    final data = async.asData?.value;
    final loading = async.isLoading && data == null;

    final clubs = data?.clubs ?? const <ClubModel>[];
    final perfs = data?.performances ?? const <PerformanceModel>[];

    // 카드 거리 표시는 내 위치 기준.
    final me = ref.watch(userLocationProvider);
    final origin = (lat: me.lat, lng: me.lng);

    if (!identical(data, _memoData) || origin != _memoOrigin) {
      _memoData = data;
      _memoOrigin = origin;
      // 그리드(포스터) = 클럽 + 오늘 라인업 머지(live/lineup).
      final headliner = data?.headlinerByClub ?? const {};
      _source = [
        for (final c in clubs)
          vybeClubPosterFrom(
            c,
            origin: origin,
            headliner: headliner[c.clubId],
            bg: hipGradFor,
          ),
      ];
    }
    final grid = _grid();

    // 아티스트 = 오늘 공연 전체(시작시각순).
    final djs = [
      for (var i = 0; i < perfs.length; i++) hipHopDjFrom(perfs[i], i),
    ];

    return Scaffold(
      backgroundColor: kVybeInk,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // 배경 — 공용 리뉴얼 오로라(다른 카테고리 페이지와 동일). 화면 전체를 채운다.
            const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
            Positioned.fill(
              child: CustomScrollView(
                // ⚠ 튕김(오버스크롤) 금지 — 히어로가 상태바 뒤까지 올라가 있어서
                // 위로 당기면 이미지 위에 배경이 드러난다.
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverList.list(
                    children: [
                      // 상단은 오늘 공연 캐러셀 대신 인트로 히어로 이미지.
                      // 로딩 분기가 없다 — 로컬 asset이라 데이터와 무관하게 바로 그려진다.
                      const VybeImageHero(
                        'hip_hop',
                        heroAspect: 786 / 758,
                        headerHeight: 44,
                      ),
                      // 오늘의 공연 아티스트 (항상 노출)
                      Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: VybeSectionHead(
                          title: '오늘의 공연 아티스트',
                          sub: '내 주변 힙합 클럽 · 공연 시간순',
                          right: HipHopSeeAll(onTap: _openLineup),
                        ),
                      ),
                      if (loading)
                        const HipHopDjRailSkeleton()
                      else if (djs.isNotEmpty)
                        HipHopDjRail(djs: djs)
                      else
                        const HipHopRailEmpty(),
                      const HipHopNoticeCard(),
                      // 지역 필터 + 포스터 그리드
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 26.h, 0, 14.h),
                        child: VybeChipRow(
                          items: kHipHopAreas,
                          active: _area,
                          onChange: (a) => setState(() => _area = a),
                          icon: Icons.place_rounded,
                          iconExcept: kHipHopAreas.first,
                        ),
                      ),
                      VybeSectionHead(
                        title: _area == kHipHopAreas.first
                            ? '인기 클럽 TOP 10'
                            : '$_area 인기 클럽 TOP 10',
                        sub: _area == kHipHopAreas.first
                            ? '지금 가장 인기있는 클럽 TOP 10'
                            : '$_area에서 가장 인기있는 클럽 TOP 10',
                        right: VybeHeadAction(
                          label: '지도에서 보기',
                          icon: Icons.place_rounded,
                          iconColor: kHipAccent,
                          onTap: () => _showOnMap(grid, clubs),
                        ),
                      ),
                    ],
                  ),
                  if (loading)
                    const VybePosterSliverGridSkeleton()
                  else if (grid.isEmpty)
                    SliverToBoxAdapter(
                      child: VybeStateMessage(
                        '$_area 지역에는 클럽이 아직 없어요',
                        padding: EdgeInsets.symmetric(
                          vertical: 50.h,
                          horizontal: 24.w,
                        ),
                      ),
                    )
                  else
                    VybePosterSliverGrid(
                      itemCount: grid.length,
                      itemBuilder: (_, i) {
                        final c = grid[i];
                        return ValueListenableBuilder<Set<Object>>(
                          valueListenable: _saved,
                          builder: (_, saved, __) => VybeClubPosterCard(
                            club: c,
                            saved: saved.contains(c.id),
                            onSave: () => _toggleSave(c.id),
                            // 카드 탭 → 클럽 상세.
                            onTap: () => openClubDetail(context, c.id),
                          ),
                        );
                      },
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 24.h + bottomPad)),
                ],
              ),
            ),
            // 돌아가기 버튼 오버레이 (추천 페이지와 동일한 글래스 버튼).
            Positioned(
              top: MediaQuery.paddingOf(context).top,
              left: 16.w,
              child: VybeGlassButton(
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
