/* global React */
const { useState, useEffect, useRef, useCallback, useMemo, useLayoutEffect } = React;
const cx = (...a) => a.filter(Boolean).join(' ');
const won = (n) => n.toLocaleString('ko-KR');
const mmss = (s) => `${String(Math.floor(s / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`;
const IMG = 'assets/new_func/';
const CLUB_IMG = 'assets/pass-4.jpg';

const IP = {
  back: 'M15 18l-6-6 6-6', close: 'M6 6l12 12M18 6L6 18', chevD: 'M6 9l6 6 6-6', chevR: 'M9 6l6 6-6 6',
  bell: 'M6 8a6 6 0 1 1 12 0c0 7 3 9 3 9H3s3-2 3-9M10.3 21a1.94 1.94 0 0 0 3.4 0',
  more: 'M12 5h.01M12 12h.01M12 19h.01', cal: 'M4 5h16v15H4zM4 10h16M8 3v4M16 3v4',
  user: 'M20 21a8 8 0 0 0-16 0M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z',
  table: 'M3 8h18M12 8v11M8 19h8M5 8l1.5-3h11L19 8', clock: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 7v5l3 2',
  doc: 'M6 3h12v18l-3-2-3 2-3-2-3 2zM9 8h6M9 12h6', search: 'M11 18a7 7 0 1 0 0-14 7 7 0 0 0 0 14zM20 20l-4-4',
  camera: 'M3 8h4l2-3h6l2 3h4v12H3zM12 17a4 4 0 1 0 0-8 4 4 0 0 0 0 8z',
  trash: 'M4 7h16M10 11v6M14 11v6M5 7l1 13h12l1-13M9 7V4h6v3', pencil: 'M4 20h4L19 9l-4-4L4 16zM13 7l4 4',
  refresh: 'M20 11a8 8 0 1 0-2.3 5.7M20 4v7h-7', check: 'M5 12l5 5L20 7', plus: 'M12 5v14M5 12h14', minus: 'M5 12h14',
  info: 'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 11v5M12 8h.01',
  pin: 'M12 21s-7-6.2-7-11a7 7 0 0 1 14 0c0 4.8-7 11-7 11zM12 12a2 2 0 1 0 0-4 2 2 0 0 0 0 4z',
  home: 'M3 11l9-7 9 7v9a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1z',
  ticket: 'M3 6h18v4a2 2 0 0 0 0 4v4H3v-4a2 2 0 0 0 0-4zM15 6v2M15 11v2M15 16v2',
  share: 'M12 3v13M7 8l5-5 5 5M5 14v6h14v-6', sun: 'M12 16a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4',
  store: 'M3 9l1.5-5h15L21 9M3 9v11h18V9M3 9a3 3 0 0 0 6 0 3 3 0 0 0 6 0 3 3 0 0 0 6 0M9 20v-5h6v5',
  bottle: 'M10 2h4v3l1.5 2.5V21a1 1 0 0 1-1 1h-5a1 1 0 0 1-1-1V7.5L10 5zM8.5 12h7', nav: 'M3 11l18-8-8 18-2-8z', lock: 'M6 11h12v10H6zM8 11V7a4 4 0 0 1 8 0v4',
  cart: 'M6 8h12l-1.2 12.2H7.2L6 8zM9.2 8V5.8a2.8 2.8 0 0 1 5.6 0V8',
};
function Icon({ n, s = 24, sw = 1.8, style }) {
  return <svg width={s} height={s} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={n === 'more' ? 3 : sw} strokeLinecap="round" strokeLinejoin="round" style={style} aria-hidden="true"><path d={IP[n]} /></svg>;
}
const STAR = 'M12 2.5l2.9 6 6.6.9-4.8 4.6 1.2 6.5L12 17.4l-5.9 3.1 1.2-6.5L2.5 9.4l6.6-.9z';
function Stars({ v, s = 20, onPick, pop }) {
  return <span className={cx('stars', pop && 'pop')}>{[0, 1, 2, 3, 4].map((i) => {
    const f = Math.max(0, Math.min(1, v - i));
    return <span key={i + (pop ? '-' + v : '')} style={{ width: s, height: s, cursor: onPick ? 'pointer' : 'default' }}
      onClick={onPick ? (e) => { const r = e.currentTarget.getBoundingClientRect(); onPick(i + (e.clientX - r.left < r.width / 2 ? .5 : 1)); } : undefined}>
      <svg className="bgs" width={s} height={s} viewBox="0 0 24 24"><path d={STAR} fill="currentColor" /></svg>
      <span className="fg" style={{ width: f * 100 + '%' }}><svg width={s} height={s} viewBox="0 0 24 24"><path d={STAR} fill="currentColor" /></svg></span>
    </span>;
  })}</span>;
}

