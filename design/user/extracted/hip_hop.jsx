/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, PURPLE, LIME, RED, BLUE */
const { useState } = React;

const C = { bg: COLORS.bg, purple: PURPLE[500], lime: LIME[500] };
const HIP = '#F5B82E'; // hip-hop accent (gold)
const ON_HIP = '#2A1E04';

// ============ ICONS ============
const I = {
  Back: ({ size = 24, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="15 18 9 12 15 6" />
  </svg>),
  Search: ({ size = 21, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" />
  </svg>),
  Mic: ({ size = 16, color = HIP }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
    <rect x="9" y="2" width="6" height="11" rx="3" /><path d="M5 10a7 7 0 0 0 14 0" /><line x1="12" y1="17" x2="12" y2="21" /><line x1="8.5" y1="21" x2="15.5" y2="21" />
  </svg>),
  Star: ({ size = 13, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round">
    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
  </svg>),
  Pin: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" />
  </svg>),
  Disc: ({ size = 12, color = HIP }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="12" cy="12" r="9" /><circle cx="12" cy="12" r="2.4" />
  </svg>),
  Play: ({ size = 16, color = ON_HIP }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke="none">
    <path d="M7 4.5v15l13-7.5z" />
  </svg>),
  ChevRight: ({ size = 16, color = GRAY[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="9 18 15 12 9 6" />
  </svg>),
  Heart: ({ size = 19, active = false }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
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
// 오늘 밤 헤드라인
const HEROES = [
  { name: '어썸레드', area: '홍대', dist: 0.4, rating: 4.58, lineup: 'YANO', genre: '힙합', time: '오늘 22:00 공연', tag: '오늘밤 주목할 공연', bg: 'linear-gradient(150deg, #1a0f33 0%, #5a2bb8 48%, #f5b82e 120%)' },
  { name: '플로우', area: '강남', dist: 5.0, rating: 4.61, lineup: 'SWERVE', genre: '힙합', time: '오늘 23:30 공연', tag: '오늘밤 주목할 공연', bg: 'linear-gradient(150deg, #15082e 0%, #3a0ca3 50%, #7731FE 120%)' },
  { name: '버뮤다', area: '홍대', dist: 0.7, rating: 4.49, lineup: 'NOVA', genre: '힙합', time: '오늘 23:00 공연', tag: '오늘밤 주목할 공연', bg: 'linear-gradient(150deg, #2a1f06 0%, #b5860b 52%, #f5b82e 120%)' },
  { name: '몹', area: '압구정', dist: 4.2, rating: 4.55, lineup: 'VICE', genre: '힙합', time: '오늘 00:30 공연', tag: '오늘밤 주목할 공연', bg: 'linear-gradient(150deg, #2e0a1a 0%, #a01448 52%, #f72585 120%)' },
];

// 오늘의 공연 래퍼
const DJS = [
  { id: 1, dj: 'YANO', club: '어썸레드', time: '22:00', type: 'rapper', bg: 'linear-gradient(135deg, #7731FE, #f5b82e)' },
  { id: 2, dj: 'GRIM', club: '인클', time: '23:00', type: 'dj', bg: 'linear-gradient(135deg, #fb5607, #ffbe0b)' },
  { id: 3, dj: 'SWERVE', club: '플로우', time: '23:30', type: 'rapper', bg: 'linear-gradient(135deg, #2a1a3e, #7731FE)' },
  { id: 4, dj: 'KODA', club: '부스트', time: '00:00', type: 'dj', bg: 'linear-gradient(135deg, #3a0ca3, #4361ee)' },
  { id: 5, dj: 'VICE', club: '몹', time: '00:30', type: 'rapper', bg: 'linear-gradient(135deg, #4a1e1e, #f72585)' },
  { id: 6, dj: 'ECHO', club: '사운즈', time: '01:00', type: 'dj', bg: 'linear-gradient(135deg, #1b3a3a, #2a9d8f)' },
];

// 지역
const AREAS = ['인기순', '홍대', '강남', '압구정', '이태원', '건대'];

// 힙합 클럽 (포스터 그리드)
const CLUBS = [
  { id: 1, name: '어썸레드', area: '홍대', dist: 0.4, rating: 4.58, styles: ['트랩', '붐뱁'], lineup: 'YANO', live: true, open: true, bg: 'linear-gradient(150deg, #2b1655, #7731FE 60%, #f5b82e)' },
  { id: 3, name: '인클', area: '홍대', dist: 0.5, rating: 4.44, styles: ['올드스쿨'], lineup: 'GRIM', live: true, open: true, bg: 'linear-gradient(150deg, #fb5607, #ffbe0b)' },
  { id: 4, name: '플로우', area: '강남', dist: 5.0, rating: 4.61, styles: ['트랩', '드릴'], lineup: 'SWERVE', live: true, open: true, bg: 'linear-gradient(150deg, #2a1a3e, #7731FE)' },
  { id: 8, name: '몹', area: '압구정', dist: 4.2, rating: 4.55, styles: ['드릴'], lineup: 'VICE', live: true, open: true, bg: 'linear-gradient(150deg, #4a1e1e, #f72585)' },
  { id: 5, name: '부스트', area: '강남', dist: 5.3, rating: 4.52, styles: ['트랩', '붐뱁'], lineup: 'KODA', live: true, open: true, bg: 'linear-gradient(150deg, #3a0ca3, #4361ee)' },
  { id: 2, name: '버뮤다', area: '홍대', dist: 0.7, rating: 4.49, styles: ['R&B', '트랩'], lineup: 'NOVA', live: false, open: true, bg: 'linear-gradient(150deg, #3a2f0a, #f5b82e 65%, #fb8500)' },
  { id: 6, name: '베이스먼트', area: '이태원', dist: 6.0, rating: 4.47, styles: ['붐뱁'], lineup: 'RAWKID', live: false, open: true, bg: 'linear-gradient(150deg, #5a3a1a, #f5b82e)' },
  { id: 7, name: '사운즈', area: '이태원', dist: 6.4, rating: 4.40, styles: ['R&B'], lineup: 'ECHO', live: true, open: true, bg: 'linear-gradient(150deg, #1b3a3a, #2a9d8f)' },
  { id: 9, name: '하이브', area: '건대', dist: 3.1, rating: 4.31, styles: ['올드스쿨'], lineup: 'OG TANG', live: false, open: false, bg: 'linear-gradient(150deg, #ffbe0b, #fb5607)' },
  { id: 10, name: '리얼', area: '건대', dist: 3.4, rating: 4.28, styles: ['트랩', '붐뱁'], lineup: 'BLAZE', live: false, open: false, bg: 'linear-gradient(150deg, #2a2410, #b5860b)' },
];

// ============ HEADER ============
function Header({ scrolled }) {
  return (
    <div style={{
      position: 'absolute', top: 0, left: 0, right: 0, zIndex: 30, height: 52, padding: '0 8px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      background: scrolled ? 'rgba(16,16,19,0.9)' : 'transparent',
      backdropFilter: scrolled ? 'blur(16px)' : 'none', WebkitBackdropFilter: scrolled ? 'blur(16px)' : 'none',
      borderBottom: `1px solid ${scrolled ? GRAY[900] : 'transparent'}`, transition: 'all .2s',
    }}>
      <a href="%5Bv1%5DHOME-005.html" style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <I.Back />
      </a>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: '#fff', opacity: scrolled ? 1 : 0, transition: 'opacity .2s', display: 'flex', alignItems: 'center', gap: 6 }}>
        <I.Mic size={17} /> 힙합
      </span>
      <button style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <I.Search />
      </button>
    </div>
  );
}

// ============ HERO SLIDE ============
function HeroSlide({ h, saved, onSave }) {
  return (
    <div style={{ position: 'relative', height: 440, width: '100%', flexShrink: 0, scrollSnapAlign: 'start', overflow: 'hidden' }}>
      <div style={{ position: 'absolute', inset: 0, background: h.bg }} />
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 70% at 75% 12%, rgba(255,255,255,0.22), transparent 55%)' }} />
      <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, #0d0a0c 6%, rgba(13,10,12,0.55) 42%, rgba(13,10,12,0.15) 70%, rgba(13,10,12,0.4) 100%)' }} />

      {/* save */}
      <button onClick={e => { e.preventDefault(); onSave(); }} style={{
        all: 'unset', cursor: 'pointer', position: 'absolute', top: 60, right: 16, zIndex: 4,
        width: 38, height: 38, borderRadius: 99, background: 'rgba(0,0,0,0.4)', backdropFilter: 'blur(6px)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <I.Heart size={20} active={saved} />
      </button>

      <div style={{ position: 'absolute', left: 20, right: 20, bottom: 42, zIndex: 3 }}>
        {/* eyebrow */}
        <div style={{
          display: 'inline-flex', alignItems: 'center', gap: 6, marginBottom: 13,
          padding: '6px 11px', borderRadius: 999,
          background: HIP, boxShadow: '0 6px 20px rgba(245,184,46,0.4)',
        }}>
          <I.Mic size={13} color={ON_HIP} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 800, color: ON_HIP, letterSpacing: '0.02em' }}>{h.tag}</span>
        </div>

        <h1 style={{ ...TYPO.h1, fontSize: 40, lineHeight: '42px', fontWeight: 800, color: '#fff', margin: '0 0 12px', textShadow: '0 2px 24px rgba(0,0,0,0.5)' }}>{h.name}</h1>

        <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap', marginBottom: 16 }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4 }}>
            <I.Mic size={14} color={HIP} />
            <span style={{ ...TYPO.body4, fontWeight: 700, color: HIP }}>{h.lineup} LIVE</span>
          </span>
          <span style={{ width: 3, height: 3, background: GRAY[500], borderRadius: 99 }} />
          <span style={{ ...TYPO.body4, color: GRAY[200], fontWeight: 600 }}>{h.genre}</span>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <a href="%5Bv1%5DCLUB-021.html" style={{
            all: 'unset', cursor: 'pointer', flex: 1,
            height: 50, borderRadius: 14, background: HIP,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 7,
            boxShadow: '0 8px 24px rgba(245,184,46,0.3)',
          }}>
            <I.Play size={16} color={ON_HIP} />
            <span style={{ ...TYPO.button1, fontWeight: 800, color: ON_HIP }}>지금 입장 정보 보기</span>
          </a>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 7, marginTop: 13 }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4 }}>
            <I.Star size={13} /><span style={{ ...TYPO.body4, fontWeight: 700, color: '#fff' }}>{h.rating.toFixed(2)}</span>
          </span>
          <span style={{ width: 3, height: 3, background: GRAY[500], borderRadius: 99 }} />
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4 }}>
            <I.Pin size={12} color={GRAY[300]} /><span style={{ ...TYPO.body4, color: GRAY[300] }}>{h.area} · {h.dist}km</span>
          </span>
          <span style={{ width: 3, height: 3, background: GRAY[500], borderRadius: 99 }} />
          <span style={{ ...TYPO.body4, color: GRAY[400] }}>{h.time}</span>
        </div>
      </div>
    </div>
  );
}

