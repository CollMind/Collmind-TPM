# SYSTEM_INVARIANTS.md — v0.4 (DRAFT)

> **Status:** Draft for review. Not yet normative.
> **Subject:** Collmind-TPM (`collmind.backend`) @ `876010f` + guards Phase 2 + uncommitted T-057 delta
> **Count:** 38 invariants — **20 HOLDS · 10 VIOLATED · 8 BLOCKED** · 14 open decisions
> (sayıldı 2026-08-10, `### INV-X-NNN` başlıkları + her girdinin **ilk** `Status:` satırı;
> `INV-X-000` §2 şablonudur ve sayıma girmez. İki `HOLDS` **kazara** sağlanıyor — bkz. §9.)
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
| `GUARD SCRIPT` | `scripts/guards/*.sh`, run by `npm run guards`. Blocking (`exit 1`) since Phase 2. Each run first executes `self-test.sh`, which proves the guards still detect known defects — a guard that has silently stopped measuring is itself a failure, not a pass |
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

### ⛔ Kapsam sınırı (bağlayıcı kaynak, `docs/brd/01_Main_BRD/Section_03_Core_Components.md` §3.6)

> *"Ledger is a financial traceability mechanism, **not an accounting system**. It tracks
> promotional spend attribution and audit trails, but does not replace GL accounting,
> accounts payable processing, or ERP financial modules."*

Bu cümle `INV-L-*` ailesinin **üst sınırıdır**: ledger'dan muhasebe düzeyinde garanti
beklenmez. `account_code`'un BRD'de *"Optional GL mapping"* olması da bunu destekler.
Gelecekte *"ledger şunu da yapmalı"* denildiğinde referans budur.
(Kaydeden: [[T-143]] turu 5 · `docs/analysis/0023 §2.7`)

### ⚠️ Bu ailenin kaçırdığı bir kaynak maddesi ([[T-151]])

BRD `§3.6` şeması `amount NUMERIC(18,2) NOT NULL **CHECK (amount >= 0)**` diyor ve
*"amount always positive; sign indicated by direction"* kuralını yazıyor. **Bu kısıt bizde
yok** (ölçüldü: `pg_constraint contype='c'` boş) ve **aşağıdaki dokuz invariantın hiçbiri
onu içermiyor.** Negatif bir `amount` + `DEBIT`, `INV-L-007`'nin `Σ DEBIT − Σ CREDIT`
hesabını sessizce bozar.

### 📌 `deleted_at` ve **D-04**

BRD'nin `ledger_entries` şemasında `deleted_at` **hiç yok**. `INV-L-003` *"hiçbir satır
non-null `deleted_at` taşıyamaz"* demek zorunda kalıyor — **bir invariant'ın bunu söylemek
zorunda olması, kolonun hiç olmaması gerektiğinin işaretidir.** D-04 için kaynak tarafı
artık cevaplı; karar ürün sahibinin.

The ledger is the system's financial system of record. These are the strongest invariants
in the product and most of them already hold.

### ⛔ Bu aile ŞEMA tarafından ihlal ediliyor — ölçüldü 2026-08-11 ([[T-188]])

`INV-L-001` mutasyonu **ifadelerde** arıyor (*"No statement may modify…"*). Ama iki
mutasyon yolu **şemada**, ve hiçbir `UPDATE`/`DELETE` ifadesi içermiyor:

```sql
FK ledger_entries → budget_envelopes   ON DELETE = SET NULL   -- 1704067540000:243
FK ledger_entries → tenants            ON DELETE = CASCADE
FK ledger_entries → agreements         YOK
```

**Ölçülmüş bedeli:** `main.ledger_entries` 1231 satır, ₺6.080.000, `budget_envelope_id`
**%100 NULL** — zarflar silindiğinde FK sessizce NULL'ladı. Ve `agreement_id`'de FK
olmadığı için **1231 satırın hepsi var olmayan bir anlaşmaya** işaret ediyor.

