import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/design_system/colors.dart';
import 'package:vybe/design_system/v1_tokens.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';

/// 흰 종이판 QR. 디자인 `.qrp`.
///
/// 공유용(안내 문구)과 입장용(카운트다운 + 새로 받기)이 같은 판을 쓴다.
///
/// ⚠ 지금은 **플레이스홀더 패턴**을 그린다 — 실제 QR 인코딩은 백엔드 단계에서
/// `issueEntryQr` 응답(payload)을 받아 그린다. UI 단계에선 자리와 크기만 맞추면 된다.
/// `// TODO[외부API]` 가 아니라 서버 함수라 스텁 주석은 두지 않는다.
class VybeQrPanel extends StatelessWidget {
  const VybeQrPanel({
    super.key,
    required this.payload,
    this.size,
    this.caption,
    this.remainSeconds,
    this.onRefresh,
    this.expired = false,
  });

  /// QR 에 실릴 문자열. 패턴 시드로도 쓴다.
  final String payload;
  final double? size;

  /// 판 아래 안내 한 줄.
  final String? caption;

  /// 남은 시간(초). 주면 `mm:ss` 를 그린다. 60 미만이면 경고색.
  final int? remainSeconds;

  /// 새로 받기(↻).
  final VoidCallback? onRefresh;

  /// 만료 — QR 을 덮고 '만료됨' 을 띄운다.
  final bool expired;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 196.r;
    final warn = remainSeconds != null && remainSeconds! < 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: s,
          height: s,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _QrPlaceholderPainter(payload)),
              if (expired)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xF2FFFFFF),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      '만료됨',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: VybeColors.gray800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (remainSeconds != null || caption != null || onRefresh != null) ...[
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (remainSeconds != null)
                Text(
                  vybeFormatMmSs(remainSeconds!),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: warn ? VybeColors.accentRed500 : Colors.white,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                )
              else if (caption != null)
                Flexible(
                  child: Text(
                    caption!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, color: RenewGlass.t3),
                  ),
                ),
              if (onRefresh != null) ...[
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: onRefresh,
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 20.r,
                    color: RenewGlass.t3,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// `mm:ss`. 음수는 `00:00`.
String vybeFormatMmSs(int seconds) {
  final s = seconds < 0 ? 0 : seconds;
  final m = (s ~/ 60).toString().padLeft(2, '0');
  final r = (s % 60).toString().padLeft(2, '0');
  return '$m:$r';
}

class _QrPlaceholderPainter extends CustomPainter {
  _QrPlaceholderPainter(this.seed);

  final String seed;

  @override
  void paint(Canvas canvas, Size size) {
    const n = 21; // QR v1 과 같은 모듈 수
    final cell = size.width / n;
    final rnd = math.Random(seed.hashCode);
    final p = Paint()..color = const Color(0xFF0E0D12);

    bool isFinder(int x, int y) =>
        (x < 7 && y < 7) || (x >= n - 7 && y < 7) || (x < 7 && y >= n - 7);

    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        if (isFinder(x, y)) continue;
        if (rnd.nextDouble() < 0.46) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), p);
        }
      }
    }

    // 파인더 패턴 3개
    void finder(double ox, double oy) {
      canvas.drawRect(Rect.fromLTWH(ox, oy, cell * 7, cell * 7), p);
      canvas.drawRect(
        Rect.fromLTWH(ox + cell, oy + cell, cell * 5, cell * 5),
        Paint()..color = Colors.white,
      );
      canvas.drawRect(
        Rect.fromLTWH(ox + cell * 2, oy + cell * 2, cell * 3, cell * 3),
        p,
      );
    }

    finder(0, 0);
    finder(size.width - cell * 7, 0);
    finder(0, size.height - cell * 7);
  }

  @override
  bool shouldRepaint(covariant _QrPlaceholderPainter old) => old.seed != seed;
}

/// QR 잠금 캡슐 — 블러 처리한 QR 위에 자물쇠 안내를 얹는다.
///
/// 아직 QR 을 열어 줄 수 없는 상태(호출 전 · 전환 전 · 비밀번호 미입력) 전부에 쓴다.
class VybeQrLockCapsule extends StatelessWidget {
  const VybeQrLockCapsule({
    super.key,
    required this.message,
    this.payload = 'locked',
    this.size,
  });

  /// 자물쇠 옆 한 줄(예: '입장 순서가 되면 열려요').
  final String message;
  final String payload;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final s = size ?? 196.r;
    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: VybeQrPanel(payload: payload, size: s),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: const Color(0xD90E0D12),
                borderRadius: BorderRadius.circular(V1Dim.badgeRadius.r),
                border: Border.all(color: RenewGlass.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded, size: 14.r, color: RenewGlass.t3),
                  SizedBox(width: 6.w),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: RenewGlass.t2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
