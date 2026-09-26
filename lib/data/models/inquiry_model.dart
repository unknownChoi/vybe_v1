import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/core/utils/date_format.dart';

part 'inquiry_model.freezed.dart';

/// 고객센터 문의 1건 (`inquiries/{inquiryId}`).
///
/// 사용자가 쓰고 운영자가 답변한다 — 답변(`answer`·`status`·`answeredAt`)은
/// 운영자만 쓰고(현재는 Firebase 콘솔) 앱에서는 **읽기만** 한다(Rules 가 막는다).
/// 앱이 쓰는 필드는 생성 시 전체 + 이후 `readAt` 하나뿐.
@freezed
abstract class InquiryModel with _$InquiryModel {
  const InquiryModel._();

  const factory InquiryModel({
    required String inquiryId,
    required String userId,

    /// 표시 이름. 어드민은 users 문서를 못 읽어(read: 본인만) 여기 비정규화한다.
    @Default('') String userName,

    /// 문의 유형 — "service"|"bug"|"report"|"account"|"etc" 영문 키만 저장.
    /// 한글 라벨은 화면(`support_models.dart`)이 붙인다.
    @Default('etc') String category,
    required String title,
    required String content,
    @Default(<String>[]) List<String> imageUrls,

    /// "pending" | "answered". 값이 늘어날 수 있으므로 판정은 [isAnswered] 한 곳에서.
    @Default('pending') String status,
    @Default('') String answer,
    DateTime? answeredAt,
    @Default('') String answeredBy,

    /// 사용자가 답변을 확인한 시각. null 이면 미확인 = 배지 대상.
    DateTime? readAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InquiryModel;

  /// 답변이 달렸는지. 상태 문자열이 늘어나도 여기만 고친다.
  bool get isAnswered => status == 'answered';

  /// 답변이 왔는데 아직 안 본 문의 — 마이페이지 배지·목록 점의 기준.
  bool get hasUnreadAnswer => isAnswered && readAt == null;

  /// 표시용 날짜 (예: 2026.09.06)
  String get dateLabel => fmtDateDot(createdAt.toLocal());

  /// 답변 도착일 표기. 미답변이면 빈 문자열.
  String get answeredDateLabel {
    final d = answeredAt?.toLocal();
    return d == null ? '' : fmtDateDot(d);
  }

  factory InquiryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final createdAt =
        (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    return InquiryModel(
      inquiryId: data['inquiryId'] as String? ?? doc.id,
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? '',
      category: data['category'] as String? ?? 'etc',
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      imageUrls: List<String>.from(data['imageUrls'] as List? ?? []),
      status: data['status'] as String? ?? 'pending',
      answer: data['answer'] as String? ?? '',
      answeredAt: (data['answeredAt'] as Timestamp?)?.toDate(),
      answeredBy: data['answeredBy'] as String? ?? '',
      readAt: (data['readAt'] as Timestamp?)?.toDate(),
      createdAt: createdAt,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? createdAt,
    );
  }

  /// 문의 생성 payload.
  ///
  /// ⚠ `status`·`answer`·`answeredAt`·`answeredBy`·`readAt` 을 **반드시 같이 쓴다** —
  /// Rules 의 create 규칙이 값까지 검사하고(`status=='pending'`, `answer==''`),
  /// 목록·배지 판정이 필드가 있다는 전제로 돈다. 하나라도 빠지면 문서 생성이 403.
  Map<String, dynamic> toFirestore() => {
    'inquiryId': inquiryId,
    'userId': userId,
    'userName': userName,
    'category': category,
    'title': title,
    'content': content,
    'imageUrls': imageUrls,
    'status': 'pending',
    'answer': '',
    'answeredAt': null,
    'answeredBy': '',
    'readAt': null,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
