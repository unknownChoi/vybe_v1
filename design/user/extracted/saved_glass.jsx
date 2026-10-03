/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, PURPLE, window, SG, SG_GRAIN, SG_AURORA, SGI, SGCard, SG_CLUBS, SG_SORTS, sgState */
// ============ VYBE — 찜한 클럽 (Liquid Glass) · page ============

function SGHeader({ count, openCount }) {
  return (
    <div style={{ position: 'relative', flexShrink: 0, padding: '54px 16px 18px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12 }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
        <span style={{ ...TYPO.h1, color: '#fff', fontWeight: 800 }}>{count}</span>
        <span style={{ ...TYPO.h4, color: SG.t3, fontWeight: 500 }}>곳을 찜했어요</span>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 7, flexShrink: 0 }}>
        <span style={{ width: 7, height: 7, borderRadius: 99, background: LIME[500], boxShadow: `0 0 8px ${LIME[500]}` }} />
        <span style={{ ...TYPO.body4, color: SG.t2 }}>지금 <span style={{ color: '#fff', fontWeight: 700 }}>{openCount}곳</span> 영업중</span>
      </div>
    </div>
  );
}

function SGToolbar({ view, onView, sort, onSort }) {
  const [open, setOpen] = sgState(false);
  const current = SG_SORTS.find(o => o.key === sort) || SG_SORTS[0];
  return (
    <div style={{ position: 'sticky', top: 0, zIndex: 20, flexShrink: 0, padding: '11px 16px', ...SG.bar, borderTop: `1px solid ${SG.hair}`, borderBottom: `1px solid ${SG.hair}`, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
      <div style={{ position: 'relative' }}>
        <button onClick={() => setOpen(o => !o)} style={{ all: 'unset', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 4, padding: '7px 13px', borderRadius: 999, ...SG.tile, ...TYPO.button2, fontWeight: 600, color: '#fff' }}>
          {current.label}
          <span style={{ display: 'flex', transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .2s' }}><SGI.Chevron size={12} /></span>
        </button>
        {open && (
          <>
            <div onClick={() => setOpen(false)} style={{ position: 'fixed', inset: 0, zIndex: 29 }} />
            <div style={{ position: 'absolute', top: 'calc(100% + 8px)', left: 0, zIndex: 30, minWidth: 168, padding: 5, borderRadius: 16, ...SG.glass, animation: 'fadeIn .14s ease' }}>
              {SG_SORTS.map(o => {
                const sel = o.key === sort;
                return (
                  <button key={o.key} onClick={() => { onSort(o.key); setOpen(false); }} style={{ all: 'unset', cursor: 'pointer', width: '100%', boxSizing: 'border-box', padding: '11px 12px', borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12, background: sel ? 'rgba(119,49,254,0.22)' : 'transparent', ...TYPO.body4, fontWeight: sel ? 700 : 500, color: sel ? '#fff' : SG.t3 }}>
                    {o.label}{sel && <SGI.Check size={14} c={LIME[500]} />}
                  </button>
                );
              })}
            </div>
          </>
        )}
      </div>

      <div style={{ display: 'flex', gap: 3, padding: 3, borderRadius: 999, background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.1)' }}>
        {[{ k: 'list', C: SGI.List }, { k: 'grid', C: SGI.Grid }].map(v => {
          const sel = view === v.k;
          return (
            <button key={v.k} onClick={() => onView(v.k)} style={{ all: 'unset', cursor: 'pointer', width: 34, height: 28, borderRadius: 999, background: sel ? '#fff' : 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center', transition: 'all .18s ease' }}>
              <v.C size={14} c={sel ? SG.ink : SG.t3} />
            </button>
          );
        })}
      </div>
    </div>
  );
}

function SGTag({ tag }) {
  const hot = tag === 'HOT';
  return (
    <div style={{ position: 'absolute', top: 8, left: 8, display: 'inline-flex', alignItems: 'center', gap: 4, padding: '4px 9px', borderRadius: 999, background: hot ? 'rgba(255,59,110,0.88)' : 'rgba(14,13,18,0.72)', border: `1px solid ${hot ? 'rgba(255,255,255,0.28)' : 'rgba(181,255,96,0.42)'}`, backdropFilter: 'blur(10px)', WebkitBackdropFilter: 'blur(10px)' }}>
      {!hot && <SGI.Star size={9} />}
      <span style={{ fontSize: 10, lineHeight: '12px', fontWeight: 800, color: hot ? '#fff' : LIME[500], whiteSpace: 'nowrap' }}>{tag}</span>
    </div>
  );
}

function SGListCard({ club, onUnsave }) {
  return (
    <SGCard pad={12} radius={18}>
      <a href={club.href || '#'} onClick={e => !club.href && e.preventDefault()} style={{ display: 'flex', gap: 13, textDecoration: 'none' }}>
        <div style={{ width: 92, height: 92, borderRadius: 14, flexShrink: 0, background: club.photo, position: 'relative', overflow: 'hidden', border: '1px solid rgba(255,255,255,0.1)' }}>
          <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 28%, rgba(255,255,255,0.26), transparent 62%)' }} />
          {club.tag && <SGTag tag={club.tag} />}
        </div>
        <div style={{ flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column', gap: 6 }}>
          <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 8 }}>
            <span style={{ ...TYPO.body3, color: '#fff', fontWeight: 700, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', flex: 1 }}>{club.name}</span>
            <button onClick={e => { e.preventDefault(); onUnsave(club.id); }} style={{ all: 'unset', cursor: 'pointer', width: 30, height: 30, borderRadius: '50%', marginTop: -3, marginRight: -3, flexShrink: 0, ...SG.tile, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <SGI.Heart size={15} active />
            </button>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <SGI.Star size={11} />
            <span style={{ ...TYPO.caption, color: '#fff', lineHeight: '14px', fontWeight: 700 }}>{club.rating.toFixed(2)}</span>
            <span style={{ width: 1, height: 9, background: 'rgba(255,255,255,0.2)' }} />
            <span style={{ ...TYPO.caption, color: SG.t3, lineHeight: '14px' }}>{club.area}</span>
            <span style={{ width: 2, height: 2, background: SG.t4, borderRadius: 99 }} />
            <span style={{ ...TYPO.caption, color: SG.t3, lineHeight: '14px' }}>{club.genre}</span>
          </div>
          <div style={{ display: 'inline-flex', alignItems: 'center', gap: 5, alignSelf: 'flex-start', padding: '4px 9px', borderRadius: 999, background: club.open ? 'rgba(181,255,96,0.13)' : 'rgba(255,255,255,0.06)', border: `1px solid ${club.open ? 'rgba(181,255,96,0.28)' : 'rgba(255,255,255,0.1)'}` }}>
            <span style={{ width: 5, height: 5, borderRadius: 99, background: club.open ? LIME[500] : 'rgba(255,255,255,0.35)' }} />
            <span style={{ ...TYPO.caption, lineHeight: '13px', fontWeight: 700, color: club.open ? LIME[500] : SG.t4 }}>{club.open ? '영업중' : '영업종료'}</span>
            <span style={{ ...TYPO.caption, lineHeight: '13px', color: SG.t3 }}>{club.hours}</span>
          </div>
          <span style={{ ...TYPO.caption, color: SG.t4, lineHeight: '14px' }}>{club.savedAt}</span>
        </div>
      </a>
    </SGCard>
  );
}

function SGGridCard({ club, onUnsave }) {
  return (
    <a href={club.href || '#'} onClick={e => !club.href && e.preventDefault()} style={{ display: 'flex', flexDirection: 'column', gap: 9, textDecoration: 'none' }}>
      <div style={{ width: '100%', aspectRatio: '1', borderRadius: 19, background: club.photo, position: 'relative', overflow: 'hidden', border: '1px solid rgba(255,255,255,0.1)' }}>
        <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 32% 26%, rgba(255,255,255,0.26), transparent 62%)' }} />
        <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(180deg, transparent 46%, rgba(0,0,0,0.68) 100%)' }} />
        {club.tag && <SGTag tag={club.tag} />}
        <button onClick={e => { e.preventDefault(); onUnsave(club.id); }} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', top: 8, right: 8, width: 30, height: 30, borderRadius: '50%', background: 'rgba(20,18,26,0.5)', backdropFilter: 'blur(12px)', WebkitBackdropFilter: 'blur(12px)', border: '1px solid rgba(255,255,255,0.16)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <SGI.Heart size={15} active />
        </button>
        <div style={{ position: 'absolute', left: 9, right: 9, bottom: 9, display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 6 }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4 }}>
            <span style={{ width: 5, height: 5, borderRadius: 99, background: club.open ? LIME[500] : 'rgba(255,255,255,0.45)' }} />
            <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '12px', color: '#fff', fontWeight: 700 }}>{club.open ? '영업중' : '영업종료'}</span>
          </span>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, padding: '3px 8px', borderRadius: 999, background: 'rgba(14,13,18,0.5)', backdropFilter: 'blur(10px)', border: '1px solid rgba(255,255,255,0.14)' }}>
            <SGI.Star size={9} />
            <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '12px', color: '#fff', fontWeight: 700 }}>{club.rating.toFixed(1)}</span>
          </span>
        </div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 3, padding: '0 2px' }}>
        <span style={{ ...TYPO.body4, color: '#fff', fontWeight: 700, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{club.name}</span>
        <span style={{ ...TYPO.caption, lineHeight: '14px', color: SG.t3 }}>{club.area} · {club.genre}</span>
      </div>
    </a>
  );
}

function SGEmpty() {
  return (
    <SGCard pad={32} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14, marginTop: 8 }}>
      <div style={{ width: 76, height: 76, borderRadius: '50%', background: 'rgba(119,49,254,0.16)', border: '1px solid rgba(119,49,254,0.3)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <SGI.Heart size={30} active={false} />
      </div>
      <span style={{ ...TYPO.h4, color: '#fff' }}>아직 찜한 클럽이 없어요</span>
      <span style={{ ...TYPO.body4, color: SG.t3, textAlign: 'center', lineHeight: '20px' }}>마음에 드는 클럽의 하트를 눌러서<br />나만의 리스트를 만들어보세요</span>
      <a href="%5Bv1%5DHOME-005.html" style={{ padding: '13px 26px', borderRadius: 14, background: `linear-gradient(135deg, ${LIME[500]}, ${LIME[700]})`, boxShadow: '0 10px 26px rgba(181,255,96,0.2), inset 0 1px 0 rgba(255,255,255,0.35)', color: SG.ink, textDecoration: 'none', ...TYPO.button1, fontWeight: 700, marginTop: 2 }}>클럽 둘러보기</a>
    </SGCard>
  );
}

function SGTabBar() {
  const tabs = [
    { key: 'home', label: '홈', C: SGI.HomeTab, href: '%5Bv1%5DHOME-005.html' },
    { key: 'near', label: '주변', C: SGI.AroundTab, href: '%5Bv1%5DPLACE-019.html' },
    { key: 'search', label: '검색', C: SGI.SearchTab, href: '%5Bv1%5DHOME-006.html' },
    { key: 'saved', label: '찜', C: SGI.SavedTab, href: null, active: true },
    { key: 'me', label: '내 정보', C: SGI.MeTab, href: '%5Bv1%5DMY-029.html' },
  ];
  return (
    <div style={{ position: 'relative', zIndex: 5, flexShrink: 0, display: 'flex', padding: '9px 8px 22px', ...SG.bar, borderTop: `1px solid ${SG.hair}` }}>
      {tabs.map(t => (
        <a key={t.key} href={t.href || '#'} onClick={e => !t.href && e.preventDefault()} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 5, textDecoration: 'none', padding: '4px 0' }}>
          <t.C active={t.active} />
          <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: '12px', fontWeight: t.active ? 700 : 500, color: t.active ? LIME[500] : SG.t3 }}>{t.label}</span>
        </a>
      ))}
    </div>
  );
}

