import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/presentation/auth/viewmodels/auth_viewmodel.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_confirm_dialog.dart';
import 'package:vybe/presentation/common/widgets/vybe_fade_in_up.dart';
import 'package:vybe/presentation/common/widgets/vybe_toast.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_hide_route.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/my_page/my_reviews_screen.dart';
import 'package:vybe/presentation/my_page/notices_screen.dart';
import 'package:vybe/presentation/my_page/profile_edit_screen.dart';
import 'package:vybe/presentation/my_page/settings_screen.dart';
import 'package:vybe/presentation/my_page/viewmodels/my_page_viewmodel.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_logged_out.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_profile.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_profile_skeleton.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_stats.dart';
import 'package:vybe/presentation/profile/viewmodels/user_viewmodel.dart';
import 'package:vybe/presentation/saved/viewmodels/saved_viewmodel.dart';
import 'package:vybe/presentation/support/support_screen.dart';
import 'package:vybe/presentation/support/viewmodels/inquiry_viewmodel.dart';

// ============================================================
// 마이페이지 — 리뉴얼 (my_renew.html 디자인 기반)
//
// 오로라 배경 + 가로 프로필 행 + 통계 카드 2칸 +
// '내 활동'·'계정' 메뉴 목록(카드 없이 헤어라인으로만 구분) + 버전 표기.
//
// 디자인의 @핸들·한 줄 소개는 users 스키마에 없어 가입 방식(provider)
// 표기로 대체. '알림' 화면은 베타 범위 외 — 준비 중 토스트.
//
// ⚠ 이름은 `user.nickname` 을 쓴다 — `user.name` 은 본인인증으로 받은 실명이라
// 화면에 띄우지 않는다(리뷰·문의에 실명이 새 나가던 경로였다).
// 디자인 하단 탭바는 MainScaffold가 이미 그리므로 여기선 그리지 않는다.
// ============================================================

/// 찜 탭 인덱스 (MainScaffold PageView 기준).
const int _kSavedTabIndex = 2;

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUidProvider);

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: VybeAurora()),
          uid == null ? const MyPageLoggedOutView() : _LoggedInView(uid: uid),
        ],
      ),
    );
  }
}

// ============ 로그인 ============

class _LoggedInView extends ConsumerWidget {
  final String uid;

  const _LoggedInView({required this.uid});

  // 하위 페이지(프로필 수정·내 리뷰·설정)는 바텀 nav를 아래로 내린 채 연다.
  // 돌아오면 다시 올라온다. (pushHidingNavBar 참고)
  void _push(BuildContext context, Widget screen) =>
      pushHidingNavBar<void>(context, screen);

  void _openSaved(WidgetRef ref) =>
      ref.read(tabSwitchRequestProvider.notifier).request(_kSavedTabIndex);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider(uid)).value;
    // 리뷰 수는 count 집계(목록 스트림 + 클럽 조인을 숫자 하나 때문에 안 연다).
    // 찜 수는 찜 탭과 **같은 목록**을 센다 — favorites 문서 수를 그대로 쓰면
    // 비활성 클럽이 섞여 탭 목록보다 큰 숫자가 된다. 카탈로그 캐시 조인이라 read 0.
    final reviewCount = ref.watch(myReviewCountProvider).value;
    final savedCount = ref.watch(
      savedClubsProvider.select((s) => s.value?.length),
    );
    // 안 본 답변 수 — 고객센터 목록 스트림에서 세므로 추가 조회가 없다.
    final unreadAnswers = ref.watch(unreadAnswerCountProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        kMyPagePad.w,
        MediaQuery.paddingOf(context).top + kMySectionGap.h,
        kMyPagePad.w,
        // 하단 floating nav 바에 가리지 않도록 확보하는 여백.
        130.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VybeFadeInUp(
            index: 0,
            child: user == null
                ? const MyPageProfileSkeleton()
                : MyPageProfile(
                    // 표시 이름은 닉네임이다 — user.name 은 실명(본인인증 원본)이라
                    // 화면에 띄우지 않는다. 아직 배정 전이면 중립 라벨.
                    nickname: user.nickname,
                    imageUrl: user.profileImageUrl,
                    subtitle: providerJoinLabel(user.provider),
                    onEdit: () => _push(context, ProfileEditScreen(user: user)),
                  ),
          ),
          SizedBox(height: kMySectionGap.h),

          VybeFadeInUp(
            index: 1,
            child: MyPageStats(
              reviewCount: reviewCount,
              savedCount: savedCount,
              onReviews: () => _push(context, const MyReviewsScreen()),
              onSaved: () => _openSaved(ref),
            ),
          ),
          SizedBox(height: kMySectionGap.h),

          VybeFadeInUp(
            index: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RenewSectionHead(title: '내 활동'),
                MyMenuRow(
                  icon: RenewIcons.review,
                  label: '내 리뷰 관리',
                  value: reviewCount?.toString(),
                  onTap: () => _push(context, const MyReviewsScreen()),
                ),
                MyMenuRow(
                  icon: RenewIcons.heart,
                  label: '찜한 클럽',
                  value: savedCount?.toString(),
                  onTap: () => _openSaved(ref),
                  last: true,
                ),
              ],
            ),
          ),
          SizedBox(height: kMySectionGap.h),

          VybeFadeInUp(
            index: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RenewSectionHead(title: '계정'),
                MyMenuRow(
                  icon: RenewIcons.bell,
                  label: '알림',
                  onTap: () => VybeToast.show(context, message: '알림은 준비 중이에요'),
                ),
                MyMenuRow(
                  icon: RenewIcons.mega,
                  label: '공지사항',
                  onTap: () => _push(context, const NoticesScreen()),
                ),
                MyMenuRow(
                  icon: RenewIcons.review,
                  label: '고객센터 · 문의',
                  // 안 본 답변 수. 푸시가 없어 **이 값이 답변 도착을 알리는
                  // 유일한 경로**다(목록 카드의 점과 짝).
                  value: unreadAnswers > 0 ? '답변 $unreadAnswers' : null,
                  onTap: () => _push(context, const SupportScreen()),
                ),
                MyMenuRow(
                  icon: RenewIcons.gear,
                  label: '설정',
                  onTap: () => _push(context, const SettingsScreen()),
                ),
                // 회원 탈퇴는 설정 화면 하단 '탈퇴하기' 링크로만 진입한다 —
                // 되돌릴 수 없는 동작이라 마이페이지 메뉴에 노출하지 않는다.
                MyMenuRow(
                  icon: RenewIcons.logout,
                  label: '로그아웃',
                  danger: true,
                  last: true,
                  onTap: () => _confirmLogout(context, ref),
                ),
              ],
            ),
          ),
          SizedBox(height: kMySectionGap.h),

          const AppVersionLabel(),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    // 다이얼로그는 루트 Navigator에 떠서 스크림이 floating 바텀 nav까지 덮는다
    // → 예전 바텀시트처럼 nav를 따로 내렸다 올릴 필요가 없다.
    final confirmed = await VybeConfirmDialog.show(
      context,
      title: '로그아웃할까요?',
      message: '언제든 다시 로그인할 수 있어요.',
      confirmLabel: '로그아웃',
    );
    if (!confirmed) return;

    // 로그아웃하면 AuthGate가 루트를 WelcomeScreen으로 교체하고
    // 그 위에 쌓인 라우트를 전부 정리한다.
    await ref.read(authViewModelProvider.notifier).signOut();
  }
}
