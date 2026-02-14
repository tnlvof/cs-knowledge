import type {
  Profile,
  QuizHistory,
  BattleSession,
  Monster,
  Question,
  LocalGameState,
  SupporterTier,
} from "@/types/game";

const STORAGE_KEYS = {
  PROFILE: "meaiple_profile",
  QUIZ_HISTORY: "meaiple_quiz_history",
  BATTLE_SESSION: "meaiple_battle_session",
  CURRENT_MONSTER: "meaiple_current_monster",
  CURRENT_QUESTION: "meaiple_current_question",
  LOGIN_PROMPT_SHOWN: "meaiple_login_prompt_shown",
} as const;

const MAX_HISTORY_ITEMS = 500;

function safeGet<T>(key: string): T | null {
  if (typeof window === "undefined") return null;
  try {
    const item = localStorage.getItem(key);
    return item ? (JSON.parse(item) as T) : null;
  } catch {
    return null;
  }
}

function safeSet(key: string, value: unknown): boolean {
  if (typeof window === "undefined") return false;
  try {
    localStorage.setItem(key, JSON.stringify(value));
    return true;
  } catch {
    // localStorage 용량 초과 시 오래된 히스토리 정리
    if (key !== STORAGE_KEYS.QUIZ_HISTORY) {
      trimHistory();
      try {
        localStorage.setItem(key, JSON.stringify(value));
        return true;
      } catch {
        return false;
      }
    }
    return false;
  }
}

function trimHistory(): void {
  const history = getQuizHistory();
  if (history.length > MAX_HISTORY_ITEMS / 2) {
    const trimmed = history.slice(0, MAX_HISTORY_ITEMS / 2);
    try {
      localStorage.setItem(
        STORAGE_KEYS.QUIZ_HISTORY,
        JSON.stringify(trimmed)
      );
    } catch {
      // 정리해도 안 되면 전체 삭제
      localStorage.removeItem(STORAGE_KEYS.QUIZ_HISTORY);
    }
  }
}

// Profile
export function getProfile(): Profile | null {
  return safeGet<Profile>(STORAGE_KEYS.PROFILE);
}

export function saveProfile(profile: Profile): boolean {
  return safeSet(STORAGE_KEYS.PROFILE, profile);
}

export function createGuestProfile(
  nickname: string,
  avatarType: string
): Profile {
  const profile: Profile = {
    id: `guest_${crypto.randomUUID()}`,
    nickname,
    level: 1,
    exp: 0,
    hp: 100,
    maxHp: 100,
    jobClass: "novice",
    jobTier: 0,
    topCategory: null,
    avatarType,
    gemBalance: 0,
    totalDonated: 0,
    supporterTier: "none" as SupporterTier,
    comboCount: 0,
    consecutiveWrongCount: 0,
    totalCorrect: 0,
    totalQuestions: 0,
    estimatedSalary: 2400,
    bestCombo: 0,
    weeklyExp: 0,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  saveProfile(profile);
  return profile;
}

// Quiz History
export function getQuizHistory(): QuizHistory[] {
  return safeGet<QuizHistory[]>(STORAGE_KEYS.QUIZ_HISTORY) ?? [];
}

export function addQuizHistory(entry: QuizHistory): void {
  const history = getQuizHistory();
  history.unshift(entry);
  if (history.length > MAX_HISTORY_ITEMS) {
    history.splice(MAX_HISTORY_ITEMS);
  }
  safeSet(STORAGE_KEYS.QUIZ_HISTORY, history);
}

// Battle Session
export function getBattleSession(): BattleSession | null {
  return safeGet<BattleSession>(STORAGE_KEYS.BATTLE_SESSION);
}

export function saveBattleSession(session: BattleSession | null): void {
  if (session === null) {
    if (typeof window !== "undefined") {
      localStorage.removeItem(STORAGE_KEYS.BATTLE_SESSION);
    }
    return;
  }
  safeSet(STORAGE_KEYS.BATTLE_SESSION, session);
}

// Current Monster & Question
export function getCurrentMonster(): Monster | null {
  return safeGet<Monster>(STORAGE_KEYS.CURRENT_MONSTER);
}

export function saveCurrentMonster(monster: Monster | null): void {
  if (monster === null) {
    if (typeof window !== "undefined") {
      localStorage.removeItem(STORAGE_KEYS.CURRENT_MONSTER);
    }
    return;
  }
  safeSet(STORAGE_KEYS.CURRENT_MONSTER, monster);
}

export function getCurrentQuestion(): Question | null {
  return safeGet<Question>(STORAGE_KEYS.CURRENT_QUESTION);
}

export function saveCurrentQuestion(question: Question | null): void {
  if (question === null) {
    if (typeof window !== "undefined") {
      localStorage.removeItem(STORAGE_KEYS.CURRENT_QUESTION);
    }
    return;
  }
  safeSet(STORAGE_KEYS.CURRENT_QUESTION, question);
}

// Login Prompt
export function hasShownLoginPrompt(): boolean {
  return safeGet<boolean>(STORAGE_KEYS.LOGIN_PROMPT_SHOWN) ?? false;
}

export function markLoginPromptShown(): void {
  safeSet(STORAGE_KEYS.LOGIN_PROMPT_SHOWN, true);
}

// Full State (for sync)
export function getFullGameState(): LocalGameState | null {
  const profile = getProfile();
  if (!profile) return null;

  return {
    profile,
    battleSession: getBattleSession(),
    quizHistory: getQuizHistory(),
    currentMonster: getCurrentMonster(),
    currentQuestion: getCurrentQuestion(),
  };
}

// Clear all game data
export function clearGameData(): void {
  if (typeof window === "undefined") return;
  Object.values(STORAGE_KEYS).forEach((key) => {
    localStorage.removeItem(key);
  });
}

// Check if user is guest
export function isGuestUser(): boolean {
  const profile = getProfile();
  return profile !== null && profile.id.startsWith("guest_");
}
