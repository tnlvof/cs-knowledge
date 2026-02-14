"use client";

import { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { motion, AnimatePresence } from "framer-motion";
import Button from "@/components/ui/Button";
import Card from "@/components/ui/Card";
import HPBar from "@/components/game/HPBar";
import ComboCounter from "@/components/game/ComboCounter";
import DamagePopup from "@/components/game/DamagePopup";
import CriticalHit from "@/components/animations/CriticalHit";
import LevelUpEffect from "@/components/animations/LevelUpEffect";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import AccuracyBadge from "@/components/game/AccuracyBadge";
import { useGameState } from "@/hooks/use-game-state";
import { useGuestBattle } from "@/hooks/use-battle-guest";
import { CATEGORIES } from "@/constants/categories";
import type { Question } from "@/types/game";

// 클라이언트용 하드코딩 문제 (Supabase 없이 게스트 모드 지원)
// 정답률 데이터 포함 (T101: 전투 화면에 정답률 표시)
const SAMPLE_QUESTIONS: Question[] = [
  {
    id: "sample_1",
    category: "network",
    subcategory: "HTTP",
    difficulty: 1,
    levelMin: 1,
    levelMax: 100,
    questionText: "HTTP 상태 코드 200, 404, 500은 각각 무엇을 의미하나요?",
    correctAnswer:
      "200은 요청 성공, 404는 리소스를 찾을 수 없음, 500은 서버 내부 오류를 의미합니다.",
    keywords: ["성공", "찾을 수 없음", "서버 오류", "Not Found", "Internal Server Error"],
    explanation:
      "HTTP 상태 코드는 서버가 클라이언트 요청에 대한 처리 결과를 숫자로 알려주는 표준 응답입니다.",
    totalAttempts: 150,
    correctCount: 120,
    accuracyRate: 0.8, // 80% - 쉬운 문제 (초록색)
  },
  {
    id: "sample_2",
    category: "linux",
    subcategory: "명령어",
    difficulty: 1,
    levelMin: 1,
    levelMax: 100,
    questionText: "리눅스에서 현재 실행 중인 프로세스 목록을 확인하는 명령어는?",
    correctAnswer:
      "ps 명령어로 프로세스를 확인할 수 있으며, ps aux로 모든 프로세스를 자세히 볼 수 있습니다. top이나 htop으로 실시간 모니터링도 가능합니다.",
    keywords: ["ps", "top", "htop", "프로세스", "aux"],
    explanation:
      "ps는 현재 프로세스 스냅샷을, top/htop은 실시간 프로세스 모니터링을 제공합니다.",
    totalAttempts: 100,
    correctCount: 55,
    accuracyRate: 0.55, // 55% - 보통 문제 (노란색)
  },
  {
    id: "sample_3",
    category: "db",
    subcategory: "인덱스",
    difficulty: 1,
    levelMin: 1,
    levelMax: 100,
    questionText: "데이터베이스 인덱스(Index)란 무엇이며, 왜 사용하나요?",
    correctAnswer:
      "인덱스는 테이블의 검색 속도를 높이기 위한 자료구조로, B-Tree 등의 구조를 사용해 특정 컬럼 값을 빠르게 찾을 수 있게 합니다.",
    keywords: ["검색 속도", "자료구조", "B-Tree", "컬럼", "조회 성능"],
    explanation:
      "인덱스는 책의 목차와 비슷하게 원하는 데이터를 빠르게 찾아가는 역할을 합니다.",
    totalAttempts: 80,
    correctCount: 20,
    accuracyRate: 0.25, // 25% - 어려운 문제 (빨간색)
  },
];

export default function BattlePage() {
  const router = useRouter();
  const { profile, isLoading: profileLoading } = useGameState();
  const battle = useGuestBattle();
  const [answer, setAnswer] = useState("");
  const [mounted, setMounted] = useState(false);
  const [startTime, setStartTime] = useState<number>(0);
  const [showCritical, setShowCritical] = useState(false);
  const [showLevelUp, setShowLevelUp] = useState(false);
  const [showDamage, setShowDamage] = useState(false);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  // 마운트 확인
  useEffect(() => {
    setMounted(true);
    setStartTime(Date.now());
  }, []);

  // 전투 시작
  useEffect(() => {
    if (mounted && !battle.battleSession && profile) {
      battle.startBattle(SAMPLE_QUESTIONS);
    }
  }, [mounted, profile]); // eslint-disable-line react-hooks/exhaustive-deps

  // 결과 애니메이션
  useEffect(() => {
    if (battle.lastGrading) {
      setShowDamage(true);
      if (battle.lastGrading.isCorrect === "correct") {
        setShowCritical(true);
      }
      if (battle.lastRewards?.levelUp) {
        setTimeout(() => setShowLevelUp(true), 800);
      }
      const timer = setTimeout(() => setShowDamage(false), 1500);
      return () => clearTimeout(timer);
    }
  }, [battle.lastGrading, battle.lastRewards]);

  if (profileLoading) {
    return <LoadingSpinner />;
  }

  if (!profile) {
    router.replace("/");
    return null;
  }

  if (!battle.battleSession || !battle.monster || !battle.currentQuestion) {
    return <LoadingSpinner />;
  }

  const handleSubmit = async () => {
    if (!answer.trim() || battle.isGrading) return;
    const timeSpent = Math.floor((Date.now() - startTime) / 1000);
    await battle.submitAnswer(answer.trim(), timeSpent);
    setAnswer("");
    setStartTime(Date.now());
  };

  const handleNext = () => {
    if (
      battle.battleSession?.status === "victory" ||
      battle.battleSession?.status === "defeat"
    ) {
      router.push("/world");
      return;
    }
    // 다음 문제
    const nextQ =
      SAMPLE_QUESTIONS[
        Math.floor(Math.random() * SAMPLE_QUESTIONS.length)
      ];
    battle.setNextQuestion(nextQ);
  };

  const categoryInfo = CATEGORIES.find(
    (c) => c.id === battle.currentQuestion?.category
  );
  const battleEnded =
    battle.battleSession.status === "victory" ||
    battle.battleSession.status === "defeat";

  return (
    <div className="flex min-h-dvh flex-col px-4 pb-4 pt-4">
      {/* 상단: 몬스터 정보 */}
      <Card className="mb-3">
        <div className="flex items-center gap-3">
          <motion.div
            className="flex h-16 w-16 items-center justify-center rounded-lg border-2 border-maple-medium bg-gradient-to-b from-maple-cream to-white text-4xl shadow-[inset_0_2px_4px_rgba(0,0,0,0.1)]"
            animate={
              battle.lastGrading?.isCorrect === "correct"
                ? { x: [0, -5, 5, -5, 0] }
                : battle.lastGrading?.isCorrect === "wrong"
                  ? { scale: [1, 1.1, 1] }
                  : {}
            }
            transition={{ duration: 0.3 }}
          >
            👾
          </motion.div>
          <div className="flex-1">
            <p className="font-pixel text-sm">{battle.monster.name}</p>
            <HPBar
              current={battle.battleSession.monsterHp}
              max={battle.monster.hp}
              label="Monster HP"
              variant="monster"
            />
          </div>
        </div>
      </Card>

      {/* 데미지 팝업 */}
      <div className="relative flex justify-center">
        <AnimatePresence>
          {showDamage && battle.lastDamage && battle.lastGrading && (
            <DamagePopup
              damage={
                battle.lastGrading.isCorrect === "wrong"
                  ? battle.lastDamage.damageTaken
                  : battle.lastDamage.damageDealt
              }
              type={battle.lastGrading.isCorrect}
              show={showDamage}
            />
          )}
        </AnimatePresence>
      </div>

      {/* 내 캐릭터 정보 */}
      <Card className="mb-3">
        <div className="flex items-center justify-between">
          <div>
            <p className="font-pixel text-sm">
              {profile.nickname} Lv.{profile.level}
            </p>
            <HPBar
              current={battle.battleSession.userHp}
              max={profile.maxHp}
              label="My HP"
            />
          </div>
          <ComboCounter count={profile.comboCount} />
        </div>
      </Card>

      {/* 문제 영역 */}
      <Card className="mb-3 flex-1">
        {battle.lastGrading ? (
          // 결과 표시
          <div className="space-y-3">
            <div
              className={`rounded-lg p-3 text-center font-pixel text-lg ${
                battle.lastGrading.isCorrect === "correct"
                  ? "bg-correct/20 text-correct"
                  : battle.lastGrading.isCorrect === "partial"
                    ? "bg-partial/20 text-amber-700"
                    : "bg-wrong/20 text-wrong"
              }`}
            >
              {battle.lastGrading.isCorrect === "correct"
                ? "정답!"
                : battle.lastGrading.isCorrect === "partial"
                  ? "부분 정답"
                  : "오답..."}
              <span className="ml-2 text-sm">
                ({Math.round(battle.lastGrading.score * 100)}점)
              </span>
            </div>

            <div className="space-y-2 text-sm">
              <p className="font-body text-text-primary">
                {battle.lastGrading.feedback}
              </p>
              <div className="rounded-lg bg-maple-cream/50 p-2">
                <p className="font-pixel text-xs text-text-secondary">
                  모범 답안
                </p>
                <p className="font-body text-text-primary">
                  {battle.lastGrading.correctAnswer}
                </p>
              </div>
              <p className="font-body text-xs text-accent-mint">
                💡 {battle.lastGrading.tip}
              </p>
            </div>

            {battle.lastRewards && (
              <p className="text-center font-pixel text-sm text-exp-gold">
                +{battle.lastRewards.expEarned} EXP
              </p>
            )}
          </div>
        ) : (
          // 문제 표시
          <div className="space-y-3">
            <div className="flex flex-wrap items-center gap-2">
              <span
                className="rounded-full px-2 py-0.5 text-xs text-white"
                style={{
                  backgroundColor: categoryInfo?.color ?? "#666",
                }}
              >
                {categoryInfo?.emoji} {categoryInfo?.name}
              </span>
              <span className="font-pixel text-xs text-text-muted">
                Q{battle.battleSession.questionsAnswered + 1}
              </span>
              {/* 정답률 뱃지 (T101: 전투 화면에 정답률 표시) */}
              <AccuracyBadge
                accuracyRate={battle.currentQuestion.accuracyRate ?? null}
                totalAttempts={battle.currentQuestion.totalAttempts ?? 0}
                size="sm"
              />
            </div>
            <p className="font-body text-base leading-relaxed">
              {battle.currentQuestion.questionText}
            </p>
          </div>
        )}
      </Card>

      {/* 하단: 입력 + 버튼 */}
      <div className="space-y-2">
        {battle.lastGrading ? (
          <Button size="lg" className="w-full" onClick={handleNext}>
            {battleEnded
              ? battle.battleSession.status === "victory"
                ? "승리! 월드로 돌아가기"
                : "돌아가기"
              : "다음 문제"}
          </Button>
        ) : (
          <>
            <textarea
              ref={textareaRef}
              className="w-full resize-none rounded-lg border-2 border-maple-medium bg-white p-3 font-body text-base placeholder:text-text-muted shadow-[inset_0_2px_4px_rgba(0,0,0,0.08)] focus-visible:border-accent-orange focus-visible:outline-none focus-visible:shadow-[inset_0_2px_4px_rgba(0,0,0,0.08),0_0_0_2px_rgba(254,119,2,0.2)]"
              rows={3}
              placeholder="답변을 입력하세요..."
              value={answer}
              onChange={(e) => setAnswer(e.target.value)}
              disabled={battle.isGrading}
            />
            <Button
              size="lg"
              className="w-full"
              onClick={handleSubmit}
              loading={battle.isGrading}
              disabled={!answer.trim()}
            >
              {battle.isGrading ? "채점 중..." : "공격하기!"}
            </Button>
          </>
        )}
      </div>

      {/* 애니메이션 오버레이 */}
      <CriticalHit
        show={showCritical}
        onComplete={() => setShowCritical(false)}
      />
      <LevelUpEffect
        show={showLevelUp}
        newLevel={profile.level}
        onComplete={() => setShowLevelUp(false)}
      />
    </div>
  );
}
