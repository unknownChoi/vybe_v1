import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 규정 · 안내 박스. 디자인 `.fnote`.
///
/// 한 줄 안내와 `· ` 불릿 목록 둘 다 담는다. 실패 화면은 테두리가 앰버로 바뀐다.
/// 기존 `RenewFooterNote` 는 **단문 전용**이라 불릿 목록을 못 담아 따로 둔다
/// (기존 호출부를 건드리지 않기 위해서다).
class VybeNoteBox extends StatelessWidget {
  const VybeNoteBox({
    super.key,
    this.text,
    this.bullets = const [],
    this.borderColor,
    this.icon = true,
  });

  /// 한 줄 안내.
  final String? text;

  /// `· ` 불릿 목록.
  final List<String> bullets;

  /// 기본은 글래스 헤어라인. 경고면 [V1Colors.amber500] 같은 색을 준다.
  final Color? borderColor;
  final bool icon;

  @override
  Widget build(BuildContext context) {
    final body = <Widget>[
      if (text != null)
        Text(
          text!,
          style: TextStyle(fontSize: 13.sp, height: 1.5, color: RenewGlass.t3),
        ),
      for (final b in bullets)
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '· ',
                style: TextStyle(fontSize: 13.sp, height: 1.5, color: RenewGlass.t4),
              ),
              Expanded(
                child: Text(
                  b,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: RenewGlass.t3,
                  ),
                ),
              ),
            ],
          ),
        ),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: RenewGlass.quietFill,
        borderRadius: BorderRadius.circular(V1Dim.noteRadius.r),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: borderColor ?? RenewGlass.hair),
        borderRadius: BorderRadius.circular(V1Dim.noteRadius.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon) ...[
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Icon(
                Icons.info_outline_rounded,
                size: 16.r,
                color: borderColor ?? RenewGlass.t4,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: body),
          ),
        ],
      ),
    );
  }
}

/// 한 줄 인라인 알림 띠. 디자인 `.ibn`.
///
/// 지금 어떤 맥락인지 본문 맨 위에서 알린다(구간 안내 · 경고 · 상태).
class VybeInlineBanner extends StatelessWidget {
  const VybeInlineBanner(
    this.text, {
    super.key,
    this.tone = VybeInlineBannerTone.purple,
  });

  final String text;
  final VybeInlineBannerTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: tone.fill,
        borderRadius: BorderRadius.circular(V1Dim.noteRadius.r),
        border: Border.all(color: tone.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h, right: 8.w),
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(color: tone.text, shape: BoxShape.circle),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: tone.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [VybeInlineBanner] 톤. 디자인 `.ibn.purple` · `.ibn.amber`.
enum VybeInlineBannerTone {
  purple,
  amber;

  Color get fill => switch (this) {
    VybeInlineBannerTone.purple => const Color(0x1F7731FE),
    VybeInlineBannerTone.amber => const Color(0x1FF5B544),
  };

  Color get border => switch (this) {
    VybeInlineBannerTone.purple => const Color(0x3D7731FE),
    VybeInlineBannerTone.amber => const Color(0x3DF5B544),
  };

  Color get text => switch (this) {
    VybeInlineBannerTone.purple => V1Colors.purpleBannerText,
    VybeInlineBannerTone.amber => V1Colors.amberText,
  };
}
