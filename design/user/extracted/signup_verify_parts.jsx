/* global React, TYPO, GRAY, LIME, PURPLE, RED, BLUE, window */
// ============ VYBE — 본인 인증 리뉴얼 · 파츠 ============
// 원본 Flutter 위젯(VybeTextField / BirthInput / CompletedField / CarrierDropdownField /
// CarrierSheet / TermsAgreementSheet)의 규칙을 그대로 두고 표면만 글래스로 갈아끼웠다.

const SV = {
  ink: '#0E0D12',
  hair: 'rgba(255,255,255,0.09)',
  cardFill: 'rgba(120,120,128,0.16)',
  cardBorder: 'rgba(255,255,255,0.10)',
  tileFill: 'rgba(255,255,255,0.07)',
  tileBorder: 'rgba(255,255,255,0.12)',
  quietFill: 'rgba(120,120,128,0.08)',
  quietBorder: 'rgba(255,255,255,0.06)',
  barFill: 'rgba(14,13,18,0.55)',
  t1: '#fff', t2: 'rgba(255,255,255,0.82)', t3: 'rgba(255,255,255,0.68)', t4: GRAY[500],
};
const SV_BLUR = (n) => ({ backdropFilter: `blur(${n}px)`, WebkitBackdropFilter: `blur(${n}px)` });
const svState = React.useState;

// 24sp Medium — 입력 필드 공통 타이포 (원본 하드코딩값 유지)
const SV_INPUT_FONT = { fontFamily: 'Pretendard, sans-serif', fontWeight: 500, fontSize: 24, lineHeight: '26px', letterSpacing: '-0.025em' };

// ---------- 글래스 원형 버튼 (VybeGlassButton) ----------
function SVGlassBtn({ onClick, size = 34, children }) {
  return (
    <button onClick={onClick} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: size, height: size, borderRadius: 99, background: SV.tileFill, border: `1px solid ${SV.tileBorder}`, ...SV_BLUR(18), display: 'grid', placeItems: 'center', color: SV.t2 }}>
      {children}
    </button>
  );
}

// ---------- 상단 바 + 단계 레일 ----------
function SVHeader({ onBack, step, total }) {
  return (
    <div style={{ flexShrink: 0, paddingTop: 54, background: SV.barFill, ...SV_BLUR(20) }}>
      <div style={{ height: 44, display: 'flex', alignItems: 'center', padding: '0 20px' }}>
        <SVGlassBtn onClick={onBack}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>
        </SVGlassBtn>
        <div style={{ flex: 1, textAlign: 'center', fontSize: 16, fontWeight: 500, color: '#EBEDF0', letterSpacing: '-0.025em', marginLeft: -34 }}>본인 인증</div>
      </div>
      {/* 단계 레일 — 원본에는 진행 표시가 없어 4단계 흐름이 보이지 않았다 */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '6px 24px 14px' }}>
        <div style={{ flex: 1, display: 'flex', gap: 5 }}>
          {Array.from({ length: total }, (_, i) => (
            <div key={i} style={{ flex: 1, height: 3, borderRadius: 99, overflow: 'hidden', background: 'rgba(255,255,255,0.10)' }}>
              <div style={{ height: '100%', borderRadius: 99, background: i === step ? LIME[500] : PURPLE[500], width: i <= step ? '100%' : '0%', boxShadow: i === step ? `0 0 10px ${LIME[500]}66` : 'none', transition: 'width .42s cubic-bezier(.2,.8,.2,1)' }} />
            </div>
          ))}
        </div>
        <span style={{ ...TYPO.caption, lineHeight: '12px', color: SV.t4, fontVariantNumeric: 'tabular-nums' }}>
          <span style={{ color: LIME[500], fontWeight: 600 }}>{step + 1}</span> / {total}
        </span>
      </div>
    </div>
  );
}

