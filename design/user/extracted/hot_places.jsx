/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, PURPLE, LIME, RED, BLUE */
const { useState } = React;

const C = { bg: COLORS.bg, purple: PURPLE[500], lime: LIME[500] };
const HOT = '#FF6A2B'; // hot-place accent (flame orange)

// ============ ICONS ============
const I = {
  Back: ({ size = 24, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="15 18 9 12 15 6" />
  </svg>),
  Search: ({ size = 21, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" />
  </svg>),
  Flame: ({ size = 14, color = HOT }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke="none">
    <path d="M12 2c.5 3-1.8 4.3-3 6-1.4 2-1.6 4.2 0 6 .3-1.4 1-2.3 2-3-.3 2 .4 3.2 1.5 4 1.9-1.2 3.5-3.3 3.5-6.2 0-3-1.8-4.6-2.8-5.8-.2 1.3-.9 2-1.7 2.4C12 6.5 12.6 4.5 12 2z" />
  </svg>),
  Star: ({ size = 13, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round">
    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
  </svg>),
  Users: ({ size = 12, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="9" cy="8" r="3" /><path d="M3 20c0-3.3 2.7-6 6-6s6 2.7 6 6" /><path d="M16 6.2a3 3 0 0 1 0 5.6" /><path d="M21 20c0-2.5-1.4-4.6-3.5-5.5" />
  </svg>),
  Pin: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" />
  </svg>),
  Heart: ({ size = 19, active = false }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
  </svg>),
  TrendUp: ({ size = 12, color = HOT }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="3 17 9 11 13 15 21 7" /><polyline points="16 7 21 7 21 12" />
  </svg>),
  HomeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" />
  </svg>),
  AroundTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" />
  </svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" />
  </svg>),
  SavedTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
  </svg>),
  MeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" />
  </svg>),
};

// ============ DATA ============
const AREAS = ['전체', '내 주변', '홍대', '강남', '이태원', '압구정', '건대'];

// crowd level: 'packed' | 'busy' | 'lively'
const CROWD = {
  packed: { label: '매우 붐빔', color: '#FF3B30', pct: 95 },
  busy:   { label: '붐빔',     color: HOT,       pct: 78 },
  lively: { label: '활기참',   color: LIME[500], pct: 55 },
};

// Top 3 podium clubs
const TOP = [
  { id: 1, rank: 1, name: '어썸레드', area: '홍대', genre: '힙합', dist: 0.4, visitors: '2.4천', rating: 4.76, crowd: 'packed', bg: 'linear-gradient(135deg, #2b1655, #7731FE 60%, #ff4d8d)' },
  { id: 2, rank: 2, name: 'OCTAGON', area: '강남', genre: 'EDM', dist: 5.2, visitors: '2.1천', rating: 4.80, crowd: 'packed', bg: 'linear-gradient(135deg, #2B6BFF, #7731FE)' },
  { id: 3, rank: 3, name: '버뮤다', area: '홍대', genre: '힙합', dist: 0.7, visitors: '1.8천', rating: 4.62, crowd: 'busy', bg: 'linear-gradient(135deg, #06ffa5, #3a86ff)' },
];

// Full ranked list (4+)
const LIST = [
  { id: 4, rank: 4, name: '인클', area: '홍대', genre: '힙합', dist: 0.5, visitors: '1.6천', rating: 4.70, crowd: 'busy', up: true, bg: 'linear-gradient(135deg, #fb5607, #ffbe0b)' },
  { id: 5, rank: 5, name: '메이드', area: '이태원', genre: 'EDM', dist: 6.1, visitors: '1.5천', rating: 4.58, crowd: 'busy', up: true, bg: 'linear-gradient(135deg, #ff006e, #8338ec)' },
  { id: 6, rank: 6, name: '소다', area: '강남', genre: '하우스', dist: 5.4, visitors: '1.3천', rating: 4.49, crowd: 'lively', up: false, bg: 'linear-gradient(135deg, #3a0ca3, #4361ee)' },
  { id: 7, rank: 7, name: '케이크샵', area: '이태원', genre: '테크노', dist: 6.3, visitors: '1.2천', rating: 4.66, crowd: 'lively', up: true, bg: 'linear-gradient(135deg, #06ffa5, #1b9aaa)' },
  { id: 8, rank: 8, name: '글로우', area: '압구정', genre: 'EDM', dist: 4.2, visitors: '1.1천', rating: 4.41, crowd: 'lively', up: false, bg: 'linear-gradient(135deg, #f72585, #b5179e)' },
  { id: 9, rank: 9, name: '하이브', area: '건대', genre: '힙합', dist: 3.1, visitors: '980', rating: 4.38, crowd: 'lively', up: true, bg: 'linear-gradient(135deg, #ffbe0b, #fb5607)' },
  { id: 10, rank: 10, name: '벨로주', area: '홍대', genre: '재즈', dist: 0.9, visitors: '870', rating: 4.51, crowd: 'lively', up: false, bg: 'linear-gradient(135deg, #2a2d34, #6c757d)' },
];

