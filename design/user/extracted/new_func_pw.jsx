/* global React, cx, won, mmss, Icon, Stars, usePresence, useToast, useCountUp, useCountdown, Phone, TabBar, Segment, Badge, Meta, Dialog, Sheet, Stepper, PassQr, goRow, CLUB_IMG */
const { useState: pwS, useEffect: pwE, useRef: pwR } = React;
const CLUB = '어썸레드';

function TkHead({ layer, ink, badge, sub, club = CLUB }) {
  return <div className="tk-h">{['p', 'l', 'a', 'g', 'e'].map((k) => <i key={k} className={cx('tk-hl', k, layer === k && 'on')} />)}
    <div><div className="club">{club} {badge}</div><div className="sub">{sub}</div></div></div>;
}
function TkStub({ kind, code }) {
  return <div className="tk-stub"><div><span className="k">{kind}</span><span className="c">{code}</span></div><span className="bar" aria-hidden="true" /></div>;
}
function QrSlot({ open, lockText, blur, h = 158 }) {
  if (!open) return <div className="tk-qr sm" style={{ height: h }}>
    <div className="qr-bl" aria-hidden="true"><PassQr small size={104} /></div>
    <div className="qr-msg"><span><Icon n="lock" s={14} />{lockText}</span></div></div>;
  return <div className="tk-qr sm" style={{ height: h }}><div><PassQr small size={104} /></div></div>;
}

/* ── 웨이팅 티켓 ── */
const W = {
  waiting: { L: 'p', b: <Badge s="waiting" dot>대기 중</Badge>, sub: '07월 04일 금요일 · 오후 8:12 · 입장 대기 중' },
  called: { L: 'l', ink: 1, b: <Badge s="called">입장 순서</Badge>, sub: '지금 입장할 수 있어요 · 10분 안에 입구로 와주세요' },
  entered: { L: 'e', b: <Badge s="entered">입장 완료</Badge>, sub: '입장이 완료됐어요. 재 입장시 직원에게 QR을 보여주세요.' },
  expired: { L: 'g', done: 1, b: <Badge s="done">입장 시간 지남</Badge>, sub: '호출 후 10분 안에 입장하지 않아 취소됐어요' },
  canceled: { L: 'g', done: 1, b: <Badge s="done">취소됨</Badge>, sub: '07월 04일 금요일 · 오후 8:40 · 웨이팅 취소' },
};
/* fee = 1인 입장비(0이면 입장비 없는 클럽) · share = 공유하기 버튼 노출 · shared = 공유받은 입장권 */
function WaitTicket({ st, shift, atBack, onPost, onCancel, onDelete, club = CLUB, base = 5, ahd = 2, total = 14, dist = '550m', stamp = 'AWSOME RED', fee = 0, people = 2, payMethod = '신용카드 · 신한', shared = false, share = false, onReceipt, onShare = () => goRow('sh-02') }) {
  const c = W[st]; const num = useCountUp(atBack ? total : base + shift); const ahead = atBack ? total - 1 : ahd + shift; const aheadN = useCountUp(ahead);
  const [left] = useCountdown(600, st === 'called');
  const feeRow = fee ? <button className="tk-link" onClick={onReceipt}>입장비 {won(fee * people)}원 결제 완료 · 영수증 보기 ›</button> : null;
  return <><div className={cx('tk cmp', c.ink && 'ink', st === 'called' && 'glow', st === 'entered' && 'ent', c.done && 'done')}>
    <TkHead layer={c.L} badge={shared ? <Badge s="entered">공유받음</Badge> : c.b} sub={shared ? '공유받은 입장권 · 07월 04일 금요일 · 오후 9:02 발급' : c.sub} club={club} /><div className="tk-cut" />
    <div className="tk-b">
      {st === 'entered' ? <>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 22, padding: '2px 0 0' }}>
          <div className="stamp"><span className="t">{stamp}</span><span className="m">ENTERED</span><span className="b">20:32</span></div>
          <div className="tk-stats two" style={{ margin: 0 }}><div><div className="k">대기 시간</div><div className="v">20:00</div></div><div><div className="k">인원</div><div className="v">{people}명</div></div></div>
        </div>
        <div className="tk-qr sm" style={{ marginTop: 6, height: 148 }}><div><PassQr small size={104} seed0={21} /></div></div>
        <div className="tk-note">{shared ? '공유받은 입장권 · 입장 시 직원에게 QR을 보여주세요' : '입장 시 직원에게 QR을 보여주세요'}</div>
        {feeRow}
        <button className="tk-link" onClick={() => goRow('pw-09')}>후기 작성하기 ›</button>
        {share && shared ? <div className="tk-note" style={{ margin: '0 0 8px' }}>공유받은 입장권은 다시 공유할 수 없어요</div> : null}
      </> : <>
        <div className="tk-lbl">{st === 'waiting' ? '앞에 남은 팀' : c.done ? '대기 번호' : '현재 대기 번호'}</div>
        <div className="tk-num">{st === 'waiting' ? aheadN : num}<small>{st === 'waiting' ? '팀' : '번'}</small></div>
        {st === 'waiting' && <><div className="tk-stats"><div><div className="k">예상 대기시간</div><div className="v">20:00</div></div><div><div className="k">남은 거리</div><div className="v">{dist}</div></div><div><div className="k">인원</div><div className="v">{people}명</div></div></div>
          <div className="tk-note" style={{ margin: '0 0 10px' }}>매장 상황에 따라 달라질 수 있어요</div></>}
        {st === 'called' && <div className="tk-stats"><div><div className="k">입장 마감까지</div><div className={cx('v live', left < 60 && 'warn')}>{mmss(left)}</div></div><div><div className="k">인원</div><div className="v">{people}명</div></div><div><div className="k">남은 거리</div><div className="v">120m</div></div></div>}
        {feeRow}
        {c.done && <div className="tk-stats two"><div><div className="k">인원</div><div className="v">{people}명</div></div><div><div className="k">{st === 'expired' ? '호출 시각' : '등록 시각'}</div><div className="v">오후 {st === 'expired' ? '8:32' : '8:12'}</div></div></div>}
        {!c.done && <><QrSlot open={st === 'called'} lockText="입장 순서가 되면 QR이 표시돼요" />
          {st === 'called' && <div className="tk-note">입장 시 직원에게 QR을 보여주세요</div>}
          {share ? <div className="tk-note" style={{ margin: '2px 0 8px' }}>입장 완료 후에 공유하기가 활성화돼요</div> : null}</>}
      </>}
      <TkStub kind="ENTRY PASS" code={`WT-2607-${String(base + shift).padStart(4, '0')}`} />
    </div></div>
    {st === 'entered' ? <div className="tk-acts">
      {shared ? <button className="btn s" onClick={() => goRow('pw-09')}>후기 작성하기</button> : <button className="btn s" onClick={onShare}><Icon n="share" s={16} />공유하기</button>}
      <button className="btn p" onClick={() => goRow('od-01')}>주문하기</button></div>
      : c.done ? <div className="tk-acts">{st === 'expired' && <button className="btn s" onClick={onDelete}>제거하기</button>}<button className="btn p" onClick={() => goRow('pw-01')}>다시 등록하기</button></div>
      : <div className="tk-acts"><button className="btn s" onClick={onCancel}>웨이팅 취소하기</button><button className="btn p" onClick={onPost}>순서 미루기</button></div>}</>;
}

