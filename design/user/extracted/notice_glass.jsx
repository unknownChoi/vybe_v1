/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, PURPLE, window, NG, NG_GRAIN, NG_AURORA, NGI, NGCard, ngState */
// ============ VYBE — 공지사항 (Liquid Glass) · 읽기 전용 ============

const NCI = {
  Lock: ({ size = 12, c = 'rgba(255,255,255,0.5)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><rect x="4" y="11" width="16" height="10" rx="2.4" /><path d="M8 11V7a4 4 0 0 1 8 0v4" /></svg>),
  Pin: ({ size = 12, c = LIME[500] }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="17" x2="12" y2="22" /><path d="M9 3h6l-1 6 3 3v2H7v-2l3-3z" /></svg>),
  Chev: ({ size = 13, c = 'rgba(255,255,255,0.5)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6" /></svg>),
  ChevLeft: ({ size = 13, c = 'rgba(255,255,255,0.5)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>),
  Clock: ({ size = 12, c = 'rgba(255,255,255,0.5)' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.1" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="9" /><polyline points="12 7 12 12 15.5 14" /></svg>),
  Badge: ({ size = 15, c = '#fff' }) => (<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 2l2.6 2 3.2-.3 1 3.1 2.6 2-1.4 2.9 1.4 2.9-2.6 2-1 3.1-3.2-.3L12 22l-2.6-2-3.2.3-1-3.1L2.6 15 4 12.1 2.6 9.2l2.6-2 1-3.1L9.4 4z" /><polyline points="9 12 11 14 15 10" /></svg>),
};

const NC_CATS = {
  notice: { label: '공지', hue: 'rgba(255,255,255,0.92)', tint: 'rgba(255,255,255,0.10)', ring: 'rgba(255,255,255,0.22)' },
  update: { label: '업데이트', hue: '#C7A6FF', tint: 'rgba(119,49,254,0.22)', ring: 'rgba(119,49,254,0.45)' },
  event: { label: '이벤트', hue: LIME[500], tint: 'rgba(181,255,96,0.16)', ring: 'rgba(181,255,96,0.38)' },
  maint: { label: '점검', hue: '#FFC94D', tint: 'rgba(255,201,77,0.16)', ring: 'rgba(255,201,77,0.36)' },
};

const NC_LIST = [
  { id: 1, cat: 'notice', pin: true, isNew: true, date: '2026.08.01', title: '입장 확정 절차 변경 안내',
    body: '2026년 8월 5일부터 예약 후 입장 24시간 전까지 앱에서 “입장 확정”을 눌러야 예약이 유지됩니다.\n\n· 미확정 예약은 자동 취소되며 대기 순번으로 전환돼요.\n· 확정 알림은 예약 24시간 전, 3시간 전 두 번 발송됩니다.\n· 현장 입장 시에는 확정된 예약 코드만 인정됩니다.\n\n변경된 정책은 모든 제휴 클럽에 동일하게 적용됩니다.' },
  { id: 2, cat: 'update', isNew: true, date: '2026.07.28', title: 'v2.4 업데이트 — 주변 지도 개편',
    body: '주변 탭이 지도 중심으로 새로워졌어요.\n\n· 지도에서 클러스터를 눌러 지역별 클럽을 한 번에 탐색\n· 도보 시간 배지와 실시간 대기 정보 추가\n· 리퀴드 글래스 디자인 적용으로 야간 가독성 개선\n\n앱스토어에서 최신 버전으로 업데이트해 주세요.' },
  { id: 3, cat: 'event', date: '2026.07.22', title: '여름 나이트 페스타 — 입장권 30% 할인',
    body: '8월 한 달간 강남·홍대·이태원 제휴 클럽 24곳의 게스트 입장권을 30% 할인가로 예약할 수 있어요.\n\n· 기간: 2026.08.01 ~ 08.31\n· 대상: vybe 앱에서 예약한 모든 회원\n· 1인 최대 4매까지 할인 적용\n\n일부 프리미엄 라인업 공연은 할인에서 제외될 수 있습니다.' },
  { id: 4, cat: 'maint', date: '2026.07.15', title: '서버 정기 점검 안내 (07.18 04:00~06:00)',
    body: '보다 안정적인 서비스를 위해 정기 점검을 진행합니다.\n\n· 일시: 2026년 7월 18일(토) 04:00 ~ 06:00 (2시간)\n· 영향: 예약, 리뷰 작성, 알림 수신 일시 중단\n\n점검 시간 동안 이용에 불편을 드려 죄송합니다.' },
  { id: 5, cat: 'notice', date: '2026.07.03', title: '리뷰 운영 정책 안내',
    body: '건전한 리뷰 문화를 위해 아래 기준에 해당하는 리뷰는 사전 통보 없이 삭제될 수 있습니다.\n\n· 방문 사실이 확인되지 않는 리뷰\n· 욕설, 비방, 특정인 식별이 가능한 내용\n· 홍보·광고 목적의 반복 게시\n\n신고된 리뷰는 운영팀 검토 후 48시간 내 처리됩니다.' },
  { id: 6, cat: 'update', date: '2026.06.19', title: 'v2.3 업데이트 — 찜 목록 정렬 기능',
    body: '찜한 클럽을 거리순, 평점순, 최근 저장순으로 정렬할 수 있어요. 지역별 필터도 함께 추가되었습니다.' },
  { id: 7, cat: 'notice', date: '2026.06.02', title: '개인정보 처리방침 개정 안내',
    body: '2026년 6월 16일자로 개인정보 처리방침이 개정됩니다.\n\n· 위치정보 보관 기간 명시 (수집일로부터 6개월)\n· 제휴 클럽에 제공되는 예약 정보 항목 구체화\n\n개정 내용에 동의하지 않으실 경우 설정에서 위치 기반 서비스를 해제할 수 있습니다.' },
];

function NCHeader() {
  return (
    <div style={{ position: 'relative', flexShrink: 0, padding: '52px 16px 18px' }}>
      <a href="%5Bv1%5DMY-029.html" style={{ width: 38, height: 38, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', textDecoration: 'none', ...NG.tile, backdropFilter: 'blur(16px) saturate(180%)', WebkitBackdropFilter: 'blur(16px) saturate(180%)' }}><NGI.Back /></a>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 6, marginTop: 18 }}>
        <span style={{ ...TYPO.h1, color: '#fff', fontWeight: 800, letterSpacing: '-0.02em' }}>공지사항</span>
        <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 9px 4px 7px', borderRadius: 999, background: 'rgba(119,49,254,0.22)', border: '1px solid rgba(119,49,254,0.42)' }}>
            <NCI.Badge size={12} c="#C7A6FF" />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 700, color: '#C7A6FF' }}>vybe 운영팀</span>
          </span>
          <span style={{ ...TYPO.body4, color: NG.t3 }}>이 전하는 소식</span>
        </div>
      </div>
    </div>
  );
}

function NCRow({ n, onOpen, index }) {
  const c = NC_CATS[n.cat];
  return (
    <div style={{ animation: 'fadeIn .3s ease both', animationDelay: `${index * 45}ms` }}>
      <NGCard pad={0} radius={19} quiet={!n.pin} style={{
        boxShadow: n.pin
          ? `inset 0 1px 0 rgba(255,255,255,0.18), 0 10px 30px rgba(0,0,0,0.36), 0 0 0 1px ${c.ring}`
          : 'inset 0 1px 0 rgba(255,255,255,0.08)',
      }}>
        {n.pin && <div aria-hidden style={{ position: 'absolute', inset: 0, background: `linear-gradient(115deg, ${c.tint}, transparent 58%)`, pointerEvents: 'none' }} />}
        <button onClick={onOpen} className="nc-row" style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', display: 'block', width: '100%', padding: 15 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 7, marginBottom: 9 }}>
            {n.pin && (
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '3px 8px 3px 6px', borderRadius: 999, background: 'rgba(181,255,96,0.16)', border: '1px solid rgba(181,255,96,0.38)' }}>
                <NCI.Pin size={10} />
                <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '12px', fontWeight: 800, color: LIME[500] }}>중요</span>
              </span>
            )}
            <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '12px', fontWeight: 700, color: c.hue, padding: '4px 9px', borderRadius: 999, background: c.tint, border: `1px solid ${c.ring}` }}>{c.label}</span>
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '12px', color: NG.t4, marginLeft: 'auto' }}>{n.date}</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'flex-start', gap: 8 }}>
            <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 5 }}>
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 7 }}>
                <span style={{ ...TYPO.body4, fontSize: 14, lineHeight: '21px', fontWeight: n.pin ? 700 : 600, color: n.pin ? '#fff' : NG.t2, flex: 1, textWrap: 'pretty' }}>{n.title}</span>
                {n.isNew && <span style={{ ...TYPO.caption, fontSize: 9.5, lineHeight: '16px', fontWeight: 800, letterSpacing: '0.04em', color: NG.ink, background: LIME[500], padding: '0 6px', borderRadius: 5, flexShrink: 0, marginTop: 2 }}>NEW</span>}
              </div>
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '18px', color: NG.t4, display: '-webkit-box', WebkitLineClamp: 1, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>{n.body.split('\n')[0]}</span>
            </div>
            <span style={{ display: 'flex', paddingTop: 5 }}><NCI.Chev /></span>
          </div>
        </button>
      </NGCard>
    </div>
  );
}

