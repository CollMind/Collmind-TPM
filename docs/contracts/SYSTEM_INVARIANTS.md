# SYSTEM_INVARIANTS.md — v0.4 (DRAFT)

> ## ⚠️ KARANTİNA DAMGASI (2026-08-24 · Fable, ürün sahibi onayıyla · F12: içerik değişmedi)
>
> **Bu belgedeki `Status:` satırları 2026-08-10 fotoğrafıdır ve KANONİK DEĞİLDİR.**
> O tarihten sonraki hiçbir gelişme işlenmemiştir. Kanonik durum üç yerdedir:
> guard çıktıları (`npm run guards`) · karar defteri (`docs/brd-v2/04_KARAR_KAYDI.md`,
> Z-kayıtları dahil) · L2 kural gövdesi.
>
> **Bilinen bayat satırlar (örnekleme, tam liste değil — ölçüldü 2026-08-24):**
> - `INV-L-006` kapsamındaki `budget_transaction_logs` tablosu **silindi** (Z24)
> - `INV-N-002` "Guard: NONE" diyor — **money-float ratchet'i doğdu ve işliyor**
> - `INV-B-007` "BLOCKED → D-09" diyor — **K-2.2.3 bunu L2'de kararlaştırdı**,
>   ihlalci kod (`findMatchingAllocation` / `budget_allocations`) Z21/Z24'te öldü
> - `D-04` ekseni **ADR 0012** ile kısmen kararlaştı (finansal tabloda fiziksel silme yasağı)
> - `D-01` üç varyant sayıyor — **K43-R (clamp)** kararı verildi
> - `INV-T` ailesi ADIM-3 yetki katmanını (K-2.6.13 DB rolleri · kapsam zorlaması ·
>   capability modeli) **hiç taşımıyor**
> - §12 registry notu bayat: karar defteri artık **bu repoda**, TTM'de değil
>
> **Yol (ürün sahibi onaylı, 2026-08-24):**
> 1. ✅ Bu damga (bugün)
> 2. ⏳ **Uzlaşı turu — KOŞUL, tetikleyici: ADIM 5 (RLS) planlamasının açılışı.**
>    Kapsam: tüm statülerin bugünkü gerçekle çakıştırılması · yetki/kapsam invariant
>    ailesinin eklenmesi (boş kapsam=erişim yok · SUMMARY_READ kapsamsız doğamaz ·
>    negatif-kullanılabilirlik) · INV-C'nin ilk-deploy ön koşulları listesine çapraz
>    referansı · §12 Adoption koşullarının yeniden değerlendirilmesi
> 3. ⏳ Kalıcı mekanizma (uzlaşı turunda kararlaştırılır): GUARD SCRIPT'li statülerin
>    guard çıktısından türetilmesi; elle kalanların Z-kaydı "etkilenen türev belgeler"
>    alanına bağlanması
>
> Bu belge, uzlaşı turu kapanana kadar **yalnız envanter değeri** taşır (guard-eşleme ·
> bilinçli-ihlal · "kazara sağlanan" sınıfı); statü okuması için kullanılmaz.
>
> ---
>
> ### ⏳ UZLAŞI TURU · **`FAZ-1` İNDİ** (2026-08-27) — damga **KALDIRILMADI**
>
> **`F12`: yukarıdaki damga silinmez.** Yol maddesi 2'nin **`FAZ-1`'i** (yetki/kapsam
> invariant ailesi) bugün indi; **`FAZ-2` (tüm `Status:` satırlarının tek tek
> çakıştırılması · `INV-C` çapraz referansı · `§12` · kalıcı mekanizma) AÇIK.**
>
> ```
> FAZ-1  ✅ INV-T-004 · INV-T-005 · INV-T-006  (§6 sonunda)
>           INV-B-008 · INV-B-009              (§4 sonunda)
>           ⇒ ADIM 5 (RLS) karar paketinin GİRDİ KAPISI: AÇIK
> FAZ-2  ⏳ geri kalan statüler HÂLÂ 2026-08-10 fotoğrafıdır
> ```
>
> ⛔ **Yani bu belge bugün İKİ HIZLIDIR:** `FAZ-1`'de eklenen beş madde
> **2026-08-27 ölçümlüdür ve statü okuması için kullanılabilir**; **diğer her
> madde hâlâ damganın altındadır.** Bir maddenin hangi tarafta olduğunu ayırt
> etme kuralı: **`ÖLÇÜLDÜ 2026-08-27` ibaresi taşıyor mu.**
>
> ⚠️ Ve damganın bayat-satır listesi **ÖRNEKLEMEDİR, TAM LİSTE DEĞİL** — `FAZ-2`
> her satırı **tek tek** ölçer. *"Örnekleme"* bir **uyarıdır**, bir kapsam değil.

> **Status:** Draft for review. Not yet normative.
> **Subject:** Collmind-TPM (`collmind.backend`) @ `876010f` + guards Phase 2 + uncommitted T-057 delta
> **Count:** ~~38 invariants — **20 HOLDS · 10 VIOLATED · 8 BLOCKED** · 14 open decisions~~
> ⛔ **REVİZE EDİLDİ (2026-08-27, uzlaşı turu `FAZ-1`):** bu satır bir **sayı**dır ve
> `DISIPLIN`'in *"belgeye elle üye-sayısı yazma"* kuralını ihlal eder — bu repoda elle
> yazılmış üye-sayısının bayatlama oranı **dokuzda dokuz**. `FAZ-1` beş madde ekledi ve
> satır **güncellenmedi**: yerine **kanonik sayım komutu** yazılıyor.
> ```bash
> grep -c '^### INV-[A-Z]-[0-9]' docs/contracts/SYSTEM_INVARIANTS.md   # INV-X-000 §2 ŞABLONU sayıma girer, çıkar
> grep -c '^- \*\*Status:\*\* HOLDS\|^- \*\*Status:\*\* 🔴' docs/contracts/SYSTEM_INVARIANTS.md
> ```
> ⚠️ Ve statü dağılımı **`FAZ-2` kapanana kadar sayılmaz** — bayat satırlarla yapılan bir
> sayım, bayatlığı bir **toplama** gömer ve görünmez kılar.
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
*"amount always positive; sign indicated by direction"* kuralını yazıyor. ~~**Bu kısıt bizde
yok** (ölçüldü: `pg_constraint contype='c'` boş)~~ ve **aşağıdaki dokuz invariantın hiçbiri
onu içermiyor.** Negatif bir `amount` + `DEBIT`, `INV-L-007`'nin `Σ DEBIT − Σ CREDIT`
hesabını sessizce bozar.

> ⛔ **REVİZE EDİLDİ (2026-08-27, uzlaşı `FAZ-2` · `ÖLÇÜLDÜ`):** kısıt **BUGÜN VAR** —
> `main.ledger_entries` üzerinde **`CHK_ledger_entries_amount_non_negative`**
> `CHECK (amount >= 0)` (**POZ.KONTROL:** aynı sorgu `main` şemasında başka `CHECK`'leri de
> buldu ⇒ sorgu çalışıyor). Aynı tabloda ikinci bir tanesi de doğdu
> (`CHK_..._adjustment_subtype_bidirectional`).
> ⚠️ **Ama cümlenin İKİNCİ yarısı hâlâ doğru:** dokuz invariantın **hiçbiri** bu kısıtı
> **söylemiyor** — yani koruma **kazara** duruyor, bir invariant'ın talebi olarak değil.
> Bir migration onu düşürse **hiçbir madde kırmızıya dönmez**. *(Bu, `INV-C` ailesinin
> "kazara sağlanan" sınıfının `INV-L` tarafındaki örneğidir.)*

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

