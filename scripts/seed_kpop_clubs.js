// 장르 "K-POP" 클럽 100개 신규 생성. 5개 지역 균등(각 20개),
// VYBE 추천 80곳도 지역별 균등(각 16개).
//
// ⚠ DB 에 'K-POP' 장르는 이 스크립트가 처음 만든다. 기존 '팝' 17곳은 건드리지 않는다.
//    앱은 `kKpopGenre`(presentation/kpop/kpop_models.dart) 로 이 값을 읽는다 — 둘이 같아야 한다.
//
// 이미지는 **기존 클럽 전체에서 랜덤**으로 골라 쓴다 (clubs/** 는 공개 읽기라 URL 그대로 참조).
//   thumbnail / gallery(=imageUrls·heroImageUrls) / menuBoard / menu 이미지 전부.
//   seed_hybrid_clubs.js 는 한 클럽(더 베이스) 자산만 복제해 100곳이 전부 같은 사진이 됐다.
//
// 각 신규 클럽: clubs/{auto} + info/{id} + menus/* + reviews/* + photos/*.
// rating/ratingSum/reviewCount 는 0 으로 두고 onReviewCreated 트리거에 맡긴다
//   (직접 계산해 넣으면 트리거가 또 더해 두 배가 된다).
//
// 실행: gcloud 로그인 상태에서  node scripts/seed_kpop_clubs.js
//   --dry      : 쓰지 않고 계획만 출력
//   --force    : 이미 K-POP 클럽이 있어도 강행 (중복 생성 주의)
//   --purge    : 기존 genre='K-POP' 클럽을 **서브컬렉션까지 전부 삭제**하고 끝낸다 (생성 안 함)
//   --count=N  : 생성 개수 (기본 100)
//   --no-photos: photos 서브컬렉션 생략

const { execSync } = require('child_process');
const https = require('https');

const PROJECT = 'vybe-bata-c07aa';
const GENRE = 'K-POP';
const CONC = 6;
const enc = encodeURIComponent;

const DRY = process.argv.includes('--dry');
const FORCE = process.argv.includes('--force');
const PURGE = process.argv.includes('--purge');
const NO_PHOTOS = process.argv.includes('--no-photos');
const countArg = process.argv.find((a) => a.startsWith('--count='));
const COUNT = countArg ? parseInt(countArg.split('=')[1]) : 100;

/// VYBE 추천으로 만들 개수. 지역별로 고르게 나눈다.
const recArg = process.argv.find((a) => a.startsWith('--recommended='));
const RECOMMENDED = recArg ? parseInt(recArg.split('=')[1]) : 80;

// ── 지역 (중심 좌표 · 행정구 · 도로명 · 지하철) ──
// 좌표는 core/constants/app_geo.dart 의 hotspotCenters 와 같은 값이어야 한다.
const REGIONS = [
  {
    area: '홍대', slug: 'hongdae', gu: '마포구', lat: 37.5547, lng: 126.9230,
    roads: ['양화로', '와우산로', '동교로', '홍익로', '잔다리로'],
    subways: [
      { station: '홍대입구', distanceM: 320, lines: ['2호선', '경의중앙선', '공항철도'] },
      { station: '상수', distanceM: 540, lines: ['6호선'] },
    ],
  },
  {
    area: '강남', slug: 'gangnam', gu: '강남구', lat: 37.4979, lng: 127.0276,
    roads: ['강남대로', '테헤란로', '논현로', '도산대로', '봉은사로'],
    subways: [
      { station: '강남', distanceM: 280, lines: ['2호선', '신분당선'] },
      { station: '신논현', distanceM: 610, lines: ['9호선', '신분당선'] },
    ],
  },
  {
    area: '이태원', slug: 'itaewon', gu: '용산구', lat: 37.5345, lng: 126.9946,
    roads: ['이태원로', '녹사평대로', '우사단로', '보광로', '한남대로'],
    subways: [
      { station: '이태원', distanceM: 240, lines: ['6호선'] },
      { station: '녹사평', distanceM: 700, lines: ['6호선'] },
    ],
  },
  {
    area: '건대', slug: 'kondae', gu: '광진구', lat: 37.5403, lng: 127.0698,
    roads: ['아차산로', '능동로', '광나루로', '자양로', '동일로'],
    subways: [
      { station: '건대입구', distanceM: 300, lines: ['2호선', '7호선'] },
      { station: '구의', distanceM: 820, lines: ['2호선'] },
    ],
  },
  {
    area: '신촌', slug: 'sinchon', gu: '서대문구', lat: 37.5559, lng: 126.9368,
    roads: ['연세로', '신촌로', '명물길', '백범로', '대현로'],
    subways: [
      { station: '신촌', distanceM: 260, lines: ['2호선'] },
      { station: '이대', distanceM: 640, lines: ['2호선'] },
    ],
  },
];

