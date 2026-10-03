import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/utils/nickname.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/typography.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/renew/renew_icons.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';
import 'package:vybe/presentation/support/support_screen.dart';

// ============================================================
// 내 정보 수정 화면 조각 (디자인 `my_edit_v2.jsx`)
//
// 이 화면에서만 쓰는 것들만 둔다 — 아바타(`MyAvatar`)·푸시 헤더·하단 바처럼
// 마이 계열이 같이 쓰는 것은 `my_page_common.dart` 에 있다.
// ============================================================

/// 디자인 `MEPATH` — 이 화면에만 나오는 아이콘.
/// (`RenewIcons` 는 리뉴얼 **공용** 세트라 여기 것들을 섞지 않는다)
class _MePath {
  static const lock =
      '<rect x="4" y="10.5" width="16" height="10.5" rx="2.4"/>'
      '<path d="M8 10.5V7.6a4 4 0 0 1 8 0v2.9"/>';
  static const album =
      '<rect x="3" y="3" width="18" height="18" rx="2.6"/>'
      '<circle cx="8.8" cy="9" r="1.8"/>'
      '<path d="M4 17.5l4.6-4.3 3.6 3.2 3-2.7L20 17.5"/>';
  static const refresh =
      '<path d="M20.5 12a8.5 8.5 0 1 1-2.6-6.1"/>'
      '<polyline points="20.8 4.4 20.8 9.2 16 9.2"/>';
  static const warn =
      '<path d="M12 3.6 21.4 20H2.6z"/>'
      '<line x1="12" y1="10" x2="12" y2="14.6"/>'
      '<circle cx="12" cy="17.4" r="1"/>';
  static const check = '<polyline points="20 6 9 17 4 12"/>';
  static const shield =
      '<path d="M12 2.5 20 6v6c0 4.6-3.2 8.4-8 9.5-4.8-1.1-8-4.9-8-9.5V6z"/>'
      '<polyline points="8.8 12 11 14.2 15.4 9.8"/>';
  static const eye =
      '<path d="M1.8 12S5.6 5 12 5s10.2 7 10.2 7-3.8 7-10.2 7S1.8 12 1.8 12z"/>'
      '<circle cx="12" cy="12" r="3.2"/>';
  static const eyeOff =
      '<path d="M4 4l16 16"/>'
      '<path d="M9.6 5.5A9.6 9.6 0 0 1 12 5c6.4 0 10.2 7 10.2 7a17 17 0 0 1-2.7 3.5"/>'
      '<path d="M6.3 7.3A17.4 17.4 0 0 0 1.8 12S5.6 19 12 19c1.4 0 2.7-.3 3.8-.9"/>'
      '<path d="M9.8 9.9a3.2 3.2 0 0 0 4.4 4.4"/>';
}

// ============================================================
// 프로필 사진 (아바타 + 카메라 뱃지 + '사진 변경' pill)
// ============================================================

/// 사진을 고르는 자리. 아바타와 pill **둘 다** 시트를 연다 —
/// 뱃지만 누를 수 있게 두면 탭 타겟이 34px 뿐이다.
class ProfilePhotoPicker extends StatelessWidget {
  /// 지금 보여줄 사진. 비었으면 기본 프로필.
  final String imageUrl;

  /// 방금 고른(아직 안 올린) 로컬 파일. 있으면 이걸 먼저 보여준다 —
  /// 저장 전에도 결과가 보여야 '골랐다'는 게 전달된다.
  final ImageProvider? preview;

  final VoidCallback onTap;

  /// 사진이 없을 때의 기본 피규어를 고르는 값 — [MyAvatar.gender].
  final String gender;

  const ProfilePhotoPicker({
    super.key,
    required this.imageUrl,
    required this.onTap,
    this.preview,
    this.gender = '',
  });

