# 배포/CI·CD/컨테이너 - IT 서비스 운영 필수 지식

> 이 문서는 IT 서비스 운영에 필요한 배포, CI/CD, 컨테이너 오케스트레이션 지식을 레벨별로 정리한 학습 자료입니다.

## 레벨 가이드
| 레벨 | 대상 | 설명 |
|------|------|------|
| ⭐ Level 1 | 입문 | 개념 이해, 기본 용어 |
| ⭐⭐ Level 2 | 주니어 | 실무 적용, 트러블슈팅 기초 |
| ⭐⭐⭐ Level 3 | 시니어 | 아키텍처 설계, 성능 최적화 |
| ⭐⭐⭐⭐ Level 4 | 리드/CTO | 전략적 의사결정, 대규모 설계 |

---

## 1. Docker 기초

### 개념 설명
Docker는 애플리케이션을 컨테이너라는 격리된 환경에서 실행할 수 있게 해주는 플랫폼이다. 컨테이너는 OS 레벨 가상화를 통해 호스트 커널을 공유하면서도 독립적인 실행 환경을 제공한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 이미지(Image): 컨테이너 실행에 필요한 파일 시스템과 설정의 읽기 전용 템플릿
> - 컨테이너(Container): 이미지를 기반으로 실행되는 격리된 프로세스
> - 레이어(Layer): 이미지를 구성하는 읽기 전용 파일 시스템 계층
>
> **Q: Docker 이미지와 컨테이너의 차이점은?**
> **A:** 이미지는 읽기 전용 템플릿이고, 컨테이너는 이미지를 기반으로 실행되는 인스턴스다. 이미지는 클래스, 컨테이너는 객체에 비유할 수 있다.
>
> **Q: Docker가 VM보다 가벼운 이유는?**
> **A:** Docker는 호스트 OS의 커널을 공유하므로 게스트 OS가 필요 없다. VM은 각각 전체 OS를 가상화하므로 리소스 오버헤드가 크다.
>
> **Q: Docker 레이어 구조의 장점은?**
> **A:** 레이어를 공유하여 저장 공간을 절약하고, 이미 존재하는 레이어는 다시 다운로드하지 않아 빌드와 배포가 빠르다.

> ⭐⭐ **Level 2 (주니어)**
> - Dockerfile 주요 명령어: FROM, RUN, COPY, ADD, CMD, ENTRYPOINT, ENV, EXPOSE, WORKDIR
> - 빌드 컨텍스트: docker build 시 Docker 데몬에 전송되는 파일 집합
> - Union File System: 여러 레이어를 하나의 파일 시스템으로 합치는 기술
>
> **Q: CMD와 ENTRYPOINT의 차이점은?**
> **A:** ENTRYPOINT는 컨테이너의 메인 실행 파일을 정의하고, CMD는 기본 인자를 제공한다. docker run 시 인자를 주면 CMD는 대체되지만 ENTRYPOINT는 유지된다.
>
> **Q: COPY와 ADD의 차이점은?**
> **A:** COPY는 단순 파일 복사만 수행하고, ADD는 URL 다운로드와 tar 자동 압축 해제 기능이 있다. 일반적으로 명시적인 COPY 사용을 권장한다.
>
> **Q: 빌드 컨텍스트가 크면 어떤 문제가 발생하는가?**
> **A:** Docker 데몬에 전송하는 시간이 길어지고, 불필요한 파일이 이미지에 포함될 수 있다. .dockerignore로 제외할 파일을 지정해야 한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - Copy-on-Write: 컨테이너 레이어에서 파일 수정 시 해당 파일만 복사하여 수정
> - 스토리지 드라이버: overlay2, devicemapper, btrfs 등 레이어 관리 방식
> - 이미지 매니페스트: 멀티 아키텍처 이미지를 위한 메타데이터
>
> **Q: overlay2 스토리지 드라이버의 동작 원리는?**
> **A:** OverlayFS를 사용해 lowerdir(읽기 전용 레이어들), upperdir(쓰기 가능 레이어), merged(통합 뷰)를 구성한다. 파일 수정 시 copy-up 발생.
>
> **Q: 멀티 아키텍처 이미지는 어떻게 동작하는가?**
> **A:** 매니페스트 리스트가 여러 아키텍처별 이미지를 참조한다. docker pull 시 클라이언트 아키텍처에 맞는 이미지를 자동 선택한다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - OCI 표준: Open Container Initiative에서 정의한 컨테이너 런타임 및 이미지 표준
> - containerd vs CRI-O: 컨테이너 런타임 선택과 생태계 영향
>
> **Q: Docker에서 containerd로의 전환이 중요한 이유는?**
> **A:** Kubernetes가 dockershim을 제거하고 CRI 호환 런타임을 요구한다. containerd는 더 가볍고 표준을 준수하며, 프로덕션에서 안정적이다.

---

## 2. Docker 최적화

### 개념 설명
효율적인 Docker 이미지는 빌드 시간 단축, 보안 강화, 배포 속도 향상에 필수적이다. 레이어 캐싱, 멀티스테이지 빌드, 경량 베이스 이미지 사용이 핵심이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 이미지 크기가 작을수록 배포가 빠르고 저장 비용이 절감됨
> - alpine 이미지: 5MB 정도의 경량 리눅스 배포판
>
> **Q: alpine 베이스 이미지의 장단점은?**
> **A:** 장점은 매우 작은 크기(~5MB)와 보안 공격 표면 감소. 단점은 musl libc 사용으로 glibc 기반 바이너리 호환성 문제 가능.
>
> **Q: 이미지 크기를 줄이면 어떤 이점이 있는가?**
> **A:** 레지스트리 저장 비용 감소, 네트워크 전송 시간 단축, 컨테이너 시작 시간 개선, 보안 취약점 감소.

> ⭐⭐ **Level 2 (주니어)**
> - 멀티스테이지 빌드: 빌드 도구는 빌드 단계에만, 최종 이미지에는 실행 파일만 포함
> - 레이어 캐싱: 변경되지 않은 레이어는 캐시에서 재사용
> - .dockerignore: 빌드 컨텍스트에서 제외할 파일 패턴 지정
>
> **Q: 멀티스테이지 빌드의 이점은?**
> **A:** 빌드 도구(컴파일러, npm 등)가 최종 이미지에 포함되지 않아 이미지 크기가 작아지고 보안이 향상된다.
>
> **Q: 레이어 캐시를 효율적으로 활용하려면?**
> **A:** 자주 변경되는 파일(소스코드)은 나중에 COPY하고, 잘 변경되지 않는 파일(package.json)은 먼저 COPY하여 의존성 설치 레이어를 캐시한다.
>
> **Q: .dockerignore에 포함해야 할 파일은?**
> **A:** node_modules, .git, 로그 파일, 테스트 파일, IDE 설정, .env 파일 등 실행에 불필요하거나 민감한 파일.

