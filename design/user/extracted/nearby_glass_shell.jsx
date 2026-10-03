/* global React, TYPO, GRAY, LIME, PURPLE, window */
// ============ VYBE — 주변 (Liquid Glass) · shell: tokens / icons / data / map ============
const { useState: ngState, useEffect: ngEffect, useRef: ngRef } = React;

const NG = {
  ink: '#0e0d12',
  glass: { background: 'rgba(120,120,128,0.16)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)', border: '1px solid rgba(255,255,255,0.10)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.16), 0 10px 30px rgba(0,0,0,0.36)' },
  tile: { background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.12)' },
  bar: { background: 'rgba(14,13,18,0.55)', backdropFilter: 'blur(20px) saturate(180%)', WebkitBackdropFilter: 'blur(20px) saturate(180%)' },
  sheet: { background: 'rgba(23,21,31,0.68)', backdropFilter: 'blur(34px) saturate(190%)', WebkitBackdropFilter: 'blur(34px) saturate(190%)' },
  float: { background: 'rgba(20,18,26,0.46)', backdropFilter: 'blur(16px) saturate(180%)', WebkitBackdropFilter: 'blur(16px) saturate(180%)', border: '1px solid rgba(255,255,255,0.16)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.18), 0 8px 22px rgba(0,0,0,0.4)' },
  t1: '#fff', t2: 'rgba(255,255,255,0.82)', t3: 'rgba(255,255,255,0.68)', t4: GRAY[500],
  hair: 'rgba(255,255,255,0.09)',
};
const NG_GRAIN = "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='140'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2'/%3E%3C/filter%3E%3Crect width='140' height='140' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E\")";

// ---------- icons ----------
const NPATH = {
  search: '<circle cx="11" cy="11" r="7"/><line x1="20" y1="20" x2="16.5" y2="16.5"/>',
  close: '<line x1="6" y1="6" x2="18" y2="18"/><line x1="18" y1="6" x2="6" y2="18"/>',
  pin: '<path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>',
  clock: '<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>',
  ticket: '<path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z"/><path d="M13 5v2"/><path d="M13 17v2"/><path d="M13 11v2"/>',
  heart: '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>',
  nav: '<polygon points="3 11 22 2 13 21 11 13 3 11"/>',
  share: '<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>',
  phone: '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.37 1.9.72 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.35 1.85.59 2.81.72A2 2 0 0 1 22 16.92z"/>',
  calendar: '<rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>',
  locate: '<circle cx="12" cy="12" r="3.2"/><line x1="12" y1="2" x2="12" y2="5"/><line x1="12" y1="19" x2="12" y2="22"/><line x1="2" y1="12" x2="5" y2="12"/><line x1="19" y1="12" x2="22" y2="12"/><circle cx="12" cy="12" r="8"/>',
  refresh: '<polyline points="21 3 21 9 15 9"/><path d="M3.5 13a8.5 8.5 0 0 0 15.2 3.6"/><polyline points="3 21 3 15 9 15"/><path d="M20.5 11A8.5 8.5 0 0 0 5.3 7.4"/>',
  plus: '<line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>',
  minus: '<line x1="5" y1="12" x2="19" y2="12"/>',
  walk: '<circle cx="13" cy="4" r="1.6"/><path d="M11 21l1.5-5.5L10 13l1-5 3 1.5 2 2.5"/><path d="M10 8l-2 2-2 4"/><path d="M12.5 15.5L15 18l1 3"/>',
  check: '<polyline points="20 6 9 17 4 12"/>',
  glass: '<path d="M5 4h14l-6 8v6h3v2H8v-2h3v-6z"/>',
  home: '<path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z"/>',
  me: '<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/>',
};
const NGIcon = ({ d, size = 18, c = NG.t2, w = 1.9, fill = 'none' }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={c} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round" dangerouslySetInnerHTML={{ __html: NPATH[d] || d }} />
);
const NGStar = ({ size = 12, c = LIME[500] }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={c} stroke={c} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>
);
const NGChev = ({ dir = 'down', size = 14, c = NG.t3, w = 2.3 }) => {
  const pts = { down: '6 9 12 15 18 9', up: '18 15 12 9 6 15', right: '9 6 15 12 9 18', left: '15 18 9 12 15 6' }[dir];
  return <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth={w} strokeLinecap="round" strokeLinejoin="round"><polyline points={pts} /></svg>;
};

