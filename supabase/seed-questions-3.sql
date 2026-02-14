-- seed-questions-3.sql
-- 모니터링/관측성 및 보안 분야 문제
--
-- 분야별 문제 수:
--   - monitoring (모니터링/관측성): 50문제
--     - 난이도 1: 15문제
--     - 난이도 2: 15문제
--     - 난이도 3: 12문제
--     - 난이도 4: 8문제
--   - security (보안): 50문제
--     - 난이도 1: 15문제
--     - 난이도 2: 15문제
--     - 난이도 3: 12문제
--     - 난이도 4: 8문제
--
-- 총 100문제

-- =====================================================
-- MONITORING (모니터링/관측성) - 50문제
-- =====================================================

-- 난이도 1 (입문) - 15문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('monitoring', '관측성 기초', 1, 1, 25,
'모니터링과 관측성(Observability)의 차이점을 설명해주세요.',
'모니터링은 미리 정의된 메트릭 임계값으로 알려진 문제를 감지하는 것이고, 관측성은 시스템의 외부 출력을 통해 알려지지 않은 문제도 조사할 수 있는 능력입니다. 관측성은 모니터링을 포함하는 더 넓은 개념입니다.',
ARRAY['모니터링', '관측성', '알려진 문제', '알려지지 않은 문제', '임계값'],
'관측성은 "임의의 질문에 답할 수 있는 능력"으로, 예상치 못한 상황에서도 시스템 상태를 파악할 수 있게 해줍니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '관측성 3요소', 1, 1, 25,
'관측성의 3가지 핵심 데이터 타입(Metrics, Logs, Traces)은 각각 어떤 역할을 하나요?',
'메트릭은 시간에 따른 수치 데이터로 시스템 상태 개요와 트렌드를 파악하고, 로그는 이벤트의 텍스트 기록으로 상세 디버깅에 사용하며, 트레이스는 분산 시스템에서 요청 경로를 추적합니다.',
ARRAY['메트릭', '로그', '트레이스', '수치 데이터', '이벤트 기록', '경로 추적'],
'세 가지를 연계하면 메트릭으로 "무엇이 문제인가", 로그로 "왜 문제인가", 트레이스로 "어디서 문제인가"를 파악할 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Prometheus', 1, 1, 25,
'Prometheus의 Pull 방식 메트릭 수집이란 무엇인가요?',
'Pull 방식은 Prometheus가 애플리케이션의 /metrics 엔드포인트에서 주기적으로 메트릭을 수집해오는 방식입니다. Push 방식과 달리 모니터링 대상의 상태를 쉽게 파악할 수 있고 중앙에서 제어할 수 있습니다.',
ARRAY['Pull', 'Push', '/metrics', '엔드포인트', '스크레이핑'],
'Push 방식은 애플리케이션이 메트릭을 전송하는 것으로, 방화벽 문제나 부하 제어가 어려울 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Prometheus', 1, 1, 25,
'Prometheus에서 exporter란 무엇인가요?',
'exporter는 Prometheus 형식의 메트릭을 노출하는 에이전트입니다. 애플리케이션이 직접 메트릭을 노출하지 못할 때 사용하며, node_exporter, mysqld_exporter, redis_exporter 등이 있습니다.',
ARRAY['exporter', 'node_exporter', '메트릭', '에이전트', 'Prometheus 형식'],
'exporter를 사용하면 기존 시스템을 수정하지 않고도 Prometheus로 모니터링할 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Grafana', 1, 1, 25,
'Grafana와 Prometheus의 관계를 설명해주세요.',
'Prometheus는 메트릭을 수집하고 저장하는 역할을 하고, Grafana는 시각화를 담당합니다. Grafana가 PromQL 쿼리를 Prometheus에 전송하고 결과를 시각화합니다. 둘은 보완적이며 함께 사용됩니다.',
ARRAY['Grafana', 'Prometheus', '시각화', 'PromQL', '메트릭'],
'Grafana는 Prometheus 외에도 Elasticsearch, InfluxDB 등 다양한 데이터소스를 지원합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'ELK Stack', 1, 1, 25,
'ELK Stack의 각 컴포넌트(Elasticsearch, Logstash, Kibana, Beats)의 역할을 설명해주세요.',
'Beats(Filebeat)는 로그 파일을 읽어 전송하고, Logstash는 필터링/파싱/변환을 수행하며, Elasticsearch는 인덱싱/저장/검색을 담당하고, Kibana는 시각화와 관리 UI를 제공합니다.',
ARRAY['Elasticsearch', 'Logstash', 'Kibana', 'Beats', 'Filebeat'],
'간단한 경우 Filebeat에서 Elasticsearch로 직접 연결하는 것도 가능합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '분산 트레이싱', 1, 1, 25,
'분산 트레이싱이 필요한 이유는 무엇인가요?',
'마이크로서비스에서 하나의 요청이 수십 개 서비스를 거칠 수 있어 로그만으로는 전체 흐름을 파악하기 어렵습니다. 트레이싱으로 어느 서비스에서 지연이 발생했는지, 에러가 어디서 시작됐는지 한눈에 파악할 수 있습니다.',
ARRAY['분산 트레이싱', '마이크로서비스', '트레이스', '스팬', '요청 추적'],
'Jaeger와 Zipkin은 대표적인 분산 트레이싱 시스템입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '분산 트레이싱', 1, 1, 25,
'트레이스(Trace)와 스팬(Span)의 관계를 설명해주세요.',
'트레이스는 하나의 요청에 대한 전체 경로를 나타내고, 스팬은 단일 작업 단위(서비스 호출, DB 쿼리 등)를 나타냅니다. 여러 스팬이 모여 하나의 트레이스를 구성합니다.',
ARRAY['트레이스', '스팬', '요청 경로', '작업 단위'],
'스팬은 시작/종료 시간, 태그, 로그, 부모 스팬 참조를 포함합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'OpenTelemetry', 1, 1, 25,
'OpenTelemetry를 사용해야 하는 이유는 무엇인가요?',
'OpenTelemetry는 벤더 중립적 관측성 표준으로, 벤더 락인을 방지하고 백엔드를 쉽게 교체할 수 있습니다. 일관된 계측 API, 자동 계측 지원, 활발한 커뮤니티가 장점입니다.',
ARRAY['OpenTelemetry', '벤더 중립', '표준', '계측', 'OTLP'],
'OpenTracing과 OpenCensus가 합쳐진 CNCF 프로젝트입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '알림 설계', 1, 1, 25,
'좋은 알림의 조건은 무엇인가요?',
'좋은 알림은 조치 가능(Actionable)하여 받았을 때 무엇을 해야 하는지 명확하고, 시의적절하게 문제 발생 직후 알려야 합니다. 컨텍스트를 포함하고 중복 없이 전달되어야 합니다.',
ARRAY['알림', '조치 가능', '컨텍스트', '알림 피로'],
'너무 많은 알림은 알림 피로(Alert Fatigue)를 유발하여 중요한 알림도 무시하게 만들 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'SLI/SLO/SLA', 1, 1, 25,
'SLI, SLO, SLA의 관계를 설명해주세요.',
'SLI는 "무엇을 측정하는가"(예: 정상 요청 비율), SLO는 "얼마나 좋아야 하는가"(예: 99.9%), SLA는 "못 지키면 어떻게 되는가"(예: 환불)입니다. SLI를 기반으로 SLO를 설정하고, SLA는 SLO보다 느슨하게 설정합니다.',
ARRAY['SLI', 'SLO', 'SLA', '가용성', '신뢰성'],
'SLA(Service Level Agreement)는 고객과의 계약으로, SLO 미달 시 보상을 명시합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'SLI/SLO/SLA', 1, 1, 25,
'99.9%와 99.99% 가용성의 실제 다운타임 차이는 얼마인가요?',
'99.9%(3 nines)는 연간 8.76시간 다운타임을 허용하고, 99.99%(4 nines)는 연간 52분 다운타임을 허용합니다. 0.09% 차이지만 허용 다운타임은 10배 차이입니다.',
ARRAY['가용성', '다운타임', 'nines', '99.9', '99.99'],
'높은 SLO는 복잡성과 비용 증가를 의미하므로 적절한 수준을 선택해야 합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Golden Signals', 1, 1, 25,
'Golden Signals 4가지를 설명해주세요.',
'Latency(지연)는 요청 처리 시간, Traffic(트래픽)은 요청량, Errors(에러)는 실패한 요청 비율, Saturation(포화)은 리소스 사용률입니다. 이 4가지로 대부분의 서비스 문제를 감지할 수 있습니다.',
ARRAY['Golden Signals', 'Latency', 'Traffic', 'Errors', 'Saturation'],
'Google SRE에서 정의한 핵심 모니터링 지표입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'APM', 1, 1, 25,
'APM이 일반 모니터링과 다른 점은 무엇인가요?',
'일반 모니터링은 인프라/시스템 레벨(CPU, 메모리)을 다루고, APM은 애플리케이션 레벨(트랜잭션, 코드 성능)을 다룹니다. APM은 어떤 API 호출에서 어떤 함수가 느린가까지 파악할 수 있습니다.',
ARRAY['APM', '트랜잭션', '코드 성능', '모니터링', '애플리케이션'],
'Datadog, New Relic, Sentry, Dynatrace 등이 대표적인 APM 도구입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '로그 수집', 1, 1, 25,
'왜 중앙 집중식 로깅이 필요한가요?',
'분산 시스템에서 각 서버에 SSH로 접속하여 로그를 확인하는 것은 비효율적입니다. 중앙 집중화하면 검색이 용이하고, 상관관계 분석이 가능하며, 장애 시에도 접근 가능하고, 보안/감사와 장기 보관이 가능합니다.',
ARRAY['중앙 집중식 로깅', '로그 수집', '분산 시스템', '로그 분석'],
'Filebeat, Fluentd, Promtail 등이 대표적인 로그 수집 도구입니다.',
'docs/05-monitoring-observability.md');

