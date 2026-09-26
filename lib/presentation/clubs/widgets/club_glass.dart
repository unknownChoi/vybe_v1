import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/utils/number_format.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/clubs/widgets/subway_line_badge.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 클럽 상세(구) 리퀴드 글래스 공통 요소.
///
/// 디자인: club_glass_shell.jsx (CG 토큰 · GCard · GHead · GlassRound) 기준.
/// CSS `blur(18px)` ≈ Flutter `ImageFilter.blur(sigma 9)`.
///
/// 색 토큰은 전부 [RenewGlass]의 **별칭** — 값이 같은데 두 벌로 살면 한쪽만
/// 바뀌어 조용히 갈라진다. 글자 헬퍼만 행간이 달라 남겨 뒀다.

// ============================================================================
// 토큰
// ============================================================================

class ClubGlass {
  ClubGlass._();

  static const Color ink = RenewGlass.ink;
  static const Color cardFill = RenewGlass.cardFill;
  static const Color cardBorder = RenewGlass.cardBorder;
  static const Color tileFill = RenewGlass.tileFill;
  static const Color tileBorder = RenewGlass.tileBorder;
  static const Color barFill = RenewGlass.barFill;
  static const Color hair = RenewGlass.hair;
  static const Color t1 = RenewGlass.t1;
  static const Color t2 = RenewGlass.t2;
  static const Color t3 = RenewGlass.t3;
  static const Color t4 = RenewGlass.t4;

  /// 찜 상태 색 (CG_SAVED)
  static const Color saved = VybeColors.mainPurple500;

  static const double blurSigma = RenewGlass.cardBlur;

  static TextStyle title() => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 16 * -0.025,
    color: t1,
  );

  static TextStyle body({Color color = t2, double size = 14}) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: size.sp,
    height: 20 / 14,
    letterSpacing: size * -0.025,
    color: color,
  );

  static TextStyle caption({
    Color color = t3,
    double size = 12,
    double lineHeight = 14,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
    fontFamily: 'Pretendard',
    fontSize: size.sp,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: size * -0.025,
    color: color,
  );
}

/// 원형 글래스 타일 (CG.tile) — 아이콘 하나를 담는 작은 유리 원.
///
/// 검색 pill 우측 아이콘 자리(주변 GNB · 검색 화면)와 헤더 원형 버튼(알림)이 공유한다.
/// 탭 동작은 호출측에서 감싼다 — 히트 영역이 화면마다 달라서.
class GlassCircleTile extends StatelessWidget {
  final Widget child;

  /// 지름 (CSS px, `.r` 적용).
  final double size;

  /// 뒤 배경 블러. null이면 블러 없이 채움만 (이미 블러된 유리 위에 올릴 때).
  final double? blurSigma;

  /// 기본 타일 톤 대신 쓸 채움·테두리 (사진 위 어두운 원 등).
  final Color fill;
  final Color border;

  const GlassCircleTile({
    super.key,
    required this.child,
    this.size = 34,
    this.blurSigma,
    this.fill = ClubGlass.tileFill,
    this.border = ClubGlass.tileBorder,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border),
      ),
      child: child,
    );

    if (blurSigma == null) return tile;
    return ClipOval(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blurSigma!, sigmaY: blurSigma!),
        child: tile,
      ),
    );
  }
}

// ============================================================================
// 작은 조각들
// ============================================================================

/// 호선 배지 + `역명에서 N m` 한 줄. `clubs/{id}/info.nearbySubways` 원소를 받는다.
class SubwayStationLine extends StatelessWidget {
  final Map<String, dynamic> subway;

  /// 노선 배지 지름. 리뉴얼 상세의 접힌 카드 안에서는 17.
  final double badgeSize;

  const SubwayStationLine({
    super.key,
    required this.subway,
    this.badgeSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final lines = List<String>.from(subway['lines'] as List? ?? const []);
    return Row(
      children: [
        if (lines.isNotEmpty) ...[
          SubwayLineBadge(line: lines.first, size: badgeSize),
          SizedBox(width: 6.w),
        ],
        Flexible(
          child: Text(
            subwayLabel(subway) ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ClubGlass.caption(),
          ),
        ),
      ],
    );
  }
}

/// 지하철역 표기 — `상수역에서 422m`. 역명이 없으면 null.
String? subwayLabel(Map<String, dynamic>? subway) {
  if (subway == null) return null;
  final station = subway['stationName'] as String? ?? '';
  if (station.isEmpty) return null;
  final distance = (subway['distanceM'] as num?)?.toInt() ?? 0;
  return distance > 0 ? '$station에서 ${distance}m' : station;
}

/// 입장료 표기 — 둘 다 0이면 '무료', 같으면 단일가, 다르면 범위.
String formatEntryFee({required int min, required int max}) {
  if (min == 0 && max == 0) return '무료';
  if (min == max) return '${formatThousands(min)}원';
  return '${formatThousands(min)} ~ ${formatThousands(max)}원';
}