// ============ HERO CAROUSEL ============
function Hero({ savedSet, onSave }) {
  const ref = React.useRef(null);
  const [active, setActive] = useState(0);

  const onScroll = (e) => {
    const w = e.target.clientWidth;
    setActive(Math.round(e.target.scrollLeft / w));
  };
  const goTo = (i) => {
    const el = ref.current;
    if (el) el.scrollTo({ left: i * el.clientWidth, behavior: 'smooth' });
  };

  return (
    <div style={{ position: 'relative' }}>
      <div ref={ref} onScroll={onScroll} style={{
        display: 'flex', overflowX: 'auto', scrollSnapType: 'x mandatory',
        scrollbarWidth: 'none', WebkitOverflowScrolling: 'touch',
      }}>
        {HEROES.map((h, i) => (
          <HeroSlide key={h.name} h={h} saved={savedSet.has(`hero-${i}`)} onSave={() => onSave(`hero-${i}`)} />
        ))}
      </div>

      {/* pagination dots */}
      <div style={{ position: 'absolute', bottom: 16, left: 0, right: 0, zIndex: 5, display: 'flex', justifyContent: 'center', gap: 6 }}>
        {HEROES.map((h, i) => (
          <button key={h.name} onClick={() => goTo(i)} style={{
            all: 'unset', cursor: 'pointer', height: 6, borderRadius: 99, transition: 'all .25s',
            width: i === active ? 20 : 6,
            background: i === active ? HIP : 'rgba(255,255,255,0.4)',
          }} />
        ))}
      </div>
    </div>
  );
}