// ── 고유 클럽명 풀 (110개 — 기존 클럽명과 겹치는 건 실행 시 걸러낸다) ──
const NAMES = [
  '클럽 아이돌', '클럽 앙코르', '클럽 팬덤', '클럽 컴백', '클럽 데뷔',
  '클럽 스테이지', '클럽 센터', '클럽 하이노트', '클럽 올킬', '클럽 차트인',
  '클럽 타이틀곡', '클럽 유닛', '클럽 비주얼', '클럽 칼군무', '클럽 직캠',
  '클럽 응원봉', '클럽 슬로건', '클럽 포토카드', '클럽 리액션', '클럽 퍼포먼스',
  '더 아이돌', '더 팬덤', '더 컴백', '더 앙코르', '더 하모니',
  '더 멜로디', '더 리듬', '더 코러스', '더 브리지', '더 트로피',
  '더 스포트라이트', '더 크라운', '더 데뷔', '더 센터', '더 원더',
  '케이팝 파라다이스', '케이팝 시티', '케이팝 스퀘어', '케이팝 스테이션', '케이팝 하우스',
  '케이팝 라운지', '케이팝 아레나', '케이팝 팩토리', '케이팝 스튜디오', '케이팝 아카이브',
  '멜로디 홀', '하모니 바', '리듬 세션', '비트박스', '템포',
  '크레센도', '옥타브', '코러스 룸', '후렴구', '간주점프',
  '킬링파트', '포인트안무', '음원차트', '스밍총공', '역주행',
  '아이돌룸', '팬덤하우스', '컴백라운지', '앙코르바', '스테이지식스',
  '아이돌 나이트', '데뷔 나이트', '컴백 나이트', '앙코르 나이트', '차트 나이트',
  '원더랜드', '소녀시절', '그시절 가요', '레트로 가요', '밀레니엄 팝',
  '2000 하우스', '뉴트로 스테이지', '가요톱텐', '인기가요', '음악중심',
  '핑크블러썸', '러브다이브', '체리블라썸', '드림노트', '스타라이트',
  '문라이트 아이돌', '네온아이돌', '슈퍼노바', '하이라이트', '클라이맥스',
  '스포트라이트', '샤이닝스타', '드림스테이지', '위시리스트', '판타지아 팝',
  '에이스', '퍼스트클래스', '올라운더', '멀티버스', '유니버스',
  '하트시그널', '심쿵', '덕질하우스', '최애', '입덕',
  '컬러링', '플레이리스트', '리피트', '셔플', '앵콜요청',
];

// ── K-POP 클럽 설명 풀 ──
const DESCRIPTIONS = [
  '최신 K-POP 히트곡만 트는 아이돌 전문 클럽. 아는 노래만 나온다.',
  '4세대 아이돌 타이틀곡으로 꽉 채운 플레이리스트. 칼군무 따라하기 좋은 곳.',
  '걸그룹 명곡부터 최신곡까지, 떼창이 끊이지 않는 K-POP 플로어.',
  '2000년대 가요와 최신 K-POP 이 번갈아 흐르는 세대 통합 클럽.',
  '보이그룹 셋리스트가 강한 곳. 응원법 아는 사람들이 모인다.',
  '음방 1위곡만 골라 트는 K-POP 전용 플레이그라운드.',
  '아이돌 뮤직비디오를 대형 스크린에 띄우는 비주얼 중심 클럽.',
  '덕후들의 아지트. 최애 노래 신청 받는 K-POP 라운지.',
  '커버댄스 스테이지가 열리는 날이 있는 참여형 K-POP 클럽.',
  '레트로 가요와 뉴트로 리믹스가 섞인 감성 K-POP 나이트.',
  '스밍 차트 상위권 곡으로만 채운 셋. 처음 와도 다 아는 노래.',
  '아이돌 콘서트 뒤풀이 성지. 응원봉 들고 와도 어색하지 않다.',
];

