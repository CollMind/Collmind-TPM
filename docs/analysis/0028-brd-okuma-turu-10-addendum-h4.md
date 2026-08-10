# 0028 — BRD okuma turu **10**: Addendum H4 (Baseline) — [[T-024]]'ün blokajı kalkıyor

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/02_Addendum/BRD_Addendum_Technical_Clarifications.md` H4 (534–675, tamamı)
- **Ölçüm ortamı:** meta `3bbbccc` · backend `99ee9e6`

---

## 0. Okundu / okunmadı

✅ **H4** tamamı (dört Action).
⛔ H5 **5.2/5.3** (810–959) · Sprint 0 Checklist · Phase 2 Gate · Escalation (1017–1153).

**Addendum: ~765 / 1153 (%66).** Beş MANDATORY maddenin **dördü** okundu; H5'in iki alt
maddesi kaldı.

---

## 1. 🔓 [[T-024]] **aradığı onayı bekliyormuş — ve o onay altı aydır repodaydı**

`T-024` `status: blocked`, başlığı: *"Baseline türetme (actuals → BASE_VOL) — **BRD onayı
şart**"*. `docs/analysis/0002` onu şu ön koşulla ertelemişti: *"BRD onayı + volume kolonu +
dağıtım kuralı"*.

**H4 tam olarak o onaydır** — ve fazlasını veriyor:

| Action | ne veriyor |
|---|---|
| **4.1** | **Sahip**: Data Engineering (yoksa BI). RACI: Sales Ops (müşteri eşlemesi), Finance (COGS) danışılır. *"Owner commit edemezse → Phase 2 kapsamı daralır"* |
| **4.2** | **MVB seviyeleri** ve her birinin Phase 2 karşılığı + **kabul SQL'i** |
| **4.3** | Altı haftalık takvim, haftalık teslimat, **Week 6 = MVB-2 GO/NO-GO kapısı**, iki hafta tampon |
| **4.4** | **Degraded-Mode Planning** — baseline'sız SKU ile ne yapılacağı, tam davranış |

> **T-024 altı aydır, repoda duran bir belgenin verdiği onayı bekliyormuş.**
> Blokaj gerekçesi (*"BRD onayı şart"*) doğruydu; eksik olan onay değil, **belgenin
> okunmamış olması**ydı.

---

## 2. 📌 Turu 1'in danışman kuyruğundaki bir madde **düzeltiliyor**

Turu 1, Glossary'den okuyup kuyruğa şunu koymuştu:

> *#4 — Baseline **≥%95 SKU kapsama** onay kapısı · domain · orta maliyet · danışmana evet
> (kapının **varlığı**, sayısı değil)*

**H4 kapıyı üç kademeli gösteriyor:**

| Seviye | Kapsam | Dönem | Granülarite | Phase 2 karşılığı |
|---|---|---|---|---|
| MVB-1 | **%50** | 6 ay | Müşteri × SKU × **Ay** | sınırlı planlama (yalnız üst SKU'lar) |
| **MVB-2** | **%80** | 6 ay | Müşteri × SKU × **Hafta** | **"Phase 2 launches as designed"** |
| MVB-3 | **%95** | **12 ay** | Müşteri × SKU × Hafta | tam kapasite |

> **Glossary'nin *"≥95% SKU coverage for plans to be approved"* ifadesi tam kapasite
> hedefidir, fırlatma kapısı değil.** Fırlatma kapısı **MVB-2 (%80)**.
>
> Danışman sorusu bu yüzden değişiyor: *"böyle bir kapı olmalı mı"* değil,
> **"kademeli kapı doğru mu ve eşikleri sizin gördüğünüz pratikle uyuşuyor mu"** — ve
> ürün sahibinin filtresi gereği bu **daha güçlü** bir soru (gerekçeli olana *"bu gerekçe
> tutuyor mu"* sorulur).

⚠️ Ve kuyruk maddesi *"sayısı değil, kapının varlığı"* diyordu — **düzeltildi**: kademeler
ve granülarite (ay vs hafta) **birlikte** bir domain kararıdır.

---

## 3. ✅ Degraded mode ↔ **T-027 ve §2.5 ile çelişmiyor** — ve fark kritik

H4 Action 4.4, baseline'sız SKU için:

```typescript
withoutBaseline: {
  baselineVolume: 0,                    // ← sıfır ATANIYOR
  incrementalVolume: plannedVolume,     // tümü artımsal
  uplift: null,                         // hesaplanamaz
  roiAccuracy: 'LOW',
  uiWarning: '⚠️ No baseline data for this SKU. ROI calculation is approximate.'
}
```

İlk bakışta `plan.entity.ts`'in T-027 kuralıyla çelişir görünüyor: *"missing data → null,
**never a fabricated 0**"*.

**Çelişmiyor, ve ayrım tam olarak CLAUDE.md §2.5'in ayrımı:**

| | §2.5 ne yasaklıyor | H4.4 ne yapıyor |
|---|---|---|
| değer | sessiz varsayılan | `baselineVolume: 0` |
| **görünürlük** | **sessizlik** | `uplift: null` + `roiAccuracy: LOW` + **UI uyarısı** |

> §2.5 *"sessiz sıfır"*ı yasaklıyor. H4.4'ün sıfırı **gürültülü**: yanında hesaplanamayan
> alan `null` kalıyor, doğruluk düşük işaretleniyor, ve kullanıcı ekranda uyarılıyor.
> **Bu, kuralın ihlali değil, doğru uygulanmış hâli.**

Ve **ADR 0006 Karar 2 ile de çelişmiyor** — farklı eksen (ADR 0008'in kurduğu ayrımın aynısı):

| | konu |
|---|---|
| ADR 0006 K2 | **lumpsum dağıtım ağırlığı** — null base'li SKU **pay almaz** |
| H4.4 | **planlama/ROI gösterimi** — null base'li SKU planlanabilir, tümü artımsal sayılır |

Kod tarafı zaten tutarlı: `spend-distribution.service.ts` ağırlık toplamında
`Number(sku.baseVolume) || 0` → ağırlık 0 → pay yok.

---

## 4. 🔴 Eksik: kapsama kapısı, degraded mode, ve **%30 Finance override'ı**

**Ölçüm** (`coverage|degraded|MVB|baselineCoverage` araması, spec hariç): **boş.**

| H4 maddesi | bizde |
|---|---|
| MVB kademeleri / kapsama ölçümü | ❌ yok |
| Degraded-mode davranışı (`roiAccuracy`, UI uyarısı) | ❌ yok |
| **Plan'da >%30 SKU baseline'sızsa → açık Finance override** | ❌ yok |

Sonuncusu bir **onay kapısı** ve [[T-153]]'ün (onay politika katmanı yok) kapsamına giriyor:
BRD'nin onay kuralları politika tablosunda yaşamalı, ve o tablo yok.

---

## 5. Skor: **dört ADR/task, dört yakınsama** — ve doğası farklı

| Addendum | bizdeki | sonuç |
|---|---|---|
| **H2** budget race | ADR 0005 | ✅ karar **aynı**, üç kabul ölçütü eksik ([[T-154]]) |
| **H1** KPI perf | ADR 0003 | ✅ karar **aynı**, Phase 2 kapısı karşılanamıyor ([[T-157]]) |
| **H3** approval FSM | ADR 0002 | ✅ karar **aynı**, `EXPIRED` ailesi eksik ([[T-158]]) |
| **H4** baseline | [[T-024]] | ⚪ **karar yok — iş yapılmamış**; blokaj kalkıyor |

⚠️ **H4 diğer üçünden farklı:** orada bir karar verip kaynağa yakınsamıştık; burada
**karar hiç verilmemiş**, çünkü verilecek karar kaynakta zaten yazılıydı ve okunmamıştı.

> Üç yakınsama yöntemin gücünü gösteriyor: **kaynak yokken de doğru karar verilebiliyor.**
> H4 ise maliyetini gösteriyor: **kaynak varken okunmazsa iş durur.**
>
> `RECOGNITION_SPEC` için ikisi birden anlamlı — orada kaynak **gerçekten** yok
> ([[ADR 0010]]), yani üç yakınsamanın verdiği güven geçerli; ama H4'ün dersi de geçerli:
> **önce tüm kaynağın okunduğundan emin ol.**

---

## 6. Sonraki tur

1. H5 **5.2/5.3** + Sprint 0 Checklist + Phase 2 Gate + Escalation (1017–1153) → **Addendum
   biter**
2. `Section_05_Planning_First_Mode` (2013) — en büyük okunmamış bölüm
3. `Section_02` (1026) · `Section_10/11` (niyet ayrımının planning tarafı)
