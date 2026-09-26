import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 빈 찜 목록의 '클럽 둘러보기' 라임 CTA (`VybeEmptyCard.action` 자리).
///
/// saved_glass.html 의 컴팩트 pill(26×13 · r14) — 공용 `VybeButton`(56.h 풀폭)과
/// 다른 크기라 화면 전용으로 둔다.
class SavedExploreButton extends StatelessWidget {
  final VoidCallback onTap;

  const SavedExploreButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [VybeColors.mainLime500, VybeColors.mainLime700],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: VybeColors.mainLime500.withValues(alpha: 0.2),
              blurRadius: 26.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Text(
          '클럽 둘러보기',
          style: VybeTypography.button1.copyWith(
            fontWeight: FontWeight.w700,
            color: RenewGlass.ink,
          ),
        ),
      ),
    );
  }
}
