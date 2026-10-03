import 'package:vybe/core/utils/date_format.dart';

/// 탈퇴 대기(보관 기간) 중인 계정으로 로그인·가입을 시도했을 때.
///
/// Cloud Functions 가 `failed-precondition` + `details.purgeAt` 으로 거부한 것을
/// datasource 가 이 타입으로 바꿔 던진다. 화면은 `toString()` 을 그대로 토스트에
/// 띄우면 되도록 사용자 문구를 여기서 만든다.
class AccountPendingDeletionException implements Exception {
  /// 완전 파기 예정 시각 = 재가입 가능 시점. 서버가 안 실어 보내면 null.
  final DateTime? purgeAt;

  const AccountPendingDeletionException(this.purgeAt);

  @override
  String toString() {
    if (purgeAt == null) {
      return '탈퇴 처리 중인 계정입니다. 잠시 후 다시 시도해주세요.';
    }
    return '탈퇴 처리 중인 계정입니다. ${fmtDateDot(purgeAt!)} 이후 다시 가입할 수 있어요.';
  }
}

/// 진행 중인 티켓이 남아 **탈퇴가 보류**된 경우.
///
/// 설계 17장 ②-30 '탈퇴 시 활성 티켓 — 활성 웨이팅·예약·주문·미완료 환불
/// 있으면 탈퇴 보류' · 6-X MY-029 위젯 '진행 중 예약·웨이팅이 있으면
/// `failed-precondition`' [임시_차선책].
///
/// ⚠ 베타 서버는 이 검사를 하지 않는다 — 함수에 활성 티켓 검사가 들어가기
/// 전까지 이 예외는 올라오지 않는다(화면 분기만 먼저 둔다).
/// 서버가 거부 사유를 `details.blockers` 에 실어 주면 그 문구를 쓰고,
/// 없으면 설계 문구를 그대로 쓴다 — 원시 함수 오류를 토스트로 흘리면
/// 사용자는 "탈퇴가 왜 안 되는지"를 알 수 없다.
class AccountDeletionBlockedException implements Exception {
  /// 서버가 알려준 보류 사유 목록(`웨이팅`·`예약`·`주문`·`환불` 등).
  /// 비어 있으면 종류를 모르는 것이다.
  final List<String> blockers;

  const AccountDeletionBlockedException([this.blockers = const []]);

  @override
  String toString() => blockers.isEmpty
      ? '진행 중인 웨이팅·예약·주문이나 완료되지 않은 환불이 있어 지금은 탈퇴할 수 없어요. '
            '모두 끝난 뒤 다시 시도해 주세요.'
      : '진행 중인 ${blockers.join(' · ')}이(가) 있어 지금은 탈퇴할 수 없어요. '
            '모두 끝난 뒤 다시 시도해 주세요.';
}
