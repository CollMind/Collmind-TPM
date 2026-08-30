# KPI EVRENİ — **ADLI-KALEM LİSTESİNDEN TÜRETİLMİŞ**

> **iş:** `T-340` · **hüküm:** `04_KARAR_KAYDI.md` `Z67` (+ `Z69` ad-hükmü)
> **yazan:** `data-analyst` · **tarih:** 2026-08-31 · **statü:** **TÜRETİLMİŞ** (`G5`: yazılmış < taranmış < türetilmiş)
> **yöntem:** salt-okunur. Kaynak metin makineyle ayrıştırıldı; sayı **listeden üretildi**, hiçbir başlıktan alınmadı.

⛔ **Bu belgenin adında ve başlığında SAYI YOKTUR** (`Z69`: *"bir dosya adı da bir başlıktır"*).
Sayılar yalnız **listenin yanında** yazılıdır ve listeden sayılabilir.

---

## `§0` · KAYNAK METİN **BULUNDU** — ve repoda bir adresi var

`Z67` evreni *"`A1` promptunun tam metni (**proje bilgisi**)"*na dayandırıyordu — yani
sohbette yaşayan, repoda adresi olmayan bir metne. **Bu tur o metnin repo-içi taşıyıcısını
buldu:**

```
.cursor/KPI_Details.docx
   └── "KPI Library for Marketing Promotions and Analysis"     (word/document.xml, 869–980)
       11 KPI grubu  +  12. grup: "Promo Mechanics (User Inputs)"  ← KPI DEĞİL, girdi
```

**Ayrıştırma mekaniktir, elle sayım değildir:** `document.xml` düzleştirildi, grup
başlıkları sabit bir kümeyle eşlendi, her kalem `Ad (ID)Formula:` deseninden çekildi.
Çıkan liste `§1`'dedir; grup sayıları o listenin `len()`'idir.

⚠️ **Bunun `Z67`'nin kastettiği metin OLDUĞUNU KANITLAYAMAM** (`§6` `ÖLÇEMEDİM-1`).
Kanıtlayabildiğim üç bağımsız çakışma:

| çakışma | ölçüm |
|---|---|
| `Z67 §1`: *"PSbM adlı listesi **9**"* + dokuz adın kendisi | docx PSbM grubu **tam olarak o dokuz adı** taşıyor |
| `Z67 §3`: *"adlı-kalem ön-sayımı **49**"* (ürün sahibi) | docx'in KPI toplamı **49** |
| `DEMO_EXCEL… §1` grup sayıları (**bağımsız kaynak**) | grup grup **birebir** aynı (`§3`) |

📌 Ve `A1_KPI_ESLEME.md §1 GRUP 7`'nin koşul satırı zaten bu belgeyi adıyla anıyor:
*"ürün sahibi — **KPI-Library/A1** kaynak metninin 21-28 satırları."*

⛔ **`.cursor/KPI_Engine_Prompts.pdf` bu listeyi TAŞIMIYOR** — `pdftotext -layout` ile
tarandı: sekiz prompt var, `Master Data KPIs` / `BaseNIV` / `VisibilityGT` **sıfır
eşleşme**. Yani kaynak metnin repodaki **tek** taşıyıcısı `KPI_Details.docx`'tir.

---

## `§1` · ADLI-KALEM LİSTESİ — **EVREN**

> **kaynak:** `.cursor/KPI_Details.docx` → *"KPI Library for Marketing Promotions and Analysis"*
> **okuma tarihi:** 2026-08-31 · **yöntem:** makine-ayrıştırma
> `ID` sütunu kaynak metnin kendi parantezidir. **Kimlik = AD/ID'dir, numara değildir**
> (`Z67 §2`: *"başlık sayıları güvenilmez; kalem adları kanoniktir"*).
> `eski #` = `A1_KPI_ESLEME.md`'nin numarası — **atıf sürekliliği için**, kimlik olarak değil.

### `1a` · KANONİK-YAKINSAK ÇEKİRDEK — *iki bağımsız kaynak aynı listeyi veriyor*

