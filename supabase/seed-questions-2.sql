-- =====================================================
-- IT 서비스 운영 퀴즈 시드 데이터 - 파트 2
-- 생성일: 2024
-- =====================================================
-- 문제 수 요약:
--   Database: 50문제
--     - 난이도1 (입문): 15문제
--     - 난이도2 (주니어): 15문제
--     - 난이도3 (시니어): 12문제
--     - 난이도4 (리드): 8문제
--   Deployment/CI-CD: 50문제
--     - 난이도1 (입문): 15문제
--     - 난이도2 (주니어): 15문제
--     - 난이도3 (시니어): 12문제
--     - 난이도4 (리드): 8문제
-- 총: 100문제
-- =====================================================

-- =====================================================
-- DATABASE 분야 (50문제)
-- =====================================================

-- 난이도 1 (입문) - 15문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'RDBMS 핵심 개념', 1, 1, 25,
'기본키(Primary Key)란 무엇이며 어떤 특성을 가지고 있나요?',
'기본키는 테이블에서 각 행을 고유하게 식별하는 열 또는 열의 조합입니다. NULL 값을 가질 수 없고 테이블 내에서 유일해야 합니다.',
ARRAY['Primary Key', '기본키', '고유 식별', 'NULL 불가', '유일성'],
'기본키는 관계형 데이터베이스에서 데이터 무결성을 보장하는 핵심 요소입니다. 자동 증가(AUTO_INCREMENT), UUID 등의 방식으로 생성할 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'RDBMS 핵심 개념', 1, 1, 25,
'외래키(Foreign Key)의 역할은 무엇인가요?',
'외래키는 다른 테이블의 기본키를 참조하여 테이블 간의 관계를 정의합니다. 참조 무결성을 보장하는 역할을 합니다.',
ARRAY['Foreign Key', '외래키', '참조', '관계', '무결성'],
'외래키를 사용하면 부모 테이블에 없는 값을 자식 테이블에 삽입할 수 없으며, ON DELETE CASCADE 등의 옵션으로 연관 데이터 처리를 자동화할 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'RDBMS 핵심 개념', 1, 1, 25,
'정규화(Normalization)를 하는 이유는 무엇인가요?',
'데이터 중복을 제거하고, 삽입/수정/삭제 이상(Anomaly)을 방지하며, 데이터 무결성을 유지하기 위함입니다.',
ARRAY['정규화', 'Normalization', '중복 제거', '이상', '무결성'],
'정규화는 1NF부터 5NF까지 단계가 있으며, 일반적으로 3NF 또는 BCNF까지 적용합니다. 과도한 정규화는 조인 비용을 증가시킬 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '인덱스', 1, 1, 25,
'인덱스를 사용하면 왜 조회 속도가 빨라지나요?',
'전체 테이블을 스캔(Full Table Scan)하지 않고, 정렬된 인덱스에서 이진 탐색처럼 빠르게 데이터 위치를 찾을 수 있기 때문입니다.',
ARRAY['인덱스', 'Index', '이진 탐색', 'Full Table Scan', '조회 속도'],
'인덱스는 책의 색인과 같은 역할을 합니다. B+Tree 구조를 사용하여 O(log n) 시간 복잡도로 데이터를 찾을 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '인덱스', 1, 1, 25,
'인덱스의 단점은 무엇인가요?',
'추가 저장 공간이 필요하고, INSERT/UPDATE/DELETE 시 인덱스도 갱신해야 하므로 쓰기 성능이 저하됩니다.',
ARRAY['인덱스', '저장 공간', '쓰기 성능', 'INSERT', 'UPDATE'],
'인덱스는 조회 성능을 높이는 대신 쓰기 성능을 희생합니다. 따라서 읽기가 많은 테이블에 적합하며, 과도한 인덱스 생성은 피해야 합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '실행계획', 1, 1, 25,
'EXPLAIN 명령어는 왜 사용하나요?',
'쿼리가 어떻게 실행될지 미리 확인하여 성능 문제를 진단하고 최적화 방향을 결정하기 위함입니다.',
ARRAY['EXPLAIN', '실행계획', '성능', '최적화', '진단'],
'EXPLAIN을 사용하면 어떤 인덱스가 사용되는지, 어떤 조인 방식이 선택되는지 등을 확인할 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '트랜잭션', 1, 1, 25,
'트랜잭션이 필요한 이유는 무엇인가요?',
'여러 작업을 하나의 단위로 처리하여, 중간에 실패해도 데이터 정합성을 유지하기 위함입니다. 예를 들어 계좌이체에서 출금만 되고 입금이 안 되는 상황을 방지합니다.',
ARRAY['트랜잭션', 'Transaction', '정합성', '원자성', '계좌이체'],
'트랜잭션은 ACID 속성(원자성, 일관성, 격리성, 지속성)을 통해 데이터 무결성을 보장합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '트랜잭션', 1, 1, 25,
'COMMIT과 ROLLBACK의 차이는 무엇인가요?',
'COMMIT은 트랜잭션의 변경사항을 영구적으로 저장합니다. ROLLBACK은 트랜잭션의 변경사항을 취소하고 이전 상태로 되돌립니다.',
ARRAY['COMMIT', 'ROLLBACK', '트랜잭션', '저장', '취소'],
'트랜잭션 중 오류가 발생하면 ROLLBACK으로 이전 상태로 복구하고, 모든 작업이 성공하면 COMMIT으로 확정합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '잠금', 1, 1, 25,
'공유 잠금(Shared Lock)과 배타 잠금(Exclusive Lock)의 차이는 무엇인가요?',
'공유 잠금은 읽기용으로 여러 트랜잭션이 동시에 획득 가능합니다. 배타 잠금은 쓰기용으로 하나의 트랜잭션만 획득 가능하며 다른 모든 잠금을 차단합니다.',
ARRAY['공유 잠금', '배타 잠금', 'Shared Lock', 'Exclusive Lock', '읽기', '쓰기'],
'공유 잠금끼리는 호환되지만, 배타 잠금은 다른 어떤 잠금과도 호환되지 않습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '복제', 1, 1, 25,
'데이터베이스 복제(Replication)를 사용하는 이유는 무엇인가요?',
'고가용성(Primary 장애 시 Replica로 전환), 읽기 성능 향상(읽기 쿼리 분산), 재해 복구(지역 분산 복제), 백업(Replica에서 백업 수행)을 위해 사용합니다.',
ARRAY['복제', 'Replication', '고가용성', '읽기 분산', '재해 복구'],
'Primary-Replica 구조가 가장 일반적이며, Primary는 쓰기를 처리하고 Replica는 읽기를 분담합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '샤딩', 1, 1, 25,
'샤딩(Sharding)이 필요한 이유는 무엇인가요?',
'단일 데이터베이스가 저장할 수 있는 데이터양과 처리할 수 있는 트래픽에 한계가 있기 때문입니다. 샤딩을 통해 수평 확장으로 이를 극복합니다.',
ARRAY['샤딩', 'Sharding', '수평 확장', '대용량', '트래픽'],
'샤딩은 데이터를 여러 데이터베이스 서버에 분산 저장하는 기법으로, 샤드 키를 기준으로 데이터를 분배합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '파티셔닝', 1, 1, 25,
'파티셔닝(Partitioning)을 하는 이유는 무엇인가요?',
'대용량 테이블의 쿼리 성능 향상, 관리 용이성(파티션별 백업/삭제), 오래된 데이터 쉽게 아카이빙, 병렬 처리가 가능해지기 때문입니다.',
ARRAY['파티셔닝', 'Partitioning', '성능', '관리', '아카이빙'],
'파티셔닝은 단일 데이터베이스 내에서 테이블을 물리적 조각으로 분할하며, Range, Hash, List 파티션이 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '백업 및 복구', 1, 1, 25,
'데이터베이스 백업이 필요한 이유는 무엇인가요?',
'하드웨어 장애, 소프트웨어 버그, 휴먼 에러, 랜섬웨어 등으로 인한 데이터 손실을 복구하기 위함입니다.',
ARRAY['백업', 'Backup', '장애', '복구', '데이터 손실'],
'백업에는 논리적 백업(pg_dump)과 물리적 백업(pg_basebackup)이 있으며, 정기적인 복구 테스트가 중요합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '커넥션 풀링', 1, 1, 25,
'커넥션 풀링(Connection Pooling)이 필요한 이유는 무엇인가요?',
'DB 연결 생성은 비용이 높습니다(TCP 핸드셰이크, 인증, 메모리 할당). 매 요청마다 연결을 만들면 성능이 저하되고 DB 리소스가 고갈됩니다.',
ARRAY['커넥션 풀링', 'Connection Pooling', '연결', '성능', '리소스'],
'커넥션 풀은 미리 연결을 생성하여 재사용함으로써 연결 생성 오버헤드를 줄입니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'NoSQL', 1, 1, 25,
'NoSQL이 RDBMS와 다른 주요 특징은 무엇인가요?',
'스키마가 유연하고, 조인 없이 비정규화된 데이터를 저장하며, 수평 확장이 용이하고, ACID 대신 BASE 특성을 가지는 경우가 많습니다.',
ARRAY['NoSQL', 'RDBMS', '스키마', '수평 확장', 'BASE'],
'NoSQL에는 문서형(MongoDB), 키-값(Redis), 컬럼형, 그래프형 등 다양한 유형이 있습니다.',
'docs/03-database.md');

