import 'package:flutter/material.dart';
import 'package:vybe/design_system/colors.dart';

/// 앱 공통 로딩 스피너.
///
/// ⚠ 예전에는 `flutter_spinkit`의 `SpinKitWave`(막대 5개) 위에 보라↔라임
/// 컬러 트윈을 얹었다. 효과 하나 때문에 패키지를 물고 있어 프레임워크 기본
/// 인디케이터로 바꿨다 — 파도 모양과 색 펄스는 사라졌다.
class VybeSpinner extends StatelessWidget {
  final double size;

  const VybeSpinner({super.key, this.size = 50.0});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: const CircularProgressIndicator(
      color: VybeColors.mainPurple500,
      strokeWidth: 3,
    ),
  );
}