/* ── Hooks ── */
function usePresence(open, ms) {
  const [m, setM] = useState(open); const [out, setOut] = useState(false);
  useEffect(() => {
    if (open) { setM(true); setOut(false); return; }
    if (!m) return; setOut(true);
    const t = setTimeout(() => { setM(false); setOut(false); }, ms); return () => clearTimeout(t);
  }, [open]);
  return [m, out];
}
function useToast() {
  const [t, setT] = useState(null); const tm = useRef([]);
  const show = useCallback((msg) => {
    tm.current.forEach(clearTimeout);
    setT({ msg, k: Date.now(), out: false });
    tm.current = [setTimeout(() => setT((x) => x && { ...x, out: true }), 2100), setTimeout(() => setT(null), 2320)];
  }, []);
  useEffect(() => () => tm.current.forEach(clearTimeout), []);
  const el = t ? <div className="toast-wrap"><div key={t.k} className={cx('toast', t.out && 'out')}><span className="ic" />{t.msg}</div></div> : null;
  return [el, show];
}
function useCountdown(start, on = true) {
  const [s, setS] = useState(start);
  useEffect(() => { if (!on) return; const t = setInterval(() => setS((v) => (v > 0 ? v - 1 : 0)), 1000); return () => clearInterval(t); }, [on]);
  return [s, setS];
}
function useCountUp(v, dur = 600) {
  const [d, setD] = useState(v); const prev = useRef(v);
  useEffect(() => {
    const from = prev.current; prev.current = v; if (from === v) return;
    const t0 = performance.now(); let raf;
    const f = (now) => { const p = Math.min(1, (now - t0) / dur); setD(Math.round(from + (v - from) * (1 - Math.pow(1 - p, 3)))); if (p < 1) raf = requestAnimationFrame(f); };
    raf = requestAnimationFrame(f); return () => cancelAnimationFrame(raf);
  }, [v]);
  return d;
}

