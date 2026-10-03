# vybe_bata → vybe_v1 이식 · 분류 · 점검 결과

작업일 2026-10-03 · 레포 `unknownChoi/vybe_v1` (private) · 기준 커밋 `35515f9` → `9d2a199`

> 루트 `result.md` 은 베타에서 복사돼 온 2026-09-06 ponytail-audit 기록이라 건드리지 않았다.

---

## 0. 한눈에

| 단계 | 결과 |
|---|---|
| 1. 기존 코드 파악 | 베타 전 화면·위젯·모델·datasource 인벤토리 완료 (destination 113개) |
| 2. 화면 분류 | 사용자 앱 **99화면 전부** 분류 — 그대로 사용 2 · 복사 후 수정 29 · 신규 개발 68 · 판단 보류 0 |
| 3. 이식 | **이미 끝나 있었다** (`35515f9`). 베타와 다른 파일 2개뿐, import 수정 0건 |
| 4. 이식 확인 | `dart analyze` 0 · `flutter test` 390 통과 · iOS 빌드 성공 · 시뮬레이터 전 화면 정상 |
| 점검 | 설정 보강 · 문서 정비 완료. **UI 개발 진입은 보류** (아래 9번 2건) |

생성 문서 — `docs/screen_map.md`(1030줄) · `docs/progress.md` · `docs/backend_design.html` · `design/user/` · `design/admin/`

---

## 1. 기준 문서 — 둘 다 레포에 없었다

CLAUDE.md ⭐ v1 규칙이 가리키는 두 문서가 레포에 없어 분류를 시작할 수 없었다. 원본을 찾아 제자리에 넣었다.

| 문서 | 어디 있었나 | 어디로 |
|---|---|---|
| 백엔드 설계서 | `~/Downloads/VYBE_v1_firebase_backend_design.html` (2026-10-02판) | `docs/backend_design.html` |
| 사용자 앱 디자인 원본 | `~/Downloads/VYBE_v1_offline 2/` (2026-10-01판, 최신) | `design/user/` |
| 관리자 디자인 원본 | `~/Downloads/VYBE_v1_store/` | 아직 안 옮김 (`design/admin/README.md` 에 위치 기록) |

- Claude Design 프로젝트(`/design`·DesignSync)에는 **"VYBE 사용자"가 없다**. 찾지 말 것.
- `VYBE_v1_prototype.html` · `VYBE_v1_storyboard.html` 은 `window.__VBF` JSON 에 **파일 109개를 통째로 품은 자급식 번들**이라 그대로는 못 읽는다 → `design/user/extracted/` 에 파일 단위로 풀었다 (html 33 + jsx 69 + 공용 js 7).
- `design/user/screen/assets/` (이미지·영상 25MB) 는 `.gitignore` 제외. 화면 구조·문구·레이아웃은 전부 `extracted/` 코드에 있다.

---

## 2. 이식 — 이미 끝나 있었다

`vybe_v1` 은 `35515f9 chore: copy beta as v1 baseline` 에서 베타 전체 복사본으로 만들어졌다. 이번에 실측 확인:

| 대상 | 결과 |
|---|---|
| `lib/` · `test/` · `assets/` · `functions/` · `scripts/` | vybe_bata 와 **완전 동일** |
| `pubspec.yaml` · `pubspec.lock` · `analysis_options.yaml` | 동일 |
| 다른 파일 | **2개뿐** |
| **import 경로 수정** | **0건** — 패키지명이 양쪽 다 `vybe` 라 경로가 안 바뀐다 |

다른 파일 2개 (의도된 v1 변경):

```
lib/firebase_options.dart        테스트 Firebase 프로젝트(vybe-bata-c07aa-test)로 교체
lib/core/utils/map_launcher.dart 네이버 지도 appname  com.justinchoi.vybe → .vybe.dev
```

`partner/` 는 **베타에 없다**. CLAUDE.md 폴더 설명이 낡았다 — 테이블 배치 편집기는 별도 레포 `소스코드/vybe-partner/` 에 있다. 이식할 것이 없다.

