---
description: Günlük durum özeti — backlog, son commit'ler, açık branch'ler
---

Ekip standup özeti çıkar:

1. **Backlog:** `.claude/backlog/BACKLOG.md`'den aktif sprint, açık (`todo`/`in-progress`/`review`) ve son tamamlanan task'ları özetle. Her açık task için `assignee` ve durum.
2. **Repo durumu:** her submodule için son 5 commit (`git -C <dir> log --oneline -5`), aktif branch, uncommitted değişiklik var mı.
3. **Açık branch'ler:** `git -C <dir> branch -a` (lokal feature branch'ler).
4. **Önericeler:** bugün nelere odaklanılmalı (blocked task'lar, review bekleyenler).

Kısa, tarayıcı dostu bir özet ver. Token sızdırma.
