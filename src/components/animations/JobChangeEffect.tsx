"use client";

import { motion, AnimatePresence } from "framer-motion";
import { JOBS } from "@/constants/jobs";

interface JobChangeEffectProps {
  show: boolean;
  jobId: string;
  onComplete?: () => void;
}

export default function JobChangeEffect({
  show,
  jobId,
  onComplete,
}: JobChangeEffectProps) {
  const job = JOBS.find((j) => j.id === jobId);

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
          <motion.div
            className="absolute inset-0 bg-black/60"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
          />

          {/* 아이콘 회전 */}
          <motion.div
            className="relative z-10 text-8xl"
            initial={{ rotateY: 0, scale: 0 }}
            animate={{
              rotateY: 720,
              scale: [0, 1.5, 1],
            }}
            transition={{ duration: 1.5, ease: "easeInOut" }}
          >
            {job.emoji}
          </motion.div>

          {/* 전직 텍스트 */}
          <motion.div
            className="relative z-10 mt-4 text-center"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1 }}
          >
            <p className="font-pixel text-2xl text-exp-gold">전직!</p>
            <p className="mt-1 font-pixel text-3xl text-white">
              {job.name}
            </p>
            <p className="mt-1 font-pixel text-sm text-text-muted">
              {job.description}
            </p>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
