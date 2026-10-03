/* global React, cx, won, Icon, Phone, AppBar, Bottom, Check, Drop, Sheet, MenuThumb, MENU, OPT, goRow, Gauge, Stepper, RulesH, RulesTabSheet, useToast, Badge */
const { useState: pyS, useEffect: pyE, useRef: pyR } = React;
const METHODS = [['card', '신용카드', ''], ['kakao', '카카오페이', 'kakao'], ['naver', '네이버페이', 'naver'], ['toss', '토스페이', ''], ['payco', '페이코', ''], ['phone', '휴대폰 결제', ''], ['bank', '무통장 입금', ''], ['gift', '상품권', '']];
const CARDS = ['신한', '현대', '비씨', 'KB국민', '삼성', '롯데', '하나', 'NH', '우리', '광주', '씨티', '전북', '카카오뱅크', '케이뱅크'];
const INST = ['일시불', '2개월 (무이자)', '3개월 (무이자)', '4개월', '5개월', '6개월', '7개월', '8개월', '9개월', '10개월', '11개월', '12개월'];
const TERMS_L = [['위 사항을 확인하였으며 구매 진행에 동의합니다.', 1], ['이용 약관에 동의합니다.', 1], ['개인 정보 수집에 동의합니다.', 1], ['이 결제 수단으로 추후 결제 이용에 동의합니다.', 0]];