/* ── Phone shell ── */
function Phone({ bd = 'ambient', top, topH = 106, bottom, botH = 0, toastB, children, overlay, scrollRef, onScroll }) {
  const ref = useRef(); const [sc, setSc] = useState(false);
  useLayoutEffect(() => { if (scrollRef) scrollRef.current = ref.current; });
  return <div className={`ph bd-${bd}`} style={{ '--topH': topH + 'px', '--botH': botH + 'px', '--toastB': (toastB || botH + 14) + 'px' }}>
    <div className="ph-scroll" ref={ref} onScroll={(e) => { setSc(e.currentTarget.scrollTop > 4); onScroll && onScroll(e); }}>{children}</div>
    {top && <div className={cx('ph-top', sc && 'scrolled')}>{top}</div>}
    {bottom}{overlay}
    <div className="ph-sb"><span>9:41</span><span className="ph-sbi">
      <svg width="18" height="12" viewBox="0 0 18 12" fill="#fff"><rect x="0" y="8" width="3" height="4" rx="1" /><rect x="5" y="5.5" width="3" height="6.5" rx="1" /><rect x="10" y="3" width="3" height="9" rx="1" /><rect x="15" y="0" width="3" height="12" rx="1" /></svg>
      <svg width="16" height="12" viewBox="0 0 16 12" fill="#fff"><path d="M8 2.5c2.3 0 4.4.9 6 2.4l1.2-1.2A10.2 10.2 0 0 0 8 .8C5.2.8 2.7 1.9.8 3.7L2 4.9a8.5 8.5 0 0 1 6-2.4zm0 3.4c1.4 0 2.6.5 3.6 1.4l1.2-1.2A6.8 6.8 0 0 0 8 4.2c-1.9 0-3.5.7-4.8 1.9l1.2 1.2c1-.9 2.2-1.4 3.6-1.4zm0 3.4c-.5 0-1 .2-1.4.6L8 11.3l1.4-1.4A2 2 0 0 0 8 9.3z" /></svg>
      <svg width="27" height="13" viewBox="0 0 27 13"><rect x=".5" y=".5" width="23" height="12" rx="3.5" stroke="rgba(255,255,255,.4)" fill="none" /><rect x="2" y="2" width="20" height="9" rx="2" fill="#fff" /><rect x="25" y="4.5" width="1.6" height="4" rx=".8" fill="rgba(255,255,255,.4)" /></svg>
    </span></div>
    <div className="ph-island" /><div className="ph-home" />
  </div>;
}
function AppBar({ title, right, onBack, noBack }) {
  return <div className="ph-bar">{noBack ? <span style={{ width: 40 }} /> : <button className="gbtn" aria-label="뒤로" onClick={onBack}><Icon n="back" s={22} /></button>}
    <div className="ph-title t-h4">{title}</div><div className="ph-right">{right}</div></div>;
}
function Bottom({ children, cap, sum }) {
  return <div className="ph-bot">{cap && <div className="dis-cap" key={cap}>{cap}</div>}{sum && <div className="bsum">{sum}</div>}<div className="row">{children}</div></div>;
}
/* 하단 탭 — 리퀴드 글래스(홈 화면과 같은 디자인 · html.lg-on) / 기본 UI 두 벌. 프로토타입 · 스토리보드의 UI 전환 토글을 따른다. */
const LG_TICKET = '<path d="M2.6 9.4a2.7 2.7 0 0 1 0 5.2v2.6a2 2 0 0 0 2 2h14.8a2 2 0 0 0 2-2v-2.6a2.7 2.7 0 0 1 0-5.2V6.8a2 2 0 0 0-2-2H4.6a2 2 0 0 0-2 2z" fill="currentColor"/><path d="M13.4 5.4v2M13.4 11v2M13.4 16.6v2" stroke="#1b1526" stroke-linecap="round"/>';
const LG_ICON = {
  home: '<svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linejoin="round"><path d="M3.5 10.2 12 3.2l8.5 7V19.5a1.3 1.3 0 0 1-1.3 1.3H15v-5.6H9v5.6H4.8a1.3 1.3 0 0 1-1.3-1.3z"/></svg>',
  pin: '<svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="2.1"><path d="M12 21.2s-7-6.3-7-11.7a7 7 0 0 1 14 0c0 5.4-7 11.7-7 11.7z"/><circle cx="12" cy="9.6" r="2.5"/></svg>',
  ticket: '<svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linejoin="round">' + LG_TICKET + '</svg>',
  search: '<svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round"><circle cx="10.8" cy="10.8" r="6.6"/><path d="m16 16 4.6 4.6"/></svg>',
  user: '<svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linejoin="round"><circle cx="12" cy="8" r="4.2"/><path d="M4.2 20.4c.8-3.9 4-6.2 7.8-6.2s7 2.3 7.8 6.2z"/></svg>',
};
function TabBar({ alert, active = 'ticket' }) {
  const it = [['home', '홈'], ['pin', '주변'], ['ticket', '패스월렛'], ['search', '검색'], ['user', '내 정보']];
  const TB = { home: 'file:[v1]HOME-005.html', pin: 'file:[v1]PLACE-019.html', ticket: 'pw-01', search: 'file:[v1]HOME-006.html', user: 'file:[v1]MY-029.html' };
  return <>
    <nav className="tabbar">{it.map(([n, l], i) => <button key={n} className={cx(i === 2 && 'center on', i === 2 && alert && 'alert')} onClick={() => goRow(TB[n])}><Icon n={n} s={i === 2 ? 26 : 22} />{l}</button>)}</nav>
    <nav className="lg-tabbar">{it.map(([n, l]) => <button key={n} className={cx('lg-tab', n === active && 'on', n === 'ticket' && alert && 'alert')} aria-label={l} onClick={() => goRow(TB[n])} dangerouslySetInnerHTML={{ __html: LG_ICON[n] }} />)}</nav>
  </>;
}
function Segment({ items, value, onChange }) {
  const i = Math.max(0, items.findIndex((x) => x.k === value));
  return <div className="seg" style={{ '--n': items.length, '--i': i }}><span className="seg-th" />
    {items.map((x) => <button key={x.k} className={cx(x.k === value && 'on')} onClick={() => onChange(x.k)}>{x.label}{x.count ? <i>{x.count}</i> : null}</button>)}</div>;
}
const Badge = ({ s, dot, children }) => <span className={cx('v2badge', s)}>{dot && <span className="dot" />}{children}</span>;
const Meta = ({ items }) => <div className="meta">{items.map((t, i) => <React.Fragment key={i}>{i > 0 && <span className="d" />}{t}</React.Fragment>)}</div>;

