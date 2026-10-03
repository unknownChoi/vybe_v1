import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/utils/nickname.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';

/// 마이페이지 가로 프로필 행 (디자인 MRProfile).
///
/// **행 전체가 MY-030(내 정보 수정) 진입점이다** (결정 ㊱).
/// 디자인 `MRProfile` 은 아바타 + 이름 + 가입 방식 세 조각뿐이라 '프로필 수정' pill 이
/// 없다. 그렇다고 베타처럼 pill 을 그려 두면 디자인에 없는 버튼이 하나 늘고, pill 을
/// 그냥 지우면 MY-030 이 **도달 불가 화면**이 된다(디자인 쪽 `setView('edit')` 호출부 0).
/// 그래서 새 버튼을 그리는 대신 **이 행을 누르면 열리게** 했다.
class MyPageProfile extends StatelessWidget {
  /// 표시 이름 = `users.nickname`. 비어 있으면 중립 라벨로 그린다
  /// (실명으로 폴백하면 안 된다 — [kNicknameFallback] 참고).
  final String nickname;

  final String imageUrl;

  /// 디자인의 `@handle` 자리 — 스키마에 없어 가입 방식으로 대체.
  final String subtitle;

  /// 사진이 없을 때의 기본 피규어를 고르는 값 — [MyAvatar.gender].
  final String gender;

  /// 행을 누르면 열리는 화면 — MY-030 내 정보 수정.
  final VoidCallback onEdit;

  const MyPageProfile({
    super.key,
    required this.nickname,
    required this.imageUrl,
    required this.subtitle,
    required this.onEdit,
    this.gender = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      // 아바타와 글자 사이 빈 자리도 눌리게 — 행 전체가 버튼이다.
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          MyAvatar(imageUrl: imageUrl, gender: gender),
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
              ],
            ),
          ),
          // 누를 수 있는 행이라는 표시만 남긴다(디자인에 없는 pill 대신).
          const RenewChevron(
            dir: RenewChevronDir.right,
            size: 15,
            color: RenewGlass.t4,
          ),
        ],
      ),
    );
  }
}