> ### ⛔ REVİZE EDİLDİ (2026-08-27, uzlaşı `FAZ-2` · `ÖLÇÜLDÜ`) — **bu blok BAYAT, `F12` gereği SİLİNMEDİ**
>
> Yukarıdaki üç satırlık FK tablosunun **üçü de değişti**, ve **hepsi doğru yöne**:
>
> ```
> ledger_entries → budget_envelopes    SET NULL  →  ON DELETE RESTRICT
> ledger_entries → tenants             CASCADE   →  ON DELETE RESTRICT
> ledger_entries → agreements          YOK       →  FK_ledger_entries_agreement_id_restrict
>                                                   ON DELETE RESTRICT
> ```
> (`pg_constraint` + `pg_get_constraintdef`, `nspname='main'` ile şema-nitelendirilmiş.)
>
> ⇒ **Şemadaki iki sessiz mutasyon yolu KAPANDI** ve `INV-L-001`'in `budget_envelope_id`
> maddesi **bugün doğru**. `T-188`'in *"ya FK değişmeli ya madde düzeltilmeli"* ikilemi
> **FK tarafından** çözülmüş.
>
> ⚠️ **Ölçülen bedel satırları (`1231` satır · `%100 NULL` · *"panoda harcama ₺0"*) bu
> DB'de ARTIK GEÇERLİ DEĞİL** — çalışma veritabanı o günden beri sıfırlanmış görünüyor
> (bugün `main.ledger_entries` az sayıda satır taşıyor ve `budget_envelope_id`'leri
> **dolu**). ⛔ **Bu bir düzeltme kanıtı DEĞİLDİR:** eski bedel **veriyle birlikte
> silindi**, ölçülerek kapatılmadı. Aynı hasar başka bir ortamın verisinde **hâlâ
> durabilir** — ve `INV-M-001`/`INV-L-005` o ortamların `main` şemasının **eksik**
> olduğunu söylüyor.

### INV-L-001 — No statement may modify `ledger_entries.amount`, `entry_direction`, `budget_envelope_id`, or `period_month` after insert.
- **Status:** HOLDS
- **Guard:** NONE → target `DB` (BEFORE UPDATE trigger rejecting changes to these columns)
- **Evidence:** exactly one mutating statement exists in the codebase; it sets `is_reversed`
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **statü DEĞİŞMEDİ (`HOLDS`), ama
  `budget_envelope_id` maddesinin dayanağı DEĞİŞTİ — ve iyi yönde.** `§3`'ün üstündeki
  `T-188` bloğu (*"bu aile ŞEMA tarafından ihlal ediliyor"*) **BAYAT**: `main.ledger_entries`'in
  üç FK'sinin **üçü de bugün `ON DELETE RESTRICT`** (`tenant_id` · `budget_envelope_id` ·
  **`agreement_id` — ki `T-188`'de FK'si HİÇ YOKTU**). Yani şemadaki iki sessiz mutasyon
  yolu (envelope `SET NULL` · tenant `CASCADE`) **kapandı**. Guard hâlâ `NONE`: `main.ledger_entries`
  üzerinde **kullanıcı trigger'ı yok** (ölçüldü, `pg_trigger` `NOT tgisinternal`).
- **Source:** audit candidate #1

### INV-L-002 — The only permitted mutation of an existing ledger row is setting `is_reversed` from `false` to `true`.
- **Status:** HOLDS
- **Guard:** NONE → target `DB` (same trigger as INV-L-001, with the `is_reversed` exception)
- **Source:** audit candidate #2

### INV-L-003 — No ledger row may ever have a non-null `deleted_at`.
- **Status:** ~~🔴 VIOLATED (structurally, not in practice)~~ → ⛔ **REVİZE EDİLDİ: HOLDS**
  *(2026-08-27, `ÖLÇÜLDÜ` — çürüten ölçüm aşağıda)*
- **Guard:** ~~NONE~~ → **DB** ✅ — *ve mümkün olan EN GÜÇLÜ biçimde: kolonun kendisi yok*
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** `main.ledger_entries` üzerinde
  **`deleted_at` kolonu ARTIK YOK** (`information_schema.columns`, şema-nitelendirilmiş,
  boş döndü · **POZ.KONTROL:** aynı sorgu `main.users.deleted_at`'i **buldu** ⇒ sorgu
  çalışıyor, yokluk gerçek). Maddenin kendi öngörüsü gerçekleşti: *"bir invariant'ın bunu
  söylemek zorunda olması, kolonun hiç olmaması gerektiğinin işaretidir."* `D-04`
  **ADR 0012** ile kapandı. ⇒ Bir `CHECK`'e gerek kalmadı: **var olmayan kolon ihlal
  edilemez.**
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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **STATÜ DEĞİŞMEDİ — ve bu bir
  BULGUDUR, bir teyit değil.** Ölçüm bugün tekrarlandı: `UQ_ledger_entries_reversal_per_tenant`
  ve `FK_ledger_entries_reverses_entry` **hâlâ yalnız `public` şemasında**, `main`'de **yok**
  (`pg_indexes`/`pg_constraint`, ikisi de şema-nitelendirilmiş · **POZ.KONTROL:** aynı iki
  sorgu `main`'de başka index ve constraint'leri **buldu**). `reverses_entry_id` ve
  `is_reversed` kolonları `main`'de **var** ⇒ yol canlı, koruma yok.
  ⛔ **Ve *"T-057 commit edilince `db:reset`"* şartı ARTIK GEÇERSİZ bir bekleme:** `T-057`
  çoktan indi (ölçüldü, `INV-B-003`) ve `main.migrations` o günden bu yana **büyümeye devam
  etti** — yani `db:reset` beklenen olay değil, **yapılmayan iş**. Bu, `Z44 §4`'ün
  *"sağlanamaz bir koşulu beklemek"* deseninin **bu belgedeki ikinci vakasıdır**; şart bir
  **tarihe** değil bir **karara** bağlanmalı. ⇒ **`RLS` turu bunu devralır** (aynı DB, aynı
  `db:reset` penceresi).
- **Source:** audit candidate #5, violation #5

