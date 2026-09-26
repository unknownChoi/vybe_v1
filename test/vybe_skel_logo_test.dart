import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/home/widgets/home_banner_skeleton.dart';

Widget _wrap(Widget child) => ScreenUtilInit(
  designSize: const Size(393, 852),
  builder: (_, __) => MaterialApp(home: Center(child: child)),
);

void main() {
  testWidgets('사진 자리 스켈레톤엔 로고가 뜬다', (tester) async {
    await tester.pumpWidget(
      _wrap(const VybeSkel(width: 200, height: 120, logo: true)),
    );
    await tester.pump();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('작은 칸(48 미만)에선 로고를 뺀다', (tester) async {
    await tester.pumpWidget(
      _wrap(const VybeSkel(width: 40, height: 40, logo: true)),
    );
    await tester.pump();
    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets('페이지 진입 스켈레톤(홈 배너)에도 로고가 뜬다', (tester) async {
    await tester.pumpWidget(_wrap(const HomeBannerSkeleton()));
    await tester.pump();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('텍스트 줄 스켈레톤(logo:false)엔 로고 없음', (tester) async {
    await tester.pumpWidget(_wrap(const VybeSkel(width: 200, height: 14)));
    await tester.pump();
    expect(find.byType(SvgPicture), findsNothing);
  });
  _more();
}

// ── shimmer 시계 공유 · widthFactor · SkeletonImage 정리 ─────────────

Widget _wrapBox(Widget child) => ScreenUtilInit(
  designSize: const Size(393, 852),
  builder: (_, __) => MaterialApp(
    home: Center(child: SizedBox(width: 200, height: 100, child: child)),
  ),
);

/// 네트워크 없이 이미지를 넣는다 — 200×100 `cover` 칸이라 키는 폭(200·dpr) 기준.
/// [done] 을 완료하면 프레임이 도착한다.
Completer<ImageInfo> _seedImage(WidgetTester tester, String url) {
  final done = Completer<ImageInfo>();
  vybeNetworkImage(
    url,
    cacheWidth: (200 * tester.view.devicePixelRatio).round(),
  ).obtainKey(ImageConfiguration.empty).then((key) {
    PaintingBinding.instance.imageCache
      ..putIfAbsent(key, () => OneFrameImageStreamCompleter(done.future))
      // putIfAbsent 는 아직 안 온 이미지도 live 로 잡는다 — 캐시 히트로 안 보이게.
      ..clearLiveImages();
  });
  return done;
}

ImageInfo _onePixel() {
  final rec = ui.PictureRecorder();
  ui.Canvas(rec);
  return ImageInfo(image: rec.endRecording().toImageSync(1, 1));
}

void _more() {
  testWidgets('widthFactor 는 부모 폭 비율로 왼쪽 정렬', (tester) async {
    await tester.pumpWidget(
      _wrapBox(const VybeSkel(height: 20, widthFactor: 0.5)),
    );
    await tester.pump();
    final box = find.descendant(
      of: find.byType(VybeSkel),
      matching: find.byType(DecoratedBox),
    );
    expect(tester.getSize(box).width, 100);
    expect(
      tester.getTopLeft(box).dx,
      tester.getTopLeft(find.byType(VybeSkel)).dx,
    );
  });

  testWidgets('SkeletonImage 는 페이드가 끝나면 스켈레톤을 트리에서 뺀다', (tester) async {
    const url = 'https://example.com/fade.jpg';
    final done = _seedImage(tester, url);
    await tester.pumpWidget(
      _wrapBox(
        const SkeletonImage(url: url, minSkeleton: Duration(milliseconds: 100)),
      ),
    );
    await tester.pump();
    expect(find.byType(VybeSkel), findsOneWidget);

    done.complete(_onePixel());
    await tester.pump(); // 프레임 도착 → settle 예약
    await tester.pump(
      const Duration(milliseconds: 150),
    ); // minSkeleton → reveal
    expect(find.byType(VybeSkel), findsOneWidget); // 페이드 중엔 아직 있다
    await tester.pump(const Duration(milliseconds: 400)); // 페이드 끝 → onEnd
    await tester.pump();
    expect(find.byType(VybeSkel), findsNothing);
  });

  testWidgets('캐시에 있으면 스켈레톤 없이 시작한다', (tester) async {
    const url = 'https://example.com/hit.jpg';
    _seedImage(tester, url).complete(_onePixel());
    await tester.pump(); // 캐시에 실린다
    await tester.pumpWidget(_wrapBox(const SkeletonImage(url: url)));
    await tester.pump();
    expect(find.byType(VybeSkel), findsNothing);
  });
}