-- 난이도 2 (주니어) - 15문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('monitoring', '메트릭 타입', 2, 10, 50,
'Prometheus에서 Counter와 Gauge의 차이점을 설명해주세요.',
'Counter는 단조 증가하는 값(요청 수, 에러 수)으로 리셋되면 0부터 시작합니다. Gauge는 증감 가능한 현재 값(온도, 메모리 사용량)입니다. Counter는 rate()로 변화율을 계산하고, Gauge는 현재 값 자체가 의미 있습니다.',
ARRAY['Counter', 'Gauge', 'rate()', '메트릭 타입', 'Prometheus'],
'Counter에는 rate()나 increase()를 적용하고, Gauge에는 avg_over_time() 등을 적용합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '구조화 로그', 2, 10, 50,
'구조화 로그(Structured Logging)란 무엇이고 왜 중요한가요?',
'구조화 로그는 JSON 등 파싱 가능한 형식의 로그입니다. 검색/집계/분석이 용이하고, trace_id 등 컨텍스트를 쉽게 포함할 수 있습니다. 비구조화 로그는 정규식에 의존해야 해서 분석이 어렵습니다.',
ARRAY['구조화 로그', 'JSON', '로그 분석', 'trace_id', '파싱'],
'예시: {"level":"error","service":"api","user_id":123,"message":"..."}',
'docs/05-monitoring-observability.md'),

('monitoring', 'PromQL', 2, 10, 50,
'PromQL에서 rate()와 irate()의 차이점과 사용 시기를 설명해주세요.',
'rate()는 범위 내 전체 평균 증가율을 계산하여 그래프에 적합하고, irate()는 마지막 두 포인트의 순간 증가율로 급격한 변화를 감지합니다. 일반적으로 rate()를 사용하고 스파이크 분석 시 irate()를 사용합니다.',
ARRAY['rate()', 'irate()', 'PromQL', '증가율', 'Counter'],
'rate()는 Counter에만 사용해야 합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'PromQL', 2, 10, 50,
'Prometheus에서 Histogram과 Summary의 차이와 선택 기준을 설명해주세요.',
'Histogram은 버킷별 카운트로 서버 측 집계가 가능하고 여러 인스턴스를 합산할 수 있습니다. Summary는 클라이언트에서 분위수를 계산하여 정확하지만 집계가 불가합니다. 분산 시스템에서는 Histogram을 권장합니다.',
ARRAY['Histogram', 'Summary', '분위수', '버킷', '집계'],
'Histogram은 사전 정의된 버킷이 필요하고, Summary는 quantile을 클라이언트에서 계산합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Grafana', 2, 10, 50,
'Grafana에서 변수(Variables)의 용도를 설명해주세요.',
'변수를 사용하면 드롭다운으로 필터링 값을 선택하여 대시보드를 동적으로 변경할 수 있습니다. 예를 들어 서버나 환경을 선택할 수 있습니다. 쿼리로 변수 값을 자동 채울 수 있어 하나의 대시보드로 여러 상황에 대응할 수 있습니다.',
ARRAY['Grafana', '변수', 'Variables', '대시보드', '동적'],
'변수는 $variable 형식으로 쿼리에서 사용할 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'ELK Stack', 2, 10, 50,
'Grok 패턴이란 무엇인가요?',
'Grok은 정규식을 사람이 읽기 쉽게 추상화한 것입니다. 비구조화 로그를 구조화된 필드로 파싱합니다. 예: %{IP:client} %{WORD:method} %{URIPATHPARAM:request}처럼 사용합니다.',
ARRAY['Grok', '로그 파싱', '정규식', 'Logstash', 'Filebeat'],
'Logstash와 Filebeat에서 로그 파싱에 널리 사용됩니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Loki', 2, 10, 50,
'Loki가 Elasticsearch보다 저렴한 이유는 무엇인가요?',
'Loki는 로그 내용을 인덱싱하지 않고 라벨(메타데이터)만 인덱싱합니다. 스토리지와 인덱스 크기가 작아 비용이 크게 절감됩니다. 대신 로그 내용 검색은 풀스캔이 필요합니다.',
ARRAY['Loki', 'Elasticsearch', '라벨', '인덱싱', '비용'],
'Loki는 Grafana Labs에서 개발한 로그 집계 시스템으로 Prometheus에서 영감을 받았습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '분산 트레이싱', 2, 10, 50,
'트레이스 ID는 어떻게 서비스 간에 전파되나요?',
'HTTP의 경우 헤더에 포함됩니다. W3C Trace Context 표준은 traceparent 헤더를 사용하고, B3 포맷(Zipkin)은 X-B3-TraceId, X-B3-SpanId 헤더를 사용합니다. OpenTelemetry SDK가 자동으로 처리합니다.',
ARRAY['트레이스 ID', '컨텍스트 전파', 'W3C Trace Context', 'B3', 'OpenTelemetry'],
'gRPC 메타데이터, 메시지 큐 속성 등을 통해서도 전파할 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'OpenTelemetry', 2, 10, 50,
'OpenTelemetry Collector를 사용하는 이유는 무엇인가요?',
'Collector를 경유하면 버퍼링/재시도로 안정성이 향상되고, 다양한 백엔드로 동시 전송이 가능합니다. 필터링/변환 처리가 가능하고 애플리케이션 부담이 감소하며, 설정 변경이 애플리케이션 재배포 없이 가능합니다.',
ARRAY['OpenTelemetry', 'Collector', '버퍼링', '필터링', 'OTLP'],
'Collector는 receivers, processors, exporters로 파이프라인을 구성합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '알림 설계', 2, 10, 50,
'Alertmanager에서 알림 그룹화(Grouping)가 필요한 이유를 설명해주세요.',
'하나의 장애가 수십 개 알림을 발생시킬 수 있습니다. 그룹화하면 관련 알림을 하나의 알림으로 묶어 보냅니다. Alertmanager에서 group_by로 설정하며, 예를 들어 같은 서비스의 알림을 그룹화할 수 있습니다.',
ARRAY['Alertmanager', '그룹화', 'group_by', '알림', '알림 피로'],
'group_wait, group_interval, repeat_interval로 그룹화 동작을 제어합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '알림 설계', 2, 10, 50,
'알림 억제(Inhibition)란 무엇인가요?',
'상위 알림이 발생하면 하위 알림을 억제하는 기능입니다. 예를 들어 "서버 다운" 알림이 발생하면 해당 서버의 "서비스 응답 없음" 알림을 억제합니다. 중복 알림을 줄이고 근본 원인에 집중할 수 있습니다.',
ARRAY['억제', 'Inhibition', 'Alertmanager', '알림', '근본 원인'],
'Alertmanager의 inhibit_rules에서 설정합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'SLI/SLO/SLA', 2, 10, 50,
'좋은 SLI의 조건은 무엇인가요?',
'좋은 SLI는 사용자 경험과 직결되어야 합니다(서버 CPU가 아닌 응답 시간). 측정 가능해야 하고, 의미 있는 범위(0-100%)여야 하며, 비교 가능해야 합니다. 사용자가 인지하는 품질을 반영해야 합니다.',
ARRAY['SLI', '사용자 경험', '측정', '응답 시간', '품질'],
'일반적인 SLI로는 가용성, 지연 시간, 처리량, 에러율 등이 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'RED/USE', 2, 10, 50,
'RED Method와 USE Method의 차이와 언제 사용하는지 설명해주세요.',
'RED(Rate, Errors, Duration)는 서비스/엔드포인트별 모니터링에 사용하고, USE(Utilization, Saturation, Errors)는 CPU, 메모리, 디스크 등 리소스별 모니터링에 사용합니다. RED로 서비스 문제를 감지하고 USE로 원인을 분석합니다.',
ARRAY['RED', 'USE', 'Rate', 'Utilization', 'Saturation'],
'RED는 마이크로서비스, USE는 시스템 리소스 분석에 적합합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'APM', 2, 10, 50,
'APM에서 에러 그룹화(Error Grouping)의 원리를 설명해주세요.',
'같은 원인의 에러를 하나의 이슈로 그룹화합니다. 스택트레이스, 에러 메시지, 발생 위치를 기준으로 판단합니다. 100개의 동일 에러를 1개 이슈로 표시하여 관리를 용이하게 합니다.',
ARRAY['에러 그룹화', 'APM', 'Sentry', '스택트레이스', '이슈'],
'Sentry의 핵심 기능 중 하나입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '로그 수집', 2, 10, 50,
'로그 레벨(DEBUG, INFO, WARN, ERROR, FATAL)의 적절한 사용법을 설명해주세요.',
'DEBUG는 개발/디버깅용 상세 정보, INFO는 정상 동작 기록, WARN은 잠재적 문제로 복구 가능한 경우, ERROR는 에러 발생과 기능 실패, FATAL은 시스템 중단 상황입니다. 프로덕션은 INFO 이상만 기록하고 문제 시 DEBUG를 활성화합니다.',
ARRAY['로그 레벨', 'DEBUG', 'INFO', 'WARN', 'ERROR'],
'적절한 로그 레벨 사용은 디버깅 효율성과 로그 비용에 큰 영향을 미칩니다.',
'docs/05-monitoring-observability.md');

