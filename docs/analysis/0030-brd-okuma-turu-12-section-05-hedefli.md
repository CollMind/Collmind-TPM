# 0030 — BRD okuma turu **12**: Section 05, üç hedefli blok

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_05_Planning_First_Mode.md`
- **Ölçüm ortamı:** meta `100023f` · backend `99ee9e6`

---

## 0. Okundu / okunmadı — **bu tur hedefliydi**

✅ **§5.1 Mode Coexistence + Product Philosophy** (203–231) · **§5.2 Design Principle
(Critical Guardrail) + RAG Visualization** (437–488) · **§5.3 Edge Case Handling** (1355–1375)

⛔ **~1.900 satır okunmadı**, ve içinde en büyüğü: **40 KPI'nin tam kütüphanesi**
(587–1199, sekiz grup) · Planning Grid mimarisi · Calculation Engine Logic (dört adım) ·
§5.4 ROI Simulation · ve §5.4 sonrası **tümüyle**.

> ⚠️ **Bu tur bir bölüm okuması değil, üç sorunun cevabını arayan bir sondaj.** Section_05
> hakkında genel bir iddia **yazılmıyor**.

---

## 1. ✅ Mod ayrımı — **dördüncü ve en tam ölçüm**, ve teşhis kesinleşti

`§5.1 Mode Coexistence (Critical Clarification)`:

> **"Planning-First and Actuals-First **can coexist within the same customer, channel, or
> portfolio**."** Çözüm faktörleri:
> - Tactic eligibility
> - **Baseline data availability (no baseline → Actuals-First)**
> - Channel maturity
> - User role/permissions
>
> *"This is **not a system-wide toggle**. A single user may create an Actuals-First agreement
> for a competitive response in Traditional Trade **in the morning**, then work on a
> Planning-First JBP for NKA **in the afternoon**."*

### Dört kaynağın uzlaşması

| kaynak | ne sayıyor |
|---|---|
| Glossary | tactic eligibility · baseline availability · channel maturity · user workflow |
| §4.1 | tactic eligibility · scope policy configuration · user permissions |
| §4.7 / §3.5 | **mekanizma**: `tactic_policies` (`enabled_in_actuals`/`enabled_in_planning` + iki JSONB) |
| **§5.1** (bu tur) | tactic eligibility · **baseline availability** · channel maturity · **user role/permissions** |

Glossary ve §5.1 **birebir aynı dörtlüyü** sayıyor; §4.1 kısaltılmış hâli. **Turu 2'nin
"BRD-içi tutarsızlık" bulgusunun geri çekilmesi dördüncü kaynakla doğrulandı.**

### Ve [[T-148]]'in teşhisi keskinleşiyor

Bugün mod bir **modül ağacı** (`modes/actuals-first/`, `modes/planning-first/`).

> **Kod organizasyonu olarak bölünme sorun değil.** Sorun, ayrımın **çalışma zamanında
> bağlamsal** olması gerekirken bugün **yapısal** olması: aynı müşteri, aynı kanal, hatta
> **aynı kullanıcı aynı gün** iki modda çalışabilmeli — ve bunu belirleyen dört faktörden
> **hiçbiri** kodda bir çözümleyiciye bağlı değil (`tactic_policies` tablosu yok).

⚠️ *"no baseline → Actuals-First"* ayrıca [[T-024]] ile bağlanıyor: baseline kapsama
ölçümü yalnız bir veri kalitesi kapısı değil, **mod çözümünün girdisi**.

---

## 2. 📌 "Critical Guardrail" — okunması gereken şeyi **söylemiyor**, ve bu da bir sonuç

`§5.2 Design Principle`:

```
❌ Cannot add custom calculated columns (Phase 1)
❌ Cannot override calculated KPIs (they are read-only)
❌ Cannot paste arbitrary formulas (only data values)
❌ Cannot delete required columns
✅ Can enter volumes, tactics, and user-input fields
```

Bu, grid'in **serbest bir hesap tablosu olmadığını** ve KPI'ların **salt-okunur** olduğunu
sabitliyor.

> ⚠️ **Ama hesabın NEREDE yapıldığını söylemiyor.** Yani `docs/analysis/0011 §S2.3`'ün açık
> bıraktığı soru (`PlanningGridEnhanced`'in istemcide NIV/Turnover türetmesi) bu blokla
> **ne çözülüyor ne de kapanıyor.**

İlgisi şurada: *"cannot override calculated KPIs"* — istemcide **türetilen** bir değer,
kullanıcı tarafından **override edilmiyor**, yani bu yasağı ihlal etmiyor. Soru hâlâ
CLAUDE.md §2.3'ün *"frontend sadece sonucu render eder"* cümlesi ile [[T-155]]'in kalıntısı
arasında. **Açık kalıyor.**

---

## 3. ✅ Edge Case Handling — **CLAUDE.md §2.3'ün KPI kuralı kaynakta birebir var**

§2.3 hatırlatma listesi diyordu:

> *"KPI edge case: division-by-zero → null, eksik veri → null, negatif ROI geçerlidir."*

`§5.3 Edge Case Handling`:

| vaka | BRD'nin çözümü |
|---|---|
| **Zero Baseline** (yeni ürün) | `IF(BASE_VOL = 0, NULL, (INCR_VOL / BASE_VOL) * 100)` |
| **Zero Spend** (taktik yok) | `IF(TOTAL_PLANNED_SPEND = 0, NULL, …)` |
| **Negative ROI** | **geçerli** — *"Display in red, **flag for review**"* |

> **§2.3'ün bu maddesi — hatırlatma listesi olduğu için "normatif değil" diye
> işaretlenmişti — kaynakta birebir doğrulandı.** Ve `formula-parser.service.ts`'in
> bölme-sıfır → `null` davranışı ([[T-132]] turu boyunca ölçüldü) BRD'nin çözümüyle aynı.

🆕 **Ve bir ek getiriyor:** negatif ROI için *"**flag for review**"*. Bizde kırmızı gösterim
var (RAG `< %10`), ama **inceleme işareti** ölçülmedi — onay akışında bir sinyal mi,
yoksa yalnız görsel mi?

---

## 4. 📌 RAG toplama kuralı — normatif, **ölçülmedi**

`§5.2`:

```
If any SKU is Red   → FU is Red
If no Red but any Amber → FU is Amber
If all Green        → FU is Green
```

*"En kötü kazanır"* kuralı. Glossary de aynısını söylüyordu (turu 1). **Kodda karşılığı bu
turda ölçülmedi** — [[T-162]]'ye ölçüm maddesi olarak girdi.

⚠️ Ve eşikler burada da **20 / 10** (`≥20 yeşil · 10-20 amber · <10 kırmızı`) — turu 1'de
DB'den doğrulanmıştı (`GP_ROI_PCT: green=20, amber=10`). **Üçüncü kaynak, aynı sayı.**

---

## 5. Sonraki tur

1. **`Section_05`'in 40 KPI kütüphanesi** (587–1199) — sekiz grup, ve `kpi.seed.ts`'imizle
   **birebir karşılaştırma** yapılabilir. Bu, KPI motorunun en somut denetimi
2. `§5.3 Calculation Engine Logic` (1199–1355) — dependency graph, formula parsing, SKU→FU
   toplama
3. `§5.4` ve sonrası (~600 satır) — **hiç görülmedi**
4. `Section_02` (1026) · `Section_10/11` · `04_Reviews` ([[T-161]])
