"use client";

import { useState, useCallback, useRef } from "react";
import type {
  Question,
  Monster,
  BattleSession,
  GradingResponse,
  QuizHistory,
} from "@/types/game";
import { calculateDamage } from "@/lib/game-logic/battle";
import { calculateExp, checkLevelChange } from "@/lib/game-logic/exp";
import { checkJobDemotion } from "@/lib/game-logic/job";
import {
  getProfile,
  saveProfile,
  addQuizHistory,
  saveBattleSession,
} from "@/lib/storage/local-storage";
import { MONSTER_GRADES } from "@/constants/monsters";
import { HP_CONSTANTS } from "@/constants/levels";

interface GuestBattleState {
  isLoading: boolean;
  isGrading: boolean;
  battleSession: BattleSession | null;
  monster: Monster | null;
  currentQuestion: Question | null;
  lastGrading: GradingResponse | null;
  lastDamage: { damageDealt: number; damageTaken: number } | null;
  lastRewards: {
    expEarned: number;
    comboCount: number;
    levelUp: boolean;
    levelDown: boolean;
    newLevel: number;
    oldLevel: number;
    jobDemote: boolean;
    newJobTier: number;
    oldJobTier: number;
  } | null;
  error: string | null;
}

export function useGuestBattle() {
  const [state, setState] = useState<GuestBattleState>({
    isLoading: false,
    isGrading: false,
    battleSession: null,
    monster: null,
    currentQuestion: null,
    lastGrading: null,
    lastDamage: null,
    lastRewards: null,
    error: null,
  });

  const stateRef = useRef(state);
  stateRef.current = state;

  const startBattle = useCallback(async (questions: Question[]) => {
    const profile = getProfile();
    if (!profile || questions.length === 0) return;

    const level = profile.level;
    const grade = MONSTER_GRADES.find(
      (g) => level >= g.levelMin && level <= g.levelMax
    ) ?? MONSTER_GRADES[0];

    const monsterIndex = Math.floor(Math.random() * grade.names.length);
    const monster: Monster = {
      id: `guest_monster_${Date.now()}`,
      name: grade.names[monsterIndex],
      levelMin: grade.levelMin,
      levelMax: grade.levelMax,
      hp: grade.baseHp,
      imageUrl: null,
      description: grade.descriptions[monsterIndex],
      category: null,
    };

    const session: BattleSession = {
      id: `guest_session_${Date.now()}`,
      userId: profile.id,
      monsterId: monster.id,
      monsterHp: monster.hp,
      userHp: HP_CONSTANTS.DEFAULT_MAX_HP,
      status: "active",
      questionsAnswered: 0,
      createdAt: new Date().toISOString(),
      completedAt: null,
    };

    // HP 리셋
    saveProfile({ ...profile, hp: HP_CONSTANTS.DEFAULT_MAX_HP });
    saveBattleSession(session);

    const question = questions[Math.floor(Math.random() * questions.length)];

    setState((prev) => ({
      ...prev,
      battleSession: session,
      monster,
      currentQuestion: question,
      error: null,
    }));
  }, []);

  const submitAnswer = useCallback(
    async (userAnswer: string, timeSpentSec: number) => {
      const { battleSession, monster, currentQuestion } = stateRef.current;
      const profile = getProfile();

      if (!battleSession || !monster || !currentQuestion || !profile) return;

      setState((prev) => ({ ...prev, isGrading: true, error: null }));

      try {
        // 서버 AI 채점 API 호출
        const res = await fetch("/api/battle/grade", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            questionId: currentQuestion.id,
            userAnswer,
            questionText: currentQuestion.questionText,
            correctAnswer: currentQuestion.correctAnswer,
            keywords: currentQuestion.keywords,
          }),
        });

        if (!res.ok) throw new Error("AI 채점에 실패했습니다");

        const { grading } = (await res.json()) as {
          grading: GradingResponse;
        };

        // 클라이언트에서 전투 로직 처리
        const damage = calculateDamage({
          score: grading.score,
          isCorrect: grading.isCorrect,
          monsterHp: battleSession.monsterHp,
          monsterMaxHp: monster.hp,
          userHp: battleSession.userHp,
        });

        // 연속 오답 카운트 가져오기 (프로필에 없으면 0)
        const consecutiveWrongCount = profile.consecutiveWrongCount || 0;

        const expResult = calculateExp({
          isCorrect: grading.isCorrect,
          score: grading.score,
          comboCount: profile.comboCount,
          currentLevel: profile.level,
          consecutiveWrongCount,
        });

        const oldLevel = profile.level;
        const oldJobTier = profile.jobTier;

        const levelChangeResult = checkLevelChange({
          currentLevel: profile.level,
          currentExp: profile.exp,
          expChange: expResult.totalExp,
        });

        const demotionResult = checkJobDemotion({
          newLevel: levelChangeResult.newLevel,
          oldLevel: oldLevel,
          currentJobTier: profile.jobTier,
        });

        // 전투 세션 업데이트
        const newStatus = damage.monsterDefeated
          ? "victory"
          : damage.userDefeated
            ? "defeat"
            : "active";

        const updatedSession: BattleSession = {
          ...battleSession,
          monsterHp: damage.newMonsterHp,
          userHp: damage.newUserHp,
          status: newStatus as BattleSession["status"],
          questionsAnswered: battleSession.questionsAnswered + 1,
          completedAt:
            newStatus !== "active" ? new Date().toISOString() : null,
        };

        saveBattleSession(
          newStatus === "active" ? updatedSession : null
        );

        // 프로필 업데이트
        const updatedProfile = {
          ...profile,
          exp: levelChangeResult.newExp,
          level: levelChangeResult.newLevel,
          hp: damage.newUserHp,
          comboCount: expResult.newComboCount,
          consecutiveWrongCount: expResult.consecutiveWrongCount,
          jobTier: demotionResult.shouldDemote ? demotionResult.newJobTier : profile.jobTier,
          totalQuestions: profile.totalQuestions + 1,
          totalCorrect:
            grading.isCorrect === "correct"
              ? profile.totalCorrect + 1
              : profile.totalCorrect,
          updatedAt: new Date().toISOString(),
        };
        saveProfile(updatedProfile);

        // 히스토리 저장
        const historyEntry: QuizHistory = {
          id: `guest_history_${Date.now()}`,
          userId: profile.id,
          questionId: currentQuestion.id,
          userAnswer,
          aiScore: grading.score,
          aiFeedback: grading.feedback,
          aiCorrectAnswer: grading.correctAnswer,
          isCorrect: grading.isCorrect,
          expEarned: expResult.totalExp,
          timeSpentSec: timeSpentSec,
          comboCount: expResult.newComboCount,
          monsterId: monster.id,
          createdAt: new Date().toISOString(),
        };
        addQuizHistory(historyEntry);

        setState((prev) => ({
          ...prev,
          isGrading: false,
          battleSession: updatedSession,
          lastGrading: grading,
          lastDamage: {
            damageDealt: damage.damageDealt,
            damageTaken: damage.damageTaken,
          },
          lastRewards: {
            expEarned: expResult.totalExp,
            comboCount: expResult.newComboCount,
            levelUp: levelChangeResult.levelUp,
            levelDown: levelChangeResult.levelDown,
            newLevel: levelChangeResult.newLevel,
            oldLevel: oldLevel,
            jobDemote: demotionResult.shouldDemote,
            newJobTier: demotionResult.newJobTier,
            oldJobTier: oldJobTier,
          },
        }));
      } catch (err) {
        setState((prev) => ({
          ...prev,
          isGrading: false,
          error:
            err instanceof Error ? err.message : "채점에 실패했습니다",
        }));
      }
    },
    []
  );

  const setNextQuestion = useCallback((question: Question) => {
    setState((prev) => ({
      ...prev,
      currentQuestion: question,
      lastGrading: null,
      lastDamage: null,
      lastRewards: null,
    }));
  }, []);

  return {
    ...state,
    startBattle,
    submitAnswer,
    setNextQuestion,
  };
}
