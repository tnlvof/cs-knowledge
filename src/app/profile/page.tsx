"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { motion } from "framer-motion";
import Button from "@/components/ui/Button";
import Card from "@/components/ui/Card";
import Modal from "@/components/ui/Modal";
import Input from "@/components/ui/Input";
import LevelBadge from "@/components/game/LevelBadge";
import HPBar from "@/components/game/HPBar";
import EXPBar from "@/components/game/EXPBar";
import SalaryDisplay from "@/components/game/SalaryDisplay";
import LoadingSpinner from "@/components/ui/LoadingSpinner";
import { useAuth } from "@/hooks/use-auth";
import { useGameState } from "@/hooks/use-game-state";
import { getJobInfo } from "@/lib/utils/job";
import { SUPPORTER_BADGES } from "@/constants/supporters";
import type { Profile } from "@/types/game";

interface CategoryStat {
  id: string;
  name: string;
  emoji: string;
  color: string;
  totalCount: number;
  correctCount: number;
  avgScore: number;
}

interface EquippedItems {
  [category: string]: {
    id: string;
    name: string;
    imageUrl: string | null;
    rarity: string;
  };
}

const AVATAR_OPTIONS = [
  { id: "warrior", name: "전사", emoji: "🗡️" },
  { id: "mage", name: "마법사", emoji: "🔮" },
  { id: "archer", name: "궁수", emoji: "🏹" },
  { id: "healer", name: "힐러", emoji: "💚" },
];

