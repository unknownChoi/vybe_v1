import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_chip_poster_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_map_section.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_image_hero.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/service_drinks/service_drinks_models.dart';
import 'package:vybe/presentation/service_drinks/viewmodels/service_drinks_viewmodel.dart';

/// 서비스 음료 페이지 — 이미지 히어로 + ① 내 주변 서비스 음료 클럽(지도)
/// + ② 음료 종류별로 무료 클럽 확인(칩 + 가까운 순 그리드) + 하단 안내.
///
/// claude.ai/design `service_drinks_renew.html` 디자인 기반. 데이터는
/// `clubs.serviceDrink`(isOffered=true) 실연동. 지도·그리드는 K-POP·금연 페이지와
/// 같은 공용 위젯이고 문구·칩·카드 하단 뱃지만 다르다. 디자인에 있지만 뺀 것
/// (혜택별 섹션 등)은 `service_drinks_models.dart` 참고.
class ServiceDrinksScreen extends ConsumerWidget {
  const ServiceDrinksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 플로팅 바텀 nav(MainScaffold) 가림 방지용 하단 여백.
    final bottomPad = MediaQuery.paddingOf(context).bottom + 90.h;

    final async = ref.watch(serviceDrinksViewModelProvider);
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
                      // ⚠ 이미지에 '제공 클럽 14곳'이 박혀 있다 — 실데이터 아님.
                      const VybeImageHero(
                        'service_drinks',
                        heroAspect: 786 / 760,
                      ),
                      SizedBox(height: 30.h),
                      if (async.hasError)
                        VybeStateMessage(
                          '서비스 음료 클럽을 불러오지 못했어요',
                          padding: EdgeInsets.symmetric(
                            vertical: 60.h,
                            horizontal: 24.w,
                          ),
                        )
                      else ...[
                        VybeClubMapSection(
                          clubs: clubs,
                          loading: loading,
                          title: '내 주변 서비스 음료 클럽',
                          subject: '서비스 음료 클럽',
                          accent: kDrinkAccent,
                        ),
                        SizedBox(height: 44.h),
                      ],
                    ],
                  ),
                  // 그리드는 sliver — 보이는 카드만 만든다.
                  if (!async.hasError)
                    VybeChipPosterGrid(
                      title: '음료 종류별로 무료 클럽 확인',
                      chips: serviceDrinkTypesOf(clubs),
                      clubs: clubs,
                      matches: (c, type) =>
                          c.serviceDrink.drinks.contains(type),
                      loading: loading,
                      accent: kDrinkAccent,
                      chipIcon: Icons.liquor_rounded,
                      emptyText: '이 음료를 주는 클럽이 아직 없어요',
                      // 카드 하단은 #태그 대신 제공 문구(디자인 SdPerkBadge).
                      footer: (c) => VybePosterBadge(
                        icon: Icons.liquor_rounded,
                        label: c.serviceDrink.comment,
                        accent: kDrinkAccent,
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      24.w,
                      26.h,
                      24.w,
                      30.h + bottomPad,
                    ),
                    sliver: const SliverToBoxAdapter(
                      child: RenewFooterNote(
                        text:
                            '서비스 음료는 매장 사정과 입장 시간에 따라 변동될 수 있어요. '
                            '방문 전 클럽 상세에서 한 번 더 확인해 주세요.',
                        iconColor: kDrinkAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 상단 투명 헤더 오버레이 — 우측은 디자인대로 검색(검색 탭 전환).
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: VybeGlassHeader(
                rightIcon: Icons.search_rounded,
                // 홈 검색 버튼과 같은 규칙 — 화면을 push 하지 않고 검색 탭(3)으로 전환.
                onShare: () =>
                    ref.read(tabSwitchRequestProvider.notifier).request(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
