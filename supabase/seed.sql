-- ============================================
-- CS Knowledge 시드 데이터 (통합)
-- 총 문제: ~408문제 (8분야 × ~50문제)
-- 몬스터: 40마리, 업적: 25개, 아이템: 32개
-- 생성일: 2026-02-14
-- ============================================

BEGIN;

-- ============================================
-- 1. Questions (문제 은행)
-- ============================================

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

-- =====================================================
-- CS Knowledge Quiz - Architecture & Incident Questions
-- =====================================================
-- 분야별 문제 수:
--   - Architecture (아키텍처/확장성): 50문제
--   - Incident (장애대응/SRE): 50문제
-- 총 문제 수: 100문제
--
-- 난이도 분배 (분야당):
--   - 난이도 1 (입문): ~15문제
--   - 난이도 2 (주니어): ~15문제
--   - 난이도 3 (시니어): ~12문제
--   - 난이도 4 (리드): ~8문제
-- =====================================================

INSERT INTO questions (category, subcategory, difficulty, level_min, level_max, question_text, correct_answer, keywords, explanation, source_doc)
VALUES

-- =====================================================
-- ARCHITECTURE (아키텍처/확장성) - 50문제
-- =====================================================

-- 난이도 1 (입문) - 15문제
('architecture', '모놀리스 vs 마이크로서비스', 1, 1, 25,
 '모놀리스 아키텍처란 무엇인가요?',
 '모놀리스 아키텍처는 모든 기능이 단일 애플리케이션으로 통합된 구조입니다. 하나의 코드베이스, 하나의 배포 단위, 하나의 데이터베이스를 공유하며, 모든 컴포넌트가 단일 프로세스로 실행됩니다.',
 ARRAY['단일 애플리케이션', '하나의 코드베이스', '하나의 배포 단위', '통합 구조', '단일 프로세스'],
 '모놀리스는 초기 개발이 단순하고 빠르지만, 규모가 커지면 복잡도가 증가하고 확장이 어려워질 수 있습니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '모놀리스 vs 마이크로서비스', 1, 1, 25,
 '마이크로서비스 아키텍처의 장점을 설명하세요.',
 '마이크로서비스의 장점은 서비스별 독립 배포가 가능하고, 기술 스택을 자유롭게 선택할 수 있으며, 장애가 격리되고, 팀별로 독립적으로 개발할 수 있으며, 서비스별로 개별 확장이 가능하다는 것입니다.',
 ARRAY['독립 배포', '기술 스택 자유', '장애 격리', '독립 개발', '개별 확장'],
 '마이크로서비스는 대규모 팀과 복잡한 시스템에서 효과적이지만, 분산 시스템의 복잡성을 관리해야 합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'API 설계', 1, 1, 25,
 'REST API에서 주요 HTTP 메서드의 용도를 설명하세요.',
 'GET은 조회, POST는 생성, PUT은 전체 수정, PATCH는 부분 수정, DELETE는 삭제에 사용됩니다. GET, PUT, DELETE는 멱등성을 가지며, GET은 안전한(safe) 메서드입니다.',
 ARRAY['GET', 'POST', 'PUT', 'PATCH', 'DELETE', '멱등성'],
 '멱등성은 같은 요청을 여러 번 해도 결과가 동일한 것을 의미합니다. POST는 비멱등 메서드입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'API 설계', 1, 1, 25,
 '자주 사용하는 HTTP 상태 코드를 설명하세요.',
 '200은 성공, 201은 생성됨, 400은 잘못된 요청, 401은 인증 필요, 403은 권한 없음, 404는 리소스 없음, 500은 서버 오류를 의미합니다. 2xx는 성공, 4xx는 클라이언트 오류, 5xx는 서버 오류입니다.',
 ARRAY['200', '201', '400', '401', '403', '404', '500'],
 '상태 코드는 클라이언트에게 요청 결과를 명확하게 전달하는 중요한 수단입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '메시지 큐', 1, 1, 25,
 '메시지 큐를 사용하는 이유는 무엇인가요?',
 '메시지 큐는 비동기 처리로 응답 시간을 단축하고, 시스템 간 결합도를 감소시키며, 피크 트래픽을 흡수하여 부하를 조절하고, 장애를 격리하며, 실패 시 재처리를 용이하게 합니다.',
 ARRAY['비동기 처리', '결합도 감소', '부하 조절', '장애 격리', '재처리'],
 'Kafka, RabbitMQ, SQS 등 다양한 메시지 큐 솔루션이 있으며, 용도에 맞게 선택합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '이벤트 드리븐', 1, 1, 25,
 '이벤트와 커맨드의 차이점은 무엇인가요?',
 '커맨드는 "~을 해라"라는 명령으로 특정 대상에게 보내는 것이고, 이벤트는 "~이 발생했다"라는 사실로 누가 구독할지 모르는 상태로 발행됩니다. 커맨드는 명령형, 이벤트는 과거형으로 명명합니다.',
 ARRAY['커맨드', '이벤트', '명령', '사실', '발행', '구독'],
 '이벤트 드리븐 아키텍처에서 이 구분은 시스템 설계의 핵심입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'CQRS', 1, 1, 25,
 'CQRS란 무엇인가요?',
 'CQRS(Command Query Responsibility Segregation)는 데이터 변경(Command)과 데이터 조회(Query)를 위한 모델을 분리하는 아키텍처 패턴입니다. 각 모델을 독립적으로 최적화할 수 있어 복잡한 도메인에서 유용합니다.',
 ARRAY['CQRS', 'Command', 'Query', '분리', '모델', '최적화'],
 'CQRS는 이벤트 소싱과 자주 결합되어 사용됩니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '캐싱 아키텍처', 1, 1, 25,
 '캐시를 어디에 배치할 수 있나요?',
 '캐시는 브라우저, CDN, 로드밸런서/리버스프록시, 애플리케이션(로컬/분산), 데이터베이스 등 여러 계층에 배치할 수 있습니다. 사용자에 가까울수록 응답이 빠릅니다.',
 ARRAY['브라우저', 'CDN', '로드밸런서', '애플리케이션 캐시', '분산 캐시', 'Redis'],
 '멀티 레이어 캐시 전략을 통해 DB 부하를 최소화할 수 있습니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '스케일링', 1, 1, 25,
 '수직 확장(Scale Up)과 수평 확장(Scale Out)의 차이점을 설명하세요.',
 '수직 확장은 서버의 CPU, 메모리, 디스크를 증가시키는 것으로 구성이 단순하지만 하드웨어 한계가 있습니다. 수평 확장은 서버 수를 늘리는 것으로 이론적으로 무한 확장이 가능하지만 애플리케이션이 상태 비저장(Stateless)이어야 합니다.',
 ARRAY['수직 확장', '수평 확장', 'Scale Up', 'Scale Out', 'Stateless', '하드웨어 한계'],
 '현대 클라우드 환경에서는 수평 확장과 자동 스케일링이 일반적입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'CAP 정리', 1, 1, 25,
 'CAP 정리에서 C, A, P는 각각 무엇을 의미하나요?',
 'C(Consistency)는 모든 노드가 같은 시점에 같은 데이터를 보는 것, A(Availability)는 모든 요청이 응답을 받는 것, P(Partition Tolerance)는 네트워크 분할이 발생해도 시스템이 동작하는 것을 의미합니다.',
 ARRAY['Consistency', 'Availability', 'Partition Tolerance', '일관성', '가용성', '분할 내성'],
 'CAP 정리는 분산 시스템에서 세 가지 속성 중 최대 두 가지만 보장할 수 있다는 이론입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '서비스 메시', 1, 1, 25,
 '서비스 메시가 필요한 이유는 무엇인가요?',
 '마이크로서비스 수가 늘어나면 서비스 간 통신 관리가 복잡해집니다. 디스커버리, 로드 밸런싱, 보안, 모니터링을 각 서비스에 구현하면 중복과 복잡성이 증가하므로, 서비스 메시로 이를 중앙에서 처리합니다.',
 ARRAY['서비스 메시', '마이크로서비스', '통신 관리', '디스커버리', '로드 밸런싱', 'mTLS'],
 'Istio, Linkerd 등이 대표적인 서비스 메시 솔루션입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '서버리스', 1, 1, 25,
 '서버리스의 장단점을 설명하세요.',
 '장점은 서버 관리 불필요, 자동 확장, 사용량 기반 과금, 빠른 배포입니다. 단점은 콜드 스타트 지연, 실행 시간 제한, 상태 유지 어려움, 벤더 종속, 로컬 개발/디버깅 어려움입니다.',
 ARRAY['서버리스', '자동 확장', '콜드 스타트', '벤더 종속', 'FaaS', 'Lambda'],
 '서버리스는 "서버가 없다"가 아니라 "서버를 관리하지 않는다"는 의미입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'DDD', 1, 1, 25,
 '유비쿼터스 언어(Ubiquitous Language)란 무엇인가요?',
 '유비쿼터스 언어는 개발자와 도메인 전문가가 공유하는 공통 용어입니다. 코드, 문서, 대화에서 동일한 용어를 사용하여 의사소통 오해를 방지합니다.',
 ARRAY['유비쿼터스 언어', 'DDD', '공통 용어', '도메인 전문가', '의사소통'],
 'DDD(Domain-Driven Design)의 핵심 개념 중 하나입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '12-Factor App', 1, 1, 25,
 '12-Factor App이란 무엇인가요?',
 '12-Factor App은 확장 가능하고 유지보수하기 쉬운 SaaS 애플리케이션을 만들기 위한 12가지 원칙입니다. 클라우드 환경에 최적화된 설계 지침으로, 환경 간 이식성과 CI/CD 친화적인 특성을 제공합니다.',
 ARRAY['12-Factor', 'SaaS', '클라우드 네이티브', '이식성', 'CI/CD'],
 'Heroku 개발자들이 정리한 방법론으로, 현대 클라우드 애플리케이션의 기본 원칙입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'API Gateway', 1, 1, 25,
 'API Gateway의 주요 기능은 무엇인가요?',
 'API Gateway는 요청 라우팅, 인증/인가, Rate Limiting, 요청/응답 변환, 로드 밸런싱, SSL 종료, 캐싱, 로깅/모니터링 등의 기능을 제공합니다.',
 ARRAY['API Gateway', '라우팅', '인증', 'Rate Limiting', 'SSL 종료', '캐싱'],
 'AWS API Gateway, Kong, NGINX Plus 등이 대표적인 솔루션입니다.',
 'docs/07-architecture-scalability.md'),

