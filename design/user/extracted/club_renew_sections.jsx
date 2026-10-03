/* global React, TYPO, GRAY, LIME, PURPLE, RED, window, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, VRStar, VGlass, VHead, VDot, VMeta, VStatusPill, VRecBadge, VButton, VGlassRound, VFooterNote, vrState */
// ============ VYBE — Club Detail · Renewal · sections ============

const VR_CLUB = {
  name: '어썸 레드', area: '홍대', genre: '힙합 클럽', dist: '0.4km',
  rating: 4.76, reviews: 13,
  desc: '홍대역 인근, 입문자에게 좋은 힙합 클럽',
  tags: ['#힙합', '#대중적', '#무료입장', '#홍대'],
  addr: '서울 마포구 잔다리로 12 지하 1층', jibun: '서울 마포구 서교동 402-9',
  hint: '편의점 옆 계단으로 지하 1층까지 내려오세요',
  fee: '0 ~ 10,000원', sns: '@awesomered_omg', tel: '02-333-1094',
  photoCount: 34,
};
const VR_SHOTS = [
  'linear-gradient(135deg,#7731FE 0%,#c04bd0 52%,#ff5c8a 100%)',
  'linear-gradient(135deg,#2B6BFF 0%,#7731FE 100%)',
  'linear-gradient(135deg,#1b1030 0%,#5a2b9e 60%,#b5ff60 160%)',
  'linear-gradient(135deg,#ff4d8d 0%,#7731FE 100%)',
  'linear-gradient(135deg,#0f2027 0%,#2c5364 100%)',
];
const VR_HOURS = [['월', '11:00 - 02:00'], ['화', '11:00 - 02:00'], ['수', '11:00 - 02:00'], ['목', '11:00 - 02:00', true], ['금', '11:00 - 03:00'], ['토', '11:00 - 03:00'], ['일', '정기휴무']];
const VR_LINEUP = [{ t: '23:00', n: 'DJ SOMA', g: '힙합 · R&B' }, { t: '00:30', n: 'DJ KURO', g: '트랩' }, { t: '01:30', n: 'DJ MIRAE', g: '하우스' }];
const VR_MENU = [{ n: '테이블 세트 (4인)', p: '150,000원', tag: '위스키 1병 + 음료' }, { n: '하이볼', p: '12,000원' }, { n: '소주 · 맥주', p: '6,000원' }];
const VR_REVIEWS = [
  { id: 1, u: '지은', d: '3일 전', r: 5, t: '음악이 계속 좋았어요. 입문자끼리 가도 눈치 안 보이고 편했음. 화장실도 깔끔.', tags: ['음악 최고', '분위기 좋음'] },
  { id: 2, u: '태오', d: '1주 전', r: 4, t: '금요일 12시쯤 갔는데 사람 꽤 많았어요. 테이블은 예약 필수인 듯.', tags: ['사람 많음'] },
];
const VR_FACIL = [{ l: '주차 가능', d: VRPATH.parking }, { l: '화장실 분리', d: VRPATH.restroom }, { l: '흡연실', d: VRPATH.smoking }, { l: '물품보관함', d: VRPATH.locker }, { l: '카드 결제', d: VRPATH.card }, { l: '단체석', d: VRPATH.groupSeat }];

