import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/repositories/club_repository_impl.dart';
import 'package:vybe/presentation/kpop/kpop_models.dart';

/// K-POP 페이지 클럽 목록 — `clubs` 에서 [kKpopGenre] 활성 클럽만.
///
/// EDM 과 달리 `performances` 를 같이 읽지 않는다 — 이 페이지엔 공연 일정 섹션이
/// 없어서(디자인 kpop_renew.jsx) 조회할 이유가 없다. 쿼리 하나뿐이라
/// `AsyncNotifier` 클래스 없이 `FutureProvider` 로 둔다.
final kpopClubsProvider = FutureProvider.autoDispose<List<ClubModel>>(
  _kpopClubs,
);

Future<List<ClubModel>> _kpopClubs(Ref ref) =>
    ref.watch(clubRepositoryProvider).getClubsByGenre(kKpopGenre);
