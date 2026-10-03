import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/data/datasources/fake/fake_club_ops_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_chrome.dart';

/// CLUB-021 하단 바 — 노출(features) · 활성(ops/live) 분기.
///
/// 설계 6-0 CLUB-021 「하단 바(웨이팅·예약 버튼)는 clubs.features ·
/// ops/live.phase/accept 로 활성화」.

Future<void> _pump(WidgetTester tester, Widget bar) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (_, __) => MaterialApp(
        home: Scaffold(
          body: Align(alignment: Alignment.bottomCenter, child: bar),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// 누름 최소 노출 시간([VybeLiquidPress])이 있어 `tap` 한 번으로는 안 쏜다 —
/// 눌렀다 잠시 뒤 떼는 실제 손가락 흐름을 흉내 낸다.
Future<void> _press(WidgetTester tester, Finder finder) async {
  final g = await tester.startGesture(tester.getCenter(finder));
  await tester.pump(const Duration(milliseconds: 200));
  await g.up();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  tearDown(() => fakeScenario.value = FakeScenario.normal);

  group('하단 바 노출 — clubs.features', () {
    testWidgets('웨이팅만 켠 클럽은 예약 버튼이 아예 없다', (tester) async {
      await _pump(
        tester,
        RenewBottomBar(
          saved: false,
          saveCount: 12,
          onSave: () {},
          onWaiting: () {},
        ),
      );
      expect(find.text('웨이팅 등록'), findsOneWidget);
      // 꺼진 기능은 회색 버튼이 아니라 **없음** — 눌러 보고 알게 하지 않는다.
      expect(find.text('테이블 예약'), findsNothing);
    });

    testWidgets('아무것도 안 켠 클럽은 하트만 남는다', (tester) async {
      await _pump(
        tester,
        RenewBottomBar(saved: true, saveCount: 129, onSave: () {}),
      );
      expect(find.text('웨이팅 등록'), findsNothing);
      expect(find.text('테이블 예약'), findsNothing);
      expect(find.text('129'), findsOneWidget);
    });
  });

  group('하단 바 상태 — ops/live', () {
    testWidgets('접수 중지면 눌리지 않는다', (tester) async {
      var tapped = 0;
      await _pump(
        tester,
        RenewBottomBar(
          saved: false,
          saveCount: 0,
          onSave: () {},
          onWaiting: () => tapped++,
          waitingLabel: '웨이팅 접수 중지',
          waitingDisabled: true,
        ),
      );
      await _press(tester, find.text('웨이팅 접수 중지'));
      expect(tapped, 0);
    });

    testWidgets('내 티켓이 있으면 순번을 말하고 눌린다', (tester) async {
      var tapped = 0;
      await _pump(
        tester,
        RenewBottomBar(
          saved: false,
          saveCount: 0,
          onSave: () {},
          onWaiting: () => tapped++,
          waitingLabel: '웨이팅 3번째',
          waitingActive: true,
        ),
      );
      await _press(tester, find.text('웨이팅 3번째'));
      expect(tapped, 1);
    });
  });

  group('Fake — 입장비 유무가 등록 흐름을 가른다', () {
    test('입장비 있는 클럽과 없는 클럽이 둘 다 나온다', () async {
      final ds = FakeClubOpsDataSource();
      final fees = <bool>{};
      for (final id in ['c1', 'c2', 'c3', 'c4', 'c5', 'c6']) {
        final s = await ds.getSettings(id);
        fees.add(s!.hasEntryFee);
      }
      // 두 흐름(WAIT · FEE)을 다 눌러 볼 수 있어야 한다.
      expect(fees, {true, false});
    });

    test('빈 상태면 설정이 없다 — 화면이 금액을 지어내지 않는다', () async {
      fakeScenario.value = FakeScenario.empty;
      expect(await FakeClubOpsDataSource().getSettings('c1'), isNull);
    });

    test('어느 클럽을 열어도 웨이팅·예약 진입점이 있다', () async {
      final ds = FakeClubOpsDataSource();
      final all = <ClubFeatures>[];
      for (final id in ['c1', 'c2', 'c3', 'c4', 'c5', 'c6']) {
        all.add(await ds.getFeatures(id));
      }
      // 해시로 1/3 을 꺼 두면 사용자가 연 클럽에 하단 바가 안 떠 진입점을
      // 확인할 수 없다 — 기능 미사용 모습은 '빈 상태' 시나리오로 본다.
      expect(all.every((f) => f.waiting && f.reservation), isTrue);
      expect(all.any((f) => f.order), isTrue);
    });

    test('빈 상태면 기능이 전부 꺼진다 — 하단 바가 베타처럼 그려진다', () async {
      fakeScenario.value = FakeScenario.empty;
      final f = await FakeClubOpsDataSource().getFeatures('c1');
      expect(f.none, isTrue);
    });
  });
}
