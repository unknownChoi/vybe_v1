/* global React, ReactDOM, IOSDevice, TYPO, GRAY, LIME, PURPLE, window, NG, NG_GRAIN, NGIcon, NGStar, NGChev, NGCard, NGRound, NGMap, NGCrown, NG_CLUBS, NG_FILTERS, NG_SORTS, ngWalk, ngDist, ngState, ngEffect, ngRef */
// ============ VYBE — 주변 (Liquid Glass) · page ============
const H = 852;
const SNAPS = [0.3, 0.56, 0.88];
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));

function useSheet(initial, snaps, onDismiss) {
  const [frac, setFrac] = ngState(initial);
  const [dragging, setDragging] = ngState(false);
  const r = ngRef({ y: 0, f: initial, cur: initial });
  r.current.cur = frac;
  const grab = {
    onPointerDown: (e) => { r.current.y = e.clientY; r.current.f = frac; setDragging(true); try { e.currentTarget.setPointerCapture(e.pointerId); } catch (_) {} },
    onPointerMove: (e) => { if (!dragging) return; setFrac(clamp(r.current.f + (r.current.y - e.clientY) / H, 0, 1)); },
    onPointerUp: () => {
      if (!dragging) return;
      setDragging(false);
      const c = r.current.cur;
      if (onDismiss && c < snaps[0] * 0.7) { onDismiss(); return; }
      setFrac(snaps.reduce((a, b) => (Math.abs(b - c) < Math.abs(a - c) ? b : a)));
    },
    style: { touchAction: 'none' },
  };
  grab.onPointerCancel = grab.onPointerUp;
  return { frac, setFrac, dragging, grab };
}

// ---------- top: search GNB ----------
function NGGnb({ keyword, onClear, area, onClearArea }) {
  return (
    <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 22, padding: '54px 16px 0', pointerEvents: 'none' }}>
      <div aria-hidden style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 190, background: 'linear-gradient(180deg, rgba(10,9,14,0.82) 0%, rgba(10,9,14,0.34) 58%, transparent 100%)' }} />
      <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', gap: 10, pointerEvents: 'auto' }}>
        <a href="%5Bv1%5DHOME-006.html" style={{ display: 'flex', alignItems: 'center', gap: 10, height: 48, boxSizing: 'border-box', padding: '0 8px 0 18px', borderRadius: 999, textDecoration: 'none', ...NG.glass }}>
          <span style={{ flex: 1, minWidth: 0, ...TYPO.body4, fontWeight: keyword ? 600 : 400, color: keyword ? '#fff' : NG.t3, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
            {keyword || '클럽, 지역, 장르 검색'}
          </span>
          {keyword
            ? <button onClick={(e) => { e.preventDefault(); onClear(); }} style={{ all: 'unset', cursor: 'pointer', width: 34, height: 34, borderRadius: '50%', ...NG.tile, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><NGIcon d="close" size={15} c="#fff" w="2.4" /></button>
            : <span style={{ width: 34, height: 34, borderRadius: '50%', ...NG.tile, display: 'flex', alignItems: 'center', justifyContent: 'center' }}><NGIcon d="search" size={16} c={NG.t2} /></span>}
        </a>
        {area && (
          <button onClick={onClearArea} style={{ all: 'unset', cursor: 'pointer', alignSelf: 'flex-start', display: 'flex', alignItems: 'center', gap: 6, padding: '7px 10px 7px 13px', borderRadius: 999, background: 'rgba(119,49,254,0.34)', border: '1px solid rgba(181,255,96,0.35)', backdropFilter: 'blur(14px)', WebkitBackdropFilter: 'blur(14px)' }}>
            <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: '#fff' }}>{area} 지역</span>
            <NGIcon d="close" size={12} c="rgba(255,255,255,0.8)" w="2.6" />
          </button>
        )}
      </div>
    </div>
  );
}

