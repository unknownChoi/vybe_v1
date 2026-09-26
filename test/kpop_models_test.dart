import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/service_drink.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/kpop/kpop_models.dart';

ClubModel _club(
  String id, {
  String area = '홍대',
  bool vybe = false,
  bool freeEntry = false,
  bool drink = false,
  bool nonSmoking = false,
}) => ClubModel(
  clubId: id,
  name: id,
  description: '',
  address: '',
  area: area,
  phone: '',
  instagramUrl: '',
  lat: 37.55,
  lng: 126.92,
  geohash: '',
  genre: kKpopGenre,
  rating: 4.0,
  reviewCount: 1,
  entryFeeMin: 0,
  entryFeeMax: 0,
  imageUrls: const [],
  thumbnailUrl: '',
  tags: const [],
  favoriteCount: 0,
  isActive: true,
  isVybeRecommended: vybe,
  isNonSmoking: nonSmoking,
  isFreeEntry: freeEntry,
  serviceDrink: drink ? const ServiceDrink(isOffered: true) : ServiceDrink.none,
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
);

/// 라벨로 필터를 찾는다 — 화면이 라벨을 키로 고르므로 같은 방식으로 검사한다.
VybeClubFilter _filter(String label) =>
    kKpopFilters.firstWhere((f) => f.label == label);

void main() {
  group('vybeClubAreasOf', () {
    test('상권 표 순서를 따르고 중복은 한 번만', () {
      final areas = vybeClubAreasOf([
        _club('a', area: '강남'),
        _club('b', area: '홍대'),
        _club('c', area: '강남'),
        _club('d', area: '이태원'),
      ]);
      // AppGeo.hotspotCenters 순서: 홍대 → 신촌 → 강남 → 압구정 → 이태원 → 건대
      expect(areas, ['홍대', '강남', '이태원']);
    });

    test('클럽이 없는 지역은 칩을 만들지 않는다', () {
      expect(vybeClubAreasOf([_club('a', area: '건대')]), ['건대']);
      expect(vybeClubAreasOf(const []), isEmpty);
    });

    test('상권 표에 없는 지역은 뒤에 이름순으로 붙는다', () {
      final areas = vybeClubAreasOf([
        _club('a', area: '수원'),
        _club('b', area: '홍대'),
        _club('c', area: '부산'),
      ]);
      expect(areas, ['홍대', '부산', '수원']);
    });

    test('area 가 빈 클럽은 칩을 만들지 않는다', () {
      expect(vybeClubAreasOf([_club('a', area: '')]), isEmpty);
    });
  });

  group('필터 칩', () {
    test('각 칩이 제 필드만 본다', () {
      const saved = <String>{'saved-club'};

      expect(_filter('vybe 추천 클럽').test(_club('a', vybe: true), saved), isTrue);
      expect(_filter('vybe 추천 클럽').test(_club('a'), saved), isFalse);

      expect(
        _filter('입장비 무료').test(_club('a', freeEntry: true), saved),
        isTrue,
      );
      expect(_filter('입장비 무료').test(_club('a'), saved), isFalse);

      expect(_filter('서비스 음료').test(_club('a', drink: true), saved), isTrue);
      expect(_filter('서비스 음료').test(_club('a'), saved), isFalse);

      expect(_filter('금연').test(_club('a', nonSmoking: true), saved), isTrue);
      expect(_filter('금연').test(_club('a'), saved), isFalse);

      expect(_filter('찜').test(_club('saved-club'), saved), isTrue);
      expect(_filter('찜').test(_club('a'), saved), isFalse);
    });

    test('여러 칩은 AND — 전부 만족하는 클럽만 남는다', () {
      final clubs = [
        _club('both', freeEntry: true, nonSmoking: true),
        _club('freeOnly', freeEntry: true),
        _club('smokeOnly', nonSmoking: true),
      ];
      final picked = [_filter('입장비 무료'), _filter('금연')];
      final left = clubs
          .where((c) => picked.every((f) => f.test(c, const {})))
          .map((c) => c.clubId);
      expect(left, ['both']);
    });
  });

  group('vybeClubPosterFrom', () {
    test('추천 클럽이면 뱃지 플래그가 켜진다', () {
      expect(vybeClubPosterFrom(_club('a', vybe: true)).vybe, isTrue);
      expect(vybeClubPosterFrom(_club('a')).vybe, isFalse);
    });

    test('공연 데이터를 안 읽으므로 LIVE 는 항상 꺼져 있다', () {
      expect(vybeClubPosterFrom(_club('a')).live, isFalse);
    });

    test('태그가 없으면 장르를 대신 쓴다', () {
      expect(vybeClubPosterFrom(_club('a')).styles, [kKpopGenre]);
    });
  });

  test('같은 클럽은 항상 같은 폴백 그라데이션', () {
    expect(vybeClubGradFor('club-1'), same(vybeClubGradFor('club-1')));
    expect(vybeClubGradFor('club-1').length, 3);
  });
}
