import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';

/// 카드 위에 얹는 원형 찜 버튼 (반투명 검정 배경 + 하트).
///
/// 검색·입장비 무료·서비스 음료·힙합 카드가 같은 모양을 쓴다.
/// 크기·채움만 화면마다 달라 [size]/[iconSize]/[fill]/[border]로 받는다.
/// 비로그인이면 [onTap]에 null을 넘겨 탭을 막는다(모양은 그대로).
class VybeSaveButton extends StatelessWidget {
  final bool saved;
  final VoidCallback? onTap;

  /// 버튼 지름 (`.r` 적용 전 값).
  final double size;

  /// 하트 아이콘 크기 (`.r` 적용 전 값).
  final double iconSize;

  /// 검정 42% 대신 쓸 채움 (글래스 타일 위 흰 7% 등).
  final Color? fill;

  /// 테두리. null이면 없음.
  final Color? border;

  /// 찜 상태 하트 색.
  final Color savedColor;

  const VybeSaveButton({
    super.key,
    required this.saved,
    required this.onTap,
    this.size = 32,
    this.iconSize = 17,
    this.fill,
    this.border,
    this.savedColor = VybeColors.mainPurple500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          color: fill ?? Colors.black.withValues(alpha: 0.42),
          shape: BoxShape.circle,
          border: border == null ? null : Border.all(color: border!),
        ),
        child: Icon(
          saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: iconSize.r,
          color: saved ? savedColor : Colors.white,
        ),
      ),
    );
  }
}
