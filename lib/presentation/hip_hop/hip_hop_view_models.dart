import 'package:flutter/material.dart';
import 'package:vybe/data/models/performance_model.dart';
import 'package:vybe/presentation/hip_hop/hip_hop_gradients.dart';

// 힙합 페이지 표시 모델 — Firestore 모델(PerformanceModel)을 화면이 쓰기 좋은
// 형태로 옮긴 어댑터. 로직 없음.
//
// 포스터 카드 뷰모델·매퍼는 공용 `VybeClubPoster` / `vybeClubPosterFrom`
// (`common/club_page_models.dart`) — 힙합은 `headliner:` 와 `bg: hipGradFor` 만 넘긴다.

// ── DJ rail 모델 ──
class HipHopDj {
  final int id;
  final String clubId; // 탭 → 클럽 상세 이동용
  final String dj;
  final String club;
  final String time;
  final bool isDj; // true=DJ(disc), false=rapper(mic)
  final List<Color> bg;
  const HipHopDj({
    required this.id,
    required this.clubId,
    required this.dj,
    required this.club,
    required this.time,
    required this.isDj,
    required this.bg,
  });
}

// 오늘 공연 → DJ rail(아티스트) 뷰모델.
HipHopDj hipHopDjFrom(PerformanceModel p, int idx) => HipHopDj(
  id: idx,
  clubId: p.clubId,
  dj: p.artistName,
  club: p.clubName,
  time: p.hhmm,
  isDj: p.isDj,
  bg: hipGradFor(p.clubId),
);
