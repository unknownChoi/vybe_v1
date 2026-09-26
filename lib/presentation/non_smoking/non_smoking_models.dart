import 'package:flutter/material.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/colors.dart';

// 금연 페이지 전용 상수 · 순수 함수. 표시 모델·매퍼·지역 목록은 K-POP 과 같이 쓰는
// `presentation/common/club_page_models.dart` 에 있다.
//
// 디자인(smoke_free.jsx)에는 있지만 **데이터가 없어 뺀 것**:
// - `BoothSection`('실내 흡연실이 따로 있는 클럽') — 흡연실 위치·설명(`BOOTHS`)이
//   clubs 에 없다. `isNonSmoking` 불리언 하나뿐이라 부스 유무를 나눌 수 없다.
// - `PolicyBadge` 의 정책 문구 3종(실내 전 구역 금연 · 흡연 부스 분리 · 테라스만 흡연)
//   — 같은 이유. 카드 뱃지는 히어로 문구와 같은 '실내 금연' 하나로 통일.
// - `walk`(도보 n분) — 거리에서 역산하면 지어낸 값. 다른 카드와 같이 `지역 · N.Nkm`.
// - 카드의 보라 '추천 클럽' pill — 앱 공용 `VybeRecommendBadge`(주변 탭과 같은 뱃지)로
//   대체(요구사항).

/// 금연 포인트 색 — 히어로 'FREE' 와 같은 브랜드 라임(디자인 ACC = LIME[500]).
const Color kNonSmokingAccent = VybeColors.mainLime500;

/// 장르 칩 순서 — 디자인 `GENRES`. 여기 없는 장르는 뒤에 이름순으로 붙는다.
const kNonSmokingGenreOrder = ['EDM', '힙합', 'K-POP', '하이브리드'];

/// 장르 칩에 쓸 장르 목록 — **실제 금연 클럽이 있는 장르만**.
///
/// 디자인의 고정 4종을 그대로 박으면 테크노·팝·하우스·R&B 의 금연 클럽
/// (2026.09.15 실측 21곳)이 어느 칩에도 안 잡히고, 반대로 클럽이 0곳인 장르 칩은
/// 눌러 봐야 '없어요'만 나온다. 지역 칩(`vybeClubAreasOf`)과 같은 규칙.
List<String> nonSmokingGenresOf(List<ClubModel> clubs) {
  final present = {
    for (final c in clubs)
      if (c.genre.isNotEmpty) c.genre,
  };
  final known = kNonSmokingGenreOrder.where(present.contains).toList();
  final rest = present.where((g) => !kNonSmokingGenreOrder.contains(g)).toList()
    ..sort();
  return [...known, ...rest];
}
