# KPI EVRENİ — GRUP AĞACI

> ## ⛔ `F12` — BU BELGENİN SAYISI DÜŞTÜ *(2026-08-31, `T-340` · hüküm `Z67`+`Z69`)*
>
> ```
> önceki DOSYA ADI   KPI_EVRENI_52_GRUP_AGACI.md
> önceki BAŞLIK      "11 GRUP / 52 KALEM"
> ```
> **`52` bir ONBİR BAŞLIĞIN TOPLAMIYDI**, bir kalem listesinin uzunluğu değil.
> `Section_05 §5.3`'ün `GROUP 5 … (11 KPIs)` başlığı **dokuz** adlı kalemin üstünde
> duruyordu ⇒ `52` **iki fazla** sayıyordu.
>
> ⭐ **Ad da düzeltildi** (`Z69`): *"bir dosya adı, içeriği okunmadan önce okunan tek
> satırdır"* — `52` taşıyan bir ad, bu `F12`'yi asla görmeyecek okuyuculara (dizin
> listesi · link · atıf) **düzeltilmemiş sayıyı beyan etmeye devam ederdi.**
> `git mv` kullanıldı; dosya geçmişi korundu.
>
> ⇒ **TÜRETİLMİŞ EVREN: `docs/research/KPI_EVRENI_TURETILMIS_LISTE.md`.**
> ⚠️ Aşağıdaki metin **SİLİNMEDİ** (append-only izi). `52`, `11 kalem` ve
> `[KAYNAKTA YOK] 8` geçen her satır **bu `F12` altında okunur.**

> **kaynak:** Faz-2 açılış paketi, ürün sahibi, 2026-08-29
> **statü:** **YAZILMIŞ evren, türetilmiş DEĞİL**
> **yazan:** `data-analyst` (`W2` `DALGA-A` / `A4`) · **tarih:** 2026-08-30
> **iş:** `docs/process/W2_CIFT_DALGA_BRIEF.md` `A4` · hüküm `04_KARAR_KAYDI.md` `Z62 §6-1`

Bu dosya `A4`'ün tek işini yapar: **`11 grup / 52 kalem` evrenine repoda bir adres vermek.**
Evren bugüne kadar yalnız proje bilgisinde (sohbet) yaşıyordu — `G5` ailesi:
*"bir evren, kaynağı gösterilemiyorsa **türetilmiş** değil **YAZILMIŞ**tır."*

⛔ **Bu belge bir SPEC DEĞİLDİR.** Yerleşim (`Faz-2`-şart / aday / `Faz-3`) `Z62 §0`
süzgecinden geçer ve **`A1`'in işidir** — bu turda yapılmadı.

---

## 0 · ⭐ ÖLÇÜM — `52` SAYISININ ARİTMETİĞİ REPODA **ÜRETİLEBİLİYOR**

Statü satırı ürün sahibinin verdiği hâliyle korunur (**YAZILMIŞ**). Ama bu tur bir
şey daha ölçtü ve **kayda geçmesi gerekir**: `52` ve `11` sayıları bugün repodaki
iki kaynaktan **yeniden üretilebiliyor**.

```
42   docs/brd/01_Main_BRD/Section_05_Planning_First_Mode.md  §5.3
     "Complete KPI Library" SQL blokları   -- KPI 1 … -- KPI 42   (satır 616–1197)
     GRUP 1..8 başlıkları                  (2+4+3+8+11+6+5+3 = 42)      [ÖLÇÜLDÜ]
+3   NIV              (Base / Planned / Incremental)
+4   Turnover         (Base / Planned / Incremental / Uplift %)
+3   Gross Margin     (Base / Planned / Incremental)
──
52   ve   8 grup + 3 grup = 11 GRUP                                      [ÖLÇÜLDÜ]
```

⇒ `W2` brief'inin `A3` satırındaki *"`42 → 52` (NIV 3 + Turnover 4 + Gross Margin 3
geri)"* aritmetiği **birebir tutuyor**. Yani evren *"uydurulmuş"* değil; **kaynağı
gösterilmemişti.** Bu dosya o adresi verir.

~~⚠️ Ama **`52`'nin 8 kalemi hâlâ ADSIZ** (`§2 GRUP 7`) — aşağıda `[KAYNAKTA YOK]`
işaretli. Sayı türetilebiliyor, **liste tamamlanamıyor**.~~

