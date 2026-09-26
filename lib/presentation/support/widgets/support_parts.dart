import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/support/support_models.dart';

// ============================================================
// 고객센터 공통 조각 (디자인 `support_parts.jsx`).
//
// 목록·작성·상세 **세 화면이 같이 쓰는 것만** 여기 둔다. 한 화면에서만 쓰는
// 조각은 그 화면 옆(`inquiry_card` · `inquiry_form_parts`)에 남긴다.
// ============================================================

/// 문의 유형 태그 (SupTypeTag) — 유형별 색은 [InquiryCategory.tone].
class InquiryTypeTag extends StatelessWidget {
  final InquiryCategory category;

  const InquiryTypeTag({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final tone = category.tone;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: tone.fill,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: tone.border),
      ),
      child: Text(
        category.label,
        style: RenewGlass.caption(
          color: tone.foreground,
          size: 11,
          lineHeight: 15,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 답변 상태 뱃지 (SupStatusBadge) — 완료는 채운 점 + 라임, 대기는 빈 점 + 회색.
class InquiryStatusBadge extends StatelessWidget {
  final bool answered;

  const InquiryStatusBadge({super.key, required this.answered});

  @override
  Widget build(BuildContext context) {
    final color = answered ? VybeColors.mainLime500 : VybeColors.gray400;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: answered
            ? const Color(0x24B5FF60) // rgba(181,255,96,0.14)
            : RenewGlass.tileFill,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: answered
              ? const Color(0x4DB5FF60) // rgba(181,255,96,0.30)
              : const Color(0x24FFFFFF), // rgba(255,255,255,0.14)
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: answered ? color : Colors.transparent,
              border: answered ? null : Border.all(color: color, width: 1.4),
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            answered ? '답변 완료' : '답변 대기',
            style: RenewGlass.caption(
              color: color,
              size: 11,
              lineHeight: 11,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 입력 묶음 위 라벨 (SupLabel) — `제목` + 보조문구.
class InquiryFieldLabel extends StatelessWidget {
  final String label;

  /// 라벨 옆 보조 문구 ('선택 · 최대 4장').
  final String? sub;

  const InquiryFieldLabel(this.label, {super.key, this.sub});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            label,
            style: RenewGlass.caption(lineHeight: 14, weight: FontWeight.w700),
          ),
          if (sub != null) ...[
            SizedBox(width: 6.w),
            Text(
              sub!,
              style: RenewGlass.caption(
                color: VybeColors.gray600,
                lineHeight: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// [InquiryStatusMessage] 톤 (디자인 SUP_MSG_C).
enum InquiryMessageTone { normal, warn, success, error }

/// 입력 아래 한 줄 안내 (SupStatusMsg).
///
/// 디자인은 글리프 문자(ⓘ · ✓ · ✕)를 쓰지만 폰트에 없으면 두부가 되므로
/// 같은 뜻의 Material 아이콘으로 그린다.
class InquiryStatusMessage extends StatelessWidget {
  final String text;
  final InquiryMessageTone tone;

  const InquiryStatusMessage(
    this.text, {
    super.key,
    this.tone = InquiryMessageTone.normal,
  });

  Color get _color => switch (tone) {
    InquiryMessageTone.normal => VybeColors.gray500,
    InquiryMessageTone.warn => VybeColors.warnYellow,
    InquiryMessageTone.success => VybeColors.mainLime500,
    InquiryMessageTone.error => VybeColors.accentRed500,
  };

  IconData get _icon => switch (tone) {
    InquiryMessageTone.normal => Icons.info_outline_rounded,
    InquiryMessageTone.warn => Icons.error_outline_rounded,
    InquiryMessageTone.success => Icons.check_circle_outline_rounded,
    InquiryMessageTone.error => Icons.cancel_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, size: 12.r, color: color),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: RenewGlass.caption(color: color, lineHeight: 16),
          ),
        ),
      ],
    );
  }
}

/// 좌측 2px 컬러 바 + 옅은 틴트 박스. [InquiryWarnBox]·[InquiryNoteBox]의 껍데기.
class _InquirySideBarBox extends StatelessWidget {
  final Color accent;
  final Color fill;
  final Widget child;

  const _InquirySideBarBox({
    required this.accent,
    required this.fill,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(13.r),
          bottomRight: Radius.circular(13.r),
        ),
        border: Border(left: BorderSide(color: accent, width: 2)),
      ),
      child: child,
    );
  }
}

/// 제출 전 주의 (SupWarnBox) — 붉은 좌측 바 + 불릿 목록.
class InquiryWarnBox extends StatelessWidget {
  final String title;
  final List<String> items;

  const InquiryWarnBox({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return _InquirySideBarBox(
      accent: VybeColors.accentRed500,
      fill: const Color(0x0FFF5C5F), // rgba(255,92,95,0.06)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const RenewIcon(
                path: RenewIcons.alert,
                size: 14,
                color: VybeColors.accentRed500,
                strokeWidth: 1.9,
              ),
              SizedBox(width: 7.w),
              Text(
                title,
                style: VybeTypography.button2.copyWith(
                  color: VybeColors.accentRed500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(height: 6.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Container(
                    width: 3.r,
                    height: 3.r,
                    decoration: const BoxDecoration(
                      // rgba(255,255,255,0.32)
                      color: Color(0x52FFFFFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Text(
                    items[i],
                    style: RenewGlass.caption(
                      color: RenewGlass.t2,
                      lineHeight: 19,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 개인정보 안내 (SupNoteBox) — 라임 좌측 바 + 자물쇠.
class InquiryNoteBox extends StatelessWidget {
  final String text;

  const InquiryNoteBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return _InquirySideBarBox(
      accent: VybeColors.mainLime500,
      fill: const Color(0x0DB5FF60), // rgba(181,255,96,0.05)
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h, right: 9.w),
            child: const RenewIcon(
              path: RenewIcons.lock,
              size: 14,
              color: VybeColors.mainLime500,
              strokeWidth: 1.8,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: RenewGlass.caption(
                color: RenewGlass.t2,
                lineHeight: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 첨부 사진 타일 (SupThumb) — 상세 화면에서 올라간 사진을 보여 준다.
/// 누르면 라이트박스가 열리도록 [onTap]을 받는다.
class InquiryPhotoThumb extends StatelessWidget {
  final String url;
  final double size;
  final VoidCallback? onTap;

  const InquiryPhotoThumb({
    super.key,
    required this.url,
    this.size = 72,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size.r,
        height: size.r,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0x0DFFFFFF), // rgba(255,255,255,0.05)
          borderRadius: BorderRadius.circular(12.r),
        ),
        // 테두리는 자식(사진) 위에 올린다 — decoration 에 두면 코너 호에서 선이 사라진다.
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: RenewGlass.tileBorder),
        ),
        child: Image(
          image: vybeNetworkImage(
            url,
            cacheWidth: (size.r * MediaQuery.devicePixelRatioOf(context))
                .round(),
          ),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _placeholder(),
        ),
      ),
    );
  }

  Widget _placeholder() => const Center(
    child: RenewIcon(
      path: RenewIcons.image,
      size: 19,
      color: Color(0x57FFFFFF), // rgba(255,255,255,0.34)
      strokeWidth: 1.7,
    ),
  );
}
