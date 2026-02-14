import { ImageResponse } from "next/og";
import { NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { CATEGORIES, CATEGORY_MAP } from "@/constants/categories";
import { JOBS, DEFAULT_JOB, JOB_TIER_PREFIX } from "@/constants/jobs";
import { TIER_NAMES } from "@/constants/levels";

export const runtime = "edge";

const SUPPORTER_BADGES: Record<string, string> = {
  bronze: "🥉",
  silver: "🥈",
  gold: "🥇",
};

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ nickname: string }> }
) {
  try {
    const { nickname } = await params;

    if (!nickname) {
      return new Response("Nickname required", { status: 400 });
    }

    const supabase = await createClient();
    const sb = supabase as any;

    // Get profile
    const { data: profile } = await sb
      .from("profiles")
      .select("*")
      .eq("nickname", nickname)
      .single();

    if (!profile) {
      return new Response("Profile not found", { status: 404 });
    }

    // Get category stats
    const { data: historyData } = await sb
      .from("quiz_history")
      .select("ai_score, is_correct, question:questions(category)")
      .eq("user_id", profile.id);

    const categoryStats: Record<string, { total: number; correct: number }> = {};
    CATEGORIES.forEach((cat) => {
      categoryStats[cat.id] = { total: 0, correct: 0 };
    });

    (historyData || []).forEach((item: any) => {
      const category = item.question?.category;
      if (category && categoryStats[category]) {
        categoryStats[category].total++;
        if (item.is_correct === "correct") {
          categoryStats[category].correct++;
        }
      }
    });

    // Find top category
    let topCategory = null;
    let maxCorrect = 0;
    Object.entries(categoryStats).forEach(([catId, stats]) => {
      if (stats.correct > maxCorrect) {
        maxCorrect = stats.correct;
        topCategory = catId;
      }
    });

    const currentJob =
      profile.job_class === "novice"
        ? DEFAULT_JOB
        : JOBS.find((j) => j.id === profile.job_class) || DEFAULT_JOB;

    const jobDisplayName =
      profile.job_tier > 0
        ? `${JOB_TIER_PREFIX[profile.job_tier] || ""}${currentJob.name}`
        : currentJob.name;

    const tierKey = profile.level < 10 ? "trainee" :
      profile.level < 30 ? "apprentice" :
      profile.level < 50 ? "regular" :
      profile.level < 70 ? "veteran" :
      profile.level < 90 ? "master" : "legend";
    const tierName = TIER_NAMES[tierKey];

    const accuracy =
      profile.total_questions > 0
        ? Math.round((profile.total_correct / profile.total_questions) * 100)
        : 0;

    return new ImageResponse(
      (
        <div
          style={{
            width: "600px",
            height: "900px",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "flex-start",
            background: "linear-gradient(180deg, #FFF8E7 0%, #FFE4B5 100%)",
            fontFamily: "sans-serif",
            padding: "40px",
          }}
        >
          {/* Header */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: "12px",
              marginBottom: "20px",
            }}
          >
            <span style={{ fontSize: "24px" }}>⚔️</span>
            <span style={{ fontSize: "20px", color: "#8B4513", fontWeight: "bold" }}>
              MeAIple Story
            </span>
          </div>

          {/* Avatar Card */}
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              backgroundColor: "#FFFAF0",
              borderRadius: "24px",
              border: "3px solid #DAA520",
              padding: "32px",
              width: "100%",
              boxShadow: "0 8px 32px rgba(218, 165, 32, 0.3)",
            }}
          >
            {/* Avatar */}
            <div
              style={{
                width: "120px",
                height: "120px",
                borderRadius: "60px",
                backgroundColor: "#FFE4B5",
                border: "4px solid #DAA520",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                fontSize: "60px",
                marginBottom: "16px",
              }}
            >
              {currentJob.emoji}
            </div>

            {/* Nickname & Level */}
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: "12px",
                marginBottom: "8px",
              }}
            >
              <span style={{ fontSize: "32px", fontWeight: "bold", color: "#2D1B0E" }}>
                {profile.nickname}
              </span>
              {profile.supporter_tier !== "none" && (
                <span style={{ fontSize: "28px" }}>
                  {SUPPORTER_BADGES[profile.supporter_tier]}
                </span>
              )}
            </div>

            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: "8px",
                marginBottom: "24px",
              }}
            >
              <span
                style={{
                  backgroundColor: "#FFD700",
                  color: "#8B4513",
                  padding: "4px 12px",
                  borderRadius: "12px",
                  fontSize: "16px",
                  fontWeight: "bold",
                }}
              >
                Lv.{profile.level} {tierName}
              </span>
              <span style={{ fontSize: "16px", color: "#666" }}>{jobDisplayName}</span>
            </div>

            {/* Stats Grid */}
            <div
              style={{
                display: "flex",
                width: "100%",
                gap: "16px",
                marginBottom: "24px",
              }}
            >
              <div
                style={{
                  flex: 1,
                  backgroundColor: "#FFF",
                  borderRadius: "12px",
                  padding: "16px",
                  textAlign: "center",
                  display: "flex",
                  flexDirection: "column",
                  alignItems: "center",
                }}
              >
                <span style={{ fontSize: "32px", fontWeight: "bold", color: "#FF6B35" }}>
                  {profile.total_questions}
                </span>
                <span style={{ fontSize: "14px", color: "#666" }}>총 문제</span>
              </div>
              <div
                style={{
                  flex: 1,
                  backgroundColor: "#FFF",
                  borderRadius: "12px",
                  padding: "16px",
                  textAlign: "center",
                  display: "flex",
                  flexDirection: "column",
                  alignItems: "center",
                }}
              >
                <span style={{ fontSize: "32px", fontWeight: "bold", color: "#22C55E" }}>
                  {profile.total_correct}
                </span>
                <span style={{ fontSize: "14px", color: "#666" }}>정답</span>
              </div>
              <div
                style={{
                  flex: 1,
                  backgroundColor: "#FFF",
                  borderRadius: "12px",
                  padding: "16px",
                  textAlign: "center",
                  display: "flex",
                  flexDirection: "column",
                  alignItems: "center",
                }}
              >
                <span style={{ fontSize: "32px", fontWeight: "bold", color: "#3B82F6" }}>
                  {accuracy}%
                </span>
                <span style={{ fontSize: "14px", color: "#666" }}>정답률</span>
              </div>
            </div>

            {/* Top Category */}
            {topCategory && (
              <div
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: "8px",
                  backgroundColor: "#E8F5E9",
                  padding: "12px 20px",
                  borderRadius: "12px",
                  marginBottom: "16px",
                }}
              >
                <span style={{ fontSize: "24px" }}>
                  {CATEGORY_MAP[topCategory as keyof typeof CATEGORY_MAP]?.emoji}
                </span>
                <span style={{ fontSize: "16px", color: "#2E7D32" }}>
                  {CATEGORY_MAP[topCategory as keyof typeof CATEGORY_MAP]?.name} 전문가
                </span>
              </div>
            )}

            {/* Estimated Salary */}
            <div
              style={{
                display: "flex",
                alignItems: "center",
                gap: "8px",
                backgroundColor: "#ECFDF5",
                border: "2px solid #10B981",
                padding: "12px 20px",
                borderRadius: "12px",
                marginBottom: "24px",
              }}
            >
              <span style={{ fontSize: "24px" }}>💰</span>
              <div style={{ display: "flex", flexDirection: "column" }}>
                <span style={{ fontSize: "12px", color: "#059669" }}>예상 연봉</span>
                <span style={{ fontSize: "20px", fontWeight: "bold", color: "#047857" }}>
                  {(profile.estimated_salary || 2400).toLocaleString()}만원
                </span>
              </div>
            </div>

            {/* Category Bars */}
            <div style={{ width: "100%", display: "flex", flexDirection: "column", gap: "8px" }}>
              {CATEGORIES.slice(0, 4).map((cat) => {
                const stat = categoryStats[cat.id];
                const percentage = stat.total > 0 ? (stat.correct / stat.total) * 100 : 0;
                return (
                  <div
                    key={cat.id}
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: "8px",
                    }}
                  >
                    <span style={{ fontSize: "16px", width: "24px" }}>{cat.emoji}</span>
                    <span style={{ fontSize: "12px", color: "#666", width: "60px" }}>
                      {cat.name}
                    </span>
                    <div
                      style={{
                        flex: 1,
                        height: "12px",
                        backgroundColor: "#E5E7EB",
                        borderRadius: "6px",
                        overflow: "hidden",
                        display: "flex",
                      }}
                    >
                      <div
                        style={{
                          width: `${percentage}%`,
                          height: "100%",
                          backgroundColor: cat.color,
                          borderRadius: "6px",
                        }}
                      />
                    </div>
                    <span style={{ fontSize: "12px", color: "#666", width: "40px" }}>
                      {Math.round(percentage)}%
                    </span>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Footer */}
          <div
            style={{
              marginTop: "auto",
              display: "flex",
              alignItems: "center",
              gap: "8px",
              color: "#8B4513",
              fontSize: "14px",
            }}
          >
            <span>meaiple-story.vercel.app</span>
          </div>
        </div>
      ),
      {
        width: 600,
        height: 900,
      }
    );
  } catch (error) {
    console.error("OG image error:", error);
    return new Response("Error generating image", { status: 500 });
  }
}
