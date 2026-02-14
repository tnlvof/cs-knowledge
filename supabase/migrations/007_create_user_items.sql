-- Migration: 007_create_user_items
-- Description: Create user_items table for user inventory

CREATE TABLE user_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  item_id uuid NOT NULL REFERENCES shop_items(id),
  equipped boolean NOT NULL DEFAULT false,
  purchased_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, item_id)
);

CREATE INDEX idx_user_items_user ON user_items(user_id);
CREATE INDEX idx_user_items_equipped ON user_items(user_id, equipped) WHERE equipped = true;
