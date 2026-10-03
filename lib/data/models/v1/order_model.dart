import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

part 'order_model.freezed.dart';

/// 비대면 주문 1건. `clubs/{clubId}/orders/{orderId}`.
///
/// 주문 자격은 **입장 완료 티켓**이다([entryRef]) — 웨이팅 · 전환된 예약 · 공유받은 입장권.
@freezed
abstract class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    required String orderId,

    /// 영업일 내 주문번호 3자리 — '017'.
    required String no,
    required String clubId,
    @Default('') String clubName,
    required String uid,
    required String businessDate,

    /// 주문 자격이 된 입장 티켓.
    @Default(EntryRef()) EntryRef entryRef,

    /// '테이블-4' · 웨이팅 입장이면 '입장권 WT-…'.
    @Default('') String tableLabel,

    /// 픽업 위치 — '바 카운터'.
    @Default('') String pickup,
    @Default(<OrderLine>[]) List<OrderLine> lines,

    /// 서버가 계산한 총액.
    @Default(0) int total,
    @Default('') String paymentId,
    TicketPaymentSummary? payment,
    @Default(OrderStatus.unknown) OrderStatus status,

    /// 자동 전환으로 making 이 된 주문.
    @Default(false) bool auto,
    @Default(OrderTimeline()) OrderTimeline timeline,
    OrderReject? reject,
    DateTime? cancelledAt,
    @Default(CancelledBy.unknown) CancelledBy cancelledBy,
    TicketRefundSummary? refund,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderModel;

  /// 담은 개수 합.
  int get itemCount => lines.fold(0, (s, l) => s + l.qty);

  /// '017 · 2개' 같은 한 줄 요약.
  String get shortSummary => '$no · $itemCount개';
}

/// 주문 상태 이력. `orders.timeline`.
@freezed
abstract class OrderTimeline with _$OrderTimeline {
  const factory OrderTimeline({
    DateTime? paidAt,
    DateTime? makingAt,
    DateTime? readyAt,
    DateTime? doneAt,
  }) = _OrderTimeline;
}

/// 매장 거절 기록. `orders.reject`(ORDER-106).
@freezed
abstract class OrderReject with _$OrderReject {
  const factory OrderReject({
    DateTime? at,
    @Default(OrderRejectReason.unknown) OrderRejectReason reason,
    @Default('') String by,

    /// 거절과 함께 품절 처리했는지.
    @Default(false) bool markSoldOut,
  }) = _OrderReject;
}
