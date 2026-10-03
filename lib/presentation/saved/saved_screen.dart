import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/data/repositories/favorite_repository_impl.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_empty_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/saved/saved_common.dart';
import 'package:vybe/presentation/saved/viewmodels/saved_viewmodel.dart';
import 'package:vybe/presentation/saved/widgets/saved_explore_button.dart';
import 'package:vybe/presentation/saved/widgets/saved_grid_card.dart';
import 'package:vybe/presentation/saved/widgets/saved_list_card.dart';
import 'package:vybe/presentation/saved/widgets/saved_skeleton.dart';
import 'package:vybe/presentation/saved/widgets/saved_toolbar.dart';

// ============================================================
// 찜한 클럽 화면 (saved_glass.html · Liquid Glass 리뉴얼)
//
// 배경·카드는 공용 글래스 요소(RenewGlassCard · VybeEmptyCard) 재사용.
// favorites Firestore 연동. 정렬, 리스트↔그리드 뷰 지원.
// ============================================================

/// 홈 탭 인덱스 (빈 화면 CTA에서 사용).
const int _kHomeTabIndex = 0;

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  bool _isGrid = false;
  SavedSortOption _sort = SavedSortOption.recent;

  List<SavedEntry> _applySort(List<SavedEntry> all) {
    final list = List.of(all);
    switch (_sort) {
      case SavedSortOption.rating:
        list.sort((a, b) => b.club.rating.compareTo(a.club.rating));
        break;
      case SavedSortOption.name:
        list.sort((a, b) => a.club.name.compareTo(b.club.name));
        break;
      case SavedSortOption.open:
        list.sort((a, b) {
          final byOpen = (b.isOpen ? 1 : 0) - (a.isOpen ? 1 : 0);
          return byOpen != 0 ? byOpen : b.club.rating.compareTo(a.club.rating);
        });
        break;
      case SavedSortOption.recent:
        list.sort((a, b) => b.savedAt.compareTo(a.savedAt));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final savedAsync = ref.watch(savedClubsProvider);
    // MediaQuery 전체가 아니라 쓰는 값만 구독한다 — 키보드가 올라오는 것 같은
    // 무관한 변화에 화면 전체가 다시 빌드되지 않게.
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final screenSize = MediaQuery.sizeOf(context);
    // 결정 ⑫ — 이제 하단 탭이 아니라 마이에서 push 로 열린다.
    // pushHidingNavBar 로 들어와 floating nav 가 내려가 있으므로 그만큼의 여백이 필요 없다.
    final bottomPad = bottomInset + 28.h;

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
          // 오로라는 상태바 뒤까지 깔되, 콘텐츠는 인셋 아래에서 시작한다
          // (sticky 툴바가 노치·시계 뒤로 들어가지 않도록).
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 결정 ⑫ — push 로 열리는 화면이 되어 뒤로가기 상단바가 필요하다
                  // (탭 본문일 때는 돌아갈 곳이 없어 없었다).
                  const VybePushHeader(title: '찜한 클럽'),
                  Expanded(
                    child: _buildContent(savedAsync, bottomPad, screenSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    AsyncValue<List<SavedEntry>> savedAsync,
    double bottomPad,
    Size screen,
  ) {
    return savedAsync.when(
      loading: () => ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: const [SavedSkeleton()],
      ),
      error: (e, _) => VybeStateMessage(
        '찜 목록을 불러오지 못했어요',
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        lineHeight: 20,
      ),
      data: (all) {
        final isEmpty = all.isEmpty;
        final sorted = _applySort(all);
        // 그리드 셀 높이 = 정사각 이미지 + 이름/메타 영역(46).
        final cellWidth = (screen.width - 32.w - 14.w) / 2;

        return CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SavedHeader(
                count: all.length,
                openCount: all.where((e) => e.isOpen).length,
              ),
            ),
            // 디자인은 찜이 0곳이어도 헤더·툴바를 그대로 둔다(SGHeader·SGToolbar 가
            // 조건 없이 렌더된다) — 베타가 숨기던 것을 디자인대로 되돌렸다.
            // 디자인 `position: sticky, top: 0` — 툴바에 글래스 배경이 생겨
            // pinned 로 둬도 카드가 글자 뒤로 비치지 않는다.
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyToolbar(
                child: SavedToolbar(
                  isGrid: _isGrid,
                  sort: _sort,
                  onView: (g) => setState(() => _isGrid = g),
                  onSort: (s) => setState(() => _sort = s),
                ),
              ),
            ),
            if (isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                  child: VybeEmptyCard(
                    icon: Icons.favorite_border_rounded,
                    title: '아직 찜한 클럽이 없어요',
                    message: '마음에 드는 클럽의 하트를 눌러서\n나만의 리스트를 만들어보세요',
                    padding: 32,
                    circleSize: 76,
                    iconColor: Colors.white,
                    gap: 14,
                    titleStyle: VybeTypography.heading4.copyWith(
                      color: Colors.white,
                    ),
                    action: SavedExploreButton(
                      // push 화면이 되어, 탭만 바꾸면 이 화면이 위에 남는다 → 먼저 닫는다.
                      onTap: () {
                        Navigator.of(context).maybePop();
                        ref
                            .read(tabSwitchRequestProvider.notifier)
                            .request(_kHomeTabIndex);
                      },
                    ),
                  ),
                ),
              )
            else if (_isGrid)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14.h,
                    crossAxisSpacing: 14.w,
                    mainAxisExtent: cellWidth + 46.h,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => SavedGridCard(
                      entry: sorted[i],
                      onUnsave: _unsave,
                    ),
                    childCount: sorted.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                sliver: SliverList.separated(
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, i) => SavedListCard(
                    entry: sorted[i],
                    onUnsave: _unsave,
                  ),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: bottomPad)),
          ],
        );
      },
    );
  }

  Future<void> _unsave(String clubId) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    await ref.read(favoriteRepositoryProvider).removeFavorite(uid, clubId);
  }
}

/// 정렬·뷰 툴바를 화면 위에 고정하는 sliver 껍데기 (디자인 `position: sticky`).
class _StickyToolbar extends SliverPersistentHeaderDelegate {
  const _StickyToolbar({required this.child});

  final Widget child;

  @override
  double get minExtent => kSavedToolbarHeight.h;

  @override
  double get maxExtent => kSavedToolbarHeight.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      SizedBox(height: kSavedToolbarHeight.h, child: child);

  @override
  bool shouldRebuild(covariant _StickyToolbar old) => old.child != child;
}