-- 난이도 3 (시니어) - 12문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('monitoring', '카디널리티', 3, 30, 75,
'메트릭에서 높은 카디널리티(Cardinality)가 문제가 되는 이유와 해결 방법을 설명해주세요.',
'메트릭의 레이블 조합이 많아지면 저장/쿼리 비용이 급증합니다. 예를 들어 user_id를 레이블로 사용하면 수백만 개 시계열이 생성됩니다. 해결책으로 레이블 값을 제한하고, 높은 카디널리티 데이터는 로그/트레이스로 이동하며, 집계 레벨을 조정합니다.',
ARRAY['카디널리티', '레이블', '시계열', '비용', '집계'],
'Prometheus의 확장성 한계 중 하나가 높은 카디널리티입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '트레이스 샘플링', 3, 30, 75,
'트레이스 샘플링 전략 중 Head-based와 Tail-based의 차이점을 설명해주세요.',
'Head-based(확률적)는 요청 시작 시 샘플링을 결정하여 단순하지만 중요 트레이스 누락이 가능합니다. Tail-based는 요청 완료 후 결정하여 에러/지연 발생 트레이스만 저장할 수 있지만 구현이 복잡합니다. 하이브리드 방식으로 중요 경로는 100%, 나머지는 샘플링하는 것이 권장됩니다.',
ARRAY['샘플링', 'Head-based', 'Tail-based', '트레이스', 'OpenTelemetry'],
'OpenTelemetry Collector는 tail_sampling 프로세서를 통해 테일 기반 샘플링을 지원합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Prometheus 확장', 3, 30, 75,
'Prometheus의 확장성 제한과 해결 방법(Thanos, Cortex)을 설명해주세요.',
'Prometheus는 단일 노드 아키텍처로 수평 확장이 불가하고, 메모리 내 인덱스로 시계열 수가 제한되며, 로컬 스토리지로 장기 보관이 어렵습니다. Thanos나 Cortex로 장기 저장 및 글로벌 뷰를 제공하고, Federation으로 계층화할 수 있습니다.',
ARRAY['Prometheus', 'Thanos', 'Cortex', '확장성', 'Federation'],
'Thanos는 사이드카 방식으로 도입이 쉽고, Cortex는 완전 분산 아키텍처로 대규모 멀티테넌트에 적합합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Elasticsearch', 3, 30, 75,
'Elasticsearch의 ILM(Index Lifecycle Management) 단계를 설명해주세요.',
'Hot은 활발한 쓰기/읽기로 빠른 스토리지를 사용하고, Warm은 읽기 위주로 느린 스토리지를, Cold는 거의 접근하지 않는 저렴한 스토리지를, Delete는 삭제 단계입니다. 정책으로 자동 전환하여 비용을 최적화합니다.',
ARRAY['ILM', 'Elasticsearch', 'Hot', 'Warm', 'Cold'],
'시간 기반이나 용량 기반 조건으로 단계를 전환할 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'Loki 아키텍처', 3, 30, 75,
'Loki의 주요 아키텍처 컴포넌트를 설명해주세요.',
'Distributor는 쓰기 요청을 분배하고, Ingester는 청크를 생성/저장합니다. Querier는 읽기 쿼리를 처리하고, Query Frontend는 쿼리 스케줄링/캐싱을 담당합니다. Compactor는 인덱스를 압축합니다. 단일 바이너리 또는 마이크로서비스 모드로 운영할 수 있습니다.',
ARRAY['Loki', 'Distributor', 'Ingester', 'Querier', 'Compactor'],
'대규모 환경에서는 마이크로서비스 모드로 배포하여 읽기/쓰기 경로를 분리합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'SLO 기반 알림', 3, 30, 75,
'SLO 기반 알림과 번 레이트(Burn Rate) 알림을 설명해주세요.',
'SLO 기반 알림은 에러 버짓 소진율을 기반으로 알림합니다. 예를 들어 "현재 속도로 28일 에러 버짓이 3일 내 소진" 시 알림합니다. 비즈니스 영향과 연계되어 더 의미 있는 알림입니다. 번 레이트 1은 정확히 예산대로 소비, 2는 2배 속도로 소비합니다.',
ARRAY['SLO', '번 레이트', '에러 버짓', '알림', 'Burn Rate'],
'Google SRE Workbook에서 자세히 설명하고 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'OpenTelemetry Collector', 3, 30, 75,
'OpenTelemetry Collector 배포 패턴(사이드카, 데몬셋, 게이트웨이)의 장단점을 설명해주세요.',
'사이드카는 각 Pod에 Collector를 배치하여 격리가 좋지만 리소스 오버헤드가 있습니다. 데몬셋은 노드당 하나로 효율적이지만 노드 장애 시 영향이 있습니다. 게이트웨이는 중앙 집중으로 관리가 용이하지만 병목이 될 수 있습니다. 대규모 환경은 에이전트에서 게이트웨이로 계층화합니다.',
ARRAY['OpenTelemetry', 'Collector', '사이드카', '데몬셋', '게이트웨이'],
'각 패턴은 격리, 효율성, 관리 용이성 측면에서 트레이드오프가 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '에러 버짓', 3, 30, 75,
'에러 버짓(Error Budget)이란 무엇이고 어떻게 활용하나요?',
'에러 버짓은 1 - SLO입니다. 99.9% SLO면 0.1% 에러 버짓입니다. 30일 기준 1,000,000 요청이면 1,000개 에러를 허용합니다. 버짓 내에서 기능 개발 속도와 안정성의 균형을 맞추고, 버짓이 소진되면 안정성 작업에 집중합니다.',
ARRAY['에러 버짓', 'SLO', '기능 개발', '안정성', '신뢰성'],
'에러 버짓은 개발팀과 운영팀 간의 협력을 위한 공통 언어가 됩니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'APM 프로파일링', 3, 30, 75,
'프로덕션 환경에서 프로파일링 시 고려사항을 설명해주세요.',
'오버헤드는 1-5% 수준으로 허용해야 하고, 샘플링으로 영향을 최소화합니다. 민감 데이터는 마스킹하고, 연속 프로파일링과 온디맨드 방식 중 선택합니다. Datadog Continuous Profiler, Pyroscope 등을 사용하며, 코드 레벨 병목 발견에 필수적입니다.',
ARRAY['프로파일링', 'APM', '오버헤드', '샘플링', 'Pyroscope'],
'프로파일링은 CPU, 메모리, 락 경합 등 다양한 영역에서 수행할 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '로그 파이프라인', 3, 30, 75,
'로그 파이프라인에서 배압(Backpressure) 처리 방법을 설명해주세요.',
'수신 측이 처리하지 못할 때 송신 측을 조절합니다. 전략으로는 버퍼링(메모리/디스크), 드롭(덜 중요한 로그), 속도 제한, 백오프가 있습니다. Fluentd의 buffer나 Kafka의 자연스러운 배압을 활용합니다. 로그 유실과 시스템 안정성 사이의 트레이드오프가 있습니다.',
ARRAY['배압', 'Backpressure', '버퍼링', 'Fluentd', 'Kafka'],
'대용량 로그 파이프라인에서 안정적인 운영을 위해 필수적인 개념입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '이상 탐지', 3, 30, 75,
'시계열 분해(Decomposition)란 무엇이고 이상 탐지에 어떻게 활용하나요?',
'시계열을 트렌드(장기 방향), 계절성(주기적 패턴), 잔차(노이즈)로 분리합니다. STL, Prophet 등을 사용합니다. 잔차에서 이상 탐지를 하면 계절성에 속지 않습니다. 주간 트래픽 패턴이 있어도 정확한 탐지가 가능합니다.',
ARRAY['시계열 분해', 'STL', 'Prophet', '계절성', '이상 탐지'],
'트렌드, 계절성, 잔차를 분리하면 각각의 특성을 독립적으로 분석할 수 있습니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '알림 품질', 3, 30, 75,
'알림 품질을 측정하는 지표들을 설명해주세요.',
'MTTA(Mean Time To Acknowledge)는 알림 확인까지 시간, MTTR은 해결까지 시간입니다. 거짓 양성률은 조치 불필요한 알림 비율, 알림당 조치 비율은 실제 조치로 이어진 비율입니다. 90% 이상 조치 가능해야 건강한 알림 시스템입니다.',
ARRAY['MTTA', 'MTTR', '거짓 양성', '알림 품질', '조치 가능'],
'정기적인 알림 리뷰를 통해 알림 품질을 지속적으로 개선해야 합니다.',
'docs/05-monitoring-observability.md');

