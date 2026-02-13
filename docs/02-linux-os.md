# 리눅스/OS - IT 서비스 운영 필수 지식

> 이 문서는 IT 서비스 운영에 필요한 리눅스/OS 지식을 레벨별로 정리한 학습 자료입니다.
> 퀴즈 생성 및 역량 평가에 활용할 수 있습니다.

## 레벨 가이드
| 레벨 | 대상 | 설명 |
|------|------|------|
| ⭐ Level 1 | 입문 | 개념 이해, 기본 용어 |
| ⭐⭐ Level 2 | 주니어 | 실무 적용, 트러블슈팅 기초 |
| ⭐⭐⭐ Level 3 | 시니어 | 아키텍처 설계, 성능 최적화 |
| ⭐⭐⭐⭐ Level 4 | 리드/CTO | 전략적 의사결정, 대규모 설계 |

---

## 1. 프로세스 관리 (Process Management)

### 개념 설명
프로세스는 실행 중인 프로그램의 인스턴스로, 운영체제가 자원을 할당하고 관리하는 기본 단위이다. 리눅스에서 모든 프로세스는 PID(Process ID)로 식별되며, 계층적 부모-자식 관계를 형성한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 프로세스는 실행 중인 프로그램이며 각각 고유한 PID를 가진다
> - `ps`, `top` 명령어로 프로세스 목록을 확인할 수 있다
> - 프로세스는 foreground와 background로 실행될 수 있다
>
> **Q: 프로세스와 프로그램의 차이는?**
> **A:** 프로그램은 디스크에 저장된 실행 파일(정적)이고, 프로세스는 메모리에 로드되어 실행 중인 프로그램의 인스턴스(동적)이다. 하나의 프로그램에서 여러 프로세스가 생성될 수 있다.
>
> **Q: PID 1번 프로세스는 무엇인가?**
> **A:** init 또는 systemd 프로세스로, 시스템 부팅 시 커널이 가장 먼저 실행하는 프로세스이다. 모든 사용자 프로세스의 조상이며 고아 프로세스를 입양한다.
>
> **Q: `ps aux`와 `ps -ef`의 차이는?**
> **A:** `ps aux`는 BSD 스타일로 CPU/메모리 사용률을 보여주고, `ps -ef`는 System V 스타일로 PPID(부모 PID)와 전체 명령어를 보여준다. 둘 다 모든 프로세스를 출력한다.
>
> **Q: background로 프로세스를 실행하는 방법은?**
> **A:** 명령어 끝에 `&`를 붙이거나, 실행 중인 프로세스에서 Ctrl+Z로 정지 후 `bg` 명령어를 사용한다.

> ⭐⭐ **Level 2 (주니어)**
> - fork()는 현재 프로세스를 복제하고, exec()는 새 프로그램으로 교체한다
> - 좀비 프로세스는 종료되었지만 부모가 wait()를 호출하지 않은 상태
> - 고아 프로세스는 부모가 먼저 종료되어 init/systemd가 입양한 프로세스
> - 주요 시그널: SIGTERM(15, 정상종료), SIGKILL(9, 강제종료), SIGHUP(1, 재시작)
>
> **Q: fork()와 exec()의 차이와 사용 시나리오는?**
> **A:** fork()는 현재 프로세스의 복사본을 만들어 자식 프로세스를 생성한다. exec()는 현재 프로세스의 메모리를 새 프로그램으로 완전히 교체한다. 쉘에서 명령어 실행 시 fork()로 자식을 만들고 exec()로 명령어를 실행하는 방식을 사용한다.
>
> **Q: 좀비 프로세스는 왜 문제가 되는가?**
> **A:** 좀비 프로세스는 CPU나 메모리를 사용하지 않지만 프로세스 테이블 엔트리를 차지한다. 대량 발생 시 PID 고갈로 새 프로세스 생성이 불가능해질 수 있다. 해결책은 부모 프로세스가 wait()를 호출하거나 부모를 종료시키는 것이다.
>
> **Q: SIGTERM과 SIGKILL의 차이는?**
> **A:** SIGTERM(15)은 프로세스에게 정상 종료를 요청하여 cleanup 작업이 가능하고 프로세스가 무시할 수 있다. SIGKILL(9)은 커널이 즉시 강제 종료하여 무시 불가능하고 cleanup 기회가 없다. 항상 SIGTERM을 먼저 시도해야 한다.
>
> **Q: SIGHUP의 용도는?**
> **A:** 원래는 터미널 연결 끊김을 알리는 시그널이었으나, 현재는 데몬 프로세스에서 설정 파일 재로딩 용도로 관례적으로 사용된다. nginx, Apache 등이 SIGHUP으로 graceful reload를 수행한다.
>
> **Q: nohup의 역할은?**
> **A:** 프로세스가 SIGHUP을 무시하도록 하여 터미널 종료 시에도 계속 실행되게 한다. `nohup command &`로 사용하며 출력은 nohup.out에 저장된다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 프로세스 상태: R(Running), S(Sleeping), D(Uninterruptible Sleep), Z(Zombie), T(Stopped)
> - D 상태는 I/O 대기 중으로 SIGKILL로도 종료 불가
> - nice 값(-20~19)으로 CPU 스케줄링 우선순위 조정
> - /proc/[pid]/ 를 통한 프로세스 상세 정보 확인
>
> **Q: D 상태(Uninterruptible Sleep) 프로세스가 많으면 어떤 문제인가?**
> **A:** D 상태는 주로 디스크 I/O나 NFS 응답 대기 중에 발생한다. 이 상태의 프로세스가 많으면 스토리지 시스템 문제(디스크 장애, NFS 서버 응답 없음, I/O 병목)를 의심해야 한다. SIGKILL로도 종료할 수 없어 시스템 재부팅이 필요할 수 있다.
>
> **Q: nice와 renice의 차이와 사용법은?**
> **A:** nice는 프로세스 시작 시 우선순위를 설정하고(`nice -n 10 command`), renice는 실행 중인 프로세스의 우선순위를 변경한다(`renice -n 5 -p PID`). 낮은 값이 높은 우선순위이며, 일반 사용자는 우선순위를 낮출 수만 있고 root만 높일 수 있다.
>
> **Q: /proc/[pid]/fd 디렉토리의 용도는?**
> **A:** 해당 프로세스가 열어둔 모든 파일 디스크립터를 심볼릭 링크로 보여준다. `ls -la /proc/PID/fd`로 프로세스가 어떤 파일, 소켓, 파이프를 열어뒀는지 확인할 수 있어 파일 핸들 누수 디버깅에 유용하다.
>
> **Q: /proc/[pid]/status에서 확인할 수 있는 중요 정보는?**
> **A:** VmRSS(실제 메모리 사용량), VmSize(가상 메모리 크기), Threads(스레드 수), State(프로세스 상태), PPid(부모 PID), voluntary_ctxt_switches/nonvoluntary_ctxt_switches(컨텍스트 스위칭 횟수)를 확인할 수 있다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - CFS(Completely Fair Scheduler)의 동작 원리와 튜닝
> - cgroup을 통한 프로세스 그룹 리소스 제한
> - 실시간 스케줄링 정책(SCHED_FIFO, SCHED_RR)
> - 대규모 프로세스 관리 아키텍처 설계
>
> **Q: CFS 스케줄러의 핵심 개념인 vruntime은 무엇인가?**
> **A:** vruntime(virtual runtime)은 프로세스가 CPU를 사용한 가상 시간으로, 프로세스의 우선순위(nice 값)에 따라 가중치가 적용된다. CFS는 항상 vruntime이 가장 작은 프로세스를 다음에 실행하여 공정성을 보장한다. Red-Black 트리로 관리되어 O(log N) 복잡도로 다음 프로세스를 선택한다.
>
> **Q: SCHED_FIFO와 SCHED_RR의 차이와 사용 시나리오는?**
> **A:** 둘 다 실시간 스케줄링 정책이다. SCHED_FIFO는 더 높은 우선순위 프로세스가 나타나거나 스스로 양보할 때까지 CPU를 독점한다. SCHED_RR은 같은 우선순위 프로세스 간 라운드로빈으로 타임슬라이스를 나눈다. 산업용 제어 시스템, 오디오/비디오 처리 등 지연 시간이 중요한 곳에서 사용한다.
>
> **Q: 대규모 서비스에서 프로세스 관리 전략은?**
> **A:** systemd의 cgroup을 활용한 리소스 격리, MemoryMax/CPUQuota로 runaway 프로세스 방지, OOMScoreAdjust로 중요 프로세스 보호, 프로세스 풀링 패턴으로 fork() 오버헤드 감소, 컨테이너화로 프로세스 그룹 관리 단순화를 적용한다.

### 실무 시나리오

**시나리오 1: 좀비 프로세스 대량 발생**
```bash
# 좀비 프로세스 확인
ps aux | grep 'Z'

# 좀비의 부모 프로세스 찾기
ps -o ppid= -p <zombie_pid>

# 부모 프로세스 확인 및 처리
# 부모에게 SIGCHLD 전송하거나 부모 프로세스 재시작
kill -SIGCHLD <parent_pid>
```

**시나리오 2: 응답 없는 프로세스 처리**
```bash
# 프로세스 상태 확인
cat /proc/<pid>/status | grep State

# D 상태면 I/O 문제 확인
cat /proc/<pid>/stack  # 커널 스택 확인
lsof -p <pid>          # 열린 파일 확인

# 정상 종료 시도 후 강제 종료
kill -TERM <pid>
sleep 5
kill -KILL <pid>
```

### 면접 빈출 질문
- **Q: 프로세스와 스레드의 차이를 설명하시오.**
- **A:** 프로세스는 독립된 메모리 공간(코드, 데이터, 힙, 스택)을 가지며 IPC를 통해 통신한다. 스레드는 같은 프로세스 내에서 힙과 코드를 공유하고 각자의 스택만 가진다. 프로세스 생성은 fork()로 무겁고, 스레드 생성은 가볍다. 스레드는 메모리 공유로 통신이 빠르지만 동기화 문제가 발생할 수 있다.

- **Q: kill -9를 먼저 사용하면 안 되는 이유는?**
- **A:** SIGKILL(9)은 프로세스가 cleanup 작업(파일 닫기, 임시 파일 삭제, 연결 정리)을 수행할 기회 없이 즉시 종료된다. 데이터 손실, 파일 잠금 미해제, 좀비 자식 프로세스 등의 문제가 발생할 수 있다. 항상 SIGTERM(15)을 먼저 시도하고 응답이 없을 때만 SIGKILL을 사용해야 한다.

