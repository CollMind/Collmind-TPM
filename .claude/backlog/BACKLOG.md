# CollMind — Paylaşılan Backlog (Sprint / Epic / Task)

> **Bu dosya git'e commit'lenir ve tüm ekip + agentlar arasında paylaşılır.**
> Team Lead her yeni görevte ÖNCE buraya bakar; aynı/benzer task varsa YENİ açmaz, mevcudu devam ettirir.
> Her oturum başında SessionStart hook'u bu dosyayı context'e enjekte eder.

---

## Dosya Şablonları

### Task — `.claude/backlog/tasks/<id>.md`
```markdown
---
id: T-001
title: Kısa başlık
epic: E-001            # bağlı epic id (yoksa boş)
sprint: S-001          # aktif sprint id (yoksa boş)
status: todo           # todo | in-progress | review | done | blocked
assignee: backend-engineer   # bir subagent adı
created: 2026-05-29
updated: 2026-05-29
---

## Açıklama
Ne yapılacak.

## Acceptance Criteria
- [ ] ...

## İlgili
- Dosya/PR/branch linkleri, bağımlı task'lar ([[T-002]])
```

### Epic — `.claude/backlog/epics/<id>.md`
```markdown
---
id: E-001
title: Epic başlığı
sprint: S-001
status: todo
created: 2026-05-29
updated: 2026-05-29
---

## Hedef
## Kapsadığı Task'lar
- [[T-001]]
```

### Sprint — `.claude/backlog/sprints/<id>.md`
```markdown
---
id: S-001
title: Sprint başlığı
start: 2026-05-29
end: 2026-06-12
status: active        # planned | active | closed
---

## Hedef
## Kapsadığı Epic'ler
- [[E-001]]
```

---

## Aktif Sprint
- [[S-001]] Konsolidasyon Sprint 1 — 2026-06-23 → 2026-07-07 — `active`

## Epic'ler
- [[E-001]] TTM'i Collmind-TPM'e konsolide et, ana ürünü olgunlaştır — `in-progress`

## Açık Task'lar (todo / in-progress / review)
| ID | Başlık | Öncelik | Assignee | Durum |
|---|---|---|---|---|
| [[T-013]] | CLOSED agreement ↔ reversal etkileşimi (re-open/reversible) | P2 | architect | todo |
| [[T-014]] | Transactional audit (reversal+settlement queryRunner-aware) | P1 | backend-engineer | todo |
| [[T-006]] | Reports olgunlaştırma | P1 | backend-engineer | todo |
| [[T-009]] | Gap audit (attachments/baseline/cap/sales) | P2 | planner | todo |
| [[T-010]] | Wella demo dataset (CTPM) | P1 | data-engineer | in-progress (ürün ✅, actuals→T-020) |
| [[T-021]] | CSV parser konsolidasyonu + entity kaydı tek kaynağa | P2 | backend-engineer | todo |
| [[T-022]] | Actuals ↔ agreement eşleştirme + recognition-exceptions | P2 | architect | todo |
| [[T-023]] | Plan-vs-Actual varyans raporu (finance-reporting) | P1 | backend-engineer | todo |
| [[T-024]] | Baseline türetme (actuals→BASE_VOL) — BRD onayı şart | P3 | architect | **blocked** |
| [[T-025]] | Frontend actuals upload ekranı + batch geçmişi | P1 | frontend-engineer | todo |
| [[T-033]] | Rejected → Draft geçişi yok (BRD state machine eksiği) | P1 | backend-engineer | todo |
| [[T-031]] | Encumbrance relief (ACTIVE dönem çifte blokaj) | P2 | architect | todo |
| [[T-032]] | Agreement lifecycle audit eksikliği (BRD ihlali) | **P1** | backend-engineer | todo |
| [[T-028]] | RBAC/BRD hizalaması (CM onay + Planner scope + rol matrisi) | P1 | architect | todo |
| [[T-011]] | TTM repo freeze formalizasyonu (README+tag/archive) | P2 | architect | todo |
| [[T-015]] | Cap kontrolü reversed tx semantiği (BRD karar) | P1 | architect | todo |
| [[T-016]] | Playwright UI E2E suite (14 senaryo) | P1 | qa-engineer | todo |
| [[T-019]] | On/Off-Invoice ayrı envelope bütçe kontrol/rezervasyon | P1 | backend-engineer | todo |

