// CS 분야
export type Category =
  | "network"
  | "linux"
  | "db"
  | "deploy"
  | "monitoring"
  | "security"
  | "architecture"
  | "sre";

// 채점 결과
export type GradingResult = "correct" | "partial" | "wrong";

// 전투 상태
export type BattleStatus = "active" | "victory" | "defeat";

// 후원 뱃지 티어
export type SupporterTier = "none" | "bronze" | "silver" | "gold";

// 아이템 카테고리
export type ItemCategory =
  | "hat"
  | "weapon_skin"
  | "costume"
  | "effect"
  | "pet"
  | "frame";

// 아이템 등급
export type ItemRarity = "common" | "rare" | "epic" | "legendary";

// 결제 상태
export type PaymentStatus = "pending" | "confirmed" | "cancelled" | "refunded";

// 젬 패키지
export type GemPackage = "100" | "330" | "575" | "1200";

// 프로필
export interface Profile {
  id: string;
  nickname: string;
  level: number;
  exp: number;
  hp: number;
  maxHp: number;
  jobClass: string;
  jobTier: number;
  topCategory: Category | null;
  avatarType: string;
  gemBalance: number;
  totalDonated: number;
  supporterTier: SupporterTier;
  comboCount: number;
  consecutiveWrongCount: number;
  totalCorrect: number;
  totalQuestions: number;
  estimatedSalary: number;
  bestCombo: number;
  weeklyExp: number;
  createdAt: string;
  updatedAt: string;
}

// 문제
export interface Question {
  id: string;
  category: Category;
  subcategory: string | null;
  difficulty: number;
  levelMin: number;
  levelMax: number;
  questionText: string;
  correctAnswer: string;
  keywords: string[];
  explanation: string;
  // 정답률 관련 필드
  totalAttempts?: number;
  correctCount?: number;
  accuracyRate?: number | null;
}

// 몬스터
export interface Monster {
  id: string;
  name: string;
  levelMin: number;
  levelMax: number;
  hp: number;
  imageUrl: string | null;
  description: string | null;
  category: Category | null;
}

// 퀴즈 기록
export interface QuizHistory {
  id: string;
  userId: string;
  questionId: string;
  userAnswer: string;
  aiScore: number;
  aiFeedback: string;
  aiCorrectAnswer: string;
  isCorrect: GradingResult;
  expEarned: number;
  timeSpentSec: number | null;
  comboCount: number;
  monsterId: string | null;
  createdAt: string;
}

// 전투 세션
export interface BattleSession {
  id: string;
  userId: string;
  monsterId: string;
  monsterHp: number;
  userHp: number;
  status: BattleStatus;
  questionsAnswered: number;
  createdAt: string;
  completedAt: string | null;
}

// 상점 아이템
export interface ShopItem {
  id: string;
  name: string;
  category: ItemCategory;
  description: string | null;
  priceGem: number;
  imageUrl: string | null;
  rarity: ItemRarity;
}

// 사용자 아이템
export interface UserItem {
  id: string;
  userId: string;
  itemId: string;
  equipped: boolean;
  purchasedAt: string;
}

// 후원
export interface Donation {
  id: string;
  userId: string;
  amount: number;
  gemAmount: number;
  paymentKey: string | null;
  orderId: string;
  status: PaymentStatus;
  createdAt: string;
}

// AI 채점 응답
export interface GradingResponse {
  score: number;
  isCorrect: GradingResult;
  feedback: string;
  correctAnswer: string;
  tip: string;
}

// 전투 결과 응답
export interface BattleResult {
  grading: GradingResponse;
  battle: {
    monsterHp: number;
    userHp: number;
    damageDealt: number;
    damageTaken: number;
  };
  rewards: {
    expEarned: number;
    comboCount: number;
    levelUp: boolean;
    levelDown: boolean;
    newLevel: number;
    oldLevel: number;
    jobChange: string | null;
    jobDemote: boolean;
    newJobTier: number;
    oldJobTier: number;
  };
  nextQuestion: Question | null;
}

// 비로그인 로컬 게임 상태
export interface LocalGameState {
  profile: Profile;
  battleSession: BattleSession | null;
  quizHistory: QuizHistory[];
  currentMonster: Monster | null;
  currentQuestion: Question | null;
}

// 시즌
export interface Season {
  id: string;
  seasonNumber: number;
  startsAt: string;
  endsAt: string;
  status: 'upcoming' | 'active' | 'ended';
}

// 명예의 전당
export interface HallOfFame {
  id: string;
  seasonId: string;
  userId: string;
  // DB에서는 CHECK (rank BETWEEN 1 AND 3) 제약으로 1, 2, 3만 허용됨
  rank: 1 | 2 | 3;
  finalLevel: number;
  finalExp: number;
  titleAwarded: string;
}

// 카테고리별 통계
export interface CategoryStats {
  id: string;
  userId: string;
  category: string;
  correctCount: number;
  totalCount: number;
  accuracy: number;
  updatedAt: string;
}

// 랭킹 항목
export interface RankingEntry {
  rank: number;
  userId: string;
  nickname: string;
  level: number;
  exp: number;
  jobClass: string;
  avatarType: string;
  supporterTier: string;
  weeklyExp?: number;
  bestCombo?: number;
  categoryCorrect?: number;
  categoryAccuracy?: number;
}
