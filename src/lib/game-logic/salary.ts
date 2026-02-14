import {
  BASE_SALARY_TABLE,
  CATEGORY_MEDIAN_SALARY,
  BASE_CATEGORY_SALARY,
} from "@/constants/salary";

/**
 * 레벨 구간에 해당하는 기준 연봉을 반환
 */
function getBaseSalary(level: number): number {
  const clampedLevel = Math.min(Math.max(1, level), 100);
  const entry = BASE_SALARY_TABLE.find(
    (e) => clampedLevel >= e.levelMin && clampedLevel <= e.levelMax
  );
  return entry?.salary ?? BASE_SALARY_TABLE[0].salary;
}

/**
 * 분야별 보정 금액 계산
 * 해당 분야 중위 임금과 기준점(5000만원)의 차이를 10으로 나눈 값
 */
function getCategoryBonus(topCategory: string | null): number {
  if (!topCategory) return 0;
  const medianSalary = CATEGORY_MEDIAN_SALARY[topCategory];
  if (!medianSalary) return 0;
  return Math.round((medianSalary - BASE_CATEGORY_SALARY) / 10);
}

/**
 * 멀티 스킬 보너스 계산
 * 높은 정답률(70%+)인 분야가 2개 이상일 때 보너스 부여
 * - 2개: 300만원
 * - 3개 이상: 300 + (count - 2) * 200만원
 */
function getMultiSkillBonus(highAccuracyCount: number): number {
  if (highAccuracyCount < 2) return 0;
  return 300 + (highAccuracyCount - 2) * 200;
}

/**
 * 예상 연봉 산출
 * @param level 현재 레벨
 * @param topCategory 주력 분야 (정답 수 기준)
 * @param highAccuracyCount 70%+ 정답률인 분야 개수
 * @returns 예상 연봉 (만원)
 */
export function calculateSalary(
  level: number,
  topCategory: string | null,
  highAccuracyCount: number
): number {
  // Input validation
  const clampedLevel = Math.min(Math.max(1, level), 100);
  const baseSalary = getBaseSalary(clampedLevel);
  const categoryBonus = getCategoryBonus(topCategory);
  const multiSkillBonus = getMultiSkillBonus(highAccuracyCount);

  return baseSalary + categoryBonus + multiSkillBonus;
}

/**
 * 연봉을 포맷팅된 문자열로 반환
 * @param salary 연봉 (만원)
 * @returns 포맷팅된 문자열 (예: "5,800")
 */
export function formatSalary(salary: number): string {
  return salary.toLocaleString("ko-KR");
}
