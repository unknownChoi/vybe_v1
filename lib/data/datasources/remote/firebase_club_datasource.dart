import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vybe/core/utils/firebase_logger.dart';
import 'package:vybe/data/datasources/remote/firestore_paths.dart';
import 'package:vybe/data/models/club_info_model.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/club_table_layout.dart';
import 'package:vybe/data/models/menu_model.dart';
import 'package:vybe/data/models/photo_model.dart';

class FirebaseClubDataSource {
  final FirebaseFirestore _firestore;

  FirebaseClubDataSource() : _firestore = FirebaseFirestore.instance;

  /// 활성 클럽 **전체**(164곳) — repository 가 세션 캐시로 들고 주변·장르·무료·
  /// 금연·서비스 음료·지역 목록을 전부 메모리에서 거른다. 화면마다 따로 쿼리하면
  /// 같은 문서를 세션당 수백 번 다시 읽는다 (2026.09.15).
  Future<List<ClubModel>> getActiveClubs() async {
    logFirebaseAccess(
      'Firestore(clubs) [where isActive=true]',
      '활성 클럽 카탈로그 조회(세션 캐시)',
    );
    final snapshot = await _firestore
        .collection(FirestorePaths.clubs)
        .where('isActive', isEqualTo: true)
        .get();
    return snapshot.docs.map(ClubModel.fromFirestore).toList();
  }

  Future<ClubModel?> getClub(String clubId) async {
    logFirebaseAccess('Firestore(clubs/$clubId)', '클럽 상세 정보 조회');
    final doc = await _firestore
        .collection(FirestorePaths.clubs)
        .doc(clubId)
        .get();
    if (!doc.exists) return null;
    return ClubModel.fromFirestore(doc);
  }

  /// 여러 클럽을 ID 목록으로 일괄 조회(whereIn 10개 청크).
  /// vybe 추천 등 clubId 참조 컬렉션과 조인할 때 사용.
  Future<List<ClubModel>> getClubsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    logFirebaseAccess(
      'Firestore(clubs) [whereIn documentId, ${ids.length}개]',
      '클럽 ID 목록 일괄 조회(추천 조인용)',
    );
    final result = <ClubModel>[];
    for (var i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(i, math.min(i + 10, ids.length));
      final snapshot = await _firestore
          .collection(FirestorePaths.clubs)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      result.addAll(snapshot.docs.map(ClubModel.fromFirestore));
    }
    return result;
  }

  Future<ClubInfoModel?> getClubInfo(String clubId) async {
    logFirebaseAccess('Firestore(clubs/$clubId/info/$clubId)', '클럽 운영 정보 조회');
    final doc = await _firestore
        .collection(FirestorePaths.clubs)
        .doc(clubId)
        .collection(FirestorePaths.clubInfo)
        .doc(clubId)
        .get();
    if (!doc.exists) return null;
    return ClubInfoModel.fromFirestore(doc);
  }

  /// 테이블 배치도 — 문서 1건. 없으면 null(호출부가 섹션 자체를 뺀다).
  ///
  /// 층·테이블·구조물이 한 문서에 들어 있어 read 1회로 끝난다.
  /// 업주 웹이 통째로 `set()` 하므로 반쯤 옮겨진 배치도가 읽힐 일이 없다.
  Future<ClubTableLayout?> getTableLayout(String clubId) async {
    logFirebaseAccess(
      'Firestore(clubs/$clubId/tableLayout/$clubId)',
      '[테이블] 배치도·가격 조회',
    );
    final doc = await _firestore
        .collection(FirestorePaths.clubs)
        .doc(clubId)
        .collection(FirestorePaths.tableLayout)
        .doc(clubId)
        .get();
    if (!doc.exists) return null;
    return ClubTableLayout.fromMap(doc.data(), clubId);
  }

  Future<List<MenuModel>> getMenus(String clubId) async {
    logFirebaseAccess(
      'Firestore(clubs/$clubId/menus) [isAvailable=true]',
      '[메뉴탭] 전체 메뉴 목록 조회',
    );
    final snapshot = await _firestore
        .collection(FirestorePaths.clubs)
        .doc(clubId)
        .collection(FirestorePaths.menus)
        .where('isAvailable', isEqualTo: true)
        .get();
    return snapshot.docs.map(MenuModel.fromFirestore).toList();
  }

  Future<List<PhotoModel>> getPhotos(String clubId) async {
    logFirebaseAccess('Firestore(clubs/$clubId/photos)', '[사진탭] 갤러리 사진 목록 조회');
    final snapshot = await _firestore
        .collection(FirestorePaths.clubs)
        .doc(clubId)
        .collection(FirestorePaths.photos)
        .where('isHidden', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map(PhotoModel.fromFirestore).toList();
  }
}