/* ── 입장권 덱 (여러 클럽 가로 스와이프) ── */
const EXTRA = [{ club: '홍대 클럽 레이저', st: 'waiting', shift: 0, base: 12, ahd: 6, total: 19, dist: '1.2km', stamp: 'CLUB LASER' }, { club: '버뮤다', st: 'entered', shift: 0, base: 3, ahd: 0, total: 6, dist: '80m', stamp: 'BERMUDA' }];
const SW = 312;
function TicketDeck({ items, idx, onIdx, label = '내 입장권' }) {
  const ref = pwR(); const n = items.length;
  const upd = () => {
    const el = ref.current; if (!el) return;
    [...el.children].forEach((s) => { const d = Math.max(-1, Math.min(1, (s.offsetLeft + s.offsetWidth / 2 - el.scrollLeft - el.clientWidth / 2) / SW)); const a = Math.abs(d);
      s.style.transform = `perspective(900px) rotateY(${d * -9}deg) scale(${1 - a * .07})`; s.style.opacity = 1 - a * .45; });
    const i = Math.max(0, Math.min(n - 1, Math.round(el.scrollLeft / SW))); if (i !== idx) onIdx(i);
  };
  pwE(() => { upd(); }, [n]);
  const go = (j) => ref.current && ref.current.scrollTo({ left: j * SW, behavior: 'smooth' });
  return <><div className="deck-top"><span className="t-btn2">{label} <span className="cl">{n}</span></span>
    {n > 1 && <div className="deck-dots">{items.map((_, j) => <button key={j} className={cx(j === idx && 'on')} onClick={() => go(j)} aria-label={`${j + 1}번째 입장권`} />)}</div>}</div>
    <div className={cx('deck', n > 1 && 'nudge')} ref={ref} onScroll={upd}>{items.map((it, j) => <div key={j} className={cx('deck-s', j === idx && 'on')} onClick={j !== idx ? () => go(j) : undefined}>{it}</div>)}</div></>;
}

