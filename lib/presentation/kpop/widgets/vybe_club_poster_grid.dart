import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/clubs/viewmodels/favorite_viewmodel.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_poster_sliver_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';

typedef _Entry = ({ClubModel club, VybeClubPoster poster});

/// '가까운 순으로 보기' 섹션 — 필터 칩(개수) + 2열 포스터 그리드. **sliver** 다 —
/// `CustomScrollView.slivers` 안에 둔다(그리드가 보이는 칸만 만들도록).
/// K-POP 전용 — 금연 페이지는 단일 선택 칩의 `non_smoking_genre_grid` 를 따로 쓴다.
///
/// 칩은 **여러 개를 동시에** 고를 수 있고(디자인 `FilterChips`) 고른 조건을 전부
/// 만족하는 클럽만 남는다. 필터 상태는 이 섹션 밖에서 쓰지 않아 여기가 들고 있는다.
class VybeClubPosterGrid extends ConsumerStatefulWidget {
  final List<ClubModel> clubs;
  final bool loading;

  /// 칩 줄에 보일 필터 — 페이지가 이미 그 조건으로 걸러 온 항목(금연 페이지의
  /// '금연')은 빼고 넘긴다. 전부 통과하는 칩은 정보가 0이다.
  final List<VybeClubFilter> filters;

  /// 포스터 카드 LIVE 뱃지 색.
  final Color accent;

  const VybeClubPosterGrid({
    super.key,
    required this.clubs,
    required this.loading,
    required this.filters,
    required this.accent,
  });

  @override
  ConsumerState<VybeClubPosterGrid> createState() => _VybeClubPosterGridState();
}

class _VybeClubPosterGridState extends ConsumerState<VybeClubPosterGrid> {
  final Set<String> _picked = {};

  // 포스터 변환(haversine)·정렬은 목록·내 위치가 바뀔 때만 — 찜 토글은 emit 이
  // 3회라 매번 다시 돌리면 N곳을 세 번 계산한다.
  List<ClubModel>? _memoClubs;
  ({double lat, double lng})? _memoOrigin;
  List<_Entry> _sorted = const [];

  List<_Entry> _postersFor(({double lat, double lng}) origin) {
    if (!identical(widget.clubs, _memoClubs) || origin != _memoOrigin) {
      _memoClubs = widget.clubs;
      _memoOrigin = origin;
      _sorted = [
        for (final c in widget.clubs)
          (club: c, poster: vybeClubPosterFrom(c, origin: origin)),
      ]..sort((a, b) => a.poster.dist.compareTo(b.poster.dist));
    }
    return _sorted;
  }

  void _toggle(String label) => setState(() {
    _picked.contains(label) ? _picked.remove(label) : _picked.add(label);
  });

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
    final favoritedIds = ref.watch(mergedFavoriteIdsProvider);
    final me = ref.watch(userLocationProvider);
    final sorted = _postersFor((lat: me.lat, lng: me.lng));

    final active = widget.filters
        .where((f) => _picked.contains(f.label))
        .toList();
    final list = [
      for (final e in sorted)
        if (active.every((f) => f.test(e.club, favoritedIds))) e.poster,
    ];
    final byLabel = {for (final f in widget.filters) f.label: f};

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VybeSectionHead(
                title: '가까운 순으로 보기',
                sub: widget.loading
                    ? '내 위치에서 가까운 순'
                    : '${list.length}곳 · 내 위치에서 가까운 순',
              ),
              // 로딩 중 칩은 개수가 전부 0이라 거짓 정보다 — 자리만 잡는다.
              if (widget.loading)
                const VybeChipRowSkeleton()
              else
                VybeChipRow(
                  items: [for (final f in widget.filters) f.label],
                  active: '',
                  isSelected: _picked.contains,
                  onChange: _toggle,
                  // 개수는 **필터를 걸기 전 전체**에서 센다 — 고를 때마다 숫자가
                  // 같이 줄면 '이 조건이 몇 곳인지'를 알 수 없게 된다(디자인도 전체 기준).
                  trailing: (label, fg) => Text(
                    '${widget.clubs.where((c) => byLabel[label]!.test(c, favoritedIds)).length}',
                    style: VybeTypography.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 14 / 12,
                      color: fg.withValues(alpha: 0.6),
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
        if (widget.loading)
          const VybePosterSliverGridSkeleton()
        else if (list.isEmpty)
          SliverToBoxAdapter(
            child: VybeStateMessage(
              '조건에 맞는 클럽이 아직 없어요',
              padding: EdgeInsets.symmetric(vertical: 34.h, horizontal: 24.w),
            ),
          )
        else
          VybePosterSliverGrid(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final c = list[i];
              final saved = favoritedIds.contains(c.id);
              return VybeClubPosterCard(
                club: c,
                saved: saved,
                onSave: () => _toggleFavorite(c.id, saved),
                onTap: () => openClubDetail(context, c.id),
                accent: widget.accent,
                liveIcon: Icons.music_note_rounded,
              );
            },
          ),
      ],
    );
  }
}
