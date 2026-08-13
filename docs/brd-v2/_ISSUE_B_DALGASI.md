# `B` Dalgası — ön koşul ölçümü ve kapsam değişiklikleri

> `B` dalgası, `L2` kurallarının **şema tarafına** inen işlerin dalgası. Bu dosya o dalganın
> **ön koşul tablosunu** ve ölçüm sonrası **kapsam değişikliklerini** tutar.
>
> 📌 **Kalem listesi burada DEĞİL — kanonik yeri `EK_C_VERI_SOZLUGU.md §B dalgası — kanonik
> kalem listesi`.** `S1`–`S14` · `R1`–`R3` · seed · `kabul-1`…`kabul-8` orada yaşar; bu
> dosya onlara **atıf verir, kopyalamaz**. (2026-08-13'e kadar liste hiçbir belgede yoktu:
> bir kez yazıldı, iki kez numaralandı — `B1`–`B9` ↔ `S`/`R` — ve eşleme yalnız issue
> gövdesinde kaldı.)

- **Ölçüm tarihi:** 2026-08-12
- **Ölçüm kaydı:** `docs/analysis/0069-b-dalgasi-on-kosul-olcumu-kod-tarafi.md` — **kanonik**;
  bu dosya oradan **sonuç** taşır, gövde taşımaz
- **Ölçüm ortamı:** meta `a0fc0ec` · backend `5743c6e` (kod) · **2026-08-13 ek turu:** backend
  `276532c` + **tek kullanımlık PostgreSQL 16.13** (migration + seed)
- ⚠️ **Veri kapsamı:** o DB **üretim değil** — yalnız seed. `sales_actuals` 3 satır ·
  `agreements` 3 · `ledger_entries`/`on_invoice_entries`/`agreement_transactions`/`plans`
  **0**. Yani ölçülen şey **şemanın neye izin verdiği** ve **kodun ne yazdığı**; üretim
  değerleri hâlâ ölçülmedi

---

## 1. Ön koşul tablosu — kod tarafı **kapandı**

| # | soru | durum | sonuç |
|---|---|---|---|
| **C1** | `INV-T-002` nereye bakıyor | ✅ ölçüldü | ⛔ **yalnız gönderen** — ve dayanacağı kolon yok |
| **C3** | net = brüt − indirim kısıtı yazılabilir mi | ✅ ölçüldü → **karar geçersizleşti** (§5) | ⛔ **HAYIR** — kısıt reddediliyor, ve soru alan tanımına döndü |
| **F14** | planın organizasyon bağlantısı | ✅ ölçüldü → **bulgu satırına geçti** (§3) | dört denormalize kolon |
| **F16** | satış verisinde SKU + hacim | ✅ **KAPANDI 2026-08-13** — TTM kanıtıyla (§4) | sınıf: **pilot profili** → `İlke 5`; `A2` **ayakta** · ⚠️ **kanıt boşluğu**, aşağıda |
| **Ö4** | dönem alanları tutarlı mı | ✅ ölçüldü + probe | biçim tek, **ad iki**, biri nullable — ve temizlik **tesadüf** (§6) |
| **C2** | iade `sales_actuals`'ta nasıl temsil ediliyor | ✅ ölçüldü (2026-08-13) | ⛔ **temsil yok, kanal AÇIK** → [[T-208]] |
| `F13` | tutarlar KDV dahil mi hariç mi | ⚠️ **kod ölçüldü, veri ölçülemedi** | kodda KDV kavramı **hiç yok**; ölçek sorusu üretim verisi ister |

> ⚠️ **2026-08-13: bu cümle artık yanlış.** `C3`'ün veri ölçümü `S3`'ü dalgadan çıkardı —
> yani migration'ı bloklayan bir soru **doğdu** ([[T-209]], alan tanımı). Kalan iki
> soru davranış tarafındaydı; biri (`C2`) kapandı ve bir task'a döndü.

## ⚠️ `F16`'nın kanıt boşluğu — kaydedilsin, dalgayı bloklamıyor

`F16` kapandı ve *"kolon eklenir"* gerekçesi artık **ölçülü** (`0070 §B1`). Ama kanıtın
kapsamı **dar**:

> **16 CSV'nin KÖKENİ ölçülmedi.** Şablon **TTM'in istediğini** kanıtlıyor — **Wella'nın
> verdiğini** değil.

İkisi farklı iddia: bir içe-aktarma şablonu bir **talebi** gösterir, bir **teslimi** değil.
Pilot profili sınıflandırması ikincisine dayanıyor.

