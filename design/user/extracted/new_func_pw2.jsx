/* global React, cx, won, Icon, Stars, useToast, Phone, AppBar, Bottom, Badge, Meta, Dialog, StepI, PassQr, FloorPlan, MenuThumb, MENU, OPT, goRow, IMG, CLUB_IMG, RulesTabSheet */
const { useState: p2S, useEffect: p2E, useRef: p2R } = React;

/* PW-06 예약 상세 · entry = 입장 섹션으로 전환된 예약 티켓의 상세(RV-03) */
function ResvDetail({ anchor, entry = false, sharing = false }) {
  const sc = p2R(); const refs = { people: p2R(), seat: p2R(), pay: p2R() }; const [rules, setRules] = p2S(false);
  p2E(() => { const el = refs[anchor] && refs[anchor].current; if (el && sc.current) sc.current.scrollTo({ top: el.offsetTop - 118, behavior: 'smooth' }); }, []);
  const H = ({ ic, t, r }) => <div className="shead"><span className="tt"><Icon n={ic} s={18} />{t}</span>{r}</div>;
  return <Phone bd="ambient" scrollRef={sc} top={<AppBar title={entry ? '티켓 상세' : '예약 상세'} />} botH={102} overlay={<RulesTabSheet open={rules} onClose={() => setRules(false)} />} bottom={<Bottom><button className="vb" onClick={() => goRow(entry ? 'pw-01' : 'pw-02')}>확인</button></Bottom>}>
    <div className="pad stack" style={{ gap: 12, paddingTop: 8, paddingBottom: 24 }}>
      <div className="gcard"><div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 18 }}><div><div className="t-h4">어썸레드</div><div className="meta" style={{ marginTop: 6 }}>07월 04일 (금)<span className="d" />오후 8:12</div></div>{entry ? <Badge s="waiting" dot>대기 중</Badge> : <Badge>예약 확정 · D-10</Badge>}</div>
        <StepI steps={['접수', '확정', '착석', '완료']} cur={entry ? 2 : 1} /></div>
      {entry && <div className="gcard">
        <H ic="ticket" t="입장권 상태" r={<Badge s="waiting" dot>대기 중</Badge>} />
        <div className="tk-stats two" style={{ margin: '4px 0 0' }}>
          <div><div className="k">섹션</div><div className="v">입장</div></div>
          <div><div className="k">자동 전환</div><div className="v">오후 5:12</div></div></div>
        <div className="fnote" style={{ marginTop: 12 }}><Icon n="info" s={16} /><span>입장 3시간 전에 예약 섹션에서 입장 섹션으로 자동 전환됐어요. 티켓에 적힌 정보는 그대로예요.</span></div></div>}
      {entry && <div className="gcard">
        <H ic="share" t="공유" r={sharing ? <Badge s="entered" dot>공유 중</Badge> : <Badge s="done">공유 안 함</Badge>} />
        <div className="tk-stats two" style={{ margin: '4px 0 12px' }}>
          <div><div className="k">공유된 횟수</div><div className="v">{sharing ? '2회' : '0회'}</div></div>
          <div><div className="k">공유 비밀번호</div><div className="v">{sharing ? '설정됨' : '미설정'}</div></div></div>
        <button className="btn s" style={{ width: '100%' }} onClick={() => goRow(sharing ? 'sh-04' : 'sh-02')}><Icon n="share" s={16} />{sharing ? '공유 관리' : '공유하기'}</button></div>}
      <div className="gcard" ref={refs.people}><H ic="user" t="인원 정보" r={<span className="t-btn2 cl">총 3명</span>} />
        <div className="kv" style={{ paddingBottom: 0, borderBottom: 0 }}><span>예약자</span><b>홍길동</b></div></div>
      <div className="gcard" ref={refs.seat}><H ic="table" t="좌석 정보" r={<span className="t-btn2">테이블-4</span>} /><FloorPlan sel="T4" readOnly /></div>
      <div className="gcard" ref={refs.pay}><H ic="doc" t="결제 정보" />
        {[['hardA', 1], ['hardB', 0]].map(([id, o]) => { const m = MENU[id]; return <div key={id} className="mrow"><MenuThumb m={m} /><div className="tx"><div className="nm">{m.nm}</div>{o ? <div className="ds">추가 옵션 · {OPT.nm} (+{won(OPT.pr)}원)</div> : null}<div className="pr">{won(m.pr + (o ? OPT.pr : 0))}원 · 1개</div></div></div>; })}
        <div style={{ marginTop: 16 }}><div style={{ fontSize: 12, color: 'var(--g400)' }}>총 결제 금액</div><div style={{ font: '700 28px var(--f)', letterSpacing: '-.7px', margin: '2px 0 10px' }}>545,500원</div>
          {[['HARD SET A', '225,500'], ['HARD SET B', '320,000']].map(([a, b]) => <div key={a} className="kv" style={{ padding: '8px 0', fontSize: 13 }}><span>{a}</span><b>{b}</b></div>)}
          <div className="kv" style={{ padding: '8px 0', fontSize: 13 }}><span>결제 수단</span><b>신용카드 · 신한 3개월</b></div></div></div>
      <button className="btn s" style={{ width: '100%' }} onClick={() => setRules(true)}><Icon n="doc" s={16} />취소 · 변경 규정 보기</button>
    </div></Phone>;
}

