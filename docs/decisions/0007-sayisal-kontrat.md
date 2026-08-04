# 0007 — Sayısal kontrat: para aritmetiği ile analitik aritmetiğin ayrılması

- **Durum:** Kabul edildi (Accepted)
- **Geçerlilik tarihi:** 2026-08-03
- **Karar veren:** Sertaç Tuzcu (ürün sahibi)
- **Sürüm:** v3. v1 ve v2 commit edilmedi; farkları §Sürüm geçmişi'nde.
- **Kanıt:** `docs/analysis/0010-numeric-contract-measurement.md` ·
  `0011-integer-minor-unit-feasibility.md` · `0012-frontend-calculation-layer.md`
- **⚠️ ERRATA VAR — v3 metnine olduğu gibi güvenmeyin.** Karar 2, 3a, 4, 5, 6 maddelerinde
  ölçümle çürütülmüş ifadeler bulundu ve düzeltildi. Aşağıdaki v3 metni **tarihsel kayıt**
  olarak olduğu gibi korunmuştur; bağlayıcı olan, §Errata ile düzeltilmiş hâlidir.
  → [§Errata (2026-08-04)](#errata-2026-08-04) · kanıt: `docs/analysis/0013-numeric-contract-design.md`
- **İlgili:** `docs/contracts/SYSTEM_INVARIANTS.md` → `INV-N-002`, `INV-N-003`, `INV-R-007`,
  `INV-R-008`, `INV-B-002` · D-05 · açtığı karar: D-07

---

## Bağlam

### Veritabanı zaten doğru

Para `numeric(18,2)`. PostgreSQL `numeric` **tam ondalık** aritmetiktir ve
`v_budget_summary` toplaması **SQL'de** yapılıyor — yani toplama tam.

Kayıp TypeORM sınırında: `numeric` sürücüden string gelir, kod `number`'a çevirir, karar
IEEE 754'te verilir. Kanonik örnek, CAP kontrolü:

```
SQL SUM (tam) → parseFloat (ledger.repository.ts:120) → float karşılaştırma
                                                        (agreement-transaction.service.ts:102)
```

### Ölçülen büyüklük

| | |
|---|---|
| Alan A dosya sayısı | 54 |
| Para bağlamlı `Number()` | 130 · `parseFloat` 9 |
| Tamsayı yolunda dönüşecek kolon | 57 (+11 ≈ 68), 23 tabloda |
| Tamsayıda kayıpsız hâle gelen çağrı | ~%60–70 |
| Gereken tamsayı ölçeği | **3** — para ×100, hacim ×1000, fiyat ×10000 |
| `0.01` epsilon toleransı | 6 |
| Frontend para dokunma noktası | 36 formatter · **iş hesabı yok, kalıcılaşma yok** |
| `big.js` maliyeti | 198× kat, mutlak etki +%1,2–8,0 (sıcak yol I/O-bound) |

### Dürüst çerçeve

`INV-N-002` **kanıtlanmış bir yanlış para tutarı değildir.** İki bağımsız ölçüm mekanizmayı
kanıtladı — birikimli hata (`1000 × 0.07 = 69.99999999999966`), tam→float sınırı, altı epsilon
toleransının varlığı — ama canlı bir hatalı tutar gösterilemedi.

Karar yine de veriliyor, üç sebeple:

1. **Altı epsilon toleransı bir teşhistir.** Tam aritmetikte kimse epsilon yazmaz.
2. **D-07 bu karara bağlı.** Recognition dağıtımı (`INV-R-007`, `INV-R-008`) kuruşu kuruşuna
   deterministik olmak zorunda; sayısal kontrat olmadan yazılamaz.
3. **Şema penceresi açık.** Deploy edilmiş ortam yok, pilot kapalı, `claims` /
   `recognition_variance` / settlement tabloları **henüz yazılmadı.**

---

## Karar

### Karar 1 — İki alan, sınır Alan A'nın dışında

**Alan A — Para (tam aritmetik zorunlu)**
`ledger` · `budget` · `agreement` ve `agreement-transaction` · CAP karşılaştırmaları ·
**`spend-calculation` (tümüyle)** · claim, settlement, recognition · fatura eşleştirme toleransı.

**Alan B — Analitik (kayan nokta kabul)**
`kpi-engine` (`safeEval` zinciri) · ROI, oran, yüzde göstergeleri · RAG · raporlama türevleri.

**Sınır kuralı (bağlayıcı):**

> Alan A → Alan B geçişi serbesttir.
> **Alan B'nin çıktısı para olarak kalıcılaştırılamaz ve bir para eşiğiyle karşılaştırılamaz.**
> B'den A'ya dönüş için değer Alan A'da yeniden üretilmelidir.

`spend-calculation` `safeEval` kullanmıyor; para üretiyor, çıktısı `plans.total_spend`'e
kalıcılaşıyor ve `reserveForPlan`'a gidiyor. Alan A'nın parçasıdır.

### Karar 2 — RAG sert bir para kapısına dönüştürülemez

Bugün RAG onay akışında yalnızca `warnings.push` yapıyor
(`approval-workflow.service.ts:148`) — bloklamıyor. **Bu yumuşaklık korunur.**

RAG'ı bir onayı veya rezervasyonu **bloklayan** kapıya dönüştürmek istenirse, karar değeri önce
Alan A'da yeniden üretilmelidir.

*Gerekçe:* float bir eşiğin para hareketini durdurması, Karar 1'in sınırını delmenin en olası
ve en fark edilmez yoludur.

### Karar 3 — Kapsam: yeni kod tam, mevcut kod ratchet ile

Tek seferlik 57–68 kolonluk dönüşüm **yapılmaz.** Bunun yerine:

**3a — Yeni modüller tam temsille doğar.** `claims`, `recognition_variance`, settlement ve
recognition dağıtımı: **tamsayı minor unit (kuruş) + markalı tip**, repository sınırında
`numeric(18,2)`'ye dönüşüm.

```ts
type MoneyMinor = number & { readonly __scale: 'money' };   // kuruş
type RateBps    = number & { readonly __scale: 'rate'  };   // baz puan
```

`MoneyMinor * RateBps` derleme hatası olur; çarpma yalnız ölçek dönüşümünü bilen yardımcıdan
geçer. Çalışma zamanı maliyeti sıfır.

*Gerekçe:* `0011`'in bulduğu **üç ölçek** problemi (para ×100, hacim ×1000, fiyat ×10000) eski
şemanın mirasıdır. Recognition'ın dünyası **iki** ölçek taşır — para ve oran — ikisi de yeni,
ikisi de markalanabilir, tek modülde kapalı. Ayrıca largest-remainder dağıtımı (Karar 6) doğal
olarak tamsayı aritmetiğidir: kuruşa floor'la, artığı dağıt.

> Bu, C'nin bir temsil kararı **vermediği** eleştirisine cevaptır. C bir kapsam seçeneğidir;
> temsil seçimi burada açıkça yapılmıştır.

**3b — Mevcut Alan A kodu ratchet ile dönüşür.** `money-float.sh` guard'ının rapor-modu taban
sayısı kaydedilir. Done checklist'ine madde girer:

> Dokunulan Alan A dosyasında para-float bulgu sayısı **artamaz**.

Dokunulan dosya dönüşür, dokunulmayan bekler, sayı tek yönde hareket eder.

*Gerekçe:* "fırsatçı" tetikleyicisiz bırakılırsa "asla" demektir. Recognition çalışmaya
başladığında 54 eski dosya kimsenin önceliği olmaz.

**3c — İki şema işi bu ADR'nin kapsamındadır** (Karar 4, 5). Bunlar pencere kapandığında
gerçekten pahalılaşan işlerdir; 57 kolonluk okuma disiplini değil.

### Karar 4 — `entered_value` polimorfizmi çözülür

`plan_mechanic_values.entered_value` `numeric(18,4)`, mekanik kategorisine göre iki semantik:

| Kategori | Tüketim | Semantik |
|---|---|---|
| `ON_INVOICE_DISCOUNT` / `OFF_INVOICE_DISCOUNT` | `(base × v) / 100` | oran |
| `PER_UNIT_SUPPORT` | `v × plannedVolume` | para |
| `LUMPSUM_SPEND` | `totalSpend: v` | para |

Ayırıcı (`mechanics.input_type`) mevcut, dolu, 6/6 tutarlı. Yüzey dar: 86 referans, 7 dosya.
Aynı polimorfizm `mechanics.default_value` / `min_value` / `max_value` / `step_increment` ve
`agreements.mechanic_value`'da da var.

**Kolon semantiğine göre bölünür.** Tek kolon iki ölçek taşıyamaz; markalı tip de tek kolona
bağlanamaz. Bu, **her sayısal yolun ön koşuluydu** — tamsayıya özgü bir ceza değildir.

### Karar 5 — Oran ölçeği kanonikleştirilir

Oranlar **yüzde notasyonunda** (0–100), kesir değil. Üç bağımsız kanıt:
`lta-rate.entity.ts:34,42`, `lta-agreement.service.ts:473` (`> 100` kontrolü), formüllerde `/ 100`.

Bugün aynı kavram iki ölçekte: LTA oranları `numeric(5,2)` (%3,255 sığmaz),
`entered_value` `numeric(18,4)`.

**Kanonik ölçek: 4 ondalık** (baz puan hassasiyeti). LTA oran alanları `numeric(9,4)`'e
yükseltilir. Alan A içinde oran `RateBps` olarak taşınır.

### Karar 6 — Yuvarlama ve dağıtım

**Yuvarlama:** ölçek 2 ondalık (TRY kuruş) · mod **half-up** · yalnızca **kalıcılaştırma
anında**, ara hesapta yuvarlama yok · tek yardımcı fonksiyondan geçer, dağınık
`toFixed`/`Math.round` yasak.

*Half-up gerekçesi:* ticari mutabakatta beklenen davranıştır ve müşteriye açıklaması kolaydır.
Bankacı yuvarlaması reddedildi.

**Dağıtım artığı — largest remainder:**
```
1. Her parça için tam pay, kuruşa floor
2. Artık = toplam − Σ(yuvarlanmış paylar)
3. Artığı, kesirli kısmı en büyük olan parçalara kuruş kuruş dağıt
4. Eşitlikte iş anahtarı: agreement başlangıç tarihi, sonra agreement kodu.
   Üretilmiş id (uuid) ile sıralama YASAK (INV-N-001)
```
Toplam korunur, dağılım orantıya en yakın kalır, sonuç deterministiktir (`INV-R-008`).

**2⁵³ sınırı:** JS `number` 9.007.199.254.740.991'e kadar tamdır. Gerçek veri bunun 8 mertebe
altında (en büyük tutar 600.000 TRY). Ölçek çarpımı 1e6 birim × 100 TRY'de 2⁵³'ün %11'ine
ulaşır. **Kontrat bu sınırı yazar:** tek bir `MoneyMinor` değeri 2⁵³'ü aşamaz; ara çarpımlar
ölçek dönüşüm yardımcısından geçer ve sınır orada kontrol edilir.

### Karar 7 — Epsilon toleransları dönüşümle **birlikte** kaldırılır

Altı `0.01` toleransı float aritmetiğinin telafisidir. Alan A tam aritmetiğe geçtikçe karşılık
gelen tolerans **aynı commit'te** kaldırılır — önce değil, sonra değil.

*Gerekçe:* erken kaldırmak çalışan karşılaştırmaları kırar; geç kaldırmak faydayı gizler.

> Fatura eşleştirme toleransı (K3, ±%5) kapsam **dışıdır** — o bir iş kuralıdır, temsil hatası
> telafisi değil.

### Karar 8 — Zorlama: tip > guard > test

1. **Tip** — yeni modüllerde markalı tipler. Derleyici en güçlü kapıdır.
2. **Guard** — `money-float.sh`: `parseFloat` / `Number(` / `toFixed` / `Math.round`.
   Yeni modüllerde `block`, mevcut Alan A'da `report` + ratchet (Karar 3b).
   Mevcut guard altyapısına eklenir; aynı allowlist, self-test ve fixture disiplinine tabidir.
3. **Test** — dönüştürülen ve yeni yazılan her yol için property-based test: aynı girdi →
   kuruşu kuruşuna aynı çıktı, sıra bağımsız.

---

## Sonuçlar

**Olumlu**
- D-07 (recognition dağıtımı) **hemen** açılır — TPM olgunluğunun en büyük boşluğu
- Korunum matematiği (`INV-R-007`) doğduğu anda tam temsille doğar
- Şema penceresi doğru işler için kullanılır (Karar 4, 5)
- Yeni bağımlılık yok
- Frontend değişmez — `0012`: iş hesabı yok, kalıcılaşma yok

**Olumsuz / maliyet**
- **İki temsil bir arada yaşar.** Sınır modül sınırıdır (yeni tam, eski değil), dosya içi
  karışma değil — ama sınırda dönüşüm disiplini gerektirir
- Markalı tip tasarımı ön yatırım ister
- Ratchet, dönüşümü uzun bir kuyruğa yayar; 54 dosyanın bir kısmı uzun süre float kalır

**Riskler**
- **R1 — Sınır sızıntısı.** Karar 2 ve Karar 8.1 hedefliyor
- **R2 — Ratchet uygulanmazsa "fırsatçı" = "asla".** Done checklist'i tek koruma; guard taban
  sayısı düzenli raporlanmalı
- **R3 — İki temsilin sınırında dönüşüm hatası.** Repository sınırı tek geçiş noktası olmalı

---

## Değerlendirilen alternatifler

**A — Tamsayı minor unit, tam dönüşüm (57–68 kolon) — reddedildi.**
En güvenli son durum. Ama iki bağımsız ölçüm canlı bir yanlış para tutarı gösteremedi;
kanıtlanmamış bir risk için 23 tabloluk bir dönüşümü ürün işinin (D-07) önüne koymak
orantısız. A'nın C'ye karşı tek benzersiz kazanımı DB'nin kesirli değeri reddetmesidir — bu da
yalnız yazma yolunda yuvarlama unutulursa devreye girer, ve tek yuvarlama yardımcısı + guard o
deliği kapatıyor. Ayrıca yarım kalamaz: bazı kolonlar minor unit, bazıları değilse sessiz ve
katastrofik hata olur.
*Tersinmezlik asimetrisi belirleyici oldu:* yanlış C'den dönmek ucuz (recognition zaten doğru
temsille yazılmış olur, kalan dönüşüm küçülmüştür); yanlış A'dan dönmek yeniden-migration'dır.

