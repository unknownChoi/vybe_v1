/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, PURPLE, window, NG, NG_GRAIN, NG_AURORA, NGI, NGCard, NG_TYPES, NG_FILTERS, NG_SECTIONS, NG_NOTIS, ngState, ngEffect */
// ============ VYBE — 알림 (Liquid Glass) · page ============

function NGRound({ children, onClick, href, size = 38 }) {
  const st = { all: 'unset', boxSizing: 'border-box', cursor: 'pointer', width: size, height: size, borderRadius: '50%', flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', ...NG.tile, backdropFilter: 'blur(16px) saturate(180%)', WebkitBackdropFilter: 'blur(16px) saturate(180%)' };
  return href
    ? <a href={href} style={{ ...st, textDecoration: 'none' }}>{children}</a>
    : <button onClick={onClick} style={st}>{children}</button>;
}

function NGHeader({ unread, onReadAll }) {
  return (
    <div style={{ position: 'relative', flexShrink: 0, padding: '52px 16px 16px' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
        <NGRound href="%5Bv1%5DHOME-005.html"><NGI.Back /></NGRound>
        <NGRound href="%5Bv1%5DMY-029.html"><NGI.Settings /></NGRound>
      </div>
      <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', gap: 12 }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 5 }}>
          <span style={{ ...TYPO.h1, color: '#fff', fontWeight: 800, letterSpacing: '-0.02em' }}>알림</span>
          <span style={{ ...TYPO.body4, color: NG.t3 }}>
            {unread > 0
              ? <>읽지 않은 소식 <span style={{ color: LIME[500], fontWeight: 700 }}>{unread}개</span></>
              : '모두 확인했어요'}
          </span>
        </div>
        <button onClick={onReadAll} disabled={!unread} style={{
          all: 'unset', boxSizing: 'border-box', cursor: unread ? 'pointer' : 'default', flexShrink: 0,
          padding: '9px 14px', borderRadius: 999, display: 'flex', alignItems: 'center', gap: 6,
          ...NG.tile, opacity: unread ? 1 : 0.4,
          backdropFilter: 'blur(16px) saturate(180%)', WebkitBackdropFilter: 'blur(16px) saturate(180%)',
          ...TYPO.button2, fontWeight: 600, color: '#fff', transition: 'opacity .2s',
        }}>
          <NGI.Check size={13} c={unread ? LIME[500] : NG.t4} />모두 읽음
        </button>
      </div>
    </div>
  );
}

function NGSectionLabel({ label, count }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '20px 4px 10px' }}>
      <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: NG.t2, letterSpacing: '0.04em' }}>{label}</span>
      <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 600, color: NG.t4 }}>{count}</span>
      <span style={{ flex: 1, height: 1, background: 'linear-gradient(90deg, rgba(255,255,255,0.13), rgba(255,255,255,0))' }} />
    </div>
  );
}