> ⭐⭐⭐ **Level 3 (시니어)**
> - distroless 이미지: 패키지 관리자, 셸이 없는 최소 런타임 이미지
> - scratch 이미지: 완전히 빈 베이스 이미지, 정적 바이너리용
> - BuildKit: 병렬 빌드, 캐시 마운트, 시크릿 마운트 지원
>
> **Q: distroless 이미지 사용 시 디버깅은 어떻게 하는가?**
> **A:** 디버그 태그 이미지 사용, 사이드카 컨테이너, 또는 ephemeral container(kubectl debug)를 활용한다.
>
> **Q: BuildKit의 캐시 마운트(--mount=type=cache)의 용도는?**
> **A:** 패키지 매니저 캐시(apt, npm, pip)를 빌드 간에 유지하여 의존성 다운로드 시간을 크게 줄인다.
>
> **Q: 멀티스테이지에서 특정 스테이지만 빌드하려면?**
> **A:** `docker build --target <stage-name>`을 사용한다. CI에서 테스트 스테이지와 프로덕션 스테이지를 분리할 때 유용하다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 이미지 서명 및 검증: Notary, cosign을 통한 공급망 보안
> - SBOM(Software Bill of Materials): 이미지 내 소프트웨어 구성 요소 목록화
>
> **Q: 컨테이너 공급망 보안을 강화하는 방법은?**
> **A:** 이미지 서명(cosign), SBOM 생성(syft), 취약점 스캐닝(trivy), 신뢰할 수 있는 베이스 이미지 사용, 정책 기반 어드미션 컨트롤.

---

## 3. Docker 네트워킹

### 개념 설명
Docker는 다양한 네트워크 드라이버를 제공하여 컨테이너 간, 컨테이너와 호스트 간 통신을 관리한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - bridge: 기본 네트워크, 같은 브릿지의 컨테이너끼리 통신 가능
> - host: 호스트 네트워크 스택 직접 사용
> - none: 네트워크 비활성화
>
> **Q: 포트 매핑(-p 8080:80)의 의미는?**
> **A:** 호스트의 8080 포트로 들어온 트래픽을 컨테이너의 80 포트로 전달한다.
>
> **Q: 컨테이너 간 통신을 위해 같은 네트워크에 있어야 하는 이유는?**
> **A:** Docker 네트워크는 격리되어 있어 다른 네트워크의 컨테이너와는 기본적으로 통신할 수 없다.

> ⭐⭐ **Level 2 (주니어)**
> - 사용자 정의 브릿지: 컨테이너 이름으로 DNS 해석 가능
> - 내장 DNS: 127.0.0.11에서 동작, 컨테이너 이름을 IP로 해석
>
> **Q: 기본 bridge와 사용자 정의 bridge의 차이점은?**
> **A:** 사용자 정의 bridge에서는 컨테이너 이름으로 DNS 해석이 가능하고, 더 나은 격리와 연결/분리 유연성을 제공한다.
>
> **Q: --link 옵션을 사용하지 않아야 하는 이유는?**
> **A:** --link는 레거시 기능이다. 사용자 정의 네트워크의 DNS 기능이 더 유연하고 권장된다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - overlay: 여러 Docker 호스트 간 컨테이너 통신 (Swarm/Kubernetes)
> - macvlan: 컨테이너에 물리 네트워크의 MAC 주소 할당
> - ipvlan: L2/L3 모드로 네트워크 성능 최적화
>
> **Q: overlay 네트워크의 VXLAN 캡슐화란?**
> **A:** 컨테이너 패킷을 UDP로 캡슐화하여 다른 호스트로 전송한다. VTEP가 캡슐화/역캡슐화를 담당하며 오버레이 네트워크를 구현한다.
>
> **Q: macvlan vs ipvlan 선택 기준은?**
> **A:** macvlan은 각 컨테이너가 고유 MAC을 가져 기존 네트워크 통합에 유리. ipvlan은 MAC 주소 제한이 있는 환경이나 성능이 중요할 때 사용.

---

## 4. Docker Compose

### 개념 설명
Docker Compose는 YAML 파일로 다중 컨테이너 애플리케이션을 정의하고 관리하는 도구이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - docker-compose.yml: 서비스, 네트워크, 볼륨 정의 파일
> - 서비스(Service): 하나의 컨테이너 정의
>
> **Q: docker-compose up -d의 의미는?**
> **A:** 정의된 모든 서비스를 백그라운드(-d)에서 시작한다.
>
> **Q: docker-compose down과 stop의 차이는?**
> **A:** stop은 컨테이너만 중지, down은 컨테이너와 네트워크를 제거한다. down -v는 볼륨도 제거.

> ⭐⭐ **Level 2 (주니어)**
> - depends_on: 서비스 시작 순서 정의
> - volumes: 데이터 영속화
> - environment/env_file: 환경 변수 설정
>
> **Q: depends_on이 보장하는 것과 보장하지 않는 것은?**
> **A:** 컨테이너 시작 순서는 보장하지만, 애플리케이션 준비 상태는 보장하지 않는다. healthcheck와 condition을 사용해야 한다.
>
> **Q: named volume과 bind mount의 차이는?**
> **A:** named volume은 Docker가 관리하며 이식성이 좋다. bind mount는 호스트 경로를 직접 마운트하여 개발 시 코드 동기화에 유용하다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - profiles: 환경별 서비스 그룹화
> - extends: 서비스 설정 상속
> - deploy: Swarm 배포 설정 (replicas, resources)
>
> **Q: Compose에서 서비스 스케일링 방법은?**
> **A:** `docker-compose up --scale web=3` 또는 deploy.replicas 설정. 단, 포트 충돌 방지를 위해 동적 포트 매핑 필요.
>
> **Q: 여러 Compose 파일을 조합하는 방법은?**
> **A:** `-f` 옵션으로 여러 파일 지정. 나중 파일이 앞 파일을 오버라이드. base + override 패턴으로 환경별 설정 관리.

---

## 5. Docker 보안

