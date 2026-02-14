"use client";

import { motion, AnimatePresence } from "framer-motion";
import { JOBS } from "@/constants/jobs";
import { TIER_NAMES } from "@/constants/levels";

interface JobDemoteEffectProps {
  show: boolean;
  jobId: string;
  oldTier: number;
  newTier: number;
  onComplete?: () => void;
}

export default function JobDemoteEffect({
  show,
  jobId,
  oldTier,
  newTier,
  onComplete,
}: JobDemoteEffectProps) {
  const job = JOBS.find((j) => j.id === jobId);
  const tierKeys = ["trainee", "apprentice", "regular", "veteran", "master", "legend"];
  const oldTierName = TIER_NAMES[tierKeys[oldTier]] || "???";
  const newTierName = newTier > 0 ? TIER_NAMES[tierKeys[newTier - 1]] : "수습 이전";

  return (
    <AnimatePresence>
      {show && job && (
        <motion.div
          className="pointer-events-none fixed inset-0 z-50 flex flex-col items-center justify-center"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onAnimationComplete={() => {
            setTimeout(() => onComplete?.(), 2000);
          }}
        >
          {/* 어두운 배경 */}
          <motion.div
            className="absolute inset-0 bg-black/70"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
          />

          {/* 아이콘 (흐릿해지며 축소) */}
          <motion.div
            className="relative z-10 text-7xl grayscale"
            initial={{ scale: 1, opacity: 1 }}
            animate={{
              scale: [1, 0.8, 0.6],
              opacity: [1, 0.7, 0.5],
            }}
            transition={{ duration: 1.2, ease: "easeOut" }}
          >
            {job.emoji}
          </motion.div>

          {/* 전직 해제 텍스트 */}
          <motion.div
            className="relative z-10 mt-4 text-center"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5 }}
          >
            <motion.p
              className="font-pixel text-2xl text-hp-red"
              animate={{ opacity: [1, 0.6, 1] }}
              transition={{ duration: 0.8, repeat: 2 }}
            >
              전직 해제...
            </motion.p>

            {/* 직업 티어 변화 */}
            <motion.div
              className="mt-3 flex flex-col items-center gap-1"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.8 }}
            >
              <p className="font-pixel text-lg text-text-muted line-through">
                {oldTierName} {job.name}
              </p>
              <motion.span
                className="font-pixel text-xl text-hp-red"
                animate={{ y: [0, 5, 0] }}
                transition={{ duration: 0.4, repeat: 2 }}
              >
                ↓
              </motion.span>
              <p className="font-pixel text-xl text-white">
                {newTier > 0 ? `${newTierName} ${job.name}` : "초보자"}
              </p>
            </motion.div>
          </motion.div>

          {/* 깨지는 효과 파티클 */}
          {Array.from({ length: 8 }).map((_, i) => (
            <motion.div
              key={i}
              className="absolute h-3 w-3 bg-hp-red/40"
              style={{
                left: "50%",
                top: "40%",
              }}
              initial={{ x: 0, y: 0, opacity: 1, scale: 1 }}
              animate={{
                x: (Math.random() - 0.5) * 200,
                y: (Math.random() - 0.5) * 200,
                opacity: 0,
                scale: 0,
                rotate: Math.random() * 360,
              }}
              transition={{
                duration: 1,
                delay: 0.3 + i * 0.05,
                ease: "easeOut",
              }}
            />
          ))}
        </motion.div>
      )}
    </AnimatePresence>
  );
}
