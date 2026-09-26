import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/utils/nickname.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';

/// 마이페이지 가로 프로필 행 (디자인 MRProfile).
class MyPageProfile extends StatelessWidget {
  /// 표시 이름 = `users.nickname`. 비어 있으면 중립 라벨로 그린다
  /// (실명으로 폴백하면 안 된다 — [kNicknameFallback] 참고).
  final String nickname;

  final String imageUrl;

  /// 디자인의 `@handle` 자리 — 스키마에 없어 가입 방식으로 대체.
  final String subtitle;

  final VoidCallback onEdit;

  const MyPageProfile({
    super.key,
    required this.nickname,
    required this.imageUrl,
    required this.subtitle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyAvatar(imageUrl: imageUrl),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                // 닉네임이 아직 없으면 중립 라벨 (실명 폴백 금지).
                nickname.isEmpty ? kNicknameFallback : nickname,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: VybeTypography.heading4.copyWith(
                  fontSize: 21.sp,
                  color: RenewGlass.t1,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: RenewGlass.body(color: RenewGlass.t4),
                ),
              ],
              SizedBox(height: 12.h),
              _EditPill(onTap: onEdit),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditPill extends StatelessWidget {
  final VoidCallback onTap;
  const _EditPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 32.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: RenewGlass.tileFill,
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: RenewGlass.tileBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '프로필 수정',
                style: VybeTypography.button2.copyWith(color: RenewGlass.t1),
              ),
              SizedBox(width: 5.w),
              const RenewChevron(
                dir: RenewChevronDir.right,
                size: 13,
                color: RenewGlass.t1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
