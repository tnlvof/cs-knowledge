"use client";

import { motion } from "framer-motion";
import { LEVEL_TABLE } from "@/constants/levels";

interface EXPBarProps {
  level: number;
  currentExp: number;
}

export default function EXPBar({ level, currentExp }: EXPBarProps) {
  const levelInfo = LEVEL_TABLE[level - 1];
  const requiredExp = levelInfo?.requiredExp ?? 100;
  const percentage = Math.min(100, (currentExp / requiredExp) * 100);

  return (
    <div className="w-full">
      <div className="mb-1 flex items-center justify-between">
        <span className="font-pixel text-xs text-exp-gold drop-shadow-[0_1px_1px_rgba(0,0,0,0.3)]">EXP</span>
        <span className="font-pixel text-xs text-text-secondary">
          {currentExp}/{requiredExp}
        </span>
      </div>
      <div className="h-3 w-full overflow-hidden rounded-sm border-2 border-maple-dark bg-gradient-to-b from-gray-700 to-gray-800 shadow-[inset_0_2px_4px_rgba(0,0,0,0.5)]">
        <motion.div
          className="h-full bg-gradient-to-b from-exp-gold to-exp-orange shadow-[inset_0_1px_0_rgba(255,255,255,0.4)]"
          initial={false}
          animate={{ width: `${percentage}%` }}
          transition={{ type: "spring", damping: 15, stiffness: 100 }}
        />
      </div>
    </div>
  );
}