---

## 2. 스레드 vs 프로세스 (Thread vs Process)

### 개념 설명
스레드는 프로세스 내의 실행 단위로, 같은 프로세스의 스레드들은 메모리 공간을 공유한다. 리눅스에서는 clone() 시스템콜로 스레드를 구현하며, 커널 관점에서 스레드와 프로세스는 모두 task_struct로 관리된다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 스레드는 프로세스 내의 경량 실행 단위이다
> - 같은 프로세스의 스레드들은 메모리를 공유한다
> - 멀티스레딩으로 병렬 처리가 가능하다
>
> **Q: 왜 멀티스레딩을 사용하는가?**
> **A:** 여러 작업을 동시에 처리하여 응답성을 높이고, 메모리를 공유하므로 프로세스보다 생성 비용이 적고 통신이 빠르다. 멀티코어 CPU를 효율적으로 활용할 수 있다.
>
> **Q: 스레드가 공유하는 것과 공유하지 않는 것은?**
> **A:** 공유: 코드 영역, 데이터 영역, 힙, 열린 파일, 시그널 핸들러. 비공유: 스택, 레지스터, 스레드 ID, 시그널 마스크, errno.
>
> **Q: 스레드 생성이 프로세스 생성보다 빠른 이유는?**
> **A:** 스레드는 메모리 공간을 복사할 필요 없이 기존 주소 공간을 공유하고, 새로운 스택만 할당하면 되기 때문이다.

> ⭐⭐ **Level 2 (주니어)**
> - POSIX 스레드(pthread)는 리눅스 표준 스레드 라이브러리
> - 경량 프로세스(LWP)는 리눅스에서 스레드를 구현하는 방식
> - Green Thread는 사용자 공간에서 관리되는 스레드(커널 지원 없음)
> - 스레드 안전성(thread safety)과 동기화 필요성
>
> **Q: pthread와 커널 스레드의 관계는?**
> **A:** 리눅스에서 pthread는 NPTL(Native POSIX Thread Library)로 구현되며, 각 pthread는 1:1로 커널 스레드(LWP)에 매핑된다. `ps -eLf`로 LWP를 확인할 수 있다.
>
> **Q: Green Thread와 Native Thread의 차이는?**
> **A:** Green Thread는 사용자 공간의 런타임이 관리하여 커널 개입 없이 빠르게 전환되지만 멀티코어를 활용할 수 없다. Native Thread는 커널이 스케줄링하여 멀티코어 활용이 가능하지만 컨텍스트 스위칭 비용이 크다. Go의 goroutine, Java의 가상 스레드는 M:N 모델로 둘의 장점을 결합했다.
>
> **Q: 스레드 안전한 코드를 작성하는 방법은?**
> **A:** 공유 자원에 뮤텍스/세마포어로 동기화, 불변 객체 사용, 스레드 로컬 저장소(TLS) 활용, 원자적 연산 사용, 락 없는(lock-free) 자료구조 사용 등이 있다.
>
> **Q: 데드락 발생 조건 4가지는?**
> **A:** 상호 배제(Mutual Exclusion), 점유 대기(Hold and Wait), 비선점(No Preemption), 순환 대기(Circular Wait). 이 중 하나라도 깨면 데드락을 방지할 수 있다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 리눅스 clone() 시스템콜의 플래그로 공유 수준 제어
> - NPTL(Native POSIX Thread Library)의 구현
> - futex(Fast Userspace Mutex)의 동작 원리
> - 스레드 풀 패턴과 적정 스레드 수 산정
>
> **Q: clone() 시스템콜의 주요 플래그는?**
> **A:** CLONE_VM(메모리 공유), CLONE_FS(파일시스템 정보 공유), CLONE_FILES(파일 디스크립터 공유), CLONE_SIGHAND(시그널 핸들러 공유), CLONE_THREAD(같은 스레드 그룹). 모든 플래그를 사용하면 스레드, 일부만 사용하면 특수 목적의 프로세스가 된다.
>
> **Q: futex가 빠른 이유는?**
> **A:** 경쟁이 없을 때(uncontended case) 커널 진입 없이 사용자 공간의 원자적 연산만으로 락을 획득/해제한다. 경쟁 발생 시에만 커널의 대기 큐를 사용한다. 대부분의 락 연산이 경쟁 없이 이루어지므로 성능이 좋다.
>
> **Q: 적정 스레드 풀 크기 산정 공식은?**
> **A:** CPU 바운드 작업: 스레드 수 = CPU 코어 수 + 1. I/O 바운드 작업: 스레드 수 = CPU 코어 수 * (1 + 대기시간/처리시간). 또는 Little's Law를 적용하여 동시 요청 수 = 도착률 * 평균 처리 시간으로 계산한다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 동시성 모델 비교: 멀티프로세스, 멀티스레드, 이벤트 드리븐, 코루틴
> - C10K/C10M 문제와 해결 전략
> - False sharing과 캐시 라인 최적화
> - NUMA 환경에서의 스레드 배치
>
> **Q: 이벤트 드리븐 vs 멀티스레드 아키텍처 선택 기준은?**
> **A:** 이벤트 드리븐(Node.js, nginx)은 I/O 바운드 작업에 적합하고 메모리 효율적이며 C10K 문제에 강하다. 멀티스레드는 CPU 바운드 작업에 적합하고 블로킹 연산 처리가 쉽다. 현대 시스템은 하이브리드(이벤트 루프 + 스레드 풀)를 많이 사용한다.
>
> **Q: False sharing이란 무엇이고 어떻게 해결하는가?**
> **A:** 서로 다른 CPU 코어가 같은 캐시 라인에 있는 다른 변수를 수정할 때 캐시 무효화가 발생하여 성능이 저하되는 현상이다. 해결 방법: 변수를 캐시 라인 크기(보통 64바이트)로 패딩하거나 정렬, 또는 각 스레드가 자신만의 데이터 구조를 사용하도록 분리한다.
>
> **Q: NUMA 환경에서 성능 최적화 전략은?**
> **A:** numactl로 프로세스를 특정 NUMA 노드에 바인딩, 메모리를 로컬 노드에서 할당, 스레드와 데이터를 같은 노드에 배치, NUMA-aware 메모리 할당자 사용. 원격 메모리 접근은 2-3배 느리므로 로컬리티가 중요하다.

### 실무 시나리오

**시나리오: 스레드 수 폭증으로 인한 메모리 부족**
```bash
# 프로세스별 스레드 수 확인
ps -eLf | awk '{print $2}' | sort | uniq -c | sort -rn | head

# 특정 프로세스의 스레드 상태
cat /proc/<pid>/status | grep Threads

# 스택 크기 확인 (기본 8MB)
ulimit -s

# 해결: 스레드 풀 사용, 스택 크기 조정
# 또는 비동기 I/O로 전환
```

### 면접 빈출 질문
- **Q: 컨텍스트 스위칭이란 무엇이고 비용은?**
- **A:** CPU가 현재 실행 중인 프로세스/스레드의 상태(레지스터, PC 등)를 저장하고 다른 것을 로드하는 과정이다. 직접 비용: 레지스터 저장/복원. 간접 비용: CPU 캐시, TLB, 분기 예측기 무효화. 프로세스 간 전환이 스레드 간 전환보다 비용이 크다(메모리 맵 변경 필요).

---

## 3. 메모리 관리 (Memory Management)

### 개념 설명
리눅스는 가상 메모리 시스템을 사용하여 각 프로세스에 독립된 주소 공간을 제공한다. MMU(Memory Management Unit)가 가상 주소를 물리 주소로 변환하며, 페이징을 통해 메모리를 효율적으로 관리한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 가상 메모리는 각 프로세스에 독립된 주소 공간을 제공한다
> - RAM이 부족하면 swap 공간(디스크)을 사용한다
> - `free`, `top` 명령어로 메모리 사용량을 확인한다
>
> **Q: 가상 메모리를 사용하는 이유는?**
> **A:** 프로세스 간 메모리 격리로 보안/안정성 확보, 물리 메모리보다 큰 주소 공간 사용 가능, 메모리 단편화 문제 해결, 공유 라이브러리의 효율적 공유가 가능하다.
>
> **Q: `free -h` 출력에서 buff/cache는 무엇인가?**
> **A:** buffers는 블록 디바이스의 메타데이터 캐시, cache는 파일 내용 캐시이다. 이 메모리는 필요시 즉시 해제 가능하므로 실제 가용 메모리는 free + buff/cache이다. available 컬럼이 실제 사용 가능한 메모리를 보여준다.
>
> **Q: swap이 발생하면 왜 성능이 저하되는가?**
> **A:** 디스크 I/O 속도가 RAM보다 수천 배 느리기 때문이다. SSD도 RAM의 1/100 속도이다. swap 발생은 메모리 부족의 신호이며 시스템이 심하게 느려진다(thrashing).

