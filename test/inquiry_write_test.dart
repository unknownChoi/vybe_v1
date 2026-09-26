import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/presentation/support/inquiry_write_screen.dart';
import 'package:vybe/presentation/support/support_models.dart';
import 'package:vybe/presentation/support/viewmodels/inquiry_viewmodel.dart';

// 문의 작성 스모크 — 제출 가능 판정과 등록 경로.
//
// 길이 기준(kInquiryTitleMin/kInquiryContentMin)은 Firestore Rules 의 create
// 검증과 같은 값이다. 화면이 더 느슨해지면 실기기에서 403 이 나므로 여기서 잡는다.

/// 등록 호출을 받아 두는 가짜 액션 — Firestore·Storage 를 타지 않는다.
class _FakeInquiryActions extends InquiryActions {
  final List<({String category, String title, String content, int photos})>
  submits = [];

  bool succeed = true;

  @override
  Future<bool> submitInquiry({
    required String userId,
    required String category,
    required String title,
    required String content,
    required List<File> images,
  }) async {
    submits.add((
      category: category,
      title: title,
      content: content,
      photos: images.length,
    ));
    return succeed;
  }
}

Future<_FakeInquiryActions> _boot(WidgetTester tester) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final actions = _FakeInquiryActions();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        currentUidProvider.overrideWithValue('u1'),
        inquiryActionsProvider.overrideWith(() => actions),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => const MaterialApp(home: InquiryWriteScreen()),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 200));
  return actions;
}

Finder get _titleField => find.byType(TextField).first;
Finder get _contentField => find.byType(TextField).last;

void main() {
  testWidgets('제목·본문이 최소 길이를 넘기 전에는 보내지 않는다', (tester) async {
    final actions = await _boot(tester);

    // 빈 상태에서 눌러도 아무 일도 없다.
    await tester.tap(find.text('제출하기'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(actions.submits, isEmpty);

    // 제목만 채운 상태 — 본문이 최소 길이 미만이라 여전히 막힌다.
    await tester.enterText(_titleField, '로그인 오류');
    await tester.enterText(_contentField, '짧아요');
    await tester.pump();
    await tester.tap(find.text('제출하기'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(actions.submits, isEmpty);
  });

  testWidgets('유형·제목·본문을 채우면 그 값 그대로 등록된다', (tester) async {
    final actions = await _boot(tester);

    await tester.tap(find.text(InquiryCategory.bug.label));
    await tester.pump();
    await tester.enterText(_titleField, '클럽 상세가 안 열려요');
    await tester.enterText(_contentField, '어제부터 클럽 상세 화면이 흰 화면으로 나옵니다.');
    await tester.pump();

    await tester.tap(find.text('제출하기'));
    // 버튼 누름 연출(VybeLiquidPress)이 300ms 타이머를 남긴다 — 그보다 길게 돌린다.
    await tester.pump(const Duration(milliseconds: 500));

    expect(actions.submits, hasLength(1));
    expect(actions.submits.single.category, InquiryCategory.bug.name);
    expect(actions.submits.single.title, '클럽 상세가 안 열려요');
    expect(actions.submits.single.photos, 0);
  });

  test('작성 제약은 Rules 검증과 같은 값이어야 한다', () {
    // 값을 바꿀 땐 firestore.rules 의 inquiries create 규칙도 같이 고칠 것.
    expect(kInquiryTitleMin, 2);
    expect(kInquiryTitleMax, 50);
    expect(kInquiryContentMin, 10);
    expect(kInquiryContentMax, 1000);
    expect(kInquiryMaxPhotos, 4);
  });
}
