import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

/// 작은 둥근 클럽 썸네일 — 그라데이션 폴백 위에 사진([SkeletonImage]).
///
/// 지도 미니 카드(52 · r10 · gray800)와 입장비 무료 조건 레일(46 · r12 · hair)이
/// 같은 조각을 그린다. 테두리는 클립 위 [Container.foregroundDecoration] —
/// `decoration` 에 두면 코너 호에서 선이 죽는다(CLAUDE.md).
class VybeClubThumb extends StatelessWidget {
  final String url;
  final List<Color> gradient;

  /// 한 변 (`.r` 적용 전).
  final double size;
  final double radius;
  final Color border;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const VybeClubThumb({
    super.key,
    required this.url,
    required this.gradient,
    this.size = 52,
    this.radius = 10,
    this.border = VybeColors.gray800,
    this.begin = const Alignment(-0.5, -0.87),
    this.end = const Alignment(0.5, 0.87),
  });

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius.r);
    return Container(
      width: size.r,
      height: size.r,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: begin, end: end, colors: gradient),
        borderRadius: r,
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: r,
      ),
      child: url.isEmpty ? null : SkeletonImage(url: url, fit: BoxFit.cover),
    );
  }
}
