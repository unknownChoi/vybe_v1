import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/edm/edm_models.dart';
import 'package:vybe/presentation/edm/widgets/edm_equalizer.dart';

// EDM 페이지 전용 조각.
//
// ⚠ 섹션 헤더 · 우측 액션 pill · 필터 칩 줄은 K-POP 페이지가 같이 쓰게 되면서
// `common/widgets/vybe_section_head.dart` 로 승격했다
// ([VybeSectionHead] · [VybeHeadAction] · [VybeChipRow]).

/// 지역 필터 항목 — 디자인(edm_renew.jsx `AREAS`) 그대로.
const kEdmAreas = ['추천순', '홍대', '강남', '압구정', '이태원', '건대'];

/// 섹션 헤더 우측 라임 pill — '지금 몇 곳에서 돌고 있나'.
///
/// 디자인(edm_renew_v1.jsx `Schedule`)의 `{n}곳 플레이 중`. 라임은 NOW 마커와
/// 같은 색 — 두 표시가 같은 사실('지금')을 말하므로 색도 같아야 한다.
///
/// ⚠ 세는 단위는 **공연이 아니라 클럽**이다. 라벨이 '곳'이라 진행 중인 셋 수를
/// 그대로 쓰면 한 클럽에서 두 셋이 겹칠 때 2곳이라고 말하게 된다.
class EdmLivePill extends StatelessWidget {
  final int count;
  const EdmLivePill({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kEdmHot.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(color: kEdmHot.withValues(alpha: 0.42)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const EdmEqualizer(color: kEdmHot, size: 11, bars: 3),
          SizedBox(width: 6.w),
          Text(
            '$count곳 플레이 중',
            style: VybeTypography.caption.copyWith(
              height: 14 / 12,
              fontWeight: FontWeight.w700,
              color: kEdmHot,
            ),
          ),
        ],
      ),
    );
  }
}
