# 보안 (Security) - IT 서비스 운영 필수 지식

> 이 문서는 IT 서비스 운영에 필요한 보안 지식을 레벨별로 정리한 학습 자료입니다.
> 퀴즈 생성 및 역량 평가에 활용할 수 있습니다.

## 레벨 가이드

| 레벨 | 대상 | 설명 |
|------|------|------|
| ⭐ Level 1 | 입문 | 개념 이해, 기본 용어 |
| ⭐⭐ Level 2 | 주니어 | 실무 적용, 트러블슈팅 기초 |
| ⭐⭐⭐ Level 3 | 시니어 | 아키텍처 설계, 성능 최적화 |
| ⭐⭐⭐⭐ Level 4 | 리드/CTO | 전략적 의사결정, 대규모 설계 |

---

## 1. 인증과 인가 (Authentication & Authorization)

### 개념 설명

인증(Authentication)은 "누구인가?"를 확인하는 과정이고, 인가(Authorization)는 "무엇을 할 수 있는가?"를 결정하는 과정이다. 이 두 개념은 보안의 기초이며, 모든 애플리케이션에서 올바르게 구현되어야 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 인증(Authentication): 사용자가 누구인지 확인 (로그인)
> - 인가(Authorization): 사용자가 무엇을 할 수 있는지 결정 (권한)
> - 인증 방식: 비밀번호, 생체인식, OTP, 인증서
> - 세션과 토큰: 로그인 상태를 유지하는 방법
>
> **Q: 인증과 인가의 차이를 비유로 설명해주세요.**
> **A: 인증은 건물 입구에서 신분증을 확인하는 것(누구인지), 인가는 특정 층이나 방에 들어갈 수 있는 출입 권한을 확인하는 것(무엇을 할 수 있는지)입니다.**
>
> **Q: 비밀번호만으로 충분한 보안이 되나요?**
> **A: 아닙니다. 비밀번호는 유출, 추측, 피싱에 취약합니다. MFA(다중 인증)를 추가하여 보안을 강화해야 합니다.**
>
> **Q: 세션과 토큰의 기본 차이는?**
> **A: 세션은 서버에 상태를 저장하고 세션 ID만 클라이언트에 전달, 토큰(JWT 등)은 클라이언트에 정보를 담아 서버가 stateless하게 동작합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **세션 기반 인증**: 서버에 세션 저장, 세션 ID를 쿠키로 전달
> - **토큰 기반 인증**: JWT 등 토큰에 정보 포함, 서버 stateless
> - **MFA (Multi-Factor Authentication)**: 2개 이상의 인증 요소 조합
>   - 지식(Something you know): 비밀번호, PIN
>   - 소유(Something you have): 휴대폰, 하드웨어 키
>   - 생체(Something you are): 지문, 얼굴
> - **비밀번호 저장**: 평문 금지, bcrypt/argon2로 해싱
>
> **Q: 세션 vs 토큰 인증의 장단점은?**
> **A: 세션: 서버에서 무효화 쉬움, 하지만 서버 확장 시 세션 공유 필요(Redis 등). 토큰: stateless로 확장 용이, 하지만 발급 후 무효화 어려움(만료까지 유효).**
>
> **Q: 비밀번호를 해시할 때 MD5나 SHA-256을 쓰면 안 되는 이유는?**
> **A: 너무 빨라서 brute force 공격에 취약합니다. bcrypt, argon2, scrypt는 의도적으로 느리게 설계되어 공격 비용을 높입니다.**
>
> **Q: 세션 고정 공격(Session Fixation)이란?**
> **A: 공격자가 미리 알고 있는 세션 ID를 피해자가 사용하도록 유도하는 공격입니다. 방어: 로그인 성공 시 새 세션 ID 발급.**
>
> **Q: MFA에서 SMS OTP의 취약점은?**
> **A: SIM 스와핑, SS7 취약점으로 SMS 가로채기 가능. TOTP(Google Authenticator)나 하드웨어 키(YubiKey)가 더 안전합니다.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **JWT (JSON Web Token)**: Header.Payload.Signature 구조
>   - 알고리즘: HS256(대칭키), RS256/ES256(비대칭키)
>   - 클레임: iss(발급자), sub(주체), aud(대상), exp(만료), iat(발급시간)
>   - 취약점: none 알고리즘, 키 혼동, 만료 검증 누락
> - **OAuth 2.0 플로우**:
>   - Authorization Code: 서버 사이드 앱용, 가장 안전
>   - Authorization Code + PKCE: SPA/모바일 앱용, 권장
>   - Client Credentials: 서비스 간 통신
>   - (Deprecated) Implicit: 보안 취약, 사용 금지
> - **Refresh Token**: Access Token 만료 시 재발급용
>
> **Q: JWT의 주요 보안 취약점과 방어 방법은?**
> **A: 1) none 알고리즘: 허용된 알고리즘 화이트리스트 적용, 2) 키 혼동(RS256을 HS256으로): 알고리즘 검증 후 해당 키 사용, 3) 만료 미검증: exp, nbf, iss, aud 클레임 필수 검증, 4) 민감 정보 노출: Payload는 암호화되지 않으므로 민감 정보 포함 금지.**
>
> **Q: PKCE가 필요한 이유는?**
> **A: SPA나 모바일 앱은 client_secret을 안전하게 보관할 수 없습니다. PKCE는 code_verifier/code_challenge로 Authorization Code 가로채기 공격을 방어합니다. OAuth 2.1에서는 모든 클라이언트에 PKCE가 필수입니다.**
>
> **Q: Access Token과 Refresh Token을 분리하는 이유는?**
> **A: Access Token은 짧은 만료(15분-1시간)로 유출 시 피해 최소화. Refresh Token은 긴 만료, 안전한 저장소에 보관, Access Token 재발급에만 사용.**
>
> **Q: Refresh Token Rotation이란?**
> **A: Refresh Token 사용 시 새 Refresh Token을 발급하고 기존 것을 무효화합니다. 토큰 유출 시 공격자와 정상 사용자 중 하나만 유효한 토큰을 가지게 되어 탐지 가능.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **OIDC (OpenID Connect)**: OAuth 2.0 위에 인증 레이어 추가, ID Token 제공
> - **SAML**: 엔터프라이즈 SSO 표준, XML 기반
> - **SSO (Single Sign-On)**: 한 번 로그인으로 여러 서비스 이용
> - **RBAC vs ABAC**:
>   - RBAC (Role-Based): 역할에 권한 부여 (Admin, Editor, Viewer)
>   - ABAC (Attribute-Based): 속성 기반 동적 권한 (부서, 시간, 위치 등)
> - **Passkey/WebAuthn**: 비밀번호 없는 인증, 피싱 저항성
>
> **Q: OIDC와 OAuth 2.0의 차이는?**
> **A: OAuth 2.0은 인가(Authorization) 프로토콜로 "무엇을 할 수 있는가"만 다룹니다. OIDC는 OAuth 2.0 위에 인증(Authentication) 레이어를 추가하여 ID Token으로 "누구인가"를 확인합니다.**
>
> **Q: 대규모 조직에서 RBAC의 한계와 ABAC으로 전환하는 이유는?**
> **A: RBAC은 역할이 폭발적으로 증가(Role Explosion)할 수 있고, 세밀한 제어가 어렵습니다. ABAC은 동적 조건을 조합할 수 있어 유연합니다.**
>
> **Q: Passkey(WebAuthn)의 보안 이점은?**
> **A: 1) 피싱 저항: 도메인에 바인딩되어 가짜 사이트에서 사용 불가, 2) 개인 키는 디바이스를 떠나지 않음, 3) 서버에 비밀 저장 없음(공개 키만 저장).**
>
> **Q: 제로 트러스트 환경에서 인증 아키텍처는?**
> **A: 1) 지속적 인증(Continuous Authentication): 세션 중에도 주기적 검증, 2) 위험 기반 인증: 이상 행동 감지 시 추가 인증, 3) 디바이스 신뢰: 디바이스 인증서/상태 확인, 4) 최소 권한.**

