/* global React, TYPO, GRAY, LIME, PURPLE, RED, window, VAurora, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, VGlass, VHead, VButton, VGlassRound, VFooterNote, VFadeUp, vrState */
// ============ VYBE — My · Renewal · screens (리뷰관리 · 정보수정 · 설정) ============

const MRPATH = {
  bell: '<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/>',
  gear: '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>',
  review: '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>',
  heart: '<path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>',
  mega: '<path d="M3 11v2a1 1 0 0 0 1 1h2l5 4V6L6 10H4a1 1 0 0 0-1 1z"/><path d="M16 8.5a4 4 0 0 1 0 7"/>',
  trash: '<polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/>',
  camera: '<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="3.6"/>',
  logout: '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>',
  user: '<circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/>',
  pencil: '<path d="M17 3a2.83 2.83 0 0 1 4 4L7.5 20.5 2 22l1.5-5.5z"/>',
  pin: '<path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z"/><circle cx="12" cy="10" r="3"/>',
  moon: '<path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/>',
  globe: '<circle cx="12" cy="12" r="9"/><path d="M3.6 9h16.8M3.6 15h16.8"/><path d="M12 3a15 15 0 0 1 0 18 15 15 0 0 1 0-18z"/>',
};

const MR_ME = { name: '김바이브', handle: 'vibe_kim', provider: 'kakao', phone: '010-1234-5678', birthDate: '1997.03.14', joinedAt: '2025.11.02', bio: '테크노 · 하우스 좋아하는 주말 클러버', gender: '여성', birth: '1997', region: '서울 마포' };
const MR_PROVIDER_LABEL = { naver: '네이버로 가입', kakao: '카카오로 가입', apple: 'Apple로 가입', phone: '휴대폰으로 가입' };

const MR_REVIEWS = [
  { id: 'r1', club: 'OCTAGON', area: '강남', rating: 5.0, date: '2026.07.12', likes: 24, text: '빅룸 사운드가 진짜 미쳤어요. VAULT 셋이 하이라이트였고 사운드 시스템이 압도적이었습니다. 다음 주말에 또 방문 예정!', photos: ['linear-gradient(150deg,#06222e,#102a4a 55%,#2B6BFF)', 'linear-gradient(150deg,#0c1430,#4361ee)'] },
  { id: 'r2', club: '글로우', area: '압구정', rating: 4.5, date: '2026.06.28', likes: 11, text: '하우스 라인업이 탄탄하고 분위기가 좋아요. 웰컴 드링크도 만족스러웠습니다.', photos: ['linear-gradient(150deg,#07211f,#0a3a36 52%,#28E0E0)'] },
  { id: 'r3', club: '메이드', area: '이태원', rating: 4.0, date: '2026.06.14', likes: 8, text: '테크노 좋아하면 강추. 새벽 타임 KORE 셋 분위기 최고였어요.', photos: [] },
  { id: 'r4', club: '소다', area: '강남', rating: 4.5, date: '2026.05.30', likes: 16, text: '트랜스 스페셜 데이 갔는데 ZEPH 셋이 정말 좋았어요. 층고가 높아서 시원한 느낌.', photos: ['linear-gradient(150deg,#16213e,#4361ee)'] },
  { id: 'r5', club: '펄스', area: '홍대', rating: 3.5, date: '2026.05.11', likes: 4, text: '홍대라 접근성은 좋은데 규모가 아담해요. 가볍게 놀기 좋음.', photos: [] },
];

