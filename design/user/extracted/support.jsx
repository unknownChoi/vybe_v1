/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, PURPLE, RED, window, VAurora, VR, SP, PAGE_H, VR_BLUR, VR_BTN_LABEL, VRPATH, VRIcon, VRChev, VGlass, VButton, VFooterNote, VToast, VFadeUp, vrState, SPATH, SUP_TYPES, SUP_TYPE, SupTypeTag, SupStatusBadge, SupHead, SupScreen, SupActionBar, SupThumb, SupWarnBox, SupNoteBox, SupStatusMsg, SUP_ITEMS */
// ============ VYBE — 고객센터 · 문의 내역 / 문의 작성 / 답변 상세 ============

// ─────────── 1. 문의 내역 목록 ───────────
const SUP_TABS = [{ k: 'all', l: '전체' }, { k: 'wait', l: '답변 대기' }, { k: 'done', l: '답변 완료' }];

function SupTabs({ tab, onTab, counts }) {
  return (
    <div style={{ flexShrink: 0, display: 'flex', gap: 22, padding: `2px ${PAGE_H}px 0`, borderBottom: `1px solid ${VR.hair}` }}>
      {SUP_TABS.map(t => {
        const on = tab === t.k;
        return (
          <button key={t.k} onClick={() => onTab(t.k)} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', position: 'relative', display: 'inline-flex', alignItems: 'center', gap: 5, padding: '10px 1px 13px', ...TYPO.button1, fontWeight: on ? 700 : 500, color: on ? VR.t1 : VR.t4, transition: 'color .16s ease' }}>
            {t.l}
            <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: on ? LIME[500] : GRAY[600], fontVariantNumeric: 'tabular-nums' }}>{counts[t.k]}</span>
            <span aria-hidden style={{ position: 'absolute', left: 0, right: 0, bottom: -1, height: 2, borderRadius: 2, background: on ? LIME[500] : 'transparent', boxShadow: on ? `0 0 12px ${LIME[500]}66` : 'none', transition: 'background .16s ease' }} />
          </button>
        );
      })}
    </div>
  );
}

function SupCard({ it, i, onOpen }) {
  const [down, setDown] = vrState(false);
  return (
    <VFadeUp i={i}>
      <button onClick={() => onOpen(it)} onPointerDown={() => setDown(true)} onPointerUp={() => setDown(false)} onPointerLeave={() => setDown(false)}
        style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', display: 'block', width: '100%', position: 'relative', overflow: 'hidden', borderRadius: 19, padding: SP.lg, background: down ? 'rgba(120,120,128,0.20)' : VR.quietFill, border: `1px solid ${down ? VR.cardBorder : VR.quietBorder}`, ...VR_BLUR(14), transition: 'background .12s linear' }}>
        <div aria-hidden style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 1, background: 'rgba(255,255,255,0.08)' }} />
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: SP.sm }}>
          <SupTypeTag k={it.type} />
          <SupStatusBadge done={it.done} />
        </div>
        <div style={{ ...TYPO.body3, fontWeight: 600, lineHeight: '22px', color: VR.t1, margin: '11px 0 0', textWrap: 'pretty', display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>{it.title}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 9 }}>
          <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{it.date}</span>
          {it.photos > 0 && <React.Fragment><span style={{ width: 3, height: 3, borderRadius: 99, background: GRAY[600] }} /><span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}><VRIcon d={SPATH.image} size={11} c={VR.t4} w="1.8" />{it.photos}</span></React.Fragment>}
          {it.done && <React.Fragment><span style={{ width: 3, height: 3, borderRadius: 99, background: GRAY[600] }} /><span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.lavender }}>답변 {it.answeredAt}</span></React.Fragment>}
          <span style={{ marginLeft: 'auto', display: 'flex' }}><VRChev dir="right" size={15} c="rgba(255,255,255,0.32)" /></span>
        </div>
      </button>
    </VFadeUp>
  );
}

