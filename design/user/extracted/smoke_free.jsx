/* global React, ReactDOM, IOSDevice, TYPO, LIME, PURPLE, G, SF_AURORA, GCard, GlassRound, SFI, SFSectionHead, SFChipRow, SFMapSection */
const { useState } = React;

const ACC = LIME[500];
const ON_ACC = '#12210a';
const ACC_LINE = 'rgba(181,255,96,0.38)';

const AREAS = ['홍대', '강남', '이태원', '건대', '신촌'];
const GENRES = ['EDM', '힙합', 'K-POP', '하이브리드'];

const CLUBS = [
  { id: 1, name: '클리어', area: '홍대', dist: 0.3, walk: 4, rating: 4.64, reviews: 128, genre: 'EDM', policy: '실내 전 구역 금연', air: 96, pick: true, open: true, x: 46, y: 34, bg: 'linear-gradient(150deg,#1b2a10,#739F41 55%,#B5FF60)' },
  { id: 2, name: '에어', area: '홍대', dist: 0.5, walk: 7, rating: 4.52, reviews: 214, genre: '하이브리드', policy: '흡연 부스 분리', air: 88, pick: true, open: true, x: 62, y: 27, bg: 'linear-gradient(150deg,#2b1655,#7731FE 58%,#B5FF60)' },
  { id: 3, name: '브리드', area: '홍대', dist: 0.6, walk: 8, rating: 4.47, reviews: 96, genre: '힙합', policy: '실내 전 구역 금연', air: 94, pick: false, open: true, x: 30, y: 50, bg: 'linear-gradient(150deg,#241452,#6329d6 60%,#a179ff)' },
  { id: 4, name: '오존', area: '홍대', dist: 0.8, walk: 11, rating: 4.41, reviews: 67, genre: 'K-POP', policy: '테라스만 흡연', air: 81, pick: false, open: true, x: 72, y: 58, bg: 'linear-gradient(150deg,#1b3a3a,#2a9d8f 60%,#B5FF60)' },
  { id: 5, name: '화이트룸', area: '신촌', dist: 1.4, walk: 19, rating: 4.38, reviews: 152, genre: 'EDM', policy: '흡연 부스 분리', air: 86, pick: true, open: true, x: 18, y: 28, bg: 'linear-gradient(150deg,#1a0a26,#4b2093 55%,#B5FF60)' },
  { id: 6, name: '노트', area: '신촌', dist: 1.7, walk: 23, rating: 4.33, reviews: 74, genre: '하이브리드', policy: '실내 전 구역 금연', air: 92, pick: false, open: true, x: 55, y: 70, bg: 'linear-gradient(150deg,#101019,#2a1b52 50%,#b694ff)' },
  { id: 7, name: '민트', area: '강남', dist: 5.1, walk: 62, rating: 4.55, reviews: 186, genre: 'K-POP', policy: '실내 전 구역 금연', air: 95, pick: true, open: true, x: 84, y: 40, bg: 'linear-gradient(150deg,#17102e,#40208c 55%,#8b4dff)' },
  { id: 8, name: '베이스', area: '강남', dist: 5.4, walk: 66, rating: 4.40, reviews: 231, genre: '힙합', policy: '테라스만 흡연', air: 79, pick: false, open: false, x: 38, y: 72, bg: 'linear-gradient(150deg,#2a2410,#b5860b 60%,#ffbe0b)' },
  { id: 9, name: '프레시', area: '이태원', dist: 6.2, walk: 74, rating: 4.31, reviews: 88, genre: 'EDM', policy: '흡연 부스 분리', air: 84, pick: false, open: false, x: 68, y: 30, bg: 'linear-gradient(150deg,#14102b,#35187a 55%,#8a55ff)' },
  { id: 10, name: '스카이', area: '건대', dist: 3.3, walk: 41, rating: 4.27, reviews: 59, genre: '하이브리드', policy: '실내 전 구역 금연', air: 90, pick: false, open: false, x: 24, y: 66, bg: 'linear-gradient(150deg,#1c2a12,#94CF51 62%,#B5FF60)' },
];

