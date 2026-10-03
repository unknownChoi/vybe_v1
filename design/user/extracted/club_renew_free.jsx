/* global React, TYPO, GRAY, LIME, PURPLE, RED, window, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, VGlass, VHead, VDot, VFooterNote, vrState, vrEffect */
// ============ VYBE — 시간대별 무료입장 ============

const VR_FREE = {
  // 오늘(목) 입장료 시간표 — 영업 20:00 ~ 02:00 구간
  slots: [{ s: '20:00', e: '22:00', p: 0 }, { s: '22:00', e: '23:30', p: 5000 }, { s: '23:30', e: '02:00', p: 10000 }],
  week: [{ d: '월', w: '20:00 - 23:00' }, { d: '화', w: '20:00 - 23:00' }, { d: '수', w: '20:00 - 23:00' }, { d: '목', w: '20:00 - 22:00', today: true }, { d: '금', w: '19:00 - 21:00' }, { d: '토', w: '19:00 - 21:00' }, { d: '일', w: null }],
  cond: ['시간대 내 입장 기준', '만석 시 조기 마감될 수 있어요', '신분증 지참 필수 (만 19세 이상)'],
};
const VF_MIN = (s) => { const [h, m] = s.split(':').map(Number); return (h < 12 ? h + 24 : h) * 60 + m; };
const VF_T0 = VF_MIN(VR_FREE.slots[0].s), VF_T1 = VF_MIN(VR_FREE.slots[VR_FREE.slots.length - 1].e), VF_SPAN = VF_T1 - VF_T0;
const VF_HHMM = (min) => `${String(Math.floor(min / 60) % 24).padStart(2, '0')}:${String(Math.round(min) % 60).padStart(2, '0')}`;
const VF_WON = (p) => p === 0 ? '무료' : `${p.toLocaleString()}원`;

// 데모 시계 — 21:14에서 시작해 실시간으로 흐름. 모듈 단위 단일 소스(탭 전환에도 유지)
const VF_CLOCK = { sec: (VF_T0 + 74) * 60, subs: new Set() };
setInterval(() => { VF_CLOCK.sec += 1; VF_CLOCK.subs.forEach(f => f(VF_CLOCK.sec)); }, 1000);
function useVFClock() {
  const [sec, setSec] = vrState(VF_CLOCK.sec);
  vrEffect(() => { setSec(VF_CLOCK.sec); VF_CLOCK.subs.add(setSec); return () => { VF_CLOCK.subs.delete(setSec); }; }, []);
  return sec;
}
function vfState(sec) {
  const min = sec / 60;
  const cur = VR_FREE.slots.find(s => min >= VF_MIN(s.s) && min < VF_MIN(s.e));
  const free = VR_FREE.slots.find(s => s.p === 0);
  const isFree = !!cur && cur.p === 0;
  const target = isFree ? VF_MIN(cur.e) : min < VF_MIN(free.s) ? VF_MIN(free.s) : null;
  return { min, cur, free, isFree, target, left: target == null ? null : Math.max(0, target * 60 - sec) };
}
const VF_LEFT = (s) => {
  const h = Math.floor(s / 3600), m = Math.floor(s / 60) % 60;
  return h > 0 ? `${h}시간 ${String(m).padStart(2, '0')}분` : `${String(m).padStart(2, '0')}:${String(Math.floor(s) % 60).padStart(2, '0')}`;
};

// ---------- 타이틀 옆 라이브 칩 ----------
function VRFreePill() {
  const { isFree, free, cur } = vfState(useVFClock());
  if (isFree) return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 10px', borderRadius: 99, background: LIME[500], color: VR.ink, fontWeight: 700, fontSize: 12, lineHeight: 1, letterSpacing: '-0.025em', flexShrink: 0 }}>
      <span style={{ width: 5, height: 5, borderRadius: 99, background: VR.ink, animation: 'vfPulse 1.4s ease-in-out infinite' }} />
      지금 무료입장
    </span>
  );
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 10px', borderRadius: 99, background: 'rgba(181,255,96,0.14)', border: '1px solid rgba(181,255,96,0.30)', color: LIME[500], fontWeight: 600, fontSize: 12, lineHeight: 1, letterSpacing: '-0.025em', flexShrink: 0 }}>
      {cur ? `${free.s} 무료입장` : `${free.s}부터 무료`}
    </span>
  );
}

