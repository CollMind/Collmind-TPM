# Numeric Contract: Columns, JSONB and Write Validation (ADR 0007 F2)

**Date:** 2026-08-04 · **Branch:** `feat/numeric-contract-columns` · **Base:** F1 `70eaa4d`

| Commit | Content | SHA | Status |
|---|---|---|---|
| **C1** | Column split — expand phase | `ce1ca97` | **done** |
| **C2** | JSONB semantics (J1) + `DROP COLUMN` (contract phase) | — | pending |
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

### C2 / C3 — pending

C1's gate was easy because `plan.service.ts` never appeared in the diff. **C2 is where the
criterion is actually tested** — `plan.service.ts` is one of the two callers whose signature
changes.

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

## C2 — JSONB semantics (J1) · pending

## C3 — Write validation · pending

## E2 closure · pending

## What this does not protect · pending

## Open questions · pending
