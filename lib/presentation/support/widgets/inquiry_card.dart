import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/inquiry_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/common/widgets/vybe_meta_dot.dart';
import 'package:vybe/presentation/support/support_models.dart';
import 'package:vybe/presentation/support/widgets/support_parts.dart';

/// 내 문의 1건 카드 (디자인 `SupCard`) — 유형 태그 · 상태 뱃지 · 제목 2줄 · 메타 줄.
///
/// 답변이 왔는데 아직 안 봤으면 상태 뱃지 앞에 점을 찍는다. 이 앱에는 푸시가
/// 없어 **이 점과 마이페이지 배지가 답변 도착을 알리는 유일한 경로**다
/// (디자인엔 없는 요소 — 디자인은 앱 알림이 있다는 전제로 그려졌다).
class InquiryCard extends StatefulWidget {
  final InquiryModel inquiry;
  final VoidCallback onTap;

  const InquiryCard({super.key, required this.inquiry, required this.onTap});

  @override
  State<InquiryCard> createState() => _InquiryCardState();
}

class _InquiryCardState extends State<InquiryCard> {
  bool _down = false;

  void _setDown(bool v) {
    if (v != _down) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final inquiry = widget.inquiry;
    final category = InquiryCategory.fromKey(inquiry.category);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setDown(true),
      onTapUp: (_) => _setDown(false),
      onTapCancel: () => _setDown(false),
      behavior: HitTestBehavior.opaque,
      child: RenewGlassCard(
        quiet: true,
        // 누름 상태만 채움·테두리를 올린다 (디자인 down 상태).
        fill: _down ? const Color(0x33787880) : null,
        border: _down ? RenewGlass.cardBorder : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InquiryTypeTag(category: category),
                const Spacer(),
                if (inquiry.hasUnreadAnswer) ...[
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: const BoxDecoration(
                      color: VybeColors.mainLime500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                ],
                InquiryStatusBadge(answered: inquiry.isAnswered),
              ],
            ),
            SizedBox(height: 11.h),
            Text(
              inquiry.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: VybeTypography.body3.copyWith(
                fontWeight: FontWeight.w600,
                height: 22 / 16,
                color: RenewGlass.t1,
              ),
            ),
            SizedBox(height: 9.h),
            _MetaRow(inquiry: inquiry),
          ],
        ),
      ),
    );
  }
}

/// `2026.09.05 · 🖼 2 · 답변 2026.09.06   >` 한 줄.
class _MetaRow extends StatelessWidget {
  final InquiryModel inquiry;

  const _MetaRow({required this.inquiry});

  @override
  Widget build(BuildContext context) {
    final photos = inquiry.imageUrls.length;

    return Row(
      children: [
        // 메타 묶음이 남는 폭을 다 먹어야 꺾쇠가 오른쪽 끝에 붙는다.
        Expanded(
          child: Row(
            children: [
              Text(
                inquiry.dateLabel,
                style: RenewGlass.caption(lineHeight: 14),
              ),
              if (photos > 0) ...[
                const VybeMetaDot(),
                const RenewIcon(
                  path: RenewIcons.image,
                  size: 11,
                  color: RenewGlass.t4,
                  strokeWidth: 1.8,
                ),
                SizedBox(width: 3.w),
                Text('$photos', style: RenewGlass.caption(lineHeight: 14)),
              ],
              // 답변일은 답변이 실제로 달렸을 때만 — 상태만 answered 이고 날짜가
              // 비어 있으면(콘솔에서 손으로 채운 문서) '답변 ' 뒤가 빈칸으로 남는다.
              if (inquiry.isAnswered &&
                  inquiry.answeredDateLabel.isNotEmpty) ...[
                const VybeMetaDot(),
                Flexible(
                  child: Text(
                    '답변 ${inquiry.answeredDateLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: RenewGlass.caption(
                      color: RenewGlass.lavender,
                      lineHeight: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: 6.w),
        const RenewChevron(
          dir: RenewChevronDir.right,
          size: 15,
          color: Color(0x52FFFFFF), // rgba(255,255,255,0.32)
        ),
      ],
    );
  }
}
