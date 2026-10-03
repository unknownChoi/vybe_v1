import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/models/v1/reservation_model.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

/// 테이블 예약 datasource 인터페이스. Firebase import 금지.
///
/// ⚠ 패널티 · 환불액 · 변경 수수료는 **서버가 계산**한다.
/// [previewCancel] 은 "지금 취소하면 얼마"를 서버에 물어보는 것이지 앱이 계산하는 게 아니다.
abstract interface class ReservationDataSource {
  /// 내 예약들(패스월렛 예약 탭).
  Stream<List<ReservationModel>> watchMyReservations(String uid);

  Stream<ReservationModel?> watchReservation(String clubId, String reservationId);

  /// 날짜별 예약 가능 상태(마감 날짜 · 잡힌 테이블).
  Future<ReservationDayModel?> getReservationDay(String clubId, String date);

  /// 예약 생성. 금액을 보내지 않는다 — 좌석 · 인원 · 메뉴 ID 만 보낸다.
  Future<ReservationModel> createReservation({
    required String clubId,
    required String date,
    required String arrivalSlot,
    required int people,
    required String tableId,
    required List<OrderLine> menuLines,
    required ReservationGuest guest,
    required String policyVersion,
  });

  /// 취소 미리보기 — 서버가 구간 · 패널티 · 환불액을 돌려준다.
  Future<ReservationCancel> previewCancel(String clubId, String reservationId);

  /// 예약 취소.
  Future<ReservationCancel> cancelReservation(String clubId, String reservationId);

  /// 입장 QR(전환된 예약 티켓).
  Future<EntryQrToken> issueEntryQr(String clubId, String reservationId);

  /// 종료된 예약 숨기기.
  Future<void> hideReservation(String clubId, String reservationId);
}
