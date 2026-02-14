-- Migration: 003_create_monsters
-- Description: Create monsters table for battle system

CREATE TABLE monsters (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  level_min int NOT NULL,
  level_max int NOT NULL,
  hp int NOT NULL,
  image_url text,
  description text,
  category text
);

CREATE INDEX idx_monsters_level ON monsters(level_min, level_max);
CREATE INDEX idx_monsters_category ON monsters(category);
