import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/review_model.dart';
import 'package:vybe/data/repositories/review_repository_impl.dart';
import 'package:vybe/data/repositories/user_repository_impl.dart';
import 'package:vybe/presentation/profile/viewmodels/user_viewmodel.dart';

/// 클럽 리뷰 목록 — 일회성 조회. 작성·수정·삭제 뒤엔 **결과 bool 을 받는 호출부**
/// (리뷰 탭 `_openWritePage` · 내 리뷰 화면)가 `ref.invalidate(reviewListProvider(clubId))`
/// 로 다시 읽는다 — [ReviewViewModel] 은 autoDispose + `read` 로만 잡혀 await 뒤엔
/// 이미 dispose 돼 있어 거기서 invalidate 하면 한 번도 돌지 않는다.
/// (무제한 실시간 스트림은 상세를 보는 내내 소켓을 열어 두고 남의 변경분까지 과금했다).
final reviewListProvider = FutureProvider.autoDispose
    .family<List<ReviewModel>, String>(_reviewList);

Future<List<ReviewModel>> _reviewList(Ref ref, String clubId) {
  return ref.watch(reviewRepositoryProvider).getReviews(clubId);
}

final reviewViewModelProvider =
    NotifierProvider.autoDispose<ReviewViewModel, AsyncValue<void>>(
      ReviewViewModel.new,
    );

class ReviewViewModel extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> createReview(String clubId, ReviewModel review) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(reviewRepositoryProvider).createReview(clubId, review),
    );
    if (!ref.mounted) return;
    state = result;
  }

  /// 리뷰 작성(사진 포함) 한 번에 처리.
  ///
  /// 작성자 이름은 홈 인사말이 붙잡고 있는 `currentUserProvider` 스트림 값을
  /// 동기로 먼저 본다(read 0). 아직 값이 없을 때만 users/{uid} 를 한 번 읽는다 —
  /// `ref.read(...future)` 는 autoDispose 스트림이라 첫 emit 전에 dispose 돼
  /// 에러로 끝나므로 쓰지 않는다.
  ///
  /// reviewId를 먼저 발급 → 사진을 `reviews/{clubId}/{reviewId}/`에 업로드 →
  /// 받은 URL을 imageUrls에 담아 문서 생성. 업로드가 실패하면 문서도 안 만든다.
  ///
  /// 성공 여부를 반환한다 — 사진 업로드가 길어 화면이 먼저 닫히면 provider가
  /// dispose되어 state를 못 쓰므로, 호출측은 state 대신 이 반환값으로 분기한다.
  Future<bool> submitReview({
    required String clubId,
    required String userId,
    required double rating,
    required String content,
    required List<String> tags,
    required List<File> images,
  }) async {
    // ⚠ 의존성은 반드시 첫 await 전에 전부 꺼낸다.
    // 이 provider는 autoDispose이고 호출측이 `ref.read(...notifier)`로만 잡아서
    // 리스너가 없다 → 프레임 끝에 dispose된다. await 뒤에 `ref`를 다시 쓰면
    // "Cannot use the Ref of reviewViewModelProvider after it has been disposed".
    final userRepository = ref.read(userRepositoryProvider);
    final repository = ref.read(reviewRepositoryProvider);
    final cachedNickname = ref
        .read(currentUserProvider(userId))
        .value
        ?.nickname;

    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      // 이름 조회를 사진 업로드보다 먼저 — 실패 시 업로드 파일이 남지 않는다.
      //
      // ⚠ 실명(`user.name`)이 아니라 **닉네임**을 싣는다 — 이 값이 클럽 상세
      // 리뷰 카드에 다른 사용자에게 그대로 보인다. 예전엔 실명이 나갔다.
      // 닉네임이 아직 없으면 빈 값 → 카드가 '익명'으로 그린다(기존 폴백).
      final userName =
          cachedNickname ??
          (await userRepository.getUser(userId))?.nickname ??
          '';

      final reviewId = repository.newReviewId(clubId);
      final imageUrls = images.isEmpty
          ? const <String>[]
          : await repository.uploadReviewImages(
              clubId: clubId,
              reviewId: reviewId,
              images: images,
            );
      final now = DateTime.now();
      await repository.createReview(
        clubId,
        ReviewModel(
          reviewId: reviewId,
          clubId: clubId,
          userId: userId,
          userName: userName,
          rating: rating,
          content: content,
          imageUrls: imageUrls,
          tags: tags,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });
    // 호출측은 실패 시 일반 토스트만 띄우므로, 원인은 여기서 남긴다.
    if (result case AsyncError(:final error, :final stackTrace)) {
      debugPrint('[ReviewViewModel] submitReview failed: $error\n$stackTrace');
    }
    // 업로드 중 화면이 닫혀 provider가 dispose됐으면 state 접근 금지 (결과만 반환).
    if (ref.mounted) state = result;
    return !result.hasError;
  }

  /// 리뷰 수정(사진 포함) 한 번에 처리. 성공 여부를 반환한다.
  ///
  /// [keptImageUrls]는 화면에 그대로 남아 있는 기존 첨부 URL(순서 유지),
  /// [newImages]는 이번에 새로 고른 파일. 최종 imageUrls = kept + 업로드 결과.
  /// 새 파일은 타임스탬프 prefix로 올린다 — 작성 때 쓰는 인덱스 이름(`0.jpg`)을
  /// 그대로 쓰면 남겨둔 기존 사진 파일을 덮어써서 그 URL이 다른 이미지가 된다.
  ///
  /// 빠진 첨부의 Storage 파일은 **문서 갱신이 성공한 뒤** 지운다 — 먼저 지우면
  /// 갱신이 실패했을 때 문서는 옛 URL을 가리키는데 파일은 없는 상태가 된다.
  /// 삭제 실패는 수정 실패로 보지 않는다(고아 파일만 남음).
  ///
  /// rating 변경분은 Cloud Functions `onReviewUpdated`가 클럽 평점에 반영한다.
  Future<bool> submitReviewEdit({
    required ReviewModel original,
    required double rating,
    required String content,
    required List<String> tags,
    required List<String> keptImageUrls,
    required List<File> newImages,
  }) async {
    // submitReview와 같은 이유로 의존성은 첫 await 전에 꺼낸다 (autoDispose).
    final repository = ref.read(reviewRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final uploaded = newImages.isEmpty
          ? const <String>[]
          : await repository.uploadReviewImages(
              clubId: original.clubId,
              reviewId: original.reviewId,
              images: newImages,
              namePrefix: '${DateTime.now().millisecondsSinceEpoch}',
            );

      await repository.updateReview(
        original.clubId,
        original.reviewId,
        original.copyWith(
          rating: rating,
          content: content,
          imageUrls: [...keptImageUrls, ...uploaded],
          tags: tags,
        ),
      );

      final removed = original.imageUrls
          .where((url) => !keptImageUrls.contains(url))
          .toList();
      if (removed.isNotEmpty) {
        await repository.deleteReviewImages(removed);
      }
    });
    if (result case AsyncError(:final error, :final stackTrace)) {
      debugPrint(
        '[ReviewViewModel] submitReviewEdit failed: $error\n$stackTrace',
      );
    }
    if (ref.mounted) state = result;
    return !result.hasError;
  }

  Future<void> updateReview(
    String clubId,
    String reviewId,
    ReviewModel review,
  ) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(reviewRepositoryProvider)
          .updateReview(clubId, reviewId, review),
    );
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> deleteReview(String clubId, String reviewId) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(reviewRepositoryProvider).deleteReview(clubId, reviewId),
    );
    if (!ref.mounted) return;
    state = result;
  }
}
