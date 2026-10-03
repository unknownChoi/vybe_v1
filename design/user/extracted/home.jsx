/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, PURPLE, LIME, RED */
const { useState, useRef } = React;

// ============================================================
// VYBE Design System 준수 (design_system.html)
// Glass Token · Radius · Typography · Spacing 전부 명세값 사용
// ============================================================
const G = {
  cardFill: 'rgba(120,120,128,.16)', cardBorder: 'rgba(255,255,255,.10)',
  tileFill: 'rgba(255,255,255,.07)', tileBorder: 'rgba(255,255,255,.12)',
  quietFill: 'rgba(120,120,128,.08)', quietBorder: 'rgba(255,255,255,.06)',
  barFill: 'rgba(14,13,18,.55)', hair: 'rgba(255,255,255,.09)',
  hiStrong: 'rgba(255,255,255,.18)', hiQuiet: 'rgba(255,255,255,.08)',
  t1: '#fff', t2: 'rgba(255,255,255,.82)', t3: 'rgba(255,255,255,.68)', t4: GRAY[500],
  lavender: '#C8A8FF',
  shadow: '0 10px 30px rgba(0,0,0,.36)',
  blurCard: 'blur(18px)', blurQuiet: 'blur(14px)',
};
// Radius — 6 스켈레톤 / 10 내부 / 12 버튼 / 14 바 / 19 글래스 / 999 pill
const R = { skel: 6, inner: 10, btn: 12, bar: 14, glass: 19, pill: 999 };

// ── 리퀴드 글래스 표면 ──────────────────────────────────────
// 명세의 fill/border/blur 위에 (1) 대각 스페큘러 (2) 상단 1px 하이라이트
// (3) 하단 리플렉션 라인 (4) elevated 그림자를 얹어 유리판처럼 띄운다.
const SURF = {
  card:  { fill: G.cardFill,  bd: G.cardBorder,  blur: 18, hi: G.hiStrong, sh: '0 10px 30px rgba(0,0,0,.36)' },
  quiet: { fill: G.quietFill, bd: G.quietBorder, blur: 14, hi: G.hiQuiet,  sh: '0 8px 24px rgba(0,0,0,.26)' },
  tile:  { fill: G.tileFill,  bd: G.tileBorder,  blur: 18, hi: G.hiStrong, sh: '0 6px 18px rgba(0,0,0,.28)' },
  bar:   { fill: G.barFill,   bd: G.hair,        blur: 18, hi: G.hiQuiet,  sh: null },
};
function glass(v = 'card', radius = R.glass) {
  const m = SURF[v];
  const sheen = 'linear-gradient(158deg, rgba(255,255,255,.11) 0%, rgba(255,255,255,.035) 44%, rgba(255,255,255,0) 60%)';
  const inset = `inset 0 1px 0 ${m.hi}, inset 0 -1px 0 rgba(255,255,255,.05)`;
  return {
    boxSizing: 'border-box', borderRadius: radius,
    background: `${sheen}, ${m.fill}`,
    border: `1px solid ${m.bd}`,
    backdropFilter: `blur(${m.blur}px) saturate(150%)`,
    WebkitBackdropFilter: `blur(${m.blur}px) saturate(150%)`,
    boxShadow: m.sh ? `${m.sh}, ${inset}` : inset,
  };
}
// 유리 위 광원 — 좌상단 스페큘러 + 우하단 브랜드 반사
const Spec = ({ radius = R.glass, drift }) => (
  <span style={{ position: 'absolute', inset: 0, borderRadius: radius, overflow: 'hidden', pointerEvents: 'none' }}>
    <span style={{ position: 'absolute', top: -54, left: -34, width: 190, height: 130,
      background: 'radial-gradient(closest-side, rgba(255,255,255,.20), transparent)',
      animation: drift ? 'glassDrift 9s ease-in-out infinite' : 'none' }} />
    <span style={{ position: 'absolute', bottom: -70, right: -46, width: 210, height: 150,
      background: 'radial-gradient(closest-side, rgba(181,255,96,.10), transparent)' }} />
  </span>
);
// Spacing — 4px 그리드, pagePaddingH 24 · pagePaddingV 20
const PAD = 24;

