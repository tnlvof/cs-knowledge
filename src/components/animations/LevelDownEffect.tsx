"use client";

import { useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";

interface LevelDownEffectProps {
  show: boolean;
  oldLevel: number;
  newLevel: number;
  onComplete?: () => void;
}

export default function LevelDownEffect({
  show,
  oldLevel,
  newLevel,
  onComplete,
}: LevelDownEffectProps) {
  // T124: 모바일 진동 피드백
  useEffect(() => {
    if (show && typeof navigator !== "undefined" && navigator.vibrate) {
      navigator.vibrate([100, 50, 100, 50, 200]);
    }
  }, [show]);

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
          {/* 어두운 배경 오버레이 */}
          <motion.div
            className="absolute inset-0 bg-black/60"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
          />

          {/* 내려가는 화살표 효과 */}
          <motion.div
            className="absolute left-1/2 h-full w-16 -translate-x-1/2 bg-gradient-to-b from-transparent via-hp-red/30 to-transparent"
            initial={{ scaleY: 0, opacity: 0, y: -100 }}
            animate={{ scaleY: 1, opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          />

          {/* LEVEL DOWN 텍스트 */}
          <motion.div
            className="relative z-10 text-center"
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{
              type: "spring",
              damping: 15,
              stiffness: 100,
              delay: 0.2,
            }}
          >
            <motion.p
              className="font-pixel text-3xl font-bold text-hp-red"
              style={{
                textShadow:
                  "2px 2px 0 #4a0000, -1px -1px 0 rgba(0,0,0,0.5)",
              }}
              animate={{
                y: [0, 3, 0],
              }}
              transition={{
                duration: 0.5,
                repeat: 2,
              }}
            >
              LEVEL DOWN...
            </motion.p>

            {/* 레벨 변화 표시 */}
            <motion.div
              className="mt-4 flex items-center justify-center gap-3"
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.5 }}
            >
              <span className="font-pixel text-4xl text-text-muted line-through">
                Lv.{oldLevel}
              </span>
              <motion.span
                className="font-pixel text-2xl text-hp-red"
                animate={{ x: [0, -3, 3, 0] }}
                transition={{ duration: 0.3, repeat: 2 }}
              >
                →
              </motion.span>
              <span className="font-pixel text-5xl text-white">
                Lv.{newLevel}
              </span>
            </motion.div>
          </motion.div>

          {/* 떨어지는 파티클 (깨진 코드 조각) */}
          {Array.from({ length: 10 }).map((_, i) => (
            <motion.div
              key={i}
              className="absolute font-pixel text-xs text-hp-red/60"
              style={{
                left: `${15 + Math.random() * 70}%`,
                top: "-10%",
              }}
              initial={{ y: 0, opacity: 0, rotate: 0 }}
              animate={{
                y: "120vh",
                opacity: [0, 1, 1, 0],
                rotate: Math.random() * 360,
              }}
              transition={{
                duration: 2,
                delay: 0.3 + Math.random() * 0.5,
                ease: "easeIn",
              }}
            >
              {["ERR", "404", "NaN", "null", "??", "fail", "!!!", "X", "-1", "..."][i]}
            </motion.div>
          ))}
        </motion.div>
      )}
    </AnimatePresence>
  );
}
