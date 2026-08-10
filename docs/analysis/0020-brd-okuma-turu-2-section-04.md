# 0020 — Bağlayıcı BRD okuma turu **2**: Section 04 (Actuals-First Mode)

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur. Kod / migration / entity değişikliği YOK.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_04_Actuals_First_Mode.md`
- **Ölçüm ortamı:** meta `e865444` · backend `99ee9e6`

---

## 0. Bu turda ne OKUNDU, ne OKUNMADI

| | satır | ne |
|---|---|---|
| ✅ **okundu** | 1–1139 | 4.1 Mode Overview · 4.2 Agreement Management · 4.3 Off-Invoice Import · 4.4 Spend Tracking & KPIs · 4.5 Use Cases |
| ✅ **okundu** | 1470–1750 | 4.8 Budget Integration (akış, rezervasyon, tüketim, **eşikler**) |
| ⛔ **okunmadı** | 1139–1470 | 4.6 Price Simulation (UI) · 4.7 Tactics & Mechanics · Settlement Calculation Examples (bir kısmı önceki turda görüldü) |
| ⛔ **okunmadı** | 1750–2038 | 4.9 Reporting & Analytics'in gövdesi · kapanış |

**Okunan: ~1.420 / 2.038 satır (%70).** Kalan **618 satır** ve içinde `4.7 Tactics &
Mechanics` var — mekanik semantiğinin merkezi. Sonraki tura.

---

## 1. ⛔ DUR — [[T-145]] ÇÖZÜLDÜ, ve tur 1'in bulgusu **yanlıştı**

Tur 1, Glossary'nin `Ledger` maddesine bakıp *"BRD tek ledger anlatıyor, ürün iki tablo
kullanıyor — model farkı"* demişti. **Section_04 bunu çürütüyor.**

BRD'nin **kendi pseudo-kodu** (4.8, `postToLedger`):

```typescript
await createLedgerEntry({
  source_type: 'AGREEMENT',
  entry_direction: 'DEBIT',          // ← bizim modelimiz
  spend_type: transaction.spend_type,
  budget_envelope_id: envelope?.id,
  idempotency_key: `LEDGER|AGREEMENT|${agreement.id}|${transaction.invoice_no}`
});
```

Ve `reserveBudgetOnApproval` **ayrı bir tabloya** yazıyor:

```typescript
await createBudgetTransaction({ tx_type: 'RESERVE', tx_status: 'POSTED', ... });
```

Ve 4.4'ün *"Database Tables"* listesi **ikisini birden** sayıyor:
`ledger_entries` (*"unified spend log"*) **ve** `budget_transactions`
(*"reservation/consumption log"*).

Ve `v_budget_summary`'nin nasıl hesaplandığını **açıkça** yazıyor:

```
v_budget_summary computes from:
  • budget_transactions (Reserved)
  • ledger_entries      (Consumed)
