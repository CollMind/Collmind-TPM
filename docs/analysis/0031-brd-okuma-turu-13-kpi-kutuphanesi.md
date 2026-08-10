# 0031 — BRD okuma turu **13**: 40 KPI kütüphanesi ↔ `main.kpis` — **GP ROI formülü farklı**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_05_Planning_First_Mode.md` §5.3 (587–1199)
- **Ölçüm ortamı:** meta `95fa6e3` · backend `99ee9e6` · dev DB `main`, port 5434

---

## 0. Yöntem

KPI'lar BRD'de **yapılandırılmış `INSERT INTO kpis VALUES (…)` blokları** hâlinde. Bu yüzden
karşılaştırma **programatik** yapıldı: BRD'den 34 blok ayrıştırıldı, `main.kpis`'ten 27 satır
çekildi, kod ve `formula_text` alanları karşılaştırıldı.

⚠️ **Ölçülen şey formül METİNLERİDİR.** İki farklı metnin sayısal olarak **eşdeğer olup
olmadığı** ayrı bir sorudur ve bu turda **ölçülmedi** — nerede öyle olduğu aşağıda açıkça
işaretlendi.

⚠️ BRD *"40 KPI"* diyor, ayrıştırılan blok **34**. Fark ya başlık metinlerinde ya da
ayrıştırıcının kaçırdığı bloklarda. **Sayı iddiası yazmıyorum**; karşılaştırma 34 blok
üzerinden.

---

## 1. ⛔ **GP_ROI_PCT — paydalar farklı, ve bu ürünün ana metriği**

```
BRD:  (INCR_GP / TOTAL_PLANNED_SPEND) * 100
biz:  INCR_GP / INCR_SPEND * 100
```

Ve BRD bunu **üç yerde** aynı yazıyor:

| kaynak | ifade |
|---|---|
| `Section_05 §5.3` KPI tanımı | `(INCR_GP / TOTAL_PLANNED_SPEND) * 100` |
| **Glossary** `GP ROI` maddesi | *"GP ROI % = (Incremental GP / **Total Planned Spend**) × 100"* |
| **Glossary** `ROI` maddesi | *"(Incremental GP / **Total Planned Spend**) × 100%"* |

Ve BRD `INCR_SPEND`'i **ayrı bir KPI** olarak tanımlıyor:
`INCR_SPEND = TOTAL_PLANNED_SPEND − TOTAL_BASE_LTA`.

> **Yani BRD'de `INCR_SPEND ≤ TOTAL_PLANNED_SPEND`** (TOTAL_BASE_LTA negatif olmadıkça).
> Payda küçüldükçe oran **büyür**.
>
> ⛔ **Ölçülen: iki formül farklı payda kullanıyor. ÖLÇÜLMEYEN: bugünkü verideki sayısal
> fark.** `plans` tablosu **boş** (`0016 §7`), yani canlı bir karşılaştırma yapılamaz.
> Ama fark **yapısaldır**, veriye bağlı değil.

### Neden bu en ağır bulgu