### 개념 설명
컨테이너 보안은 이미지 빌드부터 런타임까지 다층 방어가 필요하다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - root로 실행하지 않기: USER 지시어로 non-root 사용자 지정
> - 공식 이미지 사용: 검증된 베이스 이미지 선택
>
> **Q: 컨테이너를 root로 실행하면 안 되는 이유는?**
> **A:** 컨테이너 탈출 시 호스트 root 권한을 얻을 수 있다. 최소 권한 원칙을 적용해야 한다.

> ⭐⭐ **Level 2 (주니어)**
> - 이미지 스캐닝: trivy, clair 등으로 취약점 검사
> - read-only 파일시스템: --read-only 플래그
> - resource limits: --memory, --cpus로 리소스 제한
>
> **Q: 이미지 스캐닝을 CI에 통합하는 이유는?**
> **A:** 취약한 이미지가 프로덕션에 배포되기 전에 차단할 수 있다. 빌드 파이프라인에서 스캔 실패 시 배포 중단.
>
> **Q: read-only 파일시스템 사용 시 주의점은?**
> **A:** 애플리케이션이 임시 파일을 쓸 수 있도록 tmpfs 마운트를 별도로 구성해야 한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - seccomp: 시스템 콜 필터링
> - AppArmor/SELinux: MAC(강제 접근 제어)
> - rootless Docker: 데몬도 non-root로 실행
>
> **Q: seccomp 프로파일의 역할은?**
> **A:** 컨테이너가 호출할 수 있는 시스템 콜을 제한한다. 불필요한 syscall을 차단하여 공격 표면을 줄인다.
>
> **Q: rootless Docker의 장단점은?**
> **A:** 장점은 데몬 취약점 이용한 root 탈취 방지. 단점은 일부 기능 제한(특권 포트, 일부 스토리지 드라이버).

---

## 6. Kubernetes 핵심 개념

### 개념 설명
Kubernetes(K8s)는 컨테이너화된 워크로드를 자동으로 배포, 스케일링, 관리하는 오케스트레이션 플랫폼이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - Pod: 하나 이상의 컨테이너를 포함하는 최소 배포 단위
> - Node: Pod가 실행되는 워커 머신
> - Cluster: 노드들의 집합
>
> **Q: Pod 안에 여러 컨테이너를 넣는 경우는?**
> **A:** 사이드카 패턴(로깅, 프록시), 초기화 컨테이너, 밀접하게 결합된 컨테이너 등. 일반적으로 1 Pod = 1 컨테이너 권장.
>
> **Q: Kubernetes가 Docker Swarm보다 선호되는 이유는?**
> **A:** 더 풍부한 기능(자동 스케일링, 롤백, 서비스 디스커버리), 큰 생태계, 멀티 클라우드 지원, 선언적 설정.

> ⭐⭐ **Level 2 (주니어)**
> - ReplicaSet: Pod 복제본 수 유지
> - Deployment: ReplicaSet의 선언적 업데이트 관리
> - StatefulSet: 상태 유지가 필요한 애플리케이션(DB, 메시지 큐)
> - DaemonSet: 모든 노드에 Pod 하나씩 실행
> - Job/CronJob: 일회성/주기적 배치 작업
>
> **Q: Deployment vs StatefulSet 선택 기준은?**
> **A:** Deployment는 상태 없는 애플리케이션(웹 서버). StatefulSet은 안정적 네트워크 ID, 순차 배포, 영구 스토리지가 필요한 경우(DB).
>
> **Q: DaemonSet의 대표적 사용 사례는?**
> **A:** 로그 수집(fluentd), 모니터링 에이전트(node-exporter), 네트워크 플러그인(CNI), 스토리지 플러그인.
>
> **Q: Job과 CronJob의 차이는?**
> **A:** Job은 일회성 작업 완료까지 실행. CronJob은 cron 표현식에 따라 주기적으로 Job 생성.

> ⭐⭐⭐ **Level 3 (시니어)**
> - Pod 라이프사이클: Pending → Running → Succeeded/Failed
> - Init Container: 메인 컨테이너 전에 실행, 순차 실행 보장
> - Pod Disruption Budget: 자발적 중단 시 최소 가용 Pod 수 보장
>
> **Q: Pod가 Pending 상태에 머무는 원인은?**
> **A:** 리소스 부족, 이미지 풀 실패, PVC 바인딩 대기, 노드 셀렉터/어피니티 불일치, taint/toleration 미스매치.
>
> **Q: Pod Disruption Budget(PDB)이 중요한 이유는?**
> **A:** 노드 업그레이드, 클러스터 스케일 다운 시 최소 가용성을 보장한다. minAvailable 또는 maxUnavailable로 설정.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - Control Plane 컴포넌트: API Server, etcd, Scheduler, Controller Manager
> - 커스텀 리소스(CRD)와 Operator 패턴
>
> **Q: etcd의 역할과 관리 방법은?**
> **A:** 모든 클러스터 상태 저장. 정기 백업 필수, 홀수 개 노드 구성, 전용 SSD, 디스크 IOPS 모니터링.
>
> **Q: Operator 패턴의 장점은?**
> **A:** 도메인 지식을 코드화하여 복잡한 애플리케이션(DB, 메시지 큐)의 배포, 업그레이드, 복구를 자동화한다.

---

## 7. Kubernetes 서비스/네트워킹

### 개념 설명
Kubernetes Service는 Pod 집합에 대한 안정적인 네트워크 엔드포인트를 제공한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - Service: Pod 그룹에 대한 단일 접점
> - ClusterIP: 클러스터 내부에서만 접근 가능 (기본값)
> - NodePort: 각 노드의 특정 포트로 외부 접근
> - LoadBalancer: 클라우드 로드밸런서 프로비저닝
>
> **Q: Service가 필요한 이유는?**
> **A:** Pod IP는 재시작 시 변경된다. Service는 레이블 셀렉터로 Pod를 선택하고 안정적인 DNS 이름과 IP를 제공한다.
>
> **Q: NodePort의 기본 포트 범위는?**
> **A:** 30000-32767. 이 범위를 벗어나면 API Server 설정 변경 필요.

