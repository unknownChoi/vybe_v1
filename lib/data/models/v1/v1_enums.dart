/// v1 신규 기능의 상태 enum 모음.
///
/// 값(`key`)은 `docs/backend_design.html` 4장과 **글자 그대로** 같다. 바꾸지 말 것 —
/// Firestore 에 그 문자열이 저장되고 Functions · Rules 가 같은 값을 본다.
///
/// 모르는 값이 오면 `unknown` 으로 떨어뜨린다. 서버가 상태를 늘려도 앱이 죽지 않게 하기 위함이고,
/// 화면은 `unknown` 을 '알 수 없음'으로만 그린다(베타 `facilities` 가 모르는 키를 조용히 버리는 것과 같은 규칙).
library;

/// 공통 — 키 문자열로 enum 을 찾는다.
T _byKey<T>(List<T> values, String Function(T) key, String raw, T fallback) {
  for (final v in values) {
    if (key(v) == raw) return v;
  }
  return fallback;
}

/// `waitings.status` — 웨이팅 티켓 상태.
///
/// 전이: pendingPayment →(PG 승인) waiting →(관리자 호출) called →(스캔·수동) entered
/// / pendingPayment →(결제 실패·15분 만료·결제 중 마감) failed / 취소 cancelled / 호출 10분 미입장 noShow.
enum WaitingStatus {
  pendingPayment('pendingPayment'),
  waiting('waiting'),
  called('called'),
  entered('entered'),
  noShow('noShow'),
  cancelled('cancelled'),
  failed('failed'),
  deleted('deleted'),
  unknown('');

  const WaitingStatus(this.key);
  final String key;

  static WaitingStatus from(String raw) =>
      _byKey(values, (v) => v.key, raw, WaitingStatus.unknown);

  /// 영업이 끝났거나 더 진행할 수 없는 상태.
  bool get isClosed => const {
    WaitingStatus.entered,
    WaitingStatus.noShow,
    WaitingStatus.cancelled,
    WaitingStatus.failed,
    WaitingStatus.deleted,
  }.contains(this);
}

/// `waitings.noShowReason`.
enum NoShowReason {
  callTimeout('callTimeout'),
  manual('manual'),
  unknown('');

  const NoShowReason(this.key);
  final String key;

  static NoShowReason from(String raw) =>
      _byKey(values, (v) => v.key, raw, NoShowReason.unknown);
}

/// 취소 주체 — `waitings.cancelledBy` · `reservations.cancel.by` · `orders.cancel.by`.
enum CancelledBy {
  user('user'),
  store('store'),
  system('system'),
  unknown('');

  const CancelledBy(this.key);
  final String key;

  static CancelledBy from(String raw) =>
      _byKey(values, (v) => v.key, raw, CancelledBy.unknown);
}

/// `reservations.status`.
///
/// 전이: pendingPayment → pending(접수됨) → confirmed → converted(입장권) → entered → completed.
enum ReservationStatus {
  pendingPayment('pendingPayment'),
  pending('pending'),
  confirmed('confirmed'),
  converted('converted'),
  entered('entered'),
  completed('completed'),
  cancelled('cancelled'),
  noShow('noShow'),
  failed('failed'),
  unknown('');

  const ReservationStatus(this.key);
  final String key;

  static ReservationStatus from(String raw) =>
      _byKey(values, (v) => v.key, raw, ReservationStatus.unknown);

  /// 입장권으로 전환된 뒤 — 취소 · 변경이 막힌다(RSV-101).
  bool get isConvertedOrLater => const {
    ReservationStatus.converted,
    ReservationStatus.entered,
    ReservationStatus.completed,
  }.contains(this);
}

/// 취소 구간 — `reservations.cancel.bucket` · 패널티 요율 기준(설계 7장).
enum CancelBucket {
  /// 결제 후 10분 이내 — 전액 환불.
  free10m('free10m'),

  /// 이용 3일 전까지 — 전액 환불.
  d3('d3'),

  /// 이용 2일 전 — 테이블 20% · 메뉴 0% · 취소 수수료 3%.
  d2('d2'),

  /// 당일(영업 시작 전) — 테이블 50% · 메뉴 10% · 취소 수수료 3%.
  d0('d0'),

  /// 영업 시작 후.
  open('open'),

