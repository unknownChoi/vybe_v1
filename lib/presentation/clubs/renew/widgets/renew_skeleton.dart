import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

/// 클럽 상세(리뉴얼) 로딩 스켈레톤.
///
/// 진입 로딩에 스피너를 쓰면 화면이 통째로 비어 있다가 한 번에 나타나 위치가
/// 튄다. 스켈레톤은 실제 레이아웃과 같은 자리에 같은 크기의 블록을 미리 깔아
/// 데이터가 도착해도 요소가 제자리에 그대로 채워지게 한다.
///
/// ⚠ **섹션 조각이 실제 위젯과 1:1로 대응한다** — 탭 전체 스켈레톤과, 섹션마다
/// 따로 도는 조회(메뉴·사진·라인업·테이블·주변·편의시설)의 스켈레톤이 같은
/// 조각을 쓴다. 복붙으로 나누면 두 자리가 같은 섹션을 다른 모양으로 그린다.
///
/// 블록 그림은 공용 [VybeSkel](shimmer)을 그대로 쓴다.

// ============================================================================
// 블록 프리미티브
// ============================================================================

/// shimmer 막대. [w] 가 null 이면 가로를 꽉 채운다.
class RenewSkelBar extends StatelessWidget {
  final double? w;
  final double h;
  final double r;

  /// 사진 자리면 true — 회색 도형에 VYBE 로고가 얹힌다.
  final bool logo;

  const RenewSkelBar({
    super.key,
    this.w,
    this.h = 14,
    this.r = 6,
    this.logo = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: w == null ? double.infinity : w!.w,
    height: h.h,
    child: VybeSkel(radius: r, logo: logo),
  );
}

/// 섹션 제목 줄. 실제 [RenewSectionHead] 와 같은 배치(제목 · 보조 문구 ·
/// 맨 오른쪽 액션)와 **같은 12 하단 여백**을 쓴다 — 여백이 다르면 데이터가
/// 도착하는 순간 아래 내용이 통째로 밀린다.
class RenewSkelHead extends StatelessWidget {
  final double title;
  final double? sub;
  final double? action;

  const RenewSkelHead({super.key, this.title = 72, this.sub, this.action = 52});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Row(
      children: [
        RenewSkelBar(w: title, h: 17, r: 6),
        if (sub != null) ...[
          SizedBox(width: 8.w),
          RenewSkelBar(w: sub!, h: 12),
        ],
        const Spacer(),
        if (action != null) RenewSkelBar(w: action!, h: 13),
      ],
    ),
  );
}

/// 글래스 카드 안에 본문 줄만 깔아 둔 스켈레톤.
class RenewSkelCard extends StatelessWidget {
  /// 각 줄의 가로 폭. null 이면 꽉 찬 줄.
  final List<double?> lines;
  final bool quiet;

  const RenewSkelCard({super.key, required this.lines, this.quiet = false});

  @override
  Widget build(BuildContext context) => RenewGlassCard(
    quiet: quiet,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          if (i > 0) SizedBox(height: 11.h),
          RenewSkelBar(w: lines[i], h: 14),
        ],
      ],
    ),
  );
}

/// 칩 한 줄 (필터·카테고리 바 자리).
class RenewSkelChips extends StatelessWidget {
  final List<double> widths;

  const RenewSkelChips({super.key, this.widths = const [58, 72, 64, 80]});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < widths.length; i++) ...[
        if (i > 0) SizedBox(width: 8.w),
        RenewSkelBar(w: widths[i], h: 30, r: 999),
      ],
    ],
  );
}

// ============================================================================
// 타이틀 블록 (히어로 아래 아이덴티티)
// ============================================================================

