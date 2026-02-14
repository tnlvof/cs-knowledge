import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { gradeAnswer } from "@/lib/gemini/grading";
import { calculateDamage } from "@/lib/game-logic/battle";
import { calculateExp, checkLevelChange } from "@/lib/game-logic/exp";
import { checkJobDemotion } from "@/lib/game-logic/job";
import { calculateSalary } from "@/lib/game-logic/salary";
import type { Database } from "@/types/database";

type BattleSessionRow = Database["public"]["Tables"]["battle_sessions"]["Row"];
type QuestionRow = Database["public"]["Tables"]["questions"]["Row"];
type ProfileRow = Database["public"]["Tables"]["profiles"]["Row"];

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

    const body = await request.json();
    const { battleSessionId, questionId, userAnswer, timeSpentSec } = body;

    if (!battleSessionId || !questionId || !userAnswer) {
      return NextResponse.json(
        { error: "필수 필드가 누락되었습니다" },
        { status: 400 }
      );
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const sb = supabase as any;

    // 전투 세션 조회
    const { data: rawSession } = await sb
      .from("battle_sessions")
      .select("*")
      .eq("id", battleSessionId)
      .eq("user_id", user.id)
      .single();

    const session = rawSession as BattleSessionRow | null;
    if (!session || session.status !== "active") {
      return NextResponse.json(
        { error: "유효하지 않은 전투 세션입니다" },
        { status: 404 }
      );
    }

    // 문제 조회
    const { data: rawQuestion } = await sb
      .from("questions")
      .select("id, question_text, correct_answer, keywords, category, total_attempts, correct_count, accuracy_rate")
      .eq("id", questionId)
      .single();

    const question = rawQuestion as QuestionRow | null;
    if (!question) {
      return NextResponse.json(
        { error: "문제를 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    // 프로필 조회
    const { data: rawProfile } = await sb
      .from("profiles")
      .select("id, level, exp, hp, combo_count, consecutive_wrong_count, total_correct, total_questions, job_tier, job_class, best_combo, weekly_exp, top_category")
      .eq("id", user.id)
      .single();

    const profile = rawProfile as ProfileRow | null;
    if (!profile) {
      return NextResponse.json(
        { error: "프로필을 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    // AI 채점
    const grading = await gradeAnswer({
      questionText: question.question_text,
      correctAnswer: question.correct_answer,
      keywords: question.keywords,
      userAnswer: String(userAnswer),
    });

    // 전투 데미지 계산
    const { data: rawMonster } = await sb
      .from("monsters")
      .select("hp")
      .eq("id", session.monster_id)
      .single();
    const monsterMaxHp = (rawMonster as { hp: number } | null)?.hp ?? 100;

    const damage = calculateDamage({
      score: grading.score,
      isCorrect: grading.isCorrect,
      monsterHp: session.monster_hp,
      monsterMaxHp,
      userHp: session.user_hp,
    });

    // EXP 계산 (레벨 및 연속 오답 카운트 포함)
    const consecutiveWrongCount = (profile as Record<string, unknown>).consecutive_wrong_count as number || 0;
    const expResult = calculateExp({
      isCorrect: grading.isCorrect,
      score: grading.score,
      comboCount: profile.combo_count,
      currentLevel: profile.level,
      consecutiveWrongCount,
    });

    // 레벨 변화 체크 (업/다운 모두)
    const oldLevel = profile.level;
    const levelChangeResult = checkLevelChange({
      currentLevel: profile.level,
      currentExp: profile.exp,
      expChange: expResult.totalExp,
    });

    // 직업 강등 체크
    const oldJobTier = profile.job_tier;
    const demotionResult = checkJobDemotion({
      newLevel: levelChangeResult.newLevel,
      oldLevel: oldLevel,
      currentJobTier: profile.job_tier,
    });

    // 전투 상태 업데이트
    const newStatus = damage.monsterDefeated
      ? "victory"
      : damage.userDefeated
        ? "defeat"
        : "active";

    await sb
      .from("battle_sessions")
      .update({
        monster_hp: damage.newMonsterHp,
        user_hp: damage.newUserHp,
        status: newStatus,
        questions_answered: session.questions_answered + 1,
        ...(newStatus !== "active"
          ? { completed_at: new Date().toISOString() }
          : {}),
      })
      .eq("id", battleSessionId);

    // =============================================
    // T123: 예상 연봉 계산 (레벨 변동 시 재계산) - 프로필 업데이트 전에 계산
    // =============================================
    let salaryUpdates: { estimated_salary?: number; top_category?: string | null } = {};
    if (levelChangeResult.levelUp || levelChangeResult.levelDown) {
      // 카테고리별 통계 조회 (높은 정답률 분야 개수 계산용)
      const { data: categoryStatsData } = await sb
        .from("category_stats")
        .select("category, correct_count, total_count")
        .eq("user_id", user.id);

      let highAccuracyCount = 0;
      let topCategory: string | null = profile.top_category;
      let maxCorrect = 0;

      if (categoryStatsData && categoryStatsData.length > 0) {
        (categoryStatsData as { category: string; correct_count: number; total_count: number }[]).forEach((stat) => {
          // 최소 5문제 이상 풀고 70%+ 정답률인 분야 개수 카운트
          if (stat.total_count >= 5) {
            const accuracy = stat.total_count > 0 ? (stat.correct_count / stat.total_count) * 100 : 0;
            if (accuracy >= 70) {
              highAccuracyCount++;
            }
          }
          // 주력 분야 결정 (가장 많이 맞춘 분야)
          if (stat.correct_count > maxCorrect) {
            maxCorrect = stat.correct_count;
            topCategory = stat.category;
          }
        });
      }

      // 새 레벨 기준으로 연봉 계산
      const newSalary = calculateSalary(
        levelChangeResult.newLevel,
        topCategory,
        highAccuracyCount
      );

      salaryUpdates = {
        estimated_salary: newSalary,
        top_category: topCategory,
      };
    }
    // =============================================
    // END T123 (salary calculation)
    // =============================================

    // 프로필 업데이트 (모든 필드를 단일 UPDATE로 통합)
    const profileUpdates: Record<string, unknown> = {
      exp: levelChangeResult.newExp,
      level: levelChangeResult.newLevel,
      hp: damage.newUserHp,
      combo_count: expResult.newComboCount,
      consecutive_wrong_count: expResult.consecutiveWrongCount,
      total_questions: profile.total_questions + 1,
      updated_at: new Date().toISOString(),
      // T111: weekly_exp 갱신 (양수 EXP만)
      weekly_exp: expResult.totalExp > 0 ? (profile as Record<string, unknown>).weekly_exp as number + expResult.totalExp : (profile as Record<string, unknown>).weekly_exp as number,
      // T111: best_combo 갱신 (현재 콤보가 역대 최고보다 높을 때)
      ...(expResult.newComboCount > ((profile as Record<string, unknown>).best_combo as number || 0) ? { best_combo: expResult.newComboCount } : {}),
      // T123: 연봉 및 주력 분야 갱신
      ...salaryUpdates,
    };

    // 직업 강등 시 tier 업데이트
    if (demotionResult.shouldDemote) {
      profileUpdates.job_tier = demotionResult.newJobTier;
    }

    if (grading.isCorrect === "correct") {
      profileUpdates.total_correct = profile.total_correct + 1;
    }

    await sb.from("profiles").update(profileUpdates).eq("id", user.id);

    // 퀴즈 히스토리 저장
    await sb.from("quiz_history").insert({
      user_id: user.id,
      question_id: questionId,
      user_answer: String(userAnswer),
      ai_score: grading.score,
      ai_feedback: grading.feedback,
      ai_correct_answer: grading.correctAnswer,
      is_correct: grading.isCorrect,
      exp_earned: expResult.totalExp,
      time_spent_sec: Number(timeSpentSec) || null,
      combo_count: expResult.newComboCount,
      monster_id: session.monster_id,
    });

    // =============================================
    // T111: category_stats UPSERT (read-then-write 방식)
    // Note: 진정한 원자성을 위해서는 RPC 함수가 필요하지만, maybeSingle()로 안전하게 처리
    // =============================================
    const questionCategory = question.category;
    const { data: existingStat } = await sb
      .from("category_stats")
      .select("id, correct_count, total_count")
      .eq("user_id", user.id)
      .eq("category", questionCategory)
      .maybeSingle();

    if (existingStat) {
      // Use SQL increment via RPC or direct increment
      await sb.from("category_stats").update({
        correct_count: existingStat.correct_count + (grading.isCorrect === "correct" ? 1 : 0),
        total_count: existingStat.total_count + 1,
        updated_at: new Date().toISOString(),
      }).eq("id", existingStat.id);
    } else {
      await sb.from("category_stats").insert({
        user_id: user.id,
        category: questionCategory,
        correct_count: grading.isCorrect === "correct" ? 1 : 0,
        total_count: 1,
        updated_at: new Date().toISOString(),
      });
    }
    // =============================================
    // END T111
    // =============================================

    // =============================================
    // T102: 정답률 갱신 (문제별 total_attempts, correct_count 업데이트)
    // =============================================
    const isCorrectAnswer = grading.isCorrect === "correct";
    try {
      const { error: rpcError } = await sb.rpc("increment_question_stats", {
        p_question_id: questionId,
        p_is_correct: isCorrectAnswer,
      });
      if (rpcError) {
        // RPC 함수가 없거나 실패 시 대체 쿼리
        await sb.from("questions").update({
          total_attempts: question.total_attempts + 1,
          correct_count: question.correct_count + (isCorrectAnswer ? 1 : 0),
        }).eq("id", questionId);
      }
    } catch {
      // 정답률 갱신 실패는 전투 진행에 영향 없음
      try {
        await sb.from("questions").update({
          total_attempts: question.total_attempts + 1,
          correct_count: question.correct_count + (isCorrectAnswer ? 1 : 0),
        }).eq("id", questionId);
      } catch (fallbackErr) {
        console.error("Failed to update question stats:", fallbackErr);
      }
    }
    // =============================================
    // END T102
    // =============================================

    // 다음 문제 (전투 계속 시)
    let nextQuestion = null;
    if (newStatus === "active") {
      // T104: 정답률 데이터 포함하여 문제 반환 (accuracy_rate 포함)
      const { data: questions } = await sb
        .from("questions")
        .select("*, accuracy_rate")
        .lte("level_min", levelChangeResult.newLevel)
        .gte("level_max", levelChangeResult.newLevel)
        .neq("id", questionId)
        .limit(5);

      const qList = questions as QuestionRow[] | null;
      if (qList && qList.length > 0) {
        nextQuestion = qList[Math.floor(Math.random() * qList.length)];
      }
    }

    // T103: 정답률 정보를 응답에 포함 (결과 화면에서 "상위 N%" 표시용)
    const questionAccuracyRate = question.accuracy_rate ?? null;

    return NextResponse.json({
      grading,
      battle: {
        monsterHp: damage.newMonsterHp,
        userHp: damage.newUserHp,
        damageDealt: damage.damageDealt,
        damageTaken: damage.damageTaken,
      },
      rewards: {
        expEarned: expResult.totalExp,
        comboCount: expResult.newComboCount,
        levelUp: levelChangeResult.levelUp,
        levelDown: levelChangeResult.levelDown,
        newLevel: levelChangeResult.newLevel,
        oldLevel: oldLevel,
        jobChange: null,
        jobDemote: demotionResult.shouldDemote,
        newJobTier: demotionResult.newJobTier,
        oldJobTier: oldJobTier,
      },
      questionAccuracy: {
        accuracyRate: questionAccuracyRate,
        totalAttempts: question.total_attempts,
      },
      nextQuestion,
    });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "서버 오류가 발생했습니다";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
