import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/core/utils/gradient_palette.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/widgets/vybe_fade_in_up.dart';
import 'package:vybe/presentation/common/widgets/vybe_home_club_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_pill.dart';
import 'package:vybe/presentation/common/widgets/vybe_recommend_badge.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/home/viewmodels/home_nearby_viewmodel.dart';
import 'package:vybe/presentation/home/widgets/home_screen_skeleton.dart';
import 'package:vybe/presentation/home/widgets/home_section_head.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';

/// 홈 '주변 클럽' — 디자인 `home.jsx > NearbyClubs`.
///
/// ⚠ 디자인의 혼잡도 pill(`지금 붐벼요`·`활기참`·`여유로움`)은 **없다** —
/// `clubs` 에도 설계 4장에도 혼잡도 필드가 없다. 고정 문구로 채우면 전 클럽이
/// 같은 혼잡도라고 말하는 거짓 정보가 된다(HOME-005 차이 #4 · 남김).
class HomeNearbyClubs extends ConsumerWidget {
  const HomeNearbyClubs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(homeNearbyClubsProvider);
    // 거리 기준점 — 좌표만 본다(라벨이 바뀌어도 다시 안 그린다).
    final me = ref.watch(
      userLocationProvider.select((l) => (lat: l.lat, lng: l.lng)),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8.h, 0, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHead(
            title: '주변 클럽',
            // 주변 탭(index 1)으로 전환 — MainScaffold가 listen해 점프.
            onAction: () =>
                ref.read(tabSwitchRequestProvider.notifier).request(1),
          ),
          clubsAsync.when(
            // 위치 칩으로 다시 조회하는 동안엔 있던 카드를 그대로 둔다 —
            // 5장이 통째로 스켈레톤으로 바뀌었다 돌아오면 화면이 튄다.
            skipLoadingOnReload: true,
            data: (clubs) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: List.generate(clubs.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: i < clubs.length - 1 ? 12.w : 0,
                    ),
                    // 디자인은 세 섹션 모두 카드를 순차 등장시킨다(45ms × index).
                    child: VybeFadeInUp(
                      delay: Duration(milliseconds: 45 * i),
                      child: _ClubCard(club: clubs[i], origin: me),
                    ),
                  );
                }),
              ),
            ),
            loading: () => const HomeClubCardRailSkeleton(),
            error: (_, __) => const VybeStateMessage(
              '클럽 정보를 불러올 수 없어요',
              height: VybeHomeClubCard.height,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  final ClubModel club;
  final ({double lat, double lng}) origin;

  const _ClubCard({required this.club, required this.origin});

  @override
  Widget build(BuildContext context) {
    return VybeHomeClubCard(
      thumbnailUrl: club.thumbnailUrl,
      gradient: clubGradientFor(club.clubId),
      onTap: () => openClubDetail(context, club.clubId),
      badges: [
        // 디자인 좌측 칸(혼잡도)은 데이터가 없어 비워 둔다 — 평점은 우측.
        const SizedBox.shrink(),
        VybePill(
          tone: VybePillTone.dark,
          icon: Icons.star_rounded,
          iconColor: VybeColors.mainLime500,
          label: club.rating.toStringAsFixed(1),
        ),
      ],
      info: [
        // 디자인은 추천 뱃지를 이름 **윗줄 독립 행**으로 깐다.
        if (club.isVybeRecommended)
          const Align(
            alignment: Alignment.centerLeft,
            child: VybeRecommendBadge(size: 10, label: 'VYBE 추천'),
          ),
        Text(
          club.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 18 * -0.025,
          ),
        ),
        VybeHomeCardMeta(
          // 좌표가 없는 클럽(0,0)은 거리를 그리지 않는다.
          distanceKm: club.lat == 0 && club.lng == 0
              ? null
              : vybeClubDistanceKm(club.lat, club.lng, origin: origin),
          area: club.area,
          genre: club.genre,
        ),
      ],
    );
  }
}
