import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/data/models/performance_model.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/hip_hop/hip_hop_style.dart';
import 'package:vybe/presentation/hip_hop/lineup_models.dart';
import 'package:vybe/presentation/hip_hop/today_lineup_screen.dart';
import 'package:vybe/presentation/hip_hop/viewmodels/hip_hop_viewmodel.dart';

/// HOME-009 오늘의 라인업 — v1 디자인 반영분.
///
/// 테스트 프로젝트의 `performances` 는 날짜 버킷(오늘)으로 조회해서, 실행일에
/// 공연이 없으면 기기에서 목록을 볼 수 없다. 목록이 있는 경우는 여기서 본다.

PerformanceModel _perf({
  required String id,
  required String artist,
  required String area,
  required String type,
  required int hour,
}) => PerformanceModel(
  performanceId: id,
  clubId: 'c_$id',
  clubName: '클럽 $id',
  clubArea: area,
  genre: '힙합',
  artistName: artist,
  artistType: type,
  startAt: DateTime(2026, 10, 4, hour),
  date: '20261004',
  isFeatured: false,
  isActive: true,
  createdAt: DateTime(2026),
);

Future<void> _pump(WidgetTester tester, List<PerformanceModel> perfs) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hipHopViewModelProvider.overrideWith(
          (ref) async => GenrePageData(clubs: const [], performances: perfs),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => const MaterialApp(home: TodayLineupScreen()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('인트로 메타', () {
    test('지역 줄은 오늘 목록에 실제로 있는 지역만 디자인 순서로 잇는다', () {
      final items = [
        for (final (id, area) in [('1', '강남'), ('2', '홍대'), ('3', '성수')])
          lineupItemFrom(
            _perf(id: id, artist: 'A$id', area: area, type: 'dj', hour: 22),
          ),
      ];
      // 디자인 순서(홍대 · 강남 …) 먼저, 목록에 없는 지역은 뒤에 이름순.
      expect(lineupAreaText(items), '홍대 · 강남 · 성수');
      // 고정 문구 '모든지역' 은 더 이상 쓰지 않는다.
      expect(lineupAreaText(const []), '');
    });
  });

  testWidgets('헤더 · 단색 배경 · 골드 칩 · 지역 줄', (tester) async {
    await _pump(tester, [
      _perf(id: '1', artist: 'YANO', area: '홍대', type: 'rapper', hour: 22),
      _perf(id: '2', artist: 'SOUL', area: '강남', type: 'dj', hour: 23),
    ]);

    // #1 고정 헤더 바 + 화면 제목.
    expect(find.byType(VybePushHeader), findsOneWidget);
    expect(find.text('오늘의 라인업'), findsOneWidget);
    // #7 배경은 단색 — 오로라를 깔지 않는다.
    expect(find.byType(VybeAurora), findsNothing);
    // #4 지역 줄이 데이터에서 나온다.
    expect(find.text('홍대 · 강남'), findsOneWidget);
    expect(find.text('모든지역'), findsNothing);
    // 목록·개수.
    expect(find.text('2팀'), findsOneWidget);
    expect(find.text('YANO'), findsOneWidget);
    expect(find.text('SOUL'), findsOneWidget);
  });

  testWidgets('#5 빈 상태는 한 문구 — 디자인에 없는 문구를 쓰지 않는다', (tester) async {
    await _pump(tester, const []);
    expect(find.text('해당하는 공연이 없어요'), findsOneWidget);
    expect(find.text('오늘 예정된 공연이 없어요'), findsNothing);
  });

  testWidgets('#6 선택된 타입 칩은 힙합 골드로 칠한다', (tester) async {
    await _pump(tester, [
      _perf(id: '1', artist: 'YANO', area: '홍대', type: 'rapper', hour: 22),
    ]);

    final chip = tester.widget<AnimatedContainer>(
      find
          .ancestor(
            of: find.text('전체'),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );
    expect((chip.decoration! as BoxDecoration).color, kLineupAccent);
  });
}
