# 0013 — Sayısal kontrat: kolon bölünmesi, oran ölçeği, markalı tipler (tasarım)

- **Tarih:** 2026-08-04 · **Yazan:** architect · **Revizyon:** r2 (ürün sahibi kararları işlendi)
- **Kapsam:** **yalnızca tasarım.** Bu turda üretim kodu, migration, entity veya test
  yazılmadı/değiştirilmedi. Belgedeki diff'ler **örnektir**, dosyaya uygulanmamıştır.
- **Karar (tartışma değil):** `docs/decisions/0007-sayisal-kontrat.md` **v3 + §Errata (2026-08-03)** —
  Adım 1–3 (Karar 4, Karar 5, markalı tipler + yardımcılar)
- **Kanıt tabanı:** `docs/analysis/0010` · `0011` · `0012`
- **Ölçüm ortamı:** backend SHA `0b6518e` (çalışma ağacı **temiz**), frontend SHA `5cf0bd2`,
  dev DB `collmind-tpm-postgres` (port 5434, şema `main`), TypeScript **5.9.3**, ESLint 8.57.1
- **Tahsis edilen migration numaraları:** `1796000000000` (F2), `1797000000000` (F3)
  (`.claude/backlog/MIGRATION_SEQUENCE.md`; son kullanılan `1795000000000`)

> **Yöntem kuralı (uyuldu):** her iddia ya `dosya:satır` ya canlı SQL ya da koşturulmuş
> derleyici/linter çıktısıyla kanıtlanmıştır. "Muhtemelen böyle" cümlesi yok.

### r1 → r2 değişim özeti

r1 sekiz düzeltme önerdi; ürün sahibi hepsini **errata olarak kabul etti** (E1–E8) ve sekiz
kapsam kararı verdi (A3–A10). Bu revizyon onları işler. Değişenler:

| Alan | r1 | r2 |
|---|---|---|
| Errata | önerildi (§7/A1) | **ADR'ye eklendi** — E1–E8 bağlayıcı |
| JSONB kapsamı | "K1: kapsam JSONB'yi içerir" (yöntem belirsiz) | **§1.5'te açık seçim: (J1)** — JSONB şekli korunur, semantik tek noktada pinlenir |
| Yuvarlama | half-up, negatifte **hata fırlat** (K7 askıda) | **half-away-from-zero** (E7); negatif **geçerli**, hata yok |
| `RateMicro` | öneri | **karara bağlandı** (E3) |
| `max_combined_discount_percentage` | §7/A3 onay bekliyor | **Karar 5 kapsamında** (E8) |
| `mechanics.decimal_places` (K11) | doğrulama eklensin | **[[T-071]]'e devredildi** (A5) — kontrata bağlanmaz |
| A10 kanonik seçim | açık soru | **⛔ ASKIDA** — kararın dayandığı olgu çürüdü (aşağıda). Ürün sahibi **2026-08-04'te kararı resmen geri çekti** → ADR errata **E9**; çağıran envanterine bağlandı → **[[T-075]]** |
| Bağlayıcı koşul | K1–K11 | **K1–K14** (K7/K11 değişti, K12–K14 eklendi) |
| Faz sayısı | 4 | **4 (değişmedi)** — J1 seçimi F2'yi büyütmedi |

---

## Karar: ⚠️ KOŞULLU ONAY — bir ürün sahibi kararı (A10) askıya alındı

Adım 1–3 uygulanabilir. Errata sonrası ADR ile tasarım **hizalı**. Yedi kapsam kararı (A3–A9)
uygulandı. **Bir karar uygulanamadı ve DUR edildi.**

### ⛔ A10 askıda — kararın dayandığı olgu ölçümle çürüdü

Karar: *kanonik = `spend-calculation.service.ts:893-907`, çünkü **exception fırlatıyor**;
`spend-validation` yalnız `ValidationError` dönüp çağıranın kontrol etmemesine izin veriyor.*

Ölçüm bunu doğrulamıyor — **her iki taraf da dönüş değeri veriyor, hiçbiri fırlatmıyor:**

```ts
// spend-calculation.service.ts:874-918  — SEÇİLEN "kanonik"
async validateSpendCalculations(...): Promise<ValidationResult> {
  const errors: string[] = [];
  ...
  errors.push(`Mechanic ${mechanic.code} value ... is below minimum ...`);   // :899
  ...
  return { isValid: errors.length === 0, errors, warnings };                  // :914-918
}
```

| | `spend-calculation.service.ts:874-918` (seçilen) | `spend-validation.service.ts:49-182` (reddedilen) |
|---|---|---|
| Exception fırlatıyor mu | **HAYIR** — `errors.push(string)` + dönüş | hayır — `errors.push(ValidationError)` + dönüş |
| Üretim çağıranı | **YOK** — yalnız kendi spec'i (`spend-calculation.service.spec.ts:871`) | **4 canlı HTTP endpoint** (`spend-calculation.controller.ts:112-167`: `validate-inputs`, `validate-combinations`, `validate-budget`, `validate-before-submission`) |
| Hata bilgisi | `string[]` | yapılandırılmış `ValidationError` — `severity`, `category`, `field`, `fuId`, `skuId`, `suggestion` (`validation-result.dto.ts:26-60`) |

Kararın **her iki gerekçesi de tersine dönüyor:** seçilen taraf exception fırlatmıyor **ve ölü
kod**; reddedilen taraf canlı **ve** daha zengin. Gerekçe (2) — *"kanonik olan parayı üreten
olmalı"* — dosya konumu bakımından doğru, ama seçilen metot para **üretmiyor**; yalnız sınır
doğruluyor ve hiçbir yerden çağrılmıyor.

**Sonuç:** kararı kendi başıma tersine çeviremem. **F2'de iki implementasyon birleştirilmez,
üçüncü kopya yazılmaz** (K14). Kanoniklik kararı, çağıran envanteri (yukarıdaki tablo bir
başlangıçtır) ile birlikte ayrı bir turda verilir.

### STOP durumu (r1'den değişmedi)

| STOP | Durum |
|---|---|
| 1 — kardeş kolonlar zorunlu + yüzey > 150 | **tetiklenmedi** — kardeşler zorunlu **değil** (§1.2 ispatı); yüzey **125** |
| 2 — markalı tip kaçağı kapatılamıyor | **tetiklenmedi** — ESLint seçicisi 3/3 cast biçimini yakaladı, 0 yanlış pozitif |
| 3 — `entered_value` tabloları dolu | **tetiklenmedi** — `plan_mechanic_values`=0, `lta_rates`=0, `lta_plan_overrides`=0, `plans`=0, `plan_fus`=0, `plan_skus`=0 |
| 4 — oran ölçeği beklenmeyen tabloyu etkiliyor | **kapandı** — `max_combined_discount_percentage` ürün sahibi tarafından Karar 5 kapsamına alındı (E8) |

---

## Bağlayıcı koşullar

Her biri test edilebilir; faz kabul kriterlerine birebir girer.
**Değişenler r2'de işaretli.**

**K1 — Kapsam JSONB'yi içerir; yöntem (J1)'dir.** ⟨r2: yöntem netleşti⟩
Karar 4 uygulaması `plan_mechanic_values.entered_value` **ve** `plan_fus.tactics` **ve**
`buildMechanicValues`'ın dönüş tipini birlikte kapsar. **JSONB'nin şekli değişmez**
(`Record<string, number>` kalır); semantik `buildMechanicValues`'ta mekanik satırından çözülür
ve oradan **ayrımlı birlik** olarak çıkar (§1.5). Kanıt testi: `updateFuTactic` ile bir
`percentage` ve bir `currency` mekaniği girilen FU'da her ikisinin de doğru semantikle
hesaplandığını gösteren e2e. Yalnız kolonu bölen bir PR **reddedilir**.

**K2 — Semantik ayrımı DB zorlar, kod değil.**
`plan_mechanic_values` üzerinde `CHECK`: üç değer kolonundan **en çok biri** NOT NULL.
Kanıt testi: iki kolonu birden dolduran `INSERT` DB tarafından reddedilir.

**K3 — Aritmetik sonucun düz `number`'a kaçtığı her yuva markalanır.** ⟨errata E1⟩
Yeni modüllerde para/oran taşıyan hiçbir **entity kolonu, DTO alanı, repository metod
parametresi veya dönüş tipi** `number` olamaz. Kanıt testi: derleme (TS2322). Bu koşul
karşılanmazsa markanın **tek** gerçek kapısı (atama) da açılır ve Karar 8.1 fiilen çöker.

**K4 — `as MoneyMinor` / `as PriceMinor` / `as RateMicro` yalnız fabrika dosyasında serbesttir.**
ESLint `no-restricted-syntax` + `.eslintrc.js` `overrides` istisnası. Kanıt testi: fabrika
dışında `n as MoneyMinor` yazıldığında `npm run lint` hata verir. Aynı desen guard'da da taranır
(lint `--fix` modunda koşuyor; Done kapısı `npm run guards`).

**K5 — Aritmetik yalnız yardımcıdan geçer; ham operatör markalı operandda yasaktır.** ⟨errata E1⟩
`money-float.sh` yeni modüllerde markalı tipli değişkenler üzerinde `*` `/` `+` `-` desenlerini
bulgu sayar. Gerekçe: derleyici bunu **yakalamıyor** (ölçüldü).

**K6 — Yuvarlama tek fonksiyondan ve yalnız kalıcılaştırma anında.**
Transformer `to` ucu **yuvarlamaz**; `MoneyMinor` tamsayı değilse **hata fırlatır**. Sessiz
yuvarlama, sessiz-sıfır yasağının aynı sınıfıdır.