> ⭐⭐ **Level 2 (주니어)**
> - 페이지는 메모리 관리의 기본 단위(기본 4KB)
> - 페이지 폴트는 접근한 페이지가 물리 메모리에 없을 때 발생
> - TLB(Translation Lookaside Buffer)는 주소 변환 캐시
> - mmap으로 파일을 메모리에 매핑할 수 있다
>
> **Q: Minor와 Major 페이지 폴트의 차이는?**
> **A:** Minor(soft) 페이지 폴트: 페이지가 물리 메모리에 있지만 페이지 테이블에 매핑 안 됨, 디스크 I/O 없이 해결. Major(hard) 페이지 폴트: 페이지가 디스크에서 로드되어야 함, 디스크 I/O 발생으로 느림. `ps -o min_flt,maj_flt`로 확인한다.
>
> **Q: TLB miss가 성능에 미치는 영향은?**
> **A:** TLB miss 시 페이지 테이블을 여러 레벨 탐색해야 하므로 메모리 접근 횟수가 증가한다(4-level 페이징에서 최대 4번). 대용량 데이터 처리 시 Huge Pages를 사용하면 TLB 효율성이 향상된다.
>
> **Q: mmap의 장점과 사용 시나리오는?**
> **A:** 장점: 시스템콜 없이 파일 접근, 커널과 사용자 공간 간 복사 제거, 여러 프로세스가 같은 파일 공유 가능. 시나리오: 대용량 파일 처리, 공유 메모리 IPC, 메모리 매핑 데이터베이스(LMDB).
>
> **Q: Copy-on-Write(COW)란?**
> **A:** fork() 시 실제로 메모리를 복사하지 않고 페이지를 읽기 전용으로 공유하다가, 쓰기 발생 시에만 복사하는 기법이다. fork() 비용을 줄이고 메모리를 절약한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - OOM Killer의 동작 원리와 oom_score_adj 튜닝
> - Huge Pages(2MB, 1GB)와 Transparent Huge Pages
> - NUMA 메모리 할당 정책
> - 메모리 오버커밋 설정(vm.overcommit_memory)
>
> **Q: OOM Killer가 프로세스를 선택하는 기준은?**
> **A:** oom_score를 기반으로 하며, 메모리 사용량이 많고 실행 시간이 짧으며 중요도가 낮은 프로세스가 선택된다. /proc/[pid]/oom_score로 확인하고 oom_score_adj(-1000~1000)로 조정한다. -1000은 OOM 대상에서 제외, 1000은 최우선 대상이다.
>
> **Q: Transparent Huge Pages(THP)의 장단점은?**
> **A:** 장점: 자동으로 2MB 페이지 사용, TLB 효율 향상. 단점: 메모리 단편화 시 압축/스왑 오버헤드, 지연 시간 스파이크 발생. Redis, MongoDB 등 DB는 THP 비활성화를 권장한다. `echo never > /sys/kernel/mm/transparent_hugepage/enabled`
>
> **Q: vm.overcommit_memory 설정값의 의미는?**
> **A:** 0(기본): 휴리스틱으로 오버커밋 허용. 1: 무조건 허용(malloc 항상 성공). 2: 제한적 허용(swap + RAM*비율까지만). 2를 사용하면 OOM을 예방할 수 있지만 메모리 할당 실패가 발생할 수 있다.
>
> **Q: /proc/meminfo의 주요 항목은?**
> **A:** MemTotal/MemFree/MemAvailable(전체/여유/가용 메모리), Buffers/Cached(캐시), SwapTotal/SwapFree(스왑), Dirty/Writeback(쓰기 대기 페이지), Slab(커널 캐시), PageTables(페이지 테이블 크기).

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - cgroup memory controller로 메모리 제한
> - 메모리 단편화와 compaction
> - NUMA balancing과 메모리 마이그레이션
> - 커널 메모리 할당자(SLUB, SLAB)
>
> **Q: cgroup v2에서 메모리 제한 설정 방법은?**
> **A:** memory.max로 하드 리밋, memory.high로 소프트 리밋(스로틀링), memory.low로 보호 설정. memory.high 초과 시 reclaim 압박을 주고, memory.max 초과 시 OOM Killer 호출. systemd에서는 MemoryMax, MemoryHigh 옵션 사용.
>
> **Q: 메모리 단편화 문제를 해결하는 방법은?**
> **A:** 외부 단편화: 커널의 compaction으로 페이지 재배치, Huge Pages 사용으로 단편화 감소. 내부 단편화: slab 할당자가 유사 크기 객체 그룹화. /proc/buddyinfo로 단편화 상태 확인, /proc/sys/vm/compact_memory로 수동 compaction 트리거.
>
> **Q: 대용량 메모리 시스템(TB급)에서 고려사항은?**
> **A:** NUMA 토폴로지 인식 필수, Huge Pages로 페이지 테이블 오버헤드 감소, zone_reclaim_mode 설정으로 로컬 메모리 우선 사용, 메모리 대역폭 병목 주의, 메모리 핫플러그 고려.

### 실무 시나리오

**시나리오: OOM으로 인한 서비스 중단**
```bash
# OOM 로그 확인
dmesg | grep -i "out of memory"
journalctl -k | grep -i oom

# 현재 메모리 상태 확인
free -h
cat /proc/meminfo | head -20

# 중요 프로세스 OOM 보호
echo -1000 > /proc/<pid>/oom_score_adj

# 또는 systemd 서비스에서
# OOMScoreAdjust=-1000
```

### 면접 빈출 질문
- **Q: 메모리 누수를 어떻게 탐지하는가?**
- **A:** 방법: Valgrind로 런타임 분석, /proc/[pid]/smaps로 메모리 영역 추적, pmap으로 메모리 맵 확인, 시계열로 RSS 증가 추이 모니터링. 프로덕션에서는 메모리 사용량 메트릭을 수집하여 비정상적 증가 패턴을 감지한다.

---

## 4. 파일시스템 (Filesystem)

### 개념 설명
리눅스 파일시스템은 계층적 디렉토리 구조로 모든 것을 파일로 추상화한다. VFS(Virtual File System)를 통해 다양한 파일시스템을 통일된 인터페이스로 접근할 수 있다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 모든 것이 파일이다 (Everything is a file) 원칙
> - 루트(/)부터 시작하는 단일 트리 구조
> - 주요 디렉토리: /etc(설정), /var(가변 데이터), /home(사용자), /tmp(임시)
>
> **Q: 리눅스에서 "모든 것이 파일"이라는 의미는?**
> **A:** 일반 파일, 디렉토리, 디바이스, 소켓, 파이프, 심지어 프로세스 정보(/proc)까지 파일 인터페이스로 접근한다. read(), write() 등 동일한 시스템콜로 다양한 자원을 다룰 수 있다.
>
> **Q: /proc와 /sys 디렉토리의 차이는?**
> **A:** /proc는 프로세스와 커널 정보를 제공하는 가상 파일시스템(procfs)이다. /sys는 장치와 드라이버 정보를 구조화하여 제공하는 sysfs이다. 둘 다 메모리에만 존재한다.
>
> **Q: 절대 경로와 상대 경로의 차이는?**
> **A:** 절대 경로는 루트(/)부터 시작하는 전체 경로이다. 상대 경로는 현재 디렉토리(.)를 기준으로 한 경로이다. 스크립트에서는 절대 경로 사용을 권장한다.

> ⭐⭐ **Level 2 (주니어)**
> - inode는 파일의 메타데이터(권한, 소유자, 크기, 블록 위치)를 저장
> - 파일 디스크립터(fd)는 프로세스가 열어둔 파일에 대한 정수 핸들
> - 하드링크는 같은 inode를 가리키고, 심볼릭링크는 경로를 저장
> - 주요 파일시스템: ext4(기본), xfs(대용량), btrfs(고급 기능)
>
> **Q: inode가 저장하는 정보와 저장하지 않는 정보는?**
> **A:** 저장: 파일 타입, 권한, 소유자/그룹, 크기, 타임스탬프, 데이터 블록 포인터. 저장 안 함: 파일명(디렉토리 엔트리에 저장). 파일명은 inode 번호와 매핑되어 디렉토리에 저장된다.
>
> **Q: 하드링크와 심볼릭링크의 차이와 각각의 용도는?**
> **A:** 하드링크: 같은 inode 공유, 원본 삭제해도 접근 가능, 같은 파일시스템만 가능, 디렉토리 불가. 심볼릭링크: 경로를 저장, 원본 삭제 시 깨짐, 다른 파일시스템 가능, 디렉토리 가능. 심볼릭링크가 더 유연하여 일반적으로 많이 사용한다.
>
> **Q: 파일 디스크립터 0, 1, 2는 무엇인가?**
> **A:** 0: stdin(표준 입력), 1: stdout(표준 출력), 2: stderr(표준 에러). 모든 프로세스가 기본으로 열어두며, 리다이렉션과 파이프의 기반이 된다.
>
> **Q: ext4와 xfs의 차이와 선택 기준은?**
> **A:** ext4: 범용, 안정적, fsck 빠름, 최대 1EB. xfs: 대용량 파일에 최적화, 병렬 I/O 우수, 확장만 가능(축소 불가). 대용량 미디어 파일이나 빅데이터는 xfs, 일반 서버는 ext4를 권장한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - VFS 레이어의 역할과 구조
> - 저널링 파일시스템의 원리와 모드
> - I/O 스케줄러: mq-deadline, bfq, kyber
> - 파일시스템 캐시와 동기화
>
> **Q: VFS(Virtual File System)의 역할은?**
> **A:** 다양한 파일시스템(ext4, xfs, nfs, tmpfs 등)에 대해 통일된 인터페이스를 제공하는 추상화 레이어다. 애플리케이션은 실제 파일시스템을 알 필요 없이 동일한 시스템콜(open, read, write)을 사용할 수 있다.
>
> **Q: 저널링의 세 가지 모드는?**
> **A:** writeback: 메타데이터만 저널링(빠름, 데이터 손실 가능). ordered(기본): 데이터 쓴 후 메타데이터 저널링(균형). journal: 모든 것 저널링(안전, 느림). mount 옵션으로 data=ordered 등 지정한다.
>
> **Q: sync와 fsync의 차이는?**
> **A:** sync: 시스템 전체의 버퍼를 디스크에 플러시. fsync(fd): 특정 파일의 데이터와 메타데이터만 디스크에 플러시. fdatasync: fsync와 유사하나 수정시간 등 비필수 메타데이터 제외. 데이터베이스는 fsync를 자주 호출한다.
>
> **Q: inode 고갈 문제란 무엇이고 해결책은?**
> **A:** 디스크 공간이 남아있어도 inode가 모두 사용되면 파일 생성이 불가능하다. 작은 파일이 매우 많을 때 발생한다. 해결: 파일시스템 생성 시 inode 수 증가(`mkfs.ext4 -N`), 파일 정리, 또는 동적 inode 할당 파일시스템(xfs, btrfs) 사용.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 파일시스템 벤치마크와 선택 기준
> - btrfs/ZFS의 고급 기능(스냅샷, 압축, 중복제거)
> - 분산 파일시스템(NFS, GlusterFS, CephFS)
> - 스토리지 계층화 전략
>
> **Q: btrfs/ZFS의 Copy-on-Write 장단점은?**
> **A:** 장점: 즉각적 스냅샷, 데이터 무결성(체크섬), 원자적 업데이트, 효율적 증분 백업. 단점: 쓰기 증폭(write amplification), 단편화, SSD에서 TRIM 복잡. 데이터베이스 등 랜덤 쓰기가 많은 워크로드에서 성능 저하 가능.
>
> **Q: 대용량 스토리지 아키텍처 설계 시 고려사항은?**
> **A:** RAID 레벨 선택(성능 vs 안정성), 핫스페어 구성, 스토리지 계층화(SSD/HDD 혼용), 파일시스템 선택, 백업/복구 전략, I/O 병목 지점 분석, 분산 스토리지 고려(Ceph, MinIO), 모니터링 및 용량 계획.

### 실무 시나리오