> ⭐⭐ **Level 2 (주니어)**
> - Ingress: HTTP/HTTPS 라우팅, 호스트/경로 기반 라우팅
> - Ingress Controller: Ingress 리소스를 실제로 처리 (nginx, traefik 등)
> - kube-dns/CoreDNS: 서비스 이름을 IP로 해석
>
> **Q: Ingress vs LoadBalancer 선택 기준은?**
> **A:** HTTP/HTTPS 트래픽은 Ingress가 효율적(하나의 LB로 여러 서비스). TCP/UDP는 LoadBalancer 또는 NodePort 사용.
>
> **Q: Kubernetes DNS 형식은?**
> **A:** `<service>.<namespace>.svc.cluster.local`. 같은 네임스페이스면 `<service>`만으로 접근 가능.

> ⭐⭐⭐ **Level 3 (시니어)**
> - NetworkPolicy: Pod 간 트래픽 제어 (방화벽 규칙)
> - Service Mesh: Istio, Linkerd로 트래픽 관리, mTLS
> - ExternalName: 외부 DNS를 클러스터 내 서비스로 매핑
>
> **Q: NetworkPolicy의 기본 동작은?**
> **A:** NetworkPolicy가 없으면 모든 트래픽 허용. 하나라도 적용되면 명시적으로 허용된 트래픽만 통과(화이트리스트).
>
> **Q: Service Mesh 도입 시 고려사항은?**
> **A:** 사이드카 프록시로 인한 리소스 오버헤드, 복잡성 증가, 학습 곡선. mTLS, 트래픽 관리, 관측성 필요성 평가 후 도입.

---

## 8. Kubernetes 스토리지

### 개념 설명
Kubernetes는 PersistentVolume(PV)과 PersistentVolumeClaim(PVC)으로 스토리지를 추상화한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - PersistentVolume(PV): 클러스터 수준의 스토리지 리소스
> - PersistentVolumeClaim(PVC): 사용자의 스토리지 요청
> - Volume: Pod 내 컨테이너 간 공유 저장소
>
> **Q: PV와 PVC의 관계는?**
> **A:** PV는 실제 스토리지, PVC는 스토리지 요청서. PVC가 조건에 맞는 PV에 바인딩되어 Pod에서 사용.
>
> **Q: emptyDir 볼륨의 특성은?**
> **A:** Pod가 노드에 할당될 때 생성, Pod 삭제 시 함께 삭제. 임시 데이터나 컨테이너 간 파일 공유용.

> ⭐⭐ **Level 2 (주니어)**
> - StorageClass: 동적 프로비저닝을 위한 스토리지 템플릿
> - Access Modes: ReadWriteOnce, ReadOnlyMany, ReadWriteMany
> - Reclaim Policy: Retain, Delete, Recycle
>
> **Q: Dynamic Provisioning의 장점은?**
> **A:** PVC 생성 시 자동으로 PV가 프로비저닝된다. 관리자가 미리 PV를 생성할 필요 없어 운영 부담 감소.
>
> **Q: ReadWriteMany를 지원하는 스토리지는?**
> **A:** NFS, CephFS, GlusterFS, AWS EFS 등 네트워크 파일시스템. EBS, GCE PD는 ReadWriteOnce만 지원.

> ⭐⭐⭐ **Level 3 (시니어)**
> - CSI(Container Storage Interface): 스토리지 플러그인 표준
> - Volume Snapshot: PVC의 특정 시점 백업
> - Volume Expansion: 실행 중 볼륨 크기 확장
>
> **Q: in-tree vs CSI 드라이버의 차이는?**
> **A:** in-tree는 K8s 코어에 내장, CSI는 독립 플러그인. CSI는 K8s 릴리스와 독립적으로 업데이트 가능하고 표준화됨.
>
> **Q: StatefulSet과 스토리지의 관계는?**
> **A:** volumeClaimTemplates로 각 Pod에 별도의 PVC 자동 생성. Pod 재시작 시에도 같은 PV에 재연결되어 상태 유지.

---

## 9. Kubernetes 설정 관리

### 개념 설명
ConfigMap과 Secret으로 설정과 민감 정보를 Pod에서 분리하여 관리한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - ConfigMap: 비밀이 아닌 설정 데이터 저장
> - Secret: 비밀번호, 토큰, 키 등 민감 정보 저장
>
> **Q: ConfigMap과 Secret의 주요 차이는?**
> **A:** Secret은 base64 인코딩(암호화 아님)되고, 메모리에만 저장되는 tmpfs 마운트 옵션이 있다. 권한 관리도 별도로 가능.
>
> **Q: 환경변수 vs 볼륨 마운트 선택 기준은?**
> **A:** 단순 값은 환경변수, 파일 형태 설정(config 파일)은 볼륨 마운트. 볼륨 마운트는 실행 중 업데이트 가능.

> ⭐⭐ **Level 2 (주니어)**
> - envFrom: ConfigMap/Secret 전체를 환경변수로
> - subPath: 볼륨의 특정 파일만 마운트
> - immutable: 변경 불가능 ConfigMap/Secret (성능 향상)
>
> **Q: ConfigMap 변경이 Pod에 반영되는 시점은?**
> **A:** 볼륨 마운트는 kubelet sync 주기(기본 1분)에 따라 자동 업데이트. 환경변수는 Pod 재시작 필요.
>
> **Q: Secret을 안전하게 관리하는 방법은?**
> **A:** RBAC로 접근 제한, etcd 암호화 활성화, 외부 비밀 관리자(Vault, AWS Secrets Manager) 연동.

> ⭐⭐⭐ **Level 3 (시니어)**
> - External Secrets Operator: 외부 비밀 저장소와 동기화
> - Sealed Secrets: Git에 암호화된 Secret 저장
>
> **Q: GitOps에서 Secret을 안전하게 관리하는 방법은?**
> **A:** Sealed Secrets로 암호화하여 Git 저장, 또는 External Secrets Operator로 Vault/AWS Secrets Manager에서 동기화.

---

## 10. Kubernetes 스케일링

### 개념 설명
Kubernetes는 워크로드와 클러스터를 자동으로 스케일링할 수 있다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 수평 스케일링: Pod 수 증가/감소
> - 수직 스케일링: Pod 리소스(CPU/메모리) 증가/감소
>
> **Q: 수평 vs 수직 스케일링 선택 기준은?**
> **A:** 대부분 수평 스케일링 선호(무중단, 고가용성). 수직은 단일 Pod 성능이 중요할 때(DB, 메모리 집약 작업).