/* ── 예약 티켓 ── */
const R = {
  pending: { L: 'a', ink: 1, b: <Badge s="pending">접수됨</Badge>, sub: '매장 확인을 기다리고 있어요', lock: '매장이 확인하면 QR이 준비돼요' },
  confirmed: { L: 'p', b: <Badge>예약 확정 · D-10</Badge>, sub: '07월 04일 금요일 · 오후 8:12 · 테이블 예약', lock: '예약 당일에 QR이 열려요' },
  today: { L: 'l', ink: 1, b: <Badge s="called">오늘 예약</Badge>, sub: '오늘 오후 8:12 · 입장 시 QR을 보여주세요' },
  canceled: { L: 'g', done: 1, b: <Badge s="done">취소됨</Badge>, sub: '예약이 취소됐어요' },
  /* 노쇼 — 매장이 노쇼로 처리한 결과 · 위약금 100% · 환불 없음 (영업 시작 후 취소와 같은 기준) */
  noshow: { L: 'g', done: 1, ns: 1, b: <Badge s="done">노쇼</Badge>, sub: '07월 04일 금요일 · 방문하지 않아 종료됐어요' },
};
function ResvTicket({ st, onCancel, onDelete, entry = false, pre = false, sharing = false, onShare = () => goRow('sh-02') }) {
  const c = (entry ? W : R)[st];
  const det = entry ? 'rv-03' : 'pw-06';
  /* 전환된 티켓은 입장 직전 상태 — RSV-087의 '오늘 예약'과 같은 입장 순서 효과(라임 레이어 · ink · glow)를 그대로 쓴다 */
  const soon = entry && st !== 'entered' && !c.done;
  return <><div className={cx('tk cmp rsv', pre && 'pre', (soon || c.ink) && 'ink', (soon || st === 'today') && 'glow', st === 'entered' && 'ent', c.done && 'done')}>
    <TkHead layer={soon ? 'l' : c.L} badge={c.b} sub={pre ? '입장 3시간 전(오후 5:12) 입장 섹션으로 자동 이동해요' : c.sub} /><div className="tk-cut" />
    <div className="tk-b">
      <div className="tk-lbl">07월 04일 (금) 오후 8:12</div>
      <div className="tk-num sm">테이블-4 · 3명</div>
      {c.ns ? <div className="tk-stats two"><div><div className="k">위약금</div><div className="v">100%</div></div><div><div className="k">환불</div><div className="v">없음</div></div></div>
        : <div className="tk-stats">{[['좌석 등급', '테이블'], ['사전 주문', '2개'], ['결제', '545,500']].map(([k, v]) => <button key={k} onClick={() => goRow(det)}><div className="k">{k}</div><div className="v">{v}</div></button>)}</div>}
      {c.ns ? <div className="tk-note">영업 시작 후 취소와 같은 기준이 적용됐어요</div> : null}
      <button className="tk-link" onClick={() => goRow(det)}>예약 상세 보기 ›</button>
      {!c.done && <QrSlot open={entry || (st === 'today' && !pre)} lockText={pre && st === 'today' ? '티켓으로 전환된 후 QR이 열려요' : c.lock} h={pre ? 140 : 158} />}
      {entry && <div className="tk-note">입장 시 직원에게 QR을 보여주세요</div>}
      {entry && sharing && <div style={{ display: 'flex', justifyContent: 'center', margin: '2px 0 6px' }}><Badge s="entered" dot>공유 중</Badge></div>}
      {pre && <div className="dis-cap" style={{ margin: '10px 0 2px' }}>입장 3시간 전부터 공유할 수 있어요</div>}
      <TkStub kind="TABLE RESERVATION" code="RS-2607-1182" />
    </div></div>
    <div className="tk-acts">
        {entry && <button className="btn p" onClick={() => goRow(det)}>티켓 상세</button>}
        {!entry && (st === 'pending' || st === 'confirmed') && <><button className="btn s" onClick={onCancel}>예약 취소하기</button><button className="btn p" onClick={() => goRow('rc-04')}>예약 변경하기</button></>}
        {!entry && st === 'today' && <><button className="btn s" onClick={() => goRow('file:[v1]PLACE-019.html')}><Icon n="nav" s={16} />길찾기</button><button className="btn s" onClick={() => goRow('pw-06')}>예약 상세</button></>}
        {!entry && c.ns && <><button className="btn s" onClick={() => goRow('pw-04')}>이용 내역</button><button className="btn p" onClick={() => goRow('file:[v1]CLUB-021.html')}>다시 예약하기</button></>}
        {!entry && c.done && !c.ns && <><button className="btn s" onClick={onDelete}><Icon n="trash" s={16} />내역 삭제</button>
          {st === 'canceled' && <button className="btn p" onClick={() => goRow('rc-10')}>환불 상태</button>}</>}
    </div></>;
}

/* ── 예약 목록 카드 ── */
function ResvCard({ r, onOpen, onCancel, onDelete }) {
  const c = R[r.st];
  return <div className={cx(c.done ? 'gquiet' : 'gcard', r.rm && 'card-rm')} style={c.done ? { filter: 'saturate(0)' } : null}>
    <button className="tap" style={{ display: 'flex', gap: 12, width: '100%', alignItems: 'center' }} onClick={onOpen}>
      <img className="thumb" src={CLUB_IMG} alt="" style={{ width: 64, height: 64 }} />
      <div style={{ flex: 1, minWidth: 0 }}><div style={{ marginBottom: 6 }}>{r.st === 'confirmed' ? <Badge>예약 확정 · {r.dday}</Badge> : c.b}</div>
        <div style={{ font: '600 15px/1.25 var(--f)', marginBottom: 4 }}>{CLUB}</div><Meta items={['07월 04일 (금)', '오후 8:12', '3명']} /></div>
      <Icon n="chevR" s={18} style={{ color: 'var(--g500)' }} /></button>
    <div className="tk-btns" style={{ marginTop: 14 }}>{c.done ? <button className="btn s" onClick={onDelete}><Icon n="trash" s={16} />내역 삭제</button>
      : <><button className="btn s" onClick={onCancel}>예약 취소</button><button className="btn p" onClick={() => goRow('rc-04')}>예약 변경</button></>}</div>
  </div>;
}

