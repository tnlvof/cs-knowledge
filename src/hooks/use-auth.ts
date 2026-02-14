"use client";

import { useState, useEffect, useCallback, useMemo } from "react";
import { createClient } from "@/lib/supabase/client";
import type { User } from "@supabase/supabase-js";
import {
  getFullGameState,
  clearGameData,
} from "@/lib/storage/local-storage";

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const supabase = useMemo(() => createClient(), []);

  useEffect(() => {
    const getInitialUser = async () => {
      try {
        const {
          data: { user },
        } = await supabase.auth.getUser();
        setUser(user);
      } catch (error) {
        console.error("Error getting user:", error);
      } finally {
        setIsLoading(false);
      }
    };

    getInitialUser();

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });

    return () => {
      subscription.unsubscribe();
    };
  }, [supabase.auth]);

  const signInWithGoogle = useCallback(async () => {
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider: "google",
        options: {
          redirectTo: `${window.location.origin}/api/auth/callback`,
          queryParams: {
            access_type: "offline",
            prompt: "consent",
          },
        },
      });

      if (error) {
        console.error("Google sign in error:", error);
        throw error;
      }
    } catch (error) {
      console.error("Sign in error:", error);
      throw error;
    }
  }, [supabase.auth]);

  const signOut = useCallback(async () => {
    try {
      const { error } = await supabase.auth.signOut();
      if (error) {
        console.error("Sign out error:", error);
        throw error;
      }
      setUser(null);
    } catch (error) {
      console.error("Sign out error:", error);
      throw error;
    }
  }, [supabase.auth]);

  const syncLocalData = useCallback(async () => {
    if (!user) {
      throw new Error("로그인이 필요합니다");
    }

    const localState = getFullGameState();
    if (!localState || !localState.profile) {
      return { success: true, message: "동기화할 데이터가 없습니다" };
    }

    try {
      const response = await fetch("/api/auth/sync", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          profile: localState.profile,
          quizHistory: localState.quizHistory,
          battleSessions: localState.battleSession
            ? [localState.battleSession]
            : [],
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || "동기화 실패");
      }

      const result = await response.json();

      // Clear local data after successful sync
      clearGameData();

      return result;
    } catch (error) {
      console.error("Sync error:", error);
      throw error;
    }
  }, [user]);

  return {
    user,
    isAuthenticated: !!user,
    isLoading,
    signInWithGoogle,
    signOut,
    syncLocalData,
  };
}
