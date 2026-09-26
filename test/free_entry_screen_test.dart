import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/providers/location_providers.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/free_entry_policy.dart';
import 'package:vybe/data/models/operating_hours.dart';
import 'package:vybe/presentation/free_entry/free_entry_screen.dart';
import 'package:vybe/presentation/free_entry/viewmodels/free_entry_viewmodel.dart';

/// 입장비 무료 페이지(리뉴얼) — 시간대 무료는 ① 레일, 상시 무료는 ③ 레일, 지도는 전체.
///
/// 화면이 `DateTime.now()` 로 판정하므로 **시각을 주입할 수 없다** →
/// 창을 지금 기준 상대 시각으로 만들어 실행 시각과 무관하게 같은 결과가 나오게 한다.
///
/// 클럽 좌표는 (0,0) — 지도 섹션이 핀을 못 찍어 NaverMap(플랫폼 뷰 · 테스트 불가)을
/// 안 만들고 빈 지도 안내를 그린다.

/// 24시간 영업 — '지금 무료'는 영업 중일 때만 뜨므로 영업시간이 판정을 가리지 않게.
const _open24 = OperatingHours(
  mon: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  tue: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  wed: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  thu: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  fri: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  sat: DayHours(isOpen: true, open: '00:00', close: '24:00'),
  sun: DayHours(isOpen: true, open: '00:00', close: '24:00'),
);

String _hhmm(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// [from] ~ [to] 를 덮는 창 하나. 창은 **시작 요일**에 속한다.
FreeEntryWindow _window(DateTime from, DateTime to) => FreeEntryWindow(
  days: [dayKeyOf(from.weekday)],
  start: _hhmm(from),
  end: _hhmm(to),
);

ClubModel _club({
  required String id,
  required String name,
  required FreeEntryPolicy freeEntry,
  int entryFeeMin = 20000,
  OperatingHours hours = _open24,
}) => ClubModel(
  clubId: id,
  name: name,
  description: '',
  address: '',
  area: '홍대',
  phone: '',
  instagramUrl: '',
  lat: 0,
  lng: 0,
  geohash: '',
  genre: '힙합',
  rating: 4.5,
  operatingHours: hours,
  entryFeeMin: entryFeeMin,
  entryFeeMax: 30000,
  imageUrls: const [],
  thumbnailUrl: '',
  tags: const [],
  favoriteCount: 0,
  isActive: true,
  isVybeRecommended: false,
  freeEntry: freeEntry,
  isFreeEntry: freeEntry.hasFreeEntry,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

ClubModel _timedClub(
  String id,
  String name,
  DateTime from,
  DateTime to, {
  String cond = '',
  OperatingHours hours = _open24,
}) => _club(
  id: id,
  name: name,
  hours: hours,
  freeEntry: FreeEntryPolicy(
    type: FreeEntryType.timed,
    condition: cond,
    windows: [_window(from, to)],
  ),
);

class _FixedLocation extends UserLocationNotifier {
  @override
  UserLocation build() =>
      const UserLocation(lat: 37.55, lng: 126.92, area: '홍대');
}

Widget _app(List<ClubModel> clubs) => ProviderScope(
  overrides: [
    freeEntryViewModelProvider.overrideWith((ref) async => clubs),
    // 비로그인 — mergedFavoriteIds 가 Firestore 스트림을 건드리지 않게 한다.
    currentUidProvider.overrideWithValue(null),
    userLocationProvider.overrideWith(_FixedLocation.new),
  ],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (_, __) => const MaterialApp(home: FreeEntryScreen()),
  ),
);

/// 카운트다운 타이머·스켈레톤이 반복이라 pumpAndSettle 대신 정해진 만큼만 돌린다.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 300));
  }
}

void main() {
  testWidgets('상시·진행중·예정 무료가 각각 제 섹션에 제 문구로 그려진다', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final now = DateTime.now();
    await tester.pumpWidget(
      _app([
        // 상시 무료 → ③ 조건 레일.
        _club(
          id: 'always',
          name: '상시무료클럽',
          entryFeeMin: 0,
          freeEntry: const FreeEntryPolicy(
            type: FreeEntryType.always,
            condition: '여성 무료입장',
          ),
        ),
        // 지금 무료 — 한 시간 전에 시작해 한 시간 뒤에 끝나는 창 → ① 카운트다운.
        _timedClub(
          'now',
          '지금무료클럽',
          now.subtract(const Duration(hours: 1)),
          now.add(const Duration(hours: 1)),
        ),
        // 아직 무료 아님 — 세 시간 뒤에 시작하는 창 → ① 예정 문구.
        _timedClub(
          'later',
          '예정무료클럽',
          now.add(const Duration(hours: 3)),
          now.add(const Duration(hours: 5)),
          cond: '오픈런 무료',
        ),
      ]),
    );
    await _settle(tester);

    expect(find.text('지금 무료 1곳 · 시간 지나면 입장료가 붙어요'), findsOneWidget);

    // 진행 중 — 뱃지 '지금 무료' + 마감 카운트다운.
    expect(find.text('지금 무료'), findsOneWidget);
    expect(find.text('무료 마감까지'), findsOneWidget);
    // 예정 — 언제부터 무료인지로 바꿔 말한다.
    expect(find.text('시간대 무료'), findsOneWidget);
    expect(find.textContaining('부터 무료'), findsOneWidget);
    expect(find.text('오픈런 무료'), findsOneWidget);

    // 상시 — 조건 레일(③, 지도 아래)에 조건 문구와 함께.
    await tester.dragUntilVisible(
      find.text('조건이 맞으면 무료'),
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    await tester.pump();
    expect(find.text('1곳 · 클럽마다 조건이 달라요'), findsOneWidget);
    expect(find.text('여성 무료입장'), findsOneWidget);

    expect(find.text('상시무료클럽'), findsOneWidget);
    expect(find.text('지금무료클럽'), findsOneWidget);
    expect(find.text('예정무료클럽'), findsOneWidget);
  });

  testWidgets('지금 무료인 곳이 레일 맨 앞으로 온다', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final now = DateTime.now();
    await tester.pumpWidget(
      _app([
        _timedClub(
          'later',
          '예정무료클럽',
          now.add(const Duration(hours: 3)),
          now.add(const Duration(hours: 5)),
        ),
        _timedClub(
          'now',
          '지금무료클럽',
          now.subtract(const Duration(hours: 1)),
          now.add(const Duration(hours: 1)),
        ),
      ]),
    );
    await _settle(tester);

    final freeNowX = tester.getTopLeft(find.text('지금무료클럽')).dx;
    final laterX = tester.getTopLeft(find.text('예정무료클럽')).dx;
    expect(freeNowX, lessThan(laterX));
  });

  testWidgets('문 닫은 클럽은 무료 창 안이어도 지금 무료라고 하지 않는다', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final now = DateTime.now();
    await tester.pumpWidget(
      _app([
        _timedClub(
          'closed',
          '휴무클럽',
          now.subtract(const Duration(hours: 1)),
          now.add(const Duration(hours: 1)),
          hours: const OperatingHours(), // 전 요일 휴무
        ),
      ]),
    );
    await _settle(tester);

    expect(find.text('휴무클럽'), findsOneWidget);
    expect(find.text('지금 무료'), findsNothing);
    expect(find.text('무료 마감까지'), findsNothing);
    expect(find.text('다음 무료입장'), findsOneWidget);
  });
}
