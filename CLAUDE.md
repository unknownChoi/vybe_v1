# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**vybe** is a Flutter mobile application for discovering nightclubs based on map.

- **Platform:** Android, iOS
- **Language:** Dart (SDK ^3.9.2)
- **Framework:** Flutter (v3.18.0+)
- **Core Features:**
  - Map-based club discovery
  - Club detail pages (info, hours, price, menu)
  - User reviews
  - Search & filtering
- **v1 (2026.10~):** 패스월렛 · 비대면 웨이팅 · 입장비 결제 · 테이블 예약 · 비대면 주문 · 입장권 공유 +
  업주용 관리자 페이지 — 아래 **⭐ v1 개발 규칙** 참고

---

## ⭐ v1 개발 규칙 (2026.10~ · 이 섹션이 최우선)

> 아래 베타 시절 섹션과 충돌하면 **이 섹션이 이긴다.** 단, 베타 섹션의 코드 규칙(MVVM · Firebase는
> `data/datasources/remote/`에만 · screenutil · `Vybe` 공용 위젯 · 손으로 선언하는 provider · 라우팅 구조)은
> v1에서도 **그대로 지킨다.** v1 규칙은 그 위에 얹는 것이다.

### 목표와 진행 단계
v1은 사용자 앱(99화면 · 상태 187)과 업주용 관리자 페이지(32화면 · 상태 176 · 조회 섹션 14)를 만든다.
진행은 반드시 이 순서다.

1. **UI 단계** — 디자인 원본과 똑같이 화면을 만든다. 데이터는 Fake datasource로만 돈다. Firebase 호출 없음.
2. **백엔드 단계** — `docs/backend_design.html` 대로 Firestore · Functions · Rules를 Emulator에서 구현하고,
   Fake datasource를 Firebase datasource로 **교체만** 한다. 화면 · ViewModel 코드는 원칙적으로 안 바꾼다.

### 기준 문서 (추측으로 채우지 말 것)
| 무엇의 기준 | 위치 |
|---|---|
| 화면 · 문구 · 상태 · 흐름 | Claude Design 원본 — Claude Code `/design` 으로 가져오거나 `design/user/` · `design/admin/` 내보내기 파일 |
| 백엔드 전체 (컬렉션 · 필드 · enum · 함수 · Rules · 색인 · 시간 작업 · 비용) | `docs/backend_design.html` (v1 Firebase 백엔드 설계 문서) |
| 화면 ID ↔ 라우트 ↔ 파일 ↔ 구현 상태 | `docs/screen_map.md` |
| 진행 기록 · 결정 기록 · 다음 작업 | `docs/progress.md` |

- **디자인 원본은 `design/user/`(Export ZIP 2026-10-01판)와 `design/user/extracted/` 를 쓴다** (2026-10-03 확정).
  Claude Design 에는 "VYBE 사용자" 프로젝트가 **없다** — `/design` 으로 찾지 말 것.
  `extracted/` 는 `VYBE_v1_prototype.html`·`VYBE_v1_storyboard.html` 안의 `window.__VBF` 번들을 파일 단위로 푼 것이다
  (`[v1]<화면ID>.html` 33 = 베타 섹션 A~G · `new_func_*.jsx` = 신규 H~T · `nf_specs.js` = 신규 68화면 명세).
- 원본을 열 수 없거나 일부만 보이면 **멈추고 보고**한다. 비슷하게 만들어 넣지 않는다.
- 디자인 원본과 설계 문서가 정면으로 충돌하면 **멈추고 보고**한다.

### 화면 ID 규칙
- 사용자 앱: `[기능 코드]-[3자리 번호]` (예: `RSV-047`, `PASS-041`). 상태 변형은 `-1`, `-2` …
- 관리자: `ADM-[기능 코드]-[3자리 번호]` (예: `ADM-WAIT-017`), 조회 섹션은 `ADM-SEC-[번호]`
- 화면 클래스 위에 doc 주석으로 화면 ID를 반드시 남긴다: `/// RSV-047 예약 정보 입력`
- 커밋 메시지에도 화면 ID 또는 설계 문서 장 번호를 넣는다: `feat(RSV-047): …`, `feat(6-I): …`

### UI 단계 — Fake datasource 구조 (v1 신규 기능에만 적용)
베타의 "datasource는 구체 클래스" 방식을 v1 신규 기능에서는 이렇게 바꾼다.

```
data/datasources/<feature>_datasource.dart          # abstract interface class (Firebase import 금지)
data/datasources/remote/firebase_<feature>_datasource.dart  # Firebase 구현 (백엔드 단계)
data/datasources/fake/fake_<feature>_datasource.dart        # Fake 구현 (UI 단계)
```

- 어느 구현을 쓸지는 datasource **provider 한 곳**에서만 고른다. 실행 플래그
  `--dart-define=VYBE_BACKEND=fake|emulator|prod` (기본값 `fake`, v1 백엔드 연결 전까지).
- Repository · ViewModel · 화면은 어떤 구현이 붙었는지 모른다. 교체 시 이 세 레이어를 고치면 설계 실패다.
- Fake 데이터의 모델 · 필드명 · 타입 · 상태 enum은 처음부터 `backend_design.html` **4장 데이터 모델과 같게**
  만든다(freezed). 예시 값은 디자인 원본 프로토타입의 값(매장명 · 날짜 · 금액 · 번호)을 그대로 쓴다.
- Fake는 화면의 **모든 상태 변형**(로딩 · 빈 상태 · 실패 · 만료 · 잠김 · 마감 · 다이얼로그 결과)을 재현할 수 있어야 한다.
  상태를 바꿔 보는 개발용 전환 수단은 `kDebugMode` 에서만 보이게 한다.
- `logFirebaseAccess()` 는 remote datasource 전용이다. Fake에서는 부르지 않는다.
- 베타에서 이미 Firebase에 붙어 있는 기능(클럽 · 리뷰 · 찜 · 검색 · 인증 등)은 Fake로 되돌리지 않는다.

### 서버 확정 원칙 (백엔드 단계, UI 단계에서도 구조를 이렇게 잡아 둘 것)
- 금액 · 결제 결과 · 상태 전이 · 순번 · 시간 구간은 **클라이언트가 확정하지 않는다.** onCall 함수 · 트리거만 정한다.
- 클라이언트가 함수에 보내는 값은 ID와 선택값뿐이다. **금액을 보내지 않는다.**
- 클라 → Firestore 직접 쓰기는 설계 문서 2장 "요청 경로 규칙"의 허용 목록(찜 · 검색 로그 · 리뷰 · 문의 ·
  프로필(베타 범위) · 알림 읽음 · 사용자 측 숨김)만. 웨이팅 · 예약 · 주문 · 결제 · 환불 · 공유 · 관리자 운영 데이터는 전부 함수 전용.

### 구현하지 않는 것 (외부 API)
- 결제(PG), 회원가입 · 본인인증 신규 연동, 알림톡 · SMS, 계좌 실명 확인 등 **외부 API는 v1 작업에서 구현하지 않는다.**
  인터페이스와 스텁만 두고 `// TODO[외부API] 설계 7장 · [임시]` 주석을 남긴다. 스텁은 성공 · 실패를 고를 수 있게 한다.
- 베타의 기존 회원가입 · 본인인증(PortOne) · Algolia 검색 코드는 **건드리지도, 확장하지도 않는다.**
- 설계 문서에서 `[임시]` 로 표시된 항목은 모두 이 규칙을 따른다.

### 백엔드 단계 규칙
- 모든 작업은 **Firebase Emulator Suite** 에서 먼저 한다. 사용자가 명시하기 전에는 `firebase deploy` 를 실행하지 않는다.
- 컬렉션 · 필드 · enum · 함수 이름 · 입출력 · 에러 코드 · Rules · 색인 · Cloud Tasks 큐 · Scheduler 잡은 설계 문서 그대로.
  설계와 다르게 해야 하면 구현하지 말고 보고한다.
- Functions: 2nd gen · Node.js 20 · TypeScript · 리전 `asia-northeast3`(설계 14장). 베타 함수의 리전 · 구조가 다르면
  **옮기지 말고 보고**한다(설계 17장 ③ `[베타 버전 수정]` 항목과 대조).
- 테스트(설계 16장): Rules는 `@firebase/rules-unit-testing` 으로 역할별(사용자 · 타인 · staff · manager · owner · admin) 매트릭스,
  금액 · 구간 계산은 순수 함수 + 7장 예시값 테이블 테스트, 상태 전이는 잘못된 전이 케이스 포함,
  Cloud Tasks 핸들러는 HTTP 직접 호출 테스트.
- 관리자 동작 ↔ 사용자 화면 상태 변경(설계 12장 연결표)은 두 앱을 함께 띄워 확인한다.

### 설계 문서의 표시 문구를 코드에 남기는 법
- `[임시]` · `[임시_차선책]` · `[베타 버전 수정]` 항목을 구현한 곳에는 주석으로 표시와 설계 문서 위치를 남긴다.
  예: `// [임시_차선책] 설계 8장 영업일(businessDate) 규칙`
- 설계 문서에 없는데 코드에서 정해야 하는 것이 생기면 권장안으로 진행하고 `docs/progress.md` 결정 기록에 남긴다.

### 관리자 페이지 (업주용 SPA)
- 위치: `admin/` (v1 신규). 스택: [관리자 웹 스택 — 권장: React + Vite + TypeScript]
- 라우트 · 메뉴 · 역할 제한은 설계 12장 "관리자 셸 · 라우트 · 권한" 그대로. 공통 사이드 탭 1개 · SPA(새로고침 없이 내용만 교체) ·
  모든 상태 변경에 확인 다이얼로그. 데이터 계층은 앱과 같은 원칙(화면은 Firebase 직접 호출 금지, Fake ↔ Firebase 교체).
- 기존 테이블 배치 편집기는 **별도 레포 `소스코드/vybe-partner/`** 에 있다(이 레포엔 `partner/` 가 없다).
  관리자 `CLUB-011 앱 콘텐츠 › 테이블`로 옮겨지기 전까지 그 레포를 **삭제하지 않는다.**

### 확정 정책 (바꾸지 않음)
로그인 필수 · 친구 추가 없음 · 용어는 "공제"가 아니라 "패널티"(비율 표시, 합계 · 환불은 금액) ·
공유받은 사람 개인정보 비노출 · 입장 완료 티켓은 영업 종료 시 자동 삭제(사용자 삭제 없음) ·
Firebase Dynamic Links 사용 금지 · 관리자 화면의 예약자 이름 · 전화번호는 마스킹 없이 표시

### 작업 습관
- 세션 시작: `docs/progress.md` 를 먼저 읽고, 끝난 작업은 반복하지 않는다. 시작할 때 "완료된 작업 / 이어서 할 작업"을 한 줄로 적는다.
- 작업 단위(섹션 · 기능)마다 `docs/screen_map.md` 상태 갱신 → `docs/progress.md` 기록 → 커밋.
- 요청 범위 밖의 화면 · 기능 · 문구는 바꾸지 않는다. 화면에 없는 기능을 만들지 않는다.
- 애매하면 멈추지 말고 권장안으로 진행하고 결정 기록에 남긴다(멈추는 경우는 위 "기준 문서"의 두 경우뿐).

### 이 레포의 환경 규칙 (2026-10-03 확정)
- **정적 분석은 `dart analyze`** 를 쓴다. `flutter analyze` 는 프로젝트 경로에 한글(`업무/소스코드`)이 있어 LSP FormatException 으로 크래시한다.
- **iOS 의존성 설치는 로케일을 지정한다** — 같은 한글 경로 때문에 CocoaPods 가 `Encoding::CompatibilityError` 로 죽는다.
  ```bash
  cd ios && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install
  ```
- **시뮬레이터 기기** (iOS 18 런타임 · 새 런타임을 받지 않는다)
  | 쓰임 | 기기 | UDID |
  |---|---|---|
  | 기준(393×852) | `iPhone 15 (v1 기준)` | `7FD974D0-3182-4005-8B0F-D527FF30895A` |
  | 작은 화면(375×667) | `iPhone SE (3rd generation)` | `1FC88502-D84E-4AE5-96C6-21F76663C57C` |
  | 넓은 화면(기존 로그인 상태) | `iPhone 16 Pro Max` | `7B2DE53C-1BF6-4A74-80EB-11AE4244CBDA` |
- **시뮬레이터 로그인은 사람이 한다.** 시뮬레이터 텍스트 입력이 iOS 붙여넣기 권한 프롬프트에 막혀 자동 입력이 안 된다.
  로그인 상태를 유지하고 **작업 중 로그아웃하지 않는다.** 로그인이 필요해지면 **멈추고 사용자에게 요청**한다.
- **키 파일 3개는 git 추적 제외** — `lib/firebase_options.dart` · `ios/Runner/GoogleService-Info.plist` ·
  `android/app/google-services.json`. 파일은 로컬에 있고 `.gitignore` 에 들어 있다.
  **새로 clone 하면 이 셋을 따로 넣어야 빌드된다.** (`.env` · `functions/.env` 도 전부터 추적 제외)

---

## Architecture

This project follows **MVVM (Model-View-ViewModel)** pattern with **Riverpod** for state management.

```
View (Widget) → ViewModel (Notifier) → Repository → DataSource (Firebase)
```

- **View:** UI only, no business logic
- **ViewModel:** `AsyncNotifier` / `Notifier` via Riverpod, handles state & logic
- **Repository:** Abstracts data source, returns domain models
- **DataSource:** Firebase (Firestore, Auth, Storage) calls

---

## Folder Structure

```
├── lib/
│   ├── design_system/   # 색상, 타이포그래피 (spacing.dart 는 참조 0이라 삭제 — 2026.09.06)
│   ├── core/
│   │   ├── constants/   # app_geo.dart (폴백 좌표 · 상권 좌표 · 지역 판정)
│   │   │                #   korea_regions.dart (전국 시군구 252개 중심 좌표표 — 구 있는 시는 구 단위)
│   │   ├── providers/   # 전역 Riverpod providers (auth_providers, location_providers 등)
│   │   ├── theme/       # 앱 테마
│   │   └── utils/       # 유틸리티 — firebase_logger · date_format(fmtDateDot/fmtHhmm) ·
│   │                    #   gradient_palette(kClubFallbackGradients/clubGradientFor — 클럽 폴백
│   │                    #   그라데이션 단일 소스) · geohash_utils(haversineKm 만 남음, 2026.09.15)
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── <feature>_datasource.dart  # [v1] 신규 기능 datasource 인터페이스 (Firebase import 금지)
│   │   │   ├── fake/    # [v1] Fake datasource (UI 단계 · --dart-define=VYBE_BACKEND=fake)
│   │   │   ├── local/   # 기기 SDK 전담 datasource
│   │   │   │   ├── device_location_datasource.dart  # geolocator (GPS 코드는 여기에만)
│   │   │   │   └── device_network_datasource.dart   # connectivity_plus · app_settings
│   │   │   │                                        #   (연결 확인·설정 열기는 여기에만)
│   │   │   └── remote/  # Firebase 전담 datasource (Firebase 코드는 여기에만)
│   │   │       ├── firebase_auth_datasource.dart
│   │   │       ├── firebase_user_datasource.dart
│   │   │       ├── firebase_storage_datasource.dart
│   │   │       ├── firebase_club_datasource.dart
│   │   │       ├── firebase_search_history_datasource.dart
│   │   │       ├── firebase_review_datasource.dart
│   │   │       ├── firebase_favorite_datasource.dart
│   │   │       ├── firebase_banner_datasource.dart
│   │   │       ├── firebase_notice_datasource.dart
│   │   │       └── firebase_app_config_datasource.dart
│   │   ├── models/      # Freezed 모델 (user, club, club_info, menu, photo, review,
│   │   │                #   favorite, banner, notice, search_history, operating_hours,
│   │   │                #   app_version_config)
│   │   └── repositories/# repository provider (*_repository_impl.dart)
│   │                    #   ⚠ 이름과 달리 절반은 인터페이스 구현체가 아니다 (2026.09.06) —
│   │                    #   가공 없는 5개(banner·app_config·notice·performance·search_trend)는
│   │                    #   provider 가 datasource 를 그대로 노출한다
│   ├── domain/
│   │   └── repositories/    # repository 인터페이스 (Firebase 의존 금지) — **4개만 남음**
│   │                        #   club·favorite·search_history·user.
│   │                        #   테스트가 가짜 구현을 만들어 구현이 2개인 것들이다
│   ├── presentation/
│   │   ├── common/          # 화면 공용 — widgets/(Vybe prefix) + location_flip_mixin.dart
│   │   │                    #   + network_gate/ (네트워크 게이트 — VersionGate보다 위)
│   │                    #   + version_gate/ (버전 게이트 — AuthGate보다 위)
│   │   │                    #   + renew/ (리뉴얼 디자인 토큰·글래스 프리미티브 — Renew prefix)
│   │   │                    #   2026.09.15 공용 승격 — VybeEmptyCard · VybeStateMessage · VybePushHeader ·
│   │   │                    #   VybeClubThumb · VybePosterSliverGrid(+Skeleton) · vybeNetworkImage(vybe_skeleton).
│   │   │                    #   반대로 화면 하나만 쓰던 것은 그 화면으로 내렸다 — content_image → my_page/widgets,
│   │   │                    #   club_poster_grid → kpop/widgets, text_field·page_title → auth/widgets
│   │   │                    #   (common = 두 화면 이상). 서비스 음료로 내렸던 club_list_sorting·chip_filter_bar·
│   │   │                    #   location_sort_bar·accent_dropdown·footer_note 는 2026.09.22 리뉴얼로 삭제.
│   │   │                    #   2026.09.22 승격 — VybeChipPosterGrid(칩 단일 선택 + 가까운 순 포스터 격자,
│   │   │                    #   금연·서비스 음료) · VybePosterBadge(포스터 카드 하단 액센트 뱃지)
│   │   ├── main_scaffold/   # 루트 IndexedStack + 하단 탭바
│   │   ├── home/            # 홈 (widgets/, viewmodels/)
│   │   ├── nearby/          # 내 주변 (지도 기반, widgets/)
│   │   ├── saved/           # 찜 (favorites, saved_common.dart, widgets/, viewmodels/)
│   │   ├── search/          # 검색 (widgets/, viewmodels/)
│   │   ├── clubs/           # 클럽 상세 (tabs/, widgets/, viewmodels/)
│   │   │                    #   테이블 배치도는 widgets/table_*.dart (그리드 셀 좌표)
│   │   ├── hip_hop/         # 장르 페이지 + 오늘의 라인업 (widgets/, *_models.dart)
│   │   ├── kpop/            # K-POP 장르 페이지 — 히어로 + 공용 지도 섹션 + 전용 다중 필터 그리드
│   │   │                    #   (widgets/vybe_club_poster_grid — 공용 VybePosterSliverGrid 위에 K-POP 필터 칩을
│   │   │                    #   얹은 것. K-POP 만 써서 여기로 내림 2026.09.15)
│   │   ├── non_smoking/     # 금연 클럽 페이지 (2026.09.15, smoke_free.html) — 데이터는 isNonSmoking
│   │   │                    #   지도 섹션은 공용 vybe_club_map_section(title·subject·accent 파라미터),
│   │   │                    #   그리드는 전용 widgets/non_smoking_genre_grid (장르 칩 단일 선택 —
│   │   │                    #   K-POP 의 다중 필터 그리드와 다르다). 상수·장르 목록은 non_smoking_models
│   │   │                    #   표시 모델·매퍼는 common/club_page_models, 카드는 vybe_club_poster_card,
│   │   │                    #   2열 격자·스켈레톤은 vybe_poster_sliver_grid(sliver — CustomScrollView 안)
│   │   ├── hot_places/      # 핫플레이스 (더미 데이터, widgets/)
│   │   ├── recommend/       # VYBE 추천 (widgets/, recommend_models.dart)
│   │   ├── free_entry/      # 입장비 무료 (2026.09.15 리뉴얼 — 인트로 + 가로 레일 3섹션, widgets/)
│   │   ├── service_drinks/  # 서비스 음료 (2026.09.22 `service_drinks_renew.html` 리뉴얼 — 이미지 히어로 +
│   │   │                    #   공용 지도 섹션 + 음료 종류 칩 격자(공용 VybeChipPosterGrid). 화면 파일 하나 +
│   │   │                    #   service_drinks_models(상수·serviceDrinkTypesOf) + viewmodels/ — widgets/ 없음)
│   │   ├── my_page/         # 마이페이지
│   │   ├── support/         # 고객센터 문의 (목록·작성·상세, widgets/, viewmodels/)
│   │   ├── profile/         # 프로필
│   │   └── auth/            # 인증 플로우
│   └── main.dart
│
├── functions/           # Cloud Functions (TypeScript, src/auth · account · favorites · reviews)
│                        #   v1 함수는 docs/backend_design.html 함수 카탈로그 기준으로 추가
├── admin/               # [v1] 업주용 관리자 페이지 SPA (설계 12장 라우트 · 공통 사이드 탭)
├── docs/                # [v1] backend_design.html · screen_map.md · progress.md
├── design/              # [v1] Claude Design 내보내기 (user/ · admin/) — /design 을 쓰면 없어도 됨
│                        #   ⚠ partner/ 는 이 레포에 없다 — 업주용 웹(테이블 배치 편집기)은
│                        #     **별도 레포 `소스코드/vybe-partner/`** 에 있다 (2026-10-03 확인)
├── scripts/             # Firestore/Storage seed·migration 스크립트 (Node.js)
│
└── assets/
    ├── images/          # 로고 등 이미지
    ├── icons/
    │   ├── common/      # 범용 아이콘
    │   └── social/      # 소셜 로그인 아이콘
    └── fonts/
```

### 화면 파일 구성 규칙

| 두는 곳 | 무엇을 |
|---------|--------|
| `<feature>/<name>_screen.dart` | 화면 조립 + 상태(State/ViewModel 연결)만 |
| `<feature>/widgets/` | 그 화면 전용 하위 위젯 |
| `<feature>/<feature>_models.dart` | 표시 전용 모델 + `ClubModel` → 카드 모델 매퍼 |
| `<feature>/<feature>_style.dart` | 화면 전용 색·상수 |
| `presentation/common/widgets/` | **두 화면 이상**이 쓰는 위젯 (`Vybe` prefix) |

- 화면 파일이 **300줄을 넘으면 분리 신호**. 위젯을 `widgets/`로 빼고 화면엔 조립만 남긴다.
- 같은 위젯을 두 번째 화면에서 복붙하게 되면 그때 `common/widgets/`로 승격한다
  (색·크기가 화면마다 다르면 파라미터로 받되, 기본값은 원래 화면 값 유지).
- 긴 목록은 `ListView(children: [...])`가 아니라 `SliverList.builder` — 전부 즉시 빌드하지 않는다.
- `MediaQuery.of(context).padding` 대신 `MediaQuery.paddingOf(context)` (구독 범위 축소).

---

## Tech Stack

| 역할 | 패키지 |
|------|--------|
| 상태관리 | `flutter_riverpod` ^3.0 |
| 백엔드 | Firebase (Firestore, Auth, Storage, Functions) |
| 지도 | `flutter_naver_map`. **geohash 범위 쿼리는 2026.09.15 제거** — `GeohashUtils` 엔 `haversineKm` 만 남았고 주변 클럽은 세션 카탈로그 캐시를 메모리에서 거른다(아래 '클럽 카탈로그 캐시') |
| 라우팅 | **별도 라우터 패키지 없음** — `MainScaffold`(IndexedStack 5탭) + 탭 내부 `Navigator`. push 는 `SwipeBackPageRoute` |
| 코드 생성 | `freezed` ^3.0 **전용** (riverpod 코드 생성은 2026.09.06 제거) |
| 아이콘/벡터 | `flutter_svg` |
| 미디어 | `video_player`, `image_picker`(리뷰·문의 사진 첨부, 프로필 사진) |
| 이미지 캐시 | `cached_network_image`(디스크 캐시 + `vybeNetworkImage` 디코드 상한) · `flutter_cache_manager`(설정 '캐시 삭제' 가 `DefaultCacheManager().emptyCache()` 호출) — 2026.09.15 추가 |
| UI 보조 | `flutter_staggered_grid_view`(갤러리) |
| 반응형 | `flutter_screenutil` |
| 네이버 로그인 | `flutter_naver_login` |
| 카카오 로그인 | `kakao_flutter_sdk_user` |
| 검색엔진 | `algoliasearch` (Algolia — Firebase Extension으로 clubs 자동 동기화) |
| 환경변수 관리 | `flutter_dotenv` (Flutter) / `dotenv` (Cloud Functions) |
| 앱 버전 조회 | `package_info_plus` (버전 게이트 · 설정 화면 버전 표기) |
| 기기 위치 | `geolocator` (앱 첫 로딩 GPS 조회 + 위치 권한 요청) |
| 네트워크 확인 | `connectivity_plus` (앱 첫 로딩 연결 확인 + 연결 변화 구독) |
| 설정 앱 열기 | `app_settings` **^5.x 고정** (8.x는 SPM 전용 — 이 프로젝트는 CocoaPods) |

> ⚠️ `go_router` / `google_maps_flutter` / `json_serializable` 미사용. 화면 전환은
> 하단 탭(`MainScaffold`) + 탭별 `Navigator.push`. 지도는 네이버 지도.
>
> ⚠️ **드래그 백은 화면 왼쪽 끝(약 20px)에서만 먹는다 (2026.09.06)** — 예전
> `SwipeBackPageRoute` 는 프레임워크 제스처 로직을 복사해 화면 전체 폭으로 넓힌
> 200줄짜리 자체 구현이었다. 지금은 `CupertinoPageRoute` 의 typedef 라 기본 동작만 쓴다.
> 전체 폭 드래그가 다시 필요하면 `core/navigation/swipe_back_page_route.dart` 를
> git 이전 버전으로 되돌리면 된다(그 파일 하나면 끝, 호출부 37곳은 그대로).
>
> ⚠️ **2026.09.06 제거된 패키지** — `riverpod_annotation` · `riverpod_generator`(아래 State
> Management 참고) · `geoflutterfire_plus`(import 0건 — geohash 는 2026.09.15 에 범위 쿼리째 걷어냈다) ·
> `cupertino_icons`(`CupertinoIcons` 참조 0건) · `flutter_spinkit`.
> `flutter_spinkit` 을 빼면서 **`VybeSpinner` 모양이 바뀌었다** — 파도 막대 + 보라↔라임 색
> 펄스에서 기본 `CircularProgressIndicator`(보라)로. **이제 버튼 안 스피너·제출 오버레이에만
> 남았다** (2026.09.15 — 데이터 로딩 분기는 전부 스켈레톤, Design System Rules 참고).

---

## Commands

```bash
# 앱 실행
flutter run

# 테스트
flutter test

# 코드 분석 (경고 0 유지 — analysis_options.yaml에 const·정렬 린트 추가돼 있음)
flutter analyze

# 린트 자동 수정 (const 누락, import 정렬, 미사용 import 등)
dart fix --apply lib

# 코드 생성 (Freezed 전용 — riverpod 생성은 없다)
flutter pub run build_runner build --delete-conflicting-outputs

# 코드 생성 (watch 모드)
flutter pub run build_runner watch --delete-conflicting-outputs

# 빌드
flutter build apk      # Android
flutter build ios      # iOS

# Cloud Functions 배포
firebase deploy --only functions
firebase deploy --only functions:naverLogin  # 특정 함수만

# 규칙·인덱스 배포
firebase deploy --only firestore:rules,firestore:indexes,storage

# ── v1 ──
# 앱 실행 — 데이터 소스 선택 (기본 fake)
flutter run --dart-define=VYBE_BACKEND=fake       # UI 단계
flutter run --dart-define=VYBE_BACKEND=emulator   # 백엔드 단계 (Emulator 연결)

# Firebase Emulator (백엔드 단계 — 배포 전 모든 작업은 여기서)
firebase emulators:start --only auth,firestore,functions,storage

# Rules 테스트 / Functions 테스트
cd functions && npm test

# 관리자 페이지
cd admin && npm run dev

```

