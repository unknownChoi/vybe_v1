import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/navigation/swipe_back_page_route.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/common/widgets/vybe_fade_in_up.dart';
import 'package:vybe/presentation/common/widgets/vybe_home_club_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_pill.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/free_entry/free_entry_screen.dart';
import 'package:vybe/presentation/home/home_models.dart';
import 'package:vybe/presentation/home/viewmodels/home_free_time_viewmodel.dart';
import 'package:vybe/presentation/home/widgets/home_screen_skeleton.dart';
import 'package:vybe/presentation/home/widgets/home_section_head.dart';

/// 홈 '이 시간에만 무료입장' — 특정 시간대에만 입장료가 0원인 클럽 가로 목록.
///
/// 디자인 `home.jsx > FreeTimeClubs`.
/// 데이터는 `clubs.freeEntry.type == 'timed'`, 지금 무료인지는 앱이 판정한다
/// (Firestore는 요일×시:분×자정 넘김을 쿼리할 수 없다).
class HomeFreeTimeClubs extends ConsumerWidget {
  const HomeFreeTimeClubs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsync = ref.watch(homeFreeTimeClubsProvider);
    // 설계 단위 — VybeStateMessage 가 내부에서 `.h` 로 환산한다.
    const cardHeight = 156.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHead(
            title: '타임 무료입장',
            sub: '이 시간대에만 입장료 0원',
            onAction: () => Navigator.of(context).push(
              SwipeBackPageRoute<void>(builder: (_) => const FreeEntryScreen()),
            ),
          ),
          clubsAsync.when(
            data: (clubs) => clubs.isEmpty
                ? const VybeStateMessage(
                    '지금 예정된 무료입장 시간이 없어요',
                    height: cardHeight,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      children: List.generate(clubs.length, (i) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: i < clubs.length - 1 ? 12.w : 0,
                          ),
                          child: VybeFadeInUp(
                            delay: Duration(milliseconds: 45 * i),
                            child: _FreeTimeCard(club: clubs[i]),
                          ),
                        );
                      }),
                    ),
                  ),
            loading: () => const HomeClubCardRailSkeleton(),
            error: (_, __) => const VybeStateMessage(
              '무료입장 정보를 불러오지 못했어요',
              height: cardHeight,
            ),
          ),
        ],
      ),
    );
  }
}

/// 250×156 카드 — 공용 [VybeHomeClubCard] 위에 이 섹션 고유 줄만 얹는다
/// (주변 클럽 카드와 같은 판 · 같은 하단 글래스 바).
class _FreeTimeCard extends StatelessWidget {
  final HomeFreeTimeClub club;

  const _FreeTimeCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return VybeHomeClubCard(
      thumbnailUrl: club.thumbnailUrl,
      gradient: club.gradient,
      onTap: () => openClubDetail(context, club.clubId),
      badges: [
        if (club.freeNow)
          const VybePill(
            label: '지금 무료',
            tone: VybePillTone.lime,
            dot: true,
            live: true,
          )
        else if (club.startsLabel != null)
          VybePill(icon: Icons.schedule_rounded, label: club.startsLabel!)
        else
          const SizedBox.shrink(),
        if (club.remainingLabel != null)
          VybePill(label: club.remainingLabel!, tone: VybePillTone.dark)
        else
          const SizedBox.shrink(),
      ],
      info: [
        // 무료 시간대 + 평상시 요금 — 이 섹션만의 줄.
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            // 시간 표기가 이 줄의 주인공 — 좁아지면 요금보다 먼저 자리를 갖는다.
            Flexible(
              child: Text(
                club.windowLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: VybeTypography.tagline.copyWith(
                  height: 16 / 14,
                  color: VybeColors.mainLime500,
                ),
              ),
            ),
            if (club.normalFeeLabel.isNotEmpty) ...[
              SizedBox(width: 7.w),
              // 무료 시간이 끝나면 받는 값 — 취소선으로 대비를 준다.
              Text(
                club.normalFeeLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: VybeTypography.caption.copyWith(
                  color: VybeColors.gray400,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
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
          distanceKm: club.distanceKm,
          area: club.area,
          genre: club.genre,
        ),
      ],
    );
  }
}
