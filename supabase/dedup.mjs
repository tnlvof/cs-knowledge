import { Client } from 'pg';

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
  console.log('Connected!\n');

  // 현재 총 문제 수
  const { rows: before } = await client.query('SELECT count(*) as cnt FROM questions');
  console.log(`중복 제거 전 총 문제 수: ${before[0].cnt}`);

  // 중복 현황 확인 (question_text 기준)
  const { rows: dupStats } = await client.query(`
    SELECT count(*) as dup_groups, sum(cnt - 1) as dup_count
    FROM (
      SELECT question_text, count(*) as cnt
      FROM questions
      GROUP BY question_text
      HAVING count(*) > 1
    ) sub
  `);
  console.log(`중복 그룹 수: ${dupStats[0].dup_groups}`);
  console.log(`삭제 대상 중복 행 수: ${dupStats[0].dup_count}`);

  // 중복 제거 - question_text가 같은 행 중 id가 더 큰 것을 삭제
  const { rowCount } = await client.query(`
    DELETE FROM questions a
    USING questions b
    WHERE a.id > b.id
      AND a.question_text = b.question_text
  `);
  console.log(`\n삭제된 행 수: ${rowCount}`);

  // 제거 후 총 문제 수
  const { rows: after } = await client.query('SELECT count(*) as cnt FROM questions');
  console.log(`중복 제거 후 총 문제 수: ${after[0].cnt}`);

  // 카테고리별 문제 수
  const { rows: cats } = await client.query(`
    SELECT category, count(*) as cnt
    FROM questions
    GROUP BY category
    ORDER BY category
  `);
  console.log('\n카테고리별 문제 수:');
  for (const r of cats) {
    console.log(`  ${r.category}: ${r.cnt}`);
  }

  // 난이도별 문제 수
  const { rows: diffs } = await client.query(`
    SELECT difficulty, count(*) as cnt
    FROM questions
    GROUP BY difficulty
    ORDER BY difficulty
  `);
  console.log('\n난이도별 문제 수:');
  for (const r of diffs) {
    console.log(`  난이도 ${r.difficulty}: ${r.cnt}`);
  }

  await client.end();
}

main().catch(console.error);