const STRONG_POLICY = CLUBS[0].policy; // 실내 전 구역 금연

const BOOTHS = {
  2: { where: '지하 1층 입구 옆 별도 부스', detail: '플로어와 문 두 개로 분리, 부스 전용 환기' },
  5: { where: '2층 라운지 끝 흡연실', detail: '플로어와 층이 달라 연기가 넘어오지 않음' },
  9: { where: '1층 외부 계단 옆 부스', detail: '실내를 거치지 않고 바로 나갈 수 있음' },
};

function Header({ solid }) {
  return (
    <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 40, height: 52, padding: '0 12px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', ...(solid ? { ...G.bar, borderBottom: `1px solid ${G.hair}` } : { background: 'transparent', borderBottom: '1px solid transparent' }), transition: 'background .22s, border-color .22s' }}>
      <GlassRound href="%5Bv1%5DHOME-005.html" size={36}><SFI.Back /></GlassRound>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: G.t1, display: 'flex', alignItems: 'center', gap: 6, opacity: solid ? 1 : 0, transition: 'opacity .22s' }}><SFI.NoSmoke size={15} /> 금연</span>
      <GlassRound size={36}><SFI.Search /></GlassRound>
    </div>
  );
}

/* 히어로 — 금연 배너 7안(아웃라인 타이포형) */
function Hero() {
  return (
    <div style={{ position: 'relative' }}>
      <div style={{ position: 'relative', height: 478, overflow: 'hidden' }}>
        <div style={{ position: 'absolute', inset: 0 }}>
          <image-slot id="sf7" shape="rect" fit="cover" placeholder="클럽 플로어 사진"></image-slot>
        </div>
        <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none', background: 'linear-gradient(180deg,rgba(8,12,6,.56) 0%,rgba(8,12,6,.26) 46%,rgba(14,13,18,.92) 100%)' }} />
        <div style={{ position: 'absolute', left: 20, top: 104, display: 'inline-flex', alignItems: 'center', gap: 7, padding: '7px 13px', borderRadius: 999, ...G.tile, ...TYPO.caption, fontSize: 12, fontWeight: 700, color: G.t1 }}>
          <span style={{ width: 6, height: 6, borderRadius: 99, background: ACC, display: 'block' }} />금연 클럽 추천
        </div>
        <div style={{ position: 'absolute', left: 22, right: 22, top: 160, pointerEvents: 'none' }}>
          <div style={{ fontSize: 52, fontWeight: 800, letterSpacing: '-0.05em', lineHeight: '54px', color: 'transparent', WebkitTextStroke: '2px rgba(255,255,255,.88)' }}>SMOKE</div>
          <div style={{ fontSize: 52, fontWeight: 800, letterSpacing: '-0.05em', lineHeight: '54px', color: ACC }}>FREE</div>
        </div>
        <div style={{ position: 'absolute', left: 22, right: 22, bottom: 26, pointerEvents: 'none' }}>
          <h1 style={{ margin: 0, fontSize: 28, lineHeight: '36px', fontWeight: 800, letterSpacing: '-0.045em', color: '#fff', textShadow: '0 4px 20px rgba(0,0,0,.5)' }}>담배 연기 없는 클럽</h1>
          <p style={{ margin: '12px 0 0', fontSize: 14, lineHeight: '21px', letterSpacing: '-0.025em', color: G.t3 }}>실내 금연인 클럽만 모았어요.</p>
        </div>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '17px 20px', background: ACC }}>
        <img src="assets/vybe-logo.png" alt="vybe" style={{ height: 15, width: 42, objectFit: 'contain', display: 'block', flexShrink: 0, filter: 'brightness(0)' }} />
        <p style={{ margin: 0, fontSize: 12, lineHeight: '19px', letterSpacing: '-0.025em', color: 'rgba(12,20,4,.78)' }}>옷에 냄새 밸 걱정 없이<br /><b style={{ color: '#0d1505', fontWeight: 700 }}>금연 클럽만 모아놨어요</b></p>
      </div>
    </div>
  );
}

