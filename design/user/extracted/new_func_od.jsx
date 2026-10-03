/* global React, cx, won, Icon, Phone, AppBar, Bottom, Badge, Meta, Sheet, Dialog, MenuThumb, MENU, OPT, goRow, useToast, CLUB_IMG */
/* 비대면 오더 v1 — 주문 완료 · 주문 상태 · 주문 상세 · 영수증 · 예외 상태
   메뉴 선택(od-01/02)과 결제(od-04)는 테이블 예약 화면을 그대로 재사용한다. */
const { useState: odS, useEffect: odE } = React;
const OCLUB = '어썸레드';
const OLINES = [{ id: 'hardA', q: 1, o: 1 }, { id: 'hardB', q: 1, o: 0 }];
const OPRICE = (l) => (MENU[l.id].pr + (l.o ? OPT.pr : 0)) * l.q;
const OTOTAL = OLINES.reduce((a, l) => a + OPRICE(l), 0);
const OCNT = OLINES.reduce((a, l) => a + l.q, 0);

/* 상태 → 색 매핑(design_system_v2 #v2-state) · 결제완료·만드는중은 퍼플, 픽업대기는 라임 + 글로우 */
const OST = {
  paid: { i: 0, lay: 'p', ic: 'p', icn: 'check', b: <Badge s="waiting" dot>결제 완료</Badge>, msg: '주문이 접수됐어요', sub: '매장에서 주문을 확인하고 있어요' },
  making: { i: 1, lay: 'p', ic: 'p', icn: 'bottle', b: <Badge s="waiting" dot>만드는 중</Badge>, msg: '지금 만들고 있어요', sub: '준비되면 바로 알려드릴게요 · 예상 5분' },
  ready: { i: 2, lay: 'l', ic: 'l', icn: 'bell', b: <Badge s="called">픽업해 주세요</Badge>, msg: <>바 카운터에서 <em>주문번호</em>를 보여주세요</>, sub: '10분 안에 픽업해 주세요' },
  done: { i: 3, lay: 'g', ic: '', icn: 'check', b: <Badge s="entered">픽업 완료</Badge>, msg: '픽업이 완료됐어요', sub: '이용 내역에서 영수증을 볼 수 있어요' },
};
const OSTEPS = ['결제 완료', '만드는 중', '픽업 대기'];
function OStep({ cur }) {
  return <div className="stepi n3"><i className="fill" style={{ width: Math.min(cur, 2) / 3 * 100 + '%' }} />
    {OSTEPS.map((s, i) => <div key={s} className={cx(i < cur && 'past', i === cur && 'cur')}>{s}</div>)}</div>;
}
function OLineRows({ lines = OLINES }) {
  return <>{lines.map((l) => { const m = MENU[l.id]; return <div key={l.id} className="mrow"><MenuThumb m={m} />
    <div className="tx"><div className="nm">{m.nm}</div>{l.o ? <div className="ds">{OPT.nm} (+{won(OPT.pr)}원)</div> : null}<div className="pr">{won(OPRICE(l))}원 · {l.q}개</div></div></div>; })}</>;
}

