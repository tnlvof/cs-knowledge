import { NextRequest, NextResponse } from "next/server";
import { createClient, getAuthUser } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  try {
    const supabase = await createClient();
    const user = await getAuthUser(supabase);

    if (!user) {
      return NextResponse.json(
        { error: "로그인이 필요합니다" },
        { status: 401 }
      );
    }

    const { searchParams } = new URL(request.url);
    const MAX_LIMIT = 100;
    const page = Math.max(1, parseInt(searchParams.get("page") || "1", 10));
    const limit = Math.min(MAX_LIMIT, Math.max(1, parseInt(searchParams.get("limit") || "20", 10)));
    const category = searchParams.get("category");

    const offset = (page - 1) * limit;
    const sb = supabase as any;

    // Build query for wrong and partial answers
    let query = sb
      .from("quiz_history")
      .select(
        `
        *,
        question:questions(id, category, subcategory, question_text, correct_answer, explanation, keywords)
      `,
        { count: "exact" }
      )
      .eq("user_id", user.id)
      .in("is_correct", ["wrong", "partial"])
      .order("created_at", { ascending: false });

    // Apply category filter
    if (category) {
      query = query.eq("question.category", category);
    }

    // Apply pagination
    query = query.range(offset, offset + limit - 1);

    const { data, error, count } = await query;

    if (error) {
      console.error("Wrong notes fetch error:", error);
      return NextResponse.json(
        { error: "오답노트를 불러오는데 실패했습니다" },
        { status: 500 }
      );
    }

    // Group by question to show unique wrong answers
    const groupedData: Record<string, any> = {};
    data?.forEach((item: any) => {
      const questionId = item.question_id;
      if (!groupedData[questionId]) {
        groupedData[questionId] = {
          ...item,
          attempts: 1,
          lastAttempt: item.created_at,
        };
      } else {
        groupedData[questionId].attempts++;
        if (
          new Date(item.created_at) >
          new Date(groupedData[questionId].lastAttempt)
        ) {
          groupedData[questionId].lastAttempt = item.created_at;
          groupedData[questionId].user_answer = item.user_answer;
          groupedData[questionId].ai_feedback = item.ai_feedback;
          groupedData[questionId].ai_score = item.ai_score;
        }
      }
    });

    return NextResponse.json({
      data: Object.values(groupedData),
      pagination: {
        page,
        limit,
        total: count || 0,
        totalPages: Math.ceil((count || 0) / limit),
      },
    });
  } catch (error) {
    console.error("Wrong notes error:", error);
    return NextResponse.json(
      { error: "서버 오류가 발생했습니다" },
      { status: 500 }
    );
  }
}
