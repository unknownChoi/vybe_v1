/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, PURPLE, LIME */
const { useState, useEffect } = React;

const C = { bg: COLORS.bg, lime: LIME[500], purple: PURPLE[500], purpleDeep: PURPLE[700] };

// ============ ICONS ============
const I = {
  Back: ({ size = 18, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="15 18 9 12 15 6" />
  </svg>),
  Search: ({ size = 18, color = GRAY[400] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" />
  </svg>),
  Pin: ({ size = 14, color = GRAY[400] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" />
  </svg>),
  Clock: ({ size = 12, color = GRAY[300] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="12" cy="12" r="9" /><polyline points="12 7 12 12 15.5 14" />
  </svg>),
  Won: ({ size = 12, color = GRAY[300] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M4 5l3 14 5-11 5 11 3-14" /><line x1="3" y1="11" x2="21" y2="11" />
  </svg>),
  Star: ({ size = 13, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round">
    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
  </svg>),
  Check: ({ size = 13, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="20 6 9 17 4 12" />
  </svg>),
  Chevron: ({ size = 12, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="6 9 12 15 18 9" />
  </svg>),
  Locate: ({ size = 14, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="12" cy="12" r="3.2" /><line x1="12" y1="2" x2="12" y2="5" /><line x1="12" y1="19" x2="12" y2="22" /><line x1="2" y1="12" x2="5" y2="12" /><line x1="19" y1="12" x2="22" y2="12" />
  </svg>),
  Heart: ({ size = 18, active = false }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
  </svg>),
  // filter chip icons
  fOpen: ({ c }) => (<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><polyline points="12 7 12 12 15.5 14" /></svg>),
  fDrink: ({ c }) => (<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3h14l-7 8z" /><line x1="12" y1="11" x2="12" y2="20" /><line x1="8" y1="20" x2="16" y2="20" /></svg>),
  fFree: ({ c }) => (<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M4 5l3 14 5-11 5 11 3-14" /><line x1="3" y1="11" x2="21" y2="11" /><line x1="4" y1="4" x2="20" y2="20" /></svg>),
  fHiphop: ({ c }) => (<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M3 18V9a9 9 0 0 1 18 0v9" /><rect x="2" y="14" width="5" height="7" rx="1.6" /><rect x="17" y="14" width="5" height="7" rx="1.6" /></svg>),
  fEdm: ({ c }) => (<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="4" y1="10" x2="4" y2="14" /><line x1="9" y1="6" x2="9" y2="18" /><line x1="14" y1="9" x2="14" y2="15" /><line x1="19" y1="4" x2="19" y2="20" /></svg>),
  fHybrid: ({ c }) => (<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="16 3 21 3 21 8" /><line x1="4" y1="20" x2="21" y2="3" /><polyline points="21 16 21 21 16 21" /><line x1="15" y1="15" x2="21" y2="21" /><line x1="4" y1="4" x2="9" y2="9" /></svg>),
  fSmoke: ({ c }) => (<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M18 12H2v3h16" /><path d="M22 12v3" /><path d="M18 8c0-2-1.5-3-1.5-4" /><line x1="3" y1="3" x2="21" y2="21" /></svg>),
  Home: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" /></svg>),
  Around: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" /></svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  Saved: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  Me: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" /></svg>),
  Vybe: ({ size = 11, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke="none"><path d="M12 2l2.4 6.9L21 9.3l-5.2 4.2L17.6 21 12 16.9 6.4 21l1.8-7.5L3 9.3l6.6-.4z" /></svg>),
};

// ============ DATA (from search_result_screen.dart structure) ============
const QUERY = '홍대 클럽';

const CLUBS = [
  { id: 1, name: '어썸레드', area: '홍대', genre: '힙합', tags: ['hiphop', '서비스 음료'], rating: 4.76, reviews: 132, dist: 0.32, address: '서울 마포구 잔다리로 12 지하 1층', open: true, close: '02:00', feeMin: 0, feeMax: 10000, smoke: false, recommended: true, bg: 'linear-gradient(135deg, #2b1655, #7731FE 60%, #ff4d8d)' },
  { id: 2, name: '레이저', area: '홍대', genre: '힙합', tags: ['hiphop'], rating: 4.50, reviews: 281, dist: 0.54, address: '서울 마포구 와우산로 23 지하 1층', open: true, close: '03:00', feeMin: 10000, feeMax: 20000, smoke: true, recommended: false, bg: 'linear-gradient(135deg, #ff006e, #8338ec)' },
  { id: 3, name: '버뮤다', area: '홍대', genre: 'EDM', tags: ['edm', '서비스 음료'], rating: 4.30, reviews: 96, dist: 0.68, address: '서울 마포구 양화로 161 지하 2층', open: true, close: '05:00', feeMin: 0, feeMax: 15000, smoke: false, recommended: false, bg: 'linear-gradient(135deg, #06ffa5, #3a86ff)' },
  { id: 4, name: '인클', area: '홍대', genre: '하이브리드', tags: ['hybrid', '서비스 음료'], rating: 4.70, reviews: 214, dist: 0.72, address: '서울 마포구 동교로 165', open: true, close: '04:00', feeMin: 0, feeMax: 0, smoke: false, recommended: true, bg: 'linear-gradient(135deg, #fb5607, #ffbe0b)' },
  { id: 5, name: '벨로주', area: '홍대', genre: '재즈', tags: ['jazz'], rating: 4.50, reviews: 88, dist: 0.86, address: '서울 마포구 와우산로 19', open: false, close: '01:30', feeMin: 0, feeMax: 0, smoke: false, recommended: false, bg: 'linear-gradient(135deg, #6d4c91, #2a2d34)' },
  { id: 6, name: '소다', area: '홍대', genre: 'EDM', tags: ['edm'], rating: 4.42, reviews: 167, dist: 0.91, address: '서울 마포구 서교동 357-1 지하 1층', open: true, close: '06:00', feeMin: 15000, feeMax: 25000, smoke: true, recommended: false, bg: 'linear-gradient(135deg, #3a0ca3, #4361ee)' },
];

// 1:1 with ClubFilter enum (favorite omitted — search result has no fav filter)
const FILTERS = [
  { key: 'open',  label: '영업중',     Icon: I.fOpen },
  { key: 'drink', label: '서비스 음료', Icon: I.fDrink },
  { key: 'free',  label: '입장료 무료', Icon: I.fFree },
  { key: 'hiphop',label: '힙합',       Icon: I.fHiphop },
  { key: 'edm',   label: 'EDM',        Icon: I.fEdm },
  { key: 'hybrid',label: '하이브리드',  Icon: I.fHybrid },
  { key: 'smoke', label: '금연',       Icon: I.fSmoke },
];
const SORT_OPTIONS = ['추천순', '거리순', '평점순', '리뷰 많은순'];

const won = (n) => n === 0 ? '0' : n.toLocaleString('ko-KR');

// ============ RESULT GNB (glass back + search pill) ============
function ResultGnb({ query, scrolled }) {
  return (
    <div style={{
      position: 'sticky', top: 0, zIndex: 20,
      padding: '8px 16px 10px', display: 'flex', alignItems: 'center', gap: 8,
      background: scrolled ? 'rgba(16,16,19,0.82)' : 'transparent',
      backdropFilter: scrolled ? 'blur(18px) saturate(160%)' : 'none',
      WebkitBackdropFilter: scrolled ? 'blur(18px) saturate(160%)' : 'none',
      transition: 'background .2s',
    }}>
      <a href="%5Bv1%5DHOME-006.html" style={{
        all: 'unset', cursor: 'pointer', width: 34, height: 34, borderRadius: 99, flexShrink: 0,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        background: 'rgba(255,255,255,0.07)',
        border: '1px solid rgba(255,255,255,0.14)',
        backdropFilter: 'blur(12px)', WebkitBackdropFilter: 'blur(12px)',
        boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.16)',
      }}>
        <I.Back />
      </a>
      <a href="%5Bv1%5DHOME-006.html" style={{
        all: 'unset', cursor: 'pointer', flex: 1, height: 44, boxSizing: 'border-box',
        display: 'flex', alignItems: 'center', gap: 10, padding: '0 16px', borderRadius: 999,
        background: 'rgba(255,255,255,0.06)',
        border: '1px solid rgba(255,255,255,0.12)',
        backdropFilter: 'blur(12px)', WebkitBackdropFilter: 'blur(12px)',
        boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.12)',
      }}>
        <span style={{ flex: 1, minWidth: 0, ...TYPO.body4, color: '#fff', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{query}</span>
        <I.Search size={18} color={GRAY[300]} />
      </a>
    </div>
  );
}

// ============ LOCATION + COUNT ROW ============
function MetaRow({ count }) {
  return (
    <div style={{ padding: '4px 16px 12px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 6 }}>
        <span style={{ ...TYPO.body3, color: '#fff', fontWeight: 700 }}>검색결과</span>
        <span style={{ ...TYPO.body3, color: LIME[500], fontWeight: 700 }}>{count}</span>
      </div>
      <span style={{
        display: 'inline-flex', alignItems: 'center', gap: 5,
        height: 30, boxSizing: 'border-box', padding: '0 11px', borderRadius: 999,
        background: 'rgba(181,255,96,0.1)', border: '1px solid rgba(181,255,96,0.28)',
      }}>
        <I.Locate size={13} />
        <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: LIME[500] }}>내 주변 검색</span>
      </span>
    </div>
  );
}

// ============ FILTER CHIP BAR ============
function FilterBar({ active, onToggle, sort, onSort, scrolled }) {
  const [sortOpen, setSortOpen] = useState(false);
  return (
    <div style={{
      position: 'sticky', top: 62, zIndex: 15,
      background: scrolled ? 'rgba(16,16,19,0.9)' : 'transparent',
      backdropFilter: scrolled ? 'blur(14px)' : 'none', WebkitBackdropFilter: scrolled ? 'blur(14px)' : 'none',
      transition: 'background .2s',
    }}>
      <div style={{ position: 'relative' }}>
        <div style={{ padding: '4px 16px 12px', display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none' }}>
          {/* sort */}
          <button onClick={() => setSortOpen(o => !o)} style={{
            ...chip, flexShrink: 0,
            background: sortOpen || sort !== '추천순' ? PURPLE[700] : GRAY[900],
            border: sortOpen || sort !== '추천순' ? '1px solid transparent' : `1px solid ${GRAY[800]}`,
            color: '#fff', fontWeight: 600,
          }}>
            {sort}
            <span style={{ display: 'inline-flex', transform: sortOpen ? 'rotate(180deg)' : 'none', transition: 'transform .2s' }}>
              <I.Chevron size={12} color="#fff" />
            </span>
          </button>
          <span style={{ width: 1, alignSelf: 'stretch', background: GRAY[800], margin: '5px 2px', flexShrink: 0 }} />
          {FILTERS.map(f => {
            const sel = active.includes(f.key);
            const Icon = f.Icon;
            return (
              <button key={f.key} onClick={() => onToggle(f.key)} style={{
                ...chip, flexShrink: 0,
                background: sel ? PURPLE[700] : GRAY[900],
                border: sel ? '1px solid transparent' : `1px solid ${GRAY[800]}`,
                color: sel ? '#fff' : GRAY[300],
                fontWeight: sel ? 600 : 500,
              }}>
                <Icon c={sel ? '#fff' : GRAY[400]} />
                {f.label}
              </button>
            );
          })}
        </div>

        {sortOpen && (
          <>
            <div onClick={() => setSortOpen(false)} style={{ position: 'fixed', inset: 0, zIndex: 19 }} />
            <div style={{
              position: 'absolute', top: 'calc(100% - 4px)', left: 16, zIndex: 20,
              minWidth: 156, padding: 6,
              background: GRAY[800], borderRadius: 12, border: `1px solid ${GRAY[700]}`,
              boxShadow: '0 16px 36px rgba(0,0,0,0.55)',
              display: 'flex', flexDirection: 'column', gap: 2,
            }}>
              {SORT_OPTIONS.map(opt => {
                const on = opt === sort;
                return (
                  <button key={opt} onClick={() => { onSort(opt); setSortOpen(false); }} style={{
                    all: 'unset', cursor: 'pointer', padding: '10px 12px', borderRadius: 8,
                    ...TYPO.body4, fontWeight: on ? 700 : 500,
                    color: on ? LIME[500] : '#fff', background: on ? 'rgba(181,255,96,0.12)' : 'transparent',
                    display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 14,
                  }}>
                    {opt}{on && <I.Check size={14} color={LIME[500]} />}
                  </button>
                );
              })}
            </div>
          </>
        )}
      </div>
    </div>
  );
}
const chip = {
  cursor: 'pointer', appearance: 'none', WebkitAppearance: 'none', margin: 0,
  height: 34, boxSizing: 'border-box', padding: '0 13px', borderRadius: 999,
  ...TYPO.body4, lineHeight: '16px',
  display: 'flex', alignItems: 'center', gap: 5, whiteSpace: 'nowrap',
};

// ============ RESULT CARD (image-forward + liquid glass bar) ============
function ResultCard({ club, saved, onSave, index }) {
  const free = club.feeMin === 0;
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{
      display: 'block', textDecoration: 'none', position: 'relative',
      height: 216, borderRadius: 19, overflow: 'hidden',
      background: club.bg, border: `1px solid ${GRAY[800]}`,
      animation: `resultIn .4s ease ${index * 0.05}s both`,
    }}>
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 80% at 70% 8%, rgba(255,255,255,0.18), transparent 55%)' }} />

      {/* recommend ribbon */}
      {club.recommended && (
        <div style={{
          position: 'absolute', top: 14, left: 14,
          display: 'inline-flex', alignItems: 'center', gap: 5,
          padding: '6px 11px 6px 9px', borderRadius: 10,
          background: LIME[500], boxShadow: '0 6px 18px rgba(181,255,96,0.3)',
        }}>
          <I.Vybe size={12} color={COLORS.bg} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 800, color: COLORS.bg }}>VYBE 추천</span>
        </div>
      )}

      {/* status pill */}
      <div style={{
        position: 'absolute', top: 16, right: 52,
        display: 'inline-flex', alignItems: 'center', gap: 5,
        padding: '5px 9px', borderRadius: 99,
        background: 'rgba(0,0,0,0.42)', backdropFilter: 'blur(6px)', WebkitBackdropFilter: 'blur(6px)',
        border: `1px solid ${club.open ? 'rgba(181,255,96,0.45)' : GRAY[700]}`,
      }}>
        <span style={{ width: 6, height: 6, borderRadius: 99, background: club.open ? LIME[500] : GRAY[500] }} />
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: club.open ? LIME[500] : GRAY[400] }}>{club.open ? '영업중' : '영업종료'}</span>
      </div>

      {/* save */}
      <button onClick={e => { e.preventDefault(); onSave(club.id); }} style={{
        all: 'unset', cursor: 'pointer', position: 'absolute', top: 12, right: 12,
        width: 32, height: 32, borderRadius: 99, background: 'rgba(0,0,0,0.42)', backdropFilter: 'blur(6px)', WebkitBackdropFilter: 'blur(6px)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <I.Heart size={17} active={saved} />
      </button>

      {/* liquid glass info bar */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, padding: '14px 16px 15px',
        background: 'linear-gradient(to top, rgba(16,16,21,0.82), rgba(28,28,38,0.62))',
        backdropFilter: 'blur(18px) saturate(160%)', WebkitBackdropFilter: 'blur(18px) saturate(160%)',
        WebkitMaskImage: 'linear-gradient(to top, #000 78%, transparent 100%)',
        maskImage: 'linear-gradient(to top, #000 78%, transparent 100%)',
        boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.12)',
      }}>
        {/* name + rating */}
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginBottom: 6 }}>
          <span style={{ ...TYPO.h4, fontWeight: 700, color: '#fff' }}>{club.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
            <I.Star size={12} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: '#fff', fontWeight: 700 }}>{club.rating.toFixed(2)}</span>
          </span>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[400] }}>리뷰 {club.reviews}</span>
        </div>

        {/* area · genre · dist */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 8, flexWrap: 'wrap' }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
            <I.Pin size={11} color={GRAY[300]} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[300], fontWeight: 600 }}>{club.area} · {club.dist.toFixed(1)}km</span>
          </span>
          <span style={{ width: 2, height: 2, background: GRAY[500], borderRadius: 99 }} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[400] }}>{club.genre}</span>
          <span style={{ width: 2, height: 2, background: GRAY[500], borderRadius: 99 }} />
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
            <I.Clock size={11} color={GRAY[400]} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[400] }}>{club.open ? `${club.close} 영업종료` : '영업종료'}</span>
          </span>
        </div>

        {/* fee */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
          <span style={{
            display: 'inline-flex', alignItems: 'center', gap: 5,
            padding: '4px 9px', borderRadius: 8,
            background: free ? 'rgba(181,255,96,0.14)' : 'rgba(255,255,255,0.08)',
            border: free ? '1px solid rgba(181,255,96,0.3)' : '1px solid rgba(255,255,255,0.12)',
          }}>
            <I.Won size={11} color={free ? LIME[500] : GRAY[300]} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: free ? LIME[500] : GRAY[200] }}>
              {free ? (club.feeMax === 0 ? '입장료 무료' : `입장료 0 ~ ${won(club.feeMax)}원`) : `입장료 ${won(club.feeMin)} ~ ${won(club.feeMax)}원`}
            </span>
          </span>
        </div>
      </div>
    </a>
  );
}