/* OD-05 결제 완료 — 52 예약 완료 화면과 같은 구성(succ → 문구 → 티켓 → 결제 내역) */
function OrderDone({ no = '017' }) {
  return <Phone bd="aurora" top={<AppBar title="결제 완료" noBack />} botH={102}
    bottom={<Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('file:[v1]CLUB-021.html')}>확인</button><button className="vb" style={{ flex: 2 }} onClick={() => goRow('od-06')}>주문 상태 보기</button></Bottom>}>
    <div className="pad" style={{ paddingTop: 20, paddingBottom: 18 }}>
      <div className="succ"><svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5L20 7" /></svg></div>
      <div className="t-h3 fade-up" style={{ textAlign: 'center', marginTop: 20, animationDelay: '.3s' }}>주문이 접수되었어요</div>
      <div className="t-b4 c3 fade-up" style={{ textAlign: 'center', marginTop: 10, animationDelay: '.35s' }}>준비가 끝나면 알림으로 알려드릴게요</div>
      <div className="tk cmp fade-up" style={{ marginTop: 20, animationDelay: '.42s' }}>
        <div className="tk-h"><i className="tk-hl p on" />
          <div><div className="club">{OCLUB} <Badge s="waiting" dot>결제 완료</Badge></div><div className="sub">테이블-4 · 오후 9:12 · 비대면 주문</div></div></div>
        <div className="tk-cut" /><div className="tk-b"><div className="tk-lbl">주문번호</div><div className="tk-num">{no}</div>
          <div className="tk-stats" style={{ marginBottom: 0 }}><div><div className="k">메뉴</div><div className="v">{OCNT}개</div></div><div><div className="k">픽업</div><div className="v">바 카운터</div></div><div><div className="k">결제</div><div className="v">{won(OTOTAL)}</div></div></div></div></div>
      <div className="gcard fade-up" style={{ marginTop: 12, animationDelay: '.5s' }}><div className="shead" style={{ marginBottom: 4 }}><span className="tt">결제 내역</span></div>
        {[['총 결제 금액', won(OTOTAL) + '원'], ...OLINES.map((l) => [MENU[l.id].nm, won(OPRICE(l))])].map(([a, b], i) => <div key={a} className="kv" style={i ? { padding: '8px 0', fontSize: 13 } : { fontWeight: 600 }}><span style={i ? null : { color: '#fff' }}>{a}</span><b style={i ? null : { fontWeight: 700 }}>{b}</b></div>)}</div>
    </div></Phone>;
}

/* OD-06 주문 상태 · 진행 중 주문 여러 건(세로 카드 목록) */
const OMULTI = [
  { no: '017', st: 'ready', cnt: 2, at: '오후 9:12', lines: OLINES },
  { no: '021', st: 'making', cnt: 1, at: '오후 9:38', lines: [{ id: 'lemon', q: 1, o: 0 }] },
  { no: '024', st: 'paid', cnt: 3, at: '오후 9:51', lines: [{ id: 'hardAB', q: 1, o: 0 }, { id: 'lemon', q: 2, o: 0 }] },
];
const OLS = (o) => o.lines || OLINES;
const OSUM = (o) => { const ls = OLS(o); return MENU[ls[0].id].nm + (ls.length > 1 ? ` 외 ${ls.length - 1}건` : ''); };
const OAMT = (o) => OLS(o).reduce((a, l) => a + OPRICE(l), 0);

