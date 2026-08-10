# 0038 — BRD okuma turu **20**: §6.4 Idempotency & Corrections

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_06_Data_Integration.md` §6.4 (343–476, tamamı)
- **Ölçüm ortamı:** meta `1d86784` · backend `99ee9e6`

---

## 1. ✅ Ürün sahibinin sorusuna cevap: **BRD her işlemin anahtar taşımasını beklemiyor**

> *"[[T-095]]'te kısmi UNIQUE kararı verdik (`WHERE idempotency_key IS NOT NULL`) ve
> `ADJUSTMENT`/`ALLOCATION` anahtarsız yazıyor. BRD'nin idempotency modeli bunu kapsıyor mu?"*

### §6.4'ün modeli **içe aktarma** modelidir, işlem modeli değil

Üç seviyenin **üçü de import'a ait**:

| seviye | ne | kapsam |
|---|---|---|
| **1** | `sha256(fileContent)` → `checkImportHistory` | **yüklenen dosya** |
| **2** | kayıt anahtarı — üç biçim | **içe aktarılan kayıt** |
| **3** | `import_batches` (durum, sayaçlar) | **parti sürümleme** |

Seviye 2'nin üç biçimi:

```
ACTUALS|{customer_id}|{sku}|{date}
INVOICE|{invoice_no}|{line_no}
AGR_TXN|{agreement_id}|{invoice_no}|{invoice_date}
```

> **Üçü de dışarıdan gelen veriye ait.** `budget_transactions` gibi **sistemin kendi
> ürettiği** işlemler `§6.4`'ün konusu **değil**.

### Ve `§3.3` bütçe işlemleri için ayrı bir biçim veriyor

```
'<tx_type>|<source_type>|<source_id>|<envelope_id>'
örnek: 'RESERVE|AGREEMENT|uuid-123|uuid-456'
```

**Bu biçim bir KAYNAK VARLIK varsayıyor** (`source_type` + `source_id`).

| tip | kaynak varlık | anahtar üretilebilir mi |
|---|---|---|
| `RESERVE` | agreement | ✅ |
| `COMMIT` | plan | ✅ |
| `RELEASE` | agreement/plan | ✅ |
| **`ALLOCATE`** | — *(envelope'un kendisi yaratılıyor)* | ⚠️ **doğal kaynak yok** |
| **`ADJUST`** | — *(*"Manual correction (admin only)"*)* | ⚠️ **doğal kaynak yok** |

> ### Cevap
>
> **BRD her işlemin anahtar taşımasını beklemiyor**, ve verdiği biçim **tam olarak
> `ALLOCATE`/`ADJUST` için doğal bir anahtar üretmiyor** — çünkü ikisinin de bir kaynak
> varlığı yok.
>
> **[[T-095]]'in kısmi UNIQUE kararı (`WHERE idempotency_key IS NOT NULL`) kaynakla
> uyumludur** — ve yalnız uyumlu değil, kaynağın kendi anahtar biçiminin **zorunlu
> kıldığı** şeydir. Tam UNIQUE, anahtar üretemeyen iki tipi yazılamaz kılardı.

⚠️ **Sınır:** bu, biçimin şeklinden çıkarılan bir sonuçtur. `§6.4` ve `§3.3` *"bazı işlemler
anahtarsız olabilir"* diye **açıkça yazmıyor**. Çıkarım olarak işaretlendi.

---

## 2. 🟢 Correction Scenario 1 — **bizim modelimiz kaynaktan daha güçlü** (ikinci vaka)

**BRD Phase 1 kararı: OVERWRITE.**

```typescript
if (await hasApprovedPlansInPeriod(period)) throw new Error(...);
await deleteActuals({ period });        // ← SİLİYOR
await insertActuals(file.records);
await recalculateBaselines(period);
```

**Bizde** (`INV-R-003` / `INV-R-004` · D-14): `sales_actual_batches` + `ACTIVE`/`REPLACED` +
`replaced_by_batch_id` + `replaced_at` — **sürümlü değiştirme**, silme yok.

Ve `INV-R-004` açıkça: *"A replaced sales-actuals batch is **never deleted**."*

> **BRD'nin pseudo-kodu siliyor; bizimki sürümlüyor.** Bu, [[T-164]]'ün (`|| 0`) ardından
> **ikinci** vaka: kaynak sadakati burada da **zararlı** olurdu.
>
> Ve BRD kendi gerekçesini Scenario 2'de yazıyor: *"Maintains **audit trail** (Finance
> requirement)"* — yani Scenario 1'de uyguladığı *"basitlik"* tercihi, Scenario 2'nin
> kendi ilkesiyle çelişiyor.

### ⚠️ Ama bir GUARDRAIL bizde ölçülmedi

> *"Cannot overwrite actuals if **approved plans** reference that period. Requires Finance
> override for corrections post-approval."*

Bizde böyle bir kontrol **var mı — ölçülmedi**. `plans` tablosu boş olduğu için davranışsal
olarak da sınanamaz. → [[T-166]]

---

## 3. 🔴 Correction Scenario 2 — BRD **negatif tutar** kullanıyor, `§3.6` **yasaklıyor**

```typescript
// Correction (credit note)
{ invoice_no: 'CN-INV-001', original_invoice_no: 'INV-001',
  amount: -2,000,                       // ← NEGATİF
  correction_reason: 'Pricing error' }
