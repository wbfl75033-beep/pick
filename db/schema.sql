-- ============================================================
-- FP파트너즈 강사 Pick — Supabase 스키마
-- 버전 v1.0 / 2026-08-19
-- 실행 방법: Supabase 대시보드 > SQL Editor 에 전체 붙여넣기 후 RUN
-- 주의: 프로젝트는 반드시 서울 리전(ap-northeast-2)으로 생성할 것
-- ============================================================


-- ============================================================
-- 1. 분야 (categories)
-- ============================================================
create table public.categories (
  id          bigserial primary key,
  name        text not null unique,
  sort_order  int not null default 0,
  is_active   boolean not null default true
);

insert into public.categories (name, sort_order) values
  ('FPShip', 1), ('메디컬화법', 2), ('약관&보상&고지의무', 3), ('실손보험', 4),
  ('종신&정기보험', 5), ('변액보험', 6), ('연금&저축성보험', 7), ('자동차&운전자보험', 8),
  ('배상책임&화재보험', 9), ('치아&어린이&치매보험', 10), ('세무설계', 11), ('초회상담(AP)', 12),
  ('상담프로세스', 13), ('상품영업전략', 14), ('DB영업', 15), ('AI세일즈', 16),
  ('법인영업', 17), ('매니저 육성', 18);


