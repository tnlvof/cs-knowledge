"use client";

import { motion, useReducedMotion } from "framer-motion";

interface RankChangeProps {
  change: number;
  size?: "sm" | "md" | "lg";
}

/**
 * T113: 순위 변동 표시 컴포넌트
 * "+3" in green (상승), "-2" in red (하락), "" for no change
 */
export default function RankChange({ change, size = "sm" }: RankChangeProps) {
  const shouldReduceMotion = useReducedMotion();

  if (change === 0) {
    return (
      <span
        className={`font-pixel text-text-secondary ${
          size === "sm" ? "text-xs" : size === "md" ? "text-sm" : "text-base"
        }`}
      >
        -
      </span>
    );
  }

  const isUp = change > 0;
  const colorClass = isUp
    ? "bg-green-100 text-green-600 border-green-300"
    : "bg-red-100 text-red-600 border-red-300";

  const sizeClass =
    size === "sm"
      ? "px-1.5 py-0.5 text-[10px]"
      : size === "md"
        ? "px-2 py-0.5 text-xs"
        : "px-2.5 py-1 text-sm";

  return (
    <motion.span
      className={`inline-flex items-center gap-0.5 rounded-full border font-pixel ${colorClass} ${sizeClass}`}
      initial={{ scale: 0, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ type: "spring", damping: 12, stiffness: 200 }}
    >
      {isUp ? (
        <>
          <span>+{change}</span>
          <motion.span
            animate={shouldReduceMotion ? {} : { y: [-1, 1, -1] }}
            transition={shouldReduceMotion ? {} : { repeat: Infinity, duration: 0.8 }}
          >
            ↑
          </motion.span>
        </>
      ) : (
        <>
          <span>{change}</span>
          <motion.span
            animate={shouldReduceMotion ? {} : { y: [1, -1, 1] }}
            transition={shouldReduceMotion ? {} : { repeat: Infinity, duration: 0.8 }}
          >
            ↓
          </motion.span>
        </>
      )}
    </motion.span>
  );
}
