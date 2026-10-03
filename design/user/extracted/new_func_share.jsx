/* global React, cx, won, Icon, Phone, AppBar, Bottom, Badge, Meta, Check, Field, Sheet, Dialog, useToast, goRow, qrPath, tableName, CLUB_IMG, WfNotice, WF_CLUB */
/* VYBE v1 — 입장완료(entered) 입장권 공유
   공유 방식은 두 가지만: ① 공유 일련번호 직접 입력 ② 공유 QR을 휴대폰 기본 카메라로 인식 → 딥링크로 앱 열림
   공유해주는 사용자가 설정한 공유 비밀번호가 일치해야 공유받을 수 있다. 친구 추가 개념은 없음. */
const { useState: shS } = React;
const SH_SERIAL = 'ARD-4F9K-2Q71';
const SH_PWLEN = 6;
const SH_TRY = 5;
const SH_CLUB = typeof WF_CLUB === 'string' ? WF_CLUB : '어썸레드';

/* 비밀번호 입력 — 회원가입 인증번호 입력(signup_code · CNCell)과 동일한 셀 위젯 · 숫자 6자리 */
function ShPinCell({ filled, err, active }) {
  const line = err ? 'var(--red500)' : active ? 'var(--purple500)' : filled ? 'rgba(181,255,96,.55)' : 'rgba(255,255,255,.10)';
  return <div style={{ position: 'relative', overflow: 'hidden', flex: 1, height: 72, borderRadius: 14, display: 'grid', placeItems: 'center',
    background: 'linear-gradient(158deg, rgba(255,255,255,.13) 0%, rgba(255,255,255,.05) 42%, rgba(255,255,255,.02) 100%)',
    border: `1px solid ${err ? 'rgba(255,92,95,.45)' : active ? 'rgba(119,49,254,.5)' : 'rgba(255,255,255,.1)'}`,
    backdropFilter: 'blur(20px) saturate(160%)', WebkitBackdropFilter: 'blur(20px) saturate(160%)',
    boxShadow: `inset 0 1px 0 rgba(255,255,255,.22), inset 0 -1px 0 rgba(255,255,255,.05), 0 8px 22px rgba(0,0,0,.34)${active ? ', 0 0 0 3px rgba(119,49,254,.16)' : ''}`,
    transform: filled ? 'translateY(-1px)' : 'none', transition: 'border-color .18s, box-shadow .2s, transform .2s cubic-bezier(.2,.8,.2,1)' }}>
    <span aria-hidden style={{ position: 'absolute', left: -14, top: -26, width: 76, height: 54, borderRadius: '50%', background: 'radial-gradient(closest-side, rgba(255,255,255,.2), transparent 70%)', filter: 'blur(8px)' }} />
    {filled ? <span style={{ position: 'relative', font: '500 26px/1 var(--f)', letterSpacing: '-.025em', color: err ? 'var(--red500)' : 'var(--g200)', animation: 'cnPop .22s cubic-bezier(.2,.9,.3,1)' }}>•</span> : null}
    <span aria-hidden style={{ position: 'absolute', left: 14, right: 14, bottom: 10, height: 2, borderRadius: 99, background: line, opacity: filled || active || err ? 1 : .6, transition: 'background .18s, opacity .18s' }} />
    {active && !filled ? <span aria-hidden style={{ position: 'absolute', width: 2, height: 28, borderRadius: 2, background: 'var(--purple500)', animation: 'cnCaret 1.05s ease-in-out infinite' }} /> : null}
  </div>;
}
function ShPin({ n = 0, len = SH_PWLEN, err, label, hint, active = true }) {
  return <div>
    {label && <div className="vtf-lbl" style={{ marginBottom: 8 }}>{label}</div>}
    <div style={{ display: 'flex', gap: 7 }}>{[...Array(len)].map((_, i) => <ShPinCell key={i} filled={i < n} err={err} active={active && !err && i === n} />)}</div>
    {hint && <div className={cx('t-cap', err ? null : 'c4')} style={err ? { color: 'var(--red500)', lineHeight: 1.5 } : { lineHeight: 1.5 }}>{hint}</div>}
  </div>;
}
/* 공유용 티켓 미리보기 — kind: 'entry' 입장 완료 입장권 · 'resv' 입장 섹션으로 전환된 테이블 예약 티켓 */
function ShPreviewTicket({ shared, quiet, kind = 'entry' }) {
  const rv = kind === 'resv';
  return <div className={cx('tk cmp', quiet && 'ink')}>
    <div className="tk-h"><i className={cx('tk-hl', quiet ? 'l' : 'e', 'on')} />
      <div><div className="club">{SH_CLUB} <Badge s={quiet ? 'called' : 'entered'}>{shared ? '공유받음' : rv ? '공유 예약 티켓' : '공유 입장권'}</Badge></div>
        <div className="sub">{rv ? '07월 04일 금요일 · 오후 8:12 · ' + tableName('T4') : '07월 04일 금요일 · 오후 8:32 입장 · 홍대'}</div></div></div>
    <div className="tk-cut" />
    <div className="tk-b">
      <div className="tk-stats" style={{ marginTop: 6 }}>{(rv ? [['이용 날짜', '07.04 (금)'], ['입장 시간', '20:12'], ['인원', '3명']] : [['이용 날짜', '07.04 (금)'], ['입장 시각', '20:32'], ['입장권', '1매']]).map(([k, v]) => <div key={k}><div className="k">{k}</div><div className="v">{v}</div></div>)}</div>
      <div className="tk-stub"><div><span className="k">{rv ? 'SHARED TABLE RESERVATION' : 'SHARED ENTRY PASS'}</span><span className="c">{rv ? 'RS-2607-1182' : SH_SERIAL}</span></div><span className="bar" aria-hidden="true" /></div></div></div>;
}

