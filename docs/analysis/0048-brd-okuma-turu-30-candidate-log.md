# 0048 — BRD okuma turu **30**: `03_Candidate_Log`'un beş adayı

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `03_Candidate_Log/BRD_2.0_Candidate_Log.md` — CANDIDATE-001/003/004/005/006
- **Ölçüm ortamı:** meta `2dbe1d2` · backend `99ee9e6`

---

## 1. ✅ **Yedi adayın YEDİSİ de Addendum'u kaynak gösteriyor**

| aday | Source |
|---|---|
| CANDIDATE-001 KPI Calculation Engine | **Addendum §H1** + `§5` |
| CANDIDATE-002 Formula Execution Sandbox | **Addendum §H5** + `§9` |
| CANDIDATE-003 Budget Concurrency | **Addendum §H2** + `§3.4` |
| CANDIDATE-004 Approval State Machine | **Addendum §H3** + `§4.3` + `§5.6` |
| CANDIDATE-005 Baseline Data Readiness | **Addendum §H4** + `§11.1 A9` |
| CANDIDATE-006 KPI Recalculation Strategy | **Addendum §H1** + `§5.4` |
| CANDIDATE-007 KPI Engine SLA | **Addendum §H1** + `§9.1` |

> **[[T-159]]'un çözümü kesinleşti: `03_Candidate_Log`, `02_Addendum`'un beş maddesinin
> canlı bir DURUM İZLEYİCİSİDİR.** Yedi aday, beş H maddesine dağılmış (H1 → üç aday).
>
> Çelişki aramak baştan yanlış soruydu; ikisi **aynı işin iki görünümü**.

---

## 2. 🔴 CANDIDATE-003 — kaynağın kendi statüsü [[T-154]]'ü **birebir** tarif ediyor

```
Status: 🟠 Partially Implemented (Phase 1) — SQL logic written, load test pending
Deferral:
  ❌ Conceptually defined in BRD v1.0, but not stress-tested
  ❌ Requires real concurrency scenarios (10+ simultaneous users)
  ❌ Database isolation level implications not validated in production-like environment
```

**T-154'ün bulgusu** (turu 7): pessimistic locking ✅ var (ADR 0005 yakınsaması), ama
`SERIALIZABLE` yok · retry ölçülmedi · **H2'nin kabul testi yazılmamış**.

> **Kaynağın kendi durum kaydı aynı boşluğu sayıyor** — *"SQL logic written, **load test
> pending**"* ve *"isolation level implications **not validated**"*.
>
> **T-154 bir sapma değil, kaynağın da izlediği açık bir madde.** Statüsü değişmiyor ama
> **çerçevesi değişiyor**: *"eksik"* değil, *"planlanmış ama yapılmamış doğrulama"*.

---

## 3. 🔴 CANDIDATE-004 — [[T-158]] **yeniden çerçeveleniyor**

```
Status: 🟠 Partially Implemented (Phase 1) — happy path complete,
        edge cases pending UAT validation
Deferral:
  ❌ Core flow defined in BRD v1.0 (sufficient for Phase 1 happy path)
  ❌ Edge cases depend on real usage patterns (cannot be fully enumerated
     without production data)
  ❌ State machine diagram exists (Addendum §H3) but needs real-world validation
```

**T-158'in bulgusu** (turu 8): `EXPIRED` durumu · 7 günlük otomatik zaman aşımı · 14 günlük
grace period · planlarda `CANCELLED` — hiçbiri yok. Ve gece işi altyapısı da yok.

> **Kaynak bunları *"edge cases"* sayıyor ve *"pending UAT validation"* diyor.**
> Yani `§H3` Action 3.3'ün zaman aşımı ailesi **Phase 1'in happy path'i dışında** ve
> **gerçek kullanım verisine bağlı** olarak erteleniyor.
>
> **T-158 *"karşılanmamış Phase 1 gereksinimi"* değil, *"UAT'ye ertelenmiş edge case"*.**
> Bu, [[T-167]] (RLS — Phase 1'de ✅ işaretli) ile **tam zıt** bir statü.

⚠️ **Ölçümün sınırı:** CANDIDATE-004'ün *"edge cases"* tanımının **7 günlük zaman aşımını
kapsadığı doğrulanmadı** — adayın doğrulama tablosu okunmadı. *"Kapsıyor"* demiyorum;
**statü sınıfının** farklı olduğunu söylüyorum.

---

## 4. 📌 Diğer üç aday

**CANDIDATE-005 Baseline** — `🔴 Risk identified (blocking risk for Phase 2)`, gerekçe
*"depends on customer data availability (**external dependency**)"*.

> [[T-024]] ile tutarlı: blokaj **bizde değil**, müşteri veri erişilebilirliğinde.

**CANDIDATE-006 KPI Recalculation** — `🟡 Open design question (not decided)`,
gerekçe: *"**No KPI recalculation in Phase 1** (Actuals-First has no KPI engine)"*.

> **Üçüncü kez** *"Phase 1'de KPI motoru yok"* — [[T-169]]'u pekiştiriyor.

**CANDIDATE-001 KPI Engine** — `🟡 Hypothesis (design assumed, not proven)`, gerekçe
*"No baseline data available to test against"*.

---

## 5. 📌 Statü sözlüğü — kaynağın kendi sınıflandırması işe yarar

Beş adayın statüleri **üç ayrı sınıf** kullanıyor:

| statü | anlamı | bizdeki karşılığı |
|---|---|---|
| 🟠 **Partially Implemented (Phase 1)** | uygulama var, **doğrulama yok** | CANDIDATE-003 → [[T-154]] · CANDIDATE-004 → [[T-158]] |
| 🟡 **Hypothesis / Open design question** | **karar verilmemiş** | CANDIDATE-001 · CANDIDATE-006 |
| 🔴 **Risk identified** | **dış bağımlılık** | CANDIDATE-005 → [[T-024]] |

> Bu sözlük [[T-169]]'un sorusuna da bir çerçeve veriyor: *"eksik"* dediğimiz şeyler
> **üç farklı sınıfta** — ve sıralama kararı sınıfa göre değişir.
>
> ⚠️ Ama kaynağın sınıflandırması **bizim ölçümümüzün yerine geçmez**: CANDIDATE-003
> *"SQL logic written"* diyor ve bu **doğru**; CANDIDATE-001 *"design assumed, not
> proven"* diyor ama bizde **27 KPI çalışıyor** — yani kaynak bazı yerlerde **bizden
> geride**.

---

## 6. `03_Candidate_Log` tamamlandı

Yedi adayın **yedisinin** de künyesi okundu. Okunmayan: adayların **doğrulama
tabloları** ve `GOVERNANCE NOTES` / `REVIEW SCHEDULE` / `NEXT ACTIONS` blokları
(~250 satır).

⚠️ Bunlar 🟡: doğrulama tabloları *kim, ne zaman* bilgisi taşıyor — **açık bir task'ı
değiştirmez**, ama T-169'un sıralama kararında girdi olabilir.

---

## 7. Sonraki tur

🔴 kalan iki parça:
1. `§3.3` kalanı (606–781) — *"Phase 1 Constraints"*, [[T-150]]'nin ön koşulu
2. `§7.1` Role Model — [[T-165]]
