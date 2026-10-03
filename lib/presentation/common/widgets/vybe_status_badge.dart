import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/v1_tokens.dart';

/// 상태 배지 — 티켓 · 카드 · 헤더 · 시트 어디서나 상태 한 조각을 알약으로 말한다.
///
/// 디자인 `new_func_renew.css:121` `.v2badge`.
/// H~T 전 섹션에서 가장 많이 반복되는 조각이다(웨이팅 · 예약 · 주문 · 공유 · 환불).
///
/// ⚠ [VybeBadgeTone.error] 는 **결제 실패 · 시스템 오류 전용**이다.
/// 취소 · 거절은 [VybeBadgeTone.done] 을 쓴다(디자인 CSS 주석이 못 박은 규칙).
class VybeStatusBadge extends StatelessWidget {
  const VybeStatusBadge(
    this.label, {
    super.key,
    this.tone = VybeBadgeTone.neutral,
    this.dot = false,
  });

  final String label;
  final VybeBadgeTone tone;

  /// 앞에 5px 점을 찍는다(진행 중 상태 표시).
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: tone.fill,
        borderRadius: BorderRadius.circular(V1Dim.badgeRadius.r),
        border: Border.all(color: tone.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 5.r,
              height: 5.r,
              decoration: BoxDecoration(color: tone.text, shape: BoxShape.circle),
            ),
            SizedBox(width: 5.w),
          ],
          Text(label, style: V1Typo.badge.copyWith(color: tone.text)),
        ],
      ),
    );
  }
}
