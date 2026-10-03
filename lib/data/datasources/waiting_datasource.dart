import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/models/v1/waiting_model.dart';

/// 비대면 웨이팅 datasource 인터페이스.
///
/// ⚠ **Firebase 를 import 하지 않는다**(CLAUDE.md v1 규칙).
/// 구현은 `fake/fake_waiting_datasource.dart`(UI 단계)와
/// `remote/firebase_waiting_datasource.dart`(백엔드 단계) 두 벌이고,
/// 어느 쪽을 쓸지는 `repositories/v1_providers.dart` **한 곳**에서만 고른다.
///
/// ⚠ 순번 · 상태 전이 · 금액은 **서버가 확정**한다 — 앱은 ID 와 선택값만 보낸다.
/// 그래서 등록 · 취소 · 미루기 메서드가 금액을 받지 않는다.
abstract interface class WaitingDataSource {
  /// 내 진행 중 웨이팅 티켓들(패스월렛 입장권 탭).
  Stream<List<WaitingModel>> watchMyWaitings(String uid);

  /// 티켓 1건 구독.
  Stream<WaitingModel?> watchWaiting(String clubId, String waitingId);

  /// 클럽 실시간 운영 상태(대기 팀 수 · 접수 여부).
  Stream<ClubOpsLive?> watchOpsLive(String clubId);

  /// 클럽 웨이팅 설정(입장비 · 인원 범위).
  Future<ClubOpsSettings?> getOpsSettings(String clubId);

  /// 웨이팅 등록. 입장비가 0원일 때만 바로 된다.
  ///
  /// 금액을 보내지 않는다 — 서버가 `ops/settings` 를 보고 확정한다.
  Future<WaitingModel> registerWaiting({
    required String clubId,
    required int people,
    required bool noticeAgreed,
    required double lat,
    required double lng,
  });

  /// 순서 미루기.
  Future<WaitingModel> postponeWaiting(String clubId, String waitingId);

  /// 웨이팅 취소.
  Future<void> cancelWaiting(String clubId, String waitingId);

  /// 입장 QR 발급. 10초에 한 번만 다시 받을 수 있다.
  Future<EntryQrToken> issueEntryQr(String clubId, String waitingId);

  /// noShow 티켓 숨기기(사용자 측 삭제).
  Future<void> hideWaiting(String clubId, String waitingId);
}