/// [RenewTitleBlock] 자리. 상태 pill · 이름 · 메타 · 평점 · 소개 · 태그 순서를
/// 그대로 따라 둬서 데이터가 들어와도 아래 탭 바가 위아래로 안 흔들린다.
class RenewTitleSkeleton extends StatelessWidget {
  const RenewTitleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        RenewGlass.pagePad.w,
        0,
        RenewGlass.pagePad.w,
        2.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RenewSkelBar(w: 108, h: 26, r: 999),
          SizedBox(height: 12.h),
          const RenewSkelBar(w: 188, h: 26, r: 8),
          SizedBox(height: 12.h),
          const RenewSkelBar(w: 152, h: 14),
          SizedBox(height: 12.h),
          const RenewSkelBar(w: 118, h: 15),
          SizedBox(height: 12.h),
          const RenewSkelBar(h: 14),
          SizedBox(height: 7.h),
          const RenewSkelBar(w: 214, h: 14),
          SizedBox(height: 12.h),
          const RenewSkelChips(widths: [64, 82, 56]),
        ],
      ),
    );
  }
}

// ============================================================================
// 섹션 조각 — 실제 섹션 위젯과 같은 모양
//
// 홈/매장정보 탭은 섹션마다 조회가 따로 돈다. 클럽 문서가 먼저 도착해도
// 메뉴·사진·라인업·테이블·주변·편의시설은 뒤늦게 오는데, 그동안 자리를
// 비워 두면 섹션이 하나씩 튀어나오며 스크롤이 계속 밀린다.
// ============================================================================

/// 메뉴 한 줄 — 이름·설명·가격(왼쪽) + 78 정사각 사진(오른쪽).
/// 실제 [RenewMenuRows] 와 같이 위아래 16 여백 + 첫 줄 빼고 헤어라인.
class RenewSkelMenuRow extends StatelessWidget {
  final bool first;

  const RenewSkelMenuRow({super.key, this.first = false});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(vertical: 16.h),
    decoration: BoxDecoration(
      border: first
          ? null
          : const Border(top: BorderSide(color: RenewGlass.hair)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RenewSkelBar(w: 132, h: 15),
              SizedBox(height: 6.h),
              const RenewSkelBar(w: 176, h: 12),
              SizedBox(height: 8.h),
              const RenewSkelBar(w: 72, h: 14),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        SizedBox(
          width: 78.r,
          height: 78.r,
          child: const VybeSkel(radius: 14, logo: true),
        ),
      ],
    ),
  );
}

/// 오늘의 라인업 — 제목 + 공연 줄(아이콘 44 + 이름·시간).
class RenewSkelLineupSection extends StatelessWidget {
  final int rows;

  const RenewSkelLineupSection({super.key, this.rows = 2});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const RenewSkelHead(title: 88, sub: 62),
      for (var i = 0; i < rows; i++) ...[
        if (i > 0) SizedBox(height: 8.h),
        RenewGlassCard(
          quiet: true,
          radius: 14,
          padding: 12,
          child: Row(
            children: [
              SizedBox(
                width: 44.r,
                height: 44.r,
                child: const VybeSkel(radius: 12),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const RenewSkelBar(w: 112, h: 15),
                    SizedBox(height: 6.h),
                    const RenewSkelBar(w: 88, h: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ],
  );
}

/// 테이블 — 제목 + 등급 줄(점 · 등급명 · 좌석 · 최저가).
class RenewSkelTableSection extends StatelessWidget {
  final int rows;

  const RenewSkelTableSection({super.key, this.rows = 3});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const RenewSkelHead(title: 52, sub: 128, action: 44),
      for (var i = 0; i < rows; i++) ...[
        if (i > 0) SizedBox(height: 8.h),
        const RenewSkelBar(h: 45, r: 14),
      ],
    ],
  );
}

/// 메뉴 미리보기 — 제목 + 메뉴 3줄.
class RenewSkelMenuSection extends StatelessWidget {
  const RenewSkelMenuSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const RenewSkelHead(title: 44, sub: 116),
      for (var i = 0; i < 3; i++) RenewSkelMenuRow(first: i == 0),
    ],
  );
}

