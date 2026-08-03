# SYSTEM_INVARIANTS.md — v0.2.2 (DRAFT)

> **Status:** Draft for review. Not yet normative.
> **Subject:** Collmind-TPM (`collmind.backend`) @ `876010f` + guards Phase 2 + uncommitted T-057 delta
> **Count:** 33 invariants — **16 HOLDS · 10 VIOLATED · 7 BLOCKED** · 14 open decisions
> **Derived from:** `docs/verification/CTPM_BASELINE_AND_PORT_AUDIT.md` (2026-08-03)
> **Supersedes for invariant purposes:** nothing yet. Coexists with `.cursor/rules.md`
> until §Adoption is executed.

---

## 1. What this document is

A system invariant is a statement that must be true of the system at all times, expressed
so that a machine can check it. This document is the single normative home for such
statements.

**Rules of this layer:**

1. An invariant is written **once**, here. Other documents reference its ID; they do not
   restate the rule.
2. Every invariant carries a **guard**. An invariant without a guard is an aspiration and
   is marked as such.
3. Where an invariant cannot yet be stated because a product decision is missing, it is
   recorded as `BLOCKED` with the decision it waits on. Blocked invariants are not
   silently omitted.
4. Code is ground truth for *what is*. This document is ground truth for *what must be*.
   Divergence between them is a defect in one or the other — never an ambiguity.

---

## 2. How to read an entry

```
### INV-X-000 — <single testable sentence>
Status:   HOLDS | VIOLATED | BLOCKED
Guard:    DB | GUARD SCRIPT | TEST | LINT | NONE
Evidence: file:line or catalogue query
Source:   audit candidate #n · K-nn · ADR-nnnn
```

**Status**
| Value | Meaning |
|---|---|
| `HOLDS` | True in the codebase today, verified with evidence |
| `VIOLATED` | Should be true; is not. Carries a remediation note |
| `BLOCKED` | Cannot be stated until an open decision is made |

**Guard** — how a breach is detected. `NONE` means the invariant is currently protected
only by developer discipline, which is not protection.

| Guard | Mechanism |
|---|---|
| `DB` | Constraint, unique index, trigger, or revoked grant |
| `GUARD SCRIPT` | `scripts/guards/*.sh`, run by `npm run guards`. Blocking (`exit 1`) since Phase 2 |
| `TEST` | Unit / integration / e2e assertion |
| `LINT` | ESLint rule, `no-restricted-syntax`, custom AST rule |
| `NONE` | Unprotected |

**Guard strength order:** `DB` > `GUARD SCRIPT` > `LINT` > `TEST` > `NONE`. Prefer the
strongest guard the invariant admits. A rule that can be expressed as a DB constraint should
not be left to a test.

**Why `GUARD SCRIPT` and not `LINT`:** ESLint operates on the TypeScript AST. Several
invariants here are properties of **SQL text inside string literals** — a schema predicate in
a catalogue query, a direction-aware `SUM`, an `ORDER BY` column. To ESLint that is an opaque
string. The guard scripts read the string contents, so they are a different mechanism, not a
weaker spelling of the same one.

**There is no `CI` guard type.** This project has no pipeline (`CLAUDE.md` §5: manual
promote, no pipeline). Anywhere an invariant previously targeted `CI`, the enforcement path
is instead the three places a guard is actually invoked:

1. `npm run guards` — blocking by default (`GUARD_MODE=block`; `exit 1` on a finding,
   `exit 2` on an allowlist parse error)
2. `code-reviewer` agent checklist — a red guard run is a 🔴 Blocker
3. `BACKLOG.md` / `CLAUDE.md` Done checklist — `done` is not writable while guards are red

Invariants whose enforcement genuinely needs a scheduled job (nightly reconciliation,
fresh-migrate schema diff) keep that as a stated *target* and remain `NONE` until such a job
exists. Naming a pipeline that does not exist would be the same silent-failure class this
document is about.

---

## 3. Ledger — `INV-L`

The ledger is the system's financial system of record. These are the strongest invariants
in the product and most of them already hold.

