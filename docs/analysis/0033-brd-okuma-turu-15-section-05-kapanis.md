# 0033 — BRD okuma turu **15**: §5.5 Budget Commitment · §5.7 Phase 1 kapsamı

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_05_Planning_First_Mode.md` §5.5 (1645–1697) · §5.7 (1956–2013)
- **Ölçüm ortamı:** meta `31c8025` · backend `99ee9e6`

---

## 1. 🔴 [[T-150]] ağırlaştı — **kayıp ayrım değil, YANLIŞ ETİKETLEME**

`§5.5 Budget Commitment` normatif bir tablo veriyor:

| State | Planning-First | Actuals-First |
|---|---|---|
| **Reserved** | ❌ **Not used** | ✅ Agreement approved |
| **Committed** | ✅ **Plan approved** | ❌ **Not used** |
| Consumed | ✅ | ✅ |

> **`Reserved` ve `Committed` moda göre BİRBİRİNİ DIŞLIYOR.** Bir plan **asla** `Reserved`
> üretmez; bir anlaşma **asla** `Committed` üretmez.

Bizim `budget-summary.view-entity.ts`: `reserved_amount = RESERVE + COMMIT − RELEASE`.

**Turu 4'te bunu *"kayıp ayrım"* diye kaydetmiştim. Ölçüm bir adım öteye götürüyor:**

> Plan taahhütleri, BRD'nin *"Planning-First'te kullanılmaz"* dediği bir durumun (`Reserved`)
> altında **raporlanıyor**. Bu yalnız bilgi kaybı değil, **yanlış ad**.

Ve `§5.5` COMMIT'in tutarını da veriyor: `amount: plan.total_planned_spend`.

---

## 2. 📌 [[T-163]] için **bağlam bulundu** — formül değil, gerekçe

`§5.4` ve sonrasında `TOTAL_PLANNED_SPEND` · `INCR_SPEND` · `GP_ROI` **hiç geçmiyor**
(ölçüldü). Yani BRD'de ROI paydasına dair **ek bir formül açıklaması yok**.

**Ama `§5.5` dolaylı bir gerekçe veriyor:**

```typescript
tx_type: 'COMMIT',
amount: plan.total_planned_spend,      // ← bütçeye taahhüt edilen tutar
```

BRD'nin ROI paydası (`TOTAL_PLANNED_SPEND`) = **bütçeye fiilen taahhüt edilen para**.

> **BRD'nin metriği:** *"taahhüt edilen her lira başına artımsal kâr."*
> **Bizim metriğimiz** (`INCR_SPEND` paydası): *"artımsal harcanan her lira başına artımsal
> kâr."*
>
> İkisi de savunulabilir — ama BRD'ninki **bütçe taahhüdüne bağlı** ve bu tutarlı bir
> tasarım: onaylanan şey `total_planned_spend`, ROI de onun getirisini ölçüyor.

⚠️ **Bu bir ÇIKARIMDIR, kaynakta yazılı bir gerekçe değil.** T-163'e böyle işaretlendi.
Kaynakta açık gerekçe için geriye **`04_Reviews`** (5.249 satır, [[T-161]]) kalıyor.

---

## 3. ✅ Çıktı 1'in niyet ayrımı — **planning tarafı da ölçüldü**

`§5.7 Explicitly NOT in Phase 1 (Deferred)`, beş grup: Advanced Grid · Advanced KPI ·
Integration · Collaboration · Advanced Approval.

**Aradığımız altı terim bu listede de YOK.**

Toplam **üç açık kapsam listesi** ölçüldü:

| liste | nerede | terimlerimiz |
|---|---|---|
| Deferred (actuals) | `§4.10` | yok |
| **Out of scope, *conceptually incompatible*** (actuals) | `§4.10` | yok |
| Deferred (planning) | **`§5.7`** | **yok** |

> Turu 5'in düzeltilmiş iddiası **üçüncü listeyle de doğrulandı**: `accrual` ve `settlement`
> **sözcük** olarak var (ledger `spend_type`, LTA özelliği), `claim`/`recognition`/
> `gross-to-net` **hiç yok**, ve **hiçbiri** bir kapsam listesinde yer almıyor —
> ne ertelenmiş, ne bilinçli dışlanmış.

[[ADR 0010]]'un sonucu ayakta: RECOGNITION_SPEC **yeni bir ürün kararı**.

---

## 4. 🟢 [[T-156]]'ya bir **sınır** geldi — ve çerçeveyi güçlendiriyor

`§5.7`'nin *Advanced Approval* grubunda:

```
❌ Policy authoring UI (admin creates policies via UI)
```

**Ertelenen şey admin ARAYÜZÜ.** Politika **tabloları** (`approval_policies`,
`tactic_policies`, `budget_policies`) `Section_03`'te **çekirdek bileşen** olarak, Phase 1'de
tanımlı.

> **Ayrım net ve T-156'nın olası en güçlü itirazını kapatıyor:**
>
> | | BRD | bizde |
> |---|---|---|
> | politika **tabloları** | Phase 1 çekirdek | ❌ **yok** ([[T-148]], [[T-153]]) |
> | politika **yazma UI'ı** | ❌ Phase 2'ye ertelenmiş | yok — **uygun** |
>
> Yani *"admin UI yok"* bir kusur **değil**. *"Tablo yok, kural serviste"* bir kusur.

⚠️ Ve `§3.4`'ün *"Phase 1 Guardrail: intentionally constrained to a small, opinionated set"*
ifadesiyle birleşince tam resim: **az sayıda, seed'le kurulmuş, tabloda yaşayan kural** —
BRD'nin Phase 1 hedefi bu. Bizde kurallar **kodda**.

---

## 5. 📌 Küçük bir Glossary ↔ §5.7 gerilimi (kayda geçer)

`§5.7` *"Conditional routing (if ROI <15%, route to CFO)"*'yu **Phase 2'ye erteliyor**.

Glossary `Approval Policy` maddesi ise örnek olarak veriyor:
*"Level 2: Finance (if amount ≥50K **OR GP ROI <15%**)"* ve *"Auto-Reject: If GP ROI <5%"*.

> Glossary bir **örnek** veriyor, §5.7 onu **erteliyor**. [[T-159]]'un (paket içi öncelik)
> dördüncü vakası — ve [[T-163]]'ün *"onay eşikleri ROI'ye uygulanıyor"* gerekçesini
> **zayıflatıyor**: koşullu yönlendirme Phase 1'de yok.
>
> **T-163'ün ağırlığı değişmiyor** (ROI hâlâ RAG'ı ve göstergeleri belirliyor) ama
> *"auto-reject <%5"* argümanı Phase 1 için **geçerli değil**. T-163'e düzeltme olarak
> işlendi.

---

## 6. Okunmayan

`§5.2` grid mimarisi (246–437) · `§5.4` What-If (1377–1530) · `§5.5`'in politika/UI blokları
(1530–1645) · `§5.6` senaryolar (1699–1840) · `§5.7`'nin Phase 1 **özellik** listesi
(1840–1956).

**Section_05: ~550 / 2013 (%27).**

---

## 7. Sonraki tur

1. `Section_02 Product Overview` (1026) — ürün çerçevesi, hiç açılmadı
2. `Section_10 Roadmap` + `Section_11 Assumptions/Risks` — faz kararlarının kanonik yeri
3. `04_Reviews` (5249) — [[T-161]]; **[[T-163]]'ün son kaynak adayı**
4. `Section_05`'in kalanı · `Section_06/07/08/09`
