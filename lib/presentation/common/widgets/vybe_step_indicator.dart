import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 단계 표시 — 레일 + 진행 채움 + 단계마다 점 · 라벨. 디자인 `StepI` · `RkStep3`.
///
/// 3단계(환불 진행) · 4단계(예약 접수→완료 · 결제 처리) 둘 다 쓴다.
///
/// ⚠ 칸을 **등분**한다(각 단계 `Expanded`) — 라벨 길이에 따라 칸이 달라지면
/// 좁은 기기에서 가로가 넘친다(테스트 `v1_common_test` 가 360px 에서 잡는다).
class VybeStepIndicator extends StatelessWidget {
  const VybeStepIndicator({
    super.key,
    required this.labels,
    required this.current,
  });

  final List<String> labels;

  /// 0-based. 이 단계까지 채운다.
  final int current;

  @override
  Widget build(BuildContext context) {
    final dot = 10.r;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: dot,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 레일 — 첫 점 ~ 끝 점 사이만 긋는다.
              Row(
                children: [
                  SizedBox(width: _halfSlot(context)),
                  Expanded(child: _rail()),
                  SizedBox(width: _halfSlot(context)),
                ],
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(child: Center(child: _dot(i, dot))),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: i == current ? FontWeight.w600 : FontWeight.w400,
                    color: i <= current ? Colors.white : RenewGlass.t4,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// 첫 칸 · 끝 칸의 절반 — 레일이 점 밖으로 삐져나오지 않게.
  double _halfSlot(BuildContext context) =>
      MediaQuery.sizeOf(context).width / labels.length / 2;

  Widget _rail() {
    final filled = labels.length <= 1
        ? 1.0
        : (current / (labels.length - 1)).clamp(0.0, 1.0);
    return Stack(
      children: [
        Container(height: 2.h, color: RenewGlass.hair),
        FractionallySizedBox(
          widthFactor: filled,
          child: Container(height: 2.h, color: VybeColors.mainLime500),
        ),
      ],
    );
  }

  Widget _dot(int i, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: i <= current ? VybeColors.mainLime500 : RenewGlass.ink,
      border: Border.all(
        color: i <= current ? VybeColors.mainLime500 : RenewGlass.cardBorder,
      ),
    ),
  );
}
