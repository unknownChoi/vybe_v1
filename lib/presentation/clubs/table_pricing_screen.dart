import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/navigation/swipe_back_page_route.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/clubs/viewmodels/club_detail_viewmodel.dart';
import 'package:vybe/presentation/clubs/widgets/table_pricing_section.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_state_message.dart';

/// CLUB-023 테이블 가격 — 클럽 상세 홈 탭 '테이블 › 가격표' 로 들어온다.
///
/// 디자인 `table_pricing.jsx`. 본문은 [TablePricingSection].
///
/// 데이터는 `clubTableLayoutProvider` 하나 — 클럽 상세 홈 탭이 이미 읽어 둬서
/// 여기서 다시 watch 해도 Firestore read 가 추가로 들지 않는다(같은 provider 캐시).
/// 예약 문의 버튼이 쓰는 전화·오픈채팅은 `clubDetailProvider` · `clubInfoProvider`
/// 로 이미 받아 둔 값이라 역시 추가 조회가 없다.
///
/// ⚠ **이 화면만 오로라 배경이 아니다** — 디자인 CLUB-023 은 단색 `#101013`
/// 이다(같은 묶음의 CLUB-021 은 명시적으로 오로라라 화면별 선택이다).
/// 본문 카드가 전부 불투명이라 오로라가 뒤에서 비칠 자리도 없다.
class TablePricingScreen extends ConsumerWidget {
  final String clubId;
  final String clubName;

  const TablePricingScreen({
    super.key,
    required this.clubId,
    required this.clubName,
  });

  static Future<void> push(
    BuildContext context, {
    required String clubId,
    required String clubName,
  }) {
    return Navigator.of(context).push(
      SwipeBackPageRoute(
        builder: (_) =>
            TablePricingScreen(clubId: clubId, clubName: clubName),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutAsync = ref.watch(clubTableLayoutProvider(clubId));
    final layout = layoutAsync.value;
    final club = ref.watch(clubDetailProvider(clubId)).value;
    final info = ref.watch(clubInfoProvider(clubId)).value;

    return Scaffold(
      backgroundColor: VybeColors.background,
      body: Column(
        children: [
          const VybePushHeader(title: '테이블 가격'),
          Expanded(
            child: layout == null && !layoutAsync.isLoading
                ? const VybeStateMessage('등록된 테이블 정보가 없어요')
                : ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: 40.h + MediaQuery.paddingOf(context).bottom,
                    ),
                    children: [
                      if (layout == null)
                        const TablePricingSkeleton()
                      else
                        TablePricingSection(
                          layout: layout,
                          clubName: clubName,
                          clubArea: club?.area ?? '',
                          clubPhone: club?.phone ?? '',
                          clubOpenChatUrl: info?.openChatUrl ?? '',
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
