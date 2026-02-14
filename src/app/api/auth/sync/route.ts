import { NextRequest, NextResponse } from "next/server";
import { createClient, createServiceClient } from "@/lib/supabase/server";
import type { Profile, QuizHistory, BattleSession } from "@/types/game";

interface SyncRequestBody {
  profile: Profile;
  quizHistory: QuizHistory[];
  battleSessions: BattleSession[];
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json(
        { error: "로그인이 필요합니다" },
        { status: 401 }
      );
    }

    const body: SyncRequestBody = await request.json();
    const { profile, quizHistory, battleSessions } = body;

    if (!profile) {
      return NextResponse.json(
        { error: "프로필 데이터가 필요합니다" },
        { status: 400 }
      );
    }

    // Validation: cap values at reasonable maximums to prevent client tampering
    const MAX_LEVEL = 50;
    const MAX_EXP = 100000;
    const MAX_HP = 1000;
    const MAX_COMBO = 100;
    const MAX_TOTAL_QUESTIONS = 100000;

    const sanitizedProfile = {
      ...profile,
      level: Math.min(Math.max(1, profile.level || 1), MAX_LEVEL),
      exp: Math.min(Math.max(0, profile.exp || 0), MAX_EXP),
      hp: Math.min(Math.max(0, profile.hp || 100), MAX_HP),
      maxHp: Math.min(Math.max(100, profile.maxHp || 100), MAX_HP),
      comboCount: Math.min(Math.max(0, profile.comboCount || 0), MAX_COMBO),
      totalQuestions: Math.min(Math.max(0, profile.totalQuestions || 0), MAX_TOTAL_QUESTIONS),
      totalCorrect: Math.min(
        Math.max(0, profile.totalCorrect || 0),
        Math.min(profile.totalQuestions || 0, MAX_TOTAL_QUESTIONS)
      ),
    };

    // Sanity check: totalCorrect cannot exceed totalQuestions
    if (sanitizedProfile.totalCorrect > sanitizedProfile.totalQuestions) {
      sanitizedProfile.totalCorrect = sanitizedProfile.totalQuestions;
    }

    const serviceClient = await createServiceClient();
    const sb = serviceClient as any;

    // Check if profile already exists
    const { data: existingProfile } = await sb
      .from("profiles")
      .select("id")
      .eq("id", user.id)
      .single();

    if (existingProfile) {
      // Update existing profile with merged data (using sanitized values)
      const { error: profileError } = await sb
        .from("profiles")
        .update({
          level: sanitizedProfile.level,
          exp: sanitizedProfile.exp,
          hp: sanitizedProfile.hp,
          max_hp: sanitizedProfile.maxHp,
          job_class: profile.jobClass,
          job_tier: profile.jobTier,
          top_category: profile.topCategory,
          combo_count: sanitizedProfile.comboCount,
          total_correct: sanitizedProfile.totalCorrect,
          total_questions: sanitizedProfile.totalQuestions,
          updated_at: new Date().toISOString(),
        })
        .eq("id", user.id);

      if (profileError) {
        console.error("Profile update error:", profileError);
        return NextResponse.json(
          { error: "프로필 업데이트 실패" },
          { status: 500 }
        );
      }
    } else {
      // Insert new profile (using sanitized values)
      const { error: profileError } = await sb.from("profiles").insert({
        id: user.id,
        nickname: profile.nickname,
        avatar_type: profile.avatarType,
        level: sanitizedProfile.level,
        exp: sanitizedProfile.exp,
        hp: sanitizedProfile.hp,
        max_hp: sanitizedProfile.maxHp,
        job_class: profile.jobClass,
        job_tier: profile.jobTier,
        top_category: profile.topCategory,
        combo_count: sanitizedProfile.comboCount,
        total_correct: sanitizedProfile.totalCorrect,
        total_questions: sanitizedProfile.totalQuestions,
      });

      if (profileError) {
        console.error("Profile insert error:", profileError);
        return NextResponse.json(
          { error: "프로필 생성 실패" },
          { status: 500 }
        );
      }
    }

    // Sync quiz history (only items that don't exist)
    if (quizHistory && quizHistory.length > 0) {
      const historyToInsert = quizHistory.map((h) => ({
        user_id: user.id,
        question_id: h.questionId,
        user_answer: h.userAnswer,
        ai_score: h.aiScore,
        ai_feedback: h.aiFeedback,
        ai_correct_answer: h.aiCorrectAnswer,
        is_correct: h.isCorrect,
        exp_earned: h.expEarned,
        time_spent_sec: h.timeSpentSec,
        combo_count: h.comboCount,
        monster_id: h.monsterId,
        created_at: h.createdAt,
      }));

      // Use upsert to avoid duplicates
      const { error: historyError } = await sb
        .from("quiz_history")
        .upsert(historyToInsert, {
          onConflict: "user_id,question_id,created_at",
          ignoreDuplicates: true,
        });

      if (historyError) {
        console.error("Quiz history sync error:", historyError);
      }
    }

    // Sync battle sessions
    if (battleSessions && battleSessions.length > 0) {
      const sessionsToInsert = battleSessions.map((s) => ({
        user_id: user.id,
        monster_id: s.monsterId,
        monster_hp: s.monsterHp,
        user_hp: s.userHp,
        status: s.status,
        questions_answered: s.questionsAnswered,
        created_at: s.createdAt,
        completed_at: s.completedAt,
      }));

      const { error: sessionError } = await sb
        .from("battle_sessions")
        .upsert(sessionsToInsert, {
          onConflict: "user_id,created_at",
          ignoreDuplicates: true,
        });

      if (sessionError) {
        console.error("Battle sessions sync error:", sessionError);
      }
    }

    return NextResponse.json({
      success: true,
      message: "동기화가 완료되었습니다",
    });
  } catch (error) {
    console.error("Sync error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
