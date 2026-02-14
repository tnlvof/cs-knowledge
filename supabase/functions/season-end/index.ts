/**
 * T116: 시즌 종료 Edge Function
 *
 * 시즌 종료 시 다음 작업을 수행합니다:
 * 1. 현재 활성 시즌 조회
 * 2. 상위 3명 유저 조회 (level DESC, exp DESC)
 * 3. hall_of_fame에 등록
 * 4. 한정 칭호 부여
 * 5. 모든 유저의 weekly_exp 초기화
 * 6. 현재 시즌 상태를 'ended'로 변경
 * 7. 다음 시즌 생성
 *
 * 실행 방법: Supabase cron 또는 수동 호출
 * cron 설정 예시: 매월 마지막 월요일 00:00 KST
 */

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// 시즌 순위별 칭호
const SEASON_TITLES = {
  1: "전설의 모험가",
  2: "위대한 모험가",
  3: "용감한 모험가",
} as Record<number, string>;

// 시즌 기간 (4주 = 28일)
const SEASON_DURATION_DAYS = 28;

interface Profile {
  id: string;
  nickname: string;
  level: number;
  exp: number;
}

interface Season {
  id: string;
  season_number: number;
  starts_at: string;
  ends_at: string;
  status: string;
}

Deno.serve(async (req) => {
  try {
    // CORS 처리
    if (req.method === "OPTIONS") {
      return new Response("ok", {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type, Authorization",
        },
      });
    }

    // 인증 확인 (서비스 롤 키 또는 시즌 종료 비밀 키 필요)
    const authHeader = req.headers.get("Authorization");
    const expectedToken = Deno.env.get("SEASON_END_SECRET") || Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!authHeader || authHeader.replace("Bearer ", "") !== expectedToken) {
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 403, headers: { "Content-Type": "application/json" } }
      );
    }

    // Supabase 클라이언트 생성 (서비스 롤 키 사용)
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // 1. 현재 활성 시즌 조회
    const { data: activeSeason, error: seasonError } = await supabase
      .from("seasons")
      .select("*")
      .eq("status", "active")
      .single();

    if (seasonError || !activeSeason) {
      return new Response(
        JSON.stringify({ error: "활성 시즌을 찾을 수 없습니다", details: seasonError }),
        { status: 404, headers: { "Content-Type": "application/json" } }
      );
    }

    const season = activeSeason as Season;

    // 중복 실행 방지 (idempotency check)
    const { data: existingHof } = await supabase
      .from("hall_of_fame")
      .select("id")
      .eq("season_id", season.id)
      .limit(1);

    if (existingHof && existingHof.length > 0) {
      return new Response(
        JSON.stringify({ message: "Season already processed", seasonId: season.id }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    // 2. 상위 3명 유저 조회
    const { data: topUsers, error: topError } = await supabase
      .from("profiles")
      .select("id, nickname, level, exp")
      .order("level", { ascending: false })
      .order("exp", { ascending: false })
      .limit(3);

    if (topError) {
      return new Response(
        JSON.stringify({ error: "상위 유저 조회 실패", details: topError }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    const winners = topUsers as Profile[];

    // 3. hall_of_fame에 등록
    const hallOfFameEntries = winners.map((user, index) => ({
      season_id: season.id,
      user_id: user.id,
      rank: index + 1,
      final_level: user.level,
      final_exp: user.exp,
      title_awarded: SEASON_TITLES[index + 1] || "모험가",
    }));

    const { error: hofError } = await supabase
      .from("hall_of_fame")
      .insert(hallOfFameEntries);

    if (hofError) {
      console.error("명예의 전당 등록 오류:", hofError);
      // 이미 존재하는 경우 (중복 실행) 무시하고 계속 진행
      if (!hofError.message?.includes("duplicate")) {
        return new Response(
          JSON.stringify({ error: "명예의 전당 등록 실패", details: hofError }),
          { status: 500, headers: { "Content-Type": "application/json" } }
        );
      }
    }

    // 4. 한정 칭호 부여 (user_achievements 테이블에 추가)
    // 먼저 시즌 칭호 achievement가 있는지 확인
    for (let i = 0; i < winners.length; i++) {
      const user = winners[i];
      const title = SEASON_TITLES[i + 1];
      const achievementCode = `season_${season.season_number}_rank_${i + 1}`;

      // 칭호 생성 (이미 있으면 무시)
      await supabase
        .from("achievements")
        .upsert({
          code: achievementCode,
          name: title,
          description: `시즌 ${season.season_number} ${i + 1}위 달성`,
          icon: i === 0 ? "👑" : i === 1 ? "🥈" : "🥉",
        }, { onConflict: "code" });

      // 유저에게 칭호 부여
      const { data: achievement } = await supabase
        .from("achievements")
        .select("id")
        .eq("code", achievementCode)
        .single();

      if (achievement) {
        await supabase
          .from("user_achievements")
          .upsert({
            user_id: user.id,
            achievement_id: achievement.id,
          }, { onConflict: "user_id,achievement_id" })
          .select();
      }
    }

    // 5. 모든 유저의 weekly_exp 초기화
    const { error: resetError } = await supabase
      .from("profiles")
      .update({ weekly_exp: 0 })
      .neq("id", "00000000-0000-0000-0000-000000000000"); // 모든 유저

    if (resetError) {
      console.error("주간 EXP 초기화 오류:", resetError);
    }

    // 6. 현재 시즌 상태를 'ended'로 변경
    const { error: updateSeasonError } = await supabase
      .from("seasons")
      .update({ status: "ended" })
      .eq("id", season.id);

    if (updateSeasonError) {
      console.error("시즌 상태 업데이트 오류:", updateSeasonError);
    }

    // 7. 다음 시즌 생성
    const nextSeasonNumber = season.season_number + 1;
    const nextStartsAt = new Date();
    const nextEndsAt = new Date(nextStartsAt.getTime() + SEASON_DURATION_DAYS * 24 * 60 * 60 * 1000);

    const { data: newSeason, error: newSeasonError } = await supabase
      .from("seasons")
      .insert({
        season_number: nextSeasonNumber,
        starts_at: nextStartsAt.toISOString(),
        ends_at: nextEndsAt.toISOString(),
        status: "active",
      })
      .select()
      .single();

    if (newSeasonError) {
      console.error("새 시즌 생성 오류:", newSeasonError);
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: `시즌 ${season.season_number} 종료 완료`,
        endedSeason: {
          id: season.id,
          seasonNumber: season.season_number,
        },
        winners: winners.map((user, index) => ({
          rank: index + 1,
          nickname: user.nickname,
          level: user.level,
          exp: user.exp,
          title: SEASON_TITLES[index + 1],
        })),
        newSeason: newSeason ? {
          id: newSeason.id,
          seasonNumber: nextSeasonNumber,
          startsAt: nextStartsAt.toISOString(),
          endsAt: nextEndsAt.toISOString(),
        } : null,
      }),
      {
        status: 200,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  } catch (error) {
    console.error("시즌 종료 오류:", error);
    return new Response(
      JSON.stringify({
        error: "시즌 종료 처리 중 오류가 발생했습니다",
        details: error instanceof Error ? error.message : String(error),
      }),
      {
        status: 500,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  }
});