-- 난이도 2 (주니어) - 15문제
('architecture', '모놀리스 vs 마이크로서비스', 2, 10, 50,
 '모듈러 모놀리스(Modular Monolith)란 무엇인가요?',
 '모듈러 모놀리스는 모놀리스의 단순함을 유지하면서 내부를 모듈로 분리한 구조입니다. 모듈 간 명확한 경계와 인터페이스를 정의하여 추후 마이크로서비스로의 전환이 용이합니다.',
 ARRAY['모듈러 모놀리스', '모듈 분리', '인터페이스', '마이크로서비스 전환', '경계'],
 '스타트업에서 초기에는 모놀리스로 시작하고 점진적으로 분리하는 전략에 적합합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'API 설계', 2, 10, 50,
 '페이지네이션 구현 방식의 종류와 특징을 설명하세요.',
 'Offset 기반(page=1&limit=20)은 구현이 단순하지만 대용량에서 성능이 저하됩니다. Cursor 기반(after=id123)은 대용량에 효율적이며 데이터 변경에 강합니다. 응답에 총 개수, 다음 페이지 링크를 포함하는 것이 좋습니다.',
 ARRAY['페이지네이션', 'Offset', 'Cursor', '대용량', '성능'],
 'Cursor 기반은 특히 무한 스크롤 UI에서 많이 사용됩니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'API 설계', 2, 10, 50,
 'API 버전 관리 방법을 설명하세요.',
 'URL 경로(/v1/users), 헤더(Accept: application/vnd.api.v1+json), 쿼리 파라미터(?version=1) 방식이 있습니다. URL 방식이 가장 직관적이고 널리 사용됩니다.',
 ARRAY['API 버전', 'URL 경로', '헤더', '쿼리 파라미터', '하위 호환성'],
 '버전 변경 시 하위 호환성을 유지하고 폐기(Deprecation) 정책을 명확히 해야 합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '메시지 큐', 2, 10, 50,
 'Kafka의 Partition과 Consumer Group이란 무엇인가요?',
 'Partition은 Topic을 물리적으로 분할한 단위로, 순서 보장은 Partition 내에서만 됩니다. Consumer Group은 같은 그룹 내 Consumer들이 Partition을 나눠서 처리하며, 그룹 단위로 오프셋을 관리합니다.',
 ARRAY['Kafka', 'Partition', 'Consumer Group', '순서 보장', '오프셋'],
 'Partition 수로 병렬 처리량이 결정되며, 한 Partition은 그룹 내 하나의 Consumer만 처리합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '메시지 큐', 2, 10, 50,
 '메시지 전달 보장 수준의 종류를 설명하세요.',
 'At-most-once는 최대 1회 전달로 유실 가능, At-least-once는 최소 1회 전달로 중복 가능, Exactly-once는 정확히 1회 전달입니다. 비즈니스 요구에 맞게 선택해야 합니다.',
 ARRAY['At-most-once', 'At-least-once', 'Exactly-once', '메시지 전달', '중복'],
 '대부분의 시스템은 At-least-once를 사용하고, Consumer 측에서 멱등성을 보장합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '이벤트 드리븐', 2, 10, 50,
 '좋은 이벤트 설계 원칙을 설명하세요.',
 '이벤트는 과거형으로 명명(OrderCreated)하고, 불변(immutable)해야 하며, 자기 설명적(필요한 정보 포함)이어야 합니다. 버전 관리가 필요하고, 중복 처리를 고려해야 합니다.',
 ARRAY['이벤트 설계', '과거형', '불변', '버전 관리', '중복 처리'],
 '이벤트에 포함할 데이터 양은 "fat events" vs "thin events" 트레이드오프를 고려합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'CQRS', 2, 10, 50,
 'Command 모델과 Query 모델의 특징을 설명하세요.',
 'Command 모델은 도메인 로직을 포함하고 정규화된 스키마로 트랜잭션을 보장합니다. Query 모델은 조회에 최적화된 비정규화 스키마로 복잡한 조인 없이 빠른 응답을 제공합니다.',
 ARRAY['Command', 'Query', '정규화', '비정규화', '도메인 로직'],
 'CQRS는 읽기/쓰기 비율 차이가 크거나 여러 뷰가 필요한 경우에 적합합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '캐싱 아키텍처', 2, 10, 50,
 'HTTP 캐시 제어 헤더의 종류와 역할을 설명하세요.',
 'Cache-Control은 캐시 정책(max-age, no-cache, private)을 지정하고, ETag는 내용 해시로 변경 여부를 확인합니다. Last-Modified는 변경 시간을 나타냅니다. 조건부 요청으로 네트워크를 절약합니다.',
 ARRAY['Cache-Control', 'ETag', 'Last-Modified', '조건부 요청', 'max-age'],
 'If-None-Match, If-Modified-Since 헤더로 조건부 요청을 보낼 수 있습니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '캐싱 아키텍처', 2, 10, 50,
 '로컬 캐시와 분산 캐시의 장단점을 비교하세요.',
 '로컬 캐시는 네트워크 왕복 없이 매우 빠르지만, 인스턴스 간 불일치가 발생하고 메모리 제한이 있습니다. 분산 캐시는 인스턴스 간 공유가 가능하고 대용량 저장이 가능하지만, 네트워크 지연과 직렬화 비용이 있습니다.',
 ARRAY['로컬 캐시', '분산 캐시', '네트워크 지연', '인스턴스 불일치', 'Redis'],
 '일반적으로 L1(로컬) + L2(분산) 멀티 레이어 캐시 전략을 사용합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '스케일링', 2, 10, 50,
 '상태 비저장(Stateless) 서버가 중요한 이유를 설명하세요.',
 '상태 비저장 서버는 어떤 서버로 요청이 가도 동일하게 처리할 수 있어 서버 추가/제거가 자유롭습니다. 세션, 캐시 등 상태는 Redis 같은 외부 저장소로 분리해야 합니다.',
 ARRAY['Stateless', '상태 비저장', '수평 확장', '외부 저장소', '세션'],
 'JWT를 사용하면 클라이언트에서 상태를 관리하여 서버를 stateless로 유지할 수 있습니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '스케일링', 2, 10, 50,
 'Auto Scaling의 동작 원리를 설명하세요.',
 'Auto Scaling은 CPU, 요청 수 등의 메트릭을 모니터링하여 임계값 초과 시 인스턴스를 추가하고, 임계값 미만 시 인스턴스를 제거합니다. 최소/최대 인스턴스 수와 쿨다운 기간을 설정합니다.',
 ARRAY['Auto Scaling', '메트릭', '임계값', '인스턴스', '쿨다운'],
 '급격한 변동을 방지하기 위해 쿨다운 기간을 설정하는 것이 중요합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'CAP 정리', 2, 10, 50,
 'CP 시스템과 AP 시스템의 예시를 들어 설명하세요.',
 'CP 시스템은 ZooKeeper, etcd 같은 분산 코디네이터로, 네트워크 분할 시 쓰기를 거부합니다. AP 시스템은 Cassandra, DynamoDB로, 네트워크 분할에도 응답하지만 노드 간 데이터가 다를 수 있습니다.',
 ARRAY['CP', 'AP', 'ZooKeeper', 'Cassandra', '네트워크 분할'],
 'PACELC 정리는 CAP을 확장하여 정상 상태에서의 Latency vs Consistency도 고려합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '서비스 메시', 2, 10, 50,
 '서비스 메시가 제공하는 주요 기능을 설명하세요.',
 '서비스 메시는 서비스 디스커버리, 로드 밸런싱, 트래픽 제어(라우팅, 분할), 보안(mTLS), 관측성(메트릭, 트레이싱), 장애 처리(재시도, 타임아웃, 서킷 브레이커)를 제공합니다.',
 ARRAY['서비스 디스커버리', 'mTLS', '트래픽 제어', '관측성', '서킷 브레이커'],
 '사이드카 프록시를 통해 애플리케이션 코드 변경 없이 이 기능들을 적용합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '서버리스', 2, 10, 50,
 '콜드 스타트 문제와 완화 방법을 설명하세요.',
 '콜드 스타트는 함수 첫 호출 시 컨테이너 초기화로 인한 지연입니다. Provisioned Concurrency로 미리 웜업하거나, 경량 런타임(Node.js, Go) 사용, 패키지 크기 최소화, 정기적 호출로 웜 상태를 유지합니다.',
 ARRAY['콜드 스타트', 'Provisioned Concurrency', '웜업', '런타임', '지연'],
 'Java, C# 같은 무거운 런타임은 콜드 스타트가 수 초까지 걸릴 수 있습니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'Circuit Breaker', 2, 10, 50,
 'Circuit Breaker의 세 가지 상태를 설명하세요.',
 'Closed는 정상 상태로 요청이 통과합니다. Open은 차단 상태로 즉시 실패를 반환합니다. Half-Open은 일부 요청으로 복구를 확인하는 상태로, 성공하면 Closed로, 실패하면 Open으로 전환됩니다.',
 ARRAY['Circuit Breaker', 'Closed', 'Open', 'Half-Open', '장애 격리'],
 '의존 서비스 장애 시 연쇄 장애를 방지하고 시스템을 보호합니다.',
 'docs/07-architecture-scalability.md'),