-- 난이도 2 (주니어) - 15문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'RDBMS 핵심 개념', 2, 10, 50,
'반정규화(Denormalization)는 언제 수행하나요?',
'조회 성능이 중요하고 JOIN이 빈번할 때, 의도적으로 중복을 허용하여 조회 속도를 높입니다. 단, 데이터 정합성 관리 비용이 증가합니다.',
ARRAY['반정규화', 'Denormalization', 'JOIN', '조회 성능', '중복'],
'정규화와 반정규화는 트레이드오프 관계입니다. 쓰기가 많으면 정규화, 읽기가 많으면 반정규화를 고려합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '인덱스', 2, 10, 50,
'복합 인덱스(Composite Index)에서 컬럼 순서가 중요한 이유는 무엇인가요?',
'인덱스는 첫 번째 컬럼부터 순서대로 정렬됩니다. (A, B, C) 인덱스에서 B나 C만으로 검색하면 인덱스를 활용할 수 없습니다.',
ARRAY['복합 인덱스', 'Composite Index', '컬럼 순서', '정렬', '활용'],
'복합 인덱스 (A, B, C)에서는 A 조건만, (A, B) 조건, (A, B, C) 조건은 활용 가능하지만, B만 또는 C만 있는 조건은 활용 불가합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '인덱스', 2, 10, 50,
'카디널리티(Cardinality)란 무엇이며 인덱스 효과에 어떤 영향을 미치나요?',
'카디널리티는 컬럼의 고유값 개수입니다. 카디널리티가 높을수록(중복이 적을수록) 인덱스 효과가 좋습니다. 예: 주민번호(높음), 성별(낮음).',
ARRAY['카디널리티', 'Cardinality', '고유값', '인덱스', '선택도'],
'선택도(Selectivity) = 고유값 수 / 전체 행 수로 계산되며, 1에 가까울수록 인덱스에 적합합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '실행계획', 2, 10, 50,
'EXPLAIN과 EXPLAIN ANALYZE의 차이는 무엇인가요?',
'EXPLAIN은 예상 실행계획만 보여주고, EXPLAIN ANALYZE는 실제로 쿼리를 실행하여 실제 시간과 행 수를 보여줍니다.',
ARRAY['EXPLAIN', 'EXPLAIN ANALYZE', '실행계획', '예상', '실제'],
'EXPLAIN ANALYZE는 실제 쿼리를 실행하므로 SELECT가 아닌 쿼리는 주의가 필요합니다. BEGIN/ROLLBACK으로 감싸면 안전합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '트랜잭션', 2, 10, 50,
'Dirty Read란 무엇인가요?',
'다른 트랜잭션이 아직 커밋하지 않은 데이터를 읽는 것입니다. 그 트랜잭션이 롤백하면 잘못된 데이터를 읽은 것이 됩니다.',
ARRAY['Dirty Read', '커밋', '롤백', '격리 수준', '읽기'],
'Dirty Read는 READ UNCOMMITTED 격리 수준에서 발생할 수 있습니다. READ COMMITTED 이상에서는 방지됩니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '트랜잭션', 2, 10, 50,
'Non-repeatable Read와 Phantom Read의 차이는 무엇인가요?',
'Non-repeatable Read는 같은 행을 다시 읽을 때 값이 변경된 것입니다. Phantom Read는 같은 쿼리를 다시 실행할 때 새로운 행이 추가/삭제된 것입니다.',
ARRAY['Non-repeatable Read', 'Phantom Read', '격리 수준', '행', '변경'],
'REPEATABLE READ는 Non-repeatable Read를 방지하고, SERIALIZABLE은 Phantom Read까지 방지합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '잠금', 2, 10, 50,
'SELECT FOR UPDATE는 언제 사용하나요?',
'읽은 데이터를 이후 수정할 예정일 때 사용합니다. 다른 트랜잭션이 같은 행을 수정하지 못하게 미리 잠급니다. 예: 재고 확인 후 차감.',
ARRAY['SELECT FOR UPDATE', '잠금', '수정', '재고', '배타 잠금'],
'SELECT FOR UPDATE는 배타 잠금을 획득하므로 다른 트랜잭션의 읽기/쓰기를 블로킹합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '복제', 2, 10, 50,
'동기 복제와 비동기 복제의 차이는 무엇인가요?',
'동기 복제는 Replica에 적용될 때까지 커밋을 대기하여 데이터 손실이 없습니다. 비동기 복제는 즉시 커밋하여 빠르지만 데이터 손실 위험이 있습니다.',
ARRAY['동기 복제', '비동기 복제', '커밋', '데이터 손실', 'Replica'],
'동기 복제는 일관성을 보장하지만 지연이 있고, 비동기 복제는 빠르지만 장애 시 최근 데이터가 손실될 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '복제', 2, 10, 50,
'복제 지연(Replication Lag)이란 무엇인가요?',
'Primary의 변경사항이 Replica에 적용되기까지의 시간 차이입니다. 비동기 복제에서 발생하며, 읽기 일관성 문제를 야기할 수 있습니다.',
ARRAY['복제 지연', 'Replication Lag', 'Primary', 'Replica', '일관성'],
'복제 지연이 발생하면 쓰기 직후 Replica에서 읽을 때 최신 데이터가 보이지 않을 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '샤딩', 2, 10, 50,
'Range 샤딩과 Hash 샤딩의 차이점은 무엇인가요?',
'Range 샤딩은 범위 쿼리에 효율적이지만 핫스팟이 발생할 수 있습니다. Hash 샤딩은 데이터를 균등 분배하지만 범위 쿼리가 모든 샤드를 조회해야 합니다.',
ARRAY['Range 샤딩', 'Hash 샤딩', '범위 쿼리', '핫스팟', '균등 분배'],
'시간 기반 Range 샤딩은 최근 데이터에 쓰기가 집중되어 핫스팟이 발생하기 쉽습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '백업 및 복구', 2, 10, 50,
'논리적 백업과 물리적 백업의 차이는 무엇인가요?',
'논리적 백업은 SQL 문장으로 데이터를 내보냅니다(pg_dump). 물리적 백업은 데이터 파일을 직접 복사합니다(pg_basebackup). 물리적 백업이 대용량에 빠릅니다.',
ARRAY['논리적 백업', '물리적 백업', 'pg_dump', 'pg_basebackup', 'SQL'],
'논리적 백업은 이식성이 좋고 특정 테이블만 백업 가능하며, 물리적 백업은 속도가 빠르고 PITR이 가능합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '커넥션 풀링', 2, 10, 50,
'커넥션 풀의 최적 사이즈는 어떻게 결정하나요?',
'일반적으로 (CPU 코어 수 * 2) + 유효 스핀들 수 공식을 사용합니다. 벤치마크로 검증해야 합니다. 너무 크면 DB 부하 증가, 너무 작으면 대기 발생합니다.',
ARRAY['커넥션 풀', '사이즈', 'CPU 코어', '벤치마크', '대기'],
'HikariCP 문서에서 권장하는 공식이며, 실제 환경에서는 테스트를 통해 최적값을 찾아야 합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'Slow Query', 2, 10, 50,
'N+1 쿼리 문제란 무엇인가요?',
'목록 조회 후 각 항목마다 추가 쿼리를 실행하는 문제입니다. 예: 주문 10건 조회 후 각 주문의 상품 조회 = 11번 쿼리. JOIN이나 배치 로딩으로 해결합니다.',
ARRAY['N+1', '쿼리', 'JOIN', '배치 로딩', '성능'],
'ORM 사용 시 자주 발생하며, Eager Loading 또는 명시적 JOIN으로 해결할 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'NoSQL', 2, 10, 50,
'Redis의 주요 자료구조에는 어떤 것들이 있나요?',
'String(단순 값), List(큐/스택), Set(집합 연산), Sorted Set(순위), Hash(필드-값 맵), Stream(로그)이 있습니다. 용도에 맞게 선택합니다.',
ARRAY['Redis', 'String', 'List', 'Set', 'Sorted Set', 'Hash'],
'각 자료구조는 특정 용도에 최적화되어 있습니다. 예: Sorted Set은 리더보드, List는 메시지 큐에 적합합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '캐싱', 2, 10, 50,
'Cache-Aside 패턴의 동작 방식을 설명해주세요.',
'1) 캐시 조회 2) 미스 시 DB 조회 3) 결과를 캐시에 저장 4) 반환. 쓰기 시 DB 업데이트 후 캐시 무효화합니다. 가장 일반적인 캐싱 패턴입니다.',
ARRAY['Cache-Aside', '캐시', 'DB 조회', '무효화', '패턴'],
'애플리케이션이 캐시와 DB를 직접 관리하므로 유연하지만 코드 복잡도가 증가할 수 있습니다.',
'docs/03-database.md');

