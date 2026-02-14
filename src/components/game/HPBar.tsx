"use client";

import { motion } from "framer-motion";

interface HPBarProps {
  current: number;
  max: number;
  label?: string;
  variant?: "player" | "monster";
}

export default function HPBar({
  current,
  max,
  label,
  variant = "player",
}: HPBarProps) {
  const percentage = Math.max(0, Math.min(100, (current / max) * 100));

  const barColor =
    variant === "monster"
      ? "bg-gradient-to-b from-purple-400 to-purple-600"
      : percentage > 50
        ? "bg-gradient-to-b from-hp-pink to-hp-red"
        : percentage > 25
          ? "bg-gradient-to-b from-orange-400 to-orange-600"
          : "bg-gradient-to-b from-red-500 to-red-800 animate-pulse";

  return (
    <div className="w-full">
      {label && (
        <div className="mb-1 flex items-center justify-between">
          <span className="font-pixel text-xs text-text-secondary">
            {label}
          </span>
          <span className="font-pixel text-xs text-text-primary">
            {current}/{max}
          </span>
        </div>
      )}
      <div className="h-4 w-full overflow-hidden rounded-sm border-2 border-maple-dark bg-gradient-to-b from-gray-700 to-gray-800 shadow-[inset_0_2px_4px_rgba(0,0,0,0.5)]">
        <motion.div
          className={`h-full ${barColor} shadow-[inset_0_1px_0_rgba(255,255,255,0.35)]`}
          initial={false}
          animate={{ width: `${percentage}%` }}
          transition={{ type: "spring", damping: 15, stiffness: 100 }}
        />
      </div>
    </div>
  );
}
