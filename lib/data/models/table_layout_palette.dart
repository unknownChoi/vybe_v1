import 'package:flutter/material.dart';
import 'package:vybe/design_system/colors.dart';

// 테이블 배치도 색·아이콘 대응표.
//
// Firestore 에는 `colorKey`(purple·blue·gray…) 만 저장하고 실제 색값은 앱이 갖는다.
// 업주가 hex 를 자유 입력하게 두면 다크 배경에 안 보이는 색(#111 위 #222)이 나오고,
// 앱 테마를 바꿀 때 전 클럽 문서를 손봐야 한다. `ClubFacility` 와 같은 규칙.

/// 등급 하나에 쓰이는 색 묶음.
class TableTierStyle {
  /// 텍스트·아이콘 accent (밝은 쪽).
  final Color text;

  /// 범례 dot · 선택 테두리 (진한 쪽).
  final Color dot;

  /// 선택된 도형 배경.
  final Color selectedFill;

  /// 미선택 도형 배경 (반투명).
  final Color fill;

  /// 미선택 도형 테두리 (반투명).
  final Color border;

  const TableTierStyle({
    required this.text,
    required this.dot,
    required this.selectedFill,
    required this.fill,
    required this.border,
  });
}

/// `colorKey` → 색 묶음. 모르는 키는 [kGrayTierStyle].
const Map<String, TableTierStyle> kTableTierStyles = {
  'purple': TableTierStyle(
    text: Color(0xFFC8A8FF),
    dot: VybeColors.mainPurple500,
    selectedFill: VybeColors.mainPurple500,
    fill: Color(0x297731FE),
    border: Color(0x807731FE),
  ),
  'blue': TableTierStyle(
    text: Color(0xFF8FB5FF),
    dot: VybeColors.accentBlue500,
    selectedFill: VybeColors.accentBlue500,
    fill: Color(0x242B6BFF),
    border: Color(0x802B6BFF),
  ),
  'lime': TableTierStyle(
    text: Color(0xFFD3FFA0),
    dot: VybeColors.mainLime500,
    selectedFill: VybeColors.mainLime700,
    fill: Color(0x24B5FF60),
    border: Color(0x80B5FF60),
  ),
  'pink': TableTierStyle(
    text: Color(0xFFFFA8C8),
    dot: Color(0xFFFF4D8D),
    selectedFill: Color(0xFFCF3E71),
    fill: Color(0x24FF4D8D),
    border: Color(0x80FF4D8D),
  ),
  'amber': TableTierStyle(
    text: Color(0xFFFFD79A),
    dot: Color(0xFFFFA726),
    selectedFill: Color(0xFFCF861F),
    fill: Color(0x24FFA726),
    border: Color(0x80FFA726),
  ),
  'gray': kGrayTierStyle,
};

/// 모르는 `colorKey` 폴백. 색을 지어내지 않고 무채색으로 떨어뜨린다.
const TableTierStyle kGrayTierStyle = TableTierStyle(
  text: VybeColors.gray300,
  dot: VybeColors.gray500,
  selectedFill: VybeColors.gray700,
  fill: Color(0x0DFFFFFF),
  border: Color(0x33FFFFFF),
);

TableTierStyle tierStyleOf(String colorKey) =>
    kTableTierStyles[colorKey] ?? kGrayTierStyle;

// ── 구조물 ──

/// 구조물 도형의 색·아이콘.
class FixtureStyle {
  final Color fill;
  final Color border;
  final Color text;
  final IconData? icon;

  /// 채움 대신 쓰는 세로 그라데이션 (디자인 무대).
  final Gradient? gradient;

  /// 점선 테두리 (디자인 댄스플로어).
  final bool dashed;

  /// 테두리 두께. 점선은 1.5.
  final double borderWidth;

  /// 글자 자간(px). 디자인은 타입마다 다르다(0.08em · 0.16em · 0.12em).
  final double letterSpacing;

  /// 라벨 아래 보조 캡션. 디자인이 타입마다 박아 둔 문구다(댄스플로어 '스탠딩').
  /// 업주 데이터에 대응 필드가 없어 색·아이콘과 같이 앱이 갖는다.
  final String? caption;

