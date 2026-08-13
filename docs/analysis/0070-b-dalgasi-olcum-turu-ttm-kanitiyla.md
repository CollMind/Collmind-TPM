# 0070 — `B` dalgası ölçüm turu: sekiz ölçüm, ve TTM'den gelen kesin kanıt

- **Tarih:** 2026-08-13
- **Mod:** SALT-OKUNUR (ürün kodu/şema değişmedi)
- **Ölçüm ortamı:** meta `009a7b6` · backend `276532c` · **TTM `19c6376`** (bu oturumda
  ilk kez klonlandı) · tek kullanımlık PostgreSQL 16.13

> ⚠️ **VERİ KAPSAMI — her bulguda geçerli.** Ayaktaki DB **üretim değil**, yalnız `seed`:
> `sales_actuals` 3 satır · `agreements` 3 · `ledger_entries` / `on_invoice_entries` /
> `agreement_transactions` / `plans` **0**. Veri tarafı bulguları bu kapsamla okunmalı.

---

## Turun tek cümlelik sonucu

**`B1` kapandı, ve `DUR` koşulu ateşledi.** TTM erişilebilir çıktı; bir turdur ölçülmeden
taşınan iddia **doğrudan doğrulandı**, ve sınıf **`pilot profili`.**

---

# B1 · `T-206` — tasarım kararının sınıfı ⚡ **KAPANDI**

## Gerekçe metni, tarihi, bağlamı

```
metin      sales-actual.entity.ts:7-11
           "FU/SKU ve hacim boyutu YOKTUR — Wella actuals CSV'sinde
            fu_code/volume kolonları bulunmuyor"
commit     dd7eaaf · 2026-07-27 · T-020 — dosyayı YARATAN commit
bağlam     docs/analysis/0002 §Kritik bulgu
```

Yani karar **doğuşta** alınmış, sonradan eklenmemiş. Ve dayanağı **tek bir müşterinin CSV
başlığı.**

## ✅ TTM iddiası DOĞRULANDI — `Done` şartı sessiz taşınmayla kapanmadı

`0002 §Kritik bulgu` bir turdur şunu taşıyordu: *"TTM `validateRow` bunları zorunlu tutuyor;
yani TTM validator'ı bu veriyi tümden reddederdi."* Bugüne kadar **ölçülmemişti** (repo
oturumda yoktu). `CollMind/TTM` eklendi ve okundu:

```
apps/api/src/actuals/actuals.service.ts — validateRow()

  :991   if (!row.fu_code?.trim()) throw new Error('fu_code is required');
  :1045  if (volume === 0 && grossAmount > 0)
           throw new Error('volume is 0 but gross_amount > 0: …must have a positive volume')
```

**İddia doğru.** Ve zorunlu alan listesinin tamamı ölçüldü: `cpl_code` · **`fu_code`** ·
`gross_amount` · geçerli `volume`.

## Ve ikinci, daha güçlü kanıt: TTM'in KANONİK biçimi

```
apps/web/public/templates/actuals_template.csv
  cpl_code,fu_code,gross_amount,net_amount,discount_amount,volume
```

Sayım (`head` değil, tam tarama):

| | |
|---|---|
| `cpl_code` ile başlayan CSV, TTM'de | **22** |
| **`fu_code` + `volume` taşıyan** | **16** |
| CTPM'in biçimi (`category,channel_code`, hacimsiz) | **4** — ve hepsi eski/ikincil (`test-data/actuals_2026_01.csv`, `_02`, `docs/testing/…`) |

> **Kardeş üründe hacim ve FU kırılımı yalnız var değil — kanonik.** Kullanıcıya sunulan
> şablon o. CTPM'in dayandığı biçim TTM'de de var, ama **eski test verisi** olarak.

## ⛔ SINIF: `pilot profili` — ve `DUR` koşulu ateşledi

| şık | ölçüm ne diyor |
|---|---|
| **kaynak sınırı** (ERP veremiyordu) | ⛔ **ELENDİ** — kardeş ürün aynı veriyi zorunlu tutuyor ve şablonuyla topluyor; ERP'nin veremediğine dair **tek cümle yok** |
| **pilot profili kararı** | ✅ **DESTEKLENDİ** — gerekçe tek müşterinin dosya başlığı, ve o başlık TTM'de bile ikincil |
| gerçek domain kararı | ⛔ ELENDİ — "actuals tutar agregasıdır" bir ürün ilkesi olsaydı TTM'in kanonik şablonu onu ihlal ederdi |

