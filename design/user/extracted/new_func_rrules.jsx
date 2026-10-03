/* global React, cx, Icon, Phone, AppBar, Bottom, Badge, Check, Sheet, Segment */
/* VYBE v1 — 테이블 예약 환불·취소·변경 규정 (RSV-049 약관 동의 영역)
   이중 트랙 타임라인 위젯(H안) + 전체 규정 탭 바텀시트.
   문구·요율은 rsv_rules.js(첨부 규정 원문 · 사용자에게 보이는 항목만)에서만 가져온다. */
const { useState: rrS } = React;
const RR = () => window.RSV_RULES;
const TONE = { ok: 'var(--lime500)', part: 'var(--amber500)', no: 'var(--g700)' };
const TONE_TX = { ok: 'var(--lime500)', part: 'var(--amber500)', no: 'var(--g500)' };
const RBADGE = { ok: 'entered', part: 'pending', no: 'done' };

/* ── 전체 규정 본문 (취소 / 변경 / 적용 예시) ── */
function RulesFull({ only }) {
  const R = RR();
  const Row = ({ k, v }) => <div className="kv"><span>{k}</span><b>{v}</b></div>;
  const show = (k) => ({ display: only && only !== k ? 'none' : 'block' });
  return <div className="stack" style={{ gap: 12 }}>
    <div style={show('cancel')}>
      <div className="t-h4">취소 규정</div>
      <div className="stack" style={{ gap: 8, marginTop: 10 }}>
        {R.cancel.map((c) => <div key={c.when} className="gquiet" style={{ padding: '12px 14px' }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8, marginBottom: 8 }}>
            <span className="t-btn2" style={{ color: '#fff' }}>{c.when}</span><Badge s={RBADGE[c.tone]}>{c.refund}</Badge></div>
          <Row k="테이블 위약금 (테이블 금액 대비)" v={c.tb} />
          <Row k="메뉴 위약금 (메뉴 금액 대비)" v={c.menu} />
          {c.fee ? <Row k="취소 처리 수수료 (결제총액 대비)" v={c.fee} /> : null}
          <Row k="돌려받는 금액" v={c.ex + ' (결제총액 100만 원 예시)'} />
        </div>)}
      </div>
      <div className="fnote" style={{ marginTop: 10 }}><Icon n="info" s={16} /><div><ul>{R.extraCancel.map((t) => <li key={t}>· {t}</li>)}</ul></div></div>
    </div>
    <div style={show('change')}>
      <div className="t-h4">변경 규정</div>
      <div className="stack" style={{ gap: 8, marginTop: 10 }}>
        {R.change.map((c) => <div key={c.it} className="gquiet" style={{ padding: '12px 14px' }}>
          <div className="t-btn2" style={{ color: '#fff' }}>{c.it}</div>
          {c.sub ? <div className="t-cap c4" style={{ lineHeight: '18px', marginBottom: 4 }}>{c.sub}</div> : null}
          {R.changeCols.map((col, i) => <Row key={col} k={col} v={c.v[i]} />)}
        </div>)}
        <div className="gquiet" style={{ padding: '12px 14px' }}>
          <div className="t-btn2" style={{ color: '#fff' }}>{R.changeFee.it}</div>
          <div className="t-cap c4" style={{ lineHeight: '18px' }}>{R.changeFee.sub}</div>
          <div className="t-b4 cl" style={{ marginTop: 6 }}>{R.changeFee.v}</div></div>
      </div>
      <div className="fnote" style={{ marginTop: 10 }}><Icon n="info" s={16} /><div><ul>{R.extraChange.map((t) => <li key={t}>· {t}</li>)}</ul></div></div>
    </div>
    <div style={show('ex')}>
      <div className="t-h4">적용 예시</div>
      <div className="hscroll" style={{ padding: '10px 0 2px', gap: 6 }}>{R.exBase.map((b) => <span key={b} className="chip" style={{ fontSize: 12 }}>{b}</span>)}</div>
      <div className="t-tag" style={{ marginTop: 10 }}>취소 예시</div>
      <div className="stack" style={{ gap: 8, marginTop: 6 }}>
        {R.exCancel.map((e) => <div key={e.s + e.ss} className="gquiet" style={{ padding: '12px 14px' }}>
          <div className="t-btn2" style={{ color: '#fff' }}>{e.s}</div>
          {e.ss ? <div className="t-cap c4" style={{ lineHeight: '18px' }}>{e.ss}</div> : null}
          <div className="t-cap c2" style={{ lineHeight: '20px', margin: '4px 0 6px' }}>{e.calc.map((x) => <div key={x}>· {x}</div>)}</div>
          <Row k="돌려받는 금액" v={e.user} /></div>)}
      </div>
      <div className="t-tag" style={{ marginTop: 14 }}>변경 예시</div>
      <div className="stack" style={{ gap: 8, marginTop: 6 }}>
        {R.exChange.map((e) => <div key={e.s + e.ss} className="gquiet" style={{ padding: '12px 14px' }}>
          <div className="t-btn2" style={{ color: '#fff' }}>{e.s}</div>
          {e.ss ? <div className="t-cap c4" style={{ lineHeight: '18px' }}>{e.ss}</div> : null}
          <div className="t-cap c2" style={{ lineHeight: '20px', margin: '4px 0 6px' }}>{e.calc.map((x) => <div key={x}>· {x}</div>)}</div>
          <Row k="추가 결제 · 환불" v={e.user} /></div>)}
      </div>
    </div>
    <div className="fnote"><Icon n="info" s={16} /><span>{R.note}</span></div>
  </div>;
}