Sonuç: `v_budget_summary` ledger'ı okuyor ama zarfsız satırları **join edemiyor** →
₺1.120.000 net DEBIT bütçe özetine **hiç girmiyor**. Bütçe panosu *"harcama ₺0"* diyor.

> **Değişmezliği kodda arayan bir invariant, şemadaki bir kuralı göremez.**
> `INV-L-001`'in `budget_envelope_id` maddesi bugün **yanlış** — ya FK değişmeli
> (`RESTRICT`), ya madde düzeltilmeli. Karar [[T-188]]'de, `D-04` ile aynı yöne bakıyor.

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

### INV-L-006 — Wherever a row carries an `idempotency_key`, that key is unique within its tenant, enforced in the database.
- **Status:** HOLDS (as of T-095)
- **Guard:** DB ✅
- **Scope:** `ledger_entries`, `budget_transactions`, `agreement_transactions`, `on_invoice_entries`, `budget_transaction_logs`
- **Source:** audit candidate #6; generalised by T-095

Originally written for `ledger_entries` alone. T-095 measured all five tables that carry the
column and found four already compliant on **both** dimensions (`NOT NULL` **and**
`UNIQUE (tenant_id, idempotency_key)`) — so generalising the wording cost nothing and closed the
one gap.

`budget_transaction_logs` is that gap. It took the column in migration `1771169825000` and never
took the index, while `budget_transactions` had received its own in the original
`1704067520000` — a later table quietly dropping a guarantee its sibling already held.

It is now closed, by a partial index (migration `1798000000000`) rather than the `NOT NULL` +
plain UNIQUE the other four use — and the detour is worth recording.

A first attempt added `NOT NULL`. It was reverted: three of the six write sites legitimately pass
no key, so that would have broken live routes. The measurement that justified it ("0 rows, so
NOT NULL is free") also had a second explanation nobody had checked — the table had never been
writable at all (`created_by` was mapped twice; every INSERT failed with 42701, fixed in T-096).
The count was right and the conclusion was wrong.

**On `NOT NULL`:** four of the five tables keep the column `NOT NULL`, and there it is right —
every row on those paths carries a key. `budget_transaction_logs` also records `ALLOCATION` and
`ADJUSTMENT` rows, and creating or adjusting an allocation is a repeatable event with no natural
business key. Forcing one would assert a uniqueness the domain does not have.

So the invariant is stated over ROWS THAT CARRY A KEY, not over columns:

```sql
UNIQUE (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL
```

A second draft wrote `AND transaction_type <> 'adjustment'`. Also rejected: uniqueness depends on
whether a key is present, not on the transaction type — and naming a type would have made a
silent claim about `transfer`, which exists, is unused, and about which nobody has decided
anything. The `IS NOT NULL` form is the literal SQL of this invariant's own sentence, and it makes
the `ALLOCATION` question moot rather than deferring it: no key, no scope; a key one day, scope
automatically.

The trap this wording avoids: PostgreSQL permits several `NULL`s under a UNIQUE constraint, so a
nullable column with a plain unique index is protection that looks present and is not — the same
class as a partially applied transformer (T-091) or a guard whose detector never reaches the code
it claims to cover (T-094). A PARTIAL index is not that trap: it states exactly which rows it
governs.

**Both layers are required, and they are not redundant.** The application-side read
(`where: { idempotencyKey, tenantId, deletedAt: IsNull() }`) answers the normal path cleanly —
"already written, no-op" — instead of surfacing a raw `23505`. The DB constraint is the last
line, for the race the read cannot see: two writers can both read "absent" and both proceed.
Removing either leaves a real hole.

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
- **Status:** ⚠️ **HOLDS VACUOUSLY (until 2026-08-04)** — bugüne kadar üretimde **hiç POSTED satır
  üretilmedi**: `on-invoice.service.ts`'teki `entry.invoiceDate.toISOString()` her zaman
  çöküyordu (TypeORM `type:'date'` kolonlarını `Date` değil `'YYYY-MM-DD'` **string** olarak
  hydrate ediyor). **Boş kümede her invaryant sağlanır.** Posting yolu [[T-057]]'de düzeltildi;
  bu invaryant ilk kez gerçek veriyle sınanacak. Doğrulama yolu (`validateBatch`) hâlâ kırık →
  [[T-064]].
- **Guard:** TEST → add `CI` (reconciliation) — ⚠️ mevcut testler bu hatayı **yakalamadı**
- **Source:** audit candidate #9

### INV-R-002 — The sum of ledger DEBITs created from an on-invoice batch equals the sum of `discount` over that batch's `POSTED` entries.
- **Status:** ⚠️ **HOLDS VACUOUSLY (until 2026-08-04)** — aynı gerekçe: hiç POSTED satır
  üretilmediği için hiç ledger DEBIT de üretilmedi; iki boş kümenin toplamı eşitti.
  Bkz. INV-R-001 notu, [[T-057]] (posting düzeltmesi) ve [[T-064]] (validate yolu hâlâ kırık).
- **Guard:** TEST → add `CI` — ⚠️ mevcut testler bu hatayı **yakalamadı**
- **Source:** audit candidate #10

> **Ders (2026-08-04):** İki denetim (`0011` ve CTPM baseline) `on-invoice.service.ts:439`'u okudu,
> zarf çözümünü tartıştı, ama o kodun **hiç çalışmadığını** görmedi.
> **Statik okuma, çalıştırmanın yerini tutmaz.** "HOLDS" işareti, invaryantın sınandığı anlamına
> gelmez — üretilen satır sayısı sıfırsa hiçbir şey sınanmamıştır.

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
- **⚠️ Source status (T-142, 2026-08-10):** the "two extant Addendum V2 versions" could **not
  be located**. `recognition` appears **zero** times in the binding BRD package
  (`docs/brd/`), and it carries no allocation rule of any kind. The rule below is a
  **proposal awaiting a product decision**, not a reading of a source. See ADR 0010.
- **Rationale (as originally written):** the two extant Addendum V2 versions specify incompatible algorithms.
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

### INV-N-004 — A RAG colour is never shown from the full-coverage palette while coverage is partial.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `TEST` (inject a partial-coverage row on a live route, assert no
  full-coverage colour is returned)
