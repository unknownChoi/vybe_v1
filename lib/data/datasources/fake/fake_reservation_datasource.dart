import 'package:vybe/data/datasources/fake/fake_sample_data.dart';
import 'package:vybe/data/datasources/fake/fake_scenario.dart';
import 'package:vybe/data/datasources/reservation_datasource.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/models/v1/reservation_model.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/data/models/v1/v1_shared.dart';

/// 메모리 Fake. Firebase 호출 없음.
class FakeReservationDataSource implements ReservationDataSource {
  @override
  Stream<List<ReservationModel>> watchMyReservations(String uid) async* {
    await fakeGate();
    yield switch (fakeScenario.value) {
      FakeScenario.empty => const [],
      FakeScenario.expired => [FakeSample.reservationNoShow],
      FakeScenario.locked => [FakeSample.reservationConverted],
      // 디자인 예약 목록 3건 — 확정 · 접수됨 · 취소됨.
      _ => [
        FakeSample.reservation,
        FakeSample.reservationPending,
        FakeSample.reservation.copyWith(
          reservationId: 'rs_1180',
          status: ReservationStatus.cancelled,
        ),
      ],
    };
  }

  @override
  Stream<ReservationModel?> watchReservation(
    String clubId,
    String reservationId,
  ) async* {
    await fakeGate();
    yield switch (fakeScenario.value) {
      FakeScenario.empty => null,
      FakeScenario.expired => FakeSample.reservationNoShow,
      FakeScenario.locked => FakeSample.reservationConverted,
      _ => FakeSample.reservation,
    };
  }

  @override
  Future<ReservationDayModel?> getReservationDay(
    String clubId,
    String date,
  ) async {
    await fakeGate();
    if (fakeScenario.value == FakeScenario.empty) return null;
    if (fakeScenario.value == FakeScenario.closed) {
      return FakeSample.reservationDay.copyWith(closed: true);
    }
    return FakeSample.reservationDay;
  }

  @override
  Future<ReservationModel> createReservation({
    required String clubId,
    required String date,
    required String arrivalSlot,
    required int people,
    required String tableId,
    required List<OrderLine> menuLines,
    required ReservationGuest guest,
    required String policyVersion,
  }) async {
    await fakeGate();
    final subtotal = menuLines.fold(0, (s, l) => s + l.lineTotal);
    return FakeSample.reservation.copyWith(
      date: date,
      arrivalSlot: arrivalSlot,
      people: people,
      tableId: tableId,
      menuLines: menuLines,
      menuSubtotal: subtotal,
      totalPaid: subtotal,
      guest: guest,
      policyVersion: policyVersion,
      status: ReservationStatus.pending,
    );
  }

  @override
  Future<ReservationCancel> previewCancel(
    String clubId,
    String reservationId,
  ) async {
    await fakeGate();
    // 디자인 RSV-092 — d2 구간: 테이블 20% · 메뉴 0% · 취소 수수료 3%.
    return const ReservationCancel(
      bucket: CancelBucket.d2,
      penalties: [
        PenaltyLine(kind: PenaltyKind.table, rate: 20, amount: 60000),
        PenaltyLine(kind: PenaltyKind.cancelFee, rate: 3, amount: 30000),
      ],
      penaltyTotal: 90000,
      refundAmount: 910000,
    );
  }

  @override
  Future<ReservationCancel> cancelReservation(
    String clubId,
    String reservationId,
  ) async {
    final preview = await previewCancel(clubId, reservationId);
    return preview.copyWith(at: DateTime.now(), by: CancelledBy.user);
  }

  @override
  Future<EntryQrToken> issueEntryQr(String clubId, String reservationId) async {
    await fakeGate();
    final now = DateTime.now();
    final issued = fakeScenario.value == FakeScenario.expired
        ? now.subtract(EntryQrToken.validity)
        : now;
    return EntryQrToken(
      token: 'fake.$clubId.$reservationId.${issued.millisecondsSinceEpoch}',
      issuedAt: issued,
      expiresAt: issued.add(EntryQrToken.validity),
    );
  }

  @override
  Future<void> hideReservation(String clubId, String reservationId) =>
      fakeGate();
}
