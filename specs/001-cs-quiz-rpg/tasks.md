# Tasks: MeAIple Story - CS Quiz RPG

**Input**: Design documents from `/specs/001-cs-quiz-rpg/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/api.md

## Phase 1: Setup

**Purpose**: 프로젝트 초기화 및 기본 구조

- [X] T001 Next.js 16 프로젝트 생성 (TypeScript, Tailwind CSS 4, App Router, src/) - `package.json`
- [X] T002 핵심 의존성 설치 (@supabase/supabase-js, @supabase/ssr, framer-motion, @google/generative-ai) - `package.json`
- [X] T003 [P] 환경변수 설정 (.env.local.example 생성) - `.env.local.example`
- [X] T004 [P] Tailwind CSS 4 커스텀 설정 (컬러 시스템, 폰트) - `tailwind.config.ts`
- [X] T005 [P] 모바일 전용 레이아웃 (max-width 430px, 중앙 정렬) - `src/app/layout.tsx`
- [X] T006 [P] TypeScript 타입 정의 (게임, API, DB) - `src/types/game.ts`, `src/types/api.ts`, `src/types/database.ts`
- [X] T007 [P] 게임 상수 정의 (레벨 테이블, 직업, 몬스터, 분야) - `src/constants/levels.ts`, `src/constants/jobs.ts`, `src/constants/monsters.ts`, `src/constants/categories.ts`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: 모든 User Story에 필요한 핵심 인프라

- [X] T008 Supabase 클라이언트 설정 (브라우저 + 서버) - `src/lib/supabase/client.ts`, `src/lib/supabase/server.ts`
- [X] T009 Supabase Auth 미들웨어 설정 - `src/lib/supabase/middleware.ts`, `src/middleware.ts`
- [X] T010 [P] DB 마이그레이션: profiles 테이블 - `supabase/migrations/001_create_profiles.sql`
- [X] T011 [P] DB 마이그레이션: questions 테이블 - `supabase/migrations/002_create_questions.sql`
- [X] T012 [P] DB 마이그레이션: monsters 테이블 - `supabase/migrations/003_create_monsters.sql`
- [X] T013 [P] DB 마이그레이션: quiz_history 테이블 - `supabase/migrations/004_create_quiz_history.sql`
- [X] T014 [P] DB 마이그레이션: battle_sessions 테이블 - `supabase/migrations/005_create_battle_sessions.sql`
- [X] T015 [P] DB 마이그레이션: shop_items, user_items 테이블 - `supabase/migrations/006_create_shop_items.sql`, `supabase/migrations/007_create_user_items.sql`
- [X] T016 [P] DB 마이그레이션: donations 테이블 - `supabase/migrations/008_create_donations.sql`
- [X] T017 DB 마이그레이션: RLS 정책 전체 적용 - `supabase/migrations/009_create_rls_policies.sql`
- [X] T018 [P] 시드 데이터: 초기 문제 은행 (8분야 x 50문제) - `supabase/seed.sql`
- [X] T019 [P] 시드 데이터: 몬스터 데이터 (7등급) - `supabase/seed.sql`
- [X] T020 [P] 시드 데이터: 아이템샵 상품 - `supabase/seed.sql`
- [X] T021 [P] localStorage 관리 유틸리티 (저장/로드/동기화) - `src/lib/storage/local-storage.ts`
- [X] T022 [P] 공통 UI 컴포넌트: Button, Card, Modal, Input - `src/components/ui/`
- [X] T023 [P] 게임 UI 컴포넌트: HPBar, EXPBar, LevelBadge - `src/components/game/`

**Checkpoint**: Foundation ready

---

## Phase 3: User Story 1 - 캐릭터 생성과 첫 전투 (Priority: P1)

**Goal**: 비로그인 사용자가 캐릭터를 생성하고 첫 퀴즈 전투를 체험한다

**Independent Test**: 캐릭터 생성 → 월드맵 → 전투 시작까지의 플로우

- [X] T024 [US1] 캐릭터 생성 페이지 UI (닉네임 + 외형 4종 선택) - `src/app/page.tsx`
- [X] T025 [US1] 캐릭터 생성 API (닉네임 유효성 + 중복 체크) - `src/app/api/game/create-character/route.ts`
- [X] T026 [US1] 게임 상태 관리 hook (localStorage 기반) - `src/hooks/use-game-state.ts`
- [X] T027 [US1] 월드맵(메인) 페이지 UI (IT 빌리지 + 캐릭터 표시 + 메뉴 버튼) - `src/app/world/page.tsx`
- [X] T028 [US1] 전투 시작 API (몬스터 + 첫 문제 배정) - `src/app/api/battle/start/route.ts`
- [X] T029 [US1] 몬스터 매칭 로직 (레벨 기반) - `src/lib/game-logic/monster.ts`

**Checkpoint**: 캐릭터 생성 → 월드맵 → 전투 시작 가능

---

## Phase 4: User Story 2 - 퀴즈 전투 & AI 채점 (Priority: P1)

**Goal**: 주관식 답변 → AI 채점 → 전투 결과 연출의 핵심 게임 루프

**Independent Test**: 문제 출제 → 답변 → 채점 → 결과 연출 → 다음 문제/전투 종료

- [X] T030 [US2] Gemini AI 채점 모듈 (프롬프트 + JSON 파싱 + 재시도) - `src/lib/gemini/grading.ts`
- [X] T030a [US2] 비로그인 AI 채점 전용 API (Auth 불필요, 채점만 수행) - `src/app/api/battle/grade/route.ts`
- [X] T031 [US2] 답변 제출 API (AI 채점 + 전투 상태 업데이트, Auth Required) - `src/app/api/battle/answer/route.ts`
- [X] T032 [US2] 전투 로직 (데미지 계산, HP 관리, 몬스터 처치 판정) - `src/lib/game-logic/battle.ts`
- [X] T032a [US2] 전투 로직: 오답 시 고정 20 HP 데미지 + 전투 시작 시 HP max 리셋 - `src/lib/game-logic/battle.ts`
- [X] T033 [US2] 전투 화면 UI (2D 사이드뷰, 몬스터, 퀴즈, 답변 입력) - `src/app/battle/page.tsx`
- [X] T033a [US2] 비로그인 전투 클라이언트 로직 (localStorage 기반 전투 상태 관리, grade API 호출) - `src/hooks/use-battle-guest.ts`
- [X] T034 [US2] 전투 상태 hook (실시간 HP/콤보/문제 관리) - `src/hooks/use-battle.ts`
- [X] T035 [P] [US2] 전투 애니메이션: 크리티컬 히트 이펙트 - `src/components/animations/CriticalHit.tsx`
- [X] T036 [P] [US2] 전투 애니메이션: 미스 + 반격 이펙트 - `src/components/animations/Miss.tsx`
- [X] T037 [P] [US2] 전투 애니메이션: 데미지 숫자 팝업 - `src/components/game/DamagePopup.tsx`
- [X] T038 [US2] 채점 결과 화면 UI (AI 해설 + 피드백 + 다음 문제) - `src/app/result/page.tsx`
- [X] T039 [US2] 전투 종료 API (세션 완료 처리) - `src/app/api/battle/end/route.ts`
- [X] T040 [US2] 전투 컴포넌트: MonsterCard, QuizArea, AnswerInput - `src/components/battle/`

**Checkpoint**: 완전한 퀴즈 전투 루프 작동

---

## Phase 5: User Story 3 - 캐릭터 성장 시스템 (Priority: P1)

**Goal**: EXP 획득 → 레벨업 → 자동전직의 성장 시스템

**Independent Test**: 연속 퀴즈 → 레벨업 연출 → 전직 연출

- [X] T041 [US3] EXP 계산 로직 (기본/부분/오답 + 콤보 보너스) - `src/lib/game-logic/exp.ts`
- [X] T042 [US3] 레벨업 판정 + 레벨업 데이터 업데이트 - `src/lib/game-logic/exp.ts`
- [X] T043 [US3] 자동전직 로직 (분야별 정답률 계산 + 직업 매핑) - `src/lib/game-logic/job.ts`
- [X] T044 [P] [US3] 레벨업 애니메이션 (빛기둥 + 코드 파티클) - `src/components/animations/LevelUpEffect.tsx`
- [X] T045 [P] [US3] 전직 애니메이션 (분야 아이콘 회전 + 빛 폭발) - `src/components/animations/JobChangeEffect.tsx`
- [X] T046 [US3] 전투 결과에 레벨업/전직 통합 (answer API 응답에 포함) - `src/app/api/battle/answer/route.ts` 업데이트

**Checkpoint**: 완전한 성장 시스템 (퀴즈→EXP→레벨업→전직) 작동

---

## Phase 6: User Story 4 - 비로그인 플레이 & 로그인 동기화 (Priority: P2)

**Goal**: localStorage 기반 비로그인 플레이 + Google OAuth 로그인 + 데이터 동기화

**Independent Test**: 비로그인 플레이 → 레벨 5 팝업 → Google 로그인 → 데이터 동기화

- [X] T047 [US4] Google OAuth 설정 (Supabase Auth) - `src/lib/supabase/` 업데이트
- [X] T048 [US4] Auth 콜백 라우트 - `src/app/api/auth/callback/route.ts`
- [X] T049 [US4] 인증 상태 hook - `src/hooks/use-auth.ts`
- [X] T050 [US4] localStorage → Supabase 동기화 API - `src/app/api/auth/sync/route.ts`
- [X] T051 [US4] 레벨 5 로그인 유도 팝업 컴포넌트 - `src/components/ui/LoginPrompt.tsx`
- [X] T052 [US4] 메뉴 "로그인" 버튼 (항상 노출) - `src/app/world/page.tsx` 업데이트

**Checkpoint**: 비로그인→로그인 전환 + 데이터 동기화 작동

---

## Phase 7: User Story 5 - 풀이 히스토리 & 오답 노트 (Priority: P2)

**Goal**: 퀴즈 풀이 기록 조회, 필터링, 오답 복습, 통계

**Independent Test**: 히스토리 타임라인 → 분야 필터 → 오답 노트 → 통계

- [X] T053 [US5] 히스토리 조회 API (페이지네이션 + 필터) - `src/app/api/history/route.ts`
- [X] T054 [P] [US5] 통계 API (분야별 정답률, 평균 점수) - `src/app/api/history/stats/route.ts`
- [X] T055 [P] [US5] 오답 노트 API - `src/app/api/history/wrong-notes/route.ts`
- [X] T056 [US5] 히스토리 페이지 UI (타임라인 + 필터 + 오답노트 + 통계 탭) - `src/app/history/page.tsx`

**Checkpoint**: 히스토리/오답노트/통계 모두 작동

---

## Phase 8: User Story 6 - 후원 & 아이템샵 (Priority: P3)

**Goal**: 토스페이먼츠 젬 충전 + 아이템샵 구매/장착 + 후원 뱃지

**Independent Test**: 젬 충전 → 아이템 구매 → 장착 → 뱃지 확인

- [X] T057 [US6] 결제 준비 API (orderId 생성) - `src/app/api/payment/ready/route.ts`
- [X] T058 [US6] 결제 승인 API (토스 승인 + 금액 검증 + 젬 지급) - `src/app/api/payment/confirm/route.ts`
- [X] T059 [US6] 토스페이먼츠 클라이언트 설정 - `src/lib/toss-payments/client.ts`
- [X] T060 [US6] 후원하기 페이지 UI (젬 패키지 선택 + 결제) - `src/app/donate/page.tsx`
- [X] T061 [P] [US6] 아이템샵 상품 목록 API - `src/app/api/shop/items/route.ts`
- [X] T062 [P] [US6] 아이템 구매 API (젬 차감 + 잔고 검증) - `src/app/api/shop/purchase/route.ts`
- [X] T063 [P] [US6] 아이템 장착/해제 API - `src/app/api/shop/equip/route.ts`
- [X] T064 [P] [US6] 인벤토리 API - `src/app/api/shop/inventory/route.ts`
- [X] T065 [US6] 아이템샵 페이지 UI (카테고리별 아이템 + 구매/장착) - `src/app/shop/page.tsx`
- [X] T066 [US6] 후원 뱃지 로직 (누적 금액별 티어 계산) - `src/lib/game-logic/` 추가
- [X] T067 [US6] 후원 내역 API - `src/app/api/payment/history/route.ts`

**Checkpoint**: 결제 → 아이템 구매/장착 → 뱃지 시스템 작동

---

## Phase 9: User Story 7 - 캐릭터 자랑하기 & 공개 프로필 (Priority: P3)

**Goal**: 캐릭터 카드 이미지 생성 + 공개 프로필 + SNS 공유

**Independent Test**: 카드 이미지 생성 → 공개 프로필 접근 → OG 미리보기 확인

- [X] T068 [US7] OG 캐릭터 카드 이미지 생성 API (ImageResponse) - `src/app/api/og/profile/[nickname]/route.ts`
- [X] T069 [US7] 공개 프로필 데이터 API - `src/app/api/profile/[nickname]/route.ts`
- [X] T070 [US7] 공개 프로필 페이지 (카드 + 레이더 차트 + OG 메타) - `src/app/profile/[nickname]/page.tsx`
- [X] T071 [US7] 캐릭터 프로필 페이지 (스탯 + 장착 아이템) - `src/app/profile/page.tsx`
- [X] T072 [US7] 자랑하기 기능 (링크 복사, 이미지 저장, Web Share API) - `src/components/ui/ShareButton.tsx`
- [X] T073 [US7] 프로필 API - `src/app/api/game/profile/route.ts`

**Checkpoint**: 캐릭터 카드 + 공개 프로필 + 공유 작동

---

## Phase 10: Polish & Cross-Cutting Concerns

**Purpose**: 전체 품질 향상

- [X] T074 [P] 진동 피드백 (모바일 레벨업/전직 시) - 전체 애니메이션 컴포넌트
- [X] T075 [P] 에러 바운더리 + 로딩 UI + 빈 상태 UI - `src/components/ui/`
- [X] T076 [P] SEO 최적화 (메타태그, sitemap, robots.txt) - `src/app/layout.tsx`, `public/`
- [X] T077 성능 최적화 (이미지 최적화, 코드 스플리팅, 애니메이션 GPU 가속) - 전체
- [X] T078 보안 검증 (RLS 테스트, API 인증 체크, 결제 금액 검증) - 전체 API
- [X] T079 quickstart.md 시나리오 4개 전체 검증 - E2E

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: 즉시 시작
- **Phase 2 (Foundational)**: Phase 1 완료 후 → 모든 User Story 차단
- **Phase 3~5 (US1~3, P1)**: Phase 2 완료 후 순차 (핵심 루프는 순서 의존)
- **Phase 6~7 (US4~5, P2)**: Phase 5 완료 후 (성장 시스템 필요)
- **Phase 8~9 (US6~7, P3)**: Phase 6 완료 후 (로그인 필요)
- **Phase 10 (Polish)**: 모든 User Story 완료 후

### Parallel Opportunities

- Phase 1: T003~T007 병렬
- Phase 2: T010~T016 (DB 마이그레이션) 병렬, T018~T023 (시드+UI) 병렬
- Phase 4: T035~T037 (애니메이션) 병렬
- Phase 7: T054~T055 병렬
- Phase 8: T061~T064 병렬

---

## Summary

| Phase | Story | Tasks | Parallel |
|-------|-------|-------|----------|
| 1. Setup | - | 7 | 5 |
| 2. Foundational | - | 16 | 12 |
| 3. US1 캐릭터+첫전투 | P1 | 6 | 0 |
| 4. US2 퀴즈전투+AI | P1 | 11 | 3 |
| 5. US3 성장시스템 | P1 | 6 | 2 |
| 6. US4 로그인동기화 | P2 | 6 | 0 |
| 7. US5 히스토리 | P2 | 4 | 2 |
| 8. US6 후원+아이템샵 | P3 | 11 | 4 |
| 9. US7 프로필+공유 | P3 | 6 | 0 |
| 10. Polish | - | 6 | 3 |
| **Total** | | **82** | **31** |

**MVP Scope**: Phase 1~5 (US1+US2+US3) = 49 tasks
