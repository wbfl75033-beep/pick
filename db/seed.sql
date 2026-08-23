-- ============================================================
-- 강사 Pick — 초기 이관 데이터 (index.html 하드코딩 데이터 → DB)
-- 자동 생성: tools/seed.mjs  |  생성일: 2026-08-20
-- 실행 순서: schema.sql 실행 후 이 파일 실행
-- 주의: 두 번 실행하면 중복 입력됩니다. 재실행 전 아래 초기화 블록 사용.
-- ============================================================

-- [재실행용 초기화] 필요할 때만 주석 해제
-- truncate table public.instructor_videos, public.instructors,
--   public.posters, public.top_ads, public.banners restart identity cascade;


-- ------------------------------------------------------------
-- 강사 21명
-- ------------------------------------------------------------
insert into public.instructors
  (id, name, type, title, intro, profile, categories, phone_public, phone_private, email,
   photo_url, profile_file_url, sort_order, is_pinned, is_visible)
values
  (1, '장신영', '추천', '보장분석 전문 강사입니다.', '매월 바뀌는 보험사별 상품 판매 전략과 트렌드를 분석하여 현장에 즉시 적용 가능한 세일즈 포인트를 제공합니다.', '현) FP파트너스 대표 강사
전) 외국계 생명보험사 지점장',
   array['상품영업전략', '초회상담(AP)'], '02-525-1686', null, null,
   'https://i.ibb.co/CpCfDgs4/2026-08-11-165218-removebg-preview.png', null, 1, false, true),
  (2, '조대수', '제휴', 'AI 전문가로 만들어드립니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['AI세일즈', 'FPShip', '법인영업'], '02-525-1686', null, null,
   'https://i.ibb.co/jvNhTb9q/Kakao-Talk-20260807-165630659-removebg-preview.png', null, 2, false, true),
  (3, '김낙현', '추천', 'FP를 위한 경제 브리핑', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['DB영업', '상담프로세스', '초회상담(AP)'], '02-525-1686', null, null,
   'https://i.ibb.co/ymvwPGxQ/2026-08-11-173008-removebg-preview.png', null, 3, false, true),
  (4, '염동준', '추천', 'AI 전문가로 만들어드립니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['상품영업전략', '상담프로세스'], '02-525-1686', null, null,
   'https://i.ibb.co/zWksb9ZW/2026-08-11-165336-removebg-preview.png', null, 4, false, true),
  (5, '이병조', '추천', '메디컬화법 전문 강사입니다', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['메디컬화법'], '02-525-1686', null, null,
   'https://i.ibb.co/xq16dm1B/2026-08-11-173815-removebg-preview.png', null, 5, false, true),
  (6, '이해웅', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['상품영업전략', '상담프로세스', '초회상담(AP)'], '02-525-1686', null, null,
   'https://i.ibb.co/hFZ4yFJ9/2026-08-11-165347-removebg-preview.png', null, 6, false, true),
  (7, '한민국', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['상담프로세스', '초회상담(AP)'], '02-525-1686', null, null,
   'https://i.ibb.co/sv6QYyLc/2026-07-21-162756-removebg-preview.png', null, 7, false, true),
  (8, '박승용', '제휴', 'FP 육성 전문 강사이자 트레이너 입니다.', '세일즈,리쿠르팅,교육과 훈련,매니지먼트,동기부여,코칭
종합 솔루션 제공강의가 아니라 무기를 드립니다!
아마추어는 흉내를 내지만 프로는 완성을 합니다!
듣고 끝나는 교육이 아니라, 당장 고객 앞에서 ‘써먹을 수 있는 실전형 Skill’과 ‘조직 빌드업을 위한 시스템을 장착’ 해드립니다.
FP를 대상으로 주입식이 아니라 원리를 이해시키고 시범을 보이고 함께 참여하는 능동적 강의 방식으로 진행하여 실전 가용성을 극대화 합니다.', '- 세일즈명인아카데미 대표
- 2019년 푸르덴셜 글로벌 AM 챔피언보험영업 19년(총 세일즈 31년)
- FP 정착률 기네스(13차월 100%, 25차월90%)
- 현대해상,신한라이프,인카금융서비스등 국내 주요 생보/손보/GA 공식 강사및 만족도 AAA
- 1,300회 출강 이력',
   array['종신&정기보험', '상담프로세스', 'FPShip'], '010-2257-9723', null, 'sr9066@naver.com',
   'https://i.ibb.co/rRHWLVTp/2026-08-11-173116-removebg-preview.png', 'https://raw.githubusercontent.com/wbfl75033-beep/-/main/2026_세일즈명인아카데미_인쇄용_2026.0101.pdf', 8, false, true),
  (9, '최승은', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['DB영업', '초회상담(AP)', '상담프로세스'], '010-2257-9723', null, 'sr9066@naver.com',
   'https://i.ibb.co/tTpzBFZh/2026-08-11-172134-removebg-preview.png', null, 9, false, true),
  (10, '김윤호', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['DB영업', '초회상담(AP)', '상담프로세스'], '02-525-1686', null, null,
   'https://i.ibb.co/r2WNf0z0/2026-08-11-171301-removebg-preview.png', null, 10, false, true),
  (11, '김지율', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['FPShip', '초회상담(AP)', '상담프로세스'], '02-525-1686', null, null,
   'https://i.ibb.co/0R2d7r3t/2026-07-24-084205.png', null, 11, false, true),
  (12, '원승현', '제휴', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['FPShip', '초회상담(AP)', '상담프로세스'], '02-525-1686', null, null,
   'https://i.ibb.co/zWw0nyyr/2026-07-24-084507.png', null, 12, false, true),
  (13, '황선찬', '제휴', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['종신&정기보험', 'FPShip', '초회상담(AP)'], '02-525-1686', null, null,
   'https://i.ibb.co/HLXpt8Vw/2026-07-24-084721.png', null, 13, false, true),
  (14, '김현진', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['AI세일즈', '초회상담(AP)', '상담프로세스'], '02-525-1686', null, null,
   'https://i.ibb.co/nMSnHyPb/2026-08-11-171910-removebg-preview.png', null, 14, false, true),
  (15, '김효석', '제휴', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['FPShip', '초회상담(AP)'], '02-525-1686', null, null,
   'https://i.ibb.co/jkZ2TghS/2026-07-24-085445.png', null, 15, false, true),
  (16, '이상훈', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['상품영업전략', '초회상담(AP)', '상담프로세스'], '02-525-1686', null, null,
   'https://i.ibb.co/LDhyDZdS/2026-08-11-172556-removebg-preview.png', null, 16, false, true),
  (17, '박준용', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['변액보험'], '02-525-1686', null, null,
   'https://i.ibb.co/LhXvhk0j/2026-07-24-085747.png', null, 17, false, true),
  (18, '이희준', '제휴', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['상담프로세스', '초회상담(AP)'], '02-525-1686', null, null,
   'https://i.ibb.co/XrLX09Ln/2026-07-24-085917.png', null, 18, false, true),
  (19, '박중환', '추천', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['법인영업'], '02-525-1686', null, null,
   'https://i.ibb.co/C5jX9kJC/2026-07-24-090042.png', null, 19, false, true),
  (20, '노규한', '제휴', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['법인영업'], '02-525-1686', null, null,
   'https://i.ibb.co/Z6vKwNBM/2026-07-24-090227.png', null, 20, false, true),
  (21, '백문영', '제휴', '상품영업전략 전문입니다!', '복잡한 경제 흐름을 고객의 눈높이에 맞춰 쉽게 설명하고, 변액 및 연금 상품 판매로 연결하는 화법을 배웁니다.', '투자자산운용사
경제 칼럼니스트',
   array['법인영업'], '02-525-1686', null, null,
   'https://i.ibb.co/SX86czXc/2026-07-24-090414.png', null, 21, false, true);