/* ── Overlays ── */
function Dialog({ open, title, desc, children, actions, onClose }) {
  const [m, out] = usePresence(open, 190); if (!m) return null;
  return <div className={cx('ov', out && 'out')} onClick={(e) => e.target === e.currentTarget && onClose && onClose()}>
    <div className="dlg" role="dialog"><div className="t-h4">{title}</div>{desc && <div className="dlg-d">{desc}</div>}
      {children && <div className="dlg-x">{children}</div>}<div className="dlg-btns">{actions}</div></div></div>;
}
function Sheet({ open, onClose, title, children, footer }) {
  const [m, out] = usePresence(open, 270); const [dy, setDy] = useState(0); const st = useRef(null);
  if (!m) return null;
  const down = (e) => { st.current = e.clientY; e.currentTarget.setPointerCapture(e.pointerId); };
  const move = (e) => { if (st.current != null) setDy(Math.max(0, e.clientY - st.current)); };
  const up = () => { if (st.current == null) return; st.current = null; if (dy > 90) onClose(); else setDy(0); };
  return <div className={cx('sh-ov', out && 'out')} onClick={(e) => e.target === e.currentTarget && onClose()}>
    <div className="sheet" style={{ '--dy': dy + 'px', ...(dy && !out ? { transform: `translateY(${dy}px)`, transition: 'none' } : {}) }}>
      <div className="sh-grab" onPointerDown={down} onPointerMove={move} onPointerUp={up} onPointerCancel={up}><i /></div>
      {title && <div className="sh-head"><span className="t-h4">{title}</span><button className="gbtn sm" onClick={onClose} aria-label="닫기"><Icon n="close" s={16} /></button></div>}
      <div className="sh-body">{children}</div>{footer && <div className="sh-foot">{footer}</div>}
    </div></div>;
}

/* ── Controls ── */
function Stepper({ v, min = 1, max = 10, onChange, big, sm, unit }) {
  return <div className={cx('stp', big && 'big', sm && 'sm')}>
    <button disabled={v <= min} onClick={() => onChange(v - 1)} aria-label="감소"><Icon n="minus" s={18} /></button>
    <span className="n" key={v}>{v}{unit && <small>{unit}</small>}</span>
    <button disabled={v >= max} onClick={() => onChange(v + 1)} aria-label="증가"><Icon n="plus" s={18} /></button></div>;
}
const Check = ({ on, onChange, children, style }) => <button className={cx('vcb', on && 'on')} onClick={() => onChange(!on)} style={style}><i />{children}</button>;
function Field({ label, value, onChange, ph, err, msg, inputMode, onBlur }) {
  return <label className="vtf-f"><span className="vtf-lbl">{label}</span>
    <input className={cx('vtf-in', err && 'err')} value={value} placeholder={ph} inputMode={inputMode} onChange={(e) => onChange(e.target.value)} onBlur={onBlur} />
    {err && <span className="vtf-msg">{msg}</span>}</label>;
}
const Drop = ({ label, value, ph, onClick }) => <button className="vdd" onClick={onClick}><span className="vtf-lbl">{label}</span><span className={cx('vdd-v', !value && 'is-ph')}>{value || ph}<Icon n="chevD" s={20} /></span></button>;
function Gauge({ min, cur }) {
  const ok = cur >= min;
  return <div className={cx('gauge', ok && 'ok')}><div className="r"><span>{ok ? '조건을 채웠어요 ✓' : `최소 주문 ${won(min)}원 중`}</span><b>{won(cur)}원</b></div><div className="bar"><i style={{ width: Math.min(100, cur / min * 100) + '%' }} /></div></div>;
}
function StepI({ steps, cur }) {
  return <div className="stepi"><i className="fill" style={{ width: cur / (steps.length) * 100 + '%' }} />{steps.map((s, i) => <div key={s} className={cx(i < cur && 'past', i === cur && 'cur')}>{s}</div>)}</div>;
}

