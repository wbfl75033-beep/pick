/* ============================================================
   강사 Pick — 설정값
   ------------------------------------------------------------
   ※ 여기 들어가는 키 3개는 모두 "브라우저에 공개되는 키"입니다.
     - Supabase anon key : 공개용 키. 실제 권한은 DB의 RLS 정책이 막습니다.
     - Web3Forms key     : 공개용 키. 폼 전송 전용입니다.
     비밀키(service_role key)는 절대 이 파일에 넣지 마세요.
   ============================================================ */
window.PICK_CONFIG = {
  // Supabase 대시보드 > Project Settings > API 에서 복사
  SUPABASE_URL:      'https://piukbdjifexfqjevfgrq.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_zw35mtr_rDkykS72te9ssw_TBAIA42V',

  // Web3Forms 대시보드에서 발급받은 Access Key
  WEB3FORMS_KEY:     '5dbdd6e9-2080-484b-954d-92843c9141e9',

  // 폼 수신 메일 (Web3Forms 가입 계정 메일과 동일해야 함)
  MAIL_TO:           'minzi34@naver.com',

  // Storage 버킷명 (설계서 지정값)
  STORAGE_BUCKET:    'pick-media',

  // 강사·공고 삭제 방식
  //   true  = is_visible 을 false 로 바꿔 화면에서만 숨김 (설계서 권장)
  //   false = DB에서 완전 삭제
  SOFT_DELETE:       true,
};
