import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/core/utils/date_format.dart';
import 'package:vybe/core/utils/nickname.dart';
import 'package:vybe/data/models/user_model.dart';
import 'package:vybe/domain/exceptions/profile_exceptions.dart';
import 'package:vybe/presentation/common/renew/renew_button.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_fade_in_up.dart';
import 'package:vybe/presentation/common/widgets/vybe_photo_picker.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_toast.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';
import 'package:vybe/presentation/my_page/widgets/profile_edit_parts.dart';
import 'package:vybe/presentation/profile/viewmodels/user_viewmodel.dart';

// ============================================================
// 내 정보 수정 — 리뉴얼 (디자인 `my_edit_v2.html`)
//
// 바꿀 수 있는 것은 **닉네임 · 프로필 사진** 둘이고, 가입 정보(이름·성별·
// 생년월일·전화번호)는 본인인증으로 받은 값이라 읽기 전용이다.
//
// 저장 순서가 설계의 알맹이 — **파일 먼저, 문서는 마지막**.
// 실제 순서는 `UserViewModel.saveProfile` 한 곳에 있다(화면은 결과만 본다).
//
// ⚠ 닉네임·사진은 Firestore 에 직접 쓸 수 없다 — 닉네임 유일성 예약
// (`nicknames/{key}`)과 문서 갱신이 한 트랜잭션에 묶여야 해서 쓰기 주체가
// Cloud Functions(`updateUserProfile`) 하나다. Rules 가 클라 쓰기를 막는다.
//
// 디자인과 다른 점
// - 입력칸이 예전엔 `users.name`(실명)을 읽고 쓰고 있었다 — 라벨만 '닉네임'
//   이었다. 이제 `users.nickname` 을 본다.
// - 사진 시트의 용량 안내는 시안 10MB 대신 **5MB** — `storage.rules` 의
//   `users/{uid}/**` 상한이 5MB 다. 시안대로 쓰면 6MB 사진이 403 으로
//   조용히 실패한다.
// - '기본 이미지로 변경'은 사진이 있을 때만 보여준다(되돌릴 게 없으면 뺀다).
// - 디자인의 '닉네임 30일 변경 제한' 문구는 뺐다 — 서버에 그 제한이 없다
//   (없는 규칙을 안내하면 거짓 정보다). 필요해지면 함수에 붙인다.
// ============================================================

class ProfileEditScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const ProfileEditScreen({super.key, required this.user});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController _nickname;
  final ImagePicker _picker = ImagePicker();

  /// 방금 고른 사진(아직 안 올렸다). null이면 사진을 안 골랐다.
  File? _picked;

  /// '기본 이미지로 변경'을 골랐다 — 저장하면 URL 이 빈 값이 된다.
  bool _reset = false;

  /// 서버만 아는 거부 이유(중복 닉네임). 입력을 고치면 지운다.
  String? _nicknameTaken;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // 닉네임이 아직 없는 계정(배정 실패·예약 도입 전)은 빈 칸으로 시작한다 —
    // 중립 라벨(VYBER)을 채워 두면 사용자가 그걸 자기 닉네임으로 저장한다.
    _nickname = TextEditingController(text: widget.user.nickname);
    _nickname.addListener(_onNicknameChanged);
  }

  @override
  void dispose() {
    _nickname
      ..removeListener(_onNicknameChanged)
      ..dispose();
    super.dispose();
  }

  void _onNicknameChanged() {
    // 글자수·상태 아이콘·저장 버튼이 전부 이 값을 본다.
    setState(() => _nicknameTaken = null);
  }

  /// 지금 화면에 보여줄 사진 URL (기본 이미지로 되돌리는 중이면 빈 값).
  String get _shownImageUrl => _reset ? '' : widget.user.profileImageUrl;

  bool get _dirty =>
      _picked != null ||
      _reset ||
      _nickname.text.trim() != widget.user.nickname;

  bool get _canSave =>
      !_saving && _dirty && isValidNickname(_nickname.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RenewGlass.ink,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(child: VybeAurora()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VybePushHeader(title: '내 정보 수정'),
              Expanded(child: _body()),
              MyBottomBar(
                child: RenewButton(
                  label: _saving ? '저장 중…' : '저장하기',
                  onTap: _canSave ? _save : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    final user = widget.user;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: kMyPagePad.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VybeFadeInUp(
            index: 0,
            child: ProfilePhotoPicker(
              imageUrl: _shownImageUrl,
              preview: _picked == null ? null : FileImage(_picked!),
              onTap: _saving ? () {} : _openPhotoSheet,
            ),
          ),
          SizedBox(height: kMySectionGap.h),

          VybeFadeInUp(
            index: 1,
            child: NicknameField(
              controller: _nickname,
              serverError: _nicknameTaken,
            ),
          ),
          SizedBox(height: kMySectionGap.h),

          const VybeFadeInUp(
            index: 2,
            child: ProfileWarnCard(
              title: '닉네임 · 사진 이용 안내',
              lines: [
                '욕설·비방, 타인 사칭, 광고성 닉네임은 안내 없이 초기화될 수 있어요.',
                '이미 다른 사람이 쓰고 있는 닉네임은 저장되지 않아요.',
                '본인이 아닌 사람의 사진이나 선정적·폭력적인 이미지는 사용할 수 없어요.',
                '신고가 접수된 사진은 검토 후 기본 이미지로 변경돼요.',
              ],
            ),
          ),
          SizedBox(height: kMySectionGap.h),

          VybeFadeInUp(
            index: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LockedSectionHead(title: '가입 정보'),
                IdentityInfoCard(
                  name: user.name,
                  birthDate: _birthLabel(user.birthDate),
                  phone: user.phone,
                  gender: _genderLabel(user.gender),
                  providerName: kProviderNames[user.provider] ?? '',
                  joinedAt: fmtDateDot(user.createdAt),
                ),
                SizedBox(height: 10.h),
                const RenewFooterNote(
                  text: '이름·성별·생년월일·전화번호는 본인인증으로 받은 정보라 앱에서 바꿀 수 없어요. '
                      '변경이 필요하면 고객센터로 문의해 주세요.',
                ),
              ],
            ),
          ),
          SizedBox(height: kMySectionGap.h),

          const VybeFadeInUp(index: 4, child: ProfileSupportLink()),
        ],
      ),
    );
  }

  // ============ 사진 ============

  Future<void> _openPhotoSheet() async {
    final action = await showProfilePhotoSheet(
      context,
      // 되돌릴 대상은 '지금 화면에 보이는 사진' — 방금 고른 것도 포함한다.
      canReset: _picked != null || _shownImageUrl.isNotEmpty,
    );
    if (action == null || !mounted) return;

    if (action == ProfilePhotoAction.reset) {
      setState(() {
        _picked = null;
        _reset = widget.user.profileImageUrl.isNotEmpty;
      });
      return;
    }

    try {
      final file = await pickProfilePhoto(
        _picker,
        fromCamera: action == ProfilePhotoAction.camera,
      );
      if (file == null || !mounted) return;
      setState(() {
        _picked = file;
        _reset = false;
      });
    } catch (_) {
      // 권한 거부·플러그인 오류. 조용히 삼키면 "눌러도 아무 일도 안 남"이 된다.
      if (!mounted) return;
      VybeToast.show(context, message: '사진을 불러올 수 없어요', isError: true);
    }
  }

  // ============ 저장 ============

  Future<void> _save() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null || !_canSave) return;

    setState(() => _saving = true);
    try {
      await ref.read(userViewModelProvider.notifier).saveProfile(
            uid: uid,
            nickname: _nickname.text.trim(),
            imageFile: _picked,
            resetImage: _reset,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      VybeToast.show(context, message: '변경 내용을 저장했어요');
    } on NicknameTakenException {
      // 입력칸 아래에 붙인다 — 토스트로만 알리면 어느 값이 문제인지 안 보인다.
      if (!mounted) return;
      setState(() {
        _saving = false;
        _nicknameTaken = '이미 사용 중인 닉네임이에요';
      });
    } on ProfileRejectedException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      // 사진 거부를 입력칸 아래에 붙이면 엉뚱한 곳을 고치게 된다 —
      // 어느 값이 문제인지는 서버가 `details.field` 로 알려준다.
      if (e.field == ProfileField.nickname) {
        setState(() => _nicknameTaken = e.message);
      } else {
        VybeToast.show(context, message: e.message, isError: true);
      }
    } catch (e, st) {
      // 토스트는 공통 문구뿐이라 원인은 여기 남긴다 — 안 남기면 "저장 실패"만 보인다.
      debugPrint('[ProfileEdit] save failed: $e\n$st');
      if (!mounted) return;
      setState(() => _saving = false);
      VybeToast.show(context, message: '저장에 실패했어요. 다시 시도해 주세요', isError: true);
    }
  }

  // ============ 표기 ============

  /// `YYYYMMDD` → `YYYY.MM.DD`. 형식이 다르면 원본 그대로.
  String _birthLabel(String raw) {
    if (raw.length != 8) return raw;
    return '${raw.substring(0, 4)}.${raw.substring(4, 6)}.${raw.substring(6)}';
  }

  /// `users.gender` 는 영문 키만 저장한다 — 한글 라벨은 화면이 붙인다.
  String _genderLabel(String gender) => switch (gender) {
    'male' => '남성',
    'female' => '여성',
    _ => '',
  };
}