-- 난이도 3 (시니어) - 12문제
('architecture', '모놀리스 vs 마이크로서비스', 3, 30, 75,
 'Strangler Fig 패턴이란 무엇인가요?',
 'Strangler Fig 패턴은 모놀리스를 점진적으로 마이크로서비스로 전환하는 패턴입니다. 새 기능은 마이크로서비스로 개발하고, 기존 기능은 하나씩 추출하여 구 시스템을 점차 대체합니다.',
 ARRAY['Strangler Fig', '점진적 전환', '마이크로서비스', '모놀리스', '추출'],
 '무화과 나무가 숙주 나무를 감싸며 자라는 것에서 이름이 유래했습니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'API 설계', 3, 30, 75,
 'GraphQL N+1 문제와 해결 방법을 설명하세요.',
 'GraphQL N+1 문제는 관계형 데이터를 조회할 때 N개의 추가 쿼리가 발생하는 것입니다. DataLoader 패턴을 사용하여 같은 리소스에 대한 요청을 배치로 모아 한 번에 처리합니다.',
 ARRAY['GraphQL', 'N+1', 'DataLoader', '배치', '쿼리 최적화'],
 'DataLoader는 요청을 수집하여 IN 절로 한 번에 조회하는 방식으로 동작합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '메시지 큐', 3, 30, 75,
 'Dead Letter Queue(DLQ)란 무엇이고 어떻게 활용하나요?',
 'DLQ는 처리 실패한 메시지를 저장하는 별도 큐입니다. 재시도 한계 초과, 파싱 오류 등의 메시지를 분리하여 이후 분석하거나 수동으로 처리합니다. 시스템 안정성과 디버깅에 도움이 됩니다.',
 ARRAY['Dead Letter Queue', 'DLQ', '처리 실패', '재시도', '분리'],
 'DLQ의 메시지는 정기적으로 검토하고 처리해야 합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '이벤트 드리븐', 3, 30, 75,
 'Outbox 패턴이란 무엇인가요?',
 'Outbox 패턴은 DB 트랜잭션 내에서 Outbox 테이블에 이벤트를 저장하고, 별도 프로세스가 Outbox를 읽어 메시지 큐에 발행하는 패턴입니다. DB 변경과 이벤트 발행의 원자성을 보장합니다.',
 ARRAY['Outbox 패턴', '트랜잭션', '원자성', '이벤트 발행', 'Debezium'],
 'CDC(Change Data Capture)와 함께 사용하면 폴링 없이 이벤트를 캡처할 수 있습니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'CQRS', 3, 30, 75,
 '이벤트 소싱과 CQRS 조합의 장점을 설명하세요.',
 '이벤트가 Command 모델로 저장되고, 이벤트를 투영(Projection)하여 여러 Query 모델을 생성할 수 있습니다. 읽기 모델 재구축이 용이하고, 시간 여행 쿼리와 완전한 감사 로그가 가능합니다.',
 ARRAY['이벤트 소싱', 'CQRS', 'Projection', '재구축', '감사 로그'],
 '이벤트 스트림을 처음부터 재생하여 읽기 모델을 새로 생성할 수 있습니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '캐싱 아키텍처', 3, 30, 75,
 '캐시 워밍(Cache Warming)이란 무엇이고 언제 필요한가요?',
 '캐시 워밍은 서비스 시작 시 자주 조회되는 데이터를 미리 캐시에 로드하는 것입니다. 콜드 스타트 시 DB 부하 급증을 방지하며, 배포 직전이나 서비스 시작 시 수행합니다.',
 ARRAY['캐시 워밍', '콜드 스타트', '프리로딩', 'DB 부하', '배포'],
 '특히 트래픽이 많은 서비스에서 배포 후 성능 저하를 방지합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '스케일링', 3, 30, 75,
 'Amdahl의 법칙이란 무엇인가요?',
 'Amdahl의 법칙은 병렬화할 수 없는 부분이 전체 성능 향상의 한계를 결정한다는 것입니다. 예를 들어, 10%가 직렬 처리라면 아무리 나머지를 병렬화해도 10배 이상 빨라질 수 없습니다.',
 ARRAY['Amdahl', '병렬화', '성능 한계', '직렬', '확장성'],
 '병목점을 찾아 직렬 부분을 줄이는 것이 성능 향상의 핵심입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'CAP 정리', 3, 30, 75,
 'Saga 패턴이란 무엇이고 언제 사용하나요?',
 'Saga 패턴은 분산 트랜잭션을 로컬 트랜잭션의 시퀀스로 분해하는 패턴입니다. 각 단계 실패 시 보상 트랜잭션을 실행합니다. Choreography(이벤트 체인) 또는 Orchestration(중앙 조정자) 방식이 있습니다.',
 ARRAY['Saga', '분산 트랜잭션', '보상 트랜잭션', 'Choreography', 'Orchestration'],
 '2PC의 문제점(블로킹, 확장성 제한)을 해결하기 위해 마이크로서비스에서 선호됩니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '서비스 메시', 3, 30, 75,
 '컨트롤 플레인과 데이터 플레인의 차이를 설명하세요.',
 '컨트롤 플레인은 정책 관리와 설정 배포를 담당합니다(예: Istio Pilot). 데이터 플레인은 실제 트래픽을 처리하는 프록시입니다(예: Envoy). 컨트롤 플레인이 규칙을 정의하고, 데이터 플레인이 실행합니다.',
 ARRAY['컨트롤 플레인', '데이터 플레인', 'Istio', 'Envoy', '프록시'],
 '이 분리로 확장성과 유연성을 확보합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'DDD', 3, 30, 75,
 'Anti-corruption Layer(ACL)란 무엇인가요?',
 'Anti-corruption Layer는 외부 시스템의 모델이 내부로 침투하지 않도록 변환 계층을 두는 패턴입니다. 레거시 시스템 통합이나 외부 API 통합 시 내부 도메인 모델을 보호합니다.',
 ARRAY['Anti-corruption Layer', 'ACL', '변환 계층', '레거시', '도메인 모델'],
 'Context Mapping 패턴 중 하나로, Bounded Context 간 통합에 사용됩니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'Rate Limiting', 3, 30, 75,
 '분산 환경에서 Rate Limiting을 어떻게 구현하나요?',
 '중앙 저장소(Redis)에서 카운터를 관리하고, 각 인스턴스가 Redis를 조회하여 판단합니다. INCR + EXPIRE로 카운터를 구현하거나, Lua 스크립트로 원자적 연산을 수행합니다. Sliding Window는 Sorted Set을 활용합니다.',
 ARRAY['분산 Rate Limiting', 'Redis', 'INCR', 'Lua 스크립트', 'Sliding Window'],
 '네트워크 지연과 일관성 사이의 트레이드오프를 고려해야 합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'Circuit Breaker', 3, 30, 75,
 'Retry와 Circuit Breaker를 어떻게 조합하나요?',
 'Retry → Circuit Breaker 순서로 적용합니다. 재시도 실패도 Circuit Breaker에 집계되며, Circuit이 Open이면 재시도 없이 즉시 실패합니다. Timeout도 함께 설정하여 전체 대기 시간을 제어합니다.',
 ARRAY['Retry', 'Circuit Breaker', 'Timeout', '조합', '장애 대응'],
 'Resilience4j 같은 라이브러리에서 이런 패턴을 쉽게 조합할 수 있습니다.',
 'docs/07-architecture-scalability.md'),

-- 난이도 4 (리드/CTO) - 8문제
('architecture', '모놀리스 vs 마이크로서비스', 4, 50, 100,
 'Conway의 법칙과 아키텍처의 관계를 설명하세요.',
 'Conway의 법칙은 "시스템 구조는 조직의 커뮤니케이션 구조를 반영한다"는 것입니다. 마이크로서비스 성공을 위해서는 팀을 서비스 단위로 조직하고 자율성을 부여해야 합니다. 조직 구조와 아키텍처를 함께 설계해야 합니다.',
 ARRAY['Conway 법칙', '조직 구조', '커뮤니케이션', '팀 자율성', '아키텍처'],
 'Inverse Conway Maneuver는 원하는 아키텍처에 맞게 조직을 설계하는 전략입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'API 설계', 4, 50, 100,
 'BFF(Backend For Frontend) 패턴을 설명하세요.',
 'BFF는 프론트엔드 유형(Web, Mobile, IoT)별로 전용 API 서버를 두는 패턴입니다. 각 클라이언트에 최적화된 데이터 형태와 API를 제공하며, API Gateway와 결합하여 사용합니다.',
 ARRAY['BFF', 'Backend For Frontend', '클라이언트 최적화', 'API Gateway', '프론트엔드'],
 '다양한 클라이언트가 있고 요구사항이 다를 때 효과적입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '메시지 큐', 4, 50, 100,
 '대규모 Kafka 클러스터 규모 산정 기준을 설명하세요.',
 '처리량(메시지/초), 데이터 보존 기간, 복제 팩터, 컨슈머 지연 허용치를 고려합니다. Broker 수 = (처리량 × 복제 × 보존기간) / (디스크 용량 × 처리 능력)으로 산정합니다.',
 ARRAY['Kafka', '클러스터 규모', '처리량', '복제 팩터', '용량 계획'],
 'Partition 수는 Consumer 병렬성과 순서 보장 요구사항을 고려하여 결정합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'CQRS', 4, 50, 100,
 'CQRS 안티패턴에는 어떤 것들이 있나요?',
 '모든 기능에 CQRS를 적용하는 것, 동기 이벤트로 결합도를 증가시키는 것, 거대한 단일 읽기 모델을 만드는 것, Projection 로직에 도메인 로직을 포함시키는 것 등이 안티패턴입니다.',
 ARRAY['CQRS 안티패턴', '과도한 적용', '동기 이벤트', '결합도', 'Projection'],
 '단순한 CRUD 애플리케이션에 CQRS는 과도한 설계입니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '캐싱 아키텍처', 4, 50, 100,
 '글로벌 서비스에서 캐시 전략을 어떻게 설계하나요?',
 '리전별 분산 캐시 클러스터를 운영하고, CDN 엣지에서 캐싱합니다. 리전 간 복제 또는 독립 운영을 선택하며, 캐시 미스 시 가장 가까운 리전에서 조회합니다. 일관성과 지연시간의 트레이드오프를 고려합니다.',
 ARRAY['글로벌 캐시', '리전별', 'CDN', '복제', '지연시간'],
 '캐시 용량 산정은 Working Set 크기와 히트율 목표를 기반으로 합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', '스케일링', 4, 50, 100,
 '용량 계획(Capacity Planning)은 어떻게 하나요?',
 '현재 트래픽을 분석하고 성장률을 예측합니다. 피크 트래픽을 대비하고 버퍼를 확보합니다. 정기적인 부하 테스트로 현재 용량을 파악하고, 비즈니스 팀과 협업하여 이벤트와 성장 전망을 공유받습니다.',
 ARRAY['용량 계획', '트래픽 분석', '성장률', '부하 테스트', '피크 대비'],
 'Reserved Instance로 기본 용량을 확보하고 Spot으로 피크를 처리하는 비용 최적화도 고려합니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'DDD', 4, 50, 100,
 '이벤트 스토밍(Event Storming)이란 무엇인가요?',
 '이벤트 스토밍은 도메인 전문가와 개발자가 함께 도메인 이벤트를 포스트잇으로 나열하며 도메인을 탐색하는 워크샵입니다. Bounded Context 도출, 도메인 모델 발견, 팀 공유에 효과적입니다.',
 ARRAY['이벤트 스토밍', '워크샵', 'Bounded Context', '도메인 전문가', '포스트잇'],
 'Alberto Brandolini가 고안한 기법으로, DDD 프로젝트 초기에 많이 사용됩니다.',
 'docs/07-architecture-scalability.md'),