// ── 메뉴명 풀 ──
const MENU_NAMES = [
  'NEGRONI', 'OLD FASHIONED', 'MOJITO', 'MARGARITA', 'COSMOPOLITAN', 'MANHATTAN',
  'WHISKEY SOUR', 'DAIQUIRI', 'GIN TONIC', 'APEROL SPRITZ', 'PINA COLADA',
  'LONG ISLAND', 'MAI TAI', 'TEQUILA SUNRISE', 'BLOODY MARY', 'ESPRESSO MARTINI',
  'MOSCOW MULE', 'WHITE RUSSIAN', 'GIMLET', 'SIDECAR', 'BELLINI', 'KIR ROYALE',
  'SEX ON THE BEACH', 'BLUE HAWAII', 'CAIPIRINHA', 'MOËT & CHANDON',
  'DOM PÉRIGNON', 'VEUVE CLICQUOT', 'JÄGERBOMB', 'B-52',
  '하이볼', '얼그레이 하이볼', '청포도 하이볼', '레몬 하이볼', '자몽 하이볼',
  '생맥주 500', '수제 맥주', 'IPA 드래프트', '버드와이저', '하이네켄',
  '나초 플래터', '감바스 알 아히요', '치즈 플래터', '트러플 감자튀김', '치킨윙',
  '먹태 구이', '소시지 모둠', '하몽 플래터', '과일 안주', '오징어 튀김',
  '아이돌 시그니처', '컴백 스페셜', '앙코르 펀치', '최애 칵테일', '덕질 하이볼',
  '핑크 라이트', '네온 응원봉', '스밍 총공', '타이틀곡 마티니', '역주행 소다',
];

// ── 리뷰 내용 풀 (K-POP 무드) ──
const REVIEW_TEXTS = [
  '진짜 아는 노래만 나와서 세 시간 내내 떼창했어요.',
  '최애 노래 신청했는데 틀어주셔서 감동... 또 갈 거예요.',
  '칼군무 따라하는 사람 많아서 같이 추기 좋았어요.',
  '음방 1위곡 위주로 틀어줘서 처음 온 친구도 잘 놀았어요.',
  '뮤비를 스크린에 띄워줘서 눈이 심심할 틈이 없어요.',
  '걸그룹 메들리 구간에서 완전 미쳤습니다.',
  '2000년대 가요 틀어줄 때 분위기 폭발했어요 ㅋㅋ',
  '응원법 아는 사람들이 많아서 콘서트 온 기분.',
  'DJ 선곡 취향저격. 셋리스트만 보고 또 오고 싶네요.',
  '입장료 대비 만족도 최고예요. 칵테일도 맛있음.',
  '보이그룹 파트 나올 때 플로어가 하나가 됐어요.',
  '덕질하는 친구들이랑 오기 딱 좋은 곳.',
  '사운드랑 조명 퀄리티가 다르네요. 사진도 잘 나와요.',
  '직원분들 친절하고 화장실도 깨끗했어요.',
  '주말 웨이팅 좀 있었지만 들어가니까 다 잊혀짐.',
  '커버댄스 스테이지 열린 날 갔는데 진짜 재밌었어요.',
  '늦게까지 영업해서 새벽까지 놀았네요.',
  '처음 와봤는데 단골 될 것 같아요. 강추!',
  '생일파티로 갔는데 최애 노래 틀어주셔서 최고였어요.',
  '플로어 넓어서 춤추기 좋고 에어컨도 빵빵해요.',
];

const NICKNAMES = [
  '최애만세', '덕질러', '응원봉지기', '입덕부정기', '스밍요정', '포카수집가',
  '칼군무장인', '떼창머신', '음방투표러', '홍대토박이', '주말전사', '네온키드',
  '댄싱퀸', '나이트아울', '플로어킬러', '서울나이트', '뮤직중독', '리듬타기',
  '컴백대기중', '역주행요정', '가요톱텐', '슬로건러', '직캠장인', '올팬',
  '파티피플', '문라이트', '심쿵주의', '앵콜요청', '타이틀곡러', '첫콘직관',
];

