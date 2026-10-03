import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';

/// PASS-035 패스월렛 — **임시 화면**.
///
/// 결정 ⑫ 로 하단 탭 3번째 자리가 찜 → 패스월렛이 됐는데 화면이 아직 없다.
/// 탭을 빈 채로 두면 눌렀을 때 아무 일도 안 일어나 '고장'으로 읽히므로,
/// 화면 ID 와 이름만 보이는 자리표시만 둔다.
///
/// ⚠ **STEP 5 에서 실제 PASS-035~043 화면으로 교체한다.**
/// `docs/progress.md` 「임시 연결」 목록 참고.
class PassWalletScreen extends StatelessWidget {
  const PassWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const VybeAurora(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PASS-035',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: VybeColors.mainLime500,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  '패스월렛',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  '아직 만들지 않은 화면이에요',
                  style: TextStyle(fontSize: 14.sp, color: RenewGlass.t4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
