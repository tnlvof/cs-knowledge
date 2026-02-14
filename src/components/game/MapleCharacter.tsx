"use client";

import { motion, AnimatePresence } from "framer-motion";
import { useMemo } from "react";

const AVATAR_CONFIG: Record<
  string,
  { emoji: string; auraColor: string; auraGlow: string; label: string }
> = {
  warrior: {
    emoji: "⚔️",
    auraColor: "rgba(254, 119, 2, 0.15)",
    auraGlow: "rgba(254, 119, 2, 0.4)",
    label: "검사",
  },
  mage: {
    emoji: "🧙",
    auraColor: "rgba(177, 151, 252, 0.15)",
    auraGlow: "rgba(177, 151, 252, 0.4)",
    label: "마법사",
  },
  archer: {
    emoji: "🏹",
    auraColor: "rgba(64, 192, 87, 0.15)",
    auraGlow: "rgba(64, 192, 87, 0.4)",
    label: "궁수",
  },
  healer: {
    emoji: "🗡️",
    auraColor: "rgba(92, 42, 30, 0.15)",
    auraGlow: "rgba(92, 42, 30, 0.4)",
    label: "도적",
  },
};

// 캐릭터 주변 파티클 생성
function useParticles(count: number) {
  return useMemo(() => {
    const symbols = ["✦", "⭐", "✧", "★", "◆", "❖"];
    return Array.from({ length: count }, (_, i) => ({
      id: i,
      symbol: symbols[i % symbols.length],
      x: Math.random() * 160 - 80,
      y: Math.random() * 160 - 80,
      delay: Math.random() * 3,
      duration: 2 + Math.random() * 2,
      size: 8 + Math.random() * 8,
    }));
  }, [count]);
}

interface MapleCharacterProps {
  avatarType: string;
  size?: "sm" | "md" | "lg";
  showParticles?: boolean;
  showPlatform?: boolean;
  showAura?: boolean;
}

export default function MapleCharacter({
  avatarType,
  size = "lg",
  showParticles = true,
  showPlatform = true,
  showAura = true,
}: MapleCharacterProps) {
  const config = AVATAR_CONFIG[avatarType] || AVATAR_CONFIG.warrior;
  const particles = useParticles(showParticles ? 8 : 0);

  const sizeMap = {
    sm: { emoji: "text-4xl", container: "h-20 w-20" },
    md: { emoji: "text-6xl", container: "h-28 w-28" },
    lg: { emoji: "text-8xl", container: "h-40 w-40" },
  };

  const s = sizeMap[size];

  return (
    <div className="relative flex flex-col items-center">
      {/* 파티클 */}
      {showParticles && (
        <div className="pointer-events-none absolute inset-0 z-10">
          {particles.map((p) => (
            <motion.span
              key={p.id}
              className="absolute left-1/2 top-1/2 text-maple-gold"
              style={{ fontSize: p.size }}
              initial={{ opacity: 0, x: 0, y: 0 }}
              animate={{
                opacity: [0, 0.8, 0],
                x: [0, p.x],
                y: [0, p.y],
                scale: [0.5, 1, 0.3],
              }}
              transition={{
                duration: p.duration,
                delay: p.delay,
                repeat: Infinity,
                ease: "easeOut",
              }}
            >
              {p.symbol}
            </motion.span>
          ))}
        </div>
      )}

      {/* 오라/글로우 */}
      {showAura && (
        <motion.div
          className="absolute rounded-full"
          style={{
            width: size === "lg" ? 180 : size === "md" ? 130 : 90,
            height: size === "lg" ? 180 : size === "md" ? 130 : 90,
            background: `radial-gradient(circle, ${config.auraColor} 0%, transparent 70%)`,
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -55%)",
          }}
          animate={{
            scale: [1, 1.15, 1],
            opacity: [0.6, 1, 0.6],
          }}
          transition={{
            duration: 3,
            repeat: Infinity,
            ease: "easeInOut",
          }}
        />
      )}

      {/* 캐릭터 본체 */}
      <AnimatePresence mode="wait">
        <motion.div
          key={avatarType}
          className={`relative z-20 flex items-center justify-center ${s.container}`}
          initial={{ scale: 0.5, opacity: 0, y: 20 }}
          animate={{ scale: 1, opacity: 1, y: 0 }}
          exit={{ scale: 0.5, opacity: 0, y: -20 }}
          transition={{ type: "spring", damping: 12, stiffness: 200 }}
        >
          {/* 아이들 바운스 */}
          <motion.span
            className={`${s.emoji} drop-shadow-lg`}
            style={{
              filter: `drop-shadow(0 0 12px ${config.auraGlow})`,
            }}
            animate={{ y: [0, -8, 0] }}
            transition={{
              duration: 2,
              repeat: Infinity,
              ease: "easeInOut",
            }}
          >
            {config.emoji}
          </motion.span>
        </motion.div>
      </AnimatePresence>

      {/* 그림자 */}
      {showPlatform && (
        <motion.div
          className="z-10 mt-1"
          animate={{ scaleX: [1, 1.1, 1], opacity: [0.3, 0.2, 0.3] }}
          transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
        >
          <div
            className="h-3 rounded-full bg-maple-dark/20"
            style={{
              width: size === "lg" ? 100 : size === "md" ? 70 : 50,
              filter: "blur(4px)",
            }}
          />
        </motion.div>
      )}

      {/* 발판 */}
      {showPlatform && (
        <div className="relative z-0 -mt-1">
          <div
            className="rounded-md border-2 border-maple-medium/60 bg-gradient-to-b from-maple-medium to-maple-dark shadow-[0_4px_8px_rgba(61,35,20,0.3)]"
            style={{
              width: size === "lg" ? 120 : size === "md" ? 90 : 60,
              height: size === "lg" ? 16 : size === "md" ? 12 : 8,
            }}
          >
            {/* 발판 하이라이트 */}
            <div className="absolute inset-x-2 top-0.5 h-1 rounded-full bg-white/20" />
          </div>
        </div>
      )}
    </div>
  );
}
