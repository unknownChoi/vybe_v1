import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/core/storage/local_prefs.dart';
import 'package:vybe/data/models/popup_ad_model.dart';
import 'package:vybe/data/repositories/popup_ad_repository_impl.dart';

/// '1주일동안 안보기' 기간.
///
/// 서버 필드가 아니라 **앱 상수**다 — 운영자가 만질 값이 아니고, 문서에 두면
/// 기기마다 다른 기간이 섞여 "왜 나만 또 뜨냐"를 재현할 수 없다.
const kPopupAdHideDuration = Duration(days: 7);

/// 이번 실행에서 띄울 팝업 광고 1건. 없으면 null.
///
/// keepAlive — 앱 수명 동안 한 번만 조회한다(홈 재진입·탭 전환으로 다시 읽지 않음).
///
/// **fail-silent** — 조회가 실패하면 null이다. 광고가 안 뜨는 것은 최악이 아니고,
/// 오류를 띄우면 사용자는 자기가 뭘 잘못한 줄 안다.
final popupAdProvider = FutureProvider<PopupAdModel?>(_popupAd);

Future<PopupAdModel?> _popupAd(Ref ref) async {
  final List<PopupAdModel> ads;
  try {
    ads = await ref.read(popupAdRepositoryProvider).getActivePopupAds();
  } catch (_) {
    return null;
  }

  final now = DateTime.now();
  final ad = PopupAdModel.pick(ads, now);
  if (ad == null) return null;

  // 기기에 남긴 '1주일동안 안보기'가 아직 유효하면 띄우지 않는다.
  try {
    final prefs = await ref.read(localPrefsProvider.future);
    if (now.millisecondsSinceEpoch < prefs.popupAdHideUntil(ad.popupId)) {
      return null;
    }
  } catch (_) {
    // 로컬 설정을 못 읽으면 그냥 띄운다 — 숨김은 편의 기능이라,
    // 못 읽었다고 광고를 통째로 막을 이유가 없다.
  }
  return ad;
}
