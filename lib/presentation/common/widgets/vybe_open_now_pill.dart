import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';

/// 사진 위에 얹는 「● 영업 중 / 영업 종료」 pill.
///
/// 입장비 무료·서비스 음료 카드가 공유한다. 검색 카드·포스터 카드의 작은 판은
/// [fontSize]·[dotSize]·[padding]·[height]만 다르게 준다.
class VybeOpenNowPill extends StatelessWidget {
  final bool open;

  /// pill 높이. screenutil이 이미 적용된 값을 넘긴다(`32.r` / `32.h`).
  /// 생략하면 `32.r`. [fixedHeight]가 false면 높이를 고정하지 않는다(포스터용).
  final double? height;
  final bool fixedHeight;

  final double fontSize;
  final double dotSize;

  /// 안쪽 여백. 생략하면 좌우 11.
  final EdgeInsetsGeometry? padding;

  final String openLabel;
  final String closedLabel;

  const VybeOpenNowPill({
    super.key,
    required this.open,
    this.height,
    this.fixedHeight = true,
    this.fontSize = 11,
    this.dotSize = 6,
    this.padding,
    this.openLabel = '영업 중',
    this.closedLabel = '영업 종료',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fixedHeight ? (height ?? 32.r) : null,
      alignment: Alignment.center,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 11.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(
          color: open
              ? VybeColors.mainLime500.withValues(alpha: 0.5)
              : VybeColors.gray700,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dotSize.r,
            height: dotSize.r,
            decoration: BoxDecoration(
              color: open ? VybeColors.mainLime500 : VybeColors.gray500,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            open ? openLabel : closedLabel,
            style: VybeTypography.caption.copyWith(
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w700,
              color: open ? VybeColors.mainLime500 : VybeColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}
