import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/performance_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/hip_hop/hip_hop_style.dart';
import 'package:vybe/presentation/hip_hop/lineup_models.dart';
import 'package:vybe/presentation/hip_hop/viewmodels/hip_hop_viewmodel.dart';
import 'package:vybe/presentation/hip_hop/widgets/lineup_header.dart';
import 'package:vybe/presentation/hip_hop/widgets/lineup_skeleton.dart';
import 'package:vybe/presentation/hip_hop/widgets/lineup_timeline_row.dart';

/// HOME-009 오늘의 라인업 — 힙합 페이지 '오늘의 공연 아티스트' 전체 보기.
///
/// 디자인 `today_lineup.jsx`. 수치는 디자인(393 기준) 값 그대로.
/// 데이터: `hipHopViewModelProvider`(오늘 performances + 힙합 클럽) 실연동.
///
/// ⚠ 배경은 **단색**이다(디자인 `BG` #0D0A0C) — 오로라를 깔지 않는다.
/// 하단 탭바도 없다(`pushHidingNavBar` 로 연다) — 디자인 App 루트가 헤더 + 본문 둘뿐.
class TodayLineupScreen extends ConsumerStatefulWidget {
  const TodayLineupScreen({super.key});

  @override
  ConsumerState<TodayLineupScreen> createState() => _TodayLineupScreenState();
}

class _TodayLineupScreenState extends ConsumerState<TodayLineupScreen> {
  String _type = 'all'; // all | rapper | dj

  @override
  Widget build(BuildContext context) {
    // pushHidingNavBar 로 들어와 floating nav 가 내려가 있으므로 그만큼의
    // 여백이 필요 없다(saved_screen 과 같은 사유).
    final bottomPad = MediaQuery.paddingOf(context).bottom;

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
      backgroundColor: kLineupBg,
      body: Column(
        children: [
          // 디자인 Header — 뒤로 + 마이크 아이콘 + '오늘의 라인업' + 하단 헤어라인.
          VybePushHeader(
            title: '오늘의 라인업',
            titleIcon: Icon(
              Icons.mic_none_rounded,
              size: 16.r,
              color: Colors.white,
            ),
            bottomBorder: true,
          ),
          Expanded(
            child: loading
                // 로딩 중: 전체 레이아웃(인트로·배너·필터·타임라인)을 shimmer로.
                // 실제 데이터 위젯을 빈 값(0팀·배너없음)으로 렌더하지 않도록 분기.
                ? const SingleChildScrollView(child: LineupSkeleton())
                : CustomScrollView(
                    slivers: [
                      SliverList.list(
                        children: [
                          LineupIntroMeta(
                            total: lineup.length,
                            areaText: lineupAreaText(lineup),
                          ),
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
                          // 조회 실패도 빈 목록으로 들어온다(genre_page_viewmodel 의
                          // .catchError) — 디자인에 오류 상태가 없어 같은 문구로 둔다.
                          if (list.isEmpty)
                            VybeStateMessage(
                              '해당하는 공연이 없어요',
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
        ],
      ),
    );
  }
}