> ⛔ **`F12` — BAŞLIK HATASI, SLOT YOK** *(`T-340`, 2026-08-31)*
> **Sekiz adsız kalem diye bir şey YOKTU.** `Section_05 §5.3`'ün `(11 KPIs)` başlığı
> **dokuz** adlı kalemin üstündeydi; `.cursor/KPI_Details.docx` (*"KPI Library"*) ve
> Excel `§1` **aynı dokuz adı** taşıyor. Üçü canlı listede zaten vardı, **altısının
> adı bu turda bulundu**:
> `PlannedVisibilityMTPH · PlannedVisibilityGT · PlannedTPRDriveOn ·
> PlannedTPRDriveLumpsum · PlannedWSTPROn · PlannedWSTPROff`
> ⇒ **`[KAYNAKTA YOK]` kovası KAPANDI.** Etiket doğruydu, ama işaretlediği şey bir
> **eksiklik değil, bir SAYIM HATASIYDI** (`Z67 §4`).

📌 `DISIPLIN`: *"bir sayı, LİSTESİYLE anılır ya da HİÇ anılmaz."* Bu belge sayıyı
listesiyle anıyor — **ve listenin eksik yerini de gösteriyor.**

---

## 1 · KAYNAK HARİTASI — hangi grup nereden geldi

| # | grup | kalem | kaynak |
|---|---|---|---|
| 1 | Master Data | 2 | `Section_05 §5.3` SQL (KPI 1–2) · Excel `§1 Master Data` |
| 2 | Volume | 4 | `Section_05 §5.3` SQL (KPI 3–6) · Excel `§1 VOLUME` |
| 3 | GSV | 3 | `Section_05 §5.3` SQL (KPI 7–9) · Excel `§1 GSV` |
| 4 | **NIV** | 3 | `Section_05 §5.3` **anlatı listesi** (*"Net Invoice Value - NIV (3 KPIs)"*) · **formüller Excel `§1 NIV`** |
| 5 | **Turnover** | 4 | `Section_05 §5.3` **anlatı listesi** (*"Turnover (4 KPIs) - Base, Planned, Incremental, Uplift%"*) · **formüller Excel `§1 Turnover`** |
| 6 | LTA Spend | 8 | `Section_05 §5.3` SQL (KPI 10–17) — ⚠️ Excel'de bu grup **7 kalem** |
| 7 | Promo Spend by Mechanic | 11 | `Section_05 §5.3` SQL (KPI 18–28) — ⚠️ **8'i adsız** · Excel'de **9 kalem** |
| 8 | Total Planned Spend | 6 | `Section_05 §5.3` SQL (KPI 29–34) · Excel `§1 Promo Spend` |
| 9 | Gross Profit | 5 | `Section_05 §5.3` SQL (KPI 35–39) · Excel `§1 Gross Profit` |
| 10 | **Gross Margin** | 3 | ⛔ **`Section_05`'te HİÇ YOK** — tek kaynak **Excel `§1 Gross Margin`** |
| 11 | ROI & RAG | 3 | `Section_05 §5.3` SQL (KPI 40–42) · Excel `§1 ROI&RAG` |
|  | **TOPLAM** | **52** | **11 grup** |

⚠️ **Kaynak-içi tutarsızlıklar (`F12` adayı — bu turda DÜZELTİLMEDİ):**

```
a  Section_05 §5.3 anlatısı  "40+ KPIs organized into 8 groups"  DER
   ve ALTINDA DOKUZ grup SAYAR (NIV ve Turnover dahil) — 2+4+3+3+4+8+11+5+3 = 43
b  Aynı bölümün SQL kütüphanesi SEKİZ grup / 42 kalem taşır — NIV ve Turnover YOK
c  Başlık "40 KPIs" · gövde 42 · anlatı 43 · Excel 49 · bugünkü hüküm 52
```
📌 Yani `NIV`+`Turnover` **BRD'nin kendi anlatısında duruyordu**; düşen şey
**SQL kütüphanesiydi**. `Z62 §6-1`'in *"düşüş bilinçli değildi"* hükmü bu ölçümle
**bağımsız olarak doğrulanıyor** — `DISIPLIN`: *"en iyi kontrol, bağımsız bir kayıtla
çakıştırmadır."*

⚠️ **Excel `§1` ile toplam örtüşmüyor ve bu KAYIT KONUSUDUR:** Excel sözlüğü
(girdi-mekanikleri hariç) **11 grup / 49 kalem**tir — `LTA Spend 7` (BRD 8) ve
`Promo Spend by Mechanic 9` (BRD 11) farkından. **`52` sayısı BRD-42 tabanlıdır,
Excel tabanlı değildir.** Bu fark `A1`'in girdisidir; **burada çözülmedi.**

