/* global React, ReactDOM, IOSDevice, VAurora, TYPO, GRAY, LIME, PURPLE, RED, window, SV, SV_BLUR, SVHeader, SVTitle, SVField, SVBirth, SVCarrierField, SVDone, SVCarrierSheet, SVTermsSheet, SVLoading, SVToast, svState */
// ============ VYBE — 본인 인증 (회원가입 정보 입력) · 리뉴얼 ============
// 흐름·검증 규칙은 원본 Flutter 화면과 1:1. 표면만 리뉴얼했다.
//   이름 → 생년월일 → 전화번호 → 통신사 → 약관 시트 → 인증번호 화면

const STEPS = ['name', 'birth', 'phone', 'carrier'];

const fmtPhone = (v) => {
  const d = v.replace(/\D/g, '').slice(0, 11);
  if (d.length < 4) return d;
  if (d.length < 8) return `${d.slice(0, 3)}-${d.slice(3)}`;
  return `${d.slice(0, 3)}-${d.slice(3, 7)}-${d.slice(7)}`;
};

function SignupVerify() {
  const [maxStep, setMaxStep] = svState(0);
  const [active, setActive] = svState(0);
  const [name, setName] = svState('');
  const [front, setFront] = svState('');
  const [back, setBack] = svState('');
  const [phone, setPhone] = svState('');
  const [carrier, setCarrier] = svState(null);
  const [sheet, setSheet] = svState(null);      // 'carrier' | 'terms'
  const [loading, setLoading] = svState(false);
  const [toast, setToast] = svState(null);

  const nameRef = React.useRef(null), frontRef = React.useRef(null), backRef = React.useRef(null), phoneRef = React.useRef(null);
  const refFor = (s) => [nameRef, frontRef, phoneRef, null][s];
  const focusStep = (s) => setTimeout(() => refFor(s)?.current?.focus(), 60);

  // 앞 6자리 완료 시 뒷자리로 자동 이동
  const onFront = (v) => { setFront(v); if (v.length === 6 && front.length < 6) setTimeout(() => backRef.current?.focus(), 20); };

  // ── 검증 (원본 LogicMixin 이식) ──
  const code = parseInt(back, 10);
  const isForeigner = !!back && code >= 5 && code <= 8;
  const isInvalidBirth = (() => {
    if (front.length < 6 || !back) return false;
    if (!code || code < 1 || code > 8) return true;
    if (isForeigner) return false;
    const yy = +front.slice(0, 2), mm = +front.slice(2, 4), dd = +front.slice(4, 6);
    const y = (code === 1 || code === 2 ? 1900 : 2000) + yy;
    const d = new Date(y, mm - 1, dd);
    if (d.getMonth() !== mm - 1 || d.getDate() !== dd) return true;
    return d > new Date();
  })();
  const isMinor = (() => {
    if (front.length < 6 || !back || isForeigner || isInvalidBirth) return false;
    const yy = +front.slice(0, 2), mm = +front.slice(2, 4), dd = +front.slice(4, 6);
    const b = new Date((code === 1 || code === 2 ? 1900 : 2000) + yy, mm - 1, dd);
    const n = new Date();
    return b > new Date(n.getFullYear() - 19, n.getMonth(), n.getDate());
  })();
  const birthErr = isForeigner || isInvalidBirth || isMinor;

  const canProceed = [
    name.trim().length > 0,
    front.length === 6 && back.length === 1 && !birthErr,
    phone.replace(/-/g, '').length === 11,
    !!carrier,
  ][active];

  const onConfirm = () => {
    if (!canProceed) return;
    if (active === 3) { setSheet('terms'); return; }
    if (active === maxStep) { const n = maxStep + 1; setMaxStep(n); setActive(n); focusStep(n); }
    else { setActive(maxStep); focusStep(maxStep); }
  };
  const activateStep = (s) => { if (s === active) return; setActive(s); focusStep(s); };

  const say = (m, e) => { setToast({ m, e }); setTimeout(() => setToast(null), 2200); };
  const submit = () => {
    setSheet(null); setLoading(true);
    setTimeout(() => { window.__VBGO('%5Bv1%5DAUTH-004.html'); }, 1200);
  };

  // ── 단계별 타이틀 ──
  const title = [
    { hl: '이름', rest: '을 입력해주세요.' },
    {
      hl: '생년월일', rest: '을 입력해주세요.',
      caption: isForeigner ? '외국인은 회원가입이 불가 합니다.'
        : isInvalidBirth ? '올바른 생년월일을 입력해주세요.'
          : isMinor ? '미성년자는 회원가입이 제한됩니다.'
            : '이 서비스는 만 19세 이상만 이용 가능합니다.',
      captionType: birthErr ? 'error' : 'warn',
    },
    { hl: '전화번호', rest: '를 입력해주세요.' },
    { hl: '통신사', rest: '를 선택해주세요.' },
  ][active];

  const doneValue = [name, `${front} — ${back}●●●●●●`, phone, carrier || ''];
  const doneLabel = ['이름', '생년월일', '전화번호', '통신사'];

  // 활성 입력 위젯
  const activeField = (s) => {
    if (s === 0) return <SVField value={name} onChange={setName} hint="이름을 입력해주세요." inputRef={nameRef} onClear={() => setName('')} />;
    if (s === 1) return <SVBirth front={front} back={back} setFront={onFront} setBack={setBack} frontRef={frontRef} backRef={backRef} error={birthErr} />;
    if (s === 2) return <SVField value={phone} onChange={(v) => setPhone(fmtPhone(v))} hint="숫자만 입력해주세요." inputRef={phoneRef} type="tel" onClear={() => setPhone('')} />;
    return <SVCarrierField value={carrier} onTap={() => setSheet('carrier')} active />;
  };

  // 맨 위 = 최신 단계 / 그 아래 = 완료된 단계들을 최신순으로
  const below = STEPS.map((_, i) => i).filter(i => i < maxStep).reverse();

  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: SV.ink, display: 'flex', flexDirection: 'column', fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <VAurora variant="quiet" grain={true} />
      <div style={{ position: 'relative', flex: 1, minHeight: 0, display: 'flex', flexDirection: 'column' }}>
        <SVHeader onBack={() => false ? window.history.back() : null} step={active} total={5} />

        <div style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: '30px 24px 24px' }}>
          <div key={`t${active}${birthErr}`} style={{ animation: 'svTitle .3s ease-out' }}><SVTitle {...title} /></div>

          <div style={{ marginTop: 42 }} key={`f${maxStep}`}>
            <div style={{ animation: 'svSlide .28s ease-out' }}>
              {maxStep === active ? activeField(maxStep)
                : <SVDone label={doneLabel[maxStep]} value={doneValue[maxStep]} onEdit={() => activateStep(maxStep)} />}
            </div>
          </div>

          {below.length > 0 && (
            <div style={{ display: 'grid', gap: 10, marginTop: 26 }}>
              {below.map(i => (
                <div key={i} style={{ animation: 'svFadeUp .32s ease-out' }}>
                  {i === active
                    ? <div style={{ padding: '2px 0 4px' }}>{activeField(i)}</div>
                    : <SVDone label={doneLabel[i]} value={doneValue[i]} onEdit={() => activateStep(i)} />}
                </div>
              ))}
            </div>
          )}
        </div>

        <div style={{ flexShrink: 0, padding: '12px 24px 40px' }}>
          <button onClick={onConfirm} disabled={!canProceed} style={{
            all: 'unset', boxSizing: 'border-box', width: '100%', height: 56, borderRadius: 12, display: 'grid', placeItems: 'center',
            cursor: canProceed ? 'pointer' : 'default', background: canProceed ? PURPLE[500] : PURPLE.disabled,
            color: canProceed ? '#fff' : 'rgba(255,255,255,0.8)', fontWeight: 500, fontSize: 18, letterSpacing: '-0.45px',
            boxShadow: canProceed ? '0 10px 26px rgba(119,49,254,0.32)' : 'none', transition: 'background .12s, box-shadow .18s',
          }}>확인</button>
        </div>
      </div>

      {sheet === 'carrier' && <SVCarrierSheet selected={carrier} onClose={() => setSheet(null)} onSelect={(c) => { setCarrier(c); setSheet(null); }} />}
      {sheet === 'terms' && <SVTermsSheet onClose={() => setSheet(null)} onConfirm={submit} />}
      {loading && <SVLoading />}
      <SVToast msg={toast?.m} err={toast?.e} />
    </div>
  );
}

const svRoot = ReactDOM.createRoot(document.getElementById('root'));
svRoot.render(
  <IOSDevice dark={true} width={393} height={852}>
    <SignupVerify />
  </IOSDevice>
);
