/* global React, TYPO, GRAY, LIME, PURPLE, RED, window, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VGlass, VHead, VButton, VFooterNote, MRPATH, MR_ME, MRScreen, MRPushHead, vrState */
// ============ VYBE — 탈퇴하기 (혜택 확인 → 맨 아래 스크롤 → 다이얼로그) ============

const MR_STAR_D = '<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>';
const MR_TICKET_D = '<path d="M3 9V7a1 1 0 0 1 1-1h16a1 1 0 0 1 1 1v2a2.5 2.5 0 0 0 0 5v3a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-3a2.5 2.5 0 0 0 0-5z"/><path d="M13 6v12" stroke-dasharray="2 2.6"/>';

// 잃게 되는 것들 — 실제 계정에 쌓인 값을 그대로 보여준다
const MR_LOSE = (reviews, saved) => [
  { icon: MRPATH.review, n: `리뷰 ${reviews}개`, d: '작성한 후기와 받은 좋아요가 모두 사라져요' },
  { icon: MRPATH.heart, n: `찜한 클럽 ${saved}곳`, d: '저장한 클럽과 라인업 알림이 해제돼요' },
  { icon: MR_STAR_D, n: 'VYBE 등급 GOLD', d: '누적 방문 38회로 얻은 등급이 초기화돼요' },
  { icon: MR_TICKET_D, n: '보유 쿠폰 3장', d: '입장 할인·웰컴 드링크 쿠폰이 즉시 소멸돼요' },
];

function MRLoseRow({ item, last }) {
  return (
    <div style={{ display: 'flex', gap: SP.lg, padding: `${SP.lg}px 0`, borderBottom: last ? 'none' : `1px solid ${VR.hair}` }}>
      <div style={{ flexShrink: 0, width: 38, height: 38, borderRadius: 12, background: 'rgba(255,92,95,0.10)', border: '1px solid rgba(255,92,95,0.20)', display: 'grid', placeItems: 'center' }}>
        <VRIcon d={item.icon} size={18} c={RED[500]} />
      </div>
      <div style={{ paddingTop: 1 }}>
        <div style={{ ...TYPO.body4, fontWeight: 600, color: VR.t1 }}>{item.n}</div>
        <div style={{ ...TYPO.caption, lineHeight: '17px', color: VR.t4, marginTop: 3 }}>{item.d}</div>
      </div>
    </div>
  );
}

// 탈퇴 확인 다이얼로그
function MRLeaveDialog({ onCancel, onConfirm, reviews }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 90, display: 'grid', placeItems: 'center', padding: `0 ${PAGE_H}px` }}>
      <div onClick={onCancel} style={{ position: 'absolute', inset: 0, background: 'rgba(14,13,18,0.72)', ...VR_BLUR(6), animation: 'mrFade .2s ease' }} />
      <VGlass radius={19} pad={SP.xxl} style={{ position: 'relative', width: '100%', maxWidth: 301, animation: 'mrDialog .22s cubic-bezier(.2,.9,.3,1)' }}>
        <div style={{ width: 46, height: 46, borderRadius: 14, background: 'rgba(255,92,95,0.12)', border: '1px solid rgba(255,92,95,0.24)', display: 'grid', placeItems: 'center', margin: '0 auto 16px' }}>
          <span style={{ font: '700 22px/1 Pretendard, sans-serif', color: RED[500] }}>!</span>
        </div>
        <div style={{ ...TYPO.h4, color: VR.t1, textAlign: 'center' }}>정말 탈퇴할까요?</div>
        <div style={{ ...TYPO.body4, lineHeight: '20px', color: VR.t3, textAlign: 'center', marginTop: SP.md }}>
          {MR_ME.name} 님의 리뷰 {reviews}개와<br />등급·쿠폰이 즉시 삭제되고<br />되돌릴 수 없어요.
        </div>
        <div style={{ display: 'flex', gap: SP.md, marginTop: SP.xxl }}>
          <VButton label="더 써볼게요" variant="quiet" onClick={onCancel} style={{ flex: 1, height: 48 }} />
          <button onClick={onConfirm} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', flex: 1, height: 48, borderRadius: 12, display: 'grid', placeItems: 'center', background: RED[500], fontWeight: 500, fontSize: 18, lineHeight: 1, letterSpacing: '-0.025em', color: '#fff' }}>탈퇴</button>
        </div>
      </VGlass>
    </div>
  );
}

