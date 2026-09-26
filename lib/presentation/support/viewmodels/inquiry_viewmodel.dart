import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/models/inquiry_model.dart';
import 'package:vybe/data/repositories/inquiry_repository_impl.dart';
import 'package:vybe/data/repositories/user_repository_impl.dart';
import 'package:vybe/presentation/profile/viewmodels/user_viewmodel.dart';

/// 내 문의 목록. 운영자가 답변을 달면 화면이 바로 바뀌도록 스트림으로 본다.
/// 비로그인이면 빈 목록 — 화면이 로그인 유도를 그린다.
final myInquiriesProvider = StreamProvider.autoDispose<List<InquiryModel>>(
  _myInquiries,
);

Stream<List<InquiryModel>> _myInquiries(Ref ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(inquiryRepositoryProvider).watchMyInquiries(uid);
}

/// 아직 안 본 답변 수 — 마이페이지 배지. **추가 쿼리 없이** 위 목록에서 센다.
final unreadAnswerCountProvider = Provider.autoDispose<int>(
  (ref) => ref
      .watch(myInquiriesProvider)
      .maybeWhen(
        data: (list) => list.where((i) => i.hasUnreadAnswer).length,
        orElse: () => 0,
      ),
);

/// 문의 작성 · 답변 확인 기록.
final inquiryActionsProvider =
    NotifierProvider.autoDispose<InquiryActions, AsyncValue<void>>(
      InquiryActions.new,
    );

class InquiryActions extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// 문의 등록. 성공 여부를 반환한다 —
  /// 사진 업로드가 길어 화면이 먼저 닫히면 provider가 dispose되어 state를 못 쓴다.
  Future<bool> submitInquiry({
    required String userId,
    required String category,
    required String title,
    required String content,
    required List<File> images,
  }) async {
    // ⚠ 의존성은 첫 await 전에 전부 꺼낸다 — autoDispose provider라
    //   await 뒤에 ref를 다시 쓰면 "Ref ... after it has been disposed".
    final repository = ref.read(inquiryRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);
    // 홈 인사말이 붙잡고 있는 users 스트림 값이 있으면 read 0 — 없을 때만 getUser.
    final cachedNickname = ref
        .read(currentUserProvider(userId))
        .value
        ?.nickname;

    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      // 이름 조회를 사진 업로드보다 먼저 — 실패 시 업로드 파일이 남지 않는다.
      // (어드민은 users 문서를 못 읽어 표시 이름을 문의에 실어 보낸다)
      //
      // ⚠ 실명이 아니라 **닉네임**이다 — 운영자 화면에 실명을 띄울 이유가 없고,
      // 본인 확인이 필요하면 uid 로 users 문서를 보면 된다.
      final userName =
          cachedNickname ??
          (await userRepository.getUser(userId))?.nickname ??
          '';

      final inquiryId = repository.newInquiryId();
      final imageUrls = images.isEmpty
          ? const <String>[]
          : await repository.uploadInquiryImages(
              uid: userId,
              inquiryId: inquiryId,
              images: images,
            );
      final now = DateTime.now();
      await repository.createInquiry(
        InquiryModel(
          inquiryId: inquiryId,
          userId: userId,
          userName: userName,
          category: category,
          title: title,
          content: content,
          imageUrls: imageUrls,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    if (result case AsyncError(:final error, :final stackTrace)) {
      debugPrint('[InquiryActions] submitInquiry failed: $error\n$stackTrace');
    }
    if (ref.mounted) state = result;
    return !result.hasError;
  }

  /// 답변 확인 기록. 상세를 열 때 한 번만 부른다.
  /// 실패해도 화면을 되돌리지 않는다 — 배지가 다음에 다시 뜰 뿐이다.
  Future<void> markAnswerRead(String inquiryId) async {
    final repository = ref.read(inquiryRepositoryProvider);
    try {
      await repository.markAnswerRead(inquiryId);
    } catch (e) {
      debugPrint('[InquiryActions] markAnswerRead failed: $e');
    }
  }
}
