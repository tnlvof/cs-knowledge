"use client";

import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import { useRouter } from "next/navigation";

interface MVPData {
  nickname: string;
  level: number;
  weeklyExp: number;
  avatarType: string;
  jobClass: string;
}

/**
 * T114: 주간 MVP 배너 컴포넌트
 * "이번 주 최강 모험가" 배너를 표시합니다.
 */
export default function WeeklyMVP() {
  const router = useRouter();
  const [mvp, setMvp] = useState<MVPData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchMVP() {
      try {
        const res = await fetch("/api/ranking/weekly?limit=1");
        if (res.ok) {
          const data = await res.json();
          if (data.rankings && data.rankings.length > 0) {
            const top = data.rankings[0];
            setMvp({
              nickname: top.nickname,
              level: top.level,
              weeklyExp: top.weeklyExp,
              avatarType: top.avatarType,
              jobClass: top.jobClass,
            });
          }
        }
      } catch (error) {
        if (process.env.NODE_ENV === "development") {
          console.warn("Failed to fetch weekly MVP:", error);
        }
      } finally {
        setLoading(false);
      }
    }

    fetchMVP();
  }, []);

  if (loading) {
    return (
      <div className="mb-4 h-16 animate-pulse rounded-xl bg-frame/50" />
    );
  }

  if (!mvp) {
    return null;
  }

  return (
    <motion.button
      onClick={() => router.push("/ranking?tab=weekly")}
      className="relative mb-4 w-full overflow-hidden rounded-xl border-2 border-exp-gold bg-gradient-to-r from-amber-50 via-yellow-50 to-amber-50 p-3 text-left shadow-md"
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{ scale: 1.01 }}
      whileTap={{ scale: 0.99 }}
    >
      <div className="flex items-center gap-3">
        {/* 트로피 아이콘 */}
        <motion.div
          className="flex h-10 w-10 items-center justify-center rounded-full bg-exp-gold/20 text-2xl"
          animate={{
            scale: [1, 1.1, 1],
            rotate: [0, -5, 5, 0],
          }}
          transition={{
            duration: 2,
            repeat: Infinity,
            ease: "easeInOut",
          }}
        >
          🏆
        </motion.div>

        {/* MVP 정보 */}
        <div className="flex-1">
          <p className="font-pixel text-[10px] text-exp-gold">
            이번 주 최강 모험가
          </p>
          <div className="flex items-center gap-2">
            <span className="font-pixel text-sm text-text-primary">
              {mvp.nickname}
            </span>
            <span className="rounded bg-exp-gold/20 px-1.5 py-0.5 font-pixel text-[10px] text-exp-gold">
              Lv.{mvp.level}
            </span>
          </div>
        </div>

        {/* 주간 EXP */}
        <div className="text-right">
          <p className="font-pixel text-xs text-text-secondary">주간 EXP</p>
          <p className="font-pixel text-sm text-exp-gold">
            +{mvp.weeklyExp.toLocaleString()}
          </p>
        </div>

        {/* 스파클 효과 */}
        <motion.div
          className="absolute right-4 top-2 text-xl"
          animate={{
            opacity: [0, 1, 0],
            scale: [0.5, 1, 0.5],
          }}
          transition={{
            duration: 1.5,
            repeat: Infinity,
            delay: 0.5,
          }}
        >
          ✨
        </motion.div>
      </div>
    </motion.button>
  );
}
