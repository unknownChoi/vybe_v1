/* global React, TYPO, LIME, PURPLE, FG, FGCard, window */
// ============ VYBE · 서비스음료 (리뉴얼) — 액센트 토큰 + 음료 아이콘 + 데이터 ============
// 글래스 토큰(FG/FGCard/FGRound/FeHead/FeMeta/FeOpen)은 free_entry_renew_parts.jsx 공용 사용

/* 액센트 — design_system.html 팔레트만 사용 (라임 포인트 · 퍼플 서브) */
const SD = {
  point: LIME[500], onPoint: '#12210a',
  soft: 'rgba(181,255,96,0.11)', line: 'rgba(181,255,96,0.30)', strongLine: 'rgba(181,255,96,0.48)',
  sub: '#C8A8FF', subFill: PURPLE[500], subSoft: 'rgba(119,49,254,0.16)', subLine: 'rgba(119,49,254,0.40)',
};

const SD_AURORA = 'radial-gradient(110% 80% at 0% 0%,rgba(119,49,254,0.42),transparent 74%),radial-gradient(110% 80% at 100% 2%,rgba(181,255,96,0.20),transparent 74%),radial-gradient(120% 90% at 86% 100%,rgba(119,49,254,0.18),transparent 76%),linear-gradient(180deg,#120F1A 0%,#101013 40%,#0E0D12 100%)';

