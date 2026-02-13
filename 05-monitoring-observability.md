# 모니터링/관측성 - IT 서비스 운영 필수 지식

> 이 문서는 IT 서비스 운영에 필요한 모니터링 및 관측성(Observability) 지식을 레벨별로 정리한 학습 자료입니다.
> 퀴즈 생성 및 역량 평가에 활용할 수 있습니다.

## 레벨 가이드
| 레벨 | 대상 | 설명 |
|------|------|------|
| ⭐ Level 1 | 입문 | 개념 이해, 기본 용어 |
| ⭐⭐ Level 2 | 주니어 | 실무 적용, 트러블슈팅 기초 |
| ⭐⭐⭐ Level 3 | 시니어 | 아키텍처 설계, 성능 최적화 |
| ⭐⭐⭐⭐ Level 4 | 리드/CTO | 전략적 의사결정, 대규모 설계 |

---

## 1. 관측성 3요소 (Metrics, Logs, Traces)

### 개념 설명
관측성(Observability)은 시스템의 외부 출력을 통해 내부 상태를 이해하는 능력이다. 세 가지 핵심 데이터 타입인 메트릭, 로그, 트레이스가 상호 보완적으로 작동하여 시스템 동작을 파악한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 메트릭(Metrics): 시간에 따른 수치 데이터 (CPU 사용률, 요청 수)
> - 로그(Logs): 이벤트의 텍스트 기록 (에러 메시지, 접근 기록)
> - 트레이스(Traces): 요청의 분산 시스템 경로 추적
>
> **Q: 모니터링과 관측성의 차이는?**
> **A:** 모니터링은 "알려진 문제"를 감지하는 것(미리 정의된 메트릭 임계값). 관측성은 "알려지지 않은 문제"도 조사할 수 있는 것(임의의 질문에 답할 수 있는 능력). 관측성은 모니터링을 포함하는 더 넓은 개념이다.
>
> **Q: 메트릭, 로그, 트레이스는 각각 언제 사용하는가?**
> **A:** 메트릭: 시스템 상태 개요, 알림, 트렌드 분석. 로그: 상세한 이벤트 정보, 디버깅. 트레이스: 분산 시스템에서 요청 흐름 추적. 세 가지를 연계하여 문제를 빠르게 파악한다.
>
> **Q: 왜 세 가지 모두 필요한가?**
> **A:** 각각 다른 관점을 제공한다. 메트릭으로 "무엇이 문제인가", 로그로 "왜 문제인가", 트레이스로 "어디서 문제인가"를 파악한다. 하나만으로는 전체 그림을 볼 수 없다.

> ⭐⭐ **Level 2 (주니어)**
> - 메트릭 타입: Counter, Gauge, Histogram, Summary
> - 구조화 로그(Structured Logging)의 중요성
> - 스팬(Span)과 트레이스의 관계
> - 상관관계(Correlation): trace_id로 로그와 트레이스 연결
>
> **Q: Counter와 Gauge의 차이는?**
> **A:** Counter: 단조 증가하는 값(요청 수, 에러 수). 리셋되면 0부터 시작. Gauge: 증감 가능한 현재 값(온도, 메모리 사용량, 동시 접속자). Counter는 rate()로 변화율을 계산하고, Gauge는 현재 값 자체가 의미있다.
>
> **Q: 구조화 로그란 무엇이고 왜 중요한가?**
> **A:** JSON 등 파싱 가능한 형식의 로그. `{"level":"error","service":"api","user_id":123,"message":"..."}`. 검색/집계/분석이 용이하고, trace_id 등 컨텍스트를 쉽게 포함할 수 있다. 비구조화 로그는 정규식에 의존해야 한다.
>
> **Q: 스팬(Span)이란 무엇인가?**
> **A:** 분산 트레이싱의 기본 단위로, 단일 작업(예: DB 쿼리, HTTP 호출)을 나타낸다. 시작/종료 시간, 태그, 로그, 부모 스팬 참조를 포함한다. 여러 스팬이 모여 하나의 트레이스를 구성한다.
>
> **Q: trace_id로 로그와 트레이스를 연결하는 방법은?**
> **A:** 요청 처리 시 trace_id를 로그에 포함시킨다. 트레이스에서 문제 스팬 발견 시 해당 trace_id로 로그를 검색하여 상세 정보를 확인한다. OpenTelemetry가 자동으로 이 연결을 지원한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 카디널리티(Cardinality) 관리와 비용
> - 샘플링 전략 (확률적, 테일 기반)
> - 컨텍스트 전파(Context Propagation)
> - 원격 측정 파이프라인 설계
>
> **Q: 높은 카디널리티가 문제가 되는 이유는?**
> **A:** 메트릭의 레이블 조합이 많아지면 저장/쿼리 비용이 급증한다. user_id를 레이블로 사용하면 수백만 개 시계열이 생성된다. 해결: 레이블 값 제한, 높은 카디널리티는 로그/트레이스로 이동, 집계 레벨 조정.
>
> **Q: 트레이스 샘플링 전략은?**
> **A:** Head-based(확률적): 요청 시작 시 결정, 단순하지만 중요 트레이스 누락 가능. Tail-based: 요청 완료 후 결정, 에러/지연 발생 트레이스만 저장 가능하지만 구현 복잡. 하이브리드: 중요 경로는 100%, 나머지는 샘플링.
>
> **Q: 컨텍스트 전파(Context Propagation)란?**
> **A:** 분산 시스템에서 요청 컨텍스트(trace_id, span_id, baggage)를 서비스 간에 전달하는 메커니즘. W3C Trace Context 표준 사용을 권장한다. HTTP 헤더(traceparent), gRPC 메타데이터, 메시지 큐 속성 등을 통해 전파한다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 관측성 플랫폼 아키텍처
> - 비용 최적화 전략
> - 관측성 성숙도 모델
> - 조직 문화와 관측성
>
> **Q: 관측성 플랫폼 선택 기준은?**
> **A:** 규모와 비용(SaaS vs 자체 운영), 통합 용이성(기존 스택, OpenTelemetry 지원), 기능(APM, 인프라, 로그 통합), 쿼리 성능, 데이터 보존 정책, 팀 역량. 대기업은 하이브리드(중요 데이터 자체 운영 + SaaS) 고려.
>
> **Q: 관측성 비용 최적화 방법은?**
> **A:** 샘플링 적용(트레이스 1-10%), 로그 레벨 조정(프로덕션은 INFO 이상), 메트릭 카디널리티 제한, 핫/콜드 티어링(오래된 데이터 저렴한 스토리지), 불필요한 텔레메트리 제거, 집계 전 필터링.

### 실무 시나리오

**시나리오: 느린 API 응답 디버깅**
1. **메트릭 확인**: API 응답 시간 p99가 급증
2. **트레이스 검색**: 느린 요청의 trace_id 확인
3. **스팬 분석**: DB 쿼리 스팬이 3초 소요 발견
4. **로그 확인**: 해당 trace_id로 로그 검색, 쿼리 상세 확인
5. **근본 원인**: 인덱스 누락된 쿼리 발견

### 면접 빈출 질문
- **Q: 관측성 시스템 없이 장애를 디버깅해야 한다면?**
- **A:** 로그 파일 직접 분석(grep, awk), 시스템 메트릭(top, vmstat, iostat), 네트워크 분석(tcpdump, ss). 하지만 분산 시스템에서는 매우 어렵고 시간이 오래 걸린다. 이것이 관측성 투자의 이유다.

---

## 2. Prometheus

