-- Migration: 009_create_rls_policies
-- Description: Enable RLS and create security policies for all tables

-- =============================================
-- PROFILES TABLE
-- =============================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow public read for leaderboard (limited fields handled at API level)
CREATE POLICY "Public can view profiles for leaderboard"
  ON profiles FOR SELECT
  USING (true);

-- =============================================
-- QUESTIONS TABLE
-- =============================================
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;

-- Anyone can read questions (including guests)
CREATE POLICY "Questions are publicly readable"
  ON questions FOR SELECT
  USING (true);

-- Only service_role can insert/update/delete questions
CREATE POLICY "Service role can manage questions"
  ON questions FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');

-- =============================================
-- MONSTERS TABLE
-- =============================================
ALTER TABLE monsters ENABLE ROW LEVEL SECURITY;

-- Anyone can read monsters (including guests)
CREATE POLICY "Monsters are publicly readable"
  ON monsters FOR SELECT
  USING (true);

-- Only service_role can manage monsters
CREATE POLICY "Service role can manage monsters"
  ON monsters FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');

-- =============================================
-- QUIZ_HISTORY TABLE
-- =============================================
ALTER TABLE quiz_history ENABLE ROW LEVEL SECURITY;

-- Users can view their own quiz history
CREATE POLICY "Users can view own quiz history"
  ON quiz_history FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own quiz history
CREATE POLICY "Users can insert own quiz history"
  ON quiz_history FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- =============================================
-- BATTLE_SESSIONS TABLE
-- =============================================
ALTER TABLE battle_sessions ENABLE ROW LEVEL SECURITY;

-- Users can view their own battle sessions
CREATE POLICY "Users can view own battle sessions"
  ON battle_sessions FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own battle sessions
CREATE POLICY "Users can insert own battle sessions"
  ON battle_sessions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own battle sessions
CREATE POLICY "Users can update own battle sessions"
  ON battle_sessions FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- =============================================
-- SHOP_ITEMS TABLE
-- =============================================
ALTER TABLE shop_items ENABLE ROW LEVEL SECURITY;

-- Anyone can read shop items (including guests)
CREATE POLICY "Shop items are publicly readable"
  ON shop_items FOR SELECT
  USING (true);

-- Only service_role can manage shop items
CREATE POLICY "Service role can manage shop items"
  ON shop_items FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');

-- =============================================
-- USER_ITEMS TABLE
-- =============================================
ALTER TABLE user_items ENABLE ROW LEVEL SECURITY;

-- Users can view their own items
CREATE POLICY "Users can view own items"
  ON user_items FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own items (purchase)
CREATE POLICY "Users can insert own items"
  ON user_items FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own items (equip/unequip)
CREATE POLICY "Users can update own items"
  ON user_items FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- =============================================
-- DONATIONS TABLE
-- =============================================
ALTER TABLE donations ENABLE ROW LEVEL SECURITY;

-- Users can view their own donations
CREATE POLICY "Users can view own donations"
  ON donations FOR SELECT
  USING (auth.uid() = user_id);

-- Only service_role can insert donations (via webhook)
CREATE POLICY "Service role can insert donations"
  ON donations FOR INSERT
  WITH CHECK (auth.role() = 'service_role');

-- Only service_role can update donations (via webhook)
CREATE POLICY "Service role can update donations"
  ON donations FOR UPDATE
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');