function MRLeaveScreen({ onBack, toast, reviews = 0, saved = 0 }) {
  const lose = MR_LOSE(reviews, saved);
  const [atEnd, setAtEnd] = vrState(false);   // 맨 아래까지 읽었는지
  const [agree, setAgree] = vrState(false);
  const [dialog, setDialog] = vrState(false);
  const scRef = React.useRef(null);

  const onScroll = (e) => {
    const el = e.currentTarget;
    if (el.scrollTop + el.clientHeight >= el.scrollHeight - 24) setAtEnd(true);
  };
  const ready = atEnd && agree;

  return (
    <MRScreen>
      <MRPushHead title="탈퇴하기" onBack={onBack} />
      <div ref={scRef} onScroll={onScroll} style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: `0 ${PAGE_H}px 30px` }}>
        <div style={{ padding: `${SP.xxl}px 0 ${SP.xl}px` }}>
          <div style={{ ...TYPO.h3, color: VR.t1, lineHeight: '32px' }}>
            떠나기 전에<br /><span style={{ color: LIME[500] }}>{MR_ME.name}</span> 님이 놓칠 것들이에요
          </div>
          <div style={{ ...TYPO.body4, lineHeight: '21px', color: VR.t4, marginTop: SP.md }}>
            탈퇴하면 아래 기록이 모두 사라져요.<br />끝까지 확인한 뒤 진행할 수 있어요.
          </div>
        </div>

        <VGlass radius={16} pad={`${SP.xs}px ${SP.xl}px`} style={{ marginBottom: SP.xl }}>
          {lose.map((it, i) => <MRLoseRow key={it.n} item={it} last={i === lose.length - 1} />)}
        </VGlass>

        <VHead title="계속 쓰면 이런 게 남아요" />
        <div style={{ display: 'grid', gap: SP.sm, marginBottom: SP.xxl }}>
          {[
            ['GOLD 등급 입장 혜택', '제휴 클럽 20곳 웨이팅 없이 입장'],
            ['찜한 클럽 라인업 알림', '오늘 누가 트는지 시작 전에 먼저'],
            ['리뷰 반응과 팔로워', '내 후기를 보고 찾아오는 사람들'],
          ].map(([t, d]) => (
            <div key={t} style={{ display: 'flex', gap: SP.md, alignItems: 'flex-start', padding: `${SP.md}px ${SP.lg}px`, borderRadius: 12, background: 'rgba(181,255,96,0.06)', border: '1px solid rgba(181,255,96,0.16)' }}>
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke={LIME[500]} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" style={{ flexShrink: 0, marginTop: 2 }}><polyline points="20 6 9 17 4 12" /></svg>
              <div>
                <div style={{ ...TYPO.body4, fontWeight: 600, color: VR.t1 }}>{t}</div>
                <div style={{ ...TYPO.caption, lineHeight: '17px', color: VR.t4, marginTop: 2 }}>{d}</div>
              </div>
            </div>
          ))}
        </div>

        <VHead title="탈퇴 전 확인" />
        <div style={{ display: 'grid', gap: SP.sm }}>
          {[
            '탈퇴 후 30일간 같은 번호로 재가입할 수 없어요.',
            '작성한 리뷰는 삭제되며 복구를 요청할 수 없어요.',
            '보유 쿠폰과 등급 혜택은 환불 대상이 아니에요.',
            '결제 내역은 전자상거래법에 따라 5년간 보관돼요.',
          ].map(t => (
            <div key={t} style={{ display: 'flex', gap: 9, alignItems: 'flex-start' }}>
              <span style={{ width: 3, height: 3, borderRadius: 99, background: VR.t4, flexShrink: 0, marginTop: 8 }} />
              <span style={{ ...TYPO.caption, lineHeight: '18px', color: VR.t3 }}>{t}</span>
            </div>
          ))}
        </div>

        <button onClick={() => setAgree(v => !v)} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: SP.md, width: '100%', marginTop: SP.xl, padding: `${SP.lg}px ${SP.lg}px`, borderRadius: 12, background: agree ? 'rgba(255,92,95,0.08)' : VR.tileFill, border: `1px solid ${agree ? 'rgba(255,92,95,0.28)' : VR.tileBorder}`, transition: 'background .15s, border-color .15s' }}>
          <span style={{ flexShrink: 0, width: 20, height: 20, borderRadius: 6, display: 'grid', placeItems: 'center', background: agree ? RED[500] : 'transparent', border: `1.5px solid ${agree ? RED[500] : VR.t4}`, transition: 'background .15s, border-color .15s' }}>
            {agree && <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>}
          </span>
          <span style={{ ...TYPO.body4, color: agree ? VR.t1 : VR.t3 }}>위 내용을 모두 확인했어요</span>
        </button>

        <div style={{ marginTop: SP.xl }}>
          <button onClick={() => ready && setDialog(true)} disabled={!ready} style={{
            all: 'unset', boxSizing: 'border-box', width: '100%', height: 52, borderRadius: 12, display: 'grid', placeItems: 'center',
            cursor: ready ? 'pointer' : 'default', background: ready ? RED[500] : 'rgba(255,255,255,0.06)',
            border: `1px solid ${ready ? RED[500] : VR.hair}`, color: ready ? '#fff' : VR.t4,
            fontWeight: 500, fontSize: 16, letterSpacing: '-0.025em', transition: 'background .18s, color .18s, border-color .18s',
          }}>탈퇴하기</button>
          <div style={{ marginTop: SP.md, textAlign: 'center', ...TYPO.caption, lineHeight: '16px', color: VR.t4, opacity: ready ? 0 : 1, transition: 'opacity .2s' }}>
            {!atEnd ? '내용을 끝까지 확인해 주세요' : '확인 체크 후 진행할 수 있어요'}
          </div>
        </div>
        <div style={{ marginTop: SP.xl }}><VButton label="계속 vybe 쓸게요" variant="quiet" onClick={onBack} style={{ width: '100%' }} /></div>
      </div>

      {/* 아직 안 읽었을 때 아래로 유도 */}
      <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, height: 78, pointerEvents: 'none', background: 'linear-gradient(180deg, transparent, rgba(14,13,18,0.92))', opacity: atEnd ? 0 : 1, transition: 'opacity .3s' }} />
      <div style={{ position: 'absolute', left: '50%', bottom: 22, transform: 'translateX(-50%)', pointerEvents: 'none', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, opacity: atEnd ? 0 : 1, transition: 'opacity .3s' }}>
        <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t3 }}>아래로 스크롤</span>
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={VR.t3} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" style={{ animation: 'mrNudge 1.4s ease-in-out infinite' }}><polyline points="6 9 12 15 18 9" /></svg>
      </div>

      {dialog && <MRLeaveDialog reviews={reviews} onCancel={() => setDialog(false)} onConfirm={() => { setDialog(false); onBack(); toast('탈퇴 요청이 접수됐어요'); }} />}
    </MRScreen>
  );
}

Object.assign(window, { MR_LOSE, MR_STAR_D, MR_TICKET_D, MRLeaveScreen, MRLeaveDialog });
