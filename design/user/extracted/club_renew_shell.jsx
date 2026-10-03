/* global React, TYPO, GRAY, LIME, PURPLE, RED, window */
// ============ VYBE — Club Detail · Renewal · shell (tokens + primitives) ============
// 모든 값은 uploads/design_system.html 규격. 393pt 기준 1sp = 1px.
const { useState: vrState, useEffect: vrEffect, useRef: vrRef } = React;

const VR = {
  bg: '#101013', surface: '#1A1A1E', ink: '#0E0D12',
  cardFill: 'rgba(120,120,128,0.16)', cardBorder: 'rgba(255,255,255,0.10)',
  tileFill: 'rgba(255,255,255,0.07)', tileBorder: 'rgba(255,255,255,0.12)',
  quietFill: 'rgba(120,120,128,0.08)', quietBorder: 'rgba(255,255,255,0.06)',
  barFill: 'rgba(14,13,18,0.55)', hair: 'rgba(255,255,255,0.09)',
  t1: '#fff', t2: 'rgba(255,255,255,0.82)', t3: 'rgba(255,255,255,0.68)', t4: GRAY[500],
  lavender: '#C8A8FF', link: '#8FB5FF',
  // ClubAurora — 좌상단 보라 · 우상단 라임 · 우하단 보라 3겹
  aurora: ['radial-gradient(120% 80% at 0% 0%, rgba(119,49,254,0.50), transparent 72%)', 'radial-gradient(110% 80% at 100% 2%, rgba(181,255,96,0.26), transparent 74%)', 'radial-gradient(120% 90% at 88% 100%, rgba(119,49,254,0.34), transparent 76%)', '#0E0D12'].join(', '),
};
// VybeSpacing — 4px 그리드
const SP = { xs: 4, sm: 8, md: 12, lg: 16, xl: 20, xxl: 24, xxxl: 32, xxxxl: 40 };
const PAGE_H = 24; // pagePaddingH 24.w
// VybeButton 라벨 — Medium 500 · 18sp · lh 1
const VR_BTN_LABEL = { fontWeight: 500, fontSize: 18, lineHeight: 1, letterSpacing: '-0.025em' };
const VR_BLUR = (px) => ({ backdropFilter: `blur(${px}px) saturate(180%)`, WebkitBackdropFilter: `blur(${px}px) saturate(180%)` });

// ---------- icons ----------
const VRPATH = {
  pin: '<path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>',
  clock: '<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>',
  ticket: '<path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z"/><path d="M13 5v2"/><path d="M13 17v2"/><path d="M13 11v2"/>',
  link: '<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>',
  phone: '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.37 1.9.72 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.35 1.85.59 2.81.72A2 2 0 0 1 22 16.92z"/>',
  nav: '<polygon points="3 11 22 2 13 21 11 13 3 11"/>',
  share: '<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>',
  heart: '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>',
  pen: '<path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/>',
  copy: '<rect x="9" y="9" width="12" height="12" rx="2"/><path d="M5 15V5a2 2 0 0 1 2-2h8"/>',
  parking: '<rect x="4" y="3" width="16" height="18" rx="2"/><path d="M9 16V7h3.5a3 3 0 1 1 0 6H9"/>',
  restroom: '<circle cx="8.5" cy="5.5" r="2"/><path d="M5 21v-6.5a3.5 3.5 0 0 1 7 0V21"/><circle cx="17" cy="6.5" r="1.8"/><path d="M14.7 21v-5.2l-1-3.3a1.3 1.3 0 0 1 1.25-1.7h4.1a1.3 1.3 0 0 1 1.25 1.7l-1 3.3V21"/>',
  smoking: '<rect x="2" y="15" width="15" height="4" rx="1"/><line x1="12" y1="15" x2="12" y2="19"/><path d="M19 12c.7-.9.7-2.1 0-3"/><path d="M21.5 13.5c1.2-1.6 1.2-3.9 0-5.5"/>',
  locker: '<rect x="4" y="2.5" width="16" height="19" rx="2"/><line x1="4" y1="12" x2="20" y2="12"/><circle cx="15" cy="7.5" r="1"/><circle cx="15" cy="16.5" r="1"/>',
  card: '<rect x="2" y="5" width="20" height="14" rx="2.2"/><line x1="2" y1="10" x2="22" y2="10"/>',
  groupSeat: '<circle cx="9" cy="7" r="3.6"/><path d="M2.5 21v-1.5a5 5 0 0 1 5-5h3a5 5 0 0 1 5 5V21"/><circle cx="17.5" cy="7.8" r="2.6"/><path d="M16 3.3a3 3 0 0 1 0 5.8"/>',
  info: '<circle cx="12" cy="12" r="10"/><line x1="12" y1="11" x2="12" y2="16.5"/><circle cx="12" cy="7.8" r="1"/>',
  bellFree: '<path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/>',
};
const VRIcon = ({ d, size = 18, c = VR.t2, w = 1.85, fill = 'none' }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={c} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round" dangerouslySetInnerHTML={{ __html: d }} />
);
const VRChev = ({ dir = 'down', size = 16, c = 'rgba(255,255,255,0.5)', w = 2.2 }) => {
  const pts = { down: '6 9 12 15 18 9', right: '9 6 15 12 9 18', left: '15 18 9 12 15 6' }[dir];
  return <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round"><polyline points={pts} /></svg>;
};
const VRStar = ({ size = 14, c = LIME[500] }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={c}><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>
);

