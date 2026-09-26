import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/night_clock.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_meta_dot.dart';
import 'package:vybe/presentation/common/widgets/vybe_save_button.dart';
import 'package:vybe/presentation/edm/edm_models.dart';
import 'package:vybe/presentation/edm/widgets/edm_equalizer.dart';

/// 타임테이블 셋 카드 1장 — 클럽 · DJ · 세부 장르 · 지역/거리 · 진행 상태.
///
/// 디자인(edm_renew_v1.jsx `SetCard`)의 좌측 액센트 바 색은 BPM(에너지)에서 나오는데
/// performances 에 BPM 이 없다. **진행 상태**로 대신 칠한다 — 없는 값을 지어내느니
/// 이미 아는 것을 색으로 말한다.
///
/// ⚠ 진행 중 카드는 **라임**이다 (디자인 v1). 예전엔 퍼플이었는데, 같은 화면의
/// NOW 마커·`N곳 플레이 중` pill 이 라임이라 '지금'을 말하는 색이 둘로 갈렸다.
class EdmSetCard extends StatelessWidget {
  final EdmSet set;
  final NightSlotStatus status;

  /// 지금 시각(분). '몇 분 후 시작' 계산용 — 카드마다 시계를 다시 읽으면
  /// 같은 목록 안에서 기준이 어긋난다.
  final int nowMin;

  /// 하트를 누른 공연 id 집합. 버튼만 구독한다 — 카드·목록은 하트에 안 흔들린다.
  final ValueListenable<Set<Object>> saved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  const EdmSetCard({
    super.key,
    required this.set,
    required this.status,
    required this.nowMin,
    required this.saved,
    required this.onSave,
    required this.onTap,
  });

  /// 상태별 강조색 — 진행 중은 라임, 예정은 보라, 종료는 회색.
  Color get _tone => switch (status) {
    NightSlotStatus.live => kEdmHot,
    NightSlotStatus.upcoming => kEdmUpcoming,
    NightSlotStatus.past => VybeColors.gray500,
  };

  String get _statusText => switch (status) {
    NightSlotStatus.live => '진행 중',
    NightSlotStatus.upcoming => '${nightMinutes(set.time) - nowMin}분 후 시작',
    NightSlotStatus.past => '공연 종료',
  };

  @override
  Widget build(BuildContext context) {
    final live = status == NightSlotStatus.live;
    final past = status == NightSlotStatus.past;
    final radius = BorderRadius.circular(16.r);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: live
                  ? kEdmHot.withValues(alpha: 0.16)
                  : const Color(0x4D000000),
              blurRadius: 24.r,
              offset: Offset(0, live ? 6.h : 8.h),
            ),
          ],
        ),
        // ⚠ 테두리는 자식 위(foregroundDecoration)에 — decoration 에 두면 좌측
        // 액센트 바가 코너 호에서 선을 덮는다. (CLAUDE.md '라운드 카드에 테두리')
        foregroundDecoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: live
                ? kEdmHot.withValues(alpha: 0.5)
                : RenewGlass.cardBorder,
          ),
        ),
        // ⚠ BackdropFilter 를 두지 않는다 — 뒤가 정적인 오로라뿐이라 블러할
        // 그림이 없고, 목록 행마다 오프스크린 레이어만 든다(perf).
        child: ClipRRect(
          borderRadius: radius,
          child: ColoredBox(
            color: RenewGlass.cardFill,
            child: Stack(
              children: [
                // 진행 중 카드만 라임 틴트 — 목록에서 눈이 먼저 닿는 자리.
                // 디자인 v1 `linear-gradient(120deg, rgba(181,255,96,.13), …)`을
                // 유리 위에 얹으므로 끝을 잉크가 아니라 **투명**으로 뺀다.
                if (live)
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-0.87, -0.5),
                          end: Alignment(0.87, 0.5),
                          colors: [Color(0x33B5FF60), Color(0x00B5FF60)],
                        ),
                      ),
                    ),
                  ),
                // 상단 1px 하이라이트 (RenewGlassCard 와 같은 값).
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 1,
                  child: ColoredBox(color: Color(0x2EFFFFFF)),
                ),
                // 좌측 액센트 바.
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 3.w,
                  child: ColoredBox(color: _tone),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 13.h, 12.w, 13.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _Info(
                          set: set,
                          live: live,
                          tone: _tone,
                          statusText: _statusText,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      ValueListenableBuilder<Set<Object>>(
                        valueListenable: saved,
                        builder: (_, s, __) => VybeSaveButton(
                          saved: s.contains(set.id),
                          onTap: onSave,
                          size: 30,
                          iconSize: 15,
                          fill: RenewGlass.tileFill,
                          border: RenewGlass.tileBorder,
                          savedColor: kEdmAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                // ⚠ 종료된 셋을 Opacity 로 낮추지 않는다 — 행마다 오프스크린
                // 레이어가 생긴다. 잉크 스크림을 자식 위에 덮어 같은 만큼 가라앉힌다.
                if (past)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: RenewGlass.ink.withValues(alpha: 0.48),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final EdmSet set;
  final bool live;
  final Color tone;
  final String statusText;

  const _Info({
    required this.set,
    required this.live,
    required this.tone,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 클럽 이름 + (진행 중이면) 이퀄라이저.
        Row(
          children: [
            Flexible(
              child: Text(
                set.club,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 17.sp,
                  height: 19 / 17,
                  letterSpacing: 17 * -0.025,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            if (live) ...[
              SizedBox(width: 7.w),
              const EdmEqualizer(color: kEdmHot, size: 12, bars: 3),
            ],
          ],
        ),
        SizedBox(height: 7.h),
        // DJ.
        Row(
          children: [
            Icon(Icons.bolt_rounded, size: 13.r, color: tone),
            SizedBox(width: 3.w),
            Text(
              set.dj,
              style: VybeTypography.caption.copyWith(
                fontSize: 12.5.sp,
                height: 14 / 12.5,
                fontWeight: FontWeight.w700,
                color: tone,
              ),
            ),
          ],
        ),
        SizedBox(height: 9.h),
        // 지역 · 거리 · 진행 상태.
        Row(
          children: [
            Flexible(
              child: Text(
                set.dist == null
                    ? set.area
                    : '${set.area} · ${set.dist!.toStringAsFixed(1)}km',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: VybeTypography.caption.copyWith(
                  fontSize: 11.sp,
                  height: 12 / 11,
                  color: VybeColors.gray500,
                ),
              ),
            ),
            const VybeMetaDot(size: 2),
            Text(
              statusText,
              style: VybeTypography.caption.copyWith(
                fontSize: 11.sp,
                height: 12 / 11,
                fontWeight: FontWeight.w600,
                color: VybeColors.gray500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
