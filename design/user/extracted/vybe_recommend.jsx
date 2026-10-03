/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, PURPLE, LIME, RED, BLUE */
const { useState, useRef } = React;

const C = {
  bg: COLORS.bg,
  surface: GRAY[900],
  purple: PURPLE[500],
  lime: LIME[500]
};

// ============ ICONS ============
const I = {
  Back: ({ size = 24, color = '#fff' }) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="15 18 9 12 15 6" />
  </svg>,
  Share: ({ size = 21, color = '#fff' }) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="18" cy="5" r="3" /><circle cx="6" cy="12" r="3" /><circle cx="18" cy="19" r="3" />
    <line x1="8.6" y1="13.5" x2="15.4" y2="17.5" /><line x1="15.4" y1="6.5" x2="8.6" y2="10.5" />
  </svg>,
  Star: ({ size = 13, color = LIME[500] }) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinejoin="round">
    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
  </svg>,
  Heart: ({ size = 20, active = false }) => <svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
  </svg>,
  Clock: ({ size = 12, color = GRAY[500] }) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="12" cy="12" r="10" /><polyline points="12 6 12 12 16 14" />
  </svg>,
  Spark: ({ size = 14, color = LIME[500] }) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke="none">
    <path d="M12 2l1.8 6.2L20 10l-6.2 1.8L12 18l-1.8-6.2L4 10l6.2-1.8z" />
  </svg>,
  Quote: ({ size = 18, color = PURPLE[500] }) => <svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke="none">
    <path d="M7 7h4v6c0 2.2-1.3 3.6-3.5 4.2l-.5-1.4C8.2 15.4 9 14.6 9 13.5H7zM15 7h4v6c0 2.2-1.3 3.6-3.5 4.2l-.5-1.4c1.2-.4 2-1.2 2-2.3h-2z" />
  </svg>,
  ChevRight: ({ size = 16, color = GRAY[500] }) => <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
    <polyline points="9 18 15 12 9 6" />
  </svg>,
  HomeTab: ({ active }) => <svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" />
  </svg>,
  AroundTab: ({ active }) => <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" />
  </svg>,
  SearchTab: ({ active }) => <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" />
  </svg>,
  SavedTab: ({ active }) => <svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
  </svg>,
  MeTab: ({ active }) => <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
    <circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" />
  </svg>
};