### INV-L-006 — Wherever a row carries an `idempotency_key`, that key is unique within its tenant, enforced in the database.
- **Status:** HOLDS (as of T-095)
- **Guard:** DB ✅
- **Scope:** `ledger_entries`, `budget_transactions`, `agreement_transactions`, `on_invoice_entries`, ~~`budget_transaction_logs`~~
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **kapsam satırı BAYATTI ve daraltıldı:**
  `main.budget_transaction_logs` **tablosu artık YOK** (`Z24` · migration
  `DropBudgetAllocationsAndTransactionLogs1811000000000`, `main.migrations`'ta kayıtlı ·
  `pg_tables` boş döndü, **POZ.KONTROL:** aynı sorgu `main`'de tabloları **buldu**).
  Aşağıdaki uzun anlatı o tablonun **kısmi index gerekçesini** anlatıyor ve **tarihsel
  değeri için SİLİNMEDİ** (`F12`) — ama bugün **var olmayan bir tabloyu** tarif ediyor.
  Kalan dört tabloda şart ölçüldü: `main.ledger_entries` üzerinde
  `IDX_LEDGER_ENTRIES_TENANT_IDEMPOTENCY` **UNIQUE** (`(tenant_id, idempotency_key)`).
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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **statü DEĞİŞMEDİ, satır numarası
  DEĞİŞTİ** — `if (envelope) {` bugün **`:235`**'te, `else` **hâlâ yok**, blok
  `createFromAgreementTransaction` çağrısıyla kapanıyor ve `return transaction;` koşulsuz.
  ⚠️ **Satır numarası kaymasının kendisi bir uyarıdır:** bu dosya `T-057` ile ağır biçimde
  değişti ve **kusur değişikliğin içinden geçti** — dokunulan bir kusur, düzeltilen bir
  kusur değildir.
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
- **Status:** ~~🔴 VIOLATED at HEAD · HOLDS with the uncommitted T-057 delta~~ → ⛔ **REVİZE
  EDİLDİ: KISMEN sağlanıyor** *(2026-08-27, `ÖLÇÜLDÜ`)* — ve **`HOLDS` yazılmadı**, çünkü
  kalan yarı ölçüldü ve **açık**
- **Guard:** TEST ✅ (`T-057` deltası **commit edildi**, spec artık izlenen dosyada)
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** `on-invoice.service.ts:475-493` bugün
  **iki aşamalı**: önce **niteliksiz** çağrı, ve yalnız bu çağrı bir *split-dimension*
  guard hatası fırlatırsa **`BudgetSpendType.ON_INVOICE` ile** yeniden çözüm. ⇒ Bölünmüş
  boyutta invariant **sağlanıyor**. ⛔ **Bölünmemiş boyutta SAĞLANDIĞI ÖLÇÜLMEDİ**: orada
  zarfın `spend_type`'ı hiç sorulmuyor, ledger satırı ise `ON_INVOICE`'ı **sabit** yazıyor.
  Bu tasarım **bilinçli** (`agreement-transaction.service.ts`'in uzun `T-057` notu:
  *"UNSPLIT boyutta bugünkü davranış BİREBİR korunmalıydı"*), ama invariant'ın cümlesi
  **her zaman** diyor. ⇒ Ya cümle daraltılır ya davranış genişletilir — **bir KARAR**
  (`§2.4`), bu belgenin tek taraflı vereceği hüküm değil.
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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** `BLOCKED → D-09` **BAYAT**: damganın
  kendi tespiti — `K-2.2.3` bunu `L2`'de kararlaştırdı, ve ihlalci kod (`budget_allocations`)
  `Z21`/`Z24`'te öldü. **Bugün ölçüldü:** `main.budget_allocations` **tablosu YOK**
  (`pg_tables`, **POZ.KONTROL:** aynı sorgu `main`'de tabloları buldu). ⛔ **Ama statü
  `HOLDS`'a çevrilmedi**, çünkü *"tek boyut kümesi"* iddiasının **kod tarafı bu turda
  ölçülmedi** — `findEnvelopeByDimensions`'ın iki çağrı yolu (off-invoice: kategorisiz ·
  on-invoice: kategorili) **hâlâ farklı imzalarla** çağrılıyor (`INV-B-003` ölçümü).
  ⇒ Statü: **`ÖLÇÜLMEDİ`**, `BLOCKED` değil — engel kalktı, ölçüm yapılmadı.
- **Source:** spec gap 14, B2 finding #3

### INV-B-008 — No budget envelope may fall to negative availability.
- **Status:** ⛔ **ÖLÇÜLMEDİ** — *ve bu, `HOLDS` ile `VIOLATED` arasında **üçüncü ve meşru** bir değerdir*
- **Guard:** **NONE** — ne `DB` ne `TEST`. `ÖLÇÜLDÜ` 2026-08-27
- **Evidence — iki yüzey, ikisi de boş:**
  ```
  DB      main şemasındaki CHECK kısıtları tarandı (pg_constraint, contype='c',
          nspname='main' ile ŞEMA-NİTELENDİRİLMİŞ)
          → budget_envelopes'ta CHECK: YOK
          POZ.KONTROL: aynı sorgu ledger_entries · claims · plan_mechanic_values ·
          budget_policies · budget_alert_configurations … üzerinde CHECK BULDU
          ⇒ sorgu çalışıyor, sonuç gerçek bir yokluk (ayrıştırıcı körlüğü değil)

  TEST    "negatif kullanılabilirlik" iddiasını sınayan test: bulunamadı
          POZ.KONTROL: aynı terimlerle taranan `toBeGreaterThanOrEqual`
          birden çok spec/e2e dosyasında BULUNDU ⇒ tarama deseni çalışıyor
  ```
- **⛔ VE STATÜ NEDEN `HOLDS` DEĞİL — `verinin yokluğu örter` sınıfı:**
  Bugünkü veride hiçbir zarf negatif değil (`ÖLÇÜLDÜ`: hem
  `main.budget_envelopes.available_amount` hem `main.v_budget_summary`
  üzerinde negatif satır **yok**). **Ama bu invariantın sağlandığının kanıtı
  değildir** — negatif üretecek bir olay henüz **hiç yaşanmadı**.
  ```
  POZ.KONTROL (yolun ÖLÜ olmadığı): v_budget_summary'de reserved_amount ve
  consumed_amount SIFIRDAN FARKLI satırlar var ⇒ tüketim yolu CANLI, yalnız
  sınıra hiç DAYANMADI.
  ```
  `CLAUDE.md §2.7`: *"bir yol bugün koşuyor mu?"* sorusu *"bu yol doğru mu?"*
  sorusundan **önce** gelir. Cevap: **yol koşuyor, sınır koşmadı.**
- **Statement (`PLAN_BUTCE_NETLESTIRME.md` madde 4, ürün sahibi):** *"Hiçbir
  zarf negatif kullanılabilirliğe düşemez."* Bu bir **varlık teyidiydi**, bir
  inşa değil: test **varsa** referansı kaydedilir, **yoksa** eklenir.
  ⇒ Ölçüm sonucu: **yok**. ⇒ **Eklenir** — ve nereye ekleneceği `INV-B-009`'a
  bağlıdır (hangi taşıyıcı?).
- **⚠️ `K-2.2.9h` (atomiklik) ve `K-2.2.15` (DB seviyesi koruma) tam olarak bu
  invariantı savunuyor — ama SAVUNDUĞUNUN SINANDIĞI ölçülmedi.** `FAZ1_PLAN`
  `Adım 2` 6. satırının kendi cümlesi budur ve bugün hâlâ geçerli.
- **Remediation:** `B5`'in *"10 eşzamanlı onay"* senaryosuyla **aynı aile** —
  bir eşzamanlılık testi ve/veya bir `CHECK`. ⛔ Hangisi olduğu bir **karar**:
  `INV-B-009` çözülmeden `CHECK`'in **hangi kolona** konacağı bile belirsiz.
- **Source:** `Z8` · `docs/decisions/PLAN_BUTCE_NETLESTIRME.md` madde 4 ·
  `FAZ1_PLAN.md` `Adım 2/6` · `ADIM3_KAPANIS_RAPORU §3.5`

### INV-B-009 — "Available" has exactly one carrier, and every consumer reads that one.
- **Status:** 🔴 **VIOLATED** — `ÖLÇÜLDÜ` 2026-08-27, **bu turda doğdu**
- **Guard:** **NONE** → target `LINT`/`GUARD SCRIPT` (tek okuma noktası) veya `DB` (kolonun düşürülmesi)
- **Evidence — iki taşıyıcı, ve CANLI VERİDE AYRIŞMIŞ durumdalar:**
  ```
  TAŞIYICI 1  main.budget_envelopes.available_amount   (saklanan kolon)
  TAŞIYICI 2  main.v_budget_summary.available_amount   (HESAPLANAN:
              allocated − (RESERVE+COMMIT−RELEASE) − (DEBIT−CREDIT))

  ÖLÇÜM (dev DB, şema-nitelendirilmiş JOIN): dört zarfın İKİSİNDE fark
  SIFIR DEĞİL — saklanan kolon tahsis anındaki değerde DURUYOR, view ise
  tüketimi görüyor.
  POZ.KONTROL: diğer iki zarfta fark tam olarak 0 ⇒ sorgu doğru eşliyor,
  fark gerçek bir ayrışma.
  ```
- **⛔ VE AYRIŞMA CANLI ROTALARA VARIYOR:**

  | okuyan | hangi taşıyıcı | ne yapıyor |
  |---|---|---|
  | `budget.repository.ts` (`sufficient: … >= requestedAmount`) | **VIEW** ✅ | yeterlilik kararı |
  | `finance-reporting.service.ts` (varyans raporu) | **VIEW** ✅ | rapor |
  | `agreement-transaction.controller.ts` (`currentAvailable`) | ⛔ **SAKLANAN** | kullanıcıya *"kullanılabilir"* gösteriyor |
  | `on-invoice-validation.service.ts` (`current`, sonra `utilizationAfter` → **RAG**) | ⛔ **SAKLANAN** | **RAG rengi** bundan çıkıyor |

  ⇒ Sonuncusu en ağırı: bayat bir *"kullanılabilir"* rakamı bir **RAG
  eşiğine** giriyor. `INV-N-004`'ün *"rengin kendisi yalan söyler"* ailesiyle
  **aynı yüzey**, farklı sebep.
- **⚠️ Ve aynı iki satırda `§2.5` ihlali var (ayrı ama komşu):**
  `Number(foundEnvelope.availableAmount) || 0` ve not-found dalında
  `currentAvailable: 0` — **sessiz sıfır**. Eksik/çözülemeyen zarf, *"sıfır
  kullanılabilir"* diye okunuyor; bu **yanlış yöne güvenli** görünüp
  (`0` = kısıtlayıcı) `utilizationAfter` hesabını **tersine** bozuyor.
- **⛔ BU BELGE BURADA HÜKÜM VERMEZ — bir KARAR gerekiyor (`§2.4`):**
  ```
  (i)   saklanan kolon bir SNAPSHOT'tır (tahsis anı) → adı YANLIŞ, yeniden adlandırılır
  (ii)  saklanan kolon TÜREVDİR → düşürülür, tek kaynak view olur
  (iii) saklanan kolon CANLIDIR → her yazma yolunda güncellenmeli (bugün DEĞİL)
  ```
  Üçü de farklı bir `INV-B-008` `CHECK`'i doğurur. ⇒ **`D-18`** olarak
  `§10`'a girer.
- **Impact:** `INV-B-008`'i **bugün yazılamaz** kılan şey budur — *"negatif
  kullanılabilirlik yasak"* demek için önce ***"kullanılabilir hangisidir"***
  sorusu cevaplanmalı. İki taşıyıcının biri asla negatife düşmez (hiç
  güncellenmiyor), diğeri **düşebilir**.
- **Source:** bu tur (`SYSTEM_INVARIANTS` uzlaşı `FAZ-1`, 2026-08-27) ·
  `INV-B-004` (*"CAP ve spend aynı kaynaktan"*) ile **aynı sınıf, farklı tablo**

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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **HÂLÂ BOŞ KÜMEDE — ve statü
  `ÖLÇÜLMEDİ`'ye çevrildi.** `main.on_invoice_entries` **sıfır satır** (`POSTED` 0 ·
  `ERROR` 0 · **POZ.KONTROL:** aynı turda `main.agreement_transactions` ve
  `main.sales_actual_batches` **dolu** ⇒ bağlantı ve şema doğru, sıfır gerçek).
  Maddenin *"[[T-057]]'de düzeltildi; bu invariant ilk kez gerçek veriyle sınanacak"*
  cümlesi **bir beklentiydi ve gerçekleşmedi** — düzeltme indi, **veri gelmedi**.
  ⇒ *"`HOLDS VACUOUSLY`"* ifadesi `HOLDS` kelimesini taşıdığı için **yanıltıcıdır**;
  doğru değer **`ÖLÇÜLMEDİ`**. (`DISIPLIN`: *"verinin yokluğu örter"* — ve örttüğü şey
  bir gün **kendiliğinden** ortaya çıkar, bir düzeltme turu olmadan.)
