/* global React, TYPO, LIME, PURPLE, window */
// ============ VYBE — 홈 진입 팝업 광고 (Liquid Glass) ============
// 운영자가 등록한 광고 1건. 정사각 사진 + 글래스 하단 바 (1주일동안 안보기 · 닫기)
// 브랜드: PURPLE 500 #7731FE (광채/테두리) · LIME 500 #B5FF60 (액센트)
const { useState: adState, useEffect: adEffect } = React;

const AD_KEY = 'vybe.homeAdPopup.hideUntil';
const AD_WEEK = 7 * 24 * 60 * 60 * 1000;
const AD = { href: '%5Bv1%5DHOME-008.html', src: 'assets/ad-dj-soulbeat.png' };

// 앱 공통 글래스 토큰 (nearby_glass_shell.jsx NG와 동일 값)
const AG = {
  sheet: { background: 'rgba(23,21,31,0.68)', backdropFilter: 'blur(34px) saturate(190%)', WebkitBackdropFilter: 'blur(34px) saturate(190%)' },
  float: { background: 'rgba(20,18,26,0.46)', backdropFilter: 'blur(16px) saturate(180%)', WebkitBackdropFilter: 'blur(16px) saturate(180%)', border: '1px solid rgba(255,255,255,0.16)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.18), 0 8px 22px rgba(0,0,0,0.4)' },
  spec: 'radial-gradient(110% 80% at 12% 0%, rgba(255,255,255,0.10), transparent 58%)',
  hair: 'rgba(255,255,255,0.09)',
  edge: 'rgba(255,255,255,0.10)',
  t1: '#fff', t3: 'rgba(255,255,255,0.68)',
};

