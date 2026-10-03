/* global React, ReactDOM, IOSDevice, TYPO, LIME, PURPLE, FG, FE, FE_AURORA, FE_PAD, FGCard, FGRound, FEI, FeHead, FeMeta, FeOpen, FeFreeBadge, FE_NOW, FE_NOW_MIN, FE_LOC, feMin, FE_TIMED, FE_NEAR, FE_COND, FEMap */
const { useState, useEffect, useRef } = React;

const PAD = FE_PAD; // 좌우 여백 16px 고정
const pad2 = (n) => String(n).padStart(2, '0');
const feHM = (t) => t.replace(/^24:/, '00:');
const RAIL = { display: 'flex', overflowX: 'auto', scrollbarWidth: 'none', scrollSnapType: 'x proximity', WebkitOverflowScrolling: 'touch' };

// ============ HEADER ============
function FeHeader({ solid }) {
  return (
    <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 40, height: 52, padding: `0 ${PAD - 6}px`, display: 'flex', alignItems: 'center', justifyContent: 'space-between', ...(solid ? { ...FG.bar, borderBottom: `1px solid ${FG.hair}` } : { background: 'transparent', borderBottom: '1px solid transparent' }), transition: 'background .22s, border-color .22s' }}>
      <FGRound href="%5Bv1%5DHOME-005.html" size={36}><FEI.Back /></FGRound>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: FG.t1, display: 'flex', alignItems: 'center', gap: 6, opacity: solid ? 1 : 0, transition: 'opacity .22s' }}><FEI.Ticket size={14} /> 입장비 무료</span>
      <FGRound href="%5Bv1%5DHOME-006.html" size={36}><FEI.Search /></FGRound>
    </div>
  );
}

// ============ INTRO ============
function FeIntro({ count }) {
  return (
    <div style={{ padding: `${PAD}px ${PAD}px 26px` }}>
      <span style={{ display: 'inline-flex', alignItems: 'center', gap: 7, padding: '7px 12px', borderRadius: 999, ...FG.tile, ...TYPO.caption, fontSize: 12, fontWeight: 700, color: FG.t1 }}>
        <span style={{ width: 6, height: 6, borderRadius: 99, background: FE.point, display: 'block' }} />무료입장 클럽 추천
      </span>
      <h1 style={{ ...TYPO.h2, fontSize: 28, lineHeight: '36px', fontWeight: 800, letterSpacing: '-0.045em', color: FG.t1, margin: '14px 0 12px', textWrap: 'pretty' }}>
        지금 들어가면<br /><span style={{ color: FE.point }}>입장비 0원</span>인 클럽
      </h1>
      <FeMeta items={[`${FE_LOC} 근처 ${count}곳`, `오늘 ${FE_NOW} 기준`]} size={12.5} color={FG.t4} />
    </div>
  );
}

// ============ 1섹션 · 지금 이 시간만 무료 ============
function FeCountdown({ start, end, tick }) {
  const s0 = feMin(start), s1 = feMin(end);
  const left = Math.max(0, (s1 - FE_NOW_MIN) * 60 - tick);
  const h = Math.floor(left / 3600), m = Math.floor((left % 3600) / 60), s = left % 60;
  const digits = h > 0 ? `${h}:${pad2(m)}:${pad2(s)}` : `${pad2(m)}:${pad2(s)}`;
  const prog = Math.min(1, Math.max(0, ((FE_NOW_MIN * 60 + tick) - s0 * 60) / ((s1 - s0) * 60)));
  const urgent = left < 3600;
  return (
    <div style={{ padding: '11px 13px 12px', borderRadius: 12, ...FG.tile, ...(urgent ? { background: FE.pointSoft, border: `1px solid ${FE.pointLine}` } : {}) }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8 }}>
        <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5 }}>
          <FEI.Clock size={11} color={urgent ? FE.point : 'rgba(255,255,255,0.6)'} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: urgent ? FE.point : FG.t3 }}>무료 마감까지</span>
        </span>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: FG.t4 }}>{feHM(end)} 종료</span>
      </div>
      <div style={{ marginTop: 8, fontSize: 34, lineHeight: '34px', fontWeight: 700, letterSpacing: '-0.035em', color: urgent ? FE.point : FG.t1, fontVariantNumeric: 'tabular-nums' }}>{digits}</div>
      <div style={{ marginTop: 10, height: 4, borderRadius: 99, background: 'rgba(255,255,255,0.10)', overflow: 'hidden' }}>
        <div style={{ width: `${prog * 100}%`, height: '100%', borderRadius: 99, background: `linear-gradient(90deg, ${PURPLE[500]}, ${FE.point})`, transition: 'width 1s linear' }} />
      </div>
    </div>
  );
}

