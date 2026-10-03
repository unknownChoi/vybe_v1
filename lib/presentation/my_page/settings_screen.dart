import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/storage/local_prefs.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/repositories/user_repository_impl.dart';
import 'package:vybe/presentation/auth/terms/legal_documents.dart';
import 'package:vybe/presentation/auth/viewmodels/auth_viewmodel.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_toast.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_hide_route.dart';
import 'package:vybe/presentation/my_page/account_delete_screen.dart';
import 'package:vybe/presentation/my_page/legal_screen.dart';
import 'package:vybe/presentation/my_page/my_info_screen.dart';
import 'package:vybe/presentation/my_page/viewmodels/settings_viewmodel.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';
import 'package:vybe/presentation/my_page/widgets/settings_groups.dart';
import 'package:vybe/presentation/notifications/viewmodels/notification_viewmodel.dart';
import 'package:vybe/presentation/profile/viewmodels/user_viewmodel.dart';
import 'package:vybe/presentation/support/support_screen.dart';

// ============================================================
// 설정 — 리뉴얼 (my_renew.html · MRSettingsScreen)
//
// 알림 / 일반 / 데이터 / 계정 4개 그룹 + 안내 문구 + 탈퇴하기 + 버전.
// 행은 카드로 감싸지 않고 헤어라인으로만 나눈다(디자인 MRSetRow).
//
// 디자인과 다른 점
// - **알림·위치·사운드 토글은 로컬 상태만** — 베타 범위에 설정 서버 저장도,
//   푸시 연동도 없다. 저장해 두면 동작하지 않는 설정이 켜져 있는 것처럼 보인다.
//   ⚠ **'마케팅 · 홍보 알림'만 예외**로 서버(`users.agreements.marketing`)에
//   저장한다 — 그 값이 곧 가입 때 받은 **수신 동의**라서다. 가입 시 동의했으면
//   켜진 채로 시작하고, 여기서 끄면 동의 철회로 기록된다. 로컬로만 두면
//   약관·법적 고지가 약속한 '설정에서 언제든 해제'가 앱을 껐다 켜면 되살아난다.
// - **자동 로그인 유지**는 디자인에 없지만 실제 동작이 걸린 설정이라 남겼다.
//   유일하게 기기에 저장된다([LocalPrefs]).
// - **테마·언어**는 값 + 꺾쇠까지 디자인대로 그리되 고를 것이 하나뿐이라
//   탭하면 안내 토스트만 띄운다(빈 화면으로 보내지 않는다).
// - 디자인 '계정 삭제는 고객센터' 문구는 앱에 실제 탈퇴 기능이 있어 교체.
// ============================================================

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

