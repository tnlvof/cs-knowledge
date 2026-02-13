# 네트워크 (Network) - IT 서비스 운영 필수 지식

> 이 문서는 IT 서비스 운영에 필요한 네트워크 지식을 레벨별로 정리한 학습 자료입니다.
> 퀴즈 생성 및 역량 평가에 활용할 수 있습니다.

## 레벨 가이드

| 레벨 | 대상 | 설명 |
|------|------|------|
| ⭐ Level 1 | 입문 | 개념 이해, 기본 용어 |
| ⭐⭐ Level 2 | 주니어 | 실무 적용, 트러블슈팅 기초 |
| ⭐⭐⭐ Level 3 | 시니어 | 아키텍처 설계, 성능 최적화 |
| ⭐⭐⭐⭐ Level 4 | 리드/CTO | 전략적 의사결정, 대규모 설계 |

---

## 1. DNS (Domain Name System)

### 개념 설명

DNS는 인터넷의 전화번호부로, 사람이 읽을 수 있는 도메인 이름(예: www.example.com)을 컴퓨터가 이해할 수 있는 IP 주소(예: 192.0.2.1)로 변환하는 분산 데이터베이스 시스템이다. DNS 없이는 모든 웹사이트 접속 시 IP 주소를 직접 입력해야 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - DNS는 도메인 이름을 IP 주소로 변환하는 시스템
> - 브라우저에 URL 입력 시 가장 먼저 DNS 조회가 발생
> - DNS 서버는 계층 구조: Root → TLD → Authoritative
> - 로컬 DNS 캐시가 먼저 확인됨 (브라우저 → OS → 라우터)
>
> **Q: DNS가 없다면 어떤 일이 발생하나요?**
> **A: 모든 웹사이트 접속 시 IP 주소를 직접 입력해야 합니다. 예를 들어 구글 접속 시 'google.com' 대신 '142.250.190.78'을 입력해야 합니다.**
>
> **Q: DNS 조회는 어디서 먼저 시작되나요?**
> **A: 브라우저 캐시 → OS 캐시 → 라우터 캐시 → ISP DNS 서버 순으로 확인합니다.**
>
> **Q: 도메인 이름 체계에서 'www.example.com'의 각 부분은 무엇을 의미하나요?**
> **A: 'com'은 TLD(최상위 도메인), 'example'은 SLD(2차 도메인), 'www'는 서브도메인(호스트명)입니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **A 레코드**: 도메인을 IPv4 주소에 매핑 (예: example.com → 192.0.2.1)
> - **AAAA 레코드**: 도메인을 IPv6 주소에 매핑
> - **CNAME 레코드**: 도메인을 다른 도메인에 매핑 (별칭), 루트 도메인에는 사용 불가
> - **MX 레코드**: 메일 서버 지정, 우선순위(priority) 값이 낮을수록 우선
> - **TXT 레코드**: 텍스트 정보 저장 (SPF, DKIM, 도메인 소유권 확인 등)
> - **NS 레코드**: 도메인의 네임서버 지정
> - **TTL (Time To Live)**: DNS 레코드 캐시 유지 시간 (초 단위)
>
> **Q: A 레코드와 CNAME 레코드의 차이점은 무엇인가요?**
> **A: A 레코드는 도메인을 IP 주소에 직접 연결하고, CNAME은 도메인을 다른 도메인에 연결합니다. CNAME은 추가 DNS 조회가 필요하여 약간의 지연이 발생할 수 있습니다.**
>
> **Q: 루트 도메인(apex domain)에 CNAME을 사용할 수 없는 이유는?**
> **A: RFC 표준에 따르면 CNAME은 해당 이름의 다른 레코드와 공존할 수 없는데, 루트 도메인에는 SOA, NS 등 필수 레코드가 있어야 하기 때문입니다. 대안으로 ALIAS나 ANAME 레코드를 사용합니다.**
>
> **Q: TTL을 낮게 설정하면 어떤 장단점이 있나요?**
> **A: 장점은 DNS 변경이 빠르게 전파됩니다. 단점은 DNS 서버 부하 증가와 조회 지연 시간 증가입니다. 마이그레이션 전에는 TTL을 낮추고, 안정화 후 높이는 것이 일반적입니다.**
>
> **Q: MX 레코드의 우선순위(priority)는 어떻게 작동하나요?**
> **A: 숫자가 낮을수록 우선순위가 높습니다. 예: priority 10인 서버가 priority 20보다 먼저 시도됩니다. 같은 우선순위면 랜덤하게 선택됩니다.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **재귀적 쿼리 (Recursive Query)**: 클라이언트가 로컬 DNS 서버에 요청하면, 로컬 DNS가 최종 답을 찾아 반환
> - **반복적 쿼리 (Iterative Query)**: DNS 서버가 자신이 모르면 다른 DNS 서버 주소만 알려줌
> - **DNS 전파 (Propagation)**: TTL과 캐시로 인해 전 세계 DNS 서버 업데이트에 최대 48시간 소요 가능
> - **DNS Round Robin**: 하나의 도메인에 여러 IP를 매핑하여 간단한 로드밸런싱
> - **Negative Caching**: 존재하지 않는 레코드도 캐시 (NXDOMAIN)
> - **DNS Amplification Attack**: 작은 쿼리로 큰 응답을 유도하는 DDoS 공격
>
> **Q: 재귀적 쿼리와 반복적 쿼리의 차이를 설명해주세요.**
> **A: 재귀적 쿼리에서는 클라이언트가 DNS 서버에 요청하면 그 서버가 최종 답을 찾아 반환합니다. 반복적 쿼리에서는 DNS 서버가 답을 모르면 "이 서버에 물어보세요"라며 다른 서버 주소만 알려주고, 클라이언트가 직접 다음 서버에 질의합니다.**
>
> **Q: DNS 전파가 오래 걸리는 이유와 대처 방법은?**
> **A: 전 세계 DNS 서버들이 각자의 캐시를 가지고 있고, TTL이 만료될 때까지 기존 값을 사용하기 때문입니다. 대처: 1) 변경 전 TTL을 300초 이하로 낮춤, 2) 변경 후 24-48시간 대기, 3) 안정화 후 TTL을 다시 높임.**
>
> **Q: DNS Round Robin의 한계점은 무엇인가요?**
> **A: 1) 서버 상태 확인 불가(죽은 서버에도 트래픽 전송), 2) 세션 유지 어려움, 3) 클라이언트 캐싱으로 불균등 분배, 4) 가중치 설정 불가. 실제 로드밸런싱에는 L4/L7 로드밸런서 사용을 권장합니다.**
>
> **Q: DNS Amplification Attack은 어떻게 방어하나요?**
> **A: 1) Rate limiting 적용, 2) 재귀 쿼리를 내부 네트워크로 제한, 3) Response Rate Limiting(RRL) 설정, 4) 불필요한 ANY 쿼리 차단, 5) BCP38/BCP84 적용으로 IP 스푸핑 방지.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **DNS over HTTPS (DoH)**: HTTPS로 DNS 쿼리를 암호화하여 프라이버시 보호 (RFC 8484)
> - **DNS over TLS (DoT)**: TLS로 DNS 쿼리 암호화 (포트 853)
> - **DNSSEC**: DNS 응답의 무결성과 인증을 보장하는 보안 확장
> - **Split-Horizon DNS**: 내부/외부 네트워크에 다른 DNS 응답 제공
> - **Anycast DNS**: 동일 IP를 여러 지역에서 announce하여 지연 최소화
> - **GeoDNS**: 클라이언트 위치 기반 DNS 응답으로 지역별 최적화
>
> **Q: DoH와 DoT의 차이점과 각각의 장단점은?**
> **A: DoT는 전용 포트 853을 사용하여 DNS 트래픽임이 명확하고 네트워크 관리가 쉽습니다. DoH는 HTTPS 포트 443을 사용하여 일반 웹 트래픽과 구분이 어려워 검열 우회에 유리하지만, 기업 환경에서 DNS 모니터링이 어렵습니다. 2024년 기준 Firefox 미국 사용자 90% 이상이 DoH를 기본 사용합니다.**
>
> **Q: DNSSEC의 작동 원리와 한계점은?**
> **A: DNSSEC은 각 DNS 레코드에 디지털 서명을 추가하여 응답의 진위를 검증합니다. 한계: 1) 쿼리 암호화 없음(DoH/DoT 필요), 2) 구현 복잡성, 3) 응답 크기 증가, 4) 키 관리 부담, 5) 도입률이 낮아 전체 체인 검증 어려움.**
>
> **Q: 글로벌 서비스에서 DNS 아키텍처를 어떻게 설계하나요?**
> **A: 1) Anycast DNS로 전 세계 PoP에서 동일 IP로 응답, 2) GeoDNS로 지역별 최적 서버 반환, 3) 낮은 TTL(60-300초)로 장애 시 빠른 전환, 4) 헬스체크 연동으로 자동 failover, 5) 멀티 DNS 프로바이더로 단일 장애점 제거.**
>
> **Q: DNS 기반 트래픽 관리와 로드밸런서 기반 관리의 차이는?**
> **A: DNS 기반은 클라이언트 캐싱으로 실시간 제어가 어렵고 세션 유지가 안 되지만, 글로벌 분산에 효과적입니다. 로드밸런서는 실시간 헬스체크, 세션 어피니티, 가중치 조절이 가능하지만 단일 지역에 제한됩니다. 실무에서는 DNS로 지역 분배 후 각 지역 내에서 로드밸런서를 사용하는 조합이 일반적입니다.**

### 실무 시나리오

**시나리오 1: 도메인 마이그레이션**
기존 서버에서 새 서버로 마이그레이션 시:
1. 마이그레이션 3일 전: TTL을 300초로 낮춤
2. 새 서버 준비 및 테스트 완료
3. A 레코드를 새 IP로 변경
4. 48시간 모니터링
5. 안정화 후 TTL을 3600초 이상으로 복원

**시나리오 2: DNS 조회 실패 트러블슈팅**
```bash
# DNS 조회 테스트
dig example.com
nslookup example.com

# 특정 DNS 서버로 조회
dig @8.8.8.8 example.com

# DNS 전파 상태 확인
dig +trace example.com

# 모든 레코드 타입 조회
dig example.com ANY
```