/// 사진 미리보기 — 제목 + 4×2 그리드(첫 칸 2×2). 실제 [RenewPhotoSection] 과
/// 같은 계산이라 폭이 달라도 같은 모양이 나온다.
class RenewSkelPhotoSection extends StatelessWidget {
  const RenewSkelPhotoSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const RenewSkelHead(title: 44, sub: 34),
      LayoutBuilder(
        builder: (_, c) {
          final gap = 8.w;
          final total = c.maxWidth;
          final height = total / 2;
          final colW = (total - gap * 3) / 4;
          final rowH = (height - gap) / 2;
          final bigW = colW * 2 + gap;

          Widget tile(double w, double h) => SizedBox(
            width: w,
            height: h,
            child: const VybeSkel(radius: 10, logo: true),
          );
          Widget column() => Column(
            children: [
              tile(colW, rowH),
              SizedBox(height: gap),
              tile(colW, rowH),
            ],
          );

          return SizedBox(
            height: height,
            child: Row(
              children: [
                tile(bigW, height),
                SizedBox(width: gap),
                column(),
                SizedBox(width: gap),
                column(),
              ],
            ),
          );
        },
      ),
    ],
  );
}

/// 주변 클럽 — 제목 + 가로 카드(썸네일 134 + 이름·메타).
class RenewSkelNearbySection extends StatelessWidget {
  /// 실제 [RenewNearbySection] 과 같은 값.
  static const double _thumb = 134;
  static const double _textBlock = 42;

  const RenewSkelNearbySection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const RenewSkelHead(title: 72, sub: 58, action: null),
      RenewEdgeBleed(
        height: _thumb.w + 9.h + _textBlock.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: RenewGlass.pagePad.w),
          itemCount: 3,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (_, __) => SizedBox(
            width: _thumb.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _thumb.w,
                  height: _thumb.w,
                  child: const VybeSkel(radius: 16, logo: true),
                ),
                SizedBox(height: 9.h),
                const RenewSkelBar(w: 96, h: 15),
                SizedBox(height: 6.h),
                const RenewSkelBar(w: 70, h: 12),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

/// 편의시설 — 제목 + 3열 그리드.
class RenewSkelFacilitiesSection extends StatelessWidget {
  final int rows;

  const RenewSkelFacilitiesSection({super.key, this.rows = 2});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const RenewSkelHead(title: 68, action: null),
      for (var row = 0; row < rows; row++) ...[
        if (row > 0) SizedBox(height: 10.h),
        Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) SizedBox(width: 10.w),
              const Expanded(child: RenewSkelBar(h: 78, r: 16)),
            ],
          ],
        ),
      ],
    ],
  );
}

/// 주소 카드 안 지하철 줄 — 헤어라인 + 역 2줄.
class RenewSkelSubwayLines extends StatelessWidget {
  const RenewSkelSubwayLines({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 1,
        color: RenewGlass.hair,
        margin: EdgeInsets.symmetric(vertical: 12.h),
      ),
      const RenewSkelBar(w: 168, h: 15),
      SizedBox(height: 8.h),
      const RenewSkelBar(w: 142, h: 15),
    ],
  );
}

/// 리뷰 카드 한 장 — 아바타 + 이름/별점 + 본문 2줄 + 사진.
class RenewSkelReviewCard extends StatelessWidget {
  const RenewSkelReviewCard({super.key});

  @override
  Widget build(BuildContext context) => RenewGlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 36.w,
              height: 36.h,
              child: const VybeSkel(radius: 999),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RenewSkelBar(w: 88, h: 14),
                SizedBox(height: 7.h),
                const RenewSkelBar(w: 112, h: 12),
              ],
            ),
          ],
        ),
        SizedBox(height: 14.h),
        const RenewSkelBar(h: 14),
        SizedBox(height: 7.h),
        const RenewSkelBar(w: 196, h: 14),
        SizedBox(height: 12.h),
        SizedBox(
          height: 72.h,
          child: Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) SizedBox(width: 8.w),
                SizedBox(
                  width: 72.w,
                  child: const VybeSkel(radius: 12, logo: true),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

// ============================================================================
// 탭별 스켈레톤
// ============================================================================

/// 홈 탭 — 매장 정보 / 라인업 / 테이블 / 메뉴 / 사진 / 주변 클럽 순서.
class RenewHomeSkeleton extends StatelessWidget {
  final EdgeInsets padding;

  const RenewHomeSkeleton({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: RenewGlass.sectionGap.h);
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: padding,
      children: [
        const RenewSkelCard(lines: [null, 196, 148]),
        gap,
        const RenewSkelLineupSection(),
        gap,
        const RenewSkelTableSection(),
        gap,
        const RenewSkelMenuSection(),
        gap,
        const RenewSkelPhotoSection(),
        gap,
        const RenewSkelNearbySection(),
      ],
    );
  }
}

