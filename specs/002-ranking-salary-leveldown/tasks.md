# Tasks: 002 - 랭킹 · 예상연봉 · 레벨다운 · 정답률

**Input**: `/specs/002-ranking-salary-leveldown/plan.md`, `spec.md`, `data-model.md`
**Prerequisites**: 001-cs-quiz-rpg 전체 구현 완료

## Phase 1: Bun 전환 + DB 마이그레이션

**Purpose**: 패키지 매니저 전환 + 신규 테이블/컬럼 추가

- [X] T080 Bun 전환 (pnpm-lock.yaml 제거, bun install, bun.lock 생성, 001 quickstart 수정) - `package.json`, `bun.lock`
- [X] T081 DB 마이그레이션: profiles 테이블 컬럼 추가 (estimated_salary, best_combo, weekly_exp) - `supabase/migrations/010_alter_profiles.sql`
- [X] T082 DB 마이그레이션: questions 테이블 컬럼 추가 (total_attempts, correct_count, accuracy_rate) - `supabase/migrations/011_alter_questions.sql`
- [X] T083 [P] DB 마이그레이션: seasons 테이블 생성 - `supabase/migrations/012_create_seasons.sql`
- [X] T084 [P] DB 마이그레이션: hall_of_fame 테이블 생성 - `supabase/migrations/013_create_hall_of_fame.sql`
- [X] T085 [P] DB 마이그레이션: category_stats 테이블 생성 - `supabase/migrations/014_create_category_stats.sql`
- [X] T086 DB 마이그레이션: 랭킹 인덱스 생성 - `supabase/migrations/015_create_ranking_indexes.sql`
- [X] T087 DB 마이그레이션: RLS 정책 (seasons, hall_of_fame, category_stats) - `supabase/migrations/016_create_rls_ranking.sql`
- [X] T088 DB 마이그레이션: 주간 weekly_exp 초기화 cron 설정 - `supabase/migrations/017_create_weekly_reset_cron.sql`
- [X] T089 [P] TypeScript 타입 추가 (Season, HallOfFame, CategoryStats, 수정된 Profile/Question) - `src/types/`

**Checkpoint**: Bun 전환 완료 + DB 스키마 준비 ✅

---

## Phase 2: 레벨 다운 + 오답 페널티 (US10, P1)

**Goal**: 기존 EXP/레벨/전직 시스템 수정

- [X] T090 [US10] 레벨 구간별 오답 페널티 상수 정의 - `src/constants/levels.ts` 수정
- [X] T091 [US10] EXP 감소 로직 (오답 시 레벨 구간별 -50~-200, 연속 오답 추가 -30) - `src/lib/game-logic/exp.ts` 수정
- [X] T092 [US10] 레벨 다운 로직 (EXP < 0 → 레벨 -1 + 이전 레벨 EXP 상한에서 차감, Lv.1 바닥) - `src/lib/game-logic/exp.ts` 수정
- [X] T093 [US10] 전직 강등 로직 (전직 기준 레벨 아래 하락 시 이전 직업으로) - `src/lib/game-logic/job.ts` 수정
- [X] T094 [US10] 전투 로직에 오답 EXP 감소 반영 - `src/lib/game-logic/battle.ts` 수정
- [X] T095 [US10] answer API에 레벨 다운/전직 강등 응답 추가 - `src/app/api/battle/answer/route.ts` 수정
- [X] T096 [US10] 전투 hook에 레벨 다운/전직 강등 상태 반영 - `src/hooks/use-battle.ts` 수정
- [X] T097 [P] [US10] 레벨 다운 애니메이션 ("LEVEL DOWN..." + 어두워짐 + 캐릭터 풀죽기) - `src/components/animations/LevelDownEffect.tsx`
- [X] T098 [P] [US10] 전직 강등 애니메이션 - `src/components/animations/JobDemoteEffect.tsx`
- [X] T099 [US10] 결과 화면에 레벨 다운/강등 연출 통합 - `src/app/result/page.tsx` 수정

**Checkpoint**: 오답 → EXP 감소 → 레벨 다운 → 전직 강등 전체 플로우 작동 ✅

---

## Phase 3: 문제별 정답률 (US11, P2)

**Goal**: 퀴즈 화면에 정답률 표시 + 채점 시 정답률 갱신

- [X] T100 [US11] 정답률 색상 뱃지 컴포넌트 (초록/노랑/주황/빨강 + "첫 도전!") - `src/components/game/AccuracyBadge.tsx`
- [X] T101 [US11] 전투 화면에 정답률 표시 추가 - `src/app/battle/page.tsx` 수정
- [X] T102 [US11] answer API에서 정답률 갱신 (total_attempts++, 정답이면 correct_count++) - `src/app/api/battle/answer/route.ts` 수정
- [X] T103 [US11] 채점 결과에 "상위 N%" 표시 - `src/app/result/page.tsx` 수정
- [X] T104 [US11] 문제 출제 시 정답률 데이터 함께 반환 - `src/app/api/battle/start/route.ts` 수정

**Checkpoint**: 퀴즈에 정답률 표시 + 정답률 실시간 갱신 작동 ✅

---

## Phase 4: 랭킹 시스템 (US8, P2)