// ---------- 입장료 타임라인 바 ----------
function VFBar({ min }) {
  const pos = Math.min(100, Math.max(0, ((min - VF_T0) / VF_SPAN) * 100));
  const inRange = min >= VF_T0 && min <= VF_T1;
  return (
    <div style={{ position: 'relative' }}>
      <div style={{ display: 'flex', gap: 3, height: 46 }}>
        {VR_FREE.slots.map(s => {
          const on = min >= VF_MIN(s.s) && min < VF_MIN(s.e), fr = s.p === 0;
          return (
            <div key={s.s} style={{ flex: VF_MIN(s.e) - VF_MIN(s.s), minWidth: 0, borderRadius: 10, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 2, position: 'relative', overflow: 'hidden', background: fr ? LIME[500] : VR.tileFill, border: `1px solid ${fr ? LIME[500] : VR.tileBorder}`, opacity: fr || on ? 1 : 0.62, boxShadow: fr ? '0 6px 18px rgba(181,255,96,0.22)' : 'none' }}>
              {fr && <span aria-hidden style={{ position: 'absolute', inset: 0, background: 'linear-gradient(128deg, rgba(255,255,255,0.42), transparent 52%)' }} />}
              <span style={{ position: 'relative', fontWeight: fr ? 700 : 600, fontSize: fr ? 13 : 12, lineHeight: 1, letterSpacing: '-0.025em', color: fr ? VR.ink : on ? VR.t1 : VR.t3, whiteSpace: 'nowrap' }}>{VF_WON(s.p)}</span>
            </div>
          );
        })}
      </div>
      {inRange && (
        <div style={{ position: 'absolute', top: -7, bottom: -7, left: `${pos}%`, width: 2, marginLeft: -1, background: '#fff', borderRadius: 99, boxShadow: '0 0 10px rgba(255,255,255,0.7)', pointerEvents: 'none' }}>
          <span style={{ position: 'absolute', top: -4, left: -3, width: 8, height: 8, borderRadius: 99, background: '#fff' }} />
        </div>
      )}
      <div style={{ display: 'flex', gap: 3, marginTop: 7 }}>
        {VR_FREE.slots.map((s, i) => (
          <div key={s.s} style={{ flex: VF_MIN(s.e) - VF_MIN(s.s), minWidth: 0, position: 'relative' }}>
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: s.p === 0 ? VR.t2 : VR.t4, fontWeight: s.p === 0 ? 600 : 400 }}>{s.s}</span>
            {i === VR_FREE.slots.length - 1 && <span style={{ position: 'absolute', right: 0, top: 0, ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: VR.t4 }}>{s.e}</span>}
          </div>
        ))}
      </div>
    </div>
  );
}

