import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { HP_CONSTANTS } from "@/constants/levels";

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
    const { userLevel, preferredCategory } = body;
    const level = Number(userLevel) || 1;

    // 프로필의 HP를 max_hp로 리셋
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    await (supabase as any)
      .from("profiles")
      .update({ hp: HP_CONSTANTS.DEFAULT_MAX_HP })
      .eq("id", user.id);

    // 레벨에 맞는 몬스터 선택
    let monsterQuery = supabase
      .from("monsters")
      .select("*")
      .lte("level_min", level)
      .gte("level_max", level);

    if (preferredCategory) {
      monsterQuery = monsterQuery.eq("category", preferredCategory);
    }

    const { data: monsters } = await monsterQuery;
    if (!monsters || monsters.length === 0) {
      // 폴백: 아무 몬스터나
      const { data: fallback } = await supabase
        .from("monsters")
        .select("*")
        .limit(1);
      if (!fallback || fallback.length === 0) {
        return NextResponse.json(
          { error: "몬스터를 찾을 수 없습니다" },
          { status: 404 }
        );
      }
      monsters?.push(...fallback);
    }

    const monster = monsters![Math.floor(Math.random() * monsters!.length)];

    // 레벨에 맞는 문제 선택
    // T104: 정답률 데이터 (accuracy_rate, total_attempts) 포함하여 반환
    let questionQuery = supabase
      .from("questions")
      .select("*, accuracy_rate")
      .lte("level_min", level)
      .gte("level_max", level);

    if (preferredCategory) {
      questionQuery = questionQuery.eq("category", preferredCategory);
    }

    const { data: questions } = await questionQuery.limit(10);
    if (!questions || questions.length === 0) {
      return NextResponse.json(
        { error: "문제를 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    const question = questions[Math.floor(Math.random() * questions.length)];

    // 전투 세션 생성
    const selectedMonster = monster as { id: string; hp: number; [key: string]: unknown };
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data: battleSession, error } = await (supabase as any)
      .from("battle_sessions")
      .insert({
        user_id: user.id,
        monster_id: selectedMonster.id,
        monster_hp: selectedMonster.hp,
        user_hp: HP_CONSTANTS.DEFAULT_MAX_HP,
      })
      .select()
      .single();

    if (error) {
      return NextResponse.json(
        { error: "전투 세션 생성 실패" },
        { status: 500 }
      );
    }

    return NextResponse.json({
      battleSession,
      monster,
      question,
    });
  } catch {
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
