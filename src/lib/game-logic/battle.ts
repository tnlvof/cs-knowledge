import type { GradingResult } from "@/types/game";
import { HP_CONSTANTS } from "@/constants/levels";

export interface DamageResult {
  damageDealt: number;
  damageTaken: number;
  newMonsterHp: number;
  newUserHp: number;
  monsterDefeated: boolean;
  userDefeated: boolean;
}

export function calculateDamage(params: {
  score: number;
  isCorrect: GradingResult;
  monsterHp: number;
  monsterMaxHp: number;
  userHp: number;
}): DamageResult {
  const { score, isCorrect, monsterHp, monsterMaxHp, userHp } = params;
  const safeMonsterMaxHp = Math.max(1, monsterMaxHp);

  let damageDealt = 0;
  let damageTaken = 0;

  switch (isCorrect) {
    case "correct":
      // 정답: 몬스터 max HP의 25~35% 데미지
      damageDealt = Math.floor(safeMonsterMaxHp * (0.25 + score * 0.1));
      break;
    case "partial":
      // 부분정답: 몬스터 max HP의 10~20% 데미지
      damageDealt = Math.floor(safeMonsterMaxHp * (0.1 + score * 0.1));
      break;
    case "wrong":
      // 오답: 데미지 없음 + 반격
      damageDealt = 0;
      damageTaken = HP_CONSTANTS.WRONG_ANSWER_DAMAGE;
      break;
  }

  const newMonsterHp = Math.max(0, monsterHp - damageDealt);
  const newUserHp = Math.max(0, userHp - damageTaken);

  return {
    damageDealt,
    damageTaken,
    newMonsterHp,
    newUserHp,
    monsterDefeated: newMonsterHp <= 0,
    userDefeated: newUserHp <= 0,
  };
}
