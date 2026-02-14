export default function LoadingSpinner({ fullScreen = true }: { fullScreen?: boolean }) {
  return (
    <div
      className={fullScreen ? "flex min-h-dvh flex-col items-center justify-center gap-3" : "flex h-40 flex-col items-center justify-center gap-2"}
      role="status"
      aria-label="로딩 중"
    >
      <div
        className="h-10 w-10 animate-spin rounded-full border-4 border-maple-gold border-t-maple-brown"
        aria-hidden="true"
      />
      <span className="font-pixel text-xs text-maple-brown animate-pulse">
        로딩 중...
      </span>
    </div>
  );
}
