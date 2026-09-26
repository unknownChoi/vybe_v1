import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_favorite_datasource.dart';
import 'package:vybe/data/models/favorite_model.dart';
import 'package:vybe/domain/repositories/favorite_repository.dart';

final favoriteRepositoryProvider = Provider.autoDispose<FavoriteRepository>(
  _favoriteRepository,
);

FavoriteRepository _favoriteRepository(Ref ref) =>
    FavoriteRepositoryImpl(FirebaseFavoriteDataSource());

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FirebaseFavoriteDataSource _dataSource;

  FavoriteRepositoryImpl(this._dataSource);

  @override
  Stream<List<FavoriteModel>> watchUserFavorites(String userId) =>
      _dataSource.watchUserFavorites(userId);

  @override
  Future<void> addFavorite(String userId, String clubId) =>
      _dataSource.addFavorite(userId, clubId);

  @override
  Future<void> removeFavorite(String userId, String clubId) =>
      _dataSource.removeFavorite(userId, clubId);
}
