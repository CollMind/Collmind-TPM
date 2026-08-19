# `SCOPE_ENFORCEMENT_ENABLED` — `.env.example`'a eklenecek metin

> **Neden burada:** Team Lead'in `.env*` dosyalarına **okuma ve yazma izni yok**
> (dizin koruması, `T-235` turunda karşılaşıldı). Metin hazır; ekleme ürün sahibinin
> ya da izinli bir oturumun işi.
>
> **Hedef dosya:** `collmind.backend/.env.example` (sonuna eklenir)
> **`T-235` kabul şartı:** *"bayrak `.env.example`'a adıyla ve varsayılanıyla yazılır"*

---

## Eklenecek blok — aynen

```dotenv
# ─── Kapsam (scope) zorlaması ────────────────────────────────────────────────
# T-028c · K-2.6.9 ("kapsam filtresi her zaman aktiftir")
#
# 'true' DIŞINDAKİ her değer (ve TANIMSIZ) = KAPALI. Varsayılan bilinçli olarak
# kapalı: açıldığı anda kapsam satırı OLMAYAN her PLANNER "her şeyi kaybeder"
# (fail-closed, AccessScopeService R-2).
#
# ⚠️ Bu bayrak YALNIZ PLANNER'ı etkiler. ADMIN/FINANCE kod dalıyla koşulsuz
# UNRESTRICTED (access-scope.service.ts UNRESTRICTED_ROLES); READONLY T-235
# ADIM 2'de o daldan çıktı (ff1f85f) ve joker kapsam satırıyla çözülüyor.
#
# ⚠️ Ve bu satır yazılana kadar bayrak HİÇBİR YERDE görünmüyordu — bir ortam
# kuran kişi varlığını bilemezdi (T-235 ölçümü, 2026-08-17: .env 0 anahtar ·
# .env.example yok · docker-compose yok).
SCOPE_ENFORCEMENT_ENABLED=false
```

---

## Doğrulanmış olgular — bu metindeki her iddia ölçüldü

| iddia | ölçüm |
|---|---|
| varsayılan `false` | `access-scope.service.ts:118` — `config.get('SCOPE_ENFORCEMENT_ENABLED') === 'true'`; başka her değer **false** |
| yalnız `PLANNER`'ı etkiler | `resolveScope`: `UNRESTRICTED_ROLES` (ADMIN·FINANCE) önce döner; bayrak kontrolü **yalnız** `role === PLANNER` dalında |
| `READONLY` artık dalda değil | `ff1f85f` — `UNRESTRICTED_ROLES = {ADMIN, FINANCE}` |
| hiçbir yerde tanımlı değil | `.env` `0` anahtar · `.env.example` `0` · `docker-compose*.yml` `0` (2026-08-17) |

## ⚠️ Eklendikten sonra — `T-235`'te işaretlenecek

Bu blok `.env.example`'a girdiğinde `T-235`'in ilgili kabul satırı `[x]` olur.
**Değeri `true` yapmak AYRI bir karardır** — etkisi `T-235`'te ölçülü:
iki planlamacı `29/29` CPL'den `11/29` ve `17/29`'a daralır.