**Goal**: 5종 랭킹 + 시즌제 + 명예의 전당

- [X] T105 [US8] 종합 랭킹 API - `src/app/api/ranking/overall/route.ts`
- [X] T106 [US8] 주간 랭킹 API - `src/app/api/ranking/weekly/route.ts`
- [X] T107 [US8] 분야별 랭킹 API - `src/app/api/ranking/category/[category]/route.ts`
- [X] T108 [US8] 연속 정답 랭킹 API - `src/app/api/ranking/combo/route.ts`
- [X] T109 [US8] 내 순위 + 주변 ±5명 API - `src/app/api/ranking/me/route.ts`
- [X] T110 [US8] 명예의 전당 API - `src/app/api/ranking/hall-of-fame/route.ts`
- [X] T111 [US8] answer API에서 weekly_exp 갱신 + category_stats UPSERT + best_combo 갱신 - `src/app/api/battle/answer/route.ts` 수정
- [X] T112 [P] [US8] 랭킹 페이지 UI (탭: 종합/주간/분야별/콤보 + 내 순위 하이라이트) - `src/app/ranking/page.tsx`
- [X] T113 [P] [US8] 순위 변동 애니메이션 (+N↑) - `src/components/game/RankChange.tsx`
- [X] T114 [US8] 월드맵에 "이번 주 최강 모험가" 배너 - `src/components/game/WeeklyMVP.tsx`, `src/app/world/page.tsx` 수정
- [X] T115 [US8] 월드맵에 랭킹 메뉴 버튼 추가 - `src/app/world/page.tsx` 수정
- [X] T116 [US8] 시즌 종료 로직 (Edge Function: 1~3위 확정 → hall_of_fame INSERT → 칭호 부여 → weekly_exp 리셋) - `supabase/functions/season-end/`

**Checkpoint**: 5종 랭킹 + 시즌 + 명예의 전당 작동 ✅

---

## Phase 5: 예상 연봉 (US9, P3)

**Goal**: 프로필/카드에 연봉 표시

- [X] T117 [US9] 연봉 데이터 상수 (공공데이터 기반 분야별 중위 임금) - `src/constants/salary.ts`
- [X] T118 [US9] 연봉 산출 로직 (레벨 구간 기준 + 분야 보정) - `src/lib/game-logic/salary.ts`
- [X] T119 [US9] 연봉 표시 컴포넌트 - `src/components/game/SalaryDisplay.tsx`
- [X] T120 [US9] 내 프로필에 예상 연봉 표시 + 출처 표기 - `src/app/profile/page.tsx` 수정
- [X] T121 [US9] 공개 프로필에 예상 연봉 표시 - `src/app/profile/[nickname]/page.tsx` 수정
- [X] T122 [US9] OG 캐릭터 카드에 예상 연봉 추가 - `src/app/api/og/profile/[nickname]/route.tsx` 수정
- [X] T123 [US9] answer API에서 레벨 변동 시 estimated_salary 갱신 - `src/app/api/battle/answer/route.ts` 수정

**Checkpoint**: 프로필 + 카드 + 공유에 예상 연봉 표시 ✅

---

## Phase 6: Polish

- [X] T124 레벨 다운 시 진동 피드백 (모바일) - 애니메이션 컴포넌트
- [X] T125 랭킹 화면 빈 상태 UI ("아직 모험가가 없습니다") - `src/app/ranking/page.tsx`
- [X] T126 001 quickstart.md에서 pnpm → bun 전환 반영 - `specs/001-cs-quiz-rpg/quickstart.md` 수정
- [X] T127 전체 통합 테스트 (레벨 다운 → 랭킹 변동 → 연봉 변경 시나리오) - quickstart.md에 시나리오 추가

**Checkpoint**: Polish 완료 ✅

---

## Dependencies & Execution Order

- **Phase 1**: 즉시 시작 (DB 준비)
- **Phase 2**: Phase 1 완료 후 (레벨 다운은 핵심 게임 로직 수정)
- **Phase 3**: Phase 1 완료 후 (Phase 2와 병렬 가능하나, answer API 수정이 겹치므로 순차 권장)
- **Phase 4**: Phase 2, 3 완료 후 (랭킹은 EXP/정답률 데이터에 의존)
- **Phase 5**: Phase 2 완료 후 (연봉은 레벨 기반, Phase 4와 병렬 가능)
- **Phase 6**: 모든 Phase 완료 후

### Parallel Opportunities

- Phase 1: T081~T088 (마이그레이션) 병렬
- Phase 2: T097~T098 (애니메이션) 병렬
- Phase 4: T105~T110 (랭킹 API 6개) 병렬
- Phase 4 & Phase 5: 병렬 가능

## Summary

| Phase | Story | Tasks | Priority | Status |
|-------|-------|-------|----------|--------|
| 1. DB + Bun | - | 10 | - | ✅ |
| 2. 레벨 다운 | US10 | 10 | P1 | ✅ |
| 3. 정답률 | US11 | 5 | P2 | ✅ |
| 4. 랭킹 | US8 | 12 | P2 | ✅ |
| 5. 예상 연봉 | US9 | 7 | P3 | ✅ |
| 6. Polish | - | 4 | - | ✅ |
| **Total** | | **48** | | **All Done** |
