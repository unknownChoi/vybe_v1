import { https } from "firebase-functions/v1";

/**
 * 닉네임 규칙의 **정본**. 앱(`core/utils/nickname.dart`)이 같은 값을 복사해
 * 입력 즉시 검증에만 쓴다 — 두 값이 어긋나면 앱이 통과시킨 입력이 여기서
 * `invalid-argument` 로 튕긴다(앱 `test/nickname_test.dart` 가 일치를 잡는다).
 */
export const NICKNAME_MIN = 2;
export const NICKNAME_MAX = 12;

/**
 * 한글·영문·숫자만. 공백을 막아 앞뒤 trim 만으로 정규화가 끝나고,
 * 자모 단독(`ㅋㅋ`·`ㅇㅇ`)은 `[가-힣]` 범위 밖이라 자동으로 걸러진다.
 *
 * ⚠ `_` 를 뺀 이유 — 닉네임이 곧 `nicknames/{key}` 문서 ID 라 Firestore ID
 * 제약을 받는다. `__foo__` 는 예약 패턴이라 쓰기가 거부되는데, `_` 를 허용하면
 * 사용자가 그런 닉네임을 만들 수 있다. 한글·영문·숫자만 받으면 `/`·`.` 까지
 * 통째로 막혀 ID 제약 문제가 사라진다.
 */
export const NICKNAME_PATTERN = new RegExp(
  `^[가-힣a-zA-Z0-9]{${NICKNAME_MIN},${NICKNAME_MAX}}$`
);

/**
 * 사칭 어휘 — **부분 일치**로 막는다(`vybe운영자` 도 사칭이다).
 * 욕설 필터는 범위 밖. 서버에 두는 이유는 앱에만 두면 함수를 직접 부르는
 * 것으로 우회되기 때문이다.
 *
 * ⚠ 랜덤 생성기의 단어표와 겹치면 배정이 영영 실패한다 —
 * `randomNickname()` 이 생성값도 이 목록에 걸어 보고 다시 뽑는다.
 */
const BANNED_WORDS = [
  "운영자",
  "운영팀",
  "관리자",
  "관리인",
  "고객센터",
  "고객지원",
  "vybe",
  "admin",
];

/**
 * 예약 컬렉션 문서 ID. 소문자로 접는다 — `VYBE` 와 `vybe` 를 서로 다른
 * 닉네임으로 두면 사칭이 쉬워진다. 한글은 대소문자가 없어 영향이 없고,
 * 화면에 보이는 값은 원본 대소문자를 지킨 `users.nickname` 이다.
 */
export function nicknameKey(nickname: string): string {
  return nickname.trim().toLowerCase();
}

/** 사칭 어휘를 품고 있는지 (키 기준 — 대소문자 무시). */
export function isBannedNickname(nickname: string): boolean {
  const key = nicknameKey(nickname);
  return BANNED_WORDS.some((w) => key.includes(w));
}

/**
 * 형식·금칙어 검사를 통과한 닉네임을 돌려준다(앞뒤 공백 제거).
 * 실패하면 `invalid-argument`.
 */
export function validateNickname(raw: string): string {
  const nickname = raw.trim();

  // details.field — 앱이 이 값을 보고 오류를 **닉네임 입력칸 아래**에 붙일지
  // 토스트로 띄울지 가른다. 메시지 문구로 갈라내면 문구를 고칠 때 깨진다.
  if (!NICKNAME_PATTERN.test(nickname)) {
    throw new https.HttpsError(
      "invalid-argument",
      `닉네임은 한글·영문·숫자 ${NICKNAME_MIN}~${NICKNAME_MAX}자로 입력해 주세요.`,
      {field: "nickname"}
    );
  }
  if (isBannedNickname(nickname)) {
    throw new https.HttpsError(
      "invalid-argument",
      "사용할 수 없는 닉네임이에요.",
      {field: "nickname"}
    );
  }
  return nickname;
}

// ============================================================
// 랜덤 배정 — 서버에만 둔다
// ============================================================
//
// 배정 주체가 서버 하나라 단어표도 한 벌뿐이다. 앱에 표를 복사해 두면
// '앱과 서버의 표가 갈라지는' 문제가 생기는데, 앱은 배정을 하지 않으므로
// 표가 아예 필요 없다.