**시나리오: 디스크 용량 부족 디버깅**
```bash
# 디스크 사용량 확인
df -h

# 대용량 파일/디렉토리 찾기
du -sh /* | sort -hr | head

# 삭제되었지만 열려있는 파일 찾기
lsof +L1

# inode 사용량 확인
df -i

# 특정 디렉토리의 파일 수 확인
find /var -type f | wc -l
```

### 면접 빈출 질문
- **Q: rm으로 파일을 삭제해도 용량이 회복되지 않는 경우는?**
- **A:** 파일이 다른 프로세스에 의해 열려있으면 inode가 해제되지 않아 디스크 공간이 회복되지 않는다. `lsof +L1`로 확인 후 해당 프로세스를 재시작해야 한다. 이것이 로그 파일을 truncate하는 것보다 rm 후 재시작이 필요한 이유다.

---

## 5. 커널 (Kernel)

### 개념 설명
커널은 하드웨어와 소프트웨어 사이의 핵심 계층으로, 프로세스 관리, 메모리 관리, 파일시스템, 네트워킹, 디바이스 드라이버 등을 담당한다. 리눅스는 모놀리식 커널 구조이며 동적으로 모듈을 로드할 수 있다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 커널은 운영체제의 핵심으로 하드웨어를 관리한다
> - `uname -r`로 커널 버전을 확인한다
> - 커널 모듈로 기능을 확장할 수 있다
>
> **Q: 커널 공간과 사용자 공간의 차이는?**
> **A:** 커널 공간은 하드웨어에 직접 접근 가능하고 모든 권한을 가진다. 사용자 공간은 제한된 권한으로 커널을 통해서만 하드웨어에 접근한다. 사용자 프로그램이 커널 기능을 사용하려면 시스템콜을 호출해야 한다.
>
> **Q: 커널 버전 번호의 의미는?**
> **A:** 예: 5.15.0-generic. 주버전(5), 부버전(15), 패치레벨(0). LTS(Long Term Support) 버전은 장기 지원된다. 부버전이 짝수면 안정 버전(과거 관례), 현재는 모든 릴리스가 안정 버전이다.
>
> **Q: dmesg 명령어는 무엇을 보여주는가?**
> **A:** 커널 링 버퍼의 메시지를 출력한다. 부팅 과정, 하드웨어 감지, 드라이버 로드, 커널 오류 등의 정보를 확인할 수 있다. 장치 문제 디버깅에 필수적이다.

> ⭐⭐ **Level 2 (주니어)**
> - 시스템콜은 사용자 공간에서 커널 기능을 호출하는 인터페이스
> - 인터럽트는 하드웨어/소프트웨어 이벤트를 커널에 알리는 메커니즘
> - 커널 모듈은 lsmod, modprobe, insmod로 관리
> - /proc와 /sys로 커널 정보에 접근
>
> **Q: 자주 사용되는 시스템콜에는 무엇이 있는가?**
> **A:** 파일: open, read, write, close, stat. 프로세스: fork, exec, wait, exit. 메모리: mmap, brk. 네트워크: socket, bind, listen, accept, connect. strace로 프로세스의 시스템콜을 추적할 수 있다.
>
> **Q: 하드 인터럽트와 소프트 인터럽트의 차이는?**
> **A:** 하드 인터럽트(IRQ): 하드웨어가 발생, 즉시 처리 필요, CPU 중단. 소프트 인터럽트(softirq, tasklet): 지연된 처리, 인터럽트 컨텍스트에서 실행. 네트워크 패킷 처리는 hardirq에서 최소 처리 후 softirq에서 완료한다.
>
> **Q: lsmod와 modprobe의 차이는?**
> **A:** lsmod: 로드된 모듈 목록 표시. modprobe: 모듈 로드/언로드, 의존성 자동 처리. insmod: 단일 모듈만 로드(의존성 수동). rmmod: 모듈 언로드. 일반적으로 modprobe 사용을 권장한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 컨텍스트 스위칭의 상세 과정
> - 커널 파라미터 튜닝(sysctl)
> - 커널 빌드와 설정
> - 커널 디버깅 기법
>
> **Q: sysctl로 자주 튜닝하는 파라미터는?**
> **A:** 네트워크: net.core.somaxconn, net.ipv4.tcp_max_syn_backlog, net.core.netdev_max_backlog. 메모리: vm.swappiness, vm.dirty_ratio, vm.overcommit_memory. 파일: fs.file-max, fs.inotify.max_user_watches. 보안: kernel.randomize_va_space.
>
> **Q: /proc/sys와 sysctl의 관계는?**
> **A:** sysctl은 /proc/sys 아래의 파일을 읽고 쓰는 인터페이스다. `sysctl -w vm.swappiness=10`은 `/proc/sys/vm/swappiness`에 10을 쓰는 것과 동일하다. 영구 적용은 `/etc/sysctl.conf`에 설정한다.
>
> **Q: 커널 패닉 발생 시 디버깅 방법은?**
> **A:** 1) 콘솔 로그 수집(netconsole, serial). 2) kdump로 크래시 덤프 생성. 3) crash 유틸리티로 덤프 분석. 4) 스택 트레이스에서 문제 함수 파악. 5) dmesg, /var/log/kern.log 확인. 커널 심볼 필요.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 커널 성능 최적화 전략
> - 커스텀 커널 빌드와 패치
> - eBPF를 활용한 커널 확장
> - 실시간 커널(PREEMPT_RT)
>
> **Q: eBPF의 용도와 장점은?**
> **A:** eBPF는 커널 내에서 안전하게 실행되는 샌드박스 프로그램이다. 용도: 네트워크 필터링(XDP), 보안 모니터링, 성능 추적, 디버깅. 장점: 커널 수정/재부팅 없이 기능 추가, 낮은 오버헤드, 안전성(verifier). bcc, bpftrace 도구로 활용한다.
>
> **Q: 고성능 서버를 위한 커널 튜닝 전략은?**
> **A:** 네트워크: TCP 버퍼 증가, 백로그 큐 확대, RPS/RFS 설정. CPU: irqbalance 또는 수동 IRQ 배치, CPU 격리(isolcpus). 메모리: Huge Pages 설정, NUMA 최적화, swappiness 조정. I/O: 스케줄러 선택(NVMe는 none), readahead 조정.

### 실무 시나리오

**시나리오: 높은 시스템 CPU 사용률**
```bash
# CPU 사용률 상세 확인
mpstat -P ALL 1

# 시스템 콜 빈도 확인
perf top -e syscalls:sys_enter_*

# 인터럽트 확인
cat /proc/interrupts
watch -n1 'cat /proc/softirqs'

# 컨텍스트 스위칭 확인
vmstat 1
```

### 면접 빈출 질문
- **Q: 시스템콜과 라이브러리 함수의 차이는?**
- **A:** 시스템콜(read, write)은 커널 모드로 전환하여 커널 기능을 실행한다. 라이브러리 함수(fread, printf)는 사용자 공간에서 실행되며 내부적으로 시스템콜을 호출할 수 있다. 시스템콜은 비용이 크므로 라이브러리가 버퍼링 등으로 호출 횟수를 줄인다.

---

## 6. systemd

### 개념 설명
systemd는 현대 리눅스의 init 시스템이자 시스템/서비스 관리자이다. 병렬 부팅, 의존성 기반 서비스 관리, 소켓 활성화, cgroup 통합 등을 제공한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - systemctl로 서비스를 시작/중지/재시작한다
> - `systemctl status service`로 상태를 확인한다
> - enable/disable로 부팅 시 자동 시작을 설정한다
>
> **Q: systemctl start와 enable의 차이는?**
> **A:** start: 지금 즉시 서비스를 시작. enable: 부팅 시 자동으로 시작하도록 설정(심볼릭 링크 생성). 둘 다 필요하면 `systemctl enable --now service`를 사용한다.
>
> **Q: 서비스 로그를 확인하는 방법은?**
> **A:** `journalctl -u service-name`으로 특정 서비스 로그를 확인한다. `-f`는 실시간, `-n 100`은 최근 100줄, `--since "1 hour ago"`는 시간 범위를 지정한다.
>
> **Q: 서비스가 실패했을 때 원인을 찾는 방법은?**
> **A:** `systemctl status service`로 상태와 최근 로그 확인. `journalctl -xe`로 상세 에러 확인. ExecStart 경로, 권한, 의존성, 환경변수 등을 점검한다.

> ⭐⭐ **Level 2 (주니어)**
> - unit 파일의 기본 구조: [Unit], [Service], [Install]
> - 서비스 타입: simple, forking, oneshot, notify
> - 의존성: Requires, Wants, After, Before
> - 재시작 정책: Restart, RestartSec
>
> **Q: service 파일의 Type 옵션 각각의 의미는?**
> **A:** simple(기본): 프로세스가 바로 시작됨. forking: fork 후 부모 종료, PIDFile 필요. oneshot: 실행 완료 후 종료, RemainAfterExit과 사용. notify: sd_notify()로 준비 완료 알림. dbus: D-Bus 이름 등록으로 준비 완료.
>
> **Q: Requires와 Wants의 차이는?**
> **A:** Requires: 의존 유닛 실패 시 현재 유닛도 실패/중지. Wants: 의존 유닛 실패해도 현재 유닛은 계속 실행. 강한 의존성은 Requires, 선택적 의존성은 Wants를 사용한다.
>
> **Q: Restart 옵션의 종류는?**
> **A:** no: 재시작 안함. on-success: 정상 종료 시 재시작. on-failure: 비정상 종료 시 재시작. on-abnormal: 시그널, 타임아웃 등 재시작. always: 항상 재시작. 서비스 특성에 맞게 선택한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 보안 옵션: User, Group, CapabilityBoundingSet, ProtectSystem
> - 리소스 제한: MemoryMax, CPUQuota, TasksMax
> - 타이머 유닛으로 cron 대체
> - drop-in 파일로 오버라이드
>
> **Q: systemd 서비스 보안 강화 옵션은?**
> **A:** ProtectSystem=strict(파일시스템 읽기전용), ProtectHome=yes(홈 디렉토리 숨김), NoNewPrivileges=yes(권한 상승 금지), CapabilityBoundingSet=(capability 제한), PrivateTmp=yes(독립 /tmp). systemd-analyze security로 점검한다.
>
> **Q: systemd 타이머와 cron의 차이는?**
> **A:** 타이머: 부팅 후 시간 기준(OnBootSec), 마지막 실행 후(OnUnitActiveSec) 등 유연한 설정, 의존성 관리, 로깅 통합, 놓친 실행 처리(Persistent). cron: 캘린더 기반, 단순함. 새 시스템에서는 타이머 권장.
>
> **Q: 기존 서비스 파일을 수정하지 않고 설정을 변경하는 방법은?**
> **A:** `/etc/systemd/system/service.d/override.conf` 파일을 생성한다. `systemctl edit service`로 편리하게 생성. 패키지 업데이트 시 덮어쓰기 걱정 없이 커스터마이징 가능하다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - cgroup v2와 systemd 통합
> - 컨테이너 런타임과 systemd
> - 대규모 시스템에서 systemd 관리
> - 부팅 최적화
>
> **Q: systemd의 cgroup v2 활용은?**
> **A:** systemd는 cgroup v2의 통합 계층을 활용하여 서비스별 리소스를 관리한다. MemoryMax, CPUWeight, IOWeight 등으로 제한하고, systemd-cgtop으로 실시간 모니터링한다. slice 단위로 그룹화하여 관리할 수 있다.
>
> **Q: 부팅 시간을 최적화하는 방법은?**
> **A:** `systemd-analyze blame`으로 느린 서비스 파악, `systemd-analyze critical-chain`으로 병목 확인. 불필요한 서비스 disable, socket activation으로 지연 로딩, DefaultDependencies=no로 의존성 최소화, Type=notify 활용.

