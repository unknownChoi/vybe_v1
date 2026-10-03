// performances/{performanceId} — **테스트 프로젝트 전용** UI 확인용 예시 공연 일정.
//
// 왜 필요한가: 테스트 프로젝트 vybe-bata-c07aa-test 에 performances 컬렉션이 비어 있어
//   힙합 · EDM · 오늘의 라인업 화면이 전부 "공연 0개" 빈 상태로만 보인다.
//   UI 작업 중 진행 중/예정/종료 상태를 눈으로 확인하려면 데이터가 있어야 한다.
//
// 운영 데이터가 아니라 **화면 확인용 샘플**이다. 규모를 일부러 작게 잡았다
//   (장르별 최대 8곳 · 오늘부터 14일 · 클럽당 밤 1~3팀).
//
// 안전장치
//   - PROJECT 가 '-test' 로 끝나지 않으면 즉시 종료한다(운영 프로젝트 오염 방지).
//   - 기본은 **쓰지 않는다**. 계획만 출력한다. 실제 쓰기는 --write 를 줘야 한다.
//
// 실행: gcloud 로그인 상태에서
//   node scripts/seed_performances_test.js            # 계획만 출력 (기본)
//   node scripts/seed_performances_test.js --write    # 실제 쓰기
//   node scripts/seed_performances_test.js --purge --write   # 기존 문서 삭제 후 쓰기
//
// 문서 1개 = (클럽 × 날짜 × 아티스트). performanceId = perf_<clubId>_<date>_<n>.
// 난수는 clubId·날짜 해시 기반 결정적 PRNG → 재실행해도 같은 결과(멱등, 잔여 doc 없음).
// 스키마는 CLAUDE.md `performances/{performanceId}` 와 같다.

const { execSync } = require('child_process');
const https = require('https');

const PROJECT = 'vybe-bata-c07aa-test';
const WRITE = process.argv.includes('--write');
const PURGE = process.argv.includes('--purge');

if (!PROJECT.endsWith('-test')) {
  console.error(`[중단] 이 스크립트는 테스트 프로젝트 전용이다. PROJECT=${PROJECT}`);
  process.exit(1);
}

const TARGET_GENRES = ['힙합', 'EDM'];
const DAYS = 14;                   // 오늘부터 14일
const MAX_CLUBS_PER_GENRE = 8;     // 장르별 최대 클럽 수 (샘플이라 작게)
const CLUB_NIGHT_RATIO = 0.6;      // 공연일마다 참여하는 클럽 비율
const MAX_ARTISTS_PER_NIGHT = 3;   // 클럽당 하루 1~3팀
const FEATURED_PER_DATE = 2;       // hero 캐러셀용 isFeatured 수/일

const DJS = [
  'GRIM', 'KODA', 'ECHO', 'FLASH', 'PEAK', 'HALO', 'DRIFT', 'PULSE',
  'SAGE', 'RIFT', 'AXIS', 'LUMEN', 'ORBIT', 'PRISM', 'VOLT', 'ZENON',
  'CIRRUS', 'NOCTIS', 'HELIX', 'QUARTZ', 'SABLE', 'TIDAL', 'UMBRA', 'VECTOR',
];
const RAPPERS = [
  'YANO', 'MOBB', 'KRYPT', 'JAEL', 'ODDY', 'SOUL K', 'BLNK', 'RIO',
  'TUNA', 'VERSE', 'NOEL', 'HWI', 'DAZE', 'MIRO', 'ONYX', 'PAVE',
];
const SLOTS = [[22, 0], [23, 30], [1, 0]];   // 밤 시작 시각 (01:00 은 다음 날 새벽)

// ── HTTP ────────────────────────────────────────────────────
function request(options, body) {
  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (c) => (data += c));
      res.on('end', () => resolve({ status: res.statusCode, body: data }));
    });
    req.on('error', reject);
    if (body) req.write(body);
    req.end();
  });
}

function fsReq(token, method, path, body) {
  return request(
    {
      hostname: 'firestore.googleapis.com',
      path,
      method,
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
        ...(body ? { 'Content-Length': Buffer.byteLength(body) } : {}),
      },
    },
    body
  );
}

// ── 결정적 난수 ──────────────────────────────────────────────
function hashSeed(str) {
  let h = 2166136261 >>> 0;
  for (let i = 0; i < str.length; i++) {
    h ^= str.charCodeAt(i);
    h = Math.imul(h, 16777619) >>> 0;
  }
  return h >>> 0;
}

