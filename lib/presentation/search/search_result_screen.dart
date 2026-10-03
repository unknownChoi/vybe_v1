import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/search_trend_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/clubs/viewmodels/favorite_viewmodel.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/filter_chip_style.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_fade_in_up.dart';
import 'package:vybe/presentation/search/viewmodels/club_filter_viewmodel.dart';
import 'package:vybe/presentation/search/viewmodels/search_viewmodel.dart';
import 'package:vybe/presentation/search/widgets/club_list_item.dart';
import 'package:vybe/presentation/search/widgets/filter_chip_bar.dart';
import 'package:vybe/presentation/search/widgets/result_gnb.dart';
import 'package:vybe/presentation/search/widgets/search_result_item_skeleton.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final String query;

  /// 이 검색이 어디서 왔는지 — 인기 검색어 집계에서 되먹임을 걸러내는 데 쓰인다.
  final SearchSource source;

  const SearchResultScreen({
    super.key,
    required this.query,
    this.source = SearchSource.input,
  });

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

/// 고정 바 높이 — GNB(패딩 8+10 + pill 44) · 필터 줄(패딩 4+12 + 칩 34).
const double _kGnbHeight = 62;
const double _kFilterHeight = 50;

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  @override
  void initState() {
    super.initState();
    // 진입 즉시 첫 페이지 검색 (+ 검색 기록 저장).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = ref.read(currentUidProvider);
      ref
          .read(searchViewModelProvider.notifier)
          .search(widget.query, userId: uid, source: widget.source);
    });
  }

  /// 상단 바·필터 줄에 유리 배경을 깔지 (디자인 `scrollTop > 8`).
  bool _scrolled = false;

  // 바닥 근처 스크롤 시 다음 페이지(10개) 서버에서 추가 로드.
  bool _onScroll(ScrollNotification n) {
    final scrolled = n.metrics.pixels > 8;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
      ref.read(searchViewModelProvider.notifier).loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchViewModelProvider);
    final filters = ref.watch(clubFilterViewModelProvider);
    final sort = ref.watch(clubSortViewModelProvider);

    // 찜 상태(스트림 + 낙관적 오버라이드 머지).
    final uid = ref.watch(currentUidProvider);
    final favoritedIds = ref.watch(mergedFavoriteIdsProvider);

    // 영업·무료 판정 시각은 화면당 한 번 — 카드마다 읽으면 같은 목록 안에서
    // 기준이 어긋난다(CLAUDE.md 규칙).
    final now = DateTime.now();

    // 내 좌표도 한 번만 — 카드 거리 표기와 '거리순' 정렬이 같은 기준을 본다.
    final origin = ref.watch(
      userLocationProvider.select((l) => (lat: l.lat, lng: l.lng)),
    );

    // 로드된 결과에 필터 + 정렬 (클라) — 한 번만 돌려 메타 행 개수와 목록이
    // 같은 리스트를 본다. 로딩·실패면 null.
    final results = resultsAsync.value;
    final filtered = results == null
        ? null
        : sortClubs(
            results.clubs
                .where(
                  (c) => clubMatchesFilters(
                    c,
                    filters,
                    favoritedIds: favoritedIds,
                    now: now,
                  ),
                )
                .toList(),
            sort,
            // 좌표를 안 넘기면 '거리순' 이 입력 순서를 그대로 돌려준다(무동작).
            refLat: origin.lat,
            refLng: origin.lng,
          );

    // 메타 행 결과 수. 로딩 중엔 null.
    // - 필터 없음: 검색어 전체 매칭 수(totalCount) — 10개씩 로드해도 숫자 안 변함.
    // - 필터 있음: 서버는 필터를 모르므로 지금까지 로드된 것 중 통과 개수.
    final int? count = results == null
        ? null
        : filters.isEmpty
        ? results.totalCount
        : filtered!.length;

    final listKey = ValueKey(
      '${filters.map((f) => f.name).join(',')}-${sort.name}',
    );

    return Scaffold(
      backgroundColor: kVybeInk,
      body: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: _ResultBackdrop())),
          SafeArea(
            bottom: false,
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: CustomScrollView(
                slivers: [
                  // 디자인: GNB 는 sticky top 0, 필터 줄은 sticky top 62,
                  // **MetaRow 는 스크롤하면 위로 사라진다**.
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyBar(
                      height: _kGnbHeight,
                      scrolled: _scrolled,
                      opacity: 0.82,
                      child: ResultGnb(query: widget.query),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildMetaRow(count)),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyBar(
                      height: _kFilterHeight,
                      scrolled: _scrolled,
                      opacity: 0.90,
                      child: const FilterChipBar(tone: kSearchChipTone),
                    ),
                  ),
                  ...resultsAsync.when(
                    loading: () => [
                      SliverToBoxAdapter(child: _buildSkeletonList()),
                    ],
                    error: (e, _) => [
                      SliverToBoxAdapter(
                        child: _buildMessage('검색 중 오류가 발생했어요\n\n$e'),
                      ),
                    ],
                    data: (results) {
                      final clubs = filtered!; // data 상태면 위에서 계산됨

                      // 필터로 다 걸러졌는데 서버에 더 있으면 자동으로 다음 페이지
                      // 로드 (사용자가 스크롤할 콘텐츠가 없어 멈추는 것 방지).
                      if (clubs.isEmpty &&
                          results.hasMore &&
                          !results.loadingMore) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref.read(searchViewModelProvider.notifier).loadMore();
                        });
                      }

                      if (clubs.isEmpty) {
                        // 필터로 다 걸러진 채 다음 페이지를 받아오는 중 —
                        // 스피너 대신 카드 골격 스켈레톤으로 채운다.
                        if (results.hasMore || results.loadingMore) {
                          return [
                            SliverToBoxAdapter(child: _buildSkeletonList()),
                          ];
                        }
                        return [
                          SliverToBoxAdapter(
                            child: filters.isEmpty
                                ? _EmptyResult(
                                    title: "'${widget.query}' 검색 결과가 없어요",
                                  )
                                : const _EmptyResult(
                                    title: '조건에 맞는 클럽이 없어요',
                                    hint: '필터를 조정해 다시 찾아보세요',
                                  ),
                          ),
                        ];
                      }

                      final showSkeleton =
                          results.hasMore || results.loadingMore;
                      return [
                        SliverPadding(
                          padding: EdgeInsets.only(top: 4.h),
                          // 필터·정렬이 바뀌면 key 가 바뀌어 목록이 다시
                          // 페이드인한다(디자인 key={filters-sort} + fadeIn).
                          sliver: SliverList.builder(
                            key: listKey,
                            itemCount: clubs.length,
                            itemBuilder: (_, i) {
                              final club = clubs[i];
                              return VybeFadeInUp(
                                // 무한 스크롤로 index 가 커지면 지연이 1초를 넘어
                                // 빈 칸처럼 보인다 → 첫 화면만 차례로 올린다.
                                index: i < 8 ? i : null,
                                child: ClubListItem(
                                  club: club,
                                  now: now,
                                  distanceKm: club.lat == 0 && club.lng == 0
                                      ? null
                                      : vybeClubDistanceKm(
                                          club.lat,
                                          club.lng,
                                          origin: origin,
                                        ),
                                  isFavorited: favoritedIds.contains(
                                    club.clubId,
                                  ),
                                  onFavoriteTap: uid == null
                                      ? null
                                      : () => ref
                                            .read(
                                              favoriteViewModelProvider
                                                  .notifier,
                                            )
                                            .toggleFavorite(
                                              uid,
                                              club.clubId,
                                              favoritedIds.contains(
                                                club.clubId,
                                              ),
                                            ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (showSkeleton)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 6.h),
                              child: const Column(
                                children: [
                                  SearchResultItemSkeleton(),
                                  SearchResultItemSkeleton(),
                                ],
                              ),
                            ),
                          ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 결과 카드 자리를 채우는 스켈레톤 리스트 (최초 검색·필터 대기 중 표시).
  // 화면 높이에 상관없이 아래가 잘리도록 넉넉히 4장.
  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 4.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, __) => const SearchResultItemSkeleton(),
    );
  }

  Widget _buildMessage(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 80.h),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: VybeTypography.body3.copyWith(color: VybeColors.gray500),
        ),
      ),
    );
  }

  // 검색결과 수 + '내 주변 검색' 라임 pill (디자인 MetaRow).
  Widget _buildMetaRow(int? count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '검색결과',
                style: VybeTypography.body3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                count?.toString() ?? '–',
                style: VybeTypography.body3.copyWith(
                  color: VybeColors.mainLime500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const _NearbySearchPill(),
        ],
      ),
    );
  }
}

