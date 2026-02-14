# Frontend Code Quality Rules (Toss Frontend Fundamentals)

Good frontend code = **easy to change**. Evaluate code by 4 criteria: Readability, Predictability, Cohesion, Coupling.

## 1. Readability

Human brain holds ~6 items at once. Minimize context per code block.

- **Separate non-co-executing code**: Split components that branch by state into separate sub-components (e.g., `<ViewerButton />` vs `<AdminButton />` instead of one component with `if/else`).
- **Abstract implementation details**: Extract auth guards, dialog logic into wrapper components or HOCs. Keep parent components focused on "what" not "how".
- **Split merged logic by responsibility**: Don't create one hook for all query params (`usePageState`). Create individual hooks (`useCardIdQueryParam`) — clearer naming, narrower re-render scope.
- **Name complex conditions**: Extract `isSameCategory && isPriceInRange` instead of inline nested `.some()` chains.
- **Name magic numbers**: `const ANIMATION_DELAY_MS = 300` instead of bare `300`.
- **Minimize point-of-view shifts**: Avoid forcing readers to jump between functions/files/constants. Inline simple lookups; use object maps visible in the same scope.
- **Simplify ternaries**: Replace nested ternaries with IIFE + early returns: `(() => { if (A && B) return "BOTH"; ... })()`.
- **Left-to-right range comparisons**: Write `minPrice <= price && price <= maxPrice` (math-style) instead of `price >= minPrice && price <= maxPrice`.

## 2. Predictability

Functions should do exactly what their name/params/return type suggest.

- **No name collisions with different behavior**: If wrapping `http.get` with auth, name it `httpService.getWithAuth`, not `http.get`.
- **Unify return types for similar functions**: All `useXxx` query hooks should return the same shape (e.g., full query object). All `checkIsXxxValid` functions should return `{ ok: boolean; reason?: string }`, never mixed boolean/object. Use discriminated unions.
- **No hidden side effects**: `fetchBalance()` should only fetch — don't embed logging inside. Let callers add logging explicitly.

## 3. Cohesion

Code that changes together should live together.

- **Co-locate by domain, not by type**: Don't organize as `hooks/`, `components/`, `utils/` at top level. Use `domains/Feature1/{hooks,components,utils}`. Enables easy deletion and bad-import detection.
- **Eliminate magic numbers for cohesion**: If `300` is tied to animation duration, extract as a named constant so changes propagate together.
- **Form cohesion strategy**:
  - *Field-level*: Each field owns its validation (good for reusable, independently validated fields).
  - *Form-level*: Centralized schema validation with zod (good for wizard forms, cross-field dependencies).
  - Choose based on whether changes happen per-field or per-form.

## 4. Coupling

Minimize blast radius of changes.

- **Single responsibility per hook/function**: One hook per query param, not one god-hook for all page state.
- **Allow duplication over premature abstraction**: If pages may diverge in behavior (different logging, different UI), keep code duplicated rather than forcing a shared hook that accumulates params/options. Only abstract when behavior is truly identical and will stay that way.
- **Eliminate Props Drilling**:
  1. First try **Composition pattern** (`children` prop) to remove pass-through intermediaries.
  2. Then try **Context API** as last resort for deeply nested trees.
  3. Props that express component intent are fine — only drill-through props that a component doesn't use are problematic.

## Trade-offs

The 4 criteria can conflict. Prioritize:
- **Cohesion first** when co-modification failures cause bugs.
- **Readability first** when risk of separate modification is low.
- Discuss trade-offs with teammates to find the right balance.
