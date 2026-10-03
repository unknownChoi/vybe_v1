import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/datasources/fake/fake_club_ops_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_notification_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/repositories/v1_providers.dart';
import 'package:vybe/presentation/home/widgets/home_gnb.dart';
import 'package:vybe/presentation/notifications/viewmodels/notification_viewmodel.dart';

/// Fake datasource 의 상태 전환이 실제로 다른 결과를 내는지.
///
/// UI 단계의 Fake 는 "모든 상태 변형을 재현할 수 있어야 한다"(CLAUDE.md v1 규칙).
/// 재현이 안 되면 화면의 빈 상태·마감·접수 중지를 눈으로 볼 방법이 없다.

void main() {
  // 시나리오는 전역 ValueNotifier — 테스트끼리 새지 않게 되돌린다.
  tearDown(() => fakeScenario.value = FakeScenario.normal);

  group('알림 — 안 읽은 수', () {
    test('빈 상태는 0, 기본은 3, 만료는 두 자리', () async {
      final ds = FakeNotificationDataSource();

      fakeScenario.value = FakeScenario.empty;
      expect(await ds.watchUnreadCount('u1').first, 0);

      fakeScenario.value = FakeScenario.normal;
      expect(await ds.watchUnreadCount('u1').first, 3);

      fakeScenario.value = FakeScenario.expired;
      expect(await ds.watchUnreadCount('u1').first, greaterThanOrEqualTo(10));
    });

    test('모두 읽으면 0이 된다', () async {
      final ds = FakeNotificationDataSource();
      expect(await ds.watchUnreadCount('u1').first, 3);

      await ds.markAllRead('u1');
      expect(await ds.watchUnreadCount('u1').first, 0);
    });

    test('토글은 같은 인스턴스에 남는다 — 화면을 닫았다 열어도 유지', () async {
      final ds = FakeNotificationDataSource();
      final before = await ds.getSettings('u1');
      // 설계 4장 기본값 — 네 개 모두 true.
      expect(before.toMap().values, everyElement(isTrue));

      await ds.updateSettings('u1', before.toggled('review'));
      expect((await ds.getSettings('u1')).review, isFalse);
      // 건드리지 않은 키는 그대로.
      expect((await ds.getSettings('u1')).push, isTrue);
    });
  });

  group('클럽 운영 상태 — 대기 팀 수', () {
    const clubIds = ['club_a', 'club_b', 'club_c', 'club_d', 'club_e'];

    test('빈 상태면 아무 클럽도 안 돌려준다 (= 웨이팅 정보를 모른다)', () async {
      fakeScenario.value = FakeScenario.empty;
      final ops = await FakeClubOpsDataSource()
          .watchOpsLiveMany(clubIds)
          .first;
      expect(ops, isEmpty);
    });

    test('기본은 일부 클럽만 운영 중이고 대기 수가 서로 다르다', () async {
      final ops = await FakeClubOpsDataSource()
          .watchOpsLiveMany(clubIds)
          .first;

      // 전부도 아니고 0도 아니다 — 지도에서 같은 숫자가 164개 붙으면 안 된다.
      expect(ops, isNotEmpty);
      expect(ops.length, lessThan(clubIds.length));
      expect(
        ops.values.map((l) => l.waiting.waitingCount).toSet().length,
        greaterThan(1),
      );
      expect(ops.values.every((l) => l.waiting.accept), isTrue);
    });

    test('같은 clubId 는 늘 같은 대기 수 — 화면을 다시 열어도 안 흔들린다', () async {
      final a = await FakeClubOpsDataSource().watchOpsLiveMany(clubIds).first;
      final b = await FakeClubOpsDataSource().watchOpsLiveMany(clubIds).first;
      expect(
        a.map((k, v) => MapEntry(k, v.waiting.waitingCount)),
        b.map((k, v) => MapEntry(k, v.waiting.waitingCount)),
      );
    });

    test('잠김은 접수 중지, 마감은 영업 종료 + 접수 마감', () async {
      final ds = FakeClubOpsDataSource();

      fakeScenario.value = FakeScenario.locked;
      final locked = await ds.watchOpsLive('club_a').first;
      expect(locked!.waiting.accept, isFalse);
      expect(locked.waiting.closed, isFalse);
      expect(locked.phase, OpsPhase.open);

      fakeScenario.value = FakeScenario.closed;
      final closed = await ds.watchOpsLive('club_a').first;
      expect(closed!.waiting.closed, isTrue);
      expect(closed.phase, OpsPhase.closed);
    });

    test('상세 화면 구독은 웨이팅 미사용 클럽에서도 상태를 돌려준다', () async {
      final ds = FakeClubOpsDataSource();
      // watchOpsLiveMany 가 건너뛴 클럽이라도 단건 구독은 값이 있다.
      final many = await ds.watchOpsLiveMany(clubIds).first;
      final skipped = clubIds.firstWhere((id) => !many.containsKey(id));
      expect(await ds.watchOpsLive(skipped).first, isNotNull);
    });
  });

  group('홈 GNB 알림 배지', () {
    Future<void> pump(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [currentUidProvider.overrideWithValue('u1')],
          child: ScreenUtilInit(
            designSize: const Size(393, 852),
            builder: (context, child) => MaterialApp(home: child),
            child: const HomeGnb(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('안 읽은 알림이 있으면 점이 뜬다', (tester) async {
      await pump(tester);
      expect(_badge(tester), 1);
    });

    testWidgets('안 읽은 알림이 없으면 점이 없다', (tester) async {
      fakeScenario.value = FakeScenario.empty;
      await pump(tester);
      expect(_badge(tester), 0);
    });

    test('모두 읽음이면 배지 provider 가 0 을 다시 내보낸다 — 알림 화면과 같은 샘', () async {
      final container = ProviderContainer(
        overrides: [currentUidProvider.overrideWithValue('u1')],
      );
      addTearDown(container.dispose);

      final seen = <int>[];
      final sub = container.listen(
        unreadNotificationCountProvider,
        (_, next) {
          final v = next.value;
          if (v != null) seen.add(v);
        },
        fireImmediately: true,
      );
      addTearDown(sub.close);

      await container.read(notificationDataSourceProvider).markAllRead('u1');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 읽음 처리가 datasource 한 곳을 흔들어 홈 배지 스트림까지 다시 흐른다.
      expect(seen.last, 0);
    });

    // ⚠ '조회 중' 은 위젯 테스트로 못 본다 — loading 시나리오의 Fake 는
    // 일부러 끝나지 않아(`fakeGate` 가 1일 대기) 테스트가 타이머를 물고 죽는다.
    // 그 분기는 `(s.value ?? 0) > 0` 한 줄이라 빈 상태 테스트가 같이 덮는다.
  });
}

/// 배지 = 7×7 보라 원. 아이콘·버튼과 섞이지 않게 색·모양으로 집는다.
int _badge(WidgetTester tester) => tester
    .widgetList<Container>(find.byType(Container))
    .where((c) {
      final d = c.decoration;
      return d is BoxDecoration &&
          d.shape == BoxShape.circle &&
          d.color == const Color(0xFF7731FE);
    })
    .length;
