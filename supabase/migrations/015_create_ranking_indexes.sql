CREATE INDEX IF NOT EXISTS idx_profiles_overall_rank ON profiles(level DESC, exp DESC);
CREATE INDEX IF NOT EXISTS idx_profiles_weekly_rank ON profiles(weekly_exp DESC);
CREATE INDEX IF NOT EXISTS idx_profiles_combo_rank ON profiles(best_combo DESC);
CREATE INDEX IF NOT EXISTS idx_category_stats_rank ON category_stats(category, correct_count DESC, accuracy DESC);
CREATE INDEX IF NOT EXISTS idx_questions_attempts ON questions(total_attempts);
CREATE INDEX IF NOT EXISTS idx_hall_of_fame_season ON hall_of_fame(season_id, rank);
CREATE INDEX IF NOT EXISTS idx_seasons_status ON seasons(status);