// ---------- 페이지 타이틀 (VybePageTitle) ----------
// age_limit_19.svg — 원본 asset path 그대로
const SV_INFO_D = 'M12 6C12 2.6862 9.3138 0 6 0C2.6862 0 0 2.6862 0 6C0 9.3138 2.6862 12 6 12C9.3138 12 12 9.3138 12 6ZM6 3C6.15913 3 6.31174 3.06321 6.42426 3.17574C6.53679 3.28826 6.6 3.44087 6.6 3.6V6.6C6.6 6.75913 6.53679 6.91174 6.42426 7.02426C6.31174 7.13679 6.15913 7.2 6 7.2C5.84087 7.2 5.68826 7.13679 5.57574 7.02426C5.46321 6.91174 5.4 6.75913 5.4 6.6V3.6C5.4 3.44087 5.46321 3.28826 5.57574 3.17574C5.68826 3.06321 5.84087 3 6 3ZM5.4 8.4C5.4 8.24087 5.46321 8.08826 5.57574 7.97574C5.68826 7.86321 5.84087 7.8 6 7.8H6.0048C6.16393 7.8 6.31654 7.86321 6.42906 7.97574C6.54159 8.08826 6.6048 8.24087 6.6048 8.4C6.6048 8.55913 6.54159 8.71174 6.42906 8.82426C6.31654 8.93679 6.16393 9 6.0048 9H6C5.84087 9 5.68826 8.93679 5.57574 8.82426C5.46321 8.71174 5.4 8.55913 5.4 8.4Z';

// VybeStatusMessage — 타입별 색·아이콘 매핑 (error: red500 / success: blue500 / 그 외: gray500)
function SVStatus({ message, type = 'default' }) {
  const c = type === 'error' ? RED[500] : type === 'success' ? BLUE[500] : GRAY[500];
  return (
    <div style={{ display: 'inline-flex', alignItems: 'center', gap: 4, fontSize: 12, lineHeight: '14px', letterSpacing: '-0.025em', color: c }}>
      {type === 'warn' && <svg width="12" height="12" viewBox="0 0 12 12" fill="none" style={{ flexShrink: 0 }}><path fillRule="evenodd" clipRule="evenodd" d={SV_INFO_D} fill={GRAY[500]} /></svg>}
      {type === 'error' && <svg width="12" height="12" viewBox="0 0 24 24" fill={RED[500]} style={{ flexShrink: 0 }}><path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm0 15.2a1.2 1.2 0 1 1 0-2.4 1.2 1.2 0 0 1 0 2.4zm1.1-5.1a1.1 1.1 0 0 1-2.2 0V7.3a1.1 1.1 0 0 1 2.2 0z" /></svg>}
      {type === 'success' && <svg width="12" height="12" viewBox="0 0 24 24" fill={BLUE[500]} style={{ flexShrink: 0 }}><path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm-1.3 14.3L6.4 12l1.5-1.5 2.8 2.8 5.4-5.4L17.6 9.4z" /></svg>}
      {message}
    </div>
  );
}

function SVTitle({ hl, rest, caption, captionType = 'error' }) {
  return (
    <div>
      <div style={{ fontWeight: 600, fontSize: 24, lineHeight: '30px', letterSpacing: '-0.025em', color: '#fff' }}>
        <span style={{ color: LIME[500] }}>{hl}</span>{rest}
      </div>
      {caption && <div style={{ marginTop: 12 }}><SVStatus message={caption} type={captionType} /></div>}
    </div>
  );
}

// ---------- 삭제(x) 버튼 ----------
const SV_CLEAR_D = 'M9 0C13.9706 0 18 4.02944 18 9C18 13.9706 13.9706 18 9 18C4.02944 18 0 13.9706 0 9C0 4.02944 4.02944 0 9 0ZM12.4951 5.50488C12.2218 5.23153 11.7783 5.23155 11.5049 5.50488L9 8.00977L6.49512 5.50488C6.22176 5.23153 5.77825 5.23155 5.50488 5.50488C5.23152 5.77825 5.23152 6.22175 5.50488 6.49512L8.00977 9L5.50488 11.5049L5.41602 11.6143C5.23642 11.886 5.26561 12.2558 5.50488 12.4951C5.7441 12.7343 6.11308 12.7634 6.38477 12.584L6.49512 12.4951L9 9.99023L11.5049 12.4951L11.6143 12.584C11.886 12.7636 12.2559 12.7344 12.4951 12.4951C12.7344 12.2558 12.7636 11.886 12.584 11.6143L12.4951 11.5049L9.99023 9L12.4951 6.49512C12.7684 6.22177 12.7684 5.77825 12.4951 5.50488Z';

function SVClear({ onClick }) {
  return (
    <button onMouseDown={(e) => e.preventDefault()} onClick={onClick} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, width: 18, height: 18, display: 'grid', placeItems: 'center', marginLeft: 8 }}>
      <svg width="18" height="18" viewBox="0 0 18 18" fill="none" style={{ display: 'block' }}><path d={SV_CLEAR_D} fill={GRAY[700]} /></svg>
    </button>
  );
}

