# v1 진행 기록 (progress.md)

> 세션 시작 때 이 파일을 먼저 읽는다. 끝난 작업은 반복하지 않는다.
> 기준 문서 — `docs/backend_design.html` · `design/user/` · `docs/screen_map.md`

---

## 진행 현황

### 지금 상태 한 줄

**완료** 베타 코드 이식 + 기준 문서 배치 + 사용자 앱 99화면 분류 ·
**이어서 할 일** 화면 구현 — `복사 후 수정` 29화면 + 신규 68화면.
공통 기반(토큰 · 공용 위젯 14 · v1 모델 · Fake datasource · 개발 메뉴)은 2026-10-03 완료.
원래 적어 둔 순서는 아래와 같다 — `복사 후 수정` 29화면 UI 작업 (신규 68화면보다 먼저 — 공용 위젯이 여기서 나온다).
보류였던 결정 7건은 2026-10-03 전부 확정됐다(결정 기록 ⑩~⑯).

---

### 2026-10-03 — 분류 · 이식 확인

#### 1. 이식 (3단계) — 이미 끝나 있었다

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

#### 2. 기준 문서 배치

CLAUDE.md ⭐ v1 개발 규칙이 가리키는 두 문서가 레포에 없어 분류를 시작할 수 없었다. 원본을 찾아 넣었다.

- `docs/backend_design.html` ← `~/Downloads/VYBE_v1_firebase_backend_design.html` (2026-10-02판)
- `design/user/` ← `~/Downloads/VYBE_v1_offline 2/` (2026-10-01판, 최신)
  - `VYBE_v1_prototype.html` · `VYBE_v1_storyboard.html` 은 `window.__VBF` 에 화면 코드 109개를
    통째로 품은 자급식 번들이다. 그대로는 읽기 어려워 **`design/user/extracted/`** 에 파일 단위로 풀었다
    (`[v1]<화면ID>.html` 33 + `.jsx` 69 + 공용 js 7).
  - `design/user/screen/assets/` (이미지·영상 25MB) 는 `.gitignore` 로 제외 (결정 기록 ②)

#### 3. 화면 분류 (2단계) — 사용자 앱 99화면 전부

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

#### 4. 베타에 있는데 v1 디자인에 화면 ID 가 없는 것

베타 `*_screen.dart` 38개 중 35개는 v1 화면 ID 에 대응된다. 나머지 3개:

| 파일 | 무엇 | 권장 |
|---|---|---|
| `lib/presentation/auth/terms/terms_detail_screen.dart` | 약관 전문 (4종) | **남긴다** — 약관 동의 시트·마이 약관 목록이 여는 법적 고지. 디자인이 안 그렸을 뿐 법적으로 필요 |
| `lib/presentation/my_page/legal_screen.dart` | 약관·정책 목록 | **남긴다** — 위와 같은 이유 |
| `lib/presentation/common/version_gate/widgets/version_block_screen.dart` | 강제 업데이트 · 점검 차단 | **남긴다** — 설계 3장 AUTH-001 행의 `appConfig/{platform}` 게이트 체인이 쓰는 화면. 지우면 강제 업데이트가 작동 안 함 |

셋 다 이식하지 않는 게 아니라 **이미 들어와 있고 그대로 둔다**. 화면 ID 가 없을 뿐이다.

#### 5. 이식 확인 (4단계)

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

⑥ **키·설정 파일 3개를 git 추적에서 제외** (2026-10-03 점검) —
`lib/firebase_options.dart` · `ios/Runner/GoogleService-Info.plist` · `android/app/google-services.json`.
베타는 이 셋을 커밋했지만(그 규칙을 그대로 물려받아 v1 도 커밋돼 있었다) v1 은 `git rm --cached` 로 추적만 끊고
`.gitignore` 에 넣었다. **파일은 지우지 않았다** — 로컬에 그대로 있어 빌드에 지장 없다.
⚠ **이미 private 레포에 push 된 이력이 있다**(커밋 `35515f9`·`42e99b5`). 원격 이력 정리(force push)는 하지 않았다.
Firebase 웹 API 키는 클라이언트 공개값이라 그 자체로 비밀은 아니지만, 레포가 공개로 바뀌거나 외부에 공유되면
**키 재발급과 Firebase 콘솔 API 키 제한(앱 체크·번들 ID 제한)을 걸어야 한다.**
새로 clone 하면 이 세 파일을 따로 받아야 빌드된다.

⑦ **`pod install` 은 `LANG=en_US.UTF-8` 을 붙여야 돈다** — 프로젝트 경로에 한글(`업무/소스코드`)이 있어
CocoaPods 가 `Unicode Normalization not appropriate for ASCII-8BIT (Encoding::CompatibilityError)` 로 죽는다.
`flutter analyze` 가 같은 경로 때문에 죽는 것과 같은 원인이다. 코드·Podfile 문제가 아니다(베타와 Podfile·Podfile.lock 동일).

```bash
cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install
```

