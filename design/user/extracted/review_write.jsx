/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, window */
// ============ WRITE REVIEW — LIQUID GLASS ============
const { useState: rwState, useEffect: rwEffect } = React;

const RG_GLASS = { background: 'rgba(120,120,128,0.16)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)', border: '1px solid rgba(255,255,255,0.10)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.16), 0 10px 30px rgba(0,0,0,0.36)' };
const RG_TILE = { background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)' };
const RG_GRAIN = "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='140'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='2'/%3E%3C/filter%3E%3Crect width='140' height='140' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E\")";
const RG_AURORA = ['radial-gradient(75% 260px at 6% 0%, rgba(119,49,254,0.34), transparent 60%)','radial-gradient(70% 240px at 100% 6%, rgba(181,255,96,0.13), transparent 62%)','radial-gradient(90% 340px at 80% 94%, rgba(119,49,254,0.14), transparent 66%)','linear-gradient(180deg, #120f1a 0%, #101013 34%, #0e0d12 100%)'].join(', ');
const INK = '#0e0d12';

const REVIEW_TAGS = ['음악이 좋아요', '사운드 최고', '분위기 좋아요', '직원이 친절해요', '가성비 좋아요', '웨이팅 짧아요', '춤추기 좋아요', '테이블 만족'];
const RATING_LABEL = ['별을 눌러 평가해주세요', '별로예요', '아쉬워요', '괜찮아요', '좋아요', '최고예요'];
const PHOTO_SWATCH = ['linear-gradient(140deg,#4b2b7a,#a24bd0)', 'linear-gradient(140deg,#1d3d6b,#3f8fd0)', 'linear-gradient(140deg,#6b2233,#d0644b)', 'linear-gradient(140deg,#25503a,#7fc06a)'];

const RWStar = ({ size = 40, color = LIME[500] }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill={color} stroke={color} strokeWidth="1" strokeLinecap="round" strokeLinejoin="round">
    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
  </svg>
);

function GlassCard({ children, style, pad = 18 }) {
  return (
    <div style={{ position: 'relative', borderRadius: 19, padding: pad, overflow: 'hidden', flexShrink: 0, ...RG_GLASS, ...style }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 80% at 12% 0%, rgba(255,255,255,0.10), transparent 58%)', pointerEvents: 'none' }} />
      <div style={{ position: 'relative' }}>{children}</div>
    </div>
  );
}

