/* global React, cx, won, Icon, Phone, AppBar, Bottom, Stepper, MenuThumb, MENU, goRow */
/* VYBE v1 — 테이블 예약 전용 메뉴 선택 (비대면 오더 MENU-054와 분리한 화면)
   메뉴 행 · 카테고리 칩 · 수량 조절은 기존 컴포넌트를 그대로 쓰고,
   예약 흐름에만 필요한 최소 주문금액 진행 바(MinGauge)를 하단 버튼 위에 더한다. */
const { useState: rvS, useRef: rvR } = React;
const RSV_MIN = 500000;
const RSV_SECS = [['rep', '대표 메뉴', ['lemon', 'hardA']], ['set', 'SET', ['hardA', 'hardAB', 'hardB']], ['hard', 'HARD', ['hardA', 'hardAB', 'hardB']]];

/* 최소 주문금액 진행 바 — 기존 .gauge(퍼플 채움 · 달성 시 라임) 위에 부족 금액 한 줄을 더한 형태 */
function MinGauge({ min = RSV_MIN, cur = 0, style }) {
  const ok = cur >= min;
  const pct = Math.min(100, Math.round((cur / min) * 100));
  return <div className={cx('gauge', ok && 'ok')} style={style}>
    <div className="r"><span style={{ whiteSpace: 'nowrap' }}>최소 주문금액 {won(min)}원</span>
      <b style={{ whiteSpace: 'nowrap' }}>{won(cur)}원</b></div>
    <div className="bar"><i style={{ width: pct + '%' }} /></div>
    <div className="t-cap" style={{ color: ok ? 'var(--lime500)' : 'var(--t4)', lineHeight: '18px', marginTop: 7 }}>
      {pct}% · {ok ? '최소 주문금액을 채웠어요' : cur === 0 ? '메뉴를 담으면 예약을 이어갈 수 있어요' : `${won(min - cur)}원 더 담으면 예약할 수 있어요`}</div>
  </div>;
}

/* RM-01 테이블 예약 · 메뉴 선택 */
function RsvMenuList({ cart: c0 = {}, min = RSV_MIN }) {
  const [cart, setCart] = rvS(c0); const [act, setAct] = rvS('rep');
  const sc = rvR(); const secs = rvR({});
  const n = Object.values(cart).reduce((a, b) => a + b, 0);
  const sum = Object.entries(cart).reduce((a, [k, v]) => a + MENU[k].pr * v, 0);
  const ok = sum >= min;
  const set = (id, q) => setCart((c) => { const x = { ...c }; if (q > 0) x[id] = q; else delete x[id]; return x; });
  const onScroll = (e) => { const y = e.currentTarget.scrollTop + 190; let a = 'rep'; RSV_SECS.forEach(([k]) => { const el = secs.current[k]; if (el && el.offsetTop <= y) a = k; }); setAct(a); };
  const jump = (k) => { const el = secs.current[k]; if (el) sc.current.scrollTo({ top: el.offsetTop - 170, behavior: 'smooth' }); };
  return <Phone bd="aurora" scrollRef={sc} onScroll={onScroll} topH={162} botH={196}
    top={<><AppBar title="사전 주문" right={<button className="gbtn cartg" aria-label="장바구니" onClick={() => goRow('od-03')}><Icon n="cart" s={20} />{n ? <span className="cnt" key={n}>{n}</span> : null}</button>} />
      <div className="hscroll" style={{ padding: '4px 24px 12px' }}>{RSV_SECS.map(([k, l]) => <button key={k} className={cx('chip', act === k && 'on')} onClick={() => jump(k)}>{l}</button>)}</div></>}
    bottom={<Bottom sum={<MinGauge min={min} cur={sum} style={{ flex: 1, background: 'var(--surface)', borderColor: 'var(--cardBorder)', boxShadow: '0 10px 30px rgba(0,0,0,.4)' }} />}>
      <button className="vb" disabled={!ok} onClick={() => {
        /* 예약 변경에서 들어왔으면 RSV-103으로, 신규 예약이면 기존대로 장바구니로 */
        let chg = false; try { chg = localStorage.getItem('vybe_chg_menu') === '1'; if (chg) localStorage.removeItem('vybe_chg_menu'); } catch (e) {}
        goRow(chg ? 'rc-13#4' : 'od-03');
      }}>다음</button></Bottom>}>
    <div className="pad">
      <div className="ibn purple" style={{ marginTop: 14 }}><i />어썸레드 · 07월 23일 (수) 오후 8:00 · 테이블-4 예약</div>
      {RSV_SECS.map(([k, l, ids]) => <section key={k} ref={(el) => (secs.current[k] = el)} style={{ paddingTop: 14 }}>
        <div className="t-h4" style={{ marginBottom: 4 }}>{l}</div>
        {ids.map((id, i) => { const m = MENU[id]; const q = cart[id] || 0; return <div key={id} className="mrow fade-up" style={{ animationDelay: i * 45 + 'ms' }}>
          <button className="tap" style={{ display: 'flex', gap: 12, alignItems: 'center', flex: 1, minWidth: 0 }} onClick={() => goRow('od-02')}><MenuThumb m={m} cnt={q} />
            <div className="tx"><div className="nm">{m.rep && <span className="ttag">대표</span>}{m.nm}</div><div className="ds">{m.ds}</div><div className="pr">{won(m.pr)}원</div></div></button>
          {q ? <Stepper sm v={q} min={0} max={9} onChange={(x) => set(id, x)} />
            : <button className="add" aria-label={m.nm + ' 담기'} onClick={() => set(id, 1)}><Icon n="plus" s={18} sw={2.4} /></button>}</div>; })}</section>)}
      <div className="fnote" style={{ margin: '20px 0 24px' }}><Icon n="info" s={16} /><div><ul>
        <li>· 최소 주문금액은 매장과 좌석 등급에 따라 달라져요. 이 예약은 {won(min)}원 기준이에요.</li>
        <li>· 담은 메뉴는 장바구니에서 다시 확인하고 예약에 담을 수 있어요.</li></ul></div></div>
    </div></Phone>;
}
Object.assign(window, { RSV_MIN, MinGauge, RsvMenuList });