> ⭐⭐ **Level 2 (주니어)**
> - HPA(Horizontal Pod Autoscaler): CPU/메모리 기반 자동 Pod 스케일링
> - metrics-server: 리소스 메트릭 수집
>
> **Q: HPA 설정 시 주의할 점은?**
> **A:** Pod에 resource requests 설정 필수. 스케일 업/다운 안정화 기간으로 빈번한 스케일링 방지. 최소/최대 레플리카 적절히 설정.
>
> **Q: HPA가 동작하지 않을 때 확인할 사항은?**
> **A:** metrics-server 정상 동작, Pod의 resource requests 설정, HPA 이벤트 로그, 대상 Deployment 존재 확인.

> ⭐⭐⭐ **Level 3 (시니어)**
> - VPA(Vertical Pod Autoscaler): 자동 리소스 추천 및 조정
> - Cluster Autoscaler: 노드 수 자동 조정
> - KEDA: 이벤트 기반 스케일링 (큐 길이, HTTP 요청 등)
>
> **Q: HPA와 VPA를 함께 사용할 수 있는가?**
> **A:** CPU/메모리 기반으로 둘 다 사용하면 충돌. VPA는 추천 모드만 사용하고 HPA를 활성화하거나, KEDA 커스텀 메트릭 사용.
>
> **Q: KEDA의 장점은?**
> **A:** 외부 이벤트 소스(Kafka, RabbitMQ, Redis, Prometheus) 기반 스케일링. 0으로 스케일 다운 가능하여 비용 절감.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 멀티 클러스터 스케일링: Federation, 글로벌 로드밸런싱
> - 비용 최적화: Spot/Preemptible 인스턴스, 리소스 right-sizing
>
> **Q: Spot 인스턴스를 프로덕션에 사용할 때 주의점은?**
> **A:** 중단 허용 워크로드만 배치, PDB 설정, 온디맨드 노드 풀 유지, 중단 핸들러로 graceful shutdown.

---

## 11. Kubernetes 보안

### 개념 설명
Kubernetes 보안은 인증, 인가, 어드미션 컨트롤, 런타임 보안의 다층 구조이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - RBAC: Role-Based Access Control
> - ServiceAccount: Pod의 API 서버 인증 ID
>
> **Q: RBAC의 구성요소는?**
> **A:** Role(권한 정의), RoleBinding(사용자/그룹에 Role 할당). 클러스터 범위는 ClusterRole, ClusterRoleBinding.
>
> **Q: 기본 ServiceAccount의 위험성은?**
> **A:** 네임스페이스의 default SA는 과도한 권한을 가질 수 있다. 각 애플리케이션용 전용 SA 생성 권장.

> ⭐⭐ **Level 2 (주니어)**
> - Pod Security Standards: Privileged, Baseline, Restricted 정책
> - SecurityContext: Pod/컨테이너 수준 보안 설정
>
> **Q: SecurityContext에서 설정할 수 있는 것은?**
> **A:** runAsNonRoot, readOnlyRootFilesystem, capabilities, allowPrivilegeEscalation, seccompProfile 등.
>
> **Q: Pod Security Standards의 세 가지 레벨은?**
> **A:** Privileged(제한 없음), Baseline(기본 보안), Restricted(강화된 보안). 네임스페이스에 enforce/audit/warn 모드 적용.

> ⭐⭐⭐ **Level 3 (시니어)**
> - OPA/Gatekeeper: 정책 기반 어드미션 컨트롤
> - Falco: 런타임 보안 모니터링
> - 이미지 스캐닝: Trivy Operator, 어드미션 시 스캔
>
> **Q: OPA Gatekeeper의 동작 원리는?**
> **A:** Admission Webhook으로 리소스 생성/수정 요청을 가로채고, Rego 언어로 작성된 정책을 평가하여 허용/거부.
>
> **Q: Falco가 감지할 수 있는 위협은?**
> **A:** 예상치 못한 프로세스 실행, 파일 시스템 변경, 네트워크 연결, 권한 상승 시도, 컨테이너 탈출 시도.

---

## 12. Kubernetes 운영

### 개념 설명
Kubernetes 클러스터의 효과적인 운영을 위한 디버깅, 로깅, 모니터링 방법.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - kubectl get/describe/logs: 기본 조회 명령어
> - kubectl exec: 컨테이너 내부 접속
>
> **Q: Pod 문제 디버깅 순서는?**
> **A:** `kubectl get pods` → `kubectl describe pod` → `kubectl logs` → `kubectl exec`으로 상태, 이벤트, 로그, 내부 확인.

> ⭐⭐ **Level 2 (주니어)**
> - kubectl debug: 디버그 컨테이너 생성
> - kubectl top: 리소스 사용량 확인
> - kubectl port-forward: 로컬에서 Pod/Service 접근
>
> **Q: CrashLoopBackOff 디버깅 방법은?**
> **A:** `kubectl logs --previous`로 이전 컨테이너 로그 확인, describe로 이벤트 확인, 리소스 제한, 프로브 설정, 의존성 확인.
>
> **Q: kubectl debug의 사용 사례는?**
> **A:** distroless 이미지처럼 셸이 없는 컨테이너 디버깅, 네트워크 도구가 필요할 때, 프로세스 네임스페이스 공유 디버깅.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 노드 관리: cordon, drain, taint
> - 리소스 쿼터: 네임스페이스별 리소스 제한
> - LimitRange: Pod 기본 리소스 설정
>
> **Q: 노드 유지보수 절차는?**
> **A:** `kubectl cordon node`(스케줄링 비활성화) → `kubectl drain node`(Pod 이전) → 유지보수 → `kubectl uncordon node`.
>
> **Q: ResourceQuota vs LimitRange 차이는?**
> **A:** ResourceQuota는 네임스페이스 전체 리소스 총량 제한. LimitRange는 개별 Pod/Container의 기본값과 범위 설정.

---

## 13. CI/CD 파이프라인

### 개념 설명
CI(Continuous Integration)는 코드 변경의 자동 빌드/테스트, CD(Continuous Delivery/Deployment)는 자동 배포까지 확장한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - CI: 코드 통합 시 자동 빌드, 테스트
> - CD: 자동화된 배포 파이프라인
> - 파이프라인: 빌드 → 테스트 → 배포 단계
>
> **Q: CI의 핵심 원칙은?**
> **A:** 자주 통합(하루에 여러 번), 모든 커밋에 자동 빌드/테스트, 빠른 피드백, 실패 시 즉시 수정.
>
> **Q: Continuous Delivery vs Continuous Deployment 차이는?**
> **A:** Delivery는 프로덕션 배포 전 수동 승인, Deployment는 모든 변경이 자동으로 프로덕션까지 배포.

