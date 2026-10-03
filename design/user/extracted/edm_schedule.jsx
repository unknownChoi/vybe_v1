/* global React, ReactDOM, IOSDevice, TYPO, GRAY, PURPLE, LIME */
const { useState } = React;

const EDM = LIME[500];
const ON_EDM = '#12210a';
const NOW_LABEL = '01:24';

const ENERGY = {
  peak:   { label: '피크', color: EDM },
  high:   { label: '고조', color: '#C8A8FF' },
  warmup: { label: '워밍업', color: GRAY[500] },
};

// ============ ICONS ============
const I = {
  Back: ({ size = 24, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>),
  Search: ({ size = 21, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  Bolt: ({ size = 16, color = EDM }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke="none"><path d="M13 2L4.5 13.5H11l-1.5 8.5L19 9.5h-6.5z" /></svg>),
  Star: ({ size = 13, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>),
  Pin: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" /></svg>),
  ChevRight: ({ size = 16, color = GRAY[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6" /></svg>),
  ChevDown: ({ size = 15, color = GRAY[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9" /></svg>),
  Heart: ({ size = 19, active = false }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  HomeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" /></svg>),
  AroundTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" /></svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  SavedTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  MeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" /></svg>),
};

function Equalizer({ color = EDM, size = 14, bars = 4, live = true }) {
  const hs = [0.55, 1, 0.7, 0.85], ds = [0, 0.18, 0.36, 0.12];
  return (
    <div style={{ display: 'flex', alignItems: 'flex-end', gap: 2, height: size }}>
      {Array.from({ length: bars }).map((_, i) => (
        <span key={i} style={{ width: 2.5, height: size, borderRadius: 2, background: color, transformOrigin: 'bottom', transform: live ? undefined : `scaleY(${hs[i % hs.length] * 0.6})`, animation: live ? `eq ${0.5 + (i % 3) * 0.18}s ease-in-out ${ds[i % ds.length]}s infinite alternate` : 'none' }} />
      ))}
    </div>
  );
}

// ============ TIME ============
const parseMin = (t) => { const [h, m] = t.split(':').map(Number); return h * 60 + m + (h < 12 ? 1440 : 0); };
const NOW_MIN = parseMin(NOW_LABEL);
const stateOf = (s) => { const a = parseMin(s.start), b = parseMin(s.end); if (b <= NOW_MIN) return 'past'; if (a <= NOW_MIN && NOW_MIN < b) return 'live'; return 'upcoming'; };
const energyOf = (s) => (s.bpm >= 130 ? 'peak' : s.bpm >= 127 ? 'high' : 'warmup');

// ============ DATA ============
const GENRES = ['전체', '빅룸', '테크노', '하우스', '트랜스', '프로그레시브'];
const AREAS = ['추천순', '홍대', '강남', '압구정', '이태원', '건대'];

const SETS = [
  { id: 1, club: '글로우', area: '압구정', dist: 4.2, dj: 'AXEL V', genre: '하우스', key: '하우스', bpm: 124, start: '22:00', end: '23:30' },
  { id: 2, club: '소다', area: '강남', dist: 5.4, dj: 'MARLO', genre: '테크 하우스', key: '하우스', bpm: 126, start: '22:30', end: '00:00' },
  { id: 3, club: 'OCTAGON', area: '강남', dist: 5.2, dj: 'NEXØ', genre: '빅룸', key: '빅룸', bpm: 128, start: '23:00', end: '00:30' },
  { id: 4, club: '메이드', area: '이태원', dist: 6.1, dj: 'KORE', genre: '테크노', key: '테크노', bpm: 130, start: '23:30', end: '01:00' },
  { id: 5, club: '케이크샵', area: '이태원', dist: 6.3, dj: 'DELTA', genre: '테크노', key: '테크노', bpm: 132, start: '00:30', end: '02:00' },
  { id: 6, club: 'OCTAGON', area: '강남', dist: 5.2, dj: 'VAULT', genre: '빅룸', key: '빅룸', bpm: 130, start: '01:00', end: '02:30' },
  { id: 7, club: '글로우', area: '압구정', dist: 4.2, dj: 'SENNA', genre: '퓨처 하우스', key: '하우스', bpm: 126, start: '01:30', end: '03:00' },
  { id: 8, club: '메이드', area: '이태원', dist: 6.1, dj: 'AURORA', genre: '프로그레시브', key: '프로그레시브', bpm: 132, start: '02:00', end: '03:30' },
  { id: 9, club: '소다', area: '강남', dist: 5.4, dj: 'ZEPH', genre: '트랜스', key: '트랜스', bpm: 138, start: '02:30', end: '04:00' },
  { id: 10, club: '케이크샵', area: '이태원', dist: 6.3, dj: 'NULL', genre: '테크노', key: '테크노', bpm: 130, start: '03:00', end: '05:00' },
];

const CLUBS = [
  { id: 'c1', name: 'OCTAGON', area: '강남', dist: 5.2, rating: 4.72, styles: ['빅룸', '프로그레시브'], lineup: 'VAULT', at: '01:00', live: true, reason: '오늘 최고 평점 라인업', bg: 'linear-gradient(150deg, #0d1024, #102a4a 55%, #2B6BFF)' },
  { id: 'c2', name: '글로우', area: '압구정', dist: 4.2, rating: 4.66, styles: ['하우스', '퓨처하우스'], lineup: 'SENNA', at: '01:30', live: true, reason: '내 위치에서 가장 가까움', bg: 'linear-gradient(150deg, #150a26, #2a0e3a 52%, #7731FE)' },
  { id: 'c5', name: '케이크샵', area: '이태원', dist: 6.3, rating: 4.55, styles: ['테크노', '미니멀'], lineup: 'DELTA', at: '00:30', live: true, reason: '지금 피크 타임', bg: 'linear-gradient(150deg, #0d1024, #2a0e3a 55%, #622ACF)' },
  { id: 'c4', name: '메이드', area: '이태원', dist: 6.1, rating: 4.58, styles: ['테크노'], lineup: 'AURORA', at: '02:00', live: false, reason: '테크노 올나잇 · 06:00까지', bg: 'linear-gradient(150deg, #1a0a26, #2a0e3a 52%, #8338ec)' },
  { id: 'c3', name: '소다', area: '강남', dist: 5.4, rating: 4.61, styles: ['트랜스', '하우스'], lineup: 'ZEPH', at: '02:30', live: false, reason: '트랜스 스페셜 나이트', bg: 'linear-gradient(150deg, #0c1430, #16213e 55%, #4361ee)' },
  { id: 'c6', name: '펄스', area: '홍대', dist: 0.6, rating: 4.51, styles: ['하우스'], lineup: 'LUNA', at: '01:00', live: true, reason: '걸어서 8분', bg: 'linear-gradient(150deg, #19102e, #4E24A0 60%, #7731FE)' },
  { id: 'c7', name: '볼트', area: '강남', dist: 5.0, rating: 4.47, styles: ['빅룸'], lineup: 'NEXØ', at: '23:00', live: false, reason: '입장료 50% 할인', bg: 'linear-gradient(150deg, #0c1430, #102a4a 55%, #2B6BFF)' },
  { id: 'c9', name: '프리즘', area: '홍대', dist: 0.9, rating: 4.39, styles: ['트랜스'], lineup: 'IRIS', at: '02:00', live: false, reason: '걸어서 12분', bg: 'linear-gradient(150deg, #0d1024, #2047A1 60%, #2B6BFF)' },
  { id: 'c10', name: '오로라', area: '건대', dist: 3.2, rating: 4.34, styles: ['프로그레시브'], lineup: 'AURORA', at: '01:30', live: false, reason: '웰컴 드링크 1잔', bg: 'linear-gradient(150deg, #1a0a26, #3a1a5e 58%, #8338ec)' },
];

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

function ChipRow({ items, active, onChange, pin = false }) {
  return (
    <div style={{ display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none', padding: '0 16px 2px' }}>
      {items.map(g => {
        const sel = g === active;
        return (
          <button key={g} onClick={() => onChange(g)} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, height: 34, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 15px', borderRadius: 999, background: sel ? PURPLE[500] : GRAY[900], border: sel ? 'none' : `1px solid ${GRAY[800]}`, ...TYPO.button2, fontWeight: sel ? 700 : 500, color: sel ? '#fff' : GRAY[300], transition: 'all .18s' }}>
            {pin && g !== '추천순' && <I.Pin size={12} color={sel ? '#fff' : GRAY[400]} />}
            {g}
          </button>
        );
      })}
    </div>
  );
}

// ============ SET CARD ============
function SetCard({ set, st, saved, onSave }) {
  const e = ENERGY[energyOf(set)];
  const live = st === 'live';
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{ display: 'block', textDecoration: 'none', position: 'relative', borderRadius: 14, overflow: 'hidden', padding: '13px 12px 13px 15px', background: live ? 'linear-gradient(120deg, rgba(181,255,96,0.13), rgba(20,24,28,0.6))' : GRAY[900], border: `1px solid ${live ? 'rgba(181,255,96,0.55)' : GRAY[800]}`, opacity: st === 'past' ? 0.52 : 1, boxShadow: live ? '0 6px 22px rgba(181,255,96,0.14)' : 'none' }}>
      <span style={{ position: 'absolute', left: 0, top: 0, bottom: 0, width: 3, background: e.color }} />
      <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 10 }}>
        <div style={{ minWidth: 0 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 7, marginBottom: 7, flexWrap: 'wrap' }}>
            <span style={{ ...TYPO.button1, fontSize: 16, fontWeight: 700, color: '#fff' }}>{set.club}</span>
            {live && <Equalizer size={12} bars={3} />}
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, flexShrink: 0 }}>
              <I.Bolt size={11} color={e.color} />
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 700, color: e.color, whiteSpace: 'nowrap' }}>{set.dj}</span>
            </span>
            <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99, flexShrink: 0 }} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: GRAY[400], whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{set.genre}</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 9 }}>
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: GRAY[500], whiteSpace: 'nowrap' }}>{set.area} · {set.dist}km</span>
            <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99, flexShrink: 0 }} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: GRAY[500], fontWeight: 600, whiteSpace: 'nowrap', fontVariantNumeric: 'tabular-nums' }}>{set.start}–{set.end}</span>
          </div>
        </div>
        <button onClick={e2 => { e2.preventDefault(); onSave(set.id); }} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, width: 30, height: 30, borderRadius: 99, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'rgba(255,255,255,0.06)' }}>
          <I.Heart size={15} active={saved} />
        </button>
      </div>
    </a>
  );
}