**B — `big.js`, aşamalı — reddedildi.**
Tek avantajı aşamalılıktı; Karar 3 aynı aşamalılığı daha az maliyetle veriyor. Geriye kalanı:
139 çağrının hepsi değişir (en büyük yüzey), `.toNumber()` **sessizce kayıplıdır** ve native `+`
string birleştirir — koruma lint'e emanet. Sessiz-kayıplı bir varsayılan işlemi bilerek içeri
almak, `CLAUDE.md §2.5`'in yasakladığı sınıfı kabul etmek olurdu.

**Yalnız `DecimalTransformer` uygulamak — reddedildi.**
v1'in önerisiydi. Ölçüm gösterdi ki transformer `from` içinde `Number(value)` yapıyor;
uygulanması `INV-N-002` üzerinde **sıfır etki** yapar, yalnız kaybı merkezileştirir.
Kullanılacaksa önce yeniden yazılmalıdır.

**Hiçbir şey yapmama — reddedildi.**
D-07 bu karar olmadan yazılamıyor.

---

## Uygulama sırası

1. **Karar 4** — `entered_value` ve kardeş kolonların semantik bölünmesi ⟨her yolun ön koşulu⟩
2. **Karar 5** — oran ölçeği `numeric(9,4)`, `RateBps` tanımı
3. **Markalı tipler + yardımcılar** — yuvarlama, largest-remainder dağıtımı, ölçek dönüşümü,
   2⁵³ sınır kontrolü
