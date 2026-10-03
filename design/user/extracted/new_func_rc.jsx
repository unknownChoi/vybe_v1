/* global React, cx, won, Icon, Phone, AppBar, Bottom, Badge, Dialog, Check, useCountdown, mmss, RulesTabSheet, goRow */
/* VYBE v1 — 예약 취소 · 변경 규정 반영 화면 (RSV-091 ~ RSV-102)
   화면 구성 · 정보 배치 · 문구 · 금액은 "F · UI 시안"을 그대로 따른다.
   스타일은 디자인 시스템 토큰 · 기존 컴포넌트만 사용한다.
   금액은 규정 "적용 예시" 기준 — 테이블 30만 · 메뉴 70만 · 결제총액 100만 원. */
const { useState: rkS } = React;
const RK_CLUB = '어썸레드';
const RK_WHEN = '07월 23일 (수) 오후 8:00';
const RK_SEAT = '테이블-4 · 3명';
const RK_PAY = 1000000;
/* 이동 대상 — nf_specs 행 id · 상태 변형은 #n · 베타 화면(HTML)은 file: */
const RK = {
  pw: 'pw-02', hist: 'pw-04', tkTab: 'pw-01', resvDet: 'pw-06', entryDet: 'rv-03',
  cancelFull: 'rs-07', cancelDone: 'rs-07#1', cancelPart: 'rs-07#2', cancelNone: 'rs-07#3', upPay: 'rs-03#7',
  nearby: 'file:[v1]PLACE-019.html', support: 'file:[v1]MY-032.html', club: 'file:[v1]CLUB-021.html',
};

const RkSummary = ({ note, skip = [] }) => <div className="gcard" style={{ padding: '4px 16px' }}>
  {[['매장', RK_CLUB], ['예약 일시', RK_WHEN], ['좌석', RK_SEAT], ['결제 금액', won(RK_PAY) + '원']].filter(([a]) => !skip.includes(a)).map(([a, b]) => <div className="kv" key={a}><span>{a}</span><b>{b}</b></div>)}
  {note ? <div className="t-cap c4" style={{ lineHeight: '24px', padding: '4px 0 12px' }}>{note}</div> : null}</div>;

