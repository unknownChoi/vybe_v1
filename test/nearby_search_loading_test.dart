import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/data/repositories/club_repository_impl.dart';
import 'package:vybe/domain/repositories/club_repository.dart';
import 'package:vybe/presentation/nearby/viewmodels/nearby_search_provider.dart';

/// 지도 검색은 엔진 응답이 오기 전에 **로딩 상태**를 먼저 넣어야 한다 —
/// 없으면 응답까지 이전 geo 목록·핀이 그대로 남아 검색이 안 된 것처럼 보인다.
class _GatedRepo implements ClubRepository {
  final gate = Completer<void>();
  bool fail = false;

  @override
  Future<ClubSearchPage> searchClubsPage(
    String keyword, {
    Object? cursor,
    int pageSize = 10,
  }) async {
    await gate.future;
    if (fail) throw Exception('algolia down');
    return const ClubSearchPage(
      clubs: [],
      cursor: 1,
      hasMore: false,
      totalCount: 0,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('응답 전엔 loading·빈 목록, 응답 후엔 새 requestId 로 결과', () async {
    final repo = _GatedRepo();
    final container = ProviderContainer(
      overrides: [clubRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final future = container
        .read(nearbySearchResultProvider.notifier)
        .search('홍대');
    final loading = container.read(nearbySearchResultProvider)!;
    expect(loading.loading, isTrue);
    expect(loading.keyword, '홍대');
    expect(loading.clubs, isEmpty);

    repo.gate.complete();
    await future;
    final done = container.read(nearbySearchResultProvider)!;
    expect(done.loading, isFalse);
    // 로딩 상태와 다른 id 여야 마커 계획이 '새 검색'으로 보고 카메라를 맞춘다.
    expect(done.requestId, greaterThan(loading.requestId));
  });

  test('엔진 실패 → 스켈레톤에 갇히지 않고 빈 결과로 확정', () async {
    final repo = _GatedRepo()..fail = true;
    final container = ProviderContainer(
      overrides: [clubRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final future = container
        .read(nearbySearchResultProvider.notifier)
        .search('홍대');
    repo.gate.complete();
    await future;
    final done = container.read(nearbySearchResultProvider)!;
    expect(done.loading, isFalse);
    expect(done.clubs, isEmpty);
    expect(done.keyword, '홍대');
  });

  test('로딩 중 clear() → 늦게 온 응답이 검색 모드를 되살리지 않는다', () async {
    final repo = _GatedRepo();
    final container = ProviderContainer(
      overrides: [clubRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(nearbySearchResultProvider.notifier);
    final future = notifier.search('홍대');
    notifier.clear();
    repo.gate.complete();
    await future;
    expect(container.read(nearbySearchResultProvider), isNull);
  });
}
