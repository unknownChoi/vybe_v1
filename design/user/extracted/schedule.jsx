/* global React, window, GRAY, LIME, TYPO */
// ============================================================
// schedule.jsx — 공연 일정 공유 모듈 (club_detail + schedule_all)
// SCHEDULE 데이터 + AgendaAct / ScheduleDayCard 컴포넌트
// ============================================================

// ---- icons ----
const SIcon = ({ d, size = 18, stroke = GRAY[400], fill = 'none', sw = 1.7 }) =>
  <svg width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={stroke} strokeWidth={sw} strokeLinecap="round" strokeLinejoin="round">{d}</svg>;
const SMic = (p) => <SIcon {...p} d={<><rect x="9" y="2" width="6" height="11" rx="3" /><path d="M5 10a7 7 0 0 0 14 0" /><line x1="12" y1="17" x2="12" y2="21" /><line x1="8" y1="21" x2="16" y2="21" /></>} />;
const SDisc = (p) => <SIcon {...p} d={<><circle cx="12" cy="12" r="10" /><circle cx="12" cy="12" r="2.4" /></>} />;
const SStar = ({ size = 9 }) => <svg width={size} height={size} viewBox="0 0 24 24" fill={LIME[500]} stroke={LIME[500]} strokeWidth="1" strokeLinejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>;

// ---- data ----
const ACT_TYPE = {
  rapper: { label: '래퍼', color: '#C8A8FF', bg: 'rgba(119,49,254,0.18)', Icon: SMic },
  dj:     { label: 'DJ',  color: '#8FB5FF', bg: 'rgba(43,107,255,0.18)',  Icon: SDisc },
};

const SCHEDULE = [
  { month: 7, day: 4,  dow: '목', dday: 0, acts: [
    { time: '22:00', name: 'YANO',   type: 'rapper', headline: true, bg: 'linear-gradient(135deg,#7731FE,#ff4d8d)' },
    { time: '23:30', name: 'GRIM',   type: 'dj',                     bg: 'linear-gradient(135deg,#fb5607,#ffbe0b)' },
    { time: '01:00', name: 'KODA',   type: 'dj',                     bg: 'linear-gradient(135deg,#3a0ca3,#4361ee)' },
  ]},
  { month: 7, day: 6,  dow: '토', dday: 2, acts: [
    { time: '22:00', name: 'VICE',   type: 'rapper', headline: true, bg: 'linear-gradient(135deg,#4a1e1e,#f72585)' },
    { time: '23:00', name: 'NOVA',   type: 'rapper',                 bg: 'linear-gradient(135deg,#3a2f0a,#f5b82e)' },
    { time: '00:30', name: 'BLAZE',  type: 'dj',                     bg: 'linear-gradient(135deg,#2a2410,#b5860b)' },
  ]},
  { month: 7, day: 11, dow: '목', dday: 7, acts: [
    { time: '22:00', name: 'SWERVE', type: 'rapper', headline: true, bg: 'linear-gradient(135deg,#2a1a3e,#7731FE)' },
    { time: '23:30', name: 'RENO',   type: 'dj',                     bg: 'linear-gradient(135deg,#5a3a1a,#f5b82e)' },
  ]},
  { month: 7, day: 13, dow: '토', dday: 9, acts: [
    { time: '22:00', name: 'YANO',   type: 'rapper', headline: true, bg: 'linear-gradient(135deg,#7731FE,#ff4d8d)' },
    { time: '23:00', name: 'ECHO',   type: 'dj',                     bg: 'linear-gradient(135deg,#1b3a3a,#2a9d8f)' },
    { time: '00:30', name: 'KODA',   type: 'dj',                     bg: 'linear-gradient(135deg,#3a0ca3,#4361ee)' },
  ]},
  { month: 7, day: 19, dow: '금', dday: 15, acts: [
    { time: '22:00', name: 'NOVA',   type: 'rapper', headline: true, bg: 'linear-gradient(135deg,#3a2f0a,#f5b82e)' },
    { time: '23:30', name: 'GRIM',   type: 'dj',                     bg: 'linear-gradient(135deg,#fb5607,#ffbe0b)' },
  ]},
  { month: 7, day: 25, dow: '금', dday: 21, acts: [
    { time: '22:00', name: 'SWERVE', type: 'rapper', headline: true, bg: 'linear-gradient(135deg,#2a1a3e,#7731FE)' },
    { time: '23:00', name: 'VICE',   type: 'rapper',                 bg: 'linear-gradient(135deg,#4a1e1e,#f72585)' },
    { time: '00:30', name: 'RENO',   type: 'dj',                     bg: 'linear-gradient(135deg,#5a3a1a,#f5b82e)' },
  ]},
  { month: 8, day: 1,  dow: '토', dday: 28, acts: [
    { time: '22:00', name: 'YANO',   type: 'rapper', headline: true, bg: 'linear-gradient(135deg,#7731FE,#ff4d8d)' },
    { time: '23:30', name: 'ECHO',   type: 'dj',                     bg: 'linear-gradient(135deg,#1b3a3a,#2a9d8f)' },
  ]},
];