> ⚠ `firebase deploy --only hosting` 은 로컬 `legal/` 폴더를 `vybe-bata-c07aa.web.app` 에 올린다.
> **그 사이트는 여태 한 번도 배포된 적이 없다**(2026.09.06 확인 — 404. 실제 법적 고지는 외부
> 호스트 `vybe.inertent.com`). 즉 이 명령은 '갱신'이 아니라 **첫 공개**가 된다.

---

## 환경변수 / 키 관리 (dotenv)

API 키는 `.env` 파일로 관리하며 절대 git에 커밋하지 않는다.

### Flutter (`flutter_dotenv`)
파일 위치: 프로젝트 루트 `.env`

```
# .env (git 제외)
KAKAO_NATIVE_APP_KEY=your_key_here     # main.dart: KakaoSdk.init
NAVER_MAP_CLIENT_ID=your_id_here       # main.dart: 네이버 지도 초기화 (FlutterNaverMap)
ALGOLIA_APP_ID=your_id_here            # algolia_club_search_datasource: 클럽 검색
ALGOLIA_SEARCH_API_KEY=your_key_here   # 반드시 Search-Only 키 (Admin/Write 키 금지)
```

> main.dart 초기화 순서: `dotenv.load` → `Firebase.initializeApp` → `KakaoSdk.init` → 네이버 지도(`NAVER_MAP_CLIENT_ID`).
> ⚠ 네이버 **로그인** clientId/clientSecret 은 dotenv 가 아니라 **네이티브 설정**에 있다 —
> `android/app/src/main/AndroidManifest.xml` 의 `com.naver.sdk.*` 메타데이터와 `ios/Runner/Info.plist`.
> 서버(Cloud Functions)는 클라가 넘긴 accessToken 만 검증하므로 이 값들이 필요 없다.

사용법:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// main.dart에서 초기화
await dotenv.load(fileName: '.env');

// 어디서나 접근
final kakaoKey = dotenv.env['KAKAO_NATIVE_APP_KEY']!;
```

### Cloud Functions (`dotenv`)
파일 위치: `functions/.env` (템플릿 `functions/.env.example` 은 커밋)

```
# functions/.env (git 제외) — 서버가 실제로 읽는 키는 이 둘뿐이다
PORTONE_IMP_KEY=your_key_here        # verifyIdentity — 포트원 토큰 발급
PORTONE_IMP_SECRET=your_secret_here  # verifyIdentity — 포트원 토큰 발급
```

> ⚠ **현재 배포본에 이 키가 안 실려 있다 (2026.08.20 확인)** — `verifyIdentity` 의 런타임
> 환경변수에 `PORTONE_*` 가 없어 호출하면 `internal`("포트원 API 키가 설정되지 않았습니다")로
> 실패한다. 앱이 아직 이 함수를 부르지 않아 드러나지 않았을 뿐(문자 인증이 `'123456'` 하드코딩).
> 값을 채운 뒤 `firebase deploy --only functions:verifyIdentity` 로 반영할 것.
>
> `firebase deploy` 는 `functions/.env` 를 읽어 **런타임 환경변수로 올린다** — 파일이 없으면
> 조용히 없는 채로 배포된다(경고 없음). 로그인 3종은 서버 시크릿을 안 써서 영향 없다.

## 클럽 검색 (Algolia)

검색은 **Algolia 단일 경로**. (구 Firestore searchTokens 검색은 폐기 —
onClubWritten 트리거·searchTokens 필드·전용 인덱스 전부 삭제됨. 2026.07.19)

```
clubs 쓰기 → Firebase Extension(firestore-algolia-search) → Algolia `clubs` 인덱스 자동 동기화
앱 검색   → algolia_club_search_datasource (Search-Only 키) → 관련도순 hit 페이지
          → hit를 ClubModel.fromSearchHit로 직접 매핑 (Firestore read 0)
상세 진입 → clubId로 getClub 1건만 조회
```

- Extension 설정: Collection Path `clubs`, Index `clubs`, objectID = doc.id(= clubId),
  Indexable Fields (**18개 — 이 목록이 정본**):
  ```
  name,area,genre,tags,address,rating,reviewCount,thumbnailUrl,entryFeeMin,entryFeeMax,operatingHours,isActive,isVybeRecommended,isNonSmoking,favoriteCount,location,freeEntry,isFreeEntry
  ```
  ⚠ **배포본은 아직 19개** (2026.09.01 실측 — 위 18개 + 삭제된 `genreStyles`). 앱
  `_requiredFields`에 없어 동작엔 영향 없고(인덱스에 죽은 속성이 실릴 뿐), 다음 설정 변경 때
  같이 뺀다 — 재구성은 전체 재색인을 동반하고 `searchableAttributes` 생존 확인이 필요하다.
  ⚠ **배포된 설정이 문서와 달라져 있던 적이 있다 (2026.08.21 발견)** — 배포본 `FIELDS`에
  `reviewCount`·`entryFeeMax`·`operatingHours`·`isVybeRecommended`·`isNonSmoking`·`location`
  6개가 빠져 있었고(= 2026.07.31 '조인 제거' 설정이 실제로는 반영된 적이 없음), 그동안 검색은
  내내 `complete=false` → `getClub` 조인 폴백으로 돌고 있었다. **화면이 멀쩡해서 티가 안 난다**
  — 조용히 read 비용만 낸다. 설정을 만졌으면 반드시 실물로 확인할 것:
  ```bash
  TOKEN=$(gcloud auth print-access-token)
  curl -s -H "Authorization: Bearer $TOKEN" \
    "https://firebaseextensions.googleapis.com/v1beta/projects/vybe-bata-c07aa/instances/firestore-algolia-search" \
    | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['state']); print(d['config']['params']['FIELDS'])"
  # 그 다음 hit에 실제로 실려 오는지 (앱과 같은 Search-Only 키)
  curl -s -X POST "https://$ALGOLIA_APP_ID-dsn.algolia.net/1/indexes/clubs/query" \
    -H "X-Algolia-API-Key: $ALGOLIA_SEARCH_API_KEY" -H "X-Algolia-Application-Id: $ALGOLIA_APP_ID" \
    -d '{"query":"","hitsPerPage":1}' | python3 -c "import json,sys; print(sorted(json.load(sys.stdin)['hits'][0].keys()))"
  ```
- **Firestore 조인 제거 (2026.07.31 설계 · 2026.08.21 현재 미가동)** — 목록 카드·필터·정렬·지도 핀에 필요한 필드를
  전부 인덱싱해 검색 시 Firestore 문서 read가 0이 됨. 필요 필드 목록은
  `AlgoliaClubSearchDataSource._requiredFields` (단일 소스).
  hit에 하나라도 빠지면 `complete=false` → 예전 `getClub` 조인으로 자동 폴백(화면 안 깨짐).
  ⚠ Indexable Fields를 바꾸면 기존 문서는 자동 반영 안 됨 → `node scripts/reindex_clubs.js`로
  전체 touch 필요. `_requiredFields`에 필드를 추가할 때도 Extension 설정 + 재색인 동반 필수.
- **Searchable Attributes (Algolia 인덱스 설정 — Extension 설정과 별개)**:
  ```
  unordered(name), unordered(tags), unordered(genre), unordered(freeEntry.condition)
  ```
  순서 = 우선순위. `freeEntry.condition`은 **맨 뒤**라 이름 매치를 밀어내지 않는다.
  ⚠ **인덱싱된 필드 ≠ 검색되는 필드다** — Extension의 Indexable Fields는 "인덱스에 실어 보낼
  필드", searchableAttributes는 "그중 검색어로 찾을 필드". 여기 없으면 값이 실려 있어도 0건이다.
  - `freeEntry.condition` 추가 (2026.08.21) — 검색창에 **`무료`를 치면 무료입장 클럽 119곳**이
    뜨게 하려고. 조건 문구 80종이 전부 '무료'를 포함한다(always 71 + timed 48, `none` 45곳만 빈 값).
    ⚠ **`입장료`로는 안 걸린다** — 문구가 전부 '입장 무료'·'무료입장'이라 '입장료'라는 단어가
    데이터에 없다(필터 칩 라벨은 '입장료 무료'라 헷갈릴 수 있음).
    부수 효과로 `여성`(8곳)·`오픈런`(6곳) 같은 조건 단어로도 찾아진다 — 의도한 것.
  - 한국어는 **부분 일치**가 된다(실측: `테이션` → `클럽 스테이션`). 접두사만이 아니라 중간·끝
    조각도 잡히므로 `무료`가 `무료입장`·`무료`를 모두 건진다.
  - ⚠ **이 설정은 리포에 없다** — Algolia 대시보드(또는 Settings API)에만 산다. Extension을
    재구성한 뒤에는 살아남았는지 확인할 것:
    `GET https://{APP_ID}-dsn.algolia.net/1/indexes/clubs/settings`
- ⚠ **Extension 업데이트는 전체 재색인을 동반한다** (`DO_FULL_INDEXING=true`) — 2026.08.21
  설정 변경 후 ACTIVE로 바뀌자 164개가 자동으로 다시 색인됐다. 즉 Indexable Fields만 고치면
  `scripts/reindex_clubs.js`를 따로 돌릴 필요가 없다(수동 touch는 설정을 안 건드리고 다시 밀
  때만 쓴다). 반영은 상태가 DEPLOYING → ACTIVE로 바뀐 뒤 1~2분.
- **한글 조합 중 자모 (2026.08.24)** — 엔진은 **완성형 음절만** 인덱싱한다. 타이핑 중
  마지막 글자로 남는 단독 자모(`ㅇ` U+3147)를 그대로 던지면 AND 매칭이 결과를 통째로
  0건으로 만든다 — 실측 `홍대` 57건 · `홍대 어` 4건 → **`홍대 ㅇ` 0건**
  (`removeWordsIfNoResults: 'none'` 이라 안 지워진다).
  → `searchClubsPage`가 검색어를 **엔진에 던질 부분 / 초성으로 거를 자모**로 쪼갠다
  (`core/utils/hangul_search.dart` — 순수 함수, `test/hangul_search_test.dart` 15건).
  - 자모가 있으면 후보를 `pageSize * 8`(상한 80)만큼 받아 **이름 초성**으로 거르고,
    초성이 앞쪽에서 걸린 곳을 먼저 정렬한다('홍대 ㅇ' → 어썸레드가 '홍대 클럽 나인'보다 위)
  - 쌍자음은 홑자음으로 눕힌다(`ㅅ`로도 '썸'이 걸린다). 초성이 못 되는 모음·겹받침 자모는 버린다
  - ⚠ **처리 위치는 `searchClubsPage` 한 곳** — 검색 3경로(연관 검색어 · 검색 결과 ·
    주변 지도 `NearbySearchResultNotifier`)가 전부 여기를 지난다. 화면마다 따로 손대면
    같은 검색어가 화면마다 다르게 걸린다
  - ⚠ 자모를 걸렀을 땐 `totalCount`에 엔진 `nbHits`(거르기 전 수)를 쓰지 않는다 —
    화면 '검색결과 N'이 목록보다 큰 숫자를 말하게 된다
- 진입점은 `ClubRepositoryImpl.searchClubsPage` 하나 — viewmodel/화면은 엔진 무관.
  cursor = Algolia 페이지 번호(int, 0부터).
- 결과 개수는 `ClubSearchPage.totalCount`(= Algolia `nbHits`, 검색어 전체 매칭 수).
  응답에 이미 실려와 추가 비용 0. 검색 결과 화면 메타 행은 필터 없을 때 이 값을 쓰고,
  필터가 걸리면 서버가 필터를 모르므로 로드된 것 중 통과 개수로 대체한다.
- 비활성 클럽 제외는 hit의 `isActive` 값으로 처리(폴백 경로에선 조인 후 확인).
  (Algolia `filters`는 attributesForFaceting 미선언 속성이면 조용히 0건 — 사용 금지)
- ⚠ .env에 ALGOLIA 키 없으면 검색 결과 빈 값 (fallback 없음 — 키 필수).
- ⚠ 키 규칙: 앱에는 **Search-Only 키만**. Admin/Write 키는 Extension(서버)에서만 사용.

### 클럽 카탈로그 캐시 (2026.09.15)

목록 화면이 화면마다 따로 쿼리를 날려 한 세션에 `clubs` read 가 **500~700** 이었다.
지금은 `ClubRepositoryImpl` 이 `clubs(isActive==true)` **164건을 세션당 한 번** 읽어 들고 있는다.

- `clubRepositoryProvider` 는 **keepAlive** — 화면을 옮겨도 캐시가 산다. TTL 10분
  (`ClubRepositoryImpl.catalogTtl`) 지나면 다음 목록 호출이 다시 읽는다. `Future` 를 들고 있어
  동시 진입(홈 두 섹션 + 주변 탭)도 1회, 실패한 Future 는 즉시 버린다(TTL 동안 전부 죽지 않게)
- `getClubsNearby`(haversine · 가까운 순 정렬) · `ByArea` · `ByGenre` · `FreeEntry` ·
  `TimedFreeEntry` · `NonSmoking` · `ServiceDrink` 는 전부 **메모리 필터** —
  `firebase_club_datasource` 의 목록 쿼리들은 삭제됐다(`getActiveClubs`·`getClub`·`getClubsByIds`·
  info·menus·photos·tableLayout 만 남음)
- `getClub` 은 **여전히 새로 읽는다**(상세 화면). 조인용은 `getClubCached` — 찜 탭·내 리뷰가
  카탈로그에서 꺼내고, 없는 id(비활성·신규)만 `getClub` 로 떨어진다
- ⚠ **당겨서 새로고침 훅은 없다** — 10분 TTL 이 유일한 갱신. 필요해지면 `_catalog = null`
  한 줄(구 `invalidateCatalog`, 호출부 0이라 삭제)을 되살려 RefreshIndicator 에 물린다
- ⚠ `clubs.location.geohash` 필드는 남아 있지만 **앱은 더 이상 안 읽는다** — 반경 판정은 haversine

### .gitignore 규칙
- `.env` — Flutter 키
- `functions/.env` — Cloud Functions 키
- `.env.example` · `functions/.env.example` 은 커밋 (실제 값 없이 키 이름만 포함)

---

## State Management

Riverpod 3.x 기반, `AsyncNotifier` / `Notifier` 패턴 사용.
**코드 생성을 쓰지 않는다** — provider 를 손으로 선언한다 (2026.09.06, `.g.dart` 45개 삭제).

- 단순 값: `Provider` / `FutureProvider` / `StreamProvider`
- 인자 있는 provider: `.family<반환형, 인자형>`
- 상태 클래스: `class X extends Notifier<T>` (동기) 또는 `AsyncNotifier<T>` (비동기)
- **`@riverpod` / `part '*.g.dart'` 를 새로 쓰지 말 것** — 생성기가 빠져 있어 빌드가 깨진다
- UI는 `ConsumerWidget` 또는 `ConsumerStatefulWidget` 사용

```dart
// 함수형 — @riverpod 이면 .autoDispose, @Riverpod(keepAlive: true) 이면 그냥
final noticesProvider = FutureProvider.autoDispose<List<NoticeModel>>(_notices);

Future<List<NoticeModel>> _notices(Ref ref) =>
    ref.watch(noticeRepositoryProvider).getNotices();

// 인자 있는 것 (구 family)
final clubDetailProvider =
    FutureProvider.autoDispose.family<ClubModel?, String>(_clubDetail);

// 상태 클래스
final nearbyViewModelProvider =
    AsyncNotifierProvider.autoDispose<NearbyViewModel, List<ClubModel>>(NearbyViewModel.new);

class NearbyViewModel extends AsyncNotifier<List<ClubModel>> { ... }
```

⚠ **provider 이름은 예전 생성기 규칙을 그대로 따른다** — 호출부를 안 바꾸기 위해서다.
클래스명 끝의 `Notifier` 는 뗀다 (`UserLocationNotifier` → `userLocationProvider`).

⚠ **테스트에서 Notifier provider 를 갈아 끼울 땐 값이 아니라 notifier 를 넘긴다** —
`overrideWithValue(값)` 은 없다. `overrideWith(() => _FakeNotifier())`
(예: `test/renew_screen_smoke_test.dart`).

---

## Design System Rules

모든 색상, 타이포그래피, 공통 컴포넌트는 먼저 정의된 것이 있는지 확인 후 사용한다.
**정의된 것이 있으면 반드시 가져다 쓰고, 없으면 하드코딩 허용.**

### 색상
```dart
// ✅ VybeColors에 있으면
color: VybeColors.mainPurple500

// ✅ 없으면 하드코딩 허용
color: Color(0xFF1A1A2E)
```

### 타이포그래피
```dart
// ✅ VybeTypography에 있으면
style: VybeTypography.heading1

// ✅ 없으면 하드코딩 허용
style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500)
```

### 공통 컴포넌트
```dart
// ✅ common/widgets/에 있으면
VybeButton(label: '로그인', onTap: () {})

// ✅ 없으면 기본 위젯 사용 허용
ElevatedButton(onPressed: () {}, child: Text('로그인'))
```

> 새 UI 작업 전 반드시 `VybeColors`, `VybeTypography`, `common/widgets/` 먼저 확인할 것

### 글래스 카드 · 로딩 규칙 (2026.09.15)

- **글래스 카드는 `RenewGlassCard` 하나** — `GlassCard` · `ReviewGlassCard` · `VybeGlassSurface` 는
  같은 껍데기 4벌이라 2026.09.15 삭제. `sheen: true` 가 구 GlassCard 의 좌상단 광택, radius 기본 **19**
  (18·20 으로 흔들리던 값을 전부 기본값으로). 색은 `RenewGlass.*`(`ClubGlass.*` 는 별칭)
- **블러는 옵트인(`blur: true`)** — 기본은 BackdropFilter 없음. 뒤가 정적인 오로라뿐이면 블러해도
  눈에 보이는 차이가 없고 매 프레임 뒤 배경을 다시 뜨는 비용만 든다. `RenewGlassCard` 에
  `blur: true` 를 주는 호출부는 0 — 카드는 전부 정적 오로라 위다. `BackdropFilter` 가 남는 곳은
  **뒤에 사진·본문이 실제로 지나가는 자리**뿐: `RenewBar`(sticky 탭바·GNB), 사진 위 글래스 바
  (검색 카드·서비스 음료 카드), 모달 시트·다이얼로그·토스트, 원형 글래스 버튼 — 이건 걷어내지 말 것
- **지도 위 `BackdropFilter` 금지** — 네이버 지도는 플랫폼 뷰라 블러가 지도를 못 잡는다(효과 0,
  비용만). 주변 탭 표면은 전부 채움 + 테두리 + 그림자(`NearbyGlass` 클래스 주석)
- `VybeMetaDot` 기본 **3px gray600**(디자인 VDot). 구 2px t4 는 `size: 2, color: RenewGlass.t4`
- `VybeToast` 규격 = 디자인 문서 — surface `.94` 채움 · `RenewGlass.hair` 테두리 · blur sigma 9 ·
  그림자 30/(0,10). 표시 시간 3초 고정
- **비동기 로딩 분기는 전부 스켈레톤** — `VybeSkel`(shimmer 클럭 **1개** 공유 — 인스턴스마다
  컨트롤러를 만들지 않는다. radius 는 `.r` 없이 넘긴다) 로 최종 레이아웃을 흉내 낸다.
  스피너·빈 화면 금지(버튼 안 인라인 스피너·제출 오버레이는 예외). 구 `VybeShimmerBox` 삭제
- 네트워크 이미지는 `SkeletonImage` / `vybeNetworkImage(url, cacheWidth|cacheHeight)` —
  `cached_network_image` 디스크 캐시(7일) + 표시 크기 × dpr 로 디코드 상한. **`Image.network` 직접 호출은
  lib 에 0** (2026.09.16 — 사진 뷰어·추천 페이지도 `vybeNetworkImage(url)` 로 옮겨 디스크 캐시와
  메모리 키를 다른 화면과 공유한다. 뷰어는 상한 없음 = 줌용 풀해상도). 설정 '캐시 삭제' 가 이 디스크 캐시도 비운다
  - `SkeletonImage(image:)` 로 provider 를 직접 넘길 수 있다 — 홈 배너와 가입 직후 `precacheImage` 가
    같은 `vybeNetworkImage(url)` 키를 쓰게 하려고(키가 다르면 미리 받은 비트맵을 배너가 안 쓰고 다시 내려받는다)
  - cover 디코드 상한은 **박스 비율이 아니라 원본 비율에 여유를 둔다** — 가로 박스는
    `max(w, h·16/9)`, 세로 박스는 `max(h, w·16/9)` 로 묶는다. 박스 축 하나만 묶으면 박스보다 넓은(긴)
    원본이 페인트에서 확대돼 흐려진다(`ResizeImage.allowUpscaling:false` 는 디코드만 막는다)
  - 세션 안에서 한 번 디코드가 끝난 URL 은 `minSkeleton` 을 건너뛴다(정적 settled-URL 집합) —
    같은 URL 을 다른 크기로 다시 보면(찜 리스트↔그리드) 메모리 키가 달라 miss 인데 1초 shimmer 를 다시 채우면 안 된다

### ⚠ 라운드 카드에 테두리를 그릴 때 (2026.08.20)

클립되는 카드의 **테두리는 `decoration`이 아니라 `foregroundDecoration`에 둔다.**

```dart
Container(
  clipBehavior: Clip.antiAlias,
  decoration: BoxDecoration(gradient: ..., borderRadius: r),      // 채움만
  foregroundDecoration: BoxDecoration(border: ..., borderRadius: r), // 테두리는 자식 위
  child: ...,
)
```

`decoration`에 `border`를 넣으면 **직선부만 남고 코너 호에서 선이 사라진다** —
카드 모서리가 잘려 나간 것처럼 보인다. Flutter가 `Container`를
`DecoratedBox(decoration) > ClipPath(바깥 라운드렉트) > Padding(테두리 두께) > child`
로 짜기 때문 —
① decoration(채움 + 테두리)을 먼저 그리고 ② 자식을 **바깥** 라운드렉트로 클립해 그 위에 얹는다.
직선부는 `decoration.padding`(= 테두리 두께)이 자식을 1px 들여보내 선이 살아남지만,
그 균일한 1px 인셋은 **코너 곡선을 따라가지 않아** 호 구간에서 자식이 선을 덮는다.
바깥 `ClipRRect`로 감싸도 결과는 같다(둘 다 실측 확인 — 직선부 밝기 83 대 호 14~25,
`foregroundDecoration`은 호 76~83).

카드 하단이 배경색과 비슷한 화면(홈 주변 클럽 카드 등)에서 특히 티가 난다 —
호에 선이 없으면 대비가 0이라 아래 모서리가 통째로 안 보인다.
**바깥 `ClipRRect`로 감싸는 것도 같은 결과**라 `ClipRRect > Container(border)` 형태는
`Container(clipBehavior: Clip.antiAlias)` + `foregroundDecoration` 으로 바꿔야 한다
(`ClipRRect`를 남긴 채 `foregroundDecoration`만 쓰면 바깥 클립이 다시 호를 깎는다).

적용된 곳 — 사진/불투명 카드 13곳(서비스 음료 카드는 2026.09.22 리뉴얼로 공용 포스터 카드를 쓴다):
`home_nearby_clubs` · `home_free_time_clubs` · `home_banner` · `search/club_list_item` ·
`free_entry_screen` · `vybe_club_poster_card` · `hip_hop_poster_card` · `saved_thumb` ·
`recommend_featured` · `my_review_card` · `hot_places_podium` · `hot_places_list_row` ·
`table_floor_map` · `renew_free_entry`(입장비 도형 칸).
`RenewGlassCard`(`common/renew/renew_glass.dart`)는 처음부터 이 방식이다.

⚠ **아직 안 고친 곳 (2026.09.15 재확인)** — `BackdropFilter` 가 낀 라운드 표면 4곳:
`vybe_toast` · `vybe_confirm_dialog` · `notification_header`(원형 버튼) · `search_bar`.
테두리를 자식 위로 올리면 글래스 질감이 달라질 수 있다 — 화면별로 눈으로 보고 옮길 것.
(예전 목록의 `nearby_*`·`club_pin_card`·`club_nearby_list_item`·`home_category_grid` 는
블러를 걷어내며 고쳤고, `vybe_glass_surface` 는 껍데기(`VybeGlassSurface`)만 삭제되고 파일엔
`GlassTintOverlay` 만 남았다(BackdropFilter 없음), `home_gnb`·`renew_chrome` 은 사각 `ClipRect`
바 안의 작은 도형이라 이 버그가 아니었다.) 찾는 법은 아래 스캔:

```bash
# 클립 안 decoration 에 테두리가 있는 곳 (괄호 매칭)
grep -rn "border: Border.all" lib/presentation/   # 후보 추린 뒤 ClipRRect/clipBehavior 포함 여부 확인
```

---

## Coding Conventions

- 파일명: `snake_case.dart`
- 클래스명: `PascalCase`
- Provider명: `camelCase` + `Provider` suffix (e.g. `clubListViewModelProvider`)
- 위젯은 `StatelessWidget` / `ConsumerWidget` 우선, `StatefulWidget` 최소화
- 비즈니스 로직은 절대 Widget 안에 작성하지 않음
- `freezed` 모델은 `data/models/` 또는 `domain/entities/`에 위치

---

## Responsive UI

이 프로젝트는 **`flutter_screenutil`** 을 사용하여 모든 UI 단위를 반응형으로 처리한다.
기준 디자인 사이즈는 `main.dart`에 설정되어 있다 **(393 x 852, iPhone 15 기준)**.

- 모든 width, height, fontSize, borderRadius는 반드시 screenutil 단위 사용
- `.w` (가로), `.h` (세로), `.r` (border radius), `.sp` (폰트 크기)
- 절대 `px` 고정값(예: `width: 100`) 사용 금지

---

## Design (Figma · 베타 / Claude Design · v1)

> **v1 화면의 디자인 기준은 Claude Design이다** (`/design` 또는 `design/` 폴더 — ⭐ v1 개발 규칙 참고).
> Figma 규칙은 베타 화면을 고칠 때만 적용한다. v1 화면 작업에 Figma MCP를 찾지 말 것.

베타 화면은 **Figma MCP**를 통해 디자인을 직접 참조하여 UI를 구현했다.

- **MCP 연동:** Figma MCP (`https://mcp.figma.com/mcp`) 사용
- UI 구현 시 Figma 디자인을 기준으로 색상, 타이포그래피, 간격, 컴포넌트를 최대한 정확하게 반영할 것
- Figma에 정의된 컴포넌트는 `presentation/common/` 폴더에 재사용 가능한 위젯으로 분리할 것
- 디자인 토큰(색상, 폰트 크기 등)은 `core/constants/` 또는 `core/theme/`에 상수로 정의할 것

### Figma 활용 규칙

