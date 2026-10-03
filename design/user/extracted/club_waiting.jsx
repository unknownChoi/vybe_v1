/* global React, ReactDOM, IOSDevice, TYPO, LIME, PURPLE, window, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, VGlassRound, VButton, VFooterNote, VToast, VFadeUp, VR_CLUB, VRHero, VRTitle, VRToday, VRMenu, VRPhotos, VRLocation, VRFacilities, VRLineupToday, VRTables, VRNearby, VRMenuTab, VRPhotoTab, VRReviewTab, VRDetailInfo, VRNotice, VRLightbox, VW, VWSheet, VWLiveCard, VWCoach, VWBottomBar, vrState, vrEffect, vrRef */
// ============ VYBE — Club Detail · 웨이팅 · page ============
const VW_TABS = ['홈', '사진', '메뉴', '리뷰', '매장정보'];
const VW_SHOTS = ['assets/club-hero-waiting.jpg'];
const VW_CHROME_H = 100;

function VWChrome({ y, saved, onSave, onShare }) {
  const solid = y > 210;
  return (
    <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 30, paddingTop: 54, background: solid ? VR.barFill : 'transparent', ...(solid ? VR_BLUR(20) : {}), borderBottom: `1px solid ${solid ? VR.hair : 'transparent'}`, transition: 'background .24s ease, border-color .24s ease' }}>
      <div style={{ height: 46, padding: `0 ${PAGE_H - 8}px`, display: 'flex', alignItems: 'center', gap: SP.sm }}>
        <VGlassRound href="%5Bv1%5DHOME-005.html"><VRChev dir="left" size={17} c="#fff" w="2.4" /></VGlassRound>
        <span style={{ flex: 1, minWidth: 0, ...TYPO.button1, color: VR.t1, textAlign: 'center', opacity: y > 250 ? 1 : 0, transition: 'opacity .2s ease', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{VR_CLUB.name}</span>
        <VGlassRound onClick={onShare}><VRIcon d={VRPATH.share} size={15} c="#fff" /></VGlassRound>
        <VGlassRound onClick={onSave}>
          <span style={{ display: 'flex', transform: saved ? 'scale(1.12)' : 'scale(1)', transition: 'transform .22s cubic-bezier(.34,1.56,.64,1)' }}>
            <VRIcon d={VRPATH.heart} size={16} c={saved ? PURPLE[500] : '#fff'} fill={saved ? PURPLE[500] : 'none'} />
          </span>
        </VGlassRound>
      </div>
    </div>
  );
}

function VWTabs({ active, onTab, innerRef }) {
  return (
    <div ref={innerRef} style={{ position: 'sticky', top: VW_CHROME_H, zIndex: 20, flexShrink: 0, marginTop: SP.xl, padding: `9px ${PAGE_H}px`, background: VR.barFill, ...VR_BLUR(20), borderTop: `1px solid ${VR.hair}`, borderBottom: `1px solid ${VR.hair}` }}>
      <div style={{ display: 'flex', gap: 2 }}>
        {VW_TABS.map(t => {
          const sel = t === active;
          return <button key={t} onClick={() => onTab(t)} style={{ all: 'unset', cursor: 'pointer', flex: 1, textAlign: 'center', padding: '9px 0', borderRadius: 99, ...TYPO.button2, fontSize: 12, color: sel ? VR.ink : VR.t3, background: sel ? '#fff' : 'transparent', transition: 'color .18s, background .18s', whiteSpace: 'nowrap' }}>{t}</button>;
        })}
      </div>
    </div>
  );
}

