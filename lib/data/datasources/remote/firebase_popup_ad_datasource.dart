import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vybe/core/utils/firebase_logger.dart';
import 'package:vybe/data/datasources/remote/firestore_paths.dart';
import 'package:vybe/data/models/popup_ad_model.dart';

class FirebasePopupAdDataSource {
  final FirebaseFirestore _firestore;

  FirebasePopupAdDataSource() : _firestore = FirebaseFirestore.instance;

  /// 활성 팝업 광고 전부. 노출 기간·정렬은 [PopupAdModel.pick]이 메모리에서 한다.
  ///
  /// ⚠ `where isActive == true`를 빼면 안 된다 — Rules가
  /// `resource.data.isActive == true`로 판정해 조건 없는 목록 쿼리는
  /// **permission-denied**가 된다(notices와 같은 함정).
  Future<List<PopupAdModel>> getActivePopupAds() async {
    logFirebaseAccess(
      'Firestore(popupAds) [where isActive=true]',
      '홈 진입 팝업 광고 조회',
    );
    final snapshot = await _firestore
        .collection(FirestorePaths.popupAds)
        .where('isActive', isEqualTo: true)
        .get();
    return snapshot.docs.map(PopupAdModel.fromFirestore).toList();
  }
}
