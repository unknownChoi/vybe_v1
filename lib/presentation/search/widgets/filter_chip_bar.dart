import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/clubs/widgets/club_glass.dart';
import 'package:vybe/presentation/common/filter_chip_style.dart';
import 'package:vybe/presentation/nearby/widgets/nearby_glass.dart';
import 'package:vybe/presentation/search/viewmodels/club_filter_viewmodel.dart';

/// 클럽 필터/정렬 칩 줄. 검색 결과 화면과 주변 페이지 바텀시트가 공유한다.
///
/// 칩 외형은 주변 리퀴드 글래스 토큰([NearbyGlass]) 기준 —
/// 테두리 없음, 비활성은 흰색 6% 채움, 활성은 보라 그라데이션.
/// 칩 하나의 정의 — 라벨 · 아이콘 · 거는 필터.
typedef _ChipSpec = ({
  ClubFilter filter,
  String label,
  IconData? icon,
  String? svg,
});

/// 검색 결과 화면이 쓰는 칩 줄 — 디자인 `search_results_v2.jsx:66-75` FILTERS 7개
/// (영업중 · 서비스 음료 · 입장료 무료 · 힙합 · EDM · 하이브리드 · 금연) 순서 그대로.
///
/// `favorite` 는 **주변 시트 전용**이라 목록에는 남기고 `showFavorite` 로 가린다
/// (지우면 `kNearbySheetFilters` 조회가 StateError 로 터진다).
/// ⚠ 'VYBE 추천' 칩은 디자인에 없다 — 주석이 'favorite omitted' 하나만 선언한다.
/// 되살리지 말 것(`ClubFilter.vybeRecommended` enum 값과 판정 분기는 그대로 둔다).
const List<_ChipSpec> _kAllChips = [
  (
    filter: ClubFilter.favorite,
    label: '찜한 클럽',
    icon: Icons.favorite_rounded,
    svg: null,
  ),
  (
    filter: ClubFilter.open,
    label: '영업중',
    icon: Icons.access_time_rounded,
    svg: null,
  ),
  (
    filter: ClubFilter.serviceDrink,
    label: '서비스 음료',
    icon: Icons.local_bar_rounded,
    svg: null,
  ),
  (
    filter: ClubFilter.freeEntry,
    label: '입장료 무료',
    icon: Icons.money_off_rounded,
    svg: null,
  ),
  (
    filter: ClubFilter.hiphop,
    label: '힙합',
    icon: Icons.headphones_rounded,
    svg: null,
  ),
  (
    filter: ClubFilter.edm,
    label: 'EDM',
    icon: Icons.graphic_eq_rounded,
    svg: null,
  ),
  (
    filter: ClubFilter.hybrid,
    label: '하이브리드',
    icon: Icons.shuffle_rounded,
    svg: null,
  ),
  (
    filter: ClubFilter.noSmoking,
    label: '금연',
    icon: Icons.smoke_free_rounded,
    svg: null,
  ),
];

/// 주변 지도 시트의 칩 줄 — 디자인 `nearby_glass_shell.jsx > NG_FILTERS`
/// (영업중 · 입장료 무료 · 서비스 음료 · 핫플레이스 · 찜한 클럽) 순서 그대로.
///
/// ⚠ '핫플레이스' 는 뺐다 — `clubs` 에도 설계 4장에도 핫플레이스 플래그가 없다
/// (PLACE-019 차이 #5 · 남김). 나머지 4개는 디자인 순서 그대로다.
const List<ClubFilter> kNearbySheetFilters = [
  ClubFilter.open,
  ClubFilter.freeEntry,
  ClubFilter.serviceDrink,
  ClubFilter.favorite,
];

class FilterChipBar extends ConsumerStatefulWidget {
  // 찜 필터 칩 노출 여부 (주변 페이지 전용 — 로그인 사용자 찜 목록 의존).
  final bool showFavorite;

  /// 칩 줄 바깥 여백. 화면마다 좌우 거터가 달라 주입받는다.
  final EdgeInsetsGeometry? padding;

  /// 그릴 필터와 순서. null이면 검색 결과 화면의 전체 9개.
  /// 주변 시트는 [kNearbySheetFilters] 를 넘긴다.
  final List<ClubFilter>? filters;

  /// 칩 안 아이콘. 디자인 주변 시트 칩은 **라벨만** 그린다
  /// (아이콘이 붙으면 칩 폭이 전부 넓어져 가로 스크롤 체감이 달라진다).
  final bool showIcons;

  /// 정렬 칩과 필터 칩 사이 세로 구분선. 디자인 주변 시트엔 없다.
  final bool showSortDivider;

  /// 칩 색 묶음. null 이면 주변 지도 글래스 톤(보라 그라데이션).
  ///
  /// ⚠ v1 디자인은 **화면마다 칩이 다르다** — 주변 지도(`nearby_glass.jsx:68-70`)는
  /// 지도 위 글래스 + 보라 그라데이션, 검색 결과(`search_results_v2.jsx:167-170`)는
  /// 불투명 GRAY900 + GRAY800 테두리 + PURPLE700 단색이다. 전역 값을 한쪽으로
  /// 맞추면 다른 쪽 디자인이 깨진다.
  final VybeChipTone? tone;

  const FilterChipBar({
    super.key,
    this.showFavorite = false,
    this.padding,
    this.filters,
    this.showIcons = true,
    this.showSortDivider = true,
    this.tone,
  });

  @override
  ConsumerState<FilterChipBar> createState() => _FilterChipBarState();
}

class _FilterChipBarState extends ConsumerState<FilterChipBar> {
  bool _sortOpen = false;

  // 정렬 칩 아래에 붙는 드롭다운 오버레이.
  final LayerLink _sortLink = LayerLink();
  OverlayEntry? _sortOverlay;

