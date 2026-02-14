import type { Category } from "@/types/game";

export interface CategoryInfo {
  id: Category;
  name: string;
  description: string;
  emoji: string;
  color: string;
}

export const CATEGORIES: CategoryInfo[] = [
  {
    id: "network",
    name: "네트워크",
    description: "TCP/IP, HTTP, DNS, 로드밸런싱",
    emoji: "🌐",
    color: "#4ECDC4",
  },
  {
    id: "linux",
    name: "Linux/OS",
    description: "리눅스 명령어, 프로세스, 파일시스템",
    emoji: "🐧",
    color: "#FFA500",
  },
  {
    id: "db",
    name: "데이터베이스",
    description: "SQL, 인덱싱, 트랜잭션, 복제",
    emoji: "🗄️",
    color: "#9B59B6",
  },
  {
    id: "deploy",
    name: "배포/CI-CD",
    description: "Docker, K8s, 배포 전략, 파이프라인",
    emoji: "🚀",
    color: "#3498DB",
  },
  {
    id: "monitoring",
    name: "모니터링",
    description: "로깅, 메트릭, 알림, APM",
    emoji: "📊",
    color: "#2ECC71",
  },
  {
    id: "security",
    name: "보안",
    description: "인증, 암호화, 취약점, 방화벽",
    emoji: "🛡️",
    color: "#E74C3C",
  },
  {
    id: "architecture",
    name: "아키텍처",
    description: "MSA, 캐싱, 메시지 큐, 설계 패턴",
    emoji: "☁️",
    color: "#1ABC9C",
  },
  {
    id: "sre",
    name: "장애/SRE",
    description: "장애 대응, SLO/SLA, 카오스 엔지니어링",
    emoji: "🔥",
    color: "#E67E22",
  },
];

export const CATEGORY_MAP = Object.fromEntries(
  CATEGORIES.map((c) => [c.id, c])
) as Record<Category, CategoryInfo>;
