<!--
Sync Impact Report
- Version: 1.0.0 (initial)
- Added principles: I~VII (all new)
- Added sections: Technology Constraints, Development Workflow
- Templates requiring updates: N/A (initial setup)
- Follow-up TODOs: None
-->

# MeAIple Story Constitution

## Core Principles

### I. Mobile-First (NON-NEGOTIABLE)

모든 UI/UX는 모바일 환경을 최우선으로 설계한다.
- MUST: max-width 430px 기준 중앙 정렬 레이아웃
- MUST: 한 손(엄지) 조작 가능한 하단 중심 인터랙션
- MUST: 터치 타겟 최소 44x44px
- PC 접속 시에도 모바일 UI 유지 (반응형 아님, 모바일 Only)

### II. Guest-First Experience

비로그인 사용자도 핵심 기능을 즉시 사용할 수 있어야 한다.
- MUST: 첫 접속 시 로그인 없이 캐릭터 생성 + 퀴즈 플레이 가능
- MUST: 비로그인 데이터는 localStorage에 안전하게 보관
- MUST: 강제 로그인 절대 금지 (유도는 허용, 차단은 금지)
- MUST: 로그인 시 localStorage → Supabase 자동 동기화

### III. AI Grading Integrity

AI 채점의 정확성과 일관성이 서비스 핵심 가치이다.
- MUST: 주관식 답변에 대해 0.0~1.0 정량적 채점 제공
- MUST: 모든 채점에 피드백 + 모범 답안 + 학습 팁 포함
- MUST: 채점 기준은 핵심 키워드, 개념 정확성, 답변 완성도 3축
- SHOULD: AI 응답 실패 시 재시도 + 사용자 안내 (무응답 금지)

### IV. No Pay-to-Win (NON-NEGOTIABLE)

후원/결제는 순수 꾸미기 아이템에만 적용되며, 게임 능력치에 영향을 주지 않는다.
- MUST: 젬으로 구매 가능한 아이템은 코스튬(외형)만 허용
- MUST: 후원 여부와 관계없이 퀴즈/레벨업/전직 등 핵심 기능 동일
- MUST: 경험치 부스트, 문제 스킵 등 능력치 관련 유료 아이템 절대 금지
- MUST: 후원 진입점에 강제성 없음, 닫기 버튼 항상 존재

### V. Payment & Data Security

결제 및 사용자 데이터 처리에서 보안을 최우선한다.
- MUST: 토스페이먼츠 결제는 서버 사이드에서만 승인 처리 (secretKey 노출 금지)
- MUST: Supabase RLS(Row Level Security) 모든 테이블에 적용
- MUST: 본인 데이터만 읽기/쓰기 가능 (public 테이블 제외)
- MUST: 결제 금액 검증은 서버에서 수행 (클라이언트 데이터 신뢰 금지)
- SHOULD: 환불 정책 준수 (미사용 젬 7일 이내 환불)

### VI. Gamification-Driven UX

학습 동기를 극대화하는 게이미피케이션 요소를 일관되게 적용한다.
- MUST: 모든 퀴즈 인터랙션은 전투 메타포로 표현 (답변=공격, 정답=데미지)
- MUST: 레벨업/전직 등 성장 이벤트에 화려한 애니메이션 연출
- MUST: 연속 정답 콤보, HP 시스템으로 긴장감 유지
- SHOULD: 메이플스토리 감성 차용하되 독자 디자인으로 저작권 회피
- SHOULD: 2D 픽셀아트 + 밝은 파스텔 톤 유지

### VII. Copyright Safety

메이플스토리 감성을 차용하되, 저작권 침해를 확실히 회피한다.
- MUST: 캐릭터/몬스터/UI 프레임 모두 독자 디자인
- MUST: 메이플 고유 용어(메소, 스타포스 등) 사용 금지
- MUST: 메이플 원본 에셋(이미지, 사운드, 폰트) 사용 금지
- SHOULD: 3등신 픽셀 캐릭터, IT 테마 몬스터로 차별화
- SHOULD: 무료 라이선스 폰트/사운드만 사용

## Technology Constraints

- **Framework**: Next.js 16 (App Router) + TypeScript
- **Styling**: Tailwind CSS 4 + Framer Motion
- **Database**: Supabase (PostgreSQL) + Supabase Auth (Google OAuth)
- **AI**: Gemini 3 Flash Preview
- **Payment**: TossPayments API
- **Deployment**: Vercel
- **Image Storage**: Supabase Storage

## Development Workflow

- 기능 개발은 speckit 파이프라인(specify → clarify → plan → tasks → implement)을 따른다
- 모든 API Route Handler는 서버 사이드 검증 포함
- 데이터베이스 변경은 Supabase Migration으로 관리
- 결제 관련 코드 변경은 반드시 보안 리뷰 수행

## Governance

이 Constitution은 프로젝트의 최상위 규범이며, 모든 설계 및 구현 결정에 우선한다.
- 원칙 수정 시 MAJOR 버전 변경 + 이유 문서화 필수
- NON-NEGOTIABLE 표시된 원칙은 예외 없이 준수
- 모든 PR/리뷰에서 Constitution 준수 여부 확인

**Version**: 1.0.0 | **Ratified**: 2026-02-13 | **Last Amended**: 2026-02-13
