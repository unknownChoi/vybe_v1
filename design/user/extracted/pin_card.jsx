/* global React, ReactDOM, TYPO, GRAY, LIME, PURPLE, NG, NG_GRAIN, NGIcon, NGStar, NGChev, NGCrown, NG_CLUBS, ngWalk, ngDist */
// ============ VYBE — 핀 탭 클럽 카드 (단독) ============
// nearby_glass.jsx의 NGPinCard를 그대로 떼어냈다. 디자인 시스템 GlassCard(강조·elevated) 규격.

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

function PinCardStage() {
  const [saved, setSaved] = React.useState(new Set());
  const club = NG_CLUBS[0];
  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: NG.ink, fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <div aria-hidden style={{ position: 'absolute', inset: 0, background: 'radial-gradient(120% 80% at 0% 0%, rgba(119,49,254,0.38), transparent 72%), radial-gradient(110% 80% at 100% 4%, rgba(181,255,96,0.18), transparent 74%), radial-gradient(120% 90% at 90% 100%, rgba(119,49,254,0.26), transparent 76%)' }} />
      <div aria-hidden style={{ position: 'absolute', inset: 0, backgroundImage: NG_GRAIN, opacity: 0.5, mixBlendMode: 'overlay' }} />
      <NGPinCard
        club={club}
        saved={saved.has(club.id)}
        onSave={(id) => setSaved(s => { const n = new Set(s); n.has(id) ? n.delete(id) : n.add(id); return n; })}
        onClose={() => {}}
        bottom={0}
      />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<PinCardStage />);
