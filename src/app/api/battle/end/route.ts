import { NextRequest, NextResponse } from "next/server";
import { createClient, getAuthUser } from "@/lib/supabase/server";
import type { Database } from "@/types/database";

type BattleSessionRow = Database["public"]["Tables"]["battle_sessions"]["Row"];

export async function POST(request: NextRequest) {
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
    const { battleSessionId } = body;

    if (!battleSessionId) {
      return NextResponse.json(
        { error: "battleSessionId가 필요합니다" },
        { status: 400 }
      );
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const sb = supabase as any;

    const { data: rawSession } = await sb
      .from("battle_sessions")
      .select("*")
      .eq("id", battleSessionId)
      .eq("user_id", user.id)
      .single();

    const session = rawSession as BattleSessionRow | null;
    if (!session) {
      return NextResponse.json(
        { error: "전투 세션을 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    if (session.status === "active") {
      await sb
        .from("battle_sessions")
        .update({
          status: "defeat",
          completed_at: new Date().toISOString(),
        })
        .eq("id", battleSessionId);
    }

    const { data: historyData } = await sb
      .from("quiz_history")
      .select("exp_earned")
      .eq("user_id", user.id)
      .eq("monster_id", session.monster_id)
      .gte("created_at", session.created_at);

    const totalExpEarned =
      (historyData as { exp_earned: number }[] | null)?.reduce(
        (sum: number, h: { exp_earned: number }) => sum + h.exp_earned,
        0
      ) ?? 0;

    return NextResponse.json({
      battleSession: {
        ...session,
        status: session.status === "active" ? "defeat" : session.status,
      },
      totalExpEarned,
    });
  } catch {
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
