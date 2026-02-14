import { ImageResponse } from "next/og";
import { NextRequest } from "next/server";

export const runtime = "edge";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const nickname = searchParams.get("nickname") || "용사";
  const level = searchParams.get("level") || "1";
  const jobClass = searchParams.get("job") || "견습생";
  const totalCorrect = searchParams.get("correct") || "0";
  const totalQuestions = searchParams.get("total") || "0";

  const accuracy =
    totalQuestions !== "0"
      ? Math.round(
          (parseInt(totalCorrect) / parseInt(totalQuestions)) * 100
        )
      : 0;

  return new ImageResponse(
    (
      <div
        style={{
          width: "1200px",
          height: "630px",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          background: "linear-gradient(135deg, #F5F0E8 0%, #FFE4D4 100%)",
          fontFamily: "sans-serif",
        }}
      >
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            padding: "40px",
            borderRadius: "24px",
            background: "white",
            boxShadow: "0 8px 32px rgba(0,0,0,0.1)",
            border: "4px solid #8B7355",
          }}
        >
          <div
            style={{
              fontSize: "24px",
              color: "#8B7355",
              marginBottom: "8px",
              display: "flex",
            }}
          >
            메AI플스토리
          </div>
          <div
            style={{
              fontSize: "48px",
              fontWeight: "bold",
              color: "#2D1B00",
              marginBottom: "8px",
              display: "flex",
            }}
          >
            {nickname}
          </div>
          <div
            style={{
              display: "flex",
              gap: "16px",
              marginBottom: "16px",
            }}
          >
            <div
              style={{
                padding: "8px 24px",
                borderRadius: "12px",
                background: "#FF6B35",
                color: "white",
                fontSize: "24px",
                display: "flex",
              }}
            >
              Lv.{level}
            </div>
            <div
              style={{
                padding: "8px 24px",
                borderRadius: "12px",
                background: "#4ECDC4",
                color: "white",
                fontSize: "24px",
                display: "flex",
              }}
            >
              {jobClass}
            </div>
          </div>
          <div
            style={{
              fontSize: "20px",
              color: "#666",
              display: "flex",
            }}
          >
            정답률 {accuracy}% ({totalCorrect}/{totalQuestions})
          </div>
        </div>
      </div>
    ),
    {
      width: 1200,
      height: 630,
    }
  );
}