// ============ TIMELINE ROW ============
function TimeRow({ set, st, saved, onSave, first, last }) {
  const live = st === 'live';
  const dotColor = live ? EDM : st === 'past' ? GRAY[700] : GRAY[500];
  return (
    <div style={{ display: 'flex', gap: 10, alignItems: 'stretch' }}>
      <div style={{ width: 36, flexShrink: 0, paddingTop: 13, textAlign: 'right' }}>
        <span style={{ ...TYPO.caption, fontSize: 13, lineHeight: '15px', fontWeight: 700, color: live ? EDM : st === 'past' ? GRAY[600] : '#fff', fontVariantNumeric: 'tabular-nums' }}>{set.start}</span>
      </div>
      <div style={{ width: 13, flexShrink: 0, position: 'relative', display: 'flex', justifyContent: 'center' }}>
        <span style={{ position: 'absolute', top: first ? 20 : 0, bottom: last ? 'auto' : 0, height: last ? 0 : 'auto', width: 1.5, background: GRAY[800] }} />
        {live && <span style={{ position: 'absolute', top: 14, width: 18, height: 18, borderRadius: 99, background: 'rgba(181,255,96,0.28)', animation: 'nowLine 1.8s ease-in-out infinite' }} />}
        <span style={{ position: 'absolute', top: 18, width: 10, height: 10, borderRadius: 99, background: dotColor, border: `2px solid #101013`, boxShadow: live ? `0 0 10px ${EDM}` : 'none' }} />
      </div>
      <div style={{ flex: 1, minWidth: 0, paddingBottom: 12 }}>
        <SetCard set={set} st={st} saved={saved} onSave={onSave} />
      </div>
    </div>
  );
}

