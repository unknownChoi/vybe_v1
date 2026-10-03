import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';

/// v1 신규 섹션(H~T)이 쓰는 디자인 토큰.
///
/// **기존 토큰을 바꾸지 않는다.** [VybeColors] · [VybeTypography] · `RenewGlass` 에
/// 같은 값이 이미 있으면 여기 중복해 두지 않고 그쪽을 그대로 쓴다.
/// 여기 있는 것은 디자인 원본(`design/user/extracted/new_func_renew.css` ·
/// `new_func_od.css` · `new_func_rsv.css` · `tokens.jsx`)에만 있고 기존에 없던 값이다.
///
/// 이미 있어서 여기 없는 것들 — 보라 `mainPurple500/700`, 라임 `mainLime500/700`,
/// 회색 `gray500~900`, 빨강 `accentRed500`, 잉크 `RenewGlass.ink`,
/// 글래스 채움·테두리 `RenewGlass.cardFill/cardBorder/hair`, 글자 `RenewGlass.t1~t4`,
/// 라벤더 `RenewGlass.lavender`.

/// v1 색 토큰.
class V1Colors {
  const V1Colors._();

  // ── 앰버 (주의 · 패널티 · 접수 대기) ─────────────────────────
  /// `--amber500`. 주의·패널티·'접수됨' 기본색.
  static const Color amber500 = Color(0xFFF5B544);

  /// `--amber700`. 앰버 티켓 헤더 그라데이션 끝색.
  static const Color amber700 = Color(0xFFD89A2F);

  /// 앰버 인라인 배너 글자.
  static const Color amberText = Color(0xFFFFD68A);

  // ── 오류 전용 ───────────────────────────────────────────
  /// 오류 뱃지 글자. ⚠ 디자인 주석: **취소·거절에는 쓰지 않는다**(그때는 done 톤).
  static const Color red300 = Color(0xFFFF8A8C);

  // ── 보라 보조 ───────────────────────────────────────────
  /// '대기중' 뱃지 글자 · 보라 아이콘 캡슐 글자.
  static const Color purpleText = Color(0xFFD9C6FF);

  /// 보라 인라인 배너 글자.
  static const Color purpleBannerText = Color(0xFFE2D4FF);

  // ── 티켓 헤더 그라데이션 ──────────────────────────────────
  /// 확정·진행 티켓 헤더.
  static const List<Color> ticketHeaderPurple = [
    VybeColors.mainPurple500,
    VybeColors.mainPurple700,
  ];

  /// 호출됨 티켓 헤더(글자는 잉크색).
  static const List<Color> ticketHeaderLime = [
    VybeColors.mainLime500,
    VybeColors.mainLime700,
  ];

  /// 접수됨(매장 확인 전) 티켓 헤더.
  static const List<Color> ticketHeaderAmber = [amber500, amber700];

  /// 완료·만료·취소 티켓 헤더.
  static const List<Color> ticketHeaderGray = [
    VybeColors.gray800,
    VybeColors.gray900,
  ];

  /// 입장 완료 티켓 헤더 바닥층(그 위에 보라·라임 방사 그라데이션이 얹힌다).
  static const List<Color> ticketHeaderEntered = [
    Color(0xFF241246), // --purpleDeep
    Color(0xFF121118), // --entInk
    Color(0xFF1A2410), // --limeDeep
  ];

  /// 입장 완료 헤더의 보라 방사광.
  static const Color enteredGlowPurple = Color(0xEB7731FE); // rgba(119,49,254,.92)

  /// 입장 완료 헤더의 라임 방사광.
  static const Color enteredGlowLime = Color(0x9EB5FF60); // rgba(181,255,96,.62)

  // ── 좌석 배치도 ─────────────────────────────────────────
  /// 예약 완료(선택 불가) 좌석 45° 스트라이프 — 밝은 줄.
  static const Color floorBlockedA = Color(0xFF3A3A3E);

  /// 같은 스트라이프 — 어두운 줄.
  static const Color floorBlockedB = Color(0xFF2A2A2E);

