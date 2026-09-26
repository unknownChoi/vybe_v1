import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_button.dart';

/// 푸시 화면 공통 상단 바 — 뒤로가기 + 가운데 제목 + (선택) 우측 슬롯.
///
/// 마이페이지 `MyPushHeader`(디자인 MRPushHead)를 그대로 옮겼다 — 리뷰 작성·
/// 테이블 가격표·공연 일정도 같은 배치라서. 제목이 정확히 가운데 오도록
/// 좌·우 슬롯 폭을 [buttonSize]로 같게 맞춘다. 세이프에어리어는 안에서 더한다.
class VybePushHeader extends StatelessWidget {
  final String title;

  /// 우측 슬롯에 넣을 위젯. 없으면 빈 자리로 남겨 제목 중앙을 지킨다.
  final Widget? trailing;

  /// 뒤로가기 버튼 지름 = 우측 슬롯 폭 (`.w`/`.r` 적용 전).
  final double buttonSize;

  const VybePushHeader({
    super.key,
    required this.title,
    this.trailing,
    this.buttonSize = 38,
  });

  @override
  Widget build(BuildContext context) {
    return RenewBar(
      // 구분선 없음 — 배경이 투명해진 뒤로는 hairline만 남아 화면을 가로지르는
      // 줄로 보인다. 상단바와 본문은 여백으로 나눈다.
      bottomBorder: false,
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: SizedBox(
        height: 46.h,
        child: Row(
          children: [
            SizedBox(width: (RenewGlass.pagePad - 8).w),
            VybeGlassButton(
              onTap: () => Navigator.of(context).maybePop(),
              size: buttonSize,
              iconSize: 17,
              hitSize: buttonSize,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: VybeTypography.button1.copyWith(color: RenewGlass.t1),
                ),
              ),
            ),
            SizedBox(
              width: buttonSize.w,
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing ?? const SizedBox.shrink(),
              ),
            ),
            SizedBox(width: (RenewGlass.pagePad - 8).w),
          ],
        ),
      ),
    );
  }
}
