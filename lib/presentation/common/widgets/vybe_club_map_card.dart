import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/nearby/nearby_map_presenter.dart';
import 'package:vybe/presentation/nearby/nearby_marker_factory.dart';

/// 카테고리 페이지(K-POP · 금연) 안에 박히는 작은 네이버 지도 (디자인 높이 300 · radius 16).
///
/// ⚠ **`forceGesture: true` 가 이 위젯의 핵심이다** — 지도는 세로로 스크롤되는
/// 페이지 한가운데에 있어서, 제스처를 선점(`EagerGestureRecognizer`)하지 않으면
/// 지도 위 드래그를 부모 `ListView` 가 가로채 지도가 한 픽셀도 안 움직인다.
/// 선점하면 반대로 지도 위에서는 페이지가 안 밀린다 — 지도를 조작하려면 그래야
/// 하므로 의도한 맞바꿈이다(주변 탭·클럽 상세 지도와 같은 설정).
///
/// ⚠ 그래서 **좌우 16 여백을 남긴다** — 화면 왼쪽 끝(약 20px)은 뒤로가기 드래그
/// 영역이라, 지도가 가장자리까지 닿으면 그 제스처까지 먹어 버린다.
///
/// 마커 생성·렌더 직렬화·선택 아이콘 교체는 주변 탭과 같은 조각
/// ([NearbyMarkerFactory] · [NearbyMapPresenter])을 그대로 쓴다. 지도 SDK 의
/// 크래시 회피(마커 이미지 직렬 생성 · 앱 복귀 시 캐시 폐기)가 거기 들어 있다.
class VybeClubMapCard extends ConsumerStatefulWidget {
  /// 지도에 찍을 클럽 (선택된 지역의 것만). 좌표가 없는 클럽은 호출부가 거른다.
  final List<ClubModel> clubs;

  /// 핀을 골랐을 때(또는 선택이 풀렸을 때). 부모가 하단 미니 카드를 띄운다.
  final ValueChanged<ClubModel?> onSelected;

  /// 하단 미니 카드가 떠 있는지 — 줌 버튼을 그만큼 올린다(디자인 `raised`).
  final bool raised;

  const VybeClubMapCard({
    super.key,
    required this.clubs,
    required this.onSelected,
    required this.raised,
  });

  @override
  ConsumerState<VybeClubMapCard> createState() => _VybeClubMapCardState();
}

