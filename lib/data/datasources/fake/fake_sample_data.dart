import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/data/models/v1/order_model.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/models/v1/payment_model.dart';
import 'package:vybe/data/models/v1/reservation_model.dart';
import 'package:vybe/data/models/v1/share_model.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';
import 'package:vybe/data/models/v1/waiting_model.dart';

/// Fake datasource 가 쓰는 예시 데이터.
///
/// ⚠ 값은 **디자인 원본(`design/user/extracted/new_func_*.jsx`)에 찍힌 것 그대로**다 —
/// 매장명 · 날짜 · 시간 · 인원 · 금액 · 번호를 지어내지 않는다(CLAUDE.md v1 규칙).
/// 화면을 디자인과 나란히 놓고 볼 수 있어야 하기 때문이다.
class FakeSample {
  const FakeSample._();

  // ── 매장 ────────────────────────────────────────────────
  /// 주 매장 — 웨이팅 · 예약 · 주문 · 공유 전 화면 공통.
  static const String clubId = 'club_awsome_red';
  static const String clubName = '어썸레드';
  static const String clubArea = '홍대';
  static const String clubGenre = '힙합';

  /// 입장권 덱의 추가 매장.
  static const String club2Id = 'club_laser';
  static const String club2Name = '홍대 클럽 레이저';

  /// 영업일 — 디자인의 07월 04일 (금).
  static const String businessDate = '20260704';

  /// 디자인 화면들이 기준으로 삼는 '지금'. 상대 시각 계산을 고정하려고 둔다.
  static DateTime get now => DateTime(2026, 7, 4, 20, 12);

  static DateTime _at(int h, int m) => DateTime(2026, 7, 4, h, m);

  // ── 웨이팅 (WAIT · FEE) ──────────────────────────────────
  /// 1인 입장비. 디자인 `WF_FEE`.
  static const int entryFeeUnit = 20000;

  static WaitingModel get waiting => WaitingModel(
    waitingId: 'wt_0005',
    code: 'WT-2607-0005',
    clubId: clubId,
    clubName: clubName,
    uid: 'fake_uid',
    businessDate: businessDate,
    seq: 5,
    people: 2,
    status: WaitingStatus.waiting,
    fee: const WaitingFee(
      unit: entryFeeUnit,
      people: 2,
      total: 40000,
      settingsVersion: 3,
    ),
    paymentId: 'pay_wt_0005',
    payment: TicketPaymentSummary(
      status: PaymentStatus.paid,
      method: PaymentMethod.card,
      cardCompany: '신한',
      paidAt: _at(20, 11),
      approvalNo: '30124578',
    ),
    noticeAgreed: true,
    locationChecked: true,
    createdAt: _at(20, 12),
    updatedAt: _at(20, 12),
  );

  /// 호출된 티켓 — 입장 마감 10분(600초) 카운트다운.
  static WaitingModel get waitingCalled => waiting.copyWith(
    status: WaitingStatus.called,
    calledAt: _at(20, 32),
    callDeadline: _at(20, 42),
  );

  /// 입장 완료 티켓 — 스탬프 20:32.
  static WaitingModel get waitingEntered => waiting.copyWith(
    status: WaitingStatus.entered,
    calledAt: _at(20, 32),
    enteredAt: _at(20, 32),
    share: TicketShareSummary(
      serial: shareSerial,
      status: ShareLinkStatus.active,
      receivedCount: 2,
      lastReceivedAt: _at(21, 10),
      passwordSetAt: _at(20, 50),
    ),
  );

  /// 순서를 미룬 티켓 — 5번 → 14번.
  static WaitingModel get waitingPostponed =>
      waiting.copyWith(seq: 14, postponed: true, postponeCount: 1);

  /// 취소된 티켓 — 오후 8:40.
  static WaitingModel get waitingCancelled => waiting.copyWith(
    status: WaitingStatus.cancelled,
    cancelledAt: _at(20, 40),
    cancelledBy: CancelledBy.user,
    refund: const TicketRefundSummary(
      refundId: 'rf_wt_0005',
      status: RefundStatus.done,
      amount: 40000,
      reason: RefundReason.userCancel,
    ),
  );

