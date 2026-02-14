-- CS Knowledge Quiz - Database & Deployment 실전/시나리오 기반 추가 문제 (v2-2)
-- 총 50문제: database 25문제 + deployment 25문제
-- 생성일: 2026-02-14

-- ============================================
-- DATABASE 문제 (25문제)
-- ============================================

-- 난이도 1 (6문제) - level_min=1, level_max=25
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'index', 1, 1, 25,
'개발 중인 서비스에서 사용자 테이블의 email 컬럼으로 자주 검색하는데, 검색 속도가 느립니다. 어떻게 개선할 수 있나요?',
'email 컬럼에 인덱스를 생성하면 검색 속도를 크게 향상시킬 수 있습니다. 인덱스는 테이블 전체를 스캔하지 않고 정렬된 구조에서 빠르게 데이터를 찾을 수 있게 해줍니다.',
ARRAY['index', 'email', 'search', 'performance', 'optimization'],
'WHERE 절에 자주 사용되는 컬럼에 인덱스를 생성하면 Full Table Scan 대신 인덱스를 통해 빠르게 데이터 위치를 찾을 수 있어 조회 성능이 향상됩니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'transaction', 1, 1, 25,
'온라인 쇼핑몰에서 결제 처리 중 시스템 오류가 발생했습니다. 결제 금액은 차감되었는데 주문은 생성되지 않았다면, 이런 문제를 방지하기 위해 어떤 개념이 필요한가요?',
'트랜잭션을 사용해야 합니다. 트랜잭션은 결제 차감과 주문 생성을 하나의 작업 단위로 묶어, 둘 다 성공하거나 둘 다 실패하도록 보장합니다.',
ARRAY['transaction', 'atomicity', 'ACID', 'commit', 'rollback'],
'트랜잭션의 원자성(Atomicity)은 여러 작업이 모두 완전히 수행되거나 전혀 수행되지 않음을 보장하여 데이터 정합성을 유지합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'backup', 1, 1, 25,
'서버 하드디스크 장애로 데이터베이스가 손상되었습니다. 데이터를 복구하려면 평소에 무엇을 해두어야 했나요?',
'정기적인 백업을 수행해야 합니다. 전체 백업과 증분 백업을 조합하여 주기적으로 데이터를 안전한 저장소에 보관해야 장애 시 복구가 가능합니다.',
ARRAY['backup', 'recovery', 'disaster recovery', 'data protection'],
'백업은 하드웨어 장애, 소프트웨어 버그, 휴먼 에러, 랜섬웨어 등으로 인한 데이터 손실에 대비하는 필수적인 운영 활동입니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'normalization', 1, 1, 25,
'회원 테이블에 주소를 저장하는데, 한 컬럼에 "서울시 강남구 역삼동 123-45"처럼 전체 주소를 넣으면 어떤 문제가 있나요?',
'정규화 원칙을 위반합니다. 하나의 컬럼에 여러 값(시, 구, 동, 번지)이 들어가면 특정 지역만 검색하기 어렵고, 데이터 수정 시 일관성 유지가 어렵습니다.',
ARRAY['normalization', '1NF', 'atomic value', 'data integrity'],
'1NF(제1정규형)는 모든 속성이 원자값만 가져야 합니다. 주소를 시, 구, 동, 상세주소로 분리하면 검색과 수정이 용이해집니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'replication', 1, 1, 25,
'서비스 사용자가 급증하여 데이터베이스 조회 성능이 떨어지고 있습니다. 쓰기보다 읽기가 훨씬 많은 상황에서 어떻게 개선할 수 있나요?',
'복제(Replication)를 사용하여 읽기/쓰기를 분리합니다. Primary 서버는 쓰기만 처리하고, 여러 Replica 서버에서 읽기 쿼리를 분산 처리하면 전체 처리량이 향상됩니다.',
ARRAY['replication', 'read replica', 'load balancing', 'primary', 'replica'],
'복제는 고가용성, 읽기 성능 향상, 재해 복구를 위해 데이터를 여러 서버에 복사하는 기법입니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'connection-pool', 1, 1, 25,
'웹 애플리케이션에서 매 요청마다 새로운 DB 연결을 생성하고 있습니다. 트래픽이 늘어나면서 "too many connections" 에러가 발생합니다. 어떻게 해결해야 하나요?',
'커넥션 풀링을 적용해야 합니다. 미리 일정 수의 연결을 생성해두고 재사용하면 연결 생성 오버헤드를 줄이고 데이터베이스 리소스를 효율적으로 사용할 수 있습니다.',
ARRAY['connection pooling', 'connection pool', 'database connection', 'resource management'],
'DB 연결 생성은 TCP 핸드셰이크, 인증, 메모리 할당 등 비용이 높습니다. 커넥션 풀링으로 이 비용을 절감하고 연결 수를 제어할 수 있습니다.',
'03-database.md');

