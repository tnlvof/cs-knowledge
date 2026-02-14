import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const VALID_AVATARS = ["warrior", "mage", "archer", "healer"];

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { nickname, avatarType } = body;

    // Validation
    if (!nickname || typeof nickname !== "string") {
      return NextResponse.json(
        { error: "닉네임을 입력해주세요" },
        { status: 400 }
      );
    }

    if (nickname.length < 2 || nickname.length > 12) {
      return NextResponse.json(
        { error: "닉네임은 2~12자여야 합니다" },
        { status: 400 }
      );
    }

    if (!/^[가-힣a-zA-Z0-9]+$/.test(nickname)) {
      return NextResponse.json(
        { error: "한글, 영문, 숫자만 사용 가능합니다" },
        { status: 400 }
      );
    }

    if (!VALID_AVATARS.includes(avatarType)) {
      return NextResponse.json(
        { error: "유효하지 않은 캐릭터 타입입니다" },
        { status: 400 }
      );
    }

    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      // 비로그인: 닉네임 중복 체크만 하고 클라이언트에서 localStorage로 처리
      // 비로그인 사용자의 닉네임 중복은 로그인 시 sync에서 처리
      return NextResponse.json({
        profile: {
          id: `guest_${crypto.randomUUID()}`,
          nickname,
          level: 1,
          exp: 0,
          hp: 100,
          maxHp: 100,
          jobClass: "novice",
          jobTier: 0,
          topCategory: null,
          avatarType,
          gemBalance: 0,
          totalDonated: 0,
          supporterTier: "none",
          comboCount: 0,
          totalCorrect: 0,
          totalQuestions: 0,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        },
      });
    }

    // 로그인 사용자: DB에 프로필 생성
    // 닉네임 중복 체크
    const { data: existing } = await supabase
      .from("profiles")
      .select("id")
      .eq("nickname", nickname)
      .single();

    if (existing) {
      return NextResponse.json(
        { error: "이미 사용 중인 닉네임입니다" },
        { status: 409 }
      );
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data: profile, error } = await (supabase as any)
      .from("profiles")
      .insert({
        id: user.id,
        nickname,
        avatar_type: String(avatarType),
      })
      .select()
      .single();

    if (error) {
      return NextResponse.json(
        { error: "캐릭터 생성에 실패했습니다" },
        { status: 500 }
      );
    }

    return NextResponse.json({ profile });
  } catch {
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