// ============ DATA ============
const CRITERIA = [
  { label: '플로어 분위기', color: '#7731FE', svg: <><path d="M12 2l1.8 6.2L20 10l-6.2 1.8L12 18l-1.8-6.2L4 10l6.2-1.8z"/></>, fill: true },
  { label: '사운드 퀄리티', color: '#2B6BFF', svg: <g stroke="#2B6BFF" strokeWidth="2" strokeLinecap="round" fill="none"><line x1="4" y1="10" x2="4" y2="14"/><line x1="9" y1="6" x2="9" y2="18"/><line x1="14" y1="3" x2="14" y2="21"/><line x1="19" y1="8" x2="19" y2="16"/></g> },
  { label: '최근 리뷰', color: '#B5FF60', svg: <><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></>, fill: true },
  { label: '혼잡도', color: '#FF8A3D', svg: <g stroke="#FF8A3D" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round" fill="none"><circle cx="9" cy="8" r="3"/><path d="M3 20c0-3.3 2.7-6 6-6s6 2.7 6 6"/><path d="M16 6.2a3 3 0 0 1 0 5.6"/><path d="M21 20c0-2.5-1.4-4.6-3.5-5.5"/></g> },
  { label: '재방문율', color: '#FF4D8D', svg: <g stroke="#FF4D8D" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></g> },
];

const FEATURED = {
  id: 1, name: '어썸레드', area: '홍대', genre: '힙합 클럽',
  rating: 4.76, reviews: 1284, match: 98, open: true, hours: '오늘 22:00 오픈 · 05:00 종료',
  bg: 'linear-gradient(135deg, #2b1655 0%, #7731FE 55%, #ff4d8d 100%)',
  tags: ['#사운드맛집', '#힙합성지', '#첫방문추천'],
  reason: '탄탄한 힙합 라인업과 압도적인 사운드 시스템. 처음 클럽을 찾는다면 가장 먼저 추천하는 곳이에요.',
  href: '%5Bv1%5DCLUB-021.html'
};

const RANKED = [
{
  id: 2, rank: 2, name: '버뮤다', area: '홍대', genre: '힙합 클럽',
  rating: 4.62, match: 95, open: true,
  bg: 'linear-gradient(135deg, #06ffa5, #3a86ff)',
  tags: ['#무드맛집', '#새벽감성'],
  reason: '감각적인 조명과 여유로운 플로어. 늦은 밤 무드가 일품이에요.',
  href: '%5Bv1%5DCLUB-021.html'
},
{
  id: 3, rank: 3, name: 'OCTAGON', area: '강남', genre: 'EDM 클럽',
  rating: 4.80, match: 93, open: false,
  bg: 'linear-gradient(135deg, #2B6BFF, #7731FE)',
  tags: ['#EDM성지', '#게스트DJ'],
  reason: '세계적 규모의 EDM 스테이지. 화려한 게스트 라인업이 강점.',
  href: '%5Bv1%5DCLUB-021.html'
},
{
  id: 4, rank: 4, name: '인클', area: '홍대', genre: '힙합 클럽',
  rating: 4.70, match: 91, open: true,
  bg: 'linear-gradient(135deg, #fb5607, #ffbe0b)',
  tags: ['#새벽까지', '#단골만족'],
  reason: '새벽까지 이어지는 에너지. 단골 만족도가 가장 높은 곳.',
  href: '%5Bv1%5DCLUB-021.html'
},
{
  id: 5, rank: 5, name: '벨로주', area: '홍대', genre: '재즈 클럽',
  rating: 4.51, match: 88, open: true,
  bg: 'linear-gradient(135deg, #2a2d34, #6c757d)',
  tags: ['#라이브재즈', '#대화하기좋은'],
  reason: '라이브 재즈와 차분한 무드. 대화하며 즐기기 좋아요.',
  href: '%5Bv1%5DCLUB-021.html'
}];


// ============ HEADER ============
function Header({ scrolled }) {
  return (
    <div style={{
      position: 'absolute', top: 0, left: 0, right: 0, zIndex: 20,
      height: 52, padding: '0 8px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      background: scrolled ? 'rgba(16,16,19,0.9)' : 'transparent',
      backdropFilter: scrolled ? 'blur(16px)' : 'none', WebkitBackdropFilter: scrolled ? 'blur(16px)' : 'none',
      borderBottom: `1px solid ${scrolled ? GRAY[900] : 'transparent'}`,
      transition: 'background .2s, border-color .2s'
    }}>
      <a href="%5Bv1%5DHOME-005.html" style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <I.Back />
      </a>
      <span style={{
        ...TYPO.button1, fontWeight: 700, color: '#fff',
        opacity: scrolled ? 1 : 0, transition: 'opacity .2s'
      }}>VYBE 추천</span>
      <button style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <I.Share />
      </button>
    </div>);

}

// ============ INTRO BAND ============
function Intro() {
  return (
    <div style={{
      position: 'relative', overflow: 'hidden',
      padding: '76px 24px 26px',
      background: 'radial-gradient(150% 120% at 0% 0%, rgba(119,49,254,0.36), transparent 72%), radial-gradient(150% 130% at 100% 8%, rgba(181,255,96,0.18), transparent 72%)'
    }}>
      <div style={{
        display: 'inline-flex', alignItems: 'center', gap: 6,
        padding: '6px 12px', borderRadius: 999, marginBottom: 16,
        background: 'rgba(119,49,254,0.18)', border: `1px solid ${PURPLE[700]}`
      }}>
        <I.Spark size={13} color={LIME[500]} />
        <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: '#fff', letterSpacing: '0.04em', display: 'flex', alignItems: 'center', gap: 5 }}>
          이번 주
          <img src="assets/vybe-logo.png" alt="vybe" style={{ height: 14, display: 'block', transform: 'translateY(0.5px)', objectFit: "contain", width: "38px" }} />
          PICK
        </span>
      </div>

      <h1 style={{
        ...TYPO.h2, fontSize: 30, lineHeight: '36px', fontWeight: 700,
        color: '#fff', margin: '0 0 10px'
      }}>
        오늘 밤, <span style={{ color: LIME[500] }}>실패 없는</span><br />클럽만 골랐어요
      </h1>
      <p style={{ ...TYPO.body3, color: GRAY[400], margin: 0, lineHeight: '22px' }}>
        최근 방문자 리뷰와 분위기 데이터를 분석해<br />VYBE가 직접 큐레이션한 추천 리스트예요.
      </p>

      {/* criteria chips */}
      <div style={{ display: 'flex', gap: 7, flexWrap: 'wrap', marginTop: 18 }}>
        {CRITERIA.map((c) =>
        <span key={c.label} style={{
          ...TYPO.caption, lineHeight: '14px', color: '#fff', fontWeight: 600,
          display: 'inline-flex', alignItems: 'center', gap: 6,
          padding: '7px 12px 7px 9px', borderRadius: 999,
          background: `${c.color}22`, border: `1px solid ${c.color}66`
        }}>
          <span style={{
            width: 18, height: 18, borderRadius: 99, flexShrink: 0,
            background: `${c.color}2b`,
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center'
          }}>
            <svg width="12" height="12" viewBox="0 0 24 24" fill={c.fill ? c.color : 'none'}>{c.svg}</svg>
          </span>
          {c.label}
        </span>
        )}
      </div>
    </div>);

}

