---
description: Bir bug'ı orkestre et (debugger → qa regresyon → review)
argument-hint: <bug açıklaması / hata>
---

Team Lead olarak şu bug'ı çöz: **$ARGUMENTS**

1. **Dedup:** `.claude/backlog/` içinde bu bug için açık task var mı bak; yoksa bir task oluştur (`assignee: debugger`), `BACKLOG.md`'ye ekle, `in-progress` yap.
2. **debugger** ajanını çağır → kök neden analizi + minimal fix + regresyon testi.
3. **qa-engineer** ajanını çağır → regresyon ve ilgili test suite'ini çalıştır, fix'i doğrula.
4. **code-reviewer** ajanını çağır → diff review.
5. Task'ı `done` yap, `BACKLOG.md`'yi güncelle. Commit/push için kullanıcı onayı iste.

Kök neden, uygulanan fix ve test sonucunu net raporla.
