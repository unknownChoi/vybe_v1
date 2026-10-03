/* global React, goEntry, cx, won, Icon, useToast, Phone, AppBar, Bottom, Badge, Meta, Stepper, Check, Field, Gauge, Calendar, dateLabel, FloorPlan, TABLES, tableName, goRow, RulesTabSheet */
const { useState: rsS, useEffect: rsE, useRef: rsR } = React;
const fmtPhone = (v) => { const d = v.replace(/\D/g, '').slice(0, 11); return d.length < 4 ? d : d.length < 8 ? `${d.slice(0, 3)}-${d.slice(3)}` : `${d.slice(0, 3)}-${d.slice(3, 7)}-${d.slice(7)}`; };
const TIMES = [['오후 7:30', 1], ['오후 8:00'], ['오후 8:30'], ['오후 9:00'], ['오후 9:30'], ['오후 10:00']];

function AccSec({ ic, label, value, ph, open, onToggle, children, done }) {
  return <div className="gcard" style={{ padding: 0 }}>
    <button className="acc-h" onClick={onToggle} aria-expanded={open}><span className="gtile"><Icon n={ic} s={18} /></span>
      <span className="lb"><small>{label}</small><b className={cx(!value && 'is-ph')}>{value || ph}</b></span>
      {done && !open && <Icon n="check" s={18} sw={2.4} style={{ color: 'var(--lime500)' }} />}
      <Icon n="chevD" s={20} style={{ color: 'var(--g500)', transition: 'transform .34s var(--e-out)', transform: open ? 'rotate(180deg)' : 'none' }} /></button>
    <div className={cx('acc', open && 'open')}><div><div className="acc-c">{children}</div></div></div></div>;
}

/* RS-01 예약 정보 입력 */
function BookingForm({ filled = false, open: open0 = null }) {
  const F = filled;
  const [name, setName] = rsS(F ? '홍길동' : ''); const [phone, setPhone] = rsS(F ? '010-1234-1234' : ''); const [pErr, setPErr] = rsS(false);
  const [date, setDate] = rsS(F ? 723 : null); const [people, setPeople] = rsS(F ? 3 : 1);
  const [table, setTable] = rsS(F ? 'T4' : null); const [time, setTime] = rsS(F ? '오후 8:00' : null); const [order] = rsS(F);
  const [open, setOpen] = rsS(open0); const [roomMsg, setRoomMsg] = rsS(false);
  const tg = table && TABLES.find((t) => t.id === table).g; const min = 500000; const total = order ? 545500 : 0;
  const tog = (k) => setOpen((o) => (o === k ? null : k)); const next = (k) => setTimeout(() => setOpen(k), 260);
  const miss = !name ? '예약자명을 입력해 주세요' : phone.replace(/\D/g, '').length < 10 ? '연락처를 확인해 주세요' : !date ? '날짜를 선택해 주세요' : !table ? '테이블을 선택해 주세요' : !time ? '시간을 선택해 주세요' : total < min ? `최소 주문 ${won(min)}원을 채워 주세요` : null;
  return <Phone bd="aurora" top={<AppBar title="어썸레드" />} botH={124} bottom={<Bottom cap={miss}><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('file:[v1]CLUB-021.html')}>취소</button><button className="vb" style={{ flex: 2 }} disabled={!!miss} onClick={() => goRow('rs-03')}>{miss ? '결제하기' : `${won(total)}원 결제하기`}</button></Bottom>}>
    <div className="pad" style={{ paddingTop: 8, paddingBottom: 24 }}>
      <div className="t-tag cl">테이블 예약</div>
      <div className="stack" style={{ gap: 24, margin: '14px 0 28px' }}>
        <Field label="예약자명" value={name} onChange={setName} ph="이름을 입력해 주세요." />
        <Field label="연락처" value={phone} inputMode="numeric" onChange={(v) => { setPhone(fmtPhone(v)); setPErr(false); }} onBlur={() => setPErr(phone && phone.replace(/\D/g, '').length < 10)} ph="숫자만 입력해 주세요." err={pErr} msg="올바른 전화번호를 입력해 주세요" />
      </div>
      <div className="stack" style={{ gap: 10 }}>
        <AccSec ic="cal" label="날짜" ph="날짜를 선택해 주세요" value={date && dateLabel(date)} done={!!date} open={open === 'date'} onToggle={() => tog('date')}>
          <Calendar sel={date} onSel={(k) => { setDate(k); next('people'); }} /></AccSec>
        <AccSec ic="user" label="인원" ph="인원을 선택해 주세요" value={`${people}명`} done open={open === 'people'} onToggle={() => tog('people')}>
          <div style={{ display: 'flex', justifyContent: 'center', padding: '6px 0 16px' }}><Stepper big v={people} min={1} max={10} unit="명" onChange={(v) => { setPeople(v); setRoomMsg(false); }} /></div>