- 새 화면 구현 전 반드시 Figma에서 해당 화면 디자인을 먼저 확인할 것
- Figma의 레이어 이름을 위젯 변수명/파일명 참고용으로 활용할 것
- 디자인과 다르게 구현이 필요한 경우 반드시 사유를 주석으로 남길 것
- **UI가 이미 구현된 화면 작업 시 Figma MCP 확인 불필요, 로직 레이어만 작성할 것**

---

## 현재 구현 상태 (2026.06.25 기준)

### 완료 ✅
- 디자인 시스템 (colors, typography) + 앱 테마
- Firebase 초기화 (firebase_options.dart), dotenv/카카오/네이버지도 초기화
- 인증 UI 화면 전체 (welcome, OTP, 본인인증, 약관, 가입완료)
- 공통 위젯 (VybeButton 등 — `VybeTextField`·`VybePageTitle` 은 본인인증 화면만 써서 `auth/widgets/` 로 내렸다 2026.09.15)
- **Cloud Functions 16개 전부 구현** (auth 6 + profile 1 + account 2 + favorites 2 + reviews 3 + performances 1 + search 1)
- **Flutter 데이터 레이어 전부 구현** — Freezed 모델 18종, datasource remote 18 + local 2,
  domain 인터페이스 4개(club·favorite·search_history·user) + repository provider 전부 (2026.09.16 재집계)
- 인증 플로우 연결 (SDK → Functions → Firebase)
- `MainScaffold` 5탭 (홈 / 주변 / 찜 / 검색 / 내 정보)
- 홈 (배너·추천), 내 주변 (네이버 지도 + 카탈로그 캐시 × haversine 반경 필터), 검색 화면
- **클럽 상세 — club_detail_glass.html(리퀴드 글래스) 리뉴얼 완료**
  (오로라 배경 + 히어로 320 + 히어로를 -34 덮는 아이덴티티 글래스 카드 +
  퀵 액션 4칸(전화·길찾기·공유·저장) + sticky 글래스 세그먼트 탭 5개)
  - 홈: 시간대별 무료입장(정책 있는 클럽만) / 매장정보(주소·영업시간 확장) / 오늘의 라인업 /
    테이블 요약 / 메뉴3 / 사진6 / 주변 클럽
  - 메뉴: 메뉴판 이미지 + sticky 카테고리 칩(섹션 스크롤) + 카테고리별 섹션
  - 사진: sticky 필터 칩(개수) + 2열 매스너리 + 12장씩 더 보기
  - 리뷰: 평점 요약(분포 바) + 작성 버튼 + 정렬 칩 + 5개씩 더 보기
  - 매장 정보: 위치(네이버 지도·주소 복사·길찾기) / 상세 정보 / 편의시설 / 이용 안내
  - 공통 글래스 위젯은 `clubs/widgets/club_glass.dart`
  - ⚠ **`NestedScrollView.headerSliverBuilder`에 pinned `SliverPersistentHeader` 금지**
    — Flutter 3.41 세만틱스 검증(`debugCheckForParentData`)이 매 프레임
    `'!semantics.parentDataDirty'` assert를 던져 화면이 통째로 안 그려진다(빈 화면).
    sticky 바는 스크롤 밖 고정 행(탭바는 `NestedScrollView.body` 최상단)으로 구현할 것
  - **편의시설 (2026.08.15 · 항목·아이콘 교체 2026.09.09)** — `info.facilities`(영문 키 배열)
    → 3열 그리드 카드. 키↔라벨·아이콘 대응은 `clubs/renew/widgets/renew_facilities.dart`의
    `ClubFacility` enum 하나. 등록된 시설이 없으면 섹션 자체를 뺀다.
    데이터 없으면 `node scripts/seed_facilities.js`
    - **항목 6종 고정** — `card`(카드 결제) · `locker`(물품보관함) · `nonSmoking`(금연) ·
      `parking`(주차 가능) · `tableReserve`(테이블 예약 가능) · `powerBank`(보조배터리)
    - 아이콘은 머티리얼 대체품이 아니라 **전용 SVG** —
      `assets/club_detail/icons/amenity/amenity-{card|locker|nosmoking|parking|reserve|battery}.svg`.
      전부 `stroke="currentColor"` 선 아이콘이라 색은 위젯이 `ColorFilter`(라임)로 입힌다
      (파일마다 색을 박으면 테마를 바꿀 때 6개를 다 손대야 한다)
    - ⚠ **구 키 3개(`restroom`·`smoking`·`groupSeat`)는 없어졌다** — enum에 없는 키는 앱이
      조용히 버리므로 기존 Firestore 문서는 `card`만 남아 섹션이 거의 빈다.
      `node scripts/seed_facilities.js --force`로 재배정할 것
- **약관 동의 기록 (2026.08.22)** — 가입 시 약관 시트에서 고른 항목별 동의/비동의를
  `users/{uid}.agreements` map에 저장. 항목 5개(terms·privacy·location·marketing + age19),
  각각 `{ agreed, version, agreedAt }`. **비동의도 false로 기록**하고 문서 개정일(`LegalDoc.version`)을
  같이 남겨 약관 개정 시 재동의 대상을 고를 수 있게 했다.
  - 저장 위치가 서브컬렉션이 아니라 users 문서 안의 map인 이유 — 항목이 5개 고정이고 프로필과
    항상 같이 읽힌다. 가입 때 쓰던 `set(merge)` 한 번에 얹으므로 **read·write 추가 0**
  - Rules·인덱스·Functions 변경 **없음**. 기존 유저는 필드 없음 = 빈 map (백필 안 함 —
    동의한 판본·시각을 모르는데 지어내면 그게 더 나쁜 기록)
  - **설정 토글 연결 (2026.08.22)** — 설정 > 알림의 '마케팅 · 홍보 알림'이
    `agreements.marketing`을 **직접 읽고 쓴다**. 가입 때 동의했으면 켜진 채로 시작하고,
    끄면 `agreed:false` + 그때의 `version`·`agreedAt`으로 **철회가 기록**된다
    - 알림 그룹의 나머지 토글은 여전히 화면 상태뿐 — **마케팅만 서버에 산다**.
      그 값이 표시 설정이 아니라 **수신 동의** 자체라서다. 로컬로 두면 약관·법적 고지가
      약속한 '설정에서 언제든 해제'가 앱을 껐다 켜면 되살아난다
    - 쓰기는 `setAgreement()`(datasource → repository) 한 곳. 점 표기
      `agreements.marketing`이라 다른 항목의 `agreedAt`은 안 건드린다
    - 토글 키는 `kMarketingToggleKey`(= `LegalDoc.marketing.name`) 하나 —
      화면 토글 키와 Firestore 키가 갈라지면 동의가 조용히 반영이 안 된다
    - 실패하면 표시를 되돌리고 토스트를 띄운다. 조용히 넘기면 껐다고 생각한
      사용자에게 계속 광고가 나간다
    - 비로그인 상태(알림 화면 → 설정 경로)에서는 '로그인 후 변경할 수 있어요' 토스트
  - 조각: `data/models/terms_agreement.dart` · `legal_documents.dart`(version) ·
    `terms_agreement_sheet.dart` · `settings_screen.dart`(마케팅 토글) ·
    `test/terms_agreement_sheet_test.dart` · `test/settings_screen_test.dart`(3건).
    상세 설계는 `firebase_structure.html#feature-terms`
- **테이블 배치도 · 가격 (2026.08.22)** — 하드코딩 상수(`table_pricing_data.dart`, 테이블 9자리가
  164개 클럽에 공통)를 걷어내고 `clubs/{clubId}/tableLayout/{clubId}` 문서 1건으로 교체.
  **위치는 정수 그리드 셀**(층마다 `cols × rows`, 셀 정사각) — 폭이 다른 업주 웹과 앱이 같은 그림을 그린다
  - 앱: 모델·파서 `data/models/club_table_layout.dart` + 팔레트 `table_layout_palette.dart` +
    금액 표기 `presentation/common/table_price_format.dart` + 렌더 `widgets/table_floor_map.dart`
    (층 전환 탭 포함) + `table_pricing_section.dart` · `table_detail_sheet.dart` ·
    `table_pricing_screen.dart` · `RenewTableSection`. 테스트 `test/club_table_layout_test.dart` 29건
  - **업주용 편집기 — `partner/`** (실서비스용). Firebase Auth 로그인 → Firestore 직접 쓰기,
    권한은 **Rules가 판정**한다. 업주는 클레임 `clubIds`에 적힌 클럽만 본다.
    정적 파일 3개(빌드 없음)라 `vybe.inertent.com/partner/...`에 그대로 얹으면 된다.
    운영 절차·주의는 `partner/README.md`
  - **로컬 확인 도구** — `node scripts/table_editor_server.js` → http://127.0.0.1:5599.
    ⚠ **gcloud 자격증명으로 붙어 Rules를 거치지 않는다**(아무 클럽이나 편집됨). 127.0.0.1 전용
  - ⚠ **편집 로직은 `partner/editor.js` 하나** — 두 페이지가 같이 쓴다(전송 계층만 다름).
    복붙으로 나누면 두 화면이 같은 배치도를 다르게 그려 '웹·앱 데이터 일치'가 조용히 깨진다.
    `editor.js`의 `TIER_STYLE`·`FX_LABEL`은 앱 `table_layout_palette.dart`와 **같은 값이어야 한다**
  - 권한: 커스텀 클레임 `{ partner: true, clubIds: [...] }` — `node scripts/set_partner_claim.js`
  - **Rules 배포 완료 (2026.08.22)** — 실측 확인: 비인증 read 200 / 비인증 write 403
  - 데이터 없는 클럽은 섹션 자체가 안 뜬다. 샘플 `node scripts/seed_table_layout.js`
  - 상세 설계는 `firebase_structure.html#feature-tables`
- **찜 탭 (`saved/`) — favorites 실연동** (정렬, 리스트↔그리드 뷰, 찜 해제)
- **마이페이지 (`my_page/`) — my_renew.html 리뉴얼 완료 (2026.08.15)**
  (오로라 배경 + 가로 프로필 행(아바타 76 · 프로필 수정 pill) + 통계 카드 2칸(리뷰·찜) +
  '내 활동'·'계정' 메뉴 목록 + 버전 표기. 메뉴는 카드로 감싸지 않고 **헤어라인으로만** 구분 —
  글래스 카드를 겹겹이 쌓으면 배경이 탁해져 본문이 안 읽힌다)
  - 하위 화면: 내 리뷰 관리(collectionGroup 조회·수정·삭제) / 내 정보 수정(닉네임) /
    설정(로컬 토글 + 캐시 삭제 실동작) — 공통 상단바는 공용 `VybePushHeader`(구 `MyPushHeader`, 2026.09.15 승격)
  - 화면 전용 조각은 `my_page/widgets/my_page_common.dart` 하나에 모음
    (메뉴 행 · 토글 · 입력 · 아바타 · 하단 바 — 푸시 헤더는 `VybePushHeader`, 등장 애니메이션은
    `VybeFadeInUp(index:)` 로 공용화)
  - 디자인의 @핸들·한 줄 소개·성별·활동지역은 users 스키마에 없어 제외
    (핸들 자리는 가입 방식 표기로 대체), 리뷰 '좋아요 수'도 reviews 스키마에 없어 제외
  - 리뷰 수정은 실동작(작성 화면 재사용), **알림 화면은 준비 중 토스트**
  - 프로필 사진 변경·닉네임 변경은 **2026.09.15 구현 완료** (아래 '프로필 수정' 참고)
  - ⚠ 리뉴얼 디자인 토큰·글래스 프리미티브(`RenewGlass` · `RenewGlassCard` · `RenewBar` ·
    `RenewSectionHead` · `RenewButton` · `RenewIcons`)는 클럽 상세와 함께 쓰므로
    `presentation/common/renew/`에 있다 (예전 `clubs/renew/widgets/`에서 승격)
- **프로필 수정 — 닉네임 · 프로필 사진 (2026.09.15, 배포 전)** — `my_edit_v2.html` 디자인 이식 +
  `users.nickname` 신설. 화면은 `my_page/profile_edit_screen.dart`(조립) +
  `my_page/widgets/profile_edit_parts.dart`(사진 피커 · 닉네임칸 · 이용 안내 카드 ·
  가입 정보 카드 · 사진 변경 시트), 서버는 `functions/src/profile/`
  (`update_user_profile.ts` onCall + 규칙 정본 `nickname.ts`).
  - **고친 문제는 '실명 노출'이다** — `users.name` 은 본인인증으로 받은 실명인데 그게 그대로
    표시 이름으로 쓰이고 있었다(입력칸 라벨만 '닉네임'이었고 실제로는 실명을 편집 중).
    리뷰를 하나 쓰면 `reviews.userName` 에 실명이 박혀 클럽 상세에 공개됐다.
    이제 표시 이름을 읽는 곳은 전부 `nickname` 이다 — 마이페이지 · 홈 인사말 ·
    리뷰 작성 · 고객센터 문의 · 탈퇴 화면
  - **닉네임은 서버가 배정·검증한다** — 유일성(`nicknames/{key}` 예약)과 문서 갱신이 한
    트랜잭션에 묶여야 해서 쓰기 주체가 `updateUserProfile` 하나다. Rules 가
    `nickname`·`profileImageUrl` 클라 쓰기를 막는다. 가입 마지막에 **인자 없이** 한 번
    부르면 랜덤 배정이 끝난다 — 형식 **`{앞말}바이버{1000~9999}`** (예: `신나는바이버4821`).
    앞말은 클럽 단어 40개(춤·플로어 20 + 에너지·열정 20), 조합 40×9000 = **36만**
    - ⚠ 앞말은 전부 **4자 이하**여야 한다 — 몸통 `바이버`(3) + 숫자(4)와 합쳐 최대 11자로
      상한 12에 1자 여유. 5자 단어를 넣으면 배정된 닉네임이 규칙을 넘어서고
      **사용자가 자기 닉네임을 다시 입력할 수 없게 된다**(입력칸이 12자에서 끊긴다).
      단어표는 서버에만 있고, `test/nickname_test.dart` 가 `nickname.ts` 를 파싱해
      길이·문자·금칙어를 검사한다
    - ⚠ **띄어쓰기 없이 붙여 쓴다** — 공백을 허용하면 앞뒤 trim 만으로 끝나던 정규화가
      복잡해지고(중간·연속 공백) 상한도 13자로 늘려야 한다
    - 뒤 4자리가 구분자 몫을 하므로 단어 수가 적어도 된다. 유일성 자체는
      `nicknames/{key}` 예약이 강제한다(충돌 시 최대 5회 재시도)
    - 앱은 형식만 복사해 둔다 (`core/utils/nickname.dart` — 2~12자 `^[가-힣a-zA-Z0-9]{2,12}$`).
      서버 왕복을 기다렸다 빨간 글씨를 보여주면 입력이 답답하다. 어긋남은
      `test/nickname_test.dart` 가 서버 `nickname.ts` 를 읽어 대조한다
    - ⚠ `_` 를 허용 문자에서 뺐다 — 닉네임이 곧 문서 ID라 `__foo__` 예약 패턴에 걸린다
    - ⚠ 한글 IME **조합 중 자모**(`새벽ㅇ`)는 오류로 띄우지 않는다 — 한 글자 칠 때마다
      빨간 글씨가 번쩍인다. 저장 버튼은 그대로 막혀 있다
    - 금칙어(사칭 어휘)·중복은 **서버만** 안다. 앱에 두면 함수 직접 호출로 우회된다
  - **저장 순서 — 파일 먼저, 문서는 마지막** (`UserViewModel.saveProfile` 한 곳).
    업로드 → `updateUserProfile` → 옛 파일 삭제. 함수가 실패하면 **방금 올린 파일을 지운다**
    (저장이 안 됐는데 파일만 남으면 고아가 된다). 옛 파일 삭제 실패는 삼킨다(문서는 이미 갱신)
  - ⚠ **프로필 사진 파일명에 타임스탬프를 붙인다** (`profile_{millis}.jpg`) — 예전처럼
    `profile.jpg` 로 덮어쓰면 URL이 그대로라 이미지 캐시·CDN이 옛 사진을 계속 보여준다
    ("바꿨는데 안 바뀐다" — 앱을 지웠다 깔아야 고쳐지는 종류)
  - ⚠ 업로드 전 **`maxWidth: 720`** 으로 줄인다(`pickProfilePhoto`) — `storage.rules` 의
    `users/{uid}/**` 상한이 5MB 라 원본을 그대로 올리면 **조용히 403** 이 난다
  - **기본 아바타가 이름 첫 글자 → 실루엣으로 바뀌었다** (요구사항) — `MyAvatar` 가 사진이
    없으면 디자인 기본 프로필(어두운 보라 원 + 중성 실루엣)을 그린다. `name` 파라미터도 뺐다
  - 가입 정보(이름·성별·생년월일·전화번호)는 읽기 전용 카드에 **기본 마스킹**으로 —
    `김**브` · `1997.**.**` · `010-****-5678`, '전체 정보 보기'로 해제
  - 디자인과 다른 곳 — 사진 시트 용량 안내 10MB → **5MB**(Rules 값) · '닉네임 30일 변경 제한'
    문구 제거(서버에 그 제한이 없다) · `invalid-argument` 에 `details.field` 를 실어
    사진 거부를 닉네임 입력칸 아래에 붙이지 않는다
  - 테스트 `test/nickname_test.dart` 19건 · `test/profile_edit_test.dart` 13건
  - **배포 순서 — 함수 → 앱 → Rules** (아래 '미구현' 참고). 상세 설계는
    `firebase_structure.html#feature-profile-edit`
- **리뷰 작성 페이지 (`clubs/review_write_screen.dart`) — review_write.jsx 글래스 디자인 기반**
  (별점 0.5 단위 반쪽 별, 추천 태그 칩 → `tags`, 사진 최대 4장 `image_picker` → Storage 업로드,
  후기 500자, 주의사항, 등록 완료 화면). 구 `write_review_sheet.dart` 바텀시트는 대체·삭제됨
- **검색 화면 인기 해시태그 · 실시간 인기 검색어 실연동 (2026.07.31)** — 더미 상수 제거 완료.
  `searchLogs`(수집) → `aggregateSearchTrends`(집계) → `searchTrends/current`·`searchHashtags`(노출).
  순수 로직은 `functions/src/search/compute_trends.ts`에 분리(Firestore 의존 없음) —
  되먹임 필터·고유유저 집계·증감·fallback·갱신주기 판단 전부 여기 있음
- **홈 배너 → 공지사항 상세 (2026.08.06 프로모션 상세로 시작 → 2026.08.24 공지로 통합)** —
  배너 탭 → `banner_link_handler`가 `linkType`으로 분기 → `notice`면
  `openNoticeDetail(noticeId)`(`my_page/notice_detail_route.dart`)가 문서 1건을 조회해
  기존 공지 상세 화면을 그대로 띄운다. **배너마다 다른 광고 글을 앱 배포 없이 DB만으로 추가** 가능.
  - ⚠ **구 `promotions` 컬렉션 + `PromotionDetailScreen`은 삭제됐다 (2026.08.24)** —
    광고 목적지가 배너 전용 페이지와 공지사항 둘로 갈려 같은 내용을 두 벌 관리해야 했다.
    공지로 합치면 **배너가 내려간 뒤에도 목록에서 다시 찾을 수 있다**. 지운 것 —
    `presentation/promotion/`, `promotion_model`·datasource·repository, `notices.promotionId`,
    `BannerLinkType.promotion`, `scripts/seed_promotions.js`, promotions Rules(Firestore·Storage)
  - 광고 공지는 `notice_ad_*` id에 배너 이미지를 첨부 사진으로 넣는다 —
    투입은 로컬 스크립트로 하고, 어드민 작성 UI는 아직 없음
- **공지사항 (2026.08.03)** — `notices` 컬렉션 + 앱 읽기 전용 화면
  (마이페이지 계정 메뉴 → `my_page/notices_screen.dart` 목록 → `notice_detail_screen.dart` 상세).
  카테고리 배지·고정 공지·NEW(7일) 배지·사진 n장. **작성/수정은 어드민 페이지(별도 구축 예정) 전용**
  - **게시 기간·게시 상태 (2026.08.07)** — 예약 게시(`publishedAt` 미래) / 게시 종료(`endAt`) /
    게시중단(`isActive=false`, 기간보다 우선) 3조건으로 노출 제어.
    판정은 `NoticeModel.isVisibleAt(now)` 단일 소스, 목록·단건 조회 양쪽에 적용
- **앱 버전 체크 / 강제 업데이트 (2026.08.13)** — `appConfig/{platform}` 정책 문서 +
  `presentation/common/version_gate/`. 루트가 `VersionGate` → `AuthGate` 순서라
  **로그인 전에** 판정한다. 점검 > 강제 > 권유 > 통과 4단계, 강제·점검은 전체화면
  차단(`PopScope canPop:false`), 권유는 앱 실행당 1회 바텀시트.
  앱 복귀(`AppLifecycleState.resumed`)마다 재검사 — 앱을 며칠 켜둔 기기가 강제
  업데이트를 영영 피하는 구멍 차단. 조회 실패·타임아웃은 전부 통과(fail-open).
  버전 비교·판정은 `core/utils/version_utils.dart` 순수 함수 + `test/version_utils_test.dart`.
  설정 화면 하단 버전 표기도 하드코딩 대신 이 결과를 재사용(`package_info_plus`)
- **네트워크 연결 게이트 (2026.08.16)** — `presentation/common/network_gate/`.
  루트가 `SplashGate` → `NetworkGate` → `VersionGate` → `AuthGate` 순서라
  **버전 조회·세션 복원보다 먼저** 걸린다(연결이 없으면 그것들은 타임아웃만 먹고
  빈 화면이 된다). 확인은 스플래시가 도는 동안 시작 —
  `splashDestinationProvider`가 `networkStatusProvider`를 보기 때문.
  - 판정 우선순위 (2026.08.28 수정) — ① `InternetAddress.lookup('firestore.googleapis.com')`
    **실제 도달이 최우선**(성공=연결됨 / `SocketException`=연결 없음) ② 도달이 답을 못
    냈을 때(타임아웃 등)만 `connectivity_plus` 연결 종류로 가른다 — 종류가 하나도
    없으면 연결 없음, 그 외엔 통과. **fail-open** — 플러그인 오류·조회 타임아웃은
    통과(확인 실패로 앱을 막으면 잘못된 차단). 판정은
    `data/datasources/local/device_network_datasource.dart` 한 곳
    - ⚠ **연결 종류를 먼저 보고 끊지 않는다** — 와이파이가 막 붙었거나 기기가 상태를
      늦게 갱신하면 종류와 실제 통신이 어긋나, 연결이 돌아왔는데도 안내 화면에 갇힌다
    - ⚠ **도달 확인은 재연결 경로에서 여러 번**(`kReconnectAttempts` 3회 · 0.5초 간격).
      붙은 직후엔 인터페이스만 올라오고 DNS는 아직 못 쓰는 구간이 있어, 한 번 실패로
      오프라인을 확정하면 **다시 시도 버튼을 눌러도 계속 실패**한다.
      첫 진입만 1회(스플래시를 붙잡지 않으려고)
  - 차단 화면 `widgets/network_error_screen.dart` (디자인 `network_error.jsx` 이식) —
    오로라 배경 + 신호없음 아이콘(`no_signal_icon.dart`, CustomPaint) + 다시 시도 +
    '네트워크 설정 열기'. 재시도 실패는 `VybeToast`(횟수 표기)
  - 자동 복구 4경로 — 재시도 버튼 · 앱 복귀(`resumed`) · 기기 연결 변화 스트림 ·
    **안내 화면이 떠 있는 동안 5초마다 도는 조용한 재확인**. 설정에서 와이파이를 켜고
    돌아오면 버튼을 안 눌러도 넘어간다
    - 주기 확인을 더한 이유 — 앞의 세 경로는 전부 '사건'에 걸려 있어, 연결 변화
      이벤트를 놓치거나(확인 중에 흘러감) 종류는 그대로인데 회선만 살아난 경우에
      **아무도 다시 확인하지 않는다**. 실패해도 토스트는 안 띄운다(사용자가 시킨
      확인이 아니다)
  - ⚠ iOS는 와이파이 설정 직접 진입이 막혀 있어 '설정 열기'가 **앱 설정 화면**으로
    열린다(app_settings 폴백). Android는 와이파이 설정으로 직행
  - **화면 확인용 강제 오프라인** — `DeviceNetworkDataSource.debugForceOffline = true`
    로 바꾸고 **핫리로드**하면 바로 안내 화면이 뜬다(`NetworkGate.reassemble` 이
    매 핫리로드마다 재검사). iOS 시뮬레이터는 Mac 네트워크를 그대로 써서 실제로
    끊으려면 Mac 와이파이를 꺼야 하므로 이 스위치가 빠르다.
    `kDebugMode` 안에서만 읽으므로 켠 채 커밋해도 **릴리즈 빌드는 영향 없음**
- **내 위치 기반 지역 판정 (2026.08.16)** — 지역 '홍대' 고정을 해제.
  `SplashGate` 진입 시 `geolocator`로 GPS 1회 조회(권한 팝업도 여기) →
  `userLocationProvider`(keepAlive) 갱신 → 홈 위치 칩 라벨 · 홈 '주변 클럽' 섹션 ·
  주변 탭 최초 조회 중심 · 힙합 카드 거리가 전부 이 좌표 하나를 본다.
  - GPS 코드는 `data/datasources/local/device_location_datasource.dart` **한 곳만**.
    서비스 꺼짐·권한 거부·타임아웃(5초)은 전부 예외 대신 null → 폴백 좌표(홍대)로 진행
  - `UserLocation` 은 `==` 를 구현한다 (2026.09.15) — 같은 좌표로 다시 set 해도 watcher 가 안 깨어난다.
    `setLocation` 은 기기→기기 **50m 미만 이동도 무시**(GPS 지터로 홈·주변 목록이 재계산되지 않게).
    홈 섹션·주변 뷰모델은 `select((l) => (lat, lng))` 로 좌표만 본다
  - 좌표 → 지역 이름은 `AppGeo.areaOf()` **2단계** — ① 클럽 상권
    (`AppGeo.hotspotCenters`, 반경 2km) ② 전국 시군'구'(`korea_regions.dart`, 252개,
    상한 60km). 둘 다 최근접이 우선(홍대·신촌은 1.2km라 반경으론 못 가린다).
    판정 테스트는 `test/app_geo_test.dart` · `test/user_location_test.dart`
    - **국내 밖(60km 밖)이면 좌표를 상권으로 대체한다 (2026.08.16)** —
      `AppGeo.overseasFallbackAreas`(홍대·건대·이태원·강남) 중 **앱 실행마다 랜덤 1곳**의
      좌표를 쓰고, 라벨만 `AppGeo.outsideKoreaLabel`(**'위치 확인 불가'**)로 바꾼다.
      해외 좌표를 그대로 두면 반경 3~30km에 클럽이 0곳이라 홈 '주변 클럽'·주변 탭이
      빈 화면이 되기 때문. 좌표를 빌린 걸 숨기고 '강남'이라 쓰면 거짓 정보라 라벨은 분리.
      대체 여부는 `UserLocation.outsideKorea`, 화면 문구는 **`areaLabel`로만** 읽을 것
      (`area`엔 대체한 상권명이 들어간다). 판정·대체는 `UserLocationNotifier.setLocation`
      한 곳. 뽑은 상권은 앱 실행 내내 고정 — 칩을 누를 때마다 주변 클럽이 갈아엎히면 안 됨
    - 상권명('홍대'·'강남')은 `clubs.area` 값과 **정확히 같아야** 한다 —
      지역 필터·거리표가 같은 문자열을 쓴다. DB에 상권을 추가하면
      `AppGeo.hotspotCenters`에도 추가할 것
    - **구가 있는 시는 시가 아니라 구를 넣는다 (2026.08.16)** — 일반구를 둔 12개 시
      (수원·성남·안양·안산·고양·용인·부천·청주·천안·전주·포항·창원)는 시 항목을 빼고
      구 35개로 대체. 시 하나로 두면 분당·일산·수지가 전부 '성남시'·'고양시'로 뭉개진다.
      화성시는 일반구 미설치라 아직 시 단위 — 설치되면 같이 쪼갤 것
    - 시군구 라벨은 `clubs.area`와 **무관한 표시 전용** 문자열. 이름이 겹치는
      중구·동구·남구·서구·북구·강서구·고성군·포항 남북구만 '서울 중구'처럼 시도를 앞에
      붙였다(경기 광주시도 광주광역시와 구분하려 '경기 광주시'). 라벨 유일성은 테스트가
      지킨다. 상권 2km가 시군구보다 먼저라 홍대에 있으면 '마포구'가 아니라 '홍대'로 뜬다
  - 홈 '주변 클럽'은 3 → 10 → 30km로 반경을 넓혀 가까운 순 5곳. 다 비면 홍대로 폴백
    (섹션을 비우느니 보여준다)
  - **`AppGeo.useFixedLocation` 은 false 가 정상** (2026.08.28 — true로 켜져 있던 걸 껐다).
    true면 GPS를 아예 안 읽고 전 화면이 홍대로 고정된다(권한 팝업도 안 뜸) — 화면 확인용
    스위치이므로 **true인 채로 커밋하지 말 것**. 홍대 좌표·라벨 상수는 폴백으로 그대로 산다
  - **카테고리 페이지의 위치 칩은 전부 빠졌다** — 입장비 무료(2026.09.15)·서비스 음료(2026.09.22)
    리뉴얼로 목록 상단 위치 칩·정렬 드롭다운이 사라져 `resolveFromDevice()` 재조회는 **홈 인사말만**
    부른다(`LocationFlipMixin`·`VybeLocationChip` 도 홈 전용). 거리는 두 페이지 다 공용
    `vybeClubDistanceKm`(내 좌표 × 클럽 좌표 haversine) — 서비스 음료 격자는 `VybeChipPosterGrid`
    가 이 값으로 가까운 순 정렬한다
    - ⚠ `ClubAreaDistance` 지역 간 거리표·`ClubSortable` 은 2026.09.15, `buildClubList`·`kClubSorts`·
      `test/club_list_sorting_test.dart` 는 **2026.09.22 삭제**(정렬 옵션 자체가 없어졌다)
  - 위치 권한 문구는 이미 설정돼 있음 — Android `ACCESS_FINE/COARSE_LOCATION`,
    iOS `NSLocationWhenInUseUsageDescription`