### 개념 설명
Prometheus는 오픈소스 모니터링 시스템으로, 시계열 데이터베이스와 강력한 쿼리 언어(PromQL)를 제공한다. Pull 모델로 메트릭을 수집하고 알림을 지원한다. CNCF 졸업 프로젝트이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - Pull 기반 메트릭 수집 (HTTP /metrics 엔드포인트)
> - 메트릭 타입: Counter, Gauge, Histogram, Summary
> - Grafana와 연동하여 대시보드 구성
>
> **Q: Push 방식과 Pull 방식의 차이는?**
> **A:** Push: 애플리케이션이 메트릭을 전송(StatsD). 방화벽 문제, 부하 제어 어려움. Pull: Prometheus가 애플리케이션에서 수집. 모니터링 대상 상태 파악 용이, 중앙 제어. 단기 작업은 Pushgateway 사용.
>
> **Q: Prometheus에서 /metrics 엔드포인트란?**
> **A:** 애플리케이션이 노출하는 HTTP 엔드포인트로, Prometheus가 주기적으로 스크레이핑한다. 텍스트 기반 형식으로 메트릭 이름, 레이블, 값을 제공한다. 클라이언트 라이브러리가 자동으로 포맷팅한다.
>
> **Q: exporter란 무엇인가?**
> **A:** Prometheus 형식의 메트릭을 노출하는 에이전트. 애플리케이션이 직접 메트릭을 노출하지 못할 때 사용한다. node_exporter(리눅스), mysqld_exporter(MySQL), redis_exporter 등이 있다.

> ⭐⭐ **Level 2 (주니어)**
> - 기본 PromQL: rate(), sum(), avg(), quantile()
> - 서비스 디스커버리: Kubernetes, Consul, 파일 기반
> - 알림 규칙(alerting rules) 작성
> - 녹화 규칙(recording rules)로 사전 계산
>
> **Q: rate()와 irate()의 차이는?**
> **A:** rate(): 범위 내 전체 평균 증가율, 그래프에 적합. irate(): 마지막 두 포인트의 순간 증가율, 급격한 변화 감지. 일반적으로 rate() 사용, 스파이크 분석 시 irate(). rate()는 Counter에만 사용.
>
> **Q: Histogram과 Summary의 차이와 선택 기준은?**
> **A:** Histogram: 버킷별 카운트, 서버 측 집계 가능(여러 인스턴스 합산), 사전 정의 버킷 필요. Summary: 클라이언트에서 분위수 계산, 정확하지만 집계 불가. 분산 시스템에서는 Histogram 권장.
>
> **Q: recording rules를 사용하는 이유는?**
> **A:** 복잡한 쿼리를 미리 계산하여 저장. 대시보드 로딩 속도 향상, 알림 평가 성능 개선. `record: job:http_requests:rate5m`처럼 명명 규칙을 따른다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - Prometheus 아키텍처와 제한사항
> - 고가용성 구성 (Federation, Thanos, Cortex)
> - 장기 저장소 통합
> - 성능 튜닝
>
> **Q: Prometheus의 확장성 제한은?**
> **A:** 단일 노드 아키텍처로 수평 확장 불가, 메모리 내 인덱스로 시계열 수 제한(수백만), 로컬 스토리지로 장기 보관 어려움. 해결: Thanos/Cortex로 장기 저장 및 글로벌 뷰, Federation으로 계층화.
>
> **Q: Thanos와 Cortex의 차이는?**
> **A:** Thanos: 사이드카 방식, 기존 Prometheus에 추가, 객체 스토리지 활용, 다운샘플링 지원. Cortex: 완전 분산 아키텍처, 푸시 기반, 멀티테넌시 내장. Thanos가 도입이 쉽고, Cortex는 대규모 멀티테넌트에 적합.
>
> **Q: Prometheus 메모리 사용량을 줄이는 방법은?**
> **A:** 시계열 수 줄이기(레이블 카디널리티 제한), 스크레이핑 간격 늘리기, 불필요한 메트릭 drop, 보존 기간 단축, recording rules로 원본 대체, relabel_configs로 필터링.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 대규모 Prometheus 아키텍처 설계
> - PromQL 성능 최적화
> - 멀티클러스터/멀티리전 모니터링
> - 비용 대비 가치 분석
>
> **Q: 멀티클러스터 환경에서 Prometheus 설계는?**
> **A:** 클러스터당 Prometheus 운영, Thanos Query로 글로벌 뷰 제공, external_labels로 클러스터 식별, 교차 클러스터 알림은 중앙 Alertmanager. 또는 원격 쓰기(remote_write)로 중앙 집중화.
>
> **Q: PromQL 쿼리 성능을 개선하는 방법은?**
> **A:** recording rules로 사전 계산, 시간 범위 제한, 레이블 셀렉터 구체화, 불필요한 by/without 제거, 정규식 셀렉터 최소화. 쿼리 로그로 느린 쿼리 분석, EXPLAIN 기능 활용.

### 실무 시나리오

**시나리오: 알림 규칙 작성**
```yaml
groups:
  - name: api-alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m]))
          / sum(rate(http_requests_total[5m])) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }}"
```

### 면접 빈출 질문
- **Q: Prometheus가 다운되면 메트릭이 유실되는가?**
- **A:** Prometheus가 다운된 동안의 메트릭은 수집되지 않는다(Pull 모델). 해결: HA 구성(두 대가 같은 대상 스크레이핑), 원격 저장소 복제, 짧은 복구 시간 목표. 완전한 무손실은 Push 기반 시스템 고려.

---

## 3. Grafana

### 개념 설명
Grafana는 오픈소스 데이터 시각화 및 대시보드 플랫폼이다. Prometheus, Elasticsearch, InfluxDB 등 다양한 데이터소스를 지원하고, 알림 기능을 제공한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 대시보드와 패널 개념
> - 주요 시각화: 그래프, 게이지, 테이블, Stat
> - 데이터소스 연결
>
> **Q: Grafana와 Prometheus의 관계는?**
> **A:** Prometheus는 메트릭을 수집/저장하고, Grafana는 시각화를 담당한다. Grafana가 PromQL 쿼리를 Prometheus에 전송하고 결과를 시각화한다. 둘은 보완적이며 함께 사용된다.
>
> **Q: 좋은 대시보드의 조건은?**
> **A:** 목적이 명확(서비스 개요, 상세 분석 등), 핵심 지표가 눈에 띄게, 적절한 시간 범위, 읽기 쉬운 레이아웃, 드릴다운 가능, 과도한 패널 지양(7개 이하 권장).

> ⭐⭐ **Level 2 (주니어)**
> - 변수(Variables)를 활용한 동적 대시보드
> - 패널 링크와 데이터 링크
> - 알림 설정과 알림 채널
> - 대시보드 버전 관리
>
> **Q: 변수(Variables)의 용도는?**
> **A:** 드롭다운으로 필터링 값을 선택하여 대시보드를 동적으로 변경한다. 예: 서버 선택, 환경 선택. 쿼리로 변수 값을 자동 채울 수 있다. 하나의 대시보드로 여러 상황에 대응 가능.
>
> **Q: Grafana 알림과 Alertmanager의 차이는?**
> **A:** Grafana 알림: 대시보드 기반, 설정 쉬움, 시각화와 통합. Alertmanager: Prometheus 전용, 중복 제거/그룹화/억제 기능, 복잡한 라우팅. 프로덕션에서는 Alertmanager 권장, Grafana는 보조로 사용.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 플러그인 개발과 확장
> - 멀티 데이터소스 쿼리
> - 대시보드 프로비저닝(Infrastructure as Code)
> - 성능 최적화
>
> **Q: 대시보드를 코드로 관리하는 방법은?**
> **A:** Grafana 프로비저닝: YAML/JSON으로 대시보드 정의, ConfigMap이나 파일 시스템에서 로드. Grafonnet: Jsonnet 기반 대시보드 생성. Terraform provider 사용. Git으로 버전 관리, CI/CD로 배포.
>
> **Q: Grafana 대시보드 성능 문제 해결은?**
> **A:** 패널 수 줄이기, 쿼리 최적화(recording rules 활용), 시간 범위 제한, 불필요한 쿼리 제거, 캐시 활용, 느린 쿼리 식별, 변수 쿼리 최적화.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 대시보드 거버넌스
> - 멀티테넌트 Grafana
> - SLO 대시보드 설계
> - 관측성 문화 구축
>
> **Q: 조직에서 대시보드 표준화 방법은?**
> **A:** 대시보드 템플릿 제공, 명명 규칙 정의, 폴더 구조 표준화, 대시보드 리뷰 프로세스, 사용하지 않는 대시보드 정리, 문서화. 플랫폼 팀이 관리하고 서비스 팀이 활용하는 구조.

