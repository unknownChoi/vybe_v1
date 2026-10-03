import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vybe/data/models/v1/club_ops_model.dart';
import 'package:vybe/data/repositories/v1_providers.dart';

/// 클럽 1곳 실시간 운영 상태 — `clubs/{clubId}/ops/live`.
///
/// 설계 6-0 PLACE-019 「핀 카드에 ops/live.waiting.waitingCount 표시
/// (클럽당 1 read 추가 · **핀 탭 시만**)」 · 6-X 'clubs/{clubId} 1 read +
/// ops/live 1 read (대기 팀 수)'.
///
/// ⚠ **autoDispose** — 핀을 닫으면 구독도 끊어야 한다. 지도에 핀이 수십 개인데
/// 탭할 때마다 구독이 쌓이면 화면 하나가 문서 수십 개를 들고 있게 된다.
///
/// 값이 null 이면 **모른다**는 뜻이다(웨이팅을 안 쓰는 클럽 · 조회 전).
/// 화면은 그 자리에 대기 팀 수를 그리지 않는다 — 0팀이라고 말하면 안 된다.
final clubOpsLiveProvider = StreamProvider.autoDispose
    .family<ClubOpsLive?, String>(
      (ref, clubId) =>
          ref.watch(clubOpsDataSourceProvider).watchOpsLive(clubId),
    );
