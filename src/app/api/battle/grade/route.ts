import { NextRequest, NextResponse } from "next/server";
import { gradeAnswer } from "@/lib/gemini/grading";

// Simple in-memory rate limiter
const rateLimitMap = new Map<string, number[]>();
const RATE_LIMIT_WINDOW_MS = 60 * 1000; // 1 minute
const RATE_LIMIT_MAX_REQUESTS = 10;

function getClientIP(request: NextRequest): string {
  const forwardedFor = request.headers.get("x-forwarded-for");
  if (forwardedFor) {
    return forwardedFor.split(",")[0].trim();
  }
  const realIP = request.headers.get("x-real-ip");
  if (realIP) {
    return realIP;
  }
  return "unknown";
}

function isRateLimited(ip: string): boolean {
  const now = Date.now();
  const timestamps = rateLimitMap.get(ip) || [];

  // Filter out timestamps outside the window
  const recentTimestamps = timestamps.filter(
    (ts) => now - ts < RATE_LIMIT_WINDOW_MS
  );

  if (recentTimestamps.length >= RATE_LIMIT_MAX_REQUESTS) {
    return true;
  }

  // Add current timestamp and update map
  recentTimestamps.push(now);
  rateLimitMap.set(ip, recentTimestamps);

  // Cleanup old entries periodically (every 100 requests)
  if (rateLimitMap.size > 1000) {
    for (const [key, value] of rateLimitMap.entries()) {
      const filtered = value.filter((ts) => now - ts < RATE_LIMIT_WINDOW_MS);
      if (filtered.length === 0) {
        rateLimitMap.delete(key);
      } else {
        rateLimitMap.set(key, filtered);
      }
    }
  }

  return false;
}

export async function POST(request: NextRequest) {
  try {
    // Rate limiting check
    const clientIP = getClientIP(request);
    if (isRateLimited(clientIP)) {
      return NextResponse.json(
        { error: "요청이 너무 많습니다. 잠시 후 다시 시도해주세요." },
        { status: 429 }
      );
    }

    const body = await request.json();
    const { userAnswer, questionText, correctAnswer, keywords } = body;

    if (!userAnswer || !questionText || !correctAnswer) {
      return NextResponse.json(
        { error: "필수 필드가 누락되었습니다" },
        { status: 400 }
      );
    }

    if (typeof userAnswer !== "string" || userAnswer.trim().length === 0) {
      return NextResponse.json(
        { error: "답변을 입력해주세요" },
        { status: 400 }
      );
    }

    const grading = await gradeAnswer({
      questionText: String(questionText),
      correctAnswer: String(correctAnswer),
      keywords: Array.isArray(keywords) ? keywords.map(String) : [],
      userAnswer: String(userAnswer),
    });

    return NextResponse.json({ grading });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "AI 채점에 실패했습니다";
    return NextResponse.json(
      { error: message },
      { status: 503 }
    );
  }
}