-- 난이도 3 (시니어) - 12문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '인덱스', 3, 30, 75,
'커버링 인덱스(Covering Index)란 무엇이며 어떤 장점이 있나요?',
'쿼리에서 필요한 모든 컬럼이 인덱스에 포함되어, 테이블에 접근하지 않고 인덱스만으로 쿼리를 처리할 수 있는 인덱스입니다. I/O를 크게 줄입니다.',
ARRAY['커버링 인덱스', 'Covering Index', 'I/O', '테이블 접근', '인덱스 온리'],
'Index Only Scan이 발생하며, 특히 대용량 테이블에서 조회 성능을 크게 향상시킬 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '실행계획', 3, 30, 75,
'Hash Join의 동작 방식을 설명해주세요.',
'작은 테이블로 해시 테이블을 만들고(Build), 큰 테이블을 스캔하며 해시 테이블과 매칭(Probe)합니다. 동등 조인에서 대량 데이터에 효율적입니다.',
ARRAY['Hash Join', '해시 테이블', 'Build', 'Probe', '동등 조인'],
'메모리에 해시 테이블이 들어가야 효율적이며, 범위 조인에는 사용할 수 없습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '트랜잭션', 3, 30, 75,
'MVCC(Multi-Version Concurrency Control)는 어떻게 동작하나요?',
'데이터 변경 시 새 버전을 생성하고 이전 버전을 유지합니다. 각 트랜잭션은 시작 시점의 스냅샷을 보며, 읽기와 쓰기가 서로 블로킹하지 않습니다.',
ARRAY['MVCC', '버전', '스냅샷', '블로킹', '동시성'],
'PostgreSQL은 xmin/xmax로 행 버전을 관리하며, VACUUM이 오래된 버전을 정리합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '트랜잭션', 3, 30, 75,
'데드락(Deadlock)은 어떻게 발생하며 어떻게 해결하나요?',
'두 트랜잭션이 서로 상대방이 잡고 있는 잠금을 기다릴 때 발생합니다. 데이터베이스가 자동 감지하여 한 트랜잭션을 롤백시킵니다. 예방하려면 잠금 순서를 일관되게 하거나 타임아웃을 설정합니다.',
ARRAY['데드락', 'Deadlock', '잠금', '롤백', '타임아웃'],
'예: T1이 A를 잠그고 B를 기다림, T2가 B를 잠그고 A를 기다리면 데드락이 발생합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '잠금', 3, 30, 75,
'낙관적 잠금(Optimistic Locking)과 비관적 잠금(Pessimistic Locking)의 선택 기준은 무엇인가요?',
'충돌이 적으면 낙관적 잠금(버전 체크), 충돌이 많으면 비관적 잠금(SELECT FOR UPDATE)이 효율적입니다. 낙관적 잠금은 재시도 로직이 필요합니다.',
ARRAY['낙관적 잠금', '비관적 잠금', '충돌', '버전', 'SELECT FOR UPDATE'],
'낙관적 잠금은 version 컬럼으로 구현하며, UPDATE 시 version을 체크하여 충돌을 감지합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '복제', 3, 30, 75,
'복제 지연에 어떻게 대응하나요?',
'1) 쓰기 후 읽기를 Primary에서 수행 2) 버전 또는 타임스탬프로 일관성 확인 3) 복제 지연 모니터링 및 알림 4) 지연이 심하면 해당 Replica를 제외합니다.',
ARRAY['복제 지연', 'Primary', 'Replica', '일관성', '모니터링'],
'Read-your-writes 일관성을 위해 쓰기 직후에는 Primary에서 읽도록 라우팅하는 것이 일반적입니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '샤딩', 3, 30, 75,
'Consistent Hashing이란 무엇인가요?',
'해시 링에 샤드를 배치하고, 키의 해시값에서 시계방향으로 가장 가까운 샤드에 할당합니다. 샤드 추가/제거 시 영향받는 데이터가 최소화됩니다.',
ARRAY['Consistent Hashing', '해시 링', '샤드', '리밸런싱', '최소화'],
'일반 해시와 달리 노드 추가/제거 시 전체 데이터가 아닌 일부만 재배치되어 리밸런싱 비용이 낮습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '백업 및 복구', 3, 30, 75,
'PITR(Point-In-Time Recovery)이란 무엇인가요?',
'특정 시점으로 데이터베이스를 복구하는 기능입니다. 기본 백업 + WAL 아카이브를 사용하여 장애 발생 직전이나 잘못된 쿼리 실행 전 시점으로 복구합니다.',
ARRAY['PITR', 'Point-In-Time Recovery', 'WAL', '아카이브', '복구'],
'실수로 테이블을 DROP한 경우 등에서 해당 시점 직전으로 복구할 수 있어 매우 유용합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '커넥션 풀링', 3, 30, 75,
'PgBouncer의 풀링 모드 종류와 특징을 설명해주세요.',
'Session(세션 동안 연결 유지), Transaction(트랜잭션 동안만), Statement(각 쿼리마다)가 있습니다. Transaction 모드가 가장 효율적이지만 Prepared Statement, 세션 변수 등 세션 기능이 제한됩니다.',
ARRAY['PgBouncer', 'Session', 'Transaction', 'Statement', '풀링'],
'Transaction 풀링에서는 LISTEN/NOTIFY, 임시 테이블도 사용할 수 없습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '캐싱', 3, 30, 75,
'Thundering Herd 문제란 무엇이며 어떻게 방지하나요?',
'인기 캐시 키가 만료될 때 동시에 많은 요청이 DB로 몰리는 현상입니다. 방지책: 1) 뮤텍스/락으로 하나의 요청만 DB 조회 2) 만료 전 미리 갱신 3) TTL에 랜덤 지터 추가 4) 스테일 데이터 허용.',
ARRAY['Thundering Herd', '캐시', '만료', '락', 'TTL'],
'Hot key에서 자주 발생하며, 캐시 워밍이나 background refresh 패턴으로 예방할 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '검색엔진', 3, 30, 75,
'Elasticsearch에서 match 쿼리와 term 쿼리의 차이는 무엇인가요?',
'match는 검색어를 분석하여 검색합니다(전문 검색). term은 검색어를 분석 없이 정확히 일치하는 것을 검색합니다(keyword 필드용).',
ARRAY['match', 'term', 'Elasticsearch', '분석', 'keyword'],
'text 필드에는 match, keyword 필드에는 term을 사용하는 것이 일반적입니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '데이터 모델링', 3, 30, 75,
'이력 데이터를 어떻게 관리하나요?',
'1) 별도 이력 테이블 2) 유효 시작/종료일 컬럼 추가 3) 소프트 삭제(deleted_at) 4) 이벤트 소싱. 요구사항에 따라 선택합니다.',
ARRAY['이력', '이력 테이블', '소프트 삭제', '이벤트 소싱', '유효일'],
'감사 로그가 필요한 경우 별도 이력 테이블이, 시점별 조회가 필요하면 유효일 방식이 적합합니다.',
'docs/03-database.md');

