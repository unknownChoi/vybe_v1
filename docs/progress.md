# v1 진행 기록 (progress.md)

> 세션 시작 때 이 파일을 먼저 읽는다. 끝난 작업은 반복하지 않는다.
> 기준 문서 — `docs/backend_design.html` · `design/user/` · `docs/screen_map.md`

---

## 지금 상태 한 줄

**완료** 베타 코드 이식 + 기준 문서 배치 + 사용자 앱 99화면 분류 ·
**이어서 할 일** `복사 후 수정` 29화면 UI 작업 (신규 68화면보다 먼저 — 공용 위젯이 여기서 나온다)

---

## 2026-10-03 — 분류 · 이식 확인

### 1. 이식 (3단계) — 이미 끝나 있었다

`vybe_v1` 은 `35515f9 chore: copy beta as v1 baseline` 에서 베타(`vybe_bata`) 전체 복사본으로 만들어졌다.
이번 세션에서 실측으로 확인:

| 대상 | 결과 |
|---|---|
| `lib/` · `test/` · `assets/` · `functions/` · `scripts/` | vybe_bata 와 **완전 동일** |
| `pubspec.yaml` · `pubspec.lock` · `analysis_options.yaml` | 동일 |
| 다른 파일 | **2개뿐** — `lib/firebase_options.dart`, `lib/core/utils/map_launcher.dart` (아래 결정 기록 ①) |
| import 경로 수정 | **0건** — 패키지명이 양쪽 다 `vybe` 라 경로가 안 바뀐다 |
| 키·설정 파일 | `.env` · `functions/.env` 존재, `.gitignore` 베타와 동일(두 파일 모두 ignore) |

`partner/` 는 **베타에 없다**. CLAUDE.md 폴더 구조 설명이 낡았다 — 테이블 배치 편집기는
별도 레포 `소스코드/vybe-partner/` 에 있다. 이식할 것이 없다.

### 2. 기준 문서 배치

CLAUDE.md ⭐ v1 개발 규칙이 가리키는 두 문서가 레포에 없어 분류를 시작할 수 없었다. 원본을 찾아 넣었다.

- `docs/backend_design.html` ← `~/Downloads/VYBE_v1_firebase_backend_design.html` (2026-10-02판)
- `design/user/` ← `~/Downloads/VYBE_v1_offline 2/` (2026-10-01판, 최신)
  - `VYBE_v1_prototype.html` · `VYBE_v1_storyboard.html` 은 `window.__VBF` 에 화면 코드 109개를
    통째로 품은 자급식 번들이다. 그대로는 읽기 어려워 **`design/user/extracted/`** 에 파일 단위로 풀었다
    (`[v1]<화면ID>.html` 33 + `.jsx` 69 + 공용 js 7).
  - `design/user/screen/assets/` (이미지·영상 25MB) 는 `.gitignore` 로 제외 (결정 기록 ②)

### 3. 화면 분류 (2단계) — 사용자 앱 99화면 전부

| 분류 | 수 | 비고 |
|---|---|---|
| 그대로 복사 | **2** | AUTH-004 인증번호 입력 · CLUB-022 공연 일정 |
| 복사 후 수정 | **29** | 베타 A~G 섹션의 나머지 전부 |
| 신규 개발 | **68** | H~T 섹션 (베타에 코드 없음) |
| 판단 보류 | **0** | |

- 화면별 분류·차이·근거는 **`docs/screen_map.md`**
- 방법: 화면 ID 하나당 에이전트 1개가 디자인 jsx ↔ 베타 Flutter 코드를 대조(1차) →
  다른 에이전트가 **반박 전용**으로 재검사(2차). 31화면 전부 2차까지 끝났고 전부 `confidence: high`.
  1차에서 "그대로 복사"로 나왔던 AUTH-001·AUTH-002 가 2차에서 뒤집혔다.
- 찾은 차이 **384건**, 종류별: 레이아웃 105 · 상태 75 · 문구 70 · 신규요소 49 · 흐름 31 ·
  삭제요소 22 · 진입점 22 · 백엔드 10
- 차이가 많은 화면 순: MY-033 탈퇴(22) · CLUB-026 웨이팅(21) · CAT-012 입장비 무료(18) ·
  HOME-005 홈(17) · CAT-013 서비스 음료(17) · CLUB-021 클럽 상세(17)

**신규 68화면 매핑도 끝났다** — 설계 3장의 신규 68행과 디자인 `nf_specs.js` 의 68항목이
순서·이름까지 1:1로 맞는다(불일치 0). `screen_map.md` 에 화면 ID ↔ 프로토 ID ↔ 컴포넌트 ↔ 파일로 적어 뒀다.

### 4. 베타에 있는데 v1 디자인에 화면 ID 가 없는 것

베타 `*_screen.dart` 38개 중 35개는 v1 화면 ID 에 대응된다. 나머지 3개:

| 파일 | 무엇 | 권장 |
|---|---|---|
| `lib/presentation/auth/terms/terms_detail_screen.dart` | 약관 전문 (4종) | **남긴다** — 약관 동의 시트·마이 약관 목록이 여는 법적 고지. 디자인이 안 그렸을 뿐 법적으로 필요 |
| `lib/presentation/my_page/legal_screen.dart` | 약관·정책 목록 | **남긴다** — 위와 같은 이유 |
| `lib/presentation/common/version_gate/widgets/version_block_screen.dart` | 강제 업데이트 · 점검 차단 | **남긴다** — 설계 3장 AUTH-001 행의 `appConfig/{platform}` 게이트 체인이 쓰는 화면. 지우면 강제 업데이트가 작동 안 함 |