// ---- components ----
function AgendaAct({ act, first }) {
  const t = ACT_TYPE[act.type];
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: first ? '0 0 10px' : '10px 0', borderTop: first ? 'none' : `1px solid ${GRAY[900]}` }}>
      <div style={{
        width: 34, height: 34, flexShrink: 0, borderRadius: 99, background: act.bg,
        border: '1px solid rgba(255,255,255,0.14)', position: 'relative', overflow: 'hidden',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 32% 30%, rgba(255,255,255,0.22), transparent 60%)' }} />
        <t.Icon size={15} stroke="rgba(255,255,255,0.92)" />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
          <span style={{ ...TYPO.button2, fontSize: 15, fontWeight: 700, color: '#fff' }}>{act.name}</span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, padding: '1px 6px', borderRadius: 5, background: t.bg }}>
            <t.Icon size={9} stroke={t.color} />
            <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: t.color }}>{t.label}</span>
          </span>
          {act.headline && (
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 2, padding: '1px 6px', borderRadius: 5, background: 'rgba(181,255,96,0.16)' }}>
              <SStar size={8} />
              <span style={{ ...TYPO.caption, fontSize: 9, lineHeight: '11px', fontWeight: 800, color: LIME[500] }}>헤드라이너</span>
            </span>
          )}
        </div>
      </div>
      <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 700, color: GRAY[400], fontVariantNumeric: 'tabular-nums', flexShrink: 0 }}>{act.time}</span>
    </div>
  );
}

function ScheduleDayCard({ day }) {
  const isToday = day.dday === 0;
  const rel = day.dday === 0 ? '오늘' : day.dday === 1 ? '내일' : day.dday === 2 ? '모레' : `D-${day.dday}`;
  return (
    <div style={{
      display: 'grid', gridTemplateColumns: '54px 1fr', padding: 14, borderRadius: 14,
      background: isToday ? 'rgba(119,49,254,0.08)' : 'rgba(255,255,255,0.03)',
      border: `1px solid ${isToday ? 'rgba(119,49,254,0.5)' : GRAY[800]}`,
      opacity: isToday ? 1 : 0.5,
    }}>
      {/* date tile */}
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3, paddingRight: 12 }}>
        <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '11px', fontWeight: 700, color: GRAY[500], whiteSpace: 'nowrap' }}>{day.month}월</span>
        <span style={{ ...TYPO.h3, fontSize: 26, lineHeight: '28px', fontWeight: 800, color: '#fff' }}>{day.day}</span>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', fontWeight: 700, color: isToday ? '#C8A8FF' : GRAY[400] }}>{day.dow}</span>
        <span style={{
          marginTop: 2, padding: '2px 7px', borderRadius: 999,
          ...TYPO.caption, fontSize: 9, lineHeight: '11px', fontWeight: 800, letterSpacing: '0.02em',
          background: isToday ? LIME[500] : 'rgba(255,255,255,0.06)', color: isToday ? '#1a1a1a' : GRAY[400],
        }}>{rel}</span>
      </div>
      {/* acts */}
      <div style={{ borderLeft: `1px solid ${isToday ? 'rgba(119,49,254,0.25)' : GRAY[800]}`, paddingLeft: 14 }}>
        {day.acts.map((a, i) => <AgendaAct key={i} act={a} first={i === 0} />)}
      </div>
    </div>
  );
}

Object.assign(window, { SCHEDULE, ACT_TYPE, AgendaAct, ScheduleDayCard });
