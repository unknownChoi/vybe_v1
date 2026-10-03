import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/data/models/notice_model.dart';

/// HOME-008 #2 — 파트너 대상 공지가 사용자 앱에 새지 않는지.
///
/// [베타 버전 수정] 설계 17장 ③ #14 `notices.audience` (user|partner).
/// 목록·단건이 같은 판정을 쓰므로 [NoticeModel.isVisibleAt] 한 곳만 본다.

NoticeModel _notice({String audience = 'user', bool isActive = true}) =>
    NoticeModel(
      noticeId: 'n1',
      title: '공지',
      content: '본문',
      audience: audience,
      isActive: isActive,
      publishedAt: DateTime(2026, 1, 1),
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

void main() {
  final now = DateTime(2026, 6, 1);

  test('필드가 없는 베타 문서는 사용자 공지로 본다', () {
    // 백필 전 문서에도 기본값이 들어가야 목록이 통째로 비지 않는다.
    expect(_notice().audience, 'user');
    expect(_notice().isVisibleAt(now), isTrue);
  });

  test('파트너 대상 공지는 사용자 앱 목록·상세 모두에서 빠진다', () {
    expect(_notice(audience: 'partner').isVisibleAt(now), isFalse);
  });

  test('대상 판정이 게시 상태보다 앞선다', () {
    // 둘 다 막혀야 하는 조합에서 순서가 바뀌어도 결과가 같은지.
    expect(
      _notice(audience: 'partner', isActive: false).isVisibleAt(now),
      isFalse,
    );
  });
}