| grup | # | kalem | ID | eski # |
|---|---|---|---|---|
| **Master Data** | 1 | List Price per piece | `BPTT` | 1 |
| | 2 | COGS per piece | `COGS` | 2 |
| **Volume** | 1 | Base Volume | `Baseline` | 3 |
| | 2 | Planned Volume | `PlannedTotalVolume` | 4 |
| | 3 | Incremental Volume – iVol | `PlannedIncrVol` | 5 |
| | 4 | Volume Uplift % | `PlannedIncrPromoVolPct` | 6 |
| **Turnover** | 1 | Base TO | `BaseTurnover` | 13 |
| | 2 | Planned TO | `PlannedPromoTurnover` | 14 |
| | 3 | Incremental TO – iTO | `PlannedIncrTO` | 15 |
| | 4 | TO Uplift % | `PlannedIncrPromoTOPct` | 16 |
| **GSV** | 1 | Base GSV | `BaseGSV` | 7 |
| | 2 | Planned GSV | `PlannedPromoGSV` | 8 |
| | 3 | Incremental GSV – iGSV | `PlannedIncrPromoGSV` | 9 |
| **NIV** | 1 | Base NIV | `BaseNIV` | 10 |
| | 2 | Planned NIV | `PlannedPromoNIV` | 11 |
| | 3 | Incremental NIV – iNIV | `PlannedIncrNIV` | 12 |
| **LTA Spend** | 1 | LTA On-Invoice % | `LTAOnPct` | 17 |
| | 2 | LTA Off-Invoice % | `LTAOffPct` | 18 |
| | 3 | Base LTA Spend On-Invoice | `BaseLTASpendOn` | 19 |
| | 4 | Base LTA Spend Off-Invoice | `BaseLTASpendOff` | 20 |
| | 5 | Planned LTA Spend On-Invoice | `PlannedPromoLTAOnInvoice` | 21 |
| | 6 | Planned LTA Spend Off-Invoice | `PlannedPromoLTAOffInvoice` | 22 |
| | 7 | Total Base Spend | `BaseTradeSpend` | 23 |
| **Promo Spend by Mechanic** | 1 | CPP On-invoice% Spend | `PlannedCPPOn` | 25 |
| | 2 | CPP Off-invoice% Spend | `PlannedCPPOff` | 26 |
| | 3 | Price Support per Unit Spend | `PlannedPriceSupport` | 27 |
| | 4 | **Visibility Lumpsum MT/PH Spend** | `PlannedVisibilityMTPH` | ⭐ *(eski `28–35` hayalet slotu)* |
| | 5 | **Visibility Lumpsum GT Spend** | `PlannedVisibilityGT` | ⭐ |
| | 6 | **Drive/TPR On-invoice% Spend** | `PlannedTPRDriveOn` | ⭐ |
| | 7 | **TPR/Drives Lumpsum Spend** | `PlannedTPRDriveLumpsum` | ⭐ |
| | 8 | **WS TPR On-invoice% Spend** | `PlannedWSTPROn` | ⭐ |
| | 9 | **WS TPR Off-invoice% Spend** | `PlannedWSTPROff` | ⭐ |
| **Total Promo Spend** | 1 | Planned Promo Spend On-Invoice | `PlannedOnInvoiceDiscounts` | 36 |
| | 2 | Planned Promo Spend Off-Invoice | `PlannedOffInvoiceDiscounts` | 37 |
| | 3 | Total Planned Spend On-Invoice | `PlannedPromoTotalSpendOn` | 38 |
| | 4 | Total Planned Spend Off-Invoice | `PlannedPromoTotalSpendOff` | 39 |
| | 5 | Total Planned Spend | `PlannedPromoTotalSpend` | 40 |
| | 6 | Incremental Planned Spend | `PlannedIncrPromoSpend` | 41 |
| **Gross Profit** | 1 | Base COGS | `BaseCOGS` | 42 |
| | 2 | Planned COGS | `PlannedCOGS` | 43 |
| | 3 | Base Gross Profit | `BaseGrossProfit` | 44 |
| | 4 | Planned Gross Profit | `PlannedPromoGrossProfit` | 45 |
| | 5 | Incremental Gross Profit – iGP | `PlannedIncrPromoGP` | 46 |
| **Gross Margin** | 1 | Base Gross Margin % | `BaseGrossMarginPct` | 47 |
| | 2 | Planned Gross Margin % | `PlannedPromoGrossMarginPct` | 48 |
| | 3 | Incremental Gross Margin % | `PlannedIncrPromoGM` | 49 |
| **ROI & RAG** | 1 | Planned TO ROI % | `PlannedPromoROITO` | 50 |
| | 2 | Planned GP ROI % | `PlannedPromoROIGP` | 51 |
| | 3 | RAG Status | `Planned OPSO Quadrant` | 52 |

**Grup uzunlukları — listeden türetildi:**
`Master Data 2 · Volume 4 · Turnover 4 · GSV 3 · NIV 3 · LTA Spend 7 · Promo Spend by
Mechanic 9 · Total Promo Spend 6 · Gross Profit 5 · Gross Margin 3 · ROI & RAG 3`
⇒ **`2+4+4+3+3+7+9+6+5+3+3 = 49` · 11 grup.**

### `1b` · TEK-KAYNAKLI EK KALEM — `BRD`-only

| kalem | ID | kaynak | eski # |
|---|---|---|---|
| Total Planned LTA Spend | `TOTAL_PLANNED_LTA` | ⚠️ **yalnız** `Section_05 §5.3` `KPI 17` — tam SQL bloğu, kodu ve formülü var | 24 |

`Z66 §4` `Q11` hükmü: *"kaynağı **varsa** evrende **KALIR**"*. **Kaynağı ölçüldü ve VAR**
(adlandırılmış SQL bloğu, `formula: PLANNED_LTA_ON + PLANNED_LTA_OFF`). ⇒ **evrende kalır.**
`.cursor/KPI_Details.docx`'te ve Excel `§1`'de **karşılığı yoktur** — bu bir eksiklik
işareti değil, **kaynak farkının kendisidir** ve öyle kaydedilir.

### `1c` · ⛔ EVRENE **GİRMEYEN** — ve neden

| küme | üye | neden dışarıda |
|---|---|---|
| **Promo Mechanics (User Inputs)** | `CPPOnInvoicePCT` `CPPOffInvoicePCT` `PriceSupportperPiece` `VisibilityMTPH` `VisibilityGT` `DriveTPROnInvoicePCT` `TPRDriveLumpsum` `WSTPROnInvoicePCT` `WSTPROffInvoicePCT` | Kaynak metnin **kendi cümlesi**: *"not performance outcomes but the **input parameters**"*. Excel `§1` de aynı ayrımı yapar (*"Promo Mechanics (girdi) 9"*). ⇒ **KPI değil, girdi.** |
| **hayalet slotlar** | eski `28–35` | ⛔ **YOK.** Bir sayım hatasının ürünüydü (`§2`). |

---

## `§2` · BAŞLIK ↔ LİSTE FARKLARI — grup grup

> ⭐ **BULGU: `"(11)"` ve `"(8)"` BAŞLIKLARI `A1` KAYNAK METNİNDE YOKTUR.**
> `.cursor/KPI_Details.docx`'in grup başlıkları **sayı taşımaz** (*"Promo Spend by Mechanic
> KPIs"*, nokta). Parantezli sayılar **yalnız `Section_05 §5.3`'te** yaşıyor.
> ⇒ `Z67`'nin *"başlık hatası"* teşhisi **doğru, ama hatanın ADRESİ `Section_05`'tir.**