4. **`money-float.sh` rapor modunda** → ratchet tabanı kaydedilir (Karar 3b)
5. **CAP yolu** — `ledger.repository.ts:120` + `agreement-transaction.service.ts:102`.
   En dar yüzey, en yüksek getiri. İlgili epsilon Karar 7 uyarınca birlikte kaldırılır
6. **D-07 açılır** — recognition dağıtımı, doğduğu anda tam temsille
7. Ratchet işler; `spend-calculation` ve ledger/budget dokunuldukça dönüşür

---

## Errata (2026-08-04)

- **Kaynak:** `docs/analysis/0013-numeric-contract-design.md` (architect, tek tasarım turu)
- **Ölçüm ortamı:** backend SHA `0b6518e` · TypeScript **5.9.3** · ESLint 8.57.1 · dev DB `main` şeması
- **Statü:** bu bölüm **bağlayıcıdır** ve çeliştiği yerde yukarıdaki v3 metnini **geçersiz kılar.**
  v3 metni silinmedi — altı ay sonra "ADR neden böyle diyordu" sorusunun cevabı kayıtta kalsın diye.

Adım 1–3'ün tasarımı sırasında v3'ün beş maddesinde ölçümle çürütülen ifadeler bulundu. Sekizi
düzeltme, biri (E5) genelleştirme, biri (E6) kanoniklik ilanıdır.