const SDI = {
  Bottle: ({ size = 16, color = '#fff', fill = false }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={fill ? color : 'none'} stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M10 2h4v3.2l1.4 2.6a3 3 0 0 1 .35 1.4V20a2 2 0 0 1-2 2h-3.5a2 2 0 0 1-2-2V9.2a3 3 0 0 1 .35-1.4L10 5.2z" />{!fill && <line x1="8.3" y1="13" x2="15.7" y2="13" />}</svg>),
  Champagne: ({ size = 16, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M9 2h6l-.7 8.2a2.4 2.4 0 0 1-4.6 0z" /><line x1="12" y1="13" x2="12" y2="21" /><line x1="9" y1="21" x2="15" y2="21" /></svg>),
  Cocktail: ({ size = 16, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M5 5h14l-7 8z" /><line x1="12" y1="13" x2="12" y2="20" /><line x1="8" y1="20" x2="16" y2="20" /></svg>),
  Beer: ({ size = 16, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M6 8h9v12a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2z" /><path d="M15 11h2.4a1.6 1.6 0 0 1 1.6 1.6v3a1.6 1.6 0 0 1-1.6 1.6H15" /><path d="M6 8c0-2 1.5-3 3-3s1.3-1.4 3-1.4S15 6 15 8" /></svg>),
  Wine: ({ size = 16, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M8 3h8v3.5a4 4 0 0 1-8 0z" /><line x1="12" y1="14" x2="12" y2="21" /><line x1="8.5" y1="21" x2="15.5" y2="21" /></svg>),
  Cup: ({ size = 14, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><path d="M5 4h14l-7 8z" /><line x1="12" y1="12" x2="12" y2="20" /><line x1="8" y1="20" x2="16" y2="20" /></svg>),
  Chevron: ({ size = 14, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9" /></svg>),
  Arrow: ({ size = 13, color = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 6 15 12 9 18" /></svg>),
  People: ({ size = 12, color = 'rgba(255,255,255,0.6)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="9" cy="8" r="3.4" /><path d="M2.5 21c0-3.6 2.9-6.5 6.5-6.5s6.5 2.9 6.5 6.5" /><path d="M16.5 5.2a3.4 3.4 0 0 1 0 6.4M18 14.8c2.1.9 3.5 3 3.5 5.4" /></svg>),
  Time: ({ size = 12, color = 'rgba(255,255,255,0.6)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><polyline points="12 7 12 12 16 14" /></svg>),
  Info: ({ size = 13, color = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><line x1="12" y1="11" x2="12" y2="16.5" /><line x1="12" y1="7.6" x2="12" y2="7.7" /></svg>),
};

// ---------- 데이터 ----------
const SD_LOC = '홍대입구역';

const SD_CLUBS = [
  { id: 1, name: '어썸레드', area: '홍대', genre: '힙합', dist: 0.4, walk: 6, rating: 4.58, open: true, tier: 'welcome', perk: '웰컴 샷 + 음료 1잔', drinks: ['양주', '칵테일'], bg: 'linear-gradient(140deg,#7731FE,#ff5c8a)' },
  { id: 2, name: 'OCTAGON', area: '강남', genre: 'EDM', dist: 5.2, walk: 62, rating: 4.82, open: true, tier: 'bottle', perk: '양주 1병 + 웰컴드링크', drinks: ['양주', '샴페인', '칵테일'], bg: 'linear-gradient(140deg,#2B6BFF,#7731FE 70%,#B5FF60 165%)' },
  { id: 3, name: '버뮤다', area: '홍대', genre: '힙합', dist: 0.7, walk: 10, rating: 4.49, open: true, tier: 'unlimited', perk: '1인 음료 무제한', drinks: ['칵테일', '맥주'], bg: 'linear-gradient(140deg,#06ffa5,#3a86ff)' },
  { id: 4, name: '인클', area: '홍대', genre: '힙합', dist: 0.5, walk: 7, rating: 4.44, open: false, tier: 'bottle', perk: '테이블당 맥주 6병', drinks: ['맥주'], bg: 'linear-gradient(140deg,#fb5607,#ffbe0b)' },
  { id: 5, name: '메이드', area: '이태원', genre: 'EDM', dist: 6.1, walk: 74, rating: 4.74, open: true, tier: 'bottle', perk: '테이블 샴페인 1병', drinks: ['샴페인', '맥주'], bg: 'linear-gradient(140deg,#ff006e,#8338ec)' },
  { id: 6, name: '소다', area: '강남', genre: '하우스', dist: 5.4, walk: 66, rating: 4.55, open: true, tier: 'welcome', perk: '1인 칵테일 2잔 무료', drinks: ['칵테일', '맥주'], bg: 'linear-gradient(140deg,#3a0ca3,#4361ee)' },
  { id: 7, name: '케이크샵', area: '이태원', genre: '테크노', dist: 6.3, walk: 76, rating: 4.40, open: true, tier: 'welcome', perk: '웰컴 칵테일 1잔', drinks: ['칵테일'], bg: 'linear-gradient(140deg,#0f2b2a,#1b9aaa)' },
  { id: 8, name: '글로우', area: '압구정', genre: 'EDM', dist: 4.2, walk: 52, rating: 4.61, open: true, tier: 'conditional', perk: '입장 시 양주 1병', drinks: ['양주', '칵테일'], bg: 'linear-gradient(140deg,#f72585,#b5179e)' },
  { id: 9, name: '하이브', area: '건대', genre: '힙합', dist: 3.1, walk: 41, rating: 4.31, open: false, tier: 'conditional', perk: '입장 시 맥주 2병', drinks: ['맥주'], bg: 'linear-gradient(140deg,#ffbe0b,#fb5607)' },
  { id: 10, name: '벨로주', area: '홍대', genre: '재즈', dist: 0.9, walk: 12, rating: 4.36, open: true, tier: 'welcome', perk: '웰컴 와인 1잔', drinks: ['와인'], bg: 'linear-gradient(140deg,#6d4c91,#2a2d34)' },
  { id: 11, name: '라운지 온', area: '한남', genre: '라운지', dist: 5.8, walk: 70, rating: 4.28, open: true, tier: 'unlimited', perk: '하우스 와인 무제한', drinks: ['와인', '맥주'], bg: 'linear-gradient(140deg,#5b2333,#a8577a)' },
  { id: 12, name: '미드나잇', area: '강남', genre: 'EDM', dist: 4.9, walk: 59, rating: 4.47, open: true, tier: 'conditional', perk: '생일자 샴페인 1병', drinks: ['샴페인', '칵테일'], bg: 'linear-gradient(140deg,#2047A1,#7731FE 145%)' },
];

// 1섹션 — 음료 종류
const SD_TYPES = [
  { key: '양주', Icon: SDI.Bottle, desc: '위스키·보드카 등 병 단위로 제공돼요', unit: '병' },
  { key: '샴페인', Icon: SDI.Champagne, desc: '테이블 예약 혜택으로 가장 많이 나와요', unit: '병' },
  { key: '칵테일', Icon: SDI.Cocktail, desc: '입장 웰컴 드링크로 잔 단위 제공', unit: '잔' },
  { key: '맥주', Icon: SDI.Beer, desc: '병·잔 단위, 무제한 매장도 있어요', unit: '병' },
  { key: '와인', Icon: SDI.Wine, desc: '라운지·재즈 계열 매장에서 제공', unit: '잔' },
];

const sdByType = (t) => SD_CLUBS.filter(c => c.drinks.includes(t)).sort((a, b) => a.dist - b.dist);

// 2섹션 — 무료 혜택 4종
const SD_PERKS = [
  {
    key: 'welcome', name: '웰컴 드링크', Icon: SDI.Cocktail, tone: SD.point,
    sum: '입장하면 1인 1잔', head: '입장 팔찌를 받고 바에서 바로 교환',
    gives: ['칵테일·맥주·소프트드링크 중 택 1', '1인 1잔, 동반 인원 전원 지급', '매장에 따라 웰컴 샷 추가 제공'],
    cond: '입장객 전원', when: '입장 직후 ~ 영업 종료 전까지',
  },
  {
    key: 'bottle', name: '테이블 주류 1병', Icon: SDI.Bottle, tone: SD.point,
    sum: '테이블 예약 시 병 제공', head: '예약 확정된 테이블에 세팅되어 나와요',
    gives: ['양주 또는 샴페인 1병 (매장 지정)', '믹서·얼음·기본 안주 포함', '맥주 6병으로 교체 가능한 매장도 있어요'],
    cond: '4인 이상 테이블 예약', when: '테이블 입장 시 세팅',
  },
  {
    key: 'unlimited', name: '음료 무제한', Icon: SDI.Beer, tone: SD.point,
    sum: '지정 시간 동안 프리 드링크', head: '정해진 시간 안에서는 잔 수 제한이 없어요',
    gives: ['생맥주·하우스 와인·소프트드링크 무제한', '양주·샴페인은 제외', '1회 1잔씩 바에서 수령'],
    cond: '무제한 팔찌 착용자', when: '오픈 ~ 새벽 1시',
  },
  {
    key: 'conditional', name: '조건부 혜택', Icon: SDI.Champagne, tone: SD.sub,
    sum: '조건이 맞으면 추가 지급', head: '생일·인증·요일 조건을 확인해 주세요',
    gives: ['생일 당일 본인 샴페인 1병 (신분증 확인)', '여성 전원 칵테일 2잔', 'SNS 스토리 인증 시 맥주 2병'],
    cond: '신분증 또는 인증 필요', when: '조건 충족 시 현장 확인 후',
  },
];

const sdByTier = (k) => SD_CLUBS.filter(c => c.tier === k);

// 지도 섹션 — 홍대입구역 1.5km 이내 (x/y = 지도 내 상대 위치 %)
const SD_MAP_XY = { 1: [33, 54], 4: [67, 32], 3: [72, 67], 10: [27, 78] };
const SD_NEAR = SD_CLUBS
  .filter(c => SD_MAP_XY[c.id])
  .map(c => ({ ...c, x: SD_MAP_XY[c.id][0], y: SD_MAP_XY[c.id][1] }))
  .sort((a, b) => a.dist - b.dist);

Object.assign(window, { SD, SD_AURORA, SDI, SD_LOC, SD_CLUBS, SD_TYPES, SD_PERKS, sdByType, sdByTier, SD_NEAR });
