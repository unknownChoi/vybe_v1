import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/inquiry_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/common/widgets/vybe_photo_viewer.dart';
import 'package:vybe/presentation/support/support_models.dart';
import 'package:vybe/presentation/support/widgets/support_parts.dart';

/// 문의 상세 화면의 카드 3장 (디자인 `SupDetailScreen`) — 내 문의 · 운영자 답변 · 답변 대기.

/// 카드 안 구분선 — 위아래 16 여백 (디자인 `margin: SP.lg 0`). 16 + 1 + 16.
Widget _hairline() =>
    Divider(height: 32.h + 1, thickness: 1, color: RenewGlass.hair);

/// 내가 보낸 문의 — 유형·상태·제목·작성일·본문·첨부 사진.
class InquiryQuestionCard extends StatelessWidget {
  final InquiryModel inquiry;

  const InquiryQuestionCard({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    final category = InquiryCategory.fromKey(inquiry.category);

    return RenewGlassCard(
      quiet: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InquiryTypeTag(category: category),
              const Spacer(),
              InquiryStatusBadge(answered: inquiry.isAnswered),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            inquiry.title,
            style: VybeTypography.heading4.copyWith(
              fontSize: 19.sp,
              height: 26 / 19,
              color: RenewGlass.t1,
            ),
          ),
          SizedBox(height: 9.h),
          Text(
            '${inquiry.dateLabel} 작성',
            style: RenewGlass.caption(lineHeight: 14),
          ),
          _hairline(),
          Text(
            inquiry.content,
            style: RenewGlass.body(color: RenewGlass.t2, lineHeight: 23),
          ),
          if (inquiry.imageUrls.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Text(
              '첨부 사진 ${inquiry.imageUrls.length}장',
              style: RenewGlass.caption(lineHeight: 14),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 72.r,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: inquiry.imageUrls.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (context, i) => InquiryPhotoThumb(
                  url: inquiry.imageUrls[i],
                  onTap: () => VybePhotoViewer.open(
                    context,
                    imageUrls: inquiry.imageUrls,
                    initialIndex: i,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 운영자 답변 (디자인 `SupAnswerCard`) — 좌상단 보라 글로우가 깔린 글래스 카드.
class InquiryAnswerCard extends StatelessWidget {
  final InquiryModel inquiry;

  const InquiryAnswerCard({super.key, required this.inquiry});

  @override
  Widget build(BuildContext context) {
    return RenewGlassCard(
      // 글로우가 카드 안쪽 여백까지 덮어야 해서 여백은 카드가 아니라 안에서 준다.
      padding: 0,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.84, -1),
                  radius: 1.1,
                  colors: [
                    Color(0x3D7731FE), // rgba(119,49,254,0.24)
                    Color(0x007731FE),
                  ],
                  stops: [0, 0.62],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _OperatorAvatar(),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'vybe 운영팀',
                            style: VybeTypography.button1.copyWith(
                              color: RenewGlass.t1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (inquiry.answeredDateLabel.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              '${inquiry.answeredDateLabel} 답변',
                              style: RenewGlass.caption(lineHeight: 15),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    const InquiryStatusBadge(answered: true),
                  ],
                ),
                _hairline(),
                Text(
                  inquiry.answer,
                  style: RenewGlass.body(color: RenewGlass.t2, lineHeight: 23),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 운영팀 아바타 — 보라 그라데이션 원 + 헤드셋.
class _OperatorAvatar extends StatelessWidget {
  const _OperatorAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.r,
      height: 38.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment(-0.5, -1),
          end: Alignment(0.5, 1),
          colors: [
            Color(0xFF8B52FF),
            VybeColors.mainPurple500,
            VybeColors.mainPurple900,
          ],
          stops: [0, 0.48, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: VybeColors.mainPurple500.withValues(alpha: 0.42),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: const RenewIcon(
        path: RenewIcons.headset,
        size: 19,
        color: Colors.white,
        strokeWidth: 1.9,
      ),
    );
  }
}

/// 답변 대기 안내 (디자인 `SupWaitCard`).
class InquiryWaitingCard extends StatelessWidget {
  const InquiryWaitingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RenewGlassCard(
      quiet: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RenewGlass.tileFill,
              border: Border.all(color: RenewGlass.tileBorder),
            ),
            child: const RenewIcon(
              path: RenewIcons.clock,
              size: 18,
              color: VybeColors.gray400,
              strokeWidth: 1.8,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '답변을 준비하고 있어요',
                  style: VybeTypography.body3.copyWith(
                    color: RenewGlass.t1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  // 디자인은 '앱 알림으로 알려드립니다'까지 말하지만 이 앱엔 푸시가
                  // 없다 — 실제로 답변이 도착하는 자리(이 화면·목록)만 안내한다.
                  '$kInquiryAnswerSla 안에 답변드려요. 답변이 등록되면 이 화면에 바로 표시돼요.',
                  style: RenewGlass.caption(
                    color: RenewGlass.t3,
                    lineHeight: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
