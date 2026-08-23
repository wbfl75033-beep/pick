# FP파트너즈 강사 Pick — 백엔드 연결

정적 HTML 프론트엔드(완성본)에 **Supabase**(DB·파일저장·관리자로그인)와
**Web3Forms**(폼 메일발송)를 붙이고 **Vercel**에 배포하는 프로젝트입니다.

> 📌 **처음 인수받으셨다면 `docs/인수인계서.md` 부터 보세요.**
> 터미널 없이 Claude Code에게 말로 시키는 방식으로 정리돼 있습니다.
> 이 README의 명령어들은 클로드가 실행할 참고 자료입니다.

- 서비스 주소(예정): `pick.fppartners.co.kr`
- 오픈 목표: **2026년 9월 중순**

---

## 폴더 구조

```
fppartners/
├── index.html              작업 대상 (원본 복사본 + 스크립트 연결됨)
├── js/
│   ├── config.js           ★ 키 3개 입력하는 곳 (제일 먼저 채울 파일)
│   ├── db.js               Supabase 조회·저장 + DB↔화면 필드명 변환
│   ├── auth.js             관리자 로그인 / 권한별 버튼 숨김
│   ├── upload.js           Storage 파일 업로드
│   └── mail.js             Web3Forms 메일 발송
├── db/
│   ├── schema.sql          테이블·권한·버킷정책 (제공 스키마 + 줌필드 보정)
│   └── seed.sql            기존 데이터 이관용 (강사 21 / 영상 63 / 공고 2 / 배너 2 / 광고 3)
├── docs/
│   ├── 작업체크리스트.md     남은 작업 목록
│   ├── 확인필요사항.md       발주처에 물어봐야 할 것
│   └── original/           원본 파일 보관 (요청서·설계서·최초 index.html·최초 SQL)
├── tools/                  index.html 데이터 → seed.sql 자동 생성 스크립트
└── vercel.json             배포 설정
```

---

## 세팅 순서

### 1. Supabase
1. 프로젝트 생성 — **리전은 반드시 서울(ap-northeast-2)**. 생성 후 변경 불가.
2. SQL Editor → `db/schema.sql` 전체 붙여넣고 실행
   (테이블·권한·`pick-media` 버킷까지 한 번에 생성됩니다. Storage 메뉴 안 들어가도 됨)
3. SQL Editor → `db/seed.sql` 전체 붙여넣고 실행 (기존 데이터 이관)
4. Storage 메뉴에서 `pick-media` 버킷이 생겼는지 확인
5. Authentication → Users 에서 관리자 계정 2~3개 생성
6. Authentication → Providers → **Email 회원가입(Enable Sign Ups) 끄기** (외부 가입 차단)
7. Project Settings → API 에서 `Project URL` 과 `anon public` 키 복사

### 2. Web3Forms
1. https://web3forms.com 에서 수신 메일 `minzi34@naver.com` 으로 Access Key 발급
2. 발급받은 키 복사

### 3. 키 입력
`js/config.js` 를 열어 3곳을 채웁니다.

```js
SUPABASE_URL:      'https://xxxxx.supabase.co',
SUPABASE_ANON_KEY: 'eyJhbGci...',
WEB3FORMS_KEY:     'xxxxxxxx-xxxx-...',
```

> anon key 와 Web3Forms key 는 **원래 브라우저에 공개되는 키**입니다. 그대로 커밋해도 됩니다.
> 단, Supabase 의 `service_role` 키는 절대 넣지 마세요.

### 4. 로컬 실행

```bash
npm run dev
```

브라우저에서 `http://localhost:5173` 접속.
관리자 로그인은 주소 뒤에 `#admin` 을 붙이거나 `Ctrl + Shift + A`.

### 5. 배포

```bash
npx vercel --prod
```

이후 Vercel 대시보드 → Domains 에서 `pick.fppartners.co.kr` 추가 →
안내되는 CNAME 값을 회사 도메인 담당자에게 전달.

---

## 데이터 다시 뽑기

`index.html` 원본의 하드코딩 데이터가 바뀌었을 때만 사용합니다.

```bash
npm run seed
```

`docs/original/index.original.html` 을 읽어 `db/seed.sql` 을 다시 만듭니다.

---

## 관리자 진입 방법

| 방법 | 설명 |
|---|---|
| `주소/#admin` | 로그인 창이 뜹니다 |
| `Ctrl + Shift + A` | 어느 화면에서든 로그인 창 |
| 로그인 후 | 우측 하단에 로그아웃 바, 헤더에 관리자 버튼이 나타납니다 |

로그인하지 않으면 관리자 버튼·수정·삭제·핀 버튼이 **화면에서 사라지고**,
콘솔로 직접 호출해도 `switchTab` 가드와 DB의 RLS 정책이 이중으로 막습니다.
