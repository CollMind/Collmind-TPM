# 0014 — `DecimalTransformer` kapsam ölçümü: kökten çözüm mü?

- **Tarih:** 2026-08-07
- **Task:** [[T-090]] — salt-okunur ölçüm. Kod / migration / entity / test değişikliği YOK.
- **İlgili:** ADR `0007-sayisal-kontrat.md` (Karar 3, F1, E15, E16) · ADR `0008` ·
  `docs/analysis/0010`, `0011`, `0013` · `docs/contracts/SYSTEM_INVARIANTS.md` → `INV-N-002`,
  guard backlog **K9**
- **Kapsam dışı:** uygulama. Bu doküman bir faz önerisi verir, faz uygulamaz.

---

## 0. DUR ve bildir — tetiklenen koşullar

Task üç DUR koşulu tanımladı. **İkisi tetiklendi.**

| Koşul | Durum | Kanıt |
|---|---|---|
| Kusur sayısı **> 10** | ❌ **tetiklenmedi** | 1 kusur bölgesi (2 satır) bulundu — §3. Ama bu sayının *neden* düşük olduğu §3.6'da: bu oturumda beş düzeltme (T-084/085/089/091/093) aynı yüzeyi süpürdü. Düşük artık, kökün dar olduğunun kanıtı **değildir**. |
| Transformer düzeltmesi **mevcut davranışı değiştiriyor** | ✅ **TETİKLENDİ** | Yerinde düzeltilebilir bir hâli yok (§2.3). Mevcut davranışı **spec kilitliyor** (`decimal.transformer.spec.ts:13`) ve **7 canlı çağrı yeri** doğruluk yönünü değiştiriyor (§4.2). |
| Kapsam **tek task'a sığmıyor** | ✅ **TETİKLENDİ** | 71 kolon / 22 entity + 77 ratchet bulgusu + 38 raw-query çağrısı + 7 truthiness-flip + frontend tel-sözleşmesi. §5'te 5 faza bölündü. |

**Bunlardan çıkan tek cümlelik karar önerisi:**
`DecimalTransformer`'ı yaymak **INV-N-002'yi kapatmaz** ve bugünkü hâliyle yayılırsa
**yeni bir kusur sınıfı açar**. ADR 0007 Karar 3'ün zaten reddettiği seçenek budur
(`0007-sayisal-kontrat.md:244-247`); bu ölçüm o reddi **doğruluyor ve genişletiyor**.

---

## 1. Soru 1 — Kapsam

### 1.1 Sayılar

Üretici komut (balanced-paren `@Column(...)` taraması, `.entity.ts` + `.view-entity.ts`):

```
node <scan.js>   # dosya: her @Column/@ViewColumn bloğunda type:'decimal'|'numeric' arar
```

| Ölçüm | Değer |
|---|---|
| `decimal`/`numeric` kolon içeren entity dosyası | **26** |
| Toplam `decimal`/`numeric` kolon | **89** |
| Transformer **beyan eden** kolon | **18** |
| Transformer **beyan etmeyen** kolon | **71** |
| Hiç transformer'ı olmayan entity dosyası | **22** |
| Transformer kullanan entity dosyası | **5** |
| Benzersiz transformer'sız property adı | **62** |

DB tarafı doğrulaması (şema-nitelendirilmiş, port 5434):

```bash
docker exec collmind-tpm-postgres psql -U postgres -d collmind_tpm -Atc \
  "SELECT count(*), count(DISTINCT table_name) FROM information_schema.columns
   WHERE table_schema='main' AND data_type='numeric';"
# → 94|29
```

