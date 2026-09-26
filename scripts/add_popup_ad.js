// popupAds/{popupId} 팝업 광고 1건 추가 — 로컬 이미지 업로드 + Firestore 문서 생성.
//
// 실서비스 등록 경로는 어드민 페이지(별도 구축) — 이 스크립트는 팝업을 손으로
// 하나 얹어 보기 위한 도구다. `add_banner.js` 와 같은 구조.
//
// 하는 일 2가지:
//   1) Storage `popupAds/{popupId}/image.{ext}` 에 업로드 (다운로드 토큰 포함 URL 생성)
//   2) popupAds/{popupId} 문서 생성
//
// 멱등성: popupId 를 지정하면 재실행 시 같은 문서를 덮어쓴다(createdAt 은 보존).
//
// ⚠ 이미지는 **정사각 1:1** 이다 (배너 1.71:1 과 다르다). 권장 원본 1080 x 1080.
//   앱이 cover 로 그리므로 정사각이 아니면 가운데만 남고 잘린다.
//
// 실행: gcloud 로그인 상태에서
//   node scripts/add_popup_ad.js --file=~/Downloads/ad.png --notice=notice_ad_free_entry
//   옵션:
//     --id=popup_ad_1        문서 ID (기본: popup_<파일명>)
//     --notice=<noticeId>    사진을 탭하면 갈 공지. 없으면 linkType='none'
//     --alt="설명"           스크린리더용 사진 설명
//     --primary              isPrimary=true (order 와 무관하게 맨 앞)
//     --order=0              같은 순위 안에서의 정렬 (기본: 기존 최소 order - 1)
//     --days=30              노출 기간 (기본 30일)
//     --inactive             isActive=false 로 생성
//     --dry                  쓰지 않고 결과만 출력

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const https = require('https');
const crypto = require('crypto');

const PROJECT = 'vybe-bata-c07aa';
const BUCKET = 'vybe-bata-c07aa.firebasestorage.app';
const FS_BASE = `/v1/projects/${PROJECT}/databases/(default)/documents`;

function arg(name, fallback) {
  const hit = process.argv.find(a => a.startsWith(`--${name}=`));
  return hit ? hit.slice(name.length + 3) : fallback;
}
const DRY = process.argv.includes('--dry');
const INACTIVE = process.argv.includes('--inactive');
const PRIMARY = process.argv.includes('--primary');

// ─────────────────────────────────────────── HTTP

function request(options, body) {
  return new Promise((resolve, reject) => {
    const req = https.request(options, res => {
      let data = '';
      res.on('data', chunk => (data += chunk));
      res.on('end', () => resolve({ status: res.statusCode, body: data }));
    });
    req.on('error', reject);
    if (body) req.write(body);
    req.end();
  });
}

// 확장자가 아니라 **실제 매직 바이트**로 판정한다 — .png 로 저장된 JPEG 가 흔한데
// contentType 이 틀리면 브라우저·앱이 렌더를 거부할 수 있다.
function sniffImage(buf) {
  if (buf[0] === 0xff && buf[1] === 0xd8) return { ext: '.jpg', type: 'image/jpeg' };
  if (buf.slice(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])))
    return { ext: '.png', type: 'image/png' };
  if (buf.slice(0, 4).toString() === 'RIFF' && buf.slice(8, 12).toString() === 'WEBP')
    return { ext: '.webp', type: 'image/webp' };
  return null;
}

// PNG·JPEG 는 헤더만 읽어 크기를 알 수 있다 — 정사각이 아닌 이미지를 조용히
// 올리면 앱에서 가운데만 남고 잘린다. 경고만 하고 막지는 않는다(의도일 수 있다).
function imageSize(buf, type) {
  if (type === 'image/png') {
    return { w: buf.readUInt32BE(16), h: buf.readUInt32BE(20) };
  }
  if (type === 'image/jpeg') {
    let i = 2;
    while (i < buf.length) {
      if (buf[i] !== 0xff) { i++; continue; }
      const marker = buf[i + 1];
      // SOF0~SOF3, SOF5~SOF7, SOF9~SOF11, SOF13~SOF15
      if (marker >= 0xc0 && marker <= 0xcf &&
          ![0xc4, 0xc8, 0xcc].includes(marker)) {
        return { h: buf.readUInt16BE(i + 5), w: buf.readUInt16BE(i + 7) };
      }
      i += 2 + buf.readUInt16BE(i + 2);
    }
  }
  return null;
}

async function uploadToStorage(token, fileData, destination, contentType, downloadToken) {
  const metadata = JSON.stringify({
    name: destination,
    contentType,
    metadata: { firebaseStorageDownloadTokens: downloadToken },
  });

  const boundary = '-------314159265358979323846';
  const delim = `\r\n--${boundary}\r\n`;
  const closeDelim = `\r\n--${boundary}--`;

  const body = Buffer.concat([
    Buffer.from(
      `--${boundary}\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n${metadata}${delim}Content-Type: ${contentType}\r\n\r\n`
    ),
    fileData,
    Buffer.from(closeDelim),
  ]);

  const res = await request(
    {
      hostname: 'storage.googleapis.com',
      path: `/upload/storage/v1/b/${encodeURIComponent(BUCKET)}/o?uploadType=multipart&name=${encodeURIComponent(destination)}`,
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': `multipart/related; boundary="${boundary}"`,
        'Content-Length': body.length,
      },
    },
    body
  );

  if (res.status !== 200) throw new Error(`Storage upload failed: ${res.status} ${res.body}`);
}

