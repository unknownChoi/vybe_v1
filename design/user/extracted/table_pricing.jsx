/* global React, ReactDOM, IOSDevice, COLORS, TYPO, GRAY, LIME, TIER, FLOOR, TableFloorMap */
const { useState } = React;

// ---- page icons ----
const PI = ({ d, size = 18, stroke = GRAY[400], fill = 'none', sw = 1.7 }) =>
  <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={stroke} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">{d}</svg>;
const PBack = (p) => <PI {...p} d={<polyline points="15 18 9 12 15 6" />} />;
const PInfo = (p) => <PI {...p} d={<><circle cx="12" cy="12" r="10" /><line x1="12" y1="16" x2="12" y2="12" /><line x1="12" y1="8" x2="12.01" y2="8" /></>} />;
const PPhone = (p) => <PI {...p} d={<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.37 1.9.72 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.35 1.85.59 2.81.72A2 2 0 0 1 22 16.92z" />} />;
const PChat = (p) => <PI {...p} d={<path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z" />} />;

const won = (s) => s.replace('원', '');

// ---- header ----
function Header() {
  return (
    <div style={{
      flexShrink: 0, padding: '50px 8px 12px',
      display: 'grid', gridTemplateColumns: '44px 1fr 44px', alignItems: 'center',
      background: COLORS.bg, borderBottom: `1px solid ${GRAY[900]}`, zIndex: 20,
    }}>
      <a href="%5Bv1%5DCLUB-021.html" style={{ all: 'unset', cursor: 'pointer', width: 44, height: 44, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <PBack size={24} stroke="#fff" />
      </a>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: '#fff', textAlign: 'center' }}>테이블 가격</span>
      <span />
    </div>
  );
}

// ---- table list card ----
function TableListCard({ t, selected, onSelect }) {
  const tier = TIER[t.tier];
  return (
    <button onClick={() => onSelect(t.id)} style={{
      all: 'unset', cursor: 'pointer', boxSizing: 'border-box', width: '100%',
      padding: 14, borderRadius: 14,
      background: selected ? tier.soft : GRAY[900],
      border: `1px solid ${selected ? tier.dot : GRAY[800]}`,
      boxShadow: selected ? `0 6px 20px ${tier.ring}` : 'none',
      display: 'flex', flexDirection: 'column', gap: 11, transition: 'background .16s, border-color .16s, box-shadow .16s',
    }}>
      <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 10 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, minWidth: 0 }}>
          <span style={{
            flexShrink: 0, width: 34, height: 34, borderRadius: 9, background: tier.soft, border: `1px solid ${tier.ring}`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 800, color: tier.color,
          }}>{t.id}</span>
          <div style={{ minWidth: 0 }}>
            <div style={{ ...TYPO.body3, fontWeight: 700, color: '#fff' }}>{t.name}</div>
            <div style={{ ...TYPO.caption, fontSize: 12, lineHeight: '15px', color: GRAY[500], marginTop: 3 }}>{t.desc}</div>
          </div>
        </div>
        <div style={{ textAlign: 'right', flexShrink: 0 }}>
          <div style={{ ...TYPO.body3, fontWeight: 800, color: '#fff' }}>{won(t.minSpend)}<span style={{ ...TYPO.caption, color: GRAY[500], fontWeight: 400 }}>원~</span></div>
          <div style={{ ...TYPO.caption, fontSize: 10, lineHeight: '12px', color: GRAY[500], marginTop: 3 }}>최소 주문</div>
        </div>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '9px 11px', borderRadius: 10, background: tier.soft, border: `1px solid ${tier.ring}` }}>
        <span style={{ flexShrink: 0, display: 'flex' }}><PInfo size={14} stroke={tier.color} /></span>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: GRAY[200], wordBreak: 'keep-all' }}>
          최소 <b style={{ color: tier.color, fontWeight: 800 }}>{t.minPeople}인</b> · 보틀 <b style={{ color: tier.color, fontWeight: 800 }}>{t.minBottles}병</b> 이상 주문 시 예약 가능
        </span>
      </div>
    </button>
  );
}

// ---- tier group ----
function TierGroup({ tierKey, selId, onSelect }) {
  const tier = TIER[tierKey];
  const tables = FLOOR.filter(f => f.tier === tierKey);
  return (
    <div style={{ marginBottom: 22 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12 }}>
        <span style={{ width: 10, height: 10, borderRadius: 3, background: tier.dot }} />
        <span style={{ ...TYPO.body3, fontWeight: 800, color: '#fff' }}>{tier.name}</span>
        <span style={{ ...TYPO.caption, fontSize: 12, color: GRAY[500] }}>· {tables.length}석</span>
        <span style={{ flex: 1 }} />
        <span style={{ ...TYPO.caption, fontSize: 12, color: tier.color, fontWeight: 700, whiteSpace: 'nowrap' }}>{won(tables[0].minSpend)}원~</span>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        {tables.map(t => <TableListCard key={t.id} t={t} selected={selId === t.id} onSelect={onSelect} />)}
      </div>
    </div>
  );
}