// ---------- filter chips over the map ----------
function NGChips({ active, onToggle, sort, onSort }) {
  const [open, setOpen] = ngState(false);
  const cur = NG_SORTS.find(s => s.key === sort) || NG_SORTS[0];
  return (
    <div style={{ position: 'absolute', top: 116, left: 0, right: 0, zIndex: 21 }}>
      <div style={{ display: 'flex', gap: 7, overflowX: 'auto', scrollbarWidth: 'none', padding: '0 16px 4px' }}>
        <button onClick={() => setOpen(o => !o)} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, display: 'flex', alignItems: 'center', gap: 4, padding: '8px 12px', borderRadius: 999, ...NG.float, ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: '#fff' }}>
          {cur.label}
          <span style={{ display: 'flex', transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .2s' }}><NGChev size={12} c="rgba(255,255,255,0.8)" /></span>
        </button>
        {NG_FILTERS.map(f => {
          const on = active.includes(f.key);
          return (
            <button key={f.key} onClick={() => onToggle(f.key)} style={{
              all: 'unset', cursor: 'pointer', flexShrink: 0, padding: '8px 13px', borderRadius: 999,
              background: on ? 'linear-gradient(135deg, rgba(119,49,254,0.95), rgba(98,42,207,0.7))' : 'rgba(20,18,26,0.46)',
              backdropFilter: 'blur(16px) saturate(180%)', WebkitBackdropFilter: 'blur(16px) saturate(180%)',
              border: `1px solid ${on ? 'rgba(181,255,96,0.45)' : 'rgba(255,255,255,0.16)'}`,
              boxShadow: on ? '0 8px 20px rgba(119,49,254,0.35), inset 0 1px 0 rgba(255,255,255,0.28)' : 'inset 0 1px 0 rgba(255,255,255,0.18), 0 8px 22px rgba(0,0,0,0.4)',
              ...TYPO.caption, lineHeight: '14px', fontWeight: on ? 700 : 500, color: on ? '#fff' : NG.t2, whiteSpace: 'nowrap',
            }}>{f.label}</button>
          );
        })}
      </div>
      {open && (
        <>
          <div onClick={() => setOpen(false)} style={{ position: 'fixed', inset: 0, zIndex: 29 }} />
          <div style={{ position: 'absolute', top: 'calc(100% + 6px)', left: 16, zIndex: 30, minWidth: 168, padding: 5, borderRadius: 16, ...NG.glass, animation: 'fadeIn .14s ease' }}>
            {NG_SORTS.map(o => {
              const sel = o.key === sort;
              return (
                <button key={o.key} onClick={() => { onSort(o.key); setOpen(false); }} style={{ all: 'unset', cursor: 'pointer', width: '100%', boxSizing: 'border-box', padding: '11px 12px', borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12, background: sel ? 'rgba(119,49,254,0.22)' : 'transparent', ...TYPO.body4, fontWeight: sel ? 700 : 500, color: sel ? '#fff' : NG.t3 }}>
                  {o.label}{sel && <NGIcon d="check" size={14} c={LIME[500]} w="3" />}
                </button>
              );
            })}
          </div>
        </>
      )}
    </div>
  );
}

// ---------- floating map controls ----------
function NGControls({ bottom, areaMode, onZoom, onLocate, reSearch, onReSearch }) {
  return (
    <>
      {reSearch && (
        <div style={{ position: 'absolute', left: 0, right: 0, bottom: bottom + 8, zIndex: 15, display: 'flex', justifyContent: 'center', pointerEvents: 'none' }}>
          <button onClick={onReSearch} style={{ all: 'unset', pointerEvents: 'auto', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 7, padding: '10px 18px', borderRadius: 999, ...NG.float, animation: 'ngRise .28s cubic-bezier(.34,1.4,.64,1)' }}>
            <NGIcon d="refresh" size={15} c={LIME[500]} w="2.1" />
            <span style={{ ...TYPO.button2, color: '#fff' }}>현재 지역에서 재검색</span>
          </button>
        </div>
      )}
      <div style={{ position: 'absolute', right: 16, bottom: bottom + 8, zIndex: 16, display: 'flex', flexDirection: 'column', gap: 9, alignItems: 'center' }}>
        <div style={{ display: 'flex', flexDirection: 'column', borderRadius: 16, overflow: 'hidden', ...NG.float }}>
          <button onClick={() => onZoom(1)} disabled={!areaMode} style={{ all: 'unset', cursor: areaMode ? 'pointer' : 'default', width: 44, height: 42, display: 'flex', alignItems: 'center', justifyContent: 'center', opacity: areaMode ? 1 : 0.32 }}><NGIcon d="plus" size={17} c="#fff" w="2.3" /></button>
          <div style={{ height: 1, background: 'rgba(255,255,255,0.14)' }} />
          <button onClick={() => onZoom(-1)} disabled={areaMode} style={{ all: 'unset', cursor: areaMode ? 'default' : 'pointer', width: 44, height: 42, display: 'flex', alignItems: 'center', justifyContent: 'center', opacity: areaMode ? 0.32 : 1 }}><NGIcon d="minus" size={17} c="#fff" w="2.3" /></button>
        </div>
        <NGRound onClick={onLocate}><NGIcon d="locate" size={19} c="#fff" w="1.8" /></NGRound>
      </div>
    </>
  );
}

