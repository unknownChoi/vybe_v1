/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, PURPLE, LIME */
const { useState, useEffect } = React;

const HIP = '#F5B82E';       // hip-hop accent (gold)
const ON_HIP = '#2A1E04';
const BG = '#0d0a0c';
const DJ_TXT = '#B79CFF';    // readable purple on dark

// ============ ICONS ============
const I = {
  Back: ({ size = 24, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>),
  Mic: ({ size = 16, color = HIP }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><rect x="9" y="2" width="6" height="11" rx="3" /><path d="M5 10a7 7 0 0 0 14 0" /><line x1="12" y1="17" x2="12" y2="21" /><line x1="8.5" y1="21" x2="15.5" y2="21" /></svg>),
  Disc: ({ size = 16, color = HIP }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><circle cx="12" cy="12" r="2.4" /></svg>),
  Pin: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" /></svg>),
  Star: ({ size = 13, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>),
  ChevRight: ({ size = 16, color = GRAY[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6" /></svg>),
  Clock: ({ size = 13, color = GRAY[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><polyline points="12 7 12 12 15 14" /></svg>),
};

// ============ DATA — 오늘의 공연 라인업 (시간순) ============
const LINEUP = [
  { id: 'reno',   dj: 'RENO',   club: '베이스먼트', area: '이태원', time: '21:00', type: 'dj',     rating: 4.47, genres: ['올드스쿨'],    bg: 'linear-gradient(135deg,#5a3a1a,#f5b82e)' },
  { id: 'yano',   dj: 'YANO',   club: '어썸레드',   area: '홍대',   time: '22:00', type: 'rapper', rating: 4.58, genres: ['트랩', '붐뱁'], bg: 'linear-gradient(135deg,#7731FE,#f5b82e)', headline: true },
  { id: 'grim',   dj: 'GRIM',   club: '인클',       area: '홍대',   time: '23:00', type: 'dj',     rating: 4.44, genres: ['올드스쿨'],    bg: 'linear-gradient(135deg,#fb5607,#ffbe0b)' },
  { id: 'swerve', dj: 'SWERVE', club: '플로우',     area: '강남',   time: '23:30', type: 'rapper', rating: 4.61, genres: ['트랩', '드릴'], bg: 'linear-gradient(135deg,#2a1a3e,#7731FE)' },
  { id: 'koda',   dj: 'KODA',   club: '부스트',     area: '강남',   time: '00:00', type: 'dj',     rating: 4.52, genres: ['트랩'],         bg: 'linear-gradient(135deg,#3a0ca3,#4361ee)' },
  { id: 'vice',   dj: 'VICE',   club: '몹',         area: '압구정', time: '00:30', type: 'rapper', rating: 4.55, genres: ['드릴'],         bg: 'linear-gradient(135deg,#4a1e1e,#f72585)' },
  { id: 'echo',   dj: 'ECHO',   club: '사운즈',     area: '이태원', time: '01:00', type: 'dj',     rating: 4.40, genres: ['R&B'],          bg: 'linear-gradient(135deg,#1b3a3a,#2a9d8f)' },
  { id: 'nova',   dj: 'NOVA',   club: '버뮤다',     area: '홍대',   time: '01:30', type: 'rapper', rating: 4.49, genres: ['R&B', '트랩'],  bg: 'linear-gradient(135deg,#3a2f0a,#f5b82e)' },
  { id: 'blaze',  dj: 'BLAZE',  club: '리얼',       area: '건대',   time: '02:00', type: 'rapper', rating: 4.28, genres: ['붐뱁'],         bg: 'linear-gradient(135deg,#2a2410,#b5860b)' },
];

const NOW_MIN = 23 * 60 + 15; // 데모 기준 현재 시각 23:15
const toMin = (t) => { let [h, m] = t.split(':').map(Number); if (h < 6) h += 24; return h * 60 + m; };
const statusOf = (t) => { const m = toMin(t); return m <= NOW_MIN - 60 ? 'past' : (m <= NOW_MIN ? 'now' : 'up'); };

const TYPE_META = {
  rapper: { label: '래퍼', color: HIP, bg: 'rgba(245,184,46,0.16)', Icon: I.Mic },
  dj:     { label: 'DJ',  color: DJ_TXT, bg: 'rgba(119,49,254,0.22)', Icon: I.Disc },
};

// ============ HEADER ============
function Header() {
  return (
    <div style={{
      flexShrink: 0, paddingTop: 50, paddingBottom: 12, padding: '50px 8px 12px',
      display: 'grid', gridTemplateColumns: '44px 1fr 44px', alignItems: 'center',
      background: BG, borderBottom: `1px solid ${GRAY[900]}`, zIndex: 20,
    }}>
      <a href="%5Bv1%5DCAT-016.html" style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <I.Back />
      </a>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: '#fff', textAlign: 'center', display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}>
        <I.Mic size={16} /> 오늘의 라인업
      </span>
      <span />
    </div>
  );
}

// ============ NOW BANNER ============
function NowBanner({ item }) {
  if (!item) return null;
  const meta = TYPE_META[item.type];
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{
      display: 'flex', alignItems: 'center', gap: 13, textDecoration: 'none',
      margin: '4px 16px 6px', padding: 14, borderRadius: 19,
      background: 'linear-gradient(120deg, rgba(245,184,46,0.16), rgba(245,184,46,0.05))',
      border: `1.5px solid ${HIP}`, boxShadow: '0 10px 30px rgba(245,184,46,0.16)',
    }}>
      <div style={{ position: 'relative', width: 54, height: 54, flexShrink: 0 }}>
        <div style={{ width: '100%', height: '100%', borderRadius: 99, background: item.bg, border: `2px solid ${HIP}`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <meta.Icon size={22} color="rgba(255,255,255,0.92)" />
        </div>
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6, marginBottom: 6 }}>
          <span style={{ width: 7, height: 7, borderRadius: 99, background: HIP, animation: 'pulse 1.3s ease-in-out infinite' }} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 800, color: HIP, letterSpacing: '0.04em' }}>지금 공연 중</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 7 }}>
          <span style={{ ...TYPO.h4, fontSize: 20, lineHeight: '22px', fontWeight: 800, color: '#fff' }}>{item.dj}</span>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: GRAY[300], whiteSpace: 'nowrap' }}>{meta.label} · {item.club}</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 5, marginTop: 6 }}>
          <I.Pin size={11} color={GRAY[400]} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: GRAY[400], fontWeight: 600, whiteSpace: 'nowrap' }}>{item.area} · {item.time} 시작</span>
        </div>
      </div>
      <I.ChevRight size={18} color={HIP} />
    </a>
  );
}

