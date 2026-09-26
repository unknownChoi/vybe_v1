import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/clubs/viewmodels/favorite_viewmodel.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_poster_sliver_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';

/// '{기준}별로 {대상} 확인' 섹션 — 칩(단일 선택) + 가까운 순 2열 포스터 그리드.
/// **sliver** — `CustomScrollView.slivers` 안에 둔다(보이는 카드만 만든다).
///
/// 금연 페이지(장르 칩) 전용이던 것을 서비스 음료 페이지(음료 종류 칩)가 같은 구조로
/// 쓰게 되면서 승격했다 — 화면마다 다른 건 칩 목록·소속 판정·카드 하단 줄뿐이라
/// 그것만 받는다. K-POP 의 다중 선택 필터 그리드(`VybeClubPosterGrid`)와 달리
/// 칩 하나가 곧 목록이라 개수 표기가 없다. 칩 선택은 이 섹션 밖에서 안 쓰므로
/// 여기가 들고 있는다.
class VybeChipPosterGrid extends ConsumerStatefulWidget {
  final String title;

  /// 칩 목록(표시 순서대로). **실제 클럽이 있는 값만** 넘길 것 — 0곳인 칩은
  /// 눌러 봐야 '없어요'만 나온다. 비면 [emptyText].
  final List<String> chips;

  /// 이 페이지의 클럽 전체(활성).
  final List<ClubModel> clubs;

  /// 클럽이 이 칩에 속하는지.
  final bool Function(ClubModel club, String chip) matches;

  final bool loading;

  /// 카드 LIVE 뱃지 색(화면 포인트 색).
  final Color accent;

  /// 카드 맨 아래 줄. null이면 `#태그`.
  final Widget Function(ClubModel club)? footer;

  /// 목록이 비었을 때 문구.
  final String emptyText;

  /// 칩 라벨 앞 아이콘. null이면 글자만.
  final IconData? chipIcon;

  const VybeChipPosterGrid({
    super.key,
    required this.title,
    required this.chips,
    required this.clubs,
    required this.matches,
    required this.loading,
    required this.emptyText,
    this.accent = VybeColors.mainLime500,
    this.footer,
    this.chipIcon,
  });

  @override
  ConsumerState<VybeChipPosterGrid> createState() => _VybeChipPosterGridState();
}

class _VybeChipPosterGridState extends ConsumerState<VybeChipPosterGrid> {
  /// 고른 칩. null이면 아직 안 골랐다 — 첫 칩.
  String? _chip;

  // 찜 토글 — favorites 실연동(다른 화면과 동일 패턴).
  void _toggleFavorite(String clubId, bool currentIsFav) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return; // 비로그인 — 추후 로그인 유도 처리
    ref
        .read(favoriteViewModelProvider.notifier)
        .toggleFavorite(uid, clubId, currentIsFav);
  }

  @override
  Widget build(BuildContext context) {
    final chips = widget.chips;
    // 고른 칩이 목록에 없으면(아직 안 골랐거나 데이터가 바뀜) 첫 칩으로.
    final chip = chips.contains(_chip) ? _chip : chips.firstOrNull;

    final me = ref.watch(userLocationProvider);
    final origin = (lat: me.lat, lng: me.lng);
    // 원본 클럽은 [footer] 가 받고(카드 모델엔 서비스 음료 문구 같은 게 없다),
    // 카드 모델은 거리 정렬·카드가 쓴다.
    final list = [
      for (final c in widget.clubs)
        if (chip != null && widget.matches(c, chip))
          (club: c, poster: vybeClubPosterFrom(c, origin: origin)),
    ]..sort((a, b) => a.poster.dist.compareTo(b.poster.dist));

    return SliverMainAxisGroup(
      slivers: [
        SliverList.list(
          children: [
            VybeSectionHead(
              title: widget.title,
              sub: widget.loading || chip == null
                  ? '가까운 순'
                  : '$chip · ${list.length}곳 · 가까운 순',
            ),
            // 로딩 중엔 칩 항목을 모르니 자리만 잡아 둔다(지도 섹션과 같은 이유).
            if (widget.loading)
              const VybeChipRowSkeleton()
            else if (chip != null)
              VybeChipRow(
                items: chips,
                active: chip,
                onChange: (c) => setState(() => _chip = c),
                icon: widget.chipIcon,
              ),
            SizedBox(height: 14.h),
          ],
        ),
        if (widget.loading)
          const VybePosterSliverGridSkeleton()
        else if (list.isEmpty)
          SliverToBoxAdapter(
            child: VybeStateMessage(
              widget.emptyText,
              padding: EdgeInsets.symmetric(vertical: 34.h, horizontal: 24.w),
            ),
          )
        else
          // 디자인의 카드 `riseIn` 은 뺐다 — sliver 격자는 스크롤로 벗어난 카드를
          // 버렸다 다시 만들어 되돌아올 때마다 페이드인이 재생된다. EDM·K-POP·힙합
          // 격자와 같은 그림.
          VybePosterSliverGrid(
            key: ValueKey(chip),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final (:club, poster: c) = list[i];
              // 찜 여부 하나만 구독 — 다른 클럽 찜에 이 카드가 다시 그려지지 않는다.
              return Consumer(
                builder: (context, ref, _) {
                  final saved = ref.watch(
                    mergedFavoriteIdsProvider.select((s) => s.contains(c.id)),
                  );
                  return VybeClubPosterCard(
                    club: c,
                    saved: saved,
                    onSave: () => _toggleFavorite(c.id, saved),
                    onTap: () => openClubDetail(context, c.id),
                    accent: widget.accent,
                    footer: widget.footer?.call(club),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
