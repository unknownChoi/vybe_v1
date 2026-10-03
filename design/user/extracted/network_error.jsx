/* global React, ReactDOM, IOSDevice, VAurora, TYPO, GRAY, LIME, PURPLE, RED, window */
// ============ VYBE — 네트워크 오류 (앱 최초 진입 시) ============
const NE = { ink: '#0E0D12', hair: 'rgba(255,255,255,0.08)', t2: 'rgba(255,255,255,0.72)' };

// 신호 없음 아이콘 — 전파 아크가 위로 갈수록 흐려지고 사선으로 끊긴다
function NoSignal({ retrying }) {
  const arc = (r, o, dash) => (
    <path d={`M ${44 - r} 62 A ${r} ${r} 0 0 1 ${44 + r} 62`} fill="none" stroke="#fff" strokeOpacity={o}
      strokeWidth="4.5" strokeLinecap="round" strokeDasharray={dash} />
  );
  return (
    <div style={{ position: 'relative', width: 88, height: 88 }}>
      <div aria-hidden style={{ position: 'absolute', left: '50%', top: '58%', transform: 'translate(-50%,-50%)', width: 168, height: 168, borderRadius: '50%', background: 'radial-gradient(circle, rgba(255,92,95,0.14), transparent 68%)', animation: retrying ? 'neHalo 1.1s ease-in-out infinite' : 'none' }} />
      <svg width="88" height="72" viewBox="0 0 88 72" style={{ position: 'absolute', left: 0, top: 8, display: 'block' }}>
        {arc(34, 0.1, '4 9')}
        {arc(24, 0.22, '')}
        {arc(14, 0.42, '')}
        <circle cx="44" cy="61" r="4.5" fill="#fff" fillOpacity="0.62" />
        {!retrying && <line x1="20" y1="70" x2="68" y2="20" stroke={NE.ink} strokeWidth="9" strokeLinecap="round" />}
        {!retrying && <line x1="20" y1="70" x2="68" y2="20" stroke={RED[500]} strokeWidth="4" strokeLinecap="round" />}
      </svg>
    </div>
  );
}

function Spinner({ size = 20 }) {
  return <span style={{ display: 'block', width: size, height: size, borderRadius: 99, background: `conic-gradient(from 0deg, rgba(255,255,255,0.15), #fff)`, WebkitMask: 'radial-gradient(farthest-side, transparent calc(100% - 2.5px), #000 0)', mask: 'radial-gradient(farthest-side, transparent calc(100% - 2.5px), #000 0)', animation: 'neSpin .8s linear infinite' }} />;
}

function NetworkError() {
  const [retrying, setRetrying] = React.useState(false);
  const [tries, setTries] = React.useState(0);
  const [toast, setToast] = React.useState(false);

  const retry = () => {
    if (retrying) return;
    setRetrying(true); setToast(false);
    setTimeout(() => {
      if (navigator.onLine) { window.__VBGO('%5Bv1%5DAUTH-001.html'); return; }
      setRetrying(false); setTries(t => t + 1); setToast(true);
      setTimeout(() => setToast(false), 2400);
    }, 1500);
  };
  React.useEffect(() => {
    const on = () => { window.__VBGO('%5Bv1%5DAUTH-001.html'); };
    window.addEventListener('online', on);
    return () => window.removeEventListener('online', on);
  }, []);

  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: NE.ink, fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      {/* 다른 페이지와 동일한 오로라 배경 */}
      <VAurora variant="club" grain={true} />

      <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', padding: '0 20px 40px' }}>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 26, paddingBottom: 20 }}>
          <NoSignal retrying={retrying} />
          <div style={{ textAlign: 'center' }}>
            <h1 style={{ ...TYPO.h2, margin: 0, color: '#fff' }}>
              <span style={{ color: LIME[500] }}>네트워크 연결</span>을<br />확인해 주세요
            </h1>
            <p style={{ ...TYPO.body4, lineHeight: '21px', margin: '14px 0 0', color: GRAY[500] }}>
              인터넷에 연결되어 있지 않아<br />클럽 정보를 불러올 수 없어요.
            </p>
            <button onClick={retry} disabled={retrying} style={{
              marginTop: 22, height: 44, padding: retrying ? '0 20px' : '0 24px', borderRadius: 12, border: 0, cursor: retrying ? 'default' : 'pointer',
              background: retrying ? PURPLE.disabled : PURPLE[500], color: retrying ? 'rgba(255,255,255,0.8)' : '#fff',
              ...TYPO.button1, display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
              boxShadow: retrying ? 'none' : '0 8px 20px rgba(119,49,254,0.35)', transition: 'background .1s, box-shadow .15s',
            }}>
              {retrying && <Spinner size={17} />}
              {retrying ? '연결 확인 중' : '다시 시도'}
            </button>
          </div>
        </div>

        <div style={{ display: 'flex', justifyContent: 'center' }}>
          <button style={{ font: '400 12px/14px Pretendard, sans-serif', letterSpacing: '-0.3px', color: '#D9D9D9', textDecoration: 'underline', background: 0, border: 0, cursor: 'pointer' }}>네트워크 설정 열기</button>
        </div>
      </div>

      {/* 재시도 실패 토스트 */}
      <div style={{ position: 'absolute', left: 0, right: 0, bottom: 120, display: 'flex', justifyContent: 'center', pointerEvents: 'none', opacity: toast ? 1 : 0, transform: toast ? 'none' : 'translateY(8px)', transition: 'opacity .22s ease, transform .22s ease' }}>
        <div style={{ display: 'inline-flex', alignItems: 'center', gap: 9, padding: '12px 18px', borderRadius: 99, background: 'rgba(26,26,30,0.94)', border: `1px solid ${NE.hair}`, boxShadow: '0 10px 30px rgba(0,0,0,0.5)', backdropFilter: 'blur(18px)' }}>
          <span style={{ width: 19, height: 19, borderRadius: 99, background: RED[500], display: 'grid', placeItems: 'center', font: '800 11px/1 Pretendard', color: '#fff' }}>!</span>
          <span style={{ fontSize: 14, color: '#fff', letterSpacing: '-0.025em' }}>여전히 연결되지 않아요{tries > 1 ? ` (${tries}회)` : ''}</span>
        </div>
      </div>
    </div>
  );
}

const neRoot = ReactDOM.createRoot(document.getElementById('root'));
neRoot.render(
  <IOSDevice dark={true} width={393} height={852}>
    <NetworkError />
  </IOSDevice>
);
