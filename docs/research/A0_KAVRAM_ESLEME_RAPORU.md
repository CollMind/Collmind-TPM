# `A0'` — KAVRAM EŞLEME RAPORU: **`NIV(3)` + `Turnover(4)`**

> **iş:** `W2` `DALGA-A` / `A0'` · **hüküm:** `docs/brd-v2/04_KARAR_KAYDI.md` `Z64 §2`–`§3`
> **yazan:** `data-analyst` · **tarih:** 2026-08-30 · **statü:** salt-okunur ölçüm
> **işaretleme:** `[ÖLÇÜLDÜ]` bugün canlı · `[GEREKÇELİ]` türetildi · `ÖLÇEMEDİM`
>
> ⛔ **Bu tur hiçbir kolon/enum/`kpi_code` DEĞİŞTİRMEDİ, migration YAZMADI, e2e KOŞMADI.**
> Ölçüm evreni: `main.kpis` (canlı satır) + `collmind.backend/src` (çalışma-zamanı kodu)
> + `collmind.frontend/src` (grid) + `Section_05 §5.3` + Excel referansı `§1`.

---

## ⭐ 0 · MANŞET — `Turnover` KAYIP DEĞİL, **ÜSTÜNE YAZILMIŞ**

`Z64 §2` *"Excel'in gerçek TO'su canlıda **hiç olmayabilir**"* diyordu. Ölçüm bundan
daha keskin bir şey buldu:

```
migration 1780000000000  FixKpiBrdFormulas          (uygulandı, main.migrations id=171)
    BASE_TO    = BASE_GSV - BASE_LTA_ON - BASE_LTA_OFF     ← Excel BaseTurnover   ✅
    PLANNED_TO = PLANNED_GSV - TOTAL_PLANNED_SPEND         ← Excel PlannedTO      ✅
                 ↓
migration 1781000000000  FixTurnoverOnInvoiceOnly (T-008)  (uygulandı, id=172)
    başlıkta:  "YANLIŞ (1780 sonrası)"  →  "DOĞRU (bu migration sonrası)"
    BASE_TO    = BASE_GSV - BASE_LTA_ON                    ← Excel BaseNIV        ⚠️
    PLANNED_TO = PLANNED_GSV - PLANNED_ON_INVOICE_SPEND    ← Excel PlannedNIV     ⚠️
```

⇒ **`Turnover(4)` grubu canlıda BİR MİGRATION BOYUNCA DOĞRU HÂLDE VARDI ve `T-008`
onu `NIV` semantiğiyle EZDİ — `kpi_code`'ları değiştirmeden.** `[ÖLÇÜLDÜ]`

📌 Bu, `Z64`'ün *"iki kavram tek ada sıkıştı"* teşhisinin **kökenidir**: ad-borcu bir
isimlendirme kazası değil, **bir düzeltme turunun yan ürünüdür**. Ve `1781`'in başlığı
o anki hâli *"YANLIŞ"* ilan ederek **eski semantiği koruma altına almanın tersini**
yaptı — `CLAUDE.md §7.1`: *"bir hatayı belgelemek onu koruma altına alır"*, burada
**doğrusunu yanlış diye belgelemek** aynı işi ters yönde yaptı.

⛔ **VE `T-008` KARDEŞ YOLU SAYMADI** (`§7.1` ihlali, `[ÖLÇÜLDÜ]`):
`collmind.frontend/src/components/features/plans/PlanningGridEnhanced.tsx`
**bugün hâlâ `1780` semantiğini taşıyor** —

```
FE  BASE_TO  = baseGSV − baseLtaOn − baseLtaOff            (satır 218–222)
BE  BASE_TO  = BASE_GSV − BASE_LTA_ON                      (main.kpis, canlı satır)
```

⇒ **Aynı kod (`BASE_TO`), iki yüzeyde iki farklı sayı.** Grid canlı rotada
(`PlanDetailPage.tsx:27` → `PlanningGridEnhanced`) render ediliyor.

---

## `§1` · YEDİ KALEM — kalem kalem

> **Sütun 2 bir FORMÜL karşılaştırmasıdır.** Ad eşleşmesi kanıt sayılmadı (`Z64 §3`).
> Cebirsel denklik gösterilirken canlı `external` KPI'ların **çalışma-zamanı kaynağı**
> izlendi: `plan.service.ts:2438-2447` context enjeksiyonu →
> `spend-calculation.service.ts:486-646`.

