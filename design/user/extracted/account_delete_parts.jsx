/* global React, TYPO, GRAY, LIME, PURPLE, RED, BLUE, window */
// ============ VYBE — 회원 탈퇴 (만류) · 토큰 / 아이콘 / 데이터 ============
const { useState: adState } = React;

const AD = {
  ink: '#0E0D12',
  card: { background: 'rgba(120,120,128,0.16)', border: '1px solid rgba(255,255,255,0.10)', backdropFilter: 'blur(18px) saturate(150%)', WebkitBackdropFilter: 'blur(18px) saturate(150%)', boxShadow: '0 10px 30px rgba(0,0,0,0.36)' },
  quiet: { background: 'rgba(120,120,128,0.08)', border: '1px solid rgba(255,255,255,0.06)', backdropFilter: 'blur(14px) saturate(150%)', WebkitBackdropFilter: 'blur(14px) saturate(150%)' },
  tile: { background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.12)', backdropFilter: 'blur(18px) saturate(150%)', WebkitBackdropFilter: 'blur(18px) saturate(150%)' },
  bar: { background: 'rgba(14,13,18,0.55)', backdropFilter: 'blur(18px) saturate(150%)', WebkitBackdropFilter: 'blur(18px) saturate(150%)' },
  t1: '#fff', t2: 'rgba(255,255,255,0.82)', t3: 'rgba(255,255,255,0.68)', t4: GRAY[500],
  hair: 'rgba(255,255,255,0.09)',
};
const AD_AURORA = ['radial-gradient(120% 90% at -5% -10%, rgba(119,49,254,0.42) 0%, transparent 78%)', 'radial-gradient(120% 90% at 105% -5%, rgba(181,255,96,0.20) 0%, transparent 80%)', 'linear-gradient(180deg,#120F1A 0%, #101013 34%, #0E0D12 100%)'].join(', ');
const AD_GRAIN = "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='140'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2'/%3E%3C/filter%3E%3Crect width='140' height='140' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E\")";

const sv = (p, o = {}) => ({ size = 18, c = '#fff' }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={o.fill || 'none'} stroke={c} strokeWidth={o.sw || 1.9} strokeLinecap="round" strokeLinejoin="round" dangerouslySetInnerHTML={{ __html: p }} />
);

const ADI = {
  Back: sv('<polyline points="15 18 9 12 15 6"/>', { sw: 2.4 }),
  Heart: sv('<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>'),
  Star: sv('<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>'),
  Photo: sv('<rect x="3" y="5" width="18" height="14" rx="2.4"/><circle cx="8.5" cy="10" r="1.6"/><path d="M21 16l-4.5-4.5L7 21"/>'),
  Ticket: sv('<path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z"/><line x1="13" y1="5" x2="13" y2="19" stroke-dasharray="2 3"/>'),
  Glass: sv('<path d="M5 4h14l-1.6 6.2A4 4 0 0 1 13.5 13H12v6"/><line x1="8" y1="19" x2="16" y2="19"/>'),
  Clock: sv('<circle cx="12" cy="12" r="9"/><polyline points="12 7 12 12 15.5 14"/>'),
  Music: sv('<path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>'),
  Megaphone: sv('<path d="M3 11l18-5v12L3 14v-3z"/><path d="M11.6 16.8a3 3 0 1 1-5.8-1.6"/>'),
  Sparkle: sv('<path d="M12 3l2.1 5.4L19.5 10l-5.4 1.6L12 17l-2.1-5.4L4.5 10l5.4-1.6z"/><path d="M18.5 16.5l.9 2.1 2.1.9-2.1.9-.9 2.1-.9-2.1-2.1-.9 2.1-.9z"/>'),
  Check: sv('<polyline points="20 6 9 17 4 12"/>', { sw: 3 }),
  Chev: sv('<polyline points="9 18 15 12 9 6"/>', { sw: 2.6 }),
  Search: sv('<circle cx="11" cy="11" r="7"/><line x1="20" y1="20" x2="16.5" y2="16.5"/>'),
  Bell: sv('<path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/>'),
  Shield: sv('<path d="M12 3l8 3v6c0 4.6-3.3 8.2-8 9-4.7-.8-8-4.4-8-9V6z"/><polyline points="9 12 11 14 15.5 9.5"/>'),
  Msg: sv('<path d="M21 12a8 8 0 0 1-11.6 7.1L3 21l1.9-6.4A8 8 0 1 1 21 12z"/>'),
};

// 내 계정에 쌓인 값 — 개인화 숫자
const AD_ME = { name: '지우', saved: 12, reviews: 7, photos: 15, joined: '2025.03.14', leaveDate: '2026.08.20', reopenDate: '2026.09.19' };

