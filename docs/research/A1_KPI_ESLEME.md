# `A1` — KPI EŞLEMESİ: **`52` KANON KALEM × CANLI ÜRÜN**

> **iş:** `W2` `DALGA-A` / `A1` · **hüküm:** `docs/brd-v2/04_KARAR_KAYDI.md` **`Z65`** (beş hüküm)
> **yazan:** `data-analyst` · **tarih:** 2026-08-30 · **statü:** salt-okunur ölçüm
> **girdiler:** `docs/research/KPI_EVRENI_52_GRUP_AGACI.md` (`A4`) ·
> `docs/research/A0_KAVRAM_ESLEME_RAPORU.md` (`A0'`) ·
> `docs/research/DEMO_EXCEL_KPI_TACTIC_REFERANSI.md` `§1`/`§3`
> **işaretleme:** `[ÖLÇÜLDÜ]` bugün canlı · `[GEREKÇELİ]` türetildi · `ÖLÇEMEDİM`
>
> ⛔ **Bu tur:** hiçbir `src/` dosyası yazılmadı · migration yazılmadı · test/e2e koşulmadı ·
> `.claude/backlog/tasks/T-334.md`'ye **dokunulmadı** (öneri `§4`'te, Team Lead işler).

---

## `§0` · OKUMA KURALLARI — ve **KÖK-NEDEN ÇERÇEVESİ**

### `0.1` · Çerçeve (`Z65 §0`)
```
Section_05 DERLEME-KAYBI → NIV grubu listeden DÜŞTÜ → NIV İHTİYACI KODDA DOĞDU
→ listede karşılığı yoktu → TO'NUN ÜSTÜNE YAMANDI (1781)
⇒ 1781 KÖTÜ BİR TUR DEĞİLDİ — EKSİK-EVRENLE ÇALIŞAN BİR TURDU
```
Bu tablo **suç dağıtmaz**. Aşağıdaki `eşleşen-sapmalı` kalemlerin çoğu **tek bir
eksik-evrenin türevidir** — ve `T-334` o türevi **tek turda** kapatır (`§4`).

### `0.2` · KANON NEDİR
> **Eşleme *"olması gereken"i* yazar — bugünkü kodu değil.**

```
KANON  =  Z65'in beş hükmü            (Q1–Q5)
       +  Excel formül sözlüğü         (§1 — FORMÜL-KANIT KAYNAĞI)
       +  BRD-A1 52 kalem listesi      (EVREN — Z65 §4 F12: evren Excel'den DEĞİL)
```
⛔ **`1781` sonrası canlı formül KANON DEĞİLDİR.** `Q2`/`Q3`/`Q5` kapsamındaki kalemler
bugünkü hâliyle **`eşleşen-sapmalı`** kovasındadır; her satırda **`T-334` sonrası ne
olacağı** yazılıdır.

### `0.3` · KOVALAR
| kova | tanım |
|---|---|
| `eşleşen-doğru` | kalem canlıda üretiliyor **ve** kanon formülle **anlamca aynı** |
| `eşleşen-sapmalı` | kalem üretiliyor ama **formülü / tabanı / adı / seviyesi** kanondan sapıyor ⇒ **kaydedilir, sessizce hizalanmaz** |
| `YOK` | kanonik sayı **hiçbir yüzeyde** üretilmiyor ⇒ `Z62 §0` süzgeciyle yerleşir |

### `0.4` · AYRI SÜTUNLAR — kova ile **karıştırılmaz**
| sütun | ne söyler | neden ayrı |
|---|---|---|
| **`BİÇİM`** | sayı **nerede** yaşıyor: `kpis-satırı` · `context-girdisi` · `kod` · `FE-hardcode` · `yok` | *"formüller veridir, kod değildir"* ihlali bir **biçim** kusurudur, formül kusuru değil |
| **`AGG`** | agregasyon davranışı (Excel `§3`) | *"kalem var ama **yanlış seviyede** toplanıyor"* ⇒ **`eşleşen-sapmalı`** |
| **`ETİKET`** | `kaynağı-belirsiz-girdi` (`Z62 §6-2`) · `[KAYNAKTA YOK]` (`Z65 §4`) · `Excl. BMI` (`§6-4`) | **kova değil ETİKET** — kalem yine bir kovaya girer |

⛔ **`kaynağı-belirsiz-girdi` etiketli kalemde sell-in hacmi SESSİZ VEKİL SAYILMAZ**
(`Z62 §6-2`). Bu yüzden `PRICE_SUPPORT_SPEND` ve `PLANNED_COGS` *"eşleşti"* **yazılmadı**.

---

## `§1` · EŞLEME TABLOSU — 52 kalem

> `kanon formül` sütunu Excel `§1`'dendir (`Z65 §4`: Excel = **formül-kanıt kaynağı**).
> `canlı` sütunu `main.kpis` satırı **ya da** onu üreten kod noktasıdır.
> `AGG` sütunu: `S`=SUM · `F`=Formula (yeniden hesaplanır) · `NR`=Not required · `—`=kaynakta yok.

### GRUP 1 · Master Data (2)

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG kanon → canlı | verdict |
|---|---|---|---|---|---|---|
| 1 | List Price / piece (`BPTT`) | Master Data (piece) | `BPTT` ← `sku.unitPrice` (`plan.service.ts:2437`) | ⚠️ **context-girdisi** — `kpis` satırı **YOK** `[ÖLÇÜLDÜ]` | — → — | **eşleşen-doğru** ⚠️`BİÇİM-SAPMASI` |
| 2 | COGS / piece | Master Data (piece) | `COGS` ← `sku.cogs` (`:2438`) | ⚠️ **context-girdisi** | — → — | **eşleşen-doğru** ⚠️`BİÇİM-SAPMASI` |

📌 İkisi de `null`-korumalı (`unitPriceOrNull`/`cogsOrNull`, `T-027`) ⇒ **`§2.5` uyumlu**,
sessiz `0` yok. **Olumlu kayıt.**