// ---------- list card ----------
function NGListCard({ club, selected, saved, onOpen, onSave }) {
  return (
    <a href={club.href || '%5Bv1%5DCLUB-021.html'} style={{
      display: 'block', textDecoration: 'none',
      position: 'relative', padding: '18px 4px', cursor: 'pointer', flexShrink: 0,
      borderBottom: `1px solid ${NG.hair}`,
      background: selected ? 'linear-gradient(90deg, rgba(119,49,254,0.16), transparent 72%)' : 'transparent',
      transition: 'background .2s',
    }}>
      <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', gap: 8 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <span style={{ ...TYPO.h4, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', minWidth: 0 }}>{club.name}</span>
          {club.rec && (
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, padding: '3px 8px', borderRadius: 999, flexShrink: 0, background: 'rgba(181,255,96,0.14)', border: '1px solid rgba(181,255,96,0.28)' }}>
              <NGStar size={10} />
              <span style={{ fontSize: 12, lineHeight: '14px', fontWeight: 700, color: LIME[500], letterSpacing: '-0.025em' }}>VYBE 추천 클럽</span>
            </span>
          )}
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
          <NGStar size={13} />
          <span style={{ ...TYPO.caption, lineHeight: '14px', color: '#fff', fontWeight: 700 }}>{club.rating.toFixed(2)}</span>
          <span style={{ ...TYPO.caption, lineHeight: '14px', color: NG.t4, marginLeft: 2 }}>{club.area}</span>
          <span style={{ width: 1, height: 11, background: 'rgba(255,255,255,0.2)' }} />
          <span style={{ ...TYPO.caption, lineHeight: '14px', color: NG.t4 }}>{club.genre}</span>
        </div>

        <div style={{ position: 'relative', width: '100%', height: 152, borderRadius: 14, background: club.photo, overflow: 'hidden', border: '1px solid rgba(255,255,255,0.1)' }}>
          <div style={{ position: 'absolute', inset: 0, background: 'radial-gradient(circle at 30% 26%, rgba(255,255,255,0.26), transparent 62%)' }} />
          <div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(180deg, transparent 52%, rgba(0,0,0,0.5) 100%)' }} />
          <div style={{ position: 'absolute', left: 10, bottom: 10, display: 'inline-flex', alignItems: 'center', gap: 5, padding: '5px 10px', borderRadius: 999, background: 'rgba(14,13,18,0.5)', border: '1px solid rgba(255,255,255,0.16)', backdropFilter: 'blur(12px) saturate(180%)', WebkitBackdropFilter: 'blur(12px) saturate(180%)' }}>
            <NGIcon d="walk" size={11} c="#fff" w="2.1" />
            <span style={{ fontSize: 12, lineHeight: '13px', fontWeight: 700, color: '#fff' }}>도보 {ngWalk(club.dist)}분 · {ngDist(club.dist)}</span>
          </div>
          <button onClick={(e) => { e.preventDefault(); e.stopPropagation(); onSave(club.id); }} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', right: 10, bottom: 10, width: 38, height: 38, borderRadius: '50%', background: 'rgba(20,18,26,0.5)', backdropFilter: 'blur(14px) saturate(180%)', WebkitBackdropFilter: 'blur(14px) saturate(180%)', border: '1px solid rgba(255,255,255,0.18)', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <NGIcon d="heart" size={18} c={saved ? PURPLE[500] : '#fff'} fill={saved ? PURPLE[500] : 'none'} w="2" />
          </button>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
          <NGIcon d="pin" size={13} c={NG.t4} w="2" />
          <span style={{ ...TYPO.caption, lineHeight: '14px', color: NG.t3, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{club.address}</span>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 16, flexWrap: 'wrap' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <NGIcon d="clock" size={13} c={NG.t4} w="2" />
            <span style={{ width: 5, height: 5, borderRadius: 99, background: club.open ? LIME[500] : 'rgba(255,255,255,0.3)', animation: club.open ? 'ngLive 1.6s ease-in-out infinite' : 'none' }} />
            <span style={{ ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: club.open ? LIME[500] : NG.t4 }}>{club.open ? '영업중' : '영업종료'}</span>
            <span style={{ width: 2, height: 2, borderRadius: 99, background: NG.t4 }} />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: NG.t3 }}>{club.hours}</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
            <NGIcon d="ticket" size={13} c={NG.t4} w="2" />
            <span style={{ ...TYPO.caption, lineHeight: '14px', color: NG.t3 }}>입장료 {club.fee}</span>
          </div>
        </div>
      </div>
    </a>
  );
}