// 밑줄 + 활성 시 보라 언더글로우
function SVUnderline({ color, active }) {
  return (
    <div style={{ position: 'relative', height: 1, background: color, transition: 'background .18s' }}>
      <div style={{ position: 'absolute', left: 0, right: 0, top: 0, height: 1, background: color, filter: 'blur(4px)', opacity: active ? 0.9 : 0, transition: 'opacity .2s' }} />
    </div>
  );
}

// ---------- 텍스트 필드 (VybeTextField) ----------
function SVField({ value, onChange, hint, inputRef, type = 'text', error, onClear }) {
  const [focus, setFocus] = svState(false);
  const line = error ? RED[500] : (focus || value) ? PURPLE[500] : GRAY[700];
  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', paddingBottom: 9 }}>
        <input
          ref={inputRef} value={value} onChange={(e) => onChange(e.target.value)}
          onFocus={() => setFocus(true)} onBlur={() => setFocus(false)}
          placeholder={hint} inputMode={type === 'tel' ? 'numeric' : 'text'}
          style={{ ...SV_INPUT_FONT, flex: 1, minWidth: 0, background: 'transparent', border: 0, outline: 'none', padding: '4px 0', color: error ? RED[700] : GRAY[200], caretColor: PURPLE[500] }} />
        {!!value && onClear && <SVClear onClick={onClear} />}
      </div>
      <SVUnderline color={line} active={focus && !error} />
    </div>
  );
}

// ---------- 생년월일 (BirthInput) ----------
function SVBirth({ front, back, setFront, setBack, frontRef, backRef, error, readOnly, onTap }) {
  const [focus, setFocus] = svState(false);
  const line = error ? RED[500] : (!readOnly && focus) ? PURPLE[500] : GRAY[700];
  const txt = error ? RED[700] : focus ? GRAY[200] : GRAY[600];
  const dot = error ? 'rgba(255,92,95,0.55)' : GRAY[700];
  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', padding: '4px 0 9px' }} onClick={readOnly ? onTap : undefined}>
        <input ref={frontRef} value={front} readOnly={readOnly} inputMode="numeric" placeholder="생년월일 6자리"
          onFocus={() => setFocus(true)} onBlur={() => setFocus(false)}
          onChange={(e) => setFront(e.target.value.replace(/\D/g, '').slice(0, 6))}
          style={{ ...SV_INPUT_FONT, flex: 1, minWidth: 0, letterSpacing: front ? '10.56px' : '-0.025em', background: 'transparent', border: 0, outline: 'none', color: txt, caretColor: PURPLE[500] }} />
        <span style={{ ...SV_INPUT_FONT, color: GRAY[600], padding: '0 12px' }}>—</span>
        <input ref={backRef} value={back} readOnly={readOnly} inputMode="numeric" maxLength={1}
          onFocus={() => setFocus(true)} onBlur={() => setFocus(false)}
          onChange={(e) => setBack(e.target.value.replace(/\D/g, '').slice(0, 1))}
          style={{ ...SV_INPUT_FONT, width: 20, background: 'transparent', border: 0, outline: 'none', color: txt, caretColor: PURPLE[500] }} />
        <div style={{ display: 'flex', gap: 6, marginLeft: 6 }}>
          {Array.from({ length: 6 }, (_, i) => <span key={i} style={{ width: 8, height: 8, borderRadius: 99, background: dot, transition: 'background .18s' }} />)}
        </div>
        {!readOnly && (front || back) && <SVClear onClick={() => { setFront(''); setBack(''); }} />}
      </div>
      <SVUnderline color={line} active={!readOnly && focus && !error} />
    </div>
  );
}

