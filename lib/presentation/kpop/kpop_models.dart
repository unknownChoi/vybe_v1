import 'package:flutter/material.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/club_page_models.dart';

// K-POP 페이지 전용 상수. 표시 모델·매퍼·지역 목록은 금연 페이지와 같이 쓰게 되면서
// `presentation/common/club_page_models.dart` 로 승격했다.
//
// 디자인(kpop_renew.jsx)에는 있지만 **데이터가 없어 뺀 것**:
// - `now: 'aespa · Whiplash'` (지금 나오는 곡) — clubs 에 그런 필드가 없다.
// - `TAGS` 세부 장르 칩('4세대 아이돌'·'걸그룹' …) — `clubs.genreStyles` 가
//   2026.09.01 에 폐기됐다(값이 조사 데이터가 아니라 clubId 해시 샘플이었다).
//   EDM 타임테이블에서 같은 이유로 걷어낸 것과 같은 판단 — 실 조사 데이터가 먼저다.
// - `walk`(도보 n분) — 거리에서 역산하면 지어낸 값이 된다. 다른 카드와 같이
//   `지역 · N.Nkm` 만 쓴다.

/// `clubs.genre` 에서 K-POP 페이지가 가져올 값.
///
/// `scripts/seed_kpop_clubs.js` 가 이 값으로 클럽 100곳을 만들었다 (2026.09.15,
/// 5개 상권 각 20곳 · VYBE 추천 80곳). **스크립트의 `GENRE` 상수와 같아야 한다.**
///
/// ⚠ 기존 `'팝'` 17곳은 따로 남아 있다 — K-POP 페이지에 안 잡히고 전용 페이지도
/// 없다(R&B 와 같은 처지). 합치려면 그 17곳의 genre 를 바꿔야 한다.
const kKpopGenre = 'K-POP';

/// K-POP 포인트 색 — 디자인 ACC = LIME[500].
const Color kKpopAccent = VybeColors.mainLime500;

/// 디자인 `FILTERS` — vybe 추천 / 입장비 무료 / 서비스 음료 / 찜 / 금연.
const kKpopFilters = <VybeClubFilter>[
  vybeRecommendedFilter,
  vybeFreeEntryFilter,
  vybeServiceDrinkFilter,
  vybeSavedFilter,
  vybeNonSmokingFilter,
];