// ---------- 아바타 (성별 3D 아이콘) ----------
// 이름 이니셜 대신 성별 아이콘을 넣는다. gender: '여성' | '남성' (없으면 중성 실루엣)
function MRGenderFigure({ size = 76, gender = MR_ME.gender }) {
  const uid = React.useId().replace(/:/g, '');
  const female = String(gender).includes('여');
  const male = String(gender).includes('남');
  const g = n => `${n}-${uid}`;
  const face = 'M32 14.4c5.7 0 9.9 4.3 9.9 10.5 0 7.3-4.4 12.8-9.9 12.8s-9.9-5.5-9.9-12.8c0-6.2 4.2-10.5 9.9-10.5z';
  return (
    <svg width={size} height={size} viewBox="0 0 64 64" style={{ display: 'block' }}>
      <defs>
        <linearGradient id={g('sk')} x1="24%" y1="4%" x2="80%" y2="98%">
          <stop offset="0" stopColor="#FFFDFF" /><stop offset="0.5" stopColor="#F2E7FF" /><stop offset="1" stopColor="#CBAEF7" />
        </linearGradient>
        <linearGradient id={g('bd')} x1="16%" y1="0%" x2="88%" y2="100%">
          <stop offset="0" stopColor="#F6EFFF" /><stop offset="0.52" stopColor="#DDCBFC" /><stop offset="1" stopColor="#A98BE6" />
        </linearGradient>
        <linearGradient id={g('hr')} x1="22%" y1="0%" x2="78%" y2="100%">
          <stop offset="0" stopColor="#5A2A9C" /><stop offset="0.5" stopColor="#33135C" /><stop offset="1" stopColor="#190826" />
        </linearGradient>
        <radialGradient id={g('hl')} cx="34%" cy="24%" r="66%">
          <stop offset="0" stopColor="#fff" stopOpacity="0.7" /><stop offset="1" stopColor="#fff" stopOpacity="0" />
        </radialGradient>
        <linearGradient id={g('sh')} x1="0%" y1="0%" x2="100%" y2="30%">
          <stop offset="0" stopColor="#8B5FD6" stopOpacity="0" /><stop offset="1" stopColor="#7C4CC9" stopOpacity="0.38" />
        </linearGradient>
        <clipPath id={g('cf')}><path d={face} /></clipPath>
      </defs>
      <path d={female ? 'M13.8 62c0-11.9 6.4-18.6 18.2-18.6S50.2 49.4 50.2 62z' : 'M11.2 62c0-12.6 7.5-19.6 20.8-19.6S52.8 48.6 52.8 62z'} fill={`url(#${g('bd')})`} />
      <path d="M28.6 34.8h6.8v5.1c0 1.9-1.4 3-3.4 3s-3.4-1.1-3.4-3z" fill={`url(#${g('sk')})`} />
      <path d="M28.6 38.8c2.1 1.7 4.7 1.7 6.8 0v1.1c0 1.9-1.4 3-3.4 3s-3.4-1.1-3.4-3z" fill="#7A54C4" opacity="0.32" />
      {female && <path d="M32 11.8c-8.8 0-13.9 5.7-13.9 13.9 0 4.5-.9 8.2-2.2 11.6-1 2.6-1.5 4.7-1.5 6.4 3.7-.3 6.4-1.7 7.8-3.9.9-1.5 1.4-3.3 1.4-5.5V25.4c0-4.1 3.4-7.1 8.4-7.1s8.4 3 8.4 7.1v8.9c0 2.2.5 4 1.4 5.5 1.4 2.2 4.1 3.6 7.8 3.9 0-1.7-.5-3.8-1.5-6.4-1.3-3.4-2.2-7.1-2.2-11.6 0-8.2-5.1-13.9-13.9-13.9z" fill={`url(#${g('hr')})`} />}
      <path d={face} fill={`url(#${g('sk')})`} />
      <g clipPath={`url(#${g('cf')})`}>
        <ellipse cx="26" cy="21" rx="8" ry="8.5" fill={`url(#${g('hl')})`} />
        <ellipse cx="42" cy="28" rx="11" ry="14" fill={`url(#${g('sh')})`} />
      </g>
      {female && <path d="M22.3 24.6c.6-7 4.4-10.9 9.7-10.9 4.7 0 8.2 3 9.4 8.2-2.6-2.4-5.5-3.3-8.7-2.8-4 .6-7.5 2.3-10.4 5.5z" fill={`url(#${g('hr')})`} />}
      {male && <path d="M21.6 24.6c-.5-7.6 4.2-12.2 10.4-12.2s10.9 4.6 10.4 12.2c-.6-2-1.4-3.6-2.3-4.7-2.6 1.4-5.4 2.1-8.5 2.1-2.9 0-5.2-.4-6.9-1.3-1.2 1-2.1 2.3-3.1 3.9z" fill={`url(#${g('hr')})`} />}
      {!female && !male && <path d="M22 24.4c-.4-7.2 4.1-11.6 10-11.6s10.4 4.4 10 11.6c-1.9-4.2-5.2-6.2-10-6.2s-8.1 2-10 6.2z" fill={`url(#${g('hr')})`} />}
      <path d="M23.5 19.4c2-3.5 4.8-5.3 8.5-5.3.9 0 1.8.1 2.6.3-4.2.7-7.9 2.4-11.1 5z" fill="#fff" opacity="0.28" />
    </svg>
  );
}