### 실무 시나리오

**시나리오: SLO 대시보드 구성**
```
┌─────────────────────────────────────────────────┐
│ Service: ${service}  │ SLO: 99.9%  │ Budget: 43m│
├─────────────────────────────────────────────────┤
│ [Error Budget Remaining: 73%]  ████████████░░░  │
├──────────────────────┬──────────────────────────┤
│ Availability (30d)   │ Latency p99 (30d)        │
│ 99.95%              │ 245ms                     │
├──────────────────────┴──────────────────────────┤
│ [Error Budget Burn Rate - 7 days graph]         │
├─────────────────────────────────────────────────┤
│ [Recent SLO Violations Table]                   │
└─────────────────────────────────────────────────┘
```

### 면접 빈출 질문
- **Q: 너무 많은 대시보드가 있을 때 문제점은?**
- **A:** 어떤 대시보드를 봐야 할지 혼란, 유지보수 부담, 일관성 부족, 성능 저하. 해결: 계층 구조(개요 -> 상세), 서비스별/팀별 폴더, 정기 정리, 명명 규칙, 템플릿 사용.

---

## 4. ELK Stack (Elasticsearch, Logstash, Kibana)

### 개념 설명
ELK Stack은 Elasticsearch(검색/저장), Logstash(수집/변환), Kibana(시각화)로 구성된 로그 분석 플랫폼이다. Beats가 추가되어 Elastic Stack으로 불리기도 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - Elasticsearch: 분산 검색/분석 엔진
> - Logstash: 데이터 수집 및 변환 파이프라인
> - Kibana: 시각화 및 대시보드
> - Filebeat: 경량 로그 수집기
>
> **Q: ELK Stack의 각 컴포넌트 역할은?**
> **A:** Beats(Filebeat): 로그 파일을 읽어 전송. Logstash: 필터링, 파싱, 변환. Elasticsearch: 인덱싱, 저장, 검색. Kibana: 시각화, 대시보드, 관리 UI. 간단한 경우 Filebeat -> Elasticsearch 직접 연결도 가능.
>
> **Q: Elasticsearch의 인덱스란?**
> **A:** 관련 문서의 모음으로, RDB의 테이블과 유사하다. 로그는 보통 날짜별 인덱스(logs-2024.01.15)를 사용하여 오래된 데이터 삭제가 용이하다.

> ⭐⭐ **Level 2 (주니어)**
> - Elasticsearch 기본 쿼리 (match, term, range)
> - Logstash 파이프라인 구성 (input, filter, output)
> - Grok 패턴으로 로그 파싱
> - Kibana 대시보드와 Discover
>
> **Q: Grok 패턴이란 무엇인가?**
> **A:** 정규식을 사람이 읽기 쉽게 추상화한 것. `%{IP:client} %{WORD:method} %{URIPATHPARAM:request}`처럼 사용한다. 비구조화 로그를 구조화된 필드로 파싱한다. Logstash, Filebeat에서 사용.
>
> **Q: Filebeat와 Logstash 중 언제 무엇을 쓰는가?**
> **A:** Filebeat: 경량, 간단한 전송, 적은 변환. Logstash: 무거움, 복잡한 변환, 다양한 입출력. 일반적으로 Filebeat로 수집하고 필요시 Logstash로 처리. 또는 Elasticsearch Ingest Pipeline으로 대체.

> ⭐⭐⭐ **Level 3 (시니어)**
> - Elasticsearch 클러스터 아키텍처 (노드 역할)
> - 인덱스 수명주기 관리(ILM)
> - 쿼리 성능 최적화
> - 샤드 설계
>
> **Q: Elasticsearch 노드 역할의 종류는?**
> **A:** Master: 클러스터 메타데이터 관리. Data: 데이터 저장/검색. Coordinating: 쿼리 라우팅. Ingest: 데이터 전처리. ML: 머신러닝. 대규모 클러스터는 역할별로 분리한다.
>
> **Q: ILM(Index Lifecycle Management) 단계는?**
> **A:** Hot: 활발한 쓰기/읽기, 빠른 스토리지. Warm: 읽기 위주, 느린 스토리지. Cold: 거의 접근 안 함, 저렴한 스토리지. Delete: 삭제. 정책으로 자동 전환하여 비용 최적화.
>
> **Q: 적절한 샤드 수와 크기는?**
> **A:** 샤드당 20-50GB 권장. 샤드 수 = 예상 인덱스 크기 / 50GB. 너무 작은 샤드: 오버헤드 증가. 너무 큰 샤드: 복구/재배치 느림. 프라이머리 샤드 수는 변경 불가(reindex 필요).

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 대규모 ELK 아키텍처 설계
> - 비용 최적화 전략
> - 보안 설정 (TLS, 인증, RBAC)
> - Elastic Cloud vs Self-managed
>
> **Q: ELK 비용을 줄이는 방법은?**
> **A:** 불필요한 필드 제외(_source filtering), 로그 레벨 조정, 보존 기간 단축, ILM으로 계층화, 적절한 샤드 수, 인덱스 압축, 스토리지 계층(Hot/Warm/Cold), 샘플링.
>
> **Q: ELK vs Loki 선택 기준은?**
> **A:** ELK: 풀텍스트 검색 강점, 복잡한 쿼리, APM 통합, 성숙한 생태계. Loki: 라벨 기반 인덱싱, 저비용, Grafana 통합, 간단한 쿼리. 대규모 풀텍스트 검색은 ELK, 비용 중시/Grafana 환경은 Loki.

### 실무 시나리오

**시나리오: Logstash 파이프라인**
```ruby
input {
  beats { port => 5044 }
}

filter {
  grok {
    match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:msg}" }
  }
  date {
    match => [ "timestamp", "ISO8601" ]
    target => "@timestamp"
  }
  if [level] == "DEBUG" {
    drop { }
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "logs-%{+YYYY.MM.dd}"
  }
}
```

### 면접 빈출 질문
- **Q: Elasticsearch가 느려지는 원인은?**
- **A:** 힙 메모리 부족(GC), 샤드 수 과다, 느린 쿼리(wildcard, 정규식), 디스크 I/O 병목, 인덱싱 부하, 노드 불균형. 해결: 모니터링, 샤드 최적화, 쿼리 개선, 노드 추가.

---

## 5. Loki

### 개념 설명
Loki는 Grafana Labs가 개발한 로그 집계 시스템으로, Prometheus에서 영감을 받아 라벨 기반 인덱싱을 사용한다. Elasticsearch보다 저비용으로 대량의 로그를 처리할 수 있다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 라벨 기반 인덱싱 (로그 내용은 인덱싱하지 않음)
> - Promtail로 로그 수집
> - Grafana와 통합
> - LogQL로 쿼리
>
> **Q: Loki가 Elasticsearch보다 저렴한 이유는?**
> **A:** Loki는 로그 내용을 인덱싱하지 않고 라벨(메타데이터)만 인덱싱한다. 스토리지와 인덱스 크기가 작아 비용이 크게 절감된다. 대신 로그 내용 검색은 풀스캔이 필요하다.
>
> **Q: Loki의 라벨 설계 원칙은?**
> **A:** 라벨은 스트림을 정의하며 카디널리티가 낮아야 한다. 좋은 라벨: job, namespace, pod_name(제한적). 나쁜 라벨: request_id, user_id(값이 너무 많음). 높은 카디널리티는 성능 저하.

> ⭐⭐ **Level 2 (주니어)**
> - LogQL 기본 문법
> - 라인 필터: |=, !=, |~, !~
> - 파서: json, logfmt, pattern, regexp
> - 집계 함수: count_over_time, rate
>
> **Q: LogQL 기본 쿼리 예시는?**
> **A:** `{job="api"}` - 라벨 셀렉터. `{job="api"} |= "error"` - 에러 포함 로그. `{job="api"} | json | level="error"` - JSON 파싱 후 필터. `rate({job="api"} |= "error" [5m])` - 5분간 에러 발생률.
>
> **Q: Promtail vs Fluentd vs Filebeat?**
> **A:** Promtail: Loki 전용, 경량, 라벨 지원. Fluentd: 범용, 플러그인 풍부, 무거움. Filebeat: ELK 전용, 경량. Loki 사용 시 Promtail, OpenTelemetry Collector로 대체 가능.

