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
    console.log(`  SUCCESS`);
  } catch (e) {
    console.error(`  ERROR: ${e.message}`);
  }
}

async function countTable(table) {
  const { rows } = await client.query(`SELECT count(*) as cnt FROM ${table}`);
  return parseInt(rows[0].cnt);
}

async function main() {
  console.log('=== CS Knowledge Seed Data (Direct SQL) ===');
  await client.connect();
  console.log('Connected!\n');

  // seed-questions-4.sql (missing from previous run)
  await executeSQLFile(join(__dirname, 'seed-questions-4.sql'), 'Questions: seed-questions-4.sql');

  // gamedata
  await executeSQLFile(join(__dirname, 'seed-gamedata.sql'), 'Gamedata: monsters + achievements + shop_items');

  // Count results
  const questions = await countTable('questions');
  const monsters = await countTable('monsters');
  const achievements = await countTable('achievements');
  const shopItems = await countTable('shop_items');

  console.log('\n=== TOTAL COUNTS ===');
  console.log(`Questions: ${questions}`);
  console.log(`Monsters: ${monsters}`);
  console.log(`Achievements: ${achievements}`);
  console.log(`Shop Items: ${shopItems}`);
  console.log(`Total: ${questions + monsters + achievements + shopItems}`);

  await client.end();
}

main().catch(console.error);
