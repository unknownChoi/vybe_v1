/* global React, ReactDOM, IOSDevice, window */
// ============ VYBE — Splash · 클럽 조명 기둥 애니메이션 ============
const { useState: spState } = React;

const SP_LIME = '#B5FF60';
const SP_PURPLE = '#7731FE';

// 조명 기둥 하나 — 위에서 아래로 퍼지는 원뿔형 광선.
// hue: 색 / x: 시작 x(%) / w: 아래쪽 폭(px) / from~to: 스윙 각도 / dur: 왕복 주기
const BEAMS = [
  { hue: SP_PURPLE, x: 16, w: 190, from: -18, to: 12, dur: 6.4, delay: 0, op: 0.6 },
  { hue: SP_LIME, x: 38, w: 140, from: 12, to: -14, dur: 5.2, delay: 0.35, op: 0.46 },
  { hue: '#C8A8FF', x: 62, w: 140, from: -12, to: 14, dur: 7.1, delay: 0.35, op: 0.46 },
  { hue: SP_PURPLE, x: 84, w: 190, from: 18, to: -12, dur: 5.8, delay: 0, op: 0.6 },
];

function Beam({ b, i }) {
  const cone = (w, blur, alpha) => (
    <div style={{ position: 'absolute', top: 0, left: '50%', width: w, height: '100%', marginLeft: -w / 2, filter: `blur(${blur}px)`, clipPath: 'polygon(45% 0, 55% 0, 100% 100%, 0 100%)', background: `linear-gradient(to bottom, ${b.hue} 0%, ${b.hue} 12%, ${b.hue}99 42%, ${b.hue}33 68%, transparent 90%)`, opacity: alpha }} />
  );
  return (
    <div style={{
      position: 'absolute', top: -30, left: `${b.x}%`, width: b.w, height: '108%', marginLeft: -b.w / 2,
      transformOrigin: 'top center', mixBlendMode: 'screen',
      opacity: 0, animation: `spBeamIn .9s ${0.25 + Math.min(i, 3 - i) * 0.12}s forwards, spSwing ${b.dur}s ${b.delay}s ease-in-out infinite alternate, spFlicker ${2.7 + i * 0.6}s ${1 + i * 0.3}s ease-in-out infinite`,
      ['--from']: `${b.from}deg`, ['--to']: `${b.to}deg`, ['--op']: b.op,
    }}>
      {cone(b.w, 16, 0.75)}
      {cone(b.w * 0.52, 5, 0.85)}
      {/* 렌즈 코어 */}
      <div style={{ position: 'absolute', top: -10, left: '50%', width: 22, height: 22, marginLeft: -11, borderRadius: '50%', background: '#fff', boxShadow: `0 0 22px 8px ${b.hue}`, filter: 'blur(4px)' }} />
    </div>
  );
}

