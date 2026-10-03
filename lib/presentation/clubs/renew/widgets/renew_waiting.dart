import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/data/models/v1/waiting_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_button.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_stepper.dart';

// ============================================================================
// CLUB-026 클럽 상세 · 웨이팅 — 실시간 카드 · 등록 시트 · 코치마크
//
// 디자인 `club_waiting_sheet.jsx` (VWLiveCard · VWSheet · VWStat · VWCoach).
//
// ⚠ CLUB-021 과 CLUB-026 은 **같은 화면의 두 변형**이다 — 디자인에서 두 파일의
// 차이는 ① 홈 첫 섹션 VWLiveCard ② 하단 바 웨이팅 버튼이 시트를 여는지 ③ 안내
// 문구 한 줄뿐이다. 앱은 화면이 하나라 여기 조각을 그 한 화면에 얹는다.
// ============================================================================

/// 디자인 `VW_NOTICE` — 등록 시트 유의사항 본문.
const String kWaitingNotice =
    '웨이팅 등록 후, 방문을 하지 않으면 방문 이력이 노쇼로 처리될 수 있습니다. '
    '노쇼로 처리될 경우, 이후 서비스 이용에 제한이 생길 수 있으니 이 점 확인 부탁드립니다.';

/// 호출 후 자동 취소까지 (디자인 `VW.callHold`).
const int kWaitingCallHoldMinutes = 10;

/// 숫자 + 단위 (디자인 VWStat) — 라임 강조.
class RenewWaitingStat extends StatelessWidget {
  final String label;
  final int value;
  final String unit;

  /// 디자인 size — 카드 30, 시트 34.
  final double size;

