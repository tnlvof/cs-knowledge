"use client";

import { useState, useEffect, useCallback } from "react";
import type { Profile } from "@/types/game";
import {
  getProfile,
  saveProfile,
  createGuestProfile,
  isGuestUser,
} from "@/lib/storage/local-storage";
import { LEVEL_TABLE } from "@/constants/levels";

export function useGameState() {
  const [profile, setProfile] = useState<Profile | null>(null);
  const [isGuest, setIsGuest] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const stored = getProfile();
    if (stored) {
      setProfile(stored);
      setIsGuest(isGuestUser());
    }
    setIsLoading(false);
  }, []);

  const createCharacter = useCallback(
    (nickname: string, avatarType: string) => {
      const newProfile = createGuestProfile(nickname, avatarType);
      setProfile(newProfile);
      setIsGuest(true);
      return newProfile;
    },
    []
  );

  const updateProfile = useCallback(
    (updates: Partial<Profile>) => {
      if (!profile) return;
      const updated = { ...profile, ...updates, updatedAt: new Date().toISOString() };
      saveProfile(updated);
      setProfile(updated);
    },
    [profile]
  );

  const addExp = useCallback(
    (amount: number) => {
      if (!profile) return { levelUp: false, newLevel: 1 };

      let newExp = profile.exp + amount;
      let newLevel = profile.level;
      let levelUp = false;

      while (newLevel < 100) {
        const levelInfo = LEVEL_TABLE[newLevel - 1];
        if (newExp >= levelInfo.requiredExp) {
          newExp -= levelInfo.requiredExp;
          newLevel++;
          levelUp = true;
        } else {
          break;
        }
      }

      const updated = {
        ...profile,
        exp: newExp,
        level: newLevel,
        updatedAt: new Date().toISOString(),
      };
      saveProfile(updated);
      setProfile(updated);

      return { levelUp, newLevel };
    },
    [profile]
  );

  return {
    profile,
    isGuest,
    isLoading,
    createCharacter,
    updateProfile,
    addExp,
    hasCharacter: profile !== null,
  };
}