Available = Allocated - Reserved - Consumed
"No aggregate columns to drift"
```

> **Ürünün iki-tablolu modeli BRD'nin modelidir.** Glossary'nin *"beş işlem tipli tek
> ledger"*i kavramsal bir özetti; şema Section_04'te ve bizimkiyle örtüşüyor.

⚠️ **Bu, tur 1'in kendi uyarısının doğrulanmasıdır** — *"bir sözlük maddesi bir davranış
spesifikasyonu değildir"* demiştik ve tam olarak o tuzağa yarım adım girmiştik. Bulgu
**"model farkı" olarak değil, "Glossary basitleştiriyor" olarak** kayda geçmeliydi.

**[[T-145]] kapatılır.** Geriye tek bir dar soru kalıyor: `TRANSFER` ve `ADJUST` işlem
tipleri BRD'nin hiçbir yerinde geçmiyor — **kullanılıyorlar mı?** (§7.1)

---

## 2. 🔴 [[T-144]] GENİŞLEDİ — BRD'de **iki ayrı eşik sistemi** var, kod ikisini birleştirmiş

Bu turun en pahalı bulgusu.

### 2.1 BRD iki farklı şey tanımlıyor

**(a) RAG — GÖRÜNTÜ** (4.4 *"Budget Utilization %"*, ve Glossary'de birebir aynı):

```
Green: <80%      Amber: 80-95%      Red: >95%
```

**(b) Alert — DAVRANIŞ** (4.8 *"Budget Alerts & Thresholds"*):

```
Warning (80%):            Email to Planner + Finance
Approval Required (90%):  Finance approval needed for new agreements
Block (100%):             System prevents new agreement submissions
```

**Bunlar aynı eşikler değil ve aynı işi yapmıyorlar.** Biri renk, diğeri **kapı**. Ve
orta değerleri **farklı**: görüntüde **95**, davranışta **90**.

### 2.2 Kod ikisini tek sete indirmiş

`budget-threshold.service.ts`: `{ warning: 80, critical: 95, exceeded: 100 }`

| BRD | değer | kodda karşılığı |
|---|---|---|
| RAG amber başlangıcı | 80 | `warning: 80` ✅ |
| RAG red sınırı | **>95** | `critical: 95` ⚠️ (`>=`, bkz. [[T-144]]) |
| Alert warning | 80 | `warning: 80` ✅ |
| **Alert "Approval Required"** | **90** | ❌ **YOK — hiçbir karşılığı yok** |
| Alert block | 100 | `exceeded: 100` ✅ ama **kapı bağlı değil** |

### 2.3 İki sonuç, ikisi de yeni

**① Tur 1'in açık bıraktığı soru cevaplandı.** *"Dördüncü kova (`exceeded: 100`) Glossary'de
yok — kaynaksız mı?"* **Kaynağı var:** `Block (100%): System prevents new agreement
submissions`. Kayıt hatası değilmiş; Glossary yalnız renkleri sayıyordu.

Ve bu, ADR 0007 **A6**'nın notunu doğruluyor: `budget-allocation.service.ts`'teki
*"TODO: block plan submission if hard limit mode"* **gerçekten bir BRD ihlali** —
BRD %100'de blok **istiyor**, kodda TODO olarak duruyor.

**② %90 "Approval Required" katmanı hiç yazılmamış.** Kodda ne enum üyesi, ne eşik, ne kapı.
BRD'nin üç davranış katmanından **ortadaki tamamen yok**.

> Kod, **görüntü eşiğini davranış eşiği yerine kullanıyor**: %95 (bir renk sınırı) `critical`
> adıyla duruyor, %90 (gerçek bir onay kapısı) hiç yok.

---

## 3. Açık kararlara BRD'nin verdiği cevaplar

⚠️ **Hepsi "kayda geçer" statüsünde.** Section_04'ün %30'u okunmadı ve `Section_03 Budget
Management`'a **çapraz atıf** var (4.8 sonu: *"See Section 3.3 for budget envelope schema,
transaction types, policy configuration"*). Karara bağlanmadan o bölüm okunmalı.

| Karar | BRD ne diyor | Nerede |
|---|---|---|
| **D-08** — envelope bulunamazsa | **`throw new Error("No budget envelope found for …")`** — reject. Auto-provision/catch-all **yok** | 4.8 `reserveBudgetOnApproval` |
| **D-09** — envelope çözüm boyutları | `channel` + `category` (*"Derived from FU"*) + `period_month` | 4.8, iki ayrı fonksiyonda **aynı** üçlü |
| **D-01** — CAP aşımı | Import doğrulamasında **`warnings.push`** — satır **geçer**. Batch'i Finance onaylar (override). Envelope seviyesinde %100'de **blok** | 4.3 `validateRow` Check 6 · 4.8 |
| **D-13** — idempotency formatları | **İkisi de yazılı:** `'{agreement_id}\|{invoice_no}\|{invoice_date}'` (transaction) · `LEDGER\|AGREEMENT\|{id}\|{invoice_no}` (ledger) · `RESERVE\|AGREEMENT\|{id}\|{envelope_id}` (budget tx) | 4.3 · 4.8 |

**D-01 hakkında:** tur 1'de Glossary *"cap breach → alert + Finance override"* demişti;
Section_04 **mekanizmasını** veriyor — uyarı satırı geçirir, batch onayı Finance'tedir.
Bizim üç seçeneğimizin (hard block · clamp · `OVER_CAP` kovası) **hiçbiri** bu değil.

---

## 4. Kararlarımızı DOĞRULAYAN bulgular

Bu tur yalnız sapma bulmadı; üç kararı bağımsız olarak destekledi.

### 4.1 ✅ [[ADR 0009]]'un şekli BRD'nin kendi deseni

BRD'nin `agreements` şeması:

```sql
CHECK (cap_total_amount > 0),
CHECK (mechanic_value > 0),
```

ADR 0009 `max_combined_discount_percentage` için `CHECK (IS NULL OR > 0)` dedi — **aynı desen,
aynı belgede iki kez.** Karar BRD okunmadan verilmişti; kaynak onu doğruluyor.

⚠️ Ve bir soru açıyor: **bu iki `CHECK` bizde var mı?** Ölçülmedi → [[T-146]].

### 4.2 ✅ ADR 0007 Karar 4 / C3'ün **üç kolonlu** bölünmesi

BRD: `mechanic_type VARCHAR(20) -- 'PERCENT' | 'AMOUNT' | 'AMOUNT_PER_UNIT'`

**Üç değer** — ve `AMOUNT` ile `AMOUNT_PER_UNIT`'i **ayırıyor**. `0013 §1.1`'in üç kolonu
(`entered_rate_pct` · `entered_unit_amount` · `entered_total_amount`) bu üçlüyle **birebir**
eşleşiyor. O karar ölçümle verilmişti (*"çarpanın diğer ucu hacim, yani bu bir fiyattır"*);
kaynak aynı ayrımı yapıyor.

### 4.3 ✅ [[T-124]] — off-invoice'un `amount <= 0` reddi BRD'ye uygun

BRD `validateRow` Check 3: `if (isNaN(row.Amount) || row.Amount <= 0) errors.push(...)`

T-124 asimetriyi *"dayanaksız"* diye kaydetmişti. **Off-invoice tarafı dayanaklıymış**;
sapma **on-invoice** tarafında.

---

## 5. Yeni sapma adayları (ölçülmedi, kayda geçiyor)

| # | BRD ne diyor | Ölçülecek |
|---|---|---|
| 1 | `justification TEXT NOT NULL`, min **20 karakter**, *"Mandatory"* | Bizde zorunlu mu, uzunluk kontrolü var mı |
| 2 | STA **≤30 gün**, LTA >30 — `validateAgreement` Check 2 | Kodda süre kapısı var mı |
| 3 | `fu_id … (required)` | Bizde nullable mı |
| 4 | `import_batches` + `uq_batch_file_hash UNIQUE(tenant_id, file_hash)` | Dosya-hash idempotency'si var mı |
| 5 | Batch limitleri: **max 500 satır**, **<10MB** | Kodda karşılığı |
| 6 | `tactic_policies` (*"mode-specific rules"*) tablosu | Bizde var mı — **mod çözümünün mekanizması** |
| 7 | Satır doğrulamada **severity ataması** (CPL uyuşmazlığı=ERROR, tarih dışı=WARNING, cap aşımı=WARNING) | [[T-126]]'nın kanalıyla karşılaştır |

⚠️ **6 numaralı özellikle önemli:** tur 1'in danışman kuyruğuna aldığı *"mod kullanıcı seçimi
değil"* kararının **mekanizması** bu tablo. Ve Section_04 mod çözümü için Glossary'den
**farklı bir liste** veriyor:

| Glossary | Section_04 (4.1) |
|---|---|
| tactic eligibility · **baseline availability** · **channel maturity** · user workflow | tactic eligibility · **scope policy configuration** · **user permissions** |

**Aynı ilke, iki farklı enumerasyon.** Hangisi bağlayıcı? — bir BRD-içi tutarsızlık, ve
danışman sorusunun şeklini değiştirir.

---

## 6. Çıktı 3 — danışman kuyruğuna eklenenler ([[T-143]] filtresi)

| # | Karar | Tür | Maliyet | Danışmana |
|---|---|---|---|---|
| 5 | **CAP aşımı satırı geçirir, Finance batch onayı override'dır** | domain | yüksek | ✅ (D-01 ile birlikte) |
| 6 | **%90'da "Finance onayı gerekir" katmanı** — üç katmanlı bütçe kapısı | domain | orta-yüksek | ✅ |
| 7 | Envelope bulunamazsa **reddet** (auto-provision yok) | domain | yüksek — D-08 iki invariantı blokluyor | ✅ |
| 8 | STA ≤30 gün / LTA >30 gün ayrımı | domain | orta | 🟡 |

**Kuyruk: tur 1'den 4 + bu turdan 3-4 = 7-8.** 10-15 sınırı içinde ama `Section_05` ve
`Section_03` henüz okunmadı — ürün sahibinin uyardığı **ikinci eleme** (yalnız "çok yüksek"
maliyetliler) gerekebilir.

---

## 7. Çıktı 4 — görsel envanteri (Section_04)

| Biçim | Adet | Örnek |
|---|---|---|
| **ASCII kutu-akış diyagramı** | **6** | Actuals-First workflow (7 adım) · Batch import workflow (7 adım) · Budget integration (5 adım) · Budget & ledger state transition (4 adım) |
| **ASCII state machine** | **1** | Agreement lifecycle (Draft→Pending→Approved→Active→Closed + alternatif yollar) |
| **ASCII ekran taslağı** | **7** | Agreement form (4 adım) · Validation results · Batch approval · Budget alert · KPI dashboard |
| SQL şema bloğu | 4 | `agreements` · `import_batches` · `agreement_transactions` · (indeksler) |
| TypeScript pseudo-kod | 5 | `validateAgreement` · `validateRow` · `postBatchToLedger` · `reserveBudgetOnApproval` · `checkBudgetAvailability` |
| JSON politika örneği | 2 | STA approval policy · batch approval policy |

> **Görsel üretmeden önce var olanı say** ilkesi karşılığını buldu: Section_04 **14 hazır
> diyagram/taslak** taşıyor. Agreement lifecycle ve budget state transition **doğrudan
> mermaid'e çevrilebilir**; yeniden tasarlanmalarına gerek yok.

---

## 8. Sonraki tur

1. **Section_04'ün kalanı** (618 satır) — özellikle **4.7 Tactics & Mechanics**
2. **`Section_03_Core_Components`** — 4.8 oraya çapraz atıf veriyor (*"budget envelope schema,
   transaction types, policy configuration, Phase 1 constraints"*). §2 ve §3'ün kararları
   oraya bağlı
3. `02_Addendum` — beş HIGH PRIORITY
4. `Section_05` (2013) · Roadmap + Assumptions (niyet ayrımı)
