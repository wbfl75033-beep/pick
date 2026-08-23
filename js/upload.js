/* ============================================================
   강사 Pick — Supabase Storage 업로드
   기존 URL.createObjectURL(임시 미리보기) 을 대체합니다.
   폴더: instructors / profiles / posters / maps / banners / ads
   ============================================================ */
(function () {
  const sb = window.PickDB.client;
  const BUCKET = window.PICK_CONFIG.STORAGE_BUCKET;

  const MAX_MB = { image: 5, video: 20, file: 20 };

  function safeName(name) {
    const dot = name.lastIndexOf('.');
    const ext = dot > -1 ? name.slice(dot + 1).toLowerCase() : 'bin';
    return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}.${ext}`;
  }

  /**
   * 파일 하나를 Storage 에 올리고 공개 URL 을 돌려줍니다.
   * @param {File} file
   * @param {string} folder  instructors | profiles | posters | maps | banners | ads
   * @returns {Promise<string>} public URL
   */
  async function upload(file, folder) {
    if (!file) return '';
    const kind = file.type.startsWith('video') ? 'video' : file.type.startsWith('image') ? 'image' : 'file';
    if (file.size > MAX_MB[kind] * 1024 * 1024) {
      throw new Error(`파일이 너무 큽니다. ${MAX_MB[kind]}MB 이하로 올려주세요.`);
    }
    const path = `${folder}/${safeName(file.name)}`;
    const { error } = await sb.storage.from(BUCKET).upload(path, file, {
      cacheControl: '31536000', upsert: false, contentType: file.type || undefined,
    });
    if (error) { console.error('[업로드]', error); throw error; }
    return sb.storage.from(BUCKET).getPublicUrl(path).data.publicUrl;
  }

  /** input[type=file] 에서 바로 업로드. 파일이 없으면 빈 문자열 */
  async function uploadFromInput(input, folder) {
    if (!input || !input.files || !input.files[0]) return '';
    return upload(input.files[0], folder);
  }

  /** 교체 업로드 후 이전 파일 정리 (같은 버킷 안의 파일만) */
  async function removeByUrl(url) {
    if (!url) return;
    const marker = `/storage/v1/object/public/${BUCKET}/`;
    const i = url.indexOf(marker);
    if (i === -1) return;                       // 외부 URL 은 건드리지 않음
    const path = decodeURIComponent(url.slice(i + marker.length));
    await sb.storage.from(BUCKET).remove([path]);
  }

  window.PickUpload = { upload, uploadFromInput, removeByUrl, BUCKET };
})();
