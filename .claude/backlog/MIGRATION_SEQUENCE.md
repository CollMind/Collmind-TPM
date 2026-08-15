# Migration numara tahsisi

Ajan kendi numarasını SEÇMEZ. Team Lead buradan tahsis eder ve satırı işaretler.
Sebep: T-030/T-028'de 1790 iki kez alındı (elle yakalandı).

| Numara | Task | Durum |
|---|---|---|
| 1795000000000 | AddSpendTypeToBudgetDimensions | kullanıldı |
| 1796000000000 | ADR 0007 F2/C1 — SplitPlanMechanicEnteredValue (expand) | kullanıldı |
| 1797000000000 | ADR 0007 F2/C2 — DropEnteredValue (contract) | **kullanıldı** — `1803000000000-BDalgasiSemaKalemleri.ts`, run/revert/run boş VE seed'li ortamda doğrulandı |
| 1798000000000 | T-095 — budget_transaction_logs.idempotency_key kısmi UNIQUE (`WHERE key IS NOT NULL`) | kullanıldı |
| 1799000000000 | T-101 — budget_alert_configurations: threshold_percent aralık CHECK (**yalnız CHECK**; kısmi UNIQUE taslağı kapsam dışı olduğu için çıkarıldı → T-108) | kullanıldı |
| 1800000000000 | [[T-141]] / ADR 0009 — mechanics.max_combined_discount_percentage: `CHECK (IS NULL OR > 0)` | **kullanıldı** — `1803000000000-BDalgasiSemaKalemleri.ts`, run/revert/run boş VE seed'li ortamda doğrulandı |
| 1801000000000 | [[T-163]] / **ADR 0011** — GP_ROI_PCT paydası `INCR_SPEND` → `TOTAL_PLANNED_SPEND` (1780 geriye dönük düzenlenmez) | kullanıldı |
| 1802000000000 | **ADR 0012** / [[T-188]] — finansal FK'lar: `purge → agreement_id FK → RESTRICT (⛔ kovası + tenants + */users) → budget_envelopes.deleted_at (zaten vardı, aksiyon yok)`. ⚠️ `tenants` DAHİL — T-188 "Migration issue gövdesi" not 3, offboarding yolu [[T-195]]'te tanımlanana kadar `tenants` de `RESTRICT` | kullanıldı — `1802000000000-FinancialFkRestrictAndLedgerOrphanPurge.ts`, run/revert/run doğrulandı |
| 1803000000000 | [[T-211]] / **`B` dalgası** — `EK_C §B dalgası — kanonik kalem listesi`'nin `S1`–`S14` + `R1`–`R3` kalemleri. ⚠️ **TEK migration, TEK `down`** (ürün sahibi kısıtı: tek geri dönüş noktası). Seed ayrı ve **atomik**. `S3` DÜŞTÜ, uygulanmaz | kullanıldı — `1803000000000-BDalgasiSemaKalemleri.ts`, run/revert/run (boş + seed'li ortamda) doğrulandı. `S13` migration'da yok (servis işi, [[T-207]]). S10 tablo-seçimi (`budget_transactions` vs `ledger_entries`) data-engineer yorumu — Team Lead onayına açık, final rapora bkz. |
| 1804000000000 | [[T-218]] — `plans.coverage_ratio` `numeric(9,4)` nullable. Değer ZATEN hesaplanıyor (`kpi-engine.calculatePlan`), `plan.service.ts:2621-2659` onu atıyor. ⚠️ `calculated_kpis` JSONB **açılmaz** — bugün ihtiyaç olmayan şema esnekliği (`İlke 1`) | kullanıldı — `1804000000000-AddCoverageRatioToPlans.ts`, run/revert/run içerikten doğrulandı; `plan.entity.ts` + `plan.service.ts` (GP_ROI_PCT.coverageRatio pass-through, recompute değil) aynı PR'da. ⚠️ mode-split guard'ı `plan.service.ts`'i BÜYÜDÜ diye işaretliyor (2977→2990, +13 satır) — bu task'ın ürün sahibi talimatının doğrudan sonucu; baseline güncellemesi Team Lead kararına bırakıldı, ben commit etmedim. |
| 1805000000000 | [[T-225]] — `DROP TABLE main.budget_reservations` + `DROP TYPE`. Karar: **ölü iskele** (architect ölçümü 2026-08-15: entity hiçbir listeye HİÇ eklenmemiş, 0 INSERT yolu, TTM'de karşılığı yok, `K-2.5.7` ile uyumsuz). ⚠️ `Alan A` — `money-float --ratchet` koşulur. ⚠️ `down()` tabloyu `1704067560000` ile **birebir** geri kurmalı. ⚠️ `cleanup-data.ts:63` AYNI dalgada temizlenmeli, yoksa `42P01` | tahsis edildi |
