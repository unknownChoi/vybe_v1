/* global React, ReactDOM, IOSDevice, VAurora, TYPO, GRAY, LIME, PURPLE, RED, window, SV, SV_BLUR, SVHeader, SVLoading, SVToast, svState */
// ============ VYBE — 인증번호 입력 · 리뉴얼 ============
// 원본(certification_number_screen.dart)의 상태 기계·타이머·검증을 그대로 두고 표면만 리뉴얼.
//   initial → focused → (requestSent) → error / expired
// 표면 규칙은 signup_verify와 공유: 오로라 배경 · 글래스 · 리퀴드 셀

const CN_CODE = '123456';   // 원본 _correctCode
const CN_TOTAL = 180;       // 원본은 데모용 10초, 실서비스 값(3분)으로 표시

// check_certification_number.svg / error_certification_number.svg — 레포 asset 그대로
const CN_OK_D = 'M6 0C7.5913 0 9.11742 0.632141 10.2426 1.75736C11.3679 2.88258 12 4.4087 12 6C12 7.5913 11.3679 9.11742 10.2426 10.2426C9.11742 11.3679 7.5913 12 6 12C4.4087 12 2.88258 11.3679 1.75736 10.2426C0.632141 9.11742 0 7.5913 0 6C0 4.4087 0.632141 2.88258 1.75736 1.75736C2.88258 0.632141 4.4087 0 6 0ZM5.25257 7.18371L3.91971 5.85C3.87193 5.80222 3.81521 5.76431 3.75278 5.73845C3.69034 5.7126 3.62343 5.69929 3.55586 5.69929C3.48828 5.69929 3.42137 5.7126 3.35894 5.73845C3.29651 5.76431 3.23978 5.80222 3.192 5.85C3.0955 5.9465 3.04129 6.07738 3.04129 6.21386C3.04129 6.35033 3.0955 6.48121 3.192 6.57771L4.88914 8.27486C4.93679 8.32288 4.99347 8.361 5.05592 8.38701C5.11837 8.41302 5.18535 8.42642 5.253 8.42642C5.32065 8.42642 5.38763 8.41302 5.45008 8.38701C5.51253 8.361 5.56921 8.32288 5.61686 8.27486L9.13114 4.75971C9.17956 4.71213 9.21808 4.65543 9.24448 4.59288C9.27088 4.53034 9.28463 4.46318 9.28495 4.3953C9.28527 4.32741 9.27214 4.26013 9.24632 4.19734C9.22051 4.13455 9.18252 4.0775 9.13454 4.02946C9.08656 3.98143 9.02955 3.94337 8.96679 3.91748C8.90404 3.89159 8.83677 3.87839 8.76888 3.87862C8.701 3.87886 8.63383 3.89253 8.57125 3.91886C8.50867 3.94518 8.45193 3.98364 8.40429 4.032L5.25257 7.18371Z';
const CN_ERR_D = 'M12 6C12 2.6862 9.3138 0 6 0C2.6862 0 0 2.6862 0 6C0 9.3138 2.6862 12 6 12C9.3138 12 12 9.3138 12 6ZM6 3C6.15913 3 6.31174 3.06321 6.42426 3.17574C6.53679 3.28826 6.6 3.44087 6.6 3.6V6.6C6.6 6.75913 6.53679 6.91174 6.42426 7.02426C6.31174 7.13679 6.15913 7.2 6 7.2C5.84087 7.2 5.68826 7.13679 5.57574 7.02426C5.46321 6.91174 5.4 6.75913 5.4 6.6V3.6C5.4 3.44087 5.46321 3.28826 5.57574 3.17574C5.68826 3.06321 5.84087 3 6 3ZM5.4 8.4C5.4 8.24087 5.46321 8.08826 5.57574 7.97574C5.68826 7.86321 5.84087 7.8 6 7.8H6.0048C6.16393 7.8 6.31654 7.86321 6.42906 7.97574C6.54159 8.08826 6.6048 8.24087 6.6048 8.4C6.6048 8.55913 6.54159 8.71174 6.42906 8.82426C6.31654 8.93679 6.16393 9 6.0048 9H6C5.84087 9 5.68826 8.93679 5.57574 8.82426C5.46321 8.71174 5.4 8.55913 5.4 8.4Z';

