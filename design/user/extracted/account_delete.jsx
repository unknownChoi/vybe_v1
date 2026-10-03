/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, PURPLE, RED, window, AD, AD_AURORA, AD_GRAIN, ADI, AD_ME, AD_STATS, AD_BENEFITS, AD_REASONS, ADCard, ADSection, adState */
// ============ VYBE — 회원 탈퇴 (만류 화면) ============

function ADHeader() {
  return (
    <div style={{ position: 'relative', zIndex: 5, flexShrink: 0, display: 'flex', alignItems: 'center', gap: 11, padding: '52px 16px 12px' }}>
      <a href="%5Bv1%5DMY-029.html" style={{ width: 38, height: 38, borderRadius: 999, display: 'grid', placeItems: 'center', textDecoration: 'none', ...AD.tile }}><ADI.Back size={19} /></a>
      <span style={{ ...TYPO.body3, fontWeight: 600, color: AD.t2 }}>회원 탈퇴</span>
    </div>
  );
}

function ADStatCard() {
  return (
    <ADCard pad={0} radius={19}>
      <div style={{ display: 'flex', padding: '18px 0 16px' }}>
        {AD_STATS.map((s, i) => (
          <div key={s.label} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 7, borderLeft: i ? `1px solid ${AD.hair}` : 'none' }}>
            <s.Icon size={17} c="rgba(255,255,255,0.5)" />
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 2 }}>
              <span style={{ ...TYPO.h2, fontSize: 28, lineHeight: '28px', color: '#fff' }}>{s.n}</span>
              <span style={{ ...TYPO.body4, color: AD.t3 }}>{s.unit}</span>
            </div>
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: AD.t4 }}>{s.label}</span>
          </div>
        ))}
      </div>
      <div style={{ display: 'flex', gap: 8, alignItems: 'flex-start', padding: '13px 16px', borderTop: `1px solid ${AD.hair}`, background: 'rgba(255,92,95,0.07)' }}>
        <span style={{ width: 15, height: 15, borderRadius: 999, flexShrink: 0, marginTop: 1, display: 'grid', placeItems: 'center', background: 'rgba(255,92,95,0.18)', border: `1px solid rgba(255,92,95,0.34)`, font: '700 10px/1 Pretendard, sans-serif', color: RED[500] }}>!</span>
        <span style={{ ...TYPO.caption, lineHeight: '18px', color: AD.t3 }}>탈퇴하는 순간 리뷰 {AD_ME.reviews}개와 사진 {AD_ME.photos}장이 클럽 페이지에서 바로 내려가요. 최근 검색 기록과 본인인증 상태도 함께 지워져요.</span>
      </div>
    </ADCard>
  );
}

function ADBenefitRow({ b, i }) {
  return (
    <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start', padding: '13px 14px', borderRadius: 14, ...AD.quiet, animation: 'adUp .3s ease both', animationDelay: `${i * 40}ms` }}>
      <span style={{ flexShrink: 0, width: 34, height: 34, borderRadius: 10, display: 'grid', placeItems: 'center', background: b.tint, border: `1px solid ${b.ring}` }}><b.Icon size={17} c={b.hue} /></span>
      <div style={{ flex: 1, minWidth: 0, paddingTop: 1 }}>
        <div style={{ ...TYPO.body4, fontWeight: 600, color: AD.t1 }}>{b.t}</div>
        <div style={{ ...TYPO.caption, lineHeight: '18px', color: AD.t4, marginTop: 3, textWrap: 'pretty' }}>{b.d}</div>
      </div>
    </div>
  );
}

