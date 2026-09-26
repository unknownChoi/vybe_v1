import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_photo_picker.dart';
import 'package:vybe/presentation/support/support_models.dart';
import 'package:vybe/presentation/support/widgets/support_parts.dart';

// ============================================================
// 문의 작성 화면 조각 (디자인 `SupCreateScreen`).
//
// 입력 값은 화면이 들고 있는 컨트롤러가 정본이고, 여기 조각은 포커스·터치 여부
// 같은 **표시 상태만** 스스로 갖는다(리뷰 작성 화면과 같은 규칙).
// ============================================================

/// 문의 유형 타일 3열 (디자인 `SupTypePicker`).
class InquiryTypePicker extends StatelessWidget {
  /// 아직 아무것도 고르지 않았으면 null — 디자인은 기본 선택을 두지 않는다
  /// (제출 가드가 '문의 유형을 선택해 주세요'를 먼저 말한다).
  final InquiryCategory? selected;
  final ValueChanged<InquiryCategory> onSelect;

  const InquiryTypePicker({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const int _cols = 3;

  @override
  Widget build(BuildContext context) {
    final gap = 8.w;
    const values = InquiryCategory.values;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = (constraints.maxWidth - gap * (_cols - 1)) / _cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < values.length; i++)
              SizedBox(
                // 마지막 칸이 그 줄에 혼자 남으면 줄 전체를 채운다
                // (디자인 `gridColumn: '1 / -1'`).
                width: (i == values.length - 1 && i % _cols == 0)
                    ? constraints.maxWidth
                    : cell,
                child: _TypeTile(
                  category: values[i],
                  selected: values[i] == selected,
                  onTap: () => onSelect(values[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TypeTile extends StatelessWidget {
  final InquiryCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _TypeTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 46.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: selected
              ? VybeColors.mainLime500
              : const Color(0x0FFFFFFF), // rgba(255,255,255,0.06)
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? VybeColors.mainLime500 : RenewGlass.tileBorder,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: VybeColors.mainLime500.withValues(alpha: 0.22),
                    blurRadius: 18.r,
                    offset: Offset(0, 6.h),
                  ),
                ]
              : null,
        ),
        child: Text(
          category.label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: VybeTypography.button2.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? RenewGlass.ink : RenewGlass.t3,
          ),
        ),
      ),
    );
  }
}

/// 밑줄 입력 한 칸 (디자인 `SupCreateScreen.field`) — 라벨 · 입력 · 안내/글자수.
///
/// 밑줄 색이 곧 상태다 — 평상시 gray700 · 포커스 purple500 · 오류 red500.
/// 오류는 **한 번이라도 손댄 뒤에만** 띄운다(화면에 들어오자마자 빨간 줄이
/// 두 개 떠 있으면 잘못한 것처럼 보인다).
class InquiryUnderlineField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  /// 입력 전 회색 안내 문구.
  final String placeholder;

  /// 아래 왼쪽 기본 안내 ('최소 2자 이상').
  final String helper;

  /// 최소 길이 미만일 때 문구.
  final String errorMessage;

  final int minLength;
  final int maxLength;

  /// 이 길이를 넘으면 글자수가 노란색으로 (본문 전용). null이면 안 바뀐다.
  final int? warnAt;

  /// 여러 줄 입력.
  final bool multiline;

  const InquiryUnderlineField({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.helper,
    required this.errorMessage,
    required this.minLength,
    required this.maxLength,
    this.warnAt,
    this.multiline = false,
  });

  @override
  State<InquiryUnderlineField> createState() => _InquiryUnderlineFieldState();
}

class _InquiryUnderlineFieldState extends State<InquiryUnderlineField> {
  final _focus = FocusNode();
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  void _onFocus() {
    // 포커스를 잃으면 비워 둔 칸도 오류로 표시한다 (디자인 onBlur → touch).
    if (!_focus.hasFocus) _touched = true;
    setState(() {});
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InquiryFieldLabel(widget.label),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller,
          builder: (context, value, __) {
            final length = value.text.characters.length;
            final trimmed = value.text.trim().characters.length;
            final hasError = _touched && trimmed < widget.minLength;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 9.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: _lineColor(hasError)),
                    ),
                  ),
                  // 여러 줄 입력의 최소 높이 (디자인 132).
                  constraints: widget.multiline
                      ? BoxConstraints(minHeight: 132.h)
                      : null,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focus,
                    maxLines: widget.multiline ? null : 1,
                    minLines: widget.multiline ? 5 : 1,
                    expands: false,
                    // 서버 Rules 와 같은 상한 — 여기서 잘라야 403 이 안 난다.
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(widget.maxLength),
                    ],
                    onChanged: (_) {
                      if (!_touched) setState(() => _touched = true);
                    },
                    cursorColor: VybeColors.mainPurple500,
                    style: _inputStyle(RenewGlass.t1),
                    decoration: InputDecoration(
                      isDense: true,
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.placeholder,
                      hintStyle: _inputStyle(VybeColors.gray600),
                    ),
                  ),
                ),
                SizedBox(height: 7.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InquiryStatusMessage(
                        hasError ? widget.errorMessage : widget.helper,
                        tone: hasError
                            ? InquiryMessageTone.error
                            : InquiryMessageTone.normal,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '$length/${widget.maxLength}',
                      style: RenewGlass.caption(
                        color: _countColor(hasError, length),
                        lineHeight: 14,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Color _lineColor(bool hasError) {
    if (hasError) return VybeColors.accentRed500;
    if (_focus.hasFocus) return VybeColors.mainPurple500;
    return VybeColors.gray700;
  }

  Color _countColor(bool hasError, int length) {
    if (hasError) return VybeColors.accentRed500;
    if (widget.warnAt != null && length > widget.warnAt!) {
      return VybeColors.warnYellow;
    }
    return VybeColors.gray500;
  }

  TextStyle _inputStyle(Color color) => TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    height: (widget.multiline ? 23 : 22) / 16,
    letterSpacing: 16 * -0.025,
    color: color,
  );
}

/// 사진 첨부 줄 (디자인 `SupCreateScreen` 사진 첨부) — 라벨 + 타일.
class InquiryPhotoField extends StatelessWidget {
  final List<VybePhotoPick> photos;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const InquiryPhotoField({
    super.key,
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const InquiryFieldLabel('사진 첨부', sub: '선택 · 최대 $kInquiryMaxPhotos장'),
        VybePhotoPickerRow(
          photos: photos,
          maxCount: kInquiryMaxPhotos,
          onAdd: onAdd,
          onRemove: onRemove,
          // 디자인은 고른 사진 뒤에 추가 칸이 온다 — 왼쪽부터 순서대로 쌓인다.
          addFirst: false,
          addShowsCount: true,
        ),
      ],
    );
  }
}
