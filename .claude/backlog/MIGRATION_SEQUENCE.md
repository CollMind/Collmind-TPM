# Migration numara tahsisi

Ajan kendi numarasını SEÇMEZ. Team Lead buradan tahsis eder ve satırı işaretler.
Sebep: T-030/T-028'de 1790 iki kez alındı (elle yakalandı).

| Numara | Task | Durum |
|---|---|---|
| 1795000000000 | AddSpendTypeToBudgetDimensions | kullanıldı |
| 1796000000000 | ADR 0007 F2/C1 — SplitPlanMechanicEnteredValue (expand) | kullanıldı |
| 1797000000000 | ADR 0007 F2/C2 — DropEnteredValue (contract) | tahsis edildi |
| 1798000000000 | T-095 — budget_transaction_logs.idempotency_key kısmi UNIQUE (`WHERE key IS NOT NULL`) | kullanıldı |
| 1799000000000 | T-101 — budget_alert_configurations: threshold_percent aralık CHECK (**yalnız CHECK**; kısmi UNIQUE taslağı kapsam dışı olduğu için çıkarıldı → T-108) | kullanıldı |
| 1800000000000 | [[T-141]] / ADR 0009 — mechanics.max_combined_discount_percentage: `CHECK (IS NULL OR > 0)` | tahsis edildi |
| 1801000000000 | [[T-163]] / **ADR 0011** — GP_ROI_PCT paydası `INCR_SPEND` → `TOTAL_PLANNED_SPEND` (1780 geriye dönük düzenlenmez) | kullanıldı |
| 1802000000000 | **ADR 0012** / [[T-188]] — finansal FK'lar: `purge → agreement_id FK → RESTRICT → budget_envelopes.deleted_at`. ⛔ `*/tenants` HARİÇ ([[T-195]]) | tahsis edildi — **ön koşullar kapanmadan `data-engineer`'a verilmez** |
