/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, PURPLE, LIME */
const { useState } = React;

const BG = '#101013';
const ACC = LIME[500];                 // K-POP 액센트 — 선택 / 강조
const ON_ACC = '#12210a';
const PIN = PURPLE[700];               // 기본 핀 (브랜드)
const ACC_SOFT = 'rgba(181,255,96,0.14)';
const ACC_LINE = 'rgba(181,255,96,0.45)';

// ============ ICONS ============
const I = {
  Back: ({ size = 24, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>),
  Search: ({ size = 21, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  Note: ({ size = 15, color = ACC }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="7" cy="18" r="3" /><circle cx="18" cy="15.5" r="3" /><path d="M10 18V6l11-2.5V15.5" /></svg>),
  Star: ({ size = 13, color = ACC }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>),
  Pin: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" /></svg>),
  Target: ({ size = 18, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="7.5" /><circle cx="12" cy="12" r="2.4" fill={color} stroke="none" /><line x1="12" y1="1.5" x2="12" y2="4" /><line x1="12" y1="20" x2="12" y2="22.5" /><line x1="1.5" y1="12" x2="4" y2="12" /><line x1="20" y1="12" x2="22.5" y2="12" /></svg>),
  Plus: ({ size = 16, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.4" strokeLinecap="round"><line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" /></svg>),
  Minus: ({ size = 16, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.4" strokeLinecap="round"><line x1="5" y1="12" x2="19" y2="12" /></svg>),
  Expand: ({ size = 15, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 3 21 3 21 9" /><polyline points="9 21 3 21 3 15" /><line x1="21" y1="3" x2="14" y2="10" /><line x1="3" y1="21" x2="10" y2="14" /></svg>),
  Walk: ({ size = 12, color = GRAY[400] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="13" cy="4" r="2" /><path d="M13 7l-2 5 3 3 1 6M11 12L7 15l-1 6M14 10l4 2" /></svg>),
  ChevRight: ({ size = 16, color = GRAY[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6" /></svg>),
  Heart: ({ size = 19, active = false }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  HomeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" /></svg>),
  AroundTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" /></svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  SavedTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  MeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" /></svg>),
};

// ============ DATA ============
const AREAS = ['홍대', '강남', '이태원', '건대', '신촌'];
const TAGS = ['전체', '최신 K-POP', '4세대 아이돌', '걸그룹', '2000년대 가요', '보이그룹'];
const FILTERS = [
  { key: 'pick', label: 'vybe 추천 클럽', test: c => c.pick },
  { key: 'free', label: '입장비 무료', test: c => c.free },
  { key: 'drink', label: '서비스 음료', test: c => c.drink },
  { key: 'saved', label: '찜', test: (c, saved) => saved.has(c.id) },
  { key: 'smokeFree', label: '금연', test: c => c.smokeFree },
];

const CLUBS = [
  { id: 1, free: true, drink: true, smokeFree: true, name: '샤이니', area: '홍대', dist: 0.3, walk: 4, rating: 4.62, tags: ['최신 K-POP', '걸그룹'], now: 'aespa · Whiplash', open: true, pick: true, x: 46, y: 34, bg: 'linear-gradient(150deg, #2b1655, #7731FE 58%, #B5FF60)' },
  { id: 2, free: false, drink: true, smokeFree: false, name: '루프', area: '홍대', dist: 0.5, walk: 7, rating: 4.51, tags: ['4세대 아이돌'], now: 'ITZY · GOLD', open: true, pick: true, x: 62, y: 27, bg: 'linear-gradient(150deg, #1c2a10, #739F41 55%, #B5FF60)' },
  { id: 3, free: true, drink: false, smokeFree: true, name: '엔코어', area: '홍대', dist: 0.6, walk: 8, rating: 4.48, tags: ['보이그룹', '최신 K-POP'], now: 'CORTIS · GO!', open: true, pick: false, x: 30, y: 50, bg: 'linear-gradient(150deg, #241452, #6329d6 60%, #a179ff)' },
  { id: 4, free: false, drink: true, smokeFree: true, name: '멜로디', area: '홍대', dist: 0.8, walk: 11, rating: 4.44, tags: ['2000년대 가요'], now: '소녀시대 · Gee', open: true, pick: true, x: 72, y: 58, bg: 'linear-gradient(150deg, #3a2f0a, #94CF51 62%, #ffbe0b)' },
  { id: 5, free: true, drink: true, smokeFree: false, name: '아이돌룸', area: '신촌', dist: 1.4, walk: 19, rating: 4.39, tags: ['4세대 아이돌', '걸그룹'], now: 'NMIXX · DASH', open: true, pick: false, x: 18, y: 28, bg: 'linear-gradient(150deg, #1a0a26, #4b2093 55%, #B5FF60)' },
  { id: 6, free: false, drink: false, smokeFree: true, name: '팬덤', area: '신촌', dist: 1.7, walk: 23, rating: 4.35, tags: ['보이그룹'], now: 'TXT · Deja Vu', open: true, pick: false, x: 55, y: 70, bg: 'linear-gradient(150deg, #101019, #2a1b52 50%, #b694ff)' },
  { id: 7, free: true, drink: true, smokeFree: true, name: '리믹스', area: '강남', dist: 5.1, walk: 62, rating: 4.55, tags: ['최신 K-POP'], now: 'LE SSERAFIM · HOT', open: true, pick: true, x: 84, y: 40, bg: 'linear-gradient(150deg, #17102e, #40208c 55%, #8b4dff)' },
  { id: 8, free: false, drink: false, smokeFree: false, name: '커버', area: '강남', dist: 5.4, walk: 66, rating: 4.41, tags: ['걸그룹', '2000년대 가요'], now: '원더걸스 · Nobody', open: false, pick: false, x: 38, y: 72, bg: 'linear-gradient(150deg, #2a2410, #b5860b 60%, #ffbe0b)' },
  { id: 9, free: true, drink: false, smokeFree: false, name: '스테이지', area: '이태원', dist: 6.2, walk: 74, rating: 4.32, tags: ['보이그룹', '4세대 아이돌'], now: 'ENHYPEN · Bite Me', open: false, pick: false, x: 68, y: 30, bg: 'linear-gradient(150deg, #14102b, #35187a 55%, #8a55ff)' },
  { id: 10, free: false, drink: true, smokeFree: true, name: '앙콜', area: '건대', dist: 3.3, walk: 41, rating: 4.28, tags: ['2000년대 가요'], now: '빅뱅 · 뱅뱅뱅', open: false, pick: false, x: 24, y: 66, bg: 'linear-gradient(150deg, #1b3a3a, #2a9d8f 60%, #B5FF60)' },
];

// ============ HEADER ============
function Header({ solid }) {
  return (
    <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 40, height: 52, padding: '0 8px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', background: solid ? 'rgba(16,16,19,0.92)' : 'transparent', backdropFilter: solid ? 'blur(16px)' : 'none', WebkitBackdropFilter: solid ? 'blur(16px)' : 'none', borderBottom: `1px solid ${solid ? GRAY[900] : 'transparent'}`, transition: 'background .22s, border-color .22s' }}>
      <a href="%5Bv1%5DHOME-005.html" style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><I.Back /></a>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: '#fff', display: 'flex', alignItems: 'center', gap: 6, opacity: solid ? 1 : 0, transition: 'opacity .22s' }}><I.Note size={15} /> K-POP</span>
      <button style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><I.Search /></button>
    </div>
  );
}

// ============ HERO — K-POP 배너 10안(듀오톤 라임형) ============
function Hero() {
  return (
    <div style={{ position: 'relative', background: BG }}>
      <div style={{ position: 'relative', height: 478, overflow: 'hidden' }}>
        <img src="assets/kpop-hero.png" alt="오늘 밤 K-POP만 — 내가 아는 노래만 나오는 클럽을 모았어요" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', objectFit: 'cover', display: 'block' }} />
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '17px 20px', background: ACC }}>
        <img src="assets/vybe-logo.png" alt="vybe" style={{ height: 15, width: 42, objectFit: 'contain', display: 'block', flexShrink: 0, filter: 'brightness(0)' }} />
        <p style={{ margin: 0, fontSize: 12, lineHeight: '19px', letterSpacing: '-0.025em', color: 'rgba(12,20,4,.78)' }}>내가 아는 노래만 나오는<br /><b style={{ color: '#0d1505', fontWeight: 700 }}>K-POP 클럽만 모아놨어요</b></p>
      </div>
    </div>
  );
}

// ============ SECTION HEAD ============
function SectionHead({ title, sub, right }) {
  return (
    <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', gap: 12, padding: '0 16px', marginBottom: 14 }}>
      <div>
        <h2 style={{ ...TYPO.h4, fontSize: 20, lineHeight: '23px', fontWeight: 700, color: '#fff', margin: 0 }}>{title}</h2>
        {sub && <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '16px', display: 'block', marginTop: 6 }}>{sub}</span>}
      </div>
      {right}
    </div>
  );
}

function FilterChips({ picked, onToggle, savedSet }) {
  return (
    <div style={{ display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none', padding: '0 16px 2px' }}>
      {FILTERS.map(f => {
        const sel = picked.includes(f.key);
        const n = CLUBS.filter(c => f.test(c, savedSet)).length;
        return (
          <button key={f.key} onClick={() => onToggle(f.key)} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, height: 34, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 15px', borderRadius: 999, background: sel ? ACC : GRAY[900], border: sel ? 'none' : `1px solid ${GRAY[800]}`, ...TYPO.button2, fontWeight: sel ? 700 : 500, color: sel ? ON_ACC : GRAY[300], boxShadow: sel ? '0 4px 14px rgba(181,255,96,0.22)' : 'none', transition: 'all .18s' }}>
            {f.label}
            <span style={{ ...TYPO.caption, fontWeight: 600, color: sel ? 'rgba(14,13,18,0.55)' : GRAY[500], fontVariantNumeric: 'tabular-nums' }}>{n}</span>
          </button>
        );
      })}
    </div>
  );
}

function ChipRow({ items, active, onChange, pin = false }) {
  return (
    <div style={{ display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none', padding: '0 16px 2px' }}>
      {items.map(g => {
        const sel = g === active;
        return (
          <button key={g} onClick={() => onChange(g)} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, height: 34, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 15px', borderRadius: 999, background: sel ? ACC : GRAY[900], border: sel ? 'none' : `1px solid ${GRAY[800]}`, ...TYPO.button2, fontWeight: sel ? 700 : 500, color: sel ? ON_ACC : GRAY[300], boxShadow: sel ? '0 4px 14px rgba(181,255,96,0.22)' : 'none', transition: 'all .18s' }}>
            {pin && <I.Pin size={12} color={sel ? ON_ACC : GRAY[400]} />}
            {g}
          </button>
        );
      })}
    </div>
  );
}

// ============ MAP ============
function MapPinShape({ color, size = 30 }) {
  return (
    <svg width={size} height={size * (27 / 24)} viewBox="0 0 24 27" fill="none" style={{ display: 'block', filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.5))' }}>
      <path d="M12 0C16.4183 0 20 3.58172 20 8C19.9999 10.5544 18.8005 12.8264 16.9365 14.291L13.3867 17.7031C12.6127 18.4469 11.3894 18.4468 10.6152 17.7031L7.06738 14.2959C5.20068 12.8314 4.00008 10.5566 4 8C4 3.58172 7.58172 0 12 0Z" fill={color} />
      <circle cx="12" cy="8" r="3" fill="#fff" />
    </svg>
  );
}

function MapCanvas({ pins, selected, onSelect, zoom }) {
  return (
    <div style={{ position: 'absolute', inset: 0, background: '#15171c', overflow: 'hidden' }}>
      <div style={{ position: 'absolute', inset: 0, transform: `scale(${zoom})`, transformOrigin: 'center 50%', transition: 'transform .4s cubic-bezier(0.32,0.72,0,1)' }}>
        <svg width="100%" height="100%" viewBox="0 0 361 300" preserveAspectRatio="xMidYMid slice" style={{ position: 'absolute', inset: 0 }}>
          <defs>
            <linearGradient id="kmg" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stopColor="#1d2027" /><stop offset="100%" stopColor="#13151a" /></linearGradient>
            <pattern id="kgrid" width="36" height="36" patternUnits="userSpaceOnUse"><path d="M 36 0 L 0 0 0 36" fill="none" stroke="#242730" strokeWidth="0.5" /></pattern>
          </defs>
          <rect width="361" height="300" fill="url(#kmg)" />
          <rect width="361" height="300" fill="url(#kgrid)" />
          <ellipse cx="70" cy="120" rx="76" ry="46" fill="#1b2a1f" opacity="0.65" />
          <ellipse cx="300" cy="235" rx="80" ry="48" fill="#1b2a1f" opacity="0.45" />
          <path d="M-20 262 Q 90 246, 180 274 T 400 250" stroke="#2a3848" strokeWidth="26" fill="none" opacity="0.6" />
          <path d="M-20 78 Q 180 96, 400 66" stroke="#2c3038" strokeWidth="13" fill="none" />
          <path d="M-20 78 Q 180 96, 400 66" stroke="#3b4250" strokeWidth="1" fill="none" strokeDasharray="6 6" />
          <path d="M-20 176 L 400 190" stroke="#2c3038" strokeWidth="10" fill="none" />
          <path d="M104 -20 Q 122 150, 88 320" stroke="#2c3038" strokeWidth="11" fill="none" />
          <path d="M258 -20 Q 240 150, 276 320" stroke="#2c3038" strokeWidth="10" fill="none" />
          <path d="M-20 128 L 400 138" stroke="#262a32" strokeWidth="3" fill="none" />
          <path d="M172 -20 L 188 320" stroke="#262a32" strokeWidth="3" fill="none" />
          <path d="M322 -20 L 338 320" stroke="#262a32" strokeWidth="3" fill="none" />
          {[[34, 96, 26, 20], [70, 104, 20, 16], [200, 52, 30, 24], [238, 44, 24, 18], [44, 200, 24, 20], [150, 224, 28, 22], [300, 130, 26, 20], [58, 268, 24, 18], [214, 272, 26, 20]].map(([x, y, w, h], i) => (<rect key={i} x={x} y={y} width={w} height={h} rx="2" fill="#22252c" />))}
          <text x="52" y="70" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">홍익로</text>
          <text x="214" y="182" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">와우산로</text>
          <text x="118" y="252" fill="#3d4250" fontSize="8.5" fontFamily="Pretendard">잔다리로</text>
        </svg>

        {/* 내 위치 */}
        <div style={{ position: 'absolute', left: '50%', top: '46%', transform: 'translate(-50%,-50%)' }}>
          <span style={{ position: 'absolute', left: '50%', top: '50%', width: 26, height: 26, borderRadius: 99, background: 'rgba(119,49,254,0.45)', animation: 'locPulse 2.4s ease-out infinite' }} />
          <span style={{ position: 'relative', display: 'block', width: 13, height: 13, borderRadius: 99, background: PURPLE[500], border: '2.5px solid #fff', boxShadow: '0 2px 8px rgba(0,0,0,.5)' }} />
        </div>

        {pins.map(p => {
          const sel = selected === p.id;
          const below = p.y < 24;   // 위쪽 경계에 가까우면 라벨을 핀 아래로
          return (
            <button key={p.id} onClick={() => onSelect(p.id)} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', left: `${p.x}%`, top: `${p.y}%`, transform: `translate(-50%,-100%) ${sel ? 'scale(1.06)' : 'scale(1)'}`, zIndex: sel ? 6 : 2, transition: 'transform .2s', animation: 'pinDrop .3s ease' }}>
              <div style={{ position: 'absolute', left: '50%', transform: 'translateX(-50%)', ...(below ? { top: '100%', marginTop: 3 } : { bottom: '100%', marginBottom: 4 }), padding: '3px 8px', borderRadius: 8, background: sel ? ACC : PIN, color: sel ? ON_ACC : '#fff', ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 700, boxShadow: sel ? '0 6px 18px rgba(181,255,96,0.42)' : '0 4px 12px rgba(98,42,207,0.42)', whiteSpace: 'nowrap' }}>{p.name}</div>
              <MapPinShape color={sel ? ACC : PIN} size={sel ? 32 : 28} />
            </button>
          );
        })}
      </div>
    </div>
  );
}

function MapControls({ zoom, setZoom, raised }) {
  const btn = { all: 'unset', cursor: 'pointer', width: 34, height: 34, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'rgba(16,16,19,0.82)', backdropFilter: 'blur(10px)' };
  return (
    <div style={{ position: 'absolute', right: 12, bottom: raised ? 104 : 12, display: 'flex', flexDirection: 'column', gap: 8, zIndex: 8, transition: 'bottom .26s cubic-bezier(0.32,0.72,0,1)' }}>
      <div style={{ borderRadius: 10, overflow: 'hidden', border: `1px solid ${GRAY[800]}`, display: 'flex', flexDirection: 'column' }}>
        <button onClick={() => setZoom(z => Math.min(1.6, +(z + 0.2).toFixed(1)))} style={btn}><I.Plus /></button>
        <span style={{ height: 1, background: GRAY[800] }} />
        <button onClick={() => setZoom(z => Math.max(1, +(z - 0.2).toFixed(1)))} style={btn}><I.Minus /></button>
      </div>
      <button onClick={() => setZoom(1)} style={{ ...btn, borderRadius: 10, border: `1px solid ${GRAY[800]}` }}><I.Target /></button>
    </div>
  );
}

// 지도 위 선택 클럽 미니 카드
function MapMini({ club, saved, onSave }) {
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{ display: 'flex', gap: 11, alignItems: 'center', textDecoration: 'none', position: 'absolute', left: 12, right: 12, bottom: 12, zIndex: 7, padding: 10, borderRadius: 14, background: 'rgba(16,16,19,0.92)', backdropFilter: 'blur(14px)', WebkitBackdropFilter: 'blur(14px)', border: `1px solid ${ACC_LINE}`, boxShadow: '0 10px 30px rgba(0,0,0,.5)', animation: 'riseIn .26s ease' }}>
      <div style={{ width: 52, height: 52, flexShrink: 0, borderRadius: 10, background: club.bg, border: `1px solid ${GRAY[800]}` }} />
      <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 5 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, minWidth: 0 }}>
          <span style={{ ...TYPO.button1, fontSize: 16, fontWeight: 700, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{club.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2, flexShrink: 0 }}><I.Star size={10} /><span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: '#fff' }}>{club.rating.toFixed(2)}</span></span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
          <I.Walk size={11} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: GRAY[400], fontWeight: 600 }}>걸어서 {club.walk}분 · {club.dist.toFixed(1)}km</span>
        </div>
      </div>
      <button onClick={e => { e.preventDefault(); onSave(club.id); }} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, width: 32, height: 32, borderRadius: 99, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'rgba(255,255,255,0.07)' }}><I.Heart size={15} active={saved} /></button>
    </a>
  );
}

