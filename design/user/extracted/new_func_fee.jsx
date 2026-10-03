/* global React, cx, won, Icon, Phone, AppBar, Bottom, Badge, Meta, Check, Stepper, Sheet, Dialog, StepI, useToast, useCountUp, goRow, CLUB_IMG, WaitTicket */
/* VYBE v1 — 입장비가 있는 클럽의 비대면 웨이팅 (백엔드 설계 1.1~1.3 기준)
   상태값·용어는 설계 문서 표기를 따른다: waiting · called · entered · noShow · cancelled · closed / paid · refunded */
const { useState: wfS } = React;
const WF_FEE = 20000;
const WF_CLUB = '어썸레드';
const WF_REFUND = [['대기 중(waiting) 취소', '전액 환불'], ['입장 순서(called) 후 취소', '전액 환불'], ['호출 후 10분 미입장(noShow)', '환불 불가'], ['매장 취소 · 웨이팅 마감(closed)', '전액 환불']];
const WF_NOTICE = '웨이팅 등록 후 방문하지 않으면 방문 이력이 노쇼로 처리될 수 있습니다. 노쇼로 처리될 경우 이후 서비스 이용에 제한이 생길 수 있으니 이 점 확인 부탁드립니다.';
const WF_METHODS = [['card', '신용카드', ''], ['kakao', '카카오페이', 'kakao'], ['naver', '네이버페이', 'naver'], ['toss', '토스페이', ''], ['payco', '페이코', ''], ['phone', '휴대폰 결제', '']];
const MNAME = { card: '신용카드 · 신한', kakao: '카카오페이', naver: '네이버페이', toss: '토스페이', payco: '페이코', phone: '휴대폰 결제' };

/* 총 입장비 — 인원 × 1인 입장비 (서버가 최종 계산) */
function WfTotal({ people, fee = WF_FEE, big }) {
  const t = useCountUp(people * fee);
  return <div className="gauge" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10 }}>
    <span className="t-b4 c3" style={{ whiteSpace: 'nowrap' }}>{people}명 × {won(fee)}원</span>
    <span style={{ font: `700 ${big ? 28 : 24}px/1 var(--f)`, letterSpacing: '-.7px', color: 'var(--lime500)', fontVariantNumeric: 'tabular-nums' }}>{won(t)}<small style={{ font: '600 15px var(--f)', color: '#fff', marginLeft: 3 }}>원</small></span>
  </div>;
}
function WfRefundRows({ compact }) {
  return <div className="gcard" style={{ padding: '4px 16px', ...(compact ? { background: 'rgba(255,255,255,.04)', boxShadow: 'none' } : null) }}>
    {WF_REFUND.map(([k, v]) => <div className="kv" key={k}><span>{k}</span><b style={{ color: v === '환불 불가' ? 'var(--red500)' : 'var(--lime500)' }}>{v}</b></div>)}</div>;
}
function WfRefundSheet({ open, onClose }) {
  return <Sheet open={open} onClose={onClose} title="입장비 환불 규정" footer={<button className="vb s" onClick={onClose}>확인</button>}>
    <WfRefundRows compact />
    <div className="fnote" style={{ marginTop: 12 }}><Icon n="info" s={16} /><div><ul>
      <li>· 환불은 결제한 수단으로 자동 처리되며, 카드사에 따라 3~5영업일이 걸릴 수 있어요.</li>
      <li>· 환불이 지연되면 처리 중으로 표시되고, 완료되면 알림을 보내드려요.</li>
      <li>· 입장(entered) 이후에는 취소와 환불이 되지 않아요.</li></ul></div></div>
  </Sheet>;
}