### 면접 빈출 질문

- **Q: 브라우저에 URL을 입력하면 어떤 일이 일어나나요?**
- **A: 1) 브라우저 캐시 → OS 캐시 → 라우터 → ISP DNS 순으로 캐시 확인, 2) 캐시 미스 시 재귀적 DNS 쿼리로 Root → TLD → Authoritative 순 조회, 3) IP 획득 후 TCP 연결(3-way handshake), 4) HTTPS면 TLS 핸드셰이크, 5) HTTP 요청 전송, 6) 서버 응답 수신 및 렌더링.**

- **Q: DNS 캐시 포이즈닝(Cache Poisoning)이란?**
- **A: 공격자가 DNS 캐시에 위조된 레코드를 주입하여 사용자를 악성 사이트로 유도하는 공격입니다. 방어: DNSSEC 적용, DNS 서버 소프트웨어 최신 유지, 소스 포트 랜덤화.**

---

## 2. HTTP/HTTPS

### 개념 설명

HTTP(HyperText Transfer Protocol)는 웹에서 클라이언트와 서버 간 데이터를 주고받기 위한 프로토콜이다. HTTPS는 HTTP에 TLS/SSL 암호화를 추가한 보안 버전이다. 현대 웹의 근간이 되는 프로토콜로, 버전이 발전하면서 성능과 보안이 크게 개선되었다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - HTTP는 요청(Request)과 응답(Response)으로 구성
> - 기본 메서드: GET(조회), POST(생성), PUT(수정), DELETE(삭제)
> - HTTPS는 HTTP + TLS 암호화 (포트 443)
> - 상태 코드: 2xx(성공), 3xx(리다이렉션), 4xx(클라이언트 오류), 5xx(서버 오류)
>
> **Q: GET과 POST의 차이점은 무엇인가요?**
> **A: GET은 데이터 조회용으로 URL에 파라미터가 노출되고, 브라우저 히스토리에 남으며, 캐시 가능합니다. POST는 데이터 생성/수정용으로 body에 데이터를 담아 전송하고, 캐시되지 않습니다.**
>
> **Q: HTTP 상태 코드 200, 404, 500은 각각 무엇을 의미하나요?**
> **A: 200 OK는 요청 성공, 404 Not Found는 리소스를 찾을 수 없음, 500 Internal Server Error는 서버 내부 오류입니다.**
>
> **Q: HTTPS가 HTTP보다 안전한 이유는?**
> **A: HTTPS는 TLS 암호화를 통해 1) 데이터 도청 방지(기밀성), 2) 데이터 변조 방지(무결성), 3) 서버 신원 확인(인증)을 제공합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **주요 상태 코드**: 201(Created), 204(No Content), 301(영구 이동), 302(임시 이동), 400(Bad Request), 401(Unauthorized), 403(Forbidden), 429(Too Many Requests), 502(Bad Gateway), 503(Service Unavailable)
> - **중요 헤더**: Content-Type, Authorization, Cache-Control, Cookie/Set-Cookie, User-Agent
> - **쿠키 속성**: HttpOnly(JS 접근 차단), Secure(HTTPS만), SameSite(CSRF 방어)
> - **Keep-Alive**: TCP 연결 재사용으로 성능 향상 (HTTP/1.1 기본)
>
> **Q: 401 Unauthorized와 403 Forbidden의 차이는?**
> **A: 401은 인증(Authentication) 실패로 "누구인지 모르겠다"이고, 403은 인가(Authorization) 실패로 "누구인지 알지만 권한이 없다"입니다.**
>
> **Q: Cache-Control 헤더의 주요 디렉티브를 설명해주세요.**
> **A: no-store(캐시 금지), no-cache(항상 재검증), max-age=N(N초간 캐시), private(브라우저만 캐시), public(CDN도 캐시 가능), must-revalidate(만료 후 필수 재검증).**
>
> **Q: SameSite 쿠키 속성의 Strict, Lax, None의 차이는?**
> **A: Strict는 모든 크로스사이트 요청에서 쿠키 전송 차단, Lax(기본값)는 안전한 최상위 탐색(GET 링크)에서만 허용, None은 모든 요청에 전송(Secure 필수).**
>
> **Q: 502 Bad Gateway와 503 Service Unavailable의 차이는?**
> **A: 502는 게이트웨이/프록시가 업스트림 서버로부터 잘못된 응답을 받음, 503은 서버가 일시적으로 요청을 처리할 수 없음(과부하, 유지보수).**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **HTTP/1.1**: Keep-Alive, Chunked Transfer, 파이프라이닝(HOL blocking 문제)
> - **HTTP/2**: 멀티플렉싱(단일 연결에 여러 스트림), 헤더 압축(HPACK), 서버 푸시, 바이너리 프레이밍
> - **HTTP/3**: QUIC 기반(UDP), 연결 수준 HOL blocking 해결, 0-RTT 연결, 연결 마이그레이션
> - **CORS**: Cross-Origin Resource Sharing, Preflight 요청(OPTIONS), Access-Control-* 헤더
>
> **Q: HTTP/2의 멀티플렉싱이 HTTP/1.1의 문제를 어떻게 해결하나요?**
> **A: HTTP/1.1은 하나의 연결에서 한 번에 하나의 요청만 처리할 수 있어 HOL(Head-of-Line) blocking이 발생했습니다. HTTP/2는 단일 TCP 연결에서 여러 스트림을 동시에 처리하여 병렬 요청이 가능합니다. 하지만 TCP 수준의 HOL blocking은 여전히 존재합니다.**
>
> **Q: HTTP/3가 UDP 기반 QUIC를 사용하는 이유는?**
> **A: TCP의 HOL blocking을 완전히 해결하기 위해서입니다. QUIC은 각 스트림이 독립적이어서 하나의 패킷 손실이 다른 스트림에 영향을 주지 않습니다. 또한 연결 설정이 빠르고(0-RTT), 네트워크 변경 시 연결 마이그레이션이 가능합니다. 2024년 기준 HTTP/3는 모바일에서 지연 시간을 30% 감소시킵니다.**
>
> **Q: CORS Preflight 요청은 언제 발생하나요?**
> **A: Simple Request가 아닌 경우 발생합니다. 조건: 1) GET/HEAD/POST 외 메서드, 2) Content-Type이 application/json 등 특수 값, 3) 커스텀 헤더 사용. Preflight는 OPTIONS 메서드로 서버의 허용 여부를 미리 확인합니다.**
>
> **Q: HTTP/2 서버 푸시의 장단점은?**
> **A: 장점은 클라이언트 요청 전에 필요한 리소스를 미리 전송하여 지연 감소. 단점은 클라이언트 캐시를 무시하고 푸시하면 대역폭 낭비, 구현 복잡성, 실제 성능 향상이 기대보다 작아 사용이 감소하는 추세입니다.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **HTTP/3 도입 전략**: 점진적 롤아웃, 폴백 메커니즘, ALT-SVC 헤더 활용
> - **API 버저닝**: URL 경로(/v1/), 헤더(Accept-Version), 쿼리스트링 방식의 트레이드오프
> - **gRPC vs REST**: 바이너리 프로토콜 vs 텍스트, 양방향 스트리밍, 마이크로서비스 간 통신
> - **API Gateway 패턴**: 인증, 레이트 리밋, 로깅, 트래픽 관리 중앙화
>
> **Q: HTTP/3 도입 시 고려해야 할 인프라 요소는?**
> **A: 1) UDP 443 포트 개방(방화벽, 로드밸런서), 2) QUIC 지원 로드밸런서/CDN, 3) HTTP/2 폴백 구현, 4) 모니터링 도구 호환성, 5) 엔터프라이즈 네트워크의 UDP 차단 대응. 현재 CloudFront, Cloudflare 등 주요 CDN은 HTTP/3를 지원합니다.**
>
> **Q: 마이크로서비스 환경에서 gRPC와 REST의 선택 기준은?**
> **A: gRPC 선택: 낮은 지연 필요, 양방향 스트리밍, 내부 서비스 간 통신, 강타입 스키마 필요. REST 선택: 브라우저 클라이언트, 공개 API, 간단한 CRUD, 디버깅 용이성. 하이브리드 접근: 내부는 gRPC, 외부는 REST Gateway.**
>
> **Q: 대규모 API 시스템의 버저닝 전략은?**
> **A: 1) URL 버저닝(/v1/)이 가장 명시적이지만 캐시 분리됨, 2) 헤더 버저닝은 URL 깔끔하지만 테스트 어려움, 3) Sunset 헤더로 deprecation 알림, 4) 최소 2개 버전 동시 지원, 5) Breaking change 최소화를 위한 API 설계 원칙 수립.**

### 실무 시나리오

**시나리오 1: CORS 오류 해결**
```
Access to fetch at 'https://api.example.com' from origin 'https://app.example.com'
has been blocked by CORS policy
```
해결:
```nginx
# Nginx 설정
location /api {
    add_header 'Access-Control-Allow-Origin' 'https://app.example.com';
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type';
    add_header 'Access-Control-Max-Age' 86400;

    if ($request_method = 'OPTIONS') {
        return 204;
    }
}
```

**시나리오 2: HTTP 응답 속도 최적화**
1. HTTP/2 또는 HTTP/3 활성화
2. 적절한 Cache-Control 설정
3. 압축 활성화 (gzip, brotli)
4. Keep-Alive 타임아웃 조정
5. CDN 활용

### 면접 빈출 질문

- **Q: HTTP는 stateless인데 어떻게 로그인 상태를 유지하나요?**
- **A: 쿠키, 세션, JWT 등을 사용합니다. 세션 방식은 서버에 상태 저장 후 세션 ID를 쿠키로 전달, JWT는 토큰 자체에 정보를 담아 stateless하게 인증합니다.**

- **Q: HTTP/2를 사용하면 무조건 빨라지나요?**
- **A: 대부분 빨라지지만, 패킷 손실이 많은 네트워크에서는 TCP HOL blocking으로 HTTP/1.1의 다중 연결보다 느릴 수 있습니다. 이 경우 HTTP/3(QUIC)가 더 효과적입니다.**

---

## 3. TLS/SSL