- **회원 탈퇴 — 30일 보관 soft delete (2026.08.17, 서버 배포 완료 · 앱 배포만 남음)**
  요구가 둘이라 축을 나눴다 — ① 데이터는 **30일 보관** 후 파기 ② 보관과 별개로
  리뷰·사진은 **탈퇴 즉시 비노출**. 그래서 "삭제"가 아니라 **숨김 + 예약 파기**다.
  - 즉시(`requestAccountDeletion` onCall) — `users.status='pendingDeletion'` + `deletedAt`·`purgeAt`,
    리뷰·사진·찜 `isHidden=true`, 클럽 `rating`·`reviewCount`·`favoriteCount` 감산,
    Auth 계정 `disabled=true`. **멱등** — 중간 실패 후 재호출해도 안 숨겨진 것만 이어서 처리
  - 30일 후(`purgeDeletedUsers` 스케줄, 매일 KST 04:30) — Firestore 문서 · Storage 파일 ·
    Auth 유저 완전 삭제. 회차당 50명, 한 명 실패해도 다음 회차에 다시 잡힌다
  - ⚠ **Auth 유저를 즉시 지우지 않고 `disabled`로 두는 이유** — 소셜 uid는 `kakao:{id}`로
    **고정**이라 Auth에서 지우면 재로그인 시 **같은 uid가 다시 만들어져 보관 중 데이터에 붙는다**.
    `disabled`면 로그인이 거부되고, 앱의 `isSessionRevokedCode`가 `user-disabled`를 이미
    처리해 **다른 기기 세션도 다음 실행 때 자동 정리**된다(앱 추가 작업 0)
  - ⚠ **집계 감산 주체는 `requestAccountDeletion` 하나** — 트리거 3종
    (`onReviewUpdated`·`onReviewDeleted`·`onFavoriteDeleted`)에 `isHidden` 가드를 넣었다.
    없으면 파기 때 두 번 깎여 음수가 된다
  - ⚠ **쓰기 경로도 `isHidden: false`를 같이 써야 한다** — `ReviewModel.toFirestore()`와
    `firebase_favorite_datasource.addFavorite`에 들어 있다. 빠뜨리면 목록 쿼리
    (`where isHidden == false`)가 못 잡아 새 리뷰가 조용히 사라진다
  - 앱: 설정 하단 '탈퇴하기' → `my_page/account_delete_screen.dart` —
    **account_delete.html(만류 화면) 디자인 적용 (2026.08.20)**.
    내 찜/리뷰/사진 개수 카드 + 놓치게 되는 것 6줄 + 탈퇴→보관→파기 3단계 타임라인 +
    사유 칩(고르면 대안 카드) + 동의 체크 + 주 버튼은 '계속 이용하기'(탈퇴는 밑줄 링크)
    + 확인 다이얼로그. 조각은 `my_page/widgets/account_delete_parts.dart`
    - ⚠ **디자인 시안의 '30일 안에는 재가입할 수 있어요'는 서버와 반대라 안 쓴다** —
      보관 기간엔 로그인·재가입 둘 다 막히고(`checkPhoneDuplicate` → pendingDeletion)
      파기일이 지나야 다시 가입할 수 있다. 화면 문구는 이 기준으로 통일
    - ⚠ **완료 안내는 라우트가 아니라 오버레이**(`LeaveDoneOverlay`) — 탈퇴 직후
      `AuthGate`가 루트 위 라우트를 전부 걷어내 화면으로 push하면 뜨자마자 사라진다.
      `OverlayState`는 `await` 전에 잡아 둘 것. 재가입 가능일은 서버가 준 `purgeAt` 사용
    - 확인 다이얼로그는 공용 `VybeConfirmDialog`에 `icon`·`cancelTone`·
      `VybeConfirmTone.dangerQuiet`(붉은 아웃라인)를 더해 만들었다 — 취소('더 써볼게요')가
      채운 버튼이어야 탈퇴 쪽이 주 동작으로 보이지 않는다
    - 사유 칩 라벨 = 서버 `deletionReason` 값. **문구를 바꾸면 저장값도 바뀐다**
    - 대안 카드 CTA는 실제로 갈 곳이 있는 것만 단다(알림 설정·개인정보 처리방침).
      클럽 제보·의견 보내기는 창구가 없어 버튼 없이 문구만
    탈퇴 성공 시 repository가 이어서 `signOut()` → `AuthGate`가 루트를 Welcome으로 교체
  - **보관 기간 내 재로그인 = 자동 복구 (2026.08.20)** — 별도 '철회' 버튼이 아니라
    **로그인이 곧 복구**다. 서버 `restorePendingDeletionOnLogin()`
    (`functions/src/account/restore_account.ts`)이 로그인 3종에서 Custom Token 발급 **전에**
    돌아 역연산을 한다 — 리뷰·사진·찜 `isHidden=false` + 집계 **가산** + Auth `disabled=false` +
    `status='active'`·`deletedAt`·`purgeAt`·`deletionReason` 삭제
    - ⚠ **`purgeAt`이 지났으면 되살리지 않는다** — 살려 놔도 그날 새벽 `purgeDeletedUsers`가
      데이터를 지운다. 이때는 예전처럼 `failed-precondition`으로 막되 `purgeAt`은 **null로**
      보낸다(이미 지난 날짜를 '그날부터 가입 가능'이라 안내하면 거짓말)
    - ⚠ 상태 필드(`status` 등)는 **맨 마지막에** 지운다. 중간에 실패하면 `pendingDeletion`이
      남아 다음 로그인이 처음부터 다시 시도한다. 각 단계가 `isHidden==true`인 문서만 손대므로
      재실행해도 **이중 가산 없음**(숨김 쪽과 대칭)
    - ⚠ 집계 가산 주체도 이 함수 하나 — `isHidden` false 전이는 `onReviewUpdated`가
      가드로 건너뛴다(이미 양방향 전이를 모두 무시하게 돼 있다)
    - `checkPhoneDuplicate`도 같이 바뀜 — 본인 + 파기 전이면 `sameAccount=true`·
      `pendingDeletion=false`·`restorable=true`로 통과시킨다. 안 그러면 본인인증 경로가
      로그인 화면 앞에서 먼저 막혀 복구까지 도달을 못 한다
    - 앱: 복구되면 토스트 `kAccountRestoredMessage`(소셜은 Welcome, 본인인증은 인증번호 화면),
      본인인증 경로는 넘어가기 전에 `kAccountRestoreNotice`로 예고. 문구 상수는 `signup_flow.dart`
    - 탈퇴 화면 타임라인·완료 오버레이 문구도 '보관 기간엔 로그인도 막힌다' → '다시 로그인하면
      복구된다'로 수정 (**새 가입은 여전히 파기일 이후**)
  - 배포 순서·주의는 아래 '미구현' 항목 참고. 상세 설계는 `firebase_structure.html#account-deletion`
- **EDM 장르 페이지 (2026.08.28 · 전체보기 2026.09.03)** — `edm_renew.html` → `edm_renew_v1.html`
  디자인 이식. 인트로 히어로(기존 이미지) + **DJ 공연 일정** + **주변 EDM 클럽 추천** 2섹션.
  데이터는 오늘 `performances`(genre=EDM) + `clubs`(genre=EDM) 실연동 — 조각은 `presentation/edm/`
  (`edm_models.dart` · `viewmodels/edm_viewmodel.dart`(= `genrePageProvider(kEdmGenre)` 별칭 — 실제 조회는
  힙합과 공용 `hip_hop/viewmodels/genre_page_viewmodel.dart` 의 `genrePageProvider(genre)` ·
  `GenrePageData{clubs, performances, clubById, headlinerByClub}`, 2026.09.15) · `edm_schedule_screen.dart` ·
  `widgets/edm_{timetable,time_row,set_card,club_grid,chrome,equalizer}.dart`)
  - **디자인에 있지만 데이터가 없어 뺀 것** — 셋 종료 시각 · BPM(에너지 등급) · 세부 장르.
    `performances`에 그 필드가 없다. 대신 **시작 후 60분 = 진행 중**(공용 `night_clock.dart` 규칙)으로
    상태를 판정하고, 좌측 액센트 바 색·DJ 이름 색을 그 상태로 칠한다. 없는 값을 지어내지 않는다
  - ⚠ **세부 장르 칩은 2026.09.01에 걷어냈다** — `clubs.genreStyles`를 필드째 지우면서
    타임테이블 장르 필터 줄·셋 카드 장르 표기·`kEdmAllStyles`가 같이 빠졌다. 되살리려면
    실제 조사 데이터가 먼저다(해시로 만든 샘플을 장르라고 표시하던 게 문제였다)
  - ⚠ 판정 시각(`now`)은 **화면당 한 번** 읽어 목록 전체에 넘긴다. 카드마다 `DateTime.now()`를
    다시 읽으면 같은 목록에서 NOW 마커와 카드 상태가 어긋난다(입장비 무료 페이지와 같은 규칙)
  - **밤 시각 계산은 공용 `presentation/common/night_clock.dart` 하나** — 06시 미만은 +24h.
    힙합 '오늘의 라인업'(`lineup_models.dart`)도 이걸 위임해서 쓴다. 두 화면이 같은 공연을
    다른 상태로 말하면 안 되므로
  - **포스터 카드는 공용으로 승격** — `common/widgets/vybe_club_poster_card.dart`
    (`VybeClubPoster` + `VybeClubPosterCard`). 힙합 전용이던 것을 EDM이 그대로 쓰게 되면서 옮겼고,
    화면마다 다른 건 액센트 색·LIVE 아이콘뿐이라 그 둘만 파라미터. `HipHopClub` typedef 는 2026.09.15
    삭제 — 호출부는 `VybeClubPoster` 직접 사용.
    테스트도 `test/vybe_club_poster_card_test.dart`로 이동
  - **클럽 조회는 `getClubsByGenre(genre)`로 일반화** (구 `getHipHopClubs()`) — 힙합·EDM이 같은 쿼리
  - 그리드 타일은 디자인대로 **LIVE 뱃지를 안 단다** — 바로 위 타임테이블이 오늘 라인업을 이미 말한다
  - **전체보기 · 전체 일정 페이지 (2026.09.03 — `edm_renew_v1.jsx` · `edm_schedule.jsx` 이식)** —
    섹션 이름이 'DJ 타임테이블' → **'DJ 공연 일정'**. 앞 3줄만 또렷하게 그리고 다음 2줄은
    흐리게 깐 뒤 그 위에 `전체보기 N ›`(보라 pill)을 얹는다. 누르면
    `EdmScheduleScreen`(`edm_schedule_screen.dart`)으로 — **종료된 공연까지 전부** 시간순.
    구 '종료된 공연 N개 보기' 토글은 대체·삭제됨
    - **타임라인 조각은 `widgets/edm_time_row.dart` 하나** (`EdmTimeRow` · `EdmNowMarker` ·
      `EdmTimelineSkeleton` · `kEdmTimeColW`). 섹션과 전체 페이지가 같이 쓴다 — 복붙으로 나누면
      두 화면이 같은 공연을 다르게 그린다
    - ⚠ **미리보기 줄이 없어도 전체보기는 남긴다** — 디자인은 흐린 줄 위에만 버튼을 얹지만,
      밤이 깊어 남은 공연이 3개 이하가 되면 그 버튼이 통째로 사라져 **종료된 공연을 다시 볼
      방법이 없어진다**. 그때는 목록 아래 평범한 pill로 그린다(디자인과 의도적 차이)
    - ⚠ **흐린 미리보기는 잉크를 덮지 않고 [BlendMode.dstIn] 마스크로 지운다** — 디자인은
      평평한 #101013 위라 그라데이션을 덮지만, 이 앱 배경은 오로라라 그러면 칸 끝에 색 경계가
      생긴다. 알파 램프(0/.5/.9/1 → 남는 알파로 뒤집음)는 그대로
    - ⚠ 헤드 우측 `N곳 플레이 중` pill은 **클럽 수**를 센다(라벨이 '곳'). 진행 중인 셋 수를
      그대로 쓰면 한 클럽에서 두 셋이 겹칠 때 두 곳이라고 말하게 된다. 0곳이면 pill 자체를 뺀다
    - ⚠ 전체 페이지도 **디자인의 세부 장르 칩은 뺐다** — `genreStyles` 폐기와 같은 이유
    - 하트는 두 화면 모두 화면 상태일 뿐(찜 미연동)이지만, 페이지를 열 때 넘겨받고 누를 때
      부모에도 알려 **돌아갔을 때 어긋나지 않게** 한다
    - 데이터는 같은 `edmViewModelProvider` — 뒤 화면이 살아 있어 캐시를 그대로 쓴다(추가 read 0)
  - 테스트 `test/edm_timetable_test.dart` 6건(진행 상태 표기 · 앞 3줄 + 흐린 2줄 · 남은 공연 0일 때
    전체보기 유지 · 전체보기 탭 · 빈 상태 · 전체 일정 페이지)
- **고객센터 문의 (2026.09.06)** — 사용자가 유형·제목·본문·사진(최대 4장)으로 문의를 보내고
  운영자가 답변하면 앱에서 확인하는 경로. 앱은 `presentation/support/`
  (`support_screen`(목록) · `inquiry_write_screen` · `inquiry_detail_screen` +
  `support_models.dart` · `viewmodels/inquiry_viewmodel.dart` · `widgets/`),
  데이터는 `inquiries` 컬렉션 + `data/models/inquiry_model.dart` ·
  `firebase_inquiry_datasource` · `inquiry_repository_impl`(Storage 합성).
  진입은 **설정 > 계정 > 고객센터 · 문의**(준비 중 토스트를 대체)와 마이페이지 계정 메뉴 두 곳
  - **디자인 이식 (2026.09.07 — `support.html` · `support_parts.jsx`)** — 세 화면을 리뉴얼
    글래스 톤으로 다시 그렸다. 목록은 상단 탭(전체 · 답변 대기 · 답변 완료 + 건수) +
    유형 태그·상태 뱃지 카드 + 우하단 보라 FAB, 작성은 카드 대신 **밑줄 입력**
    (기본 gray700 · 포커스 purple500 · 오류 red500) + 3열 유형 타일 + 주의/개인정보 박스,
    상세는 문의 카드 + 보라 글로우 답변 카드(운영팀 아바타)다. 공용 조각은
    `support/widgets/support_parts.dart`(유형 태그 · 상태 뱃지 · 라벨 · 상태 메시지 ·
    주의/안내 박스 · 첨부 썸네일), 탭은 `widgets/inquiry_tabs.dart`
    - ⚠ **디자인과 일부러 다른 곳 3가지** — ① 문의 유형을 **5종 그대로 둔다**
      (디자인은 계정·기타를 한 칸으로 합쳤지만 키가 곧 저장값이라 합치면 기존
      `account` 문의가 갈 곳을 잃는다) ② 제목 상한은 디자인 40이 아니라 **Rules 값 50**
      ③ '앱 알림으로 안내' 문구는 뺐다 — 이 앱엔 FCM이 없어 거짓 안내가 된다
      (답변 도착은 목록 · 카드 점 · 마이페이지 배지로만 알린다)
    - `RenewButton`에 **비활성 표시**를 더했다(디자인 VButton `disabled` — onTap이 null이면
      purpleDisabled + 흰 80%). 제출 가드가 걸린 버튼이 눌리는 것처럼 보이면 안 된다.
      같은 방식으로 null을 넘기던 프로필 저장 · 탈퇴 화면 버튼도 저장 중에 회색이 된다
    - `VybePhotoPickerRow`에 `addFirst` · `addShowsCount` 를 더했다(추가 칸을 사진 뒤로,
      라벨을 `n/4`로). 리뷰 작성 화면은 기본값 그대로라 그대로 보인다
    - ⚠ **탭 선택 밑줄(라임 2px)은 `Stack` + `Positioned(left/right 0, bottom -1)` 이다** —
      `Column` 자식으로 두면 `Row` 가 비-flex 자식에게 주는 **무한 폭 제약** 때문에
      자식 없는 `Container` 가 `LimitedBox` 로 **폭 0**이 돼 선이 통째로 사라진다
      (화면은 멀쩡해 보이고 선만 없다). 같은 함정이 카드 안 구분선에도 있어
      `_Hairline` 은 `width: double.infinity` 를 준다
    - 테스트 `test/support_screen_test.dart` 7건(빈 상태 · 비로그인 · 상태 뱃지 ·
      라임 밑줄 폭 · 탭 전환 · 탭별 빈 문구 · 조회 실패) · `test/inquiry_detail_test.dart`
      4건(대기 카드 · 답변 카드 · 확인 기록 1회 · 첨부 장수) ·
      `test/inquiry_write_test.dart` 3건
  - **운영자 답변은 아직 창구가 없다** — Firebase 콘솔에서 `inquiries/{id}` 문서의
    `answer`·`status='answered'`·`answeredAt`·`answeredBy` 를 직접 채우면 앱에 즉시 반영된다
    (콘솔은 프로젝트 소유자 권한이라 Rules 를 거치지 않는다). 어드민 UI 는 다른 어드민 기능
    (공지 작성·버전 정책·클럽 편집)과 함께 별도 구축 대상
  - **답변 알림은 앱 안에서만** — 프로젝트에 FCM 인프라가 전혀 없다(`firebase_messaging`
    미설치, APNs 설정 없음). 대신 목록 스트림 + 마이페이지 '고객센터 · 문의' 행의
    **안 본 답변 수 배지**(`unreadAnswerCountProvider` — 목록에서 메모리 집계, 추가 쿼리 0)
  - 사진 첨부 조각은 리뷰 작성 화면에서 **공용으로 승격** —
    `common/widgets/vybe_photo_picker.dart`(`VybePhotoPick` · `VybePhotoPickerRow` ·
    `pickPhotosFromGallery`). `ReviewPhoto` typedef 는 2026.09.15 삭제 — `VybePhotoPick` 을 그대로 쓴다.
    `pickMultiImage(limit:)` 가 2 미만이면 `ArgumentError` 를 던지는 분기도 여기 한 곳에 모았다
    (화면마다 다시 쓰면 '마지막 한 장'에서만 터지는 버그가 화면 수만큼 생긴다)
  - ⚠ 작성 제약(제목 2~50 · 본문 10~1000 · 사진 4장)은 **Rules 검증과 같은 값** —
    화면이 더 느슨하면 보내기를 눌렀을 때 서버가 403으로 되돌린다. 상수는
    `support_models.dart` 한 곳, 어긋남은 `test/inquiry_write_test.dart` 가 잡는다
  - 테스트 목록은 위 '디자인 이식' 항목 참고
    (`inquiry_write_test.dart` 3건 = 제출 가드 · 등록 값 · 제약 상수)

- **리팩토링 (2026.09.15)** — 동작은 그대로 두고 중복·죽은 코드·read 를 걷어냈다.
  - **중복 위젯 통합** — 글래스 카드 4벌 → `RenewGlassCard` · 빈 상태 카드 4 → `VybeEmptyCard` ·
    상태 문구 8 → `VybeStateMessage` · 푸시 헤더 3(`MyPushHeader`·`GlassTopBar`·`SchedulePageHeader`)
    → `VybePushHeader` · 저장 버튼 4 → `VybeSaveButton` · 영업 pill 3 → `VybeOpenNowPill` ·
    메타 점(`GlassDot`·`RenewDot`·`_Dot`) → `VybeMetaDot` · 썸네일 → `VybeClubThumb` ·
    shimmer 2벌 → `VybeSkel` · 포스터 격자 3사본 → `VybePosterSliverGrid` · `MyFadeUp` →
    `VybeFadeInUp(index:)` · 폴백 그라데이션 6벌 → `clubGradientFor` · 날짜 포맷 → `fmtDateDot`/`fmtHhmm`
  - **죽은 코드·에셋 삭제** — 참조 0 에셋 30개(1.1MB) + 빈 디렉터리 4개(pubspec 항목 포함) ·
    datasource 목록 쿼리 8개 + geohash 인코딩 · 인터페이스 미사용 멤버(`getActiveClubs`·`watchActiveClubs`·
    `updateUser`·`isPhoneDuplicate`·`isFavorite`·`invalidateCatalog`) · 미사용 `toFirestore/toMap` ·
    `ClubModel.freeEntryCondition` · 안 넘기던 파라미터·typedef·enum 값(`SearchSource.map`·
    `SignupMethod.apple` 등) · 화면 하나만 쓰던 common 위젯 8개는 그 화면 폴더로(Folder Structure)
  - **Firebase read 절감** — clubs 카탈로그 세션 캐시(500~700 → 164, '클럽 카탈로그 캐시') ·
    검색기록 upsert + 메모리 갱신(검색당 21 → 0 read) · 리뷰 목록 스트림 → 1회 get, 내 리뷰 수 `count()` ·
    찜·내 리뷰 조인 `getClubCached` · searchLogs 비랭킹 소스 write 안 함 · 이미지 디스크 캐시 ·
    `UserLocation ==` + 50m 지터 무시 · `mergedFavoriteIdsProvider` 는 `Notifier` + **집합 동등성**
    `updateShouldNotify`(찜 스트림이 같은 집합을 다시 내보내도 목록이 안 그려진다)
  - **스켈레톤 추가** — 홈(주변·무료 레일 `HomeClubCardRailSkeleton`, 인사말) · 주변(검색 대기) ·
    검색(최근 검색어·연관 검색어·해시태그/트렌드) · 마이페이지(프로필 행·통계 숫자·내 리뷰·공지 상세) ·
    클럽(테이블 가격표·공연 일정·리뷰 작성 클럽 카드) · 장르 4곳(포스터 격자 · K-POP/금연은 칩 줄까지) ·
    추천·핫플레이스는 기존 스켈레톤을 `VybeSkel` 로 교체
  - 세부 API 는 각 위젯 파일 주석. `flutter test` 전부 통과 · `dart analyze` 0
  - **리뷰 반영 (2026.09.16)** — 위 리팩토링이 만든 회귀를 되돌린 자리:
    - 주변 지도 검색(`NearbySearchNotifier.search`)은 로딩 상태의 `requestId` 를 잡아 두고 응답 후 대조한다 —
      그 사이 X(`clear()`)·재검색·다른 검색어로 상태가 바뀌었으면 늦게 온 응답은 버린다. 엔진 예외는
      **빈 결과로 확정**(스켈레톤에 갇히지 않고 '검색 결과 없음' 카드)
    - 마이페이지·탈퇴 화면의 찜 수는 `savedClubsProvider` 길이 — **활성 클럽만** 세어 찜 탭과 같은 숫자
      (favorites 문서 수를 그대로 쓰면 어드민이 클럽을 내리는 순간 두 화면이 어긋난다)
    - `VybeStatusMessage.warn` 은 디자인대로 노랑(`warnYellow`)이지만 본인인증 '만 19세 이상' 캡션은
      경고가 아니라 안내라 `defaultState`(회색) — 화면이 열리자마자 노란 경고문이 뜨면 안 된다