- **Source:** audit candidate #9

### INV-R-002 — The sum of ledger DEBITs created from an on-invoice batch equals the sum of `discount` over that batch's `POSTED` entries.
- **Status:** ⚠️ **HOLDS VACUOUSLY (until 2026-08-04)** — aynı gerekçe: hiç POSTED satır
  üretilmediği için hiç ledger DEBIT de üretilmedi; iki boş kümenin toplamı eşitti.
  Bkz. INV-R-001 notu, [[T-057]] (posting düzeltmesi) ve [[T-064]] (validate yolu hâlâ kırık).
- **Guard:** TEST → add `CI` — ⚠️ mevcut testler bu hatayı **yakalamadı**
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** `INV-R-001` ile **aynı ölçüm, aynı
  sonuç**: `main.on_invoice_entries` sıfır satır ⇒ iki boş kümenin toplamı hâlâ eşit.
  Statü **`ÖLÇÜLMEDİ`**.
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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **TEYİT EDİLDİ, taze**: `main` şemasında
  `relrowsecurity` açık tablo **yok** ve `pg_policies` **boş** (**POZ.KONTROL:** aynı
  şemada tablolar sayıldı, boş değil ⇒ sorgu doğru şemaya bakıyor). ⚠️ Ve `INV-T-005`
  bunun **maliyetini** ölçüyor: satır kapsamı bugün **tek katmanlı** ve o katman uygulama
  kodunda. ⇒ **Bu iki madde `ADIM 5` (`RLS`) paketinin ÇEKİRDEĞİDİR.**
  📌 `OPEN_DECISIONS.md` `D-11` satırı bir **ön koşul** kaydediyor: *"önce ayrı DB rolü —
  bugün `postgres` **bypassrls**"*. RLS politikası yazmak, `bypassrls` taşıyan bir rolle
  bağlanıldığında **hiçbir şey yapmaz** — `§2.7`'nin *"sinyal sabitse sinyal değildir"*
  vakasının DB tarafı.
- **Remediation:** blocked on **D-11**. Greenfield in both codebases. This is the gate for
  the second customer, not a hardening nicety.
- **Source:** audit candidate #22, violation #22

---

## ⛔ `INV-T` YETKİ/KAPSAM AİLESİ — UZLAŞI TURU `FAZ-1` (2026-08-27)

> **Bu bölüm karantina damgasının *yol maddesi 2*'sinin `FAZ-1`'idir** ve
> `ADIM 5` (`RLS`) karar paketinin **girdi envanteridir**. Damganın kendi
> tespiti: *"`INV-T` ailesi `ADIM-3` yetki katmanını (`K-2.6.13` DB rolleri ·
> kapsam zorlaması · capability modeli) **hiç taşımıyor**."* Aşağıdaki dört
> madde o boşluğu kapatır.
>
> ⛔ **Her madde bir STATÜ SATIRI DEĞİL, bir KANIT YÜZEYİDİR:** *guard mı ·
> test mi · DB constraint mi · **hiçbiri** mi* — ve **hiçbiri**yse **o da bir
> statüdür**, gizlenmez. Statünün üç meşru değeri vardır: `HOLDS` ·
> `VIOLATED` · **`ÖLÇÜLMEDİ`**. *"Bilinmiyor"u `HOLDS`'a yuvarlamak
> sessiz-yeşilin belge hâlidir.*
>
> ⚠️ **VE BİR TERİM AYRIMI, ÇÜNKÜ İKİ AYRI MEKANİZMA AYNI ADI TAŞIYOR.**
> *"Boş kapsam = erişim yok"* cümlesi bu kod tabanında **iki farklı katmana**
> karşılık gelir ve **guard'ları, statüleri, riskleri ayrıdır**:
>
> ```
> YETENEK KAPSAMI   "rota hangi yeteneği ister"        CapabilityGuard (A′)
> SATIR KAPSAMI     "kullanıcı hangi satırları görür"  AccessScopeService (R-2)
> ```
>
> Tek bir invariant olarak yazılsaydı **biri yeşil, diğeri kırmızıyken cümle
> yeşil okunurdu** — ve bugün tam olarak öyle. `INV-T-004` ✅ · `INV-T-005` 🔴.
> ⇒ **`RLS` paketinin konusu `INV-T-005`/`INV-T-006`'dır, `INV-T-004` değil.**

### INV-T-004 — A route that declares no capability, no `@Roles`, no `@Public`, no `@SelfScoped` and no recognised domain guard is denied. (yetenek kapsamı — `A′` default-deny)
- **Status:** HOLDS — `ÖLÇÜLDÜ` 2026-08-27
- **Guard:** **TEST** ✅ + **GUARD SCRIPT** ✅ (çoklu) — *kanıt yüzeyi aşağıda ayrıştırıldı*
- **Evidence:** `collmind.backend/src/common/guards/capability.guard.ts` — `if (!required) { … return false; }`
  altıncı dal. Karar: `Z44 §2` (`B4 = A′ → B`), iniş: `Z44 §8`.
- **Kanıt yüzeyi — hangi bozulmayı KİM görür:**

  | bozulma | dedektör | mutasyon kanıtı |
  |---|---|---|
  | guard gövdesi boşaltılır (`return true`) | `test/role-journey.e2e-spec.ts` | `Z44 §7` — `N5`+`N11` düşüyor |
  | `RolesGuard` `@UseGuards` zincirinden çıkar | `scripts/guards/route-scope.sh` | `Z44 §7` — `exit 2`, rotaları **adıyla** |
  | bir rotadan `@Roles` kazayla silinir | `route-scope` `FILTRESIZ` kovası + `roles-ratchet` | `Z44 §8` |
  | kalan-`@Roles` **büyür** | `scripts/guards/roles-ratchet.sh` | baseline'dan anahtar silindi → `exit 1` |
  | `ALAN_GUARD` kovası büyür | `scripts/guards/alan-guard-ratchet.sh` | fixture'dan guard düşürüldü → `exit 1` |
  | yeni bir domain-guard **tek yere** yazılır | `scripts/guards/domain-guard-parity.sh` (**çift-kayıt**) | iki yönde, ikisi de adıyla |
  | bir rota **iki mekanizma** birden taşır | `scripts/guards/single-mechanism.sh` | `SettlementGuard` sınıf seviyesine → `exit 3` |
  | default-deny dalının **kendisi** | `src/common/guards/capability.guard.spec.ts` — **SENTETİK** rota | `Z44 §5`: gerçek karşılığı **YOK**, o yüzden **üretildi** (`CLAUDE.md §2.7 #4`) |

  ⛔ **`Z44 §7`'nin iş bölümü burada YAZILI, çünkü yazılı olmadığında bir açık
  sanıldı:** ***yapısal** bozulmayı `GUARD SCRIPT` verir, **davranışsal**
  bozulmayı `e2e`.* Hiçbiri ikisini birden görmez; bu bir boşluk değil, bir
  **iş bölümüdür**.
