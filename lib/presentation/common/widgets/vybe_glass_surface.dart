import 'package:flutter/material.dart';

/// 강조 카드 위에 깔리는 종류 색 틴트 (CSS `linear-gradient(115deg, tint, transparent 58%)`).
///
/// 공지 카드·알림 카드가 [RenewGlassCard] 안에 `Positioned.fill` 로 얹는다.
/// (예전 이 파일의 유리 껍데기 `VybeGlassSurface` 는 RenewGlassCard 로 합쳐졌다 — 2026.09.15)
class GlassTintOverlay extends StatelessWidget {
  final Color tint;

  const GlassTintOverlay({super.key, required this.tint});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          // 115deg — 좌상단에서 우하단으로 옅게 흐른다.
          gradient: LinearGradient(
            begin: const Alignment(-0.9, -0.6),
            end: const Alignment(0.6, 0.5),
            colors: [tint, tint.withValues(alpha: 0)],
            stops: const [0.0, 0.58],
          ),
        ),
      ),
    );
  }
}