// ---------- 글래스 표면 (VybeGlassSurface / GlassCard) ----------
function VGlass({ children, quiet, radius = 19, pad = SP.lg, elevated = true, style }) {
  return (
    <div style={{ position: 'relative', boxSizing: 'border-box', flexShrink: 0, borderRadius: radius, padding: pad, overflow: 'hidden', background: quiet ? VR.quietFill : VR.cardFill, border: `1px solid ${quiet ? VR.quietBorder : VR.cardBorder}`, ...VR_BLUR(quiet ? 14 : 18), boxShadow: !quiet && elevated ? '0 10px 30px rgba(0,0,0,0.36)' : 'none', ...style }}>
      <div aria-hidden style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 1, background: quiet ? 'rgba(255,255,255,0.08)' : 'rgba(255,255,255,0.18)' }} />
      {children}
    </div>
  );
}

// ---------- GlassSectionHead ----------
function VHead({ title, sub, href, action = '전체보기', pad = 0 }) {
  return (
    <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: SP.md, padding: `0 ${pad}px`, marginBottom: SP.md }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: SP.sm, minWidth: 0 }}>
        <h2 style={{ ...TYPO.h4, color: VR.t1, margin: 0 }}>{title}</h2>
        {sub && <span style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4 }}>{sub}</span>}
      </div>
      {href && <a href={href} style={{ ...TYPO.button2, color: VR.lavender, textDecoration: 'none', display: 'inline-flex', alignItems: 'center', gap: 2, flexShrink: 0 }}>{action}<VRChev dir="right" size={13} c={VR.lavender} /></a>}
    </div>
  );
}

// ---------- VybeMetaDot ----------
const VDot = () => <span style={{ width: 3, height: 3, borderRadius: 99, background: GRAY[600], flexShrink: 0 }} />;
function VMeta({ items, style }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 6, ...TYPO.body4, color: VR.t3, ...style }}>
      {items.map((t, i) => <React.Fragment key={i}>{i > 0 && <VDot />}<span>{t}</span></React.Fragment>)}
    </div>
  );
}

// ---------- OpenStatusPill / VybeRecommendBadge ----------
function VStatusPill({ open = true, label, size = 11 }) {
  const c = open ? LIME[500] : RED[500];
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 10px', borderRadius: 99, background: open ? 'rgba(181,255,96,0.14)' : 'rgba(255,92,95,0.13)', border: `1px solid ${open ? 'rgba(181,255,96,0.30)' : 'rgba(255,92,95,0.28)'}`, color: c, fontWeight: 600, fontSize: size, lineHeight: 1, letterSpacing: '-0.025em', flexShrink: 0 }}>
      <span style={{ width: 5, height: 5, borderRadius: 99, background: 'currentColor' }} />
      {label || (open ? '영업중' : '영업종료')}
    </span>
  );
}
// 전역 단일 디자인 — size만 조절
function VRecBadge({ size = 11 }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, padding: '3px 8px', borderRadius: 99, background: 'rgba(181,255,96,0.14)', border: '1px solid rgba(181,255,96,0.28)', color: LIME[500], fontWeight: 600, fontSize: size, lineHeight: `${size + 3}px`, letterSpacing: '-0.025em', flexShrink: 0 }}>
      <svg width={size - 2} height={size - 2} viewBox="0 0 12 12" fill={LIME[500]}><path d="M6 0l6 6-6 6-6-6z" /></svg>
      VYBE 추천
    </span>
  );
}

