import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybe/presentation/clubs/renew/widgets/renew_skeleton.dart';
import 'package:vybe/presentation/common/widgets/vybe_skeleton.dart';

/// 클럽 상세 로딩 스켈레톤이 오버플로 없이 그려지는지.
/// 가로를 꽉 채우는 막대가 많아 Row/Column 제약을 잘못 주면 바로 터진다.
Widget _host(Widget child) => ScreenUtilInit(
  designSize: const Size(393, 852),
  builder: (_, __) => MaterialApp(home: Scaffold(body: child)),
);

void main() {
  testWidgets('탭별 스켈레톤이 오버플로 없이 그려진다', (tester) async {
    const pad = EdgeInsets.all(24);
    for (final skeleton in <Widget>[
      const RenewTitleSkeleton(),
      const RenewHomeSkeleton(padding: pad),
      const RenewPhotoSkeleton(padding: pad),
      const RenewMenuSkeleton(padding: pad),
      const RenewReviewSkeleton(padding: pad),
      const RenewInfoSkeleton(padding: pad),
    ]) {
      await tester.pumpWidget(_host(skeleton));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(VybeSkel), findsWidgets);
    }
  });

  // 섹션 조각은 탭 전체 스켈레톤 말고도 홈·매장정보 탭에서 **단독으로** 쓰인다
  // (섹션마다 조회가 따로 도니까). 단독으로 그려도 안 터져야 한다.
  testWidgets('섹션 스켈레톤이 단독으로도 그려진다', (tester) async {
    for (final section in <Widget>[
      const RenewSkelLineupSection(),
      const RenewSkelTableSection(),
      const RenewSkelMenuSection(),
      const RenewSkelPhotoSection(),
      const RenewSkelNearbySection(),
      const RenewSkelFacilitiesSection(),
      const RenewSkelSubwayLines(),
    ]) {
      await tester.pumpWidget(
        _host(ListView(padding: const EdgeInsets.all(24), children: [section])),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(VybeSkel), findsWidgets);
    }
  });
}
