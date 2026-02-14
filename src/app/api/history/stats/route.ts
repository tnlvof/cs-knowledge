import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { CATEGORIES } from "@/constants/categories";

export async function GET() {
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

    const sb = supabase as any;

    // Get quiz history with question categories
    const { data: historyData, error: historyError } = await sb
      .from("quiz_history")
      .select(
        `
        ai_score,
        is_correct,
        question:questions(category)
      `
      )
      .eq("user_id", user.id);

    if (historyError) {
      console.error("History stats error:", historyError);
      return NextResponse.json(
        { error: "통계를 불러오는데 실패했습니다" },
        { status: 500 }
      );
    }

    // Aggregate stats per category
    const categoryStats: Record<
      string,
      {
        totalCount: number;
        correctCount: number;
        totalScore: number;
      }
    > = {};

    // Initialize all categories
    CATEGORIES.forEach((cat) => {
      categoryStats[cat.id] = {
        totalCount: 0,
        correctCount: 0,
        totalScore: 0,
      };
    });

    // Aggregate data
    historyData?.forEach((item: any) => {
      const category = item.question?.category;
      if (category && categoryStats[category]) {
        categoryStats[category].totalCount++;
        categoryStats[category].totalScore += item.ai_score || 0;
        if (item.is_correct === "correct") {
          categoryStats[category].correctCount++;
        }
      }
    });

    // Format response
    const stats = CATEGORIES.map((cat) => {
      const catStat = categoryStats[cat.id];
      return {
        id: cat.id,
        name: cat.name,
        emoji: cat.emoji,
        color: cat.color,
        totalCount: catStat.totalCount,
        correctCount: catStat.correctCount,
        avgScore:
          catStat.totalCount > 0
            ? Math.round(catStat.totalScore / catStat.totalCount)
            : 0,
        accuracy:
          catStat.totalCount > 0
            ? Math.round((catStat.correctCount / catStat.totalCount) * 100)
            : 0,
      };
    });

    // Calculate overall stats
    const overall = {
      totalQuestions: historyData?.length || 0,
      totalCorrect: historyData?.filter((h: any) => h.is_correct === "correct")
        .length || 0,
      avgScore:
        historyData && historyData.length > 0
          ? Math.round(
              historyData.reduce((sum: number, h: any) => sum + (h.ai_score || 0), 0) /
                historyData.length
            )
          : 0,
    };

    return NextResponse.json({
      categories: stats,
      overall,
    });
  } catch (error) {
    console.error("Stats error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
