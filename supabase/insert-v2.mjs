import { Client } from 'pg';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

const client = new Client({
  host: 'aws-1-ap-south-1.pooler.supabase.com',
  port: 6543,
  database: 'postgres',
  user: 'postgres.aoqavvykgzhdpnojyhrw',
  password: 'dlwhdtn10!A',
  ssl: { rejectUnauthorized: false },
});

async function main() {
  await client.connect();
  console.log('Connected!');

  const files = [
    'seed-questions-v2-1.sql',
    'seed-questions-v2-2.sql',
    'seed-questions-v2-3.sql',
    'seed-questions-v2-4.sql',
  ];

  for (const f of files) {
    try {
      const sql = readFileSync(join(__dirname, f), 'utf-8');
      await client.query(sql);
      console.log(`${f}: SUCCESS`);
    } catch (e) {
      console.log(`${f}: ERROR - ${e.message}`);
    }
  }

  const { rows } = await client.query('SELECT count(*) as cnt FROM questions');
  console.log(`\nTotal questions in DB: ${rows[0].cnt}`);

  await client.end();
}

main().catch(console.error);
