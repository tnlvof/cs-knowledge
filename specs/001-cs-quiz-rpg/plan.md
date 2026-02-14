# Implementation Plan: MeAIple Story - CS Quiz RPG

**Branch**: `001-cs-quiz-rpg` | **Date**: 2026-02-13 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-cs-quiz-rpg/spec.md`

## Summary

메AI플스토리는 CS 지식을 RPG 전투로 학습하는 모바일 웹앱이다. Next.js 16 App Router 풀스택으로 구현하며, Supabase(Auth + DB + Storage), Gemini AI 채점, 토스페이먼츠 결제, Framer Motion 애니메이션을 핵심 기술로 사용한다. 비로그인 localStorage → Google OAuth → Supabase 동기화 플로우를 지원한다.

## Technical Context

**Language/Version**: TypeScript 5.x + Next.js 16 (App Router)
**Primary Dependencies**: React 19, Tailwind CSS 4, Framer Motion, @supabase/supabase-js, @google/generative-ai, @tosspayments/tosspayments-sdk
**Storage**: Supabase (PostgreSQL) + Supabase Storage (이미지) + localStorage (비로그인)
**Testing**: Vitest + React Testing Library + Playwright (E2E)
**Target Platform**: Mobile Web (max-width 430px, 중앙 정렬)
**Project Type**: Web application (Next.js 풀스택)
**Performance Goals**: AI 채점 3초 이내, 60fps 애니메이션, 페이지 로드 3초 이내
**Constraints**: 100명 동시 접속 (MVP), Gemini API rate limit 대기열 처리
**Scale/Scope**: 400+ 문제, 8 CS 분야, 7 몬스터 등급, 8 직업

## Constitution Check

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Mobile-First | PASS | max-width 430px, 하단 중심 UI, 터치 44px+ |
| II. Guest-First | PASS | localStorage 우선, 강제 로그인 없음 |
| III. AI Grading Integrity | PASS | Gemini + 피드백 + 모범 답안 + 팁 |
| IV. No Pay-to-Win | PASS | 코스튬만, 능력치 아이템 없음 |
| V. Payment Security | PASS | 서버 사이드 승인, RLS |
| VI. Gamification UX | PASS | 전투 메타포, 레벨업/전직 연출 |
| VII. Copyright Safety | PASS | 독자 디자인, 메이플 에셋 미사용 |

## Project Structure

### Source Code

```text
src/
├── app/
│   ├── layout.tsx                # 모바일 레이아웃
│   ├── page.tsx                  # 진입점 (캐릭터 생성/메인 분기)
│   ├── world/page.tsx            # 월드맵 (메인)
│   ├── battle/page.tsx           # 전투 화면
│   ├── result/page.tsx           # 채점 결과
│   ├── shop/page.tsx             # 아이템샵
│   ├── donate/page.tsx           # 후원하기
│   ├── profile/
│   │   ├── page.tsx              # 내 프로필
│   │   └── [nickname]/page.tsx   # 공개 프로필
│   ├── history/page.tsx          # 히스토리
│   └── api/
│       ├── auth/callback/route.ts
│       ├── auth/sync/route.ts
│       ├── game/create-character/route.ts
│       ├── game/profile/route.ts
│       ├── battle/grade/route.ts
│       ├── battle/start/route.ts
│       ├── battle/answer/route.ts
│       ├── battle/end/route.ts
│       ├── history/route.ts
│       ├── history/stats/route.ts
│       ├── history/wrong-notes/route.ts
│       ├── payment/ready/route.ts
│       ├── payment/confirm/route.ts
│       ├── shop/items/route.ts
│       ├── shop/purchase/route.ts
│       ├── shop/equip/route.ts
│       ├── shop/inventory/route.ts
│       ├── og/profile/[nickname]/route.ts
│       └── profile/[nickname]/route.ts
├── components/
│   ├── ui/                       # Button, Card, Modal, Input, HPBar, EXPBar
│   ├── game/                     # LevelBadge, JobIcon, ComboCounter, DamagePopup
│   ├── battle/                   # MonsterCard, QuizArea, AnswerInput, BattleResult
│   └── animations/               # LevelUpEffect, JobChangeEffect, CriticalHit
├── lib/
│   ├── supabase/client.ts        # 브라우저 클라이언트
│   ├── supabase/server.ts        # 서버 클라이언트
│   ├── supabase/middleware.ts    # Auth 미들웨어
│   ├── gemini/grading.ts         # AI 채점 + 재시도
│   ├── toss-payments/client.ts   # 결제 SDK
│   ├── game-logic/exp.ts         # EXP 계산, 레벨업
│   ├── game-logic/job.ts         # 직업 전직
│   ├── game-logic/battle.ts      # 전투 (HP, 데미지, 콤보)
│   ├── game-logic/monster.ts     # 몬스터 매칭
│   └── storage/local-storage.ts  # localStorage + 동기화
├── hooks/
│   ├── use-game-state.ts
│   ├── use-battle.ts
│   ├── use-auth.ts
│   └── use-local-storage.ts
├── types/
│   ├── game.ts
│   ├── api.ts
│   └── database.ts
└── constants/
    ├── levels.ts                 # 레벨별 EXP 요구량
    ├── jobs.ts                   # 8개 직업 정의
    ├── monsters.ts               # 7등급 몬스터 정의
    └── categories.ts             # 8개 CS 분야

