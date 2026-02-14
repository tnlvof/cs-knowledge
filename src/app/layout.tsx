import type { Metadata, Viewport } from "next";
import MotionProvider from "@/components/providers/MotionProvider";
import "./globals.css";

export const metadata: Metadata = {
  title: "메AI플스토리 - CS 퀴즈 RPG",
  description:
    "AI 채점 주관식 퀴즈로 CS 지식을 레벨업! RPG 세계관에서 몬스터를 잡으며 배우는 IT 운영 지식.",
  openGraph: {
    title: "메AI플스토리 - CS 퀴즈 RPG",
    description: "AI 채점 주관식 퀴즈로 CS 지식을 레벨업!",
    type: "website",
  },
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  viewportFit: "cover",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ko">
      <body className="maple-bg-pattern">
        <MotionProvider>
          <div className="relative mx-auto min-h-dvh max-w-[430px] border-x-2 border-maple-medium/20 bg-frame shadow-[0_0_40px_rgba(61,35,20,0.15)]">
            {/* 메이플 골드 라인 (좌우) */}
            <div className="pointer-events-none absolute inset-y-0 left-0 w-[2px] bg-gradient-to-b from-maple-gold/40 via-maple-gold/10 to-maple-gold/40" />
            <div className="pointer-events-none absolute inset-y-0 right-0 w-[2px] bg-gradient-to-b from-maple-gold/40 via-maple-gold/10 to-maple-gold/40" />
            {children}
          </div>
        </MotionProvider>
      </body>
    </html>
  );
}