**Ucuz kapanış:** `docs/analysis/0055`'in UAT koşusu **gerçek Wella verisiyle** miydi?
(`docs/uat/uat_actuals_2026_06.csv` · `UAT_EXPECTED_RESULTS_2026_06.xlsx` — kaynağı
ölçülmedi.) Tek dosya okuması, ve cevabı `F16`'nın sınıfını **doğrular ya da zayıflatır**.

---

## ✅ Dalga onayının ön koşulu **KALMADI** (2026-08-13)

```
[[T-206]]   ✅ KAPANDI — sınıf: pilot profili (TTM kanıtıyla, §4)
```

[[T-209]] onunla aynı oturumda koşacaktı; `T-206` kapandı, `T-209` **açık kaldı** ama
dalgayı **bloklamıyor** — ikisi `K-2.1.19a`'nın *"aynı sorunun iki yüzü"* iddiasını
paylaşıyor — aynı yöntem: `git blame` + commit bağlamı + besleyen içe aktarma yolunun
kaynak kolonu.

✅ **Ve `L2`'de açık kural kalmadı** (2026-08-13): `K-2.6.4` (rol kataloğu) ve `K-2.5.12`
(tek onay hattı) ürün sahibi kararıyla kapandı — ikisi de **karar sınıfıydı**, bir ölçümle
kapanamazlardı, ve ölçüm paketine alınmaları cevaplanamayacak bir soruyu kuyruğa sokardı.
`açık: 0` bir eşiktir: `L2`'de **dayanaksız yürürlükte madde yok** — kalan her şey adresli.

---

## 2. ⛔ `C1` — `C4` kararı bugün **uygulanamaz**

`C4`: *"kendi gönderdiğini onaylama: istisna yok. Kapsam **gönderen ∪ son değiştiren**."*
`K-2.5.11` bu kapsamı yazıyor. **Dayanacağı kolon yok.**

```
plan.service.ts:1401   approve()  if (plan.submittedById === userId) throw
plan.service.ts:1691   reject()   if (plan.submittedById === userId) throw
approval.service.ts:115 approve() if (request.requestedById === approverId) throw

grep "lastModifiedBy|updatedById|modifiedBy" src/database/entities/*.ts  →  0
```

### Ve üçüncü bulgu daha ağır: dar kontrol bile delinebiliyor

`submittedById` **yeniden atanabilir** (`plan.service.ts:1776-1813` bunu bir özellik olarak
yazıyor: *"bir PLANNER yaratıp başka biri gönderebilir"*) ve bir yolda **`null`'a çekiliyor**
(`:1874`).

> **`C4`'ün *"daraltıldı"* dediği koruma, bugün dar bile değil** — tek dayanağı değiştirilebilir
> ve boşaltılabilir bir alan.

### Şema kalemi — `S13` (yeni)

```
son değiştiren alanı              ⛔ "yeni kolon" DEĞİL — updated_by zaten var (base.entity.ts:31)
                                  ve düzenleme yolu yazıyor (plan.service.ts:450 → updateVersioned)
gönderen alanının değişmezliği    submittedById bir kez yazılır, sonra sabit
```

⚠️ Yukarıdaki `grep "lastModifiedBy|updatedById|modifiedBy" → 0` ölçümü **kapsamı doğru,
terim listesi yanlış** bir aramaydı: üç adın hiçbiri ne katalog dilinde (`updated_by`) ne
entity dilinde (`updatedBy`). Yeni kolon eklenseydi **iki ayrı son-değiştiren alanı**
doğardı. → [[T-207]]

📌 `INV-T-002`'nin bugünkü *"Status: HOLDS"* etiketi **dar tanıma göre doğru** (sözleşme
cümlesi *"submitted"* diyor). `K-2.5.11`'in kapsamı uygulanınca **invariant metni de**
güncellenmeli — yoksa guard yeşil kalır, bypass açık kalır.

⚠️ **`null`'a çekilen yol ayrı bir kusur** → [[T-205]]. Şema kaleminden bağımsız: `S13`
inse bile o yol `submittedById`'yi boşaltmaya devam ederse dar kontrol yine delinir.

---

## 3. `F14` — bulgu: planın organizasyon bağlantısı

```
plans.cpl_id       uuid  NOT NULL
plans.channel_id   uuid  NOT NULL
plans.category_id  uuid  NOT NULL
plans.region_id    uuid  NULLABLE
```