### 실무 시나리오

**시나리오 1: JWT 구현 체크리스트**
```javascript
// 안전한 JWT 검증 예시
const jwt = require('jsonwebtoken');

function verifyToken(token) {
  // 1. 허용된 알고리즘만 지정
  const options = {
    algorithms: ['RS256'],  // none, HS256 허용 안 함
    issuer: 'https://auth.example.com',
    audience: 'api.example.com',
  };

  try {
    // 2. 공개 키로 검증 (비대칭)
    const decoded = jwt.verify(token, publicKey, options);

    // 3. 추가 클레임 검증
    if (decoded.exp < Date.now() / 1000) {
      throw new Error('Token expired');
    }

    return decoded;
  } catch (err) {
    throw new Error('Invalid token');
  }
}
```

**시나리오 2: OAuth 2.0 + PKCE 플로우**
```
1. 클라이언트: code_verifier 생성 (랜덤 문자열)
2. 클라이언트: code_challenge = SHA256(code_verifier)
3. 클라이언트 -> Auth Server: /authorize?code_challenge=XXX
4. 사용자 인증 후 Auth Server -> 클라이언트: authorization_code
5. 클라이언트 -> Auth Server: /token + code + code_verifier
6. Auth Server: SHA256(code_verifier) == code_challenge 검증
7. Auth Server -> 클라이언트: access_token, refresh_token
```

### 면접 빈출 질문

- **Q: 401 Unauthorized와 403 Forbidden의 차이는?**
- **A: 401은 인증 실패(누구인지 모르거나 인증 정보 없음), 403은 인가 실패(누구인지 알지만 권한 없음).**

- **Q: 로그아웃 시 JWT를 어떻게 무효화하나요?**
- **A: JWT는 stateless라 서버에서 직접 무효화할 수 없습니다. 방법: 1) 블랙리스트(Redis에 무효화된 토큰 저장), 2) 짧은 만료 시간 + Refresh Token 무효화, 3) 토큰 버전 관리.**

---

## 2. OWASP Top 10 웹 보안 위협

### 개념 설명

OWASP(Open Web Application Security Project)는 웹 애플리케이션 보안을 위한 비영리 재단으로, 가장 위험한 웹 취약점 Top 10을 정기적으로 발표한다. 이 목록은 개발자와 보안 전문가가 우선적으로 대응해야 할 위협을 정의한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - OWASP Top 10은 가장 위험한 웹 취약점 목록
> - 개발자라면 기본으로 알아야 할 보안 지식
> - 주요 위협: 인젝션, 인증 실패, 민감 데이터 노출
> - 보안은 개발 초기부터 고려해야 함 (Shift Left)
>
> **Q: OWASP Top 10을 알아야 하는 이유는?**
> **A: 실제 공격의 대부분이 이 목록의 취약점을 이용합니다. 이를 이해하고 방어하면 대부분의 일반적인 공격을 막을 수 있습니다.**
>
> **Q: 보안 취약점은 누가 책임져야 하나요?**
> **A: 개발팀, 운영팀, 보안팀 모두의 책임입니다. 특히 개발자가 코드 작성 시 보안을 고려하는 것이 가장 효과적입니다.**

> ⭐⭐ **Level 2 (주니어)**
>
> **A01: Broken Access Control (접근 제어 실패)** - 1위
> - 다른 사용자의 데이터에 무단 접근
> - 예: /user/123을 /user/124로 변경하여 다른 사용자 정보 조회 (IDOR)
> - 방어: 모든 요청에서 권한 검증, 서버 측 접근 제어
>
> **A02: Cryptographic Failures (암호화 실패)** - 2위
> - 민감 데이터의 부적절한 암호화 또는 평문 저장
> - 예: 비밀번호 평문 저장, HTTP로 민감 정보 전송
> - 방어: TLS 필수, 강력한 암호화 알고리즘, 키 관리
>
> **A03: Injection (인젝션)** - 3위
> - 사용자 입력이 명령어/쿼리로 해석됨
> - SQL Injection, Command Injection, XSS
> - 방어: Prepared Statement, 입력 검증, 출력 인코딩
>
> **Q: SQL Injection 공격 예시와 방어 방법은?**
> **A: 공격: `' OR '1'='1` 입력으로 인증 우회. 방어: Prepared Statement 사용**
> ```sql
> -- 취약한 코드
> query = "SELECT * FROM users WHERE id = '" + userId + "'";
>
> -- 안전한 코드 (Prepared Statement)
> query = "SELECT * FROM users WHERE id = ?";
> stmt.setString(1, userId);
> ```
>
> **Q: XSS(Cross-Site Scripting) 공격이란?**
> **A: 악성 스크립트를 웹 페이지에 삽입하여 다른 사용자의 브라우저에서 실행시키는 공격입니다. 종류: Stored(저장형), Reflected(반사형), DOM-based. 방어: 출력 시 HTML 인코딩, CSP 헤더, HttpOnly 쿠키.**
>
> **Q: IDOR(Insecure Direct Object Reference)란?**
> **A: URL이나 파라미터의 식별자를 변경하여 다른 사용자의 리소스에 접근하는 공격입니다. 방어: 요청마다 리소스 소유권 확인.**