function SupFab({ onClick }) {
  const [down, setDown] = vrState(false);
  return (
    <button onClick={onClick} onPointerDown={() => setDown(true)} onPointerUp={() => setDown(false)} onPointerLeave={() => setDown(false)}
      style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', position: 'absolute', right: PAGE_H, bottom: 46, zIndex: 30, height: 52, borderRadius: 99, padding: '0 20px', display: 'flex', alignItems: 'center', gap: SP.sm, background: down ? PURPLE[700] : PURPLE[500], boxShadow: '0 10px 30px rgba(119,49,254,0.45), inset 0 1px 0 rgba(255,255,255,0.22)', transition: 'background .1s linear' }}>
      <VRIcon d={SPATH.pen} size={17} c="#fff" w="2" />
      <span style={{ ...VR_BTN_LABEL, fontSize: 16, color: '#fff' }}>문의하기</span>
    </button>
  );
}

function SupListScreen({ items, onOpen, onCreate }) {
  const [tab, setTab] = vrState('all');
  const counts = { all: items.length, wait: items.filter(i => !i.done).length, done: items.filter(i => i.done).length };
  const list = tab === 'all' ? items : items.filter(i => (tab === 'done' ? i.done : !i.done));
  return (
    <SupScreen>
      <SupHead title="문의 내역" backHref="%5Bv1%5DMY-029.html" right={<span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{items.length}건</span>} />
      <SupTabs tab={tab} onTab={setTab} counts={counts} />
      <div style={{ position: 'relative', zIndex: 1, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: `${SP.lg}px ${PAGE_H}px 124px`, display: 'flex', flexDirection: 'column', gap: SP.md }}>
        {list.length === 0 ? (
          <div style={{ padding: '74px 20px', textAlign: 'center' }}>
            <div style={{ width: 60, height: 60, borderRadius: 19, background: 'rgba(119,49,254,0.20)', border: '1px solid rgba(119,49,254,0.42)', display: 'grid', placeItems: 'center', margin: '0 auto 16px' }}><VRIcon d={SPATH.headset} size={25} c={VR.lavender} /></div>
            <div style={{ ...TYPO.body3, fontWeight: 600, color: VR.t1, marginBottom: 7 }}>{tab === 'done' ? '답변 완료된 문의가 없어요' : '답변을 기다리는 문의가 없어요'}</div>
            <div style={{ ...TYPO.body4, lineHeight: '20px', color: VR.t4 }}>문의하면 영업일 기준 1~2일 내에 답변드려요</div>
          </div>
        ) : (
          <React.Fragment>
            {list.map((it, i) => <SupCard key={it.id} it={it} i={i} onOpen={onOpen} />)}
            <VFooterNote>답변은 앱 알림으로 안내되며, 문의 내역은 작성 후 1년간 보관됩니다.</VFooterNote>
          </React.Fragment>
        )}
      </div>
      <SupFab onClick={onCreate} />
    </SupScreen>
  );
}

// ─────────── 2. 문의/신고 작성 ───────────
const SUP_TITLE_MIN = 2, SUP_TITLE_MAX = 40, SUP_BODY_MIN = 10, SUP_BODY_MAX = 1000;

function SupLabel({ children, sub }) {
  return (
    <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginBottom: SP.md }}>
      <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: VR.t4 }}>{children}</span>
      {sub && <span style={{ ...TYPO.caption, lineHeight: '14px', color: GRAY[600] }}>{sub}</span>}
    </div>
  );
}

// VybeTextField 규격 — 하단 라인 (default gray700 · focus purple500 · error red500)
function SupFieldRow({ err, hint, count }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: SP.md, marginTop: 7 }}>
      <span style={{ minWidth: 0 }}>{err ? <SupStatusMsg type="error">{err}</SupStatusMsg> : hint ? <SupStatusMsg>{hint}</SupStatusMsg> : null}</span>
      {count && <span style={{ ...TYPO.caption, lineHeight: '14px', color: count.c, flexShrink: 0, fontVariantNumeric: 'tabular-nums' }}>{count.t}</span>}
    </div>
  );
}