// ============ ICONS ============
const I = {
  Bell: (p) => (<svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" {...p}>
    <path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9" /><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0" />
  </svg>),
  Search: (p) => (<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" {...p}>
    <circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" />
  </svg>),
  Pin: ({ size = 16, color = 'currentColor' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z" /><circle cx="12" cy="10" r="2.6" />
  </svg>),
  ChevDown: ({ size = 15, color = 'currentColor' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="6 9 12 15 18 9" />
  </svg>),
  ChevRight: ({ size = 13, color = 'currentColor' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="9 18 15 12 9 6" />
  </svg>),
  Star: ({ size = 11, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round">
    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
  </svg>),
  Clock: ({ size = 11, color = 'currentColor' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="12" cy="12" r="9" /><polyline points="12 7 12 12 15.5 14" />
  </svg>),
  HomeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : 'currentColor'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" />
  </svg>),
  AroundTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : 'currentColor'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" />
  </svg>),
  SavedTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : 'currentColor'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
  </svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : 'currentColor'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" />
  </svg>),
  MeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : 'currentColor'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" />
  </svg>),
};

// ============ DS 공용 조각 ============
// GlassCircleTile — 38px 원형 글래스 타일 (헤더 아이콘 버튼)
function Tile({ href, children, badge }) {
  return (
    <a href={href} style={{
      all: 'unset', boxSizing: 'border-box', cursor: 'pointer', position: 'relative',
      width: 38, height: 38, display: 'grid', placeItems: 'center', overflow: 'hidden',
      ...glass('tile', R.pill), color: G.t2,
    }}>
      <Spec radius={R.pill} />
      <span style={{ position: 'relative', display: 'grid', placeItems: 'center' }}>{children}</span>
      {badge && <span style={{ position: 'absolute', top: 6, right: 6, width: 7, height: 7, borderRadius: R.pill, background: PURPLE[500], border: '2px solid #101013' }} />}
    </a>
  );
}
// VybeRecommendBadge — 앱 전역 단일 디자인 (색·문구 고정)
const RecBadge = () => (
  <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, padding: '3px 8px', borderRadius: R.pill,
    background: 'linear-gradient(158deg, rgba(255,255,255,.18), rgba(255,255,255,0) 58%), rgba(181,255,96,.14)',
    border: '1px solid rgba(181,255,96,.28)', color: LIME[500],
    backdropFilter: 'blur(14px)', WebkitBackdropFilter: 'blur(14px)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,.18)',
    font: '600 11px/14px Pretendard, sans-serif', letterSpacing: '-0.27px' }}>
    <span style={{ fontSize: 8, lineHeight: '14px' }}>◆</span>VYBE 추천
  </span>
);

// OpenStatusPill 계열 — tone별 tint pill + dot
const TONE = {
  lime: { c: LIME[500], bg: 'rgba(181,255,96,.14)', bd: 'rgba(181,255,96,.30)' },
  red: { c: RED[500], bg: 'rgba(255,92,95,.13)', bd: 'rgba(255,92,95,.28)' },
  amber: { c: '#FFD166', bg: 'rgba(255,209,102,.14)', bd: 'rgba(255,209,102,.28)' },
  quiet: { c: G.t2, bg: G.tileFill, bd: G.tileBorder },
};
function Pill({ tone = 'quiet', dot, live, children, style }) {
  const t = TONE[tone];
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 10px', borderRadius: R.pill,
      background: `linear-gradient(158deg, rgba(255,255,255,.16), rgba(255,255,255,0) 58%), ${t.bg}`,
      border: `1px solid ${t.bd}`, color: t.c, font: '600 11px/1 Pretendard, sans-serif', letterSpacing: '-0.27px',
      backdropFilter: 'blur(14px) saturate(150%)', WebkitBackdropFilter: 'blur(14px) saturate(150%)',
      boxShadow: 'inset 0 1px 0 rgba(255,255,255,.18)', ...style }}>
      {dot && <span style={{ width: 5, height: 5, borderRadius: R.pill, background: 'currentColor', animation: live ? 'livePulse 1.4s ease-in-out infinite' : 'none' }} />}
      {children}
    </span>
  );
}

// VybeMetaDot — 메타 사이 3px 구분점
const MDot = () => <span style={{ width: 3, height: 3, borderRadius: R.pill, background: GRAY[600], flexShrink: 0 }} />;

// VybeFadeInUp — 6px ↑ + 페이드, index × 45ms
const FadeUp = ({ i = 0, children, style }) => (
  <div style={{ animation: `fadeUp6 .28s ease both`, animationDelay: `${i * 45}ms`, ...style }}>{children}</div>
);

// 섹션 헤드 — heading4(600/20/22) + caption + 전체보기
function SecHead({ title, sub, href }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12, padding: `0 ${PAD}px 16px` }}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 2, minWidth: 0 }}>
        <h3 style={{ ...TYPO.h4, color: G.t1, margin: 0 }}>{title}</h3>
        {sub && <span style={{ ...TYPO.caption, lineHeight: '16px', color: G.t4 }}>{sub}</span>}
      </div>
      {href && (
        <a href={href} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, display: 'inline-flex', alignItems: 'center', gap: 3, color: G.lavender }}>
          <span style={{ ...TYPO.button2, fontSize: 13 }}>전체보기</span>
          <I.ChevRight />
        </a>
      )}
    </div>
  );
}