- **Evidence:** the **producer** is correct — `kpi-engine.service.ts` guards both roll-ups with
  `fullCoverage`, so a partial-coverage KPI carries `ragStatus = null` deliberately (T-177).
  The **reader** falsifies it: `finance-reporting.service.ts:583` and `:633` both do
  `ragStatus: plan.ragStatus || 'GREEN'`, on live `@Get` routes.
  ⛔ **The first scope claim was WRONG and is corrected here.** It read: *"measured across six
  shapes — exactly these two sites."* Those six shapes were all spellings of **a `'GREEN'`
  default**; the defect class is wider — *"absence of colour collapses into a colour."* The
  universe was defined by a **literal**, not by the class. Found by `frontend-engineer`
  2026-08-14, one turn later:

  ```
  GrandTotals.tsx:25   if (!ragStatus || ragStatus === 'AMBER') → '• RİSKLİ'
                       (and the trailing return does the same)
  ```

  Same class, **opposite direction**: `null` becomes a business judgement (*at risk*) rather
  than a reassurance. A reader cannot tell "risky" from "not computed".

  **Measured sites, by surface:**

  | surface | site | shape |
  |---|---|---|
  | finance report | `finance-reporting.service.ts:583` · `:633` | `\|\| 'GREEN'` |
  | plan totals | `GrandTotals.tsx:25` + trailing `return` | `!x \|\| AMBER` → RİSKLİ |
  | plan list | `PlanList.tsx:49` | `return null` — no colour **and no explanation** |
  | grid | `PlanningGrid.tsx:57` · `grid-cells.tsx:551` | grey, but **no coverage ratio** |
  | export | `utils/export.ts:178` | raw value to Excel, **no coverage column** |

  The producer remains correct: both `kpi-engine` roll-ups are `fullCoverage`-guarded (T-177),
  so `null` is deliberate.

  ⚠️ **And the carrier is missing at plan level:** `plans` has neither `calculated_kpis` nor
  `coverage_ratio` (0 columns, measured); only `plan_fus` and `plan_skus` carry them. So the
  two most visible surfaces (`PlanList`, `GrandTotals`) **cannot** show a coverage ratio today
  without new backend work — remediation there is blocked, not merely unwritten.