/**
 * 닉네임 고정 몸통 — `{앞말}바이버{4자리}` 의 가운데.
 *
 * ⚠ 이 값을 바꾸면 이미 배정된 닉네임과 새 닉네임의 모양이 갈라진다.
 * 옛 닉네임은 재배정하지 않으므로(그대로 남는다) 바꿀 이유가 없다.
 */
const NICKNAME_BODY = "바이버";

/**
 * 랜덤 닉네임 앞말 — 클럽에서 따온 **40개** (춤·플로어 20 + 에너지·열정 20).
 *
 * ⚠ 전부 **4자 이하**여야 한다. 몸통 3자 + 숫자 4자와 합쳐 최대 11자로
 * 상한([NICKNAME_MAX] = 12)에 1자 여유가 남는다. 5자 단어를 넣으면 배정된
 * 닉네임이 규칙을 넘어서고, 그러면 **사용자가 자기 닉네임을 다시 입력할 수
 * 없게 된다**(입력칸은 12자에서 끊긴다). 앱 `test/nickname_test.dart` 가
 * 이 배열을 직접 읽어 길이·문자·금칙어를 검사한다.
 *
 * ⚠ 띄어쓰기를 넣지 않는다 — 공백을 허용하면 앞뒤 trim 만으로 끝나던 정규화가
 * 복잡해지고(중간·연속 공백) 상한도 13자로 늘려야 한다.
 *
 * 단어 수가 적어도 되는 이유는 뒤 4자리가 구분자 몫을 하기 때문이다 —
 * 같은 앞말을 뽑아도 숫자가 갈라 준다.
 */
const CLUB_WORDS = [
  // 춤 · 플로어
  "춤추는", "흔드는", "리듬타는", "스텝밟는", "몸푸는", "돌아가는", "뛰어드는", "들썩이는",
  "물결타는", "날아가는", "발맞추는", "무대찢는", "플로어의", "춤꾼", "댄서", "스텝왕",
  "웨이브", "턴하는", "점프하는", "흥많은",
  // 에너지 · 열정
  "신나는", "뜨거운", "불타는", "열정적", "타오르는", "폭발하는", "에너지", "활활타는",
  "끓어오른", "미친듯한", "광란의", "질주하는", "전율하는", "짜릿한", "강렬한", "힘넘치는",
  "후끈한", "달아오른", "불꽃같은", "텐션높은",
];

/** 닉네임 예약이 충돌했을 때 다시 뽑는 최대 횟수. */
export const MAX_RANDOM_TRIES = 5;

/**
 * `{앞말}바이버{4자리}` (예: `신나는바이버4821`).
 *
 * 조합 40 × 9000 = **36만**. 뒤 4자리는 같은 앞말을 뽑은 사람끼리 구분하는
 * 자리라 1000~9999 고정 폭이다(앞자리 0이 붙는 `0123` 을 피해 1000부터).
 *
 * ⚠ **여기서 유일성을 보장하지 않는다** — 겹치지 않는 것은 `nicknames/{key}`
 * 예약이 강제하고, 충돌하면 호출부(`updateUserProfile`)가 [MAX_RANDOM_TRIES]
 * 회까지 다시 뽑는다. 이 규모에서 5회 안에 실패할 확률은 사실상 0이다.
 */
export function randomNickname(): string {
  for (let i = 0; i < MAX_RANDOM_TRIES; i++) {
    const word = CLUB_WORDS[Math.floor(Math.random() * CLUB_WORDS.length)];
    const digits = 1000 + Math.floor(Math.random() * 9000);
    const candidate = `${word}${NICKNAME_BODY}${digits}`;
    // 단어표가 규칙·금칙어와 어긋나게 바뀌어도 배정이 멈추지 않게 한 번 더 본다.
    if (NICKNAME_PATTERN.test(candidate) && !isBannedNickname(candidate)) {
      return candidate;
    }
  }
  // 여기까지 오면 단어표가 규칙과 어긋난 것 — 몸통 + 숫자만으로 떨어진다.
  return `${NICKNAME_BODY}${1000 + Math.floor(Math.random() * 9000)}`;
}
