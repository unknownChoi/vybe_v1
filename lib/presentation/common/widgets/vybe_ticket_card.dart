import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_status_badge.dart';

/// 티켓 헤더 색. 디자인 `.tk-hl.{p|l|a|g|e}`.
enum VybeTicketTone {
  /// 확정 · 진행(보라).
  purple,

  /// 호출됨(라임 채움 — 글자가 잉크색으로 반전된다).
  lime,

  /// 접수됨(앰버).
  amber,

  /// 완료 · 만료 · 취소(회색).
  gray,

  /// 입장 완료(보라→라임 3겹).
  entered;

  List<Color> get colors => switch (this) {
    VybeTicketTone.purple => V1Colors.ticketHeaderPurple,
    VybeTicketTone.lime => V1Colors.ticketHeaderLime,
    VybeTicketTone.amber => V1Colors.ticketHeaderAmber,
    VybeTicketTone.gray => V1Colors.ticketHeaderGray,
    VybeTicketTone.entered => V1Colors.ticketHeaderEntered,
  };

  /// 라임 헤더 위에서는 글자가 잉크색이다(디자인 `.tk.ink .tk-h`).
  bool get inkText => this == VybeTicketTone.lime;
}

/// 티켓 카드 — 웨이팅 · 예약 · 공유 입장권이 모두 쓰는 껍데기.
///
/// 디자인 `.tk`(`new_func_renew.css:138~175`).
/// 색 레이어 헤더(매장명 · 상태 배지 · 부제) + 천공 절취선 + 본문.
///
/// ⚠ 라운드 카드 테두리는 `foregroundDecoration` 에 둔다 — CLAUDE.md 의
/// '라운드 카드에 테두리를 그릴 때' 규칙(코너 호에서 선이 사라지는 문제).
class VybeTicketCard extends StatelessWidget {
  const VybeTicketCard({
    super.key,
    required this.clubName,
    required this.subtitle,
    required this.tone,
    required this.child,
    this.badge,
    this.dimmed = false,
    this.onTap,
  });

  final String clubName;

  /// 헤더 둘째 줄(예: '07월 04일 금요일 · 오후 8:12 · 입장 대기 중').
  final String subtitle;
  final VybeTicketTone tone;

  /// 헤더 우측 상태 배지.
  final VybeStatusBadge? badge;

  /// 본문.
  final Widget child;

  /// 완료 · 만료 티켓 — 채도를 빼고 흐리게(디자인 `.tk.done`).
  final bool dimmed;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ink = tone.inkText;
    final titleColor = ink ? RenewGlass.ink : Colors.white;
    final subColor = ink ? const Color(0xB30E0D12) : RenewGlass.t3;

    final card = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: RenewGlass.cardFill,
        borderRadius: BorderRadius.circular(V1Dim.ticketRadius.r),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: RenewGlass.cardBorder),
        borderRadius: BorderRadius.circular(V1Dim.ticketRadius.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더
          Container(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: tone.colors,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        clubName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: V1Typo.ticketClub.copyWith(color: titleColor),
                      ),
                    ),
                    if (badge != null) ...[SizedBox(width: 8.w), badge!],
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13.sp, height: 1.35, color: subColor),
                ),
              ],
            ),
          ),
          const VybeTicketPerforation(),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
            child: child,
          ),
        ],
      ),
    );

    final body = dimmed
        ? Opacity(
            opacity: 0.78,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(_saturateZero),
              child: card,
            ),
          )
        : card;

    if (onTap == null) return body;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: body);
  }

  /// `filter: saturate(0)` 과 같은 행렬.
  static const List<double> _saturateZero = [
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0,
  ];
}

/// 티켓 절취선 — 양옆 반원 펀치 + 가운데 점선.
class VybeTicketPerforation extends StatelessWidget {
  const VybeTicketPerforation({super.key, this.height = 18});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: CustomPaint(painter: _PerforationPainter(), size: Size.infinite),
    );
  }
}

