import { createClient } from '@supabase/supabase-js';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

const supabaseUrl = 'https://aoqavvykgzhdpnojyhrw.supabase.co';
const envContent = readFileSync(join(__dirname, '..', '.env.local'), 'utf-8');
const supabaseServiceKey = envContent
  .split('\n')
  .find(l => l.startsWith('SUPABASE_SERVICE_ROLE_KEY='))
  ?.split('=')[1]
  ?.trim();

if (!supabaseServiceKey) {
  console.error('SUPABASE_SERVICE_ROLE_KEY not found in .env.local');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: { autoRefreshToken: false, persistSession: false }
});

function extractTuple(sql, startPos) {
  if (sql[startPos] !== '(') return null;
  let depth = 0;
  let i = startPos;
  let inString = false;

  while (i < sql.length) {
    const ch = sql[i];
    if (inString) {
      if (ch === "'" && sql[i + 1] === "'") {
        i += 2; continue;
      }
      if (ch === "'") inString = false;
    } else {
      if (ch === "'") inString = true;
      else if (ch === '(') depth++;
      else if (ch === ')') {
        depth--;
        if (depth === 0) {
          return { content: sql.slice(startPos + 1, i), end: i };
        }
      }
    }
    i++;
  }
  return null;
}

function parseTupleValues(content) {
  const values = [];
  let current = '';
  let inString = false;
  let inArray = false;
  let depth = 0;

  for (let i = 0; i < content.length; i++) {
    const ch = content[i];

    if (inString) {
      if (ch === "'" && content[i + 1] === "'") {
        current += "'";
        i++;
        continue;
      }
      if (ch === "'") {
        inString = false;
        current += ch;
        continue;
      }
      current += ch;
    } else if (inArray) {
      current += ch;
      if (ch === ']') { inArray = false; }
    } else {
      if (ch === "'") {
        inString = true;
        current += ch;
      } else if (ch === 'A' && content.slice(i, i + 5) === 'ARRAY') {
        inArray = true;
        current += 'ARRAY';
        i += 4;
      } else if (ch === '(') {
        depth++;
        current += ch;
      } else if (ch === ')') {
        depth--;
        current += ch;
      } else if (ch === ',' && depth === 0) {
        values.push(current.trim());
        current = '';
      } else {
        current += ch;
      }
    }
  }
  if (current.trim()) values.push(current.trim());

  return values.map(v => {
    v = v.trim();
    if (v === 'NULL') return null;
    if (v.startsWith("'") && v.endsWith("'")) {
      return v.slice(1, -1).replace(/''/g, "'");
    }
    if (v.startsWith('ARRAY[')) {
      const inner = v.slice(6, -1);
      const items = [];
      let inStr = false;
      let item = '';
      for (let j = 0; j < inner.length; j++) {
        if (inStr) {
          if (inner[j] === "'" && inner[j+1] === "'") { item += "'"; j++; continue; }
          if (inner[j] === "'") { inStr = false; continue; }
          item += inner[j];
        } else {
          if (inner[j] === "'") { inStr = true; continue; }
          if (inner[j] === ',') { items.push(item.trim()); item = ''; continue; }
          item += inner[j];
        }
      }
      if (item.trim()) items.push(item.trim());
      return items;
    }
    if (!isNaN(v) && v !== '') return Number(v);
    return v;
  });
}

function parseSQLInserts(sql, tableName) {
  const rows = [];
  const insertRegex = new RegExp(`INSERT INTO ${tableName}\\s*\\(([^)]+)\\)\\s*VALUES\\s*`, 'gi');
  let match;

  while ((match = insertRegex.exec(sql)) !== null) {
    const columns = match[1].split(',').map(c => c.trim());
    let pos = match.index + match[0].length;

    while (pos < sql.length) {
      const remaining = sql.slice(pos);
      const nextParen = remaining.search(/\(/);
      if (nextParen === -1) break;

      const nextInsert = remaining.search(/INSERT INTO/i);
      if (nextInsert !== -1 && nextInsert < nextParen) break;

      pos += nextParen;

      const tuple = extractTuple(sql, pos);
      if (!tuple) break;

      const values = parseTupleValues(tuple.content);
      if (values.length === columns.length) {
        const row = {};
        columns.forEach((col, i) => {
          row[col] = values[i];
        });
        rows.push(row);
      }

      pos = tuple.end + 1;

      const afterTuple = sql.slice(pos).match(/^\s*([,;])/);
      if (!afterTuple || afterTuple[1] === ';') break;
      pos += afterTuple[0].length;
    }
  }

  return rows;
}

async function seedTable(sql, tableName, label) {
  console.log(`\n--- ${label} ---`);
  const rows = parseSQLInserts(sql, tableName);
  console.log(`Parsed ${rows.length} rows`);

  if (rows.length === 0) {
    console.log('No rows found, skipping.');
    return 0;
  }

  const batchSize = 50;
  let inserted = 0;

  for (let i = 0; i < rows.length; i += batchSize) {
    const batch = rows.slice(i, i + batchSize);
    const { data, error } = await supabase.from(tableName).insert(batch).select('id');

    if (error) {
      console.error(`Error at batch ${Math.floor(i/batchSize) + 1}:`, error.message);
      for (const row of batch) {
        const { error: singleError } = await supabase.from(tableName).insert(row);
        if (singleError) {
          console.error(`  Failed:`, row.name || row.question_text?.slice(0, 40) || row.code, '-', singleError.message);
        } else {
          inserted++;
        }
      }
    } else {
      inserted += batch.length;
      console.log(`  Batch ${Math.floor(i/batchSize) + 1}: ${batch.length} rows inserted`);
    }
  }

  console.log(`Total inserted: ${inserted}/${rows.length}`);
  return inserted;
}

async function main() {
  console.log('=== CS Knowledge Seed Data ===\n');

  const questionFiles = [
    'seed-questions-1.sql',
    'seed-questions-2.sql',
    'seed-questions-3.sql',
    'seed-questions-4.sql',
  ];

  let totalQuestions = 0;

  for (const file of questionFiles) {
    const sql = readFileSync(join(__dirname, file), 'utf-8');
    const count = await seedTable(sql, 'questions', `Questions: ${file}`);
    totalQuestions += count;
  }

  const gamedataSql = readFileSync(join(__dirname, 'seed-gamedata.sql'), 'utf-8');

  const monsters = await seedTable(gamedataSql, 'monsters', 'Monsters');
  const achievements = await seedTable(gamedataSql, 'achievements', 'Achievements');
  const shopItems = await seedTable(gamedataSql, 'shop_items', 'Shop Items');

  console.log('\n=== SUMMARY ===');
  console.log(`Questions: ${totalQuestions}`);
  console.log(`Monsters: ${monsters}`);
  console.log(`Achievements: ${achievements}`);
  console.log(`Shop Items: ${shopItems}`);
  console.log(`Total: ${totalQuestions + monsters + achievements + shopItems}`);
}

main().catch(console.error);
