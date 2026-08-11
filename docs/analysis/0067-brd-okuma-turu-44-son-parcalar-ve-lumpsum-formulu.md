# 0067 — BRD okuma turu **44**: `§5.2` · `§5.5` · `§3.5` · `§3.7/§3.8` (girer kovası kapandı)

- **Tarih:** 2026-08-11
- **Mod:** SALT-OKUNUR.
- **Kaynak:** `Section_05` §5.2 (233–490, **tamamı, ASCII dahil**) · §5.5 (1529–1644) ·
  `Section_03` §3.5 (879–967) · §3.7/§3.8 (1098–1138). `§7.6` ve `§1.6` `0059`'da okunmuştu.
- **Ölçüm ortamı:** meta `549bd63`. Submodule'ler checkout **edilmemiş**.
- **Durum:** `0059`'un **girer kovası bitti** — on bir parçanın hepsi okundu.

---

## 1. ⛔ EN BÜYÜK BULGU: `ADR 0006`'nın açık öncülü **yanlışmış**

`ADR 0006` (lumpsum dağıtımı, 2026-08-03) gerekçesini şöyle kuruyor:

> ### *"**BRD'de lumpsum dağıtımı için açık formül yok.** Eldeki iki dolaylı dayanak:
> `.cursor/rules.md:79` … `docs/analysis/0001` …"*

Ve **Karar 2**: *"Dağıtım tabanı: **base hacme göre orantılı**"*.

**Ölçüm (bugün, `Section_05 §5.2:360-363`):**

```
Display Fee (Lumpsum):
- Entered at FU level (e.g., 5,000 TL)
- Distributed to SKUs proportionally by PLANNED VOLUME
- Calculation: SKU_DisplayFee = FU_DisplayFee × (SKU_PlannedVol / FU_PlannedVol)
```

> ### Formül **var**, açık, adı konmuş ve tabanı **planned volume**.
> **`ADR 0006` `base volume` seçti.** İki taban farklı, ve karar *"BRD'de yok"* öncülüne
> dayanıyordu.

### Neden görülmedi — ve bu tam olarak §2.1.1'in vakası

| bölüm | ne diyor | okundu mu (o gün) |
|---|---|---|
| `§5.3:956-958` | *"(Lumpsums distributed from FU level to SKUs **proportionally**)"* + `SKU_LumpsumSpend = FU_Lumpsum * **SKU_Share**` | ✅ (`0031`) — ama **`SKU_Share`'in tabanını söylemiyor** |
| **`§5.2:362-363`** | **tabanı tanımlıyor: planned volume** | ❌ — `0047`'de ⚪ *"gerekçeyle atla"* |

> Yani *"formül yok"* iddiası, **formülün tabanını tanımlayan bölüm ⚪ işaretliyken**
> kuruldu. `§5.3` okunmuştu ve *"proportionally"* diyordu — ama taban orada yok.
>
> **`CLAUDE.md`: bir kavramın yokluğunu iddia etmeden önce, o kavramın HANGİ BÖLÜMDE
> tanımlanacağını sor.** Girdi deseni → `§5.2`; KPI kütüphanesi → `§5.3`.

### ⚠️ Ve `ADR 0006`'nın gerekçesi yeni formülle **uzlaşmıyor**

ADR'nin Karar 2 gerekçesi: *"`0001`'in **'null base'e pay yok'** ifadesiyle birebir tutarlı
tek okuma — taban base ise null base olan SKU doğal olarak pay alamaz."*

**Planned volume tabanında bu sonuç kaybolur:** yeni ürün SKU'su (`base = 0`, `planned > 0`)
**pay alır**. Ve `§5.6 Scenario 2` (yeni ürün lansmanı, `0059 §3`) tam olarak bu vakayı
ürünün desteklediği bir senaryo olarak anlatıyor.

> **Bu bir çelişki tespitidir, bir düzeltme önerisi değil** (`§2.1.2`: kaynak bir girdidir).
> İki taban iki farklı ürün davranışı verir ve **karar ürün sahibinindir** → [[T-194]] +
> `OPEN_DECISIONS → 0067-LUMPSUM`.

---

## 2. ⚠️ Ve `§5.2`'nin **kendi örneği kendi formülünü izlemiyor**

Aynı bölümün kolon örneğinde (`:296-316`) FU seviyesinde `Display Fee = 5.000 TL` ve
SKU satırlarında `[calc]` ile:

