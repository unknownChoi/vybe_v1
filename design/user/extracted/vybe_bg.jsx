/* global React, window */
// ============ VYBE — 공용 배경 (ClubAurora) ============
// 좌상단 보라 · 우상단 라임 · 우하단 보라 3겹 + 잉크 베이스.
// 사용: <VAurora />  (부모에 position:relative 필요)

const VA_LAYERS = {
  club: [
    'radial-gradient(120% 80% at 0% 0%, rgba(119,49,254,0.50), transparent 72%)',
    'radial-gradient(110% 80% at 100% 2%, rgba(181,255,96,0.26), transparent 74%)',
    'radial-gradient(120% 90% at 88% 100%, rgba(119,49,254,0.34), transparent 76%)',
    '#0E0D12',
  ],
  quiet: [
    'radial-gradient(120% 70% at 0% 0%, rgba(119,49,254,0.34), transparent 70%)',
    'radial-gradient(100% 70% at 100% 4%, rgba(181,255,96,0.16), transparent 72%)',
    '#0E0D12',
  ],
};

const VA_GRAIN = "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='140'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E\")";

function VAurora({ variant = 'club', grain = false, style }) {
  const bg = (VA_LAYERS[variant] || VA_LAYERS.club).join(', ');
  return (
    <div aria-hidden style={{ position: 'absolute', inset: 0, pointerEvents: 'none', background: bg, ...style }}>
      {grain && <div style={{ position: 'absolute', inset: 0, opacity: 0.05, backgroundImage: VA_GRAIN, mixBlendMode: 'overlay' }} />}
    </div>
  );
}

Object.assign(window, { VAurora, VA_LAYERS, VA_GRAIN });
