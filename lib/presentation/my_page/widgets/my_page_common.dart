import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/common/version_gate/viewmodels/version_check_viewmodel.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

// ============================================================
// 마이페이지 **리뉴얼** 공통 위젯 (my_renew.html 디자인 기반)
//
// 토큰·글래스 카드·섹션 헤더는 공용 [RenewGlass]를 그대로 쓰고,
// 여기엔 마이 화면 계열에서만 쓰는 조각(메뉴 행·토글·입력)을 둔다.
// 푸시 헤더·등장 애니메이션은 공용 `VybePushHeader`·`VybeFadeInUp`.
// ============================================================

/// 위험(로그아웃·삭제) 강조 색 — 디자인 RED[500].
const Color kMyDanger = VybeColors.accentRed500;

/// 화면 좌우 여백 (디자인 PAGE_H).
const double kMyPagePad = RenewGlass.pagePad;

/// 섹션 사이 간격 (디자인 SP.xxl).
const double kMySectionGap = 24;

/// 유리 인풋 배경 (디자인 MRField) — 카드보다 옅은 채움.
BoxDecoration myInputDecoration({double radius = 12}) => BoxDecoration(
  color: const Color(0x0FFFFFFF), // rgba(255,255,255,0.06)
  borderRadius: BorderRadius.circular(radius.r),
  border: Border.all(color: RenewGlass.tileBorder),
);

// ============================================================
// 메뉴 행 (MRRow)
// ============================================================

/// `[아이콘] 라벨 ... 값 >` 한 줄. 카드로 감싸지 않고 헤어라인으로만 나눈다.
///
/// [danger]는 로그아웃처럼 되돌리기 어려운 항목 — 붉은 톤에 꺾쇠를 빼서
/// '이동'이 아니라 '실행'임을 드러낸다.
class MyMenuRow extends StatelessWidget {
  /// [RenewIcons] 패스.
  final String icon;
  final String label;

  /// 우측 보조 값 (예: 리뷰 개수). null이면 표시 안 함.
  final String? value;

  final VoidCallback onTap;
  final bool danger;

  /// 섹션 마지막 행 — 아래 구분선을 지운다.
  final bool last;