// ============ TOP BAR ============
function TopBar({ scrolled }) {
  return (
    <div style={{
      position: 'sticky', top: 0, zIndex: 20,
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: `50px ${PAD - 4}px 12px`,
      background: scrolled
        ? `linear-gradient(180deg, rgba(255,255,255,.07), rgba(255,255,255,0) 70%), rgba(14,13,18,.62)`
        : 'transparent',
      backdropFilter: scrolled ? 'blur(20px) saturate(160%)' : 'none', WebkitBackdropFilter: scrolled ? 'blur(20px) saturate(160%)' : 'none',
      borderBottom: `1px solid ${scrolled ? G.hair : 'transparent'}`,
      boxShadow: scrolled ? 'inset 0 1px 0 rgba(255,255,255,.10), 0 10px 30px rgba(0,0,0,.30)' : 'none',
      transition: 'background .2s, border-color .2s, box-shadow .2s',
    }}>
      <img src="assets/vybe-logo.png" alt="vybe" height={21} style={{ display: 'block', marginLeft: 4 }} />
      <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
        <Tile href="%5Bv1%5DHOME-006.html"><I.Search /></Tile>
        <Tile href="%5Bv1%5DHOME-007.html" badge><I.Bell /></Tile>
      </div>
    </div>
  );
}

// ============ LOCATION + GREETING ============
function LocationGreeting() {
  return (
    <div style={{ padding: `4px ${PAD}px 20px`, display: 'flex', flexDirection: 'column', gap: 16 }}>
      <a href="%5Bv1%5DPLACE-019.html" style={{
        all: 'unset', cursor: 'pointer', alignSelf: 'flex-start', position: 'relative', overflow: 'hidden',
        display: 'inline-flex', alignItems: 'center', gap: 6, padding: '7px 13px', ...glass('tile', R.pill),
      }}>
        <Spec radius={R.pill} />
        <I.Pin size={14} color={LIME[500]} />
        <span style={{ ...TYPO.body4, fontWeight: 500, color: G.t2 }}>강남구 역삼동</span>
        <I.ChevDown size={14} color={G.t4} />
      </a>
      <h1 style={{ ...TYPO.h2, color: G.t1, margin: 0 }}>
        오늘 밤, 길동님은<br />어디서 <span style={{ color: LIME[500] }}>놀까요?</span>
      </h1>
    </div>
  );
}

// ============ HERO BANNER ============
const HEROES = [
  { tag: '# 오늘의 핫플', title: '나만 알고 싶은\n히든 플레이스', sub: '요즘 가장 핫한 홍대 클럽', bg: 'linear-gradient(135deg, #2b1655 0%, #7731FE 55%, #ff4d8d 100%)' },
  { tag: '# 이번주 라인업', title: '주말이 짧게\n느껴진다면', sub: '강남·홍대 위켄드 가이드', bg: 'linear-gradient(135deg, #0f0f23 0%, #2B6BFF 60%, #7731FE 100%)' },
  { tag: '# 신규 오픈', title: '이번주 새로 문 연\n3곳의 라운지', sub: '지금 가야 자리 잡아요', bg: 'linear-gradient(135deg, #1a0b3d 0%, #6622cc 55%, #B5FF60 135%)' },
  { tag: '# 무료 입장', title: '오늘 밤은\n공짜로 입장', sub: '입장료 0원 클럽 모음', bg: 'linear-gradient(135deg, #0a0a1f 0%, #1b9aaa 45%, #B5FF60 120%)' },
];

