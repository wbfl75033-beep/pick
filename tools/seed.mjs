// tools/data.json -> db/seed.sql (초기 이관 데이터)
import fs from 'node:fs';
const d = JSON.parse(fs.readFileSync('tools/data.json', 'utf8'));

const q = v => (v === undefined || v === null || v === '') ? 'null' : `'${String(v).replace(/'/g, "''")}'`;
const arr = a => (!a || !a.length) ? `'{}'` : `array[${a.map(q).join(', ')}]`;
const b = v => v ? 'true' : 'false';

// "010-0000-0000 / mail@x.com" 형태 분리
function splitContact(raw) {
  const s = String(raw || '').trim();
  if (!s) return { phone: null, email: null };
  const parts = s.split('/').map(x => x.trim());
  const email = parts.find(x => x.includes('@')) || null;
  const phone = parts.find(x => !x.includes('@')) || null;
  return { phone, email };
}

const L = [];
L.push(`-- ============================================================
-- 강사 Pick — 초기 이관 데이터 (index.html 하드코딩 데이터 → DB)
-- 자동 생성: tools/seed.mjs  |  생성일: ${new Date().toISOString().slice(0,10)}
-- 실행 순서: schema.sql 실행 후 이 파일 실행
-- 주의: 두 번 실행하면 중복 입력됩니다. 재실행 전 아래 초기화 블록 사용.
-- ============================================================

-- [재실행용 초기화] 필요할 때만 주석 해제
-- truncate table public.instructor_videos, public.instructors,
--   public.posters, public.top_ads, public.banners restart identity cascade;
`);

// ---------- 강사 ----------
L.push(`\n-- ------------------------------------------------------------
-- 강사 ${d.instructors.length}명
-- ------------------------------------------------------------`);
L.push(`insert into public.instructors
  (id, name, type, title, intro, profile, categories, phone_public, phone_private, email,
   photo_url, profile_file_url, sort_order, is_pinned, is_visible)
values`);
const instRows = d.instructors.map((i, idx) => {
  const c = splitContact(i.phone);
  return `  (${i.id}, ${q(i.name)}, ${q(i.type || '추천')}, ${q(i.title)}, ${q(i.intro)}, ${q(i.profile)},
   ${arr(i.categories)}, ${q(c.phone)}, null, ${q(c.email)},
   ${q(i.photo)}, ${q(i.profileFile)}, ${idx + 1}, false, true)`;
});
L.push(instRows.join(',\n') + ';');
L.push(`select setval(pg_get_serial_sequence('public.instructors','id'), (select max(id) from public.instructors));`);

// ---------- 강사 영상 ----------
const vRows = [];
d.instructors.forEach(i => {
  (i.videos || []).forEach((v, k) => {
    if (!v || !v.url) return;
    vRows.push(`  (${i.id}, ${q(v.url)}, ${q(v.title)}, ${q(v.thumbnail)}, ${k + 1})`);
  });
});
L.push(`\n-- ------------------------------------------------------------
-- 강사 영상 ${vRows.length}편
-- ------------------------------------------------------------`);
L.push(`insert into public.instructor_videos (instructor_id, url, title, thumbnail_url, sort_order)\nvalues`);
L.push(vRows.join(',\n') + ';');

// ---------- 공고 ----------
L.push(`\n-- ------------------------------------------------------------
-- 공개강좌 공고 ${d.posters.length}건
-- ------------------------------------------------------------`);
L.push(`insert into public.posters
  (id, ptype, title, image_url, event_date, location, topic, description,
   link, apply_link, map_image_url, map_url, route,
   zoom_link, zoom_id, zoom_pw, zoom_note, sort_order, is_visible)
values`);
L.push(d.posters.map((p, idx) =>
`  (${p.id}, ${q(p.ptype || 'offline')}, ${q(p.title)}, ${q(p.image)}, ${q(p.date)}, ${q(p.location)}, ${q(p.topic)}, ${q(p.description)},
   ${q(p.link)}, ${q(p.applyLink)}, ${q(p.mapImage)}, ${q(p.mapUrl)}, ${q(p.route)},
   ${q(p.zoomLink)}, ${q(p.zoomId)}, ${q(p.zoomPw)}, ${q(p.zoomNote)}, ${idx + 1}, true)`
).join(',\n') + ';');
L.push(`select setval(pg_get_serial_sequence('public.posters','id'), (select max(id) from public.posters));`);

// ---------- 상단 광고 ----------
L.push(`\n-- ------------------------------------------------------------
-- 상단 광고 ${d.topAds.length}개
-- ------------------------------------------------------------`);
L.push(`insert into public.top_ads (slot, image_url, image_mobile_url, bg, link, is_visible)\nvalues`);
L.push(d.topAds.map((a, i) =>
`  (${i + 1}, ${q(a.image)}, ${q(a.imageMobile)}, ${q(a.bg)}, ${q(a.link)}, true)`
).join(',\n') + ';');

// ---------- 메인 배너 ----------
L.push(`\n-- ------------------------------------------------------------
-- 메인 배너 ${d.banners.length}개
-- ------------------------------------------------------------`);
L.push(`insert into public.banners
  (slot, image_url, image_mobile_url, video_url, video_mobile_url,
   line1, line2, sub1, sub2, btn_text, link, is_visible)
values`);
L.push(d.banners.map((x, i) =>
`  (${i + 1}, ${q(x.image)}, ${q(x.imageMobile)}, ${q(x.video)}, ${q(x.videoMobile)},
   ${q(x.line1)}, ${q(x.line2)}, ${q(x.sub1)}, ${q(x.sub2)}, ${q(x.btnText)}, ${q(x.link)}, true)`
).join(',\n') + ';');

L.push(`\n-- ============================================================
-- 확인용 조회
-- ============================================================
-- select count(*) as 강사 from public.instructors;          -- ${d.instructors.length}
-- select count(*) as 영상 from public.instructor_videos;    -- ${vRows.length}
-- select count(*) as 공고 from public.posters;              -- ${d.posters.length}
-- select count(*) as 광고 from public.top_ads;              -- ${d.topAds.length}
-- select count(*) as 배너 from public.banners;              -- ${d.banners.length}
`);

fs.writeFileSync('db/seed.sql', L.join('\n'));
console.log('db/seed.sql 생성 완료 — 강사', d.instructors.length, '/ 영상', vRows.length, '/ 공고', d.posters.length);