### 미구현 / 진행 중 ✗
- **시간대별 무료입장 — 앱 전 화면 완료, Algolia 색인만 남음 (2026.08.21)**
  Firestore `clubs`에 `freeEntry`·`isFreeEntry` 배정 완료(164개, timed 47).
  **완료** — `data/models/free_entry_policy.dart`(순수 함수 `statusAt()` +
  `test/free_entry_policy_test.dart` 25건), `ClubModel.freeEntry`·`isFreeEntry`,
  `getTimedFreeEntryClubs()`, 홈 '이 시간에만 무료입장' 섹션(`home/widgets/home_free_time_clubs.dart`),
  **클럽 상세 '시간대별 무료입장' 섹션 (2026.08.20 — club_detail_renew.html 디자인 이식)**,
  **입장비 무료 페이지 · 검색 필터 · 검색 카드 (2026.08.21)**:
  - `getFreeEntryClubs()` 기준을 `entryFeeMin==0` → `isFreeEntry==true`로 교체
    (**상시 72 → 상시+시간대 119곳**). `entryFeeMin==0`은 timed 클럽을 영영 못 잡는다 —
    timed는 무료가 끝났을 때 보여 줄 요금이 필요해 `entryFeeMin > 0`으로 두기 때문
  - `free_entry_screen.dart` — **2026.09.15 `free_entry_renew.html` 리뉴얼**. 세로 목록(지역
    칩·정렬)을 걷어내고 **기존 이미지 히어로(`VybeImageHero` — 사진 + 하단 안내 띠, 요구사항으로
    유지)** + 가로 레일 3섹션으로:
    ① '지금 이 시간만 무료'(timed — `compareFreeNow` 정렬, 지금 무료면 **초 단위 카운트다운 +
    진행 막대**, 아니면 같은 타일에 `금 22:00부터 무료`) ② '내 주변 무료입장'(공용
    `VybeClubMapSection`, 전체) ③ '조건이 맞으면 무료'(always — 가까운 순, `condition` 한 줄).
    조각은 `widgets/`(`free_entry_parts` · `_timed_rail` · `_cond_rail`), 색은 `free_entry_style`
    (퍼플 베이스 + 라임 포인트). 카운트다운 tick 은 화면 `ValueNotifier` 하나 —
    창이 열리고 닫히는 시각(`_boundary`)을 넘기면 목록을 다시 판정한다
    - 디자인과 다른 곳 — 텍스트 인트로('지금 들어가면 입장비 0원인 클럽' + n곳) 대신 이미지
      히어로 · 스크롤 시 불투명해지는 헤더 대신 공용 `VybeGlassHeader`(우측은
      디자인대로 검색 → 검색 탭 전환) · 지도 아래 카드 레일은 지도 섹션의 미니 카드로 대체 ·
      '걸어서 n분'은 도보 데이터가 없어 km · 조건 두 줄은 문구가 하나라 한 줄
    - `formatFreeCountdown` 은 클럽 상세와 같이 쓰게 되어 `common/free_entry_labels.dart` 로 승격
  - `ClubFilter.freeEntry` → `c.isFreeEntry`, 검색 카드 입장료 칩은 timed 진행 중이면 '지금 무료입장'
  - 시각 표기 문구(`38분 남음`·`금 22:00부터`)는 홈과 공유 — `presentation/common/free_entry_labels.dart`.
    두 화면이 같은 클럽을 다르게 말하면 안 되므로 한 곳에 둔다
  - 판정 시각은 **화면당 한 번** 읽어 목록 전체에 넘긴다. 카드마다 `DateTime.now()`를 다시 읽으면
    같은 목록 안에서 기준이 어긋나 정렬과 표기가 따로 논다
  - 테스트 `test/free_entry_screen_test.dart` 3건 — 시각을 주입할 수 없어 창을 **지금 기준 상대
    시각**으로 만들어 실행 시각과 무관하게 같은 결과가 나오게 짰다. 클럽 좌표는 (0,0)이라
    지도 섹션이 NaverMap(플랫폼 뷰) 대신 빈 지도 안내를 그린다
  남은 것:
  ① **Algolia Extension Indexable Fields를 정본 19개로 맞추기** → `node scripts/reindex_clubs.js`
  (2026.08.21 현재 `freeEntry`·`isFreeEntry`는 들어갔지만 그 전부터 6개가 빠져 있다 —
  위 '클럽 검색(Algolia)' 항목의 ⚠ 참고). 그때까지 검색 hit은 `complete=false` → `getClub` 조인 폴백이라
  **값은 맞고 read만 든다**(앱 코드는 이미 두 필드를 `_requiredFields`에 넣어 뒀다)
  ② 어드민 편집 UI (요일·시간 입력 + `isFreeEntry` 동시 쓰기)
  - **클럽 상세 (2026.08.20)** — 홈 탭 **첫 섹션** `clubs/renew/widgets/renew_free_entry.dart`.
    남은 시간 카운트다운(실시각 1초) + 시간대별 입장비 도형 + 조건 한 줄 + 요일별 무료입장 시간(접힘).
    매장 정보·상세 정보 탭의 **입장료 행**도 `RenewFeeRow`로 바뀌어 '지금 무료' pill + 무료 시간대가 붙는다
    - ⚠ **`freeEntry.type == 'timed'` 클럽에서, 무료 시작 1시간 전부터만 그려진다** —
      판정은 `RenewFreeEntrySection.maybeBuild()` 한 곳, null이면 호출부가 목록에서 뺀다.
      미표시 조건 넷 — `none`(무료 없음) · `always`(**상시 무료 — 나눌 시간대가 없어 도형이
      한 칸, 카운트다운도 없다. '무료'는 입장료 행이 이미 알린다**) · timed인데 쓸 수 있는 창이
      하나도 없을 때 · **다음 무료 시작이 `RenewFreeEntrySection.leadTime`(1시간)보다 멀 때**
      (무료가 여섯 시간 뒤인데 카운트다운이 홈 탭 첫 자리를 종일 차지하면 안 된다).
      무료가 **진행 중**이면 남은 시간이 곧 알맹이라 무조건 표시
    - ⚠ **표시 판정은 화면을 만드는 시점 한 번**이다 — 이미 떠 있는 섹션은 무료 시간이 끝나도
      그대로 두고 헤드만 '다음 무료입장'으로 바뀐다. 보고 있는 화면에서 섹션이 통째로 사라지면
      스크롤이 튀고 방금 본 정보를 다시 찾게 된다. 다시 숨기는 건 다음 진입 때
    - ⚠ **Firestore에 시간대별 요금표는 없다** — 도형은 `operatingHours`(회차) × `freeEntry.windows`
      × `entryFeeMin`을 겹쳐 만든다(`data/models/free_entry_timeline.dart` ·
      `test/free_entry_timeline_test.dart` 17건). 없는 요금 구간을 지어내지 않는다
    - 도형이 그리는 **회차(오픈~마감)**는 앵커로 고른다 — 무료 중이면 지금 회차,
      아니면 다음 무료 창의 시작 시각이 든 회차. 앵커 회차에 무료 구간이 없으면 도형을 뺀다
      (다른 날로 몰래 건너뛰면 헤드 문구와 다른 날을 그리게 된다)
    - 칸 너비는 길이 비례지만 **최소 폭 52**를 보장하고 모자란 만큼 넓은 칸에서 뗀다.
      현재 시각 마커도 **같은 너비 배열**로 계산해야 칸 경계와 안 어긋난다
    - 디자인의 **'무료 시간 시작 전 알림 받기' 버튼은 뺐다** — 푸시 알림 경로가 없어 눌러도 아무 일이 없다.
      '만석 시 조기 마감'·'신분증 지참' 두 줄도 대응 필드가 없어 뺐다(조건은 `freeEntry.condition` 하나)
    - ⚠ **영업 여부는 판정과 같은 시각으로 물어야 한다** — `OperatingHours.dayAt(now).isOpenAt(now)`.
      `today.isCurrentlyOpen`은 **벽시계**를 읽어, 시각을 주입하는 판정과 섞으면
      "무료 창 안인데 영업 종료" 같은 어긋난 답이 나온다(홈 카드 `toHomeFreeTimeClub`도 같이 고침)
  - Rules·인덱스·Cloud Functions 변경 **없음** (집계 아님 · clubs 쓰기는 어드민 전용 · 등호 2개라 복합 인덱스 불필요)
  - 구버전 앱은 `entryFeeMin==0`만 보므로 timed 클럽이 무료 목록에서 **안 보일 뿐**(누락) 오표기는 아니다
    → 강제 업데이트 사안 아님. 상세 설계는 `firebase_structure.html#feature-free-entry`
- 회원 탈퇴 잔여 작업 — **서버는 2026.08.17 전부 배포 완료**
  (백필 4865건 · 인덱스 · Rules · Functions 15개 · 스케줄 잡 ENABLED).
  ⚠ **단, 보관 기간 내 재로그인 복구(2026.08.20)는 아직 미배포** —
  `firebase deploy --only functions:kakaoLogin,functions:naverLogin,functions:phoneLogin,functions:checkPhoneDuplicate`.
  앱을 먼저 내보내도 안전하다(구서버는 `restored`·`restorable`을 안 주고 앱은 false로 폴백 →
  예전처럼 차단될 뿐). 반대로 **서버만 먼저 내보내도** 안전하다(구앱은 필드를 무시하고
  복구된 계정으로 그냥 로그인된다 — 안내 토스트만 없다)
  남은 것 ① **앱 빌드·배포** (`isHidden` 쿼리 필터와 탈퇴 화면이 여기 들어 있다)
  ② 개인정보처리방침에 '30일 보관' 문구 추가(법무 확인)
  ③ 어드민 페이지에 `pendingDeletion` 조회·즉시 파기 기능
  - 배포 후 확인함 — 인덱스 목록 쿼리·컬렉션그룹 `userId` 조회 200,
    **비인증**으로 숨긴 문서 단건 조회 **403**(목록에도 0건), `requestAccountDeletion`
    비인증 호출 401, `purgeDeletedUsers` 수동 실행 `파기 대상 없음`·ok, 앱 빌드 성공.
    **실계정 종단 테스트는 못 했다** — 커스텀 토큰 발급에 필요한
    `iam.serviceAccounts.signJwt` 권한이 없음. 앱 배포 후 실기기에서 볼 것
    (`firebase_structure.html#account-deletion` 검증 표)
  - 배포 중 **구 `deleteUser` 함수 제거** — 소스에선 `bb2fb34`에서 이미 빠졌는데
    배포본만 살아 있었다. users 문서·Storage·Auth를 **즉시 하드 삭제**하고 리뷰·사진·찜은
    남겨 고아 데이터를 만드는, 30일 보관 요구와 어긋나는 경로. 호출부·호출 로그 0이라 삭제
  - ⚠ 순서 주의(이미 지켜짐) — 백필·인덱스가 앱보다 먼저여야 한다. 앱을 먼저 내보내면
    `where isHidden == false`가 필드 없는 문서를 못 잡아 **리뷰 탭·사진 탭이 빈 화면**,
    인덱스가 없으면 `failed-precondition`. 지금은 서버가 다 돼 있어 앱은 아무 때나 내보내도 된다
- 테이블 잔여 작업 — Rules 배포·편집기·운영 절차는 **완료**. 남은 것:
  ① ~~이메일/비밀번호 로그인 제공자 켜기~~ **완료 (2026.09.06 확인 — 이미 켜져 있었다)**.
  같이 요구되던 **'가입 사용 중지'도 켰다**(`client.permissions.disabledUserSignup=true`).
  ⚠ **앱 로그인 3종은 영향 없음을 실측했다** — 자가 이메일 가입은 `ADMIN_ONLY_OPERATION` 으로
  막히지만, `signInWithCustomToken` 은 **없는 uid도 그대로 새로 만든다**(검증 후 테스트 계정 삭제).
  계정 추가는 이제 Admin API/콘솔로만 된다
  ② ~~Auth 승인된 도메인에 `vybe.inertent.com` 추가~~ **완료 (2026.09.06)**
  ③ `partner/` 3개 파일을 업주 웹 경로에 배포 (빌드 없음)
  ④ 업주 계정 생성 + `node scripts/set_partner_claim.js --email=… --clubs=…`
  ⑤ 실 데이터 입력 (현재는 seed 샘플 3곳뿐 — 실제 배치·가격 조사 필요)
  - 예약 기능은 **범위 밖** — 표시 전용이고 예약은 매장 전화로 안내한다
  - 절차 상세: `partner/README.md`
- EDM 페이지 잔여 작업 — 세부 장르(`genreStyles`)는 **2026.09.01 폐기**(아래 참고).
  포스터 #태그는 `tags` → 없으면 `genre` 로만 만든다. 장르 칩을 다시 붙이려면 실제 조사
  데이터 + 어드민 편집 UI가 선행돼야 한다
- ~~K-POP 장르 페이지 본문~~ **완료** — 히어로 + 주변 지도 + 가까운 순 그리드.
- ~~금연 페이지 본문~~ **완료 (2026.09.15 — `smoke_free.html` 이식)** — 히어로 + '위치별로 금연 클럽
  확인'(공용 지도 섹션) + '장르별로 금연 클럽 확인'(`widgets/non_smoking_genre_grid.dart`).
  홈 카테고리 '라운지' 자리를 '금연'으로 교체(아이콘 `category_grid/non_smoking.svg` = Material
  `smoke_free` rounded). 쿼리는 `getNonSmokingClubs()`(isActive + isNonSmoking 등호 2개 — 인덱스 불필요).
  히어로 원본(786×956)은 배지 32px 위(y=178)에서 갈라 `hero_top`(위 100px 미러 패딩) · `hero` 로 나눴다
  - **장르 칩은 실제 금연 클럽이 있는 장르만** (`nonSmokingGenresOf` — 디자인 순서 EDM·힙합·K-POP·
    하이브리드 먼저, 나머지 이름순). 디자인의 고정 4종을 박으면 테크노·팝·하우스·R&B 의 금연 클럽
    21곳(2026.09.15 실측 77곳 중)이 어느 칩에도 안 잡힌다. 지역 칩과 같은 규칙
  - 카드는 공용 `VybeClubPosterCard` + `footer`(새 슬롯) 에 '실내 금연' 뱃지 — `#태그` 자리.
    추천 뱃지는 주변 탭과 같은 공용 `VybeRecommendBadge`(디자인의 보라 '추천 클럽' pill 대신)
  - **디자인에 있지만 뺀 것** — 흡연실 섹션(`BoothSection`) · 정책 문구 3종 · 도보 n분.
    전부 `isNonSmoking` 불리언 하나뿐인 데이터로는 못 나눈다(`non_smoking_models.dart` 상단)
  - **로딩 스켈레톤** — 지역·장르 칩 줄은 `VybeChipRowSkeleton`, 그리드는 `VybePosterSliverGridSkeleton`
    (둘 다 공용 — 격자 스켈레톤은 K-POP·EDM·힙합도 같은 것, 칩 줄 스켈레톤은 칩이 데이터에서 나오는
    K-POP·금연만). 칩 줄을 안 그리면 데이터가 온 순간
    아래가 34px 튄다. 2열 격자는 공용 `VybePosterSliverGrid`(sliver — 장르 페이지 4곳이
    `CustomScrollView` 라 보이는 칸만 만든다. 구 `GridView.count` 판은 2026.09.15 삭제)
  - 테스트 `test/non_smoking_screen_test.dart` 3건(장르 칩 순서 · 문구/뱃지/칩 전환 · 스켈레톤)
- ~~서비스 음료 페이지 리뉴얼~~ **완료 (2026.09.22 — `service_drinks_renew.html` 이식)** — 이미지 히어로 +
  '내 주변 서비스 음료 클럽'(공용 지도 섹션) + '음료 종류별로 무료 클럽 확인'(공용 `VybeChipPosterGrid` —
  양주·샴페인·칵테일·맥주·와인 칩 단일 선택 + 가까운 순 2열 포스터 격자, 카드 하단은 `#태그` 대신
  `serviceDrink.comment` 를 `VybePosterBadge` 로) + 하단 `RenewFooterNote`(아이콘 라임). 헤더 우측은
  디자인대로 검색(검색 탭 전환). 구 세로 목록(위치 칩·정렬 드롭다운·`ServiceDrinksCard`)은 삭제
  - **종류 칩은 실제로 주는 클럽이 있는 것만** (`serviceDrinkTypesOf` — 디자인 순서 먼저, 모르는 값은
    뒤에 이름순). 지역·금연 장르 칩과 같은 규칙
  - **디자인에 있지만 뺀 것** — '혜택별로 무엇을 받는지' 섹션(웰컴 드링크·테이블 주류·음료 무제한·
    조건부 4종 + 제공 내용·조건·시간). `clubs.serviceDrink` 는 `{isOffered, comment, drinks}` 뿐이라
    혜택 등급이 없다 — `comment` 를 키워드로 갈라 만들면 지어낸 분류. 되살리려면 스키마에 tier +
    seed 가 먼저다. 텍스트 인트로 대신 이미지 히어로(입장비 무료와 같은 요구사항), 도보 n분은 km
  - `VybeClubPosterCard` 의 지역·거리 줄이 `Flexible` 로 바뀌었다 — 좌표 없는 클럽은 거리가 수천 km 라
    2열 카드에서 줄이 넘쳤다(테스트에서 드러남)
  - 테스트 `test/service_drinks_screen_test.dart` 4건(칩 목록 순수 함수 · 첫 칩 목록/뱃지/칩 전환 ·
    빈 안내 · 스켈레톤)
- 패스·지갑 탭 — 화면 없음. 플레이스홀더(`pass_wallet_screen.dart`)는 참조가 0이라 삭제됨(2026.09.06)
- 주변 페이지 ↔ 상세 페이지 연동 마무리 (최근 커밋 진행 중)
- 마이페이지 세부 — 알림 화면만 남음
  (리뷰 수정은 작성 화면 재사용 · 프로필 사진·닉네임 변경은 2026.09.15 구현 완료)
- 프로필 수정 잔여 작업 — **코드는 다 들어갔고 배포가 전부 남았다**
  ① `firebase deploy --only functions:updateUserProfile,functions:purgeDeletedUsers`
  ② 앱 빌드·배포 ③ `firebase deploy --only firestore:rules`
  - ⚠ **순서를 지킬 것** — 함수 없이 앱을 내보내면 가입 마지막의 닉네임 배정과 프로필 저장이
    전부 실패한다(가입 자체는 안 막힌다 — 배정 실패를 삼키고 중립 라벨 `VYBER` 로 진행).
    Rules 를 먼저 올려도 구버전 앱엔 저장 경로가 없어 실질 위험은 없다
  - 인덱스 변경 **없음**(`nicknames` 는 문서 ID로만 접근) · Storage Rules 변경 **없음**
    (`users/{uid}/**` 규칙이 파일명 변경·삭제를 이미 덮는다) · 마이그레이션 **없음**
    (기존 유저 백필 안 함 — 전부 테스트 계정이고, 프로필 수정에서 저장하면 그때 배정된다)
  - 실기기 검증 시나리오는 `firebase_structure.html#feature-profile-edit` 표
- ~~reviews collectionGroup 인덱스·Rules 배포~~ **완료 (2026.09.06 — 같은 배포에 실렸다.
  `reviews(userId, createdAt DESC)` COLLECTION_GROUP 인덱스 READY)**
- 편의시설 잔여 작업 — ① **`node scripts/seed_facilities.js --force`** (안 돌리면 구 키가 남은
  문서에서 `card` 하나만 살아남아 편의시설 섹션이 거의 빈다 — 2026.09.09 항목 교체.
  Rules·인덱스 변경은 불필요 — info 서브컬렉션 기존 규칙 그대로)
  ② 실제 시설 데이터 입력 + 어드민 편집 UI (현재 seed 값은 clubId 해시로 만든 샘플)
- 검색 트렌드 배포 잔여 작업 — ① Rules 는 **배포됨 (2026.09.06)**, `functions:aggregateSearchTrends` 는 **아직**
  (`firebase deploy --only functions:aggregateSearchTrends`)
  ② `node scripts/seed_search_hashtags.js` (안 돌리면 두 섹션 다 빈 화면)
  ③ 콘솔에서 `searchLogs.expireAt` TTL 정책 추가
- 홈 배너 링크 잔여 작업 — ① ~~`firebase deploy --only firestore:rules,storage`~~
  **완료 (2026.09.06 — 고객센터 Rules 배포에 같이 실렸다. promotions 잔재 규칙도 이때 정리됨)**
  ② 배너 `linkType`의 club·page·url 분기 연결 (`banner_link_handler.dart`) ③ 어드민 작성 UI
  (지금은 광고 공지 문서를 스크립트로 직접 넣는다)
- 고객센터 — **Rules·인덱스·Storage 배포 완료 (2026.09.06)**
  - 인덱스 `inquiries(userId, createdAt DESC)`·`(status, createdAt DESC)` 둘 다 **READY**
  - **실계정 종단 검증 11건 전부 통과** — 비인증 목록 403 / 사용자 생성 200 / 제목 1자 위반 403 /
    사용자의 `status`·`answer` 수정 403 / `readAt` 수정 200 / 사용자 삭제 403 /
    어드민 클레임 계정의 무필터 목록 200 / 답변 등록·조회·삭제 200 (검증용 문서·계정은 정리함)
  - 남은 것 ① **앱 빌드·배포** ② **운영자 답변 UI** — 지금은 Firebase 콘솔에서 문서를 직접
    편집해야 한다 ③ (선택) 답변 도착 푸시 — FCM 인프라가 통째로 없어 별도 작업.
    지금은 앱 내 배지로만 알린다
- 공지사항 배포 잔여 작업 — ① ~~`firebase deploy --only firestore:rules,firestore:indexes,storage`~~
  **완료 (2026.09.06 — `notices(isActive, publishedAt DESC)` 인덱스 READY 확인)** ② 샘플 데이터 `node scripts/seed_notices.js`
  ③ 어드민 페이지(작성 UI) 별도 구축
- 버전 체크 잔여 작업 — **Rules 배포·초기값 seed는 2026.08.13 완료**
  (`appConfig/android`·`appConfig/ios` 생성됨, 값은 전부 비어 있어 **차단 없음** 상태).
  남은 것 — ① **iOS `storeUrl`** (App Store Connect 등록 후 `.../app/id{앱ID}`.
  iOS는 폴백이 없어 비어 있으면 업데이트 버튼이 토스트만 띄운다)
  ② Android `applicationId`가 아직 `com.example.vybe`(Flutter 기본값) — **Play 스토어 게시 불가**.
  실제 패키지명 확정 필요 (`storeUrl`은 비워 두면 설치된 패키지명으로 폴백하므로 그때도 수정 불필요)
  ③ 어드민 페이지에 버전 정책 편집 UI
- Storage Security Rules 배포 검증 (Firestore Rules는 배포됨)
- Apple 로그인 (이후 구현)

---

## 작업 순서 (로드맵)

> **v1 작업의 순서 · 진행 상황은 `docs/progress.md` 와 설계 문서 16장 구현 로드맵이 기준이다.** 아래는 베타 시점 기록.

핵심 백엔드·데이터 레이어·주요 화면은 완료. 남은 작업:

```
1. 주변 ↔ 상세 페이지 연동 마무리 (진행 중)
        ↓
2. 프로필 수정 배포 (함수 → 앱 → Rules) + 마이페이지 알림 화면
        ↓
3. 패스·지갑 탭 실제 구현 (탭 슬롯 재배치 포함)
        ↓
4. Security Rules·인덱스 배포 검증(reviews collectionGroup 포함) + 본인인증(verifyIdentity) 실연동 점검
   (⚠ 선행: `functions/.env` 에 `PORTONE_IMP_KEY`·`PORTONE_IMP_SECRET` 채우고 재배포)
        ↓
5. Apple 로그인 (이후)
```

---

## Firebase 설계

> **v1 기준 문서는 `docs/backend_design.html` 이다.** 아래 표들은 베타 기준이며, v1 문서와 다르면 v1 문서가 이긴다.
> v1 문서 17장 ③ `[베타 버전 수정]` 목록에 있는 컬렉션 · 필드 · 함수 · 규칙은 아래 설명이 이미 낡은 것이다.

### 베타 버전 범위

**포함 기능:**
- 회원가입 / 로그인 (네이버, Apple + 본인인증)
- 홈 / 검색 / 내 주변 (지도 기반 탐색)
- 업체 상세 (정보, 메뉴, 갤러리, 인앱 리뷰)
- 찜 목록
- 마이페이지 (프로필, 리뷰 내역)

**제외 기능:**
- 웨이팅 / 테이블 예약
- 분실물 찾기
- 결제 내역
- 블로그 리뷰
- Apple 로그인 (이후 구현)

---

### 인증 플로우

#### 로그인 방식
| 방식 | 처리 방법 | Firebase UID 형식 | 구현 시점 |
|------|-----------|-------------------|-----------|
| 카카오 | Cloud Functions (kakaoLogin) → Custom Token | `kakao:{kakaoId}` | 베타 |
| 네이버 | Cloud Functions (naverLogin) → Custom Token | `naver:{naverId}` | 베타 |
| 본인인증 | verifyIdentity → 신규 유저 등록 | Firebase 자동 생성 | 베타 |
| Apple | Firebase Auth 직접 처리 | Firebase 자동 생성 | 이후 구현 |

#### 전체 흐름
```
1. 소셜 로그인 SDK → accessToken / identityToken 발급
2. 네이버: Cloud Functions(naverLogin) → Custom Token 발급
   Apple: Firebase Auth 직접 처리
3. FirebaseAuth.signInWithCustomToken() → Firebase UID 발급
4. Firestore users/{uid} 존재 여부 확인
   - 신규 유저 → 본인인증(verifyIdentity) → 프로필 입력 → users/{uid} 문서 생성 → 홈
   - 기존 유저 → 홈 화면 이동
```

#### 핵심 규칙
- accessToken은 매번 달라지지만 네이버ID는 불변 → 항상 같은 Firebase UID 생성
- 본인인증은 로그인 방식이 아닌 신원 확인 수단
- `phone` 필드로 **다른 방식의** 중복 가입 방지 — 같은 번호라도 **가입할 때와 같은 방식이면 로그인은 허용**한다
  (막으면 로그아웃한 사용자가 영영 못 들어온다). 판정은 `checkPhoneDuplicate` 참고
- `isVerified: false` 로 초기 생성 → 본인인증 완료 시 `true` 로 업데이트

#### 전화번호 주인 판정 (재로그인 vs 차단) — 2026.08.18

같은 번호가 이미 쓰이고 있을 때 **막을지 통과시킬지**는 "누가 주인이냐"로 정한다.
번호가 있다는 이유만으로 막으면 본인인증으로 가입한 사용자가 로그아웃한 뒤
영영 못 들어온다(실제로 그랬다).

| 상황 | 결과 |
|------|------|
| 처음 보는 번호 | 약관 동의 → 문자 인증 → **가입** |
| 가입할 때와 **같은 방식**의 내 계정 | 약관 생략 → 문자 인증 → **로그인** (홈 직행. 가입완료 화면·프로필 저장 없음 = Firestore 쓰기 0) |
| **다른 방식**으로 가입된 번호 | 차단 — `이미 존재하는 계정입니다.` + 계정 생성 안 함 |
| 탈퇴 대기(30일) 계정 — **본인** | 통과 → 로그인하는 순간 **계정 복구** (`restorePendingDeletionOnLogin`) |
| 탈퇴 대기(30일) 계정 — 남 / 파기일 지남 | 차단 (재가입 가능일 안내) |

- 판정은 서버(`checkPhoneDuplicate`) 한 곳. **시도 중인 uid를 클라가 정하지 않는다** —
  세션이 있으면 `context.auth.uid`, 없고 본인인증 경로면 `phone:{phone}`,
  소셜 신규면 없음(= 무조건 다른 계정). 앱은 `method`(= `users.provider` 값)만 넘긴다
- ⚠ **주인의 uid·provider는 응답에 싣지 않는다** — 번호만 넣어 보면 남의 카카오/네이버
  식별자나 가입 방식을 캐낼 수 있다. 비교는 서버에서 끝내고 `sameAccount` 불리언만 준다
- 앱 쪽 흐름: `SignupMethod`(진입 방식)를 Welcome → 본인인증 화면 → 인증번호 화면까지
  들고 다닌다. 공용 조각은 `presentation/auth/signup_flow.dart`
  (`SignupMethod` · `PhoneAccountStatus` · `phoneBlockedMessage` · `enterHomeAfterAuth`)
- 차단 시 `AuthViewModel.abortSignup()` 으로 만들다 만 세션을 정리한다 — 소셜 로그인은
  본인인증 화면에 오기 **전에** 세션이 붙어서, 그냥 두면 이름·전화번호가 빈 계정으로 앱에 들어간다
- **로그인은 `saveUserProfile`을 부르지 않는다** — 값이 같아도 `updatedAt`이 갱신돼
  수정한 적 없는 계정이 로그인할 때마다 수정된 것으로 남는다. `isLogin`이 켜졌다는 건
  이미 프로필이 완성돼 있다는 뜻이라(`users.phone`을 쓰는 경로가 `isVerified=true`를 같이 쓴다)
  쓸 것도 없다. 소셜 '가입 이어하기'는 `isLogin: false`로 들어와 그대로 저장된다
