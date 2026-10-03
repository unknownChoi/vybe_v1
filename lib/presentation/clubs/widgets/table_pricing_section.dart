import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/utils/phone_launcher.dart';
import 'package:vybe/core/utils/url_launcher_util.dart';
import 'package:vybe/data/models/club_table_layout.dart';
import 'package:vybe/data/models/table_layout_palette.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_skeleton.dart';
import 'package:vybe/presentation/clubs/widgets/table_floor_map.dart';
import 'package:vybe/presentation/clubs/widgets/table_tier_list.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/table_price_format.dart';
import 'package:vybe/presentation/common/widgets/vybe_meta_dot.dart';

// CLUB-023 테이블 가격 본문 — 인트로 + 배치도 + 범례 + 등급별 목록 + 안내 + 문의.
//
// 디자인 `table_pricing.jsx`. 데이터는 `clubs/{clubId}/tableLayout/{clubId}`
// 문서 하나(업주 웹이 편집). 배치도가 없는 클럽은 호출부가 섹션을 안 그린다.
//
// ⚠ 디자인에 있던 '선택 자리 상세 카드'는 **없다** — 공유 모듈 tables.jsx 의
// `TableDetail` 은 정의만 있고 호출이 0건이다. 그 정보는 등급별 목록 카드가
// 담는다. 위젯 파일(`table_detail_sheet.dart`)은 지우지 않는다.

class TablePricingSection extends StatefulWidget {
  final ClubTableLayout layout;

  /// 인트로 메타 줄 — '어썸 레드 · 홍대'.
  final String clubName;
  final String clubArea;

  /// 예약 문의 버튼이 거는 곳. 비면 그 버튼은 눌리지 않는다.
  final String clubPhone;
  final String clubOpenChatUrl;

  const TablePricingSection({
    super.key,
    required this.layout,
    this.clubName = '',
    this.clubArea = '',
    this.clubPhone = '',
    this.clubOpenChatUrl = '',
  });

  @override
  State<TablePricingSection> createState() => _TablePricingSectionState();
}

class _TablePricingSectionState extends State<TablePricingSection> {
  int _floorIndex = 0;
  String _selId = '';

  ClubTableLayout get _layout => widget.layout;

  TableFloor get _floor => _layout.floors[_floorIndex];

  // 진입 시 선택은 **없다**(디자인 `useState(null)`) — 배치도·목록 어디에도
  // 하이라이트가 없는 상태로 시작한다.

  void _selectFloor(int i) {
    if (i == _floorIndex) return;
    setState(() {
      _floorIndex = i;
      // 층을 바꾸면 선택을 **푼다** — 다른 층 자리가 선택된 채로 남으면
      // 배치도엔 하이라이트가 없는데 목록만 하나 켜져 있다.
      _selId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // 범례는 **지금 보고 있는 층**만 센다 — 전 층 기준으로 세면 바로 아래
    // 등급별 목록(그 층만 본다)과 같은 등급에 다른 금액이 뜬다.
    final tiers = _layout
        .usedTiers()
        .where((t) => _floor.tables.any((x) => x.tierKey == t.key))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _intro(),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 층 탭은 디자인에 없지만 남긴다 — 지우면 2층 이상 클럽의 위층
              // 테이블이 앱에서 도달 불가가 된다(결정 기록 참고).
              if (_layout.isMultiFloor) ...[
                FloorTabs(
                  floors: _layout.floors,
                  selectedIndex: _floorIndex,
                  onSelect: _selectFloor,
                ),
                SizedBox(height: 12.h),
              ],
              ClubFloorMap(
                layout: _layout,
                floor: _floor,
                selId: _selId,
                onSelect: (id) => setState(() => _selId = id),
              ),
              SizedBox(height: 12.h),
              _legend(tiers),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 0),
          child: TableTierList(
            layout: _layout,
            floor: _floor,
            selId: _selId,
            onSelect: (id) => setState(() => _selId = id),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 2.h, 20.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _noticeCard(),
              SizedBox(height: 16.h),
              Text(
                '예약 문의',
                style: VybeTypography.button2.copyWith(
                  color: VybeColors.gray400,
                ),
              ),
              SizedBox(height: 8.h),
              _contactRow(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
          child: Text(
            '가격 및 예약 조건은 매장 사정에 따라 변경될 수 있습니다.',
            textAlign: TextAlign.center,
            style: RenewGlass.caption(
              size: 12,
              lineHeight: 16,
              color: VybeColors.gray600,
            ),
          ),
        ),
      ],
    );
  }

