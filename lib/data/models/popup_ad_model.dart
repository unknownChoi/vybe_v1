import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'popup_ad_model.freezed.dart';

/// 팝업 광고를 탭했을 때 어디로 보낼지.
///
/// 배너(`BannerLinkType`)와 달리 목적지가 둘뿐이다 — 연결된 공지 상세이거나,
/// 아무 데도 안 간다. 운영자가 공지를 고르지 않아도 되는 요구라 [none]이 기본이고,
/// 알 수 없는 값도 여기로 폴백한다(잘못된 곳으로 보내는 것보다 낫다).
enum PopupAdLinkType { notice, none }

/// `popupAds/{popupId}` — 홈 진입 팝업 광고 1건.
///
/// 내용은 **정사각 사진 1장**이 전부다. 제목·본문 필드를 두지 않는 이유는
/// 디자인(`home_popup_ad.jsx`)에 텍스트 자리가 없기 때문 — 필드만 만들어 두면
/// 운영자는 채우는데 앱은 안 그리는 상태가 생긴다.
@freezed
abstract class PopupAdModel with _$PopupAdModel {
  const PopupAdModel._();

  const factory PopupAdModel({
    required String popupId,
    required String imageUrl,

    /// 스크린리더용 사진 설명. 사진뿐인 팝업이라 이게 없으면 읽어 줄 것이 없다.
    required String altText,
    required PopupAdLinkType linkType,
    required String linkValue,

    /// 1순위 — 운영자 페이지 토글. true면 [order]와 무관하게 맨 앞.
    required bool isPrimary,
    required int order,
    required bool isActive,
    required DateTime startAt,
    required DateTime endAt,
  }) = _PopupAdModel;

  /// 사진을 탭했을 때 갈 곳이 있는지.
  bool get isTappable =>
      linkType == PopupAdLinkType.notice && linkValue.isNotEmpty;

  /// 지금 노출 기간 안인지. `isActive`는 쿼리가 거르지만 판정을 한곳에 모은다.
  bool isVisibleAt(DateTime now) =>
      isActive && !now.isBefore(startAt) && now.isBefore(endAt);

  static PopupAdLinkType _parseLinkType(String? raw) =>
      raw == 'notice' ? PopupAdLinkType.notice : PopupAdLinkType.none;

  factory PopupAdModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PopupAdModel(
      popupId: data['popupId'] as String? ?? doc.id,
      imageUrl: data['imageUrl'] as String? ?? '',
      altText: data['altText'] as String? ?? '',
      linkType: _parseLinkType(data['linkType'] as String?),
      linkValue: data['linkValue'] as String? ?? '',
      isPrimary: data['isPrimary'] as bool? ?? false,
      order: data['order'] as int? ?? 0,
      isActive: data['isActive'] as bool? ?? false,
      startAt: (data['startAt'] as Timestamp?)?.toDate() ?? DateTime(2000),
      endAt: (data['endAt'] as Timestamp?)?.toDate() ?? DateTime(2000),
    );
  }

  /// 활성 목록에서 **띄울 1건**을 고른다.
  ///
  /// 정렬은 `isPrimary` 내림차순 → `order` 오름차순 한 줄이고, 그 맨 앞 1건만
  /// 쓴다. 팝업을 겹쳐 띄우면 홈에 닿기까지 닫기를 여러 번 눌러야 한다.
  ///
  /// ⚠ 1순위가 여럿이어도 깨지지 않아야 한다 — Rules는 다른 문서를 볼 수 없어
  /// "1순위는 하나뿐"을 서버에서 강제할 수 없다. 그래서 [order]와 [popupId]로
  /// tie-break해 **답이 항상 하나로 좁혀지게** 둔다(같은 목록이면 같은 결과).
  static PopupAdModel? pick(List<PopupAdModel> ads, DateTime now) {
    final visible = ads.where((a) => a.isVisibleAt(now)).toList()
      ..sort((a, b) {
        if (a.isPrimary != b.isPrimary) return a.isPrimary ? -1 : 1;
        final byOrder = a.order.compareTo(b.order);
        return byOrder != 0 ? byOrder : a.popupId.compareTo(b.popupId);
      });
    return visible.isEmpty ? null : visible.first;
  }
}