-- 난이도 2 (7문제) - level_min=10, level_max=50
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'explain', 2, 10, 50,
'슬로우 쿼리가 발생했을 때, 어떤 명령어로 쿼리 실행 계획을 분석할 수 있나요? 그리고 분석할 때 가장 먼저 확인해야 할 것은 무엇인가요?',
'EXPLAIN 또는 EXPLAIN ANALYZE 명령어를 사용합니다. 가장 먼저 스캔 방식(Seq Scan vs Index Scan)을 확인하고, 예상 행 수와 실제 행 수의 차이, 가장 비용이 높은 단계를 순서대로 확인해야 합니다.',
ARRAY['EXPLAIN', 'EXPLAIN ANALYZE', 'execution plan', 'Seq Scan', 'Index Scan'],
'EXPLAIN은 예상 실행계획을, EXPLAIN ANALYZE는 실제 쿼리를 실행하여 실제 통계를 보여줍니다. 대용량 테이블에서 Seq Scan이 나타나면 인덱스 추가를 검토해야 합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'index', 2, 10, 50,
'복합 인덱스 (status, created_at)가 있는 테이블에서 WHERE created_at > ''2024-01-01'' 쿼리가 여전히 느립니다. 왜 인덱스가 사용되지 않나요?',
'복합 인덱스는 첫 번째 컬럼부터 순서대로 정렬됩니다. status 없이 created_at만으로 검색하면 인덱스를 활용할 수 없습니다. created_at 단독 인덱스를 추가하거나, 쿼리에 status 조건을 포함해야 합니다.',
ARRAY['composite index', 'index order', 'leftmost prefix', 'query optimization'],
'복합 인덱스 (A, B, C)는 A만, (A, B), (A, B, C) 조건에서만 효과적입니다. B나 C만 있는 조건은 인덱스를 활용할 수 없습니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'isolation', 2, 10, 50,
'두 사용자가 동시에 같은 상품을 구매하려고 합니다. 재고가 1개인데 둘 다 구매에 성공하는 문제가 발생했습니다. 어떤 격리 수준과 잠금 방식으로 이 문제를 해결할 수 있나요?',
'SELECT FOR UPDATE를 사용하여 재고를 조회할 때 배타 잠금을 획득해야 합니다. 한 트랜잭션이 재고를 확인하고 차감할 때까지 다른 트랜잭션이 해당 행을 수정하지 못하게 막습니다.',
ARRAY['SELECT FOR UPDATE', 'exclusive lock', 'race condition', 'pessimistic locking', 'isolation level'],
'동시성 문제는 적절한 잠금으로 해결합니다. SELECT FOR UPDATE는 읽기 시점에 배타 잠금을 획득하여 읽은 값을 기반으로 안전하게 수정할 수 있게 합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'replication', 2, 10, 50,
'사용자가 주문을 완료한 직후 주문 내역 페이지로 이동했는데, 방금 한 주문이 보이지 않습니다. 복제 환경에서 이런 문제가 발생하는 이유와 해결책은?',
'복제 지연(Replication Lag) 때문입니다. 쓰기는 Primary에서 처리하고 읽기는 Replica에서 처리하는데, Replica에 아직 변경이 반영되지 않았습니다. 쓰기 직후 읽기는 Primary에서 수행하도록 라우팅하면 해결됩니다.',
ARRAY['replication lag', 'read after write', 'primary', 'replica', 'consistency'],
'비동기 복제에서는 복제 지연이 발생합니다. 쓰기 후 읽기 일관성이 필요한 경우 Primary에서 읽거나, 버전/타임스탬프로 일관성을 확인해야 합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'slow-query', 2, 10, 50,
'대시보드 페이지 로딩이 10초 이상 걸립니다. 확인해보니 주문 목록을 가져온 후 각 주문별로 상품, 고객 정보를 개별 조회하고 있었습니다. 이런 문제를 무엇이라 하고, 어떻게 해결하나요?',
'N+1 쿼리 문제입니다. 목록 조회 1회 + 각 항목별 추가 쿼리 N회가 발생합니다. JOIN으로 한 번에 필요한 데이터를 모두 가져오거나, 배치 로딩(IN 절 사용)으로 쿼리 수를 줄여야 합니다.',
ARRAY['N+1 problem', 'JOIN', 'batch loading', 'query optimization', 'ORM'],
'N+1 문제는 ORM 사용 시 자주 발생합니다. EAGER 로딩, JOIN FETCH, 또는 명시적 JOIN으로 해결할 수 있습니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'partitioning', 2, 10, 50,
'5년치 로그 데이터 10억 건이 있는 테이블에서 최근 1개월 데이터 조회가 매우 느립니다. 테이블 구조를 어떻게 개선할 수 있나요?',
'월별 Range 파티셔닝을 적용합니다. 파티셔닝을 사용하면 쿼리 조건에 해당하지 않는 파티션은 스캔에서 제외되어(파티션 프루닝) 성능이 크게 향상됩니다. 오래된 데이터는 파티션 단위로 빠르게 삭제할 수 있습니다.',
ARRAY['partitioning', 'partition pruning', 'range partition', 'log table', 'archiving'],
'파티셔닝은 대용량 테이블의 관리와 조회 성능을 향상시킵니다. WHERE 절에 파티션 키가 포함되어야 프루닝 효과가 있습니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'caching', 2, 10, 50,
'자주 조회되는 상품 정보를 Redis에 캐시했는데, 상품 정보를 수정해도 사용자에게 구버전이 계속 보입니다. 어떻게 해결해야 하나요?',
'캐시 무효화 전략을 적용해야 합니다. 데이터 변경 시 해당 캐시를 삭제(이벤트 기반 무효화)하거나, 짧은 TTL을 설정하거나, 버전 기반 키를 사용하여 캐시와 DB의 데이터 정합성을 유지해야 합니다.',
ARRAY['cache invalidation', 'TTL', 'cache aside', 'data consistency', 'Redis'],
'캐싱의 핵심은 무효화 전략입니다. Cache-Aside 패턴에서는 데이터 변경 시 DB 업데이트 후 캐시를 삭제하는 것이 일반적입니다.',
'03-database.md');