// ============ SECTION HEADER ============
function SectionHead({ title, sub, action, href }) {
  return (
    <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', padding: '0 16px', marginBottom: 13 }}>
      <div>
        <h2 style={{ ...TYPO.h4, fontSize: 20, lineHeight: '22px', fontWeight: 700, color: '#fff', margin: 0 }}>{title}</h2>
        {sub && <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '16px', display: 'block', marginTop: 5 }}>{sub}</span>}
      </div>
      {action === 'map' ? (
        <button style={{ all: 'unset', cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 4, height: 30, padding: '0 11px', borderRadius: 99, background: GRAY[900], border: `1px solid ${GRAY[800]}` }}>
          <I.Pin size={13} color={HIP} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: '#fff', fontWeight: 700 }}>지도에서 보기</span>
        </button>
      ) : (
        <a href={href || '#'} onClick={e => !href && e.preventDefault()} style={{ all: 'unset', cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 1 }}>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: GRAY[500], fontWeight: 600 }}>전체</span>
          <I.ChevRight size={14} color={GRAY[500]} />
        </a>
      )}
    </div>
  );
}

// ============ DJ LINEUP RAIL ============
function DjRail() {
  return (
    <div style={{ display: 'flex', gap: 14, overflowX: 'auto', scrollbarWidth: 'none', padding: '0 16px 4px' }}>
      {DJS.map(d => (
        <a key={d.id} href="%5Bv1%5DCLUB-021.html" style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, width: 76, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}>
          <div style={{ position: 'relative', width: 72, height: 72 }}>
            <div style={{ position: 'absolute', inset: 0, borderRadius: 99, background: d.bg, border: `2px solid ${HIP}`, padding: 2 }}>
              <div style={{ width: '100%', height: '100%', borderRadius: 99, background: d.bg, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                {d.type === 'dj'
                  ? <I.Disc size={24} color="rgba(255,255,255,0.85)" />
                  : <I.Mic size={24} color="rgba(255,255,255,0.85)" />}
              </div>
            </div>
            <span style={{
              position: 'absolute', bottom: -3, left: '50%', transform: 'translateX(-50%)',
              padding: '2px 7px', borderRadius: 99, background: ON_HIP, border: `1px solid ${HIP}`,
              ...TYPO.caption, fontSize: 10, lineHeight: '12px', fontWeight: 800, color: HIP, whiteSpace: 'nowrap',
            }}>{d.time}</span>
          </div>
          <div style={{ textAlign: 'center', width: '100%' }}>
            <div style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 700, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{d.dj}</div>
            <div style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[500], marginTop: 2 }}>{d.type === 'dj' ? 'DJ · ' : ''}{d.club}</div>
          </div>
        </a>
      ))}
    </div>
  );
}