⑧ **`design/admin/` 생성** — 비어 있고 README 만 둔다. 관리자 디자인 원본은 아직 `~/Downloads/VYBE_v1_store/` 에 있다.

⑨ **분류 이름 「그대로 복사」 → 「그대로 사용」** 으로 바꾸고, `screen_map.md` 에
섹션 · 상태 변형 수 · UI 상태 · 백엔드 상태 칸과 관리자 화면 목록(32 + 조회 섹션 14) · 신규 화면 진입점 표를 더했다.


---

### 2026-10-03 — UI 개발 전 결정 사항 (사용자 확정)

이식 점검 보고 9번의 보류 항목을 사용자가 확정했다. 아래가 정본이다.

⑩ **디자인 번들 확정** — Handoff 재수신 없이 현재 `design/user/`(Export ZIP **2026-10-01판**)를
**공식 디자인 원본**으로 확정한다. `design/user/extracted/` 가 그 번들을 파일 단위로 푼 것이다.
Claude Design 에 "VYBE 사용자" 프로젝트는 없으므로 `/design` 으로 찾지 않는다.

⑪ **화면 수 확정** — **A~G 31 + H~T 68 = 99** 가 맞다. 앞선 프롬프트의 「A~G 34 + H~T 65」는
잘못된 예상치였다. `screen_map.md` 는 이미 이 기준으로 돼 있다.

⑫ **하단 탭 — 3번째 자리를 「찜」 → 「패스월렛」으로 교체한다.**
탭 구성은 **홈 · 주변 · 패스월렛 · 검색 · 내 정보**. 찜(PLACE-020)은 **마이에서 진입**한다.
근거는 설계 6-0장과 디자인 `v1_map.js`(「nav:1 = 하단 내비게이션 찜→패스월렛 적용(v1 수정됨)」)이고,
디자인 `home.jsx` 의 TabBar 가 아직 '찜'인 것은 **갱신 누락**으로 본다.
→ 이식 점검 때 「멈추고 보고」로 올렸던 디자인 ↔ 설계 충돌은 **이 결정으로 해소**됐다.
영향: `MainScaffold`(탭 정의·IndexedStack 슬롯) · HOME-005 · PLACE-020 · MY-029(찜 진입 행).

⑬ **CLUB-022 공연 일정 — 베타 진입점(클럽 상세 공연 섹션)을 유지한다.**
디자인 번들 안에 CLUB-022 로 가는 href 가 0건이라 디자인만으로는 도달할 수 없는데,
화면 자체는 설계 3장에 있고 베타에 이미 동작하는 진입점이 있으므로 그대로 둔다.
분류는 **그대로 사용** 유지.

⑭ **CAT-014 — 홈 카테고리 8번째 칸은 「금연」(`NonSmokingScreen`)을 유지한다.**
디자인 홈 그리드의 마지막 칸은 「라운지」지만 `href` 가 비어 있어 **연결 화면이 없다**.
반면 `v1_map.js` 는 CAT-014 를 홈 카테고리 그룹에 등록해 두었다. 동작하는 쪽(베타)을 따른다.

⑮ **베타가 디자인과 일부러 다르게 만든 부분 — 디자인을 따르는 것이 원칙.**
예외는 **성능 때문에 생략한 효과**(전체화면 블러 등)뿐이며 그때만 베타 방식을 유지한다.
화면별 판정은 아래 「결정 ⑮ 화면별 판정」 표에 남긴다.

⑯ **테스트 프로젝트 `performances` 예시 데이터** — `scripts/seed_performances_test.js` 를 만들었다.
UI 확인용 샘플이며 사용자 승인 후 **실행 완료**(2026-10-03, 116개 생성).
- 안전장치: `PROJECT` 가 `-test` 로 끝나지 않으면 즉시 종료 · 기본은 **계획만 출력**(쓰기 없음)
- 규모: 힙합·EDM 활성 클럽 52곳 중 **장르별 8곳 = 16곳**, 오늘부터 **14일**, 클럽 영업일(목·금·토) 안에서만
- 결과: **공연일 6일 · 문서 116개** (오늘 22개 · hero 2/일)
- 난수는 clubId·날짜 해시 기반 결정적 PRNG → 재실행해도 같은 결과(멱등)

### 결정 ⑮ 화면별 판정 — 베타가 디자인과 일부러 다르게 만든 자리 123건

원칙: **디자인 적용**. 예외는 **성능 때문에 생략한 효과**뿐.
화면 ID 하나당 에이전트 1개가 베타 코드의 사유 주석 원문을 확인하고 판정했다.

| 결과 | 건수 |
|---|---|
| 디자인 적용 | **118** |
| 베타 유지 | **5** |
| 합계 | 123 |

**베타 유지 5건** — 4건은 성능(전체화면 블러·레이어 비용), 1건은 성능이 아니라 법적 요구다.