/* WF-01 · WF-02 — 웨이팅 진입 · 인원 선택 (입장비 있는 클럽 / 없는 클럽) */
function WaitEntry({ fee = 1, people: p0 = 2, agree: a0 = false, far = false, sheet: s0 = false }) {
  const [people, setPeople] = wfS(p0); const [agree, setAgree] = wfS(a0); const [sheet, setSheet] = wfS(s0);
  const F = fee ? WF_FEE : 0;
  const miss = far ? '매장 반경 500m 안에서 등록할 수 있어요' : !agree ? '유의사항에 동의해 주세요' : null;
  return <Phone bd="aurora" top={<AppBar title="웨이팅 등록" />} botH={F ? 132 : 124}
    bottom={<Bottom cap={miss}><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('file:[v1]CLUB-021.html')}>닫기</button>
      <button className="vb" style={{ flex: 2 }} disabled={!!miss} onClick={() => goRow(F ? 'wf-03' : 'wf-05')}>{F ? `${won(people * F)}원 결제하고 등록` : '웨이팅 등록'}</button></Bottom>}
    overlay={<WfRefundSheet open={sheet} onClose={() => setSheet(false)} />}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}><img className="thumb" src={CLUB_IMG} alt="" style={{ width: 56, height: 56 }} />
        <div><div className="t-btn1">{WF_CLUB}</div><Meta items={['홍대', '힙합', far ? '1.4km' : '550m']} /></div></div>
      <div className="gcard" style={{ padding: '16px 0 14px' }}>
        <div className="tk-stats two" style={{ margin: 0 }}><div><div className="k">현재 웨이팅</div><div className="v" style={{ color: 'var(--lime500)' }}>2팀</div></div>
          <div><div className="k">예상 대기시간</div><div className="v" style={{ color: 'var(--lime500)' }}>40분</div></div></div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '12px 16px 0', borderTop: '1px solid var(--hair)', marginTop: 12 }}>
          <span style={{ width: 6, height: 6, borderRadius: 99, background: 'var(--lime500)', flex: '0 0 6px' }} />
          <span className="t-cap c3" style={{ lineHeight: 1.4 }}>방금 전 업데이트 · 현장 상황에 따라 달라질 수 있어요</span></div></div>

      {F ? <div className="gcard">
        <div className="shead" style={{ marginBottom: 10 }}><span className="tt">입장비 <span className="v2badge waiting">결제 필요</span></span><button className="lk" onClick={() => setSheet(true)}>환불 규정 ›</button></div>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 6 }}><span style={{ font: '700 30px/1 var(--f)', letterSpacing: '-.8px', color: '#fff' }}>{won(WF_FEE)}</span><span className="t-btn2 c2">원 · 1인</span></div>
        <div className="t-cap c3" style={{ marginTop: 6, lineHeight: 1.5 }}>입장비 결제가 완료되어야 웨이팅이 등록돼요. 결제 전에는 대기 순번이 발급되지 않아요.</div>
      </div> : <div className="gcard">
        <div className="shead" style={{ marginBottom: 10 }}><span className="tt">입장비 <span className="v2badge entered">없음</span></span></div>
        <div className="t-b4 c2">이 클럽은 입장비가 없어요. 결제 없이 바로 웨이팅을 등록할 수 있어요.</div></div>}

      <div className="gcard">
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}><span className="t-btn1">인원</span>
          <Stepper v={people} min={1} max={8} unit="명" onChange={setPeople} /></div>
        {F ? <><div className="hr" style={{ margin: '14px 0' }} />
          <div className="t-cap c4" style={{ marginBottom: 8 }}>총 입장비</div><WfTotal people={people} big />
          <div className="t-cap c4" style={{ marginTop: 8, lineHeight: 1.5 }}>인원을 바꾸면 결제 금액도 함께 바뀌어요 · 최종 금액은 결제 화면에서 다시 확인해요</div></>
          : <div className="t-cap c4" style={{ marginTop: 12 }}>등록 후에는 인원을 변경할 수 없어요</div>}</div>

      <div className="gquiet">
        <div className="t-btn2" style={{ marginBottom: 8 }}>매장 웨이팅 유의사항</div>
        <p className="t-b4 c3" style={{ margin: 0, lineHeight: 1.6, textWrap: 'pretty' }}>{WF_NOTICE}</p>
        <div className="hr" style={{ margin: '14px 0 12px' }} />
        <Check on={agree} onChange={setAgree} style={{ fontSize: 14, color: '#fff' }}><span>유의사항{F ? '과 환불 규정' : ''}을 확인했어요 <span className="cl" style={{ whiteSpace: 'nowrap' }}>(필수)</span></span></Check></div>
    </div></Phone>;
}

