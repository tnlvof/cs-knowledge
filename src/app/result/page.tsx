"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { motion } from "framer-motion";
import Button from "@/components/ui/Button";
import Card from "@/components/ui/Card";
import LevelBadge from "@/components/game/LevelBadge";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import LevelUpEffect from "@/components/animations/LevelUpEffect";
import LevelDownEffect from "@/components/animations/LevelDownEffect";
import JobChangeEffect from "@/components/animations/JobChangeEffect";
import JobDemoteEffect from "@/components/animations/JobDemoteEffect";
import { TopPercentBadge } from "@/components/game/AccuracyBadge";
import { useGameState } from "@/hooks/use-game-state";
import { useAuth } from "@/hooks/use-auth";
import { getJobInfo } from "@/lib/utils/job";
import { getQuizHistory, getBattleSession } from "@/lib/storage/local-storage";
import type { QuizHistory } from "@/types/game";

function ResultContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { profile } = useGameState();
  const { isAuthenticated } = useAuth();
  const [toast, setToast] = useState<string | null>(null);
  const [showLevelUp, setShowLevelUp] = useState(false);
  const [showLevelDown, setShowLevelDown] = useState(false);
  const [showJobChange, setShowJobChange] = useState(false);
  const [showJobDemote, setShowJobDemote] = useState(false);
  const [battleResult, setBattleResult] = useState<{
    status: "victory" | "defeat";
    questionsAnswered: number;
    correctCount: number;
    totalExp: number;
    levelUp: boolean;
    levelDown: boolean;
    newLevel: number;
    oldLevel: number;
    jobChange: string | null;
    jobDemote: boolean;
    newJobTier: number;
    oldJobTier: number;
    history: QuizHistory[];
    // T103: 마지막 문제의 정답률 (상위 N% 표시용)
    lastQuestionAccuracy: number | null;
    lastQuestionCorrect: boolean;
  } | null>(null);

  useEffect(() => {
    // Get result from URL params or localStorage
    const status = searchParams.get("status") as "victory" | "defeat" | null;
    const session = getBattleSession();
    const history = getQuizHistory();

    if (status || session) {
      // Get recent history (from this battle session)
      const sessionHistory = session
        ? history.filter(
            (h) =>
              h.monsterId === session.monsterId &&
              new Date(h.createdAt) >= new Date(session.createdAt)
          )
        : history.slice(0, 5);

      const correctCount = sessionHistory.filter(
        (h) => h.isCorrect === "correct"
      ).length;
      const totalExp = sessionHistory.reduce((sum, h) => sum + h.expEarned, 0);

      const levelUp = searchParams.get("levelUp") === "true";
      const levelDown = searchParams.get("levelDown") === "true";
      const jobDemote = searchParams.get("jobDemote") === "true";
      const jobChange = searchParams.get("jobChange");

      // T103: 마지막 문제 정답률 파라미터
      const lastAccuracyParam = searchParams.get("lastAccuracy");
      const lastQuestionAccuracy = lastAccuracyParam ? parseFloat(lastAccuracyParam) : null;
      const lastQuestionCorrect = sessionHistory.length > 0
        ? sessionHistory[sessionHistory.length - 1]?.isCorrect === "correct"
        : false;

      setBattleResult({
        status: status || (session?.status as "victory" | "defeat") || "victory",
        questionsAnswered: session?.questionsAnswered || sessionHistory.length,
        correctCount,
        totalExp,
        levelUp,
        levelDown,
        newLevel: parseInt(searchParams.get("newLevel") || "1", 10),
        oldLevel: parseInt(searchParams.get("oldLevel") || "1", 10),
        jobChange,
        jobDemote,
        newJobTier: parseInt(searchParams.get("newJobTier") || "0", 10),
        oldJobTier: parseInt(searchParams.get("oldJobTier") || "0", 10),
        history: sessionHistory,
        lastQuestionAccuracy,
        lastQuestionCorrect,
      });

      // 애니메이션 표시 순서: 레벨 변화 -> 직업 변화
      if (levelUp) {
        setShowLevelUp(true);
      } else if (levelDown) {
        setShowLevelDown(true);
      } else if (jobChange) {
        setShowJobChange(true);
      } else if (jobDemote) {
        setShowJobDemote(true);
      }
    }
  }, [searchParams]);

  const handleLevelUpComplete = () => {
    setShowLevelUp(false);
    if (battleResult?.jobChange) {
      setShowJobChange(true);
    }
  };

  const handleLevelDownComplete = () => {
    setShowLevelDown(false);
    if (battleResult?.jobDemote) {
      setShowJobDemote(true);
    }
  };

  const handleJobChangeComplete = () => {
    setShowJobChange(false);
  };

  const handleJobDemoteComplete = () => {
    setShowJobDemote(false);
  };

  if (!profile) {
    return (
      <div className="flex min-h-dvh items-center justify-center">
        <p className="text-text-secondary">캐릭터 정보를 불러올 수 없습니다</p>
      </div>
    );
  }

  if (!battleResult) {
    return <LoadingSpinner />;
  }

  const { job: currentJob, displayName: jobDisplayName } = getJobInfo(profile.jobClass, profile.jobTier);

  const accuracy =
    battleResult.questionsAnswered > 0
      ? Math.round(
          (battleResult.correctCount / battleResult.questionsAnswered) * 100
        )
      : 0;

  const showToast = (message: string) => {
    setToast(message);
    setTimeout(() => setToast(null), 3000);
  };

  const shareResult = () => {
    const text = `MeAIple Story에서 ${battleResult.status === "victory" ? "승리" : "패배"}!\n정답률: ${accuracy}%\nEXP 획득: ${battleResult.totalExp}`;
    const url = `${window.location.origin}/profile/${profile.nickname}`;

    if (navigator.share) {
      navigator.share({
        title: "MeAIple Story 전투 결과",
        text,
        url,
      });
    } else {
      navigator.clipboard.writeText(`${text}\n${url}`);
      showToast("결과가 복사되었습니다!");
    }
  };

  return (
    <div className="flex min-h-dvh flex-col px-4 pb-safe-bottom pt-6">
      {/* 애니메이션 효과들 */}
      <LevelUpEffect
        show={showLevelUp}
        newLevel={battleResult.newLevel}
        onComplete={handleLevelUpComplete}
      />
      <LevelDownEffect
        show={showLevelDown}
        oldLevel={battleResult.oldLevel}
        newLevel={battleResult.newLevel}
        onComplete={handleLevelDownComplete}
      />
      <JobChangeEffect
        show={showJobChange}
        jobId={battleResult.jobChange || profile.jobClass}
        onComplete={handleJobChangeComplete}
      />
      <JobDemoteEffect
        show={showJobDemote}
        jobId={profile.jobClass}
        oldTier={battleResult.oldJobTier}
        newTier={battleResult.newJobTier}
        onComplete={handleJobDemoteComplete}
      />

      {/* Result Header */}
      <motion.div
        className="mb-6 text-center"
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.5 }}
      >
        <div className="mb-4 text-6xl">
          {battleResult.status === "victory" ? "🎉" : "💀"}
        </div>
        <h1
          className={`font-pixel text-3xl ${
            battleResult.status === "victory"
              ? "text-exp-gold"
              : "text-hp-red"
          }`}
        >
          {battleResult.status === "victory" ? "승리!" : "패배..."}
        </h1>
      </motion.div>

      {/* Level Up / Level Down / Job Change / Job Demote Alert */}
      {(battleResult.levelUp || battleResult.levelDown || battleResult.jobChange || battleResult.jobDemote) && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <Card className={`mb-4 text-center ${
            battleResult.levelDown || battleResult.jobDemote
              ? "bg-gradient-to-r from-red-100 to-rose-100"
              : "bg-gradient-to-r from-amber-100 to-orange-100"
          }`}>
            {battleResult.levelUp && (
              <div className="mb-2">
                <span className="text-2xl">🆙</span>
                <p className="font-pixel text-lg text-amber-700">
                  레벨 업! Lv.{battleResult.newLevel}
                </p>
              </div>
            )}
            {battleResult.levelDown && (
              <div className="mb-2">
                <span className="text-2xl">📉</span>
                <p className="font-pixel text-lg text-red-700">
                  레벨 다운... Lv.{battleResult.oldLevel} → Lv.{battleResult.newLevel}
                </p>
              </div>
            )}
            {battleResult.jobChange && (
              <div>
                <span className="text-2xl">⚔️</span>
                <p className="font-pixel text-lg text-purple-700">
                  전직! {battleResult.jobChange}
                </p>
              </div>
            )}
            {battleResult.jobDemote && (
              <div>
                <span className="text-2xl">💔</span>
                <p className="font-pixel text-lg text-red-700">
                  전직 해제...
                </p>
              </div>
            )}
          </Card>
        </motion.div>
      )}

      {/* Character Info */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <Card className="mb-4">
          <div className="flex items-center gap-4">
            <div className="flex h-16 w-16 items-center justify-center rounded-xl border-2 border-maple-medium bg-gradient-to-b from-maple-cream to-white text-3xl">
              {currentJob?.emoji}
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="font-pixel text-lg">{profile.nickname}</span>
                <LevelBadge level={profile.level} size="sm" />
              </div>
              <p className="text-sm text-text-secondary">{jobDisplayName}</p>
            </div>
          </div>
        </Card>
      </motion.div>

      {/* Battle Stats */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4 }}
      >
        <Card className="mb-4">
          <h3 className="font-pixel text-sm mb-3">전투 결과</h3>
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <p className="font-pixel text-2xl text-accent-orange">
                {battleResult.questionsAnswered}
              </p>
              <p className="text-xs text-text-secondary">총 문제</p>
            </div>
            <div>
              <p className="font-pixel text-2xl text-green-600">
                {battleResult.correctCount}
              </p>
              <p className="text-xs text-text-secondary">정답</p>
            </div>
            <div>
              <p className="font-pixel text-2xl text-blue-600">{accuracy}%</p>
              <p className="text-xs text-text-secondary">정답률</p>
            </div>
          </div>
          <div className={`mt-4 flex items-center justify-center gap-2 rounded-lg py-2 ${
            battleResult.totalExp >= 0 ? "bg-exp-gold/20" : "bg-hp-red/20"
          }`}>
            <span className="text-lg">{battleResult.totalExp >= 0 ? "⭐" : "💀"}</span>
            <span className={`font-pixel text-lg ${
              battleResult.totalExp >= 0 ? "text-exp-gold" : "text-hp-red"
            }`}>
              {battleResult.totalExp >= 0 ? "+" : ""}{battleResult.totalExp} EXP
            </span>
          </div>

          {/* T103: 상위 N% 표시 (마지막 문제 정답 시) */}
          {battleResult.lastQuestionCorrect && battleResult.lastQuestionAccuracy !== null && (
            <div className="mt-4 flex justify-center">
              <TopPercentBadge
                accuracyRate={battleResult.lastQuestionAccuracy}
                isCorrect={battleResult.lastQuestionCorrect}
                size="md"
              />
            </div>
          )}
        </Card>
      </motion.div>

      {/* Question History */}
      {battleResult.history.length > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
        >
          <Card className="mb-4">
            <h3 className="font-pixel text-sm mb-3">풀이 기록</h3>
            <div className="space-y-2 max-h-48 overflow-y-auto">
              {battleResult.history.map((item, index) => (
                <div
                  key={item.id}
                  className="flex items-center gap-2 rounded-lg bg-maple-cream/50 p-2"
                >
                  <span className="text-sm">
                    {item.isCorrect === "correct"
                      ? "✅"
                      : item.isCorrect === "partial"
                        ? "🔶"
                        : "❌"}
                  </span>
                  <span className="flex-1 text-xs line-clamp-1">
                    Q{index + 1}. {item.aiScore}점
                  </span>
                  <span className={`text-xs ${item.expEarned >= 0 ? "text-text-muted" : "text-hp-red"}`}>
                    {item.expEarned >= 0 ? "+" : ""}{item.expEarned}
                  </span>
                </div>
              ))}
            </div>
          </Card>
        </motion.div>
      )}

      {/* Actions */}
      <div className="mt-auto space-y-2 pb-4">
        <Button
          variant="primary"
          size="lg"
          className="w-full"
          onClick={() => router.push("/battle")}
        >
          다시 전투하기
        </Button>
        <div className="grid grid-cols-2 gap-2">
          <Button
            variant="secondary"
            size="md"
            onClick={() => router.push("/world")}
          >
            마을로
          </Button>
          <Button variant="secondary" size="md" onClick={shareResult}>
            공유하기
          </Button>
        </div>
        {!isAuthenticated && (
          <Card className="mt-4 bg-blue-50">
            <p className="text-center text-xs text-blue-700">
              로그인하면 기록이 저장됩니다
            </p>
          </Card>
        )}
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

export default function ResultPage() {
  return (
    <Suspense fallback={<LoadingSpinner />}>
      <ResultContent />
    </Suspense>
  );
}