function ClubWaitingApp() {
  const [y, setY] = vrState(0);
  const [active, setActive] = vrState('홈');
  const [saved, setSaved] = vrState(false);
  const [toast, setToast] = vrState('');
  const [shot, setShot] = vrState(null);
  const [sheet, setSheet] = vrState(false);
  const [people, setPeople] = vrState(2);
  const [ticket, setTicket] = vrState(null);
  const [coach, setCoach] = vrState(false);
  const scroller = vrRef(null);
  const tabsEl = vrRef(null);

  vrEffect(() => { const t = setTimeout(() => setCoach(true), 900); return () => clearTimeout(t); }, []);
  const say = (m) => { setToast(m); setTimeout(() => setToast(''), 1800); };
  const save = () => { setSaved(s => { say(s ? '찜 목록에서 빼놨어요' : '찜 목록에 담았어요'); return !s; }); };
  const onScroll = () => { const el = scroller.current; if (el) setY(el.scrollTop); };

  const openSheet = () => { setCoach(false); setSheet(true); };
  /* v1 · 웨이팅 등록 완료 → 44 웨이팅 티켓(WAIT-044). 27 웨이팅 현황은 제거됐다. */
  const register = () => { setSheet(false); window.__VBGO('nf_frame.html?f=wt-01&i=0'); };
  const cancelWaiting = () => { setTicket(null); setSheet(false); say('웨이팅을 취소했어요'); };

  const pick = (t) => {
    setActive(t);
    const el = scroller.current, tb = tabsEl.current;
    if (el && tb && el.scrollTop > tb.offsetTop - VW_CHROME_H) el.scrollTo({ top: tb.offsetTop - VW_CHROME_H, behavior: 'smooth' });
  };

  const panel = {
    '홈': [<VWLiveCard key="w" ticket={ticket} onOpen={openSheet} />, <window.VRFreeEntry key="fe" onNotify={(on) => say(on ? '무료 시간 시작 10분 전에 알려드릴게요' : '알림을 껐어요')} />, <VRToday key="t" />, <VRLineupToday key="l" />, <VRTables key="tb" />, <VRMenu key="m" />, <VRPhotos key="p" />, <VRNearby key="n" />],
    '사진': [<VRPhotoTab key="pt" onOpen={setShot} />],
    '메뉴': [<VRMenuTab key="mt" scrollRef={scroller} />],
    '리뷰': [<VRReviewTab key="rt" />],
    '매장정보': [<VRLocation key="loc" onCopy={() => say('주소가 복사되었습니다')} />, <VRDetailInfo key="di" />, <VRFacilities key="f" />, <VRNotice key="nt" />]
  }[active];
  const note = active === '홈' || active === '매장정보';

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: VR.aurora, fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <div ref={scroller} onScroll={onScroll} style={{ position: 'absolute', inset: 0, overflowY: 'auto', scrollbarWidth: 'none', display: 'flex', flexDirection: 'column' }}>
        <VRHero shots={VW_SHOTS} />
        <VRTitle />
        <VWTabs active={active} onTab={pick} innerRef={tabsEl} />
        <div key={active} style={{ display: 'flex', flexDirection: 'column', gap: SP.xxxl, padding: `${SP.xxl}px ${PAGE_H}px 132px` }}>
          {panel.map((node, i) => <VFadeUp key={i} i={i}>{node}</VFadeUp>)}
          {note && (
            <VFadeUp i={panel.length}>
              <VFooterNote>영업시간 · 입장료 · 웨이팅 현황은 매장 사정에 따라 달라질 수 있으니 방문 전 확인해 주세요.</VFooterNote>
            </VFadeUp>
          )}
        </div>
      </div>

      <VWChrome y={y} saved={saved} onSave={save} onShare={() => say('링크가 복사되었습니다')} />
      <VToast msg={toast} />
      <VWCoach show={coach && !sheet && !ticket} onClose={() => setCoach(false)} />
      <VWBottomBar saved={saved} saveCount={saved ? 129 : 128} onSave={save} ticket={ticket} onWaiting={openSheet} onTable={() => { window.__VBGO('%5Bv1%5DCLUB-023.html'); }} />
      <VWSheet open={sheet} mode={ticket ? 'ticket' : 'form'} ticket={ticket} people={people} onPeople={setPeople} onClose={() => setSheet(false)} onSubmit={register} onCancelWaiting={cancelWaiting} />
      <VRLightbox bg={shot} onClose={() => setShot(null)} />
    </div>
  );
}

const vwRoot = document.getElementById('root');
const vwEmbed = new URLSearchParams(window.__VBQ).get('embed') === '1';
ReactDOM.createRoot(vwRoot).render(
  vwEmbed ? <ClubWaitingApp /> : <IOSDevice dark={true} width={393} height={852}><ClubWaitingApp /></IOSDevice>
);