function Payment({ mode = 'resv', method: m0 = null, card: c0 = null, inst: i0 = '일시불', terms: t0 = [0, 0, 0, 0], sheet: s0 = null, rAgree = false, rOv = false, chg = false, busy: b0 = false }) {
  const [method, setMethod] = pyS(m0); const [card, setCard] = pyS(c0); const [inst, setInst] = pyS(i0);
  const [terms, setTerms] = pyS(t0); const [sheet, setSheet] = pyS(s0); const [busy, setBusy] = pyS(b0);
  const [agreed, setAgreed] = pyS(rAgree); const [rules, setRules] = pyS(rOv); const [hi, setHi] = pyS(0);
  const sc = pyR(); const mref = pyR(); const rref = pyR();
  const resv = mode !== 'order';
  pyE(() => { if (s0 && sc.current && mref.current) sc.current.scrollTop = mref.current.offsetTop - 120; }, []);
  const all = terms.every(Boolean);
  const miss = !method ? '결제 수단을 선택해 주세요' : method === 'card' && !card ? '카드사를 선택해 주세요' : !TERMS_L.every(([, r], i) => !r || terms[i]) ? '필수 약관에 동의해 주세요' : resv && !agreed ? '환불 · 예약 취소 규정을 확인하고 동의해 주세요' : null;
  const bump = () => { if (sc.current && rref.current) sc.current.scrollTo({ top: Math.max(0, rref.current.offsetTop - 120), behavior: 'smooth' }); setHi((x) => x + 1); };
  const pick = (fn, v) => { fn(v); setTimeout(() => setSheet(null), 220); };
  const pay = () => { setBusy(true); setTimeout(() => { setBusy(false); goRow(chg ? 'rc-08' : mode === 'order' ? 'od-05' : 'rs-06'); }, 1400); };
  return <Phone bd="ambient" scrollRef={sc} top={<AppBar title="결제하기" />} botH={124}
    bottom={<Bottom cap={miss}><span style={{ flex: 1, display: 'block' }} onClick={() => { if (miss && resv && !agreed) bump(); }}>
      <button className="vb" disabled={!!miss} style={{ pointerEvents: miss ? 'none' : 'auto' }} onClick={pay}>{chg ? '200,000원' : '545,500원'} 결제하기</button></span></Bottom>}
    overlay={<>
      {resv ? <RulesTabSheet open={rules} onClose={() => setRules(false)} /> : null}
      <Sheet open={sheet === 'card'} onClose={() => setSheet(null)} title="결제할 카드를 선택해 주세요.">{CARDS.map((c) => <button key={c} className={cx('vsi', card === c && 'on')} onClick={() => pick(setCard, c)}>{c}{card === c && <Icon n="check" s={18} sw={2.4} />}</button>)}</Sheet>
      <Sheet open={sheet === 'inst'} onClose={() => setSheet(null)} title="결제 방법을 선택해 주세요.">{INST.map((c) => <button key={c} className={cx('vsi', inst === c && 'on')} onClick={() => pick(setInst, c)}>{c}{inst === c && <Icon n="check" s={18} sw={2.4} />}</button>)}</Sheet>
      {busy && <div className="load" style={{ alignContent: 'center', gap: 18 }}><div className="spin" /><div className="ibn amber"><i />결제를 확인하고 있어요</div></div>}</>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <div className="gcard" style={{ padding: '4px 16px' }}>{(mode === 'order' ? [['매장', '어썸레드'], ['테이블', '테이블-4'], ['주문 시각', '07월 04일 (금) · 오후 9:12'], ['픽업', '바 카운터']] : [['예약자명', '홍길동'], ['연락처', '010-1234-1234'], ['예약 일시', '07월 23일 (수) · 오후 8시'], ['좌석', '테이블-4 · 3명']]).map(([a, b]) => <div key={a} className="kv"><span>{a}</span><b>{b}</b></div>)}</div>
      {chg ? <>
        <div className="gcard"><div className="shead" style={{ marginBottom: 8 }}><span className="tt">메뉴 상향</span><Badge s="entered">무료</Badge></div>
          <div className="tk-stats two" style={{ margin: '4px 0 0' }}>
            <div><div className="k">변경 전</div><div className="v">70만 원</div></div>
            <div><div className="k">변경 후</div><div className="v">90만 원</div></div></div></div>
        <div className="gcard"><div className="shead" style={{ marginBottom: 8 }}><span className="tt">추가 결제</span></div>
          {[['차액', '200,000원'], ['상향 패널티', '없음'], ['변경 처리 수수료 · 1회차', '무료']].map(([a, b]) => <div className="kv" key={a} style={{ padding: '8px 0', fontSize: 14 }}><span>{a}</span><b style={{ fontSize: 14 }}>{b}</b></div>)}
          <div className="hr" style={{ margin: '12px 0' }} />
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}><span className="t-b4 c2">결제 금액</span>
            <b style={{ font: '700 24px var(--f)', letterSpacing: '-.6px' }}>200,000원</b></div></div></>
      : <div className="gcard"><div className="shead" style={{ marginBottom: 0 }}><span className="tt">주문 내역</span><button className="lk" onClick={() => goRow('od-03')}>변경 ›</button></div>
        {[['hardA', 1], ['hardB', 0]].map(([id, o]) => { const m = MENU[id]; return <div key={id} className="mrow"><MenuThumb m={m} /><div className="tx"><div className="nm">{m.nm}</div>{o ? <div className="ds">{OPT.nm} (+{won(OPT.pr)}원)</div> : null}<div className="pr">{won(m.pr + (o ? OPT.pr : 0))}원 · 1개</div></div></div>; })}
        <div style={{ marginTop: 16 }}><div style={{ fontSize: 12, color: 'var(--g400)' }}>결제 금액</div><div style={{ font: '700 28px var(--f)', letterSpacing: '-.7px', margin: '2px 0 4px' }}>545,500원</div></div></div>}
      <div className="gcard" ref={mref}><div className="shead"><span className="tt">결제 수단 선택</span></div>
        <div className="atiles">{METHODS.map(([k, l, i]) => <button key={k} className={cx('atile', method === k && 'on')} onClick={() => setMethod(k)}><i className={i} />{l}</button>)}</div>
        <div className={cx('acc', method === 'card' && 'open')}><div><div className="stack" style={{ gap: 22, paddingTop: 22 }}>
          <Drop label="카드사" value={card} ph="카드사를 선택해 주세요." onClick={() => setSheet('card')} />
          <div><Drop label="할부" value={inst} ph="할부를 선택해 주세요." onClick={() => setSheet('inst')} /><div className="t-cap c4">* 50,000원 이상 무이자 할부 3개월</div></div></div></div></div>
        <div className={cx('acc', method === 'naver' && 'open')}><div><div className="fnote" style={{ marginTop: 18 }}><Icon n="info" s={16} /><div><b style={{ color: 'var(--t2)', fontWeight: 600 }}>네이버페이 이용안내</b><ul>
          <li>· 네이버페이는 네이버ID로 신용카드 또는 은행계좌 정보를 등록하여 결제할 수 있는 간편결제 서비스입니다.</li><li>· 주문 변경 시 카드사 혜택 및 할부 적용 여부는 해당 카드사 정책에 따라 변경될 수 있습니다.</li>
          <li>· 관련 문의는 네이버페이 고객센터(1588-3819)로 연락 부탁드립니다.</li></ul></div></div></div></div>
      </div>
      {resv ? <div ref={rref}><RulesH key={hi} hi={hi > 0} agreed={agreed} onAgree={setAgreed} onFull={() => setRules(true)} /></div> : null}
      <div className="gcard"><Check on={all} onChange={(v) => setTerms(terms.map(() => v))} style={{ fontWeight: 600, color: '#fff', fontSize: 15 }}>전체 동의하기</Check>
        <div className="hr" style={{ margin: '14px 0 6px' }} />
        {TERMS_L.map(([t, r], i) => <div key={t} style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '7px 0 7px 6px' }}>
          <Check on={!!terms[i]} onChange={(v) => setTerms(terms.map((x, j) => (j === i ? v : x)))} style={{ fontSize: 13, flex: 1 }}><span>{t} <span className={r ? 'cl' : 'c4'}>({r ? '필수' : '선택'})</span></span></Check>
          <button onClick={() => goRow('rs-05')} aria-label="약관 보기" style={{ color: 'var(--g600)', display: 'grid' }}><Icon n="chevR" s={18} /></button></div>)}</div>
    </div></Phone>;
}