  /// 인트로 — 클럽명 · 지역 / 큰 제목 / 총 좌석 수 / 안내 한 줄.
  Widget _intro() {
    final seats = _layout.floors.fold<int>(
      0,
      (sum, f) => sum + f.tables.length,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.clubName.isNotEmpty)
            Row(
              children: [
                Flexible(
                  child: Text(
                    widget.clubName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: RenewGlass.caption(
                      size: 12,
                      color: VybeColors.gray500,
                    ),
                  ),
                ),
                if (widget.clubArea.isNotEmpty) ...[
                  const VybeMetaDot(size: 2, gap: 6),
                  Text(
                    widget.clubArea,
                    style: RenewGlass.caption(
                      size: 12,
                      color: VybeColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '테이블 & 자리 가격',
                  style: VybeTypography.heading3.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  '총 $seats석',
                  style: VybeTypography.body4.copyWith(
                    color: VybeColors.gray400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '자리를 누르면 지도와 목록에서 위치를 함께 확인할 수 있어요.',
            style: RenewGlass.caption(
              size: 12,
              lineHeight: 16,
              color: VybeColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  /// 안내 및 유의사항 — 전 클럽 공통 3줄.
  ///
  /// ⚠ 업주가 넣은 `layout.notice` 는 이 카드 **아래 한 줄**로 남긴다.
  /// 디자인에는 그 자리가 없지만, 지우면 업주가 적어 둔 매장별 안내가
  /// 화면에서 통째로 사라진다.
  Widget _noticeCard() {
    const items = [
      '성인만 입장 가능합니다.',
      '테이블 가격은 요일 및 이벤트에 따라 변동될 수 있습니다.',
      '예약금은 최소 주문 금액에 포함되며, 방문일 3일 전까지 취소 시 전액 환불됩니다.',
    ];
    final radius = BorderRadius.circular(12.r);
    final body = VybeTypography.body4.copyWith(
      fontSize: 13.sp,
      height: 19 / 13,
      color: VybeColors.gray300,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0x08FFFFFF),
        borderRadius: radius,
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: VybeColors.gray800),
        borderRadius: radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '안내 및 유의사항',
            style: VybeTypography.button2.copyWith(
              fontWeight: FontWeight.w700,
              color: VybeColors.gray300,
            ),
          ),
          SizedBox(height: 10.h),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Text(
                      '•',
                      style: body.copyWith(color: VybeColors.gray600),
                    ),
                  ),
                  Expanded(child: Text(items[i], style: body)),
                ],
              ),
            ),
          if (_layout.notice.isNotEmpty) ...[
            SizedBox(height: 10.h),
            const Divider(height: 1, color: VybeColors.gray800),
            SizedBox(height: 10.h),
            Text(_layout.notice, style: body),
          ],
        ],
      ),
    );
  }

  /// 예약 문의 — 전화 · 오픈채팅.
  Widget _contactRow() {
    final phone = widget.clubPhone;
    final chat = widget.clubOpenChatUrl;
    return Row(
      children: [
        Expanded(
          child: _ContactButton(
            icon: Icons.call_outlined,
            label: '전화 문의',
            onTap: phone.isEmpty ? null : () => launchPhoneCall(context, phone),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _ContactButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: '오픈채팅 문의',
            onTap: chat.isEmpty ? null : () => launchExternalUrl(context, chat),
          ),
        ),
      ],
    );
  }

  /// 범례 — 이 층 등급별 최소 주문 금액의 최저값(등급별 목록 헤드와 같은 값).
  Widget _legend(List<TableTierDef> tiers) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Wrap(
        spacing: 16.w,
        runSpacing: 8.h,
        children: [
          for (final tier in tiers)
            Builder(
              builder: (_) {
                final style = tierStyleOf(tier.colorKey);
                final prices = _floor.tables
                    .where((t) => t.tierKey == tier.key)
                    .map((t) => t.minSpend)
                    .toList();
                final min = prices.isEmpty
                    ? 0
                    : prices.reduce((a, b) => a < b ? a : b);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9.r,
                      height: 9.r,
                      decoration: BoxDecoration(
                        color: style.dot,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      tier.name,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 12 * -0.025,
                        color: VybeColors.gray400,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      // 디자인 범례는 등급 **최소 주문 금액**을 정식 표기로 쓴다.
                      min > 0 ? '${formatWon(min)}~' : '문의',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 12 * -0.025,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

/// 예약 문의 버튼 — 전화 · 오픈채팅 (디자인 `Contact`).
///
/// 등록된 값이 없으면 눌리지 않는다(회색) — 눌러도 아무 일이 없는 버튼을
/// 멀쩡해 보이게 두지 않는다.
class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ContactButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final radius = BorderRadius.circular(10.r);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: VybeColors.gray900,
            borderRadius: radius,
          ),
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: VybeColors.gray800),
            borderRadius: radius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15.r, color: VybeColors.mainLime500),
              SizedBox(width: 7.w),
              Text(
                label,
                style: VybeTypography.button2.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 가격표 화면 로딩 자리 — 제목·안내 줄 + 배치도 판 + 범례 + 상세 카드 순서를
/// [TablePricingSection] 과 같은 여백으로 깔아 데이터가 와도 자리가 안 튄다.
class TablePricingSkeleton extends StatelessWidget {
  const TablePricingSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 인트로 — 메타 줄 / 큰 제목 / 안내 한 줄
        const RenewSkelBar(w: 120, h: 12),
        SizedBox(height: 10.h),
        const RenewSkelBar(w: 200, h: 24),
        SizedBox(height: 10.h),
        const RenewSkelBar(w: 240, h: 12),
        SizedBox(height: 16.h),
        // 배치도 + 범례
        const RenewSkelBar(h: 300, r: 16, logo: true),
        SizedBox(height: 12.h),
        const RenewSkelChips(widths: [72, 84, 68]),
        SizedBox(height: 22.h),
        // 등급 그룹 헤드 + 카드 2장
        const RenewSkelBar(w: 140, h: 14),
        SizedBox(height: 12.h),
        const RenewSkelCard(lines: [null, 180]),
        SizedBox(height: 10.h),
        const RenewSkelCard(lines: [null, 180]),
      ],
    ),
  );
}
