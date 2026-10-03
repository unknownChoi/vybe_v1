/* VYBE v1 — 화면 목록 · 흐름 원본 (단일 소스)
   스토리보드(storyboard_v1.js)와 프로토타입(prototype_v1.js)이 이 파일 하나를 함께 읽는다.
   화면을 더하거나 빼거나 순서를 바꿀 때는 여기만 고치면 두 화면이 같이 바뀐다. */
(function () {
const NOOP = '()=>{}';
/* ---------- 데이터 ----------
   A~G = 베타 화면(파일·번호 그대로). nav:1 = 하단 내비게이션 찜→패스월렛 적용(v1 수정됨).
   mod:1 = 직접 수정한 화면. todo = "v1 수정 필요" 메모. nf = 신규 기능 행(NF_SPECS). tbd = 미정 화면. */
const SECTIONS = [
  { key: 'A', code: 'AUTH', title: '온보딩 · 인증', sub: '스플래시 → 로그인 → 본인 인증 → 인증번호', screens: [
    { id: 'splash', f: '[v1]AUTH-001.html', n: '스플래시' },
    { id: 'login', f: '[v1]AUTH-002.html', n: '로그인', widgets: [{ n: '본인 인증 안내 시트', c: 'VerifySheet', p: `({open:true,onClose:${NOOP}})` }] },
    { id: 'verify', f: '[v1]AUTH-003.html', n: '본인 인증', widgets: [
      { n: '통신사 선택 시트', c: 'SVCarrierSheet', p: `({selected:'SKT',onSelect:${NOOP},onClose:${NOOP}})` },
      { n: '약관 동의 시트', c: 'SVTermsSheet', p: `({onClose:${NOOP},onConfirm:${NOOP}})` }] },
    { id: 'code', f: '[v1]AUTH-004.html', n: '인증번호 입력' },
  ], flows: [['splash', 'login', '자동 전환'], ['login', 'verify', '회원가입'], ['verify', 'code', '인증 요청']] },
  { key: 'B', code: 'HOME', title: '홈 · 탐색', sub: '홈 상단 검색 · 알림, 공지사항 · 라인업 전체보기', screens: [
    { id: 'home', f: '[v1]HOME-005.html', n: '홈', tab: 'home', nav: 1, ready: 'closeAd', widgets: [{ n: '팝업 광고', c: 'HomeAdPopup', p: '({ready:true})', ad: true }] },
    { id: 'search', f: '[v1]HOME-006.html', n: '검색 결과', tab: 'search', nav: 1 },
    { id: 'noti', f: '[v1]HOME-007.html', n: '알림', tab: 'home', nav: 1 },
    { id: 'notice', f: '[v1]HOME-008.html', n: '공지사항' },
    { id: 'lineup', f: '[v1]HOME-009.html', n: '오늘의 라인업' },
  ], flows: [['home', 'search', '검색 버튼'], ['home', 'noti', '알림 버튼'], ['home', 'notice', '공지 전체보기'], ['home', 'lineup', '라인업 카드']] },
  { key: 'C', code: 'CAT', title: '카테고리', sub: '홈 퀵메뉴 · 배너에서 진입', screens: [
    { id: 'rec', f: '[v1]CAT-010.html', n: 'VYBE 추천', tab: 'home', nav: 1 },
    { id: 'hot', f: '[v1]CAT-011.html', n: '핫플레이스', tab: 'home', nav: 1 },
    { id: 'free', f: '[v1]CAT-012.html', n: '입장비 무료', tab: 'home', nav: 1 },
    { id: 'drink', f: '[v1]CAT-013.html', n: '서비스 음료', tab: 'home', nav: 1 },
    { id: 'smoke', f: '[v1]CAT-014.html', n: '금연 클럽', tab: 'home', nav: 1 },
  ], flows: [] },
  { key: 'C', cont: true, code: 'CAT', title: '카테고리 · 장르', sub: '장르별 클럽 → DJ 공연 일정', screens: [
    { id: 'kpop', f: '[v1]CAT-015.html', n: 'K-POP', tab: 'home', nav: 1 },
    { id: 'hiphop', f: '[v1]CAT-016.html', n: '힙합', tab: 'home', nav: 1 },
    { id: 'edm', f: '[v1]CAT-017.html', n: 'EDM', tab: 'home', nav: 1 },
    { id: 'edmsch', f: '[v1]CAT-018.html', n: 'DJ 공연 일정' },
  ], flows: [['edm', 'edmsch', '공연 일정 전체보기']] },
  { key: 'D', code: 'PLACE', title: '주변 · 찜', sub: '주변 지도는 하단 탭 · 찜한 클럽은 마이·하트·지도 필터로 진입', screens: [
    { id: 'nearby', f: '[v1]PLACE-019.html', n: '주변 지도', tab: 'nearby', nav: 1, widgets: [{ n: '핀 클럽 카드', page: '[v1]PLACE-019-1.html' }] },
    { id: 'saved', f: '[v1]PLACE-020.html', n: '찜한 클럽', tab: '', nav: 1, todo: '찜 탭이 없어져 하단 탭 활성 상태가 비었다. 마이 진입 기준으로 활성 탭(내 정보) 처리 확정 필요.' },
  ], flows: [] },
  { key: 'E', code: 'CLUB', title: '클럽 상세 · 예약', sub: '클럽 상세에서 일정 · 테이블 · 주문 · 웨이팅 · 리뷰로 분기', screens: [
    { id: 'club', f: '[v1]CLUB-021.html', n: '클럽 상세', mod: 1, todo: '하단 바 교체 완료(하트 · 웨이팅 등록 · 테이블 예약). 목록 · 지도 · 알림의 클럽 카드도 이 v1 상세로 연결됨. 기존 “길찾기 · 전화 문의” 버튼의 새 위치는 미정.' },
    { id: 'sched', f: '[v1]CLUB-022.html', n: '공연 일정' },
    { id: 'table', f: '[v1]CLUB-023.html', n: '테이블 가격' },
    { id: 'reserve', gap: 1 }, /* 24 · 테이블 예약(베타) — v1에서 제거(47~53 신규 예약 흐름으로 대체) */
    { id: 'order', gap: 1 }, /* 25 · 음료 주문(베타) — v1에서 제거(54~56 신규 주문 흐름으로 대체) */
    { id: 'cwait', f: '[v1]CLUB-026.html', n: '클럽 상세 · 웨이팅', widgets: [
      { n: '웨이팅 등록 시트', c: 'VWSheet', p: `({open:true,mode:'form',people:2,onPeople:${NOOP},onClose:${NOOP},onSubmit:${NOOP},onCancelWaiting:${NOOP}})` },
      { n: '웨이팅 완료 시트', c: 'VWSheet', p: `({open:true,mode:'ticket',people:2,ticket:{rank:7,wait:25,people:2},onPeople:${NOOP},onClose:${NOOP},onSubmit:${NOOP},onCancelWaiting:${NOOP}})` }] },
    { id: 'wait', gap: 1 }, /* 27 · 웨이팅 현황 — v1에서 제거(44 웨이팅 티켓으로 대체) · 번호는 비워 둔다 */
    { id: 'review', f: '[v1]CLUB-028.html', n: '리뷰 작성' },
  ], flows: [['club', 'sched', '일정 전체보기'], ['club', 'table', '테이블 탭'], ['club', 'cwait', '웨이팅'], ['club', 'review', '리뷰 쓰기']] },
  { key: 'F', code: 'MY', title: '마이', sub: '하단 탭 — 내 정보 · 리뷰 · 찜한 클럽 · 고객센터 · 탈퇴', screens: [
    { id: 'my', f: '[v1]MY-029.html', n: '마이', tab: 'my', nav: 1, widgets: [{ n: '탈퇴 확인 다이얼로그', c: 'MRLeaveDialog', p: `({reviews:12,onCancel:${NOOP},onConfirm:${NOOP}})` }] },
    { id: 'edit', f: '[v1]MY-030.html', n: '내 정보 수정', widgets: [{ n: '사진 변경 시트', c: 'MEPhotoSheet', p: `({onClose:${NOOP},onPick:${NOOP}})` }] },
    { id: 'myrev', f: '[v1]MY-031.html', n: '내 리뷰 (베타)', widgets: [{ n: '리뷰 삭제 확인', c: 'MRConfirm', p: `({review:(typeof MR_REVIEWS!=='undefined'?MR_REVIEWS[0]:{}),onCancel:${NOOP},onConfirm:${NOOP}})` }] },
    { id: 'support', f: '[v1]MY-032.html', n: '고객센터 문의' },
    { id: 'delete', f: '[v1]MY-033.html', n: '회원 탈퇴', widgets: [{ n: '탈퇴 확인 다이얼로그', c: 'ADDialog', p: `({onCancel:${NOOP},onConfirm:${NOOP}})` }] },
  ], flows: [['my', 'edit', '프로필 수정'], ['my', 'myrev', '내 리뷰'], ['my', 'support', '고객센터'], ['my', 'delete', '회원 탈퇴']] },
  { key: 'G', code: 'SYS', title: '예외 상태', sub: '네트워크 오류', screens: [
    { id: 'neterr', f: '[v1]SYS-034.html', n: '네트워크 오류' },
  ], flows: [] },

  { key: 'H', code: 'PASS', title: '패스월렛', sub: '하단 패스월렛 탭 — 입장권 · 예약 · 이용 내역 · 리뷰', screens: [
    { id: 'pw01', nf: 'pw-01' }, { id: 'pw02', nf: 'pw-02' }, { id: 'pw03', nf: 'pw-03' },
    { id: 'pw04', nf: 'pw-04' }, { id: 'pw05', nf: 'pw-05' }, { id: 'pw06', nf: 'pw-06' },
    { id: 'pw07', nf: 'pw-07' }, { id: 'pw08', nf: 'pw-08' }, { id: 'pw09', nf: 'pw-09' },
  ], flows: [['pw01', 'pw02', '예약 탭'], ['pw02', 'pw03', '예약 여러 건'], ['pw03', 'pw04', '이용 내역 탭'], ['pw04', 'pw05', '이용 내역 카드'], ['pw02', 'pw06', '스탯 탭 · 예약 상세'], ['pw02', 'pw07', '티켓 QR 탭'], ['pw04', 'pw08', '내가 쓴 리뷰'], ['pw08', 'pw09', '리뷰 수정']] },
  { key: 'I', code: 'WAIT', title: '비대면 웨이팅', sub: '웨이팅 티켓 · 순서 미루기 · 취소', screens: [
    { id: 'wt01', nf: 'wt-01' }, { id: 'wt02', nf: 'wt-02' }, { id: 'wt03', nf: 'wt-03' },
  ], flows: [['wt01', 'wt02', '순서 미루기'], ['wt01', 'wt03', '웨이팅 취소']] },
  { key: 'J', code: 'RSV', title: '테이블 예약', sub: '예약 정보 → 결제 → 완료 → 취소', screens: [
    { id: 'rs01', nf: 'rs-01' }, { id: 'rs02', gap: 1 } /* 48 · 친구 추가 — v1에서 제거 */, { id: 'rs03', nf: 'rs-03' },
    { id: 'rs04', nf: 'rs-04' }, { id: 'rs05', nf: 'rs-05' }, { id: 'rs06', nf: 'rs-06' }, { id: 'rs07', nf: 'rs-07' },
  ], flows: [['rs01', 'rs03', '결제하기'], ['rs03', 'rs04', '카드사 · 할부 선택'], ['rs03', 'rs05', '약관 보기'], ['rs03', 'rs06', '결제 완료'], ['rs06', 'rs07', '예약 취소']] },
  { key: 'K', code: 'MENU', title: '비대면 주문', sub: '메뉴 목록 · 상세 · 장바구니', screens: [
    { id: 'od01', nf: 'od-01' }, { id: 'od02', nf: 'od-02' }, { id: 'od03', nf: 'od-03' },
  ], flows: [['od01', 'od02', '메뉴 탭'], ['od02', 'od03', '담기 → 장바구니']] },
  { key: 'L', code: 'TBD', title: '비워 둔 번호 057~060', sub: '베타 화면 정리로 비운 번호 — 재사용하지 않는다 (057 예약 변경은 RSV-094로 대체)', screens: [
    { id: 'tbdChange', gap: 1 }, /* 57 · 예약 변경하기 — R 섹션 RSV-094(변경 항목 선택)로 대체 · 번호는 비워 둔다 */
    { id: 'tbdPay', gap: 1 }, /* 58 · 비대면 주문 결제 — 61 주문 결제로 제작되어 제거 */
    { id: 'tbdDone', gap: 1 }, /* 59 · 주문 완료 · 진행 상태 — 62 · 63으로 제작되어 제거 */
    { id: 'tbdBtn', gap: 1 }, /* 60 · 클럽 상세 하단 버튼 예외 — 21 클럽 상세의 버튼 상태로 정리 · 제거 */
  ], flows: [] },
  { key: 'M', code: 'ORDER', title: '비대면 오더', sub: '메뉴 · 결제는 테이블 예약 화면 재사용 — 결제 → 상태 → 상세 → 영수증', screens: [
    { id: 'odPay', nf: 'od-04' }, { id: 'odDone', nf: 'od-05' }, { id: 'odSt', nf: 'od-06', admin: '매장이 관리자 페이지에서 만드는 중 → 픽업 대기로 바꾸면 이 화면의 상태가 바뀐다. 관리자 화면은 v1 범위 외.' },
    { id: 'odDet', nf: 'od-07' }, { id: 'odRc', nf: 'od-08' }, { id: 'odErr', nf: 'od-09' },
    { id: 'odPw', nf: 'od-10' }, { id: 'odHist', nf: 'od-11' },
  ], flows: [['odPay', 'odDone', '결제하기'], ['odDone', 'odSt', '주문 상태 보기'], ['odSt', 'odDet', '주문 상세'], ['odDet', 'odRc', '영수증 보기'], ['odPw', 'odHist', '이용 내역 탭']] },
];

/* 섹션을 넘는 흐름 — 첫 항목이 배열이면 여러 화면이 한 줄기로 모인다(팬인) */
SECTIONS.push(
  { key: 'N', code: 'FEE', title: '입장비 웨이팅', sub: '입장비가 있는 클럽 — 결제가 완료되어야 웨이팅이 등록된다', screens: [
    { id: 'wf01', nf: 'wf-01' }, { id: 'wf02', nf: 'wf-02' }, { id: 'wf03', nf: 'wf-03' }, { id: 'wf04', nf: 'wf-04' },
    { id: 'wf05', nf: 'wf-05' }, { id: 'wf06', nf: 'wf-06' }, { id: 'wf07', nf: 'wf-07' },
  ], flows: [['wf01', 'wf02', '인원 선택'], ['wf02', 'wf03', '결제하고 웨이팅 등록'], ['wf03', 'wf04', '결제 요청'], ['wf04', 'wf05', '결제 확인 · 순번 발급 → waiting'], ['wf05', 'wf06', '결제 영수증 보기'], ['wf06', 'wf07', '웨이팅 취소 · 환불'], ['wf03', 'wf07', '결제 실패 · 결제 중 마감']] },
  { key: 'O', code: 'SHARE', title: '입장권 공유', sub: '입장 완료(entered) 입장권만 공유 — 공유 QR 딥링크 또는 공유 일련번호 + 공유 비밀번호 (친구 추가 없음)', screens: [
    { id: 'sh01', nf: 'sh-01' }, { id: 'sh02', nf: 'sh-02' }, { id: 'sh03', nf: 'sh-03' }, { id: 'sh04', nf: 'sh-04' },
    { id: 'sh05', nf: 'sh-05' }, { id: 'sh06', nf: 'sh-06' }, { id: 'sh07', gap: 1 }, { id: 'sh08', nf: 'sh-08' },
    { id: 'sh09', nf: 'sh-09' }, { id: 'sh10', nf: 'sh-10' }, { id: 'sh11', nf: 'sh-11' },
  ], flows: [['sh01', 'sh02', '공유하기 (첫 공유)'], ['sh02', 'sh03', '비밀번호 설정 완료'], ['sh03', 'sh04', '공유 관리'], ['sh05', 'sh06', '일련번호 입력'], ['sh06', 'sh09', '비밀번호 일치'], ['sh09', 'sh10', '패스월렛에서 보기'], ['sh03', 'sh06', '기본 카메라로 QR 인식 → 딥링크'], ['sh03', 'sh08', '앱 미설치'], ['sh06', 'sh11', '예외 처리']] },
  { key: 'P', code: 'RSV', title: '테이블 예약 티켓 자동 전환', sub: '입장 3시간 전이 되면 예약 섹션 → 입장 섹션으로 자동 이동 · 티켓 정보는 그대로 · 상태 표시는 입장권 체계를 사용 · 공유는 O 섹션 화면을 그대로 재사용', screens: [
    { id: 'rv01', nf: 'rv-01' }, { id: 'rv02', nf: 'rv-02' }, { id: 'rv03', nf: 'rv-03' },
  ], flows: [['rv01', 'rv02', '입장 3시간 전 자동 전환'], ['rv02', 'rv03', '티켓 상세 보기']] },
  { key: 'Q', code: 'MENU', title: '테이블 예약 · 메뉴 선택', sub: '비대면 오더 메뉴 선택(MENU-054)과 분리한 예약 전용 화면 — 최소 주문금액 진행 바', screens: [
    { id: 'rm01', nf: 'rm-01' },
  ], flows: [] },
  { key: 'R', code: 'RSV', title: '예약 취소 · 변경', sub: '취소는 시점별 환불 구간 · 변경은 상향 무료 / 하향 패널티 — 취소 · 변경 규정 반영', screens: [
    { id: 'rc01', nf: 'rc-01' }, { id: 'rc02', nf: 'rc-02' }, { id: 'rc03', nf: 'rc-03' },
    { id: 'rc04', nf: 'rc-04' }, { id: 'rc05', nf: 'rc-05' }, { id: 'rc06', nf: 'rc-06' },
    { id: 'rc07', nf: 'rc-07' }, { id: 'rc08', nf: 'rc-08' }, { id: 'rc09', nf: 'rc-09' },
    { id: 'rc10', nf: 'rc-10' }, { id: 'rc11', nf: 'rc-11' }, { id: 'rc12', nf: 'rc-12' },
    { id: 'rc13', nf: 'rc-13' }, /* 103 · 예약 정보 변경 — 번호는 맨 끝, 배치는 아래 order로 094 옆 */
  ], order: ['rc01', 'rc02', 'rc03', 'rc04', 'rc13', 'rc05', 'rc06', 'rc07', 'rc08', 'rc09', 'rc10', 'rc11', 'rc12'], flows: [
    ['rc01', 'rc02', '10분 경과 · 부분 환불 구간'],
    ['rc02', 'rc03', '영업 시작 후 · 환불 불가 구간'],
    ['rc04', 'rc13', '바꿀 항목 선택 후 변경하기'],
    ['rc13', 'rc05', '하향 변경 · 패널티 발생'],
    ['rc05', 'rc06', '규정상 변경 불가 항목'],
    ['rc06', 'rc04', '가능한 변경 보기'],
    ['rc05', 'rc07', '2회차 이상 · 수수료 3,000원'],
    ['rc07', 'rc08', '동의하고 변경'],
    ['rc13', 'rc08', '무료 변경 · 금액 변화 없음'],
    ['rc09', 'rc10', '전액 환불 진행'],
  ] },
  { key: 'S', code: 'ORDER', title: '주문 취소 · 환불', sub: '결제 완료 구간에서만 취소 · 조리 시작 후에는 취소 불가 · 매장 거절은 전액 자동 환불', screens: [
    { id: 'oc01', nf: 'oc-01' }, { id: 'oc02', nf: 'oc-02' }, { id: 'oc03', nf: 'oc-03' },
  ], flows: [['oc01', 'oc02', '취소하고 환불받기'], ['oc03', 'oc02', '매장 거절 · 자동 환불']] },
  { key: 'T', code: 'RSV', title: '예약 결제 예외', sub: '결제 실패 · 예약 불가 — 재시도와 대안(다른 날짜 · 다른 테이블 · 웨이팅)으로 이어진다', screens: [
    { id: 'rp01', nf: 'rp-01' }, { id: 'rp02', nf: 'rp-02' },
  ], flows: [['rp01', 'rp02', '결제 중 좌석 마감 · 마감 안내']] },
);
const GFLOWS = [
  /* 홈 · 하단 탭 · 퀵메뉴 진입 */
  ['home', 'rec', '퀵메뉴 · VYBE 추천'], ['home', 'hot', '퀵메뉴 · 핫플레이스'], ['home', 'free', '퀵메뉴 · 입장비 무료'],
  ['home', 'drink', '퀵메뉴 · 서비스 음료'], ['home', 'smoke', '퀵메뉴 · 금연 클럽'],
  ['home', 'kpop', '장르 · K-POP'], ['home', 'hiphop', '장르 · 힙합'], ['home', 'edm', '장르 · EDM'],
  ['home', 'nearby', '하단 · 주변'], ['home', 'my', '하단 · 내 정보'], ['home', 'neterr', '통신 오류'],
  /* 종료 화면 복귀 */
  ['odRc', 'odDet', '영수증 닫기'], ['odErr', 'od01', '주문 내역 없음 · 메뉴 보기'], ['odErr', 'odSt', '오류 · 다시 시도'],
  ['sh04', 'sh01', '공유 중지 후 입장권으로'], ['sh08', 'sh05', '앱 설치 후 일련번호 입력'], ['sh11', 'pw01', '예외 확인 후 패스월렛'],
  /* 주문 취소 · 환불 */
  ['odSt', 'oc01', '주문 취소'], ['odDet', 'oc01', '주문 취소'], ['oc01', 'odSt', '돌아가기'],
  ['oc02', 'odHist', '환불 확인 · 이용 내역'], ['oc02', 'support', '환불 실패 · 고객센터 문의'],
  ['oc03', 'od01', '메뉴 다시 보기'], ['noti', 'oc03', '매장 거절 알림'],
  /* 예약 결제 예외 */
  ['rs03', 'rp01', '결제 실패 · 좌석 마감'], ['rp01', 'rs03', '다시 결제하기'], ['rp01', 'rs01', '다른 테이블 선택'],
  ['rs01', 'rp02', '날짜 · 테이블 마감'], ['rp02', 'rs01', '다른 날짜 · 테이블 선택'], ['rp02', 'wf01', '웨이팅으로 등록하기'],
  ['rp01', 'club', '나가기'],
  ['club', 'wf01', '하단 · 웨이팅 등록 (입장비 있는 클럽)'],
  ['cwait', 'wf01', '입장비 있는 클럽 · 결제 단계'],
  ['wf05', 'pw01', '패스월렛 · 입장권 탭'],
  ['wf06', 'sh01', '입장 완료 후 공유하기'],
  ['wf07', 'pw04', '취소 · 환불 내역 → 이용 내역'],
  ['wt01', 'sh01', '입장 완료 · 공유하기'],
  ['pw01', 'sh05', '공유 입장권 받기 진입점'],
  ['sh10', 'pw01', '공유받음 입장권 표시'],

  [['rec', 'hot', 'free', 'drink', 'smoke', 'kpop', 'hiphop', 'edm', 'edmsch', 'search', 'lineup', 'saved', 'nearby'], 'club', '클럽 카드 · 상세보기'],
  ['code', 'home', '인증 완료'],
  ['neterr', 'home', '다시 시도'],
  ['my', 'saved', '내 활동 · 찜한 클럽'],
  ['club', 'rs01', '하단 · 테이블 예약'],
  ['cwait', 'wt01', '웨이팅 등록 완료 (입장비 없는 클럽)'],
  ['wf05', 'wt01', '웨이팅 등록 완료 (입장비 있는 클럽)'],
  ['home', 'pw01', '하단 · 패스월렛 탭'],
  ['pw01', 'nearby', '주변 클럽 보기 (빈 상태)'],
  ['pw01', 'wt01', '진행 중 웨이팅 보유'],
  ['noti', 'wt01', '입장 순서 알림'],
  ['wt01', 'pw07', '입장 QR 크게 보기'],
  ['wt01', 'od01', '입장 완료 · 바로 주문하기'],
  ['wt01', 'review', '입장 완료 · 후기 작성'],
  ['pw04', 'review', '후기 요청 · 별점'],
  ['rs01', 'rm01', '사전 주문 담기'],
  ['od03', 'rs01', '예약에 담기'],
  ['rs06', 'pw02', '패스월렛에서 보기 (예약 탭 활성)'],
  ['rs06', 'club', '확인 · 예약을 시작한 화면으로'],
  ['pw02', 'rc04', '예약 변경하기'],
  /* 예약 취소 · 변경 (RSV-091 ~ RSV-102) — 취소는 누를 때의 시점으로 구간이 갈라진다 */
  ['pw02', 'rc01', '예약 취소 · 결제 후 10분 이내(무료)'],
  ['rs06', 'rc01', '예약 완료 직후 취소 · 10분 이내'],
  ['pw02', 'rc02', '예약 취소 · 2일 전 ~ 당일 영업 전(부분 환불)'],
  ['pw02', 'rc03', '예약 취소 · 영업 시작 후(환불 불가)'],
  ['rc01', 'rs07', '무료로 취소하기 · 전액 환불'],
  ['rc02', 'rs07', '취소하기 → 최종 확인 (RSV-053-2)'],
  ['rc03', 'rs07', '환불 없이 취소 → 확인 (RSV-053-3)'],
  ['rs07', 'rc10', '취소 완료 → 환불 상태'],
  ['pw04', 'rc10', '이용 내역 · 취소 항목'],
  ['rc10', 'support', '환불 실패 · 고객센터 문의'],
  ['rc13', 'rs03', '상향 변경 · 차액 결제 (RSV-049-7)'],
  ['rc13', 'rm01', '사전 주문 수정'],
  ['rm01', 'rc13', '메뉴 수정 완료 · 변경 화면 복귀'],
  ['rm01', 'rs01', '담기 완료 · 예약 정보 입력으로 복귀'],
  ['rs03', 'rc08', '상향 변경 · 차액 결제 완료'],
  ['rc08', 'pw02', '패스월렛에서 보기'],
  ['rc08', 'pw06', '확인 · 예약 상세'],
  ['noti', 'rc09', '매장 취소 알림'],
  ['rc09', 'pw04', '이용 내역'],
  ['rc09', 'nearby', '같은 날 다른 클럽 찾기'],
  ['rv02', 'rc11', '전환 후 · 당일이라 환불 불가'],
  ['rv03', 'rc11', '전환된 티켓 취소 · 변경 시도'],
  ['rc11', 'club', '매장에 문의'],
  ['pw01', 'rc12', '공유받은 티켓 삭제 안내'],
  ['noti', 'rc12', '공유 티켓 삭제 알림'],
  ['rc12', 'nearby', '주변 클럽 보기'],
  ['table', 'rs01', '예약하기'],
  ['club', 'od01', '하단 · 음료 주문'],
  ['myrev', 'pw08', '내가 쓴 리뷰'],
  /* 테이블 예약 티켓 자동 전환 · 공유 */
  ['pw02', 'rv01', '전환 전 예약 티켓'],
  ['rv03', 'sh02', '전환된 예약 티켓 공유하기'],
  ['rv03', 'sh04', '공유 중 · 공유 관리'],
  ['rm01', 'od03', '장바구니 · 최소 주문금액 확인'],
  ['od03', 'rm01', '더 담으러 가기 (예약 흐름)'],
  /* 비대면 오더 */
  ['od03', 'odPay', '결제하기 (주문 모드)'],
  ['odPay', 'rs04', '카드사 · 할부 시트 재사용'],
  ['odPay', 'rs05', '약관 재사용'],
  ['odPay', 'odErr', '결제 실패'],
  ['od01', 'odPw', '패스월렛 · 주문 탭'],
  ['odSt', 'od01', '추가 주문'],
  ['odSt', 'odHist', '픽업 완료 후 이용 내역'],
  ['odHist', 'odDet', '주문 항목 선택'],
  ['pw04', 'odHist', '주문 내역 병합'],
  ['wt01', 'odPw', '입장 후 진행 중 주문'],
  ['noti', 'odSt', '픽업 알림'],
  /* 복귀 — 뒤로가기 · 시트 닫기 · 완료 후 돌아가는 화면 */
  ['notice', 'home', '뒤로'],
  ['sched', 'club', '뒤로'],
  ['review', 'pw04', '후기 등록 완료'],
  ['edit', 'my', '저장 후 뒤로'],
  ['support', 'my', '문의 접수 후 뒤로'],
  ['delete', 'splash', '탈퇴 완료 · 첫 화면'],
  ['pw05', 'pw04', '시트 닫기'],
  ['pw06', 'pw02', '뒤로'],
  ['pw07', 'wt01', 'QR 닫기'],
  ['pw09', 'pw08', '등록 완료'],
  ['wt02', 'wt01', '변경 완료'],
  ['wt03', 'pw01', '취소 후 입장권 탭'],
  ['rs04', 'rs03', '선택 완료 · 시트 닫기'],
  ['rs05', 'rs03', '뒤로'],
  ['rs07', 'pw03', '취소 후 예약 목록'],
];
/* 화면 번호 · 고유 ID — 한 번 정하면 바뀌지 않는 값.
   번호는 섹션 순서대로 이어지고, 제거된 화면(gap)도 번호를 차지해 뒤 화면 번호가 밀리지 않는다.
   ID = [기능 코드]-[3자리 번호] · 상태 변형은 하위 번호(-1, -2 …)를 붙인다. */
let _num = 0;
SECTIONS.forEach((sec) => sec.screens.forEach((sc) => {
  _num += 1;
  sc.no = String(_num).padStart(2, '0');
  sc.sid = sec.code + '-' + String(_num).padStart(3, '0');
}));
window.V1_SID = (sc, i) => (i ? sc.sid + '-' + i : sc.sid);
window.V1_SECTIONS = SECTIONS;
window.V1_GFLOWS = GFLOWS;
/* 화면 번호는 위 섹션 순서 그대로 이어진다(기존 번호 유지).
   표시 위치만 다르게 둔다 — R 예약 취소 · 변경은 J 테이블 예약 바로 다음에 둔다. */
const LAYOUT = SECTIONS.slice();
{
  const ri = LAYOUT.findIndex((s) => s.key === 'R');
  const ji = LAYOUT.findIndex((s) => s.key === 'J');
  if (ri > -1 && ji > -1) LAYOUT.splice(ji + 1, 0, LAYOUT.splice(ri, 1)[0]);
  /* 신규 보강 섹션도 관련 기능 옆에 둔다 — 번호는 SECTIONS 순서(맨 뒤)를 그대로 유지한다 */
  [['T', 'J'], ['S', 'M']].forEach(([a, b]) => {
    const ai = LAYOUT.findIndex((s) => s.key === a); const bi = LAYOUT.findIndex((s) => s.key === b);
    if (ai > -1 && bi > -1) LAYOUT.splice(bi + 1, 0, LAYOUT.splice(ai, 1)[0]);
  });
}
/* 섹션 안에서도 번호와 배치를 나눈다 — order가 있으면 그 순서로 그린다 */
SECTIONS.forEach((sec) => {
  if (!sec.order) return;
  const by = {};
  sec.screens.forEach((s) => { by[s.id] = s; });
  sec.layout = sec.order.map((id) => by[id]).filter(Boolean);
});
window.V1_LAYOUT = LAYOUT;
})();
