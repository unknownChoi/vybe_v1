import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/clubs/viewmodels/favorite_viewmodel.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_map_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_map_mini_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/nearby/viewmodels/nearby_search_provider.dart';

/// '주변 {subject} 찾기' 섹션 — 지역 칩 + 지도 + 고른 클럽 미니 카드.
///
/// K-POP 페이지 전용이던 것을 금연 페이지가 그대로 쓰게 되면서 승격했다 —
/// 화면마다 다른 건 문구의 대상([subject])과 포인트 색뿐이라 그 둘만 받고
/// **기본값은 원래(K-POP) 값을 유지**한다.
/// 지역 선택은 이 섹션 안에서만 쓰는 상태라 화면이 아니라 여기가 들고 있는다.
class VybeClubMapSection extends ConsumerStatefulWidget {
  /// 이 페이지의 클럽 전체(활성). 지역 칩은 이 목록에 실제로 있는 지역만 만든다.
  final List<ClubModel> clubs;
  final bool loading;

  /// 문구에 들어갈 대상 — '주변 {subject} 찾기' · 주변 탭 검색어 · 빈 지도 안내.
  /// 조사가 '이'로 붙으니 **'…클럽'으로 끝나는 말**을 넘길 것.
  final String subject;

  /// 포인트 색 — 전체 지도 아이콘 · 미니 카드 테두리.
  final Color accent;

  /// 섹션 제목. null이면 '주변 {subject} 찾기'.
  final String? title;

  const VybeClubMapSection({
    super.key,
    required this.clubs,
    required this.loading,
    this.subject = 'K-POP 클럽',
    this.accent = VybeColors.mainLime500,
    this.title,
  });

  @override
  ConsumerState<VybeClubMapSection> createState() => _VybeClubMapSectionState();
}

class _VybeClubMapSectionState extends ConsumerState<VybeClubMapSection> {
  /// 고른 지역. null이면 아직 안 정했다 — 첫 빌드에서 내 위치 지역으로 맞춘다.
  String? _area;

  ClubModel? _selected;

  /// 지도에 찍을 수 있는 클럽만 — 좌표(0,0)는 위치를 모르는 것이라 핀을 못 찍는다.
  List<ClubModel> get _mappable =>
      widget.clubs.where((c) => c.lat != 0 || c.lng != 0).toList();

  List<String> get _areas => vybeClubAreasOf(_mappable);

  /// 지도에 그릴 목록. 지역 칩이 하나도 못 만들어지면 전체를 그린다.
  List<ClubModel> get _list {
    final area = _area;
    if (area == null) return _mappable;
    return _mappable.where((c) => c.area == area).toList();
  }

  /// 내 위치 지역에 해당 클럽이 있으면 거기부터 보여준다(없으면 첫 지역).
  String? _initialArea(List<String> areas) {
    if (areas.isEmpty) return null;
    final mine = ref.read(userLocationProvider).area;
    return areas.contains(mine) ? mine : areas.first;
  }

  void _changeArea(String area) {
    if (area == _area) return;
    // 지역이 바뀌면 직전 선택은 그 지역 밖이라 같이 지운다.
    setState(() {
      _area = area;
      _selected = null;
    });
  }

  /// 지금 보고 있는 목록을 주변 탭 지도 핀으로 넘기고 탭을 전환한다.
  void _openFullMap(List<ClubModel> list) {
    if (list.isEmpty) return;
    final area = _area;
    ref
        .read(nearbySearchResultProvider.notifier)
        .showClubs(
          keyword: area == null ? widget.subject : '$area ${widget.subject}',
          clubs: list,
        );
    // 주변 탭(index 1)으로 전환 — MainScaffold가 listen해 점프.
    ref.read(tabSwitchRequestProvider.notifier).request(1);
  }

