# DEMO EXCEL REFERANSI — KPI Formülleri · Tactic/Mechanic · Statü Akışı

**Kaynak:** `Demo_V2_Work_Orginal.xlsx` (11 sheet; TM1/Planning-Analytics tabanlı demo — `=_xll.SUBNM("Apollo:...")` formülleri) + Promo-Status-Flow şema görseli (ürün sahibi, 2026-08-29)
**Statü: DIŞ-GİRDİ / TARİHSEL-KAYNAK.** Bu belge bir spec DEĞİLDİR — CTPM kavramlarının atası olan demo sisteminin dökümüdür. Formül yazımları hatalar içerir (`[`/`{` karışık paranteziler, ad-tutarsızlıkları); birebir kopyalanmaz, YORUMLANIR. Hiçbir kalemi yerel ölçüm/hüküm olmadan karar taşımaz.
**Okuma tarihi:** 2026-08-29 · Okuyan: Fable (10/11 sheet hücre-düzeyi; `Promo Status Flow` sheet'i boş — çizim; görselden tamamlandı)

---

## 0 · Kavram kökenleri

| CTPM kavramı | Demo'daki kökeni |
|---|---|
| CPL | TM1 boyutu **"Customer Planning Level"** |
| STA/LTA | **"Aggrement Term"** picklist'i: `Short Term / Long Term` |
| Planner | "Sales Team" boyutu |
| Kategori/Kanal | "Promotion Category" / "Customer Channel" boyutları |

---

## 1 · KPI FORMÜL SÖZLÜĞÜ (KPI Formulas sheet — tam liste)

> Grup sayımı (Excel): Master Data 2 · VOLUME 4 · Turnover 4 · GSV 3 · NIV 3 · LTA Spend 7 · Promo Spend by Mechanic 9 · Promo Spend 6 · Gross Profit 5 · Gross Margin 3 · ROI&RAG 3 · Promo Mechanics (girdi) 9

### Master Data
| KPI | ID | Formül/Kaynak |
|---|---|---|
| List Price / piece | `BPTT` | Master Data (piece bazında) |
| COGS / piece | `COGS` | Master Data (piece bazında) |

### VOLUME
| KPI | ID | Formül |
|---|---|---|
| Base Volume | `Baseline` | Master Data (piece) |
| Planned Volume | `PlannedTotalVolume` | `TotalVolUOM × UOMConversionFactor` — kullanıcı UOM girer, sistem piece'e çevirir |
| iVol | `PlannedIncrVol` | `PlannedTotalVolume − Baseline` |
| Volume Uplift % | `PlannedIncrPromoVolPct` | `(PlannedIncrVol / Baseline) × 100` |

### Turnover
| KPI | ID | Formül |
|---|---|---|
| Base TO | `BaseTurnover` | `BaseGSV − BaseTradeSpend` |
| Planned TO | `PlannedPromoTurnover` | `PlannedPromoGSV − PlannedPromoTotalSpend` |
| iTO | `PlannedIncrTO` | `PlannedPromoTurnover − BaseTurnover` |
| TO Uplift % | `PlannedIncrPromoTOPct` | `(PlannedIncrTO / BaseTurnover) × 100` |

### GSV
| KPI | ID | Formül |
|---|---|---|
| Base GSV | `BaseGSV` | `BPTT × Baseline` |
| Planned GSV | `PlannedPromoGSV` | `BPTT × PlannedTotalVolume` |
| iGSV | `PlannedIncrPromoGSV` | `PlannedPromoGSV − BaseGSV` |

### NIV — ⚠️ BRD-42 listesinde bu grup YOK (bkz. §6 soru-1)
| KPI | ID | Formül |
|---|---|---|
| Base NIV | `BaseNIV` | `BaseGSV × (1 − LTAOnPct)` |
| Planned NIV | `PlannedPromoNIV` | `PlannedPromoGSV − PlannedPromoTotalSpendOn` |
| iNIV | `PlannedIncrNIV` | `PlannedPromoNIV − BaseNIV` |

### LTA Spend
| KPI | ID | Formül |
|---|---|---|
| LTA On-Invoice % | `LTAOnPct` | Master Data **veya LTA-promoları üzerinden** |
| LTA Off-Invoice % | `LTAOffPct` | Master Data **veya LTA-promoları üzerinden** |
| Base LTA Spend On | `BaseLTASpendOn` | `LTAOnPct × BaseGSV` |
| Base LTA Spend Off | `BaseLTASpendOff` | `LTAOffPct × BaseNIV` |
| Planned LTA Spend On | `PlannedPromoLTAOnInvoice` | `LTAOnPct × PlannedPromoGSV / 100` *(yazım: `[...]/100`)* |
| Planned LTA Spend Off | `PlannedPromoLTAOffInvoice` | `LTAOffPct × PlannedPromoNIV / 100` *(yazımda `{`-hatası mevcut)* |
| Total Base Spend | `BaseTradeSpend` | `BaseLTASpendOn + BaseLTASpendOff` |

### Promo Spend by Mechanic — ⭐ TABAN HİYERARŞİSİ
| KPI | ID | Formül |
|---|---|---|
| CPP On-invoice% Spend | `PlannedCPPOn` | `(PlannedPromoGSV − PlannedPromoLTAOnInvoice) × CPPOnInvoicePCT / 100` |
| CPP Off-invoice% Spend | `PlannedCPPOff` | `PlannedPromoNIV × CPPOffInvoicePCT / 100` |
| Price Support per Unit Spend | `PlannedPriceSupport` | `PriceSupportperPiece × EffectiveTotalIMSVolumePC` |
| Visibility Lumpsum MT/PH | `PlannedVisibilityMTPH` | `VisibilityMTPH` (doğrudan tutar) |
| Visibility Lumpsum GT | `PlannedVisibilityGT` | `VisibilityGT` (doğrudan tutar) |
| Drive/TPR On-invoice% Spend | `PlannedTPRDriveOn` | `(PlannedPromoGSV − PlannedPromoLTAOnInvoice) × DriveTPROnInvoicePCT / 100` |
| TPR/Drives Lumpsum Spend | `PlannedTPRDriveLumpsum` | `TPRDriveLumpsum` (doğrudan tutar) |
| WS TPR On-invoice% Spend | `PlannedWSTPROn` | `(PlannedPromoGSV − PlannedPromoLTAOnInvoice) × WSTPROnInvoicePCT / 100` |
| WS TPR Off-invoice% Spend | `PlannedWSTPROff` | `PlannedPromoNIV × WSTPROffInvoicePCT / 100` |

**Taban kuralı:** On-invoice %-mekanikleri → `(GSV − LTA_On)` üzerinden · Off-invoice %-mekanikleri → `NIV` üzerinden · Lumpsum → doğrudan · Per-unit → `rate × sell-out-hacim`.
**⇒ LTA oranı, promo-mekaniklerinin hesap-tabanına girer.** `LTAOnPct`'nin sessiz-0 düşmesi (T-291 sınıfı) çift-yönlü bozar: LTA-harcaması küçülür **ve** on-invoice mekanik-tabanı büyür.

### Promo Spend (toplamlar)
| KPI | ID | Formül |
|---|---|---|
| Planned Promo Spend On | `PlannedOnIInvoiceDiscounts` | `PlannedCPPOn + PlannedTPRDriveOn + PlannedWSTPROn` |
| Planned Promo Spend Off | `PlannedOffIInvoiceDiscounts` | `PlannedCPPOff + PlannedPriceSupport + PlannedVisibilityMTPH + PlannedVisibilityGT + PlannedTPRDriveLumpsum + PlannedWSTPROff` *(sheet'te 80-karakter kesikti; bileşim off-invoice kalemlerinin toplamı)* |
| Total Planned Spend On | `PlannedPromoTotalSpendOn` | `PlannedOnIInvoiceDiscounts + PlannedPromoLTAOnInvoice` |
| Total Planned Spend Off | `PlannedPromoTotalSpendOff` | `PlannedOffIInvoiceDiscounts + PlannedPromoLTAOffInvoice` |
| Total Planned Spend | `PlannedPromoTotalSpend` | `On + Off` |
| Incremental Planned Spend | `PlannedIncrPromoSpend` | `PlannedPromoTotalSpend − BaseTradeSpend` — not: **"Excl. BMI"** |

### Gross Profit — ⚠️ sell-out hacmi kullanır (bkz. §6 soru-2)
| KPI | ID | Formül |
|---|---|---|
| Base COGS | `BaseCOGS` | `COGS × Baseline` |
| Planned COGS | `PlannedCOGS` | `COGS × EffectiveTotalIMSVolumePC` ← **IMS/sell-out hacmi; tanımı sheet'te YOK** |
| Base Gross Profit | `BaseGrossProfit` | `BaseTurnover − BaseCOGS` |
| Planned Gross Profit | `PlannedPromoGrossProfit` | `PlannedPromoTurnover − PlannedCOGS` |
| iGross Profit | `PlannedIncrPromoGP` | `Planned − Base` |

### Gross Margin
| KPI | ID | Formül |
|---|---|---|
| Base GM % | `BaseGrossMarginPct` | `(BaseGrossProfit / BaseTurnover) × 100` |
| Planned GM % | `PlannedPromoGrossMarginPct` | `(PlannedPromoGrossProfit / PlannedPromoTurnover) × 100` |
| iGM % | `PlannedIncrPromoGM` | `(PlannedIncrPromoGP / PlannedIncrTO) × 100` |

### ROI & RAG
| KPI | ID | Formül |
|---|---|---|
| Planned TO ROI % | `PlannedPromoROITO` | `(PlannedIncrTO / PlannedIncrPromoSpendTTS) × 100` ← **payda "TTS"-ekli; tanımlı kalem `PlannedIncrPromoSpend` — ad-tutarsızlığı Excel'in kendi içinde** |
| Planned GP ROI % | `PlannedPromoROIGP` | `(PlannedIncrPromoGP / PlannedIncrPromoSpendTTS) × 100` |
| RAG Status | `PlannedOPSOQuadrant` | **Red:** `iTO ≤ 0` · **Amber:** `iTO > 0 ∧ iGP ≤ 0` · **Green:** `iTO > 0 ∧ iGP > 0` |

### Promo Mechanics (kullanıcı girdileri — 9)
`CPPOnInvoicePCT · CPPOffInvoicePCT · PriceSupportperPiece · VisibilityMTPH · VisibilityGT · DriveTPROnInvoicePCT · TPRDriveLumpsum · WSTPROnInvoicePCT · WSTPROffInvoicePCT` — hepsi "promotion plan ekranında kullanıcı girer".

---

## 2 · TACTIC / MECHANIC KANONİK TABLOSU (Sayfa5)

| Tactic (kullanıcı-görünür) | Mechanic (aile) | Spending Type | Calc Type |
|---|---|---|---|
| CPP On-invoice% | CPPON | On-Invoice | Rate Based (%) |
| CPP Off-invoice% | CPPOFF | Off-Invoice | Rate Based (%) |
| Price Support per Unit | CPPOFF | Off-Invoice | Rate Based (**per-unit**) |
| Visibility Lumpsum MT/PH | VisibilityMTPH | Off-Invoice | Lumpsum |
| Visibility Lumpsum GT | VisibilityGT | Off-Invoice | Lumpsum |
| Drive/TPR On-invoice% | DriveTPR | On-Invoice | Rate Based (%) |
| TPR/Drives Lumpsum | DriveTPR | Off-Invoice | Lumpsum |
| WS TPR On-invoice% | WSTPR | On-Invoice | Rate Based (%) |
| WS TPR Off-invoice% | WSTPR | Off-Invoice | Rate Based (%) |

**Yapı:** 9 tactic → 6 mekanik ailesi. Tactic'in karakteri = `mechanic + spending-type + calc-type` üçlüsü. **"Rate Based" iki alt-tip taşır:** %-rate (taban-üstünden) ve per-unit-rate (hacim-üstünden) — motor tasarımında ayrı ele alınmalı.

**Grid'deki yaşam biçimi (Short Term Promotion Plan sheet):** mekanikler *instance* olarak sütunlaşır (`M-123/M-124/M-125`, Add/Delete düğmeleri); her instance başlığı: M-ID → mechanic → invoice-yönü → calc-tipi → tactic-adı; **değerler SKU-satırı düzeyinde farklılaşabilir** (aynı mekanik R15'te 0.16, R14'te 0.18). ⇒ Mekanik değeri plan-başlığının değil, plan-satırının özniteliğidir.

---

## 3 · AGREGASYON SEMANTİĞİ (List View, R14 işaretleri)

Promo-listesi kolonlarının toplam-satırı davranışı Excel'de kalem kalem işaretli:
- **SUM (toplanabilir):** hacimler, GSV/NIV/TO mutlakları, tüm spend kalemleri, GP mutlakları
- **Formula (toplanamaz — yeniden hesaplanır):** `Volume Uplift %` · `TO Uplift %` · `iGM %` · `TO ROI %` · `GP ROI %` · `RAG Status`
- **Not required:** `LTA On-Invoice %` · `LTA Off-Invoice %` (oran kolonları toplam satırında anlamsız)

⇒ **Faz-2 KPI-agregasyon doğrulamasının hazır kabul-kriteri:** oranlar SUM'lanmaz; toplam-satırda bileşenlerden yeniden hesaplanır.

---

## 4 · PROMO STATÜ AKIŞI (görselden + Audit Trail teyidi)

```
Draft ──→ Planned ──→ Submitted-for-Approval(CM) ──→ Approved ──auto──→ Ongoing ──auto──→ Complete·END
  │           │              │        │        │
  │           │              │        ├→ Rejected·END
  │           │              │        └→ Incomplete·END   (CM eksik bulur)
  │           └→ Cancelled·END
  │                          └──→ Planned'e GERİ
  ├─(kesikli)→ Deletion-from-System·END   "promo statüsü DEĞİL — verinin tam silinmesi" (yalnız Draft)
  └─(kesikli)→ Simulate ×3 (Realistic/Aggressive/Conservative) ─(kesikli)→ Planned/Cancelled/Incomplete
```

- **Otomatik geçişler:** `Approved→Ongoing` ve `Ongoing→Complete` sistem-üretimi ("Auto Status Change by TPM System"; Audit Trail'de aktör = `System Generated`) — tarih-tetikli.
- **Promo locking lead time:** Approved'dan geri yollar yalnız kilit-süresi **öncesi** açık.
- **Approved→Planned dönüşü:** Planner onay-zincirini yeniden yönlendirir ya da iptal eder (şema dip-notu).
- **Approved → Cancelled:** iptal hattının kaynağı Approved [ürün sahibi teyidi, 2026-08-29] — "locking lead time" notuyla tutarlı: kilit-öncesi Approved iptal edilebilir.

### CTPM fark tablosu (6 kalem)
| # | Demo kavramı | CTPM bugünü | Not |
|---|---|---|---|
| 1 | `Planned` ara-durumu | yok (DRAFT→onay) | "hazır ama gönderilmedi" katmanı — senaryo-eşlemesinde karar |
| 2 | `Ongoing/Complete` (tarih-tetikli, auto) | yok (APPROVED son) | zamanlayıcı-dalgasının 2. müşterisi (7/14-gün bildirimlerinin yanı) |
| 3 | `Incomplete` (END) | return-to-draft (yaşar) | END-oluşu bilinçli fark mı? |
| 4 | promo locking lead time | yok | zaman-bazlı kilit — yeni kontrol ekseni |
| 5 | Draft-silme = fiziksel silme | ölçülmeli | ADR-0012 ile uyumlu okunabilir: finansal iz doğmadan silme |
| 6 | Simülasyon ×3 (araç, durum değil) | yok | BRD'de karşılığı taranacak [VARSAYIM]; muhtemelen Faz-3 aday |

---

## 5 · FUND UTILIZATION MODELİ

Eksen: `Category × SubCategory × FundType × Ay` — **FundType = mekanik-ailesi** (`CPPON`, `CPPOFF`, ...).
Kolonlar: `Current Fund · Selected Promotions' Planned Spend · Remaining Budget in Fund · Additional Budget Required · Net Required Budget` (roundup/rounddown formüllü).

⇒ CTPM zarfları kategori/kanal-bazlı; **mekanik-bazlı fon-ekseni bizde yok** — model farkı, kusur değil; Faz-2'de bilinçli karar ister (variance-analysis'in atası da bu rapor).

---

## 6 · W2-EŞLEME EVRENİNE ETKİ — AÇIK SORULAR

**Eşleme artık ÜÇ-KAYNAKLI:** Excel-listesi (~60 kalem, formüllü) ↔ BRD-§5.3 (42 grup-kalemi) ↔ canlı (24 aktif). Excel muhtemelen BRD-listesinin atasıdır.

1. **NIV grubu** — **KAPANDI [2026-08-29, ürün sahibi]:** düşüş bilinçli DEĞİLDİ; "hesaplamada sorun yoksa KPI'ların tamamı dikkate alınabilir." ⇒ **HÜKÜM KESİN: eşleme-evreni 52** (11 grup). Section_05 F12-düzeltmesi (42→52) W2'de; yerleşim (Faz-2-şart/aday/Faz-3) süzgeçten geçer — "tamamı dikkate alınabilir" ≠ "tamamı Faz-2-şart". Canlı-motor off-invoice-tabanı kod-ölçümü W2'nin ilk maddesi olarak kalır.
   ~~ARA-BULGU: kaynak-zincir…~~ *(hükme dönüştü; zincir-kanıtı: KPI-Library/A1 52 kalem, NIV+TO+GM dahil; 42'nin LTA/ROI formülleri bu gruplara bağımlıydı.)*
2. **Sell-in / sell-out ayrımı:** GSV sell-in hacmiyle (`PlannedTotalVolume`), Planned-COGS sell-out hacmiyle (`EffectiveTotalIMSVolumePC`) hesaplanıyor; tarih alanları da çift (Sell-In/Out Start/End). CTPM-motorunda bu ayrım var mı? **AÇIK-SORU [2026-08-29]:** `EffectiveTotalIMSVolumePC`'nin TM1-kaynağı ürün sahibince sonra cevaplanacak — o güne kadar per-unit mekanik (`PlannedPriceSupport`) ve `PlannedCOGS` formülleri W2-eşlemesinde **kaynağı-belirsiz-girdi** statüsü taşır; motor-bağı tasarımı bu iki kalemde sell-in-hacmini geçici vekil sayamaz (sessiz-ikame yasağı).
3. **ROI paydası — KAPANDI [2026-08-29, ürün sahibi]:** payda **yalnız promo-spend** (LTA hariç) — ama **tenant'a göre değişebilir.** ⇒ Tasarım-girdisi: ROI-payda tanımı motorda SABİTLENMEZ — tek noktadan okunan, tenant-düzeyi konfigüre edilebilir bir politika kalemidir (K-2.2.8-ailesi deseni). Faz-2 süzgeci: tek-tenant dünyada varsayılan "yalnız promo-spend" inşa edilir; konfigürasyon-yüzeyi olay-tetikli bekler (tetikleyici: ikinci tenant'ın farklı payda talebi). Ad-tutarsızlığı (`…TTS` vs tanımlı `PlannedIncrPromoSpend`) eşlemede F12-notu alır.
4. **"Excl. BMI" — KAPANDI [2026-08-29, ürün sahibi]:** BMI (Brand Marketing Investment) **şimdilik kapsam-DIŞI tutulur** — CTPM'de karşılığı inşa edilmez; "Excl. BMI" şerhi formül-eşlemesinde korunur (Incremental-Spend kaleminin tanım-sınırı olarak).
5. **Mekanik-değerinin SKU-düzeyi yaşaması** (§2) — CTPM'de mekanik nerede yaşıyor (plan-başlık mı satır mı)? Motor-bağı tasarımına girdi.

---

## 7 · SENARYO-TOHUMLARI (Faz-2 W1 listesine ek)

- **SC-mech-1:** aynı mekanik, iki SKU'da farklı rate → spend-kalemleri satır-bazında ayrışır (AYIRT-EDİCİ: satır-düzeyi değer ≠ başlık-düzeyi değer)
- **SC-lta-taban:** LTA'lı vs LTA'sız dünyada aynı on-invoice mekanik → taban `(GSV−LTA_On)` farkı ölçülür (AYIRT-EDİCİ: `||0`-dünyası ile doğru-dünya farklı spend üretir — T-291/T-293 pininin senaryo hali)
- **SC-agg-1:** çok-promolu listede toplam-satır → SUM-kolonları toplanır, Formula-kolonları yeniden hesaplanır (AYIRT-EDİCİ: ROI'nin toplamı ≠ toplamların ROI'si)

---

*Bu belge W2-eşleme dalgasının zorunlu okuma listesindedir. Eşleme çıktısı bu belgenin §6 sorularına cevap vermeden kapanmaz.*

---

## 8 · TTM ELIGIBILITY ENVANTERİ — özet (T-345, 2026-08-31)

**Tam belge:** `docs/research/TTM_ELIGIBILITY_ENVANTERI.md` (dosya:satır kanıtlı).
**Statü: DIŞ-GİRDİ.** TTM dondurulmuştur (`ADR 0001`); davranışı bir **girdidir**, kanıt değil
(`CLAUDE.md §2.1.2`). Bu tur TTM'e **tek bayt yazmadı** (temizlik kanıtı: envanter `§8`).

**Veri modeli.** Ayrı bir `kategori × CPL × tactic` eşleşme tablosu **YOK**. Uygunluk
`tactic_definitions` satırının **kendi kolonlarında** taşınıyor: `cpl_id` (tekil) ·
`applicable_channels[]` · `applicable_categories[]` — üçünde de `NULL`/boş = **wildcard**.
Yazma yolu **iki tane** ve ikisi çelişiyor: **seed** üç uygunluk kolonuna **hiç dokunmuyor**,
**admin CSV upsert** (`POST /admin/master-data/tactics/csv`) dokunuyor. Tekil CRUD ucu yok.

**Grid kolonları.** Statik liste değil — DB'den türetiliyor: `tactic_definitions` →
`show_in_grid` + kanal + kategori SQL filtresi → `GridTactic[]` → her tactic **bir kolon**.
⛔ Ama **aynı uygunluk kuralının ALTI ayrı implementasyonu** var, **üç farklı eksen kümesiyle**;
ikisi bayt-kopya. Plan-grid yolu `cpl_id`'yi **hiç sormuyor**, anlaşma yolu **reddediyor** —
yani bir tactic grid'de kolon olarak çıkıp anlaşmada `TACTIC_NOT_ELIGIBLE_FOR_AGREEMENT` alabilir.

**⛔ Mekanik değer girişi — `§2`/`§6-5` ile ÇELİŞİYOR.** Excel: değer **SKU-satırı**
özniteliği (aynı mekanik R14'te 0.18, R15'te 0.16). TTM: değer **FU düzeyinde** yaşıyor;
SKU satırında mekanik hücreleri **salt-okunur tire**. `tactic_values.sku_id` kolonu ve FK'si
**duruyor ama hiç yazılmıyor** — şema hazır, yol açılmamış. CTPM de bugün FU düzeyinde
(`editableAt: 'FU'`). **Hangisinin doğru olduğuna karar verilmedi** — `§6` kalem 5'in cevabı
hâlâ ürün sahibindedir.

**Çeviri.** ✅ *Deseni alınır:* wildcard uygunluk modeli · açık `…_NOT_ELIGIBLE…` **reddi**
(sessiz filtreleme değil) · kolonların DB'den türetilmesi · CSV'nin satır-satır doğrulama+`errors[]`
deseni. ⛔ *Mimarisi alınmaz:* calc-type'ı **kod sonekinden** türetmek (`endsWith('_LS')`) ·
`calculation_type`ın yalnız frontend tipinde yaşaması · frontend'e gömülü fallback tactic katalogu ·
**üç ayrı sessiz sıfır** (`?? 0`, ve `PLANNED_LTA_ON: 0` — bu belgenin `§1` "taban kuralı"nı
çift yönlü bozar) · altı kopya · Next.js yapısı · ham-SQL/entity'siz katman.
**KORUNUR:** KPI formüllerinin DB'den okunup değerlendirilmesi (TTM'de de böyle).

**CTPM karşılığı — 19 kalem: 11 tam · 3 kısmi · 3 yok · 2 ölçülemedi.**
Sözlük farkı: TTM'in tek `tactic_definitions` tablosu CTPM'de **`tactics` + `mechanics`** diye
bölünmüş. CTPM şeması TTM'in **üst kümesi** (`applicableCpls` **çoklu**, `exclusionRules`,
`mutuallyExclusiveWith`, `gridColumnOrder`/`groupHeader`, `MechanicCategory`).
⇒ **Bu bir port değil, bir BAĞLAMA işi.**