// ---------- OTP 셀 (OtpCell 리뉴얼) ----------
// 원본: gray800 채운 사각 + 상태별 테두리. 리뉴얼: 리퀴드 글래스 + 채워지면 라임 언더라인
function CNCell({ digit, state, active }) {
  const err = state === 'error' || state === 'expired';
  const line = err ? RED[500] : active ? PURPLE[500] : digit ? 'rgba(181,255,96,0.55)' : 'rgba(255,255,255,0.10)';
  return (
    <div style={{
      position: 'relative', overflow: 'hidden', width: 46, height: 56, borderRadius: 12,
      display: 'grid', placeItems: 'center',
      background: 'linear-gradient(158deg, rgba(255,255,255,0.13) 0%, rgba(255,255,255,0.05) 42%, rgba(255,255,255,0.02) 100%)',
      border: `1px solid ${err ? 'rgba(255,92,95,0.45)' : active ? 'rgba(119,49,254,0.50)' : 'rgba(255,255,255,0.10)'}`,
      ...SV_BLUR(20),
      boxShadow: `inset 0 1px 0 rgba(255,255,255,0.22), inset 0 -1px 0 rgba(255,255,255,0.05), 0 8px 22px rgba(0,0,0,0.34)${active ? `, 0 0 0 3px rgba(119,49,254,0.16)` : ''}`,
      transform: digit ? 'translateY(-1px)' : 'none',
      transition: 'border-color .18s, box-shadow .2s, transform .2s cubic-bezier(.2,.8,.2,1)',
    }}>
      <span aria-hidden style={{ position: 'absolute', left: -14, top: -26, width: 76, height: 54, borderRadius: '50%', background: 'radial-gradient(closest-side, rgba(255,255,255,0.20), transparent 70%)', filter: 'blur(8px)' }} />
      <span key={digit} style={{ position: 'relative', fontFamily: 'Pretendard, sans-serif', fontWeight: 500, fontSize: 24, lineHeight: 1, letterSpacing: '-0.025em', color: err ? RED[500] : GRAY[200], animation: digit ? 'cnPop .22s cubic-bezier(.2,.9,.3,1)' : 'none' }}>{digit}</span>
      <span aria-hidden style={{ position: 'absolute', left: 12, right: 12, bottom: 8, height: 2, borderRadius: 99, background: line, opacity: digit || active || err ? 1 : 0.6, transition: 'background .18s, opacity .18s' }} />
      {active && !digit && <span aria-hidden style={{ position: 'absolute', width: 2, height: 24, borderRadius: 2, background: PURPLE[500], animation: 'cnCaret 1.05s ease-in-out infinite' }} />}
    </div>
  );
}