function Hero() {
  const [idx, setIdx] = useState(0);
  const ref = useRef(null);
  const onScroll = () => { const el = ref.current; if (el) setIdx(Math.round(el.scrollLeft / el.clientWidth)); };
  return (
    <div style={{ position: 'relative', padding: `0 ${PAD}px` }}>
      <div ref={ref} onScroll={onScroll} style={{
        display: 'flex', gap: 12, overflowX: 'auto', scrollSnapType: 'x mandatory', scrollbarWidth: 'none',
        margin: `0 -${PAD}px`, padding: `0 ${PAD}px`,
      }}>
        {HEROES.map((h, i) => (
          <div key={i} style={{
            flex: '0 0 calc(100% - 36px)', height: 200, borderRadius: R.glass, overflow: 'hidden',
            background: h.bg, scrollSnapAlign: 'center', position: 'relative',
            border: `1px solid ${G.cardBorder}`, boxShadow: `${G.shadow}, inset 0 1px 0 ${G.hiStrong}, inset 0 -1px 0 rgba(255,255,255,.06)`,
          }}>
            <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(158deg, rgba(255,255,255,.16) 0%, rgba(255,255,255,.03) 42%, rgba(255,255,255,0) 58%)' }} />
            <Spec drift />
            <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(180deg, transparent 26%, rgba(14,13,18,.80) 100%)' }} />
            <div style={{ position: 'absolute', left: 20, top: 20, right: 84, display: 'flex', flexDirection: 'column', gap: 10, alignItems: 'flex-start' }}>
              <span style={{ display: 'inline-flex', padding: '5px 11px', borderRadius: R.pill,
                background: 'linear-gradient(158deg, rgba(255,255,255,.20), rgba(255,255,255,0) 60%), rgba(14,13,18,.42)',
                border: `1px solid ${G.tileBorder}`, backdropFilter: 'blur(14px) saturate(150%)', WebkitBackdropFilter: 'blur(14px) saturate(150%)',
                boxShadow: 'inset 0 1px 0 rgba(255,255,255,.20)',
                ...TYPO.button2, fontSize: 12, lineHeight: '14px', fontWeight: 700, color: LIME[500] }}>{h.tag}</span>
              <h2 style={{ ...TYPO.h3, color: G.t1, margin: 0, whiteSpace: 'pre-line', textShadow: '0 2px 14px rgba(0,0,0,.45)' }}>{h.title}</h2>
            </div>
            <span style={{ position: 'absolute', left: 20, bottom: 18, ...TYPO.caption, lineHeight: '14px', color: G.t3 }}>{h.sub}</span>
          </div>
        ))}
      </div>
      <div style={{ position: 'absolute', right: PAD + 12, bottom: 14, padding: '4px 11px',
        ...glass('bar', R.pill), ...TYPO.caption, lineHeight: '15px', fontWeight: 600, color: G.t2 }}>
        {idx + 1} / {HEROES.length}
      </div>
      <div style={{ display: 'flex', justifyContent: 'center', gap: 4, marginTop: 12 }}>
        {HEROES.map((_, i) => (
          <div key={i} style={{ width: i === idx ? 18 : 5, height: 5, borderRadius: R.pill, background: i === idx ? LIME[500] : GRAY[700], transition: 'all .25s' }} />
        ))}
      </div>
    </div>
  );
}

// ============ CATEGORY GRID ============
const CATS = [
  { key: 'vybe', label: 'VYBE 추천', src: 'assets/icons/lounge.svg', href: '%5Bv1%5DCAT-010.html', signature: true },
  { key: 'hot', label: '핫플레이스', src: 'assets/icons/kpop.svg', href: '%5Bv1%5DCAT-011.html' },
  { key: 'free', label: '입장료 무료', src: 'assets/icons/free_entry.svg', href: '%5Bv1%5DCAT-012.html' },
  { key: 'drink', label: '서비스 음료', src: 'assets/icons/service_drink.svg', href: '%5Bv1%5DCAT-013.html' },
  { key: 'hiphop', label: '힙합', src: 'assets/icons/hiphop.svg' },
  { key: 'edm', label: 'EDM', src: 'assets/icons/edm.svg', href: '%5Bv1%5DCAT-017.html' },
  { key: 'kpop', label: 'K-POP', src: 'assets/icons/hot_place.svg' },
  { key: 'lounge', label: '라운지', src: 'assets/icons/vybe_recommend.svg' },
];

