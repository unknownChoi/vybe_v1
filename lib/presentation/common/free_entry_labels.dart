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
/// 디자인 원본은 `22:00 오픈`이지만 '오픈'은 **영업 시작**으로 읽혀
/// 무료 시작 시각과 혼동된다 → `…부터`로 바꿨다.
String? freeEntryStartsLabel(DateTime? startsAt, DateTime now) {
  if (startsAt == null) return null;
  final hhmm = fmtHhmm(startsAt);
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(startsAt.year, startsAt.month, startsAt.day);
  if (day == today) return '$hhmm부터';
  return '${weekdayLabelKo(startsAt.weekday)} $hhmm부터';
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