// ---------- Hero ----------
function VRHero({ shots = VR_SHOTS }) {
  const [idx, setIdx] = vrState(0);
  const total = shots.length;
  React.useEffect(() => { const t = setInterval(() => setIdx(i => (i + 1) % total), 4200); return () => clearInterval(t); }, []);
  return (
    <div style={{ position: 'relative', height: 356, flexShrink: 0 }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, overflow: 'hidden', maskImage: 'linear-gradient(180deg, #000 0%, #000 58%, rgba(0,0,0,0.55) 82%, transparent 100%)', WebkitMaskImage: 'linear-gradient(180deg, #000 0%, #000 58%, rgba(0,0,0,0.55) 82%, transparent 100%)' }}>
        {shots.map((bg, i) => <div key={i} style={{ position: 'absolute', inset: 0, background: /\.(jpe?g|png|webp|avif)$/i.test(bg) ? `#0E0D12 url("${bg}") center/cover no-repeat` : bg, opacity: i === idx ? 1 : 0, transition: 'opacity .9s ease' }} />)}
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(70% 60% at 26% 20%, rgba(255,255,255,0.22), transparent 62%)' }} />
        <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(180deg, rgba(8,7,12,0.62) 0%, transparent 32%, rgba(14,13,18,0.42) 76%, rgba(14,13,18,0.72) 100%)' }} />
      </div>
      {total > 1 && <div style={{ position: 'absolute', right: PAGE_H, bottom: 58, padding: '5px 11px', borderRadius: 99, background: VR.barFill, ...VR_BLUR(18), border: '1px solid rgba(255,255,255,0.14)', ...TYPO.caption, lineHeight: '15px', color: '#fff', fontWeight: 600 }}>{idx + 1} / {total}</div>}
      {total > 1 && <div style={{ position: 'absolute', left: PAGE_H, bottom: 60, display: 'flex', gap: 5 }}>
        {shots.map((_, i) => <button key={i} onClick={() => setIdx(i)} style={{ all: 'unset', cursor: 'pointer', width: i === idx ? 18 : 5, height: 5, borderRadius: 99, background: i === idx ? '#fff' : 'rgba(255,255,255,0.38)', transition: 'all .28s' }} />)}
      </div>}
    </div>
  );
}