### `NIV(3)` — Excel `§1 NIV`

#### `N1` · **Base NIV** — Excel `BaseNIV = BaseGSV × (1 − LTAOnPct)`

| | |
|---|---|
| **1 canlı-karşılık** | **`BASE_TO`** — `main.kpis`, `formula_text = 'BASE_GSV - BASE_LTA_ON'`, `deps ["BASE_GSV","BASE_LTA_ON"]`, `order 25`, `is_active t` |
| **2 SEMANTİK KANIT** | `BASE_LTA_ON` `external`; çalışma-zamanı değeri `spendBreakdown.base.ltaOnInvoice` = `baseLtaOnInv = (baseGsv * ltaOnInvoicePct) / 100` (`spend-calculation.service.ts:509`). ⇒ `BASE_TO = BaseGSV − BaseGSV×LTAOnPct/100 = BaseGSV × (1 − LTAOnPct)` — **Excel formülüyle cebirsel olarak AYNI** |
| **3 verdict** | **eşleşen-doğru** ⛔ **`AD-BORCU`** |

⛔ `AD-BORCU-1`: kavram `BaseNIV`, taşıyan ad `BASE_TO`.

#### `N2` · **Planned NIV** — Excel `PlannedPromoNIV = PlannedPromoGSV − PlannedPromoTotalSpendOn`

| | |
|---|---|
| **1 canlı-karşılık** | **`PLANNED_TO`** — `formula_text = 'PLANNED_GSV - PLANNED_ON_INVOICE_SPEND'`, `order 26`, `is_active t` |
| **2 SEMANTİK KANIT** | `PLANNED_ON_INVOICE_SPEND` `external`, `order 12`; enjekte edilen değer `spendBreakdown.planned.totalOnInvoice` = `plannedLtaOnInv + totalPromoOnInv` (`spend-calculation.service.ts:636`, `plan.service.ts:2414`). Excel `PlannedPromoTotalSpendOn = PlannedOnIInvoiceDiscounts + PlannedPromoLTAOnInvoice` — **terim terim aynı bileşim** |
| **3 verdict** | **eşleşen-doğru** ⛔ **`AD-BORCU`** |

⛔ `AD-BORCU-2`: kavram `PlannedNIV`, taşıyan ad `PLANNED_TO`.

#### `N3` · **iNIV** — Excel `PlannedIncrNIV = PlannedPromoNIV − BaseNIV`

| | |
|---|---|
| **1 canlı-karşılık** | **YOK** — `main.kpis`'te `INCR_TO`/`INCR_NIV`/eşdeğer **hiçbir satır yok** (27 satırın tamamı `§2`'de) |
| **2 SEMANTİK KANIT** | İki yerde **hesaplanıyor ama KPI motoruna girmiyor**: (a) `spend-calculation.service.ts:1113` `niv.incrementalNiv = plannedNiv − baseNiv` — formül **doğru**, ama içinde bulunduğu `calculateCompleteSKUFinancialMetrics` metodunun **ÜRETİM ÇAĞRISI SIFIR** (`rg` tüm backend: yalnız `*.spec.ts` + bir yorum) `[ÖLÇÜLDÜ]`; (b) frontend `INCR_NIV` kolonu (`PlanningGridEnhanced.tsx:207-215`) — formül **Excel'le aynı**, ama **TypeScript'e gömülü** ⇒ *"formüller veridir, kod değildir"* ihlali |
| **3 verdict** | **YOK** (canlı `kpis` evreninde) |

---

### `Turnover(4)` — Excel `§1 Turnover`

#### `T1` · **Base TO** — Excel `BaseTurnover = BaseGSV − BaseTradeSpend` (`= BaseLTAOn + BaseLTAOff`)

