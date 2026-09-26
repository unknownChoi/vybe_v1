"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateUserProfile = void 0;
const v1_1 = require("firebase-functions/v1");
const admin = require("firebase-admin");
const nickname_1 = require("./nickname");
/**
 * 닉네임 · 프로필 사진 저장.
 *
 * 입력
 * - `{ nickname?, profileImageUrl? }`
 * - **둘 다 없음** = 가입 직후 랜덤 닉네임 배정
 * - `profileImageUrl: ''` = 기본 아바타로 되돌리기
 * - `nickname` 이 없고 사진만 오면 기존 닉네임을 그대로 둔다
 *   (닉네임이 아예 없는 계정이면 이때 배정한다)
 *
 * 출력 `{ nickname, profileImageUrl }` — 서버가 확정한 값. 랜덤 배정 결과를
 * 앱이 화면에 바로 반영할 수 있게 돌려준다.
 *
 * ⚠ 닉네임 유일성을 클라에 맡길 수 없다 — Rules 로 `nicknames/{key}` 에
 * create 만 열어도 "예약과 `users.nickname` 이 맞는지"는 검사할 수 없다
 * (트랜잭션 안의 get 은 같은 커밋의 다른 쓰기를 못 본다). 그래서 예약만 하고
 * 문서는 안 바꾸는 **선점**도, 예약 없이 문서만 바꾸는 **우회**도 못 막는다.
 * 두 쓰기를 한 트랜잭션에 묶을 수 있는 건 서버뿐이다.
 *
 * ⚠ 사진도 이 함수가 쓴다 — 닉네임과 따로 쓰면 한쪽만 저장되는 상태가 생기고
 * "사진만 바꿨을 때만 나는 버그"가 만들어진다. 저장 경로는 하나다.
 */
exports.updateUserProfile = v1_1.https.onCall(async (data, context) => {
    var _a;
    const uid = (_a = context.auth) === null || _a === void 0 ? void 0 : _a.uid;
    if (!uid) {
        throw new v1_1.https.HttpsError("unauthenticated", "로그인이 필요합니다.");
    }
    const rawNickname = typeof (data === null || data === void 0 ? void 0 : data.nickname) === "string" ? data.nickname : null;
    const rawPhotoUrl = typeof (data === null || data === void 0 ? void 0 : data.profileImageUrl) === "string"
        ? data.profileImageUrl
        : null;
    // 넘어온 URL 이 내 Storage 경로를 가리키는지 **서버가** 본다.
    // Rules 정규식으로 하면 퍼센트 인코딩 때문에 깨지기 쉽고, 깨지면 저장이
    // 조용히 403 이 된다.
    if (rawPhotoUrl && !isOwnProfileUrl(rawPhotoUrl, uid)) {
        throw new v1_1.https.HttpsError("invalid-argument", "프로필 사진을 저장할 수 없어요. 다시 골라 주세요.", { field: "photo" });
    }
    // 형식·금칙어는 저장 시도 전에 — 트랜잭션을 헛돌리지 않는다.
    const requested = rawNickname === null ? null : (0, nickname_1.validateNickname)(rawNickname);
    // 요청한 닉네임이 있으면 한 번, 랜덤 배정이면 충돌할 때마다 다시 뽑는다.
    for (let attempt = 0; attempt < nickname_1.MAX_RANDOM_TRIES; attempt++) {
        const candidate = requested !== null && requested !== void 0 ? requested : (0, nickname_1.randomNickname)();
        try {
            return await commit(uid, candidate, rawPhotoUrl, requested === null);
        }
        catch (e) {
            const conflict = e instanceof v1_1.https.HttpsError && e.code === "already-exists";
            // 사용자가 고른 닉네임이 겹친 건 그대로 알려야 한다 — 다시 뽑으면
            // 엉뚱한 닉네임이 저장된다. 다시 뽑는 건 랜덤 배정일 때만.
            if (!conflict || requested !== null)
                throw e;
            v1_1.logger.info(`updateUserProfile: 랜덤 닉네임 충돌 재시도 uid=${uid}`);
        }
    }
    throw new v1_1.https.HttpsError("already-exists", "닉네임 배정에 실패했어요. 다시 시도해 주세요.");
});
/**
 * 예약(`nicknames/{key}`)과 유저 문서를 **트랜잭션 1회**로 같이 쓴다.
 *
 * [keepExisting] 이면 이미 닉네임이 있는 계정은 그대로 둔다 — 사진만 바꾸는
 * 저장이 닉네임을 갈아 끼우면 안 된다.
 */
