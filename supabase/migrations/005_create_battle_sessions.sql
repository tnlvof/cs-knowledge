-- Migration: 005_create_battle_sessions
-- Description: Create battle_sessions table for monster battle system

CREATE TABLE battle_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  monster_id uuid NOT NULL REFERENCES monsters(id),
  monster_hp int NOT NULL,
  user_hp int NOT NULL,
  status text NOT NULL DEFAULT 'active',
  questions_answered int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);

CREATE INDEX idx_battle_sessions_user_status ON battle_sessions(user_id, status);
CREATE INDEX idx_battle_sessions_user_active ON battle_sessions(user_id) WHERE status = 'active';
