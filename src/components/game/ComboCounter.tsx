"use client";

import { motion, AnimatePresence } from "framer-motion";

interface ComboCounterProps {
  count: number;
}

export default function ComboCounter({ count }: ComboCounterProps) {
  if (count < 2) return null;

  const color =
    count >= 10
      ? "text-hp-red"
      : count >= 5
        ? "text-accent-orange"
        : "text-exp-gold";

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={count}
        className={`font-pixel text-lg ${color}`}
        initial={{ scale: 1.5, opacity: 0, y: -10 }}
        animate={{ scale: 1, opacity: 1, y: 0 }}
        exit={{ scale: 0.8, opacity: 0 }}
        transition={{ type: "spring", damping: 10, stiffness: 200 }}
      >
        {count} COMBO!
      </motion.div>
    </AnimatePresence>
  );
}