</AccSec>
        <AccSec ic="table" label="테이블" ph="테이블을 선택해 주세요" value={tableName(table)} done={!!table} open={open === 'table'} onToggle={() => tog('table')}>
          <FloorPlan sel={table} onSel={(id) => { if (id[0] === 'R' && people < 4) { setRoomMsg(true); return; } setRoomMsg(false); setTable(id); next('time'); }} />
          {roomMsg && <div className="vtf-msg" style={{ color: 'var(--amber500)' }}>룸은 4명 이상부터 예약할 수 있어요</div>}</AccSec>
        <AccSec ic="clock" label="도착 시간" ph="시간을 선택해 주세요" value={time} done={!!time} open={open === 'time'} onToggle={() => tog('time')}>
          <div className="chips">{TIMES.map(([t, d]) => <button key={t} disabled={!!d} className={cx('chip', time === t && 'on')} onClick={() => { setTime(t); next(null); }}>{t}</button>)}</div></AccSec>
        <div className="gcard" style={{ padding: 0 }}>
          <button className="acc-h" onClick={() => goRow('rm-01')}><span className="gtile"><Icon n="doc" s={18} /></span>
            <span className="lb"><small>사전 주문</small><b className={cx(!order && 'is-ph')}>{order ? 'HARD SET A 외 1건' : '메뉴를 담아 주세요'}</b></span><Icon n="chevR" s={20} style={{ color: 'var(--g500)' }} /></button>
          <div style={{ padding: '0 16px 16px' }}><Gauge min={min} cur={total} /></div></div>
      </div></div></Phone>;
}

/* RS-05 약관 */
const TERMS = [
  ['제1조 (목적)', '본 약관은 주식회사 바이브(이하 ‘회사’)가 제공하는 테이블 예약·사전 주문 서비스(이하 ‘서비스’)를 이용하면서 회사와 이용자 사이의 권리, 의무 및 책임사항을 정하는 것을 목적으로 합니다.'],
  ['제2조 (수집하는 개인정보)', '회사는 예약 확인과 매장 안내를 위해 예약자명, 연락처, 방문 일시, 동반 인원을 수집합니다. 결제 정보는 결제대행사가 처리하며 회사는 카드번호를 저장하지 않습니다.'],
  ['제3조 (이용 목적)', '수집한 정보는 예약 확정·변경·취소 안내, 입장 QR 발급, 매장과의 예약 정보 공유, 고객 문의 대응에만 이용합니다.'],
  ['제4조 (보유 기간)', '예약 정보는 방문일로부터 1년간 보관한 뒤 파기합니다. 관계 법령에 따라 보관이 필요한 결제 기록은 해당 법령이 정한 기간 동안 보관합니다.'],
  ['제5조 (동의 거부 권리)', '이용자는 개인정보 수집·이용에 동의하지 않을 수 있습니다. 다만 필수 항목에 동의하지 않으면 테이블 예약 서비스를 이용할 수 없습니다.'],
];
function Terms() {
  const sc = rsR(); const [p, setP] = rsS(0);
  return <Phone bd="ambient" scrollRef={sc} onScroll={(e) => { const t = e.currentTarget; setP(t.scrollTop / Math.max(1, t.scrollHeight - t.clientHeight)); }}
    top={<><AppBar title="개인정보 이용 약관" /><div style={{ height: 2, background: 'var(--hair)' }}><div style={{ height: 2, width: p * 100 + '%', background: 'linear-gradient(90deg,var(--purple500),var(--lime500))' }} /></div></>}>
    <div className="pad" style={{ paddingTop: 12, paddingBottom: 48 }}>
      <div className="t-cap c4">시행일 2025.07.01</div>
      {TERMS.map(([t, b]) => <section key={t} style={{ marginTop: 20 }}><div className="t-tag">{t}</div><p className="t-cap c2" style={{ marginTop: 4, textWrap: 'pretty' }}>{b}</p></section>)}
    </div></Phone>;
}

