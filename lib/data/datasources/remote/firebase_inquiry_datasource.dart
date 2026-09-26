import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vybe/core/utils/firebase_logger.dart';
import 'package:vybe/data/datasources/remote/firestore_paths.dart';
import 'package:vybe/data/models/inquiry_model.dart';

/// 고객센터 문의 (`inquiries`).
///
/// 앱은 **자기 문의만** 읽고 쓴다 — 답변(`answer`·`status`)은 운영자가 쓰고
/// Rules 가 사용자 쪽 수정을 `readAt` 하나로 막는다.
class FirebaseInquiryDataSource {
  final FirebaseFirestore _firestore;

  FirebaseInquiryDataSource() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.inquiries);

  /// 문서 id 선발급 — 사진을 `inquiries/{uid}/{inquiryId}/`에 먼저 올려야 해서
  /// 문서 생성 전에 id 가 필요하다 (리뷰 작성과 같은 순서).
  String newInquiryId() => _col.doc().id;

  Future<void> createInquiry(InquiryModel inquiry) {
    logFirebaseAccess(
      'Firestore(inquiries/${inquiry.inquiryId})',
      '고객센터 문의 등록',
    );
    return _col.doc(inquiry.inquiryId).set(inquiry.toFirestore());
  }

  /// 내 문의 목록 (최신순). 어드민이 답변을 달면 화면이 바로 바뀌도록 스트림.
  /// 인덱스: `inquiries(userId ASC, createdAt DESC)`.
  Stream<List<InquiryModel>> watchMyInquiries(String userId) {
    logFirebaseAccess(
      'Firestore(inquiries) [where userId=$userId, orderBy createdAt desc]',
      '고객센터 내 문의 목록 구독',
    );
    return _col
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map(InquiryModel.fromFirestore).toList());
  }

  /// 답변을 확인한 시각 기록. 상세를 처음 열 때 **1회**만 부른다.
  ///
  /// Rules 가 사용자 update 를 `readAt` 한 키로만 허용하므로 다른 필드를 같이
  /// 쓰면 통째로 거부된다(`updatedAt` 도 여기서 건드리지 않는다).
  Future<void> markAnswerRead(String inquiryId) {
    logFirebaseAccess(
      'Firestore(inquiries/$inquiryId) [update readAt]',
      '문의 답변 확인 시각 기록 (미확인 배지 해제)',
    );
    return _col.doc(inquiryId).update({'readAt': FieldValue.serverTimestamp()});
  }
}
