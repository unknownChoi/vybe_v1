/* global React, ReactDOM, cx, PassWallet, ResvDetail, QrFull, MyReview, ReviewEdit, BookingForm, Terms, BookingDone, Payment, MenuList, MenuDetail, Cart */
const { useState: apS, useEffect: apE, useRef: apR } = React;
const H = { pw_03_frame_2480: [202, 168], pw_10_booking_modal: [786, 954], rs_02_due_selector: [786, 1340], rs_03_due_selector: [786, 1340], rs_04_card_selector: [786, 1532], rs_05_card_selector: [786, 1532] };
const DLG = ['pw_04_cancel_waiting_success', 'pw_05_remove_history_success', 'pw_06_cancel_waiting', 'pw_07_cancel_waiting', 'pw_08_remove_history', 'pw_09_remove_payment_history', 'pw_17_cancel_reservation_success', 'pw_18_cancel_waiting_success', 'pw_19_postpone_waiting_success', 'pw_20_cancel_reservation', 'pw_21_cancel_waiting', 'pw_22_postpone_waiting', 'pw_23_postpone_waiting'];
const v = (img, label, el) => ({ img, label, el });

const FEATURES = [
  { id: 'pw', name: 'Pass Wallet', sub: '입장권 · 예약 · 이용 내역을 한 지갑에서 — 02_passwallet', rows: [
    { id: 'pw-01', t: '입장권 탭 · 빈 상태', d: '진행 중인 웨이팅이 없을 때', vs: [v('pw_27_no_data', '빈 상태', <PassWallet tab="ticket" wait={null} />)],
      n: [['cp', '상단 Segment 탭을 VybeSegment(글래스 · 건수 pill)로 교체. 0건 탭은 pill을 그리지 않는다.'], ['ux', '“찾아보세요” 안내만 있던 빈 상태에 행동 버튼(주변 클럽 보기)을 붙였다.'], ['cp', '하단 탭을 v2 플로팅 탭바로 교체 — 중앙 패스월렛이 라임으로 고정된다.'], ['mo', '추천 클럽 카드가 45ms 간격으로 순차 등장(VybeFadeInUp).']],
      c: ['VybeSegment', 'VybeGlassSurface.quiet', 'VybeMetaDot', 'TabBar v2'], tr: '상단 탭(입장권·예약·이용 내역)을 눌러 보세요. 썸 인디케이터가 미끄러지며 이동합니다.' },
    { id: 'pw-02', t: '예약 탭 · 예약 티켓', d: '예약 1건일 때 전체 티켓', vs: [v('pw_01_reservation', '예약 확정', <PassWallet tab="resv" resvState="confirmed" />), v(null, '접수됨', <PassWallet tab="resv" resvState="pending" />), v(null, '오늘 예약', <PassWallet tab="resv" resvState="today" />)],
      n: [['cl', '“예약 완료” 한 가지였던 상태를 상태→색 매핑으로 분리: 접수됨(앰버) · 예약 확정(퍼플) · 오늘 예약(라임 + 글로우).'], ['cp', '모든 패스월렛 티켓은 같은 300px 카드(개수와 무관, 1장이어도 중앙 정렬). VybeTicketCard 규격 — 헤더 96 · 노치 절취선 · 스탯 3분할 · QR 슬롯 256 고정(상태가 바뀌어도 높이 불변).'], ['ux', '예약 취소는 밑줄 텍스트 버튼으로 낮추고 주 버튼은 “예약 변경하기” 하나로.'], ['ux', '스탯을 누르면 예약 상세로 이동한다.']],
      c: ['VybeTicketCard', 'VybeStatusBadge', 'VybePassQr'], tr: '오른쪽 상태 칩으로 접수됨 → 예약 확정 → 오늘 예약 전이를 비교하세요. 헤더 색과 QR 잠금이 320ms로 바뀝니다.' },
    { id: 'pw-03', t: '예약 탭 · 예약 목록', d: '예약이 여러 건일 때', vs: [v('pw_25_reservation_list', '목록', <PassWallet tab="resv" resv="list" />), v('pw_08_remove_history', '내역 삭제 확인', <PassWallet tab="resv" resv="list" overlay="delResv" />), v('pw_05_remove_history_success', '삭제 완료', <PassWallet tab="resv" resv="list" />)],
      n: [['cl', '“수락 대기중”을 v2 시맨틱 “접수됨”(amber500)으로. 취소된 예약은 채도 0 + quiet 카드로 물러난다.'], ['ux', '카드 전체가 티켓으로 들어가는 터치 영역. 목록 ↔ 티켓을 한 탭 안에서 오간다.'], ['ux', '“삭제 완료” 팝업을 없애고 VybeToast로 대체 — 확인 탭 한 번이 줄었다.'], ['mo', '삭제된 카드는 왼쪽으로 빠지며 사라진다(300ms).']],
      c: ['GlassCard', 'VybeStatusBadge', 'Dialog', 'VybeToast'], tr: '맨 아래 취소된 예약의 “내역 삭제”를 눌러 보세요.' },
    { id: 'pw-04', t: '이용 내역', d: '지난 웨이팅·예약과 후기', vs: [v('pw_13_history', '후기 요청 포함', <PassWallet tab="hist" />), v('pw_12_history', '후기 요청 없음', <PassWallet tab="hist" hist="short" />)],
      n: [['cp', '지난 이력은 물러난 카드(VybeGlassSurface.quiet)로 톤을 낮췄다.'], ['ux', '후기 요청 박스의 별을 바로 눌러 점수를 먼저 남기고, 이어서 작성으로 넘어간다.'], ['cl', '만료 안내는 비활성 텍스트(gray500) 한 줄로 정리.'], ['ux', '카드를 누르면 결제 상세 바텀시트가 열린다.']],
      c: ['VybeGlassSurface.quiet', 'Stars', 'Sheet'], tr: '첫 카드의 별을 눌러 보세요(왼쪽 반 = 0.5점).' },
    { id: 'pw-05', t: '결제 내역 시트 · 삭제', d: '이용 내역 카드를 눌렀을 때', vs: [v('pw_10_booking_modal', '결제 상세', <PassWallet tab="hist" overlay="histSheet" />), v('pw_09_remove_payment_history', '삭제 확인', <PassWallet tab="hist" overlay="histDel" />), v('pw_04_cancel_waiting_success', '삭제 완료', <PassWallet tab="hist" overlay="histDone" />)],
      n: [['cp', '모달을 바텀시트(핸들 · 22/26 라운드 · surface 92% 글래스)로. 핸들을 끌어내려 닫을 수 있다.'], ['cl', 'red500은 오류 전용 — 빨간 “내역 삭제” 텍스트를 중립 타일 버튼으로 바꾸고 경고는 다이얼로그가 맡는다.'], ['ux', '같은 문장을 두 번 쓰던 확인 문구를 한 줄로 줄였다.'], ['mo', '시트 420ms 슬라이드 업(cubic-bezier .32,.72,0,1) · 다이얼로그 스케일 .92→1.']],
      c: ['Sheet', 'Dialog', 'VybeToast', 'GlassCard'], tr: '시트 상단 핸들을 아래로 끌어 보세요.' },
    { id: 'pw-06', t: '예약 상세', d: '인원·좌석·결제 3개 화면을 1개로', vs: [v('pw_14_purchase_success', '인원', <ResvDetail anchor="people" />), v('pw_15_purchase_success', '좌석', <ResvDetail anchor="seat" />), v('pw_16_purchase_success', '결제', <ResvDetail anchor="pay" />)],
      n: [['ux', '스탯마다 따로 있던 상세 3화면을 한 스크롤로 합쳤다. 누른 스탯 위치로 바로 스크롤된다.'], ['cp', 'RS-08 예약 타임라인(VybeStepIndicator)으로 지금 단계를 먼저 보여준다.'], ['cl', '배치도 등급색: 테이블 라임 → blue500. 라임은 “선택”에만 쓴다.'], ['cp', '지그재그 영수증을 GlassCard + 금액 28 Bold로 정리.']],
      c: ['VybeStepIndicator', 'FloorPlan', 'GlassCard', 'VybeButton'], tr: 'Before 칩(인원·좌석·결제)을 누르면 After가 해당 섹션으로 스크롤됩니다.' },
    { id: 'pw-07', t: '입장 QR 전체 화면', d: '티켓의 QR을 크게', vs: [v('pw_24_qr_overlay', '유효', <QrFull />), v(null, '60초 미만', <QrFull start={45} />), v(null, '만료', <QrFull start={3} />)],
      n: [['cp', '흰 화면 전체 대신 QR 코드 영역만 흰 배경(r10 · 여백 8 · QR 224). 카드·주변은 다크 유지.'], ['ux', '남은 시간 mm:ss와 ↻ 새로 받기(10초 제한) · 만료 오버레이를 추가.'], ['cl', '60초 미만이면 타이머가 red700으로 바뀐다(오류 계열 규칙).'], ['mo', '↻ 180° 회전 + QR 크로스페이드 240ms.']],
      c: ['VybePassQr', 'VybeInlineBanner', 'VybeFooterNote'], tr: '“만료” 칩을 누르고 3초 뒤 ↻를 눌러 새 QR을 받아 보세요.' },
    { id: 'pw-08', t: '내가 쓴 리뷰', d: '더보기 메뉴 · 삭제', vs: [v('pw_11_history', '리뷰', <MyReview />), v('pw_03_frame_2480', '더보기 메뉴', <MyReview menu />), v('pw_07_cancel_waiting', '삭제 확인', <MyReview del />)],
      n: [['cp', '⋮ 아이콘을 40 글래스 원형 버튼으로 — 터치 영역 확보.'], ['cp', '더보기 메뉴를 VybeSelectItem 팝오버로. 우상단 기준으로 스케일 인.'], ['ux', '사진은 가로 스와이프(스냅) + 페이지 pill.'], ['cl', '별점은 라임, 빈 별은 gray700.']],
      c: ['VybeGlassButton', 'VybeSelectItem', 'Dialog', 'VybeMetaDot'], tr: '사진을 옆으로 넘기고, ⋮ → 삭제하기를 눌러 보세요.' },
    { id: 'pw-09', t: '리뷰 수정', d: '별점 · 본문 · 사진', vs: [v('pw_02_review_edit', '수정', <ReviewEdit />), v('pw_06_cancel_waiting', '등록 완료', <ReviewEdit done />)],
      n: [['cp', '박스형 textarea를 하단 라인 VybeTextField로. 포커스 시 라인이 purple500.'], ['ux', '별점은 0.5 단위로 탭. 비어 있으면 제출 버튼 위에 사유 1줄 caption.'], ['ux', '“리뷰 등록” 완료 팝업을 토스트로 대체.'], ['mo', '별 탭 시 스프링 팝(260ms) · 제출 중 VybeSpinner.']],
      c: ['VybeTextField', 'VybeButton', 'VybeFooterNote', 'VybeSpinner', 'VybeToast'], tr: '본문을 지워 보면 버튼이 비활성으로 바뀌고 사유가 나타납니다.' },
  ] },
  { id: 'wt', name: '비대면 웨이팅', sub: '웨이팅 티켓 · 순서 미루기 · 취소 — 02_passwallet', rows: [
    { id: 'wt-01', t: '웨이팅 티켓', d: '대기 중 → 입장 순서 → 입장 완료', vs: [v('pw_28_waiting_before', '대기 중', <PassWallet wait="waiting" />), v(null, '입장 순서', <PassWallet wait="called" />), v('pw_26_waiting_after', '입장 완료', <PassWallet wait="entered" />), v(null, '입장 시간 지남', <PassWallet wait="expired" />)],
      n: [['ux', '대기 중에는 QR을 블러로 가리고 “입장 순서가 되면 QR이 표시돼요”를 띄운다. 호출되면 블러가 걷히며 QR이 열린다. Before는 대기 중에도 QR이 보였다.'], ['cl', '호출됨은 라임 헤더 + 1.2s 글로우 펄스. 입장 완료는 재입장에 계속 쓰는 유효 티켓이라 퍼플→라임 네온 헤더 + 네온 상단 라인으로, 채도 0인 종료(취소·시간 지남) 티켓과 구분한다.'], ['cp', '입장 완료 티켓에서 바로 주문하기(비대면 주문) · 후기 작성으로 이어진다.'], ['mo', '스탬프 scale 1.3→1(240ms) · 탭바 패스월렛에 라임 점 펄스.'], ['mo', '여러 클럽 입장권을 가로 덱으로 모은다 — 스냅 스와이프 · 옆 카드는 3D 기울기와 축소 · 라임 인디케이터가 늘어난다.']],
      c: ['VybeTicketCard', 'VybeStamp', 'VybePassQr', 'VybeStatusBadge', 'TabBar v2'], tr: '입장권을 좌우로 넘겨 다른 클럽 티켓을 보세요(옆 카드를 눌러도 이동). 상태 칩으로 첫 티켓의 전이를 확인할 수 있습니다.' },
    { id: 'wt-02', t: '순서 미루기', d: '대기 맨 뒤로 순서 넘기기', vs: [v('pw_22_postpone_waiting', '미루기 확인', <PassWallet wait="called" overlay="postpone" />), v('pw_23_postpone_waiting', '대기 중에서 미루기', <PassWallet wait="waiting" overlay="postpone" />), v('pw_19_postpone_waiting_success', '변경 완료', <PassWallet wait="waiting" back />)],
      n: [['ux', '몇 팀 뒤로 미룰지 고르는 대신 규칙을 하나로 — 미루면 대기 맨 뒤로 간다. 바뀔 대기 번호(5번 → 14번)와 앞에 남는 팀 수를 미리 보여준다.'], ['ux', 'CTA에 결과를 적는다: “맨 뒤로 미루기”. 되돌릴 수 없다는 점을 본문에서 먼저 알린다.'], ['ux', '완료 팝업 대신 토스트, 티켓은 제자리에서 갱신된다.'], ['mo', '확정하면 티켓 번호가 600ms easeOut으로 카운트업.']],
      c: ['Sheet', 'VybeTicketCard', 'VybeToast'], tr: '“맨 뒤로 미루기”를 누르고 티켓 번호가 맨 뒤로 올라가는 것을 보세요.' },
    { id: 'wt-03', t: '웨이팅 취소', d: '되돌릴 수 없는 결정', vs: [v('pw_21_cancel_waiting', '취소 확인', <PassWallet wait="waiting" overlay="cancelWait" />), v('pw_18_cancel_waiting_success', '취소 완료', <PassWallet wait="canceled" />)],
      n: [['ux', '“취소 / 확인”의 모호함을 없앴다 — “돌아가기 / 웨이팅 취소하기”.'], ['cl', '취소된 티켓은 red가 아닌 채도 0 + gray 배지(종료 상태).'], ['ux', '완료 팝업 대신 토스트, 티켓은 제자리에서 종료 상태로 바뀐다.'], ['mo', '다이얼로그 페이드 + 스케일 .92→1 (280ms spring).']],
      c: ['Dialog', 'VybeTicketCard', 'VybeToast'], tr: '“웨이팅 취소하기”를 눌러 티켓이 종료 상태로 바뀌는 것을 보세요.' },
  ] },
  { id: 'rs', name: '테이블 예약', sub: '예약 정보 · 결제 · 완료 · 취소 — 01_booking', rows: [
    { id: 'rs-01', t: '예약 정보 입력', d: '날짜·인원·테이블·시간·사전 주문', vs: [v('rs_01_booking', '기본', <BookingForm />), v('rs_15_booking', '기본(동일)', <BookingForm />), v('rs_20_booking', '입력 완료', <BookingForm filled />), v('rs_22_booking', '펼침 · 빈 값', <BookingForm open="date" />), v('rs_21_booking', '펼침 · 입력', <BookingForm filled open="people" />)],
      n: [['cp', '박스 입력창 → 하단 라인 VybeTextField. 연락처 자동 하이픈 · 잘못되면 red 라인 + 메시지.'], ['ux', '아코디언을 글래스 카드로 나누고, 고르면 다음 단계가 자동으로 열린다. 완료된 단계에는 라임 체크.'], ['cp', 'VybeCalendar · 대형 VybeStepper · 배치도(예약 완료 = 빗금) · VybeSlotChips · VybeGauge(최소 주문).'], ['ux', 'Disabled 결제 버튼 위에 빠진 항목 1줄 안내, 다 채우면 “545,500원 결제하기”.']],
      c: ['VybeTextField', 'VybeCalendar', 'VybeStepper', 'FloorPlan', 'VybeSlotChips', 'VybeGauge', 'VybeButton'], tr: '“기본”에서 이름·연락처를 입력하고 날짜를 고르면 다음 단계가 열립니다. 3명일 때 룸(R)을 눌러 보세요.' },
    { id: 'rs-03', t: '결제', d: '예약 확인 · 결제 수단 · 약관', vs: [v('rs_19_purchase', '수단 미선택', <Payment />), v('rs_16_purchase', '네이버페이', <Payment method="naver" terms={[1, 1, 1, 1]} />), v('rs_17_purchase', '신용카드 · 신한', <Payment method="card" card="신한" inst="3개월 (무이자)" terms={[1, 1, 1, 0]} />), v('rs_18_purchase', '카드사 미선택', <Payment method="card" />)],
      n: [['cp', '결제 수단을 VybeAmountTile로 — 선택은 라임 2px 테두리. 중복된 “휴대폰 결제” 타일을 정리.'], ['ux', '카드사·할부는 신용카드를 골랐을 때만 펼친다(아코디언). 입력은 하단 라인 드롭다운.'], ['cp', '약관을 VybeTermsList로: 필수는 라임, 선택은 gray.'], ['ux', '버튼 위에 막힌 이유를 1줄로, 결제 중에는 스피너 + “결제를 확인하고 있어요” 앰버 배너.']],
      c: ['VybeAmountTile', 'VybeDropdown', 'VybeTermsList', 'VybeInlineBanner', 'VybeSpinner'], tr: '신용카드 → 카드사 선택 → 필수 약관 동의 순서로 버튼이 활성화됩니다.' },
    { id: 'rs-04', t: '카드사 · 할부 선택', d: '결제 화면 위 바텀시트', vs: [v('rs_04_card_selector', '카드사', <Payment method="card" sheet="card" />), v('rs_05_card_selector', '카드사 선택됨', <Payment method="card" card="신한" sheet="card" />), v('rs_02_due_selector', '할부 선택됨', <Payment method="card" card="신한" inst="3개월 (무이자)" sheet="inst" />), v('rs_03_due_selector', '할부', <Payment method="card" card="신한" inst={null} sheet="inst" />)],
      n: [['cp', 'VybeSelectItem 목록 — 선택 항목은 퍼플 틴트 + 라임 체크.'], ['ux', '고르면 220ms 뒤 시트가 자동으로 닫히고 필드가 채워진다.'], ['ux', '긴 목록은 시트 안에서만 스크롤, 배경 화면은 고정.'], ['mo', '스크림 페이드 + 시트 슬라이드 업/다운, 핸들 드래그로 닫기.']],
      c: ['Sheet', 'VybeSelectItem', 'VybeDropdown'], tr: '카드사를 고르면 시트가 내려가며 값이 채워집니다.' },
    { id: 'rs-05', t: '개인정보 이용 약관', d: '약관 전문', vs: [v('rs_06_agency_selected', '약관', <Terms />)],
      n: [['cl', '조항 제목은 tagline(Bold 14 / lh 24), 본문은 caption(12 / lh 24).'], ['ux', '상단 진행 바로 얼마나 읽었는지 보여준다.'], ['ux', '약관 문구는 VYBE 기준 예시로 교체(원본은 타사 약관).'], ['cp', '스크롤하면 앱바가 글래스로 바뀐다.']],
      c: ['VybeGlassHeader', 'Typography'], tr: '스크롤하면 상단 진행 바가 차오릅니다.' },
    { id: 'rs-06', t: '예약 완료', d: '결제 직후', vs: [v('rs_07_purchase_success', '접수됨', <BookingDone />), v(null, '매장 확정', <BookingDone st="confirmed" />)],
      n: [['cl', '결제 직후 예약은 매장 확인 전이므로 “접수됨”(amber) 티켓으로 보여준다. 매장이 확인하면 퍼플.'], ['ux', '문구를 상태에 맞췄다: “완료되었습니다” → “접수되었어요 · 확인되면 알려드릴게요”.'], ['ux', '다음 행동 “패스월렛에서 보기”를 주 버튼으로.'], ['mo', '체크 원 스프링 등장 → 체크 선 그리기 → 티켓 순차 등장.']],
      c: ['VybeTicketCard', 'VybeStatusBadge', 'VybeButton'], tr: '“매장 확정” 칩으로 앰버 → 퍼플 헤더 전이를 보세요.' },
    { id: 'rs-07', t: '예약 취소', d: '패스월렛 예약 티켓에서', vs: [v('pw_20_cancel_reservation', '취소 확인', <PassWallet tab="resv" overlay="cancelResv" />), v('pw_17_cancel_reservation_success', '취소 완료', <PassWallet tab="resv" resvState="canceled" />)],
      n: [['ux', '버튼 라벨을 결과로: “돌아가기 / 예약 취소하기”.'], ['cl', '취소된 티켓은 채도 0 + “취소됨” gray 배지. 남은 행동은 내역 삭제 하나.'], ['ux', '완료 팝업 → 토스트.'], ['mo', '티켓 필터 전이 320ms.']],
      c: ['Dialog', 'VybeTicketCard', 'VybeToast'], tr: '“예약 취소하기”를 누르면 티켓이 제자리에서 종료 상태로 바뀝니다.' },
  ] },
  { id: 'od', name: '비대면 주문', sub: '메뉴 · 옵션 · 장바구니 — 01_booking/03_cart_order', rows: [
    { id: 'od-01', t: '메뉴 목록', d: '카테고리 · 담기', vs: [v('rs_12_booking_none', '비어 있음', <MenuList />), v('rs_11_booking_added', '1개 담김', <MenuList cart={{ hardA: 1 }} />)],
      n: [['cp', '메뉴 행을 OD-01 규격으로 — 썸네일 72 · 라임 ⊕ 32. 사진 없는 메뉴도 같은 썸네일 자리를 채운다.'], ['ux', '카테고리 칩이 상단에 고정되고, 스크롤 위치에 따라 활성 칩이 바뀐다(스크롤 스파이).'], ['ux', '하단 2버튼을 글래스 장바구니 pill 하나로. 0개면 그리지 않는다.'], ['mo', 'pill 스프링 등장 · 담을 때 수량 배지 팝.']],
      c: ['MenuRow', 'CartPill', 'VybeSlotChips', 'VybeFooterNote'], tr: '⊕를 여러 번 눌러 보고, 칩으로 섹션을 이동해 보세요.' },
    { id: 'od-02', t: '메뉴 상세', d: '수량 · 추가 옵션', vs: [v('rs_10_order_detail', '옵션 없음', <MenuDetail />), v('rs_08_order_detail', '옵션 선택', <MenuDetail opts={[true, false, false]} />)],
      n: [['cp', '회색 띠 위 흰 사진 → 오로라 배경 위 r19 카드. 뒤로·공유는 글래스 원형 버튼.'], ['cp', '수량 VybeStepper(하한 − 비활성), 옵션 VybeCheckbox.'], ['ux', '금액 CTA 규칙 그대로: 옵션·수량에 따라 “225,500원 담기”가 즉시 갱신.'], ['mo', '담기 후 버튼이 “담았어요” 체크로 바뀐다.']],
      c: ['VybeGlassButton', 'VybeStepper', 'VybeCheckbox', 'VybeButton'], tr: '수량과 옵션을 바꾸며 버튼 금액을 보세요.' },
    { id: 'od-03', t: '장바구니', d: '담은 메뉴 · 최소 주문', vs: [v('rs_09_cart', '장바구니', <Cart />)],
      n: [['cp', '최소 주문 VybeGauge를 맨 위에 — 채우면 라임 + ✓.'], ['ux', '“옵션 변경”은 바텀시트에서 바로 수정. 항목별 × 삭제.'], ['ux', '“더 담으러 가기”는 보조 버튼으로 내리고, 주 버튼은 “545,500원 예약에 담기”.'], ['ux', '최소 금액 미만이면 비활성 + 사유 1줄.']],
      c: ['VybeGauge', 'VybeStepper', 'Sheet', 'VybeCheckbox', 'VybeButton'], tr: '항목을 × 로 지워 최소 주문 미만이 되면 버튼이 막힙니다.' },
  ] },
];
const KL = { ux: 'UX', cp: '컴포넌트', mo: '모션', cl: '컬러·타이포' };