function CertificationNumber() {
  const phone = '010-5909-1595';
  const [code, setCode] = svState('');
  const [status, setStatus] = svState('initial');   // initial · focused · requestSent · error · expired
  const [left, setLeft] = svState(CN_TOTAL);
  const [loading, setLoading] = svState(false);
  const [toast, setToast] = svState(null);
  const [done, setDone] = svState(false);
  const inputRef = React.useRef(null);
  const tick = React.useRef(null);

  const startTimer = () => {
    clearInterval(tick.current);
    setLeft(CN_TOTAL);
    tick.current = setInterval(() => setLeft(s => {
      if (s <= 1) { clearInterval(tick.current); setStatus('expired'); return 0; }
      return s - 1;
    }), 1000);
  };
  React.useEffect(() => { startTimer(); setTimeout(() => inputRef.current?.focus(), 300); return () => clearInterval(tick.current); }, []);

  const err = status === 'error' || status === 'expired';
  const subtitle = status === 'error' ? '인증번호가 일치하지 않습니다.'
    : status === 'expired' ? '인증번호 입력 시간이 만료 되었습니다.'
      : status === 'requestSent' ? '새로운 인증번호가 요청되었습니다.'
        : `${phone}로 인증번호를 전송했습니다.`;

  const confirm = (v) => {
    if (v.length !== 6) return;
    if (v === CN_CODE) {
      setLoading(true); clearInterval(tick.current);
      setTimeout(() => { setLoading(false); setDone(true); }, 1200);
    } else setStatus('error');
  };

  const onInput = (raw) => {
    if (status === 'expired') return;
    const v = raw.replace(/\D/g, '').slice(0, 6);
    setCode(v);
    if (err) setStatus('focused');
    if (v.length === 6) setTimeout(() => confirm(v), 120);
  };

  const resend = () => {
    setCode(''); startTimer(); setStatus('requestSent');
    setToast({ m: '인증번호를 다시 보냈어요' });
    setTimeout(() => setToast(null), 2200);
    setTimeout(() => inputRef.current?.focus(), 60);
  };

  const focused = status === 'focused' || status === 'requestSent';
  const mm = Math.floor(left / 60), ss = String(left % 60).padStart(2, '0');
  const canConfirm = code.length === 6 && status !== 'expired';

  if (done) return <CNSuccess />;

  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: SV.ink, display: 'flex', flexDirection: 'column', fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <VAurora variant="quiet" grain={true} />
      <div style={{ position: 'relative', flex: 1, minHeight: 0, display: 'flex', flexDirection: 'column' }}>
        <SVHeader onBack={() => { window.__VBGO('%5Bv1%5DAUTH-003.html'); }} step={4} total={5} />

        <div style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: '30px 24px 24px' }} onClick={() => inputRef.current?.focus()}>
          <div style={{ fontWeight: 600, fontSize: 24, lineHeight: '30px', letterSpacing: '-0.025em', color: '#fff' }}>
            <span style={{ color: LIME[500] }}>인증번호</span>를 입력해주세요
          </div>
          <div key={status} style={{ display: 'inline-flex', alignItems: 'center', gap: 4, marginTop: 8, fontSize: 12, lineHeight: '14px', letterSpacing: '-0.025em', color: err ? RED[500] : GRAY[500], animation: 'cnFade .2s ease-out' }}>
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none" style={{ flexShrink: 0 }}>
              {err ? <path fillRule="evenodd" clipRule="evenodd" d={CN_ERR_D} fill={RED[500]} /> : <path d={CN_OK_D} fill={GRAY[500]} />}
            </svg>
            {subtitle}
          </div>

          {/* OTP 6칸 — 실제 입력은 숨은 input이 받는다 (원본과 동일) */}
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 42 }}>
            {Array.from({ length: 6 }, (_, i) => (
              <CNCell key={i} digit={code[i] || ''} state={status} active={focused && i === code.length && !err} />
            ))}
          </div>
          <input ref={inputRef} value={code} onChange={(e) => onInput(e.target.value)} inputMode="numeric" maxLength={6}
            onFocus={() => setStatus(s => s === 'initial' ? 'focused' : s)}
            style={{ position: 'absolute', opacity: 0, height: 1, width: 1, pointerEvents: 'none' }} />

          <div style={{ display: 'flex', alignItems: 'center', marginTop: 20 }}>
            <span style={{ ...TYPO.caption, lineHeight: '18px', color: GRAY[400] }}>남은 시간&nbsp;&nbsp;</span>
            <span style={{ fontSize: 16, lineHeight: '18px', letterSpacing: '-0.025em', color: left === 0 ? RED[500] : PURPLE[500], fontVariantNumeric: 'tabular-nums' }}>{mm}:{ss}</span>
            <span style={{ flex: 1 }} />
            <button onClick={(e) => { e.stopPropagation(); resend(); }} style={{ all: 'unset', cursor: 'pointer', ...TYPO.caption, lineHeight: '18px', fontWeight: 500, color: GRAY[400], textDecoration: 'underline', textUnderlineOffset: 3 }}>다시 요청하기</button>
          </div>

          {/* 만료 시 복구 동선을 눈에 보이게 */}
          {status === 'expired' && (
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 22, padding: '13px 16px', borderRadius: 14, background: 'rgba(255,92,95,0.07)', border: '1px solid rgba(255,92,95,0.20)' }}>
              <svg width="14" height="14" viewBox="0 0 12 12" fill="none" style={{ flexShrink: 0 }}><path fillRule="evenodd" clipRule="evenodd" d={CN_ERR_D} fill={RED[500]} /></svg>
              <span style={{ flex: 1, fontSize: 13, letterSpacing: '-0.025em', color: SV.t2 }}>시간이 만료됐어요</span>
              <button onClick={(e) => { e.stopPropagation(); resend(); }} style={{ all: 'unset', cursor: 'pointer', height: 30, padding: '0 13px', borderRadius: 8, background: 'rgba(255,255,255,0.09)', border: '1px solid rgba(255,255,255,0.14)', ...TYPO.button2, color: '#fff', lineHeight: '30px' }}>새 번호 받기</button>
            </div>
          )}
        </div>

        <div style={{ flexShrink: 0, padding: '12px 24px 40px' }}>
          <button onClick={() => confirm(code)} disabled={!canConfirm} style={{
            all: 'unset', boxSizing: 'border-box', width: '100%', height: 56, borderRadius: 12, display: 'grid', placeItems: 'center',
            cursor: canConfirm ? 'pointer' : 'default', background: canConfirm ? PURPLE[500] : PURPLE.disabled,
            color: canConfirm ? '#fff' : 'rgba(255,255,255,0.8)', fontWeight: 500, fontSize: 18, letterSpacing: '-0.45px',
            boxShadow: canConfirm ? '0 10px 26px rgba(119,49,254,0.32)' : 'none', transition: 'background .12s, box-shadow .18s',
          }}>확인</button>
        </div>
      </div>

      {loading && <SVLoading />}
      <SVToast msg={toast?.m} err={toast?.e} />
    </div>
  );
}

