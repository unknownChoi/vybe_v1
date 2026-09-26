import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_storage_datasource.dart';
import 'package:vybe/data/datasources/remote/firebase_user_datasource.dart';
import 'package:vybe/data/models/terms_agreement.dart';
import 'package:vybe/data/models/user_model.dart';
import 'package:vybe/domain/repositories/user_repository.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepository>(
  _userRepository,
);

UserRepository _userRepository(Ref ref) =>
    UserRepositoryImpl(FirebaseUserDataSource(), FirebaseStorageDataSource());

class UserRepositoryImpl implements UserRepository {
  final FirebaseUserDataSource _userDataSource;
  final FirebaseStorageDataSource _storageDataSource;

  UserRepositoryImpl(this._userDataSource, this._storageDataSource);

  @override
  Future<UserModel?> getUser(String uid) => _userDataSource.getUser(uid);

  @override
  Stream<UserModel?> watchUser(String uid) => _userDataSource.watchUser(uid);

  @override
  Future<void> setUserProfile({
    required String uid,
    required String name,
    required String phone,
    required String birthDate,
    required String provider,
    String? gender,
    Map<String, TermsAgreementInput>? agreements,
  }) => _userDataSource.setUserProfile(
    uid: uid,
    name: name,
    phone: phone,
    birthDate: birthDate,
    provider: provider,
    gender: gender,
    agreements: agreements,
  );

  @override
  Future<void> setAgreement({
    required String uid,
    required String key,
    required bool agreed,
    required String version,
  }) => _userDataSource.setAgreement(
    uid: uid,
    key: key,
    agreed: agreed,
    version: version,
  );

  @override
  Future<String> uploadProfileImage(String uid, File imageFile) =>
      _storageDataSource.uploadProfileImage(uid, imageFile);

  @override
  Future<ProfileSaveResult> updateUserProfile({
    String? nickname,
    String? profileImageUrl,
  }) => _userDataSource.updateUserProfile(
    nickname: nickname,
    profileImageUrl: profileImageUrl,
  );

  @override
  Future<void> deleteFileByUrl(String url) =>
      _storageDataSource.deleteFileByUrl(url);
}
