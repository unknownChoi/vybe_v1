import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/support/support_models.dart';

/// 문의 목록 상단 탭 (디자인 `SupTabs`) — 전체 · 답변 대기 · 답변 완료 + 건수.
///
/// 밑줄은 선택된 탭에만 라임으로 그린다. 건수를 라벨 옆에 붙여 두면
/// 탭을 눌러 보기 전에도 답변 대기가 남았는지 알 수 있다.
class InquiryTabs extends StatelessWidget {
  final InquiryTab selected;
  final ValueChanged<InquiryTab> onSelect;

  /// 탭별 건수.
  final Map<InquiryTab, int> counts;

  const InquiryTabs({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.h, left: RenewGlass.pagePad.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: RenewGlass.hair)),
      ),
      child: Row(
        children: [
          for (final tab in InquiryTab.values) ...[
            if (tab != InquiryTab.values.first) SizedBox(width: 22.w),
            _Tab(
              tab: tab,
              on: tab == selected,
              count: counts[tab] ?? 0,
              onTap: () => onSelect(tab),
            ),
          ],
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final InquiryTab tab;
  final bool on;
  final int count;
  final VoidCallback onTap;

  const _Tab({
    required this.tab,
    required this.on,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      // 밑줄은 라벨 위에 얹는다 — Column 자식으로 두면 Row 가 주는 무한 폭 제약에서
      // 자식 없는 Container 가 폭 0으로 접혀 선이 사라진다.
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(1.w, 10.h, 1.w, 13.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  tab.label,
                  style: VybeTypography.button1.copyWith(
                    fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                    color: on ? RenewGlass.t1 : RenewGlass.t4,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  '$count',
                  style: RenewGlass.caption(
                    color: on ? VybeColors.mainLime500 : VybeColors.gray600,
                    lineHeight: 14,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (on)
            // -1 은 바 아래 hairline 을 덮는 자리 (디자인 bottom: -1).
            Positioned(
              left: 0,
              right: 0,
              bottom: -1,
              child: Container(
                height: 2.h,
                decoration: BoxDecoration(
                  color: VybeColors.mainLime500,
                  borderRadius: BorderRadius.circular(2.r),
                  boxShadow: [
                    BoxShadow(
                      color: VybeColors.mainLime500.withValues(alpha: 0.4),
                      blurRadius: 12.r,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