-- 난이도 4 (리드/CTO) - 8문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('monitoring', '관측성 플랫폼', 4, 50, 100,
'대규모 조직에서 관측성 플랫폼 선택 시 고려해야 할 기준을 설명해주세요.',
'규모와 비용(SaaS vs 자체 운영), 통합 용이성(기존 스택, OpenTelemetry 지원), 기능(APM, 인프라, 로그 통합), 쿼리 성능, 데이터 보존 정책, 팀 역량을 고려합니다. 대기업은 하이브리드(중요 데이터 자체 운영 + SaaS)를 고려합니다.',
ARRAY['관측성', '플랫폼', 'SaaS', '비용', '통합'],
'단순 기능 비교보다 조직의 성숙도와 운영 역량을 고려한 선택이 중요합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '비용 최적화', 4, 50, 100,
'관측성 시스템의 비용 최적화 전략을 설명해주세요.',
'샘플링 적용(트레이스 1-10%), 로그 레벨 조정(프로덕션은 INFO 이상), 메트릭 카디널리티 제한, 핫/콜드 티어링(오래된 데이터 저렴한 스토리지), 불필요한 텔레메트리 제거, 집계 전 필터링을 적용합니다.',
ARRAY['비용 최적화', '샘플링', '티어링', '카디널리티', '텔레메트리'],
'관측성 비용은 데이터 볼륨에 비례하므로 수집 단계에서 최적화가 가장 효과적입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '멀티클러스터 모니터링', 4, 50, 100,
'멀티클러스터/멀티리전 환경에서 Prometheus 설계 전략을 설명해주세요.',
'클러스터당 Prometheus를 운영하고 Thanos Query로 글로벌 뷰를 제공합니다. external_labels로 클러스터를 식별하고, 교차 클러스터 알림은 중앙 Alertmanager를 사용합니다. 또는 remote_write로 중앙 집중화할 수 있습니다.',
ARRAY['멀티클러스터', 'Thanos', 'external_labels', 'Alertmanager', 'remote_write'],
'각 클러스터의 자율성과 글로벌 뷰 사이의 균형을 고려해야 합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'SLO 프로그램', 4, 50, 100,
'조직에 SLO를 도입하는 전략을 설명해주세요.',
'핵심 서비스부터 시작하고, 현재 성능 기반으로 초기 SLO를 설정합니다. 측정 인프라를 구축하고 정기 리뷰로 SLO를 조정합니다. 에러 버짓을 팀 결정에 연계하고 경영진 지원을 확보합니다. 완벽한 SLO보다 시작이 중요합니다.',
ARRAY['SLO', '에러 버짓', '도입 전략', '신뢰성', '조직'],
'SLO는 기술적 지표를 넘어 조직 문화와 의사결정 방식에 영향을 미칩니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'OpenTelemetry 전환', 4, 50, 100,
'기존 시스템에서 OpenTelemetry로 마이그레이션하는 전략을 설명해주세요.',
'단계적 접근을 합니다. 1) Collector를 배포하여 기존 데이터를 수집합니다. 2) 새 서비스부터 OTel SDK를 사용합니다. 3) 기존 서비스를 점진적으로 전환합니다. 4) 기존 SDK를 제거합니다. 자동 계측으로 빠르게 시작하고 이후 수동 계측으로 개선합니다.',
ARRAY['OpenTelemetry', '마이그레이션', 'Collector', 'SDK', '점진적 전환'],
'Big bang 전환보다 점진적 접근이 위험을 줄이고 학습 기회를 제공합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '대시보드 거버넌스', 4, 50, 100,
'조직에서 대시보드 표준화 방법을 설명해주세요.',
'대시보드 템플릿을 제공하고 명명 규칙을 정의합니다. 폴더 구조를 표준화하고 대시보드 리뷰 프로세스를 도입합니다. 사용하지 않는 대시보드를 정리하고 문서화합니다. 플랫폼 팀이 관리하고 서비스 팀이 활용하는 구조를 권장합니다.',
ARRAY['대시보드', '거버넌스', '표준화', 'Grafana', '템플릿'],
'너무 많은 대시보드는 혼란, 유지보수 부담, 일관성 부족을 야기합니다.',
'docs/05-monitoring-observability.md'),

('monitoring', 'AIOps', 4, 50, 100,
'AIOps 도입 전략과 주의점을 설명해주세요.',
'점진적으로 도입합니다. 1) 데이터 수집/정리. 2) 단순 이상 탐지 시작. 3) 알림 노이즈 감소. 4) 근본 원인 분석. 5) 자동 복구. 기대 관리가 중요하며, 완전 자동화는 먼 목표입니다. 인간 판단 보조로 시작해야 합니다.',
ARRAY['AIOps', '이상 탐지', '자동화', '근본 원인 분석', 'ML'],
'AIOps는 기존 관측성 시스템의 성숙도가 전제되어야 효과적입니다.',
'docs/05-monitoring-observability.md'),