## Tamamlanan (done)
- [[T-030]] Agreement bütçe rezerv sızıntısı — net-tabanlı ortak release motoru + backfill (17 agreement, 395.000 iade); code-review 5. çift-sayım hatasını yakaladı (plan tarafı da ortak motora devredildi) — `backend-engineer` — 2026-07-28
- [[T-029]] Plan onay audit + reserve/commit semantiği — approve/reject artık history yazıyor; submit→RESERVE, approve→COMMIT; **onaylı planların bütçeyi düşürmediği ikinci sızıntı** kapatıldı (migration 1789) — `backend-engineer` — 2026-07-27
- [[T-027]] KPI eksik-veri kuralı — COGS null → ROI/RAG null (sahte %100/GREEN bitti); migration 1788; bonus: cleanup FK fix + reseed-dayanıklı e2e; T-030 zarf sızıntısı bulundu — `backend-engineer` — 2026-07-27
- [[T-026]] Planning-first akış onarımı — entity kaydı + 2 migration + DecimalTransformer (string `>=`/`+=` bug'ları); submit→approve→bütçe SQL kanıtlı; role-journey 43/43 — `backend-engineer` — 2026-06-24
- [[T-020]] Actuals (satış) modülü portu — sales-actuals modülü + migration 1785; ledger sınırı 5 katman + DB kanıtı; hard-delete yerine versiyonlama; Wella actuals yüklü — `backend-engineer` — 2026-06-24
- [[T-018]] Planlama mechanic master-data seed — CPP/VIS_LS/PRICE_SUP/DISPLAY spendingType/category/mechanicType + backfill migration (0 NULL); SpendCalc routing doğrulandı — `data-engineer` — 2026-06-24
- [[T-017]] SpendCalc parite tamamlama — includes('PCT') hardcode → mechanic config-driven; baseTo NIV; tenant-scope bug'ı yakalandı — `backend-engineer` — 2026-06-24
- [[T-012]] Budget/RAG threshold config-driven — BudgetThresholdService (tenant-scoped, fallback) + migration; 4 tüketici hardcode kaldırıldı; YELLOW→AMBER (backend+frontend); on-invoice 95-100→RED (BRD) — `backend-engineer` — 2026-06-24
- [[T-008]] Finansal-doğruluk paritesi — KPI/ROI BRD'ye getirildi (GP_ROI=INCR_GP/INCR_SPEND, NIV turnover); sayısal kanıt Set A ROI=%10.18; circular dep + hardcode fallback'ler temizlendi — `data-analyst ∥ backend` — 2026-06-24
- [[T-007]] E2E suite (backend supertest) — auth/reversal/settlement/dashboard 51 test; kritik user_scopes tablo eksikliği bug'ı yakalandı+düzeltildi — `qa-engineer` — 2026-06-24
- [[T-005]] Dashboard port — shared/dashboard orchestrator (finance-reporting reuse, no-recompute) + frontend persona kartları; polymorphic approval count bug'ı yakalandı — `backend ∥ frontend` — 2026-06-24
- [[T-004]] Settlements derinleştirme — summary + close (state geçişi, budget'a dokunmaz); tenant-sızıntısı bug'ı yakalandı — `backend-engineer` — 2026-06-24
- [[T-003]] Reversals akışı port — reversal modülü + ledger CREDIT + audit; çift-restore bug'ı yakalandı — `backend-engineer` — 2026-06-24
- [[T-002]] Karar & dondurma — CTPM ana ürün kararı (ADR + governance) — `architect` — 2026-06-24
- [[T-001]] Wella Customer.xlsx'ten CPL + müşteri master-data tanımı — `backend-engineer` — 2026-06-23