> ⭐⭐⭐ **Level 3 (시니어)**
>
> **A04: Insecure Design (안전하지 않은 설계)**
> - 설계 단계의 보안 결함
> - 방어: 위협 모델링, 보안 설계 원칙
>
> **A05: Security Misconfiguration (보안 설정 오류)**
> - 기본 설정, 불필요한 기능 활성화, 상세 에러 메시지
> - 방어: 하드닝 가이드, 최소 기능 원칙, 정기 점검
>
> **A06: Vulnerable Components (취약한 컴포넌트)**
> - 취약점이 있는 라이브러리/프레임워크 사용
> - 방어: 의존성 스캔(Snyk, Dependabot), SBOM, 정기 업데이트
>
> **A07: Authentication Failures (인증 실패)**
> - 약한 비밀번호 정책, 무차별 대입 허용
> - 방어: MFA, 강력한 비밀번호 정책, 계정 잠금
>
> **Q: CSRF(Cross-Site Request Forgery) 공격과 방어는?**
> **A: 사용자가 인증된 상태에서 악성 사이트가 요청을 위조하여 전송하는 공격입니다. 방어: 1) CSRF 토큰 검증, 2) SameSite 쿠키 속성, 3) Referer/Origin 헤더 검증.**
>
> **Q: 보안 설정 오류를 방지하는 체계적인 방법은?**
> **A: 1) 하드닝 체크리스트 적용, 2) IaC로 일관된 설정, 3) 정기 보안 스캔(CIS Benchmark), 4) 불필요한 기능/포트/계정 제거.**
>
> **Q: 의존성 취약점 관리 전략은?**
> **A: 1) CI/CD에 의존성 스캔 통합(Snyk, Trivy), 2) Dependabot으로 자동 PR, 3) 취약점 심각도별 대응 SLA, 4) SBOM 생성.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
>
> **A08: Software and Data Integrity Failures (무결성 실패)**
> - 코드/데이터의 무결성 미검증
> - 방어: 디지털 서명, CI/CD 파이프라인 보안
>
> **A09: Security Logging and Monitoring Failures (로깅/모니터링 실패)**
> - 보안 이벤트 미기록, 침해 탐지 실패
> - 방어: 감사 로그, SIEM, 알림 규칙
>
> **A10: Server-Side Request Forgery (SSRF)**
> - 서버가 공격자가 지정한 URL로 요청
> - 방어: URL 화이트리스트, 내부 네트워크 차단
>
> **Q: SSRF 공격의 위험성과 클라우드 환경에서의 영향은?**
> **A: SSRF로 내부 네트워크, 클라우드 메타데이터(AWS IAM 자격 증명), 내부 서비스에 접근할 수 있습니다.**
>
> **Q: 보안 로깅에서 반드시 기록해야 할 이벤트는?**
> **A: 1) 인증 이벤트(성공/실패), 2) 인가 실패, 3) 입력 검증 실패, 4) 관리자 작업, 5) 민감 데이터 접근, 6) 설정 변경. 로그에는 민감 정보 포함 금지.**
>
> **Q: 공급망 공격(Supply Chain Attack) 대응 전략은?**
> **A: 1) 의존성 잠금(lock file), 2) 무결성 검증(체크섬, 서명), 3) 신뢰할 수 있는 레지스트리만 사용, 4) 최소 의존성 원칙, 5) sigstore 활용.**

### 실무 시나리오

**시나리오 1: SQL Injection 방어**
```python
# 취약한 코드
cursor.execute(f"SELECT * FROM users WHERE email = '{email}'")

# 안전한 코드 (Parameterized Query)
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))

# ORM 사용 (SQLAlchemy)
user = session.query(User).filter(User.email == email).first()
```

**시나리오 2: XSS 방어**
```javascript
// 취약한 코드 - DOM에 사용자 입력을 그대로 삽입
// 안전한 코드
element.textContent = userInput;  // HTML 해석 안 함

// HTML이 필요한 경우 DOMPurify 같은 sanitizer 사용
const cleanHTML = DOMPurify.sanitize(userInput);
```

**시나리오 3: SSRF 방어**
```python
import ipaddress
from urllib.parse import urlparse

def is_safe_url(url):
    parsed = urlparse(url)

    # 허용된 도메인만
    allowed_domains = ['api.example.com', 'cdn.example.com']
    if parsed.hostname not in allowed_domains:
        return False

    # 내부 IP 차단
    try:
        ip = ipaddress.ip_address(parsed.hostname)
        if ip.is_private or ip.is_loopback:
            return False
    except ValueError:
        pass  # 도메인인 경우

    return True
```

### 면접 빈출 질문

- **Q: 보안 테스트는 언제 수행해야 하나요?**
- **A: Shift Left: 개발 초기부터. 1) 설계 단계: 위협 모델링, 2) 개발 중: SAST, 3) 빌드 시: 의존성 스캔, 4) 배포 전: DAST, 5) 운영 중: 펜테스트.**

- **Q: Zero-Day 취약점에 어떻게 대응하나요?**
- **A: 1) 보안 뉴스 모니터링, 2) 신속한 패치 프로세스, 3) WAF 규칙 업데이트, 4) 네트워크 세그멘테이션, 5) 침해 지표(IoC) 모니터링.**

---

## 3. 암호화 (Cryptography)

### 개념 설명

