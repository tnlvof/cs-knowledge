import { MONSTER_GRADES } from "@/constants/monsters";
import { MONSTER_QUESTION_RANGE } from "@/constants/levels";

export function getMonsterGrade(userLevel: number) {
  const matching = MONSTER_GRADES.filter(
    (g) => userLevel >= g.levelMin && userLevel <= g.levelMax
  );
  return matching.length > 0
    ? matching[matching.length - 1]
    : MONSTER_GRADES[0];
}

export function getMonsterQuestionCount(): number {
  return (
    MONSTER_QUESTION_RANGE.MIN +
    Math.floor(
      Math.random() *
        (MONSTER_QUESTION_RANGE.MAX - MONSTER_QUESTION_RANGE.MIN + 1)
    )
  );
}
