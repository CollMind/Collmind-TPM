# CollMind TPM — Gerçekleşen Satış Dosyası Sözleşmesi · v1

> **Durum:** TASLAK v1 — iç okuma (Fable son okur). ERP ekibine gönderilmeden önce
> **§9'daki açık noktalar** kapanır.
> **Kaynak karar:** CollMind karar kaydı `Z111 §12–§13` (2026-09-10).
> **Kimin için:** Müşterinin ERP / veri ekibi — dosyayı üreten taraf.

---

## 1 · Amaç

CollMind, promosyon ve anlaşmaların **gerçekte ne sonuç verdiğini** ölçmek için
ERP'nizden **gerçekleşen satış** verisi alır: ne satıldı, kime, ne zaman, kaç adet,
hangi fiyattan ve fatura üzerinde ne kadar indirim yapıldı.

Bu belge o dosyanın **biçimini** tanımlar. Dosya ERP'nizin **kendi dilinde** olur:
CollMind'a özgü hiçbir kod, eşleştirme numarası ya da bütçe bilgisi **istenmez**.
Eşleştirmeyi CollMind yapar.

## 2 · Temel ilkeler

1. **Bir satır = bir ERP satış kalemi** (ya da bir aylık toplam — bkz. §6).
2. **Bir dosya = bir ay.** Dosyadaki bütün faturalar **aynı takvim ayına** ait olur. Birden
   çok ayı kapsayan bir export'u **ay başına ayrı dosyaya bölerek** gönderin.
3. **Ne gördüyseniz onu gönderin.** Tahmin, dağıtım ya da hesap yapmanız gerekmez;
   tek istisna fatura-altı indirimidir (bkz. §4.3).
4. **Eksik ya da tutarsız satır sessizce kabul edilmez.** Her reddedilen satır, bir
   **red kodu** ve düzeltme önerisiyle size geri raporlanır (bkz. §7).
5. **İade bu sürümde gönderilmez.** Negatif tutarlı satırlar reddedilir (bkz. §8).

---

## 3 · Dosya biçimi

| özellik | değer |
|---|---|
| biçim | CSV (UTF-8) — ilk satır **başlık** |
| ayraç | virgül `,` |
| ondalık | nokta `.` — binlik ayracı **kullanmayın** (`1250000.50`, `1.250.000,50` değil) |
| tarih | `YYYY-AA-GG` (ör. `2026-07-15`) |
| para birimi | tutarlar KDV hariç, satır para biriminde; alan boşsa **TRY** kabul edilir |
| boş alan | opsiyonel alan boş bırakılabilir; **zorunlu alan boş bırakılamaz** |

---

## 4 · Alanlar

### 4.1 · Alan listesi

| başlık adı | anlamı | tip | zorunluluk | örnek |
|---|---|---|---|---|
| `sku_code` | ürün (stok) kodu | metin | **ikisinden biri** zorunlu → | `SKU-100231` |
| `fu_code` | ürün grubu kodu | metin | ← **ikisinden biri** zorunlu | `FU-NEW-WAVE` |
| `customer_code` | müşteri kodu (ERP cari kodu) | metin | **ikisinden biri** zorunlu → | `C-004512` |
| `cpl_code` | müşteri grubu kodu | metin | ← **ikisinden biri** zorunlu | `BS0501.50006` |
| `invoice_date` | fatura tarihi — dosyadaki **tüm satırlarda aynı ay** | tarih | **zorunlu** | `2026-07-15` |
| `invoice_no` | fatura numarası | metin | opsiyonel | `FTR2026070001234` |
| `quantity` | adet | sayı | **zorunlu** | `120` |
| `unit_price` | birim liste fiyatı — **sıfırdan büyük**, bedelsiz malda da | sayı | **zorunlu** | `85.00` |
| `gross_amount` | brüt tutar | sayı | **zorunlu** | `10200.00` |
| `discount_amount` | fatura üzerindeki indirim (satıra dağıtılmış) | sayı | opsiyonel (yoksa 0) | `1020.00` |
| `net_amount` | net tutar | sayı | opsiyonel | `9180.00` |
| `free_goods` | bedelsiz mal işareti | `E` / `H` | opsiyonel (yoksa `H`) | `E` |
| `currency` | para birimi | metin | opsiyonel (yoksa `TRY`) | `TRY` |

