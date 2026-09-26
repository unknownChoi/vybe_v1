import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/navigation/swipe_back_page_route.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/models/inquiry_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_fade_in_up.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/common/widgets/vybe_toast.dart';
import 'package:vybe/presentation/support/inquiry_detail_screen.dart';
import 'package:vybe/presentation/support/inquiry_write_screen.dart';
import 'package:vybe/presentation/support/support_models.dart';
import 'package:vybe/presentation/support/viewmodels/inquiry_viewmodel.dart';
import 'package:vybe/presentation/support/widgets/inquiry_card.dart';
import 'package:vybe/presentation/support/widgets/inquiry_states.dart';
import 'package:vybe/presentation/support/widgets/inquiry_tabs.dart';

// ============================================================
// 고객센터 — 내 문의 목록 (디자인 `support.jsx` SupListScreen)
//
// 목록은 스트림이라 운영자가 답변을 달면 이 화면이 바로 '답변 완료'로 바뀐다.
// 이 앱에는 푸시가 없어 답변 도착을 알리는 경로는 이 목록과 마이페이지 배지뿐이다.
// ============================================================

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  InquiryTab _tab = InquiryTab.all;

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUidProvider);
    final inquiriesAsync = ref.watch(myInquiriesProvider);
    final items = uid == null ? null : inquiriesAsync.value;

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      // 키보드가 없는 화면이라 리사이즈가 필요 없다.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: VybeAurora()),
          Column(
            children: [
              VybePushHeader(
                title: '문의 내역',
                // 건수는 목록을 받아온 뒤에만 — 로딩 중 '0건'을 먼저 보여 주면
                // 문의가 없는 것처럼 읽힌다.
                trailing: items == null
                    ? null
                    : Text(
                        '${items.length}건',
                        style: RenewGlass.caption(lineHeight: 14),
                      ),
              ),
              if (uid != null)
                InquiryTabs(
                  selected: _tab,
                  onSelect: (t) => setState(() => _tab = t),
                  counts: {
                    for (final tab in InquiryTab.values)
                      tab: tab.filter(items ?? const []).length,
                  },
                ),
              Expanded(child: _body(uid, inquiriesAsync)),
            ],
          ),
          if (uid != null)
            _WriteFab(
              onTap: () => _openWrite(uid, inquiriesAsync),
            ),
        ],
      ),
    );
  }

  Widget _body(String? uid, AsyncValue<List<InquiryModel>> async) {
    if (uid == null) {
      return const SingleChildScrollView(
        child: InquiriesEmpty(
          icon: RenewIcons.lock,
          title: '로그인 후 이용할 수 있어요',
          description: '문의 내용과 답변을 계정에 안전하게 보관하기 위해\n로그인이 필요해요',
        ),
      );
    }

    return async.when(
      loading: () => const SingleChildScrollView(child: InquiriesSkeleton()),
      error: (_, __) => SingleChildScrollView(
        child: VybeStateMessage(
          '문의 내역을 불러오지 못했어요',
          padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
          color: RenewGlass.t3,
          lineHeight: 20,
        ),
      ),
      data: (all) {
        final list = _tab.filter(all);
        if (list.isEmpty) return SingleChildScrollView(child: _empty(all));
        return _list(list);
      },
    );
  }

  /// 빈 상태 문구는 탭마다 다르다 — '답변 완료' 탭에서 '아직 보낸 문의가 없어요'는
  /// 거짓말이 된다(보낸 문의는 있는데 답변이 안 왔을 뿐).
  Widget _empty(List<InquiryModel> all) {
    if (all.isEmpty) {
      return const InquiriesEmpty(
        title: '아직 보낸 문의가 없어요',
        description: '이용 중 불편하거나 궁금한 점이 있으면\n언제든 문의를 남겨주세요',
      );
    }
    return InquiriesEmpty(
      title: _tab == InquiryTab.answered
          ? '답변 완료된 문의가 없어요'
          : '답변을 기다리는 문의가 없어요',
      description: '문의하면 $kInquiryAnswerSla 안에 답변드려요',
    );
  }

  Widget _list(List<InquiryModel> list) {
    const pad = RenewGlass.pagePad;
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(pad.w, 16.h, pad.w, 124.h),
      // 마지막 한 칸은 안내 문구 — 목록 뒤에 붙는다.
      itemCount: list.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, i) {
        if (i == list.length) {
          return Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: const RenewFooterNote(
              // 디자인 문구('답변은 앱 알림으로 안내되며')는 이 앱에 푸시가 없어
              // 못 쓴다 — 실제로 알려 주는 경로(목록·배지)를 그대로 적는다.
              text: '답변이 등록되면 이 목록에 표시돼요. 문의 내역은 작성 후 1년간 보관됩니다.',
            ),
          );
        }
        // 카드가 45ms 간격으로 순서대로 떠오른다 (공지 목록과 같은 연출).
        return VybeFadeInUp(
          index: i,
          child: InquiryCard(
            inquiry: list[i],
            onTap: () => _open(list[i]),
          ),
        );
      },
    );
  }

  /// 문의 상세. 이 화면은 이미 하단 nav 가 내려간 자리라 평범하게 push 한다
  /// (공지 목록 → 상세와 같은 규칙).
  void _open(InquiryModel inquiry) {
    Navigator.of(context).push(
      SwipeBackPageRoute<void>(
        builder: (_) => InquiryDetailScreen(inquiry: inquiry),
      ),
    );
  }

  Future<void> _openWrite(
    String uid,
    AsyncValue<List<InquiryModel>> inquiriesAsync,
  ) async {
    // 답변을 기다리는 문의가 쌓이면 새 문의를 막는다 — Rules 로는 건수를 셀 수
    // 없어 여기서만 거는 가드다(서버 제한이 필요해지면 onCall 함수로 옮긴다).
    final pending = inquiriesAsync.value?.where((i) => !i.isAnswered).length;
    if (pending != null && pending >= kInquiryPendingLimit) {
      VybeToast.show(context, message: '답변 대기 중인 문의가 많아요. 답변을 먼저 확인해주세요');
      return;
    }

    final sent = await Navigator.of(context).push<bool>(
      SwipeBackPageRoute<bool>(builder: (_) => const InquiryWriteScreen()),
    );
    if (sent == true && mounted) {
      VybeToast.show(context, message: '문의를 접수했어요');
    }
  }
}

/// 우하단 문의하기 버튼 (디자인 `SupFab`).
class _WriteFab extends StatefulWidget {
  final VoidCallback onTap;

  const _WriteFab({required this.onTap});

  @override
  State<_WriteFab> createState() => _WriteFabState();
}

class _WriteFabState extends State<_WriteFab> {
  bool _down = false;

  void _setDown(bool v) {
    if (v != _down) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      right: RenewGlass.pagePad.w,
      // 디자인 46 은 홈 인디케이터를 포함한 값 — 인디케이터가 있는 기기에서는
      // 그 위로 띄운다.
      bottom: math.max(46.h, safe + 12.h),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setDown(true),
        onTapUp: (_) => _setDown(false),
        onTapCancel: () => _setDown(false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: _down
                ? VybeColors.mainPurple700
                : VybeColors.mainPurple500,
            borderRadius: BorderRadius.circular(999.r),
            boxShadow: [
              BoxShadow(
                color: VybeColors.mainPurple500.withValues(alpha: 0.45),
                blurRadius: 30.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RenewIcon(
                path: RenewIcons.pen,
                size: 17,
                color: Colors.white,
                strokeWidth: 2,
              ),
              SizedBox(width: 8.w),
              Text(
                '문의하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  height: 1,
                  letterSpacing: 16 * -0.025,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
