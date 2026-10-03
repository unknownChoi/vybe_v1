import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_profile.dart';

/// MY-029 차이 #8 — 프로필 영역이 MY-030 진입점이다(결정 ㊱).
///
/// 디자인 `MRProfile` 에는 '프로필 수정' pill 이 없고, 그렇다고 pill 만 지우면
/// MY-030 이 도달 불가 화면이 된다. 행 전체를 눌러 열리게 했다.

Future<void> _pump(WidgetTester tester, {required VoidCallback onEdit}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) => MaterialApp(home: Scaffold(body: child)),
      child: MyPageProfile(
        nickname: '테스트닉',
        imageUrl: '',
        subtitle: '휴대폰으로 가입',
        gender: 'male',
        onEdit: onEdit,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('프로필 행을 누르면 MY-030 으로 간다', (tester) async {
    var opened = 0;
    await _pump(tester, onEdit: () => opened++);

    // 이름을 눌러도, 아바타를 눌러도 같은 자리로 간다.
    await tester.tap(find.text('테스트닉'));
    await tester.pump();
    expect(opened, 1);

    await tester.tap(find.byType(MyPageProfile));
    await tester.pump();
    expect(opened, 2);
  });

  testWidgets("'프로필 수정' pill 은 그리지 않는다 (디자인 MRProfile)", (tester) async {
    await _pump(tester, onEdit: () {});

    expect(find.text('프로필 수정'), findsNothing);
    // 남는 건 아바타 · 이름 · 가입 방식 세 조각뿐.
    expect(find.text('테스트닉'), findsOneWidget);
    expect(find.text('휴대폰으로 가입'), findsOneWidget);
  });
}
