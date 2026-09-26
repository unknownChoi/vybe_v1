import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/filter_chip_style.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

// 장르 페이지(EDM · K-POP …) 섹션 헤더 · 우측 액션 pill · 가로 필터 칩 줄.
//
// 원래 EDM 전용(`edm/widgets/edm_chrome.dart`)이었는데 K-POP 이 같은 조각을 쓰게 돼
// 승격했다. 화면마다 복붙하면 같은 섹션이 화면마다 다른 여백으로 그려진다.

/// 섹션 헤더 — 제목 + 부제 + (선택) 우측 액션.
class VybeSectionHead extends StatelessWidget {
  final String title;
  final String sub;

  /// 우측에 붙는 것(지도 pill 등). null이면 제목만.
  final Widget? right;

  final double bottomGap;

  /// 좌우 여백 (`.w` 적용 전). 홈은 24.
  final double hPadding;
  final FontWeight titleWeight;

  const VybeSectionHead({
    super.key,
    required this.title,
    required this.sub,
    this.right,
    this.bottomGap = 14,
    this.hPadding = 16,
    this.titleWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: hPadding.w,
        right: hPadding.w,
        bottom: bottomGap.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 20.sp,
                    height: 23 / 20,
                    letterSpacing: 20 * -0.025,
                    fontWeight: titleWeight,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  sub,
                  style: VybeTypography.caption.copyWith(
                    height: 16 / 12,
                    color: VybeColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          if (right != null) ...[SizedBox(width: 12.w), right!],
        ],
      ),
    );
  }
}

/// 섹션 헤더 우측 pill (지도에서 보기 등).
class VybeHeadAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const VybeHeadAction({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: VybeColors.gray900,
          borderRadius: BorderRadius.circular(99.r),
          border: Border.all(color: VybeColors.gray800),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13.r, color: iconColor),
            SizedBox(width: 4.w),
            Text(
              label,
              style: VybeTypography.caption.copyWith(
                height: 14 / 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 가로 스크롤 필터 칩 줄. 칩 한 알의 외형은 앱 공용([VybeGlassFilterChip]).
///
/// 선택 판정은 [isSelected] 가 있으면 그쪽(다중 선택), 없으면 `label == active`.
class VybeChipRow extends StatelessWidget {
  final List<String> items;
  final String active;
  final ValueChanged<String> onChange;

  /// 다중 선택용 판정. 주면 [active] 는 무시된다.
  final bool Function(String label)? isSelected;

  /// 라벨 앞 아이콘. [iconExcept] 와 같은 항목에는 안 붙인다.
  final IconData? icon;
  final String? iconExcept;

  /// 라벨 뒤에 붙는 개수 등. null이면 라벨만.
  final Widget Function(String item, Color fg)? trailing;

  const VybeChipRow({
    super.key,
    required this.items,
    required this.active,
    required this.onChange,
    this.isSelected,
    this.icon,
    this.iconExcept,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final label = items[i];
          final build = trailing;
          final picked = isSelected;
          return VybeGlassFilterChip(
            label: label,
            selected: picked == null ? label == active : picked(label),
            icon: label == iconExcept ? null : icon,
            iconSize: 12,
            hPadding: 15,
            trailing: build == null ? null : (fg) => build(label, fg),
            onTap: () => onChange(label),
          );
        },
      ),
    );
  }
}

/// 칩 줄 로딩 스켈레톤 — 항목(지역·장르)은 목록을 받아야 알 수 있어 pill 모양만 깐다.
///
/// 로딩 중에 칩 줄을 아예 안 그리면 데이터가 온 순간 아래 내용이 34px 만큼 튄다.
/// 높이·간격·좌우 여백은 [VybeChipRow] 와 같은 값.
class VybeChipRowSkeleton extends StatelessWidget {
  const VybeChipRowSkeleton({super.key});

  /// 실제 칩 폭 근사(홍대 · 강남 · 이태원 · 건대). 넷이면 393 폭에 여유 있게 들어간다.
  static const _widths = [62.0, 62.0, 74.0, 62.0];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          for (var i = 0; i < _widths.length; i++) ...[
            VybeSkel(width: _widths[i].w, height: 34.h, radius: 999),
            if (i < _widths.length - 1) SizedBox(width: 8.w),
          ],
        ],
      ),
    );
  }
}
