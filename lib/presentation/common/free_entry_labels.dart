/// 무료입장 시간 표기 문구 — 홈 '이 시간에만 무료입장' 카드와 입장비 무료 페이지가
/// 같은 문장을 쓴다. 두 화면이 같은 클럽을 다르게 말하면 안 되므로 한 곳에 둔다.
///
/// 순수 함수만 — Flutter·Firebase 의존 없음. 판정 자체는
/// `FreeEntryPolicy.statusAt`, 여기는 그 결과를 사람 말로 옮기는 일만 한다.
library;

import 'package:vybe/core/utils/date_format.dart';

/// 남은 시간 → `38분 남음` / `2시간 남음` / `1시간 20분 남음`.
/// 1분 미만이면 `곧 종료`. null이면 null.
String? freeEntryRemainingLabel(Duration? left) {
  if (left == null) return null;
  final minutes = left.inMinutes;
  if (minutes < 1) return '곧 종료';
  if (minutes < 60) return '$minutes분 남음';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '$h시간 남음' : '$h시간 $m분 남음';
}

/// 다음 무료 시작 → `22:00부터`. 오늘이 아니면 요일을 앞에 붙인다(`금 22:00부터`).
///
/// 뒤에 말을 **이어 붙이는** 자리용이다 — 입장비 무료 페이지가
/// `금 22:00부터 무료` 로 쓴다. 홈 카드 pill 처럼 혼자 서는 자리는
/// [freeEntryOpenLabel] 를 쓴다.
String? freeEntryStartsLabel(DateTime? startsAt, DateTime now) {
  if (startsAt == null) return null;
  final hhmm = fmtHhmm(startsAt);
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(startsAt.year, startsAt.month, startsAt.day);
  if (day == today) return '$hhmm부터';
  return '${weekdayLabelKo(startsAt.weekday)} $hhmm부터';
}

/// 다음 무료 시작 → `22:00 오픈`. 오늘이 아니면 요일을 앞에 붙인다.
///
/// 홈 '타임 무료입장' 카드 pill 문구 — 디자인 `{c.from} 오픈`(home.jsx:404).
/// 시계 아이콘이 같이 붙고 pill 이 '지금 무료' 와 같은 자리라
/// '오픈' 이 영업 시작이 아니라 **무료 시작**으로 읽힌다.
///
/// ⚠ [freeEntryStartsLabel] 과 **문구가 다른 건 자리가 달라서**다 — 이쪽은
/// 혼자 서는 pill, 저쪽은 `… 무료` 를 이어 붙이는 문장이다. 같은 함수로 묶으면
/// 입장비 무료 페이지가 `금 22:00 오픈 무료` 가 된다.
///
/// ⚠ 요일 접두는 디자인에 없다 — 디자인 예시값이 전부 오늘 창이라 그 경우가
/// 안 나온다. 날짜를 빼면 '22:00 오픈' 이 모레 창을 가리킬 수 있어 남긴다.
String? freeEntryOpenLabel(DateTime? startsAt, DateTime now) {
  if (startsAt == null) return null;
  final hhmm = fmtHhmm(startsAt);
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(startsAt.year, startsAt.month, startsAt.day);
  if (day == today) return '$hhmm 오픈';
  return '${weekdayLabelKo(startsAt.weekday)} $hhmm 오픈';
}

const _kWeekdayLabels = ['월', '화', '수', '목', '금', '토', '일'];

/// `DateTime.weekday`(1=월) → `월`~`일`.
String weekdayLabelKo(int weekday) => _kWeekdayLabels[(weekday - 1) % 7];

/// 남은 시간 표기 — 하루 이상이면 `2일 3시간`, 한 시간 이상이면 `1시간 05분`,
/// 그 안쪽은 `07:42` 처럼 초까지 센다 (디자인 VF_LEFT).
///
/// 클럽 상세 카운트다운과 입장비 무료 페이지 카드가 같이 쓴다.
String formatFreeCountdown(Duration left) {
  if (left.inDays >= 1) return '${left.inDays}일 ${left.inHours % 24}시간';
  if (left.inHours >= 1) {
    return '${left.inHours}시간 ${(left.inMinutes % 60).toString().padLeft(2, '0')}분';
  }
  return '${left.inMinutes.toString().padLeft(2, '0')}:'
      '${(left.inSeconds % 60).toString().padLeft(2, '0')}';
}