-- ============================================================
-- 2. 강사 (instructors)
--    phone_public  : 화면 노출용. 제휴강사는 본인 휴대폰, 추천강사는 대표번호
--    phone_private : 관리자 전용. 화면에 절대 노출되지 않음
-- ============================================================
create table public.instructors (
  id                bigserial primary key,
  name              text not null,
  type              text not null default '추천' check (type in ('추천', '제휴')),
  title             text,
  intro             text,
  profile           text,
  categories        text[] not null default '{}',
  phone_public      text,
  phone_private     text,
  email             text,
  photo_url         text,
  profile_file_url  text,
  sort_order        int not null default 0,
  is_pinned         boolean not null default false,
  is_visible        boolean not null default true,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index idx_instructors_order on public.instructors (is_pinned desc, sort_order asc, id asc);


-- ============================================================
-- 3. 강사 영상 (instructor_videos)
-- ============================================================
create table public.instructor_videos (
  id             bigserial primary key,
  instructor_id  bigint not null references public.instructors(id) on delete cascade,
  url            text not null,
  title          text,
  thumbnail_url  text,
  sort_order     int not null default 0
);

create index idx_videos_instructor on public.instructor_videos (instructor_id, sort_order);


-- ============================================================
-- 4. 공고 (posters)
-- ============================================================
create table public.posters (
  id             bigserial primary key,
  ptype          text not null default 'offline' check (ptype in ('offline', 'zoom')),
  title          text not null,
  image_url      text,
  event_date     text,
  location       text,
  topic          text,
  description    text,
  link           text,
  apply_link     text,
  map_image_url  text,
  map_url        text,
  route          text,
  sort_order     int not null default 0,
  is_visible     boolean not null default true,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

create index idx_posters_order on public.posters (sort_order asc, id desc);


-- ============================================================
-- 5. 상단 광고 (top_ads)
-- ============================================================
create table public.top_ads (
  id                bigserial primary key,
  slot              int not null default 1,
  image_url         text,
  image_mobile_url  text,
  bg                text,
  link              text,
  is_visible        boolean not null default true,
  updated_at        timestamptz not null default now()
);


-- ============================================================
-- 6. 메인 배너 (banners)
-- ============================================================
create table public.banners (
  id                bigserial primary key,
  slot              int not null default 1,
  image_url         text,
  image_mobile_url  text,
  video_url         text,
  video_mobile_url  text,
  line1             text,
  line2             text,
  sub1              text,
  sub2              text,
  btn_text          text,
  link              text,
  is_visible        boolean not null default true,
  updated_at        timestamptz not null default now()
);


-- ============================================================
-- 7. updated_at 자동 갱신
-- ============================================================
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

create trigger trg_instructors_touch before update on public.instructors
  for each row execute function public.touch_updated_at();
create trigger trg_posters_touch before update on public.posters
  for each row execute function public.touch_updated_at();
create trigger trg_top_ads_touch before update on public.top_ads
  for each row execute function public.touch_updated_at();
create trigger trg_banners_touch before update on public.banners
  for each row execute function public.touch_updated_at();


-- ============================================================
-- 8. RLS — 조회는 공개, 저장·수정·삭제는 로그인한 관리자만
-- ============================================================
alter table public.categories        enable row level security;
alter table public.instructors       enable row level security;
alter table public.instructor_videos enable row level security;
alter table public.posters           enable row level security;
alter table public.top_ads           enable row level security;
alter table public.banners           enable row level security;

-- 공개 조회 (instructors 는 제외 — 아래 뷰로만 공개)
create policy pub_read_categories on public.categories
  for select to anon, authenticated using (true);
create policy pub_read_videos on public.instructor_videos
  for select to anon, authenticated using (true);
create policy pub_read_posters on public.posters
  for select to anon, authenticated using (is_visible);
create policy pub_read_top_ads on public.top_ads
  for select to anon, authenticated using (is_visible);
create policy pub_read_banners on public.banners
  for select to anon, authenticated using (is_visible);

-- instructors 본체는 관리자만 직접 조회 가능 (phone_private 보호)
create policy adm_read_instructors on public.instructors
  for select to authenticated using (true);

-- 관리자 쓰기 권한
create policy adm_write_categories on public.categories
  for all to authenticated using (true) with check (true);
create policy adm_write_instructors on public.instructors
  for all to authenticated using (true) with check (true);
create policy adm_write_videos on public.instructor_videos
  for all to authenticated using (true) with check (true);
create policy adm_write_posters on public.posters
  for all to authenticated using (true) with check (true);
create policy adm_write_top_ads on public.top_ads
  for all to authenticated using (true) with check (true);
create policy adm_write_banners on public.banners
  for all to authenticated using (true) with check (true);


-- ============================================================
-- 9. 공개용 강사 뷰 — phone_private 를 물리적으로 제외
--    이용자 화면은 반드시 이 뷰를 조회할 것
-- ============================================================
create view public.instructors_public as
  select
    id, name, type, title, intro, profile, categories,
    phone_public, photo_url, profile_file_url,
    sort_order, is_pinned
  from public.instructors
  where is_visible = true;

grant select on public.instructors_public to anon, authenticated;


-- ============================================================
-- 10. Storage 버킷
--     대시보드 Storage 메뉴를 못 찾아도 됩니다 — 아래 SQL 이 버킷을 만듭니다.
--     폴더(instructors/ profiles/ posters/ maps/ banners/ ads/)는
--     파일을 올릴 때 자동으로 생성되므로 미리 만들 필요 없습니다.
-- ============================================================

-- 버킷 생성 (이미 있으면 그냥 넘어감)
insert into storage.buckets (id, name, public)
values ('pick-media', 'pick-media', true)
on conflict (id) do update set public = true;
create policy pub_read_media on storage.objects
  for select to anon, authenticated using (bucket_id = 'pick-media');

create policy adm_write_media on storage.objects
  for insert to authenticated with check (bucket_id = 'pick-media');

create policy adm_update_media on storage.objects
  for update to authenticated using (bucket_id = 'pick-media');

create policy adm_delete_media on storage.objects
  for delete to authenticated using (bucket_id = 'pick-media');


-- ============================================================
-- 끝. 관리자 계정은 Authentication > Users 에서 직접 생성할 것
-- (이메일 가입은 비활성화 권장 — 관리자 외 가입 차단)
-- ============================================================


-- ============================================================
-- 11. [보정] 원본 스키마 누락분 — 줌 강좌 접속 정보
--     index.html savePoster() 가 저장하는 zoomLink / zoomId / zoomPw / zoomNote
--     4개 항목에 대응하는 컬럼이 원본 스키마에 없어 추가함.
--     ※ 회사 확인 후 "줌 정보 기능 삭제"로 결정되면 이 블록만 지우면 됨.
-- ============================================================
alter table public.posters
  add column if not exists zoom_link text,
  add column if not exists zoom_id   text,
  add column if not exists zoom_pw   text,
  add column if not exists zoom_note text;

-- 공개 뷰가 아닌 posters 는 전체 공개 조회이므로 줌 비밀번호가 그대로 노출됨.
-- 접속 정보를 신청자에게만 공개하려면 아래 공개 뷰로 교체할 것 (기본은 비활성).
-- create view public.posters_public as
--   select id, ptype, title, image_url, event_date, location, topic, description,
--          link, apply_link, map_image_url, map_url, route, sort_order
--   from public.posters where is_visible = true;
-- grant select on public.posters_public to anon, authenticated;


-- ============================================================
-- 12. [추가/수정] 메인 배너 오른쪽 보조문구 순환 세트 (배너별 3개)
--     처음엔 배너 전체가 공유하는 3개 세트로 만들었다가, "배너 1·배너 2가
--     각자 자기만의 3개 문구를 갖고, 그 배너가 나올 때마다 자기 세트
--     안에서 순서대로 반복"하는 것으로 정정. slot(배너 순서)별로 3개씩
--     묶어서 저장. 예전에 아래 create table 버전을 이미 실행했다면
--     이 블록으로 다시 실행해서 교체할 것 (drop 후 재생성).
-- ============================================================
drop table if exists public.banner_subtexts cascade;

create table public.banner_subtexts (
  id             bigserial primary key,
  slot           int not null,        -- 배너 순서(1,2,3...)와 매칭
  variant_order  int not null,        -- 그 배너 안에서의 순번(1~3)
  sub1           text,
  sub2           text,
  updated_at     timestamptz not null default now(),
  unique (slot, variant_order)
);

alter table public.banner_subtexts enable row level security;

create policy pub_read_banner_subtexts on public.banner_subtexts
  for select to anon, authenticated using (true);
create policy adm_write_banner_subtexts on public.banner_subtexts
  for all to authenticated using (true) with check (true);

create trigger trg_banner_subtexts_touch before update on public.banner_subtexts
  for each row execute function public.touch_updated_at();

-- 기존 배너 2개의 오른쪽 문구를 각 배너의 1번째 세트 초기값으로 이관
-- (2·3번째는 비워두었으니 관리자 화면에서 채워 넣을 것)
insert into public.banner_subtexts (slot, variant_order, sub1, sub2) values
  (1, 1, '이제 대한민국 유명 보험 강좌를', '한곳에서 확인하실 수 있습니다.'),
  (1, 2, '', ''),
  (1, 3, '', ''),
  (2, 1, '강사 섭외 스트레스를 없애드립니다.', '강의영상을 먼저 확인하고 선택합니다.'),
  (2, 2, '', ''),
  (2, 3, '', '');


-- ============================================================
-- 13. [추가] 배너 오른쪽 보조문구 3개마다 글자 색 지정
-- ============================================================
alter table public.banner_subtexts
  add column if not exists color text;


-- ============================================================
-- 14. [추가] 방문 팝업 (popups)
--     사이트 접속 시 뜨는 이벤트/공지 팝업. 완성된 이미지를 그대로
--     업로드하는 방식이라 문구 컬럼은 없음. 여러 개 등록하면 화면에서
--     자동 롤링 + 스와이프로 넘어감.
-- ============================================================
create table public.popups (
  id           bigserial primary key,
  image_url    text,
  link         text,
  sort_order   int not null default 0,
  is_visible   boolean not null default true,
  updated_at   timestamptz not null default now()
);

alter table public.popups enable row level security;

create policy pub_read_popups on public.popups
  for select to anon, authenticated using (is_visible);
create policy adm_write_popups on public.popups
  for all to authenticated using (true) with check (true);

create trigger trg_popups_touch before update on public.popups
  for each row execute function public.touch_updated_at();