function MRAvatar({ size = 76, ring = true, gender = MR_ME.gender }) {
  return (
    <div style={{ width: size, height: size, borderRadius: '50%', flexShrink: 0, overflow: 'hidden', background: 'linear-gradient(150deg,#8b52ff 0%,#7731FE 45%,#4E24A0 100%)', display: 'grid', placeItems: 'end center', boxShadow: ring ? '0 0 0 2px rgba(181,255,96,0.5), 0 10px 26px rgba(119,49,254,0.38)' : 'none' }}>
      <MRGenderFigure size={size * 0.94} gender={gender} />
    </div>
  );
}

// 성별 기호 — ♀ / ♂ (배지 속)
function MRGenderGlyph({ size = 12, female }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="#101013" strokeWidth="2.6" strokeLinecap="round" style={{ display: 'block' }}>
      {female
        ? <><circle cx="12" cy="9" r="5.4" /><path d="M12 14.4V21M8.8 18h6.4" /></>
        : <><circle cx="10" cy="14" r="5.4" /><path d="M14.2 9.8 20 4M15.4 4H20v4.6" /></>}
    </svg>
  );
}

// ---------- 푸시 화면 공통 헤더 ----------
function MRPushHead({ title, onBack, right, bare }) {
  return (
    <div style={{ position: 'relative', zIndex: 20, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '54px 16px 14px', ...(bare ? {} : { background: VR.barFill, ...VR_BLUR(18), borderBottom: '1px solid rgba(255,255,255,0.08)' }) }}>
      <button onClick={onBack} style={{ all: 'unset', cursor: 'pointer', width: 34, height: 34, borderRadius: '50%', background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', display: 'grid', placeItems: 'center' }}>
        <VRChev dir="left" size={16} c="#fff" w="2.4" />
      </button>
      <span style={{ ...TYPO.button1, fontWeight: 700, color: VR.t1 }}>{title}</span>
      <span style={{ width: 34, display: 'flex', justifyContent: 'flex-end' }}>{right}</span>
    </div>
  );
}

function MRScreen({ children }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 50, overflow: 'hidden', background: VR.ink, display: 'flex', flexDirection: 'column', animation: 'mrPush .28s cubic-bezier(.2,.8,.2,1)' }}>
      <VAurora variant="club" grain={true} />
      <div style={{ position: 'relative', zIndex: 1, flex: 1, minHeight: 0, display: 'flex', flexDirection: 'column' }}>{children}</div>
    </div>
  );
}

// ---------- GlassCard (리뷰 작성 페이지 규격) ----------
function MRCard({ children, pad = 18, radius = 20, style }) {
  return (
    <div style={{ position: 'relative', borderRadius: radius, padding: pad, overflow: 'hidden', flexShrink: 0, background: 'rgba(120,120,128,0.16)', ...VR_BLUR(18), border: '1px solid rgba(255,255,255,0.10)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.16), 0 10px 30px rgba(0,0,0,0.36)', ...style }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(110% 80% at 12% 0%, rgba(255,255,255,0.10), transparent 58%)', pointerEvents: 'none' }} />
      <div style={{ position: 'relative' }}>{children}</div>
    </div>
  );
}

// ---------- 내 리뷰 관리 ----------
function MRStars({ rating, size = 12, showNum = true }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3 }}>
      {[1, 2, 3, 4, 5].map(i => {
        const fill = rating >= i ? 1 : rating >= i - 0.5 ? 0.5 : 0;
        return (
          <span key={i} style={{ position: 'relative', width: size, height: size, display: 'block' }}>
            <svg width={size} height={size} viewBox="0 0 24 24" fill="rgba(255,255,255,0.14)" style={{ position: 'absolute', inset: 0 }}><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>
            {fill > 0 && (
              <span style={{ position: 'absolute', inset: 0, width: `${fill * 100}%`, overflow: 'hidden' }}>
                <svg width={size} height={size} viewBox="0 0 24 24" fill={LIME[500]}><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>
              </span>
            )}
          </span>
        );
      })}
      {showNum && <span style={{ ...TYPO.caption, lineHeight: '13px', fontWeight: 700, color: VR.t1, marginLeft: 3 }}>{rating.toFixed(1)}</span>}
    </span>
  );
}

// VybeMetaDot
function MRDot() {
  return <span style={{ width: 3, height: 3, borderRadius: 99, background: GRAY[600], flexShrink: 0 }} />;
}

