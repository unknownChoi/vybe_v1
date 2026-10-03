/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, PURPLE, RED, window, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, VButton, VFooterNote, VToast, VFadeUp, vrState, MRPATH, MR_ME, MR_PROVIDER_LABEL, MRAvatar, MRPushHead, MRScreen, MRCard */
// ============ VYBE — 내 정보 수정 · 리뉴얼 ============
// 바꿀 수 있는 것: 닉네임 · 프로필 사진. 가입 정보는 읽기 전용(잠금).

const MEPATH = {
  lock: '<rect x="4" y="10.5" width="16" height="10.5" rx="2.4"/><path d="M8 10.5V7.6a4 4 0 0 1 8 0v2.9"/>',
  album: '<rect x="3" y="3" width="18" height="18" rx="2.6"/><circle cx="8.8" cy="9" r="1.8"/><path d="M4 17.5l4.6-4.3 3.6 3.2 3-2.7L20 17.5"/>',
  refresh: '<path d="M20.5 12a8.5 8.5 0 1 1-2.6-6.1"/><polyline points="20.8 4.4 20.8 9.2 16 9.2"/>',
  warn: '<path d="M12 3.6 21.4 20H2.6z"/><line x1="12" y1="10" x2="12" y2="14.6"/><circle cx="12" cy="17.4" r="1"/>',
  check: '<polyline points="20 6 9 17 4 12"/>',
  kakao: '<ellipse cx="12" cy="10.6" rx="9" ry="7.4"/><path d="M8.6 17.2 6.9 21.4l4.6-3.2"/>',
  shield: '<path d="M12 2.5 20 6v6c0 4.6-3.2 8.4-8 9.5-4.8-1.1-8-4.9-8-9.5V6z"/><polyline points="8.8 12 11 14.2 15.4 9.8"/>',
  eye: '<path d="M1.8 12S5.6 5 12 5s10.2 7 10.2 7-3.8 7-10.2 7S1.8 12 1.8 12z"/><circle cx="12" cy="12" r="3.2"/>',
  eyeOff: '<path d="M4 4l16 16"/><path d="M9.6 5.5A9.6 9.6 0 0 1 12 5c6.4 0 10.2 7 10.2 7a17 17 0 0 1-2.7 3.5"/><path d="M6.3 7.3A17.4 17.4 0 0 0 1.8 12S5.6 19 12 19c1.4 0 2.7-.3 3.8-.9"/><path d="M9.8 9.9a3.2 3.2 0 0 0 4.4 4.4"/>',
  info: '<circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="11"/><circle cx="12" cy="7.8" r="1"/>',
};

// 기본 프로필 사진 — 성별 3D 피규어 대신 중성 실루엣 글리프
function MEAvatar({ size = 104 }) {
  return (
    <div style={{ width: size, height: size, borderRadius: '50%', flexShrink: 0, overflow: 'hidden', position: 'relative', background: 'linear-gradient(150deg,#2A2440 0%,#221C36 52%,#171327 100%)', border: '1px solid rgba(255,255,255,0.10)', display: 'grid', placeItems: 'center' }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(90% 70% at 30% 12%, rgba(200,168,255,0.20), transparent 62%)' }} />
      <svg width={size * 0.52} height={size * 0.52} viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.62)" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" style={{ display: 'block', position: 'relative', marginTop: size * 0.03 }} dangerouslySetInnerHTML={{ __html: MRPATH.user }} />
    </div>
  );
}

const ME_NICK_MIN = 2, ME_NICK_MAX = 12;
const ME_RE = /^[가-힣a-zA-Z0-9_]*$/;

// ---------- 잠긴 가입 정보 행 ----------
function MELockRow({ label, value, last, note }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: SP.md, minHeight: 52, padding: '13px 0', borderBottom: last ? 'none' : `1px solid ${VR.hair}` }}>
      <span style={{ ...TYPO.body4, color: VR.t4, width: 84, flexShrink: 0 }}>{label}</span>
      <span style={{ flex: 1, minWidth: 0, ...TYPO.body3, fontWeight: 500, color: VR.t2 }}>{value}
        {note && <span style={{ display: 'block', ...TYPO.caption, lineHeight: '16px', color: VR.t4, marginTop: 4 }}>{note}</span>}
      </span>
      <span style={{ flexShrink: 0, opacity: 0.5 }}><VRIcon d={MEPATH.lock} size={14} c={VR.t4} w="1.8" /></span>
    </div>
  );
}

// ---------- 마스킹 ----------
const meMaskName = (v) => v.length <= 2 ? v[0] + '*' : v[0] + '*'.repeat(v.length - 2) + v.slice(-1);
const meMaskBirth = (v) => v.slice(0, 4) + '.**.**';
const meMaskPhone = (v) => { const p = v.split('-'); return p.length === 3 ? `${p[0]}-${'*'.repeat(p[1].length)}-${p[2]}` : v; };

