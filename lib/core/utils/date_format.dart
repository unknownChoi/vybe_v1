// 날짜·시각 표기 — `intl` 없이 padLeft 두 줄. 화면마다 손으로 다시 짜면
// `2026.9.5` 처럼 0 패딩이 빠진 사본이 하나씩 생긴다.

/// `2026.09.15` (공지·문의·리뷰 날짜).
String fmtDateDot(DateTime d) => '${d.year}.${_two(d.month)}.${_two(d.day)}';

/// `22:00` (공연·무료입장 시각).
String fmtHhmm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

String _two(int n) => n.toString().padLeft(2, '0');