-- 난이도 3 (7문제) - level_min=30, level_max=75
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'deadlock', 3, 30, 75,
'주문 처리 시스템에서 데드락이 빈번하게 발생합니다. 로그를 보니 어떤 트랜잭션은 재고→결제 순으로, 다른 트랜잭션은 결제→재고 순으로 잠금을 획득하고 있습니다. 어떻게 해결해야 하나요?',
'모든 트랜잭션에서 동일한 순서로 잠금을 획득해야 합니다. 예를 들어 항상 재고→결제 순서로 통일합니다. 또한 트랜잭션 시간을 최소화하고, lock_timeout을 설정하여 무한 대기를 방지합니다.',
ARRAY['deadlock', 'lock ordering', 'lock timeout', 'transaction', 'concurrent access'],
'데드락은 두 트랜잭션이 서로 상대방이 잡은 잠금을 기다릴 때 발생합니다. 일관된 잠금 순서와 타임아웃 설정으로 예방하고, DB가 자동 감지 시 한 트랜잭션을 롤백합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'covering-index', 3, 30, 75,
'사용자 목록 조회 쿼리(SELECT id, name, email FROM users WHERE status = ''active'')에서 인덱스를 사용하지만 여전히 테이블 접근이 발생합니다. 테이블 접근 없이 인덱스만으로 처리하려면?',
'커버링 인덱스를 생성합니다. (status, id, name, email)로 복합 인덱스를 만들면 쿼리에 필요한 모든 컬럼이 인덱스에 포함되어 테이블 접근 없이 Index Only Scan으로 처리됩니다.',
ARRAY['covering index', 'index only scan', 'composite index', 'query optimization'],
'커버링 인덱스는 쿼리에 필요한 모든 컬럼을 포함하여 I/O를 크게 줄입니다. EXPLAIN에서 Index Only Scan이 나타나면 커버링 인덱스가 적용된 것입니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'mvcc', 3, 30, 75,
'PostgreSQL에서 긴 트랜잭션이 실행 중일 때 테이블 크기가 비정상적으로 커지는 현상이 발생합니다. MVCC와 관련하여 원인과 해결책을 설명해주세요.',
'MVCC는 데이터 변경 시 새 버전을 생성하고 이전 버전을 유지합니다. 긴 트랜잭션이 오래된 스냅샷을 유지하면 VACUUM이 이전 버전을 정리하지 못해 테이블 부풀림(bloat)이 발생합니다. Long-running 트랜잭션을 피하고 정기적인 VACUUM을 수행해야 합니다.',
ARRAY['MVCC', 'vacuum', 'table bloat', 'long transaction', 'PostgreSQL'],
'MVCC의 각 행에는 xmin(생성 트랜잭션), xmax(삭제 트랜잭션) 정보가 저장됩니다. VACUUM이 오래된 버전을 정리하지만, 활성 트랜잭션이 참조하는 버전은 정리할 수 없습니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'optimistic-locking', 3, 30, 75,
'위키 같은 문서 편집 시스템에서 동시 수정 충돌을 감지해야 합니다. 매번 잠금을 거는 것은 성능에 부담이 됩니다. 어떤 방식을 사용해야 하나요?',
'낙관적 잠금(Optimistic Locking)을 사용합니다. 문서 테이블에 version 컬럼을 추가하고, UPDATE 시 WHERE version = 읽었던 버전 조건을 추가합니다. affected rows가 0이면 다른 사용자가 수정한 것으로 판단하여 재시도하거나 사용자에게 알립니다.',
ARRAY['optimistic locking', 'version column', 'conflict detection', 'concurrent edit'],
'낙관적 잠금은 충돌이 적을 때 효율적입니다. 충돌이 많은 환경에서는 비관적 잠금(SELECT FOR UPDATE)이 더 적합합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'thundering-herd', 3, 30, 75,
'인기 상품 페이지의 캐시가 만료되는 순간 수천 개의 요청이 동시에 DB로 몰려 장애가 발생했습니다. 이 현상의 이름과 해결책은?',
'Thundering Herd 문제입니다. 해결책: 1) 뮤텍스/락으로 하나의 요청만 DB 조회하고 나머지는 대기 2) 만료 전 백그라운드에서 미리 갱신 3) TTL에 랜덤 지터 추가 4) Stale-While-Revalidate 패턴으로 만료된 데이터를 즉시 반환하면서 백그라운드 갱신.',
ARRAY['thundering herd', 'cache stampede', 'mutex', 'background refresh', 'jitter'],
'Thundering Herd는 캐시 키가 만료될 때 동시에 많은 요청이 DB로 몰리는 현상입니다. 단일 갱신 보장과 사전 갱신으로 방지할 수 있습니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'join-algorithm', 3, 30, 75,
'EXPLAIN ANALYZE 결과에서 Hash Join 대신 Nested Loop이 선택되어 쿼리가 매우 느립니다. 예상 행 수는 100인데 실제는 100만 건이었습니다. 원인과 해결책은?',
'통계 정보가 오래되어 옵티마이저가 잘못된 실행 계획을 선택했습니다. ANALYZE 테이블명을 실행하여 통계를 갱신해야 합니다. 갱신 후 옵티마이저가 정확한 행 수를 추정하여 적절한 Join 알고리즘(Hash Join)을 선택합니다.',
ARRAY['ANALYZE', 'statistics', 'optimizer', 'Hash Join', 'Nested Loop', 'cardinality estimation'],
'옵티마이저는 통계 정보를 기반으로 실행 계획을 결정합니다. 예상 행 수와 실제 행 수의 큰 차이는 통계 갱신이 필요하다는 신호입니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'elasticsearch', 3, 30, 75,
'상품 검색 기능을 RDBMS의 LIKE ''%keyword%''로 구현했는데 너무 느립니다. 검색 성능을 크게 향상시키려면 어떤 기술을 도입해야 하나요?',
'Elasticsearch 같은 검색 엔진을 도입해야 합니다. 역인덱스(Inverted Index) 구조로 단어를 키로, 해당 단어가 포함된 문서 목록을 값으로 저장하여 O(1)에 가까운 빠른 검색이 가능합니다. 분석기를 통한 토큰화, 유연한 매칭도 지원합니다.',
ARRAY['Elasticsearch', 'inverted index', 'full-text search', 'analyzer', 'search engine'],
'LIKE ''%keyword%''는 인덱스를 사용할 수 없어 Full Table Scan이 발생합니다. Elasticsearch는 역인덱스와 분산 처리로 대용량 텍스트에서 빠른 전문 검색을 제공합니다.',
'03-database.md');