// ============ HEADER ============
function Header({ scrolled }) {
  return (
    <div style={{
      position: 'sticky', top: 0, zIndex: 20, height: 52, padding: '0 8px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      background: 'rgba(16,16,19,0.9)', backdropFilter: 'blur(16px)', WebkitBackdropFilter: 'blur(16px)',
      borderBottom: `1px solid ${scrolled ? GRAY[900] : 'transparent'}`, transition: 'border-color .2s',
    }}>
      <a href="%5Bv1%5DHOME-005.html" style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <I.Back />
      </a>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: '#fff', display: 'flex', alignItems: 'center', gap: 6 }}>
        <I.Flame size={16} /> 핫플레이스
      </span>
      <button style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <I.Search />
      </button>
    </div>
  );
}

// ============ INTRO ============
function Intro({ area }) {
  const heading = area === '전체'
    ? <>지금 가장 <span style={{ color: HOT }}>뜨거운</span><br />클럽을 모아봤어요</>
    : <>지금 {area}에서 가장 <span style={{ color: HOT }}>뜨거운</span><br />클럽을 모아봤어요</>;
  return (
    <div style={{ position: 'relative', padding: '20px 24px 18px' }}>
      <h1 key={area} style={{ ...TYPO.h2, fontSize: 28, lineHeight: '33px', fontWeight: 700, color: '#fff', margin: '0 0 8px', animation: 'headingSwap .42s cubic-bezier(0.22,1,0.36,1)' }}>
        {heading}
      </h1>
      <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
        <span style={{
          display: 'inline-flex', alignItems: 'center', gap: 5,
          padding: '5px 10px', borderRadius: 999,
          background: 'rgba(255,59,48,0.16)', border: '1px solid rgba(255,59,48,0.4)',
        }}>
          <span style={{ width: 7, height: 7, borderRadius: 99, background: '#FF3B30', animation: 'pulseFlame 1.4s ease-in-out infinite' }} />
          <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: '#fff' }}>실시간</span>
        </span>
        <span style={{ ...TYPO.caption, color: GRAY[400], lineHeight: '16px' }}>오늘 23:40 기준 · 최근 2시간 방문자 순</span>
      </div>
    </div>
  );
}

// ============ AREA FILTER ============
function AreaFilter({ active, onChange, scrolled }) {
  return (
    <div style={{
      position: 'sticky', top: 52, zIndex: 15,
      background: scrolled ? 'rgba(16,16,19,0.92)' : 'transparent',
      backdropFilter: scrolled ? 'blur(12px)' : 'none', WebkitBackdropFilter: scrolled ? 'blur(12px)' : 'none',
      padding: '10px 16px 12px', display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none',
      transition: 'background .2s',
    }}>
      {AREAS.map(a => {
        const sel = a === active;
        const isNear = a === '내 주변';
        return (
          <button key={a} onClick={() => onChange(a)} style={{
            all: 'unset', cursor: 'pointer', flexShrink: 0,
            padding: isNear ? '8px 14px 8px 11px' : '8px 16px', borderRadius: 999,
            background: sel ? '#fff' : GRAY[900],
            border: sel ? 'none' : `1px solid ${GRAY[800]}`,
            ...TYPO.button2, fontWeight: sel ? 700 : 500,
            color: sel ? '#000' : GRAY[300], transition: 'all .18s',
            display: 'inline-flex', alignItems: 'center', gap: 4,
          }}>
            {isNear && <I.Pin size={13} color={sel ? '#000' : HOT} />}
            {a}
          </button>
        );
      })}
    </div>
  );
}