function FeTimedCard({ club, tick }) {
  return (
    <FGCard as="a" href="%5Bv1%5DCLUB-021.html" radius={19} style={{ width: 258, flexShrink: 0, scrollSnapAlign: 'start' }}>
      <div style={{ position: 'relative', height: 128, background: club.bg }}>
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 70% at 70% 12%, rgba(255,255,255,0.2), transparent 55%)' }} />
        <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(14,13,18,0.94) 14%, rgba(14,13,18,0.22) 58%, transparent 82%)' }} />
        <div style={{ position: 'absolute', left: 12, top: 12 }}><FeFreeBadge /></div>
        <span style={{ position: 'absolute', right: 12, top: 12, display: 'inline-flex', alignItems: 'center', gap: 4, height: 24, padding: '0 9px', borderRadius: 99, ...FG.bar, border: `1px solid ${FG.hair}` }}>
          <FEI.Star size={11} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: FG.t1 }}>{club.rating.toFixed(2)}</span>
        </span>
        <div style={{ position: 'absolute', left: 13, right: 13, bottom: 12, display: 'flex', flexDirection: 'column', gap: 6 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 7, minWidth: 0 }}>
            <span style={{ ...TYPO.h4, fontSize: 18, lineHeight: '20px', fontWeight: 700, color: FG.t1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{club.name}</span>
            <FeOpen open={club.open} />
          </div>
          <FeMeta items={[`${club.area} · ${club.dist.toFixed(1)}km`, club.genre]} size={11.5} />
        </div>
      </div>
      <div style={{ padding: 11 }}><FeCountdown start={club.start} end={club.end} tick={tick} /></div>
    </FGCard>
  );
}

function FeTimedSection({ tick }) {
  return (
    <div>
      <FeHead title="지금 이 시간만 무료" sub={`${FE_TIMED.length}곳 · 시간 지나면 입장료가 붙어요`} />
      <div style={{ ...RAIL, gap: 11, padding: `2px ${PAD}px` }}>
        {FE_TIMED.map(c => <FeTimedCard key={c.id} club={c} tick={tick} />)}
      </div>
    </div>
  );
}

// ============ 2섹션 · 내 주변 무료입장 (지도 + 가로 카드) ============
function FeRailCard({ club, on, onSel }) {
  return (
    <FGCard quiet={!on} radius={19} onClick={() => onSel(club.id)} style={{ flex: '0 0 200px', cursor: 'pointer', scrollSnapAlign: 'start', ...(on ? { border: `1px solid ${FE.pointLine}`, background: 'rgba(181,255,96,0.09)' } : {}), transition: 'background .18s, border-color .18s' }}>
      <div style={{ position: 'relative', height: 96, background: club.bg }}>
        <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(14,13,18,0.9) 12%, rgba(14,13,18,0.14) 62%, transparent 86%)' }} />
        <div style={{ position: 'absolute', left: 10, top: 10 }}><FeFreeBadge label="무료" strong={false} /></div>
        {on && (
          <span style={{ position: 'absolute', right: 10, top: 10, width: 22, height: 22, borderRadius: 99, background: FE.point, display: 'grid', placeItems: 'center' }}>
            <FEI.Check size={12} color={FE.onPoint} w={3.6} />
          </span>
        )}
        <div style={{ position: 'absolute', left: 11, right: 11, bottom: 10, display: 'flex', alignItems: 'center', gap: 6, minWidth: 0 }}>
          <span style={{ ...TYPO.button1, fontSize: 15, fontWeight: 700, color: FG.t1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{club.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, flexShrink: 0 }}><FEI.Star size={10} /><span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '11px', fontWeight: 700, color: FG.t1 }}>{club.rating.toFixed(2)}</span></span>
        </div>
      </div>
      <div style={{ padding: '10px 12px 12px', display: 'flex', flexDirection: 'column', gap: 7 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
          <FEI.Walk size={11} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: FG.t3, fontWeight: 600 }}>{club.area} · 걸어서 {club.walk}분</span>
        </div>
        <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, alignSelf: 'flex-start', maxWidth: '100%', padding: '4px 9px 4px 7px', borderRadius: 8, background: FE.pointSoft, border: `1px solid ${FE.pointLine}` }}>
          <FEI.Ticket size={11} color={FE.point} />
          <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '13px', fontWeight: 700, color: FE.point, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{club.tag}</span>
        </span>
      </div>
    </FGCard>
  );
}