function CategoryGrid() {
  return (
    <div style={{ padding: `24px ${PAD - 8}px 8px` }}>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', rowGap: 16, columnGap: 8 }}>
        {CATS.map((c, i) => {
          const isLink = !!c.href;
          const Tag = isLink ? 'a' : 'button';
          const props = isLink ? { href: c.href } : { onClick: () => {} };
          return (
            <FadeUp key={c.key} i={i}>
              <Tag {...props} style={{ all: 'unset', cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}>
                {/* signature: 2px 그라데이션 테두리 (VybeButton.special 규격) */}
                <div style={{
                  width: 62, height: 62, boxSizing: 'border-box', borderRadius: R.glass, padding: c.signature ? 2 : 0,
                  background: c.signature ? 'linear-gradient(135deg,#B5FF60 0%,#C8E77F 14.2%,#DACA9E 28.5%,#FF9EDB 56.9%,#DD82E4 67.7%,#BB67ED 78.5%,#994CF5 89.2%,#7731FE 100%)' : 'transparent',
                }}>
                  <div style={{
                    width: '100%', height: '100%', position: 'relative', overflow: 'hidden',
                    ...glass('tile', c.signature ? 17 : R.glass),
                    ...(c.signature ? { background: `linear-gradient(158deg, rgba(255,255,255,.20), rgba(255,255,255,0) 55%), ${PURPLE[500]}`, border: 'none' } : null),
                    display: 'grid', placeItems: 'center',
                  }}>
                    <Spec radius={c.signature ? 17 : R.glass} />
                    <img src={c.src} alt={c.label} width={32} height={32} style={{ position: 'relative' }} />
                  </div>
                </div>
                <span style={{ ...TYPO.body4, fontSize: 12, lineHeight: '14px', fontWeight: 500, color: G.t3, textAlign: 'center' }}>{c.label}</span>
              </Tag>
            </FadeUp>
          );
        })}
      </div>
    </div>
  );
}

// ============ 클럽 카드 (가로 스크롤 공용) ============
function ClubCard({ c, children, badge }) {
  return (
    <a href={c.href || '#'} onClick={e => !c.href && e.preventDefault()} style={{
      flex: '0 0 250px', textDecoration: 'none', position: 'relative', height: 156,
      borderRadius: R.glass, overflow: 'hidden', background: c.bg,
      border: `1px solid ${G.cardBorder}`,
      boxShadow: `${G.shadow}, inset 0 1px 0 ${G.hiStrong}, inset 0 -1px 0 rgba(255,255,255,.06)`,
    }}>
      <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(158deg, rgba(255,255,255,.15) 0%, rgba(255,255,255,.03) 40%, rgba(255,255,255,0) 56%)' }} />
      <Spec />
      <div style={{ position: 'absolute', top: 12, left: 12, right: 12, display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 8 }}>{badge}</div>
      {/* 하단 정보는 카드 이미지를 그대로 블러하는 유리판 위에 */}
      <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, padding: '11px 14px 13px',
        display: 'flex', flexDirection: 'column', gap: 5,
        background: 'linear-gradient(180deg, rgba(14,13,18,.28), rgba(14,13,18,.66))',
        backdropFilter: 'blur(16px) saturate(150%)', WebkitBackdropFilter: 'blur(16px) saturate(150%)',
        borderTop: `1px solid ${G.hair}`, boxShadow: 'inset 0 1px 0 rgba(255,255,255,.12)' }}>{children}</div>
    </a>
  );
}
function CardMeta({ c }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 6, ...TYPO.body4, fontSize: 12, lineHeight: '14px', color: G.t3 }}>
      <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}><I.Pin size={11} color={G.t3} /><span>{`${c.dist.toFixed(1)}km`}</span></span>
      <MDot />{c.area}<MDot />{c.genre}
    </div>
  );
}

// ============ NEARBY CLUBS ============
const CROWD = {
  packed: { label: '지금 붐벼요', tone: 'red' },
  busy: { label: '활기참', tone: 'amber' },
  lively: { label: '여유로움', tone: 'lime' },
};

const NEARBY = [
  { name: '어썸레드', area: '홍대', genre: '힙합', rating: 4.8, dist: 0.4, crowd: 'packed', rec: true, bg: 'linear-gradient(135deg, #2b1655, #7731FE 60%, #ff4d8d)', href: '%5Bv1%5DCLUB-021.html' },
  { name: '버뮤다', area: '홍대', genre: '힙합', rating: 4.6, dist: 0.7, crowd: 'busy', bg: 'linear-gradient(135deg, #06ffa5, #3a86ff)' },
  { name: '인클', area: '홍대', genre: '힙합', rating: 4.7, dist: 0.5, crowd: 'busy', bg: 'linear-gradient(135deg, #fb5607, #ffbe0b)' },
  { name: '케이크샵', area: '이태원', genre: '테크노', rating: 4.66, dist: 6.3, crowd: 'lively', bg: 'linear-gradient(135deg, #06ffa5, #1b9aaa)' },
  { name: '벨로주', area: '홍대', genre: '재즈', rating: 4.51, dist: 0.9, crowd: 'lively', bg: 'linear-gradient(135deg, #6d4c91, #2a2d34)' },
];

function NearbyClubs() {
  return (
    <div style={{ padding: '20px 0 0' }}>
      <SecHead title="주변 클럽" href="%5Bv1%5DPLACE-019.html" />
      <div style={{ display: 'flex', gap: 12, overflowX: 'auto', scrollbarWidth: 'none', padding: `2px ${PAD}px 12px` }}>
        {NEARBY.map((c, i) => {
          const cr = CROWD[c.crowd];
          return (
            <FadeUp key={c.name} i={i} style={{ display: 'flex', flex: '0 0 250px' }}>
              <ClubCard c={c} badge={<>
                <Pill tone={cr.tone} dot live>{cr.label}</Pill>
                <Pill style={{ gap: 3 }}><I.Star />{c.rating.toFixed(1)}</Pill>
              </>}>
                {c.rec && <div><RecBadge /></div>}
                <span style={{ ...TYPO.body3, fontWeight: 600, color: G.t1 }}>{c.name}</span>
                <CardMeta c={c} />
              </ClubCard>
            </FadeUp>
          );
        })}
      </div>
    </div>
  );
}