// ============ PODIUM (TOP 3) ============
function PodiumCard({ club, saved, onSave, big, solo }) {
  const cr = CROWD[club.crowd];
  const h = big ? 188 : 150;
  const MEDALS = {
    1: { grad: 'linear-gradient(145deg, #FFE7A0 0%, #FBC02D 45%, #C8860B 100%)', ring: 'rgba(255,209,102,0.55)', ink: '#5A3A00' },
    2: { grad: 'linear-gradient(145deg, #F2F5FA 0%, #C5CCD6 45%, #9098A6 100%)', ring: 'rgba(220,226,235,0.5)', ink: '#3D434D' },
    3: { grad: 'linear-gradient(145deg, #F2B98C 0%, #D98A52 45%, #A65B2A 100%)', ink: '#502A0E', ring: 'rgba(225,150,100,0.5)' },
  };
  const medal = MEDALS[club.rank] || MEDALS[3];
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{
      flex: solo ? '1' : (big ? '0 0 60%' : '1'), textDecoration: 'none', display: 'block',
      position: 'relative', height: h, borderRadius: 16, overflow: 'hidden',
      background: club.bg, border: `1px solid ${GRAY[800]}`,
    }}>
      <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(16,16,19,0.94) 8%, rgba(16,16,19,0.15) 55%, transparent 80%)' }} />

      {/* rank medal */}
      <div style={{
        position: 'absolute', top: 10, left: 10,
        width: big ? 32 : 27, height: big ? 32 : 27, borderRadius: 99,
        background: medal.grad, color: medal.ink,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontWeight: 800, fontSize: big ? 15 : 13, fontFamily: 'Pretendard',
        border: '1.5px solid rgba(255,255,255,0.45)',
        boxShadow: `0 2px 10px ${medal.ring}, inset 0 1px 1.5px rgba(255,255,255,0.7), inset 0 -2px 3px rgba(0,0,0,0.18)`,
      }}>{club.rank}</div>

      {/* save */}
      <button onClick={e => { e.preventDefault(); onSave(club.id); }} style={{
        all: 'unset', cursor: 'pointer', position: 'absolute', top: 8, right: 8,
        width: 30, height: 30, borderRadius: 99, background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(6px)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <I.Heart size={16} active={saved} />
      </button>

      {/* crowd badge — absolute only on the big card (small cards show it inline below) */}
      {big && (
        <div style={{
          position: 'absolute', top: 48, left: 10,
          display: 'inline-flex', alignItems: 'center', gap: 4,
          padding: '4px 8px', borderRadius: 99,
          background: `${cr.color}30`, backdropFilter: 'blur(6px)', border: `1px solid ${cr.color}`,
        }}>
          <I.Flame size={10} color={cr.color} />
          <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '12px', fontWeight: 700, color: '#fff' }}>{cr.label}</span>
        </div>
      )}

      {/* info */}
      <div style={{ position: 'absolute', left: 12, right: 12, bottom: 11 }}>
        <div style={{ ...(big ? TYPO.h4 : TYPO.body3), fontWeight: 700, color: '#fff', marginBottom: 5 }}>{club.name}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
            <I.Star size={11} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: '#fff', fontWeight: 700 }}>{club.rating.toFixed(2)}</span>
          </span>
          <span style={{ width: 2, height: 2, background: GRAY[500], borderRadius: 99 }} />
          {big ? (
            <>
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
                <I.Users size={11} color={GRAY[300]} />
                <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[300], fontWeight: 600 }}>{club.visitors}</span>
              </span>
              <span style={{ width: 2, height: 2, background: GRAY[500], borderRadius: 99 }} />
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[300] }}>{club.area}</span>
            </>
          ) : (
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
              <I.Flame size={10} color={cr.color} />
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: cr.color, fontWeight: 700 }}>{cr.label}</span>
            </span>
          )}
        </div>
      </div>
    </a>
  );
}

function Podium({ clubs, savedSet, onSave }) {
  if (!clubs || clubs.length === 0) return null;
  const top = clubs.slice(0, 3);
  const [first, ...rest] = top;
  const solo = rest.length === 0;
  return (
    <div style={{ padding: '6px 16px 8px' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '6px 2px 12px' }}>
        <span style={{ ...TYPO.button2, fontWeight: 700, color: '#fff' }}>실시간 TOP {top.length}</span>
      </div>
      <div style={{ display: 'flex', gap: 10, alignItems: 'stretch' }}>
        <PodiumCard club={first} big solo={solo} saved={savedSet.has(first.id)} onSave={onSave} />
        {!solo && (
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 10 }}>
            {rest.map(c => <PodiumCard key={c.id} club={c} saved={savedSet.has(c.id)} onSave={onSave} />)}
          </div>
        )}
      </div>
    </div>
  );
}

// ============ CROWD BAR ============
function CrowdBar({ crowd }) {
  const cr = CROWD[crowd];
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 7, marginTop: 7 }}>
      <div style={{ flex: 1, height: 5, borderRadius: 99, background: GRAY[800], overflow: 'hidden' }}>
        <div style={{ width: `${cr.pct}%`, height: '100%', borderRadius: 99, background: cr.color }} />
      </div>
      <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: cr.color, flexShrink: 0 }}>{cr.label}</span>
    </div>
  );
}

