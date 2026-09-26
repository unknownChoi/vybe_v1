import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_review_datasource.dart';
import 'package:vybe/data/datasources/remote/firebase_storage_datasource.dart';
import 'package:vybe/data/datasources/remote/firestore_paths.dart';
import 'package:vybe/data/models/review_model.dart';

final reviewRepositoryProvider = Provider.autoDispose<ReviewRepositoryImpl>(
  _reviewRepository,
);

ReviewRepositoryImpl _reviewRepository(Ref ref) => ReviewRepositoryImpl(
  FirebaseReviewDataSource(),
  FirebaseStorageDataSource(),
);

class ReviewRepositoryImpl {
  final FirebaseReviewDataSource _dataSource;
  final FirebaseStorageDataSource _storageDataSource;

  ReviewRepositoryImpl(this._dataSource, this._storageDataSource);

  Future<List<ReviewModel>> getReviews(String clubId) =>
      _dataSource.getReviews(clubId);

  Stream<List<ReviewModel>> watchUserReviews(String userId) =>
      _dataSource.watchUserReviews(userId);

  Future<int> countUserReviews(String userId) =>
      _dataSource.countUserReviews(userId);

  Future<void> createReview(String clubId, ReviewModel review) =>
      _dataSource.createReview(clubId, review);

  Future<void> updateReview(
    String clubId,
    String reviewId,
    ReviewModel review,
  ) => _dataSource.updateReview(clubId, reviewId, review);

  Future<void> deleteReview(String clubId, String reviewId) =>
      _dataSource.deleteReview(clubId, reviewId);

  String newReviewId(String clubId) => _dataSource.newReviewId(clubId);

  /// 파일명은 인덱스 기반 — 같은 리뷰 재업로드 시 덮어쓰기 되어 고아 파일이 안 생긴다.
  /// 단, 기존 첨부를 남겨둔 채 추가하는 수정 경로는 [namePrefix]로 이름을 갈라야
  /// 남겨둔 파일을 덮어쓰지 않는다.
  Future<List<String>> uploadReviewImages({
    required String clubId,
    required String reviewId,
    required List<File> images,
    String? namePrefix,
  }) => _storageDataSource.uploadIndexed(
    images,
    (i, ext) => StoragePaths.reviewImage(
      clubId,
      reviewId,
      '${namePrefix == null ? '$i' : '${namePrefix}_$i'}.$ext',
    ),
  );

  Future<void> deleteReviewImages(List<String> imageUrls) async {
    for (final url in imageUrls) {
      await _storageDataSource.deleteFileByUrl(url);
    }
  }
}
