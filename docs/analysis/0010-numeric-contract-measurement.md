# 0010 — Sayısal kontrat ölçümü (D-05 / ADR 0007)

**Tarih:** 2026-08-03 · **Backend SHA:** `e87d1ec` · **Meta SHA:** `1535902`
**T-057 deltası çalışma ağacında:** **EVET** — 8 değiştirilmiş + 3 yeni dosya, commit'lenmemiş.
Bu ölçüm o deltayı **okudu ama değiştirmedi**; etkilenen dosyalar §S2.3'te işaretli.
**Mod:** salt-okunur. Hiçbir kaynak dosya değiştirilmedi.

---

## ⚠️ Öncül düzeltmesi — ölçülecek ADR yok

Görev `docs/decisions/0007-sayisal-kontrat-TASLAK.md`'yi "onay bekliyor" diye referans veriyor.
**Bu dosya yok ve git geçmişinde hiç var olmamış.** `docs/decisions/` bugün 0001–0006 arasını
tutuyor; `docs/analysis/0007` başka bir iştir (recalc telemetrisi). D-05'in tek kaydı
`SYSTEM_INVARIANTS.md:449`'daki tek satırlık karar tablosu girdisidir:

> **D-05** | Numeric contract | INV-N-002, INV-R-008 | Integer minor units · decimal library · SQL-side arithmetic. Plus rounding mode

Dolayısıyla bu rapor **var olan bir ADR'yi doğrulamıyor**; görev metnindeki Alan A / Alan B
tanımını ve A1–A4 alt-sorularını spesifikasyon kabul edip ölçüyor. Ölçüm, ADR'yi yazmak için
gereken girdidir — ADR yazıldıktan sonra bu rapora karşı doğrulanmalıdır.

---

## Verdict

**Alan A / Alan B sınırı uygulanabilir — ama taslakta çizildiği yerde değil.** Ölçüm, sınırın
`spend-calculation`'ın **iki tarafında birden** olduğu varsayımını çürütüyor: `spend-calculation`
tümüyle **Alan A**'dır, çünkü ürettiği her değer `plans.total_spend`/`on_invoice_spend`/
`off_invoice_spend` kolonlarına yazılıp bütçe rezervasyonuna girer (§S1.4-A). Gerçek Alan B —
`kpi-engine` ve RAG — **temiz ayrılabilir**: KPI çıktısı yalnız analitik kolonlara (`gp_roi`,
`overall_roi`, `numeric(18,4)`) yazılıyor ve **hiçbir sert kapıyı beslemiyor** (RAG yalnızca
`warnings.push`, `approval-workflow.service.ts:148`). `finance-reporting` de salt-okur.

Yani sınır vardır ve tektir: **para üreten her şey Alan A, KPI/RAG/raporlama Alan B.**
Alan A 54 dosya (STOP eşiği 60 — altında). Performans engel değil: sıcak yol I/O-bound,
tam aritmetiğin maliyeti gerçekçi senaryoda **+%1–3**, kötümser senaryoda **+%8** (STOP eşiği %20).

**Ancak iki bulgu taslağın işini büyütüyor:**
1. `DecimalTransformer` **tam aritmetiği korumuyor** — `Number(value)` yapıyor. Onu her entity'ye
   uygulamak INV-N-002'yi çözmez, yalnız kaybı merkezileştirir (§S1.1).
2. Kod tabanında **altı ayrı epsilon toleransı** var (`0.01`). Bunlar float hatasının yazılı
   itirafıdır ve tam aritmetiğe geçilirse **hepsi yeniden değerlendirilmelidir** — bazıları
   gerçek yuvarlama artığını, bazıları yalnız float gürültüsünü karşılıyor (§S1.4-D).

---

## S1 — Alan haritası

### S1.1 — Para taşıyan alanların envanteri

Kaynak: `information_schema.columns`, `main` şeması (ad tahmini değil, DB tipi). **92 numeric alan**,
ölçeğe göre üç net grup:

| Ölçek | Adet | Anlam | Örnek |
|---|---|---|---|
| `numeric(18,2)` / `(15,2)` | 58 | **para** | `ledger_entries.amount`, `budget_envelopes.allocated_amount`, `plans.total_spend` |
| `numeric(5,2)` | 6 | **yüzde** (0–100) | `lta_rates.on_invoice_percentage`, `budget_alert_configurations.threshold_percent` |
| `numeric(18,3)` | 8 | **hacim** | `plan_skus.base_volume`, `on_invoice_entries.quantity` |
| `numeric(18,4)` | 16 | **birim fiyat / analitik** | `skus.unit_price`, `plans.overall_roi`, `kpis.rag_*_threshold` |
| (view, tipsiz) | 4 | türetilmiş | `v_budget_summary.*` |