// sticky 정렬·필터 바 (ClubGlass.barFill · 스크롤 밖 고정 행)
function MRChip({ on, children, onClick }) {
  return (
    <button onClick={onClick} style={{ all: 'unset', cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: 5, padding: '9px 14px', borderRadius: 999, ...TYPO.button2, fontWeight: 600, color: on ? VR.ink : 'rgba(255,255,255,0.72)', background: on ? LIME[500] : 'rgba(255,255,255,0.07)', border: `1px solid ${on ? LIME[500] : 'rgba(255,255,255,0.12)'}`, boxShadow: on ? '0 6px 18px rgba(181,255,96,0.22)' : 'inset 0 1px 0 rgba(255,255,255,0.12)', transition: 'all .16s ease' }}>{children}</button>
  );
}

function MRReviewBar({ sort, onSort, photoOnly, onPhotoOnly }) {
  const opts = [{ k: 'new', l: '최신순' }, { k: 'rating', l: '별점순' }, { k: 'likes', l: '좋아요순' }];
  return (
    <div style={{ flexShrink: 0, display: 'flex', alignItems: 'center', gap: 8, padding: '18px 16px 0' }}>
      {opts.map(o => <MRChip key={o.k} on={sort === o.k} onClick={() => onSort(o.k)}>{o.l}</MRChip>)}
      <MRChip on={photoOnly} onClick={() => onPhotoOnly(!photoOnly)}>
        <VRIcon d={MRPATH.camera} size={13} c={photoOnly ? VR.ink : 'rgba(255,255,255,0.72)'} w="1.9" /> 사진
      </MRChip>
    </div>
  );
}

function MRReviewCard({ r, onEdit, onDelete }) {
  const [more, setMore] = vrState(false);
  const long = r.text.length > 62;
  return (
    <MRCard>
      <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: SP.md }}>
        <div style={{ minWidth: 0 }}>
          <div style={{ ...TYPO.button1, fontWeight: 700, color: VR.t1, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', minWidth: 0 }}>{r.club}</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 6 }}>
            <MRStars rating={r.rating} />
            <MRDot />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{r.area}</span>
            <MRDot />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{r.date}</span>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 6, flexShrink: 0 }}>
          <button onClick={() => onEdit(r)} title="수정" style={{ all: 'unset', cursor: 'pointer', width: 32, height: 32, borderRadius: 99, display: 'grid', placeItems: 'center', background: VR.tileFill, border: `1px solid ${VR.tileBorder}` }}>
            <VRIcon d={MRPATH.pencil} size={14} c={VR.t2} w="1.9" />
          </button>
          <button onClick={() => onDelete(r)} title="삭제" style={{ all: 'unset', cursor: 'pointer', width: 32, height: 32, borderRadius: 99, display: 'grid', placeItems: 'center', background: 'rgba(255,92,95,0.10)', border: '1px solid rgba(255,92,95,0.26)' }}>
            <VRIcon d={MRPATH.trash} size={14} c={RED[500]} w="1.9" />
          </button>
        </div>
      </div>

      <p style={{ ...TYPO.body4, lineHeight: '21px', color: VR.t2, margin: `${SP.md}px 0 0`, textWrap: 'pretty', display: more ? 'block' : '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>{r.text}</p>
      {long && (
        <button onClick={() => setMore(m => !m)} style={{ all: 'unset', cursor: 'pointer', marginTop: 6, ...TYPO.caption, lineHeight: '14px', fontWeight: 600, color: VR.lavender }}>{more ? '접기' : '더보기'}</button>
      )}

      {r.photos.length > 0 && (
        <div style={{ display: 'flex', gap: SP.sm, marginTop: SP.md }}>
          {r.photos.map((bg, i) => (
            <div key={i} style={{ width: 72, height: 72, borderRadius: 12, background: bg, border: `1px solid ${VR.quietBorder}` }} />
          ))}
        </div>
      )}

      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: SP.md, paddingTop: SP.md, borderTop: `1px solid ${VR.hair}` }}>
        <VRIcon d={MRPATH.heart} size={13} c={VR.t4} w="1.9" />
        <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t3 }}>좋아요 {r.likes}</span>
        <MRDot />
        <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.lavender }}>공개</span>
      </div>
    </MRCard>
  );
}

