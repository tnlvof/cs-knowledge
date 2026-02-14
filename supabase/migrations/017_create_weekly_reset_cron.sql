-- Requires pg_cron extension (enabled in Supabase dashboard)
-- Reset weekly_exp every Monday at 00:00 KST (15:00 UTC Sunday)
SELECT cron.schedule(
  'reset-weekly-exp',
  '0 15 * * 0',
  $$UPDATE profiles SET weekly_exp = 0$$
);
