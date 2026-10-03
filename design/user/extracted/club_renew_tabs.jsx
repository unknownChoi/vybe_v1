/* global React, TYPO, LIME, PURPLE, BLUE, GRAY, window, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, VRStar, VGlass, VHead, VButton, VFooterNote, VStatusPill, VR_CLUB, VR_SHOTS, VR_HOURS, VRToday, VRLineup, VRMenu, VRPhotos, VRLocation, VRFacilities, vrState, vrRef */
// ============ VYBE — Club Detail · Renewal · tab content ============
// 섹션 구성은 club_detail_glass.html과 동일, 표현은 리뉴얼 디자인 규격.

const VR_CHIP_TOP = 152; // 상단바 100 + 탭바 52

// ---------- data ----------
const VRT_TIER = {
  VVIP: { short: 'VVIP', color: VR.lavender, dot: PURPLE[500], soft: 'rgba(119,49,254,0.16)', ring: 'rgba(119,49,254,0.42)' },
  VIP: { short: 'VIP', color: VR.link, dot: BLUE[500], soft: 'rgba(43,107,255,0.14)', ring: 'rgba(43,107,255,0.40)' },
  STD: { short: 'STD', color: GRAY[300], dot: GRAY[500], soft: 'rgba(255,255,255,0.05)', ring: 'rgba(255,255,255,0.16)' },
};
const VRT_FLOOR = [
  { tier: 'VVIP', seats: 2, minPeople: 8, price: '100만' },
  { tier: 'VIP', seats: 4, minPeople: 6, price: '50만' },
  { tier: 'STD', seats: 3, minPeople: 4, price: '20만' },
];
const VRT_ACTS = [
  { time: '22:00', name: 'YANO', type: '래퍼', headline: true, bg: 'linear-gradient(135deg,#7731FE,#ff4d8d)' },
  { time: '23:30', name: 'GRIM', type: 'DJ', bg: 'linear-gradient(135deg,#fb5607,#ffbe0b)' },
  { time: '01:00', name: 'KODA', type: 'DJ', bg: 'linear-gradient(135deg,#3a0ca3,#4361ee)' },
];
const VRT_MENU_GALLERY = ['linear-gradient(135deg,#f7d046,#e8a020)', 'linear-gradient(135deg,#7731FE,#2a0d4a)', 'linear-gradient(135deg,#c0392b,#6e1818)', 'linear-gradient(135deg,#2c3e50,#0a0a1f)'];
const VRT_MENU_CATEGORIES = [
  { key: 'signature', label: '대표메뉴', title: '대표 메뉴' },
  { key: 'set', label: 'SET', title: 'SET' },
  { key: 'hard', label: 'HARD', title: 'HARD' },
  { key: 'champagne', label: 'CHAMPAGNE', title: 'CHAMPAGNE' },
  { key: 'beer', label: 'BEER', title: 'BEER' },
  { key: 'cocktail', label: 'COCKTAIL', title: 'COCKTAIL' },
];
const VRT_MENU_GROUPS = {
  signature: [
    { tag: '대표', name: 'LEMON DROP', desc: '레몬 보드카 베이스 · 새콤달콤', price: '15,000원', color: 'linear-gradient(135deg,#f7d046,#e8a020)' },
    { tag: '대표', name: 'PURPLE HAZE', desc: '블루베리 진 토닉', price: '16,000원', color: 'linear-gradient(135deg,#7731FE,#2a0d4a)' },
  ],
  set: [
    { tag: '대표', name: 'HARD SET A', desc: 'CHOICE A · OPERA BRUIT', price: '220,000원' },
    { name: 'HARD SET A·B', desc: 'CHOICE A·B · OPERA BRUIT', price: '420,000원' },
    { name: 'HARD SET B', desc: 'CHOICE B · HENKELL', price: '320,000원' },
  ],
  hard: [
    { name: "JACK DANIEL'S", desc: '버번 위스키 · 750ml', price: '180,000원', color: 'linear-gradient(135deg,#6e3a1f,#2a160a)' },
    { name: 'CHIVAS REGAL 12', desc: '스카치 위스키 · 750ml', price: '220,000원', color: 'linear-gradient(135deg,#c0392b,#6e1818)' },
    { name: 'GREY GOOSE', desc: '프렌치 보드카 · 750ml', price: '260,000원', color: 'linear-gradient(135deg,#2c3e50,#0a0a1f)' },
  ],
  champagne: [
    { name: 'MOËT & CHANDON', desc: '브뤼 · 750ml', price: '280,000원' },
    { name: 'VEUVE CLICQUOT', desc: '옐로우 라벨 · 750ml', price: '320,000원' },
    { name: 'DOM PÉRIGNON', desc: '빈티지 · 750ml', price: '780,000원' },
  ],
  beer: [
    { name: 'HEINEKEN', desc: '하이네켄 · 330ml', price: '12,000원' },
    { name: 'CORONA', desc: '코로나 엑스트라 · 355ml', price: '14,000원' },
    { name: 'STELLA', desc: '스텔라 아르투아 · 330ml', price: '13,000원' },
  ],
  cocktail: [
    { name: 'NEGRONI', desc: '진 · 캄파리 · 베르무트', price: '14,000원', color: 'linear-gradient(135deg,#c0392b,#6e1818)' },
    { name: 'OLD FASHIONED', desc: '버번 · 비터스 · 슈가', price: '15,000원' },
    { name: 'ESPRESSO MARTINI', desc: '보드카 · 에스프레소 · 칼루아', price: '16,000원' },
  ],
};
const VRT_PHOTO_FILTERS = [{ key: 'all', label: '전체' }, { key: 'venue', label: '업체' }, { key: 'food', label: '음식' }, { key: 'interior', label: '내부' }];
const VRT_PHOTO_DATA = [
  { h: 262, bg: 'linear-gradient(135deg,#2b1655,#7731FE)', cat: 'interior' }, { h: 180, bg: 'linear-gradient(135deg,#ff4d8d,#6622cc)', cat: 'venue' },
  { h: 180, bg: 'linear-gradient(135deg,#f7d046,#e8a020)', cat: 'food' }, { h: 180, bg: 'linear-gradient(135deg,#B5FF60,#2B6BFF)', cat: 'interior' },
  { h: 220, bg: 'linear-gradient(135deg,#c0392b,#6e1818)', cat: 'food' }, { h: 180, bg: 'linear-gradient(135deg,#2c3e50,#0a0a1f)', cat: 'venue' },
  { h: 270, bg: 'linear-gradient(135deg,#7731FE,#ff4d8d)', cat: 'interior' }, { h: 180, bg: 'linear-gradient(135deg,#2B6BFF,#7731FE)', cat: 'venue' },
  { h: 200, bg: 'linear-gradient(135deg,#fb5607,#ffbe0b)', cat: 'food' }, { h: 220, bg: 'linear-gradient(135deg,#06ffa5,#3a86ff)', cat: 'interior' },
  { h: 180, bg: 'linear-gradient(135deg,#8338ec,#ff006e)', cat: 'food' }, { h: 200, bg: 'linear-gradient(135deg,#2a2d34,#6c757d)', cat: 'interior' },
  { h: 240, bg: 'linear-gradient(135deg,#ff006e,#fb5607)', cat: 'food' }, { h: 180, bg: 'linear-gradient(135deg,#4a2580,#B5FF60)', cat: 'interior' },
  { h: 200, bg: 'linear-gradient(135deg,#2659D0,#B5FF60)', cat: 'venue' }, { h: 260, bg: 'linear-gradient(135deg,#94CF51,#2659D0)', cat: 'food' },
  { h: 180, bg: 'linear-gradient(135deg,#FF5C5F,#4E24A0)', cat: 'interior' }, { h: 220, bg: 'linear-gradient(135deg,#ffbe0b,#ff4d8d)', cat: 'food' },
  { h: 200, bg: 'linear-gradient(135deg,#0f0f23,#6622cc)', cat: 'venue' }, { h: 180, bg: 'linear-gradient(135deg,#f7d046,#ff006e)', cat: 'food' },
  { h: 240, bg: 'linear-gradient(135deg,#7731FE,#94CF51)', cat: 'interior' }, { h: 200, bg: 'linear-gradient(135deg,#3a86ff,#8338ec)', cat: 'food' },
  { h: 280, bg: 'linear-gradient(135deg,#1a0b3d,#ff4d8d)', cat: 'interior' }, { h: 180, bg: 'linear-gradient(135deg,#06ffa5,#7731FE)', cat: 'venue' },
  { h: 220, bg: 'linear-gradient(135deg,#2a2d34,#c0392b)', cat: 'food' }, { h: 200, bg: 'linear-gradient(135deg,#739F41,#2F1A5A)', cat: 'interior' },
  { h: 180, bg: 'linear-gradient(135deg,#ff4d8d,#B5FF60)', cat: 'food' }, { h: 240, bg: 'linear-gradient(135deg,#CF4D50,#2047A1)', cat: 'interior' },
  { h: 200, bg: 'linear-gradient(135deg,#ffbe0b,#2659D0)', cat: 'venue' }, { h: 220, bg: 'linear-gradient(135deg,#4E24A0,#B5FF60)', cat: 'food' },
  { h: 180, bg: 'linear-gradient(135deg,#6e3a1f,#f7d046)', cat: 'interior' }, { h: 200, bg: 'linear-gradient(135deg,#9F3E40,#2B6BFF)', cat: 'food' },
];
const VRT_REVIEWS = [
  { id: 1, u: '익명의 사자', r: 5, d: '2025.06.08', t: '사운드가 진짜 미쳤어요. 입장료도 안 받는데 라인업이 알차서 새벽까지 놀았습니다.', av: 'linear-gradient(135deg,#7731FE,#c04bd0)', photo: 'linear-gradient(140deg,#4b2b7a,#a24bd0)' },
  { id: 2, u: '주말의기록', r: 4, d: '2025.06.02', t: '힙합 좋아하면 무조건 만족할 곳. 다만 12시 넘으면 사람이 너무 많아요.', av: 'linear-gradient(135deg,#2B6BFF,#3f8fd0)' },
  { id: 3, u: 'night_seoul', r: 5, d: '2025.05.20', t: '직원분들이 친절하고 테이블 응대도 빨라요. 분위기 진짜 좋습니다.', av: 'linear-gradient(135deg,#25503a,#7fc06a)', photo: 'linear-gradient(140deg,#1d3d6b,#3f8fd0)' },
  { id: 4, u: '홍대붙박이', r: 5, d: '2025.05.18', t: '입문자랑 같이 가기 딱 좋아요. 플로어가 넓어서 안 부딪히고 놉니다.', av: 'linear-gradient(135deg,#6b2233,#d0644b)' },
  { id: 5, u: '디제이러버', r: 5, d: '2025.05.11', t: '이번 달 라인업 진짜 알차요. YANO 셋 들으러 또 갈 예정.', av: 'linear-gradient(135deg,#1b1030,#5a2b9e)', photo: 'linear-gradient(140deg,#6b2233,#d0644b)' },
  { id: 6, u: '토요일의밤', r: 4, d: '2025.05.03', t: '가성비 최고. 다만 물품보관함이 금방 차서 일찍 가는 게 좋아요.', av: 'linear-gradient(135deg,#2c3e50,#0a0a1f)' },
  { id: 7, u: '무한리필', r: 5, d: '2025.04.27', t: '테이블 잡고 놀았는데 응대가 빨라서 좋았습니다. 사운드 밸런스도 훌륭.', av: 'linear-gradient(135deg,#25503a,#7fc06a)', photo: 'linear-gradient(140deg,#25503a,#7fc06a)' },
  { id: 8, u: 'club_kr', r: 5, d: '2025.04.20', t: '무료입장인데 이 정도 퀄리티면 말 다 했죠. 홍대 오면 필수 코스.', av: 'linear-gradient(135deg,#ff4d8d,#7731FE)' },
  { id: 9, u: '새벽감성', r: 5, d: '2025.04.12', t: '2시 넘어서가 진짜 하이라이트예요. 조명이랑 사운드 조합이 미쳤습니다.', av: 'linear-gradient(135deg,#0f2027,#2c5364)' },
  { id: 10, u: '주말도서관', r: 4, d: '2025.04.05', t: '분위기는 좋은데 주말엔 웨이팅이 좀 있어요. 그래도 재방문 의사 있음.', av: 'linear-gradient(135deg,#4b2b7a,#a24bd0)', photo: 'linear-gradient(140deg,#1b1030,#5a2b9e)' },
  { id: 11, u: '힙합키드', r: 5, d: '2025.03.29', t: '트랙 셀렉이 취향 저격. 힙합 좋아하면 여기가 정답이에요.', av: 'linear-gradient(135deg,#fb5607,#ffbe0b)' },
  { id: 12, u: '초행길', r: 3, d: '2025.03.21', t: '처음 갔는데 입구 찾기가 조금 어려웠어요. 안은 만족스러웠습니다.', av: 'linear-gradient(135deg,#2a2d34,#6c757d)' },
  { id: 13, u: '상수동주민', r: 5, d: '2025.03.14', t: '집 근처라 자주 가는데 한 번도 실망한 적 없어요. 직원분들 최고.', av: 'linear-gradient(135deg,#2B6BFF,#7731FE)', photo: 'linear-gradient(140deg,#4b2b7a,#a24bd0)' },
];
const VRT_NEARBY = [
  { name: '홍대 클럽 레이저', area: '홍대', genre: '힙합', rating: 4.5, dist: '120m', open: true, color: 'linear-gradient(135deg,#ff006e,#8338ec)' },
  { name: '버뮤다', area: '홍대', genre: '힙합', rating: 4.3, dist: '250m', open: true, color: 'linear-gradient(135deg,#06ffa5,#3a86ff)' },
  { name: '인클', area: '홍대', genre: '힙합', rating: 4.7, dist: '340m', open: true, color: 'linear-gradient(135deg,#fb5607,#ffbe0b)' },
  { name: '벨로주', area: '홍대', genre: '재즈', rating: 4.6, dist: '410m', open: false, color: 'linear-gradient(135deg,#2a2d34,#6c757d)' },
];
const VRT_NOTICE = ['만 19세 이상 입장 가능 (신분증 필수)', '슬리퍼·반바지 등 복장 제한이 있을 수 있어요', '테이블 예약은 매장 전화로만 가능합니다', '분실물은 영업 종료 후 7일간 보관해요'];