> ⚠️ **TASLAK:** `free_goods` alanının **adı, değer kümesi** ve bedelsiz satırda brüt/indirim/net
> alanlarının **nasıl doldurulacağı** önerimizdir; ERP'nizde bu bilgi başka biçimde duruyorsa
> bize bildirin (§9).

### 4.2 · "İkisinden biri" alanları

- **Ürün:** `sku_code` **ya da** `fu_code`. İkisi birden gelirse ikisinin **aynı ürün
  grubuna** ait olması gerekir.
  - `sku_code` gönderirseniz ürün grubunu CollMind bulur.
  - Yalnız `fu_code` gönderirseniz veri **ürün grubu düzeyinde** kalır; CollMind bunu
    stok kodlarına **bölmez**.
- **Müşteri:** `customer_code` **ya da** `cpl_code`.
  - `customer_code` gönderirseniz müşteri grubunu CollMind, sizin daha önce paylaştığınız
    müşteri listesinden bulur. Müşterinin bir müşteri grubuna bağlı olması gerekir.
  - Yalnız `cpl_code` gönderirseniz veri **müşteri grubu düzeyinde** kalır.

Aynı dosyada bazı satırlar stok koduyla, bazıları ürün grubu koduyla gelebilir — **karışık
düzey kabul edilir**.

### 4.3 · Tutarlar arasındaki ilişki

```
net_amount = gross_amount − discount_amount        (tolerans YOK — kuruşu kuruşuna)
```

- `net_amount` gönderirseniz CollMind bu eşitliği **kontrol eder**; tutmazsa satır reddedilir.
  Gönderdiğiniz net, denetim için **olduğu gibi saklanır**.
- `net_amount` boşsa CollMind onu bu eşitlikten **hesaplar**.
- `discount_amount` **faturanın altına toplu yazılmış** bir indirimse, onu **satırlara
  dağıtarak** gönderin. Hangi satıra ne kadar düştüğünü ERP'niz bilir; CollMind bilemez.
  Satıra dağıtılmamış (hiçbir ürüne bağlı olmayan) bir indirim satırı reddedilir.

### 4.4 · Göndermeyeceğiniz bilgiler

Aşağıdakileri dosyaya **koymayın** — CollMind bunları kendisi bulur:

- anlaşma, promosyon, plan ya da taktik numarası
- bütçe dönemi (dönem **fatura tarihinden** çıkarılır)
- kanal (müşteri grubunun kanalıdır) ve kategori (ürün grubundan çıkarılır)
- satır tipi (satış / indirim / bedelsiz — bkz. §5)

---

## 5 · CollMind satırınızı nasıl okur

Bir satır, CollMind'da bir ya da iki **kayda** dönüşür. Bunu siz işaretlemezsiniz:

| satırınızda | CollMind'daki kayıt |
|---|---|
| satış, indirim yok | **satış** |
| satış, `discount_amount > 0` | **satış** + **fatura üzeri indirim** |
| `discount_amount = gross_amount` (%100 indirim) | **bedelsiz mal** (değeri: adet × birim fiyat) |
| `free_goods = E` ve `unit_price > 0` | **bedelsiz mal** (değeri: adet × birim fiyat) |

- Bedelsiz malın değeri **birim fiyattan** hesaplanır. Bu yüzden bedelsiz satırda da
  **gerçek birim fiyatı** gönderin. Birim fiyatı `0` olan bir bedelsiz satır reddedilir
  (`FREE_GOODS_UNPRICED`) — değeri hesaplanamaz.
- Hesaplarda kullanılan net, satış eksi indirim olarak hesaplanır ve gönderdiğiniz net ile
  **aynı** olmak zorundadır (§4.3).

---

## 6 · Ayrıntı düzeyi — iki seçenek, tek biçim

| seçenek | ne gönderirsiniz | ne zaman |
|---|---|---|
| **Aylık toplam** (varsayılan) | her müşteri × ürün × ay için **tek satır**; `invoice_date` = o ayın herhangi bir günü, `invoice_no` boş | az veriyle başlamak için |
| **Fatura kalemi** | her fatura kalemi **ayrı satır** | fatura düzeyinde izleme istendiğinde |

İki seçenek **aynı sütunları** kullanır. Fatura kalemi gönderirseniz aylık toplamı
CollMind hesaplar. İlk dosyadan önce hangisiyle başlayacağımızı birlikte seçelim.