function NGRow({ noti, onRead, index }) {
  const t = NG_TYPES[noti.type];
  const Icon = t.Icon;
  const unread = !noti.read;
  return (
    <a href={noti.href || '#'} onClick={e => { if (!noti.href || noti.href === '#') e.preventDefault(); onRead(noti.id); }}
      className="ng-row"
      style={{ display: 'block', textDecoration: 'none', animation: 'fadeIn .3s ease both', animationDelay: `${index * 45}ms` }}>
      <NGCard pad={13} radius={19} quiet={!unread} style={{
        boxShadow: unread
          ? `inset 0 1px 0 rgba(255,255,255,0.18), 0 10px 30px rgba(0,0,0,0.36), 0 0 0 1px ${t.ring}`
          : 'inset 0 1px 0 rgba(255,255,255,0.08)',
        transition: 'box-shadow .3s ease, background .3s ease',
      }}>
        {unread && <div aria-hidden style={{ position: 'absolute', inset: 0, background: `linear-gradient(115deg, ${t.tint}, transparent 58%)`, pointerEvents: 'none' }} />}
        <div style={{ position: 'relative', display: 'flex', gap: 12 }}>
          {/* left visual */}
          {noti.thumb ? (
            <div style={{ position: 'relative', width: 52, height: 52, flexShrink: 0 }}>
              <div style={{ width: '100%', height: '100%', borderRadius: 15, background: noti.thumb, border: '1px solid rgba(255,255,255,0.12)', overflow: 'hidden', position: 'relative' }}>
                <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 26%, rgba(255,255,255,0.28), transparent 62%)' }} />
              </div>
              <span style={{ position: 'absolute', right: -5, bottom: -5, width: 23, height: 23, borderRadius: '50%', background: 'rgba(14,13,18,0.72)', backdropFilter: 'blur(10px)', WebkitBackdropFilter: 'blur(10px)', border: `1px solid ${t.ring}`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Icon size={12} c={t.hue} />
              </span>
            </div>
          ) : (
            <div style={{ width: 44, height: 44, borderRadius: 14, flexShrink: 0, background: t.tint, border: `1px solid ${t.ring}`, display: 'flex', alignItems: 'center', justifyContent: 'center', position: 'relative', overflow: 'hidden' }}>
              <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(160deg, rgba(255,255,255,0.18), transparent 60%)' }} />
              <span style={{ position: 'relative', display: 'flex' }}><Icon size={19} c={t.hue} /></span>
            </div>
          )}

          {/* content */}
          <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 4 }}>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
              <span style={{ ...TYPO.body4, fontSize: 14, lineHeight: '20px', fontWeight: unread ? 700 : 500, color: unread ? '#fff' : NG.t2, flex: 1 }}>{noti.title}</span>
              <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '16px', color: NG.t4, flexShrink: 0 }}>{noti.time}</span>
              {unread && <span style={{ width: 7, height: 7, borderRadius: 99, flexShrink: 0, background: t.hue, boxShadow: `0 0 8px ${t.hue}` }} />}
            </div>
            <span style={{ ...TYPO.caption, fontSize: 12, lineHeight: '18px', color: unread ? NG.t3 : NG.t4, display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>{noti.body}</span>
            {noti.cta && (
              <span style={{
                marginTop: 7, alignSelf: 'flex-start', display: 'inline-flex', alignItems: 'center', gap: 5,
                padding: '7px 13px', borderRadius: 999,
                ...(unread && noti.primary
                  ? { background: `linear-gradient(135deg, ${LIME[500]}, #94CF51)`, border: '1px solid rgba(255,255,255,0.3)', boxShadow: '0 8px 20px rgba(181,255,96,0.18), inset 0 1px 0 rgba(255,255,255,0.4)', color: NG.ink }
                  : { ...NG.tile, color: '#fff' }),
                ...TYPO.caption, fontSize: 12, lineHeight: '14px', fontWeight: 700,
              }}>
                {noti.cta}
                <NGI.ChevRight size={11} c={unread && noti.primary ? 'rgba(14,13,18,0.6)' : 'rgba(255,255,255,0.6)'} />
              </span>
            )}
          </div>
        </div>
      </NGCard>
    </a>
  );
}

function NGEmpty({ label }) {
  return (
    <NGCard pad={34} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 13, marginTop: 14 }}>
      <div style={{ width: 74, height: 74, borderRadius: '50%', background: 'rgba(119,49,254,0.16)', border: '1px solid rgba(119,49,254,0.3)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <NGI.Bell size={30} />
      </div>
      <span style={{ ...TYPO.h4, color: '#fff', fontWeight: 700 }}>{label}</span>
      <span style={{ ...TYPO.body4, color: NG.t3, textAlign: 'center', lineHeight: '20px' }}>새로운 소식이 오면<br />여기에서 가장 먼저 알려드릴게요</span>
    </NGCard>
  );
}

function NGShimmer({ w = '100%', h = 12, r = 6 }) {
  return <div style={{ width: w, height: h, borderRadius: r, flexShrink: 0, background: 'linear-gradient(90deg, rgba(255,255,255,0.05) 0px, rgba(255,255,255,0.13) 80px, rgba(255,255,255,0.05) 160px)', backgroundSize: '360px 100%', animation: 'shimmer 1.3s ease-in-out infinite' }} />;
}

