/* ============================================================
   강사 Pick — 관리자 로그인 / 화면 권한 제어
   ------------------------------------------------------------
   · 관리자 진입: 주소 뒤에 #admin 을 붙이거나 Ctrl+Shift+A
   · 로그인 상태에서만 body 에 is-admin 클래스가 붙습니다.
     [data-admin-only] 가 붙은 요소는 로그인 전에는 숨겨집니다.
   · 화면에서 숨기는 것과 별개로 DB의 RLS 가 서버에서 한 번 더 막습니다.
   ============================================================ */
(function () {
  const sb = window.PickDB.client;
  let currentUser = null;

  /* ---------- 관리자 전용 요소 숨김 CSS ---------- */
  const style = document.createElement('style');
  style.textContent = `
    [data-admin-only] { display: none !important; }
    body.is-admin [data-admin-only] { display: revert !important; }
    #pick-login-backdrop { position: fixed; inset: 0; z-index: 9999; background: rgba(17,24,39,.55);
      display: none; align-items: center; justify-content: center; padding: 16px; }
    #pick-login-backdrop.on { display: flex; }
    #pick-login-box { background:#fff; border-radius:18px; width:100%; max-width:360px; padding:28px 24px;
      box-shadow:0 20px 50px rgba(17,24,39,.25); font-family:inherit; }
    #pick-login-box h3 { font-size:17px; font-weight:800; margin-bottom:4px; color:#111827; }
    #pick-login-box p  { font-size:12.5px; color:#6b7280; margin-bottom:18px; }
    #pick-login-box input { width:100%; padding:12px; border-radius:10px; border:1px solid #e5e7eb;
      font-size:14px; margin-bottom:10px; outline:none; }
    #pick-login-box input:focus { border-color:#2f3b89; box-shadow:0 0 0 3px rgba(47,59,137,.12); }
    #pick-login-msg { font-size:12.5px; color:#dc2626; min-height:18px; margin-bottom:6px; }
    .pick-btn { width:100%; padding:12px; border-radius:999px; border:0; font-size:14px; font-weight:700;
      cursor:pointer; transition:.2s; }
    .pick-btn-primary { background:#2f3b89; color:#fff; }
    .pick-btn-primary:hover { transform:translateY(-1px); }
    .pick-btn-ghost { background:#fff; color:#6b7280; margin-top:8px; }
    #pick-logout-bar { position:fixed; right:16px; bottom:16px; z-index:9998; display:none;
      background:#111827; color:#fff; border-radius:999px; padding:9px 16px; font-size:12.5px; font-weight:700;
      box-shadow:0 8px 24px rgba(17,24,39,.28); }
    body.is-admin #pick-logout-bar { display:flex; align-items:center; gap:10px; }
    #pick-logout-bar button { background:#374151; color:#fff; border:0; border-radius:999px;
      padding:5px 12px; font-size:12px; font-weight:700; cursor:pointer; }
  `;
  document.head.appendChild(style);

  /* ---------- 로그인 모달 ---------- */
  const modal = document.createElement('div');
  modal.id = 'pick-login-backdrop';
  modal.innerHTML = `
    <div id="pick-login-box">
      <h3>관리자 로그인</h3>
      <p>등록·수정·삭제 기능을 사용하려면 로그인하세요.</p>
      <input id="pick-login-email" type="email" placeholder="이메일" autocomplete="username">
      <input id="pick-login-pw" type="password" placeholder="비밀번호" autocomplete="current-password">
      <div id="pick-login-msg"></div>
      <button class="pick-btn pick-btn-primary" id="pick-login-submit">로그인</button>
      <button class="pick-btn pick-btn-ghost" id="pick-login-cancel">닫기</button>
    </div>`;
  document.body.appendChild(modal);

  const bar = document.createElement('div');
  bar.id = 'pick-logout-bar';
  bar.innerHTML = `<span id="pick-admin-email">관리자</span><button id="pick-logout-btn">로그아웃</button>`;
  document.body.appendChild(bar);

  const $ = id => document.getElementById(id);
  const openLogin  = () => { $('pick-login-msg').textContent = ''; modal.classList.add('on'); $('pick-login-email').focus(); };
  const closeLogin = () => modal.classList.remove('on');

  $('pick-login-cancel').onclick = closeLogin;
  modal.addEventListener('click', e => { if (e.target === modal) closeLogin(); });

  $('pick-login-submit').onclick = async () => {
    const email = $('pick-login-email').value.trim();
    const password = $('pick-login-pw').value;
    if (!email || !password) { $('pick-login-msg').textContent = '이메일과 비밀번호를 입력하세요.'; return; }
    const { error } = await sb.auth.signInWithPassword({ email, password });
    if (error) { $('pick-login-msg').textContent = '로그인 실패 — 이메일 또는 비밀번호를 확인하세요.'; return; }
    $('pick-login-pw').value = '';
    closeLogin();
    if (location.hash === '#admin') history.replaceState(null, '', location.pathname);
  };
  $('pick-login-pw').addEventListener('keydown', e => { if (e.key === 'Enter') $('pick-login-submit').click(); });

  $('pick-logout-btn').onclick = async () => {
    await sb.auth.signOut();
    if (typeof switchTab === 'function') switchTab('landing');
  };

  /* ---------- 진입 경로 ---------- */
  const checkHash = () => { if (location.hash === '#admin' && !currentUser) openLogin(); };
  window.addEventListener('hashchange', checkHash);
  document.addEventListener('keydown', e => {
    if (e.ctrlKey && e.shiftKey && (e.key === 'A' || e.key === 'a')) { e.preventDefault(); currentUser ? null : openLogin(); }
  });

  /* ---------- 로그인 상태 반영 ---------- */
  /* ---------- 푸터 관리자 로그인/로그아웃 링크 ----------
     페이지 맨 아래 카피라이트 밑에 희미하게 배치.
     비로그인 → '관리자 로그인' / 로그인 → '로그아웃' 으로 문구가 바뀝니다. */
  const headerLink = $('pick-auth-link');
  if (headerLink) {
    headerLink.addEventListener('click', async e => {
      e.preventDefault();
      if (currentUser) {
        await sb.auth.signOut();
        if (typeof switchTab === 'function') switchTab('landing');
      } else {
        openLogin();
      }
    });
  }

  function apply(user) {
    currentUser = user;
    document.body.classList.toggle('is-admin', !!user);
    if (headerLink) headerLink.textContent = user ? '로그아웃' : '관리자 로그인';
    if (user) $('pick-admin-email').textContent = user.email;
    // 로그아웃 상태에서 관리자 탭이 열려 있으면 첫 화면으로 되돌림
    if (!user && typeof switchTab === 'function') {
      const open = document.querySelector('.tab-content.active, .tab-content:not(.hidden)');
      if (open && /^admin/.test(open.id)) switchTab('landing');
    }
    document.dispatchEvent(new CustomEvent('pick:auth', { detail: { user } }));
  }

  if (window.PICK_READY) {
    sb.auth.getSession().then(({ data }) => { apply(data.session ? data.session.user : null); checkHash(); })
      .catch(e => { console.warn('[세션 확인 실패]', e); apply(null); });
    sb.auth.onAuthStateChange((_e, session) => apply(session ? session.user : null));
  } else {
    apply(null);
  }

  /* ---------- 관리자 탭 진입 차단 ----------
     비로그인 상태에서 switchTab('admin...') 이 호출되면 로그인 창을 띄웁니다.
     (버튼을 숨겨도 콘솔로 직접 호출할 수 있으므로 한 겹 더 막음) */
  if (typeof window.switchTab === 'function') {
    const _switchTab = window.switchTab;
    window.switchTab = function (name) {
      if (typeof name === 'string' && name.indexOf('admin') === 0 && !currentUser) {
        openLogin();
        return;
      }
      return _switchTab.apply(this, arguments);
    };
  }

  window.PickAuth = {
    openLogin, closeLogin,
    isAdmin: () => !!currentUser,
    user: () => currentUser,
    signOut: () => sb.auth.signOut(),
  };
})();