  const RenewWaitingStat({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: VybeTypography.body4.copyWith(color: RenewGlass.t3),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$value',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: size.sp,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: size * -0.03,
                  color: VybeColors.mainLime500,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                unit,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: (size * 0.47).sp,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  letterSpacing: size * 0.47 * -0.025,
                  color: VybeColors.mainLime500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 라임 점 (펄스) — 실시간이라는 표시.
class RenewLivePulseDot extends StatefulWidget {
  final double size;
  final Color color;

  const RenewLivePulseDot({
    super.key,
    this.size = 6,
    this.color = VybeColors.mainLime500,
  });

  @override
  State<RenewLivePulseDot> createState() => _RenewLivePulseDotState();
}

class _RenewLivePulseDotState extends State<RenewLivePulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.45).animate(_c),
      child: Container(
        width: widget.size.r,
        height: widget.size.r,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

/// 홈 탭 **첫 섹션** '실시간 웨이팅' 카드 (디자인 VWLiveCard).
///
/// 티켓이 있으면 카드가 라임으로 바뀌고 숫자가 '내 대기 순번'이 된다.
///
/// ⚠ 숫자는 전부 `ops/live` 에서 온다 — 화면이 예상 대기시간을 계산하지 않는다
/// (팀 수 × 팀당 기준 시간은 [ClubOpsLive.estimatedWaitMinutes]).
class RenewWaitingLiveCard extends StatelessWidget {
  final ClubOpsLive live;
  final ClubOpsSettings? settings;

  /// 내 웨이팅 티켓. null 이면 등록 전.
  final WaitingModel? ticket;

  final VoidCallback onOpen;

  const RenewWaitingLiveCard({
    super.key,
    required this.live,
    required this.settings,
    required this.ticket,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final done = ticket != null;
    final perTeam = settings?.perTeamMin ?? live.waiting.perTeamMinToday;
    final wait = done
        ? live.waiting.aheadOf(ticket!.seq) * perTeam
        : live.estimatedWaitMinutes(perTeam);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RenewSectionHead(title: '실시간 웨이팅', sub: done ? '내 순번' : '온라인 등록 가능'),
        RenewGlassCard(
          padding: 16,
          fill: done ? V1Colors.limeTint10 : null,
          border: done ? V1Colors.limeTint30Border : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    RenewWaitingStat(
                      label: done ? '내 대기 순번' : '현재 웨이팅',
                      value: done ? ticket!.seq : live.waiting.waitingCount,
                      unit: done ? '번째' : '팀',
                    ),
                    Container(width: 1, height: 44.h, color: RenewGlass.hair),
                    RenewWaitingStat(label: '예상 대기시간', value: wait, unit: '분'),
                  ],
                ),
              ),
              const Divider(height: 1, color: RenewGlass.hair),
              Padding(
                padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 16.h),
                child: Row(
                  children: [
                    const RenewLivePulseDot(),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        done
                            ? '${ticket!.people}명으로 등록됨 · 순서가 되면 알려드려요'
                            : '방금 전 업데이트 · 현장 상황에 따라 달라질 수 있어요',
                        style: RenewGlass.caption(
                          color: RenewGlass.t3,
                          lineHeight: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RenewButton(
                label: done ? '내 웨이팅 보기' : '웨이팅 등록',
                variant: done
                    ? RenewButtonVariant.quiet
                    : RenewButtonVariant.lime,
                onTap: onOpen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 진입 0.9초 뒤 하단 바 웨이팅 버튼을 가리키는 코치마크 (디자인 VWCoach).
class RenewWaitingCoach extends StatelessWidget {
  final VoidCallback onClose;

  const RenewWaitingCoach({super.key, required this.onClose});

  /// 디자인 `bottom: 100` · `left: PAGE_H + 62`.
  static const double bottomOffset = 100;
  static const double leftOffset = RenewGlass.pagePad + 62;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: leftOffset.w,
      bottom: bottomOffset.h,
      // ⚠ 말풍선이 **스크롤을 먹지 않게** 한다 — 하단 바 바로 위라 손가락이 자주
      // 닿는 자리다. translucent 만으로는 모자라다(자식이 색을 칠한 Container 라
      // hitTestChildren 이 true 를 돌려줘 Stack 이 거기서 멈춘다).
      // 그림을 IgnorePointer 로 감싸 **탭만** 제스처 아레나에 올린다 —
      // 탭이면 말풍선이 닫히고, 드래그면 아래 스크롤이 가져간다.
      child: GestureDetector(
        onTap: onClose,
        behavior: HitTestBehavior.translucent,
        child: IgnorePointer(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: VybeColors.mainPurple500,
                  borderRadius: BorderRadius.circular(999.r),
                  boxShadow: [
                    BoxShadow(
                      color: VybeColors.mainPurple500.withValues(alpha: 0.45),
                      blurRadius: 26,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Text(
                  '온라인 웨이팅 등록이 가능한 곳이에요!',
                  style: VybeTypography.button2.copyWith(color: Colors.white),
                ),
              ),
              // 45° 회전한 꼬리 — 아래 버튼을 가리킨다.
              Positioned(
                left: 46.w,
                bottom: -4.h,
                child: Transform.rotate(
                  angle: 0.785398, // 45°
                  child: Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: BoxDecoration(
                      color: VybeColors.mainPurple500,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 등록 시트 (VWSheet)
// ============================================================================

/// 하단 모달 '웨이팅 등록 시트' (디자인 VWSheet).
///
/// 두 모습이다 — 등록 전(인원 스테퍼 + 유의사항)과 등록됨(순번 + 호출 안내).
///
/// ⚠ 인원 범위·대기 숫자는 전부 받아 온 값이다. 화면이 정하지 않는다
/// (설계: 순번 · 시간 구간은 서버가 확정).
class RenewWaitingSheet extends StatefulWidget {
  final String clubName;
  final ClubOpsLive live;
  final ClubOpsSettings? settings;
  final WaitingModel? ticket;

  /// 등록 — 입장비가 있으면 FEE 흐름, 없으면 WAIT 흐름으로 간다.
  final ValueChanged<int> onSubmit;

  /// 등록된 웨이팅 취소.
  final VoidCallback onCancelWaiting;

  const RenewWaitingSheet({
    super.key,
    required this.clubName,
    required this.live,
    required this.settings,
    required this.ticket,
    required this.onSubmit,
    required this.onCancelWaiting,
  });

  /// 시트를 띄운다. 디자인은 화면 안 모달이라 루트가 아니라 **현재 Navigator**에
  /// 띄운다(하단 바 위를 덮는다).
  static Future<void> show(
    BuildContext context, {
    required String clubName,
    required ClubOpsLive live,
    required ClubOpsSettings? settings,
    required WaitingModel? ticket,
    required ValueChanged<int> onSubmit,
    required VoidCallback onCancelWaiting,
  }) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x9E06050A), // rgba(6,5,10,0.62)
    isScrollControlled: true,
    builder: (_) => RenewWaitingSheet(
      clubName: clubName,
      live: live,
      settings: settings,
      ticket: ticket,
      onSubmit: onSubmit,
      onCancelWaiting: onCancelWaiting,
    ),
  );

  @override
  State<RenewWaitingSheet> createState() => _RenewWaitingSheetState();
}

class _RenewWaitingSheetState extends State<RenewWaitingSheet> {
  /// 디자인 기본 2명.
  late int _people = 2;

  @override
  Widget build(BuildContext context) {
    final done = widget.ticket != null;
    final s = widget.settings;
    final perTeam = s?.perTeamMin ?? widget.live.waiting.perTeamMinToday;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        RenewGlass.pagePad.w,
        10.h,
        RenewGlass.pagePad.w,
        (safeBottom > 30.h ? safeBottom : 30.h),
      ),
      decoration: BoxDecoration(
        color: const Color(0xF017151F), // rgba(23,21,31,0.94)
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: const Border(
          top: BorderSide(color: Color(0x24FFFFFF)), // rgba(255,255,255,.14)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 50,
            offset: const Offset(0, -18),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 그래버 바
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 14.h),
              decoration: BoxDecoration(
                color: const Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Text(
              widget.clubName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: VybeTypography.heading4.copyWith(color: RenewGlass.t1),
            ),
          ),
          const Divider(height: 1, color: RenewGlass.hair),

          if (done) _ticketBlock(perTeam) else _statBlock(perTeam),
          const Divider(height: 1, color: RenewGlass.hair),

          if (!done)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '인원',
                    style: VybeTypography.button1.copyWith(
                      color: RenewGlass.t1,
                    ),
                  ),
                  VybeStepper(
                    value: _people,
                    min: s?.minPeople ?? 1,
                    max: s?.maxPeople ?? 8,
                    onChanged: (v) => setState(() => _people = v),
                  ),
                ],
              ),
            ),

          Container(
            margin: EdgeInsets.only(top: done ? 20.h : 0),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0x0DFFFFFF), // rgba(255,255,255,0.05)
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: RenewGlass.hair),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  done ? '호출 안내' : '매장 웨이팅 유의사항',
                  style: VybeTypography.button2.copyWith(color: RenewGlass.t1),
                ),
                SizedBox(height: 8.h),
                Text(
                  done
                      ? '순서가 되면 알림을 보내드려요. 호출 후 '
                            '$kWaitingCallHoldMinutes분 내 미입장 시 자동으로 순번이 '
                            '취소될 수 있습니다.'
                      : kWaitingNotice,
                  style: VybeTypography.body4.copyWith(
                    height: 21 / 14,
                    color: RenewGlass.t3,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  done ? '매장 사정에 따라 대기시간은 달라질 수 있어요.' : '웨이팅을 등록하면 알림을 드립니다.',
                  style: VybeTypography.body4.copyWith(
                    height: 21 / 14,
                    color: RenewGlass.t3,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: RenewButton(
                  label: done ? '닫기' : '취소',
                  variant: RenewButtonVariant.quiet,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                flex: done ? 1 : 2,
                child: done
                    ? _cancelButton()
                    : RenewButton(
                        label: '웨이팅 등록',
                        onTap: () => widget.onSubmit(_people),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 등록 전 — 현재 웨이팅 / 예상 대기시간 2분할.
  Widget _statBlock(int perTeam) => Padding(
    padding: EdgeInsets.symmetric(vertical: 20.h),
    child: Row(
      children: [
        RenewWaitingStat(
          label: '현재 웨이팅',
          value: widget.live.waiting.waitingCount,
          unit: '팀',
          size: 34,
        ),
        Container(width: 1, height: 48.h, color: RenewGlass.hair),
        RenewWaitingStat(
          label: '예상 대기시간',
          value: widget.live.estimatedWaitMinutes(perTeam),
          unit: '분',
          size: 34,
        ),
      ],
    ),
  );

  /// 등록됨 — '대기중' pill + 큰 순번.
  Widget _ticketBlock(int perTeam) {
    final t = widget.ticket!;
    final wait = widget.live.waiting.aheadOf(t.seq) * perTeam;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: V1Colors.limeTint14,
              borderRadius: BorderRadius.circular(99.r),
              border: Border.all(color: V1Colors.limeTint30Border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RenewLivePulseDot(size: 5),
                SizedBox(width: 6.w),
                Text(
                  '대기중',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12.sp,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 12 * -0.025,
                    color: VybeColors.mainLime500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${t.seq}',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 44.sp,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 44 * -0.03,
                  color: VybeColors.mainLime500,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                '번째',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20.sp,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 20 * -0.025,
                  color: VybeColors.mainLime500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '예상 대기시간 약 $wait분 · ${t.people}명',
            style: VybeTypography.body4.copyWith(color: RenewGlass.t3),
          ),
        ],
      ),
    );
  }

  /// '웨이팅 취소' — 되돌릴 수 없어 붉은 아웃라인(디자인 VWSheet).
  Widget _cancelButton() => GestureDetector(
    onTap: widget.onCancelWaiting,
    behavior: HitTestBehavior.opaque,
    child: Container(
      height: 56.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: V1Colors.redTint14,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: V1Colors.redTint32),
      ),
      child: Text(
        '웨이팅 취소',
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 18 * -0.025,
          color: VybeColors.accentRed500,
        ),
      ),
    ),
  );
}