const TAG_POOL = [
  '최신 K-POP', '4세대 아이돌', '걸그룹', '보이그룹', '2000년대 가요',
  '떼창', '커버댄스', '아이돌', '대형클럽', '루프탑', '라운지', '감성',
];

// ── 유의사항 풀 ──
const CAUTIONS = [
  '만 19세 미만 입장 불가 (신분증 지참 필수)',
  '슬리퍼·반바지 등 복장 제한이 있을 수 있어요',
  '만석 시 조기 입장 마감될 수 있어요',
  '외부 음식물 반입은 제한됩니다',
  '분실물은 매장으로 문의해 주세요',
];

// ── 편의시설 키 (앱 ClubFacility enum 과 같은 6종) ──
const FACILITIES = ['card', 'locker', 'nonSmoking', 'parking', 'tableReserve', 'powerBank'];

// ── 서비스 음료 ──
const DRINK_KINDS = ['양주', '샴페인', '칵테일', '맥주', '와인'];
const DRINK_COMMENTS = [
  '1인 웰컴 드링크 1잔 무료',
  '테이블당 맥주 6병 제공',
  '입장 시 칵테일 1잔 서비스',
  '여성 고객 웰컴 샴페인 제공',
  '2인 이상 방문 시 음료 2잔 무료',
];

// ── 무료입장 정책 ──
// ⚠ 창(window)은 반드시 영업시간(목·금·토 22:00~05/06:00) 안에 둔다 —
//    밖에 두면 '지금 무료'가 영영 안 뜬다 (CLAUDE.md freeEntry 항목).
const ALWAYS_CONDITIONS = [
  '여성 무료입장', '게스트리스트 등록 시 무료', '첫 방문 인증 시 무료',
  '학생증 지참 시 무료', '얼리 입장객 무료',
];
const TIMED_WINDOWS = [
  { days: ['thu', 'fri', 'sat'], start: '22:00', end: '23:30', label: '오픈런', condition: '오픈런 23:30 이전 입장 무료' },
  { days: ['fri', 'sat'], start: '03:00', end: '05:00', label: '새벽', condition: '금·토 새벽 3시 이후 무료' },
  { days: ['thu'], start: '22:00', end: '01:00', label: '목요일', condition: '목요일 자정 이전 입장 무료' },
  { days: [], start: '23:00', end: '00:30', label: '자정 전', condition: '자정 이전 입장 무료' },
  { days: ['sat'], start: '22:00', end: '00:00', label: '토요일', condition: '토요일 자정 이전 여성 무료' },
];

// ── geohash 인코딩 (base32, precision 9) ──
const B32 = '0123456789bcdefghjkmnpqrstuvwxyz';
function geohashEncode(lat, lng, precision = 9) {
  let idx = 0, bit = 0, evenBit = true, hash = '';
  let latMin = -90, latMax = 90, lngMin = -180, lngMax = 180;
  while (hash.length < precision) {
    if (evenBit) {
      const mid = (lngMin + lngMax) / 2;
      if (lng >= mid) { idx = idx * 2 + 1; lngMin = mid; } else { idx = idx * 2; lngMax = mid; }
    } else {
      const mid = (latMin + latMax) / 2;
      if (lat >= mid) { idx = idx * 2 + 1; latMin = mid; } else { idx = idx * 2; latMax = mid; }
    }
    evenBit = !evenBit;
    if (++bit === 5) { hash += B32[idx]; bit = 0; idx = 0; }
  }
  return hash;
}

// ── HTTP helpers ──
function request(o, b) {
  return new Promise((res, rej) => {
    const r = https.request(o, (x) => { let d = ''; x.on('data', (c) => (d += c)); x.on('end', () => res({ status: x.statusCode, body: d })); });
    r.on('error', rej); if (b) r.write(b); r.end();
  });
}
const fsReq = (t, m, p, b) =>
  request({ hostname: 'firestore.googleapis.com', path: p, method: m, headers: { Authorization: `Bearer ${t}`, 'Content-Type': 'application/json', ...(b ? { 'Content-Length': Buffer.byteLength(b) } : {}) } }, b);
const ROOT = `/v1/projects/${PROJECT}/databases/(default)/documents`;

