import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

// 검색 기본 화면 섹션 스켈레톤 — 헤드 한 줄 + 본문 골격. 실제 섹션과 같은 자리를
// 차지해서 데이터가 와도 아래가 튀지 않는다.

/// 인기 해시태그 — 헤드 + pill 6개 ([HashtagChip] 높이 ≈ 32).
class PopularHashtagsSkeleton extends StatelessWidget {
  const PopularHashtagsSkeleton({super.key});

  static const _widths = [72.0, 64.0, 88.0, 68.0, 80.0, 60.0];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Head(),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final w in _widths)
              VybeSkel(width: w.w, height: 32.h, radius: 999),
          ],
        ),
      ],
    );
  }
}

/// 실시간 인기 검색어 — 헤드 + r18 박스 안 2열 × 5줄 ([TrendRow] 높이 ≈ 36).
class TrendingSearchesSkeleton extends StatelessWidget {
  const TrendingSearchesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Head(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            border: Border.all(color: VybeColors.gray800),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: _Rows()),
              Container(
                width: 1,
                margin: EdgeInsets.symmetric(vertical: 6.h),
                color: VybeColors.gray800,
              ),
              const Expanded(child: _Rows()),
            ],
          ),
        ),
      ],
    );
  }
}

/// [SearchSectionHead] 자리 — 아이콘 + 제목 한 줄, 아래 16 간격.
class _Head extends StatelessWidget {
  const _Head();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: VybeSkel(width: 120.w, height: 18.h),
    );
  }
}

class _Rows extends StatelessWidget {
  const _Rows();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 5; i++)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 6.w),
            child: Row(
              children: [
                VybeSkel(width: 14.w, height: 14.h),
                SizedBox(width: 16.w),
                VybeSkel(width: (56 + (i * 17) % 40).w, height: 14.h),
              ],
            ),
          ),
      ],
    );
  }
}
