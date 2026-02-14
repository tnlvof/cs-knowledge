// 레벨 구간별 기준 연봉 (만원)
export const BASE_SALARY_TABLE: {
  levelMin: number;
  levelMax: number;
  salary: number;
}[] = [
  { levelMin: 1, levelMax: 10, salary: 2400 },
  { levelMin: 11, levelMax: 25, salary: 3500 },
  { levelMin: 26, levelMax: 40, salary: 4500 },
  { levelMin: 41, levelMax: 55, salary: 5500 },
  { levelMin: 56, levelMax: 70, salary: 7000 },
  { levelMin: 71, levelMax: 85, salary: 9000 },
  { levelMin: 86, levelMax: 95, salary: 12000 },
  { levelMin: 96, levelMax: 100, salary: 20000 },
];

// 한국고용정보원 공공데이터 기반 분야별 중위 임금 (만원)
export const CATEGORY_MEDIAN_SALARY: Record<string, number> = {
  network: 5200, // 네트워크 엔지니어
  linux: 5000, // 시스템 엔지니어
  db: 5400, // DBA
  deploy: 5800, // 데브옵스
  monitoring: 4800, // 시스템 운영
  security: 6200, // 정보보안 전문가
  architecture: 7000, // 소프트웨어 아키텍트
  sre: 6000, // SRE
};

// 기준 연봉 (분야 보정 기준점)
export const BASE_CATEGORY_SALARY = 5000;