암호화는 데이터를 읽을 수 없는 형태로 변환하여 기밀성을 보호하는 기술이다. 대칭키 암호화, 비대칭키 암호화, 해시 함수 등 다양한 암호화 기법이 있으며, 용도에 맞게 올바르게 사용해야 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 암호화(Encryption): 데이터를 읽을 수 없게 변환, 복호화 가능
> - 해시(Hash): 단방향 변환, 복호화 불가
> - 대칭키: 암호화/복호화에 같은 키 사용 (AES)
> - 비대칭키: 공개키/개인키 쌍 사용 (RSA)
>
> **Q: 암호화와 해시의 차이는?**
> **A: 암호화는 키로 복호화하여 원본을 복구할 수 있고, 해시는 단방향이라 원본 복구가 불가능합니다.**
>
> **Q: 비밀번호는 왜 암호화가 아닌 해시로 저장하나요?**
> **A: 암호화는 키가 유출되면 모든 비밀번호가 복호화됩니다. 해시는 단방향이라 원본을 알 수 없습니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **AES (Advanced Encryption Standard)**: 대칭키 암호화 표준
>   - AES-256: 256비트 키, 가장 강력
>   - 모드: CBC(체이닝), GCM(인증 포함), CTR(스트림)
> - **RSA**: 비대칭키 암호화, 키 교환/서명에 사용
> - **해시 함수**: SHA-256(범용), bcrypt/argon2(비밀번호)
> - **Salt**: 해시에 랜덤 값 추가하여 레인보우 테이블 방지
>
> **Q: AES의 CBC와 GCM 모드의 차이는?**
> **A: CBC는 암호화만 제공하고 별도의 MAC이 필요합니다. GCM은 암호화 + 인증(무결성 검증)을 동시에 제공하여 더 안전합니다.**
>
> **Q: 왜 비밀번호에 일반 SHA-256 대신 bcrypt를 사용하나요?**
> **A: SHA-256은 빠르게 설계되어 GPU로 초당 수십억 번 해시 가능합니다. bcrypt는 의도적으로 느려서 brute force 공격에 강합니다.**
>
> **Q: Salt와 Pepper의 차이는?**
> **A: Salt는 각 비밀번호마다 다른 랜덤 값으로 DB에 함께 저장. Pepper는 모든 비밀번호에 동일하게 적용하는 비밀 키로 코드/환경변수에 저장.**
>
> **Q: 암호화 키를 코드에 하드코딩하면 안 되는 이유는?**
> **A: 1) 소스 코드 유출 시 키 노출, 2) 키 교체 어려움, 3) 환경별 키 분리 불가. 대신 환경변수, Vault, KMS 사용.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **ECDSA/EdDSA**: 타원 곡선 기반 서명, RSA보다 작은 키로 동일 보안
> - **Key Exchange**: Diffie-Hellman, ECDHE(Perfect Forward Secrecy)
> - **TLS 1.3**: 취약 암호 제거, 1-RTT 핸드셰이크, 0-RTT 재연결
> - **PKI**: 인증서 체인, 루트 CA -> 중간 CA -> 엔드 인증서
> - **HSM (Hardware Security Module)**: 키를 하드웨어로 보호
>
> **Q: Perfect Forward Secrecy(PFS)가 중요한 이유는?**
> **A: PFS 없이 정적 RSA 키를 사용하면, 서버 개인 키 유출 시 과거에 캡처된 모든 트래픽을 복호화할 수 있습니다. PFS(ECDHE 등)는 각 세션마다 임시 키를 생성합니다.**
>
> **Q: TLS 1.3에서 제거된 취약한 요소들은?**
> **A: 1) 정적 RSA 키 교환, 2) CBC 모드, 3) RC4, 3DES, 4) SHA-1, MD5, 5) 압축(CRIME 공격). 남은 것은 AEAD 암호(AES-GCM, ChaCha20)와 ECDHE 키 교환뿐.**
>
> **Q: 데이터 암호화 시 키 관리 전략은?**
> **A: 1) DEK/KEK 구조: 데이터 암호화 키(DEK)를 마스터 키(KEK)로 암호화, 2) 키 로테이션: 정기적 키 교체, 3) KMS 사용: AWS KMS, GCP Cloud KMS.**
>
> **Q: 인증서 체인 검증 과정을 설명해주세요.**
> **A: 1) 서버 인증서의 발급자가 중간 CA인지 확인, 2) 중간 CA 인증서가 루트 CA로 서명되었는지 확인, 3) 루트 CA가 시스템 신뢰 저장소에 있는지 확인, 4) 각 인증서의 유효기간, 용도, 폐기 상태 확인.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **Post-Quantum Cryptography**: 양자 컴퓨터 대응 암호화
>   - NIST 표준: CRYSTALS-Kyber(키 교환), CRYSTALS-Dilithium(서명)
>   - 하이브리드 접근: 기존 + PQ 알고리즘 병행
> - **Crypto Agility**: 암호 알고리즘을 쉽게 교체할 수 있는 설계
> - **Key Ceremony**: HSM 초기화, 마스터 키 생성 절차
> - **Envelope Encryption**: 대규모 데이터 암호화 패턴
>
> **Q: 양자 컴퓨팅 시대에 현재 암호화가 위험한 이유는?**
> **A: Shor 알고리즘은 RSA, ECDSA 등 현재 비대칭키 암호를 다항 시간에 해독합니다. "지금 수집, 나중에 해독" 공격에 대비해 장기 보관 데이터는 PQ 암호화를 고려해야 합니다. 2024년 NIST가 최종 PQ 표준을 발표했습니다.**
>
> **Q: Crypto Agility를 위한 설계 원칙은?**
> **A: 1) 암호 알고리즘을 추상화하여 교체 용이하게, 2) 알고리즘/키 버전 메타데이터 포함, 3) 설정 기반 알고리즘 선택, 4) 여러 알고리즘 동시 지원(전환 기간).**
>
> **Q: 대규모 서비스의 암호화 아키텍처는?**
> **A: 1) Envelope Encryption: DEK로 데이터 암호화, KEK로 DEK 암호화, 2) 계층적 키 관리: 루트 키 -> 리전 키 -> 서비스 키, 3) KMS로 KEK 관리, DEK만 로컬 처리.**

### 실무 시나리오

**시나리오 1: 비밀번호 해싱 (Python)**
```python
import bcrypt

# 비밀번호 해싱
def hash_password(password: str) -> bytes:
    salt = bcrypt.gensalt(rounds=12)  # work factor
    return bcrypt.hashpw(password.encode(), salt)

# 비밀번호 검증
def verify_password(password: str, hashed: bytes) -> bool:
    return bcrypt.checkpw(password.encode(), hashed)
```

**시나리오 2: AES-GCM 암호화 (Python)**
```python
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import os

def encrypt(plaintext: bytes, key: bytes) -> tuple[bytes, bytes]:
    nonce = os.urandom(12)  # 96-bit nonce
    aesgcm = AESGCM(key)
    ciphertext = aesgcm.encrypt(nonce, plaintext, None)
    return nonce, ciphertext

def decrypt(nonce: bytes, ciphertext: bytes, key: bytes) -> bytes:
    aesgcm = AESGCM(key)
    return aesgcm.decrypt(nonce, ciphertext, None)
```

### 면접 빈출 질문

- **Q: HTTPS만 적용하면 데이터가 안전한가요?**
- **A: HTTPS는 전송 중 암호화만 제공합니다. 저장 데이터 암호화(at-rest), 애플리케이션 레벨 암호화, 접근 제어, 키 관리가 별도로 필요합니다.**

