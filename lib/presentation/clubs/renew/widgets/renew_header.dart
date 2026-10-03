import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/utils/date_format.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/free_entry_policy.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_waiting.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_meta_dot.dart';
import 'package:vybe/presentation/common/widgets/vybe_recommend_badge.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

/// 히어로 높이 (디자인 VRHero 356).
const double kRenewHeroHeight = 356;

/// 타이틀 블록이 히어로를 덮는 깊이 (디자인 marginTop -24).
const double kRenewTitleOverlap = 24;

// ============================================================================
// 히어로 (VRHero)
// ============================================================================

/// 히어로 캐러셀의 현재 인덱스. [RenewHero](그림)와
/// [RenewHeroOverlay](스와이프·도트)가 이 하나를 공유한다.
///
/// ⚠ 둘을 나눠 놓은 이유 — 히어로는 스크롤 뷰 **아래**에 깔려 있어 포인터가
/// 닿지 않는다(스크롤 뷰가 히어로 영역을 통째로 덮는다). 조작 부분만 스크롤 뷰
/// **위**로 올려야 스와이프·도트 탭이 산다.
class RenewHeroController extends ValueNotifier<int> {
  RenewHeroController() : super(0);

  int _total = 0;

  /// 이미지 개수. 빌드 중에 들어와도 안전하게 알림 없이 값만 바꾼다
  /// (범위를 벗어난 인덱스는 읽는 쪽에서 `% total`로 접는다).
  set total(int value) => _total = value;

  void go(int i) {
    if (_total < 2) return;
    value = (i + _total) % _total;
  }

  void next() => go(value + 1);
}

/// 상단 이미지 캐러셀. 4.2초마다 자동으로 크로스페이드하고,
/// 아래쪽은 마스크로 서서히 사라져 오로라 배경과 이어진다.
///
/// 스크롤과 함께 위로 밀려야 해서 스크롤 뷰 **바깥**(루트 Stack)에 놓고
/// 화면이 스크롤한 만큼 위로 옮긴다 — 스크롤 뷰는 상단바 아래에서 시작하는데
/// 히어로는 상단바 뒤까지 올라와야 하기 때문.
///
/// 조작(스와이프·도트)은 여기가 아니라 [RenewHeroOverlay]에 있다.
class RenewHero extends StatefulWidget {
  final List<String> imageUrls;

  final RenewHeroController controller;

  /// 클럽 로딩 중 — 이미지 자리에 스켈레톤.
  final bool loading;

  const RenewHero({
    super.key,
    required this.imageUrls,
    required this.controller,
    this.loading = false,
  });

  @override
  State<RenewHero> createState() => _RenewHeroState();
}

class _RenewHeroState extends State<RenewHero> {
  Timer? _timer;

  /// 현재 장과 직전 장 — 직전 장은 크로스페이드가 끝날 때까지 트리에 남겨 둔다.
  /// (ValueNotifier 리스너는 바뀐 뒤 값만 주므로 직전 값을 여기서 기억한다)
  int _index = 0;
  int _prev = 0;