/* ── 이용 내역 ── */
const HIST = [
  { id: 1, type: '현장 웨이팅', rv: 'prompt', meta: ['07월 04일 (금)', '오후 8:12', '2명'] },
  { id: 2, type: '예약', rv: 'expired', meta: ['06월 13일 (금)', '오후 9:00', '3명'] },
  { id: 3, type: '예약', rv: 'mine', meta: ['06월 06일 (금)', '오후 8:12', '3명'] },
  { id: 4, type: '비대면 주문', k: 'order', od: 1, st: '픽업 완료', meta: ['07월 04일 (금)', '오후 9:12', 'HARD SET A 외 1건', '545,500원'] },
  { id: 5, type: '비대면 주문', k: 'order', od: 1, st: '픽업 완료', meta: ['06월 13일 (금)', '오후 10:40', 'LEMON DROP', '100,000원'] },
];
const HFIL = [['all', '전체'], ['wait', '입장 · 웨이팅'], ['resv', '예약'], ['order', '주문']];
const HKEY = (h) => h.k || (h.type === '예약' ? 'resv' : 'wait');
function HistCard({ h, onOpen, pick, onPick }) {
  return <div className={cx('gquiet', h.rm && 'card-rm')}>
    <button className="tap" style={{ display: 'block', width: '100%' }} onClick={onOpen}>
      <span className="ttag">{h.type}</span>{h.st ? <span className="v2badge entered" style={{ marginLeft: 6 }}>{h.st}</span> : null}
      <div style={{ display: 'flex', gap: 12, alignItems: 'center', marginTop: 10 }}><img className="thumb" src={CLUB_IMG} alt="" style={{ width: 56, height: 56 }} />
        <div style={{ flex: 1, minWidth: 0 }}><div style={{ font: '600 15px/1.25 var(--f)', marginBottom: 4 }}>{CLUB}</div><Meta items={h.meta} /></div><Icon n="chevR" s={18} style={{ color: 'var(--g500)' }} /></div></button>
    <div style={{ marginTop: 14 }}>
      {h.rv === 'prompt' && <div style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid rgba(181,255,96,.4)', background: 'rgba(181,255,96,.06)', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}>
        <div style={{ fontSize: 13, fontWeight: 600 }}><span className="cl">잊기 전에</span> 후기를 남겨보세요!</div>
        <Stars v={pick} s={30} onPick={onPick} pop={pick > 0} />
        {pick > 0 && <button className="fade-up" style={{ fontSize: 12, color: 'var(--lavender)' }} onClick={() => goRow('pw-09')}>{pick}점 · 이어서 작성하기 ›</button>}</div>}
      {h.rv === 'expired' && <div style={{ padding: '11px 14px', borderRadius: 12, background: 'rgba(255,255,255,.04)', border: '1px solid var(--hair)', fontSize: 13, color: 'var(--g500)', textAlign: 'center' }}>리뷰 작성 기간이 만료되었어요</div>}
      {h.rv === 'mine' && <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}><Stars v={3.5} s={18} /><b style={{ fontSize: 14, fontWeight: 600 }}>3.5</b><button className="btn s" style={{ flex: '0 0 auto', height: 40, padding: '0 16px', fontSize: 14, marginLeft: 'auto' }} onClick={() => goRow('pw-08')}>내가 쓴 리뷰</button></div>}
    </div></div>;
}