function PolicyBadge({ policy, strong }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '3px 9px 3px 7px', borderRadius: 8, background: strong ? 'rgba(181,255,96,0.13)' : 'rgba(255,255,255,0.07)', border: `1px solid ${strong ? ACC_LINE : 'rgba(255,255,255,0.12)'}` }}>
      <SFI.NoSmoke size={11} color={strong ? ACC : 'rgba(255,255,255,0.6)'} />
      <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '13px', fontWeight: 700, color: strong ? ACC : G.t2 }}>{policy}</span>
    </span>
  );
}

function ClubCard({ club, saved, onSave, badge }) {
  const strong = club.policy === STRONG_POLICY;
  return (
    <a href="%5Bv1%5DCLUB-021.html" style={{ display: 'block', textDecoration: 'none', position: 'relative', aspectRatio: '3 / 4', borderRadius: 16, overflow: 'hidden', background: club.bg, border: `1px solid ${G.hair}` }}>
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 70% at 70% 12%, rgba(255,255,255,0.2), transparent 55%)' }} />
      <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(14,13,18,0.95) 16%, rgba(14,13,18,0.2) 56%, transparent 80%)' }} />
      <div style={{ position: 'absolute', top: 11, left: 11, display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 8px', borderRadius: 99, ...G.bar, border: `1px solid ${club.open ? ACC_LINE : 'rgba(255,255,255,0.14)'}` }}>
        <span style={{ width: 5, height: 5, borderRadius: 99, background: club.open ? ACC : 'rgba(255,255,255,0.5)' }} />
        <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: club.open ? ACC : G.t3 }}>{club.open ? '영업 중' : '종료'}</span>
      </div>
      <div style={{ position: 'absolute', top: 8, right: 8 }}>
        <GlassRound size={30} onClick={e => { e.preventDefault(); onSave(club.id); }}><SFI.Heart size={15} active={saved} /></GlassRound>
      </div>
      <div style={{ position: 'absolute', left: 12, right: 12, bottom: 12 }}>
        {club.pick && (
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, marginBottom: 8, padding: '3px 8px 3px 7px', borderRadius: 7, background: 'rgba(119,49,254,0.55)', border: '1px solid rgba(200,168,255,0.45)' }}>
            <img src="assets/vybe-logo.png" alt="vybe" style={{ height: 8, width: 22, objectFit: 'contain', display: 'block', filter: 'brightness(0) invert(1)' }} />
            <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: '#fff' }}>추천 클럽</span>
          </span>
        )}
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginBottom: 5 }}>
          <span style={{ ...TYPO.h4, fontSize: 18, lineHeight: '20px', fontWeight: 700, color: G.t1 }}>{club.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2 }}>
            <SFI.Star size={11} /><span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: G.t1 }}>{club.rating.toFixed(2)}</span>
          </span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <SFI.Walk size={11} />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: G.t3, fontWeight: 600 }}>{club.area} · 걸어서 {club.walk}분</span>
        </div>
        <div style={{ marginTop: 8 }}><PolicyBadge policy={badge || club.policy} strong={badge ? false : strong} /></div>
      </div>
    </a>
  );
}

/* 02 · 장르별 금연 클럽 */
function GenreSection({ savedSet, onSave }) {
  const [genre, setGenre] = useState('EDM');
  const list = CLUBS.filter(c => c.genre === genre).slice().sort((a, b) => a.dist - b.dist);
  return (
    <div>
      <SFSectionHead title="장르별로 금연 클럽 확인" sub={`${genre} · ${list.length}곳 · 가까운 순`} />
      <div style={{ marginBottom: 14 }}><SFChipRow items={GENRES} active={genre} onChange={setGenre} /></div>
      {list.length === 0 ? (
        <div style={{ padding: '34px 24px', textAlign: 'center', ...TYPO.body4, color: G.t4 }}>이 장르에는 아직 금연 클럽이 없어요</div>
      ) : (
        <div key={genre} style={{ display: 'grid', gridTemplateColumns: 'minmax(0,1fr) minmax(0,1fr)', columnGap: 11, rowGap: 14, padding: '0 16px', animation: 'riseIn .3s ease' }}>
          {list.map(c => <ClubCard key={c.id} club={c} saved={savedSet.has(c.id)} onSave={onSave} />)}
        </div>
      )}
    </div>
  );
}

