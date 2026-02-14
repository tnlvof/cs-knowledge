# Quickstart: MeAIple Story

## Prerequisites

- Node.js 20+ (또는 Bun 1.x)
- **Bun** (패키지 매니저, https://bun.sh)
- Supabase CLI (`npx supabase`)
- Supabase 프로젝트 (Dashboard에서 생성)
- Google Cloud Console에서 OAuth 2.0 클라이언트 ID
- 토스페이먼츠 테스트 API 키
- Gemini API 키

## Setup

```bash
# 1. 프로젝트 생성
npx create-next-app@latest meaiple-story --typescript --tailwind --app --src-dir
cd meaiple-story

# 2. 의존성 설치 (Bun 사용)
bun add @supabase/supabase-js @supabase/ssr framer-motion @google/generative-ai
bun add -D supabase

# 3. 환경변수 설정
cp .env.example .env.local
```

## Environment Variables (.env.local)

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Gemini AI
GEMINI_API_KEY=your_gemini_api_key

# TossPayments
NEXT_PUBLIC_TOSS_CLIENT_KEY=your_client_key
TOSS_SECRET_KEY=your_secret_key

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## Database Setup

```bash
# Supabase 마이그레이션 실행
bunx supabase db push

# 시드 데이터 (문제, 몬스터, 아이템)
bunx supabase db seed
```

## Integration Test Scenarios

### Scenario 1: 캐릭터 생성 → 첫 전투
1. 앱 접속 (비로그인)
2. 닉네임 입력 + 외형 선택
3. "모험 시작하기" 탭
4. 전투 화면에서 몬스터 + 문제 확인
5. 주관식 답변 입력 → "공격하기"
6. AI 채점 결과 + 해설 확인

### Scenario 2: 레벨업 & 전직
1. 연속 퀴즈 풀이로 EXP 축적
2. 레벨업 연출 확인 (빛기둥 + 코드 파티클)
3. 레벨 10 도달 시 자동전직 연출 확인

### Scenario 3: 로그인 동기화
1. 비로그인으로 레벨 5까지 플레이
2. 로그인 유도 팝업 확인
3. Google 로그인
4. localStorage 데이터 → Supabase 동기화 확인

### Scenario 4: 결제 & 아이템
1. 아이템샵 진입
2. 젬 충전 (토스페이먼츠 테스트 결제)
3. 아이템 구매 → 젬 차감 확인
4. 아이템 장착 → 캐릭터 외형 변경 확인

### Scenario 5: 레벨 다운 → 랭킹 변동 → 연봉 변경 (002)
1. 고렙 캐릭터로 의도적으로 오답 반복
2. EXP 감소 확인 (레벨 구간별 -50~-200)
3. 레벨 다운 연출 확인 (어두운 화면 + "LEVEL DOWN..." + 진동)
4. 전직 강등 연출 확인 (전직 기준 레벨 미만 시)
5. 랭킹 페이지에서 순위 변동 확인
6. 프로필 예상 연봉 변경 확인

### Scenario 6: 정답률 표시 + 콤보 랭킹 (002)
1. 전투 화면에서 문제별 정답률 뱃지 확인 (첫 도전! / 정답률 N%)
2. 정답 시 결과 화면에서 "상위 N%" 표시 확인
3. 연속 정답으로 best_combo 갱신
4. 콤보 랭킹에 반영 확인

### Scenario 7: 주간 랭킹 + 시즌 (002)
1. 주간 EXP 획득 후 주간 랭킹 반영 확인
2. 월드맵에서 "이번 주 최강 모험가" 배너 확인
3. 랭킹 페이지 탭 전환 (종합/주간/분야별/콤보)
4. 명예의 전당 페이지 확인
