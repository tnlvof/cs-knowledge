# Data Model: 002 - 랭킹 · 예상연봉 · 레벨다운 · 정답률

## 001 테이블 수정

### profiles (컬럼 추가)

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| estimated_salary | int | NOT NULL, DEFAULT 2400 | 예상 연봉 (만원 단위) |
| best_combo | int | NOT NULL, DEFAULT 0 | 역대 최고 연속 정답 수 |
| weekly_exp | int | NOT NULL, DEFAULT 0 | 이번 주 획득 EXP (매주 초기화) |

```sql
ALTER TABLE profiles
  ADD COLUMN estimated_salary int NOT NULL DEFAULT 2400,
  ADD COLUMN best_combo int NOT NULL DEFAULT 0,
  ADD COLUMN weekly_exp int NOT NULL DEFAULT 0;
```

### questions (컬럼 추가)

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| total_attempts | int | NOT NULL, DEFAULT 0 | 총 풀이 횟수 |
| correct_count | int | NOT NULL, DEFAULT 0 | 정답 횟수 |
| accuracy_rate | decimal(5,4) | GENERATED ALWAYS AS | 정답률 (0.0000~1.0000) |

```sql
ALTER TABLE questions
  ADD COLUMN total_attempts int NOT NULL DEFAULT 0,
  ADD COLUMN correct_count int NOT NULL DEFAULT 0,
  ADD COLUMN accuracy_rate decimal(5,4)
    GENERATED ALWAYS AS (
      CASE WHEN total_attempts = 0 THEN 0
      ELSE correct_count::decimal / total_attempts
      END
    ) STORED;
```

## 신규 테이블

### seasons

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK, DEFAULT gen_random_uuid() | |
| season_number | int | UNIQUE, NOT NULL | 시즌 번호 |
| starts_at | timestamptz | NOT NULL | 시즌 시작일 |
| ends_at | timestamptz | NOT NULL | 시즌 종료일 |
| status | text | NOT NULL, DEFAULT 'upcoming' | 'upcoming'/'active'/'ended' |

### hall_of_fame

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK, DEFAULT gen_random_uuid() | |
| season_id | uuid | FK(seasons.id), NOT NULL | |
| user_id | uuid | FK(profiles.id), NOT NULL | |
| rank | int | NOT NULL, CHECK(1~3) | 최종 순위 |
| final_level | int | NOT NULL | 시즌 종료 시 레벨 |
| final_exp | int | NOT NULL | 시즌 종료 시 총 EXP |
| title_awarded | text | NOT NULL | 부여된 한정 칭호 |
| UNIQUE | | (season_id, rank) | 시즌당 순위 중복 방지 |
| UNIQUE | | (season_id, user_id) | 시즌당 유저 중복 방지 |

### category_stats

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | uuid | PK, DEFAULT gen_random_uuid() | |
| user_id | uuid | FK(profiles.id), NOT NULL | |
| category | text | NOT NULL | 분야 코드 |
| correct_count | int | NOT NULL, DEFAULT 0 | 정답 수 |
| total_count | int | NOT NULL, DEFAULT 0 | 총 풀이 수 |
| accuracy | decimal(5,4) | GENERATED ALWAYS AS | 정답률 |
| updated_at | timestamptz | NOT NULL, DEFAULT now() | |
| UNIQUE | | (user_id, category) | 유저당 분야별 1행 |

```sql
CREATE TABLE category_stats (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id),
  category text NOT NULL,
  correct_count int NOT NULL DEFAULT 0,
  total_count int NOT NULL DEFAULT 0,
  accuracy decimal(5,4) GENERATED ALWAYS AS (
    CASE WHEN total_count = 0 THEN 0
    ELSE correct_count::decimal / total_count
    END
  ) STORED,
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, category)
);
```

## Entity Relationships (추가)

```
profiles 1──* category_stats
profiles 1──* hall_of_fame
seasons  1──* hall_of_fame
```

## RLS Policies (추가)

| Table | SELECT | INSERT | UPDATE | DELETE |
|-------|--------|--------|--------|--------|
| seasons | public | - | - | - |
| hall_of_fame | public | service_role only | - | - |
| category_stats | public (랭킹 조회) | 본인 only | 본인 only | - |

## Indexes (추가)

- `profiles(level DESC, exp DESC)` - 종합 랭킹
- `profiles(weekly_exp DESC)` - 주간 랭킹
- `profiles(best_combo DESC)` - 콤보 랭킹
- `category_stats(category, correct_count DESC, accuracy DESC)` - 분야별 랭킹
- `questions(total_attempts)` - 정답률 집계
- `hall_of_fame(season_id, rank)` - 명예의 전당 조회
- `seasons(status)` - 활성 시즌 조회

## Migration Files

```
supabase/migrations/
  010_alter_profiles_add_ranking_salary.sql
  011_alter_questions_add_accuracy.sql
  012_create_seasons.sql
  013_create_hall_of_fame.sql
  014_create_category_stats.sql
  015_create_ranking_indexes.sql
  016_create_rls_ranking.sql
  017_create_weekly_reset_cron.sql
```
