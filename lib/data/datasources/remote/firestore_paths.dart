/// Firestore 컬렉션 이름과 Storage 경로 — **문자열은 여기에만 둔다.**
///
/// 컬렉션 이름은 Rules·인덱스·Cloud Functions·seed 스크립트와 반드시 같아야 하는데,
/// datasource마다 문자열을 적어 두면 오타가 컴파일에 걸리지 않고 런타임에
/// '문서 없음'으로만 나타난다. 한곳에 모아 두면 스키마 문서(CLAUDE.md)와
/// 대조하기도 쉽다.
///
/// ⚠ 값을 바꾸는 것은 **DB 마이그레이션**이다 — Rules·인덱스·Functions·기존 문서를
/// 같이 옮기지 않으면 앱이 빈 화면이 된다.
class FirestorePaths {
  const FirestorePaths._();

  // ── 최상위 컬렉션 ──
  static const users = 'users';
  static const clubs = 'clubs';
  static const favorites = 'favorites';
  static const banners = 'banners';
  static const notices = 'notices';

  /// `popupAds/{popupId}` — 홈 진입 팝업 광고. 어드민이 쓰고 앱은 읽기만.
  static const popupAds = 'popupAds';
  static const performances = 'performances';
  static const appConfig = 'appConfig';
  static const vybeRecommendations = 'vybeRecommendations';
  static const searchLogs = 'searchLogs';
  static const searchTrends = 'searchTrends';
  static const searchHashtags = 'searchHashtags';

  /// `inquiries/{inquiryId}` — 고객센터 문의. 사용자가 쓰고 어드민이 답변한다.
  static const inquiries = 'inquiries';

  // ── 서브컬렉션 ──
  /// `clubs/{clubId}/info/{clubId}`
  static const clubInfo = 'info';

  /// `clubs/{clubId}/menus/{menuId}`
  static const menus = 'menus';

  /// `clubs/{clubId}/photos/{photoId}`
  static const photos = 'photos';

  /// `clubs/{clubId}/tableLayout/{clubId}` — 배치도는 클럽당 문서 1건(문서 id = clubId).
  static const tableLayout = 'tableLayout';

  /// `clubs/{clubId}/reviews/{reviewId}` — 마이페이지는 collectionGroup으로도 읽는다.
  static const reviews = 'reviews';

  /// `users/{uid}/searchHistory/{historyId}`
  static const searchHistory = 'searchHistory';

  // ── 고정 문서 id ──
  /// `searchTrends/current` — 집계 스냅샷 (앱은 이 문서 1건만 읽는다).
  static const trendsCurrentDoc = 'current';
}

/// Firebase Storage 경로. 규칙(`storage.rules`)의 경로 패턴과 짝이다.
class StoragePaths {
  const StoragePaths._();

  /// `users/{uid}/{fileName}` — 프로필 사진.
  ///
  /// ⚠ 파일명에 타임스탬프를 붙여 **매번 다른 경로**에 올린다
  /// ([profileImageFileName]). 예전처럼 `profile.jpg` 로 덮어쓰면 URL 이
  /// 그대로라 앱 이미지 캐시·CDN 이 옛 사진을 계속 보여준다 —
  /// "바꿨는데 안 바뀐다"로 나타나고 앱을 지웠다 깔아야 고쳐진다.
  static String profileImage(String uid, String fileName) =>
      'users/$uid/$fileName';

  /// `profile_{millis}.jpg` — 업로드할 때마다 새 이름.
  static String profileImageFileName() =>
      'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

  /// `reviews/{clubId}/{reviewId}/{fileName}` — 리뷰 첨부 (최대 4장).
  static String reviewImage(String clubId, String reviewId, String fileName) =>
      'reviews/$clubId/$reviewId/$fileName';

  /// `inquiries/{uid}/{inquiryId}/{fileName}` — 문의 첨부 (최대 4장).
  /// ⚠ 첫 칸이 **uid** 다 — storage.rules 가 이 자리로 소유자를 판정한다
  /// (리뷰는 clubId 라 자리 순서를 헷갈리지 말 것).
  static String inquiryImage(String uid, String inquiryId, String fileName) =>
      'inquiries/$uid/$inquiryId/$fileName';
}