// ============ FEATURED HERO (#1) ============
function Featured({ club, saved, onSave }) {
  return (
    <div style={{ padding: '8px 16px 4px' }}>
      <a href={club.href} style={{
        display: 'block', textDecoration: 'none',
        borderRadius: 19, overflow: 'hidden',
        border: `1px solid ${GRAY[800]}`, background: GRAY[900]
      }}>
        {/* image */}
        <div style={{ position: 'relative', height: 230, background: club.bg, overflow: 'hidden' }}>
          <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(80% 100% at 80% 20%, rgba(255,255,255,0.18), transparent 60%)' }} />
          <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(to top, rgba(16,16,19,0.92) 6%, rgba(16,16,19,0.1) 50%, transparent 80%)' }} />

          {/* shine sweep */}
          <div style={{ position: 'absolute', top: 0, bottom: 0, left: 0, width: '40%', overflow: 'hidden', pointerEvents: 'none' }}>
            <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(105deg, transparent, rgba(255,255,255,0.22), transparent)', animation: 'shine 4.5s ease-in-out infinite' }} />
          </div>

          {/* rank badge */}
          <div style={{
            position: 'absolute', top: 14, left: 14,
            display: 'flex', alignItems: 'center', gap: 7,
            padding: '7px 12px 7px 9px', borderRadius: 999,
            background: 'rgba(0,0,0,0.45)', backdropFilter: 'blur(10px)',
            border: '1px solid rgba(255,255,255,0.16)'
          }}>
            <span style={{
              ...TYPO.caption, lineHeight: '14px', fontWeight: 800, letterSpacing: '0.04em',
              background: `linear-gradient(135deg, ${LIME[500]}, #fff)`, WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent'
            }}>NO.1 PICK</span>
          </div>

          {/* match score */}
          <div style={{
            position: 'absolute', top: 14, right: 14,
            display: 'flex', alignItems: 'center', gap: 5,
            padding: '7px 11px', borderRadius: 999,
            background: 'rgba(119,49,254,0.42)', backdropFilter: 'blur(10px)',
            border: `1px solid ${PURPLE[500]}`
          }}>
            <I.Spark size={11} color={LIME[500]} />
            <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: '#fff' }}>VYBE 매치 {club.match}%</span>
          </div>

          {/* name + meta over image */}
          <div style={{ position: 'absolute', left: 18, right: 18, bottom: 16 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 7, marginBottom: 8 }}>
              {club.tags.map((t) =>
              <span key={t} style={{ ...TYPO.caption, lineHeight: '14px', color: LIME[500], fontWeight: 600 }}>{t}</span>
              )}
            </div>
            <h2 style={{ ...TYPO.h2, fontSize: 28, fontWeight: 700, color: '#fff', margin: '0 0 8px' }}>{club.name}</h2>
            <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
              <I.Star size={13} />
              <span style={{ ...TYPO.body4, color: '#fff', fontWeight: 700 }}>{club.rating.toFixed(2)}</span>
              <span style={{ ...TYPO.caption, color: GRAY[400], lineHeight: '14px' }}>리뷰 {club.reviews.toLocaleString()}</span>
              <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
              <span style={{ ...TYPO.caption, color: GRAY[300], lineHeight: '14px' }}>{club.area}</span>
              <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
              <span style={{ ...TYPO.caption, color: GRAY[300], lineHeight: '14px' }}>{club.genre}</span>
            </div>
          </div>
        </div>

        {/* curator note */}
        <div style={{ padding: '16px 18px 18px' }}>
          <div style={{ display: 'flex', gap: 10 }}>
            <div style={{ flexShrink: 0, marginTop: 1 }}><I.Quote size={18} /></div>
            <p style={{ ...TYPO.body4, fontSize: 15, lineHeight: '23px', color: GRAY[200], margin: 0 }}>{club.reason}</p>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 16 }}>
            <div style={{
              flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
              height: 46, borderRadius: 12, background: PURPLE[500],
              ...TYPO.button1, fontWeight: 700, color: '#fff'
            }}>
              상세보기
              <I.ChevRight size={16} color="rgba(255,255,255,0.85)" />
            </div>
            <button onClick={(e) => {e.preventDefault();onSave(club.id);}} style={{
              all: 'unset', cursor: 'pointer',
              width: 46, height: 46, borderRadius: 12, flexShrink: 0,
              background: saved ? 'rgba(119,49,254,0.16)' : GRAY[800],
              border: `1px solid ${saved ? PURPLE[700] : GRAY[800]}`,
              display: 'flex', alignItems: 'center', justifyContent: 'center'
            }}>
              <I.Heart size={20} active={saved} />
            </button>
          </div>
        </div>
      </a>
    </div>);

}

