import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/datasources/notification_datasource.dart';
import 'package:vybe/data/models/v1/pass_models.dart';

/// 메모리 Fake. Firebase 호출 없음.
///
/// 결과는 [fakeScenario] 로 바뀐다 — 개발 메뉴에서 고른다.
/// | 시나리오 | 안 읽은 수 | 뜻 |
/// |---|---|---|
/// | 빈 상태 | 0 | 배지 없음 |
/// | 기본 | 3 | 배지 있음(설계 4장 예시값) |
/// | 만료 | 12 | 두 자리 — 디자인 배지는 **점**이라 표시가 같아야 한다 |
///
/// ⚠ 설정은 **이 인스턴스 안에** 들고 있는다(provider 가 한 번만 만든다) —
/// 화면을 닫았다 열어도 토글이 유지돼야 한다. 그게 MY-029 차이 #2 의 알맹이다.
class FakeNotificationDataSource implements NotificationDataSource {
  NotificationSettings _settings = const NotificationSettings();

  /// 읽음 처리를 한 번이라도 했으면 배지를 0으로 둔다 —
  /// 서버가 `unreadNotificationCount` 를 재계산하는 자리의 Fake.
  bool _allRead = false;

  @override
  Stream<int> watchUnreadCount(String uid) async* {
    await fakeGate();
    if (_allRead) {
      yield 0;
      return;
    }
    yield switch (fakeScenario.value) {
      FakeScenario.empty => 0,
      FakeScenario.expired => FakeSample.unreadNotificationCountMany,
      _ => FakeSample.unreadNotificationCount,
    };
  }

  @override
  Stream<List<AppNotificationModel>> watchNotifications(String uid) async* {
    await fakeGate();
    yield switch (fakeScenario.value) {
      FakeScenario.empty => const [],
      _ => FakeSample.notifications,
    };
  }

  @override
  Future<void> markAllRead(String uid) async {
    await fakeGate();
    _allRead = true;
  }

  @override
  Future<void> markRead(String uid, String notificationId) async {
    await fakeGate();
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
