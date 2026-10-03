/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, PURPLE, RED, window, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, VGlass, VHead, VButton, VGlassRound, VToast, VFadeUp, MRPATH, MR_ME, MR_PROVIDER_LABEL, MR_REVIEWS, MRAvatar, MRReviewsScreen, MREditScreen, MRSettingsScreen, MRLeaveScreen, VAurora, vrState, vrRef */
// ============ VYBE — My · Renewal · page ============

const MR_SAVED = 28;   // 찜한 클럽 수 — 통계·활동·탈퇴 화면이 같은 값을 쓴다

// ---------- 프로필 ----------
function MRProfile() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: SP.lg }}>
      <MRAvatar size={76} gender={MR_ME.gender} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ ...TYPO.h4, fontSize: 20, color: VR.t1 }}>{MR_ME.name}</div>
        <div style={{ ...TYPO.body4, color: VR.t4, marginTop: 4 }}>{MR_PROVIDER_LABEL[MR_ME.provider] || ''}</div>
      </div>
    </div>
  );
}

// ---------- 통계 ----------
function MRStats({ reviews, onReviews }) {
  const items = [
    { label: '리뷰', value: reviews, onClick: onReviews },
    { label: '찜', value: MR_SAVED, href: '%5Bv1%5DPLACE-020.html' },
  ];
  return (
    <VGlass quiet pad={0} style={{ display: 'flex' }}>
      {items.map((it, i) => {
        const inner = <>
          <span style={{ ...TYPO.h4, fontSize: 22, color: VR.t1, letterSpacing: '-0.02em' }}>{it.value}</span>
          <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{it.label}</span>
        </>;
        const base = { flex: 1, boxSizing: 'border-box', padding: `${SP.lg}px 0`, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, textDecoration: 'none', cursor: it.onClick || it.href ? 'pointer' : 'default' };
        return (
          <React.Fragment key={it.label}>
            {i > 0 && <div style={{ width: 1, background: VR.hair, margin: `${SP.md}px 0` }} />}
            {it.href ? <a href={it.href} style={base}>{inner}</a>
              : it.onClick ? <button onClick={it.onClick} style={{ all: 'unset', ...base }}>{inner}</button>
                : <div style={base}>{inner}</div>}
          </React.Fragment>
        );
      })}
    </VGlass>
  );
}

// ---------- 리스트 행 ----------
function MRRow({ icon, label, value, onClick, href, danger, last }) {
  const c = danger ? RED[500] : VR.t1;
  const inner = <>
    <span style={{ width: 34, height: 34, borderRadius: '50%', flexShrink: 0, background: danger ? 'rgba(255,92,95,0.12)' : VR.tileFill, border: `1px solid ${danger ? 'rgba(255,92,95,0.26)' : VR.tileBorder}`, display: 'grid', placeItems: 'center' }}>
      <VRIcon d={icon} size={17} c={danger ? RED[500] : VR.t2} />
    </span>
    <span style={{ flex: 1, minWidth: 0, ...TYPO.body3, fontWeight: 500, color: c }}>{label}</span>
    {value != null && <span style={{ ...TYPO.body4, color: VR.t4 }}>{value}</span>}
    {!danger && <VRChev dir="right" size={16} c="rgba(255,255,255,0.32)" />}
  </>;
  const base = { display: 'flex', alignItems: 'center', gap: SP.md, width: '100%', boxSizing: 'border-box', padding: `${SP.md}px 0`, textDecoration: 'none', cursor: 'pointer', borderBottom: last ? 'none' : `1px solid ${VR.hair}` };
  return href ? <a href={href} style={base}>{inner}</a> : <button onClick={onClick} style={{ all: 'unset', ...base }}>{inner}</button>;
}

// ---------- 하단 탭 ----------
const MR_TABS = [
  { key: 'home', label: '홈', href: '%5Bv1%5DHOME-005.html', d: '<path d="M3 10.5L12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z"/>' },
  { key: 'near', label: '주변', href: '%5Bv1%5DPLACE-019.html', d: VRPATH.pin },
  { key: 'search', label: '검색', href: '%5Bv1%5DHOME-006.html', d: '<circle cx="11" cy="11" r="7"/><line x1="20" y1="20" x2="16.5" y2="16.5"/>' },
  { key: 'saved', label: '찜', href: '%5Bv1%5DPLACE-020.html', d: VRPATH.heart },
  { key: 'me', label: '내 정보', href: null, d: MRPATH.user, active: true },
];

