# Money-Float Guard Baseline (ADR 0007 F0)

**Date:** 2026-08-04 · **Commit:** `0b6518e` (branch `feat/money-float-guard`) · **Guard version:** money-float v1

This phase **converts nothing**. It builds the ratchet's measuring half and records the reference number.

---

## Domain A file set

**How derived.** ADR 0007 Karar 1 names Domain A as: `ledger` · `budget` · `agreement` and
`agreement-transaction` · CAP comparisons · `spend-calculation` (entirely) · claim, settlement,
recognition · invoice matching tolerance. Those names were resolved against the current tree:

| ADR name | Resolved path | `.ts` files (spec excluded) |
|---|---|---|
| budget | `src/modules/shared/budget` | 14 |
| spend-calculation | `src/modules/shared/spend-calculation` | 10 |
| ledger | `src/modules/modes/actuals-first/ledger` | 6 |
| agreement | `src/modules/modes/actuals-first/agreement` | 8 |
| agreement-transaction (CAP comparisons) | `src/modules/modes/actuals-first/agreement-transaction` | 9 |
| settlement | `src/modules/modes/actuals-first/settlement` | 10 |
| invoice matching tolerance | `src/modules/modes/actuals-first/on-invoice` | 11 |
| claim, recognition | — | **do not exist yet** |
| *(errata E10)* planning-first plan | `src/modules/modes/planning-first/plan` | 18 |

**Count: 86 files.**

**Divergence from 0010's 54: +32 — method plus one deliberate scope decision (errata E10).** `0010` produced a *curated*
per-layer candidate list of files that were observed to touch money (and its own table lists
`shared/finance-reporting (3)` while flagging it "→ Alan B'ye aday"). This set is
*module-complete*: every `.ts` under a declared Domain A module.

Module-complete was chosen deliberately, because the curated form cannot answer the ratchet's
central question — **how does a new file join?** A service dropped into `shared/budget` tomorrow
handles money by construction; under module scope it is covered the moment it exists, under
curation it is covered when someone remembers. The larger number is the cost of that property.

**Errata E10 (2026-08-04) — the list is exemplary, the test is canonical.** Karar 1's enumeration
was being read as definitive, which left a behaviourally-Domain-A module outside it. The binding
membership test is now: *a module is Domain A if it produces money, persists money, or compares
money against a threshold.* `modes/planning-first/plan` passes on all three —
produces + persists (`spend-calculation → plans.total_spend`, `plan.service.ts:2413`), compares to
a threshold (`:844` epsilon gate), triggers reservation (`reserveForPlan`) — and ADR 0005 K3 had
already made a money decision inside that file, so it was being treated as Domain A in practice
and simply never written down. **Measured cost: 68 → 86 files, 119 → 163 findings**
(`plan.service.ts` alone contributes 36). The size is information, not grounds for exclusion.

Cross-check that the surface has *not* moved: of the 86, **24 files contain any float entry point
at all** — the concentration, not the breadth, is what grew.

**Membership mechanism.** `scripts/guards/money-float-domain-a.txt` — a checked-in list of
directories, with the join rule and the deliberate Domain B exclusions written in its header.

**Why not a path regex.** `financial-ordering.sh` originally inferred scope from one. It covered
132 of 273 files while its invariant claimed codebase-wide coverage, and nobody could see the gap
because the scope lived inside a regex nobody read. That was a review blocker. A declared list
makes scope a diff a reviewer can argue with.

**New modules (Karar 8.2).** `claims`, `recognition_variance` and settlement extensions do not
exist yet and were **not created**. When one appears, its directory is added to the domain list in
the same commit that creates it, and it is added to `NEW_MODULES` so it runs in `block` from birth
rather than being baselined.

---

## Detection

**Patterns included** (per Karar 8.2): `parseFloat` · `Number(` · `toFixed` · `Math.round`.

**Money-context rule — one sentence:** the Domain A membership *is* the money context; inside
those modules the guard over-reports and the allowlist absorbs legitimate non-money uses, each
with a written justification.

