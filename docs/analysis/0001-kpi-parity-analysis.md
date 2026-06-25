# 0001 — KPI/Spend/ROI/Budget Parite Analizi (CTPM ↔ TTM ↔ BRD)

- **Tarih:** 2026-06-24
- **Kaynak:** T-008 (data-analyst, salt-okunur analiz)
- **Verdict:** Parite **temiz değil** — çekirdek KPI/ROI hesabında sapmalar + BRD ihlalleri var.

## Sapmalar (CTPM vs TTM/BRD)

| # | Konu | Bulgu | Şiddet |
|---|---|---|---|
| 1 | ROI tabanı | CTPM fallback `PLANNED_GP/Spend` kullanıyor; BRD/TTM `INCR_GP/Spend`. Aynı girdide farklı ROI. (`plan.service.ts` ~709-712) | 🔴 |
| 2 | INCR_GP yolu | LTA>0 olunca base GP farklı taban: CTPM TO-tabanlı, TTM `BASE_VOL*(BPTT-COGS)`. (`spend-calculation.service.ts` ~690-695) | 🔴 |
| G | PLANNED_LTA_ON eksik | kpi-engine context'ine `PLANNED_LTA_ON` enjekte edilmiyor → CPP_ON_SPEND null → TOTAL_PLANNED_SPEND null → ROI null. (`plan.service.ts` ~614-626) | 🔴 |
| 4 | CPP_ON_SPEND tabanı | `calculateFuTacticSpend` LTA çıkarmıyor (ham PLANNED_GSV); `SpendCalculationService` doğru çıkarıyor → iki yol tutarsız. | 🟠 |
| — | RAG fallback hardcode | `plan.service.ts` ~652-655, 717-720: `gpRoi < 15 → AMBER` hardcoded. BRD ihlali. | 🟠 |
| — | Budget threshold hardcode | 80/95/100 birçok dosyada gömülü (finance-reporting, budget-allocation, budget, on-invoice-validation). BRD ihlali. → T-012 | 🟠 |
| — | YELLOW vs AMBER | `budget.service` `YELLOW`, finance-reporting `AMBER` — iç terminoloji tutarsız (BRD: AMBER). | 🟡 |
| — | %95 sınırı | TTM `>95` (strict), CTPM `>=95` (inclusive). **BRD "%95 Critical" → CTPM muhtemelen DOĞRU; TTM sapma.** Teyit gerek. | 🟡 |
| — | calculateFuTacticSpend | Tactic türünü kodda belirliyor (`tacticCode.includes('PCT')`) — formül motoruna taşınmalı (dinamik formül kuralı). | 🟠 |

## Uyumlu (parite OK / CTPM üstün)
- RAG aggregation (SKU Red→FU Red, karışık→Amber, hepsi Green→Green) — doğru.
- KPI-seviyesi RAG config-driven (DB `kpis.ragGreen/AmberThreshold`).
- Negatif ROI geçerli.
- Division-by-zero → null (dependency-null propagation; `safeEval` literal `/0` + `!isFinite`).
- **On/Off-Invoice ayrı bütçe — CTPM üstün** (TTM tek envelope).

## Performans
- `finance-reporting`: getPlanPerformance / getSpendTrend / getBudgetAtRisk → N+1 (`planFuRepository.find` döngüde). <500ms riski.
- `SpendCalculationService.calculationCache` tanımlı ama kullanılmıyor (ölü kod).

## Parite Test Matrisi (qa-engineer için)
TTM referans beklenen değerleri: `TTM/apps/api/src/kpi/kpi-engine-v0.spec.ts`, `plans/plans.kpis.spec.ts`.
- **Set A (happy path):** SKU-A(planVol4200,base3200,BPTT4.00,COGS1.80) + SKU-B(3500/2800/3.50/1.50), CPP_ON10/VIS_LS2000/PRICE_SUP0.25 → TTM: TOTAL_SPEND(fu)=6830, INCR_GP=695, GP_ROI≈10.18, RAG=AMBER.
- **Set B (CPP 10→5):** GP_ROI≈39.93, RAG=GREEN.
- **Set C (new-product null base):** lumpsum null base'e pay yok.
- **Set D (div-by-zero):** SPEND=0 → ROI null.
- **Set E (threshold sınırları):** 80/95/100 + admin-config edilebilirlik.
- **Set F (negatif ROI):** INCR_GP=-1000,SPEND=5000 → ROI=-20, RAG=RED.
- **Set G (PLANNED_LTA_ON):** 0 ve 500 enjeksiyonu → null olmamalı.

## İlgili dosyalar
- CTPM: `shared/kpi-engine/`, `shared/spend-calculation/spend-calculation.service.ts`, `shared/finance-reporting/finance-reporting.service.ts`, `shared/budget/`, `modes/planning-first/plan/plan.service.ts`
- TTM: `apps/api/src/kpi/kpi-engine-v0.{ts,spec.ts}`, `plans/plans.kpis.spec.ts`, `budgets/budgets.service.ts`