/* RS-06 예약 완료 */
function BookingDone({ st = 'pending' }) {
  const P = st === 'pending'; const [rules, setRules] = rsS(false);
  return <Phone bd="aurora" overlay={<RulesTabSheet open={rules} onClose={() => setRules(false)} />} top={<AppBar title="결제 완료" noBack />} botH={102} bottom={<Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => goEntry('rsv')}>확인</button><button className="vb" style={{ flex: 2 }} onClick={() => goRow('pw-02')}>패스월렛에서 보기</button></Bottom>}>
    <div className="pad" style={{ paddingTop: 20, paddingBottom: 18 }}>
      <div className="succ"><svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5L20 7" /></svg></div>
      <div className="t-h3 fade-up" style={{ textAlign: 'center', marginTop: 20, animationDelay: '.3s' }}>테이블 예약이 {P ? '접수되었어요' : '확정되었어요'}</div>
      <div className="t-b4 c3 fade-up" style={{ textAlign: 'center', marginTop: 10, animationDelay: '.35s' }}>{P ? '매장이 확인하면 알림으로 알려드릴게요' : '예약 당일 패스월렛에서 입장 QR이 열려요'}</div>
      <div className={cx('tk cmp fade-up', P && 'ink')} style={{ marginTop: 20, animationDelay: '.42s' }}>
        <div className="tk-h"><i className={cx('tk-hl a', P && 'on')} /><i className={cx('tk-hl p', !P && 'on')} />
          <div><div className="club">어썸레드 {P ? <Badge s="pending">접수됨</Badge> : <Badge>예약 확정 · D-23</Badge>}</div><div className="sub">{P ? '매장 확인을 기다리고 있어요' : '07월 23일 수요일 · 오후 8:00 · 테이블 예약'}</div></div></div>
        <div className="tk-cut" /><div className="tk-b"><div className="tk-lbl">07월 23일 (수) 오후 8:00</div><div className="tk-num sm">테이블-4 · 3명</div>
          <div className="tk-stats" style={{ marginBottom: 0 }}><div><div className="k">좌석 등급</div><div className="v">테이블</div></div><div><div className="k">사전 주문</div><div className="v">2개</div></div><div><div className="k">결제</div><div className="v">545,500</div></div></div></div></div>
      <div className="gcard fade-up" style={{ marginTop: 12, animationDelay: '.5s' }}><div className="shead" style={{ marginBottom: 4 }}><span className="tt">결제 내역</span></div>
        {[['총 결제 금액', '545,500원'], ['HARD SET A', '225,500'], ['HARD SET B', '320,000']].map(([a, b], i) => <div key={a} className="kv" style={i ? { padding: '8px 0', fontSize: 13 } : { fontWeight: 600 }}><span style={i ? null : { color: '#fff' }}>{a}</span><b style={i ? null : { fontWeight: 700 }}>{b}</b></div>)}</div>
      <button className="btn s fade-up" style={{ width: '100%', marginTop: 12, animationDelay: '.56s' }} onClick={() => setRules(true)}><Icon n="doc" s={16} />취소 · 변경 규정 다시 보기</button>
    </div></Phone>;
}
Object.assign(window, { BookingForm, Terms, BookingDone, fmtPhone });
