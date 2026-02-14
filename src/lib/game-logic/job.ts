import type { Category } from "@/types/game";
import { JOBS } from "@/constants/jobs";
import { JOB_CHANGE_LEVELS } from "@/constants/levels";

export interface JobChangeResult {
  shouldChange: boolean;
  newJobClass: string | null;
  newJobTier: number;
  topCategory: Category | null;
}

export function checkJobChange(params: {
  newLevel: number;
  oldLevel: number;
  categoryStats: Record<Category, { correct: number; total: number }>;
}): JobChangeResult {
  const { newLevel, oldLevel, categoryStats } = params;

  // 전직 레벨에 도달했는지 확인
  const triggeredLevel = JOB_CHANGE_LEVELS.find(
    (lvl) => newLevel >= lvl && oldLevel < lvl
  );

  if (!triggeredLevel) {
    return {
      shouldChange: false,
      newJobClass: null,
      newJobTier: 0,
      topCategory: null,
    };
  }

  // 최고 정답률 분야 결정
  let topCategory: Category | null = null;
  let topRate = -1;

  for (const [category, stats] of Object.entries(categoryStats)) {
    if (stats.total === 0) continue;
    const rate = stats.correct / stats.total;
    if (rate > topRate) {
      topRate = rate;
      topCategory = category as Category;
    }
  }

  if (!topCategory) {
    return {
      shouldChange: false,
      newJobClass: null,
      newJobTier: 0,
      topCategory: null,
    };
  }

  // 해당 분야의 직업 찾기
  const job = JOBS.find((j) => j.category === topCategory);
  const tierIndex = JOB_CHANGE_LEVELS.indexOf(triggeredLevel as typeof JOB_CHANGE_LEVELS[number]);

  return {
    shouldChange: true,
    newJobClass: job?.id ?? "novice",
    newJobTier: tierIndex + 1,
    topCategory,
  };
}

export interface JobDemoteResult {
  shouldDemote: boolean;
  newJobTier: number;
  oldJobTier: number;
}

export function checkJobDemotion(params: {
  newLevel: number;
  oldLevel: number;
  currentJobTier: number;
}): JobDemoteResult {
  const { newLevel, oldLevel, currentJobTier } = params;

  // 레벨이 올라갔거나 같으면 강등 없음
  if (newLevel >= oldLevel) {
    return {
      shouldDemote: false,
      newJobTier: currentJobTier,
      oldJobTier: currentJobTier,
    };
  }

  // 현재 tier가 0이면 강등할 수 없음
  if (currentJobTier <= 0) {
    return {
      shouldDemote: false,
      newJobTier: 0,
      oldJobTier: 0,
    };
  }

  // 전직 레벨 경계를 넘어 내려갔는지 확인
  // JOB_CHANGE_LEVELS = [10, 30, 50, 70, 90]
  // tier 1 = level 10+, tier 2 = level 30+, tier 3 = level 50+, etc.

  // 현재 tier에 해당하는 최소 레벨 찾기
  const currentTierMinLevel = JOB_CHANGE_LEVELS[currentJobTier - 1];

  // 새 레벨이 현재 tier 유지 조건을 충족하지 않으면 강등
  if (currentTierMinLevel !== undefined && newLevel < currentTierMinLevel) {
    // 새 레벨에 맞는 tier 계산
    let newTier = 0;
    for (let i = JOB_CHANGE_LEVELS.length - 1; i >= 0; i--) {
      if (newLevel >= JOB_CHANGE_LEVELS[i]) {
        newTier = i + 1;
        break;
      }
    }

    return {
      shouldDemote: true,
      newJobTier: newTier,
      oldJobTier: currentJobTier,
    };
  }

  return {
    shouldDemote: false,
    newJobTier: currentJobTier,
    oldJobTier: currentJobTier,
  };
}

// 레벨에 해당하는 최대 가능 tier 계산
export function getMaxTierForLevel(level: number): number {
  let maxTier = 0;
  for (let i = JOB_CHANGE_LEVELS.length - 1; i >= 0; i--) {
    if (level >= JOB_CHANGE_LEVELS[i]) {
      maxTier = i + 1;
      break;
    }
  }
  return maxTier;
}