// ---------- 공통 칩 (sticky row) ----------
function VRChip({ label, sel, onClick }) {
  return <button onClick={onClick} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, padding: '8px 15px', borderRadius: 99, background: sel ? LIME[500] : VR.tileFill, border: `1px solid ${sel ? LIME[500] : VR.tileBorder}`, color: sel ? VR.ink : VR.t2, ...TYPO.button2, fontWeight: sel ? 600 : 500, whiteSpace: 'nowrap', transition: 'background .16s ease, color .16s ease' }}>{label}</button>;
}
function VRChipRow({ children }) {
  return (
    <div style={{ position: 'sticky', top: VR_CHIP_TOP, zIndex: 15, margin: `0 -${PAGE_H}px`, padding: `10px ${PAGE_H}px`, background: VR.barFill, ...VR_BLUR(20), borderBottom: `1px solid ${VR.hair}`, display: 'flex', gap: SP.sm, overflowX: 'auto', scrollbarWidth: 'none' }}>{children}</div>
  );
}

// ---------- 오늘의 라인업 (시간 · 헤드라인) ----------
function VRLineupToday() {
  return (
    <div>
      <VHead title="오늘의 라인업" sub="7월 4일 (목)" href="%5Bv1%5DHOME-009.html" />
      <div style={{ display: 'flex', flexDirection: 'column', gap: SP.sm }}>
        {VRT_ACTS.map(a => (
          <div key={a.name} style={{ display: 'flex', alignItems: 'center', gap: SP.md, padding: SP.md, borderRadius: 14, background: a.headline ? 'rgba(119,49,254,0.16)' : VR.quietFill, border: `1px solid ${a.headline ? 'rgba(181,255,96,0.22)' : VR.quietBorder}`, ...VR_BLUR(14) }}>
            <div style={{ width: 44, height: 44, borderRadius: 12, background: a.bg, flexShrink: 0, position: 'relative', overflow: 'hidden' }}>
              <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 32% 26%, rgba(255,255,255,0.32), transparent 62%)' }} />
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
                <span style={{ ...TYPO.body4, color: VR.t1, fontWeight: 600 }}>{a.name}</span>
                {a.headline && <span style={{ fontSize: 10, lineHeight: '13px', padding: '2px 7px', borderRadius: 6, background: LIME[500], color: VR.ink, fontWeight: 600, letterSpacing: '-0.02em' }}>HEADLINE</span>}
              </div>
              <div style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4, marginTop: 2 }}>{a.time} · {a.type}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ---------- 테이블 ----------
function VRTables() {
  return (
    <div>
      <VHead title="테이블" sub="예약은 매장 전화로 문의해주세요" href="%5Bv1%5DCLUB-023.html" action="가격표" />
      <div style={{ display: 'flex', flexDirection: 'column', gap: SP.sm }}>
        {VRT_FLOOR.map(f => {
          const t = VRT_TIER[f.tier];
          return (
            <div key={f.tier} style={{ display: 'flex', alignItems: 'center', gap: SP.md, padding: `${SP.md}px ${SP.lg}px`, borderRadius: 14, background: t.soft, border: `1px solid ${t.ring}` }}>
              <span style={{ width: 8, height: 8, borderRadius: 99, background: t.dot, flexShrink: 0 }} />
              <span style={{ ...TYPO.body4, color: t.color, fontWeight: 600, width: 46 }}>{t.short}</span>
              <span style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4, flex: 1, minWidth: 0 }}>{f.seats}석 · 최소 {f.minPeople}인</span>
              <span style={{ ...TYPO.body4, color: VR.t1, fontWeight: 600, flexShrink: 0 }}>{f.price}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ---------- 주변 클럽 ----------
function VRNearby() {
  return (
    <div>
      <VHead title="주변 클럽" sub="반경 500m · 32곳" href="%5Bv1%5DPLACE-019.html" />
      <div style={{ display: 'flex', gap: SP.md, overflowX: 'auto', scrollbarWidth: 'none', margin: `0 -${PAGE_H}px`, padding: `0 ${PAGE_H}px` }}>
        {VRT_NEARBY.map(c => (
          <a key={c.name} href="%5Bv1%5DPLACE-019.html" style={{ width: 134, flexShrink: 0, textDecoration: 'none' }}>
            <div style={{ width: 134, height: 134, borderRadius: 16, background: c.color, position: 'relative', overflow: 'hidden', marginBottom: 9, border: `1px solid ${VR.tileBorder}` }}>
              <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 38% 30%, rgba(255,255,255,0.24), transparent 62%)' }} />
              <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(180deg, transparent 48%, rgba(0,0,0,0.6) 100%)' }} />
              <div style={{ position: 'absolute', top: 7, left: 7, display: 'flex', alignItems: 'center', gap: 3, padding: '3px 8px', borderRadius: 99, background: VR.barFill, ...VR_BLUR(14), border: '1px solid rgba(255,255,255,0.14)' }}>
                <VRStar size={10} /><span style={{ fontSize: 10.5, lineHeight: '12px', color: '#fff', fontWeight: 600 }}>{c.rating}</span>
              </div>
              <div style={{ position: 'absolute', left: 8, bottom: 8, display: 'flex', alignItems: 'center', gap: 4 }}>
                <span style={{ width: 5, height: 5, borderRadius: 99, background: c.open ? LIME[500] : 'rgba(255,255,255,0.4)' }} />
                <span style={{ fontSize: 10.5, lineHeight: '12px', color: '#fff', fontWeight: 500 }}>{c.dist}</span>
              </div>
            </div>
            <div style={{ ...TYPO.body4, color: VR.t1, fontWeight: 600 }}>{c.name}</div>
            <div style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4, marginTop: 2 }}>{c.area} · {c.genre}</div>
          </a>
        ))}
      </div>
    </div>
  );
}

// ---------- 메뉴 리스트 ----------
function VRMenuRows({ items }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column' }}>
      {items.map((m, i) => (
        <div key={m.name} style={{ display: 'flex', gap: SP.md, alignItems: 'center', padding: `${SP.lg}px 0`, borderTop: i === 0 ? 'none' : `1px solid ${VR.hair}` }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              {m.tag && <span style={{ padding: '2px 7px', borderRadius: 6, background: PURPLE[500], color: '#fff', fontSize: 10, lineHeight: '13px', fontWeight: 600 }}>{m.tag}</span>}
              <span style={{ ...TYPO.body4, color: VR.t1, fontWeight: 600 }}>{m.name}</span>
            </div>
            {m.desc && <div style={{ ...TYPO.caption, lineHeight: '17px', color: VR.t4, marginTop: 4 }}>{m.desc}</div>}
            <div style={{ ...TYPO.body3, color: VR.t1, fontWeight: 600, marginTop: 6 }}>{m.price}</div>
          </div>
          {m.color && (
            <div style={{ width: 78, height: 78, borderRadius: 14, flexShrink: 0, background: m.color, position: 'relative', overflow: 'hidden', border: `1px solid ${VR.tileBorder}` }}>
              <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 28%, rgba(255,255,255,0.28), transparent 62%)' }} />
            </div>
          )}
        </div>
      ))}
    </div>
  );
}

// ---------- 메뉴 탭 ----------
function VRMenuTab({ scrollRef }) {
  const [active, setActive] = vrState('signature');
  const secs = vrRef({});
  const goTo = (k) => {
    setActive(k);
    const el = secs.current[k], sc = scrollRef && scrollRef.current;
    if (!el || !sc) return;
    const top = sc.scrollTop + el.getBoundingClientRect().top - sc.getBoundingClientRect().top - (VR_CHIP_TOP + 52);
    sc.scrollTo({ top: Math.max(0, top), behavior: 'smooth' });
  };
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: SP.xl }}>
      <div>
        <VHead title="메뉴 이미지" />
        <div style={{ display: 'flex', gap: SP.sm, overflowX: 'auto', scrollbarWidth: 'none', margin: `0 -${PAGE_H}px`, padding: `0 ${PAGE_H}px` }}>
          {VRT_MENU_GALLERY.map((bg, i) => (
            <div key={i} style={{ width: 104, height: 104, borderRadius: 14, flexShrink: 0, background: bg, position: 'relative', overflow: 'hidden', border: `1px solid ${VR.tileBorder}` }}>
              <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 28%, rgba(255,255,255,0.28), transparent 62%)' }} />
            </div>
          ))}
        </div>
      </div>

      <VRChipRow>
        {VRT_MENU_CATEGORIES.map(c => <VRChip key={c.key} label={c.label} sel={c.key === active} onClick={() => goTo(c.key)} />)}
      </VRChipRow>

      <div>
        {VRT_MENU_CATEGORIES.map((c, ci) => (
          <div key={c.key} ref={el => { secs.current[c.key] = el; }} style={{ paddingTop: ci === 0 ? 0 : SP.xl, marginTop: ci === 0 ? 0 : SP.xl, borderTop: ci === 0 ? 'none' : `1px solid ${VR.hair}` }}>
            <VHead title={c.title} />
            <VRMenuRows items={VRT_MENU_GROUPS[c.key]} />
          </div>
        ))}
      </div>

      <VFooterNote>메뉴 항목과 가격은 매장 사정에 따라 다를 수 있습니다.</VFooterNote>
    </div>
  );
}