/// 디자인 MRSettingsScreen 그룹 사이 간격.
const double _kGroupGap = 26;

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  /// 기기에도 서버에도 저장되지 않는 표시 전용 토글들.
  ///
  /// 설계 6-0 MY-029 — 「위치·사운드는 로컬」. 알림 토글 4종은
  /// `users.notificationSettings`([notificationSettingsProvider]) 로 옮겼고,
  /// 마케팅은 `agreements.marketing` 이라 둘 다 여기 없다.
  final Map<String, bool> _toggles = {'location': true, 'sound': true};
  bool _clearing = false;

  /// 마케팅 수신 토글을 방금 뒤집었을 때의 임시 표시값.
  ///
  /// null 이면 서버(`users.agreements.marketing`) 값을 그대로 보여준다.
  /// 쓰기가 끝나면(= 스트림이 새 값을 이미 내보낸 뒤) 다시 null 로 돌려
  /// **다른 기기에서 바뀐 값도 가려지지 않게** 한다.
  bool? _marketingOverride;

  /// 자동 로그인 유지 — 유일하게 기기에 저장되는 설정.
  /// 저장값을 읽어오기 전에는 기본값(켜짐)으로 그린다.
  bool _autoLogin = true;

  @override
  void initState() {
    super.initState();
    _loadAutoLogin();
  }

  Future<void> _loadAutoLogin() async {
    try {
      final prefs = await ref.read(localPrefsProvider.future);
      if (!mounted) return;
      setState(() => _autoLogin = prefs.autoLogin);
    } catch (_) {
      // 저장소를 못 열면 기본값(켜짐) 그대로 — 앱 시작 판정도 같은 기본값을 쓴다.
    }
  }

  Future<void> _toggleAutoLogin() async {
    final next = !_autoLogin;
    setState(() => _autoLogin = next);
    try {
      final prefs = await ref.read(localPrefsProvider.future);
      await prefs.setAutoLogin(next);
    } catch (_) {
      if (!mounted) return;
      setState(() => _autoLogin = !next); // 저장 실패 → 화면도 되돌린다
    }
  }

  void _toggle(String key) =>
      setState(() => _toggles[key] = !(_toggles[key] ?? false));

  /// 알림 토글 4종 — 서버에 저장한다(설계 6-0 `updateNotificationSettings`).
  ///
  /// 되돌리기·낙관적 표시는 ViewModel 이 맡고 화면은 실패 안내만 띄운다.
  Future<void> _toggleNotification(String? uid, String key) async {
    if (uid == null) {
      VybeToast.show(context, message: '로그인 후 변경할 수 있어요');
      return;
    }
    final ok = await ref
        .read(notificationSettingsProvider.notifier)
        .toggle(key);
    if (!ok && mounted) {
      VybeToast.show(context, message: '설정을 저장하지 못했어요');
    }
  }

  /// 마케팅 수신 동의 켬/끔 — 서버에 기록한다(= 동의/철회).
  ///
  /// 표시를 먼저 뒤집고 쓰기가 실패하면 되돌린다([_toggleAutoLogin] 과 같은 방식).
  /// 실패를 조용히 넘기면 껐다고 생각한 사용자에게 계속 광고가 나간다.
  Future<void> _toggleMarketing(String? uid, bool current) async {
    if (uid == null) {
      VybeToast.show(context, message: '로그인 후 변경할 수 있어요');
      return;
    }
    final next = !current;
    setState(() => _marketingOverride = next);
    try {
      await ref
          .read(userRepositoryProvider)
          .setAgreement(
            uid: uid,
            key: kMarketingToggleKey,
            agreed: next,
            version: LegalDoc.marketing.version,
          );
      // 스트림이 이미 새 값을 내보낸 뒤라 되돌려도 화면은 그대로다.
      if (mounted) setState(() => _marketingOverride = null);
    } catch (_) {
      if (!mounted) return;
      setState(() => _marketingOverride = null); // 서버 값으로 복귀
      VybeToast.show(context, message: '설정을 저장하지 못했어요');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUidProvider);
    // 가입 때 마케팅 약관에 동의했으면 켜진 채로 시작한다.
    // 기록 자체가 없는(동의 기록 도입 전 가입) 유저는 꺼짐.
    final agreedMarketing = uid == null
        ? false
        : ref
                  .watch(currentUserProvider(uid))
                  .value
                  ?.agreements[kMarketingToggleKey]
                  ?.agreed ??
              false;
    final marketingOn = _marketingOverride ?? agreedMarketing;
    // 조회 전·실패는 설계 4장 기본값(전부 true)으로 그린다 —
    // 토글 줄을 스켈레톤으로 비우면 설정 화면이 열릴 때마다 흔들린다.
    final notiSettings =
        ref.watch(notificationSettingsProvider).value ??
        const NotificationSettings();

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VybePushHeader(title: '설정'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    kMyPagePad.w,
                    18.h,
                    kMyPagePad.w,
                    40.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 디자인 순서 — 내 정보 · 알림 · 일반 · 데이터 · 계정.
                      SettingsMyInfoGroup(onMyInfo: _openMyInfo),
                      SizedBox(height: _kGroupGap.h),
                      SettingsNotificationGroup(
                        // 알림 4종은 서버(users.notificationSettings),
                        // 마케팅은 동의 기록(agreements.marketing) 에서 온다.
                        // 그룹 위젯은 값이 어디서 왔는지 모른 채 키로만 그린다.
                        toggles: {
                          ...notiSettings.toMap(),
                          kMarketingToggleKey: marketingOn,
                        },
                        onToggle: (key) => key == kMarketingToggleKey
                            ? _toggleMarketing(uid, marketingOn)
                            : _toggleNotification(uid, key),
                      ),
                      SizedBox(height: _kGroupGap.h),
                      SettingsGeneralGroup(
                        autoLogin: _autoLogin,
                        onToggleAutoLogin: _toggleAutoLogin,
                        toggles: _toggles,
                        onToggle: _toggle,
                        onThemeTap: () =>
                            VybeToast.show(context, message: '지금은 다크 테마만 지원해요'),
                        onLanguageTap: () =>
                            VybeToast.show(context, message: '지금은 한국어만 지원해요'),
                      ),
                      SizedBox(height: _kGroupGap.h),
                      SettingsDataGroup(
                        cacheLabel: _cacheLabel(),
                        clearing: _clearing,
                        onClear: _clearCache,
                      ),
                      SizedBox(height: _kGroupGap.h),
                      SettingsAccountGroup(
                        onSupport: _openSupport,
                        onLegal: _openLegal,
                        onLogout: _logout,
                      ),
                      SizedBox(height: _kGroupGap.h),
                      const RenewFooterNote(
                        text:
                            '탈퇴하면 작성한 리뷰·사진은 바로 숨겨지고 30일 뒤 완전히 삭제돼요. '
                            '데이터 이관은 고객센터를 통해 처리돼요.',
                      ),
                      SizedBox(height: 18.h),
                      SettingsLeaveLink(
                        onTap: () => pushHidingNavBar<void>(
                          context,
                          const AccountDeleteScreen(),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      const AppVersionLabel(),
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

  /// 캐시 용량 문구. 순회 중에는 숫자 대신 상태를 그대로 쓴다
  /// ('계산 중… 사용 중'처럼 붙어 읽히지 않게 문장 전체를 갈아 끼운다).
  String _cacheLabel() => ref
      .watch(cacheManagerProvider)
      .when(
        data: (bytes) => '${formatCacheSize(bytes)} 사용 중',
        loading: () => '용량 계산 중…',
        error: (_, __) => '용량을 확인할 수 없어요',
      );

  /// 약관·정책은 '이용약관' 목록 화면 한 곳에서 본다.
  void _openLegal() => pushHidingNavBar<void>(context, const LegalScreen());

  void _openSupport() =>
      pushHidingNavBar<void>(context, const SupportScreen());

  /// 가입 정보(읽기 전용) — MY-029 '내 정보'.
  void _openMyInfo() => pushHidingNavBar<void>(context, const MyInfoScreen());

  // ============ 동작 ============

  Future<void> _clearCache() async {
    if (_clearing) return;
    setState(() => _clearing = true);
    try {
      await ref.read(cacheManagerProvider.notifier).clearCache();
      if (!mounted) return;
      VybeToast.show(context, message: '캐시를 삭제했어요');
    } finally {
      if (mounted) setState(() => _clearing = false);
    }
  }

  // 디자인 MY-029 로그아웃 행은 확인 없이 로그인 화면으로 간다 —
  // 확인 다이얼로그는 되돌릴 수 없는 탈퇴 쪽에만 둔다
  // (설계 6-X MY-029 위젯 칸 '— / 1' = 다이얼로그 하나).
  //
  // 로그아웃하면 AuthGate가 루트를 WelcomeScreen으로 교체하고
  // 그 위에 쌓인 라우트(이 화면 포함)를 전부 정리한다.
  Future<void> _logout() =>
      ref.read(authViewModelProvider.notifier).signOut();
}
