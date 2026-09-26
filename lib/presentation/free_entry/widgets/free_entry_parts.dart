import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_meta_dot.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/free_entry/free_entry_style.dart';

// 입장비 무료 리뉴얼 화면 공용 조각 (디자인 `free_entry_renew_parts.jsx`).
// 두 섹션 이상이 쓰는 것만 여기 둔다 — 인트로·카운트다운 같은 한 곳짜리는 제 자리에.

/// 카드 사진 자리 — 그라데이션 폴백 + 썸네일 + 하단 스크림.
/// 카드가 사진을 모서리까지 채우므로 클립은 카드([RenewGlassCard])가 맡는다.
class FreeEntryImage extends StatelessWidget {
  final String url;
  final List<Color> gradient;
  final double height;
  final List<Widget> children;

  const FreeEntryImage({
    super.key,
    required this.url,
    required this.gradient,
    required this.height,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
            ),
          ),
          if (url.isNotEmpty)
            SkeletonImage(
              url: url,
              fit: BoxFit.cover,
              minSkeleton: const Duration(seconds: 1),
            ),
          // linear-gradient(to top, rgba(14,13,18,0.94) 14%, 0.22 58%, transparent 82%)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xF00E0D12),
                  Color(0x380E0D12),
                  Colors.transparent,
                ],
                stops: [0.14, 0.58, 0.82],
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

/// 사진 위 '지금 무료' 퍼플 pill (FeFreeBadge) — 채운 퍼플 + 글로우.
class FreeEntryBadge extends StatelessWidget {
  final String label;

  const FreeEntryBadge({super.key, this.label = '지금 무료'});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      decoration: BoxDecoration(
        color: kEntryBase,
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(color: kEntryLavender.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: kEntryBase.withValues(alpha: 0.42),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 12.r,
            color: Colors.white,
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: RenewGlass.caption(
              color: Colors.white,
              size: 10.5,
              lineHeight: 11,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// 이름 옆 작은 영업 pill (FeOpen) — 라임 점 + '영업 중' / 회색 '종료'.
class FreeEntryOpenPill extends StatelessWidget {
  final bool open;
  const FreeEntryOpenPill({super.key, required this.open});

  @override
  Widget build(BuildContext context) {
    final fg = open ? kEntryPoint : RenewGlass.t3;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: RenewGlass.barFill,
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(
          color: open ? kEntryPointLine : const Color(0x24FFFFFF),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              color: open ? kEntryPoint : const Color(0x80FFFFFF),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            open ? '영업 중' : '종료',
            style: RenewGlass.caption(
              color: fg,
              size: 10,
              lineHeight: 11,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// `홍대 · 0.4km  ·  힙합` 점 구분 메타 줄 (FeMeta) — 공용 [RenewMetaRow] 에
/// 이 화면 글자·점만 준 것. [size] 11.5 / 11 두 곳.
Widget freeEntryMeta(List<String> items, {double size = 11.5}) => RenewMetaRow(
  items: items,
  style: RenewGlass.caption(
    color: RenewGlass.t3,
    size: size,
    lineHeight: 14,
    weight: FontWeight.w600,
  ),
  dot: const VybeMetaDot(gap: 0, size: 2.5, color: Color(0x4DFFFFFF)),
  gap: 5,
);

/// 라임 별 + 평점 (`★ 4.58`).
class FreeEntryRating extends StatelessWidget {
  final double rating;
  final double size;
  const FreeEntryRating({super.key, required this.rating, this.size = 11});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: (size + 3).r, color: kEntryPoint),
        SizedBox(width: 3.w),
        Text(
          rating.toStringAsFixed(2),
          style: RenewGlass.caption(
            color: Colors.white,
            size: size,
            lineHeight: size + 1,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// 가로 스크롤 카드 레일 — 좌우 16 여백, 카드 사이 [gap].
/// `ListView.builder` 라 보이는 카드만 만든다(글래스 블러가 카드마다 붙는다).
class FreeEntryRail extends StatelessWidget {
  final double height;
  final double gap;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const FreeEntryRail({
    super.key,
    required this.height,
    required this.gap,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        clipBehavior: Clip.none,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(width: gap.w),
        itemBuilder: itemBuilder,
      ),
    );
  }
}

/// 첫 로딩 스켈레톤 (FeSkeleton) — 히어로 아래 카드 레일 + 지도 자리.
class FreeEntrySkeleton extends StatelessWidget {
  const FreeEntrySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VybeSkel(width: 188.w, height: 20.h),
          SizedBox(height: 16.h),
          // 두 장째는 화면 밖으로 넘친다(디자인 overflow hidden) — Row 면 오버플로 경고.
          SizedBox(
            height: 250.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                VybeSkel(width: 262.w, height: 250.h, radius: 20, logo: true),
                SizedBox(width: 11.w),
                VybeSkel(width: 262.w, height: 250.h, radius: 20, logo: true),
              ],
            ),
          ),
          SizedBox(height: 34.h),
          VybeSkel(width: 150.w, height: 20.h),
          SizedBox(height: 16.h),
          VybeSkel(height: 260.h, radius: 20, logo: true),
        ],
      ),
    );
  }
}
