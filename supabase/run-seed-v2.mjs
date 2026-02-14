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

async function executeSQLFile(filePath, label) {
  console.log(`\n--- ${label} ---`);
  const sql = readFileSync(filePath, 'utf-8');
  try {
    await client.query(sql);
    console.log('  SUCCESS');
  } catch (e) {
    console.error(`  ERROR: ${e.message}`);
  }
}

async function main() {
  console.log('=== CS Knowledge Seed Data V2 ===');
  await client.connect();
  console.log('Connected!\n');

  const files = [
    ['seed-questions-v2-1.sql', 'V2-1: 네트워크+리눅스 (Claude)'],
    ['seed-questions-v2-2.sql', 'V2-2: DB+배포 (Claude)'],
    ['seed-questions-v2-3.sql', 'V2-3: 모니터링+보안 (Codex/GPT)'],
    ['seed-questions-v2-4.sql', 'V2-4: 아키텍처+장애대응 (Gemini)'],
  ];

  for (const [file, label] of files) {
    await executeSQLFile(join(__dirname, file), label);
  }

  const { rows } = await client.query('SELECT count(*) as cnt FROM questions');
  console.log(`\n=== 총 문제 수: ${rows[0].cnt} ===`);

  await client.end();
}

main().catch(console.error);