/* SH-02 — 공유 비밀번호 설정 (처음 공유할 때 1회) */
function SharePw({ v = 'empty' }) {
  const E = v === 'err', D = v === 'done';
  return <Phone bd="ambient" top={<AppBar title="공유 비밀번호 설정" />} botH={124}
    bottom={<Bottom cap={v === 'empty' ? '비밀번호를 입력해 주세요' : E ? '비밀번호가 일치하지 않아요' : null}>
      <button className="vb" disabled={!D} onClick={() => goRow('sh-03')}>설정하고 공유 QR 보기</button></Bottom>}>
    <div className="pad stack" style={{ gap: 24, paddingTop: 16, paddingBottom: 24 }}>
      <div><div className="t-h3">공유 비밀번호를<br />설정해 주세요</div>
        <div className="t-b4 c3" style={{ marginTop: 12, lineHeight: 1.65 }}>공유받는 사람이 이 비밀번호를 입력해야 입장권을 받을 수 있어요. 비밀번호는 앱이 알려주지 않으니 상대에게 직접 전해 주세요.</div></div>
      <ShPin label={`비밀번호 (숫자 ${SH_PWLEN}자리)`} n={v === 'empty' ? 0 : SH_PWLEN} />
      <ShPin label="비밀번호 확인" n={v === 'empty' ? 0 : E ? 4 : SH_PWLEN} err={E} hint={E ? '비밀번호가 일치하지 않아요 · 다시 입력해 주세요' : D ? '두 비밀번호가 일치해요' : null} />
      <div className="fnote"><Icon n="info" s={16} /><div><ul>
        <li>· 비밀번호는 한 입장권에 하나만 설정돼요. 이미 설정했다면 이 화면은 건너뛰고 공유 QR 화면이 바로 열려요.</li>
        <li>· 공유 관리에서 언제든 비밀번호를 바꾸거나 공유를 중지할 수 있어요.</li></ul></div></div>
    </div></Phone>;
}

