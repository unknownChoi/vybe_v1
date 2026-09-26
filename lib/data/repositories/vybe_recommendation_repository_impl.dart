import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_club_datasource.dart';
import 'package:vybe/data/datasources/remote/firebase_vybe_recommendation_datasource.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/vybe_recommendation_model.dart';

/// 큐레이션(VybeRecommendationModel) + 클럽 기본정보(ClubModel) 조인 결과.
/// presentation 레이어는 이 엔티티만 소비한다.
class VybeRecommendedClub {
  final VybeRecommendationModel recommendation;
  final ClubModel club;

  const VybeRecommendedClub({required this.recommendation, required this.club});

  int get rank => recommendation.rank;
  int get match => recommendation.match;
  String get reason => recommendation.reason;

  /// 큐레이션 태그 override가 있으면 그것, 없으면 클럽 태그.
  List<String> get tags =>
      recommendation.tags.isNotEmpty ? recommendation.tags : club.tags;

  bool get isOpen => club.operatingHours.today.isCurrentlyOpen;
}

final vybeRecommendationRepositoryProvider =
    Provider<VybeRecommendationRepositoryImpl>(_vybeRecommendationRepository);

VybeRecommendationRepositoryImpl _vybeRecommendationRepository(Ref ref) =>
    VybeRecommendationRepositoryImpl(
      FirebaseVybeRecommendationDataSource(),
      FirebaseClubDataSource(),
    );

class VybeRecommendationRepositoryImpl {
  final FirebaseVybeRecommendationDataSource _recDataSource;
  final FirebaseClubDataSource _clubDataSource;

  VybeRecommendationRepositoryImpl(this._recDataSource, this._clubDataSource);

  Future<List<VybeRecommendedClub>> getActiveRecommendations() async {
    final recs = await _recDataSource.getActiveRecommendations();
    if (recs.isEmpty) return [];

    final clubs = await _clubDataSource.getClubsByIds(
      recs.map((r) => r.clubId).toList(),
    );
    final byId = {for (final c in clubs) c.clubId: c};

    // rank 순서 유지. 클럽이 없거나 비활성이면 제외.
    final result = <VybeRecommendedClub>[];
    for (final r in recs) {
      final club = byId[r.clubId];
      if (club == null || !club.isActive) continue;
      result.add(VybeRecommendedClub(recommendation: r, club: club));
    }
    return result;
  }
}
