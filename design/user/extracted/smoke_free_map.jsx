/* global React, TYPO, GRAY, PURPLE, LIME */
const { useState: useStateM } = React;
const ACC_M = LIME[500], ON_ACC_M = '#12210a', PIN_M = PURPLE[700];

/* 디자인 시스템 · 리퀴드 글래스 토큰 (ClubGlass / VybeGlassSurface) */
const G = {
  ink: '#0E0D12',
  hair: 'rgba(255,255,255,0.09)',
  t1: '#fff', t2: 'rgba(255,255,255,0.82)', t3: 'rgba(255,255,255,0.68)', t4: '#9F9FA1',
  card: { background: 'rgba(120,120,128,0.16)', border: '1px solid rgba(255,255,255,0.10)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)', boxShadow: '0 10px 30px rgba(0,0,0,0.36)' },
  quiet: { background: 'rgba(120,120,128,0.08)', border: '1px solid rgba(255,255,255,0.06)', backdropFilter: 'blur(14px) saturate(160%)', WebkitBackdropFilter: 'blur(14px) saturate(160%)' },
  tile: { background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.12)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)' },
  bar: { background: 'rgba(14,13,18,0.55)', backdropFilter: 'blur(20px) saturate(180%)', WebkitBackdropFilter: 'blur(20px) saturate(180%)' },
};
/* VybeGenreBackdrop · 금연 = 라임 accent */
const SF_AURORA = 'radial-gradient(110% 80% at 0% 0%,rgba(181,255,96,0.30),transparent 72%),radial-gradient(110% 80% at 100% 2%,rgba(119,49,254,0.34),transparent 74%),radial-gradient(120% 90% at 88% 100%,rgba(119,49,254,0.20),transparent 76%),linear-gradient(180deg,#111A12 0%,#101013 58%,#0E0D12 100%)';

/* 글래스 카드 — 상단 1px 하이라이트 + 좌상단 스페큘러 */
function GCard({ children, style, radius = 20, quiet = false, as = 'div', href, onClick }) {
  const Tag = as;
  const base = { position: 'relative', overflow: 'hidden', borderRadius: radius, textDecoration: 'none', display: 'block', ...(quiet ? G.quiet : G.card), ...style };
  return (
    <Tag style={base} href={href} onClick={onClick}>
      <span aria-hidden style={{ position: 'absolute', left: 0, right: 0, top: 0, height: 1, background: quiet ? 'rgba(255,255,255,0.08)' : 'rgba(255,255,255,0.18)', pointerEvents: 'none' }} />
      <span aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 80% at 12% 0%, rgba(255,255,255,0.10), transparent 58%)', pointerEvents: 'none' }} />
      <div style={{ position: 'relative' }}>{children}</div>
    </Tag>
  );
}

function GlassRound({ children, onClick, href, size = 38 }) {
  const st = { all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: size, height: size, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0, ...G.tile };
  return href ? <a href={href} style={st}>{children}</a> : <button onClick={onClick} style={st}>{children}</button>;
}