function NGCard({ children, style, pad = 14, radius = 20, onClick }) {
  return (
    <div onClick={onClick} style={{ position: 'relative', borderRadius: radius, padding: pad, overflow: 'hidden', flexShrink: 0, cursor: onClick ? 'pointer' : undefined, ...NG.glass, ...style }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 80% at 12% 0%, rgba(255,255,255,0.10), transparent 58%)', pointerEvents: 'none' }} />
      <div style={{ position: 'relative' }}>{children}</div>
    </div>
  );
}

function NGRound({ children, onClick, size = 44, style }) {
  return (
    <button onClick={onClick} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: size, height: size, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0, ...NG.float, ...style }}>{children}</button>
  );
}

// ---------- data ----------
const NG_CLUBS = [
  { id: 1, name: '어썸레드', area: '홍대', genre: '힙합 클럽', rating: 4.76, reviews: 13, dist: 320, address: '서울 마포구 잔다리로 12 지하 1층', hours: '02:00에 영업 종료', open: true, fee: '0 ~ 10,000원', free: true, drink: true, hot: true, rec: true, x: 38, y: 33, photo: 'linear-gradient(135deg,#7731FE 0%,#c04bd0 52%,#ff5c8a 100%)', href: '%5Bv1%5DCLUB-021.html',
    photos: ['linear-gradient(135deg,#7731FE 0%,#c04bd0 52%,#ff5c8a 100%)', 'linear-gradient(135deg,#2B6BFF,#7731FE)', 'linear-gradient(135deg,#1b1030,#5a2b9e 60%,#b5ff60 160%)'] },
  { id: 2, name: '홍대 클럽 레이저', area: '홍대', genre: 'EDM 클럽', rating: 4.5, reviews: 28, dist: 540, address: '서울 마포구 와우산로 23 지하 1층', hours: '03:00에 영업 종료', open: true, fee: '10,000 ~ 20,000원', free: false, drink: true, hot: true, rec: false, x: 26, y: 57, photo: 'linear-gradient(135deg,#ff006e,#8338ec)', href: '%5Bv1%5DCLUB-021.html',
    photos: ['linear-gradient(135deg,#ff006e,#8338ec)', 'linear-gradient(135deg,#8338ec,#06ffa5)', 'linear-gradient(135deg,#ff4d8d,#2B6BFF)'] },
  { id: 3, name: '버뮤다', area: '합정', genre: '라운지 클럽', rating: 4.3, reviews: 19, dist: 680, address: '서울 마포구 양화로 161 지하 2층', hours: '02:00에 영업 종료', open: true, fee: '0 ~ 15,000원', free: true, drink: false, hot: false, rec: false, x: 67, y: 51, photo: 'linear-gradient(135deg,#06ffa5,#3a86ff)', href: '%5Bv1%5DCLUB-021.html',
    photos: ['linear-gradient(135deg,#06ffa5,#3a86ff)', 'linear-gradient(135deg,#3a86ff,#7731FE)', 'linear-gradient(135deg,#2a2d34,#06ffa5)'] },
  { id: 4, name: '인클', area: '홍대', genre: '힙합 클럽', rating: 4.7, reviews: 41, dist: 720, address: '서울 마포구 동교로 165', hours: '04:00에 영업 종료', open: true, fee: '20,000원', free: false, drink: true, hot: true, rec: true, x: 47, y: 62, photo: 'linear-gradient(135deg,#fb5607,#ffbe0b)', href: '%5Bv1%5DCLUB-021.html',
    photos: ['linear-gradient(135deg,#fb5607,#ffbe0b)', 'linear-gradient(135deg,#ffbe0b,#ff006e)', 'linear-gradient(135deg,#fb5607,#2a0d4a)'] },
  { id: 5, name: '벨로주', area: '상수', genre: '재즈 클럽', rating: 4.5, reviews: 22, dist: 860, address: '서울 마포구 와우산로 19', hours: '01:30에 영업 종료', open: false, fee: '무료', free: true, drink: false, hot: false, rec: false, x: 72, y: 60, photo: 'linear-gradient(135deg,#2a2d34,#6c757d)', href: '%5Bv1%5DCLUB-021.html',
    photos: ['linear-gradient(135deg,#2a2d34,#6c757d)', 'linear-gradient(135deg,#6c757d,#2B6BFF)', 'linear-gradient(135deg,#1a1a1f,#6c757d)'] },
];