// ============ TYPE FILTER ============
function TypeFilter({ active, onChange, counts }) {
  const tabs = [
    { key: 'all',    label: '전체' },
    { key: 'rapper', label: '래퍼' },
    { key: 'dj',     label: 'DJ' },
  ];
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 16px', marginBottom: 14 }}>
      <div style={{ display: 'flex', gap: 8 }}>
        {tabs.map(t => {
          const sel = t.key === active;
          return (
            <button key={t.key} onClick={() => onChange(t.key)} style={{
              all: 'unset', cursor: 'pointer', height: 34, boxSizing: 'border-box',
              display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 14px', borderRadius: 999,
              background: sel ? HIP : GRAY[900], border: sel ? 'none' : `1px solid ${GRAY[800]}`,
              ...TYPO.button2, fontWeight: sel ? 700 : 500, color: sel ? ON_HIP : GRAY[300], transition: 'all .18s',
            }}>
              {t.label}
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: sel ? ON_HIP : GRAY[500] }}>{counts[t.key]}</span>
            </button>
          );
        })}
      </div>
      <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: GRAY[500], fontWeight: 600 }}>
        <I.Clock size={12} color={GRAY[500]} /> 시간순
      </span>
    </div>
  );
}

// ============ TIMELINE ROW ============
function TimelineRow({ item, isFirst, isLast, nextUpId }) {
  const st = statusOf(item.time);
  const meta = TYPE_META[item.type];
  const isNext = item.id === nextUpId;
  const mins = toMin(item.time) - NOW_MIN;

  const dotColor = st === 'now' ? HIP : st === 'past' ? GRAY[700] : BG;
  const dotBorder = st === 'up' ? `2px solid ${GRAY[600]}` : 'none';
  const timeColor = st === 'now' ? HIP : st === 'past' ? GRAY[600] : GRAY[300];

  const cardStyle = st === 'now'
    ? { background: 'rgba(245,184,46,0.08)', border: `1.5px solid ${HIP}`, boxShadow: '0 6px 24px rgba(245,184,46,0.13)' }
    : { background: 'rgba(255,255,255,0.045)', border: `1px solid ${GRAY[800]}` };

  return (
    <div style={{ display: 'grid', gridTemplateColumns: '46px 24px 1fr', alignItems: 'stretch' }}>
      {/* time */}
      <div style={{ paddingTop: 20, textAlign: 'right', paddingRight: 4 }}>
        <span style={{ ...TYPO.caption, fontSize: 13, lineHeight: '15px', fontWeight: 700, color: timeColor, fontVariantNumeric: 'tabular-nums' }}>{item.time}</span>
      </div>

      {/* rail */}
      <div style={{ position: 'relative' }}>
        {!isFirst && <span style={{ position: 'absolute', left: 11, top: 0, height: 20, width: 2, background: GRAY[800] }} />}
        {!isLast && <span style={{ position: 'absolute', left: 11, top: 32, bottom: 0, width: 2, background: GRAY[800] }} />}
        <span style={{
          position: 'absolute', left: 6, top: 18, width: 12, height: 12, borderRadius: 99,
          background: dotColor, border: dotBorder, boxSizing: 'border-box',
        }} />
        {st === 'now' && <span style={{ position: 'absolute', left: 6, top: 18, width: 12, height: 12, borderRadius: 99, border: `2px solid ${HIP}`, animation: 'ring 1.6s ease-out infinite', pointerEvents: 'none' }} />}
      </div>

      {/* card */}
      <div style={{ paddingBottom: 14 }}>
        <a href="%5Bv1%5DCLUB-021.html" style={{
          display: 'flex', alignItems: 'center', gap: 12, textDecoration: 'none',
          padding: 12, borderRadius: 16, opacity: st === 'past' ? 0.5 : 1, ...cardStyle,
        }}>
          {/* avatar */}
          <div style={{
            width: 46, height: 46, flexShrink: 0, borderRadius: 99, background: item.bg,
            border: st === 'now' ? `2px solid ${HIP}` : `1px solid rgba(255,255,255,0.14)`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <meta.Icon size={20} color="rgba(255,255,255,0.9)" />
          </div>

          {/* info */}
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
              <span style={{ ...TYPO.h4, fontSize: 16, lineHeight: '19px', fontWeight: 700, color: '#fff' }}>{item.dj}</span>
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, padding: '2px 7px', borderRadius: 6, background: meta.bg }}>
                <meta.Icon size={10} color={meta.color} />
                <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: meta.color }}>{meta.label}</span>
              </span>
              {st === 'now' && (
                <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '2px 7px', borderRadius: 6, background: HIP }}>
                  <span style={{ width: 5, height: 5, borderRadius: 99, background: ON_HIP, animation: 'pulse 1.3s ease-in-out infinite' }} />
                  <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 800, color: ON_HIP }}>LIVE</span>
                </span>
              )}
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: 5, marginTop: 6 }}>
              <I.Pin size={11} color={GRAY[400]} />
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[400], fontWeight: 600, whiteSpace: 'nowrap' }}>{item.club} · {item.area}</span>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: 5, marginTop: 8, flexWrap: 'wrap' }}>
              {item.genres.map(g => (
                <span key={g} style={{ ...TYPO.caption, fontSize: 10, lineHeight: '13px', fontWeight: 600, color: GRAY[300], padding: '1px 7px', borderRadius: 6, background: 'rgba(255,255,255,0.09)', whiteSpace: 'nowrap', flexShrink: 0 }}>#{g}</span>
              ))}
              {isNext && (
                <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '13px', fontWeight: 700, color: HIP, padding: '1px 7px', borderRadius: 6, background: 'rgba(245,184,46,0.14)', whiteSpace: 'nowrap', flexShrink: 0 }}>곧 시작 · {mins}분 후</span>
              )}
              {st === 'past' && (
                <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '13px', fontWeight: 700, color: GRAY[500], padding: '1px 7px', borderRadius: 6, background: 'rgba(255,255,255,0.06)', whiteSpace: 'nowrap', flexShrink: 0 }}>공연 종료</span>
              )}
            </div>
          </div>

          <I.ChevRight size={16} color={st === 'now' ? HIP : GRAY[600]} />
        </a>
      </div>
    </div>
  );
}

