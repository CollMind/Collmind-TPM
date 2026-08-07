# 0015 — CSV sayı ayrıştırma: dört implementasyon, dört farklı davranış

**Tarih:** 2026-08-07 · **Statü:** ölçüm tamamlandı, ürün kararı bekliyor (C1)
**Bağlam:** [[T-099]] (`Number.isNaN(Infinity) === false`) ölçülürken çıktı; kusur task'ın
tarif ettiğinden ağır.

---

## 1. Matris — girdi × parser

Gerçek metotlara karşı ölçüldü (`getNumberValue` private, `as any` ile çağrıldı; kopya
üzerinden **değil** — §2.7 #8).

| girdi | sales `parseAmount` | on-invoice `getNumberValue` | off-invoice `getNumberValue` | customer `getOptionalNumber` |
|---|---|---|---|---|
| `7250.00` | 7250 ✓ | 7250 ✓ | 7250 ✓ | 7250 ✓ |
| `400000` | 400000 ✓ | 400000 ✓ | 400000 ✓ | 400000 ✓ |
| `1,234.56` | 1234.56 ✓ | 1234.56 ✓ | 1234.56 ✓ | **undefined** ✗ |
| **`1.234,56`** | **1.23456** ✗ | **1.23456** ✗ | **1.23456** ✗ | **undefined** ✗ |
| **`1.000,00`** | **1** ✗ | **1** ✗ | **1** ✗ | **undefined** ✗ |
| **`1234,56`** | 1234.56 ✓ | **123456** ✗ | **123456** ✗ | **undefined** ✗ |
| `1.234.567,89` | 1234567.89 ✓ | 1234567.89 ✓ | **THROW** ✗ | **undefined** ✗ |
| `1.234` | 1.234 ⚠ | 1.234 ⚠ | 1.234 ⚠ | 1.234 ⚠ |
| `Infinity` | **Infinity** ✗ | **Infinity** ✗ | **Infinity** ✗ | **Infinity** ✗ |
| `1e999` | **Infinity** ✗ | **Infinity** ✗ | **Infinity** ✗ | **Infinity** ✗ |

### Okunuşu

- **`1.234,56` → 1000 kat KÜÇÜK, üç parser'da birden.** Koşul `split('.').length > 2`, yani
  **en az iki** binlik ayraç istiyor: milyonlar doğru, `1.000,00`–`999.999,99` aralığı yanlış.
  Bir FMCG satış CSV'sindeki en yaygın aralık.
- **`1234,56` → 100 kat BÜYÜK**, on/off-invoice'ta. Aynı ürünün iki rotası **aynı girdiyi ters
  yönlerde** bozuyor.
- **`,` iki parser ailesinde zıt anlam taşıyor:** sales/on-invoice onu koşullu olarak *ondalık*
  sayıyor, off-invoice *binlik ayraç* sayıp siliyor.
- **`1.234` gerçekten belirsiz** — 1234 mü, 1.234 mü? Dördü de sessizce 1.234 diyor. Karar
  gerektiren tek gerçek belirsizlik bu.
- **`Infinity`/`1e999` dördünde de geçiyor** — [[T-099]]'un asıl hedefi.

## 2. Aynı yetenek dört kez yazılmış (§7)

```
src/modules/modes/actuals-first/sales-actuals/services/sales-actuals-validation.service.ts:51  parseAmount
src/modules/modes/actuals-first/on-invoice/services/on-invoice-file-parser.service.ts          getNumberValue
src/modules/modes/actuals-first/agreement-transaction/services/off-invoice-file-parser.service.ts  getNumberValue
src/modules/customer/services/file-parser.service.ts                                          getOptionalNumber
```

`src/common/services/csv-parser.service.ts` **sayı ayrıştırmıyor** (ölçüldü) — beşinci değil.

## 3. Kusuru neden hiçbir şey yakalamadı

**Mevcut test tam da çalışan örneği seçmiş:**
```ts
expect(parseAmount('1.234.567,89')).toBeCloseTo(1234567.89);   // İKİ ayraç → doğru dal
```
Biçim ailesi kapsanmış *görünüyor*; kırık üye (`1.234,56` — tek ayraç) hiç denenmemiş.
`1.234,56` deseni **ne unit'te ne e2e'de** geçiyor (ölçüldü).

**Ve on-invoice'un yorumu kodun yanlış hesapladığı örneği yazıyor:**
```ts
// Virgül ve nokta ayracını düzelt (Türkçe format: 1.234,56 -> 1234.56)
```
Kod o girdide 1.23456 üretiyor. CLAUDE.md §2.7'nin "yorum başka bir davranış iddia ediyor"
sınıfı — bu vaka **önceden** vardı, bu oturumda üretilmedi.

## 4. Gerçekte hangi biçim geliyor

| kaynak | biçim | dört parser'da sonuç |
|---|---|---|
| İndirilen şablonlar (`generateCSVTemplate`) | `7250.00` — **İngilizce** | ✓ hepsi doğru |
| Wella fixture'ları (`seeds/data/actuals_*.csv`) | `400000` — ayraçsız | ✓ hepsi doğru |
| e2e upload gövdeleri | `185.00` | ✓ hepsi doğru |
| Seed/fixture'larda Türkçe binlik ayraç | **hiç yok** (ölçüldü) | — |

**Yani bugünkü kanıtlanmış girdi kümesi kusurdan etkilenmiyor.** Risk, şablonu izlemeyen
gerçek dosyalarda: tr-TR yerelinde Excel'den CSV export'u tam olarak `1.234,56` üretir.

⚠️ Not: `.xlsx`'te sayısal hücre JS `number` olarak gelir ve `String(7250)` → `"7250"`, yani
sorunsuz. Kusur **metin** hücrelerde ve **CSV**'de ortaya çıkar.

## 5. Diskte bozuk veri var mı

```
main.sales_actuals           3 satır → 400000.00 / 600000.00 / 500000.00  (ölçek sağlam;
                                        bozulmuş olsalar 400.00 olurlardı)
main.on_invoice_entries      0 satır
main.agreement_transactions  0 satır
main.customers              61 satır
```

**"Neden 0?" sorusu soruldu (T-095 dersi).** Yazma yolu **kırık değil**: `on-invoice-split-envelope`
e2e'si `POST /on-invoice/upload` ile gerçekten entry yazıyor ve teardown'da siliyor
(`DELETE FROM main.on_invoice_entries WHERE batch_id = $1`). Sıfır, temizliğin sonucu —
T-095'teki gibi sessiz bir yazma hatası değil.

**Onarım gerekmiyor.** Bu, C2'nin veri geçişi taşımadığı anlamına gelir.

---

## 6. Ürün kararı gereken noktalar

**S1 — Kanonik parser hangi biçimleri kabul eder?**
`1234.56` · `1234,56` · `1.234,56` · `1,234.56` · `400000`

**S2 — Belirsiz girdide ne olur?** `1.234` tek başına 1234 de olabilir 1.234 de.
Öneri: **reddet** (satır-bazlı hata). Tahmin, bugünkü kusurun kaynağı; ve CSV importer'ları
zaten satır bazlı hata üretiyor.

**S3 — off-invoice'un `,` = binlik ayraç varsayımı korunacak mı?**
Birleştirme onu **değiştirir**: bugün `1234,56` → 123456 olan bir yükleme, sonra 1234.56 olur.
Bu bir davranış değişikliğidir ve mevcut bir dosyayı farklı okur.

**S4 — `Infinity`/`1e999` reddedilecek** (T-099). Kanonik parser'da tek yerde.

**S5 — Kanonik parser nereye?** Öneri: `src/common/numeric/`, `moneyFromNumericString` ile
aynı aile. ⚠️ Orası Alan A ve **dedektör-muaf** (ADR 0007 E15/E16) — yeni dosya
`exactness-primitives.txt`'e eklenmeli mi, yoksa `Number()` kullanıyorsa taban mı almalı?
C2'de karara bağlanacak.
