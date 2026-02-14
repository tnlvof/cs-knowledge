-- CS Knowledge Quiz - Network & Linux 실전/시나리오형 추가 문제 50개
-- 생성일: 2024-02
-- 난이도 1: level_min=1, level_max=25 (~12문제)
-- 난이도 2: level_min=10, level_max=50 (~15문제)
-- 난이도 3: level_min=30, level_max=75 (~13문제)
-- 난이도 4: level_min=50, level_max=100 (~10문제)

-- =============================================
-- NETWORK 문제 (25개)
-- =============================================

-- 난이도 1: 네트워크 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'dns', 1, 1, 25, '웹사이트 접속 시 "DNS_PROBE_FINISHED_NXDOMAIN" 에러가 발생했습니다. 사용자에게 어떤 조치를 안내해야 하나요?', 'DNS 캐시 플러시(Windows: ipconfig /flushdns, Mac: sudo dscacheutil -flushcache)를 먼저 시도하고, 그래도 안 되면 DNS 서버를 8.8.8.8이나 1.1.1.1로 변경하도록 안내합니다. 도메인 자체가 존재하지 않거나 만료된 경우일 수도 있으므로 도메인 상태도 확인합니다.', ARRAY['DNS', 'NXDOMAIN', 'DNS캐시', 'DNS서버변경'], 'NXDOMAIN은 도메인이 존재하지 않음을 의미합니다. 로컬 캐시 문제이거나 실제로 도메인이 없는 경우입니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'http', 1, 1, 25, '개발 중인 API에서 PUT 요청을 보냈는데 서버가 405 Method Not Allowed를 반환합니다. 어떤 부분을 확인해야 하나요?', '서버 라우터 설정에서 해당 엔드포인트가 PUT 메서드를 허용하는지 확인합니다. CORS 설정에서 Access-Control-Allow-Methods에 PUT이 포함되어 있는지도 확인해야 합니다. 또한 일부 호스팅 환경에서는 PUT/DELETE를 기본 차단하므로 서버 설정도 점검합니다.', ARRAY['HTTP', '405', 'PUT', 'Method Not Allowed', 'CORS'], '405는 요청한 HTTP 메서드가 해당 리소스에서 지원되지 않음을 의미합니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'tls', 1, 1, 25, '사용자들이 웹사이트 접속 시 "Your connection is not private" 또는 "NET::ERR_CERT_DATE_INVALID" 에러를 보고합니다. 가장 먼저 확인해야 할 것은 무엇인가요?', 'SSL 인증서의 유효기간 만료 여부를 가장 먼저 확인합니다. 인증서가 만료되었다면 즉시 갱신해야 합니다. Let''s Encrypt 등 자동 갱신이 설정되어 있는지도 확인하고, 갱신 실패 원인(디스크 용량, 도메인 검증 실패 등)을 파악합니다.', ARRAY['SSL', 'TLS', '인증서만료', 'HTTPS'], '인증서 만료는 가장 흔한 HTTPS 에러 원인입니다. certbot renew --dry-run으로 갱신 테스트를 할 수 있습니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'tcp', 1, 1, 25, '서버에 telnet으로 특정 포트 연결을 테스트했는데 "Connection refused"가 나옵니다. 이 에러의 의미와 확인해야 할 사항은 무엇인가요?', 'Connection refused는 해당 포트에서 서비스가 리스닝하고 있지 않음을 의미합니다. 서버에서 netstat -tlnp 또는 ss -tlnp로 서비스가 해당 포트에서 실행 중인지 확인하고, 서비스가 올바른 IP(0.0.0.0 또는 특정 IP)에 바인딩되어 있는지 점검합니다.', ARRAY['TCP', 'Connection refused', 'telnet', '포트', 'LISTEN'], 'Connection refused는 방화벽이 아닌 서비스 자체가 없을 때 발생합니다. 방화벽 차단 시에는 timeout이 발생합니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'http', 1, 1, 25, '웹 애플리케이션에서 이미지 파일이 갱신되었는데 사용자들에게 여전히 이전 이미지가 보입니다. CDN을 사용하고 있을 때 이 문제를 해결하는 방법은?', '파일명에 버전 해시를 추가(예: logo.abc123.png)하거나 쿼리스트링으로 버전 관리(logo.png?v=2)를 합니다. 급한 경우 CDN에서 캐시 무효화(purge/invalidation)를 수행합니다. 장기적으로는 빌드 시 자동으로 파일명에 해시를 추가하는 방식을 권장합니다.', ARRAY['CDN', '캐시', '캐시무효화', '버저닝', 'purge'], '파일명 해시 방식이 캐시 무효화보다 효율적이고 즉시 적용됩니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'websocket', 1, 1, 25, '실시간 채팅 기능에서 WebSocket 연결이 자주 끊어진다는 사용자 보고가 있습니다. 클라이언트 측에서 구현해야 할 기본적인 안정성 대책은 무엇인가요?', '지수 백오프(exponential backoff) 방식의 자동 재연결 로직을 구현합니다. 초기 1초 대기 후 2초, 4초, 8초로 늘려가며 최대값까지 대기합니다. 재연결 폭주 방지를 위해 jitter(랜덤 지연)를 추가하고, 연결 상태를 사용자에게 표시합니다.', ARRAY['WebSocket', '재연결', 'exponential backoff', '실시간통신'], 'WebSocket 연결은 네트워크 변경, 유휴 타임아웃 등으로 끊길 수 있으므로 재연결 로직이 필수입니다.', 'docs/01-network.md');

