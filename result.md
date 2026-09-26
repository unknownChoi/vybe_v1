# ponytail-audit 적용 결과 (2026-09-06)

`lib/` 의 Dart 코드만 대상. 과설계·중복 제거가 목적이고 기능 추가는 없다.

## 총계

| 항목 | 이전 | 이후 | 차이 |
|------|------|------|------|
| 손수 작성 (`lib`, 생성물 제외) | 54,866줄 | 53,643줄 | **−1,223** |
| 생성 코드 (`.g.dart` + `.freezed.dart`) | 9,512줄 | 5,166줄 | **−4,346** |
| `lib` 파일 수 | 435 | 373 | **−62** |
| 패키지 의존성 | — | — | **−5** |

git 기준 **143 파일 변경 / +685 / −6,326**.

제거한 의존성: `cupertino_icons` · `flutter_spinkit` · `geoflutterfire_plus` ·
`riverpod_annotation` · `riverpod_generator`.

## 검증

- `dart analyze` — **에러 0**. 남은 info 3건은 전부 작업 전부터 있던 것
  (`renew_menu_tab` · `renew_photo_tab` import 정렬, `edm_time_row` 중괄호).
- `flutter test` — **295 통과 / 5 실패**. 실패 5건은 **작업 전 HEAD에서도 똑같이 실패**한다
  (`git stash` 로 확인). 이번 변경과 무관한 기존 실패:
  - `free_entry_screen_test.dart` 3건
  - `service_drinks_screen_test.dart` 2건
- `dart run build_runner build` — 정상. 이제 freezed만 돌아 **16 output / 11초**
  (이전에는 riverpod 생성까지 61개 파일).

---

## 항목별

### 1. riverpod 코드 생성 제거 (−4,346 생성줄, −2 dep)

`@riverpod` 선언 66개를 Riverpod 3 기본 provider로 바꾸고 `.g.dart` **45개를 삭제**했다.

```dart
// before
@Riverpod(keepAlive: true)
Future<List<BannerModel>> bannerList(Ref ref) => ...;   // + banner_viewmodel.g.dart 56줄

// after
final bannerListProvider = FutureProvider<List<BannerModel>>(_bannerList);

Future<List<BannerModel>> _bannerList(Ref ref) => ...;
```

- 함수형 40개 → `Provider` / `FutureProvider` / `StreamProvider`
  (`@riverpod` = `.autoDispose`, `@Riverpod(keepAlive: true)` = 기본).
  인자 있는 12개는 `.family<T, Arg>`.
- 클래스형 26개 → `class X extends Notifier<T>` 또는 `AsyncNotifier<T>` +
  `NotifierProvider` / `AsyncNotifierProvider`. **build 에 인자를 받는 notifier는 없어서**
  family notifier 변환은 필요 없었다.
- **호출부는 그대로다** — provider 이름(`xProvider`), family 호출(`xProvider(arg)`),
  `ref.read(xProvider.notifier)` 전부 동일. 선언부만 바뀌었다.

⚠ 손으로 맞춰야 했던 3곳:
- 코드 생성기는 클래스명 끝의 `Notifier` 를 **떼고** provider 이름을 만든다 →
  `UserLocationNotifier` → `userLocationProvider`, `NearbySearchResultNotifier` →
  `nearbySearchResultProvider`. 자동 변환이 `...NotifierProvider` 로 잘못 지어 되돌렸다.
- `NearbyCenter.build()` 는 반환형이 레코드 `({double lat, double lng})` 라 파서가 못 읽어 직접 지정.
- `test/renew_screen_smoke_test.dart` — Notifier provider는 값이 아니라 notifier로 갈아 끼운다.
  `overrideWithValue(...)` → `overrideWith(_FixedLocation.new)` + 고정 좌표 notifier 4줄.

빌드 파이프라인은 남는다 — **freezed는 그대로 쓴다**(`copyWith` 실사용 212곳).

### 2. `club_glass.dart` 죽은 클래스 삭제 (−397줄)