function NCDetail({ n, onBack, prev, next, onNav }) {
  const c = NC_CATS[n.cat];
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 40, background: NG_AURORA, display: 'flex', flexDirection: 'column', animation: 'ncPush .3s cubic-bezier(.2,.8,.2,1)' }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, opacity: 0.05, backgroundImage: NG_GRAIN, mixBlendMode: 'overlay', pointerEvents: 'none' }} />
      <div style={{ position: 'relative', zIndex: 2, flexShrink: 0, padding: '52px 16px 12px', display: 'flex', alignItems: 'center', gap: 11, ...NG.bar, borderBottom: `1px solid ${NG.hair}` }}>
        <button onClick={onBack} style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: 38, height: 38, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', ...NG.tile }}><NGI.Back /></button>
        <span style={{ ...TYPO.body3, fontWeight: 700, color: NG.t2 }}>공지사항</span>
      </div>

      <div style={{ position: 'relative', zIndex: 2, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: '22px 20px 30px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 7, marginBottom: 13 }}>
          {n.pin && (
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, padding: '4px 9px 4px 7px', borderRadius: 999, background: 'rgba(181,255,96,0.16)', border: '1px solid rgba(181,255,96,0.38)' }}>
              <NCI.Pin size={11} />
              <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '13px', fontWeight: 800, color: LIME[500] }}>중요</span>
            </span>
          )}
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 700, color: c.hue, padding: '4px 10px', borderRadius: 999, background: c.tint, border: `1px solid ${c.ring}` }}>{c.label}</span>
          {n.isNew && <span style={{ ...TYPO.caption, fontSize: 10, lineHeight: '17px', fontWeight: 800, letterSpacing: '0.04em', color: NG.ink, background: LIME[500], padding: '0 7px', borderRadius: 5 }}>NEW</span>}
        </div>

        <h1 style={{ ...TYPO.h2, fontSize: 24, lineHeight: '35px', fontWeight: 800, color: '#fff', margin: '0 0 14px', letterSpacing: '-0.02em', textWrap: 'pretty' }}>{n.title}</h1>

        <div style={{ display: 'flex', alignItems: 'center', gap: 9, paddingBottom: 18, borderBottom: `1px solid ${NG.hair}` }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '5px 10px 5px 8px', borderRadius: 999, background: 'rgba(119,49,254,0.22)', border: '1px solid rgba(119,49,254,0.42)' }}>
            <NCI.Badge size={12} c="#C7A6FF" />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 700, color: '#C7A6FF' }}>vybe 운영팀</span>
          </span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5 }}>
            <NCI.Clock />
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', color: NG.t4 }}>{n.date}</span>
          </span>
        </div>

        <p style={{ ...TYPO.body4, fontSize: 14, lineHeight: '27px', color: NG.t2, margin: '20px 0 0', whiteSpace: 'pre-line', textWrap: 'pretty' }}>{n.body}</p>

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6, padding: '30px 0 20px' }}>
          <NCI.Lock />
          <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: NG.t4 }}>공지사항은 vybe 운영팀만 등록할 수 있어요</span>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          {[{ item: prev, dir: '이전 글' }, { item: next, dir: '다음 글' }].map(({ item, dir }) => item ? (
            <button key={dir} onClick={() => onNav(item.id)} className="nc-row" style={{ all: 'unset', boxSizing: 'border-box', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 11, width: '100%', padding: '13px 15px', borderRadius: 15, ...NG.glassQuiet }}>
              <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '13px', fontWeight: 700, color: NG.t4, flexShrink: 0, width: 40 }}>{dir}</span>
              <span style={{ flex: 1, minWidth: 0, ...TYPO.caption, fontSize: 12, lineHeight: '18px', color: NG.t2, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{item.title}</span>
              <NCI.Chev size={12} />
            </button>
          ) : null)}
        </div>
      </div>
    </div>
  );
}

