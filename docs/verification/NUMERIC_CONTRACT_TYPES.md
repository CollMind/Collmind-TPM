# Numeric Contract: Types and Enforcement (ADR 0007 F1)

**Date:** 2026-08-04 · **Branch:** `feat/numeric-contract-types` · **Base:** F0 `3ed93e7`

> **Branch note.** The task specified branching from `staging`, but F0 (`3ed93e7` — the
> money-float guard and its baseline) lives only on `feat/money-float-guard` and is not in
> `staging`. Branching from `staging` would have produced a tree where the required verification
> step `money-float.sh --ratchet` cannot run, because the script does not exist there. F1 was
> therefore branched from F0, honouring the stated dependency. Rebasing onto `staging` once F0
> merges is a single command.

---

## Types

**Placement: `src/common/numeric/`.** The dependency direction decides it.
`src/database/entities/*` and `src/database/transformers/*` must import these (transformer
factories), and `src/modules/**` must too. `src/common` today holds `services/`, `decorators/`,
`guards/`, `interceptors/` and depends on no module, so the one-way edge is preserved
(`common ← database`, `common ← modules`). Placing them under `src/modules/shared/` would create a
`database/entities → modules/shared` edge that does not exist today and would invert the module
boundary — rejected.

```
src/common/numeric/
  brands.ts       Scale · Branded<S> · MoneyMinor · RateMicro + scale constants
  limits.ts       2^53 ceilings, NumericOverflowError
  rounding.ts     roundHalfAwayFromZero · roundToMinorUnits · sumMoney
  money.ts        MoneyMinor factories + exact arithmetic
  rate.ts         RateMicro factories + applyRate
  allocation.ts   allocateLargestRemainder
  index.ts        the only import surface
```

**Naming (errata E3).** `RateMicro`, not `RateBps`. A basis point is 0.01%; this scale is 1/100 of
that, so `RateBps` would promise `325` where the value is `32500`. `Micro` is honest for 1e-6 of
unity. Locked by a test asserting `rateFromPercent(3.25) === 32500`.

**Factories.** Values enter the branded world through factories only — every one validates, because
a factory that accepts anything is a cast with extra steps:

| Factory | Accepts | Rejects |
|---|---|---|
| `moneyFromMinorUnits` | whole kuruş | non-integer (with a pointer to `fromMajorUnits`), non-finite, beyond 2^53 |
| `moneyFromMajorUnits` | TRY amount | non-finite; rounds half-away-from-zero |
| `moneyFromNumericString` | `numeric(18,2)` text | malformed literal; **sub-kuruş precision** — refuses rather than truncating silently |
| `rateFromMicro` / `rateFromPercent` | integer micro / percent | non-integer micro, non-finite |
| `rateFromNumericString` | `numeric(9,4)` text | precision below the column's own scale |

`moneyFromNumericString` parses digit-wise rather than through `Number()` — routing an exact
decimal string through IEEE-754 on the way *in* is the defect this contract exists to remove, and
is precisely what the existing `DecimalTransformer` does.

**Cast prevention.** `tsc` catches `m as RateMicro` (TS2352) but **not** `n as unknown as
MoneyMinor` (0013 §3.1 row 10). The gap is closed by ESLint `no-restricted-syntax` over
`src/**/*.ts` with `src/common/numeric/*.ts` excluded — the factory is the implementation of the
brand, so it must be able to cast. Proof below.

**Third-brand extensibility (A7).** `VolumeMilli` is out of scope this round. Adding it later means
adding one member to `Scale` and one alias — nothing else. Helper signatures are written against
`Branded<S>` or against a single concrete scale, never against a closed union of "the two brands",
so no helper shape assumes two.

---

## Helpers

### `roundHalfAwayFromZero` (Karar 6, errata E7)

`|round(x)| === round(|x|)`; `round(2.5) = 3`, `round(-2.5) = -3`. Throws `RangeError` on
non-finite input rather than producing `NaN`.

**Why not `Math.round`:** `Math.round(-2.5) === -2` — it rounds toward +∞, silently reintroducing
the ambiguity the mode change removes. **K7 regression test** asserts the negative-half case and
explicitly asserts the two functions disagree.

Applied at persistence only. `allocation.ts` is the single place that rounds mid-computation, and
it does so under a conservation invariant that is property-tested.

`ledger_entries` currently holds 1231 rows and **0 negative amounts**, so this rule is being fixed
while nothing depends on it. Reversal and CREDIT paths will exercise it.

### `allocateLargestRemainder` (Karar 6, canonical per errata E6)