  static const double _size = 104;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (preview != null)
                Container(
                  width: _size.r,
                  height: _size.r,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  foregroundDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: RenewGlass.cardBorder),
                    ),
                  ),
                  child: Image(image: preview!, fit: BoxFit.cover),
                )
              else
                MyAvatar(
                  imageUrl: imageUrl,
                  size: _size,
                  ring: false,
                  gender: gender,
                ),
              Positioned(
                right: -2.r,
                bottom: -2.r,
                child: const _CameraBadge(),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 34.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              color: RenewGlass.tileFill,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: RenewGlass.tileBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '사진 변경',
                  style: VybeTypography.button2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: RenewGlass.t1,
                  ),
                ),
                SizedBox(width: 6.w),
                const RenewChevron(
                  dir: RenewChevronDir.right,
                  size: 12,
                  color: RenewGlass.t3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraBadge extends StatelessWidget {
  const _CameraBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.r,
      height: 34.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: VybeColors.mainPurple500,
        border: Border.all(color: RenewGlass.ink, width: 3.r),
        boxShadow: [
          BoxShadow(
            color: VybeColors.mainPurple500.withValues(alpha: 0.5),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: const RenewIcon(
        path: RenewIcons.camera,
        size: 15,
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}

// ============================================================
// 닉네임 입력
// ============================================================

/// 라벨 + 글자수 + 입력칸 + 상태 아이콘 + 안내/오류 한 줄.
///
/// [serverError] 는 저장을 눌러 본 뒤에야 알 수 있는 것(중복 닉네임)이다 —
/// 형식 오류(`nicknameError`)보다 **우선**해 보여준다. 형식은 이미 통과했는데
/// 서버가 거부한 상황이라, 형식 안내를 띄우면 무엇이 문제인지 알 수 없다.
class NicknameField extends StatelessWidget {
  final TextEditingController controller;
  final String? serverError;

  const NicknameField({
    super.key,
    required this.controller,
    this.serverError,
  });

  @override
  Widget build(BuildContext context) {
    final raw = controller.text;
    final trimmed = raw.trim();
    final error = serverError ?? nicknameError(raw);
    final over = trimmed.characters.length > kNicknameMax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  '닉네임',
                  style: VybeTypography.button2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: RenewGlass.t1,
                  ),
                ),
              ),
              Text(
                '${trimmed.characters.length}/$kNicknameMax',
                style: RenewGlass.caption(
                  lineHeight: 14,
                  color: over ? kMyDanger : RenewGlass.t4,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 54.h,
          padding: EdgeInsets.only(left: 16.w, right: 44.w),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color(0x0FFFFFFF), // rgba(255,255,255,0.06)
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: error != null
                  ? const Color(0x8CFF5C5F) // rgba(255,92,95,0.55)
                  : RenewGlass.tileBorder,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              TextField(
                controller: controller,
                // 상한을 넘겨 입력되는 걸 막는다 — 서버 거부보다 먼저.
                maxLength: kNicknameMax,
                buildCounter: _noCounter,
                textInputAction: TextInputAction.done,
                style: VybeTypography.body3.copyWith(
                  fontWeight: FontWeight.w500,
                  color: RenewGlass.t1,
                ),
                cursorColor: VybeColors.mainPurple500,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: '닉네임을 입력해 주세요',
                  hintStyle: VybeTypography.body3.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0x57FFFFFF), // rgba(255,255,255,0.34)
                  ),
                ),
              ),
              if (trimmed.isNotEmpty)
                Positioned(
                  right: -28.w,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: error != null
                        ? const RenewIcon(
                            path: _MePath.warn,
                            size: 16,
                            color: kMyDanger,
                            strokeWidth: 1.9,
                          )
                        : const RenewIcon(
                            path: _MePath.check,
                            size: 16,
                            color: VybeColors.mainLime500,
                            strokeWidth: 2.6,
                          ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 0),
          child: Text(
            error ??
                '한글·영문·숫자 $kNicknameMin~$kNicknameMax자. '
                    '클럽 리뷰와 문의에 이 이름이 보여요.',
            style: RenewGlass.caption(
              lineHeight: 16,
              color: error != null ? kMyDanger : RenewGlass.t4,
            ),
          ),
        ),
      ],
    );
  }

  /// `maxLength` 를 쓰면 Flutter 가 기본 카운터를 붙인다 —
  /// 글자수는 라벨 줄에 이미 있으므로 뺀다.
  static Widget? _noCounter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) => null;
}

