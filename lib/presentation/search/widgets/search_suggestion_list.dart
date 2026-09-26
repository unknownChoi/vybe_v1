import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/search/viewmodels/search_viewmodel.dart';
import 'package:vybe/presentation/search/widgets/search_suggestion_item.dart';

/// 검색어 입력 중 뜨는 연관 클럽 목록.
///
/// 첫 응답을 기다리는 동안은 줄 골격 3개, 결과가 없으면 빈 화면. 글자를 바꾸는
/// 동안은 뷰모델이 이전 결과를 들고 있어 목록이 깜빡이지 않는다.
class SearchSuggestionList extends ConsumerWidget {
  /// 지금 입력된 검색어 (일치 구간 강조에 쓴다).
  final String query;

  /// 항목 탭 → 클럽 상세로 직행.
  final ValueChanged<String> onSelectClub;

  const SearchSuggestionList({
    super.key,
    required this.query,
    required this.onSelectClub,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(searchSuggestionViewModelProvider);
    final clubs = suggestions.clubs;
    if (clubs.isEmpty) {
      return suggestions.loading
          ? const _RowsSkeleton()
          : const SizedBox.shrink();
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: clubs.length,
      itemBuilder: (_, i) => SearchSuggestionItem(
        keyword: clubs[i].name,
        query: query,
        onTap: () => onSelectClub(clubs[i].clubId),
      ),
    );
  }
}

/// [SearchSuggestionItem] 골격 — 50 높이 줄 3개.
class _RowsSkeleton extends StatelessWidget {
  const _RowsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              children: [
                VybeSkel(width: 18.r, height: 18.r, radius: 999),
                SizedBox(width: 12.w),
                VybeSkel(width: 160.w, height: 15.h),
              ],
            ),
          ),
      ],
    );
  }
}