> ⭐⭐⭐ **Level 3 (시니어)**
> - Loki 아키텍처 (ingester, querier, compactor)
> - 청크와 인덱스 저장소
> - 멀티테넌시
> - 성능 튜닝
>
> **Q: Loki 아키텍처 컴포넌트는?**
> **A:** Distributor: 쓰기 요청 분배. Ingester: 청크 생성/저장. Querier: 읽기 쿼리 처리. Query Frontend: 쿼리 스케줄링/캐싱. Compactor: 인덱스 압축. 단일 바이너리 또는 마이크로서비스 모드로 운영.
>
> **Q: Loki 성능을 개선하는 방법은?**
> **A:** 라벨 카디널리티 제한, 시간 범위 좁게, 청크 크기 최적화, 쿼리 프런트엔드 캐시 활용, 적절한 샤딩, 병렬 쿼리 설정, 불필요한 파싱 제거.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 대규모 Loki 배포 전략
> - 객체 스토리지 설계
> - 비용 최적화
> - Loki vs OpenSearch vs Clickhouse
>
> **Q: 수십 TB 규모 로그를 위한 Loki 설계는?**
> **A:** 마이크로서비스 모드 배포, S3/GCS 객체 스토리지, 읽기/쓰기 경로 분리, 충분한 ingester 복제, 보존 정책으로 자동 삭제, 쿼리 스플리팅과 샤딩, 캐시 레이어 추가.

### 실무 시나리오

**시나리오: 로그 기반 에러 메트릭 추출**
```promql
# LogQL로 에러 발생률 메트릭화
sum by (service) (
  rate({namespace="production"} |= "ERROR" [5m])
)

# 이를 Recording Rule로 저장하여 알림에 활용
```

### 면접 빈출 질문
- **Q: Loki에서 특정 텍스트 검색이 느린 이유는?**
- **A:** Loki는 라벨만 인덱싱하므로 텍스트 검색은 해당 스트림의 모든 청크를 풀스캔한다. 해결: 라벨 셀렉터로 범위 좁히기, 시간 범위 제한, 라벨에 중요 정보 포함. 풀텍스트 검색이 핵심이면 Elasticsearch 고려.

---

## 6. 분산 트레이싱 (Jaeger/Zipkin)

### 개념 설명
분산 트레이싱은 마이크로서비스 아키텍처에서 요청이 여러 서비스를 거치는 경로를 추적한다. 병목 지점, 에러 발생 위치, 서비스 간 의존성을 파악할 수 있다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 트레이스: 하나의 요청에 대한 전체 경로
> - 스팬: 단일 작업 단위 (서비스 호출, DB 쿼리 등)
> - 분산 환경에서 요청 추적의 필요성
>
> **Q: 분산 트레이싱이 필요한 이유는?**
> **A:** 마이크로서비스에서 하나의 요청이 수십 개 서비스를 거칠 수 있다. 로그만으로는 전체 흐름을 파악하기 어렵다. 트레이싱으로 어느 서비스에서 지연이 발생했는지, 에러가 어디서 시작됐는지 한눈에 파악한다.
>
> **Q: Jaeger와 Zipkin의 차이는?**
> **A:** 둘 다 분산 트레이싱 시스템. Jaeger: CNCF 프로젝트, 확장성 좋음, 현대적 아키텍처. Zipkin: 더 오래됨, 단순함, Twitter에서 시작. 둘 다 OpenTelemetry와 호환되어 선택은 조직 선호도에 따름.

> ⭐⭐ **Level 2 (주니어)**
> - 스팬의 구성 요소: operation name, start/end time, tags, logs
> - 부모-자식 관계로 트레이스 구조 형성
> - 컨텍스트 전파: HTTP 헤더, gRPC 메타데이터
> - 트레이스 검색과 분석
>
> **Q: 트레이스 ID는 어떻게 전파되는가?**
> **A:** HTTP의 경우 헤더에 포함. W3C Trace Context 표준: `traceparent: 00-{trace-id}-{span-id}-{flags}`. B3 포맷(Zipkin): `X-B3-TraceId`, `X-B3-SpanId`. OpenTelemetry SDK가 자동으로 처리한다.
>
> **Q: 스팬의 태그와 로그의 차이는?**
> **A:** 태그(Tags/Attributes): 스팬 전체에 적용되는 키-값 메타데이터 (예: http.status_code=200). 로그(Events): 스팬 내 특정 시점의 이벤트 (예: "cache miss occurred at X time"). 태그는 검색에, 로그는 상세 정보에 사용.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 샘플링 전략: 확률적, 속도 제한, 테일 기반
> - 트레이싱 백엔드 아키텍처
> - 대용량 트레이스 처리
> - 자동 계측 vs 수동 계측
>
> **Q: 테일 기반 샘플링(Tail-based Sampling)이란?**
> **A:** 요청이 완료된 후 전체 트레이스를 보고 저장 여부를 결정한다. 에러가 발생하거나 지연 시간이 긴 트레이스만 저장 가능. 구현이 복잡하고(전체 스팬 수집 필요) Collector에서 처리. OpenTelemetry Collector가 지원.
>
> **Q: 자동 계측의 장단점은?**
> **A:** 장점: 코드 변경 없이 적용(Java agent, Node.js 등), 빠른 시작, 일관된 스팬. 단점: 비즈니스 컨텍스트 부족, 과도한 스팬 생성 가능, 커스터마이징 제한. 자동 계측 후 중요한 부분만 수동 추가가 좋은 전략.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 대규모 트레이싱 시스템 설계
> - 비용 관리
> - 트레이스 기반 분석 (서비스 맵, 병목 탐지)
> - OpenTelemetry 전환 전략
>
> **Q: 트레이스 저장 비용을 줄이는 방법은?**
> **A:** 샘플링 적용(1-10%), 불필요한 태그/로그 제거, 스팬 개수 제한, 보존 기간 단축, 에러/지연 트레이스만 저장(테일 샘플링), 스토리지 티어링. 중요 서비스는 높은 샘플링, 덜 중요한 서비스는 낮게.

### 실무 시나리오

**시나리오: 느린 API 요청 분석**
1. Jaeger UI에서 느린 요청 트레이스 검색 (duration > 3s)
2. 타임라인에서 가장 긴 스팬 확인 -> DB 쿼리 스팬
3. 스팬의 태그에서 쿼리 내용 확인
4. 해당 쿼리 최적화 (인덱스 추가)

### 면접 빈출 질문
- **Q: 모든 요청을 트레이싱하지 않는 이유는?**
- **A:** 비용(스토리지, 네트워크), 성능 오버헤드, 대부분의 트레이스는 정상이라 분석 가치가 낮음. 샘플링으로 전체적인 패턴은 파악하면서 비용을 절감한다. 에러/지연 케이스는 100% 수집하는 것이 좋다.

---

## 7. OpenTelemetry

### 개념 설명
OpenTelemetry(OTel)는 관측성 데이터(트레이스, 메트릭, 로그)를 수집하고 전송하는 벤더 중립적 표준이다. CNCF 프로젝트로, OpenTracing과 OpenCensus가 합쳐졌다. 계측 라이브러리, Collector, 프로토콜(OTLP)을 제공한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 벤더 중립적 관측성 표준
> - 트레이스, 메트릭, 로그의 통합 수집
> - 다양한 백엔드로 전송 가능 (Jaeger, Prometheus, 등)
>
> **Q: OpenTelemetry를 사용해야 하는 이유는?**
> **A:** 벤더 락인 방지(백엔드 교체 용이), 일관된 계측 API, 자동 계측 지원, 활발한 커뮤니티, 산업 표준화. 특정 벤더 SDK 대신 OTel을 사용하면 유연성이 높아진다.
>
> **Q: OpenTelemetry의 구성요소는?**
> **A:** API: 계측 인터페이스. SDK: API 구현체. Exporter: 백엔드로 전송. Collector: 중앙 수집/처리/전송 에이전트. 자동 계측: 코드 변경 없이 계측.

