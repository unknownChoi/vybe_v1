import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/inquiry_model.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_button.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_fade_in_up.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';
import 'package:vybe/presentation/support/viewmodels/inquiry_viewmodel.dart';
import 'package:vybe/presentation/support/widgets/inquiry_detail_cards.dart';

// ============================================================
// 문의 상세 (디자인 `SupDetailScreen`)
//
// 목록에서 받은 모델을 그대로 쓴다 — **재조회 0회**. 다만 목록 스트림에서 같은
// 문서를 다시 찾아 덮어쓰므로, 보고 있는 동안 답변이 등록되면 화면이 바로 바뀐다.
// ============================================================

class InquiryDetailScreen extends ConsumerStatefulWidget {
  final InquiryModel inquiry;

  const InquiryDetailScreen({super.key, required this.inquiry});

  @override
  ConsumerState<InquiryDetailScreen> createState() =>
      _InquiryDetailScreenState();
}

class _InquiryDetailScreenState extends ConsumerState<InquiryDetailScreen> {
  /// 답변 확인 기록은 화면당 한 번만 — 스트림이 갱신될 때마다 쓰면 안 된다.
  bool _readMarked = false;

  @override
  void initState() {
    super.initState();
    _markReadIfNeeded(widget.inquiry);
  }

  void _markReadIfNeeded(InquiryModel inquiry) {
    if (_readMarked || !inquiry.hasUnreadAnswer) return;
    _readMarked = true;
    // 화면을 막지 않는다 — 실패해도 배지가 다음에 다시 뜰 뿐이다.
    ref.read(inquiryActionsProvider.notifier).markAnswerRead(inquiry.inquiryId);
  }

  @override
  Widget build(BuildContext context) {
    // 목록 스트림에 같은 문서가 있으면 그쪽이 최신이다(답변이 방금 달렸을 수 있다).
    final live = ref
        .watch(myInquiriesProvider)
        .value
        ?.where((i) => i.inquiryId == widget.inquiry.inquiryId)
        .firstOrNull;
    final inquiry = live ?? widget.inquiry;
    _markReadIfNeeded(inquiry);

    const pad = RenewGlass.pagePad;

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: VybeAurora()),
          Column(
            children: [
              const VybePushHeader(title: '문의 상세'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(pad.w, 20.h, pad.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      VybeFadeInUp(index: 0, child: InquiryQuestionCard(inquiry: inquiry)),
                      SizedBox(height: 24.h),
                      VybeFadeInUp(
                        index: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2.w, bottom: 12.h),
                              child: Text(
                                '운영자 답변',
                                style: VybeTypography.button2.copyWith(
                                  color: RenewGlass.t4,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            inquiry.isAnswered
                                ? InquiryAnswerCard(inquiry: inquiry)
                                : const InquiryWaitingCard(),
                          ],
                        ),
                      ),
                      if (inquiry.isAnswered) ...[
                        SizedBox(height: 16.h),
                        const RenewFooterNote(
                          text: '답변 내용에 궁금한 점이 남았다면 같은 유형으로 다시 문의해 주세요.',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              MyBottomBar(
                child: RenewButton(
                  label: '목록으로',
                  onTap: () => Navigator.of(context).maybePop(),
                  variant: RenewButtonVariant.quiet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