/* PW-O-2 주문 탭 상태 카드 — od-06 구성(히어로 + 3단계 스텝)을 주문 건별 카드로 */
function OrderStatusCard({ o, onOpen }) {
  const c = OST[o.st];
  return <button className={cx('ocard', o.st === 'ready' && 'ready')} onClick={onOpen}>
    <div className={cx('oh', o.st !== 'ready' && 'p')}>
      {['p', 'l', 'a', 'g'].map((k) => <i key={k} className={cx('lay', k, c.lay === k && 'on')} />)}
      <div><div className={cx('oh-ic', c.ic)}><Icon n={c.icn} s={22} sw={2.2} /></div>
        <div style={{ marginTop: 12 }}>{c.b}</div>
        <div className="k">주문번호</div><div className="num">{o.no}</div>
        <div className="msg">{c.msg}</div><div className="sub">{c.sub}</div></div></div>
    <div className="ostepw"><OStep cur={c.i} /></div>
    <div className="ofoot"><span className="nm">{OSUM(o)} · {o.cnt}개</span><b>{won(OAMT(o))}원</b></div>
    <div className="ofoot"><span>{o.at} 주문</span><span className="arr">주문 상세<Icon n="chevR" s={16} /></span></div>
  </button>;
}
function OrderCard({ o, onOpen }) {
  const c = OST[o.st];
  return <button className={cx('ochip', o.st === 'ready' && 'ready', o.st === 'paid' && 'pend')} onClick={onOpen}>
    <i /><span className="tx">주문번호 {o.no} · {o.cnt}개 · <b>{o.st === 'ready' ? '픽업해 주세요' : o.st === 'making' ? '만드는 중' : '결제 완료'}</b></span>
    <span className="arr"><Icon n="chevR" s={18} /></span></button>;
}
function OrderStatus({ st: st0 = 'paid', multi = false, no = '017' }) {
  const [st, setSt] = odS(st0);
  const [sel, setSel] = odS(multi ? null : no);
  const c = OST[st];
  const [toast, show] = useToast();
  odE(() => { setSt(st0); }, [st0]);
  const list = <div className="stack" style={{ gap: 10 }}>
    <div className="t-btn2" style={{ color: '#fff' }}>진행 중인 주문 <span className="cl">{OMULTI.length}</span></div>
    {OMULTI.map((o, i) => <div key={o.no} className="fade-up" style={{ animationDelay: i * 45 + 'ms' }}><OrderCard o={o} onOpen={() => { setSel(o.no); setSt(o.st); }} /></div>)}
    <div className="fnote" style={{ marginTop: 6 }}><Icon n="info" s={16} /><span>상태는 매장이 바꿔요 · 픽업 순서는 준비가 끝난 주문부터예요</span></div></div>;
  return <Phone bd="ambient" top={<AppBar title="주문 상태" onBack={multi && sel ? () => setSel(null) : undefined} />} botH={110}
    bottom={<Bottom>{st === 'done' ? <><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('od-07')}>주문 상세</button><button className="vb" style={{ flex: 1 }} onClick={() => goRow('od-01')}>추가 주문</button></>
      : <><button className="vb s" style={{ flex: 1 }} onClick={() => goRow(st === 'paid' ? 'oc-01' : 'oc-01#1')}>주문 취소</button><button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('od-07')}>주문 상세</button></>}</Bottom>}
    toastB={112} overlay={toast}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 20 }}>
      {multi && !sel ? list : <>
        {st === 'ready' && <div className="ibn" style={{ background: 'rgba(181,255,96,.14)', border: '1px solid rgba(181,255,96,.35)', color: 'var(--lime500)' }} key="rb"><i style={{ background: 'var(--lime500)', animation: 'v2dot 1.2s infinite' }} />준비 완료 · 지금 픽업할 수 있어요</div>}
        <div className={cx('oh', st === 'ready' && 'ready', st !== 'ready' && 'p')}>
          {['p', 'l', 'a', 'g'].map((k) => <i key={k} className={cx('lay', k, c.lay === k && 'on')} />)}
          <div><div className={cx('oh-ic', c.ic)}><Icon n={c.icn} s={24} sw={2.2} /></div>
            <div style={{ marginTop: 14 }}>{c.b}</div>
            <div className="k">주문번호</div><div className="num">{sel || no}</div>
            <div className="msg">{c.msg}</div><div className="sub">{c.sub}</div></div></div>
        <div className="gcard"><OStep cur={c.i} /></div>
        <div className="gcard" style={{ padding: '4px 16px' }}>{[['매장', OCLUB], ['테이블', '테이블-4'], ['주문 시각', '07월 04일 (금) 오후 9:12'], ['결제 금액', won(OTOTAL) + '원']].map(([a, b]) => <div key={a} className="kv"><span>{a}</span><b>{b}</b></div>)}</div>
        <div className="gcard"><div className="shead" style={{ marginBottom: 0 }}><span className="tt">주문 메뉴 {OCNT}개</span><button className="lk" onClick={() => goRow('od-07')}>상세 ›</button></div><OLineRows /></div>
        <div className="fnote"><Icon n="info" s={16} /><span>상태는 매장 관리자 페이지에서 변경돼요 · 바뀌면 알림으로 알려드려요</span></div>
        {multi && <button className="btn s" style={{ width: '100%' }} onClick={() => setSel(null)}>진행 중인 주문 {OMULTI.length}건 모두 보기</button>}
      </>}
    </div></Phone>;
}

