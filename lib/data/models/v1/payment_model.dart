import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

part 'payment_model.freezed.dart';

/// 결제 1건. `payments/{paymentId}`.
///
/// ⚠ **금액은 서버가 확정한다** — 앱은 ID 와 선택값만 보낸다(CLAUDE.md 서버 확정 원칙).
/// PG 응답 원본(`pg.raw`)은 서버 전용이라 앱 모델에 담지 않는다.
@freezed
abstract class PaymentModel with _$PaymentModel {
  const PaymentModel._();

  const factory PaymentModel({
    required String paymentId,
    required String uid,
    required String clubId,
    @Default(PaymentKind.unknown) PaymentKind kind,
    @Default(EntryRef()) EntryRef targetRef,

    /// 서버 확정 금액.
    @Default(0) int amount,
    @Default(PaymentMethod.unknown) PaymentMethod method,
    @Default('') String cardCompany,

    /// 0 = 일시불.
    @Default(0) int installment,
    @Default(PaymentStatus.unknown) PaymentStatus status,

    /// 앱이 보여 줘도 되는 PG 값만.
    @Default('') String approvalNo,
    @Default('') String cardMasked,
    @Default('') String receiptUrl,

    /// 실패 사유 — 'CARD_DECLINED(051)'.
    @Default('') String failReason,

    /// createdAt + 15분. 미결제 만료.
    DateTime? expiresAt,
    @Default(0) int refundedAmount,
    required DateTime createdAt,
    DateTime? paidAt,
    DateTime? updatedAt,
  }) = _PaymentModel;

  bool get isPaid => status == PaymentStatus.paid;
  bool get isFailed =>
      status == PaymentStatus.failed || status == PaymentStatus.expired;
}

/// 환불 1건. `refunds/{refundId}`.
@freezed
abstract class RefundModel with _$RefundModel {
  const RefundModel._();

  const factory RefundModel({
    required String refundId,
    required String paymentId,
    required String uid,
    required String clubId,
    @Default(EntryRef()) EntryRef targetRef,
    @Default(RefundReason.unknown) RefundReason reason,

    /// 패널티를 뺀 환불액.
    @Default(0) int amount,
    @Default(<PenaltyLine>[]) List<PenaltyLine> penalties,
    @Default(RefundStatus.unknown) RefundStatus status,

    /// Cloud Tasks 재시도 횟수(1m · 5m · 30m · 2h · 12h).
    @Default(0) int attempts,
    @Default('') String lastError,
    DateTime? nextRetryAt,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _RefundModel;

  /// 패널티 합.
  int get penaltyTotal => penalties.fold(0, (s, p) => s + p.amount);

  /// 자동 재시도를 다 쓴 상태.
  bool get needsManual => status == RefundStatus.manual;
}

/// 예약 취소 · 변경 요율표. 설계 7장 `policies/reservationRules`.
///
/// ⚠ 실제 판정은 **서버가 한다**. 이 표는 화면이 "지금 취소하면 얼마"를 미리 보여 줄 때만 쓴다.
/// 서버 응답과 어긋나면 서버 값을 따른다.
class ReservationRules {
  const ReservationRules._();

  /// 결제 후 무료 취소 시간.
  static const Duration freeCancelWindow = Duration(minutes: 10);

  /// 입장권 전환 시점 — 도착 N시간 전.
  static const Duration convertBefore = Duration(hours: 3);

  /// 구간별 `(테이블 %, 메뉴 %, 취소 수수료 %)`.
  static const Map<CancelBucket, (int, int, int)> rates = {
    CancelBucket.free10m: (0, 0, 0),
    CancelBucket.d3: (0, 0, 0),
    CancelBucket.d2: (20, 0, 3),
    CancelBucket.d0: (50, 10, 3),
  };

  /// 변경 수수료 — 2회차부터.
  static const int changeFee = 3000;

  /// 하향 변경 패널티 — 메뉴는 당일 차액의 10%, 테이블은 d2 20% · d0 50%.
  static const int menuDowngradeRateD0 = 10;

  /// 노쇼 패널티 비율.
  static const int noShowPenaltyRate = 100;
}