### 개념 설명

TLS(Transport Layer Security)는 네트워크 통신에서 데이터의 기밀성, 무결성, 인증을 제공하는 암호화 프로토콜이다. SSL(Secure Sockets Layer)은 TLS의 전신으로, 현재는 보안 취약점으로 사용 금지되었다. HTTPS, 이메일, VPN 등 다양한 프로토콜에서 사용된다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - TLS는 데이터를 암호화하여 도청과 변조를 방지
> - HTTPS = HTTP + TLS
> - SSL은 구버전, TLS가 현재 표준 (TLS 1.2, 1.3)
> - 인증서는 서버의 신원을 보증하는 디지털 문서
>
> **Q: HTTP와 HTTPS의 차이점은?**
> **A: HTTPS는 TLS 암호화를 사용하여 데이터가 암호화되고, 서버 인증서로 신뢰성을 확인할 수 있습니다. HTTP는 평문 통신으로 데이터가 노출될 수 있습니다.**
>
> **Q: SSL과 TLS의 관계는?**
> **A: SSL은 Netscape가 개발한 초기 암호화 프로토콜이고, TLS는 SSL 3.0을 기반으로 IETF가 표준화한 후속 버전입니다. SSL 2.0/3.0은 취약점으로 사용 금지되었습니다.**
>
> **Q: 인증서가 필요한 이유는?**
> **A: 암호화만으로는 "누구와" 통신하는지 확인할 수 없습니다. 인증서는 신뢰할 수 있는 CA(인증기관)가 서버의 신원을 보증하여 중간자 공격을 방지합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **TLS 핸드셰이크 과정**: ClientHello → ServerHello → 인증서 교환 → 키 교환 → Finished
> - **인증서 체인**: 서버 인증서 → 중간 인증서 → 루트 인증서
> - **Let's Encrypt**: 무료 자동화 인증서 발급 (ACME 프로토콜)
> - **인증서 유형**: DV(도메인 검증), OV(조직 검증), EV(확장 검증)
>
> **Q: TLS 핸드셰이크 과정을 설명해주세요.**
> **A: 1) ClientHello: 클라이언트가 지원하는 TLS 버전, 암호화 스위트, 랜덤값 전송, 2) ServerHello: 서버가 선택한 암호화 스위트, 랜덤값, 인증서 전송, 3) 클라이언트가 인증서 검증, 4) 키 교환으로 세션 키 생성, 5) Finished 메시지로 핸드셰이크 완료.**
>
> **Q: Let's Encrypt 인증서의 장단점은?**
> **A: 장점은 무료, 자동 갱신(certbot), 널리 신뢰됨. 단점은 90일 짧은 유효기간, DV만 지원(OV/EV 불가), 와일드카드는 DNS 인증 필요.**
>
> **Q: 인증서 체인이 필요한 이유는?**
> **A: 루트 CA는 보안상 직접 인증서 발급을 하지 않고 중간 CA를 통해 발급합니다. 브라우저는 루트 CA만 신뢰하므로, 서버는 중간 인증서를 함께 전송하여 신뢰 체인을 완성해야 합니다.**
>
> **Q: SSL 인증서 오류 "NET::ERR_CERT_AUTHORITY_INVALID"의 원인은?**
> **A: 1) 자체 서명 인증서 사용, 2) 중간 인증서 누락, 3) 루트 CA가 브라우저에서 신뢰되지 않음, 4) 인증서 만료. 해결: 중간 인증서 포함, 신뢰할 수 있는 CA 사용.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **TLS 1.2 vs 1.3**: 1.3은 핸드셰이크 1-RTT(vs 2-RTT), 취약한 암호화 제거, 0-RTT 지원
> - **Perfect Forward Secrecy (PFS)**: 세션 키와 장기 키 분리로 과거 트래픽 보호 (ECDHE, DHE)
> - **mTLS (Mutual TLS)**: 서버와 클라이언트 양방향 인증
> - **HSTS**: HTTP Strict Transport Security, HTTPS 강제
> - **Certificate Pinning**: 특정 인증서만 신뢰하도록 고정
>
> **Q: TLS 1.3의 주요 개선 사항은?**
> **A: 1) 핸드셰이크 1-RTT로 단축(30-50% 지연 감소), 2) 0-RTT 재연결, 3) RSA 키 교환 제거(PFS 필수), 4) 취약 암호 제거(RC4, 3DES, SHA-1 등), 5) 핸드셰이크 암호화로 메타데이터 노출 최소화. NIST 기준 2024년부터 TLS 1.3 지원 필수입니다.**
>
> **Q: Perfect Forward Secrecy가 중요한 이유는?**
> **A: PFS 없이 정적 RSA 키를 사용하면, 서버 개인 키가 유출될 경우 과거에 캡처된 모든 트래픽을 복호화할 수 있습니다. PFS는 각 세션마다 임시 키를 생성하여 개인 키 유출에도 과거 통신을 보호합니다.**
>
> **Q: mTLS는 언제 사용하나요?**
> **A: 1) 마이크로서비스 간 통신(서비스 메시), 2) API 인증(고보안 환경), 3) IoT 디바이스 인증, 4) Zero Trust 아키텍처. 단점은 인증서 관리 복잡성, 클라이언트 인증서 배포 필요.**
>
> **Q: HSTS preload의 장단점은?**
> **A: 장점은 첫 요청부터 HTTPS 강제로 SSL Stripping 공격 방지. 단점은 등록 취소가 어렵고(수개월 소요), 실수로 등록 시 HTTP 사이트 접근 불가.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **인증서 자동화**: ACME + cert-manager(K8s), Vault PKI
> - **TLS Termination 전략**: 엣지에서 종료 vs E2E 암호화
> - **Post-Quantum Cryptography**: 양자 컴퓨터 대응 암호화 준비
> - **Zero Trust 네트워크**: mTLS + 서비스 메시(Istio, Linkerd)
>
> **Q: 대규모 환경에서 인증서 관리 전략은?**
> **A: 1) cert-manager로 K8s 인증서 자동화, 2) Vault PKI로 내부 CA 구축 및 자동 발급/갱신, 3) ACM/Cloud Certificate Manager로 클라우드 관리형 사용, 4) 인증서 만료 모니터링(30일 전 알림), 5) 와일드카드 vs 개별 인증서 정책 수립.**
>
> **Q: TLS Termination을 어디서 해야 하나요?**
> **A: 로드밸런서/CDN에서 종료: 백엔드 부하 감소, 인증서 관리 중앙화, 하지만 내부 네트워크 평문 노출. E2E 암호화: 보안 강화, 하지만 복잡성 증가. 권장: 외부 TLS는 엣지에서 종료, 내부는 mTLS로 재암호화(Zero Trust).**
>
> **Q: 양자 컴퓨팅 시대에 TLS 준비는?**
> **A: 현재 비대칭 암호(RSA, ECDSA)는 양자 컴퓨터에 취약합니다. NIST는 2024년 Post-Quantum 표준(CRYSTALS-Kyber, CRYSTALS-Dilithium)을 발표했습니다. 준비: 1) 암호화 인벤토리 파악, 2) 하이브리드 접근(기존+PQ), 3) 암호 민첩성(Crypto Agility) 확보.**

### 실무 시나리오

**시나리오 1: Let's Encrypt 인증서 자동 갱신**
```bash
# certbot 설치 및 인증서 발급
sudo certbot --nginx -d example.com -d www.example.com

# 자동 갱신 테스트
sudo certbot renew --dry-run

# cron 또는 systemd timer로 자동 갱신
# /etc/cron.d/certbot
0 0,12 * * * root certbot renew --quiet
```

**시나리오 2: TLS 설정 점검**
```bash
# OpenSSL로 연결 테스트
openssl s_client -connect example.com:443 -tls1_3

# 인증서 체인 확인
openssl s_client -connect example.com:443 -showcerts

# SSL Labs 테스트
# https://www.ssllabs.com/ssltest/
```

### 면접 빈출 질문

- **Q: HTTPS가 모든 보안 문제를 해결하나요?**
- **A: 아닙니다. HTTPS는 전송 중 암호화만 제공합니다. 서버 측 보안(SQL Injection, XSS), 인증/인가, 데이터 저장 암호화 등은 별도로 구현해야 합니다.**

- **Q: 자체 서명 인증서는 언제 사용하나요?**
- **A: 개발/테스트 환경, 내부 서비스(mTLS), 비용 절감이 필요한 비공개 시스템에서 사용합니다. 프로덕션 공개 서비스에서는 신뢰할 수 있는 CA 인증서를 사용해야 합니다.**

---

## 4. TCP/IP

### 개념 설명