### INV-L-001 — No statement may modify `ledger_entries.amount`, `entry_direction`, `budget_envelope_id`, or `period_month` after insert.
- **Status:** HOLDS
- **Guard:** NONE → target `DB` (BEFORE UPDATE trigger rejecting changes to these columns)
- **Evidence:** exactly one mutating statement exists in the codebase; it sets `is_reversed`
- **Source:** audit candidate #1

### INV-L-002 — The only permitted mutation of an existing ledger row is setting `is_reversed` from `false` to `true`.
- **Status:** HOLDS
- **Guard:** NONE → target `DB` (same trigger as INV-L-001, with the `is_reversed` exception)
- **Source:** audit candidate #2

### INV-L-003 — No ledger row may ever have a non-null `deleted_at`.
- **Status:** 🔴 VIOLATED (structurally, not in practice)
- **Guard:** NONE → target `DB` (`CHECK (deleted_at IS NULL)`, or drop the column)
- **Evidence:** `@DeleteDateColumn` active via `BaseEntity` (`base.entity.ts:23-24`); ~20 sibling
  entities call `softRemove`; no row currently affected
- **Remediation:** blocked on **D-04**. A single future `softRemove` silently removes money
  from every balance.
- **Source:** audit candidate #3, violation #3

### INV-L-004 — Every reversal is a new row with the opposite `entry_direction`, an equal absolute `amount`, and `reverses_entry_id` pointing at the original.
- **Status:** HOLDS
- **Guard:** TEST → add `DB` (FK on `reverses_entry_id`; **currently missing on `main`** — see INV-M-001)
- **Source:** audit candidate #4

### INV-L-005 — At most one non-deleted reversal row may exist per `(tenant_id, reverses_entry_id)`.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `DB` (`UQ_ledger_entries_reversal_per_tenant`)
- **Evidence:** the unique index is **absent from `main.ledger_entries`** (verified live). Only
  the read-then-write check at `reversal.service.ts:137-144` stands.
- **Impact:** two concurrent reversals can both insert a CREDIT → understated spend,
  overstated available budget, **silent**
- **Remediation:** ⏳ **fix proven, environment not yet carrying it.** The catalogue guards in
  `1777000000000-LedgerReversalSupport.ts` are now schema-qualified (see INV-M-002). Verified
  2026-08-03 on a throwaway database (`collmind_tpm_guardtest`, all 54 migrations from empty,
  then dropped): `UQ_ledger_entries_reversal_per_tenant` and `FK_ledger_entries_reverses_entry`
  both land on **`main`**. So any newly built environment is protected.
- **Why still VIOLATED:** the working database `collmind_tpm` is unchanged. `main.migrations`
  already records this migration as run, so `migration:run` will not re-execute it, and a live
  check still returns `public` only. Until the constraint exists on the database actually in
  use, the sole protection remains the read-then-write check at `reversal.service.ts:137-144`
  — an invariant is not held by a fix that has not reached the environment.
- **Flips to HOLDS / Guard `DB`** after a `db:reset` + `seed` on `collmind_tpm`, to be done
  once T-057 is committed (its test data depends on current DB state).
- **Source:** audit candidate #5, violation #5

### INV-L-006 — Every ledger insert carries a non-empty `idempotency_key` unique within its tenant.
- **Status:** HOLDS
- **Guard:** DB ✅
- **Source:** audit candidate #6

### INV-L-007 — Consumed spend is computed as `Σ DEBIT − Σ CREDIT` and never as a plain `SUM(amount)`.
- **Status:** HOLDS
- **Guard:** TEST + **GUARD SCRIPT** ✅ (`scripts/guards/ledger-direction.sh` — a `SUM(` over
  `ledger_entries.amount` without a direction `CASE` is a finding)