### GRUP 2 · Volume (4)

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 3 | Base Volume | `Baseline` (Master Data, piece) | `BASE_VOL` `user_input` | kpis-satırı | S → S | **eşleşen-doğru** |
| 4 | Planned Volume | `TotalVolUOM × UOMConversionFactor` | `PLAN_VOL` `user_input` (**piece doğrudan**) | kpis-satırı | S → S | ⚠️ **eşleşen-sapmalı** |
| 5 | iVol | `PlannedTotalVolume − Baseline` | `INCR_VOL` = `PLAN_VOL - BASE_VOL` | kpis-satırı | S → S | **eşleşen-doğru** |
| 6 | Volume Uplift % | `(iVol / Baseline) × 100` | `UPLIFT_PCT` = `(PLAN_VOL - BASE_VOL)/BASE_VOL*100` | kpis-satırı | F → **F** ✅ | **eşleşen-doğru** |

⚠️ **`4`'ün sapması:** `sku.conversionFactor` **entity'de tanımlı** (`sku.entity.ts:82`)
ve **tüketicisi SIFIR** — `rg -i conversionFactor src` yalnız entity + `sales-actual`
+ bir DTO yorumu döndürdü `[ÖLÇÜLDÜ]`. ⇒ UOM çevrimi **planlama yolunda yok**;
planlayıcı adet girmek zorunda. `§5 Q9`.