// ---------- 사진 탭 (2열 매스너리) ----------
function VRPhotoTab({ onOpen }) {
  const [filter, setFilter] = vrState('all');
  const [shown, setShown] = vrState(12);
  const all = filter === 'all' ? VRT_PHOTO_DATA : VRT_PHOTO_DATA.filter(p => p.cat === filter);
  const list = all.slice(0, shown);
  const more = all.length - list.length;
  const colA = [], colB = [];
  let hA = 0, hB = 0;
  list.forEach((p, idx) => { const it = { ...p, idx }; if (hA <= hB) { colA.push(it); hA += p.h + 8; } else { colB.push(it); hB += p.h + 8; } });
  const col = (items) => (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: SP.sm }}>
      {items.map(p => (
        <button key={p.idx} onClick={() => onOpen && onOpen(p.bg)} style={{ all: 'unset', cursor: 'pointer', display: 'block', width: '100%', height: p.h, borderRadius: 14, background: p.bg, position: 'relative', overflow: 'hidden', border: `1px solid ${VR.tileBorder}` }}>
          <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 28%, rgba(255,255,255,0.24), transparent 62%)' }} />
        </button>
      ))}
    </div>
  );
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: SP.lg }}>
      <VRChipRow>
        {VRT_PHOTO_FILTERS.map(f => {
          const n = f.key === 'all' ? VRT_PHOTO_DATA.length : VRT_PHOTO_DATA.filter(p => p.cat === f.key).length;
          return <VRChip key={f.key} label={`${f.label} ${n}`} sel={f.key === filter} onClick={() => { setFilter(f.key); setShown(12); }} />;
        })}
      </VRChipRow>
      <div style={{ display: 'flex', gap: SP.sm }}>{col(colA)}{col(colB)}</div>
      {more > 0
        ? <VButton label={`사진 ${more}장 더 보기`} variant="quiet" onClick={() => setShown(s => s + 12)} style={{ width: '100%' }} />
        : <span style={{ textAlign: 'center', ...TYPO.caption, lineHeight: '16px', color: VR.t4 }}>모든 사진을 봤어요</span>}
    </div>
  );
}