### 실무 시나리오

**시나리오: 커스텀 서비스 생성**
```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=appuser
WorkingDirectory=/opt/myapp
ExecStart=/opt/myapp/bin/server
Restart=on-failure
RestartSec=5
MemoryMax=512M
CPUQuota=50%

[Install]
WantedBy=multi-user.target
```

```bash
# 적용
systemctl daemon-reload
systemctl enable --now myapp
```

### 면접 빈출 질문
- **Q: systemd가 SysVinit보다 나은 점은?**
- **A:** 병렬 부팅으로 속도 향상, 의존성 기반 시작 순서, socket/D-Bus 활성화로 on-demand 시작, cgroup으로 프로세스 추적 및 리소스 제한, 통합 로깅(journald), 일관된 관리 인터페이스(systemctl).

---

## 7. cgroup과 namespace (컨테이너의 기반 기술)

### 개념 설명
cgroup(Control Groups)은 프로세스 그룹의 리소스 사용을 제한하고 모니터링한다. namespace는 프로세스가 시스템 리소스를 독립적으로 보도록 격리한다. 이 두 기술이 컨테이너의 핵심 기반이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - cgroup은 CPU, 메모리 등 리소스를 제한하는 기술
> - namespace는 프로세스 격리를 제공하는 기술
> - Docker, Kubernetes 등 컨테이너의 핵심 기반
>
> **Q: 컨테이너가 가상머신과 다른 점은?**
> **A:** 컨테이너는 호스트 커널을 공유하고 cgroup/namespace로 격리한다. VM은 전체 OS를 가상화하여 별도 커널을 실행한다. 컨테이너가 더 가볍고 빠르지만 격리 수준은 VM이 더 강하다.
>
> **Q: cgroup으로 무엇을 제한할 수 있는가?**
> **A:** CPU 사용량, 메모리 사용량, 디스크 I/O, 네트워크 대역폭, 프로세스 수 등을 제한할 수 있다. 리소스 과다 사용 프로세스로부터 시스템을 보호한다.

> ⭐⭐ **Level 2 (주니어)**
> - cgroup v1과 v2의 차이
> - 주요 namespace 종류: pid, net, mnt, uts, ipc, user
> - unshare, nsenter 명령어로 namespace 조작
> - /sys/fs/cgroup에서 cgroup 확인
>
> **Q: cgroup v1과 v2의 주요 차이는?**
> **A:** v1: 각 컨트롤러(cpu, memory 등)가 별도 계층. v2: 통합 계층 구조, 더 일관된 인터페이스, 개선된 리소스 분배. v2는 systemd와 잘 통합되며 현대 시스템의 기본이다.
>
> **Q: 주요 namespace의 역할은?**
> **A:** pid: 프로세스 ID 격리(컨테이너 내 PID 1). net: 네트워크 스택 격리(독립 인터페이스). mnt: 파일시스템 마운트 격리. uts: 호스트명 격리. ipc: IPC 리소스 격리. user: UID/GID 매핑(rootless 컨테이너).
>
> **Q: nsenter 명령어의 용도는?**
> **A:** 실행 중인 프로세스의 namespace에 진입하여 명령을 실행한다. `nsenter -t PID --all -- command`로 컨테이너 디버깅에 사용한다. docker exec과 유사한 기능을 제공한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - cgroup v2 컨트롤러: cpu, memory, io, pids
> - memory.high와 memory.max의 차이
> - user namespace와 rootless 컨테이너
> - cgroup 계층 구조 설계
>
> **Q: cgroup v2 메모리 컨트롤러의 주요 설정은?**
> **A:** memory.max: 하드 리밋, 초과 시 OOM. memory.high: 소프트 리밋, 초과 시 스로틀링. memory.low: 보호, 이 값까지는 reclaim 안함. memory.min: 보장, 절대 reclaim 안함. 단계적 제어가 가능하다.
>
> **Q: rootless 컨테이너의 작동 원리는?**
> **A:** user namespace로 컨테이너 내 root(UID 0)를 호스트의 일반 사용자로 매핑한다. 보안이 강화되고 root 권한 없이 컨테이너를 실행할 수 있다. Podman이 기본적으로 지원한다.
>
> **Q: 프로세스의 cgroup 확인 방법은?**
> **A:** `/proc/[pid]/cgroup`에서 프로세스가 속한 cgroup 확인. `systemd-cgls`로 계층 구조 시각화. `systemd-cgtop`으로 실시간 리소스 사용량 모니터링.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 컨테이너 런타임 내부 구조(runc, containerd)
> - cgroup v2 기반 리소스 관리 전략
> - 보안: seccomp, AppArmor, SELinux와의 조합
> - 멀티 테넌트 환경의 격리 전략
>
> **Q: 컨테이너 보안을 강화하는 방법은?**
> **A:** namespace로 기본 격리, cgroup으로 리소스 제한, seccomp로 시스템콜 필터링, AppArmor/SELinux로 MAC(Mandatory Access Control), capabilities 최소화, read-only 파일시스템, user namespace로 rootless 실행.
>
> **Q: 대규모 컨테이너 환경에서 리소스 관리 전략은?**
> **A:** 슬라이스 계층으로 그룹화(system.slice, user.slice), Kubernetes의 QoS 클래스(Guaranteed, Burstable, BestEffort), 리소스 쿼터로 전체 제한, Pod 간 공정성을 위한 CPU shares 설정, OOM 우선순위 관리.

### 실무 시나리오

**시나리오: 컨테이너 리소스 문제 디버깅**
```bash
# 컨테이너 cgroup 확인
cat /proc/<container_pid>/cgroup

# cgroup 리소스 사용량 확인
cat /sys/fs/cgroup/<cgroup_path>/memory.current
cat /sys/fs/cgroup/<cgroup_path>/cpu.stat

# namespace 확인
ls -la /proc/<pid>/ns/

# 컨테이너 namespace에 진입
nsenter -t <pid> --net ip addr
nsenter -t <pid> --pid --mount ps aux
```

### 면접 빈출 질문
- **Q: 컨테이너 격리가 VM보다 약한 이유는?**
- **A:** 컨테이너는 호스트 커널을 공유하므로 커널 취약점이 모든 컨테이너에 영향을 미친다. namespace 우회 가능성, /proc /sys 노출 위험, cgroup 탈출 가능성이 있다. VM은 하이퍼바이저가 완전히 분리하여 공격 표면이 작다.

---

## 8. 디스크 I/O

### 개념 설명
디스크 I/O는 시스템 성능의 핵심 병목 지점 중 하나이다. 블록 디바이스, I/O 스케줄러, RAID, LVM 등의 개념과 성능 최적화 방법을 이해해야 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - HDD와 SSD의 차이와 특성
> - `df`, `du`, `iostat`로 디스크 상태 확인
> - 마운트와 파티션 개념
>
> **Q: HDD와 SSD의 주요 차이는?**
> **A:** HDD: 회전 디스크, 순차 접근에 유리, 가격 저렴, 진동에 약함. SSD: 플래시 메모리, 랜덤 접근 빠름, 가격 비쌈, 쓰기 수명 제한. SSD는 IOPS가 수십~수백 배 높다.
>
> **Q: iostat에서 확인해야 할 주요 지표는?**
> **A:** %util: 디스크 사용률(100%에 가까우면 포화). await: 평균 대기 시간(ms). r/s, w/s: 초당 읽기/쓰기 요청. rMB/s, wMB/s: 처리량. avgqu-sz: 평균 대기 큐 길이.
>
> **Q: 마운트란 무엇인가?**
> **A:** 파일시스템을 디렉토리 트리의 특정 지점에 연결하는 것이다. `mount /dev/sdb1 /mnt/data`로 마운트하고 /etc/fstab에 영구 설정한다.

> ⭐⭐ **Level 2 (주니어)**
> - 블록 디바이스와 캐릭터 디바이스의 차이
> - I/O 스케줄러: mq-deadline, bfq, kyber, none
> - RAID 레벨: RAID 0, 1, 5, 6, 10
> - LVM 기본 개념
>
> **Q: I/O 스케줄러의 선택 기준은?**
> **A:** mq-deadline: 범용, 지연 시간 보장. bfq: 데스크톱, 공정성 중시. kyber: 고성능 SSD. none: NVMe SSD(하드웨어가 스케줄링). `cat /sys/block/sda/queue/scheduler`로 확인, echo로 변경.
>
> **Q: RAID 10과 RAID 5의 차이와 선택 기준은?**
> **A:** RAID 10: 미러링+스트라이핑, 쓰기 성능 좋음, 용량 50%. RAID 5: 패리티 분산, 용량 효율적, 쓰기 성능 낮음, 리빌드 시 부하 큼. DB는 RAID 10, 아카이브는 RAID 5/6 권장.
>
> **Q: LVM의 장점은?**
> **A:** 논리 볼륨 크기 동적 조정, 여러 디스크를 하나의 볼륨으로 통합, 스냅샷 기능, 온라인 확장 가능. PV(물리)-VG(볼륨그룹)-LV(논리볼륨) 계층 구조.

