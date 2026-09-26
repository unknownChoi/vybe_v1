import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/terms_agreement.dart';

part 'user_model.freezed.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String name,
    required String phone,
    required String birthDate,

    /// 'male' | 'female' — 미입력이면 빈 문자열
    required String gender,

    /// 앱 전체의 **표시 이름**. 2~12자 · 한글/영문/숫자 · 중복 불가.
    ///
    /// ⚠ 화면에 이름을 띄울 때는 [name](실명) 이 아니라 이 값을 쓴다 —
    /// 실명은 본인인증 원본이자 분쟁 시 근거일 뿐이다.
    /// ⚠ 서버 전용 필드 — 쓰기는 `updateUserProfile`(Functions) 하나뿐이고
    /// Rules 가 클라 쓰기를 막는다(예약 없이 남의 닉네임을 가질 수 있으므로).
    /// 빈 값이면 아직 배정되지 않은 계정 → 화면은 `kNicknameFallback`.
    required String nickname,

    /// 프로필 사진 URL. 빈 값이면 기본 아바타.
    /// ⚠ [nickname] 과 한 트랜잭션에 저장돼야 해서 같이 서버 전용이다.
    required String profileImageUrl,
    required String provider,
    required bool isVerified,

    /// 약관 동의 기록. 키는 `LegalDoc.name` + [kAgreementAge19].
    /// 동의 기록 도입(2026.08.22) 전에 가입한 유저는 빈 map.
    required Map<String, TermsAgreement> agreements,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] as String? ?? doc.id,
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      birthDate: data['birthDate'] as String? ?? '',
      gender: data['gender'] as String? ?? '',
      nickname: data['nickname'] as String? ?? '',
      profileImageUrl: data['profileImageUrl'] as String? ?? '',
      provider: data['provider'] as String? ?? '',
      isVerified: data['isVerified'] as bool? ?? false,
      agreements: parseAgreements(data['agreements']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