function MapSection({ area, onArea, list, selected, onSelect, savedSet, onSave }) {
  const [zoom, setZoom] = useState(1);
  const club = list.find(c => c.id === selected);
  return (
    <div>
      <SectionHead
        title="주변 K-POP 클럽 찾기"
        sub={`내 위치 · ${area} 반경 2km · ${list.length}곳`}
        right={<a href="%5Bv1%5DPLACE-019.html" style={{ all: 'unset', cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 5, flexShrink: 0, height: 30, padding: '0 11px', borderRadius: 99, background: GRAY[900], border: `1px solid ${GRAY[800]}` }}>
          <I.Expand size={13} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: '#fff', fontWeight: 700 }}>전체 지도</span>
        </a>}
      />
      <div style={{ marginBottom: 14 }}><ChipRow items={AREAS} active={area} onChange={onArea} pin /></div>
      <div style={{ margin: '0 16px', position: 'relative', height: 300, borderRadius: 16, overflow: 'hidden', border: `1px solid ${GRAY[800]}` }}>
        <MapCanvas pins={list} selected={selected} onSelect={onSelect} zoom={zoom} />
        <MapControls zoom={zoom} setZoom={setZoom} raised={!!club} />
        {club && <MapMini club={club} saved={savedSet.has(club.id)} onSave={onSave} />}
      </div>
      <div style={{ padding: '11px 16px 0', display: 'flex', alignItems: 'center', gap: 6 }}>
        <span style={{ width: 5, height: 5, borderRadius: 99, background: PURPLE[500], flexShrink: 0 }} />
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '15px', color: GRAY[500] }}>핀을 누르면 클럽 정보를 볼 수 있어요</span>
      </div>
    </div>
  );
}