  /// 입장권 덱의 두 번째 매장 — 대기번호 12 · 앞 6팀.
  static WaitingModel get waitingOther => waiting.copyWith(
    waitingId: 'wt_0012',
    code: 'WT-2607-0012',
    clubId: club2Id,
    clubName: club2Name,
    seq: 12,
  );

  // ── 운영 상태 ───────────────────────────────────────────
  static const ClubOpsSettings opsSettings = ClubOpsSettings(
    entryFee: entryFeeUnit,
    minPeople: 1,
    maxPeople: 8,
    perTeamMin: 10,
    arrivalSlots: [
      ArrivalSlot(label: '19:30', enabled: false),
      ArrivalSlot(label: '20:00'),
      ArrivalSlot(label: '20:30'),
      ArrivalSlot(label: '21:00'),
      ArrivalSlot(label: '21:30'),
      ArrivalSlot(label: '22:00'),
    ],
    version: 3,
  );

  /// 디자인 '현재 웨이팅 2팀 · 예상 대기시간 40분'.
  static ClubOpsLive get opsLive => ClubOpsLive(
    businessDate: businessDate,
    phase: OpsPhase.open,
    waiting: const OpsLiveWaiting(
      accept: true,
      nextSeq: 8,
      queue: [4, 5, 6, 7],
      calledSeqs: [3],
      waitingCount: 4,
      calledCount: 1,
      enteredCount: 9,
      perTeamMinToday: 10,
    ),
    order: const OpsLiveOrder(
      accept: true,
      nextNo: 26,
      paidCount: 2,
      makingCount: 1,
      readyCount: 1,
      doneCount: 9,
    ),
    reservation: const OpsLiveReservation(
      todayCount: 3,
      convertedCount: 1,
      enteredCount: 1,
      pendingCount: 1,
    ),
    share: const OpsLiveShare(
      activeCount: 2,
      receivedCount: 3,
      enteredCount: 1,
    ),
    updatedAt: now,
  );

  // ── 알림 (HOME-007) ────────────────────────────────────
  /// 설계 4장 `unreadNotificationCount` 예시값 3 — 디자인 `NG_NOTIS` 의
  /// 안 읽은 건수(id 1 · 2 · 3)와 같다.
  static const int unreadNotificationCount = 3;

  /// 두 자리 — 배지가 숫자를 안 쓰는지(디자인은 점) 확인용.
  static const int unreadNotificationCountMany = 12;

  /// ⚠ 알림만 **실제 '지금'** 을 기준으로 만든다 — 다른 Fake 는 디자인 화면의
  /// 날짜([now], 2026-07-04)를 그대로 쓰지만, 알림 카드가 보여 주는 건
  /// '12분 전' 같은 **상대 시각**이라 고정 날짜를 쓰면 전부 '수개월 전'이 된다.
  static DateTime _ago(Duration d) => DateTime.now().subtract(d);