('monitoring', '온콜 문화', 4, 50, 100,
'건강한 온콜 문화를 만드는 방법을 설명해주세요.',
'공정한 로테이션, 적절한 보상, 알림 품질 관리, 충분한 런북을 제공합니다. 비난 없는 포스트모템을 진행하고 온콜 피드백 루프를 만듭니다. 알림 개선 시간을 확보하고 번아웃을 방지합니다. 온콜이 학습 기회가 되도록 설계합니다.',
ARRAY['온콜', '포스트모템', '런북', '번아웃', '알림 품질'],
'온콜 경험은 조직의 운영 성숙도를 나타내는 중요한 지표입니다.',
'docs/05-monitoring-observability.md');

-- =====================================================
-- SECURITY (보안) - 50문제
-- =====================================================

-- 난이도 1 (입문) - 15문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('security', '인증과 인가', 1, 1, 25,
'인증(Authentication)과 인가(Authorization)의 차이를 설명해주세요.',
'인증은 건물 입구에서 신분증을 확인하는 것처럼 "누구인지" 확인하는 과정이고, 인가는 특정 층이나 방에 들어갈 수 있는 출입 권한을 확인하는 것처럼 "무엇을 할 수 있는지" 결정하는 과정입니다.',
ARRAY['인증', '인가', 'Authentication', 'Authorization', '권한'],
'HTTP 상태 코드에서 401은 인증 실패, 403은 인가 실패를 의미합니다.',
'docs/06-security.md'),

('security', '인증과 인가', 1, 1, 25,
'세션 기반 인증과 토큰 기반 인증의 기본 차이점을 설명해주세요.',
'세션은 서버에 상태를 저장하고 세션 ID만 클라이언트에 전달합니다. 토큰(JWT 등)은 클라이언트에 정보를 담아 서버가 stateless하게 동작합니다.',
ARRAY['세션', '토큰', 'JWT', 'stateless', '인증'],
'세션은 서버 확장 시 세션 공유가 필요하고, 토큰은 발급 후 무효화가 어렵습니다.',
'docs/06-security.md'),

('security', 'MFA', 1, 1, 25,
'MFA(다중 인증)의 세 가지 인증 요소를 설명해주세요.',
'지식(Something you know)은 비밀번호나 PIN, 소유(Something you have)는 휴대폰이나 하드웨어 키, 생체(Something you are)는 지문이나 얼굴입니다. 2개 이상의 요소를 조합하여 보안을 강화합니다.',
ARRAY['MFA', '다중 인증', '지식', '소유', '생체'],
'비밀번호만으로는 유출, 추측, 피싱에 취약하므로 MFA가 권장됩니다.',
'docs/06-security.md'),

('security', 'OWASP', 1, 1, 25,
'OWASP Top 10이란 무엇인가요?',
'OWASP Top 10은 가장 위험한 웹 취약점 목록입니다. 개발자라면 기본으로 알아야 할 보안 지식이며, 주요 위협으로는 인젝션, 인증 실패, 민감 데이터 노출 등이 있습니다.',
ARRAY['OWASP', 'Top 10', '취약점', '웹 보안', '인젝션'],
'실제 공격의 대부분이 이 목록의 취약점을 이용하므로 우선적으로 대응해야 합니다.',
'docs/06-security.md'),

('security', '암호화', 1, 1, 25,
'암호화(Encryption)와 해시(Hash)의 차이점을 설명해주세요.',
'암호화는 키로 복호화하여 원본을 복구할 수 있는 양방향 변환이고, 해시는 단방향 변환으로 원본 복구가 불가능합니다. 비밀번호는 해시로 저장하고, 데이터 전송은 암호화를 사용합니다.',
ARRAY['암호화', '해시', '복호화', '단방향', '양방향'],
'비밀번호를 암호화하면 키가 유출될 때 모든 비밀번호가 노출되므로 해시를 사용합니다.',
'docs/06-security.md'),

('security', '암호화', 1, 1, 25,
'대칭키 암호화와 비대칭키 암호화의 차이점을 설명해주세요.',
'대칭키는 암호화와 복호화에 같은 키를 사용하고(AES), 비대칭키는 공개키와 개인키 쌍을 사용합니다(RSA). 대칭키는 빠르고, 비대칭키는 키 교환이 안전합니다.',
ARRAY['대칭키', '비대칭키', 'AES', 'RSA', '공개키'],
'실제로는 비대칭키로 대칭키를 교환하고, 대칭키로 데이터를 암호화하는 하이브리드 방식을 사용합니다.',
'docs/06-security.md'),

('security', '시크릿 관리', 1, 1, 25,
'시크릿을 코드에 하드코딩하면 안 되는 이유는 무엇인가요?',
'Git 히스토리에 영구 기록되고, 소스 코드 유출 시 시크릿도 노출됩니다. 또한 환경별로 다른 시크릿을 사용할 수 없습니다. 대신 환경 변수나 시크릿 관리 도구를 사용해야 합니다.',
ARRAY['시크릿', '하드코딩', 'Git', '환경 변수', '보안'],
'.env 파일을 Git에 커밋하면 시크릿이 히스토리에 남아 삭제해도 복구 가능합니다.',
'docs/06-security.md'),

('security', '네트워크 보안', 1, 1, 25,
'방화벽만 있으면 안전한가요?',
'아닙니다. 방화벽은 네트워크 경계만 보호합니다. 내부 공격, 애플리케이션 취약점, 인증 우회 등은 다른 보안 레이어가 필요합니다. 심층 방어(Defense in Depth) 전략이 필요합니다.',
ARRAY['방화벽', '심층 방어', '네트워크 보안', '경계', '레이어'],
'VPN, WAF, 인증, 암호화 등 여러 보안 계층을 조합해야 합니다.',
'docs/06-security.md'),

('security', '네트워크 보안', 1, 1, 25,
'VPN이 필요한 이유는 무엇인가요?',
'인터넷은 공용 네트워크라 트래픽이 도청될 수 있습니다. VPN은 암호화된 터널을 만들어 안전하게 내부 네트워크에 연결합니다. 원격 근무 시 회사 자원에 안전하게 접근할 수 있습니다.',
ARRAY['VPN', '암호화', '터널', '원격 접속', '네트워크'],
'VPN은 사용자와 네트워크 사이의 모든 트래픽을 암호화합니다.',
'docs/06-security.md'),

('security', '컨테이너 보안', 1, 1, 25,
'컨테이너를 root 사용자로 실행하면 안 되는 이유는 무엇인가요?',
'컨테이너 탈출(escape) 취약점 발생 시 root 권한으로 호스트에 접근할 수 있습니다. non-root로 실행하면 탈출하더라도 피해를 최소화할 수 있습니다.',
ARRAY['컨테이너', 'root', 'non-root', '보안', '권한'],
'Dockerfile에서 USER 지시어로 non-root 사용자를 지정해야 합니다.',
'docs/06-security.md'),

('security', '컨테이너 보안', 1, 1, 25,
'컨테이너가 VM보다 보안이 약한 이유는 무엇인가요?',
'컨테이너는 호스트 커널을 공유하므로 커널 취약점이 있으면 모든 컨테이너에 영향을 미칩니다. VM은 하이퍼바이저로 완전히 격리되어 있습니다.',
ARRAY['컨테이너', 'VM', '커널', '격리', '하이퍼바이저'],
'컨테이너는 이식성이 높지만 보안 측면에서 추가적인 조치가 필요합니다.',
'docs/06-security.md'),

('security', '컴플라이언스', 1, 1, 25,
'개발자도 컴플라이언스(규정 준수)를 알아야 하나요?',
'예, 개인정보 처리, 데이터 암호화, 접근 로깅 등 많은 요구사항이 코드와 인프라에 구현되어야 합니다. GDPR, 개인정보보호법 등의 기본 개념을 알아야 합니다.',
ARRAY['컴플라이언스', 'GDPR', '개인정보', '규정 준수', '암호화'],
'컴플라이언스 위반은 법적 제재와 평판 손상으로 이어질 수 있습니다.',
'docs/06-security.md'),

