# 0053 — BRD okuma turu **35**: §6.3 Granularite + §6.5 Veri Sahipliği

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_06_Data_Integration.md` §6.3 (234–341) · §6.5 (478–520) · §6.7 (539–580)
- **Ölçüm ortamı:** meta `a58fc74` · backend `99ee9e6` · dev DB `main` şeması

---

## 1. ⛔ Karar 1 (Sales Actuals granularitesi) — **üç seviye kaba, ve hacim hiç yok**

> BRD Phase 1 kararı: **`Customer × SKU × Day (or Week)`**
> Gerekçesi: *"Enables **SKU-level planning** · Supports **uplift %** calculation (planned vs
> baseline **at SKU level**)"*

**Ölçüm:**

```
main.sales_actuals → tenant, batch_id, fiscal_period,
                     cpl_id · category_id · channel_id,
                     gross_amount · net_amount · discount_amount
```

| BRD ekseni | bizde |
|---|---|
| Customer | **CPL** (bir üst seviye) |
| **SKU** | **Category** (iki üst seviye) |
| Day / Week | **fiscal_period** (ay) |
| baseline **hacmi** | ❌ **hiç yok** — tablo yalnız **para** taşıyor |

Ve `volume` kolonu taşıyan tablolar: `forecasting_units` · `plan_fus` · `plan_skus` ·
`plans` · `lta_rates` — **hiçbiri bir içe-aktarım tablosu değil**. `baseline`/`volume` adlı
tablo **yok**.

> ### `sales_actuals` bir baseline kaynağı DEĞİL — adı öyle sanmaya davet ediyor.
> İçe aktarılan actuals, BRD'nin baseline gerekçesini (**SKU seviyesinde uplift %**)
> **yapısal olarak** karşılayamaz: ne SKU var, ne hacim.

Bu, [[T-024]]'ün (baseline verisi) **yapısal açıklaması**: eksik olan yalnız veri değil,
**onu tutacak granularite**. Ve `§6.7` *"❌ Automatic baseline calculation (requires data
warehouse)"* diyerek Phase 1'de **otomatik hesaplamayı** dışlıyor — ama içe aktarımı
(*"✅ Sales actuals import (daily batch file)"*) **dışlamıyor**.

→ [[T-024]] güncellendi.

⚠️ **Ölçümün sınırı:** *"baseline böyle olmalıydı"* demiyorum — granularite bir **ürün
kararıdır** ve BRD'nin kendisi de öyle diyor (*"This is a product decision, not a technical
limitation"*). Ölçülen şey, **bizimkinin BRD'nin kararından farklı olduğu ve bu farkın
hiçbir yerde yazılı olmadığı**.

---

## 2. ✅ Karar 2 (Bütçe granularitesi) — **uyumlu**, ve bir boyut fazla (gerekçeli)

> BRD Phase 1 kararı: **`Channel × Category × Period`**

```
main.budget_envelopes → fiscal_year · period · channel_id · category_id · spend_type
```

| | |
|---|---|
| Channel × Category × Period | ✅ **birebir** |
| **`spend_type`** (ON/OFF invoice) | ➕ fazladan — **ADR 0004** ile gerekçeli |
| CPL / Brand / Region boyutu | ❌ yok — BRD de Phase 1'de istemiyor |

> BRD'nin *"Avoids over-engineering"* gerekçesiyle **aynı yerde** duruyoruz. Sekizinci
> habersiz yakınsama; ve tek fark bir ADR'ye dayanıyor.

📌 `budget_envelopes` de `channel`/`category` **metin** kolonlarını `channel_id`/`category_id`
FK'lerinin yanında taşıyor — `customers`'takiyle aynı ikilik (`0052 §2`). Bugün ölçülen
uyuşmazlık yok; kayda geçiyor.

---

## 3. 📌 Karar 3 (Fatura granularitesi) — satır ve SKU ✅, **anlaşma bağı yok**

> BRD Phase 1 kararı: **`Invoice × Line (with optional Agreement link)`**
> Gerekçesi: *"Agreement link enables **spend attribution** (which agreement consumed
> budget)"*

```
main.on_invoice_entries → invoice_no · invoice_date · customer_id · sku_id · quantity
                          list_price · actual_price · discount · budget_envelope_id