// ---------- 타이틀 블록 (배경 위 · 카드 없음) ----------
function VRTitle() {
  return (
    <div style={{ position: 'relative', zIndex: 2, padding: `0 ${PAGE_H}px`, marginTop: -24, paddingBottom: 2, display: 'flex', flexDirection: 'column', gap: SP.md, flexShrink: 0 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
        <window.VRFreePill />
        <VRecBadge />
        <VStatusPill open label="영업중 · 02:00 종료" />
      </div>
      <h1 style={{ ...TYPO.h2, color: VR.t1, margin: 0 }}>{VR_CLUB.name}</h1>
      <VMeta items={[VR_CLUB.area, VR_CLUB.genre.replace(' 클럽', ''), VR_CLUB.dist]} />
      <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
        <VRStar size={15} />
        <span style={{ ...TYPO.body3, color: VR.t1, fontWeight: 600 }}>{VR_CLUB.rating}</span>
        <VDot />
        <span style={{ ...TYPO.body4, color: VR.t3 }}>리뷰 {VR_CLUB.reviews}</span>
      </div>
      <p style={{ ...TYPO.body4, lineHeight: '20px', color: VR.t2, margin: 0, textWrap: 'pretty' }}>{VR_CLUB.desc}</p>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
        {VR_CLUB.tags.map(t => (
          <span key={t} style={{ padding: '5px 11px', borderRadius: 99, background: VR.tileFill, border: `1px solid ${VR.tileBorder}`, ...TYPO.caption, lineHeight: '14px', color: VR.lavender }}>{t}</span>
        ))}
      </div>
    </div>
  );
}

// ---------- 오늘 (강조 글래스 카드) ----------
function VRToday() {
  const [addr, setAddr] = vrState(false);
  const [hours, setHours] = vrState(false);
  const row = (icon, children, last, first) => (
    <div style={{ display: 'flex', gap: SP.md, alignItems: 'flex-start', paddingTop: first ? 0 : SP.md, paddingBottom: last ? 0 : SP.md, borderBottom: last ? 'none' : `1px solid ${VR.hair}` }}>
      <span style={{ flexShrink: 0, marginTop: 1 }}>{icon}</span>
      <div style={{ flex: 1, minWidth: 0, ...TYPO.body4, lineHeight: '20px', color: VR.t2 }}>{children}</div>
    </div>
  );
  const ico = (d) => <VRIcon d={d} size={17} c="rgba(255,255,255,0.55)" />;
  return (
    <div>
      <VHead title="매장 정보" />
      <VGlass quiet pad={SP.lg} style={{ paddingTop: 13, paddingBottom: 13 }}>
        {row(ico(VRPATH.pin), (
          <div>
            <button onClick={() => setAddr(!addr)} style={{ all: 'unset', cursor: 'pointer', width: '100%', display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: SP.sm }}>
              <span style={{ flex: 1, minWidth: 0, color: VR.t2 }}>{VR_CLUB.addr}</span>
              <span style={{ display: 'flex', flexShrink: 0, marginTop: 3, transform: addr ? 'rotate(180deg)' : 'none', transition: 'transform .22s' }}><VRChev size={15} /></span>
            </button>
            <div style={{ maxHeight: addr ? 200 : 0, overflow: 'hidden', transition: 'max-height .3s ease' }}>
              <div style={{ marginTop: SP.sm, display: 'flex', flexDirection: 'column', gap: 7 }}>
                <div style={{ display: 'flex', gap: SP.sm }}>
                  <span style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4, width: 30, flexShrink: 0 }}>지번</span>
                  <span style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t3 }}>{VR_CLUB.jibun}</span>
                </div>
                <div style={{ display: 'flex', gap: SP.sm }}>
                  <span style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4, width: 30, flexShrink: 0 }}>안내</span>
                  <span style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t3, textWrap: 'pretty' }}>{VR_CLUB.hint}</span>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 2 }}>
                  <span style={{ width: 17, height: 17, borderRadius: 99, background: '#BDB092', color: VR.ink, fontSize: 10, lineHeight: '17px', fontWeight: 700, textAlign: 'center', flexShrink: 0 }}>9</span>
                  <span style={{ ...TYPO.caption, lineHeight: '15px', color: VR.t3 }}>상수역 1번 출구에서 422m</span>
                </div>
              </div>
            </div>
          </div>
        ), false, true)}
        {row(ico(VRPATH.clock), (
          <div>
            <button onClick={() => setHours(!hours)} style={{ all: 'unset', cursor: 'pointer', width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: SP.sm }}>
              <span style={{ display: 'flex', alignItems: 'center', gap: SP.sm, minWidth: 0 }}>
                <VStatusPill open />
                <span style={{ color: VR.t3 }}>02:00에 영업 종료</span>
              </span>
              <span style={{ display: 'flex', flexShrink: 0, transform: hours ? 'rotate(180deg)' : 'none', transition: 'transform .22s' }}><VRChev size={15} /></span>
            </button>
            <div style={{ maxHeight: hours ? 230 : 0, overflow: 'hidden', transition: 'max-height .3s ease' }}>
              <div style={{ marginTop: SP.md, display: 'flex', flexDirection: 'column', gap: 9 }}>
                {VR_HOURS.map(([d, h, today]) => {
                  const off = h === '정기휴무';
                  return (
                    <div key={d} style={{ display: 'flex', alignItems: 'center', gap: SP.md }}>
                      <span style={{ width: 18, ...TYPO.caption, lineHeight: '15px', color: today ? VR.t1 : VR.t3, fontWeight: today ? 600 : 400 }}>{d}</span>
                      <span style={{ ...TYPO.caption, lineHeight: '15px', color: off ? RED[500] : today ? VR.t1 : VR.t3, fontWeight: today || off ? 600 : 400 }}>{h}</span>
                      {today && <span style={{ marginLeft: 'auto', ...TYPO.caption, fontSize: 10, lineHeight: '12px', color: VR.lavender, fontWeight: 600, padding: '3px 8px', borderRadius: 6, background: 'rgba(119,49,254,0.22)' }}>오늘</span>}
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        ))}
        {row(ico(VRPATH.ticket), <window.VRFeeLine />)}
        {row(ico(VRPATH.link), <a href="#" onClick={e => e.preventDefault()} style={{ color: VR.link, textDecoration: 'none' }}>{VR_CLUB.sns}</a>, true)}
      </VGlass>
    </div>
  );
}

// ---------- 오늘 라인업 ----------
function VRLineup() {
  return (
    <div>
      <VHead title="오늘 라인업" sub="3팀" href="%5Bv1%5DHOME-009.html" />
      <div style={{ display: 'flex', gap: SP.md, overflowX: 'auto', scrollbarWidth: 'none', margin: `0 -${PAGE_H}px`, padding: `0 ${PAGE_H}px` }}>
        {VR_LINEUP.map(d => (
          <VGlass key={d.n} quiet pad={SP.lg} style={{ width: 140, flexShrink: 0 }}>
            <span style={{ display: 'inline-block', padding: '3px 9px', borderRadius: 99, background: 'rgba(181,255,96,0.14)', border: '1px solid rgba(181,255,96,0.28)', color: LIME[500], fontWeight: 600, fontSize: 12, lineHeight: '14px', letterSpacing: '-0.025em' }}>{d.t}</span>
            <div style={{ ...TYPO.button1, color: VR.t1, marginTop: SP.md }}>{d.n}</div>
            <div style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4, marginTop: 2 }}>{d.g}</div>
          </VGlass>
        ))}
      </div>
    </div>
  );
}

