-- Migration: 008_create_donations
-- Description: Create donations table for payment tracking

CREATE TABLE donations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount int NOT NULL,
  gem_amount int NOT NULL,
  payment_key text,
  order_id text UNIQUE NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_donations_user_status ON donations(user_id, status);
CREATE INDEX idx_donations_order ON donations(order_id);
CREATE INDEX idx_donations_status ON donations(status);
