"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import Button from "@/components/ui/Button";
import Card from "@/components/ui/Card";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import { useAuth } from "@/hooks/use-auth";
import { getQuizHistory } from "@/lib/storage/local-storage";
import { CATEGORIES, CATEGORY_MAP } from "@/constants/categories";
import type { QuizHistory, Category } from "@/types/game";

type TabType = "timeline" | "wrong" | "stats";

interface CategoryStat {
  id: string;
  name: string;
  emoji: string;
  color: string;
  totalCount: number;
  correctCount: number;
  avgScore: number;
  accuracy: number;
}

interface StatsData {
  categories: CategoryStat[];
  overall: {
    totalQuestions: number;
    totalCorrect: number;
    avgScore: number;
  };
}

export default function HistoryPage() {
  const router = useRouter();
  const { isAuthenticated, isLoading: authLoading } = useAuth();
  const [activeTab, setActiveTab] = useState<TabType>("timeline");
  const [history, setHistory] = useState<QuizHistory[]>([]);
  const [wrongNotes, setWrongNotes] = useState<any[]>([]);
  const [stats, setStats] = useState<StatsData | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [selectedCategory, setSelectedCategory] = useState<Category | "">("");

  const fetchHistory = useCallback(async () => {
    if (!isAuthenticated) {
      const localHistory = getQuizHistory();
      setHistory(localHistory);
      setIsLoading(false);
      return;
    }

    try {
      const params = new URLSearchParams({
        page: page.toString(),
        limit: "20",
      });
      if (selectedCategory) {
        params.append("category", selectedCategory);
      }

      const response = await fetch(`/api/history?${params}`);
      const data = await response.json();

      if (response.ok) {
        setHistory(
          data.data.map((item: any) => ({
            id: item.id,
            userId: item.user_id,
            questionId: item.question_id,
            userAnswer: item.user_answer,
            aiScore: item.ai_score,
            aiFeedback: item.ai_feedback,
            aiCorrectAnswer: item.ai_correct_answer,
            isCorrect: item.is_correct,
            expEarned: item.exp_earned,
            timeSpentSec: item.time_spent_sec,
            comboCount: item.combo_count,
            monsterId: item.monster_id,
            createdAt: item.created_at,
            question: item.question,
          }))
        );
        setTotalPages(data.pagination.totalPages);
      }
    } catch (error) {
      console.error("Failed to fetch history:", error);
    } finally {
      setIsLoading(false);
    }
  }, [isAuthenticated, page, selectedCategory]);

  const fetchWrongNotes = useCallback(async () => {
    if (!isAuthenticated) {
      const localHistory = getQuizHistory();
      const wrongItems = localHistory.filter(
        (h) => h.isCorrect === "wrong" || h.isCorrect === "partial"
      );
      setWrongNotes(wrongItems);
      return;
    }

    try {
      const params = new URLSearchParams({
        page: page.toString(),
        limit: "20",
      });
      if (selectedCategory) {
        params.append("category", selectedCategory);
      }

      const response = await fetch(`/api/history/wrong-notes?${params}`);
      const data = await response.json();

      if (response.ok) {
        setWrongNotes(data.data);
        setTotalPages(data.pagination.totalPages);
      }
    } catch (error) {
      console.error("Failed to fetch wrong notes:", error);
    }
  }, [isAuthenticated, page, selectedCategory]);

  const fetchStats = useCallback(async () => {
    if (!isAuthenticated) {
      const localHistory = getQuizHistory();
      const categoryStats: Record<string, { total: number; correct: number; score: number }> = {};

      CATEGORIES.forEach((cat) => {
        categoryStats[cat.id] = { total: 0, correct: 0, score: 0 };
      });

      localHistory.forEach((h) => {
        const question = h as any;
        const category = question.question?.category;
        if (category && categoryStats[category]) {
          categoryStats[category].total++;
          categoryStats[category].score += h.aiScore;
          if (h.isCorrect === "correct") {
            categoryStats[category].correct++;
          }
        }
      });

      const formattedStats: StatsData = {
        categories: CATEGORIES.map((cat) => ({
          id: cat.id,
          name: cat.name,
          emoji: cat.emoji,
          color: cat.color,
          totalCount: categoryStats[cat.id].total,
          correctCount: categoryStats[cat.id].correct,
          avgScore:
            categoryStats[cat.id].total > 0
              ? Math.round(categoryStats[cat.id].score / categoryStats[cat.id].total)
              : 0,
          accuracy:
            categoryStats[cat.id].total > 0
              ? Math.round(
                  (categoryStats[cat.id].correct / categoryStats[cat.id].total) * 100
                )
              : 0,
        })),
        overall: {
          totalQuestions: localHistory.length,
          totalCorrect: localHistory.filter((h) => h.isCorrect === "correct").length,
          avgScore:
            localHistory.length > 0
              ? Math.round(
                  localHistory.reduce((sum, h) => sum + h.aiScore, 0) / localHistory.length
                )
              : 0,
        },
      };

      setStats(formattedStats);
      return;
    }

    try {
      const response = await fetch("/api/history/stats");
      const data = await response.json();

      if (response.ok) {
        setStats(data);
      }
    } catch (error) {
      console.error("Failed to fetch stats:", error);
    }
  }, [isAuthenticated]);

  useEffect(() => {
    if (authLoading) return;

    setIsLoading(true);
    if (activeTab === "timeline") {
      fetchHistory();
    } else if (activeTab === "wrong") {
      fetchWrongNotes();
    } else if (activeTab === "stats") {
      fetchStats();
      setIsLoading(false);
    }
  }, [activeTab, authLoading, fetchHistory, fetchWrongNotes, fetchStats]);

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString("ko-KR", {
      month: "short",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const getResultBadge = (isCorrect: string) => {
    switch (isCorrect) {
      case "correct":
        return (
          <span className="rounded-full bg-green-100 px-2 py-0.5 text-xs text-green-700">
            정답
          </span>
        );
      case "partial":
        return (
          <span className="rounded-full bg-yellow-100 px-2 py-0.5 text-xs text-yellow-700">
            부분정답
          </span>
        );
      default:
        return (
          <span className="rounded-full bg-red-100 px-2 py-0.5 text-xs text-red-700">
            오답
          </span>
        );
    }
  };

  if (authLoading) {
    return <LoadingSpinner />;
  }

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
        <h1 className="font-pixel text-lg">학습 기록</h1>
        <div className="w-10" />
      </div>

      {/* Tabs */}
      <div className="mb-4 flex gap-2">
        {[
          { id: "timeline" as TabType, label: "타임라인" },
          { id: "wrong" as TabType, label: "오답노트" },
          { id: "stats" as TabType, label: "통계" },
        ].map((tab) => (
          <button
            key={tab.id}
            onClick={() => {
              setActiveTab(tab.id);
              setPage(1);
            }}
            className={`flex-1 rounded-xl py-2 font-pixel text-sm transition-colors ${
              activeTab === tab.id
                ? "bg-accent-orange text-white"
                : "bg-frame text-text-secondary"
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Category Filter (for timeline and wrong) */}
      {activeTab !== "stats" && (
        <div className="mb-4 flex gap-2 overflow-x-auto pb-2">
          <button
            onClick={() => setSelectedCategory("")}
            className={`shrink-0 rounded-lg px-3 py-1.5 text-xs ${
              selectedCategory === ""
                ? "bg-accent-orange text-white"
                : "bg-frame text-text-secondary"
            }`}
          >
            전체
          </button>
          {CATEGORIES.map((cat) => (
            <button
              key={cat.id}
              onClick={() => setSelectedCategory(cat.id)}
              className={`shrink-0 rounded-lg px-3 py-1.5 text-xs ${
                selectedCategory === cat.id
                  ? "bg-accent-orange text-white"
                  : "bg-frame text-text-secondary"
              }`}
            >
              {cat.emoji} {cat.name}
            </button>
          ))}
        </div>
      )}

      {/* Content */}
      <div className="flex-1 space-y-3">
        {isLoading ? (
          <div className="flex h-40 items-center justify-center">
            <LoadingSpinner />
          </div>
        ) : activeTab === "timeline" ? (
          history.length === 0 ? (
            <Card className="text-center py-8">
              <p className="text-text-secondary">아직 풀이 기록이 없습니다</p>
              <Button
                variant="primary"
                size="sm"
                className="mt-4"
                onClick={() => router.push("/battle")}
              >
                퀴즈 풀러가기
              </Button>
            </Card>
          ) : (
            history.map((item, index) => (
              <motion.div
                key={item.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
              >
                <Card className="space-y-2">
                  <div className="flex items-start justify-between">
                    <div className="flex items-center gap-2">
                      <span className="text-lg">
                        {CATEGORY_MAP[(item as any).question?.category as Category]?.emoji || "📝"}
                      </span>
                      {getResultBadge(item.isCorrect)}
                    </div>
                    <span className="text-xs text-text-muted">
                      {formatDate(item.createdAt)}
                    </span>
                  </div>
                  <p className="text-sm font-medium line-clamp-2">
                    {(item as any).question?.question_text || "문제"}
                  </p>
                  <div className="flex items-center justify-between text-xs text-text-secondary">
                    <span>점수: {item.aiScore}점</span>
                    <span>+{item.expEarned} EXP</span>
                  </div>
                </Card>
              </motion.div>
            ))
          )
        ) : activeTab === "wrong" ? (
          wrongNotes.length === 0 ? (
            <Card className="text-center py-8">
              <p className="text-text-secondary">오답 기록이 없습니다</p>
              <p className="text-xs text-text-muted mt-2">모든 문제를 맞추셨네요!</p>
            </Card>
          ) : (
            wrongNotes.map((item, index) => (
              <motion.div
                key={item.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
              >
                <Card className="space-y-3">
                  <div className="flex items-start justify-between">
                    <div className="flex items-center gap-2">
                      <span className="text-lg">
                        {CATEGORY_MAP[item.question?.category as Category]?.emoji || "📝"}
                      </span>
                      {getResultBadge(item.is_correct)}
                    </div>
                    <span className="text-xs text-text-muted">
                      {item.attempts > 1 && `${item.attempts}회 오답`}
                    </span>
                  </div>
                  <div className="space-y-2">
                    <p className="text-sm font-medium">
                      {item.question?.question_text}
                    </p>
                    <div className="rounded-lg bg-red-50 p-2">
                      <p className="text-xs text-red-600">내 답변</p>
                      <p className="text-sm">{item.user_answer}</p>
                    </div>
                    <div className="rounded-lg bg-green-50 p-2">
                      <p className="text-xs text-green-600">정답</p>
                      <p className="text-sm">{item.question?.correct_answer}</p>
                    </div>
                    <div className="rounded-lg bg-blue-50 p-2">
                      <p className="text-xs text-blue-600">AI 피드백</p>
                      <p className="text-sm">{item.ai_feedback}</p>
                    </div>
                  </div>
                </Card>
              </motion.div>
            ))
          )
        ) : (
          /* Stats Tab */
          stats && (
            <div className="space-y-4">
              {/* Overall Stats */}
              <Card>
                <h3 className="font-pixel text-sm mb-3">전체 현황</h3>
                <div className="grid grid-cols-3 gap-4 text-center">
                  <div>
                    <p className="font-pixel text-2xl tabular-nums text-accent-orange">
                      {stats.overall.totalQuestions}
                    </p>
                    <p className="text-xs text-text-secondary">총 문제</p>
                  </div>
                  <div>
                    <p className="font-pixel text-2xl tabular-nums text-green-600">
                      {stats.overall.totalCorrect}
                    </p>
                    <p className="text-xs text-text-secondary">정답</p>
                  </div>
                  <div>
                    <p className="font-pixel text-2xl tabular-nums text-blue-600">
                      {stats.overall.avgScore}
                    </p>
                    <p className="text-xs text-text-secondary">평균 점수</p>
                  </div>
                </div>
              </Card>

              {/* Category Stats */}
              <Card>
                <h3 className="font-pixel text-sm mb-3">카테고리별 성적</h3>
                <div className="space-y-3">
                  {stats.categories.map((cat) => (
                    <div key={cat.id} className="space-y-1">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <span>{cat.emoji}</span>
                          <span className="text-sm">{cat.name}</span>
                        </div>
                        <span className="text-xs text-text-secondary">
                          {cat.correctCount}/{cat.totalCount} ({cat.accuracy}%)
                        </span>
                      </div>
                      <div className="h-2 w-full overflow-hidden rounded-full bg-gray-200">
                        <motion.div
                          className="h-full rounded-full"
                          style={{ backgroundColor: cat.color }}
                          initial={{ width: 0 }}
                          animate={{ width: `${cat.accuracy}%` }}
                          transition={{ duration: 0.5, delay: 0.1 }}
                        />
                      </div>
                    </div>
                  ))}
                </div>
              </Card>
            </div>
          )
        )}

        {/* Pagination */}
        {activeTab !== "stats" && totalPages > 1 && (
          <div className="flex items-center justify-center gap-2 pt-4">
            <Button
              variant="ghost"
              size="sm"
              disabled={page === 1}
              onClick={() => setPage((p) => Math.max(1, p - 1))}
            >
              이전
            </Button>
            <span className="text-sm text-text-secondary">
              {page} / {totalPages}
            </span>
            <Button
              variant="ghost"
              size="sm"
              disabled={page === totalPages}
              onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
            >
              다음
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
