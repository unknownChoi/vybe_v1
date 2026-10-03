/* global React, cx, won, Icon, Phone, AppBar, Bottom, Badge, Dialog, goRow, RkNotice, RkAmt, RkStep3, OCLUB, OTOTAL, OCNT, OLineRows, RK_CLUB, RK_WHEN, RK_SEAT */
/* VYBE v1 — 흐름 완성 보강 화면 (ORDER-104~106 · RSV-107~108)
   기존 화면과 같은 컴포넌트(Phone · AppBar · Bottom · RkNotice · RkAmt · RkStep3)와
   디자인 시스템 v2 토큰만 사용한다. 금액은 기존 화면 값을 그대로 가져온다. */
const { useState: gpS } = React;
const GP_NO = '017';
const GP_METHOD = '신용카드 · 신한';
const GP_WHEN = '07월 04일 (금) 오후 9:12';

/* ORDER-104 · 주문 취소 확인 — 결제 완료 상태에서만 취소 · 조리 시작 후에는 취소 불가 */
function OdCancel({ v = 'paid' }) {
  const [ov, setOv] = gpS(false);
  if (v === 'making') {
    return <div id="ORDER-104-1" data-screen-id="ORDER-104-1" data-screen-label="ORDER-104-1">
      <RkNotice bar="주문 취소" icon="info" tone="gray" title={<>지금은 주문을<br />취소할 수 없어요</>}
        desc={<>매장이 이미 만들기를 시작했어요. 조리가 시작된 뒤에는 취소와 환불이 되지 않아요.</>}
        rows={[['주문 번호', GP_NO], ['주문 상태', '만드는 중'], ['결제 금액', won(OTOTAL) + '원']]}
        bullets={['픽업이 어려우면 매장에 직접 문의해 주세요.', '픽업하지 않은 주문도 환불되지 않아요.']}
        actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('od-06')}>주문 상태</button>
          <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('file:[v1]CLUB-021.html')}>매장에 문의</button></>} />
    </div>;
  }
  return <div id="ORDER-104" data-screen-id="ORDER-104" data-screen-label="ORDER-104">
    <Phone bd="ambient" botH={128} top={<AppBar title="주문 취소" />}
      bottom={<Bottom cap="취소하면 되돌릴 수 없어요"><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('od-06')}>돌아가기</button>
        <button className="vb" style={{ flex: 1.4 }} onClick={() => setOv(true)}>취소하기</button></Bottom>}
      overlay={<Dialog open={ov} onClose={() => setOv(false)} title={<>주문을 정말<br />취소하시겠어요?</>} desc="한 번 취소하면 되돌릴 수 없어요. 결제한 금액은 전액 환불돼요."
        actions={<><button className="btn s" onClick={() => setOv(false)}>돌아가기</button>
          <button className="btn p" onClick={() => { setOv(false); goRow('oc-02'); }}>취소하고 환불받기</button></>}>
        <div className="gcard" style={{ padding: '4px 16px' }}>
          <div className="kv"><span>환불 금액</span><b className="cl">{won(OTOTAL)}원 (전액)</b></div>
          <div className="kv"><span>환불 수단</span><b>{GP_METHOD}</b></div></div></Dialog>}>
      <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
        <div className="ibn amber"><i />결제 완료 구간이라 전액 환불돼요</div>
        <div className="gcard" style={{ padding: '4px 16px' }}>
          {[['매장', OCLUB], ['주문 번호', GP_NO], ['주문 시각', GP_WHEN], ['주문 메뉴', OCNT + '개']].map(([a, b]) => <div className="kv" key={a}><span>{a}</span><b>{b}</b></div>)}</div>
        <RkAmt label="환불 내역" rows={[['결제 금액', won(OTOTAL) + '원'], ['취소 수수료', '없음'], ['결제 수단', GP_METHOD]]} total={won(OTOTAL) + '원'} tone="ok" />
        <div className="fnote"><Icon n="info" s={16} /><span>매장이 만들기를 시작하면 취소할 수 없어요. 환불은 영업일 3~5일 이내에 결제 수단으로 처리돼요.</span></div>
      </div></Phone></div>;
}

/* ORDER-105 · 주문 취소 · 환불 상태 (진행 중 · 완료 · 실패) */
function OdRefund({ v = 'ing' }) {
  const D = {
    ing: { b: <Badge s="pending" dot>환불 진행 중</Badge>, t: '환불이 진행되고 있어요', c: 1 },
    done: { b: <Badge s="entered">환불 완료</Badge>, t: '환불이 완료됐어요', c: 2 },
    fail: { b: <Badge s="err">환불 실패</Badge>, t: '환불에 실패했어요', c: 1 },
  }[v];
  return <div id="ORDER-105" data-screen-id="ORDER-105" data-screen-label="ORDER-105">
    <Phone bd="ambient" top={<AppBar title="환불 상태" />} botH={102}
      bottom={<Bottom>{v === 'fail'
        ? <><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('oc-02')}>다시 시도</button><button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('file:[v1]MY-032.html')}>고객센터 문의</button></>
        : <button className="vb" onClick={() => goRow('od-11')}>확인</button>}</Bottom>}>
      <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24, minHeight: '100%', justifyContent: 'center' }}>
        <div className="gcard">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
            <div><div className="t-h4">{D.t}</div><div className="meta" style={{ marginTop: 8 }}>{OCLUB}<span className="d" />주문번호 {GP_NO}</div></div>{D.b}</div>
          <RkStep3 steps={['취소 접수', '환불 요청', '환불 완료']} cur={D.c} /></div>
        <RkAmt label="환불 내역" rows={[['결제 금액', won(OTOTAL) + '원'], ['취소 수수료', '없음'], ['결제 수단', GP_METHOD]]} total={won(OTOTAL) + '원'} tone={v === 'fail' ? 'no' : 'ok'} />
        {v === 'fail' ? <div className="fnote" style={{ borderColor: 'rgba(245,181,68,.4)' }}><Icon n="info" s={16} /><span>카드사 통신 오류로 환불이 완료되지 않았어요. 다시 시도하거나 고객센터로 문의해 주세요.</span></div>
          : <div className="fnote"><Icon n="info" s={16} /><span>환불은 취소 접수 후 영업일 3~5일 이내에 결제 수단으로 처리돼요.</span></div>}
      </div></Phone></div>;
}

