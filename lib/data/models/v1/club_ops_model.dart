import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';

part 'club_ops_model.freezed.dart';

/// 클럽 운영 설정. `clubs/{clubId}/ops/settings`.
///
/// 저장할 때마다 [version] 이 +1 되고, 티켓이 그 값을 스냅샷으로 들고 간다.
@freezed
abstract class ClubOpsSettings with _$ClubOpsSettings {
  const ClubOpsSettings._();

  const factory ClubOpsSettings({
    /// 1인 입장비(원 · 1,000 단위 · 0 = 없음).
    @Default(0) int entryFee,
    @Default(1) int minPeople,

    /// ⚠ 앱 스테퍼 상한과 같아야 한다(설계: maxPeople ≤ 8).
    @Default(8) int maxPeople,

    /// 팀당 기준 대기시간(분 · 5~60 · 5단위).
    @Default(10) int perTeamMin,

    /// 예약 도착 시간 슬롯.
    @Default(<ArrivalSlot>[]) List<ArrivalSlot> arrivalSlots,

    /// 주문 자동 '만드는 중' 전환.
    @Default(false) bool autoMaking,
    @Default(0) int version,
    DateTime? updatedAt,
  }) = _ClubOpsSettings;

  /// 입장비를 받는 클럽인지 — FEE 흐름으로 갈지 바로 등록할지 가른다.
  bool get hasEntryFee => entryFee > 0;

  /// 고를 수 있는 슬롯만.
  List<ArrivalSlot> get openSlots =>
      arrivalSlots.where((s) => s.enabled).toList();
}

/// 클럽이 켜 둔 v1 기능 — `clubs.features` (설계 4장).
///
/// 용도는 **하단 바 버튼 노출(CLUB-021)** 하나다. 꺼진 기능은 버튼을 아예
/// 그리지 않는다(회색으로 두면 눌러 보고 나서야 안 된다는 걸 안다).
/// 서버 쪽에서는 미지원이면 함수가 `failed-precondition` 으로 막는다.
///
/// ⚠ 설계는 이 map 을 `clubs` 문서에 두지만 **베타 clubs 문서엔 없다**
/// (설계 4장 마이그레이션 '기존 클럽에 features(기본 false) 백필'). 그래서 UI
/// 단계에서는 `ClubOpsDataSource` 가 같이 돌려준다 — 백엔드 단계에서 읽는 자리만
/// `clubs` 로 옮기고 화면은 그대로 둔다.
@freezed
abstract class ClubFeatures with _$ClubFeatures {
  const ClubFeatures._();

  const factory ClubFeatures({
    @Default(false) bool waiting,
    @Default(false) bool reservation,
    @Default(false) bool order,
  }) = _ClubFeatures;

  /// 하나도 안 켠 클럽 — 하단 바가 베타처럼 그려진다.
  bool get none => !waiting && !reservation && !order;
}

/// 예약 도착 시간 슬롯 한 칸.
@freezed
abstract class ArrivalSlot with _$ArrivalSlot {
  const factory ArrivalSlot({
    /// '20:00'.
    required String label,
    @Default(true) bool enabled,
  }) = _ArrivalSlot;
}

/// 영업일 실시간 상태(핫 문서). `clubs/{clubId}/ops/live`.
///
/// 앱이 **구독**한다 — 웨이팅 카드 · 입장비 화면 · 주변 지도 핀 카드가 본다.
@freezed
abstract class ClubOpsLive with _$ClubOpsLive {
  const ClubOpsLive._();

  const factory ClubOpsLive({
    required String businessDate,
    @Default(OpsPhase.unknown) OpsPhase phase,
    DateTime? openedAt,
    DateTime? closedAt,
    DateTime? autoOpenAt,
    DateTime? autoCloseAt,
    @Default(OpsLiveWaiting()) OpsLiveWaiting waiting,
    @Default(OpsLiveOrder()) OpsLiveOrder order,
    @Default(OpsLiveReservation()) OpsLiveReservation reservation,
    @Default(OpsLiveShare()) OpsLiveShare share,
    DateTime? updatedAt,
  }) = _ClubOpsLive;

  bool get isOpen => phase == OpsPhase.open;

  /// 예상 대기 시간(분) — 앞 팀 수 × 팀당 기준 시간.
  int estimatedWaitMinutes(int perTeamMin) =>
      waiting.waitingCount * perTeamMin;
}

/// `ops/live.waiting`.
@freezed
abstract class OpsLiveWaiting with _$OpsLiveWaiting {
  const OpsLiveWaiting._();

  const factory OpsLiveWaiting({
    /// 지금 웨이팅을 받는지.
    @Default(false) bool accept,

    /// 오늘 웨이팅 마감.
    @Default(false) bool closed,
    @Default(1) int nextSeq,

    /// 대기 중인 순번들.
    @Default(<int>[]) List<int> queue,

    /// 호출된 순번들.
    @Default(<int>[]) List<int> calledSeqs,
    @Default(0) int waitingCount,
    @Default(0) int calledCount,
    @Default(0) int enteredCount,
    @Default(0) int noShowCount,
    @Default(0) int cancelledCount,

    /// 오늘 실측 팀당 평균(분).
    @Default(0) int perTeamMinToday,
  }) = _OpsLiveWaiting;

  /// 내 순번 앞에 남은 팀 수.
  int aheadOf(int mySeq) => queue.where((s) => s < mySeq).length;
}

/// `ops/live.order`.
@freezed
abstract class OpsLiveOrder with _$OpsLiveOrder {
  const factory OpsLiveOrder({
    @Default(false) bool accept,
    @Default(1) int nextNo,
    @Default(0) int paidCount,
    @Default(0) int makingCount,
    @Default(0) int readyCount,
    @Default(0) int doneCount,
  }) = _OpsLiveOrder;
}

/// `ops/live.reservation`.
@freezed
abstract class OpsLiveReservation with _$OpsLiveReservation {
  const factory OpsLiveReservation({
    @Default(0) int todayCount,
    @Default(0) int convertedCount,
    @Default(0) int enteredCount,
    @Default(0) int pendingCount,
  }) = _OpsLiveReservation;
}

/// `ops/live.share`.
@freezed
abstract class OpsLiveShare with _$OpsLiveShare {
  const factory OpsLiveShare({
    @Default(0) int activeCount,
    @Default(0) int receivedCount,
    @Default(0) int enteredCount,
  }) = _OpsLiveShare;
}