- **Impact:** with today's data this is the **majority** case, not an edge — `COGS 4/170`, so
  nearly every green shown on the panel actually means *"could not be computed."* This is the
  most dangerous class: it falsifies the confidence claim itself.
- **Carrier:** `null`, not a `GRAY` value (`K-2.4.22a1`). Meaning is read from the coverage
  ratio, which today **stops at the JSONB** — 0 occurrences in DTOs, 0 in the frontend.
- **Remediation:** `D1` (drop the `|| 'GREEN'`) + `D2` (carry `coverageRatio` to the client and
  render the grey badge). `PlanList.tsx:49` currently does `if (!ragStatus) return null` — no
  colour *and* no explanation.
- **Source:** `K-2.4.22c` (invariant clause) · `K-2.4.22a`/`a1` · decision `3.9`

### INV-N-003 — Fiscal period derivation is timezone-independent.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `TEST` (assert under ≥2 `TZ` values) + `LINT`
- **Evidence:** `agreement-transaction.service.ts:108-122` — 3-level fallback ending in
  `getFullYear()`/`getMonth()`, which are local-timezone operations
- **Impact:** the same invoice lands in different fiscal months on servers in different
  timezones
- **Remediation:** blocked on **D-12**
- **Source:** determinism risk 6, spec gap 22
- **⚠️ Scope correction (T-107 adım 1, 2026-08-09):** the invariant was written against
  `getFullYear()`/`getMonth()` only. Measured: the SAME violation class also occurs at **Date
  EPOCH CONSTRUCTION**, one step earlier in the pipeline — `new Date(1899, 11, 30)` builds a
  local-midnight epoch, then `.toISOString().split('T')[0]` formats it in UTC. The two clocks
  disagree by one calendar day in any timezone east of UTC (measured: `Europe/Istanbul`,
  `Asia/Kolkata` both landed a day early; `UTC`, `America/New_York` did not — so a `TZ=UTC`-only
  test cannot see this instance either). Found in five Excel serial-date call sites across
  three importers (`off-invoice-file-parser.service.ts:268,308`,
  `on-invoice-file-parser.service.ts:281,323`, `customer/services/file-parser.service.ts:434`).
  **This instance is FIXED** — `src/common/date/excel-serial-date.ts`, `Date.UTC(1899, 11, 30)`
  throughout, no local-clock construction or formatting anywhere in the path. The
  `agreement-transaction.service.ts:108-122` instance above is unrelated code (invoice-date
  string parsing, not Excel serial parsing) and remains VIOLATED, still blocked on **D-12** —
  fixing one instance does not close the invariant's overall status.

---

### Known limit — RAG thresholds survive only on a compensation

`kpi.entity.ts:101,110` hold the RAG threshold columns. They declare no
`DecimalTransformer`, so they arrive as strings, and every comparison against them works
today only because the call sites wrap them in `Number()`.

That is a compensation, not a contract. A comparison written without it flips silently —
and the failure has no symptom: no error, no NaN on screen, just a **RAG colour that is
wrong**. Measured 2026-08-07 (`docs/analysis/0014`); no comparison is broken today.

It matters more than the column count suggests. RAG sits at the centre of the BRD rule that
thresholds are never hardcoded and come only from KPI configuration — a threshold read
through a compensation is one edit away from being no threshold at all.

Not a guard yet: `money-float` does not scan `src/database/`, which is the same gap
`docs/analysis/0014` records as the F0 precondition.

---

## 9. Compliance & Retention — `INV-C`