// ---------- 회원가입 완료 (SignupSuccessScreen) ----------
// 원본: 배경 영상 무한 반복(top 280) + 상단 잉크→투명 그라데이션 + 로고 "와 함께"
//       + 라임→핑크→퍼플 그라데이션 타이틀 + special variant 버튼
const CN_TITLE_GRAD = 'linear-gradient(135deg, #B5FF60 0%, #C8E77F 14.2%, #DACA9E 28.5%, #FF9EDB 56.9%, #DD82E4 67.7%, #BB67ED 78.5%, #994CF5 89.2%, #7731FE 100%)';

function CNSuccess() {
  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: '#101013', fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <video src="assets/auth/signup_success.mp4" autoPlay loop muted playsInline
        style={{ position: 'absolute', left: 0, right: 0, top: 280, bottom: 0, width: '100%', height: 'calc(100% - 280px)', objectFit: 'cover' }} />
      {/* 영상 위 잉크 → 투명 (영상과 자연스러운 전환) */}
      <div aria-hidden style={{ position: 'absolute', left: 0, right: 0, top: 200, height: 420, background: 'linear-gradient(180deg, #101013 0%, rgba(16,16,19,0.95) 35%, rgba(16,16,19,0.8) 55%, rgba(16,16,19,0.5) 75%, rgba(16,16,19,0.15) 90%, transparent 100%)' }} />

      <div style={{ position: 'absolute', left: 26, top: 156, display: 'flex', alignItems: 'center', gap: 8 }}>
        <img src="assets/auth/vybe_white_logo.svg" alt="vybe" style={{ width: 120, display: 'block' }} />
        <span style={{ fontWeight: 700, fontSize: 36, lineHeight: 1, letterSpacing: '-0.9px', color: GRAY[200] }}>와 함께</span>
      </div>

      <div style={{ position: 'absolute', left: 26, top: 220, width: 305, fontWeight: 700, fontSize: 44, lineHeight: 1.25, letterSpacing: '-0.025em', background: CN_TITLE_GRAD, WebkitBackgroundClip: 'text', backgroundClip: 'text', color: 'transparent' }}>
        새로운<br />클럽 라이프를<br />시작해볼까요?
      </div>

      {/* VybeButton special — 그라데이션 border */}
      <a href="%5Bv1%5DHOME-005.html" style={{ position: 'absolute', left: 24, right: 24, bottom: 40, display: 'block', padding: 2, borderRadius: 12, background: CN_TITLE_GRAD }}>
        <span style={{ display: 'grid', placeItems: 'center', height: 52, borderRadius: 10, background: PURPLE[500], color: '#fff', fontWeight: 500, fontSize: 18, letterSpacing: '-0.45px' }}>바이브 시작하기</span>
      </a>
    </div>
  );
}

const cnRoot = ReactDOM.createRoot(document.getElementById('root'));
cnRoot.render(
  <IOSDevice dark={true} width={393} height={852}>
    <CertificationNumber />
  </IOSDevice>
);