// ---------- 통신사 트리거 (CarrierDropdownField) ----------
function SVCarrierField({ value, onTap, active }) {
  const line = (active || value) ? PURPLE[500] : GRAY[700];
  return (
    <div onClick={onTap} style={{ cursor: 'pointer' }}>
      <div style={{ display: 'flex', alignItems: 'center', padding: '4px 0 9px' }}>
        <span style={{ ...SV_INPUT_FONT, flex: 1, color: value ? GRAY[200] : GRAY[600] }}>{value || '통신사를 선택해주세요.'}</span>
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={GRAY[500]} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9" /></svg>
      </div>
      <SVUnderline color={line} active={active} />
    </div>
  );
}

// ---------- 완료된 필드 (CompletedField 리뉴얼) ----------
// 원본은 24sp 필드가 그대로 아래에 쌓여 화면을 채웠다 → 값이 확정된 항목은 리퀴드 글래스 행으로 접는다
function SVDone({ label, value, onEdit }) {
  const [press, setPress] = svState(false);
  return (
    <button onClick={onEdit}
      onPointerDown={() => setPress(true)} onPointerUp={() => setPress(false)} onPointerLeave={() => setPress(false)}
      style={{
        all: 'unset', boxSizing: 'border-box', cursor: 'pointer', position: 'relative', overflow: 'hidden',
        display: 'flex', alignItems: 'center', gap: 12, width: '100%', padding: '14px 16px', borderRadius: 16,
        background: 'linear-gradient(158deg, rgba(255,255,255,0.13) 0%, rgba(255,255,255,0.05) 42%, rgba(255,255,255,0.02) 100%)',
        border: '1px solid rgba(255,255,255,0.10)', ...SV_BLUR(20),
        boxShadow: press
          ? 'inset 0 1px 0 rgba(255,255,255,0.30), inset 0 -1px 0 rgba(255,255,255,0.06), 0 2px 10px rgba(0,0,0,0.28)'
          : 'inset 0 1px 0 rgba(255,255,255,0.22), inset 0 -1px 0 rgba(255,255,255,0.05), 0 8px 22px rgba(0,0,0,0.34)',
        transform: press ? 'scale(0.985)' : 'none',
        transition: 'transform .22s cubic-bezier(.2,.8,.2,1), box-shadow .22s ease',
      }}>
      {/* 굴절광 — 좌상단에서 흘러드는 스펙큘러 */}
      <span aria-hidden style={{ position: 'absolute', left: -30, top: -46, width: 190, height: 96, borderRadius: '50%', background: 'radial-gradient(closest-side, rgba(255,255,255,0.20), transparent 70%)', filter: 'blur(10px)', pointerEvents: 'none' }} />
      <span aria-hidden style={{ position: 'absolute', right: -40, bottom: -52, width: 150, height: 90, borderRadius: '50%', background: 'radial-gradient(closest-side, rgba(119,49,254,0.26), transparent 72%)', filter: 'blur(12px)', pointerEvents: 'none' }} />
      <span style={{ position: 'relative', flexShrink: 0, width: 16, height: 16, borderRadius: 99, background: 'rgba(181,255,96,0.16)', border: `1px solid rgba(181,255,96,0.34)`, display: 'grid', placeItems: 'center' }}>
        <svg width="8" height="8" viewBox="0 0 24 24" fill="none" stroke={LIME[500]} strokeWidth="4.4" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>
      </span>
      <span style={{ position: 'relative', ...TYPO.caption, lineHeight: '14px', color: SV.t4, flexShrink: 0 }}>{label}</span>
      <span style={{ position: 'relative', flex: 1, minWidth: 0, textAlign: 'right', fontSize: 15, fontWeight: 500, letterSpacing: '-0.025em', color: SV.t2, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{value}</span>
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke={GRAY[600]} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ position: 'relative', flexShrink: 0 }}><path d="M12 20h9" /><path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4z" /></svg>
    </button>
  );
}

