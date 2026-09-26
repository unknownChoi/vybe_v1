import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/club_info_model.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/club_table_layout.dart';
import 'package:vybe/data/models/menu_model.dart';
import 'package:vybe/data/models/photo_model.dart';
import 'package:vybe/data/repositories/club_repository_impl.dart';

final clubDetailProvider = FutureProvider.autoDispose
    .family<ClubModel?, String>(_clubDetail);

Future<ClubModel?> _clubDetail(Ref ref, String clubId) {
  return ref.watch(clubRepositoryProvider).getClub(clubId);
}

final clubInfoProvider = FutureProvider.autoDispose
    .family<ClubInfoModel?, String>(_clubInfo);

Future<ClubInfoModel?> _clubInfo(Ref ref, String clubId) {
  return ref.watch(clubRepositoryProvider).getClubInfo(clubId);
}

/// 테이블 배치도. null 이면 홈 탭 테이블 섹션·가격표 화면을 그리지 않는다.
final clubTableLayoutProvider = FutureProvider.autoDispose
    .family<ClubTableLayout?, String>(_clubTableLayout);

Future<ClubTableLayout?> _clubTableLayout(Ref ref, String clubId) {
  return ref.watch(clubRepositoryProvider).getTableLayout(clubId);
}

final clubMenusProvider = FutureProvider.autoDispose
    .family<List<MenuModel>, String>(_clubMenus);

Future<List<MenuModel>> _clubMenus(Ref ref, String clubId) {
  return ref.watch(clubRepositoryProvider).getMenus(clubId);
}

final clubPhotosProvider = FutureProvider.autoDispose
    .family<List<PhotoModel>, String>(_clubPhotos);

Future<List<PhotoModel>> _clubPhotos(Ref ref, String clubId) {
  return ref.watch(clubRepositoryProvider).getPhotos(clubId);
}

final nearbyClubsProvider = FutureProvider.autoDispose
    .family<List<ClubModel>, String>(_nearbyClubs);

Future<List<ClubModel>> _nearbyClubs(Ref ref, String clubId) async {
  final club = await ref.watch(clubDetailProvider(clubId).future);
  if (club == null) return [];
  final all = await ref.watch(clubRepositoryProvider).getClubsByArea(club.area);
  return all.where((c) => c.clubId != clubId).take(5).toList();
}