function MRConfirm({ review, onCancel, onConfirm }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 70, display: 'grid', placeItems: 'center', padding: `0 ${PAGE_H}px` }}>
      <div onClick={onCancel} style={{ position: 'absolute', inset: 0, background: 'rgba(14,13,18,0.66)', ...VR_BLUR(6), animation: 'mrFade .2s ease' }} />
      <VGlass radius={19} pad={SP.xxl} style={{ position: 'relative', width: '100%', maxWidth: 301, animation: 'mrDialog .22s cubic-bezier(.2,.9,.3,1)' }}>
        <div style={{ ...TYPO.h4, color: VR.t1, textAlign: 'center' }}>리뷰를 삭제할까요?</div>
        <div style={{ ...TYPO.body4, lineHeight: '20px', color: VR.t3, textAlign: 'center', marginTop: SP.md }}>{review.club} 리뷰가 삭제되며<br />되돌릴 수 없어요.</div>
        <div style={{ display: 'flex', gap: SP.md, marginTop: SP.xxl }}>
          <VButton label="취소" variant="quiet" onClick={onCancel} style={{ flex: 1, height: 48 }} />
          <button onClick={onConfirm} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', flex: 1, height: 48, borderRadius: 12, display: 'grid', placeItems: 'center', background: RED[500], fontWeight: 500, fontSize: 18, lineHeight: 1, letterSpacing: '-0.025em', color: '#fff' }}>삭제</button>
        </div>
      </VGlass>
    </div>
  );
}

function MRReviewsScreen({ onBack, reviews, onDelete, toast }) {
  const [confirm, setConfirm] = vrState(null);
  const [sort, setSort] = vrState('new');
  const [photoOnly, setPhotoOnly] = vrState(false);

  const list = React.useMemo(() => {
    let l = photoOnly ? reviews.filter(r => r.photos.length > 0) : reviews.slice();
    if (sort === 'rating') l.sort((a, b) => b.rating - a.rating);
    else if (sort === 'likes') l.sort((a, b) => b.likes - a.likes);
    return l;
  }, [reviews, sort, photoOnly]);

  return (
    <MRScreen>
      <MRPushHead title="내 리뷰" onBack={onBack} right={<span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{reviews.length}개</span>} />
      {reviews.length > 0 && <MRReviewBar sort={sort} onSort={setSort} photoOnly={photoOnly} onPhotoOnly={setPhotoOnly} />}
      <div style={{ position: 'relative', zIndex: 1, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: '14px 16px 24px', display: 'flex', flexDirection: 'column', gap: 14 }}>
        {reviews.length === 0 ? (
          <div style={{ padding: '90px 20px', textAlign: 'center' }}>
            <div style={{ width: 60, height: 60, borderRadius: 19, background: 'rgba(119,49,254,0.20)', border: '1px solid rgba(119,49,254,0.42)', display: 'grid', placeItems: 'center', margin: '0 auto 16px' }}><VRIcon d={MRPATH.review} size={25} c={VR.lavender} /></div>
            <div style={{ ...TYPO.body3, fontWeight: 600, color: VR.t1, marginBottom: 7 }}>작성한 리뷰가 없어요</div>
            <div style={{ ...TYPO.body4, color: VR.t4, lineHeight: '20px', marginBottom: SP.xl }}>다녀온 클럽의 후기를 남겨보세요</div>
            <VButton label="리뷰 쓰기" href="%5Bv1%5DCLUB-028.html" style={{ maxWidth: 190, margin: '0 auto', height: 48 }} />
          </div>
        ) : (
          <React.Fragment>
            {list.length === 0 ? (
              <div style={{ padding: '54px 20px', textAlign: 'center' }}>
                <div style={{ ...TYPO.body4, color: VR.t4, lineHeight: '20px' }}>사진이 있는 리뷰가 없어요</div>
              </div>
            ) : list.map(r => (
              <MRReviewCard key={r.id} r={r} onEdit={() => toast('리뷰 수정은 준비 중이에요')} onDelete={setConfirm} />
            ))}
            <VFooterNote>리뷰는 클럽 상세 페이지에 공개되며, 운영 정책에 어긋나면 안내 후 삭제될 수 있어요.</VFooterNote>
          </React.Fragment>
        )}
      </div>
      {confirm && <MRConfirm review={confirm} onCancel={() => setConfirm(null)} onConfirm={() => { onDelete(confirm.id); setConfirm(null); toast('리뷰를 삭제했어요'); }} />}
    </MRScreen>
  );
}