('architecture', 'Rate Limiting', 4, 50, 100,
 'API Rate Limit 정책 설계 시 고려할 점을 설명하세요.',
 '사용자 티어별 차등 제한, 엔드포인트별 비용 차이, 버스트 허용량, 초과 시 대응(차단 vs 과금)을 고려합니다. 문서화하고 클라이언트에게 명확한 피드백(헤더, 에러 메시지)을 제공합니다.',
 ARRAY['Rate Limit 정책', '티어별', '버스트', '과금', '문서화'],
 'API 사용량 기반 과금 모델의 기초가 되며, 비즈니스 목표와 연계해야 합니다.',
 'docs/07-architecture-scalability.md'),

-- =====================================================
-- INCIDENT (장애대응/SRE) - 50문제
-- =====================================================

-- 난이도 1 (입문) - 15문제
('incident', 'SRE 원칙', 1, 1, 25,
 'SRE와 DevOps의 차이점은 무엇인가요?',
 'DevOps는 문화와 철학 중심의 광범위한 움직임이고, SRE는 그 철학을 구체적인 실천 방법과 메트릭으로 구현한 것입니다. SRE는 "DevOps를 구현하는 하나의 방법"으로 볼 수 있습니다.',
 ARRAY['SRE', 'DevOps', '문화', '메트릭', '구현'],
 'SRE는 Google에서 시작된 운영 방법론으로, 신뢰성을 측정 가능하게 만듭니다.',
 'docs/08-incident-sre.md'),

('incident', 'SRE 원칙', 1, 1, 25,
 'SRE의 핵심 목표는 무엇인가요?',
 'SRE의 핵심 목표는 시스템의 신뢰성을 측정 가능하게 만들고, 자동화를 통해 수동 운영 작업(Toil)을 줄이며, 개발 속도와 안정성 사이의 균형을 맞추는 것입니다.',
 ARRAY['SRE', '신뢰성', '자동화', 'Toil', '균형'],
 '"운영을 소프트웨어 문제로 다룬다"는 철학이 핵심입니다.',
 'docs/08-incident-sre.md'),

('incident', '온콜 운영', 1, 1, 25,
 '온콜이 필요한 이유는 무엇인가요?',
 '24/7 서비스는 언제든 장애가 발생할 수 있고, 빠른 대응이 비즈니스 영향과 사용자 경험에 직접적인 영향을 미칩니다. 업무 시간 외에도 즉각 대응할 수 있도록 교대로 대기하는 체계가 필요합니다.',
 ARRAY['온콜', '24/7', '장애 대응', '교대', '대기'],
 'PagerDuty, Opsgenie 등의 알림 시스템을 사용하여 온콜을 운영합니다.',
 'docs/08-incident-sre.md'),

('incident', '온콜 운영', 1, 1, 25,
 '온콜 담당자의 기본 책임은 무엇인가요?',
 '온콜 담당자는 알림 수신 및 응답, 초기 진단 및 완화, 에스컬레이션 판단, 장애 타임라인 기록, 핸드오프 수행 등의 책임이 있습니다.',
 ARRAY['온콜', '알림 응답', '초기 진단', '에스컬레이션', '타임라인'],
 'Primary가 응답하지 않으면 Secondary에게 자동 에스컬레이션됩니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 등급', 1, 1, 25,
 'SEV1과 SEV2의 차이점을 설명하세요.',
 'SEV1(Critical)은 전체 또는 대다수 사용자에게 영향을 미치고 핵심 비즈니스 기능이 완전히 중단된 경우입니다. SEV2(High)는 상당수 사용자에게 영향이 있지만 우회가 가능하거나, 일부 핵심 기능만 영향받는 경우입니다.',
 ARRAY['SEV1', 'SEV2', '장애 등급', '영향 범위', 'Critical'],
 '장애 등급은 적절한 대응 수준과 리소스를 할당하기 위해 필요합니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 대응', 1, 1, 25,
 '장애 대응의 5단계를 설명하세요.',
 '장애 대응은 감지(Detect) → 분류(Triage) → 완화(Mitigate) → 복구(Resolve) → 분석(Review) 단계로 구성됩니다. 감지는 장애 인지, 분류는 등급 결정, 완화는 빠른 조치, 복구는 근본 해결, 분석은 재발 방지입니다.',
 ARRAY['감지', '분류', '완화', '복구', '분석'],
 '완화는 응급 조치로 일단 서비스를 정상화하고, 복구는 근본 원인을 해결합니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 대응', 1, 1, 25,
 '완화(Mitigate)와 복구(Resolve)의 차이는 무엇인가요?',
 '완화는 롤백, 트래픽 우회 등 응급 조치로 일단 서비스를 정상화하는 것입니다. 복구는 근본 원인을 해결하여 완전히 정상화하는 것입니다. 완화를 먼저 하고, 복구는 나중에 해도 됩니다.',
 ARRAY['완화', '복구', '응급 조치', '근본 원인', '롤백'],
 '장애 상황에서는 완화로 빠르게 서비스를 정상화하는 것이 우선입니다.',
 'docs/08-incident-sre.md'),

('incident', 'Incident Commander', 1, 1, 25,
 'Incident Commander(IC)가 필요한 이유는 무엇인가요?',
 '여러 사람이 개별적으로 움직이면 혼란과 중복 작업이 발생합니다. 한 명이 전체 상황을 파악하고 조율해야 효율적인 장애 대응이 가능합니다. IC는 조율과 의사결정에 집중합니다.',
 ARRAY['Incident Commander', 'IC', '조율', '의사결정', '중앙 조율자'],
 'IC는 직접 디버깅하지 않고 전체 상황을 파악하는 역할입니다.',
 'docs/08-incident-sre.md'),

('incident', '포스트모텀', 1, 1, 25,
 'Blameless 포스트모텀이란 무엇인가요?',
 'Blameless 포스트모텀은 "누가 잘못했나"가 아니라 "시스템이 왜 이런 실수를 허용했나"에 집중하는 장애 분석입니다. 개인을 비난하지 않고 시스템 개선에 집중하여 솔직한 원인 분석과 학습이 가능합니다.',
 ARRAY['Blameless', '포스트모텀', '시스템 개선', '비난 없음', '학습'],
 '사람은 실수하므로 시스템이 실수를 방지하고 감지해야 합니다.',
 'docs/08-incident-sre.md'),

('incident', 'SLI/SLO/SLA', 1, 1, 25,
 'SLI, SLO, SLA의 차이점을 설명하세요.',
 'SLI(Service Level Indicator)는 서비스 품질 측정 지표(가용성, 지연시간 등)입니다. SLO(Service Level Objective)는 목표 수치(99.9% 가용성)입니다. SLA(Service Level Agreement)는 고객과의 계약으로 위반 시 보상이 포함됩니다.',
 ARRAY['SLI', 'SLO', 'SLA', '측정 지표', '목표', '계약'],
 'SLI를 정의하고, SLO를 설정하고, 필요시 SLA로 계약을 맺습니다.',
 'docs/08-incident-sre.md'),

('incident', 'SLI/SLO/SLA', 1, 1, 25,
 '99.9%와 99.99% 가용성의 다운타임 차이는 얼마인가요?',
 '99.9%(Three 9s)는 연간 약 8.76시간의 다운타임이 허용됩니다. 99.99%(Four 9s)는 연간 약 52.56분입니다. 9 하나를 추가하는 것은 10배 더 어렵습니다.',
 ARRAY['가용성', '99.9%', '99.99%', '다운타임', 'Three 9s'],
 '100% SLO를 목표로 하면 모든 변경이 위험해져 혁신이 멈춥니다.',
 'docs/08-incident-sre.md'),

('incident', '에러 버짓', 1, 1, 25,
 '에러 버짓이란 무엇인가요?',
 '에러 버짓은 SLO가 허용하는 장애/에러의 양을 수치화한 것입니다. 100% - SLO = 에러 버짓입니다. 예를 들어, 99.9% SLO는 0.1% 에러 버짓, 즉 월 43.2분의 다운타임을 허용합니다.',
 ARRAY['에러 버짓', 'SLO', '다운타임', '허용량', '계산'],
 '에러 버짓은 개발 속도와 안정성 사이의 객관적 균형점입니다.',
 'docs/08-incident-sre.md'),

('incident', 'Chaos Engineering', 1, 1, 25,
 'Chaos Engineering의 목적은 무엇인가요?',
 'Chaos Engineering은 실제 장애 전에 시스템의 약점을 발견하고, 시스템 회복력을 검증하며, 운영팀의 대응 연습을 하고, 시스템에 대한 가정을 검증하는 것이 목적입니다.',
 ARRAY['Chaos Engineering', '장애 주입', '회복력', '약점 발견', '검증'],
 'Netflix Chaos Monkey가 대표적인 도구입니다.',
 'docs/08-incident-sre.md'),

