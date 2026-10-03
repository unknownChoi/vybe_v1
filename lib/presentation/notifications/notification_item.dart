import 'package:flutter/material.dart';
import 'package:vybe/core/utils/date_format.dart';
import 'package:vybe/core/utils/gradient_palette.dart';
import 'package:vybe/data/models/v1/pass_models.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/design_system/colors.dart';

/// HOME-007 알림 **표시 모델** · 종류별 스타일.
///
/// 데이터 모델은 `data/models/v1/pass_models.dart` 의 [AppNotificationModel]
/// (= 설계 4장 `users/{uid}/notifications`)이고, 여기선 그걸 카드가 그릴 수 있는
/// 모양으로만 바꾼다 — 경과 시각 문구 · 시간 섹션 · CTA · 썸네일 그라데이션.
///
/// ⚠ 종류는 [NotificationCategory] 하나다 — 예전 화면 전용 `NotiType` 에만 있던
/// `friend`(팔로우)는 v1 디자인 `NG_TYPES` · 설계 10장 어디에도 없어 뺐다.

// ── 섹션(시간 그룹) ──
enum NotiSection { today, week, earlier }

/// 섹션 노출 순서 + 라벨 (디자인 `NG_SECTIONS`).
const kNotiSections = [
  (NotiSection.today, '오늘'),
  (NotiSection.week, '이번 주'),
  (NotiSection.earlier, '이전'),
];

/// 종류 필터 칩 (디자인 `NG_FILTERS`).
///
/// 설계 6-0 HOME-007 「필터는 category 필드」 + 3장 색인
/// `notifications (category ASC, createdAt DESC)`.
/// null = '전체'.
const kNotiFilters = <(NotificationCategory?, String)>[
  (null, '전체'),
  (NotificationCategory.reservation, '예약·입장'),
  (NotificationCategory.club, '클럽 소식'),
  (NotificationCategory.promo, '프로모션'),
  (NotificationCategory.activity, '활동'),
];

class NotificationItem {
  final String id;
  final NotificationCategory category;
  final NotiSection section;
  final bool read;

  /// '12분 전' · '어제' 같은 경과 시각 문구.
  final String time;
  final String title;
  final String body;
  final String? cta;

  /// CTA를 강조(라임 채움)할지. 안 읽은 알림에서만 적용된다.
  final bool primary;

  /// 좌측 썸네일 그라데이션 (없으면 종류 아이콘 타일로 대체).
  final List<Color>? thumb;

  /// 탭했을 때 갈 화면 ID (설계 10장 '이동 화면').
  final String route;

  /// 그 화면이 필요로 하는 클럽.
  final String clubId;

  const NotificationItem({
    required this.id,
    required this.category,
    required this.section,
    required this.read,
    required this.time,
    required this.title,
    required this.body,
    required this.route,
    this.clubId = '',
    this.cta,
    this.primary = false,
    this.thumb,
  });

  /// 설계 모델 → 표시 모델.
  ///
  /// [now] 는 화면당 한 번 읽어 넘긴다 — 카드마다 `DateTime.now()` 를 다시
  /// 읽으면 같은 목록 안에서 섹션과 경과 문구의 기준이 어긋난다(CLAUDE.md 규칙).
  factory NotificationItem.from(AppNotificationModel n, {required DateTime now}) {
    final gap = now.difference(n.createdAt);
    final clubId = n.data['clubId'] ?? '';
    // 디자인은 예약·클럽 알림에만 매장 썸네일을 깐다 — 프로모션·리뷰·공지는
    // 종류 아이콘 타일이다. 색은 공용 폴백 그라데이션(클럽마다 늘 같은 색).
    final hasThumb =
        clubId.isNotEmpty &&
        (n.category == NotificationCategory.reservation ||
            n.category == NotificationCategory.club);

    return NotificationItem(
      id: n.notificationId,
      category: n.category,
      section: _sectionOf(gap),
      read: n.read,
      time: fmtRelativeAgo(gap),
      title: n.title,
      body: n.body,
      route: n.route,
      clubId: clubId,
      cta: _kCta[n.type],
      // 디자인에서 라임 채움 CTA 는 입장 확정 알림 하나다(`primary: true`).
      primary: n.type == 'reservation_confirmed',
      thumb: hasThumb ? clubGradientFor(clubId) : null,
    );
  }

  NotificationItem copyWith({bool? read}) => NotificationItem(
    id: id,
    category: category,
    section: section,
    read: read ?? this.read,
    time: time,
    title: title,
    body: body,
    route: route,
    clubId: clubId,
    cta: cta,
    primary: primary,
    thumb: thumb,
  );
}

/// 유형별 CTA 라벨 (디자인 `NG_NOTIS` 의 `cta`). 없으면 CTA 줄을 안 그린다.
const _kCta = <String, String>{
  'reservation_confirmed': '예약 코드 보기',
  'promo': '혜택 보기',
  'review_request': '리뷰 남기기',
};

NotiSection _sectionOf(Duration gap) {
  if (gap.inDays < 1) return NotiSection.today;
  if (gap.inDays < 7) return NotiSection.week;
  return NotiSection.earlier;
}

// ── 종류별 색/아이콘 매핑 (디자인 NG_TYPES) ──
// hue = 아이콘 색, tint = 타일·카드 틴트, ring = 카드 외곽 링.
class NotiTypeStyle {
  final IconData icon;
  final Color hue;
  final Color tint;
  final Color ring;

  const NotiTypeStyle(this.icon, this.hue, this.tint, this.ring);
}

const _kTypeStyles = <NotificationCategory, NotiTypeStyle>{
  NotificationCategory.reservation: NotiTypeStyle(
    Icons.confirmation_number_outlined,
    VybeColors.mainPurple500,
    Color(0x387731FE), // rgba(119,49,254,0.22)
    Color(0x737731FE), // rgba(119,49,254,0.45)
  ),
  NotificationCategory.club: NotiTypeStyle(
    Icons.music_note_rounded,
    VybeColors.mainLime500,
    Color(0x29B5FF60), // rgba(181,255,96,0.16)
    Color(0x61B5FF60), // rgba(181,255,96,0.38)
  ),
  NotificationCategory.promo: NotiTypeStyle(
    Icons.sell_outlined,
    Color(0xFFFF5C7A),
    Color(0x2EFF5C7A), // rgba(255,92,122,0.18)
    Color(0x66FF5C7A), // rgba(255,92,122,0.40)
  ),
  NotificationCategory.activity: NotiTypeStyle(
    Icons.favorite_rounded,
    Color(0xFF5B8CFF),
    Color(0x2E5B8CFF),
    Color(0x665B8CFF),
  ),
  NotificationCategory.review: NotiTypeStyle(
    Icons.star_rounded,
    Color(0xFFFFC94D),
    Color(0x29FFC94D),
    Color(0x5CFFC94D),
  ),
  NotificationCategory.notice: NotiTypeStyle(
    Icons.campaign_outlined,
    Color(0xE6FFFFFF),
    Color(0x1AFFFFFF),
    Color(0x33FFFFFF),
  ),
};

/// 모르는 종류는 공지 스타일(중립 흰색)로 — 영문 키를 화면에 노출하지 않는다.
NotiTypeStyle notiStyleOf(NotificationCategory category) =>
    _kTypeStyles[category] ?? _kTypeStyles[NotificationCategory.notice]!;