---

## 2 · GRUP AĞACI — 52 kalem

> `kod` sütunu: `Section_05 §5.3` SQL bloklarındaki `kpi_code`.
> `[KAYNAKTA YOK]` = hiçbir repo kaynağında adı geçmiyor ⇒ **ürün sahibinden istenecek.**

### GRUP 1 · Master Data (2)
| # | kalem | kod | formül / kaynak |
|---|---|---|---|
| 1 | List Price per Piece (BPTT) | `LIST_PRICE` | `sku.list_price` (external) |
| 2 | COGS per Piece | `COGS` | `sku.cogs_per_unit` (external) |

### GRUP 2 · Volume (4)
| # | kalem | kod | formül |
|---|---|---|---|
| 3 | Base Volume | `BASE_VOL` | `baseline.volume` (external) |
| 4 | Planned Volume | `PLANNED_VOL` | `plan_sku.planned_volume` (user_input) |
| 5 | Incremental Volume (iVol) | `INCR_VOL` | `PLANNED_VOL - BASE_VOL` |
| 6 | Volume Uplift % | `VOL_UPLIFT_PCT` | `(INCR_VOL / BASE_VOL) * 100` |

### GRUP 3 · GSV (3)
| # | kalem | kod | formül |
|---|---|---|---|
| 7 | Base GSV | `BASE_GSV` | `BASE_VOL * LIST_PRICE` |
| 8 | Planned GSV | `PLANNED_GSV` | `PLANNED_VOL * LIST_PRICE` |
| 9 | Incremental GSV (iGSV) | `INCR_GSV` | `PLANNED_GSV - BASE_GSV` |

### GRUP 4 · NIV (3) — ⭐ SQL kütüphanesinde YOKTU
| # | kalem | kod | formül (Excel `§1`) |
|---|---|---|---|
| 10 | Base NIV | `[KAYNAKTA YOK — kod atanmamış]` | `BaseGSV × (1 − LTAOnPct)` |
| 11 | Planned NIV | `[KAYNAKTA YOK — kod atanmamış]` | `PlannedPromoGSV − PlannedPromoTotalSpendOn` |
| 12 | iNIV | `[KAYNAKTA YOK — kod atanmamış]` | `PlannedPromoNIV − BaseNIV` |

⛔ **Kod atama bu turda YAPILMADI** — `Z64 §3`: *"yeniden-adlandırma hükmü eşleme-sonrası,
VERİ-DOKUNMASIZ."* Bugün bu üç kavramın ikisi canlıda **`BASE_TO` / `PLANNED_TO`** adıyla
yaşıyor (`AD-BORCU` — bkz. `A0_KAVRAM_ESLEME_RAPORU.md §1`).

### GRUP 5 · Turnover (4) — ⭐ SQL kütüphanesinde YOKTU
| # | kalem | kod | formül (Excel `§1`) |
|---|---|---|---|
| 13 | Base TO | `[KAYNAKTA YOK — kod atanmamış]` | `BaseGSV − BaseTradeSpend` (`= BaseLTAOn + BaseLTAOff`) |
| 14 | Planned TO | `[KAYNAKTA YOK — kod atanmamış]` | `PlannedPromoGSV − PlannedPromoTotalSpend` (**ON+OFF**) |
| 15 | iTO | `[KAYNAKTA YOK — kod atanmamış]` | `PlannedPromoTurnover − BaseTurnover` |
| 16 | TO Uplift % | `[KAYNAKTA YOK — kod atanmamış]` | `(PlannedIncrTO / BaseTurnover) × 100` |

⛔ **`BASE_TO`/`PLANNED_TO` kodları bugün BU KAVRAMLARA AİT DEĞİLDİR** — `NIV`'e aittir.
Bkz. `A0_KAVRAM_ESLEME_RAPORU.md §1`.