('incident', '런북', 1, 1, 25,
 '런북이 필요한 이유는 무엇인가요?',
 '런북은 장애 시 당황하지 않고 체계적으로 대응할 수 있게 하고, 경험이 적은 담당자도 대응 가능하게 하며, 일관된 대응 품질을 보장합니다.',
 ARRAY['런북', '장애 대응', '절차서', '일관성', '체계적'],
 '좋은 런북은 명확한 단계, 복붙 가능한 명령어, 에스컬레이션 경로를 포함합니다.',
 'docs/08-incident-sre.md'),

('incident', '재해 복구', 1, 1, 25,
 'RTO와 RPO의 차이는 무엇인가요?',
 'RTO(Recovery Time Objective)는 "얼마나 빨리 복구해야 하는가"로 복구 목표 시간입니다. RPO(Recovery Point Objective)는 "얼마나 많은 데이터 손실을 감수할 수 있는가"로 데이터 손실 허용 시점입니다.',
 ARRAY['RTO', 'RPO', '복구 시간', '데이터 손실', '재해 복구'],
 'RTO 1시간, RPO 15분이면 1시간 내 복구하고 최대 15분치 데이터 손실을 허용합니다.',
 'docs/08-incident-sre.md'),

-- 난이도 2 (주니어) - 15문제
('incident', 'SRE 원칙', 2, 10, 50,
 '50% 규칙이 중요한 이유는 무엇인가요?',
 'SRE 시간의 50% 이상을 엔지니어링 작업에 투자해야 합니다. Toil이 50%를 넘으면 자동화할 시간이 없어져 악순환에 빠집니다. 엔지니어링 시간을 확보해야 장기적으로 운영 부담이 줄어듭니다.',
 ARRAY['50% 규칙', 'Toil', '엔지니어링', '자동화', '악순환'],
 'SRE는 운영을 소프트웨어 문제로 다루어 자동화로 해결합니다.',
 'docs/08-incident-sre.md'),

('incident', '온콜 운영', 2, 10, 50,
 '효과적인 온콜 핸드오프 방법을 설명하세요.',
 '현재 진행 중인 이슈 상태를 문서화하고, 주의해야 할 알림이나 트렌드를 공유합니다. 예정된 변경사항을 알리고, 구두나 비동기로 직접 소통하여 인계합니다.',
 ARRAY['핸드오프', '문서화', '이슈 상태', '트렌드', '인계'],
 '장시간 장애 시 IC 인수인계도 마찬가지로 현재 상황을 명확히 전달해야 합니다.',
 'docs/08-incident-sre.md'),

('incident', '온콜 운영', 2, 10, 50,
 '알림 피로(Alert Fatigue)를 줄이는 방법을 설명하세요.',
 '불필요한 알림을 제거하고, 알림을 그룹화하며, 임계값을 튜닝합니다. 자동 복구를 구현하고, 정보성 알림과 긴급 알림을 분리합니다.',
 ARRAY['알림 피로', 'Alert Fatigue', '알림 튜닝', '자동 복구', '그룹화'],
 '알림이 너무 많으면 중요한 알림을 놓칠 수 있습니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 등급', 2, 10, 50,
 'SEV 등급별 일반적인 대응 SLA를 설명하세요.',
 'SEV1은 15분 내 응답, 4시간 내 완화가 목표입니다. SEV2는 30분 내 응답, 8시간 내 완화입니다. SEV3는 4시간 내 응답, 24시간 내 해결입니다. SEV4는 24시간 내 응답입니다.',
 ARRAY['SEV', '응답 SLA', '완화 시간', '해결 시간', '대응'],
 '장애 등급을 잘못 판단했으면 언제든 조정할 수 있으며, 과소평가보다 과대평가가 낫습니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 대응', 2, 10, 50,
 '장애 타임라인에 기록해야 할 내용은 무엇인가요?',
 '장애 인지 시점, 주요 발견사항, 시도한 조치와 결과, 에스컬레이션, 완화/복구 시점, 의사결정과 근거를 타임스탬프와 함께 기록합니다.',
 ARRAY['타임라인', '기록', '발견사항', '조치', '의사결정'],
 '타임라인은 포스트모텀의 기초 자료가 됩니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 대응', 2, 10, 50,
 '워룸(War Room)의 기본 규칙을 설명하세요.',
 '역할을 명확히 하고(IC, 커뮤니케이터, 기록자), 관련 없는 대화를 금지합니다. 행동 전 의도를 공유하고, 발견 즉시 공유하며, 정기적으로 상태를 요약합니다.',
 ARRAY['워룸', 'War Room', '역할', 'IC', '커뮤니케이션'],
 '워룸은 장애 대응을 위한 집중 커뮤니케이션 채널입니다.',
 'docs/08-incident-sre.md'),

('incident', 'Incident Commander', 2, 10, 50,
 'Communications Lead와 Scribe의 역할을 설명하세요.',
 'Communications Lead는 외부 커뮤니케이션을 담당하여 상태 페이지 업데이트, 고객 알림, 경영진 보고를 합니다. Scribe(기록자)는 실시간으로 타임라인을 기록하고 주요 발견과 조치를 문서화합니다.',
 ARRAY['Communications Lead', 'Scribe', '기록자', '상태 페이지', '타임라인'],
 'IC가 기술적 조율에 집중할 수 있도록 역할을 분담합니다.',
 'docs/08-incident-sre.md'),

('incident', '포스트모텀', 2, 10, 50,
 '5 Whys 기법은 어떻게 적용하나요?',
 '"왜 이런 일이 발생했나?"를 반복하여 표면적 원인에서 근본 원인까지 도달합니다. 반드시 5회일 필요는 없고, 여러 분기로 나뉠 수 있습니다.',
 ARRAY['5 Whys', '근본 원인', '반복', '분석', '원인 도출'],
 '예: 서버 다운 → 메모리 부족 → 메모리 누수 → 코드 버그 → 테스트 부재',
 'docs/08-incident-sre.md'),

('incident', '포스트모텀', 2, 10, 50,
 '좋은 액션 아이템의 조건을 설명하세요.',
 '좋은 액션 아이템은 구체적(무엇을), 측정 가능하고, 담당자가 지정되어 있으며, 기한이 설정되어 있고, 추적 가능해야 합니다. "모니터링 개선"이 아니라 "API 응답시간 알림 임계값 500ms로 조정 by 3/15"처럼 작성합니다.',
 ARRAY['액션 아이템', '구체적', '측정 가능', '담당자', '기한'],
 '액션 아이템 완료율을 정기적으로 추적해야 합니다.',
 'docs/08-incident-sre.md'),

('incident', 'SLI/SLO/SLA', 2, 10, 50,
 '지연시간 SLI에서 평균 대신 백분위수를 사용하는 이유를 설명하세요.',
 '평균은 이상치에 왜곡되기 쉽습니다. p50(중앙값), p90, p99를 사용하면 사용자 경험을 더 정확하게 반영합니다. 특히 p99는 "최악의 케이스" 사용자 경험을 나타냅니다.',
 ARRAY['지연시간', '백분위수', 'p99', 'p50', '평균'],
 '대부분의 사용자가 좋은 경험을 해도 일부가 나쁘면 SLO를 달성하지 못할 수 있습니다.',
 'docs/08-incident-sre.md'),

('incident', '에러 버짓', 2, 10, 50,
 '에러 버짓 계산 예시를 설명하세요.',
 '월간 100만 요청에 SLO 99.9%면 에러 버짓은 1000 실패 요청입니다. 현재까지 300 실패라면 30% 소진, 70% 잔여입니다. 버짓을 빠르게 소진하고 있다면 신규 배포를 중단하고 안정화 작업을 우선합니다.',
 ARRAY['에러 버짓', '계산', '실패 요청', '소진율', '안정화'],
 '에러 버짓은 개발팀과 운영팀의 객관적 협력 기준입니다.',
 'docs/08-incident-sre.md'),

('incident', 'Chaos Engineering', 2, 10, 50,
 'Chaos 실험 전 필요한 준비를 설명하세요.',
 'Steady State(정상 메트릭)를 정의하고, 롤백 계획을 수립합니다. 영향 범위를 제한하고, 모니터링을 준비하며, 이해관계자에게 알립니다.',
 ARRAY['Chaos Engineering', 'Steady State', '롤백', '영향 범위', '모니터링'],
 'Blast Radius를 제한하여 일부 인스턴스/사용자만 대상으로 합니다.',
 'docs/08-incident-sre.md'),

('incident', '카나리 분석', 2, 10, 50,
 '카나리 트래픽 비율과 분석 기간은 어떻게 결정하나요?',
 '트래픽 비율은 보통 1-5%로 시작하여 통계적 유의성을 확보하면서 문제 시 영향을 최소화합니다. 분석 기간은 최소 15-30분, 이상적으로 1-2시간이며, 트래픽 패턴과 지연 문제(메모리 누수 등)를 고려합니다.',
 ARRAY['카나리', '트래픽 비율', '분석 기간', '통계적 유의성', '영향 최소화'],
 '베이스라인과 같은 시점에 비교해야 정확한 분석이 가능합니다.',
 'docs/08-incident-sre.md'),

('incident', '런북', 2, 10, 50,
 '런북에 포함되어야 할 필수 항목을 설명하세요.',
 '알림 의미, 영향 범위, 진단 명령어/방법, 해결 절차, 확인 방법, 에스컬레이션 기준 및 연락처, 관련 문서 링크가 포함되어야 합니다.',
 ARRAY['런북', '진단', '해결 절차', '에스컬레이션', '알림'],
 '의사결정 트리로 상황별 분기 처리를 시각화하면 좋습니다.',
 'docs/08-incident-sre.md'),

('incident', '재해 복구', 2, 10, 50,
 'DR 전략별 비용과 RTO 관계를 설명하세요.',
 'Backup/Restore < Pilot Light < Warm Standby < Multi-Site 순으로 비용이 증가하고 RTO가 감소합니다. Pilot Light는 핵심 시스템만 최소 규모로 DR 환경에서 실행하여 비용과 RTO의 균형을 맞춥니다.',
 ARRAY['DR 전략', 'Backup', 'Pilot Light', 'Warm Standby', 'Multi-Site'],
 '비즈니스 요구와 비용을 고려하여 적절한 전략을 선택합니다.',
 'docs/08-incident-sre.md'),