function Before({ img }) {
  const hw = H[img]; const dlg = DLG.includes(img); const crop = dlg || !!hw;
  return <div className={cx('nf-bf', crop && 'crop')}><div className="sc"><img src={`assets/new_func/${img}.png`} alt={img} loading="lazy" style={dlg ? { width: 353 } : hw && hw[0] < 400 ? { width: hw[0] } : null} /></div></div>;
}
function Row({ r }) {
  const [i, setI] = apS(0); const [k, setK] = apS(0);
  const [bi, setBi] = apS(0);
  const pickV = (j) => { setI(j); setK((x) => x + 1); if (r.vs[j].img) setBi(j); };
  const bvs = r.vs.map((x, j) => [x, j]).filter(([x]) => x.img);
  return <article className="nf-row" id={r.id} data-screen-label={r.id.toUpperCase()}>
    <div className="nf-rh"><span className="nf-id">{r.id.toUpperCase()}</span><span className="nf-rt">{r.t}</span><span className="nf-rd">{r.d}</span></div>
    <div className="nf-cols">
      <div><div className="nf-ch"><span className="nf-lbl">Before</span>{bvs.length > 1 && bvs.map(([x, j]) => <button key={j} className={cx('nf-vc', bi === j && 'on')} onClick={() => pickV(j)}><code>{x.img.slice(0, 5)}</code>{x.label}</button>)}</div>
        <Before img={r.vs[bi].img} /><div className="nf-bfn">{r.vs[bi].img}.png</div></div>
      <div><div className="nf-ch"><span className="nf-lbl after">After</span>{r.vs.length > 1 && r.vs.map((x, j) => <button key={j} className={cx('nf-vc', i === j && 'on')} onClick={() => pickV(j)}>{x.label}</button>)}
        <button className="nf-vc" style={{ marginLeft: 'auto' }} onClick={() => setK((x) => x + 1)} title="처음 상태로">↺</button></div>
        <div key={k}>{r.vs[i].el}</div><div className="nf-bfn" style={{ color: 'var(--lime900)' }}>DS v2.0 · 393 × 852</div></div>
      <div className="nf-notes"><div className="nf-nh">개선 포인트</div>
        <ol className="nf-ol">{r.n.map(([c, t], j) => <li key={j}><b className={'k-' + c}>{KL[c]}</b><span>{t}</span></li>)}</ol>
        <div className="nf-nh">사용 컴포넌트</div><div className="nf-comp">{r.c.map((c) => <code key={c}>{c}</code>)}</div>
        <div className="nf-try"><b>해보기</b><span>{r.tr}</span></div></div>
    </div></article>;
}
function App() {
  const [on, setOn] = apS('pw');
  apE(() => {
    const go = (e) => { const el = document.getElementById(e.detail); if (!el) return; window.scrollTo({ top: el.getBoundingClientRect().top + window.scrollY - 60, behavior: 'smooth' }); el.classList.remove('flash'); void el.offsetWidth; el.classList.add('flash'); };
    window.addEventListener('nf-go', go);
    const io = new IntersectionObserver((es) => es.forEach((x) => x.isIntersecting && setOn(x.target.id)), { rootMargin: '-20% 0px -70% 0px' });
    FEATURES.forEach((f) => io.observe(document.getElementById(f.id)));
    return () => { window.removeEventListener('nf-go', go); io.disconnect(); };
  }, []);
  const nB = FEATURES.reduce((a, f) => a + f.rows.reduce((b, r) => b + r.vs.filter((x) => x.img).length, 0), 0);
  const nA = FEATURES.reduce((a, f) => a + f.rows.length, 0);
  return <div className="nf-wrap">
    <header className="nf-hero"><div className="nf-brand"><b>VYBE<span>.</span></b>신규 기능 리뉴얼 · Design System v2.0</div>
      <h1 className="nf-h1">신규 기능 4종 <em>UI 리뉴얼</em></h1>
      <p className="nf-lede">베타 예시 스크린샷 {nB}장(Before)을 디자인 시스템 v2.0 규격으로 다시 만든 {nA}개 화면(After)과 나란히 놓았습니다. After는 실제로 눌러 볼 수 있고, Before 칩을 누르면 After도 같은 상태로 맞춰집니다. 화면 안의 이동 버튼은 해당 비교 행으로 스크롤합니다.</p>
      <div className="nf-rules">
        <div className="it"><b>상태 → 색 매핑</b><span>대기·진행 퍼플 · 지금 행동 라임 · 확인 대기 앰버 · 완료 gray · 종료 채도 0. 라임은 버튼 채움에 쓰지 않고, red는 오류에만.</span></div>
        <div className="it"><b>피드백 3단계</b><span>고르고 입력하는 일은 바텀시트, 되돌릴 수 없는 결정은 다이얼로그, 완료 알림은 토스트. 완료 팝업 7종을 없앴다.</span></div>
        <div className="it"><b>입력 · CTA</b><span>박스 입력 → 하단 라인 VybeTextField. 금액 CTA에는 금액을 넣고, Disabled 버튼 위에는 사유 1줄.</span></div>
        <div className="it"><b>고정 영역 · 모션</b><span>앱바·하단 CTA·탭바는 고정, 콘텐츠만 스크롤. 버튼 100ms 눌림 · 시트 420ms · 상태 전이 320ms.</span></div>
      </div>
      <nav className="nf-nav">{FEATURES.map((f) => <a key={f.id} href={'#' + f.id} className={cx(on === f.id && 'on')} onClick={(e) => { e.preventDefault(); window.dispatchEvent(new CustomEvent('nf-go', { detail: f.id })); }}>{f.name}<i>{f.rows.length}</i></a>)}</nav>
    </header>
    {FEATURES.map((f) => <section key={f.id} id={f.id} className="nf-sec"><h2 className="nf-h2">{f.name}</h2><p className="nf-h2sub">{f.sub}</p>{f.rows.map((r) => <Row key={r.id} r={r} />)}</section>)}
  </div>;
}
ReactDOM.createRoot(document.getElementById('root')).render(<App />);