This is a deliberate choice, stated openly because it shapes the baseline. Static detection of
"is this value money?" is not reliable — `0010` measured 347 `Number(` codebase-wide of which only
130 were money-context, and the difference is pagination, ids and counters that no static rule
separates cleanly. Over-reporting inside an already-money-scoped module is the safe direction: a
false positive costs one allowlist line with a justification, a false negative costs a silent
float on a money path. **Consequence:** the baseline contains findings that will never be
converted. They are visible and justified rather than excluded by a heuristic nobody can review.

**One lexical exclusion, measured.** The `(^|[^A-Za-z0-9_$])` prefix is load-bearing:
`@IsNumber()` contains `Number(`. On the real tree that was **38 of 138** raw `Number(` matches —
28% of the signal would have been class-validator decorators. Locked by the
`money-float-decorator` fixture.

### Adjacent patterns — evaluated

| Pattern | Decision | Reason |
|---|---|---|
| `Number.parseFloat` | **included** (free) | `.` is not an identifier char, so the existing prefix rule already matches it |
| `parseInt` | excluded | Karar 8.2 defines the pattern set; `parseInt` is overwhelmingly ids/pagination and adding it changes what the baseline number *means*. Revisit if a money `parseInt` is ever found. |
| unary `+` | excluded | Not lexically separable from string concatenation and arithmetic without a real expression parser. Over-reporting here would swamp the baseline. |
| `+` on `numeric` column reads | excluded | Requires type information the guard does not have. This is what F1's branded types are for — the type system is the right tool, not a grep. |
| `Object.entries()` accumulation | excluded | `0010` flagged four order-dependent sites, but the defect there is **ordering**, not float. `financial-ordering.sh` already owns that invariant; duplicating it here would give one defect two owners. |
| epsilon comparisons (`Math.abs(a-b) < 0.01`) | **excluded** | Six exist. Karar 7 removes each **together with its conversion** — flagging them now would create six allowlist entries that the conversion then has to delete, i.e. churn that makes the baseline noisier without moving anything. They become visible when their file's count is reduced. |

### Output

Three-line shape, matching the existing guards:

```
[money-float] src/modules/shared/budget/budget.service.ts:412
  Number() on a Domain A (money) path — ADR 0007 Karar 3b ratchet
  > const amount = Number(row.amount);
```

**One finding per line, not per occurrence** — the ratchet compares per-file line counts, so a
line with two entry points counts once and is labelled `multiple float entry points`. (Occurrence
counting would have given 126 where line counting gives 119.)

### Domain B is a hard error, not a finding

A hit in `finance-reporting` / `kpi-engine` / `dashboard` exits **2** before allowlist filtering.
It cannot be triaged away, because it does not mean "float on a money path" — it means either
Karar 1's boundary or the domain list is wrong. Locked by the `money-float-domain-b` fixture.

---

## Baseline

`scripts/guards/money-float-baseline.txt` — **163 findings across 24 files**, deterministically
sorted by path, one `<file> <count>` line each, header carrying date / commit / guard version /
total.

**Pattern mix:** `Number(` 100 · `toFixed` 17 · `parseFloat` 6 · `Math.round` 3 (pre-E10 mix; E10 added 44 findings, dominated by `Number(`).

**Top 10 files:**

| Findings | File |
|---:|---|
| 54 | `shared/budget/budget-allocation.service.ts` |
| 36 | `modes/planning-first/plan/plan.service.ts` *(added by E10)* |
| 10 | `shared/spend-calculation/spend-validation.service.ts` |
| 10 | `shared/spend-calculation/spend-distribution.service.ts` |
| 9 | `shared/spend-calculation/spend-calculation.service.ts` |
| 9 | `modes/actuals-first/on-invoice/on-invoice.service.ts` |
| 7 | `shared/budget/budget.service.ts` |
| 2 | `shared/budget/budget.repository.ts` |
| 2 | `modes/actuals-first/on-invoice/services/on-invoice-validation.service.ts` |
| 2 | `modes/actuals-first/ledger/ledger.repository.ts` |
| 2 | `modes/actuals-first/agreement-transaction/agreement-transaction.controller.ts` |

**Distribution:** 4 files hold ≥10 findings, 4 hold 3–9, and 16 hold 1–2. The tail is thin — most
Domain A files are one or two conversions away from zero, while `budget-allocation.service.ts`
(54, **33%**) and `plan.service.ts` (36, **22%**) together are more than half the baseline.
`budget-allocation.service.ts` has its own task: **T-077**.