**Bu aile 2026-08-10'da, bir BRD okuma turu bunun bir boyut olarak hiç var olmadığını
ölçtükten sonra açıldı** (`docs/analysis/0050`). Kaynak: `Section_09_NFR.md` §9.5, üç Türk
düzenlemesini **adıyla** sayıyor (Vergi Usul · KVKK · E-Fatura) ve `§9.8` 7 yıllık saklamayı
bir **Phase 1 taahhüdü** olarak listeliyor.

### ⚠️ Bu ailenin özel niteliği: şartlar bugün **kazara** sağlanıyor

Diğer aileler bir davranışı **koruma altına alır**. Bu aile, bugün doğru olan ama **hiçbir
şeyin koruması altında olmayan** şartları yazıya döker: 7 yıl saklama sağlanıyor çünkü
**hiçbir şey silinmiyor** — bir temizlik/arşivleme işi eklendiği gün sessizce ihlal edilir.

> **Guard'ı olmayan bir invariant bir temennidir** — ama yazılmamış bir invariant, ihlal
> edildiğinde **fark bile edilmez**. Bu aile ikincisini kapatır.

⚠️ **Bağlayıcılık burada iddia EDİLMİYOR.** BRD'nin listesi bir **girdi**dir
(`CLAUDE.md §2.1.2`); hangi düzenlemenin bu ürüne, hangi kayıtlara, hangi biçimde
uygulandığı bir **hukuk sorusudur** ve karara bağlanmamıştır ([[T-170]]). Buradaki
maddeler *"mevzuat şunu emrediyor"* demez — *"kaynak bunu istiyor, bugün şu durumda,
korunmuyor"* der.

### INV-C-001 — No financial record is ever hard-deleted.
```
Status:   HOLDS (accidentally)
Guard:    NONE
Evidence: INV-L-003 (ledger) · INV-R-004 (sales-actuals batches: REPLACED, not deleted)
          Hiçbir zamanlanmış temizlik/arşivleme işi yok — ölçüldü 2026-08-10:
          retention|anonymiz|archive → backend'de ilgili sonuç yok
Source:   BRD §9.5 (Vergi Usul, 7 yıl) · §9.8 Phase 1 · docs/analysis/0050
```
`INV-L-003` bunun ledger'a özel hâli ve **DB guard'ı var**. Bu madde onu tüm finansal
kayıtlara genişletir ve **guard'ı yoktur**.

⚠️ Bu bir *"asla silinmeyecek"* taahhüdü değil; **7 yıl** bir süredir ve süreyi uygulayan
bir mekanizma yoktur. Bir arşivleme işi yazıldığı gün bu madde bir **karar** gerektirir,
bir engel değil.

### INV-C-002 — A deleted user's identity is anonymized, and the audit trail that references it survives.
```
Status:   BLOCKED
Guard:    NONE
Evidence: users soft-delete var (deleted_at); ANONİMLEŞTİRME ÖLÇÜLMEDİ
Source:   BRD §9.5 (KVKK + GDPR Right to Erasure) · docs/analysis/0050
```
Kural **ikili**: *sil* değil, **anonimleştir + audit izini koru**. İkinci yarısı `INV-A-*`
ailesine bağlı ve o aile **henüz yok** ([[T-168]]).

**BLOCKED sebebi:** anonimleştirmenin bugün var olup olmadığı ölçülmedi, ve KVKK'nın bu
ürüne uygulanma biçimi karara bağlanmadı.

### INV-C-003 — An imported invoice file is retained in its original form.
```
Status:   VIOLATED
Guard:    NONE
Evidence: import_batches tablosu YOK (docs/analysis/0028 §5). sales_actuals.raw_row
          satır düzeyinde ham veri tutuyor — dosya değil.
Source:   BRD §9.5 (E-Fatura: "archived in original format (XML/PDF)") · docs/analysis/0050
```
⚠️ *"Dosya saklanmıyor"* **tablo yokluğundan çıkarıldı**, doğrudan ölçülmedi — kanıt bir
sinyaldir, ölçüm değil ([[T-170]]).