Bağlantı bir ara tabloda değil, **planın kendi satırında denormalize**. Zarf çözümlemesi
(kanal × kategori × dönem) için gereken üç eksen **zorunlu** olarak duruyor.

📌 `A7` kararıyla (*kapsam = kanal + müşteri + kategori, bölge Faz 2*) **uyumlu**.
Ve `0056-K5`'in sorusu değişiyor: *"region eklensin mi"* → **"zorunlu olsun mu"** — kolon
zaten var, nullable.

---

## 4. `F16` — bulgu: SKU ve hacim **yok, ve bu bir karar**

`sales_actuals` grain'i: **CPL × Kategori × Kanal × Dönem**, tutar agregası.
`sku` / `quantity` / `volume` / `units` kolonu: **0**.

Entity'nin kendi başlığı gerekçeyi yazıyor:

> *"FU/SKU ve hacim boyutu **YOKTUR** — Wella actuals CSV'sinde `fu_code`/`volume`
> kolonları bulunmuyor."*

### İki sonuç

**(a) `A2`'nin dağıtım tabanı beslenemez.** `K-2.1.8a` dağıtımı **geçmiş SKU hacim payına**
bağlıyor; bugünkü model o veriyi taşımıyor. Yani `A2` **bugün uygulanamaz** — ya kaynak
genişler ya kural taban değiştirir.

📌 Ve bir **kestirme kapatıldı:** `on_invoice_entries` SKU kırılımı **taşıyor**
(`on-invoice-entry.entity.ts:53` `sku_id`, `:56` `sku_code`), yani *"veri zaten var"*
denip oradan dağıtım tabanı türetilmesi cazip. `K-2.1.8a1` bunu **yasaklıyor**: o küme
yalnız fatura-içi mekaniğe giren ürünleri kapsar → **sistematik yanlılık**.
⚠️ Üstelik o tabloda **hacim/adet kolonu da yok** (`quantity`/`volume`: 0) — kestirme
zaten hacim payı üretemezdi.

**(b) Daha ağır olan ikinci sınır:** aynı entity şunu da yazıyor —

> *"`discountAmount` **satış iskontosudur**; asla bütçeye/ledger'a/spend'e yazılmaz.
> On-invoice indirimiyle ekonomik olarak örtüşebilir; on-invoice zaten kendi akışında
> ledger'a yazıyor, burada tekrar kullanılırsa **çift sayım** olur (T-003/T-017'nin kökü)."*

📌 Bu, `K-2.13.14h3`'ün (**net taban**) gerekçesiyle **doğrudan kesişiyor**: hakediş tabanı
"net satış" ise, o netin içindeki iskonto **bütçe tarafında zaten sayılmış** olabilir.

### ✅ `F16` YENİDEN YAZILDI (2026-08-13) — sınıf **`pilot profili`**

[[T-206]] kapandı. `CollMind/TTM` bu oturumda klonlandı (`19c6376`) ve bir turdur ölçülmeden
taşınan iddia **doğrudan doğrulandı:**

```
apps/api/src/actuals/actuals.service.ts — validateRow()
  :991   if (!row.fu_code?.trim()) throw new Error('fu_code is required');
  :1045  if (volume === 0 && grossAmount > 0) throw new Error('…must have a positive volume')
```

Ve ikinci, daha güçlü kanıt — TTM'in **kanonik** biçimi:

```
apps/web/public/templates/actuals_template.csv
  cpl_code,fu_code,gross_amount,net_amount,discount_amount,volume

TTM'de cpl_code ile başlayan CSV : 22
  fu_code + volume taşıyan       : 16
  CTPM'in biçimi (hacimsiz)      :  4  — hepsi eski/ikincil test verisi
```

| şık | sonuç |
|---|---|
| kaynak sınırı (ERP veremiyordu) | ⛔ **ELENDİ** — kardeş ürün aynı veriyi **zorunlu tutuyor** ve şablonuyla topluyor |
| **pilot profili kararı** | ✅ **SEÇİLDİ** — gerekçe tek müşterinin dosya başlığı, ve o başlık TTM'de bile ikincil |
| gerçek domain kararı | ⛔ ELENDİ — ürün ilkesi olsaydı TTM'in kanonik şablonu onu ihlal ederdi |

**İki sonuç değişti:**

1. **`A2` / `K-2.1.8a` AYAKTA ve uygulanabilir.** Taban değişikliği gerekmiyor — gereken şey
   kaynağın genişlemesi, ve o genişleme kardeş üründe **zaten yazılmış.**
