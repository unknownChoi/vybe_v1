import 'dart:io';

import 'package:vybe/data/models/terms_agreement.dart';
import 'package:vybe/data/models/user_model.dart';

/// `updateUserProfile` 가 **확정한** 값 — 서버가 랜덤 배정한 닉네임을 앱이
/// 화면에 바로 반영할 수 있게 돌려받는다.
typedef ProfileSaveResult = ({String nickname, String profileImageUrl});

abstract class UserRepository {
  Future<UserModel?> getUser(String uid);
  Stream<UserModel?> watchUser(String uid);
  Future<void> setUserProfile({
    required String uid,
    required String name,
    required String phone,
    required String birthDate,
    required String provider,

    /// 'male' | 'female'. 알 수 없으면 null — 필드를 쓰지 않는다.
    String? gender,

    /// 약관 동의 기록. 키는 `LegalDoc.name` + `kAgreementAge19`.
    /// null(재로그인)이면 이미 저장된 기록을 그대로 둔다.
    Map<String, TermsAgreementInput>? agreements,
  });

  /// 동의 항목 하나만 바꾼다(설정 화면의 마케팅 수신 켬/끔).
  /// [key] 는 `LegalDoc.name`, [version] 은 그 문서의 개정일.
  /// 다른 항목의 동의 시각은 건드리지 않는다.
  Future<void> setAgreement({
    required String uid,
    required String key,
    required bool agreed,
    required String version,
  });

  /// 프로필 사진을 Storage 에 올린다 → 다운로드 URL.
  /// 문서에 반영하려면 그 URL 을 [updateUserProfile] 에 넘겨야 한다.
  Future<String> uploadProfileImage(String uid, File imageFile);

  /// 닉네임 · 프로필 사진 저장 (Cloud Functions). 둘 다 서버 전용 필드라
  /// 클라가 Firestore 에 직접 쓸 수 없다.
  ///
  /// 인자를 **둘 다 비우면** 서버가 랜덤 닉네임을 배정한다(가입 마지막 단계).
  Future<ProfileSaveResult> updateUserProfile({
    String? nickname,
    String? profileImageUrl,
  });

  /// 교체된 옛 프로필 사진 파일 삭제. 실패는 삼킨다(문서는 이미 갱신됐다).
  Future<void> deleteFileByUrl(String url);
}
