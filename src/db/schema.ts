import {
  pgTable,
  uuid,
  text,
  integer,
  boolean,
  decimal,
  date,
  timestamp,
  index,
  unique,
} from "drizzle-orm/pg-core";
import { sql } from "drizzle-orm";

// =============================================
// PROFILES (사용자 프로필)
// =============================================
export const profiles = pgTable(
  "profiles",
  {
    id: uuid("id").primaryKey(),
    nickname: text("nickname").unique().notNull(),
    level: integer("level").notNull().default(1),
    exp: integer("exp").notNull().default(0),
    hp: integer("hp").notNull().default(100),
    maxHp: integer("max_hp").notNull().default(100),
    jobClass: text("job_class").notNull().default("novice"),
    jobTier: integer("job_tier").notNull().default(0),
    topCategory: text("top_category"),
    avatarType: text("avatar_type").notNull(),
    gemBalance: integer("gem_balance").notNull().default(0),
    totalDonated: integer("total_donated").notNull().default(0),
    supporterTier: text("supporter_tier").notNull().default("none"),
    comboCount: integer("combo_count").notNull().default(0),
    consecutiveWrongCount: integer("consecutive_wrong_count").notNull().default(0),
    totalCorrect: integer("total_correct").notNull().default(0),
    totalQuestions: integer("total_questions").notNull().default(0),
    estimatedSalary: integer("estimated_salary").notNull().default(2400),
    bestCombo: integer("best_combo").notNull().default(0),
    weeklyExp: integer("weekly_exp").notNull().default(0),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index("idx_profiles_level").on(table.level, table.exp),
    index("idx_profiles_total_correct").on(table.totalCorrect),
    index("idx_profiles_overall_rank").on(table.level, table.exp),
    index("idx_profiles_weekly_rank").on(table.weeklyExp),
    index("idx_profiles_combo_rank").on(table.bestCombo),
  ]
);

// =============================================
// QUESTIONS (문제 은행)
// =============================================
export const questions = pgTable(
  "questions",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    category: text("category").notNull(),
    subcategory: text("subcategory"),
    difficulty: integer("difficulty").notNull(),
    levelMin: integer("level_min").notNull(),
    levelMax: integer("level_max").notNull(),
    questionText: text("question_text").notNull(),
    correctAnswer: text("correct_answer").notNull(),
    keywords: text("keywords").array().notNull(),
    explanation: text("explanation").notNull(),
    sourceDoc: text("source_doc"),
    totalAttempts: integer("total_attempts").notNull().default(0),
    correctCount: integer("correct_count").notNull().default(0),
    // accuracy_rate는 generated column으로 SQL에서만 존재
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index("idx_questions_selection").on(
      table.category,
      table.difficulty,
      table.levelMin,
      table.levelMax
    ),
    index("idx_questions_category").on(table.category),
    index("idx_questions_difficulty").on(table.difficulty),
    index("idx_questions_attempts").on(table.totalAttempts),
  ]
);

// =============================================
// MONSTERS (몬스터)
// =============================================
export const monsters = pgTable(
  "monsters",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    name: text("name").notNull(),
    levelMin: integer("level_min").notNull(),
    levelMax: integer("level_max").notNull(),
    hp: integer("hp").notNull(),
    imageUrl: text("image_url"),
    description: text("description"),
    category: text("category"),
  },
  (table) => [
    index("idx_monsters_level").on(table.levelMin, table.levelMax),
    index("idx_monsters_category").on(table.category),
  ]
);

// =============================================
// QUIZ_HISTORY (퀴즈 풀이 기록)
// =============================================
export const quizHistory = pgTable(
  "quiz_history",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: uuid("user_id")
      .notNull()
      .references(() => profiles.id, { onDelete: "cascade" }),
    questionId: uuid("question_id")
      .notNull()
      .references(() => questions.id),
    userAnswer: text("user_answer").notNull(),
    aiScore: decimal("ai_score", { precision: 3, scale: 2 }).notNull(),
    aiFeedback: text("ai_feedback").notNull(),
    aiCorrectAnswer: text("ai_correct_answer").notNull(),
    isCorrect: text("is_correct").notNull(),
    expEarned: integer("exp_earned").notNull(),
    timeSpentSec: integer("time_spent_sec"),
    comboCount: integer("combo_count").notNull().default(0),
    monsterId: uuid("monster_id").references(() => monsters.id),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index("idx_quiz_history_user_date").on(table.userId, table.createdAt),
    index("idx_quiz_history_user_correct").on(table.userId, table.isCorrect),
    index("idx_quiz_history_question").on(table.questionId),
  ]
);

// =============================================
// BATTLE_SESSIONS (전투 세션)
// =============================================
export const battleSessions = pgTable(
  "battle_sessions",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: uuid("user_id")
      .notNull()
      .references(() => profiles.id, { onDelete: "cascade" }),
    monsterId: uuid("monster_id")
      .notNull()
      .references(() => monsters.id),
    monsterHp: integer("monster_hp").notNull(),
    userHp: integer("user_hp").notNull(),
    status: text("status").notNull().default("active"),
    questionsAnswered: integer("questions_answered").notNull().default(0),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
    completedAt: timestamp("completed_at", { withTimezone: true }),
  },
  (table) => [
    index("idx_battle_sessions_user_status").on(table.userId, table.status),
  ]
);

