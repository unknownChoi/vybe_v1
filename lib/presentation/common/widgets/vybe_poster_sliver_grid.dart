import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

/// 포스터 카드 2열 격자 — 디자인의 columnGap 11 / rowGap 14 / 3:4 비율
/// (좌우 16). 반드시 `CustomScrollView.slivers` 안에 둔다.
///
/// 구 `GridView.count(shrinkWrap)` 판(`VybePosterGridLayout`, 2026.09.15 삭제)은
/// 바깥 `ListView` 안에서 카드를 전량 빌드·레이아웃했다(화면 밖 카드의 이미지
/// 디코드까지 한꺼번에 시작). sliver 로 두면 보이는 칸만 만든다.
class VybePosterSliverGrid extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// 기본 좌우 16.w.
  final EdgeInsetsGeometry? padding;

  const VybePosterSliverGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
  });

  static SliverGridDelegate get _delegate =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 11.w,
        childAspectRatio: 3 / 4,
      );

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverGrid.builder(
        gridDelegate: _delegate,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}

/// 격자 로딩 스켈레톤(sliver) — 카드는 사진 한 장이라 사진 자리 shimmer(로고 포함)로 깐다.
class VybePosterSliverGridSkeleton extends StatelessWidget {
  final int count;
  const VybePosterSliverGridSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) => VybePosterSliverGrid(
    itemCount: count,
    itemBuilder: (_, __) =>
        const VybeSkel(height: double.infinity, radius: 16, logo: true),
  );
}