| | |
|---|---|
| **1 canlı-karşılık** | **YOK.** `BASE_TO` adı bu kavrama ait **değil** (`N1`'e ait). Bu kavramı hesaplayan **hiçbir `kpis` satırı yok** |
| **2 SEMANTİK KANIT** | Excel `BaseGSV − (BaseLTAOn + BaseLTAOff)`. Canlı `BASE_TO` yalnız `BASE_LTA_ON` düşer ⇒ **fark = `BASE_LTA_OFF`**, ve bu sıfır değildir (`BASE_LTA_OFF` canlı bir `external` KPI, `order 8`, `is_active t`). Malzeme **tam** (`BASE_GSV`, `BASE_TOTAL_SPEND = base.ltaOn + base.ltaOff`), **onu birleştiren satır yok**. `1780` bu satıra sahipti, `1781` sildi |
| **3 verdict** | **YOK** ⛔ **`AD-BORCU` (ters yön)** — ad **işgal altında** |

⛔ `AD-BORCU-3`: `BASE_TO` adı, ait olmadığı kavramı taşıyor ⇒ bu kalem inerken
**adını geri alamaz.** Frontend'de aynı ad **bu** kavramı gösteriyor.

#### `T2` · **Planned TO** — Excel `PlannedPromoTurnover = PlannedPromoGSV − PlannedPromoTotalSpend` (**ON+OFF**)

| | |
|---|---|
| **1 canlı-karşılık** | **YOK.** `PLANNED_TO` adı `N2`'ye ait |
| **2 SEMANTİK KANIT** | Excel paydası **`TotalSpend` (on+off)**; canlı `PLANNED_TO` yalnız **on**-invoice düşer ⇒ **fark = `totalOffInvoice` = `PLANNED_LTA_OFF + Σ off-invoice promo`**. Malzeme canlıda **var** (`TOTAL_PLANNED_SPEND` `external`, `order 9`) — `PLANNED_GSV − TOTAL_PLANNED_SPEND` tam olarak `1780`'in formülüydü ve `1781` onu *"YANLIŞ"* ilan etti |
| **3 verdict** | **YOK** ⛔ **`AD-BORCU` (ters yön)** |

⛔ `AD-BORCU-4`.

#### `T3` · **iTO** — Excel `PlannedIncrTO = PlannedPromoTurnover − BaseTurnover`

| | |
|---|---|
| **1 canlı-karşılık** | **YOK** — hiçbir ad altında yok |
| **2 SEMANTİK KANIT** | Bağımlılıkları (`T1`,`T2`) canlıda **olmadığı için** türetilemez. Backend `turnover.incrementalTo` (`spend-calculation.service.ts:1126`) **var ama `= niv.incrementalNiv`** (satır 1122-1123 `baseTo = niv.baseNiv`, `plannedTo = niv.plannedNiv`) ⇒ **`iTO` adı altında `iNIV` hesaplıyor**, ve zaten üretim çağrısı yok. Frontend `INCR_TO` (`:234-248`) **Excel semantiğiyle doğru**, ama TS'e gömülü |
| **3 verdict** | **YOK** |

#### `T4` · **TO Uplift %** — Excel `PlannedIncrPromoTOPct = (PlannedIncrTO / BaseTurnover) × 100`

| | |
|---|---|
| **1 canlı-karşılık** | **YOK**. (Canlı `UPLIFT_PCT` **hacim** upliftidir: `(PLAN_VOL - BASE_VOL) / BASE_VOL * 100`, `kpi_group='Volume'` — **başka kalem**, Excel `VOLUME` grubunun `Volume Uplift %`'i) |
| **2 SEMANTİK KANIT** | Payı da paydası da (`T3`, `T1`) canlıda yok ⇒ türetilemez. Frontend `TO_UPLIFT_PCT` (`:249-262`) Excel semantiğiyle var, TS'e gömülü |
| **3 verdict** | **YOK** |

---

### `§1.1` · ÖZET TABLO

| # | Excel kalemi | canlı `kpis` satırı | verdict | `AD-BORCU` |
|---|---|---|---|---|
| `N1` | Base NIV | **`BASE_TO`** | **eşleşen-doğru** | ✅ `AD-BORCU-1` |
| `N2` | Planned NIV | **`PLANNED_TO`** | **eşleşen-doğru** | ✅ `AD-BORCU-2` |
| `N3` | iNIV | YOK | **YOK** | — |
| `T1` | Base TO | YOK (*ad işgal altında*) | **YOK** | ✅ `AD-BORCU-3` |
| `T2` | Planned TO | YOK (*ad işgal altında*) | **YOK** | ✅ `AD-BORCU-4` |
| `T3` | iTO | YOK | **YOK** | — |
| `T4` | TO Uplift % | YOK | **YOK** | — |

```
eşleşen-doğru   2        eşleşen-sapmalı  0        YOK  5        AD-BORCU  4
```

⛔ **`eşleşen-sapmalı` kovası BOŞ ve bu ANLAMLIDIR:** canlıdaki iki satır Excel'in
**NIV** formüllerine **birebir** uyuyor. Sorun formülün yanlışlığı değil —
**doğru formülün YANLIŞ ADI taşıması**, ve o adın gerçek sahibinin **yerinden edilmesi**.

---

## `§2` · CANLI `main.kpis` TAM DÖKÜMÜ  `[ÖLÇÜLDÜ` 2026-08-30, `bash scripts/db-query.sh]`

```
şema  main   ·  tenant  598a895e-5a20-48cc-95bd-a52fe5d4bb65 (TEK tenant)
satır 27     ·  is_active=true 24   ·  is_active=false 3   ·  deleted_at IS NULL 27
```
⚠️ `public` şemasında `kpis` tablosu **yok** (`information_schema.tables` taraması) —
şema-karışması riski bu tabloda **mevcut değil**. `[ÖLÇÜLDÜ]`

| ord | kod | ad | grup | tip | `formula_text` | `depends_on` | agg | aktif |
|---:|---|---|---|---|---|---|---|---|
| 1 | `BASE_VOL` | Base Volume | Volume | user_input | `BASE_VOL` | — | sum | ✅ |
| 2 | `PLAN_VOL` | Planned Volume | Volume | user_input | `PLAN_VOL` | — | sum | ✅ |
| 5 | `PLANNED_LTA_ON` | Planned LTA On-Invoice | Spend | external | `PLANNED_LTA_ON` | — | sum | ✅ |
| 5 | `PLAN_TURNOVER` | Planned Turnover | Revenue | expression | `PLAN_VOL * BPTT` | — | sum | ❌ *(1782)* |
| 6 | `PLANNED_LTA_OFF` | Planned LTA Off-Invoice | Spend | external | `PLANNED_LTA_OFF` | — | sum | ✅ |
| 6 | `TACTIC_SPEND` | Tactic Spend | Spend | external | `TACTIC_SPEND` | — | sum | ❌ *(1782)* |
| 7 | `BASE_LTA_ON` | Base LTA On-Invoice | Spend | external | `BASE_LTA_ON` | — | sum | ✅ |
| 7 | `GP` | Gross Profit | Profit | expression | `(PLAN_VOL * BPTT) - (PLAN_VOL * COGS) - TACTIC_SPEND` | — | sum | ❌ *(1782)* |
| 8 | `BASE_LTA_OFF` | Base LTA Off-Invoice | Spend | external | `BASE_LTA_OFF` | — | sum | ✅ |
| 9 | `TOTAL_PLANNED_SPEND` | Total Planned Spend | Spend | external | `TOTAL_PLANNED_SPEND` | — | sum | ✅ |
| 10 | `BASE_TOTAL_SPEND` | Base Total Spend | Spend | external | `BASE_TOTAL_SPEND` | — | sum | ✅ |
| 11 | `INCR_SPEND` | Incremental Spend | Spend | external | `INCR_SPEND` | — | sum | ✅ |
| 12 | `PLANNED_ON_INVOICE_SPEND` | Planned On-Invoice Spend | Spend | external | `PLANNED_ON_INVOICE_SPEND` | `[]` | sum | ✅ |
| 15 | `BASE_GSV` | Base GSV | Revenue | expression | `BASE_VOL * BPTT` | `BASE_VOL, BPTT` | sum | ✅ |
| 16 | `PLANNED_GSV` | Planned GSV | Revenue | expression | `PLAN_VOL * BPTT` | `PLAN_VOL, BPTT` | sum | ✅ |
| 20 | `INCR_VOL` | Incremental Volume | Volume | expression | `PLAN_VOL - BASE_VOL` | `PLAN_VOL, BASE_VOL` | sum | ✅ |
| 21 | `UPLIFT_PCT` | Uplift % | Volume | expression | `(PLAN_VOL - BASE_VOL) / BASE_VOL * 100` | `PLAN_VOL, BASE_VOL` | weighted_avg | ✅ |
| 25 | `BASE_TO` | Base Turnover | Revenue | expression | `BASE_GSV - BASE_LTA_ON` | `BASE_GSV, BASE_LTA_ON` | sum | ✅ |
| 26 | `PLANNED_TO` | Planned Turnover | Revenue | expression | `PLANNED_GSV - PLANNED_ON_INVOICE_SPEND` | `PLANNED_GSV, PLANNED_ON_INVOICE_SPEND` | sum | ✅ |
| 30 | `BASE_COGS` | Base COGS | Cost | expression | `BASE_VOL * COGS` | `BASE_VOL, COGS` | sum | ✅ |
| 31 | `PLANNED_COGS` | Planned COGS | Cost | expression | `PLAN_VOL * COGS` | `PLAN_VOL, COGS` | sum | ✅ |
| 35 | `BASE_GP` | Base Gross Profit | Profit | expression | `BASE_TO - BASE_COGS` | `BASE_TO, BASE_COGS` | sum | ✅ |
| 36 | `PLANNED_GP` | Planned Gross Profit | Profit | expression | `PLANNED_TO - PLANNED_COGS` | `PLANNED_TO, PLANNED_COGS` | sum | ✅ |
| 46 | `INCR_GP` | Incremental Gross Profit | Profit | expression | `PLANNED_GP - BASE_GP` | `PLANNED_GP, BASE_GP` | sum | ✅ |
| 47 | `CPP_ON_SPEND` | CPP On-Invoice Spend | Spend | expression | `(PLANNED_GSV - PLANNED_LTA_ON) * CPP_ON_PCT / 100` | `PLANNED_GSV, PLANNED_LTA_ON, CPP_ON_PCT` | sum | ✅ |
| 48 | `GP_ROI_PCT` | GP ROI % | ROI | expression | `INCR_GP / TOTAL_PLANNED_SPEND * 100` | `INCR_GP, TOTAL_PLANNED_SPEND` | weighted_avg | ✅ |
| 49 | `GP_MARGIN_PCT` | GP Margin % | Profit | expression | `PLANNED_GP / PLANNED_TO * 100` | `PLANNED_GP, PLANNED_TO` | weighted_avg | ✅ |

**RAG eşikleri:** `main.kpis` içinde **yalnız `GP_ROI_PCT`** taşıyor —
`rag_green_threshold = 20.0000`, `rag_amber_threshold = 10.0000`. Diğer 26 satırda
**NULL**. `[ÖLÇÜLDÜ]` · Bir `RAG_STATUS` KPI satırı **yok**.

**Motor davranışı:** `kpi-engine.service.ts:586-587` → `where { tenantId, isActive: true }`,
`order { calculationOrder: 'ASC' }` ⇒ **motorun gördüğü evren tam olarak yukarıdaki 24 satır.**
Üç `is_active=false` satır `1782000000000-DeactivateLegacyKpis` ile kapatıldı. `[ÖLÇÜLDÜ]`

**Migration ↔ canlı satır çelişkisi:** **YOK.** `1781`'in yazdığı iki `formula_text`
canlı satırlarla **birebir aynı**; `kpi.seed.ts` de aynı metni taşıyor. `[ÖLÇÜLDÜ]`
⇒ `Z64`'ün öngördüğü *"migration bir niyet beyanıdır"* riski bu iki satırda
**gerçekleşmemiş**; migration metni **doğru** okunmuştu.

---

## `§3` · EVREN ETKİSİ — *"eksik-18 küçülüyor mu?"*

### `3.1` · Sayı

```
"eksik-18"nin türetimi   42 (Section_05 SQL kütüphanesi) − 24 (canlı aktif) = 18   [GEREKÇELİ]
                         ⚠️ brief'te tanımı yazılı değil; başka bir türetme bulunamadı

evren hükmü 52 (Z62 §6-1)  ⇒  nominal boşluk  52 − 24 = 28                          [GEREKÇELİ]
```

### `3.2` · CEVAP: **KÜÇÜLMÜYOR. BÜYÜYOR — ve asıl mesele bu bile değil.**

Yedi kalemin bilançosu: **2 karşılanmış · 5 karşılanmamış.**

⛔ **VE ŞU SAYIM DENEYİ YAPILDI** — `Z64 §2`'nin yasakladığı ad-düzeyi okuma ile
doğru semantik okuma **yan yana** kondu:

| okuma | `NIV(3)` | `Turnover(4)` | **eksik** |
|---|---|---|---|
| ❌ ad-düzeyi (*"TO var ⇒ Turnover eşleşti"*) | 0/3 karşılandı | 2/4 karşılandı | **5** |
| ✅ semantik (bu rapor) | **2/3** karşılandı | **0/4** karşılandı | **5** |

> ### ⛔ İKİ OKUMA AYNI SAYIYI VERİYOR — `5`.
> **Yanlış eşleme, TOPLAMDA GÖRÜNMEZ.** Ayrıştığı yer sayı değil, **kimlik**tir.

📌 Bu, `DISIPLIN`'in *"bir TOPLAMIN azalması, bir SINIFIN girmediğinin kanıtı değildir"*
maddesinin **tam simetriği**: burada toplamın **değişmemesi**, sınıfın doğruluğunun
kanıtı değil. Bir sayım-kontrolü bu hatayı **asla yakalayamazdı**.

**Ve pratik sonucu ölçülebilir:** ad-düzeyi okuma kabul edilseydi —
```
Turnover  "2/4 var"  ⇒  Base/Planned TO ASLA İNŞA EDİLMEZDİ  (zaten var sanılırdı)
NIV       "0/3 var"  ⇒  Base/Planned NIV İKİNCİ KEZ inşa edilirdi (zaten vardı)
sonuç     iki kalem KAYIP + iki kalem ÇİFT   —  ve gap sayısı 5 olarak DOĞRU görünürdü
```

### `3.3` · Zincir etkisi — `Turnover`'ın yokluğu **beş kalemi daha** kirletiyor

Canlı `PLANNED_TO` aslında `NIV` olduğu için, ona bağlı her satır `NIV` tabanlıdır:

| canlı satır | canlı formül | Excel karşılığı | yön |
|---|---|---|---|
| `BASE_GP` | `BASE_TO − BASE_COGS` | `BaseTurnover − BaseCOGS` | GP **yüksek** (`BASE_LTA_OFF` kadar) |
| `PLANNED_GP` | `PLANNED_TO − PLANNED_COGS` | `PlannedTurnover − PlannedCOGS` | GP **yüksek** (`totalOffInvoice` kadar) |
| `INCR_GP` | `PLANNED_GP − BASE_GP` | aynı ad | **artımsal off-invoice harcaması kadar yüksek** |
| `GP_ROI_PCT` | `INCR_GP / TOTAL_PLANNED_SPEND` | aynı ad | **payı şişik ⇒ ROI İYİMSER** |
| `GP_MARGIN_PCT` | `PLANNED_GP / PLANNED_TO` | payda `Turnover` | pay **ve** payda sapmalı |

⛔ **YÖN TEHLİKELİ:** off-invoice harcaması `GP`'nin **payına hiç girmiyor**, yalnız
`ROI` **paydasına** giriyor. `1781`'in başlığı *"off-invoice spend … GP hesabına
incremental spend olarak girer"* diyor — **canlı formüllerde bu KARŞILIĞINI BULMUYOR**
(`PLANNED_GP = PLANNED_TO − PLANNED_COGS`; harcama terimi yok). `[ÖLÇÜLDÜ]`
⇒ `CLAUDE.md §2.7`: *"kod yorumunda yazmadan önce ölç."* Bu bir **yorum-kirliliği** vakası.

⚠️ **Bu beş kalem `A0'` evreninin dışındadır** ⇒ verdict **yazılmadı**; `A1`'in girdisidir.

### `3.4` · Üçüncü yüzey — frontend, ve `BRD`-dinamik-formül ihlali

`PlanningGridEnhanced.tsx` **13 grup / 58 kolon**'luk bir kolon evrenini
`column-definitions.ts`'te **hardcode** taşıyor (`NIV & Turnover` grubu: 7 kolon —
`BASE_NIV · PLAN_NIV · INCR_NIV · BASE_TO · PLAN_TO · INCR_TO · TO_UPLIFT_PCT`).
`[ÖLÇÜLDÜ]`

```
FE NIV kolonları  ≡ Excel NIV       ✅   (BE ile de aynı sayı)
FE TO  kolonları  ≡ Excel Turnover  ✅   (BE'de KARŞILIĞI YOK — 1780 semantiği)
FE PLAN_GP        ← backend plannedGp (NIV tabanlı)
FE BASE_GP        ← FE'de yerel hesap (TO tabanlı)
   ⇒ FE INCR_GP = plannedGp − baseGp  →  İKİ FARKLI TO SEMANTİĞİNİ ÇIKARIYOR
```

⛔ **VE AYNI DOSYADA İKİNCİ BİR İMPLEMENTASYON:** `getFuCellValue` (satır `536-600+`)
`BASE_NIV · PLAN_NIV · INCR_NIV · BASE_TO · PLAN_TO · INCR_TO · TO_UPLIFT_PCT`
formüllerinin **tamamını SKU-döngüsü içinde yeniden yazıyor** — `getSkuCellValue`'nun
(satır `196-262`) bağımsız bir kopyası. `[ÖLÇÜLDÜ]`
📌 `CLAUDE.md §7` ailesi (*"aynı yetenek bu projede birden çok kez yazıldı"*): tek bir
kavram bugün **üç yerde** tanımlı — `main.kpis` (motor) · `getSkuCellValue` · `getFuCellValue`
— ve **ilki diğer ikisiyle çelişiyor**.
⛔ Sonuncusu bir **karışık-semantik çıkarma**: `A1`'in değil, bir **hata kaydının** konusu.
Team Lead'e bildirilir; bu tur **düzeltme yapmadı** (`DALGA-A` üretim kodu yazmaz).

📌 Ve evren tarafında: kolon listesi ne `42` ne `52`'dir (**58 / 13 grup**, `ITEM_INFO`
hariç **56 / 12**). ⇒ **Dördüncü bir evren beyanı**, ve `A4`'ün adreslediğinden farklı.
`F8` ailesi (*"sayı dört yerde dört farklı"*) — bugün **beş** yerde.

