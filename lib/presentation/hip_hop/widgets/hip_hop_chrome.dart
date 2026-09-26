import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/hip_hop/hip_hop_style.dart';

// 힙합 페이지 전용 조각 — 섹션 헤더 우측 링크 · 안내 카드.
//
// ⚠ 섹션 헤더 · 지역 칩 줄은 공용 [VybeSectionHead] · [VybeChipRow]
// (`common/widgets/vybe_section_head.dart`) 를 쓴다.

/// 섹션 헤더 우측 `전체 ›` — 오늘의 라인업 전체 보기.
class HipHopSeeAll extends StatelessWidget {
  final VoidCallback onTap;
  const HipHopSeeAll({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '전체',
            style: VybeTypography.caption.copyWith(
              height: 14 / 12,
              fontWeight: FontWeight.w600,
              color: VybeColors.gray500,
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 14.r,
            color: VybeColors.gray500,
          ),
        ],
      ),
    );
  }
}

/// 라인업 변경 안내 카드.
class HipHopNoticeCard extends StatelessWidget {
  const HipHopNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: VybeColors.gray900,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: VybeColors.gray800),
      ),
      child: Row(
        children: [
          Icon(Icons.album_outlined, size: 15.r, color: kHipAccent),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              '공연 라인업은 당일 사정에 따라 변경될 수 있어요. 방문 전 확인해 주세요.',
              style: VybeTypography.caption.copyWith(
                height: 17 / 12,
                color: VybeColors.gray400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
