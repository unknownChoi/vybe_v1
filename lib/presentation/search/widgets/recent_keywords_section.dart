import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/search_history_model.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/search/widgets/keyword_chip.dart';
import 'package:vybe/presentation/search/widgets/search_section_head.dart';

/// 최근 검색어 섹션 — 칩 목록 + '전체 삭제'.
class RecentKeywordsSection extends StatelessWidget {
  final AsyncValue<List<SearchHistoryModel>> historyAsync;

  final ValueChanged<String> onKeyword;

  /// 칩 하나 삭제 (historyId).
  final ValueChanged<String> onDelete;

  final VoidCallback onClearAll;

  const RecentKeywordsSection({
    super.key,
    required this.historyAsync,
    required this.onKeyword,
    required this.onDelete,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchSectionHead(
          icon: Icon(
            Icons.access_time_rounded,
            size: 15.r,
            color: VybeColors.gray300,
          ),
          title: '최근 검색어',
          // 지울 게 없으면 '전체 삭제'도 없다.
          right: historyAsync.maybeWhen(
            data: (list) => list.isEmpty ? null : _ClearAll(onTap: onClearAll),
            orElse: () => null,
          ),
        ),
        historyAsync.when(
          loading: () => const _ChipsSkeleton(),
          // 기록을 못 읽어도 검색은 계속 할 수 있어야 하니 섹션만 조용히 접는다.
          error: (_, __) => const SizedBox.shrink(),
          data: (list) => list.isEmpty ? const _EmptyNote() : _chips(list),
        ),
      ],
    );
  }

  Widget _chips(List<SearchHistoryModel> list) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final item in list)
          KeywordChip(
            item: item,
            onTap: () => onKeyword(item.keyword),
            onDelete: () => onDelete(item.historyId),
          ),
      ],
    );
  }
}

class _ClearAll extends StatelessWidget {
  final VoidCallback onTap;
  const _ClearAll({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        '전체 삭제',
        style: VybeTypography.caption.copyWith(color: VybeColors.gray500),
      ),
    );
  }
}

/// 칩 자리 스켈레톤 — [KeywordChip] 높이(≈34) pill 4개, 같은 Wrap 간격.
class _ChipsSkeleton extends StatelessWidget {
  const _ChipsSkeleton();

  static const _widths = [72.0, 56.0, 88.0, 64.0];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final w in _widths)
          VybeSkel(width: w.w, height: 34.h, radius: 999),
      ],
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: Text(
          '최근 검색 기록이 없어요',
          style: VybeTypography.body4.copyWith(color: VybeColors.gray600),
        ),
      ),
    );
  }
}