// ============ AREA FILTER ============
function AreaFilter({ active, onChange }) {
  return (
    <div style={{ display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none', padding: '0 16px 2px' }}>
      {AREAS.map(s => {
        const sel = s === active;
        return (
          <button key={s} onClick={() => onChange(s)} style={{
            all: 'unset', cursor: 'pointer', flexShrink: 0,
            height: 34, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 15px', borderRadius: 999,
            background: sel ? HIP : GRAY[900], border: sel ? 'none' : `1px solid ${GRAY[800]}`,
            ...TYPO.button2, fontWeight: sel ? 700 : 500, color: sel ? ON_HIP : GRAY[300], transition: 'all .18s',
          }}>
            {s !== '인기순' && <I.Pin size={12} color={sel ? ON_HIP : GRAY[400]} />}
            {s}
          </button>
        );
      })}
    </div>
  );
}

// ============ POSTER CARD ============
function PosterCard({ club, saved, onSave }) {
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{
      display: 'block', textDecoration: 'none', position: 'relative',
      aspectRatio: '3 / 4', borderRadius: 16, overflow: 'hidden',
      background: club.bg, border: `1px solid ${GRAY[800]}`,
    }}>
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 70% at 70% 12%, rgba(255,255,255,0.2), transparent 55%)' }} />
      <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(10,9,11,0.95) 16%, rgba(10,9,11,0.2) 56%, transparent 80%)' }} />

      {/* status dot */}
      <div style={{
        position: 'absolute', top: 11, left: 11,
        display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 8px', borderRadius: 99,
        background: 'rgba(0,0,0,0.42)', backdropFilter: 'blur(6px)',
        border: `1px solid ${club.open ? 'rgba(181,255,96,0.5)' : GRAY[700]}`,
      }}>
        <span style={{ width: 5, height: 5, borderRadius: 99, background: club.open ? LIME[500] : GRAY[500] }} />
        <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: club.open ? LIME[500] : GRAY[400] }}>{club.open ? '영업 중' : '종료'}</span>
      </div>

      {/* save */}
      <button onClick={e => { e.preventDefault(); onSave(club.id); }} style={{
        all: 'unset', cursor: 'pointer', position: 'absolute', top: 8, right: 8,
        width: 30, height: 30, borderRadius: 99, background: 'rgba(0,0,0,0.42)', backdropFilter: 'blur(6px)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <I.Heart size={15} active={saved} />
      </button>

      <div style={{ position: 'absolute', left: 12, right: 12, bottom: 12 }}>
        {/* lineup pill — 공연이 있는 클럽만 */}
        {club.live && (
          <span style={{
            display: 'inline-flex', alignItems: 'center', gap: 4, marginBottom: 8,
            padding: '3px 8px', borderRadius: 7,
            background: 'rgba(245,184,46,0.18)', border: '1px solid rgba(245,184,46,0.36)',
          }}>
            <I.Mic size={11} color={HIP} />
            <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: HIP }}>{club.lineup} LIVE</span>
          </span>
        )}

        <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginBottom: 5 }}>
          <span style={{ ...TYPO.h4, fontSize: 18, lineHeight: '20px', fontWeight: 700, color: '#fff' }}>{club.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2 }}>
            <I.Star size={11} /><span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: '#fff' }}>{club.rating.toFixed(2)}</span>
          </span>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <I.Pin size={10} color={GRAY[400]} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: GRAY[400], fontWeight: 600 }}>{club.area} · {club.dist.toFixed(1)}km</span>
        </div>

        <div style={{ display: 'flex', gap: 5, marginTop: 8, flexWrap: 'wrap' }}>
          {club.styles.map(t => (
            <span key={t} style={{ ...TYPO.caption, fontSize: 10, lineHeight: '13px', fontWeight: 600, color: GRAY[300], padding: '1px 7px', borderRadius: 6, background: 'rgba(255,255,255,0.09)' }}>#{t}</span>
          ))}
        </div>
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
      <Shimmer h={440} r={0} />
      <div style={{ padding: '20px 16px 0', display: 'flex', gap: 14 }}>
        {[0, 1, 2, 3].map(i => <div key={i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}><Shimmer w={72} h={72} r={99} /><Shimmer w={56} h={12} /></div>)}
      </div>
      <div style={{ padding: '22px 16px 0', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
        {[0, 1, 2, 3].map(i => <Shimmer key={i} h={210} r={16} />)}
      </div>
    </div>
  );
}