### INV-C-004 — Master data owned by an external system of record is never overwritten by this product.
```
Status:   HOLDS (accidentally)
Guard:    NONE
Evidence: Bir ERP entegrasyonu yok — çelişecek kaynak da yok (§6.7: "❌ Pre-built ERP
          connectors"). master-data altında 39 yazma ucu var, beşi BRD'ye göre ERP'nin
          olan veriyi yazıyor (sku · brand · category · generic-unit · channel).
Source:   BRD §6.5 ("source-of-truth system always prevails", "non-negotiable")
          docs/analysis/0053 §4 · [[T-175]]
```
`INV-C-001` ile **aynı şekil**: şart sağlanıyor çünkü onu ihlal edebilecek durum henüz
oluşmuyor. Tetikleyici bir kod değişikliği değil, bir **entegrasyon kararı**.

### 📌 Ailenin ortak deseni — ve neden birlikte duruyorlar

| madde | bugün neden doğru | ne zaman bozulur |
|---|---|---|
| `INV-C-001` | hiçbir şey silinmiyor | bir temizlik/arşivleme işi eklendiğinde |
| `INV-C-004` | ERP yok | ilk entegrasyonda |
| [[T-174]] (UOM) | birim kolonları **boş** | kolonlar dolduğunda ya da faturalar koli cinsinden geldiğinde |

> **Üçü de bir KOD değişikliğiyle değil, bir VERİ ya da ENTEGRASYON değişikliğiyle bozulur
> — ve o gün hiçbir test kırmızıya dönmez.** Bu, ailenin `NONE` guard'ının neden özellikle
> tehlikeli olduğunu açıklar: normal regresyon ağı bu sınıfı hiç görmez.

---

## 10. Open decisions blocking invariants

> **Kapsam, başlığın kendisidir ve bilinçli olarak dardır:** yalnız cevabı bir **invariant**
> açan kararlar. Invariantı olmayan domain soruları buraya girmez.
>
> Tüm açık kararların haritası (ürün sahibi · hukuk · danışman · ölçüm bekleyen) için:
> **`docs/decisions/OPEN_DECISIONS.md`** — o bir **indekstir**, bu listeyi yutmaz, ona
> işaret eder.

Each blocks at least one invariant. Ordered by number of invariants unblocked, then by
whether a silent wrong number depends on it.

