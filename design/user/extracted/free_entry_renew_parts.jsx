/* global React, TYPO, GRAY, LIME, PURPLE, window */
// ============ VYBE · 입장비 무료 (리뉴얼) — 디자인 시스템(리퀴드 글래스) 토큰 + 데이터 + 지도 ============
const { useState: feState } = React;

/* 리퀴드 글래스 토큰 — design_system.html */
const FG = {
  ink: '#0E0D12',
  hair: 'rgba(255,255,255,0.09)',
  t1: '#fff', t2: 'rgba(255,255,255,0.82)', t3: 'rgba(255,255,255,0.68)', t4: '#9F9FA1',
  card: { background: 'rgba(120,120,128,0.16)', border: '1px solid rgba(255,255,255,0.10)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)', boxShadow: '0 10px 30px rgba(0,0,0,0.36)' },
  quiet: { background: 'rgba(120,120,128,0.08)', border: '1px solid rgba(255,255,255,0.06)', backdropFilter: 'blur(14px) saturate(160%)', WebkitBackdropFilter: 'blur(14px) saturate(160%)' },
  tile: { background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.12)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)' },
  bar: { background: 'rgba(14,13,18,0.55)', backdropFilter: 'blur(20px) saturate(180%)', WebkitBackdropFilter: 'blur(20px) saturate(180%)' },
};

/* 액센트 — 무료입장 = 퍼플 베이스, 라임 포인트 */
const FE = {
  base: PURPLE[500], baseSoft: 'rgba(119,49,254,0.16)', baseLine: 'rgba(119,49,254,0.42)',
  point: LIME[500], onPoint: '#12210a', pointSoft: 'rgba(181,255,96,0.11)', pointLine: 'rgba(181,255,96,0.30)',
  map: '#12141a', road: '#2a2d35', block: '#1f222a', park: '#1b2a1f', water: '#141d2a',
};
/* VybeGenreBackdrop · 무료입장 = 퍼플 accent */
const FE_AURORA = 'radial-gradient(110% 80% at 0% 0%,rgba(119,49,254,0.34),transparent 72%),radial-gradient(110% 80% at 100% 2%,rgba(181,255,96,0.16),transparent 74%),radial-gradient(120% 90% at 88% 100%,rgba(119,49,254,0.24),transparent 76%),linear-gradient(180deg,#151027 0%,#111016 58%,#0E0D12 100%)';

/* 글래스 카드 — 상단 1px 하이라이트 + 좌상단 스페큘러 */
function FGCard({ children, style, radius = 19, quiet = false, as = 'div', href, onClick }) {
  const Tag = as;
  return (
    <Tag href={href} onClick={onClick} style={{ position: 'relative', overflow: 'hidden', borderRadius: radius, textDecoration: 'none', display: 'block', ...(quiet ? FG.quiet : FG.card), ...style }}>
      <span aria-hidden style={{ position: 'absolute', left: 0, right: 0, top: 0, height: 1, background: quiet ? 'rgba(255,255,255,0.08)' : 'rgba(255,255,255,0.18)', pointerEvents: 'none' }} />
      <span aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 80% at 12% 0%, rgba(255,255,255,0.10), transparent 58%)', pointerEvents: 'none' }} />
      <div style={{ position: 'relative' }}>{children}</div>
    </Tag>
  );
}

function FGRound({ children, onClick, href, size = 36 }) {
  const st = { all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: size, height: size, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0, ...FG.tile };
  return href ? <a href={href} style={st}>{children}</a> : <button onClick={onClick} style={st}>{children}</button>;
}