  /// 입장권 전환 후 — 취소 불가.
  converted('converted'),
  unknown('');

  const CancelBucket(this.key);
  final String key;

  static CancelBucket from(String raw) =>
      _byKey(values, (v) => v.key, raw, CancelBucket.unknown);
}

/// 패널티 종류 — `penalties[].kind`.
///
/// ⚠ 용어는 **"공제"가 아니라 "패널티"**(CLAUDE.md 확정 정책).
/// 비율로 표시하고 합계 · 환불은 금액으로 표시한다.
enum PenaltyKind {
  table('table'),
  menu('menu'),
  cancelFee('cancelFee'),
  unknown('');

  const PenaltyKind(this.key);
  final String key;

  static PenaltyKind from(String raw) =>
      _byKey(values, (v) => v.key, raw, PenaltyKind.unknown);
}

/// 좌석 등급 — `reservations.tier` (`tableLayout.tiers[].key` 스냅샷).
enum SeatTier {
  table('table'),
  room('room'),
  unknown('');

  const SeatTier(this.key);
  final String key;

  static SeatTier from(String raw) =>
      _byKey(values, (v) => v.key, raw, SeatTier.unknown);
}

/// `reservationDays.tables[*].status`.
enum TableHoldStatus {
  hold('hold'),
  booked('booked'),
  noShow('noShow'),
  released('released'),
  unknown('');

  const TableHoldStatus(this.key);
  final String key;

  static TableHoldStatus from(String raw) =>
      _byKey(values, (v) => v.key, raw, TableHoldStatus.unknown);

  /// 사용자가 고를 수 없는 자리.
  bool get isTaken =>
      this == TableHoldStatus.hold || this == TableHoldStatus.booked;
}

/// `orders.status`.
enum OrderStatus {
  pendingPayment('pendingPayment'),
  paid('paid'),
  making('making'),
  ready('ready'),
  done('done'),
  rejected('rejected'),
  cancelled('cancelled'),
  failed('failed'),
  unknown('');

  const OrderStatus(this.key);
  final String key;

  static OrderStatus from(String raw) =>
      _byKey(values, (v) => v.key, raw, OrderStatus.unknown);

  /// 사용자가 취소할 수 있는 구간 — 조리 시작 전까지만(ORDER-104).
  bool get userCancellable => this == OrderStatus.paid;
}

/// `orders.reject.reason`.
enum OrderRejectReason {
  soldOut('soldOut'),
  closed('closed'),
  unknown('');

  const OrderRejectReason(this.key);
  final String key;

  static OrderRejectReason from(String raw) =>
      _byKey(values, (v) => v.key, raw, OrderRejectReason.unknown);
}

/// 입장 자격 참조 종류 — `orders.entryRef.type` · `sharedTickets.source.type`.
enum EntryRefType {
  waiting('waiting'),
  reservation('reservation'),
  shared('shared'),
  unknown('');

  const EntryRefType(this.key);
  final String key;

  static EntryRefType from(String raw) =>
      _byKey(values, (v) => v.key, raw, EntryRefType.unknown);
}

/// `sharedTickets.status`.
enum SharedTicketStatus {
  active('active'),
  entered('entered'),
  deleted('deleted'),
  expired('expired'),
  unknown('');

  const SharedTicketStatus(this.key);
  final String key;

  static SharedTicketStatus from(String raw) =>
      _byKey(values, (v) => v.key, raw, SharedTicketStatus.unknown);
}

/// `shareLinks.status` · 티켓의 `share.status`.
enum ShareLinkStatus {
  active('active'),
  stopped('stopped'),
  expired('expired'),
  unknown('');

  const ShareLinkStatus(this.key);
  final String key;

  static ShareLinkStatus from(String raw) =>
      _byKey(values, (v) => v.key, raw, ShareLinkStatus.unknown);
}

/// `payments.kind`.
enum PaymentKind {
  waitingFee('waitingFee'),
  reservation('reservation'),
  reservationChange('reservationChange'),
  order('order'),
  unknown('');

  const PaymentKind(this.key);
  final String key;

  static PaymentKind from(String raw) =>
      _byKey(values, (v) => v.key, raw, PaymentKind.unknown);
}