function FeMapSection() {
  const [sel, setSel] = useState(FE_NEAR[0].id);
  const rail = useRef(null), items = useRef({});
  useEffect(() => {
    const el = items.current[sel], r = rail.current;
    if (el && r) r.scrollTo({ left: Math.max(0, el.offsetLeft - PAD), behavior: 'smooth' });
  }, [sel]);
  return (
    <div>
      <FeHead
        title="내 주변 무료입장"
        sub={`내 위치 · ${FE_LOC} 반경 2km · ${FE_NEAR.length}곳`}
        right={<a href="%5Bv1%5DPLACE-019.html" style={{ all: 'unset', cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 5, flexShrink: 0, height: 32, padding: '0 12px', borderRadius: 999, ...FG.tile }}>
          <FEI.Expand size={13} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: FG.t1, fontWeight: 700 }}>전체 지도</span>
        </a>}
      />
      <div style={{ margin: `0 ${PAD}px` }}><FEMap list={FE_NEAR} sel={sel} onSel={setSel} /></div>
      <div ref={rail} style={{ ...RAIL, gap: 10, padding: `12px ${PAD}px 2px` }}>
        {FE_NEAR.map(c => (
          <div key={c.id} ref={el => { items.current[c.id] = el; }} style={{ display: 'flex', flexShrink: 0 }}>
            <FeRailCard club={c} on={c.id === sel} onSel={setSel} />
          </div>
        ))}
      </div>
    </div>
  );
}

// ============ 3섹션 · 조건부 무료입장 ============
function FeCondCard({ club }) {
  return (
    <FGCard as="a" href="%5Bv1%5DCLUB-021.html" quiet radius={19} style={{ width: 250, flexShrink: 0, scrollSnapAlign: 'start', display: 'flex', flexDirection: 'column' }}>
      <div style={{ display: 'flex', gap: 11, padding: '13px 13px 11px', alignItems: 'center' }}>
        <div style={{ width: 46, height: 46, borderRadius: 12, flexShrink: 0, background: club.bg, border: `1px solid ${FG.hair}` }} />
        <div style={{ minWidth: 0, flex: 1, display: 'flex', flexDirection: 'column', gap: 6 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, minWidth: 0 }}>
            <span style={{ ...TYPO.button1, fontSize: 15, fontWeight: 700, color: FG.t1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{club.name}</span>
            <FeOpen open={club.open} />
          </div>
          <FeMeta items={[`${club.area} · ${club.dist.toFixed(1)}km`, club.genre, club.rating.toFixed(2)]} size={11} />
        </div>
      </div>
      <div style={{ flex: 1, margin: `0 13px 13px`, padding: '11px 12px', borderRadius: 12, background: FE.baseSoft, border: `1px solid ${FE.baseLine}`, display: 'flex', flexDirection: 'column', gap: 8 }}>
        <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '11px', fontWeight: 700, color: '#C8A8FF' }}>이 조건이면 입장비 무료</span>
        {club.conds.map((t, i) => (
          <div key={i} style={{ display: 'flex', gap: 7, alignItems: 'flex-start' }}>
            <span style={{ flexShrink: 0, marginTop: 3, display: 'block' }}><FEI.Check size={12} /></span>
            <span style={{ ...TYPO.body4, fontSize: 12, lineHeight: '17px', color: FG.t2, textWrap: 'pretty' }}>{t}</span>
          </div>
        ))}
      </div>
    </FGCard>
  );
}

function FeCondSection() {
  return (
    <div>
      <FeHead title="조건이 맞으면 무료" sub={`${FE_COND.length}곳 · 클럽마다 조건이 달라요`} />
      <div style={{ ...RAIL, gap: 10, padding: `2px ${PAD}px`, alignItems: 'stretch' }}>
        {FE_COND.map(c => <FeCondCard key={c.id} club={c} />)}
      </div>
    </div>
  );
}

