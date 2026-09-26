import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_map_section.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_image_hero.dart';
import 'package:vybe/presentation/kpop/kpop_models.dart';
import 'package:vybe/presentation/kpop/viewmodels/kpop_viewmodel.dart';
import 'package:vybe/presentation/kpop/widgets/vybe_club_poster_grid.dart';

/// K-POP 장르 페이지 — 인트로 히어로 + 주변 지도 + 가까운 순 클럽 그리드.
///
/// claude.ai/design `kpop_renew.html` 디자인 기반. 수치는 디자인(393 기준) 값 그대로.
/// 데이터는 `clubs`(genre=[kKpopGenre]) 실연동 — 공연 일정 섹션은 디자인에 없어
/// `performances` 를 읽지 않는다.
class KpopScreen extends ConsumerWidget {
  const KpopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 플로팅 바텀 nav(MainScaffold) 가림 방지용 하단 여백.
    final bottomPad = MediaQuery.paddingOf(context).bottom + 90.h;

    final async = ref.watch(kpopClubsProvider);
    final clubs = async.asData?.value ?? const <ClubModel>[];
    final loading = async.isLoading && async.asData == null;

    return Scaffold(
      backgroundColor: kVybeInk,
      // SizedBox.expand로 Stack을 화면 전체로 강제 → 백드롭이 상태바 영역까지 채워진다.
      body: SizedBox.expand(
        child: Stack(
          children: [
            // 배경 — 공용 리뉴얼 오로라 기본색(다른 카테고리 페이지와 동일).
            const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
            Positioned.fill(
              child: CustomScrollView(
                // ⚠ 튕김(오버스크롤) 금지 — 히어로가 상태바 뒤까지 올라가 있어서
                // 위로 당기면 이미지 위에 배경이 드러난다.
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // 히어로가 상태바 뒤까지 채우므로 top 패딩을 두지 않는다.
                  SliverList.list(
                    children: [
                      const VybeImageHero('kpop', heroAspect: 786 / 758),
                      SizedBox(height: 30.h),
                      VybeClubMapSection(
                        clubs: clubs,
                        loading: loading,
                        subject: 'K-POP 클럽',
                        accent: kKpopAccent,
                      ),
                      SizedBox(height: 44.h),
                    ],
                  ),
                  // 그리드는 sliver — 보이는 카드만 만든다.
                  VybeClubPosterGrid(
                    clubs: clubs,
                    loading: loading,
                    filters: kKpopFilters,
                    accent: kKpopAccent,
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 30.h + bottomPad)),
                ],
              ),
            ),
            // 상단 투명 헤더 오버레이 (뒤로가기 · 공유).
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: VybeGlassHeader(),
            ),
          ],
        ),
      ),
    );
  }
}