function NGSkel() {
  return (
    <div style={{ padding: '18px 4px', borderBottom: `1px solid ${NG.hair}` }}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 9 }}>
        <div style={{ width: '46%', height: 18, borderRadius: 6, ...ngShimmer }} />
        <div style={{ width: '60%', height: 12, borderRadius: 6, ...ngShimmer }} />
        <div style={{ width: '100%', height: 152, borderRadius: 14, ...ngShimmer }} />
        <div style={{ width: '78%', height: 12, borderRadius: 6, ...ngShimmer }} />
        <div style={{ width: '56%', height: 12, borderRadius: 6, ...ngShimmer }} />
      </div>
    </div>
  );
}
const ngShimmer = { background: 'linear-gradient(90deg, rgba(255,255,255,0.05) 25%, rgba(255,255,255,0.14) 50%, rgba(255,255,255,0.05) 75%)', backgroundSize: '200% 100%', animation: 'ngShimmer 1.3s ease-in-out infinite' };

// ---------- list sheet ----------
function NGListSheet({ sheet, clubs, loading, label, selected, savedIds, onOpen, onSave, filters, onToggleFilter, sort, onSort, padBottom }) {
  const { frac, setFrac, dragging, grab } = sheet;
  return (
    <div style={{
      position: 'absolute', left: 0, right: 0, bottom: 0, height: frac * H, zIndex: 12,
      borderTopLeftRadius: 28, borderTopRightRadius: 28, overflow: 'hidden',
      ...NG.sheet, borderTop: '1px solid rgba(255,255,255,0.14)',
      boxShadow: '0 -14px 40px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.18)',
      display: 'flex', flexDirection: 'column',
      transition: dragging ? 'none' : 'height .34s cubic-bezier(0.32,0.72,0,1)',
    }}>
      <div aria-hidden style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 160, pointerEvents: 'none', background: 'radial-gradient(72% 110px at 12% 0%, rgba(119,49,254,0.22), transparent 70%), radial-gradient(70% 110px at 92% 0%, rgba(181,255,96,0.09), transparent 70%)' }} />
      <div {...grab} style={{ ...grab.style, position: 'relative', flexShrink: 0, cursor: 'grab', paddingTop: 11 }}>
        <div style={{ display: 'flex', justifyContent: 'center' }}>
          <div style={{ width: 40, height: 4.5, borderRadius: 99, background: 'rgba(255,255,255,0.28)' }} />
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 7, padding: '13px 20px 12px' }}>
          <span style={{ ...TYPO.body3, fontWeight: 700, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{label}</span>
          <span style={{ ...TYPO.body3, fontWeight: 800, color: LIME[500] }}>{loading ? '–' : clubs.length}</span>
        </div>
      </div>
      <div style={{ position: 'relative', flexShrink: 0, padding: '0 16px 12px', display: 'flex', gap: 7, overflowX: 'auto', scrollbarWidth: 'none' }}>
        <button onClick={() => onSort(NG_SORTS[(NG_SORTS.findIndex(s => s.key === sort) + 1) % NG_SORTS.length].key)} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, display: 'flex', alignItems: 'center', gap: 4, padding: '7px 12px', borderRadius: 999, background: 'rgba(255,255,255,0.1)', border: '1px solid rgba(255,255,255,0.16)', ...TYPO.caption, lineHeight: '14px', fontWeight: 700, color: '#fff' }}>
          {(NG_SORTS.find(s => s.key === sort) || NG_SORTS[0]).label}
          <NGChev dir="down" size={11} c="rgba(255,255,255,0.8)" />
        </button>
        {NG_FILTERS.map(f => {
          const on = filters.includes(f.key);
          return (
            <button key={f.key} onClick={() => onToggleFilter(f.key)} style={{ all: 'unset', cursor: 'pointer', flexShrink: 0, padding: '7px 12px', borderRadius: 999, background: on ? 'linear-gradient(135deg, rgba(119,49,254,0.95), rgba(98,42,207,0.7))' : 'rgba(255,255,255,0.06)', border: `1px solid ${on ? 'rgba(181,255,96,0.42)' : 'rgba(255,255,255,0.12)'}`, ...TYPO.caption, lineHeight: '14px', fontWeight: on ? 700 : 500, color: on ? '#fff' : NG.t3, whiteSpace: 'nowrap' }}>{f.label}</button>
          );
        })}
      </div>
      <div style={{ position: 'relative', flex: 1, overflowY: 'auto', scrollbarWidth: 'none', padding: `0 16px ${padBottom}px`, display: 'flex', flexDirection: 'column' }}>
        {loading
          ? [0, 1, 2].map(i => <NGSkel key={i} />)
          : clubs.length === 0
            ? <NGCard pad={30} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 12, marginTop: 6 }}>
                <div style={{ width: 62, height: 62, borderRadius: '50%', background: 'rgba(119,49,254,0.16)', border: '1px solid rgba(119,49,254,0.3)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}><NGIcon d="search" size={24} c={NG.t3} /></div>
                <span style={{ ...TYPO.body3, fontWeight: 700, color: '#fff' }}>조건에 맞는 클럽이 없어요</span>
                <span style={{ ...TYPO.body4, color: NG.t3, textAlign: 'center', lineHeight: '20px' }}>필터를 줄이거나 지도를 움직여<br />다른 지역에서 재검색해보세요</span>
              </NGCard>
            : clubs.map(c => <NGListCard key={c.id} club={c} selected={selected === c.id} saved={savedIds.has(c.id)} onOpen={onOpen} onSave={onSave} />)}
      </div>
    </div>
  );
}

