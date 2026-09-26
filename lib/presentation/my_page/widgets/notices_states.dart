import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/my_page/widgets/notice_glass.dart';

/// 공지 목록 로딩 스켈레톤. 빈 상태·오류 문구는 공용 `VybeEmptyCard`·`VybeStateMessage`.

/// 목록 로딩 스켈레톤 — 실제 카드와 같은 유리 껍데기 위에 shimmer 블록.
/// 로딩 → 목록 전환에서 레이아웃이 튀지 않도록 카드 높이를 맞춘다.
class NoticesSkeleton extends StatelessWidget {
  const NoticesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
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
      radius: kNoticeCardRadius,
      padding: kNoticeCardPad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 배지 행 (카테고리 pill + 날짜).
          Row(
            children: [
              VybeSkel(width: 52.w, height: 20.h, radius: 999),
              const Spacer(),
              VybeSkel(width: 60.w, height: 12.h),
            ],
          ),
          SizedBox(height: 11.h),
          // 제목 + 미리보기 한 줄.
          VybeSkel(widthFactor: 0.72, height: 14.h),
          SizedBox(height: 8.h),
          VybeSkel(widthFactor: 0.92, height: 11.h),
        ],
      ),
    );
  }
}
