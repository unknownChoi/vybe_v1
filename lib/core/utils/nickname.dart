// ============================================================
// 닉네임 규칙 — **서버 규칙의 사본**
//
// 판정의 정본은 `functions/src/profile/nickname.ts` 다. 여기 있는 값은
// 저장 버튼을 누르기 전에 즉시 오류를 띄우기 위한 복사본일 뿐이다 —
// 서버 왕복을 기다렸다 빨간 글씨를 보여주면 입력이 답답하다.
//
// ⚠ 두 값이 어긋나면 앱이 통과시킨 입력이 서버에서 `invalid-argument` 로
// 튕긴다. `test/nickname_test.dart` 가 상수 일치를 지킨다.
//
// ⚠ 랜덤 생성기는 **여기에 두지 않는다** — 배정 주체가 서버 하나라
// 단어표도 한 벌뿐이고, '앱과 서버의 표가 갈라지는' 문제가 아예 없다.
// 금칙어·중복도 서버만 안다(앱에 두면 함수를 직접 부르는 것으로 우회된다).
// ============================================================

/// 닉네임 최소 길이.
const int kNicknameMin = 2;

/// 닉네임 최대 길이. 리뷰 카드·마이페이지 프로필이 한 줄에 담는 폭 —
/// 넘기면 ellipsis 로 잘려 누군지 알 수 없다.
const int kNicknameMax = 12;

/// 한글·영문·숫자만.
///
/// 공백을 막아 앞뒤 trim 만으로 정규화가 끝나고, 자모 단독(`ㅋㅋ`·`ㅇㅇ`)은
/// `[가-힣]` 범위 밖이라 자동으로 걸러진다.
///
/// ⚠ `_` 는 일부러 뺐다 — 닉네임이 곧 `nicknames/{key}` 문서 ID 라
/// Firestore ID 제약(`__foo__` 예약 패턴)을 받는다.
final RegExp kNicknamePattern = RegExp(
  '^[가-힣a-zA-Z0-9]{$kNicknameMin,$kNicknameMax}\$',
);

/// 닉네임이 없는 계정에 쓰는 **중립 라벨**.
///
/// ⚠ 폴백을 `users.name`(실명)으로 두면 안 된다 — 닉네임 기능이 고치려는
/// 문제(실명 노출)를 그대로 남기는 셈이 된다.
const String kNicknameFallback = 'VYBER';

/// 호환 자모(단독 자모) 구간 — 한글 IME 로 입력하는 **도중**의 마지막 글자가
/// 여기에 들어온다(`새벽ㅇ` 의 `ㅇ` U+3147).
const int _compatJamoFirst = 0x3131; // ㄱ
const int _compatJamoLast = 0x318E;

/// 저장해도 되는 닉네임인지 (형식 통과 + 길이 충족).
bool isValidNickname(String raw) => kNicknamePattern.hasMatch(raw.trim());

/// 닉네임 입력 오류 문구. 통과하면 null.
///
/// 오류로 보지 않는 두 경우 —
/// - **빈 입력**: '아직 안 썼다'다. 입력칸에 앉자마자 빨간 글씨가 뜨면 쓰기
///   시작하기도 전에 틀린 것처럼 보인다(저장은 [isValidNickname] 가 막는다).
/// - **조합 중 자모**: 한글을 치는 동안 마지막 글자는 `ㅇ` 같은 단독 자모로
///   남는다. 이걸 형식 위반으로 잡으면 **한글을 한 글자 칠 때마다** 빨간
///   글씨가 번쩍인다. 조합이 끝나면 완성형이 되어 정상 판정으로 돌아온다.
String? nicknameError(String raw) {
  final nickname = raw.trim();
  if (nickname.isEmpty) return null;
  if (kNicknamePattern.hasMatch(nickname)) return null;

  // 자모를 빼고 봤을 때 형식이 맞으면 '조합 중'으로 본다.
  final settled = nickname.runes.where((r) => !_isCompatJamo(r)).length;
  final hasJamo = settled != nickname.runes.length;

  final bad = nickname.runes.any(
    (r) => !_isCompatJamo(r) && !_isAllowedRune(r),
  );
  if (bad) return '한글·영문·숫자만 쓸 수 있어요';

  // 여기까지 왔으면 허용 문자(+자모)로만 이뤄졌고 길이만 어긋난 것.
  if (settled > kNicknameMax) return '$kNicknameMax자까지 쓸 수 있어요';
  if (hasJamo) return null; // 조합 중 — 아직 판단하지 않는다
  return '$kNicknameMin자 이상 입력해 주세요';
}

bool _isCompatJamo(int rune) =>
    rune >= _compatJamoFirst && rune <= _compatJamoLast;

/// `[가-힣a-zA-Z0-9]` 한 글자인지.
bool _isAllowedRune(int r) =>
    (r >= 0xAC00 && r <= 0xD7A3) || // 가-힣
    (r >= 0x61 && r <= 0x7A) || // a-z
    (r >= 0x41 && r <= 0x5A) || // A-Z
    (r >= 0x30 && r <= 0x39); // 0-9