→ **`İlke 5`:** bir müşteri için verilen karar ürün kuralı değildir. Karar **tenant
profiline** iner; ürün varsayılanı FU + hacim taşıyabilmelidir.

→ **`B` dalgasının `F16` kalemi yeniden yazılır** (`_ISSUE_B_DALGASI §4`).

→ **`K-2.1.8a` (`A2`) ayakta ve uygulanabilir** — taban değişikliği gerekmiyor; gereken şey
kaynağın genişlemesi, ve o genişleme kardeş üründe **zaten yazılmış.**

---

# B2 · `T-209` — `discount_amount` hangi olayı taşıyor

## Ön beklenti tablosu (ölçümün girdisi)

```
(a)  satış iskontosu                    ← ÖN OKUMA
(b)  ticari harcama indirimi
(c)  toplam indirim (brüt−net köprüsü)  ← ELENDİ: %100 sapma
```

| ölçüm çıkarsa | *"çift sayımın kökü"* teşhisi |
|---|---|
| **`(a)`** | **YANLIŞ ALARM** |
| **`(b)`** | **GERÇEK KUSUR** |

## Ölçüm — TTM `(a)`'yı destekliyor

```
TTM: discount_amount'a dokunan dosyalar
  sales/sales.service.ts · actuals/actuals.service.ts · iki migration · iki spec

TTM: discount_amount ∩ (ledger|budget|claim|spend|consume)   →  0 satır
```

**Kardeş üründe `discount_amount` ledger/bütçe/hakediş yoluna hiç girmiyor.** Yalnız
alınıyor, doğrulanıyor, saklanıyor.

Ve hakediş tabanı ölçüldü — `discount_amount` **değil**:

```sql
-- actuals.service.ts:372
COALESCE(SUM(COALESCE(sa.net_amount, sa.gross_amount)), 0) AS total_amount
COALESCE(SUM(sa.volume), 0)                                AS total_qty
```

> `(b)` doğru olsaydı, ticari indirimi taşıyan bir alanın hakediş ya da mutabakat yolunda
> **bir yeri olurdu.** Yok.

⚠️ **Sınır:** bu, alanın TTM'de nasıl **kullanıldığını** ölçüyor, ne **anlama geldiğini**
değil. Wella'nın kolon tanımı (iş dokümanı) hâlâ okunmadı, ve üçlü karşılaştırma üretim
verisi istiyor. Ama üç bağımsız iz `(a)`'yı gösteriyor: CTPM entity yorumu · TTM'in
kullanmaması · `on_invoice_entries`'in ayrı tablo olarak var olması (`İlke 4`).

→ **Ön karar `(a)` güçlendi**, kesinleşmedi. `K-2.13.14h6a`'nın ⛔'ü duruyor.

---

# B3 · `C5+` — bölme: fark ve canlılık

## 1 · Yapısal fark

```
planning-first    24 dosya  10.282 satır  23 rota   (tek modül: plan)
actuals-first     77 dosya  17.942 satır  47 rota   (yedi modül)
```

**Bölme simetrik değil:** bir tarafta tek dev modül, diğerinde yedi. *"İki paralel dünya"*
benzetmesi ölçüme uymuyor.

## ⛔ Ve asıl bulgu: iki taraf birbirini HİÇ import etmiyor

```
planning-first → actuals-first :  0
actuals-first → planning-first :  0
```

Ortak entity teması da yok denecek kadar az, ve olanlar **kod değil yorum**:
`agreement.service.ts`'te `Plan` sözcüğü üç yorum satırında, `sales-actuals.module.spec.ts`'te
bir yasak-import listesinde.

> **Birleştirme bir bağımlılık çözme işi değil.** Çözülecek bir bağ yok — iki bağımsız ağaç
> ortak bir klasörün altında duruyor. Soru *"nasıl ayrıştırırız"* değil, **"bu ayrım bir şey
> ifade ediyor mu"**.

## 2 · Canlılık — belirleyici olan

| modül | satır | frontend'de |
|---|---|---|
| `plan` (planning-first) | 10.282 | **20 dosya** ✅ |
| `agreement` | 3.143 | 20 dosya ✅ |
| `on-invoice` | 4.512 | 6 ✅ |
| `ledger` | 899 | 6 ✅ |
| `agreement-transaction` | 3.501 | 1 ⚠️ |
| **`settlement`** | 2.468 | **0** ❌ |
| **`sales-actuals`** | 1.920 | **0** ❌ |
| **`reversal`** | 1.499 | **0** ❌ |