-- 난이도 3 (시니어) - 12문제
('incident', 'SRE 원칙', 3, 30, 75,
 'Production Readiness Review에 포함되어야 할 항목을 설명하세요.',
 '아키텍처 검토, 장애 시나리오, 모니터링/알림, SLO 정의, 온콜 런북, 의존성 분석, 용량 계획, 보안 검토, 데이터 백업/복구 계획이 포함되어야 합니다.',
 ARRAY['Production Readiness', '아키텍처', '모니터링', 'SLO', '런북'],
 'SRE가 서비스를 지원하기 전에 이 검토를 통해 준비 상태를 확인합니다.',
 'docs/08-incident-sre.md'),

('incident', '온콜 운영', 3, 30, 75,
 '건강한 온콜 로테이션 설계 원칙을 설명하세요.',
 '최소 8명 이상의 풀로 주 1회 이하 온콜을 유지하고, 연속 온콜을 금지합니다. 공휴일을 균등하게 분배하고, 긴급 호출 횟수를 모니터링하며, 온콜 부담을 측정하고 조정합니다.',
 ARRAY['온콜 로테이션', '8명', '공휴일', '부담 측정', '균등 분배'],
 '온콜 효과성은 알림 횟수, MTTR, False Positive 비율 등으로 측정합니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 등급', 3, 30, 75,
 '비즈니스 임팩트를 정량화하는 방법을 설명하세요.',
 '분당/시간당 매출 손실, 영향받는 고객 수, SLA 위반 페널티, 규정 위반 벌금, 복구 비용, 평판 손상을 추정하여 정량화합니다.',
 ARRAY['비즈니스 임팩트', '매출 손실', 'SLA 위반', '고객 수', '정량화'],
 '동시에 여러 장애가 발생하면 가장 높은 SEV에 집중합니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 대응', 3, 30, 75,
 '장애 종료 조건은 무엇인가요?',
 '고객 영향이 제거되고, 메트릭이 정상화되며, 근본 원인이 파악(해결은 아니어도 됨)되고, 추가 조치가 불필요할 때 장애를 종료합니다. 모니터링 강화 후 종료합니다.',
 ARRAY['장애 종료', '고객 영향', '메트릭 정상화', '근본 원인', '모니터링'],
 '복구 시간 예측이 어려우면 "조사 중"으로 시작하고 원인 파악 시 업데이트합니다.',
 'docs/08-incident-sre.md'),

('incident', 'Incident Commander', 3, 30, 75,
 'IC가 기술적으로 깊이 관여하면 안 되는 이유를 설명하세요.',
 'IC가 특정 문제에 몰입하면 전체 상황 파악이 어려워집니다. IC는 헬리콥터 뷰를 유지해야 하며, 기술적 문제 해결은 Subject Matter Expert에게 맡기고 조율과 의사결정에 집중해야 합니다.',
 ARRAY['IC', '헬리콥터 뷰', '조율', '의사결정', '전체 상황'],
 '결정하기 어려운 상황에서도 가용한 정보로 최선의 판단을 하고, 잘못되면 즉시 수정합니다.',
 'docs/08-incident-sre.md'),

('incident', '포스트모텀', 3, 30, 75,
 '포스트모텀 액션 아이템 완료율을 높이는 방법을 설명하세요.',
 '정기적 추적 미팅을 하고, 백로그에 통합하며, 우선순위를 지정합니다. 경영진 리뷰를 하고, 완료율을 메트릭화하며, 미완료 시 원인을 분석합니다.',
 ARRAY['액션 아이템', '완료율', '추적', '백로그', '메트릭'],
 '포스트모텀의 가치는 액션 아이템 이행에서 나옵니다.',
 'docs/08-incident-sre.md'),

('incident', 'SLI/SLO/SLA', 3, 30, 75,
 '에러 버짓 소진율(Burn Rate) 기반 알림이란 무엇인가요?',
 '"현재 속도로 에러가 발생하면 SLO를 언제 위반하는가"를 계산합니다. 예를 들어, 1시간에 30일 버짓의 2%를 소진하면 긴급 알림, 6시간에 5%면 경고 알림을 발생시킵니다.',
 ARRAY['Burn Rate', '소진율', 'SLO', '알림', '경고'],
 'Multi-window, Multi-burn-rate 알림으로 더 정교한 전략을 구현합니다.',
 'docs/08-incident-sre.md'),

('incident', '에러 버짓', 3, 30, 75,
 '에러 버짓 정책의 예시를 설명하세요.',
 '버짓 50% 소진 시 신규 기능 배포 검토를 강화합니다. 75% 소진 시 신규 배포를 중단하고 안정화에 집중합니다. 100% 소진 시 기능 동결하고 버짓 복구까지 기다립니다.',
 ARRAY['에러 버짓 정책', '배포 중단', '안정화', '기능 동결', '버짓 복구'],
 '에러 버짓 정책은 개발팀과 함께 수립해야 합니다.',
 'docs/08-incident-sre.md'),

('incident', 'Chaos Engineering', 3, 30, 75,
 'GameDay 진행 방법을 설명하세요.',
 '1) 시나리오 설계 2) 역할 배정(공격팀/방어팀) 3) 모니터링 준비 4) 장애 주입 5) 대응 관찰 6) 디브리핑 7) 개선점 도출 순서로 진행합니다.',
 ARRAY['GameDay', '시나리오', '공격팀', '방어팀', '디브리핑'],
 '과거 장애 재현, 의존성 장애, 급격한 트래픽 증가 등의 시나리오를 실험합니다.',
 'docs/08-incident-sre.md'),

('incident', '카나리 분석', 3, 30, 75,
 '카나리 분석이 Pass했지만 문제가 발생하면 어떻게 해야 하나요?',
 '메트릭 커버리지가 부족하거나 SLI에 포함되지 않은 문제일 수 있습니다. 분석 기간이 부족했을 수도 있습니다. 포스트모텀에서 분석하고 메트릭과 분석 방법을 개선합니다.',
 ARRAY['카나리', 'False Negative', '메트릭 커버리지', 'SLI', '개선'],
 '비즈니스 메트릭(전환율 등)도 카나리 분석에 포함하는 것이 좋습니다.',
 'docs/08-incident-sre.md'),

('incident', '런북', 3, 30, 75,
 '런북을 자동화하는 방법을 설명하세요.',
 '진단 스크립트를 작성하고, 원클릭 복구 도구를 만듭니다. PagerDuty, Rundeck 등 런북 자동화 플랫폼을 사용하고, ChatOps와 통합합니다.',
 ARRAY['런북 자동화', '진단 스크립트', 'Rundeck', 'ChatOps', '원클릭 복구'],
 '런북이 outdated되지 않도록 포스트모텀 액션에 런북 업데이트를 포함합니다.',
 'docs/08-incident-sre.md'),

('incident', '재해 복구', 3, 30, 75,
 '동기 vs 비동기 데이터 복제의 트레이드오프를 설명하세요.',
 '동기 복제는 RPO=0으로 데이터 손실이 없지만 지연시간이 증가합니다. 비동기 복제는 성능이 좋지만 복제 지연만큼 데이터 손실이 가능합니다. 비즈니스 요구에 맞게 선택합니다.',
 ARRAY['동기 복제', '비동기 복제', 'RPO', '지연시간', '데이터 손실'],
 '페일오버 테스트는 최소 연 1회, 이상적으로 분기 1회 수행합니다.',
 'docs/08-incident-sre.md'),

-- 난이도 4 (리드/CTO) - 8문제
('incident', 'SRE 원칙', 4, 50, 100,
 '조직에 SRE 문화를 도입하는 전략을 설명하세요.',
 '1) 파일럿 팀에서 성공 사례를 만들고 2) SLO 기반 대화 문화를 조성합니다. 3) 포스트모텀 공유를 장려하고 4) Toil을 측정하고 가시화합니다. 5) 경영진 지원을 확보하고 6) 교육 프로그램을 운영합니다.',
 ARRAY['SRE 문화', '도입 전략', 'SLO', '포스트모텀', 'Toil'],
 'SRE 투자 ROI는 장애 비용 감소, MTTR 개선, 개발자 생산성 향상으로 측정합니다.',
 'docs/08-incident-sre.md'),

('incident', '온콜 운영', 4, 50, 100,
 'Follow-the-Sun 모델의 장단점을 설명하세요.',
 '장점은 야간 온콜이 없어 삶의 질이 향상됩니다. 단점은 팀 간 조율이 복잡하고, 지식이 분산되며, 핸드오프 오버헤드가 있습니다. 최소 3개 이상 시간대에 팀이 필요합니다.',
 ARRAY['Follow-the-Sun', '글로벌', '야간 온콜', '핸드오프', '시간대'],
 '완전한 무온콜은 어렵지만 온콜 부담을 최소화하는 것은 가능합니다.',
 'docs/08-incident-sre.md'),

('incident', '장애 대응', 4, 50, 100,
 '장애 대응 성숙도를 높이는 방법을 설명하세요.',
 '1) 문서화된 프로세스 2) 정기 훈련 3) 포스트모텀 문화 4) 자동화된 도구 5) 명확한 역할 정의 6) 경험 공유 세션을 통해 성숙도를 높입니다.',
 ARRAY['장애 대응 성숙도', '프로세스', '훈련', '자동화', '역할 정의'],
 '비상 대응 훈련을 정기적으로 수행하여 실전 대응 역량을 향상시킵니다.',
 'docs/08-incident-sre.md'),

('incident', '포스트모텀', 4, 50, 100,
 '포스트모텀 문화가 정착되지 않는 원인과 해결 방법을 설명하세요.',
 '원인은 비난 문화, 시간 부족, 경영진 무관심, 액션 미이행, 형식적 진행입니다. 해결을 위해 리더십의 명시적 지지와 모범이 필요하고, 학습을 극대화하기 위해 전사 공유 세션과 신규 입사자 온보딩에 활용합니다.',
 ARRAY['포스트모텀 문화', '비난 문화', '리더십', '학습', '공유'],
 '포스트모텀 문화는 심리적 안전감과 학습 조직의 기반입니다.',
 'docs/08-incident-sre.md'),

