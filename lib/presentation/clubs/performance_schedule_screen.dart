import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/clubs/viewmodels/club_schedule_viewmodel.dart';
import 'package:vybe/presentation/clubs/widgets/schedule_page_parts.dart';
import 'package:vybe/presentation/clubs/widgets/schedule_shared.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';

// 공연 일정 전체 페이지 — 클럽 상세 '다가오는 라인업 > 전체보기'에서 진입.
// claude.ai/design schedule_all.html (schedule_all.jsx) 기반.
// performances 컬렉션 실연동. 타입 필터(전체/래퍼/DJ) + 월별 그룹핑 + 알림 CTA.
//
// 배경·카드는 클럽 상세와 **같은 리뉴얼 셸**을 쓴다 (오로라 + RenewGlass) —
// 전체보기로 넘어왔는데 판이 평평한 회색으로 바뀌면 다른 앱처럼 보인다.

class PerformanceScheduleScreen extends ConsumerStatefulWidget {
  final String clubId;
  final String? clubName;
  final String? area;
  const PerformanceScheduleScreen({
    super.key,
    required this.clubId,
    this.clubName,
    this.area,
  });

  @override
  ConsumerState<PerformanceScheduleScreen> createState() =>
      _PerformanceScheduleScreenState();
}

class _PerformanceScheduleScreenState
    extends ConsumerState<PerformanceScheduleScreen> {
  String _type = 'all'; // all | rapper | dj

  Map<String, int> _countsOf(List<ScheduleDay> days) {
    int count(bool Function(ScheduleAct) test) =>
        days.fold(0, (n, d) => n + d.acts.where(test).length);
    return {
      'all': count((_) => true),
      'rapper': count((a) => a.type == 'rapper'),
      'dj': count((a) => a.type == 'dj'),
    };
  }

  List<ScheduleDay> _filtered(List<ScheduleDay> days) {
    if (_type == 'all') return days;
    return days
        .map(
          (d) => d.copyWithActs(d.acts.where((a) => a.type == _type).toList()),
        )
        .where((d) => d.acts.isNotEmpty)
        .toList();
  }

  // 월별 그룹
  List<MapEntry<int, List<ScheduleDay>>> _monthsOf(List<ScheduleDay> days) {
    final map = <int, List<ScheduleDay>>{};
    for (final d in days) {
      map.putIfAbsent(d.month, () => []).add(d);
    }
    return map.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    final clubName = widget.clubName ?? '';
    final area = widget.area ?? '';
    final async = ref.watch(clubScheduleProvider(widget.clubId));

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
            Positioned.fill(
              child: Column(
                children: [
                  const VybePushHeader(title: '공연 일정'),
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        SchedulePageIntro(clubName: clubName, area: area),
                        ...async.when(
                          loading: () => const [SchedulePageSkeleton()],
                          error: (_, __) => [_message('공연 일정을 불러오지 못했어요')],
                          data: (days) => _body(days),
                        ),
                        const SchedulePageAlertCta(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
                          child: Center(
                            child: Text(
                              '일정은 매장 사정에 따라 변경될 수 있습니다.',
                              style: RenewGlass.caption(
                                size: 11,
                                lineHeight: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 목록 자리를 대신하는 회색 안내 한 줄 (오류 · 공연 없음).
  Widget _message(String text) => VybeStateMessage(
    text,
    padding: EdgeInsets.symmetric(vertical: 50.h),
    lineHeight: 16,
  );

  List<Widget> _body(List<ScheduleDay> days) {
    final counts = _countsOf(days);
    final months = _monthsOf(_filtered(days));
    return [
      SchedulePageFilter(
        counts: counts,
        active: _type,
        onChange: (t) => setState(() => _type = t),
      ),
      if (months.isEmpty)
        _message('해당하는 공연이 없어요')
      else
        for (final month in months)
          SchedulePageMonthGroup(month: month.key, days: month.value),
    ];
  }
}
