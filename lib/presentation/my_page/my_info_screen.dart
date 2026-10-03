import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/utils/date_format.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';
import 'package:vybe/presentation/my_page/widgets/setting_row.dart';
import 'package:vybe/presentation/profile/viewmodels/user_viewmodel.dart';

/// MY-029 내 정보 (가입 정보) — 디자인 `MRMyInfoScreen`.
///
/// 설정 맨 위 '내 정보 > 내 정보 확인하기' 에서 들어온다.
/// 아바타 + 이름 + 가입 방식 행 하나, 그 아래 `가입 정보` 6줄, 하단 안내.
///
/// ⚠ **읽기 전용이다** — 이름·생년월일·전화번호는 본인인증으로 받은 값이라
/// 앱에서 바꿀 수 없다(`users` 의 그 세 필드는 `verifyIdentity` 만 쓴다).
/// 닉네임·사진을 고치는 자리는 MY-030(프로필 수정)이다.
///
/// ⚠ 값을 마스킹하지 않는다 — 디자인 `MRSetStatic` 이 `MR_ME.name` 을 그대로
/// 그린다. 본인만 보는 자리이고, 마스킹은 프로필 수정 화면의 가입 정보
/// 카드(`IdentityInfoCard`)가 이미 맡고 있다.
class MyInfoScreen extends ConsumerWidget {
  const MyInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUidProvider);
    final user = uid == null
        ? null
        : ref.watch(currentUserProvider(uid)).value;

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VybePushHeader(title: '내 정보'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    kMyPagePad.w,
                    18.h,
                    kMyPagePad.w,
                    24.h,
                  ),
                  child: user == null
                      ? const _MyInfoSkeleton()
                      : _Body(
                          name: user.name,
                          provider: user.provider,
                          gender: user.gender,
                          rows: [
                            ('이름', user.name),
                            ('휴대폰 번호', user.phone),
                            ('생년월일', birthDotLabel(user.birthDate)),
                            ('성별', genderLabel(user.gender)),
                            ('로그인 방식', kProviderNames[user.provider] ?? '-'),
                            ('가입일', fmtDateDot(user.createdAt)),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String name;
  final String provider;
  final String gender;

  /// `(라벨, 값)`. 값이 비어 있으면 `-` 로 그린다 — 빈 칸은 '없음' 과
  /// 구분이 안 된다.
  final List<(String, String)> rows;

  const _Body({
    required this.name,
    required this.provider,
    required this.gender,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 디자인 상단 행 — 아바타 64 + 이름 20sp + 가입 방식.
        // ⚠ 여기만 실명(`users.name`)을 쓴다. 본인 가입 정보 화면이라
        // 디자인도 `MR_ME.name` 을 그린다 — 남에게 보이는 자리가 아니다.
        Row(
          children: [
            MyAvatar(imageUrl: '', size: 64, ring: false, gender: gender),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name.isEmpty ? '-' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: VybeTypography.heading4.copyWith(
                      fontSize: 20.sp,
                      color: RenewGlass.t1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    providerJoinLabel(provider),
                    style: VybeTypography.body4.copyWith(
                      color: RenewGlass.t4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 26.h),

        // 디자인 `MRSetHead` 는 제목 옆에 보조문구를 붙이지만, 393·375 폭에서
        // 한 줄에 안 들어가 문장이 '…바꿀 수 없…' 으로 잘린다.
        // 잘린 문장보다 아랫줄이 낫다 — 내용은 디자인 그대로.
        Text('가입 정보', style: RenewGlass.title()),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            '본인인증 정보라 앱에서 바꿀 수 없어요',
            style: RenewGlass.caption(),
          ),
        ),
        for (final (i, row) in rows.indexed)
          SettingRow(
            label: row.$1,
            control: SettingValueStatic(row.$2.isEmpty ? '-' : row.$2),
            last: i == rows.length - 1,
          ),
        SizedBox(height: 26.h),

        const RenewFooterNote(
          text: '이름·생년월일·휴대폰 번호는 본인인증으로 받은 값이에요. '
              '변경이 필요하면 고객센터로 문의해 주세요.',
        ),
      ],
    );
  }
}

/// 사용자 문서를 읽는 동안 — 최종 레이아웃을 흉내 낸다(스피너 금지).
class _MyInfoSkeleton extends StatelessWidget {
  const _MyInfoSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            VybeSkel(width: 64.r, height: 64.r, radius: 32),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VybeSkel(width: 120.w, height: 20.h, radius: 6),
                SizedBox(height: 6.h),
                VybeSkel(width: 80.w, height: 13.h, radius: 5),
              ],
            ),
          ],
        ),
        SizedBox(height: 26.h),
        VybeSkel(width: 100.w, height: 15.h, radius: 5),
        SizedBox(height: 12.h),
        for (var i = 0; i < 6; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Container(
              height: 52.h,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: RenewGlass.hair)),
              ),
              child: VybeSkel(width: 90.w, height: 14.h, radius: 5),
            ),
          ),
      ],
    );
  }
}