  // ── 메뉴 ───────────────────────────────────────────────
  /// 메뉴 행 썸네일 빈 자리 그라데이션.
  static const List<Color> menuThumbPlaceholder = [
    Color(0xFF3A2A5E),
    Color(0xFF1F1A2B),
  ];

  // ── 틴트 (디자인의 rgba(색, 알파) 를 그대로 옮긴 값) ──────────
  /// 보라 12% — 인라인 배너 채움.
  static const Color purpleTint12 = Color(0x1F7731FE);

  /// 보라 24% — 인라인 배너 테두리.
  static const Color purpleTint24 = Color(0x3D7731FE);

  /// 앰버 12% — 인라인 배너 채움 · 결과 아이콘 원 채움.
  static const Color amberTint12 = Color(0x1FF5B544);

  /// 앰버 24% — 인라인 배너 테두리.
  static const Color amberTint24 = Color(0x3DF5B544);

  /// 앰버 30% — 결과 아이콘 원 테두리.
  static const Color amberTint30 = Color(0x4DF5B544);

  /// 라임 12% — 결과 아이콘 원 채움.
  static const Color limeTint12 = Color(0x1FB5FF60);

  /// 라임 30% — 결과 아이콘 원 테두리.
  static const Color limeTint30 = Color(0x4DB5FF60);

  /// 빨강 12% — 결과 아이콘 원 채움.
  static const Color redTint12 = Color(0x1FFF5C5F);

  /// 빨강 30% — 결과 아이콘 원 테두리.
  static const Color redTint30 = Color(0x4DFF5C5F);

  // ── 잉크 위 · 흰 판 위 ───────────────────────────────────
  /// 라임 헤더 위 부제 글자 — 잉크 70%.
  static const Color onLimeHeaderSub = Color(0xB30E0D12);

  /// QR 만료 덮개 — 흰 95%.
  static const Color qrExpiredVeil = Color(0xF2FFFFFF);

  /// QR 잠금 캡슐 채움 — 잉크 85%.
  static const Color qrLockFill = Color(0xD90E0D12);

  /// 티켓 스텁 바코드 막대 — 흰 54%.
  static const Color barcodeBar = Color(0x8AFFFFFF);

  // ── 하단 탭 ────────────────────────────────────────────
  /// 패스월렛 티켓 아이콘 안쪽 점선(채운 티켓 위에 긋는 선).
  static const Color tabTicketStroke = Color(0xFF1B1526);
}

/// 상태 뱃지 톤. 디자인 `.v2badge` 의 변형 그대로.
///
/// ⚠ [error] 는 **결제 실패·시스템 오류 전용**이다. 취소·거절은 [done] 을 쓴다
/// (디자인 CSS 주석이 못 박아 둔 규칙).
enum VybeBadgeTone {
  /// 기본 — 흰 반투명.
  neutral,

  /// 대기중 — 보라.
  waiting,

  /// 호출됨 — 라임 채움 + 잉크 글자.
  called,

  /// 입장 완료 · 무료 — 라임 틴트.
  entered,

  /// 접수됨 · 패널티 발생 — 앰버 틴트.
  pending,

  /// 완료 · 만료 · 취소 · 변경 불가 — 회색.
  done,

  /// 결제 실패 · 시스템 오류 — 빨강.
  error;

  /// 채움색.
  Color get fill => switch (this) {
    VybeBadgeTone.neutral => const Color(0x1FFFFFFF),
    VybeBadgeTone.waiting => const Color(0x387731FE),
    VybeBadgeTone.called => VybeColors.mainLime500,
    VybeBadgeTone.entered => const Color(0x24B5FF60),
    VybeBadgeTone.pending => const Color(0x29F5B544),
    VybeBadgeTone.done => const Color(0x0FFFFFFF),
    VybeBadgeTone.error => const Color(0x24FF5C5F),
  };

