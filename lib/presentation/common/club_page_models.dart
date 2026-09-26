import 'package:flutter/material.dart';
import 'package:vybe/core/constants/app_geo.dart';
import 'package:vybe/core/utils/geohash_utils.dart';
import 'package:vybe/core/utils/gradient_palette.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/performance_model.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';

// 카테고리 페이지(K-POP · 금연) 공용 — '주변 클럽 지도 + 가까운 순 그리드' 조합이
// 쓰는 표시 모델·매퍼·순수 함수. K-POP 전용이던 것을 금연 페이지가 같은 구조를
// 그대로 쓰게 되면서 승격했다(`kpop_models.dart` → 여기).

/// 그리드 필터 칩 한 개.
class VybeClubFilter {
  final String label;

  /// 클럽이 이 조건을 통과하는지. [saved] 는 현재 찜한 clubId 집합.
  final bool Function(ClubModel club, Set<String> saved) test;

  const VybeClubFilter(this.label, this.test);
}

/// 필터 5종 — 페이지가 필요한 것만 골라 목록을 만든다.
///
/// 라벨이 곧 선택 상태의 키다(칩 줄이 라벨로 고른다) — 문구를 바꾸면 선택이 풀린다.
const vybeRecommendedFilter = VybeClubFilter('vybe 추천 클럽', _testRecommended);
const vybeFreeEntryFilter = VybeClubFilter('입장비 무료', _testFreeEntry);
const vybeServiceDrinkFilter = VybeClubFilter('서비스 음료', _testServiceDrink);
const vybeSavedFilter = VybeClubFilter('찜', _testSaved);
const vybeNonSmokingFilter = VybeClubFilter('금연', _testNonSmoking);

bool _testRecommended(ClubModel c, Set<String> _) => c.isVybeRecommended;
bool _testFreeEntry(ClubModel c, Set<String> _) => c.isFreeEntry;
bool _testServiceDrink(ClubModel c, Set<String> _) => c.serviceDrink.isOffered;
bool _testSaved(ClubModel c, Set<String> saved) => saved.contains(c.clubId);
bool _testNonSmoking(ClubModel c, Set<String> _) => c.isNonSmoking;

/// ClubModel(+오늘 헤드라이너 공연) → 포스터 카드 뷰모델.
///
/// [headliner] 를 안 주면 `live` 는 false — 공연 일정을 안 읽는 페이지는
/// 없는 걸 LIVE 라고 말하지 않는다. 힙합·EDM 은 오늘 공연을 넘긴다.
/// [bg] 는 화면 팔레트(기본 [vybeClubGradFor]).
/// `vybe`(= `isVybeRecommended`)가 true 면 카드가 앱 공용 `VybeRecommendBadge`
/// (주변 탭 카드와 같은 뱃지)를 그린다.
VybeClubPoster vybeClubPosterFrom(
  ClubModel c, {
  ({double lat, double lng})? origin,
  PerformanceModel? headliner,
  List<Color> Function(String clubId) bg = vybeClubGradFor,
}) => VybeClubPoster(
  id: c.clubId,
  name: c.name,
  area: c.area,
  dist: vybeClubDistanceKm(c.lat, c.lng, origin: origin),
  rating: c.rating,
  reviews: c.reviewCount,
  // 포스터 #태그 — 클럽 태그, 없으면 장르.
  styles: c.tags.isNotEmpty ? c.tags.take(2).toList() : [c.genre],
  lineup: headliner?.artistName ?? '',
  live: headliner != null,
  open: c.operatingHours.today.isCurrentlyOpen,
  thumbnailUrl: c.thumbnailUrl,
  bg: bg(c.clubId),
  vybe: c.isVybeRecommended,
);

/// 내 위치 기준 거리(km) — 표시용.
/// [origin]을 안 주면 홍대 좌표 기준(위치를 못 받았을 때의 폴백, AppGeo와 동일).
double vybeClubDistanceKm(
  double lat,
  double lng, {
  ({double lat, double lng})? origin,
}) => GeohashUtils.haversineKm(
  origin?.lat ?? AppGeo.hongdaeLat,
  origin?.lng ?? AppGeo.hongdaeLng,
  lat,
  lng,
);

// ── 포스터 배경 fallback 그라데이션 ──
// 디자인(kpop_renew.jsx CLUBS[].bg) 10종 그대로. clubId 해시로 일관 배정 →
// 같은 클럽은 항상 같은 색. 썸네일이 있으면 그 위에 사진이 덮인다.
const vybeClubFallbackGradients = <List<Color>>[
  [Color(0xFF2B1655), Color(0xFF7731FE), Color(0xFFB5FF60)],
  [Color(0xFF1C2A10), Color(0xFF739F41), Color(0xFFB5FF60)],
  [Color(0xFF241452), Color(0xFF6329D6), Color(0xFFA179FF)],
  [Color(0xFF3A2F0A), Color(0xFF94CF51), Color(0xFFFFBE0B)],
  [Color(0xFF1A0A26), Color(0xFF4B2093), Color(0xFFB5FF60)],
  [Color(0xFF101019), Color(0xFF2A1B52), Color(0xFFB694FF)],
  [Color(0xFF17102E), Color(0xFF40208C), Color(0xFF8B4DFF)],
  [Color(0xFF2A2410), Color(0xFFB5860B), Color(0xFFFFBE0B)],
  [Color(0xFF14102B), Color(0xFF35187A), Color(0xFF8A55FF)],
  [Color(0xFF1B3A3A), Color(0xFF2A9D8F), Color(0xFFB5FF60)],
];

List<Color> vybeClubGradFor(String clubId) =>
    gradientForKey(vybeClubFallbackGradients, clubId);

/// 지도 지역 칩에 쓸 지역 목록 — **실제 클럽이 있는 지역만**.
///
/// 상권 5곳을 고정으로 박아 두면 그 조건의 클럽이 없는 지역을 골랐을 때 지도가
/// 통째로 비어 고장처럼 보인다. 순서는 [AppGeo.hotspotCenters] 를 따르고
/// (홍대 → 신촌 → 강남 …), 표에 없는 지역은 뒤에 이름순으로 붙인다.
List<String> vybeClubAreasOf(List<ClubModel> clubs) {
  final present = {
    for (final c in clubs)
      if (c.area.isNotEmpty) c.area,
  };
  final known = AppGeo.hotspotCenters.keys.where(present.contains).toList();
  final rest =
      present.where((a) => !AppGeo.hotspotCenters.containsKey(a)).toList()
        ..sort();
  return [...known, ...rest];
}
