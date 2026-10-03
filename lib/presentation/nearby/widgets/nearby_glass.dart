import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/operating_hours.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/clubs/widgets/club_glass.dart';
import 'package:vybe/presentation/common/filter_chip_style.dart';
import 'package:vybe/presentation/common/widgets/vybe_liquid_press.dart';

/// 주변 페이지 리퀴드 글래스 공통 요소.
///
/// 디자인: nearby_glass_shell.jsx (NG 토큰 · NGCard · NGRound) 기준.
/// 클럽 상세와 값이 같은 토큰(ink · tile · hair · 텍스트 계조 t1~t4)은
/// [ClubGlass]를 그대로 쓰고, 주변 전용(시트 · 지도 위 플로팅)만 여기 둔다.
///
/// ⚠ 지도 위 표면은 **BackdropFilter를 쓰지 않는다** — 네이버 지도는 플랫폼 뷰라
/// 블러가 지도 픽셀을 못 읽어 효과가 0인데, 시트 드래그·핀 카드 등장마다
/// 화면의 절반을 매 프레임 블러하는 비용만 들었다(주변 탭 끊김의 원인).
/// 시트·플로팅·pill·핀 카드·GNB 전부 채움 + 테두리만 그린다.

// ============================================================================
// 토큰
// ============================================================================

class NearbyGlass {
  NearbyGlass._();

  /// 시트 채움 (NG.sheet) — 디자인은 rgba(23,21,31,0.68)이지만 0.82로 올렸다.
  /// 블러가 없으니(위 참고) 디자인 값 그대로면 시트 글자가 지도와 겹쳐 읽힌다.
  static const Color sheetFill = Color(0xD117151F);

  /// 시트 상단 테두리 — rgba(255,255,255,0.14)
  static const Color sheetBorder = Color(0x24FFFFFF);

  /// 지도 위 플로팅 요소 채움 (NG.float) — rgba(20,18,26,0.46)
  static const Color floatFill = Color(0x7514121A);

  /// 플로팅 테두리 — rgba(255,255,255,0.16)
  static const Color floatBorder = Color(0x29FFFFFF);

  /// 시트 안 칩(비활성) 채움 — rgba(255,255,255,0.06).
  /// 값은 [kFilterChipFill] 단일 소스 (카테고리 페이지 칩과 같은 외형).
  static const Color chipFill = kFilterChipFill;

  /// 활성 칩 보라 그라데이션 (135deg, 0.95 → 0.7) — [kFilterChipActiveGradient].
  static const LinearGradient activeChip = kFilterChipActiveGradient;

  static TextStyle chipText({required bool selected}) =>
      filterChipTextStyle(selected: selected);
}

// ============================================================================
// 지도 위 플로팅 (NGRound · NG.float)
// ============================================================================

/// 지도 위 원형 글래스 버튼 (내 위치 등). 지름 44.
class NearbyRoundButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const NearbyRoundButton({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return VybeLiquidPress(
      onTap: onTap,
      circle: true,
      child: NearbyFloatSurface(
        radius: 22,
        child: SizedBox(
          width: 44.r,
          height: 44.r,
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// 지도 위 플로팅 표면 — 반투명 채움 + 테두리 + 그림자.
/// 원형 버튼 · 재검색 pill이 이 표면을 쓴다.
class NearbyFloatSurface extends StatelessWidget {
  final Widget child;
  final double radius;

  const NearbyFloatSurface({super.key, required this.child, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius.r);
    return Container(
      decoration: BoxDecoration(
        color: NearbyGlass.floatFill,
        borderRadius: r,
        border: Border.all(color: NearbyGlass.floatBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66000000),
            blurRadius: 22.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ============================================================================
// 시트 (NG.sheet)
// ============================================================================

/// 지도 위로 올라오는 글래스 시트 표면.
/// 상단 라운드 28 + 상단 오로라 글로우(보라·라임). 리스트/상세 시트 공용.
class NearbySheetSurface extends StatelessWidget {
  final Widget child;

  const NearbySheetSurface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NearbyGlass.sheetFill,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x80000000),
            blurRadius: 40.r,
            offset: Offset(0, -14.h),
          ),
        ],
      ),
      // 스크롤 내용이 라운드 밖으로 새지 않게 클립 (그림자는 클립 밖에 그려진다).
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // 상단 오로라 — 좌측 보라 · 우측 라임 (radial-gradient 2겹).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160.h,
            child: const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.76, -1),
                    radius: 1.1,
                    colors: [Color(0x387731FE), Color(0x007731FE)],
                    stops: [0.0, 0.7],
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.84, -1),
                      radius: 1.05,
                      colors: [Color(0x17B5FF60), Color(0x00B5FF60)],
                      stops: [0.0, 0.7],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 상단 1px 하이라이트 (inset 0 1px 0 rgba(255,255,255,0.18))
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 1,
            child: ColoredBox(color: NearbyGlass.sheetBorder),
          ),
          child,
        ],
      ),
    );
  }
}