-- 난이도 2: 네트워크 (8문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'dns', 2, 10, 50, '새 서버로 마이그레이션을 계획하고 있습니다. DNS TTL을 고려한 마이그레이션 절차를 단계별로 설명해주세요.', '1) 마이그레이션 3일 전 TTL을 300초 이하로 낮춤 2) 새 서버 준비 및 테스트 완료 3) A 레코드를 새 서버 IP로 변경 4) 48시간 동안 양쪽 서버 유지 및 모니터링 5) 안정화 확인 후 TTL을 3600초 이상으로 복원 6) 이전 서버 종료. TTL을 미리 낮추는 이유는 변경 시 빠른 전파를 위해서입니다.', ARRAY['DNS', 'TTL', '마이그레이션', 'DNS전파', 'A레코드'], 'TTL이 24시간이면 변경 후에도 24시간 동안 이전 캐시가 사용될 수 있습니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'http', 2, 10, 50, 'API 서버에서 CORS 에러 "Access to fetch has been blocked by CORS policy"가 발생합니다. Nginx에서 이를 해결하기 위한 설정은 어떻게 해야 하나요?', 'Nginx location 블록에 다음을 추가합니다: add_header ''Access-Control-Allow-Origin'' ''https://app.example.com'', add_header ''Access-Control-Allow-Methods'' ''GET, POST, PUT, DELETE, OPTIONS'', add_header ''Access-Control-Allow-Headers'' ''Authorization, Content-Type''. OPTIONS 요청에 대해 204를 반환하도록 설정합니다. 와일드카드(*)보다 특정 도메인 지정을 권장합니다.', ARRAY['CORS', 'Nginx', 'Preflight', 'OPTIONS', 'Access-Control'], 'CORS는 브라우저 보안 정책으로, 서버에서 허용 헤더를 명시해야 합니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'tcp', 2, 10, 50, '서버에서 netstat으로 확인했더니 TIME_WAIT 상태 연결이 수만 개입니다. 이 상황의 원인과 해결 방법을 설명해주세요.', 'TIME_WAIT은 TCP 연결 종료 후 지연 패킷 처리를 위해 2MSL(보통 60초) 동안 유지됩니다. 단기 해결: tcp_tw_reuse 활성화(sysctl -w net.ipv4.tcp_tw_reuse=1). 근본 해결: HTTP Keep-Alive 활성화, Connection Pool 사용, 연결 재사용. 주의: tcp_tw_recycle은 NAT 환경에서 문제를 일으켜 최신 커널에서 제거됨.', ARRAY['TIME_WAIT', 'TCP', 'tcp_tw_reuse', 'Connection Pool'], 'TIME_WAIT이 많으면 로컬 포트가 소진되어 새 연결이 실패할 수 있습니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'loadbalancing', 2, 10, 50, '로드밸런서 뒤의 서버 한 대가 죽었는데 일부 사용자만 에러를 경험합니다. 이 상황의 원인과 확인 사항은 무엇인가요?', '헬스체크가 정상 동작하지 않거나 체크 간격이 너무 길 수 있습니다. 확인사항: 1) 헬스체크 엔드포인트가 실제 서비스 상태를 반영하는지 2) 체크 간격과 실패 임계값 설정 3) Sticky Session 사용 시 특정 사용자가 죽은 서버에 고정되었는지 4) DNS 캐싱으로 일부 클라이언트가 죽은 서버 직접 연결하는지.', ARRAY['로드밸런서', '헬스체크', 'Sticky Session', '고가용성'], '헬스체크는 단순 포트 확인보다 실제 애플리케이션 상태를 확인하는 것이 좋습니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'tls', 2, 10, 50, 'SSL Labs 테스트에서 서버가 "B" 등급을 받았습니다. "A" 등급을 받기 위해 확인해야 할 주요 설정 항목들은 무엇인가요?', '1) TLS 1.2 이상만 허용 (TLS 1.0, 1.1 비활성화) 2) 약한 암호화 스위트 제거 (RC4, 3DES, MD5, SHA1 등) 3) PFS(Perfect Forward Secrecy) 지원 (ECDHE 우선) 4) HSTS 헤더 추가 5) 중간 인증서 체인 완전 포함 6) OCSP Stapling 활성화. A+ 등급에는 HSTS preload까지 필요합니다.', ARRAY['SSL', 'TLS', 'SSL Labs', 'HSTS', 'PFS'], 'TLS 1.3 사용 시 자동으로 취약한 암호화가 제거됩니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'cdn', 2, 10, 50, 'CDN을 도입했는데 오히려 응답 속도가 느려졌다는 보고가 있습니다. 어떤 원인들을 점검해야 하나요?', '1) 캐시 히트율 확인 - 동적 콘텐츠 비중이 높거나 TTL이 너무 짧으면 히트율 저하 2) 캐시 키 설정 확인 - 불필요한 쿼리스트링이나 헤더로 캐시가 분산되는지 3) 오리진과 엣지 거리 - 로컬 서비스인데 해외 엣지를 거치는지 4) SSL 핸드셰이크 오버헤드 5) CDN 설정 오류로 매번 오리진 호출하는지 확인.', ARRAY['CDN', '캐시히트율', 'TTL', '캐시키'], 'CDN 효과는 캐시 가능한 정적 콘텐츠 비율과 지역 분포에 따라 다릅니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'firewall', 2, 10, 50, 'AWS Security Group에서 인바운드로 특정 포트를 열었는데 여전히 연결이 안 됩니다. 체크해야 할 다른 네트워크 설정들은 무엇인가요?', '1) NACL(Network ACL)에서 해당 포트가 허용되어 있는지 - NACL은 stateless라 인바운드/아웃바운드 모두 확인 2) 라우팅 테이블에 인터넷 게이트웨이 또는 NAT 게이트웨이 경로 설정 3) EC2 인스턴스의 로컬 방화벽(iptables, firewalld) 4) 서비스가 0.0.0.0으로 바인딩되어 있는지 또는 127.0.0.1인지.', ARRAY['Security Group', 'NACL', 'AWS', '방화벽', '라우팅'], 'AWS는 SG, NACL, 라우팅 테이블, 인스턴스 방화벽 등 여러 계층의 네트워크 제어가 있습니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'dns', 2, 10, 50, '이메일 발송이 스팸으로 분류되거나 반송됩니다. DNS에서 확인해야 할 이메일 관련 레코드들은 무엇인가요?', '1) SPF(TXT 레코드): 발송 허용 서버 IP 목록 지정, v=spf1 include:... -all 2) DKIM(TXT 레코드): 이메일 서명 검증용 공개키 3) DMARC(TXT 레코드): SPF/DKIM 실패 시 정책 정의, v=DMARC1; p=quarantine 4) MX 레코드: 메일 서버 지정 및 우선순위. dig 또는 nslookup으로 각 레코드가 올바르게 설정되어 있는지 확인합니다.', ARRAY['SPF', 'DKIM', 'DMARC', 'MX', '이메일', 'DNS'], 'SPF, DKIM, DMARC는 이메일 발신자 인증의 3대 요소입니다.', 'docs/01-network.md');

-- 난이도 3: 네트워크 (7문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'tcp', 3, 30, 75, '대용량 파일 전송 서버에서 TCP 처리량이 예상보다 낮습니다. BDP(Bandwidth-Delay Product)를 고려한 커널 튜닝 방법을 설명해주세요.', 'BDP = 대역폭 × RTT 입니다. 1Gbps 회선에서 RTT 100ms면 BDP = 12.5MB가 됩니다. TCP 버퍼가 BDP보다 작으면 대역폭을 충분히 활용 못합니다. 튜닝: net.core.rmem_max, net.core.wmem_max를 BDP 이상으로 설정, net.ipv4.tcp_rmem, net.ipv4.tcp_wmem의 max 값 조정. 또한 TCP 혼잡 제어 알고리즘을 BBR로 변경하면 효과적입니다.', ARRAY['BDP', 'TCP버퍼', '처리량', 'BBR', '커널튜닝'], 'TCP BBR은 패킷 손실이 아닌 대역폭 추정 기반으로 동작하여 대용량 전송에 효과적입니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'http', 3, 30, 75, 'HTTP/2를 적용했는데 특정 환경에서 오히려 느려졌습니다. HTTP/2의 잠재적 성능 문제와 대응 방안을 설명해주세요.', 'HTTP/2의 문제점: 1) TCP HOL(Head-of-Line) blocking - 패킷 손실 시 모든 스트림이 영향받음 2) 패킷 손실이 많은 네트워크에서 다중 HTTP/1.1 연결보다 느릴 수 있음. 대응: 1) HTTP/3(QUIC)로 업그레이드 - 스트림 단위 HOL blocking 해결 2) 패킷 손실 원인 해결(네트워크 품질 개선) 3) 모바일/불안정 네트워크에서는 HTTP/3 우선 시도하고 폴백.', ARRAY['HTTP/2', 'HTTP/3', 'QUIC', 'HOL blocking', 'TCP'], 'HTTP/3는 UDP 기반 QUIC을 사용하여 TCP의 근본적인 HOL blocking 문제를 해결합니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'loadbalancing', 3, 30, 75, 'L4와 L7 로드밸런서를 조합하여 사용하는 아키텍처의 장점과 구성 방법을 설명해주세요.', '구성: L4(NLB) → L7(ALB/Nginx). 장점: 1) L4가 대용량 트래픽을 빠르게 분산하고 L7가 세밀한 라우팅 수행 2) L7 로드밸런서의 수평 확장 가능 3) TLS 종료 위치 유연성 4) L4에서 DDoS 방어, L7에서 애플리케이션 라우팅 분리. AWS 예: NLB(고성능 TCP 분산) → ALB(경로 기반 라우팅, 헤더 검사). 주의: 클라이언트 IP 보존을 위해 Proxy Protocol 설정 필요.', ARRAY['L4', 'L7', 'NLB', 'ALB', '로드밸런서아키텍처'], 'L4와 L7 조합은 대규모 트래픽 처리와 세밀한 라우팅을 모두 달성할 수 있습니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'websocket', 3, 30, 75, 'WebSocket 서버를 수평 확장할 때 발생하는 문제와 해결 아키텍처를 설명해주세요.', '문제: WebSocket은 stateful하여 연결이 특정 서버에 고정됨. 서버A 클라이언트가 서버B 클라이언트에게 메시지를 보내려면 서버 간 통신 필요. 해결: 1) Redis Pub/Sub 또는 Kafka로 서버 간 메시지 브로드캐스트 2) Sticky Session으로 같은 클라이언트는 같은 서버로 3) 연결 상태를 Redis에 저장하여 공유 4) Socket.IO의 Redis Adapter 같은 도구 활용. 추가 고려: Graceful shutdown 시 기존 연결 마이그레이션.', ARRAY['WebSocket', '수평확장', 'Redis Pub/Sub', 'Sticky Session'], 'WebSocket 확장은 stateful 특성 때문에 HTTP보다 복잡합니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'tls', 3, 30, 75, '마이크로서비스 환경에서 서비스 간 통신에 mTLS를 도입하려고 합니다. 구현 시 고려사항과 인증서 관리 방안을 설명해주세요.', '고려사항: 1) 인증서 발급/갱신 자동화 - Vault PKI, cert-manager(K8s) 사용 2) 짧은 유효기간(24시간~7일)으로 보안 강화 3) 인증서 로테이션 중 downtime 방지 4) 성능 영향 - TLS 핸드셰이크 오버헤드 5) 디버깅 복잡성 증가. 구현: 서비스 메시(Istio, Linkerd)가 사이드카로 mTLS 자동 처리하여 애플리케이션 코드 변경 없이 적용. 또는 SPIFFE/SPIRE로 워크로드 ID 관리.', ARRAY['mTLS', '마이크로서비스', 'Vault', 'cert-manager', '서비스메시'], 'mTLS는 Zero Trust 아키텍처의 핵심 요소로, 서비스 메시가 관리를 크게 단순화합니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'tcp', 3, 30, 75, '서버에서 SYN flood 공격이 의심됩니다. 탐지 방법과 커널 레벨 대응 설정을 설명해주세요.', '탐지: 1) netstat -s | grep SYN으로 SYN_RECV 상태 급증 확인 2) ss -s로 SYN-RECV 소켓 수 확인 3) dmesg에서 "TCP: request_sock_TCP: Possible SYN flooding" 메시지. 대응: 1) net.ipv4.tcp_syncookies=1 활성화 - 백로그 가득 차도 SYN 쿠키로 처리 2) net.ipv4.tcp_max_syn_backlog 증가 3) net.ipv4.tcp_synack_retries 감소(기본 5→2) 4) iptables로 rate limiting. 추가로 방화벽이나 DDoS 방어 서비스 사용.', ARRAY['SYN flood', 'DDoS', 'tcp_syncookies', 'SYN_RECV'], 'SYN cookie는 서버 리소스 없이 연결 정보를 쿠키로 인코딩하여 SYN flood를 완화합니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'dns', 3, 30, 75, '글로벌 서비스에서 사용자를 가장 가까운 리전으로 라우팅하기 위한 DNS 기반 전략을 설명해주세요.', '1) GeoDNS: 클라이언트 IP의 지리적 위치 기반 응답 - Route53 Geolocation, Cloudflare Load Balancing 2) Latency-based routing: 실제 지연 시간 측정 기반 - Route53 Latency Routing 3) Anycast: 동일 IP를 여러 PoP에서 BGP announce - Cloudflare, Google 사용 방식. 조합: DNS로 리전 선택 → 리전 내 로드밸런서로 서버 분배. 주의: DNS 캐싱으로 실시간 전환 어려우므로 헬스체크와 failover 설정 필수, TTL 60-300초로 짧게.', ARRAY['GeoDNS', 'Anycast', 'Latency routing', '글로벌로드밸런싱'], 'DNS 기반 라우팅은 글로벌 분산의 첫 단계이며, 완벽한 실시간 제어는 어렵습니다.', 'docs/01-network.md');