function RWExitAlert({ onStay, onLeave }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 40, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 34, background: 'rgba(6,5,10,0.62)', backdropFilter: 'blur(10px) saturate(140%)', WebkitBackdropFilter: 'blur(10px) saturate(140%)', animation: 'fadeIn .18s ease' }}>
      <div style={{ position: 'relative', width: '100%', maxWidth: 285, borderRadius: 26, overflow: 'hidden', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)', border: '1px solid rgba(181,255,96,0.20)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.18), 0 18px 50px rgba(119,49,254,0.34), 0 0 0 1px rgba(119,49,254,0.18)', background: ['radial-gradient(120% 90% at 8% 0%, rgba(119,49,254,0.52), transparent 62%)', 'radial-gradient(110% 80% at 100% 100%, rgba(181,255,96,0.20), transparent 60%)', 'linear-gradient(165deg, rgba(40,26,66,0.92), rgba(24,24,30,0.92))'].join(', '), animation: 'rwAlertIn .22s cubic-bezier(.2,.9,.3,1)' }}>
        <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 70% at 14% 0%, rgba(255,255,255,0.14), transparent 58%)', pointerEvents: 'none' }} />
        <div style={{ position: 'relative', padding: '26px 22px 20px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 9 }}>
          <div style={{ width: 48, height: 48, borderRadius: '50%', background: 'linear-gradient(140deg, rgba(181,255,96,0.22), rgba(119,49,254,0.42))', border: '1px solid rgba(181,255,96,0.34)', boxShadow: '0 6px 20px rgba(119,49,254,0.34), inset 0 1px 0 rgba(255,255,255,0.22)', display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: 3 }}>
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke={LIME[500]} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 9v4" /><path d="M12 17h.01" /><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z" /></svg>
          </div>
          <span style={{ ...TYPO.button1, color: '#fff', fontWeight: 700, textAlign: 'center' }}>작성을 그만두시겠어요?</span>
          <span style={{ ...TYPO.body4, color: 'rgba(255,255,255,0.52)', textAlign: 'center', lineHeight: '20px' }}>지금 나가면 작성한 내용은<br />저장되지 않아요.</span>
        </div>
        <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', gap: 8, padding: '4px 16px 18px' }}>
          <button onClick={onStay} style={{ all: 'unset', boxSizing: 'border-box', width: '100%', cursor: 'pointer', textAlign: 'center', padding: '14px 0', borderRadius: 14, background: 'linear-gradient(120deg,' + LIME[500] + ' 0%,' + LIME[700] + ' 48%, #7731FE 130%)', boxShadow: '0 8px 22px rgba(119,49,254,0.32), inset 0 1px 0 rgba(255,255,255,0.35)', color: INK, ...TYPO.button1, fontWeight: 700 }}>계속 작성하기</button>
          <button onClick={onLeave} style={{ all: 'unset', boxSizing: 'border-box', width: '100%', cursor: 'pointer', textAlign: 'center', padding: '13px 0', borderRadius: 14, background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.14)', color: 'rgba(255,255,255,0.58)', ...TYPO.button1, fontWeight: 600 }}>저장 안 하고 나가기</button>
        </div>
      </div>
    </div>
  );
}

function WriteReviewPage({ onClose }) {
  const exit = onClose || (() => { if (false) window.history.back(); else window.__VBGO('%5Bv1%5DCLUB-021.html'); });
  const [rating, setRating] = rwState(0);
  const [hover, setHover] = rwState(0);
  const [text, setText] = rwState('');
  const [tags, setTags] = rwState([]);
  const [photos, setPhotos] = rwState([]);
  const [done, setDone] = rwState(false);
  const [confirmExit, setConfirmExit] = rwState(false);
  const canSubmit = rating > 0 && text.trim().length >= 5;
  const shown = hover || rating;
  const dirty = rating > 0 || text.trim().length > 0 || tags.length > 0 || photos.length > 0;
  const back = () => { if (dirty && !done) setConfirmExit(true); else exit(); };

  rwEffect(() => {
    const onKey = (e) => { if (e.key === 'Escape') { if (confirmExit) setConfirmExit(false); else back(); } };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [dirty, done, confirmExit]);

  const toggleTag = (t) => setTags(v => v.includes(t) ? v.filter(x => x !== t) : [...v, t]);
  const addPhoto = () => setPhotos(p => p.length >= 4 ? p : [...p, PHOTO_SWATCH[p.length % PHOTO_SWATCH.length]]);
  const submit = () => { if (!canSubmit) return; setDone(true); setTimeout(exit, 1600); };

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: RG_AURORA, display: 'flex', flexDirection: 'column', fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, opacity: 0.05, backgroundImage: RG_GRAIN, mixBlendMode: 'overlay', pointerEvents: 'none' }} />
      {done ? (
        <div style={{ position: 'relative', flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 14, padding: 32 }}>
          <div style={{ width: 84, height: 84, borderRadius: '50%', ...RG_GLASS, display: 'flex', alignItems: 'center', justifyContent: 'center', animation: 'fadeIn .3s ease' }}>
            <div style={{ width: 58, height: 58, borderRadius: '50%', background: 'linear-gradient(140deg,' + LIME[500] + ',' + LIME[700] + ')', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke={INK} strokeWidth="3.2" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12" /></svg>
            </div>
          </div>
          <div style={{ ...TYPO.h3, color: '#fff', textAlign: 'center' }}>리뷰가 등록됐어요</div>
          <div style={{ ...TYPO.body4, color: 'rgba(255,255,255,0.5)', textAlign: 'center', lineHeight: '20px' }}>소중한 후기 감사합니다<br />다른 사람들에게 큰 도움이 돼요</div>
        </div>
      ) : (
        <>
          <div style={{ position: 'relative', zIndex: 20, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '54px 16px 14px', background: 'rgba(14,13,18,0.55)', backdropFilter: 'blur(18px) saturate(180%)', WebkitBackdropFilter: 'blur(18px) saturate(180%)', borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
            <button onClick={back} style={{ all: 'unset', cursor: 'pointer', width: 34, height: 34, borderRadius: '50%', ...RG_TILE, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>
            </button>
            <span style={{ ...TYPO.button1, color: '#fff', fontWeight: 700 }}>리뷰 작성</span>
            <div style={{ width: 34 }} />
          </div>

          <div style={{ position: 'relative', zIndex: 1, flex: 1, overflowY: 'auto', padding: '18px 16px 24px', display: 'flex', flexDirection: 'column', gap: 14 }}>
            <GlassCard pad={14} style={{ borderRadius: 19 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <div style={{ width: 46, height: 46, borderRadius: 14, background: 'linear-gradient(140deg,#7731FE,#c04bd0)', flexShrink: 0, position: 'relative', overflow: 'hidden' }}>
                  <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 25%, rgba(255,255,255,0.35), transparent 60%)' }} />
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 4, minWidth: 0 }}>
                  <span style={{ ...TYPO.button1, color: '#fff', fontWeight: 700 }}>어썸 레드</span>
                  <span style={{ ...TYPO.caption, lineHeight: '14px', color: 'rgba(255,255,255,0.5)' }}>홍대 · 2026.07.25 방문</span>
                </div>
              </div>
            </GlassCard>

            <GlassCard pad={22}>
              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14 }}>
                <span style={{ ...TYPO.body4, color: 'rgba(255,255,255,0.55)' }}>이 클럽, 어떠셨나요?</span>
                <div style={{ display: 'flex', gap: 10 }} onMouseLeave={() => setHover(0)}>
                  {[1, 2, 3, 4, 5].map(i => {
                    const on = shown >= i;
                    return (
                      <button key={i} onClick={() => setRating(i)} onMouseEnter={() => setHover(i)} style={{ all: 'unset', cursor: 'pointer', lineHeight: 0, filter: on ? 'drop-shadow(0 0 12px rgba(181,255,96,0.45))' : 'none', transform: on ? 'scale(1.06)' : 'scale(1)', transition: 'transform .18s cubic-bezier(.2,.9,.3,1), filter .18s ease' }}>
                        <RWStar size={40} color={on ? LIME[500] : 'rgba(255,255,255,0.14)'} />
                      </button>
                    );
                  })}
                </div>
                <span style={{ ...TYPO.button1, fontWeight: 700, color: shown ? LIME[500] : 'rgba(255,255,255,0.35)', transition: 'color .2s' }}>{RATING_LABEL[shown]}</span>
              </div>
            </GlassCard>

            <GlassCard>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 14 }}>
                <span style={{ ...TYPO.button1, color: '#fff', fontWeight: 700 }}>어떤 점이 좋았나요?</span>
                <span style={{ ...TYPO.caption, lineHeight: '14px', color: 'rgba(255,255,255,0.4)' }}>{tags.length}/8</span>
              </div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
                {REVIEW_TAGS.map(t => {
                  const on = tags.includes(t);
                  return (
                    <button key={t} onClick={() => toggleTag(t)} style={{ all: 'unset', cursor: 'pointer', padding: '9px 14px', borderRadius: 999, ...TYPO.button2, fontWeight: 600, color: on ? INK : 'rgba(255,255,255,0.72)', background: on ? LIME[500] : 'rgba(255,255,255,0.07)', border: '1px solid ' + (on ? LIME[500] : 'rgba(255,255,255,0.12)'), boxShadow: on ? '0 6px 18px rgba(181,255,96,0.22)' : 'inset 0 1px 0 rgba(255,255,255,0.12)', transition: 'all .16s ease' }}>{t}</button>
                  );
                })}
              </div>
            </GlassCard>

            <GlassCard>
              <div style={{ ...TYPO.button1, color: '#fff', fontWeight: 700, marginBottom: 14 }}>사진 첨부<span style={{ ...TYPO.caption, lineHeight: '14px', color: 'rgba(255,255,255,0.4)', fontWeight: 400, marginLeft: 6 }}>선택 · {photos.length}/4</span></div>
              <div style={{ display: 'flex', gap: 10 }}>
                <button onClick={addPhoto} style={{ all: 'unset', cursor: 'pointer', width: 72, height: 72, borderRadius: 14, flexShrink: 0, background: 'rgba(255,255,255,0.05)', border: '1px dashed rgba(255,255,255,0.22)', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 4 }}>
                  <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.6)" strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"><path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3Z" /><circle cx="12" cy="13" r="3.2" /></svg>
                  <span style={{ ...TYPO.caption, lineHeight: '12px', color: 'rgba(255,255,255,0.5)' }}>추가</span>
                </button>
                {photos.map((bg, i) => (
                  <div key={i} style={{ width: 72, height: 72, borderRadius: 14, background: bg, position: 'relative', overflow: 'hidden', flexShrink: 0, animation: 'fadeIn .2s ease' }}>
                    <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 25%, rgba(255,255,255,0.28), transparent 62%)' }} />
                    <button onClick={() => setPhotos(p => p.filter((_, j) => j !== i))} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', top: 5, right: 5, width: 19, height: 19, borderRadius: '50%', background: 'rgba(0,0,0,0.62)', backdropFilter: 'blur(6px)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                      <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3" strokeLinecap="round"><path d="M18 6 6 18M6 6l12 12" /></svg>
                    </button>
                  </div>
                ))}
              </div>
            </GlassCard>

            <GlassCard>
              <div style={{ ...TYPO.button1, color: '#fff', fontWeight: 700, marginBottom: 12 }}>후기를 들려주세요</div>
              <textarea value={text} onChange={e => setText(e.target.value.slice(0, 500))} placeholder="음악, 분위기, 사운드, 서비스는 어땠나요? (최소 5자)" style={{ width: '100%', boxSizing: 'border-box', minHeight: 116, resize: 'none', background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)', backdropFilter: 'blur(10px) saturate(160%)', WebkitBackdropFilter: 'blur(10px) saturate(160%)', borderRadius: 14, padding: 14, color: '#fff', outline: 'none', fontFamily: 'inherit', ...TYPO.body3, lineHeight: '22px' }} />
              <div style={{ textAlign: 'right', marginTop: 8, ...TYPO.caption, lineHeight: '14px', color: 'rgba(255,255,255,0.35)' }}>{text.length}/500</div>
            </GlassCard>

            <div style={{ margin: '2px 4px 0', flexShrink: 0, display: 'flex', flexDirection: 'column', gap: 7 }}>
              <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 600, color: 'rgba(255,255,255,0.45)' }}>리뷰 작성 시 주의사항</span>
              {['실제 방문한 클럽에 대한 후기만 등록할 수 있어요.', '허위·비방·욕설이 담긴 리뷰는 사전 고지 없이 삭제될 수 있어요.', '광고, 홍보, 외부 링크가 포함된 리뷰는 노출이 제한돼요.', '타인의 사진이나 개인정보가 담긴 사진은 첨부하지 말아주세요.', '작성한 리뷰는 내 정보 > 내 리뷰에서 언제든 삭제할 수 있어요.'].map((t, i) => (
                <div key={i} style={{ display: 'flex', gap: 6, alignItems: 'flex-start' }}>
                  <span style={{ width: 3, height: 3, borderRadius: 99, background: 'rgba(255,255,255,0.28)', flexShrink: 0, marginTop: 7 }} />
                  <span style={{ ...TYPO.caption, lineHeight: '17px', color: 'rgba(255,255,255,0.32)' }}>{t}</span>
                </div>
              ))}
            </div>
          </div>

          <div style={{ position: 'relative', zIndex: 2, flexShrink: 0, padding: '12px 16px 20px' }}>
            <button onClick={submit} disabled={!canSubmit} style={{ all: 'unset', boxSizing: 'border-box', width: '100%', textAlign: 'center', cursor: canSubmit ? 'pointer' : 'default', padding: '17px 0', borderRadius: 16, background: canSubmit ? 'linear-gradient(135deg,' + LIME[500] + ',' + LIME[700] + ')' : 'rgba(255,255,255,0.07)', border: '1px solid ' + (canSubmit ? 'transparent' : 'rgba(255,255,255,0.1)'), boxShadow: canSubmit ? '0 10px 30px rgba(181,255,96,0.22), inset 0 1px 0 rgba(255,255,255,0.35)' : 'none', color: canSubmit ? INK : 'rgba(255,255,255,0.3)', ...TYPO.button1, fontWeight: 700, transition: 'all .22s ease' }}>{canSubmit ? '리뷰 등록하기' : '별점과 후기를 입력해주세요'}</button>
          </div>
        </>
      )}
      {confirmExit && <RWExitAlert onStay={() => setConfirmExit(false)} onLeave={() => { setConfirmExit(false); exit(); }} />}
    </div>
  );
}

Object.assign(window, { WriteReviewPage });

const rwRoot = document.getElementById('root');
if (rwRoot && document.body.dataset.page === 'review-write') {
  const isEmbed = new URLSearchParams(window.__VBQ).get('embed') === '1';
  ReactDOM.createRoot(rwRoot).render(
    isEmbed ? <WriteReviewPage /> : <IOSDevice dark={true} width={393} height={852}><WriteReviewPage /></IOSDevice>
  );
}
