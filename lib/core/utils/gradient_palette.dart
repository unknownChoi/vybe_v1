import 'dart:ui' show Color;

import 'package:vybe/design_system/colors.dart';

/// 키(보통 clubId) 해시로 팔레트에서 그라데이션 하나를 **결정적으로** 고른다.
///
/// 썸네일이 없거나 로딩 전인 카드의 배경 폴백용. 같은 클럽은 화면을 다시 그려도
/// 늘 같은 색이 나온다.
List<Color> gradientForKey(List<List<Color>> palette, String key) =>
    palette[key.hashCode.abs() % palette.length];

/// 클럽 카드 폴백 네온 팔레트 — 찜·검색·서비스 음료·입장비 무료·홈이 각자 들고
/// 있던 목록의 합집합(중복 제거). 화면마다 다른 사본을 두면 같은 클럽이 화면마다
/// 다른 색으로 뜬다.
///
/// 포스터 카드(장르 페이지)의 보라·라임 팔레트는 별개 —
/// `club_page_models.vybeClubFallbackGradients`.
const List<List<Color>> kClubFallbackGradients = [
  [Color(0xFF2B1655), VybeColors.mainPurple500, Color(0xFFFF4D8D)],
  [Color(0xFFFF006E), Color(0xFF8338EC)],
  [Color(0xFF06FFA5), Color(0xFF3A86FF)],
  [Color(0xFFFB5607), Color(0xFFFFBE0B)],
  [Color(0xFF3A0CA3), Color(0xFF4361EE)],
  [Color(0xFF6D4C91), Color(0xFF2A2D34)],
  [VybeColors.accentBlue500, VybeColors.mainPurple500],
  [Color(0xFF06FFA5), Color(0xFF1B9AAA)],
];

/// [kClubFallbackGradients] 에서 clubId 해시로 하나.
List<Color> clubGradientFor(String clubId) =>
    gradientForKey(kClubFallbackGradients, clubId);
