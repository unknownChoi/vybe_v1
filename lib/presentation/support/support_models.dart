import 'package:flutter/material.dart';
import 'package:vybe/data/models/inquiry_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

// ============================================================
// 고객센터 화면 표시 전용 모델 (디자인 `support_parts.jsx`).
//
// **영문 키 ↔ 한글 라벨·색 대응은 여기 한 곳**(편의시설 `ClubFacility`와 같은 규칙).
// Firestore에는 키만 저장한다 — 문구를 고칠 때 기존 문의 문서를 손대지 않기 위함.
// ============================================================

/// 유형 태그 색 한 벌 (디자인 `SUP_TONE`).
class InquiryTone {
  final Color fill;
  final Color border;
  final Color foreground;

  const InquiryTone(this.fill, this.border, this.foreground);

  /// 이용 문의 — 파랑.
  static const InquiryTone blue = InquiryTone(
    Color(0x2E2B6BFF), // rgba(43,107,255,0.18)
    Color(0x6B2B6BFF), // rgba(43,107,255,0.42)
    RenewGlass.link,
  );

  /// 오류 신고 — 레드.
  static const InquiryTone red = InquiryTone(
    Color(0x21FF5C5F), // rgba(255,92,95,0.13)
    Color(0x47FF5C5F), // rgba(255,92,95,0.28)
    VybeColors.accentRed500,
  );

  /// 신고·제보 — 라벤더.
  static const InquiryTone lavender = InquiryTone(
    Color(0x26C8A8FF), // rgba(200,168,255,0.15)
    Color(0x52C8A8FF), // rgba(200,168,255,0.32)
    RenewGlass.lavender,
  );

  /// 계정·기타 — 중립.
  static const InquiryTone gray = InquiryTone(
    Color(0x14FFFFFF), // rgba(255,255,255,0.08)
    Color(0x24FFFFFF), // rgba(255,255,255,0.14)
    VybeColors.gray400,
  );
}

/// 문의 유형. `inquiries.category` 값 = [name].
///
/// ⚠ 디자인(`SUP_TYPES`)은 계정·기타를 한 칸('계정/회원정보/기타')으로 합쳤지만
/// 여기선 **5종 그대로 둔다** — 키가 곧 저장값이라 합치면 이미 쌓인 `account`
/// 문의가 갈 곳을 잃는다. 색·모양은 디자인 그대로다.
enum InquiryCategory {
  service('이용 문의', InquiryTone.blue),
  bug('오류 신고', InquiryTone.red),
  report('신고·제보', InquiryTone.lavender),
  account('계정·회원정보', InquiryTone.gray),
  etc('기타', InquiryTone.gray);

  const InquiryCategory(this.label, this.tone);

  final String label;

  /// 태그 색 한 벌.
  final InquiryTone tone;

  /// 저장된 키 → 유형. **모르는 키는 '기타'로 폴백**한다 —
  /// 어드민이 값을 늘려도 앱이 영문 키를 그대로 노출하지 않게.
  static InquiryCategory fromKey(String key) => InquiryCategory.values
      .firstWhere((c) => c.name == key, orElse: () => InquiryCategory.etc);
}

/// 답변 상태 라벨·색 (디자인 `SupStatusBadge`).
/// 완료는 라임, 대기는 중립 회색 — 상태 문자열이 늘어나도 화면은 여기만 본다.
class InquiryStatusStyle {
  const InquiryStatusStyle._();

  static String label(InquiryModel inquiry) =>
      inquiry.isAnswered ? '답변 완료' : '답변 대기';

  static Color color(InquiryModel inquiry) =>
      inquiry.isAnswered ? VybeColors.mainLime500 : VybeColors.gray400;
}

/// 목록 상단 탭 (디자인 `SUP_TABS`).
enum InquiryTab {
  all('전체'),
  waiting('답변 대기'),
  answered('답변 완료');

  const InquiryTab(this.label);

  final String label;

  /// 이 탭이 보여 줄 문의만 남긴다.
  List<InquiryModel> filter(List<InquiryModel> items) => switch (this) {
    InquiryTab.all => items,
    InquiryTab.waiting => items.where((i) => !i.isAnswered).toList(),
    InquiryTab.answered => items.where((i) => i.isAnswered).toList(),
  };
}

/// 문의 작성 제약 — Firestore Rules 의 create 검증과 **같은 값이어야 한다**.
/// 화면이 더 느슨하면 보내기를 눌렀을 때 서버가 403 으로 되돌린다.
///
/// ⚠ 제목 상한은 디자인(40)이 아니라 **Rules 값 50**을 쓴다 — 둘 중 하나를
/// 골라야 한다면 서버가 실제로 검사하는 쪽이 정본이다.
const int kInquiryMaxPhotos = 4;
const int kInquiryTitleMin = 2;
const int kInquiryTitleMax = 50;
const int kInquiryContentMin = 10;
const int kInquiryContentMax = 1000;

/// 본문 글자수가 이만큼을 넘으면 카운터가 노란색으로 바뀐다 (디자인 900).
const int kInquiryContentWarn = 900;

/// 답변을 기다리는 문의가 이만큼 쌓이면 새 문의를 막는다.
/// 서버가 건수를 셀 수 없어(Rules 로는 집계 불가) 화면에서만 거는 가드다.
const int kInquiryPendingLimit = 5;

/// 답변까지 걸리는 기간 안내 — 목록 빈 상태·대기 카드·작성 안내가 같이 쓴다.
/// 한 화면에서만 고치면 같은 약속을 화면마다 다르게 말하게 된다.
const String kInquiryAnswerSla = '영업일 기준 1~3일';