// ============ ROOT ============
function App() {
  const [loading, setLoading] = useState(true);
  const [style, setStyle] = useState('인기순'); // 지역 필터
  const [scrolled, setScrolled] = useState(false);
  const [savedSet, setSavedSet] = useState(new Set([1]));

  React.useEffect(() => { const t = setTimeout(() => setLoading(false), 1200); return () => clearTimeout(t); }, []);

  const onScroll = (e) => setScrolled(e.target.scrollTop > 380);
  const toggleSave = (id) => setSavedSet(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });

  const grid = (style === '인기순' ? CLUBS : CLUBS.filter(c => c.area === style))
    .slice().sort((a, b) => b.rating - a.rating);
  const topClub = grid[0];

  return (
    <div style={{ width: '100%', height: '100%', background: '#0d0a0c', position: 'relative', color: '#fff', fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Header scrolled={scrolled} />

      <div onScroll={onScroll} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', position: 'relative' }}>
        {loading ? <Skeleton /> : (
          <>
            <Hero savedSet={savedSet} onSave={toggleSave} />

            {/* DJ lineup */}
            <div style={{ paddingTop: 24 }}>
              <SectionHead title="오늘의 공연 아티스트" sub="내 주변 힙합 클럽 · 공연 시간순" href="%5Bv1%5DHOME-009.html" />
              <DjRail />
            </div>

            <div style={{ margin: '22px 16px 8px', padding: '14px 16px', borderRadius: 14, background: GRAY[900], border: `1px solid ${GRAY[800]}`, display: 'flex', alignItems: 'center', gap: 10 }}>
              <I.Disc size={15} />
              <span style={{ ...TYPO.caption, color: GRAY[400], lineHeight: '17px' }}>공연 라인업은 당일 사정에 따라 변경될 수 있어요. 방문 전 확인해 주세요.</span>
            </div>

            {/* area filter + poster grid */}
            <div style={{ paddingTop: 26 }}>
              <div style={{ marginBottom: 14 }}>
                <AreaFilter active={style} onChange={setStyle} />
              </div>
              <SectionHead
                title={style === '인기순' ? '인기 클럽 TOP 10' : `${style} 인기 클럽 TOP 10`}
                sub={style === '인기순'
                  ? '지금 가장 인기있는 클럽 TOP 10'
                  : `${style}에서 가장 인기있는 클럽 TOP 10`}
                action="map"
              />
              <div key={style} style={{ padding: '0 16px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, animation: 'fadeIn .3s ease' }}>
                {grid.map(c => (
                  <PosterCard key={c.id} club={c} saved={savedSet.has(c.id)} onSave={toggleSave} />
                ))}
              </div>
              {grid.length === 0 && (
                <div style={{ padding: '50px 24px', textAlign: 'center', ...TYPO.body4, color: GRAY[500] }}>{style} 지역에는 클럽이 아직 없어요</div>
              )}
            </div>

            <div style={{ height: 24 }} />
          </>
        )}
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