// ============ POSTER CARD (힙합 페이지와 동일 구조) ============
function ClubTile({ club, saved, onSave }) {
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{ display: 'block', textDecoration: 'none', position: 'relative', aspectRatio: '3 / 4', borderRadius: 16, overflow: 'hidden', background: club.bg, border: `1px solid ${GRAY[800]}` }}>
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 70% at 70% 12%, rgba(255,255,255,0.2), transparent 55%)' }} />
      <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(10,9,11,0.95) 16%, rgba(10,9,11,0.2) 56%, transparent 80%)' }} />

      <div style={{ position: 'absolute', top: 11, left: 11, display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 8px', borderRadius: 99, background: 'rgba(0,0,0,0.42)', backdropFilter: 'blur(6px)', border: `1px solid ${club.open ? ACC_LINE : GRAY[700]}` }}>
        <span style={{ width: 5, height: 5, borderRadius: 99, background: club.open ? ACC : GRAY[500] }} />
        <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: club.open ? ACC : GRAY[400] }}>{club.open ? '영업 중' : '종료'}</span>
      </div>

      <button onClick={e => { e.preventDefault(); onSave(club.id); }} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', top: 8, right: 8, width: 30, height: 30, borderRadius: 99, background: 'rgba(0,0,0,0.42)', backdropFilter: 'blur(6px)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <I.Heart size={15} active={saved} />
      </button>

      <div style={{ position: 'absolute', left: 12, right: 12, bottom: 12 }}>
        {club.pick && (
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, marginBottom: 8, padding: '3px 8px 3px 7px', borderRadius: 7, background: PURPLE[500], border: `1px solid ${PURPLE[500]}` }}>
            <img src="assets/vybe-logo.png" alt="vybe" style={{ height: 8, width: 22, objectFit: 'contain', display: 'block', filter: 'brightness(0) invert(1)' }} />
            <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: '#fff' }}>추천 클럽</span>
          </span>
        )}

        <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginBottom: 5 }}>
          <span style={{ ...TYPO.h4, fontSize: 18, lineHeight: '20px', fontWeight: 700, color: '#fff' }}>{club.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2 }}>
            <I.Star size={11} /><span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: '#fff' }}>{club.rating.toFixed(2)}</span>
          </span>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <I.Walk size={11} color={GRAY[400]} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: GRAY[400], fontWeight: 600 }}>{club.area} · 걸어서 {club.walk}분</span>
        </div>

        <div style={{ display: 'flex', gap: 5, marginTop: 8, flexWrap: 'wrap' }}>
          {club.tags.map(t => (
            <span key={t} style={{ ...TYPO.caption, fontSize: 10, lineHeight: '13px', fontWeight: 600, color: GRAY[300], padding: '1px 7px', borderRadius: 6, background: 'rgba(255,255,255,0.09)' }}>#{t}</span>
          ))}
        </div>
      </div>
    </a>
  );
}