-- 난이도 4 (5문제) - level_min=50, level_max=100
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'sharding', 4, 50, 100,
'일 1000만 건 트래픽을 처리하는 서비스에서 단일 DB의 한계에 도달했습니다. 샤딩 도입 시 샤드 키 선택 기준과 주의점을 설명해주세요.',
'좋은 샤드 키는 카디널리티가 높고, 쿼리에 자주 포함되며, 데이터가 균등 분산되고, 핫스팟이 발생하지 않아야 합니다. 시간 기반 키(created_at)는 최근 샤드에 쓰기가 집중되는 핫스팟 문제가 있어 피해야 합니다. user_id 같은 키로 Hash 샤딩이 일반적입니다. 단, 크로스 샤드 조인과 트랜잭션이 어려워지는 점을 고려해야 합니다.',
ARRAY['sharding', 'shard key', 'hotspot', 'hash sharding', 'cross-shard join', 'distributed database'],
'샤딩은 운영 복잡도가 높으므로 다른 최적화(인덱스, 캐싱, 복제, 파티셔닝)를 먼저 시도하고 마지막 수단으로 고려해야 합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'pitr', 4, 50, 100,
'운영 DB에서 실수로 중요 테이블에 DELETE 쿼리를 WHERE 없이 실행했습니다. 10분 전 상태로 복구해야 합니다. 어떤 기능으로 복구할 수 있나요?',
'PITR(Point-In-Time Recovery)을 사용합니다. 기본 백업(pg_basebackup) + WAL 아카이브를 사용하여 장애 발생 직전이나 잘못된 쿼리 실행 전 특정 시점으로 복구할 수 있습니다. recovery.conf에 recovery_target_time을 설정하고 WAL을 재생합니다.',
ARRAY['PITR', 'Point-In-Time Recovery', 'WAL archiving', 'pg_basebackup', 'disaster recovery'],
'PITR을 위해서는 평소 archive_mode=on, archive_command 설정으로 WAL 아카이빙을 구성해두어야 합니다. RPO(Recovery Point Objective)를 최소화할 수 있습니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'distributed-transaction', 4, 50, 100,
'마이크로서비스 환경에서 주문 서비스와 결제 서비스가 각각 다른 DB를 사용합니다. 두 서비스 간 데이터 일관성을 어떻게 보장하나요?',
'분산 트랜잭션 대신 Saga 패턴을 사용합니다. 각 서비스는 로컬 트랜잭션을 수행하고, 실패 시 보상 트랜잭션(Compensating Transaction)으로 이전 작업을 취소합니다. 또는 이벤트 소싱을 통해 결과적 일관성(Eventually Consistent)을 달성합니다. 2PC(Two-Phase Commit)는 가용성과 성능 문제로 마이크로서비스에서 권장되지 않습니다.',
ARRAY['Saga pattern', 'compensating transaction', 'eventual consistency', 'distributed transaction', 'microservices'],
'마이크로서비스에서는 각 서비스가 독립적인 DB를 가지므로 서비스 간 조인이 불가능합니다. 결과적 일관성을 수용하고 이벤트 기반으로 동기화합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'distributed-lock', 4, 50, 100,
'여러 서버에서 동시에 같은 배치 작업이 실행되면 안 됩니다. 분산 환경에서 단일 인스턴스만 작업을 수행하도록 보장하려면 어떻게 해야 하나요?',
'분산 잠금을 사용합니다. Redis의 SETNX(SET if Not eXists)나 Redlock 알고리즘, ZooKeeper의 순차 노드, etcd의 lease를 활용할 수 있습니다. 네트워크 파티션과 클럭 드리프트를 고려해야 하며, 잠금 만료 시간(TTL)을 설정하여 데드락을 방지합니다.',
ARRAY['distributed lock', 'Redis', 'SETNX', 'Redlock', 'ZooKeeper', 'etcd'],
'분산 잠금은 네트워크 장애로 인한 스플릿 브레인 상황을 고려해야 합니다. Redlock은 여러 Redis 인스턴스의 과반수 동의를 요구합니다.',
'03-database.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('database', 'multi-region', 4, 50, 100,
'글로벌 서비스를 위해 멀티 리전 데이터베이스 복제를 설계해야 합니다. 동기 복제와 비동기 복제 중 어떤 것을 선택해야 하고, CAP 정리와의 관계는 어떻게 되나요?',
'리전 간 네트워크 지연이 크므로 일반적으로 비동기 복제를 사용합니다. CAP 정리에서 동기 복제(CP)는 일관성을 보장하지만 네트워크 파티션 시 가용성이 떨어집니다. 비동기 복제(AP)는 가용성을 유지하지만 일관성이 떨어집니다. 대부분의 경우 결과적 일관성을 수용하고 높은 가용성을 선택하며, 복제 지연 모니터링과 충돌 해결 전략을 수립해야 합니다.',
ARRAY['multi-region', 'CAP theorem', 'async replication', 'consistency', 'availability', 'partition tolerance'],
'멀티 리전에서는 네트워크 지연, 복제 지연, 스플릿 브레인 방지, 지역별 규제 준수(GDPR 등)를 고려해야 합니다.',
'03-database.md');