/* ── 비대면 주문 ── */
const SECTIONS = [['rep', '대표 메뉴', ['lemon', 'hardA']], ['set', 'SET', ['hardA', 'hardAB', 'hardB']], ['hard', 'HARD', ['hardA', 'hardAB', 'hardB']]];
function MenuList({ cart: c0 = {} }) {
  const [cart, setCart] = pyS(c0); const [act, setAct] = pyS('rep'); const sc = pyR(); const secs = pyR({});
  const n = Object.values(cart).reduce((a, b) => a + b, 0); const sum = Object.entries(cart).reduce((a, [k, v]) => a + MENU[k].pr * v, 0);
  const onScroll = (e) => { const y = e.currentTarget.scrollTop + 190; let a = 'rep'; SECTIONS.forEach(([k]) => { const el = secs.current[k]; if (el && el.offsetTop <= y) a = k; }); setAct(a); };
  const jump = (k) => { const el = secs.current[k]; if (el) sc.current.scrollTo({ top: el.offsetTop - 170, behavior: 'smooth' }); };
  return <Phone bd="aurora" scrollRef={sc} onScroll={onScroll} topH={162} botH={102}
    top={<><AppBar title="주문하기" right={<button className="gbtn cartg" aria-label="장바구니" onClick={() => goRow('od-03')}><Icon n="cart" s={20} />{n ? <span className="cnt" key={n}>{n}</span> : null}</button>} /><div className="hscroll" style={{ padding: '4px 24px 12px' }}>{SECTIONS.map(([k, l]) => <button key={k} className={cx('chip', act === k && 'on')} onClick={() => jump(k)}>{l}</button>)}</div></>}
    bottom={<Bottom sum={n ? <><span className="k">담은 메뉴 {n}개</span><span className="v">{won(sum)}원</span></> : null}>
      <button className="vb s" style={{ flex: 1 }} onClick={() => goRow('od-03')}>{`장바구니 ${n}`}</button>
      <button className="vb" style={{ flex: 1 }} disabled={!n} onClick={() => goRow('od-04')}>확인</button></Bottom>}>
    <div className="pad">{SECTIONS.map(([k, l, ids]) => <section key={k} ref={(el) => (secs.current[k] = el)} style={{ paddingTop: 14 }}>
      <div className="t-h4" style={{ marginBottom: 4 }}>{l}</div>
      {ids.map((id, i) => { const m = MENU[id]; return <div key={id} className="mrow fade-up" style={{ animationDelay: i * 45 + 'ms' }}>
        <button className="tap" style={{ display: 'flex', gap: 12, alignItems: 'center', flex: 1, minWidth: 0 }} onClick={() => goRow('od-02')}><MenuThumb m={m} cnt={cart[id]} />
          <div className="tx"><div className="nm">{m.rep && <span className="ttag">대표</span>}{m.nm}</div><div className="ds">{m.ds}</div><div className="pr">{won(m.pr)}원</div></div></button>
        <button className="add" aria-label={m.nm + ' 담기'} onClick={() => setCart((c) => ({ ...c, [id]: (c[id] || 0) + 1 }))}><Icon n="plus" s={18} sw={2.4} /></button></div>; })}</section>)}
      <div className="fnote" style={{ margin: '20px 0 24px' }}><Icon n="info" s={16} /><span>메뉴 항목과 가격은 각 매장 사정에 따라 기재된 내용과 다를 수 있습니다.</span></div></div></Phone>;
}