const SFI = {
  Back: ({ size = 20, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.3" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>),
  Search: ({ size = 18, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  NoSmoke: ({ size = 15, color = ACC_M }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round"><circle cx="12" cy="12" r="9.2" /><line x1="5.5" y1="18.5" x2="18.5" y2="5.5" /></svg>),
  Star: ({ size = 13, color = ACC_M }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>),
  Pin: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" /></svg>),
  Target: ({ size = 17, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="7.5" /><circle cx="12" cy="12" r="2.4" fill={color} stroke="none" /><line x1="12" y1="1.5" x2="12" y2="4" /><line x1="12" y1="20" x2="12" y2="22.5" /><line x1="1.5" y1="12" x2="4" y2="12" /><line x1="20" y1="12" x2="22.5" y2="12" /></svg>),
  Plus: ({ size = 15, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.4" strokeLinecap="round"><line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" /></svg>),
  Minus: ({ size = 15, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.4" strokeLinecap="round"><line x1="5" y1="12" x2="19" y2="12" /></svg>),
  Expand: ({ size = 14, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 3 21 3 21 9" /><polyline points="9 21 3 21 3 15" /><line x1="21" y1="3" x2="14" y2="10" /><line x1="3" y1="21" x2="10" y2="14" /></svg>),
  Walk: ({ size = 12, color = 'rgba(255,255,255,0.55)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="13" cy="4" r="2" /><path d="M13 7l-2 5 3 3 1 6M11 12L7 15l-1 6M14 10l4 2" /></svg>),
  Heart: ({ size = 19, active = false }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  HomeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" /></svg>),
  AroundTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" /></svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  SavedTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  MeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" /></svg>),
};

function SFSectionHead({ title, sub, right }) {
  return (
    <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', gap: 12, padding: '0 16px', marginBottom: 14 }}>
      <div>
        <h2 style={{ ...TYPO.h4, fontSize: 20, lineHeight: '23px', fontWeight: 700, color: G.t1, margin: 0 }}>{title}</h2>
        {sub && <span style={{ ...TYPO.caption, color: G.t4, lineHeight: '16px', display: 'block', marginTop: 6 }}>{sub}</span>}
      </div>
      {right}
    </div>
  );
}

function SFChipRow({ items, active, onChange, pin = false }) {
  return (
    <div style={{ display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none', padding: '0 16px 2px' }}>
      {items.map(g => {
        const sel = g === active;
        return (
          <button key={g} onClick={() => onChange(g)} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, height: 34, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 15px', borderRadius: 999, ...(sel ? { background: ACC_M, border: '1px solid transparent', boxShadow: '0 6px 18px rgba(181,255,96,0.24)' } : G.tile), ...TYPO.button2, fontWeight: sel ? 700 : 500, color: sel ? ON_ACC_M : G.t2, transition: 'background .18s, color .18s' }}>
            {pin && <SFI.Pin size={12} color={sel ? ON_ACC_M : 'rgba(255,255,255,0.6)'} />}
            {g}
          </button>
        );
      })}
    </div>
  );
}

function SFPinShape({ color, size = 30 }) {
  return (
    <svg width={size} height={size * (27 / 24)} viewBox="0 0 24 27" fill="none" style={{ display: 'block', filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.5))' }}>
      <path d="M12 0C16.4183 0 20 3.58172 20 8C19.9999 10.5544 18.8005 12.8264 16.9365 14.291L13.3867 17.7031C12.6127 18.4469 11.3894 18.4468 10.6152 17.7031L7.06738 14.2959C5.20068 12.8314 4.00008 10.5566 4 8C4 3.58172 7.58172 0 12 0Z" fill={color} />
      <circle cx="12" cy="8" r="3" fill="#fff" />
    </svg>
  );
}

function SFMapCanvas({ pins, selected, onSelect, zoom }) {
  return (
    <div style={{ position: 'absolute', inset: 0, background: '#12141a', overflow: 'hidden' }}>
      <div style={{ position: 'absolute', inset: 0, transform: `scale(${zoom})`, transformOrigin: 'center 50%', transition: 'transform .4s cubic-bezier(0.32,0.72,0,1)' }}>
        <svg width="100%" height="100%" viewBox="0 0 361 300" preserveAspectRatio="xMidYMid slice" style={{ position: 'absolute', inset: 0 }}>
          <defs>
            <linearGradient id="sfmg" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stopColor="#1b1e26" /><stop offset="100%" stopColor="#101218" /></linearGradient>
            <pattern id="sfgrid" width="36" height="36" patternUnits="userSpaceOnUse"><path d="M 36 0 L 0 0 0 36" fill="none" stroke="#22252e" strokeWidth="0.5" /></pattern>
          </defs>
          <rect width="361" height="300" fill="url(#sfmg)" />
          <rect width="361" height="300" fill="url(#sfgrid)" />
          <ellipse cx="70" cy="120" rx="76" ry="46" fill="#1b2a1f" opacity="0.6" />
          <ellipse cx="300" cy="235" rx="80" ry="48" fill="#1b2a1f" opacity="0.4" />
          <path d="M-20 262 Q 90 246, 180 274 T 400 250" stroke="#28313f" strokeWidth="26" fill="none" opacity="0.6" />
          <path d="M-20 78 Q 180 96, 400 66" stroke="#2a2d35" strokeWidth="13" fill="none" />
          <path d="M-20 78 Q 180 96, 400 66" stroke="#3b4250" strokeWidth="1" fill="none" strokeDasharray="6 6" />
          <path d="M-20 176 L 400 190" stroke="#2a2d35" strokeWidth="10" fill="none" />
          <path d="M104 -20 Q 122 150, 88 320" stroke="#2a2d35" strokeWidth="11" fill="none" />
          <path d="M258 -20 Q 240 150, 276 320" stroke="#2a2d35" strokeWidth="10" fill="none" />
          <path d="M-20 128 L 400 138" stroke="#23262d" strokeWidth="3" fill="none" />
          <path d="M172 -20 L 188 320" stroke="#23262d" strokeWidth="3" fill="none" />
          {[[34, 96, 26, 20], [70, 104, 20, 16], [200, 52, 30, 24], [238, 44, 24, 18], [44, 200, 24, 20], [150, 224, 28, 22], [300, 130, 26, 20], [58, 268, 24, 18], [214, 272, 26, 20]].map(([x, y, w, h], i) => (<rect key={i} x={x} y={y} width={w} height={h} rx="2" fill="#1f222a" />))}
          <text x="52" y="70" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">홍익로</text>
          <text x="214" y="182" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">와우산로</text>
          <text x="118" y="252" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">잔다리로</text>
        </svg>
        <div style={{ position: 'absolute', left: '50%', top: '46%', transform: 'translate(-50%,-50%)' }}>
          <span style={{ position: 'absolute', left: '50%', top: '50%', width: 26, height: 26, borderRadius: 99, background: 'rgba(119,49,254,0.45)', animation: 'locPulse 2.4s ease-out infinite' }} />
          <span style={{ position: 'relative', display: 'block', width: 13, height: 13, borderRadius: 99, background: PURPLE[500], border: '2.5px solid #fff', boxShadow: '0 2px 8px rgba(0,0,0,.5)' }} />
        </div>
        {pins.map(p => {
          const sel = selected === p.id;
          const below = p.y < 24;
          return (
            <button key={p.id} onClick={() => onSelect(p.id)} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', left: `${p.x}%`, top: `${p.y}%`, transform: `translate(-50%,-100%) ${sel ? 'scale(1.06)' : 'scale(1)'}`, zIndex: sel ? 6 : 2, transition: 'transform .2s', animation: 'pinDrop .3s ease' }}>
              <div style={{ position: 'absolute', left: '50%', transform: 'translateX(-50%)', ...(below ? { top: '100%', marginTop: 3 } : { bottom: '100%', marginBottom: 4 }), padding: '3px 8px', borderRadius: 8, background: sel ? ACC_M : PIN_M, color: sel ? ON_ACC_M : '#fff', ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 700, boxShadow: sel ? '0 6px 18px rgba(181,255,96,0.42)' : '0 4px 12px rgba(98,42,207,0.42)', whiteSpace: 'nowrap' }}>{p.name}</div>
              <SFPinShape color={sel ? ACC_M : PIN_M} size={sel ? 32 : 28} />
            </button>
          );
        })}
      </div>
    </div>
  );
}

function SFMapControls({ setZoom, raised }) {
  const btn = { all: 'unset', cursor: 'pointer', width: 36, height: 36, display: 'flex', alignItems: 'center', justifyContent: 'center' };
  return (
    <div style={{ position: 'absolute', right: 12, bottom: raised ? 112 : 12, display: 'flex', flexDirection: 'column', gap: 8, zIndex: 8, transition: 'bottom .26s cubic-bezier(0.32,0.72,0,1)' }}>
      <div style={{ borderRadius: 14, overflow: 'hidden', display: 'flex', flexDirection: 'column', ...G.bar, border: `1px solid ${G.hair}` }}>
        <button onClick={() => setZoom(z => Math.min(1.6, +(z + 0.2).toFixed(1)))} style={btn}><SFI.Plus /></button>
        <span style={{ height: 1, background: G.hair }} />
        <button onClick={() => setZoom(z => Math.max(1, +(z - 0.2).toFixed(1)))} style={btn}><SFI.Minus /></button>
      </div>
      <button onClick={() => setZoom(1)} style={{ ...btn, borderRadius: '50%', ...G.tile }}><SFI.Target /></button>
    </div>
  );
}

function SFMapMini({ club, saved, onSave }) {
  return (
    <div style={{ position: 'absolute', left: 12, right: 12, bottom: 12, zIndex: 7, animation: 'riseIn .26s ease' }}>
      <GCard as="a" href="%5Bv1%5DCLUB-021.html" radius={18} style={{ border: '1px solid rgba(181,255,96,0.34)' }}>
        <div style={{ display: 'flex', gap: 11, alignItems: 'center', padding: 11 }}>
          <div style={{ width: 52, height: 52, flexShrink: 0, borderRadius: 12, background: club.bg, border: `1px solid ${G.hair}` }} />
          <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 5 }}>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, minWidth: 0 }}>
              <span style={{ ...TYPO.button1, fontSize: 16, fontWeight: 700, color: G.t1, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{club.name}</span>
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2, flexShrink: 0 }}><SFI.Star size={10} /><span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: G.t1 }}>{club.rating.toFixed(2)}</span></span>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
              <SFI.NoSmoke size={11} color={ACC_M} />
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: G.t3, fontWeight: 600 }}>{club.policy} · 걸어서 {club.walk}분</span>
            </div>
          </div>
          <GlassRound size={32} onClick={e => { e.preventDefault(); onSave(club.id); }}><SFI.Heart size={15} active={saved} /></GlassRound>
        </div>
      </GCard>
    </div>
  );
}

function SFMapSection({ areas, area, onArea, list, selected, onSelect, savedSet, onSave, title = '주변 금연 클럽 찾기' }) {
  const [zoom, setZoom] = useStateM(1);
  const club = list.find(c => c.id === selected);
  return (
    <div>
      <SFSectionHead
        title={title}
        sub={`내 위치 · ${area} 반경 2km · ${list.length}곳`}
        right={<a href="%5Bv1%5DPLACE-019.html" style={{ all: 'unset', cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 5, flexShrink: 0, height: 32, padding: '0 12px', borderRadius: 999, ...G.tile }}>
          <SFI.Expand size={13} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: G.t1, fontWeight: 700 }}>전체 지도</span>
        </a>}
      />
      <div style={{ marginBottom: 14 }}><SFChipRow items={areas} active={area} onChange={onArea} pin /></div>
      <div style={{ margin: '0 16px', position: 'relative', height: 300, borderRadius: 19, overflow: 'hidden', border: `1px solid ${G.hair}`, boxShadow: '0 14px 34px rgba(0,0,0,0.42)' }}>
        <SFMapCanvas pins={list} selected={selected} onSelect={onSelect} zoom={zoom} />
        <SFMapControls setZoom={setZoom} raised={!!club} />
        {club && <SFMapMini club={club} saved={savedSet.has(club.id)} onSave={onSave} />}
      </div>
      <div style={{ padding: '11px 16px 0', display: 'flex', alignItems: 'center', gap: 6 }}>
        <span style={{ width: 5, height: 5, borderRadius: 99, background: PURPLE[500], flexShrink: 0 }} />
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '15px', color: G.t4 }}>핀을 누르면 클럽 정보를 볼 수 있어요</span>
      </div>
    </div>
  );
}

Object.assign(window, { G, SF_AURORA, GCard, GlassRound, SFI, SFSectionHead, SFChipRow, SFMapSection });
