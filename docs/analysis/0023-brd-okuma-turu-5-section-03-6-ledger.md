# 0023 — BRD okuma turu **5**: §3.6 Ledger & Spend Tracking + turu 3'ün düzeltmesi

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_03_Core_Components.md` §3.6 (969–1096, tamamı)
- **Ölçüm ortamı:** meta `bd6f45d` · backend `99ee9e6` · dev DB `main`, port 5434

---

## 1. ⛔ ÖNCE DÜZELTME — turu 3'ün "niyet ölçümü" iddiasının **üçte ikisi yanlıştı**

Turu 3 şunu yazmıştı:

> *"`claim` · `settlement` · `accrual` · `reconciliation` · `gross-to-net` **iki listede de
> yok** → yazarların gündeminde hiç olmamıştır."*

**§3.6 ilk satırında çürüdü:** `spend_type: ON_INVOICE | OFF_INVOICE | ADJUSTMENT | **ACCRUAL**`.

Tüm paket yeniden tarandı. Gerçek tablo:

| terim | durum | kanıt |
|---|---|---|
| `accrual` | ✅ **VAR — mekanizmada** | `ledger_entries.spend_type`'ın dört değerinden biri (§3.6). Ve LTA tanımı: *"Can accrue monthly but settled periodically"* (§4.2) |
| `settlement` | ✅ **VAR — kavram olarak** | STA/LTA'yı **ayırt eden özellik**: *"Settlement: Typically single period"* ↔ *"Multi-period accrual, batch settlements"* (§4.2). `Section_02`'de de |
| `reconciliation` | ✅ **VAR — ama BAŞKA anlamda** | *"Reconciliation reports (**ledger vs. ERP**)"* (§3.6) · *"no reconciliation **between modes**"* (§3.2). **Claim↔actual mutabakatı değil** |
| `claim` | ⚠️ yalnız **düz İngilizce** | *"invoices/claims"* (§4.1/4.3), *"does NOT claim"* — **kavram/entity olarak yok** |
| `gross-to-net` | ❌ **gerçekten yok** | iki yazımda da **sıfır** eşleşme |
| `recognition` | ❌ **gerçekten yok** | [[T-142]]'de tüm pakette ölçüldü |

### Hatanın sınıfı — ve bu **üçüncü** tekrarı

Turu 3, iddiayı **`Section_04`'ün iki kapsam listesinden** üretti. Ama:

- `accrual`'ın kanonik yeri **§3.6** (ledger şeması)
- `settlement`'ın kanonik yeri **§4.2** (agreement tipleri)
- `reconciliation`'ın kanonik yeri **§3.6** (fonksiyonel kapsam)

Bir mod bölümünün *"kapsam dışı"* listesi, **çekirdek bölümlerde tanımlı bir kavramı
saymaz** — çünkü o kavram zaten o modun konusu değil.

> **Bu, [[T-147]]'nin hatasının aynısı, üçüncü kez.** `TRANSFER` (§4.10 düzeltti) ·
> `ADJUST` (§3.3 düzeltti) · şimdi `accrual`/`settlement`/`reconciliation` (§3.6 düzeltti).
> Üçünde de **yanlış bölümden yokluk iddiası** üretildi.

### Ne AYAKTA kalıyor — ve daha keskin hâliyle

Düzeltilmiş iddia, orijinalinden **daha kullanışlı**:

> **BRD bu kavramların bir kısmını SÖZCÜK olarak taşıyor, hiçbirini MEKANİZMA olarak
> taşımıyor.**
>
> - `accrual` bir **etikettir** (`spend_type` değeri) — nasıl hesaplanacağı, ne zaman
>   yazılacağı, nasıl kapatılacağı **hiçbir yerde yok**
> - `settlement` bir **özelliktir** (LTA'nın ritmi) — settlement **tablosu**, **hesabı**,
>   **iş akışı** yok
> - `reconciliation` **ERP mutabakatı** anlamında var — claim↔actual mutabakatı yok
> - `claim`, `recognition`, `gross-to-net` **hiç yok**

Ve [[ADR 0010]]'un sonucu **değişmiyor**: RECOGNITION_SPEC'in dayanağı hâlâ yok. Değişen
şey gerekçesi — *"hiç düşünülmemiş"* değil, **"adı konmuş, mekanizması yazılmamış"**.

⚠️ İkincisi **daha da dikkat gerektirir**: `spend_type: ACCRUAL` bugün kodda **var**
(ölçüldü) ve onu **yazan hiçbir yol yok** — yani sekiz kez kaydettiğimiz *"mekanizma var,
yol yok"* sınıfının bir üyesi daha, ve bu sefer **BRD'nin kendi enum'unda**.

---

## 2. §3.6 ↔ kodumuz: ledger şeması

`ledger_entries` DB'den okundu (şema-nitelendirilmiş) ve BRD şemasıyla karşılaştırıldı.

### 2.1 ✅ Uyumlu çekirdek

`source_type` · `source_id` · `spend_type` (**dört değer de**) · `entry_direction`
(DEBIT/CREDIT) · `amount` · `currency` · `period_month` · `posting_date` · boyutlar
(`channel`, `cpl_id`, `fu_id`, `tactic_id`, `mechanic_id`) · `reverses_entry_id`

**`spend_type` dört değeri birebir** — `ADJUSTMENT` ve `ACCRUAL` dâhil.

### 2.2 🔴 Eksik: `CHECK (amount >= 0)`

BRD şeması: `amount NUMERIC(18,2) NOT NULL **CHECK (amount >= 0)**`
ve normatif cümle: *"amount: Transaction amount (**always positive**; sign indicated by
direction)."*

**Ölçüm:** `pg_constraint … contype='c'` on `main.ledger_entries` → **BOŞ. Hiç CHECK yok.**

> Negatif bir `amount`, `DEBIT` yönüyle birleştiğinde `INV-L-007`'nin
> `Σ DEBIT − Σ CREDIT` hesabını **sessizce** bozar. Ve `INV-L-*` ailesinin **dokuz
> invariantının hiçbiri** bu kısıtı içermiyor.

⚠️ ADR 0007 E7 zaten kaydetmişti: `ledger_entries` bugün **0 negatif** satır taşıyor, yön
`entry_direction`'da. Yani kural bugün **ihlal edilmiyor** — ama **korunmuyor da**.

### 2.3 🔴 Eksik: `status` kolonu

BRD: `status VARCHAR(20) NOT NULL DEFAULT 'POSTED'` — ve **örnek sorgusu onu filtreliyor**:

```sql
SELECT SUM(amount) FROM ledger_entries
WHERE … AND entry_direction = 'DEBIT' AND status = 'POSTED';
```

**Bizde `status` kolonu yok.** `INV-L-007` (*"consumed = Σ DEBIT − Σ CREDIT"*) status
filtresi **içermiyor** — çünkü filtrelenecek bir şey yok.

Bu, §4.3'ün *"staged (pending approval)"* durumuyla birlikte okunmalı: BRD ledger'da
**POSTED olmayan** bir durum öngörüyor. Bizde staging `on_invoice_entries`/batch tarafında.
**Model farkı mı, eksik mi — ölçülmedi.**

### 2.4 🟡 Eksik: `ledger_entry_reversals` tablosu

BRD **iki tablo** sayıyor: `ledger_entries` **ve** `ledger_entry_reversals`
(*"audit trail for reversals"*).

Bizde: `pg_tables … LIKE '%revers%'` → **boş**. Ters kayıt, satırın kendi
`reverses_entry_id` + `is_reversed` alanlarıyla izleniyor.

`INV-L-004`/`INV-L-005` bu tek-tablolu modelin üzerine yazılmış. **Ayrı bir denetim
gerektirir** — ama tur 4'ün dersi gereği: bu bir *"BRD'de yok"* iddiası değil, bir
**şekil farkı**, ve gerekçesi olabilir.

### 2.5 ⚠️ `deleted_at` — BRD'de **YOK**, bizde **var**: bu **D-04'e kanıt**

BRD'nin `ledger_entries` şemasında `deleted_at` **hiç yok**. Bizde var ve `INV-L-003`
*"hiçbir ledger satırı non-null `deleted_at` taşıyamaz"* diyor.

`SYSTEM_INVARIANTS §9` **D-04** tam bunu soruyordu:
> *"Append-only enforcement level: DB guarantee or application convention? If DB:
> `deleted_at` arguably should not exist on this table."*

**BRD tarafı cevaplı:** kolon şemada yok. Bir invariant'ın *"bu kolon hep null olmalı"*
demek zorunda kalması, kolonun **hiç olmaması gerektiğinin** işareti.

### 2.6 Diğer farklar (kayda geçer)

| BRD | bizde |
|---|---|
| `channel NOT NULL` · `cpl_id NOT NULL` | **ikisi de nullable** |
| `customer_id` · `sku_id` boyutları | **yok** |
| `account_code` (GL eşlemesi) · `reference_code` (fatura no) | **yok** — `idempotency_key` + `metadata` jsonb var |
| Idempotency: *"unique constraints on **source + period + spend_type**"* | tek `idempotency_key` string'i (`UNIQUE`, kısmi — [[T-095]]) |

⚠️ Sonuncusu ilginç: BRD **iki farklı** idempotency şekli tarif ediyor — §3.3/§4.8'de
`'<tx_type>\|<source_type>\|<source_id>\|<envelope_id>'` **string anahtarı**, §3.6'da
**bileşik unique kısıt**. **D-13 için ikisi de kaynak.**

### 2.7 📌 Normatif kapsam cümlesi

> *"Ledger is a financial traceability mechanism, **not an accounting system**. It tracks
> promotional spend attribution and audit trails, but does not replace GL accounting,
> accounts payable processing, or ERP financial modules."*

Bu, `INV-L-*` ailesinin **üst sınırını** çiziyor: ledger'dan muhasebe düzeyinde garanti
beklenmiyor. `account_code`'un *"Optional GL mapping"* olması da bunu destekliyor.

---

## 3. Çıktı 3 — danışman kuyruğu (bu turdan)

| Karar | Tür | Maliyet | Danışmana |
|---|---|---|---|
| `spend_type`'ın **ACCRUAL** değeri — tahakkuk ne zaman yazılır, nasıl kapanır | **domain** | **yüksek** — mekanizma hiç yok, ve LTA'ların çoğu tahakkuk gerektiriyor | ✅ |
| Ledger'ın *"muhasebe sistemi değil"* sınırı | domain | orta | 🟡 — sınır net yazılı, doğrulama yeterli |

---

## 4. Sonraki tur

1. **§3.4 Approval Engine** — %90 onay katmanı ([[T-144]]'ün açık ucu) ve `approval_policy_key`
2. §3.3'ün kalan blokları (606–781, *"Phase 1 Constraints"*) — [[T-150]]'nin ön koşulu
3. `02_Addendum` — beş HIGH PRIORITY
4. `Section_05` (2013) · `Section_02` (1026)
