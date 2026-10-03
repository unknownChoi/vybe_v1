import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/core/utils/geohash_utils.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/data/models/v1/waiting_model.dart';
import 'package:vybe/presentation/clubs/renew/renew_home_tab.dart';
import 'package:vybe/presentation/clubs/renew/renew_info_tab.dart';
import 'package:vybe/presentation/clubs/renew/renew_menu_tab.dart';
import 'package:vybe/presentation/clubs/renew/renew_photo_tab.dart';
import 'package:vybe/presentation/clubs/renew/renew_review_tab.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_chrome.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_header.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_lazy_tab.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_skeleton.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_waiting.dart';
import 'package:vybe/presentation/clubs/viewmodels/club_detail_viewmodel.dart';
import 'package:vybe/presentation/clubs/viewmodels/club_ops_viewmodel.dart';
import 'package:vybe/presentation/clubs/viewmodels/favorite_viewmodel.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/v1/v1_placeholder_screen.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_toast.dart';
import 'package:vybe/presentation/nearby/widgets/nearby_glass.dart'
    show formatDistance;

/// 클럽 상세 — **리뉴얼**.
///
/// 디자인: club_detail_renew.html
/// (`club_renew.jsx` · `club_renew_shell.jsx` · `club_renew_sections.jsx` ·
///  `club_renew_tabs.jsx`).
///
/// 구성 — 히어로(356) → 히어로를 24 덮는 타이틀 블록 → sticky 탭 5개 →
/// 탭 패널. 상단바(뒤로/공유/찜)와 하단 액션바(찜·길찾기·전화)는 스크롤 위에 뜬다.
///
/// 스크롤 구조 —
/// 히어로가 상단바 **뒤까지** 올라와야 해서 스크롤 뷰는 상단바 아래에서 시작하고,
/// 히어로만 루트 [Stack]에 따로 그려 스크롤한 만큼 위로 옮긴다.
/// 탭 바는 [NestedScrollView.body] 최상단에 둬서 헤더가 사라지면 자연히 고정된다
/// (headerSliverBuilder에 pinned sliver를 넣으면 Flutter 3.41에서 화면이
///  통째로 안 그려진다 — CLAUDE.md 참고).
/// 진입 스켈레톤을 최소 이만큼은 유지한다.
///
/// 클럽 문서는 Firestore 캐시가 살아 있으면 한두 프레임 만에 도착한다. 그러면
/// 스켈레톤이 깜빡이고 사라져 화면이 한 번 번쩍인 것처럼 보인다. 최소 시간을
/// 두면 **스켈레톤 → 로딩 → 데이터** 순서가 항상 눈에 보이는 대로 지켜진다.
/// 사진의 [SkeletonImage.minSkeleton] 과 같은 처리.
const Duration kRenewBootSkeleton = Duration(milliseconds: 600);

/// 웨이팅 코치마크가 뜨기까지 (디자인 `setTimeout(… , 900)`).
const Duration kRenewCoachDelay = Duration(milliseconds: 900);

class ClubDetailRenewScreen extends ConsumerStatefulWidget {
  final String clubId;

  const ClubDetailRenewScreen({super.key, required this.clubId});

  // 화면 진입은 `openClubDetail`(club_detail_route.dart) 한 곳으로만 한다 —
  // 하단 액션 바가 MainScaffold의 floating nav와 겹쳐 nav를 내려야 하기 때문.

  @override
  ConsumerState<ClubDetailRenewScreen> createState() =>
      _ClubDetailRenewScreenState();
}