- **Evidence:** 0 findings. This guard's scope is content-derived, not path-derived — it greps
  all of `src` for `ledger_entries` / `LedgerEntry` / `ledger.` and scans every file that
  matches, so it is genuinely codebase-wide (unlike INV-N-001's guard, see there).
- **Rationale:** any future direction-unaware aggregation counts reversals as spend. The trap
  is invisible to anyone porting from TTM, where the direction axis does not exist.
- **Source:** audit candidate #7, hazard H4, Tier-1 risk #3

### INV-L-008 — Reversing an already-reversed entry is rejected with `ALREADY_REVERSED`.
- **Status:** HOLDS
- **Guard:** TEST (application-level; DB guard is INV-L-005)
- **Source:** audit candidate #21

### INV-L-009 — Every idempotency key conforms to a registered format.
- **Status:** BLOCKED → **D-13**
- **Guard:** target `LINT` + `TEST`
- **Note:** three literal formats are in use (`LEDGER|AGREEMENT|…`, `LEDGER|ON_INVOICE|…`,
  `REVERSAL|LEDGER|…`), defined only at their call sites. Key formats are a contract:
  changing one silently breaks idempotency for all historical rows.
- **Source:** spec gap 24

---

## 4. Budget & CAP — `INV-B`

The most fragmented area of the system. Five spec gaps and three incompatible behaviours
across the estate all concern CAP.

### INV-B-001 — Every committed `agreement_transactions` row has exactly one corresponding ledger DEBIT.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `CI` (nightly reconciliation job) + `TEST`
- **Evidence:** `agreement-transaction.service.ts:148-170` — `if (envelope) { … }` with no
  `else`. Envelope-not-found ⇒ transaction committed, no ledger entry, `200 OK`.
- **Impact:** budget reports understate spend by exactly this amount while the CAP check —
  which sums `agreement_transactions` — still counts it. **The two subsystems silently
  disagree.** No error, no log, no test.
- **Remediation:** blocked on **D-08**. The T-057 delta makes the *ambiguous* case loud but
  leaves the *not-found* case silent.
- **Source:** audit candidate #8, violation #8, Tier-1 risk #1

### INV-B-002 — Spend against an agreement never exceeds its CAP.
- **Status:** 🔴 VIOLATED (asymmetrically)
- **Guard:** TEST (off-invoice only)
- **Evidence:** holds for off-invoice; ON_INVOICE bypasses CAP entirely
  (`on-invoice.service.ts:327-450`)
- **Remediation:** blocked on **D-01**, **D-02**, **D-03**
- **Source:** audit candidate #11, violation #11

### INV-B-003 — An on-invoice ledger entry is always attributed to an envelope whose spend type is `ON_INVOICE`.
- **Status:** 🔴 VIOLATED at HEAD · HOLDS with the uncommitted T-057 delta
- **Guard:** TEST (added by T-057's untracked spec)
- **Evidence:** `findEnvelopeByDimensions` called without a spend type
  (`on-invoice.service.ts:437`) while the ledger row hardcodes `ON_INVOICE`
- **Action:** none beyond committing T-057
- **Source:** audit candidate #20, violation #20

### INV-B-004 — CAP and spend reporting derive from the same source, and that source is the ledger.
- **Status:** BLOCKED → **D-02**
- **Guard:** target `CI` (reconciliation) + `LINT`
- **Note:** today CAP sums `agreement_transactions`; reporting sums `ledger_entries`. Two
  sources of truth for "spent" is the root cause of INV-B-001's silence, not a side effect.
- **Source:** spec gap 12

### INV-B-005 — No realized economic event may go unrecorded because of a budget limit.
- **Status:** BLOCKED → **D-01**
- **Guard:** target `TEST` (property-based) + `CI`
- **Statement when unblocked:**
  `Σ(recognized_on_invoice_discount) ≡ Σ(claimed) + Σ(OVER_CAP) + Σ(NON_TPM)`
- **Rationale:** an on-invoice discount has already been granted on the customer's invoice.
  Refusing it does not unspend the money; it only removes it from the books. CAP is
  *preventive* for discretionary (off-invoice) spend and *detective* for realized
  (on-invoice) spend. These are different mechanisms and must not share one policy.
- **Source:** D1 discussion; audit open question #3

### INV-B-006 — Every path that fails to resolve a budget envelope behaves according to one declared policy.
- **Status:** BLOCKED → **D-08**
- **Guard:** target `TEST` per path
- **Note:** today the system gives two answers — silent skip (off-invoice) and a persisted
  `ERROR` row (on-invoice). One system, two policies.
- **Source:** spec gap 13

### INV-B-007 — Envelope resolution uses one dimension set across all paths.
- **Status:** BLOCKED → **D-09**
- **Guard:** target `LINT` (single resolution function) + `TEST`
- **Note:** off-invoice resolves on `(channel, period)`; on-invoice adds category. The same
  logical budget can resolve to different envelopes depending on which path reaches it.
- **Source:** spec gap 14, B2 finding #3

---

## 5. Recognition & Actuals — `INV-R`

Ingestion is solid and well-guarded. Recognition does not exist; its invariants are stated
here so they are designed in rather than retrofitted.

### INV-R-001 — Every `on_invoice_entries` row in a `COMPLETED` batch is either `POSTED` with a corresponding ledger DEBIT, or `ERROR` with a non-empty `validation_errors` array.
- **Status:** HOLDS
- **Guard:** TEST → add `CI` (reconciliation)
- **Source:** audit candidate #9

### INV-R-002 — The sum of ledger DEBITs created from an on-invoice batch equals the sum of `discount` over that batch's `POSTED` entries.
- **Status:** HOLDS
- **Guard:** TEST → add `CI`
- **Source:** audit candidate #10

### INV-R-003 — At most one `sales_actual_batches` row is `ACTIVE` per `(tenant, fiscal_period, cpl, category, channel)`.
- **Status:** HOLDS
- **Guard:** DB ✅ (partial unique index)
- **Tenant coupling:** this encodes K44 ("last upload wins") in the schema. See **D-14**.
- **Source:** audit candidate #14

### INV-R-004 — A replaced sales-actuals batch is never deleted; it transitions to `REPLACED` with `replaced_by_batch_id` and `replaced_at` set.
- **Status:** HOLDS
- **Guard:** TEST → add `DB` (`CHECK`: `status='REPLACED'` requires both columns non-null)
- **Source:** audit candidate #15

### INV-R-005 — `sales_actuals.discount_amount` never contributes to any ledger entry, budget reservation, or spend figure.
- **Status:** HOLDS
- **Guard:** TEST (module boundary spec) ✅ — the strongest existing guard pattern in the codebase
- **⚠️ Note:** any recognition design must **explicitly** overturn or reconcile with this. The
  quarantine exists for a documented double-counting reason (T-003/T-017). Recognition that
  reads `discount_amount` without addressing that history reintroduces the bug.
- **Source:** audit candidate #16, spec gap 6

### INV-R-006 — A sales-actuals row is rejected if `net_amount > gross_amount`.
- **Status:** HOLDS
- **Guard:** TEST → add `DB` (`CHECK`)
- **Source:** audit candidate #17

### INV-R-007 — Recognized on-invoice spend is conserved: `Σ(claims) + Σ(NON_TPM) = actual_discount`, for every scope, always.
- **Status:** BLOCKED → **D-07**
- **Guard:** target `TEST` (property-based, the primary use case for it)
- **Proposed rule:**
  ```
  attributable = min(actual_discount, expected_total)
  per tactic  = attributable × (expected_i / expected_total)
  actual > expected → NON_TPM = actual − expected
  actual < expected → UNDER   = expected − actual   (informational; no claim)
  ```
- **Rationale:** the two extant Addendum V2 versions specify incompatible algorithms.
  Proportional-of-actual overpays whenever a non-TPM discount exists; expected-based books
  spend that was never granted when the actual falls short. The rule above uses `expected`
  as a ceiling and the rate ratio as a distribution key — two different jobs that both
  documents conflated.
- **Source:** D3 discussion; spec gaps 4, 5

### INV-R-008 — Allocation is deterministic: identical inputs under an identical policy version produce an identical distribution to the cent.
- **Status:** BLOCKED → **D-07**, **D-05**
- **Guard:** target `TEST` (property-based) + `CI`
- **Must specify:** rounding mode, residual-cent assignment, tie-breaking order (business
  key — never a generated identifier, cf. INV-N-001)
- **Source:** spec gap 15

---

## 6. Tenancy & Access — `INV-T`

### INV-T-001 — No financial query executes without a `tenant_id` predicate.
- **Status:** HOLDS
- **Guard:** TEST → add `LINT` (repository-layer rule)
- **Source:** audit candidate #12

### INV-T-002 — A user may not approve a request they submitted.
- **Status:** HOLDS
- **Guard:** TEST ✅
- **Note:** implemented as a general submitter≠approver rule, not an actuals-specific one —
  therefore **product policy, not tenant policy**. K45 is satisfied as a consequence.
- **Source:** audit candidate #13; K45

### INV-T-003 — Tenant isolation is enforced by the database, not only by application predicates.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `DB` (RLS) + `CI` (policy-presence check)
- **Evidence:** 0 RLS policies, 0 tables with `rowsecurity`
- **Remediation:** blocked on **D-11**. Greenfield in both codebases. This is the gate for
  the second customer, not a hardening nicety.
- **Source:** audit candidate #22, violation #22

---

## 7. Schema & Migration integrity — `INV-M`

This section exists because of a defect class discovered in the audit. It has no
counterpart in either codebase's existing documentation.

### INV-M-001 — Every migration recorded in `main.migrations` has had all of its DDL effects applied to the `main` schema.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `CI` (schema diff: freshly-migrated database vs current)
- **Evidence:** `LedgerReversalSupport1777000000000` is recorded in `main.migrations`; its
  self-FK and `UQ_ledger_entries_reversal_per_tenant` exist **only on `public.ledger_entries`**
  — TTM's table
- **Impact:** the migration ledger reports success for DDL that was never applied. The
  release process trusts that report.
- **Remediation:** ⏳ **cause removed and proven, environment not yet carrying it.** The
  unqualified catalogue guards that produced the silent no-op are fixed (INV-M-002) and
  `migration-schema.sh` blocks the class from recurring. A from-empty migrate on a throwaway
  database applied all 54 migrations with every effect on `main` (see INV-L-005), so the
  invariant holds for any newly built environment. It does not hold for `collmind_tpm`, whose
  recorded history still contains the migration whose DDL never landed. Closes with the same
  `db:reset` as INV-L-005.
- **Source:** audit candidate #19, violation #19, hazard H2

### INV-M-002 — Every catalogue existence guard in a migration is schema-qualified.
- **Status:** HOLDS *(v0.1 recorded a breach; scope is now measured and closed — see §12)*
- **Guard:** **GUARD SCRIPT** ✅ (`scripts/guards/migration-schema.sh`)
- **Scope, measured:** 54 migrations, 9 of which contain catalogue queries. 5 unqualified
  queries in 2 files: `1777000000000-LedgerReversalSupport.ts` (2) and
  `1779000000000-CreateUserScopes.ts` (3). All 5 repaired in place — legitimate here because
  no deployed environment has ever run them, and left as-is every new environment would be
  built with the same missing constraints.
- **Guard method:** the guard evaluates each `queryRunner.query()` template literal as one
  unit. Phase 1 used a ±10-line window, which **masked** violations whenever a qualified
  query sat near an unqualified one; a fixture reproduced the masking and the block-based
  guard catches what the window missed. Schema-safe forms (`'main.x'::regclass`,
  `to_regclass('main.x')`, `::regnamespace`) are recognised by the guard itself rather than
  being silenced through the allowlist.
- **Residual limit:** two catalogue queries inside a *single* template literal are judged as
  one block; if one is qualified the other could still hide. **One such block exists today** —
  `1795000000000-AddSpendTypeToBudgetDimensions.ts:148-160`, two `information_schema.columns`
  queries in one literal. It is not masking anything, because both carry `table_schema = 'main'`;
  but an unqualified third query added to that block would go unreported.
- **How the guard reads a literal — no heuristic:** `scripts/guards/migration-schema.awk` tracks
  literal-in/out state character by character. A `//` counts as a comment only when the scanner is
  *outside* a literal; quoted strings are skipped so backticks inside them do not count; an
  unterminated literal at EOF is reported rather than passed over.
  Two earlier heuristics both produced **silent false negatives** and were replaced, each caught by
  a code-review round: (1) a ±10-line window, where a neighbouring qualified query masked an
  unqualified one; (2) backtick parity with comment pre-stripping, where a SQL line beginning with
  `*` (`SELECT` / newline / `  * FROM …`) was mistaken for a comment, its backtick removed, and the
  parity shifted. Fixtures for both, plus a mid-line-comment false-positive case, are the
  regression evidence.
- **Source:** spec gap 21, determinism risk 7; T-064 Faz 2

### INV-M-003 — One database hosts exactly one product's schema.
- **Status:** 🔴 VIOLATED (environment) — **detected and allowlisted**, not fixed
- **Guard:** **GUARD SCRIPT** (`scripts/guards/schema-isolation.sh` — detects the condition;
  it cannot repair it). The finding is allowlisted under key `ENV` with a written rationale,
  so `npm run guards` is green while the environment fact stays recorded rather than
  forgotten. Remediation tracked as **T-067**.
- **Evidence:** `collmind-tpm-postgres:5434` hosts both `main` (Collmind-TPM) and `public`
  (TTM), **including two separate `migrations` tables** (54 rows / 44 rows)
- **Impact:** root cause of INV-M-001. Also: an unqualified `SELECT name FROM migrations`
  resolves by `search_path` and can report the wrong product's history — this misled the
  audit's own first pass.
- **Source:** environment notes

---

## 8. Numeric & Determinism — `INV-N`

### INV-N-001 — Batch-ordered financial processing iterates in ascending source row number, never in an order derived from a generated identifier.
- **Status:** HOLDS
- **Guard:** TEST + **GUARD SCRIPT** (`scripts/guards/financial-ordering.sh` — `ORDER BY`
  on a generated identifier in a financial path is a finding)
- **Evidence:** 0 findings across the **148 of 239** production files under `src/modules` matching
  the guard's path filter (specs and e2e excluded — this invariant is about the production
  ordering path, and a blocking guard over fixture code would force allowlist entries).
  Phase 1 scanned only 132 files and left `finance-reporting`, `spend-calculation` and
  `kpi-engine` entirely outside, so its "across the codebase" phrasing claimed more than was
  measured. Scope widened and re-measured; still 0.
- **⚠️ Guard blind spot:** only *literal* sort keys are visible. A key built at runtime —
  `` query.orderBy(sortField, …) `` where ``sortField = `plan.${pagination.sortBy}` `` at
  `finance-reporting.service.ts:487-492` — is not evaluated by the guard at all. That call site
  also lacks an `@IsIn(...)` whitelist on `sortBy` (`dto/report-filters.dto.ts:97-100`), and
  TypeORM does not parameterise `orderBy`. Tracked as **T-066**; this invariant is *not* fully
  guarded until it is closed.
- **Note:** a genuine improvement over TTM, whose financial ordering was by `randomUUID()`.
  Worth protecting explicitly so a port does not reintroduce it.
- **Source:** audit candidate #18

### INV-N-002 — Monetary arithmetic is exact; no monetary value is represented as a floating-point number in application code.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `LINT` (ban `parseFloat`/`Number()` on money fields) + `TEST`
- **Evidence:** all amounts are `number`. `DecimalTransformer` exists but is **not** applied to
  `ledger_entries.amount`. `parseFloat` at `ledger.repository.ts:123,147`; `Number()` at
  `agreement-transaction.service.ts:102` and throughout `budget.service.ts`.
- **Impact:** the CAP boundary (`currentTotal + dto.amount > cap`) can flip on representation
  error at exactly the cap. `Object.entries()` accumulation
  (`spend-calculation.service.ts:539,664,824,832`) is order-dependent in floating point.
- **Remediation:** blocked on **D-05**
- **Source:** determinism risks 1, 2, 3; spec gap 15

### INV-N-003 — Fiscal period derivation is timezone-independent.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `TEST` (assert under ≥2 `TZ` values) + `LINT`
- **Evidence:** `agreement-transaction.service.ts:108-122` — 3-level fallback ending in
  `getFullYear()`/`getMonth()`, which are local-timezone operations
- **Impact:** the same invoice lands in different fiscal months on servers in different
  timezones
- **Remediation:** blocked on **D-12**
- **Source:** determinism risk 6, spec gap 22

---

## 9. Open decisions blocking invariants

Each blocks at least one invariant. Ordered by number of invariants unblocked, then by
whether a silent wrong number depends on it.

| ID | Decision | Blocks | Note |
|---|---|---|---|
| **D-01** | CAP exceedance behaviour | INV-B-002, INV-B-005 | Three variants exist: TTM skip · K43-R clamp · CTPM reject. **Proposed:** split by controllability — off-invoice clamps (K43-R), on-invoice always posts and records `OVER_CAP` |
| **D-02** | CAP source of truth | INV-B-002, INV-B-004 | **Proposed:** the ledger. It is append-only, direction-aware, and already the reporting source |
| **D-03** | CAP scope and optionality | INV-B-002 | K29 says tactic-level, code is agreement-level. K31 says optional, `cap_total_amount` is `NOT NULL` |
| **D-04** | Append-only enforcement level | INV-L-001…003 | DB guarantee or application convention? If DB: `deleted_at` arguably should not exist on this table |
| **D-05** | Numeric contract | INV-N-002, INV-R-008 | Integer minor units · decimal library · SQL-side arithmetic. Plus rounding mode |
| **D-06** | Settlement base | — (prerequisite for INV-R-007) | Absent entirely. Addendum V2 §5.2 specifies three types frozen per agreement; `LIST_PRICE × VOLUME` is uncomputable because actuals carry no volume |
| **D-07** | Recognition allocation rule | INV-R-007, INV-R-008 | Two Addendum V2 versions specify incompatible algorithms. Proposal in INV-R-007 |
| **D-08** | Envelope-not-found policy | INV-B-001, INV-B-006 | Reject · auto-provision · catch-all · persisted exception. **Fixing this also closes Tier-1 risk #1** — same `if` |
| **D-09** | Envelope resolution dimensions | INV-B-007 | One dimension set for both paths |
| **D-10** | Claim model | INV-R-007 | First-class entity (TTM, Addendum V2) or `agreement_transactions` + ledger? |
| **D-11** | RLS requirement | INV-T-003 | Second-customer gate |
| **D-12** | Fiscal period timezone | INV-N-003 | UTC vs local, explicitly |
| **D-13** | Idempotency key formats | INV-L-009 | Three undocumented formats in use |
| **D-14** | Actuals replace semantics as tenant policy | INV-R-003 | K44 is schema-encoded. Cost to make configurable: **high** — relaxing a uniqueness constraint that current correctness depends on |

---

## 10. Guard backlog

Ranked by risk closed per unit of effort.

| # | Guard | Type | Closes | Effort | State |
|---|---|---|---|---|---|
| 1 | Repair migration for `UQ_ledger_entries_reversal_per_tenant` + FK, schema-qualified | DB | INV-L-005 | S | ✅ done |
| 2 | Environment assertion: one product schema per database | GUARD SCRIPT | INV-M-003 | S | ✅ done (detects; allowlisted, T-067) |
| 3 | Schema-qualification guard for migration catalogue queries | GUARD SCRIPT | INV-M-002 | S | ✅ done |
| 4 | `SUM(amount)` direction-awareness guard | GUARD SCRIPT | INV-L-007 | S | ✅ done |
| 5 | Financial ordering guard (no `ORDER BY` on a generated id) | GUARD SCRIPT | INV-N-001 | S | ✅ done |
| 6 | Ledger immutability trigger | DB | INV-L-001, INV-L-002 | M | open |
| 7 | Schema-diff step (fresh migrate vs current) | *needs a scheduled job* | INV-M-001 | M | open |
| 8 | Nightly tx↔ledger reconciliation job | *needs a scheduled job* | INV-B-001, INV-B-004 | M | open |
| 9 | Money-as-float lint + `DecimalTransformer` rollout | LINT | INV-N-002 | L | open |
| 10 | RLS policies + policy-presence check | DB | INV-T-003 | L | open |

Items 1–5 were the first sprint of this layer and are now complete: guards 2–5 ship as
`scripts/guards/*.sh` and block by default; guard 1 is the repaired migration. Together they
close three silent-wrong-number risks.

Items 7 and 8 are deliberately **not** typed `CI`. No pipeline exists to host them, and
labelling them `CI` would assert protection that is not there.

---

## 11. Adoption

This document becomes normative when:

1. §9 decisions D-01, D-02, D-04, D-05, D-08 are recorded as ADRs in
   `docs/decisions/` (these five block the most invariants and all touch money).
2. ~~Guard backlog items 1–5 are implemented.~~ ✅ **done** (Phase 2, T-064)
3. `CLAUDE.md` §2 stops restating domain rules and references invariant IDs instead.
4. Every agent definition in `.claude/agents/` references this file and
   `docs/decisions/` as binding sources.

**Registry note:** `DECISION_REGISTRY.md` (K1–K45) currently lives in **TTM**, the frozen
repo. The product's decision registry cannot live in the legacy codebase. It should be
split — product decisions into Collmind-TPM's `docs/decisions/`, Wella-specific choices into
a tenant profile — and TTM's copy marked historical.

---

## 12. Changelog

| Version | Date | Change |
|---|---|---|
| 0.1 | 2026-08-03 | Initial draft from CTPM baseline audit. 14 open decisions. Header count of "25 invariants: 15 HOLDS · 10 VIOLATED/BLOCKED" was an estimate and is corrected in 0.2 by counting the entries. |
| 0.2.2 | 2026-08-03 | Phase 2 code review, round 2. The round-1 fix for the backtick-parity blind spot **introduced a regression of its own class**: its comment pre-pass treated any line starting with `*` as a comment, so a SQL line like `  * FROM pg_indexes …` had its backtick stripped and the parity shifted — one masked query in a two-query fixture, silently. Both heuristics are now gone: `migration-schema.awk` is a real lexer tracking literal-in/out state, so a `//` is a comment only outside a literal and an unterminated literal is reported. Four fixtures cover it (star-line, comment-backtick, mid-line comment, schema-safe forms). Also: guard-name list is now single-sourced from `lib.sh` (`run-all.sh` reads it), `filter_allowlist` accepts exactly what `validate_allowlist` accepts (they had drifted — `n < 3` vs `n != 3`, and `ENV` accepted for any guard), and `financial-ordering` excludes spec/e2e files. Counts unchanged. |
| 0.2.1 | 2026-08-03 | Phase 2 code review follow-up. Two blockers closed in the guards themselves: (1) `migration-schema.sh` split template literals on backticks, so a backtick inside a `//` comment shifted the parity and blinded the guard **silently** — comment backticks are now stripped and any file with odd parity or an escaped backtick is reported, not skipped (fixture-verified: pre-fix guard 0 findings, post-fix 1). (2) `financial-ordering.sh` scanned 132 of 273 module files — `finance-reporting`, `spend-calculation`, `kpi-engine` were outside it — so INV-N-001's "0 findings across the codebase" claimed more than was measured; scope widened to 176 files (still 0) and the guard's blind spot for runtime-built sort keys is now stated (T-066 opened). Also: `SKIPPED` no longer counts as green (a source-code guard that cannot run exits 1; a DB guard without a database reports `ÖLÇÜLMEDİ`), allowlist-suppressed findings are now printed in the summary instead of vanishing into `0 bulgu`, and the `schema-isolation` entry uses the narrow key `db:collmind_tpm` rather than the `ENV` wildcard. |
| 0.2 | 2026-08-03 | Guards Phase 2. Guard type `LINT` → `GUARD SCRIPT` for entries enforced by `scripts/guards/*.sh` (ESLint reads the AST; these checks read SQL string contents). Guard type `CI` removed — no pipeline exists; enforcement path is `npm run guards` + `code-reviewer` + Done checklist. INV-M-002 → HOLDS (5 unqualified catalogue queries in 2 migrations found and repaired; scope now measured, not unknown). INV-M-003 → detected + allowlisted (T-067). INV-L-007, INV-N-001 → guard `NONE` → `GUARD SCRIPT`, both measured at 0 findings. INV-L-005 and INV-M-001 remain VIOLATED deliberately: the repaired migration was proven on a throwaway database (all 54 migrations from empty → both objects on `main`), but the working database `collmind_tpm` still lacks them and cannot be re-migrated in place. A fix that has not reached the environment is not a held invariant. Both close with a `db:reset` after T-057 is committed. **Counted:** 33 invariants — 16 HOLDS · 10 VIOLATED · 7 BLOCKED. (The 34th `### INV-` heading, `INV-X-000`, is the §2 format template, not an invariant.) |
