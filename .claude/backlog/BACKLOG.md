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
| [[T-002]] | Karar & dondurma (CTPM ana ürün, TTM legacy) | P0 | architect | blocked (TTM freeze) |
| [[T-003]] | Reversals akışı port | P0 | backend-engineer | todo |
| [[T-004]] | Settlements derinleştirme | P0 | backend-engineer | todo |
| [[T-005]] | Dashboard modülü port | P1 | backend ∥ frontend | todo |
| [[T-006]] | Reports olgunlaştırma | P1 | backend-engineer | todo |
| [[T-007]] | E2E suite kurulumu (0→14 senaryo) | P0 | qa-engineer | todo |
| [[T-008]] | Finansal-doğruluk paritesi | P0 | qa-engineer ∥ data-analyst | todo |
| [[T-009]] | Gap audit (attachments/baseline/cap/sales) | P2 | planner | todo |
| [[T-010]] | Wella demo dataset (CTPM) | P1 | data-engineer | todo |

## Tamamlanan (done)
- [[T-001]] Wella Customer.xlsx'ten CPL + müşteri master-data tanımı — `backend-engineer` — 2026-06-23
