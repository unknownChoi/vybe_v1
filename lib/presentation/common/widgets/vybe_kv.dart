import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 라벨·값 한 줄. 디자인 `.kv` (`new_func_renew.css:233`).
///
/// 예약 요약 · 결제 영수증 · 환불 내역 · 안내 화면 표가 전부 이 줄로 조립된다.
/// H~T 에서 가장 많이 반복되는 행이다.
class VybeKvRow extends StatelessWidget {
  const VybeKvRow(
    this.label,
    this.value, {
    super.key,
    this.valueColor,
    this.valueWeight = FontWeight.w600,
    this.divider = true,
    this.valueWidget,
  });

  final String label;

  /// [valueWidget] 을 주면 무시된다.
  final String value;
  final Color? valueColor;
  final FontWeight valueWeight;

  /// 아래 헤어라인. 카드의 마지막 줄만 false.
  final bool divider;

  /// 값 자리에 위젯을 넣고 싶을 때(배지 · 복사 버튼 등).
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.h),
      decoration: divider
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: RenewGlass.hair)),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨이 길면 줄여서라도 값 자리를 남긴다(값이 더 중요한 정보다).
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: RenewGlass.t4,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: valueWidget ??
                  Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: valueWeight,
                      color: valueColor ?? Colors.white,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [VybeKvRow] 여러 줄을 묶는 글래스 카드. 디자인 `.gcard`(padding 4 16).
class VybeKvCard extends StatelessWidget {
  const VybeKvCard({super.key, required this.rows, this.padding});

  final List<Widget> rows;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: RenewGlass.quietFill,
        borderRadius: BorderRadius.circular(V1Dim.cardRadius.r),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: RenewGlass.cardBorder),
        borderRadius: BorderRadius.circular(V1Dim.cardRadius.r),
      ),
      child: Column(children: _stripLastDivider(rows)),
    );
  }

  /// 마지막 줄의 헤어라인은 카드 테두리와 겹쳐 두 줄로 보인다.
  static List<Widget> _stripLastDivider(List<Widget> rows) {
    if (rows.isEmpty) return rows;
    final out = List<Widget>.from(rows);
    final last = out.last;
    if (last is VybeKvRow && last.divider) {
      out[out.length - 1] = VybeKvRow(
        last.label,
        last.value,
        valueColor: last.valueColor,
        valueWeight: last.valueWeight,
        valueWidget: last.valueWidget,
        divider: false,
      );
    }
    return out;
  }
}

/// 금액 요약 카드 — 항목 행들 + 구분선 + 큰 합계 한 줄. 디자인 `RkAmt`.
///
/// 결제 · 환불 · 패널티 내역이 전부 이 틀이다.
/// 용어는 **"공제"가 아니라 "패널티"**(CLAUDE.md 확정 정책).
class VybeAmountCard extends StatelessWidget {
  const VybeAmountCard({
    super.key,
    this.label,
    required this.rows,
    required this.totalLabel,
    required this.total,
    this.tone = VybeRefundTone.ok,
  });

  /// 카드 머리 라벨(예: '환불 내역'). 없으면 생략.
  final String? label;

  /// `(라벨, 값)` 쌍.
  final List<(String, String)> rows;
  final String totalLabel;
  final String total;

  /// 합계 글자색을 정한다.
  final VybeRefundTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: RenewGlass.quietFill,
        borderRadius: BorderRadius.circular(V1Dim.cardRadius.r),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: RenewGlass.cardBorder),
        borderRadius: BorderRadius.circular(V1Dim.cardRadius.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            Padding(
              padding: EdgeInsets.only(top: 14.h, bottom: 2.h),
              child: Text(
                label!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: RenewGlass.t3,
                ),
              ),
            ),
          for (final (k, v) in rows) VybeKvRow(k, v),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    totalLabel,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  flex: 2,
                  child: Text(
                    total,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: tone.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 합계 줄에만 쓰는 색 — 금액이 0 이면 회색으로 떨어뜨린다.
Color vybeAmountColor(int won, VybeRefundTone tone) =>
    won == 0 ? VybeColors.gray500 : tone.color;
