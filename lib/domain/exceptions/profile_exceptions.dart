/// 프로필 저장(`updateUserProfile`) 실패 중 **화면이 다르게 말해야 하는** 것들.
///
/// Cloud Functions 의 `already-exists`·`invalid-argument` 를 datasource 가
/// 이 타입으로 바꿔 던진다 — presentation 이 Firebase 예외 코드를 알면
/// 레이어 규칙(presentation 에서 Firebase import 금지)이 깨진다.
///
/// 그 밖의 실패(네트워크·권한)는 그대로 올려보내 공통 문구로 처리한다.
library;

/// 고른 닉네임이 이미 남의 것일 때.
///
/// 중복 판정은 서버 트랜잭션만 할 수 있다 — 앱은 형식까지만 보고,
/// 이 예외를 받아 "이미 사용 중인 닉네임이에요"를 띄운다.
class NicknameTakenException implements Exception {
  const NicknameTakenException();

  @override
  String toString() => '이미 사용 중인 닉네임이에요';
}

/// 서버가 값 자체를 거부한 경우 — 닉네임 형식·금칙어, 또는 사진 URL 이
/// 내 Storage 경로가 아닐 때.
///
/// 앱이 같은 규칙을 복사해 두므로(`core/utils/nickname.dart`) 정상 경로에서는
/// 거의 오지 않는다. 오면 앱과 서버 규칙이 어긋났다는 신호다.
class ProfileRejectedException implements Exception {
  /// 서버가 준 사용자 문구.
  final String message;

  /// 어느 값이 거부됐는지 (`details.field`). 화면이 오류를 **닉네임 입력칸
  /// 아래**에 붙일지 토스트로 띄울지 가르는 데 쓴다 — 사진 문제를 입력칸
  /// 아래에 붙이면 엉뚱한 곳을 고치게 된다.
  final ProfileField field;

  const ProfileRejectedException(this.message, this.field);

  @override
  String toString() => message;
}

/// [ProfileRejectedException] 이 가리키는 값.
enum ProfileField {
  nickname,
  photo,

  /// 서버가 `field` 를 안 실어 보낸 구버전 — 어디 붙일지 모르니 토스트로.
  unknown;

  static ProfileField parse(Object? raw) => switch (raw) {
    'nickname' => ProfileField.nickname,
    'photo' => ProfileField.photo,
    _ => ProfileField.unknown,
  };
}
