CREATE TABLE IF NOT EXISTS hall_of_fame (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  season_id uuid NOT NULL REFERENCES seasons(id),
  user_id uuid NOT NULL REFERENCES profiles(id),
  rank int NOT NULL CHECK (rank BETWEEN 1 AND 3),
  final_level int NOT NULL,
  final_exp int NOT NULL,
  title_awarded text NOT NULL,
  UNIQUE(season_id, rank),
  UNIQUE(season_id, user_id)
);
