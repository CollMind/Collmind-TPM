---
description: staging'den release tag'le ve main'e (production) promote et — üç repoda da
argument-hint: <vX.Y.Z>  (semver, ör. v1.2.0)
---

Release sürümü: **$ARGUMENTS** (semver `vX.Y.Z` beklenir; verilmemişse kullanıcıdan iste).

> Manuel promote akışı (pipeline yok). `main` = production. Tag staging'den atılır.

**ZORUNLU ön koşul (T-212 Kalem 3):** rutin `staging` push'ları `scripts/push-order.sh` ile
yapılır (CLAUDE.md §5) — elle `git push` zinciri **YASAK**. Bu release akışı `staging`'in
zaten `push-order.sh` ile senkronize edildiğini VARSAYAR. Değilse önce onu çalıştır.

**Ön kontroller (HER repo için: collmind.backend, collmind.frontend, kök meta):**
1. Aktif branch `staging` mi? Değilse `git checkout staging`.
2. `staging` temiz mi (uncommitted yok) ve `origin/staging` ile senkron mu?
3. Testler yeşil mi → gerekiyorsa `/qa` çalıştır. Kırıksa **DUR**, release etme.

**Promote (sıra önemli — submodule'ler önce):**
1. **Backend** (`collmind.backend/`): `git tag -a $ARGUMENTS -m "release $ARGUMENTS"` (staging'de) → `git checkout main` → `git merge --no-ff staging` → `git push origin main` → `git push origin $ARGUMENTS` → `git checkout staging`.
2. **Frontend** (`collmind.frontend/`): aynı adımlar.
3. **Doğrulama (ZORUNLU, atlanamaz):** backend ve frontend'in `main` push'unun **origin'de
   gerçekten göründüğünü** ölç — "adım 1-2'nin komutu exit 0 döndü" yeterli değil
   (CLAUDE.md §2.7 #9 ailesi, `push-order.sh`'ın uyguladığı aynı desen):
   `git -C collmind.backend fetch origin main && git -C collmind.backend merge-base --is-ancestor <tag-sha> origin/main`
   (frontend için aynısı). Doğrulanamazsa **DUR** — meta pointer'ı görünmeyen bir commit'e
   bağlama.
4. **Meta-repo** (kök): backend/frontend artık release commit'lerinde VE 3. adımda doğrulandı;
   submodule pointer'larını staging'de güncelle (`git add collmind.backend collmind.frontend && git commit`) → `git tag -a $ARGUMENTS` → `git checkout main` → `git merge --no-ff staging` → `git push origin main` → `git push origin $ARGUMENTS` → `git checkout staging`.

**Sonrası:**
- Üç repoda da `main` artık `$ARGUMENTS` sürümünde. Tag'ler push'landı.
- **Production deploy'u kullanıcı manuel yapar** — bunu açıkça hatırlat.
- `.claude/backlog/BACKLOG.md`'de ilgili sprint/epic'i release'lendi olarak işaretle.

**Güvenlik:** Token'ları çıktıya yazma. `main`'e merge dışında doğrudan commit etme. Her push'tan önce kullanıcı onayı al (dışa dönük işlem).