const NG_FILTERS = [
  { key: 'open', label: '영업중' },
  { key: 'free', label: '입장료 무료' },
  { key: 'drink', label: '서비스 음료' },
  { key: 'hot', label: '핫플레이스' },
  { key: 'saved', label: '찜한 클럽' },
];
const NG_SORTS = [
  { key: 'rec', label: '추천순' },
  { key: 'dist', label: '거리순' },
  { key: 'rating', label: '평점순' },
  { key: 'review', label: '리뷰 많은순' },
];
const NG_AREAS = [
  { name: '홍대', count: 28, x: 48, y: 38 },
  { name: '합정', count: 19, x: 25, y: 57 },
  { name: '상수', count: 13, x: 68, y: 70 },
];

const ngWalk = (m) => Math.max(1, Math.round(m / 75));
const ngDist = (m) => (m >= 1000 ? `${(m / 1000).toFixed(1)}km` : `${m}m`);

// ---------- map ----------
function NGMapPin({ color = PURPLE[700], size = 26 }) {
  return (
    <svg width={size} height={size * (27 / 24)} viewBox="0 0 24 27" fill="none" style={{ display: 'block', filter: 'drop-shadow(0 5px 10px rgba(0,0,0,0.5))' }}>
      <path d="M12 0C16.4183 0 20 3.58172 20 8C19.9999 10.5544 18.8005 12.8264 16.9365 14.291L13.3867 17.7031C12.6127 18.4469 11.3894 18.4468 10.6152 17.7031L7.06738 14.2959C5.20068 12.8314 4.00008 10.5566 4 8C4 3.58172 7.58172 0 12 0Z" fill={color} />
      <circle cx="12" cy="8" r="3" fill="white" />
    </svg>
  );
}

function NGCrown({ size = 11, c = '#FFD36A' }) {
  return (
    <svg width={size} height={size * (10 / 13)} viewBox="0 0 13 10" fill={c} style={{ display: 'block' }}>
      <path d="M0.7 1.1 L3.4 4.2 L6.5 0.6 L9.6 4.2 L12.3 1.1 L11.2 8.4 C11.15 8.9 10.75 9.3 10.25 9.3 L2.75 9.3 C2.25 9.3 1.85 8.9 1.8 8.4 Z" />
    </svg>
  );
}

// VYBE 추천 프로버티 — 업로드된 추천 아이콘 path 그대로 사용
const NG_CROWN_D = 'M2.5 10V9H9.5V10H2.5ZM2.5 8.25L1.8625 4.2375C1.84583 4.2375 1.827 4.23967 1.806 4.244C1.785 4.24833 1.76633 4.25033 1.75 4.25C1.54167 4.25 1.36467 4.177 1.219 4.031C1.07333 3.885 1.00033 3.708 1 3.5C0.999668 3.292 1.07267 3.115 1.219 2.969C1.36533 2.823 1.54233 2.75 1.75 2.75C1.95767 2.75 2.13483 2.823 2.2815 2.969C2.42817 3.115 2.501 3.292 2.5 3.5C2.5 3.55833 2.49367 3.6125 2.481 3.6625C2.46833 3.7125 2.45383 3.75833 2.4375 3.8L4 4.5L5.5625 2.3625C5.47083 2.29583 5.39583 2.20833 5.3375 2.1C5.27917 1.99167 5.25 1.875 5.25 1.75C5.25 1.54167 5.323 1.3645 5.469 1.2185C5.615 1.0725 5.792 0.999668 6 1C6.208 1.00033 6.38517 1.07333 6.5315 1.219C6.67783 1.36467 6.75067 1.54167 6.75 1.75C6.75 1.875 6.72083 1.99167 6.6625 2.1C6.60417 2.20833 6.52917 2.29583 6.4375 2.3625L8 4.5L9.5625 3.8C9.54583 3.75833 9.53117 3.7125 9.5185 3.6625C9.50583 3.6125 9.49967 3.55833 9.5 3.5C9.5 3.29167 9.573 3.1145 9.719 2.9685C9.865 2.8225 10.042 2.74967 10.25 2.75C10.458 2.75033 10.6352 2.82333 10.7815 2.969C10.9278 3.11467 11.0007 3.29167 11 3.5C10.9993 3.70833 10.9265 3.8855 10.7815 4.0315C10.6365 4.1775 10.4593 4.25033 10.25 4.25C10.2333 4.25 10.2147 4.248 10.194 4.244C10.1733 4.24 10.1545 4.23783 10.1375 4.2375L9.5 8.25H2.5Z';

