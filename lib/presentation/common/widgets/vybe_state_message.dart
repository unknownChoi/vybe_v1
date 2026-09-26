import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';

/// 로딩·오류·0건 자리에 가운데 놓는 회색 한 줄 (body4).
///
/// 홈 섹션·공지·문의·EDM 일정이 여백만 다르게 같은 문구를 그린다 —
/// 여백([padding]) 또는 고정 높이([height])만 넘긴다.
class VybeStateMessage extends StatelessWidget {
  final String text;

  /// 바깥 여백. screenutil 을 이미 적용한 값을 넘긴다.
  final EdgeInsetsGeometry? padding;

  /// **설계 단위** 높이 — 내부에서 `.h` 로 환산한다. 섹션 자리를 같은 높이로
  /// 채울 때(홈). `.h` 를 붙여 넘기면 두 번 환산된다.
  final double? height;

  final Color color;

  /// 행간(px). null 이면 [VybeTypography.body4] 기본.
  final double? lineHeight;

  const VybeStateMessage(
    this.text, {
    super.key,
    this.padding,
    this.height,
    this.color = VybeColors.gray500,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: VybeTypography.body4.copyWith(
          color: color,
          height: lineHeight == null ? null : lineHeight! / 14,
        ),
      ),
    );
    if (height != null) body = SizedBox(height: height!.h, child: body);
    if (padding != null) body = Padding(padding: padding!, child: body);
    return body;
  }
}
