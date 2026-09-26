import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/presentation/common/renew/renew_glass.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

// 찜 목록 로딩 스켈레톤.

class _SavedItemSkeleton extends StatelessWidget {
  const _SavedItemSkeleton();

  @override
  Widget build(BuildContext context) {
    // 실제 리스트 카드(SavedListCard)와 같은 껍데기 — 데이터가 오는 순간 안 튄다.
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: RenewGlassCard(
        sheen: true,
        padding: 12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VybeSkel(width: 92.w, height: 92.w, radius: 14, logo: true),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VybeSkel(width: 130.w, height: 16.h),
                  SizedBox(height: 10.h),
                  VybeSkel(width: 170.w, height: 12.h),
                  SizedBox(height: 10.h),
                  VybeSkel(width: 132.w, height: 21.h, radius: 99),
                  SizedBox(height: 8.h),
                  VybeSkel(width: 64.w, height: 11.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedSkeleton extends StatelessWidget {
  const SavedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 (찜 개수 + 영업중)
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VybeSkel(width: 176.w, height: 32.h, radius: 8),
              VybeSkel(width: 96.w, height: 14.h, radius: 99),
            ],
          ),
        ),
        // 툴바 (정렬 + 뷰 전환) — 실제 툴바와 같이 배경 없음(오로라 그대로).
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VybeSkel(width: 116.w, height: 34.h, radius: 99),
              VybeSkel(width: 74.w, height: 34.h, radius: 99),
            ],
          ),
        ),
        // 리스트 카드 4개
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Column(
            children: List.generate(4, (_) => const _SavedItemSkeleton()),
          ),
        ),
      ],
    );
  }
}
