import 'package:vybe/data/models/v1/share_model.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';

/// 입장권 공유 datasource 인터페이스. Firebase import 금지.
///
/// ⚠ 공유받은 사람의 개인정보는 **어느 응답에도 담기지 않는다**(확정 정책).
/// 원본 소유자는 받은 횟수와 시각만 본다.
abstract interface class ShareDataSource {
  /// 내가 공유받은 입장권들.
  Stream<List<SharedTicketModel>> watchReceivedTickets(String uid);

  /// 공유 링크 만들기 — 비밀번호 6자리를 함께 건다.
  Future<String> createShareLink({
    required String clubId,
    required EntryRefType ticketType,
    required String ticketId,
    required String password,
  });

  /// 공유 중지.
  Future<void> stopShareLink(String serial);

  /// 일련번호로 미리보기 조회(비밀번호 입력 전).
  Future<SharePreviewModel?> lookupShareLink(String serial);

  /// 비밀번호를 넣고 받기. 5회 틀리면 30분 잠긴다.
  Future<SharedTicketModel> claimShareLink({
    required String serial,
    required String password,
  });
}
