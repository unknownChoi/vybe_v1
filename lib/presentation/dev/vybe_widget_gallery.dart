import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_button.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_bottom_action_bar.dart';
import 'package:vybe/presentation/common/widgets/vybe_gradient_spinner.dart';
import 'package:vybe/presentation/common/widgets/vybe_kv.dart';
import 'package:vybe/presentation/common/widgets/vybe_min_spend_gauge.dart';
import 'package:vybe/presentation/common/widgets/vybe_note.dart';
import 'package:vybe/presentation/common/widgets/vybe_pin_input.dart';
import 'package:vybe/presentation/common/widgets/vybe_qr_panel.dart';
import 'package:vybe/presentation/common/widgets/vybe_result_view.dart';
import 'package:vybe/presentation/common/widgets/vybe_segment_tabs.dart';
import 'package:vybe/presentation/common/widgets/vybe_status_badge.dart';
import 'package:vybe/presentation/common/widgets/vybe_step_indicator.dart';
import 'package:vybe/presentation/common/widgets/vybe_stepper.dart';
import 'package:vybe/presentation/common/widgets/vybe_ticket_card.dart';

/// v1 공용 위젯 미리보기. 개발 메뉴에서만 연다.
///
/// 디자인 원본과 나란히 놓고 **문구 · 간격 · 색 · 모서리 · 상태별 모습**을 대조하는 화면이다.
/// 값은 전부 `FakeSample`(= 디자인 원문 값)을 쓴다.
class VybeWidgetGallery extends StatefulWidget {
  const VybeWidgetGallery({super.key});

  @override
  State<VybeWidgetGallery> createState() => _VybeWidgetGalleryState();
}

class _VybeWidgetGalleryState extends State<VybeWidgetGallery> {
  int _seg = 0;
  int _people = 2;