| SKU | Planned Vol | örnekteki Display | **formülün verdiği** (`5000 × vol/12000`) |
|---|---|---|---|
| SP Balance 500ml | 3.600 | **1.667** | **1.500** |
| SP Hydrate 500ml | 4.800 | **2.133** | **2.000** |

**İkisi de tutmuyor.** Örnek sayıların bir **ciro (GSV) tabanıyla** üretilmiş olması
mümkün: `95 TL` ve `89 TL` liste fiyatlarıyla oranlar 1.667/2.133'e **yaklaşıyor**, ama
üçüncü SKU'nun (`SP Silver Blond 250ml`) fiyatı belgede **yok**, yani doğrulanamıyor.

> **Kesin olan negatif iddia:** örnek, iki satır aşağıda yazılı olan **kendi formülünü
> izlemiyor**. Pozitif iddia (*"ciro tabanlı"*) bir **hipotez** — üçüncü fiyat olmadan
> ölçülemez.

📌 Yani kaynak lumpsum tabanı konusunda **üç sinyal** veriyor: `§5.3` *"proportionally"*
(tabansız) · `§5.2` metni **planned volume** · `§5.2` örneği **ikisi de değil**.
[[T-194]] bu üçünü birlikte taşımalı.

---

## 3. ✅ `§3.1 ↔ §5` çelişkisine **beşinci tanık** — ve aritmetikle

`§5.2`'nin hiyerarşi görselinde FU satırı `Base Vol: 10.000 | Planned: 12.000`, altındaki
üç SKU: `3.000 + 4.000 + 3.000 = 10.000` ✓ · `3.600 + 4.800 + 3.600 = 12.000` ✓.