- **Taze koşum (`ÖLÇÜLDÜ` 2026-08-27, exit kodu boruya SOKULMADI):**
  ```
  route-scope · roles-ratchet · alan-guard-ratchet · domain-guard-parity
  single-mechanism · scope-ratchet                       → hepsi exit 0
  npx jest capability.guard.spec.ts access-scope.service.spec.ts → exit 0
  route-scope kovaları: FILTRESIZ 0   (POZ.KONTROL: ALAN_GUARD kovası dolu ⇒
                                       sıfır gerçek, ayrıştırıcı körlüğü değil)
  ```
- **⚠️ Bilinen kırılganlık — `ADIM3 §MÜHÜR 2`, kapanmadı:** muafiyet yüklemi
  `constructor.name`'e bağlı. Minification açılırsa tanınan küme **boşalır**,
  her `ALAN_GUARD` rotası default-deny'a düşer. Yön **fail-CLOSED** (`403`),
  ama sonuç bir **üretim kesintisi**. Bugün `webpack.config.js`
  `optimization.minimize = false` **gerekçesiyle** yazılı. ⇒ **ilk-deploy ön
  koşulu** (bkz. `INV-C` çapraz referansı, `FAZ-2`).
- **Source:** `Z44 §2`/`§5`/`§7`/`§8` · `ADIM3_KAPANIS_RAPORU §3.1`/`§4.2b` · `K-2.6.3`/`K-2.6.6`

### INV-T-005 — A user with no scope row sees nothing; and every route that needs a row-scope predicate applies one. (satır kapsamı — `R-2` fail-closed)
- **Status:** 🔴 **VIOLATED** — cümlenin **birinci yarısı** `HOLDS`, **ikinci yarısı** ihlal. `ÖLÇÜLDÜ` 2026-08-27
- **Guard:** birinci yarı **TEST** ✅ · ikinci yarı **NONE** → target `DB` (**RLS**, `INV-T-003`/`D-11`)
- **Evidence — birinci yarı (mekanizma DOĞRU):**
  `src/modules/shared/access-scope/access-scope.service.ts` `buildScope`:
  `rows.length === 0` → `{kind:'SCOPED', pairs:[]}`; `isInScope` → `false`;
  `applyToQueryBuilder` → `qb.andWhere('1=0')`. Testleri:
  `access-scope.service.spec.ts` `describe('R-2 — fail-closed (empty scope = nothing)')`
  — üç `it`, ve `READONLY`/`ADMIN`/`FINANCE` için ayrı `describe`'lar (`Z30 H8`).
- **Evidence — ikinci yarı (mekanizmaya GİDEN YOL eksik):**
  ```
  resolveScope() çağıran ÜRETİM dosyası: plan.service · approval-workflow.service
    · agreement.service · settlement-summary.service · dashboard.service
    · finance-reporting.service                            (altı dosya)
  scripts/guards/scope-a1-baseline.txt: "kapsam GEREKLİ, UYGULANMIYOR" — DOLU
  ```
  ⛔ Bu, `CLAUDE.md §7.1`'in *"mekanizma var, ona giden yol yok"* sınıfının
  **kapsam tarafıdır** — ve tekil değil, bir **liste**dir. Kanonik kaynak
  **elle bir sayı değil**, `scope-a1-baseline.txt` + `scope-ratchet.sh`
  çıktısıdır.
- **⛔ VE ÜÇÜNCÜ BİR YARIM, EN AĞIRI — `PLANNER` bugün hiç ölçülmüyor:**
  ```
  access-scope.service.ts:  if (role === PLANNER && !scopeEnforcementEnabled)
                                return { kind: 'UNRESTRICTED' };
  .env.example:42           SCOPE_ENFORCEMENT_ENABLED=false
  ```
  ⇒ Bayrak kapalıyken **`PLANNER` için "boş kapsam" diye bir durum YOKTUR** —
  satır sayısına bakılmadan `UNRESTRICTED` dönülür. `R-2`'nin `PLANNER`
  testleri **bayrağı açarak** koşuyor (`spec.ts:31`), yani **bugünkü üretim
  yolunu değil, gelecekteki yolu** sınıyorlar.
  ⚠️ Bu bir kusur *ithamı değil*: bayrak `T-028c`'de **bilinçli** olarak
  kapalı bırakıldı (backfill doğrulanmadan açmak yıkıcı olurdu, migration
  `1792000000000` bunu adıyla yazıyor). **Kayda geçen şey niyet değil,
  BUGÜNKÜ DAVRANIŞ.**
- **⛔ ÖLÇÜLEMEDİ (ve nedeni):** çalışan ortamdaki `.env`'in
  `SCOPE_ENFORCEMENT_ENABLED` değeri **okunamadı** — ölçüm ortamı `.env`
  okumasını reddetti (sandbox). Ölçülen şey `.env.example` (`=false`) ve kod
  varsayılanı (env yoksa `false`). ⇒ *"Üretimde kapalı"* bir **VARSAYIM**dır,
  ölçüm değil. **`RLS` paketi bunu bir girdi olarak DEVRALIR.**
- **Impact (`RLS` için):** `INV-T-003` (RLS yok) ile birlikte okununca, satır
  kapsamı bugün **tek katmanlı ve o katman uygulama kodunda**. Bir rota kapsam
  atfını unuttuğunda hiçbir şey kırmızıya dönmez — `scope-ratchet` **listenin
  büyümediğini** ölçer, **uygulandığını değil** (kendi yorumu böyle diyor).
- **Remediation:** `D-11` (RLS) · `T-304` (kapsam borcu programı) · `Z25` koşul satırı
- **Source:** `Z25` · `Z30 H8` · `Z32` · `T-028b`/`T-028c`/`T-235`/`T-254`/`T-304`

### INV-T-006 — No route may hold `SUMMARY_READ` without a row-scope predicate. (`Z32`: kapsam bir ŞART değil, üyeliğin SÖZLEŞMESİ)
- **Status:** 🔴 **VIOLATED** — `ÖLÇÜLDÜ` 2026-08-27, **türetilmiş evrenden**
- **Guard:** **NONE** ⛔ — *bugün bu invariantı ölçen hiçbir kapı yok*
- **Evidence (`ÖLÇÜLDÜ`, iki kanonik üreticinin KESİŞİMİ — elle liste değil):**
  ```
  A  scripts/analysis/route-cell-map.py   → hücre == SUMMARY_READ olan rotalar
  B  scripts/guards/scope-a1-baseline.txt → "kapsam GEREKLİ, UYGULANMIYOR"
  A ∩ B  =  SUMMARY_READ üyelerinin ÇOĞUNLUĞU  (kanonik sayı: aşağıdaki komut)
  ```
  Yeniden üretim (sayı **buraya yazılmaz**, `DISIPLIN` — elle üye-sayısı bu
  repoda dokuzda dokuz bayatladı):
  ```bash
  cd collmind.backend
  python3 scripts/analysis/route-cell-map.py \
    | awk -F'\t' '$5=="SUMMARY_READ"{print $1"|"$2"|"$3}' | sort > /tmp/s.txt
  grep -v '^#' scripts/guards/scope-a1-baseline.txt \
    | awk -F'\t' 'NF{print $1}' | sed 's/[[:space:]]*$//' | sort > /tmp/a1.txt
  comm -12 /tmp/s.txt /tmp/a1.txt      # ← ihlal eden üyeler, ADIYLA
  comm -23 /tmp/s.txt /tmp/a1.txt      # ← şartı sağlayan üye(ler)
  ```
- **⛔ POZİTİF KONTROL (negatif bulgu değil, ama sınıf gereği):** kesişim
  **boş değil** ve tümleyen de **boş değil** — yani filtre gerçekten ayırt
  ediyor. Şartı sağlayan taraf `actuals-first/settlements/summary`
  (`settlement-summary.service.ts` `resolveScope` çağırıyor); ihlal eden
  taraf `finance-reporting/*` ailesi + `sales-actuals/summary`.
  *(`CLAUDE.md §2.7 #6`: bir ayrımın iki yanı da doluysa ayrım ölçülmüştür.)*