**DB tarafı sağlam.** PostgreSQL `numeric` tam ondalıktır; saklanan hiçbir değer bozulmuyor.

#### `DecimalTransformer` — ölçümün en önemli tek bulgusu

`src/database/transformers/decimal.transformer.ts`:

```ts
from: (value?: string | null) => {
  const num = Number(value);          // ← IEEE 754'e burada düşüyor
  return Number.isNaN(num) ? null : num;
}
```

Transformer sürücüden gelen **tam ondalık string**'i alıp `Number()` ile float'a çeviriyor.
Yani **tam aritmetiği korumuyor**; dağınık `parseFloat`/`Number` çağrılarını tek yere topluyor.

Bu, yaygın bir yanlış anlamayı düzeltir: *"`DecimalTransformer` mevcut, `ledger_entries.amount`'a
uygulanmamış"* ifadesi doğru ama **çözümü işaret etmiyor**. Bugünkü hâliyle uygulanması INV-N-002
üzerinde **sıfır etki** yapar. Faz planında transformer'ın **kendisi değiştirilmelidir**
(`from` → `new Big(value)`), ki bu 39 entity'nin 5'ini değil, transformer'ı tüketen her yolu etkiler.

Bugün transformer kullanan 5 entity: `budget-allocation`, `budget-envelope`, `sales-actual`,
`sales-actual-batch`, `budget-summary.view`. Kalan 34 entity para alanlarını çıplak `number` tutuyor.

### S1.2 — Alan A adayları (para)

**54 dosya.** Katman dağılımı:

| Katman | Dosya | Rol |
|---|---|---|
| `shared/budget` (7) | zarf, rezervasyon, tahsis | **yazar + karşılaştırır** (eşik kararları) |
| `shared/spend-calculation` (5+1 dto) | harcama üretimi | **hesaplar** — Alan A'nın kaynağı |
| `modes/actuals-first/settlement` (4) | mutabakat | okur + hesaplar |
| `modes/actuals-first/agreement-transaction` (4) | CAP kontrolü | **karşılaştırır** (sert kapı) |
| `modes/planning-first/plan` (3) | plan toplamları | hesaplar + yazar + rezerve eder |
| `modes/actuals-first/{sales-actuals,on-invoice,ledger}` (9) | kayıt | yazar |
| `shared/finance-reporting` (3) | raporlama | **salt-okur** → Alan B'ye aday |
| `database/entities` (7) + `database` (1) | kalıcılaştırma | sınır |
| `user`, `agreement` (4) | ikincil okuma | okur |

### S1.3 — Alan B adayları (analitik)

- `shared/kpi-engine/` — `formula-parser.service.ts` `safeEval` (`new Function`, saf JS float),
  `kpi-engine.service.ts`. Çıktı: KPI değerleri + RAG durumu.
- `shared/finance-reporting/` — salt-okur toplama/sunum.
- `shared/dashboard/` — gösterim.
- RAG değerlendirmesi — `kpis.rag_green_threshold`/`rag_amber_threshold` (`numeric(18,4)`).

---

### S1.4 — Sınır ihlali bulguları ⟨en kritik bölüm⟩

**Dört geçiş bulundu. Üçü ayrılabilir, biri ayrılamaz — ve ayrılamayan, taslağın sınırı yanlış
yere çizdiğini gösteriyor.**

#### A. `spend-calculation` → plan para kolonları → bütçe rezervasyonu — **AYRILAMAZ**

Tam zincir:

```
spend-calculation.service.ts:190   return (baseAmount * enteredValue) / 100;     ← oran çarpımı, float
spend-calculation.service.ts:212   return (baseAmount * enteredValue) / 100;
spend-calculation.service.ts:786   totalSpend: skuBreakdowns.reduce((sum, b) => sum + b.base.totalSpend, 0)
spend-calculation.service.ts:816   totalSpend: skuBreakdowns.reduce((sum, b) => sum + b.planned.totalSpend, 0)
        ↓
plan.service.ts:2413               totalSpend: planTotalSpend        → plans.total_spend numeric(18,2)
plan.service.ts:2424               onInvoiceSpend / offInvoiceSpend  → plans.*_spend numeric(18,2)
        ↓  (submit)
plan.service.ts:819-822            const totalSpend = Number(plan.totalSpend);
plan.service.ts:844                if (Math.abs(onInvoice + offInvoice - totalSpend) > 0.01) → throw
        ↓
BudgetService#reserveForPlan       → budget_transactions.amount (KALICI PARA)
```

