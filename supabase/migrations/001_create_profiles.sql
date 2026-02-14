-- Migration: 001_create_profiles
-- Description: Create profiles table for user game data

CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nickname text UNIQUE NOT NULL,
  level int NOT NULL DEFAULT 1,
  exp int NOT NULL DEFAULT 0,
  hp int NOT NULL DEFAULT 100,
  max_hp int NOT NULL DEFAULT 100,
  job_class text NOT NULL DEFAULT 'novice',
  job_tier int NOT NULL DEFAULT 0,
  top_category text,
  avatar_type text NOT NULL,
  gem_balance int NOT NULL DEFAULT 0,
  total_donated int NOT NULL DEFAULT 0,
  supporter_tier text NOT NULL DEFAULT 'none',
  combo_count int NOT NULL DEFAULT 0,
  total_correct int NOT NULL DEFAULT 0,
  total_questions int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Create index for leaderboard queries
CREATE INDEX idx_profiles_level ON profiles(level DESC, exp DESC);
CREATE INDEX idx_profiles_total_correct ON profiles(total_correct DESC);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-update updated_at
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
