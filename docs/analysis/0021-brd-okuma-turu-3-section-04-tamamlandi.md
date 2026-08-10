# 0021 — BRD okuma turu **3**: Section 04 tamamlandı (4.6 · 4.7 · 4.10) + ekran ekseni

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_04_Actuals_First_Mode.md`
- **Ölçüm ortamı:** meta `548f796` · backend `99ee9e6` · dev DB `main`, port 5434

---

## 0. Okundu / okunmadı

✅ **`Section_04` ARTIK TAM OKUNDU** — 2038/2038 satır (tur 2: %70 · tur 3: kalan 4.6 Price
Simulation, 4.7 Tactic & Mechanic Execution, 4.10 Phase kapsam listeleri).

⛔ Okunmayan: `Section_01/02/03/05…11` · `02_Addendum` · `03_Candidate_Log` gövdesi.

---

## 1. ⛔ **Çıktı 1'in niyet ayrımı CEVAPLANDI** — ve iki liste birden var

Görev sormuştu: *bir yetenek yoksa, faz dışı mı bırakılmış (açıkça yazılı) yoksa hiç
düşünülmemiş mi?*

`Section_04` **iki ayrı ve açık liste** taşıyor:

**(a) "Explicitly NOT in Phase 1 (Deferred)"** — yapılacak ama sonra:
agreement templates/cloning/amendments · invoice sistemi entegrasyonu · ERP sync ·
carry-forward · multi-dimensional budgets · custom report builder · parallel/delegated
approvals · multi-SKU price simulation

**(b) "Explicitly Out of Scope for Actuals-First (Phase 1)" — *conceptually incompatible*,
yani tasarım gereği asla:**

```
❌ Baseline calculation          — "baseline is unknown or irrelevant"
❌ Planned volume forecasting    — "agreements set terms, actual sales determine spend"
❌ ROI simulation                — "requires baseline + planned volume + cost data"
❌ Optimization / recommendations
❌ Cross-period uplift attribution
```

### Ve asıl bulgu: aradığımız beş terim **hiçbir listede yok**

| terim | (a) ertelenmiş | (b) tasarım gereği dışarıda | sonuç |
|---|---|---|---|
| `claim` | ❌ | ❌ | **hiç düşünülmemiş** |
| `settlement` (kavram olarak) | ❌ | ❌ | **hiç düşünülmemiş** |
| `accrual` | ❌ | ❌ | **hiç düşünülmemiş** |
| `reconciliation` | ❌ | ❌ | **hiç düşünülmemiş** |
| `gross-to-net` | ❌ | ❌ | **hiç düşünülmemiş** |

> **Bu artık bir sessizlik ölçümü değil, bir NİYET ölçümüdür.** BRD hem *"ertelendi"* hem
> *"tasarım gereği dışarıda"* için **açık listeler tutuyor**. Bir kavram ikisinde de yoksa,
> yazarların gündeminde **hiç olmamıştır**.

⚠️ Kapsam sınırı: bu, `Section_04` (actuals-first) için geçerlidir. `Section_05` ve
`Section_03` okunmadı.

Ve [[ADR 0010]]'un sonucunu güçlendiriyor: RECOGNITION_SPEC bir **yorum** değil, **yeni bir
ürün kararı** — kaynak onu ertelemedi bile, hiç düşünmedi.

---

## 2. 🔴 `tactic_policies` tablosu **YOK** — ve tur 1'in en pahalı danışman sorusu buna bağlıydı

`Section_04 §4.7` mekanizmayı **tam olarak** tanımlıyor:

```json
{ "tactic_id": "...", "mode": "ACTUALS",
  "allowed_mechanics": ["OFF_INVOICE_REBATE", "PERCENT_DISCOUNT_ON_INVOICE"],
  "validation_rules": { "requires_fu": true, "requires_justification": true,
                        "max_duration_days": 30, "approval_threshold": 10000 },
  "budget_policy": { "requires_budget_check": true, "reserve_on_approval": true } }