/* WF-03 · WF-04 — 입장비 결제 · 결제 처리 중 */
function FeePay({ people = 2, method: m0 = null, terms: t0 = [0, 0], busy = false, step = 1, sheet: s0 = false }) {
  const [method, setMethod] = wfS(m0); const [terms, setTerms] = wfS(t0); const [sheet, setSheet] = wfS(s0); const [run, setRun] = wfS(busy);
  const total = people * WF_FEE;
  const miss = !method ? '결제 수단을 선택해 주세요' : !terms.every(Boolean) ? '필수 항목에 동의해 주세요' : null;
  return <Phone bd="ambient" top={<AppBar title="입장비 결제" />} botH={124}
    bottom={<Bottom cap={miss}><button className="vb" disabled={!!miss} onClick={() => setRun(true)}>{won(total)}원 결제하고 웨이팅 등록</button></Bottom>}
    overlay={<><WfRefundSheet open={sheet} onClose={() => setSheet(false)} />
      {run && <div className="load" style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 18, padding: '0 28px', background: 'rgba(14,13,18,.94)', backdropFilter: 'blur(10px)', WebkitBackdropFilter: 'blur(10px)' }}>
        <div className="spin" style={{ margin: '0 auto' }} />
        <div className="t-h4" style={{ textAlign: 'center' }}>결제를 확인하고 있어요</div>
        <div className="t-b4 c3" style={{ textAlign: 'center', lineHeight: 1.6 }}>결제가 확인되면 대기 순번이 발급돼요.<br />창을 닫거나 앱을 종료하지 마세요.</div>
        <div style={{ width: '100%', marginTop: 6 }}><StepI steps={['결제 요청', '결제 확인', '순번 발급', '등록 완료']} cur={step} /></div>
        <div className="ibn amber" style={{ marginTop: 6 }}><i />결제가 끊기면 웨이팅은 등록되지 않고 자동 환불돼요</div></div>}</>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <div className="gcard" style={{ padding: '4px 16px' }}>{[['매장', WF_CLUB], ['인원', `${people}명`], ['등록 예정', '07월 04일 (금) · 오후 8:12'], ['현재 웨이팅', '2팀 · 예상 40분']].map(([a, b]) => <div key={a} className="kv"><span>{a}</span><b>{b}</b></div>)}</div>

      <div className="gcard">
        <div className="shead" style={{ marginBottom: 4 }}><span className="tt">결제 금액</span><button className="lk" onClick={() => goRow('wf-01')}>인원 변경 ›</button></div>
        <div className="kv"><span>입장비 (1인)</span><b>{won(WF_FEE)}원</b></div>
        <div className="kv"><span>인원</span><b>{people}명</b></div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', gap: 10, paddingTop: 14 }}>
          <span className="t-btn1" style={{ whiteSpace: 'nowrap' }}>총 결제 금액</span><span style={{ font: '700 28px/1 var(--f)', letterSpacing: '-.7px', color: '#fff', whiteSpace: 'nowrap' }}>{won(total)}<small style={{ font: '600 16px var(--f)', marginLeft: 2 }}>원</small></span></div></div>

      <div className="gcard"><div className="shead"><span className="tt">결제 수단 선택</span></div>
        <div className="atiles">{WF_METHODS.map(([k, l, i]) => <button key={k} className={cx('atile', method === k && 'on')} onClick={() => setMethod(k)}><i className={i} />{l}</button>)}</div>
        <div className={cx('acc', method === 'card' && 'open')}><div><div className="fnote" style={{ marginTop: 16 }}><Icon n="info" s={16} /><span>카드사 · 할부는 결제창에서 선택해요 · 5만원 미만은 할부가 제공되지 않아요</span></div></div></div></div>

      <div className="gcard">
        <div className="shead" style={{ marginBottom: 10 }}><span className="tt">취소 · 노쇼 환불 규정</span><button className="lk" onClick={() => setSheet(true)}>전문 보기 ›</button></div>
        <WfRefundRows compact />
        <div className="hr" style={{ margin: '14px 0 4px' }} />
        <Check on={!!terms[0]} onChange={(v) => setTerms([v ? 1 : 0, terms[1]])} style={{ fontSize: 14, padding: '8px 0' }}><span>환불 규정을 확인했으며 이에 동의합니다. <span className="cl" style={{ whiteSpace: 'nowrap' }}>(필수)</span></span></Check>
        <Check on={!!terms[1]} onChange={(v) => setTerms([terms[0], v ? 1 : 0])} style={{ fontSize: 14, padding: '8px 0' }}><span>결제 진행과 결제 정보 제공에 동의합니다. <span className="cl" style={{ whiteSpace: 'nowrap' }}>(필수)</span></span></Check></div>
      <div className="fnote"><Icon n="info" s={16} /><span>결제가 완료되면 서버가 금액을 검증한 뒤 대기 순번을 발급해요. 결제 실패나 결제 중 이탈 시 웨이팅은 등록되지 않아요.</span></div>
    </div></Phone>;
}

