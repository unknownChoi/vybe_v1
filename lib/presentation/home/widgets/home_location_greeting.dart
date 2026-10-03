import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/core/utils/nickname.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/widgets/vybe_location_chip.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/profile/viewmodels/user_viewmodel.dart';

class HomeLocationGreeting extends ConsumerStatefulWidget {
  const HomeLocationGreeting({super.key});

  @override
  ConsumerState<HomeLocationGreeting> createState() =>
      _HomeLocationGreetingState();
}

class _HomeLocationGreetingState extends ConsumerState<HomeLocationGreeting> {
  // 위치 칩 탭 → **주변 탭(PLACE-019)으로 전환**.
  //
  // 디자인 LocationGreeting 의 칩은 `<a href="[v1]PLACE-019.html">` 로 통째가
  // 주변 지도 링크다(아래 꺾쇠가 그 표시). 예전처럼 그 자리에서 GPS 를 다시
  // 읽으면 꺾쇠가 거짓말이 되고, 눌러도 같은 화면에 라벨만 깜빡인다.
  //
  // ⚠ GPS 조회는 앱 시작(`SplashGate`)에서 이미 끝난다 — 홈이 뜨는 시점엔
  // 좌표가 있어서 여기서 다시 읽을 것이 없다.
  //
  // ⚠ 그래서 칩의 핀 플립 로딩 연출(`LocationFlipMixin`)도 여기선 안 돈다 —
  // 칩은 `loading: false` 로만 그린다. 믹스인·`flip` 파라미터는 위치를 화면에서
  // 다시 읽는 자리(주변 탭)가 생길 때를 위해 칩 쪽에 남겨 둔다.
  void _onLocationTap() =>
      ref.read(tabSwitchRequestProvider.notifier).request(1);

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUidProvider);
    // 인사말도 닉네임으로 부른다 — `users.name` 은 본인인증으로 받은 실명이라
    // 화면에 띄우지 않는다(실명이면 '성 떼기'가 필요했지만 닉네임엔 성이 없다).
    // 닉네임 하나에 users 문서 전체를 구독하지 않는다(select) — 사진·약관이
    // 바뀌어도 여기는 다시 그리지 않는다.
    final (loading, nickname) = uid == null
        ? (false, '')
        : ref.watch(
            currentUserProvider(uid).select(
              (a) => (a.isLoading && !a.hasValue, a.value?.nickname ?? ''),
            ),
          );
    final name = uid == null
        ? '게스트'
        : (nickname.isEmpty ? kNicknameFallback : nickname);

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 6.h, 24.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationChip(),
          // 첫 스냅샷 전엔 게이트 스켈레톤(_GreetingSkeleton)과 같은 두 줄 —
          // 'VYBER님' 을 먼저 찍었다가 닉네임으로 갈아 끼우면 글자가 튄다.
          if (loading) ...[
            // 26 + 12 + 26 = 64 = 실제 텍스트 2줄(32.sp × 2) — 단위·합이 같아야
            // 닉네임이 오는 순간 아래 배너·그리드가 안 튄다.
            VybeSkel(width: 200.w, height: 26.sp, radius: 8),
            SizedBox(height: 12.sp),
            VybeSkel(width: 150.w, height: 26.sp, radius: 8),
          ] else
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 26.sp,
                  height: 32 / 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 26 * -0.025,
                ),
                children: [
                  TextSpan(text: '오늘 밤, $name님은\n어디서 '),
                  const TextSpan(
                    text: '놀까요?',
                    style: TextStyle(color: VybeColors.mainLime500),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 위치 칩 — 공통 위젯 (VybeLocationChip). 라벨만 여기서 정한다.
  Widget _buildLocationChip() {
    // 라벨 = 지금 내 좌표가 속한 지역(예: '강남'). 등록된 지역 밖이면 '내 주변'.
    final locationLabel = ref.watch(userLocationProvider).areaLabel;

    return VybeLocationChip(
      label: locationLabel,
      loading: false,
      flip: kAlwaysDismissedAnimation,
      onTap: _onLocationTap,
      // 디자인 I.ChevDown — 누르면 주변 지도로 간다는 표시.
      chevron: true,
      margin: EdgeInsets.only(bottom: 12.h),
    );
  }
}
