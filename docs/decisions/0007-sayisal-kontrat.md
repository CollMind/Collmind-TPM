# 0007 — Sayısal kontrat: para aritmetiği ile analitik aritmetiğin ayrılması

- **Durum:** Kabul edildi (Accepted)
- **Geçerlilik tarihi:** 2026-08-03
- **Karar veren:** Sertaç Tuzcu (ürün sahibi)
- **Sürüm:** v3. v1 ve v2 commit edilmedi; farkları §Sürüm geçmişi'nde.
- **Kanıt:** `docs/analysis/0010-numeric-contract-measurement.md` ·
  `0011-integer-minor-unit-feasibility.md` · `0012-frontend-calculation-layer.md`
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

## Sürüm geçmişi

| Sürüm | Değişim |
|---|---|
| v1 | İlk taslak. Sınırı `spend-calculation`'ın içinden geçirdi; `DecimalTransformer`'ın uygulanmasını önerdi. **Commit edilmedi.** |
| v2 | `0010` sonrası: sınır düzeltildi (`spend-calculation` tümüyle Alan A); transformer'ın kendisinin bozuk olduğu tespit edildi; `big.js` önerildi. **Commit edilmedi.** |
| v3 | `0011` + `0012` + bağımsız değerlendirme sonrası: kapsam kararı C, temsil kararı tamsayı+marka (yeni modüller), ratchet mekanizması, şema işleri kapsama alındı. **Kabul edildi.** |
