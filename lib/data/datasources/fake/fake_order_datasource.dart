import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/datasources/order_datasource.dart';
import 'package:vybe/data/models/v1/order_model.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

/// 메모리 Fake. Firebase 호출 없음.
class FakeOrderDataSource implements OrderDataSource {
  @override
  Stream<List<OrderModel>> watchMyOrders(String uid) async* {
    await fakeGate();
    yield switch (fakeScenario.value) {
      FakeScenario.empty => const [],
      FakeScenario.expired => [FakeSample.orderRejected],
      FakeScenario.closed => [FakeSample.orderReady],
      _ => [FakeSample.orderMaking],
    };
  }

  @override
  Stream<OrderModel?> watchOrder(String clubId, String orderId) async* {
    await fakeGate();
    yield switch (fakeScenario.value) {
      FakeScenario.empty => null,
      FakeScenario.expired => FakeSample.orderRejected,
      FakeScenario.closed => FakeSample.orderReady,
      FakeScenario.locked => FakeSample.order,
      _ => FakeSample.orderMaking,
    };
  }

  @override
  Future<OrderModel> createOrder({
    required String clubId,
    required EntryRef entryRef,
    required List<OrderLine> lines,
  }) async {
    await fakeGate();
    // 총액은 서버가 확정한다 — Fake 도 받은 줄 합계로 '정해 준다'.
    final total = lines.fold(0, (s, l) => s + l.lineTotal);
    return FakeSample.order.copyWith(
      entryRef: entryRef,
      lines: lines,
      total: total,
      status: OrderStatus.paid,
    );
  }

  @override
  Future<void> cancelOrder(String clubId, String orderId) => fakeGate();
}