// ---------- 하단 시트 공통 ----------
function SVSheet({ onClose, children, pad = 24 }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 80, display: 'flex', flexDirection: 'column', justifyContent: 'flex-end' }}>
      <div onClick={onClose} style={{ position: 'absolute', inset: 0, background: 'rgba(14,13,18,0.66)', ...SV_BLUR(6), animation: 'svFade .2s ease' }} />
      <div style={{ position: 'relative', borderRadius: '24px 24px 0 0', background: 'rgba(32,30,40,0.86)', ...SV_BLUR(28), borderTop: `1px solid rgba(255,255,255,0.14)`, padding: `10px ${pad}px 34px`, animation: 'svSheet .3s cubic-bezier(.2,.85,.25,1)' }}>
        <div style={{ width: 36, height: 4, borderRadius: 99, background: 'rgba(255,255,255,0.18)', margin: '0 auto 20px' }} />
        {children}
      </div>
    </div>
  );
}

// ---------- 통신사 시트 (CarrierSheet) ----------
const SV_CARRIERS = ['SKT', 'KT', 'LGU+', 'SKT 알뜰폰', 'KT 알뜰폰', 'LGU+ 알뜰폰'];

function SVCarrierRow({ label, on, onClick }) {
  const [press, setPress] = svState(false);
  return (
    <button onClick={onClick}
      onPointerDown={() => setPress(true)} onPointerUp={() => setPress(false)} onPointerLeave={() => setPress(false)}
      style={{
        all: 'unset', boxSizing: 'border-box', cursor: 'pointer', position: 'relative', overflow: 'hidden',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between', width: '100%', height: 54, padding: '0 18px', borderRadius: 15,
        background: on
          ? 'linear-gradient(158deg, rgba(181,255,96,0.20) 0%, rgba(181,255,96,0.07) 45%, rgba(255,255,255,0.03) 100%)'
          : 'linear-gradient(158deg, rgba(255,255,255,0.13) 0%, rgba(255,255,255,0.05) 42%, rgba(255,255,255,0.02) 100%)',
        border: `1px solid ${on ? 'rgba(181,255,96,0.34)' : 'rgba(255,255,255,0.10)'}`, ...SV_BLUR(20),
        boxShadow: press
          ? 'inset 0 1px 0 rgba(255,255,255,0.30), inset 0 -1px 0 rgba(255,255,255,0.06), 0 2px 10px rgba(0,0,0,0.28)'
          : `inset 0 1px 0 rgba(255,255,255,0.22), inset 0 -1px 0 rgba(255,255,255,0.05), 0 8px 22px rgba(0,0,0,0.34)${on ? ', 0 0 0 3px rgba(181,255,96,0.10)' : ''}`,
        transform: press ? 'scale(0.985)' : 'none',
        fontSize: 18, fontWeight: on ? 600 : 400, letterSpacing: '-0.025em', color: on ? LIME[500] : SV.t2,
        transition: 'transform .22s cubic-bezier(.2,.8,.2,1), box-shadow .22s ease, background .18s, border-color .18s, color .14s',
      }}>
      <span aria-hidden style={{ position: 'absolute', left: -30, top: -44, width: 190, height: 92, borderRadius: '50%', background: 'radial-gradient(closest-side, rgba(255,255,255,0.20), transparent 70%)', filter: 'blur(10px)', pointerEvents: 'none' }} />
      <span aria-hidden style={{ position: 'absolute', right: -40, bottom: -50, width: 150, height: 88, borderRadius: '50%', background: on ? 'radial-gradient(closest-side, rgba(181,255,96,0.24), transparent 72%)' : 'radial-gradient(closest-side, rgba(119,49,254,0.26), transparent 72%)', filter: 'blur(12px)', pointerEvents: 'none' }} />
      <span style={{ position: 'relative' }}>{label}</span>
      {on && <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={LIME[500]} strokeWidth="2.8" strokeLinecap="round" strokeLinejoin="round" style={{ position: 'relative' }}><polyline points="20 6 9 17 4 12" /></svg>}
    </button>
  );
}

function SVCarrierSheet({ selected, onSelect, onClose }) {
  return (
    <SVSheet onClose={onClose}>
      <div style={{ ...TYPO.h4, color: '#fff', padding: '0 4px 20px' }}>통신사를 선택해주세요.</div>
      <div style={{ display: 'grid', gap: 8 }}>
        {SV_CARRIERS.map(c => <SVCarrierRow key={c} label={c} on={selected === c} onClick={() => onSelect(c)} />)}
      </div>
    </SVSheet>
  );
}

