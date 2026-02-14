-- Migration: 006_create_shop_items
-- Description: Create shop_items table for in-game shop

CREATE TABLE shop_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  category text NOT NULL,
  description text,
  price_gem int NOT NULL,
  image_url text,
  rarity text NOT NULL DEFAULT 'common',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_shop_items_category ON shop_items(category);
CREATE INDEX idx_shop_items_rarity ON shop_items(rarity);
