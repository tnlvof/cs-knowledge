# Data Model: MeAIple Story

## Entities & Relationships

```
profiles 1──* quiz_history
profiles 1──* battle_sessions
profiles 1──* user_items
profiles 1──* donations
profiles 1──* daily_quests (Phase 2)
profiles 1──* user_achievements (Phase 2)
questions 1──* quiz_history
monsters  1──* battle_sessions
monsters  1──* quiz_history
shop_items 1──* user_items
achievements 1──* user_achievements (Phase 2)
```

## Table Definitions

### profiles
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK, FK(auth.users) | Supabase Auth user ID |
| nickname | text | UNIQUE, NOT NULL | 게임 닉네임 |
| level | int | NOT NULL, DEFAULT 1 | 현재 레벨 (1~100) |
| exp | int | NOT NULL, DEFAULT 0 | 현재 경험치 |
| hp | int | NOT NULL, DEFAULT 100 | 현재 HP |
| max_hp | int | NOT NULL, DEFAULT 100 | 최대 HP |
| job_class | text | NOT NULL, DEFAULT 'novice' | 현재 직업 |
| job_tier | int | NOT NULL, DEFAULT 0 | 전직 단계 (0~5) |
| top_category | text | | 최고 정답률 분야 |
| avatar_type | text | NOT NULL | 캐릭터 외형 (type_1~type_4) |
| gem_balance | int | NOT NULL, DEFAULT 0 | 보유 젬 |
| total_donated | int | NOT NULL, DEFAULT 0 | 누적 후원 금액 (원) |
| supporter_tier | text | NOT NULL, DEFAULT 'none' | 후원 뱃지 |
| combo_count | int | NOT NULL, DEFAULT 0 | 현재 연속 정답 수 |
| total_correct | int | NOT NULL, DEFAULT 0 | 총 정답 수 |
| total_questions | int | NOT NULL, DEFAULT 0 | 총 풀이 수 |
| created_at | timestamptz | NOT NULL, DEFAULT now() | |
| updated_at | timestamptz | NOT NULL, DEFAULT now() | |

### questions
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK, DEFAULT gen_random_uuid() | |
| category | text | NOT NULL | 분야 (network, linux, db, deploy, monitoring, security, architecture, sre) |
| subcategory | text | | 세부 주제 |
| difficulty | int | NOT NULL, CHECK(1~4) | 난이도 |
| level_min | int | NOT NULL | 최소 출제 레벨 |
| level_max | int | NOT NULL | 최대 출제 레벨 |
| question_text | text | NOT NULL | 문제 |
| correct_answer | text | NOT NULL | 모범 답안 |
| keywords | text[] | NOT NULL | 채점 핵심 키워드 |
| explanation | text | NOT NULL | 해설 |
| source_doc | text | | 출처 문서 |
| created_at | timestamptz | NOT NULL, DEFAULT now() | |

### monsters
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK | |
| name | text | NOT NULL | 몬스터 이름 |
| level_min | int | NOT NULL | 출현 최소 레벨 |
| level_max | int | NOT NULL | 출현 최대 레벨 |
| hp | int | NOT NULL | 기본 HP |
| image_url | text | | Supabase Storage URL |
| description | text | | 몬스터 설명 |
| category | text | | 관련 CS 분야 (nullable) |

### quiz_history
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK | |
| user_id | uuid | FK(profiles.id), NOT NULL | |
| question_id | uuid | FK(questions.id), NOT NULL | |
| user_answer | text | NOT NULL | 사용자 답변 |
| ai_score | decimal(3,2) | NOT NULL | 채점 점수 (0.00~1.00) |
| ai_feedback | text | NOT NULL | AI 피드백 |
| ai_correct_answer | text | NOT NULL | AI 모범 답안 |
| is_correct | text | NOT NULL | 'correct'/'partial'/'wrong' |
| exp_earned | int | NOT NULL | 획득 EXP |
| time_spent_sec | int | | 소요 시간 (초) |
| combo_count | int | NOT NULL, DEFAULT 0 | 당시 콤보 수 |
| monster_id | uuid | FK(monsters.id) | 전투 몬스터 |
| created_at | timestamptz | NOT NULL, DEFAULT now() | |

### battle_sessions
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK | |
| user_id | uuid | FK(profiles.id), NOT NULL | |
| monster_id | uuid | FK(monsters.id), NOT NULL | |
| monster_hp | int | NOT NULL | 남은 몬스터 HP |
| user_hp | int | NOT NULL | 남은 유저 HP |
| status | text | NOT NULL, DEFAULT 'active' | 'active'/'victory'/'defeat' |
| questions_answered | int | NOT NULL, DEFAULT 0 | |
| created_at | timestamptz | NOT NULL, DEFAULT now() | |
| completed_at | timestamptz | | |

### shop_items
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK | |
| name | text | NOT NULL | 아이템 이름 |
| category | text | NOT NULL | 'hat'/'weapon_skin'/'costume'/'effect'/'pet'/'frame' |
| description | text | | 설명 |
| price_gem | int | NOT NULL | 가격 (젬) |
| image_url | text | | 이미지 URL |
| rarity | text | NOT NULL, DEFAULT 'common' | 'common'/'rare'/'epic'/'legendary' |
| created_at | timestamptz | NOT NULL, DEFAULT now() | |

### user_items
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK | |
| user_id | uuid | FK(profiles.id), NOT NULL | |
| item_id | uuid | FK(shop_items.id), NOT NULL | |
| equipped | boolean | NOT NULL, DEFAULT false | 장착 여부 |
| purchased_at | timestamptz | NOT NULL, DEFAULT now() | |
| UNIQUE | | (user_id, item_id) | 중복 구매 방지 |

### donations
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK | |
| user_id | uuid | FK(profiles.id), NOT NULL | |
| amount | int | NOT NULL | 결제 금액 (원) |
| gem_amount | int | NOT NULL | 지급 젬 (보너스 포함) |
| payment_key | text | | 토스페이먼츠 paymentKey |
| order_id | text | UNIQUE, NOT NULL | 주문 ID |
| status | text | NOT NULL, DEFAULT 'pending' | 'pending'/'confirmed'/'cancelled'/'refunded' |
| created_at | timestamptz | NOT NULL, DEFAULT now() | |

## RLS Policies

| Table | SELECT | INSERT | UPDATE | DELETE |
|-------|--------|--------|--------|--------|
| profiles | 본인 only | 본인 only | 본인 only | - |
| questions | public | - | - | - |
| monsters | public | - | - | - |
| quiz_history | 본인 only | 본인 only | - | - |
| battle_sessions | 본인 only | 본인 only | 본인 only | - |
| shop_items | public | - | - | - |
| user_items | 본인 only | 본인 only | 본인 only | - |
| donations | 본인 only | service_role only | service_role only | - |

## Indexes

- `profiles(nickname)` UNIQUE
- `quiz_history(user_id, created_at DESC)` - 히스토리 조회
- `quiz_history(user_id, is_correct)` - 오답 노트
- `questions(category, difficulty, level_min, level_max)` - 문제 출제
- `battle_sessions(user_id, status)` - 활성 전투 조회
- `donations(user_id, status)` - 후원 내역
