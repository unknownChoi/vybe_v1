/* global React, TYPO, GRAY, LIME, PURPLE, RED, window, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, VGlass, VHead, VButton, VR_CLUB, vrState, vrEffect */
// ============ VYBE — 웨이팅 (실시간 현황 · 등록 시트) ============

const VW = { teams: 2, wait: 40, min: 1, max: 8, callHold: 10 };
const VW_NOTICE = '웨이팅 등록 후, 방문을 하지 않으면 방문 이력이 노쇼로 처리될 수 있습니다. 노쇼로 처리될 경우, 이후 서비스 이용에 제한이 생길 수 있으니 이 점 확인 부탁드립니다.';

// ---------- 숫자 + 단위 (라임 강조) ----------
function VWStat({ label, value, unit, size = 34 }) {
  return (
    <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: SP.md }}>
      <span style={{ ...TYPO.body4, color: VR.t3 }}>{label}</span>
      <span style={{ display: 'flex', alignItems: 'baseline', gap: 5, color: LIME[500] }}>
        <span style={{ fontWeight: 700, fontSize: size, lineHeight: 1, letterSpacing: '-0.03em' }}>{value}</span>
        <span style={{ fontWeight: 600, fontSize: size * 0.47, lineHeight: 1, letterSpacing: '-0.025em' }}>{unit}</span>
      </span>
    </div>
  );
}

// ---------- 인원 스테퍼 ----------
function VWStepper({ n, onChange }) {
  const btn = (dir, on) => (
    <button onClick={() => on && onChange(n + dir)} style={{ all: 'unset', boxSizing: 'border-box', cursor: on ? 'pointer' : 'not-allowed', width: 38, height: 38, borderRadius: '50%', border: `1px solid ${on ? VR.tileBorder : 'rgba(255,255,255,0.06)'}`, background: on ? VR.tileFill : 'transparent', display: 'grid', placeItems: 'center', transition: 'background .12s linear' }}>
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke={on ? VR.t1 : 'rgba(255,255,255,0.22)'} strokeWidth="2.4" strokeLinecap="round">
        <line x1="5" y1="12" x2="19" y2="12" />{dir > 0 && <line x1="12" y1="5" x2="12" y2="19" />}
      </svg>
    </button>
  );
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: SP.lg }}>
      {btn(-1, n > VW.min)}
      <span style={{ minWidth: 26, textAlign: 'center', ...TYPO.h4, color: VR.t1 }}>{n}</span>
      {btn(1, n < VW.max)}
    </div>
  );
}

