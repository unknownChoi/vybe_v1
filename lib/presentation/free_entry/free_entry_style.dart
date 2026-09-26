import 'package:flutter/material.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 입장비 무료 화면 전용 색·상수 (디자인 `free_entry_renew_parts.jsx` FE 토큰).
///
/// 무료입장 = **퍼플 베이스 + 라임 포인트**. 뱃지·조건 박스는 퍼플, 카운트다운·
/// 지금 무료 강조는 라임.

/// 베이스(퍼플) — '지금 무료' 뱃지 채움 · 조건 박스.
const Color kEntryBase = VybeColors.mainPurple500;

/// rgba(119,49,254,0.16) / 0.42 — 조건 박스 채움·테두리.
const Color kEntryBaseSoft = Color(0x297731FE);
const Color kEntryBaseLine = Color(0x6B7731FE);

/// 포인트(라임) — 카운트다운 강조 · 영업 중 점.
const Color kEntryPoint = VybeColors.mainLime500;

/// rgba(181,255,96,0.11) / 0.30 — 마감 임박 타일·조건 태그.
const Color kEntryPointSoft = Color(0x1CB5FF60);
const Color kEntryPointLine = Color(0x4DB5FF60);

/// 조건 박스 제목 라벤더 (`#C8A8FF`).
const Color kEntryLavender = RenewGlass.lavender;

/// 무료 마감이 이 안으로 들어오면 카운트다운 타일을 라임으로 켠다.
const Duration kEntryUrgent = Duration(hours: 1);

// 썸네일 폴백 그라데이션은 공용 `clubGradientFor` (core/utils/gradient_palette.dart).
