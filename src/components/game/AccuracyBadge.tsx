"use client";

import { motion } from "framer-motion";

interface AccuracyBadgeProps {
  accuracyRate: number | null;
  totalAttempts: number;
  size?: "sm" | "md";
}

/**
 * 문제별 정답률을 색상 뱃지로 표시하는 컴포넌트
 * - 80%+ 초록색 (쉬운 문제)
 * - 50-79% 노란색 (보통 문제)
 * - 30-49% 주황색 (어려운 문제)
 * - 30% 미만 빨간색 (매우 어려운 문제)
 * - 첫 도전 (totalAttempts === 0)
 */
export default function AccuracyBadge({
  accuracyRate,
  totalAttempts,
  size = "sm",
}: AccuracyBadgeProps) {
  // 아직 아무도 풀지 않은 문제
  if (totalAttempts === 0) {
    return (
      <motion.span
        className={`inline-flex items-center gap-1 rounded-full border-2 border-purple-400 bg-purple-50 font-pixel text-purple-700 ${
          size === "sm" ? "px-2 py-0.5 text-xs" : "px-3 py-1 text-sm"
        }`}
        initial={{ scale: 0.9, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ type: "spring", damping: 15 }}
      >
        <span className="text-[0.9em]">✨</span>
        <span>첫 도전!</span>
      </motion.span>
    );
  }

  // 정답률이 없는 경우 (null)
  if (accuracyRate === null || accuracyRate === undefined) {
    return null;
  }

  // 정답률을 백분율로 변환 (0~1 -> 0~100)
  const percentage = Math.round(accuracyRate * 100);

  // 정답률에 따른 색상 결정
  let colorClass: string;
  let emoji: string;

  if (percentage >= 80) {
    colorClass = "border-green-500 bg-green-50 text-green-700";
    emoji = "🟢";
  } else if (percentage >= 50) {
    colorClass = "border-yellow-500 bg-yellow-50 text-yellow-700";
    emoji = "🟡";
  } else if (percentage >= 30) {
    colorClass = "border-orange-500 bg-orange-50 text-orange-700";
    emoji = "🟠";
  } else {
    colorClass = "border-red-500 bg-red-50 text-red-700";
    emoji = "🔴";
  }

  return (
    <motion.span
      className={`inline-flex items-center gap-1 rounded-full border-2 font-pixel ${colorClass} ${
        size === "sm" ? "px-2 py-0.5 text-xs" : "px-3 py-1 text-sm"
      }`}
      initial={{ scale: 0.9, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ type: "spring", damping: 15 }}
      title={`정답률 ${percentage}% (${totalAttempts}명 도전)`}
    >
      <span className="text-[0.8em]">{emoji}</span>
      <span>정답률 {percentage}%</span>
    </motion.span>
  );
}

/**
 * 채점 결과 화면에서 "상위 N%"를 표시하는 컴포넌트
 * 유저가 정답을 맞췄을 때, 전체 유저 중 정답을 맞춘 비율을 보여줌
 */
export function TopPercentBadge({
  accuracyRate,
  isCorrect,
  size = "md",
}: {
  accuracyRate: number | null;
  isCorrect: boolean;
  size?: "sm" | "md";
}) {
  // 오답이거나 정답률 데이터가 없으면 표시하지 않음
  if (!isCorrect || accuracyRate === null || accuracyRate === undefined) {
    return null;
  }

  const percentage = Math.round(accuracyRate * 100);

  // 정답률이 낮을수록 더 특별한 색상
  let colorClass: string;
  let message: string;

  if (percentage <= 30) {
    colorClass = "bg-gradient-to-r from-red-500 to-orange-500 text-white";
    message = `상위 ${percentage}%만 맞춘 문제!`;
  } else if (percentage <= 50) {
    colorClass = "bg-gradient-to-r from-orange-500 to-yellow-500 text-white";
    message = `상위 ${percentage}%가 맞춘 문제!`;
  } else if (percentage <= 80) {
    colorClass = "bg-gradient-to-r from-yellow-400 to-green-400 text-gray-800";
    message = `${percentage}%가 맞춘 문제`;
  } else {
    colorClass = "bg-gradient-to-r from-green-400 to-emerald-400 text-white";
    message = `${percentage}%가 맞춘 문제`;
  }

  return (
    <motion.div
      className={`rounded-lg font-pixel shadow-md ${colorClass} ${
        size === "sm" ? "px-3 py-1.5 text-xs" : "px-4 py-2 text-sm"
      }`}
      initial={{ scale: 0, opacity: 0, y: 20 }}
      animate={{ scale: 1, opacity: 1, y: 0 }}
      transition={{ type: "spring", damping: 12, delay: 0.3 }}
    >
      <div className="flex items-center justify-center gap-2">
        <span>🏆</span>
        <span>{message}</span>
      </div>
    </motion.div>
  );
}