> ⭐⭐ **Level 2 (주니어)**
> - GitHub Actions: 워크플로우 파일(.github/workflows/)
> - 트리거: push, pull_request, schedule, workflow_dispatch
> - 매트릭스 빌드: 여러 환경에서 병렬 테스트
>
> **Q: GitHub Actions의 jobs와 steps 차이는?**
> **A:** Job은 독립적인 실행 환경(러너), Step은 Job 내에서 순차 실행되는 개별 작업. Job 간에는 병렬 실행 가능.
>
> **Q: 시크릿을 안전하게 사용하는 방법은?**
> **A:** Repository/Organization secrets에 저장, 로그에 마스킹됨, 포크된 PR에서는 접근 제한, OIDC로 클라우드 인증.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 재사용 가능 워크플로우: workflow_call로 공통 로직 추출
> - 캐싱: 의존성 캐시로 빌드 시간 단축
> - 셀프 호스티드 러너: 특수 환경, 비용 절감
>
> **Q: GitHub Actions 캐싱 전략은?**
> **A:** actions/cache로 node_modules, .m2, pip 캐시. 키는 lock 파일 해시 기반. restore-keys로 부분 매칭.
>
> **Q: 모노레포에서 변경된 패키지만 빌드하려면?**
> **A:** paths 필터, dorny/paths-filter 액션, 또는 Turborepo/Nx 같은 빌드 시스템의 영향 분석 기능 활용.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 파이프라인 보안: SLSA, Sigstore, 아티팩트 증명
> - 플랫폼 엔지니어링: 내부 개발자 플랫폼, 골든 패스
>
> **Q: SLSA(Supply-chain Levels for Software Artifacts)란?**
> **A:** 소프트웨어 공급망 보안 프레임워크. 빌드 과정의 무결성, 출처 증명, 변조 방지를 레벨별로 정의.

---

## 14. 배포 전략

### 개념 설명
무중단 배포를 위한 다양한 전략과 각각의 장단점을 이해해야 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - Rolling Update: 점진적으로 새 버전 Pod 교체
> - Recreate: 기존 Pod 모두 종료 후 새 버전 시작
>
> **Q: Rolling Update의 장점은?**
> **A:** 무중단 배포, 점진적 교체로 위험 감소, 문제 시 빠른 롤백 가능.
>
> **Q: Recreate 전략은 언제 사용하는가?**
> **A:** 여러 버전이 동시에 실행되면 안 되는 경우(스키마 비호환, 싱글턴 리소스), 개발/테스트 환경에서 빠른 배포.

> ⭐⭐ **Level 2 (주니어)**
> - maxSurge, maxUnavailable: Rolling Update 속도 제어
> - Blue-Green: 두 환경 간 트래픽 전환
> - Canary: 일부 트래픽만 새 버전으로
>
> **Q: maxSurge=1, maxUnavailable=0의 의미는?**
> **A:** 한 번에 하나의 새 Pod만 추가하고, 기존 Pod는 새 Pod가 Ready가 된 후에만 종료. 가장 안전하지만 느림.
>
> **Q: Blue-Green 배포의 장단점은?**
> **A:** 장점: 즉각적인 전환과 롤백. 단점: 두 배의 리소스 필요, 데이터베이스 마이그레이션 복잡.
>
> **Q: Canary 릴리스의 트래픽 비율 결정 방법은?**
> **A:** 일반적으로 1% → 5% → 25% → 100%로 점진적 증가. 에러율, 레이턴시 모니터링하며 단계별 승인.

> ⭐⭐⭐ **Level 3 (시니어)**
> - A/B 테스트: 사용자 세그먼트별 다른 버전
> - Feature Flag: 코드 배포와 기능 릴리스 분리
> - Progressive Delivery: Argo Rollouts, Flagger
>
> **Q: Feature Flag의 장점은?**
> **A:** 배포와 릴리스 분리, 빠른 롤백(코드 배포 없이), A/B 테스트, 점진적 롤아웃, 특정 사용자에게만 기능 활성화.
>
> **Q: Argo Rollouts의 기능은?**
> **A:** Blue-Green, Canary 전략 내장, 자동화된 분석(Prometheus 메트릭), 실험 기능, Service Mesh 통합.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 멀티 클러스터 배포: 리전별 순차 배포
> - 위험 관리: 배포 창(deploy window), 변경 동결 기간
>
> **Q: 글로벌 서비스의 배포 전략은?**
> **A:** 트래픽 적은 리전부터 순차 배포, 리전 간 의존성 고려, 글로벌 피처 플래그, 시간대별 배포 창 설정.

---

## 15. GitOps

### 개념 설명
GitOps는 Git을 단일 진실 공급원(Single Source of Truth)으로 사용하여 인프라와 애플리케이션을 선언적으로 관리하는 방법론이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - GitOps 원칙: 선언적 설정, 버전 관리, 자동 동기화
> - Pull 기반 배포: 클러스터가 Git 저장소 변경 감지
>
> **Q: GitOps가 기존 CI/CD와 다른 점은?**
> **A:** Push 기반(CI가 클러스터에 배포) 대신 Pull 기반(클러스터가 Git에서 원하는 상태를 가져옴). 클러스터 자격증명을 CI에 노출하지 않음.
>
> **Q: GitOps의 장점은?**
> **A:** 감사 추적(Git 히스토리), 쉬운 롤백(git revert), 재해 복구(Git에서 전체 상태 복원), 일관성 보장.

> ⭐⭐ **Level 2 (주니어)**
> - ArgoCD: Kubernetes용 GitOps 도구
> - Application CRD: 배포 대상과 소스 정의
> - Sync: Git 상태와 클러스터 상태 동기화
>
> **Q: ArgoCD의 Sync Policy 옵션은?**
> **A:** Auto-Sync(자동 동기화), Self-Heal(수동 변경 복원), Prune(삭제된 리소스 제거), Sync Options(replace, server-side apply).
>
> **Q: ArgoCD의 Health 상태 종류는?**
> **A:** Healthy, Progressing, Degraded, Suspended, Missing, Unknown. 리소스 종류별로 health check 정의.