- **Q: 암호화 관련 흔한 실수는?**
- **A: 1) 자체 암호화 알고리즘 개발(절대 금지), 2) ECB 모드 사용(패턴 노출), 3) IV/Nonce 재사용, 4) 키 하드코딩, 5) 약한 난수 생성기.**

---

## 4. 시크릿 관리 (Secret Management)

### 개념 설명

시크릿(비밀 정보)은 API 키, 데이터베이스 비밀번호, 인증서 개인 키 등 노출되면 안 되는 민감한 정보를 말한다. 시크릿 관리는 이러한 정보를 안전하게 저장, 접근, 교체하는 프로세스이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 시크릿: API 키, 비밀번호, 토큰, 인증서 키 등
> - 코드에 하드코딩 금지
> - .env 파일로 분리, .gitignore에 추가
> - 환경 변수로 주입
>
> **Q: 시크릿을 코드에 넣으면 안 되는 이유는?**
> **A: 1) Git 히스토리에 영구 기록, 2) 소스 코드 유출 시 시크릿도 노출, 3) 환경별 다른 시크릿 사용 불가.**
>
> **Q: .env 파일을 Git에 커밋하면 어떻게 되나요?**
> **A: 시크릿이 Git 히스토리에 남아 삭제해도 복구 가능합니다. 이미 커밋했다면 시크릿을 즉시 교체해야 합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **.env 파일**: 로컬 개발용, 프로덕션에는 부적합
> - **환경 변수**: 컨테이너/서버에 주입, 프로세스 메모리에만 존재
> - **Git Secret Scanning**: GitHub, GitLab의 시크릿 탐지 기능
> - **시크릿 유출 시**: 즉시 교체, 영향 범위 파악
>
> **Q: 환경 변수의 한계점은?**
> **A: 1) 모든 프로세스가 접근 가능, 2) 로그/덤프에 노출 가능, 3) 변경 시 재시작 필요, 4) 접근 감사 불가. 프로덕션에는 시크릿 관리 도구 권장.**
>
> **Q: 시크릿이 Git에 커밋된 것을 발견하면?**
> **A: 1) 즉시 시크릿 교체(가장 중요), 2) 해당 시크릿으로 수행된 작업 감사, 3) Git 히스토리 정리(git filter-branch, BFG), 4) pre-commit 훅으로 재발 방지.**
>
> **Q: 개발 환경과 프로덕션 환경의 시크릿 관리 차이는?**
> **A: 개발: .env 파일, 가짜 시크릿/로컬 서비스 사용 가능. 프로덕션: Vault/KMS 등 시크릿 관리 도구, 최소 권한, 감사 로그, 자동 교체.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **HashiCorp Vault**: 시크릿 중앙 관리, 동적 시크릿, 감사 로그
>   - 인증 방식: Token, AppRole, AWS IAM, Kubernetes
>   - 시크릿 엔진: KV, Database, PKI, AWS
>   - 동적 시크릿: 사용 시 생성, TTL 후 자동 폐기
> - **AWS Secrets Manager**: AWS 통합, 자동 교체, RDS 통합
> - **Cloud KMS**: 암호화 키 관리, Envelope Encryption
>
> **Q: Vault의 동적 시크릿이란?**
> **A: 애플리케이션 요청 시 DB 자격 증명을 실시간 생성하고, TTL 후 자동 폐기합니다. 장점: 정적 비밀번호 유출 위험 제거, 자격 증명 공유 없음.**
>
> **Q: Kubernetes에서 시크릿 관리 방법은?**
> **A: 1) K8s Secrets: 기본 제공, base64 인코딩(암호화 아님), etcd 암호화 필요, 2) External Secrets Operator: Vault/AWS SM과 동기화, 3) Sealed Secrets: GitOps용 암호화된 시크릿.**
>
> **Q: 시크릿 교체(Rotation) 전략은?**
> **A: 1) 자동 교체: Vault/AWS SM의 자동 교체 기능, 2) 듀얼 시크릿: 교체 기간 동안 신/구 시크릿 동시 유효, 3) 그레이스 기간.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **Zero Standing Privileges**: 상시 권한 없음, 필요 시 임시 부여
> - **Just-In-Time Access**: 요청-승인-시간 제한 접근
> - **Privileged Access Management (PAM)**: 특권 계정 관리
> - **시크릿 거버넌스**: 정책, 감사, 컴플라이언스
>
> **Q: 제로 스탠딩 권한(Zero Standing Privileges) 구현 방법은?**
> **A: 1) 모든 특권 접근은 임시로 부여, 2) 승인 워크플로우 필수, 3) 시간 제한 자격 증명, 4) 세션 녹화/감사, 5) 자동 회수.**
>
> **Q: 대규모 조직의 시크릿 관리 아키텍처는?**
> **A: 1) 중앙 Vault 클러스터(HA), 2) 네임스페이스로 팀/환경 격리, 3) 정책으로 최소 권한, 4) 모든 접근 감사, 5) CI/CD 파이프라인 통합, 6) 동적 시크릿 활용.**
>
> **Q: 시크릿 유출 대응 프로세스는?**
> **A: 1) 즉시 시크릿 무효화/교체, 2) 영향 범위 파악, 3) 로그 분석, 4) 침해 지표(IoC) 기반 조사, 5) 근본 원인 분석, 6) 재발 방지책.**

### 실무 시나리오

**시나리오 1: Vault 사용 예시**
```bash
# Vault 로그인 (AppRole)
vault write auth/approle/login \
  role_id=$ROLE_ID \
  secret_id=$SECRET_ID

# 시크릿 읽기
vault kv get secret/myapp/database

# 동적 DB 자격 증명 생성
vault read database/creds/my-role
# 응답: username, password (TTL 후 자동 폐기)
```