-- 난이도 4 (리드) - 8문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'RDBMS 핵심 개념', 4, 50, 100,
'마이크로서비스에서 데이터 모델링 시 고려할 점은 무엇인가요?',
'각 서비스가 독립적인 데이터베이스를 가지므로 서비스 간 조인이 불가능합니다. 이벤트 기반 동기화, 데이터 중복 허용, 결과적 일관성을 고려해야 합니다.',
ARRAY['마이크로서비스', '데이터베이스', '조인', '이벤트', '결과적 일관성'],
'Database per Service 패턴을 따르며, CQRS나 Saga 패턴으로 분산 트랜잭션을 처리합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '인덱스', 4, 50, 100,
'수억 건 테이블에서 인덱스 전략은 어떻게 수립하나요?',
'파티셔닝과 결합하여 파티션별 로컬 인덱스 사용, 부분 인덱스로 핫 데이터만 인덱싱, 커버링 인덱스로 테이블 접근 최소화, 비동기 인덱스 생성(CONCURRENTLY) 활용합니다.',
ARRAY['대규모', '파티셔닝', '부분 인덱스', '커버링 인덱스', 'CONCURRENTLY'],
'인덱스 사용 현황을 모니터링하여 사용하지 않는 인덱스는 정리하고, 쓰기 성능과의 트레이드오프를 고려합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '트랜잭션', 4, 50, 100,
'마이크로서비스에서 분산 트랜잭션을 어떻게 처리하나요?',
'서비스별 로컬 트랜잭션을 사용하고, 서비스 간에는 Saga 패턴(보상 트랜잭션) 또는 이벤트 소싱을 통해 결과적 일관성을 달성합니다.',
ARRAY['분산 트랜잭션', 'Saga', '보상 트랜잭션', '이벤트 소싱', '결과적 일관성'],
'2PC(Two-Phase Commit)는 마이크로서비스 환경에서 확장성과 가용성 문제로 권장되지 않습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '잠금', 4, 50, 100,
'분산 시스템에서 잠금을 어떻게 구현하나요?',
'Redis의 SETNX/Redlock, ZooKeeper의 순차 노드, etcd의 lease를 사용합니다. 네트워크 파티션, 클럭 드리프트를 고려해야 합니다.',
ARRAY['분산 잠금', 'Redlock', 'ZooKeeper', 'etcd', '네트워크 파티션'],
'분산 잠금은 완벽하지 않으며, 펜싱 토큰 등 추가 안전장치가 필요할 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '복제', 4, 50, 100,
'자동 페일오버를 어떻게 구현하나요?',
'Patroni, repmgr 등 HA 솔루션을 사용합니다. 합의 알고리즘(Raft, Paxos)으로 리더 선출, VIP 전환 또는 DNS 업데이트로 연결 전환합니다.',
ARRAY['자동 페일오버', 'Patroni', 'repmgr', 'Raft', 'VIP'],
'스플릿 브레인을 방지하기 위해 쿼럼 기반 의사결정이 중요하며, 홀수 개 노드 구성을 권장합니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '샤딩', 4, 50, 100,
'샤딩 도입 시점은 어떻게 결정하나요?',
'단일 DB 한계에 도달했을 때(디스크, 연결 수, 쿼리 성능) 검토합니다. 샤딩은 복잡도가 높으므로 다른 최적화(읽기 복제본, 캐싱, 쿼리 최적화, 파티셔닝)를 먼저 시도하고 마지막 수단으로 고려합니다.',
ARRAY['샤딩 도입', '한계', '복잡도', '최적화', '파티셔닝'],
'샤딩 없이 확장하는 대안으로 Citus 같은 분산 확장 솔루션도 고려할 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', '백업 및 복구', 4, 50, 100,
'3-2-1 백업 규칙이란 무엇인가요?',
'3개의 데이터 복사본, 2개의 다른 저장 매체, 1개의 오프사이트 보관입니다. 재해 상황에서도 데이터를 복구할 수 있도록 보장합니다.',
ARRAY['3-2-1', '백업', '복사본', '저장 매체', '오프사이트'],
'클라우드 환경에서는 멀티 리전 복제, S3 버저닝 등으로 이 원칙을 구현할 수 있습니다.',
'docs/03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'NoSQL', 4, 50, 100,
'Polyglot Persistence란 무엇인가요?',
'하나의 애플리케이션에서 여러 종류의 데이터베이스를 용도에 맞게 사용하는 것입니다. 예: PostgreSQL(트랜잭션) + Redis(캐시) + Elasticsearch(검색).',
ARRAY['Polyglot Persistence', '다중 데이터베이스', 'PostgreSQL', 'Redis', 'Elasticsearch'],
'각 데이터 저장소의 강점을 활용하지만 운영 복잡도가 증가하므로 신중하게 도입해야 합니다.',
'docs/03-database.md');