function rngFrom(seedStr) {
  let a = hashSeed(seedStr);
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function shuffled(arr, rnd) {
  const a = arr.slice();
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(rnd() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

// ── 날짜 (KST) ──────────────────────────────────────────────
const DAY_KEYS = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];

function kstNow() {
  return new Date(Date.now() + 9 * 3600 * 1000);
}

function ymdOf(d) {
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, '0');
  const dd = String(d.getUTCDate()).padStart(2, '0');
  return `${y}${m}${dd}`;
}

function dates(fromDate, n) {
  const out = [];
  for (let i = 0; i < n; i++) {
    const d = new Date(fromDate.getTime() + i * 86400000);
    out.push({ ymd: ymdOf(d), dayKey: DAY_KEYS[d.getUTCDay()] });
  }
  return out;
}

// KST 벽시계 → UTC ISO. hour < 6 이면 다음 날 새벽으로 넘긴다.
function slotToIso(ymd, hour, min) {
  const y = +ymd.slice(0, 4), m = +ymd.slice(4, 6), d = +ymd.slice(6, 8);
  const base = Date.UTC(y, m - 1, d, hour, min) - 9 * 3600 * 1000;
  return new Date(base + (hour < 6 ? 86400000 : 0)).toISOString();
}

// ── Firestore ───────────────────────────────────────────────
async function listTargetClubs(token) {
  const clubs = [];
  let pageToken = '';
  do {
    const qs = `pageSize=300${pageToken ? `&pageToken=${encodeURIComponent(pageToken)}` : ''}`;
    const res = await fsReq(token, 'GET',
      `/v1/projects/${PROJECT}/databases/(default)/documents/clubs?${qs}`);
    if (res.status !== 200) throw new Error(`list clubs failed: ${res.status} ${res.body}`);
    const json = JSON.parse(res.body);
    for (const doc of json.documents || []) {
      const f = doc.fields || {};
      const genre = f.genre?.stringValue || '';
      if (!TARGET_GENRES.includes(genre)) continue;
      if (f.isActive?.booleanValue === false) continue;
      const ohFields = f.operatingHours?.mapValue?.fields || {};
      const openDays = new Set();
      for (const [k, v] of Object.entries(ohFields)) {
        if (v.mapValue?.fields?.isOpen?.booleanValue) openDays.add(k);
      }
      clubs.push({
        id: doc.name.split('/').pop(),
        name: f.name?.stringValue || '',
        area: f.area?.stringValue || '',
        genre,
        openDays,
      });
    }
    pageToken = json.nextPageToken || '';
  } while (pageToken);
  return clubs;
}

async function listPerformanceIds(token) {
  const ids = [];
  let pageToken = '';
  do {
    const qs = `pageSize=300&mask.fieldPaths=performanceId${pageToken ? `&pageToken=${encodeURIComponent(pageToken)}` : ''}`;
    const res = await fsReq(token, 'GET',
      `/v1/projects/${PROJECT}/databases/(default)/documents/performances?${qs}`);
    if (res.status !== 200) return ids;   // 컬렉션이 아예 없으면 빈 목록
    const json = JSON.parse(res.body);
    for (const doc of json.documents || []) ids.push(doc.name.split('/').pop());
    pageToken = json.nextPageToken || '';
  } while (pageToken);
  return ids;
}

async function deletePerformance(token, id) {
  const res = await fsReq(token, 'DELETE',
    `/v1/projects/${PROJECT}/databases/(default)/documents/performances/${id}`);
  if (res.status !== 200) throw new Error(`delete failed: ${res.status} ${res.body}`);
}

async function upsertPerformance(token, p) {
  const body = JSON.stringify({
    fields: {
      performanceId: { stringValue: p.id },
      clubId: { stringValue: p.clubId },
      clubName: { stringValue: p.clubName },
      clubArea: { stringValue: p.clubArea },
      genre: { stringValue: p.genre },
      artistName: { stringValue: p.artistName },
      artistType: { stringValue: p.artistType },
      startAt: { timestampValue: p.startAtIso },
      date: { stringValue: p.date },
      isFeatured: { booleanValue: p.isFeatured },
      isActive: { booleanValue: true },
      createdAt: { timestampValue: new Date().toISOString() },
    },
  });
  const res = await fsReq(token, 'PATCH',
    `/v1/projects/${PROJECT}/databases/(default)/documents/performances/${p.id}`, body);
  if (res.status !== 200) throw new Error(`upsert failed: ${res.status} ${res.body}`);
}

// ── 계획 ────────────────────────────────────────────────────
function buildPlan(clubs) {
  // 장르별 상한 — 결정적으로 고른다
  const picked = [];
  for (const g of TARGET_GENRES) {
    const pool = clubs.filter((c) => c.genre === g);
    picked.push(...shuffled(pool, rngFrom(`pick:${g}`)).slice(0, MAX_CLUBS_PER_GENRE));
  }

  const plan = [];
  for (const { ymd, dayKey } of dates(kstNow(), DAYS)) {
    // 그날 문 여는 클럽만 후보
    const openClubs = picked.filter((c) => c.openDays.has(dayKey));
    if (!openClubs.length) continue;

    const rndDay = rngFrom(`day:${ymd}`);
    const count = Math.max(1, Math.round(openClubs.length * CLUB_NIGHT_RATIO));
    const tonight = shuffled(openClubs, rndDay).slice(0, count);
    const featured = new Set(tonight.slice(0, FEATURED_PER_DATE).map((c) => c.id));

    const usedDj = new Set();
    const usedRap = new Set();
    for (const club of tonight) {
      const rnd = rngFrom(`set:${club.id}:${ymd}`);
      const teams = 1 + Math.floor(rnd() * MAX_ARTISTS_PER_NIGHT);
      for (let n = 0; n < teams; n++) {
        // 힙합은 dj + rapper 혼합(2팀 이상이면 양쪽 최소 1팀), EDM 은 dj 만
        let type = 'dj';
        if (club.genre === '힙합') {
          if (teams >= 2) type = n === 0 ? 'rapper' : (n === 1 ? 'dj' : (rnd() < 0.5 ? 'dj' : 'rapper'));
          else type = rnd() < 0.5 ? 'dj' : 'rapper';
        }
        const pool = type === 'dj' ? DJS : RAPPERS;
        const used = type === 'dj' ? usedDj : usedRap;
        const order = shuffled(pool, rngFrom(`art:${club.id}:${ymd}:${n}:${type}`));
        const name = order.find((a) => !used.has(a)) || order[0];
        used.add(name);

        const [h, mi] = SLOTS[n % SLOTS.length];
        plan.push({
          id: `perf_${club.id}_${ymd}_${n}`,
          clubId: club.id,
          clubName: club.name,
          clubArea: club.area,
          genre: club.genre,
          artistName: name,
          artistType: type,
          date: ymd,
          startAtIso: slotToIso(ymd, h, mi),
          startLabel: `${String(h).padStart(2, '0')}:${String(mi).padStart(2, '0')}`,
          isFeatured: featured.has(club.id) && n === 0,
        });
      }
    }
  }
  return { picked, plan };
}

// ── 실행 ────────────────────────────────────────────────────
async function run() {
  const token = execSync('gcloud auth print-access-token').toString().trim();
  const clubs = await listTargetClubs(token);
  console.log(`대상 프로젝트: ${PROJECT}`);
  console.log(`힙합·EDM 활성 클럽: ${clubs.length}곳`);

  const { picked, plan } = buildPlan(clubs);
  const byDate = {};
  for (const p of plan) (byDate[p.date] ||= []).push(p);

  console.log(`\n선정 클럽 ${picked.length}곳`);
  for (const c of picked) console.log(`  - ${c.genre.padEnd(4)} ${c.name} (${c.area}) 영업요일 ${[...c.openDays].join(',')}`);

  console.log(`\n공연일 ${Object.keys(byDate).length}일 · 문서 ${plan.length}개`);
  for (const d of Object.keys(byDate).sort()) {
    const rows = byDate[d];
    const feat = rows.filter((r) => r.isFeatured).length;
    console.log(`  ${d}  문서 ${String(rows.length).padStart(2)}개 · hero ${feat}`);
  }

  console.log('\n--- 샘플 문서 5개 ---');
  for (const p of plan.slice(0, 5)) {
    console.log(`  ${p.id}`);
    console.log(`    ${p.clubName} (${p.clubArea} · ${p.genre}) / ${p.artistName} [${p.artistType}] / ${p.date} ${p.startLabel} / isFeatured=${p.isFeatured}`);
  }

  if (!WRITE) {
    console.log('\n[계획만 출력했다 — 아무것도 쓰지 않았다]');
    console.log('실제로 넣으려면: node scripts/seed_performances_test.js --write');
    return;
  }

  if (PURGE) {
    const ids = await listPerformanceIds(token);
    console.log(`\n기존 문서 ${ids.length}개 삭제 중...`);
    for (const id of ids) await deletePerformance(token, id);
  }

  console.log(`\n${plan.length}개 쓰는 중...`);
  let n = 0;
  for (const p of plan) {
    await upsertPerformance(token, p);
    if (++n % 50 === 0) console.log(`  ${n}/${plan.length}`);
  }
  console.log(`완료 — ${PROJECT} performances ${plan.length}개`);
}

run().catch((e) => { console.error(e); process.exit(1); });