select setval(pg_get_serial_sequence('public.instructors','id'), (select max(id) from public.instructors));

-- ------------------------------------------------------------
-- 강사 영상 63편
-- ------------------------------------------------------------
insert into public.instructor_videos (instructor_id, url, title, thumbnail_url, sort_order)
values
  (1, 'https://vimeo.com/1212513043', '상품영업전략', null, 1),
  (1, 'https://vimeo.com/1212513044', '종신&정기보험', null, 2),
  (1, 'https://vimeo.com/1212513045', '상품영업전략', null, 3),
  (2, 'https://vimeo.com/1207296757', 'AI세일즈', null, 1),
  (2, 'https://vimeo.com/1212510054', 'AI세일즈', null, 2),
  (2, 'https://vimeo.com/1212510053', '법인영업', null, 3),
  (3, 'https://vimeo.com/1212515054', null, null, 1),
  (3, 'https://vimeo.com/1212515056', null, null, 2),
  (3, 'https://vimeo.com/1212515055', null, null, 3),
  (4, 'https://vimeo.com/1212517124', null, null, 1),
  (4, 'https://vimeo.com/1212517125', null, null, 2),
  (4, 'https://vimeo.com/1212517123', null, null, 3),
  (5, 'https://vimeo.com/1212518927', null, null, 1),
  (5, 'https://vimeo.com/1212518926', null, null, 2),
  (5, 'https://vimeo.com/1212518925', null, null, 3),
  (6, 'https://vimeo.com/1212519971', null, null, 1),
  (6, 'https://vimeo.com/1212519970', null, null, 2),
  (6, 'https://vimeo.com/1212519972', null, null, 3),
  (7, 'https://vimeo.com/1212521173', null, null, 1),
  (7, 'https://vimeo.com/1212521172', null, null, 2),
  (7, 'https://vimeo.com/1212521171', null, null, 3),
  (8, 'https://vimeo.com/1212522732', '- FPShip', 'https://i.ibb.co/nq9g9sYx/60.png', 1),
  (8, 'https://vimeo.com/1212522733', '- 종신&정기보험', 'https://i.ibb.co/MyD4bGXj/61.png', 2),
  (8, 'https://vimeo.com/1212522734', '상담프로세스', 'https://i.ibb.co/XPncNTF/62.png', 3),
  (9, 'https://vimeo.com/1212542644', null, null, 1),
  (9, 'https://vimeo.com/1212542645', null, null, 2),
  (9, 'https://vimeo.com/1212542646', null, null, 3),
  (10, 'https://vimeo.com/1212569736', null, null, 1),
  (10, 'https://vimeo.com/1212569735', null, null, 2),
  (10, 'https://vimeo.com/1212569737', null, null, 3),
  (11, 'https://vimeo.com/1212572556', null, null, 1),
  (11, 'https://vimeo.com/1212572557', null, null, 2),
  (11, 'https://vimeo.com/1212572555', null, null, 3),
  (12, 'https://vimeo.com/1207296757', null, null, 1),
  (12, 'https://vimeo.com/1207296757', null, null, 2),
  (12, 'https://vimeo.com/1207296757', null, null, 3),
  (13, 'https://vimeo.com/1207296757', null, null, 1),
  (13, 'https://vimeo.com/1207296757', null, null, 2),
  (13, 'https://vimeo.com/1207296757', null, null, 3),
  (14, 'https://vimeo.com/1207296757', null, null, 1),
  (14, 'https://vimeo.com/1207296757', null, null, 2),
  (14, 'https://vimeo.com/1207296757', null, null, 3),
  (15, 'https://vimeo.com/1207296757', null, null, 1),
  (15, 'https://vimeo.com/1207296757', null, null, 2),
  (15, 'https://vimeo.com/1207296757', null, null, 3),
  (16, 'https://vimeo.com/1207296757', null, null, 1),
  (16, 'https://vimeo.com/1207296757', null, null, 2),
  (16, 'https://vimeo.com/1207296757', null, null, 3),
  (17, 'https://vimeo.com/1207296757', null, null, 1),
  (17, 'https://vimeo.com/1207296757', null, null, 2),
  (17, 'https://vimeo.com/1207296757', null, null, 3),
  (18, 'https://vimeo.com/1207296757', null, null, 1),
  (18, 'https://vimeo.com/1207296757', null, null, 2),
  (18, 'https://vimeo.com/1207296757', null, null, 3),
  (19, 'https://vimeo.com/1207296757', null, null, 1),
  (19, 'https://vimeo.com/1207296757', null, null, 2),
  (19, 'https://vimeo.com/1207296757', null, null, 3),
  (20, 'https://vimeo.com/1207296757', null, null, 1),
  (20, 'https://vimeo.com/1207296757', null, null, 2),
  (20, 'https://vimeo.com/1207296757', null, null, 3),
  (21, 'https://vimeo.com/1207296757', null, null, 1),
  (21, 'https://vimeo.com/1207296757', null, null, 2),
  (21, 'https://vimeo.com/1207296757', null, null, 3);

