import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  /// `users.gender`(`'male'`·`'female'`). 사진이 없을 때 그릴 기본 피규어를
  /// 고른다 — 빈 값·모르는 값은 중성.
  ///
  /// ⚠ 성별을 **드러내려고** 받는 값이 아니다. 디자인 `MRAvatar` 가
  /// 이름 이니셜 대신 성별 피규어를 기본 그림으로 쓰기 때문이다
  /// (`MRGenderFigure` 의 `female`·`male` 분기).
  final String gender;

  const MyAvatar({
    super.key,
    required this.imageUrl,
    this.size = 76,
    this.ring = true,
    this.gender = '',
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

  /// 사진을 안 올렸을 때의 기본 프로필 — 디자인 `MRAvatar`.
  ///
  /// 퍼플 그라데이션 원 + 성별 3D 피규어(디자인 `MRGenderFigure`)를
  /// **아래 가운데**에 붙여 어깨가 원 밑변에 닿게 둔다
  /// (디자인 `placeItems: 'end center'`).
  ///
  /// ⚠ 피규어는 `SvgPicture.string` 으로 그린다 — path 10여 개 + 그라데이션
  /// 5개를 CustomPainter 로 옮기면 디자인 원본과 좌표가 어긋나기 쉽다.
  /// SVG 문자열이 곧 디자인 원본이라 눈으로 대조가 된다.
  Widget _placeholder() {
    return Container(
      width: size.r,
      height: size.r,
      clipBehavior: Clip.antiAlias,
      // linear-gradient(150deg,#8b52ff 0%,#7731FE 45%,#4E24A0 100%)
      // 150deg → 방향 벡터 (sin150, -cos150) = 오른아래.
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(-0.5, -0.87),
          end: Alignment(0.5, 0.87),
          colors: [Color(0xFF8B52FF), Color(0xFF7731FE), Color(0xFF4E24A0)],
          stops: [0, 0.45, 1],
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: SvgPicture.string(
        genderFigureSvg(gender),
        width: (size * 0.94).r,
        height: (size * 0.94).r,
      ),
    );
  }
}

/// 성별 3D 피규어 SVG — 디자인 `MRGenderFigure`(64×64 viewBox) 그대로.
///
/// 디자인은 한글 라벨에 `includes('여')`·`includes('남')` 를 걸지만
/// Firestore 는 영문 키만 저장하므로([kGenderNames]) 키로 가른다.
/// 모르는 값·빈 값은 중성 머리.
String genderFigureSvg(String gender) {
  final female = gender == 'female';
  final male = gender == 'male';
  const face =
      'M32 14.4c5.7 0 9.9 4.3 9.9 10.5 0 7.3-4.4 12.8-9.9 12.8s-9.9-5.5-9.9-12.8c0-6.2 4.2-10.5 9.9-10.5z';
  final body = female
      ? 'M13.8 62c0-11.9 6.4-18.6 18.2-18.6S50.2 49.4 50.2 62z'
      : 'M11.2 62c0-12.6 7.5-19.6 20.8-19.6S52.8 48.6 52.8 62z';
  // 긴 머리(뒤통수)는 여성만 — 디자인 `{female && <path .../>}`.
  final hairBack = female
      ? '<path d="M32 11.8c-8.8 0-13.9 5.7-13.9 13.9 0 4.5-.9 8.2-2.2 11.6-1 2.6-1.5 4.7-1.5 6.4 3.7-.3 6.4-1.7 7.8-3.9.9-1.5 1.4-3.3 1.4-5.5V25.4c0-4.1 3.4-7.1 8.4-7.1s8.4 3 8.4 7.1v8.9c0 2.2.5 4 1.4 5.5 1.4 2.2 4.1 3.6 7.8 3.9 0-1.7-.5-3.8-1.5-6.4-1.3-3.4-2.2-7.1-2.2-11.6 0-8.2-5.1-13.9-13.9-13.9z" fill="url(#hr)"/>'
      : '';
  final String hairFront;
  if (female) {
    hairFront =
        '<path d="M22.3 24.6c.6-7 4.4-10.9 9.7-10.9 4.7 0 8.2 3 9.4 8.2-2.6-2.4-5.5-3.3-8.7-2.8-4 .6-7.5 2.3-10.4 5.5z" fill="url(#hr)"/>';
  } else if (male) {
    hairFront =
        '<path d="M21.6 24.6c-.5-7.6 4.2-12.2 10.4-12.2s10.9 4.6 10.4 12.2c-.6-2-1.4-3.6-2.3-4.7-2.6 1.4-5.4 2.1-8.5 2.1-2.9 0-5.2-.4-6.9-1.3-1.2 1-2.1 2.3-3.1 3.9z" fill="url(#hr)"/>';
  } else {
    hairFront =
        '<path d="M22 24.4c-.4-7.2 4.1-11.6 10-11.6s10.4 4.4 10 11.6c-1.9-4.2-5.2-6.2-10-6.2s-8.1 2-10 6.2z" fill="url(#hr)"/>';
  }

  return '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" '
      'viewBox="0 0 64 64">'
      '<defs>'
      '<linearGradient id="sk" x1="24%" y1="4%" x2="80%" y2="98%">'
      '<stop offset="0" stop-color="#FFFDFF"/>'
      '<stop offset="0.5" stop-color="#F2E7FF"/>'
      '<stop offset="1" stop-color="#CBAEF7"/></linearGradient>'
      '<linearGradient id="bd" x1="16%" y1="0%" x2="88%" y2="100%">'
      '<stop offset="0" stop-color="#F6EFFF"/>'
      '<stop offset="0.52" stop-color="#DDCBFC"/>'
      '<stop offset="1" stop-color="#A98BE6"/></linearGradient>'
      '<linearGradient id="hr" x1="22%" y1="0%" x2="78%" y2="100%">'
      '<stop offset="0" stop-color="#5A2A9C"/>'
      '<stop offset="0.5" stop-color="#33135C"/>'
      '<stop offset="1" stop-color="#190826"/></linearGradient>'
      '<radialGradient id="hl" cx="34%" cy="24%" r="66%">'
      '<stop offset="0" stop-color="#FFFFFF" stop-opacity="0.7"/>'
      '<stop offset="1" stop-color="#FFFFFF" stop-opacity="0"/></radialGradient>'
      '<linearGradient id="sh" x1="0%" y1="0%" x2="100%" y2="30%">'
      '<stop offset="0" stop-color="#8B5FD6" stop-opacity="0"/>'
      '<stop offset="1" stop-color="#7C4CC9" stop-opacity="0.38"/></linearGradient>'
      '<clipPath id="cf"><path d="$face"/></clipPath>'
      '</defs>'
      '<path d="$body" fill="url(#bd)"/>'
      '<path d="M28.6 34.8h6.8v5.1c0 1.9-1.4 3-3.4 3s-3.4-1.1-3.4-3z" fill="url(#sk)"/>'
      '<path d="M28.6 38.8c2.1 1.7 4.7 1.7 6.8 0v1.1c0 1.9-1.4 3-3.4 3s-3.4-1.1-3.4-3z" '
      'fill="#7A54C4" opacity="0.32"/>'
      '$hairBack'
      '<path d="$face" fill="url(#sk)"/>'
      '<g clip-path="url(#cf)">'
      '<ellipse cx="26" cy="21" rx="8" ry="8.5" fill="url(#hl)"/>'
      '<ellipse cx="42" cy="28" rx="11" ry="14" fill="url(#sh)"/>'
      '</g>'
      '$hairFront'
      '<path d="M23.5 19.4c2-3.5 4.8-5.3 8.5-5.3.9 0 1.8.1 2.6.3-4.2.7-7.9 2.4-11.1 5z" '
      'fill="#FFFFFF" opacity="0.28"/>'
      '</svg>';
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

// ============================================================
// 가입 정보 표기 (MY-029 내 정보 · MY-030 프로필 수정 공용)
// ============================================================

/// `users.gender` → 사람이 읽는 이름.
/// 영문 키만 저장하므로 한글 라벨은 화면이 붙인다(provider·facilities 와 같은 규칙).
const Map<String, String> kGenderNames = {'male': '남성', 'female': '여성'};

/// `남성` — 모르는 값·빈 값이면 빈 문자열(화면이 줄째로 뺀다).
String genderLabel(String? gender) => kGenderNames[gender] ?? '';

/// `19970314` → `1997.03.14`. 8자리가 아니면 원문 그대로.
String birthDotLabel(String raw) => raw.length == 8
    ? '${raw.substring(0, 4)}.${raw.substring(4, 6)}.${raw.substring(6)}'
    : raw;