function OptList({ opts, setOpts }) {
  return <>{opts.map((o, i) => <div key={i} style={{ display: 'flex', alignItems: 'center', padding: '10px 0' }}><Check on={o} onChange={(v) => setOpts(opts.map((x, j) => (j === i ? v : x)))} style={{ flex: 1 }}>{OPT.nm}</Check><b className="t-btn2">+ {won(OPT.pr)}원</b></div>)}</>;
}
function MenuDetail({ opts: o0 = [false, false, false] }) {
  const m = MENU.hardA; const [q, setQ] = pyS(1); const [opts, setOpts] = pyS(o0); const [added, setAdded] = pyS(false); const [toast, show] = useToast();
  const total = (m.pr + opts.filter(Boolean).length * OPT.pr) * q;
  return <Phone bd="aurora" topH={0} top={<div className="ph-bar"><button className="gbtn" aria-label="뒤로" onClick={() => goRow('od-01')}><Icon n="back" s={22} /></button><button className="gbtn" aria-label="공유" onClick={() => show('공유 시트를 열었어요')}><Icon n="share" s={18} /></button></div>}
    botH={102} overlay={toast} bottom={<Bottom><button className="vb" onClick={() => { setAdded(true); setTimeout(() => goRow('od-03'), 700); }}>{added ? <><Icon n="check" s={20} sw={2.4} />담았어요</> : `${won(total)}원 담기`}</button></Bottom>}>
    <div style={{ height: 330, display: 'grid', placeItems: 'center', paddingTop: 70 }}><img src={m.img} alt="" style={{ width: 220, height: 220, borderRadius: 19, objectFit: 'cover', boxShadow: '0 10px 30px rgba(0,0,0,.36)' }} /></div>
    <div className="pad" style={{ paddingTop: 12, paddingBottom: 24 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}><span className="ttag">대표</span><span className="t-h3">{m.nm}</span></div><div className="t-b4 c4" style={{ marginTop: 8 }}>{m.ds}</div>
      <div className="gcard" style={{ marginTop: 20 }}><div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}><span className="t-b3 c2">가격</span><span className="t-h4">{won(m.pr)}원</span></div>
        <div className="hr" style={{ margin: '14px 0' }} /><div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}><span className="t-b3 c2">수량</span><Stepper v={q} min={1} max={9} onChange={setQ} /></div></div>
      <div className="gcard" style={{ marginTop: 12 }}><div className="shead" style={{ marginBottom: 4 }}><span className="tt">추가 옵션</span><span className="t-cap c4">선택</span></div><OptList opts={opts} setOpts={setOpts} /></div>
    </div></Phone>;
}