// ============================================================
// 운영 안내 (MEWarnCard)
// ============================================================

/// 붉은 톤 경고 카드 — 제목 + 불릿 목록.
class ProfileWarnCard extends StatelessWidget {
  final String title;
  final List<String> lines;

  const ProfileWarnCard({
    super.key,
    required this.title,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0x12FF5C5F), // rgba(255,92,95,0.07)
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0x38FF5C5F)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h, right: 10.w),
            child: const RenewIcon(
              path: _MePath.warn,
              size: 15,
              color: kMyDanger,
              strokeWidth: 1.8,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: VybeTypography.button2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xF2FFA3A4), // rgba(255,163,164,0.95)
                  ),
                ),
                SizedBox(height: 6.h),
                for (final line in lines)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: line == lines.last ? 0 : 5.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.h, right: 7.w),
                          child: Container(
                            width: 3.r,
                            height: 3.r,
                            decoration: const BoxDecoration(
                              color: Color(0x4DFFFFFF),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            line,
                            style: RenewGlass.caption(
                              lineHeight: 18,
                              color: RenewGlass.t3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 가입 정보 카드 (MEIdCard) — 읽기 전용 · 기본 마스킹
// ============================================================

/// 이름 마스킹 — `김바이브` → `김**브`, 두 글자 이하는 `김*`.
String maskName(String v) {
  final chars = v.characters.toList();
  if (chars.isEmpty) return '-';
  if (chars.length <= 2) return '${chars.first}*';
  return '${chars.first}${'*' * (chars.length - 2)}${chars.last}';
}

/// 생년월일 마스킹 — `1997.03.14` → `1997.**.**`.
String maskBirth(String v) =>
    v.characters.length < 4 ? v : '${v.substring(0, 4)}.**.**';

/// 전화번호 마스킹 — `010-1234-5678` → `010-****-5678`.
/// 세 토막이 아니면(형식이 다르면) 손대지 않는다.
String maskPhone(String v) {
  final parts = v.split('-');
  if (parts.length != 3) return v;
  return '${parts[0]}-${'*' * parts[1].length}-${parts[2]}';
}

/// 본인인증으로 받아 **앱에서 바꿀 수 없는** 값들.
///
/// 기본은 마스킹이고 버튼으로만 전체를 본다 — 카페·클럽에서 화면을 열어도
/// 실명·번호가 통째로 드러나지 않게. 값 자체는 본인만 읽을 수 있다
/// (`users/{uid}` Rules).
class IdentityInfoCard extends StatefulWidget {
  final String name;

  /// `YYYY.MM.DD`.
  final String birthDate;
  final String phone;

  /// 성별 라벨 (`남성`·`여성`) — 모르면 빈 값.
  final String gender;

  /// 가입 방식 이름 (`카카오`) — 모르면 빈 값.
  final String providerName;

  /// `2025.11.02`.
  final String joinedAt;

  const IdentityInfoCard({
    super.key,
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.gender,
    required this.providerName,
    required this.joinedAt,
  });

  @override
  State<IdentityInfoCard> createState() => _IdentityInfoCardState();
}

class _IdentityInfoCardState extends State<IdentityInfoCard> {
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.r);
    final cells = <(String, String)>[
      ('성별', widget.gender.isEmpty ? '-' : widget.gender),
      ('생년월일', _value(widget.birthDate, maskBirth)),
      ('전화번호', _value(widget.phone, maskPhone)),
      ('로그인', widget.providerName.isEmpty ? '-' : widget.providerName),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          // 145deg — 오른아래로 흐른다.
          begin: Alignment(-0.57, -0.82),
          end: Alignment(0.57, 0.82),
          colors: [Color(0xFF241D3C), Color(0xFF1A1626), Color(0xFF141119)],
          stops: [0, 0.6, 1],
        ),
      ),
      // 테두리는 자식 위 — 클립된 카드에서 decoration 에 두면 호에서 선이 사라진다.
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: RenewGlass.tileBorder),
      ),
      child: Stack(
        children: [
          // 우상단 보라 · 좌하단 라임 글로우
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.76, -0.92),
                  radius: 0.85,
                  colors: [Color(0x737731FE), Color(0x007731FE)],
                  stops: [0, 0.62],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.88, 0.92),
                  radius: 0.62,
                  colors: [Color(0x24B5FF60), Color(0x00B5FF60)],
                  stops: [0, 0.66],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                SizedBox(height: 14.h),
                Text(
                  _value(widget.name, maskName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    height: 28 / 24,
                    letterSpacing: 24 * -0.025,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                // 2×2 — Row 안에 Expanded 라 긴 값도 칸을 넘지 않는다.
                for (var row = 0; row < 2; row++)
                  Padding(
                    padding: EdgeInsets.only(bottom: row == 0 ? 14.h : 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _cell(cells[row * 2])),
                        SizedBox(width: 12.w),
                        Expanded(child: _cell(cells[row * 2 + 1])),
                      ],
                    ),
                  ),
                SizedBox(height: 16.h),
                _toggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _value(String raw, String Function(String) mask) {
    if (raw.isEmpty) return '-';
    return _shown ? raw : mask(raw);
  }

  Widget _header() {
    return Row(
      children: [
        const RenewIcon(
          path: _MePath.shield,
          size: 13,
          color: VybeColors.mainLime500,
          strokeWidth: 2.2,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            '본인인증 완료',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              height: 14 / 11,
              letterSpacing: 11 * 0.06,
              color: VybeColors.mainLime500,
            ),
          ),
        ),
        if (widget.joinedAt.isNotEmpty)
          Text(
            '${widget.joinedAt} 가입',
            style: RenewGlass.caption(
              size: 11,
              lineHeight: 14,
              color: const Color(0x80FFFFFF),
            ),
          ),
      ],
    );
  }

  Widget _cell((String, String) cell) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cell.$1,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            fontSize: 10.sp,
            height: 13 / 10,
            letterSpacing: 10 * 0.08,
            color: const Color(0x73FFFFFF),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          cell.$2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
            height: 19 / 15,
            letterSpacing: 15 * -0.025,
            color: Colors.white,
            fontFeatures: const [ui.FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _toggle() {
    return GestureDetector(
      onTap: () => setState(() => _shown = !_shown),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 42.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0x14FFFFFF),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0x24FFFFFF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RenewIcon(
              path: _shown ? _MePath.eyeOff : _MePath.eye,
              size: 15,
              color: RenewGlass.lavender,
              strokeWidth: 1.9,
            ),
            SizedBox(width: 6.w),
            Text(
              _shown ? '정보 가리기' : '전체 정보 보기',
              style: VybeTypography.button2.copyWith(
                fontWeight: FontWeight.w600,
                color: RenewGlass.lavender,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `가입 정보  [🔒 수정 불가]` 섹션 머리.
class LockedSectionHead extends StatelessWidget {
  final String title;

  const LockedSectionHead({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 10.h),
      child: Row(
        children: [
          Text(
            title,
            style: VybeTypography.button2.copyWith(
              fontWeight: FontWeight.w700,
              color: RenewGlass.t1,
            ),
          ),
          SizedBox(width: 7.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: RenewGlass.tileFill,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: RenewGlass.tileBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RenewIcon(
                  path: _MePath.lock,
                  size: 10,
                  color: RenewGlass.t4,
                  strokeWidth: 2,
                ),
                SizedBox(width: 4.w),
                Text(
                  '수정 불가',
                  style: RenewGlass.caption(size: 11, lineHeight: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 사진 변경 바텀시트 (MEPhotoSheet)
// ============================================================

/// 시트에서 고른 것.
enum ProfilePhotoAction {
  /// 카메라로 촬영.
  camera,

  /// 앨범에서 고르기.
  album,

  /// 기본 이미지로 되돌리기 (사진 삭제).
  reset,
}

/// 사진 변경 시트. 취소하거나 바깥을 누르면 null.
///
/// [canReset] 이 false면 '기본 이미지로 변경'을 뺀다 — 이미 기본 이미지인
/// 계정에 되돌릴 것이 없는 항목을 보여주면 눌러도 아무 일이 없다.
Future<ProfilePhotoAction?> showProfilePhotoSheet(
  BuildContext context, {
  required bool canReset,
}) {
  return showModalBottomSheet<ProfilePhotoAction>(
    context: context,
    backgroundColor: Colors.transparent,
    // 디자인 rgba(6,5,10,0.6)
    barrierColor: const Color(0x9906050A),
    isScrollControlled: true,
    builder: (_) => _PhotoSheet(canReset: canReset),
  );
}

class _PhotoSheet extends StatelessWidget {
  final bool canReset;

  const _PhotoSheet({required this.canReset});

  @override
  Widget build(BuildContext context) {
    final items = <(ProfilePhotoAction, String, String, bool)>[
      (ProfilePhotoAction.camera, '사진 촬영', RenewIcons.camera, false),
      (ProfilePhotoAction.album, '앨범에서 선택', _MePath.album, false),
      if (canReset)
        (ProfilePhotoAction.reset, '기본 이미지로 변경', _MePath.refresh, true),
    ];
    final safe = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, safe > 26.h ? safe : 26.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _panel(
            radius: 22,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: RenewGlass.hair),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '프로필 사진',
                        style: VybeTypography.button1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: RenewGlass.t1,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'JPG · PNG · 5MB 이하',
                        style: RenewGlass.caption(lineHeight: 16),
                      ),
                    ],
                  ),
                ),
                for (final item in items)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(item.$1),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        border: item == items.last
                            ? null
                            : const Border(
                                bottom: BorderSide(color: RenewGlass.hair),
                              ),
                      ),
                      child: Row(
                        children: [
                          RenewIcon(
                            path: item.$3,
                            size: 17,
                            color: item.$4 ? kMyDanger : RenewGlass.t2,
                            strokeWidth: 1.9,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            item.$2,
                            style: VybeTypography.body3.copyWith(
                              fontWeight: FontWeight.w500,
                              color: item.$4 ? kMyDanger : RenewGlass.t1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: _panel(
              radius: 18,
              fill: const Color(0x17FFFFFF), // rgba(255,255,255,0.09)
              child: SizedBox(
                height: 56.h,
                width: double.infinity,
                child: Center(
                  child: Text(
                    '취소',
                    style: VybeTypography.button1.copyWith(
                      fontWeight: FontWeight.w700,
                      color: RenewGlass.t1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 블러 + 테두리를 가진 시트 판. 테두리는 자식 위에 올린다.
  Widget _panel({
    required double radius,
    required Widget child,
    Color fill = const Color(0xF01A1A1E), // rgba(26,26,30,0.94)
  }) {
    final r = BorderRadius.circular(radius.r);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: r),
      foregroundDecoration: BoxDecoration(
        borderRadius: r,
        border: Border.all(color: RenewGlass.tileBorder),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: ColoredBox(color: fill, child: child),
      ),
    );
  }
}

/// 화면 맨 아래 '고객센터 문의 >' 링크 — 가입 정보를 바꾸려면 여기로.
class ProfileSupportLink extends StatelessWidget {
  const ProfileSupportLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SupportScreen()),
        ),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '고객센터 문의',
                style: RenewGlass.body(color: RenewGlass.lavender),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 15.r,
                color: RenewGlass.lavender,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
