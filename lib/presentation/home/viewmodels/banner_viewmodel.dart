import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/banner_model.dart';
import 'package:vybe/data/repositories/banner_repository_impl.dart';

// keepAlive: true — 앱 수명 동안 한 번만 fetch, 재실행 없음
final bannerListProvider = FutureProvider<List<BannerModel>>(_bannerList);

Future<List<BannerModel>> _bannerList(Ref ref) {
  return ref.read(bannerRepositoryProvider).getActiveBanners();
}