/// 시트 상단 드래그 핸들 (40 x 4.5).
class NearbySheetHandle extends StatelessWidget {
  const NearbySheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.5.h,
        decoration: BoxDecoration(
          color: const Color(0x47FFFFFF),
          borderRadius: BorderRadius.circular(99.r),
        ),
      ),
    );
  }
}

// ============================================================================
// 작은 조각
// ============================================================================

/// 영업중이면 라임, 아니면 회색 점. 영업중일 때만 맥박 애니메이션(ngLive).
class NearbyLiveDot extends StatefulWidget {
  final bool live;
  final double size;

  const NearbyLiveDot({super.key, required this.live, this.size = 5});

  @override
  State<NearbyLiveDot> createState() => _NearbyLiveDotState();
}

class _NearbyLiveDotState extends State<NearbyLiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (widget.live) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(NearbyLiveDot old) {
    super.didUpdateWidget(old);
    if (widget.live && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (!widget.live && _ctrl.isAnimating) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: widget.size.r,
      height: widget.size.r,
      decoration: BoxDecoration(
        color: widget.live ? VybeColors.mainLime500 : const Color(0x4DFFFFFF),
        shape: BoxShape.circle,
      ),
    );
    if (!widget.live) return dot;
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.45).animate(_ctrl),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 1.35).animate(_ctrl),
        child: dot,
      ),
    );
  }
}

// ============================================================================
// 거리 표기
// ============================================================================

/// 미터 → `320m` / `1.2km` (디자인 ngDist).
String formatDistance(double meters) {
  if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(1)}km';
  return '${meters.round()}m';
}

/// 미터 → 도보 분 (디자인 ngWalk: 75m/분, 최소 1분).
int walkMinutes(double meters) {
  final m = (meters / 75).round();
  return m < 1 ? 1 : m;
}

/// `도보 5분 · 320m`. 거리를 모르면 null.
String? walkLabel(double? meters) {
  if (meters == null) return null;
  return '도보 ${walkMinutes(meters)}분 · ${formatDistance(meters)}';
}

// ============================================================================
// 영업 시간 표기
// ============================================================================

/// 오늘 영업 안내 한 줄 (디자인 `club.hours`: `02:00에 영업 종료` · `내일 22:00 오픈`).
///
/// 영업 중이면 마감 시각, 영업 전이면 오픈 시각을 안내한다.
/// 주변 리스트 카드와 핀 카드가 같은 문구를 쓰므로 여기 둔다.
///
/// 오픈 시각이 **이미 지났으면 '내일' 을 붙인다** — 디자인 PLACE-020 의 `내일 22:00 오픈`.
/// 오늘 22시에 여는 가게를 새벽 3시에 보면 '22:00 오픈'은 15분 뒤처럼 읽힌다.
/// [now] 는 화면이 한 번 읽어 넘긴다(카드마다 다시 읽으면 목록 안에서 기준이 어긋난다).
String todayHoursLabel(DayHours today, {DateTime? now}) {
  if (!today.isOpen) return '오늘 휴무';
  if (today.isCurrentlyOpen) {
    return today.close != null ? '${today.close}에 영업 종료' : '영업 시간 미등록';
  }
  final open = today.open;
  if (open == null) return '영업 시간 미등록';
  return _openAlreadyPassed(open, now ?? DateTime.now())
      ? '내일 $open 오픈'
      : '$open 오픈';
}

/// 'HH:mm' 오픈 시각이 오늘 기준 이미 지났는지.
bool _openAlreadyPassed(String open, DateTime now) {
  final parts = open.split(':');
  if (parts.length != 2) return false;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return false;
  return now.hour > h || (now.hour == h && now.minute >= m);
}

/// 사진 위에 얹는 작은 글래스 pill (지도 핀 카드 · 시트 리스트 항목 공용).
///
/// 두 곳이 같은 모양을 복붙해 쓰고 있어 승격했다. 화면마다 다른 건 채움색·테두리·
/// 세로 여백뿐이라 파라미터로 받되 **기본값은 핀 카드 값([ClubGlass])** 을 유지한다.
class NearbyGlassPill extends StatelessWidget {
  final Widget child;

  /// 반투명 채움색.
  final Color? fill;

  /// 헤어라인 테두리 색.
  final Color? border;

  /// 세로 안쪽 여백(dp, `.h` 적용 전).
  final double vPadding;

  const NearbyGlassPill({
    super.key,
    required this.child,
    this.fill,
    this.border,
    this.vPadding = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: vPadding.h),
      decoration: BoxDecoration(
        color: fill ?? ClubGlass.barFill,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: border ?? ClubGlass.hair),
      ),
      child: child,
    );
  }
}
