import type { ReactNode } from "react";

interface CardProps {
  children: ReactNode;
  className?: string;
  variant?: "default" | "wood" | "gold";
}

export default function Card({ children, className = "", variant = "default" }: CardProps) {
  const baseStyles = "rounded-lg p-4 relative";

  const variantStyles = {
    default:
      "bg-frame border-2 border-maple-medium shadow-[0_4px_8px_rgba(61,35,20,0.15),inset_0_1px_0_rgba(255,255,255,0.4)] " +
      "before:absolute before:inset-x-0 before:top-0 before:h-[3px] before:rounded-t-lg before:bg-gradient-to-r before:from-maple-gold/0 before:via-maple-gold/60 before:to-maple-gold/0",
    wood:
      "maple-wood-frame text-white/90",
    gold:
      "bg-frame maple-gold-border",
  };

  return (
    <div className={`${baseStyles} ${variantStyles[variant]} ${className}`}>
      {children}
    </div>
  );
}