---

## Ratchet

**Semantics.** `money-float.sh --ratchet` compares current per-file counts to the baseline:

* **increase** → `RATCHET VIOLATION: n -> m`, exit 1
* **decrease** → reported as progress, exit unaffected, baseline **not** rewritten
* **new Domain A file with findings** → violation (Karar 8.2: new code is born exact)
* **baselined file gone** (deleted or renamed) → reported as `GONE`, not a violation; the line is
  dropped in the same commit that removed the file

**Nothing writes to the baseline.** `--baseline` emits to stdout and the operator redirects it, so
every baseline change is a reviewable diff. A baseline that silently rewrites itself cannot be
reviewed, and a ratchet whose reference can move on its own is not a ratchet.

A rename is deliberately *not* auto-followed: it appears as one `GONE` plus one new-file
violation. That is noisier than tracking content hashes, and it is the right noise — a rename is
exactly when a file's contents get quietly rewritten.

### Proof run (raw output)

```
=== 1) clean state
$ bash scripts/guards/money-float.sh --ratchet ; echo exit=$?
exit=0                                   (no output)

=== 2) synthetic parseFloat injected into shared/budget/budget.service.ts
64:const __ratchetProbe = parseFloat("1.5"); // synthetic F0 ratchet probe

=== 3) ratchet comparison
$ bash scripts/guards/money-float.sh --ratchet ; echo exit=$?
[money-float] src/modules/shared/budget/budget.service.ts
  RATCHET VIOLATION: 7 -> 8 findings
exit=1

=== 4) reverted
$ bash scripts/guards/money-float.sh --ratchet ; echo exit=$?
exit=0                                   (no output)
$ git diff --stat -- src/modules/shared/budget/budget.service.ts
                                         (empty)
```

---

## Self-test

| Guard | Fixture | Expected | Locks |
|---|---|---|---|
| money-float | `money-float-positive` | 4 | guard actually fires; per-**line** counting |
| money-float | `money-float-decorator` | 0 | the measured `@IsNumber()` false positive (38/138) |
| money-float | `money-float-domain-b` | 0 | Karar 1 boundary — file sits outside the domain list |
| money-float | ratchet control | must fail | baseline 3 vs current 4 → `--ratchet` exits non-zero |

**Negative test of the self-test itself** — a green self-test proves nothing on its own:

| Injected defect | Self-test exit | Message |
|---|---|---|
| word-boundary prefix removed | **1** | `money-float × money-float-decorator → beklenen 0, bulunan 2` |
| detection disabled entirely | **1** | `money-float × money-float-positive → beklenen 4, bulunan 0` + ratchet control also fired |
| (clean) | **0** | — |

Both defects were reverted and `git diff` on the guard is empty.

> Note on measuring exit codes: `bash self-test.sh | head` reports `head`'s status, not the
> script's. The first run of this negative test showed `exit=0` for a failing self-test for
> exactly that reason. Re-run without the pipe. Same class as `bash -n a.sh b.sh` only checking
> the first file — both are recorded here because both cost time in this phase.

---

## Wiring

`npm run guards` runs five guards and stays **exit 0**:

```
  migration-schema: 0 bulgu
  ledger-direction: 0 bulgu
  financial-ordering: 0 bulgu
  schema-isolation: 0 bulgu (1 susturuldu → allowlist)
  money-float: 163 bulgu [BİLGİ AMAÇLI — bloklamaz; kapı: money-float.sh --ratchet]
  TOPLAM: 0 bulgu
```

`money-float` is listed in `REPORT_ONLY_GUARDS` in `run-all.sh`: its findings print and appear in
the summary but do not feed the blocking total. Making it blocking today would block every commit
until the entire conversion lands — the "big-bang or never" trap Karar 3b rejects. Enforcement
lives in `--ratchet`, not the runner. When Domain A reaches zero, remove it from that list.

`lib.sh`'s `GUARD_NAMES_VALID` gained `money-float` — that constant is the single source of truth
the runner reads, so registration is one line and cannot drift. All four pre-existing guards stay
green (`npm run guards` exit 0, self-test exit 0).