// ============ RANKED ROW ============
function RankRow({ club, saved, onSave, index }) {
  return (
    <a href={club.href} className="rank-row" style={{
      display: 'flex', gap: 14, padding: '16px 20px', textDecoration: 'none',
      borderBottom: `1px solid ${GRAY[900]}`,
      animationDelay: `${index * 60}ms`
    }}>
      {/* rank numeral */}
      <div style={{ width: 22, flexShrink: 0, display: 'flex', justifyContent: 'center', paddingTop: 2 }}>
        <span style={{
          fontFamily: 'Pretendard', fontWeight: 800, fontSize: 22, lineHeight: '24px',
          color: GRAY[700], letterSpacing: '-0.04em'
        }}>{club.rank}</span>
      </div>

      {/* thumbnail */}
      <div style={{
        width: 84, height: 84, borderRadius: 12, flexShrink: 0, position: 'relative', overflow: 'hidden',
        background: club.bg, border: `1px solid ${GRAY[900]}`
      }}>
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 30%, rgba(255,255,255,0.22), transparent 60%)' }} />
        <div style={{
          position: 'absolute', left: 5, bottom: 5,
          padding: '2px 6px', borderRadius: 99,
          background: 'rgba(0,0,0,0.6)', backdropFilter: 'blur(6px)',
          display: 'flex', alignItems: 'center', gap: 3
        }}>
          <I.Star size={9} />
          <span style={{ ...TYPO.caption, color: '#fff', lineHeight: '12px', fontWeight: 700, fontSize: 12 }}>{club.rating.toFixed(2)}</span>
        </div>
      </div>

      {/* content */}
      <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 5 }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8 }}>
          <span style={{ ...TYPO.body3, color: '#fff', fontWeight: 600 }}>{club.name}</span>
          <button onClick={(e) => {e.preventDefault();onSave(club.id);}} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, padding: 2 }}>
            <I.Heart size={19} active={saved} />
          </button>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
          <span style={{
            ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: PURPLE[500]
          }}>매치 {club.match}%</span>
          <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
          <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '14px' }}>{club.area}</span>
          <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
          <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '14px' }}>{club.genre}</span>
          <span style={{ width: 2, height: 2, background: GRAY[600], borderRadius: 99 }} />
          <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 600, color: club.open ? LIME[500] : GRAY[600] }}>
            {club.open ? '영업중' : '영업종료'}
          </span>
        </div>

        <span style={{
          ...TYPO.caption, color: GRAY[400], lineHeight: '18px',
          display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden'
        }}>{club.reason}</span>
      </div>
    </a>);

}

// ============ RANKED SECTION ============
function RankedSection({ clubs, savedSet, onSave }) {
  return (
    <div style={{ marginTop: 8 }}>
      <div style={{ padding: '20px 20px 6px', display: 'flex', alignItems: 'baseline', gap: 8 }}>
        <h3 style={{ ...TYPO.h4, color: '#fff', fontWeight: 700, margin: 0 }}>추천 순위</h3>
        <span style={{ ...TYPO.caption, color: GRAY[500], lineHeight: '16px' }}>2위 — {clubs.length + 1}위</span>
      </div>
      {clubs.map((c, i) =>
      <RankRow key={c.id} club={c} index={i} saved={savedSet.has(c.id)} onSave={onSave} />
      )}
    </div>);

}