function ADRejoinCard() {
  const steps = [
    { d: AD_ME.leaveDate, t: '탈퇴 처리', s: '찜·리뷰·사진이 즉시 내려가요. 되돌리는 버튼은 없어요.', c: RED[500] },
    { d: `~ ${AD_ME.reopenDate}`, t: '30일 보관 기간 · 재가입 가능', s: '이 기간 안에는 같은 번호로 다시 가입할 수 있어요. 다만 본인인증을 처음부터 다시 하고, 찜·리뷰는 복구되지 않아요.', c: LIME[500] },
    { d: `${AD_ME.reopenDate} 이후`, t: '계정 정보 완전 삭제', s: '보관 기간이 끝나면 계정이 완전히 파기돼 복구 경로가 없어요.', c: GRAY[600] },
  ];
  return (
    <ADCard radius={19} pad={16}>
      {steps.map((s, i) => (
        <div key={s.t} style={{ display: 'flex', gap: 12 }}>
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', flexShrink: 0, width: 10 }}>
            <span style={{ width: 9, height: 9, borderRadius: 999, marginTop: 5, background: s.c, boxShadow: `0 0 0 3px ${s.c}22` }} />
            {i < steps.length - 1 && <span style={{ flex: 1, width: 1, background: 'linear-gradient(180deg, rgba(255,255,255,0.22), rgba(255,255,255,0.06))' }} />}
          </div>
          <div style={{ paddingBottom: i < steps.length - 1 ? 18 : 0 }}>
            <div style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: s.c, letterSpacing: '0.01em' }}>{s.d}</div>
            <div style={{ ...TYPO.body4, fontWeight: 600, color: AD.t1, marginTop: 6 }}>{s.t}</div>
            <div style={{ ...TYPO.caption, lineHeight: '18px', color: AD.t4, marginTop: 4, textWrap: 'pretty' }}>{s.s}</div>
          </div>
        </div>
      ))}
    </ADCard>
  );
}

function ADReasons({ sel, onSel }) {
  const cur = AD_REASONS.find(r => r.k === sel);
  return (
    <div>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
        {AD_REASONS.map(r => {
          const on = r.k === sel;
          return (
            <button key={r.k} onClick={() => onSel(on ? null : r.k)} className="ad-tap" style={{
              all: 'unset', boxSizing: 'border-box', cursor: 'pointer', padding: '9px 14px', borderRadius: 999,
              ...TYPO.body4, fontWeight: on ? 600 : 400, color: on ? '#fff' : AD.t3,
              background: on ? 'rgba(119,49,254,0.28)' : 'rgba(255,255,255,0.07)',
              border: `1px solid ${on ? 'rgba(119,49,254,0.60)' : 'rgba(255,255,255,0.12)'}`,
              backdropFilter: 'blur(18px) saturate(150%)', WebkitBackdropFilter: 'blur(18px) saturate(150%)',
              transition: 'background .16s, border-color .16s, color .16s',
            }}>{r.k}</button>
          );
        })}
      </div>
      {cur && (
        <div key={cur.k} style={{ marginTop: 12, animation: 'adUp .26s cubic-bezier(.2,.9,.3,1) both' }}>
          <ADCard radius={16} pad={15} style={{ background: 'rgba(119,49,254,0.16)', border: '1px solid rgba(119,49,254,0.38)' }}>
            <div style={{ display: 'flex', gap: 11, alignItems: 'flex-start' }}>
              <span style={{ flexShrink: 0, width: 32, height: 32, borderRadius: 10, display: 'grid', placeItems: 'center', background: 'rgba(255,255,255,0.10)', border: '1px solid rgba(255,255,255,0.16)' }}><cur.Icon size={16} c="#C8A8FF" /></span>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ ...TYPO.body4, fontWeight: 600, color: '#fff' }}>{cur.t}</div>
                <div style={{ ...TYPO.caption, lineHeight: '18px', color: AD.t3, marginTop: 4, textWrap: 'pretty' }}>{cur.d}</div>
                <button className="ad-tap" style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', marginTop: 11, display: 'inline-flex', alignItems: 'center', gap: 5, padding: '8px 13px', borderRadius: 10, background: 'rgba(255,255,255,0.10)', border: '1px solid rgba(255,255,255,0.18)', ...TYPO.button2, color: '#fff' }}>
                  {cur.cta}<ADI.Chev size={11} c="rgba(255,255,255,0.7)" />
                </button>
              </div>
            </div>
          </ADCard>
        </div>
      )}
    </div>
  );
}