function NGCrownMark({ size = 12, c = LIME[500] }) {
  return (
    <svg width={size} height={size} viewBox="0 0 12 12" fill="none" style={{ display: 'block' }}>
      <path d={NG_CROWN_D} fill={c} />
    </svg>
  );
}

// 제휴(VYBE 추천) 클럽 핀 — 왕관을 얹은 그라데이션 핀.
// 라임은 '눌린 핀' 전용이므로 평상시엔 핑크→퍼플 그라데이션만 쓴다.
const NG_REC_GRAD = 'ngRecGrad';
function NGRecPin({ selected, size = 26 }) {
  const h = size * (27 / 24), crown = size * 0.54;
  return (
    <div style={{ position: 'relative', width: size, height: h + crown * 0.62, display: 'flex', alignItems: 'flex-end', justifyContent: 'center' }}>
      <svg width={size} height={h} viewBox="0 0 24 27" fill="none" style={{ display: 'block', filter: selected ? 'drop-shadow(0 4px 11px rgba(181,255,96,0.5)) drop-shadow(0 5px 10px rgba(0,0,0,0.5))' : 'drop-shadow(0 4px 11px rgba(187,103,237,0.55)) drop-shadow(0 5px 10px rgba(0,0,0,0.5))', transition: 'filter .2s ease' }}>
        <path d="M12 0C16.4183 0 20 3.58172 20 8C19.9999 10.5544 18.8005 12.8264 16.9365 14.291L13.3867 17.7031C12.6127 18.4469 11.3894 18.4468 10.6152 17.7031L7.06738 14.2959C5.20068 12.8314 4.00008 10.5566 4 8C4 3.58172 7.58172 0 12 0Z" fill={selected ? LIME[500] : `url(#${NG_REC_GRAD})`} />
        <circle cx="12" cy="8" r="3" fill="white" />
      </svg>
      <svg width={crown} height={crown} viewBox="0 0 12 12" style={{ position: 'absolute', top: 0, left: '50%', transform: 'translateX(-50%)', display: 'block', filter: 'drop-shadow(0 1px 2px rgba(0,0,0,0.7))' }}>
        <path d={NG_CROWN_D} fill={selected ? LIME[500] : '#FF9EDB'} stroke="rgba(14,13,18,0.85)" strokeWidth="0.9" strokeLinejoin="round" paintOrder="stroke" />
      </svg>
    </div>
  );
}

