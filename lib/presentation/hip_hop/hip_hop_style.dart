/// 힙합 페이지 공용 색. 힙합 메인·오늘의 라인업이 같은 값을 쓴다.
///
/// 그라데이션은 `hip_hop_gradients.dart`. 배경은 공용 [kVybeInk] + `VybeAurora`.
library;

import 'dart:ui' show Color;

import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 힙합 포인트 색 — 브랜드 라임.
/// (예전엔 화면 전용 골드. 카테고리 페이지마다 포인트가 달라 브랜드로 통일)
const Color kHipAccent = VybeColors.mainLime500;

/// 라임 위에 얹는 어두운 텍스트/아이콘 색 (배경 잉크와 같은 톤).
const Color kHipOnAccent = RenewGlass.ink;

/// 지역 필터 항목 — 디자인(hip_hop.html) 그대로.
const kHipHopAreas = ['인기순', '홍대', '강남', '압구정', '이태원', '건대'];
