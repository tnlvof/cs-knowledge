import type {
  Profile,
  Question,
  Monster,
  BattleSession,
  QuizHistory,
  UserItem,
  Donation,
  GradingResponse,
  BattleResult,
  Category,
  GemPackage,
} from "./game";

// Auth
export interface SyncRequest {
  profile: Profile;
  quizHistory: QuizHistory[];
  battleSessions: BattleSession[];
}

export interface SyncResponse {
  success: boolean;
  syncedCount: number;
}

// Game
export interface CreateCharacterRequest {
  nickname: string;
  avatarType: string;
}

export interface CreateCharacterResponse {
  profile: Profile;
}

export interface ProfileResponse {
  profile: Profile;
  categoryStats: CategoryStat[];
}

// Battle
export interface GradeRequest {
  questionId: string;
  userAnswer: string;
  questionText: string;
  correctAnswer: string;
  keywords: string[];
}

export interface GradeResponse {
  grading: GradingResponse;
}

export interface BattleStartRequest {
  userLevel: number;
  preferredCategory?: Category;
}

export interface BattleStartResponse {
  battleSession: BattleSession;
  monster: Monster;
  question: Question;
}

export interface BattleAnswerRequest {
  battleSessionId: string;
  questionId: string;
  userAnswer: string;
  timeSpentSec: number;
}

export type BattleAnswerResponse = BattleResult;

export interface BattleEndRequest {
  battleSessionId: string;
}

export interface BattleEndResponse {
  battleSession: BattleSession;
  totalExpEarned: number;
}

// History
export interface HistoryQuery {
  page?: number;
  limit?: number;
  category?: Category;
  isCorrect?: "correct" | "partial" | "wrong";
}

export interface HistoryResponse {
  items: QuizHistory[];
  total: number;
  page: number;
}

export interface CategoryStat {
  name: Category;
  totalCount: number;
  correctCount: number;
  avgScore: number;
}

export interface StatsResponse {
  categories: CategoryStat[];
}

// Payment
export interface PaymentReadyRequest {
  amount: number;
  gemPackage: GemPackage;
}

export interface PaymentReadyResponse {
  orderId: string;
  amount: number;
  gemAmount: number;
}

export interface PaymentConfirmRequest {
  paymentKey: string;
  orderId: string;
  amount: number;
}

export interface PaymentConfirmResponse {
  success: boolean;
  gemBalance: number;
  donation: Donation;
}

// Shop
export interface ShopPurchaseRequest {
  itemId: string;
}

export interface ShopPurchaseResponse {
  success: boolean;
  gemBalance: number;
  item: UserItem;
}

export interface ShopEquipRequest {
  itemId: string;
  equipped: boolean;
}

export interface ShopEquipResponse {
  success: boolean;
  equippedItems: UserItem[];
}

// Public Profile
export interface PublicProfile {
  nickname: string;
  level: number;
  jobClass: string;
  jobTier: number;
  avatarType: string;
  supporterTier: string;
  totalCorrect: number;
  totalQuestions: number;
  createdAt: string;
}

export interface PublicProfileResponse {
  profile: PublicProfile;
  categoryStats: CategoryStat[];
  radarChart: number[];
}

// Common
export interface ApiError {
  error: string;
  message: string;
  statusCode: number;
}