```

ve `validateAgreement`'ın onu **yüklediğini** yazıyor (`getTacticPolicy(tactic_id, 'ACTUALS')`).

**Ölçüm** (şema-nitelendirilmiş):

```sql
SELECT tablename FROM pg_tables WHERE schemaname='main' AND tablename LIKE '%polic%';
-- → BOŞ
```

**Böyle bir tablo yok.** Yani:

| BRD'nin politikaya koyduğu | bizde |
|---|---|
| `mode: ACTUALS \| PLANNING` | **modül dizini** (`modes/actuals-first/`, `modes/planning-first/`) — koda gömülü |
| `allowed_mechanics` | ölçülmedi |
| `max_duration_days: 30` | **konfigüre edilebilir olmalıydı**; §4.2 sabit 30 diyor |
| `approval_threshold: 10000` | ölçülmedi |

> ### Bu, mod ayrımının üç ölçümünü **birleştiriyor**
>
> Tur 1 ve 2'de mod çözümü için **iki farklı liste** bulmuş ve BRD-içi tutarsızlık diye
> kaydetmiştim. **Tutarsızlık değilmiş** — §4.7 mekanizmayı veriyor ve üçünü uzlaştırıyor:
>
> | kaynak | ne sayıyor |
> |---|---|
> | Glossary | tactic eligibility · baseline availability · channel maturity · user workflow |
> | §4.1 | tactic eligibility · scope policy configuration · user permissions |
> | **§4.7** | **`tactic_policies.mode`** ← **mekanizma** |
>
> Ortak öge **tactic eligibility**'dir ve mekanizması `tactic_policies`. Diğerleri
> *bağlamsal faktörler*. **Tur 2'nin "BRD-içi tutarsızlık" bulgusu geri çekiliyor.**

⚠️ Ve tur 1'in danışman kuyruğundaki 1 numaralı soru (*"mod kullanıcı seçimi değil, bağlamla
çözülüyor"* — çok yüksek maliyet) artık farklı: soru **"bu doğru mu"** değil,
**"bu tablo neden yok"**.

---

## 3. Dört mekaniğin doğrulama kuralları — ve `> 0` deseninin yedinci geçişi

`§4.7` dört çekirdek mekaniği ve **her birinin doğrulama kuralını** veriyor:

| Mekanik | Hesap | Doğrulama |
|---|---|---|
| Off-Invoice Rebate (birim başı) | `Units × Rebate/unit` | `> 0`; SKU baz fiyatının %50'sini aşarsa **uyarı** |
| % Discount (on-invoice) | `GSV × %` | **0–100**; **>30 ise uyarı** |
| Fixed Lumpsum | sabit | `> 0`; ödeme takvimi **zorunlu** |
| Turnover Rebate | `Turnover × %` | `> 0`; hedef vs gerçekleşen |

**Üç sonuç:**

1. **`> 0` deseni yedinci kez** ([[ADR 0009]] artık fazlasıyla desteklenmiş durumda).
2. **On-invoice yüzde için BRD'nin sayısı 30'dur** (uyarı eşiği). Kodumuzdaki
   `MAX_ON_INVOICE_DISCOUNT = 50` hâlâ **dayanaksız** ([[T-138]]) — ve 30, üçüncü kez ve
   üçüncü farklı bağlamda karşımıza çıkıyor.
3. **`max_duration_days` ve `approval_threshold` politika alanı** — yani `Section_04 §4.2`'nin
   *"STA ≤30 gün"* kuralı **sabit değil, konfigüre edilebilir**. [[T-146]]'nın ilgili maddesi
   düzeltilmeli.

**Mechanic-Specific Data Capture** tablosu dört alan daha istiyor — bizde ölçülmedi:
`estimated_volume` · `expected_gsv` · `target_turnover` · `payment_schedule` / `payment_frequency`.

---

## 4. 🆕 Çıktı 5 — **Ekran ekseni** (ürün sahibi eklemesi)

Katman A *"BRD kuralı ↔ kod davranışı"* ölçüyor. Ekran farkı **davranış değil arayüz**: bir
ekran BRD'nin dediğini yapıp tamamen farklı görünebilir.

**Kapsam dışı:** yerleşim, renk, bileşen tipi, görsel dil. (BRD taslakları ASCII; ürün
Tailwind/shadcn — fark **tasarım kararıdır**.)

**Kapsam içi, alan bazında:**

| Soru | Anlamı |
|---|---|
| BRD taslağındaki her **alan** ekranda var mı? | Yoksa → **yetenek erişilemez** |
| Ekranda BRD'de olmayan alan var mı? | Varsa → gerekçesi ne |
| Alanların **davranışı** aynı mı? | zorunluluk · doğrulama · varsayılan |

### 4.1 Üç kova — ve üçüncüsü ekran görüntüsü **gerektirmiyor**

`Section_04`'ün **7 ekran taslağı** için ilk envanter (dosya varlığı; alan bazında
karşılaştırma ekran görüntüsü fazına):

| # | BRD taslağı | Frontend | Kova |
|---|---|---|---|
| 1 | Agreement form (4 adım) | `STAAgreementForm` · `LTAAgreementForm` · `AgreementForm` · `AgreementEditPage` | ① ekran **var** → alan bazında karşılaştırılacak |
| 2 | Validation Results (batch) | `OffInvoiceUploadPage` · `OnInvoiceUploadPage` | ① |
| 3 | **Batch Approval Request** | **YOK** — `batch`+`approv` eşleşen dosya **sıfır** | ③ **yapılmamış** |
| 4 | Budget Alert | `Alert` eşleşen 7 dosya (hangisi olduğu doğrulanmadı) | ①? |
| 5 | Actuals-First KPI Dashboard | 2 dashboard dosyası | ①? |
| 6 | **Price Simulation Widget** | **YOK** — `priceSimulation\|expectedPrice\|competitorPrice` → **sıfır** | ③ **yapılmamış** |
| 7 | Agreement lifecycle (state machine) | — (diyagram, ekran değil) | — |

### 4.2 ⚠️ Price Simulation — **şema var, ekran yok**

```
main.agreements kolonları:  current_price · expected_price · competitor_price · competitor_name
                            → DÖRDÜ DE VAR (DB'den doğrulandı)
agreement.entity.ts         → bildiriyor
frontend                    → SIFIR dosya
```

BRD `§4.6` bu yeteneği **tam olarak** tanımlıyor (formül, ters hesap, doğrulama kuralları,
uyarı eşikleri, veri kaynağı önceliği, onay ekranında kullanımı) ve şema **inmiş**.
**Kullanıcının gireceği bir yer yok.**

> Bu, bu oturumun dokuz kez kaydettiği *"mekanizma var, ona giden yol yok"* sınıfının
> **arayüz tarafındaki** hâli — ve tam olarak ürün sahibinin öngördüğü kova.
> Kardeşi: `max_combined_discount_percentage` (API'den yazılabiliyor, UI alanı yok,
> [[T-137]]).

⚠️ Ve BRD `skus.base_price` diyor; bizim `skus` tablosunda `unit_price` var, `base_price`
**yok** (`forecasting_units.base_price` var — **başka tablo**). Price simulation'ın veri
kaynağı bu yüzden de belirsiz. [[T-133]]'ün kamuflajıyla **aynı sınıf**: alan var ama
başka tabloda.

### 4.3 Üçüncü kova bugünkü hâliyle

**BRD'nin çizdiği ama yapılmamış ekranlar (Section_04):**

1. **Batch Approval Request** — batch onayı BRD'de bir Finance kapısı ve D-01'in override
   mekanizması. Ekranı yok.
2. **Price Simulation Widget** — şeması var, ekranı yok.

**İkisi de yalnız "eksik ekran" değil:** birincisi bir **onay kapısı**, ikincisi bir
**karar destek aracı**. Yani ürün boşluğu görsel değil, **işlevsel**.

---

## 5. Küçük düzeltmeler (bu tur kendi önceki turunu düzeltiyor)

| Düzeltilen | Neydi | Ne oldu |
|---|---|---|
| Tur 2 §5 | *"BRD-içi tutarsızlık: mod çözümü iki farklı liste"* | **geri çekildi** — §4.7 mekanizmayı veriyor, listeler bağlamsal faktör |
| [[T-147]] | *"`TRANSFER` BRD'de hiç geçmiyor"* | **kısmen yanlış** — `§4.10`: *"❌ Reallocation workflows (**Finance manually creates TRANSFER**)"*. Yani `TRANSFER` **Phase 1'de manuel bir mekanizma**. `ADJUST` hâlâ bulunamadı |
| [[T-146]] | *"STA ≤30 gün kapısı"* | 30 **sabit değil**, `tactic_policies.validation_rules.max_duration_days` |

⚠️ **Ve bir belirsizlik, çözmüyorum:** `§4.10`'un ertelenenler listesinde
*"❌ Overrun approval (hard block at 100%)"* var. İki okunuşu mümkün — (a) *"overrun onay
akışı ertelendi; Phase 1'de %100'de sert blok var"* ya da (b) *"sert blok da ertelendi"*.
`§4.8` *"Block (100%): System prevents new agreement submissions"* dediği için (a) tutarlı
görünüyor, ama **ölçmedim.** [[T-144]]'e not düşüldü.

---

## 6. Sonraki tur

1. **`Section_03_Core_Components`** (1138) — `§4.8` oraya çapraz atıf veriyor; [[T-144]]'ün
   eşik konfigürasyonu ve `tactic_policies` oraya bağlı olabilir
2. `02_Addendum` (1153) — beş HIGH PRIORITY
3. `Section_05_Planning_First_Mode` (2013)
4. `Section_10/11` — niyet ayrımının **planning-first** tarafı