2. **Karar tenant profiline iner** (`İlke 5`): ürün varsayılanı FU + hacim **taşıyabilmelidir**;
   hacimsiz alım bir **müşteri profili**, ürün kuralı değil.

⚠️ **Şema etkisi:** `sales_actuals`'a `fu_id`/`sku_id` + `volume` **eklenebilir olmalı**
(nullable) — bu dalganın değil, ama `A2` uygulanacaksa bir sonraki dalganın kalemi.

> **`(b)` alan sorusunun sınıfı ayrı ve `0069 §5`'te:** üç şık, `(c)` ölçümle elendi,
> ön karar `(a)` — ve TTM ölçümü onu da güçlendirdi (`discount_amount` ∩ ledger/budget/claim
> → **0 satır**). → [[T-209]]
>
> ⚠️ Ama kesinleşmedi: TTM'de **nasıl kullanıldığını** ölçtük, **ne anlama geldiğini** değil.

📌 Ölçümün tamamı: `docs/analysis/0070-b-dalgasi-olcum-turu-ttm-kanitiyla.md`

---

## 5. `C3` — net kısıtı: karar verildi

**Ölçülen bugünkü hâl:** kural **yalnız uyarı**, `±0,01` toleranslı, `net`/`discount`
**nullable**, `sales_actuals` üzerinde **0 `CHECK`**.

**Karar (ürün sahibi, 2026-08-12): tolerans kısıtta olmasın.**

```sql
CHECK (net_amount IS NULL OR discount_amount IS NULL OR gross_amount IS NULL
       OR net_amount = gross_amount - discount_amount)
```

**Gerekçe:** tolerans bir **veri kalitesi** meselesidir (`K-2.7.4`, `<%2`), bir **bütünlük
kısıtı** değil. Kısıt **tam eşitlik** arar; tolerans gerekiyorsa içe aktarma doğrulamasında
yaşar — ve kaynaksız sabit orada da olmaz.

📌 `±0,01` bugün kodda bir sabit (`RECONCILIATION_TOLERANCE`) ve kaynakta *"BRD'de tanımsız"*
diye işaretli — yani `K-2.4.22`'nin *"%80 neden 80"* itirazının kardeşi.

**`NULL` toleransı korunuyor** — üç alan bağımsız gelebiliyor.

### ⛔ Ve karar 2026-08-13'te GEÇERSİZLEŞTİ — `S3` dalgadan **ÇIKTI**

Veri tarafı ölçülünce soru değişti. Kısıt bugün **eklenemiyor**:

```
ALTER TABLE main.sales_actuals ADD CONSTRAINT ck_sa_net CHECK (…);
ERROR: check constraint "ck_sa_net" of relation "sales_actuals"
       is violated by some row
```

Sapma **3/3 satır** (pilot verisinin tamamı), en büyük `25.000`, toplam `63.000`.

> ⚠️ **`%100` sapma bir veri kalitesi sorunu değil, bir MODEL UYUŞMAZLIĞI işaretidir.**

Ve uyuşmazlık adlandırıldı: `discount_amount` entity'de **satış iskontosu**, `gross − net`
ise **toplam indirim**. İkisi eşit olmak zorunda değilse **kısıt yanlış, veri değil.**

```
gross_amount     brüt satış
discount_amount  ?   ← satış iskontosu mu, toplam indirim mi
net_amount       net satış
```

→ **`S3` sıralanmaz, ÇIKAR.** Sıralanacak şey bir veri düzeltmesi olsaydı sıraya girerdi;
sıralanacak şey bir **tanım**. Üçünün ilişkisi tanımlanmadan ne kısıt yazılabilir, ne net
taban (`K-2.13.14h6`) — ve o kural bu turda ⛔ işaretlendi.

📌 Kanonik takip: `docs/decisions/OPEN_DECISIONS.md` — `v2-UC-ALAN`.

### `C2` — ve aynı tabloda ikinci bir sessizlik

İade temsili **yok**, ama negatif tutar kanalı **açık**: gramer `-?\d+`, pozitiflik
kontrolü yok, `0 CHECK`, probe kabul etti. Kardeş yollarda (on-invoice · off-invoice)
pozitiflik kuralı **var** — yani tutarsızlık kodda. → [[T-208]]

---

## 6. `Ö4` — backfill planının şekli

Sekiz tabloda dönem kolonu, hepsi `varchar(7)`:

