import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 결과 · 안내 화면 틀. 디자인 `RkNotice` · `BookingDone` · `OrderDone`.
///
/// 원형 아이콘 + 제목 + 설명 + (요약 카드) + (불릿 안내) + 하단 버튼.
/// 완료 · 실패 · 불가 · 거절 화면이 전부 이 틀이다(H~T 에서 10화면 이상).
///
/// 하단 버튼은 이 위젯이 그리지 않는다 — 화면이 `VybeBottomActionBar` 를
/// `Scaffold.bottomNavigationBar` 자리에 따로 둔다(스크롤과 분리되어야 하므로).
class VybeResultView extends StatelessWidget {
  const VybeResultView({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    this.description,
    this.children = const [],
  });

  final IconData icon;

  /// 아이콘 원 색을 정한다.
  final VybeResultTone tone;

  /// 여러 줄 가능(`\n`).
  final String title;
  final String? description;

  /// 제목 아래에 쌓을 것들(요약 카드 · 안내 박스 등).
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(V1Dim.pagePad, 24.h, V1Dim.pagePad, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 72.r,
              height: 72.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tone.fill,
                border: Border.all(color: tone.border, width: 1.5),
              ),
              child: Icon(icon, size: 32.r, color: tone.color),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              height: 1.35,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          if (description != null) ...[
            SizedBox(height: 10.h),
            Text(
              description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.55,
                color: RenewGlass.t3,
              ),
            ),
          ],
          for (final c in children) ...[SizedBox(height: 14.h), c],
        ],
      ),
    );
  }
}

/// [VybeResultView] 아이콘 톤.
enum VybeResultTone {
  /// 성공 · 완료(라임).
  success,

  /// 주의 · 패널티 발생(앰버).
  warn,

  /// 실패 · 불가(빨강).
  error,

  /// 중립 안내(회색).
  neutral;

  Color get color => switch (this) {
    VybeResultTone.success => VybeColors.mainLime500,
    VybeResultTone.warn => V1Colors.amber500,
    VybeResultTone.error => VybeColors.accentRed500,
    VybeResultTone.neutral => RenewGlass.t3,
  };

  Color get fill => switch (this) {
    VybeResultTone.success => const Color(0x1FB5FF60),
    VybeResultTone.warn => const Color(0x1FF5B544),
    VybeResultTone.error => const Color(0x1FFF5C5F),
    VybeResultTone.neutral => RenewGlass.quietFill,
  };

  Color get border => switch (this) {
    VybeResultTone.success => const Color(0x4DB5FF60),
    VybeResultTone.warn => const Color(0x4DF5B544),
    VybeResultTone.error => const Color(0x4DFF5C5F),
    VybeResultTone.neutral => RenewGlass.cardBorder,
  };
}
