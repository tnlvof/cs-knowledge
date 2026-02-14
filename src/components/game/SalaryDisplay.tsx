"use client";

import { formatSalary } from "@/lib/game-logic/salary";

interface SalaryDisplayProps {
  salary: number;
  showSource?: boolean;
  size?: "sm" | "md" | "lg";
  className?: string;
}

const sizeStyles = {
  sm: {
    container: "px-3 py-2",
    label: "text-xs",
    value: "text-base",
    source: "text-[10px]",
  },
  md: {
    container: "px-4 py-3",
    label: "text-sm",
    value: "text-lg",
    source: "text-xs",
  },
  lg: {
    container: "px-5 py-4",
    label: "text-sm",
    value: "text-2xl",
    source: "text-xs",
  },
};

export default function SalaryDisplay({
  salary,
  showSource = true,
  size = "md",
  className = "",
}: SalaryDisplayProps) {
  const styles = sizeStyles[size];

  return (
    <div
      className={`rounded-xl bg-gradient-to-r from-emerald-50 to-green-50 border border-emerald-200 ${styles.container} ${className}`}
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span className={size === "sm" ? "text-lg" : "text-2xl"}>💰</span>
          <div>
            <p className={`text-emerald-600 ${styles.label}`}>예상 연봉</p>
            <p className={`font-pixel text-emerald-700 ${styles.value}`}>
              {formatSalary(salary)}만원
            </p>
          </div>
        </div>
      </div>
      {showSource && (
        <p className={`mt-1 text-text-muted ${styles.source}`}>
          출처: 한국고용정보원 공공데이터 기반 추정
        </p>
      )}
    </div>
  );
}
