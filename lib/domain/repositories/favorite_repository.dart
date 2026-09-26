import 'package:vybe/data/models/favorite_model.dart';

abstract class FavoriteRepository {
  Stream<List<FavoriteModel>> watchUserFavorites(String userId);
  Future<void> addFavorite(String userId, String clubId);
  Future<void> removeFavorite(String userId, String clubId);
}