function Splash({ onReplay, phase, frameRef, logoRef, morph }) {
  const out = phase === 'exit' || phase === 'home';
  return (
    <div onClick={phase === 'in' ? onReplay : undefined} style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: '#0E0D12', cursor: phase === 'in' ? 'pointer' : 'default' }}>
      {/* 홈 화면 — 처음부터 뒤에서 로드해 두고, 조명이 사그라들며 그대로 드러난다 */}
      <iframe ref={frameRef} src="%5Bv1%5DHOME-005.html?bare=1" title="home" style={{
        position: 'absolute', inset: 0, width: '100%', height: '100%', border: 0, background: '#0e0d12',
        opacity: out ? 1 : 0, transform: out ? 'scale(1)' : 'scale(1.04)', filter: out ? 'blur(0px)' : 'blur(10px)',
        transition: 'opacity .6s .1s ease-out, transform .95s cubic-bezier(.2,.8,.2,1), filter .55s .1s ease-out',
        pointerEvents: phase === 'home' ? 'auto' : 'none',
      }} />
      {/* 조명 무대 — 홈 위에 겹쳐 있다가 빛만 남기고 빠진다 */}
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none', transformOrigin: '50% 0%', animation: out ? 'spStageOut 1.05s cubic-bezier(.35,0,.25,1) forwards' : 'none' }}>
      {/* 무대 바닥 안개 */}
      <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 60% at 50% 108%, rgba(119,49,254,0.30), transparent 70%)' }} />
      {/* 조명 기둥 */}
      {BEAMS.map((b, i) => <Beam key={i} b={b} i={i} />)}
      {/* 헤이즈 — 빛을 머금은 공기 */}
      <div style={{ position: 'absolute', inset: '-20%', mixBlendMode: 'screen', opacity: 0.5, background: 'radial-gradient(48% 38% at 28% 34%, rgba(200,168,255,0.19), transparent 70%), radial-gradient(48% 38% at 72% 34%, rgba(200,168,255,0.19), transparent 70%), radial-gradient(40% 30% at 50% 58%, rgba(181,255,96,0.12), transparent 72%)', animation: 'spHaze 9s ease-in-out infinite alternate' }} />
      {/* 바닥 광원 풀 */}
      <div style={{ position: 'absolute', left: '50%', bottom: -110, width: 520, height: 240, marginLeft: -260, borderRadius: '50%', filter: 'blur(38px)', mixBlendMode: 'screen', background: 'radial-gradient(circle, rgba(181,255,96,0.30), rgba(119,49,254,0.20) 45%, transparent 72%)', opacity: 0, animation: 'spPool 1.2s .5s forwards, spPulse 3.4s 1.7s ease-in-out infinite' }} />
      {/* 먼지 입자 */}
      <div style={{ position: 'absolute', inset: 0, opacity: 0.5, backgroundImage: 'radial-gradient(1.6px 1.6px at 12% 30%, rgba(255,255,255,.7), transparent), radial-gradient(1.4px 1.4px at 34% 62%, rgba(255,255,255,.5), transparent), radial-gradient(1.8px 1.8px at 58% 24%, rgba(255,255,255,.55), transparent), radial-gradient(1.3px 1.3px at 76% 70%, rgba(255,255,255,.45), transparent), radial-gradient(1.5px 1.5px at 88% 42%, rgba(255,255,255,.5), transparent), radial-gradient(1.2px 1.2px at 22% 82%, rgba(255,255,255,.4), transparent)', animation: 'spDust 12s linear infinite' }} />
      </div>
      {/* 조명이 빠진 뒤 홈 위에 남는 잔광 */}
      <div style={{ position: 'absolute', inset: 0, mixBlendMode: 'screen', pointerEvents: 'none', opacity: 0, background: 'radial-gradient(85% 45% at 22% -6%, rgba(119,49,254,0.5), transparent 70%), radial-gradient(60% 35% at 78% -4%, rgba(181,255,96,0.22), transparent 72%)', animation: out ? 'spGlowOut 1.5s cubic-bezier(.3,0,.3,1) forwards' : 'none' }} />

      {/* 로고 — 그대로 홈 헤더 로고 자리로 옮겨 앉는다 */}
      <div style={{ position: 'absolute', inset: 0, display: 'grid', placeItems: 'center', pointerEvents: 'none' }}>
        <div ref={logoRef} style={morph ? {
          position: 'relative', width: 238, opacity: phase === 'home' ? 0 : 1, transformOrigin: 'top left',
          transform: phase === 'ready' ? 'none' : `translate(${morph.dx}px, ${morph.dy}px) scale(${morph.scale})`,
          transition: phase === 'ready' ? 'none' : 'transform .82s cubic-bezier(.58,.02,.2,1), opacity .2s .58s linear',
        } : { position: 'relative', width: 238, opacity: 0, animation: 'spLogo 1s 1.05s cubic-bezier(.2,.9,.25,1) forwards' }}>
          <img src="assets/vybe-logo.png" alt="vybe" style={{ width: '100%', display: 'block', filter: 'drop-shadow(0 0 26px rgba(119,49,254,0.55))' }} />
          {/* 로고 알파에 마스킹된 빛 스침 */}
          <div style={{
            position: 'absolute', inset: 0,
            WebkitMaskImage: 'url(assets/vybe-logo.png)', maskImage: 'url(assets/vybe-logo.png)',
            WebkitMaskSize: '100% 100%', maskSize: '100% 100%', WebkitMaskRepeat: 'no-repeat', maskRepeat: 'no-repeat',
            background: 'linear-gradient(105deg, transparent 38%, rgba(255,255,255,.92) 50%, transparent 62%)',
            backgroundSize: '260% 100%', backgroundPositionX: '160%',
            animation: 'spShine 1.5s 1.75s ease-out forwards, spShine 1.5s 5.4s ease-out forwards',
          }} />
        </div>
      </div>

      {/* 로딩 라인 */}
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none', opacity: out ? 0 : 1, transition: 'opacity .28s ease-out' }}>
        <div style={{ position: 'absolute', left: '50%', bottom: 92, width: 96, height: 2, marginLeft: -48, borderRadius: 99, background: 'rgba(255,255,255,0.12)', overflow: 'hidden', opacity: 0, animation: 'spFade .5s 1.5s forwards' }}>
          <div style={{ width: '42%', height: '100%', borderRadius: 99, background: SP_LIME, animation: 'spTrack 1.4s 1.6s cubic-bezier(.65,0,.35,1) infinite' }} />
        </div>
      </div>
    </div>
  );
}