function ClubGrid({ savedSet, onSave, onSelect }) {
  const [picked, setPicked] = useState([]);
  const toggle = k => setPicked(p => p.includes(k) ? p.filter(x => x !== k) : [...p, k]);
  const active = FILTERS.filter(f => picked.includes(f.key));
  const list = CLUBS.filter(c => active.every(f => f.test(c, savedSet))).slice().sort((a, b) => a.dist - b.dist);
  return (
    <div>
      <SectionHead title="가까운 순으로 보기" sub={`${list.length}곳 · 내 위치에서 가까운 순`} />
      <div style={{ marginBottom: 16 }}><FilterChips picked={picked} onToggle={toggle} savedSet={savedSet} /></div>
      {list.length === 0 ? (
        <div style={{ padding: '34px 24px', textAlign: 'center', ...TYPO.body4, color: GRAY[500] }}>조건에 맞는 클럽이 아직 없어요</div>
      ) : (
        <div key={picked.join()} style={{ padding: '0 16px', display: 'grid', gridTemplateColumns: '1fr 1fr', columnGap: 11, rowGap: 14, animation: 'riseIn .3s ease' }}>
          {list.map(c => <ClubTile key={c.id} club={c} saved={savedSet.has(c.id)} onSave={onSave} />)}
        </div>
      )}
    </div>
  );
}

