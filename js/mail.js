/* ============================================================
   강사 Pick — 폼 메일 발송 (Web3Forms)
   ------------------------------------------------------------
   설계서 지침: 제출 내용은 DB에 저장하지 않고 지정 메일로만 발송.
   이 파일은 어떤 값도 저장하지 않습니다.
   ============================================================ */
(function () {
  const C = window.PICK_CONFIG;
  const ENDPOINT = 'https://api.web3forms.com/submit';

  const now = () => new Date().toLocaleString('ko-KR', { timeZone: 'Asia/Seoul' });

  async function send(subject, fields) {
    const payload = {
      access_key: C.WEB3FORMS_KEY,
      subject,
      from_name: '강사 Pick',
      ...fields,
      접수일시: now(),
    };
    const res = await fetch(ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
      body: JSON.stringify(payload),
    });
    const json = await res.json().catch(() => ({}));
    if (!res.ok || json.success === false) {
      console.error('[메일 발송 실패]', json);
      throw new Error(json.message || '메일 발송에 실패했습니다.');
    }
    return true;
  }

  /** 강의의뢰 문의 — 제목: [강사Pick 강의의뢰] 대상 강사명 / 회사명 */
  function sendInquiry(d) {
    return send(`[강사Pick 강의의뢰] ${d.instructorName || '-'} / ${d.org || '-'}`, {
      대상강사: d.instructorName || '',
      회사명: d.org || '',
      소재지: d.location || '',
      문의자이름: d.name || '',
      부서및직위: d.dept || '',
      핸드폰: d.phone || '',
      이메일: d.email || '',
      문의사항: d.message || '',
      개인정보수집이용동의: d.agreed ? '동의함' : '동의하지 않음',
    });
  }

  /** 등록요청 — 제목: [강사Pick 등록요청] 강사 또는 강좌 / 신청자명 */
  function sendRegRequest(d) {
    const kind = d.kind === 'course' ? '강좌' : '강사';
    return send(`[강사Pick 등록요청] ${kind} / ${d.applicant || '-'}`, {
      요청구분: kind,
      ...(d.kind === 'course' ? { 강좌형태: d.courseType === 'zoom' ? '줌' : '오프라인' } : {}),
      ...d.fields,
      개인정보수집이용동의: d.agreed ? '동의함' : '동의하지 않음',
    });
  }

  window.PickMail = { send, sendInquiry, sendRegRequest };
})();
