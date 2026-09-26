import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/performance_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_button.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/hip_hop/lineup_models.dart';
import 'package:vybe/presentation/hip_hop/viewmodels/hip_hop_viewmodel.dart';
import 'package:vybe/presentation/hip_hop/widgets/lineup_header.dart';
import 'package:vybe/presentation/hip_hop/widgets/lineup_skeleton.dart';
import 'package:vybe/presentation/hip_hop/widgets/lineup_timeline_row.dart';

// 오늘의 라인업 — 힙합 페이지 '오늘의 공연 아티스트' 전체 보기.
// claude.ai/design today_lineup.html 디자인 기반. 수치는 디자인(393 기준) 값 그대로.
// 데이터: hipHopViewModelProvider(오늘 performances + 힙합 클럽) 실연동.

class TodayLineupScreen extends ConsumerStatefulWidget {
  const TodayLineupScreen({super.key});

  @override
  ConsumerState<TodayLineupScreen> createState() => _TodayLineupScreenState();
}

class _TodayLineupScreenState extends ConsumerState<TodayLineupScreen> {
  String _type = 'all'; // all | rapper | dj

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom + 90.h;

    final async = ref.watch(hipHopViewModelProvider);
    final data = async.asData?.value;
    final loading = async.isLoading && data == null;

    // 오늘 공연(startAt 오름차순) → 표시 모델.
    final lineup = [
      for (final p in data?.performances ?? const <PerformanceModel>[])
        lineupItemFrom(p),
    ];

    final nowMin = lineupNowMinutes();

    final counts = {
      'all': lineup.length,
      'rapper': lineup.where((l) => !l.isDj).length,
      'dj': lineup.where((l) => l.isDj).length,
    };
    final list = _type == 'all'
        ? lineup
        : lineup.where((l) => (_type == 'dj') == l.isDj).toList();
    LineupItem? nowItem;
    for (final l in lineup) {
      if (lineupStatusOf(l.time, nowMin) == LineupStatus.now) {
        nowItem = l;
        break;
      }
    }
    LineupItem? nextUp;
    for (final l in list) {
      if (lineupStatusOf(l.time, nowMin) == LineupStatus.up) {
        nextUp = l;
        break;
      }
    }

    return Scaffold(
      backgroundColor: kVybeInk,
      body: Stack(
        children: [
          // 상단 오로라 백드롭.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 560.h,
            child: const IgnorePointer(child: VybeAurora()),
          ),
          SafeArea(
            bottom: false,
            child: loading
                // 로딩 중: 전체 레이아웃(인트로·배너·필터·타임라인)을 shimmer로.
                // 실제 데이터 위젯을 빈 값(0팀·배너없음)으로 렌더하지 않도록 분기.
                ? SingleChildScrollView(
                    padding: EdgeInsets.only(top: 44.h),
                    child: const LineupSkeleton(),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverList.list(
                        children: [
                          SizedBox(height: 44.h),
                          LineupIntroMeta(total: lineup.length),
                          if (nowItem != null) LineupNowBanner(item: nowItem),
                          SizedBox(height: 12.h),
                          LineupTypeFilter(
                            active: _type,
                            counts: counts,
                            onChange: (t) => setState(() => _type = t),
                          ),
                        ],
                      ),
                      // 타임라인 — 보이는 줄만 만든다.
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverList.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) => LineupTimelineRow(
                            item: list[i],
                            nowMin: nowMin,
                            isFirst: i == 0,
                            isLast: i == list.length - 1,
                            isNext: list[i].id == nextUp?.id,
                          ),
                        ),
                      ),
                      SliverList.list(
                        children: [
                          if (list.isEmpty)
                            VybeStateMessage(
                              lineup.isEmpty
                                  ? '오늘 예정된 공연이 없어요'
                                  : '해당하는 공연이 없어요',
                              padding: EdgeInsets.symmetric(
                                vertical: 50.h,
                                horizontal: 24.w,
                              ),
                            ),
                          // footer note
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              24.w,
                              10.h,
                              24.w,
                              40.h + bottomPad,
                            ),
                            child: Text(
                              '라인업은 당일 사정에 따라 변경될 수 있어요',
                              textAlign: TextAlign.center,
                              style: VybeTypography.caption.copyWith(
                                fontSize: 11.sp,
                                height: 16 / 11,
                                color: VybeColors.gray600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          // 리퀴드 글래스 뒤로가기 버튼 (오버레이)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 4.h,
            left: 8.w,
            child: VybeGlassButton(
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}
