# 0017 — `max_combined_discount_percentage`: semantik ölçümü (D-15 eksen B)

- **Tarih:** 2026-08-10
- **Task:** [[T-137]] — salt-okunur. Kod / migration / entity / test / seed değişikliği YOK.
- **Mod:** ölçüm + seçenekler. **Karar ürün sahibinin.**
- **İlgili:** `docs/analysis/0016 §1.4` (eksen B) · `SYSTEM_INVARIANTS §9` D-15 · ADR 0007 E8 ·
  ADR 0008 (kapsam uyarısı) · CLAUDE.md §2.3 (hardcoded eşik yasağı)
- **Ölçüm ortamı:** backend `d7b6b76` · dev DB `collmind_tpm`, şema `main`, port 5434 (ayakta) ·
  exit kodları boruya sokulmadı (§2.6)

---

## 0. DUR ve bildir

| Koşul | Durum |
|---|---|
| Kolonun sınırladığı kapsam koddan belirlenemiyor | ❌ tetiklenmedi — **belirlendi**, §1 |
| Üçüncü implementasyon çıkarsa | ⚠️ **kısmen** — per-mekanik tavanın üçüncü implementasyonu **yok**, ama **aynı büyüklüğü sınırlayan üç hardcoded tavan daha** var (§4) |
| BRD'de çelişkili iki madde varsa | ⛔ **BELİRLENEMEDİ** — BRD PDF'i bu ortamda **okunamıyor** (§2). Çelişki de dayanak da ölçülemedi. |

**Ve ölçüm, sorunun kendisini değiştiren bir bulgu üretti:** `0` bir tavan olarak
*"bu FU'da hiç indirim olmasın"* **demiyor**. §1.3'e bak.

---

## 1. Neyin toplamını, hangi kapsamda sınırlıyor?

### 1.1 Kapsam: **FU**, ve tavan bildirildiği mekaniğin değil, **FU'nun tamamının** tavanı

`spend-validation.service.ts`, `validateCombinations(tenantId, planFuId)` — canlı:
`GET /spend-calculation/validate-combinations/:planFuId`, ayrıca
`validate-before-submission/:planId` içinden de çağrılıyor.