-- ------------------------------------------------------------
-- 공개강좌 공고 2건
-- ------------------------------------------------------------
insert into public.posters
  (id, ptype, title, image_url, event_date, location, topic, description,
   link, apply_link, map_image_url, map_url, route,
   zoom_link, zoom_id, zoom_pw, zoom_note, sort_order, is_visible)
values
  (1, 'offline', '이달의 보험영업 전략 브리핑 (오프라인 세미나)', 'https://i.ibb.co/S48jzbnq/44.png', '2026년 6월 15일 (월) 10:00 - 12:00', '본사 2층 대교육장', 'Sustainable Growth & Innovation', '매월 초 진행되는 정기 세일즈 브리핑입니다. 생명/손해보험사별 주력 상품의 셀링 포인트와 타겟 고객군을 완벽하게 분석해 드립니다.',
   'https://fppartners.co.kr/main.php', 'https://form.naver.com/', 'https://i.ibb.co/gLnWZtgR/2026-07-24-143047.png', 'https://map.naver.com/p/entry/place/1372825586', '지하철: 2호선 역삼역 3번 출구 도보 5분 거리
버스: 역삼역 사거리 정류장 하차 후 100m 직진
* 주차는 건물 지하 1시간 무료 지원됩니다.',
   null, null, null, null, 1, true),
  (2, 'zoom', '온라인 실전 세일즈 특강 (ZOOM 생중계)', 'https://i.ibb.co/SLZqQKW/59.png', '2026년 8월 25일 (화) 20:00 - 22:00', null, '고객을 사로잡는 화법 & 클로징 전략', '어디서나 참여 가능한 온라인 ZOOM 특강입니다.

실전에서 바로 쓸 수 있는 상담 화법과 클로징 노하우를 집중적으로 다룹니다. PC·모바일 어디서든 참여하실 수 있으며, 강의 후 질의응답 시간도 마련되어 있습니다.',
   'https://fppartners.co.kr/main.php', 'https://form.naver.com/', null, null, null,
   null, null, null, null, 2, true);
