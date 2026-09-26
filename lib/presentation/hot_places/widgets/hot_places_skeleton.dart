import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/widgets/vybe_image_hero.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

// 핫플레이스 로딩 스켈레톤.

// ── 스켈레톤 ──
class HotPlacesSkeleton extends StatelessWidget {
  const HotPlacesSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      // ⚠ padding 미지정이면 safe-area(상태바)가 top padding으로 **자동 주입**돼
      // 히어로 위에 빈 띠가 생긴다 — 로딩 1.3초 동안만 앱바 자리가 비어 보인다.
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // 인트로 히어로는 로컬 asset이라 즉시 그려진다 — 셔머로 대체하면
        // 데이터가 도착하는 순간 같은 자리가 한 번 깜빡인다.
        const VybeImageHero('hot_places', heroAspect: 786 / 760),
        SizedBox(height: 8.h), // 화면(hot_places_screen)과 같은 값
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
          child: Row(
            children: [
              for (final w in [52.0, 60.0, 60.0, 70.0, 56.0]) ...[
                VybeSkel(width: w.w, height: 34.h, radius: 999),
                SizedBox(width: 8.w),
              ],
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 58, child: VybeSkel(height: 188.h, radius: 16)),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 42,
                  child: Column(
                    children: [
                      VybeSkel(height: 89.h, radius: 16),
                      SizedBox(height: 10.h),
                      VybeSkel(height: 89.h, radius: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        for (var i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Row(
              children: [
                VybeSkel(width: 20.w, height: 20.h, radius: 6),
                SizedBox(width: 13.w),
                VybeSkel(width: 72.w, height: 72.h, radius: 12),
                SizedBox(width: 13.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VybeSkel(widthFactor: 0.45, height: 14.h, radius: 6),
                      SizedBox(height: 9.h),
                      VybeSkel(widthFactor: 0.75, height: 11.h, radius: 6),
                      SizedBox(height: 9.h),
                      VybeSkel(widthFactor: 1, height: 5.h, radius: 99),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