/* SH-03 — 공유용 QR · 공유 일련번호 */
function ShareQr({ copied: c0 = false }) {
  const [copied, setCopied] = shS(c0); const [toast, show] = useToast();
  return <Phone bd="aurora" top={<AppBar title="입장권 공유하기" right={<button className="gbtn" aria-label="공유 관리" onClick={() => goRow('sh-04')}><Icon n="more" s={20} /></button>} />} botH={102}
    bottom={<Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('sh-04')}>공유 관리</button><button className="vb" style={{ flex: 1.4 }} onClick={() => goRow('sh-01')}>완료</button></Bottom>} overlay={toast}>
    <div className="pad stack" style={{ gap: 16, paddingTop: 10, paddingBottom: 24, alignItems: 'center' }}>
      <div className="ibn" style={{ width: '100%', background: 'rgba(181,255,96,.12)', border: '1px solid rgba(181,255,96,.32)', color: 'var(--lime500)' }}><Icon n="sun" s={16} />QR을 보여주는 동안 화면 밝기를 최대로 올려요</div>
      <div className="pq" style={{ width: 300, padding: 20, gap: 14 }}>
        <svg className="code" viewBox="0 0 29 29" width={252} height={252} shapeRendering="crispEdges" role="img" aria-label="공유용 QR 코드"><path fill="#0E0D12" d={qrPath(11)} /></svg>
        <div className="row" style={{ fontSize: 12, display: 'block', textAlign: 'center', color: 'rgba(14,13,18,.72)' }}>상대방이 휴대폰 기본 카메라로 인식하면 돼요</div></div>
      <div className="gcard" style={{ width: '100%' }}>
        <div className="shead" style={{ marginBottom: 10 }}><span className="tt">공유 일련번호</span><span className="t-cap c4">오늘 영업 종료까지 유효</span></div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <span style={{ flex: 1, font: '600 19px var(--mono)', letterSpacing: '.06em', color: '#fff' }}>{SH_SERIAL}</span>
          <button className={cx('btn', copied ? 's' : 'p')} style={{ flex: '0 0 84px', height: 42, fontSize: 14 }} onClick={() => { setCopied(true); show('공유 일련번호를 복사했어요.'); }}>{copied ? <><Icon n="check" s={16} sw={2.4} />복사됨</> : '복사'}</button></div>
        <div className="t-cap c4" style={{ marginTop: 8, lineHeight: 1.5 }}>QR을 못 찍는 상황이면 이 번호를 알려주세요 · 받는 사람은 패스월렛 › 공유 입장권 받기에서 입력해요</div></div>
      <div className="gquiet" style={{ width: '100%' }}>
        <div className="t-btn2" style={{ marginBottom: 8, display: 'flex', alignItems: 'center', gap: 7 }}><Icon n="lock" s={16} />비밀번호는 따로 알려주세요</div>
        <p className="t-b4 c3" style={{ margin: 0, lineHeight: 1.6 }}>보안을 위해 QR과 일련번호에는 비밀번호가 담기지 않아요. 공유받는 사람에게 비밀번호를 직접 전해 주세요.</p></div>
    </div></Phone>;
}