- 인증번호 화면에서 **한 번 더** 판정한다. 앞 화면 통과와 계정 생성 사이에 다른 기기에서
  같은 번호가 가입될 수 있고, 실제로 계정이 생기는 건 그 시점이다
- ⚠ **문자 인증이 아직 가짜다** — 코드가 `'123456'` 하드코딩이고(`certification_number_handler.dart`),
  `phoneLogin`은 번호만 받으면 Custom Token을 내준다. 지금까지는 "이미 있는 번호 차단"이
  우연히 계정 탈취를 막고 있었는데, 재로그인을 허용하면서 그 방벽이 사라졌다.
  **출시 전 Firebase Phone Auth(실제 SMS) 연동 필수**

#### Flutter 네이버 로그인 코드 패턴
```dart
// 1. 네이버 로그인 → accessToken
final NaverLoginResult result = await FlutterNaverLogin.logIn();
final String accessToken = result.accessToken.token;

// 2. Cloud Functions 호출 → Custom Token
final callable = FirebaseFunctions.instance.httpsCallable('naverLogin');
final response = await callable.call({'accessToken': accessToken});
final String customToken = response.data['customToken'];
final bool isNewUser = response.data['isNewUser'];

// 3. Firebase 로그인
await FirebaseAuth.instance.signInWithCustomToken(customToken);

// 4. 신규/기존 분기
if (isNewUser) { /* 본인인증 화면 */ } else { /* 홈 화면 */ }
```

---

### Firebase 아키텍처 규칙

#### 레이어별 Firebase 허용 범위

| 레이어 | Firebase import | 설명 |
|--------|----------------|------|
| `presentation/` | ❌ 절대 금지 | Firebase SDK 직접 접근 불가 |
| `domain/` | ❌ 절대 금지 | 순수 Dart 인터페이스만 |
| `data/repositories/` | ❌ 금지 | datasource 타입 참조만 허용 |
| `data/datasources/remote/` | ✅ 허용 | Firebase 코드는 오직 여기에만 |

> 같은 규칙을 기기 SDK에도 적용한다 — `geolocator`(GPS) import는
> `data/datasources/local/device_location_datasource.dart` 안에만 둔다.
> presentation은 `userLocationProvider`만 본다.
> `connectivity_plus`·`app_settings`도 마찬가지로 `device_network_datasource.dart`
> 한 곳만 — presentation은 `networkStatusProvider`(+ 설정 열기 호출)만 본다.

#### 파일 구조 규칙
- 모든 Firebase datasource 파일은 `data/datasources/remote/` 안에 위치
- 파일명 패턴: `firebase_{domain}_datasource.dart`
- 클래스명 패턴: `Firebase{Domain}DataSource`

#### 새 Firebase 기능 추가 시 작업 순서
```
1. data/datasources/remote/firebase_{domain}_datasource.dart 에 메서드 추가
2. data/repositories/{domain}_repository_impl.dart 에 provider 추가
   - 가공이 없으면 datasource 를 그대로 노출한다
     (`final xRepositoryProvider = Provider<FirebaseXDataSource>((ref) => FirebaseXDataSource());`)
   - 가공(조인·매핑)이 있으면 그때 클래스를 만든다
3. presentation에서는 repositoryProvider 또는 viewModelProvider만 참조

⚠ **domain 인터페이스를 기본으로 만들지 말 것 (2026.09.06)** — 구현이 하나뿐인
인터페이스와 `=> _dataSource.x()` 만 있는 래퍼를 8개 걷어냈다. 인터페이스는 **실제로
구현이 둘 이상일 때만** 둔다 — 남아 있는 4개(club·favorite·search_history·user)는
테스트가 가짜 구현을 만들어 쓰는 것들이다.
```

#### 현재 로그인 uid 접근 방법
presentation 레이어에서 현재 사용자 uid가 필요할 때는 반드시 `currentUidProvider` 사용:
```dart
// ✅ 올바른 방법
import 'package:vybe/core/providers/auth_providers.dart';
final uid = ref.watch(currentUidProvider); // String? (null = 비로그인)

// ❌ 절대 금지
import 'package:firebase_auth/firebase_auth.dart';
FirebaseAuth.instance.currentUser?.uid
```

#### Firebase 접근 로깅 규칙
모든 datasource 메서드에서 Firebase 호출 전 반드시 `logFirebaseAccess()` 호출:
```dart
import 'package:vybe/core/utils/firebase_logger.dart';

logFirebaseAccess('Firestore(컬렉션/경로)', '데이터 사용 목적 설명');
```

⚠ **인자가 2개로 바뀌었다 (2026.09.06)** — 예전 `file:` 은 값이 언제나 호출부 파일
이름이라 정보가 0이어서 뺐다. 본문이 `assert` 안으로 들어가 **디버그 빌드에서만 찍힌다**
(예전 `print` 는 릴리즈에서도 돌았다).

---

### Firestore 컬렉션 구조

Firebase 관련 코드는 반드시 `data/datasources/remote/` 에만 작성할 것.

#### users/{uid}
```
uid             : string    // Firebase Auth UID (PK)
name            : string    // 본인인증으로 받은 **실명**. 의미 고정 — 남에게 보이는 자리에 절대 쓰지 않는다
                            //   표시 이름은 nickname. 본인에게만 '내 정보 수정 > 가입 정보' 카드에서
                            //   마스킹된 형태로 보인다(김**브 · 1997.**.** · 010-****-5678)
phone           : string    // 본인인증 완료된 전화번호 (중복 가입 방지 기준)
birthDate       : string    // 생년월일 YYYYMMDD
gender          : string    // "male" | "female" — 주민번호 뒷자리 첫 숫자에서 도출(홀수 남/짝수 여)
                            //   ⚠ 영문 키만 저장. 한글 라벨은 화면에서 붙인다(provider·facilities와 같은 규칙)
                            //   알 수 없으면 필드 자체를 안 쓴다 — 빈 값은 '미입력'과 구분이 안 됨
                            //   도출은 genderFromCode()(presentation/auth/signup_flow.dart) 한 곳
nickname        : string    // 앱 전체의 **표시 이름**. 2~12자 · 한글/영문/숫자 · 중복 불가
                            //   ⚠ 서버 전용 — 쓰기는 updateUserProfile 하나뿐(Rules가 클라 쓰기 차단).
                            //     클라가 쓸 수 있으면 예약 없이 남의 닉네임을 가질 수 있다.
                            //     create 에도 이 키를 실을 수 없다(가입 마지막에 함수가 배정한다)
                            //   유일성은 nicknames/{key} 예약 컬렉션이 강제한다(Firestore엔 unique 제약이 없다)
                            //   빈 값(또는 필드 없음) = 아직 배정 안 된 계정 → 화면은 중립 라벨 'VYBER'
                            //   ⚠ 폴백을 name 으로 두지 말 것 — 고치려는 문제(실명 노출)를 그대로 남긴다
                            //     앱 상수·검증은 core/utils/nickname.dart (서버 nickname.ts 의 사본)
profileImageUrl : string    // Storage 프로필 이미지 URL — users/{uid}/profile_{millis}.jpg
                            //   빈 값 = 기본 아바타(디자인 기본 프로필 실루엣 — MyAvatar가 그린다)
                            //   ⚠ nickname 과 한 트랜잭션에 저장돼야 해서 같이 서버 전용이다 —
                            //     나눠 쓰면 반쪽만 저장되는 상태가 생긴다
                            //   ⚠ 파일명에 타임스탬프를 붙여 매번 다른 경로에 올린다. 덮어쓰면 URL이
                            //     그대로라 이미지 캐시·CDN이 옛 사진을 계속 보여준다
provider        : string    // "naver" | "apple"
isVerified      : boolean   // 본인인증 완료 여부 (초기값: false)
agreements      : map       // 약관 동의 기록 — { <key>: { agreed, version, agreedAt } }
                            //   key: terms|privacy|location|marketing (= LegalDoc.name) + age19
                            //   agreed  : 동의 여부. **비동의도 false로 남긴다** —
                            //             키를 빼면 '거부'와 '아직 안 물어봤다'가 구분 안 됨
                            //   version : 동의한 문서의 개정일 'YYYY-MM-DD' (= LegalDoc.version)
                            //             약관을 개정하면 재동의 대상을 이 값으로 고른다
                            //             age19는 읽을 문서가 없어 빈 문자열
                            //   agreedAt: serverTimestamp. **중첩 map 안의 sentinel** —
                            //             Firestore가 배열 안에선 거부하므로 list로 바꾸지 말 것
                            //   ⚠ 가입 때 setUserProfile이 한 번만 쓴다. 재로그인은 null로
                            //     내려와 기존 기록을 덮지 않는다(재로그인 Firestore 쓰기 0 유지)
                            //   ⚠ marketing만 예외로 **가입 후에도 바뀐다** — 설정 > 알림의
                            //     '마케팅 · 홍보 알림' 토글이 곧 이 값이다(2026.08.22).
                            //     쓰기는 setAgreement()가 점 표기(agreements.marketing)로
                            //     그 항목만 갈아 끼운다 — map을 통째로 얹으면 손대지 않은
                            //     필수 약관의 agreedAt까지 오늘로 덮인다
                            //   ⚠ UserModel.toFirestore()에는 일부러 없다 — 프로필 저장마다
                            //     map을 다시 쓰면 agreedAt이 프로필 수정 시각으로 덮인다
                            //   ⚠ 덮어쓰기라 이력이 안 남는다. 철회 이력까지 필요하면
                            //     users/{uid}/agreementLogs 를 따로 둘 것
                            //   도입 전(2026.08.22) 가입자는 필드 없음 = 빈 map. 백필 안 함
status          : string    // "active" | "pendingDeletion" — 탈퇴 대기 여부.
                            //   필드가 없으면 active로 간주(기존 문서)
                            //   보관 기간 안에 다시 로그인하면 서버가 active로 되돌리고
                            //   deletedAt·purgeAt·deletionReason 을 지운다(복구)
deletedAt       : timestamp?// 탈퇴 요청 시각
purgeAt         : timestamp?// deletedAt + 30일 = 완전 파기 예정 시각(재가입 가능 시점)
deletionReason  : string?   // 탈퇴 사유(선택 설문). 안 고르면 빈 문자열
createdAt       : timestamp // 가입 시각. **문서를 처음 만들 때만** 쓴다(Rules가 이후 변경을 막음)
updatedAt       : timestamp // 수정 시각. 로그인만으로는 갱신 안 됨(재로그인 경로는 users 쓰기 0)
```
> ⚠ **`createdAt`은 앱이 쓴다 — `onUserCreated` 트리거에 맡기지 않는다 (2026.08.18)**
> 원래는 Auth 신규 유저 트리거가 채우는 설계였는데 **그 트리거가 실행되지 않고 있다**
> (`phoneLogin`이 새 uid를 만든 시각에 `onUserCreated` 호출 로그가 0건, 그렇게 만들어진
> `phone:` 문서엔 전부 `createdAt`이 비어 있음. 2026-04에 만들어진 `kakao:` 문서엔 있다).
> 이제 `setUserProfile`이 **문서가 없을 때만** `createdAt`을 같이 쓴다 —
> Rules의 update 규칙이 `createdAt` 변경을 막아 **이미 비어 있는 문서는 앱에서 못 메운다**
> (서버 스크립트 백필 필요).
> `status`·`deletedAt`·`purgeAt`는 **서버 전용** — Rules의 update 금지 키에 들어 있다.
> 클라가 고칠 수 있으면 탈퇴를 스스로 취소하거나 파기 시점을 뒤로 밀 수 있다.

#### clubs/{clubId}
```
clubId              : string    // = 문서 ID (PK). 문서 필드로는 저장 안 됨 (doc.id 사용)
name                : string    // 클럽 이름
description         : string    // 클럽 소개글
address             : string    // 주소
area                : string    // 지역 (예: "홍대", "강남", "이태원")
phone               : string    // 연락처
instagramUrl        : string    // 인스타그램 URL
location            : object    // { lat: double, lng: double, geohash: string }
                                //   geohash 는 location 맵 안(최상위 아님). ⚠ **앱은 더 이상 geohash
                                //   쿼리를 안 쓴다 (2026.09.15)** — 주변 판정은 카탈로그 캐시 × haversine.
                                //   필드는 seed 가 계속 쓰므로 남겨 둔다
genre               : string    // 주요 장르 (예: "힙합", "테크노", "팝")
                                //   ⚠ 세부 장르 `genreStyles` 는 **삭제됐다 (2026.09.01)** —
                                //     Firestore 22개 문서에서 제거(`scripts/delete_genre_styles.js`).
                                //     값이 조사 데이터가 아니라 clubId 해시 샘플이었고, 이걸 읽던
                                //     화면 3곳(힙합 라인업 장르 칩 · EDM 타임테이블 장르 필터 ·
                                //     포스터 #태그)을 같이 걷어냈다. 포스터 #태그는 이제
                                //     tags → 없으면 genre. 되살리려면 실 조사 데이터가 먼저다
rating              : double    // 평점 (ratingSum / reviewCount, Cloud Functions 자동 업데이트, 직접 수정 금지)
ratingSum           : number    // 별점 합계 (Cloud Functions 자동 업데이트, 직접 수정 금지)
reviewCount         : number    // 리뷰 수 (Cloud Functions 자동 업데이트, 직접 수정 금지)
operatingHours      : object    // 요일별 영업시간
                                //   { mon, tue, wed, thu, fri, sat, sun }
                                //   각 요일: { isOpen: boolean, open: string?, close: string? }
                                //   예: { isOpen: true, open: "22:00", close: "06:00" }
                                //   휴무일: { isOpen: false }
closeTime           : string    // (레거시) 일부 클럽에 존재하는 단일 마감시각 필드.
                                //   영업시간 표시는 operatingHours 기준 — closeTime 신규 사용 금지
entryFeeMin         : number    // 평상시 입장료 최소 (원, 0이면 상시 무료)
                                //   ⚠ freeEntry.type='timed' 클럽은 0으로 두지 말 것 — 무료 시간이 끝났을 때
                                //     보여 줄 요금이 사라지고, 구버전 앱이 상시 무료로 오인한다
entryFeeMax         : number    // 평상시 입장료 최대 (원)
heroImageUrls       : array     // 상단 슬라이더 이미지 URL 목록 (상세 페이지 히어로)
imageUrls           : array     // 갤러리(사진탭) 이미지 URL 목록
menuBoardUrls       : array     // 메뉴판 이미지 URL 목록
thumbnailUrl        : string    // 리스트 대표 이미지 URL
tags                : array     // 태그 목록
favoriteCount       : number    // 찜 수 (Cloud Functions 자동 업데이트, 직접 수정 금지)
isActive            : boolean   // false면 앱에 노출 안 됨
isVybeRecommended   : boolean   // vybe 추천 여부
serviceDrink        : object    // 무료 서비스 음료 정보 (서비스 음료 페이지 데이터 소스)
                                //   { isOffered: boolean, comment: string, drinks: string[] }
                                //   isOffered : 제공 여부 (필터/노출 기준). 미제공이면 필드 생략 or false
                                //   comment   : 제공 코멘트 (예: "1인 음료 무제한", "테이블당 맥주 6병")
                                //   drinks    : 음료 종류 ["양주","샴페인","칵테일","맥주","와인"]
                                //   서비스 음료 페이지: isOffered=true 필터 + drinks로 종류 필터
freeEntryCondition  : string    // (레거시) 구 무료 조건 코멘트 — freeEntry.condition 으로 이관 완료.
                                //   ⚠ **앱 모델에서 제거됐다 (2026.09.15)** — ClubModel 이 이 키를 읽지 않는다.
                                //     서버 문서에 남아 있어도 무시. 정리는 다음 seed/마이그레이션 때
freeEntry           : object    // 무료입장 정책 (필드 없으면 type='none'으로 간주)
                                //   { type: string, condition: string, windows: array }
                                //   type      : "none" | "always" | "timed"
                                //     always : 상시 무료(entryFeeMin=0) / timed : 특정 시간대만 무료
                                //   condition : 조건 코멘트 (예: "자정 이전 입장 무료")
                                //   windows   : type='timed'일 때만. [{ days, start, end, label }]
                                //     days  : ["thu","fri","sat"] — operatingHours와 같은 키. 빈 배열이면 매일
                                //     start : "22:00" 포함 / end : "01:00" 미포함
                                //     end <= start 면 자정을 넘긴 창 — 창은 **시작 요일**에 속한다
                                //       (금 23:00~02:00 은 토 01:00 도 무료 → 판정은 어제 창도 같이 봐야 한다)
                                //   ⚠ 지금 무료인지 판정은 앱 순수 함수 FreeEntryPolicy.statusAt() 단일 소스.
                                //     Firestore는 "요일 × 시:분 × 자정 넘김"을 쿼리할 수 없다
                                //   ⚠ 무료 뱃지는 영업 중일 때만 표시 — 문 닫은 클럽의 '지금 무료'는 거짓 정보
                                //   홈 '이 시간에만 무료입장'은 getTimedFreeEntryClubs()
                                //     (isActive=true + freeEntry.type='timed') — 상시 무료는 뺀다
isFreeEntry         : boolean   // = (freeEntry.type != "none") 파생값
                                //   입장비 무료 페이지 쿼리(isActive=true + isFreeEntry=true) · 검색 '무료입장'
                                //   필터 · Algolia 인덱스 전용. 등호 2개라 복합 인덱스 불필요
                                //   ⚠ 트리거로 만들지 않는다 — clubs write가 Algolia Extension 동기화를 다시
                                //     태워 쓰기·색인이 2배가 된다(구 onClubWritten을 지운 이유와 같다).
                                //     freeEntry를 쓰는 쪽(seed·어드민)이 반드시 같이 쓴다
createdAt           : timestamp
updatedAt           : timestamp
```
> **시간대별 무료입장 (2026.08.18 데이터 배정 완료 · 앱 미구현)** — `node scripts/seed_free_entry_windows.js`로
> 전 클럽 164개에 `freeEntry`·`isFreeEntry`를 채웠다. 배정은 **지역별로 유료 클럽(`entryFeeMin>0`)의 절반**
> (홍대 16 · 강남 13 · 이태원 10 · 건대 6 · 신촌 2 = **timed 47** / always 72 / none 45).
> 상시 무료 클럽을 timed 후보에서 뺀 이유는 무료 시간이 끝났을 때 보여 줄 평상시 요금이 0원이라 없기 때문.
> 선정·시간대 모두 clubId 해시 기반이라 재실행해도 같은 결과(`--force` 재배정, `--dry` 확인만).
> ⚠ **창(window)은 전부 영업시간 안에 둔다** — DB의 164개 클럽은 전부 **목·금·토만 영업**
> (목·금 22:00~06:00, 토 22:00~05:00, 월·화·수·일 휴무). 밖에 창을 두면(오픈런 20:00~22:00, 주중 무료 등)
> '지금 무료'가 영영 안 뜬다. 영업일이 늘면 패턴 풀도 같이 늘릴 것.
> 실제 조사 데이터가 아니라 화면 확인용 샘플 — 운영 데이터는 어드민 편집 UI로 덮어쓴다.
> 설계 상세는 `firebase_structure.html#feature-free-entry`.

#### clubs/{clubId}/info/{clubId}
```
nearbySubways   : array     // 주변 지하철역 목록 [{ stationName: string, distanceM: number, lines: string[] }]
                            //   lines: 호선 목록 (예: ["9호선"]) — SubwayLineBadge 표시용
openChatUrl     : string    // 카카오 오픈채팅방 URL
cautions        : array     // 유의사항 목록 (string[])
facilities      : array     // 편의시설 키 목록 (string[]) — 클럽 상세 '매장정보' 탭 편의시설 섹션
                            //   card(카드 결제) · locker(물품보관함) · nonSmoking(금연)
                            //   parking(주차 가능) · tableReserve(테이블 예약 가능) · powerBank(보조배터리)
                            //   ⚠ 2026.09.09 항목 교체 — restroom·smoking·groupSeat 폐기.
                            //     구 키가 남은 문서는 card만 살아남는다 → seed --force 재배정 필요
                            //   ⚠ 한글 라벨이 아닌 **영문 키만** 저장. 라벨·아이콘 대응은 앱의
                            //     `ClubFacility` enum(renew_facilities.dart) 단일 소스 —
                            //     문구를 바꿀 때 전 클럽 문서를 손대지 않기 위함
                            //   ⚠ enum에 없는 키는 앱이 **조용히 버린다**(영문 키 노출 방지).
                            //     시설을 늘리려면 enum에 먼저 추가할 것
                            //   빈 배열이면 섹션 자체가 안 그려짐 (빈 카드 = '시설 없음'으로 읽히므로)
updatedAt       : timestamp
```
> 편의시설 seed(샘플): `scripts/seed_facilities.js` — card는 전 클럽 공통,
> 나머지는 clubId 해시로 결정(같은 클럽은 항상 같은 조합). 실제 시설 조사 데이터가 아니라
> 화면 확인용. **쓰기는 어드민 페이지(별도 구축 예정) 전용 — 앱은 읽기만.**

#### clubs/{clubId}/menus/{menuId}
```
menuId          : string    // PK
clubId          : string    // FK → clubs
name            : string    // 메뉴명
description     : string    // 설명
price           : number    // 가격 (원)
imageUrl        : string    // 메뉴 이미지 URL
category        : string    // 카테고리 (주류, 음식 등)
isAvailable     : boolean   // 판매 여부
isFeatured      : boolean   // 대표 메뉴 여부
createdAt       : timestamp
```

#### clubs/{clubId}/tableLayout/{clubId}
```
schemaVersion   : number    // 현재 1. 앱이 아는 판보다 크면 렌더 포기(모르는 필드를 억지로 그리면 깨진다)
clubId          : string    // FK → clubs. Rules가 문서 경로와 일치하는지 검사
tiers           : array     // 등급 정의 [{ key, name, short, colorKey, order }]
                            //   등급 구성은 클럽마다 달라 전역 상수로 두지 않는다
                            //   colorKey: purple|blue|lime|pink|amber|gray — **영문 키만** 저장,
                            //     실제 색값은 앱(table_layout_palette.dart)이 갖는다. 모르는 키는 gray
floors          : array     // 층 목록. 1개여도 배열 (아래 구조)
notice          : string    // 배치도 하단 안내 문구. 비면 미표시
updatedAt       : timestamp
updatedBy       : string    // 저장 주체 uid(또는 도구 이름)

floors[] = {
  floorId   : string  // 층 삭제·재정렬에도 안 바뀌는 키
  name      : string  // '1F' · '루프탑'
  order     : number  // 앱이 오름차순 정렬
  cols      : number  // 격자 열 4~14
  rows      : number  // 격자 행 4~32.  캔버스 비율 = cols/rows (셀 정사각 → aspectRatio 필드 불필요)
  cells     : string  // 방 모양 마스크 — 길이 cols*rows, 행 우선. '1'=방 안 / '0'=방 밖
                      //   클럽 홀이 직사각형이 아니라서(ㄱ자, 계단 옆이 파인 형태) 격자 안에서
                      //   실제 바닥만 남긴다. **빈 문자열 = 직사각형 방 전체**(앱이 둥근 카드로 그림)
                      //   ⚠ 길이가 cols*rows 와 다르면 앱이 **통째로 버린다**(= 전부 방 안).
                      //     격자를 바꾸면 마스크도 같이 옮겨야 한다 — 편집기가 remap 한다
                      //   ⚠ 전부 '1'이거나 전부 '0'인 마스크도 버린다(각각 '없는 것'과 같고, 바닥 0은 그릴 게 없음)
                      //   테이블은 방 안에만 둔다(편집기가 막음). 구조물은 경계에 걸쳐도 된다(벽·계단)
  fixtures  : array   // 구조물 [{ id, type, label, col, row, colSpan, rowSpan }] — 탭 대상 아님, 최소 1칸
                      //   type: stage|dancefloor|bar|dj|entrance|restroom|stairs|wall|etc
                      //   ⚠ 앱이 모르는 type은 조용히 버린다(영문 키 노출 방지 — facilities와 같은 규칙)
                      //   ⚠ 색·아이콘은 **타입마다 고정**이고 업주가 못 바꾼다(kFixtureStyles).
                      //     클럽마다 무대 색이 다르면 색으로 알아보는 학습이 무너진다
                      //   label 비면 타입별 기본 문구
  tables    : array   // [{ id, tierKey, name, desc, col, row, colSpan, rowSpan, shape,
                      //     price, minPeople, minBottles, minSpend, note, isActive }]
                      //   col·row : 좌상단 셀(0부터) / colSpan·rowSpan : 점유 칸
                      //   shape   : 'rect' | 'circle' (모르는 값은 rect)
                      //   price·minSpend : **원 단위 int**. 0이면 '문의'
                      //     ⚠ 문자열 금지 — '100만원'/'100만'/'1000000'이 섞이면 정렬·비교가 불가능해진다
                      //     표기(100만 · 1,000,000원)는 presentation/common/table_price_format.dart 한 곳
                      //   isActive: false면 앱 노출 제외(공사중·시즌)
}
```
> 클럽 상세 '테이블' 섹션 + 테이블 가격표 화면 데이터 소스. **위치는 정수 그리드 셀**이다 —
> 소수 좌표를 안 쓰는 이유는 웹(업주 편집기)과 앱이 `col * width / cols`로 **반올림 여지 없이
> 같은 그림**을 그리고, 캔버스 비율이 `cols/rows`로 자동 도출되며(양쪽이 따로 지킬 `aspectRatio`가
> 없다), 겹침 판정이 셀 비교라 편집기가 원천 차단할 수 있고, 회전 개념이 사라지기 때문.
> 포기한 것은 비스듬한 홀·대각선 배치(격자를 늘려 근사).
> - **미니맵 비율 = `cols : rows`** — 셀이 정사각이라 칸 수의 비가 곧 배치도 모양이다.
>   가로로 긴 홀은 세로 칸을 줄여 만든다(편집기에 `3:1`~`1:2` 프리셋). 칸 크기를 정하는 건
>   **가로 칸뿐**이라(폭 ÷ cols) 상한도 거기에만 걸려 있다
> - 방 모양은 `cells` 마스크로 격자 안에서 깎는다. 직사각형이면 앱이 예전처럼 **둥근 카드**로,
>   깎였으면 **경계 변에만 외곽선**을 그어 하나의 방 윤곽으로 그린다(`_FloorPlatePainter`).
>   셀마다 사각형을 다 그리면 격자무늬로 보인다
> - ⚠ **열 최대 14 + 테이블 최소 2×2**가 짝을 이뤄 **탭 타겟 44px 하한**을 보장한다 —
>   가장 좁은 흔한 기기(iPhone SE 375)에서 섹션 좌우 20.w + 캔버스 안쪽 8.w 를 뺀 격자 폭
>   ≈321px ÷ 14열 ≈23px/셀 × 2칸 ≈46px. 기준 폭 393에선 48px.
>   **열을 더 늘리거나 캔버스 여백을 키우면 이 보장이 깨진다**(둘 다 셀 폭을 깎는다)
> - ⚠ **쓰기는 문서 전체 교체(set)** — 부분 update면 지운 테이블·층이 남는다. 배치도가 한 문서라
>   저장이 원자적이고 앱이 **반쯤 옮겨진 배치도**를 읽는 상태가 없다. 테이블마다 문서를 두면
>   앱 read N회 + 저장 비원자성 둘 다 생긴다
> - ⚠ **쓰기 주체는 업주(파트너) + 어드민** — 커스텀 클레임 `{ partner: true, clubIds: [...] }`.
>   부여/회수는 `node scripts/set_partner_claim.js`. 앱은 읽기만
> - 파서(`data/models/club_table_layout.dart`)가 **null을 돌려주면 섹션 자체를 뺀다** —
>   문서 없음 / 테이블 0자리 / 모르는 `schemaVersion`. 빈 카드는 '테이블 없음'과 구분이 안 된다
>   (편의시설과 같은 규칙). 테이블 없는 층도 목록에서 뺀다
> - 쿼리는 단건 get뿐 → **인덱스 불필요**. 집계 필드 없음 → **Cloud Functions 트리거 불필요**
> - 샘플: `node scripts/seed_table_layout.js` (첫 클럽은 2층 — 층 전환 탭 확인용)
> - 편집: `node scripts/table_editor_server.js` → http://127.0.0.1:5599 (**로컬 테스트용**)
> - 상세 설계는 `firebase_structure.html#feature-tables`

