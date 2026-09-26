import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vybe/data/models/free_entry_policy.dart';
import 'package:vybe/data/models/operating_hours.dart';
import 'package:vybe/data/models/service_drink.dart';

part 'club_model.freezed.dart';

@freezed
abstract class ClubModel with _$ClubModel {
  const ClubModel._();

  const factory ClubModel({
    required String clubId,
    required String name,
    required String description,
    required String address,
    required String area,
    required String phone,
    required String instagramUrl,
    required double lat,
    required double lng,
    required String geohash,
    required String genre,
    required double rating,
    @Default(0) int reviewCount,
    @Default(OperatingHours()) OperatingHours operatingHours,
    required int entryFeeMin,
    required int entryFeeMax,
    required List<String> imageUrls,
    @Default([]) List<String> heroImageUrls,
    required String thumbnailUrl,
    @Default([]) List<String> menuBoardUrls,
    required List<String> tags,
    required int favoriteCount,
    required bool isActive,
    required bool isVybeRecommended,
    @Default(false) bool isNonSmoking,
    @Default(ServiceDrink.none) ServiceDrink serviceDrink,

    /// 무료입장 정책 — 상시 / 시간대 / 없음. 지금 무료인지는 `freeEntry.statusAt()`.
    @Default(FreeEntryPolicy.none) FreeEntryPolicy freeEntry,

    /// `freeEntry.type != none` 파생값. 쿼리·필터 전용 (판정에는 쓰지 않는다).
    @Default(false) bool isFreeEntry,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ClubModel;

  /// 무료입장 조건 문구 (`freeEntry.condition`). 레거시 `freeEntryCondition` 폴백은
  /// 이관이 끝나 걷어냈다 (2026.09.15).
  String get freeEntryLabel => freeEntry.condition;

  factory ClubModel.fromFirestore(DocumentSnapshot doc) => ClubModel._fromMap(
    doc.id,
    doc.data() as Map<String, dynamic>,
    date: _parseTimestamp,
  );

  /// Algolia 검색 hit → ClubModel (Firestore 조인 없이 목록/지도 렌더용).
  ///
  /// hit에는 Extension Indexable Fields로 지정된 필드만 들어있다.
  /// 상세 화면은 clubId로 문서를 다시 읽으므로 여기 없는 필드(description,
  /// imageUrls, menuBoardUrls 등)는 fromFirestore와 같은 기본값으로 둔다.
  /// freeEntry/isFreeEntry 는 Indexable Fields 에 포함돼 hit 로 실려 온다
  /// (빠지면 `_requiredFields` 검사가 complete=false 로 떨어뜨려 조인 폴백).
  factory ClubModel.fromSearchHit(String objectID, Map<String, dynamic> data) =>
      ClubModel._fromMap(objectID, data, date: _parseSearchDate);

  /// Firestore 문서 · Algolia hit 공용 매핑. 둘의 차이는 시각 필드 형식뿐이라
  /// [date] 파서만 주입한다 (중첩 맵은 [_asStringMapOrNull] 이 둘 다 통한다).
  factory ClubModel._fromMap(
    String id,
    Map<String, dynamic> data, {
    required DateTime Function(Object?) date,
  }) {
    final location = _asStringMapOrNull(data['location']) ?? const {};
    return ClubModel(
      clubId: id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      address: data['address'] as String? ?? '',
      area: data['area'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      instagramUrl: data['instagramUrl'] as String? ?? '',
      lat: (location['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (location['lng'] as num?)?.toDouble() ?? 0.0,
      geohash: location['geohash'] as String? ?? '',
      genre: data['genre'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      operatingHours: OperatingHours.fromMap(
        _asStringMapOrNull(data['operatingHours']),
      ),
      entryFeeMin: (data['entryFeeMin'] as num?)?.toInt() ?? 0,
      entryFeeMax: (data['entryFeeMax'] as num?)?.toInt() ?? 0,
      imageUrls: List<String>.from(data['imageUrls'] as List? ?? []),
      heroImageUrls: List<String>.from(data['heroImageUrls'] as List? ?? []),
      thumbnailUrl: data['thumbnailUrl'] as String? ?? '',
      menuBoardUrls: List<String>.from(data['menuBoardUrls'] as List? ?? []),
      tags: List<String>.from(data['tags'] as List? ?? []),
      favoriteCount: (data['favoriteCount'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? false,
      isVybeRecommended: data['isVybeRecommended'] as bool? ?? false,
      isNonSmoking: data['isNonSmoking'] as bool? ?? false,
      serviceDrink: ServiceDrink.fromMap(
        _asStringMapOrNull(data['serviceDrink']),
      ),
      freeEntry: FreeEntryPolicy.fromMap(_asStringMapOrNull(data['freeEntry'])),
      isFreeEntry: data['isFreeEntry'] as bool? ?? false,
      createdAt: date(data['createdAt']),
      updatedAt: date(data['updatedAt']),
    );
  }
}

/// 중첩 객체를 안전하게 Map으로. Firestore 맵·JSON 디코드 결과 둘 다 통한다.
Map<String, dynamic>? _asStringMapOrNull(Object? v) =>
    v is Map ? Map<String, dynamic>.from(v) : null;

DateTime _parseTimestamp(Object? v) =>
    (v as Timestamp?)?.toDate() ?? DateTime.now();

/// 검색 hit의 시각 필드 파싱. Extension 버전에 따라 ISO 문자열 /
/// epoch 초·밀리초 / `{_seconds, _nanoseconds}` 중 하나로 들어온다.
/// 목록 UI에서 쓰지 않는 값이라 파싱 실패 시 현재 시각으로 둔다.
DateTime _parseSearchDate(Object? v) {
  if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
  if (v is num) {
    final ms = v > 100000000000 ? v.toInt() : (v * 1000).toInt();
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }
  if (v is Map) {
    final s = (v['_seconds'] ?? v['seconds']) as num?;
    if (s != null) {
      return DateTime.fromMillisecondsSinceEpoch((s * 1000).toInt());
    }
  }
  return DateTime.now();
}
