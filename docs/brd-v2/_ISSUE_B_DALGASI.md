# `B` Dalgası — ön koşul ölçümü ve kapsam değişiklikleri

> `B` dalgası, `L2` kurallarının **şema tarafına** inen işlerin dalgası. Bu dosya o dalganın
> **ön koşul tablosunu** ve ölçüm sonrası **kapsam değişikliklerini** tutar.

- **Ölçüm tarihi:** 2026-08-12
- **Ölçüm kaydı:** `docs/analysis/0069-b-dalgasi-on-kosul-olcumu-kod-tarafi.md` — **kanonik**;
  bu dosya oradan **sonuç** taşır, gövde taşımaz
- **Ölçüm ortamı:** meta `a0fc0ec` · backend `5743c6e` · ⚠️ **DB yok**
  (`psql:5434 → refused`), yani veri tarafı ölçülmedi

---

## 1. Ön koşul tablosu — kod tarafı **kapandı**

| # | soru | durum | sonuç |
|---|---|---|---|
| **C1** | `INV-T-002` nereye bakıyor | ✅ ölçüldü | ⛔ **yalnız gönderen** — ve dayanacağı kolon yok |
| **C3** | net = brüt − indirim kısıtı yazılabilir mi | ✅ ölçüldü | ⚠️ yazılabilir, **üç şartla** |
| **F14** | planın organizasyon bağlantısı | ✅ ölçüldü → **bulgu satırına geçti** (§3) | dört denormalize kolon |
| **F16** | satış verisinde SKU + hacim | ✅ ölçüldü → **bulgu satırına geçti** (§4) | ⛔ ikisi de yok, **karar** |
| **Ö4** | dönem alanları tutarlı mı | ✅ ölçüldü | biçim tek, **ad iki**, biri nullable |
| `C2` | iade `sales_actuals`'ta nasıl temsil ediliyor | ⏸️ **veri** | davranış işlerini blokluyor, migration'ı değil |
| `F13` | tutarlar KDV dahil mi hariç mi | ⏸️ **veri** | aynı |

> **Migration'ı bloklayan hiçbir soru kalmadı.** Kalan ikisi davranış tarafında.

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
plans.last_modified_by            yeni kolon
gönderen alanının değişmezliği    submittedById bir kez yazılır, sonra sabit
```

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

**(b) Daha ağır olan ikinci sınır:** aynı entity şunu da yazıyor —

> *"`discountAmount` **satış iskontosudur**; asla bütçeye/ledger'a/spend'e yazılmaz.
> On-invoice indirimiyle ekonomik olarak örtüşebilir; on-invoice zaten kendi akışında
> ledger'a yazıyor, burada tekrar kullanılırsa **çift sayım** olur (T-003/T-017'nin kökü)."*

📌 Bu, `K-2.13.14h3`'ün (**net taban**) gerekçesiyle **doğrudan kesişiyor**: hakediş tabanı
"net satış" ise, o netin içindeki iskonto **bütçe tarafında zaten sayılmış** olabilir.

> ⚠️ **İkisi de `L2`'ye not olarak girmeli — ama önce ölçülmeli:** o tasarım kararının
> gerekçesi *"CSV'de kolon yoktu"* mu, yoksa **domain kararı** mı? Birincisi bir veri
> kaynağı sınırı (kaynak değişince kural değişir), ikincisi bir ürün kararı (değişmez).
> → [[T-206]]

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

→ **`S3`'e**: net kısıtı, `NULL`-toleranslı, **tolerans YOK**.

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

⚠️ **Değerlerin bugün gerçekten `YYYY-MM` olduğu ÖLÇÜLMEDİ** — tip `varchar`, yani `2026-1`
ya da `2026/01` **saklanabilir**. `0060 §2` bu şekillerin *parser'da* reddedildiğini
ölçmüştü; **DB'de ne yattığı** ayrı bir soru ve veri tarafında.

---

## 7. Kapsam değişikliği özeti

| kalem | değişiklik | kaynağı |
|---|---|---|
| **`S13`** | **yeni** — `plans.last_modified_by` + gönderen değişmezliği | `C1` |
| **`S3`** | net kısıtı: `NULL`-toleranslı, **tolerans yok**, tam eşitlik | `C3` kararı |
| **`S11`** | backfill **kolon adı parametreli** (iki ad, biri nullable) | `Ö4` |

**Ve iki task açıldı:** [[T-205]] (`submittedById` `null`'a çekilen yol — kusur) ·
[[T-206]] (`F16`'nın tasarım kararının gerekçesi ölçülsün).

---

## 8. Bu dosyanın sınırları

- **Gövde burada değil.** Her ölçümün nasıl yapıldığı, hangi satırda ne bulunduğu
  `docs/analysis/0069`'da. Bu dosya **sonuç ve kapsam** taşır — `F8` sınıfına üye olmamak için.
- **`S3`/`S11`'in tam metni bu dosyada yok** — yalnız **değişiklik** yazılı. Kalemlerin
  kanonik tanımı `B` dalgasının kendi kaydındadır.
- **Veri tarafı ölçülmedi:** `C2`, `F13`, ve `Ö4`'ün değer kontrolü. DB gerektiriyor.