| ad | tablolar |
|---|---|
| `fiscal_period` (5) | `agreement_transactions` ⚠️ **nullable** · `on_invoice_batches` · `on_invoice_entries` · `sales_actual_batches` · `sales_actuals` |
| `period_month` (3) | `agreements` · `ledger_entries` · `plans` |

**Biçim tek, ad iki, biri nullable.** Yani `Ö4`'ün ikili kararı (*tek jenerik backfill* ↔
*tablo başına eşleme*) ikisinin **arasına** düşüyor:

→ **`S11`'e**: backfill **tek jenerik** olabilir, ama **kolon adı parametreli** olmalı
(iki ad), ve `agreement_transactions`'ın **`NULL` davranışı ayrı karar** (doldur mu, atla mı).

### ✅ Değer tarafı ölçüldü (2026-08-13) — ve asıl bulgu **probe**

Katalog, entity ölçümünü doğruladı: sekiz kolon, hepsi `varchar(7)`, `fiscal_period` ×5 /
`period_month` ×3, ve nullable olan **tam olarak bir tane** (`agreement_transactions`).

Ama değerlerin temiz olması bir **garanti değil**:

```
UPDATE … fiscal_period = '2026-13'  →  KABUL
UPDATE … fiscal_period = '2026/01'  →  KABUL
```

> **Mevcut satırların temiz olması kural değil, TESADÜF.**

Sekiz kolonun **altısında** yazma tarafında hiçbir gramer yok, ve olan ikisinden biri
(`create-ledger-entry.dto.ts:53`, `^\d{4}-\d{2}$`) `2026-13`'ü **zaten geçiriyor**.
Sıfır `CHECK`.

📌 **Bu, `INV-C-*` ailesinin tam üyesi: kazara sağlanan bir şart.** `INV-C-001` (hiçbir şey
silinmiyor) ve `INV-C-004` (ERP yok) ile aynı şekil — bir kod değişikliğiyle değil, bir
**veri işlemiyle** bozulur, ve o gün hiçbir test kırmızıya dönmez.
⚠️ Sözleşmeye yeni bir `INV-C-*` maddesi **basmadım** — invariant üretmek ürün sahibinin
kararı; burada yalnız **aday** olarak kayıtlı.

→ **`S11`'e ek:** backfill **biçim doğrulamalı**, ve `CHECK` **bir dalga kalemi olmalı** —
backfill'in yan ürünü değil.

⚠️ **Kapsam sınırı:** aykırı değer taraması yalnız **dolu iki tabloda** koşabildi
(`sales_actuals` 3 satır · `agreements` 3 satır, ikisi de temiz). Kalan altı tablo bu
ortamda **boş** — üretim taraması hâlâ gerekli.

⚠️ **Değerlerin bugün gerçekten `YYYY-MM` olduğu ÖLÇÜLMEDİ** — tip `varchar`, yani `2026-1`
ya da `2026/01` **saklanabilir**. `0060 §2` bu şekillerin *parser'da* reddedildiğini
ölçmüştü; **DB'de ne yattığı** ayrı bir soru ve veri tarafında.

---

## 7. Kapsam değişikliği özeti

| kalem | değişiklik | kaynağı |
|---|---|---|
| **`S3`** | ⛔ **DALGADAN ÇIKTI** — sıralanmaz: sıralanacak şey veri düzeltmesi değil, bir **tanım** (`v2-UC-ALAN` → [[T-209]]). Yerine `K-2.7.4a`: akıl sağlığı kontrolü (`net ≤ brüt`), kendisi de ⛔ `C2` kararına bağlı | `C3` veri ölçümü |
| **`S13`** | ⚠️ **ÖNERMESİ ÇÜRÜDÜ 2026-08-13** — *"yeni kolon"* değil: `updated_by` `BaseEntity`'de **var** ve yazılıyor ([[T-207]]). Kalan iş: yazma yollarının enumerasyonu + kontrolün genişletilmesi + gönderen **boşaltılamazlığı** (`K-2.5.16`, [[T-205]]) · ⚠️ **kapsam büyüdü**, aşağıda | `C1` + `0070 §B4` |
| **`S11`** | backfill **kolon adı parametreli** (iki ad, biri nullable) **+ biçim doğrulamalı**, ve `CHECK` **ayrı bir dalga kalemi** | `Ö4` + probe |

### ⛔ `S13` bir YETKİ YÜZEYİ değişikliği — ayrı madde (`0070 §B4`)

`submittedById` yalnız bir **kimlik alanı** değil; aynı fonksiyonda, boşaltmadan **önce**,
iki yerde bir **erişim anahtarı**:

