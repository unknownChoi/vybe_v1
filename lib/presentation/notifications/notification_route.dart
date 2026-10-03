import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/core/navigation/swipe_back_page_route.dart';
import 'package:vybe/presentation/clubs/club_detail_route.dart';
import 'package:vybe/presentation/clubs/review_write_screen.dart';
import 'package:vybe/presentation/common/v1/v1_placeholder_screen.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/my_page/my_reviews_screen.dart';
import 'package:vybe/presentation/my_page/notices_screen.dart';
import 'package:vybe/presentation/notifications/notification_item.dart';
import 'package:vybe/presentation/notifications/viewmodels/notification_viewmodel.dart';

/// 검색 탭 순서 (MainScaffold 홈·주변·패스·검색·마이).
const int _kSearchTabIndex = 3;

/// 아직 만들지 않은 화면의 이름 — 자리표시 상단바에 쓴다.
/// 값은 `docs/screen_map.md` 의 화면 이름 그대로다.
const _kPlaceholderNames = <String, String>{
  'WAIT-044': '웨이팅 티켓',
  'RSV-052': '예약 완료',
  'PASS-035': '패스월렛',
  'PASS-036': '예약 티켓',
  'ORDER-063': '주문 상태',
  'ORDER-067': '패스월렛 · 주문 탭',
  'SHARE-079': '입장권 공유',
  'FEE-069': '입장비 결제',
};

/// 알림 카드를 눌렀을 때 — **읽음 처리 + 이동** (디자인 `NGRow` 의 `onClick`).
///
/// 이동 목적지는 설계 10장 알림 유형 표의 '이동 화면'(`data.route`)이다.
/// 이미 있는 화면은 실제 화면으로, 아직 없는 화면은 [V1PlaceholderScreen] 으로
/// 보낸다(진행 기록 「임시 연결」 목록).
///
/// ⚠ 읽음 처리를 **먼저** 한다 — 이동 뒤에 하면 돌아왔을 때까지 배지가 남는다.
Future<void> openNotification(
  BuildContext context,
  WidgetRef ref,
  NotificationItem noti,
) async {
  if (!noti.read) {
    await ref.read(notificationActionsProvider).markRead(noti.id);
  }
  if (!context.mounted) return;

  switch (noti.route) {
    case 'CLUB-021':
      if (noti.clubId.isEmpty) return;
      await openClubDetail(context, noti.clubId);
    case 'CLUB-028':
      if (noti.clubId.isEmpty) return;
      await ReviewWriteScreen.push(context, ref, clubId: noti.clubId);
    case 'HOME-008':
      await Navigator.of(context).push<void>(
        SwipeBackPageRoute(builder: (_) => const NoticesScreen()),
      );
    case 'MY-031':
      await Navigator.of(context).push<void>(
        SwipeBackPageRoute(builder: (_) => const MyReviewsScreen()),
      );
    case 'HOME-006':
      // 검색 결과(HOME-006)는 검색어가 있어야 열린다. 프로모션 알림엔 검색어가
      // 없어 그 윗 화면인 검색 탭으로 보낸다(권장안 — 진행 기록 결정 ⓗ).
      Navigator.of(context).popUntil((r) => r.isFirst);
      ref.read(tabSwitchRequestProvider.notifier).request(_kSearchTabIndex);
    case '':
      return;
    default:
      await V1PlaceholderScreen.push(
        context,
        screenId: noti.route,
        name: _kPlaceholderNames[noti.route] ?? '준비 중인 화면',
      );
  }
}