  /// 알림 센터 예시 — 디자인 `notifications_glass_shell.jsx` 의 `NG_NOTIS` 8건
  /// 그대로다(제목 · 본문 · 경과 시각 · 읽음 여부 · 이동 화면).
  ///
  /// `type` 은 설계 10장 유형 표의 값이고 `category` · `data.route` 도 그 표의
  /// '이동 화면' 열을 따른다. 디자인이 `href` 로 적어 둔 목적지와 설계의 이동
  /// 화면이 다르면 **설계를 따른다**(디자인 프로토타입은 호스트 html 로만 링크를
  /// 걸 수 있어 CLUB-021 로 몰려 있다).
  static List<AppNotificationModel> get notifications => [
    AppNotificationModel(
      notificationId: 'n_rsv_confirmed',
      type: 'reservation_confirmed',
      category: NotificationCategory.reservation,
      title: '$clubName 입장이 확정되었어요',
      body: '오늘 23:00 · 2인 · 게스트 입장. 입장 시 예약 코드를 보여주세요.',
      data: const {'route': 'RSV-052', 'clubId': clubId},
      dedupeKey: 'reservation_confirmed:rs_1182:1',
      createdAt: _ago(const Duration(minutes: 12)),
    ),
    AppNotificationModel(
      notificationId: 'n_club_showtime',
      type: 'club_showtime',
      category: NotificationCategory.club,
      title: '버뮤다 · 오늘 밤 게스트 DJ',
      body: '찜한 클럽에서 자정부터 DJ SOULSCAPE 단독 셋이 진행돼요.',
      data: const {'route': 'CLUB-021', 'clubId': club2Id},
      dedupeKey: 'club_showtime:$club2Id:1',
      createdAt: _ago(const Duration(minutes: 40)),
    ),
    AppNotificationModel(
      notificationId: 'n_promo',
      type: 'promo',
      category: NotificationCategory.promo,
      title: '주말 한정 입장권 30% 할인',
      body: '오늘 자정까지 강남 인기 클럽 6곳 입장권을 할인가로 예약하세요.',
      data: const {'route': 'HOME-006'},
      dedupeKey: 'promo:weekend30:1',
      createdAt: _ago(const Duration(hours: 2)),
    ),
    AppNotificationModel(
      notificationId: 'n_review_reaction',
      type: 'review_reaction',
      category: NotificationCategory.activity,
      title: '회원님의 리뷰가 인기를 얻고 있어요',
      body: '$clubName에 남긴 리뷰에 좋아요 12개와 댓글 3개가 달렸어요.',
      data: const {'route': 'MY-031'},
      read: true,
      dedupeKey: 'review_reaction:rv_1:1',
      createdAt: _ago(const Duration(hours: 5)),
    ),
    AppNotificationModel(
      notificationId: 'n_rsv_reminder',
      type: 'reservation_reminder_24h',
      category: NotificationCategory.reservation,
      title: '입장 24시간 전 안내',
      body: 'OCTAGON 예약이 내일 22:00로 예정되어 있어요. 드레스 코드를 확인하세요.',
      data: const {'route': 'PASS-036', 'clubId': clubId},
      read: true,
      dedupeKey: 'reservation_reminder_24h:rs_1182:1',
      createdAt: _ago(const Duration(days: 1)),
    ),
    AppNotificationModel(
      notificationId: 'n_review_request',
      type: 'review_request',
      category: NotificationCategory.review,
      title: '다녀온 클럽은 어땠나요?',
      body: '인클에서의 밤, 별점과 한 줄 후기를 남기면 다른 사람들에게 도움이 돼요.',
      data: const {'route': 'CLUB-028', 'clubId': club2Id},
      read: true,
      dedupeKey: 'review_request:$club2Id:1',
      createdAt: _ago(const Duration(days: 3)),
    ),
    AppNotificationModel(
      notificationId: 'n_club_news',
      type: 'club_news',
      category: NotificationCategory.club,
      title: '벨로주에 새 사진 12장이 올라왔어요',
      body: '찜한 재즈 클럽의 최근 분위기를 확인해보세요.',
      data: const {'route': 'CLUB-021', 'clubId': club2Id},
      read: true,
      dedupeKey: 'club_news:$club2Id:1',
      createdAt: _ago(const Duration(days: 7)),
    ),
    AppNotificationModel(
      notificationId: 'n_notice',
      type: 'notice',
      category: NotificationCategory.notice,
      title: 'vybe 예약 정책이 업데이트되었어요',
      body: '노쇼 방지를 위한 입장 확정 절차가 추가되었습니다. 자세히 보기.',
      data: const {'route': 'HOME-008'},
      read: true,
      dedupeKey: 'notice:policy_2607:1',
      createdAt: _ago(const Duration(days: 7)),
    ),
  ];

  /// 만료 시나리오용 — **안 읽은 알림 12건**([unreadNotificationCountMany]).
  /// 두 자리 배지를 확인하려고 기본 8건을 전부 안 읽음으로 돌리고 4건을 덧댄다.
  static List<AppNotificationModel> get notificationsMany => [
    for (final n in notifications) n.copyWith(read: false),
    for (var i = 0; i < 4; i++)
      AppNotificationModel(
        notificationId: 'n_more_$i',
        type: 'club_news',
        category: NotificationCategory.club,
        title: '찜한 클럽 소식이 ${i + 2}건 도착했어요',
        body: '$clubName · 이번 주 라인업이 올라왔어요.',
        data: const {'route': 'CLUB-021', 'clubId': clubId},
        dedupeKey: 'club_news:$clubId:${i + 2}',
        createdAt: _ago(Duration(days: 8 + i)),
      ),
  ];

