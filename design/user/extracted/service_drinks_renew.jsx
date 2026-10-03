/* global React, ReactDOM, IOSDevice, TYPO, LIME, PURPLE, FG, FGCard, FGRound, FEI, FeHead, FeMeta, FeOpen, FE_PAD, SD, SD_AURORA, SDI, SD_LOC, SD_CLUBS, SD_TYPES, SD_PERKS, sdByType, sdByTier, SD_NEAR, FEMap */
const { useState, useEffect } = React;

const PAD = FE_PAD; // 24
const RAIL = { display: 'flex', overflowX: 'auto', scrollbarWidth: 'none', scrollSnapType: 'x proximity', WebkitOverflowScrolling: 'touch' };

// ============ HEADER ============
function SdHeader({ solid }) {
  return (
    <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 40, height: 52, padding: `0 ${PAD - 6}px`, display: 'flex', alignItems: 'center', justifyContent: 'space-between', ...(solid ? { ...FG.bar, borderBottom: `1px solid ${FG.hair}` } : { background: 'transparent', borderBottom: '1px solid transparent' }), transition: 'background .22s, border-color .22s' }}>
      <FGRound href="%5Bv1%5DHOME-005.html" size={36}><FEI.Back /></FGRound>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: FG.t1, display: 'flex', alignItems: 'center', gap: 6, opacity: solid ? 1 : 0, transition: 'opacity .22s' }}><SDI.Cup size={14} color={SD.point} /> 서비스음료</span>
      <FGRound href="%5Bv1%5DHOME-006.html" size={36}><FEI.Search /></FGRound>
    </div>
  );
}

// ============ INTRO ============
function SdIntro() {
  const open = SD_CLUBS.filter(c => c.open).length;
  return (
    <div style={{ padding: `${PAD}px ${PAD}px 26px` }}>
      <span style={{ display: 'inline-flex', alignItems: 'center', gap: 7, padding: '7px 12px', borderRadius: 999, ...FG.tile, ...TYPO.caption, fontSize: 12, fontWeight: 700, color: FG.t1 }}>
        <span style={{ width: 6, height: 6, borderRadius: 99, background: SD.point, display: 'block' }} />서비스 음료 제공 클럽
      </span>
      <h1 style={{ ...TYPO.h2, fontSize: 28, lineHeight: '36px', fontWeight: 800, letterSpacing: '-0.045em', color: FG.t1, margin: '14px 0 12px', textWrap: 'pretty' }}>
        오늘 <span style={{ color: SD.point }}>공짜로 한 잔</span><br />마실 수 있는 곳
      </h1>
      <FeMeta items={[`${SD_LOC} 근처 ${SD_CLUBS.length}곳`, `지금 영업 중 ${open}곳`]} size={12.5} color={FG.t4} />
    </div>
  );
}

// ============ 공통 · 클럽 카드 (2열 포트레이트) ============
function SdPerkBadge({ perk }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, maxWidth: '100%', padding: '3px 9px 3px 7px', borderRadius: 8, background: SD.soft, border: `1px solid ${SD.line}` }}>
      <SDI.Bottle size={11} color={SD.point} fill />
      <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '13px', fontWeight: 700, color: SD.point, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{perk}</span>
    </span>
  );
}

function SdClubCard({ club, saved, onSave }) {
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{ display: 'block', textDecoration: 'none', position: 'relative', aspectRatio: '3 / 4', borderRadius: 16, overflow: 'hidden', background: club.bg, border: `1px solid ${FG.hair}` }}>
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 70% at 70% 12%, rgba(255,255,255,0.2), transparent 55%)' }} />
      <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(14,13,18,0.95) 16%, rgba(14,13,18,0.2) 56%, transparent 80%)' }} />
      <div style={{ position: 'absolute', top: 11, left: 11, display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 8px', borderRadius: 99, ...FG.bar, border: `1px solid ${club.open ? SD.line : 'rgba(255,255,255,0.14)'}` }}>
        <span style={{ width: 5, height: 5, borderRadius: 99, background: club.open ? SD.point : 'rgba(255,255,255,0.5)' }} />
        <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: club.open ? SD.point : FG.t3 }}>{club.open ? '영업 중' : '종료'}</span>
      </div>
      <div style={{ position: 'absolute', top: 8, right: 8 }}>
        <FGRound size={30} onClick={e => { e.preventDefault(); onSave(club.id); }}><FEI.Heart size={15} active={saved} /></FGRound>
      </div>
      <div style={{ position: 'absolute', left: 12, right: 12, bottom: 12 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginBottom: 5 }}>
          <span style={{ ...TYPO.h4, fontSize: 18, lineHeight: '20px', fontWeight: 700, color: FG.t1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{club.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2, flexShrink: 0 }}>
            <FEI.Star size={11} color={SD.point} /><span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: FG.t1 }}>{club.rating.toFixed(2)}</span>
          </span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <FEI.Walk size={11} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: FG.t3, fontWeight: 600 }}>{club.area} · 걸어서 {club.walk}분</span>
        </div>
        <div style={{ marginTop: 8 }}><SdPerkBadge perk={club.perk} /></div>
      </div>
    </a>
  );
}

