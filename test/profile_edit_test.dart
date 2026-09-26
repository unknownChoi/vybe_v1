import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/models/user_model.dart';
import 'package:vybe/data/repositories/user_repository_impl.dart';
import 'package:vybe/domain/exceptions/profile_exceptions.dart';
import 'package:vybe/domain/repositories/user_repository.dart';
import 'package:vybe/presentation/common/renew/renew_button.dart';
import 'package:vybe/presentation/my_page/profile_edit_screen.dart';
import 'package:vybe/presentation/my_page/widgets/profile_edit_parts.dart';

// ============================================================
// 내 정보 수정 (디자인 my_edit_v2.html) — 닉네임 · 사진 저장 경로 스모크
//
// 서버(Cloud Functions)를 타는 자리는 가짜 repository 로 갈아 끼우고,
// **화면이 무엇을 보내고 무엇을 보여주는지**만 본다.
// ============================================================

UserModel _user({String nickname = '김바이브', String photo = ''}) => UserModel(
  uid: 'u1',
  name: '최윤성',
  phone: '010-1234-5678',
  birthDate: '19970314',
  gender: 'female',
  nickname: nickname,
  profileImageUrl: photo,
  provider: 'kakao',
  isVerified: true,
  agreements: const {},
  createdAt: DateTime(2025, 11, 2),
  updatedAt: DateTime(2026, 9, 1),
);

class _FakeUserRepository implements UserRepository {
  /// 화면이 함수에 실어 보낸 값.
  final List<({String? nickname, String? photo})> saves = [];

  /// 저장이 이 예외로 실패한다.
  Object? failWith;

  /// 서버 왕복 흉내 — 기본(즉시 완료)은 마이크로태스크라 autoDispose 타이머가
  /// 끼어들 틈이 없다. 실기기처럼 뷰모델이 **먼저 dispose 되는** 순서를 만들 때 준다.
  Duration? delay;

  final List<String> deleted = [];

  @override
  Future<ProfileSaveResult> updateUserProfile({
    String? nickname,
    String? profileImageUrl,
  }) async {
    saves.add((nickname: nickname, photo: profileImageUrl));
    if (delay != null) await Future<void>.delayed(delay!);
    if (failWith != null) throw failWith!;
    return (nickname: nickname ?? '', profileImageUrl: profileImageUrl ?? '');
  }

  @override
  Future<String> uploadProfileImage(String uid, File imageFile) async =>
      'https://example.test/users/$uid/profile_1.jpg';

  @override
  Future<void> deleteFileByUrl(String url) async => deleted.add(url);

  /// 저장 전 서버 값(옛 사진 URL) 조회 — 이 테스트는 빈 프로필이면 된다.
  @override
  Future<UserModel?> getUser(String uid) async => null;

  // 이 화면이 안 쓰는 나머지는 호출되면 그대로 실패시킨다.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pump(
  WidgetTester tester, {
  required UserModel user,
  _FakeUserRepository? repository,
  String? uid = 'u1',
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        currentUidProvider.overrideWithValue(uid),
        if (repository != null)
          userRepositoryProvider.overrideWithValue(repository),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) => MaterialApp(home: ProfileEditScreen(user: user)),
      ),
    ),
  );
  // VybeFadeInUp(index:) 계단(40 + index×45ms) + 등장 애니메이션(300ms)
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 400));
}

/// 저장 성공 경로는 [VybeToast] 를 띄운다 — 3초 타이머가 남아 있으면
/// 테스트가 'A Timer is still pending' 으로 실패한다. 다 흘려보낸다.
Future<void> _settleToast(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
}

