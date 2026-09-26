import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_inquiry_datasource.dart';
import 'package:vybe/data/datasources/remote/firebase_storage_datasource.dart';
import 'package:vybe/data/datasources/remote/firestore_paths.dart';
import 'package:vybe/data/models/inquiry_model.dart';

/// 고객센터 문의 — Firestore + Storage 합성이 있어 클래스로 둔다
/// (가공 없는 컬렉션은 datasource 를 그대로 노출하지만, 여기는 사진 업로드가 낀다).
final inquiryRepositoryProvider = Provider.autoDispose<InquiryRepositoryImpl>(
  _inquiryRepository,
);

InquiryRepositoryImpl _inquiryRepository(Ref ref) => InquiryRepositoryImpl(
  FirebaseInquiryDataSource(),
  FirebaseStorageDataSource(),
);

class InquiryRepositoryImpl {
  final FirebaseInquiryDataSource _dataSource;
  final FirebaseStorageDataSource _storageDataSource;

  InquiryRepositoryImpl(this._dataSource, this._storageDataSource);

  String newInquiryId() => _dataSource.newInquiryId();

  Stream<List<InquiryModel>> watchMyInquiries(String userId) =>
      _dataSource.watchMyInquiries(userId);

  Future<void> createInquiry(InquiryModel inquiry) =>
      _dataSource.createInquiry(inquiry);

  Future<void> markAnswerRead(String inquiryId) =>
      _dataSource.markAnswerRead(inquiryId);

  /// 문의 첨부 사진 업로드 → URL 목록(순서 유지).
  /// 파일명은 인덱스 기반 — 문의는 수정 경로가 없어 이름이 겹칠 일이 없다.
  Future<List<String>> uploadInquiryImages({
    required String uid,
    required String inquiryId,
    required List<File> images,
  }) => _storageDataSource.uploadIndexed(
    images,
    (i, ext) => StoragePaths.inquiryImage(uid, inquiryId, '$i.$ext'),
  );
}