**K7 — Yuvarlama modu: half-away-from-zero.** ⟨r2: DEĞİŞTİ — errata E7⟩
~~Negatif kararlaştırılmadan yardımcı kalıcılaşmaz; negatifte hata fırlatır.~~
Yeni hâli: **`|round(x)| = round(|x|)`**, işaret simetrik. **Negatif girdi geçerlidir ve hata
fırlatılmaz.** Kanıt testleri: `round(2.5) === 3` · `round(-2.5) === -3` · property:
`∀x. round(-x) === -round(x)`. Ayrıca **regresyon testi:** yardımcı `Math.round`'a delege
etmemelidir (`Math.round(-2.5) === -2`, +∞'a yuvarlar).

**K8 — İsim ile ölçek birbirini yansıtır.** ⟨errata E3⟩
`RateBps` kullanılmaz. Kanonik ad **`RateMicro`**: `%3,25` → `32500` = `numeric(9,4)` `3.2500`
= 325 baz puan. Marka anahtarı `__scale: 'rate'` değişmez.

**K9 — Mevcut 54 Alan A dosyası bu fazlarda tam aritmetiğe dönüştürülmez.**
`spend-calculation.service.ts`, `spend-distribution.service.ts`, `spend-validation.service.ts`
**yapısal olarak** dokunulur (union tipi okuma), float ondalık aritmetikleri **korunur**.
Kanıt: bu üç dosyada `money-float.sh` bulgu sayısı **artmamalı** (taban F0'da kaydedilir).

**K10 — Her faz sonunda `npm run guards` yeşil ve tam test takımı geçer.**
Hedef **631 unit / 239 e2e**; faz kabulünde **koşum çıktısı** esas alınır, ezberden yazılmaz.

**K11 — `mechanics.decimal_places` bu fazlarda kontrata BAĞLANMAZ.** ⟨r2: DEĞİŞTİ — A5⟩
~~`decimal_places ≤ kolon ölçeği` doğrulaması eklenir.~~
A5 uyarınca `decimal_places` (6/6 NULL), `calculation_formula`, `0012` R3/R4 ile **aynı sınıftır**
ve [[T-071]]'e devredilmiştir. F2/F3 bu alanı **okumaz, doğrulamaz, kontrata dahil etmez** —
"ara durum en kötüsü" gerekçesi burada da geçerlidir: yarım bir doğrulama, alanın çalıştığı
izlenimini verir. Kanıt: F2/F3 diff'inde `decimalPlaces` geçmez.

**K12 — 2⁵³ hata mesajı eşiği ve ADR atfını taşır.** ⟨r2: YENİ — A9 / errata E4⟩
`applyRate`/`applyRateExact` sınır kontrolü aşımda fırlatırken mesaj **hem 50.000.000 TRY
eşiğini hem "ADR 0007 E4/A9" atfını** içerir. Kanıt testi: eşik aşan bir çağrının hata mesajı
her iki dizgiyi de içerir (`toMatch`).

**K13 — `agreements.mechanic_value` dondurulur.** ⟨r2: YENİ — A4⟩
Silinmez, tamamlanmaz, **ölçek kontratına dahil edilmez**. Entity alanına JSDoc:
*"Kullanılmıyor (3/3 NULL). Yazılmadan önce ADR 0007 ölçek kontratına bağlanmalıdır."*
Kanıt: F2/F3 diff'inde `mechanicValue` yalnız yorum satırı olarak geçer.

**K14 — A10 askıda: iki sınır doğrulaması F2'de birleştirilmez.** ⟨r2: YENİ⟩
`spend-validation.service.ts:142-166` ve `spend-calculation.service.ts:893-907` **ikisi de
korunur**; üçüncü kopya yazılmaz. İkisi de ayrımlı birliği okuyacak şekilde uyarlanır, davranışları
**değişmez**. Kanıt: F2 sonrası `spend-calculation.controller.ts`'in 4 endpoint'inin response
şekli aynı kalır (e2e sözleşme testi).

---

## 1. Kolon bölünmesi (ADR Karar 4)

### 1.1 S1.1 — Şema seçenekleri ve seçim

Değerlendirilen dört seçenek (üç istendi; (a) iki varyantta değerlendirildi çünkü E3 ikisini
ayırıyor).

| | (a1) İki kolon | **(a2) Üç kolon — SEÇİLDİ** | (b) Tek kolon + semantik kolonu | (c) Tablo bölünmesi |
|---|---|---|---|---|
| Şema | `entered_rate_pct numeric(9,4)`, `entered_amount numeric(18,4)` | `entered_rate_pct numeric(9,4)`, `entered_unit_amount numeric(18,4)`, `entered_total_amount numeric(18,2)` | `entered_value numeric(18,4)` + `value_semantic enum` | `plan_mechanic_rates` / `plan_mechanic_amounts` |
| DB zorlaması | `CHECK` tam biri dolu ✅ | `CHECK` tam biri dolu ✅ | `CHECK` yalnız enum'un dolu olduğunu zorlar; **değerin ölçeğini zorlamaz** ❌ | FK + ayrı tablo ✅✅ |
| Ölçek DB tipinde görünür mü | kısmen — para yarısı iki ölçek taşır (E3) ⚠️ | **evet, üçü de** ✅ | hayır ❌ | evet ✅ |
| Değişen dosya | ~10 | **~10** | ~12 (enum + her okuma noktasında switch) | ~16 (+2 entity, +2 repository, +join'ler) |
| Markalı tiple eşleşme | 1 kolon → 2 tip (belirsiz) ⚠️ | **1 kolon → 1 tip** ✅ | 1 kolon → 3 tip, çalışma zamanı dallanması ❌ | 1 tablo → 1 tip ✅ |
| Geri alınabilirlik | tablo boş → `down` üç kolonu birleştirir, kayıpsız | **aynı** | kolayca geri alınır ama zaten çözmüyor | `down` iki tabloyu birleştirir; FK/index bakımı daha ağır |
| Ekstra maliyet | — | +1 kolon (boş tabloda) | — | +1 tablo, +1 unique index, `planMechanicValues` ilişkisi ikiye ayrılır |

**Seçim: (a2), üç kolon.**

Gerekçe sırasıyla:
1. **(b) elenmiştir çünkü sorunu çözmüyor.** Bugün zaten beş ayrı ayırıcı var ve **birbirinden
   farklı yerlerde kullanılıyorlar** — ölçüldü:
   - `mechanics.category` → `spend-calculation.service.ts:132` switch
   - `mechanics.input_type` → `spend-validation.service.ts:74,96,116`
   - `mechanics.mechanic_type` → `spend-distribution.service.ts:425-431`, `spend-validation.service.ts:259,274`
   - `plan_mechanic_values.distribution_method` → `spend-distribution.service.ts:412`
   - `agreements.mechanic_type` → `agreements.mechanic_value` için (veride 3/3 NULL)

   Altıncı bir ayırıcı kolonu eklemek altıncı bir ihtilaf kaynağı ekler. (b) ayrıca ADR Karar
   4'ün gerekçe cümlesiyle doğrudan çelişir: *"markalı tip de tek kolona bağlanamaz."*
2. **(c) elenmiştir çünkü fiyat/fayda dengesi yok.** Tablo bölünmesi (a2)'nin verdiği tüm
   garantileri veriyor ama iki entity, iki repository yolu ve `PlanFu` ilişkisinin ikiye
   ayrılmasını gerektiriyor. `plan_mechanic_values` üzerinde `@Index(['planFuId','mechanicId'], {unique:true})`
   var (`plan-mechanic-value.entity.ts:21`); iki tabloda bu "aynı mekanik iki tabloda birden"
   ihlalini **artık zorlayamaz** — yani (c) DB zorlamasını bir yerde kazanıp başka yerde kaybeder.
3. **(a1) yerine (a2)** çünkü E3: `PER_UNIT_SUPPORT` bir birim fiyattır. Kanıt:
   `spend-calculation.service.ts:224` `return enteredValue * plannedVolume;` — çarpanın diğer ucu
   hacim, yani bu bir **fiyat**tır; `skus.unit_price` `numeric(18,4)`, `on_invoice_entries.list_price`
   `numeric(18,4)`. `LUMPSUM_SPEND` ise doğrudan tutardır (`spend-distribution.service.ts:176`
   `totalSpend: enteredValue`) ve `calculated_spend` zaten `numeric(18,2)`. İki ölçeği tek kolona
   koymak Karar 4'ün çözdüğü sorunun küçük ölçeklisini geri getirir.

**Önerilen şema (migration `1796000000000`):**

```sql
ALTER TABLE main.plan_mechanic_values
  ADD COLUMN entered_rate_pct      numeric(9,4),   -- yüzde notasyonu, 0–100
  ADD COLUMN entered_unit_amount   numeric(18,4),  -- TRY / birim  (PER_UNIT_SUPPORT)
  ADD COLUMN entered_total_amount  numeric(18,2),  -- TRY toplam   (LUMPSUM_SPEND)
  DROP COLUMN entered_value;

ALTER TABLE main.plan_mechanic_values
  ADD CONSTRAINT chk_pmv_exactly_one_entered CHECK (
    (entered_rate_pct     IS NOT NULL)::int
  + (entered_unit_amount  IS NOT NULL)::int
  + (entered_total_amount IS NOT NULL)::int
    <= 1
  ),
  ADD CONSTRAINT chk_pmv_rate_range CHECK (
    entered_rate_pct IS NULL OR (entered_rate_pct >= 0 AND entered_rate_pct <= 100)
  );
```

> `<= 1`, `= 1` değil: bugün `spend-distribution.service.ts:87-97` değer girilmemiş bir
> `PlanMechanicValue` satırını `enteredValue: 0` ile **yaratıyor**. "Hiç değer girilmemiş"
> durumu meşru bir durumdur (satır var, girdi yok) ve `= 1` onu yazılamaz kılardı. `0` ile
> `NULL` arasındaki ayrım korunuyor — sessiz-sıfır yasağının şema karşılığı.

`DROP COLUMN` güvenli: tablo **0 satır** (§1.3). `down()` üç kolonu düşürüp `entered_value`'yu
geri ekler; veri kaybı yok çünkü veri yok.

### 1.2 S1.2 ⟨kapsam riski⟩ — Kardeş kolonlar bölünmek ZORUNDA DEĞİL. İspat.

Bu, kapsamı beşe katlayabilecek soru. Ölçtüm; cevap **hayır** ve gerekçesi tek cümleye iniyor:
**sınır değerleri hiçbir zaman aritmetik operand değildir; yalnız karşılaştırma operandıdır ve
her karşılaştırma, semantiğin zaten sabitlendiği bir dal içindedir.**

`min_value` / `max_value` toplam **52 referans / 7 dosya**. Sınıflandırma (tamamı okundu):

| Sınıf | Konum | Sayı | Bölme gerektirir mi |
|---|---|---|---|
| **Çapraz-semantik karşılaştırma** (`entered` ile) | `spend-validation.service.ts:143,156` · `spend-calculation.service.ts:896,904` | **4** | hayır — dal semantiği zaten `input_type`/`category` ile sabit |
| Aynı-kolon karşılaştırma (`min >= max`) | `mechanic.service.ts:63,187` | 2 | **hayır** — ölçekten bağımsız, her iki operand aynı kolondan |
| Bildirim (entity/DTO/seed) | `mechanic.entity.ts:90-105` · `create-mechanic.dto.ts:94-101` · `mechanic.seed.ts:83-84,110-209,300-301` | 20 | hayır |
| Salt taşıma (response payload'a kopyalama) | `agreement.service.ts:1182-1183,1259-1260` | 4 | hayır |
| Hata mesajı içinde string interpolasyonu | `spend-validation.service.ts:147,150,160,163` · `spend-calculation.service.ts:899,907` | 6 | hayır |
| Diğer (jsdoc, tip bildirimi) | — | 16 | hayır |

Dört karşılaştırma noktasının **dördü de** semantiğin bilindiği bir dalın içinde:

```ts
// spend-validation.service.ts:74  → burada input_type zaten okunmuş
if (mechanic.inputType === 'percentage') { ... }        // dal: ORAN
...
// :143 — aynı döngüde, aynı pmv için
if (enteredValue < mechanic.minValue) { ... }           // karşılaştırma
```

Yani bir sınır değerinin birimi **hiçbir zaman bağımsız bir ayırıcı gerektirmez**: onu sınırlayan
değerin birimi neyse odur, ve o birim artık **hangi kolonun dolu olduğuyla** belirlidir. Tek
ölçek dönüşümüyle karşılaştırma korunur.

**`default_value` ve `step_increment` daha da net: hiçbir tüketicileri yok.**
Toplam 8 referans, tamamı bildirim (`mechanic.entity.ts:128-144`, `create-mechanic.dto.ts:106-111`).
Hiçbir hesap, hiçbir doğrulama, hiçbir karşılaştırma okumuyor — grep boş döndü. Bugün
**yazma-yalnız konfigürasyon**durlar; yanlış sayı üretemezler.

> **Karşı-argüman ve neden reddedildi:** "Kolon polimorfik kalıyorsa yanlış okunabilir." Doğru
> ama sınır değeri için sonuç farklı: yanlış okunmuş bir sınır **yanlış bir uyarı** üretir, yanlış
> bir **para tutarı** üretmez. ADR Karar 1 Alan A'yı "para üreten her şey" diye tanımlıyor; bir
> min/max karşılaştırması para üretmez. Bölmenin faydası, 52 referanslık yüzeye ve STOP#1'i
> tetikleyecek toplam maliyete değmiyor.

**Yerine gelen bağlayıcı tasarım:** dönüşüm dört ayrı yerde yapılmaz. `buildMechanicValues`
genişletilerek **tek çözümleme noktası** olur ve değer ile sınırları **birlikte, markalı** döner
(§1.4). Böylece dört karşılaştırma noktası **bire** iner.

**`agreements.mechanic_value` — ayrıca izlendi, kapsam DIŞI.** Tam tüketim yolu:

```
agreements.mechanic_value  numeric(18,4)   (veride 3/3 NULL)
  ↓ agreement.service.ts:1287-1291
tacticsContext['MECHANIC_VAL'] = agreement.mechanicValue
  ↓ agreement.service.ts:1295-1307
kpiEngine.calculateFu(tenantId, skuResults /* MOCK: BASE_VOL 1000, PLAN_VOL 1100 */, tacticsContext)
```

Üç ölçülmüş olgu: (1) kolon 3/3 NULL; (2) ayırıcısı `agreements.mechanic_type` de 3/3 NULL;
(3) tek tüketicisi **Alan B**'ye (KPI motoru) gidiyor ve girdisi kodda **mock**
(`agreement.service.ts:1295` `// Mock SKU results for now`). Kodun kendi yorumu yolu
tamamlanmamış ilan ediyor (`:1288-1289`). ADR Karar 1 uyarınca Alan B girdisi markalanmaz.
**A4 kararı: DONDURULUR** — silinmez, tamamlanmaz, **ölçek kontratına dahil edilmez** (K13).
Entity alanına JSDoc: *"Kullanılmıyor (3/3 NULL). Yazılmadan önce ADR 0007 ölçek kontratına
bağlanmalıdır."* Gerekçe: tamamlanmamış bir yolun kolonu ölçek kararı için yeterli bilgi
taşımıyor; yol tamamlandığında karar zaten verilmiş olacak.

### 1.3 S1.3 — Tablo doluluğu, `db:reset`, seed

Canlı ölçüm (`docker exec collmind-tpm-postgres psql -U postgres -d collmind_tpm`):

```
 plan_mechanic_values        |     0
 lta_rates                   |     0
 lta_plan_overrides          |     0
 plans                       |     0
 mechanics                   |     6
 agreements                  |     3
 budget_alert_configurations |     3
```

STOP#3 **doğrulandı, tetiklenmedi.** Veri dönüşümü fiilen sıfır; `up()` içine backfill
yazılmaz (yazılırsa üretim verisi üzerinde tanımsız davranır — `0008` §4 / T-047 dersi).

> ⚠️ **Olgu düzeltmesi:** `package.json`'da **`db:reset` diye bir script YOK.** Mevcut olanlar:
> `seed:cleanup` (`cleanup-data.ts`), `seed:cleanup-and-seed` (`cleanup-and-seed.ts`),
> `seed`, `migration:run`. Faz doğrulaması bu adları kullanmalı; `db:reset` bir konuşma dili
> kısaltmasıdır ve kabul kriterine yazılırsa çalıştırılamaz.

**Seed etkisi — ölçüldü, dar:** `mechanic.seed.ts` **9 referans** taşıyor ve hiçbiri
`entered_value` **değeri** yazmıyor; hepsi `calculationFormula` **metni** içinde geçen
`entered_value` **token**'ı (`:114,133,153,174,192,212`) ve `minValue/maxValue` bildirimleri
(`:110-111,129-130,149-150,171,189,209`). Etkilenen mekanik satırı: **6**. Etkilenen
`plan_mechanic_values` satırı: **0**.

**Formül metni bir sözleşmedir (BRD riski).** `mechanics.calculation_formula` **DB'de duran,
admin'e açık dinamik formül metnidir** (`mechanic.service.ts:72-74, 201-203` doğruluyor).
Kolon bölünürse token da bölünmeli:

```
'(PLANNED_GSV - PLANNED_LTA_ON) * entered_value / 100'   →  ... * entered_rate_pct / 100
'entered_value'                                          →  entered_total_amount
'entered_value * PLANNED_VOLUME'                         →  entered_unit_amount * PLANNED_VOLUME
```

⚠️ **Ama bu metinlerin bugün hiçbir tüketicisi yok** — `calculationFormula` yalnız yazılıyor
ve doğrulanıyor; hiçbir hesap yolu okumuyor (grep: entity + seed + `mechanic.service` CRUD).
Gerçek hesap `spend-calculation.service.ts:132` switch'inde **koda gömülü**. Bu, BRD'nin
"hesaplamalar asla hardcode edilmez" ilkesiyle **mevcut** bir gerilimdir; bu ADR'nin kapsamı
değil ama kolon adları değişirken metinler de güncellenmezse gerilim **sessiz yanlışa** döner
(admin doğru formülü yazar, sistem eski koda göre hesaplar).

**A5 kararı:** ayrı task açılmaz; `calculation_formula`, `mechanics.decimal_places` (6/6 NULL),
`0012` R3'ün 8 gömülü formülü ve R4 **aynı sınıftır** ve [[T-071]] kapsamına alınmıştır.
Tek soru: *dinamik formül ilkesi gerçekten uygulanacak mı, yoksa BRD'den mi düşecek?*
**Ara durum en kötüsüdür.** F2 seed metinlerini yine de tutarlı tutar (K11: kontrata bağlamaz).

### 1.4 S1.4 — 86 referansın sınıflandırması ve dönüşüm kalıpları

Ölçüm (spec ve migration hariç): **86 referans / 7 dosya** — `0011` §S1.4 ile birebir doğrulandı.

| Dosya | Referans |
|---|---|
| `spend-calculation.service.ts` | 34 |
| `spend-distribution.service.ts` | 20 |
| `spend-validation.service.ts` | 17 |
| `mechanic.seed.ts` | 9 (formül metni + sınır bildirimi) |
| `approval-workflow.service.ts` | 3 (2'si yorum) |
| `plan-mechanic-value.entity.ts` | 2 |
| `dto/calculation-context.dto.ts` | 1 |

Sınıf dağılımı (her satır elle okundu):

| Sınıf | Sayı | Örnek konum |
|---|---|---|
| **Okuma** (kolondan/haritadan değer alma) | 24 | `spend-calculation.service.ts:103,657-660` · `spend-distribution.service.ts:100,231,319,370` |
| **Varlık/boşluk kontrolü** (null/0 testi) | 17 | `spend-validation.service.ts:69,212-214,256` · `spend-calculation.service.ts:104,288,468,507` |
| **Karşılaştırma** (sınır, aralık, ondalık) | 13 | `spend-validation.service.ts:75,86,97,106,117,127,143,156` · `spend-calculation.service.ts:896,904` |
| **Aritmetik** (semantiğe bağımlı) | 8 | `spend-calculation.service.ts:190,212,224,311,324` · `spend-distribution.service.ts:137,313` |
| **Yazma** | 1 | `spend-distribution.service.ts:91` (`enteredValue: 0`) |
| **Parametre/tip bildirimi** | 12 | `spend-calculation.service.ts:184,198,220` · `spend-distribution.service.ts:407` |
| **Yorum/metin** | 11 | `mechanic.seed.ts` formülleri, jsdoc |

**Toplam bölme yüzeyi (K1 dahil):**

| Taşıyıcı | Referans | Dosya |
|---|---|---|
| `entered_value` / `enteredValue` | 86 | 7 |
| `plan_fus.tactics` (JSONB, `Record<string, number>`) | 16 | 9 |
| `CalculationContext.mechanicValues` (`Record<string, number>`) | 19 | 3 |
| Sınır karşılaştırma noktaları (`min/max` × `entered`) | 4 | 2 |
| **TOPLAM** | **125** | **~14 benzersiz** |

**125 < 150 → STOP#1 tetiklenmedi.** Kardeşler zorunlu olsaydı `+52 (min/max) +8 (default/step)`
= **185 > 150** ve STOP#1 tetiklenirdi. §1.2'nin ispatı bu yüzden kapsam-belirleyicidir.

#### Dönüşüm kalıbı — tek çözümleme noktası

Merkez fikir: **`buildMechanicValues` genişler, ikinci bir çözümleyici yazılmaz.** Bu metot
T-052'de tam olarak "iki bağımsız türetim birbirinden ayrılır" postmortem'i sonucu **tek türetim
noktası** olarak yaratıldı (`spend-calculation.service.ts:616-645` jsdoc). Onu ikiye ayırmak o
dersi tersine çevirir.

**Örnek diff — ayrımlı birlik tipi (DOKÜMANDA; uygulanmadı):**

```ts
// ÖNERİ: src/common/numeric/mechanic-input.ts  (yeni)
export type MechanicInput =
  | { kind: 'rate';         value: RateMicro;   min?: RateMicro;   max?: RateMicro }
  | { kind: 'unit_amount';  value: PriceMinor;  min?: PriceMinor;  max?: PriceMinor }
  | { kind: 'total_amount'; value: MoneyMinor;  min?: MoneyMinor;  max?: MoneyMinor };
```

```diff
--- a/src/modules/shared/spend-calculation/spend-calculation.service.ts   (ÖRNEK)
@@ -646,10 +646,15 @@
-  buildMechanicValues(planFu: {
-    tactics?: Record<string, number> | null;
-    planMechanicValues?: Array<{
-      mechanic?: { code?: string };
-      mechanicCode?: string;
-      enteredValue?: number;
-    }>;
-  }): Record<string, number> {
-    const mechanicValues: Record<string, number> = {};
+  /**
+   * T-052 tek türetim noktası KORUNUR; T-0xx: dönüş tipi ayrımlı birliğe
+   * yükseltildi. Semantik `mechanic.inputType`/`category`'den DEĞİL, hangi
+   * kolonun dolu olduğundan gelir; `tactics` (JSONB) için mechanic satırı
+   * üzerinden çözülür — bu, JSONB'nin CHECK zorlayamamasının telafisidir.
+   */
+  buildMechanicValues(
+    planFu: { tactics?: Record<string, number> | null; planMechanicValues?: PmvRow[] },
+    mechanics: ReadonlyMap<string, Mechanic>,   // çağıran zaten yüklüyor (:721)
+  ): Map<string, MechanicInput> {
+    const out = new Map<string, MechanicInput>();
```

```diff
@@ -182,10 +182,10 @@   (ÖRNEK — aritmetik sınıfı)
   private calculateOnInvoiceDiscount(
-    mechanic: Mechanic, enteredValue: number,
+    mechanic: Mechanic, input: Extract<MechanicInput, { kind: 'rate' }>,
     plannedGsv: number, plannedLtaOnInv: number,
   ): number {
     const baseAmount = plannedGsv - plannedLtaOnInv;
-    return (baseAmount * enteredValue) / 100;
+    // K9: bu dosya float ondalık kalır (ratchet). Değişen tek şey, oranın
+    // artık ölçeğini bilen bir tipten gelmesi ve düz `number`'a AÇIKÇA
+    // dönüştürülmesi — sessiz birim karışması imkânsızlaşır.
+    return (baseAmount * rateToPercentNumber(input.value)) / 100;
   }
```

```diff
@@ -68,12 +68,20 @@   src/.../spend-validation.service.ts   (ÖRNEK — karşılaştırma sınıfı)
-      const enteredValue = pmv.enteredValue;
-      if (enteredValue === null || enteredValue === undefined) continue;
-      if (mechanic.inputType === 'percentage') {
-        if (enteredValue < 0 || enteredValue > 100) { ... }
-      } else if (mechanic.inputType === 'currency') { ... }
-      if (mechanic.minValue != null && enteredValue < mechanic.minValue) { ... }
+      const input = inputs.get(mechanic.code);
+      if (input === undefined) continue;          // girdi yok — meşru
+      switch (input.kind) {
+        case 'rate':         /* 0–100 aralığı ARTIK DB CHECK'inde de var */ break;
+        case 'unit_amount':  /* negatiflik kontrolü */ break;
+        case 'total_amount': /* negatiflik kontrolü */ break;
+      }
+      // Sınır karşılaştırması: min/max AYNI birliğin içinde geldiği için
+      // ölçek dönüşümü YOK, dallanma YOK, ayırıcı okuma YOK.
+      if (input.min !== undefined && input.value < input.min) { ... }
+      if (input.max !== undefined && input.value > input.max) { ... }
```

> `noFallthroughCasesInSwitch: true` (tsconfig) + ayrımlı birlik ⇒ yeni bir `kind` eklendiğinde
> **derleyici** her switch'i patlatır. Bu, E1'e rağmen elde kalan gerçek derleyici garantisidir
> ve bilerek buraya konumlandırılmıştır.

**İkinci implementasyon uyarısı (yeni kod yazmadan önce ara — ZORUNLU madde):**
`spend-calculation.service.ts:893-907` sınır doğrulamasını **ikinci kez** yapıyor
(`spend-validation.service.ts:142-166`'nın kopyası, farklı hata biçimiyle). Bölme sırasında
**üçüncü** bir kopya yazılmamalı; ikisi tek noktada birleşmeli veya biri açıkça kaldırılmalı.
Aksi hâlde bu ADR "iki submit yolu / iki lumpsum dağıtımı / iki CSV parser" listesine üçüncü
kalemi ekler.

#### Canlı polimorfizm zararı (yeni bulgu — Karar 4'ün gerekçesini güçlendirir)

`plan.service.ts:2692-2705` (`getAnalysis`, `GET /plans/:id/analysis`, Category Manager'a açık —
`plan.controller.ts:179-186`) `plan_fus.tactics`'in **ham** değerlerini `spend` diye topluyor:

```ts
existing.spend += Number(value) || 0;      // :2701
...
spend: data.spend,                          // :2724
percentage: (data.spend / totalSpendForBreakdown) * 100,   // :2726
```

`CPP_ON_PCT: 10` (yüzde) ile `DISPLAY_FEE: 5000` (TRY) aynı toplamda buluşuyor: harcama dağılımı
`%0,2 / %99,8` çıkar. Kalıcılaşmıyor (Alan B), ama **onaylayan kullanıcının gördüğü** rapordur —
`0012` R2 ile aynı sınıf. Bölme bu bulguyu yapısal olarak imkânsız kılar; birleştirme dal
başına ayrı yapılmak zorunda kalır.

---

### 1.5 ⟨r2 — errata E2⟩ JSONB kapsam kararı: F2'ye girer, yöntem (J1)

Errata E2 kolon bölünmesinin **gerekli ama yeterli olmadığını** saptadı. Üç seçenek ölçüldü.

#### Ölçüm — JSONB tarafının gerçek yüzeyi

| Olgu | Değer | Kanıt |
|---|---|---|
| `plan_fus.tactics` referansı | **16** / 9 dosya | `plan.entity.ts:246` · `plan.service.ts:505,564,2359,2692-2693` · `plan.repository.ts:414,421,498` · `update-fu-tactic.dto.ts:12` · `add-fu.dto.ts:24` · `approval-workflow.service.ts:137` · `kpi-engine.service.ts:28,106` · `spend-calculation.service.ts:647,664` |
| `buildMechanicValues` **üretim çağıranı** | **2** | `plan.service.ts:2134` · `spend-calculation.service.ts:706` |
| Her iki çağıranda mekanik listesi **zaten yüklü mü** | **EVET** | `plan.service.ts:2083` `cachedActiveMechanics = await this.spendCalc.getActiveMechanics(tenantId)` (`:2145`'te kullanılıyor) · `spend-calculation.service.ts:721` `activeMechanics` |
| Frontend'de `tactics` **yazma** noktası | **1** | `PlanningGridEnhanced.tsx:1032` `tactics: { [mechanicCode]: value }` |
| `plan_fus` satır sayısı (JSONB backfill hacmi) | **0** | canlı SQL |

#### Seçenekler

| | **(J1) — SEÇİLDİ** | (J2) JSONB şekli değişir | (J3) tur dışı |
|---|---|---|---|
| `plan_fus.tactics` şekli | `Record<string, number>` **korunur** — ham girdi taşıyıcısı | `{code: {kind, value}}` — semantik taşıyıcı | değişmez |
| Semantik nerede pinlenir | `buildMechanicValues` çıkışı (**ayrımlı birlik**) | JSONB'nin kendisinde | hiçbir yerde |
| **DB zorlaması (CHECK)** | **yok** — JSONB'de mümkün değil | **yok** — JSONB'de mümkün değil | yok |
| API sözleşmesi | **korunur** | **kırılır** | korunur |
| Frontend dosyası | **0** | 1 (+ e2e, + tipler) | 0 |
| Backend dosyası | ~3 (`buildMechanicValues` + 2 çağıran imzası) | ~8 (+ DTO, repository, migration backfill) | 0 |
| Ek DB round-trip | **0** (mekanikler zaten yüklü) | 0 | — |
| Karar 4'ün amacı gerçekleşir mi | **evet** | evet | **hayır** |

#### Seçim: (J1). Gerekçe.

1. **(J2)'nin zorlama kazancı SIFIR.** Bu, kararın belirleyici olgusu: `plan_fus.tactics` bir
   `jsonb` kolonudur ve **hiçbir seçenekte** üzerine anlamlı bir `CHECK` konulamaz — JSONB'nin
   içindeki anahtar başına ölçek kısıtı PostgreSQL'de ifade edilemez. Yani (J2), (J1)'in
   üstüne **tek bir DB garantisi eklemiyor**; eklediği tek şey "JSONB'ye çıplak gözle bakınca
   semantik görünür" okunabilirliği. Bedeli ise **API sözleşmesinin kırılması**.
   Zorlama kazancı olmayan bir breaking change kötü takastır.
2. **(J1) Karar 4'ün amacını gerçekleştiriyor.** Belirsizlik `buildMechanicValues`'ın
   **çıkışında bitiyor**: aşağı akıştaki her tüketici (`spend-calculation`, `spend-validation`,
   `spend-distribution`) ayrımlı birlik alıyor ve `noFallthroughCasesInSwitch` + exhaustive
   check ile derleyici korumasına giriyor. Kolonun bölünmesi de bu birliğin **DB tarafındaki**
   yarısını `CHECK` ile zorluyor (K2). İkisi birlikte, ölçülen iki taşıyıcının **ikisini de**
   kapsıyor.
3. **(J1) T-052'nin kararıyla aynı doğrultuda.** `buildMechanicValues` tam olarak *"iki bağımsız
   türetim birbirinden ayrılır"* postmortem'i sonucu **tek türetim noktası** olarak yaratıldı
   (`spend-calculation.service.ts:616-645` jsdoc). (J1) o noktayı **zenginleştiriyor**;
   (J2) ise JSONB'yi ikinci bir semantik kaynağa dönüştürerek onu **zayıflatıyor**.
4. **(J3) reddedildi** çünkü errata E2 tam olarak "kolon bölmek yetmez" diyor. Yarım bırakmak
   Karar 4'ü boşa çıkarır: canlı yol (tactics-PATCH) hiç değişmez.

#### F2'ye girer, ayrı faz OLMAZ

(J1)'in yüzeyi `buildMechanicValues` + 2 çağıran imzası. Bu, kolon bölünmesiyle **aynı
dosyalarda** ve aynı commit'te olmalıdır; ayrılırsa `buildMechanicValues` iki kez değişir ve
K9'un ratchet ölçümü iki kez sıfırlanır — F1'i F2'nin önüne almakla **aynı gerekçe**.
**Faz sayısı 4'te kalır.**

#### (J1)'in kabul ettiği artık risk — açıkça

JSONB'ye yanlış ölçekte bir sayı yazılabilir ve **DB engellemez**. Bu, (J2)'de de aynen
geçerlidir (yukarıdaki 1. madde). Telafi: `buildMechanicValues` bir tactic koduna karşılık
mekanik **bulamazsa** bugün olduğu gibi sessizce atlayamaz — **açık hata fırlatır**
(bugünkü davranış `spend-calculation.service.ts:664-668`: `if (val != null)` ile sessiz kabul).
Bu, sessiz-sıfır yasağının bu yoldaki karşılığıdır ve F2'nin kabul kriterine girer.

---

## 2. Oran ölçeği (ADR Karar 5)

### 2.1 S2.1 — DB notasyonu, TS temsili, ad tutarlılığı

**DB'de yüzde notasyonu (`3.2500` = %3,25).** Karar 5 bunu zaten söylüyor ve üç bağımsız kanıt
bu turda yeniden doğrulandı: `lta-rate.entity.ts:34,42` (`// 0-100`),
`lta-agreement.service.ts:473` (`onInvoicePercentage + offInvoicePercentage > 100` kontrolü),
formüllerde `/ 100` (`mechanic.seed.ts:114`, `spend-calculation.service.ts:190,212`,
`lta-calculation.service.ts:76,81,151`). **Değiştirilmiyor.**

**TS'te tamsayı.** `RateMicro` bir tamsayıdır; `numeric(9,4)` yüzde değerinin **10⁴ katı**:

```
DB numeric(9,4)   TS RateMicro   yüzde        kesir        baz puan
  3.2500            32500         %3,25        0,0325        325
100.0000          1000000        %100          1             10000
  0.0001               1         %0,0001       0,000001        0,01
```

**Ad ile ölçek çelişiyor — `RateBps` yanıltıcı.** Baz puan tanımı: 1 bps = %0,01. Yani
`%3,25 = 325 bps`. ADR'nin seçtiği 4 ondalık yüzde çözünürlüğü **0,01 bps**'tir — baz puanın
**yüzde biri**. `RateBps` adlı bir tamsayının değeri `32500` ise, adı `325` demeyi vaat ediyor
ama `32500` tutuyor: **100 kat**lık bir okuma hatası davetiyesi. ADR §Karar 5'teki
*"(baz puan hassasiyeti)"* parantezi de aynı imprecision'ı taşıyor.

İki tutarlı çıkış var, ikisi de ölçek ile adı hizalar:

| | Ad | Ölçek | Sonuç |
|---|---|---|---|
| **Ö1 — SEÇİLDİ** | `RateMicro` | yüzde×10⁴ = kesir×10⁶ | Karar 5'in **4 ondalık kararı korunur**; ad doğru (milyonda bir = ppm) |
| Ö2 | `RateBps` | yüzde×10² | Ad doğru olur ama **Karar 5'in 4 ondalık kararı bozulur** (2 ondalığa iner) |

Ö2, kabul edilmiş bir kararı ters çevirmek olurdu; bu benim yetkim değil. **Ö1 seçildi** ve
bu bir **isimlendirme düzeltmesidir, karar değişikliği değildir** (K8). ADR metnindeki `RateBps`
sembolü ve "baz puan hassasiyeti" ifadesi **errata E3 ile düzeltildi.**

**Marka anahtarı `'rate'` DEĞİŞMEZ** — ADR Karar 3a'nın `readonly __scale: 'rate'` biçimi
korunur; yalnız tip **adı** değişir.

**Oran × tutar hangi ara ölçekte tam kalır:**

```
MoneyMinor (kuruş, int) × RateMicro (yüzde×10⁴, int)  =  kuruş × 10⁻⁶ ölçeğinde TAM tamsayı
                                                          ÷ 10⁶ → kuruş,  yuvarlama BURADA
```

Yuvarlama **yalnız** bu bölmede devreye girer ve **yalnız kalıcılaştırma anında** uygulanır
(Karar 6). Zincirleme oran çarpımlarında (ör. `plannedGsv → −LTA_ON → −LTA_OFF → ×promo%`)
ara sonuçlar `kuruş × 10⁻⁶` ölçeğinde **tam** taşınır; ara yuvarlama yapılmaz.

**2⁵³ sınırı — ADR'nin yazdığından daha dar bir operasyonel tavan var (yeni sayı):**

```
tek MoneyMinor için tavan   : 2⁵³ kuruş                = 90.071.992.547.409 TRY  (~90 trilyon)
applyRate operandı için     : 2⁵³ / 10⁶ kuruş          =         90.071.992 TRY  (~90 milyon)
```

`applyRate`'e giren tutar 90 milyon TRY'yi aşarsa ham çarpım 2⁵³'ü aşar. Ölçülen en büyük gerçek
tutar **600.000 TRY** (`budget_envelopes.allocated_amount`) → **150× pay** var. Kontrol
`applyRate`'in içinde olmalı, tip sınırında değil (§3.2). ADR'nin yazdığı 90 trilyonluk sınır
tek değer için doğrudur; **çarpım operandı için değil.** **Errata E4 ile düzeltildi**;
`bigint` yeniden değerlendirme eşiği **50 milyon TRY** (A9) ve bu eşik hata mesajında taşınır (K12).

### 2.2 S2.2 — `RateMicro` olacak kolonların tam listesi

Ölçüm: `information_schema.columns`, şema `main`, ad kalıbı `percent|pct|rate|ratio|threshold|margin|uplift|roi`
+ `numeric_scale=4` taraması. Tüm oran benzeri kolonlar:

| # | Kolon | Bugün | Hedef | Alan | Gerekçe |
|---|---|---|---|---|---|
| 1 | `lta_rates.on_invoice_percentage` | `numeric(5,2)` | **`numeric(9,4)`** | A | `lta-calculation.service.ts:76,151` para üretiyor |
| 2 | `lta_rates.off_invoice_percentage` | `numeric(5,2)` | **`numeric(9,4)`** | A | `lta-calculation.service.ts:81,157` |
| 3 | `lta_plan_overrides.override_on_invoice_pct` | `numeric(5,2)` | **`numeric(9,4)`** | A | `lta-agreement.service.ts:425,431` → `finalOnInvoicePct` |
| 4 | `lta_plan_overrides.override_off_invoice_pct` | `numeric(5,2)` | **`numeric(9,4)`** | A | `lta-agreement.service.ts:426,433` |
| 5 | `plan_mechanic_values.entered_rate_pct` (yeni) | — | **`numeric(9,4)`** | A | §1.1 |
| 6 | `mechanics.max_combined_discount_percentage` | `numeric(5,2)` | **`numeric(9,4)`** ⚠️ | A | `spend-validation.service.ts:325` — `entered_value` oran toplamıyla **karşılaştırılıyor**; iki ölçekte kalırsa karşılaştırma bozulur. **errata E8 ile Karar 5 kapsamına alındı** (A3) |
| — | `mechanics.min_value` / `max_value` (oran yarısı) | `numeric(18,4)` | **değişmez** | A | §1.2 — bölünmez, ölçek dönüşümü tek noktada |
| — | `budget_alert_configurations.threshold_percent` | `numeric(5,2)` | **değişmez** | **B** | aşağıda |
| — | `kpis.rag_green_threshold` / `rag_amber_threshold` | `numeric(18,4)` | **değişmez** | B | ADR Karar 1: RAG Alan B |
| — | `plans.overall_roi`, `plan_fus.gp_roi`, `plan_skus.gp_roi` | `numeric(18,4)` | **değişmez** | B | analitik çıktı |
| — | `v_budget_summary.utilization_pct` | view | **değişmez** | B | türetilmiş |

**`threshold_percent` (80/95/100) — Alan A'da MI? Cevap: bugün HAYIR, ve gerekçesi ölçülmüştür.**

CLAUDE.md §2 *"%100+ Exceeded (block)"* diyor. Kodda **bloklama yok**:

| Tüketici | Ne yapıyor | Konum |
|---|---|---|
| `budget-allocation.service.ts:932-947` | `this.logger.error(...)` + `// TODO: ... block plan submission if hard limit mode` | log |
| `on-invoice-validation.service.ts:528-540` | RAG rengi belirliyor (`UtilizationStatus.RED`) | gösterim |
| `finance-reporting.service.ts:1022,1100,1168` | rapor durumu | salt-okur |
| `budget.service.ts:1595` | rapor durumu | salt-okur |

Gerçek sert para kapısı bir **yüzde eşiği değil, tutar karşılaştırmasıdır**
(`budget.service.ts:557-561`, yetersiz bütçede 400). Dolayısıyla ADR Karar 1'in tanımı gereği
`threshold_percent` **Alan B'dedir ve `RateMicro`'ya dönüşmez.** ADR **A6 kararı:** `threshold_percent`
bloklamadığı sürece Alan B'de kalır ve `RateMicro`'ya dönüşmez. Karar 2 ise **errata E5 ile
genelleştirildi** ve onu ileriye dönük kapsar: *"Bir eşik değerlendirmesi — RAG, bütçe yüzdesi
veya başka bir oran — bir onayı, rezervasyonu veya para hareketini bloklayan kapıya
dönüştürülmek istenirse, karar değeri önce Alan A'da yeniden üretilmelidir."*

> ⚠️ `budget-allocation.service.ts:945` `// TODO: ... block plan submission if hard limit mode`
> **bir BRD ihlalidir** (CLAUDE.md §2.3 "%100+ Exceeded (block)") — kod bugün bloklamıyor.
> **Ayrı task**, bu turda değil (A6).

> ⚠️ **Yan bulgu (kapsam dışı, ayrı task):** `spend-validation.service.ts:28-31` dört oran
> eşiğini **koda gömüyor** — `MAX_ON_INVOICE_DISCOUNT = 50`, `MAX_OFF_INVOICE_DISCOUNT = 30`,
> `MAX_COMBINED_DISCOUNT = 60`, `BUDGET_WARNING_THRESHOLD = 80` — yorumu "Configurable
> thresholds" demesine rağmen. Sonuncusu `BudgetThresholdService`'in config-driven değerini
> **yok sayıyor** (aynı repoda, aynı kavram, ikinci implementasyon). BRD "threshold asla
> hardcode" ilkesiyle çelişir. Bu ADR'nin işi değil ama `RateMicro` kapsamı belirlenirken
> görünür olmalı.

### 2.3 S2.3 — Kolon sayısı, tablolar, migration

**5 kolon / 3 tablo** (§2.2'nin 1–4 + 6; #5 zaten `1796`'nın parçası).

```sql
-- migration 1797000000000  (TAHSİS EDİLDİ — kendi numarasını seçme yasağı)
ALTER TABLE main.lta_rates
  ALTER COLUMN on_invoice_percentage  TYPE numeric(9,4),
  ALTER COLUMN off_invoice_percentage TYPE numeric(9,4);
ALTER TABLE main.lta_plan_overrides
  ALTER COLUMN override_on_invoice_pct  TYPE numeric(9,4),
  ALTER COLUMN override_off_invoice_pct TYPE numeric(9,4);
ALTER TABLE main.mechanics
  ALTER COLUMN max_combined_discount_percentage TYPE numeric(9,4);   -- errata E8 (A3)

-- Oran aralığını DB'ye taşı: bugün yalnız uygulamada (lta-agreement.service.ts:473)
ALTER TABLE main.lta_rates
  ADD CONSTRAINT chk_lta_rate_on_range  CHECK (on_invoice_percentage  BETWEEN 0 AND 100),
  ADD CONSTRAINT chk_lta_rate_off_range CHECK (off_invoice_percentage BETWEEN 0 AND 100);
```

**Genişletme yönü güvenli:** `numeric(5,2) → numeric(9,4)` PostgreSQL'de kayıpsızdır ve tablo
**boş** (`lta_rates` 0, `lta_plan_overrides` 0). `mechanics` 6 satır ama ilgili kolon **6/6 NULL**.
`db:reset` (yani `seed:cleanup-and-seed`) gerekmez bile; `migration:run` yeterlidir. `down()`
daraltma yönündedir ve **boşken güvenlidir** — bu yüzden geri alma penceresi tabloların dolmasına
kadar açıktır; faz kabulünde bu not düşülmeli.

> `numeric(9,4)` 5 tam basamağa (99999.9999) izin verir; 0–100 aralığı için `numeric(7,4)`
> yeterdi. ADR `numeric(9,4)` diyor — değiştirmiyorum. Fazlalık `CHECK` ile kapatılıyor.

---

## 3. Markalı tipler ve yardımcılar

### 3.1 S3.1 — Nerede yaşar, nasıl üretilir, gerçekten ne yakalar

**Konum: `src/common/numeric/`.** Gerekçe bağımlılık yönü:
- `src/database/entities/*` ve `src/database/transformers/*` bunu **import etmek zorunda**
  (transformer fabrikaları).
- `src/modules/**` de import eder.
- `src/common` bugün `services/`, `decorators/`, `guards/`, `interceptors/` barındırıyor ve
  **hiçbir modüle bağımlı değil** — tek yönlü kenar korunur (`common ← database`, `common ← modules`).
- `src/modules/shared/` altına konursa `database/entities` → `modules/shared` kenarı doğar;
  bu, bugün var olmayan ters bir bağımlılıktır ve modül sınırını bozar. **Reddedildi.**

```
src/common/numeric/
  brands.ts        MoneyMinor · PriceMinor · RateMicro  (tip + marka)
  money.ts         fabrika + aritmetik yardımcıları
  rate.ts          fabrika + oran uygulama
  rounding.ts      halfUp — TEK yuvarlama noktası
  allocation.ts    largest-remainder
  limits.ts        2⁵³ kontrolleri
  mechanic-input.ts  MechanicInput ayrımlı birliği (§1.4)
  index.ts         tek dışa açılan yüzey
src/database/transformers/
  numeric.transformers.ts   ← YENİ; DecimalTransformer'a dokunulmaz (§3.3)
```

#### Ölçüm: markalı tip TypeScript 5.9.3'te ne yakalıyor, ne yakalamıyor

Koşturuldu (`tsc -p`, `strict: true`, `skipLibCheck`, hedef ES2021 — repodaki tsconfig ile aynı
katılıkta):

```ts
type MoneyMinor = number & { readonly __scale: 'money' };
type RateMicro  = number & { readonly __scale: 'rate'  };
declare const m: MoneyMinor; declare const r: RateMicro; declare const n: number;
```

| # | İfade | Sonuç | Not |
|---|---|---|---|
| 1 | `const prod = m * r;` | ✅ **DERLENİYOR** | ⛔ ADR Karar 3a'nın iddiası burada çürüyor. `typeof prod` = `number` |
| 2 | `const stored: MoneyMinor = m * r;` | ❌ **TS2322** | Gerçek koruma: **atama**, operatör değil |
| 3 | `const q = m / r;` · `const s = m - r;` · `const neg = -m;` | ✅ derleniyor | operatörler markayı görmez |
| 4 | `const w: number = m * r;` | ✅ **derleniyor** | çarpım her düz `number` yuvasına akar → **K3'ün gerekçesi** |
| 5 | `const d: MoneyMinor = n;` | ❌ TS2322 | düz sayı markalı yuvaya giremez |
| 6 | `needsRate(m)` (`m: MoneyMinor`) | ❌ TS2345 | çapraz marka parametre **yakalanıyor** |
| 7 | `needsNumber(m)` | ✅ derleniyor | markalı → düz genişleme serbest (kaçınılmaz) |
| 8 | `m > r` | ✅ derleniyor | çapraz karşılaştırma **yakalanmıyor** |
| 9 | `m as RateMicro` | ❌ **TS2352** | doğrudan çapraz cast yakalanıyor |
| 10 | `m as unknown as RateMicro` · `n as MoneyMinor` | ✅ derleniyor | ⛔ **kaçak** |
| 11 | `[m,m].reduce((a,b)=>a+b, 0 as unknown as MoneyMinor)` | ❌ TS2769 | aynı-ölçek toplama bile helper gerektiriyor |

**Sonuç — markanın gerçek gücü ve tasarım sonucu:**
Marka bir **operatör kapısı değil, bir yuva kapısıdır.** `m * r` yazılabilir; ama sonucu
markalı bir alana yazamazsın. Bu, kontrolü **kalıcılaştırma sınırına** taşır — ki ADR'nin
korumak istediği tam olarak orasıdır. Ancak (4) gösteriyor ki bir `number` alanı bu kapıyı
tümüyle atlatır. Dolayısıyla:

> **K3 zorunlu hâle gelir:** yeni modüllerde para/oran taşıyan hiçbir entity kolonu, DTO alanı
> veya repository imzası `number` olamaz. Aksi hâlde markanın **tek** gerçek kapısı da açılır.

(11) de tasarımı belirliyor: `m + m` bile düz `number` üretir, yani **toplama dahil her işlem
yardımcıdan geçmek zorunda**. Yardımcı modülü "kolaylık" değil, **yapısal zorunluluk**tur.

#### Fabrika mı, cast mı — kaçak nasıl kapatılır

Sadece fabrika. Ama (10) gösterdi ki `as` cast kaçağı **derleyiciyle kapatılamaz.** Kapatma
mekanizması ölçüldü ve çalışıyor — ESLint 8.57.1 + `@typescript-eslint/parser`:

```jsonc
// .eslintrc.js  overrides[] — UserRole kalıbının AYNISI (mevcut precedent, satır 27-58)
{
  "files": ["src/**/*.ts"],
  "excludedFiles": ["src/common/numeric/*.ts"],        // fabrikanın kendisi muaf
  "rules": { "no-restricted-syntax": ["error",
    { "selector": "TSAsExpression > TSTypeReference[typeName.name=/^(MoneyMinor|PriceMinor|RateMicro)$/]",
      "message": "Markalı tip yalnız src/common/numeric fabrikasından üretilir; `as` cast yasak." },
    { "selector": "TSTypeAssertion > TSTypeReference[typeName.name=/^(MoneyMinor|PriceMinor|RateMicro)$/]",
      "message": "Aynı kural açı-parantez cast için de geçerli." }
  ]}
}
```

**Koşturuldu, ölçülen sonuç:**

```
leak.ts
  4:16  error  as-cast yasak  no-restricted-syntax     ← n as MoneyMinor
  5:27  error  as-cast yasak  no-restricted-syntax     ← n as unknown as MoneyMinor
  6:27  error  as-cast yasak  no-restricted-syntax     ← n as unknown as RateMicro
✖ 3 problems
```

`n as number` **bulgu vermiyor** (yanlış pozitif yok). **STOP#2 tetiklenmedi.**

> Bir uyarı: `npm run lint` `eslint --fix` ile koşuyor ve `no-restricted-syntax` düzeltilemez —
> yani hata olarak kalır, sessizce yutulmaz. Yine de tek dayanak lint olmamalı: guard tarafında
> aynı desen taranır (§3.5), çünkü Done kapısı `npm run guards`'tır.

#### Hacim ve fiyat markalanmalı mı?

`0011` üç ölçek buldu: para ×100, hacim ×1000, fiyat ×10000. Ölçülen karşılaşma noktaları:

```
spend-calculation.service.ts:109   plannedVolume * listPrice              ← hacim × fiyat
spend-calculation.service.ts:224   enteredValue * plannedVolume           ← fiyat × hacim
spend-calculation.service.ts:311   (enteredValue * skuBaseVolume) / totalBaseVolume
spend-distribution.service.ts:447  plannedVolume * listPrice
spend-validation.service.ts:248    volume * price
```

#### ⟨r2 — A7⟩ Marka mekanizması üçüncü markaya AÇIK olmak zorunda

A7'nin tek şartı: *genişletilemez marka mekanizması ve iki-marka varsayan yardımcı imzası
yazılmaz.* Tasarımda bunun karşılığı üç somut kural:

**(1) Marka jenerik bir mekanizmadır, üç elle yazılmış tip değil.**

```ts
// src/common/numeric/brands.ts
export type ScaleName = 'money' | 'price' | 'rate';        // ← genişleyen TEK yer
type Scaled<S extends ScaleName> = number & { readonly __scale: S };

export type MoneyMinor = Scaled<'money'>;   // kuruş,      10²
export type PriceMinor = Scaled<'price'>;   // TRY/birim,  10⁴
export type RateMicro  = Scaled<'rate'>;    // yüzde,      10⁴
// gelecekte:  export type VolumeMilli = Scaled<'volume'>;   → ScaleName'e 'volume' eklenir
```

**(2) Ölçek çarpanı bir KAYIT TABLOSUDUR, yardımcıya gömülü sabit değil.**

```ts
// Yeni marka eklemek = bu tabloya bir satır. Dönüşüm yardımcıları imza DEĞİŞTİRMEZ.
export const SCALE_FACTOR: Readonly<Record<ScaleName, number>> = {
  money: 100, price: 10_000, rate: 10_000,
};
```

**(3) Yardımcılar "iki marka" varsaymaz.** `applyRate(m, r)` özel bir imza gibi görünse de
altında ölçek-farkındalı jenerik bir çarpım vardır; üçüncü marka geldiğinde `applyRate` /
`quantityTimesPrice` **yeniden yazılmaz**, ince bir sarmalayıcı eklenir. Yasak olan:
`function convert(x: MoneyMinor | RateMicro)` gibi **kapalı birlik** parametreleri ve
`if (scale === 'money') ... else ...` gibi **iki-dallı** ölçek mantığı.

> **Ayrım:** A7 *kapalı ayrımlı birlik* yazmayı yasaklamıyor. `MechanicInput`'un üç `kind`'ı
> **exhaustive olmalıdır** — yeni bir `kind` eklendiğinde `noFallthroughCasesInSwitch` her
> switch'i patlatsın diye. Yasaklanan şey **marka mekanizmasının** ve **ölçek dönüşümünün**
> genişletilemez olması.

**Karar: `PriceMinor` markalanır, `VolumeMilli` markalanmaz — bu turda (A7).**
- `PriceMinor` zorunlu, çünkü `entered_unit_amount` bir fiyattır (§1.1/E3) ve `MoneyMinor` ile
  **karıştırılabilir** (ikisi de TRY görünümlü, ölçekleri 10² vs 10⁴). Marka tam da bu ayrımı
  taşımak için var.
- `VolumeMilli` bu turda dışarıda: hacim kolonları (`plan_skus.base_volume`, `planned_volume`,
  `numeric(18,3)`) mevcut Alan A dosyalarında yaşıyor ve K9 onları dönüştürmeyi yasaklıyor.
  Markalı bir hacim tipi eklemek, `plan.service.ts` (109 para aritmetiği) ve `spend-*` üçlüsünü
  dönüştürmeyi **zorunlu** kılardı. D-07 (recognition) hacim taşımıyor, yani şimdilik gerekmiyor.
  Eklenmesi yukarıdaki (1)+(2) sayesinde **iki satırlık** iştir: `ScaleName`'e `'volume'`,
  `SCALE_FACTOR`'a `volume: 1000`.

`spend-calculation` sınırında karşılaşma **olur** (yukarıdaki 5 satır) ama K9 uyarınca o dosya
float kalıyor; markalı değer oraya girerken `toNumber` benzeri **açık** bir dönüşümden geçer
(`rateToPercentNumber`, `priceToMajorNumber`) — sessiz genişleme (tablo satırı 7) bilinçli
olarak tek bir adlandırılmış fonksiyona hapsedilir ve guard onu tanır.

### 3.2 S3.2 — Yardımcı API yüzeyi (imza + davranış + hata)

Uygulama YAZILMADI. Aşağıdaki her fonksiyon için hata durumu **açık** — sessiz `0`, sessiz
`NaN`, sessiz atlama yok.

```ts
// ── brands.ts ────────────────────────────────────────────────────────────
export type MoneyMinor = number & { readonly __scale: 'money' };  // kuruş,     10²
export type PriceMinor = number & { readonly __scale: 'price' };  // TRY/birim, 10⁴
export type RateMicro  = number & { readonly __scale: 'rate'  };  // yüzde,     10⁴
```

**Fabrikalar** — tek üretim yolu:

| İmza | Davranış | Hata |
|---|---|---|
| `moneyFromMinor(n: number): MoneyMinor` | Tamsayı + sonlu + \|n\| ≤ 2⁵³−1 doğrular | `NumericContractError('MONEY_NOT_INTEGER' \| 'MONEY_OUT_OF_RANGE' \| 'MONEY_NOT_FINITE')` |
| `moneyFromDecimalString(s: string): MoneyMinor` | `numeric(18,2)` sürücü **string**'ini ayrıştırır; ondalık > 2 ise **hata** | `'MONEY_SCALE_EXCEEDED'` — sessiz yuvarlama yasak (K6) |
| `rateFromMicro(n: number): RateMicro` | Tamsayı + `0 ≤ n ≤ 1_000_000` | `'RATE_OUT_OF_RANGE'` |
| `rateFromPercentString(s: string): RateMicro` | `numeric(9,4)` string'i; ondalık > 4 ise **hata** | `'RATE_SCALE_EXCEEDED'` |
| `priceFromMinor(n: number): PriceMinor` | Tamsayı + sonlu | `'PRICE_NOT_INTEGER'` |

> **`null`/`undefined` girişte fabrika hata fırlatır** — `?? 0` yasaktır. Bugün canlı kodda
> tam bu kalıptan var: `spend-calculation.service.ts:126` `(ltaContext?.finalOnInvoicePct || 0)`,
> `spend-calculation.service.ts:103` `context.mechanicValues[mechanicCode] || 0`. Yeni yol bunu
> tekrar etmez; "değer yok" durumu çağıranın **açıkça** ele alacağı bir `undefined`'dır.

**Yuvarlama** — `rounding.ts`, tek nokta. ⟨r2: **half-away-from-zero**, errata E7⟩

| İmza | Davranış | Hata |
|---|---|---|
| `roundHalfAwayFromZero(scaledValue: number, scaleFactor: number): number` | Yalnız **kalıcılaştırma anında** çağrılır. **`\|round(x)\| = round(\|x\|)`** — işaret simetrik. **Negatif girdi GEÇERLİDİR**, hata yok. Ara hesapta çağrılması yasak (guard denetler). | `'ROUNDING_INPUT_NOT_FINITE'` |

Davranış tablosu (kabul testi):

| x | `roundHalfAwayFromZero(x)` | `Math.round(x)` (**kullanılamaz**) |
|---|---|---|
| `2.5` | **3** | 3 |
| `-2.5` | **-3** | **-2** ⛔ |
| `2.4` / `-2.4` | 2 / -2 | 2 / -2 |
| `-0.5` | **-1** | **-0** ⛔ |

> ⚠️ **JS `Math.round` E7 kuralını KARŞILAMAZ** — negatifte `+∞`'a yuvarlar. Bugün canlı kodda
> `Math.round(raw * 100) / 100` kalıbı var (`spend-calculation.service.ts:315,324,333`),
> yani mevcut fiilî davranış "+∞'a half". Yardımcı bunu **devralamaz**;
> `Math.sign(x) * Math.round(Math.abs(x))` sınıfı bir uygulama gerekir.
> **K7 regresyon testi bunu kilitler.**

> **Neden şimdi sabitleniyor:** `ledger_entries` 1.231 satır, **0 negatif**; yön
> `entry_direction` kolonunda taşınıyor ve `reversal.service.ts:181` `Math.abs` uyguluyor.
> Kural **baskı altında değilken** yazılıyor; reversal/CREDIT yolları negatif tutar üretmeye
> başladığında hazır olacak (errata E7).

**Oran uygulama:**

| İmza | Davranış | Hata |
|---|---|---|
| `applyRate(m: MoneyMinor, r: RateMicro): MoneyMinor` | `m × r` ham çarpımı, 2⁵³ kontrolü, `÷ 10⁶` + `roundHalfAwayFromZero` | `'RATE_MULTIPLY_OVERFLOW'` — mesaj **K12** uyarınca hem `50.000.000 TRY` eşiğini hem `ADR 0007 E4/A9` atfını taşır |
| `applyRateExact(m: MoneyMinor, r: RateMicro): ScaledMoney` | Yuvarlamadan, `kuruş×10⁻⁶` ölçeğinde tam sonuç — zincirleme oran için | aynı overflow kontrolü, aynı mesaj sözleşmesi |
| `quantityTimesPrice(q: number, p: PriceMinor): MoneyMinor` | Hacim × fiyat; ölçek dönüşümü **açık** | `'SCALE_OVERFLOW'` |

**Toplama/çıkarma** (E1/(11) nedeniyle zorunlu):

| İmza | Davranış | Hata |
|---|---|---|
| `addMoney(...xs: MoneyMinor[]): MoneyMinor` | Tamsayı toplama; her adımda 2⁵³ kontrolü | `'MONEY_SUM_OVERFLOW'` |
| `subMoney(a: MoneyMinor, b: MoneyMinor): MoneyMinor` | Sonuç **negatif olabilir** (E7 sonrası meşru) | `'MONEY_OUT_OF_RANGE'` yalnız 2⁵³ aşımında |
| `sumMoney(xs: readonly MoneyMinor[]): MoneyMinor` | Boş dizide **`0` DÖNMEZ**; çağıran `undefined` alır ve açıkça ele alır | — |

**Largest-remainder dağıtımı** — ADR Karar 6'nın dört adımı, iş anahtarı sıralamasıyla:

```ts
export interface AllocationPart<K> {
  readonly key: K;              // iş anahtarı taşıyıcısı (uuid DEĞİL)
  readonly weight: number;      // tam pay ağırlığı (ör. base volume)
}
export interface AllocationTieBreak<K> {
  /** Eşit kesirli kısımda sıralama. INV-N-001: üretilmiş id ile sıralama YASAK. */
  compare(a: K, b: K): number;
}
export function allocateLargestRemainder<K>(
  total: MoneyMinor,
  parts: readonly AllocationPart<K>[],
  tie: AllocationTieBreak<K>,
): ReadonlyMap<K, MoneyMinor>;
```

Davranış (Karar 6 birebir):
1. Her parça için `raw = total × weight / Σweight`, **kuruşa floor**
2. `artık = total − Σ(floor'lanmış paylar)` (tamsayı, ≥ 0, < parça sayısı)
3. Artığı, `raw`'ın kesirli kısmı en büyük olan parçalara **kuruş kuruş** dağıt
4. Eşitlikte `tie.compare` — recognition için: agreement başlangıç tarihi, sonra agreement kodu

Hata durumları (**hepsi açık**):

| Durum | Sonuç |
|---|---|
| `parts` boş | `AllocationError('ALLOCATION_NO_PARTS')` — `{}` dönmez |
| `Σweight === 0` | `AllocationError('ALLOCATION_ZERO_WEIGHT')` — eşit bölme **yapmaz** |
| Herhangi `weight < 0` veya sonlu değil | `'ALLOCATION_INVALID_WEIGHT'` |
| `tie.compare` iki farklı anahtar için `0` dönerse | `'ALLOCATION_NONDETERMINISTIC_TIE'` — determinizm iddiası kanıtlanamıyorsa susulmaz |
| İnvaryant: `Σ(sonuç) !== total` | `'ALLOCATION_SUM_MISMATCH'` — koruma amaçlı assert |

> **⚠️ Mevcut implementasyon uyarısı — bu yetenek repoda ZATEN İKİ KEZ yazılmış.** Yeni bir
> üçüncüsü yazılmadan önce ikisinin de akıbeti kararlaştırılmalı:
>
> | # | Konum | Artık kuralı | Durum |
> |---|---|---|---|
> | 1 | `spend-calculation.service.ts:308-334` `computeLumpsumDistribution` | artık → **en büyük base volume**'lu SKU | **canlı üretim yolu**, ADR 0006 Karar 2 |
> | 2 | `spend-distribution.service.ts:555-579` `adjustForRounding` | fark → **en büyük tutarlı** parça, `0.01` toleransıyla | **erişilemez** (T-062: `mechanic_spend_breakdowns` tablosu hiçbir yere beslenmiyor) |
>
> Bunlar **üç farklı kural**: (1) en büyük base volume, (2) en büyük tutar, (3) ADR 0007
> Karar 6'nın largest-remainder + iş anahtarı. **Ortak bir yardımcı, (1)'in davranışını
> değiştirir** — ADR 0006 Karar 2'nin lumpsum kuralı ile ADR 0007 Karar 6'nın recognition
> kuralı **aynı şey değildir.** Tasarım kararı: `allocateLargestRemainder` **yeni modüller
> için** yazılır; `computeLumpsumDistribution` **değişmez** (K9). İkisinin birleştirilmesi
> **Errata E6:** Karar 6'nın largest-remainder'ı **kanonik ilan edildi**; dördüncü kural
> yazılmaz, mevcutlar ona yakınsar. Yakınsama **ayrı iştir** (ADR 0006'nın açık bıraktığı iş)
> ve hâlâ planlanmadı → §7.3/A8.

**Ölçek dönüşümü (kalıcılaştırma sınırı):**

| İmza | Yön | Hata |
|---|---|---|
| `moneyToDecimalString(m: MoneyMinor): string` | `MoneyMinor → numeric(18,2)` (`"1234.56"`) | — |
| `moneyFromDecimalString(s): MoneyMinor` | `numeric(18,2) → MoneyMinor` | `'MONEY_SCALE_EXCEEDED'` |
| `rateToPercentString(r: RateMicro): string` | `RateMicro → numeric(9,4)` (`"3.2500"`) | — |
| `rateFromPercentString(s): RateMicro` | `numeric(9,4) → RateMicro` | `'RATE_SCALE_EXCEEDED'` |
| `rateToPercentNumber(r: RateMicro): number` | Alan A → Alan B / float sınırı, **adlandırılmış tek kaçış** | — |
| `moneyToMajorNumber(m: MoneyMinor): number` | API/DTO sınırı (§3.4) | — |

**⟨r2 — K12⟩ Overflow hata mesajı sözleşmesi.** Aşımda neye bakılacağı **mesajın içinde** olmalı:

```
RATE_MULTIPLY_OVERFLOW: 120.000.000,00 TRY × %3,2500 ham çarpımı 2^53'ü aşıyor.
applyRate operandı için tavan 90.071.992 TRY'dir. bigint yeniden değerlendirme
eşiği 50.000.000 TRY — bkz. ADR 0007 §Errata E4 / A9.
```

Kabul testi: eşiği aşan bir çağrının hata mesajı hem `50.000.000` hem `ADR 0007` dizgilerini
içerir (`expect(msg).toMatch(/50\.000\.000/)` + `toMatch(/ADR 0007/)`).

**2⁵³ kontrolü — nerede:**

| Nokta | Kontrol | Aşımda |
|---|---|---|
| Fabrika (`moneyFromMinor`) | `\|n\| ≤ 2⁵³−1` | **hata** |
| `applyRate` / `applyRateExact` | ham çarpım `\|m × r\| ≤ 2⁵³−1` | **hata** — operasyonel tavan 90.071.992 TRY |
| `quantityTimesPrice` | ham çarpım | **hata** |
| `addMoney` / `sumMoney` | her adımda | **hata** |
| DB'den okuma (transformer) | `numeric(18,2)` max (10¹⁶ TRY) > 2⁵³ kuruş → okuma da kontrol eder | **hata** |

**`bigint`'e geçiş bu turda YAPILMAZ.** Gerekçe ölçülmüş: en büyük gerçek tutar 600.000 TRY,
`applyRate` tavanının 150 katı altında. `bigint`'e geçmek TypeORM `numeric` sürücü sınırını,
JSON serileştirmesini (`BigInt` `JSON.stringify` edilemez) ve tüm DTO'ları etkiler — kanıtlanmamış
bir ihtiyaç için orantısız. Kontrat sınırı **yazar ve fırlatır**; aşım gerçekleşirse ayrı karar.
→ A9 eşiği **50 milyon TRY**, hata mesajında taşınır (K12).

### 3.3 S3.3 — Repository sınırı ve `DecimalTransformer`

**Dönüşüm nerede: TypeORM transformer'ında — ama tekil bir sabit değil, ölçek-farkındalı
fabrika ile.** Gerekçe: bir `ValueTransformer` kolon başına bağlanır ve ölçeği **çağrı anında**
bilir; tek bir paylaşılan sabit (`DecimalTransformer` gibi) ölçeği bilemez ve bu yüzden bugün
`Number(value)` yapmak zorunda kalmış.

```ts
// ÖNERİ: src/database/transformers/numeric.transformers.ts   (YENİ dosya)
export const moneyMinorTransformer = (): ValueTransformer => ({
  // K6: YUVARLAMAZ. Tamsayı değilse hata — sessiz yuvarlama sessiz-sıfır sınıfıdır.
  to:   (v?: MoneyMinor | null) => v == null ? v : moneyToDecimalString(v),
  from: (v?: string | null)     => v == null ? v : moneyFromDecimalString(v),
});
export const rateMicroTransformer  = (): ValueTransformer => ({ /* rateTo/FromPercentString */ });
export const priceMinorTransformer = (): ValueTransformer => ({ /* 10⁴ ölçek */ });
```

**Mevcut `DecimalTransformer` — ölçüldü, kim kullanıyor:**

| Entity | Kolon sayısı |
|---|---|
| `budget-allocation.entity.ts` (`:71,81,93,104,114,125,135,148,160`) | 9 |
| `budget-summary.view-entity.ts` (`:136,145,148,151,154`) | 5 |
| `sales-actual.entity.ts` (`:64,74,88`) | 3 |
| `sales-actual-batch.entity.ts` (`:94,104,119`) | 3 |
| `budget-envelope.entity.ts` (`:54,64,73`) | 3 |
| **Toplam** | **5 entity / 23 kolon** |

**Karar: yeniden yazılmaz, yeni eklenir.** Gerekçe:
1. `DecimalTransformer.from` bugün `Number(value)` yapıyor (`decimal.transformer.ts:12`) ve
   `to` **kimlik fonksiyonu** — yani yazma yolunda hiçbir doğrulama yok, PostgreSQL sessizce
   yuvarlıyor. `0010` §S1.1 bunu "ölçümün en önemli tek bulgusu" olarak kaydetmişti.
2. Onu markalı döndürecek şekilde değiştirmek **23 kolonun tüm tüketicilerini** — `budget`
   (7 dosya), `sales-actuals` (9 dosya), `budget-summary` okuyucuları — dönüştürmeyi zorunlu
   kılar. Bu, K9'un (ve görev kısıtının) doğrudan ihlalidir.
3. Bu ayrıca ADR'nin *"Yalnız `DecimalTransformer` uygulamak — reddedildi"* satırıyla tutarlıdır:
   o transformer bir çözüm değil, kaybın merkezîleşmiş hâli.

**Yapılacak (ucuz, K9-uyumlu):** `decimal.transformer.ts`'e `@deprecated` JSDoc + kaybın
nerede olduğunu gösteren tek satırlık atıf; ve `money-float.sh` guard'ının **report** listesine
girmesi (ratchet tabanı). Davranış değişmez.

**Tek geçiş noktası nasıl garanti edilir:** üç katman birlikte:
1. **Dosya tekilliği** — dönüşüm fonksiyonları yalnız `src/common/numeric/` içinde tanımlıdır;
   `index.ts` dışa açılan tek yüzeydir.
2. **Lint** — K4 seçicisi (`as` cast) + fabrika dosyası muafiyeti.
3. **Guard** — `money-float.sh` yeni modül yollarında `Number(`/`parseFloat(`/`toFixed(`/
   `Math.round(` **ve** `src/common/numeric` dışında tanımlanmış ölçek çarpanı literalleri
   (`* 100`, `/ 100`, `1e6`) desenlerini bulgu sayar.

Tek dosya mı, lint kuralı mı? **İkisi de**, çünkü ölçüldüğü üzere hiçbiri tek başına yetmiyor:
dosya tekilliği kopyalamayı engellemez, lint `--fix` akışında koşar ve Done kapısı değildir,
guard AST görmez. Üçü birlikte üç farklı kaçağı kapatır.

### 3.4 S3.4 — DTO / API sınırı

**Karar: API sözleşmesi ONDALIK (major unit, JSON `number`) kalır. Serileştirme noktası, yeni
modülün response mapper'ıdır — global interceptor eklenmez.**

Gerekçe, ölçülmüş üç olgu üzerine:
1. **Frontend'de iş hesabı ve kalıcılaşma yok** (`0012` §S2.1-S2.3): iki yazma yolu da yalnız ham
   girdi gönderiyor (`{version, baseVolume|plannedVolume}`, `{tactics, version}`), backend
   DTO'ları türetilmiş alan kabul etmiyor, RAG ve harcama sunucudan geliyor. 36 `formatCurrency`
   tanımının hiçbiri para üretmiyor.
2. **Tek serileştirme noktası YOK** (`0011` §S2.3): 32 controller, 235 endpoint, global
   interceptor yok, `ClassSerializerInterceptor` yok, response DTO katmanı kısmi (8 dosya),
   `@Transform` kullanımı tüm repoda 6. Bir interceptor eklemek 235 endpoint'in heterojen
   response şekilleri üzerinde **ölçülmemiş** bir risk taşır ve bu ADR'nin kapsamı değildir.
3. Bugün para API'den `number` çıkıyor (`0010` §S4) ve frontend tipleri `number`.

**Ama bu bir karardır, varsayılan değil.** Reddedilen alternatif: para alanlarının `string`
dönmesi (tam temsil uçtan uca). Daha doğrudur; maliyeti 36 formatter + frontend tipleri + 10
response DTO + Swagger sözleşmesi. `0012` frontend'in aritmetik yapmadığını kanıtladığı için bu
maliyet bugün **karşılıksızdır**. Yeniden değerlendirme tetikleyicisi: frontend para üzerinde
bir karar (submit/approve blokajı) üretmeye başlarsa.

**Serileştirme noktası — somut:**

```ts
// ÖRNEK: yeni modülün response mapper'ı (tek dosya, açık dönüşüm)
export function toClaimResponse(c: Claim): ClaimResponseDto {
  return {
    id: c.id,
    // Marka BURADA düşer ve düştüğü yer TEK ve GÖRÜNÜR.
    claimedAmount: moneyToMajorNumber(c.claimedAmountMinor),
    rate:          rateToPercentNumber(c.rateMicro),
  };
}
```

Girdi yönü: DTO alanı `number` (ondalık) gelir, **controller'da değil servis girişinde**
`moneyFromDecimalString(String(dto.amount))` ile markalanır ve ölçek ihlalinde **hata fırlatır**
(sessiz yuvarlama yok). `@Transform` ile DTO'ya gömülmez — çünkü `class-transformer` hatası
`ValidationPipe`'ın 400'üne dönüşür ve mesaj kaybolur; açık dönüşüm tipli bir hata üretir.

### 3.5 S3.5 — `money-float.sh` guard'ı (ADR Karar 8.2)

**Guard YAZILMADI.** Aşağıda ne yapacağı tanımlanıyor. Mevcut altyapıya (`scripts/guards/`)
eklenir; `lib.sh`, `allowlist.txt`, `report_guard`, self-test matrisi disiplinine tabidir.

**Aranan desenler:**

| Sınıf | Desen | Gerekçe |
|---|---|---|
| Float dönüşümü | `parseFloat(` · `Number(` (para/oran bağlamında) | tam→float sınırı |
| Gizli yuvarlama | `toFixed(` · `Math.round(` · `Math.floor(` · `Math.ceil(` | Karar 6: yuvarlama tek noktada |
| Epsilon toleransı | `Math.abs(` ile aynı satırda `0.01` benzeri sabit | Karar 7 |
| Ölçek literali | `* 100` · `/ 100` · `* 10000` · `1e6` — `src/common/numeric/` **dışında** | tek dönüşüm noktası |
| Marka kaçağı | `as MoneyMinor` · `as PriceMinor` · `as RateMicro` — fabrika **dışında** | K4 (lint'in guard karşılığı) |
| Ham operatör | markalı tip bildirimi olan satır yakınında `*` `/` | K5 (E1 telafisi) |

**Bağlam daraltma (yanlış pozitifi yapısal olarak azaltmak — `financial-ordering.sh:47-54`
kalıbı):** yalnız para/oran terimi geçen dosyalar taranır
(`FIN_RE = ledger|budget|agreement|spend|invoice|claim|settlement|recognition|lta|plan|actual|money|rate|amount`).
`*.spec.ts` / `*.e2e-spec.ts` kapsam dışı.

**`block` / `report` ayrımı — YOL BAZLI, işaret dosyası değil.**

```bash
# scripts/guards/money-float.sh  (ÖRNEK yapı — yazılmadı)
BLOCK_PATHS_RE="^src/(common/numeric|modules/shared/claims|modules/shared/recognition|modules/modes/actuals-first/settlement/recognition)/"
# BLOCK_PATHS_RE eşleşen dosya  → bulgu = HATA  (yeni modüller, ADR Karar 8.2)
# eşleşmeyen dosya              → bulgu = RAPOR (mevcut Alan A, ratchet — Karar 3b)
```

Yol bazlı seçildi çünkü:
- **İşaret dosyası (`.exact-arithmetic` gibi) reddedildi:** bir dosyayı taşımak/yeniden
  adlandırmak işareti sessizce düşürür ve guard "0 bulgu" der — `run-all.sh`'in `SKIPPED_BAD`
  ayrımıyla korumaya çalıştığı tam olarak bu sessiz-yeşil sınıfıdır.
- Yol listesi **guard dosyasının içindedir**, yani değiştirilmesi diff'te görünür ve code
  review'a girer.

**Ratchet mekaniği (Karar 3b):**
`scripts/guards/money-float.baseline.txt` — `<dosya> <bulgu-sayısı>` satırları, F0'da bir kez
üretilir ve **commit edilir**. Guard, `report` modundaki bir dosyanın sayısı tabandan **büyükse**
o dosyayı `block`'a yükseltir. Böylece "dokunulan dosyada sayı artamaz" kuralı bir insan
checklist maddesi değil, çalıştırılabilir bir kontrol olur.

**Bugünkü ham taban (ölçüldü, `src`, spec/migration/seed hariç):**

```
parseFloat(  :   9        toFixed(     :  15
Number(      : 345        Math.round(  :   4
Math.floor(  :   6        Math.abs(    :  14
```

`Number(` 345'in tamamı para değil (`0010` §S2.1: 130'u para bağlamı, 212'si sınıflandırılamadı).
Guard bağlam daraltmasıyla bu sayıyı düşürecektir; **gerçek taban F0'da guard koşturularak
ölçülür, buradan tahmin edilmez.**

**Altyapı entegrasyonu (unutulursa guard sessizce koşmaz):**
1. `scripts/guards/lib.sh:23` `GUARD_NAMES_VALID` listesine `money-float` eklenir — aksi hâlde
   allowlist doğrulaması "bilinmeyen guard adı" der (exit 2) ve `run-all.sh` guard'ı hiç çağırmaz.
2. `scripts/guards/fixtures/` altına **pozitif kontrol fixture'ı** (`money-float-probe.ts.fixture`,
   bilerek ihlal içerir) + negatif fixture eklenir; `self-test.sh` `EXPECTED` matrisine satır girer.
   `self-test.sh:11-15`'in gerekçesi birebir geçerli: bozuk bir guard sessizce 0 bulgu döner.
3. `allowlist.txt` başlığındaki "Geçerli guard adları" yorumu güncellenir.

---

## 4. Faz kırılımı

**Faz sayısı 4'te kaldı** (r1 ile aynı). (J1) seçimi F2'yi büyütmedi: JSONB tarafının yüzeyi
`buildMechanicValues` + 2 çağıran imzası ve zaten aynı dosyalarda.

**Bağlayıcı kısıt (K9):** hiçbir faz mevcut 54 Alan A dosyasını tam aritmetiğe **dönüştürmez**.
F2 üç `spend-*` dosyasına **yapısal** dokunur; float ondalık aritmetik korunur, ratchet artmaz.

| Faz | İş | Dosya | Risk | Bağımlılık | Doğrulama | Geri alınabilirlik |
|---|---|---|---|---|---|---|
| **F0** | Guard `money-float.sh` **report** modunda + `baseline.txt` + `lib.sh`/self-test/allowlist entegrasyonu; ESLint marka-cast kuralı (henüz inert) | 6 yeni + 3 düzenlenen · şema **yok** | **düşük** | — | `npm run guards` yeşil (report bulgu basar, bloklamaz); `self-test` matrisi tutar; `npm run lint` temiz | dosyaları sil |
| **F1** | `src/common/numeric/` — **jenerik marka mekanizması** (`ScaleName` + `Scaled<S>` + `SCALE_FACTOR`, A7), fabrikalar, `roundHalfAwayFromZero` (E7), `applyRate` + K12 mesaj sözleşmesi, `allocateLargestRemainder`, ölçek dönüşümleri, 2⁵³ kontrolleri, `MechanicInput` birliği. **Hiçbir tüketici bağlanmaz.** | ~8 yeni + ~8 spec · şema **yok** | **düşük** | F0 | Property testleri: `∀x. round(-x) === -round(x)` (K7) · aynı girdi → kuruşu kuruşuna aynı çıktı, **sıra bağımsız** · `Σ(allocate) === total` · overflow hata mesajı K12 dizgilerini içerir · `round(-2.5) === -3` regresyonu (`Math.round`'a delege edilmediğini kanıtlar) · K3/K4 derleme + lint negatif testleri · **A7 kanıtı:** `ScaleName`'e sahte bir `'volume'` eklendiğinde hiçbir yardımcı imzası değişmiyor | modül dizinini sil |
| **F2** | Migration **`1796000000000`** — `entered_value` → 3 kolon + 2 `CHECK`. **+ (J1):** `buildMechanicValues` → `Map<string, MechanicInput>` (mekanik haritası parametresi, **ek DB round-trip yok**), 2 çağıran imzası, `tactics` çözümlemesi + **mekanik bulunamazsa açık hata**. Entity, `CalculationContext.mechanicValues`, 3 `spend-*` dosyası, `approval-workflow.service.ts:134-137`, `mechanic.seed.ts` formül metinleri. **K13:** `agreements.mechanic_value`'ya dondurma JSDoc'u | ~12 · **şema var** | **YÜKSEK** | F1 · F0 taban | 631 unit / 239 e2e **koşum çıktısıyla** yeşil · `npm run guards` yeşil · **yeni e2e:** (a) `updateFuTactic` ile bir `percentage` + bir `currency` mekaniği → ikisi de doğru semantikle hesaplanır (K1) · (b) iki kolonu birden dolduran `INSERT` DB'de reddedilir (K2) · (c) `spend-*` üçlüsünün ratchet sayısı artmadı (K9) · (d) **K14 sözleşme testi:** `spend-calculation.controller.ts`'in 4 validate endpoint'inin response şekli **değişmedi** · (e) `decimalPlaces` diff'te geçmiyor (K11) | `down()` üç kolonu düşürür, `entered_value` geri gelir — `plan_mechanic_values`=0, `plan_fus`=0 → kayıpsız |
| **F3** | Migration **`1797000000000`** — oran ölçeği: `lta_rates` ×2, `lta_plan_overrides` ×2, `mechanics.max_combined_discount_percentage` (**errata E8**) + aralık `CHECK`'leri. Entity `precision/scale` güncellemesi | ~5 · **şema var** | **düşük** | F2 (aynı dosyalarda çakışmayı önlemek için sıralı) | `migration:run` + `migration:revert` çift yönlü koşar · 631/239 yeşil · `lta-agreement.service.ts:473` doğrulaması 4 ondalıklı bir oranı artık kaybetmeden işliyor | `down()` daraltır — tablolar **boş** olduğu sürece güvenli; **dolmadan önce** geri alınmalı |

**Sıra gerekçesi (ADR "Uygulama sırası"ndan bilinçli sapma):** ADR 1) Karar 4, 2) Karar 5,
3) yardımcılar diyor. F1 (yardımcılar) F2'nin **önüne** alındı: F2'nin TS tarafı `MechanicInput`
birliğini ve markalı tipleri kullanacak; ters sırada `spend-*` üçlüsü **iki kez** dokunulur ve
K9'un ratchet ölçümü iki kez sıfırlanır. Sıra iyileştirmesi, karar değişikliği değil.

**F0'ın ADR'den erken çekilmesi:** ADR guard'ı adım 4'e koyuyor. F2 Alan A dosyalarına dokunduğu
an ratchet tabanı gerekir; taban dokunuştan **sonra** alınırsa ratchet ölçmek istediğini ölçemez.

**⛔ Hiçbir faz A10'u uygulamaz.** İki sınır doğrulaması F2'de **korunur ve birleştirilmez**
(K14); ikisi de ayrımlı birliği okuyacak şekilde uyarlanır, davranışları değişmez.
Kanoniklik ve çağıran envanteri ayrı bir turun işidir.

**Her faz sonunda (K10):** `npm run guards` yeşil · `npm test` + `npm run test:e2e` koşum
çıktısıyla yeşil · `npm run lint` temiz · `collmind.backend` çalışma ağacı yalnız o fazın
dosyalarını içerir.

---

## 5. Riskler

| # | Risk | Şiddet | Karşı önlem |
|---|---|---|---|
| **R1** | **Marka operatörü durdurmuyor** (errata E1). `m * r` derlenir ve düz `number` yuvasına akar. | 🔴 yüksek | K3 (her yuva markalı) + K5 (guard ham operatörü tarar) + F1 property testleri. **ADR'ye errata olarak işlendi.** |
| **R2** | **JSONB'de DB zorlaması yok.** (J1) bunu açıkça kabul ediyor; (J2) de kapatamıyordu (§1.5). Yanlış ölçekte bir sayı `plan_fus.tactics`'e yazılabilir. | 🔴 yüksek | Semantik `buildMechanicValues`'ta pinlenir; mekanik bulunamazsa **açık hata** (bugünkü sessiz `if (val != null)` kabulü kalkar). F2 kabul kriteri (a). |
| **R3** | **Üçüncü/dördüncü dağıtım implementasyonu.** | 🟡 orta | **Errata E6:** Karar 6 kanonik ilan edildi, dördüncü kural yazılmaz; `allocateLargestRemainder` yalnız yeni modüllere; `computeLumpsumDistribution` değişmez (K9). Yakınsama ayrı iş. |
| **R4** | **Formül metni sözleşmesi kayıyor.** `mechanics.calculation_formula` admin'e açık, hiçbir tüketicisi yok. | 🟡 orta | **A5:** [[T-071]] kapsamına alındı. F2 seed metinlerini yine de tutarlı tutar. |
| **R5** | ~~`decimal_places` ile kolon ölçeği çelişir.~~ ⟨r2: kapsam dışına çıktı⟩ | 🟢 — | **A5/K11:** `decimal_places` [[T-071]]'e devredildi; F2/F3 onu okumaz/doğrulamaz. Yarım doğrulama "alan çalışıyor" izlenimi verirdi. |
| **R6** | **`down()` penceresi kapanır.** F3'ün daraltma yönü tablolar dolduğunda kayıplı olur. | 🟢 düşük | Faz kabulüne not; pilot açılışı kapanış tetikleyicisi |
| **R7** | ~~Yuvarlama negatifte tanımsız.~~ ⟨r2: KAPANDI⟩ | 🟢 — | **Errata E7:** half-away-from-zero, `\|round(x)\| = round(\|x\|)`. K7 regresyon testi `Math.round` delegasyonunu yasaklar. |
| **R8** | **Guard yanlış pozitif seli → guard kapatılır.** `Number(` bugün 345 kez geçiyor. | 🟡 orta | F0 **report** modunda; bağlam daraltma; taban **ölçülerek** belirlenir |
| **R9** | **Yeni modül `number` alanla doğar.** K3 kod incelemesine bırakılırsa unutulur. | 🟡 orta | Guard'da "yeni modül yolunda `amount`/`rate` adlı `number` alanı" deseni; F1'in entity örneği şablon |
| **R10** | **⟨r2 — YENİ⟩ A10 askıda kaldığı için iki sınır doğrulaması yan yana yaşamaya devam ediyor.** İkisi farklı hata biçimi üretiyor; biri ölü kod. F2 ikisine de dokunuyor. | 🟡 orta | K14: davranış **değişmez**, sözleşme testi (F2 kabul kriteri (d)) kilitler. Envanter ayrı turda. |
| **R11** | **Multi-tenant / performans:** yeni sorgu, join veya cache yok; `buildMechanicValues`'ın mekanik parametresi **zaten yüklü** listeden geliyor (`plan.service.ts:2083`, `spend-calculation.service.ts:721`) → **0 ek round-trip**. `applyRate` işlem başına ~1 çarpma + 1 bölme. | 🟢 düşük | F2 sonrası `recalc-perf-regression.e2e-spec.ts` koşulur |

**BRD ihlali riskleri (mevcut, bu tasarımın açtığı değil — kayıt için):**
- `spend-validation.service.ts:28-31` dört oran eşiğini koda gömüyor → *"threshold asla hardcode"*
- `budget-allocation.service.ts:945` `// TODO: block plan submission` → CLAUDE.md §2.3 "%100+ block"
  **uygulanmıyor** (A6 → ayrı task)
- `mechanics.calculation_formula` yazılıyor ama okunmuyor; hesap `spend-calculation.service.ts:132`
  switch'inde gömülü → *"hesaplamalar asla hardcode edilmez"* (A5 → [[T-071]])
- `plan.service.ts:2692-2705` (`GET /plans/:id/analysis`) yüzde ile TRY'yi tek "spend" toplamında
  karıştırıyor; Category Manager'a açık (`0012` R2 sınıfı)

---

## 6. Reddedilen alternatifler

**(b) Tek kolon + açık semantik kolonu — reddedildi.**
Ayırıcı sayısını beşten altıya çıkarır. Ölçülen beş ayırıcı (`mechanics.category`,
`mechanics.input_type`, `mechanics.mechanic_type`, `plan_mechanic_values.distribution_method`,
`agreements.mechanic_type`) bugün **farklı dosyalarda farklı kararlar veriyor**; hiçbiri
diğerinin doğruluğunu zorlamıyor. ADR Karar 4'ün *"markalı tip tek kolona bağlanamaz"*
cümlesiyle de doğrudan çelişir.

**(c) Tablo bölünmesi — reddedildi.**
(a2)'nin tüm garantilerini verir, ~%60 daha fazla dosya değiştirir ve
`@Index(['planFuId','mechanicId'], {unique:true})` (`plan-mechanic-value.entity.ts:21`)
"aynı mekanik iki kez" ihlalini iki tabloda **artık zorlayamaz**. DB zorlamasını bir yerde
kazanıp başka yerde kaybediyor.

**(a1) İki kolon (`entered_amount` tek para kolonu) — reddedildi.**
`PER_UNIT_SUPPORT` bir birim fiyat (10⁴), `LUMPSUM_SPEND` bir toplam tutar (10²). Tek kolon bu
iki ölçeği yeniden içine alır — Karar 4'ün çözdüğü problemin küçük ölçeklisi.

**`entered_amount_minor` (tamsayı kuruş) — reddedildi.**
Görev metnindeki seçenek (a) bu adı öneriyor; ancak ADR Karar 3a tamsayı minor unit'i **yeni
modüllere** tahsis ediyor, Karar 3b mevcut Alan A'yı ratchet'e bırakıyor.
`plan_mechanic_values` mevcut bir Alan A tablosudur ve tek okuyucusu `spend-calculation.service.ts`
(97 para aritmetiği). `bigint` kuruş yapmak o dosyayı karışık temsile sokar
(`enteredAmountMinor` kuruş × `plannedVolume` birim → kuruş, ama `totalSpend` ondalık TRY) —
**tam olarak K9'un ve ADR Karar 3'ün yasakladığı dönüşüm.** Bölme bir **semantik** işidir,
temsil işi değildir; temsil ratchet'e aittir.

**`DecimalTransformer`'ı yeniden yazmak — reddedildi (bu turda).**
5 entity / 23 kolon üzerinden `budget` (7 dosya) ve `sales-actuals` (9 dosya) tüketicilerini
dönüştürmeyi zorunlu kılar → K9 ihlali. Yerine `numeric.transformers.ts` eklenir; eski
transformer `@deprecated` işaretlenir ve ratchet tabanına girer.

**`RateBps` adının korunması — reddedildi.**
Baz puan = %0,01. ADR'nin seçtiği 4 ondalıklı yüzde çözünürlüğü **0,01 bps**'tir. `RateBps`
adlı bir tamsayının `32500` tutması, adının `325` vaat etmesine rağmen 100 katlık okuma hatası
davetiyesidir. Adı korumak, Karar 5'in 4 ondalık kararını 2'ye indirmeyi gerektirirdi — kabul
edilmiş bir kararı ters çevirmek bu belgenin yetkisi değildir. **`RateMicro`** seçildi.

**Global response interceptor ile API'yi kuruşa çevirmek — reddedildi.**
235 endpoint, heterojen response şekilleri (entity / ham nesne / iç içe dizi), global
serileştirme katmanı yok (`0011` §S2.3). Ölçülmemiş bir yüzeyde tek noktalı bir dönüşüm,
sessiz yanlış tutar üretmenin en verimli yoludur. API ondalık kalır (§3.4).

**`bigint` TS temsili — reddedildi (bu turda).**
Gerçek veri `applyRate` tavanının 150 katı altında (600.000 TRY vs 90.071.992 TRY). `bigint`
`JSON.stringify` edilemez, TypeORM `numeric` sürücü yolu ve tüm DTO'lar etkilenir. Kontrat
sınırı **yazar ve aşımda fırlatır**; yeniden değerlendirme eşiği **50 milyon TRY** (A9 / errata E4)
ve bu eşik hata mesajının içindedir (K12).

**(J2) `plan_fus.tactics` JSONB şeklini değiştirmek — reddedildi.** ⟨r2⟩
Belirleyici olgu: JSONB'de anahtar başına ölçek kısıtı **PostgreSQL'de ifade edilemez**, yani
(J2) (J1)'in üstüne **tek bir DB garantisi eklemiyor**. Eklediği tek şey okunabilirlik;
bedeli API sözleşmesinin kırılması (`PlanningGridEnhanced.tsx:1032` + DTO + e2e).
Zorlama kazancı olmayan breaking change kötü takas. Ayrıca JSONB'yi ikinci bir semantik kaynağa
dönüştürerek T-052'nin "tek türetim noktası" kararını zayıflatırdı.

**(J3) JSONB'yi bu turun dışında bırakmak — reddedildi.** ⟨r2⟩
Errata E2 tam olarak "kolon bölmek yetmez" diyor: canlı yol (tactics-PATCH) hiç değişmezdi ve
Karar 4 boşa çıkardı.

**`Math.round`'a delege eden yuvarlama — reddedildi.** ⟨r2 — errata E7⟩
`Math.round(-2.5) === -2` (+∞'a yuvarlar), `Math.round(-0.5) === -0`. E7'nin
`|round(x)| = round(|x|)` kuralını **karşılamıyor**. K7 regresyon testi bu delegasyonu yasaklar.

**A10'un uygulanması — DUR edildi (reddedilmedi).** ⟨r2⟩
Karar geçerliliğini koruyor ama dayandığı olgu ölçümle çürüdü (§Karar). Ajanın kararı tersine
çevirme yetkisi yok; askıya alındı ve ölçüm ürün sahibine sunuldu.

**`big.js` — ADR'de zaten reddedildi**, burada yeniden açılmadı.

---

## 7. Kararlar (kapandı) ve açık kalanlar

### 7.1 Kapanan kararlar — r2'de işlendi

| # | Karar | Nereye işlendi |
|---|---|---|
| **A1** | ADR errata (E1–E8) | `docs/decisions/0007-sayisal-kontrat.md` §Errata (2026-08-03) — v3 metni **silinmedi**, 56 satır **eklendi** |
| **A2** | Yuvarlama: **half-away-from-zero** | errata E7 · K7 · §3.2 davranış tablosu + regresyon testi |
| **A3** | `max_combined_discount_percentage` → Karar 5 kapsamında | errata E8 · §2.2 tablo · §2.3 migration |
| **A4** | `agreements.mechanic_value` **dondurulur** | K13 · §1.2 · F2'de JSDoc |
| **A5** | `calculation_formula` + `decimal_places` → [[T-071]] | K11 (değişti) · §1.3 · R4/R5 |
| **A6** | `threshold_percent` bugün Alan A dışında; Karar 2 genelleştirildi | errata E5 · §2.2 |
| **A7** | `VolumeMilli` bu turda dışarıda, **mekanizma genişlemeye açık** | §3.1 (1)(2)(3) kuralları · F1 kabul kriteri |
| **A9** | `bigint` eşiği **50 milyon TRY**, hata mesajında | errata E4 · **K12** · §3.2 mesaj sözleşmesi |
| **E2** | JSONB kapsamı → **(J1)**, F2'ye girer | **§1.5** · K1 · §4 F2 |

### 7.2 ⛔ Askıda — ürün sahibine geri dönen

| # | Konu | Durum |
|---|---|---|
| **A10** | Kanonik sınır doğrulaması | **ASKIDA.** Kararın iki gerekçesi de ölçümle tersine döndü: seçilen `spend-calculation.service.ts:874-918` **exception fırlatmıyor** (`errors.push(string)` + dönüş) ve **üretimde hiçbir çağıranı yok** (yalnız kendi spec'i); reddedilen `spend-validation.service.ts:49-182` **4 canlı HTTP endpoint** besliyor ve yapılandırılmış `ValidationError` döndürüyor. **Gereken:** çağıran envanteri + yeniden karar. F2'de ikisi de korunur (K14). |

### 7.3 Hâlâ açık

| # | Konu | Gereken |
|---|---|---|
| **A8** | ADR 0006 (lumpsum artığı = en büyük base volume) ↔ Karar 6 (largest remainder + iş anahtarı) yakınsaması | Errata E6 Karar 6'yı kanonik ilan etti ve yakınsamayı **ayrı iş** saydı. Yakınsama planı ve ADR 0006 güncellemesi hâlâ yazılmadı. |
| **O1** | `spend-validation.service.ts:28-31` dört hardcoded oran eşiği | BRD "threshold asla hardcode" ihlali; `BudgetThresholdService`'in config-driven değerini yok sayıyor. Ayrı task. |
| **O2** | Ratchet tabanının **gerçek** sayısı | F0'da guard koşturularak ölçülür; bu belgedeki ham sayılar (`Number(` 345 vb.) bağlam daraltması **öncesidir** ve taban değildir. |

### 7.4 Açılması önerilen task'lar

| Öneri | Kapsam | Kaynak |
|---|---|---|
| **`agreements.mechanic_value` dondurma** | Entity JSDoc + "yazılmadan önce ADR 0007 ölçek kontratına bağlanmalı" notu; yol tamamlanırsa ölçek kararı önce verilir | A4 / K13 |
| **Bütçe %100 blok TODO'su** | `budget-allocation.service.ts:945` `// TODO: block plan submission if hard limit mode` — CLAUDE.md §2.3 "%100+ Exceeded (block)" uygulanmıyor. Bloklarsa errata E5 uyarınca karar değeri Alan A'da yeniden üretilir | A6 |
| **Dağıtım artığı yakınsaması** | İki mevcut implementasyon + üç kural → Karar 6'ya yakınsama; ADR 0006 Karar 2 ile uyum | E6 / A8 |
| **Sınır doğrulaması çağıran envanteri** | 4 HTTP endpoint'in gerçek tüketicileri (frontend + e2e); sonra kanoniklik kararı | A10 |
| *(mevcut)* **[[T-071]]** | `calculation_formula` + `decimal_places` + `0012` R3 (8 gömülü formül) + R4 — *dinamik formül ilkesi uygulanacak mı, yoksa BRD'den mi düşecek?* | A5 |

---

## Ekler — ölçüm ham çıktıları

**Tablo doluluğu** (`docker exec collmind-tpm-postgres psql -U postgres -d collmind_tpm`):
`plan_mechanic_values` 0 · `lta_rates` 0 · `lta_plan_overrides` 0 · `plans` 0 · `mechanics` 6 ·
`agreements` 3 · `budget_alert_configurations` 3 · `ledger_entries` 1231 (0 negatif, min 3000,00 max 12000,00) ·
`budget_transactions` 4 (0 negatif, min 75000,00 max 500000,00) · `agreement_transactions` 0

**`mechanics` (6/6) — ayırıcı tutarlılığı:**
```
 code         | category             | input_type | mechanic_type   | decimal_places | min    | max
 CPP_OFF_PCT  | off_invoice_discount | percentage | PERCENT         | NULL           | 0.0000 | 100.0000
 CPP_ON_PCT   | on_invoice_discount  | percentage | PERCENT         | NULL           | 0.0000 | 100.0000
 MEC-DISCOUNT | on_invoice_discount  | percentage | PERCENT         | NULL           | 0.0000 | 100.0000
 DISPLAY_FEE  | lumpsum_spend        | currency   | AMOUNT          | NULL           | 0.0000 | NULL
 VIS_LS       | lumpsum_spend        | currency   | AMOUNT          | NULL           | 0.0000 | NULL
 PRICE_SUP    | per_unit_support     | currency   | AMOUNT_PER_UNIT | NULL           | 0.0000 | NULL
```

**`agreements` (3/3):** `mechanic_type` NULL, `mechanic_value` NULL, `cap_total_amount`
50.000 / 75.000 / 150.000, `spend_type` OFF_INVOICE

**Referans sayımları** (`src`, spec + migration hariç): `enteredValue|entered_value` **86** /
7 dosya · `plan_fus.tactics` **16** / 9 dosya · `mechanicValues` **19** / 3 dosya ·
`minValue|maxValue` **52** / 7 dosya (4'ü çapraz-semantik karşılaştırma) ·
`defaultValue|stepIncrement` **8** / 3 dosya (**0 tüketici**) · `agreements.mechanicValue` **5** / 4 dosya

**`DecimalTransformer` tüketicileri:** 5 entity / 23 kolon

**TypeScript 5.9.3 marka davranışı:** §3.1 tablosu · **ESLint 8.57.1 cast seçicisi:** 3/3 yakaladı, 0 yanlış pozitif

**Migration:** son kullanılan `1795000000000`; bu tasarımın tahsisi `1796000000000` (F2),
`1797000000000` (F3)

**⟨r2 ek ölçümler⟩**

`buildMechanicValues` üretim çağıranı: **2** — `plan.service.ts:2134`,
`spend-calculation.service.ts:706`. Her ikisinde mekanik listesi **zaten yüklü**
(`plan.service.ts:2083` `getActiveMechanics`, `spend-calculation.service.ts:721`) → (J1) için
**0 ek DB round-trip**.

`plan_fus` = **0**, `plan_skus` = **0** → JSONB backfill hacmi sıfır.

Frontend `tactics` **yazma** noktası: **1** — `PlanningGridEnhanced.tsx:1032`
`tactics: { [mechanicCode]: value }` (frontend SHA `5cf0bd2`).

A10 envanteri: `SpendValidationService`'in 4 metodu yalnız `spend-calculation.controller.ts:112-167`
tarafından çağrılıyor (4 HTTP endpoint). `validateSpendCalculations`'ın üretim çağıranı **yok**
(yalnız `spend-calculation.service.spec.ts:871`).
