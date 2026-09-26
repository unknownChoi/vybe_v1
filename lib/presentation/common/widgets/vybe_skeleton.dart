import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/design_system/colors.dart';

// ── Base shimmer block ──────────────────────────────────────────

/// 모든 [VybeSkel] 이 같이 듣는 shimmer 시계 **하나**.
///
/// 막대마다 `AnimationController` 를 두면 스켈레톤 화면(검색 결과 40~60개 ·
/// 상세 진입 수십 개)에서 티커가 그 수만큼 돌며 각각 프레임을 요청한다.
/// 첫 리스너가 붙을 때 돌기 시작하고 마지막이 떨어지면 멈춘다 — 스켈레톤이
/// 하나도 안 보이면 앱이 idle 로 들어간다.
class _ShimmerClock extends ChangeNotifier {
  _ShimmerClock._();
  static final instance = _ShimmerClock._();

  static const _period = Duration(milliseconds: 1400);
  Ticker? _ticker;

  /// 띠 위치 -1.5 ~ 1.5 (easeInOut). 로고 밝기도 이 값을 같이 쓴다.
  double value = -1.5;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _ticker ??= Ticker(_tick)..start();
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (hasListeners) return;
    _ticker?.dispose();
    _ticker = null;
  }

  void _tick(Duration elapsed) {
    final t =
        (elapsed.inMicroseconds % _period.inMicroseconds) /
        _period.inMicroseconds;
    value = Curves.easeInOut.transform(t) * 3 - 1.5;
    notifyListeners();
  }
}

/// 회색 shimmer 블록.
///
/// **수치는 스케일 전 값으로 넘긴다** — `radius` 는 이 위젯이 `.r` 을 붙인다
/// (`radius: 8`, `999`). `width`·`height` 는 호출부가 `.w`·`.h` 를 붙여 넘긴다.
class VybeSkel extends StatelessWidget {
  final double? width;
  final double? height;

  /// 스케일 전 값. 내부에서 `.r` 을 붙이므로 `8.r` 처럼 넘기면 이중 스케일된다.
  final double radius;

  /// 사진 자리용 — 회색 도형 가운데 VYBE 로고를 흐리게 얹는다.
  /// 텍스트 줄 스켈레톤엔 쓰지 않는다(칸이 좁아 로고가 뭉갠다).
  final bool logo;

  /// 부모 폭 대비 비율(0~1). [width] 와 같이 쓰지 않는다.
  final double? widthFactor;

  const VybeSkel({
    super.key,
    this.width,
    this.height,
    this.radius = 6,
    this.logo = false,
    this.widthFactor,
  });

  @override
  Widget build(BuildContext context) {
    final clock = _ShimmerClock.instance;
    // 로고는 한 번만 만든다 — 매 프레임 SvgPicture 를 다시 빌드하지 않는다.
    final logoChild = logo ? const _SkelLogo() : null;
    // 티커가 꺼진 자리(위에 라우트가 덮인 화면 등)에선 시계를 안 듣는다 —
    // 안 그리는 곳을 매 프레임 rebuild 만 하게 된다. 다시 켜지면 rebuild 로 돌아온다.
    final box = TickerMode.valuesOf(context).enabled
        ? AnimatedBuilder(
            animation: clock,
            child: logoChild,
            builder: (_, child) => _box(clock.value, child),
          )
        : _box(-1.5, logoChild);
    if (widthFactor == null) return box;
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: box,
    );
  }

  /// [v] 는 띠 위치 -1.5 ~ 1.5.
  Widget _box(double v, Widget? child) => Container(
    width: width,
    height: height,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius.r),
      gradient: LinearGradient(
        begin: Alignment(v - 1, 0),
        end: Alignment(v + 1, 0),
        colors: const [
          VybeColors.gray900,
          VybeColors.gray700,
          VybeColors.gray900,
        ],
      ),
    ),
    // 로고 밝기는 shimmer 띠와 같은 값으로 움직인다 — 띠가 가운데일 때 가장 밝다.
    child: child == null
        ? null
        : Opacity(opacity: 0.10 + 0.14 * (1 - v.abs() / 1.5), child: child),
  );
}