| # | Neyi düzeltir | Düzeltme |
|---|---|---|
| **E1** | **Karar 3a — mekanizma cümlesi YANLIŞ** | v3: *"`MoneyMinor * RateBps` derleme hatası olur."* **Değildir.** TS 5.9.3 ile doğrulandı: `m * r` **derlenir** (sonuç düz `number`), `const wide: number = m * r` **derlenir**, `m > r` **derlenir**, `m / r` ve `m - r` **derlenir**. **Yalnız** `const stored: MoneyMinor = m * r` TS2322 verir. Marka bir **operatör kapısı değil, yuva kapısıdır.** **Ek bağlayıcı kural:** yeni modüllerde hiçbir entity kolonu, DTO alanı veya repository imzası `number` olamaz — yuva kapısını sistematik hâle getiren tek şey budur. Cast kaçağı derleyiciyle kapatılamaz; ESLint `no-restricted-syntax` seçicisi kapatır (üç cast biçimi — `as`, açı-parantez, `as unknown as` — 3/3 yakalandı, 0 yanlış pozitif). |
| **E2** | **Karar 4 — yanlış hedefi gösteriyor** | `plan_mechanic_values.entered_value`'nun **üretimde hiçbir yazıcısı yok**; 86 referansın tamamı okuma/karşılaştırma/bildirim. Planner girdisi `plan_fus.tactics` JSONB'sine yazılıyor (`plan.service.ts:564`, tek UI-erişilebilir uç). Polimorfizm asıl olarak o JSONB'de ve `SpendCalculationService#buildMechanicValues`'ın ürettiği `Record<string, number>` haritasında yaşıyor. **Kolon bölünmesi gerekli ama YETERLİ DEĞİL** — JSONB tarafı da ele alınmalıdır. |
| **E3** | **Karar 3a / Karar 5 — tip adı yanıltıcı** | `RateBps` → **`RateMicro`**. Baz puan = %0,01; Karar 5'in seçtiği 4 ondalıklı yüzde çözünürlüğü bunun **1/100'üdür**. `%3,25` değerini `32500` olarak tutan bir tamsayının adı `325` vaat ediyor — 100 katlık okuma hatası davetiyesi. Marka anahtarı (`__scale: 'rate'`) değişmez; yalnız tip **adı** değişir. Karar 5'in "4 ondalık" kararı **korunur**; "(baz puan hassasiyeti)" parantezi hatalıdır, doğrusu "yüzde×10⁴ = kesir×10⁶ (ppm) hassasiyeti". |
| **E4** | **Karar 6 — 2⁵³ tavanı dar** | v3'ün yazdığı 90 trilyon TRY **tek bir `MoneyMinor` değeri** için doğrudur. Ama `applyRate`'e **giren** tutar için tavan `2⁵³ / 10⁶` = **90.071.992 TRY (~90 milyon)**'dur, çünkü ham çarpım `kuruş × 10⁻⁶` ölçeğine çıkar. Ölçülen gerçek maksimum **600.000 TRY** → 150× pay. **`bigint` yeniden değerlendirme eşiği: 50 milyon TRY.** Sınır kontrolü `applyRate`'in içindedir ve aşımda fırlatılan hata **bu eşiği ve "ADR 0007 E4/A9" atfını metninde taşır.** |
| **E5** | **Karar 2 genelleştirilir** | v3 yalnız RAG'dan söz ediyor. Bağlayıcı hâli: *"Bir eşik değerlendirmesi — RAG, bütçe yüzdesi veya başka bir oran — bir onayı, rezervasyonu veya para hareketini **bloklayan** kapıya dönüştürülmek istenirse, karar değeri önce Alan A'da yeniden üretilmelidir."* Gerekçe: `budget_alert_configurations.threshold_percent` (%80/95/100) bugün hiçbir şeyi bloklamıyor (yalnız log + RAG rengi + rapor), yani Alan B'dedir; ama bloklamaya başladığı an v3'ün RAG'a özgü yazımı onu kapsamazdı. |
| **E6** | **Karar 6'nın largest-remainder'ı KANONİK ilan edilir** | Repoda dağıtım artığı için **iki implementasyon ve üç farklı kural** var: `spend-calculation.service.ts:308-334` (canlı; artık → en büyük base volume, ADR 0006 Karar 2), `spend-distribution.service.ts:555-579` (erişilemez; fark → en büyük tutar, `0.01` toleransıyla), ve Karar 6'nın kendisi. **Dördüncü kural yazılmaz.** Mevcutlar Karar 6'ya **yakınsar**; yakınsama **ayrı iştir** ve ADR 0006'nın açık bıraktığı işi kapatır. Yakınsamaya kadar `computeLumpsumDistribution` değişmez. |
| **E7** | **Karar 6 — yuvarlama modu netleştirilir** | **half-up → half-away-from-zero.** "Half-up" negatifte belirsizdir (−2,5 → −2 mi, −3 mü). Bağlayıcı kural: **`\|round(x)\| = round(\|x\|)`**, işaret simetrik; `round(2,5) = 3`, `round(−2,5) = −3`. Ticari mutabakattaki beklenti korunur, belirsizlik kalkar. Not: JS `Math.round` bunu **yapmaz** (`Math.round(-2.5) === -2`, +∞'a yuvarlar) — yardımcı onu devralamaz. Kural bugün baskı altında değilken sabitleniyor: `ledger_entries` 1.231 satır, **0 negatif**; yön `entry_direction` kolonunda taşınıyor. Reversal/CREDIT yolları negatif tutar üretmeye başladığında kural hazır olacak. |
| **E8** | **Karar 5 kapsamı genişletilir** | `mechanics.max_combined_discount_percentage` (`numeric(5,2)`) **Karar 5 kapsamına alınır** → `numeric(9,4)`. Gerekçe: bir orandır ve `entered_value` oran toplamıyla **doğrudan karşılaştırılıyor** (`spend-validation.service.ts:325`); iki ölçekte kalırsa karşılaştırma sessizce bozulur. |
| **E9** | **A10 kararı GERİ ÇEKİLDİ** | 0013'ün ilk turunda *"kanonik = `spend-calculation.service.ts` (exception fırlatan)"* kararı verilmişti. **Ölçüm iki gerekçeyi de çürüttü:** (i) seçilen `validateSpendCalculations` **fırlatmıyor** — `errors.push(...)` + `return {isValid, errors, warnings}`; (ii) o metot **para üretmiyor**, yalnız sınır doğruluyor. Üstelik seçilen taraf **ölü kod** (yalnız kendi spec'inden çağrılıyor), reddedilen `spend-validation.service.ts#validateInputs` ise **canlı** (`spend-calculation.controller.ts:123` üzerinden HTTP ucuna bağlı) ve hata bilgisi daha zengin (`severity`/`category`/`field`/`fuId`/`skuId`/`suggestion` vs `string[]`). `validateInputs`'u şimdi kanonik ilan etmek de **aceleci olur**: çağıran envanteri çıkmadan `validateSpendCalculations`'ın gerçekten ölü mü, yoksa yarım bırakılmış bir yol mu olduğu bilinmiyor. **Kanonik seçim askıya alındı** ve çağıran envanterine bağlandı ([[T-075]]). F2 iki implementasyonla geçer; **K14** üçüncü kopyayı sözleşme testiyle kilitler. |
| **E10** | **Karar 1'in listesi ÖRNEKLEYİCİ, üyelik testi KANONİK** | Karar 1 Alan A'yı modül adlarıyla sayıyor; bu sayım tanımlayıcı sanıldığında adlandırılmamış bir modül davranışsal olarak Alan A olsa bile dışarıda kalıyor. **Bağlayıcı üyelik testi:** *bir modül para üretiyor, para kalıcılaştırıyor veya parayı bir eşikle karşılaştırıyorsa Alan A'dadır.* **`modes/planning-first/plan` açıkça eklenir** — üç ölçütü de karşılıyor: üretir+kalıcılaştırır (`spend-calculation → plans.total_spend`, `plan.service.ts:2413`), eşikle karşılaştırır (`:844` epsilon kapısı), rezervasyonu tetikler (`reserveForPlan`). ADR **0005 K3** zaten bu dosyada bir para kararı vermişti (bayat 0/0 spend kolonları → gürültülü red), yani modül fiilen Alan A gibi ele alınıyordu, sadece listeye yazılmamıştı. Ölçülen bedel: Alan A 68 → **86 dosya**, taban 119 → **163 bulgu** (`plan.service.ts` tek başına 36). Sayının büyüklüğü bilgidir, dışlama gerekçesi değil. |
| **E11** | **`money-float` guard'ının iki farklı modu karıştırılmamalı** | (i) **Mevcut** Alan A için guard `REPORT_ONLY`'dir ve `npm run guards`'ı kırmaz; kapı `--ratchet`'tir (dosya başına bulgu sayısı artamaz). Bu mod, Alan A toplamı **sıfıra ulaştığında** kalkar. (ii) **Yeni doğan** modüller (`claims`, `recognition_variance`, settlement uzantıları) Karar 8.2 uyarınca doğduğu andan itibaren **`block`** modundadır — tabana yazılmazlar. İkisi ayrı şeydir: guard genel olarak bilgi amaçlıyken yeni modüller için bloklayıcıdır. |
| **E12** | **Karar 4'ün "tam olarak biri dolu" ifadesi fazla sıkı** | Karar 4 bölünmüş kolonlar için *"tam olarak biri dolu"* diyor. Uygulamada bu **yazılamaz bir durum** üretiyor: `spend-distribution.service.ts` değer girilmemiş bir `PlanMechanicValue` satırı yaratıyor ve "satır var, girdi yok" **meşru bir durumdur**. `= 1` kısıtı çağıranı sıfır uydurmaya zorlardı — CLAUDE.md §2.5'in yasakladığı sessiz sıfırın şema seviyesindeki hâli. **Bağlayıcı kısıt `<= 1`'dir** ("en fazla biri dolu"); `NULL` ile `0` ayırt edilebilir kalır. Uygulanan kısıt: `chk_pmv_at_most_one_entered` (migration 1796). |
| **E13** | **F2 expand-contract ile yürür; `DROP COLUMN` ayrı commit'tedir** | C1'in tanımı *"şema doğar, henüz kimse okumaz"* idi ama `DROP COLUMN` içeriyordu — bu ikisi çelişir: bir kolonu düşürmek okuyucularına dokunmadan mümkün değil, dolayısıyla C1 tanımı gereği bağımsız derlenemez ve bağımsız geri alınamazdı (ölçüldü: kolon entity'den kaldırılınca **8 referans** kırıldı — `spend-distribution.service.ts`, `buildMechanicValues` ve üç spec). **Kalıp:** C1 genişler (üç kolon eklenir, `entered_value` durur, `CHECK` yalnız yeni kolonları kapsar), C2 okuyucuları geçirir ve **sonra** düşürür (migration 1797). Dört kolonlu ara durum bedelin değil, kalıbın kendisidir. |
| **E14** | **K14'ün sözleşme testi YAZILMADI — kilit yok** | K14 *"A10 askıda: iki sınır doğrulaması F2'de birleştirilmez, üçüncü kopya **sözleşme testiyle kilitlenir**"* diyor. F2/C2b-2'de ölçüldü: **böyle bir test yok.** `-t "K14"` hiçbir testi eşleştirmiyor (648 skipped — geçti değil, koşmadı), ve `validateInputs`'a referans veren **hiçbir spec dosyası yok**. Yani ADR bugün **olmayan bir korumayı var gibi anlatıyor**. Bu, `AGENT_HARDENING`'in kuralının doğrudan ihlali: *her bağlayıcı koşul ya bir guard'a bağlanır, ya "tavsiye"ye düşürülür — ortası yok.* K14 ortada kaldı. **Testin yazılması [[T-075]]'e eklendi**, çünkü A10 kararı verilmeden yazılacak test yanlış şeyi kilitleyebilir. O güne kadar K14 **tavsiye** statüsündedir, bağlayıcı değil. |

### Errata ile birlikte verilen kapsam kararları

| # | Konu | Karar |
|---|---|---|
| **A4** | `agreements.mechanic_value` (3/3 NULL, ayırıcısı da 3/3 NULL, tek tüketicisi mock veriyle Alan B'ye gidiyor) | **Dondurulur.** Silinmez, tamamlanmaz, **ölçek kontratına dahil edilmez.** Kolona yorum: *"Kullanılmıyor (3/3 NULL). Yazılmadan önce ADR 0007 ölçek kontratına bağlanmalıdır."* Gerekçe: tamamlanmamış bir yolun kolonu ölçek kararı için yeterli bilgi taşımıyor; yol tamamlandığında karar zaten verilmiş olacak. |
| **A5** | `mechanics.calculation_formula` (admin'e açık, DB'de duruyor, **hiçbir hesap yolu okumuyor**) | **Ayrı task açılmaz; [[T-071]] kapsamına eklenir.** `calculation_formula`, `mechanics.decimal_places` (6/6 NULL), `0012` R3'ün 8 gömülü formülü ve R4 — dördü **aynı sınıftır**. Tek soru olarak sorulur: *dinamik formül ilkesi gerçekten uygulanacak mı, yoksa BRD'den mi düşecek?* **Ara durum en kötüsüdür** — admin bir alanı doldurur, hiçbir şey olmaz. |
| **A6** | `budget_alert_configurations.threshold_percent` | **Bugün Alan A dışında.** Bloklamadığı sürece Alan B'de kalır ve `RateMicro`'ya dönüşmez. E5 onu ileriye dönük kapsar. `budget-allocation.service.ts:945`'teki `// TODO: ... block plan submission if hard limit mode` **bir BRD ihlalidir** (CLAUDE.md §2.3 "%100+ Exceeded (block)") → ayrı task, bu turda değil. |
| **A7** | `VolumeMilli` markası | **Bu turda dışarıda.** Tek şart: markalı tip tasarımı **üçüncü bir markayı sonradan eklemeye açık** olmalı — genişletilemez marka mekanizması ve iki-marka varsayan yardımcı imzası yazılmaz. |
| **A9** | `bigint`'e geçiş tetikleyicisi | **50 milyon TRY.** `applyRate`'in sınır kontrolü aşımda fırlatırken hata mesajı **bu eşiği ve bu ADR'nin E4/A9 atfını** içerir — aşımda neye bakılacağı hata metninde olur. |

### ⛔ Askıya alınan karar: A10

**A10 (kanonik sınır doğrulaması) uygulanamaz — kararın dayandığı olgu ölçümle çürüdü.**

Karar şuydu: *kanonik = `spend-calculation.service.ts:893-907`, çünkü exception fırlatıyor ve
`spend-validation` yalnız `ValidationError` dönüyor.* Ölçüm (`0013` §7/A10):

| | `spend-calculation.service.ts:874-918` (seçilen) | `spend-validation.service.ts:49-182` (reddedilen) |
|---|---|---|
| Exception fırlatıyor mu | **HAYIR** — `errors.push(string)` + `{isValid, errors, warnings}` döner | hayır — `{isValid, errors: ValidationError[], errorCount, warningCount}` döner |
| Üretim çağıranı | **YOK** — yalnız kendi spec'i (`spend-calculation.service.spec.ts:871`) | **4 canlı HTTP endpoint** (`spend-calculation.controller.ts:112-167`) |
| Hata bilgisi | `string[]` | yapılandırılmış `ValidationError` (severity, category, field, fuId, skuId, suggestion) |

Yani seçilen taraf **exception fırlatmıyor** ve **ölü koddur**; reddedilen taraf canlıdır ve
daha zengin bilgi taşır. Kararın her iki gerekçesi de tersine dönüyor.

**Sonuç:** A10 askıdadır. F2'de iki implementasyon **birleştirilmez**; üçüncü kopya da yazılmaz.
Kanoniklik kararı, çağıran envanteri çıkarıldıktan sonra ayrı bir turda verilir.

---

## Sürüm geçmişi

| Sürüm | Değişim |
|---|---|
| v1 | İlk taslak. Sınırı `spend-calculation`'ın içinden geçirdi; `DecimalTransformer`'ın uygulanmasını önerdi. **Commit edilmedi.** |
| v2 | `0010` sonrası: sınır düzeltildi (`spend-calculation` tümüyle Alan A); transformer'ın kendisinin bozuk olduğu tespit edildi; `big.js` önerildi. **Commit edilmedi.** |
| v3 | `0011` + `0012` + bağımsız değerlendirme sonrası: kapsam kararı C, temsil kararı tamsayı+marka (yeni modüller), ratchet mekanizması, şema işleri kapsama alındı. **Kabul edildi.** |