| 화면 | # | 무엇 | 사유 |
|---|---|---|---|
| AUTH-001 | 4 | 퇴장 번쩍임(brightness 1.5) 생략 · 잔광 0.6 | 번쩍임 생략 사유가 명시적 렌더링 비용이다 — '전체화면 [ColorFiltered] 는 매 프레임 레이어를 뜨는데, 같은 순간 아래에서 앱 첫 프레임이 그려지느라 가장 바쁘다'. 성능 예외에 그대로 해당하므로 잔광 대체 방식을 유지한다. 단 잔광 피크값 0.6 은 성능과 무관한 숫자이므로 디자인 spGlowOut 의 0.7 로 올린다(퇴장 길이 820ms 안에 접어 넣는 것은 스플래시가 트리에서 빠지는 앱 구조상 유지). |
| AUTH-001 | 5 | 홈 드러남 연출의 blur 10→0 생략 | 사용자가 예외로 직접 지목한 '전체화면 블러' 바로 그 항목이다. 베타 사유도 성능 그대로 — '전체화면 블러는 앱이 첫 프레임을 그리는 바로 그 구간에 매 프레임 레이어를 하나 더 뜨게 한다'. scale 1.04→1 + opacity 만 쓰는 현재 구현을 유지한다. |
| AUTH-001 | 6 | 바닥 광원 풀의 blur(38px) 생략 | 사유가 레이어 블러의 프레임당 버퍼 비용이다 — '여기에 레이어 블러까지 걸면 화면 크기 버퍼를 매 프레임 뜨게 된다'. 성능 예외에 해당하고, 그라디언트가 반지름 72%에서 투명으로 빠져 경계가 없어 시각 결과 차이도 거의 없다. 현재 구현 유지. |
| AUTH-003 | 1 | 약관 항목 5줄(위치기반 포함) vs 디자인 4줄 | 베타의 사유가 성능이 아니라 **법적 요구**다 — 앱이 실제로 GPS로 주변 클럽을 찾고 있어 위치정보법 제18조의 별도 동의를 빼면 출시 자체가 위법이 된다. 디자인 SV_TERMS 는 setChecked(Array(4)) 로 개수를 박아 둔 프로토타입이라 누락으로 보고 위치기반 항목을 유지한다(성능 예외가 아닌 유일한 베타 유지 건이므로 법무 확인 뒤 사용자 최종 결정 필요). 단 마케팅 항목 라벨은 디자인 문구 '개인정보 마케팅 활용 동의' 로 맞춘다. |
| AUTH-004 | 2 | 상단 바 반투명 잉크 + 블러(20) 미적용 | 사용자 원칙이 예외로 든 '성능 때문에 생략한 블러' 그 자체다. 베타 주석이 '스크롤 영역 위에 붙는 고정 행이라 뒤로 지나가는 콘텐츠가 없다'고 적은 것은 블러 효과가 0이면서 매 프레임 비용만 든다는 뜻이고, CLAUDE.md 글래스 규칙도 같은 근거로 '블러는 옵트인 — 뒤가 정적인 오로라뿐이면 블러해도 눈에 보이는 차이가 없고 매 프레임 뒤 배경을 다시 뜨는 비용만 든다'로 못 박아 BackdropFilter 를 '뒤에 사진·본문이 실제로 지나가는 자… |

⚠ **AUTH-003 #1 은 사용자 확인이 필요하다** — 약관 동의 시트의 「위치기반서비스 이용약관」 항목(디자인 4줄 vs 베타 5줄).
베타가 뺀 것이 아니라 **더 넣은** 것이고 사유가 성능이 아니라 위치정보법 제18조의 별도 동의 요건이다.
디자인 프로토타입이 `setChecked(Array(4))` 로 개수를 박아 둔 누락으로 보이지만, 법무 확인 뒤 최종 결정이 필요하다.

**화면별 집계**

| 화면 | 판정 건수 | 디자인 적용 | 베타 유지 |
|---|---|---|---|
| AUTH-001 | 8 | 5 | 3 |
| AUTH-002 | 2 | 2 | 0 |
| AUTH-003 | 4 | 3 | 1 |
| AUTH-004 | 3 | 2 | 1 |
| CAT-010 | 3 | 3 | 0 |
| CAT-011 | 6 | 6 | 0 |
| CAT-012 | 6 | 6 | 0 |
| CAT-013 | 4 | 4 | 0 |
| CAT-014 | 4 | 4 | 0 |
| CAT-015 | 3 | 3 | 0 |
| CAT-016 | 2 | 2 | 0 |
| CAT-017 | 5 | 5 | 0 |
| CAT-018 | 3 | 3 | 0 |
| CLUB-021 | 6 | 6 | 0 |
| CLUB-022 | 4 | 4 | 0 |
| CLUB-023 | 1 | 1 | 0 |
| CLUB-026 | 6 | 6 | 0 |
| CLUB-028 | 3 | 3 | 0 |
| HOME-005 | 5 | 5 | 0 |
| HOME-006 | 5 | 5 | 0 |
| HOME-007 | 2 | 2 | 0 |
| HOME-008 | 2 | 2 | 0 |
| HOME-009 | 2 | 2 | 0 |
| MY-029 | 4 | 4 | 0 |
| MY-030 | 5 | 5 | 0 |
| MY-031 | 4 | 4 | 0 |
| MY-032 | 4 | 4 | 0 |
| MY-033 | 9 | 9 | 0 |
| PLACE-019 | 6 | 6 | 0 |
| PLACE-020 | 2 | 2 | 0 |

