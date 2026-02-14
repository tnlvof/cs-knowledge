# Implementation Plan: 002 - 랭킹 · 예상연봉 · 레벨다운 · 정답률

**Branch**: `002-ranking-salary-leveldown` | **Date**: 2026-02-13 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-ranking-salary-leveldown/spec.md`
**Depends On**: `001-cs-quiz-rpg` 구현 완료

## Summary

기존 메AI플스토리에 경쟁/긴장감 요소를 추가한다. 레벨 다운은 기존 게임 로직 수정, 랭킹은 신규 DB+API+UI, 예상 연봉은 클라이언트 계산 로직+UI, 정답률은 DB 컬럼 추가+UI 표시. Bun 전환은 프로젝트 전반에 영향.

## Technical Context

- **기존 스택 유지**: Next.js 16 + TypeScript + Supabase + Tailwind + Framer Motion
- **패키지 매니저 변경**: pnpm → **Bun**
- **신규 의존성 없음** (기존 스택으로 모두 구현 가능)
- **Supabase pg_cron**: 주간 랭킹 초기화, 시즌 전환 자동화

## 변경 영향도 분석

### 기존 코드 수정이 필요한 부분

| 파일 | 변경 내용 | 영향도 |
|------|---------|--------|
| `src/lib/game-logic/exp.ts` | 오답 시 +10 → -50~-200 감소 + 레벨 다운 로직 | **높음** (핵심 게임 밸런스) |
| `src/lib/game-logic/job.ts` | 전직 강등 로직 추가 | **높음** |
| `src/lib/game-logic/battle.ts` | 오답 EXP 감소 호출 반영 | 중간 |
| `src/app/api/battle/answer/route.ts` | 정답률 갱신 + weekly_exp 갱신 + category_stats 갱신 | 중간 |
| `src/app/api/battle/grade/route.ts` | 비로그인도 정답률 표시 위해 정답률 데이터 반환 | 낮음 |
| `src/hooks/use-battle.ts` | 레벨 다운/전직 강등 상태 반영 | 중간 |
| `src/app/battle/page.tsx` | 정답률 표시 UI 추가 | 낮음 |
| `src/app/result/page.tsx` | "상위 N%" 표시 + 레벨 다운 연출 분기 | 중간 |
| `src/app/api/og/profile/[nickname]/route.ts` | 예상 연봉 카드에 추가 | 낮음 |
| `src/app/profile/[nickname]/page.tsx` | 예상 연봉 표시 추가 | 낮음 |
| `src/app/profile/page.tsx` | 예상 연봉 표시 추가 | 낮음 |
| `src/app/world/page.tsx` | 주간 1위 "이번 주 최강 모험가" 배너 + 랭킹 메뉴 버튼 | 중간 |
| `src/types/game.ts` | 신규 타입 추가 | 낮음 |
| `src/types/database.ts` | 신규 테이블 타입 추가 | 낮음 |
| `src/constants/levels.ts` | 레벨 구간별 오답 페널티 테이블 추가 | 낮음 |
| `quickstart.md` (001) | pnpm → bun 전환 반영 | 낮음 |
| `package.json` | scripts에서 bun 사용 | 낮음 |

### 신규 생성 파일

| 파일 | 설명 |
|------|------|
| `src/app/ranking/page.tsx` | 랭킹 화면 UI |
| `src/app/api/ranking/overall/route.ts` | 종합 랭킹 API |
| `src/app/api/ranking/weekly/route.ts` | 주간 랭킹 API |
| `src/app/api/ranking/category/[category]/route.ts` | 분야별 랭킹 API |
| `src/app/api/ranking/combo/route.ts` | 콤보 랭킹 API |
| `src/app/api/ranking/me/route.ts` | 내 순위 API |
| `src/app/api/ranking/hall-of-fame/route.ts` | 명예의 전당 API |
| `src/lib/game-logic/salary.ts` | 예상 연봉 산출 로직 |
| `src/lib/game-logic/ranking.ts` | 랭킹 유틸리티 |
| `src/constants/salary.ts` | 연봉 데이터 (공공데이터 기반 상수) |
| `src/components/animations/LevelDownEffect.tsx` | 레벨 다운 연출 |
| `src/components/animations/JobDemoteEffect.tsx` | 전직 강등 연출 |
| `src/components/game/AccuracyBadge.tsx` | 정답률 색상 뱃지 |
| `src/components/game/RankChange.tsx` | 순위 변동 애니메이션 |
| `src/components/game/SalaryDisplay.tsx` | 예상 연봉 표시 |
| `src/components/game/WeeklyMVP.tsx` | 주간 1위 배너 |
| DB 마이그레이션 7개 | 010~017 |

## Bun 전환

```bash
# 기존 pnpm 관련 파일 제거
rm -f pnpm-lock.yaml

# Bun으로 재설치
bun install

# 스크립트 실행 방식 변경
bun run dev        # (기존: pnpm dev)
bun run build      # (기존: pnpm build)
bun test           # (기존: pnpm test)
```

- `package.json`의 scripts는 그대로 유지 (bun run으로 호출)
- CI/CD(Vercel)에서 Bun 빌드 설정 필요
- `bun.lock` 생성됨

## 연봉 산출 로직 (클라이언트 사이드)

```typescript
// src/lib/game-logic/salary.ts
// src/constants/salary.ts에서 데이터 임포트

const BASE_SALARY: Record<string, number> = {
  // 레벨 구간별 기준 연봉 (만원)
  '1-10': 2400,
  '11-25': 3500,
  '26-40': 4500,
  '41-55': 5500,
  '56-70': 7000,
  '71-85': 9000,
  '86-95': 12000,
  '96-100': 20000,
};

const CATEGORY_MEDIAN_SALARY: Record<string, number> = {
  // 한국고용정보원 공공데이터 기반 (만원)
  network: 5200,    // 네트워크 엔지니어
  linux: 5000,      // 시스템 엔지니어
  db: 5400,         // DBA
  deploy: 5800,     // 데브옵스
  monitoring: 4800, // 시스템 운영
  security: 6200,   // 정보보안 전문가
  architecture: 7000, // 소프트웨어 아키텍트
  sre: 6000,        // SRE
};

function calculateSalary(level: number, topCategory: string, highAccuracyCount: number): number {
  const base = getBaseSalary(level);
  const categoryBonus = getCategoryBonus(topCategory);
  const multiSkillBonus = highAccuracyCount >= 2 ? 300 + (highAccuracyCount - 2) * 200 : 0;
  return base + categoryBonus + multiSkillBonus;
}
```