async function listPopupAds(token) {
  const res = await request({
    hostname: 'firestore.googleapis.com',
    path: `${FS_BASE}/popupAds?pageSize=300`,
    method: 'GET',
    headers: { Authorization: `Bearer ${token}` },
  });
  // 컬렉션이 아직 없으면 200 + 빈 응답이다.
  if (res.status !== 200) throw new Error(`popupAds 조회 실패: ${res.status} ${res.body}`);
  return JSON.parse(res.body).documents || [];
}

async function writePopupAd(token, popupId, fields, exists) {
  // createdAt 은 updateMask 에서 빼 최초 생성 시각을 보존한다(재실행 시 덮지 않음).
  const paths = Object.keys(fields).filter(k => !(exists && k === 'createdAt'));
  const query = paths.map(p => `updateMask.fieldPaths=${p}`).join('&');
  const body = JSON.stringify({ fields });
  const res = await request(
    {
      hostname: 'firestore.googleapis.com',
      path: `${FS_BASE}/popupAds/${popupId}?${query}`,
      method: 'PATCH',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(body),
      },
    },
    body
  );
  if (res.status !== 200) throw new Error(`Firestore 쓰기 실패: ${res.status} ${res.body}`);
}

// ─────────────────────────────────────────── main

async function run() {
  let file = arg('file');
  if (!file) throw new Error('--file=<이미지 경로> 필요');
  if (file.startsWith('~')) file = path.join(process.env.HOME, file.slice(1));
  if (!fs.existsSync(file)) throw new Error(`파일 없음: ${file}`);

  const fileData = fs.readFileSync(file);
  const sniff = sniffImage(fileData);
  if (!sniff) throw new Error('이미지가 아니거나 지원하지 않는 포맷 (jpeg/png/webp)');

  const popupId = arg('id', `popup_${path.basename(file, path.extname(file))}`);
  const noticeId = arg('notice', '');
  const linkType = noticeId ? 'notice' : 'none';
  const altText = arg('alt', '');
  const days = Number(arg('days', '30'));
  if (!Number.isInteger(days) || days <= 0) throw new Error('--days 는 양의 정수');

  const token = execSync('gcloud auth print-access-token').toString().trim();

  const existing = await listPopupAds(token);
  const orders = existing.map(d => Number(d.fields?.order?.integerValue ?? 0));
  const exists = existing.some(d => d.name.endsWith(`/popupAds/${popupId}`));

  // 기본값 = 기존 최소 order - 1. 다른 문서를 손대지 않고 맨 앞에 꽂는다.
  const minOrder = orders.length ? Math.min(...orders) : 1;
  const order = Number(arg('order', String(minOrder - 1)));
  if (!Number.isInteger(order)) throw new Error('--order 는 정수');

  const destination = `popupAds/${popupId}/image${sniff.ext}`;
  const downloadToken = crypto.randomUUID();
  const imageUrl =
    `https://firebasestorage.googleapis.com/v0/b/${BUCKET}/o/` +
    `${encodeURIComponent(destination)}?alt=media&token=${downloadToken}`;

  const now = new Date();
  const endAt = new Date(now.getTime() + days * 24 * 60 * 60 * 1000);

  const fields = {
    popupId: { stringValue: popupId },
    imageUrl: { stringValue: imageUrl },
    altText: { stringValue: altText },
    linkType: { stringValue: linkType },
    linkValue: { stringValue: noticeId },
    isPrimary: { booleanValue: PRIMARY },
    order: { integerValue: String(order) },
    isActive: { booleanValue: !INACTIVE },
    startAt: { timestampValue: now.toISOString() },
    endAt: { timestampValue: endAt.toISOString() },
    createdAt: { timestampValue: now.toISOString() },
    updatedAt: { timestampValue: now.toISOString() },
  };

  const size = imageSize(fileData, sniff.type);
  console.log(`파일      : ${file} (${sniff.type}, ${(fileData.length / 1024).toFixed(0)}KB)`);
  if (size) {
    const square = size.w === size.h ? '정사각 ✓' : '⚠ 정사각이 아님 — 앱에서 가운데만 남고 잘린다';
    console.log(`크기      : ${size.w} x ${size.h}  ${square}`);
  }
  console.log(`popupId   : ${popupId}${exists ? ' (덮어쓰기)' : ' (신규)'}`);
  console.log(`Storage   : ${destination}`);
  console.log(`isPrimary : ${PRIMARY}`);
  console.log(`order     : ${order}   (기존: ${orders.sort((a, b) => a - b).join(', ') || '없음'})`);
  console.log(`link      : ${linkType}${noticeId ? `:${noticeId}` : ' (연결 없음 — 탭해도 이동 안 함)'}`);
  console.log(`노출 기간 : ${now.toISOString().slice(0, 10)} ~ ${endAt.toISOString().slice(0, 10)} (${days}일)`);
  console.log(`isActive  : ${!INACTIVE}`);

  if (DRY) {
    console.log('\n--dry 라 아무것도 쓰지 않음');
    return;
  }

  await uploadToStorage(token, fileData, destination, sniff.type, downloadToken);
  console.log('\n✓ Storage 업로드');

  await writePopupAd(token, popupId, fields, exists);
  console.log('✓ Firestore popupAds 문서 저장');
  console.log(`\n${imageUrl}`);
}

run().catch(err => {
  console.error(`✗ ${err.message}`);
  process.exit(1);
});