**Sonuç:** `spend-calculation` Alan B değildir. Ürettiği sayı doğrudan paraya dönüşüyor.
Görev metnindeki *"muhtemelen ikisinde birden"* hipotezi **yanlış** — bölünmüyor, tümüyle Alan A.

`:190`/`:212` ayrıca A2'nin pratikteki karşılığı: `(tutar × yüzde) / 100`, float'ta, yuvarlama
kuralı **yazılı değil**. Sonuç `numeric(18,2)` kolona yazılırken PostgreSQL sessizce yuvarlıyor —
yuvarlama modu uygulama tarafından seçilmemiş, DB varsayılanına bırakılmış.

#### B. `kpi-engine` → RAG → onay akışı — **AYRILABİLİR (yumuşak geçiş)**

```
formula-parser.service.ts:252   new Function(`"use strict"; return (${sanitized});`)   ← saf float
        ↓
plan.service.ts:2254,2396       gpRoi / overallRoi = kpiResults['GP_ROI_PCT']?.value
        ↓
plan_skus.gp_roi, plans.overall_roi   numeric(18,4)   ← ANALİTİK kolon, para değil
        ↓
approval-workflow.service.ts:148   if (plan.ragStatus === 'RED') warnings.push(...)
```

**Sert kapı aranmış, bulunamamıştır** — `ragStatus` hiçbir `throw`/`Forbidden`/`reject` yolunda
geçmiyor. RAG yalnız uyarı üretiyor. Dolayısıyla KPI motoru float kalabilir; Alan B tanımı burada
tutuyor.

⚠️ Bu **bugünkü** durumdur. RAG bir gün onayı bloklarsa geçiş sertleşir ve Alan B'nin çıktısı
karar verir hâle gelir. ADR bunu açık bir kısıt olarak yazmalı: *"RAG/KPI çıktısı bir iş kararını
bloklayamaz; bloklaması gerekiyorsa o KPI Alan A'ya taşınır."*

#### C. CAP karşılaştırması — Alan A içi, ama **tam aritmetik DB'de yapılıp float'ta kaybediliyor**

```
agreement-transaction.repository.ts:115   .select('COALESCE(SUM(tx.amount), 0)', 'total')   ← SQL numeric, TAM
agreement-transaction.repository.ts:120   return parseFloat(result.total) || 0;            ← burada kayboluyor
        ↓
agreement-transaction.service.ts:102      if (currentTotal + dto.amount > Number(agreement.capTotalAmount))
```

INV-N-002'nin kanonik vakası: toplama zaten tam yapılıyor, karar float'ta veriliyor. **En ucuz
kazanç burada** — karşılaştırmayı SQL'e taşımak veya toplamı string olarak alıp tam karşılaştırmak
tek dosyalık iş.

Yan bulgu (kapsam dışı, CLAUDE.md §2.5): `parseFloat(...) || 0` — `NaN` sessizce `0`'a düşer ve
CAP kontrolü "sınırsız" hâle gelir. Bugün `COALESCE` bunu engelliyor, yani erişilemez; ama kalıp
sessiz-sıfır yasağına aykırı.

#### D. Epsilon toleransları — float hatasının **altı yerde yazılı itirafı**

| Konum | Sabit | Ne koruyor |
|---|---|---|
| `plan.service.ts:844` | `0.01` | `on + off === total` özdeşliği (submit kapısı) |
| `budget.service.ts:1636-1637` | `EPSILON = 0.01` | zarf bölme toplamı = tahsis |
| `budget.service.ts:1674` | `EPSILON` | tipsiz rezervasyon net kontrolü |
| `budget.service.ts:1761` | `EPSILON` | net-sıfır kısa devresi |
| `spend-distribution.service.ts:34,313,562` | `ROUNDING_TOLERANCE = 0.01` | lumpsum dağıtım artığı |
| `sales-actuals-validation.service.ts:45,236` | `RECONCILIATION_TOLERANCE = 0.01` | `net + discount = gross` |