// ---------- 메뉴 ----------
function VRMenu() {
  const items = (window.VRT_MENU_GROUPS ? window.VRT_MENU_GROUPS.signature : []).slice(0, 3);
  return (
    <div>
      <VHead title="메뉴" sub="가격은 달라질 수 있어요" href="%5Bv1%5DCLUB-023.html" action="더보기" />
      <VRMenuRows items={items} />
    </div>
  );
}

// ---------- 사진 ----------
function VRPhotos() {
  return (
    <div>
      <VHead title="사진" sub={`${VR_CLUB.photoCount}장`} href="#" />
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gridTemplateRows: 'repeat(2,1fr)', gap: SP.sm, aspectRatio: '2 / 1' }}>
        {[0, 1, 2, 3, 4].map(i => (
          <div key={i} style={{ position: 'relative', gridColumn: i === 0 ? 'span 2' : 'auto', gridRow: i === 0 ? 'span 2' : 'auto', borderRadius: 10, overflow: 'hidden', background: VR_SHOTS[i % VR_SHOTS.length], border: `1px solid ${VR.quietBorder}` }}>
            <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 32% 26%, rgba(255,255,255,0.20), transparent 62%)' }} />
            {i === 4 && (
              <div style={{ position: 'absolute', inset: 0, background: 'rgba(14,13,18,0.58)', ...VR_BLUR(7), display: 'grid', placeItems: 'center', ...TYPO.button2, color: '#fff' }}>{`${VR_CLUB.photoCount}장`}</div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

// ---------- 리뷰 ----------
function VRReviews() {
  return (
    <div>
      <VHead title="리뷰" sub={`${VR_CLUB.reviews}개`} href="#" />
      <VGlass pad={SP.lg} style={{ display: 'flex', alignItems: 'center', gap: SP.xl }}>
        <div style={{ textAlign: 'center', flexShrink: 0 }}>
          <div style={{ ...TYPO.h1, color: VR.t1 }}>{VR_CLUB.rating}</div>
          <div style={{ display: 'flex', gap: 2, marginTop: 6, justifyContent: 'center' }}>
            {[0, 1, 2, 3, 4].map(i => <VRStar key={i} size={11} c={i < 4 ? LIME[500] : 'rgba(255,255,255,0.18)'} />)}
          </div>
        </div>
        <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 7 }}>
          {[['음악', 92], ['분위기', 78], ['가격', 61]].map(([l, v]) => (
            <div key={l} style={{ display: 'flex', alignItems: 'center', gap: SP.sm }}>
              <span style={{ width: 34, ...TYPO.caption, lineHeight: '14px', color: VR.t3, flexShrink: 0 }}>{l}</span>
              <span style={{ flex: 1, height: 4, borderRadius: 99, background: 'rgba(255,255,255,0.10)', overflow: 'hidden' }}>
                <span style={{ display: 'block', width: `${v}%`, height: '100%', borderRadius: 99, background: LIME[500] }} />
              </span>
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: VR.t4, width: 26, textAlign: 'right', flexShrink: 0 }}>{v}%</span>
            </div>
          ))}
        </div>
      </VGlass>
      <div style={{ display: 'flex', flexDirection: 'column', gap: SP.md, marginTop: SP.md }}>
        {VR_REVIEWS.map(r => (
          <VGlass key={r.id} quiet pad={SP.lg}>
            <div style={{ display: 'flex', alignItems: 'center', gap: SP.sm }}>
              <span style={{ width: 30, height: 30, borderRadius: 99, background: 'linear-gradient(140deg,#7731FE,#B5FF60)', flexShrink: 0 }} />
              <div style={{ minWidth: 0 }}>
                <div style={{ ...TYPO.body4, color: VR.t1, fontWeight: 600 }}>{r.u}</div>
                <div style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{r.d}</div>
              </div>
              <span style={{ marginLeft: 'auto', display: 'flex', gap: 1, flexShrink: 0 }}>
                {[0, 1, 2, 3, 4].map(i => <VRStar key={i} size={11} c={i < r.r ? LIME[500] : 'rgba(255,255,255,0.18)'} />)}
              </span>
            </div>
            <p style={{ ...TYPO.body4, lineHeight: '21px', color: VR.t2, margin: `${SP.md}px 0 0`, textWrap: 'pretty' }}>{r.t}</p>
            <div style={{ display: 'flex', gap: 6, marginTop: SP.md, flexWrap: 'wrap' }}>
              {r.tags.map(t => <span key={t} style={{ padding: '4px 9px', borderRadius: 99, background: VR.tileFill, border: `1px solid ${VR.tileBorder}`, ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: VR.t3 }}>{t}</span>)}
            </div>
          </VGlass>
        ))}
      </div>
      <VButton label="리뷰 작성하기" href="%5Bv1%5DCLUB-028.html" icon={VRPATH.pen} style={{ width: '100%', marginTop: SP.md }} />
    </div>
  );
}

