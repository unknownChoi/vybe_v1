import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/widgets/vybe_image_hero.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

// VYBE 추천 로딩 · 빈 목록 · 오류 상태.

// ── 빈 · 오류 상태 ──
/// 가운데 아이콘 + 한 줄 문구. 빈 목록·조회 실패가 아이콘·문구만 다르다.
class RecommendStateView extends StatelessWidget {
  final IconData icon;
  final String text;

  const RecommendStateView({super.key, required this.icon, required this.text});

  const RecommendStateView.empty({super.key})
    : icon = Icons.auto_awesome,
      text = '이번 주 추천이 아직 준비 중이에요';

  const RecommendStateView.error({super.key})
    : icon = Icons.error_outline_rounded,
      text = '추천을 불러오지 못했어요';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36.r, color: VybeColors.gray700),
            SizedBox(height: 14.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style: VybeTypography.body3.copyWith(color: VybeColors.gray400),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 스켈레톤 ──
class RecommendSkeleton extends StatelessWidget {
  const RecommendSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인트로 히어로는 로컬 asset이라 즉시 그려진다 — 셔머로 대체하면
          // 데이터가 도착하는 순간 같은 자리가 한 번 깜빡인다.
          const VybeImageHero('recommend', heroAspect: 786 / 902),
          SizedBox(height: 16.h), // 화면(vybe_recommend_screen)과 같은 값
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: Column(
              children: [
                VybeSkel(width: double.infinity, height: 230.h, radius: 20),
                SizedBox(height: 16.h),
                VybeSkel(width: double.infinity, height: 14.h, radius: 6),
                SizedBox(height: 12.h),
                VybeSkel(width: double.infinity, height: 46.h, radius: 13),
              ],
            ),
          ),
          for (var i = 0; i < 3; i++)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VybeSkel(width: 22.w, height: 24.h, radius: 6),
                  SizedBox(width: 14.w),
                  VybeSkel(width: 84.r, height: 84.r, radius: 12),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VybeSkel(width: 120.w, height: 14.h, radius: 6),
                        SizedBox(height: 9.h),
                        VybeSkel(width: 180.w, height: 11.h, radius: 6),
                        SizedBox(height: 9.h),
                        VybeSkel(width: 240.w, height: 11.h, radius: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