  /// 테두리색.
  Color get border => switch (this) {
    VybeBadgeTone.neutral => const Color(0x24FFFFFF),
    VybeBadgeTone.waiting => const Color(0x807731FE),
    VybeBadgeTone.called => VybeColors.mainLime500,
    VybeBadgeTone.entered => const Color(0x4DB5FF60),
    VybeBadgeTone.pending => const Color(0x66F5B544),
    VybeBadgeTone.done => const Color(0x1FFFFFFF),
    VybeBadgeTone.error => const Color(0x6BFF5C5F),
  };

  /// 글자·점 색.
  Color get text => switch (this) {
    VybeBadgeTone.neutral => Colors.white,
    VybeBadgeTone.waiting => V1Colors.purpleText,
    VybeBadgeTone.called => const Color(0xFF0E0D12),
    VybeBadgeTone.entered => VybeColors.mainLime500,
    VybeBadgeTone.pending => V1Colors.amber500,
    VybeBadgeTone.done => VybeColors.gray500,
    VybeBadgeTone.error => V1Colors.red300,
  };
}

/// 취소·환불 구간 톤. 디자인 `rsv_rules.js` 의 `TONE` 그대로.
enum VybeRefundTone {
  /// 전액 환불.
  ok,

  /// 부분 환불(패널티 발생).
  part,

  /// 환불 불가.
  no;

  Color get color => switch (this) {
    VybeRefundTone.ok => VybeColors.mainLime500,
    VybeRefundTone.part => V1Colors.amber500,
    VybeRefundTone.no => VybeColors.accentRed500,
  };

  VybeBadgeTone get badge => switch (this) {
    VybeRefundTone.ok => VybeBadgeTone.entered,
    VybeRefundTone.part => VybeBadgeTone.pending,
    VybeRefundTone.no => VybeBadgeTone.done,
  };
}

/// v1 전용 타이포. 기존 [VybeTypography] 에 없는 단계만.
class V1Typo {
  const V1Typo._();

  /// 티켓 대기번호 — 700 / 44 / ls -1.1 / 라임 / tabular.
  static TextStyle get ticketNumber => TextStyle(
    fontSize: 44.sp,
    fontWeight: FontWeight.w700,
    height: 1.05,
    letterSpacing: -1.1,
    color: VybeColors.mainLime500,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// 주문 상태 히어로의 주문번호 — 700 / 56 / ls -1.4 / 라임 / tabular.
  static TextStyle get orderNumber => TextStyle(
    fontSize: 56.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -1.4,
    color: VybeColors.mainLime500,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// 큰 숫자 옆 작은 라벨 — 600 / 22 / 흰색.
  static TextStyle get bigNumberSmall => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );

  /// 인원·수량 스테퍼 숫자 — 700 / 28 / ls -0.7.
  static TextStyle get stepperNumber => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -0.7,
    color: Colors.white,
  );

  /// 티켓 헤더 매장명 — 600 / 22 / ls -0.55.
  static TextStyle get ticketClub => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: -0.55,
    color: Colors.white,
  );

  /// 티켓 스탯 값 — 500 / 18 / ls -0.45.
  static TextStyle get statValue => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: -0.45,
    color: Colors.white,
  );

  /// 상태 뱃지 글자 — 600 / 12 / ls -0.2.
  static TextStyle get badge => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: -0.2,
  );

  /// 일련번호 — mono 느낌의 자간을 준 600 / 13.
  static TextStyle get serial => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 1.2,
    color: Colors.white,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

/// v1 전용 치수. 디자인 원본 값 그대로.
class V1Dim {
  const V1Dim._();

  /// 하단 고정 버튼 높이(`.vb`).
  static double get bottomButtonHeight => 56.h;

  /// 카드 안 버튼 높이(`.btn`).
  static double get cardButtonHeight => 48.h;

  /// 상태 뱃지 radius(알약).
  static const double badgeRadius = 99;

  /// 티켓 카드 radius.
  static const double ticketRadius = 18;

  /// 안내 박스 radius(`.fnote`).
  static const double noteRadius = 12;

  /// 금액·정보 카드 radius(`.gcard`).
  static const double cardRadius = 14;

  /// 화면 좌우 여백.
  static double get pagePad => 16.w;
}