/* ── QR ── */
const qrCache = {};
function qrPath(seed) {
  if (qrCache[seed]) return qrCache[seed];
  let s = seed >>> 0; const rnd = () => { s = (s + 0x6D2B79F5) >>> 0; let t = s; t = Math.imul(t ^ (t >>> 15), t | 1); t ^= t + Math.imul(t ^ (t >>> 7), t | 61); return ((t ^ (t >>> 14)) >>> 0) / 4294967296; };
  const N = 29, m = [...Array(N)].map(() => Array(N).fill(0));
  const res = (x, y) => (x < 8 && y < 8) || (x >= N - 8 && y < 8) || (x < 8 && y >= N - 8);
  for (let y = 0; y < N; y++) for (let x = 0; x < N; x++) { if (res(x, y)) continue; m[y][x] = y === 6 ? +(x % 2 === 0) : x === 6 ? +(y % 2 === 0) : +(rnd() < .5); }
  const fin = (ox, oy) => { for (let y = 0; y < 7; y++) for (let x = 0; x < 7; x++) m[oy + y][ox + x] = +(x === 0 || y === 0 || x === 6 || y === 6 || (x > 1 && x < 5 && y > 1 && y < 5)); };
  fin(0, 0); fin(N - 7, 0); fin(0, N - 7);
  for (let y = -2; y <= 2; y++) for (let x = -2; x <= 2; x++) m[22 + y][22 + x] = +(Math.max(Math.abs(x), Math.abs(y)) !== 1);
  let d = ''; for (let y = 0; y < N; y++) { let x = 0; while (x < N) { if (m[y][x]) { let l = 1; while (x + l < N && m[y][x + l]) l++; d += `M${x} ${y}h${l}v1h-${l}z`; x += l; } else x++; } }
  return (qrCache[seed] = d);
}
function PassQr({ size = 184, start = 599, seed0 = 7, small }) {
  const [seed, setSeed] = useState(seed0); const [sec, setSec] = useCountdown(start);
  const [rl, setRl] = useState(0); const [spin, setSpin] = useState(false);
  useEffect(() => { if (!rl) return; const t = setTimeout(() => setRl(0), 10000); return () => clearTimeout(t); }, [rl]);
  const refresh = () => { setSpin((x) => !x); setSeed((x) => x + 1); setSec(599); setRl(Date.now()); };
  return <div className={cx('pq', small && 'sm')}>
    <svg key={seed} className="code" viewBox="0 0 29 29" width={size} height={size} shapeRendering="crispEdges" role="img" aria-label="입장 QR 코드"><path fill="#0E0D12" d={qrPath(seed)} /></svg>
    <div className="row">남은 시간 <b className={sec < 60 ? 'warn' : ''}>{mmss(sec)}</b><button className={cx('rf', spin && 'spin')} disabled={!!rl && sec > 0} onClick={refresh} aria-label="QR 새로 받기"><Icon n="refresh" s={15} sw={2.2} /></button></div>
    {sec === 0 && <div className="exp">만료됨 · ↻를 눌러 새로 받기</div>}
  </div>;
}