  String _won(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '$buf원';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const VybeAurora(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                    Text(
                      '공용 위젯 미리보기',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
                    children: [
                      _h('VybeStatusBadge — 상태 배지'),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: const [
                          VybeStatusBadge('대기중', tone: VybeBadgeTone.waiting, dot: true),
                          VybeStatusBadge('호출됨', tone: VybeBadgeTone.called),
                          VybeStatusBadge('입장 완료', tone: VybeBadgeTone.entered),
                          VybeStatusBadge('접수됨', tone: VybeBadgeTone.pending),
                          VybeStatusBadge('취소됨', tone: VybeBadgeTone.done),
                          VybeStatusBadge('결제 실패', tone: VybeBadgeTone.error),
                        ],
                      ),

                      _h('VybeTicketCard — 티켓 (헤더 톤 5종)'),
                      VybeTicketCard(
                        clubName: FakeSample.clubName,
                        subtitle: '07월 04일 금요일 · 오후 8:12 · 입장 대기 중',
                        tone: VybeTicketTone.purple,
                        badge: const VybeStatusBadge(
                          '대기중',
                          tone: VybeBadgeTone.waiting,
                          dot: true,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VybeTicketBigNumber(
                              label: '내 대기 번호',
                              value: '5',
                              unit: '번',
                            ),
                            SizedBox(height: 14.h),
                            const VybeTicketStats(
                              items: [
                                ('앞에 남은 팀', '2팀', null),
                                ('인원', '2명', null),
                                ('예상 대기', '20:00', VybeColors.mainLime500),
                              ],
                            ),
                            const VybeTicketStub(
                              kindLabel: 'ENTRY PASS',
                              serial: 'WT-2607-0005',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const VybeTicketCard(
                        clubName: FakeSample.clubName,
                        subtitle: '07월 04일 금요일 · 오후 8:32 · 입장해 주세요',
                        tone: VybeTicketTone.lime,
                        badge: VybeStatusBadge('호출됨', tone: VybeBadgeTone.called),
                        child: VybeTicketBigNumber(
                          label: '입장 마감까지',
                          value: '09:21',
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const VybeTicketCard(
                        clubName: FakeSample.clubName,
                        subtitle: '07월 04일 금요일 · 방문하지 않아 종료됐어요',
                        tone: VybeTicketTone.gray,
                        dimmed: true,
                        badge: VybeStatusBadge('만료', tone: VybeBadgeTone.done),
                        child: VybeTicketStats(
                          items: [('위약금', '100%', null), ('환불', '없음', null)],
                        ),
                      ),

                      _h('VybeQrPanel · VybeQrLockCapsule'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          VybeQrPanel(
                            payload: 'WT-2607-0005',
                            size: 140.r,
                            remainSeconds: 599,
                            onRefresh: () {},
                          ),
                          VybeQrLockCapsule(
                            message: '입장 순서가 되면 열려요',
                            size: 140.r,
                          ),
                        ],
                      ),

                      _h('VybeKvCard · VybeAmountCard'),
                      const VybeKvCard(
                        rows: [
                          VybeKvRow('매장', '어썸레드'),
                          VybeKvRow('인원', '2명'),
                          VybeKvRow('결제 수단', '신용카드 · 신한'),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      const VybeAmountCard(
                        label: '환불 내역',
                        rows: [
                          ('결제 금액', '1,000,000원'),
                          ('테이블 패널티 20%', '-60,000원'),
                          ('취소 수수료 3%', '-30,000원'),
                        ],
                        totalLabel: '돌려받는 금액',
                        total: '910,000원',
                        tone: VybeRefundTone.part,
                      ),

                      _h('VybeNoteBox · VybeInlineBanner'),
                      const VybeInlineBanner('결제 완료 구간이라 전액 환불돼요'),
                      SizedBox(height: 10.h),
                      const VybeInlineBanner(
                        '매장이 만들기를 시작하면 취소할 수 없어요',
                        tone: VybeInlineBannerTone.amber,
                      ),
                      SizedBox(height: 10.h),
                      const VybeNoteBox(
                        bullets: [
                          '만석이면 조기 마감될 수 있어요.',
                          '호출 후 10분 안에 입장하지 않으면 자동 취소돼요.',
                        ],
                      ),

                      _h('VybeStepIndicator'),
                      const VybeStepIndicator(
                        labels: ['결제 요청', '결제 확인', '순번 발급', '등록 완료'],
                        current: 1,
                      ),

                      _h('VybeSegmentTabs'),
                      VybeSegmentTabs(
                        labels: const ['입장권', '예약', '주문', '이용 내역'],
                        counts: const [2, 1, 1, 0],
                        index: _seg,
                        onChanged: (i) => setState(() => _seg = i),
                      ),

                      _h('VybeStepper'),
                      Center(
                        child: VybeStepper(
                          value: _people,
                          onChanged: (v) => setState(() => _people = v),
                          min: 1,
                          max: 8,
                          unit: '명',
                        ),
                      ),

                      _h('VybeMinSpendGauge'),
                      VybeMinSpendGauge(
                        current: 320000,
                        minimum: FakeSample.minSpend,
                        format: _won,
                      ),
                      SizedBox(height: 14.h),
                      VybeMinSpendGauge(
                        current: 545500,
                        minimum: FakeSample.minSpend,
                        format: _won,
                      ),

                      _h('VybePinInput · VybeSerialRow'),
                      const VybePinInput(
                        length: 6,
                        onCompleted: _noop,
                        hint: '남은 시도 4회',
                        autofocus: false,
                      ),
                      SizedBox(height: 12.h),
                      const VybeSerialRow(serial: FakeSample.shareSerial),

                      _h('VybeGradientSpinner'),
                      const Center(child: VybeGradientSpinner()),

                      _h('VybeResultView'),
                      SizedBox(
                        height: 430.h,
                        child: const VybeResultView(
                          icon: Icons.check_rounded,
                          tone: VybeResultTone.success,
                          title: '웨이팅 등록이\n완료됐어요',
                          description: '순서가 되면 알림으로 알려드릴게요.',
                          children: [
                            VybeKvCard(
                              rows: [
                                VybeKvRow('내 대기 번호', '5번'),
                                VybeKvRow('앞에 남은 팀', '2팀'),
                                VybeKvRow('결제 금액', '40,000원'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      _h('VybeBottomActionBar'),
                      VybeBottomActionBar(
                        caption: '취소하면 되돌릴 수 없어요',
                        children: [
                          Expanded(
                            child: RenewButton(
                              label: '돌아가기',
                              variant: RenewButtonVariant.quiet,
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: RenewButton(label: '취소하기', onTap: () {}),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _noop(String _) {}

  Widget _h(String t) => Padding(
    padding: EdgeInsets.only(top: 26.h, bottom: 12.h),
    child: Text(
      t,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: VybeColors.mainLime500,
      ),
    ),
  );
}
