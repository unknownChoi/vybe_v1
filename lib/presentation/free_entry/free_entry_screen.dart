import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_map_section.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_image_hero.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/free_entry/free_entry_models.dart';
import 'package:vybe/presentation/free_entry/free_entry_style.dart';
import 'package:vybe/presentation/free_entry/viewmodels/free_entry_viewmodel.dart';
import 'package:vybe/presentation/free_entry/widgets/free_entry_cond_rail.dart';
import 'package:vybe/presentation/free_entry/widgets/free_entry_parts.dart';
import 'package:vybe/presentation/free_entry/widgets/free_entry_timed_rail.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';

/// 입장비 무료 페이지 — 이미지 히어로 + ① 지금 이 시간만 무료(시간대) + ② 내 주변 무료입장(지도)
/// + ③ 조건이 맞으면 무료(상시).
///
/// claude.ai/design `free_entry_renew.html` 디자인 기반. 데이터는 clubs(`isFreeEntry=true`)
/// 실연동 — 시간대(timed)는 ①, 상시(always)는 ③, 지도는 전체.
/// '지금 무료'인지는 `FreeEntryPolicy.statusAt` 으로 화면에서 판정한다(서버는 요일×시:분을
/// 못 가른다).
///
/// 디자인과 다른 점(사유):
/// - 텍스트 인트로('지금 들어가면 입장비 0원인 클럽' + n곳) 대신 **기존 이미지 히어로**
///   ([VybeImageHero] — 사진 + 하단 안내 띠)를 그대로 쓴다(요구사항).
/// - 상단 헤더는 다른 카테고리 페이지와 같은 투명 오버레이([VybeGlassHeader]) —
///   스크롤 시 불투명해지며 제목이 뜨는 동작은 뺐다. 우측은 디자인대로 검색.
/// - ② 지도 섹션은 K-POP·금연 페이지와 같은 공용 [VybeClubMapSection](지역 칩 + 핀 탭 →
///   미니 카드). 디자인의 지도 아래 가로 카드 레일은 그 미니 카드가 대신한다.
/// - ③ 조건은 `freeEntry.condition` 한 줄뿐이라 카드에 한 줄만 그린다.
/// - 디자인의 '걸어서 n분'은 도보 시간 데이터가 없어 거리(km)로 쓴다.
class FreeEntryScreen extends ConsumerStatefulWidget {
  const FreeEntryScreen({super.key});

  @override
  ConsumerState<FreeEntryScreen> createState() => _FreeEntryScreenState();
}

class _FreeEntryScreenState extends ConsumerState<FreeEntryScreen> {
  /// 1초마다 흐르는 현재 시각. 카운트다운만 구독한다(화면 전체를 매초 안 그린다).
  final _tick = ValueNotifier<DateTime>(DateTime.now());
  Timer? _timer;

  /// 이 시각을 넘기면 어떤 클럽의 상태(무료 중 ↔ 예정)가 바뀐다 → 목록을 다시 판정.
  DateTime? _boundary;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tick.dispose();
    super.dispose();
  }

  void _onTick() {
    final now = DateTime.now();
    _tick.value = now;
    final boundary = _boundary;
    if (boundary != null && !now.isBefore(boundary)) setState(() {});
  }

  void _openClub(FreeEntryClub c) => openClubDetail(context, c.id);

  // 홈 검색 버튼과 같은 규칙 — 화면을 push 하지 않고 검색 탭(3)으로 전환.
  void _openSearch() => ref.read(tabSwitchRequestProvider.notifier).request(3);

  /// 조회 실패 / 결과 없음 — 공용 [VybeStateMessage] 에 이 화면 여백만.
  Widget _message(String text) => VybeStateMessage(
    text,
    padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
  );

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(freeEntryViewModelProvider);
    final clubs = async.asData?.value ?? const <ClubModel>[];
    final loading = async.isLoading && async.asData == null;
    final me = ref.watch(userLocationProvider);

    // ⚠ 판정 시각은 화면당 한 번 — 카드마다 DateTime.now()를 읽으면 같은 목록 안에서
    // 정렬과 표기가 따로 논다.
    final now = DateTime.now();
    final cards = [
      for (final c in clubs)
        FreeEntryClub.fromClub(c, now, origin: (lat: me.lat, lng: me.lng)),
    ];
    final timed = cards.where((c) => c.timed).toList()..sort(compareFreeNow);
    final always = cards.where((c) => !c.timed).toList()
      ..sort((a, b) => a.dist.compareTo(b.dist));
    // 가장 먼저 열리거나 닫히는 창 — 그 순간 카드가 상태를 바꿔야 한다.
    _boundary = timed
        .map((c) => c.sortAt)
        .where((t) => t != null && t.isAfter(now))
        .fold<DateTime?>(null, (m, t) => m == null || t!.isBefore(m) ? t : m);

    // 플로팅 바텀 nav(MainScaffold) 가림 방지용 하단 여백.
    final bottomPad = MediaQuery.paddingOf(context).bottom + 90.h;

    return Scaffold(
      backgroundColor: kVybeInk,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // 배경 — 공용 리뉴얼 오로라(다른 카테고리 페이지와 동일).
            const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
            Positioned.fill(
              child: ListView(
                // 히어로가 상태바 뒤까지 채우므로 top 패딩을 두지 않는다.
                padding: EdgeInsets.only(bottom: bottomPad),
                // ⚠ 튕김(오버스크롤) 금지 — 히어로가 상태바 뒤까지 올라가 있어서
                // 위로 당기면 이미지 위에 배경이 드러난다.
                physics: const ClampingScrollPhysics(),
                children: [
                  const VybeImageHero('free_entry', heroAspect: 786 / 760),
                  SizedBox(height: 30.h),
                  if (loading)
                    const FreeEntrySkeleton()
                  else if (async.hasError)
                    _message('입장비 무료 클럽을 불러오지 못했어요')
                  else ...[
                    if (cards.isEmpty) _message('입장비 무료 클럽이 아직 없어요'),
                    if (timed.isNotEmpty) ...[
                      FreeEntryTimedRail(
                        clubs: timed,
                        tick: _tick,
                        onTap: _openClub,
                      ),
                      SizedBox(height: 44.h),
                    ],
                    if (cards.isNotEmpty) ...[
                      VybeClubMapSection(
                        clubs: clubs,
                        loading: false,
                        title: '내 주변 무료입장',
                        subject: '무료입장 클럽',
                        accent: kEntryBase,
                      ),
                      SizedBox(height: 44.h),
                    ],
                    if (always.isNotEmpty) ...[
                      FreeEntryCondRail(clubs: always, onTap: _openClub),
                      SizedBox(height: 34.h),
                    ],
                  ],
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: VybeGlassHeader(
                rightIcon: Icons.search_rounded,
                onShare: _openSearch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
