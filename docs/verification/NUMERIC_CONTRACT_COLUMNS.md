# Numeric Contract: Columns, JSONB and Write Validation (ADR 0007 F2)

**Date:** 2026-08-04 · **Branch:** `feat/numeric-contract-columns` · **Base:** F1 `70eaa4d`

| Commit | Content | SHA | Status |
|---|---|---|---|
| **C1** | Column split — expand phase | `ce1ca97` | **done** |
| **C2a** | JSONB semantics (J1) — discriminated union | `43301b5` | **done** |
| **C2b** | 18 readers converted + `DROP COLUMN` (contract phase) | `42a59a6` `bafafa3` `88493eb` `3336c38` `95cb6e6` | **done** |
| **C3** | Write-side scale validation | — | pending |

---

## The distinction this phase runs on ⟨binding⟩

`plan.service.ts` must stay at **exactly 36** ratchet findings after every commit — neither up
nor down. Up means F2 added float debt. Down is subtler and worse: F2 performed an out-of-scope
representation conversion (K9), and the ratchet then records "this file partially converted" —
so the real conversion task inherits a file where nobody can say which part converted or why.

Structural change is not representation change:

| Structural — permitted | Representation — K9 violation |
|---|---|
| `buildMechanicValues` return type becomes a discriminated union | `parseFloat` → `moneyFromNumericString` |
| Caller signature types change | Removing a `Number()` call |
| `if (val != null)` → explicit error | Moving arithmetic onto `MoneyMinor` |

**The test is simple: if the ratchet dropped, you touched representation.** Every dropped finding
must be justified one by one — and even "that line should have gone anyway" is a K9 violation.
That work belongs to the ratchet, not to F2.

---

## Ratchet gate

### C1 — `ce1ca97`

```
$ bash scripts/guards/money-float.sh --ratchet ; echo "exit=$?"
exit=0
                                    ← output empty: no file moved

plan.service.ts   baseline: 36      current: 36
git status --porcelain | grep plan.service.ts
                                    ← absent from the diff entirely

$ npm run guards          exit=0
$ npx tsc --noEmit        exit=0
$ npx jest                exit=0    Tests: 648 passed, 648 total

$ e2e ×3, no reset between runs, exit captured directly (CLAUDE.md §2.6)
  run 1  exit=0   Tests: 239 passed, 239 total   [T-047 invariant] PASS
  run 2  exit=0   Tests: 239 passed, 239 total   [T-047 invariant] PASS
  run 3  exit=0   Tests: 239 passed, 239 total   [T-047 invariant] PASS
```

Nothing moved, so nothing needed reverting.

### C2a / C2b — see the per-commit tables below

C1's gate was easy because `plan.service.ts` never appeared in the diff. C2a/C2b are where the
criterion was actually tested — `plan.service.ts` is one of the callers whose signature changed.
It held at 36 across all five commits.

### C3 — pending

---

## C1 — Column split (expand phase)

### Schema

Measured live before writing the migration — three semantics, not two:

| category | input_type | mechanic_type | meaning | column |
|---|---|---|---|---|
| on/off_invoice_discount | percentage | PERCENT | rate 0–100 | `entered_rate_pct numeric(9,4)` |
| per_unit_support | currency | AMOUNT_PER_UNIT | TRY per unit (price scale) | `entered_unit_amount numeric(18,4)` |
| lumpsum_spend | currency | AMOUNT | TRY total (money scale) | `entered_total_amount numeric(18,2)` |

A unit price and a total amount round and overflow differently; collapsing them into one "money"
column would hide the distinction inside the column rather than remove it. **STOP #2 not
triggered** — `0013`'s three-column choice matches current measurement.

### Expand-contract (errata E13)

The task specified `DROP COLUMN` in C1, but that contradicts C1's own definition — "schema is
born, nobody reads it yet". Dropping a column is impossible without touching its readers.
Measured: removing `enteredValue` from the entity broke **8 references**
(`spend-distribution.service.ts:100`, `buildMechanicValues`, and three spec files). A C1 that
dropped it could neither compile nor be reverted on its own.

```
C1  expand    → three new columns + CHECK, entered_value stays
C2  migrate   → readers move to the new columns, THEN drop (migration 1797)
```

The four-column intermediate state is the pattern, not a cost.

### CHECK constraints — verified present in `main`

Not merely recorded in the `migrations` table:

```sql
SELECT conname, contype, pg_get_constraintdef(c.oid)
  FROM pg_constraint c JOIN pg_namespace n ON n.oid = c.connamespace
 WHERE n.nspname='main' AND c.conrelid = 'main.plan_mechanic_values'::regclass AND c.contype='c';
```
```
chk_pmv_at_most_one_entered | c | CHECK ((((entered_rate_pct IS NOT NULL))::integer
                                       + ((entered_unit_amount IS NOT NULL))::integer
                                       + ((entered_total_amount IS NOT NULL))::integer) <= 1)
chk_pmv_rate_range          | c | CHECK (((entered_rate_pct IS NULL)
                                     OR ((entered_rate_pct >= (0)::numeric)
                                     AND (entered_rate_pct <= (100)::numeric))))
```

