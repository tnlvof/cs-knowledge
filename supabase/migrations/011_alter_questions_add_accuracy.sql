ALTER TABLE questions
  ADD COLUMN IF NOT EXISTS total_attempts int NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS correct_count int NOT NULL DEFAULT 0;

-- accuracy_rate as a generated column
ALTER TABLE questions
  ADD COLUMN IF NOT EXISTS accuracy_rate decimal(5,4)
    GENERATED ALWAYS AS (
      CASE WHEN total_attempts = 0 THEN 0
      ELSE correct_count::decimal / total_attempts
      END
    ) STORED;
