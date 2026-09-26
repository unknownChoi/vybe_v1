import 'package:flutter/material.dart';
import 'package:vybe/core/utils/gradient_palette.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/data/models/free_entry_policy.dart';
import 'package:vybe/presentation/common/club_page_models.dart';
import 'package:vybe/presentation/common/free_entry_labels.dart';

/// 입장비 무료 카드 1장에 필요한 값만 담은 **표시 전용** 모델.
///
/// '지금 무료인가'는 목록 전체가 **같은 시각**으로 판정해야 해서(카드마다
/// `DateTime.now()`를 다시 읽으면 정렬과 표기가 따로 논다) 매핑 시점에 한 번 굳혀 둔다.
/// 거리도 같은 이유로 매핑 때 내 좌표로 한 번 계산한다.
class FreeEntryClub {
  final String id;
  final String name;
  final String area;
  final String genre;
  final double dist;
  final double rating;

  /// 무료입장 조건 (`freeEntry.condition`, 비면 '입장비 무료').
  final String cond;
  final bool open;
  final String thumbnailUrl;
  final List<Color> gradient;

  /// 시간대 무료(`freeEntry.type == 'timed'`)인지. false면 상시 무료.
  final bool timed;

  /// 지금 무료인지 — **영업 중일 때만** true.
  /// 문 닫은 클럽의 '지금 무료'는 거짓 정보다(홈 카드와 같은 규칙).
  final bool freeNow;

  /// 지금 무료(시간대)일 때 진행 중인 창의 시작·끝 — 카운트다운·진행 막대용.
  /// 상시 무료거나 지금 무료가 아니면 null.
  final DateTime? activeStartsAt;
  final DateTime? activeEndsAt;

  /// 지금 무료가 아닌 시간대 클럽의 안내 — `금 22:00부터 무료` / `22:00 – 01:00 무료`.
  /// 지금 무료거나 상시 무료면 null.
  final String? pendingLabel;

  /// '지금 무료순' 정렬 키 — 지금 무료면 끝나는 시각, 아니면 시작 시각.
  final DateTime? sortAt;

  const FreeEntryClub({
    required this.id,
    required this.name,
    required this.area,
    required this.genre,
    required this.dist,
    required this.rating,
    required this.cond,
    required this.open,
    required this.thumbnailUrl,
    required this.gradient,
    required this.timed,
    required this.freeNow,
    this.activeStartsAt,
    this.activeEndsAt,
    this.pendingLabel,
    this.sortAt,
  });

  /// `ClubModel` → 카드 모델.
  ///
  /// [now] 는 목록 전체가 같은 값을 넘긴다. [origin] 은 내 좌표(거리 계산 기준).
  factory FreeEntryClub.fromClub(
    ClubModel c,
    DateTime now, {
    ({double lat, double lng})? origin,
  }) {
    final status = c.freeEntry.statusAt(now);
    final timed = c.freeEntry.isTimed;

    // 무료 창 판정과 **같은 now** 로 영업 여부를 묻는다. today.isCurrentlyOpen 은
    // 벽시계를 다시 읽어, 주입한 시각과 섞이면 '무료 창인데 영업 종료' 같은
    // 어긋난 답이 나온다.
    final openNow = c.operatingHours.dayAt(now).isOpenAt(now);
    final freeNow = status.isFreeNow && openNow;

    final active = status.active;
    final endsAt = status.activeEndsAt;
    final startsAt = active == null || endsAt == null
        ? null
        : endsAt.subtract(Duration(minutes: active.durationMinutes));

    return FreeEntryClub(
      id: c.clubId,
      name: c.name,
      area: c.area,
      genre: c.genre,
      dist: vybeClubDistanceKm(c.lat, c.lng, origin: origin),
      rating: c.rating,
      cond: _conditionLabel(c),
      open: openNow,
      thumbnailUrl: c.thumbnailUrl,
      gradient: clubGradientFor(c.clubId),
      timed: timed,
      freeNow: freeNow,
      activeStartsAt: timed && freeNow ? startsAt : null,
      activeEndsAt: timed && freeNow ? endsAt : null,
      pendingLabel: timed && !freeNow ? _pendingLabel(status, now) : null,
      sortAt: status.isFreeNow ? status.activeEndsAt : status.nextStartsAt,
    );
  }
}

/// 무료입장 조건 문구 — 없으면 기본 문구.
String _conditionLabel(ClubModel c) =>
    c.freeEntry.condition.isNotEmpty ? c.freeEntry.condition : '입장비 무료';

/// 지금 무료가 아닌 시간대 클럽 문구.
///
/// 다음 창이 있으면 `금 22:00부터 무료`. 창 안인데 문을 안 열었으면(next 없음)
/// 창 자체를 말한다(`22:00 – 01:00 무료`). 창을 못 읽은 데이터는 종류만.
String _pendingLabel(FreeEntryStatus status, DateTime now) {
  final starts = freeEntryStartsLabel(status.nextStartsAt, now);
  if (starts != null) return '$starts 무료';
  final range = (status.active ?? status.next)?.rangeLabel;
  return range == null ? '시간대 무료' : '$range 무료';
}

/// '지금 무료순' — ① 지금 무료 먼저 ② 시각(끝나는/시작하는) 이른 순 ③ 가까운 순.
///
/// 지금 무료인 카드끼리는 **곧 끝나는 것**을 앞에 둔다(놓치면 안 되는 순서).
/// 상시 무료는 [FreeEntryClub.sortAt] 이 null이라 같은 freeNow 그룹 안에서 거리순이 된다.
int compareFreeNow(FreeEntryClub a, FreeEntryClub b) {
  if (a.freeNow != b.freeNow) return a.freeNow ? -1 : 1;
  final at = a.sortAt;
  final bt = b.sortAt;
  if (at != null && bt != null && at != bt) return at.compareTo(bt);
  if ((at == null) != (bt == null)) return at == null ? -1 : 1;
  return a.dist.compareTo(b.dist);
}
