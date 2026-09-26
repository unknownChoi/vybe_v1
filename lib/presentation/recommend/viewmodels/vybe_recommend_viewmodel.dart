import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/repositories/vybe_recommendation_repository_impl.dart';

/// vybe 추천 페이지 데이터. rank 오름차순 활성 추천 목록.
/// 첫 항목(rank 1) = featured 히어로, 나머지 = 순위 리스트.
/// 쿼리 하나뿐이라 `AsyncNotifier` 클래스 없이 `FutureProvider` 로 둔다.
final vybeRecommendViewModelProvider =
    FutureProvider.autoDispose<List<VybeRecommendedClub>>(
      (ref) => ref
          .watch(vybeRecommendationRepositoryProvider)
          .getActiveRecommendations(),
    );
