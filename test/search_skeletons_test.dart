import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/data/models/search_history_model.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/search/viewmodels/search_viewmodel.dart';
import 'package:vybe/presentation/search/widgets/recent_keywords_section.dart';
import 'package:vybe/presentation/search/widgets/search_section_skeletons.dart';
import 'package:vybe/presentation/search/widgets/search_suggestion_list.dart';

/// 검색 기본 화면의 로딩 자리는 스피너·빈 화면이 아니라 골격이어야 한다.
class _LoadingSuggestions extends SearchSuggestionViewModel {
  @override
  SearchSuggestions build() =>
      const SearchSuggestions(keyword: '홍대', clubs: [], loading: true);
}

Widget _wrap(Widget child) => ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (_, __) => MaterialApp(home: Scaffold(body: child)),
    );

void main() {
  testWidgets('최근 검색어 로딩 — pill 골격 4개, 스피너 없음', (tester) async {
    await tester.pumpWidget(_wrap(RecentKeywordsSection(
      historyAsync: const AsyncLoading<List<SearchHistoryModel>>(),
      onKeyword: (_) {},
      onDelete: (_) {},
      onClearAll: () {},
    )));
    await tester.pump();
    expect(find.byType(VybeSkel), findsNWidgets(4));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('연관 검색어 첫 응답 대기 — 줄 골격 3개', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        searchSuggestionViewModelProvider.overrideWith(_LoadingSuggestions.new),
      ],
      child: _wrap(SearchSuggestionList(query: '홍대', onSelectClub: (_) {})),
    ));
    await tester.pump();
    expect(find.byType(VybeSkel), findsNWidgets(6)); // 줄당 원 + 막대
  });

  testWidgets('해시태그·인기 검색어 스켈레톤이 그려진다', (tester) async {
    await tester.pumpWidget(_wrap(const SingleChildScrollView(
      child: Column(children: [
        PopularHashtagsSkeleton(),
        TrendingSearchesSkeleton(),
      ]),
    )));
    await tester.pump();
    // 헤드 2 + pill 6 + 5줄×2칸×2열 = 28
    expect(find.byType(VybeSkel), findsNWidgets(28));
  });
}
