import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/core/config/backend_env.dart';
import 'package:vybe/data/datasources/club_ops_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_club_ops_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_notification_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_order_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_payment_gateway.dart';
import 'package:vybe/data/datasources/fake/fake_reservation_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_share_datasource.dart';
import 'package:vybe/data/datasources/fake/fake_waiting_datasource.dart';
import 'package:vybe/data/datasources/notification_datasource.dart';
import 'package:vybe/data/datasources/order_datasource.dart';
import 'package:vybe/data/datasources/payment_gateway.dart';
import 'package:vybe/data/datasources/reservation_datasource.dart';
import 'package:vybe/data/datasources/share_datasource.dart';
import 'package:vybe/data/datasources/waiting_datasource.dart';

/// v1 신규 기능의 datasource 를 고르는 **유일한 자리**.
///
/// CLAUDE.md ⭐ v1 개발 규칙 — "어느 구현을 쓸지는 datasource **provider 한 곳**에서만 고른다.
/// Repository · ViewModel · 화면은 어떤 구현이 붙었는지 모른다."
///
/// 선택은 `--dart-define=VYBE_BACKEND` ([kVybeBackend]) 가 한다.
/// 백엔드 단계에서 `remote/firebase_*_datasource.dart` 를 만들고 아래 분기에만 추가한다.
///
/// ⚠ **베타 기능(클럽 · 리뷰 · 찜 · 검색 · 인증)은 여기 없다** — 그쪽은 늘 Firebase 다.

/// 백엔드 단계 전까지는 Fake 만 있다. 그때 이 함수에 분기를 더한다.
Never _notImplemented(String feature) => throw UnimplementedError(
  '$feature 의 ${kVybeBackend.name} 구현이 아직 없다 — '
  'UI 단계에서는 --dart-define=VYBE_BACKEND=fake 로 실행한다.',
);

/// 비대면 웨이팅.
final waitingDataSourceProvider = Provider<WaitingDataSource>((ref) {
  if (kUsesFakeBackend) return FakeWaitingDataSource();
  _notImplemented('WaitingDataSource');
});

/// 테이블 예약.
final reservationDataSourceProvider = Provider<ReservationDataSource>((ref) {
  if (kUsesFakeBackend) return FakeReservationDataSource();
  _notImplemented('ReservationDataSource');
});

/// 비대면 주문.
final orderDataSourceProvider = Provider<OrderDataSource>((ref) {
  if (kUsesFakeBackend) return FakeOrderDataSource();
  _notImplemented('OrderDataSource');
});

/// 알림 센터 · 알림 설정 (HOME-005 배지 · HOME-007 · MY-029 토글).
///
/// ⚠ **keepAlive 가 기본** — Fake 가 설정값을 인스턴스에 들고 있어서,
/// 화면을 닫을 때 provider 가 버려지면 토글이 기본값으로 되돌아간다.
final notificationDataSourceProvider = Provider<NotificationDataSource>((ref) {
  if (kUsesFakeBackend) return FakeNotificationDataSource();
  _notImplemented('NotificationDataSource');
});

/// 클럽 실시간 운영 상태 (`ops/live` — 지도 핀 대기 팀 수 · 클럽 상세).
final clubOpsDataSourceProvider = Provider<ClubOpsDataSource>((ref) {
  if (kUsesFakeBackend) return FakeClubOpsDataSource();
  _notImplemented('ClubOpsDataSource');
});

/// 입장권 공유.
final shareDataSourceProvider = Provider<ShareDataSource>((ref) {
  if (kUsesFakeBackend) return FakeShareDataSource();
  _notImplemented('ShareDataSource');
});

/// 결제(PG).
///
// TODO[외부API] 설계 7장 · [임시]
/// v1 작업에서 실제 PG 는 붙이지 않는다 — 스텁만 둔다.
final paymentGatewayProvider = Provider<PaymentGateway>(
  (ref) => FakePaymentGateway(),
);

/// 본인인증.
///
// TODO[외부API] 설계 7장 · [임시]
final identityVerifyGatewayProvider = Provider<IdentityVerifyGateway>(
  (ref) => FakeIdentityVerifyGateway(),
);

/// 알림톡 · SMS.
///
// TODO[외부API] 설계 7장 · [임시]
final messagingGatewayProvider = Provider<MessagingGateway>(
  (ref) => FakeMessagingGateway(),
);

/// 계좌 실명 확인.
///
// TODO[외부API] 설계 7장 · [임시]
final bankAccountGatewayProvider = Provider<BankAccountGateway>(
  (ref) => FakeBankAccountGateway(),
);
