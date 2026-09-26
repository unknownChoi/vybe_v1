import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/storage/local_prefs.dart';
import 'package:vybe/data/models/popup_ad_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/home/viewmodels/popup_ad_viewmodel.dart';
import 'package:vybe/presentation/my_page/notice_detail_route.dart';

/// 홈 진입 팝업 광고 (디자인 `home_popup_ad.jsx`).
///
/// 운영자가 등록한 **정사각 사진 1장**이 내용의 전부다. 사진을 탭하면 연결해 둔
/// 공지 상세로 가고(`linkType: 'notice'`), 연결이 없으면 아무 일도 없다.
///
/// 띄우는 조건은 전부 [popupAdProvider] 가 판정하고(활성·기간·1순위·로컬 숨김),
/// 이 위젯은 **언제 보여줄지**만 맡는다 — 홈이 실제로 뜬 뒤([ready]) 240ms.
///
/// 앱 실행당 1회다. 닫으면 이번 실행에서는 다시 뜨지 않는다(저장 없음).
class HomePopupAd extends ConsumerStatefulWidget {
  /// 홈이 그려진 뒤에만 true — 스켈레톤 위에 광고를 띄우지 않는다.
  final bool ready;

  const HomePopupAd({super.key, required this.ready});

  @override
  ConsumerState<HomePopupAd> createState() => _HomePopupAdState();
}

class _HomePopupAdState extends ConsumerState<HomePopupAd> {
  /// 이번 실행에서 이미 닫았는지. 탭을 옮겨 다녀도 다시 뜨지 않는다.
  bool _closed = false;

  void _close() {
    if (!mounted) return;
    setState(() => _closed = true);
  }

  /// '1주일동안 안보기' — 기기에 만료 시각을 남기고 닫는다.
  Future<void> _hideForAWeek(PopupAdModel ad) async {
    try {
      final prefs = await ref.read(localPrefsProvider.future);
      await prefs.setPopupAdHideUntil(
        ad.popupId,
        DateTime.now().add(kPopupAdHideDuration),
      );
    } catch (_) {
      // 저장 실패해도 이번 실행에서는 닫는다 — 다시 띄우면 더 성가시다.
    }
    _close();
  }

  void _openLink(PopupAdModel ad) {
    if (!ad.isTappable) return;
    _close();
    openNoticeDetail(context, ad.linkValue);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.ready || _closed) return const SizedBox.shrink();

    // 로딩·오류·없음 모두 '안 띄움' — 광고는 안 뜨는 게 최악이 아니다.
    final ad = ref.watch(popupAdProvider).asData?.value;
    if (ad == null) return const SizedBox.shrink();

    return _PopupAdOverlay(
      ad: ad,
      onClose: _close,
      onHideForAWeek: () => _hideForAWeek(ad),
      onImageTap: () => _openLink(ad),
    );
  }
}

/// 배리어 + 글래스 카드. 등장 애니메이션(배리어 .22s · 카드 .3s)을 소유한다.
class _PopupAdOverlay extends StatefulWidget {
  final PopupAdModel ad;
  final VoidCallback onClose;
  final VoidCallback onHideForAWeek;
  final VoidCallback onImageTap;

  const _PopupAdOverlay({
    required this.ad,
    required this.onClose,
    required this.onHideForAWeek,
    required this.onImageTap,
  });

  @override
  State<_PopupAdOverlay> createState() => _PopupAdOverlayState();
}

/// 홈이 뜨고 나서 팝업이 올라오기까지 (디자인 240ms).
const _kShowDelay = Duration(milliseconds: 240);

/// 체크가 라임으로 차오르는 것을 보여준 뒤 닫히기까지 (디자인 220ms).
const _kCheckedCloseDelay = Duration(milliseconds: 220);