// ---------- 리뷰 탭 ----------
function VRReviewSummary() {
  const dist = [{ s: 5, c: 9 }, { s: 4, c: 3 }, { s: 3, c: 1 }, { s: 2, c: 0 }, { s: 1, c: 0 }];
  const total = dist.reduce((a, b) => a + b.c, 0);
  return (
    <VGlass pad={SP.xl} style={{ display: 'flex', gap: SP.xl, alignItems: 'center' }}>
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 5, minWidth: 78, flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 2 }}>
          <span style={{ ...TYPO.h2, color: VR.t1 }}>{VR_CLUB.rating}</span>
          <span style={{ ...TYPO.body4, color: VR.t4 }}>/5</span>
        </div>
        <div style={{ display: 'flex', gap: 1 }}>{[1, 2, 3, 4, 5].map(i => <VRStar key={i} size={12} c={i <= 4.76 ? LIME[500] : 'rgba(255,255,255,0.18)'} />)}</div>
        <span style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4 }}>방문자 {total}명</span>
      </div>
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 5 }}>
        {dist.map(d => (
          <div key={d.s} style={{ display: 'flex', alignItems: 'center', gap: SP.sm }}>
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t3, width: 10 }}>{d.s}</span>
            <span style={{ flex: 1, height: 5, borderRadius: 99, background: 'rgba(255,255,255,0.10)', overflow: 'hidden' }}>
              <span style={{ display: 'block', width: `${total ? (d.c / total) * 100 : 0}%`, height: '100%', borderRadius: 99, background: LIME[500] }} />
            </span>
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4, minWidth: 14, textAlign: 'right' }}>{d.c}</span>
          </div>
        ))}
      </div>
    </VGlass>
  );
}