function NCFooter() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6, padding: '22px 20px 6px' }}>
      <NCI.Lock />
      <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '16px', color: NG.t4, textAlign: 'center' }}>공지사항은 vybe 운영팀만 등록할 수 있어요</span>
    </div>
  );
}

function NoticeGlassApp() {
  const [sel, setSel] = ngState(null);
  const idx = NC_LIST.findIndex(n => n.id === sel);
  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: NG_AURORA, display: 'flex', flexDirection: 'column', fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, opacity: 0.05, backgroundImage: NG_GRAIN, mixBlendMode: 'overlay', pointerEvents: 'none', zIndex: 1 }} />
      <div style={{ position: 'relative', zIndex: 2, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', display: 'flex', flexDirection: 'column' }}>
        <NCHeader />
        <div style={{ padding: '0 16px 30px', display: 'flex', flexDirection: 'column', gap: 10 }}>
          {NC_LIST.map((n, i) => (
            <NCRow key={n.id} n={n} index={i} onOpen={() => setSel(n.id)} />
          ))}
          <NCFooter />
        </div>
      </div>
      {idx > -1 && (
        <NCDetail n={NC_LIST[idx]} onBack={() => setSel(null)} prev={NC_LIST[idx - 1]} next={NC_LIST[idx + 1]} onNav={setSel} />
      )}
    </div>
  );
}

const ncRoot = document.getElementById('root');
const ncEmbed = new URLSearchParams(window.__VBQ).get('embed') === '1';
ReactDOM.createRoot(ncRoot).render(
  ncEmbed ? <NoticeGlassApp /> : <IOSDevice dark={true} width={393} height={852}><NoticeGlassApp /></IOSDevice>
);