function NGSkeleton() {
  return (
    <div style={{ padding: '4px 16px 24px', display: 'flex', flexDirection: 'column', gap: 10, animation: 'fadeIn .2s ease' }}>
      <div style={{ padding: '20px 4px 10px' }}><NGShimmer w={54} h={12} /></div>
      {[0, 1, 2, 3].map(i => (
        <NGCard key={i} pad={13} radius={19} quiet sheen={false}>
          <div style={{ display: 'flex', gap: 12 }}>
            <NGShimmer w={44} h={44} r={14} />
            <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 8, paddingTop: 3 }}>
              <NGShimmer w="62%" h={13} />
              <NGShimmer w="92%" h={10} />
              <NGShimmer w="45%" h={10} />
            </div>
          </div>
        </NGCard>
      ))}
    </div>
  );
}

function NGTabBar() {
  const tabs = [
    { key: 'home', label: '홈', C: NGI.HomeTab, href: '%5Bv1%5DHOME-005.html' },
    { key: 'near', label: '주변', C: NGI.AroundTab, href: '%5Bv1%5DPLACE-019.html' },
    { key: 'search', label: '검색', C: NGI.SearchTab, href: '%5Bv1%5DHOME-006.html' },
    { key: 'saved', label: '찜', C: NGI.SavedTab, href: '%5Bv1%5DPLACE-020.html' },
    { key: 'me', label: '내 정보', C: NGI.MeTab, href: '%5Bv1%5DMY-029.html' },
  ];
  return (
    <div style={{ position: 'relative', zIndex: 5, flexShrink: 0, display: 'flex', padding: '9px 8px 22px', ...NG.bar, borderTop: `1px solid ${NG.hair}` }}>
      {tabs.map(t => (
        <a key={t.key} href={t.href || '#'} onClick={e => !t.href && e.preventDefault()} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 5, textDecoration: 'none', padding: '4px 0' }}>
          <t.C active={false} />
          <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '12px', fontWeight: 500, color: NG.t3 }}>{t.label}</span>
        </a>
      ))}
    </div>
  );
}

function NotiGlassApp() {
  const [loading, setLoading] = ngState(true);
  const [notis, setNotis] = ngState(NG_NOTIS);

  ngEffect(() => {
    const t = setTimeout(() => setLoading(false), 1100);
    return () => clearTimeout(t);
  }, []);

  const unread = notis.filter(n => !n.read).length;
  const readAll = () => setNotis(ns => ns.map(n => ({ ...n, read: true })));
  const readOne = id => setNotis(ns => ns.map(n => n.id === id ? { ...n, read: true } : n));

  const visible = notis;

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: NG_AURORA, display: 'flex', flexDirection: 'column', fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, opacity: 0.05, backgroundImage: NG_GRAIN, mixBlendMode: 'overlay', pointerEvents: 'none', zIndex: 1 }} />

      <div style={{ position: 'relative', zIndex: 2, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', display: 'flex', flexDirection: 'column' }}>
        <NGHeader unread={unread} onReadAll={readAll} />

        {loading ? <NGSkeleton /> : (
          <div style={{ padding: '0 16px 28px' }}>
            {visible.length === 0
              ? <NGEmpty label="알림이 없어요" />
              : NG_SECTIONS.map(sec => {
                const rows = visible.filter(n => n.section === sec.key);
                if (!rows.length) return null;
                return (
                  <div key={sec.key}>
                    <NGSectionLabel label={sec.label} count={rows.length} />
                    <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                      {rows.map((n, i) => <NGRow key={n.id} noti={n} onRead={readOne} index={i} />)}
                    </div>
                  </div>
                );
              })}
          </div>
        )}
      </div>

      <NGTabBar />
    </div>
  );
}

const ngRoot = document.getElementById('root');
const ngEmbed = new URLSearchParams(window.__VBQ).get('embed') === '1';
ReactDOM.createRoot(ngRoot).render(
  ngEmbed ? <NotiGlassApp /> : <IOSDevice dark={true} width={393} height={852}><NotiGlassApp /></IOSDevice>
);
