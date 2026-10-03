/* global React, window, GRAY, PURPLE, BLUE, TYPO */
// ============================================================
// tables.jsx — 테이블 가격 공유 모듈 (club_detail + table_pricing)
// TIER / FLOOR 데이터 + 플로어맵 · 상세 컴포넌트
// ============================================================

// ---- icons ----
const Icon = ({ d, size = 18, stroke = GRAY[400], fill = 'none', sw = 1.7 }) =>
  <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={stroke} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">{d}</svg>;
const IconDisc = (p) => <Icon {...p} d={<><circle cx="12" cy="12" r="10" /><circle cx="12" cy="12" r="2.4" /></>} />;
const IconUsers = (p) => <Icon {...p} d={<><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" /><circle cx="9" cy="7" r="4" /><path d="M23 21v-2a4 4 0 0 0-3-3.87" /><path d="M16 3.13a4 4 0 0 1 0 7.75" /></>} />;
const IconBottle = (p) => <Icon {...p} d={<><path d="M10 2h4" /><path d="M10 2v3.6L8.4 8.2A2 2 0 0 0 8 9.4V20a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2V9.4a2 2 0 0 0-.4-1.2L14 5.6V2" /><path d="M8.2 13h7.6" /></>} />;
const IconInfo = (p) => <Icon {...p} d={<><circle cx="12" cy="12" r="10" /><line x1="12" y1="16" x2="12" y2="12" /><line x1="12" y1="8" x2="12.01" y2="8" /></>} />;
const IconCrown = (p) => <Icon {...p} d={<path d="M4 18 L6 9 L9 13 L12 7 L15 13 L18 9 L20 18 Z" />} />;
const IconCheck = (p) => <Icon {...p} d={<polyline points="20 6 9 17 4 12" />} />;

// ---- data ----
const TIER = {
  VVIP: { name: 'VVIP',     short: 'VVIP', color: '#C8A8FF', dot: PURPLE[500], selBg: PURPLE[500], soft: 'rgba(119,49,254,0.16)', ring: 'rgba(119,49,254,0.5)' },
  VIP:  { name: 'VIP',      short: 'VIP',  color: '#8FB5FF', dot: BLUE[500],   selBg: BLUE[500],   soft: 'rgba(43,107,255,0.14)', ring: 'rgba(43,107,255,0.5)' },
  STD:  { name: 'STANDARD', short: 'STD',  color: GRAY[300], dot: GRAY[500],   selBg: GRAY[700],   soft: 'rgba(255,255,255,0.05)', ring: 'rgba(255,255,255,0.2)' },
};

const FLOOR = [
  { id: 'S1', tier: 'VVIP', name: '스테이지 프론트 A', desc: '무대 바로 앞 · 최고의 시야', price: '100만', minPeople: 8, minBottles: 3, minSpend: '1,000,000원', pos: { left: '5%',  top: 62 } },
  { id: 'S2', tier: 'VVIP', name: '스테이지 프론트 B', desc: '무대 바로 앞 · 최고의 시야', price: '100만', minPeople: 8, minBottles: 3, minSpend: '1,000,000원', pos: { right: '5%', top: 62 } },
  { id: 'V1', tier: 'VIP',  name: '센터 사이드 1',     desc: '플로어 옆 · 활기찬 자리',     price: '50만',  minPeople: 6, minBottles: 2, minSpend: '500,000원',   pos: { left: '3%',  top: 126 } },
  { id: 'V2', tier: 'VIP',  name: '센터 사이드 2',     desc: '플로어 옆 · 활기찬 자리',     price: '50만',  minPeople: 6, minBottles: 2, minSpend: '500,000원',   pos: { right: '3%', top: 126 } },
  { id: 'V3', tier: 'VIP',  name: '센터 사이드 3',     desc: '플로어 옆 · 활기찬 자리',     price: '50만',  minPeople: 6, minBottles: 2, minSpend: '500,000원',   pos: { left: '3%',  top: 188 } },
  { id: 'V4', tier: 'VIP',  name: '센터 사이드 4',     desc: '플로어 옆 · 활기찬 자리',     price: '50만',  minPeople: 6, minBottles: 2, minSpend: '500,000원',   pos: { right: '3%', top: 188 } },
  { id: 'T1', tier: 'STD',  name: '바 라운지 1',       desc: '바 근처 · 편안한 자리',       price: '20만',  minPeople: 4, minBottles: 1, minSpend: '200,000원',   pos: { left: '4%',  top: 288 } },
  { id: 'T2', tier: 'STD',  name: '바 라운지 2',       desc: '바 근처 · 편안한 자리',       price: '20만',  minPeople: 4, minBottles: 1, minSpend: '200,000원',   pos: { left: '37%', top: 288 } },
  { id: 'T3', tier: 'STD',  name: '바 라운지 3',       desc: '바 근처 · 편안한 자리',       price: '20만',  minPeople: 4, minBottles: 1, minSpend: '200,000원',   pos: { right: '4%', top: 288 } },
];

// ---- floor map ----
function FloorTable({ t, selected, onSelect }) {
  const tier = TIER[t.tier];
  return (
    <button onClick={() => onSelect(t.id)} style={{
      all: 'unset', cursor: 'pointer', position: 'absolute', ...t.pos,
      width: 64, boxSizing: 'border-box', padding: '6px 4px', borderRadius: 9, textAlign: 'center',
      background: selected ? tier.selBg : tier.soft,
      border: `1px solid ${selected ? tier.dot : tier.ring}`,
      boxShadow: selected ? `0 6px 18px ${tier.ring}` : 'none',
      transform: selected ? 'scale(1.07)' : 'scale(1)',
      transition: 'transform .16s, box-shadow .16s, background .16s',
      zIndex: selected ? 6 : 3,
      display: 'flex', flexDirection: 'column', gap: 2, alignItems: 'center',
    }}>
      <span style={{ ...TYPO.caption, fontSize: 9, lineHeight: '10px', fontWeight: 800, letterSpacing: '0.03em', color: selected ? 'rgba(255,255,255,0.88)' : tier.color }}>{tier.short}</span>
      <span style={{ ...TYPO.caption, fontSize: 13, lineHeight: '14px', fontWeight: 800, color: '#fff' }}>{t.price}</span>
    </button>
  );
}

function TableFloorMap({ selId, onSelect }) {
  return (
    <div style={{
      position: 'relative', width: '100%', height: 384, borderRadius: 16,
      background: 'radial-gradient(120% 90% at 50% 0%, #1b1b22, #101014 72%)',
      border: `1px solid ${GRAY[800]}`, overflow: 'hidden',
    }}>
      {/* grid */}
      <div style={{ position: 'absolute', inset: 0, backgroundImage: 'linear-gradient(rgba(255,255,255,0.03) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.03) 1px, transparent 1px)', backgroundSize: '32px 32px' }} />

      {/* stage */}
      <div style={{
        position: 'absolute', top: 12, left: '50%', transform: 'translateX(-50%)', width: '86%', height: 40, borderRadius: 10,
        background: 'linear-gradient(180deg, rgba(119,49,254,0.35), rgba(119,49,254,0.06))',
        border: '1px solid rgba(119,49,254,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      }}>
        <IconDisc size={15} stroke="#C8A8FF" />
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 800, letterSpacing: '0.08em', color: '#C8A8FF' }}>DJ BOOTH · STAGE</span>
      </div>

      {/* dance floor */}
      <div style={{
        position: 'absolute', top: 118, left: '27%', width: '46%', height: 150, borderRadius: 12,
        border: `1.5px dashed ${GRAY[700]}`, background: 'rgba(255,255,255,0.015)',
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 3,
      }}>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 700, letterSpacing: '0.16em', color: GRAY[500] }}>DANCE</span>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 700, letterSpacing: '0.16em', color: GRAY[500] }}>FLOOR</span>
        <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '13px', color: GRAY[600], marginTop: 2 }}>스탠딩</span>
      </div>

      {/* bar */}
      <div style={{
        position: 'absolute', bottom: 12, left: '50%', transform: 'translateX(-50%)', width: '86%', height: 34, borderRadius: 10,
        background: 'rgba(255,255,255,0.04)', border: `1px solid ${GRAY[800]}`, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      }}>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 800, letterSpacing: '0.12em', color: GRAY[400] }}>BAR</span>
      </div>

      {/* tables */}
      {FLOOR.map(t => <FloorTable key={t.id} t={t} selected={selId === t.id} onSelect={onSelect} />)}
    </div>
  );
}