**5.887 satır (%21) hiçbir arayüzden çağrılmıyor — ve hepsi `actuals-first` tarafında.**

⚠️ **Hipotez çürüdü:** *"`A1` planning-first'ü Faz 1 dışı ilan etmişti, o taraf ölüdür"*
beklentisi **yanlış**. En canlı modül (`plan`, 20 frontend dosyası) tam da o taraf.

> **Üçüncü seçenek — silme — yanlış tarafa bakıyordu.** Silme adayları `settlement` ·
> `sales-actuals` · `reversal`; ve üçü de `A1`'in ölü ilan etmediği tarafta.
> ⚠️ Ama *"frontend çağırmıyor"* ≠ *"ölü"*: üçü de `D4`/`0068`'in **arayüzsüz olgun
> mekanizma** sınıfı olabilir. Silme kararı bu ayrımı ölçmeden verilemez.

## 3 · Sekiz `İlke 4` ihlali — ⛔ **cevaplanamadı, ve sebebi bir bulgu**

O sekizin **enumerasyonu repoda yok.** Dört yerde *"sekiz kez ölçüldü"* yazıyor, hiçbirinde
liste yok. Ve repoda **en az dört farklı "sekiz"** var: `İlke 4` (tekrar) · *"mekanizma var
yol yok"* (`T-033`…`T-062`, **bu listeli**) · karar kayıtlarındaki çakışma · doğrulama
maskeleme ailesi.

`CLAUDE.md §7`'nin adıyla saydığı dördü ölçüldü:

| vaka | bölmede mi |
|---|---|
| üç kez yazılmış scope mantığı | **3/3 bölmede** |
| iki CSV parser | **4'ü bölmede**, biri dışında (`customer/file-parser`) |
| iki lumpsum dağıtımı | **bölmede DEĞİL** — `shared/spend-calculation/` |
| iki submit yolu | bölmede |

→ *"Kaçı bölmeden doğdu"* sorusu, enumerasyon ölçülene kadar bir **tahmindir**.

---

# B4 · `C1` — gönderen alanını boşaltan yol

```
returnToDraft()          plan.service.ts:1792
rota                     POST /plans/:id/return-to-draft   (controller:517)
akış                     REDDEDİLDİ → TASLAK
boşaltma                 :1864-1874, updateStatusCas alan kümesinde
```

Boşaltma **bilinçli ve gerekçeli** (T-033 yorumu): reddin kendisi `PlanApprovalHistory`'de
değişmez duruyor, *"güncel durum"* alanları temizleniyor. Gerekçe beş **yaşam döngüsü**
alanı için doğru — `submittedById` için değil (`K-2.5.16`).

## ⚠️ Beklenen sürpriz ölçüldü — ve tahmin edilenden geniş

Aynı fonksiyonda, boşaltmadan **önce**, iki yerde (`:1811`, `:1849`):

```ts
actor.userId !== plan.createdBy && actor.userId !== plan.submittedById  → 404
```

`submittedById` bir **erişim anahtarı**. Bugün boşaltıldığı için: *yaratmayan ama gönderen*
bir PLANNER, plan taslağa döndükten sonra ona **erişemiyor** (404 `OUT_OF_SCOPE`).
Boşaltmayı kaldırmak o erişimi **geri verir.**

→ `T-205`'in regresyon notu **iki maddeli**: `TASLAK`'ta gönderen görünürlüğü (bilinen) **ve
kapsam erişiminin genişlemesi** (yeni). İkincisi bir yetki yüzeyi değişikliğidir.

---

# B5 · `C2` — iade temsili

```
alan / tip / işaret sözleşmesi        YOK
gramer                                -?\d+(\.\d+)?   → negatif PARSE ediliyor
validasyon (sales-actuals)            pozitiflik kontrolü YOK
DB                                    sales_actuals CHECK: 0
probe                                 UPDATE … gross_amount = -1  →  KABUL
mevcut negatif satır                  0 / 3  (seed)
```

Kardeş yollarda kural **var**: `on-invoice-validation.ts:264,280` · `off-invoice-validation.ts:298`.
`sales-actuals` bu üçlünün **dışında** → tutarsızlık kodda, kararsızlıkta değil.

