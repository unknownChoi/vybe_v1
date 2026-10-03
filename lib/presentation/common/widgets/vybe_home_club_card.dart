import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_meta_dot.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

/// 홈 가로 레일 클럽 카드 — 디자인 `home.jsx > ClubCard`.
///
/// 주변 클럽 · 타임 무료입장 두 섹션이 같이 쓴다(= 공용 승격 기준).
/// 사진(없으면 폴백 그라데이션) 위에 상단 pill 줄([badges])과
/// **카드 폭 전체를 덮는 하단 글래스 바**([info])를 올린다.
///
/// ⚠ 하단 바는 **사진을 실제로 블러한다**(`BackdropFilter`) — 디자인
/// `backdropFilter: 'blur(16px) saturate(150%)'`. CLAUDE.md 가 블러를 옵트인으로
/// 두면서 남겨 둔 예외가 바로 이 자리다("뒤에 사진·본문이 실제로 지나가는 자리").
/// 예전 '카드 전체를 덮는 가독성 그라데이션' 은 이 바가 대신한다.
class VybeHomeClubCard extends StatelessWidget {
  /// 디자인 250×156.
  static const double width = 250;
  static const double height = 156;

  final String thumbnailUrl;

  /// 사진이 없을 때 깔 그라데이션(`clubGradientFor`).
  final List<Color> gradient;

  /// 상단 pill 줄. 좌우 끝으로 벌어진다(디자인 `justifyContent: space-between`).
  final List<Widget> badges;

  /// 하단 글래스 바 안에 쌓는 줄들. 줄 사이 간격 5(디자인 `gap: 5`).
  final List<Widget> info;

  final VoidCallback onTap;

  const VybeHomeClubCard({
    super.key,
    required this.thumbnailUrl,
    required this.gradient,
    required this.info,
    required this.onTap,
    this.badges = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        // ⚠ 테두리는 **자식 위**(foregroundDecoration)에 그린다. decoration 쪽에
        // 두면 자식이 바깥 라운드렉트로 클립되면서 코너 호에서 선을 덮어 버린다 —
        // 직선부만 남고 모서리가 끊긴 것처럼 보인다.
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: VybeColors.gray700),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (thumbnailUrl.isNotEmpty)
              Image(
                image: vybeNetworkImage(
                  thumbnailUrl,
                  cacheWidth: (width.w * MediaQuery.devicePixelRatioOf(context))
                      .round(),
                ),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            if (badges.isNotEmpty)
              Positioned(
                top: 12.h,
                left: 12.w,
                right: 12.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: badges,
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _GlassInfoBar(children: info),
            ),
          ],
        ),
      ),
    );
  }
}

/// 카드 하단 정보 바 — 사진을 블러하는 유리판.
class _GlassInfoBar extends StatelessWidget {
  final List<Widget> children;

  const _GlassInfoBar({required this.children});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(14.w, 11.h, 14.w, 13.h),
          decoration: const BoxDecoration(
            // linear-gradient(180deg, rgba(14,13,18,.28), rgba(14,13,18,.66))
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x470E0D12), Color(0xA80E0D12)],
            ),
            border: Border(top: BorderSide(color: RenewGlass.hair)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: 5.h),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 카드 메타 줄 — 디자인 `home.jsx > CardMeta`.
///
/// `[핀] 0.4km · 홍대 · 힙합` — **거리가 맨 앞**이다.
/// 좌표가 없는 클럽은 거리를 빼고 지역부터 그린다(수천 km 가 찍히면 안 된다).
class VybeHomeCardMeta extends StatelessWidget {
  final double? distanceKm;
  final String area;
  final String genre;

  const VybeHomeCardMeta({
    super.key,
    required this.area,
    required this.genre,
    this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    final style = VybeTypography.caption.copyWith(color: VybeColors.gray300);

    return Row(
      children: [
        if (distanceKm != null) ...[
          Icon(Icons.place_outlined, size: 11.r, color: VybeColors.gray300),
          SizedBox(width: 3.w),
          Text('${distanceKm!.toStringAsFixed(1)}km', style: style),
          const VybeMetaDot(),
        ],
        Text(area, style: style),
        const VybeMetaDot(),
        Flexible(
          child: Text(
            genre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: VybeTypography.caption.copyWith(color: VybeColors.gray400),
          ),
        ),
      ],
    );
  }
}