function SavedGlassApp() {
  const [view, setView] = sgState('list');
  const [sort, setSort] = sgState('recent');
  const [clubs, setClubs] = sgState(SG_CLUBS);

  let list = clubs;
  if (sort === 'rating') list = [...list].sort((a, b) => b.rating - a.rating);
  else if (sort === 'name') list = [...list].sort((a, b) => a.name.localeCompare(b.name, 'ko'));
  else if (sort === 'open') list = [...list].sort((a, b) => Number(b.open) - Number(a.open));

  const unsave = (id) => setClubs(cs => cs.filter(c => c.id !== id));

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: SG_AURORA, display: 'flex', flexDirection: 'column', fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, opacity: 0.05, backgroundImage: SG_GRAIN, mixBlendMode: 'overlay', pointerEvents: 'none', zIndex: 1 }} />

      <div style={{ position: 'relative', zIndex: 2, flex: 1, overflowY: 'auto', scrollbarWidth: 'none', display: 'flex', flexDirection: 'column' }}>
        <SGHeader count={clubs.length} openCount={clubs.filter(c => c.open).length} />
        <SGToolbar view={view} onView={setView} sort={sort} onSort={setSort} />

        <div style={{ padding: '16px 16px 28px', display: view === 'grid' ? 'grid' : 'flex', gridTemplateColumns: view === 'grid' ? 'repeat(2,1fr)' : undefined, flexDirection: view === 'grid' ? undefined : 'column', gap: view === 'grid' ? 14 : 12 }}>
          {list.length === 0
            ? <div style={{ gridColumn: '1 / -1' }}><SGEmpty /></div>
            : list.map(c => view === 'grid'
              ? <SGGridCard key={c.id} club={c} onUnsave={unsave} />
              : <SGListCard key={c.id} club={c} onUnsave={unsave} />)}
        </div>
      </div>

      <SGTabBar />
    </div>
  );
}

const sgRoot = document.getElementById('root');
const sgEmbed = new URLSearchParams(window.__VBQ).get('embed') === '1';
ReactDOM.createRoot(sgRoot).render(
  sgEmbed ? <SavedGlassApp /> : <IOSDevice dark={true} width={393} height={852}><SavedGlassApp /></IOSDevice>
);
