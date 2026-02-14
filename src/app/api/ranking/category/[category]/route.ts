import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { CATEGORIES } from "@/constants/categories";
import type { Category } from "@/types/game";

/**
 * T107: 분야별 랭킹 API
 * GET /api/ranking/category/[category]?limit=50
 *
 * 특정 분야의 정답 수 + 정답률 순으로 정렬된 랭킹을 반환합니다.
 */
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ category: string }> }
) {
  try {
    const { category } = await params;

    // 카테고리 유효성 검증
    const validCategories = CATEGORIES.map((c) => c.id);
    if (!validCategories.includes(category as Category)) {
      return NextResponse.json(
        { error: `유효하지 않은 카테고리입니다. 가능한 값: ${validCategories.join(", ")}` },
        { status: 400 }
      );
    }

    const supabase = await createClient();
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const sb = supabase as any;

    // 쿼리 파라미터에서 limit 추출 (기본값: 50)
    const { searchParams } = new URL(request.url);
    const parsedLimit = parseInt(searchParams.get("limit") || "50", 10);
    const limit = Number.isNaN(parsedLimit) ? 50 : Math.min(Math.max(1, parsedLimit), 100);

    // 분야별 랭킹 조회: category_stats JOIN profiles
    // correct_count DESC, accuracy(정답률) DESC 순
    const { data, error } = await sb
      .from("category_stats")
      .select(`
        user_id,
        correct_count,
        total_count,
        accuracy,
        profiles!inner (
          id,
          nickname,
          level,
          exp,
          job_class,
          job_tier,
          avatar_type,
          supporter_tier
        )
      `)
      .eq("category", category)
      .order("correct_count", { ascending: false })
      .order("accuracy", { ascending: false })
      .limit(limit);

    if (error) {
      console.error("분야별 랭킹 조회 오류:", error);
      return NextResponse.json(
        { error: "분야별 랭킹을 불러오는데 실패했습니다" },
        { status: 500 }
      );
    }

    // 랭킹 번호 추가 및 데이터 변환
    const rankings = (data || []).map((stat: Record<string, unknown>, index: number) => {
      const profile = stat.profiles as Record<string, unknown>;
      const totalCount = stat.total_count as number || 0;
      const correctCount = stat.correct_count as number || 0;
      // accuracy가 generated column인 경우 값이 있고, 아니면 계산
      const accuracy = stat.accuracy !== null && stat.accuracy !== undefined
        ? stat.accuracy as number
        : totalCount > 0 ? (correctCount / totalCount) * 100 : 0;

      return {
        rank: index + 1,
        nickname: profile.nickname,
        level: profile.level,
        exp: profile.exp,
        jobClass: profile.job_class,
        jobTier: profile.job_tier,
        avatarType: profile.avatar_type,
        supporterTier: profile.supporter_tier,
        categoryCorrect: correctCount,
        categoryTotal: totalCount,
        categoryAccuracy: Math.round(accuracy * 100) / 100,
      };
    });

    // 카테고리 정보 추가
    const categoryInfo = CATEGORIES.find((c) => c.id === category);

    return NextResponse.json({
      category: {
        id: category,
        name: categoryInfo?.name,
        emoji: categoryInfo?.emoji,
      },
      rankings,
      total: rankings.length,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "서버 오류가 발생했습니다";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
