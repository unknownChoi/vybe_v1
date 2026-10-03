import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/config/backend_env.dart';
import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/datasources/fake/fake_waiting_datasource.dart';
import 'package:vybe/data/models/v1/share_model.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/widgets/vybe_bottom_action_bar.dart';
import 'package:vybe/presentation/common/widgets/vybe_kv.dart';
import 'package:vybe/presentation/common/widgets/vybe_note.dart';
import 'package:vybe/presentation/common/widgets/vybe_qr_panel.dart';
import 'package:vybe/presentation/common/widgets/vybe_segment_tabs.dart';
import 'package:vybe/presentation/common/widgets/vybe_status_badge.dart';
import 'package:vybe/presentation/common/widgets/vybe_step_indicator.dart';
import 'package:vybe/presentation/common/widgets/vybe_ticket_card.dart';

/// iPhone SE(375) 보다 좁은 360 에서도 터지지 않아야 한다.
Widget _host(Widget child) => ScreenUtilInit(
  designSize: const Size(393, 852),
  builder: (_, __) => MaterialApp(
    home: Scaffold(body: SizedBox(width: 360, child: child)),
  ),
);

void main() {
  group('v1 상태 enum — 설계 4장 키와 글자 그대로여야 한다', () {
    test('모르는 값은 unknown 으로 떨어진다(서버가 상태를 늘려도 앱이 안 죽는다)', () {
      expect(WaitingStatus.from('waiting'), WaitingStatus.waiting);
      expect(WaitingStatus.from('호출됨'), WaitingStatus.unknown);
      expect(ReservationStatus.from('converted'), ReservationStatus.converted);
      expect(OrderStatus.from('making'), OrderStatus.making);
      expect(PaymentMethod.from('kakaopay'), PaymentMethod.kakaopay);
    });

    test('웨이팅 종료 상태 판정', () {
      expect(WaitingStatus.waiting.isClosed, isFalse);
      expect(WaitingStatus.called.isClosed, isFalse);
      expect(WaitingStatus.noShow.isClosed, isTrue);
      expect(WaitingStatus.cancelled.isClosed, isTrue);
    });

    test('입장권 전환 뒤에는 취소·변경이 막힌다', () {
      expect(ReservationStatus.confirmed.isConvertedOrLater, isFalse);
      expect(ReservationStatus.converted.isConvertedOrLater, isTrue);
      expect(ReservationStatus.entered.isConvertedOrLater, isTrue);
    });

    test('주문 취소는 결제 완료 구간에서만', () {
      expect(OrderStatus.paid.userCancellable, isTrue);
      expect(OrderStatus.making.userCancellable, isFalse);
    });

    test('입장비 결제 수단에는 무통장·상품권이 없다', () {
      expect(PaymentMethod.entryFeeMethods, isNot(contains(PaymentMethod.bank)));
      expect(PaymentMethod.entryFeeMethods, isNot(contains(PaymentMethod.gift)));
      expect(PaymentMethod.fullMethods, contains(PaymentMethod.bank));
    });
  });

  group('Fake datasource', () {
    setUp(() => fakeScenario.value = FakeScenario.normal);
    tearDown(() => fakeScenario.value = FakeScenario.normal);

    test('기본 시나리오는 디자인 예시 티켓을 돌려준다', () async {
      final ds = FakeWaitingDataSource();
      final list = await ds.watchMyWaitings('uid').first;
      expect(list, isNotEmpty);
      expect(list.first.code, 'WT-2607-0005');
      expect(list.first.clubName, FakeSample.clubName);
    });

    test('빈 상태 시나리오는 0건', () async {
      fakeScenario.value = FakeScenario.empty;
      final ds = FakeWaitingDataSource();
      expect(await ds.watchMyWaitings('uid').first, isEmpty);
    });

    test('실패 시나리오는 예외를 던진다', () async {
      fakeScenario.value = FakeScenario.failure;
      final ds = FakeWaitingDataSource();
      expect(
        () => ds.watchMyWaitings('uid').first,
        throwsA(isA<FakeDataException>()),
      );
    });

    test('만료 시나리오의 QR 은 이미 지난 토큰', () async {
      fakeScenario.value = FakeScenario.expired;
      final ds = FakeWaitingDataSource();
      final qr = await ds.issueEntryQr('c', 'w');
      expect(qr.isExpired(DateTime.now()), isTrue);
      expect(qr.remainSeconds(DateTime.now()), 0);
    });

    test('등록은 금액을 보내지 않는다 — 서버(Fake)가 총액을 정한다', () async {
      final ds = FakeWaitingDataSource();
      final w = await ds.registerWaiting(
        clubId: 'c',
        people: 3,
        noticeAgreed: true,
        lat: 37.5,
        lng: 127.0,
      );
      expect(w.fee.people, 3);
      expect(w.fee.total, FakeSample.entryFeeUnit * 3);
    });
  });

  test('VYBE_BACKEND 기본값은 fake — UI 단계에서 운영에 붙지 않는다', () {
    expect(kVybeBackend, VybeBackend.fake);
    expect(kUsesFakeBackend, isTrue);
  });

  test('공유 비밀번호 규칙은 디자인 값과 같다', () {
    expect(ShareLinkRule.passwordLength, 6);
    expect(ShareLinkRule.maxAttempts, 5);
    expect(ShareLinkRule.lockDuration, const Duration(minutes: 30));
  });

  test('mm:ss 포맷 — 음수는 00:00', () {
    expect(vybeFormatMmSs(599), '09:59');
    expect(vybeFormatMmSs(45), '00:45');
    expect(vybeFormatMmSs(-3), '00:00');
  });

  test('배지 톤 — error 는 결제 실패 전용이라 취소와 색이 다르다', () {
    expect(VybeBadgeTone.error.text, V1Colors.red300);
    expect(VybeBadgeTone.done.text, isNot(V1Colors.red300));
  });

  testWidgets('공용 위젯이 좁은 기기(360)에서 오버플로 없이 그려진다', (tester) async {
    final cases = <String, Widget>{
      'StatusBadge': const VybeStatusBadge('대기중', tone: VybeBadgeTone.waiting, dot: true),
      'KvCard': const VybeKvCard(
        rows: [
          VybeKvRow('결제 수단', '신용카드 · 신한'),
          VybeKvRow('등록 예정', '07월 04일 (금) · 오후 8:12'),
        ],
      ),
      'AmountCard': const VybeAmountCard(
        label: '환불 내역',
        rows: [('결제 금액', '1,000,000원'), ('테이블 패널티 20%', '-60,000원')],
        totalLabel: '돌려받는 금액',
        total: '910,000원',
        tone: VybeRefundTone.part,
      ),
      'NoteBox': const VybeNoteBox(bullets: ['만석이면 조기 마감될 수 있어요.']),
      'InlineBanner': const VybeInlineBanner('결제 완료 구간이라 전액 환불돼요'),
      'StepIndicator': const VybeStepIndicator(
        labels: ['결제 요청', '결제 확인', '순번 발급', '등록 완료'],
        current: 1,
      ),
      'SegmentTabs': VybeSegmentTabs(
        labels: const ['입장권', '예약', '주문', '이용 내역'],
        counts: const [2, 1, 1, 0],
        index: 0,
        onChanged: (_) {},
      ),
      'TicketCard': const VybeTicketCard(
        clubName: FakeSample.clubName,
        subtitle: '07월 04일 금요일 · 오후 8:12 · 입장 대기 중',
        tone: VybeTicketTone.purple,
        badge: VybeStatusBadge('대기중', tone: VybeBadgeTone.waiting),
        child: VybeTicketStats(
          items: [
            ('앞에 남은 팀', '2팀', null),
            ('인원', '2명', null),
            ('예상 대기', '20:00', null),
          ],
        ),
      ),
      'BottomActionBar': VybeBottomActionBar(
        caption: '취소하면 되돌릴 수 없어요',
        children: [
          Expanded(child: Container(height: 56, color: Colors.purple)),
          Expanded(flex: 2, child: Container(height: 56, color: Colors.purple)),
        ],
      ),
    };
    for (final entry in cases.entries) {
      await tester.pumpWidget(_host(SingleChildScrollView(child: entry.value)));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull, reason: entry.key);
    }
  });
}
