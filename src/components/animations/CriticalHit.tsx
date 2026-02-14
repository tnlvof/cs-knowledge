"use client";

import { motion, AnimatePresence } from "framer-motion";

interface CriticalHitProps {
  show: boolean;
  onComplete?: () => void;
}

export default function CriticalHit({ show, onComplete }: CriticalHitProps) {
  return (
    <AnimatePresence>
      {show && (
        <motion.div
          className="pointer-events-none fixed inset-0 z-50 flex items-center justify-center"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onAnimationComplete={() => onComplete?.()}
        >
          {/* 화면 플래시 */}
          <motion.div
            className="absolute inset-0 bg-exp-gold/30"
            initial={{ opacity: 1 }}
            animate={{ opacity: 0 }}
            transition={{ duration: 0.3 }}
          />

          {/* CRITICAL 텍스트 */}
          <motion.div
            className="font-pixel text-5xl font-bold text-correct"
            style={{
              textShadow:
                "3px 3px 0 rgba(0,0,0,0.4), -2px -2px 0 rgba(255,255,255,0.5)",
            }}
            initial={{ scale: 3, opacity: 0, rotate: -10 }}
            animate={{ scale: 1, opacity: 1, rotate: 0 }}
            exit={{ scale: 0.5, opacity: 0 }}
            transition={{
              type: "spring",
              damping: 8,
              stiffness: 200,
            }}
          >
            CRITICAL!
          </motion.div>

          {/* 파티클 */}
          {Array.from({ length: 8 }).map((_, i) => (
            <motion.div
              key={i}
              className="absolute h-2 w-2 rounded-full bg-exp-gold"
              initial={{
                x: 0,
                y: 0,
                opacity: 1,
              }}
              animate={{
                x: Math.cos((i * Math.PI * 2) / 8) * 150,
                y: Math.sin((i * Math.PI * 2) / 8) * 150,
                opacity: 0,
              }}
              transition={{ duration: 0.6, ease: "easeOut" }}
            />
          ))}
        </motion.div>
      )}
    </AnimatePresence>
  );
}
