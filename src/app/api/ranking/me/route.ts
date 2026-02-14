import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

/**
 * T109: 내 순위 + 주변 +-5명 API
 * GET /api/ranking/me
 *
 * 현재 로그인한 유저의 종합 랭킹 순위와 주변 +-5명의 유저를 반환합니다.
 * 인증 필요.
 */
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

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const sb = supabase as any;

    // 내 프로필 조회
    const { data: myProfile, error: profileError } = await sb
      .from("profiles")
      .select("id, nickname, level, exp, job_class, job_tier, avatar_type, supporter_tier")
      .eq("id", user.id)
      .single();

    if (profileError || !myProfile) {
      return NextResponse.json(
        { error: "프로필을 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    // 내 순위 계산: 나보다 높은 레벨 또는 같은 레벨에서 더 많은 EXP를 가진 유저 수 + 1
    const { count: higherCount, error: countError } = await sb
      .from("profiles")
      .select("id", { count: "exact", head: true })
      .or(`level.gt.${myProfile.level},and(level.eq.${myProfile.level},exp.gt.${myProfile.exp})`);

    if (countError) {
      console.error("순위 계산 오류:", countError);
      return NextResponse.json(
        { error: "순위 계산에 실패했습니다" },
        { status: 500 }
      );
    }

    const myRank = (higherCount || 0) + 1;

    // 전체 랭킹 조회 (내 순위 주변을 포함하도록)
    // 내 순위 기준 위로 5명, 아래로 5명 = 총 11명
    const startRank = Math.max(1, myRank - 5);
    const offset = startRank - 1;

    const { data: allRankings, error: rankError } = await sb
      .from("profiles")
      .select("id, nickname, level, exp, job_class, job_tier, avatar_type, supporter_tier")
      .order("level", { ascending: false })
      .order("exp", { ascending: false })
      .range(offset, offset + 10); // 11명 조회

    if (rankError) {
      console.error("주변 랭킹 조회 오류:", rankError);
      return NextResponse.json(
        { error: "랭킹을 불러오는데 실패했습니다" },
        { status: 500 }
      );
    }

    // 랭킹 번호 추가
    const surroundingRankings = (allRankings || []).map(
      (profile: Record<string, unknown>, index: number) => ({
        rank: startRank + index,
        userId: profile.id,
        nickname: profile.nickname,
        level: profile.level,
        exp: profile.exp,
        jobClass: profile.job_class,
        jobTier: profile.job_tier,
        avatarType: profile.avatar_type,
        supporterTier: profile.supporter_tier,
        isMe: profile.id === user.id,
      })
    );

    // 다음 순위까지 필요한 EXP 계산 (내가 1위가 아닌 경우)
    let expToNext = null;
    if (myRank > 1) {
      // 바로 위 유저 조회
      const { data: higherUser } = await sb
        .from("profiles")
        .select("level, exp")
        .or(`level.gt.${myProfile.level},and(level.eq.${myProfile.level},exp.gt.${myProfile.exp})`)
        .order("level", { ascending: true })
        .order("exp", { ascending: true })
        .limit(1)
        .single();

      if (higherUser) {
        // 같은 레벨이면 EXP 차이만, 다른 레벨이면 복잡한 계산 필요
        if (higherUser.level === myProfile.level) {
          expToNext = (higherUser.exp as number) - (myProfile.exp as number) + 1;
        } else {
          // 레벨이 다르면 대략적인 EXP 차이 표시 (레벨업 필요)
          expToNext = "레벨업 필요";
        }
      }
    }

    return NextResponse.json({
      myRank,
      myProfile: {
        userId: myProfile.id,
        nickname: myProfile.nickname,
        level: myProfile.level,
        exp: myProfile.exp,
        jobClass: myProfile.job_class,
        jobTier: myProfile.job_tier,
        avatarType: myProfile.avatar_type,
        supporterTier: myProfile.supporter_tier,
      },
      expToNext,
      surroundingRankings,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "서버 오류가 발생했습니다";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