// ---------- pin tap: compact club card ----------
function NGPinCard({ club, saved, onSave, onClose, bottom }) {
  return (
    <a href={club.href || '%5Bv1%5DCLUB-021.html'} style={{
      display: 'block', textDecoration: 'none',
      position: 'absolute', left: 12, right: 12, bottom, zIndex: 32, cursor: 'pointer',
      borderRadius: 19, overflow: 'hidden', ...NG.glass,
      boxShadow: '0 10px 30px rgba(0,0,0,0.36), 0 18px 44px rgba(0,0,0,0.28)',
      animation: 'ngRise .3s cubic-bezier(.34,1.4,.64,1)',
    }}>
      <div aria-hidden style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 1, background: 'rgba(255,255,255,0.18)', pointerEvents: 'none', zIndex: 2 }} />

      <div style={{ position: 'relative' }}>
        <div style={{ display: 'flex', gap: 6, overflowX: 'auto', scrollbarWidth: 'none', padding: '12px 12px 0' }}>
          {club.photos.map((bg, i) => (
            <div key={i} style={{ flex: i === 0 ? '0 0 64%' : '0 0 40%', height: 122, borderRadius: 12, background: bg, position: 'relative', overflow: 'hidden', border: `1px solid ${NG.hair}` }}>
              {i === 0 && (
                <div style={{ position: 'absolute', left: 8, bottom: 8, display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 10px', borderRadius: 99, ...NG.bar, border: `1px solid ${NG.hair}` }}>
                  <NGIcon d="walk" size={11} c="#fff" w="2" />
                  <span style={{ font: '600 11px/1 Pretendard, sans-serif', letterSpacing: '-0.27px', color: '#fff' }}>도보 {ngWalk(club.dist)}분 · {ngDist(club.dist)}</span>
                </div>
              )}
            </div>
          ))}
        </div>
        <button onClick={(e) => { e.preventDefault(); e.stopPropagation(); onClose(); }} style={{ all: 'unset', cursor: 'pointer', position: 'absolute', top: 20, right: 20, width: 38, height: 38, borderRadius: 99, ...NG.tile, backdropFilter: 'blur(18px)', WebkitBackdropFilter: 'blur(18px)', display: 'grid', placeItems: 'center' }}>
          <NGIcon d="close" size={15} c="#fff" w="2.2" />
        </button>
      </div>

      <div style={{ position: 'relative', padding: '14px 16px 16px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <span style={{ ...TYPO.h4, color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', minWidth: 0 }}>{club.name}</span>
          {club.rec && (
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 3, flexShrink: 0, padding: '3px 8px', borderRadius: 99, background: 'rgba(181,255,96,0.14)', border: '1px solid rgba(181,255,96,0.28)' }}>
              <NGCrown size={10} c={LIME[500]} />
              <span style={{ font: '600 11px/14px Pretendard, sans-serif', letterSpacing: '-0.27px', color: LIME[500] }}>VYBE 추천</span>
            </span>
          )}
          <button onClick={(e) => { e.preventDefault(); e.stopPropagation(); onSave(club.id); }} style={{ all: 'unset', cursor: 'pointer', marginLeft: 'auto', width: 38, height: 38, borderRadius: 99, flexShrink: 0, ...NG.tile, display: 'grid', placeItems: 'center' }}>
            <NGIcon d="heart" size={16} c={saved ? PURPLE[500] : NG.t2} fill={saved ? PURPLE[500] : 'none'} w="2" />
          </button>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 13, lineHeight: '15px', color: NG.t3 }}>
          <NGStar size={13} />
          <span style={{ color: '#fff', fontWeight: 600 }}>{club.rating.toFixed(2)}</span>
          <span style={{ color: GRAY[600] }}>({club.reviews})</span>
          <span style={{ width: 3, height: 3, borderRadius: 99, background: GRAY[600] }} />
          <span>{club.area}</span>
          <span style={{ width: 3, height: 3, borderRadius: 99, background: GRAY[600] }} />
          <span>{club.genre}</span>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap' }}>
          <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, padding: '4px 10px', borderRadius: 99, font: '600 11px/1 Pretendard, sans-serif', letterSpacing: '-0.27px', background: club.open ? 'rgba(181,255,96,0.14)' : 'rgba(255,92,95,0.13)', border: `1px solid ${club.open ? 'rgba(181,255,96,0.30)' : 'rgba(255,92,95,0.28)'}`, color: club.open ? LIME[500] : '#FF5C5F' }}>
            <span style={{ width: 5, height: 5, borderRadius: 99, background: 'currentColor' }} />
            {club.open ? '영업중' : '영업종료'}
          </span>
          <span style={{ fontSize: 13, lineHeight: '15px', color: NG.t3 }}>{club.hours}</span>
          <span style={{ width: 3, height: 3, borderRadius: 99, background: GRAY[600] }} />
          <span style={{ fontSize: 13, lineHeight: '15px', color: NG.t3 }}>입장료 {club.fee}</span>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10, marginTop: 2, padding: '11px 15px', borderRadius: 14, ...NG.bar, border: `1px solid ${NG.hair}` }}>
          <span style={{ fontSize: 13, lineHeight: '15px', color: NG.t3 }}>사진, 리뷰, 예약까지 자세히 보기</span>
          <NGChev size={13} c={LIME[500]} />
        </div>
      </div>
    </a>
  );
}