/* ── Pass Wallet 앱 ── */
function PassWallet({ tab: tab0 = 'ticket', wait: wait0 = 'waiting', shift: sh0 = 0, back = false, resv: resvMode = 'single', resvState = 'confirmed', hist: histV = 'full', hf = 'all', overlay = null, fee = 0, people = 2, share = false, shared = false, pre = false, rsvEntry = null, sharing = false }) {
  const [tab, setTab] = pwS(tab0);
  const ORD = typeof OMULTI !== 'undefined' ? OMULTI : [];
  const ordReady = ORD.some((o) => o.st === 'ready');
  const [hfil, setHfil] = pwS(hf);
  const [waits, setWaits] = pwS(wait0 ? [{ club: CLUB, st: wait0, shift: sh0, atBack: back, base: 5, ahd: 2, total: 14, dist: '550m', stamp: 'AWSOME RED', fee, people, shared }, ...EXTRA] : []);
  const [wi, setWi] = pwS(0); const w = waits[wi] || {}; const wait = w.st || null; const shift = w.shift || 0;
  const setW = (p) => setWaits((a) => a.map((x, j) => (j === wi ? { ...x, ...p } : x)));
  const anyCalled = waits.some((x) => x.st === 'called');
  const [resvs, setResvs] = pwS(rsvEntry ? [] : resvMode === 'list' ? [{ id: 1, st: 'confirmed', dday: 'D-10' }, { id: 2, st: 'pending' }, { id: 3, st: 'canceled' }].filter((r) => !(overlay === 'delDone' && r.id === 3)) : [{ id: 1, st: resvState }]);
  const [sel, setSel] = pwS(rsvEntry || resvMode === 'list' ? null : 1);
  const [per, setPer] = pwS('최근 3개월');
  const [hist, setHist] = pwS(histV === 'short' ? HIST.slice(1) : overlay === 'histDone' ? HIST.slice(0, 2) : HIST);
  const [pick, setPick] = pwS(0);
  const [ov, setOv] = pwS(overlay === 'histDone' || overlay === 'delDone' ? null : overlay); const [target, setTarget] = pwS(overlay && (overlay.startsWith('hist') || overlay === 'delResv') ? 3 : 1);
  const [toast, show] = useToast();
  pwE(() => { if (overlay === 'histDone') setTimeout(() => show('해당 내역이 삭제되었어요.'), 300); if (overlay === 'delDone') setTimeout(() => show('예약 내역이 삭제되었어요.'), 300); }, []);
  const close = () => setOv(null);
  const rmHist = (id) => { setHist((a) => a.map((h) => h.id === id ? { ...h, rm: 1 } : h)); setTimeout(() => setHist((a) => a.filter((h) => h.id !== id)), 300); };
  const rmResv = (id) => { setResvs((a) => a.map((r) => r.id === id ? { ...r, rm: 1 } : r)); setTimeout(() => { setResvs((a) => a.filter((r) => r.id !== id)); setSel(null); }, 300); };
  const setRst = (id, st) => setResvs((a) => a.map((r) => r.id === id ? { ...r, st } : r));
  const active = resvs.filter((r) => r.st !== 'canceled' && r.st !== 'noshow').length;
  const cur = resvs.find((r) => r.id === sel);
  const wTotal = w.total || 14; const curNum = w.atBack ? wTotal : (w.base || 5) + shift;

  const top = <><div className="ph-bar" style={{ padding: '0 24px' }}><span style={{ font: '700 24px var(--f)', letterSpacing: '-.6px' }}>패스월렛</span>
    <span style={{ display: 'flex', gap: 8 }}><button className="gtile tap" aria-label="공유 입장권 받기" onClick={() => goRow('sh-05')}><Icon n="ticket" s={18} /></button>
    <span className="gtile"><Icon n="bell" s={18} />{anyCalled && <span className="dotl" />}</span></span></div>
    <div style={{ padding: '4px 24px 12px' }}><Segment value={tab} onChange={setTab} items={[{ k: 'ticket', label: '입장권', count: waits.filter((x) => !['canceled', 'expired'].includes(x.st)).length + (rsvEntry ? 1 : 0) }, { k: 'order', label: '주문', count: ORD.length }, { k: 'resv', label: '예약', count: active }, { k: 'hist', label: '이용 내역' }]} /></div></>;

  let body;
  const shareCta = <button className="gquiet tap" style={{ display: 'flex', alignItems: 'center', gap: 12, width: '100%', textAlign: 'left', margin: '14px 0 20px' }} onClick={() => goRow('sh-05')}>
    <span className="gtile"><Icon n="ticket" s={18} /></span>
    <span style={{ flex: 1, minWidth: 0 }}><span className="t-btn2" style={{ display: 'block', color: '#fff' }}>공유 입장권 받기</span><span className="t-cap c4" style={{ lineHeight: 1.4 }}>일련번호를 입력해 다른 사람이 공유한 입장권을 받아요</span></span>
    <Icon n="chevR" s={18} style={{ color: 'var(--g500)' }} /></button>;
  const rsvTk = rsvEntry ? <ResvTicket key="rsvEntry" entry st={rsvEntry} sharing={sharing} /> : null;
  const tkOff = rsvTk ? 1 : 0;
  const tkItems = (rsvTk ? [rsvTk] : []).concat(waits.map((x, j) => <WaitTicket key={x.club} {...x} share={share} onShare={() => goRow('sh-02')} onReceipt={() => { setWi(j); setOv('feeReceipt'); }} onPost={() => { setWi(j); setOv('postpone'); }} onCancel={() => { setWi(j); setOv('cancelWait'); }} onDelete={() => { setWi(j); setOv('delTicket'); }} />));
  if (tab === 'ticket') body = <>{tkItems.length ? <TicketDeck idx={wi + tkOff} onIdx={(i) => setWi(Math.max(0, i - tkOff))} items={tkItems} />
    : <>{ORD.length ? <div className="stack" style={{ gap: 8, marginBottom: 14 }}>
      <div className="t-btn2" style={{ color: '#fff' }}>진행 중인 주문 <span className="cl">{ORD.length}</span></div>
      {ORD.slice(0, 2).map((o) => <OrderCard key={o.no} o={o} onOpen={() => setTab('order')} />)}</div> : null}
      <div className="gquiet" style={{ textAlign: 'center', padding: '36px 20px 28px' }}>
      <div style={{ width: 64, height: 64, borderRadius: 99, background: 'var(--tileFill)', border: '1px solid var(--tileBorder)', display: 'grid', placeItems: 'center', margin: '0 auto 18px', color: 'var(--lavender)' }}><Icon n="store" s={30} sw={1.5} /></div>
      <div className="t-h4">현재 웨이팅 중인 매장이 없어요.</div><div className="t-b4 c3" style={{ marginTop: 10 }}>웨이팅 가능한 매장을 찾아보세요!</div>
      <button className="btn s" style={{ flex: 'none', margin: '22px auto 0', padding: '0 20px' }} onClick={() => goRow('file:[v1]PLACE-019.html')}><Icon n="pin" s={16} />주변 클럽 보기</button></div>
      {shareCta}<div className="shead" style={{ marginTop: 32 }}><span className="tt">요즘 뜨는 클럽</span><button className="lk" onClick={() => goRow('file:[v1]CAT-011.html')}>전체보기 ›</button></div>
      <div className="hscroll" style={{ margin: '0 -24px' }}>{[['어썸레드', CLUB_IMG], ['홍대 클럽 레이저', 'assets/pass-2.jpg'], ['버뮤다', 'assets/pass-1.jpg'], ['라운지 V', 'assets/pass-3.jpg']].map(([n, s], i) =>
        <button key={n} className="tap fade-up" style={{ flex: '0 0 132px', animationDelay: i * 45 + 'ms' }} onClick={() => goRow('file:[v1]CLUB-021.html')}><img className="thumb" src={s} alt="" style={{ width: 132, height: 132 }} />
          <div style={{ font: '600 15px/1.25 var(--f)', marginTop: 8 }}>{n}</div><Meta items={['홍대', '힙합']} /></button>)}</div></>}</>;
  if (tab === 'order') body = ORD.length ? <div className="stack" style={{ gap: 12 }}>
    {ordReady && <div className="ibn" style={{ background: 'rgba(181,255,96,.14)', border: '1px solid rgba(181,255,96,.35)', color: 'var(--lime500)' }}><i style={{ background: 'var(--lime500)', animation: 'v2dot 1.2s infinite' }} />준비 완료 · 지금 픽업할 수 있어요</div>}
    <div className="t-btn2" style={{ color: '#fff' }}>진행 중인 주문 <span className="cl">{ORD.length}</span></div>
    {ORD.map((o, i) => <div key={o.no} className="fade-up" style={{ animationDelay: i * 45 + 'ms' }}><OrderStatusCard o={o} onOpen={() => goRow('od-06')} /></div>)}
    <div className="fnote" style={{ marginTop: 6 }}><Icon n="info" s={16} /><span>상태는 매장 관리자 페이지에서 변경돼요 · 바뀌면 알림으로 알려드려요</span></div>
    <button className="btn s" style={{ width: '100%' }} onClick={() => goRow('od-01')}><Icon n="plus" s={16} />추가 주문하기</button>
  </div> : <div className="gquiet" style={{ textAlign: 'center', padding: '36px 20px 28px' }}>
    <div style={{ width: 64, height: 64, borderRadius: 99, background: 'var(--tileFill)', border: '1px solid var(--tileBorder)', display: 'grid', placeItems: 'center', margin: '0 auto 18px', color: 'var(--lavender)' }}><Icon n="bottle" s={28} sw={1.6} /></div>
    <div className="t-h4">진행 중인 주문이 없어요.</div><div className="t-b4 c3" style={{ marginTop: 10 }}>입장한 매장에서 바로 주문할 수 있어요</div>
    <button className="btn s" style={{ flex: 'none', margin: '22px auto 0', padding: '0 20px' }} onClick={() => goRow('od-01')}>메뉴 보러 가기</button></div>;
  if (tab === 'resv') body = cur ? <>{resvMode === 'list' && <button className="fade-up" style={{ display: 'flex', alignItems: 'center', gap: 2, fontSize: 13, color: 'var(--t3)', marginBottom: 12 }} onClick={() => setSel(null)}><Icon n="back" s={16} />전체 예약 {resvs.length}</button>}
      <TicketDeck label="내 예약" idx={0} onIdx={() => {}} items={[<ResvTicket key="r" st={cur.st} pre={pre} onCancel={() => { setTarget(cur.id); setOv('cancelResv'); }} onDelete={() => { setTarget(cur.id); setOv('delResv'); }} />]} /></>
    : <div className="stack" style={{ gap: 12 }}>
      {rsvEntry && !resvs.length && <div className="gquiet" style={{ textAlign: 'center', padding: '36px 20px 28px' }}>
        <div style={{ width: 64, height: 64, borderRadius: 99, background: 'var(--tileFill)', border: '1px solid var(--tileBorder)', display: 'grid', placeItems: 'center', margin: '0 auto 18px', color: 'var(--lavender)' }}><Icon n="ticket" s={28} sw={1.6} /></div>
        <div className="t-h4">예약 섹션이 비었어요</div>
        <div className="t-b4 c3" style={{ marginTop: 10, lineHeight: 1.6 }}>입장 3시간 전이 되어 예약 티켓이 입장권 섹션으로 이동했어요</div>
        <button className="btn s" style={{ flex: 'none', margin: '22px auto 0', padding: '0 20px' }} onClick={() => setTab('ticket')}>입장권 섹션에서 보기</button></div>}
      {resvs.map((r, i) => <div key={r.id} className="fade-up" style={{ animationDelay: i * 45 + 'ms' }}><ResvCard r={r} onOpen={() => setSel(r.id)} onCancel={() => { setTarget(r.id); setOv('cancelResv'); }} onDelete={() => { setTarget(r.id); setOv('delResv'); }} /></div>)}</div>;
  if (tab === 'hist') body = <div className="stack" style={{ gap: 12 }}>
    <div className="hscroll" style={{ margin: '0 -24px', padding: '0 24px 2px' }}>{HFIL.map(([k, l]) => <button key={k} className={cx('chip', hfil === k && 'on')} onClick={() => setHfil(k)}>{l}</button>)}</div>
    <div className="hscroll" style={{ margin: '0 -24px', padding: '0 24px 2px' }}>{['최근 3개월', '어썸레드', '직접 선택'].map((l) => <button key={l} className={cx('chip', per === l && 'on')} style={{ fontSize: 12 }} onClick={() => setPer(l)}>{l}{l === '직접 선택' ? '' : ' ▾'}</button>)}</div>
    {hist.filter((h) => hfil === 'all' || HKEY(h) === hfil).length === 0 && <div className="t-b4 c4" style={{ textAlign: 'center', padding: '40px 0' }}>해당 조건의 내역이 없어요</div>}
    {hist.filter((h) => hfil === 'all' || HKEY(h) === hfil).map((h, i) => <div key={h.id} className="fade-up" style={{ animationDelay: i * 45 + 'ms' }}><HistCard h={h} pick={pick} onPick={setPick} onOpen={() => { if (h.od) { goRow('od-07'); return; } setTarget(h.id); setOv('histSheet'); }} /></div>)}</div>;

  const overlays = <>
    <Sheet open={ov === 'postpone'} onClose={close} title="웨이팅 순서 미루기" footer={<div style={{ display: 'flex', gap: 8 }}><button className="vb s" style={{ flex: 1 }} onClick={close}>취소</button>
      <button className="vb" style={{ flex: 2 }} onClick={() => { setOv(null); setW({ atBack: true, ...(wait === 'called' ? { st: 'waiting' } : {}) }); show('순서가 대기 맨 뒤로 변경되었어요.'); }}>맨 뒤로 미루기</button></div>}>
      <div className="t-b4 c3" style={{ padding: '0 4px', lineHeight: 1.6 }}>순서를 미루면 현재 대기줄의 맨 뒤로 이동해요. 한 번 미룬 순서는 다시 앞으로 당길 수 없어요.</div>
      <div className="gauge" style={{ marginTop: 18, display: 'flex', justifyContent: 'space-between', fontSize: 13, color: 'var(--t2)' }}><span>대기 번호</span><span style={{ whiteSpace: 'nowrap' }}>{curNum}번 → <b className="cl">{wTotal}번</b> · 앞에 {wTotal - 1}팀</span></div>
    </Sheet>
    <Sheet open={ov === 'feeReceipt'} onClose={close} title={'입장비 결제 영수증'} footer={<button className="vb s" onClick={close}>{'닫기'}</button>}>
      <div className="gcard" style={{ padding: '4px 16px' }}>{[['매장', CLUB], ['결제 일시', '07.04 (금) 오후 8:11'], ['인원', (w.people || 2) + '명'], ['입장비 (1인)', won(w.fee || 20000) + '원'], ['결제 수단', '신용카드 · 신한'], ['결제 금액', won((w.fee || 20000) * (w.people || 2)) + '원'], ['결제 상태', 'paid']].map(([a, b]) => <div className="kv" key={a}><span>{a}</span><b className={b === 'paid' ? 'cl' : null}>{b === 'paid' ? '결제 완료(paid)' : b}</b></div>)}</div>
      <div className="fnote" style={{ marginTop: 12 }}><Icon n="info" s={16} /><div><ul>
        <li>{'· 대기 중(waiting) · 입장 순서(called)에서 취소하면 전액 환불되어요.'}</li>
        <li>{'· 호출 후 10분이 지나 노쇼(noShow)가 되면 환불되지 않아요.'}</li>
        <li>{'· 매장이 웨이팅을 마감(closed)하면 전액 자동 환불되어요.'}</li></ul></div></div>
    </Sheet>
    <Dialog open={ov === 'cancelWait'} onClose={close} title={<>웨이팅을 정말<br />취소하시겠어요?</>} desc="한 번 취소하면 기존 순번은 사라지고 다시 복구할 수 없어요."
      actions={<><button className="btn s" onClick={close}>돌아가기</button><button className="btn p" onClick={() => { close(); setW({ st: 'canceled' }); show('웨이팅이 취소됐어요.'); }}>웨이팅 취소하기</button></>} />
    <Dialog open={ov === 'delTicket'} onClose={close} title="입장권 삭제" desc="입장권을 삭제하면 재입장 QR도 함께 사라져요."
      actions={<><button className="btn s" onClick={close}>취소</button><button className="btn p" onClick={() => { close(); setWaits((a) => a.filter((_, j) => j !== wi)); setWi(0); show('해당 내역이 삭제되었어요.'); }}>삭제하기</button></>} />
    <Dialog open={ov === 'cancelResv'} onClose={close} title={<>예약을 정말<br />취소하시겠어요?</>} desc="예약일 3일 전까지는 패널티 없이 전액 환불돼요. 한 번 취소하면 다시 복구할 수 없어요."
      actions={<><button className="btn s" onClick={close}>돌아가기</button><button className="btn p" onClick={() => { close(); setRst(target, 'canceled'); show('예약이 취소됐어요.'); }}>예약 취소하기</button></>}>
      <div className="gcard" style={{ padding: '12px 16px' }}>
        <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>취소 구간</span><b style={{ fontSize: 14 }}>예약일 3일 전까지</b></div>
        <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>돌려받는 금액</span><b style={{ fontSize: 14, color: 'var(--lime500)' }}>1,000,000원 (전액)</b></div>
        <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>환불 예상 소요</span><b style={{ fontSize: 14 }}>영업일 3~5일</b></div></div>
    </Dialog>
    <Dialog open={ov === 'cancelResvPart'} onClose={close} title={<>이 금액으로<br />취소를 진행할까요?</>} desc="취소하면 되돌릴 수 없고, 같은 조건으로 다시 예약된다는 보장이 없어요."
      actions={<><button className="btn s" onClick={close}>돌아가기</button><button className="btn p" onClick={() => { close(); setRst(target, 'canceled'); show('예약이 취소됐어요.'); }}>진행하기</button></>}>
      <div className="gcard" style={{ padding: '12px 16px' }}>
        <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>패널티 합계</span><b style={{ fontSize: 14, color: 'var(--amber500)' }}>- 250,000원</b></div>
        <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>돌려받는 금액</span><b style={{ fontSize: 14, color: 'var(--lime500)' }}>750,000원</b></div>
        <div className="hr" style={{ margin: '8px 0' }} />
        <div className="t-cap" style={{ color: 'var(--amber500)', lineHeight: '24px' }}>공유 중인 티켓 1장도 함께 삭제돼요</div></div>
    </Dialog>
    <Dialog open={ov === 'cancelResvNone'} onClose={close} title={<>환불 없이<br />취소를 진행할까요?</>} desc="영업이 시작된 뒤에는 위약금이 100%로 적용되어 환불되지 않아요. 취소하면 되돌릴 수 없어요."
      actions={<><button className="btn s" onClick={close}>돌아가기</button><button className="btn p" onClick={() => { close(); setRst(target, 'canceled'); show('예약이 취소됐어요.'); }}>환불 없이 취소</button></>}>
      <div className="gcard" style={{ padding: '12px 16px' }}>
        <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>위약금</span><b style={{ fontSize: 14, color: 'var(--amber500)' }}>테이블 100% · 메뉴 100%</b></div>
        <div className="kv" style={{ padding: '4px 0', fontSize: 14 }}><span>돌려받는 금액</span><b style={{ fontSize: 14, color: 'var(--g500)' }}>0원</b></div>
        <div className="hr" style={{ margin: '8px 0' }} />
        <div className="t-cap" style={{ color: 'var(--amber500)', lineHeight: '24px' }}>공유 중인 티켓 1장도 함께 삭제되고, 노쇼와 결과가 같아요</div></div>
    </Dialog>
    <Dialog open={ov === 'delResv'} onClose={close} title={<>이용 내역을<br />삭제하시겠습니까?</>} desc="삭제된 내역은 복구할 수 없어요."
      actions={<><button className="btn s" onClick={close}>취소</button><button className="btn p" onClick={() => { close(); rmResv(target); show('해당 내역이 삭제되었어요.'); }}>삭제하기</button></>} />
    <Sheet open={ov === 'histSheet' || ov === 'histDel'} onClose={close} footer={<button className="vb s" onClick={() => setOv('histDel')}><Icon n="trash" s={18} />내역 삭제</button>}>
      <div style={{ display: 'flex', gap: 14, alignItems: 'center', padding: '4px 4px 18px' }}><img className="thumb" src={CLUB_IMG} alt="" style={{ width: 64, height: 64 }} />
        <div><div className="t-h4" style={{ marginBottom: 6 }}>{CLUB}</div><Meta items={(hist.find((h) => h.id === target) || HIST[2]).meta} /></div></div>
      <div className="gcard" style={{ padding: '4px 16px' }}>{[['결제 일시', '07.04 (금) 8:00'], ['결제 수단', '신용카드'], ['결제 금액', '545,500원']].map(([a, b]) => <div className="kv" key={a}><span>{a}</span><b>{b}</b></div>)}</div>
    </Sheet>
    <Dialog open={ov === 'histDel'} onClose={() => setOv('histSheet')} title={<>결제 내역을<br />삭제하시겠습니까?</>} desc="삭제된 내역은 복구할 수 없어요."
      actions={<><button className="btn s" onClick={() => setOv('histSheet')}>취소</button><button className="btn p" onClick={() => { close(); rmHist(target); show('해당 내역이 삭제되었어요.'); }}>삭제하기</button></>} />
    {toast}</>;

  return <Phone topH={168} botH={98} toastB={112} top={top} bottom={<TabBar alert={anyCalled || ordReady} />} overlay={overlays}>
    <div className="pad" key={tab + (sel || '')} style={{ paddingBottom: tab === 'ticket' || (tab === 'resv' && cur) ? 0 : 20, animation: 'fadeUp .3s var(--e-out)' }}>{body}</div></Phone>;
}
Object.assign(window, { PassWallet, WaitTicket, ResvTicket, TkHead, TkStub, QrSlot });