849줄 → 452줄. 참조 0인 위젯 8개를 걷어냈다:
`GlassSectionHead` · `GlassRoundButton` · `OpenHoursLine` · `WeekHoursTable` ·
`GlassHairline` · `GlassInfoRow` · `GlassMoreButton` · `GlassFilterChip`.
같이 죽어 있던 상수 `kNearbyThumbSize` · `kNearbyTextBlock`, 쓰이지 않게 된
import 2개(`operating_hours` · `vybe_liquid_press`)도 제거.

### 3. 구현 1개짜리 repository 인터페이스 정리 (−927줄, `.g.dart` 포함)

**(a) 위임만 하던 5개 — 인터페이스·래퍼 통째로 삭제**
`banner` · `app_config` · `notice` · `performance` · `search_trend`.
메서드마다 `=> _dataSource.x()` 뿐이라 provider가 datasource를 그대로 노출한다.

```dart
final bannerRepositoryProvider = Provider<FirebaseBannerDataSource>(
  (ref) => FirebaseBannerDataSource(),
);
```

**(b) 로직이 있는 3개 — 인터페이스만 삭제, 클래스는 유지**
`auth` · `review` · `vybe_recommendation`. 인터페이스 파일에 있던 타입은 옮겼다:
- `LoginTokenResult` · `PhoneAccountResult` → `firebase_auth_datasource.dart`
  (이미 그 파일이 도메인 파일을 import 하고 있었다)
- `VybeRecommendedClub` → `vybe_recommendation_repository_impl.dart`
  (recommend 화면 3곳의 import 갈아끼움)

**(c) 손대지 않은 4개 — `favorite` · `search_history` · `user` · `club`**
테스트가 `implements <X>Repository` 로 **가짜 구현을 만들고 있다**
(`favorite_guard_test` · `search_history_clear_test` · `settings_screen_test` ·
`search_submit_gate_test`). 구현이 2개라 "인터페이스 하나에 구현 하나" 지적이 성립하지 않는다.
`club` 은 한글 검색 로직도 들고 있다.

> ⚠ **CLAUDE.md 의 MVVM 규칙과 어긋난다** — 위 (a) 5개는 presentation이
> repository 인터페이스가 아니라 datasource 타입을 보게 된다. Firebase import 자체는
> 여전히 datasource 안에만 있고 화면 코드는 `ref.read(xRepositoryProvider)` 그대로라
> 실질 결합은 안 늘었지만, 문서의 레이어 표는 갱신이 필요하다.

### 4. `logFirebaseAccess` 축약 + 릴리즈 로그 제거 (−91줄)

57개 호출부를 5줄 → 3줄로 줄이고 `file:` 인자를 없앴다(값이 언제나 호출부 파일 이름이라 정보가 0).

```dart
// before                                    // after
logFirebaseAccess(                           logFirebaseAccess(
  file: 'firebase_banner_datasource.dart',     'Firestore(banners) [where isActive=true]',
  service: 'Firestore(banners) [...]',         '홈 화면 배너 목록 조회',
  purpose: '홈 화면 배너 목록 조회',           );
);
```

본문은 `assert(() { ... }())` 안으로 넣었다 — **예전에는 `print` 가 릴리즈 빌드에서도 돌았다.**
이제 릴리즈에서는 문자열 조립까지 통째로 빠진다.

### 5. 히어로 래퍼 7개 삭제 (−180줄, −7파일)

`EdmHero` · `KpopHero` · `RecommendHero` · `HotPlacesHero` · `FreeEntryHero` ·
`ServiceDrinksHero` · `HipHopIntroHero` — 전부 `VybeImageHero` 에 에셋 3개와 상수만 넘기는
껍데기였고, `bandAspect: 786/144` · `badgeTopPx: 32` 는 7개가 전부 같은 값이었다.

에셋 경로 규칙(`assets/images/{name}/{name}_hero_top.jpg` 등)이 7개 모두 동일해서
`VybeImageHero` 가 이름 하나로 세 장을 찾도록 바꿨다.

```dart
const VybeImageHero('edm', heroAspect: 786 / 759)
```

