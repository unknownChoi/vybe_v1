import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/presentation/clubs/widgets/review_write_cards.dart';

/// CLUB-028 리뷰 작성 — v1 디자인(`review_write.jsx`)으로 새로 들어온 조각.
///
/// 화면 전체는 Firebase(클럽 조회·등록)를 타서 여기선 **카드 단위**로 본다.
/// 등록 흐름 자체는 기기에서 확인한다.

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (_, __) => MaterialApp(home: Scaffold(body: child)),
    ),
  );
  await tester.pump();
}

/// RenewButton 은 눌림 상태를 그려서 누르는 시간을 준다.
Future<void> _press(WidgetTester tester, Finder finder) async {
  final gesture = await tester.startGesture(tester.getCenter(finder));
  await tester.pump(const Duration(milliseconds: 200));
  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  group('추천 태그 카드', () {
    testWidgets('칩 8종과 0/8 카운터가 뜨고, 누르면 토글된다', (tester) async {
      final selected = <String>[];
      await _pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => ReviewTagCard(
            selected: selected,
            onToggle: (tag) => setState(() {
              selected.contains(tag) ? selected.remove(tag) : selected.add(tag);
            }),
          ),
        ),
      );

      expect(find.text('어떤 점이 좋았나요?'), findsOneWidget);
      expect(find.text('0/8'), findsOneWidget);
      for (final tag in kReviewTags) {
        expect(find.text(tag), findsOneWidget);
      }

      await tester.tap(find.text('음악이 좋아요'));
      await tester.pump();
      expect(selected, ['음악이 좋아요']);
      expect(find.text('1/8'), findsOneWidget);

      await tester.tap(find.text('음악이 좋아요'));
      await tester.pump();
      expect(selected, isEmpty);
      expect(find.text('0/8'), findsOneWidget);
    });
  });

  group('나가기 확인 다이얼로그', () {
    testWidgets('계속 작성하기는 false, 저장 안 하고 나가기는 true', (tester) async {
      bool? result;
      await _pump(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await ReviewExitDialog.show(context);
            },
            child: const Text('열기'),
          ),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      expect(find.text('작성을 그만두시겠어요?'), findsOneWidget);
      expect(find.text('지금 나가면 작성한 내용은\n저장되지 않아요.'), findsOneWidget);

      // 주 동작은 '계속 작성하기' — 세로로 위에 둔다(디자인 RWExitAlert).
      final stay = tester.getCenter(find.text('계속 작성하기')).dy;
      final leave = tester.getCenter(find.text('저장 안 하고 나가기')).dy;
      expect(stay, lessThan(leave));

      await _press(tester, find.text('계속 작성하기'));
      expect(result, isFalse);

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      await _press(tester, find.text('저장 안 하고 나가기'));
      expect(result, isTrue);
    });
  });

  group('등록 완료 안내', () {
    testWidgets('문구 두 줄이 그려진다', (tester) async {
      await _pump(tester, const ReviewDoneView());
      expect(find.text('리뷰가 등록됐어요'), findsOneWidget);
      expect(find.text('소중한 후기 감사합니다\n다른 사람들에게 큰 도움이 돼요'), findsOneWidget);
    });
  });

  group('작성 제약 — 설계 값', () {
    test('본문 최소 10자 · 사진 30장 (설계 13장 Rules · 6-0)', () {
      // 디자인은 5자·4장이지만 설계가 이긴다. 화면이 더 느슨하면 서버가 되돌리고,
      // 더 빡빡하면 쓸 수 있는 자리를 못 쓴다.
      expect(kReviewMinLength, 10);
      expect(kReviewMaxPhotos, 30);
      expect(kReviewMaxLength, 500);
    });

    testWidgets('주의사항 5번째 줄은 디자인 문구 그대로 — 수정 안내가 빠졌다', (tester) async {
      await _pump(tester, const ReviewCautions());
      expect(find.text('작성한 리뷰는 내 정보 > 내 리뷰에서 언제든 삭제할 수 있어요.'), findsOneWidget);
      expect(
        find.text('작성한 리뷰는 내 정보 > 내 리뷰에서 언제든 수정·삭제할 수 있어요.'),
        findsNothing,
      );
    });
  });
}