---

## 3. 화면 분류 결과

### 3-1. 요약

| 분류 | 수 | 화면 |
|---|---|---|
| **그대로 사용** | **2** | AUTH-004 인증번호 입력 · CLUB-022 공연 일정 |
| **복사 후 수정** | **29** | A~G 나머지 전부 |
| **신규 개발** | **68** | H~T (PASS·WAIT·RSV·MENU·ORDER·FEE·SHARE) |
| **판단 보류** | **0** | — |
| **디자인 없음** | **3** | 베타에 있고 v1 디자인에 ID 가 없는 화면 (유지) |
| 관리자 | 46 | 화면 32 + 조회 섹션 14 (목록만) |

### 3-2. 분류 방법

화면 ID 하나당 에이전트 1개가 **디자인 jsx ↔ 베타 Flutter 코드**를 대조(1차) → 다른 에이전트가 **반박 전용**으로 재검사(2차). 31화면 전부 2차까지 끝났고 전부 `confidence: high`.

1차에서 "그대로 사용"으로 나왔던 **AUTH-001·AUTH-002 가 2차에서 뒤집혔다** — 베타가 디자인과 일부러 다르게 만든 자리가 원인.

### 3-3. 찾은 차이 384건

| 종류 | 건수 |
|---|---|
| 레이아웃 | 105 |
| 상태 | 75 |
| 문구 | 70 |
| 신규요소 | 49 |
| 흐름 | 31 |
| 삭제요소 | 22 |
| 진입점 | 22 |
| 백엔드 | 10 |

차이 많은 순 — MY-033 탈퇴(22) · CLUB-026 웨이팅(21) · CAT-012 입장비 무료(18) · HOME-005 홈(17) · CAT-013 서비스 음료(17) · CLUB-021 클럽 상세(17)

화면별 상세는 `docs/screen_map.md` 뒷부분에 **디자인 파일:행 ↔ 베타 파일:행** 근거까지 적었다.

### 3-4. 예시 — AUTH-001 스플래시가 "복사 후 수정"인 이유

- 디자인에 있는 **하단 로딩 라인**(96×2 트랙 + 라임 바 왕복)이 베타에 **없음** — 베타가 의도적으로 뺐다는 주석까지 있음
- 베타에만 있는 **미러볼 + 반사광 점 14개** (디자인 무대 레이어 5겹엔 대응 요소 0)
- 최소 노출 2.0초(디자인) vs 2.6초(베타), 로고 빛 스침 2회 vs 1회
- 퇴장 번쩍임(`brightness(1.5)`)·홈 블러(`blur(10px)`)·바닥 광원 블러(38px) 생략

### 3-5. 신규 68화면 매핑

설계 3장의 신규 68행과 디자인 `nf_specs.js` 의 68항목이 **순서·이름까지 1:1**(불일치 0건). `screen_map.md` 에 화면 ID ↔ 프로토 ID ↔ 컴포넌트 ↔ 파일로 적었다. 상태 변형 총 162개.

### 3-6. 디자인 없음 3화면 — 지우지 않고 유지

| 파일 | 무엇 | 유지 이유 |
|---|---|---|
| `lib/presentation/auth/terms/terms_detail_screen.dart` | 약관 전문 4종 | 약관 동의 시트·마이 약관 목록이 여는 법적 고지 |
| `lib/presentation/my_page/legal_screen.dart` | 약관·정책 목록 | 위와 같음 |
| `lib/presentation/common/version_gate/widgets/version_block_screen.dart` | 강제 업데이트·점검 차단 | 설계 3장 AUTH-001 행 `appConfig/{platform}` 게이트가 쓰는 화면 |

베타 `*_screen.dart` 38개 중 35개는 v1 화면 ID 에 대응. 참조 때문에 생긴 빌드 오류는 **없다**.

### 3-7. 화면 수 분배 차이