94 `numeric` kolon / 29 tablo. Entity tarafındaki 89, DB'deki 94'ün alt kümesidir
(view'lar, `migrations` dışı yardımcı tablolar farkı açıklar). Bu doküman **entity**
sayısını normatif alır; transformer yalnız entity hidrasyonunda çalışır (§3.5).

T-090 task metni "22 entity, ~70 kolon" diyordu. Ölçüm: **22 entity dosyası doğru**,
kolon sayısı **71**.

### 1.2 En yoğun dosyalar

```
plan.entity.ts                23 kolon, 0 transformer   ← tek başına kapsamın 1/3'ü
budget-allocation.entity.ts    9 kolon, 9 transformer
agreement.entity.ts            6 kolon, 0 transformer
mechanic.entity.ts             6 kolon, 0 transformer
plan-mechanic-value.entity.ts  6 kolon, 0 transformer
on-invoice-entry.entity.ts     4 kolon, 0 transformer
lta-rate.entity.ts             4 kolon, 0 transformer
```

### 1.3 Ölçek dağılımı — "hepsi para değil"

71 transformer'sız kolonun ölçeği:

| `scale` | Adet | Semantik | ADR 0007'deki karşılığı |
|---|---|---|---|
| 2 | **46** | para (TRY) + bazı yüzdeler | `MoneyMinor` (Karar 3a) |
| 3 | **8** | hacim/adet (`baseVolume`, `quantity`, `minimumVolumeCommitment`) | **karar yok** |
| 4 | **17** | oran/fiyat (`enteredRatePct`, `minValue`, `unitPrice`, `gpRoi`, `ragGreenThreshold`) | `RateBps` (Karar 5) — ama `unitPrice`/`cogs` fiyattır, oran değil |

**Bu tek başına "hepsine aynı transformer" fikrini bitirir.** `moneyFromNumericString`
(`src/common/numeric/money.ts:73-79`) kuruş-altı kesir gördüğünde **fırlatır** — yani
scale-3 ve scale-4 kolonlar (25 adet, %35) bir para transformer'ından geçemez. Üç ayrı
temsil kararı gerekiyor ve **ikisi henüz alınmamış** (hacim ölçeği için hiç karar yok;
`unitPrice`/`cogs` fiyat mı para mı sorusu açık) → §2.4 **DUR**.

### 1.4 Transformer'lı 5 entity — neden onlar? **Tarihsel tesadüf.**

```bash
git log --diff-filter=A --format="%ad %h %s" --date=iso -- src/database/transformers/
git log -S"DecimalTransformer" --format="%ad %h %s" --date=iso -- <her entity>
```

| Commit | Saat | Task | Eklenen entity'ler |
|---|---|---|---|
| `dd7eaaf` | 2026-07-27 **19:14** | T-020 — sales-actuals **portu** | transformer'ın kendisi + `sales-actual`, `sales-actual-batch` |
| `cc7e309` | 2026-07-27 **21:50** | T-026 — planning-first akışını açan **bugfix** | `budget-envelope`, `budget-allocation`, `budget-summary.view` |

- Aynı gün, **2 saat 36 dakika arayla**, iki farklı sebeple.
- `git log -- src/database/transformers/` **başka commit döndürmüyor**: dosya
  2026-07-27'den beri (10 gün) hiç değişmedi.
- `cc7e309`'un mesajı sebebi açıkça yazıyor: *"D-2: Decimal kolonlar string dönüyordu →
  `'500000.00' >= '8187.00'` LEXICOGRAFIK false → geçerli onaylar 'Insufficient budget'
  ile reddediliyordu."*

**Ortak özellik yok. Ortak olay var:** bu beş entity, o gün bir testi kıran okuma yolunda
duruyordu. Seçim kriteri "para taşıyor" değil, "kırıldığı görüldü"dür. `plan.entity.ts`
(23 para kolonu) ve `plan_mechanic_values` (6 kolon) en az onlar kadar para taşır ve
kapsam dışında kaldı — çünkü o gün kırılmadılar.

Yani T-026'nın D-2'si ile bu oturumun T-084 / T-085 / T-089 / T-091 / T-093'ü
**aynı kusurun aynı sınıfı**dır; arada 9 gün ve 5 tekrar var. Kalıbın kendisi
CLAUDE.md §7.1'in konusudur: *"kardeş yol etkilenmiyor" iddiası ölçülmeden yazıldı.*

---

## 2. Soru 2 — `DecimalTransformer` hâlâ bozuk mu? **Evet.**

### 2.1 Kaynak (okundu, doğrulandı)

`collmind.backend/src/database/transformers/decimal.transformer.ts:8-15`

```ts
export const DecimalTransformer: ValueTransformer = {
  to:   (value?: number | null) => value,
  from: (value?: string | null) => {
    if (value === null || value === undefined) return value;
    const num = Number(value);                      // ← ADR 0007 F1
    return Number.isNaN(num) ? null : num;          // ← §2.5 sessiz null
  },
};
```

**ADR 0007 F1 bulgusu bugün de geçerlidir.** İki ayrı kusur var, karıştırılmamalı:

- **F1 (temsil):** `Number(value)` tam ondalık metni IEEE-754'e sokar. ADR 0007
  `:244-247` bunu zaten ölçmüş ve *"uygulanması INV-N-002 üzerinde **sıfır etki** yapar,
  yalnız kaybı merkezileştirir"* diye reddetmiş. **Bu ölçüm o reddi doğrular.**
- **Yeni bulgu — sessiz null (§2.5):** ayrıştırılamayan bir girdi `null` döner,
  fırlatmaz. Finansal bir yolda çözülemeyen girdi → açık hata; kural CLAUDE.md §2.5.
  Bu, F1'den **bağımsız** ve **yerinde düzeltilebilir** tek kusurdur.

### 2.2 Spec çalıştırıldı (exit kodu boruya sokulmadı, §2.6)

```bash
npx jest src/database/transformers/decimal.transformer.spec.ts > /tmp/spec.log 2>&1; echo "EXIT=$?"
# EXIT=0 · Test Suites: 1 passed · Tests: 7 passed
```

7 test yeşil. Ama testlerin **ne kilitlediği** kritik:

- `decimal.transformer.spec.ts:13` → `expect(from('99.99')).toBe(99.99)` — **float
  dönüşünü sözleşme hâline getiriyor.**
- `decimal.transformer.spec.ts:17` → `expect(from('not-a-number')).toBeNull()` —
  **sessiz null'ı sözleşme hâline getiriyor.**

Yani her iki kusur da **teste bağlanmış** durumda. Düzeltme = bu iki testi değiştirmek =
tanım gereği davranış değişikliği. **DUR koşulu 2 burada tetikleniyor.**

### 2.3 Düzeltme ne gerektirir? — **Yerinde düzeltilemez**

Üç seçenek var, ikisi elenir:

| Seçenek | Sonuç |
|---|---|
| **(a)** Transformer'ı kaldır, string'e dön | T-026 D-2'yi geri getirir: `'500000.00' >= '8187.00'` → false. **Regresyon.** |
| **(b)** `number` dönmeye devam et ama "tam" ol | **İmkânsız.** `number` IEEE-754'tür; `numeric(18,2)`'nin üst ucu 2⁵³ (≈9.0×10¹⁵) sınırını aşar. 46 scale-2 kolonun 33'ü `numeric(18,2)`'dir. |
| **(c)** `MoneyMinor` dön (`moneyFromNumericString` çağırarak) | **Tek tutarlı seçenek** — ve bu artık "transformer'ı düzeltmek" değil, **ADR 0007 Karar 3'ün temsil migrasyonunu o kolon için yapmak**tır. Entity property tipi `number` → `MoneyMinor` olur, **her okuyucu değişir.** |

**Mimari sonuç:** "önce transformer'ı düzelt, sonra yay" diye bir sıra **yoktur**, çünkü
(c) zaten yayılımın kendisidir. Transformer bağımsız bir bileşen değil, ADR 0007 Karar
3'ün entity-sınırındaki yüzüdür.

### 2.4 Bugünkü 5 entity'nin okuyucuları gerçekten `number` bekliyor mu? **Evet, yazılı olarak.**

`collmind.backend/src/modules/shared/budget/budget-allocation.service.ts:491-528` — T-091'in
bıraktığı yorum bunu normatif olarak beyan ediyor:

> *"`allocation.*` carry a DecimalTransformer and arrive as NUMBERS. `reservation.*`
> (budget_transaction_logs) carry none and arrive as STRINGS."*

ve hemen ardından `allocation.onInvoiceReserved -= committedOnInvoice` (`:523-526`) —
`number` aritmetiği. `(c)` seçeneği bu satırları da değiştirir.

---

## 3. Soru 3 — Kaç kusur daha var?

### 3.1 Tarama yöntemi (kusurun **tanımından** türetildi, örneklerden değil)

Kusur tanımı: *transformer'sız bir `decimal` kolondan gelen değer (runtime'da `string`,
TS'te `number`), string ve number için **semantiği farklı** bir işleme giriyor.*

Semantiği farklı olan işlemler:

| Sınıf | String'de ne olur |
|---|---|
| `+` / `+=` | **birleştirme** (`0 + "100.00"` = `"0100.00"`) |
| `<` `>` `<=` `>=` **iki taraf da string ise** | **sözlüksel** (`"5.0000" < "10.0000"` = false) |
| `Number.isInteger(x)` / `typeof x === 'number'` | **her zaman false** |
| `x !== 0` / `x === 0` | **her zaman true / false** |
| **truthiness** (`if (x)`, `x ? :`, `x \|\| d`) | `"0.00"` **truthy**, `0` falsy → §4.2 |

Semantiği **aynı** olan (elenir): `-` `*` `/` `%`, ve **bir tarafı gerçek sayı olan**
`<` `>` karşılaştırmaları — JS sayısal coerce eder.

Uygulanan §7.1 disiplini:
- **dosya bazlı** tarandı (property adı geçen her `.ts`, `.spec.ts` hariç),
- kalıbın **iki ucu** arandı (okuma tarafı **ve** `+=`/atama yazma tarafı),
- **dolaylı biçim** dâhil — yerel değişken takibi: `const x = pmv.field;` sonrası `x`
  kullanımları alias olarak izlendi (T-093'ün kaçırdığı biçim),
- normalize edici çağrılar (`Number(`, `parseFloat`, `numericTextToNumber`, `boundOf`,
  `spendOf`, `moneyFrom*`, `rateFrom*`) **elemede** kullanıldı, aramada değil.

**Ham aday: 88 satır / 22 dosya.** Normalize edicileri düşünce **58 kalıntı**; elle
triyaj sonrası **1 kusur bölgesi**.

### 3.2 ✅ Onaylanan kusur — 1 bölge, 2 satır

**`collmind.backend/src/modules/shared/spend-calculation/spend-calculation.service.ts:1066-1077`**

```ts
const entered = readEnteredRaw(pmv, mechanic);                    // → string
if (mechanic.minValue !== null && entered < mechanic.minValue) {  // string < string
if (mechanic.maxValue !== null && entered > mechanic.maxValue) {  // string > string
```

- **Kalıp:** sözlüksel karşılaştırma, **iki taraf da string**.
- `readEnteredRaw` (`src/common/numeric/mechanic-input.ts:341-346`) kolonu **ham**
  döndürür: `return pmv[enteredColumnFor(mechanic)]` — `enteredRatePct` (`numeric(9,4)`,
  transformer'sız). Dönüş tipi `number | null | undefined` yazıyor; runtime `string`.
- `mechanic.minValue` / `maxValue`: `mechanic.entity.ts:89,98`, `numeric(18,4)`,
  transformer'sız.
- **Bu, T-085'in düzelttiği kusurun birebir aynısıdır** — kardeş dosyada. T-085
  `spend-validation.service.ts:176-198`'i `numericTextToNumber` ile düzeltti;
  `spend-calculation.service.ts`'teki eşi **taranmadı**. CLAUDE.md §7.1'in T-084 satırı
  ("kardeş karşılaştırmalar güvenli" iddiası) yedinci kez doğrulanmış oluyor.
- **⚠️ CANLI ÇAĞRI YOLU: YOK.**
  ```bash
  grep -rn "validateSpendCalculations" src --include="*.ts" | grep -v "\.spec\."
  # → tek satır: tanımın kendisi (spend-calculation.service.ts:1042)
  ```
  Sıfır çağıran. HTTP route yok, zamanlanmış iş yok, event yok. CLAUDE.md §4.2'ye göre
  bu **`blocked-unreachable`** sınıfıdır: kusur gerçektir, ürün etkisi bugün **sıfırdır**,
  ve bağlandığı gün sessizce yanlış olur.
- **Öneri:** T-085 ile aynı düzeltme (`numericTextToNumber` iki tarafta) + ölü kodun
  bağlanması/silinmesi ayrı bir ürün sorusu (§2.4 — sormadan silinmez).

### 3.3 ❌ Elenen — ve **neden** elendiği (tarama kapsamının kanıtı)

| Yer | Kalıp göründü | Neden kusur DEĞİL |
|---|---|---|
| `finance-reporting.service.ts:320-335, 421, 556-560, 626, 864-866` (11 nokta) | `+=` biriktirme | **T-091/T-093 düzeltti.** Hepsi `spendOf(...)` üzerinden geçiyor → number |
| `spend-validation.service.ts:176-198, 263-270` | sözlüksel `<`/`>`, `!== 0` | **T-085 düzeltti** — `numericTextToNumber` iki tarafta |
| `spend-validation.service.ts:335-368` | `+=` biriktirme | **T-093 düzeltti** — tek `contribution` noktası, `rateFromNumericString` |
| `mechanic.service.ts:148, 278` | `createMin >= createMax` | **T-084 düzeltti** — `boundOf()` iki tarafta |
| `budget-allocation.service.ts:517-586` | `+=` / `-=` | **T-091 düzeltti** — `moneyFromNumericString(String(...))` tek dönüşüm |
| `budget.service.ts:1584` | `summary.reservedAmount + summary.consumedAmount` | `BudgetSummaryView`'ın **beş** para kolonu transformer taşıyor (`budget-summary.view-entity.ts:136,145,148,151,154`) → number + number |
| `plan.service.ts:1935` | `if (plan.totalSpend > 0)` | **bir taraf gerçek sayı** (`0`) → JS sayısal coerce eder. `"0.00" > 0` = false, `"5.00" > 0` = true. Doğru — ama kırılgan |
| `spend-validation.service.ts:407` | `combinedDiscount > mechanic.maxCombined...` | sol taraf hesaplanmış **number** → sayısal coerce |
| `lta-agreement.service.ts:473-476` | `rate.onInvoicePercentage + rate.offInvoicePercentage` | operand **DTO**, entity değil. `create-lta-agreement.dto.ts:49,58` `@IsNumber()`; global pipe `main.ts:32-36` `transform:true, forbidNonWhitelisted:true` → string gövde 400 alır |
| `on-invoice-validation.service.ts:223-273, 379-399, 502` | `+=`, `<=` | operand `row.dto.*`; `create-on-invoice-entry.dto.ts:35-50` `@IsNumber()` |
| `customer.service.ts:454, 463` | `dto.annualRevenue < 0` | DTO |
| `dashboard.service.ts:482, 649` | `ag.consumedAmount > 0` | **SQL dizesi** (`andWhere`) → karşılaştırma Postgres'te, JS'te değil |
| `budget-allocation.service.ts:788` | `tx.onInvoiceAmount + tx.offInvoiceAmount` | **SQL dizesi** (`orderBy`) |
| `spend-distribution.service.ts:142-317, 578-583` | `sum + dist.amount` | `amount` üretimi `:305` `Number(b.calculatedAmount) \|\| 0` ve `:532` hesaplanmış → number |
| `spend-calculation.service.ts:955, 986`; `plan.service.ts:2411` | `sum + b.base.totalSpend` | `SpendBreakdown` `:635-668`'de yerel number'lardan kuruluyor |
| `common/numeric/allocation.ts:154` | `s + r.amount` | `MoneyMinor` (branded integer) |
| `lta-calculation.service.ts:45-49, 120-124` | `planSku.baseVolume \|\| 0` sonra `*` | tek işlem `*` → sayısal coerce. **Ama §4.3'e bak: tel-sözleşme kusuru var** |
| `lta-agreement.service.ts:431-441` → `lta-calculation.service.ts:76,81,151,157`; `spend-calculation.service.ts:196,198,506,507` | `finalOnInvoicePct` (string) | tüm tüketiciler `*` ve `/` → sayısal coerce. **Latent:** bu yolda tek bir `+` kusur üretir |
| `agreement.service.ts:1290` `tacticsContext['MECHANIC_VAL'] = agreement.mechanicValue` | string, `Record<string, number>`'a | **KPI motoru sınırda coerce ediyor:** `formula-parser.service.ts:169` ve `:211` → `const value = Number(context[dep])`. Kusur değil — ama §4.2'ye bak |
| `seeds/test-happy-path.ts:342, 351, 497, 566` | `+`, `<=` | seed script; canlı çağrı yolu yok |
| kalan ~40 satır | `Number(...)` / `parseFloat(...)` sarmalı | zaten normalize |

**`Number.isInteger(string)` ve `!== 0` kalıpları için sonuç: sıfır hit.**

```bash
grep -rnE "Number\.isInteger\(\s*[\w.$]*\.(<62 prop>)\b" src --include="*.ts" | grep -v "\.spec\."   # boş
grep -rnE "\.(<62 prop>)\s*[!=]==\s*-?[0-9]"           src --include="*.ts" | grep -v "\.spec\."   # boş
```

### 3.4 Yazma ucu (§7.1 — kalıbın iki ucu)

```bash
grep -rnE "\.(<62 prop>)\s*\+=" src --include="*.ts" | grep -v "\.spec\."
```

5 hit: `on-invoice-validation.service.ts:393,395,399` · `spend-distribution.service.ts:579` ·
`finance-reporting.service.ts:421`. **Hepsi ad çakışması** — sol taraf bir entity kolonu
değil, düz nesne alanı (`discountDistribution.cppOnInvoice.amount`). Sağ taraflar sırasıyla
DTO number, hesaplanmış `difference`, `spendOf()`. Kusur yok.

```bash
grep -rnE "\.(<62 prop>)\s*=\s*[^=].*\+" src --include="*.ts" | grep -v "\.spec\."   # boş
```

Bir entity `decimal` kolonuna `+` içeren bir ifade **hiç** atanmıyor.

### 3.5 ⚠️ Transformer'ın **hiç ulaşamadığı** yüzey — raw query

Bu, T-090'ın sorduğu sorunun dışında ama cevabını değiştiriyor.

TypeORM `ValueTransformer`, **yalnız entity hidrasyonunda** çalışır.
`getRawOne()` / `getRawMany()` / `.query()` sonuçlarına **uygulanmaz**.

```bash
grep -rnE "getRawOne|getRawMany|\.query\(" src --include="*.ts" | grep -v "\.spec\.\|migrations/" | wc -l   # 38
grep -rnE "SUM\(|AVG\("                    src --include="*.ts" | grep -v "\.spec\.\|migrations/" | wc -l   # 21
```

**38 raw çağrısı / 7 repository**, 21 SQL toplama ifadesi. Örnek
(`ledger.repository.ts:115-123`, `INV-N-002`'nin kanıt satırı):

```ts
.select(`COALESCE(SUM(CASE WHEN ... THEN ledger.amount ELSE 0 END), 0)` + ` - COALESCE(SUM(...), 0)`, 'total')
.getRawOne();
return parseFloat(result.total) || 0;     // ← float + SESSİZ SIFIR (§2.5)
```

Aynısı `agreement-transaction.repository.ts:115-120`.

**Sonuç:** kusursuz bir transformer bile bu 38 noktayı kapatmaz. "Transformer = kökten
çözüm" önermesi **ölçümle yanlışlanmıştır**; transformer entity yüzeyinin bir kısmını
kapatır, ledger/toplama yüzeyinin **hiçbirini** kapatmaz. Kök çözüm ADR 0007 Karar 3'tür
(temsil), transformer değil.

### 3.6 Neden sadece 1 kusur? — sonucu sorgula (§7.1)

Beklenenden düşük bir sayı çıktı; §7.1 bunun için *"sonucun BAŞKA bir açıklaması var mı?"*
diye sormayı zorunlu kılıyor. Var, ve belirleyici:

**Bu ölçüm, aynı yüzeyi süpüren beş düzeltmenin hemen ardından yapıldı** — T-084, T-085,
T-089, T-091, T-093, hepsi son günlerde. §3.3 tablosundaki elemelerin **çoğu bu beş
task'ın eseri**, kodun doğuştan sağlamlığı değil.

Dolayısıyla **"1" bir taban değil, bir artıktır.** Doğru okuma:

- Kalan tekil kusur **1**'dir (ve o da erişilemez kodda).
- Kalan **latent** yüzey büyüktür: 71 kolon hâlâ tipi hakkında yalan söylüyor
  (`number` yazıyor, `string` dönüyor), 77 ratchet bulgusu bu yalanı elle telafi ediyor,
  ve bu telafinin unutulduğu her yeni satır altıncı kusuru üretir.
- Kanıt: bugüne kadar **altı** ayrı task (T-026 D-2 dâhil) tam olarak bunu üretti.

---

## 4. Soru 4 — Yayılım: bir kolona transformer eklemek kimi etkiler?

### 4.1 Bugün string bekleyen kod var mı? — **5 nokta, hepsi hayatta kalır**

```bash
grep -rnE "\.(<62 prop>)\b\s*\.(split|substring|startsWith|replace|match|length|trim|padStart)" src --include="*.ts" | grep -v "\.spec\."
# → BOŞ. Hiçbir yerde entity decimal alanı üzerinde doğrudan string metodu çağrılmıyor.

grep -rnE "String\(\s*[A-Za-z_$][\w$.]*\.(<62 prop>)\b" src --include="*.ts" | grep -v "\.spec\."
```

| Dosya:satır | Kod | Transformer eklenirse |
|---|---|---|
| `budget-allocation.service.ts:517,520,583,586` | `moneyFromNumericString(String(reservation.onInvoiceAmount))` | **Çalışmaya devam eder ama garantisini kaybeder** — bkz. aşağıdaki uyarı |
| `spend-validation.service.ts:483` | `moneyFromNumericString(String(pmv.calculatedSpend))` | aynı |

> ⚠️ **Bu, yayılımın en ince ve en tehlikeli sonucudur.**
> `moneyFromNumericString` (`money.ts:64-83`) tam da *IEEE-754'ten geçmemek için*
> rakam-rakam ayrıştırır (`money.ts:61-62`: *"Parsed digit-wise rather than via `Number()`
> — the whole point is not to route an exact decimal string through IEEE-754 on the way
> in"*). Bugün ona DB'nin **tam metni** gidiyor.
> Bugünkü `DecimalTransformer` `budget_transaction_logs`'a uygulanırsa, ona giden şey
> `String(Number("100.00"))` olur — yani **float round-trip'inden geçmiş** bir metin.
> T-091'in kurduğu tam-ayrıştırma savunması, kaynağında etkisiz hâle gelir.
> Scale-2 ve 2⁵³ altındaki değerler için sonuç aynı çıkar; **üst uçta ve scale-4'te
> çıkmaz.** Bu, ADR 0007'nin *"kaybı merkezileştirmek"* dediği şeyin somut hâlidir.

### 4.2 ⚠️ Truthiness dönmesi — **7 canlı nokta doğruluk yönü değiştirir**

Bu, T-090'ın dört kalıbında **olmayan** beşinci kalıp ve yayılımın asıl bedeli.
`"0.0000"` **truthy**, `0` **falsy**.

```bash
grep -rnE "(if\s*\(\s*[\w.$]*\.(<62 prop>)\s*\)|[\w.$]+\.(<62 prop>)\s*\?[^?.]|[\w.$]+\.(<62 prop>)\s*(\|\||&&))" \
  src --include="*.ts" | grep -v "\.spec\." | grep -vE "!==|!=|===|=="    # 38 satır, elle triyaj → 7 flip
```

| # | Dosya:satır | Bugün | Transformer eklenince |
|---|---|---|---|
| 1 | `finance-reporting.service.ts:427` `if (planFu.gpRoi)` | `"0.0000"` truthy → sıfır ROI **sayılır** | `0` falsy → **sayılmaz**; `roiCount` düşer, **ortalama ROI değişir** |
| 2 | `plan.service.ts:2806` `plan.overallRoi ? Number(...) : null` | 0 → `0` | 0 → **`null`** |
| 3 | `plan.service.ts:2885` `planFu.gpRoi ? Number(...) : null` | 0 → `0` | 0 → **`null`** |
| 4 | `approval-workflow.service.ts:916` `plan.overallRoi ? Number(...) : undefined` | 0 → `0` | 0 → **`undefined`** |
| 5 | `mechanic.service.ts:605` `m.maxCombinedDiscountPercentage \|\| 100` | `"0.00"` → `"0.00"` (tavan 0) | `0` → **`100`** (tavan 100) |
| 6 | `agreement.service.ts:1287-1290` `if (agreement.mechanicValue)` | `"0.0000"` truthy → `MECHANIC_VAL` context'e girer | `0` falsy → **anahtar hiç girmez** → `formula-parser.service.ts:161` bağımlılık eksik → KPI **`null`** |
| 7 | `plan.service.ts:774-776` `dto.plannedVolume && planSku.baseVolume` | `"0.000"` truthy | `0` falsy → farklı dala düşer |

**Yedisi de aynı yöne kayıyor: "tam sıfır" ile "değer yok" ayırt edilemez hâle geliyor.**

ADR 0008 (`0008-girilen-degerde-null-sifir-ayrimi-yoktur.md`) bu ayrımı **girilen değer**
için kaldırdı. Buradaki 7 noktanın **hiçbiri girilen değer değil**: `gpRoi`, `overallRoi`
hesaplanmış KPI; `maxCombinedDiscountPercentage` bir kural tavanı; `mechanicValue` bir
anlaşma parametresi. **ADR 0008 bunları kapsamıyor** → §2.4 **DUR**: "sıfır ROI, ROI
yokluğu mudur?" sorusu ürün sahibinin kararıdır, ajanın varsayımı değil.

`agreement.service.ts:1287` ayrıca §7 ihlali sinyali taşıyor: **7 satır yukarıda**
(`:1280`) aynı context için `if (typeof value === 'number')` filtresi var. Yazar
context'in sayısal olması gerektiğini biliyordu ve `mechanicValue` o filtreyi atlıyor.
Bugün zararsız çünkü motor `formula-parser.service.ts:169`'da `Number()` ile coerce
ediyor — yani kodu **başkasının savunması** kurtarıyor.

### 4.3 Tel-sözleşme (API) etkisi — frontend'e taşar

Controller'ların çoğu **ham entity** döndürüyor:

```bash
grep -rnE "return (this\.)?\w+Service\.(findOne|findAll|find)\b" src --include="*.controller.ts"
# mechanic, lta-agreement, plan, agreement, agreement-transaction, ledger, tenant, user, ...
```

Yani bugün JSON'da `totalSpend: "8187.00"` (**string**) gidiyor. Transformer eklenirse
`totalSpend: 8187` (**number**) olur — **breaking change**.

Frontend zaten bu belirsizliğin farkında:

- `collmind.frontend/src/api/endpoints/plans.endpoints.ts:40` ve `:63` →
  `totalSpend: number | string;` — tip **her ikisini** kabul ediyor.
- Buna karşılık `finance-reporting.endpoints.ts:101,102,125,143,154` → `totalSpend: number`
  (bugün yanlış, transformer'dan sonra doğru olur).
- 32 coerce noktası: `grep -rnE "(parseFloat|Number)\(\s*\w+\.(totalSpend|capTotalAmount|...)" src | wc -l` → **32**

İki nokta gerçek string metodu kullanıyor, ama **ikisi de `typeof` korumalı** → hayatta kalır:

- `PlansPage.tsx:94-96` → `typeof p.totalSpend === 'string' ? parseFloat(p.totalSpend.replace(/,/g,'')) : Number(p.totalSpend)`
- `AgreementApprovalsPage.tsx:158-160` → aynı kalıp

(Yan bulgu, kapsam dışı: her ikisi de `isNaN(x) ? 0 : x` yapıyor — frontend'de §2.5
sessiz sıfır. Ayrı task konusu; bu doküman onu düzeltmiyor, kaydediyor.)

Ve `lta-agreement.controller.ts:174-206` (`POST /lta-agreements/calculate/base-spend`,
`.../planned-spend`) `lta-calculation.service.ts:88-92`'nin döndürdüğü nesneyi doğrudan
yayınlıyor; `baseVolume` ve `listPrice` alanları DTO'da `number` yazıp **string**
gidiyor. Hesap doğru (`*` coerce ediyor), **sözleşme yanlış**.

### 4.4 Ratchet nasıl oynar? — **taban %47'ye kadar düşebilir, ve bu tehlikeli**

Ölçüm (exit kodu boruya sokulmadı, §2.6):

```bash
bash scripts/guards/money-float.sh --ratchet > /tmp/ratchet.log 2>&1; echo "EXIT=$?"   # EXIT=0
bash scripts/guards/money-float.sh --baseline | grep "^# total"                        # 163 findings in 24 files
diff <(grep -v '^#' scripts/guards/money-float-baseline.txt) <(...)                     # fark yok
```

Taban **163 bulgu / 24 dosya**, bugün birebir tutuyor.

Bunların kaçı transformer eklenince **gereksizleşir**?

```bash
GUARD_MODE=report bash scripts/guards/money-float.sh > /tmp/findings.txt 2>&1
grep "^  > " /tmp/findings.txt | grep -cE "(Number|parseFloat)\(\s*[A-Za-z_$][\w$.]*\.(<62 prop>)\b"
# → 77
```

**163 bulgunun 77'si (%47)**, doğrudan transformer'sız bir kolona uygulanan
`Number(...)` / `parseFloat(...)` çağrısıdır. Örnekler:
`Number(plan.totalSpend)` (×8), `Number(planSku.baseVolume) || 0` (×5),
`Number(tx.amount)` (×5), `Number(agreement.capTotalAmount)` (×3).

**K9 kapsamında doğan soru — ve cevabı olumsuz:**

```bash
grep -n "transformer\|entities\|database" scripts/guards/money-float-domain-a.txt   # BOŞ
```

`src/database/transformers/` ve `src/database/entities/` **Alan A listesinde değil**.
Sonuç: 77 `Number()` çağrısı silinip dönüşüm `decimal.transformer.ts`'e taşınırsa
**taban 163 → 86'ya düşer, ama tek bir float dönüşümü ortadan kalkmaz.** Dedektör
oraya bakmıyor.

Bu, `mechanic.service.ts:76-90`'ın yazılı olarak reddettiği hamlenin **77 kat büyüğüdür**:

> *"`plan.service.ts:119` (`Number(raw)`) o dosyanın 36 ratchet bulgusundan biri. Fonksiyonu
> dışarı taşımak onu 35'e düşürür — ama hiçbir şey düzelmedi. Ratchet, hiç olmamış bir
> geri ödemeyi kaydeder."*

Ve `src/common/numeric/` vakasından **daha kötüdür**: ADR 0007 E15 o dizini muaf tutarken
gerekçesi *"daha güçlü bir enstrümanla korunuyor — F1'in 17 property-based testi"*ydi.
`src/database/transformers/` için böyle bir enstrüman **yok**: tek koruma
`decimal.transformer.spec.ts`'in 7 testi, ve o testler §2.2'de gösterildiği gibi
**kusurun kendisini kilitliyor**.

**Somut öneri (K9'a bağlanmalı):** transformer yayılımına *başlamadan önce*
`src/database/transformers/` Alan A üyelik testinden geçirilmeli. Test
(`scripts/guards/money-float-domain-a.txt` kuralı): *"bir modül para üretiyor, para
kalıcılaştırıyor veya parayı bir eşikle karşılaştırıyorsa Alan A'dadır."* Transformer
**parayı entity sınırında maddeleştirir** → Alan A'dadır. Listeye eklenmesi tek satırlık
bir değişikliktir ve tabanı bugünden +1 artırır (transformer'ın kendi `Number(value)`'su).
Bu yapılmadan yayılım, ratchet'i **77 bulguluk sahte bir geri ödemeyle** kör eder.

---

## 5. Soru 5 — Sıra: önce düzelt mi, önce yay mı?

### 5.1 Bağımsız değiller — ve "önce düzelt" diye bir seçenek yok

§2.3'te ölçüldü: transformer'ı düzeltmenin tek tutarlı hâli `MoneyMinor` döndürmektir, o
da tanım gereği **her okuyucuyu değiştirir**. Yani:

- "Önce transformer'ı düzelt, sonra yay" → **imkânsız**; düzeltme zaten yayılımdır.
- "Önce bugünkü hâliyle yay, sonra düzelt" → **yasak**; ADR 0007 `:244-247`'nin reddettiği
  takas (string sorununu float sorunuyla değiştirmek) + §4.4'ün 77 bulguluk sahte geri
  ödemesi + §4.1'in T-091 savunmasını etkisizleştirmesi.

Geriye tek tutarlı sıra kalıyor: **kolon kolon temsil migrasyonu** (ADR 0007 Karar 3),
transformer da o migrasyonun entity-sınırındaki aracı olarak yazılıyor.

### 5.2 Ama bağımsız olan **bir** parça var

`decimal.transformer.ts:13`'ün **sessiz null**'u (§2.1), F1'den bağımsızdır ve yerinde
düzeltilebilir: `Number.isNaN(num)` → `null` yerine **fırlat** (CLAUDE.md §2.5).
Bugün transformer'lı 18 kolonda bozuk bir metin sessizce `null` oluyor. Bu değişiklik
mutlu yolu hiç etkilemez; yalnız `decimal.transformer.spec.ts:17`'i değiştirir.

### 5.3 Önerilen fazlar — ölçüme dayalı, tahmine değil

| Faz | İş | Neden bu sırada | Boyut | Tek task mı? |
|---|---|---|---|---|
| **F0** | `src/database/transformers/` → `money-float-domain-a.txt`; taban +1 ile yenilenir | §4.4: bu yapılmadan sonraki her faz ratchet'i kör eder. **Ön koşul.** | XS | evet |
| **F1** | `decimal.transformer.ts` sessiz null → `throw` (+ spec) | §5.2: F1'den bağımsız, §2.5 ihlali, geri dönüşsüz risk yok | XS | evet |
| **F2** | `spend-calculation.service.ts:1066-1077` sözlüksel karşılaştırma → `numericTextToNumber`; ölü kod kararı sorulur | §3.2: bugün bilinen **tek** kusur. Erişilemez olması onu ucuzlatır, silmez | S | evet |
| **F3** | **DUR — ürün sahibine sorulur.** Üç soru: (a) "tam sıfır KPI = KPI yok mu?" (§4.2, 7 nokta) · (b) scale-3 hacim kolonlarının temsili (8 kolon, karar yok) · (c) `unitPrice`/`cogs` para mı fiyat mı (§1.3) | §2.4: BRD yorumu ürün sahibinin kararıdır. **F4 bu cevaplar olmadan yazılamaz** | — | karar, task değil |
| **F4** | Temsil migrasyonu, **scale-2 para kolonlarından** başlayarak (46 kolon), ADR 0007 Karar 3 uyarınca. Modül modül: `budget_transaction_logs` → `agreements` → `plan_mechanic_values` → `plan` | En büyük yüzey; F3'ün üç cevabına bağlı; her adım tel-sözleşmesini kırar (§4.3) → frontend eşzamanlı | XL | **hayır — en az 4 task** |
| **F5** | Raw-query yüzeyi: 38 çağrı / 7 repository, `parseFloat(x) \|\| 0` sessiz sıfırları dâhil | §3.5: transformer buraya **hiç** ulaşmıyor; ayrı ve bağımsız iş | L | hayır — en az 2 task |

**Kademeli mi, hepsi birden mi?** Kademeli — ama **kolon kolon değil, tablo tablo**.
Gerekçe ölçümde: bir tablonun kolonları aynı okuyucu tarafından birlikte okunur
(`budget-allocation.service.ts:517-526` dört alanı bir arada kullanır); yarısı `MoneyMinor`
yarısı `string` olan bir tablo, T-091'in düzelttiği asimetrinin **tam olarak aynısını**
üretir.

**Hangi tablo önce?** Canlı rota **ve** yazma yolu olan: `budget_transaction_logs`
(plan-onay yolunda diske yazılıyor — T-091 kanıtı), sonra `agreements`
(`capTotalAmount` CAP sınırı — `INV-N-002`'nin kanonik vakası), sonra
`plan_mechanic_values`, en son `plan` (23 kolon).

**`plan.entity.ts` ayrı task mı olmalı?** **Evet** — 23 kolon, kapsamın %32'si, ve üç
farklı ölçek (2/3/4) taşıyor, yani F3'ün her üç cevabına da bağımlı. En sona konmalı.

---

## 6. Mimari karar

**⚠️ KOŞULLU — F0/F1/F2 onaylı, F4 bloke.**

| | |
|---|---|
| ✅ **Uygun** | **F0** (Alan A üyeliği), **F1** (sessiz null → throw), **F2** (bilinen kusur) — üçü de küçük, bağımsız, geri alınabilir ve ölçülmüş bir kusuru kapatıyor |
| ❌ **Uyumsuz** | **`DecimalTransformer`'ı bugünkü hâliyle 71 kolona yaymak.** ADR 0007 `:244-247` bunu zaten reddetti; bu ölçüm reddi üç yeni kanıtla güçlendiriyor: (1) T-091'in tam-ayrıştırma savunmasını kaynağında etkisizleştirir (§4.1), (2) 7 canlı noktada "sıfır = yok" davranış değişikliği üretir (§4.2), (3) ratchet'e 77 bulguluk sahte geri ödeme yazdırır (§4.4) |
| ⛔ **Bloke** | **F4** — §2.4 gereği F3'ün üç ürün kararı alınmadan başlatılamaz |

**Modül & bağımlılık etkisi:**
`src/database/{transformers,entities}` (bugün Alan A dışı) → `shared/{budget,
spend-calculation}`, `modes/planning-first/plan`, `modes/actuals-first/{agreement,
agreement-transaction,ledger,on-invoice}`, `shared/lta` → `shared/{finance-reporting,
kpi-engine,dashboard}` (Alan B) → **frontend tel-sözleşmesi**. Bağımlılık yönü doğru
(entity → servis → controller); sorun yönde değil, **entity katmanının tip beyanının
runtime ile uyuşmamasında** — 71 kolon `number` diyor, `string` dönüyor. Bu, katman
sınırında bir **sözleşme ihlali**dir ve her tüketiciye sızar.

**BRD ihlali riskleri:**
- **KPI dinamikliği:** `agreement.service.ts:1290` KPI context'ine string sokuyor;
  bugün yalnız `formula-parser.service.ts:169`'un savunmacı `Number()`'ı kurtarıyor.
  Formül Admin-tanımlı olduğu için hangi formülün `MECHANIC_VAL`'i nasıl kullandığı
  **koda bakılarak bilinemez** — savunma tek noktada ve tesadüfi.
- **RAG eşikleri:** `kpi.entity.ts:101,110` (`ragGreenThreshold`, `ragAmberThreshold`,
  `numeric(18,4)`) transformer'sız. `plan.service.ts:2860` civarı
  `Number(gpRoiKpi.ragGreenThreshold)` ile telafi ediyor. Telafinin unutulduğu bir
  karşılaştırma sözlüksel olur ve **RAG rengi sessizce yanlış** çıkar — BRD'nin
  "threshold asla hardcode, KPI config'ten" kuralı korunur ama sonucu bozulur.
- **Audit:** etkilenmiyor (immutable log yolu bu yüzeyden geçmiyor).
- **Multi-tenant:** etkilenmiyor; hiçbir bulgu tenant filtresine dokunmuyor.
- **NFR-1.2 (<500 ms):** transformer entity başına O(kolon) ek iş getirir; `plan` +
  `planFus` + `planSkus` + `planMechanicValues` ağır okumalarında ölçülmelidir.
  **Bu doküman ölçmedi** — F4'ün kabul ölçütüne konmalı, varsayılmamalı.

---

## 7. §7 kontrolü — "bu yeteneğin mevcut implementasyonu var mı?"

**Arandı.** Terimler: `DecimalTransformer`, `ValueTransformer`, `transformer:`,
`numericTextToNumber`, `boundOf`, `spendOf`, `rawOf`, `moneyFromNumericString`,
`rateFromNumericString`, `toNullableNumber`, `parseFloat`, `Number(`.

Bulunan mevcut implementasyonlar — **yeni bir dönüştürücü yazılmamalı**:

| Yetenek | Mevcut yer |
|---|---|
| Tam ondalık metin → para | `src/common/numeric/money.ts:64` `moneyFromNumericString` |
| Tam ondalık metin → oran | `src/common/numeric/` `rateFromNumericString` |
| Mekanik girdisi okuma (semantik kolon seçimi) | `src/common/numeric/mechanic-input.ts:341` `readEnteredRaw` / `:317` `readEnteredValue` |
| Min/max sınır normalizasyonu | `mechanic.service.ts` içinden çağrılan `boundOf` |
| Spend normalizasyonu | `finance-reporting.service.ts` içinden çağrılan `spendOf` |
| Frontend sayı normalizasyonu | `collmind.frontend/src/utils/numberUtils.ts:5` `toNumber` |
| Entity sınırı dönüşümü | `src/database/transformers/decimal.transformer.ts` (**bozuk**, §2) |

**Bilinen tekrar (kapatılmadı, bilinçli):** `numericTextToNumber` (`mechanic-input.ts:135`)
ile `toNullableNumber` (`plan.service.ts`) semantik olarak aynı — `mechanic.service.ts:76-90`
bunu belgeliyor ve birleştirmemenin gerekçesini veriyor (ratchet'e sahte geri ödeme
yazdırmamak). §4.4 aynı gerekçenin 77 katını gösteriyor.

**Çapraz repo uyarısı:** TTM'de aynı kavramın farklı adlanabileceği unutulmamalı
(`capTotalAmount` ↔ `capAmount`). Bu ölçüm **yalnız CTPM** üzerinde yapıldı; TTM'de bir
transformer karşılığı olup olmadığı **aranmadı** ve bu bir eksiktir.

---

## 8. Ölçüm dürüstlüğü notları

- Tüm exit kodları dosyaya yönlendirilerek okundu, boruya sokulmadı (CLAUDE.md §2.6).
  `money-float.sh --ratchet` → `EXIT=0`; `jest decimal.transformer.spec.ts` → `EXIT=0`.
- DB sorgusu şema-nitelendirildi (`table_schema='main'`), port 5434 (CLAUDE.md §1).
- Ölçek dağılımını üreten ilk (tembel-regex) script `decimalPlaces`'i yanlışlıkla saydı;
  `kpi.entity.ts:82`'nin `type: 'int'` olduğu doğrulanıp düzeltildi. Normatif sayı
  balanced-paren taramasından gelir: **71 = 46 + 8 + 17**.
- §3'ün "1 kusur" sonucu §3.6'da sorgulandı: sayı doğru, **çıkarım "kök dardır" değildir**.
- Ölçülmeyenler, açıkça: (a) transformer'ın recalc süresine etkisi (NFR-1.2),
  (b) TTM'de karşılık gelen mekanizma, (c) `.spec.ts` dosyalarındaki kalıplar
  (üretim yolu yok, kapsam dışı bırakıldı).