/* 금액 카드 — 패널티 항목과 최종 금액 */
function RkAmt({ rows, label, total, tone = 'ok' }) {
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
function RkNotice({ title, bar, icon = 'info', tone = 'amber', desc, rows, bullets, actions }) {
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
/* 팝업형 화면 — 예약 상세 위에 다이얼로그 */
function RkDlg({ bar = '예약 상세', title, desc, children, actions }) {
  return <Phone bd="ambient" top={<AppBar title={bar} />} botH={102}
    bottom={<Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('rc-02')}>예약 취소하기</button><button className="vb" style={{ flex: 1 }} onClick={() => goRow('rc-04')}>예약 변경하기</button></Bottom>}
    overlay={<Dialog open title={title} desc={desc} actions={actions}>{children}</Dialog>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <RkSummary />
      <div className="gcard">
        <div className="shead"><span className="tt">주문 내역</span><Badge s="entered">결제 완료</Badge></div>
        {[['테이블-4 · 3명', '300,000원'], ['HARD SET A', '500,000원'], ['샴페인 1병', '200,000원']].map(([a, b]) => <div className="kv" key={a} style={{ padding: '8px 0', fontSize: 14 }}><span>{a}</span><b style={{ fontSize: 14 }}>{b}</b></div>)}
        <div className="hr" style={{ margin: '12px 0' }} />
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
          <span className="t-b4 c2">결제 금액</span><b style={{ font: '700 24px var(--f)', letterSpacing: '-.6px' }}>{won(RK_PAY)}원</b></div></div>
      <div className="gcard" style={{ padding: '4px 16px' }}>
        <div className="kv"><span>취소 · 변경 규정</span><b className="cv">전체 보기</b></div>
        <div className="kv"><span>티켓 공유</span><b>1장 공유 중</b></div></div>
    </div></Phone>;
}

/* RSV-091 · 무료 취소 안내 (결제 후 10분 이내 · 모든 예약)
   10분이 지나면 그 시점의 구간(3일 전까지 = 전액 환불)으로 넘긴다. */
function RkFreeCancel() {
  const [s] = useCountdown(438);
  const over = s === 0;
  return <RkDlg title={over ? <>무료 취소 시간이<br />지났어요</> : '지금은 무료로 취소할 수 있어요'}
    desc={over ? '이제부터는 취소 시점별 규정이 적용돼요. 지금은 예약일 3일 전까지 구간이라 전액 환불돼요.' : '결제 후 10분 이내에는 패널티 없이 전액 환불돼요.'}
    actions={<><button className="btn s" onClick={() => goRow(RK.pw)}>돌아가기</button>
      <button className="btn p" onClick={() => goRow(over ? RK.cancelFull : RK.cancelDone)}>{over ? '취소 계속하기' : '무료로 취소하기'}</button></>}>
    <div className="gcard" style={{ padding: '12px 16px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}><span className="t-b4 c2">남은 무료 취소 시간</span>
        <b style={{ font: '700 20px var(--f)', color: over ? 'var(--g500)' : 'var(--lime500)', fontVariantNumeric: 'tabular-nums' }}>{mmss(s)}</b></div>
      <div className="hr" style={{ margin: '12px 0' }} />
      <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>돌려받는 금액</span><b style={{ fontSize: 14, color: 'var(--lime500)' }}>{won(RK_PAY)}원 (전액)</b></div>
      <div className="t-cap c4" style={{ lineHeight: '24px', marginTop: 8 }}>10분이 지나면 취소 시점별 규정이 적용돼요</div></div>
  </RkDlg>;
}

/* RSV-092 · 취소 패널티 내역 확인 (부분 환불 구간) */
function RkDeduct({ v = 'eve' }) {
  const [rules, setRules] = rkS(false);
  const D = v === 'day'
    ? { badge: '당일 영업 시작 전', rows: [['테이블 위약금 · 50%', '- 150,000원', 1], ['메뉴 위약금 · 10%', '- 70,000원', 1], ['취소 처리 수수료 · 결제총액의 3%', '- 30,000원', 1]], total: '750,000원' }
    : { badge: '2일 전 ~ 전날', rows: [['테이블 위약금 · 20%', '- 60,000원', 1], ['메뉴 위약금 · 0%', '0원'], ['취소 처리 수수료 · 결제총액의 3%', '- 30,000원', 1]], total: '910,000원' };
  return <Phone bd="ambient" botH={128}
    top={<AppBar title="예약 취소" right={<button className="gbtn" aria-label="취소 · 변경 규정 전체 보기" onClick={() => setRules(true)}><Icon n="doc" s={20} /></button>} />}
    overlay={<RulesTabSheet open={rules} onClose={() => setRules(false)} />}
    bottom={<Bottom cap="취소하면 되돌릴 수 없어요"><button className="vb s" style={{ flex: 1 }} onClick={() => goRow(RK.pw)}>돌아가기</button>
      <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow(RK.cancelPart)}>취소하기</button></Bottom>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <div className="ibn amber"><i />{D.badge} · 패널티가 부과되는 구간이에요</div>
      <RkSummary skip={['좌석']} />
      <RkAmt label="패널티 내역" rows={D.rows} total={D.total} tone="part" />
      <div className="fnote"><Icon n="info" s={16} /><span>환불은 취소 접수 후 영업일 3~5일 이내에 결제 수단으로 처리돼요.</span></div>
    </div></Phone>;
}

/* RSV-093 · 취소 불가 안내 (영업 시작 후 · 전환 후) */
const RkNoRefund = () => <RkNotice bar="예약 취소" icon="info" tone="gray" title={<>지금은 취소해도<br />환불되지 않아요</>}
  desc={<>영업이 시작된 뒤에는 테이블·메뉴 위약금이 100%로 적용돼요. 입장 3시간 전 입장권으로 전환된 뒤에도 당일이라 같은 기준이에요.</>}
  rows={[['취소 구간', '영업 시작 후 ~ 도착 전'], ['위약금', '테이블 100% · 메뉴 100%'], ['돌려받는 금액', '0원']]}
  bullets={['그래도 취소하면 티켓이 사라지고, 공유한 티켓도 함께 삭제돼요.', '방문하지 않는 노쇼도 결과가 같아요.']}
  actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow(RK.pw)}>돌아가기</button>
    <button className="vb s" style={{ flex: 1 }} onClick={() => goRow(RK.cancelNone)}>환불 없이 취소</button></>} />;

/* RSV-094 · 변경 항목 선택 */
const RK_ITEMS = [
  { it: '인원', now: '3명', st: 'free', d: '테이블 수용 인원 이내' },
  { it: '메뉴', now: 'HARD SET A 외 1건', st: 'part', d: '하향은 차액의 10% 패널티 · 최소주문금액 50만 원 이상 유지' },
  { it: '테이블', now: '테이블-4', st: 'part', d: '하향은 차액의 50% 패널티 · 상향은 무료' },
  { it: '도착시간', now: '오후 8:00', st: 'once', d: '당일 영업 시작 전 1회 무료' },
];
function RkChangePick({ sel: sel0 = [] }) {
  const [sel, setSel] = rkS(sel0);
  const B = { free: <Badge s="entered">무료</Badge>, part: <Badge s="pending">패널티 발생</Badge>, once: <Badge s="pending">1회 무료</Badge>, no: <Badge s="done">변경 불가</Badge> };
  const tog = (it) => setSel((a) => (a.includes(it) ? a.filter((x) => x !== it) : a.concat(it)));
  /* 고른 항목을 그대로 넘겨 예약 정보 변경(RSV-103)에서 값을 고른다 */
  const next = () => goRow('rc-13');
  return <Phone bd="aurora" top={<AppBar title="예약 변경" />} botH={128}
    bottom={<Bottom cap={sel.length ? '함께 바꾸고 한 번 결제하면 변경 1회예요' : '바꿀 항목을 선택해 주세요'}>
      <button className="vb" disabled={!sel.length} onClick={next}>{sel.length ? `${sel.length}개 항목 변경하기` : '변경하기'}</button></Bottom>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 20 }}>
      <div className="ibn purple"><i />당일 영업 시작 전 구간 · 이번 변경은 1회차 무료</div>
      <div className="t-cap c4" style={{ lineHeight: '24px' }}>{RK_CLUB} · {RK_WHEN} · {RK_SEAT} · {won(RK_PAY)}원</div>
      <div className="stack" style={{ gap: 8 }}>
        {RK_ITEMS.map((x) => <div key={x.it} className={cx(sel.includes(x.it) ? 'gcard' : 'gquiet')} style={{ padding: '12px 16px', border: sel.includes(x.it) ? '1px solid rgba(119,49,254,.5)' : null }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <Check on={sel.includes(x.it)} onChange={() => tog(x.it)} style={{ flex: 1 }}><span className="t-btn1">{x.it}</span></Check>{B[x.st]}</div>
          <div className="kv" style={{ padding: '8px 0 0', fontSize: 14 }}><span>현재</span><b style={{ fontSize: 14 }}>{x.now}</b></div>
          <div className="t-cap c4" style={{ lineHeight: '24px' }}>{x.d}</div></div>)}
      </div>
      <div className="t-cap c4" style={{ lineHeight: '24px' }}>2회차부터 건당 3,000원이 부과돼요 · 여러 항목을 함께 바꾸면 1회로 계산돼요</div>
      <button className="btn s" style={{ width: '100%' }} onClick={() => goRow('rc-06')}>지금 변경할 수 없는 항목 보기</button>
    </div></Phone>;
}

/* RSV-095 · 하향 변경 패널티 확인 — n=2는 2회차(변경 처리 수수료 3,000원) */
const RkChangeDown = ({ n = 1 }) => <Phone bd="ambient" top={<AppBar title="변경 내용 확인" />} botH={128}
  bottom={<Bottom cap="변경하면 되돌릴 수 없어요"><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('rc-13')}>돌아가기</button>
    <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow(n > 1 ? 'rc-07' : 'rc-08')}>변경하고 환불받기</button></Bottom>}>
  <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
    <div className="ibn amber"><i />당일 영업 시작 전 하향 변경 · 차액의 50% 패널티가 부과돼요</div>
    <div className="gcard">
      <div className="shead" style={{ marginBottom: 8 }}><span className="tt">테이블 하향</span><Badge s="pending">패널티 발생</Badge></div>
      <div className="tk-stats two" style={{ margin: '4px 0 0' }}>
        <div><div className="k">변경 전</div><div className="v">테이블-4 · 30만 원</div></div>
        <div><div className="k">변경 후</div><div className="v">테이블-2 · 20만 원</div></div></div></div>
    <RkAmt label="정산 내역" rows={[['차액', '100,000원'], ['하향 패널티 · 차액의 50%', '- 50,000원', 1], n > 1 ? ['변경 처리 수수료 · 2회차', '- 3,000원', 1] : ['변경 처리 수수료 · 1회차', '무료']]}
      total={n > 1 ? '47,000원' : '50,000원'} tone="part" />
    <div className="fnote"><Icon n="info" s={16} /><span>최소주문금액 50만 원은 그대로 유지돼요. 변경 후 금액이 미만이면 변경할 수 없어요.</span></div>
  </div></Phone>;

