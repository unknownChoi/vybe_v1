import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/models/inquiry_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/support/support_screen.dart';
import 'package:vybe/presentation/support/viewmodels/inquiry_viewmodel.dart';
import 'package:vybe/presentation/support/widgets/inquiry_card.dart';
import 'package:vybe/presentation/support/widgets/inquiry_tabs.dart';

// 고객센터 목록 스모크 — 상태 3종 + 답변완료 표기 + 비로그인 안내.
// Firestore를 타지 않도록 목록 스트림과 uid만 갈아끼운다.

InquiryModel _inquiry({
  required String id,
  required String title,
  String status = 'pending',
  String answer = '',
  DateTime? answeredAt,
  DateTime? readAt,
}) => InquiryModel(
  inquiryId: id,
  userId: 'u1',
  userName: '테스트',
  category: 'service',
  title: title,
  content: '앱에서 클럽 상세가 열리지 않아요. 확인 부탁드립니다.',
  status: status,
  answer: answer,
  answeredAt: answeredAt,
  readAt: readAt,
  createdAt: DateTime(2026, 9, 1),
  updatedAt: DateTime(2026, 9, 1),
);

Future<void> _boot(
  WidgetTester tester, {
  String? uid = 'u1',
  Stream<List<InquiryModel>>? stream,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        currentUidProvider.overrideWithValue(uid),
        myInquiriesProvider.overrideWith(
          (ref) => stream ?? Stream.value(const <InquiryModel>[]),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => const MaterialApp(home: SupportScreen()),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

List<InquiryModel> _two() => [
  _inquiry(id: 'a', title: '클럽 정보가 잘못돼 있어요'),
  _inquiry(
    id: 'b',
    title: '로그인이 안 돼요',
    status: 'answered',
    answer: '확인 후 조치했습니다.',
    answeredAt: DateTime(2026, 9, 3),
  ),
];

/// 카드 안에 있는 문구만 — 상단 탭에도 같은 라벨이 있다.
Finder _inCard(String text) => find.descendant(
  of: find.byType(InquiryCard),
  matching: find.text(text),
);

/// 상단 탭 라벨. 카드 뱃지와 문구가 같아 범위를 좁혀야 한다.
Finder _tab(String label) => find.descendant(
  of: find.byType(InquiryTabs),
  matching: find.text(label),
);

void main() {
  testWidgets('문의가 없으면 빈 상태 안내가 뜬다', (tester) async {
    await _boot(tester);

    expect(find.text('아직 보낸 문의가 없어요'), findsOneWidget);
    expect(find.text('문의하기'), findsOneWidget);
  });

  testWidgets('비로그인이면 로그인 안내로 바뀐다', (tester) async {
    await _boot(tester, uid: null);

    expect(find.text('로그인 후 이용할 수 있어요'), findsOneWidget);
    expect(find.text('아직 보낸 문의가 없어요'), findsNothing);
  });

  testWidgets('목록은 상태 뱃지와 함께 그려진다 (대기 · 완료)', (tester) async {
    await _boot(tester, stream: Stream.value(_two()));
    // 카드 등장 애니메이션(index * 45ms)이 끝나야 텍스트가 보인다.
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('클럽 정보가 잘못돼 있어요'), findsOneWidget);
    expect(find.text('로그인이 안 돼요'), findsOneWidget);
    // 같은 문구가 상단 탭에도 있어 카드 안쪽만 센다.
    expect(_inCard('답변 대기'), findsOneWidget);
    expect(_inCard('답변 완료'), findsOneWidget);
  });

  testWidgets('선택된 탭에만 라임 밑줄이 폭을 갖고 그려진다', (tester) async {
    await _boot(tester, stream: Stream.value(_two()));
    await tester.pump(const Duration(milliseconds: 600));

    final underline = find.descendant(
      of: find.byType(InquiryTabs),
      matching: find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration! as BoxDecoration).color == VybeColors.mainLime500,
      ),
    );

    expect(underline, findsOneWidget);
    // 폭 0으로 접히면 선이 없는 것과 같다 — Row 가 주는 무한 폭 제약 회귀 방지.
    expect(tester.getSize(underline).width, greaterThan(30));
    expect(tester.getSize(underline).height, greaterThan(0));
  });

  testWidgets('탭을 바꾸면 그 상태의 문의만 남는다', (tester) async {
    await _boot(tester, stream: Stream.value(_two()));
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(_tab('답변 완료'));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('로그인이 안 돼요'), findsOneWidget);
    expect(find.text('클럽 정보가 잘못돼 있어요'), findsNothing);

    await tester.tap(_tab('답변 대기'));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('클럽 정보가 잘못돼 있어요'), findsOneWidget);
    expect(find.text('로그인이 안 돼요'), findsNothing);
  });

  testWidgets('한 탭이 비어도 다른 탭에 문의가 있으면 문구가 달라진다', (tester) async {
    await _boot(
      tester,
      stream: Stream.value([_inquiry(id: 'a', title: '답변 기다리는 문의')]),
    );
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(_tab('답변 완료'));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('답변 완료된 문의가 없어요'), findsOneWidget);
    expect(find.text('아직 보낸 문의가 없어요'), findsNothing);
  });

  testWidgets('조회 실패는 오류 문구로 대체된다', (tester) async {
    await _boot(
      tester,
      stream: Stream<List<InquiryModel>>.error(Exception('permission-denied')),
    );

    expect(find.text('문의 내역을 불러오지 못했어요'), findsOneWidget);
  });
}