class _SkelLogo extends StatelessWidget {
  const _SkelLogo();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) {
      // 칸이 좁으면(작은 썸네일) 로고를 뺀다 — 뭉개져 회색 얼룩으로만 보인다.
      final side = c.biggest.shortestSide;
      if (!side.isFinite || side < 48) return const SizedBox.shrink();
      return SvgPicture.asset(
        'assets/icons/common/vybe_white_logo.svg',
        width: (c.maxWidth * 0.42).clamp(40.0, 110.0),
        // 로고 원본엔 보라·라임이 섞여 있다 — 전부 흰색으로. 밝기는 바깥 Opacity 몫.
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    },
  );
}

// ── 네트워크 이미지 provider ────────────────────────────────────

/// 디스크 캐시(7일) + 표시 크기 디코드 상한이 붙은 네트워크 이미지.
///
/// `Image.network` 는 메모리 캐시뿐이라 앱을 껐다 켜면 Storage 에서 전부 다시
/// 받는다(egress 과금). [cacheWidth]·[cacheHeight] 는 물리 px —
/// `(표시 폭 * MediaQuery.devicePixelRatioOf(context)).round()`. 하나만 주면
/// 나머지는 비율대로. 원본이 더 작으면 확대하지 않는다.
///
/// ⚠ `BoxFit.cover` 에서 어느 축이 병목인지는 **원본** 비율이 정한다 — 박스 축
/// 하나로만 묶으면 반대로 긴 원본이 페인트에서 확대돼 흐려진다. [SkeletonImage] 는
/// 가로·정사각 칸을 `max(w, h·16/9)` 폭으로, 세로 칸을 `max(h, w·16/9)` 높이로
/// 묶어 9:16~16:9 원본까지 확대 0 을 보장한다. 상한이 필요 없는 자리(배너처럼
/// 원본이 작은 것)는 `SkeletonImage(image: vybeNetworkImage(url))` 로 그대로 넘긴다.
ImageProvider vybeNetworkImage(
  String url, {
  int? cacheWidth,
  int? cacheHeight,
}) => ResizeImage.resizeIfNeeded(
  cacheWidth,
  cacheHeight,
  CachedNetworkImageProvider(url),
);

// ── Skeleton 이미지 ─────────────────────────────────────────────
//
// 이미지 로딩 중 + 디코드 완료 후에도 최소 [minSkeleton] 동안
// 스켈레톤(shimmer)을 유지한 뒤 페이드로 이미지를 노출한다.
// URL 로딩 지연 시 깜빡임을 막기 위한 위젯.

class SkeletonImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Duration minSkeleton;

  /// 주면 레이아웃 기반 디코드 상한 대신 이 provider 를 그대로 쓴다(캐시 확인도
  /// 이 키로). `precacheImage` 와 키를 맞춰야 하는 배너처럼 상한이 필요 없는 자리용.
  final ImageProvider? image;

  const SkeletonImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.minSkeleton = const Duration(seconds: 1),
    this.image,
  });

  @override
  State<SkeletonImage> createState() => _SkeletonImageState();
}

class _SkeletonImageState extends State<SkeletonImage> {
  /// 이 세션에서 한 번 디코드가 끝난 URL. 같은 사진을 다른 크기로 다시 그리면
  /// (찜 리스트↔그리드, 미리보기→사진 탭) 캐시 키가 달라 miss 지만 디스크에서
  /// 수십 ms 에 오므로 [SkeletonImage.minSkeleton] 을 건너뛴다(페이드만 남는다).
  static final _settledUrls = <String>{};

  bool _revealed = false;
  bool _loaded = false;