/* SH-04 — 공유 관리 (비밀번호 변경 · 공유 중지 · 공유된 횟수) */
function ShareManage({ ov: o0 = null, count = 2, people = 4, kind = 'entry' }) {
  const [ov, setOv] = shS(o0); const [stopped, setStopped] = shS(false); const [toast, show] = useToast();
  return <Phone bd="ambient" top={<AppBar title="공유 관리" />} botH={102}
    bottom={<Bottom>{stopped ? <button className="vb" onClick={() => goRow('sh-01')}>확인</button>
      : <><button className="vb s" style={{ flex: 1 }} onClick={() => setOv('pw')}>비밀번호 변경</button><button className="vb" style={{ flex: 1, background: 'rgba(255,92,95,.16)', border: '1px solid rgba(255,92,95,.34)', color: 'var(--red500)' }} onClick={() => setOv('stop')}>공유 중지</button></>}</Bottom>}
    overlay={<>
      <Sheet open={ov === 'pw'} onClose={() => setOv(null)} title="공유 비밀번호 변경" footer={<button className="vb" onClick={() => { setOv(null); show('공유 비밀번호가 변경되었어요.'); }}>변경하기</button>}>
        <div className="stack" style={{ gap: 20, padding: '0 2px' }}>
          <ShPin label="새 비밀번호" n={SH_PWLEN} /><ShPin label="새 비밀번호 확인" n={SH_PWLEN} />
          <div className="fnote"><Icon n="info" s={16} /><span>비밀번호를 바꾸면 이전 비밀번호로는 공유받을 수 없어요. 이미 공유받은 입장권은 그대로 유지돼요.</span></div></div></Sheet>
      <Dialog open={ov === 'stop'} onClose={() => setOv(null)} title={<>공유를 중지하면<br />공유 QR과 일련번호가 막혀요</>} desc="이미 공유받은 입장권은 그대로 유지되고, 새로 공유받는 것만 차단돼요."
        actions={<><button className="btn s" onClick={() => setOv(null)}>돌아가기</button><button className="btn p" onClick={() => { setOv(null); setStopped(true); show('공유를 중지했어요.'); }}>공유 중지하기</button></>} />{toast}</>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <ShPreviewTicket kind={kind} />
      <div className="gcard">
        <div className="shead" style={{ marginBottom: 10 }}><span className="tt">공유 상태</span>{stopped ? <Badge s="done">공유 중지됨</Badge> : <Badge s="entered" dot>공유 중</Badge>}</div>
        <div className="tk-stats two" style={{ margin: '4px 0 0' }}>
          <div><div className="k">공유된 횟수</div><div className="v">{count}회</div></div>
          <div><div className="k">마지막 공유</div><div className="v">오후 9:10</div></div></div></div>
      <div className="gcard" style={{ padding: '4px 16px' }}>
        <div className="kv"><span>공유 일련번호</span><b style={{ font: '600 13px var(--mono)', letterSpacing: '.05em' }}>{SH_SERIAL}</b></div>
        <div className="kv"><span>공유 가능 횟수</span><b className="c3">제한 미정 · 정책 확인 필요</b></div>
        <div className="kv"><span>비밀번호</span><b>설정됨 · 숫자 {SH_PWLEN}자리</b></div>
        <div className="kv"><span>유효 기간</span><b>오늘 영업 종료까지</b></div></div>
      <div className="fnote"><Icon n="lock" s={16} /><span>공유받은 사람의 이름 · 연락처 등 개인정보는 표시하지 않아요. 공유된 횟수만 확인할 수 있어요.</span></div>
    </div></Phone>;
}

/* SH-05 — 공유 입장권 받기 (QR 스캔 · 일련번호 입력 선택) */
const SH_CORNER = (a, b) => ({
  position: 'absolute', [a]: 0, [b]: 0, width: 26, height: 26,
  [a === 'top' ? 'borderTop' : 'borderBottom']: '3px solid var(--lime500)',
  [b === 'left' ? 'borderLeft' : 'borderRight']: '3px solid var(--lime500)',
  [`border${a === 'top' ? 'Top' : 'Bottom'}${b === 'left' ? 'Left' : 'Right'}Radius`]: 10,
});
function ShareSerial({ v = 'empty', m = 'qr' }) {
  const [mode, setMode] = shS(m);
  const [code, setCode] = shS(v === 'empty' ? '' : SH_SERIAL); const [err, setErr] = shS(v === 'none');
  const ok = code.replace(/[^A-Za-z0-9]/g, '').length >= 10;
  const qr = mode === 'qr';
  return <Phone bd="ambient" top={<AppBar title="공유 입장권 받기" />} botH={124}
    bottom={<Bottom cap={qr ? '공유 QR을 사각형 안에 맞춰 주세요' : !ok ? '공유 일련번호를 입력해 주세요' : err ? '일련번호를 다시 확인해 주세요' : null}>
      <button className="vb" disabled={!qr && (!ok || err)} onClick={() => goRow('sh-06')}>입장권 확인하기</button></Bottom>}>
    <div className="pad stack" style={{ gap: 20, paddingTop: 16, paddingBottom: 24 }}>
      <div><div className="t-h3">입장권을 받는 방법을<br />선택해 주세요</div>
        <div className="t-b4 c3" style={{ marginTop: 12, lineHeight: 1.65 }}>공유 QR을 스캔하거나, 공유해주는 사람 화면에 보이는 일련번호를 입력하면 돼요.</div></div>
      <Segment value={mode} onChange={setMode} items={[{ k: 'qr', label: 'QR 스캔' }, { k: 'serial', label: '일련번호 입력' }]} />
      {qr ? <>
        <div style={{ position: 'relative', width: '100%', height: 286, borderRadius: 19, background: 'var(--ink)', border: '1px solid var(--tileBorder)', overflow: 'hidden', display: 'grid', placeItems: 'center' }}>
          <span style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 90% at 50% 0%, rgba(119,49,254,.34), transparent 72%)' }} />
          <span style={{ position: 'relative', width: 188, height: 188, borderRadius: 12, background: 'rgba(255,255,255,.04)' }}>
            <span style={SH_CORNER('top', 'left')} /><span style={SH_CORNER('top', 'right')} />
            <span style={SH_CORNER('bottom', 'left')} /><span style={SH_CORNER('bottom', 'right')} />
            <span style={{ position: 'absolute', left: 10, right: 10, top: '50%', height: 2, borderRadius: 99, background: 'var(--lime500)', opacity: .7 }} />
          </span>
          <span className="t-cap c4" style={{ position: 'absolute', bottom: 16, textAlign: 'center' }}>사각형 안에 QR을 맞추면 자동으로 인식돼요</span>
        </div>
        <div className="fnote"><Icon n="info" s={16} /><div><ul>
          <li>· 휴대폰 기본 카메라로 공유 QR을 찍으면 이 화면 없이 바로 열려요.</li>
          <li>· QR을 인식한 뒤에도 공유 비밀번호를 입력해야 입장권을 받을 수 있어요.</li></ul></div></div>
      </> : <>
        <Field label="공유 일련번호" value={code} onChange={(x) => { setCode(x.toUpperCase()); setErr(false); }} ph="ARD-0000-0000" err={err} msg="존재하지 않는 일련번호예요 · 대시(-)를 포함해 다시 확인해 주세요" />
        <div className="fnote"><Icon n="info" s={16} /><div><ul>
          <li>· 일련번호는 오늘 영업 종료까지만 유효해요.</li>
          <li>· 번호를 입력한 뒤 공유 비밀번호도 입력해야 입장권을 받을 수 있어요.</li></ul></div></div>
      </>}
    </div></Phone>;
}