// ---------- tab bar ----------
function NGTabBar({ collapsed }) {
  const tabs = [
    { k: 'home', l: '홈', d: 'home', href: '%5Bv1%5DHOME-005.html' },
    { k: 'near', l: '주변', d: 'pin', href: null, on: true },
    { k: 'search', l: '검색', d: 'search', href: '%5Bv1%5DHOME-006.html' },
    { k: 'saved', l: '찜', d: 'heart', href: '%5Bv1%5DPLACE-020.html' },
    { k: 'me', l: '내 정보', d: 'me', href: '%5Bv1%5DMY-029.html' },
  ];
  return (
    <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, zIndex: 40, display: 'flex', padding: collapsed ? '7px 8px 12px' : '9px 8px 22px', ...NG.bar, borderTop: `1px solid ${NG.hair}`, transition: 'padding .26s ease' }}>
      {tabs.map(t => (
        <a key={t.k} href={t.href || '#'} onClick={e => !t.href && e.preventDefault()} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: collapsed ? 0 : 5, textDecoration: 'none', padding: '4px 0' }}>
          <NGIcon d={t.d} size={collapsed ? 21 : 23} c={t.on ? LIME[500] : '#fff'} fill={t.on && t.k === 'saved' ? LIME[500] : 'none'} w="1.7" />
          <span style={{ ...TYPO.caption, fontSize: 10.5, lineHeight: collapsed ? '0px' : '12px', fontWeight: t.on ? 700 : 500, color: t.on ? LIME[500] : NG.t3, opacity: collapsed ? 0 : 1, height: collapsed ? 0 : 12, overflow: 'hidden', transition: 'opacity .2s ease, height .26s ease, line-height .26s ease' }}>{t.l}</span>
        </a>
      ))}
    </div>
  );
}