function Cart({ below = false, mode = 'resv', min = 500000 }) {
  const [lines, setLines] = pyS(below ? [{ id: 'lemon', q: 0.5 }] : [{ id: 'hardA', q: 1, o: [true, false, false] }, { id: 'hardB', q: 1, o: [false, false, false] }]);
  const L = below ? [] : lines; const [edit, setEdit] = pyS(null); const [eo, setEo] = pyS([]);
  const price = (l) => (MENU[l.id].pr + (l.o || []).filter(Boolean).length * OPT.pr) * l.q;
  const total = L.reduce((a, l) => a + price(l), 0);
  const upd = (i, p) => setLines((a) => a.map((l, j) => (j === i ? { ...l, ...p } : l)));
  const od = mode === 'order';
  return <Phone bd="ambient" top={<AppBar title="장바구니" />} botH={124}
    bottom={<Bottom cap={!od && total < min ? `최소 주문 ${won(min)}원을 채워 주세요` : null}><button className="vb" disabled={!od && total < min} onClick={() => { let chg = false; try { chg = localStorage.getItem('vybe_chg_menu') === '1'; if (chg) localStorage.removeItem('vybe_chg_menu'); } catch (e) {} goRow(od ? 'od-04' : chg ? 'rc-13#4' : 'rs-01'); }}>{won(total)}원 {od ? '결제하기' : '예약에 담기'}</button></Bottom>}
    overlay={<Sheet open={edit != null} onClose={() => setEdit(null)} title="옵션 변경" footer={<button className="vb" onClick={() => { upd(edit, { o: eo }); setEdit(null); }}>변경하기</button>}><OptList opts={eo} setOpts={setEo} /></Sheet>}>
    <div className="pad" style={{ paddingTop: 8, paddingBottom: 24 }}>
      {od ? <div className="ibn purple" style={{ marginBottom: 12 }}><i />어썸레드 · 테이블-4 에서 바로 주문해요</div> : <><Gauge min={min} cur={total} /><div className="t-cap c4" style={{ marginBottom: 8 }}>테이블-4 · 최소 주문금액 {won(min)}원</div></>}
      {L.length === 0 && <div className="t-b4 c4" style={{ textAlign: 'center', padding: '40px 0' }}>담은 메뉴가 없어요</div>}
      {L.map((l, i) => { const m = MENU[l.id]; return <div key={l.id} className="gcard fade-up" style={{ marginBottom: 10, animationDelay: i * 45 + 'ms' }}>
        <div style={{ display: 'flex', gap: 12 }}><MenuThumbWrap m={m} /><div style={{ flex: 1, minWidth: 0 }}><div style={{ display: 'flex', justifyContent: 'space-between', gap: 8 }}><div className="t-btn1">{m.nm}</div>
          <button onClick={() => setLines((a) => a.filter((_, j) => j !== i))} aria-label="삭제" style={{ color: 'var(--g500)', display: 'grid' }}><Icon n="close" s={18} /></button></div>
          {(l.o || []).some(Boolean) && <div className="t-cap c4">{OPT.nm} (+{won(OPT.pr)}원)</div>}<div className="t-h4" style={{ marginTop: 6 }}>{won(price(l))}원</div></div></div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 14 }}><button className="btn s" style={{ flex: 'none', height: 40, padding: '0 14px', fontSize: 14 }} onClick={() => { setEo(l.o || [false, false, false]); setEdit(i); }}>옵션 변경</button>
          <Stepper v={l.q} min={1} max={9} onChange={(q) => upd(i, { q })} /></div></div>; })}
      <button className="btn s" style={{ width: '100%', marginTop: 4 }} onClick={() => goRow(od ? 'od-01' : 'rm-01')}><Icon n="plus" s={16} />더 담으러 가기</button>
    </div></Phone>;
}
const MenuThumbWrap = ({ m }) => <div className="mrow" style={{ padding: 0, border: 0, width: 'auto' }}><MenuThumb m={m} /></div>;
Object.assign(window, { Payment, MenuList, MenuDetail, Cart });
