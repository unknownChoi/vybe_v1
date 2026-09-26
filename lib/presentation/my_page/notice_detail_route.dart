import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/clubs/widgets/club_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_button.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_hide_route.dart';
import 'package:vybe/presentation/my_page/notice_detail_screen.dart';
import 'package:vybe/presentation/my_page/viewmodels/notice_viewmodel.dart';

/// 공지 상세를 **noticeId만으로** 여는 진입점 (홈 배너 → 광고 공지).
///
/// 공지 목록에서 탭할 때는 이미 받아 둔 모델을 그대로 넘기므로
/// [NoticeDetailScreen]을 직접 쓴다 — 그 경로는 조회가 0회다.
/// 배너는 모델이 없어 여기서 문서 1건을 조회한 뒤 같은 화면을 띄운다.
///
/// 광고 페이지는 전체화면이라 [pushHidingNavBar]로 열어 하단 nav 바를 내린다.
Future<void> openNoticeDetail(BuildContext context, String noticeId) {
  return pushHidingNavBar<void>(context, NoticeDetailById(noticeId: noticeId));
}

/// noticeId로 조회해 [NoticeDetailScreen]을 띄우는 껍데기.
class NoticeDetailById extends ConsumerWidget {
  final String noticeId;

  const NoticeDetailById({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(noticeProvider(noticeId));

    return async.when(
      loading: () => const _Shell(child: _NoticeDetailSkeleton()),
      error: (_, __) => _Shell(child: _message('공지를 불러오지 못했어요')),
      // 게시 종료·게시중단·삭제된 공지도 null — 배너가 남아 있어도 빈 화면은 안 나온다.
      data: (notice) => notice == null
          ? _Shell(child: _message('종료되었거나 찾을 수 없는 공지예요'))
          : NoticeDetailScreen(notice: notice),
    );
  }
}

/// 로딩·오류 상태용 껍데기 — 뒤로가기는 어느 상태에서도 떠 있어야 한다.
class _Shell extends StatelessWidget {
  final Widget child;

  const _Shell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClubGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: VybeAurora()),
          child,
          Positioned(
            top: MediaQuery.paddingOf(context).top + 6.h,
            left: 12.w,
            child: VybeGlassButton(
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _message(String text) => VybeStateMessage(
  text,
  padding: EdgeInsets.symmetric(horizontal: 40.w),
  color: ClubGlass.t3,
);

/// [NoticeDetailScreen] 골격 — 배지 행 → 제목 2줄 → 날짜 → 본문 4줄 → 첨부 이미지.
/// 배너를 누를 때마다 문서 1건을 새로 읽으므로 매번 보이는 자리다.
class _NoticeDetailSkeleton extends StatelessWidget {
  const _NoticeDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    // 상세 화면의 상단바(세이프에어리어 + 8 + 38 + 12) 아래부터 같은 여백.
    final top = MediaQuery.paddingOf(context).top + 58.h;
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, top + 22.h, 20.w, 30.h),
      children: [
        VybeSkel(width: 52.w, height: 20.h, radius: 999),
        SizedBox(height: 13.h),
        VybeSkel(width: 240.w, height: 22.h),
        SizedBox(height: 6.h),
        VybeSkel(width: 180.w, height: 22.h),
        SizedBox(height: 14.h),
        VybeSkel(width: 90.w, height: 12.h),
        SizedBox(height: 20.h),
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) SizedBox(height: 8.h),
          VybeSkel(height: 14.h, widthFactor: i == 3 ? 0.6 : null),
        ],
        SizedBox(height: 16.h),
        VybeSkel(height: 200.h, radius: 14, logo: true),
      ],
    );
  }
}