### GRUP 6 · LTA Spend (8)
| # | kalem | kod | formül |
|---|---|---|---|
| 17 | LTA On-Invoice % | `LTA_ON_PCT` | `sku.lta_on_invoice_pct` (external) |
| 18 | LTA Off-Invoice % | `LTA_OFF_PCT` | `sku.lta_off_invoice_pct` (external) |
| 19 | Base LTA Spend On-Invoice | `BASE_LTA_ON` | `(BASE_GSV * LTA_ON_PCT) / 100` |
| 20 | Base LTA Spend Off-Invoice | `BASE_LTA_OFF` | `((BASE_GSV - BASE_LTA_ON) * LTA_OFF_PCT) / 100` |
| 21 | Planned LTA Spend On-Invoice | `PLANNED_LTA_ON` | `(PLANNED_GSV * LTA_ON_PCT) / 100` |
| 22 | Planned LTA Spend Off-Invoice | `PLANNED_LTA_OFF` | `((PLANNED_GSV - PLANNED_LTA_ON) * LTA_OFF_PCT) / 100` |
| 23 | Total Base LTA Spend | `TOTAL_BASE_LTA` | `BASE_LTA_ON + BASE_LTA_OFF` |
| 24 | Total Planned LTA Spend | `TOTAL_PLANNED_LTA` | `PLANNED_LTA_ON + PLANNED_LTA_OFF` |

⚠️ Excel'de bu grup **7 kalem** (`Total Planned LTA Spend` yok; `Total Base Spend` =
`BaseTradeSpend` var). Fark `A1`'e.

### GRUP 7 · Promo Spend by Mechanic (11) — ⛔ **8'i ADSIZ**
| # | kalem | kod | formül |
|---|---|---|---|
| 25 | CPP On-Invoice % Spend | `CPP_ON_SPEND` | `((PLANNED_GSV - PLANNED_LTA_ON) * CPP_ON_PCT) / 100` |
| 26 | CPP Off-Invoice % Spend | `CPP_OFF_SPEND` | `((PLANNED_GSV - PLANNED_LTA_ON - CPP_ON_SPEND) * CPP_OFF_PCT) / 100` |
| 27 | Price Support per Unit Spend | `PRICE_SUPPORT_SPEND` | `PLANNED_VOL * PRICE_SUPPORT_PER_UNIT` |
| ~~28–35~~ | ⛔ **`F12`: SLOT YOK — başlık hatası** | — | **6 adlı kalem** ⇒ `KPI_EVRENI_TURETILMIS_LISTE.md §1a` |

⛔ **Ölçüm:** `Section_05 §5.3`'te bu sekiz kalemin yerinde **tek bir yorum satırı** var:
`-- KPI 21-28: Display Fees, Visibility, TPR lumpsums` (satır 955) — **SQL bloğu yok, kod
yok, formül yok.** Sekizinin adı repoda **hiçbir yerde** yazılı değil.

📌 **ADAY isimler (Excel `§1 Promo Spend by Mechanic`, 9 kalem — ATAMA DEĞİL, ADAY):**
`PlannedVisibilityMTPH` · `PlannedVisibilityGT` · `PlannedTPRDriveOn` ·
`PlannedTPRDriveLumpsum` · `PlannedWSTPROn` · `PlannedWSTPROff`
(+ Excel'in ilk üçü zaten `25–27`'ye karşılık geliyor).
⚠️ **Excel 9 verir, BRD 11 ister — iki kalem hâlâ açıkta.** `8 ≠ 6` ve `9 ≠ 11`;
eşleştirme **hiçbir kaynakta yazılı değil** ⇒ **ürün sahibi kararı.**

