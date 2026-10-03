/* global React, TYPO, GRAY, LIME, PURPLE, BLUE, window */
// ============ VYBE — 알림 (Liquid Glass) · shell ============
const { useState: ngState, useEffect: ngEffect } = React;

const NG = {
  ink: '#0e0d12',
  glass: { background: 'rgba(120,120,128,0.16)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)', border: '1px solid rgba(255,255,255,0.10)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.16), 0 10px 30px rgba(0,0,0,0.36)' },
  glassQuiet: { background: 'rgba(120,120,128,0.08)', backdropFilter: 'blur(14px) saturate(150%)', WebkitBackdropFilter: 'blur(14px) saturate(150%)', border: '1px solid rgba(255,255,255,0.06)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.08)' },
  tile: { background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.12)' },
  bar: { background: 'rgba(14,13,18,0.55)', backdropFilter: 'blur(20px) saturate(180%)', WebkitBackdropFilter: 'blur(20px) saturate(180%)' },
  t1: '#fff', t2: 'rgba(255,255,255,0.82)', t3: 'rgba(255,255,255,0.68)', t4: GRAY[500],
  hair: 'rgba(255,255,255,0.09)',
};
const NG_GRAIN = "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='140'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2'/%3E%3C/filter%3E%3Crect width='140' height='140' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E\")";
const NG_AURORA = ['radial-gradient(80% 300px at 4% 0%, rgba(119,49,254,0.32), transparent 62%)','radial-gradient(70% 260px at 100% 18%, rgba(181,255,96,0.11), transparent 64%)','radial-gradient(95% 380px at 82% 96%, rgba(119,49,254,0.14), transparent 68%)','linear-gradient(180deg, #120f1a 0%, #101013 38%, #0d0c11 100%)'].join(', ');