-- =====================================================
-- DEPLOYMENT/CI-CD 분야 (50문제)
-- =====================================================

-- 난이도 1 (입문) - 15문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 기초', 1, 1, 25,
'Docker 이미지와 컨테이너의 차이점은 무엇인가요?',
'이미지는 읽기 전용 템플릿이고, 컨테이너는 이미지를 기반으로 실행되는 인스턴스입니다. 이미지는 클래스, 컨테이너는 객체에 비유할 수 있습니다.',
ARRAY['이미지', 'Image', '컨테이너', 'Container', '템플릿'],
'하나의 이미지로 여러 컨테이너를 실행할 수 있으며, 컨테이너는 독립적인 상태를 가집니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 기초', 1, 1, 25,
'Docker가 VM(가상 머신)보다 가벼운 이유는 무엇인가요?',
'Docker는 호스트 OS의 커널을 공유하므로 게스트 OS가 필요 없습니다. VM은 각각 전체 OS를 가상화하므로 리소스 오버헤드가 큽니다.',
ARRAY['Docker', 'VM', '커널', '가상화', '오버헤드'],
'컨테이너는 프로세스 격리 수준의 가상화를 제공하여 빠른 시작과 적은 리소스 사용이 가능합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 최적화', 1, 1, 25,
'alpine 베이스 이미지의 장단점은 무엇인가요?',
'장점은 매우 작은 크기(약 5MB)와 보안 공격 표면 감소입니다. 단점은 musl libc 사용으로 glibc 기반 바이너리 호환성 문제가 발생할 수 있습니다.',
ARRAY['alpine', '베이스 이미지', 'musl', 'glibc', '경량'],
'Python, Node.js 등의 공식 alpine 이미지를 사용하면 이미지 크기를 크게 줄일 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 네트워킹', 1, 1, 25,
'Docker 포트 매핑 -p 8080:80의 의미는 무엇인가요?',
'호스트의 8080 포트로 들어온 트래픽을 컨테이너의 80 포트로 전달합니다.',
ARRAY['포트 매핑', '-p', '호스트', '컨테이너', '트래픽'],
'형식은 -p [호스트포트]:[컨테이너포트]이며, 호스트 IP를 지정할 수도 있습니다(-p 127.0.0.1:8080:80).',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker Compose', 1, 1, 25,
'docker-compose up -d 명령어의 의미는 무엇인가요?',
'정의된 모든 서비스를 백그라운드(-d, detached)에서 시작합니다.',
ARRAY['docker-compose', 'up', '-d', '백그라운드', '서비스'],
'-d 옵션 없이 실행하면 포그라운드에서 실행되어 로그가 터미널에 출력됩니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 보안', 1, 1, 25,
'컨테이너를 root로 실행하면 안 되는 이유는 무엇인가요?',
'컨테이너 탈출 시 호스트 root 권한을 얻을 수 있습니다. 최소 권한 원칙을 적용해야 합니다.',
ARRAY['root', '보안', '권한', '컨테이너 탈출', 'non-root'],
'Dockerfile에서 USER 지시어로 non-root 사용자를 지정하여 실행해야 합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 핵심 개념', 1, 1, 25,
'Kubernetes에서 Pod란 무엇인가요?',
'하나 이상의 컨테이너를 포함하는 최소 배포 단위입니다. 같은 Pod 내 컨테이너는 네트워크와 스토리지를 공유합니다.',
ARRAY['Pod', '컨테이너', '배포 단위', 'Kubernetes', '공유'],
'일반적으로 1 Pod = 1 컨테이너 권장이며, 사이드카 패턴 등에서 여러 컨테이너를 넣기도 합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 서비스', 1, 1, 25,
'Kubernetes Service가 필요한 이유는 무엇인가요?',
'Pod IP는 재시작 시 변경됩니다. Service는 레이블 셀렉터로 Pod를 선택하고 안정적인 DNS 이름과 IP를 제공합니다.',
ARRAY['Service', 'Pod', 'IP', 'DNS', '레이블'],
'Service 유형에는 ClusterIP, NodePort, LoadBalancer가 있으며 용도에 따라 선택합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 설정 관리', 1, 1, 25,
'ConfigMap과 Secret의 주요 차이는 무엇인가요?',
'ConfigMap은 비밀이 아닌 설정 데이터를 저장합니다. Secret은 비밀번호, 토큰 등 민감 정보를 저장하며 base64 인코딩되고 권한 관리가 별도로 가능합니다.',
ARRAY['ConfigMap', 'Secret', '설정', '민감 정보', 'base64'],
'Secret은 암호화가 아닌 인코딩이므로 etcd 암호화나 외부 비밀 관리자 연동을 권장합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'CI/CD 파이프라인', 1, 1, 25,
'CI(Continuous Integration)의 핵심 원칙은 무엇인가요?',
'자주 통합(하루에 여러 번), 모든 커밋에 자동 빌드/테스트, 빠른 피드백, 실패 시 즉시 수정입니다.',
ARRAY['CI', 'Continuous Integration', '통합', '자동화', '피드백'],
'CI를 통해 통합 문제를 조기에 발견하고 품질을 유지할 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'CI/CD 파이프라인', 1, 1, 25,
'Continuous Delivery와 Continuous Deployment의 차이는 무엇인가요?',
'Delivery는 프로덕션 배포 전 수동 승인이 필요합니다. Deployment는 모든 변경이 자동으로 프로덕션까지 배포됩니다.',
ARRAY['Continuous Delivery', 'Continuous Deployment', '수동 승인', '자동 배포', '프로덕션'],
'대부분의 조직은 Continuous Delivery를 선택하며, 충분한 자동화 테스트가 있으면 Deployment로 전환합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', '배포 전략', 1, 1, 25,
'Rolling Update 배포 전략의 장점은 무엇인가요?',
'무중단 배포가 가능하고, 점진적 교체로 위험이 감소하며, 문제 시 빠른 롤백이 가능합니다.',
ARRAY['Rolling Update', '무중단', '점진적', '롤백', '배포'],
'Kubernetes의 기본 배포 전략이며, maxSurge와 maxUnavailable로 속도를 제어합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'GitOps', 1, 1, 25,
'GitOps가 기존 CI/CD와 다른 점은 무엇인가요?',
'Push 기반(CI가 클러스터에 배포) 대신 Pull 기반(클러스터가 Git에서 원하는 상태를 가져옴)입니다. 클러스터 자격증명을 CI에 노출하지 않습니다.',
ARRAY['GitOps', 'Push', 'Pull', 'Git', '자격증명'],
'Git을 단일 진실 공급원으로 사용하여 감사 추적, 쉬운 롤백, 재해 복구가 용이합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'IaC', 1, 1, 25,
'Infrastructure as Code(IaC)의 핵심 이점은 무엇인가요?',
'재현 가능한 인프라, 버전 관리, 코드 리뷰, 자동화된 프로비저닝, 환경 일관성, 문서화입니다.',
ARRAY['IaC', 'Infrastructure as Code', '재현', '버전 관리', '자동화'],
'Terraform, Pulumi, CloudFormation 등의 도구로 인프라를 코드로 관리합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', '롤백', 1, 1, 25,
'Kubernetes에서 롤백이 빠른 이유는 무엇인가요?',
'이전 ReplicaSet이 보존되어 있어 새로 빌드/배포 없이 이전 Pod로 즉시 전환이 가능합니다.',
ARRAY['롤백', 'ReplicaSet', 'Pod', 'Kubernetes', '전환'],
'revisionHistoryLimit으로 보관할 ReplicaSet 수를 설정할 수 있습니다.',
'docs/04-deployment-cicd.md');

