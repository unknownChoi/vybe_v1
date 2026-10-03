/* global React, TYPO, GRAY, LIME, PURPLE, RED, window, VAurora, VR, SP, PAGE_H, VR_BLUR, VRPATH, VRIcon, VRChev, vrState */
// ============ VYBE — 고객센터(문의/신고) · 공통 파트 ============
// 값은 전부 uploads/design_system.html 규격. 393pt 기준 1sp = 1px.

const SPATH = {
  pen: '<path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/>',
  camera: '<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="3.6"/>',
  image: '<rect x="3" y="3" width="18" height="18" rx="2.5"/><circle cx="8.8" cy="9.2" r="1.6"/><path d="M21 15.5 16.5 11 6 21"/>',
  x: '<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>',
  alert: '<path d="M10.3 3.6 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.6a2 2 0 0 0-3.4 0z"/><line x1="12" y1="9.2" x2="12" y2="13.6"/><circle cx="12" cy="17" r="1"/>',
  headset: '<path d="M4 14v-2.2a8 8 0 0 1 16 0V14"/><path d="M4 13.6h2.4A1.6 1.6 0 0 1 8 15.2v3.2a1.6 1.6 0 0 1-1.6 1.6H6a2 2 0 0 1-2-2z"/><path d="M20 13.6h-2.4a1.6 1.6 0 0 0-1.6 1.6v3.2a1.6 1.6 0 0 0 1.6 1.6h.4a2 2 0 0 0 2-2z"/>',
  clock: '<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>',
  info: '<circle cx="12" cy="12" r="10"/><line x1="12" y1="11" x2="12" y2="16.5"/><circle cx="12" cy="7.8" r="1"/>',
  lock: '<rect x="4" y="10.5" width="16" height="11" rx="2.4"/><path d="M8 10.5V7.6a4 4 0 0 1 8 0v2.9"/>',
};

// ---------- 문의 유형 (4종) ----------
const SUP_TYPES = [
  { k: 'use', label: '이용 문의', tone: 'blue' },
  { k: 'bug', label: '오류 신고', tone: 'red' },
  { k: 'report', label: '신고/제보', tone: 'lav' },
  { k: 'etc', label: '계정/회원정보/기타', tone: 'gray' },
];
const SUP_TYPE = Object.fromEntries(SUP_TYPES.map(t => [t.k, t]));
const SUP_TONE = {
  blue: { bg: 'rgba(43,107,255,0.18)', bd: 'rgba(43,107,255,0.42)', fg: VR.link },
  red: { bg: 'rgba(255,92,95,0.13)', bd: 'rgba(255,92,95,0.28)', fg: RED[500] },
  lav: { bg: 'rgba(200,168,255,0.15)', bd: 'rgba(200,168,255,0.32)', fg: VR.lavender },
  gray: { bg: 'rgba(255,255,255,0.08)', bd: 'rgba(255,255,255,0.14)', fg: GRAY[400] },
};

function SupTypeTag({ k, size = 11 }) {
  const t = SUP_TYPE[k], c = SUP_TONE[t.tone];
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', padding: '3px 8px', borderRadius: 6, background: c.bg, border: `1px solid ${c.bd}`, color: c.fg, fontWeight: 600, fontSize: size, lineHeight: `${size + 4}px`, letterSpacing: '-0.025em', flexShrink: 0 }}>{t.label}</span>
  );
}

// 답변 상태 뱃지 — 대기(중립) / 완료(라임)
function SupStatusBadge({ done, size = 11 }) {
  const fg = done ? LIME[500] : GRAY[400];
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 10px', borderRadius: 99, background: done ? 'rgba(181,255,96,0.14)' : 'rgba(255,255,255,0.07)', border: `1px solid ${done ? 'rgba(181,255,96,0.30)' : 'rgba(255,255,255,0.14)'}`, color: fg, fontWeight: 600, fontSize: size, lineHeight: 1, letterSpacing: '-0.025em', flexShrink: 0 }}>
      <span style={{ width: 5, height: 5, borderRadius: 99, background: done ? 'currentColor' : 'transparent', border: done ? 'none' : `1.4px solid ${fg}`, boxSizing: 'border-box' }} />
      {done ? '답변 완료' : '답변 대기'}
    </span>
  );
}