-- 난이도 4: 네트워크 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'architecture', 4, 50, 100, 'HTTP/3 도입을 검토하고 있습니다. 인프라 관점에서의 준비사항과 점진적 롤아웃 전략을 수립해주세요.', '인프라 준비: 1) UDP 443 포트 방화벽/로드밸런서 허용 2) QUIC 지원 로드밸런서/CDN 확인(CloudFront, Cloudflare 지원) 3) 모니터링 도구의 HTTP/3 트래픽 분석 지원 4) 엔터프라이즈 네트워크 UDP 차단 대응 - HTTP/2 폴백 필수. 롤아웃: 1) CDN 엣지에서 먼저 활성화 2) ALT-SVC 헤더로 HTTP/3 가용성 알림 3) 5-10% 트래픽으로 시작해 모니터링 4) 모바일 앱에서 먼저 테스트(지연 시간 개선 효과 큼) 5) 에러율, 지연시간, 처리량 비교 후 확대.', ARRAY['HTTP/3', 'QUIC', 'UDP', 'ALT-SVC', '롤아웃전략'], 'HTTP/3는 UDP 기반이라 기존 TCP 기반 인프라와 다른 고려가 필요합니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'architecture', 4, 50, 100, '대규모 서비스에서 단일 CDN 장애에 대비한 멀티 CDN 전략을 설계해주세요.', '아키텍처: 1) DNS 레벨 전환 - 헬스체크 기반 자동 failover (Route53, NS1) 2) 실시간 성능 측정 - Cedexis, Citrix ITM으로 지역별 최적 CDN 선택 3) 오리진 앞에 CDN 추상화 계층 - 여러 CDN에 동일 설정 배포. 고려사항: 1) 캐시 키, 퍼지 API 등 CDN별 차이 추상화 2) SSL 인증서 각 CDN에 배포 3) 로그 포맷 통합 4) 비용 모니터링. Netflix 사례: 자체 Open Connect + 여러 CDN 조합, 실시간 품질 기반 라우팅.', ARRAY['멀티CDN', 'CDN페일오버', '고가용성', 'Cedexis'], 'Netflix는 2012년 CloudFront 장애 후 멀티 CDN 전략을 강화했습니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'security', 4, 50, 100, 'Zero Trust Network Architecture를 구현하기 위한 핵심 요소와 단계별 도입 전략을 설명해주세요.', '핵심 요소: 1) 강력한 인증 - MFA, 디바이스 인증서, 조건부 접근 2) 최소 권한 원칙 - 리소스별 세밀한 접근 제어 3) 마이크로세그멘테이션 - 워크로드별 네트워크 격리 4) 지속적 검증 - 세션 중에도 신뢰 재평가 5) 암호화 - mTLS로 모든 통신 암호화. 도입 단계: 1단계) IAM 강화, SSO/MFA 2단계) VPN을 ZTNA로 전환(Cloudflare Access, Zscaler) 3단계) 내부 서비스 mTLS 적용 4단계) 마이크로세그멘테이션(서비스 메시) 5단계) 지속적 모니터링, UEBA 도입.', ARRAY['Zero Trust', 'ZTNA', 'mTLS', '마이크로세그멘테이션', 'IAM'], 'Zero Trust는 "신뢰하지 말고 항상 검증하라"는 원칙으로, VPN을 대체하는 추세입니다.', 'docs/01-network.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'performance', 4, 50, 100, 'C10M(천만 동시 연결) 문제를 해결하기 위한 아키텍처와 커널 튜닝 전략을 설명해주세요.', '아키텍처: 1) 이벤트 드리븐 + 비동기 I/O(epoll, io_uring) 2) 커널 바이패스 - DPDK, XDP로 커널 네트워크 스택 우회 3) 수평 확장 - 여러 노드로 분산 4) 연결당 리소스 최소화. 커널 튜닝: 1) fs.file-max, fs.nr_open 증가 2) net.core.somaxconn=65535 3) net.ipv4.ip_local_port_range 확대 4) net.core.netdev_max_backlog 증가 5) TCP 메모리 설정 최적화 6) IRQ 밸런싱, RSS(Receive Side Scaling) 설정 7) NUMA 인식 프로세스 배치. 또한 SO_REUSEPORT로 포트 공유, 여러 프로세스가 같은 포트 리스닝.', ARRAY['C10M', 'DPDK', 'XDP', 'io_uring', '고성능네트워크'], 'C10M은 단일 서버에서 천만 동시 연결을 처리하는 것으로, 커널 바이패스가 핵심입니다.', 'docs/01-network.md');

