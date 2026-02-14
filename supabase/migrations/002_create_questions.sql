-- Migration: 002_create_questions
-- Description: Create questions table for CS quiz questions

CREATE TABLE questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category text NOT NULL,
  subcategory text,
  difficulty int NOT NULL CHECK (difficulty BETWEEN 1 AND 4),
  level_min int NOT NULL,
  level_max int NOT NULL,
  question_text text NOT NULL,
  correct_answer text NOT NULL,
  keywords text[] NOT NULL,
  explanation text NOT NULL,
  source_doc text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_questions_selection ON questions(category, difficulty, level_min, level_max);
CREATE INDEX idx_questions_category ON questions(category);
CREATE INDEX idx_questions_difficulty ON questions(difficulty);
