# 0051 — BRD okuma turu **33**: §5.4 What-If — ve **ROI'nin tüketim ucu**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_05_Planning_First_Mode.md` §5.4 (1377–1527, **tamamı**)
- **Ölçüm ortamı:** meta `5acd8ae` · backend `99ee9e6`

---

## 1. §5.4'ün dört UI yeteneği — üçü yok

| BRD §5.4 yeteneği | bizde | ölçüm |
|---|---|---|
| **Grand Totals Panel** (gerçek zamanlı) | ✅ | `GrandTotals.tsx` (167 satır) |
| **What-If Analysis** | ❌ | `whatif\|what-if\|simulat` → **0 dosya** |
| **Undo/Redo Stack** | ❌ | aşağıda |
| **Inline Optimization Hints** | ❌ | aşağıda |

### ⚠️ Turu 28'in iki `⚠️ doğrulanmadı` işareti **kapandı** — ikisi de gürültüydü

Turu 28 *"Undo/Redo: **3 dosyada iz** — doğrulanmadı"* ve *"Optimization hints: 1 dosya —
muhtemelen ilgisiz"* demişti. Ölçüldü:

```
undo|redo  → 2 dosya, ve ikisi de İNGİLİZCE DÜZYAZI:
  useVersionConflict.ts:16  "The user must review the fresh data and redo their edit"
  versionConflict.ts:14     "let them redo their edit"
suggestion → spend-calculation.endpoints.ts: suggestion? · suggestions[] · autoFixSuggestions[]
             → VALİDASYON düzeltme önerisi, ROI optimizasyonu değil
```

> **Undo/Redo mekanizması yok; `Ctrl+Z` bağlaması yok (`ctrlKey|metaKey` → 0).**
> Ve *"iz"* sanılan şey, bir yorumdaki İngilizce fiildi.

⚠️ Bu, oturumda **dördüncü** kez ısırdığımız sınıf (`§7.1` — kelime sayımı bir gürültü
ölçüsüdür), ama bu sefer **kod aramasında**: `grep -li` bir dosyayı işaretler, o dosyanın
**neresinde** eşleştiğini söylemez. Turu 28 sayıyı raporlamış ama `⚠️` ile işaretlemişti —
**işaret doğru konmuştu, ve tam da onun sayesinde bu tur ölçüldü.**

---

## 2. 🔴 Yeni: `GrandTotals.tsx`'te **hardcoded ROI hedefi** — ve düzeltilmiş bir kardeşi var

```ts
// GrandTotals.tsx:66
const targetRoi = 20.0; // Default target ROI (will be configurable from KPI config)
...
:137  className={... gpRoi < targetRoi ? 'text-red-600' : ...}   ← RENK KARARI
:142  Target: %{targetRoi.toFixed(0)}
```

**Kardeş okuyucu düzeltilmiş:**

```ts
// plan.service.ts:2809 — B-1 fix'i
// B-1: Target ROI from GP_ROI_PCT KPI config (ragGreenThreshold) — NOT hardcoded.
const gpRoiKpi = await this.kpiEngine.getKpiConfig(tenantId, 'GP_ROI_PCT');
const targetRoi = gpRoiKpi?.ragGreenThreshold ?? 20.0;  // fallback yalnız kayıt yoksa
```

Ve `PlanAnalysis.tsx:118` bu konfigüre değeri **okuyor**.

> ### İki ROI hedefi okuyucusu: biri konfigürasyondan, biri sabitten.
> `§2.3`: *"RAG: hardcoded threshold YASAK; sadece KPI konfigürasyonundan."*
> Ve **sabit olan, sürekli görünen panelde** — `PlanAnalysis` bir alt sayfa.

⚠️ **`§7.1`'in T-083a vakasıyla aynı şekil:** bir düzeltme yapıldı, kardeş yol açıkta kaldı,
ve **açıkta kalan daha görünür olandı**. → [[T-171]]

⚠️ Ve TODO'nun kendisi `CLAUDE.md`'nin *"eksiklik TODO ile değil TASK ile kaydedilir"*
kuralının bir vakası: *"will be configurable from KPI config"* yazılmış, task açılmamış.

---

## 3. ⛔ [[T-163]] için **beşinci tanık — ve ilki kendi repomuzda**

```ts
// GrandTotals.tsx:64
// GP ROI: From plan.overallRoi (calculated as: (Incremental GP / Total Spend) * 100)
```

| tanık | payda |
|---|---|
| BRD `§5.1` · `§5.3` · Addendum `H1` · `04_Reviews` | `TOTAL_PLANNED_SPEND` |
| **`GrandTotals.tsx:64` yorumu** | **Total Spend** |
| `migration 1780…FixKpiBrdFormulas` (*"DOĞRU (BRD)"*) | `INCR_SPEND` |