판정 전문(차이별 사유 · 베타 주석 원문 인용)은 `docs/screen_map.md` 의 화면별 상세와 함께 보면 된다.

### v1 공통 기반 — 만든 것 (2026-10-03)

**설정**
- `core/config/backend_env.dart` — `--dart-define=VYBE_BACKEND=fake|emulator|prod`(기본 fake) · `kVybeBackend` · `kUsesFakeBackend`

**토큰** `design_system/v1_tokens.dart` (기존 토큰은 **하나도 바꾸지 않았다**)
- `V1Colors` — 앰버 500/700 · 오류 red300 · 보라 글자 2종 · 티켓 헤더 그라데이션 5종 · 입장완료 방사광 2 · 좌석 스트라이프 2 · 메뉴 썸네일 · 탭 티켓 아이콘 선
- `VybeBadgeTone` 7종(neutral·waiting·called·entered·pending·done·error) — 채움/테두리/글자 3색
- `VybeRefundTone` 3종(ok·part·no)
- `V1Typo` — ticketNumber(44) · orderNumber(56) · bigNumberSmall · stepperNumber · ticketClub · statValue · badge · serial
- `V1Dim` — 하단 버튼 56 · 카드 버튼 48 · radius(배지 99 · 티켓 18 · 안내 12 · 카드 14) · 페이지 여백

**공용 위젯 14개** `presentation/common/widgets/` (전부 `Vybe` prefix)
`VybeStatusBadge` · `VybeKvRow`/`VybeKvCard`/`VybeAmountCard` · `VybeNoteBox`/`VybeInlineBanner` ·
`VybeBottomActionBar` · `VybeTicketCard`/`VybeTicketPerforation`/`VybeTicketStub`/`VybeTicketStats`/`VybeTicketBigNumber` ·
`VybeQrPanel`/`VybeQrLockCapsule` · `VybeStepIndicator` · `VybeSegmentTabs` · `VybeStepper` ·
`VybeMinSpendGauge` · `VybeResultView` · `VybePinInput`/`VybeSerialRow` · `VybeGradientSpinner`

**모델** `data/models/v1/` (순수 Dart + freezed · build_runner 실행 완료)
- `v1_enums.dart` — 상태 enum **21종**(WaitingStatus · ReservationStatus · OrderStatus · PaymentStatus · RefundStatus · CancelBucket · PenaltyKind · SeatTier · TableHoldStatus · PaymentMethod · … )
- `v1_shared.dart` — TicketPaymentSummary · TicketRefundSummary · TicketShareSummary · PenaltyLine · WaitingFee · EntryRef · OrderLine · OrderLineOption
- `waiting_model.dart` · `reservation_model.dart`(+Guest·Cancel·NoShow·Day·DayTable) · `order_model.dart`(+Timeline·Reject) ·
  `share_model.dart`(SharedTicket · SharePreview · ShareLinkRule) · `payment_model.dart`(Payment · Refund · ReservationRules) ·
  `club_ops_model.dart`(Settings · Live · Waiting/Order/Reservation/Share) · `pass_models.dart`(HistoryItem · AppNotification · EntryQrToken · Policy)

**datasource**
- 인터페이스 4 — `waiting_datasource` · `reservation_datasource` · `order_datasource` · `share_datasource` (**Firebase import 없음**)
- Fake 4 — `fake/fake_*_datasource.dart` + `fake_scenario.dart`(상태 전환 훅) + `fake_sample_data.dart`(**디자인 원문 값**: 어썸레드 · WT-2607-0005 · RS-2607-1182 · ARD-4F9K-2Q71 · 입장비 20,000 · 최소주문 500,000 · HARD SET A/B · 545,500원 …)
- 외부 API 스텁 4 — `payment_gateway.dart` 인터페이스 + `fake_payment_gateway.dart` 구현
  (PG · 본인인증 · 알림톡/SMS · 계좌 실명 확인). 전부 `// TODO[외부API] 설계 7장 · [임시]` 주석, 성공/실패 선택 가능
- **구현 선택 한 곳** — `data/repositories/v1_providers.dart`

**개발 도구** `presentation/dev/` (`kDebugMode` 전용)
- `vybe_dev_overlay.dart` — 끌어 옮기는 입구 버튼 + 루트 navigatorKey
- `vybe_dev_menu.dart` — 백엔드 표시 · Fake 상태 7종 전환
- `vybe_widget_gallery.dart` — 공용 위젯 미리보기

**테스트** `test/v1_common_test.dart` 15건 — enum 키 · 종료 상태 · Fake 시나리오 5 · 서버 확정 금액 ·
`VYBE_BACKEND` 기본값 · 공유 규칙 · mm:ss · 배지 톤 · **360px 오버플로**

