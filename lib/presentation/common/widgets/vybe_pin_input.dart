import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 숫자 비밀번호 입력 — 셀 줄 + 밑줄 색으로 상태를 말한다. 디자인 `PinRow`.
///
/// 공유 입장권 비밀번호(6자리 · 시도 5회 · 실패 시 30분 잠김)에 쓴다.
/// OTP 와 같은 '보이는 칸 + 숨은 입력' 구조다(베타 인증번호 화면과 같은 방식).
class VybePinInput extends StatefulWidget {
  const VybePinInput({
    super.key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
    this.error = false,
    this.hint,
    this.autofocus = true,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  /// 불일치 — 밑줄이 빨강으로 바뀐다.
  final bool error;

  /// 셀 아래 안내(예: '남은 시도 4회').
  final String? hint;
  final bool autofocus;

  @override
  State<VybePinInput> createState() => _VybePinInputState();
}

class _VybePinInputState extends State<VybePinInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    setState(() {});
    widget.onChanged?.call(v);
    if (v.length == widget.length) widget.onCompleted(v);
  }

  @override
  Widget build(BuildContext context) {
    final value = _controller.text;
    return GestureDetector(
      onTap: () => _focus.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Row(
                children: [
                  for (var i = 0; i < widget.length; i++) ...[
                    if (i > 0) SizedBox(width: 8.w),
                    Expanded(child: _cell(i, value)),
                  ],
                ],
              ),
              // 숨은 입력칸 — 화면엔 안 보이고 키보드만 받는다.
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    autofocus: widget.autofocus,
                    keyboardType: TextInputType.number,
                    maxLength: widget.length,
                    onChanged: _onChanged,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(counterText: ''),
                  ),
                ),
              ),
            ],
          ),
          if (widget.hint != null) ...[
            SizedBox(height: 10.h),
            Text(
              widget.hint!,
              style: TextStyle(
                fontSize: 12.sp,
                color: widget.error ? VybeColors.accentRed500 : RenewGlass.t4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _cell(int i, String value) {
    final filled = i < value.length;
    final focused = i == value.length && _focus.hasFocus;
    final line = widget.error
        ? VybeColors.accentRed500
        : focused
        ? VybeColors.mainPurple500
        : VybeColors.gray700;

    return Column(
      children: [
        SizedBox(
          height: 44.h,
          child: Center(
            child: filled
                ? Container(
                    width: 9.r,
                    height: 9.r,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        Container(height: 2.h, color: line),
      ],
    );
  }
}

/// 공유 일련번호 표시 — 대문자 코드 + 복사 버튼. 디자인 `SerialRow`.
class VybeSerialRow extends StatefulWidget {
  const VybeSerialRow({super.key, required this.serial, this.onCopy});

  final String serial;

  /// 누르면 클립보드 복사 뒤 호출된다(토스트는 화면이 띄운다).
  final VoidCallback? onCopy;

  @override
  State<VybeSerialRow> createState() => _VybeSerialRowState();
}

class _VybeSerialRowState extends State<VybeSerialRow> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: RenewGlass.quietFill,
        borderRadius: BorderRadius.circular(V1Dim.cardRadius.r),
        border: Border.all(color: RenewGlass.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(child: Text(widget.serial, style: V1Typo.serial)),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: widget.serial));
              if (!mounted) return;
              setState(() => _copied = true);
              widget.onCopy?.call();
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _copied ? Icons.check_rounded : Icons.copy_rounded,
                  size: 16.r,
                  color: _copied ? VybeColors.mainLime500 : RenewGlass.t3,
                ),
                SizedBox(width: 5.w),
                Text(
                  _copied ? '복사됨' : '복사',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _copied ? VybeColors.mainLime500 : RenewGlass.t3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