  const FixtureStyle({
    required this.fill,
    required this.border,
    required this.text,
    this.icon,
    this.gradient,
    this.dashed = false,
    this.borderWidth = 1,
    this.letterSpacing = 1.1,
    this.caption,
  });
}

/// `fixture.type` → 색·아이콘. **타입마다 고정**이고 업주가 못 바꾼다.
///
/// 색을 업주 손에 맡기면 클럽마다 무대가 다른 색이 되어, 사용자가 배치도를 볼 때
/// 색으로 무엇인지 알아보는 학습이 통째로 무너진다. 등급(tier)만 클럽별로 다르고
/// 구조물은 앱이 정한 색을 쓴다.
///
/// ⚠ `partner/editor.js` 의 `FX_STYLE` 과 **같은 값이어야 한다** —
///   어긋나면 업주가 편집기에서 보는 색과 앱이 보여주는 색이 달라진다.
const Map<String, FixtureStyle> kFixtureStyles = {
  // 무대 — 클럽의 기준점. 위에서 아래로 옅어지는 보라(디자인 CLUB-023).
  'stage': FixtureStyle(
    fill: Color(0x597731FE),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0x597731FE), Color(0x0F7731FE)],
    ),
    border: Color(0x807731FE),
    text: Color(0xFFC8A8FF),
    icon: Icons.album_outlined,
    letterSpacing: 0.96, // 0.08em × 12
  ),
  // DJ 부스 — 무대 옆에 붙는 경우가 많아 무대와 구분되는 핑크.
  'dj': FixtureStyle(
    fill: Color(0x29FF4D8D),
    border: Color(0x80FF4D8D),
    text: Color(0xFFFFA8C8),
    icon: Icons.album_outlined,
  ),
  // 댄스플로어 — 면적이 가장 넓다. 디자인은 색을 빼고 **점선 윤곽**으로만
  // 둬서 테이블이 묻히지 않게 한다(아이콘도 없다).
  'dancefloor': FixtureStyle(
    fill: Color(0x04FFFFFF),
    border: VybeColors.gray700,
    text: VybeColors.gray500,
    dashed: true,
    borderWidth: 1.5,
    letterSpacing: 1.92, // 0.16em × 12
    caption: '스탠딩',
  ),
  // 바 — 중성 회색. 색을 주면 등급 색과 섞여 읽힌다(디자인 CLUB-023).
  'bar': FixtureStyle(
    fill: Color(0x0AFFFFFF),
    border: VybeColors.gray800,
    text: VybeColors.gray400,
    letterSpacing: 1.44, // 0.12em × 12
  ),
  // 입구 — 안내 표지 관례대로 초록 계열.
  'entrance': FixtureStyle(
    fill: Color(0x24B5FF60),
    border: Color(0x80B5FF60),
    text: Color(0xFFD3FFA0),
    icon: Icons.meeting_room_outlined,
  ),
  'restroom': FixtureStyle(
    fill: Color(0x242B6BFF),
    border: Color(0x802B6BFF),
    text: Color(0xFF8FB5FF),
    icon: Icons.wc_rounded,
  ),
  'stairs': FixtureStyle(
    fill: Color(0x14FFFFFF),
    border: Color(0x47FFFFFF),
    text: Color(0xFFB9B9C6),
    icon: Icons.stairs_outlined,
  ),
  // 벽 — 글자 없이 덩어리로만 보인다.
  'wall': FixtureStyle(
    fill: Color(0x24FFFFFF),
    border: Color(0x24FFFFFF),
    text: Colors.transparent,
  ),
  'etc': FixtureStyle(
    fill: Color(0x0AFFFFFF),
    border: VybeColors.gray800,
    text: VybeColors.gray400,
  ),
};

/// 모르는 타입 폴백 — 파서가 이미 모르는 키를 버리므로 실제로는 안 쓰인다.
const FixtureStyle kUnknownFixtureStyle = FixtureStyle(
  fill: Color(0x0AFFFFFF),
  border: VybeColors.gray800,
  text: VybeColors.gray400,
);

FixtureStyle fixtureStyleOf(String typeKey) =>
    kFixtureStyles[typeKey] ?? kUnknownFixtureStyle;