> **Kendi frontend'imizin yorumu, kendi backend'imizin formülüyle çelişiyor** — ve BRD
> tarafında duruyor.

Bu aynı zamanda `CLAUDE.md`'nin *"yorumda başka bir bileşen hakkında iddia → ölç, atıf yaz"*
kuralının bir ihlali: yorum backend'in hesabını tarif ediyor, **backend öyle hesaplamıyor**.

→ [[T-163]] güçlendi. Ve **düzeltme yönü ne olursa olsun bu yorum da düzeltilmeli** — iki
sayıdan biri yanlış, ama şu an ikisi birbirini yanlışlıyor.

---

## 4. 🔴 Yeni: **hesaplanamayan ROI, bir iş yargısına dönüşüyor**

İki bağımsız yolda:

```ts
// plan.service.ts:2816
const status = currentRoi === null ? 'BELOW_TARGET' : ...
// GrandTotals.tsx:65
const gpRoi = plan.overallRoi || 0;   // → 0, ve 0 < 20 → KIRMIZI
```

`§2.3`: *"KPI edge case: division-by-zero → **null**, eksik veri → **null**"*. Motor doğru
davranıyor (`formula-parser` bağımlılık eksikse `null` döndürüyor — turu 12'de ölçüldü).

> **Kayıp motorda değil, TÜKETİM ucunda:** *"hesaplanamadı"* ile *"hedefin altında"* aynı
> ekrana, aynı renge, aynı statüye çöküyor.
>
> Bu `§2.5`'in (*sessiz sıfır*) görüntüleme tarafındaki hâli: sayı uydurulmuyor ama
> **bilinmezlik bir yargıya çevriliyor** — ve kullanıcı farkı göremiyor.

→ [[T-172]]

---

## 5. 🔴 §5.4'ün hukuki maddesi: *"on what basis"* — **kaydedilmiyor**

BRD `§5.4` *Decision Support vs Decision Authority*:

> *"Accountability: Category Manager/Finance approver **owns the commercial decision**"*
> *"This distinction is critical for: **Finance audit trails (who approved, on what basis)**"*

**Ölçüm** (`plan_approval_history`):

| alan | var mı | yazılıyor mu |
|---|---|---|
| `actioned_by` · `action` · `comments` · `rejection_reason` | ✅ | ✅ |
| **`metadata` jsonb** — *"Additional context (budget amounts, etc.)"* | ✅ | ❌ **sıfır yazar** |

`createHistoryEntry` (`approval-workflow.service.ts:1092`) `metadata`'yı ne parametre olarak
alıyor ne set ediyor.

> **`who` kaydediliyor, `on what basis` kaydedilmiyor.**
>
> Ve geri de alınamıyor: `plan.overallRoi` **değişebilir bir alan**: onaydan sonra bir
> yeniden hesaplama olduğunda, onayın hangi sayıya dayandığı **hiçbir yerden** okunamaz.

⚠️ Ve bu, tanıdık sınıfın bir üyesi daha: **alan var, ona giden yol yok** ([[T-052]] ailesi).
Alanın varlığı, doldurulduğu izlenimi veriyor.

→ [[T-173]] · [[T-168]] (audit sözlüğü) ve [[T-170]] (Vergi Usul denetim izi) ile bağlı.

---

## 6. 📌 `§5.4` performans hedefleri: **bir değil beş**

| eylem | hedef |
|---|---|
| Hacim değişimi (tek SKU) | **<200ms** |
| Taktik değişimi (FU) | <500ms |
| FU aç (SKU göster) | **<100ms** |
| 50 SKU tüm KPI yeniden hesap | <500ms |
| Grand Totals paneli | **<300ms** |

> ADR 0003 (*"recalc 500ms kapsamı"*) tek bir sayı üzerinden karara bağlanmıştı. **Kaynak
> eylem başına beş ayrı hedef veriyor** ve üçü 500ms'ten sıkı.
>
> ⚠️ ADR 0003 ile **çelişmiyor** — o *"hangi kapsam"* sorusunu çözüyordu, bu *"hangi eylem"*
> sorusunu açıyor. **Yeni bir karar gerektirir mi, ürün sahibinin çağrısı.**

⚠️ Ve hiçbiri bugün ölçülemez: deploy edilmiş ortam yok ([[T-157]]).

---

## 7. Okunmayan / sonraki tur (🟡 kalan)

`Section_05` §5.4 **tamamlandı**. Kalan 🟡: `§3.1/3.2` · `§6.3/6.5` · `§11.2`+P2/P3 ·
`§10.3` · Addendum H5.2/5.3 (~845 satır, **~2 tur**).
