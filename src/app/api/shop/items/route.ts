import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient();
    const sb = supabase as any;

    const { searchParams } = new URL(request.url);
    const category = searchParams.get("category");

    let query = sb.from("shop_items").select("*").order("price_gem", { ascending: true });

    if (category) {
      query = query.eq("category", category);
    }

    const { data, error } = await query;

    if (error) {
      console.error("Shop items fetch error:", error);
      return NextResponse.json(
        { error: "상품을 불러오는데 실패했습니다" },
        { status: 500 }
      );
    }

    // Transform to camelCase
    const items = (data || []).map((item: any) => ({
      id: item.id,
      name: item.name,
      category: item.category,
      description: item.description,
      priceGem: item.price_gem,
      imageUrl: item.image_url,
      rarity: item.rarity,
      createdAt: item.created_at,
    }));

    return NextResponse.json({ items });
  } catch (error) {
    console.error("Shop items error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