supabase/
├── migrations/                   # 순차 DB 마이그레이션
└── seed.sql                      # 초기 데이터

public/images/
├── characters/                   # 캐릭터 픽셀아트 (4종)
├── monsters/                     # 몬스터 이미지 (7등급)
└── items/                        # 코스튬 아이템
```

## Technology Decisions

### AI 채점 (Gemini)
- 모델: `gemini-3-flash-preview`
- 프롬프트: 채점 기준 + JSON 형식 강제
- Rate Limit: 지수 백오프 재시도 (최대 3회) + 대기열 UI
- 응답: `{ score, isCorrect, feedback, correctAnswer, tip }`

### 인증 (Supabase Auth)
- Google OAuth Only (Supabase Auth Proxy)
- 비로그인: localStorage 게임 데이터 (프로필, 전투 세션, 풀이 히스토리 전부 localStorage)
- 비로그인 AI 채점: `/api/battle/grade` (Auth 불필요, AI 채점만 수행하고 DB 저장 안 함)
- 로그인 사용자: `/api/battle/start`, `/api/battle/answer`, `/api/battle/end` (Auth Required, DB 저장)
- 동기화: `/api/auth/sync` → localStorage → Supabase INSERT (로그인 시 일괄 전송)

### 결제 (토스페이먼츠)
- 클라이언트 SDK → successUrl → 서버 `/api/payment/confirm` → 토스 승인
- secretKey 서버 환경변수만, 금액 검증 서버 사이드

### 상태 관리
- 서버: React Server Components + Server Actions
- 클라이언트: React Context + useReducer (전투 상태)
- 비로그인: localStorage + custom hook

### 애니메이션
- Framer Motion: 크리티컬/미스/레벨업/전직
- CSS: EXP 바, HP 바, 데미지 숫자
- 최적화: will-change, GPU 가속, 60fps

### 폰트
- 제목/레벨: DungGeunMo (무료 픽셀 폰트)
- 본문: Pretendard (가독성)
- 데미지 숫자: 굵은 픽셀 폰트 + 외곽선

### 컬러 시스템
- 배경: #F5F0E8 (아이보리)
- 프레임: #FFF8ED + #8B6914 (갈색 테두리)
- 액센트: #FF6B35 (오렌지/공격), #4ECDC4 (민트/정답)
- EXP 바: #FFD700→#FFA500 (골드)
- HP 바: #FF4757→#FF6B81 (레드)
