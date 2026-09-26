import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/performance_model.dart';
import 'package:vybe/data/repositories/club_repository_impl.dart';
import 'package:vybe/data/repositories/performance_repository_impl.dart';

/// 장르 페이지(힙합·EDM) 데이터 — 그 장르의 활성 클럽 + 오늘 공연 일정.
/// 타임테이블(공연 + 클럽 조인)·포스터 그리드(클럽 + 라인업 머지)는 화면에서 가공.
class GenrePageData {
  final List<ClubModel> clubs; // genre=장르 활성 클럽
  final List<PerformanceModel> performances; // 오늘(KST) 공연, 시작시각 오름차순

  GenrePageData({required this.clubs, required this.performances});

  /// clubId → 클럽. 타임테이블이 지역·거리를 조인할 때 쓴다.
  late final Map<String, ClubModel> clubById = {
    for (final c in clubs) c.clubId: c,
  };

  /// clubId → 오늘 헤드라이너 공연(가장 이른 시각). 포스터 live/lineup 머지용.
  late final Map<String, PerformanceModel> headlinerByClub = () {
    final map = <String, PerformanceModel>{};
    for (final p in performances) {
      // performances는 startAt 오름차순 → 클럽별 첫 건이 가장 이른 공연.
      map.putIfAbsent(p.clubId, () => p);
    }
    return map;
  }();
}

/// 장르 클럽 + 오늘 공연 일정을 병렬 조회해 합친다. 인자는 `clubs.genre` ·
/// `performances.genre` 값('힙합'·'EDM') — 두 쿼리가 같은 문자열을 본다.
final genrePageProvider = FutureProvider.autoDispose
    .family<GenrePageData, String>(_genrePage);

Future<GenrePageData> _genrePage(Ref ref, String genre) async {
  // 클럽은 필수. 오늘 공연(performances)은 인덱스 미생성/데이터 없음 시
  // 실패해도 클럽 그리드는 보여야 하므로 비치명적으로 처리.
  final clubsF = ref.read(clubRepositoryProvider).getClubsByGenre(genre);
  final perfsF = ref
      .read(performanceRepositoryProvider)
      .getTodayPerformances(genre: genre)
      .catchError((e, st) {
        debugPrint('[$genre] performances 조회 실패: $e');
        return <PerformanceModel>[];
      });
  final results = await (clubsF, perfsF).wait;
  return GenrePageData(clubs: results.$1, performances: results.$2);
}