('security', '사고 대응', 1, 1, 25,
'보안 사고 발견 시 첫 번째로 해야 할 행동은 무엇인가요?',
'침착하게 상황을 파악하고, 보안팀이나 매니저에게 즉시 보고합니다. 증거(로그, 스크린샷)를 보존하고, 임의로 조치하지 않아 증거 훼손을 방지합니다.',
ARRAY['보안 사고', '대응', '보고', '증거 보존', '로그'],
'로그는 증거이므로 함부로 삭제하면 안 됩니다.',
'docs/06-security.md'),

('security', '인젝션', 1, 1, 25,
'SQL Injection 공격이란 무엇인가요?',
'사용자 입력이 SQL 쿼리의 일부로 해석되어 의도하지 않은 쿼리가 실행되는 공격입니다. 예를 들어 OR 1=1 입력으로 인증을 우회할 수 있습니다. Prepared Statement로 방어합니다.',
ARRAY['SQL Injection', '인젝션', 'Prepared Statement', '입력 검증', '쿼리'],
'사용자 입력을 절대로 쿼리 문자열에 직접 연결하면 안 됩니다.',
'docs/06-security.md'),

('security', 'XSS', 1, 1, 25,
'XSS(Cross-Site Scripting) 공격이란 무엇인가요?',
'악성 스크립트를 웹 페이지에 삽입하여 다른 사용자의 브라우저에서 실행시키는 공격입니다. 종류로는 Stored(저장형), Reflected(반사형), DOM-based가 있습니다. 출력 시 HTML 인코딩으로 방어합니다.',
ARRAY['XSS', 'Cross-Site Scripting', '스크립트', 'HTML 인코딩', 'CSP'],
'HttpOnly 쿠키와 CSP 헤더도 XSS 방어에 도움이 됩니다.',
'docs/06-security.md');

-- 난이도 2 (주니어) - 15문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('security', '인증', 2, 10, 50,
'세션 기반 인증과 토큰 기반 인증의 장단점을 비교해주세요.',
'세션은 서버에서 무효화가 쉽지만 서버 확장 시 세션 공유가 필요합니다(Redis 등). 토큰은 stateless로 확장이 용이하지만 발급 후 무효화가 어렵습니다(만료까지 유효).',
ARRAY['세션', '토큰', 'stateless', 'Redis', '무효화'],
'로그아웃 시 JWT를 무효화하려면 블랙리스트나 짧은 만료 시간 + Refresh Token 전략이 필요합니다.',
'docs/06-security.md'),

('security', '비밀번호', 2, 10, 50,
'비밀번호를 해시할 때 MD5나 SHA-256 대신 bcrypt를 사용해야 하는 이유는 무엇인가요?',
'MD5나 SHA-256은 빠르게 설계되어 GPU로 초당 수십억 번 해시할 수 있어 brute force 공격에 취약합니다. bcrypt, argon2, scrypt는 의도적으로 느리게 설계되어 공격 비용을 높입니다.',
ARRAY['bcrypt', 'SHA-256', 'MD5', '해시', 'brute force'],
'bcrypt의 work factor(cost)를 조절하여 해시 속도를 제어할 수 있습니다.',
'docs/06-security.md'),

('security', '비밀번호', 2, 10, 50,
'Salt와 Pepper의 차이점을 설명해주세요.',
'Salt는 각 비밀번호마다 다른 랜덤 값으로 DB에 함께 저장하여 레인보우 테이블 공격을 방지합니다. Pepper는 모든 비밀번호에 동일하게 적용하는 비밀 키로 코드나 환경변수에 저장합니다.',
ARRAY['Salt', 'Pepper', '해시', '레인보우 테이블', '비밀번호'],
'Salt는 공개되어도 무방하지만, Pepper는 반드시 비밀로 유지해야 합니다.',
'docs/06-security.md'),

('security', 'OWASP', 2, 10, 50,
'IDOR(Insecure Direct Object Reference) 공격이란 무엇이고 어떻게 방어하나요?',
'URL이나 파라미터의 식별자를 변경하여 다른 사용자의 리소스에 접근하는 공격입니다. 예: /user/123을 /user/124로 변경. 방어: 모든 요청에서 리소스 소유권을 확인합니다.',
ARRAY['IDOR', '접근 제어', '권한', '소유권', 'OWASP'],
'서버 측에서 현재 사용자가 해당 리소스에 접근 권한이 있는지 항상 검증해야 합니다.',
'docs/06-security.md'),

('security', 'CSRF', 2, 10, 50,
'CSRF(Cross-Site Request Forgery) 공격과 방어 방법을 설명해주세요.',
'사용자가 인증된 상태에서 악성 사이트가 요청을 위조하여 전송하는 공격입니다. 방어: 1) CSRF 토큰 검증, 2) SameSite 쿠키 속성, 3) Referer/Origin 헤더 검증을 사용합니다.',
ARRAY['CSRF', 'SameSite', 'CSRF 토큰', '쿠키', 'Referer'],
'SameSite=Strict 또는 SameSite=Lax 쿠키 속성으로 대부분의 CSRF를 방어할 수 있습니다.',
'docs/06-security.md'),

('security', '암호화', 2, 10, 50,
'AES의 CBC와 GCM 모드의 차이점을 설명해주세요.',
'CBC는 암호화만 제공하고 별도의 MAC이 필요합니다. GCM은 암호화와 인증(무결성 검증)을 동시에 제공하여 더 안전합니다. 현대 시스템에서는 GCM이 권장됩니다.',
ARRAY['AES', 'CBC', 'GCM', 'AEAD', '무결성'],
'GCM은 AEAD(Authenticated Encryption with Associated Data) 모드입니다.',
'docs/06-security.md'),

('security', '암호화 키', 2, 10, 50,
'암호화 키를 코드에 하드코딩하면 안 되는 이유와 대안을 설명해주세요.',
'소스 코드 유출 시 키가 노출되고, 키 교체가 어려우며, 환경별 키 분리가 불가합니다. 대신 환경변수, HashiCorp Vault, 클라우드 KMS를 사용해야 합니다.',
ARRAY['암호화 키', '하드코딩', 'Vault', 'KMS', '환경변수'],
'키 관리는 암호화만큼 중요한 보안 요소입니다.',
'docs/06-security.md'),

('security', '시크릿 관리', 2, 10, 50,
'시크릿이 Git에 커밋된 것을 발견하면 어떻게 해야 하나요?',
'1) 즉시 시크릿을 교체합니다(가장 중요). 2) 해당 시크릿으로 수행된 작업을 감사합니다. 3) Git 히스토리를 정리합니다(git filter-branch, BFG). 4) pre-commit 훅으로 재발을 방지합니다.',
ARRAY['시크릿', 'Git', '교체', 'pre-commit', '히스토리'],
'Git 히스토리에서 삭제해도 이미 노출된 시크릿은 반드시 교체해야 합니다.',
'docs/06-security.md'),

('security', '네트워크 보안', 2, 10, 50,
'WAF(Web Application Firewall)와 일반 방화벽의 차이점을 설명해주세요.',
'일반 방화벽(L3/L4)은 IP와 포트만 확인합니다. WAF(L7)는 HTTP 내용을 분석하여 SQL Injection, XSS 등 애플리케이션 공격을 탐지하고 차단합니다.',
ARRAY['WAF', '방화벽', 'L7', 'SQL Injection', 'XSS'],
'WAF는 OWASP Top 10 공격에 대한 규칙을 제공하는 경우가 많습니다.',
'docs/06-security.md'),

('security', '네트워크 보안', 2, 10, 50,
'DDoS 공격 유형과 방어 방법을 설명해주세요.',
'유형: 1) Volumetric(대역폭 소진), 2) Protocol(SYN flood 등), 3) Application(HTTP flood). 방어: CDN으로 흡수, Rate limiting, 자동 스케일링, 전문 DDoS 방어 서비스를 사용합니다.',
ARRAY['DDoS', 'CDN', 'Rate limiting', 'SYN flood', '대역폭'],
'대규모 볼류메트릭 공격은 Rate limiting만으로 방어할 수 없습니다.',
'docs/06-security.md'),

