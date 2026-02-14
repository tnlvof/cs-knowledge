"use client";

import { useEffect } from "react";
import Button from "@/components/ui/Button";

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <div className="flex min-h-dvh flex-col items-center justify-center gap-4 px-4">
      <p className="font-pixel text-lg">오류가 발생했습니다</p>
      <p className="text-sm text-text-secondary">{error.message}</p>
      <Button variant="primary" onClick={reset}>다시 시도</Button>
    </div>
  );
}