⛔ **İki repoda da AYNI kör nokta — "verinin yokluğu örter" (`CLAUDE.md §2.7`):**
- TTM: hiçbir seed uygunluk kolonlarını yazmıyor ⇒ **UAT'de bu filtreler hiç ayırt etmedi.**
- CTPM canlı DB: `main.mechanics` 6 satır · `main.tactics` 5 satır — `applicable_channels`,
  `applicable_categories`, `applicable_cpls`, `exclusion_rules` **hepsi NULL.**
- CTPM frontend: `getApplicable` ucu **tanımlı, çağıranı SIFIR**; planlama grid'i onun yerine
  `getAll` çağırıp `// TODO: Implement applicability rules check` ile yalnız `isActive`
  bakıyor, ve `catch { return [] }` ile hatayı yutuyor — *mekanizma var, yol yok.*

⇒ Faz-2'de bu yolun kabul-kriteri bir **fixture**tır: uygunluğun **iki tarafında FARKLI**
değer taşıyan veri. Aksi hâlde her ölçüm yeşil çıkar ve hiçbir şey kanıtlamaz.

**Yeni senaryo-tohumları (`§7` listesine ek):**
- **SC-elig-1:** CPL-X'e kısıtlı bir tactic, CPL-Y planında → grid'de kolon **çıkmamalı**
  (AYIRT-EDİCİ: TTM'de çıkıyor, anlaşmada reddediliyor)
- **SC-elig-2:** kategori adı farklı harf büyüklüğüyle → SQL tam-eşleşme ↔ istemci
  case-insensitive (AYIRT-EDİCİ: aynı veri iki katmanda farklı sınıflanıyor)
- **SC-elig-3:** wildcard (`NULL`) tactic ile kısıtlı tactic aynı planda → ikisi **farklı**
  davranmalı (bugün her ikisi de wildcard olduğu için ayrım ölçülemiyor)