// ---------- 무료입장 메인 카드 ----------
function VRFreeEntry({ onNotify }) {
  const [alarm, setAlarm] = vrState(false);
  const [open, setOpen] = vrState(false);
  const { min, cur, free, isFree, left } = vfState(useVFClock());

  const head = isFree
    ? { k: '지금 무료입장 중', v: `${free.e}까지`, sub: '남은 시간', big: VF_LEFT(left) }
    : left != null
      ? { k: '오늘 무료입장 예정', v: `${free.s} 시작`, sub: '시작까지', big: VF_LEFT(left) }
      : { k: '오늘 무료입장 종료', v: `${free.s} - ${free.e}`, sub: '현재 입장료', big: VF_WON(cur ? cur.p : 10000) };

  return (
    <div>
      <VHead title="시간대별 무료입장" sub="오늘 · 목요일" />
      <VGlass pad={SP.lg} style={{ background: isFree ? 'rgba(181,255,96,0.10)' : VR.cardFill, border: `1px solid ${isFree ? 'rgba(181,255,96,0.34)' : VR.cardBorder}` }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: SP.md }}>
          <div style={{ minWidth: 0 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              {isFree && <span style={{ width: 6, height: 6, borderRadius: 99, background: LIME[500], animation: 'vfPulse 1.4s ease-in-out infinite', flexShrink: 0 }} />}
              <span style={{ ...TYPO.button2, color: isFree ? LIME[500] : VR.t3 }}>{head.k}</span>
            </div>
            <div style={{ ...TYPO.h3, color: VR.t1, marginTop: 7 }}>{head.v}</div>
          </div>
          <div style={{ textAlign: 'right', flexShrink: 0 }}>
            <div style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{head.sub}</div>
            <div style={{ fontWeight: 700, fontSize: 26, lineHeight: '30px', letterSpacing: '-0.03em', marginTop: 4, color: isFree ? LIME[500] : VR.t1, fontVariantNumeric: 'tabular-nums' }}>{head.big}</div>
          </div>
        </div>

        <div style={{ marginTop: SP.lg }}><VFBar min={min} /></div>

        <div style={{ height: 1, background: VR.hair, margin: `${SP.lg}px 0 ${SP.md}px` }} />

        <div style={{ display: 'flex', alignItems: 'center', gap: SP.sm }}>
          <VRIcon d={VRPATH.info} size={14} c={VR.t4} w="1.7" />
          <span style={{ ...TYPO.caption, lineHeight: '17px', color: VR.t4, flex: 1, minWidth: 0 }}>{VR_FREE.cond[0]}</span>
        </div>

        <button onClick={() => { setAlarm(a => !a); onNotify && onNotify(!alarm); }} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', marginTop: SP.md, width: '100%', height: 48, borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 7, background: alarm ? 'rgba(119,49,254,0.20)' : VR.tileFill, border: `1px solid ${alarm ? 'rgba(119,49,254,0.45)' : VR.tileBorder}`, fontWeight: 500, fontSize: 15, letterSpacing: '-0.025em', color: alarm ? VR.lavender : VR.t2, transition: 'background .1s linear' }}>
          <VRIcon d={VRPATH.bellFree} size={16} c={alarm ? VR.lavender : VR.t2} />
          {alarm ? '무료 시간 알림 받는 중' : '무료 시간 시작 전 알림 받기'}
        </button>

        <button onClick={() => setOpen(o => !o)} style={{ all: 'unset', cursor: 'pointer', marginTop: SP.md, width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <span style={{ ...TYPO.button2, color: VR.t3 }}>요일별 무료입장 시간</span>
          <span style={{ display: 'flex', transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .22s' }}><VRChev size={15} /></span>
        </button>
        <div style={{ maxHeight: open ? 340 : 0, overflow: 'hidden', transition: 'max-height .32s ease' }}>
          <div style={{ marginTop: SP.md, display: 'flex', flexDirection: 'column', gap: 9 }}>
            {VR_FREE.week.map(w => (
              <div key={w.d} style={{ display: 'flex', alignItems: 'center', gap: SP.md }}>
                <span style={{ width: 18, ...TYPO.caption, lineHeight: '15px', color: w.today ? VR.t1 : VR.t3, fontWeight: w.today ? 600 : 400 }}>{w.d}</span>
                <span style={{ ...TYPO.caption, lineHeight: '15px', color: !w.w ? RED[500] : w.today ? LIME[500] : VR.t3, fontWeight: w.today || !w.w ? 600 : 400 }}>{w.w || '정기휴무'}</span>
                {w.today && <span style={{ marginLeft: 'auto', ...TYPO.caption, fontSize: 10, lineHeight: '12px', color: VR.lavender, fontWeight: 600, padding: '3px 8px', borderRadius: 6, background: 'rgba(119,49,254,0.22)' }}>오늘</span>}
              </div>
            ))}
            <div style={{ height: 1, background: VR.hair, margin: '3px 0' }} />
            {VR_FREE.cond.slice(1).map(c => (
              <div key={c} style={{ display: 'flex', gap: 7 }}>
                <span style={{ color: VR.t4, flexShrink: 0 }}>·</span>
                <span style={{ ...TYPO.caption, lineHeight: '17px', color: VR.t4 }}>{c}</span>
              </div>
            ))}
          </div>
        </div>
      </VGlass>
    </div>
  );
}

// ---------- 매장 정보 입장료 행에 붙는 요약 ----------
function VRFeeLine() {
  const { isFree, free, cur } = vfState(useVFClock());
  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', gap: SP.sm, flexWrap: 'wrap' }}>
        <span>입장료 <span style={{ color: VR.t1, fontWeight: 600 }}>{window.VR_CLUB.fee}</span></span>
        {isFree
          ? <span style={{ padding: '3px 9px', borderRadius: 99, background: LIME[500], color: VR.ink, fontWeight: 700, fontSize: 12, lineHeight: '14px', letterSpacing: '-0.025em' }}>지금 무료</span>
          : <span style={{ padding: '3px 9px', borderRadius: 99, background: 'rgba(181,255,96,0.14)', border: '1px solid rgba(181,255,96,0.28)', color: LIME[500], fontWeight: 600, fontSize: 12, lineHeight: '14px', letterSpacing: '-0.025em' }}>{free.s} 무료</span>}
      </div>
      <div style={{ ...TYPO.caption, lineHeight: '17px', color: VR.t4, marginTop: 4 }}>
        {free.s} - {free.e} 무료 · 이후 {cur && cur.p ? VF_WON(cur.p) : '5,000원'}부터
      </div>
    </div>
  );
}

Object.assign(window, { VR_FREE, VF_MIN, VF_HHMM, VF_WON, useVFClock, vfState, VRFreePill, VFBar, VRFreeEntry, VRFeeLine });
