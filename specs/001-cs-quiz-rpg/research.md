# Research: MeAIple Story

## Decision Log

### D1: AI 채점 모델 선택
- **Decision**: Gemini 3 Flash Preview (`gemini-3-flash-preview`)
- **Rationale**: 빠른 응답 속도 + 저비용 + 한국어 지원. 주관식 채점에 충분한 성능.
- **Alternatives**: GPT-4o-mini (비용 높음), Claude Haiku (Anthropic SDK 추가 의존성)

### D2: Rate Limit 대응 전략
- **Decision**: 지수 백오프 재시도 (최대 3회) + 로딩 애니메이션
- **Rationale**: MVP 100명 동시접속에서는 rate limit 빈발 가능성 낮음. 재시도로 대부분 해결.
- **Alternatives**: 키워드 매칭 폴백 (정확도 저하), 대체 모델 폴백 (복잡도 증가)

### D3: 상태 관리 방식
- **Decision**: React Context + useReducer (전투), localStorage (비로그인 영속)
- **Rationale**: 전역 상태 라이브러리(Zustand/Redux) 없이도 전투 상태는 페이지 단위로 충분. Next.js RSC와 자연스럽게 통합.
- **Alternatives**: Zustand (추가 의존성), Jotai (원자적이지만 학습 비용)

### D4: 인증 플로우
- **Decision**: Supabase Auth + Google OAuth Only + Auth Proxy
- **Rationale**: 단일 소셜 로그인으로 UX 단순화. Supabase Auth Proxy로 빠른 인증.
- **Alternatives**: NextAuth.js (추가 레이어), 자체 JWT (보안 리스크)

### D5: 결제 연동
- **Decision**: 토스페이먼츠 일반결제 (카드/토스페이/간편결제)
- **Rationale**: 한국 사용자 대상, 간편결제 지원, 잘 정리된 API 문서
- **Alternatives**: 카카오페이 단건결제 (결제수단 제한), Stripe (해외 결제 중심)

### D6: 이미지 저장소
- **Decision**: Supabase Storage
- **Rationale**: 이미 Supabase를 DB로 사용하므로 추가 서비스 없이 이미지 호스팅 가능
- **Alternatives**: Cloudinary (무료 한도 있음), Vercel Blob (추가 비용)

### D7: 픽셀 폰트
- **Decision**: DungGeunMo (둥근모꼴) - 무료 한글 픽셀 폰트
- **Rationale**: 한글 지원 + 레트로 게임 감성 + 무료 라이선스
- **Alternatives**: 갈무리체, 도스고딕 (둘 다 무료지만 DungGeunMo가 가장 널리 사용)

### D8: 애니메이션 라이브러리
- **Decision**: Framer Motion
- **Rationale**: React 네이티브 통합, 선언적 API, 모바일 성능 우수
- **Alternatives**: GSAP (라이선스 주의), react-spring (학습 곡선), CSS-only (복잡한 시퀀스 어려움)