const NGI = {
  Back: ({ size = 19, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>),
  Check: ({ size = 14, c = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>),
  Settings: ({ size = 18, c = 'rgba(255,255,255,0.82)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="3" /><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z" /></svg>),
  Ticket: ({ size = 18, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z" /><line x1="13" y1="5" x2="13" y2="19" strokeDasharray="2 3" /></svg>),
  Music: ({ size = 18, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><path d="M9 18V5l12-2v13" /><circle cx="6" cy="18" r="3" /><circle cx="18" cy="16" r="3" /></svg>),
  Tag: ({ size = 17, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z" /><line x1="7" y1="7" x2="7.01" y2="7" /></svg>),
  Heart: ({ size = 17, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={c} stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  Star: ({ size = 17, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill={c} stroke={c} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>),
  User: ({ size = 17, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" /></svg>),
  Megaphone: ({ size = 17, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><path d="M3 11l18-5v12L3 14v-3z" /><path d="M11.6 16.8a3 3 0 1 1-5.8-1.6" /></svg>),
  ChevRight: ({ size = 12, c = 'rgba(255,255,255,0.72)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6" /></svg>),
  Bell: ({ size = 30, c = 'rgba(255,255,255,0.5)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9" /><path d="M13.7 21a2 2 0 0 1-3.4 0" /></svg>),
  HomeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" /></svg>),
  AroundTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" /><circle cx="12" cy="10" r="3" /></svg>),
  SearchTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="7" /><line x1="20" y1="20" x2="16.5" y2="16.5" /></svg>),
  SavedTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill={active ? LIME[500] : 'none'} stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>),
  MeTab: ({ active }) => (<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke={active ? LIME[500] : '#fff'} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4" /><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8" /></svg>),
};

function NGCard({ children, style, pad = 14, radius = 20, quiet = false, sheen = true }) {
  return (
    <div style={{ position: 'relative', borderRadius: radius, padding: pad, overflow: 'hidden', flexShrink: 0, ...(quiet ? NG.glassQuiet : NG.glass), ...style }}>
      {sheen && <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 80% at 12% 0%, rgba(255,255,255,0.10), transparent 58%)', pointerEvents: 'none' }} />}
      <div style={{ position: 'relative' }}>{children}</div>
    </div>
  );
}

// 카테고리 — 라이트한 유리 틴트 + 컬러 아이콘으로 구분
const NG_TYPES = {
  reservation: { Icon: NGI.Ticket,    hue: PURPLE[500], tint: 'rgba(119,49,254,0.22)', ring: 'rgba(119,49,254,0.45)' },
  club:        { Icon: NGI.Music,     hue: LIME[500],   tint: 'rgba(181,255,96,0.16)', ring: 'rgba(181,255,96,0.38)' },
  promo:       { Icon: NGI.Tag,       hue: '#FF5C7A',   tint: 'rgba(255,92,122,0.18)', ring: 'rgba(255,92,122,0.40)' },
  activity:    { Icon: NGI.Heart,     hue: '#5B8CFF',   tint: 'rgba(91,140,255,0.18)', ring: 'rgba(91,140,255,0.40)' },
  review:      { Icon: NGI.Star,      hue: '#FFC94D',   tint: 'rgba(255,201,77,0.16)', ring: 'rgba(255,201,77,0.36)' },
  notice:      { Icon: NGI.Megaphone, hue: 'rgba(255,255,255,0.9)', tint: 'rgba(255,255,255,0.10)', ring: 'rgba(255,255,255,0.20)' },
};

const NG_FILTERS = [
  { key: 'all',         label: '전체' },
  { key: 'reservation', label: '예약·입장' },
  { key: 'club',        label: '클럽 소식' },
  { key: 'promo',       label: '프로모션' },
  { key: 'activity',    label: '활동' },
];

const NG_SECTIONS = [
  { key: 'today',   label: '오늘' },
  { key: 'week',    label: '이번 주' },
  { key: 'earlier', label: '이전' },
];

const NG_NOTIS = [
  { id: 1, type: 'reservation', section: 'today', read: false, time: '12분 전',
    title: '어썸레드 입장이 확정되었어요',
    body: '오늘 23:00 · 2인 · 게스트 입장. 입장 시 예약 코드를 보여주세요.',
    thumb: 'linear-gradient(135deg, #7731FE, #ff4d8d)', cta: '예약 코드 보기', primary: true, href: '%5Bv1%5DCLUB-021.html' },
  { id: 2, type: 'club', section: 'today', read: false, time: '40분 전',
    title: '버뮤다 · 오늘 밤 게스트 DJ',
    body: '찜한 클럽에서 자정부터 DJ SOULSCAPE 단독 셋이 진행돼요.',
    thumb: 'linear-gradient(135deg, #06ffa5, #3a86ff)', href: '%5Bv1%5DCLUB-021.html' },
  { id: 3, type: 'promo', section: 'today', read: false, time: '2시간 전',
    title: '주말 한정 입장권 30% 할인',
    body: '오늘 자정까지 강남 인기 클럽 6곳 입장권을 할인가로 예약하세요.',
    cta: '혜택 보기', href: '%5Bv1%5DHOME-006.html' },
  { id: 4, type: 'activity', section: 'today', read: true, time: '5시간 전',
    title: '회원님의 리뷰가 인기를 얻고 있어요',
    body: '어썸레드에 남긴 리뷰에 좋아요 12개와 댓글 3개가 달렸어요.',
    href: '%5Bv1%5DCLUB-021.html' },
  { id: 5, type: 'reservation', section: 'week', read: true, time: '어제',
    title: '입장 24시간 전 안내',
    body: 'OCTAGON 예약이 내일 22:00로 예정되어 있어요. 드레스 코드를 확인하세요.',
    thumb: 'linear-gradient(135deg, #2B6BFF, #7731FE)', href: '%5Bv1%5DCLUB-021.html' },
  { id: 7, type: 'review', section: 'week', read: true, time: '3일 전',
    title: '다녀온 클럽은 어땠나요?',
    body: '인클에서의 밤, 별점과 한 줄 후기를 남기면 다른 사람들에게 도움이 돼요.',
    cta: '리뷰 남기기', href: '%5Bv1%5DCLUB-028.html' },
  { id: 8, type: 'club', section: 'earlier', read: true, time: '1주 전',
    title: '벨로주에 새 사진 12장이 올라왔어요',
    body: '찜한 재즈 클럽의 최근 분위기를 확인해보세요.',
    thumb: 'linear-gradient(135deg, #2a2d34, #6c757d)', href: '%5Bv1%5DCLUB-021.html' },
  { id: 9, type: 'notice', section: 'earlier', read: true, time: '1주 전',
    title: 'vybe 예약 정책이 업데이트되었어요',
    body: '노쇼 방지를 위한 입장 확정 절차가 추가되었습니다. 자세히 보기.', href: '#' },
];

Object.assign(window, { NG, NG_GRAIN, NG_AURORA, NGI, NGCard, NG_TYPES, NG_FILTERS, NG_SECTIONS, NG_NOTIS, ngState, ngEffect });