/* RSV-096 · 변경 불가 안내 */
const RkNoChange = () => <RkNotice bar="예약 변경" icon="info" tone="gray" title={<>이 항목은 지금<br />변경할 수 없어요</>}
  desc="영업이 시작된 뒤에는 하향 변경과 도착시간 변경이 막혀요."
  rows={[['메뉴 하향', '변경 불가'], ['테이블 하향', '변경 불가'], ['도착시간 변경', '변경 불가'], ['인원 · 상향 변경', '무료']]}
  bullets={['메뉴를 낮춰 최소주문금액 50만 원 미만이 되면 변경할 수 없어요.', '인원 증가는 테이블 수용 인원 이내에서만 가능해요.', '예약을 취소하고 다시 예약하면 취소 규정이 적용돼요.']}
  actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('rc-04')}>돌아가기</button>
    <button className="vb" style={{ flex: 1 }} onClick={() => goRow('rc-04')}>가능한 변경 보기</button></>} />;

/* RSV-097 · 변경 수수료 안내 팝업 (2회차 이상) */
const RkChangeFee = () => <RkDlg bar="변경 내용 확인" title={<>이번 변경은<br />3,000원이 부과돼요</>} desc="첫 변경은 무료이고, 2회차부터 건당 3,000원의 변경 처리 수수료가 붙어요."
  actions={<><button className="btn s" onClick={() => goRow('rc-05')}>돌아가기</button><button className="btn p" onClick={() => goRow('rc-08')}>동의하고 변경</button></>}>
  <div className="gcard" style={{ padding: '12px 16px' }}>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>지금까지 변경</span><b style={{ fontSize: 14 }}>1회 (무료)</b></div>
    <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>이번 변경</span><b style={{ fontSize: 14, color: 'var(--amber500)' }}>2회차 · 3,000원</b></div>
    <div className="t-cap c4" style={{ lineHeight: '24px', marginTop: 4 }}>여러 항목을 함께 바꾸고 한 번 결제하면 1회로 계산돼요</div></div>