셋 다 이식하지 않는 게 아니라 **이미 들어와 있고 그대로 둔다**. 화면 ID 가 없을 뿐이다.

### 5. 이식 확인 (4단계)

| 항목 | 결과 |
|---|---|
| `flutter pub get` | OK |
| `dart analyze` | **No issues found** |
| `flutter test` | **390 passed** |
| `flutter build ios --simulator --debug` | OK (57.4s) |
| 파일 비교 (diff) | import 경로 외 변경 **없음** — 다른 파일은 위 2개뿐 |

시뮬레이터(iPhone 16 Pro Max · iOS 18) 실행해 화면 순회 — 전부 베타와 같이 동작:

스플래시 → 로그인(AUTH-002) → 본인 인증 안내 시트 → 본인 인증(AUTH-003) → **로그인** →
홈(HOME-005, 배너 7장·카테고리 8칸) → 주변 지도(PLACE-019, 네이버 지도 + "내 주변 클럽 103") →
클럽 상세(CLUB-021, 히어로 1/5 + sticky 탭 5개) → 리뷰 탭(평점 5.00 분포 바) →
검색(HOME-006, 해시태그 8 + 인기 검색어 10) → 찜(PLACE-020) → 마이(MY-029) → EDM(CAT-017)

빌드 오류 · 런타임 오류 · 빈 화면 · 깨진 이미지/폰트 **없음**. Storage 이미지 정상 로드.

**런타임에서 비어 보이는 것 2가지 (이식 결함 아님)**
- EDM·힙합·오늘의 라인업의 공연 일정이 "공연 0개" — 테스트 Firebase 프로젝트에
  `performances` 컬렉션이 **비어 있다**. 빈 상태 UI 는 정상 동작
- 마이페이지 이름이 `VYBER` — 테스트 계정에 `nickname` 미배정이라 폴백이 뜬 것(정상)

**못 한 것** — 시뮬레이터 텍스트 입력이 iOS 붙여넣기 권한 프롬프트에 막혀 자동 로그인이 안 됐다.
사람이 직접 로그인한 뒤 이어서 확인했다. 다음에도 로그인 단계는 사람 손이 필요하다.

---

## 결정 기록

① **테스트 Firebase 프로젝트로 전환** (커밋 `42e99b5`)
운영 `vybe-bata-c07aa` 를 건드리지 않으려고 `vybe-bata-c07aa-test` 로 바꾸고 번들/패키지에 `.dev` 를 붙였다.
`map_launcher.dart` 의 네이버 지도 `appname` 도 바뀐 번들 ID 에 맞췄다(이게 베타와 다른 두 번째 파일).
베타 앱과 같은 기기에 나란히 설치된다.

② **디자인 에셋 25MB 는 git 제외** — `design/user/screen/assets/` 를 `.gitignore` 에 넣었다.
화면 구조·문구·레이아웃은 전부 `extracted/` 의 코드에 있어 개발에는 지장이 없다.
이미지를 봐야 하면 로컬 `~/Downloads/VYBE_v1_offline 2/screen/assets/` 를 쓴다.

③ **`docs/backend_design.html` 은 2026-10-02 사본으로 고정** — 원본이 갱신되면 그때 다시 복사한다.
(`~/Downloads` 에 `_print.html` 판도 있으나 본문 판을 정본으로 썼다)

④ **`terms_detail` · `legal` · `version_block` 3화면은 ID 없이 유지** — 위 4번 참고.

⑤ **GitHub 레포 `unknownChoi/vybe_v1` (private)** 생성·푸쉬. 베타는 `unknownChoi/VYBE_bata` 로 별개.

---

## 이어서 할 일

1. **`복사 후 수정` 29화면 UI 작업** — `docs/screen_map.md` 의 화면별 상세(차이 384건)를 보고 고친다.
   신규 68화면보다 먼저 하는 이유: 공용 위젯·토큰이 여기서 확정돼야 신규 화면이 그걸 쓴다.
   차이가 많은 MY-033 · CLUB-026 · CAT-012 부터 보는 걸 권한다.
2. **H~T 신규 68화면 UI** — Fake datasource 구조(CLAUDE.md ⭐ v1 규칙)로. Firebase 호출 없음.
3. 백엔드 단계 — Emulator 에서 `docs/backend_design.html` 대로 구현 후 datasource 교체.

### 작업 전 사람이 정해야 하는 것

- **베타가 디자인과 일부러 다르게 만든 자리를 어느 쪽으로 맞출지.** 분류 과정에서 계속 나왔다 —
  예: AUTH-001 스플래시는 디자인의 하단 로딩 라인이 없고(의도적 생략, 주석 있음),
  대신 디자인에 없는 미러볼이 있다. 베타 코드에 생략 사유 주석이 남아 있는 항목들은
  "디자인대로 되돌릴지 / 베타 판단을 유지할지" 결정이 필요하다.
- 테스트 프로젝트 `performances` 컬렉션을 채울지 여부 (장르 페이지 공연 일정 확인용)