  /// 페이드가 끝나면 스켈레톤을 트리에서 뺀다 — 투명(alpha 0)한 AnimatedOpacity 는
  /// repaint boundary 가 아니라, 밑에 남은 shimmer 가 매 프레임 카드 전체를 다시 그린다.
  bool _skelGone = false;
  bool _cacheChecked = false;
  late final DateTime _start;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start = DateTime.now();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 이미 ImageCache에 있으면(재방문) skeleton 없이 즉시 노출.
  // 최초 로드(캐시 없음)일 때만 minSkeleton 동안 shimmer 표시.
  // 키가 디코드 크기(레이아웃)에 따라 달라져 첫 build 에서 본다.
  void _checkCache(ImageProvider provider) {
    if (_cacheChecked) return;
    _cacheChecked = true;
    // CachedNetworkImageProvider·ResizeImage 의 obtainKey 는 동기(SynchronousFuture).
    provider.obtainKey(ImageConfiguration.empty).then((key) {
      final status = PaintingBinding.instance.imageCache.statusForKey(key);
      if (status.keepAlive || status.live) {
        _loaded = _revealed = _skelGone = true;
      }
    });
  }

  // 이미지 디코드(또는 에러) 완료 시 호출 — 최소 표시 시간 보장 후 reveal.
  void _onSettled() {
    if (_loaded) return;
    _loaded = true;
    final remain = _settledUrls.add(widget.url)
        ? widget.minSkeleton - DateTime.now().difference(_start)
        : Duration.zero;
    if (remain > Duration.zero) {
      _timer = Timer(remain, () {
        if (mounted) setState(() => _revealed = true);
      });
    } else {
      if (mounted) setState(() => _revealed = true);
    }
  }

  void _scheduleSettle() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onSettled());
  }

  /// 표시 크기 → 디코드 상한. `cover` 인 세로 칸은 높이로, 그 외엔 폭으로 묶는다.
  /// `cover` 는 어느 축이 병목인지 **원본** 비율이 정하므로 반대 축에 16:9 만큼
  /// 여유를 둔다 — 가로 칸에 16:9 사진이 오면 폭 상한 디코드의 높이가 칸에 못 미쳐
  /// 페인트에서 확대되던 문제(히어로 1.6×). 9:16~16:9 원본은 확대 0.
  ImageProvider _provider(BuildContext context, BoxConstraints c) {
    if (widget.image != null) return widget.image!;
    double? finite(double? v) => (v != null && v.isFinite) ? v : null;
    final w = finite(widget.width) ?? finite(c.maxWidth);
    final h = finite(widget.height) ?? finite(c.maxHeight);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final byHeight =
        h != null && (w == null || (widget.fit == BoxFit.cover && h > w));
    var bound = byHeight ? h : w;
    if (widget.fit == BoxFit.cover && w != null && h != null) {
      bound = byHeight ? math.max(h, w * 16 / 9) : math.max(w, h * 16 / 9);
    }
    final px = bound == null ? null : (bound * dpr).round();
    return vybeNetworkImage(
      widget.url,
      cacheWidth: byHeight ? null : px,
      cacheHeight: byHeight ? px : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = LayoutBuilder(
      builder: (context, c) {
        final provider = _provider(context, c);
        _checkCache(provider);
        return Stack(
          fit: StackFit.passthrough,
          children: [
            Image(
              image: provider,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              frameBuilder: (_, child, frame, wasSync) {
                if ((frame != null || wasSync) && !_loaded) _scheduleSettle();
                return child;
              },
              errorBuilder: (_, __, ___) {
                if (!_loaded) _scheduleSettle();
                return Container(
                  width: widget.width,
                  height: widget.height,
                  color: VybeColors.gray900,
                );
              },
            ),
            if (!_skelGone)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: _revealed,
                  child: AnimatedOpacity(
                    opacity: _revealed ? 0 : 1,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    onEnd: () {
                      if (_revealed && mounted) {
                        setState(() => _skelGone = true);
                      }
                    },
                    child: VybeSkel(
                      width: widget.width,
                      height: widget.height,
                      radius: 0,
                      logo: true,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );

    if (widget.borderRadius == null) return content;
    return ClipRRect(borderRadius: widget.borderRadius!, child: content);
  }
}
