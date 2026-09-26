import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vybe/core/providers/auth_providers.dart';
import 'package:vybe/presentation/common/renew/renew_button.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_aurora.dart';
import 'package:vybe/presentation/common/widgets/vybe_photo_picker.dart';
import 'package:vybe/presentation/common/widgets/vybe_push_header.dart';
import 'package:vybe/presentation/common/widgets/vybe_toast.dart';
import 'package:vybe/presentation/my_page/widgets/my_page_common.dart';
import 'package:vybe/presentation/support/support_models.dart';
import 'package:vybe/presentation/support/viewmodels/inquiry_viewmodel.dart';
import 'package:vybe/presentation/support/widgets/inquiry_form_parts.dart';
import 'package:vybe/presentation/support/widgets/support_parts.dart';

// ============================================================
// 문의 작성 (디자인 `SupCreateScreen`)
//
// 등록에 성공하면 별도 완료 화면 없이 `pop(true)` — 목록 화면이 토스트를 띄운다
// (리뷰 작성과 같은 규칙). 목록은 스트림이라 새 문의가 곧바로 올라온다.
// ============================================================

class InquiryWriteScreen extends ConsumerStatefulWidget {
  const InquiryWriteScreen({super.key});

  @override
  ConsumerState<InquiryWriteScreen> createState() => _InquiryWriteScreenState();
}

class _InquiryWriteScreenState extends ConsumerState<InquiryWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _picker = ImagePicker();
  final List<VybePhotoPick> _photos = [];

  /// 기본 선택 없음 — 디자인이 유형을 고르게 만든다(가드가 먼저 말해 준다).
  InquiryCategory? _category;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 제출 가능 판정. 길이 기준은 서버 Rules 와 같은 상수를 쓴다 —
  /// 화면이 더 느슨하면 보내기를 눌렀을 때 서버가 403 으로 되돌린다.
  bool get _valid =>
      _category != null &&
      _titleController.text.trim().characters.length >= kInquiryTitleMin &&
      _contentController.text.trim().characters.length >= kInquiryContentMin;

  /// 아직 못 보내는 이유 한 줄. 보낼 수 있으면 null.
  String? get _blockReason {
    if (_category == null) return '문의 유형을 선택해 주세요';
    if (_valid) return null;
    return '제목 $kInquiryTitleMin자 · 내용 $kInquiryContentMin자 이상 '
        '입력하면 보낼 수 있어요';
  }

  Future<void> _pickPhotos() async {
    final remain = kInquiryMaxPhotos - _photos.length;
    if (remain <= 0) return;

    try {
      final picked = await pickPhotosFromGallery(_picker, remain: remain);
      if (picked.isEmpty || !mounted) return;
      setState(() => _photos.addAll(picked.map(VybePhotoPick.local)));
    } catch (e) {
      // 권한 거부·플러그인 미등록을 조용히 삼키면 "눌러도 아무 일도 안 남"이 된다.
      if (!mounted) return;
      VybeToast.show(context, message: '사진을 불러올 수 없어요');
      debugPrint('[InquiryWrite] pickPhotos failed: $e');
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final category = _category;
    if (category == null) return;

    final uid = ref.read(currentUidProvider);
    if (uid == null) {
      VybeToast.show(context, message: '로그인 후 문의할 수 있어요');
      return;
    }

    setState(() => _submitting = true);
    final ok = await ref
        .read(inquiryActionsProvider.notifier)
        .submitInquiry(
          userId: uid,
          category: category.name,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          images: <File>[
            for (final p in _photos)
              if (p.file != null) p.file!,
          ],
        );
    if (!mounted) return;
    if (!ok) {
      setState(() => _submitting = false);
      VybeToast.show(context, message: '문의를 보내지 못했어요. 잠시 후 다시 시도해주세요');
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    const pad = RenewGlass.pagePad;

    return Scaffold(
      backgroundColor: RenewGlass.ink,
      body: Stack(
        children: [
          const Positioned.fill(child: VybeAurora()),
          Column(
            children: [
              const VybePushHeader(title: '문의하기'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(pad.w, 24.h, pad.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const InquiryFieldLabel('문의 유형'),
                      InquiryTypePicker(
                        selected: _category,
                        onSelect: (c) => setState(() => _category = c),
                      ),
                      SizedBox(height: 28.h),
                      InquiryUnderlineField(
                        label: '제목',
                        controller: _titleController,
                        placeholder: '문의 제목을 입력해 주세요',
                        helper: '최소 $kInquiryTitleMin자 이상',
                        errorMessage: '제목을 $kInquiryTitleMin자 이상 입력해 주세요',
                        minLength: kInquiryTitleMin,
                        maxLength: kInquiryTitleMax,
                      ),
                      SizedBox(height: 28.h),
                      InquiryUnderlineField(
                        label: '문의 내용',
                        controller: _contentController,
                        placeholder:
                            '어떤 점이 문제였는지, 언제 어디서 발생했는지 적어 주시면 '
                            '더 빠르게 확인할 수 있어요.',
                        helper:
                            '최소 $kInquiryContentMin자 · 최대 $kInquiryContentMax자',
                        errorMessage: '문의 내용을 $kInquiryContentMin자 이상 입력해 주세요',
                        minLength: kInquiryContentMin,
                        maxLength: kInquiryContentMax,
                        warnAt: kInquiryContentWarn,
                        multiline: true,
                      ),
                      SizedBox(height: 28.h),
                      InquiryPhotoField(
                        photos: _photos,
                        onAdd: _pickPhotos,
                        onRemove: (i) => setState(() => _photos.removeAt(i)),
                      ),
                      SizedBox(height: 28.h),
                      const InquiryWarnBox(
                        title: '제출 전 확인해 주세요',
                        items: [
                          '허위 신고나 반복 장난 신고가 확인되면 서비스 이용이 제한될 수 있어요.',
                          '내용·첨부 사진에 주민등록번호, 카드번호 등 민감한 개인정보는 넣지 말아 주세요.',
                        ],
                      ),
                      SizedBox(height: 28.h),
                      const InquiryNoteBox(
                        text: '문의 내용과 첨부 사진은 답변 처리 목적으로만 사용되며, '
                            '처리 완료 후 1년간 보관 뒤 삭제됩니다.',
                      ),
                    ],
                  ),
                ),
              ),
              _bottomBar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    // 두 입력만 구독해 버튼 활성만 바꾼다 — 화면 전체를 setState 하면
    // 글래스 표면(BackdropFilter)이 매 글자 다시 그려진다.
    return MyBottomBar(
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _titleController,
        builder: (_, __, ___) => ValueListenableBuilder<TextEditingValue>(
          valueListenable: _contentController,
          builder: (_, __, ___) {
            final reason = _blockReason;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (reason != null) ...[
                  InquiryStatusMessage(reason),
                  SizedBox(height: 10.h),
                ],
                RenewButton(
                  label: _submitting ? '보내는 중…' : '제출하기',
                  onTap: _valid && !_submitting ? _submit : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
