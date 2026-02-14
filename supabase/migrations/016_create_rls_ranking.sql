ALTER TABLE seasons ENABLE ROW LEVEL SECURITY;
ALTER TABLE hall_of_fame ENABLE ROW LEVEL SECURITY;
ALTER TABLE category_stats ENABLE ROW LEVEL SECURITY;

-- seasons: public read
CREATE POLICY "seasons_select_all" ON seasons FOR SELECT USING (true);

-- hall_of_fame: public read, service_role insert
CREATE POLICY "hall_of_fame_select_all" ON hall_of_fame FOR SELECT USING (true);

-- category_stats: public read (for rankings), own write
CREATE POLICY "category_stats_select_all" ON category_stats FOR SELECT USING (true);
CREATE POLICY "category_stats_insert_own" ON category_stats FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "category_stats_update_own" ON category_stats FOR UPDATE USING (auth.uid() = user_id);