-- =============================================
-- LINUX 문제 (25개)
-- =============================================

-- 난이도 1: 리눅스 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'process', 1, 1, 25, '서버에서 특정 프로세스가 멈춘 것 같습니다. 프로세스 상태를 확인하고 안전하게 종료하는 단계를 설명해주세요.', '1) ps aux | grep 프로세스명 으로 PID와 상태 확인 2) 상태가 Z(좀비)면 부모 프로세스 확인, D(uninterruptible)면 I/O 문제 의심 3) kill -TERM PID로 정상 종료 요청 4) 5-10초 대기 5) 여전히 살아있으면 kill -KILL PID로 강제 종료. 주의: kill -9(KILL)는 cleanup 기회 없이 즉시 종료되므로 먼저 SIGTERM을 시도해야 합니다.', ARRAY['kill', 'SIGTERM', 'SIGKILL', '프로세스종료', 'ps'], 'SIGTERM은 프로세스가 파일 닫기 등 정리 작업을 할 기회를 줍니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'memory', 1, 1, 25, 'free -h 명령어 실행 결과에서 "buff/cache"가 메모리 대부분을 차지합니다. 이것이 문제인가요?', '문제가 아닙니다. buff/cache는 시스템이 파일 읽기를 캐싱한 것으로, 필요 시 즉시 해제될 수 있습니다. 실제 사용 가능한 메모리는 "available" 컬럼을 확인해야 합니다. 리눅스는 남는 메모리를 캐시로 활용하여 성능을 높이는 것이 정상입니다. 문제가 되는 것은 swap 사용량이 증가하거나 available이 낮을 때입니다.', ARRAY['free', 'buff/cache', 'available', '메모리캐시'], '리눅스는 "사용하지 않는 메모리는 낭비되는 메모리"라는 철학으로 적극적으로 캐싱합니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'filesystem', 1, 1, 25, 'df -h로 확인했을 때 디스크 사용률이 100%인데, du로 계산하면 합계가 맞지 않습니다. 원인은 무엇인가요?', '삭제된 파일이 아직 프로세스에 의해 열려있는 경우입니다. 파일을 삭제해도 해당 파일을 열고 있는 프로세스가 있으면 inode가 해제되지 않아 공간이 회복되지 않습니다. lsof +L1 명령어로 삭제되었지만 열려있는 파일을 찾을 수 있습니다. 해결: 해당 프로세스를 재시작하거나, 가능하다면 해당 파일 디스크립터를 닫습니다.', ARRAY['디스크용량', 'lsof', '삭제된파일', 'inode', 'df'], '로그 로테이션 시 rm 대신 truncate(> logfile)를 사용하면 이 문제를 피할 수 있습니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'systemd', 1, 1, 25, 'systemctl start 서비스명 으로 서비스를 시작했는데 바로 죽습니다. 원인을 찾는 방법은?', '1) systemctl status 서비스명 - 상태와 최근 로그 확인 2) journalctl -u 서비스명 -n 50 - 더 상세한 로그 확인 3) journalctl -xe - 전체 시스템 에러 로그. 일반적 원인: 설정 파일 오류, 포트 충돌, 권한 문제, 의존 서비스 미시작, 환경변수 누락. ExecStart 경로가 올바른지, 해당 사용자로 직접 실행해보는 것도 도움이 됩니다.', ARRAY['systemctl', 'journalctl', '서비스실패', 'systemd', '로그'], 'journalctl -f -u 서비스명 으로 실시간 로그를 보면서 서비스를 시작하면 디버깅이 쉽습니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'permission', 1, 1, 25, '웹 서버가 특정 디렉토리의 파일을 읽지 못합니다. 권한 문제를 디버깅하는 순서는?', '1) ls -la로 파일 권한과 소유자 확인 2) 웹 서버 실행 사용자 확인(ps aux | grep nginx) 3) 파일 권한이 최소 644(rw-r--r--), 디렉토리는 755(rwxr-xr-x) 필요 4) 상위 디렉토리 전체 경로에 x(실행/진입) 권한 있는지 확인 - 디렉토리의 x는 진입 권한 5) SELinux/AppArmor가 활성화되어 있다면 audit 로그 확인. namei -l /path/to/file 로 경로 전체 권한을 한번에 확인할 수 있습니다.', ARRAY['파일권한', 'chmod', '웹서버', 'SELinux', 'namei'], '디렉토리의 x 권한이 없으면 그 안의 파일에 접근할 수 없습니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'shell', 1, 1, 25, '스크립트를 실행했는데 "Permission denied" 에러가 발생합니다. 해결 방법은?', '1) chmod +x script.sh로 실행 권한 부여 후 ./script.sh 실행 2) 또는 bash script.sh로 bash 인터프리터를 직접 지정하여 실행. 실행 권한 없이도 bash나 sh로 직접 호출하면 실행 가능합니다. 스크립트 첫 줄의 shebang(#!/bin/bash)은 직접 실행 시 사용할 인터프리터를 지정합니다. 윈도우에서 작성한 파일이면 dos2unix로 줄바꿈 문자도 변환해야 할 수 있습니다.', ARRAY['chmod', '실행권한', 'shebang', 'Permission denied'], 'shebang 없이 ./script.sh 실행 시 기본 셸이 사용됩니다.', 'docs/02-linux-os.md');

-- 난이도 2: 리눅스 (7문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'process', 2, 10, 50, '서버에서 좀비(Z) 프로세스가 계속 증가하고 있습니다. 원인 파악과 해결 방법을 설명해주세요.', '좀비 프로세스는 종료되었지만 부모가 wait()를 호출하지 않아 프로세스 테이블에 남은 상태입니다. 1) ps aux | grep Z로 좀비 확인 2) ps -o ppid= -p 좀비PID로 부모 찾기 3) 부모 프로세스 코드에서 자식 종료 처리 확인. 단기 해결: kill -SIGCHLD 부모PID로 부모에게 자식 종료 알림. 부모가 응답 없으면 부모 재시작. 좀비 자체는 리소스를 거의 사용 않지만 대량 발생 시 PID 고갈 가능.', ARRAY['좀비프로세스', 'wait', 'SIGCHLD', 'PID고갈'], '좀비는 부모 문제이므로 좀비 자체를 kill해도 사라지지 않습니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'memory', 2, 10, 50, '서버에서 OOM Killer가 중요한 프로세스를 죽였습니다. 원인 분석과 재발 방지 방법을 설명해주세요.', '원인 분석: 1) dmesg | grep -i "out of memory" 또는 journalctl -k | grep oom 2) /var/log/messages에서 어떤 프로세스가 죽었는지 확인. 재발 방지: 1) 중요 프로세스의 oom_score_adj를 -1000으로 설정(echo -1000 > /proc/PID/oom_score_adj) 2) systemd 서비스면 OOMScoreAdjust=-1000 추가 3) 메모리 누수 점검 4) swap 추가 또는 메모리 증설 5) 메모리 제한(cgroup)으로 폭주 프로세스 제어.', ARRAY['OOM Killer', 'oom_score_adj', '메모리관리', 'dmesg'], 'OOM Killer는 메모리 고갈 시 oom_score가 높은 프로세스를 선택해 종료합니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'disk', 2, 10, 50, 'iostat에서 %util이 100%에 가깝고 await가 높습니다. 어떤 프로세스가 I/O를 많이 사용하는지 찾는 방법은?', '1) iotop -oP로 실시간 프로세스별 I/O 사용량 확인 (-o는 I/O 사용 중인 것만, -P는 프로세스만) 2) pidstat -d 1로 프로세스별 I/O 통계 3) /proc/[pid]/io에서 특정 프로세스의 상세 I/O 정보. 추가 분석: 1) I/O가 읽기인지 쓰기인지 확인 2) 순차인지 랜덤인지 - 랜덤 I/O가 HDD에서 특히 느림 3) sync 쓰기가 많은지 확인. 근본 원인: 로깅 과다, 캐시 미스, 쿼리 최적화 부족 등.', ARRAY['iotop', 'iostat', 'pidstat', 'I/O병목'], '%util 100%는 디스크가 항상 바쁘다는 의미이며, 큐잉 지연이 발생합니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'network', 2, 10, 50, 'netstat이나 ss로 확인했을 때 CLOSE_WAIT 상태 연결이 계속 증가합니다. 원인과 해결 방법은?', 'CLOSE_WAIT은 상대방이 연결을 종료했지만 로컬 애플리케이션이 close()를 호출하지 않은 상태입니다. 원인: 애플리케이션 코드에서 소켓/연결을 제대로 닫지 않음, 예외 처리 누락. 1) ss -tp state close-wait로 어떤 프로세스인지 확인 2) 해당 애플리케이션 코드에서 connection.close() 또는 try-finally/using 패턴 확인 3) connection pool 설정 점검. TIME_WAIT은 정상이지만 CLOSE_WAIT은 버그 징후입니다.', ARRAY['CLOSE_WAIT', 'TCP', '연결누수', 'ss', '소켓'], 'CLOSE_WAIT은 클라이언트 측(연결을 닫지 않은 쪽)의 문제입니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'systemd', 2, 10, 50, '서비스가 비정상 종료 시 자동으로 재시작되도록 systemd 설정을 구성해주세요.', 'service 파일의 [Service] 섹션에 다음 추가: Restart=on-failure (비정상 종료 시만 재시작) 또는 Restart=always (항상 재시작), RestartSec=5 (5초 후 재시작), StartLimitIntervalSec=300, StartLimitBurst=5 (5분 내 5회 실패 시 중단). 예시: [Service] Restart=on-failure RestartSec=5 StartLimitIntervalSec=300 StartLimitBurst=5. 변경 후 systemctl daemon-reload && systemctl restart 서비스명.', ARRAY['systemd', 'Restart', 'RestartSec', '자동재시작'], 'Restart=on-failure는 exit code 0 이외의 종료 시 재시작하고, always는 정상 종료도 재시작합니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'shell', 2, 10, 50, '로그 파일에서 특정 시간대의 에러 로그를 추출하고 IP별로 카운트하는 스크립트를 작성해주세요.', '#!/bin/bash\nset -euo pipefail\nLOG_FILE="${1:?Usage: $0 <logfile>}"\nSTART_HOUR="${2:-00}"\nEND_HOUR="${3:-23}"\n\n# 시간대 필터링 후 ERROR 포함 라인에서 IP 추출 및 카운트\nawk -v start="$START_HOUR" -v end="$END_HOUR" ''{split($4, t, ":"); hour=substr(t[1],2); if(hour>=start && hour<=end && /ERROR/) print $1}'' "$LOG_FILE" | sort | uniq -c | sort -rn | head -20\n\n위 예시는 nginx 로그 형식 기준입니다. 로그 형식에 맞게 필드 번호 조정 필요.', ARRAY['awk', 'shell script', '로그분석', 'uniq', 'sort'], 'set -euo pipefail은 에러 시 즉시 종료, 미정의 변수 에러, 파이프 실패 감지를 활성화합니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'cgroup', 2, 10, 50, 'Docker 컨테이너의 메모리 사용량이 limit에 도달했는지 확인하는 방법은?', '1) docker stats 컨테이너명 - 실시간 리소스 사용량 확인, MEM USAGE/LIMIT 컬럼 2) docker inspect 컨테이너명 | grep -i memory - 메모리 설정 확인 3) cgroup 직접 확인: cat /sys/fs/cgroup/memory/docker/컨테이너ID/memory.usage_in_bytes, memory.limit_in_bytes 비교. OOM 발생 확인: docker inspect --format="{{.State.OOMKilled}}" 컨테이너명 또는 dmesg | grep oom 에서 컨테이너 프로세스 확인.', ARRAY['Docker', 'cgroup', 'memory limit', 'OOM', 'docker stats'], 'cgroup v2에서는 /sys/fs/cgroup/컨테이너경로/memory.current, memory.max 파일을 확인합니다.', 'docs/02-linux-os.md');