// ---------- 내 정보 수정 ----------
function MRField({ label, value, onChange, placeholder, multiline }) {
  const st = { width: '100%', boxSizing: 'border-box', padding: multiline ? '13px 14px' : '0 14px', height: multiline ? 'auto' : 50, borderRadius: 12, background: 'rgba(255,255,255,0.06)', ...VR_BLUR(10), border: `1px solid ${VR.tileBorder}`, color: VR.t1, ...TYPO.body3, lineHeight: multiline ? '21px' : undefined, outline: 'none', resize: 'none' };
  return (
    <label style={{ display: 'block', marginBottom: SP.lg }}>
      <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: VR.t4, display: 'block', marginBottom: SP.sm }}>{label}</span>
      {multiline
        ? <textarea value={value} onChange={e => onChange(e.target.value)} rows={2} placeholder={placeholder} style={st} />
        : <input value={value} onChange={e => onChange(e.target.value)} placeholder={placeholder} style={st} />}
    </label>
  );
}

function MREditScreen({ onBack, onSave }) {
  const [name, setName] = vrState(MR_ME.name);
  const [handle, setHandle] = vrState(MR_ME.handle);
  const [bio, setBio] = vrState(MR_ME.bio);
  const [gender, setGender] = vrState(MR_ME.gender);
  const [birth, setBirth] = vrState(MR_ME.birth);
  const [region, setRegion] = vrState(MR_ME.region);
  return (
    <MRScreen>
      <MRPushHead title="내 정보 수정" onBack={onBack} />
      <div style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: `${SP.xxl}px ${PAGE_H}px ${SP.xxl}px` }}>
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: SP.xxl }}>
          <div style={{ position: 'relative' }}>
            <MRAvatar size={92} ring={false} gender={gender} />
            <div style={{ position: 'absolute', right: -2, bottom: -2, width: 32, height: 32, borderRadius: '50%', background: PURPLE[500], border: `3px solid ${VR.ink}`, display: 'grid', placeItems: 'center' }}><VRIcon d={MRPATH.camera} size={14} c="#fff" w="2" /></div>
          </div>
        </div>
        <MRField label="닉네임" value={name} onChange={setName} placeholder="닉네임" />
        <MRField label="아이디" value={handle} onChange={setHandle} placeholder="아이디" />
        <MRField label="한 줄 소개" value={bio} onChange={setBio} placeholder="나를 소개해 주세요" multiline />
        <div style={{ marginBottom: SP.lg }}>
          <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: VR.t4, display: 'block', marginBottom: SP.sm }}>성별</span>
          <div style={{ display: 'flex', gap: SP.sm }}>
            {['여성', '남성', '비공개'].map(g => {
              const sel = gender === g;
              return <button key={g} onClick={() => setGender(g)} style={{ all: 'unset', cursor: 'pointer', flex: 1, textAlign: 'center', height: 46, lineHeight: '46px', borderRadius: 12, background: sel ? 'rgba(119,49,254,0.22)' : 'rgba(255,255,255,0.06)', border: `1px solid ${sel ? PURPLE[500] : VR.tileBorder}`, ...TYPO.button1, fontWeight: sel ? 700 : 500, color: sel ? VR.t1 : VR.t3, transition: 'background .15s, border-color .15s' }}>{g}</button>;
            })}
          </div>
        </div>
        <div style={{ display: 'flex', gap: SP.md }}>
          <div style={{ flex: 1 }}><MRField label="출생연도" value={birth} onChange={setBirth} placeholder="1997" /></div>
          <div style={{ flex: 1 }}><MRField label="활동 지역" value={region} onChange={setRegion} placeholder="서울 마포" /></div>
        </div>
      </div>
      <div style={{ flexShrink: 0, padding: `${SP.md}px ${PAGE_H}px 30px`, }}>
        <VButton label="저장하기" onClick={onSave} style={{ width: '100%' }} />
      </div>
    </MRScreen>
  );
}

// ---------- 설정 ----------
function MRToggle({ on, onClick }) {
  return (
    <button onClick={onClick} style={{ all: 'unset', cursor: 'pointer', width: 46, height: 28, borderRadius: 99, flexShrink: 0, background: on ? PURPLE[500] : 'rgba(255,255,255,0.14)', border: `1px solid ${on ? 'rgba(181,255,96,0.001)' : 'rgba(255,255,255,0.12)'}`, boxShadow: on ? '0 4px 16px rgba(119,49,254,0.45), inset 0 1px 0 rgba(255,255,255,0.24)' : 'inset 0 1px 0 rgba(255,255,255,0.10)', position: 'relative', transition: 'background .18s ease, box-shadow .18s ease' }}>
      <span style={{ position: 'absolute', top: 3, left: on ? 21 : 3, width: 22, height: 22, borderRadius: '50%', background: '#fff', transition: 'left .18s cubic-bezier(.2,.9,.3,1)', boxShadow: '0 2px 6px rgba(0,0,0,0.4)' }} />
    </button>
  );
}