// ============ TAB BAR ============
function FeTabBar() {
  const tabs = [
    { key: 'home', label: '홈', Icon: FEI.HomeTab, href: '%5Bv1%5DHOME-005.html', active: true },
    { key: 'near', label: '주변', Icon: FEI.AroundTab, href: '%5Bv1%5DPLACE-019.html' },
    { key: 'search', label: '검색', Icon: FEI.SearchTab, href: '%5Bv1%5DHOME-006.html' },
    { key: 'saved', label: '찜', Icon: FEI.SavedTab, href: '%5Bv1%5DPLACE-020.html' },
    { key: 'me', label: '내 정보', Icon: FEI.MeTab, href: '%5Bv1%5DMY-029.html' },
  ];
  return (
    <div style={{ borderTop: `1px solid ${FG.hair}`, ...FG.bar, padding: '12px 24px 24px', display: 'flex', justifyContent: 'space-between', flexShrink: 0, position: 'relative', zIndex: 30 }}>
      {tabs.map(t => {
        const Icon = t.Icon;
        return (
          <a key={t.key} href={t.href} style={{ textDecoration: 'none', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, minWidth: 44 }}>
            <div style={{ width: 4, height: 4, borderRadius: 99, background: t.active ? LIME[500] : 'transparent', marginBottom: 2 }} />
            <Icon active={!!t.active} />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: t.active ? LIME[500] : FG.t2, fontWeight: t.active ? 600 : 400 }}>{t.label}</span>
          </a>
        );
      })}
    </div>
  );
}

// ============ SKELETON ============
function FeSkel({ w = '100%', h = 12, r = 8, style }) {
  return <div style={{ width: w, height: h, borderRadius: r, flexShrink: 0, background: 'linear-gradient(90deg, rgba(255,255,255,0.05) 0px, rgba(255,255,255,0.11) 80px, rgba(255,255,255,0.05) 160px)', backgroundSize: '360px 100%', animation: 'shimmer 1.3s ease-in-out infinite', ...style }} />;
}
function FeSkeleton() {
  return (
    <div style={{ padding: `${PAD}px ${PAD}px 0`, animation: 'fadeIn .2s ease' }}>
      <FeSkel w={132} h={30} r={99} />
      <div style={{ display: 'flex', flexDirection: 'column', gap: 11, padding: '16px 0 26px' }}>
        <FeSkel w="72%" h={28} /><FeSkel w="46%" h={28} /><FeSkel w={172} h={14} style={{ marginTop: 4 }} />
      </div>
      <FeSkel w={188} h={20} style={{ marginBottom: 16 }} />
      <div style={{ display: 'flex', gap: 11 }}>
        {[0, 1].map(i => <FeSkel key={i} w={258} h={250} r={19} />)}
      </div>
      <FeSkel w={150} h={20} style={{ margin: '34px 0 16px' }} />
      <FeSkel h={260} r={19} />
    </div>
  );
}

// ============ ROOT ============
function App() {
  const [loading, setLoading] = useState(true);
  const [solid, setSolid] = useState(false);
  const [tick, setTick] = useState(0);

  useEffect(() => { const t = setTimeout(() => setLoading(false), 1000); return () => clearTimeout(t); }, []);
  useEffect(() => { const i = setInterval(() => setTick(x => x + 1), 1000); return () => clearInterval(i); }, []);

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', background: FG.ink, color: FG.t1, fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <FeHeader solid={solid} />
      <div onScroll={e => setSolid(e.target.scrollTop > 40)} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', position: 'relative', background: FE_AURORA }}>
        <div style={{ paddingTop: 52 }}>
          {loading ? <FeSkeleton /> : (
            <div style={{ animation: 'fadeIn .3s ease' }}>
              <FeIntro count={FE_TIMED.length + FE_NEAR.filter(c => c.open).length} />
              <FeTimedSection tick={tick} />
              <div style={{ height: 44 }} />
              <FeMapSection />
              <div style={{ height: 44 }} />
              <FeCondSection />
              <div style={{ height: 34 }} />
            </div>
          )}
        </div>
      </div>
      <FeTabBar />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <IOSDevice dark={true} width={393} height={852}><App /></IOSDevice>
);
