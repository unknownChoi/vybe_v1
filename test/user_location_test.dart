import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/core/constants/app_geo.dart';
import 'package:vybe/core/providers/location_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  UserLocation setAndRead(double lat, double lng) {
    container.read(userLocationProvider.notifier).setLocation(lat, lng);
    return container.read(userLocationProvider);
  }

  group('UserLocationNotifier.setLocation — 국내', () {
    test('좌표가 속한 지역이 그대로 라벨이 된다', () {
      final loc = setAndRead(37.3827, 127.1187); // 성남 분당
      expect(loc.area, '분당구');
      expect(loc.areaLabel, '분당구');
      expect(loc.outsideKorea, isFalse);
      expect(loc.lat, 37.3827);
      expect(loc.lng, 127.1187);
    });

    test('같은 값이면 같은 상태 — 재조회 트리거가 안 된다', () {
      expect(
        setAndRead(37.3827, 127.1187),
        equals(setAndRead(37.3827, 127.1187)),
      );
    });

    test('기기 좌표끼리 50m 미만 이동은 무시한다 (GPS 지터)', () {
      final n = container.read(userLocationProvider.notifier);
      n.setLocation(37.3827, 127.1187, fromDevice: true);
      final before = container.read(userLocationProvider);
      n.setLocation(37.38272, 127.11872, fromDevice: true); // ≈3m
      expect(container.read(userLocationProvider), same(before));
      n.setLocation(37.3927, 127.1187, fromDevice: true); // ≈1.1km
      expect(container.read(userLocationProvider).lat, 37.3927);
    });
  });

  group('UserLocationNotifier.setLocation — 국내 밖', () {
    test('좌표는 대체 상권으로, 라벨은 위치 확인 불가', () {
      final loc = setAndRead(35.6762, 139.6503); // 도쿄

      expect(loc.outsideKorea, isTrue);
      expect(loc.areaLabel, AppGeo.outsideKoreaLabel);
      // 라벨은 '위치 확인 불가'지만 좌표는 후보 상권 중 하나여야 목록이 채워진다.
      expect(AppGeo.overseasFallbackAreas, contains(loc.area));
      final center = AppGeo.hotspotCenters[loc.area]!;
      expect(loc.lat, center.lat);
      expect(loc.lng, center.lng);
    });

    test('기기 좌표가 아니라고 표시된다', () {
      final loc = setAndRead(0, 0);
      expect(loc.outsideKorea, isTrue);
      expect(loc.fromDevice, isFalse);
    });

    test('다시 호출해도 같은 상권 — 누를 때마다 주변 클럽이 바뀌면 안 된다', () {
      final first = setAndRead(35.6762, 139.6503); // 도쿄
      final second = setAndRead(40.7128, -74.0060); // 뉴욕
      expect(second.area, first.area);
      expect(second.lat, first.lat);
      expect(second.lng, first.lng);
    });

    test('국내로 돌아오면 실제 지역으로 복귀한다', () {
      setAndRead(35.6762, 139.6503); // 도쿄
      final home = setAndRead(AppGeo.hongdaeLat, AppGeo.hongdaeLng);
      expect(home.outsideKorea, isFalse);
      expect(home.areaLabel, AppGeo.hongdaeLabel);
    });
  });
}