> ⭐⭐⭐ **Level 3 (시니어)**
> - App of Apps 패턴: 애플리케이션을 관리하는 애플리케이션
> - ApplicationSet: 동적 애플리케이션 생성
> - Flux: 또 다른 GitOps 도구, 모듈화된 컴포넌트
>
> **Q: App of Apps 패턴의 사용 사례는?**
> **A:** 환경별(dev/staging/prod) 애플리케이션 그룹 관리, 마이크로서비스 세트 배포, 클러스터 부트스트래핑.
>
> **Q: ArgoCD vs Flux 선택 기준은?**
> **A:** ArgoCD는 UI 우수, 멀티테넌시 강점. Flux는 모듈화, Helm/Kustomize 통합 우수. 조직 요구사항에 맞게 선택.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 멀티 클러스터 GitOps: 중앙 집중 vs 분산 관리
> - 정책 기반 배포: OPA와 GitOps 통합
>
> **Q: 대규모 조직에서 GitOps 거버넌스 전략은?**
> **A:** 중앙 플랫폼팀이 기본 정책과 템플릿 관리, 팀별 네임스페이스 자율권 부여, RBAC과 ApplicationProject로 권한 분리.

---

## 16. Infrastructure as Code (IaC)

### 개념 설명
IaC는 인프라를 코드로 정의하여 버전 관리, 재현성, 자동화를 실현한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - IaC 도구: Terraform, Pulumi, CloudFormation, Ansible
> - 선언적 vs 명령형: 원하는 상태 선언 vs 실행 순서 정의
>
> **Q: IaC의 핵심 이점은?**
> **A:** 재현 가능한 인프라, 버전 관리, 코드 리뷰, 자동화된 프로비저닝, 환경 일관성, 문서화.
>
> **Q: Terraform이 널리 사용되는 이유는?**
> **A:** 클라우드 중립적, 풍부한 프로바이더, 선언적 HCL 문법, 상태 관리, 큰 커뮤니티.

> ⭐⭐ **Level 2 (주니어)**
> - Terraform State: 실제 인프라 상태 추적
> - 모듈: 재사용 가능한 리소스 그룹
> - plan/apply: 변경 사항 미리보기와 적용
>
> **Q: Terraform State를 원격 저장해야 하는 이유는?**
> **A:** 팀 협업, State 잠금으로 동시 수정 방지, 백업, CI/CD 통합. S3+DynamoDB, Terraform Cloud 등 사용.
>
> **Q: Terraform 모듈 설계 원칙은?**
> **A:** 단일 책임, 적절한 입출력 변수, 기본값 제공, 문서화, 버전 관리, 테스트 가능성.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 워크스페이스: 환경별 State 분리
> - Terragrunt: DRY 원칙, 의존성 관리
> - State 마이그레이션: moved 블록, state mv
>
> **Q: Terraform 워크스페이스 vs 디렉토리 분리 선택은?**
> **A:** 워크스페이스는 같은 구성의 환경 분리에 적합. 디렉토리 분리는 환경별로 다른 구성이 필요하거나 명시적 분리 원할 때.
>
> **Q: Terraform State 드리프트 해결 방법은?**
> **A:** `terraform refresh`로 State 갱신, `terraform import`로 기존 리소스 가져오기, 필요시 State 수동 편집(주의 필요).

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - Policy as Code: Sentinel, OPA로 규정 준수 자동화
> - 대규모 Terraform 관리: 모노레포 vs 폴리레포, 모듈 레지스트리
>
> **Q: 대규모 조직의 IaC 거버넌스 전략은?**
> **A:** 중앙 모듈 레지스트리, 버전 관리 정책, Policy as Code로 규정 준수, 자동화된 테스트, 문서화 표준.

---

## 17. 아티팩트 관리

### 개념 설명
빌드 아티팩트(컨테이너 이미지, 패키지, 차트)의 저장, 버전 관리, 배포를 위한 체계.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 컨테이너 레지스트리: Docker Hub, ECR, GCR, ACR
> - 시맨틱 버저닝: MAJOR.MINOR.PATCH
>
> **Q: 시맨틱 버저닝의 각 숫자 의미는?**
> **A:** MAJOR: 호환성 깨지는 변경, MINOR: 하위 호환 기능 추가, PATCH: 하위 호환 버그 수정.
>
> **Q: latest 태그의 문제점은?**
> **A:** 어떤 버전인지 추적 불가, 재현성 없음, 캐시 문제. 프로덕션에서는 명시적 버전 태그 사용.

> ⭐⭐ **Level 2 (주니어)**
> - 이미지 태깅 전략: Git SHA, 버전, 날짜
> - Helm 차트: Kubernetes 패키지 매니저
> - Chart Repository: 차트 저장소
>
> **Q: 좋은 이미지 태깅 전략은?**
> **A:** `v1.2.3`(릴리스), `main-abc1234`(브랜치-커밋), `pr-123`(PR). 불변 태그 사용, latest는 개발용으로만.
>
> **Q: Helm 차트 버전 vs 앱 버전 차이는?**
> **A:** Chart version은 차트 패키지 버전, appVersion은 배포되는 애플리케이션 버전. 독립적으로 관리.

> ⭐⭐⭐ **Level 3 (시니어)**
> - OCI 레지스트리: Helm 차트를 컨테이너 레지스트리에 저장
> - 이미지 프로모션: dev → staging → prod 환경 간 이동
> - 가비지 컬렉션: 오래된 이미지 정리
>
> **Q: 이미지 프로모션 전략은?**
> **A:** 환경별 태그(dev-v1.0, prod-v1.0) 또는 별도 레지스트리/리포지토리 사용. 프로모션 시 재빌드 없이 태그만 추가/이동.
>
> **Q: 레지스트리 비용 최적화 방법은?**
> **A:** 보존 정책 설정(최근 N개 또는 N일), 태그 없는 이미지 정리, 베이스 이미지 공유, 멀티스테이지 빌드로 크기 감소.

---

## 18. 환경 분리

### 개념 설명
개발(dev), 스테이징(staging), 프로덕션(prod) 환경을 분리하여 안전하게 개발하고 테스트한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - dev: 개발자 테스트 환경
> - staging: 프로덕션 유사 환경, QA
> - prod: 실제 사용자 서비스 환경
>
> **Q: 환경 분리의 목적은?**
> **A:** 개발 중인 변경이 프로덕션에 영향 주지 않도록 격리, 각 단계별 테스트, 점진적 검증.

