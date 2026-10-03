import 'package:vybe/data/datasources/club_ops_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';

/// 메모리 Fake. Firebase 호출 없음.
///
/// 결과는 [fakeScenario] 로 바뀐다 — 개발 메뉴에서 고른다.
/// | 시나리오 | 운영 상태 |
/// |---|---|
/// | 빈 상태 | 문서 없음 = **웨이팅 정보를 모른다**(화면이 줄째로 뺀다) |
/// | 기본 | 대기 N팀 (clubId 로 4·2·7팀 중 하나) |
/// | 잠김 | 접수 중지 (`accept: false`) |
/// | 마감 | 영업 종료 · 접수 마감 (`phase: closed` · `closed: true`) |
///
/// ⚠ **클럽별 대기 수는 clubId 해시로 정한다** — 베타 클럽 164곳의 실제
/// 운영 데이터가 없는데 전부 같은 숫자를 쓰면 지도에서 '대기 4팀' 이 164개
/// 붙어 화면 확인이 안 된다. 재실행해도 같은 값이라 화면을 다시 열었을 때
/// 숫자가 흔들리지 않는다(프로젝트의 seed 스크립트와 같은 방식).
///
/// ⚠ **모든 클럽에 ops 문서를 주지 않는다** — 실제로도 v1 기능을 켠 클럽만
/// 있다(`features.waiting`). 해시로 약 2/3 만 운영 중으로 둔다.
class FakeClubOpsDataSource implements ClubOpsDataSource {
  @override
  Stream<ClubOpsLive?> watchOpsLive(String clubId) async* {
    await fakeGate();
    yield _forClub(clubId, alwaysOn: true);
  }

  @override
  Stream<Map<String, ClubOpsLive>> watchOpsLiveMany(
    List<String> clubIds,
  ) async* {
    await fakeGate();
    if (fakeScenario.value == FakeScenario.empty) {
      yield const {};
      return;
    }
    final out = <String, ClubOpsLive>{};
    for (final id in clubIds) {
      final live = _forClub(id);
      if (live != null) out[id] = live;
    }
    yield out;
  }

  /// `null` = 이 클럽은 웨이팅을 안 쓴다(= 모른다).
  ClubOpsLive? _forClub(String clubId, {bool alwaysOn = false}) {
    if (fakeScenario.value == FakeScenario.empty) return null;

    final h = _hash(clubId);
    // 3곳 중 1곳은 웨이팅 미사용. 상세 화면은 티켓 흐름이 걸려 있어 늘 켠다.
    if (!alwaysOn && h % 3 == 0) return null;

    final counts = [4, 2, 7];
    final base = FakeSample.opsLive;
    final live = base.copyWith(
      waiting: base.waiting.copyWith(waitingCount: counts[h % counts.length]),
    );

    return switch (fakeScenario.value) {
      FakeScenario.locked => live.copyWith(
        waiting: live.waiting.copyWith(accept: false),
      ),
      FakeScenario.closed => live.copyWith(
        phase: OpsPhase.closed,
        waiting: live.waiting.copyWith(accept: false, closed: true),
      ),
      _ => live,
    };
  }

  /// 작은 결정적 해시 — 같은 clubId 는 늘 같은 값.
  int _hash(String s) {
    var h = 0;
    for (final c in s.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return h;
  }
}