  static const _autoPlay = Duration(milliseconds: 4200);
  static const _fade = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onIndexChanged);
    _schedule();
  }

  @override
  void didUpdateWidget(RenewHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onIndexChanged);
      widget.controller.addListener(_onIndexChanged);
    }
    // 클럽이 늦게 도착해 이미지가 이제야 2장 이상이 되면 그때 자동재생 시작.
    if (oldWidget.imageUrls.length != widget.imageUrls.length) _schedule();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller.removeListener(_onIndexChanged);
    super.dispose();
  }

  /// 다음 장으로 넘길 타이머를 다시 건다. 사용자가 직접 넘긴 직후에도
  /// 호출돼 — 손으로 넘기자마자 자동재생이 또 넘기는 일이 없다.
  void _schedule() {
    _timer?.cancel();
    if (widget.imageUrls.length < 2) return;
    _timer = Timer(_autoPlay, () {
      if (mounted) widget.controller.next();
    });
  }

  void _onIndexChanged() {
    if (!mounted) return;
    setState(() {
      _prev = _index;
      _index = _shownIndex;
    });
    _schedule();
  }

  int get _shownIndex {
    final total = widget.imageUrls.length;
    return total == 0 ? 0 : widget.controller.value % total;
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;
    final total = images.length;
    widget.controller.total = total;
    final index = _shownIndex;
    // 트리에 두는 장은 넷뿐 — 직전 장(페이드 아웃) · 현재 장 · 앞뒤 한 칸(미리 받기).
    // 전부 올리면 상세 진입 즉시 N장이 동시에 요청·디코드된다. 키를 줘야 장이
    // 바뀌어도 AnimatedOpacity 가 이어져 크로스페이드가 산다. 뒤로 한 칸도 미리
    // 두는 이유 — 트리에 없는 장으로 가면 첫 삽입이 opacity 1 이라 컷으로 바뀐다
    // (도트 탭으로 먼 장에 갈 땐 컷을 감수한다).
    final shown = total == 0
        ? const <int>[]
        : ({
            _prev % total,
            (index - 1 + total) % total,
            index,
            (index + 1) % total,
          }.toList()..sort());

    // RepaintBoundary — 페이드·shimmer 가 히어로 밖(상단바·하단바·탭)까지
    // 매 프레임 다시 그리지 않게 경계를 친다. 스크롤 이동은 레이어 오프셋만 바뀐다.
    return RepaintBoundary(
      child: SizedBox(
        height: kRenewHeroHeight.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 마스크 안쪽 — 이미지 + 하이라이트 + 스크림
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.black,
                  Color(0x8C000000),
                  Color(0x00000000),
                ],
                stops: [0.0, 0.58, 0.82, 1.0],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.loading)
                    const VybeSkel(radius: 0)
                  else
                    for (final i in shown)
                      AnimatedOpacity(
                        key: ValueKey(i),
                        opacity: i == index ? 1 : 0,
                        duration: _fade,
                        curve: Curves.easeInOut,
                        child: SkeletonImage(url: images[i], fit: BoxFit.cover),
                      ),
                  // radial(70% 60% at 26% 20%, rgba(255,255,255,0.22), transparent 62%)
                  const IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(-0.48, -0.6),
                          radius: 0.9,
                          colors: [Color(0x38FFFFFF), Color(0x00FFFFFF)],
                          stops: [0.0, 0.62],
                        ),
                      ),
                    ),
                  ),
                  // linear(180deg, rgba(8,7,12,.62), transparent 32%,
                  //        rgba(14,13,18,.42) 76%, rgba(14,13,18,.72) 100%)
                  const IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x9E08070C),
                            Color(0x00000000),
                            Color(0x6B0E0D12),
                            Color(0xB80E0D12),
                          ],
                          stops: [0.0, 0.32, 0.76, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 히어로의 **조작·표시** 레이어 — 좌우 스와이프, 도트 인디케이터, 장수 카운터.
///
/// ⚠ 히어로와 같은 위젯에 두면 안 된다 — 히어로는 루트 Stack에서 스크롤 뷰
/// **아래**에 깔려 있어 포인터가 전부 스크롤 뷰에 먹힌다. 이 레이어를 스크롤 뷰
/// **위** 형제로 올리고 히어로와 같은 만큼 스크롤시켜 위치를 맞춘다.
///
/// 스와이프 판정은 `translucent` — 세로 드래그는 제스처 아레나에서 아래 스크롤
/// 뷰가 가져가므로 히어로 위에서도 화면 스크롤이 그대로 된다.
class RenewHeroOverlay extends StatelessWidget {
  final RenewHeroController controller;

  /// 이미지 개수. 2장 미만이면 아무것도 그리지 않는다.
  final int total;

  const RenewHeroOverlay({
    super.key,
    required this.controller,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (total < 2) return const SizedBox.shrink();
    controller.total = total;

    return SizedBox(
      height: kRenewHeroHeight.h,
      width: double.infinity,
      child: ValueListenableBuilder<int>(
        valueListenable: controller,
        builder: (_, raw, __) {
          final index = raw % total;
          return Stack(
            fit: StackFit.expand,
            children: [
              // 좌우로 밀어 사진 넘기기 (디자인엔 없지만 캐러셀 기본 동작).
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragEnd: (d) {
                    final v = d.primaryVelocity ?? 0;
                    if (v == 0) return;
                    controller.go(v < 0 ? index + 1 : index - 1);
                  },
                ),
              ),
              // 카운터
              Positioned(
                right: RenewGlass.pagePad.w,
                bottom: 58.h,
                child: IgnorePointer(child: _counter(index)),
              ),
              // 도트 인디케이터
              Positioned(
                left: RenewGlass.pagePad.w,
                bottom: 60.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(total, (i) {
                    final on = i == index;
                    return GestureDetector(
                      onTap: () => controller.go(i),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        margin: EdgeInsets.only(
                          right: i == total - 1 ? 0 : 5.w,
                        ),
                        width: on ? 18.w : 5.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: on ? Colors.white : const Color(0x61FFFFFF),
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _counter(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: RenewGlass.barFill,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: const Color(0x24FFFFFF)),
      ),
      child: Text(
        '${index + 1} / $total',
        style: RenewGlass.caption(
          color: Colors.white,
          lineHeight: 15,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================================
// 타이틀 블록 (VRTitle)
// ============================================================================

/// 히어로 아래 카드 없이 배경 위에 바로 얹히는 클럽 아이덴티티 블록.
class RenewTitleBlock extends StatelessWidget {
  final ClubModel club;

  /// `0.4km` — 내 위치 기준 거리. 좌표가 없으면 null.
  final String? distanceLabel;

  const RenewTitleBlock({super.key, required this.club, this.distanceLabel});

  @override
  Widget build(BuildContext context) {
    final today = club.operatingHours.today;
    final isOpen = today.isCurrentlyOpen;
    final statusLabel = isOpen && today.close != null
        ? '영업중 · ${today.close} 종료'
        : null;
    // 뱃지 줄 첫 칸 — 무료입장 정책이 있는 클럽만 (디자인 VRFreePill).
    final freePill = RenewFreePill.maybeBuild(club);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        RenewGlass.pagePad.w,
        0,
        RenewGlass.pagePad.w,
        2.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 뱃지 줄 — 디자인 순서는 무료입장 pill · VYBE 추천 · 영업 상태.
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (freePill != null) freePill,
              if (club.isVybeRecommended) const VybeRecommendBadge(),
              RenewStatusPill(isOpen: isOpen, label: statusLabel),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            club.name,
            style: VybeTypography.heading2.copyWith(color: RenewGlass.t1),
          ),
          SizedBox(height: 12.h),
          RenewMetaRow(
            items: [
              club.area,
              club.genre,
              if (distanceLabel != null) distanceLabel!,
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/common/club_card/star.svg',
                width: 15.r,
                height: 15.r,
              ),
              SizedBox(width: 7.w),
              Text(
                club.rating.toStringAsFixed(2),
                style: VybeTypography.body3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: RenewGlass.t1,
                ),
              ),
              SizedBox(width: 7.w),
              const VybeMetaDot(gap: 0),
              SizedBox(width: 7.w),
              Text(
                '리뷰 ${club.reviewCount}',
                style: RenewGlass.body(color: RenewGlass.t3),
              ),
            ],
          ),
          if (club.description.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(club.description, style: RenewGlass.body(lineHeight: 20)),
          ],
          if (club.tags.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                for (final tag in club.tags)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 11.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: RenewGlass.tileFill,
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(color: RenewGlass.tileBorder),
                    ),
                    child: Text(
                      '#$tag',
                      style: RenewGlass.caption(
                        color: RenewGlass.lavender,
                        lineHeight: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 타이틀 블록 뱃지 줄 **첫 칸** — 무료입장 pill (디자인 `VRFreePill`).
///
/// 무료 중이면 라임 채움 + 펄스 점 '지금 무료입장', 아니면 라임 아웃라인으로
/// `{시각} 무료입장`(오늘 창 안이지만 아직 아닐 때) / `{시각}부터 무료`.
///
/// ⚠ 판정은 `FreeEntryPolicy.statusAt` 하나다 — 홈 카드 · 입장비 무료 페이지와
/// 같은 함수를 쓴다(두 화면이 같은 클럽을 다르게 말하면 안 된다).
class RenewFreePill extends StatelessWidget {
  final String label;
  final bool now;

  const RenewFreePill({super.key, required this.label, required this.now});

  /// 무료입장 정책이 없는 클럽은 null — 호출부가 뱃지 줄에서 뺀다.
  static RenewFreePill? maybeBuild(ClubModel club, {DateTime? at}) {
    final policy = club.freeEntry;
    if (policy.type == FreeEntryType.none) return null;

    final now = at ?? DateTime.now();
    final status = policy.statusAt(now);
    // 문 닫은 클럽의 '지금 무료'는 거짓 정보 — 영업 중일 때만 라임 채움.
    final open = club.operatingHours.dayAt(now).isOpenAt(now);
    if (status.isFreeNow && open) {
      return const RenewFreePill(label: '지금 무료입장', now: true);
    }
    // 상시 무료는 시각이 없다 — 창 없이 '무료입장'만.
    if (policy.type == FreeEntryType.always) {
      return const RenewFreePill(label: '무료입장', now: false);
    }
    final starts = status.nextStartsAt;
    if (starts == null) return null;
    return RenewFreePill(
      label: '${fmtHhmm(starts)}부터 무료',
      now: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fg = now ? RenewGlass.ink : VybeColors.mainLime500;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: now ? VybeColors.mainLime500 : V1Colors.limeTint14,
        borderRadius: BorderRadius.circular(999.r),
        border: now ? null : Border.all(color: V1Colors.limeTint30Border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (now) ...[
            RenewLivePulseDot(size: 5, color: fg),
            SizedBox(width: 5.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12.sp,
              height: 1,
              fontWeight: now ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: 12 * -0.025,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