-- ============================================
-- DEPLOYMENT 문제 (25문제)
-- ============================================

-- 난이도 1 (6문제) - level_min=1, level_max=25
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'docker', 1, 1, 25,
'개발 환경에서는 잘 동작하는 애플리케이션이 다른 개발자 PC에서는 동작하지 않습니다. "내 컴퓨터에서는 돼요"라는 문제를 해결하려면 어떤 기술을 사용해야 하나요?',
'Docker 컨테이너를 사용합니다. 컨테이너는 애플리케이션과 실행에 필요한 모든 의존성을 패키징하여 어떤 환경에서도 동일하게 동작하도록 보장합니다. 호스트 OS와 격리되어 일관된 실행 환경을 제공합니다.',
ARRAY['Docker', 'container', 'environment consistency', 'isolation', 'packaging'],
'Docker는 OS 레벨 가상화로 호스트 커널을 공유하면서 독립적인 실행 환경을 제공합니다. VM보다 가볍고 빠릅니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'ci', 1, 1, 25,
'개발팀에서 코드 통합 시 자주 충돌이 발생하고, 빌드가 깨진 채로 오래 방치됩니다. 어떤 프랙티스를 도입해야 하나요?',
'CI(Continuous Integration)를 도입해야 합니다. 모든 개발자가 자주 코드를 통합하고(하루에 여러 번), 모든 커밋에 자동 빌드와 테스트를 실행하여 빠른 피드백을 받고, 실패 시 즉시 수정하는 문화를 만들어야 합니다.',
ARRAY['CI', 'Continuous Integration', 'automated build', 'automated test', 'fast feedback'],
'CI의 핵심 원칙은 자주 통합하고, 모든 변경에 자동 빌드/테스트를 실행하며, 실패 시 즉시 수정하는 것입니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'rolling-update', 1, 1, 25,
'서비스 배포 시 사용자에게 다운타임 없이 새 버전을 배포하고 싶습니다. 가장 기본적인 무중단 배포 전략은 무엇인가요?',
'Rolling Update(롤링 업데이트)입니다. 기존 Pod를 점진적으로 새 버전으로 교체하여 항상 일정 수의 Pod가 서비스 중인 상태를 유지합니다. 문제 발생 시 빠른 롤백이 가능합니다.',
ARRAY['rolling update', 'zero downtime', 'deployment strategy', 'gradual replacement'],
'Rolling Update는 Kubernetes Deployment의 기본 전략입니다. maxSurge와 maxUnavailable로 교체 속도를 제어할 수 있습니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'kubernetes', 1, 1, 25,
'컨테이너가 많아지면서 수동으로 관리하기 어렵습니다. 컨테이너 배포, 스케일링, 장애 복구를 자동화하려면 어떤 도구를 사용해야 하나요?',
'Kubernetes(K8s)를 사용합니다. Kubernetes는 컨테이너화된 워크로드를 자동으로 배포, 스케일링, 관리하는 오케스트레이션 플랫폼입니다. 자동 스케일링, 롤백, 서비스 디스커버리, 선언적 설정을 제공합니다.',
ARRAY['Kubernetes', 'container orchestration', 'auto scaling', 'deployment', 'management'],
'Kubernetes는 Pod 장애 시 자동 재시작, 노드 장애 시 다른 노드로 재스케줄링, 트래픽 증가 시 자동 스케일링 등을 지원합니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'dockerfile', 1, 1, 25,
'Docker 이미지를 빌드했는데 크기가 2GB가 넘습니다. 이미지 크기를 줄이면 어떤 이점이 있나요?',
'이미지 크기가 작으면 레지스트리 저장 비용 감소, 네트워크 전송 시간 단축, 컨테이너 시작 시간 개선, 보안 취약점 감소의 이점이 있습니다. alpine 같은 경량 베이스 이미지를 사용하면 5MB 정도로 줄일 수 있습니다.',
ARRAY['Docker image', 'image size', 'alpine', 'optimization', 'deployment speed'],
'이미지 크기 최적화: 경량 베이스 이미지, 멀티스테이지 빌드, 불필요 파일 제거(.dockerignore), 레이어 최소화.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'service', 1, 1, 25,
'Kubernetes에서 Pod IP가 재시작할 때마다 바뀌어서 다른 서비스에서 접근하기 어렵습니다. 안정적인 접근 방법은?',
'Kubernetes Service를 생성합니다. Service는 레이블 셀렉터로 Pod 그룹을 선택하고 안정적인 DNS 이름과 IP를 제공합니다. ClusterIP는 내부 접근용, NodePort/LoadBalancer는 외부 접근용입니다.',
ARRAY['Kubernetes Service', 'ClusterIP', 'stable endpoint', 'service discovery', 'DNS'],
'Service는 Pod가 재시작되어 IP가 변경되어도 같은 엔드포인트로 접근할 수 있게 해줍니다. 서비스 이름으로 DNS 해석도 가능합니다.',
'04-deployment-cicd.md');