// ============ 타임 무료입장 ============
// 특정 시간대에만 입장료가 무료인 클럽. 시간창을 tagline(라임)으로 앞세운다.
const FREE_TIME = [
  { name: '어썸레드', area: '홍대', genre: '힙합', dist: 0.4, from: '22:00', to: '23:30', price: 20000, live: true, left: '38분 남음', bg: 'linear-gradient(135deg, #2b1655, #7731FE 60%, #ff4d8d)', href: '%5Bv1%5DCLUB-021.html' },
  { name: '소울트레인', area: '강남', genre: 'K-POP', dist: 1.2, from: '21:00', to: '23:00', price: 25000, live: true, left: '12분 남음', bg: 'linear-gradient(135deg, #3a0ca3, #4361ee)' },
  { name: '케이크샵', area: '이태원', genre: '테크노', dist: 6.3, from: '23:30', to: '01:00', price: 30000, bg: 'linear-gradient(135deg, #06ffa5, #1b9aaa)' },
  { name: '버뮤다', area: '홍대', genre: '힙합', dist: 0.7, from: '00:00', to: '01:30', price: 20000, bg: 'linear-gradient(135deg, #06ffa5, #3a86ff)' },
  { name: '벨로주', area: '홍대', genre: '재즈', dist: 0.9, from: '19:00', to: '20:30', price: 15000, bg: 'linear-gradient(135deg, #6d4c91, #2a2d34)' },
];

function FreeTimeClubs() {
  return (
    <div style={{ padding: '20px 0 0' }}>
      <SecHead title="타임 무료입장" sub="이 시간대에만 입장료 0원" href="%5Bv1%5DCAT-012.html" />
      <div style={{ display: 'flex', gap: 12, overflowX: 'auto', scrollbarWidth: 'none', padding: `2px ${PAD}px 12px` }}>
        {FREE_TIME.map((c, i) => (
          <FadeUp key={c.name} i={i} style={{ display: 'flex', flex: '0 0 250px' }}>
            <ClubCard c={c} badge={<>
              {c.live
                ? <Pill tone="lime" dot live>지금 무료</Pill>
                : <Pill style={{ gap: 4, color: G.t3 }}><I.Clock />{c.from} 오픈</Pill>}
              {c.live && <Pill style={{ background: G.barFill, border: `1px solid ${G.hair}`, color: G.t2 }}>{c.left}</Pill>}
            </>}>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 7 }}>
                <span style={{ ...TYPO.tagline, lineHeight: '16px', color: LIME[500] }}>{c.from}–{c.to}</span>
                <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: G.t4, textDecoration: 'line-through' }}>₩{c.price.toLocaleString()}</span>
              </div>
              <span style={{ ...TYPO.body3, fontWeight: 600, color: G.t1 }}>{c.name}</span>
              <CardMeta c={c} />
            </ClubCard>
          </FadeUp>
        ))}
      </div>
    </div>
  );
}

// ============ 공지사항 ============
// VybeGlassSurface.quiet — 물러난 카드 위 hair 구분 리스트, 상위 3건.
const NOTICE_CATS = {
  notice: { label: '공지', bg: 'rgba(255,255,255,.10)', color: G.t2 },
  update: { label: '업데이트', bg: 'rgba(119,49,254,.22)', color: G.lavender },
  event: { label: '이벤트', bg: 'rgba(181,255,96,.14)', color: LIME[500] },
};

const NOTICES = [
  { cat: 'notice', title: '입장 확정 절차 변경 안내', date: '2026.08.01', isNew: true },
  { cat: 'update', title: 'v2.4 업데이트 — 주변 지도 개편', date: '2026.07.28', isNew: true },
  { cat: 'event', title: '여름 나이트 페스타 — 입장권 30% 할인', date: '2026.07.22' },
];

