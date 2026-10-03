import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/models/v1/v1_enums.dart';
import 'package:vybe/presentation/clubs/widgets/club_glass.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_empty_card.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';
import 'package:vybe/presentation/main_scaffold/main_scaffold.dart'
    show navBarTotalHeight;
import 'package:vybe/presentation/notifications/notification_item.dart';
import 'package:vybe/presentation/notifications/notification_route.dart';
import 'package:vybe/presentation/notifications/viewmodels/notification_viewmodel.dart';
import 'package:vybe/presentation/notifications/widgets/notification_card.dart';
import 'package:vybe/presentation/notifications/widgets/notification_header.dart';
import 'package:vybe/presentation/notifications/widgets/notification_placeholders.dart';

/// HOME-007 알림 — 리퀴드 글래스.
///
/// 디자인: `notifications_glass_shell.jsx` · `notifications_glass.jsx`.
/// 오로라 배경 + 큰 타이틀 헤더 + 종류 필터 칩 + 시간 섹션 라벨 +
/// 종류별 색 링을 두른 글래스 카드 목록.
///
/// 데이터는 설계 4장 `users/{uid}/notifications` — UI 단계에선 Fake 가 흘려보낸다
/// ([notificationListProvider]). 카드를 누르면 읽음 처리 + 설계 10장 '이동 화면'
/// 으로 간다([openNotification]).
class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  /// 카드가 순차로 나타나는 간격 (디자인 animationDelay: index * 45ms).
  static const _kStagger = Duration(milliseconds: 45);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(notificationListProvider);
    final filter = ref.watch(notificationFilterProvider);
    // 경과 문구·시간 섹션 기준은 화면당 한 번 — 카드마다 다시 읽으면 같은
    // 목록에서 기준이 어긋난다(CLAUDE.md 규칙).
    final now = DateTime.now();

    final all = [
      for (final n in listAsync.value ?? const [])
        NotificationItem.from(n, now: now),
    ];
    final items = filter == null
        ? all
        : all.where((n) => n.category == filter).toList();
    final unread = all.where((n) => !n.read).length;

    // 홈 탭 Navigator 위에 push되므로 하단 floating nav가 그대로 떠 있다.
    final bottomPad = 28.h + navBarTotalHeight(context);

    return Scaffold(
      backgroundColor: ClubGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: VybeAurora()),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: NotificationHeader(
                  unread: unread,
                  onReadAll: unread > 0
                      ? () => ref.read(notificationActionsProvider).markAllRead()
                      : null,
                ),
              ),
              SliverToBoxAdapter(
                child: _FilterChips(
                  selected: filter,
                  onSelect: (c) =>
                      ref.read(notificationFilterProvider.notifier).select(c),
                ),
              ),
              if (listAsync.isLoading)
                const SliverToBoxAdapter(child: NotificationSkeleton())
              else if (listAsync.hasError)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 0),
                    child: const VybeStateMessage('알림을 불러오지 못했어요'),
                  ),
                )
              else if (items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                    // 디자인 NGEmpty.
                    child: const VybeEmptyCard(
                      icon: Icons.notifications_none_rounded,
                      title: '알림이 없어요',
                      message: '새로운 소식이 오면\n여기에서 가장 먼저 알려드릴게요',
                    ),
                  ),
                )
              else
                ..._sectionSlivers(context, ref, items),
              SliverToBoxAdapter(child: SizedBox(height: bottomPad)),
            ],
          ),
        ],
      ),
    );
  }

  /// 시간 섹션(오늘/이번 주/이전)별 라벨 + 카드 목록. 빈 섹션은 통째로 생략.
  List<Widget> _sectionSlivers(
    BuildContext context,
    WidgetRef ref,
    List<NotificationItem> items,
  ) {
    final slivers = <Widget>[];

    for (final (section, label) in kNotiSections) {
      final rows = items.where((n) => n.section == section).toList();
      if (rows.isEmpty) continue;

      slivers.add(
        SliverToBoxAdapter(
          child: _SectionLabel(label: label, count: rows.length),
        ),
      );
      slivers.add(
        SliverList.builder(
          itemCount: rows.length,
          itemBuilder: (_, i) => Padding(
            // 카드 사이 간격 10px.
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
            child: NotificationCard(
              noti: rows[i],
              appearDelay: _kStagger * i,
              onTap: () => openNotification(context, ref, rows[i]),
            ),
          ),
        ),
      );
    }
    return slivers;
  }
}

/// 종류 필터 칩 줄 (디자인 `NG_FILTERS`).
///
/// 설계 6-0 HOME-007 「필터는 category 필드」 — 디자인 shell 이 선언만 하고
/// 페이지가 안 그리던 것을 설계대로 살렸다(진행 기록 결정 ⓕ).
class _FilterChips extends StatelessWidget {
  final NotificationCategory? selected;
  final ValueChanged<NotificationCategory?> onSelect;

  const _FilterChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: kNotiFilters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final (category, label) = kNotiFilters[i];
          return RenewChip(
            label: label,
            selected: category == selected,
            onTap: () => onSelect(category),
          );
        },
      ),
    );
  }
}

/// 시간 섹션 라벨 — `오늘 3` + 오른쪽으로 사라지는 헤어라인.
class _SectionLabel extends StatelessWidget {
  final String label;
  final int count;

  const _SectionLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
      child: Row(
        children: [
          Text(
            label,
            style: ClubGlass.caption(
              color: ClubGlass.t2,
              weight: FontWeight.w700,
            ).copyWith(letterSpacing: 12 * 0.04),
          ),
          SizedBox(width: 10.w),
          Text(
            '$count',
            style: ClubGlass.caption(
              color: ClubGlass.t4,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 10.w),
          const Expanded(child: _FadingHairline()),
        ],
      ),
    );
  }
}

class _FadingHairline extends StatelessWidget {
  const _FadingHairline();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x21FFFFFF), Color(0x00FFFFFF)],
        ),
      ),
    );
  }
}