  @override
  Widget build(BuildContext context) {
    final areas = _areas;
    _area ??= _initialArea(areas);
    final list = _list;
    final me = ref.watch(userLocationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VybeSectionHead(
          title: widget.title ?? '주변 ${widget.subject} 찾기',
          sub: widget.loading
              ? '내 주변 ${widget.subject}'
              : '${_area ?? me.areaLabel} · ${list.length}곳',
          right: widget.loading || list.isEmpty
              ? null
              : VybeHeadAction(
                  label: '전체 지도',
                  icon: Icons.open_in_full_rounded,
                  iconColor: widget.accent,
                  onTap: () => _openFullMap(list),
                ),
        ),
        // 로딩 중엔 지역을 모르니 칩 자리만 잡아 둔다 — 안 그리면 데이터가 온 순간
        // 지도가 34px 내려앉는다.
        if (widget.loading) ...[
          const VybeChipRowSkeleton(),
          SizedBox(height: 14.h),
        ] else if (areas.isNotEmpty) ...[
          VybeChipRow(
            items: areas,
            active: _area ?? areas.first,
            onChange: _changeArea,
            icon: Icons.place_rounded,
          ),
          SizedBox(height: 14.h),
        ],
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: widget.loading
              ? VybeSkel(height: 300.h, radius: 16, logo: true)
              : list.isEmpty
              ? _EmptyMap(area: _area, subject: widget.subject)
              : _map(list, me),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 11.h, 16.w, 0),
          child: Row(
            children: [
              Container(
                width: 5.r,
                height: 5.r,
                decoration: const BoxDecoration(
                  color: VybeColors.mainPurple500,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  '핀을 누르면 클럽 정보를 볼 수 있어요',
                  style: VybeTypography.caption.copyWith(
                    fontSize: 11.5.sp,
                    height: 15 / 11.5,
                    color: VybeColors.gray500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 찜 토글 — favorites 실연동(다른 화면과 동일 패턴).
  void _toggleFavorite(String clubId, bool currentIsFav) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return; // 비로그인 — 추후 로그인 유도 처리
    ref
        .read(favoriteViewModelProvider.notifier)
        .toggleFavorite(uid, clubId, currentIsFav);
  }

  /// 지도 + (고른 게 있으면) 하단 미니 카드.
  Widget _map(List<ClubModel> list, UserLocation me) {
    final club = _selected;
    // 미니 카드 한 장의 하트만 필요하다 — Set 전체를 구독하면 다른 클럽 찜에도
    // 지도가 통째로 다시 그려진다.
    final saved =
        club != null &&
        ref.watch(
          mergedFavoriteIdsProvider.select((s) => s.contains(club.clubId)),
        );

    return Stack(
      children: [
        VybeClubMapCard(
          // 매 빌드마다 새 List 라 지도는 clubId 목록으로 변경을 가린다
          // (VybeClubMapCard._sigOf).
          clubs: list,
          raised: club != null,
          onSelected: (c) => setState(() => _selected = c),
        ),
        if (club != null)
          Positioned(
            left: 12.w,
            right: 12.w,
            bottom: 12.h,
            child: VybeClubMapMiniCard(
              club: club,
              accent: widget.accent,
              dist: vybeClubDistanceKm(
                club.lat,
                club.lng,
                origin: (lat: me.lat, lng: me.lng),
              ),
              saved: saved,
              onSave: () => _toggleFavorite(club.clubId, saved),
              onTap: () => openClubDetail(context, club.clubId),
            ),
          ),
      ],
    );
  }
}

/// 지도에 찍을 클럽이 없을 때 — 빈 지도를 띄우면 고장으로 보인다.
class _EmptyMap extends StatelessWidget {
  final String? area;
  final String subject;
  const _EmptyMap({required this.area, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: VybeColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: VybeColors.gray800),
      ),
      child: Text(
        area == null ? '지도에 표시할 $subject이 없어요' : '$area에는 $subject이 아직 없어요',
        textAlign: TextAlign.center,
        style: VybeTypography.body4.copyWith(color: VybeColors.gray500),
      ),
    );
  }
}