래퍼 주석에 있던 경고(‘숫자·헤드라인이 이미지에 박혀 있어 실데이터가 아니다’)는
호출부 한 줄 주석으로 옮겼다.

### 6. `SwipeBackPageRoute` → `CupertinoPageRoute` (−211줄)

200줄짜리 자체 구현을 typedef 한 줄로 바꿨다. 호출부 37곳은 그대로.

> ⚠ **동작이 바뀐다.** 예전 구현은 프레임워크 제스처 로직을 복사해 **화면 전체 폭**에서
> 드래그 백이 먹게 한 것이었다. 이제 **화면 왼쪽 끝(약 20px)** 에서만 먹는다.
> 전체 폭 드래그가 필요하면 `lib/core/navigation/swipe_back_page_route.dart` 를
> git 이전 버전으로 되돌리면 된다(그 파일 하나만 되돌리면 끝).

### 7. 의존성 3개 제거 (−37줄)

- `geoflutterfire_plus` — **import 0건**. geohash는 `core/utils/geohash_utils.dart` 자체 구현이 다 한다.
- `cupertino_icons` — `CupertinoIcons` 참조 0건. Flutter 템플릿 잔재.
- `flutter_spinkit` — `SpinKitWave` 한 곳에만 쓰였다.

> ⚠ **`VybeSpinner` 모양이 바뀐다.** 막대 5개가 파도치는 모양 + 보라↔라임 색 펄스 →
> 기본 `CircularProgressIndicator`(보라). 6개 화면에 나온다.

### 8. 잡동사니 (−82줄, −2파일)

- `design_system/spacing.dart` (`VybeSpacing` 전체) — 참조 0
- `presentation/pass_wallet/` (`PassWalletScreen` 플레이스홀더) — 탭 미연결, import 0
- `VybeButtonState` · `VybeInputState` — 선언만 있고 아무도 안 씀
- `VybeAreaCountLine` · `kTableTierColorKeys` — 참조 0

---

## 의도적으로 **안 한** 것

**스켈레톤 통합 (원래 1순위로 잡았던 −1,400줄)**
철회했다. 12개 스켈레톤 파일은 중복이 아니라 **화면마다 다른 레이아웃을 미리 깔아
레이아웃 시프트를 막는 코드**다(`renew_skeleton.dart` 머리주석이 그 이유를 적어 뒀다).
스피너로 바꾸면 화면이 빈 채 있다가 데이터 도착 시 튄다. 실제로 자를 수 있는 건
`_SkeletonCard` 가 두 벌인 것(`notices_states` · `notification_placeholders`) 정도로 ~150줄.

**개발용 플래그 2개 — `AppGeo.useFixedLocation` · `DeviceNetworkDataSource.debugForceOffline`**
`const false` 라 "아무도 안 켜는 설정"으로 잡았지만, **`const` 인 것이 기능의 핵심**이다 —
소스에서 값을 바꾸고 핫리로드하면 즉시 반영되는 화면 확인 스위치다.
`--dart-define` 으로 바꾸면 전체 재시작이 필요해져 그 워크플로가 망가진다.
릴리즈 빌드에서는 트리셰이킹으로 빠지므로 비용도 0. 지우려면 말해 달라.

---

## 뒤따라 갱신해야 할 문서 (CLAUDE.md)

이번 변경으로 사실과 달라진 부분:

1. **코드 생성 명령** — `riverpod_generator` 항목 삭제. `build_runner` 는 freezed 전용.
2. **`logFirebaseAccess()` 예시** — `file:` 인자가 사라지고 위치 인자 2개가 됐다.
3. **레이어 표 / 폴더 구조** — `domain/repositories/` 가 13개 → 4개
   (`club` · `favorite` · `search_history` · `user`). 위 3-(a) 참고.
4. **기술 스택 표** — `geoflutterfire_plus` 는 실제로 안 쓴다(자체 geohash 구현).
   `flutter_spinkit` · `cupertino_icons` 도 제거됨.
5. **디자인 시스템** — `VybeSpacing` 삭제됨.
6. **미구현 목록** — `pass_wallet_screen.dart` 플레이스홀더가 사라졌다.
