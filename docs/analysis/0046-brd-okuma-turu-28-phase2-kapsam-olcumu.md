# 0046 — BRD okuma turu **28**: §10.1 Phase 2 — **iki faz iç içe girmiş**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_10_Roadmap.md` §10.1 Phase 2 (154–237, tamamı)
- **Ölçüm ortamı:** meta `051fdc8` · backend `99ee9e6` · dev DB `main`

---

## 1. Cevap: **Phase 2'nin tamamı değil — iç içe girmiş**

Ürün sahibinin sorusu: *"Erken inşa ettiğimiz şey Phase 2'nin tamamı mı, bir kısmı mı?
Tamamıysa 'Phase 2'ye geçilmiş ama Phase 1 tabanı eksik'; bir kısmıysa 'iki faz iç içe
girmiş' — ve ikisinin sıralama sonucu farklı."*

**Ölçüm: bir kısmı.**

| Phase 2 grubu | madde | bizde |
|---|---|---|
| **Planning Grid** | hiyerarşik FU/SKU grid · hacim girişi · FU-seviye tactic · Grand Totals | ✅ |
| | Undo/Redo stack | ⚠️ **3 dosyada iz** — doğrulanmadı |
| | auto-save (draft) | ölçülmedi |
| **KPI Engine** | **40+ KPI** | ⚠️ **27** (`0031`) |
| | dependency graph resolution | ⚠️ graf kuruluyor, **kullanılmıyor** ([[T-164]]) |
| | SKU→FU→Plan aggregation · edge case · admin-configurable formüller | ✅ |
| **ROI Simulation** | **What-if analysis** | ❌ **0 dosya** (`whatIf\|what-if\|simulat`) |
| | RAG status evaluation | ✅ |
| | Optimization hints | ⚠️ 1 dosya — muhtemelen ilgisiz |
| **Baseline Data** | import ekranı | ✅ `BaselineImportPage` |
| | validation · **≥%95 kapsama zorlaması** | ❌ ([[T-024]]) |
| **Planning Approval** | **ROI-based approval policies** | ❌ ([[T-153]]) |
| | **auto-reject conditions** | ❌ |
| | budget commitment (COMMIT) | ✅ enum'da var |
| **Reporting** | Plan Performance Report | ✅ `/finance-reporting/plan-performance` |
| | **Planner Performance · ROI Distribution** | ❌ **ikisi de yok** |

---

## 2. 🔴 En çarpıcı eksik: **Phase 2'nin varlık sebebi**

Phase 2'nin **Tagline**'ı: *"Plan with intelligence, approve with confidence."*
**Core Value Proposition**'ın ilk maddesi:

> *"Category Managers can **simulate ROI before committing budget**"*
> *"Plans achieve 10-15% higher ROI through **what-if optimization**"*

**Ölçüm:** `whatIf|what-if|simulat` → **frontend'de 0 dosya**.

> **Phase 2'nin ALTYAPISI inşa edilmiş (grid + KPI motoru), DEĞER ÖNERİSİ inşa
> edilmemiş.**
>
> Ve Phase 2'nin başarı ölçütlerinden biri doğrudan buna bağlı:
> *"ROI optimization: **10%+ improvement (draft → final)**"* — what-if olmadan
> ölçülemez bile.

⚠️ Ve `§4.6`'nın **Price Simulation**'ı da aynı sınıftaydı ([[T-149]]): şema inmiş, ekran
yok. **İki farklı simülasyon yeteneği, ikisi de eksik** — ve ikisi de karar destek aracı.

---

## 3. 📌 Sıralama sonucu — ürün sahibinin çerçevesiyle

> *"Tamamıysa 'Phase 2'ye geçilmiş ama Phase 1 tabanı eksik'; bir kısmıysa 'iki faz iç içe
> girmiş' — ve ikisinin sıralama sonucu farklı."*

**İç içe girmiş.** Bunun anlamı:

| | |
|---|---|
| *"Phase 2 bitti, Phase 1 tabanı eksik"* olsaydı | sıra basit: **geri dön, tabanı tamamla** |
| **Gerçek: iç içe** | Phase 2'nin **yarısı** var, ve eksik yarısı Phase 1 eksikleriyle **kesişiyor** |

**Kesişim somut:**

| Phase 2 eksiği | Phase 1 eksiğine bağlı |
|---|---|
| ROI-based approval policies · auto-reject | **`approval_policies` tablosu** ([[T-153]], Phase 1) |
| Baseline ≥%95 zorlaması | baseline sahibi + kapsama ölçümü ([[T-024]]) |
| — | RLS · yetenek izinleri ([[T-167]], [[T-165]], Phase 1) |

> **Yani "önce Phase 1 tabanı" seçeneği, Phase 2'nin eksik yarısının da ön koşulu.**
> İki iş sıralı değil, **birinci ikincinin altında**.

⚠️ **Bu bir öneri değil, bir bağımlılık ölçümü.** Karar ürün sahibinin ([[T-169]]).

---

## 4. ✅ `%95` üçüncü kez hedef olarak doğrulandı

`Phase 2 Success Criteria`: *"**Baseline coverage ≥95%** for all plans"*

| kaynak | değer |
|---|---|
| Glossary `Baseline` | ≥%95 |
| `§10.2` Gate 2 | ≥%95 |
| **`§10.1` Phase 2 başarı ölçütü** | **≥%95** |
| `§11.3 R3` mitigation | %80 *(kabul edilen azaltma)* |
| Addendum H4 | MVB-2 %80 |

> Turu 17'nin *"%95 hedef, %80 mitigation"* çözümü **üçüncü kaynakla** doğrulandı.

Ve `"70%+ plans achieve Green status (ROI ≥20%)"` **ikinci kez** (Gate 3 ile aynı) —
[[T-163]]'ün etkilediği ölçüt.

---

## 5. 📌 [[T-156]]'nın çerçevesine ürün sahibi düzeltmesi

> *"Ayrım 'mekanizma vs arayüz' değil, **madde bazında**. Epic'in gerekçesi buna göre
> incelmeli — genelleme yerine **vaka bazında faz atfı**."*

Kanıt: `§10.1` **`Tactic configuration (Admin UI)`**'yi **Phase 1**'e koyuyor, `§5.7` ise
`Policy authoring UI`'yi Phase 2'ye.

> **Aynı ürün, iki admin arayüzü, iki farklı faz.** *"Ertelenen hep arayüz"* genellemesi
> **yanlış**.

→ T-156'nın gerekçesi **vaka bazına** çevrildi (aşağıda).

---

## 6. Okunmayan

`§10.1` Phase 1.1 (133–154) · Phase 3 (239–294) · Phase 4+ (294–323) · `§10.3` riskler ·
`§10.5` · `§10.6`.

**Section_10: ~320 / 567 (%56).**

---

## 7. Sonraki tur

1. `§7.1` Role Model — [[T-165]] (beş rol ↔ altı rol, `region ↔ category`)
2. `04_Reviews` gövdesi — [[T-161]]
3. `§10.3` Delivery Risks — dört risk, `§11.3` ile örtüşüyor olabilir