const FEI = {
  Back: ({ size = 20, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.3" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>),
  Search: ({ size = 18, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  Ticket: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M3 9.5V6.5a1 1 0 0 1 1-1h16a1 1 0 0 1 1 1v3a2.5 2.5 0 0 0 0 5v3a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-3a2.5 2.5 0 0 0 0-5z" /></svg>),
  Clock: ({ size = 12, color = 'rgba(255,255,255,0.6)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><polyline points="12 7 12 12 16 14" /></svg>),
  Star: ({ size = 12, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>),
  Pin: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" /></svg>),
  Walk: ({ size = 12, color = 'rgba(255,255,255,0.55)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="13" cy="4" r="2" /><path d="M13 7l-2 5 3 3 1 6M11 12L7 15l-1 6M14 10l4 2" /></svg>),
  Check: ({ size = 12, color = LIME[500], w = 3.2 }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>),
  Expand: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 3 21 3 21 9" /><polyline points="9 21 3 21 3 15" /><line x1="21" y1="3" x2="14" y2="10" /><line x1="3" y1="21" x2="10" y2="14" /></svg>),
  Heart: ({ size = 16, active = false }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  HomeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" /></svg>),
  AroundTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" /></svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  SavedTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  MeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" /></svg>),
};

/* 섹션 헤드 · 메타 · 영업상태 — 좌우 여백 16px 고정 */
const FE_PAD = 24; // pagePaddingH · 24.w

function FeHead({ title, sub, right }) {
  return (
    <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', gap: 12, padding: `0 ${FE_PAD}px`, marginBottom: 14 }}>
      <div>
        <h2 style={{ ...TYPO.h4, fontSize: 20, lineHeight: '23px', fontWeight: 700, color: FG.t1, margin: 0 }}>{title}</h2>
        {sub && <span style={{ ...TYPO.caption, color: FG.t4, lineHeight: '16px', display: 'block', marginTop: 6 }}>{sub}</span>}
      </div>
      {right}
    </div>
  );
}

function FeMeta({ items, size = 11.5, color = FG.t3 }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 5, minWidth: 0, ...TYPO.caption, fontSize: size, lineHeight: '14px', color, fontWeight: 600 }}>
      {items.filter(Boolean).map((t, i) => (
        <React.Fragment key={i}>
          {i > 0 && <span style={{ width: 2.5, height: 2.5, borderRadius: 99, background: 'rgba(255,255,255,0.3)', flexShrink: 0 }} />}
          <span style={{ whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{t}</span>
        </React.Fragment>
      ))}
    </div>
  );
}

function FeOpen({ open }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, flexShrink: 0, padding: '3px 7px', borderRadius: 99, ...FG.bar, border: `1px solid ${open ? FE.pointLine : 'rgba(255,255,255,0.14)'}` }}>
      <span style={{ width: 5, height: 5, borderRadius: 99, background: open ? FE.point : 'rgba(255,255,255,0.5)' }} />
      <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: open ? FE.point : FG.t3 }}>{open ? '영업 중' : '종료'}</span>
    </span>
  );
}

function FeFreeBadge({ label = '지금 무료', strong = true }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, height: 24, padding: '0 9px', borderRadius: 99, background: strong ? PURPLE[500] : 'rgba(119,49,254,0.55)', border: `1px solid ${strong ? 'rgba(200,168,255,0.5)' : 'rgba(200,168,255,0.4)'}`, boxShadow: strong ? '0 6px 16px rgba(119,49,254,0.42)' : 'none' }}>
      <FEI.Ticket size={12} />
      <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '11px', fontWeight: 700, color: '#fff' }}>{label}</span>
    </span>
  );
}

// ---------- 데이터 ----------
const FE_NOW = '22:13';            // 기준 시각
const FE_LOC = '홍대입구역';        // 내 위치
const feMin = (t) => { const [h, m] = t.split(':').map(Number); return h * 60 + m + (h < 6 ? 1440 : 0); };
const FE_NOW_MIN = feMin(FE_NOW);

const FE_TIMED = [
  { id: 1, name: '어썸레드', area: '홍대', genre: '힙합', dist: 0.4, rating: 4.58, open: true, start: '21:00', end: '23:00', bg: 'linear-gradient(140deg,#7731FE 0%,#c04bd0 55%,#ff5c8a 100%)' },
  { id: 2, name: 'OCTAGON', area: '강남', genre: 'EDM', dist: 5.2, rating: 4.82, open: true, start: '21:00', end: '23:30', bg: 'linear-gradient(140deg,#2B6BFF,#7731FE 70%,#b5ff60 170%)' },
  { id: 3, name: '케이크샵', area: '이태원', genre: '테크노', dist: 6.3, rating: 4.40, open: true, start: '22:00', end: '24:00', bg: 'linear-gradient(140deg,#0f2b2a,#1b9aaa 60%,#06ffa5 130%)' },
];