-- 난이도 2 (8문제) - level_min=10, level_max=50
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'blue-green', 2, 10, 50,
'Blue-Green 배포와 Canary 배포의 차이점은 무엇이고, 어떤 상황에서 각각을 선택해야 하나요?',
'Blue-Green은 전체 트래픽을 한 번에 새 버전(Green)으로 전환하고, 문제 시 즉각적으로 구버전(Blue)으로 롤백합니다. Canary는 일부 트래픽(1%→5%→25%→100%)만 점진적으로 새 버전으로 이동하며 메트릭을 모니터링합니다. 빠른 전환과 롤백이 중요하면 Blue-Green, 점진적 검증이 중요하면 Canary를 선택합니다. Blue-Green은 두 배의 리소스가 필요합니다.',
ARRAY['Blue-Green', 'Canary', 'deployment strategy', 'traffic shifting', 'rollback'],
'Blue-Green은 즉각적인 전환과 롤백이 장점이지만 리소스 비용이 높습니다. Canary는 점진적 검증으로 위험을 줄이지만 복잡한 트래픽 관리가 필요합니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'multi-stage', 2, 10, 50,
'Dockerfile에서 빌드 도구(npm, maven)가 최종 이미지에 포함되어 이미지가 큽니다. 빌드 도구 없이 실행 파일만 포함하려면?',
'멀티스테이지 빌드를 사용합니다. 첫 번째 스테이지에서 빌드 도구로 애플리케이션을 빌드하고, 두 번째 스테이지에서 빌드 결과물만 경량 베이스 이미지에 복사합니다. 빌드 도구가 최종 이미지에 포함되지 않아 크기가 작아지고 보안이 향상됩니다.',
ARRAY['multi-stage build', 'Dockerfile', 'image optimization', 'build artifacts', 'distroless'],
'멀티스테이지 빌드: FROM node AS builder ... FROM alpine COPY --from=builder /app/dist /app',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'hpa', 2, 10, 50,
'트래픽이 급증할 때 수동으로 Pod 수를 늘리는 것이 번거롭습니다. 자동으로 스케일링하려면 어떻게 해야 하나요?',
'HPA(Horizontal Pod Autoscaler)를 설정합니다. CPU나 메모리 사용률 기반으로 Pod 수를 자동 조정합니다. 설정 시 주의점: Pod에 resource requests 설정 필수, 최소/최대 레플리카 수 적절히 지정, 급격한 스케일링 방지를 위한 안정화 기간 설정.',
ARRAY['HPA', 'Horizontal Pod Autoscaler', 'auto scaling', 'resource requests', 'metrics-server'],
'HPA는 metrics-server가 필요하며, Pod에 resource requests가 없으면 동작하지 않습니다. kubectl top pods로 현재 사용량을 확인할 수 있습니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'probe', 2, 10, 50,
'배포 후 Pod가 Running 상태인데 애플리케이션이 실제로 요청을 처리하지 못합니다. Kubernetes가 애플리케이션 준비 상태를 어떻게 알 수 있나요?',
'Readiness Probe와 Liveness Probe를 설정해야 합니다. Readiness Probe는 Pod가 트래픽을 받을 준비가 되었는지 확인하여, 준비되지 않으면 Service에서 제외합니다. Liveness Probe는 컨테이너가 살아있는지 확인하여, 응답이 없으면 재시작합니다.',
ARRAY['Readiness Probe', 'Liveness Probe', 'health check', 'Pod lifecycle', 'service endpoint'],
'Probe 종류: HTTP GET(엔드포인트 호출), TCP Socket(포트 연결), Exec(명령어 실행). initialDelaySeconds, periodSeconds, failureThreshold 등을 적절히 설정해야 합니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'configmap-secret', 2, 10, 50,
'데이터베이스 비밀번호를 코드에 하드코딩했다가 Git에 노출되었습니다. Kubernetes에서 민감 정보를 안전하게 관리하는 방법은?',
'Secret 리소스를 사용합니다. Secret은 비밀번호, 토큰, 키 등 민감 정보를 저장하고, Pod에 환경 변수나 볼륨 마운트로 주입합니다. 추가 보안: RBAC로 접근 제한, etcd 암호화 활성화, 외부 비밀 관리자(Vault, AWS Secrets Manager) 연동.',
ARRAY['Secret', 'ConfigMap', 'sensitive data', 'RBAC', 'secrets management'],
'Secret은 base64 인코딩(암호화 아님)됩니다. GitOps에서는 Sealed Secrets로 암호화하여 Git 저장하거나 External Secrets Operator를 사용합니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'layer-cache', 2, 10, 50,
'Docker 빌드 시 소스 코드만 변경했는데 npm install이 매번 다시 실행됩니다. 빌드 시간을 줄이려면 Dockerfile을 어떻게 수정해야 하나요?',
'레이어 캐싱을 활용합니다. 변경이 적은 package.json과 package-lock.json을 먼저 COPY하고 npm install을 실행한 후, 자주 변경되는 소스 코드를 나중에 COPY합니다. 의존성이 변경되지 않으면 npm install 레이어가 캐시에서 재사용됩니다.',
ARRAY['layer caching', 'Docker build', 'build optimization', 'npm install', 'Dockerfile'],
'잘못된 예: COPY . . && npm install (소스 변경마다 npm install 재실행) / 올바른 예: COPY package*.json . && npm install && COPY . .',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'rollback', 2, 10, 50,
'배포 후 에러율이 급증하여 빠르게 이전 버전으로 롤백해야 합니다. Kubernetes에서 롤백하는 방법은?',
'kubectl rollout undo deployment/<name> 명령으로 롤백합니다. Kubernetes는 이전 ReplicaSet을 보존하고 있어 새로 빌드/배포 없이 즉시 이전 Pod로 전환 가능합니다. revisionHistoryLimit으로 보관할 ReplicaSet 수를 설정할 수 있습니다.',
ARRAY['rollback', 'kubectl rollout undo', 'ReplicaSet', 'revision', 'deployment'],
'GitOps에서는 git revert 후 동기화하거나, ArgoCD에서 이전 버전으로 수동 Sync합니다. kubectl rollout history로 이전 배포 이력을 확인할 수 있습니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'depends-on', 2, 10, 50,
'docker-compose에서 depends_on으로 DB가 먼저 시작되도록 했는데, 애플리케이션이 DB 연결에 실패합니다. 왜 그런가요?',
'depends_on은 컨테이너 시작 순서만 보장하고, 애플리케이션 준비 상태는 보장하지 않습니다. DB 컨테이너가 시작되어도 MySQL/PostgreSQL이 실제로 연결을 받을 준비가 되기까지 시간이 걸립니다. healthcheck와 condition: service_healthy를 사용하거나, 애플리케이션에서 재시도 로직을 구현해야 합니다.',
ARRAY['depends_on', 'healthcheck', 'docker-compose', 'service dependency', 'startup order'],
'healthcheck 예: healthcheck: test: [CMD, pg_isready, -U, postgres] interval: 5s / depends_on: db: condition: service_healthy',
'04-deployment-cicd.md');

