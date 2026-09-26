// 찜 탭 공용 — 정렬 옵션.
//
// 썸네일 폴백 그라데이션은 core `clubGradientFor`, 캡션은 `ClubGlass.caption`,
// 상세 이동은 `openClubDetail` 을 바로 쓴다 — 여기 두던 사본·패스스루는 뺐다.

enum SavedSortOption { recent, rating, name, open }

const Map<SavedSortOption, String> kSavedSortLabels = {
  SavedSortOption.recent: '최근 찜한 순',
  SavedSortOption.rating: '평점 높은 순',
  SavedSortOption.name: '가나다 순',
  SavedSortOption.open: '영업중 먼저',
};
