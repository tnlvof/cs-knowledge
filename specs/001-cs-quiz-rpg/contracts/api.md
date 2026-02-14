# API Contracts: MeAIple Story

## Auth

### POST /api/auth/callback
Google OAuth 콜백 처리
- **Request**: Supabase Auth 자동 처리
- **Response**: Redirect to `/world`

### POST /api/auth/sync
localStorage → Supabase 동기화
- **Request Body**: `{ profile: Profile, quizHistory: QuizHistory[], battleSessions: BattleSession[] }`
- **Response**: `{ success: boolean, syncedCount: number }`
- **Auth**: Required

## Game

### POST /api/game/create-character
캐릭터 생성
- **Request Body**: `{ nickname: string, avatarType: string }`
- **Response**: `{ profile: Profile }`
- **Validation**: nickname 2~12자, unique, avatarType in ['type_1','type_2','type_3','type_4']
- **Auth**: Optional (비로그인 시 localStorage ID 반환)

### GET /api/game/profile
프로필 조회
- **Response**: `{ profile: Profile, categoryStats: CategoryStat[] }`
- **Auth**: Required

### PATCH /api/game/profile
프로필 업데이트
- **Request Body**: `{ nickname?: string, avatarType?: string }`
- **Response**: `{ profile: Profile }`
- **Auth**: Required

## Battle

### POST /api/battle/grade
비로그인/로그인 공용 AI 채점 전용
- **Request Body**: `{ questionId: string, userAnswer: string, questionText: string, correctAnswer: string, keywords: string[] }`
- **Response**:
```json
{
  "grading": {
    "score": 0.7,
    "isCorrect": "partial",
    "feedback": "string",
    "correctAnswer": "string",
    "tip": "string"
  }
}
```
- **Auth**: Not required
- **Note**: AI 채점만 수행. 전투 상태/히스토리 저장 없음. 비로그인 사용자는 이 API만 호출하고 나머지 로직은 클라이언트(localStorage)에서 처리.
- **Score Thresholds**: correct >= 0.8, partial 0.3~<0.8, wrong < 0.3
- **Rate Limit**: 지수 백오프 재시도 (최대 3회)

### POST /api/battle/start
전투 시작 (몬스터 + 첫 문제 배정)
- **Request Body**: `{ userLevel: number, preferredCategory?: string }`
- **Response**: `{ battleSession: BattleSession, monster: Monster, question: Question }`
- **Auth**: Required
- **Note**: 인증 사용자 전용. 전투 시작 시 user_hp를 max_hp로 리셋.

### POST /api/battle/answer
답변 제출 → AI 채점 + 전투 상태 업데이트
- **Request Body**: `{ battleSessionId: string, questionId: string, userAnswer: string, timeSpentSec: number }`
- **Response**:
```json
{
  "grading": {
    "score": 0.7,
    "isCorrect": "partial",
    "feedback": "string",
    "correctAnswer": "string",
    "tip": "string"
  },
  "battle": {
    "monsterHp": 60,
    "userHp": 100,
    "damageDealt": 40,
    "damageTaken": 0
  },
  "rewards": {
    "expEarned": 70,
    "comboCount": 3,
    "levelUp": false,
    "jobChange": null
  },
  "nextQuestion": { ... } | null
}
```
- **Auth**: Required
- **Damage Rules**: 오답(wrong) 시 damageTaken = 고정 20 HP. 부분정답/정답은 damageTaken = 0.

### POST /api/battle/end
전투 종료 처리
- **Request Body**: `{ battleSessionId: string }`
- **Response**: `{ battleSession: BattleSession, totalExpEarned: number }`
- **Auth**: Required

## History

### GET /api/history
풀이 기록 조회
- **Query**: `?page=1&limit=20&category=network&isCorrect=wrong`
- **Response**: `{ items: QuizHistory[], total: number, page: number }`
- **Auth**: Required

### GET /api/history/stats
분야별 통계
- **Response**: `{ categories: { name: string, totalCount: number, correctCount: number, avgScore: number }[] }`
- **Auth**: Required

### GET /api/history/wrong-notes
오답 노트
- **Query**: `?page=1&limit=20&category=network`
- **Response**: `{ items: QuizHistory[], total: number }`
- **Auth**: Required

## Payment

### POST /api/payment/ready
결제 준비 (orderId 생성)
- **Request Body**: `{ amount: number, gemPackage: '100'|'330'|'575'|'1200' }`
- **Response**: `{ orderId: string, amount: number, gemAmount: number }`
- **Auth**: Required
- **Validation**: amount in [1000, 3000, 5000, 10000]

### POST /api/payment/confirm
결제 승인
- **Request Body**: `{ paymentKey: string, orderId: string, amount: number }`
- **Response**: `{ success: boolean, gemBalance: number, donation: Donation }`
- **Auth**: Required
- **Server**: 토스페이먼츠 승인 API 호출 + 금액 검증

### GET /api/payment/history
후원 내역
- **Response**: `{ donations: Donation[] }`
- **Auth**: Required

## Shop

### GET /api/shop/items
상품 목록
- **Query**: `?category=hat`
- **Response**: `{ items: ShopItem[] }`
- **Auth**: Not required

### POST /api/shop/purchase
아이템 구매
- **Request Body**: `{ itemId: string }`
- **Response**: `{ success: boolean, gemBalance: number, item: UserItem }`
- **Auth**: Required
- **Validation**: 잔고 >= 가격, 미보유 아이템

### PATCH /api/shop/equip
장착/해제
- **Request Body**: `{ itemId: string, equipped: boolean }`
- **Response**: `{ success: boolean, equippedItems: UserItem[] }`
- **Auth**: Required

### GET /api/shop/inventory
보유 아이템
- **Response**: `{ items: UserItem[] }`
- **Auth**: Required

## Public Profile

### GET /api/og/profile/[nickname]
OG 캐릭터 카드 이미지 동적 생성
- **Response**: ImageResponse (PNG, 600x900)
- **Auth**: Not required

### GET /api/profile/[nickname]
공개 프로필 데이터
- **Response**: `{ profile: PublicProfile, categoryStats: CategoryStat[], radarChart: number[] }`
- **Auth**: Not required