// ---------- app ----------
function NearbyGlassApp() {
  const [selected, setSelected] = ngState(null);
  const [filters, setFilters] = ngState([]);
  const [sort, setSort] = ngState('rec');
  const [area, setArea] = ngState(null);
  const [keyword] = ngState(null);
  const [areaMode, setAreaMode] = ngState(false);
  const [pan, setPan] = ngState({ x: 0, y: 0 });
  const [reSearch, setReSearch] = ngState(false);
  const [loading, setLoading] = ngState(true);
  const [savedIds, setSavedIds] = ngState(() => new Set([1]));

  const listSheet = useSheet(SNAPS[0], SNAPS);

  ngEffect(() => { const t = setTimeout(() => setLoading(false), 850); return () => clearTimeout(t); }, []);

  // map pan
  const pr = ngRef({ down: false, x: 0, y: 0, ox: 0, oy: 0, moved: false });
  const [panning, setPanning] = ngState(false);
  const dragProps = {
    dragging: panning,
    onPointerDown: (e) => { pr.current = { down: true, x: e.clientX, y: e.clientY, ox: pan.x, oy: pan.y, moved: false }; setPanning(true); try { e.currentTarget.setPointerCapture(e.pointerId); } catch (_) {} },
    onPointerMove: (e) => {
      if (!pr.current.down) return;
      const dx = e.clientX - pr.current.x, dy = e.clientY - pr.current.y;
      if (Math.abs(dx) + Math.abs(dy) > 6) pr.current.moved = true;
      setPan({ x: clamp(pr.current.ox + dx, -70, 70), y: clamp(pr.current.oy + dy, -520, 70) });
    },
    onPointerUp: () => { if (!pr.current.down) return; pr.current.down = false; setPanning(false); if (pr.current.moved) setReSearch(true); },
  };
  dragProps.onPointerCancel = dragProps.onPointerUp;

  const toggleFilter = (k) => setFilters(p => (p.includes(k) ? p.filter(x => x !== k) : [...p, k]));
  const toggleSave = (id) => setSavedIds(p => { const n = new Set(p); n.has(id) ? n.delete(id) : n.add(id); return n; });

  // 핀(라벨 포함)이 카드에 가리지 않도록 지도를 위로 밀어 올린다
  const panForPin = (c) => {
    if (!c) return 0;
    const boxH = H + 80, originY = 0.42 * boxH - 40, zoom = 1.18;
    const y = originY + ((c.y / 100) * boxH - 40 - originY) * zoom;
    return clamp(Math.round(250 - y), -520, 0);
  };
  const pickPin = (id) => {
    const c = NG_CLUBS.find(x => x.id === id);
    setSelected(id);
    setPan({ x: 0, y: panForPin(c) });
    listSheet.setFrac(0);
  };
  const closePin = () => { setSelected(null); setPan({ x: 0, y: 0 }); listSheet.setFrac(SNAPS[0]); };
  const goDetail = (id) => { const c = NG_CLUBS.find(x => x.id === id); if (c) window.__VBGO(c.href || '%5Bv1%5DCLUB-021.html'); };

  let list = NG_CLUBS.filter(c => (!area || c.area === area));
  filters.forEach(f => {
    if (f === 'open') list = list.filter(c => c.open);
    if (f === 'free') list = list.filter(c => c.free);
    if (f === 'drink') list = list.filter(c => c.drink);
    if (f === 'hot') list = list.filter(c => c.hot);
    if (f === 'saved') list = list.filter(c => savedIds.has(c.id));
  });
  if (sort === 'dist') list = [...list].sort((a, b) => a.dist - b.dist);
  else if (sort === 'rating') list = [...list].sort((a, b) => b.rating - a.rating);
  else if (sort === 'review') list = [...list].sort((a, b) => b.reviews - a.reviews);
  else list = [...list].sort((a, b) => Number(b.rec) - Number(a.rec) || b.rating - a.rating);

  const label = keyword ? `'${keyword}' 검색 결과` : area ? `${area} 클럽` : '내 주변 클럽';
  const pinClub = NG_CLUBS.find(c => c.id === selected);
  const sheetTop = listSheet.frac * H;
  const collapsed = listSheet.frac > 0.5;
  const tabH = collapsed ? 62 : 78;

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%', overflow: 'hidden', background: NG.ink, fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <NGMap clubs={NG_CLUBS} selectedId={selected} onSelect={pickPin} areaMode={areaMode} onArea={(a) => { setArea(a.name); setAreaMode(false); listSheet.setFrac(SNAPS[1]); }} zoom={areaMode ? 0.86 : 1.18} pan={pan} dragProps={dragProps} />
      <div aria-hidden style={{ position: 'absolute', inset: 0, zIndex: 1, pointerEvents: 'none', background: 'radial-gradient(78% 240px at 2% 0%, rgba(119,49,254,0.26), transparent 64%), radial-gradient(66% 200px at 100% 10%, rgba(181,255,96,0.08), transparent 66%)' }} />
      <div aria-hidden style={{ position: 'absolute', inset: 0, zIndex: 1, opacity: 0.05, backgroundImage: NG_GRAIN, mixBlendMode: 'overlay', pointerEvents: 'none' }} />

      <NGGnb keyword={keyword} onClear={() => {}} area={area} onClearArea={() => { setArea(null); listSheet.setFrac(SNAPS[0]); }} />

      {!pinClub && (
        <NGControls
          bottom={sheetTop}
          areaMode={areaMode}
          onZoom={(d) => { setAreaMode(d < 0); setPan({ x: 0, y: 0 }); if (d < 0) setSelected(null); }}
          onLocate={() => { setPan({ x: 0, y: 0 }); setAreaMode(false); setReSearch(false); }}
          reSearch={reSearch}
          onReSearch={() => { setReSearch(false); setArea(null); setLoading(true); setTimeout(() => setLoading(false), 800); listSheet.setFrac(SNAPS[1]); }}
        />
      )}

      <NGListSheet
        sheet={listSheet} clubs={list} loading={loading} label={label}
        selected={selected} savedIds={savedIds} onOpen={goDetail} onSave={toggleSave}
        filters={filters} onToggleFilter={toggleFilter} sort={sort} onSort={setSort}
        padBottom={tabH + 12}
      />

      {pinClub && (
        <NGPinCard club={pinClub} saved={savedIds.has(pinClub.id)} onSave={toggleSave} onClose={closePin} bottom={tabH + 10} />
      )}

      <NGTabBar collapsed={collapsed} />
    </div>
  );
}

const ngRoot = document.getElementById('root');
const ngEmbed = new URLSearchParams(window.__VBQ).get('embed') === '1';
ReactDOM.createRoot(ngRoot).render(
  ngEmbed ? <NearbyGlassApp /> : <IOSDevice dark={true} width={393} height={852}><NearbyGlassApp /></IOSDevice>
);