function NoticeSection() {
  return (
    <div style={{ padding: '20px 0 0' }}>
      <SecHead title="공지사항" href="%5Bv1%5DHOME-008.html" />
      <div style={{ padding: `0 ${PAD}px` }}>
        <div style={{ position: 'relative', overflow: 'hidden', ...glass('quiet') }}>
          <Spec />
          {NOTICES.map((n, i) => {
            const c = NOTICE_CATS[n.cat];
            return (
              <a key={n.title} href="%5Bv1%5DHOME-008.html" style={{
                all: 'unset', cursor: 'pointer', boxSizing: 'border-box', display: 'flex', flexDirection: 'column', gap: 6,
                padding: '14px 16px', borderTop: i ? `1px solid ${G.hair}` : 'none', position: 'relative',
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <span style={{ padding: '2px 7px', borderRadius: R.skel, background: c.bg, color: c.color, font: '600 10.5px/16px Pretendard, sans-serif', letterSpacing: '-0.26px' }}>{c.label}</span>
                  {n.isNew && <span style={{ font: '700 10.5px/16px Pretendard, sans-serif', letterSpacing: '-0.26px', color: LIME[500] }}>NEW</span>}
                  <span style={{ marginLeft: 'auto', ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: G.t4 }}>{n.date}</span>
                </div>
                <span style={{ ...TYPO.body4, fontWeight: 500, color: G.t1, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{n.title}</span>
              </a>
            );
          })}
        </div>
      </div>
    </div>
  );
}

// ============ TAB BAR ============
function TabBar() {
  const tabs = [
    { key: 'home', label: '홈', Icon: I.HomeTab, href: '%5Bv1%5DHOME-005.html', active: true },
    { key: 'near', label: '주변', Icon: I.AroundTab, href: '%5Bv1%5DPLACE-019.html' },
    { key: 'saved', label: '찜', Icon: I.SavedTab, href: '%5Bv1%5DPLACE-020.html' },
    { key: 'search', label: '검색', Icon: I.SearchTab, href: '%5Bv1%5DHOME-006.html' },
    { key: 'me', label: '내 정보', Icon: I.MeTab, href: null },
  ];
  return (
    <div style={{ flexShrink: 0, borderTop: `1px solid ${G.hair}`, background: 'rgba(14,13,18,.92)',
      backdropFilter: G.blurCard, WebkitBackdropFilter: G.blurCard,
      padding: '10px 16px 8px', display: 'flex', justifyContent: 'space-between' }}>
      {tabs.map(t => {
        const Icon = t.Icon;
        return (
          <a key={t.key} href={t.href || '#'} onClick={e => !t.href && e.preventDefault()} style={{
            textDecoration: 'none', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
            minWidth: 54, padding: '6px 0 4px', borderRadius: R.bar, color: G.t2,
            background: t.active ? G.tileFill : 'transparent',
            border: `1px solid ${t.active ? G.tileBorder : 'transparent'}`,
          }}>
            <Icon active={!!t.active} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: t.active ? 600 : 400, color: t.active ? LIME[500] : G.t3 }}>{t.label}</span>
          </a>
        );
      })}
    </div>
  );
}

// ============ SKELETON (VybeShimmerBox) ============
function Skel({ w = '100%', h = 12, r = R.skel, style = {} }) {
  return (
    <div style={{ width: w, height: h, borderRadius: r, flexShrink: 0, background: 'rgba(255,255,255,.07)', border: `1px solid ${G.quietBorder}`, boxSizing: 'border-box', position: 'relative', overflow: 'hidden', ...style }}>
      <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(90deg, transparent, rgba(255,255,255,.14), transparent)', animation: 'dsSweep 1.35s infinite' }} />
    </div>
  );
}
function Skeleton() {
  return (
    <div style={{ animation: 'fadeIn .2s ease' }}>
      <div style={{ padding: `4px ${PAD}px 20px`, display: 'flex', flexDirection: 'column', gap: 16 }}>
        <Skel w={116} h={32} r={R.pill} /><Skel w="70%" h={30} />
      </div>
      <div style={{ padding: `0 ${PAD}px` }}><Skel h={200} r={R.glass} /></div>
      <div style={{ padding: `24px ${PAD}px 0`, display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', rowGap: 16, columnGap: 8 }}>
        {Array.from({ length: 8 }).map((_, i) => (
          <div key={i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8 }}>
            <Skel w={62} h={62} r={R.glass} /><Skel w={44} h={11} />
          </div>
        ))}
      </div>
      <div style={{ padding: `28px ${PAD}px 0`, display: 'flex', gap: 12 }}>
        <Skel w={250} h={156} r={R.glass} /><Skel w={120} h={156} r={R.glass} />
      </div>
    </div>
  );
}

// ============ 네트워크 끊김 스트립 ============
// 헤더 바로 아래 붙는 인라인 스트립. 콘텐츠를 가리지 않고 연결이 돌아올 때까지 남는다.
function OfflineStrip() {
  const forced = new URLSearchParams(window.__VBQ).has('offline');
  const [off, setOff] = useState(forced || !navigator.onLine);
  const [busy, setBusy] = useState(false);

  const down2 = React.useCallback(() => { setBusy(false); setOff(true); }, []);
  const up2 = React.useCallback(() => { setBusy(false); setOff(false); }, []);

  React.useEffect(() => {
    window.addEventListener('offline', down2);
    window.addEventListener('online', up2);
    window.__vybeSetOffline = (v) => (v ? down2() : up2());
    return () => { window.removeEventListener('offline', down2); window.removeEventListener('online', up2); };
  }, [down2, up2]);

  const tryAgain = () => {
    if (busy) return;
    setBusy(true);
    setTimeout(() => { setBusy(false); if (navigator.onLine && !forced) up2(); }, 1400);
  };

  if (!off) return null;
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: `10px ${PAD - 4}px`, margin: '0 0 12px',
      background: 'linear-gradient(158deg, rgba(255,255,255,.10), rgba(255,255,255,0) 55%), rgba(255,92,95,.12)',
      borderTop: '1px solid rgba(255,92,95,.22)', borderBottom: '1px solid rgba(255,92,95,.22)',
      backdropFilter: 'blur(18px) saturate(150%)', WebkitBackdropFilter: 'blur(18px) saturate(150%)',
      boxShadow: 'inset 0 1px 0 rgba(255,255,255,.10)', animation: 'fadeUp6 .26s ease' }}>
      <span style={{ width: 5, height: 5, borderRadius: R.pill, background: RED[500], flexShrink: 0 }} />
      <span style={{ ...TYPO.body4, fontWeight: 500, color: G.t1, flex: 1 }}>네트워크에 연결되지 않았습니다</span>
      <button onClick={tryAgain} style={{ all: 'unset', cursor: 'pointer', ...TYPO.button2, color: LIME[500], display: 'inline-flex', alignItems: 'center', gap: 4 }}>
        {busy
          ? [0, 1, 2].map(i => <span key={i} style={{ width: 4, height: 4, borderRadius: R.pill, background: LIME[500], animation: `netDot .9s ${i * 0.15}s ease-in-out infinite` }} />)
          : '재시도'}
      </button>
    </div>
  );
}