/* ── 연결 페이지 · 취소 / 변경 / 예시 탭 바텀시트 ── */
const RTABS = [{ k: 'cancel', label: '취소 규정' }, { k: 'change', label: '변경 규정' }, { k: 'ex', label: '적용 예시' }];
function RulesTabSheet({ open, onClose }) {
  const [tab, setTab] = rrS('cancel');
  return <Sheet open={open} onClose={onClose} title="테이블 예약 취소·변경 규정" footer={<button className="vb s" onClick={onClose}>닫기</button>}>
    <div style={{ marginBottom: 14 }}><Segment value={tab} onChange={setTab} items={RTABS} /></div>
    <RulesFull only={tab} /></Sheet>;
}

/* ── 위젯 껍데기 ── */
function RuleShell({ title, onFull, hi, children, foot }) {
  return <div className={cx('gcard', hi && 'rule-hi')} style={{ padding: 16 }}>
    <div className="shead" style={{ marginBottom: 12 }}>
      <span className="tt" style={{ fontSize: 15 }}><Icon n="doc" s={18} />{title}</span>
      <button className="lk" onClick={onFull}>전체 규정 보기 ›</button></div>
    {children}
    {foot}
  </div>;
}
const AgreeRow = ({ agreed, onAgree, label = '환불 · 예약 취소 규정을 확인했으며 이에 동의합니다.' }) => <>
  <div className="hr" style={{ margin: '14px 0 10px' }} />
  <Check on={agreed} onChange={onAgree} style={{ fontSize: 13, alignItems: 'flex-start' }}><span>{label} <span className="cl" style={{ whiteSpace: 'nowrap' }}>(필수)</span></span></Check></>;
const RSub = ({ t }) => <div className="t-tag" style={{ fontSize: 13, lineHeight: '20px', color: 'var(--t2)', marginTop: 10 }}>{t}</div>;

/* H. 이중 트랙 타임라인 — 같은 시간축 위 취소 트랙 · 변경 트랙 */
function RulesH({ agreed, onAgree, onFull, hi }) {
  const C = RR().cancel.slice(0, 4);
  const ch = RR().change.find((c) => c.it === '테이블 하향');
  const tone = (x) => (x === '무료' ? 'ok' : x === '변경 불가' ? 'no' : 'part');
  return <RuleShell title="환불 · 예약 취소 규정" onFull={onFull} hi={hi} foot={<AgreeRow agreed={agreed} onAgree={onAgree} />}>
    <div style={{ display: 'flex', justifyContent: 'space-between' }}><span className="t-cap c4">결제</span><span className="t-cap c4">예약일 · 영업 시작</span></div>
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 4, marginTop: 6 }}>
      {C.map((c) => <div key={c.when} className="t-cap" style={{ color: 'var(--t4)', lineHeight: '15px' }}>{c.short}</div>)}
    </div>
    <RSub t="취소 · 환불" />
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 4 }}>
      {C.map((c) => <div key={c.when}><div style={{ height: 8, borderRadius: 99, background: TONE[c.tone] }} />
        <div style={{ font: '600 12px/16px var(--f)', letterSpacing: '-.3px', color: TONE_TX[c.tone], marginTop: 4 }}>{c.refund}</div></div>)}
    </div>
    <RSub t="예약 변경 (메뉴 · 테이블 하향)" />
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 4 }}>
      {ch.v.map((x, i) => <div key={i}><div style={{ height: 8, borderRadius: 99, background: TONE[tone(x)] }} />
        <div style={{ font: '600 12px/16px var(--f)', letterSpacing: '-.3px', color: TONE_TX[tone(x)], marginTop: 4 }}>{x}</div></div>)}
    </div>
    <div className="t-cap c4" style={{ lineHeight: '18px', marginTop: 10 }}>상향 변경과 인원 변경은 전 구간 무료 · 도착시간은 당일 영업 전 1회 무료 · 노쇼는 영업 시작 후와 같이 환불되지 않아요</div>
  </RuleShell>;
}
Object.assign(window, { RulesFull, RulesTabSheet, RuleShell, AgreeRow, RulesH });