/* ── Calendar · floor plan ── */
const WD = ['일', '월', '화', '수', '목', '금', '토'];
const CAL = (() => { const c = [{ m: 6, d: 29, dis: 1 }, { m: 6, d: 30, today: 1 }]; for (let d = 1; d <= 31; d++) c.push({ m: 7, d, dis: [11, 18, 19].includes(d) }); c.push({ m: 8, d: 1, dis: 1 }, { m: 8, d: 2, dis: 1 }); return c.map((x, i) => ({ ...x, w: WD[i % 7] })); })();
const dateLabel = (k) => { const c = CAL.find((x) => x.m * 100 + x.d === k); return c ? `${String(c.m).padStart(2, '0')}월 ${c.d}일 (${c.w})` : ''; };
function Calendar({ sel, onSel }) {
  return <div><div className="cal-h"><button disabled aria-label="이전 달"><Icon n="back" s={18} /></button><span>2025년 7월</span><button disabled aria-label="다음 달"><Icon n="chevR" s={18} /></button></div>
    <div className="cal">{WD.map((w) => <div className="w" key={w}>{w}</div>)}
      {CAL.map((c) => { const k = c.m * 100 + c.d; return <button key={k} disabled={!!c.dis} className={cx('d', c.today && 'today', sel === k && 'on')} onClick={() => onSel(k)}>{c.d}</button>; })}</div></div>;
}
const TABLES = [
  { id: 'R1', x: 78, y: 0, w: 56, h: 34, g: 'room', bk: 1 }, { id: 'R2', x: 144, y: 0, w: 56, h: 34, g: 'room', bk: 1 }, { id: 'R3', x: 210, y: 0, w: 56, h: 34, g: 'room' },
  { id: 'R4', x: 8, y: 52, w: 38, h: 64, g: 'room' }, { id: 'T1', x: 80, y: 60, w: 48, h: 48, g: 'tb', bk: 1 }, { id: 'T2', x: 148, y: 60, w: 48, h: 48, g: 'tb', bk: 1 }, { id: 'T3', x: 216, y: 60, w: 48, h: 48, g: 'tb' }, { id: 'R5', x: 298, y: 52, w: 38, h: 64, g: 'room', bk: 1 },
  { id: 'R6', x: 8, y: 138, w: 38, h: 64, g: 'room' }, { id: 'T4', x: 80, y: 146, w: 48, h: 48, g: 'tb' }, { id: 'T5', x: 148, y: 146, w: 48, h: 48, g: 'tb' }, { id: 'T6', x: 216, y: 146, w: 48, h: 48, g: 'tb', bk: 1 }, { id: 'R7', x: 298, y: 138, w: 38, h: 64, g: 'room' },
];
const tableName = (id) => id ? (id[0] === 'R' ? '룸-' : '테이블-') + id.slice(1) : '';
function FloorPlan({ sel, onSel, readOnly }) {
  return <div><div className="fp-lg"><span><i style={{ background: 'var(--purple500)' }} />룸 · 4명 이상</span><span><i style={{ background: 'var(--blue500)' }} />테이블 · 2~4명</span><span><i style={{ background: 'repeating-linear-gradient(45deg,#3a3a3e 0 3px,#2a2a2e 3px 6px)' }} />예약 완료</span></div>
    <div className="fp">{TABLES.map((t) => <button key={t.id} disabled={!!t.bk || readOnly} className={cx('t', t.g === 'tb' && 'rd', t.bk ? 'bk' : t.g === 'room' ? 'av' : 'av2', sel === t.id && 'sel')}
      style={{ left: t.x, top: t.y, width: t.w, height: t.h, opacity: readOnly && sel !== t.id ? .45 : 1 }} onClick={() => onSel && onSel(t.id)}>{t.id}</button>)}</div></div>;
}

/* ── Menu data (shared by 예약·주문) ── */
const MENU = {
  lemon: { nm: 'LEMON DROP', ds: '시그니처 · 6잔', pr: 100000, img: IMG + 'menu_bottle.png', rep: 1 },
  hardA: { nm: 'HARD SET A', ds: 'CHOICE A OPERA BRUIT', pr: 220000, img: IMG + 'menu_bottle.png', rep: 1 },
  hardAB: { nm: 'HARD SET A*B', ds: 'CHOICE A*B OPERA BRUIT', pr: 420000 },
  hardB: { nm: 'HARD SET B', ds: 'CHOICE B HENKELL', pr: 320000 },
};
const OPT = { nm: '레몬 슬라이스 추가 5P', pr: 5500 };
function MenuThumb({ m, cnt }) {
  return <div className="th">{m.img ? <img src={m.img} alt="" /> : <Icon n="bottle" s={28} sw={1.5} />}{cnt ? <span className="cnt" key={cnt}>{cnt}</span> : null}</div>;
}
function goRow(id) { window.dispatchEvent(new CustomEvent('nf-go', { detail: id })); }
/* 흐름을 시작한 진입 화면으로 복귀 — 진행 중 화면(입력 · 결제)을 건너뛴다 */
function goEntry(flow) { window.dispatchEvent(new CustomEvent('nf-entry', { detail: flow })); }

Object.assign(window, { cx, won, mmss, goEntry, IMG, CLUB_IMG, Icon, Stars, usePresence, useToast, useCountdown, useCountUp, Phone, AppBar, Bottom, TabBar, Segment, Badge, Meta, Dialog, Sheet, Stepper, Check, Field, Drop, Gauge, StepI, PassQr, qrPath, Calendar, CAL, dateLabel, FloorPlan, TABLES, tableName, MENU, OPT, MenuThumb, goRow });