/* SH-06 — 입장권 미리보기 + 비밀번호 입력 (QR · 일련번호 공통) */
function SharePreview({ v = 'input', from = 'qr', kind = 'entry' }) {
  const E = v === 'err', L = v === 'locked';
  return <Phone bd="aurora" top={<AppBar title="공유받기" />} botH={124}
    bottom={<Bottom cap={L ? `${SH_TRY}회 모두 틀려 30분간 잠겼어요` : E ? `비밀번호가 맞지 않아요 · 남은 시도 ${SH_TRY - 1}회` : v === 'input' ? '비밀번호를 입력해 주세요' : null}>
      {L ? <button className="vb s" onClick={() => goRow('sh-01')}>닫기</button> : <button className="vb" disabled={v !== 'ready'} onClick={() => goRow('sh-09')}>입장권 받기</button>}</Bottom>}>
    <div className="pad stack" style={{ gap: 16, paddingTop: 8, paddingBottom: 24 }}>
      <div className="ibn purple"><Icon n="camera" s={16} />{from === 'qr' ? '휴대폰 카메라로 공유 QR을 인식해 열렸어요' : `일련번호 ${SH_SERIAL} 로 찾은 입장권이에요`}</div>
      <ShPreviewTicket kind={kind} />
      <div className="gcard">
        <div className="shead" style={{ marginBottom: 12 }}><span className="tt">공유 비밀번호</span><span className="t-cap c4">공유해준 사람에게 받은 번호</span></div>
        <ShPin n={L ? SH_PWLEN : E ? SH_PWLEN : v === 'ready' ? SH_PWLEN : 0} err={E || L}
          hint={L ? `시도 횟수를 ${SH_TRY}회 모두 사용했어요 · 30분 후 다시 시도할 수 있어요` : E ? `비밀번호가 맞지 않아요 · 남은 시도 ${SH_TRY - 1}회` : '공유해준 사람에게 직접 받은 숫자 6자리를 입력해 주세요'} />
        {L ? <div className="ibn amber" style={{ marginTop: 14 }}><i />잠김이 풀리면 같은 QR이나 일련번호로 다시 시도할 수 있어요</div> : null}</div>
      <div className="fnote"><Icon n="info" s={16} /><span>비밀번호가 일치하면 이 입장권이 내 패스월렛에 공유받음 입장권으로 발급돼요.</span></div>
    </div></Phone>;
}

