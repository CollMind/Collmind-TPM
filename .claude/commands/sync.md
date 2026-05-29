---
description: Backend/frontend submodule'lerini Bitbucket'tan güncelle ve durum raporu ver
---

Projeyi güncel tut:

1. Submodule durumunu göster: `git submodule status`
2. Her submodule'de iş branch'ini (`staging`) çek:
   - `git -C collmind.backend pull` (branch: `staging`)
   - `git -C collmind.frontend pull` (branch: `staging`)
   (İş `staging`'de yapılır; `main` = production, yalnızca release ile güncellenir.)
3. Çekilen yeni commit'leri özetle (her repo için `git -C <dir> log --oneline -5`).
4. Kök repo'da submodule pointer değiştiyse bildir; kullanıcı isterse pointer güncellemesini commit et.
5. Çalışan tree'de uncommitted değişiklik var mı raporla (`git status` + her submodule).

Token sızdırma — remote URL'lerini çıktıya yazma. Sadece özet ver.