> ⭐⭐⭐ **Level 3 (시니어)**
> - Direct I/O와 Buffered I/O
> - readahead 튜닝
> - fio를 사용한 벤치마크
> - I/O 병목 진단
>
> **Q: Direct I/O는 언제 사용하는가?**
> **A:** 페이지 캐시를 우회하여 디스크에 직접 읽기/쓰기한다. 데이터베이스처럼 자체 캐싱을 하는 애플리케이션에서 사용하여 이중 캐싱을 방지한다. O_DIRECT 플래그로 열거나 데이터베이스 설정으로 활성화한다.
>
> **Q: fio 벤치마크의 주요 파라미터는?**
> **A:** `--rw`: 읽기/쓰기 패턴(read, write, randread, randwrite, randrw). `--bs`: 블록 크기. `--iodepth`: 동시 I/O 요청 수. `--numjobs`: 병렬 작업 수. `--size`: 테스트 파일 크기. 실제 워크로드와 유사하게 설정해야 한다.
>
> **Q: I/O 대기가 높을 때 진단 방법은?**
> **A:** 1) `iostat -x 1`로 디스크별 사용률 확인. 2) `iotop`으로 프로세스별 I/O 사용량 확인. 3) `pidstat -d 1`로 상세 I/O 통계. 4) blktrace로 상세 추적. await가 높으면 디스크 포화, %util이 낮은데 await가 높으면 RAID/스토리지 문제.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - NVMe와 기존 스토리지의 차이
> - io_uring을 활용한 고성능 I/O
> - 스토리지 아키텍처 설계
> - 분산 스토리지 고려사항
>
> **Q: io_uring의 장점은?**
> **A:** 시스템콜 오버헤드 최소화(배치 처리), 폴링 모드로 인터럽트 제거, 비동기 I/O의 효율성 향상. epoll보다 성능이 좋고 libaio보다 유연하다. 고성능 네트워크/스토리지 애플리케이션에서 채택 증가.
>
> **Q: 대규모 서비스의 스토리지 설계 시 고려사항은?**
> **A:** 워크로드 특성(IOPS vs 처리량, 순차 vs 랜덤), 가용성 요구사항(복제, RAID), 용량 계획과 확장성, 계층화(핫/웜/콜드), 백업/복구 전략, 비용 최적화, 모니터링, 분산 스토리지 vs 로컬 스토리지.

### 실무 시나리오

**시나리오: I/O 성능 문제 해결**
```bash
# 디스크 사용률 확인
iostat -xz 1

# 어떤 프로세스가 I/O를 많이 사용하는지
iotop -oP

# I/O 스케줄러 변경 (NVMe는 none 권장)
echo none > /sys/block/nvme0n1/queue/scheduler

# readahead 조정 (대용량 순차 읽기 시)
blockdev --setra 4096 /dev/sda

# fio 벤치마크
fio --name=test --rw=randrw --bs=4k --size=1G \
    --numjobs=4 --iodepth=32 --runtime=60
```

### 면접 빈출 질문
- **Q: fsync와 fdatasync의 차이는?**
- **A:** fsync: 파일 데이터와 모든 메타데이터(수정시간, 크기 등)를 디스크에 플러시. fdatasync: 데이터와 필수 메타데이터(크기 등)만 플러시, 수정시간 같은 비필수 메타데이터 제외. fdatasync가 약간 빠르며 데이터 무결성에는 충분하다.

---

## 9. 네트워크 스택

### 개념 설명
리눅스 네트워크 스택은 소켓 API부터 물리 계층까지 패킷 처리를 담당한다. 소켓, TCP 버퍼, epoll/io_uring 등 네트워크 프로그래밍과 성능 튜닝의 기반이다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 소켓은 네트워크 통신의 끝점(endpoint)
> - `ss`, `netstat`으로 연결 상태 확인
> - TCP와 UDP의 기본 차이
>
> **Q: `ss -tulnp` 명령어의 의미는?**
> **A:** -t: TCP, -u: UDP, -l: LISTEN 상태, -n: 숫자로 표시, -p: 프로세스 정보. 현재 열려있는 포트와 해당 프로세스를 확인한다. netstat보다 빠르고 더 많은 정보를 제공한다.
>
> **Q: LISTEN, ESTABLISHED, TIME_WAIT 상태의 의미는?**
> **A:** LISTEN: 연결 대기 중(서버). ESTABLISHED: 연결 수립됨(통신 중). TIME_WAIT: 연결 종료 후 대기(2MSL, 지연 패킷 처리). CLOSE_WAIT: 상대방이 종료, 로컬에서 close 대기.

> ⭐⭐ **Level 2 (주니어)**
> - TCP 3-way handshake와 4-way termination
> - TCP 버퍼와 윈도우 크기
> - TIME_WAIT 상태와 소켓 재사용
> - 네트워크 디버깅: ping, traceroute, tcpdump
>
> **Q: TIME_WAIT이 많으면 어떤 문제가 발생하는가?**
> **A:** 소켓(로컬 포트)이 소진되어 새 연결이 실패할 수 있다. 해결: connection pool 사용, SO_REUSEADDR 설정, tcp_tw_reuse 활성화, tcp_fin_timeout 단축. 근본적으로는 연결을 재사용하도록 개선한다.
>
> **Q: TCP 버퍼 크기가 성능에 미치는 영향은?**
> **A:** 버퍼가 작으면 대역폭을 충분히 활용 못함(BDP 문제). 버퍼가 크면 메모리 사용 증가, bufferbloat 발생 가능. 적절한 크기 = Bandwidth * RTT. net.core.rmem_max, net.core.wmem_max로 최대값 설정.
>
> **Q: tcpdump 기본 사용법은?**
> **A:** `tcpdump -i eth0 port 80`: 특정 포트 캡처. `tcpdump -w file.pcap`: 파일로 저장. `tcpdump -A`: ASCII 출력. `tcpdump host 10.0.0.1 and port 443`: 조건 조합. Wireshark로 pcap 분석.

> ⭐⭐⭐ **Level 3 (시니어)**
> - epoll의 동작 원리와 장점
> - TCP 커널 파라미터 튜닝
> - 네트워크 네임스페이스
> - 연결 추적(conntrack)
>
> **Q: select/poll과 epoll의 차이는?**
> **A:** select/poll: 매번 전체 fd 목록 전달, O(n) 스캔. epoll: 커널에 관심 fd 등록, 이벤트 발생한 것만 반환, O(1) 검색. 대규모 연결(C10K)에서 epoll이 훨씬 효율적이다. kqueue(BSD), IOCP(Windows)와 유사.
>
> **Q: 자주 튜닝하는 TCP 커널 파라미터는?**
> **A:** net.core.somaxconn: listen 백로그 최대값. net.ipv4.tcp_max_syn_backlog: SYN 큐 크기. net.core.netdev_max_backlog: 수신 큐 크기. net.ipv4.tcp_keepalive_time: keepalive 시작 시간. tcp_slow_start_after_idle: idle 후 cwnd 유지.
>
> **Q: conntrack table이 가득 차면 어떻게 되는가?**
> **A:** 새 연결이 드롭되고 "nf_conntrack: table full" 메시지가 발생한다. 해결: net.netfilter.nf_conntrack_max 증가, 불필요한 연결 추적 비활성화(NOTRACK), 타임아웃 단축. 대용량 트래픽 서버에서 자주 발생.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - io_uring 네트워크 I/O
> - XDP(eXpress Data Path)와 eBPF
> - DPDK와 커널 바이패스
> - 고성능 네트워크 아키텍처
>
> **Q: XDP의 용도와 장점은?**
> **A:** 드라이버 레벨에서 패킷을 처리하는 eBPF 프로그램이다. 커널 네트워크 스택 진입 전에 처리하여 매우 빠름. 용도: DDoS 방어, 로드밸런싱, 패킷 필터링. Cloudflare, Facebook 등에서 사용. XDP_DROP, XDP_TX, XDP_PASS 등 액션 가능.
>
> **Q: DPDK가 필요한 상황은?**
> **A:** 10Gbps 이상 고대역폭, 수백만 PPS(packets per second), 마이크로초 지연 요구. 커널을 완전히 우회하여 사용자 공간에서 패킷 처리. 단점: 전용 코어 필요, 애플리케이션 복잡성 증가, 표준 도구 사용 불가. NFV, 텔레콤에서 사용.

### 실무 시나리오

**시나리오: 연결 거부 문제 해결**
```bash
# 현재 연결 상태 확인
ss -s
ss -tan state time-wait | wc -l

# conntrack 테이블 확인
cat /proc/sys/net/netfilter/nf_conntrack_count
cat /proc/sys/net/netfilter/nf_conntrack_max

# 백로그 큐 확인
ss -ltn  # Send-Q는 백로그 크기

# 커널 파라미터 튜닝
sysctl -w net.core.somaxconn=65535
sysctl -w net.ipv4.tcp_max_syn_backlog=65535
```

### 면접 빈출 질문
- **Q: TCP_NODELAY(Nagle 비활성화)는 언제 사용하는가?**
- **A:** Nagle 알고리즘은 작은 패킷을 모아서 전송하여 효율성을 높이지만 지연을 발생시킨다. 실시간 통신(게임, 금융), 대화형 프로토콜, 이미 애플리케이션에서 버퍼링하는 경우 TCP_NODELAY로 비활성화하여 지연을 줄인다.

---

## 10. 권한과 보안

### 개념 설명
리눅스 보안은 DAC(Discretionary Access Control)인 전통적 권한 시스템과 MAC(Mandatory Access Control)인 SELinux/AppArmor를 기반으로 한다. capabilities로 root 권한을 세분화할 수 있다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 파일 권한: rwx(읽기/쓰기/실행)와 소유자/그룹/기타
> - chmod로 권한 변경, chown으로 소유자 변경
> - sudo로 관리자 권한 획득
>
> **Q: chmod 755와 chmod 644의 의미는?**
> **A:** 755: rwxr-xr-x (소유자 모든 권한, 그룹/기타 읽기+실행) - 실행 파일, 디렉토리용. 644: rw-r--r-- (소유자 읽기+쓰기, 그룹/기타 읽기만) - 일반 파일용. 숫자는 r=4, w=2, x=1의 합이다.
>
> **Q: sudo와 su의 차이는?**
> **A:** sudo: 특정 명령만 root 권한으로 실행, 본인 비밀번호 사용, 로깅됨. su: 사용자를 완전히 전환(세션), 대상 사용자 비밀번호 필요. 보안상 sudo 사용을 권장한다.
>
> **Q: 디렉토리의 실행 권한(x)의 의미는?**
> **A:** 디렉토리에 대한 x 권한은 해당 디렉토리에 "진입"할 수 있는 권한이다. r은 목록 보기, w는 파일 생성/삭제이다. x 없이 r만 있으면 파일명은 보이지만 접근은 불가능하다.

