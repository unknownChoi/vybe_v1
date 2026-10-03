import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

part 'reservation_model.freezed.dart';

/// 테이블 예약 1건. `clubs/{clubId}/reservations/{reservationId}`.
///
/// 앱은 읽기만 한다. 예약 · 변경 · 취소는 onCall 함수(금액 · 패널티 · 상태 전이는 서버 확정).
@freezed
abstract class ReservationModel with _$ReservationModel {
  const ReservationModel._();

  const factory ReservationModel({
    required String reservationId,

    /// TABLE RESERVATION 번호 — 'RS-2607-1182'.
    required String code,
    required String clubId,
    @Default('') String clubName,
    required String uid,

    /// 예약자 정보. ⚠ 관리자 화면은 **마스킹 없이** 표시한다(확정 정책).
    @Default(ReservationGuest()) ReservationGuest guest,

    /// 이용 날짜 'YYYYMMDD'(= businessDate).
    required String date,

    /// 도착 시간 슬롯 — '20:00'.
    @Default('') String arrivalSlot,
    DateTime? arrivalAt,
    @Default(1) int people,
    @Default('') String tableId,

    /// 표시용 좌석 이름 — '테이블-4'.
    @Default('') String tableName,
    @Default(SeatTier.unknown) SeatTier tier,

    /// 테이블 금액 스냅샷.
    @Default(0) int seatPrice,

    /// 최소 주문금액 스냅샷.
    @Default(0) int minSpend,

    /// 사전 주문.
    @Default(<OrderLine>[]) List<OrderLine> menuLines,
    @Default(0) int menuSubtotal,

    /// 결제 총액(변경 누적 반영).
    @Default(0) int totalPaid,
    @Default('') String paymentId,
    TicketPaymentSummary? payment,
    @Default(ReservationStatus.unknown) ReservationStatus status,

    /// 결제 +10분. 이 안에 취소하면 전액 환불(RSV-091).
    DateTime? freeCancelUntil,

    /// 도착 3시간 전 — 입장권으로 자동 전환(RSV-087).
    DateTime? convertAt,
    DateTime? convertedAt,
    DateTime? enteredAt,
    @Default(0) int reentryCount,

    /// 변경 횟수. 2회차부터 변경 수수료 3,000원.
    @Default(0) int changeCount,
    ReservationCancel? cancel,
    ReservationNoShow? noShow,
    TicketShareSummary? share,

    /// 동의한 규정 판본.
    @Default('') String policyVersion,
    DateTime? policyAgreedAt,
    @Default(false) bool hiddenByUser,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReservationModel;

  /// 사전 주문이 있는지.
  bool get hasPreorder => menuLines.isNotEmpty;

  /// 사전 주문 요약 — 'HARD SET A 외 1건'.
  String get preorderSummary {
    if (menuLines.isEmpty) return '';
    final first = menuLines.first.name;
    final rest = menuLines.length - 1;
    return rest == 0 ? first : '$first 외 $rest건';
  }

  /// 입장권 전환 후에는 취소 · 변경이 막힌다(RSV-101).
  bool get isLocked => status.isConvertedOrLater;
}

/// 예약자 정보. `reservations.guest`.
@freezed
abstract class ReservationGuest with _$ReservationGuest {
  const factory ReservationGuest({
    @Default('') String name,
    @Default('') String phone,
  }) = _ReservationGuest;
}

/// 취소 기록. `reservations.cancel`.
@freezed
abstract class ReservationCancel with _$ReservationCancel {
  const ReservationCancel._();

  const factory ReservationCancel({
    DateTime? at,
    @Default(CancelledBy.unknown) CancelledBy by,
    @Default(CancelBucket.unknown) CancelBucket bucket,
    @Default('') String reason,
    @Default(<PenaltyLine>[]) List<PenaltyLine> penalties,
    @Default(0) int penaltyTotal,
    @Default(0) int refundAmount,
  }) = _ReservationCancel;

  /// 패널티가 하나도 없으면 전액 환불.
  bool get isFullRefund => penaltyTotal == 0;
}

/// 노쇼 기록. `reservations.noShow`.
@freezed
abstract class ReservationNoShow with _$ReservationNoShow {
  const factory ReservationNoShow({
    DateTime? at,
    @Default(CancelledBy.unknown) CancelledBy by,

    /// 노쇼 패널티 비율(설계 7장: 100).
    @Default(100) int penaltyRate,
    @Default(0) int refundAmount,
  }) = _ReservationNoShow;
}

/// 예약 가능 날짜 1일. `clubs/{clubId}/reservationDays/{YYYYMMDD}`.
@freezed
abstract class ReservationDayModel with _$ReservationDayModel {
  const ReservationDayModel._();

  const factory ReservationDayModel({
    required String date,

    /// 날짜 자체 마감.
    @Default(false) bool closed,

    /// 수동 마감 테이블.
    @Default(<String>[]) List<String> closedTables,

    /// `{ tableId: 상태 }`.
    @Default(<String, ReservationDayTable>{})
    Map<String, ReservationDayTable> tables,
    @Default(0) int bookedCount,
    @Default(0) int holdCount,
    DateTime? updatedAt,
  }) = _ReservationDayModel;

  /// 그 테이블을 지금 고를 수 있는지.
  bool canPick(String tableId) {
    if (closed || closedTables.contains(tableId)) return false;
    final t = tables[tableId];
    return t == null || !t.status.isTaken;
  }
}

/// 날짜별 테이블 상태 한 칸.
@freezed
abstract class ReservationDayTable with _$ReservationDayTable {
  const factory ReservationDayTable({
    @Default(TableHoldStatus.unknown) TableHoldStatus status,
    @Default('') String reservationId,
    @Default(0) int people,
    @Default('') String slot,
    DateTime? holdUntil,
  }) = _ReservationDayTable;
}
