# `K1` — SESSİZ SIFIR ÖLÇÜM TABLOSU (`T-337` birinci adım)

> **Tarih:** 2026-08-31 · **Tur cinsi:** ⛔ **ÖLÇÜM — HÜKÜM DEĞİL** (`Z75 §1`)
> **Ajan:** data-analyst (salt-okunur) · **Kod değiştirilmedi.**
> **Ölçüm koşulu:** çalışan ağaç `staging` @ `ff8feac` · DB `collmind_tpm` şema `main`,
> `plans = 0 · plan_fus = 0 · plan_skus = 0` ⇒ **aşağıdaki yolların hiçbiri bugün koşmuyor**
> (`Z68 §3b` / `T-273` körlüğü). Her satırın `W3` sütunu bu yüzden zorunludur.

---

## `§0` · ⛔ BRIEF'İN İKİ ÖNCÜLÜ ÖLÇÜLDÜ — BİRİ YANLIŞ, BİRİ BAYAT

| brief | ölçüm |
|---|---|
| *"`spend-calculation.service.ts:918-921`"* | **BAYAT SATIR** — `918-921` bugün `calculateAllSpendsForFU`'nun JSDoc'u. Kalem **`:1001-1004`**'te. |
| *"`plan.service.ts:2368-2371` `?? 0`"* | **BAYAT SATIR** — `2368-2371` bugün telemetri payload'u. Kalem **`:2532-2535`**'te; KPI enjeksiyonu **`:2603`** (brief `:2445` diyordu). |
| *"ÜRETİM ÇAĞIRANI `approval-workflow.service.ts:1011` ← ONAY/BÜTÇE YOLU"* | ⛔ **YANLIŞ.** `approval-workflow.service.ts` **811 satır** — `1011` yok. Dosya `SpendCalculationService`'i **enjekte bile etmiyor**. |

**`SpendCalculationService`'in tüm `src/` enjeksiyonu — ölçüm:**

```
grep -rn "SpendCalculationService" src/ | grep -v spend-calculation.service.ts | grep -v .spec.
⇒ TEK enjeksiyon:  plan.service.ts:157   (+ import :49)
```

⇒ **`calculateAllSpendsForFU`'nun bugün SIFIR üretim çağıranı var.** Tek çağıranları
`spend-calculation.service.spec.ts` (`:377/:439/:496/:645/:664/:735`) ve `plan.service.spec.ts:183`
(mock). **Pozitif kontrol:** aynı grep `plan.service.ts`'in `calculateAllSpendsForSKU` çağrısını
(`:2554`) **buluyor** ⇒ desen çalışıyor, evren doğru.

⚠️ **Ve kod bunun tersini YAZILI olarak iddia ediyor** (`DISIPLIN`: *"yorum kirliliği iki yönde
birden yanıltır"*):

- `spend-calculation.service.ts:786` — *"`calculateAllSpendsForFU` … used by
  `ApprovalWorkflowService#submitForApproval`"*
- `plan.service.ts:2464-2465` — *"`calculateAllSpendsForFU` (the OTHER canonical spend-derivation
  path, used by `ApprovalWorkflowService#submitForApproval`)"*
- `test/role-journey.e2e-spec.ts:705,857` — aynı iddia

⇒ **`Z75 §4` (`K4`, "bir uç ya TÜKETİCİ KAZANIR ya ÖLÜR") kapsamına giren dokuzuncu bir uç.**
Bu, aşağıdaki `B` sayımının **yarısını** bugün ulaşılamaz kılıyor — ama yorumlar onu **canlı
gösteriyor**, yani `T-084` koruma-etkisi zaten işliyor.

---

## `§1` · ÇAĞRI YERİ TABLOSU

**Sınıflar:** `A` = ÇÖZÜLMÜŞ DEĞER (`0` doğru) · `B` = SESSİZ VARSAYILAN (`0` yanlış, `§2.5`) ·
`?` = **ÖLÇEMEDİM** (bkz. `§5`) · `—` = para yolu değil, evren dışı.

### `1a` · `collmind.backend/src/modules/shared/spend-calculation/spend-calculation.service.ts`

