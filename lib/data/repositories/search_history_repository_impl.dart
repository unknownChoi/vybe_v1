import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_search_history_datasource.dart';
import 'package:vybe/data/models/search_history_model.dart';
import 'package:vybe/domain/repositories/search_history_repository.dart';

final searchHistoryRepositoryProvider =
    Provider.autoDispose<SearchHistoryRepository>(_searchHistoryRepository);

SearchHistoryRepository _searchHistoryRepository(Ref ref) =>
    SearchHistoryRepositoryImpl(FirebaseSearchHistoryDataSource());

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  final FirebaseSearchHistoryDataSource _dataSource;

  SearchHistoryRepositoryImpl(this._dataSource);

  @override
  Future<List<SearchHistoryModel>> getSearchHistory(String userId) =>
      _dataSource.getSearchHistory(userId);

  @override
  Future<void> addSearchHistory(String userId, String keyword) =>
      _dataSource.addSearchHistory(userId, keyword);

  @override
  Future<void> deleteSearchHistory(String userId, String historyId) =>
      _dataSource.deleteSearchHistory(userId, historyId);

  @override
  Future<void> clearAllSearchHistory(String userId) =>
      _dataSource.clearAllSearchHistory(userId);
}