function NGMapCanvas() {
  return (
    <svg width="100%" height="100%" viewBox="0 0 393 852" preserveAspectRatio="xMidYMid slice" style={{ position: 'absolute', top: 0, left: 0, right: 0, bottom: -620, display: 'block' }}>
      <defs>
        <linearGradient id="ngBase" x1="0" y1="0" x2="0.6" y2="1">
          <stop offset="0%" stopColor="#15121d" /><stop offset="55%" stopColor="#111017" /><stop offset="100%" stopColor="#0d0c12" />
        </linearGradient>
        <pattern id="ngGrid" width="44" height="44" patternUnits="userSpaceOnUse">
          <path d="M 44 0 L 0 0 0 44" fill="none" stroke="rgba(255,255,255,0.035)" strokeWidth="0.6" />
        </pattern>
      </defs>
      <rect width="393" height="852" fill="url(#ngBase)" />
      <rect width="393" height="852" fill="url(#ngGrid)" />
      <ellipse cx="70" cy="330" rx="104" ry="62" fill="#16261c" opacity="0.62" />
      <ellipse cx="330" cy="176" rx="118" ry="78" fill="#16261c" opacity="0.45" />
      <path d="M-20 604 Q 110 578, 210 622 T 420 578" stroke="#1a2a3d" strokeWidth="34" fill="none" opacity="0.7" />
      <path d="M-20 604 Q 110 578, 210 622 T 420 578" stroke="rgba(120,170,255,0.10)" strokeWidth="1.2" fill="none" />
      {[['M-20 198 Q 200 220, 420 178', 15], ['M-20 424 L 420 444', 12], ['M118 -20 Q 140 400, 96 870', 13], ['M282 -20 Q 262 400, 302 870', 12], ['M30 722 L 380 700', 11]].map(([d, w], i) => (
        <g key={i}><path d={d} stroke="#22202b" strokeWidth={w} fill="none" /><path d={d} stroke="rgba(255,255,255,0.05)" strokeWidth="0.8" fill="none" /></g>
      ))}
      {['M-20 284 L 420 294', 'M-20 364 L 420 374', 'M182 -20 L 202 870', 'M338 -20 L 358 870', 'M-20 512 L 420 520'].map((d, i) => (
        <path key={i} d={d} stroke="#1c1a24" strokeWidth="3.4" fill="none" />
      ))}
      {[[38, 238, 32, 26], [82, 250, 22, 20], [112, 244, 25, 18], [202, 148, 36, 28], [244, 138, 28, 22], [284, 150, 20, 18], [48, 468, 27, 22], [162, 530, 33, 26], [332, 318, 30, 24], [58, 748, 29, 22], [112, 760, 22, 18], [222, 758, 31, 24], [312, 770, 24, 20], [268, 660, 26, 20], [96, 620, 22, 18]].map(([x, y, w, h], i) => (
        <rect key={i} x={x} y={y} width={w} height={h} rx="2.5" fill="#1b1924" stroke="rgba(255,255,255,0.045)" strokeWidth="0.7" />
      ))}
      {[['홍익로', 58, 192], ['와우산로', 238, 418], ['잔다리로', 128, 646], ['양화로', 296, 288]].map(([t, x, y]) => (
        <text key={t} x={x} y={y} fill="rgba(255,255,255,0.22)" fontSize="9.5" fontFamily="Pretendard" letterSpacing="0.2">{t}</text>
      ))}
    </svg>
  );
}