/* OD-07 주문 상세 — 메뉴 전체 · 상태 이력 · 결제 정보 · 영수증 */
const OTL = [['결제 완료', '09:12'], ['만드는 중', '09:14'], ['픽업 대기', '09:19'], ['픽업 완료', '09:24']];
function OrderDetail({ st = 'done' }) {
  const cur = OST[st].i;
  return <Phone bd="ambient" top={<AppBar title="주문 상세" />} botH={102}
    bottom={<Bottom>{st === 'done' ? <><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('od-01')}>다시 주문</button><button className="vb" style={{ flex: 1 }} onClick={() => goRow('od-08')}>영수증 보기</button></>
      : <><button className="vb s" style={{ flex: 1 }} onClick={() => goRow(st === 'paid' ? 'oc-01' : 'oc-01#1')}>주문 취소</button><button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('od-08')}>영수증 보기</button></>}</Bottom>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 20 }}>
      <div className="gcard"><div style={{ display: 'flex', gap: 14, alignItems: 'center' }}><img className="thumb" src={CLUB_IMG} alt="" style={{ width: 56, height: 56 }} />
        <div style={{ flex: 1, minWidth: 0 }}><div className="t-h4" style={{ marginBottom: 6 }}>{OCLUB}</div><Meta items={['07월 04일 (금)', '오후 9:12', '테이블-4']} /></div>{OST[st].b}</div>
        <div className="hr" style={{ margin: '14px 0 10px' }} />
        <div className="kv"><span>주문번호</span><b>017</b></div></div>
      <div className="gcard"><div className="shead" style={{ marginBottom: 0 }}><span className="tt">주문 메뉴 {OCNT}개</span></div><OLineRows /></div>
      <div className="gcard"><div className="shead"><span className="tt">상태 이력</span></div>
        <div className="otl">{OTL.map(([n, t], i) => <div key={n} className={cx('r', i < cur && 'done', i === cur && 'cur')}><span className="d" />
          <div><div className="n">{n}</div><div className="t">{i <= cur ? `07.04 ${t}` : '—'}</div></div></div>)}</div></div>
      <div className="gcard" style={{ padding: '4px 16px' }}>{[['결제 수단', '신용카드 · 신한'], ['할부', '일시불'], ['승인번호', '30021845'], ['결제 금액', won(OTOTAL) + '원']].map(([a, b]) => <div key={a} className="kv"><span>{a}</span><b>{b}</b></div>)}</div>
    </div></Phone>;
}

/* OD-08 영수증 */
function Receipt() {
  const [toast, show] = useToast();
  return <Phone bd="ambient" top={<AppBar title="영수증" />} botH={102} toastB={112} overlay={toast}
    bottom={<Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => show('영수증을 저장했어요')}><Icon n="doc" s={18} />저장</button><button className="vb s" style={{ flex: 1 }} onClick={() => show('공유 시트를 열었어요')}><Icon n="share" s={18} />공유</button></Bottom>}>
    <div className="pad" style={{ paddingTop: 8, paddingBottom: 24 }}>
      <div className="rc">
        <div className="ttl">{OCLUB}</div>
        <div className="biz">서울 마포구 양화로 000 · 02-000-0000<br />사업자등록번호 000-00-00000 · 대표 홍길동</div>
        <div className="hrd" />
        <div className="kv2"><span>주문번호</span><b>017</b></div>
        <div className="kv2"><span>주문 일시</span><b>2026-07-04 21:12</b></div>
        <div className="kv2"><span>테이블</span><b>테이블-4</b></div>
        <div className="hrd" />
        {OLINES.map((l) => { const m = MENU[l.id]; return <div key={l.id} className="li"><div><div className="nm">{m.nm}</div>{l.o ? <div className="op">{OPT.nm} +{won(OPT.pr)}</div> : null}<div className="qt">{won(MENU[l.id].pr)} × {l.q}</div></div><div className="pr">{won(OPRICE(l))}</div></div>; })}
        <div className="hrd" />
        <div className="kv2"><span>공급가액</span><b>{won(Math.round(OTOTAL / 1.1))}</b></div>
        <div className="kv2"><span>부가세</span><b>{won(OTOTAL - Math.round(OTOTAL / 1.1))}</b></div>
        <div className="kv2"><span>할인</span><b>0</b></div>
        <div className="hrd" />
        <div className="tot"><span>총 결제 금액</span><b>{won(OTOTAL)}원</b></div>
        <div className="hrd" />
        <div className="kv2"><span>결제 수단</span><b>신용카드 · 신한</b></div>
        <div className="kv2"><span>카드번호</span><b>4092-**-****-1234</b></div>
        <div className="kv2"><span>승인번호</span><b>30021845</b></div>
        <div className="kv2"><span>승인 일시</span><b>2026-07-04 21:12:38</b></div>
      </div>
      <div className="fnote" style={{ marginTop: 14 }}><Icon n="info" s={16} /><span>전자 영수증이며 세금계산서로 사용할 수 없어요</span></div>
    </div></Phone>;
}