### `2a` · `Section_05 §5.3` SQL kütüphanesi — `#### GROUP n: … (m KPIs)`

| başlık | başlığın dediği | **adlandırılmış SQL bloğu** | fark |
|---|---|---|---|
| GROUP 1 Master Data | 2 | 2 | — |
| GROUP 2 Volume | 4 | 4 | — |
| GROUP 3 GSV | 3 | 3 | — |
| GROUP 4 LTA Spend | 8 | **8** | — ⚠️ **başlık DOĞRU** |
| GROUP 5 Promo Spend by Mechanic | **11** | **3** | ⛔ **`-8`** — yerinde tek yorum satırı: `-- KPI 21-28: Display Fees, Visibility, TPR lumpsums` (`:955`) |
| GROUP 6 Total Planned Spend | 6 | 6 | — |
| GROUP 7 Gross Profit | 5 | 5 | — |
| GROUP 8 ROI & RAG | 3 | 3 | — |
| **başlık toplamı** | **42** | **adlandırılmış toplam 34** | **`-8`** |

`grep -c "^-- KPI [0-9]*:"` = **34** `[ÖLÇÜLDÜ]`. `42 − 34 = 8` ⇒ **hayalet sekizin
tamamı GROUP 5'tedir.**

### `2b` · ⛔ `LTA "(8)"` BİR BAŞLIK HATASI **DEĞİLDİR** — `Z67 §3`'e düzeltme

`Z67 §3` *"LTA `(8)` **muhtemelen** `7` adlı kalemin üstünde"* diyordu — ve `Z67 §3`'ün
kendi ek şartı (`Z62`-ailesi: *"**muhtemelen** bir hüküm değildir"*) tam da bunu ölçmeyi
istiyordu. **Ölçüldü:**

```
Section_05 §5.3 GROUP 4     KPI 10 … KPI 17     SEKİZ tam SQL bloğu, sekizinin de adı var
KPI_Details.docx LTA grubu  YEDİ kalem          (Total Planned LTA Spend YOK)
Excel §1 LTA Spend          YEDİ kalem          (aynı yedi)
```

⇒ Bu **başlığın fazla sayması değil**, `Section_05`'in **bir kalem FAZLA taşımasıdır**
(`TOTAL_PLANNED_LTA`, `§1b`). İki durum konsolda aynı görünür — *"başlık `8`, kanon `7`"* —
ama **kökleri zıttır**, ve **tedavileri de zıttır**: biri hayaleti siler, öteki gerçek bir
kalemi korur.

> ### **BİR SAYI FARKI, FARKIN KAYNAĞI GÖSTERİLMEDEN YORUMLANAMAZ.**
> `PSbM`'de fark **yokluktan**, `LTA`'da fark **fazlalıktan** doğuyordu. `Z67` ikisini
> aynı cümleyle (*"başlık hatası"*) topluyordu; ölçüm **ayırdı**.

### `2c` · `Section_05 §5.3` ANLATISI — üçüncü ve dördüncü sayı

```
:495  "computes 40+ KPIs"
:509  "40+ KPIs organized into 8 groups:"   ← ve ALTINDA DOKUZ MADDE SAYIYOR
:587  "### Complete KPI Library (40 KPIs)"
```
Anlatı listesi (`:511-519`): `2+4+3+3+4+8+11+5+3 = 43` — ve **iki grubu hiç saymıyor**:
`Total Planned Spend (6)` ve `Gross Margin (3)`. Yani anlatı **hem fazla** (`11`) **hem
eksik** (iki grup).

### `2d` · DÖRDÜNCÜ VAKA — `Z67 §2`'nin listesine yeni satır

`Section_05 :615-619` *"Computation-Only KPIs"* bloğu:
```
- LTA spend breakdowns (8 KPIs)
- COGS values (2 KPIs)
- Detailed promo spend by mechanic (11 KPIs)
- Base GP, Base COGS (3 KPIs)          ← İKİ kalem sayıyor, "3" diyor
```
⇒ `Z67 §2`'nin *"başlık sayıları bu belge ailesinde **sistematik** güvenilmez"* kaydına
**dördüncü tanık**, ve bu kez **aynı satırın içinde**: ad listesi `2`, sayı `3`.

### `2e` · `"52"` NEREDEN GELDİ — ve ne oldu

```
52  =  2+4+3+3+4+8+11+6+5+3+3          ← A4/Z67'nin kaydettiği onbir başlığın toplamı
                        ↑
                        └── Section_05'in "(11)" başlığı ⇒ gerçekte 9 adlı kalem  ⇒  −2
türetilmiş liste (§1a + §1b)  =  49 + 1  =  50
```
**Fark tam olarak `−2`'dir** ve tek kaynağı `PSbM` başlığıdır. `LTA "(8)"` **fark
üretmiyor**, çünkü sekizinci kalem gerçekten var (`§2b`).

---

## `§3` · EXCEL ÖRTÜŞMESİ — **ÖLÇÜLDÜ**

