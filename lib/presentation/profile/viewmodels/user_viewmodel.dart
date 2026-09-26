import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/user_model.dart';
import 'package:vybe/data/repositories/user_repository_impl.dart';
import 'package:vybe/domain/repositories/user_repository.dart';

/// 현재 로그인 유저 실시간 스트림
final currentUserProvider = StreamProvider.autoDispose
    .family<UserModel?, String>(_currentUser);

Stream<UserModel?> _currentUser(Ref ref, String uid) {
  return ref.watch(userRepositoryProvider).watchUser(uid);
}

final userViewModelProvider =
    NotifierProvider.autoDispose<UserViewModel, AsyncValue<void>>(
      UserViewModel.new,
    );

class UserViewModel extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  // ⚠ 예전 `updateProfile({uid, name})` 은 지웠다 — 호출부가 0이 됐고,
  // 그 함수가 쓰던 `users.name` 은 본인인증으로 받은 **실명**이다.
  // 프로필 화면에서 바꾸는 값은 닉네임(`nickname`)이라 실명을 쓸 일이 없다.

  /// 닉네임 · 프로필 사진 저장.
  ///
  /// 순서가 설계의 알맹이다 — **파일 먼저, 문서는 마지막**
  /// (리뷰 작성 · 고객센터 문의와 같다. 다른 점은 마지막 단계가 클라 write 가
  /// 아니라 Cloud Functions 호출이라는 것뿐이다).
  ///
  /// ```
  /// 1. 사진을 새로 골랐으면 Storage 업로드   # 실패 → 중단. 문서는 그대로
  /// 2. updateUserProfile(닉네임, URL)        # 예약 + 문서를 트랜잭션 1회로
  ///      실패 → 방금 올린 파일을 지운다      #   저장이 안 됐는데 파일만
  ///                                          #   남으면 고아가 된다
  /// 3. 옛 사진 파일 삭제 (성공 후, 실패는 삼킴)
  /// ```
  ///
  /// - [imageFile] null = 사진을 새로 고르지 않음
  /// - [resetImage] true = '기본 이미지로 변경' (URL 을 빈 값으로)
  ///
  /// ⚠ 지울 옛 파일은 **화면이 들고 있는 스냅샷이 아니라 저장 직전의 서버 값**으로
  /// 정한다. `updateUserProfile` 은 서버 쓰기라 클라에 로컬 반영이 없어,
  /// 저장하고 바로 다시 들어오면 `users` 스트림이 아직 안 따라온다 — 그 스냅샷을
  /// 믿으면 **이미 지운 한 세대 전 URL** 을 또 지우려 들고(object-not-found),
  /// 진짜 옛 파일은 아무도 안 지워 고아로 남는다.
  ///
  /// 예외는 그대로 던진다 — 화면이 `NicknameTakenException` 을 입력칸 아래
  /// 오류로, 나머지를 토스트로 나눠 보여줘야 한다.
  ///
  /// ⚠ 이 provider 는 autoDispose 인데 화면이 `read(.notifier)` 로만 잡는다 —
  /// 첫 await 뒤엔 이미 dispose 돼 있다. `state` 는 **`ref.mounted` 일 때만**
  /// 쓴다(리뷰·문의 뷰모델과 같은 규칙). 안 가리면 서버 저장이 끝난 뒤
  /// `UnmountedRefException` 이 나서 **문서는 갱신됐는데 실패 토스트**가 뜬다
  /// (뒤로 가면 새 사진이 보이는 채로). 화면은 반환값·예외만 본다.
  Future<ProfileSaveResult> saveProfile({
    required String uid,
    required String nickname,
    File? imageFile,
    bool resetImage = false,
  }) async {
    final repository = ref.read(userRepositoryProvider);
    state = const AsyncLoading();

    try {
      // 0) 지금 서버에 적힌 사진 URL — 3번에서 지울 대상.
      final previousImageUrl =
          (await repository.getUser(uid))?.profileImageUrl ?? '';

      // 1) 업로드 — 실패하면 여기서 끝난다(문서는 안 건드렸다).
      String? photoUrl;
      if (imageFile != null) {
        photoUrl = await repository.uploadProfileImage(uid, imageFile);
      } else if (resetImage) {
        photoUrl = ''; // 빈 문자열은 '기본 아바타로 되돌리기' 라는 명시적 요청
      }

      // 2) 예약 + 문서 — 실패하면 방금 올린 파일을 되돌린다.
      final ProfileSaveResult saved;
      try {
        saved = await repository.updateUserProfile(
          nickname: nickname,
          profileImageUrl: photoUrl,
        );
      } catch (_) {
        if (photoUrl != null && photoUrl.isNotEmpty) {
          await repository.deleteFileByUrl(photoUrl);
        }
        rethrow;
      }

      // 3) 옛 파일 정리 — 저장이 끝난 뒤. 실패는 삼킨다(문서는 이미 갱신됐다).
      //    먼저 지우면 2번이 실패했을 때 사진만 사라진 계정이 남는다.
      if (photoUrl != null &&
          previousImageUrl.isNotEmpty &&
          previousImageUrl != photoUrl) {
        await repository.deleteFileByUrl(previousImageUrl);
      }

      if (ref.mounted) state = const AsyncData(null);
      return saved;
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
      rethrow;
    }
  }

  /// 가입 마지막 단계의 **랜덤 닉네임 배정** — 인자 없이 부르면 서버가
  /// 닉네임을 만들어 예약까지 끝낸다.
  ///
  /// 실패해도 가입을 막지 않는다 — 이미 계정은 만들어졌다. 닉네임 없는 짧은
  /// 창에는 화면이 중립 라벨(`kNicknameFallback`)을 보여주고, 다음에 프로필
  /// 수정 화면에서 저장할 때 다시 배정된다. 여기서 홈 진입을 막으면 네트워크가
  /// 잠깐 흔들린 사용자가 가입 마지막 단계에 갇힌다.
  Future<void> assignNicknameIfMissing() async {
    await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).updateUserProfile(),
    );
  }
}
