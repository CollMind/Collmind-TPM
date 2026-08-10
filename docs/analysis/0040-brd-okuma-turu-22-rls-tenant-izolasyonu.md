# 0040 — BRD okuma turu **22**: §7.5 Data Security & Isolation — **D-11 bir karar değil, bir eksik**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_07_Security_Roles.md` §7.5 (487–531) · §7.6 (533–545)
- **Ölçüm ortamı:** meta `a3e39ad` · backend `99ee9e6` · dev DB `main`, port 5434

---

## 1. ⛔ BRD **RLS'i zorunlu kılıyor** — ve tartışmaya yer bırakmıyor

```
Tenant Isolation:
- Every table has `tenant_id` column
- Row-Level Security (RLS) enforced at database level
- No cross-tenant data visibility (even for admins)
```

Ve somut politika örneğiyle:

```sql
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON plans
  USING (tenant_id = current_setting('app.current_tenant')::UUID);
```

### ⚠️ Ve uygulama filtresi **yerine değil, EK olarak**

Hemen ardından:

```typescript
// Every query must filter by tenant_id
where: { tenant_id: currentUser.tenant_id, // Required!
         channel: 'NKA' }
```

> **BRD ikisini birden istiyor: DB seviyesinde RLS + uygulama seviyesinde predicate.**
> Derinlemesine savunma. *"Uygulama filtresi yeterli"* seçeneği kaynakta **yok**.

Ve *"even for admins"* ifadesi tipik olandan **daha güçlü**: admin rotalarımız bugün
uygulama filtresine güveniyor, yani bir admin yolundaki hata tenant sınırını aşabilir.

---

## 2. Ölçüm — `INV-T-003`'ün kanıtı bugün de aynı

```sql
-- şema-nitelendirilmiş
0 / 43 tabloda RLS etkin
0 politika  (pg_policies WHERE schemaname='main')
```

`SYSTEM_INVARIANTS` `INV-T-003` — **🔴 VIOLATED**, *"Evidence: 0 RLS policies, 0 tables with
`rowsecurity`"*. **Değişmemiş.**

---

## 3. 🔴 **D-11 yeniden çerçevelendi: karar değil, yapılmamış iş**

`SYSTEM_INVARIANTS §9`:

```
| D-11 | RLS requirement | INV-T-003 | Second-customer gate |
```

ve `INV-T-003`'ün remediation'ı: *"**blocked on D-11**."*

> **D-11 bir açık karar olarak kaydedilmişti** — *"RLS gerekli mi?"* Ürün sahibinin
> tarifiyle iki olasılık vardı: BRD zorunlu kılıyorsa sapma, uygulama filtresini yeterli
> sayıyorsa D-11 yeniden çerçevelenir.
>
> **Ölçüm birinciyi gösteriyor.** `§7.5` RLS'i *"enforced at database level"* diye yazıyor,
> örnek politikayı veriyor, ve uygulama filtresini **ek** olarak istiyor.
>
> ### Yani D-11'in **tasarım sorusu cevaplı**: RLS zorunlu.
> `INV-T-003`'ün *"blocked on D-11"* blokajı **bu yönüyle kalkıyor** — geriye bir karar
> değil, **yazılmamış bir koruma** kalıyor.

### ⚠️ Ama bir yarısı hâlâ açık — ve o yarı ölçülmedi

D-11'in notu *"**Second-customer gate**"* diyor. Bu bir **tasarım** sorusu değil, bir
**fazlama** sorusu: *"RLS ne zaman gerekli — ilk müşteride mi, ikincide mi?"*

**`§7.7 Phase 1 Security Scope` OKUNMADI.** Fazlama cevabı orada olabilir.

> **Tasarım sorusu cevaplı, fazlama sorusu ölçülmedi.** D-11 tümüyle kapanmıyor —
> **ikiye bölünüyor.**

→ [[T-167]]

---

## 4. 📌 Ve bu, [[T-156]]'nın çerçevesine bir **düzeltme** getiriyor

T-156'nın gerekçesi şuydu:

> *"Bu, ikinci müşteri sorusunun gerçek hâli — **RLS'ten önce gelen**. İzolasyon olsa bile
> her müşteri için kod değiştirmek gerekir."*

**Doğru ama eksik:** ölçüm gösteriyor ki **izolasyonun kendisi de yok**. Yani iki iş
**paralel**, biri diğerinden önce değil:

| | durum |
|---|---|
| **Veri ayrımı** (RLS) | ❌ 0/43 tablo — `INV-T-003` VIOLATED |
| **Davranış konfigürasyonu** (beş politika tablosu) | ❌ [[T-156]] |

> İkinci müşteri **ikisini birden** gerektiriyor. T-156'nın *"RLS'ten önce gelen"* ifadesi
> bir **öncelik iddiasıydı** ve ölçülmemişti — düzeltildi.

---

## 5. 📌 §7.6 Session Management — ölçülmedi, kayda geçer

```
Idle timeout: 30 dk · Absolute: 8 saat · Concurrent sessions: izinli
Logout → anında · Şifre değişimi → tüm oturumlar · ROL DEĞİŞİMİ → tüm oturumlar
```

Sonuncusu dikkat çekici: **rol değişince tüm oturumlar geçersiz** — bir güvenlik önlemi, ve
bizde karşılığı **ölçülmedi**.

⚠️ Bu turda ölçmedim çünkü ayrı bir alan (oturum yönetimi) ve açık bir task'la kesişmiyor.
**Kayda geçiyor**, iddia edilmiyor.

---

## 6. Okunmayan

`§7.1` Role Model · `§7.3`'ün kalanı · `§7.4` Audit & Traceability · **`§7.7` Phase 1
Security Scope** · `§7.6`'nın kalanı.

**Section_07: ~180 / 601 (%30).**

---

## 7. Sonraki tur

1. **`§7.7` Phase 1 Security Scope** — [[T-167]]'nin fazlama yarısı **doğrudan orada**
2. `§7.4` Audit & Traceability — audit invariantları
3. `§7.1` Role Model + `§7.3` kalanı — [[T-165]] · [[T-153]]
4. `04_Reviews` ([[T-161]] · [[T-163]]'ün son adayı)