main.agreement_id taşıyan tablolar → budget_reservations · ledger_entries · agreement_transactions
```

| BRD | bizde |
|---|---|
| Invoice × Line | ✅ |
| SKU detayı | ✅ `sku_id` |
| **Agreement link** (opsiyonel) | ❌ satırda yok — **`budget_envelope_id`** var |

> Yani satır **hangi bütçeyi** tükettiğini biliyor, **hangi anlaşmanın** tükettiğini
> taşımıyor.

⚠️ **Ölçülmedi:** atfın `ledger_entries`/`budget_reservations` üzerinden **geri
kurulabilir** olup olmadığı. *"İmkânsız"* demiyorum — bu tam da `CLAUDE.md`'nin
*"ulaşılamaz yazmadan önce ölç"* kuralının kapsamı. Ölçülen tek şey: **satırın kendisinde
yok**, ve BRD onu opsiyonel sayıyor.

---

## 4. 🔴 §6.5 — bir **yönetişim kuralı**, ve bugün kazara sağlanıyor

> *"**In case of discrepancies, the source-of-truth system always prevails; CollMind does
> not override enterprise financial records.** This is a **non-negotiable** rule"*
> *"CollMind is always in **read mode** for master/transactional data"*

| veri | BRD sahibi | CollMind rolü |
|---|---|---|
| Customer Master · Product Master · Sales Actuals · Invoice | **ERP** | **Consumer (read-only)** |
| CPL · FU · Tactics · Plans · Agreements · Ledger | **CollMind** | Owner |
| Budget Allocations | duruma göre | Hybrid |

**Ölçüm:** `modules/master-data` altında **39 yazma ucu** (`@Post`/`@Put`/`@Patch`/`@Delete`),
11 controller'da — `cpl` · `fu` · `tactic` · `mechanic` · `kpi` · `region` **(BRD'ye göre
bizim)** ve `sku` · `brand` · `category` · `generic-unit` · `channel` **(BRD'ye göre ERP'nin)**.

### Uzlaştıran okuma — ve kuralın gerçek statüsü

`§6.7` Phase 1'de *"Customer import (API or daily file)"* ve *"Product import"* diyor; ERP
**konektörlerini** ise açıkça dışlıyor (*"❌ Pre-built ERP connectors"*).

> **Bugün bir ERP yok — yani çelişecek bir kaynak da yok.** Kural **ihlal edilmiyor**,
> çünkü ihlal edilebileceği durum henüz oluşmuyor.
>
> ⚠️ Ama `§6.5` bir **dağıtım-zamanı** kuralıdır ve bugün onu koruyacak **hiçbir mekanizma
> yok**: bir kaydın *"ERP tarafından yönetiliyor"* olduğunu işaretleyen bir alan, ya da
> ürün master'ını yazmaya kapatan bir mod bulunmuyor.

Bu, turu 32'nin **7 yıl saklama** bulgusuyla **aynı şekil**: *şart kazara sağlanıyor
(hiçbir şey silinmiyor / hiçbir ERP yok), ve sağlandığı için korunmuyor.* İlk ERP
entegrasyonu günü sessizce ihlal edilir.

→ [[T-175]] (P3 — **bugün bir kusur değil, ilk entegrasyonun ön koşulu**)

---

## 5. Okunmayan / sonraki tur

`Section_06` **tamamlandı** (§6.1/6.2/6.4/6.6 daha önce okundu; §6.7 bu turda).

Kalan 🟡: `§11.2` + P2/P3 riskleri · `§10.3` · Addendum H5.2/5.3 (~440 satır, **~1 tur**).