function SupTypePicker({ value, onChange }) {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: SP.sm }}>
      {SUP_TYPES.map((t, i) => {
        const on = value === t.k;
        return (
          <button key={t.k} onClick={() => onChange(t.k)} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', gridColumn: i === 3 ? '1 / -1' : 'auto', height: 46, borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'center', textAlign: 'center', padding: '0 8px', background: on ? LIME[500] : 'rgba(255,255,255,0.06)', border: `1px solid ${on ? LIME[500] : VR.tileBorder}`, boxShadow: on ? '0 6px 18px rgba(181,255,96,0.22)' : 'none', ...TYPO.button2, fontWeight: on ? 700 : 500, color: on ? VR.ink : VR.t3, transition: 'background .15s, border-color .15s, color .15s' }}>{t.label}</button>
        );
      })}
    </div>
  );
}

function SupCreateScreen({ onBack, onSubmit }) {
  const [type, setType] = vrState(null);
  const [title, setTitle] = vrState('');
  const [body, setBody] = vrState('');
  const [tTouch, setTTouch] = vrState(false);
  const [bTouch, setBTouch] = vrState(false);
  const [focus, setFocus] = vrState('');
  const [photos, setPhotos] = vrState([]);

  const tLen = title.trim().length, bLen = body.trim().length;
  const tErr = tTouch && tLen < SUP_TITLE_MIN ? `제목을 ${SUP_TITLE_MIN}자 이상 입력해 주세요` : '';
  const bErr = bTouch && bLen < SUP_BODY_MIN ? `문의 내용을 ${SUP_BODY_MIN}자 이상 입력해 주세요` : '';
  const valid = type && tLen >= SUP_TITLE_MIN && bLen >= SUP_BODY_MIN;

  const line = (name, err) => (err ? RED[500] : focus === name ? PURPLE[500] : GRAY[700]);
  const field = (name, err) => ({ width: '100%', boxSizing: 'border-box', background: 'transparent', border: 0, borderBottom: `1px solid ${line(name, err)}`, borderRadius: 0, padding: '0 0 9px', color: VR.t1, fontFamily: 'inherit', fontSize: 16, lineHeight: '22px', letterSpacing: '-0.025em', outline: 'none', resize: 'none', transition: 'border-color .15s' });

  return (
    <SupScreen push>
      <SupHead title="문의하기" onBack={onBack} />
      <div style={{ position: 'relative', zIndex: 1, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: `${SP.xxl}px ${PAGE_H}px ${SP.xxl}px`, display: 'flex', flexDirection: 'column', gap: 28 }}>
        <div>
          <SupLabel>문의 유형</SupLabel>
          <SupTypePicker value={type} onChange={setType} />
        </div>

        <div>
          <SupLabel>제목</SupLabel>
          <input value={title} onChange={e => { setTitle(e.target.value.slice(0, SUP_TITLE_MAX)); setTTouch(true); }} onFocus={() => setFocus('title')} onBlur={() => { setFocus(''); setTTouch(true); }} placeholder="문의 제목을 입력해 주세요" style={field('title', tErr)} />
          <SupFieldRow err={tErr} hint={`최소 ${SUP_TITLE_MIN}자 이상`} count={{ t: `${title.length}/${SUP_TITLE_MAX}`, c: tErr ? RED[500] : GRAY[500] }} />
        </div>

        <div>
          <SupLabel>문의 내용</SupLabel>
          <textarea value={body} onChange={e => { setBody(e.target.value.slice(0, SUP_BODY_MAX)); setBTouch(true); }} onFocus={() => setFocus('body')} onBlur={() => { setFocus(''); setBTouch(true); }} placeholder="어떤 점이 문제였는지, 언제 어디서 발생했는지 적어 주시면 더 빠르게 확인할 수 있어요." style={{ ...field('body', bErr), minHeight: 132, lineHeight: '23px' }} />
          <SupFieldRow err={bErr} hint={`최소 ${SUP_BODY_MIN}자 · 최대 ${SUP_BODY_MAX}자`} count={{ t: `${body.length}/${SUP_BODY_MAX}`, c: bErr ? RED[500] : body.length > 900 ? '#FFD166' : GRAY[500] }} />
        </div>

        <div>
          <SupLabel sub="선택 · 최대 4장">사진 첨부</SupLabel>
          <div style={{ display: 'flex', gap: SP.sm }}>
            {photos.map((p, i) => <SupThumb key={p} onRemove={() => setPhotos(ps => ps.filter(x => x !== p))} label={`IMG_${i + 1}`} />)}
            {photos.length < 4 && (
              <button onClick={() => setPhotos(ps => [...ps, Date.now() + Math.random()])} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: 72, height: 72, borderRadius: 12, flexShrink: 0, background: 'rgba(255,255,255,0.05)', border: '1px dashed rgba(255,255,255,0.24)', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 5 }}>
                <VRIcon d={SPATH.camera} size={18} c="rgba(255,255,255,0.5)" w="1.7" />
                <span style={{ ...TYPO.caption, lineHeight: '12px', color: VR.t4, fontVariantNumeric: 'tabular-nums' }}>{photos.length}/4</span>
              </button>
            )}
          </div>
        </div>

        <SupWarnBox title="제출 전 확인해 주세요" items={[
          '허위 신고나 반복 장난 신고가 확인되면 서비스 이용이 제한될 수 있어요.',
          '내용·첨부 사진에 주민등록번호, 카드번호 등 민감한 개인정보는 넣지 말아 주세요.',
        ]} />
        <SupNoteBox>문의 내용과 첨부 사진은 답변 처리 목적으로만 사용되며, 처리 완료 후 1년간 보관 뒤 삭제됩니다.</SupNoteBox>
      </div>

      <SupActionBar>
        {!valid && <SupStatusMsg>{!type ? '문의 유형을 선택해 주세요' : `제목 ${SUP_TITLE_MIN}자 · 내용 ${SUP_BODY_MIN}자 이상 입력하면 제출할 수 있어요`}</SupStatusMsg>}
        <VButton label="제출하기" disabled={!valid} onClick={() => onSubmit({ type, title: title.trim(), photos: photos.length })} style={{ width: '100%' }} />
      </SupActionBar>
    </SupScreen>
  );
}