Handoff 안내는 **A~G 34 + H~T 65**, 지금 번들·설계 3장 기준은 **A~G 31 + H~T 68**.
합계 99와 L 섹션(ORDER-057~060)이 빈 번호인 것은 일치. 번들에 없는 화면 ID 는 없다.
섹션 경계만 다르게 센 것으로 보이며, 번들 대조가 돼야 결론난다(9번 참고).

---

## 4. v1 신규 화면 진입점 — 이식 코드에 없는 것 10건

| 신규 흐름 | 디자인이 정한 진입점 | 이식 코드에 있나 | 고쳐야 할 화면 |
|---|---|---|---|
| H 패스월렛 (PASS-035~043) | 하단 탭 3번째 자리 | **없음** | `MainScaffold` · HOME-005 · PLACE-020 |
| I 웨이팅 (WAIT-044~046) | 클럽 상세 하단 바 **웨이팅 등록** | **없음** | CLUB-021 |
| N 입장비 웨이팅 (FEE-069~075) | 위 버튼에서 입장비 있을 때 분기 | **없음** | CLUB-021 · CLUB-026 |
| J 테이블 예약 (RSV-047~053) | 클럽 상세 하단 바 **테이블 예약** | **없음** | CLUB-021 · CLUB-023 |
| K·M 오더 (MENU-054~056 · ORDER-061~068) | 클럽 상세 메뉴 탭 · 패스월렛 주문 탭 | **없음** | CLUB-021 · 패스월렛 |
| O 공유 (SHARE-076~086) | 패스월렛 입장권 상세 → 공유하기 | **없음** | 패스월렛 |
| R 취소·변경 (RSV-091~103) | 패스월렛 예약 상세 | **없음** | 패스월렛 |
| CLUB-028 리뷰 (신규 경로) | 웨이팅 티켓 「후기 작성하기」 · 알림 CTA | **없음** | CLUB-028 · HOME-007 · MY-031 |
| CAT-011 핫플레이스 (신규 경로) | 패스월렛 빈 상태 「전체보기」 | **없음** | 패스월렛 |
| HOME-007 알림 | 홈 GNB 종(있음) + **마이 「알림」 행** | 마이 행은 "준비 중" 토스트 | MY-029 |

해당 화면은 전부 이미 `복사 후 수정` 으로 분류돼 있다.
베타에 이미 있는 진입점(홈 카테고리 8칸 · 검색 해시태그 키 · 클럽 상세 「가격표」 · 홈 배너 → 공지)은 디자인과 일치해 손대지 않는다.

---

## 5. 이식 확인 결과

| 항목 | 명령 | 결과 | 판단 |
|---|---|---|---|
| 의존성 | `flutter pub get` | Got dependencies! | 정상 |
| iOS 의존성 | `LANG=en_US.UTF-8 pod install` | 43 pods · Podfile.lock 베타와 동일 | 정상 |
| 정적 분석 | `dart analyze` | **No issues found** | 정상 |
| 정적 분석 | `flutter analyze` | LSP FormatException 크래시 | **이식 전부터 있음** |
| 테스트 | `flutter test` | **390 passed** | 정상 |
| 빌드 | `flutter build ios --simulator --debug` | 성공 (57.4s) | 정상 |
| 파일 비교 | `diff -rq` | import 외 변경 없음 (다른 파일 2개뿐) | 정상 |

### 시뮬레이터 (iPhone 16 Pro Max · iOS 18)

스플래시 → 로그인(AUTH-002) → 본인 인증 안내 시트 → 본인 인증(AUTH-003) → **로그인** →
홈(HOME-005, 배너 7장·카테고리 8칸) → 주변 지도(PLACE-019, 네이버 지도 + "내 주변 클럽 103") →
클럽 상세(CLUB-021, 히어로 1/5 + sticky 탭 5개) → 리뷰 탭(평점 5.00 분포 바) →
검색(HOME-006, 해시태그 8 + 인기 검색어 10) → 찜(PLACE-020) → 마이(MY-029) → EDM(CAT-017)

