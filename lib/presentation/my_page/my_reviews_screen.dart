import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/repositories/review_repository_impl.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_skeleton.dart';
import 'package:vybe/presentation/clubs/review_write_screen.dart';
import 'package:vybe/presentation/clubs/viewmodels/review_viewmodel.dart';
import 'package:vybe/presentation/common/renew/renew_button.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_confirm_dialog.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/common/widgets/vybe_toast.dart';
import 'package:vybe/presentation/main_scaffold/nav_bar_visibility_provider.dart';
import 'package:vybe/presentation/my_page/viewmodels/my_page_viewmodel.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';
import 'package:vybe/presentation/my_page/widgets/my_review_card.dart';
import 'package:vybe/presentation/my_page/widgets/my_review_toolbar.dart';

// ============================================================
// 내 리뷰 — 리뉴얼 (my_renew_screens.jsx · MRReviewsScreen)
//
// collectionGroup 쿼리로 전 클럽에서 내 리뷰를 모아 보여주고
// 정렬·사진 필터 + 수정(리뷰 작성 화면 재사용) + 삭제를 지원한다.
// 카드는 widgets/my_review_card.dart, 칩 줄은 widgets/my_review_toolbar.dart.
//
// 디자인의 '좋아요순' 정렬과 카드 하단 좋아요 수는 reviews 스키마에
// 좋아요 필드가 없어 제외했다.
// ============================================================

/// 검색 탭 인덱스 (MainScaffold PageView 기준).
const int _kSearchTabIndex = 3;

class MyReviewsScreen extends ConsumerWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 헤더 개수는 **필터와 무관한 전체 개수** — 사진 필터를 켰다고 '3개'가
    // 되면 리뷰가 사라진 것처럼 읽힌다.
    final async = ref.watch(myReviewsProvider);
    final total = async.value?.length;
    // 스켈레톤은 첫 로딩에만 — 에러도 value 가 null 이라 total 로 가르면
    // '불러오지 못했어요' 옆에서 헤더·툴바 shimmer 가 영영 돈다.
    final loading = async.isLoading && !async.hasValue;
    final visible = ref.watch(visibleMyReviewsProvider);

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: VybeAurora())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VybePushHeader(
                title: '내 리뷰',
                trailing: loading
                    ? VybeSkel(width: 28.w, height: 14.h)
                    : total == null
                    ? null
                    : Text(
                        '$total개',
                        style: RenewGlass.caption(lineHeight: 14),
                      ),
              ),
              // 로딩 중엔 칩 자리를 잡아 둔다 — 안 그리면 데이터가 온 순간
              // 헤더·툴바·목록이 한꺼번에 튀어나온다.
              if (loading)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    kMyPagePad.w,
                    18.h,
                    kMyPagePad.w,
                    0,
                  ),
                  child: const RenewSkelChips(widths: [62, 62]),
                )
              else if (total != null && total > 0)
                const MyReviewToolbar(),
              Expanded(
                child: visible.when(
                  loading: () => _skeleton(context),
                  error: (_, __) => _message('리뷰를 불러오지 못했어요'),
                  data: (entries) {
                    if (total == 0) return _empty(context, ref);
                    // 전체엔 있는데 목록이 비었다 = 사진 필터가 다 걸러낸 것.
                    if (entries.isEmpty) return _message('사진이 있는 리뷰가 없어요');
                    return _list(context, ref, entries);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  EdgeInsets _listPadding(BuildContext context) => EdgeInsets.fromLTRB(
    kMyPagePad.w,
    14.h,
    kMyPagePad.w,
    24.h + MediaQuery.paddingOf(context).bottom,
  );

  /// 실제 카드와 같은 골격(클럽명·별점 메타·본문·사진) 3장.
  Widget _skeleton(BuildContext context) {
    return ListView.separated(
      padding: _listPadding(context),
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
      itemBuilder: (_, __) => const RenewSkelReviewCard(),
    );
  }

  Widget _list(
    BuildContext context,
    WidgetRef ref,
    List<MyReviewEntry> entries,
  ) {
    return ListView.separated(
      padding: _listPadding(context),
      // 마지막 한 칸은 안내 문구.
      itemCount: entries.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
      itemBuilder: (context, i) {
        if (i == entries.length) {
          return const RenewFooterNote(
            text: '리뷰는 클럽 상세 페이지에 공개되며, 운영 정책에 어긋나면 안내 후 삭제될 수 있어요.',
          );
        }
        final entry = entries[i];
        return MyReviewCard(
          entry: entry,
          onEdit: () => _openEdit(context, ref, entry),
          onDelete: () => _confirmDelete(context, ref, entry),
        );
      },
    );
  }

  Widget _message(String text) => VybeStateMessage(text, lineHeight: 16);

  /// 리뷰가 한 건도 없을 때. 디자인의 '리뷰 쓰기' 버튼은 클럽을 골라야
  /// 열 수 있으므로 클럽을 찾는 화면(검색 탭)으로 보낸다.
  Widget _empty(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyGlassTile(icon: RenewIcons.review),
          SizedBox(height: 16.h),
          Text(
            '작성한 리뷰가 없어요',
            style: VybeTypography.body3.copyWith(
              fontWeight: FontWeight.w600,
              color: RenewGlass.t1,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            '다녀온 클럽의 후기를 남겨보세요',
            style: RenewGlass.body(color: RenewGlass.t4, lineHeight: 20),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: 190.w,
            child: RenewButton(
              label: '클럽 둘러보기',
              onTap: () => _openSearch(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  /// 탭 전환 요청은 MainScaffold가 받는다 — 이 화면이 위에 남아 있으면
  /// 바뀐 탭이 가려지므로 먼저 닫는다.
  void _openSearch(BuildContext context, WidgetRef ref) {
    Navigator.of(context).maybePop();
    ref.read(tabSwitchRequestProvider.notifier).request(_kSearchTabIndex);
  }

  /// 리뷰 수정 — 작성 화면을 수정 모드로 연다.
  /// 이 목록은 collectionGroup 스트림이라 저절로 갱신되지만, 다른 탭에 떠 있을 수
  /// 있는 클럽 상세 리뷰 탭(일회성 조회)은 여기서 invalidate 해야 맞춰진다.
  Future<void> _openEdit(
    BuildContext context,
    WidgetRef ref,
    MyReviewEntry entry,
  ) async {
    // 클럽은 목록이 이미 조인해 들고 있다 — 넘기면 작성 화면이 재조회 없이
    // 바로 이름·썸네일을 그린다.
    final updated = await ReviewWriteScreen.pushEdit(
      context,
      review: entry.review,
      club: entry.club,
    );
    if (updated != true || !context.mounted) return;
    ref.invalidate(reviewListProvider(entry.review.clubId));
    VybeToast.show(context, message: '리뷰를 수정했어요');
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    MyReviewEntry entry,
  ) async {
    final confirmed = await VybeConfirmDialog.show(
      context,
      title: '리뷰를 삭제할까요?',
      message: '${entry.clubName} 리뷰가 삭제되며\n되돌릴 수 없어요.',
      confirmLabel: '삭제',
    );
    if (!confirmed || !context.mounted) return;

    await ref
        .read(reviewRepositoryProvider)
        .deleteReview(entry.review.clubId, entry.review.reviewId);
    if (!context.mounted) return;
    ref.invalidate(reviewListProvider(entry.review.clubId));
    ref.invalidate(myReviewCountProvider);
    VybeToast.show(context, message: '리뷰를 삭제했어요');
  }
}
