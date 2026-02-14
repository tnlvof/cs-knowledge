import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

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

    const sb = supabase as any;

    // Get user items with shop item details
    const { data, error } = await sb
      .from("user_items")
      .select(
        `
        *,
        item:shop_items(*)
      `
      )
      .eq("user_id", user.id)
      .order("purchased_at", { ascending: false });

    if (error) {
      console.error("Inventory fetch error:", error);
      return NextResponse.json(
        { error: "인벤토리를 불러오는데 실패했습니다" },
        { status: 500 }
      );
    }

    // Transform to camelCase
    const inventory = (data || []).map((ui: any) => ({
      id: ui.id,
      userId: ui.user_id,
      itemId: ui.item_id,
      equipped: ui.equipped,
      purchasedAt: ui.purchased_at,
      item: ui.item
        ? {
            id: ui.item.id,
            name: ui.item.name,
            category: ui.item.category,
            description: ui.item.description,
            priceGem: ui.item.price_gem,
            imageUrl: ui.item.image_url,
            rarity: ui.item.rarity,
          }
        : null,
    }));

    // Get equipped items grouped by category
    const equipped = inventory
      .filter((item: any) => item.equipped)
      .reduce((acc: Record<string, any>, item: any) => {
        if (item.item?.category) {
          acc[item.item.category] = item;
        }
        return acc;
      }, {});

    return NextResponse.json({
      inventory,
      equipped,
      totalItems: inventory.length,
    });
  } catch (error) {
    console.error("Inventory error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
