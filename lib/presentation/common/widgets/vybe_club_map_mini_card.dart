import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_thumb.dart';
import 'package:vybe/presentation/common/widgets/vybe_save_button.dart';

/// 지도에서 고른 클럽 한 줄 (디자인 `MapMini`) — 지도 하단에 떠 있는 미니 카드.
///
/// 디자인의 `걸어서 n분`은 뺐다 — 도보 시간 데이터가 없어 거리에서 역산하면
/// 지어낸 값이 된다. 앱의 다른 카드와 같이 `지역 · N.Nkm`만 쓴다.
class VybeClubMapMiniCard extends StatelessWidget {
  final ClubModel club;

  /// 내 위치 기준 거리(km).
  final double dist;

  final bool saved;
  final VoidCallback onSave;

  final VoidCallback onTap;

  /// 테두리·별 색. 화면 포인트 색을 넘긴다.
  final Color accent;

  const VybeClubMapMiniCard({
    super.key,
    required this.club,
    required this.dist,
    required this.saved,
    required this.onSave,
    required this.onTap,
    this.accent = VybeColors.mainLime500,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14.r);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: VybeColors.background.withValues(alpha: 0.92),
          borderRadius: radius,
          border: Border.all(color: accent.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Row(
          children: [
            VybeClubThumb(
              url: club.thumbnailUrl,
              gradient: vybeClubGradFor(club.clubId),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: _Body(club: club, dist: dist, accent: accent),
            ),
            SizedBox(width: 8.w),
            VybeSaveButton(
              saved: saved,
              onTap: onSave,
              iconSize: 15,
              fill: Colors.white.withValues(alpha: 0.07),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ClubModel club;
  final double dist;
  final Color accent;
  const _Body({required this.club, required this.dist, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                club.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16.sp,
                  height: 18 / 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.star_rounded, size: 11.r, color: accent),
            SizedBox(width: 2.w),
            Text(
              club.rating.toStringAsFixed(2),
              style: VybeTypography.caption.copyWith(
                fontSize: 11.sp,
                height: 12 / 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            Icon(Icons.place_rounded, size: 11.r, color: VybeColors.gray400),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                '${club.area} · ${dist.toStringAsFixed(1)}km',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: VybeTypography.caption.copyWith(
                  fontSize: 11.sp,
                  height: 12 / 11,
                  fontWeight: FontWeight.w600,
                  color: VybeColors.gray400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
