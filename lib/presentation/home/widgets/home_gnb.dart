import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/navigation/swipe_back_page_route.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_glass_button.dart';
import 'package:vybe/presentation/notifications/notification_screen.dart';
import 'package:vybe/presentation/notifications/viewmodels/notification_viewmodel.dart';

/// 홈 상단 바 로고의 위치·크기(디자인 px).
///
/// 스플래시 퇴장 애니메이션이 로고를 **정확히 이 자리로** 날려 보낸 뒤 사라진다
/// ([VybeSplash.logoLanding]). 값이 어긋나면 착지 순간 로고가 한 칸 튀므로
/// 상수 하나를 양쪽이 같이 본다.
const kHomeGnbHPadding = 20.0;
const kHomeGnbTopGap = 6.0;
const kHomeGnbLogoHeight = 22.0;

class HomeGnb extends ConsumerWidget {
  final VoidCallback? onSearchTap;
  final bool scrolled;

  const HomeGnb({super.key, this.onSearchTap, this.scrolled = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final top = MediaQuery.paddingOf(context).top;
    // 디자인 Tile 의 `badge` — 안 읽은 알림이 있을 때만 점을 찍는다.
    // 숫자는 안 쓴다(디자인 배지가 점이다). 설계 6-0 HOME-005 참고.
    final hasUnread = ref.watch(
      unreadNotificationCountProvider.select((s) => (s.value ?? 0) > 0),
    );

    // 그림자는 **ClipRect 밖**에 둔다 — 안에 두면 바 아래로 떨어지는 30px 가
    // 바 경계에서 잘려 안 보인다.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        boxShadow: scrolled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.30),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ]
            : const [],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: scrolled
              ? ImageFilter.blur(sigmaX: 20, sigmaY: 20)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          // 스크롤하면 틴트 + 하단 헤어라인 + 그림자까지 얹는다(디자인 TopBar).
          // 블러만으로는 본문 사진이 바 뒤로 비쳐 로고·아이콘이 묻힌다.
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              // linear-gradient(180deg, rgba(255,255,255,.07),
              //   rgba(255,255,255,0) 70%), rgba(14,13,18,.62)
              color: scrolled ? const Color(0x9E0E0D12) : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: scrolled ? RenewGlass.hair : Colors.transparent,
                ),
              ),
            ),
            // 틴트 위 흰 광택은 **내용 밑**이다 — foregroundDecoration 에 두면
            // 로고·아이콘 위로 덮인다.
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: scrolled
                      ? const [Color(0x12FFFFFF), Color(0x00FFFFFF)]
                      : const [Colors.transparent, Colors.transparent],
                  stops: const [0, 0.7],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  kHomeGnbHPadding.w,
                  top + kHomeGnbTopGap.h,
                  kHomeGnbHPadding.w,
                  10.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/common/vybe_white_logo.svg',
                      height: kHomeGnbLogoHeight.h,
                    ),
                    Row(
                      children: [
                        VybeGlassButton(
                          icon: Icons.search_rounded,
                          onTap: onSearchTap ?? () {},
                          size: 36,
                          iconSize: 20,
                          hitSize: 40,
                        ),
                        SizedBox(width: 4.w),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            VybeGlassButton(
                              icon: Icons.notifications_none_rounded,
                              onTap: () => Navigator.of(context).push(
                                SwipeBackPageRoute(
                                  builder: (_) => const NotificationScreen(),
                                ),
                              ),
                              size: 36,
                              iconSize: 20,
                              hitSize: 40,
                            ),
                            if (hasUnread)
                              Positioned(
                                top: 8.r,
                                right: 8.r,
                                child: IgnorePointer(
                                  child: Container(
                                    width: 7.r,
                                    height: 7.r,
                                    decoration: BoxDecoration(
                                      color: VybeColors.mainPurple500,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: VybeColors.background,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
