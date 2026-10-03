import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/data/models/v1/waiting_model.dart';
import 'package:vybe/data/repositories/v1_providers.dart';

/// 클럽 1곳 실시간 운영 상태 — `clubs/{clubId}/ops/live`.
///
/// 설계 6-0 PLACE-019 「핀 카드에 ops/live.waiting.waitingCount 표시
/// (클럽당 1 read 추가 · **핀 탭 시만**)」 · 6-X 'clubs/{clubId} 1 read +
/// ops/live 1 read (대기 팀 수)'.
///
/// ⚠ **autoDispose** — 핀을 닫으면 구독도 끊어야 한다. 지도에 핀이 수십 개인데
/// 탭할 때마다 구독이 쌓이면 화면 하나가 문서 수십 개를 들고 있게 된다.
///
/// 값이 null 이면 **모른다**는 뜻이다(웨이팅을 안 쓰는 클럽 · 조회 전).
/// 화면은 그 자리에 대기 팀 수를 그리지 않는다 — 0팀이라고 말하면 안 된다.
final clubOpsLiveProvider = StreamProvider.autoDispose
    .family<ClubOpsLive?, String>(
      (ref, clubId) =>
          ref.watch(clubOpsDataSourceProvider).watchOpsLive(clubId),
    );

/// 이 클럽이 켜 둔 v1 기능 — 하단 바 버튼 노출(설계 6-0 CLUB-021).
///
/// 조회 전에는 `ClubFeatures()`(전부 false)로 읽힌다 — 아직 모를 때 버튼을
/// 먼저 그렸다가 지우면 하단 바가 한 번 튄다.
final clubFeaturesProvider = FutureProvider.autoDispose
    .family<ClubFeatures, String>(
      (ref, clubId) =>
          ref.watch(clubOpsDataSourceProvider).getFeatures(clubId),
    );

/// 클럽 운영 설정 — 입장비(WAIT ↔ FEE 분기) · 인원 범위 · 팀당 기준 시간.
final clubOpsSettingsProvider = FutureProvider.autoDispose
    .family<ClubOpsSettings?, String>(
      (ref, clubId) =>
          ref.watch(clubOpsDataSourceProvider).getSettings(clubId),
    );

/// 무료입장 시작 10분 전 알림 구독 — `users/{uid}/freeEntryAlerts/{clubId}`.
///
/// 비로그인은 늘 false. 토글은 [toggleFreeEntryAlert].
final freeEntryAlertProvider = StreamProvider.autoDispose
    .family<bool, String>((ref, clubId) {
      final uid = ref.watch(currentUidProvider);
      if (uid == null) return Stream.value(false);
      return ref
          .watch(notificationDataSourceProvider)
          .watchFreeEntryAlert(uid, clubId);
    });

/// 알림 토글. 저장 성공 여부를 돌려준다 — 실패하면 화면이 안내를 띄운다.
///
/// 로그인이 없으면 false(화면이 '로그인 후…' 안내).
///
/// ⚠ `Ref` 가 아니라 `WidgetRef` 를 받는다 — 호출부가 위젯이다.
Future<bool> toggleFreeEntryAlert(
  WidgetRef ref,
  String clubId,
  bool next,
) async {
  final uid = ref.read(currentUidProvider);
  if (uid == null) return false;
  try {
    await ref
        .read(notificationDataSourceProvider)
        .setFreeEntryAlert(uid, clubId, next);
    ref.invalidate(freeEntryAlertProvider(clubId));
    return true;
  } catch (_) {
    return false;
  }
}

/// 이 클럽에 내가 걸어 둔 웨이팅 티켓. 없으면 null.
///
/// 패스월렛(PASS-035)이 쓰는 '내 활성 티켓' 구독을 clubId 로 거른 것이다 —
/// 클럽 상세의 하단 바 라벨('웨이팅 N번째')과 홈 첫 카드가 이걸 본다.
final myClubWaitingProvider = StreamProvider.autoDispose
    .family<WaitingModel?, String>((ref, clubId) {
      final uid = ref.watch(currentUidProvider);
      if (uid == null) return Stream.value(null);
      return ref
          .watch(waitingDataSourceProvider)
          .watchMyWaitings(uid)
          .map(
            (list) => list
                .where((w) => w.clubId == clubId && !w.status.isClosed)
                .firstOrNull,
          );
    });
