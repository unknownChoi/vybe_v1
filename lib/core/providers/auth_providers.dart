import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/presentation/auth/viewmodels/auth_viewmodel.dart';

/// 현재 로그인한 사용자의 uid. 비로그인 시 null.
final currentUidProvider = Provider.autoDispose<String?>(_currentUid);

String? _currentUid(Ref ref) {
  return ref.watch(authStateProvider).value;
}