**Scope:** the constraint covers only the three new columns. `entered_value` is deliberately
outside it — during expand both may legitimately hold a value, and including it would make the
expand phase unwritable.

**`<= 1`, not `= 1` (errata E12).** `spend-distribution.service.ts` creates a `PlanMechanicValue`
row with no entered value, and "row exists, nothing entered" is a legitimate state. `= 1` would
force a caller to invent a zero — the silent-zero prohibition (CLAUDE.md §2.5) expressed at
schema level, so `NULL` and `0` stay distinguishable. ADR Karar 4 said "exactly one"; E12 records
that the ADR text was too strict rather than letting code and ADR diverge silently.

### Migration hygiene

Catalogue probes are schema-qualified (`table_schema` / `nspname` predicates). This database
hosts both `main` (CTPM) and `public` (TTM), and an unqualified probe is the defect class that
made `UQ_ledger_entries_reversal_per_tenant` silently never apply.

`MIGRATION_SEQUENCE`: **1796 used** (expand), **1797 allocated** for C2 (contract).

### Sibling columns — no-split proof re-verified

**STOP #3 not triggered.** `0013` proved these do not split; re-measured against the current tree:

* `minValue`/`maxValue`: **50 references** (0013 counted 52 — the delta is grep shape, not tree
  drift). None is an arithmetic operand: every hit is a type declaration, a passthrough
  assignment, or a null check (`spend-validation.service.ts:142`).
* `defaultValue`/`stepIncrement`: **no consumer of the mechanic columns**. The only textual hits
  are an unrelated `getEnvVar(key, defaultValue)` parameter in `typeorm.config.ts`.

`agreements.mechanic_value` is frozen (A4 / K13, T-072) — untouched here.

### What C1 did NOT do

The three new entity columns are typed **`number`**, not `MoneyMinor`/`RateMicro`. This is
deliberate (K9): converting an existing Domain A entity's representation is ratchet work, not F2.

**F2 has not applied branded types to this entity and could not have.** Stated plainly so this
commit is not read as "the numeric contract is now enforced on plan_mechanic_values" — it is not.
The columns carry the right *semantics*; they do not yet carry the right *types*.

---

## C2a — JSONB semantics (J1) · `43301b5`

`buildMechanicValues` returns a **discriminated union** instead of a raw number map.
`plan_fus.tactics` keeps its shape: a per-key scale constraint cannot be expressed on a `jsonb`
column, so changing it (J2) adds no DB guarantee while breaking the API contract.

**Single derivation point:** `src/common/numeric/mechanic-input.ts#toMechanicInput`. Scale comes
from `mechanic_type` — `PERCENT → rate`, `AMOUNT_PER_UNIT → unitAmount`, `AMOUNT → totalAmount`.
An unrecognised type throws rather than defaulting.

**Discriminator choice turned out load-bearing.** `category` and `input_type` are **nullable**;
`mechanic_type` is **NOT NULL**. Had a nullable field been chosen, the five test failures below
would have been a product question instead of a fixture fix.

**Silent acceptance removed.** `if (val != null)` accepted any key; the value then sat in the map
**unread**, because the calculation loops iterate over *mechanics*, not over tactic keys. A typo
produced no spend and no message. The error now names the code, the FU, and the known codes.

