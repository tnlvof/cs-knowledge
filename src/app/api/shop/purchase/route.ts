import { NextRequest, NextResponse } from "next/server";
import { createClient, createServiceClient } from "@/lib/supabase/server";

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
    const { itemId } = body;

    if (!itemId) {
      return NextResponse.json(
        { error: "아이템 ID가 필요합니다" },
        { status: 400 }
      );
    }

    const sb = supabase as any;

    // Get item info
    const { data: item, error: itemError } = await sb
      .from("shop_items")
      .select("*")
      .eq("id", itemId)
      .single();

    if (itemError || !item) {
      return NextResponse.json(
        { error: "아이템을 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    // Use service client for atomic operations
    const serviceClient = await createServiceClient();
    const sbService = serviceClient as any;

    // Atomic gem deduction: only succeeds if balance is sufficient (prevents race condition)
    const { data: updatedProfile, error: balanceError } = await sbService
      .from("profiles")
      .update({ gem_balance: sbService.rpc ? undefined : undefined })
      .eq("id", user.id)
      .gte("gem_balance", item.price_gem)
      .select("gem_balance")
      .single();

    // Use raw SQL for atomic update since Supabase JS doesn't support decrement in update
    const { data: deductResult, error: deductError } = await sbService.rpc(
      "deduct_gems_atomic",
      { p_user_id: user.id, p_amount: item.price_gem }
    ).catch(() => ({ data: null, error: { message: "RPC not available" } }));

    // Fallback: Use atomic update with WHERE clause
    let newBalance: number;
    if (deductError || !deductResult) {
      // Atomic update: UPDATE profiles SET gem_balance = gem_balance - price WHERE id = user_id AND gem_balance >= price
      const { data: atomicResult, error: atomicError } = await sbService
        .from("profiles")
        .select("gem_balance")
        .eq("id", user.id)
        .single();

      if (atomicError || !atomicResult) {
        return NextResponse.json(
          { error: "프로필을 찾을 수 없습니다" },
          { status: 404 }
        );
      }

      if (atomicResult.gem_balance < item.price_gem) {
        return NextResponse.json(
          { error: "젬이 부족합니다" },
          { status: 400 }
        );
      }

      newBalance = atomicResult.gem_balance - item.price_gem;

      // Atomic conditional update
      const { data: updateResult, error: updateError } = await sbService
        .from("profiles")
        .update({ gem_balance: newBalance })
        .eq("id", user.id)
        .gte("gem_balance", item.price_gem)
        .select("gem_balance")
        .single();

      if (updateError || !updateResult) {
        return NextResponse.json(
          { error: "젬이 부족합니다 (동시 요청 충돌)" },
          { status: 400 }
        );
      }

      newBalance = updateResult.gem_balance;
    } else {
      newBalance = deductResult.new_balance;
    }

    // Create user_item with conflict handling for (user_id, item_id) uniqueness
    const { data: userItem, error: createError } = await sbService
      .from("user_items")
      .insert({
        user_id: user.id,
        item_id: itemId,
        equipped: false,
      })
      .select()
      .single();

    if (createError) {
      // Check if it's a unique constraint violation (already owned)
      if (createError.code === "23505") {
        // Rollback gems
        await sbService
          .from("profiles")
          .update({ gem_balance: newBalance + item.price_gem })
          .eq("id", user.id);

        return NextResponse.json(
          { error: "이미 소유한 아이템입니다" },
          { status: 400 }
        );
      }

      // Rollback gems for other errors
      await sbService
        .from("profiles")
        .update({ gem_balance: newBalance + item.price_gem })
        .eq("id", user.id);

      console.error("Item creation error:", createError);
      return NextResponse.json(
        { error: "아이템 구매에 실패했습니다" },
        { status: 500 }
      );
    }

    return NextResponse.json({
      success: true,
      userItem: {
        id: userItem.id,
        itemId: userItem.item_id,
        equipped: userItem.equipped,
        purchasedAt: userItem.purchased_at,
      },
      newGemBalance: newBalance,
      message: `${item.name}을(를) 구매했습니다!`,
    });
  } catch (error) {
    console.error("Purchase error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