-- 난이도 2 (주니어) - 15문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 기초', 2, 10, 50,
'Dockerfile에서 CMD와 ENTRYPOINT의 차이점은 무엇인가요?',
'ENTRYPOINT는 컨테이너의 메인 실행 파일을 정의하고, CMD는 기본 인자를 제공합니다. docker run 시 인자를 주면 CMD는 대체되지만 ENTRYPOINT는 유지됩니다.',
ARRAY['CMD', 'ENTRYPOINT', 'Dockerfile', '인자', '실행'],
'ENTRYPOINT를 실행 파일로, CMD를 기본 인자로 조합하여 사용하는 것이 일반적입니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 최적화', 2, 10, 50,
'멀티스테이지 빌드(Multi-stage Build)의 이점은 무엇인가요?',
'빌드 도구(컴파일러, npm 등)가 최종 이미지에 포함되지 않아 이미지 크기가 작아지고 보안이 향상됩니다.',
ARRAY['멀티스테이지', 'Multi-stage', '빌드', '이미지 크기', '보안'],
'FROM 지시어를 여러 번 사용하여 빌드 단계와 실행 단계를 분리합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 최적화', 2, 10, 50,
'Docker 레이어 캐시를 효율적으로 활용하려면 어떻게 해야 하나요?',
'자주 변경되는 파일(소스코드)은 나중에 COPY하고, 잘 변경되지 않는 파일(package.json)은 먼저 COPY하여 의존성 설치 레이어를 캐시합니다.',
ARRAY['레이어 캐시', 'COPY', '의존성', '빌드', '효율'],
'Dockerfile 명령어 순서를 최적화하면 빌드 시간을 크게 단축할 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker Compose', 2, 10, 50,
'depends_on이 보장하는 것과 보장하지 않는 것은 무엇인가요?',
'컨테이너 시작 순서는 보장하지만, 애플리케이션 준비 상태는 보장하지 않습니다. healthcheck와 condition을 사용해야 합니다.',
ARRAY['depends_on', '시작 순서', 'healthcheck', 'condition', '준비'],
'depends_on + condition: service_healthy 조합으로 의존 서비스가 준비될 때까지 대기할 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 보안', 2, 10, 50,
'이미지 스캐닝을 CI에 통합하는 이유는 무엇인가요?',
'취약한 이미지가 프로덕션에 배포되기 전에 차단할 수 있습니다. 빌드 파이프라인에서 스캔 실패 시 배포를 중단합니다.',
ARRAY['이미지 스캐닝', 'CI', '취약점', '차단', 'trivy'],
'trivy, clair 등의 도구로 CVE 취약점을 검사하고 심각도에 따라 빌드를 실패시킵니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 핵심 개념', 2, 10, 50,
'Deployment와 StatefulSet의 선택 기준은 무엇인가요?',
'Deployment는 상태 없는 애플리케이션(웹 서버)에 사용합니다. StatefulSet은 안정적 네트워크 ID, 순차 배포, 영구 스토리지가 필요한 경우(DB)에 사용합니다.',
ARRAY['Deployment', 'StatefulSet', '상태', '네트워크 ID', '스토리지'],
'StatefulSet은 Pod 이름이 순차적(pod-0, pod-1)이며 각 Pod에 전용 PVC가 할당됩니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 서비스', 2, 10, 50,
'Ingress와 LoadBalancer Service의 선택 기준은 무엇인가요?',
'HTTP/HTTPS 트래픽은 Ingress가 효율적입니다(하나의 LB로 여러 서비스). TCP/UDP는 LoadBalancer 또는 NodePort를 사용합니다.',
ARRAY['Ingress', 'LoadBalancer', 'HTTP', 'HTTPS', 'TCP'],
'Ingress는 호스트/경로 기반 라우팅, TLS 종료 등의 기능을 제공합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 스토리지', 2, 10, 50,
'Dynamic Provisioning의 장점은 무엇인가요?',
'PVC 생성 시 자동으로 PV가 프로비저닝됩니다. 관리자가 미리 PV를 생성할 필요 없어 운영 부담이 감소합니다.',
ARRAY['Dynamic Provisioning', 'PVC', 'PV', 'StorageClass', '자동'],
'StorageClass를 정의하면 PVC 요청에 맞는 PV가 자동 생성됩니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 스케일링', 2, 10, 50,
'HPA(Horizontal Pod Autoscaler) 설정 시 주의할 점은 무엇인가요?',
'Pod에 resource requests 설정이 필수입니다. 스케일 업/다운 안정화 기간으로 빈번한 스케일링을 방지하고, 최소/최대 레플리카를 적절히 설정해야 합니다.',
ARRAY['HPA', 'resource requests', '스케일링', '안정화', '레플리카'],
'metrics-server가 설치되어 있어야 HPA가 동작합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'CI/CD 파이프라인', 2, 10, 50,
'GitHub Actions에서 jobs와 steps의 차이는 무엇인가요?',
'Job은 독립적인 실행 환경(러너)입니다. Step은 Job 내에서 순차 실행되는 개별 작업입니다. Job 간에는 병렬 실행이 가능합니다.',
ARRAY['GitHub Actions', 'jobs', 'steps', '러너', '병렬'],
'Job 간 데이터 전달은 artifacts나 outputs를 사용합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', '배포 전략', 2, 10, 50,
'Blue-Green 배포의 장단점은 무엇인가요?',
'장점은 즉각적인 전환과 롤백이 가능합니다. 단점은 두 배의 리소스가 필요하고 데이터베이스 마이그레이션이 복잡합니다.',
ARRAY['Blue-Green', '배포', '전환', '롤백', '리소스'],
'트래픽을 한 번에 전환하므로 점진적 검증은 어렵지만 롤백이 명확합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', '배포 전략', 2, 10, 50,
'Canary 배포에서 트래픽 비율을 어떻게 결정하나요?',
'일반적으로 1% -> 5% -> 25% -> 100%로 점진적 증가합니다. 에러율, 레이턴시를 모니터링하며 단계별 승인합니다.',
ARRAY['Canary', '트래픽 비율', '점진적', '모니터링', '승인'],
'Argo Rollouts, Flagger 등으로 메트릭 기반 자동 프로모션/롤백이 가능합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'GitOps', 2, 10, 50,
'ArgoCD의 Sync Policy 옵션에는 어떤 것들이 있나요?',
'Auto-Sync(자동 동기화), Self-Heal(수동 변경 복원), Prune(삭제된 리소스 제거), Sync Options(replace, server-side apply)가 있습니다.',
ARRAY['ArgoCD', 'Sync Policy', 'Auto-Sync', 'Self-Heal', 'Prune'],
'Self-Heal은 kubectl로 직접 수정한 리소스를 Git 상태로 되돌립니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'IaC', 2, 10, 50,
'Terraform State를 원격 저장해야 하는 이유는 무엇인가요?',
'팀 협업, State 잠금으로 동시 수정 방지, 백업, CI/CD 통합이 가능합니다. S3+DynamoDB, Terraform Cloud 등을 사용합니다.',
ARRAY['Terraform', 'State', '원격', '잠금', 'S3'],
'로컬 State는 단일 사용자에게만 적합하며, 팀에서는 반드시 원격 백엔드를 사용해야 합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', '환경 분리', 2, 10, 50,
'Kustomize와 Helm의 선택 기준은 무엇인가요?',
'Kustomize는 패치 기반으로 단순하고 K8s에 내장되어 있습니다. Helm은 템플릿 기반으로 복잡한 로직, 조건부 렌더링이 가능합니다. 혼용도 가능합니다.',
ARRAY['Kustomize', 'Helm', '패치', '템플릿', '환경'],
'단순한 환경별 설정 차이는 Kustomize, 복잡한 패키징과 버전 관리는 Helm이 적합합니다.',
'docs/04-deployment-cicd.md');