function VRReviewTab() {
  const [sort, setSort] = vrState('latest');
  const [shown, setShown] = vrState(5);
  const base = sort === 'photo' ? VRT_REVIEWS.filter(r => r.photo) : sort === 'rating' ? [...VRT_REVIEWS].sort((a, b) => b.r - a.r) : VRT_REVIEWS;
  const list = base.slice(0, shown);
  const more = base.length - list.length;
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: SP.lg }}>
      <VRReviewSummary />
      <VButton label="리뷰 작성하기" href="%5Bv1%5DCLUB-028.html" icon={VRPATH.pen} variant="lime" style={{ width: '100%' }} />
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: SP.md }}>
        <span style={{ ...TYPO.body4, color: VR.t1, fontWeight: 600 }}>리뷰 {base.length}</span>
        <div style={{ display: 'flex', gap: 4 }}>
          {[{ k: 'latest', l: '최신순' }, { k: 'rating', l: '평점순' }, { k: 'photo', l: '사진' }].map(o => {
            const sel = sort === o.k;
            return <button key={o.k} onClick={() => { setSort(o.k); setShown(5); }} style={{ all: 'unset', cursor: 'pointer', padding: '5px 11px', borderRadius: 99, ...TYPO.caption, lineHeight: '14px', fontWeight: sel ? 600 : 400, color: sel ? VR.t1 : VR.t3, background: sel ? VR.tileFill : 'transparent', border: `1px solid ${sel ? VR.tileBorder : 'transparent'}` }}>{o.l}</button>;
          })}
        </div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: SP.md }}>
        {list.map(r => (
          <VGlass key={r.id} quiet pad={SP.lg}>
            <div style={{ display: 'flex', alignItems: 'center', gap: SP.sm }}>
              <span style={{ width: 34, height: 34, borderRadius: 99, background: r.av, flexShrink: 0 }} />
              <div style={{ minWidth: 0 }}>
                <div style={{ ...TYPO.body4, color: VR.t1, fontWeight: 600 }}>{r.u}</div>
                <div style={{ display: 'flex', gap: 1, marginTop: 3 }}>{[1, 2, 3, 4, 5].map(i => <VRStar key={i} size={10} c={i <= r.r ? LIME[500] : 'rgba(255,255,255,0.18)'} />)}</div>
              </div>
              <span style={{ marginLeft: 'auto', ...TYPO.caption, lineHeight: '14px', color: VR.t4, flexShrink: 0 }}>{r.d}</span>
            </div>
            <div style={{ display: 'flex', gap: SP.md, alignItems: 'flex-start', marginTop: SP.md }}>
              <p style={{ flex: 1, minWidth: 0, ...TYPO.body4, lineHeight: '21px', color: VR.t2, margin: 0, textWrap: 'pretty' }}>{r.t}</p>
              {r.photo && <div style={{ width: 72, height: 72, borderRadius: 12, background: r.photo, flexShrink: 0, border: `1px solid ${VR.tileBorder}` }} />}
            </div>
          </VGlass>
        ))}
      </div>
      {more > 0
        ? <VButton label={`리뷰 ${more}개 더 보기`} variant="quiet" onClick={() => setShown(s => s + 5)} style={{ width: '100%' }} />
        : <span style={{ textAlign: 'center', ...TYPO.caption, lineHeight: '16px', color: VR.t4 }}>모든 리뷰를 봤어요</span>}
    </div>
  );
}

