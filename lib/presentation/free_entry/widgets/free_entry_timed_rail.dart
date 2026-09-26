import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/utils/date_format.dart';
import 'package:vybe/presentation/common/free_entry_labels.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/free_entry/free_entry_models.dart';
import 'package:vybe/presentation/free_entry/free_entry_style.dart';
import 'package:vybe/presentation/free_entry/widgets/free_entry_parts.dart';

/// 1섹션 · '지금 이 시간만 무료' — 시간대 무료 클럽 가로 레일 (FeTimedSection).
///
/// 카드 = 사진(뱃지·평점·이름·영업·메타) + 카운트다운 타일. 지금 무료면 마감까지
/// 초 단위로 세고, 아직이면 같은 타일에 `금 22:00부터 무료`를 쓴다(디자인엔 진행 중
/// 카드만 있지만, 이 앱 클럽은 목·금·토 밤에만 열어 낮엔 섹션이 통째로 비기 때문).
class FreeEntryTimedRail extends StatelessWidget {
  /// `compareFreeNow` 로 정렬된 시간대 클럽 — 지금 무료가 앞.
  final List<FreeEntryClub> clubs;

  /// 1초마다 흐르는 현재 시각. 카운트다운 숫자·막대만 이걸 구독한다 —
  /// 카드 전체를 매초 다시 그리면 글래스 블러까지 매초 다시 계산된다.
  final ValueListenable<DateTime> tick;
  final ValueChanged<FreeEntryClub> onTap;

  const FreeEntryTimedRail({
    super.key,
    required this.clubs,
    required this.tick,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nowCount = clubs.where((c) => c.freeNow).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VybeSectionHead(
          title: '지금 이 시간만 무료',
          sub: nowCount > 0
              ? '지금 무료 $nowCount곳 · 시간 지나면 입장료가 붙어요'
              : '${clubs.length}곳 · 무료 시간이 되면 입장료가 빠져요',
        ),
        FreeEntryRail(
          // 사진 128 + 타일 여백 22 + 타일(≈93) — 남는 몇 px 은 .h/.r 스케일 차이 여유.
          height: 256,
          gap: 11,
          itemCount: clubs.length,
          itemBuilder: (_, i) => _TimedCard(
            club: clubs[i],
            tick: tick,
            onTap: () => onTap(clubs[i]),
          ),
        ),
      ],
    );
  }
}

class _TimedCard extends StatelessWidget {
  final FreeEntryClub club;
  final ValueListenable<DateTime> tick;
  final VoidCallback onTap;

  const _TimedCard({
    required this.club,
    required this.tick,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 262.w,
        child: RenewGlassCard(
          padding: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FreeEntryImage(
                url: club.thumbnailUrl,
                gradient: club.gradient,
                height: 128,
                children: [
                  Positioned(
                    left: 12.w,
                    top: 12.h,
                    child: FreeEntryBadge(
                      label: club.freeNow ? '지금 무료' : '시간대 무료',
                    ),
                  ),
                  Positioned(
                    right: 12.w,
                    top: 12.h,
                    child: Container(
                      height: 24.h,
                      padding: EdgeInsets.symmetric(horizontal: 9.w),
                      decoration: BoxDecoration(
                        color: RenewGlass.barFill,
                        borderRadius: BorderRadius.circular(99.r),
                        border: Border.all(color: RenewGlass.hair),
                      ),
                      child: FreeEntryRating(rating: club.rating),
                    ),
                  ),
                  Positioned(
                    left: 13.w,
                    right: 13.w,
                    bottom: 12.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                club.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 18.sp,
                                  height: 20 / 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 18 * -0.025,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 7.w),
                            FreeEntryOpenPill(open: club.open),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        freeEntryMeta([
                          '${club.area} · ${club.dist.toStringAsFixed(1)}km',
                          club.genre,
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(11.r),
                child: _Countdown(club: club, tick: tick),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 카운트다운 타일 (FeCountdown). 마감 1시간 안이면 라임으로 켠다.
class _Countdown extends StatelessWidget {
  final FreeEntryClub club;
  final ValueListenable<DateTime> tick;

  const _Countdown({required this.club, required this.tick});

  @override
  Widget build(BuildContext context) {
    final end = club.activeEndsAt;
    final start = club.activeStartsAt;
    if (end == null || start == null) {
      return _Tile(urgent: false, child: _pending());
    }

    return ValueListenableBuilder<DateTime>(
      valueListenable: tick,
      builder: (_, now, __) {
        var left = end.difference(now);
        if (left.isNegative) left = Duration.zero;
        final total = end.difference(start).inSeconds;
        final prog = total <= 0
            ? 1.0
            : (now.difference(start).inSeconds / total).clamp(0.0, 1.0);
        final urgent = left < kEntryUrgent;
        final fg = urgent ? kEntryPoint : RenewGlass.t3;

        return _Tile(
          urgent: urgent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeadRow(
                icon: Icons.schedule_rounded,
                label: '무료 마감까지',
                color: fg,
                right: '${fmtHhmm(end)} 종료',
              ),
              SizedBox(height: 8.h),
              Text(
                formatFreeCountdown(left),
                style: _digits(urgent ? kEntryPoint : Colors.white),
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(99.r),
                child: SizedBox(
                  height: 4.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: Color(0x1AFFFFFF)),
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: prog,
                        // 디자인은 퍼플→라임 그라데이션이지만 브랜드 라임 단색으로(요구사항).
                        child: const ColoredBox(color: kEntryPoint),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 아직 무료가 아닐 때 — 시각 대신 언제부터인지를 큰 글자로.
  Widget _pending() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeadRow(
          icon: Icons.schedule_rounded,
          label: '다음 무료입장',
          color: RenewGlass.t3,
        ),
        SizedBox(height: 8.h),
        Text(
          club.pendingLabel ?? '시간대 무료',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _digits(Colors.white),
        ),
        SizedBox(height: 10.h),
        Text(
          club.cond,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: RenewGlass.caption(
            color: RenewGlass.t4,
            size: 11,
            lineHeight: 12,
          ),
        ),
      ],
    );
  }

  /// 디자인은 34px 이지만 예정 문구(`금 22:00부터 무료`)와 같은 22px 로 맞췄다(요구사항).
  static TextStyle _digits(Color color, {double size = 22}) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: size.sp,
    height: 1,
    fontWeight: FontWeight.w700,
    letterSpacing: size * -0.035,
    color: color,
    // 숫자 폭이 매초 달라지면 글자가 떨린다.
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

class _Tile extends StatelessWidget {
  final bool urgent;
  final Widget child;
  const _Tile({required this.urgent, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(13.w, 11.h, 13.w, 12.h),
      decoration: BoxDecoration(
        color: urgent ? kEntryPointSoft : RenewGlass.tileFill,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: urgent ? kEntryPointLine : RenewGlass.tileBorder,
        ),
      ),
      child: child,
    );
  }
}

class _HeadRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? right;

  const _HeadRow({
    required this.icon,
    required this.label,
    required this.color,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    final caption = RenewGlass.caption(
      color: color,
      size: 11,
      lineHeight: 12,
      weight: FontWeight.w700,
    );
    return Row(
      children: [
        Icon(icon, size: 11.r, color: color),
        SizedBox(width: 5.w),
        Expanded(child: Text(label, style: caption)),
        if (right != null)
          Text(
            right!,
            style: RenewGlass.caption(
              color: RenewGlass.t4,
              size: 11,
              lineHeight: 12,
            ),
          ),
      ],
    );
  }
}