</RkDlg>;

/* RSV-098 · 변경 완료 */
const RkChangeDone = () => <Phone bd="aurora" top={<AppBar title="변경 완료" noBack />} botH={102}
  bottom={<Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => goRow(RK.resvDet)}>확인</button>
    <button className="vb" style={{ flex: 2 }} onClick={() => goRow(RK.pw)}>패스월렛에서 보기</button></Bottom>}>
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

/* RSV-099 · 매장 취소 안내 (전액 환불) */
const RkStoreCancel = () => <RkNotice bar="예약 취소 안내" icon="store" tone="lime" title={<>매장에서<br />예약을 취소했어요</>}
  desc={<>{RK_CLUB}에서 예약을 취소했어요. 결제하신 금액은 전액 환불돼요.</>}
  rows={[['예약 일시', RK_WHEN], ['취소 주체', '매장'], ['돌려받는 금액', won(RK_PAY) + '원 (전액)'], ['결제 수단', '신용카드 · 신한']]}
  bullets={['매장 사유 취소는 위약금과 수수료가 붙지 않아요.', '환불은 취소 접수 후 영업일 3~5일 이내에 결제 수단으로 처리돼요.']}
  actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow(RK.hist)}>이용 내역</button>
    <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow(RK.nearby)}>다른 클럽 찾기</button></>} />;

/* 3단계 스텝 인디케이터 — StepI(4분할)의 3분할 변형 (.stepi.n3) */
const RkStep3 = ({ steps, cur }) => <div className="stepi n3"><i className="fill" style={{ width: cur / (steps.length - 1) * 66.6 + '%' }} />{steps.map((s, i) => <div key={s} className={cx(i < cur && 'past', i === cur && 'cur')}>{s}</div>)}</div>;