Four steps as specified: exact share floored → remainder → one minor unit at a time to the largest
fractional parts → **ties broken on a caller-supplied business key**.

The helper *refuses* to invent a tie-break (`tieBreak: []` throws). Ordering by a generated id is
forbidden by INV-N-001 because it makes kuruş placement depend on a value with no business meaning
that differs between environments — the same input would allocate differently in dev and prod and
neither would be reproducible from the data.

It also refuses a zero total weight rather than defaulting to an equal split: whether that means
"skip" or "split equally" is a business decision (cf. ADR 0006 Karar 2, where null base volume
explicitly receives no share), and a silent default is how the wrong one gets chosen.

Conservation is asserted inside the function, not merely intended — if `Σ parts !== total` it
throws rather than returning a plausible-looking wrong answer.

### Scale conversion — **`DecimalTransformer` left alone**

`moneyFromNumericString` / `moneyToNumericString` and `rateFromNumericString` /
`rateToNumericString` are the conversion surface, to be wired into new-module entities in F2.

**Measured before deciding:** `DecimalTransformer` has **29 references across 5 entity files**
(`budget-allocation`, `budget-envelope`, `budget-summary.view`, `sales-actual`,
`sales-actual-batch`). Its `from` calls `Number(value)` — the defect. Rewriting it would change the
runtime type of every money column on those five entities, which is representation conversion of
existing Domain A code. **That is ratchet territory (STOP condition 3), not F1.** A new
transformer is therefore added alongside in F2; the old one keeps its consumers until the ratchet
reaches them.

### Overflow guard (errata E4, A9)

Applied to the **operand, before the multiplication** — checking the product afterwards would
validate a number that is already wrong. Ceiling is derived (`2^53 / RATE_SCALE`), not hand-typed:
≈ 9.007e9 kuruş ≈ **90,071,992 TRY**, not the 90 trillion the ADR first implied. Today's largest
real value is 600,000 TRY — ~150× headroom, so it never fires in practice yet.

**K12:** the message carries the literal `50000000` and the string `ADR 0007 E4/A9`, so whoever
sees the throw finds the pending `bigint` decision instead of guessing. Asserted by test.

### `applyRate`

`applyRate(amount: MoneyMinor, rate: RateMicro): MoneyMinor` — the one place the two scales meet.
Intermediate scale is 1e-6 kuruş (`minor × micro`); the operand check runs first; rounding enters
exactly once, at the end.

---

## The number-slot rule

### Three mechanisms evaluated

| Mechanism | How it fails | Verdict |
|---|---|---|
| **Sixth guard script** (bash/grep) | Cannot see types. `amount: number` and `count: number` are indistinguishable lexically without an AST, so it either over-reports every `number` in a new module or needs the same name heuristic with worse tooling. Also duplicates scope logic that ESLint already resolves via `files:`. | rejected |
| **Type-level convention** (e.g. a nominal wrapper that makes `number` unassignable) | Cannot be enforced. Nothing stops a developer from declaring `amount: number` — the convention has no teeth, and this repo has nine recorded cases of an unenforced convention being ignored. | rejected |
| **Extended ESLint rule** | AST-aware, so it distinguishes a property signature from a local variable; scoped by `files:` from a declaration file; reuses the `UserRole` precedent already in this config. Fails on: name-based money/non-money heuristic (documented), and it cannot see through a type alias (`type Amount = number`). | **chosen** |

### Chosen implementation

Two overrides in `.eslintrc.js`:

1. **Cast ban** — `src/**/*.ts` except `src/common/numeric/*.ts`.
2. **Number-slot ban** — new-module paths only. Catches `number` on class properties, DTO/interface
   fields, and method signatures, **except** identifiers on a documented exemption list
   (`count`, `index`, `page`, `pageSize`, `limit`, `offset`, `version`, `order`, `sequence`,
   `length`, `size`, `totalCount`, `retries`, `attempts`, `priority`, `decimalPlaces`).

The exemption is a heuristic and is named as one. A rule that flags `pageSize: number` gets
switched off within a week, so the false-positive direction is the dangerous one here — the reverse
of the money-float guard, where over-reporting was safe.

### 🔴 Defect found while proving it

An **empty** `files: []` array makes ESLint reject the entire config
(`"overrides[2].files" should NOT have fewer than 1 items`) and refuse to start — so an empty
NEW_MODULES declaration would not merely disable the rule, it would break `npm run lint` for the
whole repository. That is exactly today's state, by design.

Fixed by spreading the override in conditionally. **This is the reason the fixture proof had to be
run against the real, empty declaration and not only against a populated one**: the first proof run
passed because a fixture path had been appended, which masked the breakage completely.

