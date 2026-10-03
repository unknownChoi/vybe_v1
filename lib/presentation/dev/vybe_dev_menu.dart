import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/config/backend_env.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/dev/vybe_dev_overlay.dart';
import 'package:vybe/presentation/dev/vybe_widget_gallery.dart';

/// 개발용 메뉴 — Fake 상태 전환 + 공용 위젯 미리보기.
///
/// ⚠ **`kDebugMode` 에서만 열린다.** [open] 이 릴리스 빌드에서는 아무것도 하지 않고,
/// 입구인 [VybeDevOverlay] 자체도 릴리스에서는 트리에 없다.
class VybeDevMenu extends StatefulWidget {
  const VybeDevMenu({super.key});

  /// 개발 메뉴를 연다. 릴리스에서는 no-op.
  static void open() {
    if (!kDebugMode) return;
    vybeRootNavigatorKey.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => const VybeDevMenu()),
    );
  }

  @override
  State<VybeDevMenu> createState() => _VybeDevMenuState();
}

class _VybeDevMenuState extends State<VybeDevMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const VybeAurora(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '개발 메뉴',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
                    children: [
                      _section('백엔드'),
                      _card(
                        child: Row(
                          children: [
                            Text(
                              'VYBE_BACKEND',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: RenewGlass.t3,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              kVybeBackend.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: VybeColors.mainLime500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '빌드에 박힌 값이라 앱 안에서는 못 바꾼다 — '
                        '--dart-define=VYBE_BACKEND=fake|emulator|prod',
                        style: TextStyle(fontSize: 12.sp, color: RenewGlass.t4),
                      ),

                      SizedBox(height: 24.h),
                      _section('Fake 상태'),
                      Text(
                        'v1 신규 화면(H~T)의 Fake datasource 가 이 값을 읽는다. '
                        '베타 기능(클럽·리뷰·찜·검색)은 영향 없다.',
                        style: TextStyle(fontSize: 12.sp, color: RenewGlass.t4),
                      ),
                      SizedBox(height: 10.h),
                      ValueListenableBuilder<FakeScenario>(
                        valueListenable: fakeScenario,
                        builder: (context, value, _) => Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            for (final s in FakeScenario.values)
                              _chip(
                                s.label,
                                selected: s == value,
                                onTap: () => fakeScenario.value = s,
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),
                      _section('미리보기'),
                      _card(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const VybeWidgetGallery(),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.widgets_outlined,
                              size: 18.r,
                              color: RenewGlass.t3,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              '공용 위젯 미리보기',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20.r,
                              color: RenewGlass.t4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: VybeColors.mainLime500,
      ),
    ),
  );

  Widget _card({required Widget child, VoidCallback? onTap}) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: RenewGlass.quietFill,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: RenewGlass.cardBorder),
      ),
      child: child,
    ),
  );

  Widget _chip(String label, {required bool selected, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: selected
                ? VybeColors.mainPurple500
                : RenewGlass.quietFill,
            borderRadius: BorderRadius.circular(99.r),
            border: Border.all(
              color: selected
                  ? VybeColors.mainPurple500
                  : RenewGlass.cardBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : RenewGlass.t3,
            ),
          ),
        ),
      );
}