/* RSV-100 · 환불 상태 (진행 중 · 완료 · 실패) */
function RkRefund({ v = 'ing' }) {
  const D = {
    ing: { b: <Badge s="pending" dot>환불 진행 중</Badge>, t: '환불이 진행되고 있어요', c: 1 },
    done: { b: <Badge s="entered">환불 완료</Badge>, t: '환불이 완료됐어요', c: 2 },
    fail: { b: <Badge s="err">환불 실패</Badge>, t: '환불에 실패했어요', c: 1 },
  }[v];
  return <Phone bd="ambient" top={<AppBar title="환불 상태" />} botH={102}
    bottom={<Bottom>{v === 'fail'
      ? <><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('rc-10')}>다시 시도</button><button className="vb" style={{ flex: 1.4 }} onClick={() => goRow(RK.support)}>고객센터 문의</button></>
      : <button className="vb" onClick={() => goRow(RK.hist)}>확인</button>}</Bottom>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24, minHeight: '100%', justifyContent: 'center' }}>
      <div className="gcard">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
          <div><div className="t-h4">{D.t}</div><div className="meta" style={{ marginTop: 8 }}>{RK_CLUB}<span className="d" />07월 23일 (수)</div></div>{D.b}</div>
        <RkStep3 steps={['취소 접수', '환불 요청', '환불 완료']} cur={D.c} /></div>
      <RkAmt label="환불 내역" rows={[['결제 금액', won(RK_PAY) + '원'], ['패널티 합계', '- 250,000원', 1], ['결제 수단', '신용카드 · 신한']]} total="750,000원" tone={v === 'fail' ? 'no' : 'ok'} />
      {v === 'fail' ? <div className="fnote" style={{ borderColor: 'rgba(245,181,68,.4)' }}><Icon n="info" s={16} /><span>카드사 통신 오류로 환불이 완료되지 않았어요. 다시 시도하거나 고객센터로 문의해 주세요.</span></div>
        : <div className="fnote"><Icon n="info" s={16} /><span>환불은 취소 접수 후 영업일 3~5일 이내에 결제 수단으로 처리돼요.</span></div>}
    </div></Phone>;
}

/* RSV-101 · 전환 티켓 취소 · 변경 불가 안내 */
const RkEntryLock = () => <RkNotice bar="입장권" icon="ticket" tone="amber" title={<>입장권으로 전환된 뒤에는<br />취소 · 변경할 수 없어요</>}
  desc="입장 3시간 전에 입장권으로 전환됐어요. 전환 이후는 당일이라 환불과 변경이 모두 막혀요."
  rows={[['전환 시각', '오후 5:00'], ['환불', '불가'], ['변경', '불가']]}
  bullets={['그래도 취소하면 입장권과 공유한 티켓이 모두 삭제되고 환불되지 않아요.', '도착이 늦어질 것 같으면 매장에 직접 문의해 주세요.']}
  actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow(RK.entryDet)}>돌아가기</button>
    <button className="vb" style={{ flex: 1 }} onClick={() => goRow(RK.club)}>매장에 문의</button></>} />;

/* RSV-102 · 공유받은 티켓 삭제 안내 */
const RkSharedDel = () => <RkNotice bar="입장권" icon="close" tone="gray" title={<>공유받은 입장권이<br />삭제됐어요</>}
  desc="공유해준 분이 예약을 취소해서 이 입장권도 함께 사라졌어요."
  rows={[['매장', RK_CLUB], ['이용 날짜', '07월 23일 (수)'], ['상태', '원본 예약 취소로 삭제']]}
  bullets={['공유해준 분의 개인정보는 표시하지 않아요.', '같은 예약으로는 다시 받을 수 없어요.']}
  actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow(RK.tkTab)}>확인</button>
    <button className="vb" style={{ flex: 1.4 }} onClick={() => goRow(RK.nearby)}>주변 클럽 보기</button></>} />;

/* RSV-103 · 예약 정보 변경 — RSV-047 예약 정보 입력과 별개 화면(코드 공유 없음).
   입력 카드 · 스테퍼 · 좌석 배치도 · 시간 칩 · 최소 주문금액 진행 바는 기존 컴포넌트를 그대로 쓴다.
   RSV-094에서 고른 항목만 수정할 수 있고 나머지는 잠긴다. */
