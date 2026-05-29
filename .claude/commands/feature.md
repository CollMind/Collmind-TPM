---
description: Bir feature'ı uçtan uca orkestre et (planner → architect → backend ∥ frontend → qa → review)
argument-hint: <feature açıklaması>
---

Team Lead olarak şu feature'ı orkestre et: **$ARGUMENTS**

Adımlar:

1. **Dedup kontrolü:** `.claude/backlog/BACKLOG.md` ve `tasks/` içinde bu işle ilgili mevcut task var mı bak. Varsa onu devam ettir, yoksa devam et.
2. **planner** ajanını çağır → epic + task'lara böl, BRD ile hizala. Çıktıyı `.claude/backlog/` altında epic/task dosyalarına yaz, `BACKLOG.md` indeksini güncelle (her task'a `assignee` ata).
3. **architect** ajanını çağır → tasarımı onayla. ❌ uyumsuzsa plana dön, ⚠️ koşulluysa notları task'lara ekle.
4. **Implementasyon (paralel):** backend ve frontend işleri bağımsızsa **backend-engineer** ve **frontend-engineer**'ı **tek mesajda paralel** başlat. Bağımlıysa sırala. İlgili task'ları `in-progress` yap.
5. **qa-engineer** ajanını çağır → testleri yaz/çalıştır, sonucu doğrula. Kırılırsa **debugger**'a yönlendir.
6. **code-reviewer** ajanını çağır → diff review. 🔴 blocker varsa düzelttir.
7. Task'ları `done` yap, `BACKLOG.md`'yi senkronla. Commit/push için **kullanıcı onayı** iste (feature branch, Co-Authored-By footer).

Her adımda kısa durum özeti ver. Bağımsız işleri mümkün olduğunca paralelleştir.