const AD_STATS = [
  { Icon: ADI.Heart, n: AD_ME.saved, unit: '곳', label: '찜한 클럽' },
  { Icon: ADI.Star, n: AD_ME.reviews, unit: '개', label: '내가 쓴 리뷰' },
  { Icon: ADI.Photo, n: AD_ME.photos, unit: '장', label: '리뷰 사진' },
];

// 못 쓰게 되는 기능 — 돈·시간이 직접 걸린 것 우선
const AD_BENEFITS = [
  { Icon: ADI.Ticket, hue: LIME[500], tint: 'rgba(181,255,96,0.14)', ring: 'rgba(181,255,96,0.30)', t: '시간대별 무료입장', d: '오늘 밤 무료로 들어갈 수 있는 클럽, 더는 안 보여요.' },
  { Icon: ADI.Glass, hue: '#8FB5FF', tint: 'rgba(43,107,255,0.16)', ring: 'rgba(43,107,255,0.34)', t: '서비스 음료 정보', d: '테이블당 맥주 6병 같은 조건을 미리 못 봐요.' },
  { Icon: ADI.Clock, hue: '#C8A8FF', tint: 'rgba(119,49,254,0.20)', ring: 'rgba(119,49,254,0.42)', t: '영업시간 · 메뉴판', d: '오늘 여는지, 얼마인지 확인하던 게 사라져요.' },
  { Icon: ADI.Music, hue: '#FF9EDB', tint: 'rgba(255,158,219,0.16)', ring: 'rgba(255,158,219,0.34)', t: '오늘의 라인업', d: '누가 트는지 보고 고르던 게 안 돼요.' },
  { Icon: ADI.Megaphone, hue: '#FFC94D', tint: 'rgba(255,201,77,0.16)', ring: 'rgba(255,201,77,0.34)', t: '이벤트 공지', d: 'VYBE에서만 여는 이벤트 소식을 못 받아요.' },
  { Icon: ADI.Sparkle, hue: LIME[500], tint: 'rgba(181,255,96,0.14)', ring: 'rgba(181,255,96,0.30)', t: 'VYBE PICK', d: '매주 새로 올라오는 큐레이션을 못 봐요.' },
];

// 탈퇴 사유 → 대안
const AD_REASONS = [
  { k: '이용 빈도가 낮아서', Icon: ADI.Bell, t: '알림만 꺼도 괜찮아요', d: '계정은 그대로 두고 알림만 끄면 앱이 조용해져요. 필요할 때 정보는 그대로 남아 있어요.', cta: '알림 설정 열기' },
  { k: '원하는 클럽 정보가 없어서', Icon: ADI.Search, t: '찾는 클럽을 알려 주세요', d: '제보해 주신 클럽은 운영팀이 확인 후 등록해요. 등록되면 알려 드려요.', cta: '클럽 제보하기' },
  { k: '앱 사용이 불편해서', Icon: ADI.Msg, t: '어떤 점이 불편했는지 알려 주세요', d: '어디가 불편했는지 한 줄만 남겨 주시면 다음 업데이트에 반영해요.', cta: '의견 보내기' },
  { k: '개인정보가 걱정돼서', Icon: ADI.Shield, t: '저장되는 정보는 이것뿐이에요', d: '휴대폰 번호, 닉네임, 찜·리뷰 기록만 저장해요. 위치는 앱을 쓰는 동안에만 사용하고 남기지 않아요.', cta: '개인정보 처리방침' },
  { k: '기타', Icon: ADI.Msg, t: '이유를 알려 주시면 도움이 돼요', d: '남겨 주신 내용은 운영팀이 직접 읽어요.', cta: '의견 보내기' },
];

function ADCard({ children, style, pad = 16, radius = 19, quiet = false, sheen = true }) {
  return (
    <div style={{ position: 'relative', borderRadius: radius, padding: pad, overflow: 'hidden', ...(quiet ? AD.quiet : AD.card), ...style }}>
      <div aria-hidden style={{ position: 'absolute', left: 0, right: 0, top: 0, height: 1, background: quiet ? 'rgba(255,255,255,0.08)' : 'rgba(255,255,255,0.18)' }} />
      {sheen && <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'linear-gradient(128deg, rgba(255,255,255,0.10), transparent 46%)', pointerEvents: 'none' }} />}
      <div style={{ position: 'relative' }}>{children}</div>
    </div>
  );
}

function ADSection({ title, sub, children }) {
  return (
    <div style={{ marginTop: 26 }}>
      <div style={{ ...TYPO.h4, color: AD.t1, letterSpacing: '-0.03em' }}>{title}</div>
      {sub && <div style={{ ...TYPO.body4, lineHeight: '20px', color: AD.t4, marginTop: 6 }}>{sub}</div>}
      <div style={{ marginTop: 13 }}>{children}</div>
    </div>
  );
}

Object.assign(window, { AD, AD_AURORA, AD_GRAIN, ADI, AD_ME, AD_STATS, AD_BENEFITS, AD_REASONS, ADCard, ADSection, adState });