function SplashApp() {
  const [run, setRun] = spState(0);
  const [phase, setPhase] = spState('in');   // in → exit → home
  const [morph, setMorph] = spState(null);   // 로고 → 헤더 로고 이동값
  const frameRef = React.useRef(null);
  const logoRef = React.useRef(null);

  React.useEffect(() => {
    setPhase('in'); setMorph(null);
    const timers = [];
    const readyAt = Date.now() + 2000;
    // 홈이 실제로 그려진 뒤에 전환 — 로고 목표 위치를 홈 헤더에서 직접 재서 이어 붙인다
    const target = () => { try { return frameRef.current.contentDocument.querySelector('img[alt="vybe"]'); } catch (e) { return null; } };
    const poll = setInterval(() => {
      // 진입 직후 네트워킬 점검 — 끚겼으면 오류 화면으로
      if (Date.now() >= readyAt && !navigator.onLine) {
        clearInterval(poll); window.__VBGO('%5Bv1%5DSYS-034.html'); return;
      }
      const t = target();
      if (!t || !t.complete || !t.naturalWidth || Date.now() < readyAt) return;
      const r = t.getBoundingClientRect();
      if (!r.width) return; // 로고 디코드 전이면 측정이 0 — 다음 톱에 다시
      clearInterval(poll);
      const s = logoRef.current.getBoundingClientRect();
      const f = frameRef.current.getBoundingClientRect();
      // iframe은 이 시점에 scale(1.04) 상태 — 레이아웃 원본 박스 기준으로 보정해서 재다
      const ox = f.left + (f.width - frameRef.current.offsetWidth) / 2;
      const oy = f.top + (f.height - frameRef.current.offsetHeight) / 2;
      setMorph({ dx: ox + r.left - s.left, dy: oy + r.top - s.top, scale: (r.width / s.width) || (22 * 170 / 45) / 238 });
      setPhase('ready');
      requestAnimationFrame(() => requestAnimationFrame(() => setPhase('exit')));
      timers.push(setTimeout(() => setPhase('home'), 1180));
    }, 60);
    return () => { clearInterval(poll); timers.forEach(clearTimeout); };
  }, [run]);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14 }}>
      <IOSDevice dark={true} width={393} height={852}>
        <Splash key={run} phase={phase} morph={morph} frameRef={frameRef} logoRef={logoRef} onReplay={() => setRun(v => v + 1)} />
      </IOSDevice>
      <button onClick={() => setRun(v => v + 1)} style={{ all: 'unset', cursor: 'pointer', padding: '9px 18px', borderRadius: 999, background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.14)', color: 'rgba(255,255,255,0.8)', fontSize: 13, fontWeight: 600, fontFamily: "'Pretendard', sans-serif" }}>다시 재생</button>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<SplashApp />);