/* ORDER-106 · 매장 거절 안내 — 품절 · 영업 마감 (결제 금액은 자동 환불) */
function OdReject({ v = 'soldout' }) {
  const D = v === 'closed'
    ? { r: '영업 마감', d: <>매장이 오늘 영업을 마감해 주문을 받지 못했어요.<br />결제한 금액은 전액 자동 환불돼요.</>, n: 'ORDER-106-1' }
    : { r: '메뉴 품절', d: <>주문한 메뉴가 품절돼 매장이 주문을 받지 못했어요.<br />결제한 금액은 전액 자동 환불돼요.</>, n: 'ORDER-106' };
  return <div id={D.n} data-screen-id={D.n} data-screen-label={D.n}>
    <RkNotice bar="주문 상태" icon="info" tone="amber" title={<>매장이 주문을<br />받지 못했어요</>} desc={D.d}
      rows={[['주문 번호', GP_NO], ['거절 사유', D.r], ['환불 금액', won(OTOTAL) + '원 (전액)']]}
      bullets={['환불은 영업일 3~5일 이내에 결제 수단으로 처리돼요.', '다른 메뉴로 다시 주문할 수 있어요.']}
      actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('od-01')}>메뉴 다시 보기</button>
        <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('oc-02')}>환불 상태 보기</button></>} />
  </div>;
}

/* RSV-107 · 예약 결제 실패 — 카드 승인 거절 · 결제 중 좌석 마감 */
function RsvPayFail({ v = 'card' }) {
  const seat = v === 'seat';
  const D = seat
    ? { t: <>결제하는 동안<br />좌석이 마감됐어요</>, d: <>다른 손님의 예약이 먼저 확정돼 선택한 좌석이 마감됐어요. 결제는 승인되지 않았어요.</>,
      rows: [['예약 일시', RK_WHEN], ['좌석', RK_SEAT], ['결제 상태', '승인 안 됨']],
      bl: ['결제가 승인되지 않아 별도 환불 절차는 없어요.', '다른 테이블이나 다른 날짜로 다시 예약할 수 있어요.'],
      a: <><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('rp-02#1')}>마감 안내</button>
        <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('rs-01')}>다른 테이블 선택</button></>, n: 'RSV-107-1' }
    : { t: <>결제가<br />완료되지 않았어요</>, d: <>카드사 승인이 거절됐어요 (코드 051). 다른 결제 수단으로 다시 시도해 주세요.</>,
      rows: [['예약 일시', RK_WHEN], ['좌석', RK_SEAT], ['결제 금액', '545,500원']],
      bl: ['결제가 승인되지 않아 예약은 접수되지 않았어요.', '좌석은 결제가 끝날 때까지 다른 손님도 선택할 수 있어요.'],
      a: <><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('file:[v1]CLUB-021.html')}>나가기</button>
        <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('rs-03')}>다시 결제하기</button></>, n: 'RSV-107' };
  return <div id={D.n} data-screen-id={D.n} data-screen-label={D.n}>
    <RkNotice bar="결제하기" icon={seat ? 'info' : 'close'} tone={seat ? 'amber' : 'gray'} title={D.t} desc={D.d} rows={D.rows} bullets={D.bl} actions={D.a} />
  </div>;
}

/* RSV-108 · 예약 불가 안내 — 예약 마감 · 선택한 테이블 마감 */
function RsvUnavail({ v = 'full' }) {
  const tb = v === 'table';
  const D = tb
    ? { t: <>선택한 테이블은<br />예약이 마감됐어요</>, d: <>테이블-4는 이 날짜에 예약이 모두 찼어요. 다른 테이블을 선택하면 같은 날짜로 예약할 수 있어요.</>,
      rows: [['매장', RK_CLUB], ['예약 일시', RK_WHEN], ['마감된 좌석', '테이블-4']],
      bl: ['남은 좌석은 예약 정보 입력 화면의 좌석도에서 확인할 수 있어요.', '원하는 좌석이 없으면 웨이팅으로 입장할 수 있어요.'], n: 'RSV-108-1' }
    : { t: <>이 날짜는<br />예약이 마감됐어요</>, d: <>07월 23일 (수)은 예약이 모두 찼어요. 다른 날짜를 선택하거나 웨이팅으로 입장할 수 있어요.</>,
      rows: [['매장', RK_CLUB], ['마감된 날짜', '07월 23일 (수)'], ['다음 예약 가능', '07월 24일 (목)']],
      bl: ['예약이 취소되면 좌석이 다시 열려요.', '웨이팅은 영업 시작 후 현장 대기로 입장해요.'], n: 'RSV-108' };
  return <div id={D.n} data-screen-id={D.n} data-screen-label={D.n}>
    <RkNotice bar="테이블 예약" icon="info" tone="amber" title={D.t} desc={D.d} rows={D.rows} bullets={D.bl}
      actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('wf-01')}>웨이팅 등록</button>
        <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('rs-01')}>{tb ? '다른 테이블 선택' : '다른 날짜 보기'}</button></>} />
  </div>;
}

Object.assign(window, { OdCancel, OdRefund, OdReject, RsvPayFail, RsvUnavail });