// ============ SKELETON ============
function Skel({ w, h, r = 6, style }) {
  return (
    <div style={{
      width: w, height: h, borderRadius: r,
      background: `linear-gradient(90deg, ${GRAY[900]} 0%, ${GRAY[700]} 50%, ${GRAY[900]} 100%)`,
      backgroundSize: '200% 100%', animation: 'shimmer 1.4s ease-in-out infinite',
      flexShrink: 0, ...style,
    }} />
  );
}

function TimelineRowSkeleton({ isFirst, isLast }) {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: '46px 24px 1fr', alignItems: 'stretch' }}>
      <div style={{ paddingTop: 20, textAlign: 'right', paddingRight: 4 }}>
        <Skel w={34} h={13} style={{ marginLeft: 'auto' }} />
      </div>
      <div style={{ position: 'relative' }}>
        {!isFirst && <span style={{ position: 'absolute', left: 11, top: 0, height: 20, width: 2, background: GRAY[800] }} />}
        {!isLast && <span style={{ position: 'absolute', left: 11, top: 32, bottom: 0, width: 2, background: GRAY[800] }} />}
        <span style={{ position: 'absolute', left: 6, top: 18, width: 12, height: 12, borderRadius: 99, background: GRAY[700] }} />
      </div>
      <div style={{ paddingBottom: 14 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: 12, borderRadius: 16, background: 'rgba(255,255,255,0.03)', border: `1px solid ${GRAY[800]}` }}>
          <Skel w={46} h={46} r={99} />
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 8 }}>
            <Skel w="46%" h={16} />
            <Skel w="62%" h={12} />
            <div style={{ display: 'flex', gap: 5 }}>
              <Skel w={44} h={16} r={6} />
              <Skel w={38} h={16} r={6} />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function LineupSkeleton() {
  return (
    <div style={{ animation: 'fadeIn .3s ease' }}>
      {/* intro meta */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '16px 20px 12px' }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <Skel w={130} h={24} r={8} />
          <Skel w={180} h={13} />
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: 8 }}>
          <Skel w={44} h={20} r={6} />
          <Skel w={52} h={12} />
        </div>
      </div>

      {/* now banner */}
      <div style={{ margin: '4px 16px 6px', padding: 14, borderRadius: 19, border: `1px solid ${GRAY[800]}`, display: 'flex', alignItems: 'center', gap: 13 }}>
        <Skel w={54} h={54} r={99} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 9 }}>
          <Skel w={90} h={12} />
          <Skel w={150} h={20} r={6} />
          <Skel w={120} h={12} />
        </div>
      </div>

      <div style={{ height: 12 }} />

      {/* filter */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '0 16px', marginBottom: 14 }}>
        <div style={{ display: 'flex', gap: 8 }}>
          <Skel w={60} h={34} r={999} />
          <Skel w={64} h={34} r={999} />
          <Skel w={54} h={34} r={999} />
        </div>
        <Skel w={56} h={14} />
      </div>

      {/* timeline */}
      <div style={{ padding: '0 16px' }}>
        {[0, 1, 2, 3, 4].map(i => <TimelineRowSkeleton key={i} isFirst={i === 0} isLast={i === 4} />)}
      </div>
    </div>
  );
}