| ID | Decision | Blocks | Note |
|---|---|---|---|
| **D-01** | CAP exceedance behaviour | INV-B-002, INV-B-005 | Three variants exist: TTM skip · K43-R clamp · CTPM reject. **Proposed:** split by controllability — off-invoice clamps (K43-R), on-invoice always posts and records `OVER_CAP` |
| **D-02** | CAP source of truth | INV-B-002, INV-B-004 | **Proposed:** the ledger. It is append-only, direction-aware, and already the reporting source |
| **D-03** | CAP scope and optionality | INV-B-002 | K29 says tactic-level, code is agreement-level. K31 says optional, `cap_total_amount` is `NOT NULL` |
| **D-04** | Append-only enforcement level | INV-L-001…003 | DB guarantee or application convention? If DB: `deleted_at` arguably should not exist on this table |
| **D-05** | Numeric contract | INV-N-002, INV-R-008 | Integer minor units · decimal library · SQL-side arithmetic. Plus rounding mode |
| **D-06** | Settlement base | — (prerequisite for INV-R-007) | ⚠️ **Citation corrected (T-142, ADR 0010).** The previous text cited *"Addendum V2 §5.2 — three types frozen per agreement"*. **No such document exists in the repo**: `settlement` appears **zero** times in the Addendum that is here. The binding BRD (`docs/brd/01_Main_BRD/Section_04`) gives **no frozen-type enum** — it gives two concrete **per-mechanic** bases: `250 units × 15 TL` (volume × unit amount) and `125,000 × 5%` (rate × amount). D-06 is to be rebuilt on those. `LIST_PRICE × VOLUME` remains uncomputable — the off-invoice import template carries **Amount only**, no quantity (`0018 §Ö-C`) |
| **D-07** | Recognition allocation rule | INV-R-007, INV-R-008 | ⚠️ **Measured (T-142): NO normative source exists.** `recognition` appears **zero** times across the whole binding BRD package; no allocation / pro-rata / attribution rule anywhere. The earlier note (*"two Addendum V2 versions conflict"*) cited a document that could not be found. **The rule in INV-R-007 is therefore a new product decision, not an interpretation** — §2.4 applies |
| **D-08** | Envelope-not-found policy | INV-B-001, INV-B-006 | Reject · auto-provision · catch-all · persisted exception. **Fixing this also closes Tier-1 risk #1** — same `if` |
| **D-09** | Envelope resolution dimensions | INV-B-007 | One dimension set for both paths |
| **D-10** | Claim model | INV-R-007 | First-class entity (TTM, Addendum V2) or `agreement_transactions` + ledger? |
| **D-11** | RLS requirement | INV-T-003 | Second-customer gate |
| **D-12** | Fiscal period timezone | INV-N-003 | UTC vs local, explicitly |
| **D-13** | Idempotency key formats | INV-L-009 | Three undocumented formats in use |
| **D-14** | Actuals replace semantics as tenant policy | INV-R-003 | K44 is schema-encoded. Cost to make configurable: **high** — relaxing a uniqueness constraint that current correctness depends on |
| **D-15** | Is a computed KPI of exactly zero the same as "no KPI"? | INV-N-002 (blocks the transformer phases) | Seven live sites flip direction the moment a `decimal` column stops arriving as a string: `"0.0000"` is truthy, `0` is not. ⚠️ **ADR 0008 does NOT cover this** — that decision was about a planner's ENTERED value; these are computed KPIs and rule ceilings. Different axis, separate decision. Measured in `docs/analysis/0014` |
| **D-16** | How are scale-3 volume columns represented? | INV-N-002 | 8 columns at `numeric(x,3)`. ADR 0007 settled money (minor units) and rate (micro); volume was never decided, so no parser fits them |
| **D-17** | Are `unitPrice` / `cogs` money or price? | INV-N-002 | Same distinction C3 already drew for `entered_unit_amount`: a per-unit figure legitimately carries four decimals, so the kuruş rule does not apply to it. Whether these two columns are on that side has not been decided |

---

## 11. Guard backlog

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

## 12. Adoption

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

## 13. Changelog

