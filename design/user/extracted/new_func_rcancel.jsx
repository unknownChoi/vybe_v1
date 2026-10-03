/* global React, cx, won, Icon, Phone, AppBar, Bottom, Badge, Dialog, StepI, Check, Stepper, useCountdown, mmss, RulesTabSheet, goRow */
/* VYBE v1 — 취소·변경 규정 반영 추가 화면 UI 시안 (R1~R17, R6 제외)
   금액은 규정 "적용 예시" 기준 — 테이블 30만 · 메뉴 70만 · 결제총액 100만 원.
   요율·패널티 금액은 rsv_rules.js 원문 값만 사용한다. */
const { useState: rcS } = React;
const RC_CLUB = '어썸레드';
const RC_WHEN = '07월 23일 (수) 오후 8:00';
const RC_SEAT = '테이블-4 · 3명';
const RC_PAY = 1000000;

const RSummary = ({ note, skip = [] }) => <div className="gcard" style={{ padding: '4px 16px' }}>
  {[['매장', RC_CLUB], ['예약 일시', RC_WHEN], ['좌석', RC_SEAT], ['결제 금액', won(RC_PAY) + '원']].filter(([a]) => !skip.includes(a)).map(([a, b]) => <div className="kv" key={a}><span>{a}</span><b>{b}</b></div>)}
  {note ? <div className="t-cap c4" style={{ lineHeight: '24px', padding: '4px 0 12px' }}>{note}</div> : null}</div>;