### 2026-10-03 — v1 공통 기반 (토큰 · 위젯 · 모델 · Fake)

⑰ **v1 신규 모델은 `cloud_firestore` 를 import 하지 않는다.** 베타 모델 일부는 모델 안에서
`Timestamp` 를 다루지만, v1 은 Fake ↔ Firebase 교체가 전제라 변환을 remote datasource 쪽에 둔다
("datasource 인터페이스는 Firebase import 금지" 규칙과 같은 이유). 모델은 순수 Dart + freezed.

⑱ **상태는 String 이 아니라 enum 으로 둔다.** 설계 4장이 "상태 enum" 을 요구하고, 값(`key`)은 문서와
글자 그대로 같게 뒀다. 모르는 값이 오면 `unknown` 으로 떨어뜨린다 — 서버가 상태를 늘려도 앱이 죽지 않게.
(베타 `facilities` 가 모르는 키를 조용히 버리는 것과 같은 규칙)

⑲ **공용 위젯은 "두 화면 이상 반복"만 만들었다.** 조사에서 나온 후보 96개 중 섹션을 넘나들며 반복되는
14개만 만들고, 한 섹션 전용(메뉴 행 · 결제 수단 타일 · 약관 묶음 · 바텀시트)은 **그 섹션 화면을 만들 때**
모양이 굳은 뒤 승격하기로 했다(베타의 '두 번째 화면에서 복붙하게 되면 승격' 규칙).
만들지 않은 후보와 이유는 `screen_map.md` 「만들지 않은 공용 위젯 후보」 참고.

⑳ **기존 위젯은 새로 만들지 않고 확장 대상으로 적어 뒀다** — `VybeConfirmDialog`(본문 슬롯) ·
`RenewFooterNote`(불릿) · `RenewChip`(비활성) · `RenewSectionHead`(아이콘·배지) ·
`VybeGlassButton`(알림 점) · `VybeRecommendBadge`(변형) · `VybeGlassHeader`(스크롤 반응).
이번에는 **건드리지 않았다** — 기존 화면 동작이 바뀌면 안 되기 때문이고, 각 화면 작업 때 함께 고친다.

㉑ **개발 메뉴는 `MaterialApp.builder` 한 곳에만 붙였다.** 화면 코드를 건드리지 않으려는 선택이다.
그 자리는 Navigator **바깥**이라 `Navigator.of(context)` 가 안 먹어 루트 `navigatorKey` 를 하나 뒀다
(`vybeRootNavigatorKey`). 릴리스 빌드에서는 오버레이가 **트리에 아예 없다**(`kDebugMode` 반환 분기).

㉒ **QR 은 플레이스홀더 패턴을 그린다.** 실제 QR 인코딩은 백엔드 단계에서 `issueEntryQr` 응답(JWT)을
받아 그린다. UI 단계에선 자리 · 크기 · 만료 · 잠김 상태만 맞추면 된다.

㉓ **좌석 배치도(`VybeFloorPlan`)는 만들지 않았다** — 기존 `table_floor_map.dart` 는 **정수 그리드 셀**
(cols×rows + cells 마스크), 디자인 `FloorPlan` 은 **절대 px 좌표**다. 좌표 체계가 달라 그대로 못 쓴다.
예약 좌석 선택을 어느 쪽으로 그릴지 **사람이 정해야 한다**(아래 남은 확인 사항).

### 2026-10-03 — STEP 4-A 결정 ⑫ 반영 (하단 탭 묶음)

㉔ **하단 탭은 아이콘만 그린다(라벨 없음) — 베타 방식 유지.**
HOME-005 차이 #2 가 "디자인은 아이콘 아래 한글 라벨을 쌓는다"고 적었지만, 그건 디자인의
**비-LG 폴백**(`<nav className="tabbar">`)이다. 스토리보드 html 이 `<html class="lg-on">` 이라
실제로 쓰이는 것은 `<nav className="lg-tabbar">` 이고, 그쪽은 `aria-label` 만 주고
**아이콘만** 그린다. 베타의 리퀴드 글래스 플로팅 바가 그 쪽이라 그대로 둔다.
`MainNavItem.label` 은 접근성·테스트용 이름으로만 남겼다.

㉕ **패스월렛 탭 아이콘은 디자인 모양 + 베타 선 아이콘 관례.**
디자인 `LG_TICKET` 은 채운 티켓 + 안쪽 점선인데, 베타 탭 아이콘은 전부 24×24 선 아이콘이고
`ColorFilter(srcIn)` 로 색을 입힌다 — 채운 아이콘을 그대로 넣으면 활성 시 라임 덩어리가 된다.
모양(티켓 + 안쪽 점선 3칸)은 디자인 path 그대로 쓰고 **선 아이콘으로** 그렸다.
`assets/icons/bottom_nav/pass_wallet.svg`.