Tam aritmetiğe geçişte bunlar **otomatik silinemez**. İkisi farklı şey karşılıyor:
- `spend-distribution` ve `sales-actuals` toleransları **gerçek kuruş artığı** içindir
  (orantısal dağıtımda 1 kuruş bir yere gitmek zorunda) — tam aritmetikte de kalmalı, ama
  artık "tolerans" değil **açık artık-atama kuralı** olarak yazılmalı.
- `plan.service.ts:844` ve `budget.service.ts` epsilon'ları **yalnız float gürültüsü** içindir —
  tam aritmetikte `=== 0` olmalı ve tolerans kaldırılmalı.

Bu ayrımı yapmadan geçiş yapılırsa toleranslar kalır ve tam aritmetiğin tek somut faydası
(kesin eşitlik) kaybolur.

---

## S2 — Dokunma yüzeyi

### S2.1 — Sayım

Kapsam: `src/modules` + `src/database`, **283 dosya** (`*.spec.ts`, `migrations/`, `seeds/` hariç).

| Metrik | Sayı | Not |
|---|---|---|
| `parseFloat(` | **9** | 5 dosya, hepsi repository katmanı (SQL toplamı okuma) |
| `Number(` toplam | **347** | hepsi para değil |
| `Number(` **para bağlamı** | **130** | ad kalıbıyla ayrıldı; belirsizler para sayıldı (kötümser) |
| `Number(` açıkça para dışı | 5 | sayfalama/id/sayaç/yıl |
| `toFixed(` | **18** | sunum + log |
| `Math.round(` | 4 | |
| `Math.floor(` | 5 | |
| `Math.abs(` | **12** | 6'sı epsilon karşılaştırması (§S1.4-D) |
| Transformer'ı eksik entity | **34 / 39** | ama §S1.1 — transformer zaten çözüm değil |

**Belirsizlik notu:** 347 − 130 − 5 = 212 `Number()` çağrısı ad kalıbıyla sınıflandırılamadı.
Örneklemle bakıldığında çoğu enum/tarih/konfig dönüşümü; ancak bu **tam sayım değildir** ve
faz planlaması sırasında dosya bazında elle triyaj gerekir.

`parseFloat` dağılımı (tamamı):
```
sales-actuals.repository.ts:3 · budget.repository.ts:2 · ledger.repository.ts:2
on-invoice.repository.ts:1 · agreement-transaction.repository.ts:1
```
Hepsi aynı kalıp: SQL `SUM(...)` sonucunu float'a çevirmek. **Tek noktada düzeltilebilir bir sınıf.**

### S2.2 — Yoğunluk ve risk sıralaması (ilk 10)

| # | Dosya | Para aritmetiği | Test | Finansal karar veriyor mu | T-057 |
|---|---|---|---|---|---|
| 1 | `shared/budget/budget.service.ts` | 114 | ✅ | **evet** (eşik, rezervasyon) | ⚠️ |
| 2 | `planning-first/plan/plan.service.ts` | 109 | ✅ | **evet** (submit kapısı) | ⚠️ |
| 3 | `shared/spend-calculation/spend-calculation.service.ts` | 97 | ✅ | **evet** (para üretir) | — |
| 4 | `shared/budget/budget-allocation.service.ts` | 83 | ✅ | evet | — |
| 5 | `shared/finance-reporting/finance-reporting.service.ts` | 75 | ❌ | hayır (salt-okur) | — |
| 6 | `planning-first/plan/approval-workflow.service.ts` | 40 | ✅ | **evet** (onay) | ⚠️ |
| 7 | `shared/spend-calculation/spend-validation.service.ts` | 35 | ❌ | evet (limit) | — |
| 8 | `shared/budget/budget.repository.ts` | 33 | ❌ | sınır (parseFloat) | ⚠️ |
| 9 | `shared/budget/budget-reservation.service.ts` | 26 | ✅ | evet | — |
| 10 | `shared/spend-calculation/spend-distribution.service.ts` | 24 | ❌ | evet (dağıtım) | — |

**Testsiz + finansal karar veren dört dosya (7, 8, 10 ve 5):** bu üçü (5 hariç) faz planında
**önce test yazılması gereken** dosyalardır. Sayısal kontrat değişikliği testsiz bir finansal
karar dosyasında yapılamaz.