// 검색결과 배경 — 공용 리뉴얼 오로라([VybeAurora]).
class _ResultBackdrop extends StatelessWidget {
  const _ResultBackdrop();

  @override
  Widget build(BuildContext context) => const VybeAurora();
}

/// 상단 바·필터 줄을 화면 위에 고정하는 sliver 껍데기.
///
/// 디자인은 스크롤이 8px 를 넘으면(`scrolled`) 두 줄에 유리 배경을 깐다 —
/// 안 깔면 결과 카드가 글자 뒤로 비쳐 읽히지 않는다.
class _StickyBar extends SliverPersistentHeaderDelegate {
  const _StickyBar({
    required this.height,
    required this.scrolled,
    required this.opacity,
    required this.child,
  });

  final double height;
  final bool scrolled;

  /// 디자인 배경 알파 — GNB 0.82 · 필터 줄 0.90.
  final double opacity;
  final Widget child;

  @override
  double get minExtent => height.h;

  @override
  double get maxExtent => height.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return ClipRect(
      child: BackdropFilter(
        filter: scrolled
            ? ui.ImageFilter.blur(sigmaX: 9, sigmaY: 9)
            : ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height.h,
          color: scrolled
              ? kVybeInk.withValues(alpha: opacity)
              : Colors.transparent,
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyBar old) =>
      old.child != child || old.scrolled != scrolled || old.height != height;
}

/// '내 주변 검색' 표시 pill (디자인 MetaRow 우측).
///
/// ⚠ 디자인은 `<a>` 가 아니라 `<span>` 이다 — '이 검색이 내 위치 기준' 이라는
/// **표시 라벨**이라 탭 동작을 붙이지 않는다.
class _NearbySearchPill extends StatelessWidget {
  const _NearbySearchPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      decoration: BoxDecoration(
        color: V1Colors.limeTint10,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: V1Colors.limeTint28Border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.gps_fixed_rounded,
            size: 13.r,
            color: VybeColors.mainLime500,
          ),
          SizedBox(width: 5.w),
          Text(
            '내 주변 검색',
            style: VybeTypography.caption.copyWith(
              height: 14 / 12,
              fontWeight: FontWeight.w700,
              color: VybeColors.mainLime500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 결과 0건 안내 — 돋보기 + 1행(+ 2행). 디자인 search_results_v2.jsx:408-413.
class _EmptyResult extends StatelessWidget {
  final String title;

  /// null 이면 1행만 (검색어 자체가 0건인 경우 — 디자인에 2행 문구가 없다).
  final String? hint;

  const _EmptyResult({required this.title, this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded, size: 26.r, color: VybeColors.gray600),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: VybeTypography.body3.copyWith(
              color: VybeColors.gray400,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hint != null) ...[
            SizedBox(height: 10.h),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: VybeTypography.body4.copyWith(color: VybeColors.gray600),
            ),
          ],
        ],
      ),
    );
  }
}
