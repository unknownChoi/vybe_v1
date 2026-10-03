import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_button.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_button.dart';

/// 상단바 안쪽 행 높이 (디자인 VR_CHROME_H = 상태바 54 + 행 46).
const double kRenewChromeRow = 46;

/// 상단바에 클럽 이름이 나타나는 스크롤 지점.
const double _titleAt = 250;

// ============================================================================
// 상단바 (VRChrome)
// ============================================================================

/// 스크롤 위에 떠 있는 상단바 (디자인 VRChrome).
///
/// 뒤로가기 · 공유 · 찜은 앱 공통 리퀴드 글래스 버튼([VybeGlassButton])을 쓴다.
///
/// ⚠ **찜 버튼이 상단바와 하단 바 양쪽에 있다** — 디자인이 둘을 같은 상태로
/// 묶어 두기 때문이다(`VWChrome` · `VWBottomBar` 둘 다 같은 `saved`). 둘이
/// 같이 바뀌므로 '어느 쪽이 눌린 상태인지' 헷갈릴 일은 없다.
///
/// ⚠ 스크롤이 [_solidAt] 을 넘으면 유리 띠로 바뀐다(디자인 `y > 210`).
/// 넘기 전에는 배경이 없어 히어로가 그대로 비친다.
class RenewChrome extends StatelessWidget {
  final double scrollY;
  final String clubName;
  final VoidCallback onBack;
  final VoidCallback onShare;

  /// 찜 상태 — 하단 바 하트와 같은 값을 본다.
  final bool saved;
  final VoidCallback onSave;

  const RenewChrome({
    super.key,
    required this.scrollY,
    required this.clubName,
    required this.onBack,
    required this.onShare,
    required this.saved,
    required this.onSave,
  });

  /// 상단바가 유리 띠로 바뀌는 스크롤 지점 (디자인 `const solid = y > 210`).
  static const double _solidAt = 210;

  /// 원 지름 = 탭 영역. 디자인 VGlassRound 38px 간격을 그대로 살리려고
  /// 히트 영역을 원 크기에 맞춘다.
  static const double _button = 38;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final solid = scrollY > _solidAt.h;