// =============================================
// SHOP_ITEMS (아이템샵 상품)
// =============================================
export const shopItems = pgTable(
  "shop_items",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    name: text("name").notNull(),
    category: text("category").notNull(),
    description: text("description"),
    priceGem: integer("price_gem").notNull(),
    imageUrl: text("image_url"),
    rarity: text("rarity").notNull().default("common"),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index("idx_shop_items_category").on(table.category),
    index("idx_shop_items_rarity").on(table.rarity),
  ]
);

// =============================================
// USER_ITEMS (사용자 보유 아이템)
// =============================================
export const userItems = pgTable(
  "user_items",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: uuid("user_id")
      .notNull()
      .references(() => profiles.id, { onDelete: "cascade" }),
    itemId: uuid("item_id")
      .notNull()
      .references(() => shopItems.id),
    equipped: boolean("equipped").notNull().default(false),
    purchasedAt: timestamp("purchased_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    unique("user_items_user_item_unique").on(table.userId, table.itemId),
    index("idx_user_items_user").on(table.userId),
  ]
);

// =============================================
// DONATIONS (후원 내역)
// =============================================
export const donations = pgTable(
  "donations",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: uuid("user_id")
      .notNull()
      .references(() => profiles.id, { onDelete: "cascade" }),
    amount: integer("amount").notNull(),
    gemAmount: integer("gem_amount").notNull(),
    paymentKey: text("payment_key"),
    orderId: text("order_id").unique().notNull(),
    status: text("status").notNull().default("pending"),
    createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index("idx_donations_user_status").on(table.userId, table.status),
    index("idx_donations_order").on(table.orderId),
    index("idx_donations_status").on(table.status),
  ]
);

// =============================================
// ACHIEVEMENTS (칭호/업적)
// =============================================
export const achievements = pgTable("achievements", {
  id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
  code: text("code").unique().notNull(),
  name: text("name").notNull(),
  description: text("description").notNull(),
  icon: text("icon").notNull(),
});

// =============================================
// USER_ACHIEVEMENTS (사용자 칭호)
// =============================================
export const userAchievements = pgTable(
  "user_achievements",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: uuid("user_id")
      .notNull()
      .references(() => profiles.id, { onDelete: "cascade" }),
    achievementId: uuid("achievement_id")
      .notNull()
      .references(() => achievements.id),
    earnedAt: timestamp("earned_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index("idx_user_achievements_user").on(table.userId),
  ]
);

// =============================================
// DAILY_QUESTS (일일 퀘스트)
// =============================================
export const dailyQuests = pgTable(
  "daily_quests",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: uuid("user_id")
      .notNull()
      .references(() => profiles.id, { onDelete: "cascade" }),
    questType: text("quest_type").notNull(),
    targetCount: integer("target_count").notNull(),
    currentCount: integer("current_count").notNull().default(0),
    bonusExp: integer("bonus_exp").notNull(),
    questDate: date("quest_date").notNull(),
    completed: boolean("completed").notNull().default(false),
  },
  (table) => [
    index("idx_daily_quests_user_date").on(table.userId, table.questDate),
  ]
);

// =============================================
// SEASONS (시즌)
// =============================================
export const seasons = pgTable(
  "seasons",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    seasonNumber: integer("season_number").unique().notNull(),
    startsAt: timestamp("starts_at", { withTimezone: true }).notNull(),
    endsAt: timestamp("ends_at", { withTimezone: true }).notNull(),
    status: text("status").notNull().default("upcoming"),
  },
  (table) => [
    index("idx_seasons_status").on(table.status),
  ]
);

// =============================================
// HALL_OF_FAME (명예의 전당)
// =============================================
export const hallOfFame = pgTable(
  "hall_of_fame",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    seasonId: uuid("season_id")
      .notNull()
      .references(() => seasons.id, { onDelete: "restrict" }),
    userId: uuid("user_id")
      .notNull()
      .references(() => profiles.id, { onDelete: "cascade" }),
    rank: integer("rank").notNull(),
    finalLevel: integer("final_level").notNull(),
    finalExp: integer("final_exp").notNull(),
    titleAwarded: text("title_awarded").notNull(),
  },
  (table) => [
    unique("hall_of_fame_season_rank").on(table.seasonId, table.rank),
    unique("hall_of_fame_season_user").on(table.seasonId, table.userId),
    index("idx_hall_of_fame_season").on(table.seasonId, table.rank),
  ]
);

// =============================================
// CATEGORY_STATS (카테고리별 통계)
// =============================================
export const categoryStats = pgTable(
  "category_stats",
  {
    id: uuid("id").primaryKey().default(sql`gen_random_uuid()`),
    userId: uuid("user_id")
      .notNull()
      .references(() => profiles.id, { onDelete: "cascade" }),
    category: text("category").notNull(),
    correctCount: integer("correct_count").notNull().default(0),
    totalCount: integer("total_count").notNull().default(0),
    // accuracy는 generated column으로 SQL에서만 존재
    updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    unique("category_stats_user_category").on(table.userId, table.category),
    index("idx_category_stats_rank").on(table.category, table.correctCount),
  ]
);
