import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/club_table_layout.dart';
import 'package:vybe/data/models/table_layout_palette.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/table_price_format.dart';

// 플로어 배치도 — 격자 셀 좌표를 픽셀로 펼쳐 그린다.
//
// 셀 크기는 **폭에서만** 구한다(`maxWidth / cols`). 높이로 따로 구하면 두 값이
// 미세하게 달라져 아래로 갈수록 도형이 어긋난다. 셀이 정사각이므로 캔버스 높이는
// `cell * rows` 로 따라온다 — 업주 웹도 같은 식을 써야 같은 그림이 나온다.

/// 배치도 캔버스. 층 하나를 그린다.
class ClubFloorMap extends StatelessWidget {
  final ClubTableLayout layout;
  final TableFloor floor;

  /// 선택된 테이블 [ClubTable.id].
  final String selId;
  final ValueChanged<String> onSelect;

  const ClubFloorMap({
    super.key,
    required this.layout,
    required this.floor,
    required this.selId,
    required this.onSelect,
  });

  /// 캔버스 안쪽 여백 — 테두리에 도형이 닿아 붙어 보이지 않게.
  ///
  /// ⚠ 이 값이 격자 폭을 깎아 셀 크기를 줄인다 — `kMaxGridCols` 의 탭 타겟 계산에
  ///   같이 들어가 있다. 키우려면 열 상한을 다시 계산할 것.
  static const double _pad = 8;

  /// 바닥판 채움 — 위가 밝은 방사형.
  static const _plateGradient = RadialGradient(
    center: Alignment(0, -1),
    radius: 1.1,
    colors: [Color(0xFF1B1B22), Color(0xFF101014)],
    stops: [0.0, 0.72],
  );

  @override
  Widget build(BuildContext context) {
    // 방이 직사각형이면 예전처럼 둥근 카드로 그린다 — 대부분의 클럽이 여기 해당하고,
    // 셀 단위 외곽선은 모서리가 각져 카드보다 거칠다.
    final rect = floor.isFullRect;

    return Container(
      clipBehavior: rect ? Clip.antiAlias : Clip.none,
      padding: EdgeInsets.all(_pad.w),
      // 테두리는 자식 위에 — decoration 에 두면 코너 호에서 선이 덮인다.
      foregroundDecoration: rect
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: VybeColors.gray800),
            )
          : null,
      decoration: rect
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: _plateGradient,
            )
          : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cell = constraints.maxWidth / floor.cols;
          return SizedBox(
            width: constraints.maxWidth,
            height: cell * floor.rows,
            child: Stack(
              children: [
                // 깎인 방은 바닥판을 셀 모양대로 직접 그린다.
                if (!rect)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _FloorPlatePainter(floor: floor, cell: cell),
                    ),
                  ),
                // 구조물이 먼저 — 테이블이 항상 위에 온다.
                for (final f in floor.fixtures)
                  _place(f.rect, cell, child: _FixtureBox(fixture: f)),
                for (final t in floor.tables)
                  _place(
                    t.rect,
                    cell,
                    child: _TableSpot(
                      table: t,
                      tier: layout.tierOf(t.tierKey),
                      selected: selId == t.id,
                      onTap: () => onSelect(t.id),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _place(GridRect r, double cell, {required Widget child}) => Positioned(
    left: r.col * cell,
    top: r.row * cell,
    width: r.colSpan * cell,
    height: r.rowSpan * cell,
    child: child,
  );
}

// ── 바닥판 ──

/// 방 모양(`floor.cells`)대로 바닥을 칠하고 **경계 변에만** 외곽선을 긋는다.
///
/// 셀마다 사각형을 다 그리면 격자무늬처럼 보인다 — 채움은 이어 붙이고
/// 선은 방 밖과 맞닿은 변에서만 그어야 하나의 방 윤곽으로 읽힌다.
class _FloorPlatePainter extends CustomPainter {
  final TableFloor floor;
  final double cell;

  const _FloorPlatePainter({required this.floor, required this.cell});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..shader = ClubFloorMap._plateGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();
    for (var r = 0; r < floor.rows; r++) {
      for (var c = 0; c < floor.cols; c++) {
        if (!floor.isInside(c, r)) continue;
        // 0.5 씩 부풀려 이웃 칸과 겹치게 한다 — 딱 맞붙이면 안티에일리어싱 때문에
        // 칸 사이에 실선 같은 이음매가 보인다.
        path.addRect(
          Rect.fromLTWH(c * cell, r * cell, cell, cell).inflate(0.5),
        );
      }
    }
    canvas.drawPath(path, fill);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = VybeColors.gray800;

    for (var r = 0; r < floor.rows; r++) {
      for (var c = 0; c < floor.cols; c++) {
        if (!floor.isInside(c, r)) continue;
        final l = c * cell, t = r * cell, rt = l + cell, b = t + cell;
        if (!floor.isInside(c - 1, r)) {
          canvas.drawLine(Offset(l, t), Offset(l, b), stroke);
        }
        if (!floor.isInside(c + 1, r)) {
          canvas.drawLine(Offset(rt, t), Offset(rt, b), stroke);
        }
        if (!floor.isInside(c, r - 1)) {
          canvas.drawLine(Offset(l, t), Offset(rt, t), stroke);
        }
        if (!floor.isInside(c, r + 1)) {
          canvas.drawLine(Offset(l, b), Offset(rt, b), stroke);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_FloorPlatePainter old) =>
      old.cell != cell || old.floor != floor;
}

// ── 구조물 ──

class _FixtureBox extends StatelessWidget {
  final FloorFixture fixture;

  const _FixtureBox({required this.fixture});

  @override
  Widget build(BuildContext context) {
    final style = fixtureStyleOf(fixture.type.key);
    final label = fixture.displayLabel;
    final radius = BorderRadius.circular(10.r);

    return Padding(
      padding: EdgeInsets.all(1.5.w),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          borderRadius: radius,
          color: style.gradient == null ? style.fill : null,
          gradient: style.gradient,
          // 점선은 CustomPaint 로 그린다 — Border 에 점선이 없다.
          border: style.dashed
              ? null
              : Border.all(color: style.border, width: style.borderWidth),
        ),
        foregroundDecoration: style.dashed
            ? _DashedBorder(color: style.border, radius: radius)
            : null,
        // ⚠ 라벨은 폭에 맞춰 접는다 — 디자인은 'DANCE FLOOR' 가 두 줄로 쌓인
        // 모습이다. 접는 규칙은 _text 참고.
        child: label.isEmpty ? null : _label(style, label),
      ),
    );
  }

  /// 라벨 줄(+ 타입 고정 보조 캡션). 캡션은 디자인이 타입마다 박아 둔 문구다.
  Widget _label(FixtureStyle style, String label) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (style.icon != null) ...[
          Icon(style.icon, size: 14.r, color: style.text),
          SizedBox(width: 6.w),
        ],
        Flexible(child: _text(style, label)),
      ],
    );
    if (style.caption == null) return row;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: row),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              style.caption!,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 10.sp,
                height: 13 / 10,
                letterSpacing: 10 * -0.025,
                color: VybeColors.gray600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ⚠ **띄어쓰기가 있는 라벨만 접는다**('DANCE FLOOR' 는 디자인이 두 줄로
  /// 쌓은 모습이다). 'STAIRS' 처럼 한 단어짜리 라벨을 좁은 칸에서 접으면
  /// 단어 중간이 끊겨 'ST / AIR / S' 로 보인다 — 그건 한 줄로 두고 줄인다.
  Widget _text(FixtureStyle style, String label) {
    final wrap = label.contains(' ');
    final text = Text(
      label,
      textAlign: TextAlign.center,
      maxLines: wrap ? 3 : 1,
      softWrap: wrap,
      overflow: TextOverflow.clip,
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12.sp,
        height: 13 / 12,
        fontWeight: FontWeight.w700,
        letterSpacing: style.letterSpacing,
        color: style.text,
      ),
    );
    return wrap ? text : FittedBox(fit: BoxFit.scaleDown, child: text);
  }
}

