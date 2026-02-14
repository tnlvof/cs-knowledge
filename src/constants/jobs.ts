import type { Category } from "@/types/game";

export interface JobDefinition {
  id: string;
  name: string;
  category: Category;
  description: string;
  emoji: string;
}

// 8개 분야별 직업
export const JOBS: JobDefinition[] = [
  {
    id: "network_engineer",
    name: "네트워크 엔지니어",
    category: "network",
    description: "TCP/IP와 HTTP의 달인",
    emoji: "🌐",
  },
  {
    id: "linux_admin",
    name: "리눅스 관리자",
    category: "linux",
    description: "서버 OS의 수호자",
    emoji: "🐧",
  },
  {
    id: "db_architect",
    name: "DB 아키텍트",
    category: "db",
    description: "데이터의 설계자",
    emoji: "🗄️",
  },
  {
    id: "devops_engineer",
    name: "DevOps 엔지니어",
    category: "deploy",
    description: "배포 파이프라인의 마스터",
    emoji: "🚀",
  },
  {
    id: "monitoring_specialist",
    name: "모니터링 전문가",
    category: "monitoring",
    description: "시스템 관찰의 눈",
    emoji: "📊",
  },
  {
    id: "security_analyst",
    name: "보안 분석가",
    category: "security",
    description: "시스템 방어의 방패",
    emoji: "🛡️",
  },
  {
    id: "cloud_architect",
    name: "클라우드 아키텍트",
    category: "architecture",
    description: "인프라 설계의 대가",
    emoji: "☁️",
  },
  {
    id: "sre_engineer",
    name: "SRE 엔지니어",
    category: "sre",
    description: "장애 대응의 소방관",
    emoji: "🔥",
  },
];

// 기본 직업 (전직 전)
export const DEFAULT_JOB = {
  id: "novice",
  name: "모험가",
  description: "CS 세계를 탐험하는 초보 모험가",
  emoji: "⚔️",
};

// 전직 단계별 접두사
export const JOB_TIER_PREFIX: Record<number, string> = {
  0: "",
  1: "초급 ",
  2: "중급 ",
  3: "고급 ",
  4: "최고급 ",
  5: "전설의 ",
};