㉖ **PLACE-020 빈 상태에서 툴바를 다시 보이게 했다(디자인 적용).**
베타는 `if (!isEmpty)` 로 숨기고 "(디자인과 다름)" 주석을 달아 뒀다. 디자인은 `SGHeader`·`SGToolbar`
를 조건 없이 그린다. 디자인 우선 원칙(결정 ⑮)대로 되돌렸고, 이 동작을 검사하던 기존 테스트를 고쳤다.

㉗ **PLACE-020 '둘러보기' 는 닫고 나서 홈 탭으로 간다.**
push 화면이 되어 탭만 바꾸면 이 화면이 위에 남는다. `maybePop()` 뒤 탭 요청으로 바꿨다.

---

## 확인 기록

### 디자인 번들 상태 (2026-10-03 점검)

`design/user/` 에 번들이 **이미 있다** — Claude Design Export 로 받은 2026-10-01판 ZIP 을 푼 것
(`VYBE_v1_prototype.html` · `VYBE_v1_storyboard.html` · `screen/assets/` · README).
`/design`(DesignSync) 같은 다른 경로로 본 적 없고, 이식 분류 때 본 것과 **같은 번들**이다.
읽기 편하도록 `design/user/extracted/` 에 풀어 둔 것(html 33 + jsx 69)도 그대로다.

⚠ **Handoff 프롬프트가 전달되지 않았다** — 이번 지시문에 "위에 붙여넣은 내용은 … Handoff 프롬프트" 라고
돼 있으나 실제로는 작업 지시만 왔다. 그래서 **번들을 새로 받아 대조하지 못했다**.
지금 번들이 최신인지 확인하려면 Handoff 프롬프트를 붙여 주거나,
Export 대화상자에서 `Download zip instead` 로 받은 ZIP 을 `design/user/` 에 덮어쓰면 된다.
화면 수가 Handoff 안내(A~G 34 + H~T 65)와 분배가 다른 것도 이 대조가 돼야 결론이 난다
(합계 99 · L 섹션 빈 번호는 일치).


### 2026-10-03 이식 점검 (UI 개발 준비)

| 항목 | 명령 | 결과 | 판단 |
|---|---|---|---|
| 의존성 | `flutter pub get` | Got dependencies! | 정상 |
| iOS 의존성 | `LANG=en_US.UTF-8 pod install` | 43 pods installed · Podfile.lock 베타와 동일 | 정상 (결정 기록 ⑦) |
| 정적 분석 | `dart analyze` | **No issues found** | 정상 |
| 정적 분석 | `flutter analyze` | LSP FormatException 크래시 | **이식 전부터 있음** — 한글 경로 문제, 베타도 동일. `dart analyze` 를 쓴다 |
| 테스트 | `flutter test` | **390 passed** | 정상 |
| 빌드 | `flutter build ios --simulator --debug` | 성공 | 정상 |
| 시뮬레이터 | iPhone 16 Pro Max · iOS 18 | 홈 · 주변 지도 · 클럽 상세 · 리뷰 · 검색 · 찜 · 마이 · EDM 전부 정상 | 정상 |

- `pod install` 경고 `[!] CocoaPods did not set the base configuration ...` 는 Flutter 기본 구성에서 나오는 것으로
  베타와 Podfile·설정이 같고 빌드가 성공하므로 **이식 전부터 있음**으로 기록만 한다.
- 이식하지 않은 베타 화면으로 인한 참조 오류 **없음** — 이식이 전체 복사였고 analyze 0 · test 390 통과로 확인.
- 기준 기기는 iPhone 15 로 지시됐으나 이미 부팅돼 있던 **iPhone 16 Pro Max(iOS 18)** 로 확인했다.
  화면 폭이 넓은 쪽이라 레이아웃 오버플로가 덜 드러날 수 있다 — 좁은 기기(iPhone SE) 확인은 UI 작업 때 같이 한다.

### 런타임에서 비어 보이지만 이식 결함이 아닌 것

- ~~장르 페이지 공연 일정이 "공연 0개"~~ **해소됨 (2026-10-03)** — 결정 ⑯ 의 seed 를 실행해
  `performances` 116개를 넣었다. 아래 「performances 데이터 투입 후 확인」 참고
- 마이페이지 이름이 `VYBER` — 테스트 계정에 `nickname` 미배정이라 폴백이 뜬 것(정상)

---

### performances 데이터 투입 후 확인 (2026-10-03)

`node scripts/seed_performances_test.js --write` 실행 → `vybe-bata-c07aa-test` 에 **116개** 생성.
필요한 복합 인덱스 2개는 이미 READY 였다 — `performances(genre,date,isActive,startAt)` · `performances(clubId,startAt)`.