`GP_ROI_PCT` → **RAG rengi** (`≥20 yeşil · 10-20 amber · <10 kırmızı`) → **onay kararı**
(Glossary `Approval Policy`: *"Auto-Reject: If GP ROI <5%"*, *"Level 2: Finance if GP ROI
<15%"*).

Yani formül farkı bir gösterge farkı değil: **onay eşiklerinin uygulandığı sayı farklı.**

→ [[T-163]] **P1**

---

## 2. 🔴 `BASE_GP` ve `PLANNED_GP` — kâr tanımı da farklı

```
BASE_GP     BRD:  BASE_GSV - BASE_COGS
            biz:  BASE_TO  - BASE_COGS          (BASE_TO = BASE_GSV - BASE_LTA_ON)

PLANNED_GP  BRD:  (PLANNED_GSV - CPP_ON_SPEND) - PLANNED_COGS
            biz:  PLANNED_TO - PLANNED_COGS     (PLANNED_TO = PLANNED_GSV - PLANNED_ON_INVOICE_SPEND)
```

İki gözlem, ve ikisi de **ölçüm**, çıkarım değil:

1. **`BASE_GP`:** bizimki tabandan `BASE_LTA_ON`'u düşüyor, BRD düşmüyor. → `INCR_GP`
   (= `PLANNED_GP − BASE_GP`) **her iki uçtan** etkileniyor.
2. **`PLANNED_GP`:** BRD yalnız `CPP_ON_SPEND`'i düşüyor; bizimki
   `PLANNED_ON_INVOICE_SPEND`'i. BRD'nin kendi zincirinde
   `TOTAL_ON_SPEND = PLANNED_LTA_ON + TOTAL_PROMO_ON` ve `TOTAL_PROMO_ON = CPP_ON_SPEND`.
   **Yani BRD'nin `PLANNED_GP`'si LTA on-invoice'ı düşmüyor, bizimki düşüyor olabilir** —
   `PLANNED_ON_INVOICE_SPEND`'in içeriği ölçülmedi.

> ⚠️ **Eşdeğerlik iddiası yazmıyorum.** İkisinin aynı sonucu verip vermediği
> `PLANNED_ON_INVOICE_SPEND`'in tanımına bağlı ve o **`main.kpis`'te kendi kendine referans
> veriyor** (`formula_text = 'PLANNED_ON_INVOICE_SPEND'`), yani dışarıdan besleniyor.

---

## 3. Envanter farkı

**BRD'de olup bizde olmayan (17):**

| grup | kodlar |
|---|---|
| **master data** | `LIST_PRICE` · `COGS` · `PLANNED_VOL` · `LTA_ON_PCT` · `LTA_OFF_PCT` |
| **harcama zinciri** | `TOTAL_ON_SPEND` · `TOTAL_OFF_SPEND` · `TOTAL_PROMO_ON` · `TOTAL_PROMO_OFF` · `TOTAL_PLANNED_LTA` · `TOTAL_BASE_LTA` · `CPP_OFF_SPEND` · `PRICE_SUPPORT_SPEND` |
| **türev** | `INCR_GSV` · `VOL_UPLIFT_PCT` · `TO_ROI_PCT` · **`RAG_STATUS`** |

**Bizde olup BRD'de olmayan (10):** `PLAN_VOL` · `BPTT`-tabanlı zincir · `PLANNED_TO` ·
`BASE_TO` · `GP_MARGIN_PCT` · `GP` · `PLAN_TURNOVER` · `TACTIC_SPEND` · `BASE_TOTAL_SPEND` ·
`PLANNED_ON_INVOICE_SPEND`

### 3.1 Bir kısmı **yeniden adlandırma**, kusur değil

| BRD | bizde |
|---|---|
| `LIST_PRICE` (*"BPTT — Brüt Parça Taşıma Fiyatı"* diye açıklıyor) | **`BPTT`** |
| `PLANNED_VOL` | `PLAN_VOL` |
| `VOL_UPLIFT_PCT` | `UPLIFT_PCT` (formülü de farklı: `(PLAN_VOL − BASE_VOL) / BASE_VOL * 100`) |

> BRD'nin kendi yorumu Türkçe kısaltmayı **veriyor**; biz onu **kod** yapmışız. İşlevsel
> sorun değil ama **BRD'nin formülleri kopyalanamıyor** — `BASE_VOL * LIST_PRICE` bizde
> tanımsız.

### 3.2 ⚠️ `RAG_STATUS` bir **KPI** olarak yok

BRD: `RAG_STATUS` bir KPI ve formülü
`IF(GP_ROI_PCT >= 20, "GREEN", IF(GP_ROI_PCT >= 10, "AMBER", "RED"))`.

Bizde RAG, `kpis` satırındaki `rag_green_threshold`/`rag_amber_threshold` kolonlarından
hesaplanıyor (turu 1'de DB'den doğrulandı: `20 / 10`).

**Farklı mekanizma, aynı eşikler** — ve bizimki *"eşik konfigürasyondan"* ilkesine (§2.3)
**daha uygun**. Ama sonuç: BRD'nin `RAG_STATUS` KPI'ı bizde **yok**, ve `IF(...)` formülü
bizim motorumuzda **çalışmaz** (§4).

### 3.3 `TO_ROI_PCT` yok

Glossary iki ROI tanımlıyor: `GP ROI` (Finance tercih ediyor) ve `TO ROI` (*"COGS
gerektirmez"*). **`TO_ROI_PCT` bizde yok.**

⚠️ Ve bu bugün anlamlı: `skus.cogs` **4/170 dolu** (`0016 §7.4`). BRD'nin *"TO ROI: easier to
calculate (no COGS required)"* notu tam bu duruma cevap — **COGS'suz ROI ölçebilen metrik
bizde eksik.**

---

## 4. ✅ [[T-160]]'ın sınavı — BRD'nin formüllerinden kaçı motorumuzdan geçer?

Ürün sahibinin sorusu. Ölçüm:

| formül sınıfı | örnek | motorumuzda |
|---|---|---|
| saf aritmetik (KPI kodları **değerle değiştirildikten sonra**) | `(INCR_GP / TOTAL_PLANNED_SPEND) * 100` → `(123 / 456) * 100` | ✅ **geçer** — karakter beyaz listesi rakam ve `+-*/()` kabul ediyor |
| **koşullu** | `IF(BASE_VOL = 0, NULL, …)` · `IF(GP_ROI_PCT >= 20, "GREEN", …)` | ⚠️ `safeEval` **reddeder** (`I`, `F`, `"`, `,`, `=` harf/işaret) — ama `formula-parser` `parseConditional`/`evaluateCondition` ile **ayrı yol** taşıyor |
| `Math.*` | — | ❌ BRD'nin 34 formülünde **hiç `Math.` yok** |

> **Sonuç [[T-160]] için önemli ve beklediğimin tersi:** BRD'nin KPI kütüphanesindeki
> **hiçbir formül `Math.*` kullanmıyor.** Yani H5.1'in izin verdiği sekiz fonksiyon
> kütüphanede **kullanılmıyor** — T-160'ın *"sekizi de yazılamıyor"* bulgusu doğru ama
> **bugün pratik bir engel üretmiyor.**
>
> Asıl sınav **koşullu formüller**: BRD'nin edge-case çözümü (`IF(BASE_VOL = 0, NULL, …)`)
> ve `RAG_STATUS` bu sınıfta, ve motorumuzda **ayrı bir yoldan** geçiyorlar. O yolun
> BRD'nin biçimini kabul edip etmediği **ölçülmedi.**

---

## 5. 📌 Bir yan doğrulama: H1'in Option C fallback'i **BRD'de zaten uygulanmış**

`§5.3` girişi:

> *"only a **curated subset** is exposed in the Phase 1 planning grid UI"* — Volume 4 ·
> Turnover 2 · Spend 1 · Profit 2 · ROI 2 = **~11 KPI kolonu**

Addendum **H1 Action 1.2 Option C** aynen bunu fallback diye öneriyordu: *"Show only 10-12
'essential' KPIs in real-time … 11 KPIs only"*.

> **Fallback ana tasarıma zaten girmiş.** Yani H1'in performans riski, BRD'nin UI
> tasarımında kısmen **önceden** karşılanmış.

---

## 6. Okunmayan

`§5.3`'ün formül blokları **ayrıştırıldı**, ama açıklama metinleri (her KPI'nin gerekçesi,
kullanım notları) **okunmadı**. `Calculation Engine Logic` (1199–1355, dört adım) ·
`§5.4` ve sonrası (~640 satır) **hiç görülmedi**.

---

## 7. Sonraki tur

1. **`§5.3 Calculation Engine Logic`** (1199–1355) — dependency graph · formula parsing ·
   SKU→FU toplama. [[T-163]]'ün bağlamı orada olabilir
2. `§5.4` ROI Simulation ve sonrası
3. `Section_02` (1026) · `Section_10/11` · `04_Reviews` ([[T-161]])