async function commit(uid, candidate, photoUrl, keepExisting) {
    const db = admin.firestore();
    const userRef = db.collection("users").doc(uid);
    return db.runTransaction(async (tx) => {
        var _a, _b;
        // ── 읽기 먼저 (Firestore 트랜잭션 제약) ──
        const userSnap = await tx.get(userRef);
        if (!userSnap.exists) {
            // 가입이 끝나기 전(setUserProfile 이전)에 불린 것.
            throw new v1_1.https.HttpsError("failed-precondition", "프로필 정보가 아직 저장되지 않았어요.");
        }
        const user = (_a = userSnap.data()) !== null && _a !== void 0 ? _a : {};
        const oldNickname = typeof user.nickname === "string" ? user.nickname : "";
        // 사진만 바꾸는 저장 — 닉네임이 이미 있으면 손대지 않는다.
        const nickname = keepExisting && oldNickname ? oldNickname : candidate;
        const newKey = (0, nickname_1.nicknameKey)(nickname);
        const oldKey = oldNickname ? (0, nickname_1.nicknameKey)(oldNickname) : "";
        const reserveRef = db.collection("nicknames").doc(newKey);
        const reserveSnap = await tx.get(reserveRef);
        if (reserveSnap.exists && ((_b = reserveSnap.data()) === null || _b === void 0 ? void 0 : _b.uid) !== uid) {
            throw new v1_1.https.HttpsError("already-exists", "이미 사용 중인 닉네임이에요.");
        }
        // ── 쓰기 ──
        // 이미 내 것이면 예약을 다시 만들지 않는다(대소문자만 바꾼 경우).
        // 예약이 없으면 만든다 — 닉네임은 있는데 예약이 없는 계정(배정 도중
        // 실패했거나 예약 도입 전 문서)도 이 저장으로 정상 상태가 된다.
        if (!reserveSnap.exists)
            tx.set(reserveRef, { uid });
        // ⚠ `oldKey !== newKey` 가드가 없으면 대소문자만 바꿨을 때
        // **방금 확보한 예약을 지운다**(vybe → VYBE 는 key 가 같다).
        if (oldKey && oldKey !== newKey) {
            tx.delete(db.collection("nicknames").doc(oldKey));
        }
        const update = {
            nickname,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        // 사진은 **보내온 경우에만** 건드린다. 빈 문자열은 '기본 아바타로'라는
        // 명시적 요청이라 그대로 쓴다.
        if (photoUrl !== null)
            update.profileImageUrl = photoUrl;
        tx.update(userRef, update);
        return {
            nickname,
            profileImageUrl: photoUrl !== null
                ? photoUrl
                : typeof user.profileImageUrl === "string"
                    ? user.profileImageUrl
                    : "",
        };
    });
}
/**
 * 다운로드 URL 이 `users/{uid}/` 아래의 내 파일인지.
 *
 * 버킷 이름까지 확인한다 — 경로만 보면 `/o/users%2F{uid}%2F…` 를 흉내 낸
 * 남의 호스트 URL 이 통과한다.
 */
function isOwnProfileUrl(url, uid) {
    let parsed;
    try {
        parsed = new URL(url);
    }
    catch (_a) {
        return false;
    }
    if (parsed.hostname !== "firebasestorage.googleapis.com")
        return false;
    const match = /^\/v0\/b\/([^/]+)\/o\/(.+)$/.exec(parsed.pathname);
    if (!match)
        return false;
    if (match[1] !== admin.storage().bucket().name)
        return false;
    let path;
    try {
        // pathname 은 %2F 를 그대로 들고 있다 — 여기서 한 번만 푼다.
        path = decodeURIComponent(match[2]);
    }
    catch (_b) {
        return false;
    }
    return path.startsWith(`users/${uid}/`) && !path.includes("..");
}
//# sourceMappingURL=update_user_profile.js.map