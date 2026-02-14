import type { GradingResult } from "@/types/game";
import {
  EXP_REWARDS,
  COMBO_MULTIPLIERS,
  LEVEL_TABLE,
  getWrongAnswerPenalty,
  CONSECUTIVE_WRONG_BONUS_PENALTY,
  CONSECUTIVE_WRONG_THRESHOLD,
} from "@/constants/levels";

export interface ExpResult {
  baseExp: number;
  comboMultiplier: number;
  totalExp: number;
  newComboCount: number;
  consecutiveWrongCount: number;
}

export function calculateExp(params: {
  isCorrect: GradingResult;
  score: number;
  comboCount: number;
  currentLevel: number;
  consecutiveWrongCount?: number;
}): ExpResult {
  const { isCorrect, score, comboCount, currentLevel, consecutiveWrongCount = 0 } = params;

  let baseExp: number;
  let newComboCount: number;
  let newConsecutiveWrongCount: number;

  switch (isCorrect) {
    case "correct":
      baseExp = EXP_REWARDS.CORRECT;
      newComboCount = comboCount + 1;
      newConsecutiveWrongCount = 0; // 정답 시 연속 오답 리셋
      break;
    case "partial":
      baseExp = Math.floor(
        EXP_REWARDS.PARTIAL_MIN +
          (EXP_REWARDS.PARTIAL_MAX - EXP_REWARDS.PARTIAL_MIN) * score
      );
      newComboCount = comboCount + 1;
      newConsecutiveWrongCount = 0; // 부분 정답도 연속 오답 리셋
      break;
    case "wrong":
      // 오답: 레벨별 페널티 적용
      const basePenalty = getWrongAnswerPenalty(currentLevel);
      const newWrongCount = consecutiveWrongCount + 1;

      // 3연속 이상 오답 시 추가 페널티
      const extraPenalty = newWrongCount >= CONSECUTIVE_WRONG_THRESHOLD
        ? CONSECUTIVE_WRONG_BONUS_PENALTY
        : 0;

      baseExp = -(basePenalty + extraPenalty); // 음수 EXP
      newComboCount = 0; // 콤보 리셋
      newConsecutiveWrongCount = newWrongCount;
      break;
    default: {
      const _exhaustiveCheck: never = isCorrect;
      throw new Error(`Unknown grading result: ${_exhaustiveCheck}`);
    }
  }

  // 콤보 보너스 결정 (새 콤보 수 기준) - 양수 EXP에만 적용
  let comboMultiplier = 1;
  if (baseExp > 0) {
    const sortedThresholds = Object.keys(COMBO_MULTIPLIERS)
      .map(Number)
      .sort((a, b) => b - a);

    for (const threshold of sortedThresholds) {
      if (newComboCount >= threshold) {
        comboMultiplier = COMBO_MULTIPLIERS[threshold];
        break;
      }
    }
  }

  const totalExp = Math.floor(baseExp * comboMultiplier);

  return {
    baseExp,
    comboMultiplier,
    totalExp,
    newComboCount,
    consecutiveWrongCount: newConsecutiveWrongCount,
  };
}

export interface LevelUpResult {
  leveledUp: boolean;
  newLevel: number;
  newExp: number;
  levelsGained: number;
}

export function checkLevelUp(params: {
  currentLevel: number;
  currentExp: number;
  expToAdd: number;
}): LevelUpResult {
  let { currentLevel, currentExp } = params;
  const newExp = currentExp + params.expToAdd;
  let remainingExp = newExp;
  let levelsGained = 0;

  while (currentLevel < 100) {
    const levelInfo = LEVEL_TABLE[currentLevel - 1];
    if (!levelInfo) break;

    if (remainingExp >= levelInfo.requiredExp) {
      remainingExp -= levelInfo.requiredExp;
      currentLevel++;
      levelsGained++;
    } else {
      break;
    }
  }

  return {
    leveledUp: levelsGained > 0,
    newLevel: currentLevel,
    newExp: remainingExp,
    levelsGained,
  };
}

export interface LevelDownResult {
  leveledDown: boolean;
  newLevel: number;
  newExp: number;
  levelsLost: number;
}

export function checkLevelDown(params: {
  currentLevel: number;
  currentExp: number;
  expToSubtract: number;
}): LevelDownResult {
  let { currentLevel, currentExp } = params;
  let remainingExp = currentExp - params.expToSubtract;
  let levelsLost = 0;

  // EXP가 음수가 되면 레벨 다운
  while (remainingExp < 0 && currentLevel > 1) {
    currentLevel--;
    levelsLost++;
    // 이전 레벨의 최대 EXP를 가져옴
    const prevLevelInfo = LEVEL_TABLE[currentLevel - 1];
    if (!prevLevelInfo) break;
    remainingExp += prevLevelInfo.requiredExp;
  }

  // 레벨 1 이하로 떨어지면 바닥 처리
  if (currentLevel <= 1 && remainingExp < 0) {
    currentLevel = 1;
    remainingExp = 0;
  }

  return {
    leveledDown: levelsLost > 0,
    newLevel: currentLevel,
    newExp: Math.max(0, remainingExp),
    levelsLost,
  };
}

// 통합 레벨 변화 체크 함수
export interface LevelChangeResult {
  levelUp: boolean;
  levelDown: boolean;
  newLevel: number;
  newExp: number;
  levelsChanged: number;
}

export function checkLevelChange(params: {
  currentLevel: number;
  currentExp: number;
  expChange: number;
}): LevelChangeResult {
  const { currentLevel, currentExp, expChange } = params;

  if (expChange >= 0) {
    // 양수 EXP: 레벨업 체크
    const result = checkLevelUp({
      currentLevel,
      currentExp,
      expToAdd: expChange,
    });
    return {
      levelUp: result.leveledUp,
      levelDown: false,
      newLevel: result.newLevel,
      newExp: result.newExp,
      levelsChanged: result.levelsGained,
    };
  } else {
    // 음수 EXP: 레벨다운 체크
    const result = checkLevelDown({
      currentLevel,
      currentExp,
      expToSubtract: Math.abs(expChange),
    });
    return {
      levelUp: false,
      levelDown: result.leveledDown,
      newLevel: result.newLevel,
      newExp: result.newExp,
      levelsChanged: result.levelsLost,
    };
  }
}