| Version | Date | Change |
|---|---|---|
| 0.1 | 2026-08-03 | Initial draft from CTPM baseline audit. 14 open decisions. Header count of "25 invariants: 15 HOLDS · 10 VIOLATED/BLOCKED" was an estimate and is corrected in 0.2 by counting the entries. |
| 0.4 | 2026-08-10 | **`INV-C` — Compliance & Retention ailesi açıldı** (§9, dört madde). Bir BRD okuma turu (`docs/analysis/0050`) bu boyutun ne kodda ne sözleşmede var olduğunu ölçtü: `Section_09_NFR` §9.5 üç Türk düzenlemesini adıyla sayıyor, `§9.8` 7 yıllık saklamayı bir **Phase 1 taahhüdü** olarak listeliyor, ve `compliance|KVKK|GDPR|retention|INV-C-` bu belgede **0** geçiyordu. Ailenin özel niteliği: `INV-C-001` ve `INV-C-004` bugün **kazara** sağlanıyor — biri hiçbir şey silinmediği, diğeri hiçbir ERP olmadığı için. İkisi de bir **kod** değişikliğiyle değil, bir **veri/entegrasyon** değişikliğiyle bozulur, ve o gün hiçbir test kırmızıya dönmez; normal regresyon ağı bu sınıfı hiç görmez. Bağlayıcılık **iddia edilmiyor** — BRD'nin listesi bir girdidir (`CLAUDE.md §2.1.2`) ve hukuki kapsam [[T-170]]'te açıktır. Sayı 33 → 38, ve **sayılarak** güncellendi (v0.1'in tahmin hatası tekrarlanmadı). Bölüm numaraları 9→10, 10→11, 11→12, 12→13 kaydı.
| 0.3 | 2026-08-03 | **Guards now carry their own tests.** Two review rounds each found a real silent false negative, and in both the evidence was a throwaway fixture that was deleted afterwards — the most valuable output of each round was never recorded. `scripts/guards/fixtures/` makes those five cases permanent (round-2 regression, round-1 blocker, the false-positive counterpart, the schema-safe forms, and a **positive control** that fails if a guard has stopped measuring at all), and `self-test.sh` runs the matrix at the start of every `npm run guards`; a red matrix stops the run before any finding is counted. Verified by negative test: reinstating the round-2 pre-pass drops `star-line` from 2 findings to 1 and the self-test goes red. This closes the guard-infrastructure work — a future defect adds a fixture, not a review round. |
| 0.2.2 | 2026-08-03 | Phase 2 code review, round 2. The round-1 fix for the backtick-parity blind spot **introduced a regression of its own class**: its comment pre-pass treated any line starting with `*` as a comment, so a SQL line like `  * FROM pg_indexes …` had its backtick stripped and the parity shifted — one masked query in a two-query fixture, silently. Both heuristics are now gone: `migration-schema.awk` is a real lexer tracking literal-in/out state, so a `//` is a comment only outside a literal and an unterminated literal is reported. Four fixtures cover it (star-line, comment-backtick, mid-line comment, schema-safe forms). Also: guard-name list is now single-sourced from `lib.sh` (`run-all.sh` reads it), `filter_allowlist` accepts exactly what `validate_allowlist` accepts (they had drifted — `n < 3` vs `n != 3`, and `ENV` accepted for any guard), and `financial-ordering` excludes spec/e2e files. Counts unchanged. |
| 0.2.1 | 2026-08-03 | Phase 2 code review follow-up. Two blockers closed in the guards themselves: (1) `migration-schema.sh` split template literals on backticks, so a backtick inside a `//` comment shifted the parity and blinded the guard **silently** — comment backticks are now stripped and any file with odd parity or an escaped backtick is reported, not skipped (fixture-verified: pre-fix guard 0 findings, post-fix 1). (2) `financial-ordering.sh` scanned 132 of 273 module files — `finance-reporting`, `spend-calculation`, `kpi-engine` were outside it — so INV-N-001's "0 findings across the codebase" claimed more than was measured; scope widened to 176 files (still 0) and the guard's blind spot for runtime-built sort keys is now stated (T-066 opened). Also: `SKIPPED` no longer counts as green (a source-code guard that cannot run exits 1; a DB guard without a database reports `ÖLÇÜLMEDİ`), allowlist-suppressed findings are now printed in the summary instead of vanishing into `0 bulgu`, and the `schema-isolation` entry uses the narrow key `db:collmind_tpm` rather than the `ENV` wildcard. |
| 0.2 | 2026-08-03 | Guards Phase 2. Guard type `LINT` → `GUARD SCRIPT` for entries enforced by `scripts/guards/*.sh` (ESLint reads the AST; these checks read SQL string contents). Guard type `CI` removed — no pipeline exists; enforcement path is `npm run guards` + `code-reviewer` + Done checklist. INV-M-002 → HOLDS (5 unqualified catalogue queries in 2 migrations found and repaired; scope now measured, not unknown). INV-M-003 → detected + allowlisted (T-067). INV-L-007, INV-N-001 → guard `NONE` → `GUARD SCRIPT`, both measured at 0 findings. INV-L-005 and INV-M-001 remain VIOLATED deliberately: the repaired migration was proven on a throwaway database (all 54 migrations from empty → both objects on `main`), but the working database `collmind_tpm` still lacks them and cannot be re-migrated in place. A fix that has not reached the environment is not a held invariant. Both close with a `db:reset` after T-057 is committed. **Counted:** 33 invariants — 16 HOLDS · 10 VIOLATED · 7 BLOCKED. (The 34th `### INV-` heading, `INV-X-000`, is the §2 format template, not an invariant.) |
