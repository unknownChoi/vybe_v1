import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 홈 카드 pill 의 톤 — 디자인 `home.jsx > TONE`.
enum VybePillTone {
  /// 라임 틴트 — '지금 무료'.
  lime,

  /// 기본(회색 타일) — 시작 시각.
  quiet,

  /// 어두운 바 채움 — 사진 위에서 대비를 올려야 할 때(남은 시간 · 평점).
  dark;

  Color get fill => switch (this) {
    VybePillTone.lime => const Color(0x24B5FF60),
    VybePillTone.quiet => RenewGlass.tileFill,
    VybePillTone.dark => RenewGlass.barFill,
  };

  Color get border => switch (this) {
    VybePillTone.lime => const Color(0x4DB5FF60),
    VybePillTone.quiet => RenewGlass.tileBorder,
    VybePillTone.dark => RenewGlass.hair,
  };

  Color get text => switch (this) {
    VybePillTone.lime => VybeColors.mainLime500,
    VybePillTone.quiet => RenewGlass.t3,
    VybePillTone.dark => RenewGlass.t2,
  };
}

/// 카드 위 작은 pill — 디자인 `home.jsx > Pill`.
///
/// 주변 클럽(평점) · 타임 무료입장(지금 무료 · 시작 시각 · 남은 시간) 공용.
/// [live] 를 주면 점이 맥박친다(디자인 `livePulse 1.4s`).
///
/// ⚠ 블러는 넣지 않는다 — 5×5 점과 11sp 글자 뒤라 눈에 보이는 차이가 없는데
/// pill 마다 매 프레임 뒤 배경을 다시 뜬다(CLAUDE.md 블러 옵트인 규칙).
class VybePill extends StatefulWidget {
  final String label;
  final VybePillTone tone;

  /// 라벨 앞 아이콘. 점([dot])과 같이 쓰지 않는다.
  final IconData? icon;

  /// 아이콘 색. 기본은 톤의 글자색.
  final Color? iconColor;

  /// 라벨 앞 점. [live] 면 맥박친다.
  final bool dot;
  final bool live;

  const VybePill({
    super.key,
    required this.label,
    this.tone = VybePillTone.quiet,
    this.icon,
    this.iconColor,
    this.dot = false,
    this.live = false,
  });

  @override
  State<VybePill> createState() => _VybePillState();
}

class _VybePillState extends State<VybePill>
    with SingleTickerProviderStateMixin {
  AnimationController? _c;

  @override
  void initState() {
    super.initState();
    if (widget.live) _start();
  }

  void _start() {
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(VybePill old) {
    super.didUpdateWidget(old);
    if (widget.live == old.live) return;
    if (widget.live) {
      _start();
    } else {
      _c?.dispose();
      _c = null;
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tone = widget.tone;
    final style = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 11.sp,
      height: 1,
      fontWeight: FontWeight.w600,
      letterSpacing: 11 * -0.025,
      color: tone.text,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: tone.fill,
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(color: tone.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.dot) ...[_Dot(tone: tone, pulse: _c), SizedBox(width: 5.w)],
          if (widget.icon != null) ...[
            Icon(
              widget.icon,
              size: 11.r,
              color: widget.iconColor ?? tone.text,
            ),
            SizedBox(width: 4.w),
          ],
          Text(widget.label, style: style),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final VybePillTone tone;
  final AnimationController? pulse;

  const _Dot({required this.tone, this.pulse});

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 5.r,
      height: 5.r,
      decoration: BoxDecoration(color: tone.text, shape: BoxShape.circle),
    );
    final c = pulse;
    if (c == null) return dot;
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.55).animate(c),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 1.35).animate(c),
        child: dot,
      ),
    );
  }
}