/* WF-05 — 웨이팅 등록 완료 (순번 · 예상 시간 · 결제 내역) */
function WaitFeeDone({ people = 2, method = 'card', fee = 1, seq = 5 }) {
  const F = fee ? WF_FEE : 0;
  return <Phone bd="aurora" top={<AppBar title="웨이팅 등록 완료" noBack />} botH={102}
    bottom={<Bottom><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('file:[v1]CLUB-021.html')}>확인</button><button className="vb" style={{ flex: 2 }} onClick={() => goRow('wt-01')}>패스월렛에서 보기</button></Bottom>}>
    <div className="pad" style={{ paddingTop: 20, paddingBottom: 18 }}>
      <div className="succ"><svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12l5 5L20 7" /></svg></div>
      <div className="t-h3 fade-up" style={{ textAlign: 'center', marginTop: 20, animationDelay: '.3s' }}>웨이팅이 등록됐어요</div>
      <div className="t-b4 c3 fade-up" style={{ textAlign: 'center', marginTop: 10, animationDelay: '.35s' }}>순서가 되면 알림으로 알려드려요 · 호출 후 10분 안에 입구로 와주세요</div>
      <div className="tk cmp fade-up" style={{ marginTop: 20, animationDelay: '.42s' }}>
        <div className="tk-h"><i className="tk-hl p on" />
          <div><div className="club">{WF_CLUB} <Badge s="waiting" dot>대기 중</Badge></div><div className="sub">07월 04일 금요일 · 오후 8:12 · 입장 대기 중</div></div></div>
        <div className="tk-cut" />
        <div className="tk-b">
          <div className="tk-lbl">내 대기 번호</div><div className="tk-num">{seq}<small>번</small></div>
          <div className="tk-stats"><div><div className="k">앞에 남은 팀</div><div className="v">2팀</div></div><div><div className="k">예상 대기시간</div><div className="v">20:00</div></div><div><div className="k">인원</div><div className="v">{people}명</div></div></div>
          {F ? <div className="gquiet" style={{ padding: '4px 14px', borderRadius: 14 }}>
            <div className="kv"><span>결제 금액</span><b>{won(people * F)}원</b></div>
            <div className="kv"><span>결제 수단</span><b>{MNAME[method]}</b></div>
            <div className="kv"><span>결제 상태</span><b className="cl">결제 완료</b></div></div> : null}
          <div className="tk-note">{F ? '취소하면 입장비는 전액 환불돼요 · 노쇼는 환불되지 않아요' : '입장 순서가 되면 QR이 표시돼요'}</div>
          <div className="tk-stub"><div><span className="k">ENTRY PASS</span><span className="c">WT-2607-{String(seq).padStart(4, '0')}</span></div><span className="bar" aria-hidden="true" /></div></div></div>
      {F ? <button className="btn s" style={{ width: '100%', marginTop: 12 }} onClick={() => goRow('wf-06')}><Icon n="doc" s={16} />결제 영수증 보기</button> : null}
    </div></Phone>;
}