// ---------- 본인인증 카드 (읽기 전용 · 마스킹) ----------
function MEIdCard({ shown, onToggle }) {
  const cells = [
    { k: '성별', v: MR_ME.gender || '여성' },
    { k: '생년월일', v: shown ? MR_ME.birthDate : meMaskBirth(MR_ME.birthDate) },
    { k: '전화번호', v: shown ? MR_ME.phone : meMaskPhone(MR_ME.phone) },
    { k: '로그인', v: (MR_PROVIDER_LABEL[MR_ME.provider] || '-').replace('로 가입', '') },
  ];
  return (
    <div style={{ borderRadius: 19, padding: 20, position: 'relative', overflow: 'hidden', background: 'linear-gradient(145deg,#241D3C 0%,#1A1626 60%,#141119 100%)', border: '1px solid rgba(255,255,255,0.12)' }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(80% 60% at 88% 4%,rgba(119,49,254,0.45),transparent 62%),radial-gradient(60% 50% at 6% 96%,rgba(181,255,96,0.14),transparent 66%)' }} />
      <div style={{ position: 'relative' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: SP.md }}>
          <span style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <VRIcon d={MEPATH.shield} size={13} c={LIME[500]} w="2.2" />
            <span style={{ fontWeight: 700, fontSize: 12, lineHeight: '14px', letterSpacing: '0.06em', color: LIME[500] }}>본인인증 완료</span>
          </span>
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: 'rgba(255,255,255,0.5)' }}>{MR_ME.joinedAt} 가입</span>
        </div>
        <div style={{ fontWeight: 700, fontSize: 24, lineHeight: '28px', letterSpacing: '-0.025em', color: '#fff', marginTop: 14 }}>{shown ? MR_ME.name : meMaskName(MR_ME.name)}</div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px 12px', marginTop: SP.lg }}>
          {cells.map(c => (
            <div key={c.k}>
              <div style={{ fontWeight: 700, fontSize: 10, lineHeight: '13px', letterSpacing: '0.08em', color: 'rgba(255,255,255,0.45)', marginBottom: 4 }}>{c.k}</div>
              <div style={{ fontWeight: 600, fontSize: 15, lineHeight: '19px', letterSpacing: '-0.025em', color: '#fff', fontVariantNumeric: 'tabular-nums' }}>{c.v}</div>
            </div>
          ))}
        </div>
        <button onClick={onToggle} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: '100%', height: 42, marginTop: SP.lg, borderRadius: 12, background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.14)', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}>
          <VRIcon d={shown ? MEPATH.eyeOff : MEPATH.eye} size={15} c={VR.lavender} w="1.9" />
          <span style={{ ...TYPO.button2, fontWeight: 600, color: VR.lavender }}>{shown ? '정보 가리기' : '전체 정보 보기'}</span>
        </button>
      </div>
    </div>
  );
}