// ============ 지도 · 주변 서비스 음료 클럽 ============
function SdMapClubRow({ club, saved, onSave }) {
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{ display: 'flex', alignItems: 'center', gap: 11, textDecoration: 'none', padding: 10, borderRadius: 15, ...FG.tile, animation: 'fadeIn .22s ease' }}>
      <span style={{ width: 52, height: 52, borderRadius: 12, flexShrink: 0, background: club.bg, border: `1px solid ${FG.hair}` }} />
      <span style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 5 }}>
        <span style={{ display: 'flex', alignItems: 'center', gap: 6, minWidth: 0 }}>
          <span style={{ ...TYPO.button1, fontSize: 15, fontWeight: 700, color: FG.t1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{club.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2, flexShrink: 0 }}>
            <FEI.Star size={11} color={SD.point} /><span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: FG.t1 }}>{club.rating.toFixed(2)}</span>
          </span>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, flexShrink: 0, color: club.open ? SD.point : FG.t4 }}>{club.open ? '영업 중' : '종료'}</span>
        </span>
        <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <FEI.Walk size={11} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: FG.t3, fontWeight: 600 }}>{club.area} · {club.dist}km · 걸어서 {club.walk}분</span>
        </span>
        <span style={{ display: 'flex' }}><SdPerkBadge perk={club.perk} /></span>
      </span>
      <span style={{ flexShrink: 0 }}>
        <FGRound size={32} onClick={e => { e.preventDefault(); onSave(club.id); }}><FEI.Heart size={15} active={saved} /></FGRound>
      </span>
    </a>
  );
}

function SdMapSection({ savedSet, onSave }) {
  const [sel, setSel] = useState(SD_NEAR[0].id);
  const club = SD_NEAR.find(c => c.id === sel) || SD_NEAR[0];
  return (
    <div>
      <FeHead title="내 주변 서비스 음료 클럽" sub={`${SD_LOC} 반경 1km · ${SD_NEAR.length}곳`} />
      <div style={{ padding: `0 ${PAD}px`, display: 'flex', flexDirection: 'column', gap: 11 }}>
        <FEMap list={SD_NEAR} sel={sel} onSel={setSel} />
        <div key={club.id}><SdMapClubRow club={club} saved={savedSet.has(club.id)} onSave={onSave} /></div>
      </div>
    </div>
  );
}

// ============ 1섹션 · 음료 종류별로 보기 ============
function SdChipRow({ items, active, onChange }) {
  return (
    <div style={{ display: 'flex', gap: 8, overflowX: 'auto', scrollbarWidth: 'none', padding: `0 ${PAD}px 2px` }}>
      {items.map(t => {
        const sel = t.key === active;
        const Icon = t.Icon;
        return (
          <button key={t.key} onClick={() => onChange(t.key)} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, height: 34, boxSizing: 'border-box', display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 15px 0 12px', borderRadius: 999, ...(sel ? { background: SD.point, border: '1px solid transparent', boxShadow: '0 6px 18px rgba(181,255,96,0.20)' } : FG.tile), ...TYPO.button2, fontWeight: sel ? 700 : 500, color: sel ? SD.onPoint : FG.t2, transition: 'background .18s, color .18s' }}>
            <Icon size={13} color={sel ? SD.onPoint : 'rgba(255,255,255,0.6)'} />
            {t.key}
          </button>
        );
      })}
    </div>
  );
}

function SdTypeSection({ savedSet, onSave }) {
  const [type, setType] = useState('양주');
  const list = sdByType(type);
  return (
    <div>
      <FeHead title="음료 종류별로 무료 클럽 확인" sub={`${type} · ${list.length}곳 · 가까운 순`} />
      <div style={{ marginBottom: 14 }}><SdChipRow items={SD_TYPES} active={type} onChange={setType} /></div>
      {list.length === 0 ? (
        <div style={{ padding: '34px 24px', textAlign: 'center', ...TYPO.body4, color: FG.t4 }}>이 음료를 주는 클럽이 아직 없어요</div>
      ) : (
        <div key={type} style={{ display: 'grid', gridTemplateColumns: 'minmax(0,1fr) minmax(0,1fr)', columnGap: 11, rowGap: 14, padding: `0 ${PAD}px`, animation: 'riseIn .3s ease' }}>
          {list.map(c => <SdClubCard key={c.id} club={c} saved={savedSet.has(c.id)} onSave={onSave} />)}
        </div>
      )}
    </div>
  );
}

