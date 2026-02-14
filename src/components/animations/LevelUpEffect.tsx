"use client";

import { motion, AnimatePresence } from "framer-motion";

interface LevelUpEffectProps {
  show: boolean;
  newLevel: number;
  onComplete?: () => void;
}

export default function LevelUpEffect({
  show,
  newLevel,
  onComplete,
}: LevelUpEffectProps) {
  return (
    <AnimatePresence>
      {show && (
        <motion.div
          className="pointer-events-none fixed inset-0 z-50 flex flex-col items-center justify-center"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.5 }}
          onAnimationComplete={() => {
            setTimeout(() => onComplete?.(), 1500);
          }}
        >
          {/* 배경 오버레이 */}
          <motion.div
            className="absolute inset-0 bg-black/50"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          />

          {/* 메이플스토리 빛기둥 효과 */}
          <motion.div
            className="absolute left-1/2 h-full w-24 -translate-x-1/2 bg-gradient-to-t from-transparent via-maple-gold/50 to-transparent"
            initial={{ scaleY: 0, opacity: 0 }}
            animate={{ scaleY: 1, opacity: 1 }}
            transition={{ duration: 0.5 }}
          />
          <motion.div
            className="absolute left-1/2 h-full w-12 -translate-x-1/2 bg-gradient-to-t from-transparent via-white/30 to-transparent"
            initial={{ scaleY: 0, opacity: 0 }}
            animate={{ scaleY: 1, opacity: 1 }}
            transition={{ duration: 0.4, delay: 0.1 }}
          />

          {/* LEVEL UP 텍스트 - 메이플스토리 스타일 */}
          <motion.div
            className="relative z-10 text-center"
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{
              type: "spring",
              damping: 10,
              stiffness: 150,
              delay: 0.3,
            }}
          >
            <p
              className="font-pixel text-4xl font-bold text-maple-gold"
              style={{
                textShadow:
                  "2px 2px 0 #5C2A1E, -1px -1px 0 rgba(255,255,255,0.6), 0 0 20px rgba(245,180,72,0.5)",
              }}
            >
              LEVEL UP!
            </p>
            <motion.p
              className="mt-2 font-pixel text-6xl text-white"
              style={{
                textShadow: "3px 3px 0 #874730, 0 0 15px rgba(254,119,2,0.4)",
              }}
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.6 }}
            >
              Lv.{newLevel}
            </motion.p>
          </motion.div>

          {/* 메이플 별 파티클 */}
          {Array.from({ length: 16 }).map((_, i) => (
            <motion.div
              key={i}
              className="absolute font-pixel text-maple-gold"
              style={{
                left: `${10 + Math.random() * 80}%`,
                fontSize: `${8 + Math.random() * 14}px`,
              }}
              initial={{ y: "100vh", opacity: 0, rotate: 0 }}
              animate={{
                y: "-10vh",
                opacity: [0, 1, 1, 0],
                rotate: 360,
              }}
              transition={{
                duration: 2,
                delay: 0.2 + Math.random() * 0.5,
                ease: "easeOut",
              }}
            >
              {["✦", "★", "✧", "⭐", "{ }", "< />", "=>", "0x", "++", "fn()", "[]", "//", "**", "&&", "||", "!="][i]}
            </motion.div>
          ))}
        </motion.div>
      )}
    </AnimatePresence>
  );
}
