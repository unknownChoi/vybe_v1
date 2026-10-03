/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, PURPLE, LIME, SCHEDULE, ScheduleDayCard */
const { useState } = React;

const YEAR = 2026;

// ---- icons ----
const AI = ({ d, size = 18, stroke = GRAY[400], fill = 'none', sw = 1.7 }) =>
  <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={stroke} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">{d}</svg>;
const ABack = (p) => <AI {...p} sw={2.2} d={<polyline points="15 18 9 12 15 6" />} />;
const ACal = (p) => <AI {...p} d={<><rect x="3" y="4" width="18" height="18" rx="2" /><line x1="16" y1="2" x2="16" y2="6" /><line x1="8" y1="2" x2="8" y2="6" /><line x1="3" y1="10" x2="21" y2="10" /></>} />;
const ABell = (p) => <AI {...p} d={<><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" /><path d="M13.73 21a2 2 0 0 1-3.46 0" /></>} />;

// ---- header ----
function Header() {
  return (
    <div style={{
      flexShrink: 0, padding: '50px 8px 12px',
      display: 'grid', gridTemplateColumns: '44px 1fr 44px', alignItems: 'center',
      background: COLORS.bg, borderBottom: `1px solid ${GRAY[900]}`, zIndex: 20,
    }}>
      <a href="%5Bv1%5DCLUB-021.html" style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <ABack size={24} stroke="#fff" />
      </a>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: '#fff', textAlign: 'center' }}>공연 일정</span>
      <span />
    </div>
  );
}

// ---- type filter ----
function Filter({ active, onChange, counts }) {
  const tabs = [{ key: 'all', label: '전체' }, { key: 'rapper', label: '래퍼' }, { key: 'dj', label: 'DJ' }];
  return (
    <div style={{ display: 'flex', gap: 8, padding: '0 20px', marginBottom: 18 }}>
      {tabs.map(t => {
        const on = t.key === active;
        return (
          <button key={t.key} onClick={() => onChange(t.key)} style={{
            all: 'unset', cursor: 'pointer', height: 34, boxSizing: 'border-box',
            display: 'inline-flex', alignItems: 'center', gap: 5, padding: '0 14px', borderRadius: 999,
            background: on ? PURPLE[500] : GRAY[900], border: on ? '1px solid transparent' : `1px solid ${GRAY[800]}`,
            ...TYPO.button2, fontWeight: on ? 700 : 500, color: on ? '#fff' : GRAY[300], transition: 'background .18s',
          }}>
            {t.label}
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: on ? 'rgba(255,255,255,0.7)' : GRAY[500] }}>{counts[t.key]}</span>
          </button>
        );
      })}
    </div>
  );
}

// ---- root ----
function App() {
  const [type, setType] = useState('all');

  const counts = {
    all: SCHEDULE.reduce((n, d) => n + d.acts.length, 0),
    rapper: SCHEDULE.reduce((n, d) => n + d.acts.filter(a => a.type === 'rapper').length, 0),
    dj: SCHEDULE.reduce((n, d) => n + d.acts.filter(a => a.type === 'dj').length, 0),
  };

  const filtered = (type === 'all' ? SCHEDULE : SCHEDULE.map(d => ({ ...d, acts: d.acts.filter(a => a.type === type) })))
    .filter(d => d.acts.length > 0);

  // group by month
  const months = [];
  filtered.forEach(d => {
    let g = months.find(m => m.month === d.month);
    if (!g) { g = { month: d.month, days: [] }; months.push(g); }
    g.days.push(d);
  });

  return (
    <div style={{ width: '100%', height: '100%', background: COLORS.bg, color: '#fff', fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Header />

      <div style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none' }}>
        {/* intro */}
        <div style={{ padding: '18px 20px 14px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, ...TYPO.caption, fontSize: 12, color: GRAY[500] }}>
            <span>어썸 레드</span><span style={{ width: 2, height: 2, borderRadius: 99, background: GRAY[600] }} /><span>홍대</span>
          </div>
          <h1 style={{ ...TYPO.h3, color: '#fff', margin: '8px 0 0' }}>다가오는 공연</h1>
          <p style={{ ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: GRAY[500], margin: '8px 0 0' }}>
            공연이 있는 날만 표시돼요. 라인업은 당일 사정에 따라 변경될 수 있어요.
          </p>
        </div>

        <Filter active={type} onChange={setType} counts={counts} />

        {/* month groups */}
        <div key={type} style={{ animation: 'fadeIn .3s ease' }}>
          {months.map(m => (
            <div key={m.month} style={{ marginBottom: 8 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 7, padding: '0 20px 12px' }}>
                <ACal size={15} stroke={GRAY[400]} />
                <span style={{ ...TYPO.button2, fontWeight: 700, color: '#fff', whiteSpace: 'nowrap' }}>{YEAR}년 {m.month}월</span>
                <span style={{ ...TYPO.caption, fontSize: 12, color: GRAY[500], whiteSpace: 'nowrap' }}>· {m.days.length}일</span>
              </div>
              <div style={{ padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 20 }}>
                {m.days.map((d, i) => <ScheduleDayCard key={i} day={d} />)}
              </div>
            </div>
          ))}

          {months.length === 0 && (
            <div style={{ padding: '50px 24px', textAlign: 'center', ...TYPO.body4, color: GRAY[500] }}>해당하는 공연이 없어요</div>
          )}
        </div>

        {/* alert cta */}
        <div style={{ padding: '4px 20px 0' }}>
          <button style={{
            all: 'unset', cursor: 'pointer', boxSizing: 'border-box', width: '100%',
            padding: '13px 0', borderRadius: 12, background: 'rgba(119,49,254,0.12)', border: `1px solid rgba(119,49,254,0.4)`,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 7,
            ...TYPO.button2, fontWeight: 700, color: '#C8A8FF',
          }}>
            <ABell size={16} stroke="#C8A8FF" /> 새 공연 소식 알림 받기
          </button>
        </div>

        <div style={{ padding: '16px 24px 40px', textAlign: 'center' }}>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: GRAY[600] }}>일정은 매장 사정에 따라 변경될 수 있습니다.</span>
        </div>
      </div>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <IOSDevice dark={true} width={393} height={852}>
    <App />
  </IOSDevice>
);