// ---------- 푸시 화면 공통 헤더 ----------
function SupHead({ title, onBack, backHref, right }) {
  const back = <VRChev dir="left" size={16} c="#fff" w="2.4" />;
  const btn = { all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: 34, height: 34, borderRadius: '50%', background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', display: 'grid', placeItems: 'center', flexShrink: 0 };
  return (
    <div style={{ position: 'relative', zIndex: 20, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: SP.md, padding: '54px 16px 14px', background: 'transparent' }}>
      {backHref ? <a href={backHref} style={btn}>{back}</a> : <button onClick={onBack} style={btn}>{back}</button>}
      <span style={{ ...TYPO.button1, fontWeight: 700, color: VR.t1 }}>{title}</span>
      <span style={{ minWidth: 34, display: 'flex', justifyContent: 'flex-end' }}>{right}</span>
    </div>
  );
}

// 푸시 스크린 껍데기 (ClubAurora + 잉크)
function SupScreen({ children, push }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 50, overflow: 'hidden', background: VR.ink, display: 'flex', flexDirection: 'column', animation: push ? 'supPush .28s cubic-bezier(.2,.8,.2,1)' : 'none' }}>
      <VAurora variant="club" grain={true} />
      <div style={{ position: 'relative', zIndex: 1, flex: 1, minHeight: 0, display: 'flex', flexDirection: 'column' }}>{children}</div>
    </div>
  );
}

// 하단 고정 액션 바 (ClubGlass.barFill)
function SupActionBar({ children }) {
  return (
    <div style={{ position: 'relative', zIndex: 10, flexShrink: 0, padding: `${SP.md}px ${PAGE_H}px 30px`, display: 'flex', flexDirection: 'column', gap: 10 }}>{children}</div>
  );
}

// ---------- 첨부 사진 플레이스홀더 ----------
const SUP_STRIPE = 'repeating-linear-gradient(135deg, rgba(255,255,255,0.055) 0 5px, rgba(255,255,255,0) 5px 11px)';

