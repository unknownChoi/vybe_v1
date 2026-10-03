import 'package:vybe/data/models/v1/order_model.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

/// 비대면 주문 datasource 인터페이스. Firebase import 금지.
abstract interface class OrderDataSource {
  /// 내 진행 중 주문(패스월렛 주문 탭).
  Stream<List<OrderModel>> watchMyOrders(String uid);

  Stream<OrderModel?> watchOrder(String clubId, String orderId);

  /// 주문 생성. 총액을 보내지 않는다 — 메뉴 ID · 수량 · 옵션만 보낸다.
  Future<OrderModel> createOrder({
    required String clubId,
    required EntryRef entryRef,
    required List<OrderLine> lines,
  });

  /// 주문 취소. 조리 시작 전까지만 된다(서버가 판정).
  Future<void> cancelOrder(String clubId, String orderId);
}