/// 점선 라운드 테두리 (디자인 `1.5px dashed`).
///
/// `Border` 에 점선이 없어 `foregroundDecoration` 에 그린다 — 자식 위에
/// 올라가므로 코너 호에서도 선이 안 끊긴다(CLAUDE.md 라운드 카드 규칙).
class _DashedBorder extends Decoration {
  final Color color;
  final BorderRadius radius;

  const _DashedBorder({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _DashedBorderPainter(color: color, radius: radius);
}

class _DashedBorderPainter extends BoxPainter {
  final Color color;
  final BorderRadius radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final size = cfg.size;
    if (size == null) return;
    final rect = (offset & size).deflate(0.75);
    final path = Path()..addRRect(radius.toRRect(rect));
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color;

    // 5px 그리고 4px 쉰다.
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final end = (d + 5).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(d, end), paint);
        d = end + 4;
      }
    }
  }
}

// ── 테이블 ──

class _TableSpot extends StatelessWidget {
  final ClubTable table;
  final TableTierDef tier;
  final bool selected;
  final VoidCallback onTap;

  const _TableSpot({
    required this.table,
    required this.tier,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = tierStyleOf(tier.colorKey);
    final radius = table.shape == TableShape.circle
        ? BorderRadius.circular(999.r)
        : BorderRadius.circular(9.r);

    return GestureDetector(
      onTap: onTap,
      // 도형 사이 여백(2px)까지 탭을 받는다 — 격자 규칙상 도형 자체가 44px 이상이라
      // 여기서 크기를 더 키우면 옆 테이블의 탭을 가로챈다.
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: selected ? style.selectedFill : style.fill,
            borderRadius: radius,
            border: Border.all(
              color: selected ? style.dot : style.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: style.border,
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tier.short,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 9.sp,
                    height: 10 / 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.27,
                    color: selected ? const Color(0xE0FFFFFF) : style.text,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  formatTablePriceShort(table.price),
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13.sp,
                    height: 14 / 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 13 * -0.025,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 층 전환 탭 ──

/// 층이 2개 이상일 때만 배치도 위에 붙는다.
class FloorTabs extends StatelessWidget {
  final List<TableFloor> floors;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const FloorTabs({
    super.key,
    required this.floors,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: VybeColors.gray800),
      ),
      child: Row(
        children: [
          for (var i = 0; i < floors.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelect(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 34.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == selectedIndex
                        ? VybeColors.mainPurple500
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Text(
                    floors[i].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 13 * -0.025,
                      color: i == selectedIndex
                          ? Colors.white
                          : VybeColors.gray400,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
