-- Migration: 004_create_quiz_history
-- Description: Create quiz_history table to track user answers

CREATE TABLE quiz_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  question_id uuid NOT NULL REFERENCES questions(id),
  user_answer text NOT NULL,
  ai_score decimal(3,2) NOT NULL,
  ai_feedback text NOT NULL,
  ai_correct_answer text NOT NULL,
  is_correct text NOT NULL,
  exp_earned int NOT NULL,
  time_spent_sec int,
  combo_count int NOT NULL DEFAULT 0,
  monster_id uuid REFERENCES monsters(id),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_quiz_history_user_date ON quiz_history(user_id, created_at DESC);
CREATE INDEX idx_quiz_history_user_correct ON quiz_history(user_id, is_correct);
CREATE INDEX idx_quiz_history_question ON quiz_history(question_id);
