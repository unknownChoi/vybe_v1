import 'package:flutter/foundation.dart';

/// UI 단계에서 화면의 **상태 변형**을 바꿔 보기 위한 전역 스위치.
///
/// Fake datasource 들이 이 값을 읽어 다른 결과를 돌려준다.
/// 바꾸는 수단은 `kDebugMode` 전용 개발 메뉴([VybeDevMenu])뿐이다 —
/// 릴리스 빌드에는 그 화면으로 가는 입구가 없다.
///
/// ⚠ 이 파일은 **Fake 전용**이다. Firebase datasource 는 보지 않는다.
enum FakeScenario {
  /// 정상 — 디자인 원본의 기본 예시 값.
  normal('기본'),

  /// 조회가 끝나지 않은 상태(스켈레톤 확인용).
  loading('로딩'),

  /// 데이터 0건.
  empty('빈 상태'),

  /// 조회 실패.
  failure('실패'),

  /// 티켓·QR 만료.
  expired('만료'),

  /// 아직 열어 줄 수 없음(QR 잠김 · 전환 전).
  locked('잠김'),

  /// 접수·주문 마감.
  closed('마감');

  const FakeScenario(this.label);

  /// 개발 메뉴에 찍는 한글 라벨.
  final String label;
}

/// 지금 고른 시나리오. 개발 메뉴가 바꾸고 Fake datasource 가 읽는다.
///
/// `ValueNotifier` 라 화면에서 `ValueListenableBuilder` 로 즉시 반영할 수 있다.
final ValueNotifier<FakeScenario> fakeScenario =
    ValueNotifier<FakeScenario>(FakeScenario.normal);

/// Fake 가 흉내 내는 네트워크 지연. 로딩 상태를 눈으로 보려고 둔다.
const Duration kFakeDelay = Duration(milliseconds: 350);

/// 시나리오에 맞춰 지연·예외를 흉내 낸다. 모든 Fake 메서드가 이걸 먼저 부른다.
Future<void> fakeGate() async {
  switch (fakeScenario.value) {
    case FakeScenario.loading:
      // 끝나지 않는다 — 화면이 스켈레톤에 머문다.
      await Future<void>.delayed(const Duration(days: 1));
    case FakeScenario.failure:
      await Future<void>.delayed(kFakeDelay);
      throw const FakeDataException('Fake 실패 시나리오');
    default:
      await Future<void>.delayed(kFakeDelay);
  }
}

/// Fake 가 일부러 던지는 예외. 화면의 실패 분기를 확인할 때 쓴다.
class FakeDataException implements Exception {
  const FakeDataException(this.message);

  final String message;

  @override
  String toString() => 'FakeDataException: $message';
}
