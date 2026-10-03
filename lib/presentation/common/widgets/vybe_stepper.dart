import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 인원 · 수량 스테퍼 — 원형 −/+ 버튼 + 가운데 숫자 + 단위. 디자인 `.stp`.
///
/// 웨이팅 인원(1~8) · 예약 인원(1~10) · 메뉴 수량(1~9)에 쓴다.
class VybeStepper extends StatelessWidget {
  const VybeStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 9,
    this.unit,
    this.big = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  /// 숫자 뒤 단위('명' · '개').
  final String? unit;

  /// 큰 판(44 라임 숫자) — 인원 선택 화면용.
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundButton(
          icon: Icons.remove_rounded,
          enabled: value > min,
          onTap: () => onChanged(value - 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$value',
                style: big
                    ? V1Typo.ticketNumber
                    : V1Typo.stepperNumber,
              ),
              if (unit != null) ...[
                SizedBox(width: 3.w),
                Text(
                  unit!,
                  style: TextStyle(
                    fontSize: big ? 18.sp : 14.sp,
                    fontWeight: FontWeight.w500,
                    color: RenewGlass.t3,
                  ),
                ),
              ],
            ],
          ),
        ),
        _RoundButton(
          icon: Icons.add_rounded,
          enabled: value < max,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: RenewGlass.tileFill,
          border: Border.all(color: RenewGlass.tileBorder),
        ),
        child: Icon(
          icon,
          size: 18.r,
          color: enabled ? Colors.white : VybeColors.gray700,
        ),
      ),
    );
  }
}
