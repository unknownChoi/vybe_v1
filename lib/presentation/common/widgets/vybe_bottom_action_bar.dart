import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 화면 맨 아래 고정 버튼 영역. 디자인 `Bottom`.
///
/// ⚠ **경계선 · 배경 · 그림자가 없다** — 여백만 두고 버튼을 깐다.
/// H~T 전 섹션에서 가장 많이 반복되는 레이아웃이다(20화면 이상).
///
/// 위에 올릴 수 있는 것 — 비활성 사유 캡션([caption]) 또는 합계 줄([summary]).
class VybeBottomActionBar extends StatelessWidget {
  const VybeBottomActionBar({
    super.key,
    required this.children,
    this.caption,
    this.summary,
    this.gap = 8,
  });

  /// 버튼들. `Expanded` 로 감싸 비율을 주면 디자인의 `flex: 1 / 1.4` 가 된다.
  final List<Widget> children;

  /// 버튼 위 작은 안내(예: '내용을 끝까지 확인해 주세요').
  final String? caption;

  /// 버튼 위 합계 줄(예: 결제 금액).
  final Widget? summary;

  final double gap;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        V1Dim.pagePad,
        12.h,
        V1Dim.pagePad,
        12.h + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (summary != null) ...[summary!, SizedBox(height: 10.h)],
          if (caption != null) ...[
            Text(
              caption!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: RenewGlass.t4),
            ),
            SizedBox(height: 8.h),
          ],
          Row(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(width: gap.w),
                children[i],
              ],
            ],
          ),
        ],
      ),
    );
  }
}