// ============ 2섹션 · 혜택별 제공 내용 + 클럽 ============
function SdPerkBlock({ perk, savedSet, onSave }) {
  const Icon = perk.Icon;
  const clubs = sdByTier(perk.key);
  const tone = perk.tone;
  const soft = tone === SD.point ? SD.soft : SD.subSoft;
  const line = tone === SD.point ? SD.line : SD.subLine;
  return (
    <div>
      <div style={{ padding: `0 ${PAD}px`, display: 'flex', alignItems: 'center', gap: 11, marginBottom: 11 }}>
        <span style={{ width: 38, height: 38, borderRadius: 12, flexShrink: 0, display: 'grid', placeItems: 'center', background: soft, border: `1px solid ${line}` }}>
          <Icon size={18} color={tone} />
        </span>
        <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 4 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
            <span style={{ ...TYPO.button1, fontSize: 16, fontWeight: 700, color: FG.t1 }}>{perk.name}</span>
            <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '12px', fontWeight: 700, color: tone, padding: '3px 7px', borderRadius: 99, background: soft, border: `1px solid ${line}` }}>{clubs.length}곳</span>
          </div>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '15px', color: FG.t3 }}>{perk.sum}</span>
        </div>
      </div>

      <div style={{ ...RAIL, gap: 11, padding: `2px ${PAD}px` }}>
        {clubs.map(c => (
          <div key={c.id} style={{ width: 152, flexShrink: 0, scrollSnapAlign: 'start' }}>
            <SdClubCard club={c} saved={savedSet.has(c.id)} onSave={onSave} />
          </div>
        ))}
      </div>
    </div>
  );
}

function SdPerkSection({ savedSet, onSave }) {
  return (
    <div>
      <FeHead title="혜택별로 무엇을 받는지" sub={`무료 혜택 ${SD_PERKS.length}종 · 제공 내용과 해당 클럽`} />
      <div style={{ display: 'flex', flexDirection: 'column', gap: 26 }}>
        {SD_PERKS.map(p => <SdPerkBlock key={p.key} perk={p} savedSet={savedSet} onSave={onSave} />)}
      </div>
    </div>
  );
}

// ============ NOTICE ============
function SdNotice() {
  return (
    <div style={{ margin: `0 ${PAD}px`, padding: '13px 14px', borderRadius: 12, ...FG.quiet, display: 'flex', gap: 9, alignItems: 'flex-start' }}>
      <span style={{ flexShrink: 0, marginTop: 1 }}><SDI.Info size={14} color={SD.point} /></span>
      <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '17px', color: FG.t3, textWrap: 'pretty' }}>서비스 음료는 매장 사정과 입장 시간에 따라 변동될 수 있어요. 방문 전 클럽 상세에서 한 번 더 확인해 주세요.</span>
    </div>
  );
}

// ============ TAB BAR ============
function SdTabBar() {
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
function SdSkel({ w = '100%', h = 12, r = 8, style }) {
  return <div style={{ width: w, height: h, borderRadius: r, flexShrink: 0, background: 'linear-gradient(90deg, rgba(255,255,255,0.05) 0px, rgba(255,255,255,0.11) 80px, rgba(255,255,255,0.05) 160px)', backgroundSize: '360px 100%', animation: 'shimmer 1.3s ease-in-out infinite', ...style }} />;
}
function SdSkeleton() {
  return (
    <div style={{ padding: `${PAD}px ${PAD}px 0`, animation: 'fadeIn .2s ease' }}>
      <SdSkel w={156} h={30} r={99} />
      <div style={{ display: 'flex', flexDirection: 'column', gap: 11, padding: '16px 0 26px' }}>
        <SdSkel w="70%" h={28} /><SdSkel w="52%" h={28} /><SdSkel w={182} h={14} style={{ marginTop: 4 }} />
      </div>
      <SdSkel w={196} h={20} style={{ marginBottom: 16 }} />
      <div style={{ display: 'flex', gap: 8, marginBottom: 18 }}>
        {[72, 84, 84, 76, 76].map((w, i) => <SdSkel key={i} w={w} h={34} r={999} />)}
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 11 }}>
        {[0, 1].map(i => <SdSkel key={i} h={222} r={16} />)}
      </div>
    </div>
  );
}

// ============ ROOT ============
function App() {
  const [loading, setLoading] = useState(true);
  const [solid, setSolid] = useState(false);
  const [savedSet, setSavedSet] = useState(new Set([2]));
  const toggleSave = (id) => setSavedSet(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });
  useEffect(() => { const t = setTimeout(() => setLoading(false), 900); return () => clearTimeout(t); }, []);
  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', background: FG.ink, color: FG.t1, fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <SdHeader solid={solid} />
      <div onScroll={e => setSolid(e.target.scrollTop > 40)} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', position: 'relative', background: SD_AURORA }}>
        <div style={{ paddingTop: 52 }}>
          {loading ? <SdSkeleton /> : (
            <div style={{ animation: 'fadeIn .3s ease' }}>
              <SdIntro />
              <SdMapSection savedSet={savedSet} onSave={toggleSave} />
              <div style={{ height: 44 }} />
              <SdTypeSection savedSet={savedSet} onSave={toggleSave} />
              <div style={{ height: 44 }} />
              <SdPerkSection savedSet={savedSet} onSave={toggleSave} />
              <div style={{ height: 26 }} />
              <SdNotice />
              <div style={{ height: 30 }} />
            </div>
          )}
        </div>
      </div>
      <SdTabBar />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <IOSDevice dark={true} width={393} height={852}><App /></IOSDevice>
);