('security', '컨테이너 보안', 2, 10, 50,
'컨테이너 이미지 취약점 스캔 방법을 설명해주세요.',
'Trivy, Snyk, Clair 등의 도구로 이미지에 포함된 패키지의 알려진 취약점을 탐지합니다. CI/CD 파이프라인에 통합하여 빌드 시 자동으로 스캔하고, 심각한 취약점이 있으면 배포를 차단합니다.',
ARRAY['Trivy', 'Snyk', '이미지 스캔', '취약점', 'CI/CD'],
'예: trivy image --exit-code 1 --severity HIGH,CRITICAL myapp:latest',
'docs/06-security.md'),

('security', '컨테이너 보안', 2, 10, 50,
'Dockerfile에서 보안 모범 사례를 설명해주세요.',
'1) 공식/검증된 베이스 이미지 사용, 2) 특정 버전 태그 사용(latest 지양), 3) USER로 non-root 실행, 4) COPY 시 필요한 파일만 복사, 5) 시크릿을 이미지에 포함하지 않습니다.',
ARRAY['Dockerfile', '베이스 이미지', 'non-root', 'USER', '보안'],
'멀티 스테이지 빌드로 빌드 도구를 제외하고 최종 이미지를 축소할 수 있습니다.',
'docs/06-security.md'),

('security', '의존성 보안', 2, 10, 50,
'의존성 취약점 관리 전략을 설명해주세요.',
'1) CI/CD에 의존성 스캔을 통합합니다(Snyk, Trivy). 2) Dependabot으로 자동 PR을 생성합니다. 3) 취약점 심각도별 대응 SLA를 정합니다. 4) SBOM을 생성하여 구성 요소를 추적합니다.',
ARRAY['의존성', 'Dependabot', 'SBOM', 'Snyk', '취약점'],
'취약한 컴포넌트 사용은 OWASP Top 10의 A06입니다.',
'docs/06-security.md'),

('security', 'GDPR', 2, 10, 50,
'GDPR에서 개발자가 알아야 할 핵심 사항을 설명해주세요.',
'1) 개인정보 수집 시 명시적 동의, 2) 삭제 요청 대응(잊힐 권리), 3) 데이터 최소화, 4) 목적 외 사용 금지, 5) 암호화/가명화, 6) 침해 발생 시 72시간 내 신고가 필요합니다.',
ARRAY['GDPR', '개인정보', '동의', '삭제권', '암호화'],
'GDPR 위반 시 전 세계 매출의 최대 4%까지 과징금이 부과될 수 있습니다.',
'docs/06-security.md'),

('security', '로깅', 2, 10, 50,
'보안 로깅에서 반드시 기록해야 할 이벤트는 무엇인가요?',
'1) 인증 이벤트(성공/실패), 2) 인가 실패, 3) 입력 검증 실패, 4) 관리자 작업, 5) 민감 데이터 접근, 6) 설정 변경입니다. 로그에는 민감 정보(비밀번호 등)를 포함하면 안 됩니다.',
ARRAY['보안 로깅', '감사 로그', '인증', '인가', '민감 정보'],
'로그는 사고 조사와 컴플라이언스 증명에 필수적입니다.',
'docs/06-security.md');

-- 난이도 3 (시니어) - 12문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('security', 'JWT', 3, 30, 75,
'JWT의 주요 보안 취약점과 방어 방법을 설명해주세요.',
'1) none 알고리즘: 허용된 알고리즘 화이트리스트 적용. 2) 키 혼동: 알고리즘 검증 후 해당 키 사용. 3) 만료 미검증: exp, nbf, iss, aud 클레임 필수 검증. 4) 민감 정보: Payload는 암호화되지 않으므로 민감 정보 포함 금지.',
ARRAY['JWT', 'none 알고리즘', '키 혼동', '클레임 검증', '보안'],
'JWT 라이브러리 선택 시 알려진 취약점이 패치된 버전을 사용해야 합니다.',
'docs/06-security.md'),

('security', 'OAuth', 3, 30, 75,
'PKCE가 필요한 이유와 동작 방식을 설명해주세요.',
'SPA나 모바일 앱은 client_secret을 안전하게 보관할 수 없습니다. PKCE는 code_verifier/code_challenge로 Authorization Code 가로채기 공격을 방어합니다. OAuth 2.1에서는 모든 클라이언트에 PKCE가 필수입니다.',
ARRAY['PKCE', 'OAuth', 'code_verifier', 'code_challenge', 'SPA'],
'code_challenge = SHA256(code_verifier)로 생성하고, 토큰 요청 시 code_verifier를 제출하여 검증합니다.',
'docs/06-security.md'),

('security', 'OAuth', 3, 30, 75,
'Access Token과 Refresh Token을 분리하는 이유와 Refresh Token Rotation을 설명해주세요.',
'Access Token은 짧은 만료(15분-1시간)로 유출 시 피해를 최소화합니다. Refresh Token Rotation은 Refresh Token 사용 시 새 토큰을 발급하고 기존 토큰을 무효화하여 유출 탐지가 가능합니다.',
ARRAY['Access Token', 'Refresh Token', 'Rotation', '만료', '무효화'],
'공격자와 정상 사용자 중 하나만 유효한 토큰을 가지게 되어 유출을 탐지할 수 있습니다.',
'docs/06-security.md'),

('security', 'TLS', 3, 30, 75,
'Perfect Forward Secrecy(PFS)가 중요한 이유를 설명해주세요.',
'PFS 없이 정적 RSA 키를 사용하면 서버 개인 키 유출 시 과거에 캡처된 모든 트래픽을 복호화할 수 있습니다. PFS(ECDHE 등)는 각 세션마다 임시 키를 생성하여 과거 세션을 보호합니다.',
ARRAY['PFS', 'Forward Secrecy', 'ECDHE', 'TLS', '키 교환'],
'TLS 1.3에서는 정적 RSA 키 교환이 제거되어 PFS가 기본입니다.',
'docs/06-security.md'),

('security', '암호화 키 관리', 3, 30, 75,
'데이터 암호화 시 DEK/KEK 구조와 Envelope Encryption을 설명해주세요.',
'DEK(Data Encryption Key)로 데이터를 암호화하고, KEK(Key Encryption Key)로 DEK를 암호화합니다. 대규모 데이터에 효율적이며, KMS로 KEK를 관리하고 DEK만 로컬에서 처리합니다.',
ARRAY['DEK', 'KEK', 'Envelope Encryption', 'KMS', '키 관리'],
'키 로테이션 시 KEK만 교체하면 되어 관리가 용이합니다.',
'docs/06-security.md'),

('security', 'Vault', 3, 30, 75,
'HashiCorp Vault의 동적 시크릿(Dynamic Secrets)이란 무엇인가요?',
'애플리케이션 요청 시 DB 자격 증명을 실시간 생성하고, TTL 후 자동 폐기합니다. 장점: 정적 비밀번호 유출 위험 제거, 자격 증명 공유 없음, 접근 감사 가능.',
ARRAY['Vault', '동적 시크릿', 'TTL', '자격 증명', '자동 폐기'],
'Vault의 Database 시크릿 엔진으로 MySQL, PostgreSQL 등의 동적 자격 증명을 생성할 수 있습니다.',
'docs/06-security.md'),

('security', 'Kubernetes 시크릿', 3, 30, 75,
'Kubernetes에서 시크릿을 안전하게 관리하는 방법을 설명해주세요.',
'1) K8s Secrets는 base64 인코딩이므로 etcd 암호화가 필요합니다. 2) External Secrets Operator로 Vault/AWS SM과 동기화합니다. 3) Sealed Secrets로 GitOps용 암호화된 시크릿을 사용합니다.',
ARRAY['Kubernetes', 'Secrets', 'External Secrets', 'Sealed Secrets', 'etcd'],
'Kubernetes Secrets의 기본 base64 인코딩은 암호화가 아닙니다.',
'docs/06-security.md'),

('security', '마이크로세그멘테이션', 3, 30, 75,
'마이크로세그멘테이션 구현 방법을 설명해주세요.',
'1) 각 워크로드에 개별 Security Group을 적용합니다. 2) Kubernetes Network Policy로 Pod 간 트래픽을 제어합니다. 3) Service Mesh의 Authorization Policy를 사용합니다. 목표는 침해 시 lateral movement를 방지하는 것입니다.',
ARRAY['마이크로세그멘테이션', 'Network Policy', 'Security Group', 'lateral movement', 'Service Mesh'],
'기존의 경계 보안 모델에서 워크로드 중심의 보안 모델로 전환하는 것입니다.',
'docs/06-security.md'),

