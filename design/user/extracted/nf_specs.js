/* VYBE v1 — 신규 기능 화면 명세 (new_func_renew.jsx FEATURES의 After 상태를 그대로 옮긴 표)
   스토리보드(부모)와 nf_frame.html(iframe)이 같은 표를 읽는다. 디자인·문구 수정 없음. */
window.NF_SPECS = [
  { id: 'pw-01', comp: 'PassWallet', n: '입장권 탭 · 빈 상태', states: [
    { l: '빈 상태', p: { tab: 'ticket', wait: null } }] },
  { id: 'pw-02', comp: 'PassWallet', n: '예약 탭 · 예약 티켓', states: [
    { l: '예약 확정', p: { tab: 'resv', resvState: 'confirmed' } },
    { l: '접수됨', p: { tab: 'resv', resvState: 'pending' } },
    { l: '오늘 예약', p: { tab: 'resv', resvState: 'today' } },
    { l: '노쇼 결과 티켓', p: { tab: 'resv', resvState: 'noshow' } }] },
  { id: 'pw-03', comp: 'PassWallet', n: '예약 탭 · 예약 목록', states: [
    { l: '목록', p: { tab: 'resv', resv: 'list' } },
    { l: '내역 삭제 확인', p: { tab: 'resv', resv: 'list', overlay: 'delResv' } },
    { l: '삭제 완료', p: { tab: 'resv', resv: 'list', overlay: 'delDone' } }] },
  { id: 'pw-04', comp: 'PassWallet', n: '이용 내역', states: [
    { l: '후기 요청 포함', p: { tab: 'hist' } },
    { l: '후기 요청 없음', p: { tab: 'hist', hist: 'short' } }] },
  { id: 'pw-05', comp: 'PassWallet', n: '결제 내역 시트 · 삭제', states: [
    { l: '결제 상세', p: { tab: 'hist', overlay: 'histSheet' } },
    { l: '삭제 확인', p: { tab: 'hist', overlay: 'histDel' } },
    { l: '삭제 완료', p: { tab: 'hist', overlay: 'histDone' } }] },
  { id: 'pw-06', comp: 'ResvDetail', n: '예약 상세', states: [
    { l: '인원', p: { anchor: 'people' } },
    { l: '좌석', p: { anchor: 'seat' } },
    { l: '결제', p: { anchor: 'pay' } }] },
  { id: 'pw-07', comp: 'QrFull', n: '입장 QR 전체 화면', states: [
    { l: '유효', p: {} },
    { l: '60초 미만', p: { start: 45 } },
    { l: '만료', p: { start: 3 } }] },
  { id: 'pw-08', comp: 'MyReview', n: '내가 쓴 리뷰', states: [
    { l: '리뷰', p: {} },
    { l: '더보기 메뉴', p: { menu: true } },
    { l: '삭제 확인', p: { del: true } }] },
  { id: 'pw-09', comp: 'ReviewEdit', n: '리뷰 수정', states: [
    { l: '수정', p: {} },
    { l: '등록 완료', p: { done: true } }] },

  { id: 'wt-01', comp: 'PassWallet', n: '웨이팅 티켓', states: [
    { l: '대기 중', p: { wait: 'waiting' } },
    { l: '입장 순서', p: { wait: 'called' } },
    { l: '입장 완료', p: { wait: 'entered' } },
    { l: '입장 시간 지남', p: { wait: 'expired' } }] },
  { id: 'wt-02', comp: 'PassWallet', n: '순서 미루기', states: [
    { l: '미루기 확인', p: { wait: 'called', overlay: 'postpone' } },
    { l: '대기 중에서 미루기', p: { wait: 'waiting', overlay: 'postpone' } },
    { l: '변경 완료', p: { wait: 'waiting', back: true } }] },
  { id: 'wt-03', comp: 'PassWallet', n: '웨이팅 취소', states: [
    { l: '취소 확인', p: { wait: 'waiting', overlay: 'cancelWait' } },
    { l: '취소 완료', p: { wait: 'canceled' } }] },

  { id: 'rs-01', comp: 'BookingForm', n: '예약 정보 입력', states: [
    { l: '기본', p: {} },
    { l: '입력 완료', p: { filled: true } },
    { l: '펼침 · 빈 값', p: { open: 'date' } },
    { l: '펼침 · 입력', p: { filled: true, open: 'people' } }] },
  { id: 'rs-03', comp: 'Payment', n: '결제', states: [
    { l: '수단 미선택', p: {} },
    { l: '네이버페이', p: { method: 'naver', terms: [1, 1, 1, 1] } },
    { l: '신용카드 · 신한', p: { method: 'card', card: '신한', inst: '3개월 (무이자)', terms: [1, 1, 1, 0] } },
    { l: '카드사 미선택', p: { method: 'card' } },
    { l: '규정 동의 전 · 결제 막힘', p: { method: 'card', card: '신한', inst: '3개월 (무이자)', terms: [1, 1, 1, 1] } },
    { l: '전체 규정 보기', p: { method: 'card', card: '신한', inst: '3개월 (무이자)', terms: [1, 1, 1, 1], rOv: true } },
    { l: '규정 동의 후 · 결제 가능', p: { method: 'card', card: '신한', inst: '3개월 (무이자)', terms: [1, 1, 1, 1], rAgree: true } },
    { l: '상향 변경 · 차액 결제', p: { chg: true, method: 'card', card: '신한', inst: '3개월 (무이자)', terms: [1, 1, 1, 1] } },
    { l: '결제 확인 중', p: { method: 'card', card: '신한', inst: '3개월 (무이자)', terms: [1, 1, 1, 1], rAgree: true, busy: true } }] },
  { id: 'rs-04', comp: 'Payment', n: '카드사 · 할부 선택', states: [
    { l: '카드사', p: { method: 'card', sheet: 'card' } },
    { l: '카드사 선택됨', p: { method: 'card', card: '신한', sheet: 'card' } },
    { l: '할부', p: { method: 'card', card: '신한', inst: null, sheet: 'inst' } },
    { l: '할부 선택됨', p: { method: 'card', card: '신한', inst: '3개월 (무이자)', sheet: 'inst' } }] },
  { id: 'rs-05', comp: 'Terms', n: '개인정보 이용 약관', states: [{ l: '약관', p: {} }] },
  { id: 'rs-06', comp: 'BookingDone', n: '예약 완료', states: [
    { l: '접수됨', p: {} },
    { l: '매장 확정', p: { st: 'confirmed' } }] },
  { id: 'rs-07', comp: 'PassWallet', n: '예약 취소', states: [
    { l: '취소 확인 · 전액 환불', p: { tab: 'resv', overlay: 'cancelResv' } },
    { l: '취소 완료', p: { tab: 'resv', resvState: 'canceled' } },
    { l: '최종 확인 · 부분 환불', p: { tab: 'resv', overlay: 'cancelResvPart' } },
    { l: '최종 확인 · 환불 없음', p: { tab: 'resv', overlay: 'cancelResvNone' } }] },

  { id: 'od-01', comp: 'MenuList', n: '메뉴 목록', states: [
    { l: '비어 있음', p: {} },
    { l: '1개 담김', p: { cart: { hardA: 1 } } }] },
  { id: 'od-02', comp: 'MenuDetail', n: '메뉴 상세', states: [
    { l: '옵션 없음', p: {} },
    { l: '옵션 선택', p: { opts: [true, false, false] } }] },
  { id: 'od-03', comp: 'Cart', n: '장바구니', states: [
    { l: '예약에 담기', p: {} },
    { l: '비대면 주문 · 결제하기', p: { mode: 'order' } },
    { l: '담은 메뉴 없음 · 최소 주문금액 미달', p: { below: true } }] },

  /* ── M 비대면 오더 (v1 신규) ── */
  { id: 'od-04', comp: 'Payment', n: '주문 결제', states: [
    { l: '수단 미선택', p: { mode: 'order' } },
    { l: '신용카드 · 신한', p: { mode: 'order', method: 'card', card: '신한', inst: '3개월 (무이자)', terms: [1, 1, 1, 0] } },
    { l: '결제 확인 중', p: { mode: 'order', method: 'card', card: '신한', inst: '3개월 (무이자)', terms: [1, 1, 1, 0], busy: true } }] },
  { id: 'od-05', comp: 'OrderDone', n: '주문 완료', states: [{ l: '접수됨', p: {} }] },
  { id: 'od-06', comp: 'OrderStatus', n: '주문 상태', states: [
    { l: '결제 완료', p: { st: 'paid' } },
    { l: '만드는 중', p: { st: 'making' } },
    { l: '픽업 대기', p: { st: 'ready' } },
    { l: '진행 중 3건', p: { multi: true } }] },
  { id: 'od-07', comp: 'OrderDetail', n: '주문 상세', states: [
    { l: '픽업 완료', p: { st: 'done' } },
    { l: '진행 중', p: { st: 'making' } }] },
  { id: 'od-08', comp: 'Receipt', n: '영수증', states: [{ l: '영수증', p: {} }] },
  { id: 'od-09', comp: 'OrderStates', n: '주문 예외 상태', states: [
    { l: '주문 내역 없음', p: { v: 'empty' } },
    { l: '로딩', p: { v: 'loading' } },
    { l: '오류', p: { v: 'error' } },
    { l: '결제 실패', p: { v: 'fail' } }] },
  { id: 'od-10', comp: 'PassWallet', n: '패스월렛 · 주문 탭', states: [
    { l: '진행 중 3건', p: { tab: 'order' } },
    { l: '입장권 빈 상태 · 주문 카드', p: { tab: 'ticket', wait: null } }] },
  { id: 'od-11', comp: 'PassWallet', n: '이용 내역 · 주문 필터', states: [
    { l: '전체', p: { tab: 'hist' } },
    { l: '주문만', p: { tab: 'hist', hf: 'order' } }] },

  /* ── N 입장비 웨이팅 (v1 신규) ── */
  { id: 'wf-01', comp: 'WaitEntry', n: '웨이팅 진입 · 입장비 표시', states: [
    { l: '입장비 있는 클럽', p: { fee: 1, people: 2, agree: true } },
    { l: '입장비 없는 클럽', p: { fee: 0, people: 2, agree: true } },
    { l: '유의사항 미동의', p: { fee: 1, people: 2 } }] },
  { id: 'wf-02', comp: 'WaitEntry', n: '인원 선택 · 총 입장비', states: [
    { l: '2명 · 40,000원', p: { fee: 1, people: 2, agree: true } },
    { l: '4명 · 80,000원', p: { fee: 1, people: 4, agree: true } },
    { l: '환불 규정 시트', p: { fee: 1, people: 4, agree: true, sheet: true } }] },
  { id: 'wf-03', comp: 'FeePay', n: '입장비 결제', states: [
    { l: '수단 미선택', p: {} },
    { l: '신용카드 · 동의 완료', p: { method: 'card', terms: [1, 1] } },
    { l: '환불 규정 전문', p: { method: 'card', terms: [1, 1], sheet: true } }] },
  { id: 'wf-04', comp: 'FeePay', n: '결제 처리 중', states: [
    { l: '결제 확인 중', p: { method: 'card', terms: [1, 1], busy: true, step: 1 } },
    { l: '순번 발급 중', p: { method: 'card', terms: [1, 1], busy: true, step: 2 } }] },
  { id: 'wf-05', comp: 'WaitFeeDone', n: '웨이팅 등록 완료', states: [
    { l: '입장비 결제 포함', p: { fee: 1 } },
    { l: '입장비 없는 클럽', p: { fee: 0 } }] },
  { id: 'wf-06', comp: 'PassWallet', n: '대기 현황 · 결제 정보', states: [
    { l: '대기 중 · 결제 정보', p: { wait: 'waiting', fee: 20000 } },
    { l: '입장비 영수증', p: { wait: 'waiting', fee: 20000, overlay: 'feeReceipt' } },
    { l: '입장 순서 · 결제 정보', p: { wait: 'called', fee: 20000 } }] },
  { id: 'wf-07', comp: 'FeeStates', n: '입장비 예외', states: [
    { l: '결제 실패', p: { v: 'fail' } },
    { l: '결제 중 웨이팅 마감', p: { v: 'closed' } },
    { l: '취소 · 환불 확인 팝업', p: { v: 'cancel' } }] },

  /* ── O 입장완료 입장권 공유 (v1 신규) ── */
  { id: 'sh-01', comp: 'PassWallet', n: '입장권 상세 · 공유하기', states: [
    { l: '입장 완료 · 공유 가능', p: { wait: 'entered', fee: 20000, share: true } },
    { l: '대기 중 · 공유 불가', p: { wait: 'waiting', fee: 20000, share: true } }] },
  { id: 'sh-02', comp: 'SharePw', n: '공유 비밀번호 설정', states: [
    { l: '입력 전', p: { v: 'empty' } },
    { l: '불일치 에러', p: { v: 'err' } },
    { l: '일치 · 설정 가능', p: { v: 'done' } }] },
  { id: 'sh-03', comp: 'ShareQr', n: '공유용 QR · 일련번호', states: [
    { l: 'QR · 일련번호', p: {} },
    { l: '일련번호 복사', p: { copied: true } }] },
  { id: 'sh-04', comp: 'ShareManage', n: '공유 관리', states: [
    { l: '공유 중 · 2회', p: {} },
    { l: '비밀번호 변경', p: { ov: 'pw' } },
    { l: '공유 중지 확인', p: { ov: 'stop' } },
    { l: '테이블 예약 티켓 공유 관리', p: { kind: 'resv' } }] },
  { id: 'sh-05', comp: 'ShareSerial', n: '입장권 받기 · QR · 일련번호', states: [
    { l: 'QR 스캔', p: { m: 'qr' } },
    { l: '일련번호 · 빈 입력', p: { m: 'serial', v: 'empty' } },
    { l: '일련번호 · 입력 완료', p: { m: 'serial', v: 'filled' } },
    { l: '없는 일련번호', p: { m: 'serial', v: 'none' } }] },
  { id: 'sh-06', comp: 'SharePreview', n: '미리보기 · 비밀번호 입력', states: [
    { l: 'QR로 진입', p: { v: 'input', from: 'qr' } },
    { l: '일련번호로 진입 · 입력 완료', p: { v: 'ready', from: 'serial' } },
    { l: '비밀번호 불일치', p: { v: 'err' } },
    { l: '시도 초과 잠김', p: { v: 'locked' } },
    { l: '테이블 예약 티켓 미리보기', p: { v: 'ready', from: 'serial', kind: 'resv' } }] },
  { id: 'sh-08', comp: 'ShareInstall', n: '앱 미설치 안내 (딥링크 웹)', states: [{ l: '설치 유도', p: {} }] },
  { id: 'sh-09', comp: 'ShareDone', n: '공유받기 완료', states: [
    { l: '완료', p: {} },
    { l: '테이블 예약 티켓 공유 완료', p: { kind: 'resv' } }] },
  { id: 'sh-10', comp: 'PassWallet', n: '패스월렛 · 공유받음 입장권', states: [
    { l: '공유받음 배지', p: { wait: 'entered', shared: true, share: true } },
    { l: '공유 입장권 받기 진입점', p: { wait: null } }] },
  { id: 'sh-11', comp: 'ShareErrors', n: '공유 예외', states: [
    { l: '만료된 QR 링크', p: { v: 'expired' } },
    { l: '공유 중지됨', p: { v: 'stopped' } },
    { l: '이미 공유받음', p: { v: 'already' } },
    { l: '본인 입장권', p: { v: 'self' } }] },

  /* ── P 테이블 예약 티켓 자동 전환 · 공유 (v1 신규) ── */
  { id: 'rv-01', comp: 'PassWallet', n: '예약 섹션 · 전환 전 예약 티켓', states: [
    { l: '예약 확정 · 전환 전', p: { tab: 'resv', resvState: 'confirmed', pre: true } },
    { l: '예약 당일 · 전환 대기', p: { tab: 'resv', resvState: 'today', pre: true } }] },
  { id: 'rv-02', comp: 'PassWallet', n: '입장 섹션 · 전환된 예약 티켓', states: [
    { l: '전환 직후 · 대기 중', p: { tab: 'ticket', wait: null, rsvEntry: 'waiting' } },
    { l: '입장 완료', p: { tab: 'ticket', wait: null, rsvEntry: 'entered' } },
    { l: '공유 중', p: { tab: 'ticket', wait: null, rsvEntry: 'waiting', sharing: true } },
    { l: '전환 후 예약 섹션', p: { tab: 'resv', wait: null, rsvEntry: 'waiting' } }] },
  { id: 'rv-03', comp: 'ResvDetail', n: '전환된 티켓 상세', states: [
    { l: '입장 대기', p: { entry: true } },
    { l: '공유 중', p: { entry: true, sharing: true } }] },

  /* ── Q 테이블 예약 · 메뉴 선택 (v1 신규 · 비대면 오더와 분리) ── */
  { id: 'rm-01', comp: 'RsvMenuList', n: '테이블 예약 · 메뉴 선택', states: [
    { l: '담은 메뉴 없음', p: {} },
    { l: '최소 주문금액 미달', p: { cart: { lemon: 1 } } },
    { l: '최소 주문금액 달성', p: { cart: { lemon: 5 } } },
    { l: '최소 주문금액 초과', p: { cart: { lemon: 5, hardA: 1 } } }] },

  /* ── R 예약 취소 · 변경 (취소 · 변경 규정 반영 · v1 신규) ── */
  { id: 'rc-01', comp: 'RkFreeCancel', n: '무료 취소 안내', states: [
    { l: '결제 후 10분 이내', p: {} }] },
  { id: 'rc-02', comp: 'RkDeduct', n: '취소 패널티 내역 확인', states: [
    { l: '2일 전 ~ 전날', p: { v: 'eve' } },
    { l: '당일 영업 시작 전', p: { v: 'day' } }] },
  { id: 'rc-03', comp: 'RkNoRefund', n: '취소 불가 안내', states: [
    { l: '영업 시작 후 · 전환 후', p: {} }] },
  { id: 'rc-04', comp: 'RkChangePick', n: '변경 항목 선택', states: [
    { l: '선택 전 · 변경 버튼 비활성', p: { sel: [] } },
    { l: '메뉴 선택 · 버튼 활성', p: { sel: ['메뉴'] } }] },
  { id: 'rc-05', comp: 'RkChangeDown', n: '하향 변경 패널티 확인', states: [
    { l: '1회차 · 수수료 무료', p: {} },
    { l: '2회차 · 수수료 3,000원', p: { n: 2 } }] },
  { id: 'rc-06', comp: 'RkNoChange', n: '변경 불가 안내', states: [
    { l: '영업 시작 후', p: {} }] },
  { id: 'rc-07', comp: 'RkChangeFee', n: '변경 수수료 안내 팝업', states: [
    { l: '2회차 · 3,000원', p: {} }] },
  { id: 'rc-08', comp: 'RkChangeDone', n: '변경 완료', states: [
    { l: '변경 완료', p: {} }] },
  { id: 'rc-09', comp: 'RkStoreCancel', n: '매장 취소 안내 · 전액 환불', states: [
    { l: '매장 사유 취소', p: {} }] },
  { id: 'rc-10', comp: 'RkRefund', n: '환불 상태', states: [
    { l: '환불 진행 중', p: { v: 'ing' } },
    { l: '환불 완료', p: { v: 'done' } },
    { l: '환불 실패', p: { v: 'fail' } }] },
  { id: 'rc-11', comp: 'RkEntryLock', n: '전환 티켓 취소 · 변경 불가', states: [
    { l: '입장권 전환 후', p: {} }] },
  { id: 'rc-12', comp: 'RkSharedDel', n: '공유받은 티켓 삭제 안내', states: [
    { l: '원본 예약 취소', p: {} }] },
  { id: 'rc-13', comp: 'RkChangeForm', n: '예약 정보 변경', states: [
    { l: '인원만 수정 가능 · 변경 전', p: { sel: ['인원'] } },
    { l: '인원 · 테이블 수정 가능', p: { sel: ['인원', '테이블'] } },
    { l: '인원 스테퍼 펼침', p: { sel: ['인원'], open: 'people' } },
    { l: '값 변경 후 · 버튼 활성', p: { sel: ['인원'], people: 4 } },
    { l: '메뉴 변경 후 복귀', p: { sel: ['메뉴'], menu: 'up' } }] },

  /* ── S 주문 취소 · 환불 (v1 신규 · 흐름 완성) ── */
  { id: 'oc-01', comp: 'OdCancel', n: '주문 취소 확인', states: [
    { l: '결제 완료 · 취소 가능', p: { v: 'paid' } },
    { l: '만드는 중 · 취소 불가', p: { v: 'making' } }] },
  { id: 'oc-02', comp: 'OdRefund', n: '주문 취소 · 환불 상태', states: [
    { l: '환불 진행 중', p: { v: 'ing' } },
    { l: '환불 완료', p: { v: 'done' } },
    { l: '환불 실패', p: { v: 'fail' } }] },
  { id: 'oc-03', comp: 'OdReject', n: '매장 거절 안내', states: [
    { l: '품절로 거절', p: { v: 'soldout' } },
    { l: '영업 마감으로 거절', p: { v: 'closed' } }] },

  /* ── T 예약 결제 예외 (v1 신규 · 흐름 완성) ── */
  { id: 'rp-01', comp: 'RsvPayFail', n: '예약 결제 실패', states: [
    { l: '카드 승인 거절', p: { v: 'card' } },
    { l: '결제 중 좌석 마감', p: { v: 'seat' } }] },
  { id: 'rp-02', comp: 'RsvUnavail', n: '예약 불가 안내', states: [
    { l: '예약 마감', p: { v: 'full' } },
    { l: '선택한 테이블 마감', p: { v: 'table' } }] },
];
window.NF_ROW = (id) => window.NF_SPECS.find((r) => r.id === id);
