# 0019 — Bağlayıcı BRD okuma turu **1**: Section 12 (Glossary)

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur. Kod / migration / entity değişikliği YOK.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_12_Glossary.md` ([[ADR 0010]] uyarınca bağlayıcı)
- **Ölçüm ortamı:** meta `36c5df9` · backend `99ee9e6` · dev DB `main`, port 5434 (ayakta)

---

## 0. Bu turda ne OKUNDU, ne OKUNMADI

Bu ayrım bu turun kendi dersidir — [[T-142]] kısmi bir okumayı tam sanma riskini gösterdi.

| | |
|---|---|
| ✅ **Okundu (tam)** | `Section_12_Glossary.md` — **729 satır, tamamı.** 28 terim tanımı. |
| ⛔ **Okunmadı** | Diğer **on bir bölüm** (~9.900 satır) · `02_Addendum` (1.153) · `03_Candidate_Log`'un gövdesi (674, yalnız başlıkları + terim taraması yapıldı) |
| 📊 **Yalnız sayıldı, okunmadı** | Önceki turlarda yapılan terim taramaları — **varlık ölçümüdür, içerik iddiası değil** |

**Neden Glossary ilk:** BRD'nin kendi kavram tanımlarıdır — *"single source of truth for
discussions"* diyor. Yani Çıktı 1'in (kapsam envanteri) **BRD tarafındaki dayanağı**.

⚠️ **Bu turun bulguları Glossary'ye dayanır ve Glossary bir ÖZETTİR.** Bir terimin burada
tanımlanmış olması normatiftir; **tanımlanmamış olması, BRD'de yok demek değildir** — başka
bölümde olabilir. Bu doküman hiçbir yerde "BRD'de yok" demiyor.

---

## 1. Çıktı 1 — Kapsam envanteri (Glossary tarafı)

Görevin adlandırdığı sekiz terim, Glossary'de **tanımlı mı**:

| Terim | Glossary'de | Not |
|---|---|---|
| `baseline` | ✅ **tanımlı** — *"Baseline (Baseline Volume)"* | Ve **normatif bir kapı** taşıyor (§1.1) |
| `incrementality` | ✅ *"Incremental Volume"* + *"Uplift %"* | Formülleriyle |
| `settlement` | ⚠️ **başlık olarak yok** — yalnız LTA örneğinde geçiyor (*"Settlement: Quarterly"*) | Tanımlanmış bir kavram **değil** |
| `claim` | ❌ yok | — |
| `accrual` | ❌ yok | — |
| `deduction` | ⚠️ yalnız Off-Invoice tanımının içinde bir **örnek** olarak (*"credit note, bank transfer, deduction"*) | Tanımlanmış kavram değil |
| `reconciliation` | ❌ yok | — |
| `gross-to-net` | ❌ yok | — |

### Niyet ayrımı — Glossary bu soruyu **cevaplamıyor**

`.cursor/` PDF'i actuals'ı *"out of scope for Phase 1"* diye **açıkça** dışlamıştı. Glossary'de
buna denk bir ifade **aranmadı ve aranamaz**: bir sözlük kapsam beyanı yapmaz.

⛔ **Niyet ayrımı (faz dışı mı, hiç düşünülmemiş mi) `Section_10_Roadmap` ve
`Section_11_Assumptions_Risks` okunmadan cevaplanamaz.** Bu turda **açık kalıyor.**

Tek ipucu — ve yalnız ipucu: `GU (Group Unit)` tanımında *"Optional in **Phase 1**"*,
`Budget Envelope`'ta *"Dimensions (**Phase 1**)"* ifadeleri var. Yani paket faz dili
kullanıyor; kapsam beyanlarının nerede olduğu bulunmalı.

---

## 2. Çıktı 2 — Katman A: BRD ↔ kod (bu turda ölçülen dört madde)

### 2.1 🔴 **SAPMA — Bütçe RAG sınır semantiği**

CLAUDE.md §2.3 bunu **çözülmemiş** diye kaydediyordu: *"sınır semantiği (`>95` mi `>=95` mi)
çözülmemiştir."*

**Glossary cevaplıyor:**

```
🟢 Green: <80% utilization
🟡 Amber: 80-95% utilization
🔴 Red:   >95% utilization          ← ">" açık ve tartışmasız
```

**Kod** (`budget-threshold.service.ts`, `classify` bloğu):

```
percent <  warning              → GREEN
warning <= percent < critical   → AMBER
percent >= critical             → RED          ← ">=" 
```

| Değer | BRD | Kod |
|---|---|---|
| %94,9 | AMBER | AMBER |
| **%95,0** | **AMBER** (`>95` değil) | **RED** (`>= 95`) |
| %95,1 | RED | RED |

**Tam sınırda bir kova farkı.** Etkisi: %95,00 kullanımda BRD sarı der, ürün kırmızı gösterir.

> **CLAUDE.md §2.3'ün açık bıraktığı soru bir ürün belirsizliği değildi — cevabı bağlayıcı
> kaynakta yazıyordu ve o kaynağa altı aydır bakılmamıştı.**

### 2.2 🟡 **AÇIK — dördüncü kova (`EXCEEDED_100`) Glossary'de yok**

Kodda dört eşik var (`warning: 80, critical: 95, exceeded: 100`) ve `AlertLevel.EXCEEDED_100`
enum üyesi. CLAUDE.md §2.3 de *"%100+ Exceeded"* diyor.

**Glossary üç durum sayıyor: Green / Amber / Red.** Dördüncüsü yok.

⚠️ **Bu "BRD'de yok" DEĞİLDİR** — Glossary bir sözlüktür, `Section_03` ya da `Section_05`'te
olabilir. **Ölçülmedi.** Kayda geçer, sonraki turda aranır.

### 2.3 ✅ **UYUMLU — GP ROI RAG eşikleri**

| | Yeşil | Amber |
|---|---|---|
| BRD Glossary | ≥20% | 10–20% |
| Kod (`kpi.seed.ts`) | `ragGreenThreshold: 20` | — |
| **DB** (`main.kpis`, ölçüldü) | `GP_ROI_PCT: green=20.0000` | `amber=10.0000` |

Birebir uyumlu, **ve konfigürasyondan okunuyor** (BRD: *"Thresholds (Configurable)"*) — yani
§2.3'ün *"hardcoded threshold YASAK"* kuralı burada **sağlanıyor**.

⚠️ Karşıtlık kayda değer: aynı ürün, iki RAG. **KPI RAG'ı konfigüre edilebilir ve BRD'ye
uygun; bütçe RAG'ı sınırda sapıyor ve dördüncü kovası kaynaksız.**

### 2.4 🟡 **MODEL FARKI — tek ledger vs iki tablo**

Glossary `Ledger` için **beş** işlem tipi sayıyor:
`ALLOCATE · RESERVE · COMMIT · CONSUME · RELEASE`

Kodun `BudgetTransactionType` enum'u **altı** üye taşıyor:
`ALLOCATE · COMMIT · RESERVE · RELEASE · TRANSFER · ADJUST`

İki fark, ve ikisi de yön olarak farklı:

- **Kodda `CONSUME` YOK.** Tüketim ayrı bir tabloda (`ledger_entries`, `entry_direction`
  DEBIT/CREDIT) izleniyor.
- **BRD'de `TRANSFER` ve `ADJUST` yok** — kodda var.

> BRD **tek bir ledger** anlatıyor; ürün **iki tablo** kullanıyor (`budget_transactions` +
> `ledger_entries`). Bu bir kusur iddiası **değildir** — model farkıdır ve gerekçesi
> olabilir. Ama gerekçe **hiçbir yerde yazılı değil**, çünkü BRD hiç okunmamıştı.

⚠️ Bu, `INV-L-*` ailesinin (yedi invariant) dayandığı modelin BRD ile karşılaştırılmamış
olduğu anlamına gelir. **Ayrı ölçüm gerekir** — `Section_04`'ün *"Ledger Posting"* bölümü
okunmadan karara bağlanamaz.

### 2.5 📌 Glossary'nin **D-01'e** verdiği cevap (kayda geçer, doğrulanmadı)

`Cap` tanımı: *"**Cap Breach:** When consumed amount exceeds cap (alert triggered, **requires
Finance override**)."*

`SYSTEM_INVARIANTS §9` **D-01** (CAP aşım davranışı) üç varyant sayıyor: TTM skip · K43-R clamp ·
CTPM reject. **Glossary dördüncüsünü söylüyor: uyarı + Finance override.**

⛔ **DUR koşulu — kayda geçiyorum, karara bağlamıyorum.** D-01'in önerisi
(*"off-invoice clamps, on-invoice always posts"*) bu ifadeyle **çelişebilir**. Ama bir
sözlük maddesi bir davranış spesifikasyonu değildir; `Section_04`'ün cap bölümü okunmalı.

---

## 3. Çıktı 3 — Karar envanteri

### 3.0 ⚠️ Filtre düzeltildi: ayrım gerekçenin VARLIĞI değil, TÜRÜ ve MALİYETİ

Bu bölümün ilk hâli *"gerekçesi yazılı → danışmana sorulmaz"* diyordu. **Yanlış** — ve bu
oturumun sekiz kez belgelediği sınıfın kendisi: gerekçenin varlığını doğruluğu sanmak.

Ölçülmüş karşı örnekler, hepsi gerekçeliydi ve hepsi yanlıştı:

| yazılı gerekçe | ölçüm |
|---|---|
| *"performans için boş satırları atla"* | ters çıktı |
| *"prototype pollution için `defval: false`"* | ilgisi yoktu |
| *"tarayıcı virgülü reddediyor"* | reddetmiyordu |
| *"veritabanından ulaşılamaz"* | ulaşılabiliyordu |
| *"context, which the logger prints"* | basmıyordu |

Bazılarında gerekçe **kusuru sorgudan korudu** — yani gerekçeli olmak riski *artırdı*.

> **Ve BRD'ninki daha risklidir:** koddaki bir gerekçe **ölçülebilir**. BRD'nin domain
> gerekçesi ölçülemez — tam da danışmanın alanı.

**Doğru filtre — iki şart birlikte:**

1. Gerekçe bir **domain iddiası** mı? (teknik ya da kapsam değil)
2. **Yanlış olması pahalı mı?** (mimariye gömülü, geri dönüşü zor)

İkinci şart eleyicidir: bir ekran yerleşimi yanlışsa değiştirilir; *FU seviyesinde tactic
girme* kararı yanlışsa **veri modeli** değişir.

| Gerekçe türü | Kim doğrular | Danışmana |
|---|---|---|
| Teknik / ölçülebilir | **biz** — ölçeriz | hayır |
| Kapsam / faz | **ürün sahibi** | hayır |
| **Domain iddiası** (yazılı **veya** yazısız) | **danışman** | **evet — pahalıysa** |
| Wella'dan gelmiş (K1-K45) | önce *tenant mı ürün mü* | belki |

⚠️ Ve gerekçeli olan, danışman için **daha değerlidir**: gerekçesiz bir karar için soru
*"neden böyle?"* olur — zayıf. Gerekçeli olan için *"bu gerekçe tutuyor mu?"* — güçlü ve
cevaplanabilir.

### 3.1 Bu turdan çıkan kararlar, yeni filtreyle

| # | Karar | Gerekçe türü | Maliyet | Danışmana |
|---|---|---|---|---|
| 1 | **Mod kullanıcı seçimi DEĞİL, bağlamla çözülür** — dört faktör sayılı (tactic uygunluğu, baseline varlığı, kanal olgunluğu, kullanıcı akışı) | **domain** | **çok yüksek** — `modes/planning-first` ↔ `modes/actuals-first` modül sınırı; resolver mı toggle mı yapısal karar | ✅ **EVET** |
| 2 | **Tactic FU seviyesinde, hacim SKU seviyesinde** girilir | **domain** | **çok yüksek** — grid, veri modeli, miras kuralı | ✅ **EVET** |
| 3 | **CAP aşımı → uyarı + Finance override** | **domain** | **yüksek** — D-01 iki invariantı blokluyor, davranış harcama yolunda gömülü | ✅ **EVET** |
| 4 | **Baseline ≥%95 SKU kapsama** onay kapısı | **domain** | **orta** — kapının *varlığı* mimari, *sayısı* konfigürasyon | ✅ **EVET** (kapının varlığı; sayı değil) |
| 5 | **GP ROI ≥20 yeşil / 10-20 amber** | domain | **düşük** — konfigüre edilebilir, DB'den okunuyor | ❌ hayır |
| 6 | **Bütçe RAG 80 / 95** ve sınır semantiği | sınır: **teknik** · sayılar: domain | **düşük** — konfigürasyon | ❌ hayır — [[T-144]] |
| 7 | Dördüncü kova (`exceeded 100`) | **kaynağı bilinmiyor** | düşük | ⏸️ önce kaynağı bulunsun |
| 8 | `TRANSFER` / `ADJUST` işlem tipleri | BRD'de yok, kodda var | orta | 🟡 **belki** — önce *tenant mı ürün mü* ([[T-145]]) |
| 9 | Tek ledger vs iki tablo | **teknik** | yüksek | ❌ hayır — bizim ölçümümüz ([[T-145]]) |

**Danışman kuyruğuna bu turdan dört aday girdi** (1-4). 10-15 soru sınırı içinde;
sonraki turlar aynı filtreyle ekleyecek.

⚠️ **Sıralama notu:** 1 ve 2 en pahalıları ve **ikisi de Glossary'den geldi** — yani en
maliyetli iki domain kararı, BRD'nin *sözlüğünde* duruyordu. Davranış bölümleri
(`Section_04`/`Section_05`) henüz okunmadı; bu kuyruğun büyümesi beklenir.

## 4. Çıktı 4 — Görsel envanteri (Glossary'den)

Glossary **diyagram içermiyor.** Biçim envanteri:

| Biçim | Adet | Örnek |
|---|---|---|
| Fenced kod bloğu (örnek/hesap) | **26** | `Baseline Volume: 1,000 units` |
| Formül bloğu | 6 | `GP ROI % = (Incremental GP / Total Planned Spend) × 100` |
| Hiyerarşi metni | 2 | `GU > FU > SKU` |
| Durum listesi | 3 | Ledger durumları, RAG kovaları, Agreement lifecycle |
| ASCII diyagram / mermaid / tablo | **0** | — |

**Sonuç (yalnız bu bölüm için):** Glossary'de yeniden çizilecek bir görsel **yok**; ama
`Agreement Lifecycle` (`Draft → Pending → Approved → Active → Closed`) ve `Ledger` durum
geçişleri **state machine olarak çizilmeye hazır** — metin hâlinde tanımlı.

⚠️ Görsel envanterinin asıl gövdesi `Section_04`/`Section_05`'te: önceki turda oradan geçerken
**ASCII ekran taslakları** ve **kutu-çizgi akışları** görülmüştü. **Sayılmadı.**

---

## 5. DUR koşulları

| Koşul | Durum |
|---|---|
| Bir bölüm mevcut bir ADR'yi çürütüyor mu | ❌ **hayır** — hiçbir ADR çürümedi. **Ama** D-01 (henüz ADR değil) ve CLAUDE.md §2.3 etkilendi |
| `02_Addendum` kodla geniş çaplı çelişiyor mu | ⏭️ **ölçülmedi** — Addendum okunmadı |
| Candidate Log bugün verilmiş bir kararı erteliyor mu | ✅ önceki turda ölçüldü, **temiz** (`T-143` notu) |

---

## 6. Sonraki tur

1. `Section_04_Actuals_First_Mode.md` (2038) — Ledger Posting · Cap · Settlement bölümleri;
   §2.4 ve §2.5 bu bölüme bağlı
2. `02_Addendum` (1153) — beş HIGH PRIORITY maddesi, **kodda karşılığı hiç sorulmadı**
3. `Section_10_Roadmap` + `Section_11_Assumptions_Risks` — **niyet ayrımı** (§1) burada
4. `Section_03_Core_Components` + `Section_05` — dördüncü RAG kovasının kaynağı (§2.2)