**Behaviour inventory, produced before writing code:** no seed/fixture/e2e writes an unknown code
(STOP #4 clear); no K2 case, since an unknown code has no effect today and `plan_fus` holds 0 rows.

**Correction recorded:** `mechanicType` **is** read today (`spend-validation:259,:274`,
`spend-distribution:425`, `agreement.service`). C2a is not its first reader. The mock gap went
unnoticed because every existing reader *compares* (`=== 'PERCENT'`) and `undefined === 'PERCENT'`
quietly yields false — a missing discriminator selects the other branch instead of failing. That
is the **silent-default** family (§2.5), not the unread-field family, and it may already be
choosing wrong branches today.

## C2b — Reader conversion and column drop

### Scope correction

Specified as "one reader + `DROP COLUMN`". Measured: **18 reads across 4 files**.

| File | Reads | Commit |
|---|---|---|
| `spend-validation.service.ts` | 7 | C2b-2 `88493eb` |
| `spend-calculation.service.ts` | 6 | C2b-1 `bafafa3` |
| `spend-distribution.service.ts` | 4 (not 3 — `:239` was missed) | C2b-0 `42a59a6` / C2b-3 `3336c38` |
| `approval-workflow.service.ts` | 1 | C2b-3 |
| `plan-mechanic-value.entity.spec.ts` | 2 — **absent from the inventory entirely** | C2b-4 `95cb6e6` |

### Ratchet gate — four readings

| Commit | `--ratchet` | output | `plan.service.ts` | other touched |
|---|---|---|---|---|
| C2b-1 | `exit=0` | empty | **36** | spend-calculation 9 (9) |
| C2b-2 | `exit=0` | empty | **36** | spend-validation 10 (10) |
| C2b-3 | `exit=0` | empty | **36** | spend-distribution 10 (10) · approval-workflow 8 (8) |
| C2b-4 | `exit=0` | empty | **36** | — |

No file moved at any step. Nothing needed reverting.

### Single derivation — and one reader that needed less

The 18 reads were **not one kind**. Classifying before converting was the difference between
porting three semantics and silently merging them:

| Read shape | Helper | Why |
|---|---|---|
| null check IS the semantics (empty entry skipped, not validated as 0) | `readEnteredRaw` | `?? 0` would validate a value never entered |
| `null`, `undefined` **and** `0` treated as three distinct states (`spend-validation:212`) | `readEnteredRaw` | `?? 0` erases two of the three |
| truthiness only (0 and "not entered" both skip) | `readEnteredValue` | `?? 0` preserves behaviour exactly |
| "was anything entered?", scale-independent (`approval-workflow`) | `hasEnteredValue` | see below |

**The approval-path reader legitimately needs *less* than the derivation point.** It asks only
whether an entry exists, never which scale — and the approval query loads
`planFus.planMechanicValues` **without** the `mechanic` relation (`plan.repository.ts:70`), so
`pmv.mechanic` is undefined there. Forcing it through `enteredColumnFor` would have meant adding
a join to the approval query: a change beyond representation, on the approval path. `hasEnteredValue`
is sound because the `CHECK` (errata E12) guarantees at most one column is non-null, so "any of
the three is non-null" is exactly equivalent to the old `entered_value != null`.
Needing less than the derivation point is not the same as bypassing it — the helper lives at the
shared point with that reasoning in its doc.

No approval-path behaviour changed: same predicate, same result, different source column.

### C2b-4 proof

```
remove enteredValue from the entity
  tsc run 1 → exit=2, TWO references:
      plan-mechanic-value.entity.spec.ts:26, :27
  (fixed — the test now covers all three semantic columns — not worked around)
  tsc run 2 → exit=0
```

Running `tsc` *before* the removal would have been green whether 18 readers remained or 0. The
ordering is the proof; §2.7 records the general form.

Verified against the real catalogue, not the `migrations` table:

```sql
SELECT column_name FROM information_schema.columns
 WHERE table_schema='main' AND table_name='plan_mechanic_values'
   AND column_name LIKE 'entered%';
-- entered_rate_pct · entered_total_amount · entered_unit_amount
-- entered_value ABSENT
```

```
guards exit=0 · tsc exit=0 · unit 648/648 exit=0
e2e ×3 consecutive, no reset: 239/239 each, exit 0 each, T-047 PASS each
```

### Calibration — five data points, one direction

| Estimate | Measured | Off by |
|---|---|---|
| `0010`: Domain A = 54 files | 86 | +59% |
| F0: 0010's 130 money-context `Number(` | 163 findings / 24 files | different method, same direction |
| `0013`: C2 ≈ 3 backend files | 8 call sites | ~2.7× |
| C2b spec: 1 reader | 18 | **18×** |
| My own C2b-3 inventory: 3 + 1 | 4 + 1, **plus 2 invisible** | undercounted twice |

The pattern is **not specific to design documents**. It holds for task specs and for inventories
I produced myself, minutes before relying on them. Any unmeasured scope figure runs low.

Operationally: the last two rows were caught by *mechanisms*, not by care — removing the property
and letting the compiler answer. That is the reason the proof ordering matters more than the
counting.

## E2 closure

| Layer | Status |
|---|---|
| Column | **closed** — three semantic columns, `CHECK`, `entered_value` dropped (C1, C2b-4) |
| Read path | **closed** — discriminated union, single derivation point (C2a, C2b-1..3) |
| Write path | **NOT closed** — `PATCH .../tactics` still accepts any scale. That is **C3**. |

Explicitly **not** closed here, each with its task:
`T-074` (four hardcoded rate thresholds) · `T-075` (A10 canonical choice **and**, per errata E14,
the K14 contract test that does not exist) · `T-077` / `T-078` (representation and the `|| 0`
collapse) · the `=== 'PERCENT'` comparison sites found in C2a.

## What this does not protect

1. **Wrong scale can still be written.** J1's accepted residual risk: the JSONB takes any number
   for any key. C3 compensates at the write boundary; until then the read path interprets whatever
   is there.
2. **The `?? 0` collapse survives** in the arithmetic path (`rawOf`, four unwrap sites). The union
   carries the distinction; the unwrap discards it. T-078.
3. **Representation is unchanged.** These columns are `number`, not `MoneyMinor`/`RateMicro`.
   F2 delivered the *distinction*, not the *exactness*. K9 keeps the conversion with the ratchet.
4. **K14 is unbacked** (errata E14) — the ADR describes a lock that does not exist.

## Open questions

1. Should `plan.repository.ts:70` load `planMechanicValues.mechanic`? Not needed today thanks to
   `hasEnteredValue`, but any future approval-path read of a scaled value would need it.
2. The `=== 'PERCENT'` comparison sites silently select a branch when the discriminator is
   missing. `mechanic_type` is NOT NULL so it cannot be missing in the DB — but the mocks proved
   it can be missing in tests. Is that worth a guard?

## C3 — Write validation · pending