// ─────────── 3. 답변 상세 확인 ───────────
function SupAnswerCard({ it }) {
  return (
    <VGlass radius={19} pad={SP.lg} style={{ position: 'relative' }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 90% at 8% 0%, rgba(119,49,254,0.24), transparent 62%)', pointerEvents: 'none' }} />
      <div style={{ position: 'relative' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: SP.md }}>
          <span style={{ width: 38, height: 38, borderRadius: '50%', flexShrink: 0, background: 'linear-gradient(150deg,#8b52ff 0%,#7731FE 48%,#4E24A0 100%)', boxShadow: '0 6px 18px rgba(119,49,254,0.42)', display: 'grid', placeItems: 'center' }}>
            <VRIcon d={SPATH.headset} size={19} c="#fff" w="1.9" />
          </span>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ ...TYPO.button1, fontWeight: 700, color: VR.t1 }}>vybe 운영팀</div>
            <div style={{ ...TYPO.caption, lineHeight: '15px', color: VR.t4, marginTop: 2 }}>{it.answeredAt} 답변</div>
          </div>
          <SupStatusBadge done />
        </div>
        <div style={{ height: 1, background: VR.hair, margin: `${SP.lg}px 0` }} />
        <p style={{ ...TYPO.body4, lineHeight: '23px', color: VR.t2, margin: 0, whiteSpace: 'pre-line', textWrap: 'pretty' }}>{it.answer}</p>
      </div>
    </VGlass>
  );
}

function SupWaitCard() {
  return (
    <VGlass quiet radius={19} pad={SP.lg} style={{ display: 'flex', gap: SP.md, alignItems: 'flex-start' }}>
      <span style={{ width: 38, height: 38, borderRadius: '50%', flexShrink: 0, background: VR.tileFill, border: `1px solid ${VR.tileBorder}`, display: 'grid', placeItems: 'center' }}>
        <VRIcon d={SPATH.clock} size={18} c={GRAY[400]} w="1.8" />
      </span>
      <div style={{ minWidth: 0 }}>
        <div style={{ ...TYPO.body3, fontWeight: 600, color: VR.t1 }}>답변을 준비하고 있어요</div>
        <div style={{ ...TYPO.caption, lineHeight: '20px', color: VR.t3, marginTop: 4, textWrap: 'pretty' }}>영업일 기준 1~2일 내에 답변드려요. 답변이 등록되면 앱 알림으로 알려드립니다.</div>
      </div>
    </VGlass>
  );
}