class _ClubDetailRenewScreenState extends ConsumerState<ClubDetailRenewScreen>
    with SingleTickerProviderStateMixin {
  static const List<String> _tabs = ['홈', '사진', '메뉴', '리뷰', '매장정보'];

  late final TabController _tabController;
  final ScrollController _outer = ScrollController();

  /// 헤더가 스크롤된 양. 히어로 위치와 상단바 상태만 쓰므로 [ValueNotifier]로
  /// 흘려보낸다 — setState로 돌리면 탭 콘텐츠까지 매 프레임 다시 그린다.
  final ValueNotifier<double> _scrollY = ValueNotifier(0);

  /// 히어로 캐러셀 인덱스 — 그림(RenewHero)과 조작 레이어(RenewHeroOverlay)가
  /// 스택의 서로 다른 층에 있어 상태를 밖에서 들고 있는다.
  final RenewHeroController _hero = RenewHeroController();

  int _activeIndex = 0;

  /// [kRenewBootSkeleton] 이 지났는지. 데이터가 먼저 와도 이게 false 면
  /// 스켈레톤을 유지한다.
  bool _minSkeletonDone = false;
  Timer? _bootTimer;

  /// 웨이팅 코치마크 (디자인 VWCoach) — 진입 0.9초 뒤에 뜨고, 탭하거나
  /// 웨이팅 시트를 열면 닫힌다. 내 티켓이 있으면 아예 안 뜬다.
  bool _coach = false;
  Timer? _coachTimer;

  /// 찜 수 표시의 기준값 — **화면에 들어온 시점의 서버 집계**와 그때의 찜 여부.
  ///
  /// `clubs.favoriteCount` 는 Cloud Functions 트리거가 올리는 값이라 찜을 눌러도
  /// 한 박자 늦게 온다. 기준을 한 번 잡아 두고 ±1 로 보여 줘야 숫자가 손가락을
  /// 따라온다(디자인 `saveCount={saved ? 129 : 128}` 과 같은 방식).
  int? _baseFavoriteCount;
  bool _baseSaved = false;

  @override
  void initState() {
    super.initState();
    _bootTimer = Timer(kRenewBootSkeleton, () {
      if (mounted) setState(() => _minSkeletonDone = true);
    });
    _coachTimer = Timer(kRenewCoachDelay, () {
      if (mounted) setState(() => _coach = true);
    });
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == _activeIndex) return;
      setState(() => _activeIndex = _tabController.index);
    });
    _outer.addListener(() {
      _scrollY.value = _outer.offset < 0 ? 0 : _outer.offset;
    });
  }

  @override
  void dispose() {
    _bootTimer?.cancel();
    _coachTimer?.cancel();
    _tabController.dispose();
    _outer.dispose();
    _scrollY.dispose();
    _hero.dispose();
    super.dispose();
  }

  void _goToTab(int index) => _tabController.animateTo(index);

  @override
  Widget build(BuildContext context) {
    final clubAsync = ref.watch(clubDetailProvider(widget.clubId));
    final club = clubAsync.value;
    // 진입 로딩 — 스피너 대신 스켈레톤. 히어로·타이틀·홈 탭이 같은 플래그를
    // 봐야 세 곳이 한꺼번에 실제 내용으로 바뀐다(따로 풀리면 화면이 두 번 튄다).
    // 최소 노출 시간을 같이 보므로 캐시가 있어도 스켈레톤이 깜빡이지 않는다.
    final booting = clubAsync.isLoading || !_minSkeletonDone;

    // 탭 전환 시 재로딩 방지 — 상세 진입 시 1회만 fetch.
    ref.watch(clubInfoProvider(widget.clubId));
    ref.watch(nearbyClubsProvider(widget.clubId));

    final saved = ref.watch(mergedFavoriteIdsProvider).contains(widget.clubId);
    // v1 신규 — 기능 플래그 · 운영 상태 · 내 티켓. 전부 Fake(UI 단계).
    final features = ref.watch(clubFeaturesProvider(widget.clubId)).value;
    final live = ref.watch(clubOpsLiveProvider(widget.clubId)).value;
    final ticket = ref.watch(myClubWaitingProvider(widget.clubId)).value;
    if (_baseFavoriteCount == null && club != null) {
      _baseFavoriteCount = club.favoriteCount;
      _baseSaved = saved;
    }
    final chromeH = MediaQuery.paddingOf(context).top + kRenewChromeRow.h;
    // 히어로 아래 24가 타이틀에 덮이고, 스크롤 뷰는 상단바 아래에서 시작한다.
    final heroSpacer = (kRenewHeroHeight - kRenewTitleOverlap).h - chromeH;

    final tabPadding = EdgeInsets.fromLTRB(
      RenewGlass.pagePad.w,
      24.h,
      RenewGlass.pagePad.w,
      RenewBottomBar.height(context) + 34.h,
    );

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: VybeAurora()),
          // 히어로 — 스크롤한 만큼 위로 밀린다.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollY,
              builder: (_, y, child) =>
                  Transform.translate(offset: Offset(0, -y), child: child),
              child: RenewHero(
                imageUrls: club?.heroImageUrls ?? const [],
                controller: _hero,
                loading: booting,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: chromeH),
            child: NestedScrollView(
              controller: _outer,
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder: (_, __) => [
                SliverToBoxAdapter(
                  child: SizedBox(height: heroSpacer < 0 ? 0 : heroSpacer),
                ),
                SliverToBoxAdapter(
                  child: booting
                      ? const RenewTitleSkeleton()
                      : club == null
                      ? SizedBox(height: 120.h)
                      : RenewTitleBlock(
                          club: club,
                          distanceLabel: _distanceLabel(club),
                        ),
                ),
                // 탭 바 위 여백 (디자인 marginTop 20)
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              ],
              body: Column(
                children: [
                  RenewTabBar(
                    tabs: _tabs,
                    activeIndex: _activeIndex,
                    onSelect: _goToTab,
                  ),
                  Expanded(child: _tabViews(tabPadding, booting)),
                ],
              ),
            ),
          ),
          // 히어로 조작 레이어 — 스크롤 뷰 **위**에 올려야 스와이프·도트 탭이
          // 산다(아래에 두면 스크롤 뷰가 히어로 영역 포인터를 전부 먹는다).
          // 히어로와 같은 만큼 밀어 위치를 맞춘다.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollY,
              builder: (_, y, child) =>
                  Transform.translate(offset: Offset(0, -y), child: child),
              child: RenewHeroOverlay(
                controller: _hero,
                total: club?.heroImageUrls.length ?? 0,
              ),
            ),
          ),
          // 상단바
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollY,
              builder: (_, y, __) => RenewChrome(
                scrollY: y,
                // 스켈레톤 도중에는 상단바 제목도 비운다 — 여기만 먼저 이름을
                // 내보내면 아래가 아직 스켈레톤인데 제목만 떠 있는 상태가 된다.
                clubName: booting ? '' : (club?.name ?? ''),
                onBack: () => Navigator.of(context).maybePop(),
                onShare: () => _share(club),
                saved: saved,
                onSave: () => _toggleSave(saved),
              ),
            ),
          ),
          // 하단 액션 바 — 버튼 노출은 features, 활성은 ops/live 가 정한다.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RenewBottomBar(
              saved: saved,
              saveCount: _displayFavoriteCount(club, saved),
              onSave: () => _toggleSave(saved),
              onWaiting: (features?.waiting ?? false)
                  ? () => _openWaitingSheet(club)
                  : null,
              waitingLabel: _waitingLabel(live, ticket),
              waitingActive: ticket != null,
              waitingDisabled: _waitingDisabled(live, ticket),
              onReserve: (features?.reservation ?? false)
                  ? () => V1PlaceholderScreen.push(
                      context,
                      screenId: 'RSV-047',
                      name: '예약 정보 입력',
                    )
                  : null,
            ),
          ),
          // 웨이팅 코치마크 — 하단 바 웨이팅 버튼을 가리킨다.
          // ⚠ **접수를 받는 곳에서만** 띄운다 — 등록이 안 되는 클럽에서
          // '등록이 가능한 곳이에요' 는 거짓 안내다.
          if (_coach &&
              (features?.waiting ?? false) &&
              ticket == null &&
              (live?.waiting.accept ?? false) &&
              !(live?.waiting.closed ?? true))
            RenewWaitingCoach(onClose: () => setState(() => _coach = false)),
        ],
      ),
    );
  }

  Widget _tabViews(EdgeInsets padding, bool booting) {
    return TabBarView(
      controller: _tabController,
      children: [
        RenewHomeTab(
          clubId: widget.clubId,
          padding: padding,
          showSkeleton: booting,
          onViewAllPhotos: () => _goToTab(1),
          onViewAllMenus: () => _goToTab(2),
          onOpenWaiting: () => _openWaitingSheet(ref.read(
            clubDetailProvider(widget.clubId),
          ).value),
        ),
        RenewLazyTab(
          selected: _activeIndex == 1,
          builder: () => RenewPhotoTab(clubId: widget.clubId, padding: padding),
        ),
        RenewLazyTab(
          selected: _activeIndex == 2,
          builder: () => RenewMenuTab(clubId: widget.clubId, padding: padding),
        ),
        RenewLazyTab(
          selected: _activeIndex == 3,
          builder: () =>
              RenewReviewTab(clubId: widget.clubId, padding: padding),
        ),
        RenewLazyTab(
          selected: _activeIndex == 4,
          builder: () => RenewInfoTab(clubId: widget.clubId, padding: padding),
        ),
      ],
    );
  }

  /// 하트 아래 숫자 — 진입 시점 집계에 내 찜만 ±1 한 값.
  int _displayFavoriteCount(ClubModel? club, bool saved) {
    final base = _baseFavoriteCount ?? club?.favoriteCount ?? 0;
    final delta = (saved ? 1 : 0) - (_baseSaved ? 1 : 0);
    final n = base + delta;
    return n < 0 ? 0 : n;
  }

  // ──────────────────────────────────────────────── 웨이팅 (CLUB-026)

  /// 하단 바 웨이팅 버튼 라벨.
  ///
  /// 기본은 디자인 그대로 '웨이팅 등록', 내 티켓이 있으면 '웨이팅 N번째'.
  ///
  /// ⚠ 접수를 안 받을 때만 문구가 더 바뀐다 — 버튼을 회색으로만 두고
  /// '웨이팅 등록' 이라고 써 놓으면 왜 안 눌리는지 알 수 없다.
  /// 대기 팀 수는 **여기 쓰지 않는다** — 바로 위 '실시간 웨이팅' 카드가 이미
  /// 말하고 있고, 버튼 폭(절반)에 넣으면 글자가 잘린다.
  String _waitingLabel(ClubOpsLive? live, WaitingModel? ticket) {
    if (ticket != null) return '웨이팅 ${ticket.seq}번째';
    if (live == null) return '웨이팅 등록';
    if (live.waiting.closed) return '웨이팅 마감';
    if (!live.waiting.accept) return '웨이팅 접수 중지';
    return '웨이팅 등록';
  }

  /// 접수를 안 받으면 누를 수 없다. 내 티켓이 있으면 언제나 열린다(내 순번 보기).
  bool _waitingDisabled(ClubOpsLive? live, WaitingModel? ticket) {
    if (ticket != null) return false;
    if (live == null) return true;
    return live.waiting.closed || !live.waiting.accept || !live.isOpen;
  }

  /// 등록 시트 (디자인 VWSheet). 코치마크는 여기서 닫는다.
  Future<void> _openWaitingSheet(ClubModel? club) async {
    if (club == null) return;
    setState(() => _coach = false);
    final live = ref.read(clubOpsLiveProvider(widget.clubId)).value;
    if (live == null) return;

    await RenewWaitingSheet.show(
      context,
      clubName: club.name,
      live: live,
      settings: ref.read(clubOpsSettingsProvider(widget.clubId)).value,
      ticket: ref.read(myClubWaitingProvider(widget.clubId)).value,
      onSubmit: (people) => _submitWaiting(people),
      onCancelWaiting: _cancelWaiting,
    );
  }

  /// 등록 — **입장비가 있으면 FEE 흐름, 없으면 WAIT 흐름**
  /// (설계 3장 CLUB-026 `registerWaiting` ↔ `createWaitingPaymentIntent`).
  ///
  /// ⚠ 입장비 유무를 화면이 정하지 않는다 — `ops/settings` 가 돌려준 값을 본다.
  void _submitWaiting(int people) {
    final settings = ref.read(clubOpsSettingsProvider(widget.clubId)).value;
    final fee = settings?.hasEntryFee ?? false;
    Navigator.of(context).maybePop();
    V1PlaceholderScreen.push(
      context,
      screenId: fee ? 'FEE-069' : 'WAIT-044',
      name: fee ? '입장비 결제' : '웨이팅 티켓',
    );
  }

  void _cancelWaiting() {
    Navigator.of(context).maybePop();
    VybeToast.show(context, message: '웨이팅을 취소했어요');
  }

  /// 공유 — 링크 체계가 아직 없어 매장 정보를 클립보드에 담는다.
  ///
  /// ⚠ 디자인 문구는 '링크가 복사되었습니다' 지만 앱에 공유 URL 이 없다
  /// (확정 정책: Firebase Dynamic Links 사용 금지). 없는 링크를 복사했다고
  /// 말할 수는 없어 **복사한 것을 그대로 말한다.** 링크 체계가 정해지면
  /// 디자인 문구로 되돌린다.
  Future<void> _share(ClubModel? club) async {
    if (club == null) return;
    final text = club.address.isEmpty
        ? club.name
        : '${club.name}\n${club.address}';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    VybeToast.show(context, message: '매장 정보를 복사했어요');
  }

  /// 내 위치 기준 거리. 좌표가 없는 클럽(0,0)은 표기를 생략한다.
  String? _distanceLabel(ClubModel club) {
    if (club.lat == 0 && club.lng == 0) return null;
    final me = ref.read(userLocationProvider);
    final km = GeohashUtils.haversineKm(me.lat, me.lng, club.lat, club.lng);
    return formatDistance(km * 1000);
  }

  void _toggleSave(bool saved) {
    final uid = ref.read(currentUidProvider);
    if (uid == null) {
      VybeToast.show(context, message: '로그인 후 저장할 수 있어요');
      return;
    }
    ref
        .read(favoriteViewModelProvider.notifier)
        .toggleFavorite(uid, widget.clubId, saved);
    VybeToast.show(context, message: saved ? '찜 목록에서 빼놨어요' : '찜 목록에 담았어요');
  }
}