### 6.1 · Aynı ay için yeniden gönderim

Bir ayın dosyasını **düzelterek yeniden** gönderirseniz, yeni dosya o ayın önceki
yüklemesinin **yerine geçer** (müşteri grubu × kategori × kanal kapsamında). Önceki
yüklemeden doğan kayıtlar silinmez; **ters kayıtla** kapatılır — denetim izi korunur.

---

## 7 · Red kodları

Reddedilen her satır için size **satır numarası + red kodu + açıklama** döneriz.

| red kodu | ne demek | ne yapmalısınız |
|---|---|---|
| `UNKNOWN_SKU` | stok kodu bizim ürün listemizde yok | kodu kontrol edin ya da yeni ürünü ürün listesiyle bize bildirin |
| `UNKNOWN_FU` | ürün grubu kodu bulunamadı | kodu kontrol edin |
| `SKU_WITHOUT_FU` | stok kodu bir ürün grubuna bağlı değil | ürünün grup bilgisini ürün listesinde güncelleyin ya da satıra `fu_code` ekleyin |
| `FU_SKU_MISMATCH` | `sku_code` ile `fu_code` farklı ürün gruplarına ait | ikisinden birini düzeltin |
| `UNKNOWN_CPL` | müşteri grubu kodu bulunamadı | kodu kontrol edin |
| `UNKNOWN_CUSTOMER` | müşteri kodu bulunamadı ya da bir müşteri grubuna bağlı değil | kodu kontrol edin; müşterinin grup bilgisini müşteri listesinde güncelleyin |
| `MISSING_REQUIRED_FIELD` | zorunlu bir alan boş (ürün kodu, müşteri kodu, fatura tarihi, adet, birim fiyat ya da brüt tutar) | alanı doldurun |
| `INVALID_DATE` | fatura tarihi okunamadı ya da geçersiz | `YYYY-AA-GG` biçiminde gönderin |
| `MIXED_PERIOD` | dosyada farklı aylara ait faturalar var | dosyayı ay başına bölün (§2) |
| `AMOUNT_RECONCILIATION` | `net_amount ≠ gross_amount − discount_amount` | tutarları düzeltin ya da `net_amount`'u boş bırakın |
| `DISCOUNT_EXCEEDS_GROSS` | indirim brüt tutardan büyük | tutarları kontrol edin |
| `HEADER_DISCOUNT_UNALLOCATED` | hiçbir ürüne bağlı olmayan bir indirim satırı | fatura-altı indirimi satırlara dağıtın (§4.3) |
| `DISCOUNT_WITHOUT_SALE` | aynı müşteri × ürün × ay için satış olmadan indirim | satış satırını da gönderin |
| `FREE_GOODS_UNPRICED` | bedelsiz mal satırında birim fiyat `0` | gerçek birim fiyatı gönderin (§5) |
| `NEGATIVE_AMOUNT` | bir tutar ya da adet negatif — **iade bu sürümde kapsam dışı** | iade satırlarını bu dosyadan çıkarın (§8) |
| `INVALID_GROSS_AMOUNT` | brüt tutar okunamadı ya da sıfır | tutarı kontrol edin (§9 A6) |

---

## 8 · Bu sürümde kapsam dışı

- **İade** (negatif adet ya da tutar) — v2'de gelir.
- **Gerçek ERP dosyanızla sınanmadı.** Bu sözleşme ilk gerçek dosyanızla sınanacak;
  CollMind her ihlali adıyla raporlayacak ve sözleşmeyi gerekirse birlikte güncelleyeceğiz.

---

## 9 · Açık noktalar — gönderimden önce kapanır

> Bu bölüm iç taslakta durur; ERP ekibine giden sürümde **çıkarılır**.

