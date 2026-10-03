import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/datasources/waiting_datasource.dart';
import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/waiting_model.dart';

/// 메모리 Fake. Firebase 호출 없음.
///
/// 결과는 [fakeScenario] 로 바뀐다 — 개발 메뉴에서 로딩 · 빈 상태 · 실패 · 만료 · 잠김 · 마감을 고른다.
class FakeWaitingDataSource implements WaitingDataSource {
  @override
  Stream<List<WaitingModel>> watchMyWaitings(String uid) async* {
    await fakeGate();
    yield switch (fakeScenario.value) {
      FakeScenario.empty => const [],
      FakeScenario.expired => [FakeSample.waitingCancelled],
      FakeScenario.locked => [FakeSample.waiting],
      _ => [FakeSample.waitingCalled, FakeSample.waitingOther],
    };
  }

  @override
  Stream<WaitingModel?> watchWaiting(String clubId, String waitingId) async* {
    await fakeGate();
    yield switch (fakeScenario.value) {
      FakeScenario.empty => null,
      FakeScenario.expired => FakeSample.waitingCancelled,
      FakeScenario.locked => FakeSample.waiting,
      FakeScenario.closed => FakeSample.waitingEntered,
      _ => FakeSample.waitingCalled,
    };
  }

  @override
  Stream<ClubOpsLive?> watchOpsLive(String clubId) async* {
    await fakeGate();
    final live = FakeSample.opsLive;
    yield switch (fakeScenario.value) {
      FakeScenario.empty => null,
      FakeScenario.closed => live.copyWith(
        phase: OpsPhase.closed,
        waiting: live.waiting.copyWith(accept: false, closed: true),
      ),
      _ => live,
    };
  }

  @override
  Future<ClubOpsSettings?> getOpsSettings(String clubId) async {
    await fakeGate();
    if (fakeScenario.value == FakeScenario.empty) return null;
    return FakeSample.opsSettings;
  }

  @override
  Future<WaitingModel> registerWaiting({
    required String clubId,
    required int people,
    required bool noticeAgreed,
    required double lat,
    required double lng,
  }) async {
    await fakeGate();
    // 서버가 정하는 값(seq · fee.total)을 Fake 도 '정해 준다' — 화면은 받기만 한다.
    const s = FakeSample.opsSettings;
    return FakeSample.waiting.copyWith(
      people: people,
      fee: FakeSample.waiting.fee.copyWith(
        unit: s.entryFee,
        people: people,
        total: s.entryFee * people,
      ),
      noticeAgreed: noticeAgreed,
      locationChecked: true,
    );
  }

  @override
  Future<WaitingModel> postponeWaiting(String clubId, String waitingId) async {
    await fakeGate();
    return FakeSample.waitingPostponed;
  }

  @override
  Future<void> cancelWaiting(String clubId, String waitingId) => fakeGate();

  @override
  Future<EntryQrToken> issueEntryQr(String clubId, String waitingId) async {
    await fakeGate();
    final now = DateTime.now();
    // 만료 시나리오는 이미 지난 토큰을 준다 — PASS-041 의 '만료됨' 상태 확인용.
    final issued = fakeScenario.value == FakeScenario.expired
        ? now.subtract(EntryQrToken.validity)
        : now;
    return EntryQrToken(
      token: 'fake.$clubId.$waitingId.${issued.millisecondsSinceEpoch}',
      issuedAt: issued,
      expiresAt: issued.add(EntryQrToken.validity),
    );
  }

  @override
  Future<void> hideWaiting(String clubId, String waitingId) => fakeGate();
}