> ⭐⭐ **Level 2 (주니어)**
> - 특수 권한: SUID, SGID, Sticky Bit
> - umask로 기본 권한 설정
> - /etc/sudoers와 sudo 설정
> - PAM(Pluggable Authentication Modules) 기초
>
> **Q: SUID, SGID, Sticky Bit의 역할은?**
> **A:** SUID(4xxx): 실행 시 소유자 권한으로 실행(passwd가 root 권한 필요). SGID(2xxx): 실행 시 그룹 권한, 디렉토리면 새 파일이 부모 그룹 상속. Sticky Bit(1xxx): 디렉토리에서 소유자만 삭제 가능(/tmp).
>
> **Q: umask 022의 의미는?**
> **A:** 기본 권한에서 제외할 권한을 지정. 파일 기본 666 - 022 = 644, 디렉토리 기본 777 - 022 = 755. 보안을 위해 umask 027이나 077을 사용하기도 한다.
>
> **Q: sudoers 파일에서 NOPASSWD의 위험성은?**
> **A:** 비밀번호 없이 sudo 실행 허용. 해당 계정이 침해되면 즉시 root 권한 획득 가능. 자동화 스크립트에서 필요할 수 있지만, 최소한의 명령만 허용하고 모니터링해야 한다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - Linux Capabilities로 권한 세분화
> - SELinux/AppArmor의 개념과 설정
> - 감사 로그(auditd)
> - 파일 무결성 검사
>
> **Q: Capabilities가 필요한 이유는?**
> **A:** 전통적으로 root는 모든 권한을 가지지만, 이는 최소 권한 원칙에 위배된다. Capabilities로 권한을 CAP_NET_BIND_SERVICE(1024 이하 포트), CAP_SYS_PTRACE(프로세스 추적) 등으로 세분화하여 필요한 것만 부여할 수 있다.
>
> **Q: SELinux의 동작 모드는?**
> **A:** Enforcing: 정책 위반 차단 및 로깅. Permissive: 차단하지 않고 로깅만(디버깅용). Disabled: 완전 비활성화. `getenforce`로 확인, `setenforce`로 임시 변경, /etc/selinux/config로 영구 설정.
>
> **Q: auditd로 무엇을 모니터링하는가?**
> **A:** 파일 접근, 시스템콜 호출, 로그인/로그아웃, 권한 변경 등. `-w /etc/passwd -p wa`로 passwd 파일 쓰기/속성변경 감시. 보안 감사, 침해 탐지, 컴플라이언스에 필수적이다.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 제로 트러스트 보안 모델
> - 컨테이너 보안 전략
> - 보안 하드닝 체크리스트
> - 침해 대응 절차
>
> **Q: 프로덕션 서버 하드닝 체크리스트는?**
> **A:** SSH: 키 인증만, root 로그인 금지, 포트 변경. 방화벽: 필요한 포트만 허용. 업데이트: 자동 보안 패치. 사용자: 최소 권한, sudo 로깅. 감사: auditd, 파일 무결성. 서비스: 불필요한 서비스 제거. SELinux/AppArmor 활성화.
>
> **Q: 침해가 의심될 때 초기 대응 절차는?**
> **A:** 1) 격리(네트워크 분리, 서비스 중단 판단). 2) 증거 보존(메모리 덤프, 디스크 이미지, 로그 백업). 3) 분석(로그인 기록, 프로세스, 네트워크 연결, 변경된 파일). 4) 복구(클린 이미지로 재구축). 5) 보고(경영진, 법적 의무). 6) 사후 분석.

### 실무 시나리오

**시나리오: 의심스러운 활동 조사**
```bash
# 최근 로그인 기록
last -n 20
lastlog

# 실패한 로그인 시도
grep "Failed password" /var/log/auth.log

# SUID 파일 찾기 (백도어 가능성)
find / -perm -4000 -type f 2>/dev/null

# 열린 포트와 프로세스
ss -tulnp
lsof -i -P

# 최근 변경된 파일
find /etc -mtime -1 -type f
```

### 면접 빈출 질문
- **Q: /etc/passwd와 /etc/shadow의 차이는?**
- **A:** /etc/passwd: 모든 사용자가 읽을 수 있음, 사용자 정보(UID, GID, 홈, 쉘) 저장, 비밀번호 필드는 x. /etc/shadow: root만 읽을 수 있음, 해시된 비밀번호와 만료 정보 저장. 보안을 위해 분리되었다.

---

## 11. 패키지 관리

### 개념 설명
리눅스 패키지 관리자는 소프트웨어 설치, 업데이트, 제거를 자동화하고 의존성을 관리한다. 배포판마다 다른 패키지 관리 시스템을 사용한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - apt(Debian/Ubuntu), yum/dnf(RHEL/CentOS), pacman(Arch)
> - 패키지 검색, 설치, 제거, 업데이트 기본 명령어
> - 리포지토리 개념
>
> **Q: apt update와 apt upgrade의 차이는?**
> **A:** apt update: 패키지 목록(인덱스)을 최신으로 갱신, 설치는 안함. apt upgrade: 설치된 패키지를 최신 버전으로 업그레이드. 항상 update 후 upgrade 실행.
>
> **Q: 설치된 패키지의 파일 목록을 확인하는 방법은?**
> **A:** Debian/Ubuntu: `dpkg -L package-name`. RHEL/CentOS: `rpm -ql package-name`. 특정 파일이 어떤 패키지에 속하는지: `dpkg -S /path/to/file` 또는 `rpm -qf /path/to/file`.

> ⭐⭐ **Level 2 (주니어)**
> - 패키지 의존성 관리
> - 버전 고정(hold/lock)
> - 서드파티 리포지토리 추가
> - 캐시 관리
>
> **Q: 패키지 버전을 고정하는 방법과 이유는?**
> **A:** Debian: `apt-mark hold package`. RHEL: `dnf versionlock add package`. 자동 업그레이드로 인한 호환성 문제 방지, 검증된 버전 유지. 단, 보안 패치가 적용되지 않으므로 주기적으로 검토해야 한다.
>
> **Q: apt와 apt-get의 차이는?**
> **A:** apt는 apt-get과 apt-cache의 기능을 통합한 사용자 친화적 명령어이다. 진행률 표시, 색상 출력 등 개선된 UI. 스크립트에서는 출력 형식이 안정적인 apt-get 권장. 기능적으로는 거의 동일하다.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 보안 패치 전략
> - 자동 업데이트 설정
> - 프라이빗 리포지토리 구축
> - 패키지 빌드
>
> **Q: 보안 업데이트 전략은?**
> **A:** 자동: unattended-upgrades(Ubuntu), dnf-automatic(RHEL)로 보안 패치만 자동 적용. 수동: 스테이징 환경에서 테스트 후 적용. 긴급: CVE 모니터링으로 중요 취약점 즉시 대응. 정기적인 전체 업데이트 일정 수립.
>
> **Q: 프라이빗 패키지 리포지토리가 필요한 경우는?**
> **A:** 내부 개발 소프트웨어 배포, 외부 패키지의 커스텀 빌드, 네트워크 격리 환경, 미러링으로 대역폭 절약, 특정 버전 보관. Artifactory, Nexus, apt-mirror, createrepo 등 사용.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 대규모 환경의 패치 관리
> - 컴플라이언스와 취약점 관리
> - 불변 인프라 vs 패치 관리
> - OS 업그레이드 전략
>
> **Q: 대규모 서버 패치 전략은?**
> **A:** 단계적 롤아웃(카나리 -> 스테이징 -> 프로덕션), 블루-그린 또는 롤링 업데이트, 자동화 도구(Ansible, Puppet) 활용, 롤백 계획 수립, 패치 적용 자동 검증, 패치 상태 대시보드 운영.

### 실무 시나리오

**시나리오: 의존성 충돌 해결**
```bash
# 의존성 문제 확인
apt-get check
dpkg --configure -a

# 깨진 의존성 수정
apt --fix-broken install

# 특정 패키지 의존성 확인
apt-cache depends package
apt-cache rdepends package

# 강제 설치 (주의 필요)
dpkg --force-depends -i package.deb
```

### 면접 빈출 질문
- **Q: 소스에서 컴파일 설치 vs 패키지 설치의 장단점은?**
- **A:** 패키지: 의존성 자동 관리, 쉬운 업데이트/제거, 검증됨. 단점: 버전 선택 제한. 소스: 최신 버전, 컴파일 옵션 커스텀, 최적화 가능. 단점: 의존성 수동 관리, 업데이트 어려움, 시간 소요. 일반적으로 패키지 권장, 특수 요구사항 시 소스.

---

## 12. 쉘 스크립팅

### 개념 설명
Bash 쉘 스크립팅은 시스템 관리 자동화의 핵심이다. 파이프, 리다이렉션, 변수, 제어 구조, 텍스트 처리 도구를 활용하여 복잡한 작업을 자동화한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - 기본 명령어 연결: 파이프(|), 리다이렉션(>, >>)
> - 변수 선언과 사용
> - 기본 제어문: if, for, while
>
> **Q: 파이프(|)와 리다이렉션(>)의 차이는?**
> **A:** 파이프: 명령어의 stdout을 다음 명령어의 stdin으로 연결. 예: `ls | grep txt`. 리다이렉션: stdout을 파일로 저장. >는 덮어쓰기, >>는 추가. 예: `echo "hello" > file.txt`.
>
> **Q: $?의 의미는?**
> **A:** 직전 명령어의 종료 코드(exit code)이다. 0은 성공, 그 외는 실패. `if [ $? -eq 0 ]; then echo "success"; fi`로 성공 여부를 확인한다.
>
> **Q: 2>&1의 의미는?**
> **A:** stderr(2)를 stdout(1)으로 리다이렉션한다. `command > file 2>&1`은 stdout과 stderr 모두 파일로 저장. `command 2>&1 | less`는 에러도 파이프로 전달.