---

## `§4` · ⛔ ÖLÇEMEDİM

| # | ölçemediğim | neden | sonucu ne olurdu |
|---|---|---|---|
| 1 | **Hiçbir ÇALIŞMA-ZAMANI SAYISI** | `main.plans = 0`, `plan_fus = 0`, `plan_skus = 0` `[ÖLÇÜLDÜ]` ⇒ bugün **bu yolların hiçbiri koşmuyor** | `§1`'in tüm kanıtları **konfigürasyon + kod okumasıdır**, üretilmiş değer değil. `DISIPLIN`: *"verinin yokluğu örter"* — `T-273` ailesi |
| 2 | `1780` semantiğinin **fiilen çalıştığı** dönemde ürettiği sayılar | tarihsel veri yok; `plans` boş | `T-008`'in *"YANLIŞ"* yargısının veriye dayanıp dayanmadığı |
| 3 | Frontend grid'in **gerçekten** bu kolonları render ettiği | plan verisi yok; **e2e yasak** (bu turun şartı) | `§3.4`'ün kullanıcı-görünür etkisinin büyüklüğü |
| 4 | `EffectiveTotalIMSVolumePC` (sell-out hacmi) | kaynağı **hiçbir belgede yok** — `Z62 §6-2` **AÇIK-SORU** | Canlı `PLANNED_COGS = PLAN_VOL * COGS` ve `PRICE_SUPPORT` **sell-in** hacmi kullanıyor `[ÖLÇÜLDÜ]`; bunun **vekil mi doğru mu** olduğu **karara bağlı** ⇒ ⛔ sessiz-ikame yasağı gereği *"eşleşti"* **YAZILMADI** |
| 5 | `52` evreninin **8 adsız kalemi** (`KPI 21-28`) | `Section_05`'te tek yorum satırı, SQL yok | `A4 §2 GRUP 7` → `[KAYNAKTA YOK]` |
| 6 | Excel-`49` ↔ BRD-`52` farkının hangisinin kanonik olduğu | iki kaynak, hüküm yok | `§5` soru `Q4` |
| 7 | `calculateCompleteSKUFinancialMetrics`'in bir HTTP rotasından erişilebilirliği — **kesin** olarak | `rg` tüm `collmind.backend` üzerinde **yalnız `*.spec.ts`** buldu `[ÖLÇÜLDÜ]`; uygulamayı **çalıştırmadım** | `N3`/`T3`'ün *"var ama ulaşılamaz"* statüsü. Grep güçlü, koşum yok ⇒ `blocked-unreachable` **iddia edilmedi** |
| 8 | Off-invoice mekanik **tabanının** doğruluğu | `spend-calculation.service.ts:280-281` tabanı `GSV − LTA_On − **LTA_Off** − Σon-promo` alıyor; **Excel de BRD de** `LTA_Off`'u düşmüyor (`= PlannedNIV`) `[ÖLÇÜLDÜ]` | **Üçüncü bir formül sapması**, `7 kalem`in DIŞINDA ⇒ verdict yazmadım, `§5 Q5`'e taşıdım |