select setval(pg_get_serial_sequence('public.posters','id'), (select max(id) from public.posters));

-- ------------------------------------------------------------
-- 상단 광고 3개
-- ------------------------------------------------------------
insert into public.top_ads (slot, image_url, image_mobile_url, bg, link, is_visible)
values
  (1, 'https://i.ibb.co/6fwcSLK/1-removebg-preview.png', null, '#e6f3fb', null, true),
  (2, 'https://i.ibb.co/1f1b91r7/2-removebg-preview.png', null, null, null, true),
  (3, 'https://i.ibb.co/1f1b91r7/2-removebg-preview.png', null, '#e7f5df', null, true);

-- ------------------------------------------------------------
-- 메인 배너 2개
-- ------------------------------------------------------------
insert into public.banners
  (slot, image_url, image_mobile_url, video_url, video_mobile_url,
   line1, line2, sub1, sub2, btn_text, link, is_visible)
values
  (1, 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=1920&q=80', null, null, null,
   '현장에서 바로 쓰는', '공개 강좌 안내', '이제 대한민국 유명 보험 강좌를', '한곳에서 확인하실 수 있습니다.', '강좌 일정 보기', '#poster-section', true),
  (2, 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?auto=format&fit=crop&w=1920&q=80', null, null, null,
   '실전 현장감을 갖춘', '최고 강사를 Pick하다', '강사 섭외 스트레스를 없애드립니다.', '강의영상을 먼저 확인하고 선택합니다.', '강사 리스트 보기', '#instructor-section', true);

-- ============================================================
-- 확인용 조회
-- ============================================================
-- select count(*) as 강사 from public.instructors;          -- 21
-- select count(*) as 영상 from public.instructor_videos;    -- 63
-- select count(*) as 공고 from public.posters;              -- 2
-- select count(*) as 광고 from public.top_ads;              -- 3
-- select count(*) as 배너 from public.banners;              -- 2
