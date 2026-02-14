"use client";

import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import Button from "@/components/ui/Button";
import Card from "@/components/ui/Card";
import LevelBadge from "@/components/game/LevelBadge";
import HPBar from "@/components/game/HPBar";
import EXPBar from "@/components/game/EXPBar";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import WeeklyMVP from "@/components/game/WeeklyMVP";
import { useGameState } from "@/hooks/use-game-state";
import { CATEGORIES } from "@/constants/categories";
import { getJobInfo } from "@/lib/utils/job";

export default function WorldPage() {
  const router = useRouter();
  const { profile, isGuest, isLoading } = useGameState();

  if (isLoading) {
    return <LoadingSpinner />;
  }

  if (!profile) {
    router.replace("/");
    return null;
  }

  const { job: currentJob, displayName: jobDisplayName } = getJobInfo(profile.jobClass, profile.jobTier);

  return (
    <div className="flex min-h-dvh flex-col px-4 pb-safe-bottom pt-6">
      {/* T114: 주간 MVP 배너 */}
      <WeeklyMVP />

      {/* 상단: 캐릭터 정보 - 메이플 스타일 상태창 */}
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
      >
        <Card className="mb-4">
          <div className="flex items-center gap-3">
            <div className="flex h-14 w-14 items-center justify-center rounded-lg border-2 border-maple-medium bg-gradient-to-b from-maple-cream to-white text-3xl shadow-[inset_0_2px_4px_rgba(0,0,0,0.1)]">
              {currentJob?.emoji}
            </div>
            <div className="flex-1">
              <div className="flex items-center gap-2">
                <span className="font-pixel text-base text-maple-brown">{profile.nickname}</span>
                <LevelBadge level={profile.level} size="sm" />
              </div>
              <p className="font-pixel text-xs text-text-secondary">
                {jobDisplayName}
              </p>
            </div>
            {isGuest && (
              <button
                onClick={() => {/* TODO: login */}}
                className="rounded-lg bg-mp-blue/15 px-2 py-1 font-pixel text-xs text-mp-blue border border-mp-blue/30"
              >
                로그인
              </button>
            )}
          </div>

          <div className="mt-3 space-y-2">
            <HPBar current={profile.hp} max={profile.maxHp} label="HP" />
            <EXPBar level={profile.level} currentExp={profile.exp} />
          </div>
        </Card>
      </motion.div>

      {/* 중앙: IT 빌리지 - 메이플스토리 마을 느낌 */}
      <div className="flex-1 flex flex-col items-center justify-center">
        <motion.div
          className="text-center w-full"
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.2 }}
        >
          <div className="mb-3 flex items-center justify-center gap-2">
            <div className="h-[2px] w-8 bg-gradient-to-r from-transparent to-maple-gold/60" />
            <p className="font-pixel text-lg text-maple-brown">
              IT 빌리지
            </p>
            <div className="h-[2px] w-8 bg-gradient-to-l from-transparent to-maple-gold/60" />
          </div>
          <div className="grid grid-cols-4 gap-2 mb-6">
            {CATEGORIES.slice(0, 8).map((cat, index) => (
              <motion.div
                key={cat.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 + index * 0.05 }}
                className="flex flex-col items-center gap-1 rounded-lg border border-maple-medium/30 bg-white/70 p-2 shadow-[0_2px_4px_rgba(61,35,20,0.08)] hover:border-maple-gold/50 hover:shadow-[0_2px_8px_rgba(245,180,72,0.2)] transition-all cursor-pointer"
              >
                <span className="text-xl">{cat.emoji}</span>
                <span className="font-pixel text-[10px] text-maple-brown">
                  {cat.name}
                </span>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* 하단: 액션 버튼 - 메이플 스타일 */}
      <motion.div
        className="space-y-2 pb-4"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <Button
          size="lg"
          className="w-full text-lg"
          onClick={() => router.push("/battle")}
        >
          전투 시작!
        </Button>
        <div className="grid grid-cols-4 gap-2">
          <Button
            variant="secondary"
            size="sm"
            onClick={() => router.push("/history")}
          >
            기록
          </Button>
          <Button
            variant="secondary"
            size="sm"
            onClick={() => router.push("/shop")}
          >
            상점
          </Button>
          <Button
            variant="secondary"
            size="sm"
            onClick={() => router.push("/ranking")}
          >
            랭킹
          </Button>
          <Button
            variant="secondary"
            size="sm"
            onClick={() => router.push("/profile")}
          >
            프로필
          </Button>
        </div>
      </motion.div>
    </div>
  );
}