/* SH-08 — 앱 미설치 안내 (딥링크 웹 랜딩) */
function ShareInstall() {
  return <Phone bd="ambient" topH={98} top={<div className="ph-bar" style={{ gap: 8 }}>
    <span style={{ display: 'flex', alignItems: 'center', gap: 8, flex: 1, height: 38, padding: '0 14px', borderRadius: 99, background: 'rgba(255,255,255,.08)', border: '1px solid var(--hair)', font: '500 13px var(--mono)', color: 'var(--t3)' }}><Icon n="lock" s={13} />vybe.app/s/{SH_SERIAL}</span>
    <span className="gtile" style={{ width: 32, height: 32, flexBasis: 32 }}><Icon n="more" s={16} /></span></div>} botH={146}
    bottom={<Bottom cap="설치 후 이 링크를 다시 열면 공유받기가 이어져요"><div className="stack" style={{ gap: 8, width: '100%' }}>
      <button className="vb" onClick={() => goRow('sh-05#1')}>VYBE 앱 설치하기</button><button className="vb s" onClick={() => goRow('sh-06')}>이미 설치했어요 · 앱으로 열기</button></div></Bottom>}>
    <div className="pad stack" style={{ gap: 18, paddingTop: 28, paddingBottom: 24 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}><span style={{ width: 52, height: 52, borderRadius: 15, background: 'linear-gradient(140deg,var(--purple500),var(--purpleDeep))', display: 'grid', placeItems: 'center', font: '800 20px var(--f)', color: '#fff' }}>V</span>
        <div><div className="t-btn1">VYBE</div><div className="t-cap c4">클럽 웨이팅 · 입장권</div></div></div>
      <div><div className="t-h3">공유받은 입장권이<br />기다리고 있어요</div>
        <div className="t-b4 c3" style={{ marginTop: 12, lineHeight: 1.65 }}>입장권은 VYBE 앱에서 받을 수 있어요. 앱을 설치하고 이 링크를 다시 열면 비밀번호 입력 화면으로 바로 이어져요.</div></div>
      <ShPreviewTicket quiet />
      <div className="gcard" style={{ padding: '4px 16px' }}>
        <div className="kv"><span>공유 일련번호</span><b style={{ font: '600 13px var(--mono)', letterSpacing: '.05em' }}>{SH_SERIAL}</b></div>
        <div className="kv"><span>유효 기간</span><b>오늘 영업 종료까지</b></div></div>
      <div className="fnote"><Icon n="info" s={16} /><span>설치 후 앱에서 패스월렛 › 공유 입장권 받기로 들어가 위 일련번호를 입력해도 돼요.</span></div>
    </div></Phone>;
}

/* SH-09 — 공유 완료 */
function ShareDone({ kind = 'entry' }) {
  return <Phone bd="aurora" top={<AppBar title="공유받기 완료" noBack />} botH={102}
    bottom={<Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('pw-01')}>확인</button><button className="vb" style={{ flex: 2 }} onClick={() => goRow('sh-10')}>패스월렛에서 보기</button></Bottom>}>
    <div className="pad" style={{ paddingTop: 24, paddingBottom: 18 }}>
      <div className="succ"><svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5L20 7" /></svg></div>
      <div className="t-h3 fade-up" style={{ textAlign: 'center', marginTop: 20, animationDelay: '.3s' }}>입장권을 받았어요</div>
      <div className="t-b4 c3 fade-up" style={{ textAlign: 'center', marginTop: 10, animationDelay: '.35s' }}>패스월렛 입장권 탭에 공유받음 입장권으로 담겼어요</div>
      <div className="fade-up" style={{ marginTop: 20, animationDelay: '.42s' }}><ShPreviewTicket shared kind={kind} /></div>
      <div className="fnote" style={{ marginTop: 12 }}><Icon n="info" s={16} /><span>입장 시 직원에게 공유받은 입장권의 QR을 보여주세요. QR은 본인 계정 전용으로 발급되고 주기적으로 새로 바뀌어요.</span></div>
    </div></Phone>;
}