// ---------- 하단 모달 시트 ----------
function VWSheet({ open, mode, people, onPeople, onClose, onSubmit, onCancelWaiting, ticket }) {
  if (!open) return null;
  const done = mode === 'ticket';
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 90, display: 'flex', flexDirection: 'column', justifyContent: 'flex-end' }}>
      <div onClick={onClose} style={{ position: 'absolute', inset: 0, background: 'rgba(6,5,10,0.62)', ...VR_BLUR(4), animation: 'vwFade .2s ease' }} />
      <div style={{ position: 'relative', borderTopLeftRadius: 28, borderTopRightRadius: 28, background: 'rgba(23,21,31,0.94)', ...VR_BLUR(34), borderTop: '1px solid rgba(255,255,255,0.14)', boxShadow: '0 -18px 50px rgba(0,0,0,0.55), inset 0 1px 0 rgba(255,255,255,0.16)', padding: `10px ${PAGE_H}px 30px`, animation: 'vwSheet .34s cubic-bezier(.32,.72,0,1)' }}>
        <div style={{ width: 40, height: 4, borderRadius: 99, background: 'rgba(255,255,255,0.20)', margin: '0 auto 14px' }} />

        <h2 style={{ ...TYPO.h4, color: VR.t1, margin: 0, textAlign: 'center', paddingBottom: SP.lg, borderBottom: `1px solid ${VR.hair}` }}>클럽 바이브</h2>

        {done ? (
          <div style={{ padding: `${SP.xxl}px 0`, borderBottom: `1px solid ${VR.hair}`, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: SP.md }}>
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 6, padding: '5px 11px', borderRadius: 99, background: 'rgba(181,255,96,0.14)', border: '1px solid rgba(181,255,96,0.30)', color: LIME[500], fontWeight: 600, fontSize: 12, lineHeight: 1, letterSpacing: '-0.025em' }}>
              <span style={{ width: 5, height: 5, borderRadius: 99, background: 'currentColor', animation: 'vfPulse 1.6s ease-in-out infinite' }} />대기중
            </span>
            <span style={{ display: 'flex', alignItems: 'baseline', gap: 5, color: LIME[500] }}>
              <span style={{ fontWeight: 700, fontSize: 44, lineHeight: 1, letterSpacing: '-0.03em' }}>{ticket.rank}</span>
              <span style={{ fontWeight: 600, fontSize: 20, lineHeight: 1, letterSpacing: '-0.025em' }}>번째</span>
            </span>
            <span style={{ ...TYPO.body4, color: VR.t3 }}>예상 대기시간 약 {ticket.wait}분 · {ticket.people}명</span>
          </div>
        ) : (
          <div style={{ display: 'flex', padding: `${SP.xxl}px 0`, borderBottom: `1px solid ${VR.hair}` }}>
            <VWStat label="현재 웨이팅" value={VW.teams} unit="팀" />
            <span style={{ width: 1, background: VR.hair, margin: '4px 0' }} />
            <VWStat label="예상 대기시간" value={VW.wait} unit="분" />
          </div>
        )}

        {!done && (
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: `${SP.xl}px 4px` }}>
            <span style={{ ...TYPO.button1, color: VR.t1 }}>인원</span>
            <VWStepper n={people} onChange={onPeople} />
          </div>
        )}

        <div style={{ borderRadius: 14, background: 'rgba(255,255,255,0.05)', border: `1px solid ${VR.hair}`, padding: `${SP.lg}px ${SP.lg}px`, marginTop: done ? SP.xl : 0, display: 'flex', flexDirection: 'column', gap: SP.md }}>
          <div style={{ ...TYPO.button2, color: VR.t1 }}>{done ? '호출 안내' : '매장 웨이팅 유의사항'}</div>
          <p style={{ ...TYPO.body4, lineHeight: '21px', color: VR.t3, margin: 0, textWrap: 'pretty' }}>{done ? `순서가 되면 알림을 보내드려요. 호출 후 ${VW.callHold}분 내 미입장 시 자동으로 순번이 취소될 수 있습니다.` : VW_NOTICE}</p>
          <p style={{ ...TYPO.body4, lineHeight: '21px', color: VR.t3, margin: 0 }}>{done ? '매장 사정에 따라 대기시간은 달라질 수 있어요.' : '웨이팅을 등록하면 알림을 드립니다.'}</p>
        </div>

        <div style={{ display: 'flex', gap: SP.md, marginTop: SP.xl }}>
          <VButton label={done ? '닫기' : '취소'} variant="quiet" onClick={onClose} style={{ flex: 1 }} />
          {done
            ? <button onClick={onCancelWaiting} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', flex: 1, height: 56, borderRadius: 12, background: 'rgba(255,92,95,0.14)', border: '1px solid rgba(255,92,95,0.32)', display: 'grid', placeItems: 'center', fontWeight: 500, fontSize: 18, letterSpacing: '-0.025em', color: RED[500] }}>웨이팅 취소</button>
            : <VButton label="웨이팅 등록" onClick={onSubmit} style={{ flex: 1.35 }} />}
        </div>
      </div>
    </div>
  );
}