-- 난이도 3 (6문제) - level_min=30, level_max=75
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'gitops', 3, 30, 75,
'기존 CI/CD에서는 CI가 클러스터에 kubectl apply를 실행합니다. GitOps로 전환하면 어떤 점이 달라지나요?',
'Push 기반(CI가 클러스터에 배포) 대신 Pull 기반(클러스터가 Git에서 상태를 가져옴)으로 변경됩니다. 장점: 클러스터 자격증명을 CI에 노출하지 않음, Git 히스토리로 감사 추적, git revert로 쉬운 롤백, 재해 복구 용이(Git에서 전체 상태 복원). ArgoCD나 Flux 같은 도구가 Git 저장소를 모니터링하고 변경을 감지하여 클러스터에 적용합니다.',
ARRAY['GitOps', 'ArgoCD', 'Flux', 'pull-based', 'declarative', 'single source of truth'],
'GitOps 주의점: Secret 관리(Sealed Secrets/External Secrets), 동기화 지연 이해, 수동 변경 방지(Self-Heal), 대규모 클러스터 성능.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'network-policy', 3, 30, 75,
'Kubernetes 클러스터에서 기본적으로 모든 Pod가 서로 통신할 수 있습니다. 특정 Pod만 DB Pod에 접근하도록 제한하려면?',
'NetworkPolicy를 사용합니다. NetworkPolicy가 없으면 모든 트래픽이 허용되지만, 하나라도 적용되면 명시적으로 허용된 트래픽만 통과합니다(화이트리스트). podSelector로 대상 Pod를 지정하고, ingress 규칙에서 허용할 소스 Pod의 레이블을 지정합니다.',
ARRAY['NetworkPolicy', 'Pod security', 'traffic control', 'ingress', 'egress', 'namespace isolation'],
'NetworkPolicy 적용에는 CNI 플러그인(Calico, Cilium 등)이 지원해야 합니다. 기본 Kubernetes 네트워크는 지원하지 않을 수 있습니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'terraform-state', 3, 30, 75,
'Terraform을 여러 팀원이 함께 사용하는데, 동시에 terraform apply를 실행하면 충돌이 발생합니다. 어떻게 해결해야 하나요?',
'원격 백엔드(S3+DynamoDB, Terraform Cloud 등)를 사용하여 State를 공유하고 잠금(Locking)을 활성화해야 합니다. State 잠금은 동시 수정을 방지합니다. 추가 모범 사례: 환경별 State 분리, 민감 정보 암호화, 정기 백업, CI/CD에서만 apply 실행.',
ARRAY['Terraform', 'state', 'remote backend', 'state locking', 'S3', 'DynamoDB'],
'State에는 인프라의 현재 상태와 민감 정보가 포함됩니다. 로컬 State 파일은 팀 협업에 부적합하고 보안 위험이 있습니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'argo-rollouts', 3, 30, 75,
'Canary 배포 시 에러율이 임계값을 넘으면 자동으로 롤백하고 싶습니다. 어떤 도구와 설정이 필요한가요?',
'Argo Rollouts를 사용합니다. Analysis 리소스에서 Prometheus 메트릭 쿼리를 정의하고 성공 조건을 설정합니다. Canary 단계에서 Analysis를 실행하여 메트릭이 조건을 만족하지 않으면 자동으로 롤백합니다. Argo Rollouts는 Blue-Green, Canary 전략을 내장하고 Service Mesh와 통합됩니다.',
ARRAY['Argo Rollouts', 'Canary', 'automated rollback', 'analysis', 'Prometheus', 'progressive delivery'],
'Analysis 예: successCondition: result[0] < 0.05 (에러율 5% 미만) / Canary 단계: setWeight: 20, analysis: templates: - templateName: error-rate',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'container-security', 3, 30, 75,
'컨테이너를 root로 실행하면 보안에 취약하다고 합니다. 어떤 위험이 있고, 어떻게 방지해야 하나요?',
'컨테이너 탈출 취약점 발생 시 호스트의 root 권한을 얻을 수 있습니다. 방지책: 1) Dockerfile에서 USER 지시어로 non-root 사용자 지정 2) SecurityContext에서 runAsNonRoot: true, allowPrivilegeEscalation: false 설정 3) read-only 파일시스템(readOnlyRootFilesystem: true) 4) 불필요한 capabilities 제거.',
ARRAY['container security', 'non-root', 'SecurityContext', 'privilege escalation', 'capabilities'],
'추가 보안: seccomp 프로파일로 syscall 제한, AppArmor/SELinux MAC 적용, rootless Docker 또는 Podman 사용.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'pdb', 3, 30, 75,
'노드 업그레이드 중에 서비스 가용성이 떨어졌습니다. 최소 Pod 수를 보장하면서 노드 업그레이드를 하려면?',
'Pod Disruption Budget(PDB)을 설정합니다. minAvailable 또는 maxUnavailable로 자발적 중단(노드 업그레이드, drain) 시 최소 가용 Pod 수를 보장합니다. kubectl drain 시 PDB를 위반하면 대기합니다. 단, Pod가 충분히 분산되어 있어야 효과가 있습니다.',
ARRAY['Pod Disruption Budget', 'PDB', 'node upgrade', 'drain', 'availability', 'eviction'],
'PDB 예: minAvailable: 2 또는 maxUnavailable: 1. 비자발적 중단(노드 장애)에는 적용되지 않습니다.',
'04-deployment-cicd.md');