```

**`§3.6` ledger şeması:** `amount NUMERIC(18,2) NOT NULL **CHECK (amount >= 0)**`, ve
*"amount: … **always positive**; sign indicated by direction."*

> **BRD kendi içinde çelişiyor** — dördüncü vaka (H1↔H5.4, `|| 0`↔Edge Cases,
> `weighted_avg` guard'ı, ve şimdi bu).

### Ve bu [[T-151]]'i doğrudan etkiliyor

T-151 *"`CHECK (amount >= 0)` ekle"* diyor. **Doğru — ama tek başına eklenirse `§6.4`'ün
düzeltme modeli yazılamaz hâle gelir.**

**Uzlaştıran tasarım** (ve `§3.6` onu zaten veriyor): düzeltme **negatif tutar** değil,
`entry_direction: 'CREDIT'` ile pozitif tutar. `§3.6` bunu açıkça söylüyor:
*"CREDIT (−spend, **reversal**)"*.

> **`CHECK (amount >= 0)` + `CREDIT` yönü** birlikte hem korumayı hem düzeltmeyi sağlar.
> T-151'e bu şart eklendi — **kısıt eklenirken düzeltme yolunun CREDIT'e taşındığı
> doğrulanmalı**, yoksa credit note'lar yazılamaz.

---

## 4. 📌 `§6.4`'ün D-13'e katkısı

`SYSTEM_INVARIANTS` **D-13**: *"Idempotency key formats — three undocumented formats in
use."*

**Artık dokümante:** kaynak **altı** biçim veriyor.

| # | biçim | nerede |
|---|---|---|
| 1 | `ACTUALS\|{customer}\|{sku}\|{date}` | §6.4 |
| 2 | `INVOICE\|{invoice_no}\|{line_no}` | §6.4 |
| 3 | `AGR_TXN\|{agreement_id}\|{invoice_no}\|{invoice_date}` | §6.4 |
| 4 | `{agreement_id}\|{invoice_no}\|{invoice_date}` (önek**siz**) | §4.3 |
| 5 | `LEDGER\|AGREEMENT\|{id}\|{invoice_no}` | §4.8 |
| 6 | `<tx_type>\|<source_type>\|<source_id>\|<envelope_id>` | §3.3 |

⚠️ **3 ile 4 aynı kavramın iki yazımı** — biri `AGR_TXN|` önekli, diğeri öneksiz. Yani
**kaynağın kendisi tutarsız**, ve D-13'ün *"three undocumented formats"* ifadesi artık
*"altı belgelenmiş, en az ikisi çakışan"* olarak güncellenebilir.

→ [[T-166]]

---

## 5. Okunmayan

`§6.1` Data Domains · `§6.2` Integration Patterns · `§6.3` Granularity · `§6.5` Data
Ownership · `§6.6` Refresh Frequencies · `§6.7` Phase 1 Integration Scope.

**Section_06: ~135 / 580 (%23).**

---

## 6. Sonraki tur

1. `§7.3` Approval Authority + `§7.2` Capability Permissions — ADR 0002 · [[T-153]] · [[T-165]]
2. `§7.5` Data Security & Isolation — `INV-T-003` bugün **VIOLATED**
3. `§2.6` kalanı (916–1026) · `04_Reviews`