/* 03 · 실내 흡연실이 분리된 클럽 */
function BoothSection({ savedSet, onSave }) {
  const list = CLUBS.filter(c => BOOTHS[c.id]);
  return (
    <div>
      <SFSectionHead title="실내 흡연실이 따로 있는 클럽" sub={`${list.length}곳 · 흡연실 밖은 전부 금연이에요`} />
      <div style={{ display: 'grid', gridTemplateColumns: 'minmax(0,1fr) minmax(0,1fr)', columnGap: 11, rowGap: 14, padding: '0 16px' }}>
        {list.map(c => <ClubCard key={c.id} club={c} saved={savedSet.has(c.id)} onSave={onSave} badge="실내 흡연실" />)}
      </div>
    </div>
  );
}

function TabBar() {
  const tabs = [
    { key: 'home', label: '홈', Icon: SFI.HomeTab, href: '%5Bv1%5DHOME-005.html', active: true },
    { key: 'near', label: '주변', Icon: SFI.AroundTab, href: '%5Bv1%5DPLACE-019.html' },
    { key: 'search', label: '검색', Icon: SFI.SearchTab, href: '%5Bv1%5DHOME-006.html' },
    { key: 'saved', label: '찜', Icon: SFI.SavedTab, href: '%5Bv1%5DPLACE-020.html' },
    { key: 'me', label: '내 정보', Icon: SFI.MeTab, href: null },
  ];
  return (
    <div style={{ borderTop: `1px solid ${G.hair}`, ...G.bar, padding: '12px 24px 24px', display: 'flex', justifyContent: 'space-between', flexShrink: 0 }}>
      {tabs.map(t => {
        const Icon = t.Icon;
        return (
          <a key={t.key} href={t.href || '#'} onClick={e => !t.href && e.preventDefault()} style={{ textDecoration: 'none', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, minWidth: 40 }}>
            <div style={{ width: 4, height: 4, borderRadius: 99, background: t.active ? ACC : 'transparent', marginBottom: 2 }} />
            <Icon active={!!t.active} />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: t.active ? ACC : G.t2, fontWeight: t.active ? 600 : 400 }}>{t.label}</span>
          </a>
        );
      })}
    </div>
  );
}

function App() {
  const [solid, setSolid] = useState(false);
  const [area, setArea] = useState('홍대');
  const [selected, setSelected] = useState(1);
  const [savedSet, setSavedSet] = useState(new Set([2]));

  const mapList = CLUBS.filter(c => c.area === area);
  const toggleSave = id => setSavedSet(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; });
  const changeArea = a => { setArea(a); const first = CLUBS.find(c => c.area === a); setSelected(first ? first.id : null); };

  return (
    <div style={{ width: '100%', height: '100%', background: G.ink, position: 'relative', color: G.t1, fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Header solid={solid} />
      <div onScroll={e => setSolid(e.target.scrollTop > 420)} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', position: 'relative' }}>
        <Hero />
        <div style={{ position: 'relative', background: SF_AURORA }}>
          <div style={{ position: 'relative', paddingTop: 30 }}>
            <SFMapSection title="위치별로 금연 클럽 확인" areas={AREAS} area={area} onArea={changeArea} list={mapList} selected={selected} onSelect={setSelected} savedSet={savedSet} onSave={toggleSave} />
            <div style={{ height: 44 }} />
            <GenreSection savedSet={savedSet} onSave={toggleSave} />
            <div style={{ height: 44 }} />
            <BoothSection savedSet={savedSet} onSave={toggleSave} />
            <div style={{ height: 34 }} />
          </div>
        </div>
      </div>
      <TabBar />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <IOSDevice dark={true} width={393} height={852}>
    <App />
  </IOSDevice>
);