Zincir (grep'lenebilir tokenlarla):

```
activeMechanics = planFu.planMechanicValues
                    .filter(readEnteredRaw(...) !== null && numericTextToNumber(v) !== 0)
                    .map(pmv => pmv.mechanic)

her aktif mekanik icin:
  contribution = mechanicType === 'PERCENT'
                   ? rateToPercent(rateFromNumericString(String(entered)))
                   : (pmv.calculatedSpend / totalPlannedGsv) * 100

  ON_INVOICE_DISCOUNT                                   -> totalOnInvoiceDiscount
  OFF_INVOICE_DISCOUNT | PER_UNIT_SUPPORT | LUMPSUM_SPEND -> totalOffInvoiceDiscount

combinedDiscount = totalOnInvoiceDiscount + totalOffInvoiceDiscount
```

Sonra, `// Check max combined discount per mechanic` yorumunun altında:

```
for (const mechanic of activeMechanics)
  if (mechanic.maxCombinedDiscountPercentage !== null && !== undefined)
    if (combinedDiscount > mechanic.maxCombinedDiscountPercentage) -> ERROR
```

**Üç cevap:**

| Soru | Ölçülen cevap |
|---|---|
| Hangi kapsam? | **FU** (`planFuId`). Plan değil, SKU değil. |
| Yalnız o mekaniğin uygulamaları mı? | **Hayır.** `combinedDiscount` o FU'daki **tüm aktif** mekaniklerin toplamı. |
| Kimin tavanı? | Tavan **mekanikte bildirilir**, ama **FU toplamını** sınırlar. |

### 1.2 ⚠️ "discount" adı kapsamı olduğundan dar gösteriyor

Kolonun adı `max_combined_**discount**_percentage`. Ama `totalOffInvoiceDiscount`
akümülatörüne **dört** kategoriden üçü giriyor: `OFF_INVOICE_DISCOUNT`, **`PER_UNIT_SUPPORT`**
ve **`LUMPSUM_SPEND`**.

Yani tavan yalnız indirimleri değil, **birim-başı desteği ve lumpsum harcamayı da** —
GSV yüzdesine çevrilmiş hâlleriyle — sınırlıyor. Ad, sınırladığı şeyi eksik anlatıyor.

### 1.3 ⛔ Toplama kuralı: **en katı tavan bağlar** — ve bu `Math.max` ile zıt

Döngü her aktif mekaniğin tavanını **ayrı ayrı** sınıyor ve her ihlal bir ERROR üretiyor.
Sonuç fiilen **minimum**: en düşük tavan geçerlidir.

İzole koşum (`/tmp/ceiling.js`, `EXIT=0`) — tavanları 20 ve 80 olan iki mekanik, toplam %25:

```
spend-validation  ->  ERROR: "A tavani 20 asildi (25)"        ← en katı bağlar
mechanic.service  ->  Math.max(20, 80) = 80
                      "Total discount should not exceed 80%"  ← en gevşeği duyurur
```

> **Bu, `0`'dan bağımsız bir çelişkidir.** İki implementasyon **her** çoklu-tavan
> senaryosunda farklı sayı söylüyor — sıfır hiç devreye girmeden. `0016 §1.4` yalnız sıfır
> ayrımını kaydetmişti; **asıl fark toplama yönünde.**

---

## 2. BRD dayanağı — **ölçülemedi**, ve bu bir DUR

```bash
grep -n -i "combined|birleşik|max discount|toplam indirim|60%|50%|30%" .cursor/rules.md
# -> HİÇ EŞLEŞME YOK
```

`docs/decisions/` altındaki dokuz ADR'de de per-mekanik birleşik indirim tavanına dair
**hiçbir madde yok** (yalnız ADR 0007 E8 kolonun *ölçeğinden* söz ediyor, *anlamından* değil).

**AMA bu "BRD dayanağı yok" demek DEĞİLDİR.** CLAUDE.md §2.2 açıkça yazıyor:

> *`rules.md` bir noktada sessizse, bu "kural yok" demek değildir — PDF'e bak.*

Ve PDF **bu ortamda okunamıyor**:

| Yol | Sonuç |
|---|---|
| `pdftotext` / `mutool` / `qpdf` | kurulu değil |
| `pypdf` / `PyPDF2` | kurulu değil |
| macOS `Quartz` (PyObjC) | `No module named 'Quartz'` |
| `Read` aracı | `pdftoppm is not installed` |

> ⛔ **DUR.** Soru 2 **cevaplanamadı.** *"Kolon bir BRD dayanağı olmadan var"* iddiası
> **ölçülmemiştir** ve yazılmamalıdır — bu, CLAUDE.md'nin *"koda 'ulaşılamaz' yazmadan önce
> ölç"* kuralının doküman tarafındaki hâli.
>
> Kapatmak için: `brew install poppler` (bir sistem kurulumu — ürün sahibinin onayıyla), ya da
> BRD'nin ilgili sayfasının elle aktarılması.

⚠️ Ve **cevaplanmadan** bir şey daha biliniyor: `MAX_ON_INVOICE_DISCOUNT = 50`,
`MAX_OFF_INVOICE_DISCOUNT = 30`, `MAX_COMBINED_DISCOUNT = 60` — üçü **hardcoded** (§4). Eğer
BRD bu sayıları veriyorsa, kolon onların **tenant-bazlı override**'ı olabilir; vermiyorsa
dördü de dayanaksızdır. **Aynı ölçüm iki soruyu birden cevaplıyor**, ve ikisi de açık.

---

## 3. `0` anlamlı bir konfigürasyon mu?

### 3.1 Yazılabiliyor mu? **EVET — ve bu T-108'den farklı**

| | |
|---|---|
| Yazma ucu | `POST /mechanics` ve `PATCH /mechanics/:id` |
| Yetki | `@Roles(UserRole.ADMIN)` — ikisi de |
| DTO doğrulaması | `@IsNumber() @IsOptional() @Min(0) @Max(100)` |
| `0` kabul ediliyor mu | **EVET** — `@Min(0)`, yani `0` **açıkça izinli** bir girdi |
| `UpdateMechanicDto` | `PartialType(CreateMechanicDto)` → aynı kısıtları devralır |

> [[T-108]]'in vakası (RAG eşikleri) **yazılamıyordu** — controller yoktu. Burada durum
> tersine: **yol var, `0` geçerli, ve hiçbir yerde reddedilmiyor.**

**Ama UI yok:** `maxCombined|max_combined|combinedDiscount` araması frontend'de yalnız
`spend-calculation.endpoints.ts`'in **okuma** tipini buluyor (`combinedDiscount: number`).
Yazan hiçbir form alanı **yok**.

Yani bugün: **API'den yazılabilir, arayüzden yazılamaz.**

### 3.2 ⚠️ `0` ne demek — ölçüldü, ve varsaydığımız şey DEĞİL

Ürün sahibinin senaryosu şuydu: *"`0` yazmak 'bu FU'da hiç indirim olamaz' demek."*
**Ölçüm bunu çürütüyor.**

Tavan yalnız mekanik **aktifse** sınanıyor, ve `activeMechanics` üyeliği girilen değerin
`≠ null` **ve** `≠ 0` olmasını gerektiriyor. İzole koşum (`EXIT=0`):

| senaryo | `combinedDiscount` | sonuç |
|---|---|---|
| **A** — tavanı 0 olan mekanik **kullanılıyor** (%10) | 10 | ⛔ `ERROR: CPP_ON tavani 0 asildi (10)` |
| **B** — tavanı 0 olan mekanik kullanılmıyor (girdi `0`), başkası %10 | 10 | ✅ hata yok |
| **C** — tavanı 0 olan mekanik kullanılmıyor (girdi `null`), başkası %10 | 10 | ✅ hata yok |

**B ve C belirleyici:** tavanı `0` olan mekanik kullanılmadığında tavan **hiç sınanmıyor**,
yani FU'da başka mekaniklerle indirim yapılabiliyor.

Ve A: bir PERCENT mekaniği aktifse katkısı tanımı gereği `≠ 0`, dolayısıyla
`combinedDiscount > 0` **her zaman** doğru. Yani:

> ### `0` tavanı = **"bu mekanik hiç kullanılamaz"**
> "Bu FU'da indirim olamaz" **değil.** Tavan kendi mekaniğini **kilitler**;
> mekanik kullanılmadığında ise hiçbir şeyi sınırlamaz.

Bu, ifade edilmek istenen kısıtın **tersi tarafından** karşılanıyor: mekaniği yasaklamak
istiyorsan `is_active = false` zaten var. `0` tavanı, `is_active`'in dolambaçlı ve
**kendini imha eden** bir kopyasıdır.

⚠️ Tek istisna: PERCENT olmayan bir mekanik, girdisi `≠ 0` ama `calculatedSpend = 0`
(ya da `totalPlannedGsv = 0`) ise katkısı `0` olur ve `0 > 0` yanlıştır → hata çıkmaz.
Yani `0` tavanı **mekanik tipine göre** farklı davranıyor — kendi içinde de tutarsız.

### 3.3 Kullanılmış bir yetenek mi? **Hayır — hiçbir ölçümde dolu görülmedi**

| Ölçüm | Tarih | Sonuç |
|---|---|---|
| `docs/analysis/0010` | 2026-08-03 | 6/6 NULL |
| `docs/analysis/0011` | 2026-08-03 | 6/6 NULL |
| `0016 §7` (bu tur) | 2026-08-10 | **6/6 NULL**, `= 0` olan **hiç yok** |
| `mechanic.seed.ts` | — | `maxCombined` **hiç geçmiyor** — seed değer atamıyor |

Üç ayrı ölçüm, bir hafta arayla, aynı sonuç.

> **Bu, kuralın "çalıştığı sanılan ama girdisi hiç ulaşmayan" sınıfın ta kendisi**
> (CLAUDE.md). İki zıt implementasyon bugüne kadar hiç karşılaşmadı çünkü **hiçbir mekaniğin
> tavanı yok.**

---

## 4. Üçüncü implementasyon? — per-mekanik tavanın **yok**, ama üç hardcoded kardeşi **var**

Arama (dolaylı biçimler dâhil): `maxCombined` · `combinedDiscount` · `|| 100` / `?? 100` ·
`combined` geçen her üretim satırı · `MAX_*_DISCOUNT` / `DISCOUNT_*_LIMIT` desenleri.

**Per-mekanik tavanın üçüncü bir implementasyonu yok.** İki tane var ve ikisi §1.3'te.

**Ama aynı `combinedDiscount` değeri üzerinde üç tavan daha bulundu — üçü de hardcoded:**

```
spend-validation.service.ts
  private readonly MAX_ON_INVOICE_DISCOUNT  = 50;   // Warning threshold
  private readonly MAX_OFF_INVOICE_DISCOUNT = 30;   // Warning threshold
  private readonly MAX_COMBINED_DISCOUNT    = 60;   // Hard limit
```

`MAX_COMBINED_DISCOUNT = 60` **aynı büyüklüğü** sınırlıyor ve severity'si `ERROR` — yani
per-mekanik tavanla **aynı işi** yapıyor, biri konfigüre edilebilir diğeri değil.

> **CLAUDE.md §2.3 ihlali:** *"RAG: hardcoded threshold YASAK; sadece KPI konfigürasyonundan."*
> Kural RAG için yazılmış ama sınıf aynı: bir iş eşiği koda gömülmüş.
> Ve §2.3'ün `BudgetAlertConfiguration` uyarısıyla **aynı şekil**: konfigüre edilebilir bir
> alan var, ama yanında onu gölgeleyen bir sabit duruyor.

### ⚠️ Ve ikinci implementasyon aslında bir **placeholder** — kendi yorumu söylüyor

`mechanic.service.ts`, `checkCombinationValidity` (`POST /mechanics/check-combination`):

```
// Calculate total discount (simplified - in production, calculate from actual values)
// This is a placeholder
```

Bu metot **hiçbir gerçek toplam hesaplamıyor**. Yalnız tavanların `Math.max`'ini alıp bir
uyarı **metni** üretiyor. Yani `|| 100` orada bir politika kararı değil, bir **görüntüleme
varsayılanı**.

Bu, `0016 §1.4`'ün *"iki zıt implementasyon"* çerçevesini **düzeltiyor**: ortada iki yaptırım
yok — **bir yaptırım ve bir tavsiye** var. Ama tavsiye **yanlış**:

| durum | tavsiye ne diyor | yaptırım ne yapıyor |
|---|---|---|
| tavanlar 20 ve 80 | *"should not exceed 80%"* | %25'te **hata** verir |
| tek tavan `0` | `0 \|\| 100` → 100 → **uyarı yok** | mekanik **tamamen kilitli** |

İkinci satır en kötüsü: mümkün olan **en katı** tavan, tavsiye katmanında **hiç
görünmüyor**.

⚠️ Ve bu rotanın **UI tüketicisi yok** (`0016` B10): `check-combination` frontend'de hiç
çağrılmıyor.

---

## 5. Seçenekler ve sonuçları

⚠️ Öneri değil. Ölçüm bir seçeneği **dışlıyorsa** öyle yazıldı.

### Ö1 — `0` bağlayıcı (bugünkü canlı davranış korunur)

- **Ne demek olur:** `0` yazmak = *"bu mekanik hiç kullanılamaz"* (§3.2), *"bu FU'da indirim
  olmasın"* **değil**.
- **Sonuç:** `is_active = false` ile örtüşen ikinci bir kilitleme yolu; ve mekanik tipine göre
  tutarsız (§3.2 istisnası).
- **Temsil kararına etkisi:** transformer/`MoneyMinor` geçişinde `!== null` kontrolü **zaten
  doğru** — `mechanic.service.ts`'in `|| 100`'ü ona yakınsar.
- **⚠️ Ölçümün notu:** bu seçenek, ifade edilmek istenen kısıtı (*"birleşik indirim tavanı"*)
  **karşılamıyor**; kolonun adının vaat ettiği şey `0`'da üretilemiyor.

### Ö2 — `0` → tavansız (`|| 100` semantiği kanonik olur)

- **Ne demek olur:** `0` ile `NULL` aynı anlama gelir; kolon *"tavan var mı"* sorusunu
  yalnız `NULL` ile cevaplar.
- **Sonuç:** bugünkü canlı yaptırım **değişir** — `!== null` kontrolü `!= null && > 0`'a
  döner. Bugün veri boş olduğu için **davranış farkı üretmez** (§3.3).
- **Bedeli:** ADR 0008'in *"girilen değerde `0` ≡ `null`"* kararıyla **aynı yöne** gider, ama
  bu **girilen değer değil, konfigürasyon** — ADR 0008 bunu kapsamıyor, yani gerekçe yeniden
  yazılmalı.
- **⚠️ Ölçümün notu:** `0`'ı sessizce yok saymak, admin'in **kabul edilen** bir girdisinin
  (`@Min(0)`) hiçbir etki üretmemesi demektir — CLAUDE.md §2.5'in "sessiz" ailesinden.

### Ö3 — `0` reddedilsin (`CHECK (col IS NULL OR col > 0)`)

- **Ne demek olur:** kolon yalnız *"pozitif bir tavan"* ya da *"tavan yok"* taşır; `0`
  yazılamaz.
- **Sonuç:** iki implementasyon arasındaki **sıfır** farkı **konusuz** kalır — `|| 100` ile
  `!== null` aynı sonucu verir. §1.3'ün **toplama yönü** çelişkisi **kalır** (bu ayrı bir iş).
- **Bedeli:** bir migration + DTO `@Min(0)` → `@IsPositive()` benzeri; veri **boş** olduğu için
  dönüşüm maliyeti **sıfır** (§3.3).
- **Ve bir ön koşulu var:** "hiç indirim olmasın" gerçekten istenen bir kısıtsa, `0` kaldırılmadan
  önce onu **ifade edecek** bir yol tanımlanmalı — bugün öyle bir yol **yok** (§3.2: `0` onu
  ifade etmiyor).

### Üçünün de dışında kalan, ama üçünü de etkileyen

`MAX_COMBINED_DISCOUNT = 60` hardcoded (§4). Hangi seçenek seçilirse seçilsin, **konfigüre
edilebilir tavanın yanında konfigüre edilemez bir tavan durmaya devam eder** ve pratikte
%60'ın üzerindeki hiçbir tenant tavanı anlam taşımaz.

---

## 6. Ölçülemeyenler

| # | Ölçülemeyen | Neden | Ne gerekli |
|---|---|---|---|
| **1** | **BRD dayanağı ve olası çelişki** (§2) | BRD PDF'i bu ortamda okunamıyor — dört yol da başarısız | `brew install poppler` (sistem kurulumu, onay gerekir) ya da ilgili sayfanın elle aktarılması |
| **2** | 50 / 30 / 60 sabitlerinin kaynağı | aynı — BRD'den mi geliyor, uydurma mı | aynı |
| **3** | Gerçek Wella verisinde tavan kullanımı | `mechanics` 6 satır, 6/6 NULL, seed yazmıyor | müşteri master datası |
| **4** | `POST /mechanics` ile `0` yazıldığında uçtan uca davranış | canlı HTTP koşumu bu turun kapsamı dışı (salt-okunur ölçüm; sunucu ayağa kaldırılmadı) | e2e — [[T-137]]'nin kabul ölçütüne konabilir |

---

## 7. BRD ölçümü — §2'nin DUR'u kapandı (2026-08-10, `poppler` kurulumundan sonra)

`brew install poppler` (ürün sahibi onayı) → `pdftotext -layout` ile üç PDF de metne çevrildi.
Bu **kalıcı bir kapasitedir**: §2.1'in birinci sıra kaynağı bu oturuma kadar **bir kez bile**
okunamamıştı.

⚠️ Ve ilk bulgu, aramanın **hangi belgede** yapıldığının önemli olduğu: ana BRD
(`CollMind_TPM_BRD_v1.0.pdf`) `combined` için **hiç eşleşme vermiyor**. Kural
`TPM_Base_BRD_Code_Prompts.pdf`'te. *"BRD'de yok"* demek, hangi PDF'e bakıldığını yazmadan
anlamsızdır.

### 7.1 Kolonun BRD dayanağı **VAR** — ve `0`'a rol vermiyor

Mekanik yönetimi ekranının mockup'ı:

```
│ Combination Rules:                                    │
│ [✓] Can combine with other on-invoice discounts       │
│ [ ] Maximum combined discount: [____] %               │
```

Aynı belgedeki şema taslağı:

```sql
-- Combination Rules
can_combine_with_others BOOLEAN DEFAULT true,
mutually_exclusive_with JSONB,                -- Array of mechanic codes
max_combined_discount   DECIMAL(15,4),
```

**Üç sonuç, üçü de karara giriyor:**

1. **Tavan bir "onay kutusu + değer" çiftidir.** Kutu işaretsizken tavan **yok**; işaretliyken
   alan bir yüzde taşır. `0`'ın bu tasarımda **hiçbir rolü yok** → **Ö3 doğrulandı.**
2. **"Birleşemez" ayrı bir alanla ifade ediliyor:** `can_combine_with_others BOOLEAN`. Yani
   Ö3'ün ön koşulu olarak sorduğumuz *"hiç indirim olmasın nasıl ifade edilir"* sorusunun
   BRD'de **zaten bir cevabı var** — ve bizde o alan **yok** (§7.3).
3. **`DECIMAL(15,4)`** — bizde `numeric(5,2)`. ADR 0007 **E8**'in (`numeric(9,4)`'e yükselt)
   artık bir BRD dayanağı var; ve BRD ondan da geniş bir ölçek istiyor.

