import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_thumb.dart';
import 'package:vybe/presentation/common/widgets/vybe_section_head.dart';
import 'package:vybe/presentation/free_entry/free_entry_models.dart';
import 'package:vybe/presentation/free_entry/free_entry_style.dart';
import 'package:vybe/presentation/free_entry/widgets/free_entry_parts.dart';

/// 3섹션 · '조건이 맞으면 무료' — 상시 무료 클럽 가로 레일 (FeCondSection).
///
/// 조건은 `freeEntry.condition` **한 줄**이다 — 디자인은 조건 두 줄을 그리지만
/// Firestore 엔 문구 하나뿐이라 한 줄만 그린다(없는 조건을 지어내지 않는다).
class FreeEntryCondRail extends StatelessWidget {
  /// 가까운 순으로 정렬된 상시 무료 클럽.
  final List<FreeEntryClub> clubs;
  final ValueChanged<FreeEntryClub> onTap;

  const FreeEntryCondRail({
    super.key,
    required this.clubs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VybeSectionHead(
          title: '조건이 맞으면 무료',
          sub: '${clubs.length}곳 · 클럽마다 조건이 달라요',
        ),
        FreeEntryRail(
          // 헤더 70 + 조건 박스(≈66) + 아래 여백 13.
          height: 152,
          gap: 10,
          itemCount: clubs.length,
          itemBuilder: (_, i) =>
              _CondCard(club: clubs[i], onTap: () => onTap(clubs[i])),
        ),
      ],
    );
  }
}

class _CondCard extends StatelessWidget {
  final FreeEntryClub club;
  final VoidCallback onTap;

  const _CondCard({required this.club, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 258.w,
        child: RenewGlassCard(
          quiet: true,
          padding: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(13.w, 13.h, 13.w, 11.h),
                child: Row(
                  children: [
                    VybeClubThumb(
                      url: club.thumbnailUrl,
                      gradient: club.gradient,
                      size: 46,
                      radius: 12,
                      border: RenewGlass.hair,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    SizedBox(width: 11.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  club.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: RenewGlass.caption(
                                    color: Colors.white,
                                    size: 15,
                                    lineHeight: 18,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              FreeEntryOpenPill(open: club.open),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          freeEntryMeta(size: 11, [
                            '${club.area} · ${club.dist.toStringAsFixed(1)}km',
                            club.genre,
                            club.rating.toStringAsFixed(2),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(13.w, 0, 13.w, 13.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
                decoration: BoxDecoration(
                  color: kEntryBaseSoft,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: kEntryBaseLine),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이 조건이면 입장비 무료',
                      style: RenewGlass.caption(
                        color: kEntryLavender,
                        size: 10.5,
                        lineHeight: 11,
                        weight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Icon(
                            Icons.check_rounded,
                            size: 13.r,
                            color: kEntryPoint,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Expanded(
                          child: Text(
                            club.cond,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: RenewGlass.body(
                              color: RenewGlass.t2,
                              lineHeight: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