// ---------- 경고문 (닉네임 · 사진 운영 안내) ----------
function MEWarnCard({ title, lines }) {
  return (
    <div style={{ display: 'flex', gap: 10, padding: '14px 15px', borderRadius: 14, flexShrink: 0, background: 'rgba(255,92,95,0.07)', border: '1px solid rgba(255,92,95,0.22)' }}>
      <span style={{ flexShrink: 0, marginTop: 2 }}><VRIcon d={MEPATH.warn} size={15} c={RED[500]} w="1.8" /></span>
      <div style={{ minWidth: 0 }}>
        <div style={{ ...TYPO.button2, fontWeight: 700, color: 'rgba(255,163,164,0.95)', marginBottom: 6 }}>{title}</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 5 }}>
          {lines.map((t, i) => (
            <div key={i} style={{ display: 'flex', gap: 7 }}>
              <span style={{ width: 3, height: 3, borderRadius: 99, background: 'rgba(255,255,255,0.3)', flexShrink: 0, marginTop: 8 }} />
              <span style={{ ...TYPO.caption, lineHeight: '18px', color: VR.t3, textWrap: 'pretty' }}>{t}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ---------- 사진 변경 바텀시트 ----------
function MEPhotoSheet({ onClose, onPick }) {
  const items = [
    { k: 'camera', label: '사진 촬영', d: MRPATH.camera },
    { k: 'album', label: '앨범에서 선택', d: MEPATH.album },
    { k: 'reset', label: '기본 이미지로 변경', d: MEPATH.refresh, danger: true },
  ];
  return (
    <div onClick={onClose} style={{ position: 'absolute', inset: 0, zIndex: 70, background: 'rgba(6,5,10,0.6)', ...VR_BLUR(6), display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', animation: 'mrFade .18s ease' }}>
      <div onClick={e => e.stopPropagation()} style={{ margin: `0 ${SP.sm}px 10px`, borderRadius: 22, overflow: 'hidden', background: 'rgba(26,26,30,0.94)', ...VR_BLUR(24), border: `1px solid ${VR.tileBorder}`, boxShadow: '0 -12px 40px rgba(0,0,0,0.5)', animation: 'meSheet .26s cubic-bezier(.2,.8,.2,1)' }}>
        <div style={{ padding: '16px 20px 12px', textAlign: 'center', borderBottom: `1px solid ${VR.hair}` }}>
          <div style={{ ...TYPO.button1, fontWeight: 700, color: VR.t1 }}>프로필 사진</div>
          <div style={{ ...TYPO.caption, lineHeight: '16px', color: VR.t4, marginTop: 5 }}>JPG · PNG · 10MB 이하</div>
        </div>
        {items.map((it, i) => (
          <button key={it.k} onClick={() => onPick(it)} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: '100%', display: 'flex', alignItems: 'center', gap: SP.md, padding: '16px 20px', borderBottom: i === items.length - 1 ? 'none' : `1px solid ${VR.hair}` }}>
            <VRIcon d={it.d} size={17} c={it.danger ? RED[500] : VR.t2} w="1.9" />
            <span style={{ ...TYPO.body3, fontWeight: 500, color: it.danger ? RED[500] : VR.t1 }}>{it.label}</span>
          </button>
        ))}
      </div>
      <button onClick={onClose} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', margin: `0 ${SP.sm}px 26px`, height: 56, borderRadius: 19, background: 'rgba(255,255,255,0.09)', border: `1px solid ${VR.tileBorder}`, ...VR_BLUR(18), display: 'grid', placeItems: 'center', ...TYPO.button1, fontWeight: 700, color: VR.t1 }}>취소</button>
    </div>
  );
}

// ---------- 화면 ----------
function MEEditScreen({ onBack, toast }) {
  const [nick, setNick] = vrState(MR_ME.name);
  const [sheet, setSheet] = vrState(false);
  const [photo, setPhoto] = vrState('기본 이미지');
  const [shown, setShown] = vrState(false);

  const trimmed = nick.trim();
  const bad = !ME_RE.test(nick) ? '한글·영문·숫자·밑줄(_)만 쓸 수 있어요' : trimmed.length && trimmed.length < ME_NICK_MIN ? `${ME_NICK_MIN}자 이상 입력해 주세요` : '';
  const dirty = trimmed !== MR_ME.name || photo !== '기본 이미지';
  const ok = !bad && trimmed.length >= ME_NICK_MIN;

  return (
    <MRScreen>
      <MRPushHead title="내 정보 수정" onBack={onBack} bare />
      <div style={{ flex: 1, minHeight: 0, overflowY: 'auto', scrollbarWidth: 'none', padding: `${SP.xxl}px ${PAGE_H}px ${SP.xxl}px`, display: 'flex', flexDirection: 'column', gap: SP.xxl }}>

        {/* 프로필 사진 */}
        <VFadeUp i={0} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: SP.md }}>
          <button onClick={() => setSheet(true)} style={{ all: 'unset', cursor: 'pointer', position: 'relative', display: 'block' }}>
            <MEAvatar size={104} />
            <span style={{ position: 'absolute', right: -2, bottom: -2, width: 34, height: 34, borderRadius: '50%', background: PURPLE[500], border: `3px solid ${VR.ink}`, display: 'grid', placeItems: 'center', boxShadow: '0 6px 18px rgba(119,49,254,0.5)' }}>
              <VRIcon d={MRPATH.camera} size={15} c="#fff" w="2" />
            </span>
          </button>
          <button onClick={() => setSheet(true)} style={{ all: 'unset', cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 6, height: 34, padding: '0 15px', borderRadius: 999, background: VR.tileFill, border: `1px solid ${VR.tileBorder}`, ...VR_BLUR(14) }}>
            <span style={{ ...TYPO.button2, fontWeight: 600, color: VR.t1 }}>사진 변경</span>
            <VRChev dir="right" size={12} c={VR.t3} w="2.2" />
          </button>
        </VFadeUp>

        {/* 닉네임 */}
        <VFadeUp i={1}>
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '0 4px', marginBottom: SP.sm }}>
            <span style={{ ...TYPO.button2, fontWeight: 700, color: VR.t1 }}>닉네임</span>
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: trimmed.length > ME_NICK_MAX ? RED[500] : VR.t4 }}>{trimmed.length}/{ME_NICK_MAX}</span>
          </div>
          <div style={{ position: 'relative' }}>
            <input value={nick} maxLength={ME_NICK_MAX} onChange={e => setNick(e.target.value)} placeholder="닉네임을 입력해 주세요"
              style={{ width: '100%', boxSizing: 'border-box', height: 54, padding: '0 44px 0 16px', borderRadius: 14, background: 'rgba(255,255,255,0.06)', ...VR_BLUR(10), border: `1px solid ${bad ? 'rgba(255,92,95,0.55)' : VR.tileBorder}`, color: VR.t1, ...TYPO.body3, fontWeight: 500, outline: 'none', transition: 'border-color .15s' }} />
            {!!trimmed && (
              <span style={{ position: 'absolute', right: 15, top: 19, display: 'grid', placeItems: 'center' }}>
                {bad ? <VRIcon d={MEPATH.warn} size={16} c={RED[500]} w="1.9" /> : <VRIcon d={MEPATH.check} size={16} c={LIME[500]} w="2.6" />}
              </span>
            )}
          </div>
          <div style={{ ...TYPO.caption, lineHeight: '16px', color: bad ? RED[500] : VR.t4, marginTop: SP.sm, padding: '0 4px' }}>
            {bad || `한글·영문·숫자 ${ME_NICK_MIN}~${ME_NICK_MAX}자. 클럽 리뷰와 웨이팅 목록에 이 이름이 보여요.`}
          </div>
        </VFadeUp>

        {/* 경고문 */}
        <VFadeUp i={2}>
          <MEWarnCard title="닉네임 · 사진 이용 안내" lines={[
            '닉네임은 변경 후 30일이 지나야 다시 바꿀 수 있어요.',
            '욕설·비방, 타인 사칭, 광고성 닉네임은 안내 없이 초기화될 수 있어요.',
            '본인이 아닌 사람의 사진이나 선정적·폭력적인 이미지는 사용할 수 없어요.',
            '신고가 접수된 사진은 검토 후 기본 이미지로 변경돼요.',
          ]} />
        </VFadeUp>

        {/* 가입 정보 (읽기 전용 · 본인인증 카드) */}
        <VFadeUp i={3} style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 7, padding: '0 4px' }}>
            <span style={{ ...TYPO.button2, fontWeight: 700, color: VR.t1 }}>가입 정보</span>
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '3px 8px', borderRadius: 99, background: 'rgba(255,255,255,0.07)', border: `1px solid ${VR.tileBorder}` }}>
              <VRIcon d={MEPATH.lock} size={10} c={VR.t4} w="2" />
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '14px', color: VR.t4 }}>수정 불가</span>
            </span>
          </div>
          <MEIdCard shown={shown} onToggle={() => setShown(v => !v)} />
          <div style={{ display: 'flex', gap: 9, padding: '13px 15px', borderRadius: 12, background: 'rgba(255,255,255,0.04)', border: `1px solid ${VR.hair}` }}>
            <span style={{ flexShrink: 0, marginTop: 1 }}><VRIcon d={MEPATH.info} size={14} c={VR.t4} w="1.7" /></span>
            <span style={{ ...TYPO.caption, lineHeight: '18px', color: VR.t4, textWrap: 'pretty' }}>본인인증으로 받은 정보라 앱에서 바꿀 수 없어요.</span>
          </div>
        </VFadeUp>

        <VFadeUp i={4}>
          <VFooterNote>이름·성별·생년월일·전화번호는 본인인증으로 받은 정보라 앱에서 바꿀 수 없어요. 변경이 필요하면 고객센터로 문의해 주세요.</VFooterNote>
        </VFadeUp>

        <VFadeUp i={5} style={{ display: 'flex', justifyContent: 'center' }}>
          <a href="%5Bv1%5DMY-032.html" style={{ ...TYPO.button2, color: VR.lavender, textDecoration: 'none', display: 'inline-flex', alignItems: 'center', gap: 3 }}>고객센터 문의<VRChev dir="right" size={13} c={VR.lavender} /></a>
        </VFadeUp>
      </div>

      <div style={{ flexShrink: 0, padding: `${SP.md}px ${PAGE_H}px 30px` }}>
        <VButton label="저장하기" disabled={!dirty || !ok} onClick={() => toast('변경 내용을 저장했어요')} style={{ width: '100%' }} />
      </div>

      {sheet && <MEPhotoSheet onClose={() => setSheet(false)} onPick={it => { setSheet(false); setPhoto(it.k === 'reset' ? '기본 이미지' : '새 사진'); toast(it.k === 'reset' ? '기본 이미지로 바꿨어요' : '사진을 선택했어요'); }} />}
    </MRScreen>
  );
}

function MyEditRenewApp() {
  const [toast, setToast] = vrState('');
  const say = m => { setToast(m); setTimeout(() => setToast(''), 1700); };
  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', background: VR.ink, overflow: 'hidden' }}>
      <MEEditScreen onBack={() => { window.__VBGO('%5Bv1%5DMY-029.html'); }} toast={say} />
      <VToast msg={toast} />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <IOSDevice dark={true} width={393} height={852}><MyEditRenewApp /></IOSDevice>
);