### 7.2 ⚠️ 50 / 30 / 60 sabitleri — BRD ölçümü T-138'i **ağırlaştırdı**

BRD'de indirim tavanı bağlamında bulunan **tek** sayı **30**'dur, ve iki yerde geçiyor:

```
│ ⚠ Note: High combined discount may impact margin │
│   Recommended max: 30%                           │
│   Current: 25% - OK                              │

- Check: Not exceeds max allowed (e.g., 30%) ✓
```

Ve ana BRD'nin kullanıcı hikâyesi:

```
• System shows warning if discount exceeds typical range
```

**Karşılaştırma:**

| kod | değer | severity | BRD karşılığı |
|---|---|---|---|
| `MAX_ON_INVOICE_DISCOUNT` | 50 | WARNING | **yok** |
| `MAX_OFF_INVOICE_DISCOUNT` | 30 | WARNING | 30 var ama **combined ON-invoice** için |
| `MAX_COMBINED_DISCOUNT` | **60** | **ERROR** | **yok** |

Üç fark, üçü de tek yönde:

- **50 ve 60 için BRD'de hiçbir dayanak yok.** (`50%` geçen tüm satırlar iş vakası
  metrikleri — *"50% reduction in time-to-plan"*; `60%` yalnız bir çubuk grafikte.)