const RK_CHG_KEY = 'vybe_chg_menu';
const RK_TIMES = [['오후 7:30', 1], ['오후 8:00'], ['오후 8:30'], ['오후 9:00'], ['오후 9:30'], ['오후 10:00']];
const RK_BADGE = { 인원: <Badge s="entered">무료</Badge>, 메뉴: <Badge s="pending">패널티 발생</Badge>, 테이블: <Badge s="pending">패널티 발생</Badge>, 도착시간: <Badge s="pending">1회 무료</Badge> };
const RK_WAS = { people: 3, table: 'T4', time: '오후 8:00', menuSum: 700000 };
/* 변경 전 → 변경 후 */
const RkWas = ({ a, b }) => <><span style={{ color: 'var(--g500)' }}>{a}</span> → <span style={{ color: 'var(--lime500)' }}>{b}</span></>;
/* 잠긴 항목 — 기존 값만 보여 주고 펼치지 않는다 */
const RkLockRow = ({ ic, label, value }) => <div className="gcard" style={{ padding: 0, opacity: .5 }}>
  <div className="acc-h" style={{ cursor: 'default' }}><span className="gtile"><Icon n={ic} s={18} /></span>
    <span className="lb"><small>{label}</small><b>{value}</b></span>
    <Icon n="lock" s={18} style={{ color: 'var(--g600)' }} /></div></div>;
/* 수정 가능한 항목 — 기존 아코디언 카드(.gcard · .acc-h · .acc)에 규정 배지를 더한 형태 */
const RkEditRow = ({ ic, label, value, badge, open, onToggle, children }) => <div className="gcard" style={{ padding: 0, boxShadow: '0 0 0 1px rgba(119,49,254,.55)' }}>
  <button className="acc-h" onClick={onToggle} aria-expanded={open}><span className="gtile"><Icon n={ic} s={18} /></span>
    <span className="lb"><small>{label}</small><b>{value}</b></span>{badge}
    <Icon n="chevD" s={20} style={{ color: 'var(--g500)', transition: 'transform .34s var(--e-out)', transform: open ? 'rotate(180deg)' : 'none' }} /></button>
  <div className={cx('acc', open && 'open')}><div><div className="acc-c">{children}</div></div></div></div>;

