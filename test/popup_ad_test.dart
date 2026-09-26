import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe/core/storage/local_prefs.dart';
import 'package:vybe/data/models/notice_model.dart';
import 'package:vybe/data/models/popup_ad_model.dart';
import 'package:vybe/presentation/home/viewmodels/popup_ad_viewmodel.dart';
import 'package:vybe/presentation/home/widgets/home_popup_ad.dart';
import 'package:vybe/presentation/my_page/notice_detail_route.dart';
import 'package:vybe/presentation/my_page/viewmodels/notice_viewmodel.dart';

// 홈 진입 팝업 광고 — 어떤 1건이 뽑히는지(순수 함수)와 화면 동작(표시·닫기·이동).

const _noticeId = 'notice_ad_soulbeat';

PopupAdModel _ad({
  String id = 'popup_1',
  bool isPrimary = false,
  int order = 0,
  bool isActive = true,
  DateTime? startAt,
  DateTime? endAt,
  String noticeId = '',
}) => PopupAdModel(
  popupId: id,
  imageUrl: 'https://example.com/$id.jpg',
  altText: 'DJ SOUL BEAT',
  linkType: noticeId.isEmpty ? PopupAdLinkType.none : PopupAdLinkType.notice,
  linkValue: noticeId,
  isPrimary: isPrimary,
  order: order,
  isActive: isActive,
  startAt: startAt ?? DateTime(2026, 9, 1),
  endAt: endAt ?? DateTime(2026, 10, 1),
);

final _now = DateTime(2026, 9, 10);

final _notice = NoticeModel(
  noticeId: _noticeId,
  title: 'DJ SOUL BEAT 게스트 셋',
  content: '10월 26일 클럽 벨벳.',
  category: 'ad',
  publishedAt: DateTime(2026, 9, 1),
  createdAt: DateTime(2026, 9, 1),
  updatedAt: DateTime(2026, 9, 1),
);

Future<void> _boot(WidgetTester tester, PopupAdModel? ad) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({});

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        popupAdProvider.overrideWith((ref) async => ad),
        noticeProvider(_noticeId).overrideWith((ref) async => _notice),
        noticesProvider.overrideWith((ref) async => [_notice]),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [Positioned.fill(child: HomePopupAd(ready: true))],
            ),
          ),
        ),
      ),
    ),
  );
  // 조회 + 표시 지연(240ms) + 등장 애니메이션(300ms).
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  group('PopupAdModel.pick — 띄울 1건 고르기', () {
    test('isPrimary가 order보다 먼저다', () {
      final picked = PopupAdModel.pick([
        _ad(id: 'a', order: 1),
        _ad(id: 'b', order: 99, isPrimary: true),
      ], _now);

      expect(picked?.popupId, 'b');
    });

    test('1순위가 여럿이면 order가 낮은 쪽 — 답이 하나로 좁혀진다', () {
      final picked = PopupAdModel.pick([
        _ad(id: 'a', order: 5, isPrimary: true),
        _ad(id: 'b', order: 2, isPrimary: true),
      ], _now);

      expect(picked?.popupId, 'b');
    });

    test('1순위·order가 같으면 popupId로 갈라 같은 목록이면 같은 결과', () {
      final ads = [_ad(id: 'z', isPrimary: true), _ad(id: 'a', isPrimary: true)];

      expect(PopupAdModel.pick(ads, _now)?.popupId, 'a');
      expect(PopupAdModel.pick(ads.reversed.toList(), _now)?.popupId, 'a');
    });

    test('노출 기간 밖·비활성은 제외하고, 남는 게 없으면 null', () {
      final picked = PopupAdModel.pick([
        _ad(id: 'past', endAt: DateTime(2026, 9, 5)),
        _ad(id: 'future', startAt: DateTime(2026, 9, 20)),
        _ad(id: 'off', isActive: false),
      ], _now);

      expect(picked, isNull);
    });

    test('시작 시각은 포함, 종료 시각은 제외', () {
      final ad = _ad(startAt: _now, endAt: _now.add(const Duration(days: 1)));

      expect(ad.isVisibleAt(_now), isTrue);
      expect(ad.isVisibleAt(ad.endAt), isFalse);
    });
  });

  group('HomePopupAd', () {
    testWidgets('띄울 광고가 있으면 사진과 하단 바가 보인다', (tester) async {
      await _boot(tester, _ad());

      expect(find.text('1주일동안 안보기'), findsOneWidget);
      expect(find.text('닫기'), findsOneWidget);
      expect(find.text('AD'), findsOneWidget);
    });

    testWidgets('광고가 없으면 아무것도 그리지 않는다', (tester) async {
      await _boot(tester, null);

      expect(find.text('닫기'), findsNothing);
    });

    testWidgets('홈이 아직 안 뜬 상태(ready=false)면 안 띄운다', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [popupAdProvider.overrideWith((ref) async => _ad())],
          child: ScreenUtilInit(
            designSize: const Size(393, 852),
            builder: (_, __) => const MaterialApp(
              home: Scaffold(body: HomePopupAd(ready: false)),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('닫기'), findsNothing);
    });

    testWidgets('닫기를 누르면 사라진다', (tester) async {
      await _boot(tester, _ad());

      await tester.tap(find.text('닫기'));
      await tester.pumpAndSettle();

      expect(find.text('닫기'), findsNothing);
    });

    testWidgets('1주일동안 안보기 — 만료 시각을 기기에 남기고 닫는다', (tester) async {
      await _boot(tester, _ad(id: 'popup_week'));

      await tester.tap(find.text('1주일동안 안보기'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('1주일동안 안보기'), findsNothing);

      final prefs = LocalPrefs(await SharedPreferences.getInstance());
      final until = prefs.popupAdHideUntil('popup_week');
      final expected = DateTime.now().add(kPopupAdHideDuration);
      expect(until, greaterThan(0));
      // 7일 뒤 ±1분.
      expect(
        (until - expected.millisecondsSinceEpoch).abs(),
        lessThan(60 * 1000),
      );
      // 다른 팝업은 숨겨지지 않는다 — 키가 문서별로 갈려 있다.
      expect(prefs.popupAdHideUntil('popup_other'), 0);
    });

    testWidgets('사진을 탭하면 연결된 공지 상세가 열린다', (tester) async {
      await _boot(tester, _ad(noticeId: _noticeId));

      await tester.tap(find.byType(AspectRatio).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(NoticeDetailById), findsOneWidget);
      expect(find.text('DJ SOUL BEAT 게스트 셋'), findsOneWidget);
    });

    testWidgets('공지를 연결하지 않은 광고는 탭해도 아무 데도 안 간다', (tester) async {
      await _boot(tester, _ad());

      await tester.tap(find.byType(AspectRatio).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(NoticeDetailById), findsNothing);
      // 팝업은 그대로 떠 있다.
      expect(find.text('닫기'), findsOneWidget);
    });
  });
}
