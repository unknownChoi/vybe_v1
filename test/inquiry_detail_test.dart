import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/data/models/inquiry_model.dart';
import 'package:vybe/presentation/support/inquiry_detail_screen.dart';
import 'package:vybe/presentation/support/viewmodels/inquiry_viewmodel.dart';

// 문의 상세 스모크 — 답변 유무에 따른 카드 전환 + 답변 확인 기록 1회.
//
// Firestore·Storage 를 타지 않도록 목록 스트림과 액션을 갈아끼운다.

/// 답변 확인 기록만 세는 가짜 액션.
class _FakeInquiryActions extends InquiryActions {
  final List<String> read = [];

  @override
  Future<void> markAnswerRead(String inquiryId) async => read.add(inquiryId);

  @override
  Future<bool> submitInquiry({
    required String userId,
    required String category,
    required String title,
    required String content,
    required List<File> images,
  }) async => true;
}

InquiryModel _inquiry({
  bool answered = false,
  DateTime? readAt,
  List<String> imageUrls = const [],
}) => InquiryModel(
  inquiryId: 'q1',
  userId: 'u1',
  userName: '테스트',
  category: 'bug',
  title: '클럽 상세가 안 열려요',
  content: '어제부터 클럽 상세 화면이 흰 화면으로 나옵니다.',
  imageUrls: imageUrls,
  status: answered ? 'answered' : 'pending',
  answer: answered ? '확인 후 조치했습니다. 앱을 최신 버전으로 올려 주세요.' : '',
  answeredAt: answered ? DateTime(2026, 9, 6) : null,
  readAt: readAt,
  createdAt: DateTime(2026, 9, 5),
  updatedAt: DateTime(2026, 9, 5),
);

Future<_FakeInquiryActions> _boot(
  WidgetTester tester,
  InquiryModel inquiry,
) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final actions = _FakeInquiryActions();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        myInquiriesProvider.overrideWith((ref) => Stream.value([inquiry])),
        inquiryActionsProvider.overrideWith(() => actions),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) =>
            MaterialApp(home: InquiryDetailScreen(inquiry: inquiry)),
      ),
    ),
  );
  // 카드 등장 애니메이션(index * 45ms).
  await tester.pump(const Duration(milliseconds: 600));
  return actions;
}

void main() {
  testWidgets('답변 전에는 대기 카드가 뜬다', (tester) async {
    final actions = await _boot(tester, _inquiry());

    expect(find.text('답변을 준비하고 있어요'), findsOneWidget);
    expect(find.text('vybe 운영팀'), findsNothing);
    // 답변이 없으면 확인 기록도 남기지 않는다.
    expect(actions.read, isEmpty);
  });

  testWidgets('답변이 오면 운영팀 카드와 본문이 그려지고 확인 기록이 한 번 남는다', (tester) async {
    final actions = await _boot(tester, _inquiry(answered: true));

    expect(find.text('vybe 운영팀'), findsOneWidget);
    expect(find.text('2026.09.06 답변'), findsOneWidget);
    expect(
      find.text('확인 후 조치했습니다. 앱을 최신 버전으로 올려 주세요.'),
      findsOneWidget,
    );
    expect(find.text('답변을 준비하고 있어요'), findsNothing);
    expect(actions.read, ['q1']);
  });

  testWidgets('이미 본 답변은 확인 기록을 다시 남기지 않는다', (tester) async {
    final actions = await _boot(
      tester,
      _inquiry(answered: true, readAt: DateTime(2026, 9, 6, 10)),
    );

    expect(actions.read, isEmpty);
  });

  testWidgets('첨부 사진이 있으면 장수를 함께 표기한다', (tester) async {
    await _boot(
      tester,
      _inquiry(
        imageUrls: const [
          'https://example.com/a.jpg',
          'https://example.com/b.jpg',
        ],
      ),
    );

    expect(find.text('첨부 사진 2장'), findsOneWidget);
  });
}