### S2.3 — T-057 çakışması

`budget.service.ts`, `plan.service.ts`, `approval-workflow.service.ts`, `budget.repository.ts`,
`agreement-transaction.service.ts`, `on-invoice.service.ts` — **altısı da commit'lenmemiş T-057
deltası taşıyor** ve ilk-10'un dördü bunlardan.

**Sonuç: sayısal kontrat işi T-057 commit'lenmeden başlayamaz.** Aksi hâlde iki büyük değişiklik
aynı dosyalarda çakışır ve hangi davranışın hangi işten geldiği ayrıştırılamaz.

---

## S3 — Şema gerçekleri

### S3.1 — Oran ölçeği ⟨A2 — CEVAPLANDI⟩

**Oranlar yüzde notasyonunda saklanıyor (0–100), kesir değil.** Üç bağımsız kanıt:

1. `lta-rate.entity.ts:34,42` — alan yorumları: `// 0-100`
2. `lta-agreement.service.ts:473` — `if (rate.onInvoicePercentage + rate.offInvoicePercentage > 100)`
3. Canlı veri: `budget_alert_configurations.threshold_percent` ∈ [80.00, 100.00]
4. Formüller `/100` uyguluyor: `(PLANNED_GSV - PLANNED_LTA_ON) * entered_value / 100`
   (`mechanic.seed.ts:114`, `spend-calculation.service.ts:190,212`)

**Ölçek: `numeric(5,2)` → maksimum 999.99, tam 2 ondalık.**
- `%3` → `3.00` ✅
- `%3,25` → `3.25` ✅ **sığıyor**
- `%3,255` → ✗ **sığmıyor** — sessizce `3.26`'ya yuvarlanır

#### ⚠️ A2'nin cevaplanmamış yarısı: aynı kavram iki farklı ölçekte

| Alan | Tip | Ondalık |
|---|---|---|
| `lta_rates.on_invoice_percentage` | `numeric(5,2)` | **2** |
| `lta_rates.off_invoice_percentage` | `numeric(5,2)` | **2** |
| `lta_plan_overrides.override_*_pct` | `numeric(5,2)` | **2** |
| `mechanics.max_combined_discount_percentage` | `numeric(5,2)` | **2** |
| **`plan_mechanic_values.entered_value`** | **`numeric(18,4)`** | **4** |
| `mechanics.default_value` / `min_value` / `max_value` / `step_increment` | `numeric(18,4)` | **4** |

`entered_value` **harcama hesabında yüzde olarak kullanılan alandır**
(`spend-calculation.service.ts:190` → `(baseAmount * enteredValue) / 100`). Yani sistemde
"yüzde" kavramının **iki farklı ölçeği** var: LTA oranları 2 ondalık, mekanik girdisi 4 ondalık.

**Yuvarlama kuralı bu ayrım çözülmeden yazılamaz.** ADR'nin cevaplaması gereken:
oran ölçeği 2 mi 4 mü, ve `lta_rates` 4'e mi çıkacak yoksa `entered_value` 2'ye mi inecek
(ikincisi veri kaybı riski taşır — bugün 4 ondalıklı bir değer girilebiliyor).

**Veri kanıtı sınırlı:** `lta_rates` tablosu **boş** (0 satır),
`mechanics.max_combined_discount_percentage` 6 satırın hepsinde `NULL`. Gerçek Wella verisi
yüklenmeden "en yüksek ondalık basamak" sorusu **ölçülemez**. Bu bir açık kalandır (§Açık kalanlar).

### S3.2 — Para birimi ⟨A4 — CEVAPLANDI⟩

`currency` kolonu **11 yerde** var: `agreements`, `agreement_transactions`, `budget_envelopes`,
`budget_transactions`, `customers`, `forecasting_units`, `ledger_entries`, `on_invoice_entries`,
`sales_actuals`, `skus`, `v_budget_summary`.

- **Veride yalnız `TRY`** (`sales_actuals`: 3 satır, hepsi TRY)
- **Kur / dönüşüm / FX kavramı kod tabanında YOK** — `exchangeRate`, `fxRate` araması boş
- Kod üç yerde `'TRY'` **hardcode** ediyor: `plan.service.ts:1312, 1340, 1370`