| 화면 | 결과 |
|---|---|
| CAT-017 EDM | 「DJ 공연 일정 · 10월 3일 (토) · **공연 16개**」 · 앞 3줄 또렷 + 4번째 흐림 + 전체보기 pill (디자인대로) |
| CAT-018 DJ 공연 일정(전체) | 「오늘 밤 공연 16개」 타임라인 — 이태원 클럽 헤비/SAGE · 비트박스 클럽/GRIM · 클럽 소닉/SABLE · 스카이 클럽/ZENON · 클럽 인피니티/KODA · 건대 클럽 블라스트/QUARTZ … |
| CAT-016 힙합 | 「오늘의 공연 아티스트」 레일 — DAZE(더 팰리스) · KRYPT(클럽 러쉬) · YANO(더 정글) · TIDAL(DJ) . `artistType` 아이콘 분기(마이크/디스크) 정상 |
| HOME-009 오늘의 라인업 | 「10월 3일 (토) · **6팀**」 · 필터 칩 전체 6 / 래퍼 3 / DJ 3 · 22:00~01:00 타임라인 |
| CLUB-021 클럽 상세 공연 섹션 | 더 팰리스 — DAZE **HEADLINE** 22:00·래퍼 / TIDAL 23:30·DJ. `headlinerByClub` 정상 |

거리 표기(0.1km~6.9km) · 「368분 후 시작」 상대 시각 · hero `isFeatured` 전부 정상.
오류 · 빈 화면 **없음**.

### 2026-10-03 v1 공통 기반 확인

| 항목 | 결과 |
|---|---|
| `dart analyze lib/ test/` | **No issues found** |
| `flutter test` | **405 통과** (기존 390 + 신규 15) |
| `flutter build ios --simulator --debug --dart-define=VYBE_BACKEND=fake` | 성공 |
| 기존 화면 | 스플래시 → 홈(배너·카테고리·하단탭) 정상. 로그인 유지됨 |
| 개발 메뉴 | `VYBE_BACKEND: fake` 표시 · 상태 칩 7종 · 미리보기 진입 정상 |
| 공용 위젯 미리보기 | 배지 7종 · 티켓 3종(보라·라임·회색 dimmed) · QR/잠김 · Kv/금액 카드 · 안내/배너 · 단계 · 세그먼트 · 스테퍼 · 게이지 · PIN/일련번호 · 스피너 · 결과 틀 · 하단 바 전부 렌더 |
| 좁은 기기 | 테스트가 **360px**(iPhone SE 375 보다 좁다)에서 전 위젯 오버플로 검사. 시뮬레이터는 iPhone 16 Pro Max 로 확인 |
| 릴리스 가드 | 오버레이가 `if (!kDebugMode) return widget.child;` 로 트리에서 빠진다 · `VybeDevMenu.open` 도 같은 가드 |

**미리보기에서 찾아 고친 것 (디자인 대조)**

| 무엇 | 문제 | 고침 |
|---|---|---|
| `VybeKvRow` | 긴 라벨이 46px 넘침 | 라벨 `Flexible`, 값 `Flexible(flex:2)` |
| `VybeAmountCard` | 합계 줄 228px 넘침 | 양쪽 `Flexible` + 우측 정렬 |
| `VybeStepIndicator` | 4단계가 93px 넘침 | 칸 **등분**(각 단계 `Expanded`) 구조로 재작성 · 레일을 Stack 뒤로 |
| `VybeSegmentTabs` | 탭 4개 + 건수가 45px 넘침 | `FittedBox(scaleDown)` |
| `VybeTicketCard` 절취선 | 펀치 구멍이 **안 보였다** — `BlendMode.clear` 는 카드 안쪽 페인터라 카드 배경을 못 지운다 | 배경색(`RenewGlass.ink`) 원으로 찍어 파인 것처럼 |

앞 넷은 **테스트가 먼저 잡았고**(`test/v1_common_test.dart`), 절취선은 **시뮬레이터 눈으로** 잡았다.

### 임시 연결 목록

실제 화면이 없어 자리표시만 둔 곳. **STEP 5 에서 교체한다.**

| 화면 ID | 임시 화면 | 진입 경로 | 교체 시점 |
|---|---|---|---|
| PASS-035 패스월렛 | `lib/presentation/pass_wallet/pass_wallet_screen.dart` | 하단 탭 3번째 | STEP 5 (H 섹션 작업) |


### 2026-10-03 STEP 4-A 확인 (결정 ⑫ 하단 탭 묶음)

확인 기기 — **iPhone 16 Pro Max · iOS 18**(iPhone 15 시뮬레이터가 없어 부팅돼 있던 기기를 썼다).
로그인 상태 유지됨(작업 중 로그아웃하지 않았다).

| 화면 ID · 상태 | 확인 기기 | 디자인 대조 | 동작 확인 | 발견한 문제 | 수정 여부 |
|---|---|---|---|---|---|
| MainScaffold · **완료** | 16 Pro Max | 탭 5칸 · 3번째 티켓 아이콘 · 활성 라임 · 아이콘만(lg-tabbar) | 탭 전환 · 탭별 Navigator 상태 유지 | 없음 | — |
| PASS-035 임시 · **완료** | 16 Pro Max | 화면 ID + 이름만 (임시) | 탭 → 임시 화면 열림 | 없음 | — |
| PLACE-020 · **완료**(진입·상단바·빈상태) | 16 Pro Max | 뒤로가기 상단바 「찜한 클럽」 · 헤더 · 툴바 · 카드 | 마이 → push · 하단 바 내려감 · 뒤로가기 복귀 | 없음 | — |
| MY-029 · **완료**(찜·알림 진입) | 16 Pro Max | 찜 행 · 알림 행 | 찜 → PLACE-020 push · 알림 → HOME-007 push | 없음 | — |
| HOME-005 · **보류** | — | — | — | 디자인 차이 17건 미반영 | 보류 (아래) |
| PLACE-019 · **보류** | — | — | — | 디자인 차이 13건 미반영 | 보류 (아래) |

