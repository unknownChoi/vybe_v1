import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vybe/presentation/common/widgets/vybe_toast.dart';

/// 바깥 링크(카카오 오픈채팅 · 인스타그램 등)를 기기 기본 앱으로 연다.
///
/// 링크가 비었거나 열 수 없으면 토스트로 안내만 하고 조용히 끝낸다
/// ([launchPhoneCall] 과 같은 방식).
Future<void> launchExternalUrl(BuildContext context, String url) async {
  void notify(String message) {
    if (!context.mounted) return;
    VybeToast.show(context, message: message, isError: true);
  }

  final trimmed = url.trim();
  if (trimmed.isEmpty) {
    notify('등록된 링크가 없습니다');
    return;
  }
  final uri = Uri.tryParse(trimmed);
  if (uri == null) {
    notify('링크를 열 수 없습니다');
    return;
  }

  // canLaunchUrl 은 플랫폼 조회 권한에 걸려 false 를 줄 수 있어 먼저 시도한다.
  final launched = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  ).catchError((_) => false);
  if (!launched) notify('링크를 열 수 없습니다');
}
