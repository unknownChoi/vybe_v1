/// v1 데이터 소스 선택 — `--dart-define=VYBE_BACKEND=fake|emulator|prod`
///
/// CLAUDE.md ⭐ v1 개발 규칙: "어느 구현을 쓸지는 datasource **provider 한 곳**에서만 고른다."
/// 이 파일이 그 한 곳이 읽는 값을 만든다. 화면·ViewModel·Repository 는 이 값을 보지 않는다.
///
/// ```bash
/// flutter run --dart-define=VYBE_BACKEND=fake       # UI 단계 (기본)
/// flutter run --dart-define=VYBE_BACKEND=emulator   # 백엔드 단계
/// ```
///
/// ⚠ **베타에서 이미 Firebase 에 붙어 있는 기능(클럽 · 리뷰 · 찜 · 검색 · 인증 등)은
/// 이 플래그와 무관하게 늘 Firebase 를 쓴다.** 이 값은 v1 신규 기능
/// (웨이팅 · 예약 · 주문 · 패스월렛 · 공유 · 결제)에만 적용된다.
library;

/// v1 신규 기능이 붙을 백엔드.
enum VybeBackend {
  /// 메모리 Fake. Firebase 호출 없음. UI 단계 기본값.
  fake,

  /// Firebase Emulator Suite.
  emulator,

  /// 운영 Firebase.
  prod;

  static VybeBackend _parse(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'emulator':
        return VybeBackend.emulator;
      case 'prod':
        return VybeBackend.prod;
      case 'fake':
      case '':
        return VybeBackend.fake;
      default:
        // 오타를 조용히 prod 로 떨어뜨리면 UI 단계에 운영 데이터를 건드린다.
        // 모르는 값은 가장 안전한 fake 로 둔다.
        return VybeBackend.fake;
    }
  }
}

/// 빌드에 박힌 백엔드 선택값. 기본 [VybeBackend.fake].
const String _kRawBackend = String.fromEnvironment(
  'VYBE_BACKEND',
  defaultValue: 'fake',
);

/// 지금 빌드의 v1 백엔드.
final VybeBackend kVybeBackend = VybeBackend._parse(_kRawBackend);

/// v1 신규 기능이 Fake 로 도는지. datasource provider 가 이것만 본다.
bool get kUsesFakeBackend => kVybeBackend == VybeBackend.fake;
