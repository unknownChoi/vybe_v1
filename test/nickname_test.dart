import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/utils/nickname.dart';

// ============================================================
// 닉네임 규칙 — 경계값 + **서버 상수와의 일치**
//
// 앱의 규칙은 서버(`functions/src/profile/nickname.ts`)의 사본이다.
// 두 값이 어긋나면 앱이 통과시킨 입력이 서버에서 invalid-argument 로 튕기는데,
// 그건 저장 버튼을 눌러야 드러난다 — 여기서 잡는다.
// ============================================================

void main() {
  group('isValidNickname — 경계값', () {
    test('2~12자 한글·영문·숫자는 통과', () {
      for (final ok in [
        '가나',
        '바이브',
        'ab',
        'VYBE12',
        '신나는바이버4821', // 서버 랜덤 생성기 형식 — {앞말}바이버{4자리}
        '가나다라마바사아자차카타', // 12자
      ]) {
        expect(isValidNickname(ok), isTrue, reason: ok);
      }
    });

    test('1자·13자는 막는다', () {
      expect(isValidNickname('가'), isFalse);
      expect(isValidNickname('a'), isFalse);
      expect(isValidNickname('가나다라마바사아자차카타파'), isFalse); // 13자
    });

    test('공백·이모지·밑줄·특수문자는 막는다', () {
      for (final bad in [
        '',
        '  ',
        '바이 브', // 가운데 공백
        '바이브😀',
        'vybe_kim', // _ 는 Firestore 문서 ID 제약 때문에 뺐다
        'a.b',
        'a/b',
        '__vybe__',
      ]) {
        expect(isValidNickname(bad), isFalse, reason: '"$bad"');
      }
    });

    test('앞뒤 공백은 잘라서 본다', () {
      expect(isValidNickname('  바이브  '), isTrue);
    });

    test('단독 자모(ㅋㅋ·ㅇㅇ)는 막는다 — [가-힣] 범위 밖', () {
      expect(isValidNickname('ㅋㅋ'), isFalse);
      expect(isValidNickname('ㅇㅇㅇ'), isFalse);
    });
  });

  group('nicknameError — 문구', () {
    test('빈 입력은 오류로 보지 않는다 (아직 안 쓴 상태)', () {
      expect(nicknameError(''), isNull);
      expect(nicknameError('   '), isNull);
    });

    test('정상 입력은 오류 없음', () {
      expect(nicknameError('바이브'), isNull);
    });

    test('짧으면 길이 안내', () {
      expect(nicknameError('가'), contains('$kNicknameMin자 이상'));
    });

    test('길면 상한 안내', () {
      expect(
        nicknameError('가나다라마바사아자차카타파'),
        contains('$kNicknameMax자까지'),
      );
    });

    test('허용되지 않는 문자는 문자 안내', () {
      expect(nicknameError('vybe_kim'), contains('한글·영문·숫자'));
      expect(nicknameError('바이브😀'), contains('한글·영문·숫자'));
    });

    // 한글 IME 로 치는 동안 마지막 글자는 단독 자모로 남는다.
    // 이걸 형식 위반으로 잡으면 한 글자 칠 때마다 빨간 글씨가 번쩍인다.
    test('조합 중 자모는 오류를 띄우지 않는다 (저장은 여전히 막힌다)', () {
      expect(nicknameError('새벽ㅇ'), isNull);
      expect(isValidNickname('새벽ㅇ'), isFalse);

      expect(nicknameError('ㅅ'), isNull);
      expect(isValidNickname('ㅅ'), isFalse);
    });

    test('조합 중이어도 상한을 넘으면 안내한다', () {
      expect(
        nicknameError('가나다라마바사아자차카타파ㅎ'),
        contains('$kNicknameMax자까지'),
      );
    });
  });

  group('서버(nickname.ts)와 상수 일치', () {
    late final String server = File(
      'functions/src/profile/nickname.ts',
    ).readAsStringSync();

    test('최소·최대 길이가 같다', () {
      expect(
        server,
        contains('NICKNAME_MIN = $kNicknameMin'),
        reason: '서버 NICKNAME_MIN 이 앱 kNicknameMin($kNicknameMin)과 다르다',
      );
      expect(
        server,
        contains('NICKNAME_MAX = $kNicknameMax'),
        reason: '서버 NICKNAME_MAX 이 앱 kNicknameMax($kNicknameMax)과 다르다',
      );
    });

    test('허용 문자 클래스가 같다', () {
      // 서버: `^[가-힣a-zA-Z0-9]{${MIN},${MAX}}$`
      expect(
        server,
        contains('^[가-힣a-zA-Z0-9]{'),
        reason: '서버 정규식의 문자 클래스가 앱 kNicknamePattern 과 다르다',
      );
      expect(kNicknamePattern.pattern, contains('[가-힣a-zA-Z0-9]'));
    });

    test('랜덤 생성 형식이 앱 규칙을 통과한다', () {
      // `{앞말}바이버{4자리}` — 가장 긴 조합(4 + 3 + 4 = 11자)이 상한 안이어야
      // 배정된 닉네임을 사용자가 입력칸에 그대로 다시 쓸 수 있다.
      expect(isValidNickname('불꽃같은바이버1234'), isTrue);
      expect('불꽃같은바이버1234'.length, lessThanOrEqualTo(kNicknameMax));
    });
  });

  // 단어표가 규칙을 넘는 순간, 배정된 닉네임을 **사용자가 다시 입력할 수 없다**
  // (입력칸이 12자에서 끊긴다). 서버에만 있는 표라 앱 테스트가 대신 지킨다.
  group('서버 단어표(CLUB_WORDS) 검사', () {
    late final List<String> words = _serverClubWords();

    test('40개 · 중복 없음', () {
      expect(words, hasLength(40));
      expect(words.toSet(), hasLength(words.length));
    });

    test('전부 4자 이하 한글', () {
      for (final w in words) {
        expect(w.runes.length, lessThanOrEqualTo(4), reason: w);
        expect(RegExp(r'^[가-힣]+$').hasMatch(w), isTrue, reason: w);
      }
    });

    test('모든 조합이 앱 닉네임 규칙을 통과한다', () {
      for (final w in words) {
        // 뒤 4자리는 1000~9999 고정 폭이라 경계값만 보면 된다.
        for (final digits in [1000, 9999]) {
          final nickname = '$w바이버$digits';
          expect(
            isValidNickname(nickname),
            isTrue,
            reason: '$nickname (${nickname.runes.length}자)',
          );
          expect(nicknameError(nickname), isNull, reason: nickname);
        }
      }
    });

    test('금칙어를 품은 단어가 없다', () {
      // 서버가 생성값도 금칙어에 걸어 보므로, 표에 사칭 어휘가 섞이면
      // 그 단어를 뽑을 때마다 재시도가 돌아 배정이 느려진다.
      const banned = [
        '운영자',
        '운영팀',
        '관리자',
        '관리인',
        '고객센터',
        '고객지원',
        'vybe',
        'admin',
      ];
      for (final w in words) {
        final key = '$w바이버1234'.toLowerCase();
        for (final b in banned) {
          expect(key.contains(b), isFalse, reason: '$w ← $b');
        }
      }
    });
  });
}

/// `functions/src/profile/nickname.ts` 의 `CLUB_WORDS` 배열을 그대로 읽어 온다.
///
/// 표를 앱에 복사하지 않는 이유는 배정 주체가 서버 하나라서다 — 복사해 두면
/// 두 벌이 갈라진다. 대신 테스트가 원본을 파싱해 검사한다.
List<String> _serverClubWords() {
  final source = File('functions/src/profile/nickname.ts').readAsStringSync();
  final block = RegExp(
    r'const CLUB_WORDS = \[(.*?)\];',
    dotAll: true,
  ).firstMatch(source);
  expect(block, isNotNull, reason: '서버 nickname.ts 에서 CLUB_WORDS 를 못 찾았다');

  return RegExp(r'"([^"]+)"')
      .allMatches(block!.group(1)!)
      .map((m) => m.group(1)!)
      .toList();
}
