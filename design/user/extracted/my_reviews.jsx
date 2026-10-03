/* global React, ReactDOM, TYPO, GRAY, LIME, PURPLE, RED, VAurora, VR, SP, PAGE_H, VR_BLUR, VRIcon, VRChev, VGlass, VButton, VGlassRound, VFooterNote, VToast, MRPATH, MR_REVIEWS, MRScreen, MRPushHead, MRReviewsScreen, vrState */
// ============ VYBE — 내 리뷰 페이지 (단독) ============
// 마이페이지 → 리뷰 탭에서 푸시되는 화면만 떼어냈다. 카드/정렬 바 구현은 my_renew_screens.jsx 공용.

function MyReviewsPage() {
  const [reviews, setReviews] = vrState(MR_REVIEWS);
  const [toast, setToast] = vrState('');
  const say = (m) => { setToast(m); setTimeout(() => setToast(''), 1900); };

  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', background: VR.ink, fontFamily: "'Pretendard', -apple-system, sans-serif" }}>
      <MRReviewsScreen
        onBack={() => (false ? history.back() : (window.__VBGO('%5Bv1%5DMY-029.html')))}
        reviews={reviews}
        onDelete={id => setReviews(rs => rs.filter(r => r.id !== id))}
        toast={say}
      />
      <VToast msg={toast} />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<MyReviewsPage />);
