import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

part 'pass_models.freezed.dart';

/// 이용 내역 1건. `users/{uid}/history/{itemId}`.
///
/// 티켓이 영업 종료로 사라진 뒤에도 남는 기록이다(PASS-038).
/// 결제 상세(PASS-039)가 [payment] 만 보고 그려져 추가 read 가 0이다.
@freezed
abstract class HistoryItemModel with _$HistoryItemModel {
  const HistoryItemModel._();

  const factory HistoryItemModel({
    required String itemId,
    @Default(HistoryType.unknown) HistoryType type,
    required String clubId,
    @Default('') String clubName,
    @Default('') String clubThumbnailUrl,

    /// 원본 경로 — 남아 있을 때만 상세로 이동한다.
    @Default('') String refPath,

    /// 종료 상태 — entered · cancelled · noShow · done · rejected · storeCancelled.
    @Default('') String status,

    /// 방문 · 주문 시각(정렬 키).
    required DateTime visitedAt,
    @Default(0) int people,

    /// 주문 요약 — 'HARD SET A 외 1건'.
    @Default('') String summary,
    TicketPaymentSummary? payment,
    TicketRefundSummary? refund,
    @Default(ReviewPrompt.unknown) ReviewPrompt reviewPrompt,

    /// visitedAt + 14일. [임시_차선책] 설계 6-0 리뷰 작성 기간.
    DateTime? reviewDeadline,
    @Default('') String reviewId,

    /// 사용자 측 숨김(내역 삭제).
    @Default(false) bool hiddenByUser,
  }) = _HistoryItemModel;

  /// 리뷰를 쓸 수 있는지.
  bool canWriteReview(DateTime now) =>
      reviewPrompt == ReviewPrompt.prompt &&
      (reviewDeadline == null || reviewDeadline!.isAfter(now));
}

/// 앱 알림 1건. `users/{uid}/notifications/{notificationId}`.
///
/// ⚠ 베타에는 FCM 인프라가 없다 — v1 에서 신설된다(설계 10장).
@freezed
abstract class AppNotificationModel with _$AppNotificationModel {
  const AppNotificationModel._();

  const factory AppNotificationModel({
    required String notificationId,

    /// 10장 알림 유형 — 'waiting_called' 등.
    required String type,
    @Default(NotificationCategory.unknown) NotificationCategory category,
    required String title,
    @Default('') String body,

    /// 탭 시 이동 — `{ route, clubId, ticketId }`.
    @Default(<String, String>{}) Map<String, String> data,
    @Default(false) bool read,

    /// 중복 발송 방지 키 — `type:targetId:occurrence`(문서 ID 와 같다).
    @Default('') String dedupeKey,
    required DateTime createdAt,
  }) = _AppNotificationModel;

  /// 탭했을 때 갈 화면 ID.
  String get route => data['route'] ?? '';
}

/// 입장 QR 토큰. `issueEntryQr` 응답 — Firestore 문서가 아니다.
///
/// QR 에 넣는 내용은 [token] 문자열 **그대로**다(URL 아님 · 앱 전용).
/// 페이로드는 서버가 서명한 JWT 라 앱이 해석하지 않는다.
@freezed
abstract class EntryQrToken with _$EntryQrToken {
  const EntryQrToken._();

  const factory EntryQrToken({
    required String token,

    /// iat + 600초(10분). PASS-041 타이머가 이 값으로 센다.
    required DateTime expiresAt,
    required DateTime issuedAt,
  }) = _EntryQrToken;

  /// 남은 초. 지났으면 0.
  int remainSeconds(DateTime now) {
    final s = expiresAt.difference(now).inSeconds;
    return s < 0 ? 0 : s;
  }

  bool isExpired(DateTime now) => remainSeconds(now) == 0;

  /// 재발급 제한 — 10초에 한 번(디자인 문구와 같은 값).
  static const Duration reissueCooldown = Duration(seconds: 10);

  /// QR 유효 시간.
  static const Duration validity = Duration(minutes: 10);
}

/// 규정 문서. `policies/{policyId}`.
@freezed
abstract class PolicyModel with _$PolicyModel {
  const factory PolicyModel({
    /// reservationRules · waitingRules · orderRules · privacyTerms · paymentTerms.
    required String policyId,

    /// 'YYYY-MM-DD'.
    @Default('') String version,
    @Default('') String title,
    @Default('') String body,
  }) = _PolicyModel;
}
