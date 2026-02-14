-- ============================================================
-- CS Knowledge Quiz - 시드 데이터 (네트워크 + 리눅스/OS)
-- ============================================================
-- 생성일: 2024
-- 분야별 문제 수:
--   - network (네트워크): 50문제
--   - linux (리눅스/OS): 50문제
--   - 총합: 100문제
--
-- 난이도 분배 (분야당):
--   - 난이도 1 (입문): ~15문제
--   - 난이도 2 (주니어): ~15문제
--   - 난이도 3 (시니어): ~12문제
--   - 난이도 4 (리드): ~8문제
-- ============================================================

-- 기존 데이터 정리 (필요시)
-- DELETE FROM questions WHERE source_doc IN ('docs/01-network.md', 'docs/02-linux-os.md');

-- ============================================================
-- 네트워크 (Network) 문제 - 50문제
-- ============================================================

-- DNS 관련 문제 (8문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'DNS', 1, 1, 25,
'DNS가 없다면 어떤 일이 발생하나요?',
'모든 웹사이트 접속 시 IP 주소를 직접 입력해야 합니다. 예를 들어 구글 접속 시 ''google.com'' 대신 ''142.250.190.78''을 입력해야 합니다.',
ARRAY['IP 주소', '도메인', '직접 입력', '웹사이트'],
'DNS는 인터넷의 전화번호부 역할을 하여 사람이 읽을 수 있는 도메인 이름을 컴퓨터가 이해할 수 있는 IP 주소로 변환합니다.',
'docs/01-network.md'),

('network', 'DNS', 1, 1, 25,
'DNS 조회는 어디서 먼저 시작되나요?',
'브라우저 캐시에서 시작하여 OS 캐시, 라우터 캐시, ISP DNS 서버 순으로 확인합니다.',
ARRAY['브라우저 캐시', 'OS 캐시', '라우터', 'ISP', '순서'],
'DNS 조회는 성능을 위해 여러 단계의 캐시를 먼저 확인한 후, 캐시 미스 시에만 상위 DNS 서버에 쿼리합니다.',
'docs/01-network.md'),

