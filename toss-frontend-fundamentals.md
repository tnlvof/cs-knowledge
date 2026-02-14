# Toss Frontend Fundamentals - 좋은 코드의 4가지 기준

> 출처: [Frontend Fundamentals](https://frontend-fundamentals.com/code-quality/)
> 좋은 프론트엔드 코드란 **변경하기 쉬운 코드**입니다.

---

## 목차

- [개요](#개요)
- [1. 가독성 (Readability)](#1-가독성-readability)
  - [1-1. 같이 실행되지 않는 코드 분리하기](#1-1-같이-실행되지-않는-코드-분리하기)
  - [1-2. 구현 상세 추상화하기](#1-2-구현-상세-추상화하기)
  - [1-3. 로직 종류에 따라 합쳐진 함수 쪼개기](#1-3-로직-종류에-따라-합쳐진-함수-쪼개기)
  - [1-4. 복잡한 조건에 이름 붙이기](#1-4-복잡한-조건에-이름-붙이기)
  - [1-5. 매직 넘버에 이름 붙이기](#1-5-매직-넘버에-이름-붙이기)
  - [1-6. 시점 이동 줄이기](#1-6-시점-이동-줄이기)
  - [1-7. 삼항 연산자 단순하게 하기](#1-7-삼항-연산자-단순하게-하기)
  - [1-8. 왼쪽에서 오른쪽으로 읽히게 하기](#1-8-왼쪽에서-오른쪽으로-읽히게-하기)
- [2. 예측 가능성 (Predictability)](#2-예측-가능성-predictability)
  - [2-1. 이름 겹치지 않게 관리하기](#2-1-이름-겹치지-않게-관리하기)
  - [2-2. 같은 종류의 함수는 반환 타입 통일하기](#2-2-같은-종류의-함수는-반환-타입-통일하기)
  - [2-3. 숨은 로직 드러내기](#2-3-숨은-로직-드러내기)
- [3. 응집도 (Cohesion)](#3-응집도-cohesion)
  - [3-1. 함께 수정되는 파일을 같은 디렉토리에 두기](#3-1-함께-수정되는-파일을-같은-디렉토리에-두기)
  - [3-2. 매직 넘버 없애서 응집도 높이기](#3-2-매직-넘버-없애서-응집도-높이기)
  - [3-3. 폼의 응집도 생각하기](#3-3-폼의-응집도-생각하기)
- [4. 결합도 (Coupling)](#4-결합도-coupling)
  - [4-1. 책임을 하나씩 관리하기](#4-1-책임을-하나씩-관리하기)
  - [4-2. 중복 코드 허용하기](#4-2-중복-코드-허용하기)
  - [4-3. Props Drilling 지우기](#4-3-props-drilling-지우기)
- [기준 간 상충 관계](#기준-간-상충-관계)

---

## 개요

**Frontend Fundamentals (FF)** 는 토스에서 제공하는 "좋은 프론트엔드 코드의 기준"입니다.

좋은 프론트엔드 코드란 **변경하기 쉬운** 코드입니다. 새로운 요구사항이 생겼을 때 기존 코드의 수정과 배포가 수월해야 합니다.

### 대상 개발자

- 코드에 대한 고민을 논리적으로 설명하기 어려운 개발자
- 나쁜 코드를 빠르게 감지하고 개선하는 방법을 배우고 싶은 개발자
- 객관적 시각에서 코드 개선 방법을 이해하고 싶은 개발자
- 팀과 함께 공통의 코딩 스타일을 정하려는 개발자

### 4가지 핵심 기준

| 기준 | 설명 |
|------|------|
| **가독성** | 코드가 읽기 쉬운 정도. 한 번에 이해할 수 있는 맥락을 줄이고, 위에서 아래로 자연스럽게 흐르는 구조 |
| **예측 가능성** | 함수나 컴포넌트의 동작을 이름, 파라미터, 반환값만으로 예측할 수 있는 정도 |
| **응집도** | 함께 수정되어야 할 코드가 항상 같이 수정되는 정도 |
| **결합도** | 코드 수정 시 영향범위가 적고 예측 가능한 정도 |

---

## 1. 가독성 (Readability)

코드가 읽기 쉬운 정도를 의미합니다. 독자가 한 번에 이해할 수 있는 맥락을 줄이고, 위에서 아래로 자연스럽게 흐르는 구조가 중요합니다.

**전략:**
- 맥락 줄이기 (같이 실행되지 않는 코드 분리, 구현 상세 추상화, 함수 쪼개기)
- 이름 붙이기 (복잡한 조건, 매직 넘버)
- 위에서 아래로 읽히게 하기 (시점 이동 줄이기, 삼항 연산자 단순화)

> 참고: "프로그래머의 뇌"에 따르면, 사람의 뇌가 한 번에 저장할 수 있는 정보의 숫자는 6개입니다.

---

### 1-1. 같이 실행되지 않는 코드 분리하기

동시에 실행되지 않는 코드가 하나의 함수 또는 컴포넌트에 있으면, 동작을 한눈에 파악하기 어렵습니다. 구현 부분에 많은 분기가 들어가서 역할을 이해하기 어렵습니다.

#### Before

```tsx
function SubmitButton() {
  const isViewer = useRole() === "viewer";

  useEffect(() => {
    if (isViewer) {
      return;
    }
    showButtonAnimation();
  }, [isViewer]);

  return isViewer ? (
    <TextButton disabled>Submit</TextButton>
  ) : (
    <Button type="submit">Submit</Button>
  );
}
```

#### After

```tsx
function SubmitButton() {
  const isViewer = useRole() === "viewer";

  return isViewer ? <ViewerSubmitButton /> : <AdminSubmitButton />;
}

function ViewerSubmitButton() {
  return <TextButton disabled>Submit</TextButton>;
}

function AdminSubmitButton() {
  useEffect(() => {
    showButtonAnimation();
  }, []);

  return <Button type="submit">Submit</Button>;
}
```

**개선 효과:**
- `<SubmitButton />` 코드의 분기가 단 하나로 축소
- `<ViewerSubmitButton />`과 `<AdminSubmitButton />`에서는 각각 하나의 분기만 관리
- 코드를 읽는 사람이 한 번에 고려해야 할 맥락이 크게 감소

---

### 1-2. 구현 상세 추상화하기

한 번에 6~7개 정도의 맥락 범위 내에서 파악할 수 있도록 구현 세부사항을 추상화해야 가독성이 높아집니다.

#### 예시 1: 로그인 확인 및 리다이렉트

**Before:**

```tsx
function LoginStartPage() {
  useCheckLogin({
    onChecked: (status) => {
      if (status === "LOGGED_IN") {
        location.href = "/home";
      }
    }
  });

  /* ... 로그인 관련 로직 ... */
  return <>{/* ... 로그인 관련 컴포넌트 ... */}</>;
}
```

**After (Wrapper 컴포넌트):**

```tsx
function App() {
  return (
    <AuthGuard>
      <LoginStartPage />
    </AuthGuard>
  );
}

function AuthGuard({ children }) {
  const status = useCheckLoginStatus();

  useEffect(() => {
    if (status === "LOGGED_IN") {
      location.href = "/home";
    }
  }, [status]);

  return status !== "LOGGED_IN" ? children : null;
}

function LoginStartPage() {
  /* ... 로그인 관련 로직 ... */
  return <>{/* ... 로그인 관련 컴포넌트 ... */}</>;
}
```

**After (HOC 방식):**

```tsx
function LoginStartPage() {
  /* ... 로그인 관련 로직 ... */
  return <>{/* ... 로그인 관련 컴포넌트 ... */}</>;
}

export default withAuthGuard(LoginStartPage);

function withAuthGuard(WrappedComponent) {
  return function AuthGuard(props) {
    const status = useCheckLoginStatus();

    useEffect(() => {
      if (status === "LOGGED_IN") {
        location.href = "/home";
      }
    }, [status]);

    return status !== "LOGGED_IN" ? <WrappedComponent {...props} /> : null;
  };
}
```

#### 예시 2: 다이얼로그 로직 추상화

**Before:**

```tsx
function FriendInvitation() {
  const { data } = useQuery(/* ... */);

  // 이외 이 컴포넌트에 필요한 상태 관리, 이벤트 핸들러 및 비동기 작업 로직...

  const handleClick = async () => {
    const canInvite = await overlay.openAsync(({ isOpen, close }) => (
      <ConfirmDialog
        title={`${data.name}님에게 공유해요`}
        cancelButton={
          <ConfirmDialog.CancelButton onClick={() => close(false)}>
            닫기
          </ConfirmDialog.CancelButton>
        }
        confirmButton={
          <ConfirmDialog.ConfirmButton onClick={() => close(true)}>
            확인
          </ConfirmDialog.ConfirmButton>
        }
      />
    ));

    if (canInvite) {
      await sendPush();
    }
  };

  return (
    <>
      <Button onClick={handleClick}>초대하기</Button>
      {/* UI를 위한 JSX 마크업... */}
    </>
  );
}
```

**After:**

```tsx
export function FriendInvitation() {
  const { data } = useQuery(/* ... */);

  return (
    <>
      <InviteButton name={data.name} />
      {/* UI를 위한 JSX 마크업 */}
    </>
  );
}

function InviteButton({ name }) {
  return (
    <Button
      onClick={async () => {
        const canInvite = await overlay.openAsync(({ isOpen, close }) => (
          <ConfirmDialog
            title={`${name}님에게 공유해요`}
            cancelButton={
              <ConfirmDialog.CancelButton onClick={() => close(false)}>
                닫기
              </ConfirmDialog.CancelButton>
            }
            confirmButton={
              <ConfirmDialog.ConfirmButton onClick={() => close(true)}>
                확인
              </ConfirmDialog.ConfirmButton>
            }
          />
        ));

        if (canInvite) {
          await sendPush();
        }
      }}
    >
      초대하기
    </Button>
  );
}
```

---

### 1-3. 로직 종류에 따라 합쳐진 함수 쪼개기

쿼리 파라미터, 상태, API 호출과 같은 로직의 종류에 따라서 함수나 컴포넌트, Hook을 만들지 마세요. 한 번에 다루는 맥락의 종류가 많아져서 이해하기 힘들고 수정하기 어려운 코드가 됩니다.

#### Before

```typescript
export function usePageState() {
  const [query, setQuery] = useQueryParams({
    cardId: NumberParam,
    statementId: NumberParam,
    dateFrom: DateParam,
    dateTo: DateParam,
    statusList: ArrayParam
  });

  return useMemo(
    () => ({
      values: {
        cardId: query.cardId ?? undefined,
        statementId: query.statementId ?? undefined,
        dateFrom:
          query.dateFrom == null ? defaultDateFrom : moment(query.dateFrom),
        dateTo: query.dateTo == null ? defaultDateTo : moment(query.dateTo),
        statusList: query.statusList as StatementStatusType[] | undefined
      },
      controls: {
        setCardId: (cardId: number) => setQuery({ cardId }, "replaceIn"),
        setStatementId: (statementId: number) =>
          setQuery({ statementId }, "replaceIn"),
        setDateFrom: (date?: Moment) =>
          setQuery({ dateFrom: date?.toDate() }, "replaceIn"),
        setDateTo: (date?: Moment) =>
          setQuery({ dateTo: date?.toDate() }, "replaceIn"),
        setStatusList: (statusList?: StatementStatusType[]) =>
          setQuery({ statusList }, "replaceIn")
      }
    }),
    [query, setQuery]
  );
}
```

**문제점:**
- Hook의 책임: "페이지가 필요로 하는 모든 쿼리 파라미터 관리"
- 새로운 쿼리 파라미터 추가 시 무의식적으로 이 Hook에 추가됨
- 영역이 점점 넓어지면서 구현이 길어짐
- Hook을 사용하는 컴포넌트가 모든 쿼리 파라미터 변경에 리렌더링됨

#### After

```typescript
export function useCardIdQueryParam() {
  const [cardId, _setCardId] = useQueryParam("cardId", NumberParam);

  const setCardId = useCallback((cardId: number) => {
    _setCardId({ cardId }, "replaceIn");
  }, []);

  return [cardId ?? undefined, setCardId] as const;
}
```

**개선 효과:**
- 각 쿼리 파라미터별로 별도의 Hook 작성
- 명확한 이름으로 의도 표현
- Hook 수정 시 영향 범위를 좁힐 수 있음
- 필요한 파라미터만 변경 감지하여 불필요한 리렌더링 제거

---

### 1-4. 복잡한 조건에 이름 붙이기

복잡한 조건식이 특별한 이름 없이 사용되면, 조건이 뜻하는 바를 한눈에 파악하기 어렵습니다.

#### Before

```typescript
const result = products.filter((product) =>
  product.categories.some(
    (category) =>
      category.id === targetCategory.id &&
      product.prices.some((price) => price >= minPrice && price <= maxPrice)
  )
);
```

#### After

```typescript
const matchedProducts = products.filter((product) => {
  return product.categories.some((category) => {
    const isSameCategory = category.id === targetCategory.id;
    const isPriceInRange = product.prices.some(
      (price) => price >= minPrice && price <= maxPrice
    );

    return isSameCategory && isPriceInRange;
  });
});
```

**조건에 이름을 붙이면 좋을 때:**
- 복잡한 로직을 다룰 때
- 재사용성이 필요할 때
- 단위 테스트가 필요할 때

**조건에 이름을 붙이지 않아도 괜찮을 때:**
- 로직이 간단할 때 (예: `arr.map(x => x * 2)`)
- 한 번만 사용되며 복잡하지 않을 때

---

### 1-5. 매직 넘버에 이름 붙이기

매직 넘버는 의도를 명확하게 전달하지 못합니다. 원래 코드를 작성한 개발자가 아니면 그 의미를 알 수 없습니다.

#### Before

```typescript
async function onLikeClick() {
  await postLike(url);
  await delay(300);
  await refetchPostLike();
}
```

`300`이라는 값이 의미하는 바:
- 애니메이션이 완료될 때까지 기다리는 것인지?
- 좋아요 반영에 시간이 걸려서 기다리는 것인지?
- 테스트 코드였는데 깜빡하고 안 지운 것인지?

#### After

```typescript
const ANIMATION_DELAY_MS = 300;

async function onLikeClick() {
  await postLike(url);
  await delay(ANIMATION_DELAY_MS);
  await refetchPostLike();
}
```

---

### 1-6. 시점 이동 줄이기

코드를 읽을 때 위아래를 왔다갔다 하면서 읽거나, 여러 파일이나 함수, 변수를 넘나들면서 읽는 것을 "시점 이동"이라고 합니다. 시점이 여러 번 이동할수록 코드를 파악하는 데 시간이 더 걸립니다.

#### Before

```tsx
function Page() {
  const user = useUser();
  const policy = getPolicyByRole(user.role);

  return (
    <div>
      <Button disabled={!policy.canInvite}>Invite</Button>
      <Button disabled={!policy.canView}>View</Button>
    </div>
  );
}

function getPolicyByRole(role) {
  const policy = POLICY_SET[role];
  return {
    canInvite: policy.includes("invite"),
    canView: policy.includes("view")
  };
}

const POLICY_SET = {
  admin: ["invite", "view"],
  viewer: ["view"]
};
```

**문제:** Invite 버튼이 비활성화된 이유를 이해하려면 `policy.canInvite` -> `getPolicyByRole(user.role)` -> `POLICY_SET` 순으로 3번의 시점 이동이 필요합니다.

#### After (방법 A: 조건을 펼쳐서 드러내기)

```tsx
function Page() {
  const user = useUser();

  switch (user.role) {
    case "admin":
      return (
        <div>
          <Button disabled={false}>Invite</Button>
          <Button disabled={false}>View</Button>
        </div>
      );
    case "viewer":
      return (
        <div>
          <Button disabled={true}>Invite</Button>
          <Button disabled={false}>View</Button>
        </div>
      );
    default:
      return null;
  }
}
```

#### After (방법 B: 조건을 한눈에 볼 수 있는 객체로 만들기)

```tsx
function Page() {
  const user = useUser();
  const policy = {
    admin: { canInvite: true, canView: true },
    viewer: { canInvite: false, canView: true }
  }[user.role];

  return (
    <div>
      <Button disabled={!policy.canInvite}>Invite</Button>
      <Button disabled={!policy.canView}>View</Button>
    </div>
  );
}
```

> 권한 체계가 간단할 때는 추상화가 오히려 가독성을 해칠 수 있습니다.

---

### 1-7. 삼항 연산자 단순하게 하기

삼항 연산자를 복잡하게 사용하면 조건의 구조가 명확하게 보이지 않아서 코드를 읽기 어렵습니다.

#### Before

```typescript
const status =
  A조건 && B조건 ? "BOTH" : A조건 || B조건 ? (A조건 ? "A" : "B") : "NONE";
```

#### After

```typescript
const status = (() => {
  if (A조건 && B조건) return "BOTH";
  if (A조건) return "A";
  if (B조건) return "B";
  return "NONE";
})();
```

조건을 if 문으로 풀어서 사용하면 보다 명확하고 간단하게 조건을 드러낼 수 있습니다.

---

### 1-8. 왼쪽에서 오른쪽으로 읽히게 하기

범위를 확인하는 조건문은 수학의 부등식처럼 자연스럽게 읽히도록 작성합니다.

#### Before

```typescript
if (a >= b && a <= c) { ... }
if (score >= 80 && score <= 100) { console.log("우수"); }
if (price >= minPrice && price <= maxPrice) { console.log("적정 가격"); }
```

**문제:** 중간값 `a`를 두 번 확인해야 하므로 인지적 부담이 증가합니다.

#### After

```typescript
if (b <= a && a <= c) { ... }
if (80 <= score && score <= 100) { console.log("우수"); }
if (minPrice <= price && price <= maxPrice) { console.log("적정 가격"); }
```

수학의 부등식 `b <= a <= c`와 같은 형태로 읽혀서, 범위 조건을 직관적으로 이해할 수 있습니다.

---

## 2. 예측 가능성 (Predictability)

협업자들이 함수나 컴포넌트의 동작을 얼마나 예측할 수 있는지를 나타냅니다. 일관된 규칙을 따르고 이름, 파라미터, 반환값만으로 의도를 파악할 수 있어야 합니다.

**전략:**
- 이름 중복 방지
- 같은 종류 함수의 반환 타입 통일
- 숨은 로직 드러내기

---

### 2-1. 이름 겹치지 않게 관리하기

동일한 이름을 가진 함수나 변수는 동일한 동작을 해야 합니다. 작은 동작 차이가 코드의 예측 가능성을 낮추고 혼란을 야기할 수 있습니다.

#### Before

```typescript
// http.ts
import { http as httpLibrary } from "@some-library/http";

export const http = {
  async get(url: string) {
    const token = await fetchToken();
    return httpLibrary.get(url, {
      headers: { Authorization: `Bearer ${token}` }
    });
  }
};

// fetchUser.ts
import { http } from "./http";

export async function fetchUser() {
  return http.get("...");
}
```

**문제:** `http.get` 호출 시 개발자는 단순한 GET 요청을 예상하지만, 실제로는 토큰 인증 로직이 숨어 있습니다.

#### After

```typescript
// httpService.ts
import { http as httpLibrary } from "@some-library/http";

export const httpService = {
  async getWithAuth(url: string) {
    const token = await fetchToken();
    return httpLibrary.get(url, {
      headers: { Authorization: `Bearer ${token}` }
    });
  }
};

// fetchUser.ts
import { httpService } from "./httpService";

export async function fetchUser() {
  return await httpService.getWithAuth("...");
}
```

명확한 네이밍(`httpService`, `getWithAuth`)으로 함수의 인증 기능을 즉시 파악할 수 있습니다.

---

### 2-2. 같은 종류의 함수는 반환 타입 통일하기

유사한 기능을 하는 함수들의 반환 타입을 일관되게 유지해야 합니다.

#### 예시 1: API 호출 Hook

**Before:**

```typescript
function useUser() {
  const query = useQuery({ queryKey: ["user"], queryFn: fetchUser });
  return query; // Query 객체 반환
}

function useServerTime() {
  const query = useQuery({ queryKey: ["serverTime"], queryFn: fetchServerTime });
  return query.data; // 데이터만 반환 - 불일치!
}
```

**After:**

```typescript
function useUser() {
  const query = useQuery({ queryKey: ["user"], queryFn: fetchUser });
  return query;
}

function useServerTime() {
  const query = useQuery({ queryKey: ["serverTime"], queryFn: fetchServerTime });
  return query; // 일관된 반환 타입
}
```

#### 예시 2: 검증 함수

**Before:**

```typescript
function checkIsNameValid(name: string) {
  const isValid = name.length > 0 && name.length < 20;
  return isValid; // boolean 반환
}

function checkIsAgeValid(age: number) {
  if (!Number.isInteger(age)) {
    return { ok: false, reason: "나이는 정수여야 해요." };
  }
  // ...
  return { ok: true }; // 객체 반환 - 불일치!
}
```

**문제:** `if (checkIsAgeValid(age))` - 객체는 항상 truthy이므로 항상 true가 됩니다!

**After:**

```typescript
type ValidationCheckReturnType =
  | { ok: true }
  | { ok: false; reason: string };

function checkIsNameValid(name: string): ValidationCheckReturnType {
  if (name.length === 0) {
    return { ok: false, reason: "이름은 빈 값일 수 없어요." };
  }
  if (name.length >= 20) {
    return { ok: false, reason: "이름은 20자 이상 입력할 수 없어요." };
  }
  return { ok: true };
}

function checkIsAgeValid(age: number): ValidationCheckReturnType {
  if (!Number.isInteger(age)) {
    return { ok: false, reason: "나이는 정수여야 해요." };
  }
  if (age < 18) {
    return { ok: false, reason: "나이는 18세 이상이어야 해요." };
  }
  if (age > 99) {
    return { ok: false, reason: "나이는 99세 이하이어야 해요." };
  }
  return { ok: true };
}
```

> **TIP: Discriminated Union**을 활용하면 컴파일러가 불필요한 접근을 사전에 차단합니다.

---

### 2-3. 숨은 로직 드러내기

함수나 컴포넌트의 이름, 파라미터, 반환 값에 드러나지 않는 숨은 로직이 있다면, 협업 동료들이 동작을 예측하는 데 어려움을 겪습니다.

#### Before

```typescript
async function fetchBalance(): Promise<number> {
  const balance = await http.get<number>("...");

  logging.log("balance_fetched"); // 숨은 로직!

  return balance;
}
```

**문제:**
- 로깅을 원하지 않는 곳에서도 암묵적으로 로깅이 발생
- 로깅 로직에 오류 발생 시 계좌 잔액 조회 기능이 망가질 수 있음

#### After

함수의 이름, 파라미터, 반환 타입으로 예측할 수 있는 로직만 구현합니다:

```typescript
async function fetchBalance(): Promise<number> {
  const balance = await http.get<number>("...");
  return balance;
}
```

로깅은 호출하는 쪽에서 명시적으로 처리합니다:

```tsx
<Button
  onClick={async () => {
    const balance = await fetchBalance();
    logging.log("balance_fetched");
    await syncBalance(balance);
  }}
>
  계좌 잔액 갱신하기
</Button>
```

---

## 3. 응집도 (Cohesion)

함께 수정되어야 할 코드가 항상 같이 수정되는지를 의미합니다. 응집도가 높으면 한 부분 수정 시 의도치 않은 다른 부분의 오류가 발생하지 않습니다.

**전략:**
- 함께 수정되는 파일을 같은 디렉토리에 배치
- 매직 넘버 제거
- 폼의 응집도 고려

---

### 3-1. 함께 수정되는 파일을 같은 디렉토리에 두기

Hook, 컴포넌트, 유틸리티 함수 등을 여러 파일로 나누어 관리할 때, 올바른 디렉토리 구조를 갖추는 것이 중요합니다.

#### Before (종류별 분류 - 나쁜 구조)

```
└─ src
   ├─ components
   ├─ constants
   ├─ containers
   ├─ contexts
   ├─ remotes
   ├─ hooks
   ├─ utils
   └─ ...
```

**문제점:**
- 파일을 종류별로 나누면 코드 간 의존 관계를 파악하기 어려움
- 기능 삭제 시 연관된 코드가 함께 삭제되지 않아 사용되지 않는 코드가 남음
- 프로젝트 규모가 커질수록 디렉토리가 100개 이상의 파일을 담게 될 수 있음

#### After (도메인별 분류 - 좋은 구조)

```
└─ src
   │  // 전체 프로젝트에서 사용되는 코드
   ├─ components
   ├─ containers
   ├─ hooks
   ├─ utils
   ├─ ...
   │
   └─ domains
      │  // Domain1에서만 사용되는 코드
      ├─ Domain1
      │     ├─ components
      │     ├─ containers
      │     ├─ hooks
      │     ├─ utils
      │     └─ ...
      │
      │  // Domain2에서만 사용되는 코드
      └─ Domain2
            ├─ components
            ├─ containers
            ├─ hooks
            ├─ utils
            └─ ...
```

**장점:**
- 잘못된 참조를 쉽게 감지할 수 있음 (예: `import { useFoo } from "../../../Domain2/hooks/useFoo"`)
- 특정 기능 삭제 시 한 디렉토리 전체를 삭제하면 사용되지 않는 코드가 남지 않음

---

### 3-2. 매직 넘버 없애서 응집도 높이기

매직 넘버가 있으면, 관련 값이 변경될 때 함께 수정되어야 할 코드가 누락될 위험이 있습니다.

#### Before

```typescript
async function onLikeClick() {
  await postLike(url);
  await delay(300);
  await refetchPostLike();
}
```

**문제:** 숫자 `300`이 애니메이션 완료를 기다리는 시간이라면, 애니메이션 변경 시 이 값도 함께 수정되어야 합니다. 한쪽만 수정되면 서비스가 깨질 위험이 있으며, 이는 **응집도가 낮은 코드**입니다.

#### After

```typescript
const ANIMATION_DELAY_MS = 300;

async function onLikeClick() {
  await postLike(url);
  await delay(ANIMATION_DELAY_MS);
  await refetchPostLike();
}
```

상수로 선언하여 애니메이션 시간 변경 시 한 곳에서만 수정하면 됩니다.

---

### 3-3. 폼의 응집도 생각하기

Form으로 사용자 입력을 받을 때, 2가지 응집도 관리 방식을 고려할 수 있습니다.

#### 방식 1: 필드 단위 응집도

개별 입력 요소를 독립적으로 관리합니다. 각 필드의 검증 로직이 독립적이어서 특정 필드 유지보수 범위가 줄어듭니다.

```tsx
export function Form() {
  const {
    register,
    formState: { errors },
    handleSubmit
  } = useForm({
    defaultValues: { name: "", email: "" }
  });

  return (
    <form onSubmit={handleSubmit((formData) => console.log(formData))}>
      <div>
        <input
          {...register("name", {
            validate: (value) =>
              isEmptyStringOrNil(value) ? "이름을 입력해주세요." : ""
          })}
          placeholder="이름"
        />
        {errors.name && <p>{errors.name.message}</p>}
      </div>
      <div>
        <input
          {...register("email", {
            validate: (value) => {
              if (isEmptyStringOrNil(value)) return "이메일을 입력해주세요.";
              if (!/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i.test(value))
                return "유효한 이메일 주소를 입력해주세요.";
              return "";
            }
          })}
          placeholder="이메일"
        />
        {errors.email && <p>{errors.email.message}</p>}
      </div>
      <button type="submit">제출</button>
    </form>
  );
}
```

#### 방식 2: 폼 전체 단위 응집도

모든 필드의 검증 로직이 폼에 종속됩니다. zod 같은 스키마 검증 라이브러리를 활용합니다.

```tsx
const schema = z.object({
  name: z.string().min(1, "이름을 입력해주세요."),
  email: z
    .string()
    .min(1, "이메일을 입력해주세요.")
    .email("유효한 이메일 주소를 입력해주세요.")
});

export function Form() {
  const {
    register,
    formState: { errors },
    handleSubmit
  } = useForm({
    defaultValues: { name: "", email: "" },
    resolver: zodResolver(schema)
  });

  return (
    <form onSubmit={handleSubmit((formData) => console.log(formData))}>
      <div>
        <input {...register("name")} placeholder="이름" />
        {errors.name && <p>{errors.name.message}</p>}
      </div>
      <div>
        <input {...register("email")} placeholder="이메일" />
        {errors.email && <p>{errors.email.message}</p>}
      </div>
      <button type="submit">제출</button>
    </form>
  );
}
```

#### 선택 기준

**필드 단위 응집도가 좋을 때:**
- 독립적인 검증이 필요할 때 (이메일 형식, 전화번호 유효성, 아이디 중복 확인 등)
- 재사용이 필요할 때 (필드와 검증 로직이 다른 폼에서도 동일하게 사용)

**폼 전체 단위 응집도가 좋을 때:**
- 단일 기능을 나타낼 때 (결제 정보, 배송 정보 등)
- 단계별 입력이 필요할 때 (Wizard Form처럼 스텝별로 동작)
- 필드 간 의존성이 있을 때 (비밀번호 확인, 총액 계산)

---

## 4. 결합도 (Coupling)

코드 수정 시의 영향범위를 나타냅니다. 영향범위가 적으면 변경에 따른 범위 예측이 가능합니다.

**전략:**
- 책임을 개별적으로 관리
- 중복 코드 허용
- Props Drilling 제거

---

### 4-1. 책임을 하나씩 관리하기

단일 Hook이 페이지의 모든 쿼리 파라미터를 관리하면, 페이지 내 컴포넌트와 훅들이 이 훅에 의존하게 되어 코드 수정 시 영향 범위가 급격히 확장됩니다.

#### Before

```typescript
export function usePageState() {
  const [query, setQuery] = useQueryParams({
    cardId: NumberParam,
    statementId: NumberParam,
    dateFrom: DateParam,
    dateTo: DateParam,
    statusList: ArrayParam
  });

  return useMemo(
    () => ({
      values: { /* 모든 쿼리 파라미터 */ },
      controls: { /* 모든 setter */ }
    }),
    [query, setQuery]
  );
}
```

#### After

```typescript
export function useCardIdQueryParam() {
  const [cardId, _setCardId] = useQueryParam("cardId", NumberParam);

  const setCardId = useCallback((cardId: number) => {
    _setCardId({ cardId }, "replaceIn");
  }, []);

  return [cardId ?? undefined, setCardId] as const;
}
```

각각의 쿼리 파라미터별로 별도의 Hook을 작성하여 책임을 분리합니다.

---

### 4-2. 중복 코드 허용하기

공통화하면 응집도를 높일 수 있지만, 불필요한 결합도가 생겨 공통 컴포넌트나 Hook을 수정할 때마다 영향을 받는 코드의 범위가 넓어져서 오히려 수정이 어려워질 수 있습니다.

#### Before (공통화된 Hook)

```typescript
export const useOpenMaintenanceBottomSheet = () => {
  const maintenanceBottomSheet = useMaintenanceBottomSheet();
  const logger = useLogger();

  return async (maintainingInfo: TelecomMaintenanceInfo) => {
    logger.log("점검 바텀시트 열림");
    const result = await maintenanceBottomSheet.open(maintainingInfo);
    if (result) {
      logger.log("점검 바텀시트 알림받기 클릭");
    }
    closeView();
  };
};
```

#### 공통화 vs 중복 판단 기준

**공통화해도 좋은 경우:**
- 페이지에서 로깅하는 값이 같고
- 바텀시트의 동작이 동일하고
- 바텀시트의 모양이 동일하고
- **앞으로도 그럴 예정일 때**

**중복 코드를 허용하는 것이 나은 경우:**
- 페이지마다 로깅하는 값이 달라질 수 있다면
- 어떤 페이지에서는 바텀시트를 닫더라도 화면을 닫을 필요가 없다면
- 바텀시트에서 보여지는 텍스트나 이미지를 다르게 해야 한다면

> 중복 코드가 반드시 나쁜 것은 아닙니다. 미래의 변경 가능성을 고려하여 결합도와 응집도 사이의 균형을 맞추는 것이 중요합니다.

---

### 4-3. Props Drilling 지우기

Props Drilling은 부모 컴포넌트와 자식 컴포넌트 사이에 결합도가 생겼다는 것을 나타내는 명확한 표시입니다. prop이 변경되면 prop을 참조하는 모든 컴포넌트를 수정해야 합니다.

#### Before

```tsx
function ItemEditModal({ open, items, recommendedItems, onConfirm, onClose }) {
  const [keyword, setKeyword] = useState("");

  return (
    <Modal open={open} onClose={onClose}>
      <ItemEditBody
        items={items}
        keyword={keyword}
        onKeywordChange={setKeyword}
        recommendedItems={recommendedItems}
        onConfirm={onConfirm}
        onClose={onClose}
      />
    </Modal>
  );
}

function ItemEditBody({
  keyword, onKeywordChange, items, recommendedItems, onConfirm, onClose
}) {
  return (
    <>
      <div style={{ display: "flex", justifyContent: "space-between" }}>
        <Input value={keyword} onChange={(e) => onKeywordChange(e.target.value)} />
        <Button onClick={onClose}>닫기</Button>
      </div>
      <ItemEditList
        keyword={keyword}
        items={items}
        recommendedItems={recommendedItems}
        onConfirm={onConfirm}
      />
    </>
  );
}
```

#### After (방법 A: 조합 패턴)

`children`을 사용해 필요한 컴포넌트를 부모에서 작성하도록 하면 불필요한 Props Drilling을 줄일 수 있습니다.

```tsx
function ItemEditModal({ open, items, recommendedItems, onConfirm, onClose }) {
  const [keyword, setKeyword] = useState("");

  return (
    <Modal open={open} onClose={onClose}>
      <ItemEditBody
        keyword={keyword}
        onKeywordChange={setKeyword}
        onClose={onClose}
      >
        <ItemEditList
          keyword={keyword}
          items={items}
          recommendedItems={recommendedItems}
          onConfirm={onConfirm}
        />
      </ItemEditBody>
    </Modal>
  );
}

function ItemEditBody({ children, keyword, onKeywordChange, onClose }) {
  return (
    <>
      <div style={{ display: "flex", justifyContent: "space-between" }}>
        <Input value={keyword} onChange={(e) => onKeywordChange(e.target.value)} />
        <Button onClick={onClose}>닫기</Button>
      </div>
      {children}
    </>
  );
}
```

#### After (방법 B: Context API)

조합 패턴으로도 해결되지 않는 깊은 컴포넌트 트리에서 사용합니다.

```tsx
function ItemEditModal({ open, onConfirm, onClose }) {
  const [keyword, setKeyword] = useState("");

  return (
    <Modal open={open} onClose={onClose}>
      <ItemEditBody keyword={keyword} onKeywordChange={setKeyword} onClose={onClose}>
        <ItemEditList keyword={keyword} onConfirm={onConfirm} />
      </ItemEditBody>
    </Modal>
  );
}

function ItemEditList({ keyword, onConfirm }) {
  const { items, recommendedItems } = useItemEditModalContext();
  // items와 recommendedItems를 Context에서 직접 가져옴
  // ...
}
```

#### Context API 사용 시 고려사항

1. **Props의 명확성** - 컴포넌트의 역할과 의도를 담고 있는 props라면 Props Drilling이 문제가 되지 않을 수 있음
2. **조합 패턴 우선 시도** - `children` prop을 이용해 depth를 줄일 수 있는지 먼저 확인
3. **마지막 수단으로 활용** - 위 방법들이 맞지 않을 때 최후의 방법으로 Context API 사용

---

## 기준 간 상충 관계

4가지 기준을 동시에 만족하기는 어렵습니다. 상황에 따라 균형을 맞춰야 합니다.

- 함께 수정되지 않으면 오류 발생 위험이 높은 경우 -> **응집도 우선**
- 위험성이 낮으면 -> **가독성 우선**

> 좋은 코드에 대한 판단은 상황에 따라 달라질 수 있으며, 동료들과의 소통을 통해 최적의 균형점을 찾는 것이 중요합니다.