class _VybeClubMapCardState extends ConsumerState<VybeClubMapCard>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  /// 부모가 `ListView(children:)` 라 그리드를 끝까지 내리면 sliver 가 이 자식을
  /// 회수한다 — 플랫폼 뷰 파괴 → 돌아오면 지도·마커·카메라 fit 이 처음부터 다시
  /// 돈다(수백 ms). 살려 둔다.
  @override
  bool get wantKeepAlive => true;

  late final NearbyMarkerFactory _factory;
  late final NearbyMapPresenter _map;

  /// 지도 첫 중심 (내 위치). initState 에서 한 번만 잡는다.
  late final NLatLng _initialCenter;

  /// 핀 탭 시 확대할 줌. 300 높이 카드라 주변 탭(17)보다 한 단계 넓게 본다.
  static const double _focusZoom = 16;

  /// 카메라 fit 여백 — 핀 이름표가 카드 밖으로 잘리지 않을 만큼.
  static const double _fitPadding = 40;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _factory = NearbyMarkerFactory(contextOf: () => context);
    _map = NearbyMapPresenter(
      factory: _factory,
      onPinTap: _onPinTap,
      // 이 지도는 지역 클러스터를 쓰지 않는다(regionMode 고정 false).
      onRegionTap: (_, __) {},
      onSelectionChanged: () {},
      onSelectionLost: () {
        if (mounted) widget.onSelected(null);
      },
      isMounted: () => mounted,
    );
    // 지도 첫 중심만 여기서 잡는다 — build 에서 watch 하면 위치가 갱신될 때마다
    // 옵션이 바뀌어 지도에 쓸데없는 업데이트가 나간다(초기 중심은 안 바뀐다).
    final me = ref.read(userLocationProvider);
    _initialCenter = NLatLng(me.lat, me.lng);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 앱이 백그라운드에서 돌아오면 마커 PNG(temp)가 purge 됐을 수 있다 —
  /// 캐시된 이미지를 그대로 쓰면 네이티브가 죽으므로 버리고 다시 그린다.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !mounted) return;
    _factory.invalidate();
    _map.reRenderLast();
  }

  /// ⚠ **목록이 실제로 바뀌었을 때만** 다시 그린다. 부모는 매 빌드마다 새
  /// `List` 인스턴스를 만들어 넘기므로(지역 필터 결과) `identical` 로 보면
  /// 핀을 고를 때마다 지도가 전부 다시 그려지고 카메라가 되돌아가, 방금 고른
  /// 핀이 선택 해제된다.
  static String _sigOf(List<ClubModel> clubs) =>
      clubs.map((c) => c.clubId).join(',');

  @override
  void didUpdateWidget(covariant VybeClubMapCard old) {
    super.didUpdateWidget(old);
    if (_sigOf(old.clubs) != _sigOf(widget.clubs)) _renderAndFit();
  }

  void _onPinTap(ClubModel club) {
    // 같은 핀을 다시 누르면 선택 해제 (미니 카드가 닫힌다).
    if (_map.selectedClubId == club.clubId) {
      _map.deselect(club);
      widget.onSelected(null);
      return;
    }
    // 핀이 하단 미니 카드에 가리지 않도록 화면 위쪽(0.4)에 놓는다.
    _map.focusPin(club, pivotY: 0.4, focusZoom: _focusZoom);
    widget.onSelected(club);
  }

  Future<void> _onMapReady(NaverMapController controller) async {
    _map.controller = controller;
    _map.myPosition = _initialCenter;
    await _renderAndFit();
  }

  Future<void> _renderAndFit() async {
    if (!_map.isReady) return;
    // 선택은 여기서 지우지 않는다 — 새 목록에 그 클럽이 남아 있으면 선택을
    // 유지해야 하고, 사라졌으면 프레젠터가 `onSelectionLost` 로 알려 준다
    // (여기서 먼저 지우면 그 알림이 안 와 미니 카드가 없는 클럽을 계속 띄운다).
    await _map.render(widget.clubs);
    if (!mounted) return;
    await _map.fitClubs(
      widget.clubs,
      padding: EdgeInsets.all(_fitPadding.r),
      singlePivotY: 0.5,
      singleZoom: _focusZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final radius = BorderRadius.circular(16.r);

    return SizedBox(
      height: 300.h,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: VybeColors.background,
                borderRadius: radius,
              ),
              // ⚠ 테두리는 자식 위(foregroundDecoration)에 — decoration 에 두면
              // 지도가 바깥 라운드렉트로 클립되며 코너 호에서 선을 덮는다.
              foregroundDecoration: BoxDecoration(
                border: Border.all(color: VybeColors.gray800),
                borderRadius: radius,
              ),
              child: NaverMap(
                forceGesture: true,
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: _initialCenter,
                    zoom: 14,
                  ),
                  mapType: NMapType.basic,
                  activeLayerGroups: const [
                    NLayerGroup.building,
                    NLayerGroup.transit,
                  ],
                  nightModeEnable: true,
                  rotationGesturesEnable: false,
                  tiltGesturesEnable: false,
                ),
                onMapReady: _onMapReady,
                // 빈 지도를 누르면 선택 해제.
                onMapTapped: (_, __) => _clearSelection(),
              ),
            ),
          ),
          Positioned(
            right: 12.w,
            bottom: (widget.raised ? 104 : 12).h,
            child: _MapControls(
              onZoomIn: () => _zoom(zoomIn: true),
              onZoomOut: () => _zoom(zoomIn: false),
              onRecenter: _recenter,
            ),
          ),
        ],
      ),
    );
  }

  void _clearSelection() {
    final id = _map.selectedClubId;
    if (id == null) return;
    final club = widget.clubs.where((c) => c.clubId == id).firstOrNull;
    if (club != null) _map.deselect(club);
    widget.onSelected(null);
  }

  void _zoom({required bool zoomIn}) {
    _map.controller?.updateCamera(
      zoomIn ? NCameraUpdate.zoomIn() : NCameraUpdate.zoomOut(),
    );
  }

  /// 내 위치로 복귀 — 좌표를 아직 못 받았으면 목록 전체가 보이게 되돌린다.
  void _recenter() {
    final pos = _map.myPosition;
    if (pos == null) {
      _renderAndFit();
      return;
    }
    _map.moveTo(pos, zoom: 15);
  }
}

/// 우하단 줌 +/- · 내 위치 버튼 (디자인 `MapControls`).
///
/// 디자인의 `backdropFilter: blur(10px)` 은 뺐다 — 34px 버튼에선 거의 안 보이는데
/// 플랫폼 뷰(지도) 위 `BackdropFilter` 는 Android 하이브리드 합성에서 비싸다.
/// 불투명도(0.82)는 디자인 값 그대로라 대비는 같다.
class _MapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onRecenter;

  const _MapControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onRecenter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: VybeColors.gray800),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ControlButton(icon: Icons.add_rounded, onTap: onZoomIn),
              Container(height: 1, width: 34.r, color: VybeColors.gray800),
              _ControlButton(icon: Icons.remove_rounded, onTap: onZoomOut),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: VybeColors.gray800),
          ),
          child: _ControlButton(
            icon: Icons.my_location_rounded,
            onTap: onRecenter,
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34.r,
        height: 34.r,
        alignment: Alignment.center,
        color: const Color(0xD1101013),
        child: Icon(icon, size: 16.r, color: Colors.white),
      ),
    );
  }
}
