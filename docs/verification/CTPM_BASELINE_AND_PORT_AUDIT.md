# Collmind-TPM — Baseline & Port Completeness Audit

**Date:** 2026-08-03
**Mode:** Read-only investigation. No checkouts, stashes, fetches, merges, migrations, seeds, builds, or test runs in either repo. Exactly one file created (this report).

## Subject and reference

| | Path | Branch | HEAD SHA | HEAD date | Commits | Status |
|---|---|---|---|---|---|---|
| **Collmind-TPM** (meta) | `/Users/sertact/Documents/CollMind/Code/Collmind-TPM/` | `staging` | `ceae6db45bf3c689a73cfcc279d92eb81caeebc1` | 2026-08-03T11:34:58+03:00 | 70 | dirty (`m collmind.backend`) |
| **collmind.backend** | `…/collmind.backend` | `staging` | **`b122a6e612ccd9ab604bc62acbf2696a1d0ad251`** | 2026-08-03T11:34:58+03:00 | 130 | **dirty — 8 modified, 2 untracked** |
| **collmind.frontend** | `…/collmind.frontend` | `staging` | `5cf0bd2b959968caa106a288b02ba8fa4590727c` | 2026-08-02T12:59:26+03:00 | 42 | clean |
| **TTM** (reference) | `/Users/sertact/Documents/CollMind/Code/TTM/` | `codex/239-lta-validity-range` | `86f10a43ce7c49188ed3e8be1f06cc8e441e64d0` ✔ *matches the expected commit* | 2026-05-08 | 475 | dirty (5 untracked, pre-existing) |

Remotes: `github.com/CollMind/Collmind-TPM.git`, `github.com/CollMind/collmind.backend.git`, `github.com/CollMind/collmind.frontend.git`.

---

> ## ⚠️ SHA-BOUND EXPIRY CAVEAT
>
> **The port is in progress. Every finding in this report is bound to `collmind.backend` @ `b122a6e6` (2026-08-03).**
> Backend commits landed on the day of the audit. Anything asserted here about budget, on-invoice, plan, or
> agreement-transaction behaviour may be false within days. **Re-verify against a fresh SHA before quoting this
> report in `SYSTEM_INVARIANTS.md`, `SETTLEMENT_SPEC.md`, `RECOGNITION_SPEC.md`, or `LEDGER_SPEC.md`.**
>
> **Baseline decision (§2 STOP condition, resolved with the requester):** the working tree carried **685
> uncommitted insertions across 8 files** in exactly the modules under audit. Parts A/B/C below are therefore
> written against **committed HEAD `b122a6e6`** — read via `git show HEAD:<path>` for every modified file — and the
> uncommitted delta is reported separately in **§Working-tree delta**. No finding in Parts A–C reflects
> uncommitted code.

---

## Verdict

**(1) Financial-correctness state.** The live repo is in a markedly better state than the TTM audits would lead one to expect, in one specific and important respect: **its ledger is genuinely append-only in practice, and its money movements conserve.** There is exactly one mutating statement against `ledger_entries` in the entire codebase, and it sets a boolean flag, not an amount; reversal is modelled as a compensating `CREDIT` entry, not as mutation; idempotency is enforced by a real `UNIQUE` index at the database, not by application convention. Where TTM silently drops amounts in four branches ([K25 §Q6](../../../TTM/docs/verification/K25_ALLOCATION_VERIFICATION.md)), Collmind-TPM's on-invoice path either posts the full uploaded discount or records a persisted `ERROR` row with a reason. But the picture is not uniformly good: **CAP is agreement-level, mandatory, and applies to only one of the two spend paths**; **there is no settlement-base concept at all**; **RLS is neither defined nor enabled**, so tenant isolation is entirely application-level; and the ledger carries a `deleted_at` column that every read filters on, which means any out-of-band write to that column would silently and untraceably remove entries from every balance projection.

**(2) Port progress.** Further along than "a few financial flows" suggests, and closely aligned with what ADR 0001 actually scoped. The ADR named four priority port candidates — *E2E iskeleti, settlements, reversals, invoice claims* — and three of the four are done: **settlements** (`settlement/`, 4 services), **reversals** (`reversal/`, with compensating-entry semantics and a DB double-reversal guard *in the migration*), and the **E2E skeleton** (12 `.e2e-spec.ts` files, including `reversal`, `settlement`, `settlement-budget-release`, `budget-envelope-split`, `sales-actuals`). Sales-actuals ingestion was ported beyond the ADR's list, with **better** immutability semantics than TTM's. The fourth, **invoice claims, is not ported** — there is no claim entity at all. Of 13 inventory areas: **6 PORTED, 4 PARTIAL, 2 NOT_PORTED, 1 NOT_APPLICABLE**. The single most consequential gap is that **the ported sales-actuals data feeds nothing** — it is written and read by its own module only, and its `discountAmount` is explicitly and deliberately marked "never written to budget/ledger/spend".

**(3) Wella decision coupling.** Low — strikingly so. The pilot tenant UUID `11111111-…` appears in **zero** files. `wella` appears in 43 files, essentially all BRD documents and one entity comment. Of the 17 K-decisions assessed, only **2 are HARDCODED**, 5 are DIFFERENT, 8 are ABSENT, and 2 are CONFIGURABLE-adjacent. That is because most of the Wella decision set concerns **on-invoice recognition and tactic-level CAP**, and Collmind-TPM has implemented neither — you cannot hardcode a customer's choice about a feature you have not built. The low coupling is real but it is largely a by-product of absence, not of deliberate generalisation. **Separately: this prompt's K-list diverges from the actual registry on four rows** (K23, K32, K43, K7–K12) — see Part C.

---

## Preflight

### ADR 0001 — what it actually says about port scope

Read at `docs/decisions/0001-ctpm-ana-urun-ttm-dondurma.md` (Accepted, 2026-06-24). It does **not** describe a wholesale port. The operative scope sentence is a single bullet under *Aksiyonlar*:

> "Port-aday akışlar (öncelik: **E2E iskeleti, settlements, reversals, invoice claims**) backlog'a alınır; her port'a e2e zorunlu."

and under *Olumsuz / maliyet*:

> "CTPM'de E2E kapsamı sıfıra yakın; öncelikli yatırım gerektirir."
> "`reversals`/`settlements` ve diğer finansal akışlar CTPM'e port edilene kadar fonksiyonel boşluk var."

**Significant for this audit: on-invoice recognition and the MATCHED/OVER/UNDER/NON_TPM buckets are nowhere in the ADR's port scope.** Their absence from Collmind-TPM (A3) is therefore *not* an incomplete port — it is out of scope by decision. The ADR's stated rationale for choosing CTPM is architectural, and it explicitly discounts TTM's Wella maturity:

> "**Wella verisi bağlayıcı değil:** TTM'in Wella UAT olgunluğu demo/UAT bağlamındadır; üretim taahhüdü değildir, dolayısıyla kod tabanı seçimini belirlemez."

### In-flight port work

Recent backend commits confirm active financial work, none of it TTM-porting by name — it is on/off-invoice budget splitting:

```
b122a6e fix(spend): T-062 — LUMPSUM_SPEND artık SKU'lara dağıtılıyor; bütçeden düşüyor
7d4fba5 feat(plan): T-056 adım 7 — /submit-for-approval deprecation faz 1 + ikiz testler
042df75 feat(plan): T-056 adım 5 — canlı /submit tipli rezervasyona geçti; on/off ürüne açıldı
9612d1a refactor(budget): T-056 adım 3 — reserveTypedForPlan tek rezervasyon motoru
0f694fb fix(budget): T-056 adım 1 — kova keşfi net-tabanlı; hayalet COMMIT ortadan kalktı
04a7c42 feat(budget): T-019b — on/off-invoice zarf split + append-only re-home (Faz 2)
996bbb4 fix(budget): T-053 — RELEASE kova-farkındalı; tipli kovada reject→resubmit artık rezerve ediyor
```

Uncommitted (see §Working-tree delta): T-057, typed envelope resolution.

---

# Part A — Baseline

## A1 — Ledger

### Table and columns

`main.ledger_entries` — 27 columns, verified live:

```
id, tenant_id, source_type, source_id, agreement_id, spend_type, entry_direction,
amount numeric(18,2), currency, period_month, posting_date, channel, cpl_id, fu_id,
tactic_id, mechanic_id, budget_envelope_id, idempotency_key, description, metadata jsonb,
created_at, updated_at, deleted_at, created_by, updated_by, reverses_entry_id, is_reversed
```

Entity: `src/database/entities/ledger-entry.entity.ts:21-27,:57-58`

```ts
@Entity({ name: 'ledger_entries', schema: 'main' })
@Index(['tenantId', 'idempotencyKey'], { unique: true })
@Index(['tenantId', 'agreementId'])
@Index(['tenantId', 'budgetEnvelopeId'])
@Index(['tenantId', 'periodMonth'])
@Index(['tenantId', 'spendType'])
export class LedgerEntry extends BaseEntity {
```
```ts
  @Column({ type: 'decimal', precision: 18, scale: 2 })
  amount!: number;
```

### Does a soft-delete column exist? — **Yes, and this is the ledger's principal structural risk**

`deleted_at` is inherited from `BaseEntity`, `src/database/entities/base.entity.ts:23-24`:

```ts
  @DeleteDateColumn({ name: 'deleted_at', nullable: true })
  deletedAt?: Date;
```

`@DeleteDateColumn` is TypeORM's *active* soft-delete marker, not a passive column.

**Is it ever written for ledger entries? — No.** An exhaustive search for `softDelete` / `softRemove` across `src` returns **~25 call sites spanning ~20 entities** (Tenant, User, Plan, Agreement, Customer, Cpl, Sku, Tactic, Category, Channel, Region, Brand, Mechanic, Kpi, ForecastingUnit, GenericUnit, LTAAgreement). **`LedgerEntry` is not among them.** There is no `softRemove(ledgerEntry)`, no `softDelete` on the ledger repository, and no raw `UPDATE … SET deleted_at` against `ledger_entries`.

**Is it filtered in reads? — Yes, universally.** Every one of the eight read paths in `ledger.repository.ts` filters it, e.g. `:31-32`, `:70`, `:120`:

```ts
      where: { idempotencyKey: key, tenantId, deletedAt: IsNull() },
```
```ts
      .andWhere('ledger.deletedAt IS NULL');
```

**Consequence, stated precisely:** the ledger is append-only *by application discipline*, not by construction. Nothing in the schema prevents `UPDATE main.ledger_entries SET deleted_at = now()`, and because every balance projection filters on that column, such a write would silently remove money from `sumByAgreementId` and `sumByEnvelopeId` with no compensating entry and no audit trace. There is **no DB trigger, rule, or grant restriction** enforcing append-only — a search for `TRIGGER|RULE|REVOKE` across all 54 migrations returns nothing.

### Entry types — DB and TypeScript

TypeScript, `ledger-entry.entity.ts:8-19`:

```ts
export enum LedgerEntryDirection {
  DEBIT = 'DEBIT',
  CREDIT = 'CREDIT',
}

export enum SpendType {
  ON_INVOICE = 'ON_INVOICE',
  OFF_INVOICE = 'OFF_INVOICE',
  ADJUSTMENT = 'ADJUSTMENT',
  ACCRUAL = 'ACCRUAL',
}
```

DB: both columns are `USER-DEFINED` (Postgres enum types), declared from these same TypeScript enums via TypeORM's `type: 'enum', enum: SpendType`. **They agree by construction** — there is no hand-written DB enum to drift from.

Note there is **no** TTM-style `entry_type` axis (`ALLOCATE`/`RESERVE`/`RELEASE`/`CONSUME`/`TRANSFER`/`ADJUST`). Collmind-TPM models the ledger as *spend nature × direction*; budget lifecycle (RESERVE/COMMIT/RELEASE) lives in a **separate** table, `budget_transactions` (A-B1 below). This is a deliberate two-table design, not a gap.

### Every `UPDATE` / `DELETE` against the ledger — **exactly one, quoted in full**

`src/modules/modes/actuals-first/ledger/ledger.repository.ts:220-227`:

```ts
  /**
   * Mark a ledger entry as reversed.
   * Called inside a QueryRunner transaction — uses the runner's manager.
   */
  async markAsReversed(
    id: string,
    queryRunner: import('typeorm').QueryRunner,
  ): Promise<void> {
    await queryRunner.manager.update(LedgerEntry, { id }, { isReversed: true });
  }
```

That is the complete set. **No `DELETE` exists.** No amount, direction, envelope, or period is ever mutated. The one mutable field is a boolean marker whose only effect is to exclude the entry from future reversal-source lookups.

### Reversal — compensating entry, not mutation

`src/modules/modes/actuals-first/ledger/ledger.service.ts:101-144`:

```ts
    const idempotencyKey = `REVERSAL|LEDGER|${originalEntryId}`;
    const reversalDirection =
      original.entryDirection === LedgerEntryDirection.DEBIT
        ? LedgerEntryDirection.CREDIT
        : LedgerEntryDirection.DEBIT;

    const entry = queryRunner.manager.create(LedgerEntry, {
      ...
      entryDirection: reversalDirection,
      amount: Math.abs(Number(original.amount)),
      ...
      reversesEntryId: original.id,
      isReversed: false,
      description: `Reversal of ledger entry ${originalEntryId}`,
```

A new row with opposite direction and a self-reference. Balances are direction-aware, `ledger.repository.ts:112-122`:

```ts
      .select(
        `COALESCE(SUM(CASE WHEN ledger.entryDirection = '${LedgerEntryDirection.DEBIT}' THEN ledger.amount ELSE 0 END), 0)` +
          ` - COALESCE(SUM(CASE WHEN ledger.entryDirection = '${LedgerEntryDirection.CREDIT}' THEN ledger.amount ELSE 0 END), 0)`,
        'total',
      )
```

**This is textbook-correct double-entry reversal** and is materially better than mutation-based approaches.

### DB-level idempotency constraints

`src/database/migrations/1704067540000-CreateLedgerEntries.ts:189` declares `['tenant_id','idempotency_key']` unique. Verified live:

```sql
CREATE UNIQUE INDEX "IDX_LEDGER_ENTRIES_TENANT_IDEMPOTENCY"
  ON main.ledger_entries USING btree (tenant_id, idempotency_key)
```

Backed at the application layer by a read-before-write, `ledger.service.ts:24-27`:

```ts
    const existing = await this.ledgerRepo.findByIdempotencyKey(idempotencyKey, tenantId);
    if (existing) {
      return existing; // Idempotent: return existing entry
    }
```

### 🔴 A1 DEFECT — the double-reversal DB guard was never created on this schema

`src/database/migrations/1777000000000-LedgerReversalSupport.ts` is **recorded as applied** in `main.migrations`, and its columns did land (`is_reversed`, `reverses_entry_id` are present on `main.ledger_entries`). But its two integrity objects — the self-FK and the partial unique index — **do not exist on `main.ledger_entries`**:

```
indexes on main.ledger_entries:
  PK_6efcb84411d3f08b08450ae75d5, IDX_LEDGER_ENTRIES_TENANT_IDEMPOTENCY,
  IDX_LEDGER_ENTRIES_TENANT_AGREEMENT, IDX_LEDGER_ENTRIES_TENANT_ENVELOPE,
  IDX_LEDGER_ENTRIES_TENANT_PERIOD, IDX_LEDGER_ENTRIES_TENANT_SPEND_TYPE,
  idx_ledger_entries_envelope
                                          ← UQ_ledger_entries_reversal_per_tenant ABSENT
```

Both objects exist, but on the **wrong table in another schema**:

```
 conname                          | schema | table
 FK_ledger_entries_reverses_entry | public | ledger_entries
 indexname                             | schemaname | tablename
 UQ_ledger_entries_reversal_per_tenant | public     | ledger_entries
```

**Root cause, precisely.** The migration's `ADD COLUMN` statements are schema-qualified and succeeded (`:16`, `:22`: `ALTER TABLE "main"."ledger_entries"`). Its idempotency *guards* are not — `:33-37` and `:52-56`:

```ts
    const fkRows = (await queryRunner.query(`
      SELECT conname FROM pg_constraint
      WHERE conname = 'FK_ledger_entries_reverses_entry'
      LIMIT 1
    `)) as Array<{ conname: string }>;

    if (fkRows.length === 0) { … }
```
```ts
    const uqRows = (await queryRunner.query(`
      SELECT indexname FROM pg_indexes
      WHERE indexname = 'UQ_ledger_entries_reversal_per_tenant'
      LIMIT 1
    `)) as Array<{ indexname: string }>;

    if (uqRows.length === 0) { … }
```

Neither query filters on `schemaname`/`connamespace`. This database also hosts TTM's schema in `public` (see §Environment), which already carried identically-named objects, so both guards saw a match and **skipped creation**. The migration reported success.

**Impact:** double-reversal is still blocked in-process by an application check — `reversal.service.ts:137-144`:

```ts
      const existingReversal =
        await this.ledgerService.findReversalByOriginalId(
          originalEntry.id,
          tenantId,
        );
      if (existingReversal) {
        throw new ConflictException({
          code: 'ALREADY_REVERSED',
```

— but that is a read-then-write with no DB backstop, so **two concurrent reversal requests for the same entry can both pass the check and both insert a CREDIT**, double-crediting the envelope and the agreement. This is a **silent wrong number**, not a loud failure.

*Caveat: this is an environment finding as much as a code one. On a database not sharing a cluster with TTM's `public` schema, the guards would find nothing and the objects would be created. The **latent** defect is the unqualified guard; the **observed** defect is this instance.* **DIVERGENT** — migration recorded as applied, effect not applied.

---

## A2 — Settlement engine

### Entry point and call chain

There is **no actuals-driven claim-generation engine**. The financial write path is per-transaction, entered from the off-invoice side.

`POST /agreement-transactions` → `AgreementTransactionService.create` — `agreement-transaction.service.ts:32`. Chain:

1. `AgreementTransactionService.create` — `:32`
2. → agreement load + `AgreementStatus` validation
3. → idempotency pre-check (`:80-85`)
4. → **CAP check** (`:97-106`) — see A5
5. → fiscal period resolution, 3-level fallback (`:108-122`)
6. → `AgreementTransactionRepository.create` (`:125`) — persists `agreement_transactions`
7. → `BudgetService.findEnvelopeByDimensions(tenantId, channelCode, fiscalPeriod)` (`:143`)
8. → **if and only if an envelope is found** → `LedgerService.createFromAgreementTransaction` (`:151`)
9. → `LedgerService.createEntry` → `LedgerRepository.create` → `INSERT main.ledger_entries`

The parallel on-invoice path is `OnInvoiceService.processBatch` — `on-invoice.service.ts:327` (A3).

Settlement *reading* is separate and read-only: `SettlementSummaryService.getSummary` — `settlement-summary.service.ts:60`, and `SettlementCloseService`.

### Settlement base resolution — **absent**

A search for `settlementBase|settlement_base|NET_SALES|GROSS_SALES|LIST_PRICE_X_VOL` across `src` returns **no settlement-base concept**. The only `list_price` hits are a column on `on_invoice_entries` and CSV parser aliases (`on-invoice-file-parser.service.ts:190`).

**There are no base types, therefore no enum member can silently fall through** — the question is vacuous here. This is the inverse of TTM, which has a three-member enum in which `LIST_PRICE_X_VOL` *does* silently fall through to `NET_SALES` ([K25 §Q3](../../../TTM/docs/verification/K25_ALLOCATION_VERIFICATION.md)). Collmind-TPM has no such defect because it has no such feature: amounts are supplied per transaction (`dto.amount`) or per uploaded invoice line (`entry.discount`), never computed from a base × rate.

**Consequence for the spec layer:** `SETTLEMENT_SPEC.md` cannot describe settlement-base resolution as existing behaviour. It is greenfield.

### ON_INVOICE before OFF_INVOICE? — **unspecified, and structurally so**

