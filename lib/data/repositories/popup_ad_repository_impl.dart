import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_popup_ad_datasource.dart';

/// 홈 진입 팝업 광고 조회.
///
/// 가공이 없어 datasource를 그대로 노출한다(배너와 같은 방식).
final popupAdRepositoryProvider = Provider<FirebasePopupAdDataSource>(
  (ref) => FirebasePopupAdDataSource(),
);