TCP/IP는 인터넷의 기반이 되는 프로토콜 스택이다. IP(Internet Protocol)는 패킷을 목적지까지 라우팅하고, TCP(Transmission Control Protocol)는 신뢰성 있는 데이터 전송을 보장한다. 대부분의 인터넷 애플리케이션(웹, 이메일, 파일 전송)이 TCP/IP 위에서 동작한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - TCP/IP 4계층: 애플리케이션 → 전송 → 인터넷 → 네트워크 인터페이스
> - IP 주소: 네트워크에서 기기를 식별하는 주소 (IPv4: 32비트, IPv6: 128비트)
> - 포트: 하나의 IP에서 여러 서비스를 구분 (0-65535)
> - Well-known 포트: HTTP(80), HTTPS(443), SSH(22), FTP(21)
>
> **Q: IP 주소와 포트의 역할을 비유로 설명해주세요.**
> **A: IP 주소는 아파트 주소(건물 위치), 포트는 호수(몇 호인지)입니다. IP로 기기를 찾고, 포트로 해당 기기의 어떤 서비스에 연결할지 결정합니다.**
>
> **Q: TCP와 UDP의 기본적인 차이는?**
> **A: TCP는 신뢰성 있는 연결(전화 통화처럼), UDP는 빠르지만 신뢰성 없는 연결(편지처럼)입니다.**
>
> **Q: 127.0.0.1은 무엇인가요?**
> **A: localhost 또는 루프백 주소로, 자기 자신을 가리킵니다. 네트워크 테스트나 로컬 서비스 연결에 사용됩니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **3-way Handshake**: SYN → SYN-ACK → ACK (연결 수립)
> - **4-way Handshake**: FIN → ACK → FIN → ACK (연결 종료)
> - **시퀀스 번호**: 데이터 순서 보장, 중복/손실 감지
> - **ACK (Acknowledgment)**: 데이터 수신 확인
> - **TCP 상태**: LISTEN, ESTABLISHED, TIME_WAIT, CLOSE_WAIT 등
>
> **Q: 3-way Handshake가 필요한 이유는?**
> **A: 양쪽 모두 송수신 능력이 있음을 확인하기 위해서입니다. 1) 클라이언트 → 서버: SYN(연결 요청), 2) 서버 → 클라이언트: SYN-ACK(요청 수락), 3) 클라이언트 → 서버: ACK(확인). 이로써 양방향 통신 준비 완료.**
>
> **Q: TIME_WAIT 상태는 왜 필요한가요?**
> **A: 1) 지연된 패킷이 새 연결에 영향주는 것을 방지, 2) 마지막 ACK 손실 시 재전송 대응. 보통 2*MSL(Maximum Segment Lifetime, 약 60-240초) 동안 유지됩니다.**
>
> **Q: CLOSE_WAIT 상태가 많으면 무슨 문제인가요?**
> **A: 애플리케이션이 소켓을 제대로 닫지 않았다는 의미입니다. 상대방이 연결을 종료했지만 애플리케이션에서 close()를 호출하지 않아 리소스가 누수됩니다. 코드에서 연결 종료 처리를 확인해야 합니다.**
>
> **Q: 연결 수립은 3-way인데 종료는 왜 4-way인가요?**
> **A: 연결 종료는 양방향 독립적으로 이루어지기 때문입니다. 한쪽이 FIN을 보내면 그쪽 전송만 끝나고, 상대방은 아직 보낼 데이터가 있을 수 있어 별도로 FIN을 보냅니다.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **흐름 제어 (Flow Control)**: 수신자의 버퍼 오버플로우 방지, 슬라이딩 윈도우
> - **혼잡 제어 (Congestion Control)**: 네트워크 혼잡 감지 및 대응 (Slow Start, AIMD, Fast Retransmit)
> - **Nagle 알고리즘**: 작은 패킷을 모아서 전송, 지연 발생 가능
> - **TCP Keep-Alive**: 유휴 연결의 생존 여부 확인
> - **소켓 옵션**: SO_REUSEADDR, TCP_NODELAY, SO_KEEPALIVE
>
> **Q: 흐름 제어와 혼잡 제어의 차이는?**
> **A: 흐름 제어는 송신자-수신자 간 속도 조절로 수신자 버퍼 오버플로우 방지. 혼잡 제어는 네트워크 전체의 혼잡을 감지하고 송신 속도를 조절하여 네트워크 붕괴를 방지합니다.**
>
> **Q: TCP Slow Start는 어떻게 동작하나요?**
> **A: 초기 혼잡 윈도우(cwnd)를 작게 시작하여 ACK를 받을 때마다 지수적으로 증가시킵니다(1→2→4→8...). 임계값(ssthresh)에 도달하면 선형 증가로 전환합니다. 이로써 네트워크 상태를 탐색하며 안전하게 속도를 높입니다.**
>
> **Q: Nagle 알고리즘을 비활성화(TCP_NODELAY)해야 하는 경우는?**
> **A: 실시간성이 중요한 경우: 1) 대화형 애플리케이션(SSH, 텔넷), 2) 게임 서버, 3) 금융 거래 시스템. Nagle은 작은 패킷을 모아 보내므로 지연이 발생합니다.**
>
> **Q: SO_REUSEADDR의 용도와 주의점은?**
> **A: TIME_WAIT 상태의 포트를 재사용할 수 있게 합니다. 서버 재시작 시 "Address already in use" 오류 방지에 유용. 주의: 보안상 같은 포트에 여러 프로세스가 바인딩될 수 있어 의도치 않은 동작 가능.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **TCP BBR**: Google의 혼잡 제어 알고리즘, 대역폭 추정 기반
> - **TCP Fast Open (TFO)**: 핸드셰이크 중 데이터 전송으로 지연 감소
> - **MPTCP (Multipath TCP)**: 여러 경로를 동시에 사용
> - **커널 튜닝**: 버퍼 크기, 백로그, TIME_WAIT 최적화
>
> **Q: TCP BBR이 기존 혼잡 제어보다 좋은 이유는?**
> **A: 기존 알고리즘(CUBIC 등)은 패킷 손실을 혼잡의 신호로 사용하여 손실 발생 전까지 대역폭을 활용하지 못합니다. BBR은 RTT와 대역폭을 직접 측정하여 최적 전송률을 찾아 처리량을 높이고 지연을 줄입니다. Google 내부에서 처리량 2-25% 향상.**
>
> **Q: 대규모 서버에서 TIME_WAIT 문제 해결 방법은?**
> **A: 1) tcp_tw_reuse 활성화(클라이언트 측), 2) SO_REUSEADDR 사용, 3) Keep-Alive로 연결 재사용, 4) Connection Pooling, 5) 로드밸런서에서 연결 관리. 주의: tcp_tw_recycle은 NAT 환경에서 문제를 일으켜 최신 커널에서 제거됨.**
>
> **Q: 고성능 네트워크를 위한 커널 튜닝 항목은?**
> **A: 1) net.core.rmem_max/wmem_max: 소켓 버퍼 크기, 2) net.ipv4.tcp_max_syn_backlog: SYN 큐 크기, 3) net.core.somaxconn: listen 백로그, 4) net.ipv4.tcp_congestion_control: BBR 등 혼잡 제어 알고리즘, 5) net.ipv4.ip_local_port_range: 사용 가능한 포트 범위 확장.**

### 실무 시나리오

**시나리오 1: 연결 문제 디버깅**
```bash
# TCP 연결 상태 확인
netstat -an | grep ESTABLISHED
ss -s  # 소켓 통계

# 특정 포트 연결 테스트
telnet example.com 80
nc -zv example.com 80

# TIME_WAIT 개수 확인
netstat -an | grep TIME_WAIT | wc -l

# 패킷 캡처
tcpdump -i eth0 port 80 -w capture.pcap
```

**시나리오 2: 서버 커널 튜닝**
```bash
# /etc/sysctl.conf
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

# 적용
sysctl -p
```

### 면접 빈출 질문

- **Q: TCP가 신뢰성을 보장하는 방법은?**
- **A: 1) 시퀀스 번호로 순서 보장, 2) ACK로 수신 확인, 3) 체크섬으로 무결성 검증, 4) 재전송으로 손실 복구, 5) 흐름/혼잡 제어로 속도 조절.**

- **Q: 서버에 연결이 안 되는 경우 디버깅 순서는?**
- **A: 1) ping으로 IP 도달성, 2) traceroute로 경로 확인, 3) telnet/nc로 포트 오픈 확인, 4) netstat으로 서비스 리스닝 확인, 5) 방화벽/보안그룹 규칙 확인, 6) tcpdump로 패킷 분석.**

---

## 5. UDP

### 개념 설명

UDP(User Datagram Protocol)는 비연결형 전송 프로토콜로, TCP와 달리 연결 설정, 순서 보장, 재전송이 없다. 오버헤드가 적어 빠르지만 신뢰성이 없다. 실시간 스트리밍, 게임, DNS, VoIP 등 속도가 중요하고 일부 손실을 허용할 수 있는 애플리케이션에서 사용된다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - UDP는 연결 없이 데이터를 바로 전송 (Connectionless)
> - 패킷 손실, 순서 뒤바뀜, 중복이 발생할 수 있음
> - TCP보다 빠르고 오버헤드가 적음
> - 사용 예: 동영상 스트리밍, 온라인 게임, DNS
>
> **Q: UDP를 사용하는 이유는?**
> **A: TCP의 연결 설정, 재전송 등 오버헤드 없이 빠른 전송이 필요할 때 사용합니다. 약간의 데이터 손실이 허용되는 실시간 애플리케이션에 적합합니다.**
>
> **Q: DNS는 왜 UDP를 사용하나요?**
> **A: DNS 쿼리는 작은 크기이고, 빠른 응답이 중요하며, 응답이 없으면 재요청하면 됩니다. 연결 설정 오버헤드를 피해 빠른 조회가 가능합니다.**
>
> **Q: 동영상 스트리밍에서 패킷 손실이 발생하면?**
> **A: 잠시 화면이 깨지거나 끊길 수 있지만, 재전송을 기다리는 것보다 다음 프레임을 보여주는 것이 사용자 경험에 좋습니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **UDP 헤더**: 소스 포트, 목적지 포트, 길이, 체크섬 (8바이트로 간단)
> - **UDP vs TCP 사용 사례**:
>   - UDP: DNS, DHCP, SNMP, 실시간 게임, VoIP, 비디오 스트리밍
>   - TCP: HTTP, FTP, SSH, 이메일, 파일 전송
> - **브로드캐스트/멀티캐스트**: UDP만 지원
>
> **Q: UDP 체크섬은 어떤 역할을 하나요?**
> **A: 데이터 무결성을 검증합니다. IPv4에서는 선택적이지만 IPv6에서는 필수입니다. 체크섬 오류 시 패킷이 폐기되지만 재전송은 하지 않습니다.**
>
> **Q: 멀티캐스트가 UDP만 지원하는 이유는?**
> **A: TCP는 일대일 연결 기반이라 각 수신자와 별도 연결이 필요합니다. UDP는 연결이 없어 하나의 패킷을 여러 수신자에게 동시에 전달할 수 있습니다.**
>
> **Q: UDP 기반 애플리케이션에서 신뢰성이 필요하면?**
> **A: 애플리케이션 계층에서 구현합니다. 예: QUIC(HTTP/3), 게임의 reliable UDP, 커스텀 ACK/재전송 로직.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **QUIC**: Google이 개발한 UDP 기반 전송 프로토콜, HTTP/3의 기반
> - **UDP hole punching**: NAT 환경에서 P2P 연결 수립 기법
> - **RTP/RTCP**: 실시간 미디어 전송 프로토콜 (UDP 위에서 동작)
> - **UDP 성능 최적화**: 버퍼 크기, 패킷 크기, 손실 허용 설계
>
> **Q: QUIC가 UDP 위에 구현된 이유는?**
> **A: 1) TCP 수정은 OS 커널 변경이 필요하지만 UDP는 사용자 공간에서 프로토콜 구현 가능, 2) 미들박스(방화벽 등)가 TCP를 임의로 수정하는 문제 회피, 3) 빠른 반복과 배포 가능.**
>
> **Q: QUIC의 주요 특징을 설명해주세요.**
> **A: 1) 0-RTT 연결 재개, 2) 스트림 단위 HOL blocking 해결(패킷 손실이 다른 스트림에 영향 없음), 3) 연결 마이그레이션(IP 변경에도 연결 유지), 4) 내장 TLS 1.3, 5) 2024년 기준 모바일에서 30% 지연 감소.**
>
> **Q: UDP hole punching의 원리는?**
> **A: NAT 뒤의 두 클라이언트가 먼저 공개 서버에 패킷을 보내 NAT 매핑을 생성합니다. 서버가 상대방의 외부 IP:포트를 알려주면, 양쪽이 서로에게 패킷을 보내 NAT 매핑을 통과합니다.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **UDP 기반 프로토콜 설계**: 신뢰성, 순서, 혼잡 제어를 필요에 맞게 구현
> - **WebRTC 아키텍처**: STUN/TURN 서버, ICE, DTLS-SRTP
> - **게임 네트워크 아키텍처**: 상태 동기화, 지연 보상, 예측
>
> **Q: UDP 기반 신뢰성 프로토콜을 설계할 때 고려사항은?**
> **A: 1) 어떤 메시지가 신뢰성이 필요한지 분류(게임 위치는 최신만, 채팅은 모두 필요), 2) 시퀀스 번호와 ACK 설계, 3) 재전송 타임아웃 결정, 4) 혼잡 제어 필요 여부, 5) 패킷 단편화 처리.**
>
> **Q: 대규모 실시간 서비스에서 UDP 인프라 고려사항은?**
> **A: 1) 방화벽/로드밸런서의 UDP 지원 확인, 2) UDP 443 포트 사용(QUIC, 차단 우회), 3) NAT 타임아웃(30-60초) 고려한 keepalive, 4) DDoS 방어(UDP amplification 취약), 5) 모니터링 도구의 UDP 지원.**

