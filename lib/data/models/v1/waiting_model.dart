import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

part 'waiting_model.freezed.dart';

/// 비대면 웨이팅 티켓 1건. `clubs/{clubId}/waitings/{waitingId}`.
///
/// 설계 4장 그대로. 앱은 **읽기만** 한다 — 등록 · 취소 · 미루기는 전부 onCall 함수다
/// (CLAUDE.md 서버 확정 원칙: 순번 · 상태 전이 · 금액은 클라가 정하지 않는다).
@freezed
abstract class WaitingModel with _$WaitingModel {
  const WaitingModel._();

  const factory WaitingModel({
    required String waitingId,

    /// ENTRY PASS 번호 — 'WT-2607-0005'. 사용자·관리자 표시 · 티켓 조회 키.
    required String code,
    required String clubId,
    @Default('') String clubName,
    required String uid,

    /// 영업일 'YYYYMMDD'.
    required String businessDate,

    /// 대기 번호(영업일 내 1부터).
    @Default(0) int seq,
    @Default(1) int people,
    @Default(WaitingStatus.unknown) WaitingStatus status,

    /// 순서 미루기를 쓴 적이 있는지.
    @Default(false) bool postponed,
    @Default(0) int postponeCount,

    /// 입장비 스냅샷. `total == 0` 이면 입장비 없는 웨이팅.
    @Default(WaitingFee()) WaitingFee fee,
    @Default('') String paymentId,
    TicketPaymentSummary? payment,
    TicketRefundSummary? refund,
    DateTime? calledAt,

    /// 호출 +10분. 넘기면 noShow.
    DateTime? callDeadline,
    DateTime? enteredAt,
    @Default(0) int reentryCount,
    DateTime? lastReentryAt,
    @Default(NoShowReason.unknown) NoShowReason noShowReason,
    DateTime? cancelledAt,
    @Default(CancelledBy.unknown) CancelledBy cancelledBy,
    @Default('') String cancelReason,
    TicketShareSummary? share,

    /// 유의사항 동의 · 반경 500m 검증 결과(서버가 판정해 기록).
    @Default(false) bool noticeAgreed,
    @Default(false) bool locationChecked,

    /// noShow 티켓 '제거하기' — 사용자 측 숨김.
    @Default(false) bool hiddenByUser,

    /// `issueEntryQr` 가 갱신. 재발급 10초 제한 비교용.
    DateTime? qrIssuedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WaitingModel;

  /// 앞에 남은 팀 수는 `ops/live.waiting.queue` 로 계산한다 — 티켓 자체엔 없다.
  /// 화면은 [seq] 와 live 큐를 함께 본다.
  bool get isActive => !status.isClosed;

  /// 호출 마감까지 남은 초. 호출 전이거나 지났으면 0.
  int remainCallSeconds(DateTime now) {
    final d = callDeadline;
    if (d == null) return 0;
    final s = d.difference(now).inSeconds;
    return s < 0 ? 0 : s;
  }

  /// 입장 QR 을 열어 줄 수 있는 상태인지 — 호출됨 이후부터.
  bool get canOpenQr =>
      status == WaitingStatus.called || status == WaitingStatus.entered;
}