```ts
plan.service.ts:1811, :1849
actor.userId !== plan.createdBy && actor.userId !== plan.submittedById  → 404
```

**Bugünkü sonuç ölçüldü:** *yaratmayan ama gönderen* bir `PLANNER`, plan taslağa döndükten
sonra ona **erişemiyor** (`404 OUT_OF_SCOPE`).

> **Boşaltmayı kaldırmak o erişimi GERİ VERİR.** Yani `S13` yalnız bir kolon dolduruyor
> değil — **kimin neye erişebildiğini değiştiriyor.**

`T-205`'in regresyon notu bu yüzden **iki maddeli**:
1. `TASLAK`'ta gönderen görünürlüğü (**bilinen**)
2. **Kapsam erişiminin genişlemesi** (**yeni**) — ve bu bir **yetki yüzeyi** değişikliğidir

⚠️ İkincisi dalga onayında ayrıca değerlendirilmeli: bir şema kalemi olarak masum görünüyor,
etkisi RBAC tarafında.

📌 Ve bugünkü hâli **canlı bir kusur** — ayrı task: [[T-210]].

---

**Ve dört task açıldı:** [[T-208]] (negatif kanal açık ve sessiz) · [[T-205]] (`submittedById` boşaltan yol — `K-2.5.16` ihlali) ·
[[T-207]] (`S13`: `last_modified_by` kolonu) · [[T-206]] (`F16`'nın tasarım kararının
gerekçesi ölçülsün).

📌 **`C1` artık yalnız bir ölçüm değil, yazılı bir kural:** `K-2.5.16` ailesi
(`L2_03 §2.5.4a`) köken alanlarını yaşam döngüsü alanlarından ayırıyor — *güncellenebilir,
asla boşaltılamaz*. Ve `F16` de bir kurala dönüştü: `K-2.1.8a1` (`L2_01 §Dağıtım kuralı`).
Kural sayısı **351 → 355**.

---

## 8. Kabul ölçütüne ek — `kabul-8` (2026-08-13)

> **Dalga kapandığında, kapattığı `❌` satırları `✅`'ya çevrilir.**

`L2 §Bu katmanın kuralları` md. 5 her `❌`/`⚠️` işaretine bir **adres** koyuyor: ön koşulu
bilinen karar → dalga referansı, ön koşulu ölçülecek karar → **ölçüm** referansı. Bu dalga
bugün iki adreste anılıyor:

| işaret | nerede | adres |
|---|---|---|
| ❌ | `K-2.5.11` ihlal notu | `S13` + [[T-205]] — **dalga** (ön koşul biliniyor) |
| ⚠️ | `K-2.1.8a` uygulama notu | [[T-206]] — **ölçüm** (dalga kalemi ölçüme bağlı) |

⚠️ İkisi aynı işlem değildir: birinci satır dalga kapanınca `✅` olur; **ikincisi olmaz** —
`T-206`'nın sonucu üç yoldan birine çıkar ve biri `A2`'nin tabanını yeniden karara götürür.
Dalga kapanışında ikinciyi de çevirmek, `T-206`'yı **önceden yargılamak** olur.

📌 **Ölçülmüştü (2026-08-13): `kabul-1`…`kabul-8` listesi bu repoda YOKTU** — `kabul-[0-9]`
taraması tüm `*.md` üzerinde **0** eşleşme verdi (pozitif kontrol: *"B dalgası"* üç dosyada
geçiyor). ✅ **Aynı gün `EK_C`'ye yazıldı** ve kanonik yeri orasıdır; buradaki blok
`kabul-8`'in **CTPM tarafındaki karşılığıdır**, listenin kendisi değil.

---

## 9. Bu dosyanın sınırları

- **Gövde burada değil.** Her ölçümün nasıl yapıldığı, hangi satırda ne bulunduğu
  `docs/analysis/0069`'da. Bu dosya **sonuç ve kapsam** taşır — `F8` sınıfına üye olmamak için.
- **`S3`/`S11`'in tam metni bu dosyada yok** — yalnız **değişiklik** yazılı. ✅ Kalemlerin
  kanonik tanımı **2026-08-13'te `EK_C`'ye yazıldı**; o güne kadar hiçbir belgede yoktu ve
  bu satır *"dalganın kendi kaydındadır"* diyerek var olmayan bir belgeye işaret ediyordu.
- **Veri tarafı ölçülmedi:** `C2`, `F13`, ve `Ö4`'ün değer kontrolü. DB gerektiriyor.