  const MyMenuRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.danger = false,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final tint = danger ? kMyDanger : null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: RenewGlass.hair)),
        ),
        child: Row(
          children: [
            Container(
              width: 34.r,
              height: 34.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tint?.withValues(alpha: 0.12) ?? RenewGlass.tileFill,
                border: Border.all(
                  color: tint?.withValues(alpha: 0.26) ?? RenewGlass.tileBorder,
                ),
              ),
              child: RenewIcon(
                path: icon,
                size: 17,
                color: tint ?? RenewGlass.t2,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: VybeTypography.body3.copyWith(
                  fontWeight: FontWeight.w500,
                  color: tint ?? RenewGlass.t1,
                ),
              ),
            ),
            if (value != null) ...[
              SizedBox(width: 12.w),
              Text(value!, style: RenewGlass.body(color: RenewGlass.t4)),
            ],
            if (!danger) ...[
              SizedBox(width: 12.w),
              const RenewChevron(
                dir: RenewChevronDir.right,
                size: 16,
                color: Color(0x52FFFFFF), // rgba(255,255,255,0.32)
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 토글 (MRToggle)
// ============================================================

/// 46×28 스위치. 켜짐 보라 · 꺼짐 흰 16%.
class MyToggle extends StatelessWidget {
  final bool on;
  final VoidCallback onTap;

  const MyToggle({super.key, required this.on, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 46.w,
        height: 28.h,
        padding: EdgeInsets.all(3.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99.r),
          color: on
              ? VybeColors.mainPurple500
              : Colors.white.withValues(alpha: 0.16),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22.r,
            height: 22.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 5.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 입력 필드 (MRField)
// ============================================================

/// 라벨 + 유리 상자 한 칸. 상자 안 내용([child])은 화면이 정한다
/// (편집 가능한 `TextField` / 읽기 전용 `Text`).
class MyField extends StatelessWidget {
  final String label;
  final Widget child;

  const MyField({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text(
            label,
            style: RenewGlass.caption(lineHeight: 14, weight: FontWeight.w700),
          ),
        ),
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          alignment: Alignment.centerLeft,
          decoration: myInputDecoration(),
          child: child,
        ),
      ],
    );
  }
}

// ============================================================
// 작은 조각
// ============================================================

/// 아이콘 하나만 든 원형 유리 타일 (빈 상태 일러스트용).
class MyGlassTile extends StatelessWidget {
  final String icon;
  final double size;
  final double radius;

  const MyGlassTile({
    super.key,
    required this.icon,
    this.size = 60,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: RenewGlass.tileFill,
        borderRadius: BorderRadius.circular(radius.r),
        border: Border.all(color: RenewGlass.tileBorder),
      ),
      child: RenewIcon(path: icon, size: size * 0.42, color: RenewGlass.t4),
    );
  }
}

/// 하단 앱 버전 표기. 값은 앱 실행 시 버전 게이트가 이미 읽어둔 것을
/// 그대로 쓴다 — 화면마다 다시 조회하지 않는다.
/// (하드코딩하면 릴리스마다 잊고 안 고쳐서 실제 버전과 어긋난다)
class AppVersionLabel extends ConsumerWidget {
  const AppVersionLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 버전 문자열만 구독 — 복귀 재검사로 정책이 바뀌어도 버전이 그대로면
    // 이 라벨은 리빌드되지 않는다.
    final label = ref.watch(
      versionCheckProvider.select((s) => s.value?.versionLabel ?? ''),
    );
    return Text(
      label.isEmpty ? 'vybe' : 'vybe · 버전 $label',
      textAlign: TextAlign.center,
      style: RenewGlass.caption(),
    );
  }
}

// ============================================================
// 아바타 (MRAvatar)
// ============================================================

/// 프로필 아바타 — 사진이 있으면 네트워크 이미지, **없으면 기본 프로필**.
///
/// 기본 프로필은 디자인 `my_edit_v2.jsx` 의 `MEAvatar` — 어두운 보라 원 +
/// 좌상단 하이라이트 + 중성 실루엣 글리프다.
///
/// ⚠ 예전엔 이름 **첫 글자**를 넣었는데 그 이름이 실명(`users.name`)이라
/// 실명 첫 글자가 리뷰·프로필에 노출됐다. 닉네임 도입과 함께 글자를 빼고
/// 실루엣으로 바꿨다 — 사진을 안 올린 계정이 서로 구별되지 않아도 되고,
/// 이름을 아바타에 넣지 않으면 노출 경로가 통째로 사라진다.
class MyAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  /// 라임 링 + 퍼플 글로우. 편집 화면처럼 강조가 필요 없으면 false.
  final bool ring;

  const MyAvatar({
    super.key,
    required this.imageUrl,
    this.size = 76,
    this.ring = true,
  });

  @override
  Widget build(BuildContext context) {
    final side = size.r;
    final child = imageUrl.isNotEmpty
        ? ClipOval(
            child: Image(
              image: vybeNetworkImage(
                imageUrl,
                cacheWidth: (side * MediaQuery.devicePixelRatioOf(context))
                    .round(),
              ),
              width: side,
              height: side,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            ),
          )
        : _placeholder();

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: ring
            ? [
                // 0 0 0 2px rgba(181,255,96,0.5)
                BoxShadow(
                  color: VybeColors.mainLime500.withValues(alpha: 0.5),
                  spreadRadius: 2.r,
                ),
                // 0 10px 26px rgba(119,49,254,0.38)
                BoxShadow(
                  color: VybeColors.mainPurple500.withValues(alpha: 0.38),
                  blurRadius: 26.r,
                  offset: Offset(0, 10.h),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  /// 사진을 안 올렸을 때의 기본 프로필 (디자인 MEAvatar).
  ///
  /// 그라데이션 150deg → 방향 벡터 (sin150, -cos150) = 오른아래.
  Widget _placeholder() {
    return Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(-0.5, -0.87),
          end: Alignment(0.5, 0.87),
          colors: [Color(0xFF2A2440), Color(0xFF221C36), Color(0xFF171327)],
          stops: [0, 0.52, 1],
        ),
      ),
      // 테두리는 자식 위에 — 클립되는 원에서 decoration 에 넣으면 호에서 선이
      // 사라진다 (CLAUDE.md '라운드 카드에 테두리' 참고).
      foregroundDecoration: const BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: RenewGlass.cardBorder)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // radial-gradient(90% 70% at 30% 12%, rgba(200,168,255,0.20), …62%)
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(-0.4, -0.76),
                  radius: 0.9,
                  colors: [Color(0x33C8A8FF), Color(0x00C8A8FF)],
                  stops: [0, 0.62],
                ),
              ),
            ),
          ),
          Padding(
            // 디자인 marginTop size*0.03 — 어깨가 원 아래에 닿게 살짝 내린다.
            padding: EdgeInsets.only(top: (size * 0.06).r),
            child: RenewIcon(
              path: RenewIcons.user,
              size: size * 0.52,
              color: const Color(0x9EFFFFFF), // rgba(255,255,255,0.62)
              strokeWidth: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 가입 방식 라벨
// ============================================================

/// `users.provider` → 사람이 읽는 이름.
///
/// ⚠ 본인인증 가입의 값은 `'identity'` 다 — uid 가 `phone:` 로 시작하는데
/// 필드는 `identity` 라서 헷갈리기 쉽다(`onUserCreated`·`saveUserProfile`
/// 둘 다 그렇게 쓴다). 옛 문서를 위해 `'phone'` 도 같이 받아 둔다.
const Map<String, String> kProviderNames = {
  'naver': '네이버',
  'kakao': '카카오',
  'apple': 'Apple',
  'identity': '휴대폰',
  'phone': '휴대폰',
};

/// `카카오로 가입` — 모르는 값이면 빈 문자열(화면이 줄째로 뺀다).
String providerJoinLabel(String? provider) {
  final name = kProviderNames[provider];
  return name == null ? '' : '$name로 가입';
}

// ============================================================
// 하단 고정 액션 바
// ============================================================

/// 저장 버튼처럼 화면 맨 아래 붙는 유리 바 (디자인 MREditScreen 하단).
class MyBottomBar extends StatelessWidget {
  final Widget child;

  const MyBottomBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.paddingOf(context).bottom;
    // 배경 없음 — 스크롤 영역 '아래'에 붙는 고정 행이라 뒤로 지나가는 콘텐츠가
    // 없다. 색을 칠하면 오로라 위에 저 줄만 다른 띠로 보인다(구분은 hairline만).
    return Container(
      padding: EdgeInsets.fromLTRB(
        kMyPagePad.w,
        12.h,
        kMyPagePad.w,
        // 홈 인디케이터가 있으면 그만큼, 없으면 디자인 값 30.
        safe > 30.h ? safe : 30.h,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: RenewGlass.hair)),
      ),
      child: child,
    );
  }
}
