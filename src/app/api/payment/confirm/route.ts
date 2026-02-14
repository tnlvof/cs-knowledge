import { NextRequest, NextResponse } from "next/server";
import { createClient, createServiceClient } from "@/lib/supabase/server";

const TOSS_SECRET_KEY = process.env.TOSS_PAYMENTS_SECRET_KEY || "";
const TOSS_API_URL = "https://api.tosspayments.com/v1/payments/confirm";

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
    const { paymentKey, orderId, amount } = body;

    if (!paymentKey || !orderId || !amount) {
      return NextResponse.json(
        { error: "필수 파라미터가 누락되었습니다" },
        { status: 400 }
      );
    }

    const sb = supabase as any;

    // Verify order exists and amount matches
    const { data: donation, error: donationError } = await sb
      .from("donations")
      .select("*")
      .eq("order_id", orderId)
      .eq("user_id", user.id)
      .eq("status", "pending")
      .single();

    if (donationError || !donation) {
      return NextResponse.json(
        { error: "주문을 찾을 수 없습니다" },
        { status: 404 }
      );
    }

    // Validate amount
    if (donation.amount !== amount) {
      return NextResponse.json(
        { error: "결제 금액이 일치하지 않습니다" },
        { status: 400 }
      );
    }

    // Call TossPayments confirm API
    const tossResponse = await fetch(TOSS_API_URL, {
      method: "POST",
      headers: {
        Authorization: `Basic ${Buffer.from(`${TOSS_SECRET_KEY}:`).toString("base64")}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        paymentKey,
        orderId,
        amount,
      }),
    });

    const tossData = await tossResponse.json();

    if (!tossResponse.ok) {
      console.error("TossPayments error:", tossData);

      // Update donation status to cancelled
      await sb
        .from("donations")
        .update({ status: "cancelled" })
        .eq("id", donation.id);

      return NextResponse.json(
        { error: tossData.message || "결제 승인에 실패했습니다" },
        { status: 400 }
      );
    }

    // Use service client for atomic updates
    const serviceClient = await createServiceClient();
    const sbService = serviceClient as any;

    // Atomic update: only succeeds if status is still 'pending' (prevents race condition)
    const { data: updatedDonation, error: updateError } = await sbService
      .from("donations")
      .update({
        status: "confirmed",
        payment_key: paymentKey,
      })
      .eq("order_id", orderId)
      .eq("status", "pending")
      .select()
      .single();

    if (updateError || !updatedDonation) {
      // Another request already processed this payment
      return NextResponse.json(
        { error: "이미 처리된 결제입니다" },
        { status: 409 }
      );
    }

    // Add gems to user profile
    const { data: profile } = await sbService
      .from("profiles")
      .select("gem_balance, total_donated, supporter_tier")
      .eq("id", user.id)
      .single();

    const newGemBalance = (profile?.gem_balance || 0) + donation.gem_amount;
    const newTotalDonated = (profile?.total_donated || 0) + amount;

    // Calculate supporter tier
    let supporterTier = "none";
    if (newTotalDonated >= 100000) {
      supporterTier = "gold";
    } else if (newTotalDonated >= 30000) {
      supporterTier = "silver";
    } else if (newTotalDonated >= 10000) {
      supporterTier = "bronze";
    }

    const { error: profileError } = await sbService
      .from("profiles")
      .update({
        gem_balance: newGemBalance,
        total_donated: newTotalDonated,
        supporter_tier: supporterTier,
      })
      .eq("id", user.id);

    if (profileError) {
      console.error("Profile update error:", profileError);
      return NextResponse.json(
        { error: "젬 지급에 실패했습니다" },
        { status: 500 }
      );
    }

    return NextResponse.json({
      success: true,
      gemAmount: donation.gem_amount,
      newGemBalance,
      supporterTier,
      message: `${donation.gem_amount}젬이 지급되었습니다!`,
    });
  } catch (error) {
    console.error("Payment confirm error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
