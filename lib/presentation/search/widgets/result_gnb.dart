import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/filter_chip_style.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_button.dart';

/// 검색 결과 상단 바. 검색창을 탭하면 검색 입력 화면(최근 검색어)으로 돌아간다.
class ResultGnb extends StatelessWidget {
  final String query;
  final VoidCallback? onBack;

  const ResultGnb({super.key, required this.query, this.onBack});

  @override
  Widget build(BuildContext context) {
    final back = onBack ?? () => Navigator.of(context).pop();
    return Padding(
      // 디자인 GNB '8px 16px 10px'.
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
      child: Row(
        children: [
          VybeGlassButton(onTap: back, size: 34, iconSize: 18, hitSize: 38),
          SizedBox(width: 8.w),
          Expanded(
            child: GestureDetector(
              onTap: back,
              behavior: HitTestBehavior.opaque,
              // 디자인 검색 pill — 높이 44 · 흰 6% 채움 · 흰 12% 테두리 · blur(12).
              //
              // ⚠ 테두리는 `ClipRRect` **바깥** Container 에 둔다. 안쪽에 두면
              // 바깥 클립이 코너 호를 다시 깎아 모서리에서 선이 사라진다
              // (CLAUDE.md '라운드 카드에 테두리').
              child: Container(
                foregroundDecoration: BoxDecoration(
                  border: Border.all(color: RenewGlass.tileBorder),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),
                  child: BackdropFilter(
                    // 결과 카드가 이 바 뒤로 지나간다 — 블러를 켜는 자리다.
                    filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: kFilterChipFill,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              query,
                              style: VybeTypography.body4.copyWith(
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icons/common/search.svg',
                            width: 18.r,
                            height: 18.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