class _PerforationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.height / 2;
    final cy = size.height / 2;

    // 가운데 점선
    final dash = Paint()
      ..color = RenewGlass.hair
      ..strokeWidth = 1;
    const dashW = 5.0;
    const gapW = 5.0;
    var x = r + 6;
    while (x < size.width - r - 6) {
      canvas.drawLine(Offset(x, cy), Offset(math.min(x + dashW, size.width - r - 6), cy), dash);
      x += dashW + gapW;
    }

    // 양옆 펀치 — 뒤 배경색으로 찍어 '파인 것처럼' 보이게 한다.
    // BlendMode.clear 는 카드 자체 레이어를 못 지워서(이 페인터는 카드 **안**이다)
    // 화면에선 아무 변화가 없다 — 실측으로 확인하고 바꾼 자리다.
    final punch = Paint()..color = RenewGlass.ink;
    canvas.drawCircle(Offset(0, cy), r, punch);
    canvas.drawCircle(Offset(size.width, cy), r, punch);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 티켓 본문의 큰 숫자 — 작은 라벨 + 44 라임 숫자 + 단위.
///
/// 대기 번호 · 앞에 남은 팀 표시에 쓴다. 디자인 `.tk-num`.
class VybeTicketBigNumber extends StatelessWidget {
  const VybeTicketBigNumber({
    super.key,
    required this.label,
    required this.value,
    this.unit,
  });

  final String label;
  final String value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: RenewGlass.t4),
        ),
        SizedBox(height: 2.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: V1Typo.ticketNumber),
            if (unit != null) ...[
              SizedBox(width: 4.w),
              Text(unit!, style: V1Typo.bigNumberSmall),
            ],
          ],
        ),
      ],
    );
  }
}

/// 티켓 안 통계 칸 — 2칸 또는 3칸. 디자인 `.tk-stats`.
///
/// 칸 수를 받으므로 R 섹션의 '변경 전 → 변경 후' 2칸 비교도 이 위젯으로 그린다.
class VybeTicketStats extends StatelessWidget {
  const VybeTicketStats({super.key, required this.items, this.onTapIndex});

  /// `(라벨, 값, 값 색)`. 색이 null 이면 흰색.
  final List<(String, String, Color?)> items;

  /// 칸을 누르면 상세로 보낼 때.
  final void Function(int index)? onTapIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Container(width: 1, height: 28.h, color: RenewGlass.hair),
          Expanded(
            child: GestureDetector(
              onTap: onTapIndex == null ? null : () => onTapIndex!(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 12.w),
                    child: Text(
                      items[i].$1,
                      style: TextStyle(fontSize: 12.sp, color: RenewGlass.t4),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 12.w),
                    child: Text(
                      items[i].$2,
                      style: V1Typo.statValue.copyWith(
                        color: items[i].$3 ?? Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 티켓 아래 절취 스텁 — 종류 라벨 + 일련번호 + 가짜 바코드.
///
/// 디자인 `.tk-stub`. 바코드는 **표시 전용**이다(실제 스캔은 QR).
class VybeTicketStub extends StatelessWidget {
  const VybeTicketStub({
    super.key,
    required this.kindLabel,
    required this.serial,
  });

  /// 'ENTRY PASS' · 'TABLE RESERVATION' 같은 영문 종류 라벨.
  final String kindLabel;
  final String serial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kindLabel,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: RenewGlass.t4,
                ),
              ),
              SizedBox(height: 4.h),
              Text(serial, style: V1Typo.serial),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 92.w,
            height: 30.h,
            child: CustomPaint(painter: _BarcodePainter(serial)),
          ),
        ],
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  _BarcodePainter(this.seed);

  final String seed;

  @override
  void paint(Canvas canvas, Size size) {
    // 일련번호로 막대를 정한다 — 같은 티켓은 늘 같은 모양.
    final rnd = math.Random(seed.hashCode);
    final paint = Paint()..color = const Color(0x8AFFFFFF);
    var x = 0.0;
    while (x < size.width) {
      final w = 1.0 + rnd.nextInt(3);
      if (rnd.nextBool()) {
        canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), paint);
      }
      x += w + 1;
    }
  }

  @override
  bool shouldRepaint(covariant _BarcodePainter old) => old.seed != seed;
}
