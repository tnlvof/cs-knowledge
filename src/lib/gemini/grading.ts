import { GoogleGenerativeAI } from "@google/generative-ai";
import type { GradingResponse, GradingResult } from "@/types/game";

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "");

const GRADING_PROMPT = `당신은 IT/CS 지식 퀴즈의 채점관입니다. 사용자의 주관식 답변을 채점해주세요.

## 채점 기준
1. 핵심 키워드 포함 여부 (40%)
2. 개념 정확성 (40%)
3. 답변 완성도 (20%)

## 점수 기준
- 0.8 이상: 정답 (핵심 개념을 정확히 이해하고 키워드 대부분 포함)
- 0.3~0.8 미만: 부분 정답 (일부 개념은 맞지만 불완전)
- 0.3 미만: 오답 (핵심 개념을 이해하지 못함)

## 응답 형식 (반드시 JSON)
{
  "score": 0.0~1.0,
  "feedback": "채점 피드백 (2-3문장)",
  "correctAnswer": "모범 답안 요약",
  "tip": "학습 팁 (1문장)"
}

## 문제 정보
- 문제: {question}
- 모범 답안: {correctAnswer}
- 핵심 키워드: {keywords}

## 사용자 답변
{userAnswer}

위 기준에 따라 JSON으로만 응답하세요.`;

function classifyScore(score: number): GradingResult {
  if (score >= 0.8) return "correct";
  if (score >= 0.3) return "partial";
  return "wrong";
}

async function callGemini(prompt: string): Promise<string> {
  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });
  const result = await model.generateContent(prompt);
  return result.response.text();
}

function parseGradingResponse(text: string): Omit<GradingResponse, "isCorrect"> {
  // JSON 블록 추출
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (!jsonMatch) {
    throw new Error("JSON 응답을 파싱할 수 없습니다");
  }

  const parsed = JSON.parse(jsonMatch[0]);
  return {
    score: Math.max(0, Math.min(1, Number(parsed.score) || 0)),
    feedback: String(parsed.feedback || "채점 결과를 확인해주세요"),
    correctAnswer: String(parsed.correctAnswer || ""),
    tip: String(parsed.tip || ""),
  };
}

export async function gradeAnswer(params: {
  questionText: string;
  correctAnswer: string;
  keywords: string[];
  userAnswer: string;
}): Promise<GradingResponse> {
  const prompt = GRADING_PROMPT.replace("{question}", params.questionText)
    .replace("{correctAnswer}", params.correctAnswer)
    .replace("{keywords}", params.keywords.join(", "))
    .replace("{userAnswer}", params.userAnswer);

  const MAX_RETRIES = 3;
  let lastError: Error | null = null;

  for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
    try {
      const responseText = await callGemini(prompt);
      const parsed = parseGradingResponse(responseText);

      return {
        ...parsed,
        isCorrect: classifyScore(parsed.score),
      };
    } catch (error) {
      lastError = error instanceof Error ? error : new Error(String(error));
      // 지수 백오프
      if (attempt < MAX_RETRIES - 1) {
        await new Promise((resolve) =>
          setTimeout(resolve, Math.pow(2, attempt) * 1000)
        );
      }
    }
  }

  throw lastError || new Error("AI 채점에 실패했습니다");
}