> ⭐⭐ **Level 2 (주니어)**
> - 환경별 설정: ConfigMap, Secret, 환경 변수
> - Kustomize: base + overlays로 환경별 커스터마이징
> - Helm values: 환경별 values 파일
>
> **Q: Kustomize vs Helm 선택 기준은?**
> **A:** Kustomize는 패치 기반으로 단순, K8s 내장. Helm은 템플릿 기반으로 복잡한 로직, 조건부 렌더링 가능. 혼용도 가능.
>
> **Q: 환경 간 설정 차이를 최소화하는 방법은?**
> **A:** 환경 변수와 시크릿만 다르게 하고 애플리케이션 코드와 설정은 동일하게. 12-Factor App 원칙 준수.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 프로모션 전략: dev → staging → prod 자동화
> - Preview 환경: PR별 임시 환경 생성
> - 데이터 분리: 환경 간 데이터 격리, 익명화
>
> **Q: PR별 Preview 환경 구현 방법은?**
> **A:** CI에서 PR 이벤트 시 임시 네임스페이스/클러스터 생성, ArgoCD ApplicationSet의 PR Generator, Vercel/Netlify의 Preview.
>
> **Q: 스테이징에 프로덕션 데이터 사용 시 주의점은?**
> **A:** PII 익명화/마스킹 필수, 규정 준수(GDPR 등), 데이터 동기화 주기, 접근 권한 제한.

---

## 19. 롤백

### 개념 설명
배포 실패나 문제 발생 시 이전 버전으로 빠르게 돌아가는 전략.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 롤백: 이전 안정 버전으로 되돌리기
> - kubectl rollout undo: Deployment 롤백 명령
>
> **Q: 롤백이 필요한 상황은?**
> **A:** 배포 후 에러율 증가, 성능 저하, 기능 버그 발견, 의존 서비스 비호환.
>
> **Q: Kubernetes에서 롤백이 빠른 이유는?**
> **A:** 이전 ReplicaSet이 보존되어 있어 새로 빌드/배포 없이 이전 Pod로 즉시 전환 가능.

> ⭐⭐ **Level 2 (주니어)**
> - revisionHistoryLimit: 보관할 ReplicaSet 수
> - 자동 롤백: Probe 실패 시 롤백
> - GitOps 롤백: git revert 후 동기화
>
> **Q: 자동 롤백 설정 방법은?**
> **A:** progressDeadlineSeconds 설정, Readiness/Liveness Probe 적절히 구성, Argo Rollouts의 자동 분석 기반 롤백.
>
> **Q: GitOps에서 롤백하는 방법은?**
> **A:** `git revert <commit>`으로 이전 상태 커밋, 또는 ArgoCD에서 이전 버전으로 수동 Sync.

> ⭐⭐⭐ **Level 3 (시니어)**
> - DB 마이그레이션 롤백: 스키마 변경의 하위 호환성
> - Feature Flag 롤백: 코드 배포 없이 기능 비활성화
> - 카나리 자동 롤백: 메트릭 기반 판단
>
> **Q: DB 마이그레이션과 롤백을 안전하게 하려면?**
> **A:** Expand and Contract 패턴: 1) 새 컬럼 추가 2) 양쪽 쓰기 3) 데이터 마이그레이션 4) 새 컬럼만 읽기 5) 구 컬럼 제거.
>
> **Q: Feature Flag 롤백의 장점은?**
> **A:** 즉각적(배포 불필요), 세분화된 제어(사용자 그룹별), 원인 분석 시간 확보, 부분 롤백 가능.

---

## 실무 시나리오

### 시나리오 1: 프로덕션 배포 실패
**상황**: Canary 배포 중 5xx 에러율 급증
**대응**:
1. 즉시 트래픽을 기존 버전으로 전환 (Argo Rollouts abort 또는 수동 롤백)
2. 로그와 메트릭으로 원인 파악
3. 수정 후 스테이징에서 충분히 검증
4. 더 작은 트래픽 비율로 재배포

### 시나리오 2: CI/CD 파이프라인 최적화
**상황**: 빌드 시간 15분으로 개발 생산성 저하
**대응**:
1. 빌드 단계 프로파일링으로 병목 식별
2. 의존성 캐싱 적용 (node_modules, Maven .m2)
3. 멀티스테이지 빌드로 테스트와 빌드 병렬화
4. 변경된 서비스만 빌드 (모노레포 영향 분석)

### 시나리오 3: Kubernetes 리소스 부족
**상황**: Pod가 Pending 상태로 스케줄링 안 됨
**대응**:
1. `kubectl describe pod`로 이벤트 확인
2. 노드 리소스 확인 (`kubectl describe nodes`)
3. HPA/Cluster Autoscaler 설정 확인
4. resource requests/limits 적정성 검토

---

## 면접 빈출 질문

**Q: Docker 이미지 빌드 최적화 방법을 설명해주세요.**
**A:** 1) 레이어 캐싱 활용 - 변경 적은 명령어를 먼저 2) 멀티스테이지 빌드로 빌드 도구 제외 3) .dockerignore로 불필요 파일 제외 4) 경량 베이스 이미지(alpine, distroless) 5) BuildKit 캐시 마운트로 패키지 캐시 재사용.

**Q: Kubernetes Rolling Update의 동작 원리를 설명해주세요.**
**A:** Deployment가 새 ReplicaSet을 생성하고 maxSurge/maxUnavailable에 따라 점진적으로 Pod를 교체합니다. 새 Pod가 Ready 상태가 되면 기존 Pod를 종료합니다. 문제 발생 시 progressDeadlineSeconds 초과하면 실패로 판단합니다.

**Q: GitOps의 장점과 구현 시 주의점은?**
**A:** 장점: Git 히스토리로 감사 추적, 쉬운 롤백, 재해 복구 용이, 선언적 상태 관리. 주의점: Secret 관리(Sealed Secrets/External Secrets), 동기화 지연 이해, 수동 변경 방지 정책, 대규모 클러스터의 성능.

**Q: Blue-Green과 Canary 배포의 차이와 선택 기준은?**
**A:** Blue-Green은 전체 트래픽을 한 번에 전환, 빠른 롤백 가능하지만 두 배 리소스 필요. Canary는 점진적 트래픽 이동으로 위험 감소, 메트릭 기반 자동 분석 가능. 리소스 제약이 있거나 점진적 검증이 중요하면 Canary, 빠른 전환과 명확한 롤백이 중요하면 Blue-Green.

**Q: Terraform State 관리 모범 사례는?**
**A:** 1) 원격 백엔드 사용(S3+DynamoDB) 2) State 잠금으로 동시 수정 방지 3) 환경별 State 분리 4) 민감 정보 암호화 5) 정기 백업 6) State 직접 편집 최소화 7) CI/CD에서만 apply.
