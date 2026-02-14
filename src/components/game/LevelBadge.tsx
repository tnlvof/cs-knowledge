import { LEVEL_TABLE, TIER_NAMES } from "@/constants/levels";

interface LevelBadgeProps {
  level: number;
  size?: "sm" | "md" | "lg";
}

const tierColors: Record<string, string> = {
  trainee: "border-gray-400 bg-gradient-to-b from-gray-100 to-gray-200 text-gray-600",
  apprentice: "border-green-600 bg-gradient-to-b from-green-50 to-green-100 text-green-700",
  regular: "border-mp-blue bg-gradient-to-b from-blue-50 to-blue-100 text-blue-700",
  veteran: "border-purple-500 bg-gradient-to-b from-purple-50 to-purple-100 text-purple-700",
  master: "border-maple-gold bg-gradient-to-b from-amber-50 to-amber-100 text-amber-700 shadow-[0_0_6px_rgba(245,180,72,0.3)]",
  legend: "border-hp-red bg-gradient-to-b from-amber-50 to-red-50 text-red-700 shadow-[0_0_8px_rgba(224,49,49,0.3)]",
};

const sizeStyles = {
  sm: "px-1.5 py-0.5 text-xs",
  md: "px-2.5 py-1 text-sm",
  lg: "px-3 py-1.5 text-base",
};

export default function LevelBadge({ level, size = "md" }: LevelBadgeProps) {
  const levelInfo = LEVEL_TABLE[level - 1] ?? LEVEL_TABLE[0];
  const tier = levelInfo.tier;

  return (
    <span
      className={`inline-flex items-center gap-1 rounded-md border-2 font-pixel ${tierColors[tier] ?? tierColors.trainee} ${sizeStyles[size]}`}
    >
      <span>Lv.{level}</span>
      <span className="text-[0.7em] opacity-70">
        {TIER_NAMES[tier]}
      </span>
    </span>
  );
}