// ---------- VybeButton (56.h · radius 12 · 100ms) ----------
function VButton({ label, onClick, href, variant = 'default', disabled, icon, style }) {
  const [down, setDown] = vrState(false);
  const lime = variant === 'lime';
  const bg = disabled ? PURPLE.disabled : variant === 'quiet' ? (down ? 'rgba(255,255,255,0.12)' : VR.tileFill) : lime ? (down ? LIME[700] : LIME[500]) : (down ? PURPLE[700] : PURPLE[500]);
  const fg = disabled ? 'rgba(255,255,255,0.8)' : lime ? VR.ink : '#fff';
  const st = { all: 'unset', boxSizing: 'border-box', cursor: disabled ? 'not-allowed' : 'pointer', height: 56, borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: SP.sm, background: bg, border: variant === 'quiet' ? `1px solid ${VR.tileBorder}` : 'none', transition: 'background .1s linear', ...VR_BTN_LABEL, color: fg, ...style };
  const press = disabled ? {} : { onPointerDown: () => setDown(true), onPointerUp: () => setDown(false), onPointerLeave: () => setDown(false) };
  const body = <>{icon && <VRIcon d={icon} size={19} c={fg} w="2" />}{label}</>;
  return href && !disabled ? <a href={href} style={st} {...press}>{body}</a> : <button onClick={disabled ? undefined : onClick} style={st} {...press}>{body}</button>;
}

// ---------- 원형 글래스 버튼 (VybeGlassButton) ----------
function VGlassRound({ children, onClick, href, size = 38 }) {
  const st = { all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: size, height: size, borderRadius: '50%', background: 'rgba(20,18,26,0.42)', ...VR_BLUR(14), border: '1px solid rgba(255,255,255,0.16)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.18)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 };
  return href ? <a href={href} style={st}>{children}</a> : <button onClick={onClick} style={st}>{children}</button>;
}

// ---------- VybeFooterNote / VybeToast ----------
function VFooterNote({ children }) {
  return (
    <div style={{ display: 'flex', gap: 9, padding: '13px 15px', borderRadius: 12, background: 'rgba(255,255,255,0.04)', border: `1px solid ${VR.hair}`, flexShrink: 0 }}>
      <span style={{ flexShrink: 0, marginTop: 1 }}><VRIcon d={VRPATH.info} size={14} c={VR.t4} w="1.7" /></span>
      <span style={{ ...TYPO.caption, lineHeight: '18px', color: VR.t4 }}>{children}</span>
    </div>
  );
}
function VToast({ msg }) {
  if (!msg) return null;
  return (
    <div style={{ position: 'absolute', left: 0, right: 0, bottom: 118, display: 'flex', justifyContent: 'center', zIndex: 80, pointerEvents: 'none' }}>
      <div style={{ display: 'inline-flex', alignItems: 'center', gap: 9, padding: '12px 18px', borderRadius: 99, background: 'rgba(26,26,30,0.94)', border: `1px solid ${VR.hair}`, ...VR_BLUR(18), boxShadow: '0 10px 30px rgba(0,0,0,0.5)', animation: 'vrToast .22s ease' }}>
        <span style={{ width: 19, height: 19, borderRadius: 99, background: LIME[500], display: 'grid', placeItems: 'center', flexShrink: 0 }}>
          <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke={VR.ink} strokeWidth="3.4" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>
        </span>
        <span style={{ ...TYPO.body4, color: '#fff' }}>{msg}</span>
      </div>
    </div>
  );
}

// ---------- VybeFadeInUp — index × 45ms ----------
function VFadeUp({ i = 0, children, style }) {
  const [on, setOn] = vrState(false);
  vrEffect(() => { const t = setTimeout(() => setOn(true), 40 + i * 45); return () => clearTimeout(t); }, []);
  return <div style={{ flexShrink: 0, opacity: on ? 1 : 0, transform: on ? 'none' : 'translateY(6px)', transition: 'opacity .28s ease, transform .28s ease', ...style }}>{children}</div>;
}

Object.assign(window, { VR, SP, PAGE_H, VR_BTN_LABEL, VR_BLUR, VRPATH, VRIcon, VRChev, VRStar, VGlass, VHead, VDot, VMeta, VStatusPill, VRecBadge, VButton, VGlassRound, VFooterNote, VToast, VFadeUp, vrState, vrEffect, vrRef });