// ---------- 약관 동의 시트 (TermsAgreementSheet) ----------
const SV_TERMS = [
  { t: '개인정보 수집∙이용 동의', req: true },
  { t: '만 19세 이상입니다', req: true },
  { t: '서비스 이용약관 동의', req: true },
  { t: '개인정보 마케팅 활용 동의', req: false },
];

// box_checked.svg / box_unchecked.svg — rx 1.5 사각 테두리 + 체크 path (둘 다 배경 투명)
const SV_TICK_D = 'M5.70443 10.5884L3.21906 8.27037C3.08514 8.14547 2.90351 8.0753 2.71411 8.0753C2.52472 8.0753 2.34308 8.14547 2.20916 8.27037C2.07524 8.39528 2 8.56468 2 8.74133C2 8.82879 2.01847 8.9154 2.05436 8.9962C2.09025 9.07701 2.14285 9.15043 2.20916 9.21228L5.20306 12.0046C5.4824 12.2651 5.93363 12.2651 6.21297 12.0046L13.7908 4.93697C13.9248 4.81206 14 4.64266 14 4.46602C14 4.28937 13.9248 4.11997 13.7908 3.99506C13.6569 3.87016 13.4753 3.79999 13.2859 3.79999C13.0965 3.79999 12.9149 3.87016 12.7809 3.99506L5.70443 10.5884Z';
// check_checked.svg / check_unchecked.svg — 박스 없는 큰 체크 (전체 동의하기용)
const SV_BIGTICK_D = 'M5.32184 10.7378L2.42224 7.8382C2.266 7.68195 2.05409 7.59418 1.83313 7.59418C1.61217 7.59418 1.40026 7.68195 1.24402 7.8382C1.08778 7.99444 1 8.20635 1 8.42731C1 8.53672 1.02155 8.64505 1.06342 8.74613C1.10529 8.84721 1.16665 8.93906 1.24402 9.01642L4.73691 12.5093C5.0628 12.8352 5.58924 12.8352 5.91513 12.5093L14.756 3.66846C14.9122 3.51222 15 3.30031 15 3.07935C15 2.85839 14.9122 2.64648 14.756 2.49023C14.5997 2.33399 14.3878 2.24622 14.1669 2.24622C13.9459 2.24622 13.734 2.33399 13.5778 2.49023L5.32184 10.7378Z';

// bare=true → check_*.svg (박스 없음, 전체 동의하기), 그 외 box_*.svg
function SVCheck({ on, size = 16, bare }) {
  const c = on ? LIME[500] : '#8F8F8F';
  return (
    <svg width={size} height={size} viewBox="0 0 16 16" fill="none" style={{ flexShrink: 0, display: 'block', transition: 'color .15s' }}>
      {!bare && <rect x="0.5" y="0.5" width="15" height="15" rx="1.5" stroke={c} />}
      <path d={bare ? SV_BIGTICK_D : SV_TICK_D} fill={on ? LIME[500] : (bare ? '#8F8F8F' : 'none')} />
    </svg>
  );
}

