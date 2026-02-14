"use client";

import { useState, useEffect, use } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { motion } from "framer-motion";
import Card from "@/components/ui/Card";
import Button from "@/components/ui/Button";
import LevelBadge from "@/components/game/LevelBadge";
import SalaryDisplay from "@/components/game/SalaryDisplay";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import { getJobInfo } from "@/lib/utils/job";
import { SUPPORTER_BADGES } from "@/constants/supporters";
import { CATEGORIES } from "@/constants/categories";

interface CategoryStat {
  id: string;
  name: string;
  emoji: string;
  color: string;
  totalCount: number;
  correctCount: number;
  avgScore: number;
}

interface PublicProfile {
  nickname: string;
  level: number;
  jobClass: string;
  jobTier: number;
  topCategory: string | null;
  avatarType: string;
  supporterTier: string;
  totalCorrect: number;
  totalQuestions: number;
  accuracy: number;
  estimatedSalary: number;
  joinedAt: string;
}

interface EquippedItems {
  [category: string]: {
    name: string;
    imageUrl: string | null;
    rarity: string;
  };
}

export default function PublicProfilePage({
  params,
}: {
  params: Promise<{ nickname: string }>;
}) {
  const { nickname } = use(params);
  const router = useRouter();
  const [profile, setProfile] = useState<PublicProfile | null>(null);
  const [categoryStats, setCategoryStats] = useState<CategoryStat[]>([]);
  const [equippedItems, setEquippedItems] = useState<EquippedItems>({});
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [toast, setToast] = useState<string | null>(null);

  const showToast = (message: string) => {
    setToast(message);
    setTimeout(() => setToast(null), 3000);
  };

  useEffect(() => {
    async function fetchProfile() {
      try {
        const response = await fetch(
          `/api/profile/${encodeURIComponent(nickname)}`
        );

        if (!response.ok) {
          const data = await response.json();
          setError(data.error || "프로필을 찾을 수 없습니다");
          return;
        }

        const data = await response.json();
        setProfile(data.profile);
        setCategoryStats(data.categoryStats);
        setEquippedItems(data.equippedItems);
      } catch (err) {
        console.error("Failed to fetch profile:", err);
        setError("프로필을 불러오는데 실패했습니다");
      } finally {
        setIsLoading(false);
      }
    }

    if (nickname) {
      fetchProfile();
    }
  }, [nickname]);

  const shareProfile = () => {
    const url = window.location.href;
    if (navigator.share) {
      navigator.share({
        title: `${nickname}의 MeAIple Story 프로필`,
        url,
      });
    } else {
      navigator.clipboard.writeText(url);
      showToast("프로필 링크가 복사되었습니다!");
    }
  };

  if (isLoading) {
    return <LoadingSpinner />;
  }

  if (error || !profile) {
    return (
      <div className="flex min-h-dvh flex-col items-center justify-center gap-4 px-4">
        <p className="font-pixel text-lg text-text-secondary">
          {error || "프로필을 찾을 수 없습니다"}
        </p>
        <Button variant="secondary" onClick={() => router.back()}>
          돌아가기
        </Button>
      </div>
    );
  }

  const { job: currentJob, displayName: jobDisplayName } = getJobInfo(profile.jobClass, profile.jobTier);

  const joinDate = new Date(profile.joinedAt).toLocaleDateString("ko-KR", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  return (
    <div className="flex min-h-dvh flex-col px-4 pb-safe-bottom pt-6">
      {/* Header */}
      <div className="mb-4 flex items-center justify-between">
        <button
          onClick={() => router.back()}
          className="flex h-10 w-10 items-center justify-center rounded-full hover:bg-maple-cream/50"
          aria-label="뒤로 가기"
        >
          <span className="text-xl" aria-hidden="true">&larr;</span>
        </button>
        <h1 className="font-pixel text-lg">프로필</h1>
        <button
          onClick={shareProfile}
          className="flex h-10 w-10 items-center justify-center rounded-full hover:bg-maple-cream/50"
          aria-label="프로필 공유"
        >
          <span className="text-xl" aria-hidden="true">📤</span>
        </button>
      </div>

      {/* Profile Card */}
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
      >
        <Card className="mb-4">
          <div className="flex items-center gap-4">
            <div className="relative">
              <div className="flex h-20 w-20 items-center justify-center rounded-2xl border-2 border-maple-medium bg-gradient-to-b from-maple-cream to-white text-4xl">
                {currentJob.emoji}
              </div>
              {profile.supporterTier !== "none" && (
                <span className="absolute -right-1 -top-1 text-xl">
                  {SUPPORTER_BADGES[profile.supporterTier]?.emoji}
                </span>
              )}
            </div>
            <div className="flex-1">
              <div className="flex items-center gap-2">
                <span className="font-pixel text-lg">{profile.nickname}</span>
                <LevelBadge level={profile.level} size="sm" />
              </div>
              <p className="text-sm text-text-secondary">{jobDisplayName}</p>
              {profile.supporterTier !== "none" && (
                <p className={`text-xs ${SUPPORTER_BADGES[profile.supporterTier]?.color}`}>
                  {SUPPORTER_BADGES[profile.supporterTier]?.name} 후원자
                </p>
              )}
            </div>
          </div>
          <p className="mt-3 text-xs text-text-muted">가입일: {joinDate}</p>
        </Card>
      </motion.div>

      {/* Stats Overview */}
      <Card className="mb-4">
        <h3 className="font-pixel text-sm mb-3">통계</h3>
        <div className="grid grid-cols-3 gap-4 text-center">
          <div>
            <p className="font-pixel text-2xl tabular-nums text-accent-orange">
              {profile.totalQuestions}
            </p>
            <p className="text-xs text-text-secondary">총 문제</p>
          </div>
          <div>
            <p className="font-pixel text-2xl tabular-nums text-green-600">
              {profile.totalCorrect}
            </p>
            <p className="text-xs text-text-secondary">정답</p>
          </div>
          <div>
            <p className="font-pixel text-2xl tabular-nums text-blue-600">
              {profile.accuracy}%
            </p>
            <p className="text-xs text-text-secondary">정답률</p>
          </div>
        </div>
      </Card>

      {/* Top Category */}
      {profile.topCategory && (
        <Card className="mb-4 bg-gradient-to-r from-green-50 to-emerald-50">
          <div className="flex items-center gap-3">
            <span className="text-3xl">
              {CATEGORIES.find((c) => c.id === profile.topCategory)?.emoji || "📝"}
            </span>
            <div>
              <p className="font-pixel text-sm">주력 분야</p>
              <p className="text-lg font-medium">
                {CATEGORIES.find((c) => c.id === profile.topCategory)?.name || profile.topCategory}
              </p>
            </div>
          </div>
        </Card>
      )}

      {/* Category Stats (Radar Chart representation with bars) */}
      <Card className="mb-4">
        <h3 className="font-pixel text-sm mb-3">분야별 성적</h3>
        <div className="space-y-2">
          {categoryStats.map((cat, index) => {
            const accuracy =
              cat.totalCount > 0
                ? Math.round((cat.correctCount / cat.totalCount) * 100)
                : 0;
            return (
              <div key={cat.id} className="space-y-1">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <span>{cat.emoji}</span>
                    <span className="text-sm">{cat.name}</span>
                  </div>
                  <span className="text-xs text-text-secondary">
                    {cat.correctCount}/{cat.totalCount} ({accuracy}%)
                  </span>
                </div>
                <div className="h-2 w-full overflow-hidden rounded-full bg-gray-200">
                  <motion.div
                    className="h-full rounded-full"
                    style={{ backgroundColor: cat.color }}
                    initial={{ width: 0 }}
                    animate={{ width: `${accuracy}%` }}
                    transition={{ duration: 0.5, delay: index * 0.05 }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </Card>

      {/* Estimated Salary */}
      <SalaryDisplay salary={profile.estimatedSalary} className="mb-4" />

      {/* Equipped Items */}
      {Object.keys(equippedItems).length > 0 && (
        <Card className="mb-4">
          <h3 className="font-pixel text-sm mb-3">장착 아이템</h3>
          <div className="flex gap-2 flex-wrap">
            {Object.entries(equippedItems).map(([category, item]) => (
              <div
                key={category}
                className="flex items-center gap-2 rounded-lg bg-maple-cream/50 px-3 py-2 border border-maple-medium/20"
              >
                <span className="text-lg">{item.imageUrl || "📦"}</span>
                <span className="text-xs">{item.name}</span>
              </div>
            ))}
          </div>
        </Card>
      )}

      {/* CTA */}
      <div className="mt-auto pb-4">
        <Link
          href="/"
          className="flex h-12 w-full items-center justify-center rounded-xl bg-accent-orange font-pixel text-base text-white transition-colors hover:bg-accent-orange/90"
        >
          나도 시작하기
        </Link>
      </div>

      {toast && (
        <div className="fixed bottom-20 left-4 right-4 z-50 animate-bounce-in">
          <div className="rounded-xl bg-gray-800 px-4 py-3 text-center text-sm text-white shadow-lg">
            {toast}
            <button onClick={() => setToast(null)} className="ml-2 text-gray-400" aria-label="닫기">✕</button>
          </div>
        </div>
      )}
    </div>
  );
}