void main() {
  group('마스킹', () {
    test('이름 — 가운데를 가리고 앞뒤 한 글자만 남긴다', () {
      expect(maskName('김바이브'), '김**브');
      expect(maskName('최윤성'), '최*성');
      expect(maskName('김민'), '김*');
      expect(maskName('김'), '김*');
      expect(maskName(''), '-');
    });

    test('생년월일 — 연도만 남긴다', () {
      expect(maskBirth('1997.03.14'), '1997.**.**');
    });

    test('전화번호 — 가운데 토막만 가린다', () {
      expect(maskPhone('010-1234-5678'), '010-****-5678');
    });

    test('전화번호 형식이 다르면 손대지 않는다', () {
      // 세 토막이 아니면 어디를 가려야 하는지 알 수 없다 — 지어내지 않는다.
      expect(maskPhone('01012345678'), '01012345678');
    });
  });

  testWidgets('사진이 없으면 디자인 기본 프로필을 그린다 (이름 첫 글자 아님)', (tester) async {
    await _pump(tester, user: _user(nickname: '김바이브'));

    // 예전엔 아바타에 이름 첫 글자('김')를 넣어 실명이 노출됐다.
    // 기본 프로필은 글자 없는 실루엣이다.
    expect(find.text('김'), findsNothing);
    expect(find.byType(ProfilePhotoPicker), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('닉네임 칸이 users.nickname 을 읽고 글자수를 센다', (tester) async {
    await _pump(tester, user: _user(nickname: '김바이브'));

    expect(find.text('김바이브'), findsOneWidget);
    expect(find.text('4/12'), findsOneWidget);
    // 실명은 마스킹된 형태로만 보인다 — 그대로 노출되지 않는다.
    expect(find.text('최윤성'), findsNothing);
    expect(find.text('최*성'), findsOneWidget);
  });

  testWidgets('가입 정보는 기본 마스킹, 버튼을 누르면 전체를 보여준다', (tester) async {
    await _pump(tester, user: _user());

    expect(find.text('1997.**.**'), findsOneWidget);
    expect(find.text('010-****-5678'), findsOneWidget);

    // 카드가 스크롤 아래에 있어 탭하려면 먼저 보이게 해야 한다.
    await tester.ensureVisible(find.text('전체 정보 보기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('전체 정보 보기'));
    await tester.pump();

    expect(find.text('최윤성'), findsOneWidget);
    expect(find.text('1997.03.14'), findsOneWidget);
    expect(find.text('010-1234-5678'), findsOneWidget);
    // 가입 방식·성별은 영문 키가 아니라 한글 라벨로.
    expect(find.text('카카오'), findsOneWidget);
    expect(find.text('여성'), findsOneWidget);
  });

  testWidgets('바뀐 게 없으면 저장 버튼이 비활성', (tester) async {
    await _pump(tester, user: _user(nickname: '김바이브'));

    expect(tester.widget<RenewButton>(find.byType(RenewButton)).onTap, isNull);
  });

  testWidgets('형식에 맞지 않으면 저장 버튼이 비활성 + 오류 문구', (tester) async {
    await _pump(tester, user: _user(nickname: '김바이브'));

    await tester.enterText(find.byType(TextField), '가');
    await tester.pump();

    expect(find.textContaining('2자 이상'), findsOneWidget);
    expect(tester.widget<RenewButton>(find.byType(RenewButton)).onTap, isNull);
  });

  testWidgets('닉네임을 바꿔 저장하면 앞뒤 공백을 떼고 함수에 넘긴다', (tester) async {
    final repository = _FakeUserRepository();
    await _pump(
      tester,
      user: _user(nickname: '김바이브'),
      repository: repository,
    );

    await tester.enterText(find.byType(TextField), '  새벽의비트  ');
    await tester.pump();
    await tester.tap(find.byType(RenewButton));
    await tester.pumpAndSettle();
    await _settleToast(tester);

    expect(repository.saves, hasLength(1));
    expect(repository.saves.single.nickname, '새벽의비트');
    // 사진을 안 골랐으면 URL 은 아예 보내지 않는다 — 서버가 건드리지 않게.
    expect(repository.saves.single.photo, isNull);
  });

  testWidgets('서버 왕복이 길어 뷰모델이 먼저 dispose 돼도 저장 성공으로 처리한다', (tester) async {
    // `userViewModelProvider` 는 autoDispose 인데 화면이 `read(.notifier)` 로만
    // 잡는다 — 첫 await 뒤엔 이미 dispose 돼 있다. 그 뒤에 `state` 를 건드리면
    // UnmountedRefException 이 나서 **문서는 갱신됐는데** 실패 토스트가 떴다
    // (뒤로 가면 새 사진이 보이는 게 그 증거였다).
    final repository = _FakeUserRepository()
      ..delay = const Duration(milliseconds: 100);
    await _pump(
      tester,
      user: _user(nickname: '김바이브'),
      repository: repository,
    );

    await tester.enterText(find.byType(TextField), '새벽의비트');
    await tester.pump();
    await tester.tap(find.byType(RenewButton));
    await tester.pumpAndSettle();

    expect(repository.saves, hasLength(1));
    expect(find.text('저장에 실패했어요. 다시 시도해 주세요'), findsNothing);
    expect(find.text('변경 내용을 저장했어요'), findsOneWidget);
    await _settleToast(tester);
  });

  testWidgets('중복 닉네임은 입력칸 아래 오류로 보여주고 화면을 닫지 않는다', (tester) async {
    final repository = _FakeUserRepository()
      ..failWith = const NicknameTakenException();
    await _pump(
      tester,
      user: _user(nickname: '김바이브'),
      repository: repository,
    );

    await tester.enterText(find.byType(TextField), '바이브');
    await tester.pump();
    await tester.tap(find.byType(RenewButton));
    await tester.pumpAndSettle();

    expect(find.text('이미 사용 중인 닉네임이에요'), findsOneWidget);
    // 화면이 그대로 남아 값을 고칠 수 있어야 한다.
    expect(find.byType(ProfileEditScreen), findsOneWidget);
  });

  testWidgets('입력을 고치면 서버 오류 문구가 사라진다', (tester) async {
    final repository = _FakeUserRepository()
      ..failWith = const NicknameTakenException();
    await _pump(
      tester,
      user: _user(nickname: '김바이브'),
      repository: repository,
    );

    await tester.enterText(find.byType(TextField), '바이브');
    await tester.pump();
    await tester.tap(find.byType(RenewButton));
    await tester.pumpAndSettle();
    expect(find.text('이미 사용 중인 닉네임이에요'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '바이브2');
    await tester.pump();
    expect(find.text('이미 사용 중인 닉네임이에요'), findsNothing);
  });

  testWidgets('닉네임이 12자를 넘게 입력되지 않는다', (tester) async {
    await _pump(tester, user: _user(nickname: '김바이브'));

    await tester.enterText(find.byType(TextField), '가나다라마바사아자차카타파하');
    await tester.pump();

    expect(find.text('12/12'), findsOneWidget);
  });
}
