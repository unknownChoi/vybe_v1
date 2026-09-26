import 'package:flutter/material.dart';
import 'package:vybe/data/models/club_model.dart';
import 'package:vybe/presentation/common/widgets/vybe_chip_poster_grid.dart';
import 'package:vybe/presentation/common/widgets/vybe_club_poster_card.dart';
import 'package:vybe/presentation/non_smoking/non_smoking_models.dart';

/// '장르별로 금연 클럽 확인' 섹션 — 장르 칩(단일 선택) + 가까운 순 2열 포스터 그리드.
/// **sliver** — `CustomScrollView.slivers` 안에 둔다.
///
/// 디자인 `smoke_free.jsx GenreSection`. 칩 + 격자는 공용 [VybeChipPosterGrid]
/// (서비스 음료와 같은 구조)이고, 여기 남는 건 이 화면의 문구·장르 판정·뱃지뿐이다.
///
/// 카드 하단 금연 뱃지 (디자인 `PolicyBadge` strong) — 데이터가 `isNonSmoking`
/// 불리언 하나라 디자인의 정책 문구 3종은 못 나눈다. 히어로 문구('실내 금연인
/// 클럽만 모았어요')와 같은 말 하나로 통일한다.
class NonSmokingGenreGrid extends StatelessWidget {
  /// 이 페이지의 금연 클럽 전체(활성). 장르 칩은 이 목록에 실제로 있는 장르만 만든다.
  final List<ClubModel> clubs;
  final bool loading;

  const NonSmokingGenreGrid({
    super.key,
    required this.clubs,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return VybeChipPosterGrid(
      title: '장르별로 금연 클럽 확인',
      chips: nonSmokingGenresOf(clubs),
      clubs: clubs,
      matches: (c, genre) => c.genre == genre,
      loading: loading,
      accent: kNonSmokingAccent,
      emptyText: '아직 금연 클럽이 없어요',
      footer: (_) => const VybePosterBadge(
        icon: Icons.smoke_free_rounded,
        label: '실내 금연',
        accent: kNonSmokingAccent,
      ),
    );
  }
}
