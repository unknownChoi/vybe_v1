import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vybe/presentation/dev/vybe_dev_menu.dart';

/// 앱 루트 Navigator 키.
///
/// `MaterialApp.builder` 의 context 는 Navigator **바깥**이라 `Navigator.of(context)` 로는
/// 아무것도 열 수 없다. 개발 메뉴를 그 자리에서 띄우려면 키가 필요하다.
/// 릴리스 빌드에서도 키 자체는 존재하지만 **아무도 쓰지 않는다**(입구가 트리에 없다).
final GlobalKey<NavigatorState> vybeRootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'vybeRoot');

/// 개발용 입구. **`kDebugMode` 에서만** 그려진다.
///
/// 릴리스 빌드에서는 [child] 를 그대로 돌려줘 트리에 아무것도 더하지 않는다 —
/// 버튼이 '숨겨지는' 게 아니라 **존재하지 않는다**.
///
/// 붙는 자리는 `MaterialApp.builder` 한 곳이라 베타 화면 코드는 건드리지 않는다.
class VybeDevOverlay extends StatefulWidget {
  const VybeDevOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<VybeDevOverlay> createState() => _VybeDevOverlayState();
}

class _VybeDevOverlayState extends State<VybeDevOverlay> {
  /// 버튼 위치 — 화면을 가리면 끌어서 옮긴다.
  Offset _pos = const Offset(0, 0.62);

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return widget.child;

    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        widget.child,
        Positioned(
          right: 10 + _pos.dx,
          top: size.height * _pos.dy,
          child: GestureDetector(
            onPanUpdate: (d) => setState(() {
              _pos = Offset(
                (_pos.dx - d.delta.dx).clamp(0.0, size.width - 56),
                (_pos.dy + d.delta.dy / size.height).clamp(0.04, 0.9),
              );
            }),
            onTap: VybeDevMenu.open,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xCC7731FE),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x33FFFFFF)),
              ),
              child: const Icon(
                Icons.science_outlined,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
