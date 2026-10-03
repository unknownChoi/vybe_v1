import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/datasources/payment_gateway.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';

/// 결제창 스텁.
///
// TODO[외부API] 설계 7장 · [임시]
/// 실제 PG 를 붙이지 않는다. 성공 · 실패를 고를 수 있게만 둔다 —
/// 개발 메뉴에서 [FakeScenario.failure] 를 고르면 '카드 승인 거절'로 떨어진다.
class FakePaymentGateway implements PaymentGateway {
  @override
  Future<PaymentResult> requestPayment({
    required String paymentId,
    required PaymentMethod method,
    String? cardCompany,
    int installment = 0,
  }) async {
    // 결제창이 뜨는 시간을 흉내 낸다.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (fakeScenario.value == FakeScenario.failure) {
      // 디자인 FEE-075 의 실패 사유 문구 그대로.
      return const PaymentResult(success: false, failReason: '카드 승인 거절');
    }
    return const PaymentResult(success: true);
  }
}

/// 본인인증 스텁.
///
// TODO[외부API] 설계 7장 · [임시]
/// ⚠ 베타의 PortOne 연동은 **건드리지 않는다**. 이 스텁은 v1 신규 화면 전용이다.
class FakeIdentityVerifyGateway implements IdentityVerifyGateway {
  @override
  Future<bool> verify({required String name, required String phone}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return fakeScenario.value != FakeScenario.failure;
  }
}

/// 알림톡 · SMS 스텁.
///
// TODO[외부API] 설계 7장 · [임시]
class FakeMessagingGateway implements MessagingGateway {
  @override
  Future<bool> send({required String to, required String templateId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return fakeScenario.value != FakeScenario.failure;
  }
}

/// 계좌 실명 확인 스텁.
///
// TODO[외부API] 설계 7장 · [임시]
class FakeBankAccountGateway implements BankAccountGateway {
  @override
  Future<bool> verifyHolder({
    required String bankCode,
    required String accountNo,
    required String holderName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return fakeScenario.value != FakeScenario.failure;
  }
}