> **FU hacmi bir girdi değil, SKU'ların toplamı** — `§5.2`'nin sözü (*"KPIs aggregated
> from SKU level"*) örnekte **aritmetik olarak** doğrulanıyor.

`OPEN_DECISIONS → §3.1 ↔ §5` satırı (`Section_03:112` *"FU → SKU volumes (optional
detail)"* ↔ `Section_05:169` *"Volume planning occurs at SKU level"*) için bu, `§5`
tarafına **ölçülmüş** bir tanık daha.

---

## 4. `§5.2` bir **UI sözleşmesi** veriyor (yeni BRD'ye aynen)

**Hücre semantiği (legend):** `[locked]` salt-okunur (baseline) · `[edit]` kullanıcı
girer · `[calc]` gerçek zamanlı hesap · **`[parent]` FU'dan miras**.

**Guardrail listesi — dördü yasak, üçü serbest:**

```
❌ özel hesaplanan kolon ekleyemez (Phase 1)   ✅ hacim/taktik/kullanıcı alanları girer
❌ hesaplanan KPI'ları override edemez         ✅ kolon sırası/genişliği değiştirir
❌ serbest formül yapıştıramaz (yalnız değer)  ✅ filtre · sırala · export
❌ zorunlu kolonları silemez
```

📌 *"Cannot override calculated KPIs (they are **read-only**)"* — bu, `[calc]` hücrelerinin
düzenlenemez olmasını **kaynak seviyesinde** şart koşuyor. `EditableCell` çalışmamızın
([[T-114]]/[[T-116]]) sözleşme tarafı; **kod bu turda ölçülmedi**.

---

## 5. `§5.5` — submit kapısı ve `auto_reject`

**Submit doğrulaması (dört şart):** en az bir FU'da planlanmış hacim · tüm zorunlu
taktikler tanımlı · **bütçe uygunluğu (Total Spend ≤ Available Budget)** · grid'de
doğrulama hatası yok.

**Politika şeması** `entity_type: PLAN` + `channel` + `amount_range` ile eşleşiyor;
seviyeler `role` + `when` koşulu taşıyor (`amount_gte`, **`gp_roi_pct_lt: 15` → Finance
zorunlu**), ve:

```json
"auto_reject_conditions": [
  { "gp_roi_pct_lt": 5, "message": "ROI too low (<5%), plan rejected" }
]
```

📌 `CLAUDE.md`'nin düzeltme tablosunda kayıtlı: *"auto-reject Phase 1'de geçersiz"* iddiası
**yanlıştı**, `§7.7` Phase 1'de geçerli diyor. Bu tur o kaydı **kaynağın kendi şemasıyla**
tamamlıyor: eşik **%5**, ve mekanizma politika JSON'unun bir alanı.

⚠️ **`gp_roi_pct_lt: 15` (Finance kapısı) ve `< 5` (auto-reject)** — `§5.2`'nin RAG
merdiveniyle (`≥20` yeşil · `10-20` amber · `<10` kırmızı) **aynı eksende ama farklı
noktalar**. Yani plan onayında **üç ayrı ROI eşiği** var: 20 (renk) · 15 (Finance) ·
5 (auto-reject). Yeni BRD'de tek tabloda toplanmalı.

---

## 6. `§3.5` — tactic policy JSON: sayısal kurallar

| alan | actuals | planning |
|---|---|---|
| `requires_justification` / `min_justification_length` | **true / 50 karakter** | — |
| `max_duration_days` | **30** | — |
| `allowed_mechanic_types` | `PERCENT`, `AMOUNT` | `PERCENT`, **`AMOUNT_PER_UNIT`** |
| `max_support_percent` / `max_discount_percent` | **40.0** | **40.0** |
| `min_uplift_percent` | — | **5.0** |
| `requires_baseline` / `requires_planned_volume` | — | true / true |
| `approval_policy_key` | `ACTUALS_STA_DEFAULT` | `PLANNING_DEFAULT` |

📌 İki bağlantı: [[T-148]] (*"tüm taktikler tüm kanallara açık"* geçici azaltması) bu şemayı
**hedef** olarak alabilir; ve `max_*_percent: 40` `T-137`'nin `max_combined_discount`
kuralıyla **aynı aile** — ikisinin ilişkisi bu turda **aranmadı**.

⚠️ `allowed_mechanic_types` mod bazında **farklı**: actuals `AMOUNT`, planning
`AMOUNT_PER_UNIT`. Yani aynı taktik iki modda **farklı mekanik türü** kabul ediyor.

---

## 7. `§3.8` — iki mimari cümle

- *"`POST /api/v1/ledger/entries` — **called by both** Agreement and Plan posting logic"*
  → tek yazma yolu, iki tüketici.
- *"Core tables (master data, budget, ledger) have **no mode-specific columns**"*
  → ⚠️ `§2.1.2`'nin `ledger_entries.source_type (AGREEMENT|PLAN)` ifadesiyle (`0063 §3`)
  **gerilim**: `source_type` moda özgü bir kolon değil mi? Uzlaştıran okuma: `source_type`
  bir **köken etiketi**, mod-koşullu bir alan değil (şema iki modda **aynı**). Kaydediliyor,
  çelişki ilan edilmiyor.

---

## 8. `0059`'un girer kovası — kapanış

| parça | tur |
|---|---|
| `Sprint_0_Mandatory_Items` | `0060` |
| `Section_08` §8.1 · §8.2–8.6 | `0061` · `0062` |
| `Section_02` §2.1–2.2 · §2.3–2.5 | `0063` · `0064` |
| `Section_06` §6.1/6.2/6.6 | `0065` |
| `Section_09` §9.1–9.4/9.6/9.7 | `0066` |
| **`§5.2` · `§5.5` · `§3.5` · `§3.7/3.8`** | **bu tur** |
| `§7.6` · `§1.6` | `0059` (okundu, tek tanıklı oldukları orada kaydedildi) |

**Tahmin 8–10 turdu; gerçekleşen 8 tur** (`0060`–`0067`).

---

## 9. Bu turun sınırları (ZORUNLU)

- **Kod hiç ölçülmedi.** §4'ün `EditableCell` bağlantısı, §1'in ürün etkisi: hiçbiri
  doğrulanmadı. [[T-194]]'ün ilk adımı **bizim bugünkü tabanımızı ölçmek** olmalı —
  `ADR 0006` Karar 1 uygulandı mı, uygulandıysa hangi tabanla.
- §2'nin *"ciro tabanlı"* hipotezi **doğrulanamadı** (üçüncü SKU fiyatı belgede yok).
- `§5.2`'nin `Input Patterns` pseudo-kodundaki uyarı eşikleri (`planned < base × 0.5` →
  uyarı, `CPP > %30` → uyarı) ürün tarafında **aranmadı**.
- `T-137`'nin `max_combined_discount`'u ile `§3.5`'in `max_*_percent: 40`'ı arasındaki
  ilişki **ölçülmedi**.