### 실무 시나리오

**시나리오 1: UDP 연결 테스트**
```bash
# UDP 포트 리스닝 확인
nc -ul 5000  # 서버
nc -u localhost 5000  # 클라이언트

# UDP 포트 스캔
nmap -sU -p 53,123,161 target

# UDP 패킷 캡처
tcpdump -i eth0 udp port 53
```

### 면접 빈출 질문

- **Q: TCP와 UDP 중 어떤 것을 선택할지 기준은?**
- **A: 신뢰성이 중요하면 TCP(파일 전송, 웹), 실시간성이 중요하고 일부 손실을 허용할 수 있으면 UDP(스트리밍, 게임). 최근에는 QUIC처럼 UDP 위에 필요한 기능만 구현하는 추세.**

- **Q: UDP flood 공격과 방어 방법은?**
- **A: 대량의 UDP 패킷으로 서버/네트워크를 마비시키는 DDoS 공격입니다. 방어: 1) Rate limiting, 2) 방화벽에서 불필요한 UDP 포트 차단, 3) DDoS 방어 서비스(Cloudflare 등), 4) IP 평판 기반 필터링.**

---

## 6. WebSocket

### 개념 설명

WebSocket은 HTTP를 통해 초기 핸드셰이크 후 양방향 전이중(full-duplex) 통신을 제공하는 프로토콜이다. 클라이언트와 서버가 실시간으로 데이터를 주고받을 수 있어 채팅, 실시간 알림, 협업 도구 등에 사용된다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - WebSocket은 서버와 클라이언트 간 양방향 실시간 통신
> - HTTP는 요청-응답 방식, WebSocket은 연결 유지하며 양방향 통신
> - 사용 예: 채팅, 실시간 알림, 주식 시세, 게임
> - ws:// (비암호화), wss:// (TLS 암호화)
>
> **Q: HTTP 폴링과 WebSocket의 차이는?**
> **A: HTTP 폴링은 클라이언트가 주기적으로 서버에 요청하여 비효율적입니다. WebSocket은 연결을 유지하며 서버가 즉시 데이터를 푸시할 수 있어 효율적입니다.**
>
> **Q: WebSocket을 사용하면 좋은 경우는?**
> **A: 실시간 양방향 통신이 필요한 경우: 채팅, 실시간 협업(Google Docs), 게임, 라이브 스트리밍 알림, 실시간 대시보드.**
>
> **Q: 모든 실시간 기능에 WebSocket을 써야 하나요?**
> **A: 아닙니다. 서버→클라이언트 단방향이면 SSE(Server-Sent Events)가 더 간단합니다. 가끔 업데이트면 HTTP 폴링으로 충분합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **WebSocket 핸드셰이크**: HTTP Upgrade 요청으로 시작
>   ```
>   GET /chat HTTP/1.1
>   Upgrade: websocket
>   Connection: Upgrade
>   Sec-WebSocket-Key: x3JJHMbDL1EzLkh9GBhXDw==
>   ```
> - **프레임 타입**: Text(UTF-8), Binary, Ping/Pong(연결 확인), Close
> - **연결 종료**: Close 프레임 교환
> - **재연결 로직**: 클라이언트에서 exponential backoff로 구현
>
> **Q: WebSocket 핸드셰이크 과정을 설명해주세요.**
> **A: 1) 클라이언트가 HTTP Upgrade 요청(Sec-WebSocket-Key 포함), 2) 서버가 101 Switching Protocols 응답(Sec-WebSocket-Accept 포함), 3) 이후 TCP 연결 위에서 WebSocket 프레임 교환.**
>
> **Q: Ping/Pong 프레임의 용도는?**
> **A: 연결이 살아있는지 확인합니다. 중간 프록시나 로드밸런서가 유휴 연결을 끊지 않도록 주기적으로 전송합니다. 서버가 Ping을 보내면 클라이언트가 Pong으로 응답합니다.**
>
> **Q: WebSocket 연결이 끊어졌을 때 재연결 전략은?**
> **A: Exponential backoff: 1초 → 2초 → 4초 → 8초... 최대값까지 대기 시간을 늘립니다. Jitter(랜덤 지연)를 추가하여 서버 복구 시 동시 재연결 폭주를 방지합니다.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **WebSocket vs SSE**: SSE는 단방향(서버→클라이언트), HTTP 위에서 동작, 자동 재연결
> - **Socket.IO**: WebSocket + 폴백(polling), 방(room), 네임스페이스, 자동 재연결
> - **WebSocket 프록시 설정**: Nginx, HAProxy에서 Upgrade 헤더 전달 필요
> - **확장(Extension)**: permessage-deflate(압축)
>
> **Q: WebSocket과 SSE 중 언제 무엇을 선택하나요?**
> **A: SSE 선택: 서버→클라이언트 단방향이면 충분(알림, 피드), HTTP/2 멀티플렉싱 활용, 자동 재연결 기본 지원. WebSocket 선택: 양방향 통신 필요(채팅, 게임), 바이너리 데이터 전송, 낮은 지연. 성능 테스트에서 둘의 지연 차이는 크지 않았습니다.**
>
> **Q: Nginx에서 WebSocket 프록시 설정 방법은?**
> **A:**
> ```nginx
> location /ws {
>     proxy_pass http://backend;
>     proxy_http_version 1.1;
>     proxy_set_header Upgrade $http_upgrade;
>     proxy_set_header Connection "upgrade";
>     proxy_read_timeout 86400;  # 연결 유지 시간
> }
> ```
>
> **Q: Socket.IO를 사용하는 이유와 단점은?**
> **A: 장점: 자동 재연결, 방/네임스페이스로 그룹 관리, 폴백 지원, 이벤트 기반 API. 단점: 프로토콜 오버헤드, 순수 WebSocket 클라이언트와 호환 불가, 서버 리소스 더 사용.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **수평 확장**: Redis Pub/Sub, Kafka 등으로 서버 간 메시지 브로드캐스트
> - **Sticky Session**: 로드밸런서에서 같은 클라이언트를 같은 서버로
> - **WebTransport**: WebSocket의 후속, HTTP/3 기반, 신뢰/비신뢰 스트림
>
> **Q: 수백만 동시 접속 WebSocket을 어떻게 처리하나요?**
> **A: 1) 수평 확장: 여러 서버에 연결 분산, 2) 메시지 브로커(Redis Pub/Sub, Kafka)로 서버 간 메시지 전달, 3) Sticky session 또는 연결 상태를 공유 저장소에, 4) 연결 당 리소스 최소화(경량 프레임워크), 5) 커널 튜닝(파일 디스크립터, 소켓 버퍼).**
>
> **Q: WebSocket 기반 시스템의 장애 대응 전략은?**
> **A: 1) 클라이언트 재연결 로직(exponential backoff), 2) 서버 graceful shutdown(기존 연결 정리 후 종료), 3) 헬스체크 엔드포인트, 4) 메시지 유실 대비(오프라인 큐, 마지막 이벤트 ID), 5) 서킷 브레이커 패턴.**

### 실무 시나리오

**시나리오 1: WebSocket 서버 구현 (Node.js)**
```javascript
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('Client connected');

  ws.on('message', (message) => {
    // 브로드캐스트
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
  });

  ws.on('close', () => console.log('Client disconnected'));
});
```

**시나리오 2: WebSocket 연결 디버깅**
```bash
# wscat으로 테스트
wscat -c ws://localhost:8080

# Chrome DevTools
# Network 탭 → WS 필터 → Messages에서 프레임 확인
```

### 면접 빈출 질문

- **Q: WebSocket이 HTTP보다 효율적인 이유는?**
- **A: 1) 연결 유지로 핸드셰이크 오버헤드 제거, 2) 작은 프레임 헤더(2-14바이트 vs HTTP 수백 바이트), 3) 서버 푸시 가능(폴링 불필요).**

