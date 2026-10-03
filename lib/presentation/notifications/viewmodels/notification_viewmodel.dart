import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/repositories/v1_providers.dart';
import 'package:vybe/presentation/notifications/notification_item.dart';

/// 백엔드 연동 전 로딩 흉내 — 이 시간만큼 스켈레톤을 보여준 뒤 목록을 노출한다.
/// 실연동 시 이 지연 대신 repository 호출로 교체한다.
const _kFakeLoadDelay = Duration(milliseconds: 1100);

/// 알림 화면 상태.
///
/// 목록과 로딩을 따로 둔다 — 본문은 스켈레톤이어도 헤더의 안 읽은 개수는
/// 처음부터 보여야 하기 때문(디자인 NotiGlassApp도 `notis`/`loading` 분리).
class NotificationState {
  final List<NotificationItem> items;
  final bool loading;

  const NotificationState({required this.items, required this.loading});

  int get unreadCount => items.where((n) => !n.read).length;

  NotificationState copyWith({List<NotificationItem>? items, bool? loading}) =>
      NotificationState(
        items: items ?? this.items,
        loading: loading ?? this.loading,
      );
}

/// 알림 목록 + 읽음 처리.
///
/// 화면(위젯)은 상태를 들고 있지 않고 이 ViewModel만 구독한다.
/// autoDispose라 화면을 나가면 상태가 비워져 재진입 시 다시 로딩부터 시작한다.
final notificationViewModelProvider =
    NotifierProvider.autoDispose<NotificationViewModel, NotificationState>(
      NotificationViewModel.new,
    );

class NotificationViewModel extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    final timer = Timer(
      _kFakeLoadDelay,
      () => state = state.copyWith(loading: false),
    );
    // 로딩 중 화면을 나가면 dispose된 notifier에 state를 쓰게 되므로 취소.
    ref.onDispose(timer.cancel);

    return const NotificationState(items: kDummyNotifications, loading: true);
  }

  void markAllRead() => state = state.copyWith(
    items: [for (final n in state.items) n.copyWith(read: true)],
  );

  void markRead(int id) => state = state.copyWith(
    items: [
      for (final n in state.items) n.id == id ? n.copyWith(read: true) : n,
    ],
  );
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
