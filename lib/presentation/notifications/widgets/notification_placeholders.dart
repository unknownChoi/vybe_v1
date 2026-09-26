import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/notifications/widgets/noti_glass.dart';

/// 목록 로딩 스켈레톤 (디자인 NGSkeleton) — 섹션 라벨 + 카드 4장.
class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 20.h, 4.w, 10.h),
            child: VybeSkel(width: 54.w, height: 12.h),
          ),
          for (var i = 0; i < 4; i++) ...[
            if (i > 0) SizedBox(height: 10.h),
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
      radius: NotiGlass.cardRadius,
      padding: NotiGlass.cardPad,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VybeSkel(width: 44.r, height: 44.r, radius: 14),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목 한 줄 + 본문 두 줄.
                  VybeSkel(widthFactor: 0.62, height: 13.h),
                  SizedBox(height: 8.h),
                  VybeSkel(widthFactor: 0.92, height: 10.h),
                  SizedBox(height: 8.h),
                  VybeSkel(widthFactor: 0.45, height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
