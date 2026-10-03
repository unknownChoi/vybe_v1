import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/datasources/fake/fake_notification_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/operating_hours.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/presentation/clubs/review_write_screen.dart';
import 'package:vybe/presentation/clubs/viewmodels/club_detail_viewmodel.dart';
import 'package:vybe/presentation/notifications/notification_item.dart';
import 'package:vybe/presentation/notifications/notification_route.dart';

/// HOME-007 알림 — 읽음 처리가 홈 배지를 줄이는지, 리뷰 요청 알림이 CLUB-028 로
/// 가는지. 둘 다 이번 작업의 알맹이다(차이 #3 · #4).

ClubModel _club() => ClubModel(
  clubId: 'c1',
  name: '어썸레드',
  description: '',
  address: '서울 마포구 잔다리로 12',
  area: '홍대',
  phone: '',
  instagramUrl: '',
  lat: 37.55,
  lng: 126.92,
  geohash: 'wydm',
  genre: '힙합',
  rating: 4.8,
  reviewCount: 10,
  operatingHours: const OperatingHours(),
  entryFeeMin: 0,
  entryFeeMax: 0,
  imageUrls: const [],
  thumbnailUrl: '',
  tags: const [],
  favoriteCount: 0,
  isActive: true,
  isVybeRecommended: false,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

NotificationItem _reviewNoti() => NotificationItem.from(
  AppNotificationModel(
    notificationId: 'n_review_request',
    type: 'review_request',
    category: NotificationCategory.review,
    title: '다녀온 클럽은 어땠나요?',
    body: '별점과 한 줄 후기를 남겨보세요.',
    data: const {'route': 'CLUB-028', 'clubId': 'c1'},
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  now: DateTime.now(),
);

void main() {
  tearDown(() => fakeScenario.value = FakeScenario.normal);

  group('Fake — 읽음 처리가 배지를 줄인다', () {
    test('1건 읽으면 안 읽은 수가 하나 줄어든다', () async {
      final ds = FakeNotificationDataSource();
      final counts = <int>[];
      final sub = ds.watchUnreadCount('u1').listen(counts.add);

      final items = await ds.watchNotifications('u1').first;
      final unread = items.firstWhere((n) => !n.read);
      await ds.markRead('u1', unread.notificationId);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      // 디자인 NG_NOTIS 의 안 읽은 3건 → 하나 읽으면 2건.
      expect(counts.first, 3);
      expect(counts.last, 2);
      await sub.cancel();
    });

    test('모두 읽음이면 0 — 목록과 배지가 같은 샘을 본다', () async {
      final ds = FakeNotificationDataSource();
      await ds.markAllRead('u1');
      expect(await ds.watchUnreadCount('u1').first, 0);
      final items = await ds.watchNotifications('u1').first;
      expect(items.every((n) => n.read), isTrue);
    });

    test('빈 상태 0건 · 만료 12건 — 개발 메뉴 시나리오', () async {
      final ds = FakeNotificationDataSource();

      fakeScenario.value = FakeScenario.empty;
      expect(await ds.watchNotifications('u1').first, isEmpty);
      expect(await ds.watchUnreadCount('u1').first, 0);

      fakeScenario.value = FakeScenario.expired;
      expect(await ds.watchUnreadCount('u1').first, 12);
    });
  });

  group('알림 탭 → 이동', () {
    testWidgets('리뷰 요청 알림은 CLUB-028 리뷰 작성으로 간다', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      late WidgetRef capturedRef;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUidProvider.overrideWithValue('u1'),
            clubDetailProvider('c1').overrideWith((ref) async => _club()),
          ],
          child: ScreenUtilInit(
            designSize: const Size(393, 852),
            builder: (_, __) => MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  capturedRef = ref;
                  return TextButton(
                    onPressed: () =>
                        openNotification(context, ref, _reviewNoti()),
                    child: const Text('열기'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();

      expect(find.byType(ReviewWriteScreen), findsOneWidget);
      expect(capturedRef, isNotNull);
    });
  });
}
