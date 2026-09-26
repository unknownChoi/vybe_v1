import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/repositories/club_repository_impl.dart';

/// 무료입장 클럽 목록 — 상시 무료 + 시간대 무료를 모두 담는다.
///
/// clubs 중 `isFreeEntry=true` 인 활성 클럽. 지역/정렬 필터와 '지금 무료' 판정은
/// 화면에서 처리한다 (요일 × 시:분 판정은 서버 쿼리로 못 좁힌다).
/// 쿼리 하나뿐이라 `AsyncNotifier` 클래스 없이 `FutureProvider` 로 둔다(K-POP 과 동일).
final freeEntryViewModelProvider = FutureProvider.autoDispose<List<ClubModel>>(
  (ref) => ref.watch(clubRepositoryProvider).getFreeEntryClubs(),
);