**Sonuç:** şema çok para birimli, ürün tek para birimli, dönüşüm hiç yok. Sayısal kontrat bugün
tek para birimi varsayabilir. Ama `currency` kolonu aritmetiğe **hiç girmiyor** — yani iki farklı
para biriminde iki satır bugün sessizce toplanır. Bu D-05'in kapsamı dışında ama aynı sınıftan
bir sessiz-yanlış-sayı riskidir ve ayrı kayda değer.

---

## S4 — Serileştirme sınırı ⟨A3⟩

**Bugün para API'den `number` olarak çıkıyor.**

| Katman | Tip | Kanıt |
|---|---|---|
| DTO (girdi) | `number` | `reserve-budget.dto.ts:19`, `create-ledger-entry.dto.ts:42`, `create-budget-envelope.dto.ts:57` |
| DTO (çıktı) | `number` | `budget-report.dto.ts:99` |
| Swagger | örtük `number` | `@ApiProperty` para alanlarında açık `type:` yok — Nest TS tipinden türetiyor |
| Frontend tip | `number` | `collmind.frontend/src/types/budget.types.ts:39,41,68` |
| Frontend render | `.toLocaleString('tr-TR')` | `BudgetSummaryCard.tsx:79,91`, `BudgetEnvelopeCard.tsx:91,107` |

**Ondalık tipe geçilirse API sözleşmesi değişir.** İki seçenek:

1. **Sözleşmeyi koru** — serileştirmede `Big` → `number`. Frontend'e dokunulmaz, ama sunuma
   giden değer yine float olur. Görüntüleme için yeterli (2 ondalık, `toLocaleString`), çünkü
   frontend para üzerinde **aritmetik yapmıyor** (yalnız biçimlendiriyor — grep ile doğrulandı).
2. **Sözleşmeyi değiştir** — para alanları `string` döner. Frontend tipleri + her `toLocaleString`
   çağrısı değişir. Doğru ama daha pahalı.

**Öneri: (1).** Ölçüm frontend'in para aritmetiği yapmadığını gösteriyor; sınırı backend'de
tutmak yeterli. Bu, A3'ü ucuz cevaplıyor ve frontend'i faz planından tamamen çıkarıyor.

---

## S5 — Kütüphane ölçümü ⟨A1⟩

### S5.1 — Sentetik karşılaştırma (ham çıktı)

Ortam: Node **v24.11.1**, macOS (darwin 25.1.0). Benchmark scratchpad'de, **repo'ya bağımlılık
kurulmadı**. İşlem karışımı: toplama/çıkarma %50 · karşılaştırma %25 · oran çarpımı %15
(yuvarlamalı, `(tutar × pct)/100` — gerçek koddan) · orantısal bölme %10. 3 tekrarın en iyisi.

```
=== 1e+5 işlem ===
  number (taban)         1.1 ms      1.0×
  decimal.js           159.5 ms    148.2×
  big.js                99.5 ms     92.4×
  bignumber.js         174.5 ms    162.1×

=== 1e+6 işlem ===
  number (taban)         5.0 ms      1.0×
  decimal.js          1578.6 ms    315.2×
  big.js               990.1 ms    197.7×
  bignumber.js        1780.1 ms    355.5×

=== doğruluk ===
  number      1000 × 0.07 = 69.99999999999966
  decimal.js  1000 × 0.07 = 70
```

Kurulu boyut: `big.js` **68K** · `decimal.js` 296K · `bignumber.js` 516K.