/* OD-09 예외 상태 — 빈 상태 · 로딩 · 오류 · 결제 실패 */
function OrderStates({ v = 'empty' }) {
  const bar = { empty: '주문 내역', loading: '주문 상태', error: '주문 상태', fail: '결제하기' }[v];
  const body = {
    empty: <div className="oempty"><div className="ic"><Icon n="bottle" s={28} sw={1.6} /></div>
      <div className="t-h4">아직 주문 내역이 없어요</div><div className="t-b4 c4" style={{ marginTop: 8 }}>입장한 매장에서 바로 주문할 수 있어요</div>
      <button className="btn s" style={{ flex: 'none', margin: '22px auto 0', padding: '0 20px' }} onClick={() => goRow('od-01')}>메뉴 보러 가기</button></div>,
    loading: <div className="stack" style={{ gap: 12, paddingTop: 8 }}>
      <div className="sk" style={{ height: 232 }} /><div className="sk" style={{ height: 68 }} /><div className="sk" style={{ height: 132 }} /><div className="sk" style={{ height: 96 }} /></div>,
    error: <div className="oempty"><div className="ic" style={{ color: 'var(--red500)' }}><Icon n="info" s={28} sw={1.8} /></div>
      <div className="t-h4">주문 상태를 불러올 수 없어요</div><div className="t-b4 c4" style={{ marginTop: 8 }}>네트워크 연결을 확인하고 다시 시도해 주세요</div>
      <button className="btn p" style={{ flex: 'none', margin: '22px auto 0', padding: '0 20px' }} onClick={() => goRow('od-06')}>다시 시도</button></div>,
    fail: <div className="oempty"><div className="ic" style={{ color: 'var(--red500)' }}><Icon n="close" s={28} sw={2.2} /></div>
      <div className="t-h4">결제가 완료되지 않았어요</div><div className="t-b4 c4" style={{ marginTop: 8 }}>카드사 승인이 거절됐어요 (코드 051)<br />다른 결제 수단으로 다시 시도해 주세요</div>
      <div className="gcard" style={{ marginTop: 20, padding: '4px 16px', textAlign: 'left' }}>{[['주문 금액', won(OTOTAL) + '원'], ['결제 수단', '신용카드 · 신한'], ['시도 시각', '오후 9:11']].map(([a, b]) => <div key={a} className="kv"><span>{a}</span><b>{b}</b></div>)}</div></div>,
  }[v];
  return <Phone bd="ambient" top={<AppBar title={bar} />} botH={v === 'fail' ? 102 : 40}
    bottom={v === 'fail' ? <Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('od-03')}>장바구니</button><button className="vb" style={{ flex: 1 }} onClick={() => goRow('od-04')}>다시 결제</button></Bottom> : null}>
    <div className="pad" style={{ paddingBottom: 20 }}>{body}</div>
    {v === 'loading' && <div className="load" style={{ background: 'transparent', alignContent: 'center' }}><div className="spin" /></div>}</Phone>;
}

Object.assign(window, { OrderDone, OrderStatus, OrderDetail, Receipt, OrderStates, OrderCard, OrderStatusCard, OStep, OMULTI, OST, OLS, OSUM, OAMT });
