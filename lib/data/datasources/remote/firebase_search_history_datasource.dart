import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vybe/core/utils/firebase_logger.dart';
import 'package:vybe/data/datasources/remote/firestore_paths.dart';
import 'package:vybe/data/models/search_history_model.dart';

class FirebaseSearchHistoryDataSource {
  final FirebaseFirestore _firestore;

  FirebaseSearchHistoryDataSource() : _firestore = FirebaseFirestore.instance;

  Future<List<SearchHistoryModel>> getSearchHistory(String userId) async {
    logFirebaseAccess('Firestore(users/$userId/searchHistory)', '최근 검색어 목록 표시');
    final snapshot = await _firestore
        .collection(FirestorePaths.users)
        .doc(userId)
        .collection(FirestorePaths.searchHistory)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();
    // upsert 도입(2026.09.15) 전 자동 id 문서가 같은 검색어로 남아 있을 수 있다 —
    // 최신(정렬 앞)만 남기고, 숨긴 중복은 이미 읽은 문서라 추가 read 없이 batch 로
    // 지운다(안 지우면 keyed 문서를 삭제했을 때 숨겨졌던 옛 문서가 되살아난다).
    final seen = <String>{};
    final batch = _firestore.batch();
    var dup = 0;
    final result = <SearchHistoryModel>[];
    for (final doc in snapshot.docs) {
      final d = SearchHistoryModel.fromFirestore(doc);
      if (seen.add(d.keyword)) {
        result.add(d);
      } else {
        batch.delete(doc.reference);
        dup++;
      }
    }
    if (dup > 0) unawaited(batch.commit());
    return result;
  }

  /// 검색어 저장 — 문서 id 가 검색어 자체(base64url)라 같은 검색어는 **자리를 덮는다**.
  /// 예전엔 where 쿼리(1 read) + 삭제 batch 로 중복을 걷어냈다.
  ///
  /// delete → set 두 번인 이유 — Rules 가 `create, delete` 만 열어 두고 `update`
  /// 는 막아서 기존 문서에 `set` 을 바로 얹으면 permission-denied 다. Rules 에
  /// update 를 열면 `set` 한 번으로 줄일 수 있다(0 read 인 건 지금도 같다).
  Future<void> addSearchHistory(String userId, String keyword) async {
    logFirebaseAccess(
      'Firestore(users/$userId/searchHistory)',
      '검색어 "$keyword" 저장 (같은 검색어는 덮어쓰기)',
    );
    final doc = _firestore
        .collection(FirestorePaths.users)
        .doc(userId)
        .collection(FirestorePaths.searchHistory)
        .doc(SearchHistoryModel.idFor(keyword));
    await doc.delete();
    await doc.set({
      'userId': userId,
      'keyword': keyword,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteSearchHistory(String userId, String historyId) async {
    logFirebaseAccess(
      'Firestore(users/$userId/searchHistory/$historyId)',
      '최근 검색어 개별 삭제',
    );
    await _firestore
        .collection(FirestorePaths.users)
        .doc(userId)
        .collection(FirestorePaths.searchHistory)
        .doc(historyId)
        .delete();
  }

  Future<void> clearAllSearchHistory(String userId) async {
    logFirebaseAccess('Firestore(users/$userId/searchHistory)', '최근 검색어 전체 삭제');
    final snapshot = await _firestore
        .collection(FirestorePaths.users)
        .doc(userId)
        .collection(FirestorePaths.searchHistory)
        .get();
    if (snapshot.docs.isEmpty) return;

    // 순차 await 대신 batch 삭제. 문서는 검색어(중복 제거)마다 1개씩 쌓여
    // 보통 수십 개지만, batch 쓰기 한도(500)를 넘지 않게 잘라서 커밋한다.
    const chunkSize = 400;
    for (var i = 0; i < snapshot.docs.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, snapshot.docs.length);
      final batch = _firestore.batch();
      for (final doc in snapshot.docs.sublist(i, end)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }
}