**İşlem başına maliyet (1e6'dan):** `number` 0.0050 µs · `big.js` 0.9901 µs · `decimal.js` 1.5786 µs.
**big.js farkı: +0.985 µs/işlem.**

**A1 önerisi: `big.js`.** En hızlı tam-aritmetik seçenek (decimal.js'in 1.6×, bignumber.js'in
1.8× altında), en küçük (68K), ve API'si para için yeterli. `decimal.js`'in ek yetenekleri
(trigonometri, log, 34 basamak precision) Alan A'da gereksiz. **Yuvarlama modu ADR'de açıkça
yazılmalı** — `Big.RM = Big.roundHalfUp` (bankacı yuvarlaması değil, BRD'de aksi belirtilmedikçe).

### S5.2 — Gerçek yol işlem sayısı

**Ölçülmüş taban (`docs/analysis/0007`, T-046):**

| Senaryo | Süre | Maliyet modeli |
|---|---|---|
| 52 SKU recalc (tactic yok) | **195 ms** | `ms ≈ 3.06·n + 36` |
| 52 SKU uçtan uca (ADR 0003) | **540–548 ms** | — |
| 500 SKU (tactic yok) | **1532 ms** | — |
| 500 SKU (tactic var, 3 mekanik) | **~3400 ms** | `ms ≈ 6.72·n + 21` |

**Belirleyici olgu (`0007` §sonuç):** darboğaz aritmetik değil, **SKU başına sabit sayıda DB
round-trip**. Maliyet O(n) ve I/O-bound.

**SKU başına aritmetik işlem sayısı — yapısal sayım** (`spend-calculation.service.ts`, yorum satırları hariç):

| Blok | Operatör |
|---|---|
| `calculateAllSpendsForSKU` (406–675) | 30 |
| `calculateCompleteSKUFinancialMetrics` (924+) | 28 |
| `calculateMechanicSpend` (81–180) | 6 × mekanik sayısı |
| `calculateOnInvoiceDiscount` / `calculateOffInvoiceDiscount` (182–217) | 9 |
| **Gerçekçi toplam (3 mekanik)** | **~85** |

**Varsayımlar (açıkça):** (a) her operatör bir tam-aritmetik çağrısına dönüşür — abartılıdır,
çünkü bir kısmı tamsayı/indeks aritmetiğidir; (b) `budget`/`plan` katmanındaki işlemler SKU
başına değil plan başına çalışır, bu yüzden SKU çarpanına girmez; (c) `v_budget_summary`
toplaması **SQL'de** yapılıyor (`SUM(CASE ...)`, `numeric`, tam) — TS'e hiç girmiyor, sayıma dahil değil.
Kötümser senaryo için 250 op/SKU alındı (gerçekçinin ~3×'i).

### S5.3 — Öngörü

`big.js` farkı × işlem sayısı:

| Senaryo | Taban | Gerçekçi (85 op/SKU) | Kötümser (250 op/SKU) |
|---|---|---|---|
| 52 SKU recalc | 195 ms | +4.4 ms → **+2.2%** | +12.8 ms → **+6.6%** |
| 52 SKU uçtan uca | 548 ms | +4.4 ms → **+0.8%** | +12.8 ms → **+2.3%** |
| 500 SKU (tactic yok) | 1532 ms | +41.9 ms → **+2.7%** | +123.1 ms → **+8.0%** |
| 500 SKU (tactic var) | 3400 ms | +41.9 ms → **+1.2%** | +123.1 ms → **+3.6%** |

**STOP koşulu 4 (%20) tetiklenmedi** — kötümser senaryoda bile en yüksek artış **%8.0**.

**Doğru çerçeve (görev metninin belirttiği gibi):** NFR-1.2 (`<500ms`) ve NFR-1.4 (`<300ms` p95)
**zaten ihlal ediliyor** (ADR 0003: tek recalc 540–548 ms). Soru "bütçeye sığar mı" değil,
"mevcut aşımı ne kadar büyütür" — cevap: **ihmal edilebilir düzeyde**. 500 SKU'da bütçenin
3–6.8× katı olan aşımı, tam aritmetik %1–8 büyütür. Performans bu kararın **belirleyici
değişkeni değildir.**

---

## Faz planı önerisi

Ölçüme dayalı. **Önkoşul: T-057 commit'lenmiş olmalı** (§S2.3).

| Faz | İş | Dosya | Risk | Gerekçe |
|---|---|---|---|---|
| **0** | Testsiz finansal karar dosyalarına test yaz: `spend-validation`, `budget.repository`, `spend-distribution`, `finance-reporting` | 4 | düşük | Sayısal değişiklik testsiz dosyada yapılamaz |
| **1** | **Sınır düzeltmeleri — kütüphanesiz.** CAP karşılaştırmasını SQL'e taşı (`agreement-transaction.repository.ts:115-120` + `service.ts:102`); 5 `parseFloat` repository kalıbını tekilleştir | 6 | düşük | Tek sınıf, tek kalıp; INV-N-002'nin en ucuz kazancı |
| **2** | `DecimalTransformer`'ı **gerçekten tam** yap (`from` → `Big`), 5 mevcut entity üzerinden doğrula | 1 + 5 | orta | §S1.1 — bugünkü hâli çözüm değil |
| **3** | `spend-calculation` (5 dosya) tam aritmetiğe geçir — Alan A'nın kaynağı | 5 | **yüksek** | Para burada üretiliyor; ilk-10'un 3'ü burada |
| **4** | `budget` + `plan` katmanı (10 dosya) | 10 | **yüksek** | T-057 çakışması geçmiş olmalı |
| **5** | **Epsilon triyajı** — 6 toleransın her birini "gerçek artık" / "float gürültüsü" diye sınıflandır, ikincileri kaldır | 4 | orta | §S1.4-D; bu yapılmazsa geçişin faydası kaybolur |
| **6** | Kalan Alan A dosyaları (~28) | 28 | düşük | Çoğu okuma/kayıt |

Alan B (`kpi-engine`, `dashboard`, `finance-reporting` sunumu) **hiçbir fazda değişmez.**

---

## ADR 0007'ye düzeltme önerileri

ADR henüz yazılmadığı için bunlar **yazılırken uyulması gereken kısıtlar**:

1. **Sınır `spend-calculation`'ın içinden geçmez.** `spend-calculation` tümüyle Alan A'dır.
   Sınır `kpi-engine` ile `spend-calculation` arasındadır.
2. **`DecimalTransformer`'ı "mevcut çözüm" diye anma.** Bugün `Number()` yapıyor; çözüm değil,
   kaybın merkezileşmiş hâli. ADR transformer'ın **değiştirileceğini** yazmalı.
3. **A2 tek cevapla kapanmıyor.** Oran yüzde notasyonundadır (kesin), ama ölçek **iki farklı**:
   LTA 2 ondalık, `entered_value` 4 ondalık. ADR hangisinin kanonik olduğuna karar vermeli.
4. **Epsilon toleransları geçişin parçasıdır**, yan etkisi değil. ADR altı toleransın
   sınıflandırılmasını bir teslimat olarak saymalı.
5. **RAG kısıtı yazılmalı:** KPI/RAG çıktısı bir iş kararını bloklayamaz; bloklaması gerekiyorsa
   o KPI Alan A'ya taşınır. Bugün geçiş yumuşak, ama korumasız.
6. **Yuvarlama modu açıkça yazılmalı** (`ROUND_HALF_UP` önerilir) ve **artık-atama kuralı**
   orantısal dağıtım için ayrıca tanımlanmalı (bugün `spend-distribution` "en büyük base'e"
   diyor — ADR 0006 ile tutarlı olmalı).
7. **A1 = `big.js`** — ölçülmüş, 68K, en hızlı tam seçenek.
8. **A3 = sözleşme korunur** — serileştirmede `number`'a dönüştür; frontend para aritmetiği
   yapmıyor (ölçüldü).
9. **Performans belirleyici değişken değildir** (%1–8). ADR performansı gerekçe olarak
   kullanmamalı — ne lehte ne aleyhte.

---

## Açık kalanlar

| # | Ölçülemedi | Neden | Ne gerekli |
|---|---|---|---|
| 1 | Gerçek oran ondalık derinliği | `lta_rates` **boş** (0 satır), `max_combined_discount_percentage` 6/6 NULL | Wella verisi yüklenmeli; yoksa A2'nin ölçek kararı veriye değil tasarıma dayanacak |
| 2 | 212 sınıflandırılmamış `Number()` | Ad kalıbı yetmedi | Faz planı sırasında dosya bazında elle triyaj |
| 3 | SKU başına gerçek işlem sayısı | Üretim koduna sayaç eklemek kapsam dışıydı | Yapısal tahmin kullanıldı (85 gerçekçi / 250 kötümser); istenirse geçici harness ile ölçülebilir |
| 4 | Float hatasının **canlı** bir yanlış sonuç ürettiği vaka | Sentetik CAP senaryosu denendi, sınırda flip üretilemedi | Gerçek veriyle tekrar denenmeli; birikimli hata gösterildi (`1000 × 0.07 = 69.99999999999966`) ama üretim etkisi kanıtlanmadı |
| 5 | Çok para birimli toplama riski | D-05 kapsamı dışı | Ayrı task — `currency` kolonu aritmetiğe hiç girmiyor |

**Not (4) önemli:** bu ölçüm float hatasının **mekanizmasını** kanıtladı (birikimli toplama,
epsilon toleranslarının varlığı, tam→float sınırı), ama bugün canlı bir yanlış para tutarı
**göstermedi**. INV-N-002 bir risk kaydıdır, kanıtlanmış bir hata değil. ADR bunu dürüstçe
yazmalı — aksi hâlde aciliyet abartılır.
