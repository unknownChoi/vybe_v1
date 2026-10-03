import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/clubs/widgets/club_glass.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_meta_dot.dart';
import 'package:vybe/presentation/common/widgets/vybe_save_button.dart';
import 'package:vybe/presentation/saved/viewmodels/saved_viewmodel.dart';
import 'package:vybe/presentation/saved/widgets/saved_thumb.dart';

// 찜 리스트 뷰 카드.

class SavedListCard extends StatelessWidget {
  final SavedEntry entry;
  final ValueChanged<String> onUnsave;

  const SavedListCard({super.key, required this.entry, required this.onUnsave});

  @override
  Widget build(BuildContext context) {
    final club = entry.club;

    return GestureDetector(
      onTap: () => openClubDetail(context, club.clubId),
      behavior: HitTestBehavior.opaque,
      // 카드 뒤는 정적 오로라라 블러 없이도 같아 보인다 — 목록마다 백드롭 비용만 아낀다.
      child: RenewGlassCard(
        sheen: true,
        padding: 12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SavedThumb(entry: entry, size: 92, radius: 14),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    letterSpacing: 16 * -0.025,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      VybeSaveButton(
                        saved: true,
                        onTap: () => onUnsave(club.clubId),
                        size: 30,
                        iconSize: 15,
                        fill: RenewGlass.tileFill,
                        border: RenewGlass.tileBorder,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          size: 12.r, color: VybeColors.mainLime500),
                      SizedBox(width: 5.w),
                      Text(
                        club.rating.toStringAsFixed(2),
                        style: ClubGlass.caption(
                          color: Colors.white,
                          weight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 9.h,
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        color: const Color(0x33FFFFFF),
                      ),
                      Flexible(
                        child: Text(
                          club.area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ClubGlass.caption(),
                        ),
                      ),
                      const VybeMetaDot(size: 2, color: RenewGlass.t4),
                      Flexible(
                        child: Text(
                          club.genre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ClubGlass.caption(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  _SavedOpenHoursPill(isOpen: entry.isOpen, hours: entry.hoursLabel),
                  SizedBox(height: 6.h),
                  Text(
                    entry.savedAtLabel,
                    style: ClubGlass.caption(color: ClubGlass.t4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 영업 상태 + 마감/오픈 시각을 한 pill 안에 담는다 (찜 리스트 전용).
class _SavedOpenHoursPill extends StatelessWidget {
  final bool isOpen;
  final String hours;

  const _SavedOpenHoursPill({required this.isOpen, required this.hours});

  @override
  Widget build(BuildContext context) {
    final accent = isOpen ? VybeColors.mainLime500 : ClubGlass.t4;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isOpen
            ? VybeColors.mainLime500.withValues(alpha: 0.13)
            : const Color(0x0FFFFFFF),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: isOpen
              ? VybeColors.mainLime500.withValues(alpha: 0.28)
              : RenewGlass.cardBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              color: isOpen ? VybeColors.mainLime500 : const Color(0x59FFFFFF),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            isOpen ? '영업중' : '영업종료',
            style: ClubGlass.caption(
              color: accent,
              lineHeight: 13,
              weight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              hours,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ClubGlass.caption(lineHeight: 13),
            ),
          ),
        ],
      ),
    );
  }
}