/* PW-07 QR 전체 화면 */
function QrFull({ start = 561 }) {
  return <Phone bd="ambient" top={<AppBar title="입장 QR" onBack={() => {}} right={null} />}>
    <div className="pad" style={{ paddingTop: 8 }}>
      <div className="ibn"><Icon n="sun" s={16} />QR이 보이는 동안 화면 밝기를 최대로 올렸어요</div>
      <div style={{ textAlign: 'center', margin: '32px 0 22px' }}><div className="t-h3">어썸레드</div><div className="meta" style={{ justifyContent: 'center', marginTop: 10 }}>07월 04일 (금)<span className="d" />오후 8:32<span className="d" />2명</div>
        <div style={{ marginTop: 14 }}><Badge s="called">입장 순서</Badge></div></div>
      <div style={{ display: 'grid', placeItems: 'center' }}><PassQr size={224} start={start} /></div>
      <div className="tk-note" style={{ marginTop: 22 }}>입장 시 직원에게 QR을 보여주세요</div>
      <div className="fnote" style={{ marginTop: 20 }}><Icon n="info" s={16} /><span>QR은 10분마다 새로 발급돼요. ↻는 10초에 한 번 누를 수 있어요.</span></div>
    </div></Phone>;
}

/* PW-08 내가 쓴 리뷰 */
const RV_IMGS = [IMG + 'review_photo.jpg', 'assets/pass-1.jpg', 'assets/pass-2.jpg', 'assets/pass-3.jpg', CLUB_IMG];
function MyReview({ menu: m0 = false, del = false }) {
  const [menu, setMenu] = p2S(m0); const [dlg, setDlg] = p2S(del); const [pg, setPg] = p2S(1); const [gone, setGone] = p2S(false);
  const [toast, show] = useToast();
  return <Phone bd="ambient" top={<AppBar title="내가 쓴 리뷰" />} overlay={<>
    {menu && <div style={{ position: 'absolute', inset: 0, zIndex: 54 }} onClick={() => setMenu(false)} />}
    {menu && <div className="pop" style={{ top: 168, right: 24 }}><button className="vsi" onClick={() => { setMenu(false); goRow('pw-09'); }}><Icon n="pencil" s={18} />수정하기</button><button className="vsi" onClick={() => { setMenu(false); setDlg(true); }}><Icon n="trash" s={18} />삭제하기</button></div>}
    <Dialog open={dlg} onClose={() => setDlg(false)} title="리뷰 삭제" desc="리뷰를 삭제하시겠습니까?" actions={<><button className="btn s" onClick={() => setDlg(false)}>취소</button><button className="btn p" onClick={() => { setDlg(false); setGone(true); show('리뷰가 삭제되었어요.'); }}>삭제하기</button></>} />{toast}</>}>
    {gone ? <div className="pad fade-up" style={{ textAlign: 'center', paddingTop: 120 }}><div className="t-h4">작성한 리뷰가 없어요</div><div className="t-b4 c3" style={{ marginTop: 10 }}>방문한 클럽의 후기를 남겨보세요</div></div> : <>
      <div className="pad" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', padding: '8px 24px 16px' }}>
        <div><Meta items={['홍대', '힙합 클럽']} /><div className="t-h3" style={{ marginTop: 8 }}>어썸레드</div></div>
        <button className="gbtn" onClick={() => setMenu(true)} aria-label="더보기"><Icon n="more" s={20} /></button></div>
      <div className="pad" style={{ display: 'flex', alignItems: 'center', gap: 10, paddingBottom: 16 }}><Stars v={3.5} s={22} /><b className="t-btn1">3.5</b><span className="t-cap c4" style={{ marginLeft: 'auto' }}>2025.06.08</span></div>
      <div style={{ position: 'relative' }}><div className="carousel" onScroll={(e) => setPg(Math.round(e.currentTarget.scrollLeft / e.currentTarget.clientWidth) + 1)}>{RV_IMGS.map((s) => <img key={s} src={s} alt="" />)}</div>
        <span style={{ position: 'absolute', right: 16, bottom: 14, padding: '4px 10px', borderRadius: 99, background: 'var(--barFill)', backdropFilter: 'blur(18px)', fontSize: 12, fontWeight: 600 }}>{pg}/5</span></div>
      <div className="pad t-b3 c2" style={{ paddingTop: 20, lineHeight: 1.6 }}>외관이 깔끔해서 들어가보니 내부도 너무 깨끗하고 음악도 너무 좋네요<br />술 종류도 다양해서 잘 놀다왔어요 재방문의사 1000프로</div></>}
  </Phone>;
}