/// 사진 탭 — 필터 칩 + 2열 매스너리.
class RenewPhotoSkeleton extends StatelessWidget {
  final EdgeInsets padding;

  const RenewPhotoSkeleton({super.key, required this.padding});

  /// 실제 타일과 같은 들쭉날쭉한 높이 (renew_photo_tab 의 높이 표와 같은 결).
  static const List<double> _left = [262, 180, 220];
  static const List<double> _right = [180, 180, 270];

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: padding,
      children: [
        const RenewSkelChips(widths: [56, 74, 68, 62]),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _column(_left)),
            SizedBox(width: 8.w),
            Expanded(child: _column(_right)),
          ],
        ),
      ],
    );
  }

  Widget _column(List<double> heights) => Column(
    children: [
      for (var i = 0; i < heights.length; i++) ...[
        if (i > 0) SizedBox(height: 8.h),
        RenewSkelBar(h: heights[i], r: 16, logo: true),
      ],
    ],
  );
}

/// 메뉴 탭 — 메뉴판 + 카테고리 칩 + 메뉴 행.
class RenewMenuSkeleton extends StatelessWidget {
  final EdgeInsets padding;

  const RenewMenuSkeleton({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: padding,
      children: [
        const RenewSkelBar(h: 208, r: 19, logo: true),
        SizedBox(height: 20.h),
        const RenewSkelChips(),
        SizedBox(height: 18.h),
        for (var i = 0; i < 5; i++) RenewSkelMenuRow(first: i == 0),
      ],
    );
  }
}

/// 리뷰 탭 — 평점 요약 + 작성 버튼 + 정렬 칩 + 리뷰 카드.
class RenewReviewSkeleton extends StatelessWidget {
  final EdgeInsets padding;

  const RenewReviewSkeleton({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: padding,
      children: [
        // 평점 요약 — 큰 숫자 + 분포 바 5줄
        RenewGlassCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const RenewSkelBar(w: 64, h: 34, r: 8),
                  SizedBox(height: 10.h),
                  const RenewSkelBar(w: 80, h: 12),
                ],
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < 5; i++) ...[
                      if (i > 0) SizedBox(height: 7.h),
                      const RenewSkelBar(h: 8, r: 999),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        const RenewSkelBar(h: 46, r: 14),
        SizedBox(height: 16.h),
        const RenewSkelChips(widths: [62, 62, 62]),
        SizedBox(height: 18.h),
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) SizedBox(height: 14.h),
          const RenewSkelReviewCard(),
        ],
      ],
    );
  }
}

/// 매장정보 탭 — 지도 카드 + 상세 정보 + 편의시설 그리드.
class RenewInfoSkeleton extends StatelessWidget {
  final EdgeInsets padding;

  const RenewInfoSkeleton({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: RenewGlass.sectionGap.h);
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: padding,
      children: [
        // 위치
        const RenewSkelHead(title: 44, action: 44),
        const RenewSkelBar(h: 172, r: 19),
        SizedBox(height: 12.h),
        const RenewSkelCard(lines: [null, 168], quiet: true),
        gap,
        // 상세 정보
        const RenewSkelHead(title: 72, action: null),
        const RenewSkelCard(lines: [null, null, 208, 150], quiet: true),
        gap,
        // 편의시설
        const RenewSkelFacilitiesSection(),
      ],
    );
  }
}