| satır | ifade / alan | sınıf | DAYANAK (şema · transformer · yol · invaryant) | `W3`'ün ilk gerçek satırında ne olur |
|---|---|---|---|---|
| `:197` | mekanik bulunamadı → `return 0` (+`warn`) | `A`\* | Üretim yolunda **ulaşılamaz**: `calculateAllSpendsForSKU` `precomputed.mechanic`'i **daima** verir (`:592/:604/:674`); bilinmeyen kod `buildMechanicValues`/`describeUnresolvedMechanicCode` ile **`400`** atar | Hiçbir şey — dal koşmaz. **Yeni bir doğrudan çağıran gelirse `B`'ye döner** |
| `:202` | `if (!enteredValue) return 0` | `A` | **ADR 0008** (ölçülmüş, 15 çağrı yeri): girilen değerde `null` ≡ `0`. `rawOf` sözleşmesi (`common/numeric/mechanic-input.ts:97`) | Mekanik girilmemişse harcama **gerçekten** `0` |
| `:223` | `ltaContext?.finalOnInvoicePct \|\| 0` | `A` | **Emsal doğrulandı**: `ltaContext` ya `null` (LTA yok ⇒ harcama gerçekten `0`) ya **tam dolu**; `lta_rates.on_invoice_percentage` / `off_invoice_percentage` **`NOT NULL`** (ölçüldü, `§3`); `finalOnInvoicePct = override ?? rate.pct` (`lta-agreement.service.ts:508`) | LTA'sız plan ⇒ `0` doğru |
| `:267` | `LUMPSUM_SPEND` → `return 0` | `A`\* | Yorumda **yazılı ve ölçülebilir**: FU-farkında yol (`:646-656`) bu dala **hiç girmez** | Ulaşılmaz |
| `:271` | bilinmeyen kategori → `return 0` (+`warn`) | `?` | `mechanic.category` bir enum; DB'de enum dışı değer olup olmayamayacağı **ölçülmedi** | bkz. `§5-Ö4` |
| `:392` | `Number(ps.baseVolume) \|\| 0` (lumpsum paydası) | `A` | **ADR 0006 Karar 2**: *"null base'e pay yok"* ⇒ `null`→`0` **kuralın kendisi**. Toplam `<= 0` ise **`400` atılıyor** (`:396-407`) — sessiz sıfır **yok** | Base'siz SKU pay almaz; hiçbir SKU'da base yoksa **`400`** |
| `:411` | `Number(ps.baseVolume) \|\| 0` (pay) | `A` | aynı — **ama karşı-kaynak var**, bkz. `§5-Ö1` (`T-202`, BRD `§5.2` `planned volume` diyor) | `0` pay |
| `:537` | `ltaContext?.finalOnInvoicePct \|\| 0` | `A` | `:223` ile aynı dayanak | `0` doğru |
| `:538` | `ltaContext?.finalOffInvoicePct \|\| 0` | `A` | aynı | `0` doğru |
| `:550` | `plannedPromoNiv(baseGsv, baseLtaOnInv, **0**)` | `A` | Bir varsayılan **değil**, `SEVİYE 4`'te yazılı olgunun karşılığı: `baseTotalOnInv = baseLtaOnInv` ⇒ **taban promo cebirsel olarak `0`**. Bağı `:546-549` + `:708-728`'de yazılı | `0` doğru — taban promo doğduğu gün **iki yer birlikte** değişir |
| `:653` | `lumpsumSharesBySku?.[sku]?.[code] ?? 0` | `A` | `computeLumpsumDistribution` girilen değeri olan **her** lumpsum mekaniği için **tüm** SKU'ları doldurur (`:437-442`); anahtar yoksa değer **girilmemiştir** | `0` doğru |
| `:1001` | `baseVolume: Number(planSku.baseVolume) \|\| 0` | **`B`** | `plan_skus.base_volume` **`NULLABLE`**, `DecimalTransformer` `null`'ı **korur** ⇒ `Number(null)=0`, `Number(undefined)=NaN→0`. `null` ile girilen `0` **ayırt edilemez** | ⛔ **bugün ulaşılamaz** (`§0`); uç diriltilirse `BASE_TOTAL_SPEND` **eksik**, `INCR_SPEND` **şişkin** |
| `:1002` | `plannedVolume: … \|\| 0` | **`B`** | `plan_skus.planned_volume` **`NULLABLE`** | aynı — `plannedGsv=0` ⇒ **tüm %-mekanik harcaması `0`** |
| `:1003` | `listPrice: Number(planSku.sku?.unitPrice) \|\| 0` | **`B`** | `skus.unit_price` **`NULLABLE`**; ayrıca `planSku.sku` ilişkisi yüklenmemişse `?.` ⇒ `undefined` ⇒ `NaN` ⇒ `0` — **iki farklı olgu tek değere** | aynı |
| `:1004` | `cogsPerUnit: Number(planSku.sku?.cogs) \|\| 0` | **`B`** | `skus.cogs` **`NULLABLE`** ve **166/170 satır bugün `NULL`** (`§3`) — `T-027`'nin tam popülasyonu, **hâlâ orada** | aynı; ⚠️ `cogsPerUnit` yalnız `calculateCompleteSKUFinancialMetrics`'te okunuyor (`:1224-1225`) — **o da üretimsiz** |
| `:1081`, `:1089` | `(agg[code] \|\| 0) + value` | `A` | **akümülatör ilklendirmesi** — sözlükte anahtar yoksa toplama `0`'dan başlar; bilgi kaybı yok | doğru |

\* = *sınıfı **ulaşılamazlıktan** geliyor, semantikten değil.*

### `1b` · `collmind.backend/src/modules/modes/planning-first/plan/plan.service.ts`

