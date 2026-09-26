import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:vybe/data/datasources/remote/social_auth_datasource.dart';

final authRepositoryProvider = Provider.autoDispose<AuthRepositoryImpl>(
  _authRepository,
);

AuthRepositoryImpl _authRepository(Ref ref) =>
    AuthRepositoryImpl(FirebaseAuthDataSource(), SocialAuthDataSource());

class AuthRepositoryImpl {
  final FirebaseAuthDataSource _dataSource;
  final SocialAuthDataSource _socialDataSource;

  AuthRepositoryImpl(this._dataSource, this._socialDataSource);

  Stream<String?> get authStateChanges =>
      _dataSource.authStateChanges.map((user) => user?.uid);

  String? get currentUid => _dataSource.currentUser?.uid;

  Future<LoginTokenResult> kakaoLogin(String accessToken) =>
      _dataSource.kakaoLogin(accessToken);

  Future<LoginTokenResult> naverLogin(String accessToken) =>
      _dataSource.naverLogin(accessToken);

  Future<void> signInWithCustomToken(String customToken) =>
      _dataSource.signInWithCustomToken(customToken);

  Future<PhoneAccountResult> checkPhoneAccount(String phone, String method) =>
      _dataSource.checkPhoneAccount(phone, method);

  Future<bool> verifyIdentity(String impUid) =>
      _dataSource.verifyIdentity(impUid);

  Future<LoginTokenResult> phoneLogin(String phone) =>
      _dataSource.phoneLogin(phone);

  /// Firebase 세션과 소셜 SDK 세션을 **함께** 정리한다.
  /// 소셜 세션이 남으면 재로그인 때 계정 선택 없이 직전 계정으로 붙는다.
  Future<void> signOut() async {
    await _socialDataSource.signOutAll();
    await _dataSource.signOut();
  }

  /// 탈퇴 요청이 성공하면 **곧바로 로그아웃까지** 한다.
  /// 서버가 Auth 계정을 disabled 로 바꿔 세션이 이미 무효인데, 로컬 세션과
  /// 소셜 SDK 세션이 남아 있으면 앱이 로그인 상태처럼 굴다가 조회마다 실패한다.
  Future<DateTime> requestAccountDeletion(String reason) async {
    final purgeAt = await _dataSource.requestAccountDeletion(reason);
    await signOut();
    return purgeAt;
  }

  Future<bool> refreshSession() => _dataSource.refreshSession();
}
