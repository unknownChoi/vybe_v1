import 'package:flutter/material.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/colors.dart';

// 서비스 음료 페이지 전용 상수 · 순수 함수. 카드 모델·매퍼·지역 목록은 K-POP·금연과
// 같이 쓰는 `presentation/common/club_page_models.dart` 에 있다.
//
// 디자인(service_drinks_renew.jsx)에는 있지만 **데이터가 없어 뺀 것**:
// - `SdPerkSection`('혜택별로 무엇을 받는지' — 웰컴 드링크·테이블 주류·음료 무제한·
//   조건부 4종 + 제공 내용·조건·시간 + 해당 클럽 레일) — `clubs.serviceDrink` 는
//   `{isOffered, comment, drinks}` 뿐이라 혜택 등급(`tier`)이 없다. `comment` 한 줄을
//   키워드로 갈라 등급을 만들면 지어낸 분류가 된다(EDM BPM · 금연 흡연실과 같은 판단).
//   되살리려면 스키마에 tier 를 더하고 seed 가 같이 써야 한다.
// - `SdIntro` 텍스트 인트로 — 다른 카테고리 페이지와 같은 **이미지 히어로** 를 쓴다
//   (입장비 무료 리뉴얼 때의 요구사항과 동일).
// - `walk`(도보 n분) — 거리에서 역산하면 지어낸 값. 다른 카드와 같이 `지역 · N.Nkm`.
// - 지도 아래 클럽 한 줄(`SdMapClubRow`) — 공용 지도 섹션의 미니 카드가 대신한다.

/// 서비스음료 포인트 색 — 브랜드 라임(디자인 SD.point = LIME[500]).
const Color kDrinkAccent = VybeColors.mainLime500;

/// 음료 종류 칩 순서 — 디자인 `SD_TYPES`. `clubs.serviceDrink.drinks` 값과 문자열이
/// 같아야 필터가 걸린다(`scripts/seed_service_drinks.js` 의 `DRINK_TYPES` 와 동일).
const kDrinkTypes = ['양주', '샴페인', '칵테일', '맥주', '와인'];

/// 종류 칩에 쓸 음료 목록 — **실제로 주는 클럽이 있는 종류만**. [kDrinkTypes] 순서
/// 먼저, 표에 없는 값은 뒤에 이름순.
///
/// 디자인의 고정 5종을 그대로 박으면 클럽이 0곳인 종류 칩은 눌러 봐야 '없어요'만
/// 나온다. 지역 칩(`vybeClubAreasOf`)·금연 장르 칩과 같은 규칙.
List<String> serviceDrinkTypesOf(List<ClubModel> clubs) {
  final present = {
    for (final c in clubs)
      for (final d in c.serviceDrink.drinks)
        if (d.isNotEmpty) d,
  };
  final known = kDrinkTypes.where(present.contains).toList();
  final rest = present.where((d) => !kDrinkTypes.contains(d)).toList()..sort();
  return [...known, ...rest];
}
