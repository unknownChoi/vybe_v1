import 'package:flutter/foundation.dart';

/// Firebase 접근 한 줄 로그. datasource 메서드가 Firebase 를 부르기 직전에 호출한다.
///
/// [service] 는 접근 대상(`Firestore(banners) [where isActive=true]`),
/// [purpose] 는 그 데이터를 쓰는 목적.
///
/// ⚠ **디버그 빌드에서만 찍힌다** — 본문이 `assert` 안에 있어 릴리즈에서는
/// 문자열 조립까지 통째로 빠진다. 예전에는 `print` 가 릴리즈에서도 돌았다.
/// ⚠ 예전 `file:` 인자는 뺐다 — 값이 언제나 호출부 파일 이름이라 정보가 0이었다.
void logFirebaseAccess(String service, String purpose) {
  assert(() {
    debugPrint('[Firebase] $service — $purpose');
    return true;
  }());
}