// ---------- 상세 정보 (영업시간 · 입장료 · 전화 · SNS) ----------
function VRDetailInfo() {
  const row = (icon, children, last) => (
    <div style={{ display: 'flex', gap: SP.md, alignItems: 'flex-start', padding: `${SP.md}px 0`, borderBottom: last ? 'none' : `1px solid ${VR.hair}` }}>
      <span style={{ flexShrink: 0, marginTop: 1 }}><VRIcon d={icon} size={17} c="rgba(255,255,255,0.55)" /></span>
      <div style={{ flex: 1, minWidth: 0, ...TYPO.body4, lineHeight: '20px', color: VR.t2 }}>{children}</div>
    </div>
  );
  return (
    <div>
      <VHead title="상세 정보" />
      <VGlass quiet pad={SP.lg}>
        {row(VRPATH.clock, (
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: SP.sm, marginBottom: SP.md }}>
              <VStatusPill open />
              <span style={{ color: VR.t3 }}>02:00에 영업 종료</span>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 9 }}>
              {VR_HOURS.map(([d, h, today]) => {
                const off = h === '정기휴무';
                return (
                  <div key={d} style={{ display: 'flex', alignItems: 'center', gap: SP.md }}>
                    <span style={{ width: 18, ...TYPO.caption, lineHeight: '15px', color: today ? VR.t1 : VR.t3, fontWeight: today ? 600 : 400 }}>{d}</span>
                    <span style={{ ...TYPO.caption, lineHeight: '15px', color: off ? '#FF5C5F' : today ? VR.t1 : VR.t3, fontWeight: today || off ? 600 : 400 }}>{h}</span>
                    {today && <span style={{ marginLeft: 'auto', fontSize: 10, lineHeight: '12px', color: VR.lavender, fontWeight: 600, padding: '3px 8px', borderRadius: 6, background: 'rgba(119,49,254,0.22)' }}>오늘</span>}
                  </div>
                );
              })}
            </div>
          </div>
        ))}
        {row(VRPATH.ticket, <window.VRFeeLine />)}
        {row(VRPATH.phone, <a href={`tel:${VR_CLUB.tel.replace(/-/g, '')}`} style={{ color: VR.link, textDecoration: 'none' }}>{VR_CLUB.tel}</a>)}
        {row(VRPATH.link, <a href="#" onClick={e => e.preventDefault()} style={{ color: VR.link, textDecoration: 'none' }}>{VR_CLUB.sns}</a>, true)}
      </VGlass>
    </div>
  );
}

