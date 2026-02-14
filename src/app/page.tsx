"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { motion } from "framer-motion";
import Button from "@/components/ui/Button";
import Input from "@/components/ui/Input";
import Card from "@/components/ui/Card";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import { useGameState } from "@/hooks/use-game-state";

const AVATAR_TYPES = [
  { id: "warrior", label: "검사", emoji: "⚔️" },
  { id: "mage", label: "마법사", emoji: "🧙" },
  { id: "archer", label: "궁수", emoji: "🏹" },
  { id: "healer", label: "도적", emoji: "🗡️" },
];

export default function HomePage() {
  const router = useRouter();
  const { hasCharacter, isLoading, createCharacter } = useGameState();
  const [nickname, setNickname] = useState("");
  const [selectedAvatar, setSelectedAvatar] = useState("warrior");
  const [error, setError] = useState("");
  const [isCreating, setIsCreating] = useState(false);

  // 이미 캐릭터가 있으면 월드맵으로
  useEffect(() => {
    if (!isLoading && hasCharacter) {
      router.replace("/world");
    }
  }, [isLoading, hasCharacter, router]);

  if (isLoading) {
    return <LoadingSpinner />;
  }

  if (!isLoading && hasCharacter) {
    return <LoadingSpinner />;
  }

  const validateNickname = (name: string): string | null => {
    if (name.length < 2) return "닉네임은 2자 이상이어야 합니다";
    if (name.length > 12) return "닉네임은 12자 이하여야 합니다";
    if (!/^[가-힣a-zA-Z0-9]+$/.test(name))
      return "한글, 영문, 숫자만 사용 가능합니다";
    return null;
  };

  const handleCreate = async () => {
    const validationError = validateNickname(nickname);
    if (validationError) {
      setError(validationError);
      return;
    }

    setIsCreating(true);
    setError("");

    try {
      createCharacter(nickname, selectedAvatar);
      router.push("/world");
    } catch {
      setError("캐릭터 생성에 실패했습니다. 다시 시도해주세요.");
      setIsCreating(false);
    }
  };

  return (
    <div className="flex min-h-dvh flex-col items-center justify-center px-6 py-10">
      <motion.div
        className="w-full"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        {/* 타이틀 - 메이플스토리 로고 스타일 */}
        <div className="mb-8 text-center">
          <motion.h1
            className="font-pixel text-4xl font-bold text-accent-orange maple-sparkle inline-block"
            style={{
              textShadow: "2px 2px 0 #5C2A1E, -1px -1px 0 rgba(245,180,72,0.5)",
            }}
            initial={{ scale: 0.8 }}
            animate={{ scale: 1 }}
            transition={{ type: "spring", damping: 10, stiffness: 150 }}
          >
            메AI플스토리
          </motion.h1>
          <p className="mt-3 font-pixel text-sm text-maple-brown">
            CS 퀴즈 RPG - 모험을 시작하세요!
          </p>
        </div>

        {/* 캐릭터 생성 카드 - 나무 프레임 */}
        <Card className="space-y-6">
          <h2 className="font-pixel text-lg text-center text-maple-brown">캐릭터 생성</h2>

          {/* 닉네임 입력 */}
          <Input
            label="닉네임"
            placeholder="2~12자 한글/영문/숫자"
            value={nickname}
            onChange={(e) => {
              setNickname(e.target.value);
              setError("");
            }}
            error={error}
            maxLength={12}
            autoComplete="off"
          />

          {/* 아바타 선택 - 메이플 직업 선택 스타일 */}
          <div>
            <p className="mb-2 font-pixel text-sm text-maple-brown">
              직업 선택
            </p>
            <div className="grid grid-cols-4 gap-2">
              {AVATAR_TYPES.map((avatar) => (
                <motion.button
                  key={avatar.id}
                  onClick={() => setSelectedAvatar(avatar.id)}
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  className={`flex flex-col items-center gap-1 rounded-lg border-2 p-3 transition-all ${
                    selectedAvatar === avatar.id
                      ? "border-maple-gold bg-gradient-to-b from-accent-orange/20 to-maple-gold/20 shadow-[0_0_10px_rgba(245,180,72,0.3)]"
                      : "border-maple-medium/50 bg-white/80 hover:border-maple-gold/60"
                  }`}
                >
                  <span className="text-3xl">{avatar.emoji}</span>
                  <span className="font-pixel text-xs text-maple-brown">{avatar.label}</span>
                </motion.button>
              ))}
            </div>
          </div>

          {/* 모험 시작 버튼 */}
          <Button
            size="lg"
            className="w-full"
            onClick={handleCreate}
            loading={isCreating}
            disabled={!nickname.trim()}
          >
            모험 시작하기!
          </Button>
        </Card>

        <p className="mt-4 text-center font-body text-xs text-text-muted">
          로그인 없이 바로 시작할 수 있어요
        </p>
      </motion.div>
    </div>
  );
}