/// 결제 수단 — `payments.method`.
///
/// ⚠ 무통장(`bank`) · 상품권(`gift`) 은 **입장비 결제에는 없다**(디자인 FEE-071).
enum PaymentMethod {
  card('card', '신용카드'),
  kakaopay('kakaopay', '카카오페이'),
  naverpay('naverpay', '네이버페이'),
  tosspay('tosspay', '토스페이'),
  payco('payco', '페이코'),
  phone('phone', '휴대폰 결제'),
  bank('bank', '무통장 입금'),
  gift('gift', '상품권'),
  unknown('', '알 수 없음');

  const PaymentMethod(this.key, this.label);
  final String key;

  /// 화면에 그대로 찍는 한글 라벨(디자인 원문).
  final String label;

  static PaymentMethod from(String raw) =>
      _byKey(values, (v) => v.key, raw, PaymentMethod.unknown);

  /// 입장비 결제에서 고를 수 있는 수단.
  static const List<PaymentMethod> entryFeeMethods = [
    card,
    kakaopay,
    naverpay,
    tosspay,
    payco,
    phone,
  ];

  /// 예약 · 주문 결제에서 고를 수 있는 수단.
  static const List<PaymentMethod> fullMethods = [
    card,
    kakaopay,
    naverpay,
    tosspay,
    payco,
    phone,
    bank,
    gift,
  ];
}

/// `payments.status`.
enum PaymentStatus {
  created('created'),
  pending('pending'),
  authorized('authorized'),
  paid('paid'),
  failed('failed'),
  expired('expired'),
  partiallyRefunded('partiallyRefunded'),
  refunded('refunded'),
  unknown('');

  const PaymentStatus(this.key);
  final String key;

  static PaymentStatus from(String raw) =>
      _byKey(values, (v) => v.key, raw, PaymentStatus.unknown);
}

/// `refunds.status`.
enum RefundStatus {
  requested('requested'),
  processing('processing'),
  done('done'),
  failed('failed'),

  /// 자동 재시도를 모두 쓴 뒤 수기 처리로 넘어간 건.
  manual('manual'),
  unknown('');

  const RefundStatus(this.key);
  final String key;

  static RefundStatus from(String raw) =>
      _byKey(values, (v) => v.key, raw, RefundStatus.unknown);
}

/// `refunds.reason`.
enum RefundReason {
  userCancel('userCancel'),
  storeCancel('storeCancel'),
  storeClosed('storeClosed'),
  noShowPenalty('noShowPenalty'),
  reject('reject'),
  adminDelete('adminDelete'),
  changeDowngrade('changeDowngrade'),
  paymentFailed('paymentFailed'),
  unknown('');

  const RefundReason(this.key);
  final String key;

  static RefundReason from(String raw) =>
      _byKey(values, (v) => v.key, raw, RefundReason.unknown);
}

/// `ops/live.phase` — 영업 단계.
enum OpsPhase {
  pre('pre'),
  open('open'),
  closed('closed'),
  unknown('');

  const OpsPhase(this.key);
  final String key;

  static OpsPhase from(String raw) =>
      _byKey(values, (v) => v.key, raw, OpsPhase.unknown);
}

/// `users/{uid}/history.type` · `history.reviewPrompt`.
enum HistoryType {
  waiting('waiting'),
  reservation('reservation'),
  order('order'),
  unknown('');

  const HistoryType(this.key);
  final String key;

  static HistoryType from(String raw) =>
      _byKey(values, (v) => v.key, raw, HistoryType.unknown);
}

/// 리뷰 작성 안내 상태 — `history.reviewPrompt`.
enum ReviewPrompt {
  prompt('prompt'),
  written('written'),
  expired('expired'),
  none('none'),
  unknown('');

  const ReviewPrompt(this.key);
  final String key;

  static ReviewPrompt from(String raw) =>
      _byKey(values, (v) => v.key, raw, ReviewPrompt.unknown);
}

/// 알림 분류 — `users/{uid}/notifications.category` (HOME-007 필터).
enum NotificationCategory {
  reservation('reservation', '예약'),
  club('club', '클럽'),
  promo('promo', '혜택'),
  activity('activity', '활동'),
  review('review', '리뷰'),
  notice('notice', '공지'),
  unknown('', '기타');

  const NotificationCategory(this.key, this.label);
  final String key;
  final String label;

  static NotificationCategory from(String raw) =>
      _byKey(values, (v) => v.key, raw, NotificationCategory.unknown);
}
