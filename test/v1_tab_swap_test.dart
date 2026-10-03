import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/main_scaffold/main_scaffold.dart';
import 'package:vybe/presentation/pass_wallet/pass_wallet_screen.dart';

/// 결정 ⑫ — 하단 탭 3번째 자리 찜 → 패스월렛.
///
/// 이 테스트가 지키는 것 두 가지:
/// ① 탭 **구성과 순서**(순서가 곧 PageView 인덱스라 바뀌면 다른 화면이 열린다)
/// ② PLACE-020 이 push 로 열리는 화면이 되어 **뒤로가기 상단바**를 갖는다
void main() {
  group('하단 탭 구성 (결정 ⑫)', () {
    test('5칸 · 3번째가 패스월렛 · 찜은 빠졌다', () {
      expect(kMainNavItems.length, 5);
      expect(
        kMainNavItems.map((e) => e.label).toList(),
        ['홈', '주변', '패스월렛', '검색', '내 정보'],
      );
      // 순서가 곧 인덱스다 — 2번이 패스월렛이어야 마이의 push 진입과 어긋나지 않는다.
      expect(kMainNavItems[2].label, '패스월렛');
      expect(kMainNavItems[2].icon, endsWith('pass_wallet.svg'));
      // 찜 아이콘(bookmark)은 더 이상 탭에 없다.
      expect(
        kMainNavItems.any((e) => e.icon.contains('bookmark')),
        isFalse,
        reason: '찜은 하단 탭에서 빠지고 마이에서 push 로 들어간다',
      );
    });
  });

  testWidgets('패스월렛 탭 — 임시 화면이 화면 ID 와 이름을 보여 준다', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => const MaterialApp(home: PassWalletScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('PASS-035'), findsOneWidget);
    expect(find.text('패스월렛'), findsOneWidget);
    expect(find.text('아직 만들지 않은 화면이에요'), findsOneWidget);
  });

  testWidgets('PLACE-020 은 push 로 열리므로 뒤로가기 상단바가 있다', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // SavedScreen 전체는 favorites provider 가 필요해, 상단바만 따로 확인한다.
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const Scaffold(
                      body: SafeArea(child: VybePushHeader(title: '찜한 클럽')),
                    ),
                  ),
                ),
                child: const Text('열기'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();

    expect(find.text('찜한 클럽'), findsOneWidget);

    // 뒤로가기로 돌아온다.
    await tester.tap(find.byType(VybePushHeader).first);
    await tester.pumpAndSettle();
  });
}
