import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:vybe/core/utils/firebase_logger.dart';
import 'package:vybe/data/datasources/remote/firestore_paths.dart';

class FirebaseStorageDataSource {
  final FirebaseStorage _storage;

  FirebaseStorageDataSource() : _storage = FirebaseStorage.instance;

  /// 프로필 사진 업로드 → 다운로드 URL 반환.
  /// 경로: `users/{uid}/profile_{millis}.jpg`
  ///
  /// ⚠ 첫 칸이 uid 다 — storage.rules 가 이 자리로 소유자를 판정하고,
  /// `updateUserProfile`(Functions)도 URL 이 이 경로인지 확인한다.
  /// ⚠ 파일명이 매번 달라 옛 사진은 **자동으로 사라지지 않는다** —
  /// 저장이 성공한 뒤 호출측이 [deleteFileByUrl] 로 지운다.
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    final fileName = StoragePaths.profileImageFileName();
    logFirebaseAccess('Storage(users/$uid/$fileName)', '프로필 이미지 업로드');
    final ref = _storage.ref(StoragePaths.profileImage(uid, fileName));
    await ref.putFile(imageFile);
    return ref.getDownloadURL();
  }

  /// 첨부 이미지 여러 장을 순서대로 업로드 → 다운로드 URL 목록(순서 유지).
  ///
  /// 리뷰(`reviews/{clubId}/{reviewId}/`)·문의(`inquiries/{uid}/{inquiryId}/`)가
  /// 같은 루프를 복붙해 쓰고 있어 합쳤다. [path] 가 i번째 파일의 Storage 경로를
  /// 정한다 — 확장자는 원본을 따르고 없으면 jpg.
  Future<List<String>> uploadIndexed(
    List<File> files,
    String Function(int i, String ext) path,
  ) async {
    final urls = <String>[];
    for (var i = 0; i < files.length; i++) {
      final raw = files[i].path.split('.').last.toLowerCase();
      final fullPath = path(i, raw.isEmpty ? 'jpg' : raw);
      logFirebaseAccess('Storage($fullPath)', '첨부 이미지 업로드');
      final ref = _storage.ref(fullPath);
      await ref.putFile(files[i]);
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  /// 다운로드 URL로 파일 삭제. 리뷰 수정에서 뺀 첨부 사진 ·
  /// 프로필 사진을 바꿀 때 남는 옛 파일 정리용.
  ///
  /// 실패해도 예외를 던지지 않는다 — 이미 지워졌거나 URL이 이 버킷 것이 아닐 때
  /// 호출측(리뷰 수정)이 실패로 뒤집히면 안 된다. 문서는 이미 갱신된 상태다.
  Future<void> deleteFileByUrl(String url) async {
    logFirebaseAccess('Storage(refFromURL)', '교체·제거된 첨부/프로필 이미지 삭제');
    try {
      await _storage.refFromURL(url).delete();
    } on FirebaseException catch (e) {
      // 이미 없는 파일은 실패가 아니다 — 지우려던 결과가 이미 그 상태다.
      // 오류로 찍으면 정상 동작(중복 정리)이 매번 빨간 로그로 보인다.
      if (e.code == 'object-not-found') return;
      debugPrint('[Storage] deleteFileByUrl failed: $url ($e)');
    } catch (e) {
      debugPrint('[Storage] deleteFileByUrl failed: $url ($e)');
    }
  }
}
