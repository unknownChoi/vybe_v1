import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/utils/number_format.dart';
import 'package:vybe/data/models/club_table_layout.dart';
import 'package:vybe/data/models/table_layout_palette.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/table_price_format.dart';

/// CLUB-023 '등급별 테이블 목록' (디자인 `table_pricing.jsx > TierGroup`).
///
/// 배치도 아래에 등급별로 묶은 자리 카드. 지도 칸과 **같은 선택 상태**를 보고,
/// 어느 쪽을 눌러도 두 곳이 같이 하이라이트된다.
///
/// ⚠ 등급 순서는 디자인이 `['VVIP','VIP','STD']` 로 박아 두지만 등급 구성은
/// 클럽마다 달라 [ClubTableLayout.usedTiers] 순서(= `tiers[].order`)를 쓴다.
class TableTierList extends StatelessWidget {
  final ClubTableLayout layout;

  /// 지금 보고 있는 층의 테이블만 담는다.
  final TableFloor floor;

  /// 선택된 자리 id. 빈 문자열이면 선택 없음.
  final String selId;
  final ValueChanged<String> onSelect;

  const TableTierList({
    super.key,
    required this.layout,
    required this.floor,
    required this.selId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final groups = <TableTierDef, List<ClubTable>>{};
    for (final tier in layout.usedTiers()) {
      final tables = floor.tables
          .where((t) => t.tierKey == tier.key)
          .toList();
      if (tables.isNotEmpty) groups[tier] = tables;
    }
    if (groups.isEmpty) return const SizedBox.shrink();

    final entries = groups.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < entries.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == entries.length - 1 ? 0 : 22.h,
            ),
            child: _TierGroup(
              tier: entries[i].key,
              tables: entries[i].value,
              selId: selId,
              onSelect: onSelect,
            ),
          ),
      ],
    );
  }
}

class _TierGroup extends StatelessWidget {
  final TableTierDef tier;
  final List<ClubTable> tables;
  final String selId;
  final ValueChanged<String> onSelect;

  const _TierGroup({
    required this.tier,
    required this.tables,
    required this.selId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final style = tierStyleOf(tier.colorKey);
    // 헤드 금액 = 이 등급의 **최소 주문 금액** 최저값 (좌석 가격이 아니다).
    final spends = tables.map((t) => t.minSpend).toList();
    final minSpend = spends.reduce((a, b) => a < b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            children: [
              Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: style.dot,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                tier.name,
                style: VybeTypography.body3.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '· ${tables.length}석',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12.sp,
                  letterSpacing: 12 * -0.025,
                  color: VybeColors.gray500,
                ),
              ),
              const Spacer(),
              Text(
                minSpend > 0 ? '${formatWon(minSpend)}~' : '문의',
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 12 * -0.025,
                  color: style.text,
                ),
              ),
            ],
          ),
        ),
        for (var i = 0; i < tables.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == tables.length - 1 ? 0 : 10.h,
            ),
            child: _TableCard(
              table: tables[i],
              style: style,
              selected: selId.isNotEmpty && selId == tables[i].id,
              onTap: () => onSelect(tables[i].id),
            ),
          ),
      ],
    );
  }
}

class _TableCard extends StatelessWidget {
  final ClubTable table;
  final TableTierStyle style;
  final bool selected;
  final VoidCallback onTap;

  const _TableCard({
    required this.table,
    required this.style,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.r);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.all(14.w),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: selected ? style.fill : VybeColors.gray900,
          borderRadius: radius,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: style.border,
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        // 테두리는 자식 위에 — 클립되는 라운드 카드에서 decoration 에 두면
        // 코너 호에서 선이 사라진다 (CLAUDE.md).
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: selected ? style.dot : VybeColors.gray800,
          ),
          borderRadius: radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IdBadge(id: table.id, style: style),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        table.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: VybeTypography.body3.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (table.desc.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          table.desc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12.sp,
                            height: 15 / 12,
                            letterSpacing: 12 * -0.025,
                            color: VybeColors.gray500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                _SpendColumn(minSpend: table.minSpend),
              ],
            ),
            SizedBox(height: 11.h),
            _ConditionBar(table: table, style: style),
          ],
        ),
      ),
    );
  }
}

/// 좌측 등급 색 ID 배지 ('S1').
class _IdBadge extends StatelessWidget {
  final String id;
  final TableTierStyle style;

  const _IdBadge({required this.id, required this.style});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(9.r);
    return Container(
      width: 34.r,
      height: 34.r,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: style.fill, borderRadius: radius),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: style.border),
        borderRadius: radius,
      ),
      child: Text(
        id,
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          height: 13 / 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 12 * -0.025,
          color: style.text,
        ),
      ),
    );
  }
}

/// 우측 '1,000,000원~' + '최소 주문'.
class _SpendColumn extends StatelessWidget {
  final int minSpend;

  const _SpendColumn({required this.minSpend});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        minSpend > 0
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: formatThousands(minSpend),
                      style: VybeTypography.body3.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: '원~',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12.sp,
                        letterSpacing: 12 * -0.025,
                        color: VybeColors.gray500,
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                '문의',
                style: VybeTypography.body3.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
        SizedBox(height: 3.h),
        Text(
          '최소 주문',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10.sp,
            height: 12 / 10,
            letterSpacing: 10 * -0.025,
            color: VybeColors.gray500,
          ),
        ),
      ],
    );
  }
}

/// 카드 하단 조건 띠 — '최소 8인 · 보틀 3병 이상 주문 시 예약 가능'.
class _ConditionBar extends StatelessWidget {
  final ClubTable table;
  final TableTierStyle style;

  const _ConditionBar({required this.table, required this.style});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10.r);
    final base = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12.sp,
      height: 16 / 12,
      letterSpacing: 12 * -0.025,
      color: VybeColors.gray200,
    );
    final accent = base.copyWith(
      fontWeight: FontWeight.w800,
      color: style.text,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: style.fill, borderRadius: radius),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: style.border),
        borderRadius: radius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.h, right: 8.w),
            child: Icon(
              Icons.info_outline_rounded,
              size: 14.r,
              color: style.text,
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '최소 '),
                  TextSpan(text: '${table.minPeople}인', style: accent),
                  const TextSpan(text: ' · 보틀 '),
                  TextSpan(text: '${table.minBottles}병', style: accent),
                  const TextSpan(text: ' 이상 주문 시 예약 가능'),
                ],
                style: base,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