class _PopupAdOverlayState extends State<_PopupAdOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _curved;
  Timer? _showTimer;
  Timer? _closeTimer;

  /// 체크 표시 상태 — 누른 뒤 닫히기 전까지 라임으로 채워 보여준다.
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _curved = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _showTimer = Timer(_kShowDelay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    _closeTimer?.cancel();
    _c.dispose();
    super.dispose();
  }

  void _onCheck() {
    if (_checked) return;
    setState(() => _checked = true);
    _closeTimer = Timer(_kCheckedCloseDelay, widget.onHideForAWeek);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curved,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 배리어 — 탭하면 닫힘.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onClose,
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const ColoredBox(color: RenewGlass.barFill),
              ),
            ),
          ),
          // 카드 뒤 브랜드 광채.
          IgnorePointer(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 27, sigmaY: 27),
              child: Container(
                width: 260.w,
                height: 260.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      VybeColors.mainPurple500.withValues(alpha: 0.35),
                      VybeColors.mainPurple500.withValues(alpha: 0),
                    ],
                    stops: const [0, 0.7],
                  ),
                ),
              ),
            ),
          ),
          ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(_curved),
            child: _AdCard(
              ad: widget.ad,
              checked: _checked,
              onCheck: _onCheck,
              onClose: widget.onClose,
              onImageTap: widget.onImageTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// 유리 패널 + 정사각 사진 + 하단 바.
class _AdCard extends StatelessWidget {
  final PopupAdModel ad;
  final bool checked;
  final VoidCallback onCheck;
  final VoidCallback onClose;
  final VoidCallback onImageTap;

  const _AdCard({
    required this.ad,
    required this.checked,
    required this.onCheck,
    required this.onClose,
    required this.onImageTap,
  });

  /// 카드 채움 — rgba(23,21,31,0.68) (디자인 AG.sheet).
  static const _sheet = Color(0xAD17151F);

  /// 유리 테두리 — rgba(255,255,255,0.10) (디자인 AG.edge = 글래스 카드 테두리).
  static const _edge = RenewGlass.cardBorder;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(26.r);
    return Container(
      width: 317.w,
      // ⚠ 테두리는 decoration이 아니라 foregroundDecoration에 둔다 —
      //   클립되는 카드에서 decoration.border는 코너 호에서 선이 사라진다.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: const Color(0x8C000000),
            blurRadius: 70.r,
            offset: Offset(0, 30.h),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: _edge),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 17, sigmaY: 17),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: _sheet,
            // 상단 스페큘러 — radial-gradient(110% 80% at 12% 0%).
            gradient: RadialGradient(
              center: Alignment(-0.76, -1),
              radius: 1.1,
              colors: [Color(0x1AFFFFFF), Color(0x00FFFFFF)],
              stops: [0, 0.58],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(7.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AdImage(ad: ad, onTap: onImageTap),
                SizedBox(height: 3.h),
                _AdBar(checked: checked, onCheck: onCheck, onClose: onClose),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 광고 사진 — 정사각. 탭하면 연결된 공지로 간다.
class _AdImage extends StatelessWidget {
  final PopupAdModel ad;
  final VoidCallback onTap;

  const _AdImage({required this.ad, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(19.r);
    return Semantics(
      image: true,
      button: ad.isTappable,
      label: ad.altText.isEmpty ? '광고 이미지' : ad.altText,
      child: GestureDetector(
        onTap: ad.isTappable ? onTap : null,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: RenewGlass.quietFill,
            boxShadow: [
              BoxShadow(
                color: const Color(0x66000000),
                blurRadius: 22.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: _AdCard._edge),
            // 유리 굴절 느낌의 코너 글린트.
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x2EFFFFFF), Color(0x00FFFFFF)],
              stops: [0, 0.34],
            ),
          ),
          // 로딩은 로고 shimmer, 실패는 어두운 판 — 디스크 캐시 + 표시 크기 디코드.
          child: AspectRatio(
            aspectRatio: 1,
            child: SkeletonImage(url: ad.imageUrl, minSkeleton: Duration.zero),
          ),
        ),
      ),
    );
  }
}

/// 하단 유리 바 — AD 표시 · 1주일동안 안보기 · 닫기.
class _AdBar extends StatelessWidget {
  final bool checked;
  final VoidCallback onCheck;
  final VoidCallback onClose;

  const _AdBar({
    required this.checked,
    required this.onCheck,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h,
      child: Stack(
        children: [
          // 구분선 — 좌우 12씩 들여서 유리 모서리에 닿지 않게.
          Positioned(
            left: 12.w,
            right: 12.w,
            top: 0,
            child: Container(height: 1, color: RenewGlass.hair),
          ),
          Row(
            children: [
              const _AdLabel(),
              Expanded(
                child: _AdBarButton(
                  onTap: onCheck,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _AdCheck(on: checked),
                      SizedBox(width: 8.w),
                      Text(
                        '1주일동안 안보기',
                        style: VybeTypography.button2.copyWith(
                          fontWeight: FontWeight.w500,
                          color: RenewGlass.t3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 18.h, color: RenewGlass.hair),
              _AdBarButton(
                width: 80.w,
                onTap: onClose,
                child: Text(
                  '닫기',
                  style: VybeTypography.button2.copyWith(color: RenewGlass.t1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 광고 표시 — 이미지 밖 왼쪽 끝. 사진을 가리지 않는다.
class _AdLabel extends StatelessWidget {
  const _AdLabel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 13.w, right: 10.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VybeColors.mainLime500,
              boxShadow: [
                BoxShadow(color: VybeColors.mainLime500, blurRadius: 8.r),
              ],
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            'AD',
            style: VybeTypography.caption.copyWith(
              fontSize: 11.sp,
              height: 12 / 11,
              fontWeight: FontWeight.w600,
              color: const Color(0x85FFFFFF),
            ),
          ),
        ],
      ),
    );
  }
}

/// 체크박스 — 탭하면 라임으로 차고 곧 닫힌다.
class _AdCheck extends StatelessWidget {
  final bool on;

  const _AdCheck({required this.on});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: 17.r,
      height: 17.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: on ? VybeColors.mainLime500 : const Color(0x0DFFFFFF),
        border: on
            ? null
            : Border.all(color: const Color(0x57FFFFFF), width: 1.5),
        boxShadow: on
            ? [
                BoxShadow(
                  color: VybeColors.mainLime500.withValues(alpha: 0.4),
                  blurRadius: 12.r,
                ),
              ]
            : null,
      ),
      child: on
          ? Icon(Icons.check_rounded, size: 12.r, color: VybeColors.background)
          : null,
    );
  }
}

/// 하단 바 버튼 — 유리 위 프레스 틴트.
class _AdBarButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double? width;

  const _AdBarButton({required this.child, required this.onTap, this.width});

  @override
  State<_AdBarButton> createState() => _AdBarButtonState();
}

class _AdBarButtonState extends State<_AdBarButton> {
  bool _down = false;

  void _setDown(bool v) {
    if (_down == v) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _setDown(true),
      onTapUp: (_) => _setDown(false),
      onTapCancel: () => _setDown(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: 54.h,
        alignment: Alignment.center,
        color: _down ? const Color(0x1AFFFFFF) : Colors.transparent,
        child: widget.child,
      ),
    );
  }
}