The two paths are **independent HTTP endpoints with no shared orchestrator**: on-invoice via `OnInvoiceModule` batch upload→validate→process, off-invoice via `AgreementTransactionModule` create/batchImport. Nothing sequences them. Contrast TTM, where a single `generateActualsClaims` transaction runs off-invoice (`actuals.service.ts:454-671`) then on-invoice (`:673`) in a defined order.

**UNKNOWN — whether an ordering is intended.** Determining it requires a product decision, not a code reading. Today, order is whatever the operator does.

### Rounding, precision, numeric types

| Layer | Type |
|---|---|
| DB — `ledger_entries.amount` | `numeric(18,2)` |
| DB — `agreements.cap_total_amount` | `decimal(18,2)`, `isNullable: false` |
| DB — `sales_actuals.{gross,net,discount}_amount` | `decimal(18,2)` |
| DB — `on_invoice_entries.list_price` | `decimal(18,4)` |
| TypeScript | **`number` (IEEE-754 double)** throughout |

**There is no rounding step anywhere on the ledger write path.** No `Math.round`, no `toFixed`, no decimal library on `ledger.service.ts` / `ledger.repository.ts` / `agreement-transaction.service.ts`. Amounts pass through unrounded and Postgres applies `numeric(18,2)` coercion at insert.

Floating-point does appear at the read boundary — `ledger.repository.ts:123`, `:147`:

```ts
    return parseFloat(result.total) || 0;
```

and in comparison arithmetic — `agreement-transaction.service.ts:102`:

```ts
    if (currentTotal + dto.amount > Number(agreement.capTotalAmount)) {
```

A mitigating control exists that TTM lacks: a `DecimalTransformer` is applied to newer money columns, e.g. `sales-actual.entity.ts:82-90`. It is **not** applied to `ledger_entries.amount`.

**Rounding mode: undefined.** Whatever Postgres's `numeric` coercion does (half-up away from zero) is the de-facto rule; no application code states one.

---

## A3 — On-invoice recognition

### Does it exist? — **No. Recognition does not exist. Ingestion does.**

Entry point: `OnInvoiceService.processBatch` — `on-invoice.service.ts:327`, reached via `OnInvoiceModule` (wired at `app.module.ts:63`). It is live, not dead code.

But it performs **no recognition**. It posts each uploaded invoice line's declared discount straight to the ledger — `on-invoice.service.ts:448-455` (HEAD):

```ts
            await this.ledgerService.createEntry(
              {
                sourceType: LedgerSourceType.MANUAL,
                sourceId: entry.id,
                spendType: SpendType.ON_INVOICE,
                amount: entry.discount,
```

`amount: entry.discount` — verbatim, no rate, no base, no expected amount, no agreement lookup.

### Is the actual granted discount read? — **Read, stored, and deliberately quarantined**

`sales_actuals` (the ported TTM-shaped actuals table) *does* carry the discount:

```
gross_amount  decimal(18,2)
net_amount    decimal(18,2)
discount_amount decimal(18,2) nullable
```

And its use is **explicitly forbidden by design**, `src/database/entities/sales-actual.entity.ts:12-17`:

```ts
 * ⚠️ LEDGER/BÜTÇE SINIRI: `budgetEnvelopeId`/`ledgerEntryId`/`agreementId`
 * kolonu YOKTUR. `discountAmount` satış iskontosudur — asla bütçeye/ledger'a/
 * spend'e yazılmaz, salt bilgi amaçlıdır. On-invoice indirimiyle ekonomik
 * olarak örtüşebilir; on-invoice zaten kendi akışında ledger'a yazıyor,
 * burada tekrar kullanılırsa çift sayım olur (T-003/T-017 kökü buydu).
```

and repeated on the column itself, `:78-81`:

```ts
  /**
   * ⚠️ Satış iskontosu — asla bütçeye/ledger'a/spend'e yazılmaz, salt bilgi.
   */
```

**So the answer is: neither a real allocation nor a boolean gate — it is stored as informational-only, with a documented anti-double-counting rationale.** This is a *deliberate* decision, not an oversight, and it is the sharpest single contrast with TTM, where the same figure is read and used as a gate before being discarded ([K25 §Q2](../../../TTM/docs/verification/K25_ALLOCATION_VERIFICATION.md)).

The only place gross/net/discount are compared is a **warning-only** reconciliation, `sales-actuals-validation.service.ts:74-76`:

```ts
   * Tek satır validasyonu. BRD "varsayım yapma" kuralı gereği net+discount≠gross
   * yalnızca UYARI (satır kabul edilir); tüm diğer edge case'ler satır reddi.
```

with one hard error, `:201-212`:

```ts
      errors.push({
        rowNumber,
        code: 'NET_EXCEEDS_GROSS',
```

### Do buckets exist? — **No, in either enum**

`MATCHED`, `OVER`, `UNDER`, `NON_TPM`, `UNALLOCATED` return **zero hits** across `src`. No DB enum, no TypeScript enum, no column. The nearest identifier is `on_invoice_discount_type_enum`, `1773000000000-CreateOnInvoiceTables.ts:19`:

```sql
CREATE TYPE "main"."on_invoice_discount_type_enum" AS ENUM('CPP_ON', 'LTA_ON', 'PROMO_DISCOUNT');
```

— a **declared input** attribute parsed from the upload file, not a derived classification.

### Proportional allocation (the K25 question)? — **No, and the question does not arise**

There is no allocation because there is no expected amount to allocate against, and no agreement matching at all. A search for `matchKey|CPL.*FU.*period|CPL \+ FU` returns nothing. Each on-invoice line posts its own declared discount independently of every agreement.

**K25 is therefore unimplemented in Collmind-TPM as it is in TTM — but for a different reason.** TTM built expected-amount computation and omitted the reconciliation step. Collmind-TPM has not built expected-amount computation at all.

---

## A4 — Conservation check

### The exact arithmetic

**On-invoice path** (`processBatch`, per entry `e` in a `VALIDATED` batch with `status = PENDING`):

```
envelope := findEnvelopeByDimensions(tenant, customer.channel, e.fiscalPeriod, sku…category)

if envelope exists:
    ledger += DEBIT(amount = e.discount, spendType = ON_INVOICE, envelope, idempotency = 'LEDGER|ON_INVOICE|'||e.id)
    e.status := POSTED ; e.budgetEnvelopeId := envelope.id
    totalDiscount += Number(e.discount)
else:
    e.status := ERROR ; e.validationErrors := [{message: 'Budget envelope bulunamadı: …', severity:'ERROR'}]
    (no ledger entry)
```

**Off-invoice path** (`create`):

```
if idempotencyKey already used → return existing (no double post)
currentTotal := Σ agreement_transactions.amount for agreement
if currentTotal + dto.amount > agreement.capTotalAmount → THROW (nothing persisted)

tx := INSERT agreement_transactions(amount = dto.amount, …)      ← ALWAYS persisted
envelope := findEnvelopeByDimensions(tenant, channelCode, fiscalPeriod)
if envelope exists:
    ledger += DEBIT(amount = dto.amount, spendType = OFF_INVOICE, envelope, idempotency = 'LEDGER|AGREEMENT|…')
else:
    (no ledger entry — but tx already committed)
```

**Reversal:** `ledger += CREDIT(|original.amount|)` + `original.isReversed := true`. Balance = `Σ DEBIT − Σ CREDIT`.

### Can a granted discount end up in no claim, no bucket, and no exception table?

**On-invoice: no.** Every valid entry reaches exactly one of two terminal states, and **both are persisted**: `POSTED` with a ledger DEBIT, or `ERROR` with a stored `validationErrors` array naming the missing envelope (`on-invoice.service.ts:406-415`). Nothing is dropped silently. There is no bucket table, but there *is* a durable exception record — which is more than TTM manages ([K25 §Q8](../../../TTM/docs/verification/K25_ALLOCATION_VERIFICATION.md): a CAP-skipped amount there lives only in an HTTP response body).

**Off-invoice: yes — one branch.** `agreement-transaction.service.ts:148-172`:

```ts
    const envelope = await this.budgetService.findEnvelopeByDimensions(
      tenantId,
      channelCode,
      fiscalPeriod,
    );

    if (envelope) {
      await this.ledgerService.createFromAgreementTransaction(…);
    }

    return transaction;
```

The transaction row is created **before** the envelope lookup and is returned regardless. If no envelope matches the (channel × fiscalPeriod) dimension, **the transaction is committed with no ledger entry, no error, no warning, and a `200` response.** The spend exists in `agreement_transactions` and is invisible to every ledger-derived balance, report, and budget check. It also still counts toward the CAP (which sums `agreement_transactions`, not the ledger) — so the two subsystems disagree by exactly this amount.

**This is the report's clearest silent-wrong-number.** It is an `if` with no `else`.

### Can the system book spend that was never granted?

**Not on the on-invoice path** — the posted amount is the uploaded amount, by construction.

**Yes, in two ways elsewhere:**

1. **Concurrent double-reversal** (A1 defect) writes two CREDITs for one DEBIT, understating spend below what was actually granted — booking a *negative* phantom.
2. **The soft-delete surface.** Because `deleted_at` exists and is filtered by every projection, a single out-of-band `UPDATE` removes granted spend from all balances with no compensating entry. Nothing in the application does this today; nothing prevents it.

### Every branch where an amount is computed and then neither claimed nor recorded

| # | Location | Condition | Fate |
|---|---|---|---|
| 1 | `agreement-transaction.service.ts:148-170` | no matching envelope | **tx persisted, ledger entry silently omitted** — no error, no log |
| 2 | `on-invoice.service.ts:406-415` | no matching envelope | entry → `ERROR` **with persisted reason** — not lost |
| 3 | `agreement-transaction.service.ts:102-106` | CAP exceeded | `BadRequestException` — **nothing persisted at all**, amount never enters the system (loud) |
| 4 | `sales_actuals.discountAmount` | always | **never enters ledger/budget by design** (documented, deliberate) |

Only **#1** is a silent loss.

---

## A5 — CAP enforcement

### Does it exist, and where?