  // ── 예약 (RSV) ─────────────────────────────────────────
  /// 디자인 메뉴 — LEMON DROP · HARD SET A · HARD SET B.
  static const List<OrderLine> menuLines = [
    OrderLine(
      menuId: 'm_hard_set_a',
      name: 'HARD SET A',
      qty: 1,
      unitPrice: 220000,
      options: [
        OrderLineOption(id: 'o_lemon', name: '레몬 슬라이스 추가 5P', price: 5500),
      ],
      lineTotal: 225500,
    ),
    OrderLine(
      menuId: 'm_hard_set_b',
      name: 'HARD SET B',
      qty: 1,
      unitPrice: 320000,
      lineTotal: 320000,
    ),
  ];

  /// 최소 주문금액 — 디자인 50만 원.
  static const int minSpend = 500000;

  static ReservationModel get reservation => ReservationModel(
    reservationId: 'rs_1182',
    code: 'RS-2607-1182',
    clubId: clubId,
    clubName: clubName,
    uid: 'fake_uid',
    guest: const ReservationGuest(name: '홍길동', phone: '01012341234'),
    date: '20260723',
    arrivalSlot: '20:00',
    arrivalAt: DateTime(2026, 7, 23, 20, 0),
    people: 3,
    tableId: 'T4',
    tableName: '테이블-4',
    tier: SeatTier.table,
    seatPrice: 300000,
    minSpend: minSpend,
    menuLines: menuLines,
    menuSubtotal: 545500,
    totalPaid: 545500,
    paymentId: 'pay_rs_1182',
    payment: TicketPaymentSummary(
      method: PaymentMethod.card,
      cardCompany: '신한',
      installment: 3,
      paidAt: _at(20, 12),
      approvalNo: '30124612',
    ),
    status: ReservationStatus.confirmed,
    freeCancelUntil: _at(20, 22),
    convertAt: DateTime(2026, 7, 23, 17, 0),
    policyVersion: '2026-07-01',
    policyAgreedAt: _at(20, 12),
    createdAt: _at(20, 12),
    updatedAt: _at(20, 12),
  );

  /// 접수됨(매장 확인 전).
  static ReservationModel get reservationPending =>
      reservation.copyWith(status: ReservationStatus.pending);

  /// 입장권으로 전환된 예약.
  static ReservationModel get reservationConverted => reservation.copyWith(
    status: ReservationStatus.converted,
    convertedAt: DateTime(2026, 7, 23, 17, 0),
  );

  /// 노쇼 결과 티켓 — 위약금 100% · 환불 없음.
  static ReservationModel get reservationNoShow => reservation.copyWith(
    status: ReservationStatus.noShow,
    noShow: ReservationNoShow(
      at: DateTime(2026, 7, 23, 21, 0),
      by: CancelledBy.system,
      penaltyRate: 100,
    ),
  );

  /// 디자인 달력의 마감 날짜.
  static const List<String> closedDates = ['20260711', '20260718', '20260719'];

  static ReservationDayModel get reservationDay => ReservationDayModel(
    date: '20260723',
    tables: const {
      'R1': ReservationDayTable(status: TableHoldStatus.booked),
      'R2': ReservationDayTable(status: TableHoldStatus.booked),
      'R5': ReservationDayTable(status: TableHoldStatus.booked),
      'T1': ReservationDayTable(status: TableHoldStatus.booked),
      'T2': ReservationDayTable(status: TableHoldStatus.booked),
      'T6': ReservationDayTable(status: TableHoldStatus.booked),
    },
    bookedCount: 6,
    updatedAt: now,
  );

