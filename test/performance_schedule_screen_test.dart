import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/presentation/clubs/performance_schedule_screen.dart';
import 'package:vybe/presentation/clubs/viewmodels/club_schedule_viewmodel.dart';
import 'package:vybe/presentation/clubs/widgets/schedule_page_parts.dart';
import 'package:vybe/presentation/clubs/widgets/schedule_shared.dart';

/// 클럽 상세 '다가오는 라인업 > 전체보기' 페이지 — 리뉴얼 셸(오로라 + 글래스 카드)
/// 위에서 월별 묶음·타입 필터가 그대로 도는지.

const _clubId = 'club_1';
const _grad = [Color(0xFF3A0CA3), Color(0xFF4361EE)];

ScheduleAct _act(String name, String type, {bool headline = false}) =>
    ScheduleAct(
      time: '23:00',
      name: name,
      type: type,
      headline: headline,
      gradient: _grad,
    );

final _days = [
  ScheduleDay(
    year: 2026,
    month: 9,
    day: 9,
    dow: '수',
    dday: 0,
    acts: [_act('알파', 'rapper', headline: true), _act('베타', 'dj')],
  ),
  ScheduleDay(
    year: 2026,
    month: 9,
    day: 12,
    dow: '토',
    dday: 3,
    acts: [_act('감마', 'dj')],
  ),
];

Widget _app() => ProviderScope(
  overrides: [
    clubScheduleProvider(_clubId).overrideWith((ref) async => _days),
  ],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (_, __) => const MaterialApp(
      home: PerformanceScheduleScreen(
        clubId: _clubId,
        clubName: '클럽 알파',
        area: '홍대',
      ),
    ),
  ),
);

// 테스트 폰트(Ahem)가 넓어 실기기 폭이면 오버플로가 잡힌다.
void _wideScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(700, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// 필터 칩의 라벨('DJ'·'래퍼')은 공연 행 배지에도 같은 글자로 나온다 —
/// 칩만 집어내려면 필터 위젯 안으로 범위를 좁혀야 한다.
Finder _chip(String label) => find.descendant(
  of: find.byType(SchedulePageFilter),
  matching: find.text(label),
);

void main() {
  testWidgets('월별로 묶여 그려지고 오늘 카드가 표시된다', (tester) async {
    _wideScreen(tester);

    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.text('다가오는 공연'), findsOneWidget);
    expect(find.text('2026년 9월'), findsOneWidget);
    expect(find.text('· 2일'), findsOneWidget);
    expect(find.text('오늘'), findsOneWidget);
    expect(find.text('D-3'), findsOneWidget);
    expect(find.text('알파'), findsOneWidget);
    expect(find.text('베타'), findsOneWidget);
    expect(find.text('감마'), findsOneWidget);
  });

  testWidgets('DJ 필터는 래퍼 공연을 뺀다', (tester) async {
    _wideScreen(tester);

    await tester.pumpWidget(_app());
    await tester.pump();

    await tester.tap(_chip('DJ'));
    await tester.pump();

    expect(find.text('알파'), findsNothing);
    expect(find.text('베타'), findsOneWidget);
    expect(find.text('감마'), findsOneWidget);
  });
}