function RkChangeForm({ sel = ['인원'], open: open0 = null, people: p0 = RK_WAS.people, table: tb0 = RK_WAS.table, time: tm0 = RK_WAS.time, menu: menu0 = false }) {
  const [open, setOpen] = rkS(open0);
  const [people, setPeople] = rkS(p0);
  const [table, setTable] = rkS(tb0);
  const [time, setTime] = rkS(tm0);
  const [menu] = rkS(menu0);
  const can = (k) => sel.includes(k);
  const tog = (k) => setOpen((o) => (o === k ? null : k));
  const cap = table[0] === 'R' ? 10 : 4; /* 테이블 2~4명 · 룸 4명 이상 */
  const d = { 인원: people !== RK_WAS.people, 테이블: table !== RK_WAS.table, 도착시간: time !== RK_WAS.time, 메뉴: !!menu };
  const dirty = ['인원', '테이블', '도착시간', '메뉴'].some((k) => can(k) && d[k]);
  const menuSum = menu === 'up' ? 900000 : menu === 'down' ? 600000 : RK_WAS.menuSum;
  /* 테이블은 룸 · 높은 번호가 상향, 낮은 번호가 하향 (시안 예시 테이블-4 → 테이블-2 = 하향) */
  const tbUp = d.테이블 && (table[0] === 'R' || +table.slice(1) > +RK_WAS.table.slice(1));
  const down = (can('테이블') && d.테이블 && !tbUp) || (can('메뉴') && menu === 'down');
  const up = (can('테이블') && tbUp) || (can('메뉴') && menu === 'up');
  const next = () => goRow(down ? 'rc-05' : up ? RK.upPay : 'rc-08');
  const toMenu = () => { try { localStorage.setItem(RK_CHG_KEY, '1'); } catch (e) {} goRow('rm-01'); };
  return <Phone bd="aurora" top={<AppBar title={RK_CLUB} onBack={() => goRow('rc-04')} />} botH={128}
    bottom={<Bottom cap={dirty ? null : '변경할 내용을 선택해 주세요'}>
      <button className="vb s" style={{ flex: 1 }} onClick={() => goRow(RK.resvDet)}>취소</button>
      <button className="vb" style={{ flex: 2 }} disabled={!dirty} onClick={next}>변경 내용 확인</button></Bottom>}>
    <div className="pad" style={{ paddingTop: 8, paddingBottom: 24 }}>
      <div className="t-tag cl">예약 변경</div>
      <div className="ibn purple" style={{ marginTop: 12 }}><i />당일 영업 시작 전 구간 · 이번 변경은 1회차 무료</div>
      <div className="stack" style={{ gap: 24, margin: '18px 0 20px', opacity: .5, pointerEvents: 'none' }}>
        <Field label="예약자명" value="홍길동" onChange={() => {}} />
        <Field label="연락처" value="010-1234-1234" onChange={() => {}} />
      </div>
      <div className="stack" style={{ gap: 10 }}>
        <RkLockRow ic="cal" label="날짜" value="07월 23일 (수)" />
        {can('인원')
          ? <RkEditRow ic="user" label="인원" badge={RK_BADGE.인원} open={open === 'people'} onToggle={() => tog('people')}
              value={d.인원 ? <RkWas a={RK_WAS.people + '명'} b={people + '명'} /> : people + '명'}>
              <div style={{ display: 'flex', justifyContent: 'center', padding: '6px 0 10px' }}><Stepper big v={people} min={1} max={cap} unit="명" onChange={setPeople} /></div>
              <div className="t-cap c4" style={{ textAlign: 'center', lineHeight: '24px' }}>{tableName(table)} 수용 인원 {cap}명까지 바꿀 수 있어요</div>
            </RkEditRow>
          : <RkLockRow ic="user" label="인원" value={people + '명'} />}
        {can('테이블')
          ? <RkEditRow ic="table" label="테이블" badge={RK_BADGE.테이블} open={open === 'table'} onToggle={() => tog('table')}
              value={d.테이블 ? <RkWas a={tableName(RK_WAS.table)} b={tableName(table)} /> : tableName(table)}>
              <FloorPlan sel={table} onSel={(id) => { setTable(id); setOpen(null); }} />
            </RkEditRow>
          : <RkLockRow ic="table" label="테이블" value={tableName(table)} />}
        {can('도착시간')
          ? <RkEditRow ic="clock" label="도착 시간" badge={RK_BADGE.도착시간} open={open === 'time'} onToggle={() => tog('time')}
              value={d.도착시간 ? <RkWas a={RK_WAS.time} b={time} /> : time}>
              <div className="chips">{RK_TIMES.map(([x, dis]) => <button key={x} disabled={!!dis} className={cx('chip', time === x && 'on')} onClick={() => { setTime(x); setOpen(null); }}>{x}</button>)}</div>
            </RkEditRow>
          : <RkLockRow ic="clock" label="도착 시간" value={time} />}
        <div className="gcard" style={{ padding: 0, boxShadow: can('메뉴') ? '0 0 0 1px rgba(119,49,254,.55)' : 'none', opacity: can('메뉴') ? 1 : .5 }}>
          <button className="acc-h" onClick={can('메뉴') ? toMenu : undefined} style={can('메뉴') ? null : { cursor: 'default' }}>
            <span className="gtile"><Icon n="doc" s={18} /></span>
            <span className="lb"><small>사전 주문</small><b>{d.메뉴 ? <RkWas a={won(RK_WAS.menuSum) + '원'} b={won(menuSum) + '원'} /> : 'HARD SET A 외 1건 · ' + won(menuSum) + '원'}</b></span>
            {can('메뉴') ? RK_BADGE.메뉴 : null}
            <Icon n={can('메뉴') ? 'chevR' : 'lock'} s={20} style={{ color: 'var(--g500)' }} /></button>
          <div style={{ padding: '0 16px 16px' }}><MinGauge min={500000} cur={menuSum} /></div></div>
      </div>
      <div className="t-cap c4" style={{ lineHeight: '24px', marginTop: 12 }}>변경할 항목으로 고르지 않은 정보는 바꿀 수 없어요 · 예약자명 · 연락처 · 날짜는 변경 대상이 아니에요</div>
    </div></Phone>;
}

Object.assign(window, { RkChangeForm, RkFreeCancel, RkDeduct, RkNoRefund, RkChangePick, RkChangeDown, RkNoChange, RkChangeFee, RkChangeDone, RkStoreCancel, RkRefund, RkEntryLock, RkSharedDel, RkNotice, RkAmt, RkSummary, RkStep3 });
