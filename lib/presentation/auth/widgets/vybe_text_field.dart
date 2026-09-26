import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/widgets/vybe_underline.dart';

/// 본인 인증 입력 필드 — 하단 라인(bottom border)만 있는 스타일.
///
/// Figma "input / variant=Default" 기반. 포커스 중엔 밑줄에 언더글로우
/// (회원가입 리뉴얼 `SVUnderline`). 본인 인증 화면(이름·전화번호)만 쓴다.
///
/// - [hint]: 플레이스홀더 텍스트
/// - [controller]: TextEditingController
/// - [keyboardType]: 키보드 타입
/// - [inputFormatters]: 입력 포맷터
/// - [onClear]: 전체 삭제(×) 탭 콜백. null 이면 × 를 안 그린다
class VybeTextField extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final VoidCallback? onClear;

  const VybeTextField({
    super.key,
    this.hint,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.focusNode,
    this.onClear,
  });

  @override
  State<VybeTextField> createState() => _VybeTextFieldState();
}

class _VybeTextFieldState extends State<VybeTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);
    _hasText = (widget.controller?.text ?? '').isNotEmpty;
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _onTextChange() {
    final hasText = (widget.controller?.text ?? '').isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    widget.controller?.removeListener(_onTextChange);
    super.dispose();
  }

  Color get _lineColor =>
      _isFocused || _hasText ? VybeColors.mainPurple500 : VybeColors.gray700;

  bool get _showClear => _hasText && widget.onClear != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                // iOS 16+의 SystemContextMenu는 활성 텍스트 입력 연결이 없으면
                // assertion 오류 발생 → AdaptiveTextSelectionToolbar 직접 사용
                contextMenuBuilder: (context, editableTextState) =>
                    AdaptiveTextSelectionToolbar(
                      anchors: editableTextState.contextMenuAnchors,
                      children: AdaptiveTextSelectionToolbar.getAdaptiveButtons(
                        context,
                        editableTextState.contextMenuButtonItems,
                      ).toList(),
                    ),
                onChanged: (val) => setState(() => _hasText = val.isNotEmpty),
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 24.sp,
                  height: 26 / 24,
                  letterSpacing: 24 * -0.025,
                  color: VybeColors.gray200,
                ),
                cursorColor: VybeColors.mainPurple500,
                cursorHeight: 26.h,
                cursorWidth: 2.w,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 24.sp,
                    height: 26 / 24,
                    letterSpacing: 24 * -0.025,
                    color: VybeColors.gray600,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                ),
              ),
            ),
            if (_showClear)
              GestureDetector(
                onTap: () {
                  widget.controller?.clear();
                  setState(() => _hasText = false);
                  widget.onClear?.call();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Icon(
                    Icons.cancel,
                    size: 20.r,
                    color: VybeColors.gray500,
                  ),
                ),
              ),
          ],
        ),
        // 디자인은 입력줄과 밑줄 사이를 9px 띄운다(원본은 4px 패딩만).
        SizedBox(height: 5.h),
        VybeUnderline(color: _lineColor, glow: _isFocused),
      ],
    );
  }
}