**시나리오 2: pre-commit 시크릿 스캔**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
```

### 면접 빈출 질문

- **Q: 개발자가 프로덕션 DB 비밀번호를 알아야 하나요?**
- **A: 아닙니다. 개발자는 개발/테스트 환경만 접근하고, 프로덕션은 CI/CD 파이프라인이나 애플리케이션이 Vault/KMS에서 자동으로 가져와야 합니다.**

- **Q: AWS에서 EC2가 S3에 접근할 때 시크릿 관리 방법은?**
- **A: IAM Role을 EC2에 연결하고 인스턴스 프로파일로 임시 자격 증명을 자동 획득합니다. 액세스 키를 코드나 환경 변수에 넣지 않아도 됩니다.**

---

## 5. 네트워크 보안

### 개념 설명

네트워크 보안은 네트워크 인프라와 전송 중인 데이터를 보호하는 것이다. 방화벽, WAF, VPN, 제로 트러스트 등 다양한 기술과 아키텍처를 통해 외부 공격을 방어한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 방화벽: 네트워크 트래픽 필터링 (허용/차단)
> - VPN: 암호화된 터널로 안전한 원격 접속
> - HTTPS: 웹 트래픽 암호화
> - 최소 권한 원칙: 필요한 포트/IP만 허용
>
> **Q: 방화벽만 있으면 안전한가요?**
> **A: 아닙니다. 방화벽은 네트워크 경계만 보호합니다. 내부 공격, 애플리케이션 취약점, 인증 우회 등은 다른 보안 레이어가 필요합니다.**
>
> **Q: 집에서 회사 서버에 접속할 때 VPN이 필요한 이유는?**
> **A: 인터넷은 공용 네트워크라 트래픽이 도청될 수 있습니다. VPN은 암호화된 터널을 만들어 안전하게 내부 네트워크에 연결합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **WAF (Web Application Firewall)**: L7 방화벽, SQL Injection/XSS 차단
> - **DDoS 방어**: CloudFlare, AWS Shield, Rate Limiting
> - **Security Group vs NACL**: 인스턴스 vs 서브넷 레벨
> - **Bastion Host**: 점프 서버, 내부 네트워크 접근 게이트웨이
>
> **Q: WAF와 일반 방화벽의 차이는?**
> **A: 일반 방화벽(L3/L4)은 IP와 포트만 확인합니다. WAF(L7)는 HTTP 내용을 분석하여 애플리케이션 공격을 탐지/차단합니다.**
>
> **Q: DDoS 공격 유형과 방어 방법은?**
> **A: 유형: 1) Volumetric(대역폭 소진), 2) Protocol(SYN flood 등), 3) Application(HTTP flood). 방어: CDN 흡수, Rate limiting, 자동 스케일링.**
>
> **Q: Bastion Host 사용 시 주의점은?**
> **A: 1) 최소한의 소프트웨어만 설치, 2) 강력한 인증(SSH 키 + MFA), 3) 접근 로깅 필수, 4) 세션 시간 제한.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **마이크로세그멘테이션**: 워크로드별 세밀한 네트워크 격리
> - **mTLS (Mutual TLS)**: 클라이언트-서버 양방향 인증
> - **Service Mesh**: Istio, Linkerd에서 투명한 mTLS
> - **네트워크 정책**: Kubernetes Network Policy, Calico
>
> **Q: 마이크로세그멘테이션 구현 방법은?**
> **A: 1) 각 워크로드에 개별 Security Group, 2) K8s Network Policy로 Pod 간 트래픽 제어, 3) Service Mesh의 Authorization Policy. 목표: 침해 시 lateral movement 방지.**
>
> **Q: Service Mesh에서 mTLS의 이점은?**
> **A: 1) 투명한 암호화(앱 수정 불필요), 2) 서비스 간 상호 인증, 3) 인증서 자동 관리, 4) 세밀한 접근 정책.**
>
> **Q: 네트워크 보안 모니터링에서 중요한 지표는?**
> **A: 1) 비정상 트래픽 패턴, 2) 차단된 연결 시도, 3) 내부->외부 대량 데이터 전송, 4) 알려진 악성 IP 접근.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **Zero Trust Architecture**: 네트워크 위치와 무관하게 모든 접근 검증
>   - 핵심 원칙: "Never trust, always verify"
>   - 구성요소: 강력한 인증, 최소 권한, 지속적 검증, 암호화
> - **SASE (Secure Access Service Edge)**: 네트워크 + 보안 통합
> - **CASB (Cloud Access Security Broker)**: SaaS 보안
>
> **Q: Zero Trust Architecture 구현 단계는?**
> **A: 2024년 NIST/CISA 가이드 기준: 1) 사용자/디바이스 신원 확립, 2) 모든 자산 인벤토리, 3) 강력한 인증(MFA, 디바이스 인증), 4) 마이크로세그멘테이션, 5) 최소 권한 접근, 6) 모든 트래픽 암호화, 7) 지속적 모니터링.**
>
> **Q: VPN에서 ZTNA로 전환하는 이유는?**
> **A: VPN은 일단 연결되면 네트워크 전체 접근 가능(암묵적 신뢰). ZTNA는 애플리케이션별로 접근 허용, 디바이스 상태 확인, 지속적 검증. Gartner 기준 ZTNA는 2023-2024년 51% 이상 성장.**
>
> **Q: 클라우드 네이티브 환경의 네트워크 보안 전략은?**
> **A: 1) 서비스 메시로 mTLS, 2) 네트워크 정책으로 Pod 격리, 3) 이그레스 제어, 4) 클라우드 네이티브 WAF, 5) VPC 설계(퍼블릭/프라이빗 서브넷).**

### 실무 시나리오

**시나리오 1: Kubernetes Network Policy**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
```

**시나리오 2: AWS Security Group 설계**
```
[Internet] -> [ALB SG: 443 from 0.0.0.0/0]
           -> [App SG: 8080 from ALB-SG only]
           -> [DB SG: 5432 from App-SG only]
           -> [Bastion SG: 22 from Office-IP/32]
```

### 면접 빈출 질문

- **Q: 내부 네트워크는 안전하니까 암호화가 필요 없나요?**
- **A: 아닙니다. 내부 위협, 침해 후 lateral movement, 규정 준수 요구사항 등으로 내부 트래픽도 암호화해야 합니다. Zero Trust는 내부를 신뢰하지 않습니다.**

- **Q: Rate Limiting만으로 DDoS를 막을 수 있나요?**
- **A: 애플리케이션 레벨 DDoS는 완화할 수 있지만, 대규모 볼류메트릭 공격은 인프라 용량을 초과합니다. CDN, DDoS 방어 서비스와 함께 사용해야 합니다.**

---

## 6. 컨테이너 보안

### 개념 설명