> ⭐⭐ **Level 2 (주니어)**
> - SDK 설정과 기본 계측
> - Exporter 종류: OTLP, Jaeger, Prometheus, 콘솔
> - Collector의 역할과 파이프라인
> - 시맨틱 규칙(Semantic Conventions)
>
> **Q: OpenTelemetry Collector를 사용하는 이유는?**
> **A:** 직접 백엔드로 보내지 않고 Collector를 경유하면: 버퍼링/재시도로 안정성 향상, 다양한 백엔드로 동시 전송, 필터링/변환 처리, 애플리케이션 부담 감소, 설정 변경이 애플리케이션 재배포 없이 가능.
>
> **Q: 시맨틱 규칙(Semantic Conventions)이란?**
> **A:** 표준화된 속성 이름. 예: http.method, http.status_code, db.system. 일관된 명명으로 다양한 라이브러리/도구 간 호환성 확보. OTel 문서에 정의되어 있다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 고급 Collector 설정 (프로세서, 커넥터)
> - 자동 계측 커스터마이징
> - 성능 최적화
> - 배포 패턴 (사이드카, 데몬셋, 게이트웨이)
>
> **Q: Collector 배포 패턴의 장단점은?**
> **A:** 사이드카: 각 Pod에 Collector, 격리 좋음, 리소스 오버헤드. 데몬셋: 노드당 하나, 효율적, 노드 장애 시 영향. 게이트웨이: 중앙 집중, 관리 용이, 병목 가능. 대규모 환경은 계층화(에이전트 -> 게이트웨이).
>
> **Q: OTel Collector 프로세서 종류는?**
> **A:** batch: 배치 처리. memory_limiter: 메모리 보호. filter: 데이터 필터링. attributes: 속성 수정. transform: 데이터 변환. tail_sampling: 테일 기반 샘플링. resource: 리소스 속성 관리.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 조직 전체 OTel 도입 전략
> - 커스텀 Exporter/Receiver 개발
> - 관측성 파이프라인 아키텍처
> - 비용과 가치 분석
>
> **Q: 기존 시스템에서 OTel로 마이그레이션 전략은?**
> **A:** 단계적 접근: 1) Collector 배포하여 기존 데이터 수집. 2) 새 서비스부터 OTel SDK 사용. 3) 기존 서비스 점진적 전환. 4) 기존 SDK 제거. 자동 계측으로 빠른 시작, 이후 수동 계측으로 개선.

### 실무 시나리오

**시나리오: OTel Collector 설정**
```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 1s
    send_batch_size: 1000
  memory_limiter:
    check_interval: 1s
    limit_mib: 1000
  filter:
    traces:
      span:
        - 'attributes["http.target"] == "/health"'

exporters:
  otlp:
    endpoint: tempo:4317
  prometheus:
    endpoint: 0.0.0.0:8889

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [memory_limiter, filter, batch]
      exporters: [otlp]
    metrics:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [prometheus]
```

### 면접 빈출 질문
- **Q: OpenTelemetry vs 벤더 SDK(Datadog, New Relic) 선택은?**
- **A:** OTel: 벤더 중립, 이식성, 오픈소스, 다양한 백엔드. 벤더 SDK: 깊은 통합, 더 많은 기능, 간편한 설정, 벤더 종속. 장기적으로 OTel 권장, 단기 빠른 시작은 벤더 SDK 후 전환 고려.

---

## 8. 알림 설계

### 개념 설명
효과적인 알림 시스템은 실제 문제를 빠르게 감지하면서도 불필요한 알림으로 피로를 주지 않아야 한다. 알림은 조치 가능해야 하고 적절한 심각도로 분류되어야 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 알림의 목적: 조치가 필요한 상황 감지
> - 기본 알림 채널: 이메일, 슬랙, PagerDuty
> - 심각도 분류: Critical, Warning, Info
>
> **Q: 좋은 알림의 조건은?**
> **A:** 조치 가능(Actionable): 받았을 때 무엇을 해야 하는지 명확. 시의적절: 문제 발생 직후 알림. 컨텍스트 포함: 무엇이, 어디서, 얼마나 심각한지. 중복 없음: 같은 문제로 반복 알림 안 함.
>
> **Q: 알림 피로(Alert Fatigue)란?**
> **A:** 너무 많은 알림으로 인해 중요한 알림도 무시하게 되는 현상. 거짓 양성(false positive)이 많으면 신뢰도가 떨어진다. 알림 수 줄이기, 적절한 임계값, 의미 있는 알림만 유지해야 한다.

> ⭐⭐ **Level 2 (주니어)**
> - 임계값 설정: 정적 vs 동적
> - 알림 규칙 작성 (Prometheus Alerting Rules)
> - Alertmanager: 그룹화, 억제, 라우팅
> - on-call 로테이션 기초
>
> **Q: 알림 그룹화(Grouping)가 필요한 이유는?**
> **A:** 하나의 장애가 수십 개 알림을 발생시킬 수 있다. 그룹화하면 관련 알림을 하나의 알림으로 묶어 보낸다. Alertmanager에서 group_by로 설정. 예: 같은 서비스의 알림을 그룹화.
>
> **Q: 알림 억제(Inhibition)란?**
> **A:** 상위 알림이 발생하면 하위 알림을 억제한다. 예: "서버 다운" 알림 발생 시 해당 서버의 "서비스 응답 없음" 알림 억제. 중복 알림을 줄이고 근본 원인에 집중할 수 있다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - SLO 기반 알림 (번 레이트 알림)
> - 다중 윈도우 알림
> - 에스컬레이션 정책
> - 알림 품질 메트릭
>
> **Q: SLO 기반 알림이란?**
> **A:** 에러 버짓 소진율(Burn Rate)을 기반으로 알림한다. 예: "현재 속도로 28일 에러 버짓이 3일 내 소진" 시 알림. 비즈니스 영향과 연계되어 더 의미 있는 알림이다. Google SRE Workbook 참조.
>
> **Q: 다중 윈도우(Multi-window) 알림의 장점은?**
> **A:** 단기(5분) + 장기(1시간) 윈도우를 함께 사용. 단기만 보면 일시적 스파이크에 반응, 장기만 보면 반응이 늦음. 둘 다 만족해야 알림하여 정확도 향상. `for` 조건과 유사하지만 더 정교함.
>
> **Q: 알림 품질을 측정하는 지표는?**
> **A:** MTTA(Mean Time To Acknowledge): 알림 확인까지 시간. MTTR: 해결까지 시간. 거짓 양성률: 조치 불필요한 알림 비율. 알림당 조치 비율: 실제 조치로 이어진 비율. 90% 이상 조치 가능해야 건강한 알림.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 알림 전략 수립
> - 온콜 문화 구축
> - 인시던트 관리 통합
> - AIOps와 이상 탐지
>
> **Q: 건강한 온콜 문화를 만드는 방법은?**
> **A:** 공정한 로테이션, 적절한 보상, 알림 품질 관리, 충분한 런북, 비난 없는 포스트모템, 온콜 피드백 루프, 알림 개선 시간 확보, 번아웃 방지. 온콜이 학습 기회가 되도록 설계.
>
> **Q: AI/ML 기반 이상 탐지의 장단점은?**
> **A:** 장점: 정적 임계값 불필요, 패턴 변화 자동 감지, 계절성 고려. 단점: 블랙박스, 거짓 양성 가능, 튜닝 필요, 설명 어려움. 정적 알림 보완으로 사용하고 완전 대체는 신중하게.

### 실무 시나리오

**시나리오: Alertmanager 설정**
```yaml
global:
  resolve_timeout: 5m

route:
  receiver: 'default'
  group_by: ['alertname', 'service']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  routes:
    - match:
        severity: critical
      receiver: 'pagerduty'
    - match:
        severity: warning
      receiver: 'slack'

inhibit_rules:
  - source_match:
      alertname: 'InstanceDown'
    target_match_re:
      alertname: '.+'
    equal: ['instance']

receivers:
  - name: 'default'
    slack_configs:
      - channel: '#alerts'
  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: '<key>'
  - name: 'slack'
    slack_configs:
      - channel: '#alerts-warning'
```

