export const SUPPORTER_BADGES: Record<string, { name: string; emoji: string; color: string }> = {
  none: { name: "", emoji: "", color: "" },
  bronze: { name: "브론즈", emoji: "🥉", color: "text-amber-700" },
  silver: { name: "실버", emoji: "🥈", color: "text-gray-500" },
  gold: { name: "골드", emoji: "🥇", color: "text-yellow-500" },
};

export const SUPPORTER_TIERS = [
  { tier: "bronze", minAmount: 10000, name: "브론즈", emoji: "🥉", color: "text-amber-700" },
  { tier: "silver", minAmount: 30000, name: "실버", emoji: "🥈", color: "text-gray-500" },
  { tier: "gold", minAmount: 100000, name: "골드", emoji: "🥇", color: "text-yellow-500" },
];