// ---------- 위치 ----------
function VRLocation({ onCopy }) {
  return (
    <div>
      <VHead title="위치" sub={`상수역 422m`} href="%5Bv1%5DPLACE-019.html" action="지도" />
      <a href="%5Bv1%5DPLACE-019.html" style={{ display: 'block', position: 'relative', height: 180, borderRadius: 19, overflow: 'hidden', border: `1px solid ${VR.tileBorder}`, background: 'linear-gradient(150deg,#191622,#23202c)' }}>
        <svg width="100%" height="100%" viewBox="0 0 345 180" preserveAspectRatio="none" style={{ position: 'absolute', inset: 0 }}>
          <defs><pattern id="vrGrid" width="40" height="40" patternUnits="userSpaceOnUse"><path d="M 40 0 L 0 0 0 40" fill="none" stroke="rgba(255,255,255,0.05)" strokeWidth="1" /></pattern></defs>
          <rect width="100%" height="100%" fill="url(#vrGrid)" />
          <line x1="0" y1="92" x2="345" y2="92" stroke="rgba(255,255,255,0.09)" strokeWidth="16" />
          <line x1="186" y1="0" x2="186" y2="180" stroke="rgba(255,255,255,0.09)" strokeWidth="13" />
          <path d="M 0 124 Q 80 124 112 104" stroke="#BDB092" strokeWidth="3" fill="none" opacity="0.9" />
        </svg>
        <div style={{ position: 'absolute', left: 74, top: 84, display: 'flex', alignItems: 'center', gap: 4 }}>
          <span style={{ width: 18, height: 18, borderRadius: 99, background: '#BDB092', color: VR.ink, fontSize: 10, lineHeight: '18px', fontWeight: 700, textAlign: 'center' }}>9</span>
          <span style={{ padding: '2px 7px', borderRadius: 6, background: 'rgba(10,9,14,0.72)', ...VR_BLUR(8), color: '#fff', ...TYPO.caption, lineHeight: '14px' }}>상수역</span>
        </div>
        <div style={{ position: 'absolute', left: '50%', top: '52%', transform: 'translate(-50%,-100%)', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
          <span style={{ padding: '5px 11px', borderRadius: 10, background: PURPLE[500], border: '1px solid rgba(181,255,96,0.40)', color: '#fff', ...TYPO.caption, lineHeight: '14px', fontWeight: 600, whiteSpace: 'nowrap', boxShadow: '0 10px 30px rgba(0,0,0,0.36)' }}>{VR_CLUB.name}</span>
          <svg width="24" height="27" viewBox="0 0 24 27" fill="none"><path d="M12 0C16.4183 0 20 3.58172 20 8C19.9999 10.5544 18.8005 12.8264 16.9365 14.291L13.3867 17.7031C12.6127 18.4469 11.3894 18.4468 10.6152 17.7031L7.06738 14.2959C5.20068 12.8314 4.00008 10.5566 4 8C4 3.58172 7.58172 0 12 0Z" fill={PURPLE[500]} /><circle cx="12" cy="8" r="3" fill="#fff" /></svg>
        </div>
      </a>
      <VGlass quiet pad={SP.lg} style={{ marginTop: SP.md }}>
        <div style={{ display: 'flex', gap: SP.md, alignItems: 'flex-start' }}>
          <span style={{ flexShrink: 0, marginTop: 1 }}><VRIcon d={VRPATH.pin} size={17} c="rgba(255,255,255,0.55)" /></span>
          <div style={{ minWidth: 0, flex: 1 }}>
            <div style={{ ...TYPO.body4, lineHeight: '20px', color: VR.t2 }}>{VR_CLUB.addr}</div>
            <div style={{ ...TYPO.caption, lineHeight: '18px', color: VR.t4, marginTop: 4 }}>지번 {VR_CLUB.jibun}</div>
            <div style={{ ...TYPO.caption, lineHeight: '18px', color: VR.t4 }}>{VR_CLUB.hint}</div>
          </div>
          <button onClick={onCopy} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, width: 34, height: 34, borderRadius: 10, background: VR.tileFill, border: `1px solid ${VR.tileBorder}`, display: 'grid', placeItems: 'center' }}>
            <VRIcon d={VRPATH.copy} size={15} c={VR.t2} />
          </button>
        </div>
        <div style={{ height: 1, background: VR.hair, margin: `${SP.md}px 0` }} />
        <div style={{ display: 'flex', alignItems: 'center', gap: SP.sm }}>
          <span style={{ width: 21, height: 21, borderRadius: 99, background: '#BDB092', color: VR.ink, fontSize: 10, lineHeight: '21px', fontWeight: 700, textAlign: 'center', flexShrink: 0 }}>9</span>
          <span style={{ ...TYPO.body4, color: VR.t2 }}>상수역 1번 출구에서 422m</span>
        </div>
      </VGlass>
    </div>
  );
}

// ---------- 편의시설 ----------
function VRFacilities() {
  return (
    <div>
      <VHead title="편의시설" sub="6가지" />
      <VGlass quiet pad={SP.sm}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: SP.sm }}>
          {VR_FACIL.map(f => (
            <div key={f.l} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: SP.sm, padding: `${SP.md}px 0` }}>
              <span style={{ width: 40, height: 40, borderRadius: 99, background: VR.tileFill, border: `1px solid ${VR.tileBorder}`, display: 'grid', placeItems: 'center' }}>
                <VRIcon d={f.d} size={19} c={LIME[500]} />
              </span>
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: VR.t3, textAlign: 'center' }}>{f.l}</span>
            </div>
          ))}
        </div>
      </VGlass>
    </div>
  );
}

Object.assign(window, { VR_CLUB, VR_SHOTS, VR_HOURS, VR_LINEUP, VR_MENU, VR_REVIEWS, VR_FACIL, VRHero, VRTitle, VRToday, VRLineup, VRMenu, VRPhotos, VRReviews, VRLocation, VRFacilities });
