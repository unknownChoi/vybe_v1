import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';

/// 보라 → 라임 그라데이션 링 스피너. 디자인 `.ring`(44px · 두께 4px).
///
/// 기존 [VybeSpinner] 는 단색 보라 `CircularProgressIndicator` 라 모양이 다르다.
/// 결제 · 등록 처리 중 화면(FEE-072 · RSV-049 · ORDER-061)에서 쓴다.
class VybeGradientSpinner extends StatefulWidget {
  const VybeGradientSpinner({super.key, this.size = 44, this.stroke = 4});

  final double size;
  final double stroke;

  @override
  State<VybeGradientSpinner> createState() => _VybeGradientSpinnerState();
}

class _VybeGradientSpinnerState extends State<VybeGradientSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size.r;
    return SizedBox(
      width: s,
      height: s,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => CustomPaint(
          painter: _RingPainter(_c.value, widget.stroke.r),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.t, this.stroke);

  final double t;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final start = t * 2 * math.pi;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: GradientRotation(start),
        colors: const [
          VybeColors.mainPurple500,
          VybeColors.mainLime500,
          VybeColors.mainPurple500,
        ],
      ).createShader(rect);

    canvas.drawArc(
      rect.deflate(stroke / 2),
      start,
      math.pi * 1.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.t != t;
}
