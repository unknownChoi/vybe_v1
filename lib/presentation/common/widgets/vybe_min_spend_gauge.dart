import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 최소 주문금액 진행 바 — 금액 비교 행 + 막대 + 부족 금액 한 줄.
///
/// 디자인 `.mingauge`. 충족하면 라임으로 바뀐다.
/// 예약 메뉴판(MENU-090) · 장바구니(MENU-056) · 주문 결제(ORDER-061)에서 쓴다.
class VybeMinSpendGauge extends StatelessWidget {
  const VybeMinSpendGauge({
    super.key,
    required this.current,
    required this.minimum,
    required this.format,
    this.label = '최소 주문금액',
  });

  /// 담은 금액(원).
  final int current;

  /// 최소 주문금액(원).
  final int minimum;

  /// 금액 표기 함수 — 화면이 쓰던 포맷터를 그대로 넘긴다.
  final String Function(int won) format;

  final String label;

  bool get _met => current >= minimum;

  @override
  Widget build(BuildContext context) {
    final ratio = minimum <= 0 ? 1.0 : (current / minimum).clamp(0.0, 1.0);
    final color = _met ? VybeColors.mainLime500 : VybeColors.mainPurple500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: RenewGlass.t4),
            ),
            const Spacer(),
            Text(
              '${format(current)} / ${format(minimum)}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: _met ? VybeColors.mainLime500 : Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(99.r),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6.h,
            backgroundColor: RenewGlass.quietFill,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (!_met) ...[
          SizedBox(height: 6.h),
          Text(
            '${format(minimum - current)} 더 담으면 주문할 수 있어요',
            style: TextStyle(fontSize: 12.sp, color: RenewGlass.t4),
          ),
        ],
      ],
    );
  }
}
