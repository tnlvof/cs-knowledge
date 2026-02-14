"use client";

import { type InputHTMLAttributes, forwardRef, useId } from "react";

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
}

const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, error, className = "", id: propId, autoComplete, ...props }, ref) => {
    const generatedId = useId();
    const id = propId || generatedId;

    return (
      <div className="flex flex-col gap-1">
        {label && (
          <label htmlFor={id} className="font-pixel text-sm text-maple-brown">
            {label}
          </label>
        )}
        <input
          ref={ref}
          id={id}
          autoComplete={autoComplete}
          className={`
            min-h-[44px] rounded-lg border-2 border-maple-medium bg-white px-4 py-2
            font-body text-base text-text-primary
            placeholder:text-text-muted
            shadow-[inset_0_2px_4px_rgba(0,0,0,0.08)]
            focus-visible:border-accent-orange focus-visible:outline-none
            focus-visible:shadow-[inset_0_2px_4px_rgba(0,0,0,0.08),0_0_0_2px_rgba(254,119,2,0.2)]
            ${error ? "border-hp-red" : ""}
            ${className}
          `}
          {...props}
        />
        {error && (
          <p className="font-body text-xs text-hp-red">{error}</p>
        )}
      </div>
    );
  }
);

Input.displayName = "Input";

export default Input;