// ============ LIST ROW ============
function ListRow({ club, saved, onSave, near }) {
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{
      display: 'flex', gap: 13, padding: '14px 20px', textDecoration: 'none',
      borderBottom: `1px solid ${GRAY[900]}`, alignItems: 'center',
    }}>
      <div style={{ width: 20, flexShrink: 0, display: 'flex', justifyContent: 'center' }}>
        <span style={{ fontFamily: 'Pretendard', fontWeight: 800, fontSize: 16, color: GRAY[600], letterSpacing: '-0.04em' }}>{club.rank}</span>
      </div>

      <div style={{ position: 'relative', width: 72, height: 72, borderRadius: 12, flexShrink: 0, overflow: 'hidden', background: club.bg, border: `1px solid ${GRAY[900]}` }}>
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 30%, rgba(255,255,255,0.2), transparent 60%)' }} />
      </div>

      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, minWidth: 0 }}>
            <span style={{ ...TYPO.body3, color: '#fff', fontWeight: 600 }}>{club.name}</span>
            {club.up && (
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2, padding: '2px 5px', borderRadius: 6, background: 'rgba(255,106,43,0.16)' }}>
                <I.TrendUp size={10} />
                <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '12px', fontWeight: 700, color: HOT }}>상승</span>
              </span>
            )}
          </div>
          <button onClick={e => { e.preventDefault(); onSave(club.id); }} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, padding: 2 }}>
            <I.Heart size={18} active={saved} />
          </button>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 3 }}>
          {near && (
            <>
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
                <I.Pin size={11} color={HOT} />
                <span style={{ ...TYPO.caption, lineHeight: '14px', color: HOT, fontWeight: 700 }}>{club.dist.toFixed(1)}km</span>
              </span>
              <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
            </>
          )}
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
            <I.Star size={11} />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: '#fff', fontWeight: 700 }}>{club.rating.toFixed(2)}</span>
          </span>
          <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
          <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '14px' }}>{club.area}</span>
          <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
          <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '14px' }}>{club.genre}</span>
          <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
            <I.Users size={11} color={GRAY[400]} />
            <span style={{ ...TYPO.caption, color: GRAY[400], lineHeight: '14px', fontWeight: 600 }}>{club.visitors}</span>
          </span>
        </div>

        <CrowdBar crowd={club.crowd} />
      </div>
    </a>
  );
}

// ============ TAB BAR ============
function TabBar() {
  const tabs = [
    { key: 'home',   label: '홈',     Icon: I.HomeTab,   href: '%5Bv1%5DHOME-005.html', active: true },
    { key: 'near',   label: '주변',   Icon: I.AroundTab, href: '%5Bv1%5DPLACE-019.html' },
    { key: 'search', label: '검색',   Icon: I.SearchTab, href: '%5Bv1%5DHOME-006.html' },
    { key: 'saved',  label: '찜',     Icon: I.SavedTab,  href: '%5Bv1%5DPLACE-020.html' },
    { key: 'me',     label: '내 정보', Icon: I.MeTab,     href: null },
  ];
  return (
    <div style={{ borderTop: `1px solid ${GRAY[900]}`, background: COLORS.bg, padding: '12px 24px 8px', display: 'flex', justifyContent: 'space-between', flexShrink: 0 }}>
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

// ============ SKELETON ============
function Shimmer({ w = '100%', h = 12, r = 6, style = {} }) {
  return (<div style={{ width: w, height: h, borderRadius: r, flexShrink: 0, background: `linear-gradient(90deg, ${GRAY[900]} 0px, ${GRAY[800]} 80px, ${GRAY[900]} 160px)`, backgroundSize: '360px 100%', animation: 'shimmer 1.3s ease-in-out infinite', ...style }} />);
}

function Skeleton() {
  return (
    <div style={{ animation: 'fadeIn .2s ease' }}>
      <div style={{ padding: '20px 24px 18px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        <Shimmer w="75%" h={28} /><Shimmer w={150} h={26} r={999} />
      </div>
      <div style={{ padding: '10px 16px 12px', display: 'flex', gap: 8 }}>
        {[52, 60, 60, 70, 56].map((w, i) => <Shimmer key={i} w={w} h={34} r={999} />)}
      </div>
      <div style={{ padding: '6px 16px', display: 'flex', gap: 10 }}>
        <Shimmer w="58%" h={188} r={16} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 10 }}>
          <Shimmer h={89} r={16} /><Shimmer h={89} r={16} />
        </div>
      </div>
      {[0, 1, 2].map(i => (
        <div key={i} style={{ display: 'flex', gap: 13, padding: '14px 20px', alignItems: 'center' }}>
          <Shimmer w={20} h={20} /><Shimmer w={72} h={72} r={12} />
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 9 }}>
            <Shimmer w="45%" h={14} /><Shimmer w="75%" h={11} /><Shimmer w="100%" h={5} r={99} />
          </div>
        </div>
      ))}
    </div>
  );
}