const FE_NEAR = [
  { id: 11, name: '어썸레드', area: '홍대', genre: '힙합', dist: 0.4, walk: 6, rating: 4.58, open: true, tag: '전원 무료', x: 46, y: 40, bg: 'linear-gradient(140deg,#7731FE,#ff5c8a)' },
  { id: 12, name: '인클', area: '홍대', genre: '힙합', dist: 0.5, walk: 7, rating: 4.44, open: true, tag: '오픈~새벽 2시 무료', x: 63, y: 36, bg: 'linear-gradient(140deg,#fb5607,#ffbe0b)' },
  { id: 13, name: '버뮤다', area: '합정', genre: '힙합', dist: 0.7, walk: 10, rating: 4.49, open: true, tag: '전원 무료', x: 27, y: 58, bg: 'linear-gradient(140deg,#06ffa5,#3a86ff)' },
  { id: 14, name: '벨로주', area: '홍대', genre: '재즈', dist: 0.9, walk: 12, rating: 4.36, open: true, tag: '상시 무료', x: 72, y: 62, bg: 'linear-gradient(140deg,#6d4c91,#2a2d34)' },
  { id: 15, name: '하이브', area: '신촌', genre: '힙합', dist: 1.2, walk: 16, rating: 4.31, open: false, tag: '새벽 1시까지 무료', x: 84, y: 44, bg: 'linear-gradient(140deg,#ffbe0b,#fb5607)' },
];

const FE_COND = [
  { id: 21, name: '소다', area: '강남', genre: '하우스', dist: 5.4, rating: 4.55, open: true, bg: 'linear-gradient(140deg,#3a0ca3,#4361ee)',
    conds: ['여성 전원 무료입장', '남성 4인 이상 동반 시 전원 무료'] },
  { id: 22, name: '메이드', area: '이태원', genre: 'EDM', dist: 6.1, rating: 4.74, open: true, bg: 'linear-gradient(140deg,#ff006e,#8338ec)',
    conds: ['게스트리스트 등록 후 자정 이전 입장', '20인 이상 단체 예약 시 전원 무료'] },
  { id: 23, name: '글로우', area: '압구정', genre: 'EDM', dist: 4.2, rating: 4.61, open: true, bg: 'linear-gradient(140deg,#f72585,#b5179e)',
    conds: ['앱에서 사전 예약한 경우', '평일 23시 이전 입장 시'] },
  { id: 24, name: '하이브', area: '건대', genre: '힙합', dist: 3.1, rating: 4.31, open: false, bg: 'linear-gradient(140deg,#ffbe0b,#fb5607)',
    conds: ['대학생 학생증 지참 시', '수요일·목요일 전원 무료'] },
  { id: 25, name: '케이크샵', area: '이태원', genre: '테크노', dist: 6.3, rating: 4.40, open: true, bg: 'linear-gradient(140deg,#0f2b2a,#1b9aaa)',
    conds: ['생일 당일 본인 무료 (신분증 확인)', 'SNS 스토리 인증 시'] },
];

// ============ 지도 ============
function FEMapCanvas() {
  return (
    <svg width="100%" height="100%" viewBox="0 0 361 260" preserveAspectRatio="xMidYMid slice" style={{ position: 'absolute', inset: 0, display: 'block' }}>
      <defs>
        <linearGradient id="femg" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stopColor="#1b1e26" /><stop offset="100%" stopColor="#101218" /></linearGradient>
        <pattern id="fegrid" width="36" height="36" patternUnits="userSpaceOnUse"><path d="M 36 0 L 0 0 0 36" fill="none" stroke="#22252e" strokeWidth="0.5" /></pattern>
      </defs>
      <rect width="361" height="260" fill="url(#femg)" />
      <rect width="361" height="260" fill="url(#fegrid)" />
      <ellipse cx="66" cy="44" rx="74" ry="40" fill={FE.park} opacity="0.55" />
      <path d="M-20 224 Q 90 210, 180 236 T 400 212" stroke="#28313f" strokeWidth="24" fill="none" opacity="0.6" />
      <path d="M-20 70 Q 180 88, 400 58" stroke={FE.road} strokeWidth="13" fill="none" />
      <path d="M-20 70 Q 180 88, 400 58" stroke="#3b4250" strokeWidth="1" fill="none" strokeDasharray="6 6" />
      <path d="M-20 152 L 400 166" stroke={FE.road} strokeWidth="10" fill="none" />
      <path d="M104 -20 Q 122 130, 88 280" stroke={FE.road} strokeWidth="11" fill="none" />
      <path d="M258 -20 Q 240 130, 276 280" stroke={FE.road} strokeWidth="10" fill="none" />
      <path d="M-20 112 L 400 122" stroke="#23262d" strokeWidth="3" fill="none" />
      <path d="M172 -20 L 188 280" stroke="#23262d" strokeWidth="3" fill="none" />
      {[[34, 84, 26, 20], [70, 92, 20, 16], [200, 44, 30, 24], [238, 36, 24, 18], [44, 178, 24, 20], [150, 198, 28, 22], [300, 116, 26, 20], [58, 236, 24, 18], [214, 238, 26, 20]].map(([x, y, w, h], i) => <rect key={i} x={x} y={y} width={w} height={h} rx="2" fill={FE.block} />)}
      <text x="52" y="60" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">홍익로</text>
      <text x="214" y="158" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">와우산로</text>
      <text x="118" y="222" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">잔다리로</text>
    </svg>
  );
}