// ---------- 이용 안내 ----------
function VRNotice() {
  return (
    <VGlass pad={SP.lg} style={{ background: 'rgba(119,49,254,0.16)', border: '1px solid rgba(119,49,254,0.32)' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 7, marginBottom: SP.md }}>
        <VRIcon d={VRPATH.info} size={16} c={LIME[500]} w="2" />
        <span style={{ ...TYPO.button1, color: VR.t1, fontWeight: 600 }}>이용 안내</span>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: SP.sm }}>
        {VRT_NOTICE.map(t => (
          <div key={t} style={{ display: 'flex', gap: SP.sm, alignItems: 'flex-start' }}>
            <span style={{ width: 4, height: 4, borderRadius: 99, background: LIME[500], flexShrink: 0, marginTop: 8 }} />
            <span style={{ ...TYPO.body4, lineHeight: '20px', color: VR.t2 }}>{t}</span>
          </div>
        ))}
      </div>
    </VGlass>
  );
}

// ---------- 사진 라이트박스 (앱 루트에 렌더 — transform 조상 회피) ----------
function VRLightbox({ bg, onClose }) {
  if (!bg) return null;
  return (
    <div onClick={onClose} style={{ position: 'absolute', inset: 0, zIndex: 200, background: 'rgba(6,5,9,0.92)', ...VR_BLUR(6), display: 'grid', placeItems: 'center', padding: SP.xxl }}>
      <div style={{ width: '100%', maxWidth: 360, aspectRatio: '3/4', borderRadius: 19, background: bg, position: 'relative', overflow: 'hidden', border: '1px solid rgba(255,255,255,0.14)' }}>
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 28%, rgba(255,255,255,0.24), transparent 62%)' }} />
      </div>
    </div>
  );
}

Object.assign(window, { VR_CHIP_TOP, VRT_MENU_GROUPS, VRLightbox, VRLineupToday, VRTables, VRNearby, VRMenuRows, VRMenuTab, VRPhotoTab, VRReviewSummary, VRReviewTab, VRDetailInfo, VRNotice });