// 체크박스 — 미선택 (탭하면 즉시 적용 + 닫힘)
function AdCheck({ on }) {
  return (
    <span style={{
      width: 17, height: 17, borderRadius: 5, boxSizing: 'border-box', flexShrink: 0,
      display: 'grid', placeItems: 'center',
      border: on ? 'none' : '1.5px solid rgba(255,255,255,.34)',
      background: on ? LIME[500] : 'rgba(255,255,255,.05)',
      boxShadow: on ? `0 0 12px ${LIME[500]}66` : 'inset 0 1px 0 rgba(255,255,255,.12)',
    }}>
      {on && <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#101013" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>}
    </span>
  );
}

// 하단 바 버튼 — 글래스 위 프레스 틴트
function AdBarBtn({ children, onClick, flex, width, bold }) {
  const [down, setDown] = adState(false);
  return (
    <button onClick={onClick}
      onPointerDown={() => setDown(true)} onPointerUp={() => setDown(false)} onPointerLeave={() => setDown(false)}
      style={{
        all: 'unset', boxSizing: 'border-box', cursor: 'pointer', flex, width, position: 'relative',
        height: 54, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        background: down ? 'rgba(255,255,255,.10)' : 'transparent', transition: 'background .1s linear',
        ...TYPO.button2, fontWeight: bold ? 600 : 500, color: bold ? AG.t1 : AG.t3,
      }}>{children}</button>
  );
}

function HomeAdPopup({ ready }) {
  const [open, setOpen] = adState(false);
  const [muted, setMuted] = adState(false);
  const [checking, setChecking] = adState(false); // 체크 → 200ms 후 닫힘

  adEffect(() => {
    if (!ready || muted) return;
    let until = 0;
    try { until = Number(window.localStorage.getItem(AD_KEY) || 0); } catch (e) { until = 0; }
    if (Date.now() < until) return;
    const t = setTimeout(() => setOpen(true), 240);
    return () => clearTimeout(t);
  }, [ready, muted]);

  const hideWeek = () => {
    try { window.localStorage.setItem(AD_KEY, String(Date.now() + AD_WEEK)); } catch (e) { /* noop */ }
    setChecking(true);
    setTimeout(() => { setChecking(false); setMuted(true); setOpen(false); }, 220);
  };
  const reopen = () => {
    try { window.localStorage.removeItem(AD_KEY); } catch (e) { /* noop */ }
    setMuted(false); setOpen(true);
  };

  if (!open) {
    // 프로토타입용 — 닫은 뒤 다시 확인
    return (
      <button onClick={reopen} style={{
        all: 'unset', boxSizing: 'border-box', cursor: 'pointer', position: 'absolute', left: 14, bottom: 22, zIndex: 61,
        display: 'inline-flex', alignItems: 'center', gap: 7, padding: '9px 13px', borderRadius: 999,
        background: 'linear-gradient(158deg, rgba(255,255,255,.12), rgba(255,255,255,0) 55%), rgba(26,26,30,.78)',
        border: '1px solid rgba(255,255,255,.12)',
        boxShadow: '0 10px 30px rgba(0,0,0,.5), inset 0 1px 0 rgba(255,255,255,.16)',
        backdropFilter: 'blur(20px) saturate(160%)', WebkitBackdropFilter: 'blur(20px) saturate(160%)',
      }}>
        <span style={{ width: 6, height: 6, borderRadius: 999, background: LIME[500] }} />
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 600, color: AG.t1 }}>팝업 다시 보기</span>
      </button>
    );
  }

  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 90, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
      {/* 배리어 — 탭하면 닫힘 */}
      <div onClick={() => setOpen(false)} style={{
        position: 'absolute', inset: 0, background: 'rgba(14,13,18,0.55)',
        backdropFilter: 'blur(10px) saturate(130%)', WebkitBackdropFilter: 'blur(10px) saturate(130%)',
        animation: 'adScrim .22s ease both',
      }} />
      {/* 카드 뒤 브랜드 광채 */}
      <div aria-hidden style={{
        position: 'absolute', width: 260, height: 260, borderRadius: '50%', pointerEvents: 'none',
        background: `radial-gradient(circle, ${PURPLE[500]}59, transparent 70%)`,
        filter: 'blur(54px)', animation: 'adScrim .5s ease both',
      }} />
      <div style={{
        position: 'relative', width: 317, padding: 7, borderRadius: 26, boxSizing: 'border-box', overflow: 'hidden',
        ...AG.sheet, border: `1px solid ${AG.edge}`,
        boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.16), 0 30px 70px rgba(0,0,0,0.55)',
        animation: 'adPop .3s cubic-bezier(.2,.9,.3,1) both',
      }}>
        {/* 공통 스페큘러 오버레이 */}
        <span aria-hidden style={{ position: 'absolute', inset: 0, background: AG.spec, pointerEvents: 'none' }} />
        {/* 팝업 사진 (정사각) — 연결된 공지사항으로 이동 */}
        <a href={AD.href} style={{
          display: 'block', position: 'relative', aspectRatio: '1 / 1', borderRadius: 19, overflow: 'hidden',
          textDecoration: 'none', border: `1px solid ${AG.edge}`, boxShadow: '0 8px 22px rgba(0,0,0,0.4)',
        }}>
          <img src={AD.src} alt="DJ SOUL BEAT · 10월 26일 토요 밤 10시 · CLUB VELVET 강남" style={{ display: 'block', width: '100%', height: '100%', objectFit: 'cover' }} />
          {/* 유리 굴절 느낌의 코너 글린트 */}
          <span aria-hidden style={{
            position: 'absolute', inset: 0, pointerEvents: 'none',
            background: 'linear-gradient(158deg, rgba(255,255,255,0.18), rgba(255,255,255,0) 34%)',
            mixBlendMode: 'screen',
          }} />
        </a>
        {/* 하단 바 — AD 표시 · 1주일동안 안보기 · 닫기 */}
        <div style={{ position: 'relative', display: 'flex', alignItems: 'center', marginTop: 3 }}>
          <span aria-hidden style={{ position: 'absolute', left: 12, right: 12, top: 0, height: 1, background: AG.hair }} />
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 10px 0 13px', flexShrink: 0 }}>
            <span style={{ width: 5, height: 5, borderRadius: 999, background: LIME[500], boxShadow: `0 0 8px ${LIME[500]}` }} />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 600, color: 'rgba(255,255,255,0.52)' }}>AD</span>
          </span>
          <AdBarBtn flex="1" onClick={hideWeek}><AdCheck on={checking} />1주일동안 안보기</AdBarBtn>
          <span style={{ width: 1, height: 18, background: AG.hair, flexShrink: 0 }} />
          <AdBarBtn width={80} bold onClick={() => setOpen(false)}>닫기</AdBarBtn>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { HomeAdPopup });