| satır | ifade / alan | sınıf | DAYANAK | `W3`'ün ilk gerçek satırında ne olur |
|---|---|---|---|---|
| `:2285` | `fu.planSkus?.length ?? 0` | `—` | **sayaç**, para değil | — |
| **`:2532`** | `baseVol = baseVolOrNull ?? 0` | **`B`** | `plan_skus.base_volume` **`NULLABLE`**. `toNullableNumber` (`:142`) `null`'ı **doğru** üretiyor, sonra **aynı satırda çöktürülüyor**. `skuCtx.baseVolume` (`:2541`) → `baseGsv` (`spend-calc:517`) → `BASE_TOTAL_SPEND` **ve** `INCR_SPEND` | KPI tarafı **güvenli** (`BASE_VOL` motora `null` gider ⇒ `BASE_GSV`→`BASE_TO`→`BASE_GP` `null`), **ama** `INCR_SPEND` motora **şişkin bir SAYI** olarak gider (`:2605`) — `null` değil |
| **`:2533`** | `planVol = planVolOrNull ?? 0` | **`B`** ⛔ | `plan_skus.planned_volume` **`NULLABLE`**. `plannedGsv = planVol × unitPrice` ⇒ `0` ⇒ `plannedLtaOn = 0`, **her %-mekanik `0`**, `PER_UNIT_SUPPORT` `0` (`spend-calc:252`) ⇒ `planned.totalSpend ≈ 0` | ⛔ **CANLI-YANLIŞ ADAYI**: `TOTAL_PLANNED_SPEND` (`:2603`) ve `plan.totalSpend`/`on_invoice_spend`/`off_invoice_spend` **düşük** ⇒ **bütçe rezervasyonu düşük** ⇒ eşik **geç ateşler**. *(KPI tarafı yine güvenli: `PLAN_VOL` `null` ⇒ `PLANNED_GSV` `null`.)* |
| **`:2534`** | `unitPrice = unitPriceOrNull ?? 0` | **`B`** ⛔ | `skus.unit_price` **`NULLABLE`** (bugün `0` `NULL` satır — **veri, şema değil**) | `:2533` ile **aynı şekil**, aynı bütçe sonucu |
| `:2535` | `cogs = cogsOrNull ?? 0` | **`A` (ETKİSİZ)** | ⚠️ **Ölçüldü:** `SKUContext.cogsPerUnit` canlı yolda **hiç okunmuyor** — tek okuyucu `spend-calculation.service.ts:1224-1225` (`calculateCompleteSKUFinancialMetrics`, **üretim çağıranı yok**, `:1211-1215`'te yazılı). COGS motora `cogsOrNull` gidiyor (`:2597`) | **Hiçbir şey** — ölü alan. `Z75 §4` ölü-uç ailesine aday |
| `:2648` | `fuTotalGp += plannedGp ?? 0` | **`B`** | `plannedGp` **kasten `null` olabilir** (`:2637`, `T-027`'nin ta kendisi). `fuTotalGp` → `plan_fus.total_gp` (**`NOT NULL DEFAULT 0`**) → `plan.totalGp` → `getAnalysis`'te `incrementalGp` fallback'i (`:3040`) | ⛔ **166 COGS'suz SKU'nun tam vakası**: SKU `PLANNED_GP` `null` ⇒ **`0` sayılıp toplanıyor** ⇒ FU/plan GP **eksik ama DOLU görünüyor**. Renk `null` (güvenli), **sayı yanlış** |
| `:3016` | `baseVolume += Number(planSku.baseVolume) \|\| 0` | `?` | `getAnalysis` `volumeAnalysis.baseVolume` — hacim toplamı; `null` base'i `0` sayıyor. Ekran toplamı mı, karar girdisi mi ⇒ ürün hükmü | Base'siz SKU'lar toplamı **sessizce küçültür**; `upliftPercentage` **şişer** |
| `:3032`, `:3040` | `(storedIncrGp ?? 0) + …` / `storedIncrGpFound ? (storedIncrGp ?? 0) : …` | `A` | `storedIncrGpFound` bayrağı **varlık/yokluk ayrımını taşıyor** (`:3033`); `?? 0` yalnız **akümülatör ilklendirmesi** | doğru |
| `:3145` | `onInvoiceSpend += Number(planFu.totalSpend) \|\| 0` | `A` | `plan_fus.total_spend` **`NOT NULL DEFAULT 0`** (ölçüldü) ⇒ `null` **gelemez**; `\|\| 0` yalnız `NaN` kalkanı. ⚠️ Ama dalın **kendisi** bir fallback (*"stored KPIs not yet populated → hepsini on-invoice say"*) — bkz. `§5-Ö2` | `0` doğru |
| `:3159`, `:3162` | `existing.spend += Number(value) \|\| 0` | `?` | `plan_fus.tactics` **JSONB** — değer tipi **şemayla garanti değil**. Sayısal olmayan bir giriş **sessizce `0` harcama** olur | bkz. `§5-Ö3` |
| `:3198`, `:3199` | `fuBaseVolume/fuPlannedVolume += … \|\| 0` | `?` | `:3016` ile aynı sınıf; ek olarak `uplift` paydası (`:3207`) | Base'siz SKU `uplift`'i **şişirir** |
| `:1433/:1434` | `onSpend/offSpend = Number(plan.*Spend) \|\| 0` | `A` | `plans.on_invoice_spend` / `off_invoice_spend` **`NOT NULL DEFAULT 0`** ⇒ `null` gelemez | ⚠️ `A` **bu satırda**; hata **yukarıda** (`:2533`) — sayı temiz gelir, **içeriği yanlıştır** |
| `:1651/:1652` | aynı — zarf **auto-create boyutlandırması** | `A` | aynı şema dayanağı | aynı uyarı: `max(onSpend*2, 100000)` **düşük spend'den** boyutlanır |
| `:1763/:1764` | aynı — `commitAllReservedForPlan` on/off kırılımı | `A` | aynı şema dayanağı | aynı |

### `1c` · EK — zincirin tüketici ucu (evren dışı ama `§7.1` gereği sayıldı)

`approval-workflow.service.ts:267` `Number(plan.onInvoiceSpend) + Number(plan.offInvoiceSpend)`
· `:278/:279` · `:652-654` — **hepsi `A`** (`NOT NULL` kolonlar), **hepsi `:2533/:2534`'ün
ürettiği sayıyı bütçeye yazıyor.

> ### ⛔ TABLONUN TEK CÜMLESİ
> **Dört alanın dördü de KPI motoruna `null` gidiyor ve orada DOĞRU davranıyor.
> Aynı dört alan, SPEND motoruna `0` gidiyor ve oradan BÜTÇEYE bir SAYI olarak çıkıyor.
> `T-027` birinci yolu kapattı; ikinci yol o gün BÜTÇEYE BAĞLI DEĞİLDİ.**

---

## `§2` · `T-027`'NİN ORİJİNAL GEREKÇESİ — VE HANGİ KISMI MEKANİZMASINI KAYBETTİ

### `2a` · Yazıldığı hâliyle gerekçe

`.claude/backlog/tasks/T-027.md` (`created 2026-06-24 · updated 2026-07-27`), **Sonuç** bölümü:

```
"toNullableNumber() helper: COGS/BPTT/BASE_VOL/PLAN_VOL eksikse context'e null
 (0 değil) → engine null-propagation → ROI/GP/RAG null (sahte %100/GREEN bitti).
 Meşru 0'lar korundu; aggregation || 0'ları (EKRAN TOPLAMI) BİLİNÇLİ bırakıldı."
```

Ve kodun kendi gerekçesi (`plan.service.ts:2520-2527`, bugün hâlâ orada):

```
"SpendCalc's SKUContext has no null-safety (raw arithmetic), so it keeps the
 0-fallback numeric values below — a missing input there DEGRADES TO 0 SPEND
 RATHER THAN CRASHING ON NaN."
```

**Kararın dayandığı üç önerme:**

| # | önerme | statü |
|---|---|---|
| `P1` | Riskli çıktı **`ROI`/`GP`/`RAG`**'dir; onlar `*OrNull` ile korunuyor | **HÂLÂ DOĞRU** — `§1b` ölçtü |
| `P2` | `SKUContext`'ten çıkan sayılar **"ekran toplamı"**dır | ⛔ **MEKANİZMASINI KAYBETTİ** |
| `P3` | Alternatifler **`{0, NaN}`** — üçüncü seçenek yok | ⛔ **MEKANİZMASINI KAYBETTİ** |

### `2b` · `P2` — *"ekran toplamı"* artık bir **BÜTÇE SAYISIDIR**

`T-027` kapandığında (`2026-07-27`) `plan.totalSpend` gerçekten bir ekran toplamıydı.
Sonra, **hepsi `T-027`'den SONRA**:

```
T-056  (0009 §4.2)   plans.on_invoice_spend / off_invoice_spend  recalc'ta KALICILAŞTI
T-057  (§5.6/F4)     bütçe yeterliliği TİP BAZLI oldu — o iki kolonu OKUYARAK
                     (plan.service:1433-1434 · 1651-1652 · 1763-1764)
T-048/T-344          reserve/commit tek motora indi; commitAllReservedForPlan
                     on/off kırılımını AYNI kolonlardan alıyor
```

⇒ Bugün `:2533`/`:2534`'ün ürettiği sayı şu zinciri kat ediyor:

```
planVol ?? 0 / unitPrice ?? 0
   → plannedGsv = 0
   → plannedLtaOn = 0 · her %-mekanik = 0 · PER_UNIT_SUPPORT = 0
   → spendBreakdown.planned.totalSpend ≈ 0
   → plan.total_spend / on_invoice_spend / off_invoice_spend   [NOT NULL kolonlar]
   → checkPlanBudgetAvailability · reserveTypedForPlan · commitAllReservedForPlan
   → budget_envelopes.consumed_amount
   → budget-threshold.service.ts:228-230   percent >= critical → RED
```

> **Bir eşik, kendisine ulaşması gereken sayı `0`'a çöktüğü için ATEŞLEMEZ —
> ve hiçbir yerde bir hata görünmez.** `Z76 §4` eşik semantiğini (`>=`) ölçümle
> kapattı; bu satır **eşiğin GİRDİSİNİ** aynı derecede kapatmamış olduğumuzu gösteriyor.

### `2c` · `P3` — üçüncü seçenek **`T-027`'den sonra doğdu**

`T-027` ikili bir dünyada karar verdi: *"`0` mı, `NaN` çökmesi mi?"*. **Üçüncüsü artık var:**

```
Z68 §2 / T-323 / T-342   TANIMLI-YOKLUK
                         ragExclusionReason (plan.service:2663 · :2745)
                         "değerlendirme dışı" ≠ "değerlendirilemedi" ≠ "kötü değil"
```

⇒ `NOT_EVALUABLE` bugün **kalıcılaşabilen ve üç yüzeyde gösterilmesi kararlaştırılmış**
bir kavram. `P3` yalnız *"eskidi"* değil — **karşılığı üretildi**.

### `2d` · `T-293`/`T-334`'ün payı

- **`migration 1817`** LTA anlaşmalarını bağladı ⇒ `ltaContext` artık **gerçekten dolabiliyor**;
  `T-027` döneminde `finalOn/OffInvoicePct` yollarının **çoğu ölüydü**.
- **`migration 1818` / `Z65`** `plannedLtaOff`'un tabanını `PlannedPromoNIV`'e taşıdı
  (`spend-calc:625-631`) ⇒ `plannedGsv`'in `0` olması artık **iki kat daha fazla** kalemi
  siliyor (`plannedNiv` → `plannedLtaOff` da `0`).
- **`ADR 0011` / `Q6`** ROI paydasını `INCR_PROMO_SPEND`'e ayırdı ⇒ **`TOTAL_PLANNED_SPEND`'in
  kalan tüketicileri `PLANNED_TO` (null-korumalı) ve BÜTÇE (korumasız)**.

> ### ⇒ `Z69 §4c`: hüküm ("`0` bırak") **aynı kalabilir**, ama gerekçesi (*"ekran toplamı"* ·
> ### *"alternatif NaN"*) **artık ölçülemiyor**. Yeniden kurulmalı — iptal edilmemeli.

---

## `§3` · ŞEMA ÖLÇÜMÜ (nullable haritası)

`information_schema.columns`, `table_schema='main'`, `2026-08-31`:

| tablo.kolon | nullable | default | anlam |
|---|---|---|---|
| `plan_skus.base_volume` | **YES** | — | `null` **gelebilir** ⇒ `:1001`/`:2532` ayrım kaybı **gerçek** |
| `plan_skus.planned_volume` | **YES** | — | `null` **gelebilir** ⇒ `:1002`/`:2533` ⛔ |
| `skus.unit_price` | **YES** | — | `null` **gelebilir** ⇒ `:1003`/`:2534` ⛔ |
| `skus.cogs` | **YES** | — | `null` **gelebilir** ⇒ `:1004`/`:2535` |
| `plan_skus.planned_gp` | YES | `0` | `T-027` migration `1788` — `null` **kasten** yazılıyor |
| `plan_skus.planned_turnover` | YES | `0` | aynı |
| `plan_skus.incremental_volume` | **NO** | `0` | — |
| `plan_fus.total_spend` / `total_gp` / `total_planned_volume` | **NO** | `0` | ⇒ `:3145`'in `\|\| 0`'ı `A` |
| `plans.total_spend` / `on_invoice_spend` / `off_invoice_spend` | **NO** | `0` | ⇒ `§1c`'nin hepsi `A` — **ama içerik yukarıdan geliyor** |
| `lta_rates.on_invoice_percentage` / `off_invoice_percentage` | **NO** | — | ⇒ `finalOn/OffInvoicePct \|\| 0` **emsali DOĞRULANDI** (`A`) |

**Transformer katmanı** (`src/database/transformers/decimal.transformer.ts`):
`DecimalTransformer` / `UnitPriceTransformer` `from` = `parseFiniteOnRead` ⇒
**`null`/`undefined` KORUNUR**, finite olmayan **`throw`**. Yani `null` entity sınırına
**sağlam** ulaşıyor; kayıp **tam olarak `?? 0` / `|| 0` satırında** oluyor.

**Veri profili (canlı):**

```
plans = 0 · plan_fus = 0 · plan_skus = 0        ⇒ hiçbir yol bugün koşmuyor
skus  = 170
  cogs IS NULL        = 166      ⛔ T-027'nin popülasyonu, HÂLÂ ORADA
  unit_price IS NULL  = 0
  cogs = 0            = 0        ⇒ "meşru 0" bugün SIFIR satır
  unit_price = 0      = 0
```

> 📌 **`cogs = 0` olan satır sayısı SIFIR.** Yani `166 NULL` ile `0` arasındaki ayrım bugün
> **tamamen** `null` tarafında — `?? 0` **hiçbir meşru `0`'ı korumuyor**, yalnız **166 eksik
> veriyi maskeliyor**.

---

## `§4` · TEK-RESOLVER ÖNERİSİ (`Z75 §1` ikinci yarı · emsal `B1`'in `toFiniteNumber` deseni)

### `4a` · Ayrımı **NE** belirler

⛔ **Parametre değil, bağlam değil — ALANIN KENDİSİ.** Ölçüm bunu gösteriyor:

| alan | eksikse doğru davranış | çünkü |
|---|---|---|
| girilen **mekanik değeri** | **`0`** | ADR 0008 — `null` ≡ `0`, ölçülmüş |
| `ltaContext` yokluğu | **`0`** | LTA yok ⇒ harcama gerçekten `0`; `lta_rates` `NOT NULL` |
| `PLAN_VOL` · `BPTT` | **`NOT_EVALUABLE`** | `plannedGsv` tanımsız ⇒ **planlanan harcamanın tamamı** tanımsız |
| `BASE_VOL` | **`NOT_EVALUABLE` (yalnız taban/incremental)** | `baseGsv` tanımsız ⇒ `BASE_TOTAL_SPEND` · `INCR_SPEND` tanımsız; **planlanan harcama etkilenmez** |
| `COGS` | spend için **ilgisiz** | canlı yolda okunmuyor (`§1b:2535`) |

⇒ Resolver **tek**, ve içinde **alan-başına sabit bir kural** taşır. `A/B` bir çağıran
tercihi **değildir** — bu, `F8` ailesinin (*"aynı sayı dört yerde dört farklı"*) tam
panzehiridir.

### `4b` · Önerilen imza

```ts
// src/modules/shared/spend-calculation/sku-spend-inputs.ts   (YENİ, tek nokta)

export type SpendInputResolution =
  | { kind: 'EVALUABLE'; ctx: SKUContext }
  | { kind: 'NOT_EVALUABLE'; missing: ReadonlyArray<'PLAN_VOL' | 'BPTT'>;
      /** taban ayrı düşebilir: planlanan hesaplanabilirken taban olmayabilir */
      baseEvaluable: boolean };

export function resolveSkuSpendInputs(raw: {
  skuId: string;
  baseVolume: unknown; plannedVolume: unknown;
  unitPrice: unknown;  cogsPerUnit: unknown;
  channelCode?: string; categoryCode?: string; cplId?: string;
}): SpendInputResolution;
```

ve `SpendBreakdown`'da **iki alanın tipi genişler** (`ADR 0011` `INCR_PROMO_SPEND` bölünmesiyle
aynı şekil):

```ts
base:        { …; totalSpend: number | null }     // BASE_VOL yoksa null
incremental: { …; total:      number | null }     // BASE_VOL yoksa null
planned:     { …; totalSpend: number }            // NOT_EVALUABLE ise buraya HİÇ gelinmez
```

**Neden `throw` değil:** `§2.5` *"açık hata fırlat"* der, ama `Z68 §2`'nin **tanımlı-yokluğu**
bu projede zaten kurulu ve **üç yüzeye** taşınması kararlaştırılmış. `NOT_EVALUABLE` + zorunlu
`missing` listesi, `throw`'un bilgi içeriğini **kaybetmeden** taşır. ⛔ Ama **sessiz olamaz:**
`plans.total_spend` `NOT NULL` olduğu için bir `NOT_EVALUABLE` plan **bütçeye `0` yazmamalı** —
`§6-S3`'ün ürün hükmü tam burada gerekiyor.

### `4c` · Kaç çağıranı değiştirir

```
2  SKUContext İNŞA yeri (evrenin tamamı — ölçüldü, grep "SKUContext = {" + ": SKUContext")
   plan.service.ts:2539-2548            ← CANLI
   spend-calculation.service.ts:999-1008 ← bugün üretimsiz (§0)
1  SKUContext tipi        dto/calculation-context.dto.ts
3  breakdown TÜKETİCİSİ   plan.service.ts:2568-2577 · :2599-2612 · :2635-2648
1  ölü tüketici           spend-calculation.service.ts:1186-1231 (calculateCompleteSKUFinancialMetrics)
```

### `4d` · ⛔ BİR ÇAĞIRAN UNUTULURSA (`F8` ailesi)

```
plan.service DÖNÜŞTÜ · calculateAllSpendsForFU DÖNÜŞMEDİ
⇒ AYNI PLAN, İKİ FARKLI TOPLAM   (T-049 postmortem'inin birebir tekrarı:
                                   "aynı olgunun iki türetimi ayrışır")
⇒ ve bu kez ayrışan şey EKRAN DEĞİL, BÜTÇE REZERVASYONU
```

**Kapı önerisi (`DISIPLIN` — *"kuralı hatırlamak yerine ARACI çağır"*):**
`SKUContext`'i **yalnız** resolver üretebilsin — nesne literali ile inşa **derlenmesin**
(branded/opaque tip ya da `readonly` marker alanı). O zaman *"bir çağıran unutulursa"*
sorusunun cevabı **derleme hatası** olur, sessiz sapma değil. Alternatif ucuz kapı:
`grep`-tabanlı bir guard (`": SKUContext = {"` deseni → `exit 1`) — ama `T-100` dersi:
kapsamı dinamik bir kapı **sessizce boşalır**; tip kapısı tercih edilir.

---

## `§5` · `ÖLÇEMEDİM` — ayıramadıklarım, adıyla

| # | kalem | neyi ayıramadım | ayırmak için ne gerek |
|---|---|---|---|
| **`Ö1`** | `spend-calculation.service.ts:392` · `:411` — lumpsum `baseVolume \|\| 0` | `A` **kabul ettim** çünkü ADR 0006 Karar 2 *"null base'e pay yok"* diyor. ⛔ **Ama o kararın kendisi çekişmeli:** aynı ADR'nin `§`'i BRD `§5.2`'nin `planned volume` dediğini ve *"null base'e pay yok"* gerekçesinin o tabanda **geçersiz** olduğunu kaydediyor (`T-202` açık). Taban değişirse bu iki satırın sınıfı **`B`'ye döner** | `T-202`'nin ürün hükmü |
| **`Ö2`** | `plan.service.ts:3141-3146` — *"stored KPIs not yet populated → `planFu.totalSpend`'in TAMAMI on-invoice"* | Bu bir `?? 0` değil ama **aynı ailenin fallback'i**: off-invoice harcaması olan bir FU, recalc'tan önce **`%100 on-invoice`** raporlanıyor. `DISIPLIN` *"sessiz VARSAYILAN ≠ sessiz FALLBACK"* ayrımında **hangi tarafta** olduğuna karar veremedim — başka bir **kaynağa** düşüyor (fallback) ama o kaynak **ayrımı taşımıyor** (varsayılan) | `getAnalysis`'in tüketicisi bu ayrımı gösteriyor mu — FE ölçümü |
| **`Ö3`** | `plan.service.ts:3159` · `:3162` — `Number(value) \|\| 0` (`plan_fus.tactics` JSONB) | JSONB'de **tip garantisi yok**. Sayısal olmayan/eksik bir taktik değeri `0` harcama olarak **görünür bir kırılıma** giriyor. `tactics` yazma yolunun (`updateFuTactic`) sayısal doğrulama yapıp yapmadığını **ölçmedim** (kapsam dışıydı) | `updateFuTactic` + DTO doğrulama okuması |
| **`Ö4`** | `spend-calculation.service.ts:271` — bilinmeyen `mechanic.category` → `warn` + `0` | Enum dışı bir değerin DB'de **mümkün olup olmadığını** ölçmedim (`mechanics.category` CHECK/enum tipi sorgulanmadı) | `information_schema` + `pg_constraint` (şema-nitelendirilmiş) |
| **`Ö5`** | `plan.service.ts:3016` · `:3198` · `:3199` — `getAnalysis` hacim toplamları | `T-027` bunları *"ekran toplamı, bilinçli"* saydı. **Ama `§2b` tam olarak bu gerekçenin çürüdüğünü gösterdi** — `getAnalysis` bugün bir **karar destek** ekranı (`NOT_COMPUTABLE` statüsünü ayrı tutacak kadar özenli, `:2967`). Aynı yanıtta `uplift` **`0` sanılan base'lerden** hesaplanıyor. `A` mı `B` mi — **ürün hükmü** | `§6-S4` |
| **`Ö6`** | `:2532`'nin `INCR_SPEND` yolu | `INCR_SPEND`'in bugün **hangi KPI/ekran tarafından** okunduğunu tam ölçmedim: DB'de `INCR_SPEND` **passthrough** bir KPI (`formula_text = 'INCR_SPEND'`), yani **kalıcılaşıyor ve gösterilebiliyor**, ama tüketici yüzeyini taramadım | `rg "INCR_SPEND"` FE evreni |

---

## `§6` · ÜRÜN SAHİBİNE AÇIK SORULAR (hüküm gerektiren `B` adayları)

> ⛔ **`CLAUDE.md §2.4` — DUR.** Aşağıdakiler ölçülmüş `B` adaylarıdır; **hiçbirinde varsayım
> yapılmadı ve kod değiştirilmedi.**

**`S1` (⛔ birincil) — `PLAN_VOL` veya `BPTT` eksik bir SKU'nun harcaması nedir?**
Bugün: `0`, ve o `0` **bütçeye rezerve ediliyor**.
Seçenekler: **(a)** `NOT_EVALUABLE` ⇒ submit **`400`** (planner eksik veriyi doldurur) ·
**(b)** `NOT_EVALUABLE` ⇒ submit geçer, **rezervasyon reddedilir** ve plan
`ragExclusionReason` taşır · **(c)** bugünkü davranış **KORUNUR**, ama gerekçesi
*"ekran toplamı"* yerine **yeniden yazılır**.
Sonuç farkı: **(a)** akışı durdurur · **(b)** iki yüzey daha ister · **(c)** eşiğin geç
ateşlemesini **kabul edilmiş risk** yapar.

**`S2` — `BASE_VOL` eksikse `BASE_TOTAL_SPEND` / `INCR_SPEND` `null` mı, `0` mı?**
`Ö1` ile bağlı: ADR 0006'nın *"null base'e pay yok"* okuması bunu **çözülmüş `0`** sayar;
`T-202` o okumanın kaynağını **çekişmeli** kılıyor. **Aynı hüküm iki kalemi birden bağlar.**

**`S3` — `NOT_EVALUABLE` bir plan bütçe tarafında ne yazar?**
`plans.total_spend` **`NOT NULL`**. Kolon `NULLABLE` mi olacak (migration ⇒ data-engineer),
yoksa plan **submit edilemez** mi (`S1a`)? ⛔ Bugün `0` yazmak **sessiz sıfırın kalıcılaşmış
hâlidir** — kolon `NOT NULL` olduğu için `null` yazma seçeneği **bugün yok**.

**`S4` — `plan.service:2648` `fuTotalGp += plannedGp ?? 0`.**
`166` COGS'suz SKU'nun `PLANNED_GP`'si `null`; FU/plan `total_gp`'sine **`0`** olarak giriyor.
`plan_fus.total_gp` **`NOT NULL DEFAULT 0`** ⇒ `null` yazılamıyor. Bu **`T-027`'nin kendi
kararının bıraktığı delik**: KPI `null`, **agregat `0`**. Hüküm: kısmi toplam **gösterilir mi**
(bugün) yoksa **`coverageRatio`/`ragExclusionReason` ile nitelenir mi** (`Z70 §3`'ün istediği
şekil)?

**`S5` — `Z75 §4` (`K4`) kapsamı iki yeni üye kazanıyor mu?**
`calculateAllSpendsForFU` (üretim çağıranı **sıfır**, `§0`) ve
`calculateCompleteSKUFinancialMetrics` (aynı, `:1211-1215`'te **yazılı**). *"Bir uç ya tüketici
kazanır ya ölür."* ⛔ Ve **ölmeden önce** `plan.service.ts:2464-2465` ile
`spend-calculation.service.ts:786`'daki **yanlış canlılık iddiaları** düzeltilmeli
(`T-084`: yanlış yorum **koruma üretir**) — bu, kod değişikliği gerektirir, **bu turun işi değil**.

**`S6` — `plan.service:2535` `cogs ?? 0` ölü alan.**
`SKUContext.cogsPerUnit` canlı yolda okunmuyor. Silinsin mi, yoksa
`calculateCompleteSKUFinancialMetrics` diriltilecek mi (`S5` ile aynı karar)?

---

## `§7` · SAYIM

```
A            17     (2 tanesi "ulaşılamazlıktan": spend-calc :197 · :267
                     1 tanesi "etkisiz/ölü alan":  plan.service :2535)
B             9     :1001 :1002 :1003 :1004  (bugün ULAŞILAMAZ — uç üretimsiz)
                    :2532 :2533 :2534        (⛔ CANLI, bütçeye çıkıyor)
                    :2648                    (⛔ CANLI, agregat GP)
                    + :1004'ün ikizi olarak sayılmayan hiçbir kalem yok
ÖLÇEMEDİM     6     Ö1 (2 satır) · Ö2 · Ö3 (2 satır) · Ö4 · Ö5 (3 satır) · Ö6
EVREN DIŞI    2     :2285 (sayaç) · §1c (NOT NULL tüketici ucu, A)
```

**Tek-resolver, tek cümlede:**
> `SKUContext` bir nesne literaliyle **hiçbir yerde** inşa edilemesin; tek üreteci
> `resolveSkuSpendInputs` olsun ve `A/B` ayrımını **alan-başına sabit** olarak taşısın
> (girilen mekanik değeri ve `ltaContext` yokluğu ⇒ `0`; `PLAN_VOL`/`BPTT` yokluğu ⇒
> `NOT_EVALUABLE`; `BASE_VOL` yokluğu ⇒ yalnız taban/incremental `null`), böylece
> *"bir çağıran unutuldu"* bir **derleme hatası** olur, bir **bütçe sapması** değil.