/* WF-07 — 예외: 결제 실패 · 결제 도중 웨이팅 마감 · 취소 환불 안내 팝업 */
function WfNotice({ tone = 'red', icon = 'info', title, desc, children, actions, top = '결제 실패' }) {
  const c = tone === 'lime' ? 'var(--lime500)' : tone === 'amber' ? 'var(--amber500)' : 'var(--red500)';
  return <Phone bd="ambient" top={<AppBar title={top} noBack />} botH={102} bottom={<Bottom>{actions}</Bottom>}>
    <div className="pad" style={{ paddingTop: 48, paddingBottom: 24 }}>
      <div style={{ width: 80, height: 80, borderRadius: 99, margin: '0 auto', display: 'grid', placeItems: 'center', color: c, background: 'var(--tileFill)', border: `1px solid ${c}`, boxShadow: `0 0 0 10px color-mix(in oklch, ${c} 10%, transparent)` }}><Icon n={icon} s={36} sw={1.8} /></div>
      <div className="t-h3" style={{ textAlign: 'center', marginTop: 22, textWrap: 'balance' }}>{title}</div>
      <div className="t-b4 c3" style={{ textAlign: 'center', marginTop: 12, lineHeight: 1.65, textWrap: 'pretty' }}>{desc}</div>
      <div className="stack" style={{ gap: 12, marginTop: 24 }}>{children}</div>
    </div></Phone>;
}
function FeeStates({ v = 'fail', people = 2 }) {
  const [ov, setOv] = wfS(v === 'cancel');
  const [toast, show] = useToast();
  const total = people * WF_FEE;
  if (v === 'fail') return <WfNotice icon="close" title="결제가 완료되지 않았어요" top="결제 실패"
    desc={<>카드사에서 결제를 승인하지 않았어요.<br />웨이팅은 등록되지 않았고 순번도 사용되지 않았어요.</>}
    actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('wf-01')}>돌아가기</button><button className="vb" style={{ flex: 2 }} onClick={() => goRow('wf-03')}>다시 결제하기</button></>}>
    <div className="gcard" style={{ padding: '4px 16px' }}>{[['실패 사유', '카드 승인 거절'], ['결제 금액', `${won(total)}원`], ['웨이팅', '등록되지 않음']].map(([a, b]) => <div key={a} className="kv"><span>{a}</span><b style={b === '등록되지 않음' ? { color: 'var(--red500)' } : null}>{b}</b></div>)}</div>
    <div className="fnote"><Icon n="info" s={16} /><span>결제가 진행되던 중이었다면 금액은 자동으로 취소돼요. 카드사에 따라 취소 표시가 3~5영업일 걸릴 수 있어요.</span></div>
  </WfNotice>;
  if (v === 'closed') return <WfNotice tone="amber" icon="clock" title="결제하는 동안 웨이팅이 마감됐어요" top="등록 실패"
    desc={<>매장이 오늘 웨이팅을 마감해 등록하지 못했어요.<br />결제한 입장비는 전액 자동 환불돼요.</>}
    actions={<><button className="vb s" style={{ flex: 1 }} onClick={() => goRow('wf-01')}>다른 매장 보기</button><button className="vb" style={{ flex: 2 }} onClick={() => goRow('wf-06')}>환불 내역 보기</button></>}>
    <div className="gcard" style={{ padding: '4px 16px' }}>{[['결제 금액', `${won(total)}원`], ['환불 금액', `${won(total)}원`], ['환불 수단', '신용카드 · 신한']].map(([a, b]) => <div key={a} className="kv"><span>{a}</span><b>{b}</b></div>)}
      <div className="kv"><span>환불 상태</span><b className="cl">환불 완료</b></div></div>
    <div className="ibn amber"><i />환불이 지연되면 처리 중으로 표시되고 완료 시 알림을 보내드려요</div>
  </WfNotice>;
  return <Phone bd="ambient" topH={168} botH={98} top={<><div className="ph-bar" style={{ padding: '0 24px' }}><span style={{ font: '700 24px var(--f)', letterSpacing: '-.6px' }}>패스월렛</span><span className="gtile"><Icon n="bell" s={18} /></span></div><div style={{ padding: '4px 24px 12px' }}><div className="seg" style={{ '--n': 4, '--i': 0 }}><span className="seg-th" />{['입장권', '주문', '예약', '이용 내역'].map((l, i) => <button key={l} className={cx(i === 0 && 'on')} onClick={() => goRow(['pw-01', 'od-10', 'pw-02', 'pw-04'][i])}>{l}</button>)}</div></div></>}
    overlay={<><Dialog open={ov} onClose={() => setOv(false)} title={<>웨이팅을 취소하면<br />입장비가 환불돼요</>} desc="한 번 취소하면 기존 순번은 사라지고 다시 복구할 수 없어요."
      actions={<><button className="btn s" onClick={() => setOv(false)}>돌아가기</button><button className="btn p" onClick={() => { setOv(false); show('웨이팅이 취소됐어요 · 환불이 시작됐어요.'); }}>취소하고 환불받기</button></>}>
      <div className="gquiet" style={{ padding: '4px 14px', textAlign: 'left' }}>
        <div className="kv"><span>결제 금액</span><b>{won(total)}원</b></div>
        <div className="kv"><span>환불 금액</span><b className="cl">{won(total)}원 (전액)</b></div>
        <div className="kv"><span>환불 수단</span><b>신용카드 · 신한</b></div></div>
      <div className="t-cap c4" style={{ textAlign: 'left', marginTop: 8, lineHeight: 1.5 }}>카드사에 따라 3~5영업일이 걸릴 수 있어요</div></Dialog>{toast}</>}>
    <div className="pad" style={{ paddingBottom: 0 }}><WaitTicket st="waiting" fee={WF_FEE} people={people} onCancel={() => setOv(true)} onPost={() => {}} /></div></Phone>;
}
Object.assign(window, { WF_FEE, WF_CLUB, WF_REFUND, WfTotal, WfRefundRows, WfRefundSheet, WfNotice, WaitEntry, FeePay, WaitFeeDone, FeeStates });
