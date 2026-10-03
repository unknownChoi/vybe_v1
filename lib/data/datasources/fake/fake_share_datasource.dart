import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/datasources/share_datasource.dart';
import 'package:vybe/data/models/v1/share_model.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';

/// 메모리 Fake. Firebase 호출 없음.
///
/// 비밀번호는 디자인 기본값 `000000` 만 통과한다 — 틀리면 남은 시도가 줄어드는
/// 화면(SHARE-081)을 확인할 수 있다.
class FakeShareDataSource implements ShareDataSource {
  static const String _password = '000000';

  int _attempts = 0;

  @override
  Stream<List<SharedTicketModel>> watchReceivedTickets(String uid) async* {
    await fakeGate();
    yield switch (fakeScenario.value) {
      FakeScenario.empty => const [],
      FakeScenario.expired => [
        FakeSample.sharedTicket.copyWith(status: SharedTicketStatus.expired),
      ],
      _ => [FakeSample.sharedTicket],
    };
  }

  @override
  Future<String> createShareLink({
    required String clubId,
    required EntryRefType ticketType,
    required String ticketId,
    required String password,
  }) async {
    await fakeGate();
    return FakeSample.shareSerial;
  }

  @override
  Future<void> stopShareLink(String serial) => fakeGate();

  @override
  Future<SharePreviewModel?> lookupShareLink(String serial) async {
    await fakeGate();
    return switch (fakeScenario.value) {
      FakeScenario.empty => null,
      FakeScenario.expired => FakeSample.sharePreview.copyWith(
        status: ShareLinkStatus.expired,
      ),
      FakeScenario.locked => FakeSample.sharePreview.copyWith(
        remainAttempts: 0,
        lockedUntil: DateTime.now().add(ShareLinkRule.lockDuration),
      ),
      _ => FakeSample.sharePreview.copyWith(
        remainAttempts: ShareLinkRule.maxAttempts - _attempts,
      ),
    };
  }

  @override
  Future<SharedTicketModel> claimShareLink({
    required String serial,
    required String password,
  }) async {
    await fakeGate();
    if (password != _password) {
      _attempts++;
      throw FakeDataException(
        '비밀번호가 달라요 · 남은 시도 '
        '${ShareLinkRule.maxAttempts - _attempts}회',
      );
    }
    _attempts = 0;
    return FakeSample.sharedTicket;
  }
}