('security', 'mTLS', 3, 30, 75,
'Service Mesh에서 mTLS(Mutual TLS)의 이점을 설명해주세요.',
'1) 투명한 암호화(앱 수정 불필요), 2) 서비스 간 상호 인증, 3) 인증서 자동 관리, 4) 세밀한 접근 정책 적용이 가능합니다. Istio, Linkerd 등에서 지원합니다.',
ARRAY['mTLS', 'Service Mesh', 'Istio', '상호 인증', '인증서'],
'mTLS는 클라이언트와 서버 모두 인증서로 신원을 증명합니다.',
'docs/06-security.md'),

('security', '런타임 보안', 3, 30, 75,
'Falco로 탐지할 수 있는 컨테이너 위협을 설명해주세요.',
'1) 컨테이너 내 쉘 실행, 2) 민감 파일 접근(/etc/passwd 등), 3) 네트워크 도구 실행(curl, wget), 4) 권한 상승 시도, 5) 암호화폐 채굴 프로세스를 탐지할 수 있습니다.',
ARRAY['Falco', '런타임 보안', '컨테이너', '위협 탐지', '이상 행동'],
'Falco는 시스템 콜을 모니터링하여 이상 행동을 탐지합니다.',
'docs/06-security.md'),

('security', 'IR 프로세스', 3, 30, 75,
'NIST 사고 대응 프레임워크의 4단계를 설명해주세요.',
'1) 준비(Preparation): 팀 구성, 도구, 절차 마련. 2) 탐지 및 분석: 이상 징후 탐지, 영향 범위 파악. 3) 격리, 근절, 복구: 시스템 격리, 위협 제거, 서비스 복원. 4) 사후 활동: 보고서 작성, 교훈 도출, 개선.',
ARRAY['NIST', '사고 대응', 'IR', '격리', '복구'],
'준비 단계가 가장 중요하며, 사고 발생 전에 완료되어야 합니다.',
'docs/06-security.md'),

('security', '포렌식', 3, 30, 75,
'디지털 포렌식에서 증거 무결성을 유지하는 방법을 설명해주세요.',
'1) 원본 훼손 방지(복사본으로 작업), 2) 해시값으로 무결성 기록, 3) 체인 오브 커스터디 유지, 4) 쓰기 방지 도구 사용, 5) 모든 과정 문서화가 필요합니다.',
ARRAY['포렌식', '증거', '무결성', '해시', '체인 오브 커스터디'],
'법적 증거 능력을 위해 증거 수집 과정의 연속성을 증명해야 합니다.',
'docs/06-security.md');

-- 난이도 4 (리드/CTO) - 8문제
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('security', 'Zero Trust', 4, 50, 100,
'Zero Trust Architecture 구현 단계를 설명해주세요.',
'1) 사용자/디바이스 신원 확립, 2) 모든 자산 인벤토리, 3) 강력한 인증(MFA, 디바이스 인증), 4) 마이크로세그멘테이션, 5) 최소 권한 접근, 6) 모든 트래픽 암호화, 7) 지속적 모니터링이 필요합니다.',
ARRAY['Zero Trust', 'ZTNA', '마이크로세그멘테이션', 'MFA', '최소 권한'],
'"Never trust, always verify" 원칙으로 네트워크 위치와 무관하게 모든 접근을 검증합니다.',
'docs/06-security.md'),

('security', 'ZTNA', 4, 50, 100,
'VPN에서 ZTNA로 전환하는 이유를 설명해주세요.',
'VPN은 일단 연결되면 네트워크 전체에 접근 가능합니다(암묵적 신뢰). ZTNA는 애플리케이션별로 접근을 허용하고, 디바이스 상태를 확인하며, 지속적으로 검증합니다. 더 세밀한 접근 제어가 가능합니다.',
ARRAY['ZTNA', 'VPN', 'Zero Trust', '접근 제어', '디바이스'],
'ZTNA는 원격 근무 환경에서 더 적합한 보안 모델입니다.',
'docs/06-security.md'),

('security', 'Post-Quantum', 4, 50, 100,
'양자 컴퓨팅 시대에 현재 암호화가 위험한 이유와 대응 방안을 설명해주세요.',
'Shor 알고리즘은 RSA, ECDSA 등 현재 비대칭키 암호를 다항 시간에 해독합니다. "지금 수집, 나중에 해독" 공격에 대비해 장기 보관 데이터는 PQ 암호화를 고려해야 합니다. CRYSTALS-Kyber, CRYSTALS-Dilithium 등 NIST 표준을 사용합니다.',
ARRAY['양자 컴퓨팅', 'Post-Quantum', 'Shor', 'CRYSTALS', 'PQ 암호화'],
'하이브리드 접근으로 기존 알고리즘과 PQ 알고리즘을 병행하는 것이 권장됩니다.',
'docs/06-security.md'),

('security', 'Zero Standing Privileges', 4, 50, 100,
'제로 스탠딩 권한(Zero Standing Privileges) 구현 방법을 설명해주세요.',
'1) 모든 특권 접근은 임시로 부여합니다. 2) 승인 워크플로우를 필수로 합니다. 3) 시간 제한 자격 증명을 사용합니다. 4) 세션 녹화/감사를 수행합니다. 5) 만료 시 자동 회수합니다.',
ARRAY['Zero Standing Privileges', 'JIT', 'PAM', '임시 권한', '승인'],
'상시 권한을 제거하여 공격 표면을 최소화합니다.',
'docs/06-security.md'),

('security', '공급망 보안', 4, 50, 100,
'소프트웨어 공급망 보안(Supply Chain Security) 전략을 설명해주세요.',
'1) 의존성 잠금(lock file) 사용, 2) 무결성 검증(체크섬, 서명), 3) 신뢰할 수 있는 레지스트리만 사용, 4) 최소 의존성 원칙, 5) sigstore로 아티팩트 서명, 6) SLSA 프레임워크 적용이 필요합니다.',
ARRAY['공급망 보안', 'SLSA', 'sigstore', 'SBOM', '의존성'],
'SolarWinds, Log4j 사태 이후 공급망 보안의 중요성이 더욱 강조되고 있습니다.',
'docs/06-security.md'),

('security', 'CISO', 4, 50, 100,
'CISO로서 보안 프로그램의 핵심 요소를 설명해주세요.',
'1) 거버넌스(정책, 표준, 절차), 2) 위험 관리, 3) 규정 준수, 4) 보안 아키텍처, 5) 운영 보안, 6) 사고 대응, 7) 인식 교육, 8) 지표와 보고가 필요합니다.',
ARRAY['CISO', '거버넌스', '위험 관리', '보안 프로그램', '지표'],
'보안은 기술만의 문제가 아니라 사람, 프로세스, 기술의 조합입니다.',
'docs/06-security.md'),

('security', '위험 기반 의사결정', 4, 50, 100,
'위험 기반 보안 의사결정이란 무엇인가요?',
'모든 위험을 제거할 수 없으므로 1) 자산의 가치, 2) 위협의 가능성, 3) 취약점의 심각도, 4) 영향도를 고려하여 우선순위를 정합니다. 위험 = 가능성 x 영향으로 정량화하여 리소스를 효율적으로 배분합니다.',
ARRAY['위험 관리', '의사결정', '우선순위', '가능성', '영향도'],
'제한된 보안 리소스를 가장 효과적으로 사용하기 위한 접근법입니다.',
'docs/06-security.md'),

('security', '침해 대응', 4, 50, 100,
'보안 침해 시 법적 대응과 커뮤니케이션 전략을 설명해주세요.',
'1) 법률 자문 즉시 확보, 2) 규정에 따른 신고(GDPR 72시간 등), 3) 이해관계자 커뮤니케이션 계획 수립, 4) 외부 전문가 계약(필요 시), 5) 언론/고객 대응은 홍보팀과 조율합니다.',
ARRAY['침해 대응', '법적 대응', '커뮤니케이션', '신고', '이해관계자'],
'잘못된 커뮤니케이션은 기술적 침해보다 더 큰 평판 손상을 야기할 수 있습니다.',
'docs/06-security.md');