-- 난이도 3 (시니어) - 12문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 최적화', 3, 30, 75,
'BuildKit의 캐시 마운트(--mount=type=cache)의 용도는 무엇인가요?',
'패키지 매니저 캐시(apt, npm, pip)를 빌드 간에 유지하여 의존성 다운로드 시간을 크게 줄입니다.',
ARRAY['BuildKit', '캐시 마운트', 'apt', 'npm', 'pip'],
'RUN --mount=type=cache,target=/root/.npm npm install 형태로 사용합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 보안', 3, 30, 75,
'seccomp 프로파일의 역할은 무엇인가요?',
'컨테이너가 호출할 수 있는 시스템 콜을 제한합니다. 불필요한 syscall을 차단하여 공격 표면을 줄입니다.',
ARRAY['seccomp', '시스템 콜', 'syscall', '보안', '제한'],
'Docker는 기본 seccomp 프로파일을 제공하며, 커스텀 프로파일로 더 제한할 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 핵심 개념', 3, 30, 75,
'Pod가 Pending 상태에 머무는 원인은 무엇인가요?',
'리소스 부족, 이미지 풀 실패, PVC 바인딩 대기, 노드 셀렉터/어피니티 불일치, taint/toleration 미스매치 등이 원인입니다.',
ARRAY['Pending', 'Pod', '리소스', 'PVC', 'taint'],
'kubectl describe pod으로 Events 섹션을 확인하면 구체적인 원인을 알 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 서비스', 3, 30, 75,
'NetworkPolicy의 기본 동작은 어떻게 되나요?',
'NetworkPolicy가 없으면 모든 트래픽이 허용됩니다. 하나라도 적용되면 명시적으로 허용된 트래픽만 통과합니다(화이트리스트).',
ARRAY['NetworkPolicy', '트래픽', '허용', '화이트리스트', '방화벽'],
'NetworkPolicy는 CNI 플러그인(Calico, Cilium 등)이 지원해야 동작합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 스케일링', 3, 30, 75,
'KEDA(Kubernetes Event-driven Autoscaling)의 장점은 무엇인가요?',
'외부 이벤트 소스(Kafka, RabbitMQ, Redis, Prometheus) 기반 스케일링이 가능합니다. 0으로 스케일 다운 가능하여 비용을 절감합니다.',
ARRAY['KEDA', '이벤트', 'Kafka', 'RabbitMQ', '스케일 다운'],
'HPA의 한계인 CPU/메모리 외 메트릭 기반 스케일링을 지원합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 보안', 3, 30, 75,
'OPA Gatekeeper의 동작 원리는 무엇인가요?',
'Admission Webhook으로 리소스 생성/수정 요청을 가로채고, Rego 언어로 작성된 정책을 평가하여 허용/거부합니다.',
ARRAY['OPA', 'Gatekeeper', 'Admission', 'Rego', '정책'],
'이미지 레지스트리 제한, 리소스 제한 필수화 등의 정책을 적용할 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 운영', 3, 30, 75,
'노드 유지보수 절차는 어떻게 되나요?',
'kubectl cordon node(스케줄링 비활성화) -> kubectl drain node(Pod 이전) -> 유지보수 -> kubectl uncordon node 순서입니다.',
ARRAY['cordon', 'drain', 'uncordon', '노드', '유지보수'],
'drain 시 PodDisruptionBudget을 고려하여 가용성을 유지합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'CI/CD 파이프라인', 3, 30, 75,
'GitHub Actions 캐싱 전략은 어떻게 구성하나요?',
'actions/cache로 node_modules, .m2, pip 캐시를 관리합니다. 키는 lock 파일 해시 기반이며, restore-keys로 부분 매칭합니다.',
ARRAY['GitHub Actions', '캐싱', 'actions/cache', 'lock 파일', 'restore-keys'],
'캐시 히트율을 높이면 빌드 시간을 크게 단축할 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', '배포 전략', 3, 30, 75,
'Feature Flag의 장점은 무엇인가요?',
'배포와 릴리스 분리, 빠른 롤백(코드 배포 없이), A/B 테스트, 점진적 롤아웃, 특정 사용자에게만 기능 활성화가 가능합니다.',
ARRAY['Feature Flag', '배포', '릴리스', '롤백', 'A/B 테스트'],
'LaunchDarkly, Unleash 등의 도구로 Feature Flag를 관리합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'GitOps', 3, 30, 75,
'App of Apps 패턴의 사용 사례는 무엇인가요?',
'환경별(dev/staging/prod) 애플리케이션 그룹 관리, 마이크로서비스 세트 배포, 클러스터 부트스트래핑에 사용합니다.',
ARRAY['App of Apps', 'ArgoCD', '환경', '마이크로서비스', '부트스트래핑'],
'하나의 Application이 다른 Application들을 관리하여 계층적 구조를 만듭니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'IaC', 3, 30, 75,
'Terraform State 드리프트를 어떻게 해결하나요?',
'terraform refresh로 State를 갱신하거나, terraform import로 기존 리소스를 가져옵니다. 필요시 State를 수동 편집하지만 주의가 필요합니다.',
ARRAY['Terraform', 'State', '드리프트', 'refresh', 'import'],
'드리프트는 Terraform 외부에서 인프라가 변경되었을 때 발생합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', '롤백', 3, 30, 75,
'DB 마이그레이션과 롤백을 안전하게 하려면 어떻게 해야 하나요?',
'Expand and Contract 패턴: 1) 새 컬럼 추가 2) 양쪽 쓰기 3) 데이터 마이그레이션 4) 새 컬럼만 읽기 5) 구 컬럼 제거 순서로 진행합니다.',
ARRAY['DB 마이그레이션', '롤백', 'Expand and Contract', '컬럼', '하위 호환'],
'각 단계에서 롤백이 가능하도록 하위 호환성을 유지하는 것이 핵심입니다.',
'docs/04-deployment-cicd.md');