컨테이너는 애플리케이션과 의존성을 패키징하여 이식성을 높이지만, 새로운 보안 과제를 도입한다. 이미지 취약점, 런타임 보안, 호스트 격리 등 컨테이너 라이프사이클 전반에 걸친 보안이 필요하다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 컨테이너는 호스트 커널을 공유 (VM보다 약한 격리)
> - 이미지에 취약점이 포함될 수 있음
> - root 사용자로 실행하면 위험
> - 신뢰할 수 있는 이미지만 사용
>
> **Q: 컨테이너가 VM보다 보안이 약한 이유는?**
> **A: 컨테이너는 호스트 커널을 공유하므로 커널 취약점이 있으면 모든 컨테이너에 영향을 미칩니다. VM은 하이퍼바이저로 완전히 격리됩니다.**
>
> **Q: 공식 이미지만 사용하면 안전한가요?**
> **A: 공식 이미지도 취약점을 포함할 수 있습니다. 정기적으로 취약점 스캔을 하고 최소한의 베이스 이미지를 선택해야 합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **이미지 스캔**: Trivy, Snyk, Clair로 취약점 탐지
> - **최소 이미지**: Alpine, Distroless, scratch
> - **비루트 실행**: USER 지시어로 non-root 사용자 지정
> - **멀티 스테이지 빌드**: 빌드 도구 제외, 최종 이미지 축소
>
> **Q: Trivy로 이미지 스캔하는 방법은?**
> **A:**
> ```bash
> # 로컬 이미지 스캔
> trivy image myapp:latest
>
> # CI/CD에서 심각한 취약점 있으면 실패
> trivy image --exit-code 1 --severity HIGH,CRITICAL myapp:latest
> ```
>
> **Q: Dockerfile에서 보안 모범 사례는?**
> **A: 1) 공식/검증된 베이스 이미지, 2) 특정 버전 태그(latest 지양), 3) USER로 non-root 실행, 4) COPY 시 필요한 파일만, 5) 시크릿을 이미지에 포함하지 않음.**
>
> **Q: 컨테이너를 root로 실행하면 안 되는 이유는?**
> **A: 컨테이너 탈출(escape) 취약점 발생 시 root 권한으로 호스트에 접근할 수 있습니다. non-root로 실행하면 피해를 최소화합니다.**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **Rootless 컨테이너**: 컨테이너 런타임 자체를 non-root로 실행
> - **seccomp**: 시스템 콜 필터링
> - **AppArmor/SELinux**: 강제 접근 제어
> - **Read-only 파일시스템**: 런타임 변조 방지
> - **런타임 보안**: Falco, Sysdig로 이상 행동 탐지
>
> **Q: seccomp 프로파일의 역할은?**
> **A: 컨테이너가 호출할 수 있는 시스템 콜을 제한합니다. 기본 Docker seccomp 프로파일은 위험한 시스템 콜 약 40개를 차단합니다.**
>
> **Q: Falco로 어떤 위협을 탐지하나요?**
> **A: 1) 컨테이너 내 쉘 실행, 2) 민감 파일 접근, 3) 네트워크 도구 실행, 4) 권한 상승 시도, 5) 암호화폐 채굴.**
>
> **Q: Pod Security Standards(PSS)란?**
> **A: Kubernetes의 Pod 보안 정책 표준: 1) Privileged(무제한), 2) Baseline(기본 보안), 3) Restricted(강화 보안).**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **이미지 서명**: Sigstore, Cosign으로 무결성 검증
> - **SBOM (Software Bill of Materials)**: 구성 요소 목록
> - **정책 엔진**: OPA Gatekeeper, Kyverno로 정책 시행
> - **공급망 보안**: SLSA 프레임워크
>
> **Q: 컨테이너 공급망 보안(Supply Chain Security) 전략은?**
> **A: 1) 신뢰할 수 있는 베이스 이미지만 사용, 2) 이미지 서명 및 검증, 3) SBOM 생성 및 취약점 추적, 4) 이미지 레지스트리 접근 제어, 5) CI/CD 파이프라인 보안(SLSA Level).**
>
> **Q: Kubernetes 환경의 컨테이너 보안 아키텍처는?**
> **A: 1) Admission Controller로 정책 시행, 2) Network Policy로 Pod 격리, 3) Pod Security Standards 적용, 4) 시크릿은 외부 관리(Vault), 5) 런타임 보안 모니터링.**
>
> **Q: SLSA(Supply-chain Levels for Software Artifacts)란?**
> **A: 소프트웨어 공급망 보안 프레임워크: Level 1(문서화), Level 2(빌드 서비스), Level 3(소스/빌드 검증), Level 4(상호 검토).**

### 실무 시나리오

**시나리오 1: 보안 Dockerfile**
```dockerfile
# 멀티 스테이지 빌드
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# 최종 이미지
FROM node:20-alpine
WORKDIR /app

# non-root 사용자 생성
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# 파일 복사
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=appuser:appgroup . .

# non-root로 실행
USER appuser

EXPOSE 3000
CMD ["node", "server.js"]
```

**시나리오 2: CI/CD 이미지 보안 파이프라인**
```yaml
# GitHub Actions 예시
steps:
  - name: Build image
    run: docker build -t myapp:${{ github.sha }} .

  - name: Scan for vulnerabilities
    uses: aquasecurity/trivy-action@master
    with:
      image-ref: myapp:${{ github.sha }}
      exit-code: '1'
      severity: 'CRITICAL,HIGH'

  - name: Sign image
    run: cosign sign --key cosign.key myapp:${{ github.sha }}

  - name: Generate SBOM
    run: trivy image --format spdx-json -o sbom.json myapp:${{ github.sha }}
```

### 면접 빈출 질문

- **Q: 컨테이너 이미지 크기를 줄이면 보안에 도움이 되나요?**
- **A: 예. 작은 이미지는 불필요한 패키지가 없어 공격 표면이 줄어듭니다. Distroless나 scratch 이미지는 쉘도 없어 공격자가 할 수 있는 것이 제한됩니다.**

- **Q: Kubernetes Secret은 안전한가요?**
- **A: 기본적으로 etcd에 base64 인코딩(암호화 아님)으로 저장됩니다. 보안 강화: 1) etcd 암호화 활성화, 2) RBAC으로 접근 제한, 3) External Secrets Operator로 Vault 연동.**

---

## 7. 컴플라이언스 및 보안 사고 대응

### 개념 설명

컴플라이언스는 법규, 산업 표준, 내부 정책을 준수하는 것이다. 보안 사고 대응(Incident Response)은 보안 침해 발생 시 신속하게 탐지, 대응, 복구하는 프로세스다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 컴플라이언스: 법규/표준 준수 (개인정보보호법, GDPR 등)
> - 보안 사고: 데이터 유출, 해킹, 랜섬웨어 등
> - 사고 발생 시 즉시 보고하고 절차 따르기
> - 로그는 증거이므로 함부로 삭제하지 않기
>
> **Q: 개발자도 컴플라이언스를 알아야 하나요?**
> **A: 예. 개인정보 처리, 데이터 암호화, 접근 로깅 등 많은 요구사항이 코드/인프라에 구현되어야 합니다.**

