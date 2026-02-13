---
description: "PRD/기능 설명으로부터 speckit 전체 파이프라인을 끝까지 자동 실행합니다. constitution → specify → clarify → plan → checklist → tasks → analyze → implement"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Overview

이 스킬은 speckit의 모든 단계를 올바른 순서로 끝까지 실행하는 **오케스트레이터**입니다.
사용자가 PRD나 기능 설명을 제공하면, 아래 8단계를 순차적으로 진행하여 구현 완료까지 이끕니다.

**핵심 원칙:**
- 각 단계 완료 후 다음 단계로 자동 진행
- 사용자 확인이 반드시 필요한 지점에서만 멈추고 질문
- 실패 시 해당 단계를 수정 후 재시도 (최대 2회)
- 모든 산출물 경로를 추적하여 다음 단계에 전달

## Pipeline Stages

```
Stage 1: CONSTITUTION  ─── 프로젝트 원칙 설정 (최초 1회)
    │
Stage 2: SPECIFY       ─── PRD → spec.md 생성
    │
Stage 3: CLARIFY       ─── 스펙 모호성 해소 (interactive)
    │
Stage 4: PLAN          ─── 기술 설계 (plan.md, data-model.md, contracts/)
    │
Stage 5: CHECKLIST     ─── 요구사항 품질 검증 체크리스트
    │
Stage 6: TASKS         ─── 실행 가능한 태스크 분해 (tasks.md)
    │
Stage 7: ANALYZE       ─── 산출물 간 일관성 분석 (read-only)
    │
Stage 8: IMPLEMENT     ─── 코드 구현 실행
```

## Execution Flow

### Pre-flight Check

1. **Working directory 확인**: 현재 디렉토리가 git 레포지토리인지 확인
2. **`.specify/` 디렉토리 확인**: speckit이 초기화되었는지 확인
   - 없으면 사용자에게 speckit 설치 필요를 안내하고 중단
3. **입력 검증**: `$ARGUMENTS`가 비어있으면 사용자에게 PRD/기능 설명을 요청

### Stage 1: CONSTITUTION (조건부)

**목적**: 프로젝트의 핵심 원칙과 거버넌스 규칙 설정

1. `.specify/memory/constitution.md` 파일 존재 여부 확인
2. **파일이 존재하고 placeholder가 없는 경우**: 이 단계 스킵, Stage 2로 진행
3. **파일이 없거나 placeholder가 남아있는 경우**:
   - 사용자에게 알림: "프로젝트 Constitution이 설정되지 않았습니다. 기본 원칙으로 진행할까요, 아니면 커스텀 원칙을 지정하시겠습니까?"
   - 사용자 응답에 따라 constitution 설정 실행
   - `.specify/templates/constitution-template.md`를 기반으로 `.specify/memory/constitution.md` 생성
   - 완료 후 사용자에게 요약 보고

**완료 조건**: `.specify/memory/constitution.md`에 placeholder 없이 완성

---

### Stage 2: SPECIFY

**목적**: 사용자의 PRD/기능 설명을 구조화된 spec.md로 변환

1. `$ARGUMENTS`에서 기능 설명 추출
2. 간결한 short name 생성 (2-4 단어)
3. 기존 브랜치/스펙 디렉토리와 번호 충돌 확인
4. `.specify/scripts/bash/create-new-feature.sh --json "$ARGUMENTS"` 실행
5. JSON 출력에서 BRANCH_NAME, SPEC_FILE 경로 파싱
6. `.specify/templates/spec-template.md` 로드
7. 기능 설명을 분석하여 spec.md 작성:
   - 핵심 개념 추출 (actors, actions, data, constraints)
   - 불명확한 부분은 합리적 기본값 사용 (최대 3개 NEEDS CLARIFICATION)
   - 기능 요구사항은 테스트 가능하게 작성
   - 성공 기준은 측정 가능하고 기술 중립적으로
8. `FEATURE_DIR/checklists/requirements.md` 생성하여 스펙 품질 검증
9. 검증 실패 시 스펙 수정 후 재검증 (최대 3회)
10. NEEDS CLARIFICATION 마커가 남아있으면 Stage 3에서 해결