function MRTabBar() {
  return (
    <div style={{ flexShrink: 0, padding: '12px 24px 30px', background: VR.barFill, ...VR_BLUR(20), borderTop: `1px solid ${VR.hair}`, display: 'flex', justifyContent: 'space-between' }}>
      {MR_TABS.map(t => (
        <a key={t.key} href={t.href || '#'} onClick={e => !t.href && e.preventDefault()} style={{ textDecoration: 'none', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, minWidth: 40 }}>
          <span style={{ width: 4, height: 4, borderRadius: 99, background: t.active ? LIME[500] : 'transparent', marginBottom: 2 }} />
          <VRIcon d={t.d} size={23} c={t.active ? LIME[500] : '#fff'} w="1.7" fill={t.active && t.key !== 'me' ? LIME[500] : 'none'} />
          <span style={{ ...TYPO.caption, lineHeight: '14px', color: t.active ? LIME[500] : '#fff', fontWeight: t.active ? 600 : 400 }}>{t.label}</span>
        </a>
      ))}
    </div>
  );
}

// ---------- 루트 ----------
function MyRenewApp() {
  const [view, setView] = vrState('main');
  const [reviews, setReviews] = vrState(MR_REVIEWS);
  const [y, setY] = vrState(0);
  const [toast, setToast] = vrState('');
  const say = (m) => { setToast(m); clearTimeout(window.__mrT); window.__mrT = setTimeout(() => setToast(''), 1800); };

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', overflow: 'hidden', background: VR.ink, color: VR.t1, fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column' }}>
      <VAurora />

      <div onScroll={e => setY(e.currentTarget.scrollTop)} style={{ position: 'relative', flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: `${54 + SP.xxl}px ${PAGE_H}px 40px`, display: 'flex', flexDirection: 'column', gap: SP.xxl }}>
        <VFadeUp i={0}><MRProfile /></VFadeUp>
        <VFadeUp i={1}><MRStats reviews={reviews.length} onReviews={() => setView('reviews')} /></VFadeUp>

        <VFadeUp i={2}>
          <VHead title="내 활동" />
          <MRRow icon={MRPATH.review} label="내 리뷰 관리" value={reviews.length} onClick={() => setView('reviews')} />
          <MRRow icon={MRPATH.heart} label="찜한 클럽" value={MR_SAVED} href="%5Bv1%5DPLACE-020.html" last />
        </VFadeUp>

        <VFadeUp i={3}>
          <VHead title="계정" />
          <MRRow icon={MRPATH.bell} label="알림" href="%5Bv1%5DHOME-007.html" />
          <MRRow icon={MRPATH.mega} label="공지사항" href="%5Bv1%5DHOME-008.html" />
          <MRRow icon={MRPATH.gear} label="설정" onClick={() => setView('settings')} />
          <MRRow icon={MRPATH.logout} label="로그아웃" href="%5Bv1%5DAUTH-002.html" danger last />
        </VFadeUp>

        <div style={{ textAlign: 'center', ...TYPO.caption, lineHeight: '16px', color: VR.t4 }}>vybe · 버전 v2.4.1</div>
      </div>

      <MRTabBar />

      {view === 'reviews' && <MRReviewsScreen onBack={() => setView('main')} reviews={reviews} onDelete={id => setReviews(rs => rs.filter(r => r.id !== id))} toast={say} />}
      {view === 'edit' && <MREditScreen onBack={() => setView('main')} onSave={() => { setView('main'); say('프로필을 저장했어요'); }} />}
      {view === 'settings' && <MRSettingsScreen onBack={() => setView('main')} toast={say} onLeave={() => setView('leave')} />}
      {view === 'leave' && <MRLeaveScreen onBack={() => setView('settings')} toast={say} reviews={reviews.length} saved={MR_SAVED} />}

      <VToast msg={toast} />
    </div>
  );
}

const mrRoot = ReactDOM.createRoot(document.getElementById('root'));
mrRoot.render(
  <IOSDevice dark={true} width={393} height={852}>
    <MyRenewApp />
  </IOSDevice>
);