- **⚠️ VE BİR KARŞIT-ÖRNEK, ÇÜNKÜ TERSİ SANILIRDI:**
  `finance-reporting/budget-variance` **kapsam zorluyor**
  (`finance-reporting.service.ts` `getBudgetVarianceReport` → `resolveScope` +
  `applyToQueryBuilder`) — ve o rota `Z42 ADIM 0` SAPMA-3 ile
  `SUMMARY_READ`'den **çıkarılmıştı**. Yani bugün **kapsamı zorlayan
  finance-reporting rotası, `SUMMARY_READ` OLMAYAN rotadır.** Üyelik ile
  sözleşme **ters düşmüş** durumda.
  ⇒ Bu, `A1` baseline'ının **rota düzeyinde** doğru olduğunun da kanıtı:
  `budget-variance` o listede **yok** (`ÖLÇÜLDÜ`), yani baseline dosya
  düzeyinde kabaca yazılmamış.
- **Impact:** `Z32` *"kapsam yükümlülüğü, üyeliğin SONUCU"* diyor. Bugün sonuç
  **doğmuyor**: portföy özeti veren uçlar tenant-genelini dönüyor. Bir
  `CATEGORY_MANAGER`'a `SUMMARY_READ` verildiği gün **açılım** olur — `Z42 §2`
  bunu zaten *"`CM`-genişlemeleri KAPSAM-KOŞULLU"* diye kayıt altına aldı.
- **⛔ ÖNERİLEN KAPI (bu tur KARAR İSTER, tek taraflı açılmaz):** yukarıdaki
  `comm -12` bir **ratchet**'e bağlanabilir — evren **türetilmiş** (iki kanonik
  üretici), tek yön **aşağı**, ve `SUMMARY_READ`'e yeni bir üye kapsamsız
  giremez. Bu **`INV-T-006`'yı `NONE`'dan çıkaran en ucuz adım**, ama yeni bir
  kapı açmak bir **karar**dır → `FAZ-2` / ürün sahibi.
- **Source:** `Z31`/`Z32` (üyelik ölçütü) · `Z42 §3` · `Z43 §2` · `T-304 DİLİM-1` · `Z25`

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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **TEYİT EDİLDİ, taze**:
  `LedgerReversalSupport1777000000000` **hâlâ `main.migrations`'ta kayıtlı**, DDL etkileri
  **hâlâ yalnız `public`'te**. Ve *"54 migration"* rakamı bayatladı — `main.migrations`
  o günden bu yana **büyüdü** (kanonik kaynak: `SELECT count(*) FROM main.migrations`,
  sayı **buraya yazılmaz**). ⇒ Yani kayıt-DDL uçurumu **kapanmadı, ÜZERİNE inşa edildi**.
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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **TEYİT EDİLDİ, taze**: aynı DB'de
  `main` **ve** `public` (`pg_namespace`), ve **iki ayrı `migrations` tablosu** hâlâ orada
  (satır sayıları **farklı** ⇒ iki ayrı ürün geçmişi). `migration-schema` guard'ı
  bugün **exit 0**.
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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **kör nokta AÇIK** —
  `dto/report-filters.dto.ts`'te `sortBy?: string;` hâlâ **`@IsIn(...)` beyaz listesi
  taşımıyor** (satır numarası kaydı: `:97-100` → bugün `:112`). ⇒ `T-066` kapanmadı;
  *"`0 findings`"* cümlesi **guard'ın gördüğü evren için** doğru, **invariant için**
  değil.
- **Note:** a genuine improvement over TTM, whose financial ordering was by `randomUUID()`.
  Worth protecting explicitly so a port does not reintroduce it.
- **Source:** audit candidate #18

