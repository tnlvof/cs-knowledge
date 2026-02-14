import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { randomUUID } from "crypto";

// Gem package mapping: amount -> gems
const GEM_PACKAGES: Record<number, number> = {
  1000: 100,
  3000: 330,
  5000: 575,
  10000: 1200,
};

const VALID_AMOUNTS = Object.keys(GEM_PACKAGES).map(Number);

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
    const { amount } = body;

    // Validate amount
    if (!amount || !VALID_AMOUNTS.includes(amount)) {
      return NextResponse.json(
        { error: "유효하지 않은 결제 금액입니다" },
        { status: 400 }
      );
    }

    const gemAmount = GEM_PACKAGES[amount];
    const orderId = `MEAIPLE_${Date.now()}_${randomUUID().slice(0, 8).toUpperCase()}`;

    const sb = supabase as any;

    // Create pending donation record
    const { data: donation, error } = await sb
      .from("donations")
      .insert({
        user_id: user.id,
        amount,
        gem_amount: gemAmount,
        order_id: orderId,
        status: "pending",
      })
      .select()
      .single();

    if (error) {
      console.error("Donation creation error:", error);
      return NextResponse.json(
        { error: "결제 준비에 실패했습니다" },
        { status: 500 }
      );
    }

    // Get user profile for customer info
    const { data: profile } = await sb
      .from("profiles")
      .select("nickname")
      .eq("id", user.id)
      .single();

    return NextResponse.json({
      orderId,
      amount,
      gemAmount,
      orderName: `젬 ${gemAmount}개 패키지`,
      customerName: profile?.nickname || "용사",
      customerEmail: user.email,
      donationId: donation.id,
    });
  } catch (error) {
    console.error("Payment ready error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