// ---------- 홈 탭 · 실시간 웨이팅 카드 ----------
function VWLiveCard({ ticket, onOpen }) {
  const done = !!ticket;
  return (
    <div>
      <VHead title="실시간 웨이팅" sub={done ? '내 순번' : '온라인 등록 가능'} />
      <VGlass pad={SP.lg} style={{ background: done ? 'rgba(181,255,96,0.10)' : VR.cardFill, border: `1px solid ${done ? 'rgba(181,255,96,0.30)' : VR.cardBorder}` }}>
        <div style={{ display: 'flex', paddingBottom: SP.lg, borderBottom: `1px solid ${VR.hair}` }}>
          <VWStat label={done ? '내 대기 순번' : '현재 웨이팅'} value={done ? ticket.rank : VW.teams} unit={done ? '번째' : '팀'} size={30} />
          <span style={{ width: 1, background: VR.hair }} />
          <VWStat label="예상 대기시간" value={done ? ticket.wait : VW.wait} unit="분" size={30} />
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: SP.sm, padding: `${SP.md}px 2px ${SP.lg}px` }}>
          <span style={{ width: 6, height: 6, borderRadius: 99, background: LIME[500], animation: 'vfPulse 1.6s ease-in-out infinite', flexShrink: 0 }} />
          <span style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t3 }}>{done ? `${ticket.people}명으로 등록됨 · 순서가 되면 알려드려요` : '방금 전 업데이트 · 현장 상황에 따라 달라질 수 있어요'}</span>
        </div>
        <VButton label={done ? '내 웨이팅 보기' : '웨이팅 등록'} variant={done ? 'quiet' : 'lime'} onClick={onOpen} style={{ width: '100%' }} />
      </VGlass>
    </div>
  );
}

// ---------- 웨이팅 안내 코치마크 ----------
function VWCoach({ show, onClose }) {
  if (!show) return null;
  return (
    <div style={{ position: 'absolute', left: PAGE_H + 62, bottom: 100, zIndex: 32, animation: 'vrToast .3s ease' }}>
      <button onClick={onClose} style={{ all: 'unset', cursor: 'pointer', display: 'block', position: 'relative', padding: '9px 14px', borderRadius: 99, background: PURPLE[500], boxShadow: '0 10px 26px rgba(119,49,254,0.45)', ...TYPO.button2, color: '#fff' }}>
        온라인 웨이팅 등록이 가능한 곳이에요!
        <span aria-hidden style={{ position: 'absolute', left: 46, bottom: -4, width: 10, height: 10, background: PURPLE[500], transform: 'rotate(45deg)', borderRadius: 2 }} />
      </button>
    </div>
  );
}

// ---------- 하단 액션 바 ----------
function VWBottomBar({ saved, saveCount, onSave, ticket, onWaiting, onTable }) {
  return (
    <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, zIndex: 30, padding: `${SP.md}px ${PAGE_H}px 30px`, display: 'flex', alignItems: 'center', gap: SP.md }}>
      <button onClick={onSave} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: 46, height: 56, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 5, flexShrink: 0 }}>
        <span style={{ display: 'flex', transform: saved ? 'scale(1.1)' : 'scale(1)', transition: 'transform .22s cubic-bezier(.34,1.56,.64,1)' }}>
          <VRIcon d={VRPATH.heart} size={23} c={saved ? PURPLE[500] : VR.t2} fill={saved ? PURPLE[500] : 'none'} />
        </span>
        <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: 1, color: saved ? VR.lavender : VR.t4, fontWeight: 600 }}>{saveCount}</span>
      </button>
      <VButton label={ticket ? `웨이팅 ${ticket.rank}번째` : '웨이팅 등록'} variant="quiet" onClick={onWaiting} style={{ flex: 1, ...(ticket ? { background: 'rgba(181,255,96,0.12)', border: '1px solid rgba(181,255,96,0.32)', color: LIME[500] } : null) }} />
      <VButton label="테이블 예약" onClick={onTable} style={{ flex: 1 }} />
    </div>
  );
}

Object.assign(window, { VW, VW_NOTICE, VWStat, VWStepper, VWSheet, VWLiveCard, VWCoach, VWBottomBar });