    // 넘기 전에는 배경·블러·구분선이 전부 없다 — 뒤 콘텐츠가 그대로 지나간다.
    // 넘으면 유리 띠가 켜진다(0.24s). 히어로 사진 위를 글자가 지나는 자리라
    // 블러를 걷어내지 않는다(CLAUDE.md 블러 옵트인 규칙의 예외 자리).
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: solid ? RenewGlass.barBlur : 0,
          sigmaY: solid ? RenewGlass.barBlur : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: solid ? RenewGlass.barFill : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: solid ? RenewGlass.hair : Colors.transparent,
              ),
            ),
          ),
          padding: EdgeInsets.only(top: topInset),
          child: SizedBox(
            height: kRenewChromeRow.h,
            child: Row(
              children: [
                SizedBox(width: (RenewGlass.pagePad - 8).w),
                VybeGlassButton(
                  onTap: onBack,
                  icon: Icons.arrow_back_ios_new_rounded,
                  size: _button,
                  iconSize: 17,
                  hitSize: _button,
                ),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: scrollY > _titleAt.h ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        clubName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: VybeTypography.button1.copyWith(
                          color: RenewGlass.t1,
                        ),
                      ),
                    ),
                  ),
                ),
                VybeGlassButton(
                  onTap: onShare,
                  icon: Icons.ios_share_rounded,
                  size: _button,
                  iconSize: 16,
                  hitSize: _button,
                ),
                SizedBox(width: 8.w),
                // 찜 — 누르면 1.12배로 살짝 커진다(디자인 scale).
                VybeGlassButton(
                  onTap: onSave,
                  icon: saved
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: saved ? VybeColors.mainPurple500 : Colors.white,
                  size: _button,
                  iconSize: 16,
                  hitSize: _button,
                ),
                SizedBox(width: (RenewGlass.pagePad - 8).w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 탭 바 (VRTabs)
// ============================================================================

/// 5개 세그먼트 탭. 선택된 칸만 흰 pill.
class RenewTabBar extends StatelessWidget {
  final List<String> tabs;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const RenewTabBar({
    super.key,
    required this.tabs,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return RenewBar(
      // 디자인 VRTabs — 유리 띠 + 위·아래 헤어라인. 채움을 안 주면 헤어라인 두
      // 줄만 화면을 가로지르고 뒤 콘텐츠가 그대로 비친다.
      fill: RenewGlass.barFill,
      topBorder: true,
      bottomBorder: true,
      padding: EdgeInsets.symmetric(
        horizontal: RenewGlass.pagePad.w,
        vertical: 9.h,
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = i == activeIndex;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == tabs.length - 1 ? 0 : 2.w),
              child: GestureDetector(
                onTap: () => onSelect(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(vertical: 9.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    tabs[i],
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12.sp,
                      height: 16 / 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 12 * -0.025,
                      color: selected ? RenewGlass.ink : RenewGlass.t3,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================================
// 하단 액션 바 (VRBottomBar)
// ============================================================================

/// 하트(+찜 수) + 웨이팅 등록 + 테이블 예약. 화면 맨 아래 고정 (디자인 VWBottomBar).
///
/// ⚠ **배경·블러·구분선이 없다** — 디자인은 버튼만 오로라 위에 떠 있는 바다.
/// 베타가 깔던 유리 띠를 걷었다.
///
/// ⚠ 버튼 노출은 `clubs.features`, 활성은 `ops/live.phase`·`waiting.accept`가
/// 정한다(설계 6-0 CLUB-021). 꺼진 기능은 **버튼을 아예 그리지 않는다** —
/// 회색으로 두면 눌러 보고 나서야 안 된다는 걸 안다.
class RenewBottomBar extends StatelessWidget {
  final bool saved;

  /// 하트 아래 숫자 — `clubs.favoriteCount`.
  final int saveCount;
  final VoidCallback onSave;

  /// 웨이팅 버튼. null 이면 이 클럽은 웨이팅을 안 쓴다(버튼 없음).
  final VoidCallback? onWaiting;

  /// 웨이팅 버튼 라벨 — 등록 전 '웨이팅 등록' · 접수 중지/마감 문구 ·
  /// 내 티켓이 있으면 '웨이팅 N번째'.
  final String waitingLabel;

  /// 내 티켓이 있어 라임으로 그릴지 (디자인 `ticket ? 라임 : quiet`).
  final bool waitingActive;

  /// 접수를 안 받아 누를 수 없는지.
  final bool waitingDisabled;

  /// 테이블 예약 버튼. null 이면 버튼 없음.
  final VoidCallback? onReserve;

  const RenewBottomBar({
    super.key,
    required this.saved,
    required this.saveCount,
    required this.onSave,
    this.onWaiting,
    this.waitingLabel = '웨이팅 등록',
    this.waitingActive = false,
    this.waitingDisabled = false,
    this.onReserve,
  });

  /// 홈 인디케이터가 있으면 그만큼, 없으면 디자인 값 30.
  static double bottomInset(BuildContext context) {
    final safe = MediaQuery.paddingOf(context).bottom;
    return safe > 30.h ? safe : 30.h;
  }

  /// 콘텐츠가 바에 가리지 않도록 확보해야 할 높이.
  static double height(BuildContext context) =>
      12.h + 56.h + bottomInset(context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        RenewGlass.pagePad.w,
        12.h,
        RenewGlass.pagePad.w,
        bottomInset(context),
      ),
      child: Row(
        children: [
          _SaveButton(saved: saved, count: saveCount, onTap: onSave),
          if (onWaiting != null) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: RenewButton(
                label: waitingLabel,
                variant: waitingActive
                    ? RenewButtonVariant.lime
                    : RenewButtonVariant.quiet,
                onTap: waitingDisabled ? null : onWaiting,
              ),
            ),
          ],
          if (onReserve != null) ...[
            SizedBox(width: 12.w),
            Expanded(child: RenewButton(label: '테이블 예약', onTap: onReserve)),
          ],
        ],
      ),
    );
  }
}

/// 하트 + 찜 수 (디자인 46×56 세로 칸). 베타의 56×56 정사각 타일을 교체했다.
class _SaveButton extends StatelessWidget {
  final bool saved;
  final int count;
  final VoidCallback onTap;

  const _SaveButton({
    required this.saved,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 46.w,
        height: 56.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: saved ? 1.1 : 1,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              child: Icon(
                saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 23.r,
                color: saved ? VybeColors.mainPurple500 : RenewGlass.t2,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              '$count',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12.sp,
                height: 1,
                fontWeight: FontWeight.w600,
                color: saved ? RenewGlass.lavender : RenewGlass.t4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
