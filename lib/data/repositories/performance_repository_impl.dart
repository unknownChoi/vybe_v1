import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/datasources/remote/firebase_performance_datasource.dart';

/// 공연 일정 조회.
///
/// 가공이 없어 datasource 를 그대로 노출한다 — 구현이 하나뿐인 인터페이스와
/// 메서드마다 `=> _dataSource.x()` 만 있던 래퍼를 걷어낸 자리.
/// 가공할 로직이 생기면 그때 이 파일에 클래스를 두면 된다.
final performanceRepositoryProvider = Provider<FirebasePerformanceDataSource>(
  (ref) => FirebasePerformanceDataSource(),
);
