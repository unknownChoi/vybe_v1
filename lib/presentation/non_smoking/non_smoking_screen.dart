import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_map_section.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_image_hero.dart';
import 'package:vybe/presentation/non_smoking/non_smoking_models.dart';
import 'package:vybe/presentation/non_smoking/viewmodels/non_smoking_viewmodel.dart';
import 'package:vybe/presentation/non_smoking/widgets/non_smoking_genre_grid.dart';

/// 금연 클럽 페이지 — 인트로 히어로 + 위치별 지도(어디 있는지) + 장르별 그리드(어떤 곳인지).
///
/// claude.ai/design `smoke_free.html` 디자인 기반. 수치는 디자인(393 기준) 값 그대로.
/// 데이터는 `clubs`(isNonSmoking=true) 실연동. 지도 섹션은 K-POP 과 같은 공용 위젯이고
/// 문구만 다르다. 디자인에 있지만 뺀 것(흡연실 섹션 등)은 `non_smoking_models.dart` 참고.
class NonSmokingScreen extends ConsumerWidget {
  const NonSmokingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 플로팅 바텀 nav(MainScaffold) 가림 방지용 하단 여백.
    final bottomPad = MediaQuery.paddingOf(context).bottom + 90.h;

    final async = ref.watch(nonSmokingClubsProvider);
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
                      // 원본(786 x 956)을 배지 32px 위(y=178)에서 갈라 위쪽은 필러,
                      // 아래쪽(778)이 본체 — 다른 페이지와 같은 badgeTopPx 규칙.
                      const VybeImageHero('non_smoking', heroAspect: 786 / 778),
                      SizedBox(height: 30.h),
                      VybeClubMapSection(
                        clubs: clubs,
                        loading: loading,
                        title: '위치별로 금연 클럽 확인',
                        subject: '금연 클럽',
                        accent: kNonSmokingAccent,
                      ),
                      SizedBox(height: 44.h),
                    ],
                  ),
                  // 그리드는 sliver — 보이는 카드만 만든다.
                  NonSmokingGenreGrid(clubs: clubs, loading: loading),
                  SliverToBoxAdapter(child: SizedBox(height: 34.h + bottomPad)),
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