/* 금액 카드 — 패널티 항목과 최종 금액 */
function RAmt({ rows, label, total, tone = 'ok' }) {
  const C = { ok: 'var(--lime500)', part: 'var(--amber500)', no: 'var(--g500)' };
  return <div className="gcard">
    <div className="shead" style={{ marginBottom: 8 }}><span className="tt">{label}</span></div>
    {rows.map(([a, b, hi]) => <div className="kv" key={a} style={{ padding: '8px 0', fontSize: 14 }}><span>{a}</span><b style={{ fontSize: 14, color: hi ? 'var(--amber500)' : null }}>{b}</b></div>)}
    <div className="hr" style={{ margin: '12px 0' }} />
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
      <span className="t-b4 c2">{tone === 'no' ? '환불 금액' : '돌려받는 금액'}</span>
      <b style={{ font: '700 24px var(--f)', letterSpacing: '-.6px', color: C[tone] }}>{total}</b></div></div>;
}
/* 안내형 화면 — 취소 불가 · 변경 불가 · 매장 취소 · 공유 삭제 */
function RNotice({ title, bar, icon = 'info', tone = 'amber', desc, rows, bullets, actions }) {
  const C = { amber: ['rgba(245,181,68,.14)', 'rgba(245,181,68,.4)', 'var(--amber500)'], lime: ['rgba(181,255,96,.14)', 'rgba(181,255,96,.34)', 'var(--lime500)'], gray: ['rgba(255,255,255,.06)', 'var(--hair)', 'var(--g400)'] }[tone];
  return <Phone bd="ambient" top={<AppBar title={bar} />} botH={102} bottom={<Bottom>{actions}</Bottom>}>
    <div className="pad stack" style={{ gap: 16, paddingTop: 20, paddingBottom: 24, minHeight: '100%', justifyContent: 'center' }}>
      <div style={{ width: 64, height: 64, borderRadius: 99, background: C[0], border: `1px solid ${C[1]}`, color: C[2], display: 'grid', placeItems: 'center', margin: '0 auto' }}><Icon n={icon} s={30} sw={1.7} /></div>
      <div className="t-h3" style={{ textAlign: 'center', textWrap: 'balance' }}>{title}</div>
      <div className="t-b4 c3" style={{ textAlign: 'center', lineHeight: 1.65, textWrap: 'pretty' }}>{desc}</div>
      {rows ? <div className="gcard" style={{ padding: '4px 16px' }}>{rows.map(([a, b]) => <div className="kv" key={a}><span>{a}</span><b>{b}</b></div>)}</div> : null}
      {bullets ? <div className="fnote"><Icon n="info" s={16} /><div><ul>{bullets.map((t) => <li key={t}>· {t}</li>)}</ul></div></div> : null}
    </div></Phone>;
}
/* 팝업형 화면 — 예약 요약 위에 다이얼로그 */
function RDlg({ bar = '예약 상세', title, desc, children, actions }) {
  return <Phone bd="ambient" top={<AppBar title={bar} />} botH={102}
    bottom={<Bottom><button className="vb s" style={{ flex: 1 }}>예약 취소하기</button><button className="vb" style={{ flex: 1 }}>예약 변경하기</button></Bottom>}
    overlay={<Dialog open title={title} desc={desc} actions={actions}>{children}</Dialog>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <RSummary />
      <div className="gcard">
        <div className="shead"><span className="tt">주문 내역</span><Badge s="entered">결제 완료</Badge></div>
        {[['테이블-4 · 3명', '300,000원'], ['HARD SET A', '500,000원'], ['샴페인 1병', '200,000원']].map(([a, b]) => <div className="kv" key={a} style={{ padding: '8px 0', fontSize: 14 }}><span>{a}</span><b style={{ fontSize: 14 }}>{b}</b></div>)}
        <div className="hr" style={{ margin: '12px 0' }} />
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
          <span className="t-b4 c2">결제 금액</span><b style={{ font: '700 24px var(--f)', letterSpacing: '-.6px' }}>{won(RC_PAY)}원</b></div></div>
      <div className="gcard" style={{ padding: '4px 16px' }}>
        <div className="kv"><span>취소 · 변경 규정</span><b className="cv">전체 보기</b></div>
        <div className="kv"><span>티켓 공유</span><b>1장 공유 중</b></div></div>
    </div></Phone>;
}

/* R1 — 무료 취소 안내 (결제 후 10분 이내 · 모든 예약) */
function RC1() {
  const [s] = useCountdown(438);
  return <RDlg title="지금은 무료로 취소할 수 있어요" desc="결제 후 10분 이내에는 패널티 없이 전액 환불됩니다."
    actions={<><button className="btn s">돌아가기</button><button className="btn p">무료로 취소하기</button></>}>
    <div className="gcard" style={{ padding: '12px 16px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}><span className="t-b4 c2">남은 무료 취소 시간</span>
        <b style={{ font: '700 20px var(--f)', color: 'var(--lime500)', fontVariantNumeric: 'tabular-nums' }}>{mmss(s)}</b></div>
      <div className="hr" style={{ margin: '12px 0' }} />
      <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>돌려받는 금액</span><b style={{ fontSize: 14, color: 'var(--lime500)' }}>{won(RC_PAY)}원 (전액)</b></div>
      <div className="t-cap c4" style={{ lineHeight: '24px', marginTop: 8 }}>10분이 지나면 취소 시점별 규정이 적용돼요</div></div>
  </RDlg>;
}
/* R2 — 예약 취소 · 전액 환불 구간 (기존 RSV-053 팝업 수정) */
const RC2 = () => <RDlg title={<>예약을 정말<br />취소하시겠어요?</>} desc="예약일 3일 전까지는 패널티 없이 전액 환불됩니다. 한 번 취소하면 다시 복구할 수 없습니다."
  actions={<><button className="btn s">돌아가기</button><button className="btn p">예약 취소하기</button></>}>
  <div className="gcard" style={{ padding: '12px 16px' }}>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>취소 구간</span><b style={{ fontSize: 14 }}>예약일 3일 전까지</b></div>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>돌려받는 금액</span><b style={{ fontSize: 14, color: 'var(--lime500)' }}>{won(RC_PAY)}원 (전액)</b></div>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>환불 예상 소요</span><b style={{ fontSize: 14 }}>영업일 3~5일</b></div></div>
</RDlg>;
/* R3 — 취소 패널티 내역 확인 (부분 환불 구간) */
function RC3({ v = 'day' }) {
  const [rules, setRules] = rcS(false);
  const D = v === 'day'
    ? { badge: '당일 영업 시작 전', rows: [['테이블 위약금 · 50%', '- 150,000원', 1], ['메뉴 위약금 · 10%', '- 70,000원', 1], ['취소 처리 수수료 · 결제총액의 3%', '- 30,000원', 1]], total: '750,000원' }
    : { badge: '2일 전 ~ 전날', rows: [['테이블 위약금 · 20%', '- 60,000원', 1], ['메뉴 위약금 · 0%', '0원'], ['취소 처리 수수료 · 결제총액의 3%', '- 30,000원', 1]], total: '910,000원' };
  return <Phone bd="ambient" botH={128}
    top={<AppBar title="예약 취소" right={<button className="gbtn" aria-label="취소 · 변경 규정 전체 보기" onClick={() => setRules(true)}><Icon n="doc" s={20} /></button>} />}
    overlay={<RulesTabSheet open={rules} onClose={() => setRules(false)} />}
    bottom={<Bottom cap="취소하면 되돌릴 수 없어요"><button className="vb s" style={{ flex: 1 }}>돌아가기</button><button className="vb" style={{ flex: 1.4 }}>취소하기</button></Bottom>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <div className="ibn amber"><i />{D.badge} · 패널티가 부과되는 구간이에요</div>
      <RSummary skip={['좌석']} />
      <RAmt label="패널티 내역" rows={D.rows} total={D.total} tone="part" />
      <div className="fnote"><Icon n="info" s={16} /><span>환불은 취소 접수 후 영업일 3~5일 이내에 결제 수단으로 처리돼요.</span></div>
    </div></Phone>;
}
/* R4 — 취소 불가 안내 (영업 시작 후 · 전환 후) */
const RC4 = () => <RNotice bar="예약 취소" icon="info" tone="gray" title={<>지금은 취소해도<br />환불되지 않아요</>}
  desc={<>영업이 시작된 뒤에는 테이블·메뉴 위약금이 100%로 적용돼요. 입장 3시간 전 입장권으로 전환된 뒤에도 당일이라 같은 기준이에요.</>}
  rows={[['취소 구간', '영업 시작 후 ~ 도착 전'], ['위약금', '테이블 100% · 메뉴 100%'], ['돌려받는 금액', '0원']]}
  bullets={['그래도 취소하면 티켓이 사라지고, 공유한 티켓도 함께 삭제돼요.', '방문하지 않는 노쇼도 결과가 같아요.']}
  actions={<><button className="vb s" style={{ flex: 1 }}>돌아가기</button><button className="vb" style={{ flex: 1, background: 'rgba(255,255,255,.08)', border: '1px solid var(--hair)', color: 'var(--t2)' }}>환불 없이 취소</button></>} />;
/* R5 — 취소 확인 팝업 (최종 확인) */
const RC5 = () => <RDlg bar="예약 취소" title={<>이 금액으로<br />취소를 진행할까요?</>} desc="취소하면 되돌릴 수 없고, 같은 조건으로 다시 예약된다는 보장이 없어요."
  actions={<><button className="btn s">돌아가기</button><button className="btn p">진행하기</button></>}>
  <div className="gcard" style={{ padding: '12px 16px' }}>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>패널티 합계</span><b style={{ fontSize: 14, color: 'var(--amber500)' }}>- 250,000원</b></div>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>돌려받는 금액</span><b style={{ fontSize: 14, color: 'var(--lime500)' }}>750,000원</b></div>
    <div className="hr" style={{ margin: '8px 0' }} />
    <div className="t-cap" style={{ color: 'var(--amber500)', lineHeight: '24px' }}>공유 중인 티켓 1장도 함께 삭제돼요</div></div>
</RDlg>;

/* R7 — 변경 항목 선택 */
const RC_ITEMS = [
  { it: '인원', now: '3명', st: 'free', d: '테이블 수용 인원 이내' },
  { it: '메뉴', now: 'HARD SET A 외 1건', st: 'part', d: '하향은 차액의 10% 패널티 · 최소주문금액 50만 원 이상 유지' },
  { it: '테이블', now: '테이블-4', st: 'part', d: '하향은 차액의 50% 패널티 · 상향은 무료' },
  { it: '도착시간', now: '오후 8:00', st: 'once', d: '당일 영업 시작 전 1회 무료' },
];
function RC7() {
  const [sel, setSel] = rcS(['메뉴']);
  const B = { free: <Badge s="entered">무료</Badge>, part: <Badge s="pending">패널티 발생</Badge>, once: <Badge s="pending">1회 무료</Badge>, no: <Badge s="done">변경 불가</Badge> };
  const tog = (it) => setSel((a) => (a.includes(it) ? a.filter((x) => x !== it) : a.concat(it)));
  return <Phone bd="aurora" top={<AppBar title="예약 변경" />} botH={128}
    bottom={<Bottom cap={sel.length ? '함께 바꾸고 한 번 결제하면 변경 1회예요' : '바꿀 항목을 선택해 주세요'}>
      <button className="vb" disabled={!sel.length}>{sel.length ? `${sel.length}개 항목 변경하기` : '변경하기'}</button></Bottom>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 20 }}>
      <div className="ibn purple"><i />당일 영업 시작 전 구간 · 이번 변경은 1회차 무료</div>
      <div className="t-cap c4" style={{ lineHeight: '24px' }}>{RC_CLUB} · {RC_WHEN} · {RC_SEAT} · {won(RC_PAY)}원</div>
      <div className="stack" style={{ gap: 8 }}>
        {RC_ITEMS.map((x) => <div key={x.it} className={cx(sel.includes(x.it) ? 'gcard' : 'gquiet')} style={{ padding: '12px 16px', border: sel.includes(x.it) ? '1px solid rgba(119,49,254,.5)' : null }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <Check on={sel.includes(x.it)} onChange={() => tog(x.it)} style={{ flex: 1 }}><span className="t-btn1">{x.it}</span></Check>{B[x.st]}</div>
          <div className="kv" style={{ padding: '8px 0 0', fontSize: 14 }}><span>현재</span><b style={{ fontSize: 14 }}>{x.now}</b></div>
          <div className="t-cap c4" style={{ lineHeight: '24px' }}>{x.d}</div></div>)}
      </div>
      <div className="t-cap c4" style={{ lineHeight: '24px' }}>2회차부터 건당 3,000원이 부과돼요 · 여러 항목을 함께 바꾸면 1회로 계산돼요</div>
    </div></Phone>;
}
/* R8 — 하향 변경 패널티 확인 */
const RC8 = () => <Phone bd="ambient" top={<AppBar title="변경 내용 확인" />} botH={128}
  bottom={<Bottom cap="변경하면 되돌릴 수 없어요"><button className="vb s" style={{ flex: 1 }}>돌아가기</button><button className="vb" style={{ flex: 1.4 }}>변경하고 환불받기</button></Bottom>}>
  <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
    <div className="ibn amber"><i />당일 영업 시작 전 하향 변경 · 차액의 50% 패널티가 부과돼요</div>
    <div className="gcard">
      <div className="shead" style={{ marginBottom: 8 }}><span className="tt">테이블 하향</span><Badge s="pending">패널티 발생</Badge></div>
      <div className="tk-stats two" style={{ margin: '4px 0 0' }}>
        <div><div className="k">변경 전</div><div className="v">테이블-4 · 30만 원</div></div>
        <div><div className="k">변경 후</div><div className="v">테이블-2 · 20만 원</div></div></div></div>
    <RAmt label="정산 내역" rows={[['차액', '100,000원'], ['하향 패널티 · 차액의 50%', '- 50,000원', 1], ['변경 처리 수수료 · 1회차', '무료']]} total="50,000원" tone="part" />
    <div className="fnote"><Icon n="info" s={16} /><span>최소주문금액 50만 원은 그대로 유지돼요. 변경 후 금액이 미만이면 변경할 수 없어요.</span></div>
  </div></Phone>;
/* R9 — 상향 변경 추가 결제 (RSV-049 재사용) */
const RC9 = () => <Phone bd="ambient" top={<AppBar title="결제하기" />} botH={128}
  bottom={<Bottom><button className="vb">200,000원 결제하기</button></Bottom>}>
  <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
    <div className="ibn purple"><i />RSV-049 결제 화면 재사용 · 차액만 결제해요</div>
    <div className="gcard">
      <div className="shead" style={{ marginBottom: 8 }}><span className="tt">메뉴 상향</span><Badge s="entered">무료</Badge></div>
      <div className="tk-stats two" style={{ margin: '4px 0 0' }}>
        <div><div className="k">변경 전</div><div className="v">70만 원</div></div>
        <div><div className="k">변경 후</div><div className="v">90만 원</div></div></div></div>
    <div className="gcard"><div className="shead" style={{ marginBottom: 8 }}><span className="tt">추가 결제</span></div>
      {[['차액', '200,000원'], ['상향 패널티', '없음'], ['변경 처리 수수료 · 1회차', '무료']].map(([a, b]) => <div className="kv" key={a} style={{ padding: '8px 0', fontSize: 14 }}><span>{a}</span><b style={{ fontSize: 14 }}>{b}</b></div>)}
      <div className="hr" style={{ margin: '12px 0' }} />
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}><span className="t-b4 c2">결제 금액</span>
        <b style={{ font: '700 24px var(--f)', letterSpacing: '-.6px' }}>200,000원</b></div></div>
    <div className="fnote"><Icon n="info" s={16} /><span>규정 동의를 다시 받을지, 이미 동의한 것으로 볼지 확인이 필요해요.</span></div>
  </div></Phone>;
/* R10 — 변경 불가 안내 */
const RC10 = () => <RNotice bar="예약 변경" icon="info" tone="gray" title={<>이 항목은 지금<br />변경할 수 없어요</>}
  desc="영업이 시작된 뒤에는 하향 변경과 도착시간 변경이 막혀요."
  rows={[['메뉴 하향', '변경 불가'], ['테이블 하향', '변경 불가'], ['도착시간 변경', '변경 불가'], ['인원 · 상향 변경', '무료']]}
  bullets={['메뉴를 낮춰 최소주문금액 50만 원 미만이 되면 변경할 수 없어요.', '인원 증가는 테이블 수용 인원 이내에서만 가능해요.', '예약을 취소하고 다시 예약하면 취소 규정이 적용돼요.']}
  actions={<><button className="vb s" style={{ flex: 1 }}>돌아가기</button><button className="vb" style={{ flex: 1 }}>가능한 변경 보기</button></>} />;
/* R11 — 변경 수수료 안내 팝업 */
const RC11 = () => <RDlg bar="변경 내용 확인" title={<>이번 변경은<br />3,000원이 부과돼요</>} desc="첫 변경은 무료이고, 2회차부터 건당 3,000원의 변경 처리 수수료가 붙습니다."
  actions={<><button className="btn s">돌아가기</button><button className="btn p">동의하고 변경</button></>}>
  <div className="gcard" style={{ padding: '12px 16px' }}>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>지금까지 변경</span><b style={{ fontSize: 14 }}>1회 (무료)</b></div>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>이번 변경</span><b style={{ fontSize: 14, color: 'var(--amber500)' }}>2회차 · 3,000원</b></div>
    <div className="t-cap c4" style={{ lineHeight: '24px', marginTop: 4 }}>여러 항목을 함께 바꾸고 한 번 결제하면 1회로 계산돼요</div></div>
</RDlg>;
/* R12 — 변경 완료 */
const RC12 = () => <Phone bd="aurora" top={<AppBar title="변경 완료" noBack />} botH={102}
  bottom={<Bottom><button className="vb s" style={{ flex: 1 }}>확인</button><button className="vb" style={{ flex: 2 }}>패스월렛에서 보기</button></Bottom>}>
  <div className="pad" style={{ paddingTop: 20, paddingBottom: 20 }}>
    <div className="succ"><svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5L20 7" /></svg></div>
    <div className="t-h3 fade-up" style={{ textAlign: 'center', marginTop: 20, animationDelay: '.3s' }}>예약이 변경되었어요</div>
    <div className="t-b4 c3 fade-up" style={{ textAlign: 'center', marginTop: 12, animationDelay: '.35s' }}>변경된 내용은 패스월렛 예약 티켓에 바로 반영돼요</div>
    <div className="gcard fade-up" style={{ marginTop: 20, animationDelay: '.42s' }}>
      <div className="shead" style={{ marginBottom: 8 }}><span className="tt">바뀐 항목</span><Badge>1회차 변경</Badge></div>
      <div className="tk-stats two" style={{ margin: '4px 0 0' }}>
        <div><div className="k">변경 전</div><div className="v">테이블-4 · 30만</div></div>
        <div><div className="k">변경 후</div><div className="v">테이블-2 · 20만</div></div></div></div>
    <div className="gcard fade-up" style={{ marginTop: 12, animationDelay: '.5s' }}>
      {[['차액', '100,000원'], ['하향 패널티 · 50%', '- 50,000원'], ['환불 금액', '50,000원']].map(([a, b], i) => <div key={a} className="kv" style={i === 2 ? { fontWeight: 600 } : { padding: '8px 0', fontSize: 14 }}><span style={i === 2 ? { color: '#fff' } : null}>{a}</span><b style={i === 2 ? { fontWeight: 700, color: 'var(--lime500)' } : null}>{b}</b></div>)}</div>
    <div className="t-cap c4" style={{ textAlign: 'center', marginTop: 12, lineHeight: '24px' }}>다음 변경부터는 건당 3,000원이 부과돼요</div>
  </div></Phone>;

/* R13 — 노쇼 결과 티켓 */
const RC13 = () => <Phone bd="ambient" top={<AppBar title="예약 티켓" />} botH={102}
  bottom={<Bottom><button className="vb s" style={{ flex: 1 }}>이용 내역</button><button className="vb" style={{ flex: 1 }}>다시 예약하기</button></Bottom>}>
  <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24, minHeight: '100%', justifyContent: 'center' }}>
    <div className="tk cmp rsv done" style={{ filter: 'saturate(0)' }}>
      <div className="tk-h"><i className="tk-hl g on" />
        <div><div className="club">{RC_CLUB} <Badge s="done">노쇼</Badge></div><div className="sub">07월 23일 수요일 · 방문하지 않아 종료됐어요</div></div></div>
      <div className="tk-cut" />
      <div className="tk-b">
        <div className="tk-lbl">{RC_WHEN}</div>
        <div className="tk-num sm">{RC_SEAT}</div>
        <div className="tk-stats two"><div><div className="k">위약금</div><div className="v">100%</div></div><div><div className="k">환불</div><div className="v">없음</div></div></div>
        <div className="tk-note">영업 시작 후 취소와 같은 기준이 적용됐어요</div>
        <div className="tk-stub"><div><span className="k">TABLE RESERVATION</span><span className="c">RS-2607-1182</span></div><span className="bar" aria-hidden="true" /></div></div></div>
    <div className="fnote"><Icon n="info" s={16} /><span>노쇼는 테이블·메뉴 위약금이 100%로 적용되어 환불되지 않아요.</span></div>
  </div></Phone>;
/* R14 — 매장 취소 안내 (전액 환불) */
const RC14 = () => <RNotice bar="예약 취소 안내" icon="store" tone="lime" title={<>매장에서<br />예약을 취소했어요</>}
  desc={<>{RC_CLUB}에서 예약을 취소했어요. 결제하신 금액은 전액 환불됩니다.</>}
  rows={[['예약 일시', RC_WHEN], ['취소 주체', '매장'], ['돌려받는 금액', won(RC_PAY) + '원 (전액)'], ['결제 수단', '신용카드 · 신한']]}
  bullets={['매장 사유 취소는 위약금과 수수료가 붙지 않아요.', '환불은 취소 접수 후 영업일 3~5일 이내에 결제 수단으로 처리돼요.']}
  actions={<><button className="vb s" style={{ flex: 1 }}>이용 내역</button><button className="vb" style={{ flex: 1.4 }}>다른 클럽 찾기</button></>} />;
/* 3단계 스텝 인디케이터 — StepI(4분할)의 3분할 변형. 선이 마지막 점에서 끝난다 */
const RStep3 = ({ steps, cur }) => <div className="stepi n3"><i className="fill" style={{ width: cur / (steps.length - 1) * 66.6 + '%' }} />{steps.map((s, i) => <div key={s} className={cx(i < cur && 'past', i === cur && 'cur')}>{s}</div>)}</div>;
/* R15 — 환불 상태 (진행 중 · 완료 · 실패) */
function RC15({ v = 'ing' }) {
  const D = {
    ing: { b: <Badge s="pending" dot>환불 진행 중</Badge>, t: '환불이 진행되고 있어요', c: 1 },
    done: { b: <Badge s="entered">환불 완료</Badge>, t: '환불이 완료됐어요', c: 2 },
    fail: { b: <Badge s="err">환불 실패</Badge>, t: '환불에 실패했어요', c: 1 },
  }[v];
  return <Phone bd="ambient" top={<AppBar title="환불 상태" />} botH={102}
    bottom={<Bottom>{v === 'fail' ? <><button className="vb s" style={{ flex: 1 }}>다시 시도</button><button className="vb" style={{ flex: 1.4 }}>고객센터 문의</button></> : <button className="vb">확인</button>}</Bottom>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24, minHeight: '100%', justifyContent: 'center' }}>
      <div className="gcard">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
          <div><div className="t-h4">{D.t}</div><div className="meta" style={{ marginTop: 8 }}>{RC_CLUB}<span className="d" />07월 23일 (수)</div></div>{D.b}</div>
        <RStep3 steps={['취소 접수', '환불 요청', '환불 완료']} cur={D.c} /></div>
      <RAmt label="환불 내역" rows={[['결제 금액', won(RC_PAY) + '원'], ['패널티 합계', '- 250,000원', 1], ['결제 수단', '신용카드 · 신한']]} total="750,000원" tone={v === 'fail' ? 'no' : 'ok'} />
      {v === 'fail' ? <div className="fnote" style={{ borderColor: 'rgba(245,181,68,.4)' }}><Icon n="info" s={16} /><span>카드사 통신 오류로 환불이 완료되지 않았어요. 다시 시도하거나 고객센터로 문의해 주세요.</span></div>
        : <div className="fnote"><Icon n="info" s={16} /><span>환불은 취소 접수 후 영업일 3~5일 이내에 결제 수단으로 처리돼요.</span></div>}
    </div></Phone>;
}
/* R16 — 전환 티켓 취소·변경 불가 안내 */
const RC16 = () => <RNotice bar="입장권" icon="ticket" tone="amber" title={<>입장권으로 전환된 뒤에는<br />취소 · 변경할 수 없어요</>}
  desc="입장 3시간 전에 입장권으로 전환됐어요. 전환 이후는 당일이라 환불과 변경이 모두 막혀요."
  rows={[['전환 시각', '오후 5:00'], ['환불', '불가'], ['변경', '불가']]}
  bullets={['그래도 취소하면 입장권과 공유한 티켓이 모두 삭제되고 환불되지 않아요.', '도착이 늦어질 것 같으면 매장에 직접 문의해 주세요.']}
  actions={<><button className="vb s" style={{ flex: 1 }}>돌아가기</button><button className="vb" style={{ flex: 1 }}>매장에 문의</button></>} />;