-- 난이도 3: 리눅스 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'process', 3, 30, 75, '프로세스가 D(uninterruptible sleep) 상태에서 멈춰있어 kill -9로도 종료되지 않습니다. 원인 분석 방법과 대응책은?', '원인 분석: D 상태는 주로 I/O 대기 중(디스크, NFS 등)에 발생합니다. 1) cat /proc/PID/stack으로 커널 스택 확인 - 어떤 함수에서 대기 중인지 2) /proc/PID/wchan으로 대기 중인 커널 함수 확인 3) lsof -p PID로 열린 파일/마운트 확인. NFS 관련이면 NFS 서버 상태 점검, 디스크면 dmesg에서 I/O 에러 확인. 대응: 1) NFS라면 umount -f -l로 강제 언마운트 2) 근본 원인(디스크 장애, 네트워크 문제) 해결 3) 최악의 경우 시스템 재부팅 필요.', ARRAY['D state', 'uninterruptible', 'NFS', 'I/O hang', 'kernel stack'], 'D 상태 프로세스는 커널이 인터럽트를 받지 않아 SIGKILL도 무시됩니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'memory', 3, 30, 75, 'Transparent Huge Pages(THP)가 데이터베이스 성능에 미치는 영향과 비활성화 방법을 설명해주세요.', '영향: THP는 자동으로 2MB 페이지를 사용하여 TLB 효율을 높이지만, 1) 메모리 단편화 시 compaction으로 지연 스파이크 발생 2) khugepaged 프로세스의 CPU 사용 3) 메모리 할당 지연. Redis, MongoDB, MySQL 등 DB에서 성능 저하 유발. 비활성화: echo never > /sys/kernel/mm/transparent_hugepage/enabled, echo never > /sys/kernel/mm/transparent_hugepage/defrag. 영구 적용: /etc/rc.local 또는 systemd 서비스로 부팅 시 실행. tuned 프로파일로도 관리 가능.', ARRAY['THP', 'Transparent Huge Pages', 'khugepaged', 'Redis', '메모리지연'], 'Redis 공식 문서에서도 THP 비활성화를 권장합니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'kernel', 3, 30, 75, '서버에서 시스템 CPU(sy)가 비정상적으로 높습니다. 원인을 분석하는 방법은?', '분석 도구: 1) perf top - 커널 함수별 CPU 사용량 실시간 확인 2) perf record -g -a sleep 10 후 perf report - 콜스택 포함 상세 분석 3) strace -c -p PID - 시스템콜 통계 4) cat /proc/interrupts - 인터럽트 분포 확인 5) vmstat 1 - 컨텍스트 스위칭(cs) 확인. 일반적 원인: 과도한 시스템콜, 높은 컨텍스트 스위칭, 인터럽트 폭주, 락 경합. 해결: 시스템콜 최적화, 배치 처리, I/O 패턴 개선.', ARRAY['perf', 'system CPU', 'strace', '컨텍스트스위칭', '커널프로파일링'], 'sy가 높으면 애플리케이션이 커널 기능(I/O, 네트워크 등)을 과도하게 사용 중입니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'network', 3, 30, 75, 'conntrack table full 에러가 발생하고 새 연결이 드롭됩니다. 진단과 해결 방법을 설명해주세요.', '진단: 1) dmesg | grep conntrack - "table full, dropping packet" 확인 2) cat /proc/sys/net/netfilter/nf_conntrack_count - 현재 사용량 3) cat /proc/sys/net/netfilter/nf_conntrack_max - 최대값. 해결: 1) 즉시: sysctl -w net.netfilter.nf_conntrack_max=262144 (또는 더 높게) 2) 영구: /etc/sysctl.conf에 추가 3) 타임아웃 단축: net.netfilter.nf_conntrack_tcp_timeout_established=3600 4) 불필요한 추적 비활성화: iptables -t raw -A PREROUTING -p tcp --dport 80 -j NOTRACK.', ARRAY['conntrack', 'nf_conntrack', 'connection tracking', 'iptables', 'NOTRACK'], 'conntrack은 stateful 방화벽에 필수이나, 고트래픽 서버에서 병목이 됩니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'filesystem', 3, 30, 75, '파일시스템이 읽기 전용으로 변경되었습니다. 원인 파악과 복구 방법은?', '원인 파악: 1) dmesg | tail -50 - 파일시스템 에러 메시지 확인 2) journalctl -b | grep -i "read-only\|error\|i/o" 3) 하드웨어 이슈(디스크 장애), 파일시스템 손상, 커널 버그 등. 복구: 1) 가능하면 중요 데이터 백업 2) fsck -y /dev/sda1 (마운트 해제 후) - ext4의 경우 3) 경미한 경우: mount -o remount,rw / 시도 4) 심각한 경우: rescue 모드 부팅 후 fsck. 예방: SMART 모니터링(smartctl), 정기 백업, RAID 구성.', ARRAY['read-only', 'fsck', '파일시스템복구', 'dmesg', 'SMART'], '리눅스는 파일시스템 에러 감지 시 데이터 보호를 위해 읽기 전용으로 전환합니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'systemd', 3, 30, 75, 'systemd 서비스에 보안 강화 옵션을 적용하려고 합니다. 주요 보안 설정들을 설명해주세요.', '주요 보안 옵션: [Service] 섹션에 추가 1) ProtectSystem=strict - 파일시스템을 읽기전용으로 (필요 경로는 ReadWritePaths로 허용) 2) ProtectHome=yes - 홈 디렉토리 숨김 3) NoNewPrivileges=yes - 권한 상승 금지 4) PrivateTmp=yes - 독립적인 /tmp 사용 5) CapabilityBoundingSet= - 특정 capability만 허용 6) User=appuser - 비root 사용자로 실행 7) RestrictNamespaces=yes - namespace 생성 제한. systemd-analyze security 서비스명 으로 보안 점수 확인 가능.', ARRAY['systemd', 'ProtectSystem', 'NoNewPrivileges', 'PrivateTmp', 'Capability'], 'systemd-analyze security는 0-10점으로 서비스 보안 수준을 평가합니다.', 'docs/02-linux-os.md');