Yes — **2 enforcement points**, both on the off-invoice path. (Note: the field is `capTotalAmount` / `cap_total_amount`; a search for TTM's `capAmount`/`checkCapPolicy` naming returns zero and would produce a false negative.)

1. `agreement-transaction.service.ts:97-106` — single-transaction create:

```ts
    // Validate cap not exceeded
    const currentTotal = await this.txRepo.sumByAgreementId(
      dto.agreementId,
      tenantId,
    );
    if (currentTotal + dto.amount > Number(agreement.capTotalAmount)) {
      throw new BadRequestException(
        `Transaction would exceed agreement cap. Cap: ${agreement.capTotalAmount}, Current: ${currentTotal}, Requested: ${dto.amount}`,
      );
    }
```

2. `agreement-transaction/services/off-invoice-validation.service.ts:252-258` — batch-import pre-validation:

```ts
      if (currentTotal + row.dto.amount > Number(agreement.capTotalAmount)) {
        …
          message: `Tutar anlaşma cap'ini aşıyor. Mevcut: ${currentTotal}, Eklenen: ${row.dto.amount}, Cap: ${agreement.capTotalAmount}`,
```

Compare TTM: one shared `cap-policy.ts` at **5** call sites.

### Skip, clamp, or allow?

**Reject** — a third behaviour, matching neither TTM variant. Point 1 throws `BadRequestException`; point 2 marks the row invalid and excludes it from the batch. TTM skips-or-clamps (K25 §Q8; registry K43-R says clamp). Collmind-TPM refuses the write outright.

### Is a skipped amount persisted?

**Nothing is skipped — the request fails.** Because the exception is raised *before* `txRepo.create`, no partial state exists. There is no persisted record of the rejected attempt (no exception table, no audit row), but there is also no lost money: the caller receives a `400` with cap, current, and requested amounts in the message. **Loud failure, no silent loss** — strictly better than TTM's silent `CAP_EXCEEDED`-in-response-body-only behaviour.

### Does CAP apply identically to ON_INVOICE and OFF_INVOICE? — **No**

**ON_INVOICE completely bypasses CAP.** `OnInvoiceService.processBatch` (`on-invoice.service.ts:327-450`) contains no reference to `capTotalAmount` and no agreement lookup at all. An on-invoice batch can post unlimited discount to a budget envelope regardless of any agreement's cap.

Note this is *arguably correct* for on-invoice — the discount was already granted on the customer's invoice, so refusing to record it would hide realized spend (the exact defect K25 §Q8 raised against TTM). But it is asymmetric and undocumented, and it contradicts registry decision **K30** ("On-Invoice + Off-Invoice her ikisi tactic CAP'i tüketir").

Two further properties:

- **CAP is agreement-level, not tactic-level.** `cap_total_amount` sits on `agreements` (`agreement.entity.ts:126-131`). Registry **K29** specifies tactic-level.
- **CAP is mandatory.** `1704067800000-CreateAgreements.ts:148-153`: `isNullable: false`. Registry **K31** specifies optional with `null` = unlimited. Not expressible here.

---

## A6 — Determinism

### Every `ORDER BY` in a financial path

| Path | Location | Ordering key |
|---|---|---|
| Ledger — by agreement | `ledger.repository.ts:42` | `createdAt DESC` |
| Ledger — by envelope | `ledger.repository.ts:52` | `createdAt DESC` |
| Ledger — findAll | `ledger.repository.ts:91` | `createdAt DESC` |
| Ledger — reversal source | `ledger.repository.ts:170` | `createdAt ASC` |
| Agreement tx — by agreement | `agreement-transaction.repository.ts:52` | `invoiceDate DESC` |
| Agreement tx — by batch | `agreement-transaction.repository.ts:62` | **`rowNumber ASC`** |
| Agreement tx — findAll | `agreement-transaction.repository.ts:106` | `invoiceDate DESC` |
| On-invoice entries — by batch | `on-invoice.repository.ts:106` | **`rowNumber ASC`** |
| On-invoice entries — findAll | `on-invoice.repository.ts:178` | `invoiceDate DESC` |
| Sales actuals — rows | `sales-actuals.repository.ts:141` | **`sourceRowNumber ASC`** |
| Budget — envelopes/allocations | `budget.repository.ts:262,341,403,418` | `createdAt DESC` |
| Budget allocation ranking | `budget-allocation.service.ts:666` | `tx.onInvoiceAmount + tx.offInvoiceAmount DESC` |

### Are any keys `randomUUID()`-generated? — **No. This is a genuine improvement over TTM.**

**No financial path orders by a UUID.** The two paths that actually process amounts in sequence — on-invoice batch processing and off-invoice batch import — order by **`rowNumber` / `sourceRowNumber`**, i.e. the position in the uploaded file. That is stable, business-meaningful, and reproducible across environments.

Contrast TTM: `ORDER BY a.id ASC, at.id ASC` over `randomUUID()` values ([K25 §Q5](../../../TTM/docs/verification/K25_ALLOCATION_VERIFICATION.md)), arbitrary across environments and already output-changing under envelope exhaustion.

**Residual risks, both minor:**
- `createdAt DESC` on ledger reads is not tie-broken. Two entries written in the same transaction share a timestamp; their relative order in *display* queries is then unspecified. No amount depends on it — these are read paths, and the balance aggregations are order-independent sums.
- `findDebitEntryByAgreementId` (`ledger.repository.ts:163-172`) orders `createdAt ASC` and takes the first — the repository's own JSDoc flags this as ambiguous and deprecates it in favour of the idempotency-key lookup.

### `Map` / `Set` / object-key iteration in a financial path

Present, but **none affects a monetary outcome**:

- `agreement-transaction.controller.ts:374` — `new Set(...).size`, a count only.
- `spend-validation.service.ts:582` — `[...new Set(autoFixSuggestions)]`, deduplicating advisory strings.
- `spend-calculation.service.ts:539,664,824,832` and `agreement.service.ts:1279,1311` — `Object.entries()` over tactic/KPI maps. These **do** feed spend arithmetic. Because the operations are commutative sums, order does not change the result under exact arithmetic — but it **does** change floating-point rounding order (below).

### Floating-point arithmetic on money — **yes, throughout**

TypeScript holds every amount as `number`. Confirmed at:

- `ledger.repository.ts:123,147` — `parseFloat(result.total)`
- `ledger.service.ts:127` — `amount: Math.abs(Number(original.amount))`
- `agreement-transaction.service.ts:102` — `currentTotal + dto.amount > Number(agreement.capTotalAmount)`
- `budget.service.ts:121,735,1011,1635,1636,1658` — `Number(tx.amount)`, `Number(envelope.allocatedAmount)`, …

A `DecimalTransformer` exists (`src/database/transformers/decimal.transformer.ts`) and is applied to `sales_actuals` money columns — **but not to `ledger_entries.amount`**. So the ledger, the one place where exactness matters most, is the place without the transformer.

---

## A7 — Multi-tenancy

### RLS — **neither defined nor enabled**

The distinction the acceptance criteria ask for collapses: there is nothing to distinguish.

**Defined:** a search for `ROW LEVEL SECURITY|CREATE POLICY|ENABLE ROW|FORCE ROW` across all `src` (including all 54 migrations) returns **0 hits**.

**Enabled:** verified live —

```sql
SELECT schemaname, tablename, rowsecurity FROM pg_tables WHERE schemaname='main' AND rowsecurity = true;
→ (0 rows)

SELECT count(*) FROM pg_policies;
→ 0
```

Identical to TTM. Tenant isolation is **entirely application-level** in both.

### Does the JWT carry `tenantId`? Where is scoping enforced?

Yes, and it is re-validated against the database on every request — `src/modules/user/strategies/jwt.strategy.ts`:

```ts
  async validate(payload: any) {
    const user = await this.userRepository.findOne({
      where: { id: payload.sub, tenantId: payload.tenantId },
    });

    if (!user || user.status !== 'ACTIVE') {
      throw new UnauthorizedException('User not found or inactive');
    }

    return {
      id: user.id,
      sub: user.id,
      email: user.email,
      role: user.role,
      tenantId: user.tenantId,
    };
  }
```

This is stronger than trusting the token's claim, and stronger than TTM's `resolveTenantId(jwt.sub)`.

Enforcement is then per-query, in repositories. A second layer exists for row visibility: `AccessScopeService` is the single scope-resolution point, applied via `applyToQueryBuilder` — `settlement-summary.service.ts:69-84`, and it is **fail-closed** (an empty scope yields `1=0`, documented at `:33-36`).

### Any financial query without a tenant predicate?

**None found.** Every read in `ledger.repository.ts` (8 methods), `agreement-transaction.repository.ts`, `on-invoice.repository.ts`, `sales-actuals.repository.ts`, and `budget.repository.ts` takes `tenantId` as a required parameter and applies it. The two aggregate methods that produce balances both carry it explicitly — `ledger.repository.ts:118-121`:

```ts
      .where('ledger.agreementId = :agreementId', { agreementId })
      .andWhere('ledger.tenantId = :tenantId', { tenantId })
      .andWhere('ledger.deletedAt IS NULL')
```

**Assessment:** the discipline is good and consistent, but it is discipline. One forgotten `.andWhere` is a cross-tenant financial leak with no database backstop.

---

## A8 — Reporting / projections

**No R1–R7 implementation, no projection table, no fact table, and no gross-to-net view.** A search for `\bR[1-7]\b` yields nothing meaningful, matching TTM.

What exists:

- **`FinanceReportingModule` — wired and live** (`app.module.ts:57`), consumed by `DashboardModule` (`dashboard.module.ts:27`). Contains `finance-reporting.service.ts`, a controller, DTOs including `budget-variance-report.dto.ts`, and a spec. Its documented source of truth is the ledger — `budget-variance-report.dto.ts:16`:

```ts
 *   - `consumed`  = GERÇEKLEŞEN: ledger_entries üzerinden DEBIT-CREDIT (fiilen
```

- **One DB view:** `budget_summary` (`budget-summary.view-entity.ts`, migrations `1704067740000-CreateBudgetSummaryView`, `1789000000000-FixBudgetSummaryCommitDoubleCounting`). This is the closest thing to a projection — a budget-side aggregate, not a gross-to-net or recognition view.

- **`ReportingModule` — dead code.** `src/modules/shared/reporting/reporting.module.ts` is an empty shell whose JSDoc promises "Budget utilization reports, Spend analytics, Agreement/Plan performance metrics, Custom report generation":

```ts
@Module({
  imports: [],
  controllers: [],
  providers: [],
  exports: [],
})
export class ReportingModule {}
```

It is **not imported by `app.module.ts`** — the only `ReportingModule` references anywhere are `FinanceReportingModule`. **DIVERGENT**: the docblock describes four capabilities; the module provides none and is not routed.

---

## A9 — Tests

| | Count |
|---|---|
| Unit/integration specs (`src/**/*.spec.ts`) | **45** |
| E2E specs (`test/*.e2e-spec.ts`) | **12** |
| Framework | Jest (both; e2e via `test/jest-e2e.json` + `global-setup.js`/`global-teardown.js`) |

**E2E suite** — the ADR's top port priority, and it is real:

```
auth · budget-envelope-split · budget-variance · dashboard · kpi-optimistic-locking
optimistic-locking · recalc-perf-regression · reversal · role-journey
sales-actuals · settlement · settlement-budget-release
```

**Financial-correctness coverage:**

```
src/modules/modes/actuals-first/ledger/ledger.repository.spec.ts
src/modules/modes/actuals-first/reversal/reversal.service.spec.ts
src/modules/modes/actuals-first/reversal/reversal.guard.spec.ts
src/modules/modes/actuals-first/settlement/settlement-summary.service.spec.ts
src/modules/modes/actuals-first/settlement/settlement-close.service.spec.ts
src/modules/modes/actuals-first/settlement/settlement.guard.spec.ts
src/modules/modes/actuals-first/agreement-transaction/agreement-transaction.service.spec.ts   ← UNTRACKED
src/modules/modes/actuals-first/on-invoice/on-invoice.service.spec.ts                          ← UNTRACKED
src/modules/modes/actuals-first/sales-actuals/{sales-actuals.service,…validation.service,…module}.spec.ts
src/modules/shared/budget/{budget.service,budget-threshold.service,budget-reservation.service,budget-allocation.service}.spec.ts
src/modules/shared/spend-calculation/spend-calculation.service.spec.ts
src/modules/shared/finance-reporting/finance-reporting.budget-variance.service.spec.ts
```

**Invariant tests: yes, and they are the strongest testing asset in either repo.** Files containing explicit invariant assertions:

```
test/budget-envelope-split.e2e-spec.ts
test/settlement-budget-release.e2e-spec.ts
test/optimistic-locking.e2e-spec.ts
test/kpi-optimistic-locking.e2e-spec.ts
src/modules/shared/budget/budget.service.spec.ts
src/modules/shared/spend-calculation/spend-calculation.service.spec.ts
src/modules/modes/planning-first/plan/plan.repository.spec.ts
```

TTM has one comparable file (`ledger.invariants.spec.ts`). Collmind-TPM asserts invariants at the **E2E** level, against a real database — a stronger guarantee.

**Property-based tests: none.** No `fast-check` or generative testing in either repo. All invariant tests are example-based.

**Two caveats.** (a) The two most directly relevant specs — `agreement-transaction.service.spec.ts` and `on-invoice.service.spec.ts` — are **untracked**, so the committed baseline has *no* unit coverage of the CAP check or the on-invoice ledger post. (b) No test covers the conservation gap at `agreement-transaction.service.ts:148` (envelope-not-found → silent no-ledger).

---

# Part B — Port completeness vs TTM

## B1 — Ported inventory

| Area | Verdict | Evidence |
|---|---|---|
| **Ledger entry types and semantics** | `NOT_APPLICABLE` | Deliberately different model, not a port target. CTPM: `spend_type` × `entry_direction` (`ledger-entry.entity.ts:8-19`) + separate `budget_transactions` for lifecycle. TTM: single `entry_type` enum incl. RESERVE/CONSUME (`InitMvpSchema.ts:23`). ADR 0001 chose CTPM's architecture; converging the enums was never in scope. |
| **Budget envelopes and envelope resolution** | `PORTED` (+ahead) | `findEnvelopeByDimensions(tenant, channel, period, category?)` at `agreement-transaction.service.ts:143`, `on-invoice.service.ts:437`. CTPM adds on/off-invoice split (`budget-allocation` generated columns) TTM cannot express. |
| **RESERVE / CONSUME / RELEASE flow** | `PORTED` (+ahead) | `budget-reservation.service.ts`, `budget.service.ts` (`reserveTypedForPlan`, commit at `:735`), E2E `settlement-budget-release.e2e-spec.ts`. Registry K10 marks this ✅ in TTM too. |
| **CAP enforcement points** | `PARTIAL` | **2** points (`agreement-transaction.service.ts:102`, `off-invoice-validation.service.ts:252`) vs TTM's 5. Agreement-level not tactic-level; mandatory not optional; **ON_INVOICE entirely exempt**. |
| **Settlement base resolution** | `NOT_PORTED` | Zero hits for `settlementBase|NET_SALES|GROSS_SALES|LIST_PRICE_X_VOL`. TTM: `AgreementsV0.ts:11` + `calculateExpectedAmount` (`actuals.service.ts:1263`). |
| **Claim generation (ON and OFF)** | `NOT_PORTED` | **No claim entity exists** (`ls src/database/entities | grep -i claim` → nothing). TTM has `agreement_claims` + `generateActualsClaims`. CTPM's `agreement_transactions` is a manual-entry table, not generated output. |
| **Actuals ingestion + replace/immutability** | `PORTED` (+ahead) | `sales-actuals/` module, `1785000000000-CreateSalesActualsTables`. **Better than TTM**: explicit `REPLACED` status with `replacedByBatchId` + `replacedAt` version chain (`sales-actual-batch.entity.ts:18-19,:37-38,:123-128`) vs TTM's flat ACTIVE flag. E2E: `sales-actuals.e2e-spec.ts`. |
| **Invoice matching and tolerance** | `NOT_PORTED` | No invoice entity, no `attemptAutoMatch`, no `match_status` in CTPM. Zero hits for `tolerance`. *(TTM also lacks tolerance — that half is a gap in both.)* |
| **Approval workflow + self-approval guard** | `PORTED` | `shared/approval/approval.service.ts:113` "Self-approval prevention (BRD EA-001)"; `approval-workflow.service.ts:370` "Self-approval prevention"; module doc `approval.module.ts:17`. |
| **Agreement model (STA/LTA, validity, tactic hierarchy)** | `PARTIAL` | STA/LTA present (`agreement.entity.ts:14-16`) plus dedicated `lta_agreements`/`lta_rates`/`lta_plan_overrides` TTM lacks. **Missing**: settlement base, tactic→FU hierarchy driving settlement. CTPM agreements carry a single `tacticId`/`fuId`, not a tactic set. |
| **Master data (CPL, FU, category, channel)** | `PORTED` (+ahead) | Full normalised entities: `cpl`, `forecasting-unit`, `generic-unit`, `category`, `channel`, `region`, `brand`, `sku`, `tactic`, `mechanic`. TTM uses free-text `category` strings as join keys. |
| **RBAC / role model** | `PARTIAL` | `UserRole` enum + `@Roles()` guard + `AccessScopeService` (fail-closed, single scope point) + `user_scope` entity + `1791000000000-ConsolidateRolesToBrd`. **Missing**: TTM's typed `ROLE_PERMISSIONS` permission map (11 named permissions). Role vocabularies still differ. |
| **E2E and unit test suites** | `PORTED` | 12 e2e + 45 unit. ADR's #1 priority ("E2E kapsamı sıfıra yakın") is closed. |

**Totals: 6 PORTED · 4 PARTIAL · 2 NOT_PORTED · 1 NOT_APPLICABLE.**

## B2 — Port fidelity

Where an area is `PORTED`, behaviour is **not** identical. Divergences, all visible rather than hidden:

1. **Actuals replace semantics — CTPM is stricter.** TTM flips a batch `status` to non-`ACTIVE`; CTPM records a full version chain (`replacedByBatchId`, `replacedAt`) with an explicit immutability docblock (`sales-actual-batch.entity.ts:37-38`: "REPLACE hard-delete yapmaz"). Same decision (K44), stronger audit.

2. **Actuals grain — CTPM is coarser.** `sales-actual.entity.ts:7-10`:
   ```ts
    * satış TUTAR agregası (T-020). FU/SKU ve hacim boyutu YOKTUR — Wella actuals
    * CSV'sinde `fu_code`/`volume` kolonları bulunmuyor
   ```
   CTPM: CPL × Category × Channel × Period. TTM: additionally FU and volume. **This forecloses `PER_UNIT` tactic settlement**, which TTM supports (`calculateExpectedAmount` `PER_UNIT` branch).

3. **Envelope resolution dimensions differ.** Off-invoice resolves on `(channel, fiscalPeriod)` only — `agreement-transaction.service.ts:143` passes no category. On-invoice passes category — `on-invoice.service.ts:437`. **The two paths resolve envelopes differently within the same system**, undocumented.

4. **Reversal is richer in CTPM.** Compensating CREDIT + self-FK + app guard + `reversal.e2e-spec.ts`. TTM's reversal is a `reversals/` module without a self-referential link on the entry.

5. **CAP behaviour is a third variant** — reject, vs TTM skip (K43) or clamp (K43-R).

6. **Idempotency is broader in CTPM.** Unique `(tenant_id, idempotency_key)` on *every* ledger entry; TTM guards only `CONSUME` via a later partial index.

## B3 — Port-introduced hazards

The prompt's known candidate is **confirmed and is the most serious finding in this report** — with the mechanism differing from the one hypothesised.

**H1 — Append-only assumption on a soft-deletable ledger.** TTM's ledger has no `deleted_at`; CTPM's inherits one from `BaseEntity` (`base.entity.ts:23-24`). Ported reasoning that treats ledger rows as immutable is layered onto a table that TypeORM will happily soft-delete, and whose every read filters `deletedAt IS NULL`. Today nothing calls soft-delete on `LedgerEntry` — but ~20 sibling entities do, so the idiom is one autocomplete away. **No DB-level protection exists.**

**H2 — 🔴 Schema-unqualified migration guards silently skipped a financial constraint.** (Full evidence in A1.) `1777000000000-LedgerReversalSupport.ts:33-37,:52-56` checks `pg_constraint`/`pg_indexes` by **name only**. Because TTM's `public` schema coexists in this database with identically-named objects, both guards matched and skipped. Net effect: `main.ledger_entries` has the reversal *columns* but neither the self-FK nor `UQ_ledger_entries_reversal_per_tenant`, while `main.migrations` records the migration as applied. **This is a port-introduced hazard in the literal sense: it exists only because both codebases' schemas share a cluster.**

**H3 — Columns TTM's code writes that do not exist here.** TTM's on-invoice claim insert writes `cap_clamped` and `original_computed_amount` (`actuals.service.ts:1486-1487`). CTPM has no `agreement_claims` table at all, so any lifted claim-generation logic will fail at compile time (loud) — **not** a silent hazard, but it means claim generation cannot be ported incrementally; the table must come first.

**H4 — Columns here that TTM's code never accounted for.** `entry_direction` (DEBIT/CREDIT) has no TTM analogue. Any ported logic that sums `amount` without the direction CASE will **double-count reversals as spend**. Both existing aggregates handle it correctly (`ledger.repository.ts:112-122,:139-147`) and carry regression notes, but this is exactly the trap for the next ported aggregate. **Silent wrong number.**

**H5 — `spend_type` is unconditional on the on-invoice path.** `on-invoice.service.ts:453` hardcodes `spendType: SpendType.ON_INVOICE` while the envelope lookup at HEAD passes no spend type. The working-tree delta (T-057) is precisely the fix. Pre-fix, an on-invoice post could land in an off-invoice envelope on a split dimension.

## B4 — Not-yet-ported risk ranking

**Ranked by silence first, as required. Silent wrong numbers outrank loud failures.**

### 🔴 Tier 1 — SILENT WRONG NUMBERS (highest priority)

1. **Off-invoice envelope-not-found → spend vanishes from the ledger.** (`agreement-transaction.service.ts:148-170`, A4 branch #1.) Not a port gap but a live defect: transaction committed, no ledger entry, `200 OK`. Budget reports understate spend by exactly this amount, while the CAP check — which sums `agreement_transactions` — still counts it. **The two subsystems silently disagree.** No error, no log, no test.

2. **Concurrent double-reversal.** (A1 defect / H2.) The DB uniqueness guard is absent from `main.ledger_entries`; only a read-then-write app check stands between two concurrent reversals and two CREDITs for one DEBIT. Result: understated spend, overstated available budget. **Nothing surfaces it.**

3. **Direction-unaware aggregation in future ported code.** (H4.) Any new `SUM(amount)` that omits the DEBIT−CREDIT CASE counts reversals as spend. Silent, and the trap is invisible to someone reading TTM code where the axis does not exist.

4. **Sales actuals feed nothing.** `SalesActual` is referenced only by its own module, seeds, migrations, and the DataSource config — **no settlement, claim, recognition, budget, or reporting consumer**. Operators upload actuals and see a successful ingest; no financial figure anywhere changes. The failure mode is "the number never moved", which reads as "no promotions this period" rather than as a defect.

5. **Ledger soft-delete surface.** (H1.) No caller today; a single future `softRemove` silently removes money from every balance.

### 🟠 Tier 2 — VISIBLE-BUT-WRONG

6. **CAP asymmetry.** ON_INVOICE bypasses CAP entirely. Caps appear enforced (they are, on one path) while on-invoice spend passes uncapped. Visible if someone reconciles; invisible otherwise. Contradicts K30.
7. **CAP is agreement-level and mandatory.** Contradicts K29 (tactic-level) and K31 (optional/null). Every agreement must carry a cap; per-tactic ceilings are inexpressible.
8. **Envelope resolution dimensions differ between the two paths.** (B2 #3.) On-invoice matches on category, off-invoice does not — so the same logical budget can resolve to different envelopes.

### 🟡 Tier 3 — LOUD FAILURES / NO EFFECT YET

9. **Settlement base — NOT_PORTED.** No effect today: nothing computes an expected amount, so there is no wrong number. Blocks `SETTLEMENT_SPEC.md` entirely.
10. **Claim generation — NOT_PORTED.** No effect today; the concept is absent, so nothing produces a wrong claim. Loud at porting time (missing table).
11. **Invoice matching — NOT_PORTED.** No effect today.
12. **RBAC permission map — PARTIAL.** Role checks work; they are just less granular. Loud when a role needs splitting.
13. **CAP exceeded → `BadRequestException`.** Loudest possible behaviour. Lowest risk.

---

# Part C — K1–K45 tenant coupling

## Registry location and a divergence in this prompt's summary

The registry was found at **`TTM/docs/decisions/DECISION_REGISTRY.md`** (mirrored at `TTM/obsidian-vault/TPM/02_DECISIONS.md`). It is complete — K1 through K45.

**⚠️ DIVERGENT — this prompt's K-list disagrees with the registry on four rows.** Code is ground truth for "what is"; the registry is ground truth for "what was decided". Both are quoted:

| # | This prompt says | Registry actually says |
|---|---|---|
| **K7–K12** | "deferred to Phase-2" | **"⚠️ REVİZE EDİLDİ"** — all six now ✅ implemented in Phase-1. `K7: **REVİZE:** Phase-1'de CAP enforcement aktif (6 lokasyon, HARD BLOCK)` |
| **K23** | "Match key: CPL + FU + Period + Tactic Type" | **"⚠️ Deprecated: canlı sistemde recognition grain `period + CPL + category + channel` seviyesindedir. FU-based matching henüz aktif değildir."** |
| **K32** | "ON_INVOICE claims are expected-based, independent of actual discount" | K32 is **"Seed Budget Envelopes"** — `Budget envelopes seed data'da zorunlu (yoksa approval 500 verir)`. The prompt's description matches no registry row. |
| **K43** | "CAP exceeded → skip the claim, do not clamp" | Superseded by **K43-R** (2026-05-05): `CAP_EXCEEDED = claim is clamped to remaining CAP… cap_clamped=true, original_computed_amount=6000`. The registry states plainly: "K43 originally recorded the observed hard-skip behavior. K43-R revises that policy". |

Notably, the **deprecated K23 grain — `period + CPL + category + channel` — is exactly `sales_actuals`'s grain in Collmind-TPM** (`sales-actual.entity.ts:25-31`). The two codebases converged on the same coarser grain independently.

## Classification table

Assessed against `collmind.backend` @ `b122a6e6`.

| # | Wella decision | Classification | Evidence |
|---|---|---|---|
| **K3** | Invoice tolerance ±5%, configurable | `ABSENT` | Zero hits for `tolerance` in `src`. No invoice entity. |
| **K6** | Period tolerance +2 months auto, then soft warning | `ABSENT` | No period-tolerance logic. Fiscal period is resolved by a 3-level fallback (`agreement-transaction.service.ts:108-122`) with no tolerance window. |
| **K7–K12** | Budget/envelopes/ledger (registry: implemented Phase-1) | `CONFIGURABLE`-adjacent / **implemented** | `budget_envelopes`, `budget_allocations`, `budget_reservations`, `budget_transactions`, `main.ledger_entries` all live; RESERVE/COMMIT/RELEASE in `budget.service.ts`. Not tenant-specific — product infrastructure. |
| **K20** | Sales data: Gross+Net or Gross+OnInvoice | `CONFIGURABLE` | `sales_actuals` accepts `gross_amount` (required) with `net_amount` and `discount_amount` both **optional** (`sales-actuals-validation.service.ts:175-196`), and mismatch is warning-only (`:74-76`). Both shapes accepted; neither hardcoded. |
| **K22** | On-invoice claims auto-created as SETTLED | `DIFFERENT` | No claims. On-invoice entries reach `POSTED` (`on-invoice-entry.entity.ts:15-18`), and the ledger DEBIT is written immediately — economically equivalent to auto-settle, but via a different object with a different status vocabulary. |
| **K23** | Match key CPL+FU+Period+Tactic *(registry: deprecated)* | `ABSENT` | No matching of any kind — zero hits for `matchKey`/`CPL + FU`. FU is not even a dimension of `sales_actuals`. |
| **K25** | Overlapping agreements → proportional by tactic rate | `ABSENT` | No allocation, no expected amount, no agreement lookup on the on-invoice path (A3). |
| **K26** | OVER: expected→MATCHED, excess shown separately | `ABSENT` | No buckets in any enum (A3). |
| **K28** | One claim per tactic | `ABSENT` | No claim entity. Agreements carry a single `tacticId`, so the concept has no home. |
| **K29** | CAP at tactic level | `DIFFERENT` | CAP is **agreement-level**: `cap_total_amount` on `agreements` (`agreement.entity.ts:126-131`). |
| **K30** | Both ON and OFF consume tactic CAP | `DIFFERENT` | Only OFF consumes CAP; ON_INVOICE bypasses it entirely (A5). |
| **K31** | CAP optional; null = unlimited | `DIFFERENT` | **`isNullable: false`** (`1704067800000-CreateAgreements.ts:148-153`). CAP is mandatory; unlimited is inexpressible. |
| **K32** *(as described in prompt)* | ON_INVOICE expected-based, independent of actual | `DIFFERENT` | Collmind-TPM is the **exact inverse** — on-invoice is *actual*-based: `amount: entry.discount` (`on-invoice.service.ts:454`). |
| **K32** *(as in registry)* | Seed budget envelopes mandatory | `HARDCODED` | Envelope existence gates the ledger write (`agreement-transaction.service.ts:150` `if (envelope)`, `on-invoice.service.ts:439`). Missing envelope → silent skip / `ERROR` row. |
| **K43 / K43-R** | CAP exceeded → skip *(revised: clamp)* | `DIFFERENT` | Neither. CAP exceeded → **`BadRequestException`**, request rejected (`agreement-transaction.service.ts:103-105`). |
| **K44** | Same-scope actuals: last upload wins | `HARDCODED` | Implemented, with a stronger audit chain than TTM: `SalesActualBatchStatus.{ACTIVE,REPLACED}` + `replacedByBatchId` + `replacedAt` (`sales-actual-batch.entity.ts:18-19,:123-128`), enforced by a partial unique index (one ACTIVE per scope — `sales-actuals.service.ts:199-201`). The policy is fixed in the schema; a tenant wanting "first upload wins" or "merge" cannot configure it. |
| **K45** | Actuals uploader cannot approve own claims | `CONFIGURABLE`-adjacent / **implemented generically** | `approval.service.ts:113` "Self-approval prevention (BRD EA-001)"; `approval-workflow.service.ts:370`. Implemented as a **general** submitter≠approver rule, not an actuals-specific one — so it is product policy, not tenant policy. |

**Tally: 2 HARDCODED · 5 DIFFERENT · 8 ABSENT · 2 CONFIGURABLE(-adjacent).**

## Ranked HARDCODED list

Only two, ranked by cost to make configurable:

**1. K44 — "last upload wins" for same-scope actuals. *(Harder)***
`sales-actual-batch.entity.ts:18-19,:123-128` + the partial unique index permitting one `ACTIVE` batch per `(tenant, period, cpl, category, channel)`, plus the ordering-critical REPLACE sequence (`sales-actuals.service.ts:199-201`: *"KRİTİK SIRA: partial unique index aynı scope'ta yalnızca TEK ACTIVE satıra izin verir"*). Making this configurable means relaxing a **uniqueness constraint** that current correctness depends on, then teaching every consumer which batch is authoritative. Schema change + query change + new conflict-resolution semantics. **Cost: high.**

**2. K32(registry) — budget envelope must pre-exist for spend to post. *(Easier)***
`agreement-transaction.service.ts:150` (`if (envelope)`) and `on-invoice.service.ts:439`. A tenant wanting auto-provisioned envelopes, or wanting spend to post to a catch-all, cannot have it. This is two `if` statements and a fallback-resolution policy — no schema change. **Cost: low.** *(Fixing this also closes Tier-1 risk #1, since the silent-skip branch is the same `if`.)*

**Interpretive note, stated plainly.** Two HARDCODED items out of seventeen looks like excellent multi-tenant hygiene, and the zero occurrences of the pilot tenant UUID support that. But eight of the seventeen are `ABSENT` — and a decision cannot be hardcoded into a feature that does not exist. **The low coupling is substantially a by-product of unbuilt functionality, not of deliberate generalisation.** When recognition, buckets, tactic-level CAP, and claims are built, each will present the same fork risk the registry documents for TTM. The right conclusion is that Collmind-TPM is *well positioned* to stay generic — not that it has already proven it can.

---

# Working-tree delta

**Uncommitted at audit time: 685 insertions / 29 deletions across 8 tracked files, plus 2 untracked specs (352 lines).** Ticket: **T-057**, per the inline comments. None of Parts A–C reflects this code.

```
 agreement-transaction.service.ts   |  64 ++++++-
 on-invoice.service.ts              |  11 +-
 approval-workflow.service.ts       |   9 +
 plan.service.spec.ts               | 165 ++++++++++++++++++
 plan.service.ts                    | 190 ++++++++++++++++++++-
 budget.repository.ts               |  31 +++-
 budget.service.spec.ts             | 136 +++++++++++++++
 budget.service.ts                  | 108 ++++++++++--
 8 files changed, 685 insertions(+), 29 deletions(-)
?? agreement-transaction.service.spec.ts   (238 lines)
?? on-invoice.service.spec.ts              (114 lines)
```

### How it changes the findings above

**A3 / H5 — on-invoice envelope lookup becomes spend-typed.** The lookup now passes `BudgetSpendType.ON_INVOICE`:

```ts
+          // T-057 madde 4 (ölçüm sonucu, docs/analysis/0008 §5.7): this
+          // service is unconditionally ON_INVOICE — … the ledger entry
+          // created below has ALWAYS hardcoded `spendType:
+          // SpendType.ON_INVOICE` (line ~453, pre-existing, unrelated to
+          // this fix). The envelope lookup was simply never told what the
+          // ledger row already knows.
           const envelope = await this.budgetService.findEnvelopeByDimensions(
             tenantId, channel, entry.fiscalPeriod, category,
+            BudgetSpendType.ON_INVOICE,
           );
```

**This closes hazard H5.** It does **not** touch recognition, buckets, or allocation — A3's verdict is unchanged.

**A2 / A4 — off-invoice envelope lookup becomes agreement-spend-type-aware, and the BOTH case now fails loudly.** `agreement-transaction.service.ts` gains a typed/untyped split, and — significantly for Tier-1 risk #1 — the ambiguous case now **throws instead of silently mis-attributing**:

```ts
+      // BOTH or NULL — split detection derives from THIS SAME unqualified
+      // call's own guard … SPLIT dimension: cap's on/off split is unknown
+      // (BRD has no evidence for how BOTH divides, §5.7) — reject rather
+      // than silently mis-attributing to one arbitrary twin.
       try {
         envelope = await this.budgetService.findEnvelopeByDimensions(…);
       } catch (err) {
         if (isSplitDimensionGuardError(err)) {
           throw new BadRequestException({
```

This converts one silent path into a loud one — the correct direction. **It does not fix Tier-1 risk #1**, which is the `if (envelope)` with no `else` on the *not-found* path, still present.

**A9 — coverage improves materially.** The two untracked specs add unit coverage for exactly the two services with none at HEAD: the CAP check and the on-invoice ledger post.

**A5 — unchanged.** No CAP logic is touched. ON_INVOICE remains CAP-exempt.

**A1 — unchanged.** No ledger code is touched; the H2 migration defect persists.

---

# Invariant candidates

Direct input to `SYSTEM_INVARIANTS.md`. Each is a single testable sentence. Observed-and-holding are marked ✅; observed-but-violated are marked 🔴 and detailed in the next section.

1. ✅ No statement in the codebase may modify `ledger_entries.amount`, `entry_direction`, `budget_envelope_id`, or `period_month` after insert.
2. ✅ The only permitted mutation of an existing ledger row is setting `is_reversed` from `false` to `true`.
3. 🔴 No ledger row may ever have a non-null `deleted_at`.
4. ✅ Every reversal is a new row with the opposite `entry_direction`, an equal absolute `amount`, and `reverses_entry_id` pointing at the original.
5. 🔴 At most one non-deleted reversal row may exist per `(tenant_id, reverses_entry_id)`.
6. ✅ Every ledger insert carries a non-empty `idempotency_key` unique within its tenant.
7. ✅ An agreement's consumed spend equals `Σ DEBIT − Σ CREDIT` over its non-deleted ledger rows, and is never computed as a plain `SUM(amount)`.
8. 🔴 Every committed `agreement_transactions` row has exactly one corresponding ledger DEBIT with idempotency key `LEDGER|AGREEMENT|{agreementId}|{transactionId}`.
9. ✅ Every `on_invoice_entries` row in a `COMPLETED` batch is either `POSTED` with a corresponding ledger DEBIT, or `ERROR` with a non-empty `validation_errors` array.
10. ✅ The sum of ledger DEBITs created from an on-invoice batch equals the sum of `discount` over that batch's `POSTED` entries.
11. 🔴 An agreement's total off-invoice transaction value never exceeds its `cap_total_amount`.
12. ✅ No financial query executes without a `tenant_id` predicate.
13. ✅ A user may not approve a request they submitted.
14. ✅ At most one `sales_actual_batches` row is `ACTIVE` per `(tenant, fiscal_period, cpl, category, channel)`.
15. ✅ A replaced sales-actuals batch is never deleted; it transitions to `REPLACED` with `replaced_by_batch_id` and `replaced_at` set.
16. ✅ `sales_actuals.discount_amount` never contributes to any ledger entry, budget reservation, or spend figure.
17. ✅ A sales-actuals row is rejected if `net_amount > gross_amount`.
18. ✅ Batch-ordered financial processing iterates in ascending source row number, never in an order derived from a generated identifier.
19. 🔴 Every migration recorded in `main.migrations` has had all of its DDL effects applied to the `main` schema.
20. 🔴 An on-invoice ledger entry is always attributed to an envelope whose spend type is `ON_INVOICE`. *(holds only with the uncommitted T-057 delta)*
21. ✅ Reversing an already-reversed entry is rejected with `ALREADY_REVERSED`.
22. 🔴 Tenant isolation is enforced by the database, not only by application predicates.

# Invariant violations

| # | Invariant | How it is violated today | Visibility |
|---|---|---|---|
| **3** | No ledger row has non-null `deleted_at` | `@DeleteDateColumn` is active on the ledger via `BaseEntity` (`base.entity.ts:23-24`); ~20 sibling entities call `softRemove`. No DB constraint prevents it; every projection filters it. Not exercised today. | Silent if it ever happens |
| **5** | ≤1 reversal per original | `UQ_ledger_entries_reversal_per_tenant` **absent from `main.ledger_entries`** (verified live). Only the read-then-write guard at `reversal.service.ts:137-144` stands. Concurrent requests can both pass. | 🔴 **Silent** |
| **8** | Every tx has a ledger DEBIT | `agreement-transaction.service.ts:148-170` — `if (envelope) { … }` with no `else`. Envelope-not-found ⇒ tx committed, no ledger entry, `200 OK`. | 🔴 **Silent** |
| **11** | Off-invoice total ≤ CAP | Holds for off-invoice. **Violated in spirit for on-invoice**, which posts spend with no CAP check at all (`on-invoice.service.ts:327-450`). Also: CAP sums `agreement_transactions` while spend reporting sums the ledger — after a violation of #8 the two disagree. | Partly silent |
| **19** | Recorded migrations are fully applied | `LedgerReversalSupport1777000000000` is in `main.migrations`; its FK and unique index exist only on `public.ledger_entries`. Schema-unqualified guards (`:33-37`, `:52-56`) matched TTM's objects. | 🔴 **Silent** |
| **20** | On-invoice entry → on-invoice envelope | At HEAD, `findEnvelopeByDimensions` is called without a spend type (`on-invoice.service.ts:437`) while the ledger row hardcodes `ON_INVOICE`. Fixed only in the uncommitted delta. | Silent |
| **22** | DB-enforced tenant isolation | 0 RLS policies, 0 tables with `rowsecurity`. Application predicates only. | Silent on failure |

---

# Determinism risks

1. **Floating-point money in TypeScript.** All amounts are `number`. `DecimalTransformer` exists but is **not** applied to `ledger_entries.amount`. `parseFloat` at `ledger.repository.ts:123,147`; `Number()` comparisons at `agreement-transaction.service.ts:102` and throughout `budget.service.ts`. The CAP boundary (`currentTotal + dto.amount > cap`) can flip on representation error at the exact cap.
2. **No defined rounding mode.** No `Math.round`/`toFixed`/decimal library on the ledger write path; `numeric(18,2)` coercion at insert is the de-facto rule, never stated.
3. **`Object.entries()` over tactic/KPI maps** in `spend-calculation.service.ts:539,664,824,832` and `agreement.service.ts:1279,1311`. Sums are commutative in exact arithmetic but **not** in floating point — accumulation order can change the last cents.
4. **Untied `createdAt DESC` ordering** on ledger read paths (`ledger.repository.ts:42,52,91`). Entries written in one transaction share a timestamp; display order is unspecified. No amount depends on it.
5. **`findDebitEntryByAgreementId`** (`:163-172`) takes the oldest unreversed DEBIT — the repository's own JSDoc calls this "ambiguous when an agreement has multiple transactions (batch import)" and deprecates it.
6. **Fiscal-period 3-level fallback** (`agreement-transaction.service.ts:108-122`): DTO → agreement `periodMonth` → derived from invoice date via `getFullYear()`/`getMonth()`, which are **local-timezone** operations. The same invoice can land in different fiscal months on servers in different timezones.
7. **Cross-schema migration guards** (H2). Migration outcome depends on what else lives in the database — environment-dependent by construction.
8. **`spendType` absent from envelope resolution at HEAD** — which envelope an on-invoice post lands in depends on undocumented tie-breaking on split dimensions.

---

# Spec gaps

Everything currently implicit, undefined, or environment-dependent. Numbered for `SYSTEM_INVARIANTS.md` intake.

1. **Append-only enforcement.** Decide whether it is a DB guarantee (trigger/rule/revoked grants) or an application convention. If DB: what to do about `deleted_at`, which should arguably not exist on this table.
2. **Ledger soft-delete.** Remove the column from the ledger, or define exactly who may set it and how balances account for it.
3. **Settlement base.** No concept exists. Define the base types, per-agreement vs per-tactic scope, and the resolution rule. Greenfield.
4. **Expected-amount computation.** Nothing computes expected spend. Required before any recognition, bucket, or K25 work.
5. **Recognition buckets.** `MATCHED`/`OVER`/`UNDER`/`NON_TPM`/`UNALLOCATED` do not exist. Choose one identifier for the last (documentation uses two), define DB enum, TS enum, and storage.
6. **Whether `sales_actuals.discount_amount` may ever drive recognition.** Currently forbidden by design with a double-counting rationale (`sales-actual.entity.ts:12-17`). Any recognition spec must either overturn this or reconcile with it.
7. **ON vs OFF ordering.** Two independent endpoints, no orchestrator. Define whether an ordering is required.
8. **CAP scope.** Agreement-level today; K29 says tactic-level. Decide, and if tactic-level, define how it interacts with the agreement cap.
9. **CAP optionality.** `cap_total_amount NOT NULL` contradicts K31. Decide whether unlimited must be expressible.
10. **CAP on the on-invoice path.** Currently exempt. Decide whether already-granted discounts may ever be refused — the same question K25 §Q8 raised for TTM, unanswered in both.
11. **CAP exceedance behaviour.** Three variants exist across the estate (TTM skip / K43-R clamp / CTPM reject). Pick one.
12. **CAP source of truth.** CAP sums `agreement_transactions`; reporting sums the ledger. Define which is authoritative and require them to agree.
13. **Envelope-not-found policy.** Define the behaviour for every path: reject, auto-provision, catch-all envelope, or persisted exception. Currently silent-skip (off-invoice) vs persisted `ERROR` (on-invoice) — two answers in one system.
14. **Envelope resolution dimensions.** Off-invoice resolves on `(channel, period)`; on-invoice adds category. Define one dimension set.
15. **Numeric contract.** Integer minor units, a decimal library, or SQL-side arithmetic. Apply `DecimalTransformer` (or its successor) uniformly, starting with `ledger_entries.amount`. State the rounding mode.
16. **Actuals grain.** `sales_actuals` has no FU or volume dimension by design. This forecloses `PER_UNIT` tactics. Decide whether that is permanent.
17. **Claim model.** No claim entity exists. Decide whether claims are a first-class object (TTM) or whether `agreement_transactions` + ledger suffice.
18. **Invoice matching and tolerance.** Absent in both codebases. K3 (±5%) and K6 (+2 months) are unimplemented anywhere.
19. **Tenant isolation.** Decide whether RLS is required. If yes, it is greenfield in both codebases.
20. **Role vocabulary and permission granularity.** CTPM has roles; TTM has a typed permission map. Define the product's permission set.
21. **Migration hygiene.** Require every catalogue guard to be schema-qualified, and define how a migration's *effects* (not just its recorded name) are verified.
22. **Fiscal period derivation.** Define UTC vs local, and remove the timezone dependency at `agreement-transaction.service.ts:118-121`.
23. **Reporting surface.** R1–R7 exist in neither codebase. `ReportingModule` is an empty unwired shell whose docblock promises four capabilities.
24. **Idempotency key formats.** Three literal formats are in use (`LEDGER|AGREEMENT|…`, `LEDGER|ON_INVOICE|…`, `REVERSAL|LEDGER|…`), defined only at their call sites. Specify them as a contract.
25. **`spendType` semantics for `BOTH`/null agreements.** The uncommitted T-057 comment states outright: *"BRD has no evidence for how BOTH divides"*. This is an open product question the code has flagged and worked around by rejecting.

---

# Open questions

1. **Is the `UQ_ledger_entries_reversal_per_tenant` absence specific to this developer database, or does it affect every environment provisioned since 2026-06?** *Needed:* run the same `pg_indexes` query against staging/production. Any environment whose database does not also host TTM's `public` schema should have the index; any that does, will not.
2. **Has the envelope-not-found silent skip (Tier-1 #1) ever fired in practice?** *Needed:* `SELECT count(*) FROM main.agreement_transactions t WHERE NOT EXISTS (SELECT 1 FROM main.ledger_entries l WHERE l.idempotency_key = 'LEDGER|AGREEMENT|'||t.agreement_id||'|'||t.id)`. Not run here (read-only scope permits it, but the result would be meaningless on a dev database with 1,231 mixed-provenance ledger rows).
3. **Is the on-invoice CAP exemption deliberate?** It is defensible — arguably more correct than TTM. But no ADR, comment, or test records the intent. *Needed:* a product decision, recorded.
4. **Do `main.migrations` (54) and the repo's migration files (54) correspond one-to-one?** Counts match, but H2 proves that "recorded" ≠ "applied". *Needed:* a schema diff of a freshly migrated database against the current one.
5. **Is `ReportingModule` intended to be built out or deleted?** It is unwired and empty but its docblock describes four capabilities.
6. **What is the intended relationship between `sales_actuals` and the ledger?** Today, none — the table is quarantined by design. If recognition is built, that quarantine must be revisited, and the T-003/T-017 double-counting history it cites is essential context. *Needed:* the design document referenced as `docs/analysis/0008 §5.7` and the T-003/T-017 tickets.
7. **Does `collmind.frontend` surface any of the absent capabilities?** Frontend was not audited beyond preflight — it is clean at `5cf0bd2b` and out of scope for financial correctness.
8. **Which container is authoritative for Collmind-TPM?** See below.

---

# Environment notes

| Container | Image | Port | Status | DB | Serves |
|---|---|---|---|---|---|
| `collmind-tpm-postgres` | `postgres:16` | 5434 | Up | `collmind_tpm` | **both** `main` (Collmind-TPM) and `public` (TTM) schemas |
| `collmind-postgres` | `postgres:15-alpine` | 5433 | **Exited, 5 days** | `collmind_tpm` | TTM |

**This is the root cause of H2 and it is an environment defect in its own right.** One database hosts two products' schemas *and two separate `migrations` tables*:

```
 table_schema | table_name      rows
 public       | migrations       44   ← TTM
 main         | migrations       54   ← Collmind-TPM
```

Consequences observed:
- An unqualified `SELECT name FROM migrations` resolves by `search_path` and can silently report the **wrong** product's migration history. This misled the first pass of this audit.
- Migration guards that match catalogue objects by **name only** cross the schema boundary — exactly how `UQ_ledger_entries_reversal_per_tenant` and `FK_ledger_entries_reverses_entry` came to exist on `public.ledger_entries` while `main.ledger_entries` has neither.

`main.ledger_entries` holds **1,231** rows; `main.agreements` 3; `main.on_invoice_batches` and `main.on_invoice_entries` **0** each — the on-invoice path has never been exercised with data.

**Drift:** `main.migrations` is current through `AddSpendTypeToBudgetDimensions1795000000000`, the newest migration in the repo — so the schema matches HEAD `b122a6e6`. No `.env` drift was found for Collmind-TPM (unlike TTM, whose `.env` points at the stopped 5433 container).

---

# Constraint compliance

- Read-only in both repos. Exactly one file created: this report.
- No `checkout`, `stash`, `pull`, `fetch`, `merge`, `cherry-pick`, `commit`, `branch`, or PR. Only `log`, `show`, `status`, `diff`, `ls-files`, `grep`, `rev-parse`, `rev-list`, `for-each-ref`, `config` — all non-mutating. Committed-state reads for modified files used `git show HEAD:<path>`.
- **No file in TTM was modified.** Its `git status` is byte-identical to preflight (5 untracked paths, all pre-existing).
- No migrations, seeds, builds, or test suites run.
- DB access limited to read-only `SELECT` / catalogue queries via `docker exec … psql -c`.
- No fixes proposed, no TODOs added, no refactors. Findings only.
- Documentation/code disagreements marked **DIVERGENT** (A1 migration, A8 `ReportingModule`, Part C prompt-vs-registry).
