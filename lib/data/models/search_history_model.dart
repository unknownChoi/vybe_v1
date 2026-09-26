import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history_model.freezed.dart';

@freezed
abstract class SearchHistoryModel with _$SearchHistoryModel {
  const SearchHistoryModel._();

  /// 문서 id = 검색어(base64url) — 같은 검색어는 한 자리를 덮는다(upsert 키).
  /// datasource 쓰기와 화면의 메모리 갱신([addLocal])이 같은 식을 써야
  /// 방금 넣은 칩의 삭제가 실제 문서를 지운다.
  static String idFor(String keyword) =>
      base64Url.encode(utf8.encode(keyword.trim()));

  const factory SearchHistoryModel({
    required String historyId,
    required String userId,
    required String keyword,
    required DateTime createdAt,
  }) = _SearchHistoryModel;

  factory SearchHistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SearchHistoryModel(
      historyId: doc.id,
      userId: data['userId'] as String? ?? '',
      keyword: data['keyword'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
