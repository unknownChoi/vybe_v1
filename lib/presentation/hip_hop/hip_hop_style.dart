/// 힙합 페이지 공용 색. 힙합 메인·오늘의 라인업이 같은 값을 쓴다.
///
/// 그라데이션은 `hip_hop_gradients.dart`. 배경은 공용 [kVybeInk] + `VybeAurora`.
library;

import 'dart:ui' show Color;

import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/filter_chip_style.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 힙합 포인트 색 — 브랜드 라임.
/// (예전엔 화면 전용 골드. 카테고리 페이지마다 포인트가 달라 브랜드로 통일)
const Color kHipAccent = VybeColors.mainLime500;

/// 라임 위에 얹는 어두운 텍스트/아이콘 색 (배경 잉크와 같은 톤).
const Color kHipOnAccent = RenewGlass.ink;

/// HOME-009 오늘의 라인업 **전용** 값 — 디자인 `today_lineup.jsx`.
///
/// ⚠ [kHipAccent] 를 건드리지 않는다 — 그 값은 힙합 메인(CAT-016)과 공용이라
/// 바꾸면 이번 범위 밖 화면이 같이 바뀐다. CAT-016 차례에 같은 골드로 맞추면
/// 그때 둘을 합친다(진행 기록 결정 ⓘ).
/// 디자인 `HIP` · `ON_HIP` · `BG` (today_lineup.jsx:4-6).
/// 이 화면 조각(`lineup_*.dart`)은 전부 이 골드를 쓴다 — 칩만 골드로 칠하면
/// 한 화면에 액센트가 둘(라임 숫자 + 골드 칩)이 된다.
const Color kLineupAccent = Color(0xFFF5B82E);
const Color kLineupOnAccent = Color(0xFF2A1E04);
const Color kLineupBg = Color(0xFF0D0A0C);

/// 오늘의 라인업 타입 필터 칩 색 — 선택 시 골드 채움 + 어두운 글자,
/// 미선택은 GRAY[900] 채움 + GRAY[800] 테두리 (today_lineup.jsx:109-117).
const VybeChipTone kLineupChipTone = VybeChipTone(
  selectedFill: kLineupAccent,
  selectedInk: kLineupOnAccent,
  restFill: VybeColors.gray900,
  restBorder: VybeColors.gray800,
);

/// 지역 필터 항목 — 디자인(hip_hop.html) 그대로.
const kHipHopAreas = ['인기순', '홍대', '강남', '압구정', '이태원', '건대'];