function NGMap({ clubs, selectedId, onSelect, areaMode, onArea, zoom, pan, dragProps }) {
  const { dragging, ...dp } = dragProps;
  return (
    <div {...dp} style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: '#0d0c12', touchAction: 'none', cursor: 'grab' }}>
      <svg width="0" height="0" aria-hidden style={{ position: 'absolute' }}><defs>
        <linearGradient id={NG_REC_GRAD} x1="0" y1="0" x2="1" y2="1"><stop offset="0" stopColor="#FF9EDB" /><stop offset="0.55" stopColor="#BB67ED" /><stop offset="1" stopColor={PURPLE[500]} /></linearGradient>
      </defs></svg>
      <div style={{ position: 'absolute', inset: -40, transform: `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`, transformOrigin: 'center 42%', transition: dragging ? 'none' : 'transform .42s cubic-bezier(0.32,0.72,0,1)' }}>
        <NGMapCanvas />
        {!areaMode && clubs.map(c => {
          const sel = c.id === selectedId;
          return (
            <button key={c.id} onPointerDown={(e) => { e.stopPropagation(); onSelect(c.id); }} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', left: `${c.x}%`, top: `${c.y}%`, transform: `translate(-50%,-100%) scale(${sel ? 1.06 : 1})`, zIndex: sel ? 7 : (c.rec ? 5 : 2), transition: 'transform .22s cubic-bezier(.34,1.56,.64,1)' }}>
              <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 3 }}>
                <span style={{
                  display: 'flex', flexDirection: 'column', alignItems: 'center', gap: sel ? 1 : 0,
                  padding: sel ? '6px 12px 6.5px' : '4px 9px', borderRadius: sel ? 13 : 9, whiteSpace: 'nowrap',
                  background: sel ? `linear-gradient(135deg, ${LIME[500]}, ${LIME[700]})` : (c.rec ? 'linear-gradient(135deg, #FF9EDB, #BB67ED 55%, #7731FE)' : 'linear-gradient(135deg, rgba(119,49,254,0.96), rgba(98,42,207,0.86))'),
                  border: `1px solid ${sel ? 'rgba(255,255,255,0.55)' : (c.rec ? 'rgba(255,255,255,0.45)' : 'rgba(255,255,255,0.24)')}`,
                  boxShadow: sel ? '0 10px 26px rgba(181,255,96,0.45), inset 0 1px 0 rgba(255,255,255,0.45)' : (c.rec ? '0 8px 20px rgba(187,103,237,0.45), inset 0 1px 0 rgba(255,255,255,0.35)' : '0 6px 16px rgba(98,42,207,0.5), inset 0 1px 0 rgba(255,255,255,0.28)'),
                  transition: 'padding .2s ease, border-radius .2s ease',
                }}>
                  <span style={{ fontSize: sel ? 12.5 : 12, lineHeight: sel ? '15px' : '14px', fontWeight: sel || c.rec ? 800 : 700, letterSpacing: '-0.03em', color: sel ? NG.ink : '#fff' }}>{c.name}</span>
                  {sel && (
                    <span style={{ display: 'flex', alignItems: 'center', gap: 3.5, animation: 'fadeIn .2s ease' }}>
                      <NGStar size={9} c="rgba(14,13,18,0.82)" />
                      <span style={{ fontSize: 10.5, lineHeight: '13px', fontWeight: 800, letterSpacing: '-0.02em', color: NG.ink }}>{c.rating.toFixed(1)}</span>
                      <span style={{ fontSize: 10.5, lineHeight: '13px', fontWeight: 500, color: 'rgba(14,13,18,0.6)' }}>({c.reviews})</span>
                      <span style={{ width: 1, height: 8, background: 'rgba(14,13,18,0.28)', margin: '0 1px' }} />
                      <span style={{ width: 4.5, height: 4.5, borderRadius: 99, background: c.open ? 'rgba(14,13,18,0.8)' : 'rgba(14,13,18,0.32)' }} />
                      <span style={{ fontSize: 10.5, lineHeight: '13px', fontWeight: 700, letterSpacing: '-0.02em', color: c.open ? NG.ink : 'rgba(14,13,18,0.5)' }}>{c.open ? '영업중' : '영업종료'}</span>
                    </span>
                  )}
                </span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'center' }}>
                {c.rec ? <NGRecPin selected={sel} /> : <NGMapPin color={sel ? LIME[500] : PURPLE[700]} />}
              </div>
            </button>
          );
        })}
        {areaMode && NG_AREAS.map(a => {
          const size = 54 + Math.min(a.count, 40) * 0.55;
          return (
            <button key={a.name} onPointerDown={(e) => { e.stopPropagation(); onArea(a); }} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', left: `${a.x}%`, top: `${a.y}%`, transform: 'translate(-50%,-50%)', zIndex: 3 }}>
              <div style={{ position: 'absolute', left: '50%', top: '50%', transform: 'translate(-50%,-50%)', width: size + 26, height: size + 26, borderRadius: '50%', background: 'rgba(119,49,254,0.20)', animation: 'ngHalo 2.6s ease-in-out infinite' }} />
              <div style={{ position: 'relative', width: size, height: size, borderRadius: '50%', background: 'radial-gradient(circle at 34% 28%, rgba(160,110,255,0.95), rgba(78,36,160,0.9))', border: '1.5px solid rgba(255,255,255,0.5)', boxShadow: '0 10px 28px rgba(98,42,207,0.55), inset 0 1px 0 rgba(255,255,255,0.4)', backdropFilter: 'blur(6px)', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', color: '#fff' }}>
                <span style={{ fontSize: 12, lineHeight: '13px', fontWeight: 600, opacity: 0.9, letterSpacing: '-0.025em' }}>{a.name}</span>
                <span style={{ fontSize: 20, fontWeight: 800, lineHeight: '22px', letterSpacing: '-0.025em' }}>{a.count}</span>
              </div>
            </button>
          );
        })}
        <div style={{ position: 'absolute', left: '50%', top: '38%', transform: 'translate(-50%,-50%)', zIndex: 4 }}>
          <div style={{ position: 'absolute', inset: -11, borderRadius: '50%', background: 'rgba(0,134,255,0.28)', animation: 'ngPulse 2s ease-in-out infinite' }} />
          <div style={{ width: 18, height: 18, borderRadius: '50%', background: '#0086FF', border: '3px solid #fff', boxShadow: '0 0 14px rgba(0,134,255,0.7)', position: 'relative' }} />
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { NG, NG_GRAIN, NGIcon, NGStar, NGChev, NGCard, NGRound, NGMap, NGMapPin, NGCrown, NGCrownMark, NG_CROWN_D, NGRecPin, NG_CLUBS, NG_FILTERS, NG_SORTS, NG_AREAS, ngWalk, ngDist, ngState, ngEffect, ngRef });
