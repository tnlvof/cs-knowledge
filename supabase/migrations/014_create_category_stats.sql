CREATE TABLE IF NOT EXISTS category_stats (
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
