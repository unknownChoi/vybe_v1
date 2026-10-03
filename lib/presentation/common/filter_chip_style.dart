import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/clubs/widgets/club_glass.dart';

/// 목록/카테고리 화면 필터 칩의 **단일 외형 소스**.
///
/// 기준은 주변 페이지(지도 시트) 필터 칩 — 테두리 없음, 비활성은 흰색 6% 채움,
/// 활성은 보라 그라데이션. 화면마다 칩 모양이 다르면 같은 동작이 다른 신호로 읽혀
/// 카테고리 페이지(입장비 무료·서비스 음료·힙합·핫플레이스…)도 전부 여기로 맞춘다.
///
/// 주변/검색의 `NearbyGlass.chipFill`·`activeChip`·`chipText`는 이 값을 그대로
/// 가리킨다 — 값이 두 곳에 살면 조용히 갈라진다.

/// 비활성 칩 채움 — rgba(255,255,255,0.06).
const Color kFilterChipFill = Color(0x0FFFFFFF);

/// 활성 칩 보라 그라데이션 (135deg, 0.95 → 0.7).
const LinearGradient kFilterChipActiveGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xF27731FE), Color(0xB3622ACF)],
);

/// 선택된 칩 위 글자·아이콘 색.
const Color kFilterChipSelectedInk = Colors.white;

/// 선택 안 된 칩의 글자색 (글래스 텍스트 계조 t2).
const Color kFilterChipInk = ClubGlass.t2;

/// 화면 액센트 칩 색 묶음. null 이면 앱 공용(보라 그라데이션 + 흰 글자).
///
/// 디자인이 화면 액센트로 칩을 칠하는 자리(HOME-009 오늘의 라인업 — 골드)에만
/// 넘긴다. 칩 **모양**(높이 · radius · 글자 크기)은 그대로라 같은 동작이 다른
/// 신호로 읽히지 않는다 — 색만 화면 액센트를 따른다.
class VybeChipTone {
  /// 선택된 칩 채움(단색).
  final Color selectedFill;

  /// 선택된 칩 위 글자·아이콘.
  final Color selectedInk;

  /// 선택 안 된 칩 채움.
  final Color restFill;

  /// 선택 안 된 칩 테두리. null 이면 테두리 없음(앱 공용 모양).
  final Color? restBorder;

  const VybeChipTone({
    required this.selectedFill,
    required this.selectedInk,
    required this.restFill,
    this.restBorder,
  });
}

/// 검색 결과(HOME-006) 칩 톤 — 디자인 `search_results_v2.jsx:167-170 · 209-214`.
/// 비활성 GRAY[900] 채움 + GRAY[800] 테두리, 활성 PURPLE[700] **단색** + 흰 글자.
const VybeChipTone kSearchChipTone = VybeChipTone(
  selectedFill: VybeColors.mainPurple700,
  selectedInk: Colors.white,
  restFill: VybeColors.gray900,
  restBorder: VybeColors.gray800,
);

/// 칩 글자 스타일. 선택 시 굵기·색이 함께 올라간다.
TextStyle filterChipTextStyle({required bool selected, Color? ink}) =>
    TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12.sp,
      height: 14 / 12,
      letterSpacing: 12 * -0.025,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      color: ink ?? (selected ? kFilterChipSelectedInk : kFilterChipInk),
    );

/// 주변 페이지와 같은 모양의 필터 칩 하나.
///
/// 칩 줄(가로 스크롤·간격)은 화면이 갖고, 이 위젯은 **칩 한 알의 외형만** 책임진다.
class VybeGlassFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// 라벨 앞 아이콘. null이면 아이콘 없이 글자만.
  final IconData? icon;

  /// 선택 **안 된** 칩의 아이콘 색(화면 액센트). null이면 글자색과 같게 그린다.
  final Color? accent;

  /// 라벨 뒤에 붙는 조각(개수 등). 글자색(fg)을 받아 같은 계조로 그린다.
  final Widget Function(Color fg)? trailing;

  /// 칩 좌우 안쪽 여백(dp, `.w` 적용 전).
  final double hPadding;

  /// 아이콘 크기(dp, `.r` 적용 전).
  final double iconSize;

  /// 화면 액센트 색 묶음. null 이면 앱 공용(보라 그라데이션).
  final VybeChipTone? tone;

  const VybeGlassFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.accent,
    this.trailing,
    this.hPadding = 13,
    this.iconSize = 13,
    this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final t = tone;
    final fg = t != null
        ? (selected ? t.selectedInk : kFilterChipInk)
        : (selected ? kFilterChipSelectedInk : kFilterChipInk);
    final iconData = icon;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 34.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: hPadding.w),
        decoration: BoxDecoration(
          color: t != null
              ? (selected ? t.selectedFill : t.restFill)
              : (selected ? null : kFilterChipFill),
          gradient: t == null && selected ? kFilterChipActiveGradient : null,
          border: t?.restBorder != null && !selected
              ? Border.all(color: t!.restBorder!)
              : null,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null) ...[
              Icon(
                iconData,
                size: iconSize.r,
                color: selected ? fg : (accent ?? fg),
              ),
              SizedBox(width: 5.w),
            ],
            Text(
              label,
              style: filterChipTextStyle(
                selected: selected,
                ink: t != null ? fg : null,
              ),
            ),
            if (trailing != null) ...[SizedBox(width: 5.w), trailing!(fg)],
          ],
        ),
      ),
    );
  }
}