export default function ProfilePage() {
  const router = useRouter();
  const { isAuthenticated, isLoading: authLoading, signInWithGoogle, signOut, syncLocalData } = useAuth();
  const { profile: guestProfile, isGuest, updateProfile: updateGuestProfile } = useGameState();
  const [profile, setProfile] = useState<Profile | null>(null);
  const [categoryStats, setCategoryStats] = useState<CategoryStat[]>([]);
  const [equippedItems, setEquippedItems] = useState<EquippedItems>({});
  const [isLoading, setIsLoading] = useState(true);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [isSyncing, setIsSyncing] = useState(false);
  const [editNickname, setEditNickname] = useState("");
  const [editAvatar, setEditAvatar] = useState("");
  const [editError, setEditError] = useState("");
  const [isSaving, setIsSaving] = useState(false);
  const [toast, setToast] = useState<string | null>(null);

  const showToast = (message: string) => {
    setToast(message);
    setTimeout(() => setToast(null), 3000);
  };

  const fetchProfile = useCallback(async () => {
    if (!isAuthenticated) {
      if (guestProfile) {
        setProfile(guestProfile);
      }
      setIsLoading(false);
      return;
    }

    try {
      const response = await fetch("/api/game/profile");
      const data = await response.json();

      if (response.ok) {
        setProfile(data.profile);
        setCategoryStats(data.categoryStats);
        setEquippedItems(data.equippedItems);
      }
    } catch (error) {
      console.error("Failed to fetch profile:", error);
    } finally {
      setIsLoading(false);
    }
  }, [isAuthenticated, guestProfile]);

  useEffect(() => {
    if (!authLoading) {
      fetchProfile();
    }
  }, [authLoading, fetchProfile]);

  const handleSync = async () => {
    setIsSyncing(true);
    try {
      await syncLocalData();
      await fetchProfile();
      showToast("게스트 데이터가 성공적으로 동기화되었습니다!");
    } catch (error) {
      console.error("Sync error:", error);
      showToast("동기화에 실패했습니다");
    } finally {
      setIsSyncing(false);
    }
  };

  const handleEditSave = async () => {
    if (!profile) return;

    setEditError("");
    setIsSaving(true);

    try {
      if (isAuthenticated) {
        const response = await fetch("/api/game/profile", {
          method: "PATCH",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            nickname: editNickname !== profile.nickname ? editNickname : undefined,
            avatarType: editAvatar !== profile.avatarType ? editAvatar : undefined,
          }),
        });

        const data = await response.json();

        if (!response.ok) {
          setEditError(data.error);
          return;
        }

        await fetchProfile();
      } else {
        updateGuestProfile({
          nickname: editNickname,
          avatarType: editAvatar,
        });
        setProfile((prev) =>
          prev ? { ...prev, nickname: editNickname, avatarType: editAvatar } : null
        );
      }

      setIsEditModalOpen(false);
    } catch (error) {
      console.error("Edit error:", error);
      setEditError("저장에 실패했습니다");
    } finally {
      setIsSaving(false);
    }
  };

  const openEditModal = () => {
    if (profile) {
      setEditNickname(profile.nickname);
      setEditAvatar(profile.avatarType);
      setEditError("");
      setIsEditModalOpen(true);
    }
  };

  const { job: currentJob, displayName: jobDisplayName } = profile
    ? getJobInfo(profile.jobClass, profile.jobTier)
    : { job: null, displayName: "" };

  const shareProfile = () => {
    if (!profile) return;

    const url = `${window.location.origin}/profile/${profile.nickname}`;
    if (navigator.share) {
      navigator.share({
        title: `${profile.nickname}의 MeAIple Story 프로필`,
        url,
      });
    } else {
      navigator.clipboard.writeText(url);
      showToast("프로필 링크가 복사되었습니다!");
    }
  };

  if (authLoading || isLoading) {
    return <LoadingSpinner />;
  }

  if (!profile) {
    return (
      <div className="flex min-h-dvh flex-col items-center justify-center px-4">
        <p className="mb-4 text-text-secondary">캐릭터를 먼저 생성해주세요</p>
        <Button variant="primary" onClick={() => router.push("/")}>
          캐릭터 생성하기
        </Button>
      </div>
    );
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
        <h1 className="font-pixel text-lg">내 프로필</h1>
        <button
          onClick={shareProfile}
          className="flex h-10 w-10 items-center justify-center rounded-full hover:bg-maple-cream/50"
          aria-label="프로필 공유"
        >
          <span className="text-xl" aria-hidden="true">📤</span>
        </button>
      </div>

      {/* Guest Login Prompt */}
      {isGuest && !isAuthenticated && (
        <Card className="mb-4 bg-gradient-to-r from-blue-50 to-purple-50">
          <div className="flex items-center justify-between">
            <div>
              <p className="font-pixel text-sm">게스트 모드</p>
              <p className="text-xs text-text-secondary">
                로그인하면 진행 상황이 저장됩니다
              </p>
            </div>
            <Button
              variant="primary"
              size="sm"
              onClick={signInWithGoogle}
            >
              로그인
            </Button>
          </div>
        </Card>
      )}

      {/* Sync Prompt */}
      {isAuthenticated && isGuest && (
        <Card className="mb-4 bg-amber-50">
          <p className="text-sm text-amber-700 mb-2">
            게스트 데이터를 계정에 동기화하시겠습니까?
          </p>
          <Button
            variant="secondary"
            size="sm"
            loading={isSyncing}
            onClick={handleSync}
          >
            데이터 동기화
          </Button>
        </Card>
      )}

      {/* Profile Card */}
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
      >
        <Card className="mb-4">
          <div className="flex items-center gap-4">
            <div className="relative">
              <div className="flex h-20 w-20 items-center justify-center rounded-2xl border-2 border-maple-medium bg-gradient-to-b from-maple-cream to-white text-4xl">
                {currentJob?.emoji}
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
            <Button variant="ghost" size="sm" onClick={openEditModal}>
              수정
            </Button>
          </div>

          <div className="mt-4 space-y-2">
            <HPBar current={profile.hp} max={profile.maxHp} label="HP" />
            <EXPBar level={profile.level} currentExp={profile.exp} />
          </div>
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
              {profile.totalQuestions > 0
                ? Math.round((profile.totalCorrect / profile.totalQuestions) * 100)
                : 0}%
            </p>
            <p className="text-xs text-text-secondary">정답률</p>
          </div>
        </div>
      </Card>

      {/* Category Stats (for logged in users) */}
      {isAuthenticated && categoryStats.length > 0 && (
        <Card className="mb-4">
          <h3 className="font-pixel text-sm mb-3">분야별 성적</h3>
          <div className="space-y-2">
            {categoryStats.map((cat) => {
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
                      {accuracy}%
                    </span>
                  </div>
                  <div className="h-2 w-full overflow-hidden rounded-full bg-gray-200">
                    <motion.div
                      className="h-full rounded-full"
                      style={{ backgroundColor: cat.color }}
                      initial={{ width: 0 }}
                      animate={{ width: `${accuracy}%` }}
                      transition={{ duration: 0.5 }}
                    />
                  </div>
                </div>
              );
            })}
          </div>
        </Card>
      )}

      {/* Equipped Items (for logged in users) */}
      {isAuthenticated && Object.keys(equippedItems).length > 0 && (
        <Card className="mb-4">
          <div className="flex items-center justify-between mb-3">
            <h3 className="font-pixel text-sm">장착 아이템</h3>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => router.push("/shop")}
            >
              상점
            </Button>
          </div>
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

      {/* Estimated Salary */}
      <SalaryDisplay salary={profile.estimatedSalary} className="mb-4" />

      {/* Gem Balance */}
      <Card className="mb-4 bg-gradient-to-r from-amber-50 to-orange-50">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="text-2xl">💎</span>
            <div>
              <p className="font-pixel text-lg">{profile.gemBalance}</p>
              <p className="text-xs text-text-secondary">보유 젬</p>
            </div>
          </div>
          {isAuthenticated && (
            <Button
              variant="secondary"
              size="sm"
              onClick={() => router.push("/donate")}
            >
              충전
            </Button>
          )}
        </div>
      </Card>

      {/* Action Buttons */}
      <div className="mt-auto space-y-2 pb-4">
        <Link
          href="/history"
          className="flex h-12 w-full items-center justify-center rounded-xl bg-accent-orange font-pixel text-base text-white transition-colors hover:bg-accent-orange/90"
        >
          학습 기록 보기
        </Link>

        {isAuthenticated && (
          <Button
            variant="ghost"
            size="md"
            className="w-full"
            onClick={signOut}
          >
            로그아웃
          </Button>
        )}
      </div>

      {/* Edit Modal */}
      <Modal
        isOpen={isEditModalOpen}
        onClose={() => setIsEditModalOpen(false)}
        title="프로필 수정"
      >
        <div className="space-y-4">
          <Input
            label="닉네임"
            value={editNickname}
            onChange={(e) => setEditNickname(e.target.value)}
            maxLength={12}
            error={editError}
            autoComplete="username"
          />

          <div>
            <p className="font-pixel text-sm text-text-secondary mb-2">아바타</p>
            <div className="grid grid-cols-4 gap-2">
              {AVATAR_OPTIONS.map((avatar) => (
                <button
                  key={avatar.id}
                  onClick={() => setEditAvatar(avatar.id)}
                  className={`flex flex-col items-center gap-1 rounded-xl border-2 p-3 transition-colors ${
                    editAvatar === avatar.id
                      ? "border-accent-orange bg-orange-50"
                      : "border-maple-medium bg-gradient-to-b from-maple-cream to-white"
                  }`}
                >
                  <span className="text-2xl">{avatar.emoji}</span>
                  <span className="text-xs">{avatar.name}</span>
                </button>
              ))}
            </div>
          </div>

          <div className="flex gap-2 pt-2">
            <Button
              variant="ghost"
              size="md"
              className="flex-1"
              onClick={() => setIsEditModalOpen(false)}
            >
              취소
            </Button>
            <Button
              variant="primary"
              size="md"
              className="flex-1"
              loading={isSaving}
              onClick={handleEditSave}
            >
              저장
            </Button>
          </div>
        </div>
      </Modal>

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
