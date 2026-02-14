// 레벨별 필요 EXP 테이블 (1~100)
// 공식: baseExp * (1 + (level-1) * 0.15) → 점진적 증가

export interface LevelInfo {
  level: number;
  requiredExp: number;
  totalExp: number;
  tier: string;
  tierName: string;
}

export const TIER_NAMES: Record<string, string> = {
  trainee: "수습",
  apprentice: "견습",
  regular: "정식",
  veteran: "베테랑",
  master: "마스터",
  legend: "전설",
};

function getTier(level: number): string {
  if (level < 10) return "trainee";
  if (level < 30) return "apprentice";
  if (level < 50) return "regular";
  if (level < 70) return "veteran";
  if (level < 90) return "master";
  return "legend";
}

function calculateRequiredExp(level: number): number {
  const base = 100;
  return Math.floor(base * (1 + (level - 1) * 0.15));
}

// 레벨 테이블 생성
export const LEVEL_TABLE: LevelInfo[] = (() => {
  const table: LevelInfo[] = [];
  let totalExp = 0;

  for (let level = 1; level <= 100; level++) {
    const requiredExp = calculateRequiredExp(level);
    const tier = getTier(level);
    table.push({
      level,
      requiredExp,
      totalExp,
      tier,
      tierName: TIER_NAMES[tier],
    });
    totalExp += requiredExp;
  }

  return table;
})();

// EXP 보상 상수
export const EXP_REWARDS = {
  CORRECT: 100,
  PARTIAL_MIN: 30,
  PARTIAL_MAX: 70,
  MONSTER_KILL_BONUS: 50,
  FIRST_SHARE_BONUS: 50,
} as const;

// 콤보 보너스 배율
export const COMBO_MULTIPLIERS: Record<number, number> = {
  3: 1.5,
  5: 2.0,
  10: 3.0,
};

// 전직 레벨
export const JOB_CHANGE_LEVELS = [10, 30, 50, 70, 90] as const;

// HP 상수
export const HP_CONSTANTS = {
  DEFAULT_MAX_HP: 100,
  WRONG_ANSWER_DAMAGE: 20,
} as const;

// 몬스터 문제 수
export const MONSTER_QUESTION_RANGE = {
  MIN: 3,
  MAX: 5,
} as const;

// 레벨 구간별 오답 EXP 페널티
export const WRONG_ANSWER_PENALTY: Record<string, number> = {
  '1-10': 50,
  '11-30': 50,
  '31-50': 70,
  '51-70': 100,
  '71-90': 150,
  '91-100': 200,
};

// 연속 오답 추가 페널티
export const CONSECUTIVE_WRONG_BONUS_PENALTY = 30;
export const CONSECUTIVE_WRONG_THRESHOLD = 3;

export function getWrongAnswerPenalty(level: number): number {
  if (level <= 10) return WRONG_ANSWER_PENALTY['1-10'];
  if (level <= 30) return WRONG_ANSWER_PENALTY['11-30'];
  if (level <= 50) return WRONG_ANSWER_PENALTY['31-50'];
  if (level <= 70) return WRONG_ANSWER_PENALTY['51-70'];
  if (level <= 90) return WRONG_ANSWER_PENALTY['71-90'];
  return WRONG_ANSWER_PENALTY['91-100'];
}