- **30 var ama başka bir büyüklüğe bağlı:** BRD onu *combined on-invoice* için söylüyor,
  bizde `MAX_OFF_INVOICE_DISCOUNT`. Aynı sayı, farklı kavram.
- **Dil farkı belirleyici:** BRD *"Recommended max"*, *"e.g., 30%"*, *"shows **warning**"*
  diyor. Bizim `MAX_COMBINED_DISCOUNT` **`severity: ERROR`** — yani **bloklayan** bir kapı.

> **BRD tavsiye yazmış, kod yasak uygulamış — ve sayıyı da uydurmuş.**
> Bu, [[T-138]]'i "hardcode'u konfigürasyona taşı"dan **"eşiğin hem değeri hem sertliği
> BRD'ye aykırı"** hâline getiriyor.

⚠️ Ve BRD'nin *"typical range"* dediği şeyin şemada karşılığı var: `typical_range_min` /
`typical_range_max` / `industry_average` / `company_average`. **Dördü de bizde yok** (§7.3) —
yani BRD'nin **tavsiye** mekanizması hiç yazılmadığı için, tavsiye olması gereken kural bir
**sabit yasak** olarak doğmuş olabilir.

### 7.3 BRD'de olan, bizde olmayan üç alan → [[T-140]]

```bash
grep -rn "canCombine|can_combine|typicalRange|typical_range|industry_average"   collmind.backend/src --include="*.ts"     # → BOŞ
```