### NEW_MODULES — one declaration, two consumers ⟨binding⟩

`scripts/guards/new-modules.txt`.

* `scripts/guards/money-float.sh` reads it to decide which paths run in `block` rather than
  report-only (errata E11).
* `.eslintrc.js` reads the same file via `fs.readFileSync` to build the number-slot override's
  `files:` globs.

One file, two readers, no second list. This repo has seven recorded cases of a concept declared
twice and then diverging — two allocation implementations with different remainder rules, two
submit paths writing different buckets, two allowlist readers with different accept rules, two
derivations of the same grid column list. A second declaration here would be the eighth.

The file is **deliberately empty**: `claims` and `recognition_variance` do not exist and F1 does
not create them. The day one is created, the only remaining step is one line.

### Fixture matrix

| Fixture | Expectation | Records |
|---|---|---|
| `number-slot-money.ts.fixture` | **caught** (3 findings) | errata E1 — the `number` slot is the leak a brand cannot close |
| `number-slot-legit.ts.fixture` | **not caught** (0) | the over-reporting boundary; if it fires, the exemption list lost an entry and the rule is about to be disabled by whoever it annoys |
| existing Domain A file (`budget.service.ts`) | **not caught** (0) | errata E11 — existing code is report-only, new modules block from birth |

**Negative test:** emptying the declaration (i.e. disabling the mechanism) makes the money fixture
report **0** — confirming the proof measures the mechanism and not something incidental.

---

## Brand proof

```
(1) const stored: MoneyMinor = m * r;
    src/__brand_proof__/proof.ts(5,14): error TS2322:
      Type 'number' is not assignable to type 'MoneyMinor'.          ← the real gate

(2) const wide: number = m * r;
    (no diagnostic)                                                   ← the E1 leak, expected

(3) const leak  = n as unknown as MoneyMinor;
    const leak2 = n as MoneyMinor;
    3:37  error  Branded numeric types are produced by src/common/numeric
                 factories only; `as` casts are forbidden ...  no-restricted-syntax
    4:27  error  (same)                                        no-restricted-syntax
    eslint exit=1

(4) number money slot in a new-module fixture
    claim.entity.ts → 3 × no-restricted-syntax, eslint exit=1
    page.dto.ts     → 0 findings,               eslint exit=0
    existing Domain A file → 0 findings,        eslint exit=0
    mechanism disabled (declaration emptied) → 0 findings, exit=0   ← negative test
```

All four behave as ADR 0007 errata E1 predicts, including (2) — which is the point: the leak is
real, and it is what the number-slot rule exists to close.

---

## What this does not protect

E1 showed the intuitive claim was wrong, so the remaining gaps are stated rather than implied
away:

1. **Cross-brand comparison is not caught.** `m > r` compiles. Comparing money to a rate is
   nonsense but the type system permits it (0013 §3.1 row 8).
2. **Widening to `number` is legal and unavoidable.** `needsNumber(m)` compiles. Any function
   taking `number` accepts branded values silently — including every existing Domain A function.
3. **Type aliases defeat the slot rule.** `type Amount = number; amount!: Amount` is not caught;
   the selector matches `TSNumberKeyword`, not what an alias resolves to.
4. **The money/non-money split is name-based.** `pageSize: number` passes because of its name, not
   because anything knows it is not money. A money field named `count` would slip through.
5. **Existing Domain A code is untouched by all of it.** These rules apply to new modules only
   (errata E11). The 163 baseline findings remain, governed by the ratchet, not by types.
6. **Nothing enforces that new modules *use* these helpers.** A new module could do its own
   arithmetic on branded values via widening (gap 2). The slot rule catches the storage, not the
   computation.
7. **Frontend is entirely out of reach.** `0012` found client-side money derivation and a knowingly
   wrong incremental-GP figure on an approval screen. No backend type reaches it.

---

## Open questions

1. **Does the slot rule need to cover service signatures crossing the repository boundary?**
   (task 3.1's optional clause). Currently method signatures are covered generically, which may
   over-report on non-money services once a new module exists. Unmeasurable until one does.
2. **Type-alias evasion (gap 3)** — worth closing with `TSTypeReference` resolution, or accept and
   document? Closing it needs type information ESLint selectors do not carry.
3. **`sumMoney` vs `addMoney`** — two ways to add. Should the pairwise one be removed to force the
   list form, on the "one derivation point" principle?
4. **When new modules appear, who verifies the declaration was updated?** Today nothing fails if a
   module is created and not listed — it silently falls back to report-only, which is the grace
   period the ADR says new code must not get. A guard could compare module directories against the
   declaration.