function ADDialog({ onCancel, onConfirm }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 90, display: 'grid', placeItems: 'center', padding: '0 24px' }}>
      <div onClick={onCancel} style={{ position: 'absolute', inset: 0, background: 'rgba(14,13,18,0.74)', backdropFilter: 'blur(6px)', WebkitBackdropFilter: 'blur(6px)', animation: 'adFade .2s ease' }} />
      <ADCard radius={19} pad={22} style={{ position: 'relative', width: '100%', maxWidth: 301, animation: 'adPop .22s cubic-bezier(.2,.9,.3,1)' }}>
        <div style={{ width: 46, height: 46, borderRadius: 14, background: 'rgba(255,92,95,0.14)', border: '1px solid rgba(255,92,95,0.30)', display: 'grid', placeItems: 'center', margin: '0 auto 16px' }}>
          <span style={{ font: '700 22px/1 Pretendard, sans-serif', color: RED[500] }}>!</span>
        </div>
        <div style={{ ...TYPO.h4, color: '#fff', textAlign: 'center' }}>탈퇴를 진행할까요?</div>
        <div style={{ ...TYPO.body4, lineHeight: '21px', color: AD.t3, textAlign: 'center', marginTop: 10, textWrap: 'pretty' }}>
          리뷰 {AD_ME.reviews}개와 찜 {AD_ME.saved}곳이 지금 사라져요.<br />{AD_ME.reopenDate}까지 재가입은 가능하지만<br />기록은 되돌아오지 않아요.
        </div>
        <div style={{ display: 'flex', gap: 10, marginTop: 20 }}>
          <button onClick={onCancel} className="ad-tap" style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', flex: 1, height: 48, borderRadius: 12, display: 'grid', placeItems: 'center', background: PURPLE[500], font: '500 16px/1 Pretendard, sans-serif', letterSpacing: '-0.025em', color: '#fff' }}>더 써볼게요</button>
          <button onClick={onConfirm} className="ad-tap" style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', flex: 1, height: 48, borderRadius: 12, display: 'grid', placeItems: 'center', background: 'rgba(255,92,95,0.12)', border: `1px solid rgba(255,92,95,0.40)`, font: '500 16px/1 Pretendard, sans-serif', letterSpacing: '-0.025em', color: RED[500] }}>탈퇴</button>
        </div>
      </ADCard>
    </div>
  );
}

function ADDone({ onBack }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 95, background: AD_AURORA, display: 'grid', placeItems: 'center', padding: '0 28px', animation: 'adFade .25s ease' }}>
      <div style={{ textAlign: 'center' }}>
        <div style={{ width: 56, height: 56, borderRadius: 999, margin: '0 auto 18px', display: 'grid', placeItems: 'center', ...AD.tile }}><ADI.Check size={22} c={LIME[500]} /></div>
        <div style={{ ...TYPO.h3, color: '#fff' }}>탈퇴가 완료됐어요</div>
        <div style={{ ...TYPO.body4, lineHeight: '22px', color: AD.t3, marginTop: 12 }}>{AD_ME.reopenDate}까지는 같은 번호로<br />다시 가입할 수 있어요.</div>
        <button onClick={onBack} className="ad-tap" style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', marginTop: 26, width: 200, height: 52, borderRadius: 12, display: 'grid', placeItems: 'center', background: PURPLE[500], font: '500 17px/1 Pretendard, sans-serif', letterSpacing: '-0.025em', color: '#fff' }}>확인</button>
      </div>
    </div>
  );
}