// ============ TAB BAR ============
function TabBar() {
  const tabs = [
    { key: 'home',   label: '홈',     Icon: I.Home,      href: '%5Bv1%5DHOME-005.html' },
    { key: 'near',   label: '주변',   Icon: I.Around,    href: '%5Bv1%5DPLACE-019.html' },
    { key: 'search', label: '검색',   Icon: I.SearchTab, href: '%5Bv1%5DHOME-006.html', active: true },
    { key: 'saved',  label: '찜',     Icon: I.Saved,     href: '%5Bv1%5DPLACE-020.html' },
    { key: 'me',     label: '내 정보', Icon: I.Me,        href: null },
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
    <div style={{ padding: '4px 16px', display: 'flex', flexDirection: 'column', gap: 14, animation: 'fadeIn .2s ease' }}>
      {[0, 1, 2].map(i => <Shimmer key={i} h={216} r={18} />)}
    </div>
  );
}

// ============ ROOT ============
function App() {
  const [loading, setLoading] = useState(true);
  const [activeFilters, setActiveFilters] = useState([]);
  const [sort, setSort] = useState('추천순');
  const [scrolled, setScrolled] = useState(false);
  const [savedSet, setSavedSet] = useState(new Set([1]));

  useEffect(() => { const t = setTimeout(() => setLoading(false), 950); return () => clearTimeout(t); }, []);

  const onScroll = (e) => setScrolled(e.target.scrollTop > 8);
  const toggleFilter = (k) => setActiveFilters(p => p.includes(k) ? p.filter(x => x !== k) : [...p, k]);
  const toggleSave = (id) => setSavedSet(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });

  // filter (1:1 with clubMatchesFilters)
  let list = CLUBS.filter(c => {
    for (const f of activeFilters) {
      if (f === 'open' && !c.open) return false;
      if (f === 'drink' && !c.tags.some(t => t.includes('서비스 음료'))) return false;
      if (f === 'free' && c.feeMin !== 0) return false;
      if (f === 'hiphop' && !(c.genre.includes('힙합') || c.tags.includes('hiphop'))) return false;
      if (f === 'edm' && !(c.genre.toLowerCase().includes('edm') || c.tags.includes('edm'))) return false;
      if (f === 'hybrid' && !(c.genre.includes('하이브리드') || c.tags.includes('hybrid'))) return false;
      if (f === 'smoke' && c.smoke) return false;
    }
    return true;
  });
  // sort (1:1 with sortClubs)
  list = [...list].sort((a, b) => {
    if (sort === '거리순') return a.dist - b.dist;
    if (sort === '평점순') return (b.rating - a.rating) || (b.reviews - a.reviews);
    if (sort === '리뷰 많은순') return b.reviews - a.reviews;
    return ((b.recommended ? 1 : 0) - (a.recommended ? 1 : 0)) || (b.rating - a.rating);
  });

  return (
    <div style={{ width: '100%', height: '100%', background: C.bg, position: 'relative', color: '#fff', fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <div onScroll={onScroll} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', position: 'relative' }}>
        {!loading && (
          <div style={{
            position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, zIndex: 0, pointerEvents: 'none',
            background: [
              'radial-gradient(80% 240px at 8% 0%, rgba(119,49,254,0.24), transparent 60%)',
              'radial-gradient(70% 260px at 100% 6%, rgba(181,255,96,0.12), transparent 62%)',
              'radial-gradient(100% 360px at 90% 90%, rgba(119,49,254,0.12), transparent 66%)',
              'linear-gradient(180deg, #14101f 0%, #101013 40%, #0d0a0c 100%)',
            ].join(', '),
          }} />
        )}
        <div style={{ position: 'relative', zIndex: 1 }}>
          <ResultGnb query={QUERY} scrolled={scrolled} />
          <MetaRow count={loading ? '–' : list.length} />
          <FilterBar active={activeFilters} onToggle={toggleFilter} sort={sort} onSort={setSort} scrolled={scrolled} />

          {loading ? <Skeleton /> : (
            <div key={`${activeFilters.join()}-${sort}`} style={{ padding: '4px 16px 0', display: 'flex', flexDirection: 'column', gap: 14, animation: 'fadeIn .3s ease' }}>
              {list.length === 0 ? (
                <div style={{ padding: '60px 24px', textAlign: 'center', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10 }}>
                  <I.Search size={26} color={GRAY[600]} />
                  <span style={{ ...TYPO.body3, color: GRAY[400], fontWeight: 600 }}>조건에 맞는 클럽이 없어요</span>
                  <span style={{ ...TYPO.body4, color: GRAY[600] }}>필터를 조정해 다시 찾아보세요</span>
                </div>
              ) : list.map((c, i) => (
                <ResultCard key={c.id} club={c} index={i} saved={savedSet.has(c.id)} onSave={toggleSave} />
              ))}
            </div>
          )}
          <div style={{ height: 24 }} />
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