---

## Proposed Done-checklist wording

Identical text for **both** `.claude/backlog/BACKLOG.md` (task template) and `CLAUDE.md §4.2` —
these two copies diverging is this project's recurring failure mode, so they must be added in the
same commit:

```markdown
- [ ] Alan A dosyasına dokunulduysa: `bash scripts/guards/money-float.sh --ratchet` exit 0
      (dokunulan dosyanın bulgu sayısı ARTMAMALI — azalması beklenen ve iyidir;
      azaldıysa `--baseline` ile yeni referansı ayrı, gözden geçirilebilir bir
      commit'te güncelle). Alan A listesi: `scripts/guards/money-float-domain-a.txt`
```

**Not added in this task** — proposed for approval, per instruction.

---

## Known limits

Be specific about what this guard cannot see:

1. **Client-side arithmetic is invisible.** `0012` found `PlanningGridEnhanced.tsx` deriving
   NIV/Turnover/INCR from `volume × unitPrice`, and `PlanApprovalDetailModal.tsx:104` computing a
   knowingly wrong incremental GP — on the screen an approver reads. No backend guard reaches any
   of it. If the money contract is to hold end-to-end, the frontend needs its own mechanism.
2. **Comment detection is line-level.** A `Number(` inside a multi-line block comment whose line
   does not itself start with `//`, `*` or `/*` **will** be reported. `migration-schema.awk` was
   built precisely because that class of heuristic failed twice — it is not reused here because it
   is a template-literal extractor and money-float needs no literal tracking. The failure
   direction is over-reporting, which the allowlist absorbs.
3. **Arithmetic on already-float values is not caught.** The guard finds *entry points* into
   IEEE-754, not float arithmetic itself. `a * b` where both are already `number` is invisible.
   That is F1's job: branded types make the wrong operand a compile error at the assignment slot
   (ADR 0007 errata E1).
4. **`plan_fus.tactics` JSONB is out of reach.** Errata E2: the polymorphism that Karar 4 targets
   lives in a JSONB blob and in `buildMechanicValues`'s returned map, not only in a column. A
   lexical guard cannot see scale inside JSON values.
5. **`shared/plan` is not in the domain list.** `plan.service.ts` writes `plans.total_spend` and
   drives `reserveForPlan`, which is unambiguously money — but ADR Karar 1 does not name it, and
   this phase does not extend the ADR's boundary. See open question 1.
6. **Entities and the repository boundary are not covered.** `0010` counted 7 entity files with
   bare `number` money fields; they contain no float entry points, so they carry zero findings and
   sit invisibly at count 0. The `DecimalTransformer` defect (`Number(value)` in `from`) lives
   there and this guard does not flag it.

---

## Open questions

1. **Should `modes/planning-first/plan` join Domain A?** It writes `plans.total_spend` and feeds
   `reserveForPlan` — money by any reading — but Karar 1 does not name it. Adding it would raise
   the file set and the baseline. This is an ADR scope question, not a guard question.
2. **`budget-allocation.service.ts` is 45% of the baseline (54 findings).** It needs its own
   conversion task; the ratchet will otherwise sit on it untouched for a long time.
3. ~~`--ratchet` compares the whole tree, not just touched files.~~ **RESOLVED (2026-08-04):
   whole-tree is the rule.** The draft checklist wording said "a touched Domain A file", which the
   guard cannot express — an unenforceable checklist item is a box that gets ticked but never
   measured. Whole-tree is also *stronger* (it catches a float leaked into file B while editing
   file A) and *collective*: someone else's increase surfaces in your commit. That reads like a bug
   and is a feature — a ratchet whose rule permits "not my file" is not a ratchet. A
   `--since <ref>` mode may be added later, but only if noise is **measured** to disrupt the
   workflow; adding it now would be machinery for a problem that does not exist.
4. ~~When does `money-float` leave `REPORT_ONLY_GUARDS`?~~ **RESOLVED: when Domain A total reaches
   zero** — written into the ADR as errata **E11**, together with the distinction that must not be
   blurred: the guard is report-only for *existing* Domain A, but **blocking from birth** for new
   modules (`claims`, `recognition_variance`) under Karar 8.2. Two different things.