#### clubs/{clubId}/photos/{photoId}
```
photoId         : string    // PK (Firestore 자동 생성)
clubId          : string    // FK → clubs
userId          : string    // 올린 사람 uid (seed 데이터는 "seed")
url             : string    // Storage 다운로드 URL
category        : string    // "venue"(업체) | "food"(음식) | "inside"(내부)
                            //   PhotoCategory enum — Firestore엔 영문키, UI는 한글 라벨 매핑
isHidden        : boolean   // 올린 사람이 탈퇴하면 true — 사진탭 조회·Rules 양쪽에서 빠진다.
                            //   ⚠ 새 문서에도 false를 반드시 쓸 것 (리뷰와 같은 이유).
                            //     현재 앱엔 사진 생성 경로가 없고 seed로만 들어온다
createdAt       : timestamp // 사진탭은 createdAt desc 정렬 → index 0이 최신
```
> 사진탭(detail_gallery_tab) 카테고리 필터의 데이터 소스. 칩별 count는 메모리 집계.
> 기존 `clubs.imageUrls` 배열을 마이그레이션(`scripts/seed_photos.js`)해 생성 — 카테고리는 round-robin 임의 배정(실제 분류 아님).

#### clubs/{clubId}/reviews/{reviewId}
```
reviewId        : string    // PK
clubId          : string    // FK → clubs
userId          : string    // FK → users
userName        : string    // 표시 이름 (임시 — 추후 users/{uid} 조회로 대체)
rating          : number    // 별점 0.5~5.0 (0.5 단위 — 리뷰 작성 페이지에서 반쪽 별 입력)
content         : string    // 리뷰 텍스트
imageUrls       : array     // 첨부 이미지 URL 목록 (최대 4장)
                            //   Storage 경로 reviews/{clubId}/{reviewId}/{index}.{ext}
tags            : array     // 선택한 추천 태그 (예: ["음악이 좋아요","사운드 최고"])
                            //   리뷰 작성 페이지 고정 8종 칩에서 선택. 없으면 빈 배열
isHidden        : boolean   // 작성자가 탈퇴하면 true — 클럽 리뷰 목록·평점 집계에서 빠진다.
                            //   집계 감산은 requestAccountDeletion이 직접 한다
                            //   ⚠ 새 리뷰에도 false를 반드시 써야 한다 (ReviewModel.toFirestore).
                            //     목록 쿼리가 where isHidden==false라 필드가 없으면 Firestore가
                            //     문서를 못 잡아 **방금 쓴 리뷰가 조용히 안 보인다**
                            //   ⚠ 클라 수정 금지(Rules) — 유저가 직접 켜면 목록에선 사라지는데
                            //     reviewCount는 남아 평점이 영구히 어긋난다
createdAt       : timestamp
updatedAt       : timestamp
```
> 클럽 상세 리뷰 탭 `reviewListProvider` 는 **1회 get(FutureProvider)** — 스트림이 아니다 (2026.09.15).
> 작성·수정·삭제가 성공하면 **호출부**(`renew_review_tab._openWritePage` · `my_reviews_screen` 의 수정·삭제)가
> `reviewListProvider(clubId)` 와 `myReviewCountProvider` 를 invalidate 한다(남이 쓴 리뷰는 재진입 때).
> ⚠ ViewModel 안에서 하면 안 된다 (2026.09.16) — `reviewViewModelProvider` 는 autoDispose 인데 작성 화면이
> `ref.read(.notifier)` 로만 잡아 await 가 끝나면 이미 dispose 돼 `ref.mounted == false` 라 invalidate 가 죽은 코드가 된다.
> 마이페이지 '내 리뷰 관리'는 `collectionGroup('reviews') where userId== orderBy(createdAt desc)`
> 크로스-클럽 조회 사용 (`firebase_review_datasource.watchUserReviews`). 마이페이지 통계 칸의
> 리뷰 수는 `myReviewCountProvider` = `count()` 집계 1회(문서를 안 내려받는다).
> 인덱스: `reviews COLLECTION_GROUP (userId ASC, createdAt DESC)`.
> Rules: collectionGroup 쿼리는 중첩 match가 안 먹혀 `match /{path=**}/reviews`로
> 본인 리뷰 읽기만 별도 허용 (쓰기는 기존 clubs/.../reviews 규칙 그대로).

#### nicknames/{key}
```
(문서 ID)       : string    // key = 닉네임을 소문자로 접은 값. **문서의 존재 자체가 예약**이다
                            //   같은 ID로 두 번 만들 수 없다는 성질이 곧 유일성 (Firestore엔 unique 제약 없음)
                            //   ⚠ 소문자로 접는 이유 — VYBE 와 vybe 를 다른 닉네임으로 두면 사칭이 쉽다.
                            //     화면에 보이는 값은 원본 대소문자를 지킨 users.nickname
uid             : string    // 이 닉네임을 쓰는 유저. 필드는 이것 하나뿐
```
> 닉네임 유일성 전용. **클라는 read 도 못 한다** (Rules `allow read, write: if false`) —
> 존재 여부를 물어볼 수 있으면 닉네임을 열거할 수 있고, 중복 판정은 `updateUserProfile` 이
> 트랜잭션 안에서 한다. 조회용이 아니라 충돌 검출용이라 **인덱스 불필요**(문서 ID로만 접근).
> ⚠ 닉네임이 곧 문서 ID라 Firestore ID 제약을 받는다 — 그래서 허용 문자에서 `_` 를 뺐다
> (`__foo__` 는 예약 패턴이라 쓰기가 거부된다). 한글·영문·숫자만 받으면 `/`·`.` 까지 통째로 막힌다.
> ⚠ 예약 회수는 **파기(`purgeDeletedUsers`) 때만** — 탈퇴 요청 시점에 풀면 보관 기간 안에
> 복구한 계정이 그사이 남이 가져간 닉네임을 되찾을 수 없다.

#### favorites/{favoriteId}
```
favoriteId      : string    // PK
userId          : string    // FK → users
clubId          : string    // FK → clubs (favoriteCount 자동 연동)
isHidden        : boolean   // 찜한 사람이 탈퇴하면 true. 찜은 본인만 읽어 '노출' 이슈는 없고,
                            //   favoriteCount에서 이미 뺐다는 표시 = 파기 때 이중 감산 방지
createdAt       : timestamp
```

#### users/{uid}/searchHistory/{historyId}
```
historyId       : string    // PK = SearchHistoryModel.idFor(keyword) = base64url(keyword.trim()) (2026.09.15)
                            //   같은 검색어는 한 자리를 덮는다(upsert). 예전 where 쿼리(1 read) + 삭제 batch 폐기
                            //   ⚠ Rules 가 update 를 안 열어 delete → set 두 번으로 쓴다(read 0). update 를
                            //     열면 set 한 번으로 줄일 수 있다
userId          : string    // FK → users
keyword         : string    // 검색어
createdAt       : timestamp
```
> 검색 뒤 목록 재조회 **없음** — `SearchHistoryNotifier.addLocal` 이 메모리에서 맨 앞으로 옮긴다
> (검색마다 20 reads 이던 invalidate 폐기, 검색 탭·주변 지도 검색 둘 다). 목록이 안 떠 있으면
> `ref.exists` 로 걸러 만들지도 않는다. 도입 전 자동 id 문서가 같은 검색어로 남을 수 있어
> `getSearchHistory` 가 읽을 때 검색어별 최신만 남기고 **이미 읽은 중복 문서는 batch 로 지운다**(추가 read 0,
> 2026.09.16). 숨기기만 하면 keyed 칩을 지운 뒤 재조회에서 숨겨졌던 자동 id 문서가 되살아나 두 번 지워야 했다.

#### banners/{bannerId}
```
bannerId        : string    // PK (= doc.id fallback)
imageUrl        : string    // 배너 이미지 URL — 권장 원본 1026 x 600 px (비율 1.71:1, 아래 참고)
linkType        : string    // "notice" | "club" | "page" | "url" — 탭 시 이동 방식
                            //   BannerLinkType enum. 알 수 없는 값은 none(이동 없음)으로 폴백
linkValue       : string    // 링크 대상 값
                            //   notice: noticeId / club: clubId / page: 화면 키 / url: URL
order           : number    // 정렬 순서 (오름차순)
isActive        : boolean   // 노출 여부
startAt         : timestamp // 노출 시작
endAt           : timestamp // 노출 종료
createdAt       : timestamp
```
> 홈 배너 데이터 소스. `firebase_banner_datasource.getActiveBanners()`는
> `isActive=true` 쿼리 후 클라이언트에서 `startAt < now < endAt` 필터 + `order` 정렬.
> 탭 라우팅은 `core/navigation/banner_link_handler.dart` 한 곳에서 `linkType`으로 분기.
> 광고 페이지는 전체화면이라 `pushHidingNavBar`로 열어 하단 nav 바를 내린다(돌아오면 복원).
> **연결된 건 `notice` 하나** — club·page·url은 미연결이라 조용히 무시된다
> (잘못된 곳으로 보내는 것보다 낫다).
> **현재 운영 배너 5건은 전부 `notice`** (2026.08.24) — 광고 글을 공지사항에 같이 쌓아
> 배너로 본 광고를 공지 목록에서 다시 찾을 수 있게 목적지를 하나로 합쳤다.
> 진입점은 `openNoticeDetail()`(`my_page/notice_detail_route.dart`) — 배너는 모델이 없어
> `noticeProvider(noticeId)`로 문서 1건을 조회한 뒤 `NoticeDetailScreen`을 띄운다
> (목록에서 탭한 경로는 이미 받은 모델을 그대로 넘겨 **조회 0회**).
> 구 `promotion` 경로(promotions 컬렉션 + 전용 화면)는 **삭제됐다** — 위 '홈 배너 → 공지사항 상세' 참고.

##### 배너 이미지 규격 (2026.08.21)

카드 실측은 `home/widgets/home_banner.dart` — 높이 `200.h`, 폭 = 화면폭 × 0.9
(`PageController(viewportFraction: 0.9)`) − `12.w`(좌우 패딩 6+6), `BoxFit.cover`.
기준 393×852에서 **342 × 200 logical px = 비율 1.71:1**.

| 항목 | 값 |
|------|------|
| 권장 원본 | **1026 × 600 px** (3x). 더 선명히 하려면 1368 × 800 (4x, 같은 비율) |
| 포맷·용량 | JPEG 또는 WebP, 300KB 이하 |
| 상하 안전영역 | 위·아래 각 **9%(1026×600 기준 54px) 잘릴 수 있음** — 글자·로고는 그 안쪽에 |
| 우하단 회피 | `1 / 4` 카운터 pill이 덮는다 — 오른쪽 아래 약 110 × 40px 비울 것 |
| 하단 45% | 앱이 검정 그라데이션(`0xC708080C`)을 덮는다 → **밝은 글자**를 쓸 것 |

⚠ **기기마다 카드 비율이 달라진다** — `.w`(가로 비)와 `.h`(세로 비)가 따로 스케일돼
폭과 높이가 다른 계수로 늘어난다. iPhone SE(375×667)에서 **2.08:1**로 가장 납작해지고
iPhone 15·15 Pro Max는 1.71:1. `cover`라 납작한 기기에서 위아래가 잘리므로
안전영역 9%는 **SE 기준**이다.

⚠ 이 비율은 **홈 배너 전용**이다. 배너 이미지는 광고 공지(`notice_ad_*`)의 첨부 사진으로도
그대로 쓰이는데, 공지 본문 첨부는 폭에 맞춰 늘리는(`BoxFit.fitWidth`) 자리라 잘리지 않는다.

#### appConfig/{platform}  — 문서 2개 고정 (android · ios)
```
platform           : string    // "android" | "ios" (= doc.id)
minVersion         : string    // 이 버전 미만이면 강제 업데이트(앱 사용 차단). 비면 강제 없음
latestVersion      : string    // 이 버전 미만이면 업데이트 권유(닫을 수 있는 시트). 비면 권유 없음
storeUrl           : string    // 스토어 링크 — 앱 배포 없이 바꿀 수 있게 서버에 둔다
                               //   비면 Android만 market://details?id={packageName}로 폴백
updateTitle        : string    // 업데이트 안내 제목. 비면 화면 기본 문구
updateMessage      : string    // 업데이트 안내 본문. 비면 화면 기본 문구
isMaintenance      : boolean   // 점검 모드 — 버전과 무관하게 진입 차단 (버전보다 우선)
maintenanceMessage : string    // 점검 안내 문구. 비면 기본 문구
updatedAt          : timestamp
```
> 앱 버전 게이트 데이터 소스. **top-level** — 유저·클럽에 종속 안 되는 전역 설정.
> **쓰기는 어드민 페이지(별도 구축 예정) 전용 — 앱은 읽기만.**
> 앱 실행 시 `appConfig/{platform}` **문서 1건만** get → 인덱스 불필요, 집계 없음 →
> Cloud Functions 트리거 불필요. seed(초기값): `scripts/seed_app_config.js`.
> **판정 3단계** — ① `isMaintenance`(점검) ② `minVersion` 미만(강제) ③ `latestVersion` 미만(권유).
> 판정은 `decideVersionAction()`(`core/utils/version_utils.dart`) 한 곳에만 두고,
> 비교는 파트 단위 숫자 비교라 `1.10.0 > 1.9.0`이 올바르게 나온다(문자열 비교 금지).
> 빌드번호(`+7`)·프리릴리스(`-beta1`)는 무시 — 스토어에 노출되는 건 버전명이므로
> **핫픽스도 patch를 올려야** 게이트가 인식한다.
> ⚠ **Android/iOS 문서를 나눈 이유** — 스토어 심사·배포 시점이 달라 한쪽만
> `minVersion`을 올릴 수 있어야 한다.
> ⚠ **fail-open** — 네트워크 실패·3초 타임아웃·문서 없음·버전 미상은 전부 통과시킨다.
> 서버 사고로 전 유저 앱이 잠기는 쪽이 업데이트를 한 번 놓치는 것보다 훨씬 큰 사고다.
> 예외를 삼키는 곳은 `VersionCheck` 뷰모델 **한 곳뿐** — datasource는 그대로 던진다.
> ⚠ **Rules에서 read에 auth 조건을 걸지 않는다** — 게이트는 **로그인 전**에 읽는다.
> auth를 요구하면 비로그인 유저가 강제 업데이트·점검 안내를 영영 못 받는다.

##### appConfig 운영 주의사항
값 하나로 전 유저를 막을 수 있는 문서다. 어드민 편집 UI를 만들 때도 이 규칙을 따를 것.

| 상황 | 해야 할 것 / 하면 안 되는 것 |
|------|------|
| 강제 업데이트 켜기 | **새 빌드가 스토어에 실제 게시된 것을 확인한 뒤** `minVersion`을 올린다. **심사 중에 미리 올리면 심사자 기기가 차단 화면에 막혀 리젝**된다. Android 단계적 출시(%) 중이면 100% 도달 후 |
| 잘못 올렸을 때 | `minVersion`을 빈 문자열로 되돌리면 **즉시 해제** — 앱 재배포 불필요. 유저 기기 반영은 다음 실행 또는 백그라운드 복귀 시점 |
| 반영 시점 | 앱 **실행 시** + **복귀(resumed) 시**에만 조회. 앱을 켜 둔 채 화면만 옮기는 동안엔 반영 안 됨 (사용 중 갑자기 차단되지 않게 한 의도된 동작) |
| 점검 모드 | `isMaintenance=true`는 **최신 버전 유저까지 전원 차단**. 끄면 '다시 시도' 버튼으로 즉시 복귀 |
| 버전 값 형식 | `"1.2.0"` 숫자·점만. 빌드번호(`+7`)·프리릴리스(`-beta1`)는 **무시**되므로 **핫픽스도 patch를 올려야** 구분된다. `pubspec.yaml`의 `version:`과 스토어 버전명이 일치해야 판정이 맞는다 |
| 문서 삭제 금지 | 문서가 없으면 게이트가 **항상 통과**(fail-open) = 사실상 꺼짐. 끄고 싶으면 **문서를 지우지 말고 필드를 비운다** |
| storeUrl | 비면 **Android만** `market://details?id={설치된 packageName}` 폴백. **iOS는 폴백 없음** — App Store 등록 후 `https://apps.apple.com/kr/app/id{앱ID}` 필수 |
| 오프라인 유저 | Firestore `get()`이 캐시본을 주거나 3초 타임아웃 → **둘 다 통과**. 오프라인에선 강제 업데이트가 걸리지 않는다 (의도된 fail-open) |
| 쓰기 권한 | Custom Claim `admin: true`만. 어드민 페이지 전까진 `scripts/seed_app_config.js` 또는 콘솔에서 직접 수정 |

#### vybeRecommendations/{recId}
```
recId           : string    // PK (= doc.id fallback)
clubId          : string    // FK → clubs. 클럽 기본 정보(이름·평점·영업시간 등)는
                            //   clubId로 clubs에서 조인해 사용 (여기엔 에디토리얼 필드만)
rank            : number    // 추천 순위. 1 = featured(NO.1 PICK 히어로), 나머지는 순위 리스트
match           : number    // VYBE 매치 % (큐레이션 적합도)
reason          : string    // 큐레이터 노트 (추천 사유)
tags            : array     // 큐레이션 태그 override (비면 club.tags 사용)
weekOf          : timestamp // 주간 식별 (매주 화요일 업데이트)
isActive        : boolean   // 노출 여부
createdAt       : timestamp
```
> VYBE 추천 페이지 데이터 소스.
> `firebase_vybe_recommendation_datasource.getActiveRecommendations()`는
> `isActive=true` + `orderBy(rank)` 쿼리. clubs 컬렉션을 참조하고 페이지 전용
> 에디토리얼 필드(rank·match·reason·tags)만 보관 — 클럽 기본 정보는 clubId로 조인.
> 첫 항목(rank 1) = featured 히어로, 나머지 = 순위 리스트.

#### performances/{performanceId}
```
performanceId   : string    // PK (= doc.id)
clubId          : string    // FK → clubs. 클럽 기본정보(평점·영업·썸네일)는 clubId로 조인
clubName        : string    // 비정규화 — rail/hero에서 조인 없이 표시
clubArea        : string    // 비정규화 — 지역 표시/필터
genre           : string    // "힙합" 등 — 장르 페이지 공통 (EDM·K-POP 동일 구조 재사용)
artistName      : string    // 헤드라이너/라인업 (예: "YANO"). 아티스트는 별도 컬렉션 없이 임베드
artistType      : string    // "rapper" | "dj"  (rail 아이콘 Mic/Disc 분기)
startAt         : timestamp // 공연 시작 시각 — 시간순 정렬 + "오늘 22:00 공연" 표시
date            : string    // "YYYYMMDD" — 날짜 버킷 쿼리용 (멀티-날짜 저장 핵심)
isFeatured      : boolean   // true = Hero 캐러셀 노출 / false = rail만
isActive        : boolean   // 노출 여부
createdAt       : timestamp
```
> 장르 페이지(힙합 등) 공연 일정 데이터 소스. **top-level** 컬렉션 — DJ rail·hero가
> "오늘 모든 힙합 클럽 공연을 시간순"으로 가져오는 크로스-클럽 쿼리이기 때문(서브컬렉션이면 collectionGroup 필요).
> 문서 1개 = (클럽 × 날짜 × 공연). 같은 클럽이 여러 날 공연하면 doc 여러 개(clubId 동일, date·startAt 상이) → 멀티-날짜 저장.
> 쿼리: `genre== + date==<today YYYYMMDD> + isActive==true orderBy(startAt asc)` → hero=isFeatured만 / rail=전체.
> ⚠ **`isActive` 를 쿼리에서 빼면 안 된다 (2026.08.28 수정)** — 배포된 인덱스가
> `(genre, date, isActive, startAt)` 이라, `isActive` 없이 `orderBy startAt` 만 걸면 정렬 필드
> 앞에 제약 없는 `isActive` 가 끼어 **인덱스를 못 탄다**(`FAILED_PRECONDITION`).
> 뷰모델이 이 예외를 삼켜(그리드는 살려야 하므로) 힙합·EDM 둘 다 **공연 일정이 조용히 빈
> 화면**이었다. 전 문서가 `isActive: true` 라(633/633) 쿼리에 넣어도 누락 없음.
> 포스터 그리드의 live·lineup은 오늘 공연 목록을 clubId로 머지해 도출(클럽에 저장 안 함 — 날짜 지나면 자동 무효).
> 인덱스: `performances(genre, date, isActive, startAt)`(배포본·`firestore.indexes.json` 일치).
> seed: `scripts/seed_performances.js`(힙합 오늘/내일) ·
> `scripts/seed_performances_july.js`(7월 전 클럽) · **`scripts/seed_performances_sep.js`(현행 — 2026.08.28 실행)**.
> - `seed_performances_sep.js` — 실행일~9/30, **장르 힙합·EDM 클럽 52곳만**(나머지 112곳은 공연 없음).
>   힙합은 `artistType` dj+rapper 혼합(2팀 이상이면 양쪽 최소 1팀), **EDM은 dj만**.
>   ⚠ 공연일은 **클럽 영업일 안에서만** 잡는다 — DB의 클럽이 전부 목·금·토만 열어서,
>   '주 2일 휴무'를 달력 그대로 적용하면 문 닫은 날 공연이 잡힌다. 대신 **목·금·토 중 매주
>   랜덤 1일을 휴무**로 빼 주 2일 공연이 된다(영업일이 3일 미만인 부분 주는 휴무 없음).
>   ⚠ 전 요일 영업인 예외 클럽 1곳 때문에 월·화·수·일이 후보일에 섞이면 휴무일 추첨이
>   아무도 안 여는 날에 걸려 무의미해진다 → **대상 클럽의 25% 이상이 여는 요일만** 후보로 본다.
>   난수는 전부 `clubId`·날짜 해시 기반이라 **재실행해도 같은 결과**(멱등, 잔여 doc 없음).
>   `--dry` 확인만 · `--purge` 기존 문서 전삭제 후 재작성.
>   실행 결과(2026.08.28): 공연일 10일(8/28·29, 9/4·5·10·11·17·19·25·26) / **doc 633개**
>   (힙합 rapper 132 + dj 127, EDM dj 374) / hero `isFeatured` 30건.
> ⚠ favoriteCount·rating 같은 집계 없음 → Cloud Functions 트리거 불필요(live/lineup은 클라 머지 계산).

#### notices/{noticeId}
```
noticeId    : string     // PK (= doc.id fallback)
title       : string     // 공지 제목
content     : string     // 본문 plain text. \n 줄바꿈 그대로 렌더 (마크다운/HTML 파싱 안 함)
imageUrls   : array      // 첨부 사진 URL 0~n장 — Storage notices/{noticeId}/{index}.{ext}
category    : string     // "notice" | "update" | "event" | "maint" | "ad" — 목록 배지
                         //   배지 색: 공지=흰색 / 업데이트=보라 / 이벤트=라임 / 점검=옐로 / 광고=스카이블루
                         //   알 수 없는 값이면 '공지'로 폴백
isPinned    : boolean    // 상단 고정 (정렬은 클라 메모리에서 처리)
isActive    : boolean    // 게시 상태 — true: 게시 / false: 게시중단.
                         //   게시중단이면 게시 기간 안이어도 노출 안 됨 (기간보다 우선)
publishedAt : timestamp  // 게시 시작 시각 = 목록 정렬 키 (createdAt과 분리 → 예약/소급 게시)
                         //   미래 시각이면 그 시각이 될 때까지 노출 안 됨
endAt       : timestamp? // 게시 종료 시각. 없으면(null) 무기한 게시
                         //   지나면 문서를 지우지 않고 목록에서만 사라짐
authorName  : string     // 표시 작성자 (기본 "VYBE 운영팀")
createdAt   : timestamp
updatedAt   : timestamp
```
> 마이페이지 '계정 → 공지사항' 데이터 소스. **top-level** — 클럽·유저에 종속 안 되는
> 전역 콘텐츠(banners와 동급). **쓰기는 어드민 페이지(별도 구축 예정) 전용 — 앱은 읽기만.**
> **홈 배너의 목적지이기도 하다 (2026.08.24)** — `banners.linkType='notice'` 인 배너를 탭하면
> `openNoticeDetail(noticeId)`가 `getNotice` 1건을 조회해 같은 공지 상세를 띄운다.
> 광고 글이 공지 목록에도 남아 배너가 내려간 뒤에도 찾아볼 수 있다.
> 배너용 광고 공지는 `notice_ad_*` id를 쓰고 첨부 사진에 배너 이미지를 그대로 넣는다.
> 쿼리: `where isActive==true + where publishedAt <= now orderBy publishedAt desc limit 50`.
> 인덱스: `notices(isActive ASC, publishedAt DESC)` — `publishedAt <= now`는 정렬 키와
> 같은 필드라 **기존 인덱스로 그대로 처리**된다(추가 인덱스 불필요).
> **노출 조건 3가지** — ① `isActive==true`(게시상태) ② `publishedAt <= now`(게시 시작)
> ③ `endAt == null || endAt > now`(게시 종료). 판정은 `NoticeModel.isVisibleAt(now)` 한 곳에만 둔다.
> ⚠ `endAt`은 **메모리에서 필터** — 서로 다른 필드에 범위 조건을 하나 더 걸면 복합 인덱스가
> 추가로 필요한데 공지 건수가 적어 얻는 게 없다. 대신 `limit`이 종료된 공지까지 세므로
> 실제 노출 건수가 limit보다 적어질 수 있다.
> ⚠ 게시 기간은 **Rules에 넣지 않는다** — 클라 시계가 서버보다 조금이라도 앞서면 쿼리 범위가
> `request.time`을 넘어 목록 전체가 permission-denied가 된다. Rules는 `isActive`만 막는다
> (게시중단 공지는 문서 ID를 알아도 못 읽음. 예약 공지는 ID를 알면 읽힐 수 있음 — 앱 경로에선
> `getNotice`가 같은 기준으로 null 처리).
> ⚠ `isPinned`는 서버 orderBy에 넣지 않고 받아온 뒤 메모리에서 위로 올린다 — 공지 건수가
> 적어 3필드 인덱스를 유지할 이유가 없고, 정렬 규칙을 바꿔도 인덱스 재배포가 불필요.
> ⚠ **읽음 상태는 저장하지 않는다.** `users/{uid}/noticeReads` 방식은 공지 열 때마다 write가
> 발생 → 베타 규모에 과함. 목록 `NEW` 배지는 `publishedAt`이 7일 이내인지로만 판정.
> 집계 필드 없음 → Cloud Functions 트리거 불필요. seed(샘플): `scripts/seed_notices.js`.