('network', 'DNS', 1, 1, 25,
'도메인 이름 체계에서 ''www.example.com''의 각 부분은 무엇을 의미하나요?',
'''com''은 TLD(최상위 도메인), ''example''은 SLD(2차 도메인), ''www''는 서브도메인(호스트명)입니다.',
ARRAY['TLD', 'SLD', '서브도메인', '호스트명', '계층'],
'도메인 이름은 오른쪽부터 계층적으로 읽으며, 루트 → TLD → SLD → 서브도메인 순으로 구성됩니다.',
'docs/01-network.md'),

('network', 'DNS', 2, 10, 50,
'A 레코드와 CNAME 레코드의 차이점은 무엇인가요?',
'A 레코드는 도메인을 IP 주소에 직접 연결하고, CNAME은 도메인을 다른 도메인에 연결합니다. CNAME은 추가 DNS 조회가 필요하여 약간의 지연이 발생할 수 있습니다.',
ARRAY['A 레코드', 'CNAME', 'IP 주소', '도메인 매핑', '별칭'],
'A 레코드는 직접 IP 매핑, CNAME은 별칭으로 다른 도메인을 가리킵니다. CNAME은 루트 도메인에는 사용할 수 없습니다.',
'docs/01-network.md'),

('network', 'DNS', 2, 10, 50,
'TTL을 낮게 설정하면 어떤 장단점이 있나요?',
'장점은 DNS 변경이 빠르게 전파됩니다. 단점은 DNS 서버 부하 증가와 조회 지연 시간 증가입니다. 마이그레이션 전에는 TTL을 낮추고, 안정화 후 높이는 것이 일반적입니다.',
ARRAY['TTL', '전파', '캐시', 'DNS 서버', '부하'],
'TTL(Time To Live)은 DNS 레코드의 캐시 유지 시간으로, 낮으면 변경이 빨리 반영되지만 DNS 쿼리가 많아집니다.',
'docs/01-network.md'),

('network', 'DNS', 3, 30, 75,
'재귀적 쿼리와 반복적 쿼리의 차이를 설명해주세요.',
'재귀적 쿼리에서는 클라이언트가 DNS 서버에 요청하면 그 서버가 최종 답을 찾아 반환합니다. 반복적 쿼리에서는 DNS 서버가 답을 모르면 다른 서버 주소만 알려주고, 클라이언트가 직접 다음 서버에 질의합니다.',
ARRAY['재귀적', '반복적', 'Recursive', 'Iterative', 'DNS 쿼리'],
'로컬 DNS 서버는 클라이언트 요청에 재귀적으로 응답하고, 다른 DNS 서버들과는 반복적으로 쿼리합니다.',
'docs/01-network.md'),

('network', 'DNS', 3, 30, 75,
'DNS Round Robin의 한계점은 무엇인가요?',
'서버 상태 확인 불가로 죽은 서버에도 트래픽 전송, 세션 유지 어려움, 클라이언트 캐싱으로 불균등 분배, 가중치 설정 불가합니다. 실제 로드밸런싱에는 L4/L7 로드밸런서 사용을 권장합니다.',
ARRAY['Round Robin', '로드밸런싱', '헬스체크', '세션', '가중치'],
'DNS Round Robin은 간단한 부하 분산이지만 헬스체크가 없어 실제 서비스에서는 전용 로드밸런서와 함께 사용합니다.',
'docs/01-network.md'),

('network', 'DNS', 4, 50, 100,
'글로벌 서비스에서 DNS 아키텍처를 어떻게 설계하나요?',
'Anycast DNS로 전 세계 PoP에서 동일 IP로 응답하고, GeoDNS로 지역별 최적 서버를 반환합니다. 낮은 TTL로 장애 시 빠른 전환이 가능하게 하고, 헬스체크 연동으로 자동 failover를 구현합니다. 멀티 DNS 프로바이더로 단일 장애점을 제거합니다.',
ARRAY['Anycast', 'GeoDNS', 'TTL', 'failover', '멀티 프로바이더'],
'글로벌 서비스는 지역별 지연 최소화와 장애 대응을 위해 여러 DNS 기술을 조합하여 사용합니다.',
'docs/01-network.md');

-- HTTP/HTTPS 관련 문제 (8문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'HTTP/HTTPS', 1, 1, 25,
'GET과 POST의 차이점은 무엇인가요?',
'GET은 데이터 조회용으로 URL에 파라미터가 노출되고, 브라우저 히스토리에 남으며, 캐시 가능합니다. POST는 데이터 생성/수정용으로 body에 데이터를 담아 전송하고, 캐시되지 않습니다.',
ARRAY['GET', 'POST', 'URL', 'body', '캐시'],
'GET은 멱등성을 가지며 안전한 메서드이고, POST는 서버 상태를 변경할 수 있는 비멱등 메서드입니다.',
'docs/01-network.md'),

('network', 'HTTP/HTTPS', 1, 1, 25,
'HTTPS가 HTTP보다 안전한 이유는 무엇인가요?',
'HTTPS는 TLS 암호화를 통해 데이터 도청 방지(기밀성), 데이터 변조 방지(무결성), 서버 신원 확인(인증)을 제공합니다.',
ARRAY['TLS', '암호화', '기밀성', '무결성', '인증'],
'HTTPS는 HTTP + TLS로, 전송 중인 데이터를 암호화하여 중간자 공격을 방지합니다.',
'docs/01-network.md'),

('network', 'HTTP/HTTPS', 2, 10, 50,
'401 Unauthorized와 403 Forbidden의 차이는 무엇인가요?',
'401은 인증(Authentication) 실패로 "누구인지 모르겠다"이고, 403은 인가(Authorization) 실패로 "누구인지 알지만 권한이 없다"입니다.',
ARRAY['401', '403', '인증', '인가', 'Authentication', 'Authorization'],
'401은 로그인이 필요하거나 인증 정보가 잘못된 경우, 403은 인증은 되었지만 해당 리소스에 대한 접근 권한이 없는 경우입니다.',
'docs/01-network.md'),

('network', 'HTTP/HTTPS', 2, 10, 50,
'SameSite 쿠키 속성의 Strict, Lax, None의 차이는 무엇인가요?',
'Strict는 모든 크로스사이트 요청에서 쿠키 전송 차단, Lax(기본값)는 안전한 최상위 탐색(GET 링크)에서만 허용, None은 모든 요청에 전송됩니다. None은 Secure 플래그가 필수입니다.',
ARRAY['SameSite', 'Strict', 'Lax', 'None', 'CSRF'],
'SameSite 쿠키 속성은 CSRF 공격 방어에 사용되며, 크로스사이트 요청에서 쿠키 전송을 제어합니다.',
'docs/01-network.md'),

('network', 'HTTP/HTTPS', 3, 30, 75,
'HTTP/2의 멀티플렉싱이 HTTP/1.1의 문제를 어떻게 해결하나요?',
'HTTP/1.1은 하나의 연결에서 한 번에 하나의 요청만 처리할 수 있어 HOL(Head-of-Line) blocking이 발생했습니다. HTTP/2는 단일 TCP 연결에서 여러 스트림을 동시에 처리하여 병렬 요청이 가능합니다. 하지만 TCP 수준의 HOL blocking은 여전히 존재합니다.',
ARRAY['멀티플렉싱', 'HOL blocking', 'HTTP/2', '스트림', '병렬'],
'HTTP/2는 바이너리 프레이밍과 멀티플렉싱으로 단일 연결에서 여러 요청을 동시에 처리할 수 있습니다.',
'docs/01-network.md'),

('network', 'HTTP/HTTPS', 3, 30, 75,
'CORS Preflight 요청은 언제 발생하나요?',
'Simple Request가 아닌 경우 발생합니다. 조건은 GET/HEAD/POST 외 메서드 사용, Content-Type이 application/json 등 특수 값, 커스텀 헤더 사용입니다. Preflight는 OPTIONS 메서드로 서버의 허용 여부를 미리 확인합니다.',
ARRAY['CORS', 'Preflight', 'OPTIONS', 'Simple Request', '크로스 오리진'],
'브라우저는 보안을 위해 복잡한 크로스 오리진 요청 전에 서버에 허용 여부를 먼저 확인합니다.',
'docs/01-network.md'),

('network', 'HTTP/HTTPS', 4, 50, 100,
'마이크로서비스 환경에서 gRPC와 REST의 선택 기준은 무엇인가요?',
'gRPC 선택: 낮은 지연 필요, 양방향 스트리밍, 내부 서비스 간 통신, 강타입 스키마 필요. REST 선택: 브라우저 클라이언트, 공개 API, 간단한 CRUD, 디버깅 용이성. 하이브리드 접근으로 내부는 gRPC, 외부는 REST Gateway를 사용합니다.',
ARRAY['gRPC', 'REST', '마이크로서비스', 'Gateway', '스트리밍'],
'gRPC는 바이너리 프로토콜로 성능이 좋지만 브라우저 지원이 제한적이고, REST는 호환성이 좋지만 오버헤드가 있습니다.',
'docs/01-network.md'),

('network', 'HTTP/HTTPS', 4, 50, 100,
'HTTP/3 도입 시 고려해야 할 인프라 요소는 무엇인가요?',
'UDP 443 포트 개방(방화벽, 로드밸런서), QUIC 지원 로드밸런서/CDN, HTTP/2 폴백 구현, 모니터링 도구 호환성, 엔터프라이즈 네트워크의 UDP 차단 대응이 필요합니다. 현재 CloudFront, Cloudflare 등 주요 CDN은 HTTP/3를 지원합니다.',
ARRAY['HTTP/3', 'QUIC', 'UDP', '폴백', 'CDN'],
'HTTP/3는 UDP 기반 QUIC 프로토콜을 사용하여 기존 TCP 기반 인프라와 다른 고려사항이 있습니다.',
'docs/01-network.md');

-- TLS/SSL 관련 문제 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'TLS/SSL', 1, 1, 25,
'인증서가 필요한 이유는 무엇인가요?',
'암호화만으로는 "누구와" 통신하는지 확인할 수 없습니다. 인증서는 신뢰할 수 있는 CA(인증기관)가 서버의 신원을 보증하여 중간자 공격을 방지합니다.',
ARRAY['인증서', 'CA', '신뢰', '중간자 공격', '신원'],
'인증서는 공개키와 서버 정보를 포함하며, CA의 서명으로 신뢰성을 보장합니다.',
'docs/01-network.md'),

('network', 'TLS/SSL', 2, 10, 50,
'TLS 핸드셰이크 과정을 설명해주세요.',
'ClientHello로 클라이언트가 지원하는 TLS 버전, 암호화 스위트, 랜덤값을 전송하고, ServerHello로 서버가 선택한 암호화 스위트, 랜덤값, 인증서를 전송합니다. 클라이언트가 인증서를 검증하고, 키 교환으로 세션 키를 생성한 후, Finished 메시지로 핸드셰이크가 완료됩니다.',
ARRAY['TLS 핸드셰이크', 'ClientHello', 'ServerHello', '인증서', '세션 키'],
'TLS 핸드셰이크는 암호화 통신을 위한 파라미터 협상과 인증을 수행하는 과정입니다.',
'docs/01-network.md'),

('network', 'TLS/SSL', 2, 10, 50,
'Let''s Encrypt 인증서의 장단점은 무엇인가요?',
'장점은 무료, 자동 갱신(certbot), 널리 신뢰됩니다. 단점은 90일 짧은 유효기간, DV만 지원(OV/EV 불가), 와일드카드는 DNS 인증이 필요합니다.',
ARRAY['Let''s Encrypt', '무료', '자동 갱신', 'DV', '와일드카드'],
'Let''s Encrypt는 ACME 프로토콜을 통해 자동화된 인증서 발급을 제공하는 무료 CA입니다.',
'docs/01-network.md'),

('network', 'TLS/SSL', 3, 30, 75,
'TLS 1.3의 주요 개선 사항은 무엇인가요?',
'핸드셰이크 1-RTT로 단축(30-50% 지연 감소), 0-RTT 재연결, RSA 키 교환 제거(PFS 필수), 취약 암호 제거(RC4, 3DES, SHA-1 등), 핸드셰이크 암호화로 메타데이터 노출 최소화입니다.',
ARRAY['TLS 1.3', '1-RTT', '0-RTT', 'PFS', '핸드셰이크'],
'TLS 1.3은 보안과 성능을 모두 개선한 최신 TLS 버전으로, 취약한 알고리즘을 제거하고 핸드셰이크를 간소화했습니다.',
'docs/01-network.md'),

('network', 'TLS/SSL', 3, 30, 75,
'Perfect Forward Secrecy가 중요한 이유는 무엇인가요?',
'PFS 없이 정적 RSA 키를 사용하면, 서버 개인 키가 유출될 경우 과거에 캡처된 모든 트래픽을 복호화할 수 있습니다. PFS는 각 세션마다 임시 키를 생성하여 개인 키 유출에도 과거 통신을 보호합니다.',
ARRAY['PFS', 'Forward Secrecy', '임시 키', '키 유출', 'ECDHE'],
'PFS는 ECDHE, DHE 같은 임시 키 교환 알고리즘을 사용하여 세션별로 고유한 키를 생성합니다.',
'docs/01-network.md'),

('network', 'TLS/SSL', 4, 50, 100,
'대규모 환경에서 인증서 관리 전략은 어떻게 수립하나요?',
'cert-manager로 K8s 인증서 자동화, Vault PKI로 내부 CA 구축 및 자동 발급/갱신, ACM/Cloud Certificate Manager로 클라우드 관리형 사용, 인증서 만료 모니터링(30일 전 알림), 와일드카드 vs 개별 인증서 정책을 수립합니다.',
ARRAY['cert-manager', 'Vault PKI', '자동화', '만료 모니터링', '와일드카드'],
'대규모 환경에서는 인증서 자동화가 필수이며, 만료로 인한 장애를 방지하기 위한 모니터링이 중요합니다.',
'docs/01-network.md');

-- TCP/IP 관련 문제 (8문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'TCP/IP', 1, 1, 25,
'IP 주소와 포트의 역할을 비유로 설명해주세요.',
'IP 주소는 아파트 주소(건물 위치), 포트는 호수(몇 호인지)입니다. IP로 기기를 찾고, 포트로 해당 기기의 어떤 서비스에 연결할지 결정합니다.',
ARRAY['IP 주소', '포트', '서비스', '네트워크', '식별'],
'IP 주소는 0-65535 범위의 포트와 함께 사용되어 네트워크 서비스를 식별합니다.',
'docs/01-network.md'),

('network', 'TCP/IP', 1, 1, 25,
'127.0.0.1은 무엇인가요?',
'localhost 또는 루프백 주소로, 자기 자신을 가리킵니다. 네트워크 테스트나 로컬 서비스 연결에 사용됩니다.',
ARRAY['127.0.0.1', 'localhost', '루프백', '로컬', '테스트'],
'루프백 주소는 네트워크 스택을 거치지만 실제로 네트워크로 나가지 않고 자신에게 돌아옵니다.',
'docs/01-network.md'),

('network', 'TCP/IP', 2, 10, 50,
'3-way Handshake가 필요한 이유는 무엇인가요?',
'양쪽 모두 송수신 능력이 있음을 확인하기 위해서입니다. 클라이언트가 SYN으로 연결 요청, 서버가 SYN-ACK로 요청 수락, 클라이언트가 ACK로 확인하여 양방향 통신 준비가 완료됩니다.',
ARRAY['3-way Handshake', 'SYN', 'SYN-ACK', 'ACK', '연결 수립'],
'3-way Handshake는 TCP 연결의 신뢰성을 보장하기 위한 초기 연결 설정 과정입니다.',
'docs/01-network.md'),

('network', 'TCP/IP', 2, 10, 50,
'TIME_WAIT 상태는 왜 필요한가요?',
'지연된 패킷이 새 연결에 영향주는 것을 방지하고, 마지막 ACK 손실 시 재전송에 대응하기 위해서입니다. 보통 2*MSL(Maximum Segment Lifetime, 약 60-240초) 동안 유지됩니다.',
ARRAY['TIME_WAIT', 'MSL', '지연 패킷', 'ACK', '재전송'],
'TIME_WAIT는 TCP 연결 종료 후 같은 소켓 쌍의 재사용을 방지하여 통신 안정성을 보장합니다.',
'docs/01-network.md'),

('network', 'TCP/IP', 2, 10, 50,
'CLOSE_WAIT 상태가 많으면 무슨 문제인가요?',
'애플리케이션이 소켓을 제대로 닫지 않았다는 의미입니다. 상대방이 연결을 종료했지만 애플리케이션에서 close()를 호출하지 않아 리소스가 누수됩니다. 코드에서 연결 종료 처리를 확인해야 합니다.',
ARRAY['CLOSE_WAIT', '소켓', 'close()', '리소스 누수', '연결 종료'],
'CLOSE_WAIT는 로컬 애플리케이션의 버그를 나타내며, 연결 풀 관리 코드를 점검해야 합니다.',
'docs/01-network.md'),

('network', 'TCP/IP', 3, 30, 75,
'흐름 제어와 혼잡 제어의 차이는 무엇인가요?',
'흐름 제어는 송신자-수신자 간 속도 조절로 수신자 버퍼 오버플로우 방지입니다. 혼잡 제어는 네트워크 전체의 혼잡을 감지하고 송신 속도를 조절하여 네트워크 붕괴를 방지합니다.',
ARRAY['흐름 제어', '혼잡 제어', '슬라이딩 윈도우', 'Slow Start', 'AIMD'],
'흐름 제어는 end-to-end, 혼잡 제어는 네트워크 전체 관점에서 데이터 전송 속도를 조절합니다.',
'docs/01-network.md'),

('network', 'TCP/IP', 3, 30, 75,
'Nagle 알고리즘을 비활성화(TCP_NODELAY)해야 하는 경우는 언제인가요?',
'실시간성이 중요한 경우입니다. 대화형 애플리케이션(SSH, 텔넷), 게임 서버, 금융 거래 시스템에서 사용합니다. Nagle은 작은 패킷을 모아 보내므로 지연이 발생합니다.',
ARRAY['Nagle', 'TCP_NODELAY', '실시간', '지연', '게임'],
'Nagle 알고리즘은 네트워크 효율을 위해 작은 패킷을 모아 보내지만, 지연에 민감한 애플리케이션에서는 비활성화합니다.',
'docs/01-network.md'),

('network', 'TCP/IP', 4, 50, 100,
'대규모 서버에서 TIME_WAIT 문제 해결 방법은 무엇인가요?',
'tcp_tw_reuse 활성화(클라이언트 측), SO_REUSEADDR 사용, Keep-Alive로 연결 재사용, Connection Pooling을 적용합니다. 로드밸런서에서 연결을 관리하는 방법도 있습니다. tcp_tw_recycle은 NAT 환경에서 문제를 일으켜 최신 커널에서 제거되었습니다.',
ARRAY['TIME_WAIT', 'tcp_tw_reuse', 'Connection Pooling', 'Keep-Alive', 'SO_REUSEADDR'],
'대규모 서버에서 TIME_WAIT는 소켓 고갈을 유발할 수 있어 다양한 방법으로 관리가 필요합니다.',
'docs/01-network.md');

-- UDP 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'UDP', 1, 1, 25,
'DNS는 왜 UDP를 사용하나요?',
'DNS 쿼리는 작은 크기이고, 빠른 응답이 중요하며, 응답이 없으면 재요청하면 됩니다. 연결 설정 오버헤드를 피해 빠른 조회가 가능합니다.',
ARRAY['DNS', 'UDP', '빠른 응답', '연결 설정', '재요청'],
'UDP는 연결 설정 없이 바로 데이터를 전송하여 DNS 같은 작은 쿼리에 효율적입니다.',
'docs/01-network.md'),

('network', 'UDP', 2, 10, 50,
'멀티캐스트가 UDP만 지원하는 이유는 무엇인가요?',
'TCP는 일대일 연결 기반이라 각 수신자와 별도 연결이 필요합니다. UDP는 연결이 없어 하나의 패킷을 여러 수신자에게 동시에 전달할 수 있습니다.',
ARRAY['멀티캐스트', 'UDP', 'TCP', '연결', '일대다'],
'멀티캐스트는 네트워크 효율성을 위해 하나의 패킷을 여러 수신자에게 전달하는 방식입니다.',
'docs/01-network.md'),

('network', 'UDP', 3, 30, 75,
'QUIC가 UDP 위에 구현된 이유는 무엇인가요?',
'TCP 수정은 OS 커널 변경이 필요하지만 UDP는 사용자 공간에서 프로토콜 구현이 가능합니다. 미들박스(방화벽 등)가 TCP를 임의로 수정하는 문제를 회피하고, 빠른 반복과 배포가 가능합니다.',
ARRAY['QUIC', 'UDP', '사용자 공간', '미들박스', 'TCP'],
'QUIC은 UDP 위에서 TCP의 신뢰성과 TLS 보안을 결합한 프로토콜로, HTTP/3의 기반입니다.',
'docs/01-network.md'),

('network', 'UDP', 4, 50, 100,
'대규모 실시간 서비스에서 UDP 인프라 고려사항은 무엇인가요?',
'방화벽/로드밸런서의 UDP 지원 확인, UDP 443 포트 사용(QUIC, 차단 우회), NAT 타임아웃(30-60초) 고려한 keepalive, DDoS 방어(UDP amplification 취약), 모니터링 도구의 UDP 지원을 확인합니다.',
ARRAY['UDP', 'NAT 타임아웃', 'DDoS', 'UDP amplification', '방화벽'],
'UDP 기반 서비스는 TCP와 다른 네트워크 특성을 가지므로 인프라 구성 시 별도의 고려가 필요합니다.',
'docs/01-network.md');

-- WebSocket 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'WebSocket', 1, 1, 25,
'HTTP 폴링과 WebSocket의 차이는 무엇인가요?',
'HTTP 폴링은 클라이언트가 주기적으로 서버에 요청하여 비효율적입니다. WebSocket은 연결을 유지하며 서버가 즉시 데이터를 푸시할 수 있어 효율적입니다.',
ARRAY['폴링', 'WebSocket', '양방향', '실시간', '푸시'],
'WebSocket은 HTTP Upgrade를 통해 양방향 전이중 통신 채널을 설정합니다.',
'docs/01-network.md'),

('network', 'WebSocket', 2, 10, 50,
'Ping/Pong 프레임의 용도는 무엇인가요?',
'연결이 살아있는지 확인합니다. 중간 프록시나 로드밸런서가 유휴 연결을 끊지 않도록 주기적으로 전송합니다. 서버가 Ping을 보내면 클라이언트가 Pong으로 응답합니다.',
ARRAY['Ping', 'Pong', '연결 확인', '프록시', '유휴 연결'],
'WebSocket은 TCP 위에서 동작하므로 응용 계층에서 별도의 연결 유지 메커니즘이 필요합니다.',
'docs/01-network.md'),

('network', 'WebSocket', 3, 30, 75,
'WebSocket과 SSE 중 언제 무엇을 선택하나요?',
'SSE 선택: 서버에서 클라이언트로 단방향이면 충분(알림, 피드), HTTP/2 멀티플렉싱 활용, 자동 재연결 기본 지원. WebSocket 선택: 양방향 통신 필요(채팅, 게임), 바이너리 데이터 전송, 낮은 지연이 필요할 때 사용합니다.',
ARRAY['WebSocket', 'SSE', '단방향', '양방향', '자동 재연결'],
'SSE는 HTTP 기반으로 단순하고 WebSocket은 더 유연하지만 복잡합니다. 요구사항에 맞게 선택합니다.',
'docs/01-network.md'),

('network', 'WebSocket', 4, 50, 100,
'수백만 동시 접속 WebSocket을 어떻게 처리하나요?',
'수평 확장으로 여러 서버에 연결을 분산하고, 메시지 브로커(Redis Pub/Sub, Kafka)로 서버 간 메시지를 전달합니다. Sticky session 또는 연결 상태를 공유 저장소에 저장하고, 연결 당 리소스를 최소화합니다. 커널 튜닝(파일 디스크립터, 소켓 버퍼)도 필요합니다.',
ARRAY['수평 확장', 'Redis Pub/Sub', 'Sticky session', '파일 디스크립터', '메시지 브로커'],
'대규모 WebSocket 서비스는 단일 서버로 불가능하므로 분산 아키텍처와 상태 공유가 필요합니다.',
'docs/01-network.md');

-- Load Balancing 관련 문제 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'Load Balancing', 1, 1, 25,
'로드밸런서가 없으면 어떤 문제가 생기나요?',
'단일 서버에 트래픽 집중으로 과부하, 서버 장애 시 서비스 중단, 수평 확장 불가 문제가 발생합니다. 로드밸런서는 이 문제들을 해결합니다.',
ARRAY['로드밸런서', '트래픽', '과부하', '장애', '수평 확장'],
'로드밸런서는 고가용성과 확장성을 위한 핵심 인프라 컴포넌트입니다.',
'docs/01-network.md'),

('network', 'Load Balancing', 2, 10, 50,
'L4와 L7 로드밸런서의 차이를 설명해주세요.',
'L4는 TCP/UDP 헤더(IP, 포트)만 보고 빠르게 라우팅합니다. L7은 HTTP 내용(URL, 헤더, 쿠키)을 분석하여 유연한 라우팅이 가능하지만 처리 오버헤드가 있습니다.',
ARRAY['L4', 'L7', 'TCP', 'HTTP', '라우팅'],
'L4는 전송 계층, L7은 애플리케이션 계층에서 동작하여 각각 다른 수준의 트래픽 제어가 가능합니다.',
'docs/01-network.md'),

('network', 'Load Balancing', 2, 10, 50,
'헬스체크가 실패하면 어떻게 되나요?',
'해당 서버를 풀에서 제외하고 다른 서버로 트래픽을 보냅니다. 서버가 복구되어 헬스체크를 통과하면 다시 풀에 추가됩니다. 기존 연결은 설정에 따라 유지하거나 끊습니다.',
ARRAY['헬스체크', '서버 풀', '트래픽', '복구', '연결'],
'헬스체크는 로드밸런서가 정상 서버에만 트래픽을 보내도록 하는 핵심 기능입니다.',
'docs/01-network.md'),

('network', 'Load Balancing', 3, 30, 75,
'HAProxy와 Nginx의 선택 기준은 무엇인가요?',
'HAProxy: 고급 로드밸런싱(연결 제한, 상세 헬스체크, 통계), 고성능 TCP 프록시에 적합합니다. Nginx: 웹서버 + 리버스 프록시 통합, 정적 파일 서빙, 설정이 간편합니다. 순수 로드밸런싱은 HAProxy, 웹서버와 통합이 필요하면 Nginx를 권장합니다.',
ARRAY['HAProxy', 'Nginx', 'TCP 프록시', '웹서버', '리버스 프록시'],
'두 도구 모두 고성능이지만 HAProxy는 로드밸런싱에, Nginx는 웹서버 기능에 더 특화되어 있습니다.',
'docs/01-network.md'),

('network', 'Load Balancing', 3, 30, 75,
'Connection Draining 시간은 어떻게 설정하나요?',
'가장 긴 요청 처리 시간 + 여유를 고려합니다. 너무 짧으면 요청 중단, 너무 길면 배포 지연이 발생합니다. 일반적으로 30-300초, 롱 폴링/WebSocket은 더 길게 설정합니다.',
ARRAY['Connection Draining', '요청 처리', '배포', '타임아웃', 'graceful'],
'Connection Draining은 서버 제거 시 기존 연결이 완료될 때까지 대기하는 graceful shutdown 기능입니다.',
'docs/01-network.md'),

('network', 'Load Balancing', 4, 50, 100,
'글로벌 서비스의 로드밸런싱 아키텍처는 어떻게 구성하나요?',
'DNS 레벨에서 GeoDNS 또는 Anycast로 가장 가까운 리전으로 라우팅합니다. 리전 레벨에서 글로벌 로드밸런서(AWS Global Accelerator, Cloudflare)가 리전을 선택하고, 리전 내에서 L7 로드밸런서가 서버를 분배합니다. 장애 시 DNS TTL과 헬스체크로 리전 간 failover합니다.',
ARRAY['GeoDNS', 'Anycast', 'Global Accelerator', 'failover', '리전'],
'글로벌 서비스는 여러 계층의 로드밸런싱을 조합하여 지연 최소화와 장애 대응을 구현합니다.',
'docs/01-network.md');

-- CDN 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', 'CDN', 1, 1, 25,
'CDN을 사용하면 왜 빨라지나요?',
'사용자와 물리적으로 가까운 서버(엣지)에서 콘텐츠를 제공하여 네트워크 지연이 줄어듭니다. 미국 서버에서 한국으로 100ms 걸리던 것이 한국 엣지에서 10ms로 단축될 수 있습니다.',
ARRAY['CDN', '엣지', '지연', '캐시', '물리적 거리'],
'CDN은 전 세계에 분산된 서버를 통해 콘텐츠를 사용자 근처에서 제공합니다.',
'docs/01-network.md'),

('network', 'CDN', 2, 10, 50,
'캐시 히트율(Cache Hit Ratio)이 중요한 이유는 무엇인가요?',
'히트율이 높을수록 오리진 요청이 줄어 응답 속도 향상, 오리진 부하 감소, 비용 절감 효과가 있습니다. 일반적으로 90% 이상을 목표로 합니다.',
ARRAY['캐시 히트율', '오리진', '응답 속도', '부하', '비용'],
'캐시 히트율은 CDN 효율성의 핵심 지표로, TTL과 캐시 키 설정이 중요합니다.',
'docs/01-network.md'),

('network', 'CDN', 3, 30, 75,
'버저닝과 캐시 무효화 중 무엇을 선택하나요?',
'버저닝 권장: 파일 변경 시 새 URL이 되어 즉시 새 버전 사용, 캐시 무효화 불필요, 롤백 용이합니다. 무효화는 같은 URL 유지가 필요한 경우(API, 마케팅 URL)에만 사용합니다.',
ARRAY['버저닝', '캐시 무효화', 'URL', '롤백', '해시'],
'파일명에 해시를 포함하는 버저닝은 캐시 관리가 단순하고 효율적입니다.',
'docs/01-network.md'),

('network', 'CDN', 4, 50, 100,
'Edge Computing의 활용 사례는 무엇인가요?',
'A/B 테스트(엣지에서 분기), 지역별 콘텐츠 맞춤, 인증 토큰 검증, URL 리라이트/리다이렉트, 봇 감지에 활용합니다. 장점은 오리진 부하 감소와 지연 최소화입니다. 주의할 점은 실행 시간 제한과 디버깅 어려움입니다.',
ARRAY['Edge Computing', 'A/B 테스트', '엣지', 'CloudFront Functions', 'Cloudflare Workers'],
'Edge Computing은 CDN 엣지에서 로직을 실행하여 오리진 부하를 줄이고 응답 속도를 높입니다.',
'docs/01-network.md');

-- 방화벽과 보안그룹 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('network', '방화벽/보안그룹', 1, 1, 25,
'인바운드만 막으면 안전한가요?',
'아닙니다. 아웃바운드도 중요합니다. 서버가 해킹당해 외부로 데이터를 유출하거나 다른 서버를 공격하는 것을 방지해야 합니다.',
ARRAY['인바운드', '아웃바운드', '데이터 유출', '방화벽', '보안'],
'방화벽은 양방향 트래픽을 모두 제어하여 침해 시 피해 확산을 방지합니다.',
'docs/01-network.md'),

('network', '방화벽/보안그룹', 2, 10, 50,
'Security Group과 NACL의 차이는 무엇인가요?',
'SG는 인스턴스에 적용, stateful(응답 트래픽 자동 허용), 허용 규칙만 가능합니다. NACL은 서브넷에 적용, stateless(양방향 규칙 필요), 허용/거부 모두 가능하고 규칙 순서가 중요합니다.',
ARRAY['Security Group', 'NACL', 'stateful', 'stateless', '인스턴스'],
'AWS에서 SG와 NACL은 다른 계층에서 동작하는 보안 도구로, 함께 사용하여 defense in depth를 구현합니다.',
'docs/01-network.md'),

('network', '방화벽/보안그룹', 3, 30, 75,
'stateful과 stateless 방화벽의 동작 차이는 무엇인가요?',
'stateful은 연결 상태를 추적하여 아웃바운드 요청의 응답은 자동 허용합니다. stateless는 각 패킷을 독립적으로 평가하여 응답도 별도 규칙이 필요합니다.',
ARRAY['stateful', 'stateless', '연결 추적', '패킷', '규칙'],
'stateful 방화벽은 TCP 연결 상태를 추적하여 관련 패킷을 자동으로 허용합니다.',
'docs/01-network.md'),

('network', '방화벽/보안그룹', 4, 50, 100,
'마이크로세그멘테이션의 구현 방법은 무엇인가요?',
'각 워크로드에 개별 보안 그룹, 서비스 메시(Istio)의 네트워크 정책, 호스트 기반 방화벽, SDN(Software Defined Network)을 사용합니다. 목표는 침해 시 lateral movement를 최소화하는 것입니다.',
ARRAY['마이크로세그멘테이션', '서비스 메시', 'Istio', 'SDN', 'lateral movement'],
'마이크로세그멘테이션은 네트워크를 세밀하게 분할하여 공격 확산을 방지하는 Zero Trust 전략입니다.',
'docs/01-network.md');

-- ============================================================
-- 리눅스/OS (Linux) 문제 - 50문제
-- ============================================================

-- 프로세스 관리 관련 문제 (8문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '프로세스 관리', 1, 1, 25,
'프로세스와 프로그램의 차이는 무엇인가요?',
'프로그램은 디스크에 저장된 실행 파일(정적)이고, 프로세스는 메모리에 로드되어 실행 중인 프로그램의 인스턴스(동적)입니다. 하나의 프로그램에서 여러 프로세스가 생성될 수 있습니다.',
ARRAY['프로세스', '프로그램', '실행', '메모리', '인스턴스'],
'프로그램은 코드와 데이터의 정적인 집합이고, 프로세스는 실행 중인 동적 상태입니다.',
'docs/02-linux-os.md'),

('linux', '프로세스 관리', 1, 1, 25,
'PID 1번 프로세스는 무엇인가요?',
'init 또는 systemd 프로세스로, 시스템 부팅 시 커널이 가장 먼저 실행하는 프로세스입니다. 모든 사용자 프로세스의 조상이며 고아 프로세스를 입양합니다.',
ARRAY['PID 1', 'init', 'systemd', '부팅', '고아 프로세스'],
'PID 1은 시스템의 첫 번째 사용자 프로세스로, 다른 모든 프로세스의 부모가 됩니다.',
'docs/02-linux-os.md'),

('linux', '프로세스 관리', 2, 10, 50,
'SIGTERM과 SIGKILL의 차이는 무엇인가요?',
'SIGTERM(15)은 프로세스에게 정상 종료를 요청하여 cleanup 작업이 가능하고 프로세스가 무시할 수 있습니다. SIGKILL(9)은 커널이 즉시 강제 종료하여 무시 불가능하고 cleanup 기회가 없습니다. 항상 SIGTERM을 먼저 시도해야 합니다.',
ARRAY['SIGTERM', 'SIGKILL', '시그널', '강제 종료', 'cleanup'],
'SIGTERM은 graceful shutdown을 허용하고, SIGKILL은 즉시 종료하므로 데이터 손실 위험이 있습니다.',
'docs/02-linux-os.md'),

('linux', '프로세스 관리', 2, 10, 50,
'좀비 프로세스는 왜 문제가 되는가?',
'좀비 프로세스는 CPU나 메모리를 사용하지 않지만 프로세스 테이블 엔트리를 차지합니다. 대량 발생 시 PID 고갈로 새 프로세스 생성이 불가능해질 수 있습니다. 해결책은 부모 프로세스가 wait()를 호출하거나 부모를 종료시키는 것입니다.',
ARRAY['좀비 프로세스', 'PID', '프로세스 테이블', 'wait()', '부모 프로세스'],
'좀비 프로세스는 종료되었지만 부모가 종료 상태를 회수하지 않은 상태입니다.',
'docs/02-linux-os.md'),

('linux', '프로세스 관리', 2, 10, 50,
'nohup의 역할은 무엇인가요?',
'프로세스가 SIGHUP을 무시하도록 하여 터미널 종료 시에도 계속 실행되게 합니다. nohup command &로 사용하며 출력은 nohup.out에 저장됩니다.',
ARRAY['nohup', 'SIGHUP', '터미널', '백그라운드', '데몬'],
'nohup은 터미널 세션이 끝나도 프로세스를 계속 실행하기 위해 사용합니다.',
'docs/02-linux-os.md'),

('linux', '프로세스 관리', 3, 30, 75,
'D 상태(Uninterruptible Sleep) 프로세스가 많으면 어떤 문제인가요?',
'D 상태는 주로 디스크 I/O나 NFS 응답 대기 중에 발생합니다. 이 상태의 프로세스가 많으면 스토리지 시스템 문제(디스크 장애, NFS 서버 응답 없음, I/O 병목)를 의심해야 합니다. SIGKILL로도 종료할 수 없어 시스템 재부팅이 필요할 수 있습니다.',
ARRAY['D 상태', 'Uninterruptible Sleep', 'I/O', 'NFS', 'SIGKILL'],
'D 상태는 커널이 I/O 완료를 기다리는 동안 프로세스를 인터럽트하지 않는 상태입니다.',
'docs/02-linux-os.md'),

('linux', '프로세스 관리', 3, 30, 75,
'/proc/[pid]/fd 디렉토리의 용도는 무엇인가요?',
'해당 프로세스가 열어둔 모든 파일 디스크립터를 심볼릭 링크로 보여줍니다. ls -la /proc/PID/fd로 프로세스가 어떤 파일, 소켓, 파이프를 열어뒀는지 확인할 수 있어 파일 핸들 누수 디버깅에 유용합니다.',
ARRAY['/proc', '파일 디스크립터', 'fd', '심볼릭 링크', '누수'],
'/proc 파일시스템은 커널이 제공하는 프로세스 정보를 파일 형태로 접근할 수 있게 합니다.',
'docs/02-linux-os.md'),

('linux', '프로세스 관리', 4, 50, 100,
'대규모 서비스에서 프로세스 관리 전략은 무엇인가요?',
'systemd의 cgroup을 활용한 리소스 격리, MemoryMax/CPUQuota로 runaway 프로세스 방지, OOMScoreAdjust로 중요 프로세스 보호, 프로세스 풀링 패턴으로 fork() 오버헤드 감소, 컨테이너화로 프로세스 그룹 관리 단순화를 적용합니다.',
ARRAY['cgroup', 'systemd', 'OOMScoreAdjust', '프로세스 풀링', '컨테이너'],
'대규모 서비스에서는 리소스 제한과 모니터링을 통해 시스템 안정성을 확보합니다.',
'docs/02-linux-os.md');

-- 스레드 vs 프로세스 관련 문제 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '스레드/프로세스', 1, 1, 25,
'왜 멀티스레딩을 사용하는가?',
'여러 작업을 동시에 처리하여 응답성을 높이고, 메모리를 공유하므로 프로세스보다 생성 비용이 적고 통신이 빠릅니다. 멀티코어 CPU를 효율적으로 활용할 수 있습니다.',
ARRAY['멀티스레딩', '동시 처리', '메모리 공유', '멀티코어', '응답성'],
'스레드는 같은 프로세스 내에서 메모리를 공유하여 효율적인 병렬 처리가 가능합니다.',
'docs/02-linux-os.md'),

('linux', '스레드/프로세스', 1, 1, 25,
'스레드가 공유하는 것과 공유하지 않는 것은 무엇인가요?',
'공유: 코드 영역, 데이터 영역, 힙, 열린 파일, 시그널 핸들러. 비공유: 스택, 레지스터, 스레드 ID, 시그널 마스크, errno.',
ARRAY['스레드', '공유', '스택', '힙', '코드 영역'],
'스레드는 주소 공간을 공유하지만 각자의 실행 컨텍스트(스택, 레지스터)를 가집니다.',
'docs/02-linux-os.md'),

('linux', '스레드/프로세스', 2, 10, 50,
'데드락 발생 조건 4가지는 무엇인가요?',
'상호 배제(Mutual Exclusion), 점유 대기(Hold and Wait), 비선점(No Preemption), 순환 대기(Circular Wait)입니다. 이 중 하나라도 깨면 데드락을 방지할 수 있습니다.',
ARRAY['데드락', '상호 배제', '점유 대기', '비선점', '순환 대기'],
'데드락은 두 개 이상의 프로세스가 서로 자원을 기다리며 무한히 대기하는 상태입니다.',
'docs/02-linux-os.md'),

('linux', '스레드/프로세스', 3, 30, 75,
'적정 스레드 풀 크기 산정 공식은 무엇인가요?',
'CPU 바운드 작업: 스레드 수 = CPU 코어 수 + 1. I/O 바운드 작업: 스레드 수 = CPU 코어 수 * (1 + 대기시간/처리시간). 또는 Little''s Law를 적용하여 동시 요청 수 = 도착률 * 평균 처리 시간으로 계산합니다.',
ARRAY['스레드 풀', 'CPU 바운드', 'I/O 바운드', 'Little''s Law', '코어'],
'스레드 풀 크기는 워크로드 특성에 따라 다르게 설정해야 최적의 성능을 얻을 수 있습니다.',
'docs/02-linux-os.md'),

('linux', '스레드/프로세스', 3, 30, 75,
'futex가 빠른 이유는 무엇인가요?',
'경쟁이 없을 때(uncontended case) 커널 진입 없이 사용자 공간의 원자적 연산만으로 락을 획득/해제합니다. 경쟁 발생 시에만 커널의 대기 큐를 사용합니다. 대부분의 락 연산이 경쟁 없이 이루어지므로 성능이 좋습니다.',
ARRAY['futex', '락', '원자적 연산', '사용자 공간', '경쟁'],
'futex는 Fast Userspace Mutex로, 대부분의 경우 시스템콜 없이 락 연산이 가능합니다.',
'docs/02-linux-os.md'),

('linux', '스레드/프로세스', 4, 50, 100,
'False sharing이란 무엇이고 어떻게 해결하는가?',
'서로 다른 CPU 코어가 같은 캐시 라인에 있는 다른 변수를 수정할 때 캐시 무효화가 발생하여 성능이 저하되는 현상입니다. 해결 방법: 변수를 캐시 라인 크기(보통 64바이트)로 패딩하거나 정렬, 또는 각 스레드가 자신만의 데이터 구조를 사용하도록 분리합니다.',
ARRAY['False sharing', '캐시 라인', '패딩', 'CPU 코어', '캐시 무효화'],
'False sharing은 멀티코어 환경에서 성능을 크게 저하시킬 수 있는 숨은 병목입니다.',
'docs/02-linux-os.md');

-- 메모리 관리 관련 문제 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '메모리 관리', 1, 1, 25,
'가상 메모리를 사용하는 이유는 무엇인가요?',
'프로세스 간 메모리 격리로 보안/안정성 확보, 물리 메모리보다 큰 주소 공간 사용 가능, 메모리 단편화 문제 해결, 공유 라이브러리의 효율적 공유가 가능합니다.',
ARRAY['가상 메모리', '메모리 격리', '주소 공간', '단편화', '공유 라이브러리'],
'가상 메모리는 각 프로세스에 독립된 주소 공간을 제공하여 보안과 편의성을 높입니다.',
'docs/02-linux-os.md'),

('linux', '메모리 관리', 1, 1, 25,
'free -h 출력에서 buff/cache는 무엇인가요?',
'buffers는 블록 디바이스의 메타데이터 캐시, cache는 파일 내용 캐시입니다. 이 메모리는 필요시 즉시 해제 가능하므로 실제 가용 메모리는 free + buff/cache입니다. available 컬럼이 실제 사용 가능한 메모리를 보여줍니다.',
ARRAY['free', 'buff/cache', 'available', '캐시', '가용 메모리'],
'리눅스는 유휴 메모리를 캐시로 활용하여 파일 I/O 성능을 높입니다.',
'docs/02-linux-os.md'),

('linux', '메모리 관리', 2, 10, 50,
'Minor와 Major 페이지 폴트의 차이는 무엇인가요?',
'Minor(soft) 페이지 폴트: 페이지가 물리 메모리에 있지만 페이지 테이블에 매핑 안 됨, 디스크 I/O 없이 해결됩니다. Major(hard) 페이지 폴트: 페이지가 디스크에서 로드되어야 함, 디스크 I/O 발생으로 느립니다. ps -o min_flt,maj_flt로 확인합니다.',
ARRAY['페이지 폴트', 'Minor', 'Major', '디스크 I/O', '페이지 테이블'],
'Major 페이지 폴트가 많으면 메모리 부족이나 I/O 병목을 의심해야 합니다.',
'docs/02-linux-os.md'),

('linux', '메모리 관리', 2, 10, 50,
'Copy-on-Write(COW)란 무엇인가요?',
'fork() 시 실제로 메모리를 복사하지 않고 페이지를 읽기 전용으로 공유하다가, 쓰기 발생 시에만 복사하는 기법입니다. fork() 비용을 줄이고 메모리를 절약합니다.',
ARRAY['Copy-on-Write', 'COW', 'fork()', '메모리 복사', '읽기 전용'],
'COW는 불필요한 메모리 복사를 지연시켜 효율성을 높이는 최적화 기법입니다.',
'docs/02-linux-os.md'),

('linux', '메모리 관리', 3, 30, 75,
'OOM Killer가 프로세스를 선택하는 기준은 무엇인가요?',
'oom_score를 기반으로 하며, 메모리 사용량이 많고 실행 시간이 짧으며 중요도가 낮은 프로세스가 선택됩니다. /proc/[pid]/oom_score로 확인하고 oom_score_adj(-1000~1000)로 조정합니다. -1000은 OOM 대상에서 제외, 1000은 최우선 대상입니다.',
ARRAY['OOM Killer', 'oom_score', 'oom_score_adj', '메모리', '프로세스'],
'OOM Killer는 시스템 메모리가 고갈될 때 프로세스를 종료하여 시스템을 보호합니다.',
'docs/02-linux-os.md'),

('linux', '메모리 관리', 4, 50, 100,
'cgroup v2에서 메모리 제한 설정 방법은 무엇인가요?',
'memory.max로 하드 리밋, memory.high로 소프트 리밋(스로틀링), memory.low로 보호 설정을 합니다. memory.high 초과 시 reclaim 압박을 주고, memory.max 초과 시 OOM Killer가 호출됩니다. systemd에서는 MemoryMax, MemoryHigh 옵션을 사용합니다.',
ARRAY['cgroup v2', 'memory.max', 'memory.high', 'memory.low', 'systemd'],
'cgroup v2는 통합된 계층 구조로 프로세스 그룹의 리소스를 세밀하게 제어합니다.',
'docs/02-linux-os.md');

-- 파일시스템 관련 문제 (6문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '파일시스템', 1, 1, 25,
'리눅스에서 "모든 것이 파일"이라는 의미는 무엇인가요?',
'일반 파일, 디렉토리, 디바이스, 소켓, 파이프, 심지어 프로세스 정보(/proc)까지 파일 인터페이스로 접근합니다. read(), write() 등 동일한 시스템콜로 다양한 자원을 다룰 수 있습니다.',
ARRAY['파일', '디바이스', '/proc', '추상화', '시스템콜'],
'유닉스 철학인 "모든 것이 파일"은 일관된 인터페이스로 시스템 자원에 접근할 수 있게 합니다.',
'docs/02-linux-os.md'),

('linux', '파일시스템', 2, 10, 50,
'inode가 저장하는 정보와 저장하지 않는 정보는 무엇인가요?',
'저장: 파일 타입, 권한, 소유자/그룹, 크기, 타임스탬프, 데이터 블록 포인터. 저장 안 함: 파일명(디렉토리 엔트리에 저장). 파일명은 inode 번호와 매핑되어 디렉토리에 저장됩니다.',
ARRAY['inode', '메타데이터', '파일명', '권한', '블록 포인터'],
'inode는 파일의 메타데이터를 저장하는 자료구조로, 파일명은 별도로 디렉토리에 저장됩니다.',
'docs/02-linux-os.md'),

('linux', '파일시스템', 2, 10, 50,
'하드링크와 심볼릭링크의 차이와 각각의 용도는 무엇인가요?',
'하드링크: 같은 inode 공유, 원본 삭제해도 접근 가능, 같은 파일시스템만 가능, 디렉토리 불가. 심볼릭링크: 경로를 저장, 원본 삭제 시 깨짐, 다른 파일시스템 가능, 디렉토리 가능. 심볼릭링크가 더 유연하여 일반적으로 많이 사용됩니다.',
ARRAY['하드링크', '심볼릭링크', 'inode', '경로', '파일시스템'],
'하드링크는 같은 데이터를 가리키는 또 다른 이름이고, 심볼릭링크는 경로를 가리키는 포인터입니다.',
'docs/02-linux-os.md'),

('linux', '파일시스템', 2, 10, 50,
'ext4와 xfs의 차이와 선택 기준은 무엇인가요?',
'ext4: 범용, 안정적, fsck 빠름, 최대 1EB. xfs: 대용량 파일에 최적화, 병렬 I/O 우수, 확장만 가능(축소 불가). 대용량 미디어 파일이나 빅데이터는 xfs, 일반 서버는 ext4를 권장합니다.',
ARRAY['ext4', 'xfs', '대용량', '병렬 I/O', 'fsck'],
'파일시스템 선택은 워크로드 특성과 요구사항에 따라 달라집니다.',
'docs/02-linux-os.md'),

('linux', '파일시스템', 3, 30, 75,
'저널링의 세 가지 모드는 무엇인가요?',
'writeback: 메타데이터만 저널링(빠름, 데이터 손실 가능). ordered(기본): 데이터 쓴 후 메타데이터 저널링(균형). journal: 모든 것 저널링(안전, 느림). mount 옵션으로 data=ordered 등 지정합니다.',
ARRAY['저널링', 'writeback', 'ordered', 'journal', '메타데이터'],
'저널링은 파일시스템의 일관성을 보장하기 위해 변경 사항을 먼저 로그에 기록합니다.',
'docs/02-linux-os.md'),

('linux', '파일시스템', 3, 30, 75,
'rm으로 파일을 삭제해도 용량이 회복되지 않는 경우는 언제인가요?',
'파일이 다른 프로세스에 의해 열려있으면 inode가 해제되지 않아 디스크 공간이 회복되지 않습니다. lsof +L1로 확인 후 해당 프로세스를 재시작해야 합니다. 이것이 로그 파일을 truncate하는 것보다 rm 후 재시작이 필요한 이유입니다.',
ARRAY['rm', 'inode', 'lsof', '프로세스', '디스크 공간'],
'열린 파일의 inode는 참조 카운트가 0이 될 때까지 유지됩니다.',
'docs/02-linux-os.md');

-- 커널 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '커널', 1, 1, 25,
'커널 공간과 사용자 공간의 차이는 무엇인가요?',
'커널 공간은 하드웨어에 직접 접근 가능하고 모든 권한을 가집니다. 사용자 공간은 제한된 권한으로 커널을 통해서만 하드웨어에 접근합니다. 사용자 프로그램이 커널 기능을 사용하려면 시스템콜을 호출해야 합니다.',
ARRAY['커널 공간', '사용자 공간', '하드웨어', '시스템콜', '권한'],
'커널과 사용자 공간의 분리는 시스템 안정성과 보안의 기반입니다.',
'docs/02-linux-os.md'),

('linux', '커널', 2, 10, 50,
'자주 사용되는 시스템콜에는 무엇이 있는가?',
'파일: open, read, write, close, stat. 프로세스: fork, exec, wait, exit. 메모리: mmap, brk. 네트워크: socket, bind, listen, accept, connect. strace로 프로세스의 시스템콜을 추적할 수 있습니다.',
ARRAY['시스템콜', 'open', 'fork', 'mmap', 'socket'],
'시스템콜은 사용자 프로그램이 커널 서비스를 요청하는 인터페이스입니다.',
'docs/02-linux-os.md'),

('linux', '커널', 3, 30, 75,
'sysctl로 자주 튜닝하는 파라미터는 무엇인가요?',
'네트워크: net.core.somaxconn, net.ipv4.tcp_max_syn_backlog, net.core.netdev_max_backlog. 메모리: vm.swappiness, vm.dirty_ratio, vm.overcommit_memory. 파일: fs.file-max, fs.inotify.max_user_watches. 보안: kernel.randomize_va_space.',
ARRAY['sysctl', '커널 파라미터', 'somaxconn', 'swappiness', 'dirty_ratio'],
'sysctl은 런타임에 커널 파라미터를 조정하는 도구로, 시스템 튜닝에 필수입니다.',
'docs/02-linux-os.md'),

('linux', '커널', 4, 50, 100,
'eBPF의 용도와 장점은 무엇인가요?',
'eBPF는 커널 내에서 안전하게 실행되는 샌드박스 프로그램입니다. 용도: 네트워크 필터링(XDP), 보안 모니터링, 성능 추적, 디버깅. 장점: 커널 수정/재부팅 없이 기능 추가, 낮은 오버헤드, 안전성(verifier). bcc, bpftrace 도구로 활용합니다.',
ARRAY['eBPF', 'XDP', 'bcc', 'bpftrace', '성능 추적'],
'eBPF는 커널 확장성과 관측성을 혁신적으로 개선한 기술입니다.',
'docs/02-linux-os.md');

-- systemd 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'systemd', 1, 1, 25,
'systemctl start와 enable의 차이는 무엇인가요?',
'start: 지금 즉시 서비스를 시작합니다. enable: 부팅 시 자동으로 시작하도록 설정합니다(심볼릭 링크 생성). 둘 다 필요하면 systemctl enable --now service를 사용합니다.',
ARRAY['systemctl', 'start', 'enable', '부팅', '서비스'],
'start는 즉시 실행, enable은 부팅 시 자동 실행을 설정합니다.',
'docs/02-linux-os.md'),

('linux', 'systemd', 2, 10, 50,
'service 파일의 Type 옵션 각각의 의미는 무엇인가요?',
'simple(기본): 프로세스가 바로 시작됨. forking: fork 후 부모 종료, PIDFile 필요. oneshot: 실행 완료 후 종료, RemainAfterExit과 사용. notify: sd_notify()로 준비 완료 알림. dbus: D-Bus 이름 등록으로 준비 완료.',
ARRAY['Type', 'simple', 'forking', 'oneshot', 'notify'],
'Type은 systemd가 서비스 시작 완료를 어떻게 판단하는지 결정합니다.',
'docs/02-linux-os.md'),

('linux', 'systemd', 3, 30, 75,
'systemd 서비스 보안 강화 옵션은 무엇인가요?',
'ProtectSystem=strict(파일시스템 읽기전용), ProtectHome=yes(홈 디렉토리 숨김), NoNewPrivileges=yes(권한 상승 금지), CapabilityBoundingSet=(capability 제한), PrivateTmp=yes(독립 /tmp). systemd-analyze security로 점검합니다.',
ARRAY['ProtectSystem', 'NoNewPrivileges', 'CapabilityBoundingSet', 'PrivateTmp', '보안'],
'systemd는 다양한 샌드박싱 옵션으로 서비스 보안을 강화할 수 있습니다.',
'docs/02-linux-os.md'),

('linux', 'systemd', 4, 50, 100,
'부팅 시간을 최적화하는 방법은 무엇인가요?',
'systemd-analyze blame으로 느린 서비스를 파악하고, systemd-analyze critical-chain으로 병목을 확인합니다. 불필요한 서비스 disable, socket activation으로 지연 로딩, DefaultDependencies=no로 의존성 최소화, Type=notify 활용을 적용합니다.',
ARRAY['systemd-analyze', 'blame', 'critical-chain', 'socket activation', '부팅'],
'systemd의 병렬 부팅과 on-demand 시작으로 부팅 시간을 최적화할 수 있습니다.',
'docs/02-linux-os.md');

-- cgroup과 namespace 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', 'cgroup/namespace', 1, 1, 25,
'컨테이너가 가상머신과 다른 점은 무엇인가요?',
'컨테이너는 호스트 커널을 공유하고 cgroup/namespace로 격리합니다. VM은 전체 OS를 가상화하여 별도 커널을 실행합니다. 컨테이너가 더 가볍고 빠르지만 격리 수준은 VM이 더 강합니다.',
ARRAY['컨테이너', 'VM', 'cgroup', 'namespace', '격리'],
'컨테이너는 프로세스 수준 가상화로, VM보다 오버헤드가 적습니다.',
'docs/02-linux-os.md'),

('linux', 'cgroup/namespace', 2, 10, 50,
'주요 namespace의 역할은 무엇인가요?',
'pid: 프로세스 ID 격리(컨테이너 내 PID 1). net: 네트워크 스택 격리(독립 인터페이스). mnt: 파일시스템 마운트 격리. uts: 호스트명 격리. ipc: IPC 리소스 격리. user: UID/GID 매핑(rootless 컨테이너).',
ARRAY['namespace', 'pid', 'net', 'mnt', 'user'],
'namespace는 프로세스가 시스템 리소스를 독립적으로 보도록 격리합니다.',
'docs/02-linux-os.md'),

('linux', 'cgroup/namespace', 3, 30, 75,
'cgroup v2 메모리 컨트롤러의 주요 설정은 무엇인가요?',
'memory.max: 하드 리밋, 초과 시 OOM. memory.high: 소프트 리밋, 초과 시 스로틀링. memory.low: 보호, 이 값까지는 reclaim 안함. memory.min: 보장, 절대 reclaim 안함. 단계적 제어가 가능합니다.',
ARRAY['cgroup v2', 'memory.max', 'memory.high', 'memory.low', 'OOM'],
'cgroup v2의 메모리 컨트롤러는 세밀한 메모리 관리를 제공합니다.',
'docs/02-linux-os.md'),

('linux', 'cgroup/namespace', 4, 50, 100,
'컨테이너 보안을 강화하는 방법은 무엇인가요?',
'namespace로 기본 격리, cgroup으로 리소스 제한, seccomp로 시스템콜 필터링, AppArmor/SELinux로 MAC(Mandatory Access Control), capabilities 최소화, read-only 파일시스템, user namespace로 rootless 실행을 적용합니다.',
ARRAY['seccomp', 'AppArmor', 'SELinux', 'capabilities', 'rootless'],
'컨테이너 보안은 여러 계층의 방어를 조합하여 구현합니다.',
'docs/02-linux-os.md');

-- 디스크 I/O 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '디스크 I/O', 1, 1, 25,
'HDD와 SSD의 주요 차이는 무엇인가요?',
'HDD: 회전 디스크, 순차 접근에 유리, 가격 저렴, 진동에 약함. SSD: 플래시 메모리, 랜덤 접근 빠름, 가격 비쌈, 쓰기 수명 제한. SSD는 IOPS가 수십~수백 배 높습니다.',
ARRAY['HDD', 'SSD', 'IOPS', '랜덤 접근', '순차 접근'],
'SSD는 물리적 탐색 시간이 없어 랜덤 I/O 성능이 뛰어납니다.',
'docs/02-linux-os.md'),

('linux', '디스크 I/O', 2, 10, 50,
'I/O 스케줄러의 선택 기준은 무엇인가요?',
'mq-deadline: 범용, 지연 시간 보장. bfq: 데스크톱, 공정성 중시. kyber: 고성능 SSD. none: NVMe SSD(하드웨어가 스케줄링). cat /sys/block/sda/queue/scheduler로 확인하고 echo로 변경합니다.',
ARRAY['I/O 스케줄러', 'mq-deadline', 'bfq', 'kyber', 'NVMe'],
'I/O 스케줄러는 디스크 특성과 워크로드에 맞게 선택해야 합니다.',
'docs/02-linux-os.md'),

('linux', '디스크 I/O', 3, 30, 75,
'Direct I/O는 언제 사용하는가?',
'페이지 캐시를 우회하여 디스크에 직접 읽기/쓰기합니다. 데이터베이스처럼 자체 캐싱을 하는 애플리케이션에서 사용하여 이중 캐싱을 방지합니다. O_DIRECT 플래그로 열거나 데이터베이스 설정으로 활성화합니다.',
ARRAY['Direct I/O', 'O_DIRECT', '페이지 캐시', '데이터베이스', '이중 캐싱'],
'Direct I/O는 애플리케이션이 자체 버퍼 관리를 할 때 효율적입니다.',
'docs/02-linux-os.md'),

('linux', '디스크 I/O', 4, 50, 100,
'io_uring의 장점은 무엇인가요?',
'시스템콜 오버헤드 최소화(배치 처리), 폴링 모드로 인터럽트 제거, 비동기 I/O의 효율성 향상. epoll보다 성능이 좋고 libaio보다 유연합니다. 고성능 네트워크/스토리지 애플리케이션에서 채택이 증가하고 있습니다.',
ARRAY['io_uring', '비동기 I/O', '배치 처리', '폴링', 'epoll'],
'io_uring은 리눅스의 차세대 비동기 I/O 인터페이스로 성능이 뛰어납니다.',
'docs/02-linux-os.md');

-- 네트워크 스택 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '네트워크 스택', 1, 1, 25,
'ss -tulnp 명령어의 의미는 무엇인가요?',
'-t: TCP, -u: UDP, -l: LISTEN 상태, -n: 숫자로 표시, -p: 프로세스 정보. 현재 열려있는 포트와 해당 프로세스를 확인합니다. netstat보다 빠르고 더 많은 정보를 제공합니다.',
ARRAY['ss', 'netstat', 'LISTEN', 'TCP', '포트'],
'ss는 소켓 통계를 보여주는 현대적인 도구로, netstat를 대체합니다.',
'docs/02-linux-os.md'),

('linux', '네트워크 스택', 2, 10, 50,
'TIME_WAIT이 많으면 어떤 문제가 발생하는가?',
'소켓(로컬 포트)이 소진되어 새 연결이 실패할 수 있습니다. 해결: connection pool 사용, SO_REUSEADDR 설정, tcp_tw_reuse 활성화, tcp_fin_timeout 단축. 근본적으로는 연결을 재사용하도록 개선합니다.',
ARRAY['TIME_WAIT', '소켓', 'connection pool', 'SO_REUSEADDR', 'tcp_tw_reuse'],
'TIME_WAIT는 TCP 연결 종료 후 남는 상태로, 대량 발생 시 자원 고갈 문제가 됩니다.',
'docs/02-linux-os.md'),

('linux', '네트워크 스택', 3, 30, 75,
'select/poll과 epoll의 차이는 무엇인가요?',
'select/poll: 매번 전체 fd 목록 전달, O(n) 스캔. epoll: 커널에 관심 fd 등록, 이벤트 발생한 것만 반환, O(1) 검색. 대규모 연결(C10K)에서 epoll이 훨씬 효율적입니다. kqueue(BSD), IOCP(Windows)와 유사합니다.',
ARRAY['select', 'poll', 'epoll', 'C10K', '이벤트'],
'epoll은 대규모 동시 연결을 효율적으로 처리하기 위한 리눅스 전용 메커니즘입니다.',
'docs/02-linux-os.md'),

('linux', '네트워크 스택', 4, 50, 100,
'XDP의 용도와 장점은 무엇인가요?',
'드라이버 레벨에서 패킷을 처리하는 eBPF 프로그램입니다. 커널 네트워크 스택 진입 전에 처리하여 매우 빠릅니다. 용도: DDoS 방어, 로드밸런싱, 패킷 필터링. Cloudflare, Facebook 등에서 사용합니다. XDP_DROP, XDP_TX, XDP_PASS 등 액션이 가능합니다.',
ARRAY['XDP', 'eBPF', 'DDoS', '로드밸런싱', '패킷 필터링'],
'XDP는 네트워크 패킷을 최고 성능으로 처리할 수 있는 프레임워크입니다.',
'docs/02-linux-os.md');

-- 권한과 보안 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '권한/보안', 1, 1, 25,
'chmod 755와 chmod 644의 의미는 무엇인가요?',
'755: rwxr-xr-x (소유자 모든 권한, 그룹/기타 읽기+실행) - 실행 파일, 디렉토리용. 644: rw-r--r-- (소유자 읽기+쓰기, 그룹/기타 읽기만) - 일반 파일용. 숫자는 r=4, w=2, x=1의 합입니다.',
ARRAY['chmod', '755', '644', '권한', 'rwx'],
'리눅스 파일 권한은 소유자, 그룹, 기타 사용자별로 읽기/쓰기/실행 권한을 설정합니다.',
'docs/02-linux-os.md'),

('linux', '권한/보안', 2, 10, 50,
'SUID, SGID, Sticky Bit의 역할은 무엇인가요?',
'SUID(4xxx): 실행 시 소유자 권한으로 실행(passwd가 root 권한 필요). SGID(2xxx): 실행 시 그룹 권한, 디렉토리면 새 파일이 부모 그룹 상속. Sticky Bit(1xxx): 디렉토리에서 소유자만 삭제 가능(/tmp).',
ARRAY['SUID', 'SGID', 'Sticky Bit', '특수 권한', '/tmp'],
'특수 권한은 일반 rwx 권한 외에 추가적인 보안 기능을 제공합니다.',
'docs/02-linux-os.md'),

('linux', '권한/보안', 3, 30, 75,
'Capabilities가 필요한 이유는 무엇인가요?',
'전통적으로 root는 모든 권한을 가지지만, 이는 최소 권한 원칙에 위배됩니다. Capabilities로 권한을 CAP_NET_BIND_SERVICE(1024 이하 포트), CAP_SYS_PTRACE(프로세스 추적) 등으로 세분화하여 필요한 것만 부여할 수 있습니다.',
ARRAY['Capabilities', 'CAP_NET_BIND_SERVICE', '최소 권한', 'root', '세분화'],
'Capabilities는 root 권한을 세분화하여 보안을 강화하는 메커니즘입니다.',
'docs/02-linux-os.md'),

('linux', '권한/보안', 4, 50, 100,
'프로덕션 서버 하드닝 체크리스트는 무엇인가요?',
'SSH: 키 인증만, root 로그인 금지, 포트 변경. 방화벽: 필요한 포트만 허용. 업데이트: 자동 보안 패치. 사용자: 최소 권한, sudo 로깅. 감사: auditd, 파일 무결성. 서비스: 불필요한 서비스 제거. SELinux/AppArmor 활성화.',
ARRAY['하드닝', 'SSH', '방화벽', 'auditd', 'SELinux'],
'서버 하드닝은 여러 보안 레이어를 적용하여 공격 표면을 최소화합니다.',
'docs/02-linux-os.md');

-- 성능 분석 도구 관련 문제 (4문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '성능 분석', 1, 1, 25,
'load average 1.00의 의미는 무엇인가요?',
'1개의 CPU가 100% 사용 중이거나 1개의 작업이 대기 중임을 의미합니다. 4코어 시스템에서 4.00이면 적정 부하, 8.00이면 과부하입니다. 1분/5분/15분 평균으로 추세를 파악합니다.',
ARRAY['load average', 'CPU', '부하', 'uptime', '코어'],
'load average는 실행 대기 중인 프로세스 수의 시간 평균입니다.',
'docs/02-linux-os.md'),

('linux', '성능 분석', 2, 10, 50,
'vmstat 출력의 주요 항목은 무엇인가요?',
'r: 실행 대기 프로세스. b: 블록된 프로세스. swpd: 사용 중 swap. free: 여유 메모리. si/so: swap in/out. bi/bo: 블록 in/out. us/sy/id/wa: CPU 사용률. r이 CPU 수보다 크면 CPU 포화입니다.',
ARRAY['vmstat', 'swap', 'CPU', '메모리', '블록'],
'vmstat은 시스템 전반의 상태를 한눈에 파악할 수 있는 기본 도구입니다.',
'docs/02-linux-os.md'),

('linux', '성능 분석', 3, 30, 75,
'perf로 할 수 있는 분석은 무엇인가요?',
'perf top: 실시간 핫스팟. perf record/report: 프로파일 기록/분석. perf stat: 하드웨어 카운터. perf trace: 시스템콜 추적. CPU 캐시 미스, 분기 예측 실패 등 하드웨어 레벨 분석이 가능합니다.',
ARRAY['perf', '프로파일링', '핫스팟', '하드웨어 카운터', '캐시 미스'],
'perf는 리눅스의 강력한 성능 분석 도구로, 커널과 애플리케이션 모두 분석 가능합니다.',
'docs/02-linux-os.md'),

('linux', '성능 분석', 4, 50, 100,
'프로덕션 성능 분석의 원칙은 무엇인가요?',
'오버헤드 최소화(샘플링, eBPF), 기준선 확보(평상시 데이터), USE 방법론(Utilization, Saturation, Errors), 재현 가능한 방법, 지속적 프로파일링(Parca, Pyroscope), 가설-검증 사이클을 따릅니다.',
ARRAY['USE 방법론', '기준선', 'eBPF', '지속적 프로파일링', '가설 검증'],
'프로덕션 환경에서는 서비스 영향을 최소화하면서 정확한 분석이 필요합니다.',
'docs/02-linux-os.md');

-- 쉘 스크립팅 관련 문제 (2문제)
INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc) VALUES
('linux', '쉘 스크립팅', 1, 1, 25,
'파이프(|)와 리다이렉션(>)의 차이는 무엇인가요?',
'파이프: 명령어의 stdout을 다음 명령어의 stdin으로 연결. 예: ls | grep txt. 리다이렉션: stdout을 파일로 저장. >는 덮어쓰기, >>는 추가. 예: echo "hello" > file.txt.',
ARRAY['파이프', '리다이렉션', 'stdout', 'stdin', '명령어'],
'파이프와 리다이렉션은 유닉스 철학의 핵심인 명령어 조합의 기반입니다.',
'docs/02-linux-os.md'),

('linux', '쉘 스크립팅', 2, 10, 50,
'set -e의 역할은 무엇인가요?',
'스크립트에서 명령어가 실패하면(exit code != 0) 즉시 종료합니다. 에러 무시를 방지합니다. set -u는 미정의 변수 사용 시 에러. set -o pipefail은 파이프라인 중 실패 감지. set -euo pipefail 조합을 권장합니다.',
ARRAY['set -e', 'set -u', 'pipefail', 'exit code', '에러'],
'안전한 쉘 스크립트 작성을 위해 set 옵션을 적절히 활용해야 합니다.',
'docs/02-linux-os.md');