function SupDetailScreen({ it, onBack }) {
  return (
    <SupScreen push>
      <SupHead title="문의 상세" onBack={onBack} />
      <div style={{ position: 'relative', zIndex: 1, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: `${SP.xl}px ${PAGE_H}px ${SP.xxl}px`, display: 'flex', flexDirection: 'column', gap: SP.lg }}>
        <VFadeUp i={0}>
          <VGlass quiet radius={19} pad={SP.lg}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: SP.sm }}>
              <SupTypeTag k={it.type} />
              <SupStatusBadge done={it.done} />
            </div>
            <div style={{ ...TYPO.h4, fontSize: 20, lineHeight: '26px', color: VR.t1, margin: '12px 0 0', textWrap: 'pretty' }}>{it.title}</div>
            <div style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4, marginTop: 9 }}>{it.date} 작성</div>
            <div style={{ height: 1, background: VR.hair, margin: `${SP.lg}px 0` }} />
            <p style={{ ...TYPO.body4, lineHeight: '23px', color: VR.t2, margin: 0, whiteSpace: 'pre-line', textWrap: 'pretty' }}>{it.body}</p>
            {it.photos > 0 && (
              <div style={{ marginTop: SP.lg }}>
                <div style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4, marginBottom: SP.sm }}>첨부 사진 {it.photos}장</div>
                <div style={{ display: 'flex', gap: SP.sm }}>
                  {Array.from({ length: it.photos }).map((_, i) => <SupThumb key={i} label={`IMG_${i + 1}`} />)}
                </div>
              </div>
            )}
          </VGlass>
        </VFadeUp>

        <VFadeUp i={1} style={{ marginTop: SP.sm }}>
          <div style={{ ...TYPO.button2, fontWeight: 700, color: VR.t4, marginBottom: SP.md, paddingLeft: 2 }}>운영자 답변</div>
          {it.done ? <SupAnswerCard it={it} /> : <SupWaitCard />}
        </VFadeUp>

        {it.done && <VFooterNote>답변 내용에 궁금한 점이 남았다면 같은 유형으로 다시 문의해 주세요.</VFooterNote>}
      </div>
      <SupActionBar>
        <VButton label="목록으로" variant="quiet" onClick={onBack} style={{ width: '100%' }} />
      </SupActionBar>
    </SupScreen>
  );
}

// ─────────── 루트 ───────────
function SupportApp() {
  const [items, setItems] = vrState(SUP_ITEMS);
  const [view, setView] = vrState('list');
  const [open, setOpen] = vrState(null);
  const [toast, setToast] = vrState('');
  const say = (m) => { setToast(m); clearTimeout(window.__supT); window.__supT = setTimeout(() => setToast(''), 1900); };

  const submit = (draft) => {
    const now = '2026.09.07';
    setItems(prev => [{ id: 'n' + Date.now(), type: draft.type, title: draft.title, date: now, done: false, photos: draft.photos, body: '방금 접수된 문의입니다.' }, ...prev]);
    setView('list');
    say('문의를 접수했어요');
  };

  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', overflow: 'hidden', background: VR.ink, color: VR.t1, fontFamily: "'Pretendard', sans-serif" }}>
      <SupListScreen items={items} onOpen={it => { setOpen(it); setView('detail'); }} onCreate={() => setView('create')} />
      {view === 'create' && <SupCreateScreen onBack={() => setView('list')} onSubmit={submit} />}
      {view === 'detail' && open && <SupDetailScreen it={open} onBack={() => { setView('list'); setOpen(null); }} />}
      <VToast msg={toast} />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <IOSDevice dark={true} width={393} height={852}>
    <SupportApp />
  </IOSDevice>
);