function SupThumb({ size = 72, onRemove, label }) {
  return (
    <div style={{ position: 'relative', width: size, height: size, borderRadius: 12, flexShrink: 0, background: `${SUP_STRIPE}, rgba(255,255,255,0.05)`, border: `1px solid ${VR.tileBorder}`, display: 'grid', placeItems: 'center', overflow: 'hidden' }}>
      <VRIcon d={SPATH.image} size={19} c="rgba(255,255,255,0.34)" w="1.7" />
      {label && <span style={{ position: 'absolute', bottom: 5, left: 0, right: 0, textAlign: 'center', fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace', fontSize: 8.5, letterSpacing: 0, color: 'rgba(255,255,255,0.4)' }}>{label}</span>}
      {onRemove && (
        <button onClick={onRemove} aria-label="첨부 삭제" style={{ all: 'unset', cursor: 'pointer', position: 'absolute', top: 4, right: 4, width: 20, height: 20, borderRadius: 99, background: 'rgba(14,13,18,0.72)', ...VR_BLUR(8), border: '1px solid rgba(255,255,255,0.18)', display: 'grid', placeItems: 'center' }}>
          <VRIcon d={SPATH.x} size={11} c="#fff" w="2.6" />
        </button>
      )}
    </div>
  );
}

// ---------- 안내 / 경고 박스 ----------
// warn: accentRed500 좌측 2px + 6% 틴트 (design_system .warn)
function SupWarnBox({ title, items }) {
  return (
    <div style={{ flexShrink: 0, borderRadius: '0 13px 13px 0', borderLeft: `2px solid ${RED[500]}`, background: 'rgba(255,92,95,0.06)', padding: '13px 15px' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 7, marginBottom: 9 }}>
        <VRIcon d={SPATH.alert} size={14} c={RED[500]} w="1.9" />
        <span style={{ ...TYPO.button2, fontWeight: 700, color: RED[500] }}>{title}</span>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
        {items.map((t, i) => (
          <div key={i} style={{ display: 'flex', gap: 7, alignItems: 'flex-start' }}>
            <span style={{ width: 3, height: 3, borderRadius: 99, background: 'rgba(255,255,255,0.32)', flexShrink: 0, marginTop: 8 }} />
            <span style={{ ...TYPO.caption, lineHeight: '19px', color: VR.t2, textWrap: 'pretty' }}>{t}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

// note: mainLime500 좌측 2px + 5% 틴트 (design_system .note)
function SupNoteBox({ icon = SPATH.lock, children }) {
  return (
    <div style={{ flexShrink: 0, display: 'flex', gap: 9, borderRadius: '0 13px 13px 0', borderLeft: `2px solid ${LIME[500]}`, background: 'rgba(181,255,96,0.05)', padding: '13px 15px' }}>
      <span style={{ flexShrink: 0, marginTop: 2 }}><VRIcon d={icon} size={14} c={LIME[500]} w="1.8" /></span>
      <span style={{ ...TYPO.caption, lineHeight: '19px', color: VR.t2, textWrap: 'pretty' }}>{children}</span>
    </div>
  );
}

// VybeStatusMessage — default / warn / success / error
const SUP_MSG_C = { default: GRAY[500], warn: '#FFD166', success: LIME[500], error: RED[500] };
function SupStatusMsg({ type = 'default', children }) {
  const c = SUP_MSG_C[type];
  const glyph = { default: 'ⓘ', warn: '!', success: '✓', error: '✕' }[type];
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 6, ...TYPO.caption, lineHeight: '16px', color: c }}>
      <span style={{ fontWeight: 700, fontSize: 12 }}>{glyph}</span>{children}
    </div>
  );
}

// ---------- 더미 문의 데이터 ----------
const SUP_ITEMS = [
  {
    id: 'q5', type: 'bug', title: '예약한 테이블이 예약 내역에 표시되지 않아요', date: '2026.09.05', done: false, photos: 2,
    body: '지난 금요일에 OCTAGON 테이블을 예약했는데 예약 내역 화면에 아무것도 표시되지 않습니다. 결제 완료 문자는 받았고, 앱을 다시 설치해도 같은 화면이에요. 캡처 두 장 첨부합니다.',
  },
  {
    id: 'q4', type: 'report', title: '클럽 영업시간 정보가 실제와 달라요', date: '2026.09.02', done: false, photos: 1,
    body: '홍대 펄스 상세 페이지에 22:00-06:00으로 나와 있는데 현장에서는 23시부터 입장을 받았습니다. 입구 안내판 사진 첨부합니다.',
  },
  {
    id: 'q3', type: 'use', title: '찜한 클럽 알림만 따로 끄고 싶어요', date: '2026.08.28', done: true, answeredAt: '2026.08.29', photos: 0,
    body: '푸시 알림은 켜두고 싶은데 찜한 클럽 소식만 오지 않게 하고 싶어요. 알림 종류별로 설정할 수 있는 방법이 있나요?',
    answer: '안녕하세요, vybe 운영팀입니다.\n\n내 정보 → 설정 → 알림 메뉴에서 ‘찜한 클럽 소식’ 항목만 따로 끌 수 있어요. 전체 푸시 알림을 켜둔 상태로 두면 공연 시작 알림은 그대로 받으실 수 있습니다.\n\n설정을 바꾼 뒤에도 알림이 계속 온다면 앱을 완전히 종료하고 다시 실행해 주세요. 다른 문의사항이 있으면 언제든 남겨 주세요.',
  },
  {
    id: 'q2', type: 'etc', title: '휴대폰 번호를 변경하고 싶습니다', date: '2026.08.14', done: true, answeredAt: '2026.08.15', photos: 0,
    body: '번호를 바꿨는데 앱에서는 수정이 안 됩니다. 어떻게 변경할 수 있나요?',
    answer: '안녕하세요, vybe 운영팀입니다.\n\n휴대폰 번호는 본인인증으로 받은 정보라 앱에서 직접 바꿀 수 없어요. 새 번호로 본인인증을 다시 진행해 드릴 수 있으니, 이 문의에 변경할 번호를 남겨 주시면 순서대로 처리해 드리겠습니다.',
  },
  {
    id: 'q1', type: 'use', title: '입장비 무료 클럽은 어떤 기준으로 표시되나요?', date: '2026.07.30', done: true, answeredAt: '2026.07.31', photos: 0,
    body: '입장비 무료 탭에 뜨는 클럽 기준이 궁금합니다. 요일마다 달라지나요?',
    answer: '안녕하세요, vybe 운영팀입니다.\n\n입장비 무료 탭은 해당 날짜에 클럽이 등록한 입장 정책을 그대로 보여줍니다. 요일·이벤트에 따라 매일 갱신되며, 현장 상황에 따라 달라질 수 있어 방문 전 클럽 상세 페이지를 한 번 더 확인해 주시는 게 좋아요.',
  },
];

Object.assign(window, { SPATH, SUP_TYPES, SUP_TYPE, SUP_TONE, SupTypeTag, SupStatusBadge, SupHead, SupScreen, SupActionBar, SupThumb, SUP_STRIPE, SupWarnBox, SupNoteBox, SupStatusMsg, SUP_ITEMS });
