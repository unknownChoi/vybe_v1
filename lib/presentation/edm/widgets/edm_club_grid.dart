import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_poster_sliver_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/edm/edm_models.dart';
import 'package:vybe/presentation/edm/widgets/edm_chrome.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/nearby/viewmodels/nearby_search_provider.dart';

/// '주변 EDM 클럽 추천' 섹션 — 지역 필터 + 2열 포스터 그리드. **sliver** —
/// `CustomScrollView.slivers` 안에 둔다(보이는 카드만 만든다).
///
/// 지역 필터는 이 섹션 안에서만 쓰는 상태라 화면이 아니라 여기가 들고 있는다.
class EdmClubGrid extends ConsumerStatefulWidget {
  final List<VybeClubPoster> clubs;

  /// 지도 핀 표시에 필요한 원본 모델. 포스터 id → ClubModel.
  final Map<String, ClubModel> clubById;

  final bool loading;

  /// 하트를 누른 클럽 id — 카드 하나씩만 구독한다(그리드는 안 흔들린다).
  final ValueListenable<Set<Object>> saved;
  final ValueChanged<Object> onSave;

  const EdmClubGrid({
    super.key,
    required this.clubs,
    required this.clubById,
    required this.loading,
    required this.saved,
    required this.onSave,
  });

  @override
  ConsumerState<EdmClubGrid> createState() => _EdmClubGridState();
}

class _EdmClubGridState extends ConsumerState<EdmClubGrid> {
  String _area = kEdmAreas.first;

  /// 추천순 = VYBE 추천 먼저 → 평점 높은 순 → 가까운 순.
  List<VybeClubPoster> get _list {
    final base = _area == kEdmAreas.first
        ? widget.clubs.toList()
        : widget.clubs.where((c) => c.area == _area).toList();
    base.sort((a, b) {
      if (a.vybe != b.vybe) return a.vybe ? -1 : 1;
      final r = b.rating.compareTo(a.rating);
      return r != 0 ? r : a.dist.compareTo(b.dist);
    });
    return base;
  }

  /// 목록 그대로를 주변 탭 지도 핀으로 넘기고 탭을 전환한다.
  void _showOnMap(List<VybeClubPoster> list) {
    final clubs = list
        .map((c) => widget.clubById[c.id])
        .whereType<ClubModel>()
        .toList();
    if (clubs.isEmpty) return;
    final keyword = _area == kEdmAreas.first ? 'EDM 클럽' : '$_area EDM 클럽';
    ref
        .read(nearbySearchResultProvider.notifier)
        .showClubs(keyword: keyword, clubs: clubs);
    // 주변 탭(index 1)으로 전환 — MainScaffold가 listen해 점프.
    ref.read(tabSwitchRequestProvider.notifier).request(1);
  }

  @override
  Widget build(BuildContext context) {
    final list = _list;

    return SliverMainAxisGroup(
      slivers: [
        SliverList.list(
          children: [
            VybeSectionHead(
              title: '주변 EDM 클럽 추천',
              sub: widget.loading
                  ? '내 주변 EDM 클럽'
                  : '${_area == kEdmAreas.first ? '내 주변' : _area} · ${list.length}곳',
              right: widget.loading || list.isEmpty
                  ? null
                  : VybeHeadAction(
                      label: '지도',
                      icon: Icons.place_rounded,
                      iconColor: kEdmAccentText,
                      onTap: () => _showOnMap(list),
                    ),
            ),
            VybeChipRow(
              items: kEdmAreas,
              active: _area,
              onChange: (a) => setState(() => _area = a),
              icon: Icons.place_rounded,
              iconExcept: kEdmAreas.first,
            ),
            SizedBox(height: 18.h),
          ],
        ),
        if (widget.loading)
          const VybePosterSliverGridSkeleton()
        else if (list.isEmpty)
          SliverToBoxAdapter(
            child: VybeStateMessage(
              '$_area에는 EDM 클럽이 아직 없어요',
              padding: EdgeInsets.symmetric(vertical: 34.h, horizontal: 24.w),
            ),
          )
        else
          VybePosterSliverGrid(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final c = list[i];
              return ValueListenableBuilder<Set<Object>>(
                valueListenable: widget.saved,
                builder: (_, saved, __) => VybeClubPosterCard(
                  club: c,
                  saved: saved.contains(c.id),
                  onSave: () => widget.onSave(c.id),
                  onTap: () => openClubDetail(context, c.id),
                  accent: kEdmAccentText,
                  liveIcon: Icons.bolt_rounded,
                ),
              );
            },
          ),
      ],
    );
  }
}
