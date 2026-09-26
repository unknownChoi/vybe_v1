import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

/// 유저 문서를 읽는 동안 [MyPageProfile] 자리를 채우는 스켈레톤.
///
/// 아바타 원 → 이름 · 가입 방식 · 수정 pill 순서를 그대로 따라 데이터가 와도
/// 아래 통계 카드가 위아래로 안 튄다.
class MyPageProfileSkeleton extends StatelessWidget {
  const MyPageProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VybeSkel(width: 76.r, height: 76.r, radius: 999),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VybeSkel(width: 140.w, height: 21.h),
            SizedBox(height: 4.h),
            VybeSkel(width: 90.w, height: 13.h),
            SizedBox(height: 12.h),
            VybeSkel(width: 92.w, height: 30.h, radius: 999),
          ],
        ),
      ],
    );
  }
}