/* SH-11 — 공유 예외 */
const SH_ERR = {
  expired: { icon: 'clock', tone: 'amber', top: '공유 링크 만료', t: '유효하지 않은 공유 링크예요', d: <>링크가 만료됐거나 주소가 잘못됐어요.<br />공유 QR과 일련번호는 오늘 영업 종료까지만 유효해요.</>, rows: [['상태', '만료 또는 형식 오류'], ['유효 기간', '오늘 영업 종료까지']], note: '공유해준 사람에게 QR을 다시 띄워달라고 요청해 주세요.', a: '일련번호로 받기', go: 'sh-05' },
  stopped: { icon: 'lock', tone: 'red', top: '공유 중지됨', t: '공유가 중지된 입장권이에요', d: <>공유해준 사람이 공유를 중지했어요.<br />이 QR과 일련번호로는 더 받을 수 없어요.</>, rows: [['상태', '공유 중지'], ['공유 가능', '불가']], note: '공유를 다시 열어달라고 요청하면 새 일련번호가 발급돼요.', a: '닫기', go: 'sh-01' },
  already: { icon: 'check', tone: 'lime', top: '이미 받은 입장권', t: '이미 공유받은 입장권이에요', d: <>같은 입장권은 한 번만 받을 수 있어요.<br />패스월렛 입장권 탭에서 확인해 주세요.</>, rows: [['받은 시각', '07.04 (금) 오후 9:02'], ['상태', '공유받음 · 사용 가능']], note: '입장권이 보이지 않으면 패스월렛을 새로고침해 주세요.', a: '패스월렛에서 보기', go: 'sh-10' },
  self: { icon: 'user', tone: 'amber', top: '공유받기 불가', t: '내가 공유한 입장권이에요', d: <>본인 입장권은 스스로 공유받을 수 없어요.<br />이미 패스월렛에 입장권이 있어요.</>, rows: [['입장권 소유자', '나 (홍길동)'], ['상태', '입장 완료(entered)']], note: '다른 사람에게 QR이나 일련번호를 전해 주세요.', a: '공유 QR 다시 보기', go: 'sh-03' },
};
function ShareErrors({ v = 'expired' }) {
  const c = SH_ERR[v];
  return <WfNotice tone={c.tone} icon={c.icon} top={c.top} title={c.t} desc={c.d}
    actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('sh-05')}>돌아가기</button><button className="vb" style={{ flex: 2 }} onClick={() => goRow(c.go)}>{c.a}</button></>}>
    <div className="gcard" style={{ padding: '4px 16px' }}>{c.rows.map(([a, b]) => <div key={a} className="kv"><span>{a}</span><b>{b}</b></div>)}</div>
    <div className="fnote"><Icon n="info" s={16} /><span>{c.note}</span></div>
  </WfNotice>;
}
Object.assign(window, { SH_SERIAL, SH_PWLEN, SH_TRY, ShPin, ShPinCell, ShPreviewTicket, SharePw, ShareQr, ShareManage, ShareSerial, SharePreview, ShareInstall, ShareDone, ShareErrors });
