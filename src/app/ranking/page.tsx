"use client";

import { useEffect, useState, useCallback, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import Card from "@/components/ui/Card";
import Button from "@/components/ui/Button";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import LevelBadge from "@/components/game/LevelBadge";
import { CATEGORIES } from "@/constants/categories";
import type { Category } from "@/types/game";

type TabType = "overall" | "weekly" | "category" | "combo";

interface RankingEntry {
  rank: number;
  userId: string;
  nickname: string;
  level: number;
  exp: number;
  jobClass: string;
  jobTier: number;
  avatarType: string;
  supporterTier: string;
  weeklyExp?: number;
  bestCombo?: number;
  categoryCorrect?: number;
  categoryAccuracy?: number;
  isMe?: boolean;
}

interface MyRankInfo {
  myRank: number;
  expToNext: number | string | null;
}

const TABS: { key: TabType; label: string }[] = [
  { key: "overall", label: "종합" },
  { key: "weekly", label: "주간" },
  { key: "category", label: "분야별" },
  { key: "combo", label: "콤보" },
];

const RANK_MEDALS = ["👑", "🥈", "🥉"];

function RankingPageContent() {
  const router = useRouter();
  const searchParams = useSearchParams();

  const initialTab = (searchParams.get("tab") as TabType) || "overall";
  const initialCategory = (searchParams.get("category") as Category) || "network";

  const [activeTab, setActiveTab] = useState<TabType>(initialTab);
  const [selectedCategory, setSelectedCategory] = useState<Category>(initialCategory);
  const [rankings, setRankings] = useState<RankingEntry[]>([]);
  const [myRankInfo, setMyRankInfo] = useState<MyRankInfo | null>(null);
  const [loading, setLoading] = useState(true);
  const [currentUserId, setCurrentUserId] = useState<string | null>(null);

  // 내 랭킹 정보 조회
  const fetchMyRank = useCallback(async () => {
    try {
      const res = await fetch("/api/ranking/me");
      if (res.ok) {
        const data = await res.json();
        setMyRankInfo({
          myRank: data.myRank,
          expToNext: data.expToNext,
        });
        setCurrentUserId(data.myProfile?.userId || null);
      }
    } catch {
      // 비로그인 상태
    }
  }, []);

  // 랭킹 데이터 조회
  const fetchRankings = useCallback(async () => {
    setLoading(true);
    try {
      let url = "";
      switch (activeTab) {
        case "overall":
          url = "/api/ranking/overall";
          break;
        case "weekly":
          url = "/api/ranking/weekly";
          break;
        case "category":
          url = `/api/ranking/category/${selectedCategory}`;
          break;
        case "combo":
          url = "/api/ranking/combo";
          break;
      }

      const res = await fetch(url);
      if (res.ok) {
        const data = await res.json();
        setRankings(data.rankings || []);
      }
    } catch {
      setRankings([]);
    } finally {
      setLoading(false);
    }
  }, [activeTab, selectedCategory]);

  useEffect(() => {
    fetchMyRank();
  }, [fetchMyRank]);

  useEffect(() => {
    fetchRankings();
  }, [fetchRankings]);

  // URL 쿼리 업데이트
  useEffect(() => {
    const params = new URLSearchParams();
    params.set("tab", activeTab);
    if (activeTab === "category") {
      params.set("category", selectedCategory);
    }
    router.replace(`/ranking?${params.toString()}`, { scroll: false });
  }, [activeTab, selectedCategory, router]);

  const renderStatValue = (entry: RankingEntry) => {
    switch (activeTab) {
      case "overall":
        return (
          <span className="font-pixel text-xs text-text-secondary">
            EXP {entry.exp.toLocaleString()}
          </span>
        );
      case "weekly":
        return (
          <span className="font-pixel text-xs text-exp-gold">
            +{(entry.weeklyExp || 0).toLocaleString()}
          </span>
        );
      case "category":
        return (
          <span className="font-pixel text-xs text-text-secondary">
            {entry.categoryCorrect}문제 ({entry.categoryAccuracy}%)
          </span>
        );
      case "combo":
        return (
          <span className="font-pixel text-xs text-accent-orange">
            {entry.bestCombo}콤보
          </span>
        );
    }
  };

  return (
    <div className="flex min-h-dvh flex-col bg-maple-cream px-4 pb-safe-bottom pt-6">
      {/* 헤더 */}
      <div className="mb-4 flex items-center justify-between">
        <button
          onClick={() => router.back()}
          className="font-pixel text-text-secondary"
          aria-label="뒤로 가기"
        >
          <span aria-hidden="true">&larr;</span> 뒤로
        </button>
        <h1 className="font-pixel text-xl text-text-primary">랭킹</h1>
        <div className="w-10" />
      </div>

      {/* 내 순위 표시 */}
      {myRankInfo && activeTab === "overall" && (
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-4"
        >
          <Card className="bg-accent-orange/10 border-accent-orange">
            <div className="flex items-center justify-between">
              <div>
                <p className="font-pixel text-xs text-text-secondary">내 순위</p>
                <p className="font-pixel text-2xl text-accent-orange">
                  {myRankInfo.myRank}위
                </p>
              </div>
              {myRankInfo.expToNext && (
                <div className="text-right">
                  <p className="font-pixel text-xs text-text-secondary">다음 순위까지</p>
                  <p className="font-pixel text-sm text-text-primary">
                    {typeof myRankInfo.expToNext === "number"
                      ? `${myRankInfo.expToNext} EXP`
                      : myRankInfo.expToNext}
                  </p>
                </div>
              )}
            </div>
          </Card>
        </motion.div>
      )}

      {/* 탭 네비게이션 */}
      <div className="mb-4 flex gap-1 rounded-xl bg-frame p-1">
        {TABS.map((tab) => (
          <button
            key={tab.key}
            onClick={() => setActiveTab(tab.key)}
            className={`flex-1 rounded-lg px-2 py-2 font-pixel text-xs transition-colors ${
              activeTab === tab.key
                ? "bg-accent-orange text-white"
                : "text-text-secondary hover:bg-maple-cream"
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* 분야별 탭일 때 카테고리 선택 */}
      {activeTab === "category" && (
        <div className="mb-4 flex gap-1 overflow-x-auto pb-2">
          {CATEGORIES.map((cat) => (
            <button
              key={cat.id}
              onClick={() => setSelectedCategory(cat.id)}
              className={`flex shrink-0 items-center gap-1 rounded-full border-2 px-3 py-2 min-h-[44px] font-pixel text-xs transition-colors ${
                selectedCategory === cat.id
                  ? "border-accent-orange bg-accent-orange/10 text-accent-orange"
                  : "border-maple-medium bg-frame text-text-secondary"
              }`}
            >
              <span>{cat.emoji}</span>
              <span>{cat.name}</span>
            </button>
          ))}
        </div>
      )}

      {/* 랭킹 리스트 */}
      <div className="flex-1">
        {loading ? (
          <LoadingSpinner fullScreen={false} />
        ) : rankings.length === 0 ? (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="flex h-40 flex-col items-center justify-center"
          >
            <p className="mb-2 text-4xl">🏰</p>
            <p className="font-pixel text-sm text-text-secondary">
              아직 모험가가 없습니다
            </p>
            <Button
              variant="secondary"
              size="sm"
              className="mt-3"
              onClick={() => router.push("/battle")}
            >
              첫 도전하기
            </Button>
          </motion.div>
        ) : (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="space-y-2"
          >
            <AnimatePresence>
              {rankings.map((entry, idx) => {
                const isMe = entry.userId === currentUserId;
                return (
                  <motion.div
                    key={entry.userId}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: 20 }}
                    transition={{ delay: idx * 0.03 }}
                    className={`flex items-center gap-3 rounded-xl border-2 p-3 ${
                      isMe
                        ? "border-accent-orange bg-accent-orange/10"
                        : "border-maple-medium bg-frame"
                    }`}
                  >
                    {/* 순위 */}
                    <div className="flex w-8 justify-center">
                      {entry.rank <= 3 ? (
                        <span className="text-xl">{RANK_MEDALS[entry.rank - 1]}</span>
                      ) : (
                        <span className="font-pixel text-sm text-text-secondary">
                          {entry.rank}
                        </span>
                      )}
                    </div>

                    {/* 아바타 */}
                    <div className="flex h-10 w-10 items-center justify-center rounded-lg border-2 border-maple-medium bg-maple-cream text-xl">
                      {entry.avatarType === "male" ? "🧑" : "👩"}
                    </div>

                    {/* 유저 정보 */}
                    <div className="flex-1">
                      <div className="flex items-center gap-2">
                        <span className="font-pixel text-sm text-text-primary">
                          {entry.nickname}
                        </span>
                        {isMe && (
                          <span className="rounded bg-accent-orange px-1.5 py-0.5 font-pixel text-[10px] text-white">
                            나
                          </span>
                        )}
                      </div>
                      <div className="flex items-center gap-2">
                        <LevelBadge level={entry.level} size="sm" />
                        {renderStatValue(entry)}
                      </div>
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </motion.div>
        )}
      </div>

      {/* 명예의 전당 버튼 */}
      <motion.div
        className="pt-4"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3 }}
      >
        <Button
          variant="secondary"
          size="sm"
          className="w-full"
          onClick={() => router.push("/ranking/hall-of-fame")}
        >
          명예의 전당 보기
        </Button>
      </motion.div>
    </div>
  );
}

export default function RankingPage() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <RankingPageContent />
    </Suspense>
  );
}