// ============ ROOT ============
function App() {
  const [type, setType] = useState('all');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const t = setTimeout(() => setLoading(false), 1600);
    return () => clearTimeout(t);
  }, []);

  const counts = {
    all: LINEUP.length,
    rapper: LINEUP.filter(l => l.type === 'rapper').length,
    dj: LINEUP.filter(l => l.type === 'dj').length,
  };
  const list = type === 'all' ? LINEUP : LINEUP.filter(l => l.type === type);
  const nowItem = LINEUP.find(l => statusOf(l.time) === 'now');
  const nextUp = list.find(l => statusOf(l.time) === 'up');
  const nextUpId = nextUp ? nextUp.id : null;

  return (
    <div style={{ width: '100%', height: '100%', background: BG, position: 'relative', color: '#fff', fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Header />

      <div style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none' }}>
        {loading ? <LineupSkeleton /> : <>
        {/* intro meta */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '16px 20px 12px' }}>
          <div>
            <div style={{ ...TYPO.h3, fontSize: 22, lineHeight: '26px', fontWeight: 800, color: '#fff' }}>7월 3일 <span style={{ color: GRAY[500], fontWeight: 700 }}>(목)</span></div>
            <div style={{ ...TYPO.caption, fontSize: 12, lineHeight: '15px', color: GRAY[500], marginTop: 4 }}>홍대 · 강남 · 압구정 · 이태원 · 건대</div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div style={{ ...TYPO.h4, fontSize: 20, lineHeight: '22px', fontWeight: 800, color: HIP }}>{LINEUP.length}팀</div>
            <div style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: GRAY[500], marginTop: 3 }}>오늘 공연</div>
          </div>
        </div>

        <NowBanner item={nowItem} />

        <div style={{ height: 12 }} />
        <TypeFilter active={type} onChange={setType} counts={counts} />

        {/* timeline */}
        <div key={type} style={{ padding: '0 16px', animation: 'fadeIn .3s ease' }}>
          {list.map((item, i) => (
            <TimelineRow key={item.id} item={item} isFirst={i === 0} isLast={i === list.length - 1} nextUpId={nextUpId} />
          ))}
        </div>

        {list.length === 0 && (
          <div style={{ padding: '50px 24px', textAlign: 'center', ...TYPO.body4, color: GRAY[500] }}>해당하는 공연이 없어요</div>
        )}

        <div style={{ padding: '10px 24px 40px', textAlign: 'center' }}>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: GRAY[600] }}>라인업은 당일 사정에 따라 변경될 수 있어요</span>
        </div>
        </>}
      </div>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <IOSDevice dark={true} width={393} height={852}>
    <App />
  </IOSDevice>
);