function NowMarker() {
  return (
    <div style={{ display: 'flex', gap: 10, alignItems: 'center', paddingBottom: 12 }}>
      <div style={{ width: 36, flexShrink: 0 }} />
      <div style={{ width: 13, flexShrink: 0, display: 'flex', justifyContent: 'center' }}>
        <span style={{ width: 1.5, height: 24, background: GRAY[800] }} />
      </div>
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', gap: 8 }}>
        <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 9px', borderRadius: 99, background: EDM, flexShrink: 0 }}>
          <Equalizer size={9} bars={3} color={ON_EDM} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 800, color: ON_EDM, fontVariantNumeric: 'tabular-nums' }}>NOW {NOW_LABEL}</span>
        </span>
        <span style={{ flex: 1, height: 1, background: `repeating-linear-gradient(90deg, ${EDM} 0 5px, transparent 5px 10px)`, opacity: 0.6 }} />
      </div>
    </div>
  );
}

// ============ 전체 공연 일정 페이지 ============
function AllSchedule() {
  const [genre, setGenre] = useState('전체');
  const [savedSet, setSavedSet] = useState(new Set());
  const onSave = (id) => setSavedSet(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });
  const all = SETS.filter(s => genre === '전체' || s.key === genre).slice().sort((a, b) => parseMin(a.start) - parseMin(b.start));
  const liveCount = all.filter(s => stateOf(s) === 'live').length;
  let markerAfter = -1;
  for (let i = 0; i < all.length; i++) if (parseMin(all[i].start) <= NOW_MIN) markerAfter = i;

  return (
    <div style={{ width: '100%', height: '100%', background: '#101013', position: 'relative', color: '#fff', fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <div style={{ flexShrink: 0, zIndex: 20, background: 'rgba(16,16,19,0.94)', backdropFilter: 'blur(16px)', WebkitBackdropFilter: 'blur(16px)', borderBottom: `1px solid ${GRAY[900]}` }}>
        <div style={{ height: 52, padding: '0 8px', display: 'flex', alignItems: 'center', gap: 4 }}>
          <a href="%5Bv1%5DCAT-017.html" style={{ width: 40, height: 40, display: 'flex', alignItems: 'center', justifyContent: 'center', textDecoration: 'none' }}><I.Back /></a>
          <span style={{ ...TYPO.button1, fontSize: 16, fontWeight: 700, color: '#fff' }}>DJ 공연 일정</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', gap: 12, padding: '4px 16px 14px' }}>
          <div>
            <h1 style={{ ...TYPO.h4, fontSize: 22, lineHeight: '25px', fontWeight: 700, margin: 0, letterSpacing: '-0.02em' }}>오늘 밤 공연 {SETS.length}개</h1>
            <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '16px', display: 'block', marginTop: 6 }}>8월 27일 (목) 22:00 – 05:00</span>
          </div>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 6, flexShrink: 0, height: 30, padding: '0 11px', borderRadius: 99, background: 'rgba(181,255,96,0.13)', border: '1px solid rgba(181,255,96,0.42)' }}>
            <Equalizer size={11} bars={3} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 700, color: EDM }}>{liveCount}곳 플레이 중</span>
          </span>
        </div>
        <div style={{ paddingBottom: 12 }}><ChipRow items={GENRES} active={genre} onChange={setGenre} /></div>
      </div>

      <div style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none' }}>
        {all.length === 0 ? (
          <div style={{ padding: '44px 24px', textAlign: 'center', ...TYPO.body4, color: GRAY[500] }}>{genre} 셋은 오늘 예정에 없어요</div>
        ) : (
          <div key={genre} style={{ padding: '18px 16px 0', animation: 'riseIn .3s ease' }}>
            {all.map((s, i) => (
              <React.Fragment key={s.id}>
                <TimeRow set={s} st={stateOf(s)} saved={savedSet.has(s.id)} onSave={onSave} first={i === 0} last={i === all.length - 1} />
                {i === markerAfter && i < all.length - 1 && <NowMarker />}
              </React.Fragment>
            ))}
          </div>
        )}
        <div style={{ padding: '10px 16px 34px', textAlign: 'center' }}>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: GRAY[600] }}>공연 정보는 클럽 사정에 따라 변경될 수 있어요</span>
        </div>
      </div>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <IOSDevice dark={true} width={393} height={852}>
    <AllSchedule />
  </IOSDevice>
);