> ⭐⭐ **Level 2 (주니어)**
> - 변수 확장: ${var:-default}, ${var:?error}
> - 배열과 연관 배열
> - 함수 정의와 사용
> - 주요 텍스트 처리: grep, sed, awk, cut
>
> **Q: sed와 awk의 차이와 사용 시나리오는?**
> **A:** sed: 스트림 에디터, 라인 단위 텍스트 치환에 적합. `sed 's/old/new/g'`. awk: 프로그래밍 언어, 필드 기반 처리에 강력. `awk '{print $1, $3}'`. 단순 치환은 sed, 복잡한 처리는 awk.
>
> **Q: grep의 유용한 옵션은?**
> **A:** -i: 대소문자 무시. -r: 재귀 검색. -v: 매칭 안 되는 줄. -c: 매칭 줄 수. -l: 파일명만 출력. -A/-B/-C n: 전후 n줄 출력. -E: 확장 정규식. -P: Perl 정규식.
>
> **Q: `set -e`의 역할은?**
> **A:** 스크립트에서 명령어가 실패하면(exit code != 0) 즉시 종료한다. 에러 무시 방지. `set -u`는 미정의 변수 사용 시 에러. `set -o pipefail`은 파이프라인 중 실패 감지. `set -euo pipefail` 조합 권장.

> ⭐⭐⭐ **Level 3 (시니어)**
> - 고급 정규표현식
> - 프로세스 치환: <(), >()
> - trap으로 시그널 핸들링
> - 병렬 처리: xargs, parallel
>
> **Q: trap 명령어의 용도는?**
> **A:** 시그널이나 이벤트 발생 시 특정 명령 실행. `trap 'rm -f $TMPFILE' EXIT`로 스크립트 종료 시 임시 파일 정리. `trap '' SIGINT`로 Ctrl+C 무시. 클린업 코드에 필수적.
>
> **Q: xargs와 parallel의 차이는?**
> **A:** xargs: stdin에서 입력을 받아 명령어 인자로 전달. `-P n`으로 병렬 처리. parallel(GNU): 더 강력한 병렬 처리, 진행률 표시, 결과 순서 유지 옵션. 대용량 처리 시 parallel 권장.
>
> **Q: jq의 용도와 기본 사용법은?**
> **A:** JSON 파싱/처리 도구. `.key`로 값 추출, `.[]`로 배열 순회, `select()`로 필터링. `curl api | jq '.data[] | select(.status=="active")'`. 현대 인프라에서 API 응답 처리에 필수.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - 스크립트 품질과 유지보수
> - 성능 최적화
> - 인프라 자동화 패턴
> - 스크립트 vs 전용 도구 선택 기준
>
> **Q: 쉘 스크립트 대신 Python/Go를 선택해야 할 때는?**
> **A:** 쉘: 간단한 자동화, 명령어 조합, 100줄 이하. Python: 복잡한 로직, 에러 처리 중요, API 호출 많음, 테스트 필요. Go: 배포 단순성, 크로스 플랫폼, 고성능 필요. 유지보수성과 팀 역량 고려.

### 실무 시나리오

**시나리오: 로그 분석 스크립트**
```bash
#!/bin/bash
set -euo pipefail

LOG_FILE="${1:?Usage: $0 <logfile>}"
TOP_N="${2:-10}"

echo "=== Top $TOP_N IPs by request count ==="
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n "$TOP_N"

echo -e "\n=== HTTP status code distribution ==="
awk '{print $9}' "$LOG_FILE" | grep -E '^[0-9]+$' | sort | uniq -c | sort -rn

echo -e "\n=== Requests per hour ==="
awk '{print $4}' "$LOG_FILE" | cut -d: -f1,2 | uniq -c | tail -24
```

### 면접 빈출 질문
- **Q: 큰 파일을 처리할 때 주의할 점은?**
- **A:** 전체를 메모리에 로드하지 않기(cat 대신 스트림 처리), 파이프라인 활용, 중간 파일 최소화, 병렬 처리 고려. `while read line`보다 `awk`가 빠름. 매우 큰 파일은 split으로 분할 처리.

---

## 13. 성능 분석 도구

### 개념 설명
리눅스는 다양한 성능 분석 도구를 제공한다. 시스템 전반의 상태를 모니터링하고 병목 지점을 찾아 최적화할 수 있다. CPU, 메모리, I/O, 네트워크 각 영역별 도구를 숙지해야 한다.

### 레벨별 지식

> ⭐ **Level 1 (입문)**
> - top/htop: 프로세스 및 시스템 상태 모니터링
> - free: 메모리 사용량
> - df/du: 디스크 사용량
> - uptime: 시스템 부하(load average)
>
> **Q: load average 1.00의 의미는?**
> **A:** 1개의 CPU가 100% 사용 중이거나 1개의 작업이 대기 중임을 의미한다. 4코어 시스템에서 4.00이면 적정 부하, 8.00이면 과부하. 1분/5분/15분 평균으로 추세를 파악한다.
>
> **Q: top에서 us, sy, id, wa의 의미는?**
> **A:** us(user): 사용자 프로세스. sy(system): 커널. id(idle): 유휴. wa(iowait): I/O 대기. 높은 sy는 커널 활동 많음, 높은 wa는 디스크 병목을 의미한다.
>
> **Q: htop이 top보다 나은 점은?**
> **A:** 컬러 표시, 마우스 지원, 트리 뷰, 프로세스 검색/필터, 정렬 변경 쉬움, 스크롤 가능, CPU 코어별 사용량 시각화. 대화형 작업에 편리하다.

> ⭐⭐ **Level 2 (주니어)**
> - vmstat: 가상 메모리 통계
> - iostat: I/O 통계
> - sar: 시스템 활동 리포터
> - netstat/ss: 네트워크 연결
> - lsof: 열린 파일
>
> **Q: vmstat 출력의 주요 항목은?**
> **A:** r: 실행 대기 프로세스. b: 블록된 프로세스. swpd: 사용 중 swap. free: 여유 메모리. si/so: swap in/out. bi/bo: 블록 in/out. us/sy/id/wa: CPU 사용률. r이 CPU 수보다 크면 CPU 포화.
>
> **Q: lsof의 유용한 사용법은?**
> **A:** `lsof -i :80`: 80 포트 사용 프로세스. `lsof -u user`: 특정 사용자. `lsof +D /dir`: 디렉토리 내 파일. `lsof -c process`: 특정 프로세스. `lsof +L1`: 삭제되었지만 열린 파일(디스크 용량 문제).
>
> **Q: sar의 장점은?**
> **A:** 히스토리 데이터 제공(/var/log/sa/), CPU, 메모리, I/O, 네트워크 통합 분석, 과거 시점 분석 가능. `sar -u`: CPU, `sar -r`: 메모리, `sar -d`: 디스크. sysstat 패키지에 포함.

> ⭐⭐⭐ **Level 3 (시니어)**
> - perf: 커널 레벨 프로파일링
> - strace/ltrace: 시스템콜/라이브러리콜 추적
> - tcpdump/Wireshark: 패킷 분석
> - 프로파일링과 플레임 그래프
>
> **Q: perf로 할 수 있는 분석은?**
> **A:** `perf top`: 실시간 핫스팟. `perf record/report`: 프로파일 기록/분석. `perf stat`: 하드웨어 카운터. `perf trace`: 시스템콜 추적. CPU 캐시 미스, 분기 예측 실패 등 하드웨어 레벨 분석 가능.
>
> **Q: strace로 문제를 진단하는 방법은?**
> **A:** `strace -p PID`: 실행 중인 프로세스. `strace -c`: 시스템콜 통계. `strace -e open,read`: 특정 시스템콜만. `strace -f`: 자식 프로세스 포함. 성능 오버헤드가 있으므로 프로덕션에서 주의.
>
> **Q: 플레임 그래프의 해석 방법은?**
> **A:** x축: 샘플 수(넓을수록 많은 시간). y축: 콜 스택 깊이. 색상: 의미 없음(구분용). 넓은 "고원"은 최적화 대상. perf record 후 FlameGraph 스크립트로 생성. CPU, 메모리, I/O 병목 시각화에 효과적.

> ⭐⭐⭐⭐ **Level 4 (리드/CTO)**
> - eBPF/BPF 기반 도구 (bcc, bpftrace)
> - 프로덕션 환경 성능 분석 전략
> - 지속적 프로파일링
> - 성능 기준선과 용량 계획
>
> **Q: eBPF 기반 도구의 장점은?**
> **A:** 프로덕션에서 안전하게 사용 가능(커널 verifier), 낮은 오버헤드, 재부팅/재컴파일 불필요, 커널 내부까지 관측 가능. bpftrace로 원라이너 작성, bcc로 Python 스크립트, Cilium/Falco 등 보안/네트워크 도구.
>
> **Q: 프로덕션 성능 분석의 원칙은?**
> **A:** 1) 오버헤드 최소화(샘플링, eBPF). 2) 기준선 확보(평상시 데이터). 3) USE 방법론(Utilization, Saturation, Errors). 4) 재현 가능한 방법. 5) 지속적 프로파일링(Parca, Pyroscope). 6) 가설-검증 사이클.

### 실무 시나리오

**시나리오: 시스템 성능 종합 점검**
```bash
# 1. 시스템 전반 상태
uptime
vmstat 1 5
mpstat -P ALL 1 5

# 2. 메모리 상태
free -h
cat /proc/meminfo | head -20

# 3. 디스크 I/O
iostat -xz 1 5
iotop -oP -d 1

# 4. 네트워크
ss -s
sar -n DEV 1 5

# 5. 프로세스별 리소스
pidstat -u -r -d 1 5

# 6. 핫스팟 분석
perf top
```

### 면접 빈출 질문
- **Q: 서버가 느릴 때 점검 순서는?**
- **A:** 1) uptime으로 load average 확인. 2) top/htop으로 CPU/메모리 사용 프로세스 확인. 3) vmstat으로 swap, I/O wait 확인. 4) iostat으로 디스크 포화 확인. 5) ss/netstat으로 네트워크 상태. 6) dmesg로 커널 에러. 체계적으로 리소스별 점검.

- **Q: CPU 사용률이 100%일 때와 load average가 높을 때의 차이는?**
- **A:** CPU 100%: 연산이 많음, 최적화나 스케일아웃 필요. Load가 높지만 CPU idle: I/O 대기(wa)가 많음, 디스크/네트워크 병목. Load가 높고 CPU도 높음: 복합적 문제. Load는 실행 가능 + I/O 대기 프로세스 수이므로 CPU만으로 판단 불가.

---

## 참고 자료

- [Linux Kernel Documentation](https://docs.kernel.org/)
- [Red Hat Enterprise Linux Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/)
- [eBPF.io](https://ebpf.io/)
- [The Linux Programming Interface - Michael Kerrisk](https://man7.org/tlpi/)
- [Systems Performance - Brendan Gregg](https://www.brendangregg.com/systems-performance-2nd-edition-book.html)
