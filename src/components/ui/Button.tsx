"use client";

import { type ButtonHTMLAttributes } from "react";

type Variant = "primary" | "secondary" | "danger" | "ghost";
type Size = "sm" | "md" | "lg";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  size?: Size;
  loading?: boolean;
}

const variantStyles: Record<Variant, string> = {
  primary:
    "bg-gradient-to-b from-accent-orange-light to-accent-orange text-white border-2 border-maple-medium " +
    "shadow-[0_4px_0_0_#5C2A1E,inset_0_1px_0_rgba(255,255,255,0.35)] " +
    "active:shadow-[0_1px_0_0_#5C2A1E,inset_0_2px_4px_rgba(0,0,0,0.2)] active:translate-y-[3px] " +
    "hover:from-[#FFBB44] hover:to-accent-orange",
  secondary:
    "bg-gradient-to-b from-frame to-maple-cream text-maple-brown border-2 border-maple-medium " +
    "shadow-[0_3px_0_0_#874730,inset_0_1px_0_rgba(255,255,255,0.5)] " +
    "active:shadow-[0_1px_0_0_#874730,inset_0_2px_4px_rgba(0,0,0,0.15)] active:translate-y-[2px]",
  danger:
    "bg-gradient-to-b from-hp-pink to-hp-red text-white border-2 border-red-900 " +
    "shadow-[0_4px_0_0_#7A1A1A,inset_0_1px_0_rgba(255,255,255,0.3)] " +
    "active:shadow-[0_1px_0_0_#7A1A1A,inset_0_2px_4px_rgba(0,0,0,0.2)] active:translate-y-[3px]",
  ghost:
    "bg-transparent text-text-secondary hover:bg-maple-cream/50 hover:text-maple-brown",
};

const sizeStyles: Record<Size, string> = {
  sm: "px-3 py-1.5 text-sm min-h-[36px]",
  md: "px-5 py-2.5 text-base min-h-[44px]",
  lg: "px-7 py-3.5 text-lg min-h-[52px]",
};

export default function Button({
  variant = "primary",
  size = "md",
  loading = false,
  disabled,
  className = "",
  children,
  ...props
}: ButtonProps) {
  return (
    <button
      className={`
        inline-flex items-center justify-center rounded-lg font-pixel font-bold
        transition-all duration-100 select-none
        disabled:opacity-50 disabled:cursor-not-allowed disabled:active:translate-y-0
        ${variantStyles[variant]}
        ${sizeStyles[size]}
        ${className}
      `}
      disabled={disabled || loading}
      {...props}
    >
      {loading ? (
        <span className="inline-block h-5 w-5 animate-spin rounded-full border-2 border-current border-t-transparent" />
      ) : (
        children
      )}
    </button>
  );
}