function SVTermsSheet({ onClose, onConfirm }) {
  const [checked, setChecked] = svState([false, false, false, false]);
  const all = checked.every(Boolean);
  const req = SV_TERMS.every((t, i) => !t.req || checked[i]);
  return (
    <SVSheet onClose={onClose} pad={20}>
      <div style={{ ...TYPO.h4, color: '#fff', padding: '0 4px 24px' }}>서비스 이용을 위해<br />동의가 필요해요.</div>
      <button onClick={() => setChecked(Array(4).fill(!all))} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, width: '100%', padding: '15px 16px', borderRadius: 14, background: all ? 'rgba(181,255,96,0.09)' : SV.tileFill, border: `1px solid ${all ? 'rgba(181,255,96,0.30)' : SV.tileBorder}`, transition: 'background .15s, border-color .15s' }}>
        <SVCheck on={all} size={20} bare />
        <span style={{ fontSize: 18, fontWeight: 500, letterSpacing: '-0.025em', color: all ? '#fff' : SV.t2 }}>전체 동의하기</span>
      </button>
      <div style={{ display: 'grid', gap: 2, padding: '10px 4px 0' }}>
        {SV_TERMS.map((t, i) => (
          <div key={t.t} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '11px 12px' }}>
            <button onClick={() => setChecked(c => c.map((v, j) => j === i ? !v : v))} style={{ all: 'unset', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 12, flex: 1, minWidth: 0 }}>
              <SVCheck on={checked[i]} size={16} />
              <span style={{ fontSize: 14, letterSpacing: '-0.025em', color: checked[i] ? SV.t1 : SV.t3, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                <span style={{ color: t.req ? LIME[500] : GRAY[600], fontWeight: 500 }}>[{t.req ? '필수' : '선택'}]</span> {t.t}
              </span>
            </button>
            <button style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, padding: 4 }}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M9 5L16 12L9 19" stroke="#8F8F8F" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" /></svg>
            </button>
          </div>
        ))}
      </div>
      <button onClick={() => req && onConfirm()} disabled={!req} style={{
        all: 'unset', boxSizing: 'border-box', width: '100%', height: 56, marginTop: 22, borderRadius: 12, display: 'grid', placeItems: 'center',
        cursor: req ? 'pointer' : 'default', background: req ? PURPLE[500] : PURPLE.disabled, color: req ? '#fff' : 'rgba(255,255,255,0.8)',
        fontWeight: 500, fontSize: 18, letterSpacing: '-0.45px', transition: 'background .12s',
      }}>확인</button>
    </SVSheet>
  );
}

// ---------- 로딩 오버레이 (VybeLoadingOverlay) ----------
function SVLoading() {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 95, display: 'grid', placeItems: 'center', background: 'rgba(14,13,18,0.62)', ...SV_BLUR(4), animation: 'svFade .2s ease' }}>
      <div style={{ width: 44, height: 44, borderRadius: 99, background: `conic-gradient(from 0deg, ${PURPLE[500]}, ${LIME[500]}, ${PURPLE[500]})`, WebkitMask: 'radial-gradient(farthest-side, transparent calc(100% - 4px), #000 0)', mask: 'radial-gradient(farthest-side, transparent calc(100% - 4px), #000 0)', animation: 'svSpin 1s linear infinite' }} />
    </div>
  );
}

// ---------- 토스트 (VybeToast) ----------
function SVToast({ msg, err }) {
  return (
    <div style={{ position: 'absolute', left: 0, right: 0, bottom: 118, zIndex: 96, display: 'flex', justifyContent: 'center', pointerEvents: 'none', opacity: msg ? 1 : 0, transform: msg ? 'none' : 'translateY(8px)', transition: 'opacity .22s ease, transform .22s ease' }}>
      <div style={{ display: 'inline-flex', alignItems: 'center', gap: 9, padding: '12px 18px', borderRadius: 99, background: 'rgba(26,26,30,0.94)', border: `1px solid ${SV.hair}`, boxShadow: '0 10px 30px rgba(0,0,0,0.5)', ...SV_BLUR(18) }}>
        <span style={{ width: 19, height: 19, borderRadius: 99, background: err ? RED[500] : LIME[500], display: 'grid', placeItems: 'center' }}>
          {err ? <span style={{ font: '800 11px/1 Pretendard, sans-serif', color: '#fff' }}>!</span>
            : <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#101013" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>}
        </span>
        <span style={{ fontSize: 14, color: '#fff', letterSpacing: '-0.025em' }}>{msg}</span>
      </div>
    </div>
  );
}

Object.assign(window, { SV, SV_BLUR, SV_INPUT_FONT, SVStatus, SV_CLEAR_D, SV_INFO_D, SV_TICK_D, SV_BIGTICK_D, SVCarrierRow, SVGlassBtn, SVHeader, SVTitle, SVField, SVBirth, SVCarrierField, SVDone, SVSheet, SVCarrierSheet, SV_CARRIERS, SVTermsSheet, SV_TERMS, SVCheck, SVLoading, SVToast, svState });
