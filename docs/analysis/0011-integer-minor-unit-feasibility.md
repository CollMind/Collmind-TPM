# 0011 — Tamsayı minor unit fizibilitesi (D-05)

**Tarih:** 2026-08-03
**Backend SHA:** `e87d1ec` · **Frontend SHA:** `5cf0bd2` · **Meta SHA:** `1535902`
**T-057 deltası çalışma ağacında:** **EVET** (8 değiştirilmiş + 3 yeni dosya, commit'siz)
**Mod:** salt-okunur. İki repoda da hiçbir kaynak dosya değiştirilmedi.
**Önceki ölçüm:** [`0010-numeric-contract-measurement.md`](0010-numeric-contract-measurement.md)

> **Öncül notu:** Görev "ADR 0007 v2 tamsayı minor unit'i reddetti" diyor. `docs/decisions/`
> bugün 0001–0006 arasını tutuyor; **0007 (ne v1 ne v2) yok, git geçmişinde de hiç olmamış**
> — bu `0010`'da da tespit edilmişti. Reddin gerekçesi dosyadan değil görev metninden alındı.

---

## Verdict

**Tamsayı minor unit uygulanabilir, ama "bugün maliyet yok" öncülü ölçümle doğrulanmıyor.**
Reddin *eski* gerekçesi (şema migration'ı + veri dönüşümü) gerçekten zayıf — deploy edilmiş
ortam yok, `plan_mechanic_values` **boş**, en büyük para değeri 600.000 TRY, `db:reset` geçerli.
Veri dönüşümü fiilen sıfır. **Ama ölçüm iki farklı ve daha ağır maliyet buldu:**

1. **Üç ayrı tamsayı ölçeği gerekiyor.** Para 2 ondalık (×100), hacim 3 (×1000), fiyat 4 (×10000).
   `plannedVolume × unitPrice` çarpımı ×10⁷ ölçeğine çıkıyor ve kuruşa inmek için ÷10⁵ gerekiyor.
   Bu, "varsayılan işlemler güvenli" iddiasını zayıflatan tek bulgu: **karışık ölçekli her çarpım
   açık bir yeniden-ölçekleme ister** ve unutulduğunda sonuç 100.000 kat yanlış olur — sessizce değil,
   ama tip sistemi bunu yakalamaz (hepsi `number`).
2. **Frontend para üzerinde iş hesabı yapıyor** (STOP 3). `PlanningGridEnhanced.tsx` NIV, Turnover,
   incremental spend ve uplift% değerlerini `volume × unitPrice` üzerinden istemcide türetiyor.
   Yani "API sınırında ÷100 yap, frontend değişmez" çözümü **yetmez** — o dosya ölçek farkındalığı
   kazanmak zorunda.

**Ayrıca iki STOP koşulu tetiklendi:** 57 para kolonu (eşik 40) ve frontend iş hesabı.

`entered_value` polimorfizmi **gerçek ama ayrılabilir** ve tamsayı yolunu bloklamıyor —
ayırıcı (`mechanics.input_type`) mevcut, dolu ve kategoriyle %100 tutarlı; yüzey 7 dosya.

---

## S1 — `entered_value` polimorfizmi

### S1.1 — Semantik doğrulaması: **POLİMORFİK**

Tek kolon, `mechanic.category`'ye göre dört farklı tüketim
(`spend-calculation.service.ts:131-171` switch):

| Kategori | Tüketim | `file:line` | Semantik |
|---|---|---|---|
| `ON_INVOICE_DISCOUNT` | `(baseAmount * enteredValue) / 100` | `spend-calculation.service.ts:190` | **ORAN** (yüzde) |
| `OFF_INVOICE_DISCOUNT` | `(baseAmount * enteredValue) / 100` | `spend-calculation.service.ts:212` | **ORAN** (yüzde) |
| `PER_UNIT_SUPPORT` | `enteredValue * plannedVolume` | `spend-calculation.service.ts:225` | **PARA** (birim başına) |
| `LUMPSUM_SPEND` | `totalSpend: enteredValue` | `spend-distribution.service.ts:176` | **PARA** (doğrudan tutar) |

```ts
// spend-calculation.service.ts:182-191  → ORAN
private calculateOnInvoiceDiscount(mechanic, enteredValue, plannedGsv, plannedLtaOnInv): number {
  const baseAmount = plannedGsv - plannedLtaOnInv;
  return (baseAmount * enteredValue) / 100;      // ← yüzde olarak yorumlanıyor
}

// spend-calculation.service.ts:218-226  → PARA
private calculatePerUnitSupport(mechanic, enteredValue, plannedVolume): number {
  return enteredValue * plannedVolume;          // ← birim fiyat olarak yorumlanıyor
}
```

**Ayırıcı mevcut:** `mechanics.input_type` (`InputType` enum: `PERCENTAGE | CURRENCY | UNITS |
BOOLEAN`, `mechanic.entity.ts:25-30`). Kolon `nullable: true` ama pratikte **dolu**.

### S1.2 — Veri kanıtı

```
       category       | input_type | n | min_v | max_v
----------------------+------------+---+-------+-------
 on_invoice_discount  | percentage | 0 |       |
 off_invoice_discount | percentage | 0 |       |
 per_unit_support     | currency   | 0 |       |
 lumpsum_spend        | currency   | 0 |       |
```

`plan_mechanic_values`: **0 satır.** Değer aralığı kanıtı yok.

Ama `mechanics` tablosunun kendi sınırları polimorfizmi ele veriyor:

```
     code     |       category       | input_type | min_value | max_value
--------------+----------------------+------------+-----------+-----------
 CPP_ON_PCT   | on_invoice_discount  | percentage |    0.0000 |  100.0000   ← yüzde bandı
 MEC-DISCOUNT | on_invoice_discount  | percentage |    0.0000 |  100.0000
 CPP_OFF_PCT  | off_invoice_discount | percentage |    0.0000 |  100.0000
 PRICE_SUP    | per_unit_support     | currency   |    0.0000 |    (NULL)   ← sınırsız = para
 VIS_LS       | lumpsum_spend        | currency   |    0.0000 |    (NULL)
 DISPLAY_FEE  | lumpsum_spend        | currency   |    0.0000 |    (NULL)
```

**`input_type` ↔ `category` eşleşmesi 6/6 tutarlı.** Ayırıcı güvenilir.

### S1.3 — Aynı sorunun başka örnekleri

Polimorfizm `entered_value`'ya özgü değil — **aynı ayırıcıya bağlı beş kolon**:

| Kolon | Tip | Polimorfik mi |
|---|---|---|
| `plan_mechanic_values.entered_value` | `numeric(18,4)` | ✅ (kanıtlandı) |
| `mechanics.default_value` | `numeric(18,4)` | ✅ (aynı `input_type`) |
| `mechanics.min_value` | `numeric(18,4)` | ✅ (veri gösteriyor) |
| `mechanics.max_value` | `numeric(18,4)` | ✅ (veri gösteriyor) |
| `mechanics.step_increment` | `numeric(18,4)` | ✅ (aynı ayırıcı) |

Altıncı, **gizli** vaka: `agreements.mechanic_value` `numeric(18,4)` →
`agreement.service.ts:1290` `tacticsContext['MECHANIC_VAL'] = agreement.mechanicValue`.
Kodun kendi yorumu eksikliği kabul ediyor:

```ts
// Assuming tactic ID or code maps to the KpiEngine context key
// This mapping needs to be defined in master data
```

Bu yol KPI motoruna (Alan B) gidiyor ve **tek kullanım noktası var** — yani polimorfizm var ama
henüz gerçekten kurulmamış. Tamsayı kararını etkilemiyor, ama kayda değer.

### S1.4 — Sonuç: **polimorfik ama AYRILABİLİR**

Ayırma işinin ölçülmüş büyüklüğü:

| Metrik | Değer |
|---|---|
| `enteredValue` / `entered_value` referansı | **86** |
| Dokunulan dosya (spec + migration hariç) | **7** — 5'i `spend-calculation` içinde |
| Bölünecek kolon | 5 (+1 gizli) |
| Migration büyüklüğü | küçük — `plan_mechanic_values` **boş**, `mechanics` 6 satır |
| Ayırıcı gerekiyor mu | **hayır**, `input_type` zaten var ve tutarlı |

Dosya listesi: `spend-calculation.service.ts`, `spend-distribution.service.ts`,
`spend-validation.service.ts`, `dto/calculation-context.dto.ts`,
`plan-mechanic-value.entity.ts`, `approval-workflow.service.ts` ⚠️T-057, `mechanic.seed.ts`.

**Tamsayı yolunun ön koşuludur ama ucuz bir ön koşuldur.** `big.js` yolunda da yapılması
gerekir (ölçek belirsizliği orada da yuvarlama kuralını yazılamaz kılıyor — `0010` §S3.1).

### S1.5 — Oranların kendisi: seçenekler ve sonuçları

`0010` bulmuştu: oranlar yüzde notasyonunda (0–100), iki ölçekte — LTA `numeric(5,2)`
(2 ondalık), `entered_value` `numeric(18,4)` (4 ondalık).

**Ölçülen gerçek hassasiyet:** `lta_rates` **boş**, `mechanics.max_combined_discount_percentage`
6/6 NULL, `plan_mechanic_values` **boş**. Yalnız `budget_alert_configurations.threshold_percent`
dolu: `80.00 / 95.00 / 100.00` — **0 ondalık kullanılıyor**. Seed'de mekanik oranları için
`min 0.0000 / max 100.0000` tanımlı, yani şema 4 ondalığa izin veriyor ama **kullanılan veri 2
ondalığı bile geçmiyor**.

| Seçenek | Oran temsili | `tutar × oran` tam kalır mı | Sonuç |
|---|---|---|---|
| **A. Baz puan** (×10000, `%3.25` → `32500`) | `int` | ✅ `kuruş × bp / 10⁶` tam bölünürse | 4 ondalık hassasiyet korunur; her çarpımda ÷10⁶ ve açık yuvarlama gerekir |
| **B. Yüzde ×100** (`%3.25` → `325`) | `int` | ✅ `kuruş × pct100 / 10⁴` | LTA'nın bugünkü 2 ondalığına birebir uyar; `entered_value`'nun 4 ondalığı **kaybolur** |
| **C. Oran `numeric` kalır** | `numeric(5,4)` | ⚠️ karışık tip: `bigint × numeric` | DB'de tam, TS'te oran yine float olur — tamsayının faydası oran çarpımında kaybolur |

**Ölçüm, seçenekler arasında karar vermiyor** — ama iki olguyu kayda geçiriyor:
(a) bugün kullanılan hassasiyet **2 ondalığı geçmiyor**, (b) 4 ondalık yalnız şemada var,
veride yok. Yani B seçeneğinin "veri kaybı" riski bugün **ölçülebilir biçimde sıfır**;
gerçek Wella verisi geldiğinde yeniden ölçülmelidir.

---

## S2 — Frontend para yüzeyi

Repo: 232 `.ts`/`.tsx` dosyası.

### S2.1 — Sayım

| Metrik | Değer | Not |
|---|---|---|
| `formatCurrency` **tanımı** | **36** | 34 dosyada, **lokal** |
| `formatCurrency` kullanan dosya | **34** | |
| `formatCurrency` **import**'u | **0** | merkezî yardımcı YOK |
| Para alanı içeren TS tip/interface | `budget.types.ts` + dağınık | `allocatedAmount`, `availableAmount` vb. `number` |
| Para üzerinde **iş hesabı** yapan dosya | **1** | `PlanningGridEnhanced.tsx` (114 `case`) |
| Para **girdi** alan form alanı | backend DTO tarafından 125 alan besleniyor | aşağıda |

### S2.2 — Merkezîlik: **YOK**

`formatCurrency` 36 kez ayrı ayrı tanımlanmış, hiç import edilmiyor. Örnekler:
`GrandTotals.tsx:16`, `PlanningGrid.tsx:42`, `BudgetDashboard.tsx:62`,
`BudgetLedgerPage.tsx:27`, `finance/widgets/*.tsx` (8 widget'ın her birinde ayrı).

**Sonuç:** gösterim katmanında dönüşüm yapılacaksa **36 nokta** dokunulur. Bu, tamsayıya özgü
bir maliyet değil — mevcut bir tekilleştirme borcudur ve `big.js` yolunda da aynı şekilde durur.
Ama tamsayı yolunda **tetiklenir**.

### S2.3 — API sınırında dönüşüm: **teknik olarak mümkün, ama tek başına YETMİYOR** ⟨belirleyici⟩

**Mimari ölçüm:**

| Olgu | Değer |
|---|---|
| Controller | **32** |
| Endpoint (`@Get/@Post/@Put/@Patch/@Delete`) | **235** |
| Global serileştirme interceptor | **YOK** (`main.ts` yalnız `ValidationPipe`) |
| `ClassSerializerInterceptor` | **YOK** |
| Response DTO / mapper katmanı | **kısmi** — 8 `*-response.dto.ts`, sistematik değil |
| `@Transform`/`@Expose`/`@Exclude` kullanımı | **6** (tüm repo) |
| Girdi DTO'sunda para alanı | **125** |
| Response DTO'sunda para alanı | **10** |

Controller'lar servis sonucunu **doğrudan** dönüyor:

```ts
// budget.controller.ts:100-105
async getReservedAmount(@TenantId() tenantId, @Param('id') id) {
  const amount = await this.budgetService.getReservedAmount(tenantId, id);
  return { envelopeId: id, reservedAmount: amount };     // ← ham nesne, DTO yok
}
```

**Değerlendirme:** NestJS'te tek bir response interceptor eklemek mümkündür ve **tek ekleme
noktası** olur (`app.module.ts`). Ad kuralı (`*Minor` → `*`, ÷100) ile mekanik çalışabilir.
Girdi tarafı 125 DTO alanına `@Transform` ister — ya da tek bir özel pipe.

**Ama bu, breaking change'i ortadan kaldırmıyor**, çünkü:

> `PlanningGridEnhanced.tsx` para üzerinde **kendi hesabını** yapıyor.

```tsx
// PlanningGridEnhanced.tsx:200-205
case 'PLAN_NIV': {
  const planGsv = (planSku.plannedVolume ?? 0) * (sku?.unitPrice ?? 0);
  const totalOnInv = (planSku.plannedLtaOnInvoiceSpend ?? 0) + (planSku.promoOnInvoiceSpend ?? 0);
  return planGsv - totalOnInv;
}
```

Bu dosya `BASE_NIV`, `PLAN_NIV`, `INCR_NIV`, `BASE_TO`, `PLAN_TO`, `INCR_TO`,
`INCREMENTAL_SPEND`, `TO_UPLIFT_PCT` metriklerini **istemcide** türetiyor — `volume × unitPrice`
çarpımı dahil. Üretim grid'idir (`PlanDetailPage.tsx:27` `PlanningGridEnhanced as PlanningGrid`).

API sınırında ÷100 yapılsa bile bu dosya float'ta çalışmaya devam eder; tamsayı geçirilse
ölçek farkındalığı kazanmak zorundadır. **Her iki durumda dokunulur.**

Karşıt örnek — `GrandTotals.tsx` doğru yapıyor: `plan.totalSpend`, `plan.overallRoi` gibi
backend'in hesapladığı değerleri **okuyor**, türetmiyor.

> ⚠️ **Kapsam dışı ama kayda değer:** `PlanningGridEnhanced.tsx`'in bu bloğu `CLAUDE.md` §2.3'ün
> *"Hesaplamalar asla hardcode edilmez. Frontend sadece sonucu render eder"* kuralıyla çelişiyor
> gibi görünüyor. Bu bir BRD/ADR yorumu gerektirir ve **bu ölçümün kararı değildir** — ayrı
> task konusu.

---

## S3 — Tamsayı yolunun gerçek maliyeti

### S3.1 — Hangi çağrılar kayıpsız hâle gelir

`0010`: **130 para bağlamlı `Number()` + 9 `parseFloat`**.

Tamsayı senaryosunda:

| Desen | Örnek | Tamsayıda |
|---|---|---|
| Saklanan değeri okuma | `Number(plan.totalSpend)` | ✅ **kayıpsız** (2⁵³ altında) |
| Karşılaştırma | `currentTotal + dto.amount > Number(cap)` | ✅ **kayıpsız** (toplama tam) |
| Toplama/çıkarma birikimi | `reduce((s, b) => s + b.totalSpend, 0)` | ✅ **kayıpsız** |
| Oran çarpımı | `(baseAmount * enteredValue) / 100` | ❌ **yuvarlama gerekir** |
| Orantısal bölme | lumpsum dağıtımı | ❌ **yuvarlama + artık ataması gerekir** |
| Karışık ölçek çarpımı | `plannedVolume * unitPrice` | ❌ **yeniden ölçekleme gerekir** |

**Ölçülmüş kesirli-sonuç yüzeyi:**

| İşlem sınıfı | Sayı |
|---|---|
| `/ 100` oran çarpımı | **17** |
| Para bağlamlı bölme | **52** |
| Orantısal dağıtım satırı (`spend-calculation` içinde) | **123** |
| Mevcut `Math.round(` / `toFixed(` | **19** |

**Kaba ayrım:** 139 dönüşüm çağrısının **~%60–70'i kayıpsız hâle gelir** (okuma, karşılaştırma,
toplama). Geri kalan ~50–70 nokta (bölme, oran, karışık ölçek) tamsayıda da **açık yuvarlama
kuralı** ister. Bu, `big.js` yolunda 139'un **hepsinin** değişmesine karşı gerçek bir azalmadır —
görev metnindeki öncül bu noktada **doğrulandı**.

### S3.2 — 2⁵³ sınırı ⟨yeni bulgu⟩

```
JS Number.MAX_SAFE_INTEGER = 9,007,199,254,740,991
  → kuruş cinsinden        = 90,071,992,547,409.91 TRY
numeric(18,2) maksimum     = 9,999,999,999,999,999.99 TRY
  → kuruş cinsinden        = 999,999,999,999,999,999   ← 2⁵³'ü AŞIYOR
```

`bigint` kolon, JS `number`'ın **tam temsil edemeyeceği** değerleri tutabilir. Yani
"tamsayıda `261000` tam temsil edilir" doğrudur ama **sınırlıdır**: 90 trilyon TRY'ye kadar.

**Gerçek veri bu sınırın 8 mertebe altında:** en büyük değerler `budget_envelopes.allocated_amount`
= 600.000 TRY, `ledger_entries.amount` = 12.000 TRY, `skus.unit_price` = 1.839,50 TRY.
Pratikte `number` güvenli; ama kontrat bu sınırı **yazmak zorunda**, yoksa `bigint` kolonu
ile `number` TS tipi arasında sessiz bir uyumsuzluk kalır.

**Karışık ölçek çarpımı sınıra daha hızlı yaklaşıyor:**
`volume_milli (×1000) × price_10k (×10000)` = ×10⁷ ölçeğinde ham çarpım.
1e6 birim × 100,00 TRY → `1.000.000.000.000.000` = **2⁵³'ün %11,1'i**. Daha büyük planlarda
`BigInt`'e geçmek gerekir — ki bu `number` aritmetiğinin "varsayılan güvenli" olma iddiasını
zayıflatır.

### S3.3 — Migration büyüklüğü ⟨STOP 4 tetiklendi⟩

| Grup | Kolon | Tablo |
|---|---|---|
| Para, `numeric(_,2)` (yüzdeler hariç, view hariç) | **57** | **23** |
| Fiyat/polimorfik, `numeric(18,4)` | +11 | |
| — saf fiyat (`skus.unit_price`, `cogs`, `base_price`, `list_price`, `actual_price`) | 5 | |
| — polimorfik (`entered_value`, `mechanics.*_value`, `step_increment`, `mechanic_value`) | 6 | |
| **Toplam dönüşüm adayı** | **~68** | |
| Alan B'de kalanlar (`gp_roi`, `overall_roi`, `rag_*_threshold`) | 5 | değişmez |

**57 > 40 → STOP koşulu 4 tetiklendi.**

**Veri dönüşümü gerçekten sıfır:** `plan_mechanic_values` 0 satır, `lta_rates` 0 satır,
`ledger_entries` 1.231 satır (dev), deploy edilmiş ortam yok. `db:reset` + `seed` yeterli.
**Ama seed dosyaları değişir** — `mechanic.seed.ts`, `budget-envelope.seed.ts`,
`sales-actual.seed.ts`, `kpi.seed.ts` ve diğerleri para/oran literalleri taşıyor.

### S3.4 — Yeniden adlandırma etkisi

`amount` → `amount_minor` gibi bir yeniden adlandırma, derleyiciyi her kullanım yerinde
patlatır. Ölçülen referans sayısı (backend, migration hariç, spec dahil):

| Alan | Referans |
|---|---|
| `amount` | **391** |
| `totalSpend` | 139 |
| `allocatedAmount` | 70 |
| `onInvoiceSpend` / `offInvoiceSpend` | 54 / 53 |
| `capTotalAmount` | 54 |
| `consumedAmount` | 44 |
| `availableAmount` | 30 |
| `reservedAmount` | 15 |
| **Toplam** | **850** |

**Maliyet mi fayda mı:** 850 derleyici hatası, "sessiz karışma imkânsız" garantisinin
**fiyatıdır**. Karşılaştırma noktası: `big.js` yolunda tip `number` → `Big` değişir ve bu da
aynı yerlerde derleyici hatası üretir — yani **850 rakamı tamsayıya özgü bir ceza değil**,
her iki yolda benzerdir. Fark şurada: tamsayıda ad değişikliği *isteğe bağlı* (ek güvenlik),
`big.js`'te tip değişikliği *zorunlu*.

---

## Yan yana karşılaştırma

Her satır ölçülmüş sayı taşır.

| Boyut | Tamsayı minor unit | `big.js` |
|---|---|---|
| Dönüşecek DB kolonu | **57** (+11 fiyat/polimorfik) | **0** |
| Veri dönüşümü | **0 satır** (`pmv` boş, `db:reset` geçerli) | 0 |
| Değişmesi zorunlu dönüşüm çağrısı | **~50–70** / 139 | **139** / 139 |
| Kayıpsız hâle gelen çağrı | **~70–90** | 0 |
| Yuvarlama gereken nokta | 17 `/100` + 52 bölme + 123 dağıtım satırı | aynı |
| Ölçek sayısı | **3** (para ×100, hacim ×1000, fiyat ×10000) | 1 (`numeric` korunur) |
| Karışık ölçek çarpımı riski | **var** — `volume × price` ÷10⁵ ister, tip yakalamaz | yok |
| JS temsil sınırı | **2⁵³ = 90 trilyon TRY**; gerçek veri 600K | yok (keyfi hassasiyet) |
| Yanlış kullanımda ne olur | `.toNumber()` yok; ama ölçek unutulursa **10⁵ kat hata** | `.toNumber()` sessiz kayıp; `+` string birleştirir |
| DB kesirli değeri reddeder mi | ✅ `bigint` reddeder | ❌ `numeric(18,2)` sessizce yuvarlar |
| Kütüphane bağımlılığı | **0** | `big.js` 68K |
| Performans (0010 ölçümü) | ~taban (`number` aritmetiği) | +%1–8 |
| Frontend dokunma | **36 formatter + 1 hesap dosyası** | 36 formatter (API `number` kalırsa **0**) |
| API sözleşmesi | interceptor ile korunabilir (**yok, eklenmeli**) | korunur (`0010` §S4) |
| `entered_value` bölme ön koşulu | **evet** (7 dosya) | evet (yuvarlama kuralı için) |
| Yeniden adlandırma derleyici hatası | 850 (isteğe bağlı) | benzer (tip değişikliği, zorunlu) |

---

## ADR 0007'ye düzeltme önerileri

ADR henüz yazılmadığı için bunlar yazılırken uyulacak kısıtlardır.

1. **Reddin eski gerekçesi ("migration + veri dönüşümü yüzeyi") ölçümle çürütüldü.** Veri
   dönüşümü sıfır: `plan_mechanic_values` ve `lta_rates` boş, en büyük tutar 600K TRY,
   deploy edilmiş ortam yok. Bu gerekçe ADR'de kullanılmamalı.
2. **Yerine ölçülmüş iki gerekçe yazılmalı:** (a) üç ayrı tamsayı ölçeği ve karışık-ölçek
   çarpımının tip sistemince yakalanamaması, (b) frontend'in para üzerinde iş hesabı yapması.
3. **57 kolon** (yüzdeler hariç, view hariç) + 11 fiyat/polimorfik kolon = dönüşüm yüzeyi.
   ADR bu sayıyı yazmalı; "birkaç tablo" gibi bir ifade ölçümle çelişir.
4. **2⁵³ sınırı kontrata girmeli.** `bigint` kolon JS `number`'ın temsil edemeyeceği değer
   tutabilir. Tamsayı seçilirse ya sınır (90 trilyon TRY) yazılı bir kısıt olur ya da TS tarafı
   `BigInt` kullanır.
5. **`entered_value` bölme işi her iki yolda da ön koşuldur** — tamsayıya özgü bir ek maliyet
   değildir. ADR bunu tamsayının aleyhine yazmamalı.
6. **`0010`'un `big.js` önerisi performansa dayanmıyordu** (%1–8, belirleyici değil); bu ölçüm
   de tamsayıyı performansla savunmuyor. Performans her iki yolda da karar değişkeni değildir.
7. **Frontend hesap katmanı ayrı bir karar gerektirir** — `PlanningGridEnhanced.tsx`'in
   türetmeleri `CLAUDE.md` §2.3 ile çelişiyor görünüyor. Sayısal kontrat kararından **önce**
   veya **onunla birlikte** çözülmeli; aksi hâlde hangi yol seçilirse seçilsin o dosya
   float'ta kalır.

---

## Açık kalanlar

| # | Ölçülemedi | Neden | Ne gerekli |
|---|---|---|---|
| 1 | Oranların gerçek ondalık derinliği | `lta_rates` **0 satır**, `plan_mechanic_values` **0 satır**, `max_combined_discount_percentage` 6/6 NULL | Wella verisi; S1.5'teki A/B/C seçimi bugün veriye değil tasarıma dayanacak |
| 2 | `entered_value`'nun gerçek değer aralıkları | tablo boş | Aynı |
| 3 | Frontend form girdi alanı sayısı (para) | 125 backend DTO alanından türetildi, frontend tarafında tek tek sayılmadı | Form bileşenlerinin elle taranması |
| 4 | Response interceptor'ın 235 endpoint'te doğru çalışacağı | prototip yapmak kapsam dışıydı | Küçük bir spike; response şekilleri heterojen (entity, ham nesne, iç içe dizi) |
| 5 | `agreements.mechanic_value` polimorfizminin gerçek etkisi | yol yalnız tek noktada ve kodun kendi yorumuna göre tamamlanmamış | KPI bağlam eşlemesi tanımlandığında yeniden ölçülmeli |
| 6 | Karışık-ölçek çarpımının 2⁵³'e ne zaman dayanacağı | gerçek plan ölçeği (SKU sayısı × hacim × fiyat) bilinmiyor | 500 SKU'lu gerçek plan verisiyle üst sınır hesabı |

**Not:** Bu ölçüm de `0010` gibi float hatasının **canlı bir yanlış para tutarı** ürettiğini
göstermedi. Her iki yol da (tamsayı ve `big.js`) bugün kanıtlanmış bir hatayı değil, kayıtlı
bir riski (`INV-N-002`) kapatıyor.