// 개발용 연결 상태 토글
function NetToggle() {
  const [off, setOff] = useState(!navigator.onLine || new URLSearchParams(window.__VBQ).has('offline'));
  const flip = () => { const n = !off; setOff(n); window.__vybeSetOffline && window.__vybeSetOffline(n); };
  return (
    <button onClick={flip} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', position: 'absolute', right: 14, bottom: 22, zIndex: 61,
      display: 'inline-flex', alignItems: 'center', gap: 7, padding: '9px 13px', borderRadius: R.pill,
      background: 'linear-gradient(158deg, rgba(255,255,255,.12), rgba(255,255,255,0) 55%), rgba(26,26,30,.78)',
      border: `1px solid ${off ? RED[500] : G.tileBorder}`,
      boxShadow: '0 10px 30px rgba(0,0,0,.5), inset 0 1px 0 rgba(255,255,255,.16)',
      backdropFilter: 'blur(20px) saturate(160%)', WebkitBackdropFilter: 'blur(20px) saturate(160%)' }}>
      <span style={{ width: 6, height: 6, borderRadius: R.pill, background: off ? RED[500] : LIME[500] }} />
      <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 600, color: G.t1 }}>{off ? '오프라인' : '온라인'}</span>
    </button>
  );
}

// ============ ROOT ============
function App() {
  const [loading, setLoading] = useState(true);
  const [scrolled, setScrolled] = useState(false);
  const AdPopup = window.HomeAdPopup;
  React.useEffect(() => { const t = setTimeout(() => setLoading(false), 1100); return () => clearTimeout(t); }, []);
  const onScroll = (e) => setScrolled(e.target.scrollTop > 12);

  return (
    <div style={{ width: '100%', height: '100%', background: COLORS.bg, color: G.t1, fontFamily: "'Pretendard', sans-serif", letterSpacing: '-0.025em', display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <div onScroll={onScroll} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', position: 'relative',
        background: 'linear-gradient(180deg, #120F1A 0%, #101013 34%, #0E0D12 100%)' }}>
        {/* AmbientBackdrop — 좌상단 보라 0x8A7731FE · 우상단 라임 0x4DB5FF60 · 글로우 높이 420 고정 */}
        <div style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 420, zIndex: 0, pointerEvents: 'none',
          background: [
            'radial-gradient(140% 100% at -5% -12%, rgba(119,49,254,.54) 0%, transparent 78%)',
            'radial-gradient(140% 100% at 105% -8%, rgba(181,255,96,.30) 0%, transparent 80%)',
          ].join(', ') }} />

        <div style={{ position: 'relative', zIndex: 1 }}>
          <TopBar scrolled={scrolled} />
          <OfflineStrip />
          {loading ? <Skeleton /> : (
            <div>
              <LocationGreeting />
              <Hero />
              <CategoryGrid />
              <NearbyClubs />
              <FreeTimeClubs />
              <NoticeSection />
              <div style={{ height: 32 }} />
            </div>
          )}
        </div>
      </div>
      <NetToggle />
      {AdPopup && <AdPopup ready={!loading} />}
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
// ?bare=1 — 기기 프레임 없이 화면만 렌더 (스플래시가 같은 프레임 안에 이어 붙일 때)
if (new URLSearchParams(window.__VBQ).has('bare')) {
  root.render(<div style={{ width: '100%', height: '100%' }}><App /></div>);
} else {
root.render(
  <IOSDevice dark={true} width={393} height={852}>
    <App />
  </IOSDevice>
);
}