**ÖLÇEMEDİM kalem sayısı: 8.**

---

## `§5` · ÜRÜN SAHİBİNE AÇIK SORULAR — *evren hükmü için gerekli*

> ⛔ Hiçbirinde varsayım yapılmadı (`CLAUDE.md §2.4`). Beşi de **eşlemeyi bloke eder.**

**`Q1` — `AD-BORCU` nasıl kapanacak? (⭐ `A1`'i doğrudan bloke eder)**
Bugün `BASE_TO`/`PLANNED_TO` adları `NIV` kavramını taşıyor; gerçek `Turnover` inerken
o adları **isteyecek**. Üç yol, üçünün de bedeli farklı:
```
(a) YENİDEN ADLANDIR   BASE_TO→BASE_NIV, PLANNED_TO→PLANNED_NIV; TO adları boşalır
                       bedel: veri dokunuşu (kpi_code) + calculatedKpis JSONB anahtarları
                              + FE kolon kodları + 1781/seed metinleri  ⇒ GENİŞ
(b) YENİ AD VER        gerçek TO'ya farklı kod (ör. TO_NET_*) ⇒ veri dokunmasız
                       bedel: kod adı ile kavram KALICI olarak ayrışır (borç kalır)
(c) ERTELE             borcu kayıtta tut, A1 eşlemesini AD-BORCU etiketiyle yaz
```
`Z64 §3` bu turda **(c)** dedi (*"VERİ-DOKUNMASIZ"*). **`A1` için hangisi?**

**`Q2` — `T-008`/`1781` bir DÜZELTME miydi, yoksa bir SAPMA mı?**
`1780` Excel-`Turnover`'ını doğru kurmuştu; `1781` onu *"YANLIŞ"* ilan edip `NIV`'e
çevirdi. Ürünün **her ikisine de** ihtiyacı var (`NIV` off-invoice mekanik tabanı,
`TO` net ciro). ⇒ **`1781` geri alınmayacak** ama başlığındaki *"YANLIŞ"* yargısı
**kayda geçmeli mi** (`F12` izi), yoksa `Turnover` yeni bir kalem olarak mı inecek?

**`Q3` — `GP` tabanı hangisi? (⛔ finansal yön taşır)**
Canlı `PLANNED_GP = NIV − COGS`; Excel `PlannedGP = TO − COGS`. Fark **artımsal
off-invoice harcaması** kadar ve **`GP_ROI_PCT`'yi İYİMSER** yapıyor (`§3.3`).
`GP` tabanı `NIV` mi `TO` mu? — Bu, `RAG` renklerini doğrudan değiştirir.

**`Q4` — evren `52` (BRD tabanlı) mı, `49` (Excel tabanlı) mı?**
Excel `§1` **11 grup / 49 kalem** verir (`LTA Spend 7` ≠ BRD `8`, `Promo by Mechanic 9`
≠ BRD `11`). `52` **BRD-42 tabanlıdır**. `A1`'in karşılaştırma tabanı `Z62 §5`'e göre
**Excel `§1`**'dir — **iki taban çelişiyor.** Hangisi kanonik?

**`Q5` — off-invoice mekanik tabanı `LTA_Off`'u düşmeli mi?**
Kod düşüyor (`spend-calculation.service.ts:281`), **Excel de BRD `KPI 19` de düşmüyor**.
Kod **iki kaynaktan da** sapıyor ⇒ off-invoice harcaması **olduğundan küçük**, ROI
**olduğundan iyi**. `T-291`'in **aynı yön**deki kardeşi. Düzeltilecek mi, yoksa
bilinçli bir CTPM sapması mı?

**+ Bilgi (soru değil, kayıt):** `§3.4`'teki **FE/BE `BASE_TO` çelişkisi** ve
**FE `INCR_GP` karışık-semantiği** birer **hata kaydı adayıdır** — `A1`'in değil,
`DALGA-B` sonrası bir düzeltme turunun konusu.

---

## `§6` · BU RAPORUN YAPMADIKLARI

```
A1  52 × 24 tam eşleme            YAPILMADI — evren hükmü (Q4) bekliyor
A3  F12 düzeltmeleri              YAPILMADI — sayı kesin değil
—   hiçbir kolon/enum/kpi_code    DEĞİŞTİRİLMEDİ  (Z64 §3 VERİ-DOKUNMASIZ)
—   migration                      YAZILMADI
—   e2e / npm test                 KOŞULMADI     (paralel ajan ağaçta)
—   src/ altına yazma              YAPILMADI     (yalnız okundu)
```