-- 난이도 4: 리눅스 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'kernel', 4, 50, 100, 'eBPF를 활용한 프로덕션 환경 성능 모니터링 전략을 설명해주세요.', 'eBPF 장점: 커널 수정/재부팅 없이 커널 내부 관측, 낮은 오버헤드, 안전성(verifier). 도구: 1) bcc tools - opensnoop(파일 열기), execsnoop(프로세스 실행), tcplife(TCP 연결 수명) 등 2) bpftrace - 원라이너 스크립트로 즉석 분석 3) 지속적 프로파일링 - Parca, Pyroscope, Grafana Pyroscope. 사용 예: CPU 핫스팟 상시 수집 → 프로덕션에서도 플레임 그래프 분석, 특정 지연 시간 원인 추적, 네트워크 패킷 분석. 주의: 커널 버전에 따른 기능 차이, BTF 지원 확인.', ARRAY['eBPF', 'bcc', 'bpftrace', '지속적프로파일링', 'Parca'], 'eBPF는 Netflix, Facebook 등에서 프로덕션 관측성의 핵심 기술로 사용됩니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'performance', 4, 50, 100, 'NUMA 아키텍처 서버에서 성능 최적화를 위한 프로세스 배치와 메모리 정책을 설명해주세요.', 'NUMA 문제: 원격 노드 메모리 접근은 로컬보다 2-3배 느림. 진단: numactl --hardware로 토폴로지 확인, numastat으로 노드별 메모리 사용량. 최적화: 1) numactl --cpunodebind=0 --membind=0 ./app - 특정 노드에 바인딩 2) systemd: CPUAffinity, NUMAPolicy 설정 3) 메모리 정책: --preferred(선호 노드), --interleave(분산 할당) 4) zone_reclaim_mode=1로 로컬 메모리 우선. DB의 경우: 메모리 인텐시브 워크로드는 NUMA 노드 하나에 집중, 병렬 처리는 적절히 분산.', ARRAY['NUMA', 'numactl', 'CPUAffinity', '메모리로컬리티', '성능최적화'], 'NUMA 인식 없이 대형 서버를 사용하면 성능의 절반만 활용하게 됩니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'container', 4, 50, 100, 'rootless 컨테이너의 동작 원리와 보안상 이점, 도입 시 고려사항을 설명해주세요.', '동작 원리: user namespace를 사용하여 컨테이너 내 root(UID 0)를 호스트의 일반 사용자(예: UID 100000)로 매핑. /etc/subuid, /etc/subgid로 할당 범위 정의. 보안 이점: 1) 컨테이너 탈출해도 호스트 root 권한 없음 2) 권한 상승 공격 완화 3) 비특권 사용자도 컨테이너 실행 가능. 고려사항: 1) 1024 이하 포트 바인딩 불가 - slirp4netns 또는 포트 포워딩 필요 2) 일부 스토리지 드라이버 제한 3) cgroup v2 필요 4) 성능 약간 저하(사용자 공간 네트워킹). Podman이 기본 지원.', ARRAY['rootless', 'user namespace', 'Podman', 'UID mapping', '컨테이너보안'], 'rootless 컨테이너는 "root로 실행하지 마라"는 보안 원칙의 컨테이너 적용입니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'disk', 4, 50, 100, 'io_uring을 활용한 고성능 I/O 아키텍처의 원리와 적용 시 고려사항을 설명해주세요.', 'io_uring 원리: 커널과 사용자 공간이 공유 링 버퍼(submission queue, completion queue)를 사용하여 시스템콜 없이 I/O 요청/완료 처리. 폴링 모드로 인터럽트도 제거 가능. 장점: 1) 시스템콜 오버헤드 최소화(배치 처리) 2) 제로카피 가능 3) epoll보다 낮은 지연 4) 비동기 파일 I/O 지원(libaio 대체). 고려사항: 1) 커널 5.1+ 필요, 기능별로 더 높은 버전 필요 2) 복잡한 프로그래밍 모델 3) 보안 취약점 이력(권한 상승) 4) 라이브러리: liburing 사용 권장. 적용: RocksDB, NGINX 등에서 채택 증가.', ARRAY['io_uring', '비동기I/O', 'submission queue', 'completion queue', '고성능I/O'], 'io_uring은 epoll + aio의 장점을 결합한 리눅스의 최신 I/O 인터페이스입니다.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'security', 4, 50, 100, '프로덕션 리눅스 서버 침해가 의심될 때의 초기 대응 절차와 증거 수집 방법을 설명해주세요.', '초기 대응: 1) 격리 결정 - 네트워크 분리 vs 모니터링 유지 판단 2) 휘발성 데이터 우선 수집 - 실행 중인 프로세스, 네트워크 연결, 메모리. 증거 수집: 1) 메모리 덤프: LiME, /proc/kcore 2) 프로세스: ps auxwww, /proc/*/exe, /proc/*/cmdline 3) 네트워크: ss -tupna, /proc/net/tcp 4) 로그 백업: /var/log/* 즉시 복사 5) 파일 타임라인: find / -mtime -7 6) 히스토리: .bash_history, .zsh_history 7) 디스크 이미지: dd 또는 dc3dd. 주의: 원본 변경 최소화, 명령어 실행도 기록, 타임스탬프 보존. 이후: 클린 이미지로 재구축, 사후 분석(포렌식).', ARRAY['침해대응', '포렌식', '증거수집', 'LiME', '휘발성데이터'], '휘발성 순서: CPU 레지스터 → 메모리 → 네트워크 상태 → 프로세스 → 디스크.', 'docs/02-linux-os.md');

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'cgroup', 4, 50, 100, 'cgroup v2 기반의 Kubernetes QoS 클래스 구현 원리와 리소스 관리 전략을 설명해주세요.', 'QoS 클래스: 1) Guaranteed - requests=limits, 최고 우선순위, OOM 마지막 대상 2) Burstable - requests<limits, 중간 우선순위 3) BestEffort - requests/limits 미설정, 최저 우선순위, OOM 첫 대상. cgroup v2 매핑: memory.max(limits), memory.min(보장), cpu.max(limits), cpu.weight(상대 가중치). 관리 전략: 1) 중요 Pod는 Guaranteed로 설정 2) memory.high로 스로틀링 구간 설정 3) OOMKilled 방지를 위해 적절한 limits 설정 4) CPU는 burstable 허용이 효율적. 모니터링: cAdvisor, kubelet metrics으로 실제 사용량 vs 요청량 분석 후 right-sizing.', ARRAY['cgroup v2', 'Kubernetes QoS', 'Guaranteed', 'Burstable', 'OOM'], 'cgroup v2는 단일 계층 구조로 리소스 관리가 더 일관적이고 효율적입니다.', 'docs/02-linux-os.md');