async function listDocs(t, coll) {
  const out = []; let pt = '';
  do {
    const r = await fsReq(t, 'GET', `${ROOT}/${coll}?pageSize=300${pt ? `&pageToken=${enc(pt)}` : ''}`);
    const j = JSON.parse(r.body);
    (j.documents || []).forEach((d) => out.push({ id: d.name.split('/').pop(), fields: d.fields }));
    pt = j.nextPageToken || '';
  } while (pt);
  return out;
}
async function createDoc(t, coll, fields, docId) {
  const path = docId ? `${ROOT}/${coll}/${docId}` : `${ROOT}/${coll}`;
  const r = await fsReq(t, docId ? 'PATCH' : 'POST', path, JSON.stringify({ fields }));
  if (r.status !== 200) throw new Error(`create ${coll}: ${r.status} ${r.body.slice(0, 140)}`);
  return JSON.parse(r.body);
}
async function deleteDoc(t, path) {
  const r = await fsReq(t, 'DELETE', `${ROOT}/${path}`);
  if (r.status !== 200) throw new Error(`delete ${path}: ${r.status}`);
}

// ── value helpers ──
const S = (v) => ({ stringValue: v });
const I = (v) => ({ integerValue: String(v) });
const D = (v) => ({ doubleValue: v });
const B = (v) => ({ booleanValue: v });
const TS = (v) => ({ timestampValue: v });
const M = (fields) => ({ mapValue: { fields } });
const arr = (vals) => ({ arrayValue: { values: vals } });
const strArr = (xs) => arr(xs.map(S));