빌드 오류 · 런타임 오류 · 빈 화면 · 깨진 이미지/폰트 **없음**. Storage 이미지 정상 로드.

기준 기기는 iPhone 15 로 지시됐으나 이미 부팅돼 있던 16 Pro Max 로 확인했다 — 좁은 기기(SE) 확인은 UI 작업 때 같이 한다.

### 런타임에서 비어 보이지만 이식 결함이 아닌 것

- 장르 페이지 공연 일정 "공연 0개" — 테스트 Firebase 프로젝트에 `performances` 컬렉션이 **비어 있다**. 빈 상태 UI 는 정상 동작
- 마이페이지 이름 `VYBER` — 테스트 계정에 `nickname` 미배정이라 폴백(정상)

### 막혔던 것

시뮬레이터 텍스트 입력이 iOS 붙여넣기 권한 프롬프트 루프에 걸려 자동 로그인이 안 됐다
(`osascript` 키스트로크는 손쉬운 사용 권한 없음). **사람이 직접 로그인**한 뒤 이어서 확인했다.
다음에도 로그인 단계는 사람 손이 필요하다.

---

## 6. 발견한 문제와 조치

| 문제 | 조치 | 결과 |
|---|---|---|
| `pod install` 크래시 — `Unicode Normalization not appropriate for ASCII-8BIT` | Podfile·Podfile.lock 베타와 동일 확인 → `LANG=en_US.UTF-8` 지정 | **해결**. 원인은 경로의 한글(`업무/소스코드`) |
| `flutter analyze` 크래시 | 같은 한글 경로 원인, 베타도 동일 | **이식 전부터 있음** — `dart analyze` 사용 |
| `pod install` 경고 `base configuration` | Flutter 기본 구성, 빌드 성공 | **이식 전부터 있음** |
| 키 파일 3개 git 추적 중 | `git rm --cached` + `.gitignore` | **해결** (7번 경고) |
| 기준 문서 2개 없음 | Downloads 에서 찾아 배치 | **해결** |
| 디자인 번들 재수신 | Handoff 프롬프트 미전달 | **멈춤** (9번) |

**이식 코드는 한 줄도 고치지 않았다.**

```bash
# iOS 의존성 설치는 반드시 이렇게
cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install
```

---

## 7. ⚠ 키·설정 파일 경고

`lib/firebase_options.dart` · `ios/Runner/GoogleService-Info.plist` · `android/app/google-services.json`
3개를 git 추적에서 제외했다 (`git rm --cached`). **파일은 로컬에 그대로** 있어 빌드 영향 없다.

| 파일 | 로컬 | git 추적 |
|---|---|---|
| `.env` | O | X |
| `functions/.env` | O | X |
| `lib/firebase_options.dart` | O | X (이번에 제외) |
| `ios/Runner/GoogleService-Info.plist` | O | X (이번에 제외) |
| `android/app/google-services.json` | O | X (이번에 제외) |

> **이 3개는 이미 private 레포에 push 된 이력이 있다** (`35515f9`, `42e99b5`).
> 지시대로 원격 이력 정리(force push)는 하지 않았다.
> 레포가 공개로 바뀌거나 외부에 공유되면 **Firebase 키를 재발급하고 콘솔에서 API 키 제한
> (번들 ID · App Check)을 걸어야 한다.** 현재는 private + 테스트 프로젝트라 즉시 위험은 낮다.
>
> 부작용 — 새로 clone 하면 이 세 파일을 따로 받아야 빌드된다.

---

## 8. 커밋 이력

| 커밋 | 내용 |
|---|---|
| `35515f9` | chore: copy beta as v1 baseline (이식 — 이전 세션) |
| `42e99b5` | chore(v1): 테스트 Firebase 프로젝트로 전환 (10파일) |
| `2fd485c` | docs(v1): 기준 문서 배치 — 백엔드 설계서 · 디자인 원본 (116파일, 4.9MB) |
| `ad5c15b` | docs(v1): 사용자 앱 99화면 분류 — screen_map.md · progress.md |
| `9d2a199` | chore: 이식 점검 · UI 개발 준비 |

