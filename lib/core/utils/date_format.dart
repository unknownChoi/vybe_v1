// 날짜·시각 표기 — `intl` 없이 padLeft 두 줄. 화면마다 손으로 다시 짜면
// `2026.9.5` 처럼 0 패딩이 빠진 사본이 하나씩 생긴다.

/// `2026.09.15` (공지·문의·리뷰 날짜).
String fmtDateDot(DateTime d) => '${d.year}.${_two(d.month)}.${_two(d.day)}';

/// `22:00` (공연·무료입장 시각).
String fmtHhmm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

/// `12분 전` · `2시간 전` · `어제` · `3일 전` · `1주 전`
/// (디자인 HOME-007 알림 카드 표기).
///
/// [gap] 은 화면이 한 번 읽은 '지금'과의 차이다 — 카드마다 `DateTime.now()` 를
/// 다시 읽으면 같은 목록에서 기준이 어긋난다.
String fmtRelativeAgo(Duration gap) {
  if (gap.inMinutes < 1) return '방금';
  if (gap.inMinutes < 60) return '${gap.inMinutes}분 전';
  if (gap.inHours < 24) return '${gap.inHours}시간 전';
  if (gap.inDays == 1) return '어제';
  if (gap.inDays < 7) return '${gap.inDays}일 전';
  return '${gap.inDays ~/ 7}주 전';
}

String _two(int n) => n.toString().padLeft(2, '0');
