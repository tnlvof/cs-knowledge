import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

/**
 * T110: 명예의 전당 API
 * GET /api/ranking/hall-of-fame
 *
 * 시즌별 상위 3명의 유저와 그들의 프로필 정보를 반환합니다.
 */
export async function GET() {
  try {
    const supabase = await createClient();
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const sb = supabase as any;

    // 명예의 전당 조회: hall_of_fame JOIN seasons JOIN profiles
    const { data, error } = await sb
      .from("hall_of_fame")
      .select(`
        id,
        rank,
        final_level,
        final_exp,
        title_awarded,
        seasons!inner (
          id,
          season_number,
          starts_at,
          ends_at,
          status
        ),
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
      .order("seasons(season_number)", { ascending: false })
      .order("rank", { ascending: true });

    if (error) {
      console.error("명예의 전당 조회 오류:", error);
      return NextResponse.json(
        { error: "명예의 전당을 불러오는데 실패했습니다" },
        { status: 500 }
      );
    }

    // 시즌별로 그룹화
    const seasonMap = new Map<string, {
      season: {
        id: string;
        seasonNumber: number;
        startsAt: string;
        endsAt: string;
        status: string;
      };
      winners: Array<{
        rank: number;
        finalLevel: number;
        finalExp: number;
        titleAwarded: string;
        profile: {
          userId: string;
          nickname: string;
          level: number;
          exp: number;
          jobClass: string;
          jobTier: number;
          avatarType: string;
          supporterTier: string;
        };
      }>;
    }>();

    for (const entry of (data || [])) {
      const season = entry.seasons as Record<string, unknown>;
      const profile = entry.profiles as Record<string, unknown>;
      const seasonId = season.id as string;

      if (!seasonMap.has(seasonId)) {
        seasonMap.set(seasonId, {
          season: {
            id: seasonId,
            seasonNumber: season.season_number as number,
            startsAt: season.starts_at as string,
            endsAt: season.ends_at as string,
            status: season.status as string,
          },
          winners: [],
        });
      }

      seasonMap.get(seasonId)!.winners.push({
        rank: entry.rank,
        finalLevel: entry.final_level,
        finalExp: entry.final_exp,
        titleAwarded: entry.title_awarded,
        profile: {
          userId: profile.id as string,
          nickname: profile.nickname as string,
          level: profile.level as number,
          exp: profile.exp as number,
          jobClass: profile.job_class as string,
          jobTier: profile.job_tier as number,
          avatarType: profile.avatar_type as string,
          supporterTier: profile.supporter_tier as string,
        },
      });
    }

    // 시즌 번호 내림차순으로 정렬된 배열로 변환
    const hallOfFame = Array.from(seasonMap.values())
      .sort((a, b) => b.season.seasonNumber - a.season.seasonNumber);

    return NextResponse.json({
      hallOfFame,
      totalSeasons: hallOfFame.length,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "서버 오류가 발생했습니다";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