// ============ TAB BAR ============
function TabBar() {
  const tabs = [
    { key: 'home', label: '홈', Icon: I.HomeTab, href: '%5Bv1%5DHOME-005.html', active: true },
    { key: 'near', label: '주변', Icon: I.AroundTab, href: '%5Bv1%5DPLACE-019.html' },
    { key: 'search', label: '검색', Icon: I.SearchTab, href: '%5Bv1%5DHOME-006.html' },
    { key: 'saved', label: '찜', Icon: I.SavedTab, href: '%5Bv1%5DPLACE-020.html' },
    { key: 'me', label: '내 정보', Icon: I.MeTab, href: null },
  ];
  return (
    <div style={{ borderTop: `1px solid ${GRAY[900]}`, background: BG, padding: '12px 24px 24px', display: 'flex', justifyContent: 'space-between', flexShrink: 0 }}>
      {tabs.map(t => {
        const Icon = t.Icon;
        return (
          <a key={t.key} href={t.href || '#'} onClick={e => !t.href && e.preventDefault()} style={{ textDecoration: 'none', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, minWidth: 40 }}>
            <div style={{ width: 4, height: 4, borderRadius: 99, background: t.active ? LIME[500] : 'transparent', marginBottom: 2 }} />
            <Icon active={!!t.active} />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: t.active ? LIME[500] : '#fff', fontWeight: t.active ? 600 : 400 }}>{t.label}</span>
          </a>
        );
      })}
    </div>
  );
}