  // ── 주문 (ORDER) ───────────────────────────────────────
  static OrderModel get order => OrderModel(
    orderId: 'od_017',
    no: '017',
    clubId: clubId,
    clubName: clubName,
    uid: 'fake_uid',
    businessDate: businessDate,
    entryRef: const EntryRef(
      type: EntryRefType.waiting,
      id: 'wt_0005',
      code: 'WT-2607-0005',
    ),
    tableLabel: '테이블-4',
    pickup: '바 카운터',
    lines: menuLines,
    total: 545500,
    paymentId: 'pay_od_017',
    payment: TicketPaymentSummary(
      method: PaymentMethod.card,
      cardCompany: '신한',
      paidAt: _at(21, 12),
      approvalNo: '30124700',
      cardMasked: '5327-****-****-1234',
    ),
    status: OrderStatus.paid,
    timeline: OrderTimeline(paidAt: _at(21, 12)),
    createdAt: _at(21, 12),
    updatedAt: _at(21, 12),
  );

  static OrderModel get orderMaking => order.copyWith(
    status: OrderStatus.making,
    timeline: order.timeline.copyWith(makingAt: _at(21, 14)),
  );

  static OrderModel get orderReady => order.copyWith(
    status: OrderStatus.ready,
    timeline: order.timeline.copyWith(
      makingAt: _at(21, 14),
      readyAt: _at(21, 22),
    ),
  );

  static OrderModel get orderRejected => order.copyWith(
    status: OrderStatus.rejected,
    reject: OrderReject(
      at: _at(21, 15),
      reason: OrderRejectReason.soldOut,
      markSoldOut: true,
    ),
    refund: const TicketRefundSummary(
      refundId: 'rf_od_017',
      status: RefundStatus.processing,
      amount: 545500,
      reason: RefundReason.reject,
    ),
  );

  // ── 공유 (SHARE) ───────────────────────────────────────
  /// 디자인 일련번호.
  static const String shareSerial = 'ARD-4F9K-2Q71';

  /// 디자인 딥링크.
  static const String shareUrl = 'vybe.app/s/$shareSerial';

  static SharePreviewModel get sharePreview => SharePreviewModel(
    serial: shareSerial,
    clubName: clubName,
    date: businessDate,
    enteredAt: _at(20, 32),
    people: 1,
    status: ShareLinkStatus.active,
    ticketType: EntryRefType.waiting,
  );

  static SharedTicketModel get sharedTicket => SharedTicketModel(
    sharedTicketId: 'sh_0002_s2',
    serial: shareSerial,
    source: const EntryRef(
      type: EntryRefType.waiting,
      id: 'wt_0002',
      code: 'WT-2607-0002',
    ),
    recipientUid: 'fake_uid',
    code: 'WT-2607-0002-S2',
    businessDate: businessDate,
    clubId: clubId,
    clubName: clubName,
    people: 1,
    status: SharedTicketStatus.active,
    createdAt: _at(21, 2),
  );

  // ── 결제 ───────────────────────────────────────────────
  /// 디자인 카드사 목록.
  static const List<String> cardCompanies = [
    '신한', '현대', '비씨', 'KB국민', '삼성', '롯데',
    '하나', 'NH', '우리', '광주', '씨티', '전북', '카카오뱅크',
  ];

  /// 디자인 할부 목록.
  static const List<String> installments = [
    '일시불',
    '2개월 (무이자)',
    '3개월 (무이자)',
    '4개월',
    '5개월',
    '6개월',
    '7개월',
    '8개월',
    '9개월',
    '10개월',
    '11개월',
    '12개월',
  ];

  static PaymentModel get payment => PaymentModel(
    paymentId: 'pay_wt_0005',
    uid: 'fake_uid',
    clubId: clubId,
    kind: PaymentKind.waitingFee,
    targetRef: const EntryRef(
      type: EntryRefType.waiting,
      id: 'wt_0005',
      code: 'WT-2607-0005',
    ),
    amount: 40000,
    method: PaymentMethod.card,
    cardCompany: '신한',
    status: PaymentStatus.paid,
    approvalNo: '30124578',
    createdAt: _at(20, 11),
    paidAt: _at(20, 11),
  );

  /// 디자인 실패 사유 — '카드 승인 거절'.
  static PaymentModel get paymentFailed => payment.copyWith(
    status: PaymentStatus.failed,
    failReason: '카드 승인 거절',
    paidAt: null,
  );
}
