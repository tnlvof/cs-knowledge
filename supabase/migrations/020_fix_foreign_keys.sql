-- hall_of_fame FK에 ON DELETE 추가
ALTER TABLE hall_of_fame DROP CONSTRAINT IF EXISTS hall_of_fame_user_id_fkey;
ALTER TABLE hall_of_fame ADD CONSTRAINT hall_of_fame_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;

ALTER TABLE hall_of_fame DROP CONSTRAINT IF EXISTS hall_of_fame_season_id_fkey;
ALTER TABLE hall_of_fame ADD CONSTRAINT hall_of_fame_season_id_fkey
  FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE RESTRICT;

-- category_stats FK에 ON DELETE CASCADE 추가
ALTER TABLE category_stats DROP CONSTRAINT IF EXISTS category_stats_user_id_fkey;
ALTER TABLE category_stats ADD CONSTRAINT category_stats_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;