### INV-N-002 — Monetary arithmetic is exact; no monetary value is represented as a floating-point number in application code.
- **Status:** 🔴 VIOLATED *(statü doğru — aşağıdaki guard satırı değil)*
- **Guard:** ~~NONE~~ → ⛔ **REVİZE EDİLDİ: `GUARD SCRIPT` (ratchet)** *(2026-08-27)* —
  `scripts/guards/money-float.sh --ratchet` **doğdu ve işliyor**, bugün **exit 0**.
  ⚠️ Ratchet bir **çözüm değil, bir SINIRDIR**: Alan A'da bulgu sayısının **artmadığını**
  ölçer, ihlalin **kalktığını** değil — bu yüzden statü `VIOLATED` kalıyor.
  Hedef `LINT` + `TEST` **hâlâ açık**, `D-05`/ADR 0007 hattında.
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** damganın *"`INV-N-002` Guard: NONE
  diyor"* satırı doğruydu ve **kapatıldı**.
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
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** ⛔ **STATÜ DEĞİŞTİ — bu maddenin
  ölçülen her ihlal noktası KAPANMIŞ.** Yukarıdaki tablo (`|| 'GREEN'` · `!x || AMBER` ·
  `return null` · gri-ama-oransız · ham değer Excel'e) **BAYAT** ve `F12` gereği
  **silinmedi**; bugünkü ölçüm:
  ```
  backend   finance-reporting.service.ts   "|| 'GREEN'"  →  0 (yalnız AÇIKLAYICI YORUM kaldı)
  frontend  "|| 'GREEN'"  ve  "!ragStatus" →  0
            GrandTotals · PlanList · PlanningGrid · grid-cells · plans.endpoints
            HEPSİ tek bir yerden geçiyor:  src/utils/ragCoverage.ts
  POZ.KONTROL  aynı desenlerle aranan "ragStatus" ÇOK SAYIDA dosyada bulundu
               ⇒ grep çalışıyor, sıfırlar gerçek
  ```
  **Ve *"taşıyıcı yok"* engeli de kalktı:** `main.plans` bugün **`coverage_ratio`
  kolonunu taşıyor** (migration `1804000000000-AddCoverageRatioToPlans`; **POZ.KONTROL:**
  aynı sorgu `main.plan_fus.calculated_kpis`'i de buldu). Maddenin *"remediation there is
  blocked, not merely unwritten"* cümlesi **artık doğru değil**.
  ⛔ **AMA `HOLDS` YAZILMADI, ve gerekçesi ölçüldü:** `ragCoverage.ts`'in **testi yok**
  (`find src -name "*ragCoverage*"` → yalnız kaynak dosya; **POZ.KONTROL:** arama deseni
  kaynak dosyayı buldu). ⇒ Beş yüzey **tek bir noktaya** indirildi — bu bir mimari
  iyileşmedir — ama o **tek nokta korumasız**: bir regresyon **hepsini birden** bozar.
  ⇒ Statü: **`ÖLÇÜLMEDİ`** · Guard: **`NONE`** · ⚡ **en ucuz kapanış bu belgede: bir
  birim testi.** (`§2.7 #8`'in tersi: tekilleştirme doğru hamleydi, **testi eksik kaldı**.)

### INV-N-003 — Fiscal period derivation is timezone-independent.
- **Status:** 🔴 VIOLATED
- **Guard:** NONE → target `TEST` (assert under ≥2 `TZ` values) + `LINT`
- **Evidence:** `agreement-transaction.service.ts:108-122` — 3-level fallback ending in
  `getFullYear()`/`getMonth()`, which are local-timezone operations
- **Impact:** the same invoice lands in different fiscal months on servers in different
  timezones
- ⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** **TEYİT EDİLDİ, taze**: üç kademeli
  fallback'in son basamağı hâlâ `invoiceDate.getFullYear()` / `.getMonth()` —
  **yerel saat dilimi** işlemleri (satır kayması: `:108-122` → bugün `:107-121` civarı,
  kod **aynı**). `D-12` açık.
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

⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** *"ANONİMLEŞTİRME ÖLÇÜLMEDİ"* satırı
**artık ölçüldü: YOK.** `anonymiz|anonimle` üretim kodunda **sıfır eşleşme**
(**POZ.KONTROL:** aynı ağaçta `softRemove` **bulundu** ⇒ tarama çalışıyor).
`main.users.deleted_at` **var** ⇒ bugünkü davranış **soft-delete**, yani kimlik
**duruyor**. Statü `BLOCKED` **kalıyor** — ama artık *"bilinmiyor"* değil, *"yok, ve
hukuki kapsam karara bağlanmadı"* ([[T-170]]).

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

⛔ **`FAZ-2` ÇAKIŞTIRMA (2026-08-27, `ÖLÇÜLDÜ`):** tablo yokluğu **taze teyit edildi** —
`main` şemasında adı `%import%` içeren **hiçbir tablo yok** (**POZ.KONTROL:** aynı sorgu
`main`'de tabloları buldu). ⚠️ Ve `T-170`'in itirazı **hâlâ geçerli**: bu bir *sinyaldir*,
"dosya hiçbir yerde saklanmıyor"un **ölçümü değil** — dosya sistemi/nesne deposu bu turda
**taranmadı**. ⇒ Statü `VIOLATED` **kalıyor**, ama gerekçesi *"ölçülmemiş bir çıkarım"*
olarak işaretli.

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
| ~~**D-01**~~ | ~~CAP exceedance behaviour~~ | INV-B-002, INV-B-005 | ✅ **KAPANDI 2026-08-12** *(bu satır 2026-08-27'de revize edildi, `F12`: silinmedi)* — `04_KARAR_KAYDI §A5`: **tavan aşımı gerçekleşmeyi durdurmaz, hakediş tavana KIRPILIR** (`K43-R` clamp). Bu satırın *"üç varyant var, öneri şu"* metni **BAYATTI**. ⚠️ **Ve karar bir ADR olarak DEĞİL, karar defterinde kapandı** — `§12` koşul 1'in *"recorded as ADRs"* ifadesi bu yüzden bugün ölçülemez hâlde; bkz. `§14`. `INV-B-002`/`INV-B-005` **hâlâ ölçülmedi**: karar indi, **koda indiği ölçülmedi** |
| **D-02** | CAP source of truth | INV-B-002, INV-B-004 | **Proposed:** the ledger. It is append-only, direction-aware, and already the reporting source |
| **D-03** | CAP scope and optionality | INV-B-002 | K29 says tactic-level, code is agreement-level. K31 says optional, `cap_total_amount` is `NOT NULL` |
| ~~**D-04**~~ | ~~Append-only enforcement level~~ | INV-L-001…003 | ✅ **KAPANDI 2026-08-12 · ADR 0012** *(revize 2026-08-27)* — finansal kayıtlar **fiziksel silinemez**; zorlama seviyesi ADR'de. ⛔ **Ve sonucu ÖLÇÜLDÜ:** `main.ledger_entries.deleted_at` **kolonu artık yok** ⇒ `INV-L-003` `VIOLATED` → `HOLDS`, guard `NONE` → `DB`. *Bir kararın kapanması ile invariantın kapanması AYNI ŞEY DEĞİL — burada ikisi de ölçüldü* |
| ~~**D-05**~~ | ~~Numeric contract~~ | INV-N-002, INV-R-008 | ✅ **KARAR VERİLDİ — ADR 0007** *(revize 2026-08-27, `OPEN_DECISIONS.md`'den ölçüldü)*. ⛔ **Ama `INV-N-002` `VIOLATED` KALIYOR:** karar bir **sözleşmedir**, dönüşüm bir **programdır** ve o program açık (`money-float` **ratchet**'i sınırı tutuyor, ihlali kaldırmıyor). ⚠️ Ve `D-15`/`D-16`/`D-17` — ADR 0007'nin **kapsamadığı** üç eksen — hâlâ açık |
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
| **D-18** | *"Kullanılabilir" hangi taşıyıcıdır?* — `budget_envelopes.available_amount` (saklanan) mı `v_budget_summary.available_amount` (hesaplanan) mı | INV-B-008, INV-B-009 | ⛔ **Yeni (2026-08-27, uzlaşı `FAZ-1`, `ÖLÇÜLDÜ`).** İkisi canlı veride **ayrışmış**, ve iki canlı rota **saklanan** olanı okuyor — biri bir **RAG eşiğine** besliyor. Üç şık: **snapshot** (yeniden adlandır) · **türev** (kolonu düşür) · **canlı** (her yazma yolunda güncelle). `INV-B-008`'in `CHECK`'i hangi kolona konacağı **bu karara bağlı** — yani `D-18` çözülmeden `INV-B-008` yazılamaz. `INV-B-004` (*"CAP ve spend aynı kaynaktan"*) ile aynı sınıf, farklı tablo |
| **D-19** | `SUMMARY_READ` üyeliğinin kapsam sözleşmesi bir **KAPIYA** bağlanacak mı | INV-T-006 | ⛔ **Yeni (2026-08-27).** `Z32` kapsamı *"üyeliğin SONUCU"* ilan etti ama sonucu **ölçen bir şey yok**. Önerilen kapı **türetilmiş evrenli** bir ratchet (`route-cell-map.py` `SUMMARY` ∩ `scope-a1-baseline.txt`, tek yön aşağı). Yeni kapı açmak bir karardır → ürün sahibi |

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

**Registry note:** ~~`DECISION_REGISTRY.md` (K1–K45) currently lives in **TTM**, the frozen
repo.~~ The product's decision registry cannot live in the legacy codebase. It should be
split — product decisions into Collmind-TPM's `docs/decisions/`, Wella-specific choices into
a tenant profile — and TTM's copy marked historical.

### ⛔ `FAZ-2` YENİDEN DEĞERLENDİRME (2026-08-27, `ÖLÇÜLDÜ`) — dördü de tek tek ölçüldü

| # | koşul | bugün | ölçüm |
|---|---|---|---|
| 1 | beş karar **ADR olarak** kayıtlı | ⛔ **KARŞILANMADI — ve koşulun KENDİSİ hatalı** | `D-04` ✅ ADR 0012 · `D-05` ✅ ADR 0007 · `D-01` ✅ **ama ADR DEĞİL** (`04_KARAR_KAYDI §A5`) · `D-02` ⛔ açık · `D-08` ⛔ açık (`OPEN_DECISIONS.md`'den) |
| 2 | guard backlog `1–5` | ✅ | `Phase 2`, `T-064` — değişmedi |
| 3 | `CLAUDE.md §2` kuralları tekrar etmeyi bırakır | ⛔ **KARŞILANMADI** | `CLAUDE.md §2.3` bugün hâlâ RBAC · state machine · RAG · bütçe eşiklerini **metin olarak** tekrar ediyor (kendi başlığı *"normatif DEĞİL"* dese de) |
| 4 | her ajan tanımı bu dosyayı **ve** `docs/decisions/`'ı bağlayıcı kaynak sayar | ⛔ **YARISI** | `docs/decisions` atfı: `.claude/agents/` altındaki dosyaların **hepsinde** var ✅ · `SYSTEM_INVARIANTS` atfı: **hiçbirinde yok** ⛔ (**POZ.KONTROL:** aynı `grep -l` ikinci terimde dokuz dosya döndürdü ⇒ tarama çalışıyor) |

> ⛔ **KOŞUL 1'İN KENDİSİ REVİZE EDİLMELİ — ve bu bir ölçüm sonucudur, bir tercih değil.**
> `D-01` **kapandı**, ama `docs/decisions/` altında değil, **karar defterinde**. Koşul
> *"ADR olarak kayıtlı"* diye yazıldığı için, **kapanmış bir karar koşulu sağlamıyor
> görünüyor.** Bu, `CLAUDE.md §2.1`'in kaynak hiyerarşisiyle de çelişiyor: orada
> **ADR'ler ve karar defteri** ayrı ama **ikisi de bağlayıcı**.
> ⇒ Önerilen yeni metin: ***"…`docs/decisions/` altında bir ADR olarak **ya da**
> `04_KARAR_KAYDI.md`'de bir `Z`/`§` kaydı olarak kayıtlıdır"***.
> ⚠️ Ama **koşulu değiştirmek bir karardır** (`§2.4`) — bu belge onu **öneriyor**,
> uygulamıyor.

> **Registry notu — REVİZE (2026-08-27):** damganın tespiti doğru, kayıt **gerçekleşmiş**:
> ürünün karar kayıtları bugün **bu repoda** yaşıyor (`docs/decisions/` — on iki numaralı
> ADR + adlandırılmış karar belgeleri — ve `docs/brd-v2/04_KARAR_KAYDI.md`'nin `Z`
> kayıtları). ⛔ **`K1–K45` kümesinin TTM kopyasının "historical" işaretlenip
> işaretlenmediği bu turda ÖLÇÜLMEDİ** — `TTM` reposu bu ölçümün kapsamı dışındaydı
> (`ADR 0001`: dondurulmuş, referans). ⇒ Not **silinmiyor**, **daraltılıyor**: kalan iş
> yalnız TTM tarafındaki işaretleme.

---

## 13. Changelog

| Version | Date | Change |
|---|---|---|
| 0.5 | 2026-08-27 | **Uzlaşı turu `FAZ-1` — yetki/kapsam ailesi eklendi, damga KALDIRILMADI.** Damganın kendi tespiti (*"`INV-T` ailesi `ADIM-3` yetki katmanını hiç taşımıyor"*) kapatıldı: `INV-T-004` (yetenek kapsamı — `A′` default-deny, **HOLDS**, çok-dedektörlü kanıt yüzeyiyle), `INV-T-005` (satır kapsamı — `R-2` fail-closed; **birinci yarısı HOLDS, ikinci yarısı VIOLATED**), `INV-T-006` (`SUMMARY_READ` kapsamsız doğamaz — **VIOLATED**, iki kanonik üreticinin kesişiminden **türetilerek** ölçüldü). ⛔ **Ve bir terim ayrımı yapıldı, çünkü tek cümle iki mekanizmayı örtüyordu:** *"boş kapsam = erişim yok"* bu kod tabanında **yetenek kapsamı** (`CapabilityGuard`) ve **satır kapsamı** (`AccessScopeService`) diye iki ayrı katmandır; tek invariant olarak yazılsaydı biri yeşil diğeri kırmızıyken cümle **yeşil okunurdu** — ve bugün tam olarak öyle. `§4`'e `INV-B-008` (negatif kullanılabilirlik — statüsü **`ÖLÇÜLMEDİ`**, `HOLDS`'a **yuvarlanmadı**: negatif üreten yol bugün hiç koşmadı, *"verinin yokluğu örter"* sınıfı) ve `INV-B-009` (**bu turda doğdu** — *"kullanılabilir"in İKİ taşıyıcısı var ve canlı veride ayrışmışlar**; iki canlı rota bayat olanı okuyor, biri bir **RAG eşiğine** besliyor). `§10`'a `D-18` ve `D-19`. Header'ın elle yazılmış `Count:` satırı **revize edildi** (silinmedi, `F12`): yerine kanonik sayım komutu — elle üye-sayısının bu repoda bayatlama oranı **dokuzda dokuz**. ⏳ **`FAZ-2` AÇIK:** damganın altındaki diğer her satır hâlâ **2026-08-10 fotoğrafıdır**; ayırt edici ibare **`ÖLÇÜLDÜ 2026-08-27`**. |
| 0.1 | 2026-08-03 | Initial draft from CTPM baseline audit. 14 open decisions. Header count of "25 invariants: 15 HOLDS · 10 VIOLATED/BLOCKED" was an estimate and is corrected in 0.2 by counting the entries. |
| 0.4 | 2026-08-10 | **`INV-C` — Compliance & Retention ailesi açıldı** (§9, dört madde). Bir BRD okuma turu (`docs/analysis/0050`) bu boyutun ne kodda ne sözleşmede var olduğunu ölçtü: `Section_09_NFR` §9.5 üç Türk düzenlemesini adıyla sayıyor, `§9.8` 7 yıllık saklamayı bir **Phase 1 taahhüdü** olarak listeliyor, ve `compliance|KVKK|GDPR|retention|INV-C-` bu belgede **0** geçiyordu. Ailenin özel niteliği: `INV-C-001` ve `INV-C-004` bugün **kazara** sağlanıyor — biri hiçbir şey silinmediği, diğeri hiçbir ERP olmadığı için. İkisi de bir **kod** değişikliğiyle değil, bir **veri/entegrasyon** değişikliğiyle bozulur, ve o gün hiçbir test kırmızıya dönmez; normal regresyon ağı bu sınıfı hiç görmez. Bağlayıcılık **iddia edilmiyor** — BRD'nin listesi bir girdidir (`CLAUDE.md §2.1.2`) ve hukuki kapsam [[T-170]]'te açıktır. Sayı 33 → 38, ve **sayılarak** güncellendi (v0.1'in tahmin hatası tekrarlanmadı). Bölüm numaraları 9→10, 10→11, 11→12, 12→13 kaydı.
| 0.3 | 2026-08-03 | **Guards now carry their own tests.** Two review rounds each found a real silent false negative, and in both the evidence was a throwaway fixture that was deleted afterwards — the most valuable output of each round was never recorded. `scripts/guards/fixtures/` makes those five cases permanent (round-2 regression, round-1 blocker, the false-positive counterpart, the schema-safe forms, and a **positive control** that fails if a guard has stopped measuring at all), and `self-test.sh` runs the matrix at the start of every `npm run guards`; a red matrix stops the run before any finding is counted. Verified by negative test: reinstating the round-2 pre-pass drops `star-line` from 2 findings to 1 and the self-test goes red. This closes the guard-infrastructure work — a future defect adds a fixture, not a review round. |
| 0.2.2 | 2026-08-03 | Phase 2 code review, round 2. The round-1 fix for the backtick-parity blind spot **introduced a regression of its own class**: its comment pre-pass treated any line starting with `*` as a comment, so a SQL line like `  * FROM pg_indexes …` had its backtick stripped and the parity shifted — one masked query in a two-query fixture, silently. Both heuristics are now gone: `migration-schema.awk` is a real lexer tracking literal-in/out state, so a `//` is a comment only outside a literal and an unterminated literal is reported. Four fixtures cover it (star-line, comment-backtick, mid-line comment, schema-safe forms). Also: guard-name list is now single-sourced from `lib.sh` (`run-all.sh` reads it), `filter_allowlist` accepts exactly what `validate_allowlist` accepts (they had drifted — `n < 3` vs `n != 3`, and `ENV` accepted for any guard), and `financial-ordering` excludes spec/e2e files. Counts unchanged. |
| 0.2.1 | 2026-08-03 | Phase 2 code review follow-up. Two blockers closed in the guards themselves: (1) `migration-schema.sh` split template literals on backticks, so a backtick inside a `//` comment shifted the parity and blinded the guard **silently** — comment backticks are now stripped and any file with odd parity or an escaped backtick is reported, not skipped (fixture-verified: pre-fix guard 0 findings, post-fix 1). (2) `financial-ordering.sh` scanned 132 of 273 module files — `finance-reporting`, `spend-calculation`, `kpi-engine` were outside it — so INV-N-001's "0 findings across the codebase" claimed more than was measured; scope widened to 176 files (still 0) and the guard's blind spot for runtime-built sort keys is now stated (T-066 opened). Also: `SKIPPED` no longer counts as green (a source-code guard that cannot run exits 1; a DB guard without a database reports `ÖLÇÜLMEDİ`), allowlist-suppressed findings are now printed in the summary instead of vanishing into `0 bulgu`, and the `schema-isolation` entry uses the narrow key `db:collmind_tpm` rather than the `ENV` wildcard. |
| 0.2 | 2026-08-03 | Guards Phase 2. Guard type `LINT` → `GUARD SCRIPT` for entries enforced by `scripts/guards/*.sh` (ESLint reads the AST; these checks read SQL string contents). Guard type `CI` removed — no pipeline exists; enforcement path is `npm run guards` + `code-reviewer` + Done checklist. INV-M-002 → HOLDS (5 unqualified catalogue queries in 2 migrations found and repaired; scope now measured, not unknown). INV-M-003 → detected + allowlisted (T-067). INV-L-007, INV-N-001 → guard `NONE` → `GUARD SCRIPT`, both measured at 0 findings. INV-L-005 and INV-M-001 remain VIOLATED deliberately: the repaired migration was proven on a throwaway database (all 54 migrations from empty → both objects on `main`), but the working database `collmind_tpm` still lacks them and cannot be re-migrated in place. A fix that has not reached the environment is not a held invariant. Both close with a `db:reset` after T-057 is committed. **Counted:** 33 invariants — 16 HOLDS · 10 VIOLATED · 7 BLOCKED. (The 34th `### INV-` heading, `INV-X-000`, is the §2 format template, not an invariant.) |
