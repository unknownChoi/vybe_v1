import 'dart:async';

import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/datasources/notification_datasource.dart';
import 'package:vybe/data/models/v1/pass_models.dart';

/// 메모리 Fake. Firebase 호출 없음.
///
/// 결과는 [fakeScenario] 로 바뀐다 — 개발 메뉴에서 고른다.
/// | 시나리오 | 목록 | 안 읽은 수 | 뜻 |
/// |---|---|---|---|
/// | 빈 상태 | 0건 | 0 | 배지 없음 · 빈 카드 |
/// | 기본 | 8건 | 3 | 디자인 `NG_NOTIS` 그대로 |
/// | 만료 | 12건 | 12 | 두 자리 — 디자인 배지는 **점**이라 표시가 같아야 한다 |
///
/// ⚠ **안 읽은 수는 목록에서 센다** — 상수로 따로 두면 알림 하나를 읽어도
/// 홈 벨 배지가 그대로라, 사용자가 "읽었는데 왜 배지가 남지" 를 보게 된다.
/// 서버는 `users.unreadNotificationCount` 를 재계산하는데(설계 4장) Fake 에선
/// 그 재계산이 곧 목록 집계다.
///
/// ⚠ 상태는 **이 인스턴스 안에** 들고 있는다(provider 가 한 번만 만든다) —
/// 화면을 닫았다 열어도 읽음·토글이 유지돼야 한다.
class FakeNotificationDataSource implements NotificationDataSource {
  FakeNotificationDataSource() {
    // 개발 메뉴에서 시나리오를 바꾸면 목록을 그 시나리오로 다시 만든다.
    fakeScenario.addListener(_rebuild);
  }

  NotificationSettings _settings = const NotificationSettings();

  /// 지금 들고 있는 알림. 읽음 처리는 이 목록을 갈아 끼운다.
  List<AppNotificationModel> _items = const [];

  /// `_items` 를 어느 시나리오로 만들었는지. 바뀌면 다시 만든다.
  FakeScenario? _builtFor;

  /// 목록이 바뀔 때마다 흘려보낸다 — 알림 화면과 홈 배지가 같은 샘을 본다.
  final StreamController<void> _changes = StreamController<void>.broadcast();

  List<AppNotificationModel> get _list {
    if (_builtFor != fakeScenario.value) {
      _builtFor = fakeScenario.value;
      _items = switch (fakeScenario.value) {
        FakeScenario.empty => const [],
        FakeScenario.expired => FakeSample.notificationsMany,
        _ => FakeSample.notifications,
      };
    }
    return _items;
  }

  void _rebuild() {
    if (_builtFor == fakeScenario.value) return;
    _builtFor = null;
    _list; // 다시 만든다
    if (!_changes.isClosed) _changes.add(null);
  }

  @override
  Stream<int> watchUnreadCount(String uid) async* {
    await fakeGate();
    yield _list.where((n) => !n.read).length;
    yield* _changes.stream.map((_) => _list.where((n) => !n.read).length);
  }

  @override
  Stream<List<AppNotificationModel>> watchNotifications(String uid) async* {
    await fakeGate();
    yield _list;
    yield* _changes.stream.map((_) => _list);
  }

  @override
  Future<void> markAllRead(String uid) async {
    await fakeGate();
    _items = [for (final n in _list) n.read ? n : n.copyWith(read: true)];
    if (!_changes.isClosed) _changes.add(null);
  }

  @override
  Future<void> markRead(String uid, String notificationId) async {
    await fakeGate();
    _items = [
      for (final n in _list)
        n.notificationId == notificationId ? n.copyWith(read: true) : n,
    ];
    if (!_changes.isClosed) _changes.add(null);
  }

  /// 무료입장 알림을 켠 클럽들. 화면을 닫았다 열어도 유지돼야 한다.
  final Set<String> _freeEntryAlerts = <String>{};

  @override
  Stream<bool> watchFreeEntryAlert(String uid, String clubId) async* {
    await fakeGate();
    yield _freeEntryAlerts.contains(clubId);
  }

  @override
  Future<bool> setFreeEntryAlert(
    String uid,
    String clubId,
    bool enabled,
  ) async {
    await fakeGate();
    enabled ? _freeEntryAlerts.add(clubId) : _freeEntryAlerts.remove(clubId);
    return enabled;
  }

  @override
  Future<NotificationSettings> getSettings(String uid) async {
    await fakeGate();
    return _settings;
  }

  @override
  Future<NotificationSettings> updateSettings(
    String uid,
    NotificationSettings settings,
  ) async {
    await fakeGate();
    return _settings = settings;
  }
}