→ [[T-208]]: kanal **kapatılacak mı, adlandırılacak mı**. Bugünkü hâl üçüncüsü ve en kötüsü:
kanal açık, anlamı yok.

---

# B6 · `F13` — KDV

```
KDV            0
vergi          0
\bvat\b        0
\btax          16 satır — HEPSİ tax_number / tax_office (kimlik alanı)
```

⚠️ `vat` alt-string olarak **655** satır eşleşti (`private` içindeki `vat`). Kelime sınırı
olmasa *"KDV her yerde"* diye raporlanacaktı.

**Kodda dönüşüm yok, oran yok, brüt/net-KDV ayrımı yok.** Dosyadan gelen tutar olduğu gibi
saklanıyor.

⏸️ **Veri yarısı ölçülemedi:** seed'in üç satırı yuvarlak sayılar (`400.000`/`360.000`),
gerçek fatura tutarı değil. `1,20` / `1,10` / `1,01` testi **üretim verisi** ister.

→ `K-2.13.14`'ün eşleştirme toleransı bir KDV oranı kadar (%10-20) sistematik sapma
görebilir — ve tolerans bugün `±0,01`.

---

# B7 · `Ö4` — dönem değer kontrolü

Katalog, entity ölçümünü **doğruladı**:

| ad | tablo | nullable |
|---|---|---|
| `fiscal_period` (5) | `agreement_transactions` ⚠️ · `on_invoice_batches` · `on_invoice_entries` · `sales_actual_batches` · `sales_actuals` | biri |
| `period_month` (3) | `agreements` · `ledger_entries` · `plans` | — |

Hepsi `varchar(7)`, **0 `CHECK`**.

## Asıl bulgu probe'ta

```
UPDATE … fiscal_period = '2026-13'  →  KABUL
UPDATE … fiscal_period = '2026/01'  →  KABUL
```

> **Mevcut satırların temiz olması kural değil, TESADÜF.**

Sekiz kolonun **altısında** yazma tarafında gramer yok; olan ikisinden biri
(`create-ledger-entry.dto.ts:53`, `^\d{4}-\d{2}$`) `2026-13`'ü **zaten geçiriyor**.

⚠️ **Kapsam sınırı:** aykırı değer taraması yalnız dolu iki tabloda koşabildi
(`sales_actuals` 3 · `agreements` 3, ikisi de temiz). Kalan altı tablo bu ortamda **boş**.

→ `S11`: backfill **biçim doğrulamalı**, ve `CHECK` **ayrı bir dalga kalemi**.
→ `INV-C-*` ailesinin şekli: **kazara sağlanan bir şart.**

---

# B8 · `C3` — gerçek sapma

```
sapan      3 / 3 satır  (seed'in tamamı)
en büyük   25.000
toplam     63.000        (brütün %5-6'sı — yuvarlama değil)

ALTER TABLE … ADD CONSTRAINT ck_sa_net CHECK (…)
ERROR: check constraint "ck_sa_net" … is violated by some row
```

⚠️ **Bu ölçüm artık bir kısıt kararı değil, [[T-209]]'un girdisi** — `K-2.7.4a` kısıtı
düşürdü. `%100` sapma bir veri kalitesi sorunu değil, **model uyuşmazlığı** işareti.

⏸️ Üretim sapması ölçülmedi.

---

# Etki özeti

| ölçüm | `B` dalgası / karar üzerindeki etki |
|---|---|
| **B1** | ⚡ **Ön koşul kapandı.** `F16` yeniden yazılır (`pilot profili`), `A2` **ayakta** |
| **B2** | Ön karar `(a)` güçlendi; `K-2.13.14h6a`'nın ⛔'ü **duruyor** (iş dokümanı + üretim verisi) |
| **B3** | Birleştirme bir bağ çözme işi **değil** (0 çapraz import); silme adayları **öbür tarafta** |
| **B4** | `T-205` regresyon notu **iki maddeli** — yetki yüzeyi değişiyor |
| **B5** | [[T-208]] kararı bekliyor; tutarsızlık **kodda** |
| **B6** | Kod kesin (KDV yok); ölçek sorusu **üretim verisi** ister |
| **B7** | `S11` biçim doğrulamalı; `CHECK` ayrı kalem |
| **B8** | `S3` yerine [[T-209]]'un girdisi |

**Dalga onayının ön koşulu kalmadı** — `T-206` kapandı. Kalan işler karar ve ölçüm
kuyruğunda, dalgayı bloklamıyor.