// ============ ROOT ============
function App() {
  const [solid, setSolid] = useState(false);
  const [area, setArea] = useState('홍대');
  const [selected, setSelected] = useState(1);
  const [savedSet, setSavedSet] = useState(new Set([2]));

  const mapList = CLUBS.filter(c => c.area === area);
  const onScroll = (e) => setSolid(e.target.scrollTop > 420);
  const toggleSave = (id) => setSavedSet(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });
  const changeArea = (a) => { setArea(a); const first = CLUBS.find(c => c.area === a); setSelected(first ? first.id : null); };

  return (
    <div style={{ width: '100%', height: '100%', background: BG, position: 'relative', color: '#fff', fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Header solid={solid} />
      <div onScroll={onScroll} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', position: 'relative' }}>
        <Hero />
        <div style={{ position: 'relative' }}>
          <div style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 440, pointerEvents: 'none', background: 'radial-gradient(80% 300px at 6% 0%, rgba(181,255,96,0.13), transparent 64%), radial-gradient(64% 240px at 98% 12%, rgba(119,49,254,0.2), transparent 62%)' }} />
          <div style={{ position: 'relative', paddingTop: 30 }}>
            <MapSection area={area} onArea={changeArea} list={mapList} selected={selected} onSelect={setSelected} savedSet={savedSet} onSave={toggleSave} />
            <div style={{ height: 44 }} />
            <ClubGrid savedSet={savedSet} onSave={toggleSave} onSelect={setSelected} />
            <div style={{ height: 30 }} />
          </div>
        </div>
      </div>
      <TabBar />
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <IOSDevice dark={true} width={393} height={852}>
    <App />
  </IOSDevice>
);
