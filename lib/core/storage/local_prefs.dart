import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 기기 로컬에 남기는 설정.
///
/// 자동 로그인 스위치와 **팝업 광고 '1주일동안 안보기'** 두 가지를 저장한다.
/// 설정 화면의 알림 토글들은 실제 푸시 연동이 없어서, 값만 저장하면 동작하지
/// 않는 설정을 동작하는 것처럼 보여주게 된다 — 그래서 그것들은 화면 상태로 둔다.
class LocalPrefs {
  static const _kAutoLogin = 'auto_login';

  /// 팝업 광고 숨김 만료 시각. 뒤에 popupId가 붙는다.
  static const _kPopupAdHideUntil = 'popup_ad_hide_until_';

  final SharedPreferences _prefs;

  const LocalPrefs(this._prefs);

  /// 자동 로그인 유지 여부. 저장된 적 없으면 **켜짐**(기본 동작).
  bool get autoLogin => _prefs.getBool(_kAutoLogin) ?? true;

  Future<void> setAutoLogin(bool value) => _prefs.setBool(_kAutoLogin, value);

  /// 이 팝업 광고를 다시 띄우지 않을 시각(epoch ms). 저장된 적 없으면 0.
  ///
  /// ⚠ 키를 **popupId별로** 나눈다 — 키가 하나면 A 광고를 1주일 숨긴 사용자가
  /// 그 사이 올라온 B 광고를 못 본다.
  ///
  /// 서버가 아니라 기기에 두는 이유 — 팝업을 볼 때마다 write가 생기고,
  /// 비로그인 사용자는 저장할 키(uid)가 없다. 공지 읽음 상태를 저장하지
  /// 않는 것과 같은 규칙이다.
  int popupAdHideUntil(String popupId) =>
      _prefs.getInt('$_kPopupAdHideUntil$popupId') ?? 0;

  Future<void> setPopupAdHideUntil(String popupId, DateTime until) => _prefs
      .setInt('$_kPopupAdHideUntil$popupId', until.millisecondsSinceEpoch);
}

/// keepAlive — 앱 실행 내내 같은 인스턴스를 쓴다(매번 디스크를 열지 않게).
final localPrefsProvider = FutureProvider<LocalPrefs>(_localPrefs);

Future<LocalPrefs> _localPrefs(Ref ref) async =>
    LocalPrefs(await SharedPreferences.getInstance());