// 그룹 헤드 — 카드 밖 라벨 (라임 인디케이터)
function MRSetHead({ title, sub }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '0 4px', marginBottom: 10 }}>
      <span style={{ ...TYPO.button2, fontWeight: 700, color: VR.t1 }}>{title}</span>
      {sub && <span style={{ ...TYPO.caption, lineHeight: '14px', color: VR.t4 }}>{sub}</span>}
    </div>
  );
}

function MRSetRow({ label, sub, control, last, icon, onClick }) {
  return (
    <div onClick={onClick} style={{ display: 'flex', alignItems: 'center', gap: SP.md, minHeight: 46, padding: '11px 0', borderBottom: last ? 'none' : `1px solid ${VR.hair}`, cursor: onClick ? 'pointer' : 'default' }}>
      {icon && (
        <span style={{ width: 30, height: 30, borderRadius: 10, flexShrink: 0, display: 'grid', placeItems: 'center', background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.12)' }}>
          <VRIcon d={icon} size={15} c={VR.t2} w="1.9" />
        </span>
      )}
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ ...TYPO.body4, color: VR.t1 }}>{label}</div>
        {sub && <div style={{ ...TYPO.caption, lineHeight: '15px', color: VR.t4, marginTop: 3, textWrap: 'pretty' }}>{sub}</div>}
      </div>
      {control}
    </div>
  );
}

// 읽기 전용 값 (꺾쇠 없음) — 가입 정보처럼 바꿀 수 없는 항목
function MRSetStatic({ children }) {
  return <span style={{ flexShrink: 0, ...TYPO.body4, color: VR.t2 }}>{children}</span>;
}

function MRSetValue({ children }) {
  return <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, flexShrink: 0, ...TYPO.caption, lineHeight: '14px', color: VR.t3 }}>{children}<VRChev dir="right" size={12} c={VR.t4} w="2" /></span>;
}

// ---------- 내 정보 확인 (가입 정보) ----------
function MRMyInfoScreen({ onBack }) {
  const rows = [
    { k: '이름', v: MR_ME.name },
    { k: '휴대폰 번호', v: MR_ME.phone },
    { k: '생년월일', v: MR_ME.birthDate },
    { k: '성별', v: MR_ME.gender },
    { k: '로그인 방식', v: MR_PROVIDER_LABEL[MR_ME.provider] || '-' },
    { k: '가입일', v: MR_ME.joinedAt },
  ];
  return (
    <MRScreen>
      <MRPushHead title="내 정보" onBack={onBack} />
      <div style={{ flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: '18px 16px 24px', display: 'flex', flexDirection: 'column', gap: 26 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: SP.lg }}>
          <MRAvatar size={64} gender={MR_ME.gender} />
          <div style={{ minWidth: 0 }}>
            <div style={{ ...TYPO.h4, fontSize: 20, color: VR.t1 }}>{MR_ME.name}</div>
            <div style={{ ...TYPO.body4, color: VR.t4, marginTop: 4 }}>{MR_PROVIDER_LABEL[MR_ME.provider] || ''}</div>
          </div>
        </div>
        <div>
          <MRSetHead title="가입 정보" sub="본인인증 정보라 앱에서 바꿀 수 없어요" />
          <div>
            {rows.map((r, i) => (
              <MRSetRow key={r.k} label={r.k} last={i === rows.length - 1} control={<MRSetStatic>{r.v}</MRSetStatic>} />
            ))}
          </div>
        </div>
        <VFooterNote>이름·생년월일·휴대폰 번호는 본인인증으로 받은 값이에요. 변경이 필요하면 고객센터로 문의해 주세요.</VFooterNote>
      </div>
    </MRScreen>
  );
}

