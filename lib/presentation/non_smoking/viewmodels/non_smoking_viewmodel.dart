import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/repositories/club_repository_impl.dart';

/// 금연 페이지 클럽 목록 — `clubs` 에서 `isNonSmoking=true` 활성 클럽만.
///
/// 쿼리 하나뿐이라 `AsyncNotifier` 클래스 없이 `FutureProvider` 로 둔다(K-POP 과 동일).
final nonSmokingClubsProvider = FutureProvider.autoDispose<List<ClubModel>>(
  _nonSmokingClubs,
);

Future<List<ClubModel>> _nonSmokingClubs(Ref ref) =>
    ref.watch(clubRepositoryProvider).getNonSmokingClubs();