| BRD alanı | Bizdeki karşılığı |
|---|---|
| `can_combine_with_others BOOLEAN DEFAULT true` | **YOK** — yalnız `mutuallyExclusiveWith` var, o **ikili** dışlama, blanket değil |
| `typical_range_min` / `typical_range_max` | **YOK** — BRD'nin uyarı mekanizmasının dayanağı |
| `industry_average` / `company_average` | **YOK** (benchmark; kapsam dışı ama kayda geçer) |

Birincisi doğrudan bu kararın konusu: *"bu mekanik başkalarıyla birleşemez"* BRD'de bir
boolean'dır, bizde ifade edilemiyor — ve tam bu boşluk `0`'ın o anlama gelmesi ihtimalini
akla getirmişti.

### 7.4 Ölçülemeyenlerin güncel hâli

| # | Durum |
|---|---|
| 1 — BRD dayanağı ve olası çelişki | ✅ **kapandı** — dayanak var, çelişki yok; BRD `0`'a rol vermiyor |
| 2 — 50/30/60'ın kaynağı | ✅ **kapandı** — 50 ve 60 **dayanaksız**, 30 **başka bir büyüklüğe** ait, ve BRD **tavsiye** diyor |
| 3 — gerçek Wella verisinde tavan kullanımı | ⛔ **açık** — müşteri master datası gerekiyor |
| 4 — `POST /mechanics` ile `0` yazıldığında uçtan uca davranış | ⛔ **açık** — ADR 0009 uygulanırken e2e ile kapanır |
