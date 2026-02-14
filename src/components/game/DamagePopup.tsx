"use client";

import { motion, AnimatePresence } from "framer-motion";

interface DamagePopupProps {
  damage: number;
  type: "correct" | "partial" | "wrong";
  show: boolean;
}

const typeConfig = {
  correct: {
    color: "text-correct",
    prefix: "CRITICAL! -",
    suffix: "HP",
  },
  partial: {
    color: "text-exp-gold",
    prefix: "-",
    suffix: "HP",
  },
  wrong: {
    color: "text-hp-red",
    prefix: "MISS! +",
    suffix: "HP (반격)",
  },
};

export default function DamagePopup({ damage, type, show }: DamagePopupProps) {
  const config = typeConfig[type];

  return (
    <AnimatePresence>
      {show && (
        <motion.div
          className={`font-pixel text-2xl font-bold ${config.color}`}
          style={{
            textShadow:
              "2px 2px 0 rgba(0,0,0,0.3), -1px -1px 0 rgba(255,255,255,0.3)",
          }}
          initial={{ opacity: 1, y: 0, scale: 0.5 }}
          animate={{ opacity: 1, y: -40, scale: 1.2 }}
          exit={{ opacity: 0, y: -80 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          {config.prefix}
          {damage}
          {config.suffix}
        </motion.div>
      )}
    </AnimatePresence>
  );
}