| # | açık nokta | durum |
|---|---|---|
| A1 | ~~Bedelsiz malın "birim fiyat = 0" şekli~~ | ✅ **KAPANDI** (`Z111 §13` B5/B6): kabul edilmez → `FREE_GOODS_UNPRICED` |
| A2 | ~~Müşteri kodlu satırda kanal~~ | ✅ **KAPANDI** (`Z111 §13` B3): kanal = müşteri grubunun kanalı (bugün 27/27 tutarlı) |
| A3 | ~~Yeniden gönderim kapsamı~~ | ✅ **KAPANDI** (`Z111 §13` B1): dosya = tek ay (`MIXED_PERIOD`), yeniden gönderim o ayın kapsamını değiştirir (§6.1) |
| A4 | ~~Red kodu adları~~ | ✅ **KAPANDI** (`Z111 §13` U4): mevcut CollMind sözlüğü (`UNKNOWN_*`) |
| A5 | **`free_goods` işaretinin adı, değerleri ve bedelsiz satırda brüt/indirim/net'in doldurulması** — Wella ERP'sinde bedelsiz bilgisi nasıl duruyor? | ⏳ açık — ERP ekibiyle |
| A6 | **Sıfır brüt** (`gross_amount = 0`, bedelsiz dışı) — bugün reddediliyor; ilk gerçek dosyada meşru bir sıfır görülürse karar yeniden verilir. | ⏳ açık — ilk gerçek dosya |
| A7 | **Bedelsiz malın hangi promosyona sayılacağı** — CollMind'da bugün bedelsiz-ürün tipi bir taktik tanımlı değil; ERP dosyasını etkilemez, iç tanım. | ⏳ açık — iç (`Z111 §13.2` N1) |

---

## 10 · Örnek dosyalar

> Kodlar **temsilidir**; kendi ürün ve müşteri listelerinizdeki kodları kullanın.
> Her örnek **tek bir ay** taşır (§2).

### 10.1 · Aylık toplam — ürün grubu + müşteri grubu (Temmuz)

```csv
fu_code,cpl_code,invoice_date,invoice_no,quantity,unit_price,gross_amount,discount_amount,net_amount
FU-NEW-WAVE,BS0501.50006,2026-07-31,,4000,100.00,400000.00,15000.00,385000.00
FU-COLOR-PRO,BS0501.50006,2026-07-31,,2500,200.00,500000.00,0.00,500000.00
```

### 10.2 · Fatura kalemi — stok kodu + müşteri kodu (Temmuz)

```csv
sku_code,customer_code,invoice_date,invoice_no,quantity,unit_price,gross_amount,discount_amount,net_amount
SKU-100231,C-004512,2026-07-03,FTR2026070001234,120,85.00,10200.00,1020.00,9180.00
SKU-100232,C-004512,2026-07-03,FTR2026070001234,60,120.00,7200.00,0.00,7200.00
SKU-100231,C-004513,2026-07-18,FTR2026070001301,40,85.00,3400.00,170.00,3230.00
```

### 10.3 · Karışık düzey — net boş, CollMind hesaplar (Ağustos)

```csv
sku_code,fu_code,cpl_code,invoice_date,quantity,unit_price,gross_amount,discount_amount,net_amount
SKU-100231,,BS0501.50006,2026-08-12,200,85.00,17000.00,850.00,
,FU-COLOR-PRO,BS0501.50006,2026-08-31,1000,200.00,200000.00,10000.00,
```

### 10.4 · Bedelsiz mal — iki kabul edilen şekil (Temmuz)

```csv
sku_code,cpl_code,invoice_date,quantity,unit_price,gross_amount,discount_amount,net_amount,free_goods
SKU-100231,BS0501.50006,2026-07-10,24,85.00,2040.00,2040.00,0.00,H
SKU-100232,BS0501.50006,2026-07-10,12,120.00,1440.00,1440.00,0.00,E
```
- 1. satır: %100 indirim (indirim = brüt) → **bedelsiz mal**, değeri 24 × 85.00.
- 2. satır: `free_goods = E`, birim fiyat 120.00 → **bedelsiz mal**, değeri 12 × 120.00.

> ⚠️ **TASLAK (§9 A5):** işaretli bedelsiz satırda brüt/indirim/net'in nasıl doldurulacağı
> ERP ekibiyle kesinleşir; bu örnek %100-indirim biçimini tekrar ediyor.

---

## Sürüm notu

| sürüm | tarih | değişiklik |
|---|---|---|
| v1 (taslak) | 2026-09-10 | ilk sürüm — satış, fatura üzeri indirim, bedelsiz mal; iade kapsam dışı (v2) |
| v1 (taslak, rev.) | 2026-09-11 | `Z111 §13`: dosya = tek ay (`MIXED_PERIOD`) · red kodları mevcut sözlükle (`UNKNOWN_*`) · bedelsizde birim fiyat > 0 (`FREE_GOODS_UNPRICED`) · kanal müşteri grubundan · yeniden gönderim (§6.1) |
