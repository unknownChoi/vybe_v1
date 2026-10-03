import 'package:vybe/data/models/v1/v1_enums.dart';

/// 결제(PG) 게이트웨이 인터페이스.
///
// TODO[외부API] 설계 7장 · [임시]
/// **v1 작업에서 실제 PG 를 붙이지 않는다**(CLAUDE.md: 결제 · 본인인증 신규 연동 ·
/// 알림톡 · SMS · 계좌 실명 확인은 인터페이스와 스텁만 둔다).
/// 실제 승인 · 취소는 서버(onCall + PG 웹훅)가 하고, 앱은 결제창을 띄우고 결과만 받는다.
abstract interface class PaymentGateway {
  /// 결제창을 띄우고 결과를 기다린다.
  ///
  /// ⚠ **금액을 받지 않는다** — 서버가 만든 [paymentId] 로만 진행한다.
  Future<PaymentResult> requestPayment({
    required String paymentId,
    required PaymentMethod method,
    String? cardCompany,
    int installment = 0,
  });
}

/// 결제창 결과.
class PaymentResult {
  const PaymentResult({
    required this.success,
    this.failReason = '',
  });

  final bool success;

  /// 디자인 예시 — '카드 승인 거절'.
  final String failReason;
}

/// 본인인증 인터페이스.
///
// TODO[외부API] 설계 7장 · [임시]
/// 베타의 PortOne 연동은 **건드리지 않는다**. v1 신규 연동은 하지 않는다.
abstract interface class IdentityVerifyGateway {
  Future<bool> verify({required String name, required String phone});
}

/// 알림톡 · SMS 발송 인터페이스.
///
// TODO[외부API] 설계 7장 · [임시]
abstract interface class MessagingGateway {
  Future<bool> send({required String to, required String templateId});
}

/// 계좌 실명 확인 인터페이스.
///
// TODO[외부API] 설계 7장 · [임시]
abstract interface class BankAccountGateway {
  Future<bool> verifyHolder({
    required String bankCode,
    required String accountNo,
    required String holderName,
  });
}
