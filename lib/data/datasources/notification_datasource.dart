import 'package:vybe/data/models/v1/pass_models.dart';

/// 알림 센터 · 알림 설정 datasource 인터페이스 (HOME-007 · MY-029).
///
/// ⚠ **Firebase 를 import 하지 않는다**(CLAUDE.md v1 규칙).
/// 구현은 `fake/fake_notification_datasource.dart`(UI 단계)와
/// `remote/firebase_notification_datasource.dart`(백엔드 단계) 두 벌이고,
/// 어느 쪽을 쓸지는 `repositories/v1_providers.dart` **한 곳**에서만 고른다.
///
/// ⚠ 읽지 않은 수(`users.unreadNotificationCount`)는 **서버만 증감**한다
/// (설계 4장 — 알림 생성 시 +1, `markNotificationsRead` 가 재계산).
/// 그래서 앱에는 '읽음 처리' 만 있고 '배지 수 쓰기' 가 없다.
abstract interface class NotificationDataSource {
  /// 안 읽은 알림 수 — HOME-005 벨 배지 · 마이 배지.
  ///
  /// 사용자 문서를 이미 구독하고 있어 추가 조회가 없다(설계 11장 비용표).
  Stream<int> watchUnreadCount(String uid);

  /// 알림 목록(HOME-007). 최신순.
  Stream<List<AppNotificationModel>> watchNotifications(String uid);

  /// 모두 읽음. 서버가 `unreadNotificationCount` 를 재계산한다.
  Future<void> markAllRead(String uid);

  /// 알림 1건 읽음.
  Future<void> markRead(String uid, String notificationId);

  /// 알림 토글 4종.
  Future<NotificationSettings> getSettings(String uid);

  /// 토글 하나를 바꾼다. 반환값은 **서버가 확정한 전체 값**이다 —
  /// 화면이 보낸 값을 그대로 믿지 않는다.
  Future<NotificationSettings> updateSettings(
    String uid,
    NotificationSettings settings,
  );
}
