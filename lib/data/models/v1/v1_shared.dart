import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';

part 'v1_shared.freezed.dart';

/// 티켓에 비정규화해 둔 결제 요약. `waitings.payment` · `reservations.payment` ·
/// `orders.payment` · `history.payment`.
///
/// `payments` 문서를 또 읽지 않으려고 복사해 둔 것이다 — 영수증 시트가 이 값만으로 그려진다.
@freezed
abstract class TicketPaymentSummary with _$TicketPaymentSummary {
  const TicketPaymentSummary._();

  const factory TicketPaymentSummary({
    @Default(PaymentStatus.unknown) PaymentStatus status,
    @Default(PaymentMethod.unknown) PaymentMethod method,

    /// 카드사(예: '신한').
    @Default('') String cardCompany,

    /// 할부 개월. 0 = 일시불.
    @Default(0) int installment,
    DateTime? paidAt,

    /// 승인번호.
    @Default('') String approvalNo,

    /// 마스킹된 카드번호.
    @Default('') String cardMasked,
    DateTime? approvedAt,

    /// `history.payment` 에만 있는 금액.
    @Default(0) int amount,
  }) = _TicketPaymentSummary;

  /// 화면에 찍는 결제 수단 문자열 — '신용카드 · 신한'.
  String get methodLabel =>
      cardCompany.isEmpty ? method.label : '${method.label} · $cardCompany';
}

/// 티켓에 비정규화해 둔 환불 요약.
@freezed
abstract class TicketRefundSummary with _$TicketRefundSummary {
  const factory TicketRefundSummary({
    @Default('') String refundId,
    @Default(RefundStatus.unknown) RefundStatus status,
    @Default(0) int amount,
    @Default(RefundReason.unknown) RefundReason reason,
  }) = _TicketRefundSummary;
}

/// 티켓에 비정규화해 둔 공유 요약. `waitings.share` · `reservations.share`.
///
/// ⚠ **수령자 식별 정보는 없다** — 공유받은 사람 개인정보 비노출(확정 정책).
@freezed
abstract class TicketShareSummary with _$TicketShareSummary {
  const factory TicketShareSummary({
    @Default('') String serial,
    @Default(ShareLinkStatus.unknown) ShareLinkStatus status,
    @Default(0) int receivedCount,
    DateTime? lastReceivedAt,

    /// 비밀번호를 설정한 시각(웨이팅 티켓만).
    DateTime? passwordSetAt,
  }) = _TicketShareSummary;
}

/// 패널티 한 줄. `reservations.cancel.penalties[]` · `refunds.penalties[]`.
///
/// ⚠ 용어는 **"패널티"**다("공제" 아님 — 확정 정책).
/// [rate] 는 비율(%)로 보여 주고, 합계·환불은 금액으로 보여 준다.
@freezed
abstract class PenaltyLine with _$PenaltyLine {
  const factory PenaltyLine({
    @Default(PenaltyKind.unknown) PenaltyKind kind,

    /// 0~100 정수(%).
    @Default(0) int rate,

    /// 원 단위 정수(내림).
    @Default(0) int amount,
  }) = _PenaltyLine;
}

/// 웨이팅 입장비 스냅샷. `waitings.fee`.
///
/// ⚠ 금액은 **서버가 확정**한다 — 앱은 `unit × people` 을 표시용으로만 쓰고
/// 함수에 금액을 보내지 않는다(CLAUDE.md 서버 확정 원칙).
@freezed
abstract class WaitingFee with _$WaitingFee {
  const WaitingFee._();

  const factory WaitingFee({
    /// 1인 입장비.
    @Default(0) int unit,
    @Default(0) int people,

    /// 서버가 확정한 총액.
    @Default(0) int total,

    /// 등록 시점 `ops/settings.version`.
    @Default(0) int settingsVersion,
  }) = _WaitingFee;

  /// 입장비가 있는 웨이팅인지.
  bool get isPaid => total > 0;
}

/// 주문 자격 참조. `orders.entryRef` · `sharedTickets.source`.
@freezed
abstract class EntryRef with _$EntryRef {
  const factory EntryRef({
    @Default(EntryRefType.unknown) EntryRefType type,
    @Default('') String id,

    /// 티켓 표시 번호(예: 'WT-2607-0005').
    @Default('') String code,
  }) = _EntryRef;
}

/// 주문 · 사전 주문 한 줄. `orders.lines[]` · `reservations.menuLines[]`.
@freezed
abstract class OrderLine with _$OrderLine {
  const OrderLine._();

  const factory OrderLine({
    @Default('') String menuId,
    @Default('') String name,
    @Default(0) int qty,
    @Default(0) int unitPrice,

    /// 추가 옵션(예: 레몬 슬라이스 추가 5P · +5,500원).
    @Default(<OrderLineOption>[]) List<OrderLineOption> options,

    /// 서버가 확정한 줄 합계.
    @Default(0) int lineTotal,
  }) = _OrderLine;

  /// 옵션 금액 합.
  int get optionTotal =>
      options.fold(0, (sum, o) => sum + o.price * qty);
}

/// 메뉴 추가 옵션.
@freezed
abstract class OrderLineOption with _$OrderLineOption {
  const factory OrderLineOption({
    @Default('') String id,
    @Default('') String name,
    @Default(0) int price,
  }) = _OrderLineOption;
}