('incident', 'SLI/SLO/SLA', 4, 50, 100,
 'SLO를 비즈니스 목표와 연계하는 방법을 설명하세요.',
 '가용성 99.9%에서 99.99%로 올리면 매출 X% 증가, 고객 이탈 Y% 감소 등을 정량화합니다. 신뢰성 투자의 ROI를 측정하여 비즈니스 의사결정에 반영합니다.',
 ARRAY['SLO', '비즈니스 목표', 'ROI', '정량화', '투자'],
 'SLA 협상 시에는 SLO보다 낮은 SLA를 설정하여 버퍼를 확보합니다.',
 'docs/08-incident-sre.md'),

('incident', '에러 버짓', 4, 50, 100,
 '에러 버짓 문화의 조직적 이점을 설명하세요.',
 '개발팀과 운영팀 간 갈등을 해소하고, 객관적 의사결정 기준을 제공합니다. 신뢰성 투자를 정당화하고, 리스크를 정량화합니다. 버짓 내에서 빠른 개발, 소진 시 안정화 우선이라는 명확한 규칙을 제공합니다.',
 ARRAY['에러 버짓 문화', '갈등 해소', '의사결정', '리스크 정량화', '협력'],
 '비즈니스 이벤트(블랙프라이데이 등) 전에는 버짓을 충분히 확보해야 합니다.',
 'docs/08-incident-sre.md'),

('incident', 'Chaos Engineering', 4, 50, 100,
 '조직에 Chaos Engineering을 도입하는 전략을 설명하세요.',
 '1) 작은 규모로 시작 2) 성공 사례 공유 3) 점진적 확대 4) 도구 표준화 5) 교육 6) 경영진 지지 확보 순서로 도입합니다. 규제 환경에서는 규제 기관 사전 협의, 문서화된 절차, 비프로덕션 환경 우선이 필요합니다.',
 ARRAY['Chaos Engineering 도입', '점진적', '경영진 지지', '규제 환경', '표준화'],
 'Chaos Engineering 성숙도: Ad-hoc → 정기적 → 프로덕션 → CI/CD 통합 → 지속적',
 'docs/08-incident-sre.md'),

('incident', '재해 복구', 4, 50, 100,
 'DR 투자 비용을 정당화하는 방법을 설명하세요.',
 '장애 시 비용(시간당 손실 × 예상 다운타임), 규정 위반 페널티, 평판 손상, 고객 이탈 비용을 DR 구축/운영 비용과 비교합니다. 금융/의료 등 규제 산업에서는 명시적 RTO/RPO와 정기 테스트가 필수입니다.',
 ARRAY['DR 비용', '정당화', '장애 비용', '규정 준수', 'ROI'],
 '글로벌 아키텍처 설계 시 데이터 주권 규정(GDPR 등)도 고려해야 합니다.',
 'docs/08-incident-sre.md');

-- ============================================
-- 2. Monsters + Achievements + Shop Items
-- ============================================

-- =============================================
-- 게임 데이터 시드 파일
-- =============================================
-- monsters: 40개
-- achievements: 25개
-- shop_items: 32개
-- =============================================

-- =============================================
-- MONSTERS (40개)
-- IT 테마 몬스터, 레벨 1-100 커버
-- HP 공식: 기본 100 + (레벨 * 99) 범위
-- =============================================

INSERT INTO monsters (name, level_min, level_max, hp, image_url, description, category) VALUES
-- 레벨 1-5 (입문급 - 슬라임류)
('버그 슬라임', 1, 5, 100, NULL, '코드 속에서 태어난 가장 기초적인 몬스터. 초록빛 젤리 몸에 세미콜론이 떠다닌다.', NULL),
('널포인터 슬라임', 1, 5, 120, NULL, '참조할 곳을 잃어버린 슬픈 슬라임. 투명한 몸이 특징이다.', NULL),

-- 레벨 6-10 (입문급 - 고블린류)
('타이포 고블린', 6, 10, 300, NULL, '오타를 먹고 자라는 작은 고블린. 키보드 위에 자주 출몰한다.', NULL),
('신택스에러 고블린', 6, 10, 350, NULL, '문법 오류를 일으키는 장난꾸러기. 빨간 밑줄을 두르고 있다.', NULL),

-- 레벨 11-15 (초급)
('런타임 에러 임프', 11, 15, 500, NULL, '실행 중에 갑자기 나타나는 악동. 프로그램을 갑자기 멈추게 한다.', NULL),
('스택오버플로우 래빗', 11, 15, 550, NULL, '재귀 호출을 남용하는 토끼. 끝없이 자기 자신을 복제한다.', NULL),

-- 레벨 16-20 (초급)
('패킷로스 유령', 16, 20, 700, NULL, '네트워크에서 사라진 패킷들의 원혼. 투명하게 떠다닌다.', 'network'),
('타임아웃 망령', 16, 20, 750, NULL, '응답을 기다리다 지쳐버린 존재. 시계를 들고 배회한다.', 'network'),

-- 레벨 21-25 (중급)
('좀비 프로세스', 21, 25, 900, NULL, '종료되었지만 아직 살아있는 프로세스. 리소스를 차지한 채 움직인다.', 'linux'),
('포크 폭탄 악마', 21, 25, 950, NULL, '무한히 자식 프로세스를 생성하는 악마. 시스템을 마비시킨다.', 'linux'),

-- 레벨 26-30 (중급)
('N+1 쿼리 오크', 26, 30, 1100, NULL, '비효율적인 쿼리를 남발하는 무지한 오크. 데이터베이스를 느리게 만든다.', 'database'),
('인젝션 트롤', 26, 30, 1200, NULL, 'SQL 인젝션을 시도하는 교활한 트롤. 작은따옴표를 무기로 쓴다.', 'database'),

-- 레벨 31-35 (중급)
('다운타임 늑대', 31, 35, 1400, NULL, '서비스 중단을 노리는 어둠의 늑대. 달이 뜨면 더 강해진다.', 'deployment'),
('롤백 유령', 31, 35, 1500, NULL, '배포 실패의 원혼. 이전 버전으로 되돌리려 한다.', 'deployment'),

-- 레벨 36-40 (중급)
('메트릭 고스트', 36, 40, 1700, NULL, '측정되지 않는 것들의 원령. 대시보드에서 사라졌다 나타난다.', 'monitoring'),
('얼럿 피로 위스프', 36, 40, 1800, NULL, '의미없는 알람들의 정령. 너무 많은 알림으로 감각을 마비시킨다.', 'monitoring'),

-- 레벨 41-45 (중급)
('XSS 악령', 41, 45, 2000, NULL, '스크립트를 심는 교활한 악령. 브라우저를 조종한다.', 'security'),
('CSRF 그림자', 41, 45, 2100, NULL, '사용자의 세션을 훔치는 그림자. 신뢰를 악용한다.', 'security'),

-- 레벨 46-50 (중급 - 드래곤급)
('메모리릭 드래곤', 46, 50, 2400, NULL, '메모리를 삼키는 보라빛 드래곤. 점점 커지며 시스템을 압박한다.', NULL),
('가비지컬렉션 드래곤', 46, 50, 2500, NULL, '모든 것을 정리하려는 용. 필요한 것까지 수거해간다.', NULL),

-- 레벨 51-55 (고급)
('스파게티코드 히드라', 51, 55, 2800, NULL, '얽히고설킨 코드의 히드라. 머리를 자르면 두 개가 자라난다.', 'architecture'),
('모놀리스 골렘', 51, 55, 3000, NULL, '거대한 단일 시스템의 골렘. 분해할 수 없는 단단한 몸을 가졌다.', 'architecture'),

-- 레벨 56-60 (고급)
('캐스케이드 실패 세르펜트', 56, 60, 3300, NULL, '한 번 실패하면 연쇄적으로 시스템을 무너뜨리는 뱀.', 'incident'),
('온콜 악몽', 56, 60, 3500, NULL, '새벽 3시에 나타나는 악몽. 페이저를 울리며 다가온다.', 'incident'),

-- 레벨 61-65 (고급)
('레이스 컨디션 닌자', 61, 65, 3800, NULL, '타이밍을 노리는 은밀한 닌자. 예측 불가능한 버그를 일으킨다.', NULL),
('데드락 마왕', 61, 65, 4000, NULL, '자원을 붙잡고 절대 놓지 않는 마왕. 서로를 기다리며 교착 상태를 만든다.', NULL),

-- 레벨 66-70 (고급)
('404 유령', 66, 70, 4300, NULL, '찾을 수 없는 페이지의 원령. 길을 잃은 요청들이 변해 태어났다.', 'network'),
('500 내부 오류 악마', 66, 70, 4500, NULL, '서버 내부에서 태어난 강력한 악마. 모호한 에러 메시지만 남긴다.', NULL),

-- 레벨 71-75 (심화 - 마왕급)
('쿼리 플랜 드라큘라', 71, 75, 4800, NULL, '인덱스를 무시하는 흡혈귀. 풀스캔으로 DB를 피폐하게 만든다.', 'database'),
('샤딩 리치', 71, 75, 5000, NULL, '데이터를 분산시키는 리치. 일관성을 해치며 떠돈다.', 'database'),

-- 레벨 76-80 (심화)
('쿠버네티스 키메라', 76, 80, 5500, NULL, '여러 서비스가 합쳐진 괴물. 파드, 서비스, 인그레스가 뒤엉켜있다.', 'deployment'),
('CI/CD 파이프 데몬', 76, 80, 5800, NULL, '빌드 파이프라인에 사는 악마. 테스트를 실패시키며 배포를 막는다.', 'deployment'),

-- 레벨 81-85 (심화)
('오버엔지니어링 피닉스', 81, 85, 6200, NULL, '불필요한 복잡성의 불사조. 죽여도 더 복잡하게 부활한다.', 'architecture'),
('기술 부채 골렘', 81, 85, 6500, NULL, '쌓인 부채가 실체화된 골렘. 갚지 않으면 계속 커진다.', 'architecture'),

