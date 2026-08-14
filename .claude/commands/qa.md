---
description: Backend ve frontend test suite'lerini çalıştır ve sonucu raporla
---

Tam QA koşusu yap (qa-engineer ajanını kullanabilirsin):

1. **Backend** (`collmind.backend/`):
   - `npm run lint`
   - `npm run guards` (finansal doğruluk guard'ları — bloklayıcı, exit 0 bekleniyor;
     `exit 1` = bulgu var, `exit 2` = **kurulum hatası / ölçüm yapılmadı** — bulgu değil.
     Tek üretici allowlist parse hatası değildir (T-212): bir alt guard koşamadı, ya da
     money-float SKIPPED (domain listesi yok/boş) da aynı kodu döner. `exit 2` çıktısında
     hangisi olduğu `=== <guard> ===` bloğunun altındaki satırdan okunur. Triyaj için
     `GUARD_MODE=report npm run guards` bulguları basıp exit 0 döner — ama bu yalnız
     `exit 1` (bulgu) durumu içindir, `exit 2`'yi (kurulum hatası) rapor moduna düşürmez.)
   - `npm test` (Jest unit)
   - Gerekirse `npm run test:e2e`
2. **Frontend** (`collmind.frontend/`):
   - `npm run type-check`
   - `npm run lint`
   - `npm test` (Vitest)
3. Sonuçları tablo halinde raporla: her komut için geçti/kaldı + kırılan testlerin gerçek çıktısı.
4. Kırılan varsa kök neden ipucu ver ve **debugger**'a yönlendirilmesini öner.

Gerçek sonuçları raporla — başarısızlığı gizleme.
