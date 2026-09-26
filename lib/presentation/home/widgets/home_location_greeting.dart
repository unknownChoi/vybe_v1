import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/core/utils/nickname.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/location_flip_mixin.dart';
import 'package:vybe/presentation/common/widgets/vybe_location_chip.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/profile/viewmodels/user_viewmodel.dart';

class HomeLocationGreeting extends ConsumerStatefulWidget {
  const HomeLocationGreeting({super.key});

  @override
  ConsumerState<HomeLocationGreeting> createState() =>
      _HomeLocationGreetingState();
}

class _HomeLocationGreetingState extends ConsumerState<HomeLocationGreeting>
    with SingleTickerProviderStateMixin, LocationFlipMixin {
  // 위치 칩 탭 → 핀 플립 연출을 돌리는 동안 기기 GPS를 다시 읽는다.
  // 라벨은 userLocationProvider가 그리므로 여기서 대입할 상태가 없다.
  void _onLocationTap() {
    unawaited(ref.read(userLocationProvider.notifier).resolveFromDevice());
    runLocationFlip(onResolved: () {});
  }

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
      loading: locLoading,
      flip: flip,
      onTap: _onLocationTap,
      margin: EdgeInsets.only(bottom: 12.h),
    );
  }
}