// ============ TAB BAR ============
function TabBar() {
  const tabs = [
  { key: 'home', label: '홈', Icon: I.HomeTab, href: '%5Bv1%5DHOME-005.html', active: true },
  { key: 'near', label: '주변', Icon: I.AroundTab, href: '%5Bv1%5DPLACE-019.html' },
  { key: 'search', label: '검색', Icon: I.SearchTab, href: '%5Bv1%5DHOME-006.html' },
  { key: 'saved', label: '찜', Icon: I.SavedTab, href: '%5Bv1%5DPLACE-020.html' },
  { key: 'me', label: '내 정보', Icon: I.MeTab, href: null }];

  return (
    <div style={{
      borderTop: `1px solid ${GRAY[900]}`, background: COLORS.bg,
      padding: '12px 24px 8px', display: 'flex', justifyContent: 'space-between', flexShrink: 0
    }}>
      {tabs.map((t) => {
        const Icon = t.Icon;
        return (
          <a key={t.key} href={t.href || '#'} onClick={(e) => !t.href && e.preventDefault()} style={{
            textDecoration: 'none',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, minWidth: 40
          }}>
            <div style={{ width: 4, height: 4, borderRadius: 99, background: t.active ? LIME[500] : 'transparent', marginBottom: 2 }} />
            <Icon active={!!t.active} />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: t.active ? LIME[500] : '#fff', fontWeight: t.active ? 600 : 400 }}>{t.label}</span>
          </a>);

      })}
    </div>);

}

// ============ SKELETON ============
function Shimmer({ w = '100%', h = 12, r = 6, style = {} }) {
  return (
    <div style={{
      width: w, height: h, borderRadius: r, flexShrink: 0,
      background: `linear-gradient(90deg, ${GRAY[900]} 0px, ${GRAY[800]} 80px, ${GRAY[900]} 160px)`,
      backgroundSize: '360px 100%', animation: 'shimmer 1.3s ease-in-out infinite',
      ...style
    }} />);

}

function Skeleton() {
  return (
    <div style={{ animation: 'fadeIn .2s ease', paddingTop: 76 }}>
      <div style={{ padding: '0 24px 26px', display: 'flex', flexDirection: 'column', gap: 14 }}>
        <Shimmer w={120} h={28} r={999} />
        <Shimmer w="80%" h={30} />
        <Shimmer w="60%" h={18} />
      </div>
      <div style={{ padding: '8px 16px' }}>
        <Shimmer w="100%" h={230} r={20} />
        <div style={{ padding: '16px 4px', display: 'flex', flexDirection: 'column', gap: 12 }}>
          <Shimmer w="90%" h={14} />
          <Shimmer w={'100%'} h={46} r={13} />
        </div>
      </div>
      {[0, 1, 2].map((i) =>
      <div key={i} style={{ display: 'flex', gap: 14, padding: '16px 20px' }}>
          <Shimmer w={22} h={24} />
          <Shimmer w={84} h={84} r={12} />
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 9, paddingTop: 2 }}>
            <Shimmer w="50%" h={14} />
            <Shimmer w="70%" h={11} />
            <Shimmer w="90%" h={11} />
          </div>
        </div>
      )}
    </div>);

}

// ============ ROOT ============
function App() {
  const [loading, setLoading] = useState(true);
  const [scrolled, setScrolled] = useState(false);
  const [savedSet, setSavedSet] = useState(new Set([1]));

  React.useEffect(() => {
    const t = setTimeout(() => setLoading(false), 1300);
    return () => clearTimeout(t);
  }, []);

  const onScroll = (e) => setScrolled(e.target.scrollTop > 40);
  const toggleSave = (id) => setSavedSet((s) => {
    const next = new Set(s);
    next.has(id) ? next.delete(id) : next.add(id);
    return next;
  });

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, position: 'relative',
      color: '#fff', fontFamily: "'Pretendard', sans-serif",
      display: 'flex', flexDirection: 'column', overflow: 'hidden'
    }}>
      <Header scrolled={scrolled} />

      <div onScroll={onScroll} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none' }}>
        {loading ?
        <Skeleton /> :

        <>
            <Intro />
            <Featured club={FEATURED} saved={savedSet.has(FEATURED.id)} onSave={toggleSave} />
            <RankedSection clubs={RANKED} savedSet={savedSet} onSave={toggleSave} />
            <div style={{
            margin: '20px 20px 8px', padding: '16px',
            borderRadius: 14, background: GRAY[900], border: `1px solid ${GRAY[800]}`,
            display: 'flex', alignItems: 'center', gap: 10
          }}>
              <I.Spark size={16} color={LIME[500]} />
              <span style={{ ...TYPO.caption, color: GRAY[400], lineHeight: '17px' }}>
                추천 리스트는 매주 화요일, 최근 방문 데이터를 반영해 새롭게 업데이트돼요.
              </span>
            </div>
            <div style={{ height: 28 }} />
          </>
        }
      </div>

      <TabBar />
    </div>);

}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <IOSDevice dark={true} width={393} height={852}>
    <App />
  </IOSDevice>
);