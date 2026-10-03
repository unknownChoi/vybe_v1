import 'package:vybe/data/models/v1/club_ops_model.dart';

/// 클럽 실시간 운영 상태 datasource 인터페이스 (`clubs/{clubId}/ops/live`).
///
/// ⚠ **Firebase 를 import 하지 않는다**(CLAUDE.md v1 규칙).
/// 구현은 `fake/fake_club_ops_datasource.dart`(UI 단계)와
/// `remote/firebase_club_ops_datasource.dart`(백엔드 단계) 두 벌이고,
/// 어느 쪽을 쓸지는 `repositories/v1_providers.dart` **한 곳**에서만 고른다.
///
/// ⚠ `WaitingDataSource.watchOpsLive` 와 **일부러 겹친다** — 웨이팅 화면은
/// 자기 티켓과 같은 흐름으로 운영 상태를 보고, 지도·목록은 티켓과 무관하게
/// 여러 클럽의 상태만 본다. 백엔드 단계에서 같은 문서를 읽되 구독 범위가
/// 다르다(1건 vs 핀 여러 개).
///
/// ⚠ **지도 핀은 여러 클럽을 한 번에 묻는다** — 핀마다 구독을 열면
/// 화면 하나가 문서 수십 개를 구독한다(설계 2장 읽기 최소화).
abstract interface class ClubOpsDataSource {
  /// 클럽 1곳 운영 상태 구독(클럽 상세가 열려 있는 동안).
  Stream<ClubOpsLive?> watchOpsLive(String clubId);

  /// 여러 클럽의 운영 상태 — 지도 핀 카드 · 목록 카드.
  ///
  /// 돌려주는 map 에 **없는 clubId 는 '모른다'** 는 뜻이다(운영 중이 아니라).
  /// 화면은 그 자리에 대기 팀 수를 그리지 않는다.
  Stream<Map<String, ClubOpsLive>> watchOpsLiveMany(List<String> clubIds);
}
