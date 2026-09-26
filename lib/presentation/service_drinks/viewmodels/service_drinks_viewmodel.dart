import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/repositories/club_repository_impl.dart';

/// 서비스 음료(무료 제공) 클럽 목록.
/// clubs 중 serviceDrink.isOffered=true 인 활성 클럽. 종류/위치/정렬 필터는 화면에서 처리.
/// 쿼리 하나뿐이라 `AsyncNotifier` 클래스 없이 `FutureProvider` 로 둔다(K-POP 과 동일).
final serviceDrinksViewModelProvider =
    FutureProvider.autoDispose<List<ClubModel>>(
      (ref) => ref.watch(clubRepositoryProvider).getServiceDrinkClubs(),
    );