**Karşılaştırılan:** `§1a` listesi ↔ `DEMO_EXCEL_KPI_TACTIC_REFERANSI.md §1`
(kaynağı `Demo_V2_Work_Orginal.xlsx`, **`KPI_Details.docx`'ten bağımsız okuma**).

| grup | `§1a` | Excel `§1` | ad-düzeyi örtüşme |
|---|---|---|---|
| Master Data | 2 | 2 | **tam** |
| Volume | 4 | 4 | **tam** |
| Turnover | 4 | 4 | **tam** |
| GSV | 3 | 3 | **tam** |
| NIV | 3 | 3 | **tam** |
| LTA Spend | 7 | 7 | **tam** |
| Promo Spend by Mechanic | 9 | 9 | **tam** |
| Total Promo Spend | 6 | 6 | **tam** |
| Gross Profit | 5 | 5 | **tam** |
| Gross Margin | 3 | 3 | **tam** |
| ROI & RAG | 3 | 3 | **tam** |
| *(Promo Mechanics — girdi)* | *9* | *9* | *tam — ikisi de evren dışı sayıyor* |

⇒ **Örtüşmeyen kalem: YOK.** İki bağımsız kaynak **aynı 49 kaleme** yakınsıyor.
`Z67 §6`: *"iki bağımsız kaynağın aynı listeye yakınsaması, bir başlığın — hatta iki
başlığın — hemfikir olmasından daha güçlüdür."*

### `3a` · ⛔ ÖRTÜŞMEYENLER — **ADIYLA** (kalem değil, **yazım/formül düzeyinde**)

*"Büyük ölçüde örtüşüyor"* bir ölçüm değildir. Kalem düzeyinde fark sıfır; **yazım
düzeyinde üç fark** ölçüldü ve üçü de adıyla burada:

| # | kalem | `KPI_Details.docx` | `DEMO_EXCEL… §1` | teşhis |
|---|---|---|---|---|
| 1 | Planned Promo Spend On-Invoice | `PlannedOnInvoiceDiscounts` | `PlannedOnI**I**nvoiceDiscounts` | çift `I` — **transkripsiyon**; aynı kalem |
| 2 | Planned Promo Spend Off-Invoice | `PlannedOffInvoiceDiscounts` | `PlannedOffI**I**nvoiceDiscounts` | aynı |
| 3 | Planned Promo Spend Off-Invoice **formülü** | **tam altı terim:** `PlannedCPPOff + PlannedPriceSupport + PlannedVisibilityMTPH + PlannedVisibilityGT + PlannedTPRDriveLumpsum + PlannedWSTPROff` | *"sheet'te 80-karakter kesikti; bileşim off-invoice kalemlerinin toplamı"* | ⭐ **docx, Excel'in KESİK formülünü TAMAMLIYOR** — ve Excel okuyucusunun yeniden-kurduğu bileşim **birebir doğrulanıyor** |

📌 `3` bir fark değil, bir **kazançtır**: Excel raporunun `[YENİDEN KURULDU]` işaretli tek
formülü artık **ikinci bir kaynaktan doğrulanmıştır**.

### `3b` · ⚠️ ÖRTÜŞMENİN BAĞIMSIZLIK SINIRI

İki kaynak birbirinden **bağımsız okundu** (biri `.xlsx`, öteki `.docx`), ama **kökeni
bağımsız olmayabilir** — `DEMO_EXCEL… §6` zaten *"Excel muhtemelen BRD-listesinin
atasıdır"* diyor. ⇒ Yakınsama **transkripsiyon hatasını** eler; **ortak bir ata hatasını
elemez.** Bu, kanıtın gücünü azaltmaz ama **sınırını** çizer (`§6` `ÖLÇEMEDİM-2`).

---

## `§4` · `A1` KOVA SAYILARI — **YENİDEN TÜRETİLMİŞ**

⚠️ **İki şey aynı anda değişti** ve ayrı ayrı işlenir:
```
(a)  EVREN değişti      hayalet 8 düştü · adlı 6 doğdu       ⇒  §4a
(b)  CANLI ürün değişti T-334 İNDİ (migration FormulaCanonTurnoverNivSplit1818000000000)
                        ⇒ eski kova verdict'lerinin bir kısmı ARTIK GEÇERSİZ  ⇒  §4b
```
`(b)` `A1` yazıldığında henüz olmamıştı. **`A1 §2`'nin sayıları bugün ölçülmemiş
sayılardır** — aşağısı canlı DB ve koddan yeniden ölçüldü `[ÖLÇÜLDÜ 2026-08-31]`.

### `4a` · `[KAYNAKTA YOK]` KOVASI **KAPANDI** — gerekçesiyle

```
eski   [KAYNAKTA YOK]  8   (28–35)   "kova ATANAMAZ · Faz-2-ŞART OLAMAZ"
yeni   [KAYNAKTA YOK]  0
```

**Kapanış gerekçesi — üç adım:**
1. Etiketin tanımı *"hiçbir repo kaynağında adı geçmiyor"*du. `.cursor/KPI_Details.docx`
   ve Excel `§1` **altı adı da taşıyor** ⇒ tanım artık **hiçbir kaleme uymuyor**.
2. Etiketin **saydığı** sekiz slot bir başlık hatasıydı; **altı** gerçek kalem vardı.
   `8 ≠ 6` farkı bir eksiklik değil, **hatanın büyüklüğüydü**.
3. ⛔ Ve etiket **koruyucu** işliyordu: `Z65 §4` *"evrenden atılmaz, taşınır"* diyordu —
   yani hayaletler **hükümle korunuyordu**. `Z67 §4`: *"bir etiket, olmayan bir şeyi de
   KORUYABİLİR."*

⇒ `Z66 §4` `Q10` (*"kaynaksız kalem `Faz-2-ŞART` olamaz"*) **konusuz kaldı** — kuralı
uygulanacak kalem yok. Kural yürürlükte kalır; **bu evrende tetiklenmiyor.**

### `4b` · YENİ KOVA SAYIMI — canlıdan ölçülerek

**Canlı taban `[ÖLÇÜLDÜ 2026-08-31]`:** `main.kpis` **32 satır** (28 `is_active=t`, 4 `f`) ·
`main.mechanics` **6 satır** (`deleted_at IS NULL`).

⛔ **Sayı YAZILMAZ, LİSTEDEN OKUNUR.** Kovalar üye listesiyle verilir; her sayı
kendi satırındaki üyelerden sayılabilir:

```
eşleşen-doğru    1 2 3 5 6 7 8 10 11 12 13 14 15 19 20 21 23 25 26
                 36 37 38 40 41 42 44 45 46 48 50
eşleşen-sapmalı  4 22 27 43 52
YOK              9 16 17 18 24 39 47 49 51
eşleme-belirsiz  PlannedVisibilityMTPH · PlannedVisibilityGT · PlannedTPRDriveOn
                 PlannedTPRDriveLumpsum · PlannedWSTPROn · PlannedWSTPROff
                                                                    ── evren §1a+§1b ile TUTAR
```

⚠️ **Numaralar `A1_KPI_ESLEME.md`'nin numaralarıdır** (`50`=`GP ROI %`, `51`=`TO ROI %`) —
`§1a`'nın satır sırası **farklıdır**, bkz. `§6` `ÖLÇEMEDİM-5` ve `§7 S1`.

⚠️ **`eşleme-belirsiz` yeni bir KOVA DEĞİL, bir DUR KAYDIDIR** (`§4e`): kalemler adlıdır
ve kaynaklıdır — eksik olan **canlı karşılıklarıdır**, kaynakları değil. `[KAYNAKTA YOK]`
etiketiyle **karıştırılmamalıdır**; o etiket bu evrende **konusuz kaldı** (`§4a`).

📌 `DISIPLIN` (*"elle yazılmış üye-sayısı: ölçülmüş oran dokuzda dokuz"*): bir satırın
kovası değişirse **bu blok da düzeltilir**, yoksa **silinir**.

### `4c` · `T-334` SONRASI DEĞİŞEN VERDICT'LER — ölçümle

| eski # | kalem | `A1`'in verdict'i | bugünkü ölçüm | kanıt |
|---|---|---|---|---|
| 10 | Base NIV | `YOK`/sapmalı | **eşleşen-doğru** | `main.kpis BASE_NIV = 'BASE_GSV - BASE_LTA_ON'` ≡ `BaseGSV×(1−LTAOnPct)` |
| 11 | Planned NIV | sapmalı | **eşleşen-doğru** | `PLANNED_NIV = 'PLANNED_GSV - PLANNED_ON_INVOICE_SPEND'` |
| 12 | iNIV | `YOK` (**`Faz-2`-ŞART**) | **eşleşen-doğru** ✅ | `INCR_NIV = 'PLANNED_NIV - BASE_NIV'` · order 24 |
| 13 | Base TO | sapmalı | **eşleşen-doğru** | `BASE_TO = 'BASE_GSV - BASE_TOTAL_SPEND'` |
| 14 | Planned TO | sapmalı | **eşleşen-doğru** | `PLANNED_TO = 'PLANNED_GSV - TOTAL_PLANNED_SPEND'` |
| 15 | iTO | `YOK` (**`Faz-2`-ŞART**) | **eşleşen-doğru** ✅ | `INCR_TO = 'PLANNED_TO - BASE_TO'` · order 27 |
| 26 | CPP Off-invoice% | sapmalı (`Q5`) | **eşleşen-doğru** | `spend-calculation.service.ts:304-313` — `plannedPromoNiv(...)`, `LTA_Off` **düşülmüyor** |
| 44 | Base GP | sapmalı (`Q3`) | **eşleşen-doğru** | `BASE_GP = 'BASE_TO - BASE_COGS'` |
| 45 | Planned GP | sapmalı (`Q3`) | **eşleşen-doğru** | `PLANNED_GP = 'PLANNED_TO - PLANNED_COGS'` |
| 48 | Planned GM % | sapmalı (`Q3`) | **eşleşen-doğru** | `GP_MARGIN_PCT = 'PLANNED_GP / PLANNED_TO * 100'` |
| 50 | Planned GP ROI % | sapmalı (`KANON-ÇATIŞMASI`) | **eşleşen-doğru** | `GP_ROI_PCT = 'INCR_GP / INCR_PROMO_SPEND * 100'` (`Z66 §1` hükmü) |

⚠️ **Numara ekseni uyarısı:** `A1`'in numaralamasında `50`=`GP ROI %`, `51`=`TO ROI %`;
`§1a` ise kaynak metnin sırasını izler ve orada **`TO ROI` önce** gelir. Yukarıdaki tablonun
son satırında kastedilen kalem **`PlannedPromoROIGP`**'dir. Bu belge yazılırken bu eksende
**bir kayma yakalandı ve düzeltildi** — `§6` `ÖLÇEMEDİM-5` ve `§7 S1`.

### `4d` · ⭐ HÂLÂ SAPMALI — ve **biri T-334'ün KENDİ turundan artakalmış**

| kalem | sapma | kanıt |
|---|---|---|
| `PlannedPromoLTAOffInvoice` (eski `22`) | ⛔ **KISMEN düzeltildi.** `spend-calculation.service.ts:554-557` kanonik `PlannedPromoNIV` tabanına geçmiş; **kardeş yol geçmemiş:** `lta-calculation.service.ts:258-261` hâlâ `(plannedGsv − plannedLtaOn) × pct/100` | kodun kendi yorumu `:254-257`: *"Yol ÖLÜ DEĞİL: `POST /lta-agreements/calculate/planned-spend` bunu çağırıyor … **iki yüzey iki farklı sayı üretiyor**"* |
| `PlannedPriceSupport` (27) | `enteredValue × plannedVolume` (**sell-in**) ↔ kanon `× EffectiveTotalIMSVolumePC` (**sell-out**) | `spend-calculation.service.ts:321-325` · ETİKET `kaynağı-belirsiz-girdi` (`Z62 §6-2`) |
| `PlannedCOGS` (43) | aynı sell-in/sell-out ekseni | ETİKET `kaynağı-belirsiz-girdi` |
| `Planned OPSO Quadrant` (52) | **tek eksen** — `kpi-engine.service.ts:100,172,257…` `determineRagStatus(GP_ROI_PCT)`; `main.kpis`'te `RAG_STATUS` **satırı YOK** | `Z66 §2`/`Z68 §1` **iki-eksen kadran** hükmü **henüz inmemiş** |
| `PlannedTotalVolume` (4) | UOM ekseni (`Q9`) | `A1 §5 Q9` — değişmedi |

> ### ⚠️ ÖLÇÜMÜN GEÇERLİLİK KOŞULU — `RAG` SATIRI **AYNI ANDA DEĞİŞİYOR**
> Yukarıdaki `Planned OPSO Quadrant` satırı **commit'lenmiş HEAD'e karşı** ölçüldü
> (`3332a2d`). Ölçüm anında `collmind.backend` çalışma ağacında **`Z68`'in inişi
> sürüyordu** `[ÖLÇÜLDÜ 2026-08-31]`:
> ```
> ?? src/common/kpi/rag-quadrant.ts
>  M src/modules/shared/kpi-engine/kpi-engine.service.ts
>  M src/modules/modes/planning-first/plan/plan.service.ts
>  M src/database/entities/plan.entity.ts
> ```
> ⇒ **`52`'nin kovası bu iş kapandığında yeniden ölçülmelidir.** `DISIPLIN`:
> *"bir ölçümün geçerliliği koşullarına bağlıdır — koşulu ölçümle birlikte yaz."*
> ⛔ Bu ajan `src/` altına **yazmadı**; yukarıdaki satırlar **paralel ajanın işidir.**

⇒ **`§7.1` kardeş-yol dersinin yeni bir vakası:** `T-334` `Q8`'i **bir dosyada** düzeltti,
**ikinci dosya açıkta kaldı** — ve bunu **kodun kendi yorumu itiraf ediyor**. Bir düzeltme
turunun kapanış ölçütü *"kardeş yol taranmış mı"*dır; burada tarandı ve **kayda geçti**,
ama **kapatılmadı**.

### `4e` · YENİ `eşleme-belirsiz` KOVASI — altı adlı kalem, canlı karşılığı **BELİRSİZ**

`main.mechanics` `[ÖLÇÜLDÜ, 6 satır]`:
```
CPP_ON_PCT · CPP_OFF_PCT · PRICE_SUP · DISPLAY_FEE · VIS_LS · MEC-DISCOUNT
```

| yön | eşleşen | eşleşmeyen |
|---|---|---|
| kanon `PSbM` **9** → canlı | `PlannedCPPOn`→`CPP_ON_PCT` · `PlannedCPPOff`→`CPP_OFF_PCT` · `PlannedPriceSupport`→`PRICE_SUP` | **6:** `PlannedVisibilityMTPH` `PlannedVisibilityGT` `PlannedTPRDriveOn` `PlannedTPRDriveLumpsum` `PlannedWSTPROn` `PlannedWSTPROff` |
| canlı **6** → kanon | aynı üç | **3:** `DISPLAY_FEE` · `VIS_LS` · `MEC-DISCOUNT` |

⛔ **DUR — eşleme YAPILMADI** (`CLAUDE.md §2.4`). Akla gelen üç eşleme de **çok anlamlı**:
```
VIS_LS ("Visibility Lump Sum")   ↔  PlannedVisibilityMTPH + PlannedVisibilityGT ?   1↔2
DISPLAY_FEE ("Display/Shelf Fee")↔  PlannedTPRDriveLumpsum ?                        kanon'da "Display" YOK
MEC-DISCOUNT ("Discount")        ↔  PlannedTPRDriveOn  ya da  PlannedWSTPROn ?      formülleri AYNI, ikisinden hangisi belirsiz
```
📌 `MEC-DISCOUNT`'un formülü `CPP_ON_PCT` ile **birebir aynı**
(`(PLANNED_GSV - PLANNED_LTA_ON) * entered_value / 100`) ⇒ **formülden ayırt edilemez**;
ayırt edici yalnız **ad** olabilir, ve ad kanonda yok. ⇒ `§7` `S2`.

⚠️ Ve `DISPLAY_FEE` **kanonik listede karşılığı olmayan bir canlı yetenektir** —
`Section_05`'in hayalet yorum satırı bile *"**Display Fees**, Visibility, TPR lumpsums"*
diyordu. Yani *"Display Fee"* kavramı **BRD'de var, KPI-Library'de yok**. Bu bir
**evren sorusudur**, bir eşleme sorusu değil ⇒ `§7` `S3`.

### `4f` · `Faz-2`-ŞART / aday / `Faz-3` YERLEŞİMİ — yeni evrende

`A1 §2.2`'nin yerleşimi **`YOK` kovası için** verilmişti. `YOK` kovası küçüldü (`11 → 9`),
çünkü `12` ve `15` **inşa edildi**.

| eski yerleşim | bugünkü durum |
|---|---|
| `Faz-2`-ŞART **6** — `9 12 15 17 18 39` | **`12`, `15` KAPANDI** ⇒ kalan **4**: `9 17 18 39` |
| `aday` **5** — `16 24 47 49 51` | ⚠️ `51`(`TO ROI %`) `15`'e bağlıydı — **ön şartı düştü**, artık inşa edilebilir. Yerleşim **değişmedi** (aday), ama **engeli kalktı** |
| **`Faz-3` 0** | ⛔ **HÂLÂ 0 — ve doldurulmadı** |

⛔ **`Faz-3` boş kaldı ve bu bir BULGUDUR** (`Z66 §5b`). Yeni evren **altı adlı kalem
getirdi** ve *"ölçek-hazırlığı"* kovasına konabilecek gibi görünen bir tanesi bile
**süzgeçten geçmedi** — çünkü altısı da `eşleme-belirsiz`, yani **yerleşim öncesi bir
soru** bekliyorlar. **Bir kova doldurulmak için var değildir.**

---

## `§5` · `ŞART-6` × `T-334` KESİŞİMİ — ve **KALAN FARK**

`Z67 §7`: *"`T-334`'ün `9+1`'i ile `ŞART-6`'nın kesişimi **muhtemelen büyük**"*.
⛔ *"Muhtemelen"* bir ölçüm değildir (`Z67 §3` ek şartı). **Ölçüldü:**

```
ŞART-6         9(iGSV)  12(iNIV)  15(iTO)  17(LTA On %)  18(LTA Off %)  39(Toplam Planlanan Off)
T-334 9+1      10 11 12 13 14 · 26 · 44 45 48 · (46 türev) · 15 · 22
KESİŞİM        12 · 15                                                          ⇒ İKİ kalem
KALAN FARK     9 · 17 · 18 · 39                                                 ⇒ DÖRT kalem
```

**Kesişim canlıdan doğrulandı `[ÖLÇÜLDÜ]`:** `INCR_NIV` ve `INCR_TO` `main.kpis`'te var.
**Kalan dördün yokluğu da doğrulandı** — `SELECT kpi_code FROM main.kpis WHERE kpi_code ~*
'GSV|LTA|OFF_INVOICE|ROI|MARGIN|UPLIFT'` dokuz satır döndü ve **hiçbiri** `INCR_GSV`,
`LTA_ON_PCT`, `LTA_OFF_PCT` ya da `PLANNED_OFF_INVOICE_SPEND` değil:
```
BASE_GSV · BASE_LTA_OFF · BASE_LTA_ON · GP_MARGIN_PCT · GP_ROI_PCT
PLANNED_GSV · PLANNED_LTA_OFF · PLANNED_LTA_ON · UPLIFT_PCT
```
⚠️ `BASE_LTA_ON`/`OFF` **tutar** kalemleridir (`19`,`20`); `17`/`18` **oran** kalemleridir
ve bunlar `LTAContext.finalOn/OffInvoicePct` olarak **yalnız kodda** yaşar.
⇒ `LEFT JOIN + IS NULL` tuzağının ad-uzayı hâli: **benzer ad, farklı kalem.**

### ⭐ `5a` · KALAN DÖRT — **`W3`-baseline'ın önünü temizleyen liste**

| kalem | ID | neden hâlâ açık | ilk müşterisi |
|---|---|---|---|
| **iGSV** | `PlannedIncrPromoGSV` | `BASE_GSV`+`PLANNED_GSV` **canlı ve aktif**; farkları KPI olarak üretilmiyor. FE zaten gösteriyor ⇒ **motor/ekran çelişkisi** | grid kolonu |
| **LTA On-Invoice %** | `LTAOnPct` | FE kolonu bugün `// TODO → null` · LTA taban zincirinin **tek görünür ucu** | grid + `T-291`/`T-293` zinciri |
| **LTA Off-Invoice %** | `LTAOffPct` | aynı zincir; `22`'nin **kardeş-yol sapması** (`§4d`) bu değer görünmeden **fark edilemez** | aynı |
| **Total Planned Spend Off-Invoice** | `PlannedPromoTotalSpendOff` | ⛔ bugün **KPI değil**; iki ayrı türetim + `plan.service.ts:2933,2936`'da **iki sessiz sıfır** (`A1 §1 GRUP 8` ölçümü) | bütçe/rapor yüzeyi |

📌 **Dördü de tek bir aileden:** *"kalem canlıda **hesaplanıyor** ama **KPI olarak
doğmuyor**"* — yani `BİÇİM` kusuru (`A1 §0.4`). ⇒ **`T-334`'ün formül-kanon işinden
farklı bir iş sınıfı**: orada formül metni düzeltiliyordu, burada **kalem doğuruluyor**.

⚠️ Ve `39` bir istisna taşıyor: yalnız doğmamış değil, **iki farklı yoldan iki farklı
sayı** olarak türetiliyor ve biri sessiz sıfır üretiyor. ⇒ **`§2.5` ihlali**, ve bu onu
diğer üçten **daha acil** yapar.

---

## `§6` · ⛔ `ÖLÇEMEDİM`

| # | ölçemediğim | neden | sonucu ne değiştirir |
|---|---|---|---|
| **1** | `.cursor/KPI_Details.docx`'in **`Z67`'nin kastettiği "proje bilgisi" metni OLDUĞU** | Sohbet/proje-bilgisi yüzeyine erişimim yok. Üç bağımsız çakışma var (`§0`) ama **kimlik kanıtı değil** | Başka bir tam metin varsa ve **farklıysa**, `§1` yeniden türetilir |
| **2** | Excel ↔ docx **KÖKEN** bağımsızlığı | İkisi de aynı demo sisteminin (TM1) türevi olabilir (`DEMO_EXCEL §6`) | Yakınsama transkripsiyon hatasını eler, **ortak ata hatasını elemez** |
| **3** | Altı `PSbM` kaleminin **canlı karşılığı** | `VIS_LS`/`DISPLAY_FEE`/`MEC-DISCOUNT` eşlemesi **hiçbir kaynakta yazılı değil**; formüller ayırt etmiyor (`§4e`) | Altı kalemin kovası ve yerleşimi |
| **4** | Kalem `42` (`BaseCOGS`) ve birkaç `eşleşen-doğru` kalemin **bugünkü** doğrulaması | Bu tur yalnız `T-334`'ün dokunduğu kalemleri yeniden ölçtü; gerisinde `A1`'in verdict'i **devralındı** | Kova sayıları ±birkaç kalem |
| **5** | Numaralama eksenli atıfların **tam tutarlılığı** | `§1a` kaynak metnin grup sırasını (`Turnover` önce), `A1` kendi sırasını (`GSV` önce) izliyor ⇒ `50`/`51` gibi numaralar **iki belgede farklı kaleme** düşüyor | ⛔ **Atıf kayması riski** — `§7 S1` |
| **6** | Sapmaların **büyüklüğü** (para etkisi) | `main.plans` **boş** (`Z65 §1b` ölçümü) ⇒ hiçbir sapma bir tutar farkı üretmiyor | Önceliklendirme |
| **7** | `main.kpis`'teki **4 pasif satırın** (`PLAN_TURNOVER` `TACTIC_SPEND` `GP` + …) evrendeki yeri | `is_active=false`; `A1`'de ele alınmamış · `AD-BORCU` ailesine benziyor | Ölü satır mı, ihya adayı mı |
| **8b** | `Planned OPSO Quadrant` (`52`) kovasının **bugünkü** hâli | `Z68` inişi ölçüm anında **çalışma ağacında sürüyordu** (`§4d` kutusu) | `52` `eşleşen-sapmalı`→`eşleşen-doğru` olabilir ⇒ kova sayımı |
| **8** | `main.mechanics`'in **tenant kapsamı** | Sorgu `deleted_at IS NULL` süzdü, `tenant_id` **ayrıştırılmadı** — çok-tenant'lı bir kurulumda `6` eksik olabilir | `§4e`'nin canlı tarafı |

📌 **`ÖLÇEMEDİM` = 9 kalem** (`1`–`8` + `8b`). *"Ölçemedim"* meşru bir çıktıdır; **ölçülmüş gibi yazmak
değildir.**

---

## `§7` · ÜRÜN SAHİBİNE AÇIK SORULAR

### `S1` · ⛔ EVRENİN KİMLİĞİ **NUMARA MI, AD MI?**
`Z67 §2` *"kalem adları kanoniktir"* dedi. Ama `A1`, `A4` ve bu belge **numaralarla**
atıf veriyor (`kalem 22`, `ŞART-6 = 9 12 15 17 18 39`), ve `§1a` kaynak metnin sırasını
izlediğinde **numaralar kaydı** (`§6-5`).

```
(a)  KİMLİK = ID       PlannedIncrPromoGSV      numaralar TAMAMEN düşer, atıflar taşınır
(b)  KİMLİK = numara   A1'in 1..52'si donar     yeni 6 kalem 28..33 alır, 34/35 BOŞ kalır
(c)  yeniden numarala  1..50                    A1/A4/Z62–Z68'in TÜM numaralı atıfları kayar
```
**Önerim `(a)`** — ve gerekçesi `Z69`'un kendi yasası: *bir numara da bir başlıktır.*
⛔ Ama bu bir **ürün sahibi kararıdır**; bu belge `(a)`'yı **uygulamadı**, yalnız
`eski #` sütunuyla **her iki eksende de okunabilir** bıraktı.

### `S2` · ALTI `PSbM` KALEMİ CANLIDA HANGİSİ? *(`§4e`)*
```
VIS_LS        →  MT/PH ve GT'nin BİRLEŞİMİ mi, yoksa yalnız biri mi?
DISPLAY_FEE   →  hangi kanon kalem? (kanonik listede "Display" GEÇMİYOR)
MEC-DISCOUNT  →  PlannedTPRDriveOn mı, PlannedWSTPROn mı? (formülleri AYNI)
```
Cevap gelmeden **altı kalemin kovası atanamaz**, dolayısıyla **yerleşimi de yapılamaz**.

### `S3` · *"Display Fee"* BİR KANON KALEMİ Mİ?
Canlıda **var** (`DISPLAY_FEE` mekaniği), `Section_05`'in yorum satırında **var**,
`KPI_Details.docx` ve Excel `§1`'de **YOK**. ⇒ Evren `50`'de kalır mı, `51` mi olur?
*(Aynı sınıf `TOTAL_PLANNED_LTA` ile — `Q11` orada "kaynağı varsa kalır" dedi.)*

### `S4` · EVREN `49` MU `50` Mİ? *(`§1b`)*
`Q11` hükmü uygulandığında **`50`**. Teyit istiyorum, çünkü ürün sahibinin ön-sayımı
`49`'du ve fark **tam olarak `TOTAL_PLANNED_LTA`**'dır — yani ön-sayım Excel/docx
tabanlıydı, `Q11` ise `Section_05` tabanını da sayıyor.

### `S5` · `Z67 §3`'ün `LTA "(8)"` SATIRI **DÜŞÜYOR** — onay?
Ölçüm `§2b`: bu bir başlık hatası **değil**. `Z67 §3`'ün ilgili satırına `F12` izi
gerekiyor mu, yoksa bu belgenin ölçümü yeterli mi? *(`docs/brd-v2/` **donmuş** — bu belge
oraya **dokunmadı**.)*

### `S6` · `§4d`'nin KARDEŞ-YOLU KİMİN İŞİ?
`lta-calculation.service.ts:258` `T-334` kapsamında **değildi** ve açık kaldı; kodun kendi
yorumu *"iki yüzey iki farklı sayı üretiyor"* diyor. Yeni bir task mı, `T-334`'ün
kapanmamış kalemi mi?

---

## `§8` · BU BELGENİN YAPMADIKLARI

| yapılmadı | nerede yapılacak |
|---|---|
| Altı `PSbM` kalemine kova/yerleşim atanması | `S2` cevabından sonra |
| Numaralama kararının uygulanması | `S1` — ürün sahibi |
| `main.kpis`'in 4 pasif satırının ele alınması | `§6-7` · `AD-BORCU` paketi |
| `lta-calculation.service.ts:258` düzeltmesi | `S6` — **kod işi, bu ajanın işi değil** |
| Sapmaların para etkisi | `main.plans` dolduğunda (`§6-6`) |
