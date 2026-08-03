---
description: Backend ve frontend test suite'lerini çalıştır ve sonucu raporla
---

Tam QA koşusu yap (qa-engineer ajanını kullanabilirsin):

1. **Backend** (`collmind.backend/`):
   - `npm run lint`
   - `npm run guards` (finansal doğruluk guard'ları — bloklayıcı, exit 0 bekleniyor;
     `exit 1` = bulgu var, `exit 2` = allowlist parse hatası. Triyaj için
     `GUARD_MODE=report npm run guards` bulguları basıp exit 0 döner.)
   - `npm test` (Jest unit)
   - Gerekirse `npm run test:e2e`
2. **Frontend** (`collmind.frontend/`):
   - `npm run type-check`
   - `npm run lint`
   - `npm test` (Vitest)
3. Sonuçları tablo halinde raporla: her komut için geçti/kaldı + kırılan testlerin gerçek çıktısı.
4. Kırılan varsa kök neden ipucu ver ve **debugger**'a yönlendirilmesini öner.

Gerçek sonuçları raporla — başarısızlığı gizleme.
