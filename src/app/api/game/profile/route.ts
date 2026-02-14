import { NextRequest, NextResponse } from "next/server";
import { createClient, getAuthUser } from "@/lib/supabase/server";
import { CATEGORIES } from "@/constants/categories";

export async function GET() {
  try {
    const supabase = await createClient();
    const user = await getAuthUser(supabase);

    if (!user) {
      return NextResponse.json(
        { error: "로그인이 필요합니다" },
        { status: 401 }
      );
    }

    const sb = supabase as any;

    // Get profile
    const { data: profile, error: profileError } = await sb
      .from("profiles")
      .select("*")
      .eq("id", user.id)
      .single();

    if (profileError || !profile) {
      return NextResponse.json(
        { error: "프로필을 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    // Get category stats
    const { data: historyData } = await sb
      .from("quiz_history")
      .select(
        `
        ai_score,
        is_correct,
        question:questions(category)
      `
      )
      .eq("user_id", user.id);

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

    // Get equipped items
    const { data: equippedItems } = await sb
      .from("user_items")
      .select("*, item:shop_items(*)")
      .eq("user_id", user.id)
      .eq("equipped", true);

    const equipped = (equippedItems || []).reduce((acc: Record<string, any>, ui: any) => {
      if (ui.item?.category) {
        acc[ui.item.category] = {
          id: ui.item.id,
          name: ui.item.name,
          imageUrl: ui.item.image_url,
          rarity: ui.item.rarity,
        };
      }
      return acc;
    }, {});

    return NextResponse.json({
      profile: {
        id: profile.id,
        nickname: profile.nickname,
        level: profile.level,
        exp: profile.exp,
        hp: profile.hp,
        maxHp: profile.max_hp,
        jobClass: profile.job_class,
        jobTier: profile.job_tier,
        topCategory: profile.top_category,
        avatarType: profile.avatar_type,
        gemBalance: profile.gem_balance,
        totalDonated: profile.total_donated,
        supporterTier: profile.supporter_tier,
        comboCount: profile.combo_count,
        totalCorrect: profile.total_correct,
        totalQuestions: profile.total_questions,
        createdAt: profile.created_at,
        updatedAt: profile.updated_at,
      },
      categoryStats: stats,
      equippedItems: equipped,
    });
  } catch (error) {
    console.error("Profile fetch error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}

export async function PATCH(request: NextRequest) {
  try {
    const supabase = await createClient();
    const user = await getAuthUser(supabase);

    if (!user) {
      return NextResponse.json(
        { error: "로그인이 필요합니다" },
        { status: 401 }
      );
    }

    const body = await request.json();
    const { nickname, avatarType } = body;

    const sb = supabase as any;

    // Build update object
    const updates: Record<string, any> = {
      updated_at: new Date().toISOString(),
    };

    if (nickname !== undefined) {
      // Validate nickname
      if (typeof nickname !== "string" || nickname.length < 2 || nickname.length > 12) {
        return NextResponse.json(
          { error: "닉네임은 2~12자여야 합니다" },
          { status: 400 }
        );
      }

      // Check duplicate nickname
      const { data: existing } = await sb
        .from("profiles")
        .select("id")
        .eq("nickname", nickname)
        .neq("id", user.id)
        .single();

      if (existing) {
        return NextResponse.json(
          { error: "이미 사용 중인 닉네임입니다" },
          { status: 400 }
        );
      }

      updates.nickname = nickname;
    }

    if (avatarType !== undefined) {
      const validAvatars = ["warrior", "mage", "archer", "healer"];
      if (!validAvatars.includes(avatarType)) {
        return NextResponse.json(
          { error: "유효하지 않은 아바타입니다" },
          { status: 400 }
        );
      }
      updates.avatar_type = avatarType;
    }

    // Update profile
    const { data: profile, error } = await sb
      .from("profiles")
      .update(updates)
      .eq("id", user.id)
      .select()
      .single();

    if (error) {
      console.error("Profile update error:", error);
      return NextResponse.json(
        { error: "프로필 업데이트에 실패했습니다" },
        { status: 500 }
      );
    }

    return NextResponse.json({
      success: true,
      profile: {
        id: profile.id,
        nickname: profile.nickname,
        avatarType: profile.avatar_type,
        updatedAt: profile.updated_at,
      },
    });
  } catch (error) {
    console.error("Profile update error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