function rand(min, max) { return Math.random() * (max - min) + min; }
function randInt(min, max) { return Math.floor(rand(min, max + 1)); }
function pick(a) { return a[Math.floor(Math.random() * a.length)]; }
function shuffle(a) { a = a.slice(); for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(Math.random() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; }

async function pool(ts, n, onDone) {
  let i = 0, ok = 0, f = 0;
  async function w() {
    while (i < ts.length) {
      const m = i++;
      try { await ts[m](); ok++; } catch (e) { f++; console.error('  ✗', String(e.message).slice(0, 160)); }
      if (onDone) onDone(ok + f, ts.length);
    }
  }
  await Promise.all(Array.from({ length: n }, w));
  return { ok, f };
}

// ── 기존 클럽에서 이미지 자산 수집 ──
function harvestAssets(clubs) {
  const thumbs = [], gallery = [], boardSets = [];
  for (const c of clubs) {
    const f = c.fields || {};
    const th = f.thumbnailUrl?.stringValue;
    if (th) thumbs.push(th);
    (f.imageUrls?.arrayValue?.values || []).forEach((v) => { if (v.stringValue) gallery.push(v.stringValue); });
    const boards = (f.menuBoardUrls?.arrayValue?.values || []).map((v) => v.stringValue).filter(Boolean);
    if (boards.length) boardSets.push(boards);
  }
  return { thumbs: [...new Set(thumbs)], gallery: [...new Set(gallery)], boardSets };
}

/// 무료입장 정책 하나. entryFeeMin 을 같이 정한다 —
/// always 는 0 이어야 하고, timed 는 무료가 끝났을 때 보여 줄 요금이 있어야 해서 0 이면 안 된다.
function freeEntryPlan() {
  const roll = Math.random();
  if (roll < 0.44) {
    const feeMin = 0;
    return { type: 'always', condition: pick(ALWAYS_CONDITIONS), windows: [], feeMin, feeMax: pick([0, 10000, 15000]) };
  }
  if (roll < 0.73) {
    const w = pick(TIMED_WINDOWS);
    const feeMin = pick([10000, 15000, 20000]);
    return { type: 'timed', condition: w.condition, windows: [w], feeMin, feeMax: feeMin + pick([5000, 10000]) };
  }
  const feeMin = pick([10000, 15000, 20000, 25000]);
  return { type: 'none', condition: '', windows: [], feeMin, feeMax: feeMin + pick([5000, 10000, 15000]) };
}

function freeEntryValue(p) {
  return M({
    type: S(p.type),
    condition: S(p.condition),
    windows: arr(p.windows.map((w) => M({
      days: strArr(w.days),
      start: S(w.start),
      end: S(w.end),
      label: S(w.label),
    }))),
  });
}

async function purge(t) {
  const all = await listDocs(t, 'clubs');
  const targets = all.filter((c) => c.fields?.genre?.stringValue === GENRE);
  console.log(`genre='${GENRE}' 클럽 ${targets.length}곳 발견.`);
  if (!targets.length) return;
  if (DRY) { targets.forEach((c) => console.log(`  - ${c.fields.name?.stringValue} (${c.id})`)); console.log('\n(dry run — 지우지 않음)'); return; }

  const subs = ['info', 'menus', 'reviews', 'photos'];
  const tasks = targets.map((c) => async () => {
    for (const s of subs) {
      const docs = await listDocs(t, `clubs/${c.id}/${s}`);
      for (const d of docs) await deleteDoc(t, `clubs/${c.id}/${s}/${d.id}`);
    }
    await deleteDoc(t, `clubs/${c.id}`);
  });
  const { ok, f } = await pool(tasks, CONC, (d, total) => { if (d % 10 === 0) console.log(`  ${d}/${total}`); });
  console.log(`\n삭제 완료 ${ok} 클럽, 실패 ${f}`);
}

async function run() {
  const t = execSync('gcloud auth print-access-token').toString().trim();

  if (PURGE) return purge(t);

  const allClubs = await listDocs(t, 'clubs');
  const existingKpop = allClubs.filter((c) => c.fields?.genre?.stringValue === GENRE);
  if (existingKpop.length && !FORCE && !DRY) {
    console.error(`중단: genre='${GENRE}' 클럽이 이미 ${existingKpop.length}곳 있다.`);
    console.error('  다시 만들려면 --purge 로 지운 뒤 실행하거나, 정말 더 만들 거면 --force.');
    process.exit(1);
  }

  const assets = harvestAssets(allClubs);
  console.log(`이미지 자산 수집: 썸네일 ${assets.thumbs.length}장 / 갤러리 ${assets.gallery.length}장 / 메뉴판 ${assets.boardSets.length}세트`);
  if (!assets.thumbs.length || !assets.gallery.length) throw new Error('이미지 자산이 없다 — 기존 클럽 문서 확인 필요');

  // 메뉴 템플릿 — 기존 클럽 3곳에서 가격·카테고리·이미지를 빌린다.
  const menuSources = shuffle(allClubs).slice(0, 3);
  let menuTemplates = [];
  for (const c of menuSources) {
    const menus = await listDocs(t, `clubs/${c.id}/menus`);
    menuTemplates = menuTemplates.concat(menus.map((m) => m.fields));
  }
  if (!menuTemplates.length) throw new Error('메뉴 템플릿이 없다');
  console.log(`메뉴 템플릿 ${menuTemplates.length}건 로드`);

  // 영업시간 — DB 의 모든 클럽이 목·금·토만 연다. 새 클럽도 같은 규칙을 따라야
  // 공연 seed·무료입장 창 판정이 어긋나지 않는다.
  const hoursSrc = allClubs.find((c) => c.fields?.operatingHours);
  if (!hoursSrc) throw new Error('operatingHours 템플릿이 없다');
  const operatingHours = hoursSrc.fields.operatingHours;

  // 이름 — 기존 클럽명과 겹치는 건 뺀다.
  const taken = new Set(allClubs.map((c) => c.fields?.name?.stringValue).filter(Boolean));
  const usable = NAMES.filter((n) => !taken.has(n));
  if (usable.length < COUNT) throw new Error(`이름 풀 부족: ${usable.length} < ${COUNT} (겹친 ${NAMES.length - usable.length}개 제외됨)`);
  const names = shuffle(usable).slice(0, COUNT);

  // 지역별 균등 배정 + 지역별 추천 균등 배정.
  const perArea = Math.floor(COUNT / REGIONS.length);
  const recPerArea = Math.floor(RECOMMENDED / REGIONS.length);
  const nowIso = new Date().toISOString();

  const plan = [];
  let nameIdx = 0;
  REGIONS.forEach((region, ri) => {
    // 나머지는 앞쪽 지역부터 하나씩 더 가져간다 (100/5 · 80/5 는 딱 떨어지지만 --count 대응).
    const n = perArea + (ri < COUNT % REGIONS.length ? 1 : 0);
    const rec = recPerArea + (ri < RECOMMENDED % REGIONS.length ? 1 : 0);
    // 추천 자리를 지역 안에서 무작위로 흩는다 (앞 n개가 전부 추천이면 목록이 티 난다).
    const recFlags = shuffle([...Array(n)].map((_, i) => i < rec));
    for (let k = 0; k < n; k++) {
      const fe = freeEntryPlan();
      const lat = +(region.lat + rand(-0.012, 0.012)).toFixed(6);
      const lng = +(region.lng + rand(-0.012, 0.012)).toFixed(6);
      plan.push({
        name: names[nameIdx++],
        handle: `${region.slug}_${String(k + 1).padStart(2, '0')}`,
        region,
        lat, lng,
        geohash: geohashEncode(lat, lng, 9),
        road: pick(region.roads),
        addrNo: randInt(1, 200),
        desc: pick(DESCRIPTIONS),
        fe,
        recommended: recFlags[k],
        nonSmoking: Math.random() < 0.3,
        drink: Math.random() < 0.35,
        menuCount: randInt(8, 14),
        reviewCount: randInt(4, 7),
        galleryCount: randInt(12, 20),
      });
    }
  });

  const byArea = {}, recByArea = {};
  plan.forEach((p) => {
    byArea[p.region.area] = (byArea[p.region.area] || 0) + 1;
    if (p.recommended) recByArea[p.region.area] = (recByArea[p.region.area] || 0) + 1;
  });
  const feCount = plan.reduce((a, p) => ({ ...a, [p.fe.type]: (a[p.fe.type] || 0) + 1 }), {});
  console.log(`\n생성 계획 ${plan.length}개 · genre='${GENRE}'`);
  console.log('  지역별   : ' + Object.entries(byArea).map(([a, n]) => `${a} ${n}`).join(' / '));
  console.log('  추천      : ' + Object.entries(recByArea).map(([a, n]) => `${a} ${n}`).join(' / ') + ` (합 ${plan.filter((p) => p.recommended).length})`);
  console.log('  무료입장  : ' + Object.entries(feCount).map(([k, n]) => `${k} ${n}`).join(' / '));
  console.log('  서비스음료: ' + plan.filter((p) => p.drink).length + ' / 금연 ' + plan.filter((p) => p.nonSmoking).length);

  if (DRY) {
    plan.forEach((p, i) => console.log(`  ${i + 1}. [${p.region.area}] ${p.name} — ${p.recommended ? '★추천' : '     '} fee ${p.fe.feeMin}~${p.fe.feeMax} / freeEntry ${p.fe.type}`));
    console.log('\n(dry run — 쓰지 않음)');
    return;
  }

  const tasks = plan.map((p) => async () => {
    // 이미지 — 클럽마다 다르게 뽑는다.
    const gallery = shuffle(assets.gallery).slice(0, p.galleryCount);
    const hero = gallery.slice(0, 5);
    const boards = pick(assets.boardSets);
    const thumb = pick(assets.thumbs);

    // 1) 클럽 문서 (auto id). 집계(rating/ratingSum/reviewCount)는 0 —
    //    아래에서 만드는 reviews 를 onReviewCreated 트리거가 누적한다.
    const created = await createDoc(t, 'clubs', {
      name: S(p.name),
      description: S(p.desc),
      address: S(`서울 ${p.region.gu} ${p.road} ${p.addrNo}`),
      area: S(p.region.area),
      phone: S(`02-${randInt(300, 999)}-${randInt(1000, 9999)}`),
      // 한글 이름을 그대로 넣으면 URL 이 깨지므로 지역 + 일련번호로 만든다(더미).
      instagramUrl: S(`https://instagram.com/kpop_${p.handle}`),
      genre: S(GENRE),
      location: M({ lat: D(p.lat), lng: D(p.lng), geohash: S(p.geohash) }),
      operatingHours,
      entryFeeMin: I(p.fe.feeMin),
      entryFeeMax: I(p.fe.feeMax),
      heroImageUrls: strArr(hero),
      imageUrls: strArr(gallery),
      menuBoardUrls: strArr(boards),
      thumbnailUrl: S(thumb),
      tags: strArr([...new Set(['K-POP', p.region.area, ...shuffle(TAG_POOL).slice(0, 2)])]),
      favoriteCount: I(0),
      rating: D(0),
      ratingSum: D(0),
      reviewCount: I(0),
      isActive: B(true),
      isVybeRecommended: B(p.recommended),
      isNonSmoking: B(p.nonSmoking),
      serviceDrink: M({
        isOffered: B(p.drink),
        comment: S(p.drink ? pick(DRINK_COMMENTS) : ''),
        drinks: strArr(p.drink ? shuffle(DRINK_KINDS).slice(0, randInt(1, 3)) : []),
      }),
      freeEntry: freeEntryValue(p.fe),
      // ⚠ isFreeEntry 는 파생값인데 트리거가 없다 — freeEntry 를 쓰는 쪽이 같이 써야 한다.
      isFreeEntry: B(p.fe.type !== 'none'),
      createdAt: TS(nowIso),
      updatedAt: TS(nowIso),
    });
    const id = created.name.split('/').pop();

    // 2) info — 지역별 지하철 + 랜덤 편의시설.
    const facilities = ['card', ...shuffle(FACILITIES.slice(1)).slice(0, randInt(2, 4))];
    await createDoc(t, `clubs/${id}/info`, {
      nearbySubways: arr(p.region.subways.map((s) => M({
        stationName: S(s.station),
        distanceM: I(s.distanceM + randInt(-60, 120)),
        lines: strArr(s.lines),
      }))),
      openChatUrl: S(''),
      cautions: strArr(shuffle(CAUTIONS).slice(0, randInt(3, 5))),
      facilities: strArr(p.nonSmoking ? [...new Set([...facilities, 'nonSmoking'])] : facilities.filter((f) => f !== 'nonSmoking')),
      updatedAt: TS(nowIso),
    }, id);

    // 3) menus — 이름은 K-POP 풀에서, 가격·카테고리·이미지는 기존 클럽에서 빌린다.
    const menuNames = shuffle(MENU_NAMES).slice(0, p.menuCount);
    const srcMenus = shuffle(menuTemplates).slice(0, p.menuCount);
    for (let m = 0; m < p.menuCount; m++) {
      const src = srcMenus[m];
      await createDoc(t, `clubs/${id}/menus`, {
        ...src,
        clubId: S(id),
        name: S(menuNames[m]),
        isFeatured: B(m < 2),
        isAvailable: B(true),
      });
    }

    // 4) reviews — 생성 시 onReviewCreated 가 클럽 집계를 채운다.
    const reviewTexts = shuffle(REVIEW_TEXTS).slice(0, p.reviewCount);
    const reviewNames = shuffle(NICKNAMES).slice(0, p.reviewCount);
    for (let r = 0; r < p.reviewCount; r++) {
      await createDoc(t, `clubs/${id}/reviews`, {
        clubId: S(id),
        userId: S('seed'),
        userName: S(reviewNames[r]),
        rating: I(randInt(4, 5)),
        content: S(reviewTexts[r]),
        imageUrls: arr([]),
        tags: arr([]),
        // ⚠ 목록 쿼리가 where isHidden==false 라 빠뜨리면 리뷰가 조용히 안 보인다.
        isHidden: B(false),
        createdAt: TS(new Date(Date.now() - r * 86400000).toISOString()),
        updatedAt: TS(nowIso),
      });
    }

    // 5) photos — 이 클럽 갤러리에서 round-robin 카테고리.
    if (!NO_PHOTOS) {
      const cats = ['venue', 'food', 'inside'];
      const urls = gallery.slice(0, 12);
      for (let pi = 0; pi < urls.length; pi++) {
        await createDoc(t, `clubs/${id}/photos`, {
          clubId: S(id),
          userId: S('seed'),
          url: S(urls[pi]),
          category: S(cats[pi % cats.length]),
          isHidden: B(false),
          createdAt: TS(new Date(Date.now() - pi * 3600000).toISOString()),
        });
      }
    }
  });

  let last = -1;
  const { ok, f } = await pool(tasks, CONC, (d, total) => {
    const pct = Math.floor((d / total) * 100);
    if (pct !== last && pct % 10 === 0) { last = pct; console.log(`  ${pct}% (${d}/${total} 클럽)`); }
  });
  console.log(`\n완료! 생성 ${ok} 클럽, 실패 ${f}`);
  console.log('※ rating/ratingSum/reviewCount 는 onReviewCreated 트리거가 수 초 내 비동기로 채운다.');
  console.log('※ Algolia Extension 이 clubs 쓰기를 받아 자동 색인한다 (검색 반영까지 1~2분).');
}

run().catch((e) => { console.error(e); process.exit(1); });