### 면접 빈출 질문
- **Q: 알림이 너무 많을 때 어떻게 줄이는가?**
- **A:** 1) 조치 불가능한 알림 제거. 2) 임계값 재검토(너무 민감한지). 3) 유사 알림 통합. 4) 정보성 알림은 대시보드로 이동. 5) SLO 기반 알림으로 전환. 6) 정기적 알림 리뷰. 목표는 모든 알림이 조치 가능한 것.

---

## 9. SLI/SLO/SLA

### 개념 설명
SLI(Service Level Indicator)는 서비스 신뢰성을 측정하는 지표, SLO(Service Level Objective)는 목표치, SLA(Service Level Agreement)는 고객과의 계약이다. 이 프레임워크는 신뢰성 엔지니어링의 핵심이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - SLI: 측정 지표 (예: 가용성, 응답 시간)
> - SLO: 목표 (예: 99.9% 가용성)
> - SLA: 계약 (SLO 미달 시 보상)
>
> **Q: SLI, SLO, SLA의 관계는?**
> **A:** SLI는 "무엇을 측정하는가" (정상 요청 비율). SLO는 "얼마나 좋아야 하는가" (99.9%). SLA는 "못 지키면 어떻게 되는가" (환불). SLI를 기반으로 SLO를 설정하고, SLA는 SLO보다 느슨하게 설정한다.
>
> **Q: 99.9%와 99.99% 가용성의 차이는?**
> **A:** 99.9%(3 nines): 연간 8.76시간 다운타임 허용. 99.99%(4 nines): 연간 52분 다운타임 허용. 0.09% 차이지만 허용 다운타임은 10배 차이. 높은 SLO는 복잡성과 비용 증가를 의미한다.

> ⭐⭐ **Level 2 (주니어)**
> - 일반적인 SLI: 가용성, 지연 시간, 처리량, 에러율
> - SLO 표현 방법: "지난 30일간 99.9%"
> - 측정 방법: 서버 측 vs 클라이언트 측
> - 좋은 SLI 선택 기준
>
> **Q: 좋은 SLI의 조건은?**
> **A:** 사용자 경험과 직결(서버 CPU 아닌 응답 시간), 측정 가능, 의미 있는 범위(0-100%), 비교 가능. "사용자가 인지하는 품질"을 반영해야 한다.
>
> **Q: 서버 측과 클라이언트 측 SLI의 차이는?**
> **A:** 서버 측: 서버 로그/메트릭 기반, 수집 쉬움, 네트워크 이슈 미반영. 클라이언트 측(RUM): 실제 사용자 경험, 수집 복잡, 더 정확. 이상적으로 둘 다 측정하되, 최소 서버 측은 필수.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 에러 버짓(Error Budget) 개념과 활용
> - 번 레이트(Burn Rate) 알림
> - SLO 기반 의사결정
> - 복합 SLO
>
> **Q: 에러 버짓이란 무엇이고 어떻게 사용하는가?**
> **A:** 에러 버짓 = 1 - SLO. 99.9% SLO면 0.1% 에러 버짓. 30일 기준 1,000,000 요청이면 1,000개 에러 허용. 버짓 내에서 기능 개발 속도와 안정성의 균형. 버짓 소진 시 안정성 작업에 집중.
>
> **Q: 번 레이트(Burn Rate)란?**
> **A:** 에러 버짓 소비 속도. 번 레이트 1: 정확히 예산대로 소비. 번 레이트 2: 2배 속도로 소비(15일 내 고갈). 번 레이트 기반 알림은 임박한 SLO 위반을 예측할 수 있다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 조직 전체 SLO 프로그램
> - SLO 거버넌스
> - 비즈니스와 SLO 연계
> - SLO 문화 구축
>
> **Q: SLO를 조직에 도입하는 전략은?**
> **A:** 1) 핵심 서비스부터 시작. 2) 현재 성능 기반으로 초기 SLO 설정. 3) 측정 인프라 구축. 4) 정기 리뷰로 SLO 조정. 5) 에러 버짓을 팀 결정에 연계. 6) 경영진 지원 확보. 완벽한 SLO보다 시작이 중요.
>
> **Q: 적절한 SLO 수준을 정하는 방법은?**
> **A:** 사용자 기대(설문, 불만), 현재 성능(기준선), 경쟁사 수준, 비용(높은 SLO = 높은 비용), 의존성 SLO(최약 체인보다 높을 수 없음). 처음에는 현재 성능보다 약간 낮게 설정하고 점진적으로 높인다.

### 실무 시나리오

**시나리오: SLO 대시보드 구성**
```
┌─────────────────────────────────────────────┐
│ API Gateway SLO Status                       │
├─────────────────────────────────────────────┤
│ SLO: 99.9% requests < 200ms                 │
│ Current (30d): 99.95%                       │
│ Error Budget: 43 minutes remaining          │
│ Burn Rate (1h): 0.5x                        │
├─────────────────────────────────────────────┤
│ [Error Budget Timeline Graph - 30 days]     │
├─────────────────────────────────────────────┤
│ Top Error Contributors:                     │
│ 1. /api/search - 45% of errors             │
│ 2. /api/checkout - 30% of errors           │
└─────────────────────────────────────────────┘
```

### 면접 빈출 질문
- **Q: SLO 100%를 목표로 하지 않는 이유는?**
- **A:** 100%는 불가능하고 비용이 무한히 증가한다. 또한 100%를 목표로 하면 변화를 두려워하게 되어 혁신이 멈춘다. 적절한 에러 버짓 내에서 기능 개발과 안정성의 균형을 맞추는 것이 목표다.

---

## 10. Golden Signals, RED, USE Method

### 개념 설명
모니터링 메트릭 선택을 위한 프레임워크들이다. Golden Signals는 Google SRE에서, RED는 마이크로서비스에, USE는 시스템 리소스 분석에 적합하다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - Golden Signals: Latency, Traffic, Errors, Saturation
> - 서비스 상태 파악의 핵심 지표
>
> **Q: Golden Signals 4가지는?**
> **A:** Latency(지연): 요청 처리 시간. Traffic(트래픽): 요청량. Errors(에러): 실패한 요청 비율. Saturation(포화): 리소스 사용률. 이 4가지로 대부분의 서비스 문제를 감지할 수 있다.
>
> **Q: Golden Signals를 먼저 봐야 하는 이유는?**
> **A:** 가장 직접적인 서비스 상태 지표이다. 사용자가 느끼는 문제(느림, 에러)와 직결된다. 수많은 메트릭 중 어디서 시작할지 알려주는 프레임워크이다.

> ⭐⭐ **Level 2 (주니어)**
> - RED Method: Rate, Errors, Duration (마이크로서비스용)
> - USE Method: Utilization, Saturation, Errors (리소스용)
> - 각 메서드의 적용 대상
>
> **Q: RED와 USE의 차이와 언제 사용하는가?**
> **A:** RED(Rate, Errors, Duration): 서비스/엔드포인트별 모니터링. "이 API의 요청률, 에러율, 지연 시간". USE(Utilization, Saturation, Errors): CPU, 메모리, 디스크 등 리소스별 모니터링. "이 서버의 CPU 사용률, 대기 큐, 에러". RED로 서비스 문제 감지, USE로 원인 분석.
>
> **Q: Saturation을 측정하는 방법은?**
> **A:** 대기 큐 길이, 스레드 풀 사용률, 커넥션 풀 사용률 등. "얼마나 여유가 있는가"를 나타낸다. 높은 Utilization만으로는 문제 아닐 수 있지만, Saturation이 높으면 즉각적인 조치 필요.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 프레임워크 조합 활용
> - 대시보드 구성 전략
> - 커스텀 메트릭 설계
> - 메트릭 수집 구현
>
> **Q: Golden Signals + RED + USE 조합 전략은?**
> **A:** 서비스 대시보드: Golden Signals / RED로 시작. 인프라 대시보드: USE로 리소스 모니터링. 문제 발생 시 흐름: Golden Signals로 감지 -> USE로 리소스 병목 확인 -> 상세 메트릭으로 원인 분석.
>
> **Q: Latency 메트릭의 함정은?**
> **A:** 평균은 오해를 유발한다. p50=100ms, p99=3s인 경우 평균은 정상처럼 보인다. 항상 분위수(p50, p90, p99) 사용. 성공/실패 분리 측정(실패는 빠를 수 있음). 히스토그램으로 분포 파악.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 조직 전체 메트릭 표준화
> - 메트릭 카탈로그 관리
> - 자동화된 메트릭 수집
> - 비즈니스 메트릭과 기술 메트릭 연계
>
> **Q: 비즈니스 메트릭을 관측성에 통합하는 방법은?**
> **A:** 주문 수, 결제 성공률, 사용자 가입 등을 기술 메트릭과 함께 수집. 기술 문제가 비즈니스에 미치는 영향 측정. 비즈니스 SLI 정의. 대시보드에 비즈니스/기술 메트릭 병행 표시.

