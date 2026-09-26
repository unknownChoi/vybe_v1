import 'dart:math';

/// 좌표 거리 계산. geohash 인코딩·셀 prefix 계산은 2026.09.15 에 걷어냈다 —
/// 클럽 목록이 세션 캐시(164곳) 위 메모리 필터가 되면서 범위 쿼리가 사라졌다.
class GeohashUtils {
  static double haversineKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return 2 * r * asin(sqrt(a));
  }
}
