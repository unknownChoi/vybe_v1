import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_hide_route.dart';

/// 아직 만들지 않은 v1 화면의 **자리표시**.
///
/// 화면 ID 와 이름만 보여 준다. 진입 버튼을 아무 데도 안 걸어 두면 눌렀을 때
/// 아무 일이 없어 '고장'으로 읽히고, 가짜 내용을 그려 두면 다 만든 줄 안다.
///
/// ⚠ **실제 화면이 생기면 이 자리표시를 지운다.**
/// 지금 걸려 있는 자리는 `docs/progress.md` 「임시 연결」 목록이 정본이다.
class V1PlaceholderScreen extends StatelessWidget {
  /// `WAIT-044` 같은 화면 ID.
  final String screenId;

  /// `웨이팅 티켓` 같은 화면 이름.
  final String name;

  /// 뒤로가기 상단바를 그릴지. 탭 본문(PASS-035)은 false.
  final bool pushHeader;

  const V1PlaceholderScreen({
    super.key,
    required this.screenId,
    required this.name,
    this.pushHeader = true,
  });

  /// 하단 nav 를 내린 채 띄운다 — 하위 화면은 전부 이 경로로 연다.
  static Future<void> push(
    BuildContext context, {
    required String screenId,
    required String name,
  }) => pushHidingNavBar<void>(
    context,
    V1PlaceholderScreen(screenId: screenId, name: name),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
          Column(
            children: [
              if (pushHeader) VybePushHeader(title: name),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        screenId,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: VybeColors.mainLime500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        '아직 만들지 않은 화면이에요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14.sp,
                          color: RenewGlass.t4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
