import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 알약형 세그먼트 탭 — 움직이는 썸 + 탭별 건수 배지. 디자인 `.seg`.
///
/// 패스월렛 상단 4탭(입장권 · 예약 · 주문 · 이용 내역)과 목록 필터에 쓴다.
class VybeSegmentTabs extends StatelessWidget {
  const VybeSegmentTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.counts = const [],
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  /// 라벨 뒤 건수. 비어 있으면 안 그린다. 0 이면 그 탭은 배지를 숨긴다.
  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: RenewGlass.quietFill,
        borderRadius: BorderRadius.circular(V1Dim.badgeRadius.r),
        border: Border.all(color: RenewGlass.cardBorder),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                left: w * index,
                top: 0,
                bottom: 0,
                width: w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(V1Dim.badgeRadius.r),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onChanged(i),
                        behavior: HitTestBehavior.opaque,
                        // 탭이 4개면 좁은 기기에서 라벨 + 건수가 칸을 넘는다 —
                        // 줄이지 않고 축소해 그린다(글자가 잘리면 탭 뜻이 사라진다).
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  labels[i],
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: i == index
                                        ? RenewGlass.ink
                                        : RenewGlass.t3,
                                  ),
                                ),
                                if (i < counts.length && counts[i] > 0) ...[
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${counts[i]}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: i == index
                                          ? VybeColors.mainPurple500
                                          : RenewGlass.t4,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