-- 난이도 4 (5문제) - level_min=50, level_max=100
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'multi-cluster', 4, 50, 100,
'글로벌 서비스를 여러 리전의 Kubernetes 클러스터에 배포해야 합니다. 배포 전략과 고려사항은 무엇인가요?',
'트래픽이 적은 리전부터 순차 배포하여 위험을 줄입니다. 고려사항: 1) 리전 간 의존성(DB 복제 지연) 2) 글로벌 Feature Flag로 기능 활성화 제어 3) 시간대별 배포 창 설정 4) 멀티 클러스터 GitOps(ArgoCD ApplicationSet) 또는 Flux 5) 글로벌 로드밸런서(Route53, CloudFlare)로 트래픽 제어. 변경 동결 기간(명절, 이벤트)에는 배포를 피합니다.',
ARRAY['multi-cluster', 'multi-region', 'global deployment', 'ApplicationSet', 'deployment window'],
'멀티 클러스터 관리: 중앙 집중식(하나의 ArgoCD가 여러 클러스터 관리) vs 분산(각 클러스터에 ArgoCD). 규모와 보안 요구사항에 따라 선택.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'supply-chain', 4, 50, 100,
'컨테이너 이미지 빌드부터 배포까지 공급망 보안을 강화하려면 어떤 조치가 필요한가요?',
'1) 이미지 서명(cosign)으로 이미지 무결성 검증 2) SBOM(syft)으로 소프트웨어 구성 요소 목록화 3) 취약점 스캐닝(Trivy)을 CI에 통합하여 취약한 이미지 배포 차단 4) 신뢰할 수 있는 베이스 이미지 사용 5) 정책 기반 어드미션 컨트롤(OPA Gatekeeper)로 서명되지 않은 이미지 거부 6) SLSA 프레임워크로 빌드 과정의 무결성과 출처 증명.',
ARRAY['supply chain security', 'image signing', 'cosign', 'SBOM', 'SLSA', 'vulnerability scanning', 'Trivy'],
'SLSA(Supply-chain Levels for Software Artifacts): 소프트웨어 공급망 보안 프레임워크로 빌드 과정의 무결성, 출처 증명, 변조 방지를 레벨별로 정의.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'db-migration', 4, 50, 100,
'배포 시 DB 스키마 변경이 포함되어 있습니다. 롤백 시에도 안전하게 처리하려면 어떤 패턴을 사용해야 하나요?',
'Expand and Contract 패턴을 사용합니다. 1) Expand: 새 컬럼/테이블 추가 (구 버전 호환) 2) 양쪽 쓰기: 구/신 컬럼 모두에 쓰기 3) 데이터 마이그레이션: 기존 데이터를 새 컬럼으로 복사 4) 새 컬럼만 읽기: 애플리케이션이 새 컬럼 사용 5) Contract: 구 컬럼 제거. 각 단계가 독립적으로 배포/롤백 가능하여 안전합니다.',
ARRAY['database migration', 'expand and contract', 'backward compatibility', 'schema change', 'rolling deployment'],
'위험한 스키마 변경(컬럼명 변경, 타입 변경, NOT NULL 추가)은 Expand and Contract로 여러 배포에 걸쳐 점진적으로 수행합니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'spot-instance', 4, 50, 100,
'Kubernetes 클러스터 비용을 절감하기 위해 Spot/Preemptible 인스턴스를 사용하려 합니다. 프로덕션에서 안전하게 사용하려면?',
'1) 중단 허용 워크로드(stateless, 배치)만 Spot 노드에 배치 (nodeSelector, tolerations) 2) PDB 설정으로 최소 가용성 보장 3) 온디맨드 노드 풀을 함께 유지하여 중요 워크로드 처리 4) 중단 핸들러(AWS Node Termination Handler)로 graceful shutdown 5) 여러 인스턴스 타입과 가용 영역에 분산하여 동시 중단 위험 감소.',
ARRAY['Spot instance', 'Preemptible', 'cost optimization', 'node pool', 'PDB', 'graceful shutdown'],
'Spot 인스턴스는 온디맨드 대비 70-90% 저렴하지만 2분 전 통보로 중단될 수 있습니다. 상태 유지 워크로드(DB)에는 사용하지 않습니다.',
'04-deployment-cicd.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('deployment', 'operator', 4, 50, 100,
'Kubernetes에서 복잡한 상태 유지 애플리케이션(예: Kafka, PostgreSQL)을 운영하는 데 많은 수동 작업이 필요합니다. 이를 자동화하는 패턴은?',
'Operator 패턴을 사용합니다. Operator는 Custom Resource Definition(CRD)과 Controller를 조합하여 도메인 지식을 코드화합니다. 예: PostgreSQL Operator는 KubernetesPostgresql CRD를 생성하면 복제, 백업, 페일오버, 업그레이드를 자동으로 관리합니다. 직접 개발하거나 커뮤니티 Operator(OperatorHub)를 사용할 수 있습니다.',
ARRAY['Operator', 'CRD', 'Custom Resource', 'Controller', 'stateful application', 'automation'],
'Operator 프레임워크: Operator SDK, Kubebuilder. 성숙한 Operator 예: Strimzi(Kafka), CloudNativePG(PostgreSQL), MongoDB Community Operator.',
'04-deployment-cicd.md');
