/* global React, TYPO, GRAY, LIME, PURPLE, COLORS, window */
// ============ VYBE — 찜한 클럽 (Liquid Glass) · shell ============
const { useState: sgState, useEffect: sgEffect } = React;

const SG = {
  ink: '#0e0d12',
  glass: { background: 'rgba(120,120,128,0.16)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)', border: '1px solid rgba(255,255,255,0.10)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.16), 0 10px 30px rgba(0,0,0,0.36)' },
  tile: { background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.12)' },
  bar: { background: 'rgba(14,13,18,0.55)', backdropFilter: 'blur(20px) saturate(180%)', WebkitBackdropFilter: 'blur(20px) saturate(180%)' },
  t1: '#fff', t2: 'rgba(255,255,255,0.82)', t3: 'rgba(255,255,255,0.68)', t4: GRAY[500],
  hair: 'rgba(255,255,255,0.09)',
};
const SG_GRAIN = "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='140'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2'/%3E%3C/filter%3E%3Crect width='140' height='140' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E\")";
const SG_AURORA = ['radial-gradient(80% 300px at 4% 0%, rgba(119,49,254,0.32), transparent 62%)','radial-gradient(70% 260px at 100% 18%, rgba(181,255,96,0.11), transparent 64%)','radial-gradient(95% 380px at 82% 96%, rgba(119,49,254,0.14), transparent 68%)','linear-gradient(180deg, #120f1a 0%, #101013 38%, #0d0c11 100%)'].join(', ');

const SGI = {
  Heart: ({ size = 20, active = true }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={active ? PURPLE[500] : 'none'} stroke={active ? PURPLE[500] : '#fff'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  Star: ({ size = 12, c = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={c} stroke={c} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>),
  Clock: ({ size = 12, c = 'rgba(255,255,255,0.6)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10" /><polyline points="12 6 12 12 16 14" /></svg>),
  Chevron: ({ size = 12, c = 'rgba(255,255,255,0.68)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round"><polyline points="6 9 12 15 18 9" /></svg>),
  Grid: ({ size = 15, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="3" width="7" height="7" /><rect x="14" y="3" width="7" height="7" /><rect x="3" y="14" width="7" height="7" /><rect x="14" y="14" width="7" height="7" /></svg>),
  List: ({ size = 15, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="8" y1="6" x2="21" y2="6" /><line x1="8" y1="12" x2="21" y2="12" /><line x1="8" y1="18" x2="21" y2="18" /><line x1="3" y1="6" x2="3.01" y2="6" /><line x1="3" y1="12" x2="3.01" y2="12" /><line x1="3" y1="18" x2="3.01" y2="18" /></svg>),
  Plus: ({ size = 14, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="5" x2="12" y2="19" /><line x1="5" y1="12" x2="19" y2="12" /></svg>),
  Check: ({ size = 15, c = PURPLE[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>),
  HomeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" /></svg>),
  AroundTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" /></svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  SavedTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  MeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" /></svg>),
};

function SGCard({ children, style, pad = 18, radius = 20 }) {
  return (
    <div style={{ position: 'relative', borderRadius: radius, padding: pad, overflow: 'hidden', flexShrink: 0, ...SG.glass, ...style }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 80% at 12% 0%, rgba(255,255,255,0.10), transparent 58%)', pointerEvents: 'none' }} />
      <div style={{ position: 'relative' }}>{children}</div>
    </div>
  );
}

// ---------- data ----------
const SG_FOLDERS = [
  { key: 'all', label: '전체' },
  { key: 'go', label: '갈 곳', emoji: '✨' },
  { key: 'weekend', label: '주말 후보', emoji: '🎉' },
  { key: 'date', label: '데이트', emoji: '💜' },
  { key: 'gangnam', label: '강남', emoji: '📍' },
];

const SG_CLUBS = [
  { id: 1, name: '어썸레드', area: '홍대', genre: '힙합 클럽', rating: 4.76, savedAt: '오늘 저장', open: true, hours: '02:00에 영업 종료', photo: 'linear-gradient(135deg, #7731FE, #ff4d8d)', folder: 'go', tag: 'VYBE 추천', href: '%5Bv1%5DCLUB-021.html' },
  { id: 2, name: '홍대 클럽 레이저', area: '홍대', genre: '힙합 클럽', rating: 4.5, savedAt: '어제 저장', open: true, hours: '03:00에 영업 종료', photo: 'linear-gradient(135deg, #ff006e, #8338ec)', folder: 'go' },
  { id: 3, name: '버뮤다', area: '홍대', genre: '힙합 클럽', rating: 4.3, savedAt: '3일 전 저장', open: true, hours: '02:00에 영업 종료', photo: 'linear-gradient(135deg, #06ffa5, #3a86ff)', folder: 'weekend' },
  { id: 4, name: '인클', area: '홍대', genre: '힙합 클럽', rating: 4.7, savedAt: '1주 전 저장', open: true, hours: '04:00에 영업 종료', photo: 'linear-gradient(135deg, #fb5607, #ffbe0b)', folder: 'weekend' },
  { id: 5, name: '벨로주', area: '홍대', genre: '재즈 클럽', rating: 4.5, savedAt: '1주 전 저장', open: true, hours: '01:30에 영업 종료', photo: 'linear-gradient(135deg, #2a2d34, #6c757d)', folder: 'date' },
  { id: 6, name: 'OCTAGON', area: '강남', genre: 'EDM 클럽', rating: 4.8, savedAt: '2주 전 저장', open: false, hours: '내일 22:00 오픈', photo: 'linear-gradient(135deg, #2B6BFF, #7731FE)', folder: 'gangnam', tag: 'HOT' },
];

const SG_SORTS = [
  { key: 'recent', label: '최근 찜한 순' },
  { key: 'rating', label: '평점 높은 순' },
  { key: 'name', label: '가나다 순' },
  { key: 'open', label: '영업중 먼저' },
];

Object.assign(window, { SG, SG_GRAIN, SG_AURORA, SGI, SGCard, SG_FOLDERS, SG_CLUBS, SG_SORTS, sgState, sgEffect });
