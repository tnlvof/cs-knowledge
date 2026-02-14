import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

/**
 * T105: 종합 랭킹 API
 * GET /api/ranking/overall?limit=50
 *
 * 레벨 + EXP 순으로 정렬된 전체 유저 랭킹을 반환합니다.
 */
export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient();
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const sb = supabase as any;

    // 쿼리 파라미터에서 limit 추출 (기본값: 50)
    const { searchParams } = new URL(request.url);
    const parsedLimit = parseInt(searchParams.get("limit") || "50", 10);
    const limit = Number.isNaN(parsedLimit) ? 50 : Math.min(Math.max(1, parsedLimit), 100);

    // 종합 랭킹 조회: level DESC, exp DESC
    const { data, error } = await sb
      .from("profiles")
      .select("id, nickname, level, exp, job_class, job_tier, avatar_type, supporter_tier")
      .order("level", { ascending: false })
      .order("exp", { ascending: false })
      .limit(limit);

    if (error) {
      console.error("랭킹 조회 오류:", error);
      return NextResponse.json(
        { error: "랭킹을 불러오는데 실패했습니다" },
        { status: 500 }
      );
    }

    // 랭킹 번호 추가
    const rankings = (data || []).map((profile: Record<string, unknown>, index: number) => ({
      rank: index + 1,
      nickname: profile.nickname,
      level: profile.level,
      exp: profile.exp,
      jobClass: profile.job_class,
      jobTier: profile.job_tier,
      avatarType: profile.avatar_type,
      supporterTier: profile.supporter_tier,
    }));

    return NextResponse.json({
      rankings,
      total: rankings.length,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "서버 오류가 발생했습니다";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