**완료 조건**: spec.md 생성, 품질 체크리스트 통과
**산출물 추적**: FEATURE_DIR, SPEC_FILE, BRANCH_NAME 기록

**자동 진행**: Stage 3으로

---

### Stage 3: CLARIFY (Interactive)

**목적**: 스펙의 모호성과 누락 사항 식별 및 해결

1. `.specify/scripts/bash/check-prerequisites.sh --json --paths-only` 실행
2. spec.md 로드 및 구조적 모호성 스캔 (9개 카테고리)
3. 우선순위별 질문 큐 생성 (최대 5개)
4. **한 번에 하나씩** 사용자에게 질문:
   - 다지선다형 또는 단답형
   - 추천 옵션을 명시하여 사용자가 빠르게 결정 가능
   - 사용자가 "done", "proceed" 응답 시 조기 종료
5. 각 답변 즉시 spec.md에 반영 (Clarifications 섹션 + 관련 섹션 업데이트)
6. 검증: 중복 없음, 모순 없음, 마크다운 구조 유효

**완료 조건**: 모든 critical 모호성 해결 또는 사용자 조기 종료
**사용자 확인 필수**: 각 질문에 대한 응답 필요

**자동 진행**: Stage 4로

---

### Stage 4: PLAN

**목적**: 기술 설계 문서 생성 (아키텍처, 데이터 모델, API 계약)

1. `.specify/scripts/bash/setup-plan.sh --json` 실행
2. spec.md + constitution.md 로드
3. Phase 0 - 조사 & 연구:
   - 기술적 미결정 사항 식별
   - research.md 생성 (결정, 근거, 대안)
4. Phase 1 - 설계 & 계약:
   - data-model.md 생성 (엔티티, 관계, 검증 규칙)
   - contracts/ 생성 (API 스키마)
   - quickstart.md 생성 (통합 시나리오)
5. 에이전트 컨텍스트 업데이트: `.specify/scripts/bash/update-agent-context.sh claude`
6. Constitution Check 수행

**완료 조건**: plan.md, research.md, data-model.md, contracts/ 생성
**Gate 검사**: Constitution 위반 시 ERROR

**자동 진행**: Stage 5로

---

### Stage 5: CHECKLIST (자동 판단)

**목적**: 도메인별 요구사항 품질 검증 체크리스트 생성

1. `.specify/scripts/bash/check-prerequisites.sh --json` 실행
2. spec.md, plan.md 분석하여 관련 도메인 자동 판별:
   - 보안 관련 기능 → `security.md` 체크리스트
   - UI/UX 관련 기능 → `ux.md` 체크리스트
   - API 관련 기능 → `api.md` 체크리스트
   - 성능 관련 기능 → `performance.md` 체크리스트
3. 판별된 도메인에 대해 체크리스트 생성
4. 요구사항 품질 관점에서 검증 항목 작성 (구현 테스트가 아님)
5. 사용자에게 체크리스트 결과 보고

**완료 조건**: 관련 도메인별 체크리스트 파일 생성
**참고**: 체크리스트는 "요구사항에 대한 유닛 테스트" — 구현이 아닌 요구사항 품질 검증

**자동 진행**: Stage 6으로

---

### Stage 6: TASKS

**목적**: 실행 가능한 태스크 목록 생성

1. `.specify/scripts/bash/check-prerequisites.sh --json` 실행
2. 설계 문서 로드: plan.md(필수), spec.md(필수), data-model.md, contracts/, research.md, quickstart.md(선택)
3. 사용자 스토리 기반 태스크 구성:
   - Phase 1: Setup (프로젝트 초기화)
   - Phase 2: Foundational (공통 기반)
   - Phase 3+: 사용자 스토리별 (우선순위 순)
   - Final Phase: Polish & 횡단 관심사
4. 체크리스트 형식 준수: `- [ ] [TaskID] [P?] [Story?] Description with file path`
5. 의존성 그래프 및 병렬 실행 예시 포함

**완료 조건**: tasks.md 생성, 모든 요구사항 커버
**산출물**: 태스크 수, 스토리별 태스크 수, 병렬 기회, MVP 범위

**자동 진행**: Stage 7로

---

### Stage 7: ANALYZE (Read-only Gate)