/* R17 — 공유받은 티켓 삭제 안내 */
const RC17 = () => <RNotice bar="입장권" icon="close" tone="gray" title={<>공유받은 입장권이<br />삭제됐어요</>}
  desc="공유해준 분이 예약을 취소해서 이 입장권도 함께 사라졌어요."
  rows={[['매장', RC_CLUB], ['이용 날짜', '07월 23일 (수)'], ['상태', '원본 예약 취소로 삭제']]}
  bullets={['공유해준 분의 개인정보는 표시하지 않아요.', '같은 예약으로는 다시 받을 수 없어요.']}
  actions={<><button className="vb s" style={{ flex: 1 }}>확인</button><button className="vb" style={{ flex: 1.4 }}>주변 클럽 보기</button></>} />;

const RC_LIST = [
  { id: 'R1', nm: '무료 취소 안내', tag: '신규', comp: RC1 },
  { id: 'R2', nm: '예약 취소 · 전액 환불', tag: '기존 수정', comp: RC2 },
  { id: 'R3', nm: '취소 패널티 내역 · 2일 전~전날', tag: '신규', comp: () => <RC3 v="eve" /> },
  { id: 'R3-1', nm: '취소 패널티 내역 · 당일 영업 전', tag: '신규', comp: () => <RC3 v="day" /> },
  { id: 'R4', nm: '취소 불가 안내', tag: '신규', comp: RC4 },
  { id: 'R5', nm: '취소 확인 팝업', tag: '기존 수정', comp: RC5 },
  { id: 'R7', nm: '변경 항목 선택', tag: '신규', comp: RC7 },
  { id: 'R8', nm: '하향 변경 패널티 확인', tag: '신규', comp: RC8 },
  { id: 'R9', nm: '상향 변경 추가 결제', tag: '재사용', comp: RC9 },
  { id: 'R10', nm: '변경 불가 안내', tag: '신규', comp: RC10 },
  { id: 'R11', nm: '변경 수수료 안내 팝업', tag: '신규', comp: RC11 },
  { id: 'R12', nm: '변경 완료', tag: '신규', comp: RC12 },
  { id: 'R13', nm: '노쇼 결과 티켓', tag: '기존 수정', comp: RC13 },
  { id: 'R14', nm: '매장 취소 안내 · 전액 환불', tag: '신규', comp: RC14 },
  { id: 'R15', nm: '환불 진행 중', tag: '신규', comp: () => <RC15 v="ing" /> },
  { id: 'R15-1', nm: '환불 완료', tag: '신규', comp: () => <RC15 v="done" /> },
  { id: 'R15-2', nm: '환불 실패', tag: '신규', comp: () => <RC15 v="fail" /> },
  { id: 'R16', nm: '전환 티켓 취소 · 변경 불가', tag: '신규', comp: RC16 },
  { id: 'R17', nm: '공유받은 티켓 삭제 안내', tag: '신규', comp: RC17 },
];
Object.assign(window, { RC_LIST, RSummary, RAmt, RNotice, RDlg });