-- 레벨 86-90 (최고급 - 신급)
('제로데이 어쌔신', 86, 90, 7000, NULL, '알려지지 않은 취약점을 노리는 암살자. 패치 전에 공격한다.', 'security'),
('APT 그림자군주', 86, 90, 7500, NULL, '지속적으로 위협하는 고급 공격자. 조직적이고 끈질기다.', 'security'),

-- 레벨 91-95 (전설)
('SLA 위반자 타이탄', 91, 95, 8500, NULL, '서비스 수준을 깨뜨리는 거인. 99.9%의 가용성을 위협한다.', 'incident'),
('포스트모템 사신', 91, 95, 9000, NULL, '장애 이후에 나타나는 사신. 근본 원인을 파헤친다.', 'incident'),

-- 레벨 96-100 (신화급)
('카오스 엔지니어 신', 96, 100, 9500, NULL, '의도적 혼란을 만드는 신적 존재. 시스템의 회복력을 시험한다.', NULL),
('레거시 태고신', 96, 100, 10000, NULL, '10년 전 코드로 만들어진 고대의 신. 문서화되지 않은 비밀을 품고 있다.', NULL);


-- =============================================
-- ACHIEVEMENTS (25개)
-- PRD 정의 9개 + 분야별 마스터 8개 + 추가 8개
-- =============================================

INSERT INTO achievements (code, name, description, icon) VALUES
-- PRD 정의 업적 (9개)
('first_step', '첫 발걸음', '첫 퀴즈를 완료했습니다.', '👣'),
('combo_5', '5연속 정답왕', '연속 5문제를 정답 처리했습니다.', '🔥'),
('combo_10', '10연속 무쌍', '연속 10문제를 정답 처리했습니다.', '⚡'),
('network_beginner', '네트워크 입문자', '네트워크 문제 10개를 정답 처리했습니다.', '🌐'),
('db_master', 'DB 마스터', 'DB 문제 50개를 정답 처리했습니다.', '🗄️'),
('all_category_conqueror', '전분야 정복자', '모든 분야 문제 각 10개 이상을 정답 처리했습니다.', '🏆'),
('phoenix', '불사조', 'HP 1에서 전투 승리했습니다.', '🔶'),
('level_50', '레벨 50 돌파', '레벨 50을 달성했습니다.', '⭐'),
('legend_begins', '전설의 시작', '레벨 100을 달성했습니다.', '👑'),

-- 분야별 마스터 업적 (8개)
('network_master', '네트워크 마스터', '네트워크 문제 50개를 정답 처리했습니다.', '🌍'),
('linux_master', '리눅스 마스터', 'Linux/OS 문제 50개를 정답 처리했습니다.', '🐧'),
('database_master', '데이터베이스 현자', '데이터베이스 문제 50개를 정답 처리했습니다.', '📊'),
('deployment_master', '배포 전문가', '배포/CI·CD 문제 50개를 정답 처리했습니다.', '🚀'),
('monitoring_master', '관측의 대가', '모니터링 문제 50개를 정답 처리했습니다.', '📈'),
('security_master', '보안 수호자', '보안 문제 50개를 정답 처리했습니다.', '🔐'),
('architecture_master', '아키텍처 거장', '아키텍처 문제 50개를 정답 처리했습니다.', '🏛️'),
('incident_master', 'SRE 베테랑', '장애/SRE 문제 50개를 정답 처리했습니다.', '🚨'),

-- 추가 업적 (8개)
('social_adventurer', '소셜 모험가', '첫 캐릭터 카드를 공유했습니다.', '📢'),
('gold_supporter', '골드 서포터', '골드 후원자 티어를 달성했습니다.', '💛'),
('silver_supporter', '실버 서포터', '실버 후원자 티어를 달성했습니다.', '🤍'),
('bronze_supporter', '브론즈 서포터', '첫 후원을 완료했습니다.', '🧡'),
('monster_slayer_100', '백전노장', '몬스터 100마리를 처치했습니다.', '⚔️'),
('perfect_battle', '완벽한 전투', 'HP 손실 없이 몬스터를 처치했습니다.', '💯'),
('combo_20', '연속 20문제 전설', '연속 20문제를 정답 처리했습니다.', '🌟'),
('speed_demon', '스피드 데몬', '10초 내에 정답을 맞췄습니다.', '💨');


-- =============================================
-- SHOP_ITEMS (32개)
-- 카테고리별: 모자(6), 무기스킨(6), 의상(6), 이펙트(5), 펫(5), 프레임(4)
-- 레어리티 분배: common 40%, rare 30%, epic 20%, legendary 10%
-- =============================================

INSERT INTO shop_items (name, category, description, price_gem, image_url, rarity) VALUES
-- 모자 (hat) - 6개
('프로그래머 후드', 'hat', '검정 후드에 <code>가 새겨진 클래식한 아이템. 야근의 흔적이 느껴진다.', 50, NULL, 'common'),
('해커 비니', 'hat', '녹색 매트릭스 코드가 흐르는 비니. 착용 시 IQ가 20 올라간 기분이 든다.', 80, NULL, 'common'),
('서버 헬멧', 'hat', '서버랙 LED가 번쩍이는 메탈릭 헬멧. 장애 대응 시 필수템.', 150, NULL, 'rare'),
('클라우드 왕관', 'hat', '구름처럼 둥실 떠다니는 왕관. AWS, GCP, Azure 로고가 빛난다.', 200, NULL, 'rare'),
('인피니티 캡', 'hat', '무한루프를 형상화한 야구모자. while(true)의 기운이 서려있다.', 300, NULL, 'epic'),
('레인보우 프로그래머 캡', 'hat', '모든 프로그래밍 언어의 색이 담긴 전설의 모자. 풀스택의 증거.', 500, NULL, 'legendary'),

-- 무기 스킨 (weapon_skin) - 6개
('기계식 키보드 검', 'weapon_skin', '청축 스위치의 찰칵거림이 들리는 검. 공격 시 타건음이 난다.', 100, NULL, 'common'),
('USB 지팡이', 'weapon_skin', '3.0 규격의 마법 지팡이. 데이터 전송 속도가 빠르다.', 100, NULL, 'common'),
('랜선 채찍', 'weapon_skin', 'CAT6 케이블로 만든 채찍. 네트워크 연결이 끊기지 않는다.', 150, NULL, 'rare'),
('마우스 해머', 'weapon_skin', '거대한 게이밍 마우스 형태의 해머. 클릭 한 번에 적을 처치.', 200, NULL, 'rare'),
('SSD 부메랑', 'weapon_skin', 'NVMe SSD 형태의 부메랑. 던지면 빛의 속도로 돌아온다.', 350, NULL, 'epic'),
('깃 브랜치 낫', 'weapon_skin', 'merge conflict를 끊어내는 전설의 낫. cherry-pick이 가능하다.', 500, NULL, 'legendary'),

-- 의상 (costume) - 6개
('터미널 로브', 'costume', '검은 터미널 화면이 새겨진 로브. bash 명령어가 흘러다닌다.', 150, NULL, 'common'),
('깃헙 망토', 'costume', '초록색 잔디 패턴의 망토. Contribution 히스토리를 자랑할 수 있다.', 150, NULL, 'common'),
('AWS 갑옷', 'costume', '오렌지 빛의 클라우드 갑옷. 인스턴스를 소환할 것 같은 느낌.', 250, NULL, 'rare'),
('404 티셔츠', 'costume', '"404 Not Found" 메시지가 적힌 캐주얼 티셔츠. 아이러니의 미학.', 200, NULL, 'rare'),
('도커 슈트', 'costume', '고래 무늬가 그려진 컨테이너 슈트. 어디서든 동일하게 실행된다.', 400, NULL, 'epic'),
('쿠버네티스 황제복', 'costume', '오케스트레이션의 힘이 담긴 황제의 의상. 파드들이 경배한다.', 500, NULL, 'legendary'),

-- 이펙트 (effect) - 5개
('불꽃 정답 이펙트', 'effect', '정답 시 캐릭터 주변에 불꽃이 피어오른다.', 200, NULL, 'common'),
('무지개 레벨업', 'effect', '레벨업 시 무지개 빛기둥이 솟아오른다.', 200, NULL, 'common'),
('골드 데미지 폰트', 'effect', '데미지 숫자가 황금빛으로 빛난다.', 250, NULL, 'rare'),
('픽셀 폭발 이펙트', 'effect', '몬스터 처치 시 픽셀들이 화려하게 흩어진다.', 350, NULL, 'epic'),
('홀로그램 연속정답', 'effect', '콤보 달성 시 홀로그램 숫자가 떠오른다.', 400, NULL, 'epic'),

-- 펫 (pet) - 5개
('미니 도커 고래', 'pet', '컨테이너를 등에 짊어진 귀여운 고래. 어디든 함께 간다.', 300, NULL, 'rare'),
('깃 고양이', 'pet', 'Octocat을 닮은 귀여운 고양이. 가끔 push를 도와준다.', 300, NULL, 'rare'),
('쿠버 조타기', 'pet', '쿠버네티스 로고를 들고 다니는 작은 조타기. 오케스트레이션 중.', 400, NULL, 'epic'),
('리눅스 펭귄', 'pet', '턱스를 닮은 꼬마 펭귄. sudo 권한을 가졌다.', 350, NULL, 'epic'),
('황금 버그', 'pet', '희귀한 황금빛 버그. 잡으면 행운이 온다는 전설이 있다.', 500, NULL, 'legendary'),

-- 칭호 프레임 (frame) - 4개
('골드 닉네임 테두리', 'frame', '닉네임 주변에 황금빛 테두리가 생긴다.', 100, NULL, 'common'),
('홀로그램 칭호 배경', 'frame', '칭호 뒤에 홀로그램 효과가 나타난다.', 150, NULL, 'rare'),
('픽셀아트 테두리', 'frame', '레트로 게임 스타일의 픽셀 테두리.', 200, NULL, 'rare'),
('전설의 불꽃 프레임', 'frame', '닉네임 주변에 불꽃이 타오르는 전설급 프레임.', 400, NULL, 'legendary');

COMMIT;
