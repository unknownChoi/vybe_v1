import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

// ============================================================
// 사진 첨부 공용 조각 — 리뷰 작성 · 고객센터 문의 작성이 같이 쓴다.
//
// 원래 리뷰 작성 화면 전용(`clubs/widgets/review_write_cards.dart`)이었는데
// 두 번째 화면이 같은 것을 쓰게 되어 여기로 승격했다. 화면마다 다른 것은
// 최대 장수와 카드 껍데기뿐이라, 껍데기(제목·글래스 카드)는 화면에 남기고
// **타일 줄 + 고르기 로직**만 공용으로 둔다.
// ============================================================

/// 첨부 사진 1장.
///
/// 수정 모드에선 이미 올라간 사진(URL)과 이번에 고른 사진(File)이 한 줄에 섞여
/// 있고 순서·삭제가 같이 다뤄져야 한다 → 두 목록을 따로 두지 않고 한 타입으로 묶는다.
/// 둘 중 하나만 non-null.
class VybePhotoPick {
  final String? url;
  final File? file;

  const VybePhotoPick.remote(String this.url) : file = null;
  const VybePhotoPick.local(File this.file) : url = null;
}

/// 갤러리에서 최대 [remain]장 고르기.
///
/// ⚠ `pickMultiImage`의 `limit`은 2 미만이면 `ArgumentError`를 던진다 —
/// 한 장 남았을 땐 단일 선택으로 갈라야 한다. 이 분기를 화면마다 다시 쓰면
/// 마지막 한 장에서만 크래시하는 버그가 화면 수만큼 생긴다.
///
/// [maxWidth]는 업로드 전 축소 기준. 기본값(1440)은 본문에 폭 맞춰 들어가는
/// 첨부 사진용이다 — 작게 쓰이는 자리(프로필 아바타)는 더 줄여 넘길 것.
///
/// 권한 거부·플러그인 미등록은 예외로 올라온다 — 호출측이 토스트로 알릴 것.
/// 조용히 삼키면 "버튼을 눌러도 아무 일도 안 남"으로 보인다.
Future<List<File>> pickPhotosFromGallery(
  ImagePicker picker, {
  required int remain,
  double maxWidth = 1440,
}) async {
  if (remain <= 0) return const [];

  final List<XFile> picked;
  if (remain == 1) {
    final one = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: maxWidth,
    );
    picked = one == null ? const [] : [one];
  } else {
    picked = await picker.pickMultiImage(
      limit: remain,
      imageQuality: 85,
      maxWidth: maxWidth,
    );
  }
  return picked.take(remain).map((x) => File(x.path)).toList();
}

/// 프로필 사진으로 쓸 이미지 한 장 — 카메라 또는 앨범. 취소하면 null.
///
/// ⚠ [kProfilePhotoMaxWidth] 로 **꼭 줄여서** 올린다. `storage.rules` 의
/// `users/{uid}/**` 상한이 5MB 라, 원본을 그대로 올리면 요즘 기기 사진이
/// 걸려 **조용히 403** 이 난다(업로드만 실패하고 화면은 멀쩡해 보인다).
///
/// 크롭 화면은 두지 않는다 — 아바타가 `ClipOval` + `BoxFit.cover` 라 이미
/// 가운데가 원형으로 잘려 보이고, 크롭 UI 는 패키지가 하나 더 필요하다.
Future<File?> pickProfilePhoto(
  ImagePicker picker, {
  required bool fromCamera,
}) async {
  final picked = await picker.pickImage(
    source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    imageQuality: 85,
    maxWidth: kProfilePhotoMaxWidth,
    maxHeight: kProfilePhotoMaxWidth,
  );
  return picked == null ? null : File(picked.path);
}

/// 프로필 사진 업로드 전 축소 기준.
/// 가장 크게 쓰이는 자리가 104px 원형이라 3배수(312)면 충분하지만, 앞으로
/// 더 큰 자리가 생겨도 견디게 720 으로 둔다.
const double kProfilePhotoMaxWidth = 720;

/// 첨부 사진 타일 가로 목록 (+ 꽉 차기 전까진 맨 앞에 추가 버튼).
class VybePhotoPickerRow extends StatelessWidget {
  final List<VybePhotoPick> photos;
  final int maxCount;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  /// 추가 버튼을 고른 사진 **앞**에 둘지. 고객센터 디자인은 뒤에 둔다.
  final bool addFirst;

  /// 추가 버튼 라벨을 '추가' 대신 `n/최대`로 (고객센터 디자인).
  final bool addShowsCount;

  const VybePhotoPickerRow({
    super.key,
    required this.photos,
    required this.maxCount,
    required this.onAdd,
    required this.onRemove,
    this.addFirst = true,
    this.addShowsCount = false,
  });

  /// 타일 한 변 (리뷰 작성·고객센터 공통).
  static const double tileSize = 72;

  @override
  Widget build(BuildContext context) {
    final add = photos.length < maxCount
        ? _AddPhotoButton(
            onTap: onAdd,
            size: tileSize,
            label: addShowsCount ? '${photos.length}/$maxCount' : '추가',
          )
        : null;

    return SizedBox(
      height: tileSize.r,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (add != null && addFirst) ...[add, SizedBox(width: 10.w)],
          for (var i = 0; i < photos.length; i++) ...[
            _PhotoTile(
              photo: photos[i],
              size: tileSize,
              onRemove: () => onRemove(i),
            ),
            if (i != photos.length - 1 || (add != null && !addFirst))
              SizedBox(width: 10.w),
          ],
          if (add != null && !addFirst) add,
        ],
      ),
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final String label;

  const _AddPhotoButton({
    required this.onTap,
    required this.size,
    this.label = '추가',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomPaint(
        painter: VybeDashedBorderPainter(radius: 14.r),
        child: Container(
          width: size.r,
          height: size.r,
          decoration: BoxDecoration(
            color: const Color(0x0DFFFFFF),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_outlined,
                size: 19.r,
                color: const Color(0x99FFFFFF),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12.sp,
                  height: 12 / 12,
                  color: const Color(0x80FFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final VybePhotoPick photo;
  final double size;
  final VoidCallback onRemove;

  const _PhotoTile({
    required this.photo,
    required this.size,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.r,
      height: size.r,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: photo.url != null
                  ? Image(
                      image: vybeNetworkImage(
                        photo.url!,
                        cacheWidth:
                            (size.r * MediaQuery.devicePixelRatioOf(context))
                                .round(),
                      ),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0x14FFFFFF)),
                    )
                  : Image.file(photo.file!, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 5.r,
            right: 5.r,
            child: GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 19.r,
                height: 19.r,
                decoration: const BoxDecoration(
                  color: Color(0x9E000000),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 12.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 사진 추가 버튼의 점선 테두리 (Flutter 기본 Border에 dashed가 없어 직접 그림).
class VybeDashedBorderPainter extends CustomPainter {
  final double radius;

  const VybeDashedBorderPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0x38FFFFFF) // rgba(255,255,255,0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    const dash = 4.0;
    const space = 3.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + space;
      }
    }
  }

  @override
  bool shouldRepaint(VybeDashedBorderPainter oldDelegate) =>
      oldDelegate.radius != radius;
}
