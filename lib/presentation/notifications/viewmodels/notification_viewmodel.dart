import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/repositories/v1_providers.dart';

/// 알림 목록 (HOME-007) — 설계 4장 `users/{uid}/notifications`.
///
/// UI 단계에선 Fake 가, 백엔드 단계에선 Firebase 가 흘려보낸다. 어느 쪽을 쓸지는
/// `v1_providers.dart` 한 곳이 고른다 — 이 화면은 모른다.
///
/// ⚠ 읽음 처리가 같은 샘을 흔들어 **홈 벨 배지([unreadNotificationCountProvider])도
/// 같이 줄어든다** — 둘 다 datasource 가 들고 있는 한 목록을 본다.
final notificationListProvider =
    StreamProvider.autoDispose<List<AppNotificationModel>>((ref) {
      final uid = ref.watch(currentUidProvider);
      if (uid == null) return Stream.value(const []);
      return ref.watch(notificationDataSourceProvider).watchNotifications(uid);
    });

/// 고른 종류 필터. null = 전체 (디자인 `NG_FILTERS`).
final notificationFilterProvider =
    NotifierProvider.autoDispose<NotificationFilter, NotificationCategory?>(
      NotificationFilter.new,
    );

class NotificationFilter extends Notifier<NotificationCategory?> {
  @override
  NotificationCategory? build() => null;

  void select(NotificationCategory? category) => state = category;
}

/// 읽음 처리. 화면은 이 둘만 부른다.
final notificationActionsProvider = Provider.autoDispose<NotificationActions>(
  NotificationActions.new,
);

class NotificationActions {
  const NotificationActions(this._ref);

  final Ref _ref;

  /// 알림 1건 읽음. 서버가 `unreadNotificationCount` 를 재계산한다(설계 4장).
  Future<void> markRead(String notificationId) async {
    final uid = _ref.read(currentUidProvider);
    if (uid == null) return;
    await _ref
        .read(notificationDataSourceProvider)
        .markRead(uid, notificationId);
  }

  Future<void> markAllRead() async {
    final uid = _ref.read(currentUidProvider);
    if (uid == null) return;
    await _ref.read(notificationDataSourceProvider).markAllRead(uid);
  }
}

/// 안 읽은 알림 수 — HOME-005 벨 배지.
///
/// 설계 6-0 HOME-005 「알림 아이콘 배지 = users.unreadNotificationCount」.
/// 값 자체는 서버만 증감한다(설계 4장) — 앱은 읽기만 한다.
///
/// ⚠ 조회가 끝나기 전·실패하면 **0** 으로 읽는다. 데이터가 없는데 배지를
/// 켜 두면(= 베타의 상시 표시 점) 눌러도 새 알림이 없어 배지가 거짓이 된다.
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(0);
  return ref.watch(notificationDataSourceProvider).watchUnreadCount(uid);
});

/// 알림 토글 4종 — MY-029 설정.
///
/// 설계 6-0 MY-029 「알림 토글 4종 + 마케팅 = users.notificationSettings ·
/// agreements.marketing (updateNotificationSettings) · 위치·사운드는 로컬」.
/// 마케팅은 여기 없다 — 수신 동의라 `agreements.marketing` 이 정본이다.
///
/// ⚠ **autoDispose 를 쓰지 않는다** — 설정 화면을 닫아도 값이 남아 있어야
/// 다시 들어왔을 때 켜 둔 토글이 그대로다(차이 #2 의 알맹이).
final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsViewModel, NotificationSettings>(
      NotificationSettingsViewModel.new,
    );

class NotificationSettingsViewModel extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() {
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return Future.value(const NotificationSettings());
    return ref.watch(notificationDataSourceProvider).getSettings(uid);
  }

  /// 토글 하나 뒤집기. 표시를 먼저 바꾸고 쓰기가 실패하면 되돌린다 —
  /// 저장 왕복을 기다리면 토글이 손가락을 따라오지 않는다.
  ///
  /// 반환값은 저장 성공 여부다. 실패하면 화면이 안내를 띄운다
  /// (조용히 되돌리면 사용자는 끈 줄 안다).
  Future<bool> toggle(String key) async {
    final uid = ref.read(currentUidProvider);
    final before = state.value;
    if (uid == null || before == null) return false;

    final next = before.toggled(key);
    if (next == before) return true; // 모르는 키
    state = AsyncData(next);
    try {
      final saved = await ref
          .read(notificationDataSourceProvider)
          .updateSettings(uid, next);
      state = AsyncData(saved);
      return true;
    } catch (_) {
      state = AsyncData(before);
      return false;
    }
  }
}
