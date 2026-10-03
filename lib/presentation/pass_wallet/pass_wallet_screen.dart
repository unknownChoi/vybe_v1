import 'package:flutter/material.dart';
import 'package:vybe/presentation/common/v1/v1_placeholder_screen.dart';

/// PASS-035 패스월렛 — **임시 화면**.
///
/// 결정 ⑫ 로 하단 탭 3번째 자리가 찜 → 패스월렛이 됐는데 화면이 아직 없다.
///
/// ⚠ **STEP 5 에서 실제 PASS-035~043 화면으로 교체한다.**
/// `docs/progress.md` 「임시 연결」 목록 참고.
class PassWalletScreen extends StatelessWidget {
  const PassWalletScreen({super.key});

  @override
  Widget build(BuildContext context) => const V1PlaceholderScreen(
    screenId: 'PASS-035',
    name: '패스월렛',
    // 탭 본문이라 뒤로가기 상단바가 없다.
    pushHeader: false,
  );
}
