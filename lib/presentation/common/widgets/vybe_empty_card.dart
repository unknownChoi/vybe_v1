import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 빈 상태 카드 — 글래스 카드 안에 보라 틴트 원 아이콘 + 제목 + 설명 (+ 버튼).
///
/// 공지·알림·주변 시트·찜 목록이 치수만 다르게 같은 카드를 그린다.
/// 기본값은 공지 빈 화면(padding 34 · 원 74 · 아이콘 30 · heading4). 주변 시트는
/// `circleSize: 62, iconSize: 24`, 찜은 `circleSize: 76` + [action] 으로 맞춘다.
/// 바깥 여백은 호출부가 준다.
class VybeEmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  /// 설명 아래 CTA. null 이면 없음.
  final Widget? action;

  /// 카드 안쪽 여백 (`.r` 적용 전).
  final double padding;

  /// 아이콘 원 지름·아이콘 크기 (`.r` 적용 전).
  final double circleSize;
  final double iconSize;
  final Color iconColor;

  /// 제목 글자. 기본 heading4 w700 white.
  final TextStyle? titleStyle;

  /// 원·제목·설명 사이 간격 (`.h` 적용 전).
  final double gap;

  const VybeEmptyCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.padding = 34,
    this.circleSize = 74,
    this.iconSize = 30,
    this.iconColor = const Color(0x80FFFFFF),
    this.titleStyle,
    this.gap = 13,
  });

  @override
  Widget build(BuildContext context) {
    return RenewGlassCard(
      sheen: true,
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize.r,
            height: circleSize.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: VybeColors.mainPurple500.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: VybeColors.mainPurple500.withValues(alpha: 0.30),
              ),
            ),
            child: Icon(icon, size: iconSize.r, color: iconColor),
          ),
          SizedBox(height: gap.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                titleStyle ??
                VybeTypography.heading4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: gap.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: VybeTypography.body4.copyWith(
              color: RenewGlass.t3,
              height: 20 / 14,
            ),
          ),
          if (action != null) ...[SizedBox(height: 16.h), action!],
        ],
      ),
    );
  }
}