**목적**: spec.md, plan.md, tasks.md 간 일관성 분석

1. `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks` 실행
2. 3개 산출물 + constitution 로드
3. 6가지 탐지 패스 실행:
   - A. 중복 탐지
   - B. 모호성 탐지
   - C. 미명세 탐지
   - D. Constitution 정합성
   - E. 커버리지 갭
   - F. 비일관성
4. 심각도 분류: CRITICAL / HIGH / MEDIUM / LOW
5. 분석 보고서 출력 (파일 수정 없음)

**완료 조건**: 분석 보고서 생성

**Gate 판단:**
- **CRITICAL 이슈가 있는 경우**: 사용자에게 알림 후 수정 제안. "CRITICAL 이슈가 발견되었습니다. 구현 전에 수정하시겠습니까?" 질문
  - 수정 선택 시: 관련 산출물 수정 후 Stage 7 재실행
  - 진행 선택 시: 경고와 함께 Stage 8로
- **CRITICAL 이슈가 없는 경우**: Stage 8로 자동 진행

---

### Stage 8: IMPLEMENT (Final)

**목적**: tasks.md의 모든 태스크를 순서대로 구현

1. `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks` 실행
2. 체크리스트 상태 확인:
   - 모든 체크리스트 통과 → 자동 진행
   - 미완료 항목 존재 → 사용자에게 진행 여부 확인
3. 구현 컨텍스트 로드: tasks.md, plan.md, data-model.md, contracts/, research.md, quickstart.md
4. 프로젝트 설정 검증 (ignore 파일 등)
5. Phase별 순차 실행:
   - 의존성 준수 (순차 태스크는 순서대로, [P] 태스크는 병렬)
   - TDD 접근 (테스트 태스크가 있으면 구현 전 실행)
   - 각 태스크 완료 시 tasks.md에서 `[X]` 마킹
6. 진행 상황 보고 및 에러 핸들링
7. 최종 검증: 모든 태스크 완료, 스펙 일치, 테스트 통과

**완료 조건**: 모든 태스크 완료 및 검증 통과

---

## Progress Reporting

각 Stage 완료 시 다음 형식으로 보고:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Stage N/8] STAGE_NAME ✓ 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
산출물: [생성된 파일 목록]
소요: [주요 결정 사항 요약]
다음: Stage N+1 - NEXT_STAGE_NAME 진행
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Error Handling

- **스크립트 실행 실패**: 에러 메시지 출력 후 사용자에게 수동 해결 방법 안내
- **Gate 실패 (Constitution 위반 등)**: 위반 내용 상세 보고, 수정 제안, 사용자 확인 후 진행
- **단계 실패**: 해당 단계 수정 후 최대 2회 재시도. 3회 실패 시 사용자에게 수동 개입 요청
- **사용자 중단**: 어느 시점에서든 "stop", "중단" 입력 시 현재 단계 완료 후 중단. 이후 `/speckit.run`으로 이어서 실행 가능

## Resumption Support

파이프라인은 **어느 단계에서든 재개** 가능합니다:

1. 현재 브랜치의 `specs/` 디렉토리에서 기존 산출물 탐지
2. 존재하는 산출물 기준으로 다음 실행할 단계 자동 판별:
   - spec.md만 존재 → Stage 3 (CLARIFY)부터
   - spec.md + plan.md 존재 → Stage 5 (CHECKLIST)부터
   - spec.md + plan.md + tasks.md 존재 → Stage 7 (ANALYZE)부터
3. 사용자에게 재개 지점 확인: "기존 산출물이 감지되었습니다. Stage N부터 진행할까요?"

## Quick Reference

| Stage | Command | Interactive? | Key Output |
|-------|---------|-------------|------------|
| 1 | constitution | 조건부 | constitution.md |
| 2 | specify | No | spec.md, branch |
| 3 | clarify | **Yes** (Q&A) | updated spec.md |
| 4 | plan | No | plan.md, data-model.md, contracts/ |
| 5 | checklist | No | checklists/*.md |
| 6 | tasks | No | tasks.md |
| 7 | analyze | 조건부 (CRITICAL 시) | analysis report |
| 8 | implement | 조건부 (checklist 미완료 시) | source code |