- **Q: WebSocket 연결이 많을 때 서버 리소스 문제는?**
- **A: 각 연결이 파일 디스크립터와 메모리를 사용합니다. 해결: 1) ulimit 증가, 2) 비동기 I/O(epoll/kqueue), 3) 연결 당 메모리 최소화, 4) 유휴 연결 타임아웃.**

---

## 7. Load Balancing

### 개념 설명

로드밸런싱은 들어오는 네트워크 트래픽을 여러 서버에 분산하여 가용성과 성능을 높이는 기술이다. 단일 서버의 과부하를 방지하고, 서버 장애 시에도 서비스 연속성을 보장한다. L4(전송 계층)와 L7(애플리케이션 계층) 로드밸런서가 있으며, 용도에 따라 선택한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 로드밸런서는 트래픽을 여러 서버에 분산
> - 하나의 서버가 죽어도 다른 서버가 처리 (고가용성)
> - 트래픽이 늘면 서버를 추가하여 확장 (수평 확장)
> - 예: AWS ALB/NLB, Nginx, HAProxy
>
> **Q: 로드밸런서가 없으면 어떤 문제가 생기나요?**
> **A: 1) 단일 서버에 트래픽 집중으로 과부하, 2) 서버 장애 시 서비스 중단, 3) 수평 확장 불가. 로드밸런서는 이 문제들을 해결합니다.**
>
> **Q: 로드밸런서의 기본 동작 방식은?**
> **A: 클라이언트는 로드밸런서 IP로 접속하고, 로드밸런서가 정해진 알고리즘에 따라 백엔드 서버 중 하나를 선택하여 요청을 전달합니다.**
>
> **Q: 로드밸런서와 리버스 프록시의 차이는?**
> **A: 로드밸런서는 트래픽 분산이 주 목적이고, 리버스 프록시는 캐싱, SSL 종료, 보안 등 더 넓은 기능을 제공합니다. 실제로 Nginx 같은 소프트웨어는 둘 다 수행합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **L4 로드밸런서**: TCP/UDP 레벨, IP와 포트 기반 라우팅, 빠름
> - **L7 로드밸런서**: HTTP 레벨, URL/헤더/쿠키 기반 라우팅, 유연함
> - **알고리즘**:
>   - Round Robin: 순차적으로 분배
>   - Least Connections: 연결 수가 적은 서버로
>   - IP Hash: 클라이언트 IP 기반 (세션 유지)
>   - Weighted: 서버 용량에 따른 가중치
> - **헬스체크**: 서버 상태 확인, 장애 서버 자동 제외
>
> **Q: L4와 L7 로드밸런서의 차이를 설명해주세요.**
> **A: L4는 TCP/UDP 헤더(IP, 포트)만 보고 빠르게 라우팅합니다. L7은 HTTP 내용(URL, 헤더, 쿠키)을 분석하여 유연한 라우팅이 가능하지만 처리 오버헤드가 있습니다.**
>
> **Q: Least Connections 알고리즘의 장점과 단점은?**
> **A: 장점은 처리 시간이 다양한 요청에서 부하를 균등하게 분배합니다. 단점은 연결 수 추적 오버헤드, 새 서버 추가 시 갑자기 많은 트래픽이 몰릴 수 있음.**
>
> **Q: 헬스체크가 실패하면 어떻게 되나요?**
> **A: 해당 서버를 풀에서 제외하고 다른 서버로 트래픽을 보냅니다. 서버가 복구되어 헬스체크 통과하면 다시 풀에 추가됩니다. 기존 연결은 설정에 따라 유지하거나 끊습니다.**
>
> **Q: Sticky Session(세션 어피니티)이란?**
> **A: 같은 클라이언트의 요청을 항상 같은 서버로 보내는 것입니다. 쿠키나 IP 기반으로 구현하며, 세션 정보가 서버 로컬에 있을 때 필요합니다.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **Connection Draining**: 서버 제거 전 기존 연결 완료 대기
> - **DSR (Direct Server Return)**: 응답이 로드밸런서를 거치지 않음
> - **HAProxy vs Nginx**: HAProxy는 고급 로드밸런싱 특화, Nginx는 웹서버 + 프록시 통합
> - **L7 라우팅 규칙**: 경로 기반(/api → 서버A), 헤더 기반, A/B 테스트
>
> **Q: HAProxy와 Nginx의 선택 기준은?**
> **A: HAProxy: 고급 로드밸런싱(연결 제한, 상세 헬스체크, 통계), 고성능 TCP 프록시. Nginx: 웹서버 + 리버스 프록시 통합, 정적 파일 서빙, 설정 간편. 순수 로드밸런싱은 HAProxy, 웹서버와 통합 필요시 Nginx.**
>
> **Q: L7 로드밸런서에서 가능한 라우팅 전략 예시는?**
> **A: 1) 경로 기반: /api/*는 API 서버, /static/*은 정적 서버, 2) 헤더 기반: User-Agent로 모바일/데스크톱 분리, 3) 가중치 기반: 90% 안정 버전, 10% 카나리, 4) 쿠키 기반: A/B 테스트.**
>
> **Q: DSR(Direct Server Return)의 장단점은?**
> **A: 장점은 응답 트래픽이 로드밸런서를 우회하여 대역폭 절약, 지연 감소. 단점은 설정 복잡(루프백, MAC 변경), L7 기능 사용 불가, 헬스체크 제한.**
>
> **Q: Connection Draining 시간은 어떻게 설정하나요?**
> **A: 가장 긴 요청 처리 시간 + 여유를 고려합니다. 너무 짧으면 요청 중단, 너무 길면 배포 지연. 일반적으로 30-300초, 롱 폴링/WebSocket은 더 길게.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **글로벌 로드밸런싱**: DNS 기반 + Anycast, 지역별 분산
> - **서비스 메시**: Envoy, Istio에서의 클라이언트 사이드 로드밸런싱
> - **로드밸런서 이중화**: Active-Passive, Active-Active, VRRP
> - **비용 최적화**: 클라우드 로드밸런서 vs 자체 구축
>
> **Q: 글로벌 서비스의 로드밸런싱 아키텍처는?**
> **A: 1) DNS 레벨: GeoDNS 또는 Anycast로 가장 가까운 리전으로 라우팅, 2) 리전 레벨: 글로벌 로드밸런서(AWS Global Accelerator, Cloudflare)가 리전 선택, 3) 리전 내: L7 로드밸런서가 서버 분배. 장애 시 DNS TTL과 헬스체크로 리전 간 failover.**
>
> **Q: 서비스 메시에서 로드밸런싱은 어떻게 다른가요?**
> **A: 기존은 중앙 로드밸런서가 분배하지만, 서비스 메시는 각 서비스의 사이드카(Envoy)가 직접 로드밸런싱합니다. 장점: 중앙 병목 제거, 세밀한 제어(서비스별 정책). 단점: 리소스 오버헤드, 복잡성.**
>
> **Q: 로드밸런서 자체의 고가용성은 어떻게 확보하나요?**
> **A: 1) Active-Passive: VRRP로 VIP 공유, 장애 시 자동 전환, 2) Active-Active: DNS로 여러 로드밸런서에 분배, 3) 클라우드: 관리형 로드밸런서(ALB, NLB)는 내부적으로 이중화됨, 4) Anycast: 같은 IP를 여러 위치에서 announce.**

### 실무 시나리오

**시나리오 1: Nginx 로드밸런서 설정**
```nginx
upstream backend {
    least_conn;  # 알고리즘
    server 10.0.0.1:8080 weight=3;
    server 10.0.0.2:8080 weight=2;
    server 10.0.0.3:8080 backup;  # 백업 서버
}

server {
    listen 80;

    location / {
        proxy_pass http://backend;
        proxy_next_upstream error timeout http_500;  # 실패 시 다음 서버
        proxy_connect_timeout 5s;
    }
}
```

**시나리오 2: HAProxy 설정**
```haproxy
frontend http_front
    bind *:80
    default_backend servers

backend servers
    balance roundrobin
    option httpchk GET /health
    http-check expect status 200
    server server1 10.0.0.1:8080 check inter 5s fall 3 rise 2
    server server2 10.0.0.2:8080 check inter 5s fall 3 rise 2
```

### 면접 빈출 질문

- **Q: 세션을 사용하는 애플리케이션에서 로드밸런싱 시 주의점은?**
- **A: 세션이 서버 로컬에 저장되면 다른 서버로 요청 시 세션 유실됩니다. 해결: 1) Sticky Session, 2) 세션을 Redis 등 외부 저장소로 이동, 3) JWT 같은 stateless 인증.**

- **Q: 로드밸런서 앞단에 또 로드밸런서를 두는 이유는?**
- **A: 1) 글로벌 분산(DNS LB → 리전 LB), 2) L4와 L7 분리(L4 NLB → L7 ALB), 3) 로드밸런서 자체의 확장과 이중화.**

---

## 8. CDN (Content Delivery Network)

### 개념 설명

CDN은 전 세계에 분산된 서버(엣지)를 통해 콘텐츠를 사용자와 가까운 위치에서 제공하는 네트워크이다. 지연 시간을 줄이고, 오리진 서버의 부하를 감소시키며, DDoS 방어 등 보안 기능도 제공한다. 이미지, 동영상, 정적 파일뿐 아니라 API 응답도 캐싱할 수 있다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - CDN은 콘텐츠를 사용자와 가까운 서버에서 제공
> - 웹사이트 로딩 속도 향상
> - 예: CloudFront, Cloudflare, Akamai, Fastly
> - 정적 파일(이미지, CSS, JS)에 주로 사용
>
> **Q: CDN을 사용하면 왜 빨라지나요?**
> **A: 사용자와 물리적으로 가까운 서버(엣지)에서 콘텐츠를 제공하여 네트워크 지연이 줄어듭니다. 미국 서버에서 한국으로 100ms 걸리던 것이 한국 엣지에서 10ms로 단축될 수 있습니다.**
>
> **Q: CDN은 어떤 콘텐츠에 효과적인가요?**
> **A: 정적이고 자주 요청되는 콘텐츠: 이미지, CSS, JavaScript, 동영상, 폰트. 변경이 적고 많은 사용자가 같은 파일을 요청할 때 효과적입니다.**
>
> **Q: 모든 웹사이트에 CDN이 필요한가요?**
> **A: 글로벌 사용자가 있거나 트래픽이 많으면 필수입니다. 로컬 서비스나 소규모 사이트는 비용 대비 효과를 고려해야 합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **오리진 (Origin)**: 원본 콘텐츠가 있는 서버
> - **엣지 (Edge)**: 사용자 가까이 있는 CDN 서버
> - **캐시 히트/미스**: 엣지에 콘텐츠가 있으면 히트, 없으면 오리진에서 가져옴
> - **TTL**: 캐시 유지 시간, Cache-Control 헤더로 제어
> - **퍼지/무효화**: 캐시된 콘텐츠를 강제로 삭제
>
> **Q: 캐시 히트율(Cache Hit Ratio)이 중요한 이유는?**
> **A: 히트율이 높을수록 오리진 요청이 줄어 1) 응답 속도 향상, 2) 오리진 부하 감소, 3) 비용 절감. 일반적으로 90% 이상 목표.**
>
> **Q: CDN 캐시를 무효화해야 하는 경우는?**
> **A: 1) 긴급 콘텐츠 수정(오타, 잘못된 정보), 2) 보안 취약점 패치, 3) 새 버전 배포 시 즉시 반영 필요. 단, 무효화보다 버저닝(파일명에 해시)이 더 효율적입니다.**
>
> **Q: Cache-Control 헤더 설정 예시는?**
> **A: `Cache-Control: public, max-age=31536000` (1년, 정적 파일), `Cache-Control: no-cache` (매번 검증), `Cache-Control: private, max-age=0` (캐시 안 함).**
>
> **Q: CDN에서 동적 콘텐츠는 어떻게 처리하나요?**
> **A: 1) 캐시하지 않고 pass-through, 2) 짧은 TTL(1-5초)로 캐시, 3) Stale-while-revalidate로 백그라운드 갱신, 4) Edge Computing으로 엣지에서 동적 처리.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **캐시 전략**:
>   - 버저닝: 파일명에 해시 포함 (app.a1b2c3.js)
>   - Stale-while-revalidate: 만료된 캐시를 일단 제공하고 백그라운드 갱신
>   - Surrogate-Control: CDN 전용 캐시 헤더
> - **캐시 키**: URL + 헤더 + 쿠키 조합으로 캐시 구분
> - **Vary 헤더**: 같은 URL이라도 다른 캐시 (Accept-Encoding, Accept-Language)
> - **Origin Shield**: 오리진 앞에 중간 캐시 계층 추가
>
> **Q: 버저닝과 캐시 무효화 중 무엇을 선택하나요?**
> **A: 버저닝 권장: 파일 변경 시 새 URL이 되어 즉시 새 버전 사용, 캐시 무효화 불필요, 롤백 용이. 무효화는 같은 URL 유지 필요 시(API, 마케팅 URL)만 사용.**
>
> **Q: CloudFront와 Cloudflare의 캐시 무효화 차이는?**
> **A: CloudFront: 무효화 요청 시 전파에 시간 소요(분 단위), 비용 발생(월 1000개 무료). Cloudflare: Instant Purge로 150ms 이내 전파, 무료 플랜에서도 가능. 2024년 Cloudflare는 태그, 호스트명, 프리픽스 기반 퍼지를 모든 플랜에 확대 예정.**
>
> **Q: Origin Shield의 장점은?**
> **A: 1) 오리진 요청 집중 감소(모든 엣지 미스가 오리진 직접 호출 대신 Shield 경유), 2) 오리진 부하 대폭 감소, 3) 동적 콘텐츠에도 캐시 효과. 단점은 추가 비용, 지연 약간 증가.**
>
> **Q: CDN이 캐시하면 안 되는 콘텐츠는?**
> **A: 1) 개인화된 데이터(사용자별 정보), 2) 인증이 필요한 콘텐츠, 3) 실시간 데이터(주식 시세 등), 4) Set-Cookie 응답. 캐시 키 설정 오류로 다른 사용자 데이터가 노출되면 심각한 보안 문제.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **멀티 CDN**: 여러 CDN을 동시 사용하여 가용성과 성능 향상
> - **Edge Computing**: 엣지에서 로직 실행 (CloudFront Functions, Cloudflare Workers)
> - **실시간 분석**: 캐시 히트율, 지연, 오류율 모니터링
> - **비용 최적화**: 리전별 가격, 데이터 전송 최적화
>
> **Q: 멀티 CDN 전략은 언제 필요한가요?**
> **A: 1) 단일 CDN 장애 대비(Netflix 경험), 2) 지역별 최적 CDN 선택, 3) 비용 협상력 확보. 구현: DNS 기반 전환, 리얼타임 성능 측정 기반 라우팅, CDN 추상화 계층.**
>
> **Q: Edge Computing의 활용 사례는?**
> **A: 1) A/B 테스트 (엣지에서 분기), 2) 지역별 콘텐츠 맞춤, 3) 인증 토큰 검증, 4) URL 리라이트/리다이렉트, 5) 봇 감지. 장점: 오리진 부하 감소, 지연 최소화. 주의: 실행 시간 제한, 디버깅 어려움.**
>
> **Q: CDN 비용 최적화 전략은?**
> **A: 1) 캐시 히트율 최대화(버저닝, 적절한 TTL), 2) 압축(Brotli, gzip)으로 대역폭 절감, 3) 이미지 최적화(WebP, 리사이즈), 4) Reserved capacity 계약, 5) 리전별 가격 차이 활용.**

### 실무 시나리오

**시나리오 1: CloudFront + S3 정적 호스팅**
```yaml
# CloudFront 배포 설정 요약
Origins:
  - S3 bucket (OAI로 접근 제한)
Behaviors:
  - /static/*: 캐시 1년, 압축 활성화
  - /api/*: 캐시 안 함, 오리진으로 전달
  - /*: 캐시 1일
Cache Policy:
  - CachingOptimized (정적)
  - CachingDisabled (동적)
```

**시나리오 2: 캐시 무효화 자동화**
```bash
# CloudFront 캐시 무효화
aws cloudfront create-invalidation \
  --distribution-id E1234567890 \
  --paths "/index.html" "/static/*"

# Cloudflare 캐시 퍼지
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/purge_cache" \
  -H "Authorization: Bearer {token}" \
  -d '{"files":["https://example.com/style.css"]}'
```

### 면접 빈출 질문

- **Q: CDN을 도입했는데 오히려 느려진 경우 원인은?**
- **A: 1) 캐시 히트율 낮음(동적 콘텐츠 위주), 2) 오리진-엣지 거리가 오리진-사용자보다 멈(로컬 서비스), 3) TTL 너무 짧음, 4) 캐시 키 설정 오류로 미스 증가.**

- **Q: CDN에서 HTTPS를 사용하려면?**
- **A: 1) CDN에 SSL 인증서 설정(ACM, 업로드), 2) 오리진과 CDN 간 HTTPS 또는 HTTP(내부면 허용), 3) 리다이렉트 설정(HTTP→HTTPS), 4) HSTS 헤더 추가.**

---

## 9. 방화벽과 보안그룹

### 개념 설명

방화벽은 네트워크 트래픽을 규칙에 따라 허용하거나 차단하는 보안 시스템이다. 클라우드 환경에서는 보안그룹(Security Group)과 네트워크 ACL(NACL)이 이 역할을 수행한다. 인바운드(들어오는)와 아웃바운드(나가는) 트래픽을 각각 제어하여 네트워크 경계를 보호한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 방화벽은 네트워크 트래픽을 필터링하는 보안 장치
> - 인바운드: 외부에서 내부로 들어오는 트래픽
> - 아웃바운드: 내부에서 외부로 나가는 트래픽
> - 허용 목록(whitelist) 또는 차단 목록(blacklist) 방식
>
> **Q: 방화벽이 필요한 이유는?**
> **A: 허가되지 않은 접근을 차단하여 서버를 보호합니다. 예: 웹 서버는 80/443 포트만 열고 나머지는 차단하여 공격 표면을 최소화합니다.**
>
> **Q: 인바운드만 막으면 안전한가요?**
> **A: 아닙니다. 아웃바운드도 중요합니다. 서버가 해킹당해 외부로 데이터를 유출하거나 다른 서버를 공격하는 것을 방지해야 합니다.**
>
> **Q: 포트란 무엇이고 왜 특정 포트만 열어야 하나요?**
> **A: 포트는 서비스를 구분하는 번호입니다(HTTP:80, SSH:22). 필요한 포트만 열면 불필요한 서비스 노출을 막아 보안을 강화합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **CIDR 표기법**: IP 범위 표현 (10.0.0.0/24 = 10.0.0.0~10.0.0.255)
> - **AWS Security Group**: 인스턴스 레벨, stateful(응답 자동 허용)
> - **AWS NACL**: 서브넷 레벨, stateless(인바운드/아웃바운드 별도 규칙)
> - **iptables**: Linux 방화벽 도구
>
> **Q: Security Group과 NACL의 차이는?**
> **A: SG는 인스턴스에 적용, stateful(응답 트래픽 자동 허용), 허용 규칙만 가능. NACL은 서브넷에 적용, stateless(양방향 규칙 필요), 허용/거부 모두 가능, 규칙 순서 중요.**
>
> **Q: CIDR /24와 /32의 차이는?**
> **A: /24는 256개 IP(10.0.0.0~10.0.0.255), /32는 단일 IP(10.0.0.1만). 숫자가 클수록 범위가 좁습니다.**
>
> **Q: 0.0.0.0/0은 무엇을 의미하나요?**
> **A: 모든 IP 주소를 의미합니다. 인바운드에서 사용하면 전 세계 어디서나 접근 허용, 신중히 사용해야 합니다(웹 서버 80/443 등에만).**
>
> **Q: Security Group에서 소스로 다른 SG를 지정하는 이유는?**
> **A: IP 대신 SG를 소스로 지정하면, 해당 SG에 속한 모든 인스턴스에서 접근을 허용합니다. IP 변경에 유연하고 관리가 쉽습니다(예: ALB SG → 웹서버 SG).**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **iptables 체인**: INPUT(인바운드), OUTPUT(아웃바운드), FORWARD(라우팅)
> - **규칙 순서**: NACL은 번호 순, iptables는 위에서 아래로 매칭
> - **연결 추적 (Connection Tracking)**: stateful 방화벽의 핵심
> - **로깅**: 거부된 트래픽 로그로 공격 탐지, 디버깅
>
> **Q: iptables 기본 규칙 작성 방법은?**
> **A:**
> ```bash
> # 기본 정책: 모두 거부
> iptables -P INPUT DROP
> iptables -P FORWARD DROP
> iptables -P OUTPUT ACCEPT
>
> # 허용 규칙 추가
> iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT
> iptables -A INPUT -p tcp --dport 80 -j ACCEPT
> iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
> ```
>
> **Q: stateful과 stateless 방화벽의 동작 차이는?**
> **A: stateful은 연결 상태를 추적하여 아웃바운드 요청의 응답은 자동 허용합니다. stateless는 각 패킷을 독립적으로 평가하여 응답도 별도 규칙이 필요합니다.**
>
> **Q: NACL에서 Ephemeral Port를 열어야 하는 이유는?**
> **A: 클라이언트가 서버에 연결할 때 임시 포트(1024-65535)를 사용합니다. NACL은 stateless라 아웃바운드 응답이 이 포트로 가므로 열어야 합니다.**
>
> **Q: 방화벽 규칙 변경 시 주의점은?**
> **A: 1) 테스트 환경에서 먼저 검증, 2) 롤백 계획 수립, 3) SSH 접속 규칙은 마지막에 변경(잠금 방지), 4) 점진적 적용, 5) 변경 후 연결 테스트.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **마이크로세그멘테이션**: 워크로드별 세밀한 네트워크 격리
> - **Zero Trust Network**: 네트워크 위치와 무관하게 모든 접근 검증
> - **차세대 방화벽 (NGFW)**: 애플리케이션 인식, IPS 통합
> - **WAF**: 웹 애플리케이션 방화벽, L7 공격 방어 (SQL Injection, XSS)
>
> **Q: 마이크로세그멘테이션의 구현 방법은?**
> **A: 1) 각 워크로드에 개별 보안 그룹, 2) 서비스 메시(Istio)의 네트워크 정책, 3) 호스트 기반 방화벽, 4) SDN(Software Defined Network). 목표: 침해 시 lateral movement 최소화.**
>
> **Q: Zero Trust Network Access(ZTNA) 구현 고려사항은?**
> **A: 1) 사용자/디바이스 인증 강화(MFA, 디바이스 인증서), 2) 최소 권한 원칙, 3) 지속적 검증(세션 중에도), 4) 네트워크 세그멘테이션, 5) 암호화(mTLS). 기존 VPN 대체 트렌드.**
>
> **Q: WAF 규칙 설정 전략은?**
> **A: 1) 관리형 규칙(OWASP Core Rule Set) 기본 적용, 2) 오탐(false positive) 모니터링 후 예외 처리, 3) Rate limiting으로 DDoS 완화, 4) 커스텀 규칙은 최소한으로, 5) 로깅 활성화로 공격 분석.**

### 실무 시나리오

**시나리오 1: AWS 3-tier 아키텍처 보안그룹 설계**
```
[인터넷] → [ALB SG: 80,443 from 0.0.0.0/0]
         → [Web SG: 8080 from ALB-SG]
         → [App SG: 8080 from Web-SG]
         → [DB SG: 3306 from App-SG]
         → [Bastion SG: 22 from 회사IP/32]
```

**시나리오 2: iptables 기본 보안 설정**
```bash
# 기존 규칙 초기화
iptables -F

# 기본 정책
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 루프백 허용
iptables -A INPUT -i lo -j ACCEPT

# 기존 연결 허용 (stateful)
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH (특정 IP만)
iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT

# HTTP/HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# 나머지 거부 로깅
iptables -A INPUT -j LOG --log-prefix "DROPPED: "
```

### 면접 빈출 질문

- **Q: 보안그룹만으로 충분한가요, NACL도 필요한가요?**
- **A: 대부분 SG로 충분하지만, NACL은 서브넷 전체에 적용되어 추가 방어층(defense in depth)을 제공합니다. 특정 IP 차단, 규정 준수 요구사항이 있을 때 NACL 사용.**

- **Q: 실수로 SSH 포트를 막으면 어떻게 복구하나요?**
- **A: AWS: 콘솔에서 SG 수정, 세션 매니저로 접속, 인스턴스 중지 후 EBS를 다른 인스턴스에 연결하여 수정. 온프레미스: 물리적/콘솔 접근, IPMI/iLO, 네트워크 장비에서 규칙 수정.**

---

## 10. 기타 네트워크 개념

### NAT (Network Address Translation)

> ⭐ **Level 1 (입문)**
> - NAT은 사설 IP를 공인 IP로 변환
> - 가정의 공유기가 대표적인 NAT 장치
> - IPv4 주소 부족 문제 해결에 기여
>
> **Q: NAT가 필요한 이유는?**
> **A: IPv4 주소는 약 43억 개로 부족합니다. NAT으로 여러 기기가 하나의 공인 IP를 공유할 수 있어 주소 절약이 가능합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **SNAT (Source NAT)**: 출발지 IP 변환 (내부→외부)
> - **DNAT (Destination NAT)**: 목적지 IP 변환 (포트 포워딩)
> - **PAT (Port Address Translation)**: 포트로 여러 내부 IP 구분
> - **AWS NAT Gateway**: 프라이빗 서브넷의 아웃바운드 인터넷 접근
>
> **Q: AWS에서 프라이빗 서브넷의 인스턴스가 인터넷에 접근하려면?**
> **A: NAT Gateway를 퍼블릭 서브넷에 배치하고, 프라이빗 서브넷의 라우팅 테이블에서 0.0.0.0/0 → NAT Gateway로 설정합니다.**

### VPN (Virtual Private Network)

> ⭐⭐ **Level 2 (주니어)**
> - VPN은 공용 네트워크를 통해 암호화된 터널 생성
> - Site-to-Site VPN: 네트워크 간 연결 (사무실 ↔ AWS)
> - Client VPN: 개인이 네트워크에 접속
> - 프로토콜: IPSec, OpenVPN, WireGuard
>
> **Q: VPN과 전용선의 차이는?**
> **A: VPN은 인터넷을 통해 암호화된 터널을 만들어 비용이 저렴하지만 인터넷 품질에 의존합니다. 전용선(Direct Connect)은 물리적 전용 회선으로 안정적이지만 비용이 높습니다.**

### ARP (Address Resolution Protocol)

> ⭐⭐ **Level 2 (주니어)**
> - ARP는 IP 주소를 MAC 주소로 변환
> - 같은 네트워크 내에서 통신 시 필요
> - ARP 캐시: 조회 결과 저장
> - ARP Spoofing: 공격자가 MAC 주소를 위조하는 공격
>
> **Q: ARP Spoofing 공격과 방어 방법은?**
> **A: 공격자가 자신의 MAC을 게이트웨이 IP에 매핑시켜 트래픽을 가로챕니다. 방어: 정적 ARP 테이블, ARP Inspection, VPN으로 암호화.**

### DHCP (Dynamic Host Configuration Protocol)

> ⭐⭐ **Level 2 (주니어)**
> - DHCP는 IP 주소를 자동으로 할당
> - DORA 과정: Discover → Offer → Request → Acknowledge
> - 임대(Lease) 방식: 일정 시간 후 갱신 필요
> - 예약(Reservation): 특정 MAC에 고정 IP 할당
>
> **Q: DHCP 서버가 없으면 어떻게 되나요?**
> **A: 클라이언트가 IP를 받지 못해 네트워크 통신 불가합니다. APIPA(169.254.x.x)를 자동 할당하지만 로컬 네트워크 외부 통신은 안 됩니다.**

### VLAN (Virtual LAN)

> ⭐⭐⭐ **Level 3 (시니어)**
> - VLAN은 물리적 네트워크를 논리적으로 분할
> - 브로드캐스트 도메인 분리
> - 802.1Q 태깅: 프레임에 VLAN ID 추가
> - 트렁크 포트: 여러 VLAN 트래픽 전달
>
> **Q: VLAN을 사용하는 이유는?**
> **A: 1) 보안(부서별 격리), 2) 브로드캐스트 트래픽 감소, 3) 유연한 네트워크 구성(물리적 위치와 무관하게 그룹핑). 예: 개발팀 VLAN, 운영팀 VLAN 분리.**

### 라우팅

> ⭐⭐ **Level 2 (주니어)**
> - 라우팅은 패킷의 최적 경로를 결정
> - 정적 라우팅: 수동 설정, 소규모 네트워크
> - 동적 라우팅: OSPF, BGP 등 프로토콜로 자동 결정
> - 라우팅 테이블: 목적지별 다음 홉(next hop) 정보
>
> **Q: 0.0.0.0/0 라우트(default route)란?**
> **A: 다른 규칙에 매칭되지 않는 모든 트래픽의 기본 경로입니다. 보통 인터넷 게이트웨이나 NAT을 가리킵니다.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **BGP (Border Gateway Protocol)**: 인터넷 라우팅의 핵심, AS 간 경로 교환
> - **AWS Transit Gateway**: 여러 VPC와 온프레미스 네트워크 허브
> - **SD-WAN**: 소프트웨어 정의 WAN, 동적 경로 최적화
>
> **Q: BGP hijacking이란?**
> **A: 공격자가 자신의 네트워크를 다른 IP 대역의 오리진으로 광고하여 트래픽을 가로채는 공격입니다. 방어: RPKI(Resource Public Key Infrastructure)로 경로 출처 검증.**

---

## 참고 자료

- [Cloudflare Learning Center](https://www.cloudflare.com/learning/)
- [AWS Networking Documentation](https://docs.aws.amazon.com/vpc/)
- [Mozilla Developer Network (MDN) - HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP)
- [High Performance Browser Networking](https://hpbn.co/)
- [HTTP/3 Performance Guide 2025](https://medium.com/@ntiinsd/http-1-1-vs-http-2-vs-http-3-the-ultimate-performance-guide-for-2025-670b1f1eabf5)
- [TLS 1.3 Overview](https://www.encryptionconsulting.com/tls-1-2-and-tls-1-3/)