#### inquiries/{inquiryId}
```
inquiryId   : string     // = doc.id (문서 필드로도 저장 — Rules 화이트리스트에 포함)
userId      : string     // FK → users. 목록 쿼리·Rules 판정 기준
userName    : string     // 표시 이름 비정규화 — 어드민은 users 문서를 못 읽는다(read: 본인만)
category    : string     // "service"|"bug"|"report"|"account"|"etc" — **영문 키만** 저장
                         //   한글 라벨·아이콘 대응은 앱 `InquiryCategory` enum
                         //   (presentation/support/support_models.dart) 단일 소스.
                         //   모르는 키는 '기타'로 폴백 (facilities와 같은 규칙)
title       : string     // 제목 2~50자 (Rules가 길이 검사)
content     : string     // 본문 10~1000자 (Rules가 길이 검사)
imageUrls   : array      // 첨부 사진 URL 0~4장 — Storage inquiries/{uid}/{inquiryId}/{index}.{ext}
status      : string     // "pending" | "answered" — 생성 시 반드시 'pending'
                         //   ⚠ 새 문서에 반드시 써야 한다 (ReviewModel의 isHidden과 같은 이유) —
                         //     배지·목록 판정이 필드가 있다는 전제로 돌고 Rules가 값까지 검사한다
answer      : string     // 운영자 답변 본문. 생성 시 반드시 '' (빈 문자열)
answeredAt  : timestamp? // 답변 등록 시각. 미답변이면 null
answeredBy  : string     // 답변한 어드민 uid. 미답변이면 ''
readAt      : timestamp? // 사용자가 답변을 확인한 시각. null이면 미확인 = 배지 대상
                         //   **사용자가 쓸 수 있는 유일한 필드**(Rules update 화이트리스트)
createdAt   : timestamp
updatedAt   : timestamp
```
> 고객센터 데이터 소스. **top-level** — 유저·클럽에 종속되지 않고 어드민이 전체를 훑는다
> (서브컬렉션이면 collectionGroup 쿼리가 필요하다).
> 앱 쿼리: `where userId== orderBy createdAt desc limit 50` **스트림** —
> 운영자가 답변을 달면 목록이 바로 '답변완료'로 바뀐다.
> 운영자(어드민 클레임) 쿼리: 전체 `orderBy createdAt desc` / 미답변 `where status=='pending' + orderBy createdAt desc`.
> 인덱스: `inquiries(userId ASC, createdAt DESC)` · `inquiries(status ASC, createdAt DESC)`.
> 집계 필드 없음 → **Cloud Functions 트리거 불필요**. 답변은 운영자가 직접 쓴다
> (현재는 Firebase 콘솔. 어드민 UI 는 미구축).
> ⚠ **읽음 상태(`readAt`)는 공지와 달리 서버에 둔다** — 공지는 열 때마다 write가 생겨 안 뒀지만,
> 문의는 사용자당 문서가 몇 건이고 '안 본 답변' 배지가 기능의 핵심이라 기기 간에 맞아야 한다.
> 쓰기는 답변 도착 후 상세를 처음 열 때 **1회**.
> ⚠ **답변 필드는 앱이 못 고친다** — Rules가 사용자 update를 `readAt` 한 키로 제한한다.
> 안 막으면 스스로 '답변완료'로 바꾸거나 답변 문구를 지어낼 수 있다.
> ⚠ **문의 삭제는 어드민만** — 사용자가 지우면 답변 이력이 사라져 분쟁 때 근거가 없다.
> ⚠ 스팸 제한은 **앱에서만** 건다(답변 대기 5건 이상이면 작성 차단) — Rules로는 건수를 셀 수 없다.
> 서버 제한이 필요해지면 onCall 함수로 옮긴다.

#### searchLogs/{logId}
```
logId       : string    // PK (auto)
keyword     : string    // 정규화된 검색어 (선행 '#' 제거·연속 공백 축약·2~30자, 대소문자 보존)
userId      : string    // == request.auth.uid
source      : string    // 'input' | 'suggestion' | 'hashtag' | 'trend' | 'history'
                        //   ⚠ 2026.09.15 부터 **랭킹 대상(input · suggestion)만 쓴다** — logSearch 가
                        //     비랭킹 소스는 write 전에 돌아간다(집계가 안 세는 로그에 write 를 내지 않는다).
                        //     'map' 값은 삭제(지도 모드 제출도 input)
createdAt   : timestamp // serverTimestamp
expireAt    : timestamp // createdAt + 14d — Firestore TTL 정책이 자동 삭제
```
> 인기 검색어 집계 원본. **클라는 create만, 읽기는 Admin SDK(집계 함수) 전용**.
> 쓰기 지점은 `SearchViewModel.search()` + 화면의 예외 경로(지도 모드 제출, 연관 검색어→클럽 직행).
> `SearchSource.ranked` 가 서버 `RANKED_SOURCES` 와 같은지는 `test/search_source_test.dart` 가 지킨다.
> ⚠ **`source`가 설계 핵심** — 트렌드/해시태그 칩 탭 유입을 집계에 넣으면 1위가 계속 1위가 되는
> 되먹임이 생긴다. 랭킹은 `input`/`suggestion`만 카운트(`RANKED_SOURCES`).
> ⚠ 랭킹 기준은 raw count가 아닌 **고유 userId 수** — 1인이 반복 검색해도 1표(스팸·자기증폭 방지).
> ⚠ 비로그인 검색은 Rules상 로깅 안 됨.
> 인덱스 불필요(`createdAt` 단일 필드 = 자동 인덱스). `source`는 메모리 필터.
> TTL 정책은 콘솔/gcloud로 별도 설정 — `firestore.indexes.json`으로는 설정 안 됨.

#### searchTrends/{docId}  — 문서 2개 고정
```
// searchTrends/current — 집계 스냅샷. 앱은 이 문서 1개만 읽는다 (read 1회)
items       : array     // [{ rank, keyword, status, change, uniqueUsers }]
                        //   status: 'up'|'down'|'newEntry'|'same' (직전 스냅샷 대비)
                        //   uniqueUsers: 0이면 fallback으로 채운 자리 (실데이터 아님)
realCount   : number    // 실데이터로 채워진 항목 수
sampleSize  : number    // 집계에 쓰인 로그 건수 (디버깅용)
windowHours : number    // 집계 윈도우 (기본 24)
runKey      : string    // KST yyyyMMddHH — 중복 실행 방어
updatedAt   : timestamp // UI '07.31 22:00 기준' 표기 소스

// searchTrends/fallback — 어드민 큐레이션 백업 목록
items       : array     // [{ rank, keyword }] — 실데이터 부족 시 뒷자리를 채움
```
> ⚠ **fallback으로 채운 항목엔 증감을 표시하지 않는다** (`uniqueUsers == 0` → `TrendRow`가 숨김).
> 유저가 없는데 순위가 오르내리는 것처럼 보이면 안 되므로.
> `realCount == 0`이면 섹션 제목도 '실시간 인기 검색어' 대신 '인기 검색어'.

#### searchHashtags/{tagId}
```
tagId          : string    // = doc.id (seed: tag_<slug>)
label          : string    // '힙합' (UI 표시는 '#힙합')
linkType       : string    // 'keyword' | 'page'
linkValue      : string    // keyword: 검색어 / page: 화면 키
                           //   freeEntry|serviceDrinks|hipHop|hotPlaces|vybeRecommend
order          : number    // 큐레이션 기본 순서
popularityRank : number?   // 집계가 채우는 검색량 순위. null이면 order로 정렬
isActive       : boolean
createdAt      : timestamp
```
> 인기 해시태그 데이터 소스. **큐레이션 문서가 필수인 이유**: '입장료 무료'·'서비스 음료'·'힙합'은
> 검색어가 아니라 전용 화면(`FreeEntryScreen` 등)으로 가야 해서 검색 로그 자동 추출로는
> 라우팅을 만들 수 없다. banners의 `linkType`/`linkValue` 패턴 재사용.
> 정렬은 `popularityRank`(있는 것 우선) → `order`. **문서는 8개보다 많이 두고 상위 8개만 노출**해야
> 검색량에 따라 순서가 실제로 바뀐다. seed: `scripts/seed_search_hashtags.js`.
> ⚠ `popularityRank`는 집계 함수 소유 — seed 스크립트가 덮어쓰지 않음(updateMask에서 제외).

---

### Cloud Functions 목록

총 **16개** 함수 (`functions/src/index.ts` export 기준). Firebase 관련 서버 로직은 모두 Cloud Functions으로 처리.
구조: `functions/src/auth/` (6) · `account/` (2 + 공용 `account_common.ts` · `restore_account.ts`) ·
`profile/` (1 + 규칙 `nickname.ts`) · `favorites/` (2) · `reviews/` (3) · `performances/` (1) · `search/` (1) + `index.ts`.
(구 `search/onClubWritten`은 Algolia 전환으로 삭제 — 2026.07.19)

#### HTTP 요청 함수 (앱에서 직접 호출, `https.onCall`)

| 함수명 | 입력 | 출력 | 역할 |
|--------|------|------|------|
| `naverLogin` | `{ accessToken }` | `{ customToken, isNewUser, restored }` | 네이버 accessToken → Custom Token (`naver:{naverId}`) |
| `kakaoLogin` | `{ accessToken }` | `{ customToken, isNewUser, restored }` | 카카오 accessToken → Custom Token (`kakao:{kakaoId}`) |
| `phoneLogin` | `{ phone }` | `{ customToken, isNewUser, restored }` | 전화번호 기반 Custom Token (`phone:{phone}`) |
| `checkPhoneDuplicate` | `{ phone, method }` | `{ isDuplicate, sameAccount, pendingDeletion, purgeAt, restorable }` | 이 번호의 **주인이 지금 시도 중인 그 계정인지** 판정. `sameAccount=true`면 재로그인이라 통과, false면 다른 방식 가입이라 차단. 탈퇴 대기 계정은 **본인 + 파기 전**이면 통과(`restorable`), 그 외엔 차단 |
| `verifyIdentity` | `{ impUid }` | `{ verified }` | 본인인증 결과 검증 → phone/birthDate Firestore 저장 |
| `requestAccountDeletion` | `{ reason? }` | `{ purgeAt }` | 회원 탈퇴 — 리뷰·사진·찜 `isHidden=true` + 집계 감산 + Auth `disabled`. 삭제는 30일 뒤 |
| `updateUserProfile` | `{ nickname?, profileImageUrl? }` | `{ nickname, profileImageUrl }` | 닉네임 · 프로필 사진 저장. `nicknames/{key}` 예약 + `users` 갱신을 **트랜잭션 1회**로. **둘 다 없으면** 랜덤 닉네임 배정(가입 마지막), `profileImageUrl: ''` 는 기본 아바타로. 오류 `already-exists`(사용 중) · `invalid-argument`(형식·금칙어·남의 사진 경로 — `details.field` 동봉) · `failed-precondition`(가입 미완) |

> 로그인 3종(`naverLogin`·`kakaoLogin`·`phoneLogin`)은 Custom Token 발급 **전에**
> `restorePendingDeletionOnLogin(uid)`를 부른다 — 보관 기간(30일)이 **남아 있으면 계정을 되살리고**
> `restored: true`를 실어 보내고, 파기 시각이 이미 지났으면 `failed-precondition`(+`details.purgeAt: null`)로 막는다.
> Auth가 `disabled`인 채 토큰을 주면 앱의 `signInWithCustomToken`이 거부되므로 **발급 전에** 풀어야 한다.

#### 자동 트리거 함수

| 함수명 | 트리거 | 역할 |
|--------|--------|------|
| `onUserCreated` | Firebase Auth 신규 유저 생성 시 | users/{uid} 문서 자동 생성 (provider, createdAt). **⚠ 현재 실행 안 됨 (2026.08.18 확인)** — Custom Token 로그인으로 Auth 유저가 생겨도 호출 로그가 없다. `createdAt`은 앱(`setUserProfile`)이 쓰도록 옮겨 지금은 이 함수 없이도 동작. 원인 조사 필요 |
| `onFavoriteCreated` | favorites/{favoriteId} 생성 시 | clubs.favoriteCount += 1 (FieldValue.increment 사용) |
| `onFavoriteDeleted` | favorites/{favoriteId} 삭제 시 | clubs.favoriteCount -= 1 (0 미만 방지 처리 필요). **`isHidden==true`면 skip** |
| `onReviewCreated` | clubs/{clubId}/reviews/{reviewId} 생성 시 | ratingSum += rating, reviewCount += 1, rating = ratingSum / reviewCount |
| `onReviewDeleted` | clubs/{clubId}/reviews/{reviewId} 삭제 시 | ratingSum -= rating, reviewCount -= 1, reviewCount > 0이면 rating 재계산, 0이면 rating = 0. **`isHidden==true`면 skip** |
| `onReviewUpdated` | clubs/{clubId}/reviews/{reviewId} 수정 시 | ratingSum += (newRating - oldRating), rating = ratingSum / reviewCount. **`isHidden` 전이거나 이미 숨겨진 리뷰면 skip** |

> ⚠ **`isHidden` 가드가 왜 필요한가** — 탈퇴 시 집계 감산은 `requestAccountDeletion`이 **직접** 한다.
> `isHidden=true` 세팅은 문서 update라 `onReviewUpdated`가 발화하고, 30일 뒤 파기 때는
> `onReviewDeleted`·`onFavoriteDeleted`가 발화한다. 가드가 없으면 같은 리뷰가 **두 번 깎여**
> `rating`·`favoriteCount`가 음수가 된다.

#### 스케줄 함수 (Cloud Scheduler + Pub/Sub, Blaze 필요)

| 함수명 | 스케줄 | 역할 |
|--------|--------|------|
| `cleanupPastPerformances` | 매일 KST 04:00 | 종료된 공연 문서 삭제. `startAt < now - 8h`(PERFORMANCE_DURATION_HOURS)인 공연만 삭제 → 예정/진행 중(새벽) 공연 보존. 500개씩 배치 삭제 |
| `aggregateSearchTrends` | 매시 정각 KST (`0 * * * *`) | 검색 로그 집계 → `searchTrends/current` + `searchHashtags.popularityRank`. 매시 깨어나서 **갱신 대상 여부를 내부 판단**하고, 아니면 Firestore 접근 없이 즉시 종료 |
| `purgeDeletedUsers` | 매일 KST 04:30 | 보관 30일이 지난 탈퇴 계정 완전 파기 — Firestore 문서(리뷰·사진·찜·검색기록·users) + `nicknames/{key}` 예약 회수 + Storage 파일(`reviews/`·`users/`) + Auth 유저. 회차당 50명, 한 명 실패해도 다음으로 진행(다음 회차에 다시 잡힘) |

> 새벽 공연 보호 로직: 공연은 `startAt`(Timestamp) 후 최대 8시간 진행으로 가정(클럽 마감 ~06:00). 8시간 안 지난 공연은 "진행 중"으로 보존 → 오늘 밤 새벽 공연/어제 이어진 공연 안전. 마감 더 늦으면 `PERFORMANCE_DURATION_HOURS` 상수만 조정.

> **검색 트렌드 갱신 주기** (`scheduleDecision()` — `functions/src/search/compute_trends.ts`)
> | 구간 | 실시간 인기 검색어 | 인기 해시태그 |
> |------|------|------|
> | 야간 20:00~09:00 (9시 포함) | 매시 | 매시 |
> | 주간 10:00~19:00 | 2시간 (10·12·14·16·18) | 4시간 (12·16) |
>
> 주간 간격은 자정 기준 앵커(`hour % N`)라 **해시태그 갱신 시각은 항상 검색어 갱신 시각의 부분집합** →
> 로그 스캔 1회로 둘 다 처리한다. 클럽 검색이 밤에 몰리므로 야간을 촘촘하게 잡음.
> 중복 실행 방어: 스냅샷에 `runKey`(KST yyyyMMddHH) 저장 → 같은 시각 재실행 시 skip
> (안 막으면 증감이 방금 쓴 결과와 비교돼 전부 `same`으로 뭉개짐).

#### 구현 시 주의사항
- `favoriteCount`, `ratingSum`, `reviewCount`, `rating` 은 반드시 Cloud Functions으로만 업데이트 (직접 수정 금지)
- `ratingSum` / `reviewCount` 증감은 `FieldValue.increment()` 사용 (동시 요청 정합성 보장)
- `rating` 은 트랜잭션으로 `ratingSum / reviewCount` 계산 후 저장
- `onReviewDeleted` 에서 `reviewCount`가 0이 되면 `rating = 0` 처리 필요
- 네이버 UID 형식: `naver:{naverId}`
- `onUserCreated` 는 문서가 이미 존재하면 덮어쓰지 말 것 (중복 실행 방어)
- `cleanupPastPerformances` 는 `date`(YYYYMMDD)가 아닌 `startAt`(Timestamp) 기준으로 삭제 — 새벽 공연 오삭제 방지. 스케줄 함수라 Blaze 요금제 필요
- `nickname` · `profileImageUrl` 은 **`updateUserProfile` 만** 쓴다 (Rules가 클라 쓰기를 막는다). 닉네임 유일성 예약과 문서 갱신이 한 트랜잭션에 묶여야 해서 서버만 할 수 있다
- `purgeDeletedUsers` 는 **users 문서를 지우기 전에** `nickname` 을 읽어 둬야 한다 — 순서를 뒤집으면 예약 key 를 알 방법이 없어 그 닉네임이 영원히 잠긴다

---

### Security Rules

#### Firestore Rules 요약
| 컬렉션 | 읽기 | 쓰기 |
|--------|------|------|
| `users/{uid}` | 본인만 | 본인만 (uid / provider / createdAt / status / deletedAt / purgeAt / **nickname / profileImageUrl** 수정 불가 — `agreements`는 금지 키가 **아니다**: 본인의 동의 여부라 마케팅 수신 철회를 붙이려면 고칠 수 있어야 한다). create 에는 `nickname` 키 자체를 실을 수 없다 |
| `nicknames/{key}` | **불가** | **불가** — read·write 전면 차단(Admin SDK 전용). read 까지 막는 이유는 존재 여부를 물어볼 수 있으면 닉네임을 열거할 수 있어서다 |
| `clubs/{clubId}` | 누구나 (isActive=true만) | 어드민만 |
| `clubs/.../info`, `menus` | 누구나 | 어드민만 |
| `clubs/.../tableLayout` | 누구나 | 어드민 또는 **업주**(`partner:true` + `clubId in clubIds` 클레임). `clubId` 일치·`schemaVersion` 타입만 검사 — 셀 좌표는 Rules로 못 훑는다(반복문 없음) |
| `clubs/.../photos` | 누구나 (`isHidden != true`만) | 생성: 로그인 유저(본인 userId) / 삭제: 본인 또는 어드민 |
| `clubs/.../reviews` | 누구나 (`isHidden != true`만) | 생성: 로그인 유저 / 수정·삭제: 본인 또는 어드민 (**`isHidden` 수정 불가**) |
| `{path=**}/reviews` (collectionGroup) | 본인 리뷰만 | 불가 (마이페이지 내 리뷰 조회 전용) |
| `favorites` | 본인만 | 생성·삭제: 본인만 |
| `users/.../searchHistory` | 본인만 | 본인만 |
| `notices` | 누구나 (isActive=true만 — 게시 기간은 앱에서 필터) | 어드민만 (어드민 페이지 전용) |
| `inquiries` | 본인 문의만 (어드민은 전체 — 어드민 브랜치가 문서와 무관하게 참이라 무제약 list도 통과) | 생성: 로그인 유저(본인 userId, `status='pending'`·`answer=''` 고정, 제목 2~50·본문 10~1000자, 필드 화이트리스트) / 수정: 본인은 **`readAt`만**, 어드민은 전부 / 삭제: 어드민만 |
| `searchLogs` | **불가** (Admin SDK 전용) | 생성만: 로그인 유저(본인 userId, keyword 2~30자, 필드 화이트리스트). 수정·삭제 불가 |
| `searchTrends`, `searchHashtags` | 누구나 | 어드민만 |
| `appConfig/{platform}` | 누구나 (**auth 조건 금지** — 로그인 전에 읽는다) | 어드민만 (어드민 페이지 전용) |

> ⚠ **숨김 판정은 `resource.data.get('isHidden', false) == false`** — `resource.data.isHidden != true`로
> 쓰면 안 된다. Rules에서 **없는 필드에 직접 접근하면 평가가 에러로 떨어져 거부**되므로,
> 백필 전 문서(= 지금 전부)가 통째로 막힌다.

#### Storage Rules 요약
| 경로 | 읽기 | 쓰기 |
|------|------|------|
| `clubs/**` | 누구나 | 어드민만, 10MB 이하, 이미지만 |
| `reviews/**` | 누구나 | 로그인 유저, 10MB 이하, 이미지만 |
| `users/{uid}/**` | 누구나 | 본인만, 5MB 이하, 이미지만 |
| `notices/**` | 누구나 | 어드민만, 10MB 이하, 이미지만 |
| `inquiries/{uid}/**` | **본인 또는 어드민만** (다른 경로와 달리 공개 아님 — 문의 사진은 개인 자료) | 본인만, 10MB 이하, 이미지만 |

> ⚠ **`allow write` 에 delete 를 같이 두지 말 것 (2026.09.15 수정·배포)** — 삭제 요청엔
> `request.resource` 가 **null** 이라 `request.resource.size`·`contentType` 을 보는 순간
> 평가가 에러로 떨어져 **본인 파일도 못 지운다**(`[firebase_storage/unauthorized]`).
> 프로필 사진을 바꿀 때마다 옛 파일이 고아로 남던 원인 — 삭제 실패는 앱이 삼켜서
> (`deleteFileByUrl`) 화면은 멀쩡하고 로그에만 보인다. 그래서 전 경로를
> `allow create, update`(용량·타입 검사) + `allow delete`(주체만 검사)로 쪼갰다.

#### 어드민 권한 설정
```typescript
// Admin SDK로 Custom Claim 부여
admin.auth().setCustomUserClaims(uid, { admin: true })

// Rules에서 확인
request.auth.token.admin == true
```

---

### Firebase Storage 경로 구조

실제 구조 (더 베이스 `62VaHypRMWcCySNQZEaa` 기준). 확장자는 원본 따라 `.jpg`/`.png`/`.jpeg` 혼재.

```
clubs/{clubId}/thumbnail.jpeg               // 클럽 대표 이미지 (1장, 리스트 썸네일)
clubs/{clubId}/gallery/{n}.{jpg|png}        // 갤러리 이미지 (1.jpg, 2.png, … 순번)
                                            //   → heroImageUrls(상단 슬라이더)·imageUrls(사진탭) 둘 다 이 폴더 참조
clubs/{clubId}/menus/{menuId}.{jpg|png}     // 개별 메뉴 이미지
clubs/{clubId}/menus/boards/board_{n}.png   // 메뉴판 이미지 (menuBoardUrls)
reviews/{clubId}/{reviewId}/{index}.{ext}   // 리뷰 첨부 이미지 (0~3, 최대 4장)
users/{uid}/profile_{millis}.jpg            // 프로필 이미지 (업로드마다 새 이름)
                                            //   ⚠ 덮어쓰지 않는다 — URL이 그대로면 이미지 캐시·CDN이
                                            //     옛 사진을 계속 보여준다("바꿨는데 안 바뀐다")
                                            //   옛 파일은 저장이 성공한 뒤 deleteFileByUrl 로 지운다
notices/{noticeId}/{index}.{ext}            // 공지 첨부 이미지 (어드민 업로드)
inquiries/{uid}/{inquiryId}/{index}.{ext}   // 고객센터 문의 첨부 (0~3, 최대 4장)
                                            //   ⚠ 첫 칸이 uid — Rules가 이 자리로 소유자를 판정한다
                                            //     (리뷰는 clubId 자리라 헷갈리기 쉽다)
```

> **URL 토큰 차이**: `thumbnail`은 다운로드 토큰(`?alt=media&token=…`) 포함, `gallery`/`menus`는 토큰 없이 `?alt=media`만 → Storage 규칙 `clubs/** read: if true`(공개 읽기)에 의존.
>
> **사진탭 photos 서브컬렉션**: 현재 seed 데이터는 기존 `gallery/` URL을 재활용(별도 업로드 없음). 추후 유저 업로드 기능 추가 시 권장 경로 `clubs/{clubId}/photos/{photoId}.{ext}`.

---

## Notes for Claude

- 이 프로젝트는 **1인 개인 프로젝트**로, 단순하고 명확한 코드를 선호함
- 새 기능 추가 시 항상 **MVVM 레이어 분리**를 유지할 것
- Firebase 관련 코드는 반드시 `data/datasources/remote/`에만 작성할 것 (presentation/domain 레이어 Firebase import 절대 금지)
- presentation에서 현재 uid가 필요하면 반드시 `currentUidProvider` 사용 (`FirebaseAuth.instance` 직접 접근 금지)
- 새 datasource 메서드 작성 시 반드시 `logFirebaseAccess()` 호출할 것
- UI 코드에서 `ref.read` / `ref.watch` 외의 비즈니스 로직 금지
- `build_runner` 코드 생성이 필요한 파일(= **freezed 모델만**) 수정 시 반드시 안내할 것
- provider 는 손으로 선언한다 — `@riverpod` 을 새로 쓰지 말 것 (State Management 참고)
- UI 구현 시 디자인을 먼저 확인한 후 코드 작성할 것 — **v1 화면은 Claude Design 원본, 베타 화면은 Figma MCP**
- 모든 UI 수치는 반드시 **`flutter_screenutil`** 단위(`.w`, `.h`, `.sp`, `.r`)로 작성할 것
- 인증 관련 코드는 반드시 위의 **인증 플로우** 섹션을 먼저 참고할 것
- Firestore 문서 생성/수정 시 반드시 위의 **컬렉션 구조**를 따를 것
- `favoriteCount` 는 직접 수정 금지 — Cloud Functions 트리거로만 업데이트됨
- **화면에 사용자 이름을 띄울 때는 `users.nickname`** — `users.name` 은 본인인증으로 받은
  실명이라 남에게 보이는 자리에 쓰지 않는다. 닉네임이 비면 `kNicknameFallback`('VYBER')로
  떨어뜨릴 것 (`name` 으로 폴백하면 실명 노출이 되살아난다)
- `nickname` · `profileImageUrl` 은 Firestore 에 직접 쓰지 말 것 — `updateUserProfile`
  (Cloud Functions) 만 쓴다. Rules 가 클라 쓰기를 막아 조용히 403 이 난다
- `phone` 필드는 중복 가입 방지 기준 — 회원가입 시 반드시 `checkPhoneDuplicate` 로 확인할 것.
  **"이미 있는 번호 = 무조건 차단"이 아니다** — 같은 방식의 재로그인은 통과시킨다
- UI가 이미 구현된 화면 작업 시 디자인 확인 불필요, 로직 레이어만 작성할 것
- **v1 작업은 맨 위 ⭐ v1 개발 규칙이 최우선이다** — 특히:
  - v1 신규 기능은 datasource 인터페이스 + Fake/Firebase 두 구현. 교체는 provider 한 곳에서만
  - 금액 · 결제 결과 · 상태 · 순번 · 시간 구간은 서버(함수)에서만 확정, 클라는 금액을 보내지 않는다
  - 결제 · 회원가입/본인인증 신규 연동 · 알림톡/SMS · 계좌 실명 확인 등 외부 API는 구현하지 않는다 (스텁만)
  - 백엔드는 Emulator에서만, 사용자가 말하기 전엔 배포하지 않는다
  - 화면 ID를 doc 주석 · 커밋 메시지에 남기고, 작업마다 `docs/screen_map.md` · `docs/progress.md` 를 갱신한다
