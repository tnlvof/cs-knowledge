-- Add consecutive_wrong_count column to profiles table for level down penalty system
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS consecutive_wrong_count INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN profiles.consecutive_wrong_count IS 'Tracks consecutive wrong answers for additional penalty calculation';
