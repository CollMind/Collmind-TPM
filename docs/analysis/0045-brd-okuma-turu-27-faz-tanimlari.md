# 0045 — BRD okuma turu **27**: §10.1 Phase 1 tanımı — [[T-169]] doğrulandı

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_10_Roadmap.md` §10.1 Phase 1 (29–131, tamamı)
- **Ölçüm ortamı:** meta `ae70eb9` · backend `99ee9e6`

---

## 1. ⛔ [[T-169]] **kanonik faz tanımıyla doğrulandı**

`Phase 1: Actuals-First MVP (13 Weeks)` → **Explicitly NOT in Phase 1:**

```
❌ Planning-First Mode (deferred to Phase 2)
❌ KPI Calculation Engine (Planning-First dependency)
❌ Baseline data import (Planning-First dependency)
❌ ROI simulation (Planning-First feature)
```

**Bizde üçü de var** (ölçüldü): `modes/planning-first/` çalışıyor · `main.kpis` **27 KPI,
16 `expression`** · `formula-parser` + `kpi-engine` canlı.

> **T-169 artık iki dolaylı sinyale değil, kanonik faz tanımına dayanıyor.**
> Ürün, BRD'nin Phase 1 kapsamının **önünde** — ve bu **belgede açıkça ertelenmiş** dört
> yeteneği kapsıyor.

### Ve atlanan Phase 1 maddeleri **aynı listede sayılı**

`Phase 1 → Security & Compliance`:

```
✅ 5 core roles
✅ Capability-based permissions          → ❌ bizde yok  ([[T-165]])
✅ Audit logs (20 event types)           → ⚠️ sözlük yok ([[T-168]])
✅ Multi-tenant isolation (RLS)          → ❌ 0/43 tablo ([[T-167]])
```

> **Aynı sayfada:** Phase 2 yetenekleri **inşa edilmiş**, Phase 1 güvenlik tabanı
> **atlanmış**. T-169'un sorusu bu tabloyla somutlaşıyor.

---

## 2. ⚠️ SÜRPRİZ — `§10.1` bütçe eşiklerinde **95** diyor, `§3.3`/`§4.8` **90**

```
Phase 1 → Budget Management:
  ✅ Alerts (80%, 95%, 100% thresholds)        ← ⚠️ 95
```

Oysa turu 4 ve 2'de ölçmüştük:

| kaynak | eşikler |
|---|---|
| `§3.3` Budget Policies (çekirdek bileşen) | 80 uyarı · **90 onay** · 100 blok |
| `§4.8` Budget Alerts & Thresholds | 80 · **90** · 100 |
| **`§10.1`** Phase 1 kapsamı | 80 · **95** · 100 |
| Glossary + `§4.4` RAG (renk) | 80 · **95** (renk sınırı) |
| **bizim kod** | 80 · **95** · 100 |

### 📌 Uzlaştıran okuma adayı — ve **ölçüm değil, çıkarım**

`§2.1.1`'in haritası: **eşik/politika tanımları → `Section_03`**. `§10.1` bir **faz kapsam
özeti**dir, tanım değil.

> **Okuma:** `§3.3`'ün 80/**90**/100'ü kanonik; `§10.1`'in *"(80%, 95%, 100%)"*'i RAG renk
> sınırlarıyla karışmış bir **özet satırı**.

⚠️ **Bu bir çıkarımdır** — ve turu 17'nin dersi gereği *"çelişki"* ilan etmiyorum. Ama
[[T-144]] için önemli: **kodumuzun 95'i kaynağın bir satırıyla örtüşüyor**, yani sapma
*"tamamen dayanaksız"* değil — **yanlış satırdan alınmış** olabilir.

→ [[T-144]]'e not düşüldü.

---

## 3. 📌 İki küçük gözlem

**(a) `Tactic configuration (Admin UI)` ✅ Phase 1.**
`§5.7` *"Policy authoring UI"*'yi Phase 2'ye ertelemişti. İkisi **farklı şey** olabilir
(taktik konfigürasyonu ≠ politika yazma) — **ölçülmedi**, iddia yazılmıyor. Ama [[T-156]]'nın
*"ertelenen hep arayüz"* çerçevesi **mutlak değil**: bazı admin arayüzleri Phase 1'de.

**(b) Phase 1 başarı ölçütleri mütevazı:**

```
✅ 10 agreements created and approved by pilot users
✅ 1 off-invoice batch imported successfully
✅ All 5 roles can perform their core workflows
✅ Response times meet NFR targets (<2s page load)
```

Bizde `agreements` **3 satır** (dev), üretim ortamı **yok**. [[T-157]]'nin *"Gate 1 bile
açık"* bulgusuyla tutarlı.

---

## 4. Okunmayan

`§10.1`'in Phase 1.1 / 2 / 3 / 4+ blokları (133–323) · `§10.3` riskler · `§10.5` kaynak
planlama · `§10.6` başarı metrikleri.

**Section_10: ~230 / 567 (%41).**

---

## 5. Sonraki tur

1. **`§10.1` Phase 2 tanımı** (154–239) — [[T-169]]'un ikinci yarısı: erken inşa
   ettiğimiz şey Phase 2'nin **tamamı mı, bir kısmı mı**
2. `§7.1` Role Model — [[T-165]] (beş rol ↔ altı rol)
3. `04_Reviews`'in gövdesi ([[T-161]])