### 실무 시나리오

**시나리오: 서비스 대시보드 구성 (RED 기반)**
```
┌─────────────────────────────────────────────┐
│ Payment Service Dashboard                    │
├─────────────────────────────────────────────┤
│ Rate: [Request Rate Graph] 1.2K/s           │
├─────────────────────────────────────────────┤
│ Errors: [Error Rate Graph] 0.05%            │
│ By Type: 4xx: 0.03%, 5xx: 0.02%             │
├─────────────────────────────────────────────┤
│ Duration:                                    │
│ p50: 45ms | p90: 120ms | p99: 450ms         │
│ [Latency Heatmap]                           │
└─────────────────────────────────────────────┘
```

### 면접 빈출 질문
- **Q: 평균 응답 시간이 좋은데 사용자 불만이 있다면?**
- **A:** p99, p99.9 확인 필요. 소수 사용자가 매우 느린 응답을 받을 수 있다. 평균은 이상치를 숨긴다. 히스토그램으로 분포 확인. 특정 사용자 그룹(지역, 디바이스)에서 문제가 있을 수 있다.

---

## 11. APM (Application Performance Monitoring)

### 개념 설명
APM은 애플리케이션 성능을 모니터링하고 분석하는 도구이다. 트랜잭션 추적, 에러 분석, 코드 레벨 프로파일링을 제공한다. Datadog, New Relic, Sentry, Dynatrace 등이 대표적이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - APM이 제공하는 기능: 트랜잭션 추적, 에러 모니터링
> - 주요 APM 도구 비교
> - 에이전트 기반 vs 에이전트리스
>
> **Q: APM이 일반 모니터링과 다른 점은?**
> **A:** 일반 모니터링: 인프라/시스템 레벨(CPU, 메모리). APM: 애플리케이션 레벨(트랜잭션, 코드 성능). APM은 "어떤 API 호출에서 어떤 함수가 느린가"까지 파악 가능하다.
>
> **Q: Sentry와 Datadog APM의 차이는?**
> **A:** Sentry: 에러 추적 특화, 스택트레이스, 이슈 그룹화, 저렴함. Datadog APM: 풀스택 관측성, 인프라/로그 통합, 비용 높음. 에러 중심은 Sentry, 전체 성능은 Datadog. 함께 사용도 가능.

> ⭐⭐ **Level 2 (주니어)**
> - 트랜잭션 트레이싱
> - 느린 쿼리 탐지
> - 에러 그룹화와 알림
> - 코드 배포와 성능 상관관계
>
> **Q: APM에서 트랜잭션이란?**
> **A:** 하나의 요청 처리 과정 전체. HTTP 요청 수신부터 응답까지. 포함 내용: 외부 호출, DB 쿼리, 코드 실행 시간. 분산 트레이싱의 단일 서비스 버전이라고 볼 수 있다.
>
> **Q: 에러 그룹화(Error Grouping)의 원리는?**
> **A:** 같은 원인의 에러를 하나의 이슈로 그룹화. 스택트레이스, 에러 메시지, 발생 위치를 기준으로 판단. 100개의 동일 에러를 1개 이슈로 표시. Sentry의 핵심 기능.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 프로파일링: CPU, 메모리
> - 코드 레벨 성능 분석
> - APM 에이전트 오버헤드 관리
> - 커스텀 계측
>
> **Q: 프로덕션 프로파일링의 고려사항은?**
> **A:** 오버헤드(1-5% 허용), 샘플링으로 영향 최소화, 민감 데이터 마스킹, 연속 프로파일링 vs 온디맨드. Datadog Continuous Profiler, Pyroscope 등. 코드 레벨 병목 발견에 필수.
>
> **Q: APM 에이전트 오버헤드를 줄이는 방법은?**
> **A:** 샘플링 비율 조정, 불필요한 트랜잭션 제외, 스팬 개수 제한, 비동기 전송, 배치 처리. 모니터링이 성능에 영향을 주면 안 된다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - APM 도구 선택 전략
> - 멀티 APM 환경 관리
> - ROI 분석
> - APM과 비즈니스 메트릭 연계
>
> **Q: APM 도구 선택 시 고려사항은?**
> **A:** 지원 언어/프레임워크, 기존 스택 통합, 가격 모델(호스트 vs 이벤트), 데이터 보존, 학습 곡선, 벤더 종속성. 평가: POC 진행, 실제 워크로드 테스트, 숨겨진 비용 확인.

### 실무 시나리오

**시나리오: Sentry 에러 분석**
1. 새 에러 알림 수신
2. Sentry에서 이슈 확인: 영향받은 사용자 수, 발생 빈도
3. 스택트레이스로 코드 위치 파악
4. Breadcrumbs로 에러 전 사용자 행동 확인
5. 태그로 환경, 버전, 사용자 정보 확인
6. 이슈 할당하고 수정

### 면접 빈출 질문
- **Q: 무료 APM 대안은?**
- **A:** Sentry(에러 모니터링, 무료 티어 있음), Grafana Tempo(트레이싱), Pyroscope(프로파일링), OpenTelemetry + Jaeger(트레이싱). 조합하면 상용 APM 대부분 기능 구현 가능. 단, 통합/관리 비용 고려.

---

## 12. 로그 수집 파이프라인

### 개념 설명
로그 수집 파이프라인은 분산된 로그를 중앙으로 수집, 처리, 저장하는 시스템이다. 구조화, 필터링, 라우팅을 통해 효율적인 로그 관리를 가능하게 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 중앙 집중식 로깅의 필요성
> - 로그 레벨: DEBUG, INFO, WARN, ERROR, FATAL
> - 기본 로그 수집 도구: Filebeat, Fluentd, Promtail
>
> **Q: 왜 중앙 집중식 로깅이 필요한가?**
> **A:** 분산 시스템에서 각 서버에 SSH로 접속하여 로그를 확인하는 것은 비효율적이다. 중앙 집중화하면: 검색 용이, 상관관계 분석, 장애 시에도 접근 가능, 보안/감사, 장기 보관.
>
> **Q: 적절한 로그 레벨 사용법은?**
> **A:** DEBUG: 개발/디버깅용 상세 정보. INFO: 정상 동작 기록. WARN: 잠재적 문제, 복구 가능. ERROR: 에러 발생, 기능 실패. FATAL: 시스템 중단. 프로덕션은 INFO 이상, 문제 시 DEBUG 활성화.