> ⭐⭐ **Level 2 (주니어)**
> - **GDPR**: EU 개인정보 보호 규정, 동의/삭제권/이식권
> - **개인정보보호법**: 한국 개인정보 규정
> - **PCI DSS**: 카드 결제 보안 표준
> - **보안 사고 대응 기본**: 탐지 -> 분석 -> 격리 -> 복구 -> 교훈
>
> **Q: GDPR에서 개발자가 알아야 할 핵심은?**
> **A: 1) 개인정보 수집 시 명시적 동의, 2) 삭제 요청 대응(잊힐 권리), 3) 데이터 최소화, 4) 목적 외 사용 금지, 5) 암호화/가명화, 6) 72시간 내 침해 신고.**
>
> **Q: 보안 사고 발견 시 첫 번째 행동은?**
> **A: 1) 침착하게 상황 파악, 2) 보안팀/매니저에게 즉시 보고, 3) 증거 보존(로그, 스크린샷), 4) 임의로 조치하지 않음(증거 훼손 방지).**

> ⭐⭐⭐ **Level 3 (시니어)**
> - **SOC 2**: 서비스 조직의 보안/가용성/기밀성 인증
> - **ISO 27001**: 정보보안 관리체계 국제 표준
> - **IR 프로세스**: NIST 사고 대응 프레임워크
>   1. 준비 (Preparation)
>   2. 탐지 및 분석 (Detection & Analysis)
>   3. 격리, 근절, 복구 (Containment, Eradication, Recovery)
>   4. 사후 활동 (Post-Incident Activity)
>
> **Q: SOC 2 Type 1과 Type 2의 차이는?**
> **A: Type 1은 특정 시점의 통제 설계 적합성, Type 2는 일정 기간(보통 6-12개월) 동안 통제의 운영 효과성을 평가합니다.**
>
> **Q: 보안 사고 분석에서 IoC(Indicator of Compromise)란?**
> **A: 침해 발생을 나타내는 증거: 악성 IP/도메인, 파일 해시, 레지스트리 키, 비정상 네트워크 패턴 등.**
>
> **Q: 포렌식 시 증거 무결성을 유지하는 방법은?**
> **A: 1) 원본 훼손 방지(복사본 작업), 2) 해시값으로 무결성 기록, 3) 체인 오브 커스터디, 4) 쓰기 방지 도구 사용, 5) 문서화.**

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - **보안 거버넌스**: 정책, 조직, 프로세스, 기술의 통합
> - **위험 관리**: 자산 식별, 위협 분석, 위험 평가, 대응 전략
> - **비즈니스 연속성**: BCP(Business Continuity Plan), DR(Disaster Recovery)
> - **보안 문화**: 전사적 보안 인식, 교육, 책임
>
> **Q: CISO로서 보안 프로그램의 핵심 요소는?**
> **A: 1) 거버넌스(정책, 표준, 절차), 2) 위험 관리, 3) 규정 준수, 4) 보안 아키텍처, 5) 운영 보안, 6) 사고 대응, 7) 인식 교육, 8) 지표/보고.**
>
> **Q: 위험 기반 보안 의사결정이란?**
> **A: 모든 위험을 제거할 수 없으므로 1) 자산의 가치, 2) 위협의 가능성, 3) 취약점의 심각도, 4) 영향도를 고려하여 우선순위를 정합니다. 위험 = 가능성 x 영향.**
>
> **Q: 보안 침해 시 법적 대응과 커뮤니케이션 전략은?**
> **A: 1) 법률 자문 즉시 확보, 2) 규정에 따른 신고(72시간 등), 3) 이해관계자 커뮤니케이션 계획, 4) 외부 전문가 필요 시 계약, 5) 언론/고객 대응은 홍보팀과 조율.**

### 실무 시나리오

**시나리오 1: 보안 사고 대응 체크리스트**
```
1. 탐지/보고
   [ ] 사고 발견 시간 기록
   [ ] 초기 영향 범위 파악
   [ ] 보안팀/경영진 보고
   [ ] 사고 대응팀 소집

2. 격리
   [ ] 감염 시스템 네트워크 격리
   [ ] 자격 증명 무효화
   [ ] 백업 상태 확인

3. 분석
   [ ] 로그 수집/보존
   [ ] 타임라인 구성
   [ ] 침해 지표(IoC) 식별
   [ ] 근본 원인 분석

4. 복구
   [ ] 클린 시스템으로 복원
   [ ] 취약점 패치
   [ ] 강화된 모니터링

5. 사후 활동
   [ ] 사고 보고서 작성
   [ ] 교훈 회의
   [ ] 프로세스 개선
   [ ] 규제 기관 신고 (필요시)
```

**시나리오 2: 컴플라이언스 준수 체크리스트 (GDPR)**
```
[ ] 개인정보 처리 목록 작성
[ ] 법적 근거 문서화 (동의, 계약, 법적 의무 등)
[ ] 개인정보 처리 방침 공개
[ ] 동의 철회 메커니즘
[ ] 데이터 이식성 지원
[ ] 삭제 요청 처리 프로세스
[ ] 데이터 처리자 계약 (DPA)
[ ] 침해 대응 프로세스 (72시간 신고)
[ ] DPO(Data Protection Officer) 지정 (해당 시)
```

### 면접 빈출 질문

- **Q: 보안과 개발 속도 사이의 균형을 어떻게 맞추나요?**
- **A: 1) Shift Left로 초기부터 보안 통합, 2) 자동화된 보안 테스트, 3) 위험 기반 우선순위, 4) 보안 챔피언 프로그램, 5) DevSecOps 문화.**

- **Q: 랜섬웨어 공격 시 대응 방법은?**
- **A: 1) 즉시 네트워크 격리, 2) 랜섬 지불 전 법률/보험 자문, 3) 백업에서 복구 시도, 4) 포렌식으로 침투 경로 분석, 5) 모든 자격 증명 교체, 6) 규제 기관/고객 통보.**

---

## 참고 자료

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)
- [OAuth 2.0 Security Best Current Practice (RFC 9700)](https://datatracker.ietf.org/doc/rfc9700/)
- [Zero Trust Architecture (NIST SP 800-207)](https://nvlpubs.nist.gov/nistpubs/specialpublications/NIST.SP.800-207.pdf)
- [CISA Zero Trust Maturity Model](https://www.dhs.gov/sites/default/files/2025-04/2025_0129_cisa_zero_trust_architecture_implementation.pdf)
- [Trivy Container Scanner](https://trivy.dev/)
- [JWT Security Best Practices](https://curity.io/resources/learn/jwt-best-practices/)
