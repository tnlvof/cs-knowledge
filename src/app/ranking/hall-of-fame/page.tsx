"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import Card from "@/components/ui/Card";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import LevelBadge from "@/components/game/LevelBadge";

interface WinnerProfile {
  userId: string;
  nickname: string;
  level: number;
  exp: number;
  jobClass: string;
  jobTier: number;
  avatarType: string;
  supporterTier: string;
}

interface Winner {
  rank: number;
  finalLevel: number;
  finalExp: number;
  titleAwarded: string;
  profile: WinnerProfile;
}

interface SeasonData {
  season: {
    id: string;
    seasonNumber: number;
    startsAt: string;
    endsAt: string;
    status: string;
  };
  winners: Winner[];
}

const RANK_MEDALS = ["👑", "🥈", "🥉"];
const RANK_COLORS = [
  "from-amber-400 to-yellow-500",
  "from-gray-300 to-gray-400",
  "from-amber-600 to-orange-700",
];

export default function HallOfFamePage() {
  const router = useRouter();
  const [hallOfFame, setHallOfFame] = useState<SeasonData[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchHallOfFame() {
      try {
        const res = await fetch("/api/ranking/hall-of-fame");
        if (res.ok) {
          const data = await res.json();
          setHallOfFame(data.hallOfFame || []);
        }
      } catch {
        // 에러 무시
      } finally {
        setLoading(false);
      }
    }

    fetchHallOfFame();
  }, []);

  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    return `${date.getFullYear()}.${String(date.getMonth() + 1).padStart(2, "0")}.${String(date.getDate()).padStart(2, "0")}`;
  };

  return (
    <div className="flex min-h-dvh flex-col bg-maple-cream px-4 pb-safe-bottom pt-6">
      {/* 헤더 */}
      <div className="mb-6 flex items-center justify-between">
        <button
          onClick={() => router.back()}
          className="font-pixel text-text-secondary"
          aria-label="뒤로 가기"
        >
          <span aria-hidden="true">&larr;</span> 뒤로
        </button>
        <h1 className="font-pixel text-xl text-text-primary">명예의 전당</h1>
        <div className="w-10" />
      </div>

      {loading ? (
        <LoadingSpinner fullScreen={false} />
      ) : hallOfFame.length === 0 ? (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="flex flex-1 flex-col items-center justify-center"
        >
          <p className="mb-2 text-6xl">🏆</p>
          <p className="font-pixel text-lg text-text-primary">
            아직 기록된 시즌이 없습니다
          </p>
          <p className="font-pixel text-sm text-text-secondary">
            첫 번째 시즌이 종료되면 여기에 기록됩니다
          </p>
        </motion.div>
      ) : (
        <div className="flex-1 space-y-6">
          {hallOfFame.map((seasonData, seasonIdx) => (
            <motion.div
              key={seasonData.season.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: seasonIdx * 0.1 }}
            >
              <Card className="overflow-hidden p-0">
                {/* 시즌 헤더 */}
                <div className="bg-gradient-to-r from-exp-gold to-amber-400 px-4 py-3">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <span className="text-2xl">🏆</span>
                      <span className="font-pixel text-lg text-white">
                        시즌 {seasonData.season.seasonNumber}
                      </span>
                    </div>
                    <span className="font-pixel text-xs text-white/80">
                      {formatDate(seasonData.season.startsAt)} ~{" "}
                      {formatDate(seasonData.season.endsAt)}
                    </span>
                  </div>
                </div>

                {/* 수상자 목록 */}
                <div className="divide-y divide-maple-medium/30">
                  {seasonData.winners.map((winner) => (
                    <motion.div
                      key={`${seasonData.season.id}-${winner.rank}`}
                      className="flex items-center gap-3 p-4"
                      whileHover={{ backgroundColor: "rgba(0,0,0,0.02)" }}
                    >
                      {/* 메달 */}
                      <div
                        className={`flex h-12 w-12 items-center justify-center rounded-full bg-gradient-to-br ${RANK_COLORS[winner.rank - 1]} shadow-lg`}
                      >
                        <span className="text-2xl">
                          {RANK_MEDALS[winner.rank - 1]}
                        </span>
                      </div>

                      {/* 유저 정보 */}
                      <div className="flex-1">
                        <div className="flex items-center gap-2">
                          <span className="font-pixel text-base text-text-primary">
                            {winner.profile.nickname}
                          </span>
                          <span className="rounded-full bg-exp-gold/20 px-2 py-0.5 font-pixel text-[10px] text-exp-gold">
                            {winner.titleAwarded}
                          </span>
                        </div>
                        <div className="flex items-center gap-2">
                          <LevelBadge level={winner.finalLevel} size="sm" />
                          <span className="font-pixel text-xs text-text-secondary">
                            최종 EXP {winner.finalExp.toLocaleString()}
                          </span>
                        </div>
                      </div>

                      {/* 순위 */}
                      <div className="text-right">
                        <p className="font-pixel text-2xl text-text-primary">
                          {winner.rank}위
                        </p>
                      </div>
                    </motion.div>
                  ))}
                </div>
              </Card>
            </motion.div>
          ))}
        </div>
      )}
    </div>
  );
}
