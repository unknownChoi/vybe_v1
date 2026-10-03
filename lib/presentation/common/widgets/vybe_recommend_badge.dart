import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/design_system/colors.dart';

/// VYBE 추천 클럽 뱃지 — 앱 전역 단일 디자인.
///
/// 기준 디자인은 주변 탭 리스트 카드 뱃지(라임 14% 배경 + 라임 28% 테두리 pill).
/// 화면마다 [size]로 크기만 조절하고 색·모양·문구는 바꾸지 않는다.
///
/// 라벨은 `VybeTypography.caption`(12sp·행간 24)과 크기·행간이 달라 그대로 못 쓰고
/// 뱃지 전용 TextStyle을 직접 정의한다.
class VybeRecommendBadge extends StatelessWidget {
  /// 아래 수치들의 기준 라벨 크기(sp). [size]가 달라지면 같은 비율로 스케일된다.
  static const _baseSize = 11.0;
  static const _basePadH = 8.0;
  static const _basePadV = 3.0;
  static const _baseGap = 3.0;
  static const _baseLineHeight = 14.0;

  /// 라벨 폰트 크기(sp). 아이콘·패딩·간격이 여기에 비례한다.
  final double size;

  /// 뱃지 문구. 기본은 앱 전역에서 쓰던 'VYBE 추천 클럽'.
  ///
  /// ⚠ 디자인은 **자리에 따라 길이를 나눈다** — 사진 위에 올리는 짧은 자리(찜 카드 ·
  /// 지도 핀 카드)는 'VYBE 추천', 목록 카드는 'VYBE 추천 클럽'. 기본값을 바꾸면
  /// 같은 뱃지를 쓰는 다른 화면이 전부 따라 바뀌므로 **쓰는 쪽에서 넘긴다**.
  final String label;

  /// 라임 **단색 리본** 변형 — 검색 결과 카드 좌상단
  /// (디자인 `search_results_v2.jsx:229-239`). 기본 false 는 라임 14% 틴트 알약
  /// (찜 · 지도 핀 · 주변 · 금연 카드)이라 다른 화면은 그대로다.
  final bool solid;

  const VybeRecommendBadge({
    super.key,
    this.size = _baseSize,
    this.label = 'VYBE 추천 클럽',
    this.solid = false,
  });

  /// 기준 크기(11sp) 기준 수치를 현재 [size]에 맞게 환산.
  double _scaled(double base) => size * base / _baseSize;

  @override
  Widget build(BuildContext context) {
    // 리본은 잉크 글자 + 라임 글로우, 알약은 라임 글자 + 라임 틴트.
    final ink = solid ? VybeColors.background : VybeColors.mainLime500;
    return Container(
      padding: solid
          // 디자인 '6px 11px 6px 9px' — 아이콘 쪽이 좁다.
          ? EdgeInsets.fromLTRB(9.w, 6.h, 11.w, 6.h)
          : EdgeInsets.symmetric(
              horizontal: _scaled(_basePadH).w,
              vertical: _scaled(_basePadV).h,
            ),
      decoration: BoxDecoration(
        color: solid
            ? VybeColors.mainLime500
            : VybeColors.mainLime500.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(solid ? 10.r : 999.r),
        border: solid
            ? null
            : Border.all(
                color: VybeColors.mainLime500.withValues(alpha: 0.28),
              ),
        boxShadow: solid
            ? [
                BoxShadow(
                  color: VybeColors.mainLime500.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/common/club_card/vybe_recommend.svg',
            width: size.r,
            height: size.r,
            // SVG 가 라임을 박고 있어 리본에서는 잉크로 덮는다.
            colorFilter: solid
                ? ColorFilter.mode(ink, BlendMode.srcIn)
                : null,
          ),
          SizedBox(width: _scaled(_baseGap).w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: size.sp,
              height: _baseLineHeight / _baseSize,
              fontWeight: solid ? FontWeight.w800 : FontWeight.w700,
              color: ink,
            ),
          ),
        ],
      ),
    );
  }
}