// ---- notice ----
function Notice() {
  const items = [
    '성인만 입장 가능합니다.',
    '테이블 가격은 요일 및 이벤트에 따라 변동될 수 있습니다.',
    '예약금은 최소 주문 금액에 포함되며, 방문일 3일 전까지 취소 시 전액 환불됩니다.',
  ];
  return (
    <div style={{ padding: '14px 16px', borderRadius: 12, background: 'rgba(255,255,255,0.03)', border: `1px solid ${GRAY[800]}` }}>
      <div style={{ ...TYPO.button2, color: GRAY[300], fontWeight: 700, marginBottom: 10 }}>안내 및 유의사항</div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
        {items.map((t, i) => (
          <div key={i} style={{ display: 'flex', gap: 8 }}>
            <span style={{ ...TYPO.body4, color: GRAY[600], lineHeight: '19px' }}>•</span>
            <span style={{ ...TYPO.body4, fontSize: 13, color: GRAY[300], lineHeight: '19px', flex: 1 }}>{t}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

// ---- contact ----
function Contact() {
  const btn = {
    all: 'unset', cursor: 'pointer', flex: 1, boxSizing: 'border-box', padding: '12px 0', borderRadius: 10,
    background: GRAY[900], border: `1px solid ${GRAY[800]}`,
    display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 7,
    ...TYPO.button2, color: '#fff', fontWeight: 600,
  };
  return (
    <div style={{ display: 'flex', gap: 8 }}>
      <a href="tel:02-1234-1234" style={btn}><PPhone size={15} stroke={LIME[500]} /> 전화 문의</a>
      <a href="#" onClick={e => e.preventDefault()} style={btn}><PChat size={15} stroke={LIME[500]} /> 오픈채팅 문의</a>
    </div>
  );
}

// ---- root ----
function App() {
  const [selId, setSelId] = useState(null);
  const order = ['VVIP', 'VIP', 'STD'];
  return (
    <div style={{ width: '100%', height: '100%', background: COLORS.bg, color: '#fff', fontFamily: "'Pretendard', sans-serif", display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
      <Header />

      <div style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none' }}>
        {/* intro */}
        <div style={{ padding: '18px 20px 8px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, ...TYPO.caption, fontSize: 12, color: GRAY[500] }}>
            <span>어썸 레드</span><span style={{ width: 2, height: 2, borderRadius: 99, background: GRAY[600] }} /><span>홍대</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', marginTop: 8 }}>
            <h1 style={{ ...TYPO.h3, color: '#fff', margin: 0 }}>테이블 & 자리 가격</h1>
            <span style={{ ...TYPO.body4, color: GRAY[400] }}>총 {FLOOR.length}석</span>
          </div>
          <p style={{ ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: GRAY[500], margin: '8px 0 0' }}>
            자리를 누르면 지도와 목록에서 위치를 함께 확인할 수 있어요.
          </p>
        </div>

        {/* map + legend */}
        <div style={{ padding: '8px 20px 0' }}>
          <TableFloorMap selId={selId} onSelect={setSelId} />
          <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap', margin: '12px 2px 0' }}>
            {order.map(k => {
              const tier = TIER[k];
              const p = won(FLOOR.find(f => f.tier === k).minSpend);
              return (
                <div key={k} style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                  <span style={{ width: 9, height: 9, borderRadius: 3, background: tier.dot }} />
                  <span style={{ ...TYPO.caption, fontSize: 12, color: GRAY[400], fontWeight: 600 }}>{tier.name}</span>
                  <span style={{ ...TYPO.caption, fontSize: 12, color: '#fff', fontWeight: 700, whiteSpace: 'nowrap' }}>{p}원~</span>
                </div>
              );
            })}
          </div>
        </div>

        {/* tier groups */}
        <div style={{ padding: '22px 20px 0' }}>
          {order.map(k => <TierGroup key={k} tierKey={k} selId={selId} onSelect={setSelId} />)}
        </div>

        {/* notice + contact */}
        <div style={{ padding: '2px 20px 0', display: 'flex', flexDirection: 'column', gap: 16 }}>
          <Notice />
          <div>
            <div style={{ ...TYPO.button2, color: GRAY[400], fontWeight: 600, marginBottom: 8 }}>예약 문의</div>
            <Contact />
          </div>
        </div>

        <div style={{ padding: '20px 24px 40px', textAlign: 'center' }}>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: GRAY[600] }}>가격 및 예약 조건은 매장 사정에 따라 변경될 수 있습니다.</span>
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