  @override
  void dispose() {
    _removeSortOverlay();
    super.dispose();
  }

  void _toggleSort() {
    if (_sortOverlay != null) {
      _closeSort();
    } else {
      _openSort();
    }
  }

  void _openSort() {
    _sortOverlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // 바깥 탭 → 닫기.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeSort,
            ),
          ),
          CompositedTransformFollower(
            link: _sortLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: Offset(0, 8.h),
            child: _SortDropdown(
              current: ref.read(clubSortViewModelProvider),
              onSelect: _selectSort,
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_sortOverlay!);
    setState(() => _sortOpen = true);
  }

  void _closeSort() {
    _removeSortOverlay();
    if (mounted) setState(() => _sortOpen = false);
  }

  void _removeSortOverlay() {
    _sortOverlay?.remove();
    _sortOverlay = null;
  }

  void _selectSort(ClubSort opt) {
    _removeSortOverlay();
    if (!mounted) return;
    ref.read(clubSortViewModelProvider.notifier).select(opt);
    setState(() => _sortOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(clubFilterViewModelProvider);
    final notifier = ref.read(clubFilterViewModelProvider.notifier);

    Widget toggle({
      required String label,
      required ClubFilter filter,
      IconData? icon,
      String? svgAsset,
    }) {
      return _buildToggleChip(
        label: label,
        icon: icon,
        svgAsset: svgAsset,
        isActive: active.contains(filter),
        onTap: () => notifier.toggle(filter),
      );
    }

    final specs = widget.filters == null
        ? _kAllChips
        : [
            for (final f in widget.filters!)
              _kAllChips.firstWhere((c) => c.filter == f),
          ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // 디자인 필터 줄 '4px 16px 12px' (위 4 / 아래 12). 주변 시트는 자기 padding 을 넘긴다.
      padding: widget.padding ?? EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Row(
        children: [
          _buildSortChip(),
          if (widget.showSortDivider)
            // 정렬 칩과 필터 칩 구분선 (칩에 테두리가 없어 이 선이 둘을 가른다).
            Container(
              width: 1,
              height: 18.h,
              margin: EdgeInsets.symmetric(horizontal: 9.w),
              color: ClubGlass.tileBorder,
            ),
          for (final c in specs)
            if (c.filter != ClubFilter.favorite || widget.showFavorite)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: toggle(
                  label: c.label,
                  filter: c.filter,
                  icon: widget.showIcons ? c.icon : null,
                  svgAsset: widget.showIcons ? c.svg : null,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSortChip() {
    final sort = ref.watch(clubSortViewModelProvider);
    // 기본값(추천순)이 아니거나 열린 상태면 보라로 강조.
    final isActive = _sortOpen || sort != ClubSort.recommended;
    return CompositedTransformTarget(
      link: _sortLink,
      child: GestureDetector(
        onTap: _toggleSort,
        child: _chipContainer(
          isActive: isActive,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                kClubSortLabels[sort]!,
                style: NearbyGlass.chipText(selected: true),
              ),
              SizedBox(width: 5.w),
              AnimatedRotation(
                turns: _sortOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  'assets/icons/common/add_content_arrow_down.svg',
                  width: 12.r,
                  height: 12.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 글래스 pill + 아이콘.
  // [svgAsset]을 주면 Material 아이콘 대신 SVG를 쓴다 (VYBE 추천 등 전용 아이콘).
  Widget _buildToggleChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    IconData? icon,
    String? svgAsset,
  }) {
    final tone = widget.tone;
    final fg = isActive
        ? (tone?.selectedInk ?? Colors.white)
        : ClubGlass.t2;
    return GestureDetector(
      onTap: onTap,
      child: _chipContainer(
        isActive: isActive,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgAsset != null)
              SvgPicture.asset(
                svgAsset,
                width: 13.r,
                height: 13.r,
                colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
              )
            else if (icon != null)
              Icon(icon, size: 13.r, color: fg),
            SizedBox(width: 5.w),
            Text(
              label,
              style: NearbyGlass.chipText(
                selected: isActive,
              ).copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }

  // 기본은 테두리 없는 글래스 pill — 비활성 흰색 6% 채움, 활성 보라 그라데이션.
  // [FilterChipBar.tone] 을 주면 그 화면 디자인 색으로 칠한다(검색 결과 = 단색).
  Widget _chipContainer({required bool isActive, required Widget child}) {
    final tone = widget.tone;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: 34.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      decoration: BoxDecoration(
        color: tone != null
            ? (isActive ? tone.selectedFill : tone.restFill)
            : (isActive ? null : NearbyGlass.chipFill),
        gradient: tone == null && isActive ? NearbyGlass.activeChip : null,
        border: tone?.restBorder != null && !isActive
            ? Border.all(color: tone!.restBorder!)
            : null,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: child,
    );
  }
}

// 정렬 칩 아래 드롭다운. 선택 항목 = 라임 배경 pill + 라임 텍스트 + 체크.
class _SortDropdown extends StatelessWidget {
  final ClubSort current;
  final ValueChanged<ClubSort> onSelect;

  const _SortDropdown({
    required this.current,
    required this.onSelect,
  });

  static const _lime = VybeColors.mainLime500;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 180.w,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: VybeColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: VybeColors.gray800, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ClubSort.values.map((opt) {
            final selected = opt == current;
            return InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: () => onSelect(opt),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
                decoration: BoxDecoration(
                  color: selected
                      ? _lime.withValues(alpha: 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        kClubSortLabels[opt]!,
                        style: VybeTypography.body4.copyWith(
                          color: selected ? _lime : VybeColors.gray200,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_rounded, size: 16.r, color: _lime),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