function FEPin({ selected, size = 28 }) {
  return (
    <svg width={size} height={size * (27 / 24)} viewBox="0 0 24 27" fill="none" style={{ display: 'block', filter: selected ? 'drop-shadow(0 6px 14px rgba(181,255,96,0.42))' : 'drop-shadow(0 4px 9px rgba(0,0,0,0.5))' }}>
      <path d="M12 0C16.4183 0 20 3.58172 20 8C19.9999 10.5544 18.8005 12.8264 16.9365 14.291L13.3867 17.7031C12.6127 18.4469 11.3894 18.4468 10.6152 17.7031L7.06738 14.2959C5.20068 12.8314 4.00008 10.5566 4 8C4 3.58172 7.58172 0 12 0Z" fill={selected ? FE.point : PURPLE[700]} />
      <circle cx="12" cy="8" r="3" fill={selected ? FE.onPoint : '#fff'} />
    </svg>
  );
}

function FEMap({ list, sel, onSel }) {
  return (
    <div style={{ position: 'relative', height: 260, borderRadius: 19, overflow: 'hidden', border: `1px solid ${FG.hair}`, background: FE.map, flexShrink: 0, boxShadow: '0 14px 34px rgba(0,0,0,0.42)' }}>
      <FEMapCanvas />
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(92% 72% at 50% 44%, transparent 42%, rgba(10,9,14,0.58) 100%)', pointerEvents: 'none' }} />

      {/* 내 위치 */}
      <div style={{ position: 'absolute', left: '50%', top: '50%', transform: 'translate(-50%,-50%)', display: 'grid', placeItems: 'center' }}>
        <span style={{ position: 'absolute', width: 44, height: 44, borderRadius: 99, background: 'rgba(119,49,254,0.22)', border: '1px solid rgba(119,49,254,0.38)' }} />
        <span style={{ width: 13, height: 13, borderRadius: 99, background: PURPLE[500], border: '2.5px solid #fff', boxShadow: '0 2px 8px rgba(0,0,0,0.6)' }} />
      </div>

      {list.map(c => {
        const on = c.id === sel;
        return (
          <button key={c.id} onClick={() => onSel(c.id)} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', left: `${c.x}%`, top: `${c.y}%`, transform: `translate(-50%,-100%) scale(${on ? 1.06 : 1})`, transformOrigin: 'bottom center', transition: 'transform .18s ease', zIndex: on ? 8 : 4, display: 'block' }}>
            {on && <span style={{ position: 'absolute', left: '50%', bottom: '100%', marginBottom: 4, transform: 'translateX(-50%)', ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 700, color: FE.onPoint, padding: '3px 8px', borderRadius: 8, background: FE.point, boxShadow: '0 6px 18px rgba(181,255,96,0.38)', whiteSpace: 'nowrap' }}>{c.name}</span>}
            <FEPin selected={on} size={on ? 32 : 28} />
          </button>
        );
      })}

      {/* 위치 칩 */}
      <div style={{ position: 'absolute', left: 12, top: 12, display: 'inline-flex', alignItems: 'center', gap: 6, height: 30, padding: '0 11px', borderRadius: 99, ...FG.bar, border: `1px solid ${FG.hair}` }}>
        <span style={{ width: 6, height: 6, borderRadius: 99, background: FE.point }} />
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 700, color: FG.t1 }}>{FE_LOC} 기준</span>
      </div>
    </div>
  );
}

Object.assign(window, { FG, FE, FE_AURORA, FE_PAD, FGCard, FGRound, FEI, FeHead, FeMeta, FeOpen, FeFreeBadge, FE_NOW, FE_NOW_MIN, FE_LOC, feMin, FE_TIMED, FE_NEAR, FE_COND, FEMap, FEPin, feState });