### GRUP 8 · Total Planned Spend (6)
| # | kalem | kod | formül |
|---|---|---|---|
| 36 | Planned Promo Spend On-Invoice | `TOTAL_PROMO_ON` | `CPP_ON_SPEND` (⚠️ BRD'de tek terim) |
| 37 | Planned Promo Spend Off-Invoice | `TOTAL_PROMO_OFF` | `CPP_OFF_SPEND + VISIBILITY_SPEND + DISPLAY_SPEND + PRICE_SUPPORT_SPEND` |
| 38 | Total Planned Spend On-Invoice | `TOTAL_ON_SPEND` | `PLANNED_LTA_ON + TOTAL_PROMO_ON` |
| 39 | Total Planned Spend Off-Invoice | `TOTAL_OFF_SPEND` | `PLANNED_LTA_OFF + TOTAL_PROMO_OFF` |
| 40 | Total Planned Spend (ALL) | `TOTAL_PLANNED_SPEND` | `TOTAL_ON_SPEND + TOTAL_OFF_SPEND` |
| 41 | Incremental Planned Spend | `INCR_SPEND` | `TOTAL_PLANNED_SPEND - TOTAL_BASE_LTA` — *"Excl. BMI"* (`Z62 §6-4`) |

### GRUP 9 · Gross Profit (5)
| # | kalem | kod | formül |
|---|---|---|---|
| 42 | Base COGS | `BASE_COGS` | `BASE_VOL * COGS` |
| 43 | Planned COGS | `PLANNED_COGS` | `PLANNED_VOL * COGS` ⚠️ Excel: `COGS × EffectiveTotalIMSVolumePC` — **kaynağı-belirsiz-girdi** (`Z62 §6-2`) |
| 44 | Base Gross Profit | `BASE_GP` | `BASE_GSV - BASE_COGS` ⚠️ **GSV tabanlı** — Excel `BaseTurnover − BaseCOGS` |
| 45 | Planned Gross Profit | `PLANNED_GP` | `(PLANNED_GSV - CPP_ON_SPEND) - PLANNED_COGS` |
| 46 | Incremental Gross Profit (iGP) | `INCR_GP` | `PLANNED_GP - BASE_GP` |

📌 `44`/`45`'in `GSV` tabanlı olması, `Turnover` grubunun SQL kütüphanesinden düşmüş
olmasının **doğrudan sonucudur** (`Z62 §6-1`: *"42'nin LTA/ROI formülleri bu gruplara
bağımlıydı"*). **Bağımsız kanıt.**

### GRUP 10 · Gross Margin (3) — ⭐ `Section_05`'te HİÇ YOK
| # | kalem | kod | formül (Excel `§1`) |
|---|---|---|---|
| 47 | Base GM % | `[KAYNAKTA YOK — kod atanmamış]` | `(BaseGrossProfit / BaseTurnover) × 100` |
| 48 | Planned GM % | `[KAYNAKTA YOK — kod atanmamış]` | `(PlannedPromoGrossProfit / PlannedPromoTurnover) × 100` |
| 49 | iGM % | `[KAYNAKTA YOK — kod atanmamış]` | `(PlannedIncrPromoGP / PlannedIncrTO) × 100` |

⚠️ Canlıda `GP_MARGIN_PCT` (`PLANNED_GP / PLANNED_TO * 100`) var — `48`'in **adayı**,
ama paydası `Turnover` değil `NIV`'dir (`AD-BORCU` zinciri). Eşleme `A1`'de.

### GRUP 11 · ROI & RAG (3)
| # | kalem | kod | formül |
|---|---|---|---|
| 50 | GP ROI % | `GP_ROI_PCT` | `(INCR_GP / TOTAL_PLANNED_SPEND) * 100` ⚠️ payda hükmü `Z62 §6-3` |
| 51 | TO ROI % | `TO_ROI_PCT` | `(INCR_GSV / TOTAL_PLANNED_SPEND) * 100` ⚠️ **`iGSV` kullanıyor, `iTO` değil** — `Turnover` düşüşünün ikinci izi |
| 52 | RAG Status | `RAG_STATUS` | `IF(GP_ROI_PCT >= 20,'GREEN', IF(GP_ROI_PCT >= 10,'AMBER','RED'))` ⚠️ Excel: **iTO/iGP kadranı** — farklı model |

---

## 3 · SAYIM DOĞRULAMASI

```
2 + 4 + 3 + 3 + 4 + 8 + 11 + 6 + 5 + 3 + 3  =  52        ✅
grup sayısı                                  =  11        ✅
adı KAYNAKTAN gelen kalem                    =  44      ← F12: gerçekte 50 (§1a+§1b)
adı HİÇBİR KAYNAKTA olmayan kalem            =   8        ← F12: SIFIR — slot yoktu
kodu atanmamış ama adı/formülü bilinen kalem =  10        (GRUP 4, 5, 10)
```

⛔ **Bu üç sayı elle yazıldı ve yukarıdaki tablolardan sayılabilir.** `DISIPLIN`
(*"elle yazılmış üye-sayısı: ölçülmüş oran dokuzda dokuz"*) gereği: bir kalem
eklenir/çıkarılırsa **bu blok da düzeltilir**, yoksa blok silinir.

---

## 4 · BU BELGENİN YAPMADIKLARI

| yapılmadı | nerede yapılacak |
|---|---|
| `52 × canlı-24` kalem eşlemesi | **`A1`** — evren hükmü indikten sonra |
| Yerleşim (`Faz-2`-şart / aday / `Faz-3`) | **`A1`**, `Z62 §0` süzgeciyle |
| `Section_05` `F12` düzeltmesi (`40`/`42`/`43` → hüküm) | **`A3`** — sayı kesinleşince |
| `GRUP 4/5/10`'a kod atanması | **eşleme-sonrası**, `Z64 §3` (VERİ-DOKUNMASIZ) |
| Excel-49 ↔ BRD-52 farkının çözümü | **`A1`** girdisi · ürün sahibi kararı |