> ⭐⭐ **Level 2 (주니어)**
> - 구조화 로그(Structured Logging) 구현
> - 로그 파싱과 변환
> - 로그 로테이션과 관리
> - 민감 정보 마스킹
>
> **Q: 구조화 로그를 구현하는 방법은?**
> **A:** JSON 포맷 사용: `{"timestamp":"...", "level":"INFO", "message":"...", "user_id":123}`. 로깅 라이브러리 설정(winston, logrus, structlog). 일관된 필드 명명 규칙. 컨텍스트 자동 추가(request_id, trace_id).
>
> **Q: 민감 정보 마스킹 전략은?**
> **A:** 로그 생성 시점에 마스킹(권장), 수집 파이프라인에서 필터링, 정규식으로 패턴 매칭(신용카드, 이메일). 마스킹 대상: 비밀번호, 토큰, 개인정보, 카드번호. 로그에 민감 정보를 애초에 포함하지 않는 것이 최선.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 대용량 로그 파이프라인 설계
> - 버퍼링과 배압(Backpressure)
> - 로그 집계와 샘플링
> - 비용 최적화
>
> **Q: 로그 파이프라인에서 배압(Backpressure) 처리는?**
> **A:** 수신 측이 처리 못 할 때 송신 측을 조절. 전략: 버퍼링(메모리/디스크), 드롭(덜 중요한 로그), 속도 제한, 백오프. Fluentd의 buffer, Kafka의 자연스러운 배압. 로그 유실 vs 시스템 안정성 트레이드오프.
>
> **Q: 로그 비용을 줄이는 방법은?**
> **A:** 로그 레벨 조정(DEBUG 제거), 불필요한 필드 제거, 샘플링(성공 요청은 10%만), 압축, 보존 기간 단축, 핫/콜드 티어링, 로그 집계(동일 메시지 카운트). 인덱싱 비용이 크므로 Loki 고려.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 로그 플랫폼 아키텍처
> - 컴플라이언스와 로그 보관
> - 로그 기반 보안 분석
> - 로그 표준화 전략
>
> **Q: 대규모 로그 아키텍처 설계 시 고려사항은?**
> **A:** 수집: 에이전트 배포 전략, 신뢰성. 버퍼: Kafka로 decoupling. 처리: 스트리밍 vs 배치. 저장: 핫/웜/콜드 티어. 쿼리: 인덱싱 전략. 비용: 스토리지, 인덱스, 쿼리. 보안: 접근 제어, 암호화.

### 실무 시나리오

**시나리오: Fluentd 파이프라인 구성**
```
<source>
  @type tail
  path /var/log/app/*.log
  pos_file /var/log/td-agent/app.log.pos
  tag app.logs
  <parse>
    @type json
  </parse>
</source>

<filter app.logs>
  @type record_transformer
  <record>
    hostname "#{Socket.gethostname}"
  </record>
</filter>

<filter app.logs>
  @type grep
  <exclude>
    key level
    pattern /^DEBUG$/
  </exclude>
</filter>

<match app.logs>
  @type forward
  <server>
    host log-aggregator
    port 24224
  </server>
  <buffer>
    @type file
    path /var/log/td-agent/buffer
    flush_interval 5s
    retry_max_times 3
  </buffer>
</match>
```

### 면접 빈출 질문
- **Q: 로그와 메트릭 중 어느 것이 더 중요한가?**
- **A:** 둘 다 필수적이며 용도가 다르다. 메트릭: 전체 상태 파악, 알림, 트렌드. 로그: 상세 디버깅, 감사. 메트릭으로 "문제 있음"을 감지하고, 로그로 "왜 문제인가"를 분석한다. 하나만 선택해야 한다면 메트릭이 먼저.

---

## 13. 이상 탐지 (Anomaly Detection)

### 개념 설명
이상 탐지는 정상 패턴에서 벗어난 동작을 자동으로 감지한다. 정적 임계값의 한계를 보완하고, 알려지지 않은 문제를 발견할 수 있다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 정적 임계값의 한계
> - 이상 탐지의 개념과 필요성
> - 기본 접근: 이동 평균, 표준 편차
>
> **Q: 정적 임계값의 문제점은?**
> **A:** 트래픽이 시간/요일에 따라 변하면 적절한 임계값 설정이 어렵다. 낮에는 정상인 값이 새벽에는 이상일 수 있다. 수동 관리 부담, 계절성 미반영, 점진적 변화 감지 어려움.
>
> **Q: 이상 탐지의 기본 원리는?**
> **A:** 정상 범위를 학습하고 벗어나면 탐지. 단순: 평균 +/- 3 표준편차. 고급: 시계열 분해(트렌드, 계절성, 잔차), ML 모델. 정상 상태 정의가 핵심.

> ⭐⭐ **Level 2 (주니어)**
> - 통계 기반: Z-score, IQR, 이동 평균
> - 계절성과 트렌드 고려
> - 거짓 양성/거짓 음성 트레이드오프
> - 기본 ML 접근: Isolation Forest
>
> **Q: Z-score 기반 탐지 방법은?**
> **A:** Z = (값 - 평균) / 표준편차. |Z| > 3이면 이상치(99.7% 신뢰). 장점: 단순, 해석 쉬움. 단점: 정규분포 가정, 극단값에 민감, 계절성 미반영. 기본 베이스라인으로 사용.
>
> **Q: 거짓 양성을 줄이는 방법은?**
> **A:** 민감도 조정(임계값 높이기), 연속 이상 요구(한 번은 무시), 비즈니스 컨텍스트 추가(점검 시간 제외), 피드백 루프(거짓 양성 학습), 다중 알고리즘 앙상블.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 시계열 분해: STL, Prophet
> - ML 기반: LSTM, Autoencoder
> - 다변량 이상 탐지
> - 실시간 vs 배치 탐지
>
> **Q: 시계열 분해(Decomposition)란?**
> **A:** 시계열을 트렌드(장기 방향), 계절성(주기적 패턴), 잔차(노이즈)로 분리. STL, Prophet 등. 잔차에서 이상 탐지하면 계절성에 속지 않음. 주간 트래픽 패턴이 있어도 정확한 탐지 가능.
>
> **Q: 실시간 이상 탐지의 어려움은?**
> **A:** 충분한 컨텍스트 부족(과거 데이터 제한), 지연 시간 요구, 연산 비용, 스트리밍 처리 복잡성. 해결: 온라인 알고리즘, 슬라이딩 윈도우, 사전 계산된 통계, 근사치 허용.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - AIOps 전략
> - 이상 탐지 플랫폼 구축
> - 설명 가능한 이상 탐지
> - ROI와 가치 측정
>
> **Q: AIOps 도입 전략은?**
> **A:** 점진적 도입: 1) 데이터 수집/정리. 2) 단순 이상 탐지 시작. 3) 알림 노이즈 감소. 4) 근본 원인 분석. 5) 자동 복구. 기대 관리 중요, 완전 자동화는 먼 목표, 인간 판단 보조로 시작.
>
> **Q: 이상 탐지의 ROI를 측정하는 방법은?**
> **A:** MTTD(Mean Time To Detect) 개선, 발견된 인시던트 수, 거짓 양성으로 낭비된 시간 감소, 놓친 인시던트 감소, 자동화로 절약된 시간. 정량적 측정 어렵지만 추적 필요.

### 실무 시나리오

**시나리오: Prometheus + Grafana 이상 탐지**
```promql
# Z-score 기반 이상 탐지
(
  http_request_duration_seconds:rate5m
  - avg_over_time(http_request_duration_seconds:rate5m[1d])
) / stddev_over_time(http_request_duration_seconds:rate5m[1d]) > 3

# 이동 평균 대비 이상 탐지
http_request_duration_seconds:rate5m
  > 1.5 * avg_over_time(http_request_duration_seconds:rate5m[1h])
```

### 면접 빈출 질문
- **Q: 이상 탐지가 정적 임계값을 완전히 대체할 수 있는가?**
- **A:** 아니다. 정적 임계값은 명확한 한계(디스크 90%)에 적합하고 해석이 쉽다. 이상 탐지는 패턴 변화 감지에 적합하지만 블랙박스일 수 있다. 둘을 조합: 명확한 한계는 정적, 패턴 기반은 이상 탐지.

---

## 참고 자료

- [Google SRE Books](https://sre.google/books/)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Loki Documentation](https://grafana.com/docs/loki/)
- [Elastic Stack Documentation](https://www.elastic.co/guide/)
- [Brendan Gregg's Blog](https://www.brendangregg.com/)
- [SLO 기반 알림 - Google SRE Workbook](https://sre.google/workbook/alerting-on-slos/)