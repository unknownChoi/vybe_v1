import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/operating_hours.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/free_entry_labels.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 요일별 영업시간 표 (디자인 VR_HOURS 목록).
///
/// 오늘 줄은 흰색 + '오늘' 뱃지, 정기휴무는 레드.
/// 홈 탭(접었다 펴는 영업시간)과 매장 정보 탭(상시 노출)이 공유한다.
class RenewHoursTable extends StatelessWidget {
  final OperatingHours hours;

  const RenewHoursTable({super.key, required this.hours});

  /// 줄 사이 간격 (디자인 9).
  static const double _rowGap = 9;

  @override
  Widget build(BuildContext context) {
    final week = [
      hours.mon,
      hours.tue,
      hours.wed,
      hours.thu,
      hours.fri,
      hours.sat,
      hours.sun,
    ];
    final todayIndex = DateTime.now().weekday - 1;

    return Column(
      children: [
        for (var i = 0; i < week.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == week.length - 1 ? 0 : _rowGap.h,
            ),
            child: _row(week[i], weekdayLabelKo(i + 1), i == todayIndex),
          ),
      ],
    );
  }

  Widget _row(DayHours day, String label, bool today) {
    final off = !day.isOpen;
    return Row(
      children: [
        SizedBox(
          width: 18.w,
          child: Text(
            label,
            style: RenewGlass.caption(
              color: today ? RenewGlass.t1 : RenewGlass.t3,
              lineHeight: 15,
              weight: today ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          off ? '정기휴무' : '${day.open} - ${day.close}',
          style: RenewGlass.caption(
            color: off
                ? VybeColors.accentRed500
                : today
                ? RenewGlass.t1
                : RenewGlass.t3,
            lineHeight: 15,
            weight: today || off ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        if (today) ...[
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: VybeColors.mainPurple500.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              '오늘',
              style: RenewGlass.caption(
                color: RenewGlass.lavender,
                size: 10,
                lineHeight: 12,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 오늘 영업 상태 한 줄 요약 — `02:00에 영업 종료`.
String renewHoursSummary(DayHours today) {
  if (today.isCurrentlyOpen && today.close != null) {
    return '${today.close}에 영업 종료';
  }
  if (today.isOpen && today.open != null) return '${today.open}에 영업 시작';
  return '오늘 휴무';
}