// ============ ROOT ============
function App() {
  const [loading, setLoading] = useState(true);
  const [area, setArea] = useState('전체');
  const [scrolled, setScrolled] = useState(false);
  const [savedSet, setSavedSet] = useState(new Set([1]));

  React.useEffect(() => { const t = setTimeout(() => setLoading(false), 1300); return () => clearTimeout(t); }, []);

  const onScroll = (e) => setScrolled(e.target.scrollTop > 8);
  const toggleSave = (id) => setSavedSet(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });

  const near = area === '내 주변';
  const NEAR_RADIUS = 2; // km
  const ranked = area === '전체'
    ? [...TOP, ...LIST]
    : near
      ? [...TOP, ...LIST].filter(c => c.dist <= NEAR_RADIUS).sort((a, b) => a.dist - b.dist).map((c, i) => ({ ...c, rank: i + 1 }))
      : [...TOP, ...LIST].filter(c => c.area === area).sort((a, b) => a.rank - b.rank).map((c, i) => ({ ...c, rank: i + 1 }));
  // 전체일 때만 TOP 3 포디움 + 나머지 순위, 그 외 지역은 전체 리스트만
  const list = area === '전체' ? ranked.slice(3) : ranked;
  const total = ranked.length;

  return (
    <div style={{ width: '100%', height: '100%', background: C.bg, position: 'relative', color: '#fff', fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Header scrolled={scrolled} />

      <div onScroll={onScroll} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', position: 'relative' }}>
        {/* continuous gradient backdrop behind intro → filter → podium */}
        {!loading && (
          <div style={{
            position: 'absolute', top: 0, left: 0, right: 0, height: 560, zIndex: 0, pointerEvents: 'none',
            background: 'radial-gradient(125% 360px at 0% 0%, rgba(255,106,43,0.30), transparent 72%), radial-gradient(135% 420px at 100% 40px, rgba(255,59,48,0.17), transparent 72%)',
          }} />
        )}
        <div style={{ position: 'relative', zIndex: 1 }}>
        {loading ? <Skeleton /> : (
          <>
            <Intro area={area} />
            <AreaFilter active={area} onChange={setArea} scrolled={scrolled} />
            {area === '전체' && <Podium clubs={ranked.slice(0, 3)} savedSet={savedSet} onSave={toggleSave} />}

            {near ? (
              <>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '16px 20px 6px' }}>
                  <span style={{ ...TYPO.button2, fontWeight: 700, color: '#fff', display: 'flex', alignItems: 'center', gap: 6 }}>
                    <I.Pin size={14} color={HOT} />내 주변 핫플
                  </span>
                  <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '16px' }}>{`반경 ${NEAR_RADIUS}km · ${total}곳`}</span>
                </div>
                {list.length === 0 ? (
                  <div style={{ padding: '60px 24px', textAlign: 'center', ...TYPO.body4, color: GRAY[500] }}>
                    반경 2km 안에 집계된 핫플이 아직 없어요
                  </div>
                ) : list.map(c => <ListRow key={c.id} club={c} near saved={savedSet.has(c.id)} onSave={toggleSave} />)}
              </>
            ) : (
              <>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '16px 20px 6px' }}>
                  <span style={{ ...TYPO.button2, fontWeight: 700, color: '#fff' }}>
                    {area === '전체' ? '전체 순위' : `${area} 순위`}
                  </span>
                  <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '16px' }}>{`${total}곳`}</span>
                </div>
                {list.map(c => <ListRow key={c.id} club={c} saved={savedSet.has(c.id)} onSave={toggleSave} />)}
              </>
            )}

            <div style={{ margin: '18px 20px 8px', padding: '14px 16px', borderRadius: 14, background: GRAY[900], border: `1px solid ${GRAY[800]}`, display: 'flex', alignItems: 'center', gap: 10 }}>
              <I.Flame size={15} />
              <span style={{ ...TYPO.caption, color: GRAY[400], lineHeight: '17px' }}>순위는 실시간 방문자 수와 혼잡도를 반영해 10분마다 갱신돼요.</span>
            </div>
            <div style={{ height: 24 }} />
          </>
        )}
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
