import 'package:flutter/cupertino.dart' show CupertinoPageRoute;

/// 오른쪽으로 끌면 이전 페이지로 돌아가는 라우트.
///
/// 프레임워크 기본 동작(`CupertinoPageRoute`)을 그대로 쓴다 — 전환 애니메이션과
/// 드래그 백이 이미 들어 있다.
///
/// ⚠ 제스처는 **화면 왼쪽 끝(약 20px)에서만** 먹는다. 예전에는 같은 로직을
/// 복사해 화면 전체 폭으로 넓힌 라우트를 직접 들고 있었는데, 그 폭이
/// 프레임워크 private 상수라 200줄을 떠안아야 했다. 전체 폭 드래그가 다시
/// 필요하면 이 typedef를 예전 구현으로 되돌릴 것 (git: swipe_back_page_route.dart).
typedef SwipeBackPageRoute<T> = CupertinoPageRoute<T>;