function AccountDeleteApp() {
  const [agree, setAgree] = adState(false);
  const [reason, setReason] = adState(null);
  const [dialog, setDialog] = adState(false);
  const [done, setDone] = adState(false);
  const [nudge, setNudge] = adState(false);
  const ready = agree;
  const onLeave = () => { if (ready) return setDialog(true); setNudge(false); requestAnimationFrame(() => setNudge(true)); };

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: AD_AURORA, display: 'flex', flexDirection: 'column', fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, opacity: 0.05, backgroundImage: AD_GRAIN, mixBlendMode: 'overlay', pointerEvents: 'none', zIndex: 1 }} />
      <ADHeader />

      <div style={{ position: 'relative', zIndex: 2, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: '0 16px 34px' }}>
        <div style={{ padding: '26px 0 20px' }}>
          <div style={{ ...TYPO.h2, lineHeight: '36px', color: '#fff' }}>정말 떠나시겠어요?</div>
          <div style={{ ...TYPO.body3, lineHeight: '24px', color: AD.t3, marginTop: 12, textWrap: 'pretty' }}>
            <span style={{ color: LIME[500], fontWeight: 600 }}>{AD_ME.name}</span> 님이 {AD_ME.joined}부터 쌓은 기록과<br />지금 쓰고 있는 정보들이 어떻게 되는지 먼저 확인해 주세요.
          </div>
        </div>

        <ADStatCard />

        <ADSection title="놓치게 되는 것" sub="탈퇴하면 아래 정보는 더 이상 볼 수 없어요.">
          <div style={{ display: 'grid', gap: 8 }}>
            {AD_BENEFITS.map((b, i) => <ADBenefitRow key={b.t} b={b} i={i} />)}
          </div>
        </ADSection>

        <ADSection title="탈퇴 후 30일" sub="30일 안에는 재가입할 수 있어요. 기록은 돌아오지 않아요.">
          <ADRejoinCard />
        </ADSection>

        <ADSection title="떠나시는 이유를 알려 주세요" sub="이유에 맞는 방법이 따로 있을 수도 있어요.">
          <ADReasons sel={reason} onSel={setReason} />
        </ADSection>

        <button onClick={() => setAgree(v => !v)} className="ad-tap" style={{
          all: 'unset', boxSizing: 'border-box', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 11, width: '100%',
          marginTop: 26, padding: '15px 15px', borderRadius: 14,
          background: agree ? 'rgba(255,92,95,0.08)' : 'rgba(255,255,255,0.07)',
          border: `1px solid ${agree ? 'rgba(255,92,95,0.30)' : 'rgba(255,255,255,0.12)'}`,
          transition: 'background .16s, border-color .16s',
          animation: nudge ? 'adNudge .5s ease' : 'none',
        }} onAnimationEnd={() => setNudge(false)}>
          <span style={{ flexShrink: 0, width: 20, height: 20, borderRadius: 4, display: 'grid', placeItems: 'center', background: agree ? RED[500] : 'transparent', border: `1.4px solid ${agree ? RED[500] : '#8F8F8F'}`, transition: 'background .16s, border-color .16s' }}>
            {agree && <ADI.Check size={11} c="#fff" />}
          </span>
          <span style={{ ...TYPO.body4, lineHeight: '19px', color: agree ? AD.t1 : AD.t3 }}>위 내용을 모두 확인했으며 동의합니다</span>
        </button>

        <div style={{ marginTop: 22, display: 'grid', gap: 14 }}>
          <button onClick={() => window.history.back()} className="ad-tap" style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: '100%', height: 56, borderRadius: 12, display: 'grid', placeItems: 'center', background: PURPLE[500], font: '500 18px/1 Pretendard, sans-serif', letterSpacing: '-0.025em', color: '#fff' }}>계속 이용하기</button>
          <div style={{ display: 'flex', justifyContent: 'center' }}>
            <button onClick={onLeave} aria-disabled={!ready} className="ad-tap" style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', display: 'grid', placeItems: 'center', minHeight: 44, padding: '0 20px', font: '400 13px/16px Pretendard, sans-serif', letterSpacing: '-0.025em', textDecoration: 'underline', textUnderlineOffset: 3, color: ready ? AD.t2 : AD.t4, transition: 'color .18s' }}>탈퇴하기</button>
          </div>
          <div style={{ textAlign: 'center', ...TYPO.caption, lineHeight: '16px', color: nudge ? RED[500] : AD.t4, opacity: ready ? 0 : 1, transition: 'opacity .2s, color .2s', height: 16 }}>확인 체크 후 진행할 수 있어요</div>
        </div>
      </div>

      {dialog && <ADDialog onCancel={() => setDialog(false)} onConfirm={() => { setDialog(false); setDone(true); }} />}
      {done && <ADDone onBack={() => setDone(false)} />}
    </div>
  );
}

const adRoot = document.getElementById('root');
const adEmbed = new URLSearchParams(window.__VBQ).get('embed') === '1';
ReactDOM.createRoot(adRoot).render(
  adEmbed ? <AccountDeleteApp /> : <IOSDevice dark={true} width={393} height={852}><AccountDeleteApp /></IOSDevice>
);
