import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { CATEGORIES } from "@/constants/categories";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ nickname: string }> }
) {
  try {
    const { nickname } = await params;

    if (!nickname) {
      return NextResponse.json(
        { error: "닉네임이 필요합니다" },
        { status: 400 }
      );
    }

    const supabase = await createClient();
    const sb = supabase as any;

    // Get public profile
    const { data: profile, error: profileError } = await sb
      .from("profiles")
      .select(
        `
        id,
        nickname,
        level,
        job_class,
        job_tier,
        top_category,
        avatar_type,
        supporter_tier,
        total_correct,
        total_questions,
        estimated_salary,
        created_at
      `
      )
      .eq("nickname", nickname)
      .single();

    if (profileError || !profile) {
      return NextResponse.json(
        { error: "프로필을 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    // Get category stats (public)
    const { data: historyData } = await sb
      .from("quiz_history")
      .select(
        `
        ai_score,
        is_correct,
        question:questions(category)
      `
      )
      .eq("user_id", profile.id);

    // Calculate category stats
    const categoryStats: Record<string, { total: number; correct: number; score: number }> = {};
    CATEGORIES.forEach((cat) => {
      categoryStats[cat.id] = { total: 0, correct: 0, score: 0 };
    });

    (historyData || []).forEach((item: any) => {
      const category = item.question?.category;
      if (category && categoryStats[category]) {
        categoryStats[category].total++;
        categoryStats[category].score += item.ai_score || 0;
        if (item.is_correct === "correct") {
          categoryStats[category].correct++;
        }
      }
    });

    const stats = CATEGORIES.map((cat) => ({
      id: cat.id,
      name: cat.name,
      emoji: cat.emoji,
      color: cat.color,
      totalCount: categoryStats[cat.id].total,
      correctCount: categoryStats[cat.id].correct,
      avgScore:
        categoryStats[cat.id].total > 0
          ? Math.round(categoryStats[cat.id].score / categoryStats[cat.id].total)
          : 0,
    }));

    // Get equipped items (public)
    const { data: equippedItems } = await sb
      .from("user_items")
      .select("item:shop_items(name, category, image_url, rarity)")
      .eq("user_id", profile.id)
      .eq("equipped", true);

    const equipped = (equippedItems || []).reduce((acc: Record<string, any>, ui: any) => {
      if (ui.item?.category) {
        acc[ui.item.category] = {
          name: ui.item.name,
          imageUrl: ui.item.image_url,
          rarity: ui.item.rarity,
        };
      }
      return acc;
    }, {});

    return NextResponse.json({
      profile: {
        nickname: profile.nickname,
        level: profile.level,
        jobClass: profile.job_class,
        jobTier: profile.job_tier,
        topCategory: profile.top_category,
        avatarType: profile.avatar_type,
        supporterTier: profile.supporter_tier,
        totalCorrect: profile.total_correct,
        totalQuestions: profile.total_questions,
        accuracy:
          profile.total_questions > 0
            ? Math.round((profile.total_correct / profile.total_questions) * 100)
            : 0,
        estimatedSalary: profile.estimated_salary,
        joinedAt: profile.created_at,
      },
      categoryStats: stats,
      equippedItems: equipped,
    });
  } catch (error) {
    console.error("Public profile error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