function MRSettingsScreen({ onBack, toast, onLeave }) {
  const [s, setS] = vrState({ push: true, showtime: true, saved: true, review: false, marketing: false, location: true, sound: true });
  const [info, setInfo] = vrState(false);
  const t = (k) => setS(v => ({ ...v, [k]: !v[k] }));
  const anyPush = s.push;

  return (
    <MRScreen>
      <MRPushHead title="설정" onBack={onBack} />
      <div style={{ position: 'relative', zIndex: 1, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: '18px 16px 24px', display: 'flex', flexDirection: 'column', gap: 26 }}>

        <div>
          <MRSetHead title="내 정보" />
          <div>
            <MRSetRow icon={MRPATH.user} label="내 정보 확인하기" sub="이름 · 휴대폰 번호 · 로그인 방식 등 가입 정보" last control={<MRSetValue />} onClick={() => setInfo(true)} />
          </div>
        </div>

        <div>
          <MRSetHead title="알림" sub={anyPush ? '' : '전체 꺼짐'} />
          <div>
            <MRSetRow icon={MRPATH.bell} label="푸시 알림" sub="전체 알림 받기" control={<MRToggle on={s.push} onClick={() => t('push')} />} />
            <div style={{ opacity: anyPush ? 1 : 0.4, pointerEvents: anyPush ? 'auto' : 'none', transition: 'opacity .2s ease' }}>
              <MRSetRow label="공연 시작 알림" sub="찜한 클럽의 오늘 라인업 시작 전" control={<MRToggle on={s.showtime} onClick={() => t('showtime')} />} />
              <MRSetRow label="찜한 클럽 소식" sub="이벤트 · 입장 혜택 업데이트" control={<MRToggle on={s.saved} onClick={() => t('saved')} />} />
              <MRSetRow label="리뷰 반응 알림" sub="내 리뷰에 좋아요·댓글이 달릴 때" control={<MRToggle on={s.review} onClick={() => t('review')} />} />
              <MRSetRow label="마케팅 · 홍보 알림" sub="혜택·이벤트 정보 수신" last control={<MRToggle on={s.marketing} onClick={() => t('marketing')} />} />
            </div>
          </div>
        </div>

        <div>
          <MRSetHead title="일반" />
          <div>
            <MRSetRow icon={MRPATH.pin} label="위치 서비스" sub="내 주변 클럽 추천에 사용" control={<MRToggle on={s.location} onClick={() => t('location')} />} />
            <MRSetRow icon={MRPATH.mega} label="사운드 및 진동" sub="앱 효과음" control={<MRToggle on={s.sound} onClick={() => t('sound')} />} />
            <MRSetRow icon={MRPATH.moon} label="테마" control={<MRSetValue>다크</MRSetValue>} />
            <MRSetRow icon={MRPATH.globe} label="언어" last control={<MRSetValue>한국어</MRSetValue>} />
          </div>
        </div>

        <div>
          <MRSetHead title="데이터" />
          <div>
            <MRSetRow icon={MRPATH.trash} label="캐시 삭제" sub="48.2MB 사용 중" last control={
              <MRChip onClick={() => toast('캐시를 삭제했어요')}>삭제</MRChip>
            } />
          </div>
        </div>

        <div>
          <MRSetHead title="계정" />
          <div>
            <MRSetRow icon={MRPATH.review} label="고객센터 · 문의" control={<MRSetValue /> } />
            <MRSetRow icon={MRPATH.user} label="약관 및 개인정보 처리방침" control={<MRSetValue />} />
            <MRSetRow icon={MRPATH.logout} label="로그아웃" last control={<MRSetValue />} />
          </div>
        </div>

        <VFooterNote>계정 삭제나 데이터 이관은 고객센터를 통해 처리돼요.</VFooterNote>

        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: SP.sm, marginTop: SP.sm }}>
          <button onClick={onLeave} style={{ all: 'unset', cursor: 'pointer', ...TYPO.caption, lineHeight: '14px', color: VR.t4, textDecoration: 'underline', textUnderlineOffset: 3, padding: '6px 10px' }}>탈퇴하기</button>
          <span style={{ ...TYPO.caption, lineHeight: '16px', color: GRAY[700] }}>vybe · 버전 v2.4.1</span>
        </div>
      </div>
      {info && <MRMyInfoScreen onBack={() => setInfo(false)} />}
    </MRScreen>
  );
}

Object.assign(window, { MRPATH, MR_ME, MR_PROVIDER_LABEL, MR_REVIEWS, MRSetStatic, MRMyInfoScreen, MRGenderGlyph, MRAvatar, MRGenderFigure, MRPushHead, MRScreen, MRStars, MRDot, MRChip, MRCard, MRSetHead, MRSetRow, MRReviewsScreen, MREditScreen, MRSettingsScreen, MRToggle });