-- 난이도 4 (리드) - 8문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Docker 최적화', 4, 50, 100,
'컨테이너 공급망 보안을 강화하는 방법은 무엇인가요?',
'이미지 서명(cosign), SBOM 생성(syft), 취약점 스캐닝(trivy), 신뢰할 수 있는 베이스 이미지 사용, 정책 기반 어드미션 컨트롤을 적용합니다.',
ARRAY['공급망 보안', 'cosign', 'SBOM', 'trivy', '어드미션 컨트롤'],
'SLSA 프레임워크를 참고하여 빌드 과정의 무결성과 출처 증명을 구현합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 핵심 개념', 4, 50, 100,
'etcd의 역할과 관리 방법은 무엇인가요?',
'모든 클러스터 상태를 저장합니다. 정기 백업 필수, 홀수 개 노드 구성, 전용 SSD, 디스크 IOPS 모니터링이 필요합니다.',
ARRAY['etcd', '클러스터 상태', '백업', '홀수', 'IOPS'],
'etcd 장애는 전체 클러스터 장애로 이어지므로 고가용성 구성이 중요합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 스케일링', 4, 50, 100,
'Spot/Preemptible 인스턴스를 프로덕션에 사용할 때 주의점은 무엇인가요?',
'중단 허용 워크로드만 배치, PDB 설정, 온디맨드 노드 풀 유지, 중단 핸들러로 graceful shutdown을 구성합니다.',
ARRAY['Spot', 'Preemptible', 'PDB', 'graceful shutdown', '비용'],
'최대 90% 비용 절감이 가능하지만 언제든 중단될 수 있어 적절한 대비가 필요합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'Kubernetes 보안', 4, 50, 100,
'Falco가 감지할 수 있는 위협은 무엇인가요?',
'예상치 못한 프로세스 실행, 파일 시스템 변경, 네트워크 연결, 권한 상승 시도, 컨테이너 탈출 시도를 감지합니다.',
ARRAY['Falco', '런타임 보안', '프로세스', '권한 상승', '컨테이너 탈출'],
'Falco는 커널 수준에서 시스템 콜을 모니터링하여 실시간 위협 탐지를 수행합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'CI/CD 파이프라인', 4, 50, 100,
'SLSA(Supply-chain Levels for Software Artifacts)란 무엇인가요?',
'소프트웨어 공급망 보안 프레임워크입니다. 빌드 과정의 무결성, 출처 증명, 변조 방지를 레벨별로 정의합니다.',
ARRAY['SLSA', '공급망', '무결성', '출처 증명', '보안'],
'SLSA Level 1~4까지 있으며, 높은 레벨일수록 강력한 보안 요구사항을 충족합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', '배포 전략', 4, 50, 100,
'글로벌 서비스의 배포 전략은 어떻게 수립하나요?',
'트래픽 적은 리전부터 순차 배포, 리전 간 의존성 고려, 글로벌 피처 플래그, 시간대별 배포 창 설정을 적용합니다.',
ARRAY['글로벌', '리전', '순차 배포', '피처 플래그', '배포 창'],
'Follow-the-Sun 패턴으로 각 리전의 업무 시간을 피해 배포할 수 있습니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'GitOps', 4, 50, 100,
'대규모 조직에서 GitOps 거버넌스 전략은 어떻게 수립하나요?',
'중앙 플랫폼팀이 기본 정책과 템플릿 관리, 팀별 네임스페이스 자율권 부여, RBAC과 ApplicationProject로 권한을 분리합니다.',
ARRAY['GitOps', '거버넌스', '플랫폼팀', 'RBAC', 'ApplicationProject'],
'멀티테넌시 환경에서 팀 간 격리와 자율성의 균형을 맞추는 것이 중요합니다.',
'docs/04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'IaC', 4, 50, 100,
'대규모 조직의 IaC 거버넌스 전략은 어떻게 수립하나요?',
'중앙 모듈 레지스트리, 버전 관리 정책, Policy as Code로 규정 준수, 자동화된 테스트, 문서화 표준을 적용합니다.',
ARRAY['IaC', '거버넌스', '모듈 레지스트리', 'Policy as Code', '테스트'],
'Sentinel, OPA 등으로 정책을 코드화하여 규정 준수를 자동 검증합니다.',
'docs/04-deployment-cicd.md');
