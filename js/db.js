/* ============================================================
   강사 Pick — Supabase 데이터 계층
   화면 코드가 쓰던 필드명(photo, date, image ...)과
   DB 컬럼명(photo_url, event_date, image_url ...)을 여기서 변환합니다.
   화면 로직은 손대지 않고 이 파일의 함수만 호출하면 됩니다.
   ============================================================ */
(function () {
  const C = window.PICK_CONFIG;

  // 키를 아직 안 채웠으면 경고만 남기고 넘어감 (로컬에서 화면 확인용)
  window.PICK_READY = !/여기에/.test(C.SUPABASE_URL + C.SUPABASE_ANON_KEY);
  if (!window.PICK_READY) {
    console.warn('[강사Pick] js/config.js 에 Supabase 키가 아직 입력되지 않았습니다. DB 연결 없이 화면만 표시됩니다.');
  }

  const sb = window.supabase.createClient(
    window.PICK_READY ? C.SUPABASE_URL : 'https://placeholder.supabase.co',
    window.PICK_READY ? C.SUPABASE_ANON_KEY : 'placeholder-key'
  );

  /* ---------- DB row → 화면 객체 변환 ---------- */
  const toInstructor = (r, videos) => ({
    id: r.id,
    name: r.name,
    type: r.type,
    title: r.title || '',
    intro: r.intro || '',
    profile: r.profile || '',
    categories: r.categories || [],
    phone: r.phone_public || '',
    phonePrivate: r.phone_private || '',     // 관리자 조회 시에만 값이 들어옴
    email: r.email || '',
    photo: r.photo_url || '',
    profileFile: r.profile_file_url || '',
    sortOrder: r.sort_order,
    isPinned: r.is_pinned,
    isVisible: r.is_visible,
    videos: (videos || []).map(v => ({ url: v.url, title: v.title || '', thumbnail: v.thumbnail_url || '' })),
  });

  const toPoster = r => ({
    id: r.id,
    ptype: r.ptype,
    title: r.title,
    image: r.image_url || '',
    date: r.event_date || '',
    location: r.location || '',
    topic: r.topic || '',
    description: r.description || '',
    link: r.link || '',
    applyLink: r.apply_link || '',
    mapImage: r.map_image_url || '',
    mapUrl: r.map_url || '',
    route: r.route || '',
    zoomLink: r.zoom_link || '',
    zoomId: r.zoom_id || '',
    zoomPw: r.zoom_pw || '',
    zoomNote: r.zoom_note || '',
    sortOrder: r.sort_order,
  });

  const toBanner = r => ({
    id: r.id, slot: r.slot,
    image: r.image_url || '', imageMobile: r.image_mobile_url || '',
    video: r.video_url || '', videoMobile: r.video_mobile_url || '',
    line1: r.line1 || '', line2: r.line2 || '', sub1: r.sub1 || '', sub2: r.sub2 || '',
    btnText: r.btn_text || '', link: r.link || '',
  });

  const toTopAd = r => ({
    id: r.id, slot: r.slot,
    image: r.image_url || '', imageMobile: r.image_mobile_url || '',
    bg: r.bg || '', link: r.link || '',
  });

  /* ---------- 화면 객체 → DB row 변환 ---------- */
  const fromInstructor = o => ({
    name: o.name,
    type: o.type,                            // '추천' | '제휴' 만 허용
    title: o.title || null,
    intro: o.intro || null,
    profile: o.profile || null,
    categories: o.categories || [],
    phone_public: o.phone || null,
    phone_private: o.phonePrivate || null,
    email: o.email || null,
    photo_url: o.photo || null,
    profile_file_url: o.profileFile || null,
  });

  const fromPoster = o => ({
    ptype: o.ptype || 'offline',
    title: o.title,
    image_url: o.image || null,
    event_date: o.date || null,
    location: o.location || null,
    topic: o.topic || null,
    description: o.description || null,
    link: o.link || null,
    apply_link: o.applyLink || null,
    map_image_url: o.mapImage || null,
    map_url: o.mapUrl || null,
    route: o.route || null,
    zoom_link: o.zoomLink || null,
    zoom_id: o.zoomId || null,
    zoom_pw: o.zoomPw || null,
    zoom_note: o.zoomNote || null,
  });

  const err = (label, e) => { console.error('[' + label + ']', e); throw e; };

  /* ============================================================
     조회
     ============================================================ */
  async function fetchCategories() {
    const { data, error } = await sb.from('categories')
      .select('name').eq('is_active', true).order('sort_order');
    if (error) err('분야 조회', error);
    return data.map(r => r.name);
  }

  // 이용자 화면 — 반드시 공개 뷰(instructors_public) 사용. phone_private 가 물리적으로 빠져 있음.
  // 관리자 화면 — adminMode=true 로 본체 테이블 조회.
  async function fetchInstructors(adminMode) {
    const table = adminMode ? 'instructors' : 'instructors_public';
    const { data, error } = await sb.from(table).select('*')
      .order('is_pinned', { ascending: false })
      .order('sort_order', { ascending: true })
      .order('id', { ascending: true });
    if (error) err('강사 조회', error);

    const { data: vids, error: vErr } = await sb.from('instructor_videos')
      .select('*').order('instructor_id').order('sort_order');
    if (vErr) err('강사 영상 조회', vErr);

    const byInst = {};
    vids.forEach(v => { (byInst[v.instructor_id] = byInst[v.instructor_id] || []).push(v); });
    return data.map(r => toInstructor(r, byInst[r.id]));
  }

  async function fetchPosters() {
    const { data, error } = await sb.from('posters').select('*')
      .order('sort_order', { ascending: true }).order('id', { ascending: false });
    if (error) err('공고 조회', error);
    return data.map(toPoster);
  }

  async function fetchBanners() {
    const { data, error } = await sb.from('banners').select('*').order('slot');
    if (error) err('배너 조회', error);
    return data.map(toBanner);
  }

  async function fetchTopAds() {
    const { data, error } = await sb.from('top_ads').select('*').order('slot');
    if (error) err('상단광고 조회', error);
    return data.map(toTopAd);
  }

  /* ============================================================
     저장 · 삭제 (관리자 로그인 상태에서만 성공. 비로그인은 RLS 가 거부)
     ============================================================ */
  async function saveInstructor(obj, editingId) {
    const row = fromInstructor(obj);
    let id = editingId;

    if (editingId) {
      const { error } = await sb.from('instructors').update(row).eq('id', editingId);
      if (error) err('강사 수정', error);
    } else {
      const { data, error } = await sb.from('instructors').insert(row).select('id').single();
      if (error) err('강사 등록', error);
      id = data.id;
    }

    // 영상은 통째로 갈아끼움 (화면 폼이 항상 3칸 전체를 보내므로)
    const { error: dErr } = await sb.from('instructor_videos').delete().eq('instructor_id', id);
    if (dErr) err('기존 영상 삭제', dErr);

    const vids = (obj.videos || []).filter(v => v.url).map((v, i) => ({
      instructor_id: id, url: v.url, title: v.title || null,
      thumbnail_url: v.thumbnail || null, sort_order: i + 1,
    }));
    if (vids.length) {
      const { error: vErr } = await sb.from('instructor_videos').insert(vids);
      if (vErr) err('영상 저장', vErr);
    }
    return id;
  }

  async function deleteInstructor(id) {
    if (window.PICK_CONFIG.SOFT_DELETE) {
      const { error } = await sb.from('instructors').update({ is_visible: false }).eq('id', id);
      if (error) err('강사 숨김', error);
    } else {
      const { error } = await sb.from('instructors').delete().eq('id', id);   // 영상은 cascade 삭제
      if (error) err('강사 삭제', error);
    }
  }

  async function savePoster(obj, editingId) {
    const row = fromPoster(obj);
    if (editingId) {
      const { error } = await sb.from('posters').update(row).eq('id', editingId);
      if (error) err('공고 수정', error);
      return editingId;
    }
    const { data, error } = await sb.from('posters').insert(row).select('id').single();
    if (error) err('공고 등록', error);
    return data.id;
  }

  async function deletePoster(id) {
    if (window.PICK_CONFIG.SOFT_DELETE) {
      const { error } = await sb.from('posters').update({ is_visible: false }).eq('id', id);
      if (error) err('공고 숨김', error);
    } else {
      const { error } = await sb.from('posters').delete().eq('id', id);
      if (error) err('공고 삭제', error);
    }
  }

  // 상단광고 · 배너는 화면에서 목록 전체를 편집하므로 전체 교체 방식
  async function saveTopAds(list) {
    const { error: dErr } = await sb.from('top_ads').delete().neq('id', -1);
    if (dErr) err('상단광고 초기화', dErr);
    if (!list.length) return;
    const rows = list.map((a, i) => ({
      slot: i + 1, image_url: a.image || null, image_mobile_url: a.imageMobile || null,
      bg: a.bg || null, link: a.link || null, is_visible: true,
    }));
    const { error } = await sb.from('top_ads').insert(rows);
    if (error) err('상단광고 저장', error);
  }

  async function saveBanners(list) {
    const { error: dErr } = await sb.from('banners').delete().neq('id', -1);
    if (dErr) err('배너 초기화', dErr);
    if (!list.length) return;
    const rows = list.map((b, i) => ({
      slot: i + 1, image_url: b.image || null, image_mobile_url: b.imageMobile || null,
      video_url: b.video || null, video_mobile_url: b.videoMobile || null,
      line1: b.line1 || null, line2: b.line2 || null, sub1: b.sub1 || null, sub2: b.sub2 || null,
      btn_text: b.btnText || null, link: b.link || null, is_visible: true,
    }));
    const { error } = await sb.from('banners').insert(rows);
    if (error) err('배너 저장', error);
  }

  // 노출 순서 저장 (순서변경 기능 붙일 때 사용)
  async function saveOrder(table, idsInOrder) {
    for (let i = 0; i < idsInOrder.length; i++) {
      const { error } = await sb.from(table).update({ sort_order: i + 1 }).eq('id', idsInOrder[i]);
      if (error) err('순서 저장', error);
    }
  }

  async function setPinned(id, pinned) {
    const { error } = await sb.from('instructors').update({ is_pinned: !!pinned }).eq('id', id);
    if (error) err('상단고정', error);
  }

  window.PickDB = {
    client: sb,
    fetchCategories, fetchInstructors, fetchPosters, fetchBanners, fetchTopAds,
    saveInstructor, deleteInstructor, savePoster, deletePoster,
    saveTopAds, saveBanners, saveOrder, setPinned,
  };
})();