/* PW-09 리뷰 수정 */
function ReviewEdit({ done = false }) {
  const [v, setV] = p2S(3.5); const [pop, setPop] = p2S(0);
  const [txt, setTxt] = p2S('외관이 깔끔해서 들어가보니 내부도 너무 깨끗하고 음악도 너무 좋네요\n술 종류도 다양해서 잘 놀다왔어요 재방문의사 1000프로');
  const [ph, setPh] = p2S([IMG + 'review_photo.jpg', 'assets/pass-1.jpg']); const [busy, setBusy] = p2S(false);
  const [toast, show] = useToast();
  p2E(() => { if (done) setTimeout(() => show('리뷰 등록이 완료되었어요.'), 300); }, []);
  const ok = v > 0 && txt.trim().length >= 10;
  const submit = () => { setBusy(true); setTimeout(() => { setBusy(false); show('리뷰 등록이 완료되었어요.'); }, 900); };
  return <Phone bd="ambient" top={<AppBar title="리뷰 수정" />} botH={102} bottom={<Bottom cap={ok ? null : v === 0 ? '별점을 선택해 주세요' : '리뷰를 10자 이상 적어 주세요'}><button className="vb" disabled={!ok} onClick={submit}>제출하기</button></Bottom>}
    overlay={<>{busy && <div className="load"><div className="spin" /></div>}{toast}</>}>
    <div className="pad" style={{ paddingTop: 8, paddingBottom: 24 }}>
      <div className="t-h4">어썸레드</div><div style={{ marginTop: 8 }}><Meta items={['2025.07.04 (금)', '오후 11:12', '2명']} /></div>
      <div className="gcard" style={{ textAlign: 'center', margin: '20px 0 24px', padding: '20px 16px' }}><div className="t-b3 c2">방문은 어떠셨나요?</div>
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', gap: 14, marginTop: 14 }}><Stars v={v} s={36} pop={pop} onPick={(x) => { setV(x); setPop((p) => p + 1); }} /><b className="t-h4 cl" style={{ minWidth: 36 }}>{v.toFixed(1)}</b></div>
        <div className="t-cap c4">별의 왼쪽 반을 누르면 0.5점</div></div>
      <label className="vtf-f"><span className="vtf-lbl">리뷰 내용</span><textarea className="vtf-in" rows={4} value={txt} maxLength={500} onChange={(e) => setTxt(e.target.value)} style={{ lineHeight: 1.6 }} /></label>
      <div className="t-cap c4" style={{ textAlign: 'right' }}>{txt.length}/500</div>
      <div className="hscroll" style={{ margin: '14px -24px 24px' }}>
        <button className="tap" style={{ flex: '0 0 104px', height: 104, borderRadius: 12, background: 'var(--tileFill)', border: '1px solid var(--tileBorder)', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 6, color: 'var(--t2)' }} onClick={() => setPh((a) => (a.length < 30 ? [...a, CLUB_IMG] : a))}>
          <Icon n="camera" s={22} /><span style={{ fontSize: 12, fontWeight: 600 }}>사진·동영상 추가</span><span style={{ fontSize: 12, color: 'var(--g500)' }}>{ph.length}/30</span></button>
        {ph.map((s) => <div key={s} className="fade-up" style={{ position: 'relative', flex: '0 0 104px' }}><img className="thumb" src={s} alt="" style={{ width: 104, height: 104 }} />
          <button className="gbtn sm" style={{ position: 'absolute', top: 6, right: 6, width: 26, height: 26, flexBasis: 26 }} onClick={() => setPh((a) => a.filter((x) => x !== s))} aria-label="사진 삭제"><Icon n="close" s={13} sw={2.4} /></button></div>)}</div>
      <div className="fnote"><Icon n="info" s={16} /><div><b style={{ color: 'var(--t2)', fontWeight: 600 }}>리뷰 작성 시 유의사항</b><ul>
        <li>· 욕설, 비방, 허위사실, 광고성 내용은 관리자에 의해 삭제될 수 있습니다.</li><li>· 타인의 개인정보(이름, 연락처 등)를 포함하지 마세요.</li>
        <li>· 등록된 리뷰는 운영 정책에 따라 일부 수정 또는 삭제될 수 있습니다.</li><li>· 사진 및 텍스트는 본인의 창작물이어야 하며, 저작권 침해 시 법적 책임이 따를 수 있습니다.</li></ul></div></div>
    </div></Phone>;
}
Object.assign(window, { ResvDetail, QrFull, MyReview, ReviewEdit });
