import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/nearby/widgets/nearby_glass.dart';

/// 지도 우측 플로팅 컨트롤 — 디자인 `nearby_glass.jsx > NGControls`.
///
/// 줌 +/- 블록(44×42 두 칸이 세로로 붙은 글래스) 아래 내 위치 원형 버튼.
///
/// ⚠ 이 +/- 는 **단순 줌이 아니라 지역 클러스터 모드 토글**이다 —
/// 디자인 `onZoom(d) => setAreaMode(d < 0)`. 반대 방향 버튼은 비활성(투명도 .32).
/// 앱은 모드를 줌 임계값(`kNearbyRegionZoomThreshold`)으로 판정하므로
/// 버튼은 그 임계값 너머로 카메라를 옮겨 같은 결과를 낸다(판정은 한 곳에 둔다).
class NearbyMapControls extends StatelessWidget {
  /// 시트 상단 y좌표 (= 스택 높이 × 시트 비율).
  final double sheetTop;

  /// 지금 지역 클러스터 모드인지. 눌릴 수 있는 버튼이 갈린다.
  final bool areaMode;

  /// 지역 모드로 들어가기(핀 → 지역 동그라미).
  final VoidCallback onZoomOut;

  /// 지역 모드에서 나오기(지역 동그라미 → 핀).
  final VoidCallback onZoomIn;

  final VoidCallback onLocate;

  const NearbyMapControls({
    super.key,
    required this.sheetTop,
    required this.areaMode,
    required this.onZoomOut,
    required this.onZoomIn,
    required this.onLocate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16.w,
      bottom: sheetTop + 8.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              decoration: BoxDecoration(
                color: NearbyGlass.floatFill,
                border: Border.all(color: NearbyGlass.floatBorder),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ZoomButton(
                    icon: Icons.add_rounded,
                    // 지역 모드일 때만 '핀으로 돌아가기'가 눌린다.
                    onTap: areaMode ? onZoomIn : null,
                  ),
                  Container(height: 1, color: NearbyGlass.floatDivider),
                  _ZoomButton(
                    icon: Icons.remove_rounded,
                    onTap: areaMode ? null : onZoomOut,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 9.h),
          NearbyRoundButton(
            onTap: onLocate,
            child: Icon(
              Icons.my_location_rounded,
              size: 19.r,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;

  /// null이면 비활성 — 디자인 `opacity: .32`.
  final VoidCallback? onTap;

  const _ZoomButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: onTap == null ? 0.32 : 1,
        child: SizedBox(
          width: 44.w,
          height: 42.h,
          child: Icon(icon, size: 17.r, color: Colors.white),
        ),
      ),
    );
  }
}
