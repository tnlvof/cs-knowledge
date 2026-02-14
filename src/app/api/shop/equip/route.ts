import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function PATCH(request: NextRequest) {
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
    const { userItemId, equipped } = body;

    if (!userItemId || typeof equipped !== "boolean") {
      return NextResponse.json(
        { error: "필수 파라미터가 누락되었습니다" },
        { status: 400 }
      );
    }

    const sb = supabase as any;

    // Verify ownership
    const { data: userItem, error: fetchError } = await sb
      .from("user_items")
      .select("*, item:shop_items(category)")
      .eq("id", userItemId)
      .eq("user_id", user.id)
      .single();

    if (fetchError || !userItem) {
      return NextResponse.json(
        { error: "아이템을 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    // If equipping, unequip other items in same category
    if (equipped && userItem.item?.category) {
      // Get all user items in same category
      const { data: sameCategory } = await sb
        .from("user_items")
        .select("id, item:shop_items(category)")
        .eq("user_id", user.id)
        .eq("equipped", true);

      // Unequip items in same category
      const toUnequip = (sameCategory || []).filter(
        (item: any) => item.item?.category === userItem.item.category && item.id !== userItemId
      );

      for (const item of toUnequip) {
        await sb
          .from("user_items")
          .update({ equipped: false })
          .eq("id", item.id);
      }
    }

    // Update equipped status
    const { error: updateError } = await sb
      .from("user_items")
      .update({ equipped })
      .eq("id", userItemId);

    if (updateError) {
      console.error("Equip update error:", updateError);
      return NextResponse.json(
        { error: "장착 상태 변경에 실패했습니다" },
        { status: 500 }
      );
    }

    return NextResponse.json({
      success: true,
      equipped,
      message: equipped ? "아이템을 장착했습니다" : "아이템을 해제했습니다",
    });
  } catch (error) {
    console.error("Equip error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