레포 https://github.com/unknownChoi/vybe_v1 (**private**)

---

## 9. ⛔ UI 개발 진입 판단 — 아직 안 된다

### ① Handoff 프롬프트가 전달되지 않았다

지시문에 "위에 붙여넣은 내용은 Claude Design Handoff 프롬프트" 라고 돼 있으나 실제로는 작업 지시만 왔다.
그래서 **번들을 새로 받아 대조하지 못했다**.

현재 `design/user/` 의 번들은 Export ZIP 2026-10-01판이고, 이식 분류 때 본 것과 **같은 번들**이다
(`/design` 같은 다른 경로는 쓴 적 없음).

**필요** — Handoff 프롬프트를 붙여 주거나, Export 대화상자에서 `Download zip instead` 로 받은 ZIP 을
`design/user/` 에 덮어쓴 뒤 다시 요청. 화면 수 분배 차이(3-7)도 이 대조로 결론난다.

### ② 하단 탭 3번째 자리 — 디자인 원본과 설계 문서가 정면 충돌

CLAUDE.md ⭐ v1 규칙의 「멈추고 보고」 대상이다.

| 근거 | 말하는 것 |
|---|---|
| 디자인 `home.jsx` TabBar | `{ key:'saved', label:'찜', href: PLACE-020 }` → **찜 유지** (검색↔찜 순서만 교체) |
| 설계 6-0 HOME-005 행 | 「하단 바 "찜" → "패스월렛"(클라)」 |
| 설계 6-0 PLACE-019/020 행 | 「찜 탭은 하단 바에서 빠지고 마이에서 진입(클라)」 |
| 디자인 `v1_map.js` 머리말 | 「nav:1 = 하단 내비게이션 찜→패스월렛 적용(v1 수정됨)」 |

패스월렛 9화면 + 그 아래 웨이팅·예약·주문·공유 59화면의 **진입점 전체**가 여기서 갈린다.
`MainScaffold` · HOME-005 · PLACE-020 수정 범위도 이 결정에 달려 있다.

### 막지는 않지만 정해야 하는 것

1. **CLUB-022 공연 일정** — 디자인 안에서 들어갈 길이 없다. 클럽 상세 「오늘의 라인업」 전체보기가
   CLUB-022 가 아니라 HOME-009 를 가리키고, 번들 전체에 CLUB-022 로 가는 href 가 0건(`v1_map.js` 등록만).
   베타 진입점(클럽 상세 공연 섹션) 유지 여부.
2. **CAT-014 금연** — v1 홈 카테고리 8번째 칸이 디자인에선 「라운지」(href 없음)인데 베타는 「금연」 →
   `NonSmokingScreen`. `v1_map.js` 는 CAT-014 를 홈 카테고리 그룹에 등록해 두어 디자인 안에서도 엇갈린다.
3. **베타가 디자인과 일부러 다르게 만든 자리** — 베타 코드에 생략 사유 주석이 남은 항목들
   (스플래시 하단 로딩 라인 없음·미러볼 추가, 전체화면 블러 생략, MY-031 「리뷰 쓰기」→검색 탭 등).
   디자인대로 되돌릴지 베타 판단을 유지할지.
4. **테스트 프로젝트 `performances` 컬렉션**을 채울지 (장르 페이지 공연 일정 확인용).

### 결정이 끝나면 할 일

1. `복사 후 수정` 29화면 UI 작업 (신규보다 먼저 — 공용 위젯·토큰이 여기서 확정된다)
2. H~T 신규 68화면 UI — Fake datasource 구조, Firebase 호출 없음
3. 백엔드 단계 — Emulator 에서 `docs/backend_design.html` 대로 구현 후 datasource 교체
