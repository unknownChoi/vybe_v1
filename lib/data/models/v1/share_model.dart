import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

part 'share_model.freezed.dart';

/// 공유받은 입장권. `clubs/{clubId}/sharedTickets/{sharedTicketId}`.
///
/// ⚠ 원본 소유자에게 **수령자 정보를 보여 주지 않는다**(확정 정책) —
/// 서버가 `source.ownerUid` 를 응답에서 제거하고, 앱 모델에도 담지 않는다.
@freezed
abstract class SharedTicketModel with _$SharedTicketModel {
  const SharedTicketModel._();

  const factory SharedTicketModel({
    required String sharedTicketId,

    /// 수령 당시 일련번호 — 'ARD-4F9K-2Q71'.
    required String serial,

    /// 원본 티켓 참조(소유자 uid 는 담지 않는다).
    @Default(EntryRef()) EntryRef source,
    required String recipientUid,

    /// 표시 번호 — 'WT-2607-0002-S2'.
    @Default('') String code,
    required String businessDate,
    @Default('') String clubId,
    @Default('') String clubName,
    @Default('') String tableName,
    @Default(0) int people,
    @Default(SharedTicketStatus.unknown) SharedTicketStatus status,
    DateTime? enteredAt,
    @Default(0) int reentryCount,

    /// 원본이 취소돼 사라진 경우 — 'sourceCancelled'(RSV-102).
    @Default('') String deletedReason,
    required DateTime createdAt,
  }) = _SharedTicketModel;

  bool get isUsable => status == SharedTicketStatus.active;
}

/// 공유 링크 미리보기. `lookupShareLink(serial)` 응답.
///
/// ⚠ 문서를 직접 읽을 수 없다 — 함수 응답으로만 온다.
/// **개인정보가 들어가지 않는다**(매장 · 날짜 · 인원 · 좌석까지만).
@freezed
abstract class SharePreviewModel with _$SharePreviewModel {
  const SharePreviewModel._();

  const factory SharePreviewModel({
    required String serial,
    @Default('') String clubName,

    /// 'YYYYMMDD'.
    @Default('') String date,
    DateTime? enteredAt,
    @Default(0) int people,
    @Default('') String tableName,
    @Default(ShareLinkStatus.unknown) ShareLinkStatus status,
    @Default(EntryRefType.unknown) EntryRefType ticketType,

    /// 남은 시도 횟수. 0 이면 잠김.
    @Default(5) int remainAttempts,

    /// 5회 실패 시 30분 잠금이 풀리는 시각.
    DateTime? lockedUntil,
  }) = _SharePreviewModel;

  /// 지금 비밀번호를 넣을 수 있는지.
  bool lockedAt(DateTime now) =>
      lockedUntil != null && lockedUntil!.isAfter(now);
}

/// 공유 비밀번호 자릿수 · 시도 제한 — 디자인 `SH_PWLEN` · `SH_TRY`.
class ShareLinkRule {
  const ShareLinkRule._();

  /// 숫자 6자리.
  static const int passwordLength = 6;

  /// 5회 틀리면 30분 잠김.
  static const int maxAttempts = 5;
  static const Duration lockDuration = Duration(minutes: 30);

  /// 일련번호 표기 — 'ARD-0000-0000'(3-4-4).
  static const String serialHint = 'ARD-0000-0000';
}
