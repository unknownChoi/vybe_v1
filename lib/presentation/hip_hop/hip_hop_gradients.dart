import 'package:flutter/material.dart';
import 'package:vybe/core/utils/gradient_palette.dart';
import 'package:vybe/design_system/colors.dart';

// 힙합 페이지 공용 — 썸네일/포스터/아바타 배경 fallback 그라데이션.
// 디자인(hip_hop.html) 골드 계열 — 다른 페이지 팔레트와 색이 안 겹쳐 따로 둔다.
const hipFallbackGradients = <List<Color>>[
  [Color(0xFF2B1655), VybeColors.mainPurple500, Color(0xFFF5B82E)],
  [Color(0xFFFB5607), Color(0xFFFFBE0B)],
  [Color(0xFF2A1A3E), VybeColors.mainPurple500],
  [Color(0xFF4A1E1E), Color(0xFFF72585)],
  [Color(0xFF3A0CA3), Color(0xFF4361EE)],
  [Color(0xFF3A2F0A), Color(0xFFF5B82E), Color(0xFFFB8500)],
  [Color(0xFF5A3A1A), Color(0xFFF5B82E)],
  [Color(0xFF1B3A3A), Color(0xFF2A9D8F)],
  [Color(0xFFFFBE0B), Color(0xFFFB5607)],
  [Color(0xFF2A2410), Color(0xFFB5860B)],
];

/// clubId 해시로 일관 배정 → 같은 클럽은 항상 같은 색.
List<Color> hipGradFor(String clubId) =>
    gradientForKey(hipFallbackGradients, clubId);