**보류 사유** — 이번 작업의 1차 목표(결정 ⑫ 하단 탭 교체와 그에 딸린 진입 경로)를 끝내고
시뮬레이터로 검증했다. HOME-005 17건 · PLACE-019 13건 · PLACE-020 나머지 6건 ·
MY-029 나머지 11건은 **탭 교체와 무관한 디자인 차이**라 다음 작업으로 미뤘다.
그중 아래 4건은 **데이터가 없어 지금은 못 한다**:

| 차이 | 왜 못 하나 |
|---|---|
| HOME-005 #4 주변 클럽 혼잡도 pill | `clubs` 에 혼잡도 필드가 없다. 설계 4장에도 없다 |
| HOME-005 #1 알림 배지 수 | `users.unreadNotificationCount` 는 v1 신규 — 백엔드 단계 |
| PLACE-019 #2 핀 카드 대기 팀 수 | `ops/live` 는 v1 신규 — Fake 를 물리거나 백엔드 단계 |
| PLACE-020 #2 HOT 뱃지 | 뒤를 받칠 데이터가 설계에 없다 |

**고친 기존 테스트**

| 테스트 | 왜 |
|---|---|
| `test/saved_screen_test.dart` 「빈 목록 … 툴바 없음」 | 결정 ㉖ 으로 **동작이 의도적으로 바뀌었다**(디자인대로 빈 상태에서도 툴바 유지). 기대값을 `findsNothing` → `findsOneWidget` 으로 바꾸고 제목도 고쳤다. 검사하던 나머지(빈 카드 · CTA 가 홈 탭 요청)는 그대로 둔다 |

**추가한 테스트** — `test/v1_tab_swap_test.dart` 3건
탭 구성·순서(순서가 곧 PageView 인덱스) · 패스월렛 임시 화면 · PLACE-020 뒤로가기 상단바.

| 항목 | 결과 |
|---|---|
| `dart analyze lib/ test/` | **No issues found** |
| `flutter test` | **409 통과** |

## 다음 작업

### 보류였던 것 — 전부 해소됨 (2026-10-03)

| 보류 항목 | 결론 |
|---|---|
| 디자인 번들 최신 여부 | 결정 ⑩ — 현재 ZIP 2026-10-01판을 공식 원본으로 확정 |
| 하단 탭 3번째 자리 (디자인 ↔ 설계 충돌) | 결정 ⑫ — **패스월렛으로 교체**, 찜은 마이에서 진입 |
| 화면 수 분배 (34+65 vs 31+68) | 결정 ⑪ — **31+68=99** 가 맞다 |
| CLUB-022 진입점 | 결정 ⑬ — 베타 진입점 유지 |
| CAT-014 금연 vs 라운지 | 결정 ⑭ — **금연** 유지 |
| 베타가 일부러 다르게 만든 자리 | 결정 ⑮ — 디자인 우선, 성능 생략만 베타 유지 (화면별 판정 표) |
| 테스트 `performances` 비어 있음 | 결정 ⑯ — **실행 완료**(116개). 장르 페이지·클럽 상세 공연 섹션 확인 끝 |

### 순서

1. **`복사 후 수정` 29화면 UI 작업** — `docs/screen_map.md` 의 화면별 상세(차이 384건)를 보고 고친다.
   신규 68화면보다 먼저 하는 이유: 공용 위젯·토큰이 여기서 확정돼야 신규 화면이 그걸 쓴다.
   차이가 많은 MY-033 · CLUB-026 · CAT-012 부터 보는 걸 권한다.
2. **H~T 신규 68화면 UI** — Fake datasource 구조(CLAUDE.md ⭐ v1 규칙)로. Firebase 호출 없음.
3. 백엔드 단계 — Emulator 에서 `docs/backend_design.html` 대로 구현 후 datasource 교체.

### 남은 확인 사항

- **예약 좌석 배치도 좌표 체계** — 기존 그리드(정수 셀) vs 디자인(절대 px). 결정 ㉓ 참고.
  RSV-047 작업 전에 정해야 한다
- **AUTH-003 약관 항목 수** — 디자인 4줄 vs 베타 5줄(위치기반서비스). 베타 쪽이 위치정보법 제18조 별도 동의 요건이라
  유지로 판정했으나 **법무 확인 후 최종 결정** 필요 (결정 ⑮ 표의 유일한 비(非)성능 예외)
- 기준 기기 iPhone 15(또는 SE) 좁은 폭 레이아웃 확인은 UI 작업과 함께