// ---- detail card ----
function ReqStat({ icon, label, value }) {
  return (
    <div style={{ flex: 1, display: 'flex', alignItems: 'center', gap: 9, padding: '10px 12px', borderRadius: 10, background: 'rgba(255,255,255,0.04)', border: `1px solid ${GRAY[800]}` }}>
      <span style={{ flexShrink: 0, display: 'flex' }}>{icon}</span>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
        <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', color: GRAY[500] }}>{label}</span>
        <span style={{ ...TYPO.button2, fontSize: 15, fontWeight: 800, color: '#fff' }}>{value}</span>
      </div>
    </div>
  );
}

function ReqCell({ icon, label, value }) {
  return (
    <div style={{ flex: 1, padding: '13px 16px', display: 'flex', flexDirection: 'column', gap: 7 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
        <span style={{ flexShrink: 0, display: 'flex' }}>{icon}</span>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: GRAY[500] }}>{label}</span>
      </div>
      <span style={{ ...TYPO.button2, fontSize: 16, fontWeight: 800, color: '#fff' }}>{value}</span>
    </div>
  );
}

function TableDetail({ t }) {
  const tier = TIER[t.tier];
  return (
    <div style={{
      marginTop: 14, borderRadius: 16, overflow: 'hidden',
      background: `linear-gradient(162deg, ${tier.soft}, ${GRAY[900]} 46%)`,
      border: `1px solid ${tier.ring}`,
      boxShadow: '0 12px 34px rgba(0,0,0,0.4)',
    }}>
      {/* header */}
      <div style={{ position: 'relative', padding: '16px 16px 14px', overflow: 'hidden' }}>
        <div style={{ position: 'absolute', top: -34, right: -24, width: 150, height: 120, pointerEvents: 'none', background: `radial-gradient(closest-side, ${tier.soft}, transparent)` }} />
        <div style={{ position: 'relative', display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 12 }}>
          <div style={{ minWidth: 0 }}>
            <span style={{ display: 'inline-block', padding: '3px 9px', borderRadius: 999, background: tier.soft, border: `1px solid ${tier.ring}`, color: tier.color, ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 800, letterSpacing: '0.04em' }}>{tier.name}</span>
            <div style={{ ...TYPO.h4, fontSize: 20, lineHeight: '23px', fontWeight: 800, color: '#fff', marginTop: 9 }}>{t.name}</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 6 }}>
              <span style={{ width: 5, height: 5, borderRadius: 99, background: tier.dot, flexShrink: 0 }} />
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '15px', color: GRAY[400] }}>{t.desc}</span>
            </div>
          </div>
          <div style={{ flexShrink: 0, width: 46, height: 46, borderRadius: 12, background: tier.soft, border: `1px solid ${tier.ring}`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <IconCrown size={22} stroke={tier.color} fill={tier.color} sw={1} />
          </div>
        </div>
      </div>

      {/* price band */}
      <div style={{ padding: '13px 16px', display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', gap: 12, borderTop: `1px solid ${GRAY[800]}`, background: 'rgba(255,255,255,0.02)' }}>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '15px', color: GRAY[400], paddingBottom: 5 }}>최소 주문 금액</span>
        <span style={{ display: 'inline-flex', alignItems: 'baseline', gap: 1 }}>
          <span style={{ ...TYPO.h2, fontSize: 28, lineHeight: '29px', color: '#fff', fontWeight: 800, letterSpacing: '-0.01em' }}>{t.minSpend}</span>
          <span style={{ ...TYPO.body3, color: GRAY[400], fontWeight: 600 }}>~</span>
        </span>
      </div>

      {/* requirements */}
      <div style={{ display: 'flex', borderTop: `1px solid ${GRAY[800]}` }}>
        <ReqCell icon={<IconUsers size={16} stroke={tier.color} />} label="최소 인원" value={`${t.minPeople}인`} />
        <div style={{ width: 1, background: GRAY[800] }} />
        <ReqCell icon={<IconBottle size={16} stroke={tier.color} />} label="최소 보틀" value={`${t.minBottles}병`} />
      </div>

      {/* booking condition */}
      <div style={{ display: 'flex', gap: 8, margin: '14px 16px 16px', padding: '11px 12px', borderRadius: 10, background: tier.soft, border: `1px solid ${tier.ring}` }}>
        <span style={{ flexShrink: 0, marginTop: 1, display: 'flex' }}><IconCheck size={15} stroke={tier.color} sw={2.2} /></span>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '18px', color: GRAY[200], flex: 1 }}>
          최소 <b style={{ color: tier.color, fontWeight: 800 }}>{t.minPeople}인</b>부터, 보틀 <b style={{ color: tier.color, fontWeight: 800 }}>{t.minBottles}병</b> 이상 주문 시 예약 가능합니다.
        </span>
      </div>
    </div>
  );
}

Object.assign(window, { TIER, FLOOR, FloorTable, TableFloorMap, ReqStat, TableDetail });
