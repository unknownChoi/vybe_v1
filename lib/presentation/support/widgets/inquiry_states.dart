import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

/// 고객센터 목록의 로딩·오류·빈 상태 (디자인 `SupListScreen` 빈 상태).

class InquiriesSkeleton extends StatelessWidget {
  const InquiriesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RenewGlass.pagePad.w),
      child: Column(
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) SizedBox(height: 12.h),
            const _SkeletonCard(),
          ],
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return RenewGlassCard(
      quiet: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VybeSkel(width: 56.w, height: 20.h),
              const Spacer(),
              VybeSkel(width: 66.w, height: 20.h, radius: 999),
            ],
          ),
          SizedBox(height: 13.h),
          VybeSkel(widthFactor: 0.86, height: 14.h),
          SizedBox(height: 9.h),
          VybeSkel(widthFactor: 0.42, height: 11.h),
        ],
      ),
    );
  }
}

/// 빈 상태 / 비로그인 안내 (디자인 — 카드로 감싸지 않고 아이콘 타일 + 두 줄).
class InquiriesEmpty extends StatelessWidget {
  /// [RenewIcons] 패스.
  final String icon;
  final String title;
  final String description;

  const InquiriesEmpty({
    super.key,
    this.icon = RenewIcons.headset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 74.h, horizontal: 20.w),
      child: Column(
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x337731FE), // rgba(119,49,254,0.20)
              borderRadius: BorderRadius.circular(19.r),
              border: Border.all(
                color: const Color(0x6B7731FE), // rgba(119,49,254,0.42)
              ),
            ),
            child: RenewIcon(
              path: icon,
              size: 25,
              color: RenewGlass.lavender,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: VybeTypography.body3.copyWith(
              color: RenewGlass.t1,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: VybeTypography.body4.copyWith(
              color: RenewGlass.t4,
              height: 20 / 14,
            ),
          ),
        ],
      ),
    );
  }
}
