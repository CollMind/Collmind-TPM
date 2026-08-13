# 0069 — `B` dalgası ön koşul ölçümü — **kod tarafı** (C1 · C3 · F14 · F16 · Ö4)

- **Tarih:** 2026-08-12
- **Mod:** SALT-OKUNUR — hiçbir dosya değiştirilmedi.
- **Kapsam:** yedi sorgunun **kod tarafı beşi**. Veri tarafı (`C2` iade · `F13` KDV ·
  `F16`'nın hacim **değerleri**) bu turda **ölçülmedi** — gerekçe §0.
- **Ölçüm ortamı:** meta `4f1ed0c` · **backend `5743c6e`** (submodule checkout edildi) ·
  frontend `d9bedc5`.
- ⚠️ **DB YOK:** `psql localhost:5434` → **connection refused**. Aşağıdaki hiçbir satır
  veri sayımına dayanmıyor; hepsi **şema + kod** ölçümüdür.

---

## Özet

| # | soru | cevap | `B` dalgasına etkisi |
|---|---|---|---|
| **C1** | `INV-T-002` nereye bakıyor | **yalnız gönderen** — üç ayrı kontrol, üçü de `submittedBy`/`requestedBy` | ⛔ **bypass gerçek** |
| **C3** | net = brüt − indirim tutarlı mı, `CHECK` konabilir mi | kural **var ama yalnız uyarı**, ±0,01 toleranslı; iki kolon **nullable** | ⚠️ `CHECK` yazılabilir, **üç şartla** |
| **F14** | planın organizasyon bağlantısı şemada nerede | plan üzerinde **dört denormalize kolon** (`cpl_id`·`channel_id`·`category_id` NOT NULL, `region_id` **nullable**) | ✅ şekil net |
| **F16** | satış verisinde SKU kırılımı ve hacim | **İKİSİ DE YOK** — ve bu **bilinçli**, entity'de gerekçesiyle yazılı | ⛔ kapsamı değiştirir |
| **Ö4** | dönem alanları tutarlı biçimde mi | **biçim tutarlı** (`varchar(7)` ×8), **ad tutarsız** (`fiscal_period` ×5 / `period_month` ×3), **biri nullable** | ⚠️ tek jenerik backfill **mümkün, ama ada göre değil** |

---

## C1 · `INV-T-002` bugün nereye bakıyor

**Sözleşme** (`SYSTEM_INVARIANTS:422-427`):

> *"A user may not approve a request they **submitted**." — Status: HOLDS · Guard: TEST ✅ ·
> genel submitter≠approver kuralı, actuals'a özgü değil → **ürün politikası**"*

**Kod — üç ayrı yerde, üçü de aynı şekilde:**

```
plan.service.ts:1401   approve():  if (plan.submittedById === userId) throw
plan.service.ts:1691   reject():   if (plan.submittedById === userId) throw
approval.service.ts:115 approve(): if (request.requestedById === approverId) throw
                                    // yorum: "Self-approval prevention (BRD EA-001)"
```

**Ölçüm — "son değiştiren" alanı var mı:**

```
grep -rncE "lastModifiedBy|updatedById|modifiedBy" src/database/entities/*.ts  →  0
```

> ### Cevap: **yalnız `submittedBy`. Son değiştiren ne kontrol ediliyor ne de kaydediliyor.**
>
> Karar turunun `C4` kararı — *"kapsam **gönderen ∪ son değiştiren**"* — bugün **iki
> bakımdan** karşılanmıyor: kontrol dar, **ve dayanacağı kolon yok**.

⚠️ Ve bir ayrıntı bypass'ı somutlaştırıyor: `plan.service.ts:1776-1813` `submittedById`'nin
*"bir PLANNER yaratıp başka biri gönderebilir"* diye **yaratıcıdan ayrı** tutulduğunu
yazıyor, ve `:1874` bir yolda `submittedById: null` yazıyor. Yani bugünkü tek dayanak
**yeniden atanabilir ve boşaltılabilir** bir alan.

📌 `INV-T-002`'nin *"Status: HOLDS"* etiketi **dar tanıma göre doğru** — sözleşme cümlesi
*"submitted"* diyor. `C4` o cümleyi genişletiyor; yani invariant **metniyle birlikte**
güncellenmeli, yoksa guard yeşil kalır ve bypass açık kalır.

---

## C3 · net = brüt − indirim

**Şema** (`sales-actual.entity.ts`):

| kolon | tip | null |
|---|---|---|
| `gross_amount` | `decimal(18,·)` + `DecimalTransformer` | **NOT NULL** |
| `net_amount` | aynı | **nullable** |
| `discount_amount` | aynı | **nullable** |

**Bugünkü zorlama — kısıt değil, uyarı:**

```
sales-actuals-validation.service.ts:249
  // BRD'de tanımsız reconciliation kuralı -> yalnızca warning, satır kabul.
  if (gross !== null && net !== null && discount !== null &&
      Math.abs(net + discount - gross) > RECONCILIATION_TOLERANCE)   // = 0.01
    warnings.push({ code: 'AMOUNT_RECONCILIATION', … })
```

**Mevcut `CHECK` sayısı `sales_actuals` üzerinde: 0** (migration taraması).
Repoda `CHECK` yazma deseni **var** (`calculation_order`, `threshold_percent`) — yani
teknik engel yok.

> ### Cevap: `CHECK` **yazılabilir**, ama üç şartla — ve üçü de bugünkü koddan çıkıyor:
>
> 1. **NULL-toleranslı olmalı** (`net`/`discount` nullable): `net IS NULL OR discount IS NULL OR …`
> 2. **Tolerans taşımalı**: `abs(net + discount − gross) <= 0.01` — eşitlik `=` yazılırsa
>    bugünkü kabul edilen satırlar reddedilir
> 3. **Tolerans değeri bir karardır**: `0.01` bugün bir **koddaki sabit**
>    (`RECONCILIATION_TOLERANCE`), kaynakta *"BRD'de tanımsız"* diye işaretli

⚠️ **Verinin bugün bu kısıttan geçip geçmediği ÖLÇÜLMEDİ** (DB yok) — ve senin ayrımın
doğru: o migration sırasında görünür, `CHECK` düşerse veri düzeltme alt adımı devreye girer.

---

## F14 · Planın organizasyon bağlantısı

`plan.entity.ts` — **dört kolon, plan satırının üstünde denormalize**:

```
cpl_id       uuid  NOT NULL   → @ManyToOne(Cpl)
channel_id   uuid  NOT NULL   → @ManyToOne(Channel)
category_id  uuid  NOT NULL   → @ManyToOne(Category)
region_id    uuid  NULLABLE   → @ManyToOne(Region, { nullable: true })
tenant_id    uuid  NOT NULL
```

> Yani bağlantı bir ara tabloda değil, **planın kendi satırında**; ve **`region` tek
> nullable eksen**.

📌 İki bağlantı:
- `A7` kararı (*kapsam = kanal + müşteri + kategori, bölge Faz 2*) bugünkü şemayla
  **uyumlu**: üç zorunlu eksen tam olarak o üçü, bölge nullable duruyor.
- `0056-K5`'in (*"region eklensin mi"*) cevabı şema tarafında **zaten var** — kolon mevcut
  ama zorunlu değil. Soru artık *"eklensin mi"* değil, *"zorunlu olsun mu"*.

---

## F16 · Satış verisinde SKU kırılımı ve hacim

> ### **İkisi de YOK. Ve bu bir eksiklik değil, kayıtlı bir tasarım kararı.**

`sales-actual.entity.ts:7-11` — dosyanın kendi başlığı:

```
SalesActual — CPL x Kategori x Kanal x Dönem granülaritesinde gerçekleşen
satış TUTAR agregası (T-020). FU/SKU ve hacim boyutu YOKTUR — Wella actuals
CSV'sinde `fu_code`/`volume` kolonları bulunmuyor.
```

**Kolon envanteri:** `batch_id` · `fiscal_period` · `cpl_id`/`cpl_code` ·
`category_id`/`category_name` · `channel_id`/`channel_code` · **`gross_amount`** ·
`net_amount` · `discount_amount` · `currency` · `source_row_number`.
**`sku`/`quantity`/`volume`/`units` kolonu: 0.**

⚠️ Ve entity iki sınır daha yazıyor — ikisi de `B` dalgasını ilgilendirir:

1. **Ledger/bütçe sınırı:** `budgetEnvelopeId`/`ledgerEntryId`/`agreementId` kolonu **yok**;
   `discountAmount` **satış iskontosudur, asla bütçeye/ledger'a yazılmaz** — on-invoice
   zaten kendi akışında yazıyor, tekrar kullanılırsa **çift sayım** olur (T-003/T-017'nin kökü).

   ⚠️ **Düzeltme (2026-08-13):** bu teşhis `entity`'nin kendi yorumundan alınmıştı ve o
   yorum **doğrulanmadan** aktarılmıştı — çift sayım **iddiası** doğru, ama hangi alanın
   çift sayıldığı bir **varsayımdı**: entity `discountAmount`'ı *"satış iskontosu"*
   (`= (a)` yaklaşımı) diye adlandırıyordu, ölçüm bunu **sorguladı**. `C3` veri probe'u
   `net = brüt − discountAmount`'ın seed verisinin **3/3 satırında** tutmadığını (`is
   violated by some row`) gösterdi — yani `discountAmount` on-invoice ile aynı olayı
   temsil etmiyor **olabilir** `(b)`. Eğer `(b)` doğruysa, "kusur" sanılan şey bir **yanlış
   alarm** olurdu: çift sayım riski gerçek ama yanlış kolona bağlanmış olurdu.
   → [[T-209]] bu ayrımı ölçecek; `K-2.13.14h6` şimdilik `(a)`'yı reddedip on-invoice'u
   kaynak gösteriyor (ön karar, ölçüm şartlı).
2. **Satır seviyesinde unique kısıt YOK** — aynı scope'ta birden çok satır **meşru**.

📌 Bu, `ADR 0002`'nin (*"actuals = tutar agregası, hacim yok"*) kodda **doğrulanmış** hâli.
Hacim gerektiren her `B` maddesi (baseline, uplift, hacim varyansı) bu veriden
**beslenemez** — başka bir kaynak gerekir.

---

## Ö4 · Dönem alanları tutarlı biçimde mi

**Sekiz tabloda dönem kolonu var, hepsi `length: 7` (`YYYY-MM`), ama iki farklı ad:**

| ad | tablolar |
|---|---|
| **`fiscal_period`** (5) | `agreement_transactions` ⚠️ *nullable* · `on_invoice_batches` · `on_invoice_entries` · `sales_actual_batches` · `sales_actuals` |
| **`period_month`** (3) | `agreements` · `ledger_entries` · `plans` |

> ### Cevap: **biçim tek** (`varchar(7)`), **ad iki**, ve **biri nullable**.

**Tek jenerik backfill mümkün mü:** biçim açısından **evet** — hepsi aynı tip ve aynı
uzunluk, yani tek bir normalizasyon fonksiyonu (`YYYY-MM` doğrulaması/düzeltmesi) sekizine
de uygulanabilir. Ama:

- **Kolon adı parametre olmalı** — tek bir `UPDATE … SET fiscal_period` sekizini kapsamaz
- **`agreement_transactions.fiscal_period` nullable** → backfill'in `NULL` davranışı
  ayrıca kararlaştırılmalı (doldur mu, atla mı). Bu, `T-126`/`0060 §2`'nin dönem
  fallback'iyle **aynı alan**
- **Değerlerin bugün `YYYY-MM` olup olmadığı ÖLÇÜLMEDİ** (DB yok) — tip `varchar`,
  yani `2026-1` ya da `2026/01` **saklanabilir**; `0060 §2` bu şekillerin parser'da
  reddedildiğini ölçmüştü ama **DB'de ne yattığı** ayrı bir soru

---

## Bu turun sınırları (ZORUNLU)

- **Hiçbir sorgu veriye bakmadı.** `psql:5434 → refused`. Ölçülenler: entity tanımları,
  migration metinleri, servis kodu.
- **`C2` (iade) ve `F13` (KDV) hiç ele alınmadı** — ikisi de veri tarafında, ve senin
  ayrımına göre davranış işlerini blokluyor, migration'ı değil.
- `F16`'nın **hacim değerleri** sorusu anlamsızlaştı: kolon yok, dolayısıyla değer de yok.
  Ama *"hacim başka nereden gelebilir"* sorusu **sorulmadı**.
- `C1`'in üç kontrol noktası bulundu; **dördüncüsü olup olmadığı** (ör. agreement onayının
  başka bir yolu) tam enumerasyonla taranmadı — `approval.service` ve `plan.service`
  dışındaki onay yolları aranmadı.
- `C3`'ün `CHECK` önerisi **yazılmadı**, yalnız şartları çıkarıldı.
