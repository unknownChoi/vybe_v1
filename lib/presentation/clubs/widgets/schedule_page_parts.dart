import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_skeleton.dart';
import 'package:vybe/presentation/clubs/widgets/schedule_shared.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_meta_dot.dart';

/// 공연 일정 전체 페이지(schedule_all.jsx)를 이루는 조각들.
///
/// 표면·계조는 클럽 상세와 같은 [RenewGlass] 토큰을 쓴다 — 이 페이지는
/// 상세의 '다가오는 라인업 > 전체보기'라 두 화면이 이어져 보여야 한다.

/// 클럽명 · 지역 + '다가오는 공연' + 안내 한 줄.
class SchedulePageIntro extends StatelessWidget {
  final String clubName;
  final String area;

  const SchedulePageIntro({
    super.key,
    required this.clubName,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    final hasMeta = clubName.isNotEmpty || area.isNotEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasMeta) ...[
            Row(
              children: [
                Text(clubName, style: _meta),
                if (clubName.isNotEmpty && area.isNotEmpty)
                  const VybeMetaDot(size: 2),
                Text(area, style: _meta),
              ],
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            '다가오는 공연',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 22 * -0.025,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '공연이 있는 날만 표시돼요. 라인업은 당일 사정에 따라 변경될 수 있어요.',
            style: RenewGlass.caption(),
          ),
        ],
      ),
    );
  }

  TextStyle get _meta => RenewGlass.caption(lineHeight: 12);
}

/// 아티스트 타입 필터 (전체 · 래퍼 · DJ) — 각 칩에 해당 개수를 붙인다.
class SchedulePageFilter extends StatelessWidget {
  /// `all` · `rapper` · `dj` → 개수.
  final Map<String, int> counts;
  final String active;
  final ValueChanged<String> onChange;

  static const _tabs = [('all', '전체'), ('rapper', '래퍼'), ('dj', 'DJ')];

  const SchedulePageFilter({
    super.key,
    required this.counts,
    required this.active,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.h),
      child: Row(
        children: [
          for (final (key, label) in _tabs)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: _Chip(
                label: label,
                count: counts[key] ?? 0,
                selected: key == active,
                onTap: () => onChange(key),
              ),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: selected ? VybeColors.mainPurple500 : RenewGlass.tileFill,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected ? VybeColors.mainPurple500 : RenewGlass.tileBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 13.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 13 * -0.025,
                color: selected ? Colors.white : RenewGlass.t2,
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              '$count',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 11 * -0.025,
                color: selected ? Colors.white70 : RenewGlass.t4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 한 달치 묶음 — `YYYY년 M월 · N일` 헤더 + 날짜 카드들.
class SchedulePageMonthGroup extends StatelessWidget {
  final int month;
  final List<ScheduleDay> days;

  const SchedulePageMonthGroup({
    super.key,
    required this.month,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 15.r,
                  color: RenewGlass.t3,
                ),
                SizedBox(width: 7.w),
                Text(
                  '${days.first.year}년 $month월',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 14 * -0.025,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 6.w),
                Text('· ${days.length}일', style: RenewGlass.caption()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            child: Column(
              children: [
                for (final day in days)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: ScheduleDayCard(day: day),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 하단 '새 공연 소식 알림 받기' 배너.
///
/// ⚠ 푸시 알림 경로가 아직 없어 **표시만** 한다 — 탭 동작을 붙이지 않았다.
class SchedulePageAlertCta extends StatelessWidget {
  const SchedulePageAlertCta({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 0),
      child: RenewGlassCard(
        radius: 14,
        padding: 14,
        paddingV: 13,
        elevated: false,
        fill: const Color(0x1F7731FE), // rgba(119,49,254,0.12)
        border: const Color(0x667731FE),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 16.r,
              color: RenewGlass.lavender,
            ),
            SizedBox(width: 7.w),
            Text(
              '새 공연 소식 알림 받기',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 13 * -0.025,
                color: RenewGlass.lavender,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 일정 로딩 자리 — 필터 칩 + 월 헤더 + 날짜 카드 2장을
/// [SchedulePageFilter]·[SchedulePageMonthGroup] 과 같은 여백으로 깐다.
class SchedulePageSkeleton extends StatelessWidget {
  const SchedulePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RenewSkelChips(widths: [64, 72, 58]),
        SizedBox(height: 18.h),
        const RenewSkelBar(w: 110, h: 14),
        SizedBox(height: 12.h),
        const RenewSkelCard(lines: [null, 180, 140]),
        SizedBox(height: 10.h),
        const RenewSkelCard(lines: [null, 160], quiet: true),
      ],
    ),
  );
}