📌 **`6`'nın `AGG`'si bir OLUMLU ölçümdür ve bir yanlış-alarmı önledi:**
`aggregation_method_fu = weighted_avg` **adı yanıltıcıdır** — çalışma zamanında
`kpi-engine.service.ts:126-143` bu satırları `recomputeRatioFromChildren` ile
**çocuklardan yeniden hesaplar** (`T-177`), yani Excel `§3`'ün *"Formula — toplanamaz,
yeniden hesaplanır"* kuralı **birebir uygulanıyor**. ⇒ `UPLIFT_PCT`, `GP_ROI_PCT`,
`GP_MARGIN_PCT` **agregasyon ekseninde SAPMALI DEĞİL.** `[ÖLÇÜLDÜ]`
*(`DISIPLIN`: enum adı `weighted_avg`, davranış `recompute` — bir **ad-borcu**, ama
**davranış doğru**; `§5 Q12`'de kayıtlı, `T-334` kapsamında değil.)*

### GRUP 3 · GSV (3)

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 7 | Base GSV | `BPTT × Baseline` | `BASE_GSV` = `BASE_VOL * BPTT` | kpis-satırı | S → S | **eşleşen-doğru** |
| 8 | Planned GSV | `BPTT × PlannedTotalVolume` | `PLANNED_GSV` = `PLAN_VOL * BPTT` | kpis-satırı | S → S | **eşleşen-doğru** |
| 9 | iGSV | `PlannedPromoGSV − BaseGSV` | **satır yok**; `PlanningGridEnhanced.tsx:100-105` | ⚠️ **FE-hardcode** | S → — | **YOK** |

### GRUP 4 · NIV (3) — ⭐ `Z65 §1`: **kendi kodlarıyla DOĞAR**

| # | kanon kalem (`Z65` kodu) | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 10 | Base NIV (`BASE_NIV`) | `BaseGSV × (1 − LTAOnPct)` | **`BASE_TO`** = `BASE_GSV - BASE_LTA_ON` | kpis-satırı ⚠️ **YANLIŞ AD** | S → S | ⚠️ **eşleşen-sapmalı** `AD-BORCU-1` |
| 11 | Planned NIV (`PLANNED_NIV`) | `PlannedGSV − PlannedTotalSpendOn` | **`PLANNED_TO`** = `PLANNED_GSV - PLANNED_ON_INVOICE_SPEND` | kpis-satırı ⚠️ **YANLIŞ AD** | S → S | ⚠️ **eşleşen-sapmalı** `AD-BORCU-2` |
| 12 | iNIV (`INCR_NIV`) | `PlannedNIV − BaseNIV` | **satır yok**; `spend-calc:1113` (**ölü yol**) · `Grid:207-215` | ⚠️ **FE-hardcode + ölü kod** | S → — | **YOK** |

⛔ **`10`/`11`'in FORMÜLÜ DOĞRU, ADI YANLIŞ.** `T-334` sonrası: formül metni
**değişmez**, yeni koda (`BASE_NIV`/`PLANNED_NIV`) **taşınır**.

### GRUP 5 · Turnover (4) — ⭐ `Z65 §1`: **anlamını GERİ ALIR**

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 13 | Base TO | `BaseGSV − BaseTradeSpend` (`LTAOn+LTAOff`) | `BASE_TO` bugün **NIV** hesaplıyor (`1781`) | kpis-satırı ⚠️ **YANLIŞ FORMÜL** | S → S | ⚠️ **eşleşen-sapmalı** |
| 14 | Planned TO | `PlannedGSV − PlannedTotalSpend` (**on+off**) | `PLANNED_TO` bugün **NIV** hesaplıyor (`1781`) | kpis-satırı ⚠️ **YANLIŞ FORMÜL** | S → S | ⚠️ **eşleşen-sapmalı** |
| 15 | iTO | `PlannedTO − BaseTO` | **satır yok**; `spend-calc:1126` `= iNIV` (**ölü yol**) · `Grid:234-248` | ⚠️ **FE-hardcode + ölü kod** | S → — | **YOK** |
| 16 | TO Uplift % | `(iTO / BaseTO) × 100` | **satır yok**; `Grid:249-262` | ⚠️ **FE-hardcode** | F → — | **YOK** |

⛔ **`13`/`14`'ün malzemesi CANLIDA HAZIR:** `BASE_TOTAL_SPEND` (`order 10`) ve
`TOTAL_PLANNED_SPEND` (`order 9`) **zaten var ve aktif** — ikisi de `BASE_TO`(`25`) /
`PLANNED_TO`(`26`)'dan **önce** hesaplanıyor. ⇒ `T-334`'ün `Q2` düzeltmesi
**yeni bağımlılık gerektirmiyor**, yalnız `formula_text` + `depends_on_kpis`. `[ÖLÇÜLDÜ]`

### GRUP 6 · LTA Spend (8)

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 17 | LTA On-Invoice % | Master Data **veya** LTA-promoları | `LTAContext.finalOnInvoicePct` (`spend-calc:506`) | ⚠️ **yalnız kod** — satır yok, context'e de girmiyor · FE kolonu `// TODO` **`null` döndürüyor** (`Grid:110-112`) | NR → — | **YOK** |
| 18 | LTA Off-Invoice % | Master Data **veya** LTA-promoları | `LTAContext.finalOffInvoicePct` (`:507`) | ⚠️ aynı (`Grid:113-115`) | NR → — | **YOK** |
| 19 | Base LTA Spend On | `LTAOnPct × BaseGSV` | `BASE_LTA_ON` ← `baseLtaOnInv` (`spend-calc:509`) | kpis-satırı ⚠️ **`FORMÜL-KODDA`** | S → S | **eşleşen-doğru** |
| 20 | Base LTA Spend Off | `LTAOffPct × BaseNIV` | `BASE_LTA_OFF` ← `(baseGsv − baseLtaOn) × pct/100` (`:510`) | kpis-satırı ⚠️ `FORMÜL-KODDA` | S → S | **eşleşen-doğru** |
| 21 | Planned LTA Spend On | `LTAOnPct × PlannedGSV / 100` | `PLANNED_LTA_ON` ← `:512` | kpis-satırı ⚠️ `FORMÜL-KODDA` | S → S | **eşleşen-doğru** |
| 22 | Planned LTA Spend Off | `LTAOffPct × **PlannedPromoNIV** / 100` | `PLANNED_LTA_OFF` ← `(plannedGsv − plannedLtaOn) × pct/100` (`:513-514`) — **promo-on düşülmemiş** | kpis-satırı ⚠️ `FORMÜL-KODDA` | S → S | ⚠️ **eşleşen-sapmalı** |
| 23 | Total Base Spend (`BaseTradeSpend`) | `BaseLTASpendOn + BaseLTASpendOff` | `BASE_TOTAL_SPEND` ← `base.totalSpend` (`:642`) | kpis-satırı ⚠️ `FORMÜL-KODDA` | S → S | **eşleşen-doğru** |
| 24 | Total Planned LTA Spend | ⚠️ **Excel'de YOK** — yalnız BRD `KPI 17`: `PLANNED_LTA_ON + PLANNED_LTA_OFF` | **satır yok** | yok | S → — | **YOK** |

⛔ **`22` YENİ BİR SAPMA ve YÖNÜ TERS** — `Z65 §6` desenine **ilk karşı-örnek**:
```
Excel   LTA_Off tabanı = PlannedNIV  = GSV − LTA_On − Σpromo_on
kod     LTA_Off tabanı =              GSV − LTA_On
⇒ taban BÜYÜK ⇒ LTA_Off harcaması BÜYÜK ⇒ toplam spend BÜYÜK ⇒ ROI KÖTÜMSER
```
📌 `Z65 §6`'nın üç vakası **ROI-iyimser**di; bu **ROI-kötümser**. ⇒ *"sistematik
iyimserlik basıncı"* teşhisi **tek yönlü değil** — ama üç-bir oranı deseni bozmuyor.
**Ölçemediğim:** sapmaların **büyüklüğü** (`plans = 0`) ⇒ hangisinin baskın olduğu
bilinmiyor. `§5 Q8`.

📌 **`FORMÜL-KODDA` sınıfı (`19`–`23`, beş kalem):** `formula_text` alanı kendi kodunu
tekrar ediyor (`'BASE_LTA_ON'`), gerçek formül `spend-calculation.service.ts`'te.
⇒ **`§2.3` *"hesaplamalar asla hardcode edilmez"* ihlali — ama BRD'nin KENDİ tasarımı**
(`Section_05 §5.3`: `formula_type='external'`). ⛔ Bir **kusur değil, bir tasarım
sınırı** olarak kaydedilir; `T-334` kapsamında **değil**.

### GRUP 7 · Promo Spend by Mechanic (11) — ⛔ **8'i `[KAYNAKTA YOK]`**

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 25 | CPP On-invoice% Spend | `(GSV − LTA_On) × CPPOnPct / 100` | `CPP_ON_SPEND` kpis-satırı **VE** `calculateOnInvoiceDiscount` (`:252-261`) | ⚠️ **İKİ İMPLEMENTASYON** | S → S | **eşleşen-doğru** |
| 26 | CPP Off-invoice% Spend | `PlannedNIV × CPPOffPct / 100` | `calculateOffInvoiceDiscount` (`:266-283`) — taban `GSV − LTA_On − **LTA_Off** − Σpromo_on` | ⚠️ satır yok, **kod** | S → S | ⚠️ **eşleşen-sapmalı** (`Q5`) |
| 27 | Price Support per Unit | `PriceSupportperPiece × **EffectiveTotalIMSVolumePC**` | `calculatePerUnitSupport` (`:288-295`) = `enteredValue × plannedVolume` (**sell-in**) | ⚠️ satır yok, **kod** | S → S | ⚠️ **eşleşen-sapmalı** ETİKET **`kaynağı-belirsiz-girdi`** |
| 28–35 | **8 kalem** | `[KAYNAKTA YOK]` | ⚠️ **kova ATANAMAZ** | — | — | ⛔ **`[KAYNAKTA YOK]`** |

⛔ **`27` için *"eşleşti"* YAZILAMAZ** (`Z62 §6-2`, sessiz-vekil yasağı): sell-in hacmi
sell-out'un yerine **geçici olarak bile** sayılmaz. Kanon girdisi (`EffectiveTotalIMSVolumePC`)
**tanımsız** olduğu sürece bu kalem `eşleşen-sapmalı` **kalır**.

⛔ **`28–35` (8 kalem) hiçbir kovaya YERLEŞTİRİLMEDİ** — `Z65 §4`: evrenden **atılmaz**,
`[KAYNAKTA YOK]` etiketiyle **taşınır**, ve **`Faz-2-ŞART` OLAMAZ**.
```
koşul satırı   sağlayıcı    ürün sahibi — "KPI-Library/A1" kaynak metninin 21-28 satırları
               tetikleyici  A4 §2 GRUP 7'nin adlandırılması
               o güne kadar Faz-3/ELENİR kutusunda BEKLER
```
📌 Canlı `main.mechanics` **6 satır** (`CPP_ON_PCT · CPP_OFF_PCT · PRICE_SUP ·
DISPLAY_FEE · VIS_LS · MEC-DISCOUNT`) `[ÖLÇÜLDÜ]` — yani lumpsum/visibility harcamaları
**hesaplanıyor** ama karşılık geldikleri kanon kalemlerin **adı yok**. Bu, `28-35`'in
*"boş bir yer tutucu"* değil, **adı kayıp gerçek bir yetenek** olduğunu gösterir.

### GRUP 8 · Total Planned Spend (6)

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 36 | Planned Promo Spend On | `CPPOn + TPRDriveOn + WSTPROn` | `totalPromoOnInv` (`spend-calc:527,555`) | ⚠️ satır yok, **kod** | S → S | **eşleşen-doğru** |
| 37 | Planned Promo Spend Off | off-invoice kalemlerinin toplamı | `totalPromoOffInv` (`:528,595,623`) | ⚠️ satır yok, **kod** | S → S | **eşleşen-doğru** ⚠️`GİRDİ-SAPMALI` (`26`,`27`) |
| 38 | Total Planned Spend On | `PromoOn + LTA_On` | `PLANNED_ON_INVOICE_SPEND` ← `planned.totalOnInvoice` (`:636`) | kpis-satırı ⚠️`FORMÜL-KODDA` | S → S | **eşleşen-doğru** |
| 39 | Total Planned Spend Off | `PromoOff + LTA_Off` | `plannedOffInvoiceSpend` (`plan.service:2418`) — **KPI değil**; rapor yolunda **çıkarma ile** türetiliyor (`:2936`) | ⚠️ **satır yok** + iki türetim | S → — | **YOK** |
| 40 | Total Planned Spend | `On + Off` | `TOTAL_PLANNED_SPEND` ← `planned.totalSpend` (`:638`) | kpis-satırı ⚠️`FORMÜL-KODDA` | S → S | **eşleşen-doğru** |
| 41 | Incremental Planned Spend | `TotalPlannedSpend − BaseTradeSpend` | `INCR_SPEND` ← `incremental.total` (`:646`) | kpis-satırı ⚠️`FORMÜL-KODDA` | S → S | **eşleşen-doğru** ETİKET **`Excl. BMI`** |

⛔ **`39` iki kez türetiliyor ve İKİNCİSİ SESSİZ-SIFIR TAŞIYOR** `[ÖLÇÜLDÜ]`:
```
plan.service.ts:2418   plannedOffInvoiceSpend = spendBreakdown.planned.totalOffInvoice   ← DOĞRUDAN
plan.service.ts:2936   offInvoiceSpend += Math.max(0, totalSp - onInv)                   ← ÇIKARMA
              :2933      totalSp yoksa  →  totalSp = onInv     ⇒ off = 0 SESSİZCE
              :2936      totalSp < onInv →  Math.max(0, ·)     ⇒ negatif SESSİZCE 0
```
📌 `:2417`'deki yorum *"not derived by subtraction"* diyor — **başka bir yolda tam
olarak çıkarma yapılıyor.** `CLAUDE.md §2.7` **yorum-kirliliği** + `§2.5` **sessiz sıfır**.
⇒ `T-334`-**bitişik** bulgu (`§4.3`), evren kalemi değil.

### GRUP 9 · Gross Profit (5) — ⭐ `Z65 §3`: taban **`TO`**

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 42 | Base COGS | `COGS × Baseline` | `BASE_COGS` = `BASE_VOL * COGS` | kpis-satırı | S → S | **eşleşen-doğru** |
| 43 | Planned COGS | `COGS × **EffectiveTotalIMSVolumePC**` | `PLANNED_COGS` = `PLAN_VOL * COGS` (**sell-in**) | kpis-satırı | S → S | ⚠️ **eşleşen-sapmalı** ETİKET **`kaynağı-belirsiz-girdi`** |
| 44 | Base Gross Profit | `BaseTurnover − BaseCOGS` | `BASE_GP` = `BASE_TO - BASE_COGS` — `BASE_TO` **bugün NIV** | kpis-satırı | S → S | ⚠️ **eşleşen-sapmalı** (`Q3`) |
| 45 | Planned Gross Profit | `PlannedTurnover − PlannedCOGS` | `PLANNED_GP` = `PLANNED_TO - PLANNED_COGS` — `PLANNED_TO` **bugün NIV** | kpis-satırı | S → S | ⚠️ **eşleşen-sapmalı** (`Q3`) |
| 46 | iGP | `Planned − Base` | `INCR_GP` = `PLANNED_GP - BASE_GP` | kpis-satırı | S → S | **eşleşen-doğru** ⚠️`GİRDİ-SAPMALI` |

> ### ⭐ `44`/`45`'İN FORMÜL METNİ **ZATEN KANONİKTİR**
> `BASE_GP = BASE_TO - BASE_COGS` cümlesi Excel'in `BaseGrossProfit = BaseTurnover −
> BaseCOGS`'uyla **birebir aynıdır**. Sapan şey formül değil, **`BASE_TO`'nun ne
> anlama geldiğidir.**
>
> ⇒ **`Q3` (`Z65 §3`), `Q2` inince BEDAVA GELİR** — GP satırlarında **tek karakter
> değişmez**. Aynısı `48` (`GP_MARGIN_PCT = PLANNED_GP / PLANNED_TO`) ve `50`
> (`GP_ROI_PCT`) için de geçerli. `[GEREKÇELİ` — formül metinleri karşılaştırıldı`]`
>
> ⛔ **VE BU, PİNİN GEREKÇESİNİ AĞIRLAŞTIRIR:** düzeltme **hiçbir GP satırına
> dokunmadan** GP/ROI/RAG sayılarını değiştirir. Bir okuyucu diff'e bakıp *"GP'ye
> dokunulmamış"* diyebilir. ⇒ **`beklenen-değişim` listesi ŞART** (`Z65 §3`).

### GRUP 10 · Gross Margin (3)

| # | kanon kalem | kanon formül | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 47 | Base GM % | `(BaseGP / BaseTurnover) × 100` | **satır yok**; `Grid:290-297` | ⚠️ FE-hardcode | F → — | **YOK** |
| 48 | Planned GM % | `(PlannedGP / PlannedTurnover) × 100` | `GP_MARGIN_PCT` = `PLANNED_GP / PLANNED_TO * 100` — payda **NIV** | kpis-satırı | F → **F** ✅ | ⚠️ **eşleşen-sapmalı** (`Q3`) |
| 49 | iGM % | `(iGP / iTO) × 100` | **satır yok**; `Grid:308-334` | ⚠️ FE-hardcode | F → — | **YOK** |

### GRUP 11 · ROI & RAG (3)

| # | kanon kalem | kanon formül (Excel) | canlı | BİÇİM | AGG | verdict |
|---|---|---|---|---|---|---|
| 50 | Planned GP ROI % | `(iGP / **PlannedIncrPromoSpend**) × 100` | `GP_ROI_PCT` = `INCR_GP / **TOTAL_PLANNED_SPEND** * 100` | kpis-satırı | F → **F** ✅ | ⚠️ **eşleşen-sapmalı** ⛔ **`KANON-ÇATIŞMASI`** |
| 51 | Planned TO ROI % | `(iTO / PlannedIncrPromoSpend) × 100` | **satır yok** (BRD `KPI 41` `iGSV` kullanıyordu — o da sapma) | yok | F → — | **YOK** |
| 52 | RAG Status | **kadran:** `Red: iTO≤0` · `Amber: iTO>0 ∧ iGP≤0` · `Green: iTO>0 ∧ iGP>0` | `GP_ROI_PCT.rag_green=20 / rag_amber=10` + `determineRagStatus` | ⚠️ satır yok, **eşik alanı** | F → **F** ✅ | ⚠️ **eşleşen-sapmalı** ⛔ **`KANON-ÇATIŞMASI`** |

⛔ **`50` ve `52`'de KANON KENDİ İÇİNDE ÇATIŞIYOR — ve bu turda KARAR VERİLMEDİ** (`§2.4`):

```
50  payda   canlı  TOTAL_PLANNED_SPEND      (= BRD KPI 40 ile AYNI)
            Excel  PlannedIncrPromoSpend    (ARTIMSAL)
            Z62 §6-3 hükmü  "yalnız promo-spend, LTA HARİÇ"
            ölü kod spend-calc:1146  incremental.total    ← DÖRDÜNCÜ varyant
    ⇒ DÖRT farklı payda, hiçbiri diğerini kapsamıyor            §5 Q6

52  model   canlı  GP_ROI eşiği (20/10)  — tek eksen
            Excel  iTO × iGP kadranı     — İKİ eksen
    ⇒ eşik ayarı değil, MODEL farkı                             §5 Q7
```
📌 İkisinde de **canlı = BRD**, **kanon = Excel**. `Z65 §4` Excel'i *"formül-kanıt
kaynağı"* ilan etti ⇒ **Excel kazanır görünüyor** — ama `Z62 §6-3` `50` için **üçüncü**
bir şey söylüyor. **Hüküm olmadan yazılmaz.**

---

## `§2` · KOVA SAYIMI

```
eşleşen-doğru     19      1 2 3 5 6 7 8 19 20 21 23 25 36 37 38 40 41 42 46
eşleşen-sapmalı   14      4 10 11 13 14 22 26 27 43 44 45 48 50 52
YOK               11      9 12 15 16 17 18 24 39 47 49 51
[KAYNAKTA YOK]     8      28–35   ⛔ kova ATANAMAZ — Faz-2-ŞART OLAMAZ (Z65 §4)
                  ──
TOPLAM            52  ✅
```

⛔ **Bu dört sayı elle yazıldı ve `§1`'den TEK TEK SAYILABİLİR.** `DISIPLIN`
(*"elle yazılmış üye-sayısı"*): bir satırın kovası değişirse **bu blok da düzeltilir**.

### `2.1` · SAPMALI KOVANIN AYRIŞTIRILMASI — *hangi sapma kimin işi*

| alt-küme | kalemler | sahibi |
|---|---|---|
| **`Q2` ad-ayrıştırma** | `10 11 13 14` | ⭐ **`T-334`** |
| **`Q3` GP tabanı** | `44 45 48` | ⭐ **`T-334`** *(formül metni değişmez — `Q2`'nin türevi)* |
| **`Q5` off-invoice tabanı** | `26` | ⭐ **`T-334`** |
| **hüküm bekliyor** | `50 52` (`KANON-ÇATIŞMASI`) · `22` (yeni sapma) | ⛔ **ürün sahibi** — `§5` |
| **`kaynağı-belirsiz-girdi`** | `27 43` | ⛔ **`Z62 §6-2`** cevabı (koşul satırı ↓) |
| **bağımsız** | `4` (UOM) | `§5 Q9` |
| **türev (kendi kusuru yok)** | `37 46` `GİRDİ-SAPMALI` | `T-334` ile **kendiliğinden** düzelir |

```
koşul satırı — 27 ve 43
  sağlayıcı     ürün sahibi: EffectiveTotalIMSVolumePC'nin TM1 kaynağı (Z62 §6-2)
  tetikleyici   o cevabın inmesi
  o güne kadar  ETİKET taşınır · sell-in SESSİZ VEKİL SAYILMAZ · "eşleşti" YAZILMAZ
```

### `2.2` · `YOK` KOVASININ YERLEŞİMİ — `Z62 §0` süzgeci

| # | kalem | yerleşim | gerekçe |
|---|---|---|---|
| 9 | iGSV | **`Faz-2`-ŞART** | GSV grubunu tamamlar · bağımlılıkları **canlı ve aktif** · FE zaten gösteriyor ⇒ motor/ekran çelişkisini kapatır |
| 12 | iNIV | **`Faz-2`-ŞART** | `T-334` `BASE_NIV`/`PLANNED_NIV`'i **zaten doğuruyor**; üçüncüsü aynı turda, ek maliyet ≈ 0 |
| 15 | iTO | **`Faz-2`-ŞART** | `T-334` gerçek `TO`'yu geri veriyor · `49` (`iGM%`) ve Excel-`RAG` kadranı **buna bağlı** |
| 16 | TO Uplift % | **aday** | gösterim kalemi; `13`+`15` inince türev — ilk-müşteri değeri için **gerekli değil** |
| 17 | LTA On-Invoice % | **`Faz-2`-ŞART** | FE kolonu bugün **`// TODO` → `null`** · LTA taban zincirinin **tek görünür ucu** · `DALGA-B` pini zaten bu zinciri ölçüyor |
| 18 | LTA Off-Invoice % | **`Faz-2`-ŞART** | aynı zincir; `22`'nin sapması bu değer görünmeden **fark edilemez** |
| 24 | Total Planned LTA | **aday** | ⚠️ **Excel'de karşılığı YOK** — yalnız BRD `KPI 17`; iki bileşeni de canlı ⇒ türev toplam |
| 39 | Total Planned Spend Off | **`Faz-2`-ŞART** | bugün **iki farklı türetim** + **iki sessiz sıfır** (`§1 GRUP 8` notu) ⇒ tek-nokta gerekiyor |
| 47 | Base GM % | **aday** | `48` canlı; taban simetrisi için |
| 49 | iGM % | **aday** | `15` (iTO) inmeden **hesaplanamaz** ⇒ sırası `15`'ten sonra |
| 51 | TO ROI % | **aday** | `15`'e bağlı · Excel-`RAG` kadranı `iTO`'ya bakar, **`TO ROI`'ye değil** ⇒ `52`'nin ön-şartı **değil** |

```
Faz-2-ŞART   6      9 12 15 17 18 39
aday         5      16 24 47 49 51
Faz-3        0      ⇐ ve bu bir BULGUDUR, bir eksik değil (§2.3)
```

### `2.3` · ⛔ `Faz-3` KOVASI **BOŞ** — ve bu bilinçli

`Z62 §0` *"ölçek-hazırlığı kalemleri olay-tetikli koşul satırıyla yaşar"* der. Bu
evrende **ölçek-hazırlığı kalemi çıkmadı**: 52 kalemin tamamı **tek tenant / tek planın**
finansal hesabıdır — çoklu-tenant, hacim ya da entegrasyon ekseni taşıyan **hiçbiri yok**.

⛔ **Boş bir kova, doldurulmamış bir kova DEĞİLDİR.** `DISIPLIN`: *"karşılanamayan bir
ölçüt revize edilir — uydurma veriyle karşılanmaz."* Buraya kalem **uydurulmadı**.

📌 Olay-tetikli koşul satırları bu evrende **`YOK` kovasında değil**, **`sapmalı`
kovasında** ve **`[KAYNAKTA YOK]` etiketinde** yaşıyor (`2.1` ve `GRUP 7`).

---

## `§3` · EVREN ETKİSİ — `A0'` `§3`'ün GÜNCELLENMESİ

```
A0'  (7 kalem)         2 karşılandı / 5 karşılanmadı
A1   (52 kalem)        19 doğru · 14 sapmalı · 11 YOK · 8 kaynaksız
```

⛔ **VE *"eksik-18 / eksik-28"* SAYISI YANLIŞ BİR SORUYU ÖLÇÜYOR:**

`52 − 24 = 28` **KPI SATIRI** sayar. *"Kaç kanonik sayı doğru üretiliyor"* başka bir
sorudur ve cevabı şöyle ayrışıyor `[ÖLÇÜLDÜ]`:

```
YOK kovası (11) — "kanonik sayı KPI olarak üretilmiyor", ama HEPSİ AYNI DEĞİL:
   a  hiçbir yüzeyde üretilmiyor          2    24 51
   b  yalnız FE-hardcode'da üretiliyor    6    9 12 15 16 47 49      (motorda YOK)
   c  yalnız kod-içinde üretiliyor        3    17 18 39              (KPI değil)

eşleşen kovalarında (33) — biçim ekseni:
   d  kpis satırı var                    27
   e  satır YOK, ama üretiliyor           6    1 2 26 27 36 37
                                              (context-girdisi ya da kod)

ve doğruluk ekseni:
   f  satırı/değeri var ama SAPMALI      14
```
📌 **Bir envanter, bir teşhis değildir** (`DISIPLIN`). `24` sayısı `d`'yi ölçer —
ne `a`'yı, ne `f`'yi.

⇒ **`Faz-2`'nin gerçek işi `28` kalem *"inşa etmek"* değil:**
```
14  sapmayı düzelt            (9'u T-334 · 5'i hüküm/koşul bekliyor)
 6  kalemi inşa et            (Faz-2-ŞART: 9 12 15 17 18 39)
 5  kalemi aday'da beklet     (16 24 47 49 51)
 6  değeri KOD'dan KPI'ya taşı (biçim: 1 2 26 27 36 37)
 8  kalemin ADINI bul         (28–35 — kova atanamıyor)
```

---

## `§4` · ⭐ `T-334` KAPSAM ÖNERİSİ

> ⛔ `.claude/backlog/tasks/T-334.md` **açılmadı, okunmadı, dokunulmadı.**
> Bu bir **öneridir**; Team Lead işler. Migration numarası **tahsis EDİLMEDİ**
> (`CLAUDE.md §4-3`: *"ajan kendi numarasını seçmez"*).
> **Sıra:** `Z65 §7` — `DALGA-B` kapanışından **sonra**, kendi dalgasıyla.

### `4.1` · KAPSAM = sapmalı kovanın `Q2+Q3+Q5` alt-kümesi — **9 kalem**
`10 11 13 14` (`Q2`) · `44 45 48` (`Q3`, türev) · `26` (`Q5`) · `46` (`GİRDİ-SAPMALI`, türev)

⛔ **ÜÇÜ AYRI İNERSE ÜÇ MİGRATION TURU** (`Z65 §7`) — aynı formül katmanı, **tek tur**.

### `4.2` · KALEM LİSTESİ — dosya ve satır

**A · `main.kpis` (migration · `data-engineer` · numara Team Lead'den)**
```
INSERT  BASE_NIV      = 'BASE_GSV - BASE_LTA_ON'                      deps [BASE_GSV, BASE_LTA_ON]
INSERT  PLANNED_NIV   = 'PLANNED_GSV - PLANNED_ON_INVOICE_SPEND'      deps [PLANNED_GSV, PLANNED_ON_INVOICE_SPEND]
INSERT  INCR_NIV      = 'PLANNED_NIV - BASE_NIV'                      deps [PLANNED_NIV, BASE_NIV]     (kalem 12)
UPDATE  BASE_TO       = 'BASE_GSV - BASE_TOTAL_SPEND'                 deps [BASE_GSV, BASE_TOTAL_SPEND]
UPDATE  PLANNED_TO    = 'PLANNED_GSV - TOTAL_PLANNED_SPEND'           deps [PLANNED_GSV, TOTAL_PLANNED_SPEND]
INSERT  INCR_TO       = 'PLANNED_TO - BASE_TO'                        (kalem 15 · Faz-2-ŞART)
─ DOKUNULMAZ ─  BASE_GP · PLANNED_GP · GP_MARGIN_PCT · GP_ROI_PCT
                metinleri ZATEN KANONİK (§1 GRUP 9 notu) — Q3 Q2'nin türevidir
```
⚠️ **`calculation_order` kontrol edildi `[ÖLÇÜLDÜ]`:** `BASE_TOTAL_SPEND`=10 ve
`TOTAL_PLANNED_SPEND`=9, `BASE_TO`=25 / `PLANNED_TO`=26'dan **önce** ⇒ yeni bağımlılıklar
**mevcut sırayla uyumlu**, yeniden sıralama gerekmiyor. Yeni `*_NIV` satırları `25`/`26`
civarına, `INCR_NIV`/`INCR_TO` `46`'dan **önce** yerleşmeli.
⛔ Migration **idempotent** + `down()` + `formula_text` guard'ı (`1781`/`1782` deseni) ·
`DISIPLIN`: *"assert taşıyan migration ÜÇ durumu ayırt etmeli."*

**B · `collmind.backend/src` (`backend-engineer`)**
```
spend-calculation.service.ts:280-281   off-invoice taban: '- plannedLtaOffInv' KALDIRILIR   (Q5, kalem 26)
                                       kanon: (GSV − LTA_On − Σpromo_on) × pct
spend-calculation.service.ts:1108-1126 NIV/TO artık AYRI hesaplanır — 'baseTo = niv.baseNiv'
                                       ÖZDEŞLİĞİ KALKAR
   ⛔ ÖNCE KARAR: bu metodun (calculateCompleteSKUFinancialMetrics) ÜRETİM ÇAĞRISI SIFIR
      (A0' §4-7). DÜZELT mi SİL mi? — düzeltilirse "mekanizma var, yol yok" sınıfına
      yeni bir üye eklenir (CLAUDE.md §4.2 üçüncü madde)
plan.service.ts:2438-2447              context enjeksiyonu DEĞİŞMEZ — malzeme zaten tam
```

**C · `collmind.frontend/src` (`frontend-engineer`) — `Z65 §1` *"iki kopya AYNI dalgada"***
```
PlanningGridEnhanced.tsx:196-262   getSkuCellValue  — NIV/TO/GM/ROI blokları
PlanningGridEnhanced.tsx:536-600+  getFuCellValue   — AYNI formüllerin İKİNCİ kopyası
PlanningGridEnhanced.tsx:271-289   BASE_GP (FE-yerel, TO-tabanlı) ↔ PLAN_GP (BE, NIV-tabanlı)
                                   ⛔ INCR_GP bugün İKİ FARKLI SEMANTİĞİ ÇIKARIYOR
column-definitions.ts:547-608      NIV & Turnover grubu (7 kolon) — kodlar motorla hizalanır
```
📌 `Z65 §1a`: **frontend formül HESAPLAMAZ, motor SONUCUNU gösterir** — bu bir *hüküm
değil sınıf-notudur*, ama `T-334` **zaten bu dosyalara giriyor** ⇒ aynı dokunuşta
hizalamak, ikinci bir tur açmaktan ucuz.

**D · PİNLER (`qa-engineer`)**
```
1  AYIRT-EDİCİ FIXTURE     LTA_Off > 0  VE  off-invoice promo > 0
                           ⇒ TO ≠ NIV OLMAK ZORUNDA
   ⛔ DISIPLIN: "fixture farkı GEREKLİ; onu OKUYAN assertion olmadan YETERSİZ"
      ⇒ pin TO ile NIV'i AYRI AYRI assert eder, farkı SAYIYLA yazar
2  BEKLENEN-DEĞİŞİM LİSTESİ  RAG renkleri DEĞİŞECEK (Z65 §3) — düzeltme, regresyon DEĞİL
                             ⇒ eski değer + yeni değer + FARKI ÜRETEN KALEM yazılı
3  Q5 PİNİ                  off-invoice mekanik tabanı = NIV; LTA_Off DÜŞÜLMEZ
                            fixture LTA_Off > 0 olmadan bu pin KÖRDÜR (T-273 ailesi)
4  MUTABAKAT                TOTAL_PLANNED_SPEND == PLANNED_ON_INVOICE_SPEND + off
                            (Z63 §2-ii deseni: birikimli sapmayı tek tek kontrol yakalamaz)
5  FE/BE ÇAKIŞTIRMA         grid BASE_TO == motor BASE_TO   (bugün ÇELİŞİYOR)
```

### `4.3` · `T-334` KAPSAMINDA **DEĞİL** — ama aynı dosyalarda
| bulgu | yer | neden dışarıda |
|---|---|---|
| `50` ROI paydası (**dört varyant**) | `GP_ROI_PCT` | ⛔ **hüküm yok** (`§5 Q6`) — `Z62 §6-3` motorda **sabitlenmeyecek** diyor, tasarım işi |
| `52` RAG modeli (eşik ↔ kadran) | `determineRagStatus` | ⛔ **hüküm yok** (`§5 Q7`) — model değişimi |
| `22` `PLANNED_LTA_OFF` tabanı | `spend-calc:513-514` | ⛔ **yeni sapma**, `Z65`'te yok · yönü **ters** (`§5 Q8`) |
| `39` çifte türetim + iki sessiz sıfır | `plan.service:2933-2936` | `§2.5` ihlali — **ayrı bir bugfix**, formül-kanon işi değil |
| `27`/`43` sell-out hacmi | `spend-calc:288-295` · `PLANNED_COGS` | ⛔ **koşul satırı** — sağlayıcı ürün sahibi (`Z62 §6-2`) |
| `4` UOM çevrimi | `sku.entity.ts:82` (tüketici **0**) | `§5 Q9` |
| `FORMÜL-KODDA` (5 kalem) | `external` KPI'lar | **BRD'nin kendi tasarımı** — kusur değil, sınır |

### `4.4` · ⛔ ACİLİYET **VE** ÖLÇÜM SINIRI — aynı sayıdan
```
plans = 0 · plan_fus = 0 · plan_skus = 0     [ÖLÇÜLDÜ 2026-08-30]
```
| yüz | sonuç |
|---|---|
| **ACİLİYET** (`Z65 §1b`) | kavram-ayrıştırma migration'ı **bugün BEDELSİZ** — yalnız `kpi` TANIM tablosu. İlk gerçek müşteri planı girdiği gün **veri-migration'ına döner.** ⇒ **veri-sıfır penceresi kapanmadan inmeli** |
| **ÖLÇÜM SINIRI** (`T-273` ailesi) | bu raporun **hiçbir kanıtı üretilmiş bir sayı değildir** — hepsi konfigürasyon + kod okuması. Sapmaların **yönü** ölçüldü, **büyüklüğü** ölçülemedi |

> **Aynı `0`, hem fırsat penceresi hem körlük kaynağıdır.** İkisi de yazıldı.

---

## `§5` · ÖLÇEMEDİM  *(9 kalem)*

| # | ölçemediğim | neden | riski |
|---|---|---|---|
| 1 | **Hiçbir üretilmiş KPI değeri** | `plans/plan_fus/plan_skus = 0` `[ÖLÇÜLDÜ]` | `§1`'in tamamı **konfigürasyon+kod** okuması. Bir formülün *"çalıştığı"* değil, *"yazıldığı"* ölçüldü |
| 2 | **Sapmaların BÜYÜKLÜĞÜ** (₺ / puan) | veri yok | `22`'nin (kötümser) `26`+`44/45`'i (iyimser) ne kadar dengelediği **bilinmiyor** ⇒ net yön **iddia edilmedi** |
| 3 | RAG renk değişiminin **kapsamı** | plan yok | `Z65 §3`'ün *"beklenen-değişim listesi"* bugün **doldurulamaz** — `T-334` fixture'ıyla doldurulur |
| 4 | `28–35` sekiz kalemin adı/formülü | hiçbir kaynakta yok | evren `52` **sayıca** kapalı, **listece** açık |
| 5 | `EffectiveTotalIMSVolumePC` | `Z62 §6-2` **AÇIK-SORU** | `27`/`43` kilitli; sell-in **vekil sayılmadı** |
| 6 | FE grid'in gerçekten render ettiği | plan verisi yok · **e2e yasak** (bu turun şartı) | FE bulguları **kod okuması**; kullanıcı-görünür etki **ölçülmedi** |
| 7 | `calculateCompleteSKUFinancialMetrics`'in HTTP erişilebilirliği | `rg` yalnız `*.spec.ts` buldu `[ÖLÇÜLDÜ]`; **uygulama çalıştırılmadı** | `blocked-unreachable` **iddia edilmedi** — grep güçlü, koşum yok |
| 8 | `main.tactics` (5) ↔ `main.mechanics` (6) ↔ Excel `§2` (9 tactic / 6 aile) | `Z62 §5`: Excel `§2` → **`EK_E` referansı**, KPI evreni değil | tactic eşlemesi **bu raporun kapsamı dışında**; sayı farkı **kaydedildi**, yorumlanmadı |
| 9 | `1780` döneminde üretilmiş tarihsel değerler | veri yok | `T-008`'in *"YANLIŞ"* yargısının **veriye dayanıp dayanmadığı** |

---

## `§6` · ÜRÜN SAHİBİNE AÇIK SORULAR *(yeni — `Z65`'in beşi KAPANDI)*

> ⛔ Hiçbirinde varsayım yapılmadı (`CLAUDE.md §2.4`). `Q6`/`Q7` **`50` ve `52`'yi
> `T-334`'e sokmayı bloke eder**; diğerleri eşlemeyi bloke etmez ama **kayda girer**.

**`Q6` — `GP ROI %` paydası hangisi? (⛔ `50`'yi bloke eder)** `[ÖLÇÜLDÜ`: dört varyant`]`
```
canlı / BRD KPI 40   TOTAL_PLANNED_SPEND            (toplam planlanan harcama)
Excel                PlannedIncrPromoSpend          (ARTIMSAL)
Z62 §6-3 hükmü       yalnız promo-spend, LTA HARİÇ  (+ tenant'a göre değişebilir)
ölü kod :1146        incremental.total
```
Dördü **farklı sayı** üretir ve `RAG` rengini doğrudan değiştirir. `Z62 §6-3` ayrıca
*"motorda SABİTLENMEZ, tek noktadan okunur"* diyor — **o tek nokta nerede?**

**`Q7` — `RAG` modeli: eşik mi kadran mı? (⛔ `52`'yi bloke eder)**
```
canlı   GP_ROI_PCT >= 20 GREEN · >= 10 AMBER · else RED     (tek eksen)
Excel   Red iTO≤0 · Amber iTO>0 ∧ iGP≤0 · Green iTO>0 ∧ iGP>0  (iki eksen)
```
Excel modeli **`iTO`'ya bağlı** ⇒ kalem `15` (`Faz-2`-ŞART) **ön şartıdır**. Model
değişecekse `T-334`'ün fixture'ı **şimdiden** iki eksenli kurulmalı.

**`Q8` — `PLANNED_LTA_OFF` tabanı promo-on'u düşmeli mi?** *(yeni sapma, `Z65`'te yok)*
Excel `LTAOffPct × PlannedPromoNIV`; kod `(GSV − LTA_On) × pct`. ⇒ ROI **kötümser** —
`Z65 §6` deseninin **ilk karşı-örneği**. `T-334`'e girsin mi, ayrı mı?

**`Q9` — `PLANNED_VOL` UOM çevrimi:** `sku.conversionFactor` **tanımlı, tüketicisi
SIFIR** `[ÖLÇÜLDÜ]`. Excel `TotalVolUOM × UOMConversionFactor` diyor. Kalem `4`
`Faz-2`-ŞART mı, `Faz-3` mü?

**`Q10` — `28–35`'in adları** (`Z65 §4` koşul satırı): kaynak metni verilebilir mi?
Verilemezse **`Faz-3`/elenir** kararı gerekir — bugün **hiçbir kovaya konamıyor**.

**`Q11` — `24` `Total Planned LTA Spend`:** BRD `KPI 17`'de **var**, Excel'de **yok**.
Evrende kalsın mı (bugün **aday**)?

**`Q12` — `AGG` enum adı `weighted_avg`, davranış `recompute`** (`kpi-engine:126-143`).
Davranış **doğru**; ad yanlış. `T-334`-dışı bir ad-borcu olarak kaydedilsin mi?

---

## `§7` · BU RAPORUN YAPMADIKLARI

```
T-334.md dosyası                  AÇILMADI, OKUNMADI, DOKUNULMADI  (öneri §4'te)
migration numarası                TAHSİS EDİLMEDİ  (§4-3: ajan kendi numarasını seçmez)
src/ altına yazma                 YAPILMADI (yalnız okundu)
test / e2e                        KOŞULMADI (paralel DALGA-B ağaçta)
Q6/Q7 kararı                      VERİLMEDİ — DUR (§2.4)
Section_05 F12 (A3)               YAPILMADI — ayrı iş
28–35'in adları                   UYDURULMADI  (§5-4)
```
