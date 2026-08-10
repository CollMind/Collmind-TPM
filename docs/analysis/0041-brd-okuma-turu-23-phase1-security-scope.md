# 0041 — BRD okuma turu **23**: §7.7 Phase 1 Security Scope

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_07_Security_Roles.md` §7.7 (547–599, **tamamı**)
- **Ölçüm ortamı:** meta `9fc9235` · backend `99ee9e6`

---

## 1. ⛔ **RLS Phase 1 özelliği** — D-11 tümüyle cevaplı

```
### ✅ Phase 1 Security Features
Data Security:
- ✅ Multi-tenant isolation (RLS)          ← Phase 1
```

Ve *"❌ Explicitly NOT in Phase 1"* listesi: custom role UI · ABAC · parallel/delegated
approvals · escalation · audit retention · tamper-proof audit · **SSO · MFA · IP
whitelisting**.

> **RLS ertelenenler listesinde YOK; Phase 1 listesinde VAR.**

### D-11 kapanıyor — her iki yarısıyla

| yarı | kaynak | sonuç |
|---|---|---|
| **Tasarım** — RLS gerekli mi | `§7.5`: *"enforced at database level"* + örnek politika | ✅ **evet** |
| **Fazlama** — ne zaman | **`§7.7`: ✅ Phase 1** | ✅ **şimdi** |

> ### `INV-T-003`'ün **VIOLATED** statüsü bilinçli bir faz kararı DEĞİL.
> **Karşılanmamış bir Phase 1 gereksinimidir.** [[T-167]] **P1 olarak kalır**, ve D-11
> bir *"açık karar"* olmaktan çıkıp **iş**e dönüşür.

---

## 2. ✅ [[T-159]]'un dördüncü vakası **ÇÖZÜLDÜ** — ve çıkarımım doğrulandı

Turu 21'de şunu **çıkarım** olarak işaretlemiştim: *"`§7.3` hedef yapıyı gösteriyor; Phase
1'de basit eşik; `OR`'lu çok koşullu yönlendirme ertelenmiş."*

`§7.7` bunu **ölçülebilir hâle getiriyor**:

```
Approval:
- ✅ Sequential approval workflows
- ✅ Threshold-based routing          ← Phase 1
- ✅ Auto-reject conditions           ← Phase 1

❌ NOT in Phase 1 — Advanced Approval:
- ❌ Parallel approvals · Delegated approvals · Escalation rules
```

Ve `§5.7`'nin ertelediği madde: *"**Conditional routing** (if ROI <15%, route to CFO)"*.

| kavram | faz |
|---|---|
| **eşik tabanlı yönlendirme** (`amount_gte`) | ✅ **Phase 1** |
| **auto-reject koşulları** (`gp_roi_pct_lt: 5`) | ✅ **Phase 1** |
| **koşullu yönlendirme** (`OR`'lu, çok koşullu) | ❌ Phase 2 |

> **Çelişki yoktu — iki farklı kavram aynı kelimeyle anılıyordu.** Çıkarım doğrulandı,
> **vaka kapandı.** → T-159'da **iki vaka kaldı**, ve ikisi de aynı soruya bağlı
> (`02_Addendum` ↔ `03_Candidate_Log`).

---

## 3. 🔴 [[T-163]] — turu 15'teki düzeltmem **yanlıştı**, argüman geri geliyor

Zincir:

| tur | ne dedim | dayanak |
|---|---|---|
| **13** | *"auto-reject `<%5` ROI'ye bakıyor → payda farkı onay kararını etkiliyor"* | Glossary |
| **15** | *"bu argüman **Phase 1 için geçersiz**"* | `§5.7` *"conditional routing → Phase 2"* |
| **21** | *"durumu **belirsiz**"* | `§7.3` yapıyı geri getirdi |
| **23** | ✅ **argüman geçerli** | **`§7.7`: `Auto-reject conditions` ✅ Phase 1** |

> **Turu 15'in düzeltmesi yanlıştı.** `§5.7`'nin ertelediği *conditional routing*'i,
> `§7.7`'nin Phase 1'e koyduğu *auto-reject conditions* ile karıştırmıştım — **iki farklı
> kavram**.

### Ve ürün sahibinin tespiti burada üçüncü kez doğrulandı

> *"Bir düzeltme de bir iddiadır."*

| zincir | seyir |
|---|---|
| baseline eşiği | tur 10 (%80) → tur 16 (*"çelişki"*) → **tur 17 (hedef+contingency)** |
| auto-reject | tur 13 → tur 15 (*"geçersiz"*) → tur 21 (*"belirsiz"*) → **tur 23 (geçerli)** |

**İkisinde de ortadaki adım bir düzeltmeydi ve o da yanlıştı.** Ve ikisinde de doğru cevap
**üçüncü/dördüncü** bir belgeden geldi.

**T-163'ün ağırlığı arttı:** payda farkı hem `§10.2` Gate 3'ü gevşetiyor **hem de** Phase
1'de etkin olan `auto_reject_conditions`'ın hangi planları reddedeceğini değiştiriyor.

---

## 4. 🔴 [[T-165]] — yetenek katmanı **Phase 1**, ertelenmemiş

```
Access Control:
- ✅ 5 core roles (Planner, Approver, Finance, Admin, Read-Only)
- ✅ Capability-based permissions (20 capabilities)     ← Phase 1
- ✅ Scope-based filtering (channel, region)            ← Phase 1
- ✅ Conflict-of-interest prevention                    ← Phase 1
```

Ertelenen: **custom role UI** · **dynamic role assignment** · **ABAC**.

> **Yetenek katmanı bir Phase 2 lüksü değil, Phase 1 gereksinimi.** T-165'in ağırlığı
> artıyor — ve `§5.7`'nin *"Policy authoring UI → Phase 2"* sınırıyla aynı şekil:
> **mekanizma Phase 1, arayüzü Phase 2.**

⚠️ **Beş rol:** `Planner · Approver · Finance · Admin · Read-Only`. Bizde **altı**:
`ADMIN · PLANNER · MANAGER · FINANCE · FINANCE_MANAGER · CATEGORY_MANAGER`.
**Eşleme ölçülmedi** — `§7.1 Role Model` okunmadı, iddia yazılmıyor.

⚠️ Ve **`scope: channel, region`** — bizde `channel_id, cpl_id, category_id`. `region`
farkı **üçüncü kez** karşımıza çıkıyor ve **hâlâ ölçülmedi**.

---

## 5. 📌 Audit — Phase 1'de **20 olay tipi**

```
- ✅ Immutable audit logs (20 event types)
- ✅ User action tracking
- ✅ Change history (old/new values)
```

Bizde `admin_audit_logs` var (**16 satır**, ölçüldü). **20 olay tipinin karşılığı
ölçülmedi** — `§7.4 Audit & Traceability` okunmadı.

⚠️ *"Change history (old/new values)"* somut bir şart: eski **ve** yeni değer. Bizim audit
kaydımızın bunu taşıyıp taşımadığı **ölçülmedi**.

---

## 6. Okunmayan

`§7.1` Role Model · `§7.3`'ün kalanı · **`§7.4` Audit & Traceability** · `§7.6`'nın kalanı.

**Section_07: ~235 / 601 (%39).**

---

## 7. Sonraki tur

1. **`§7.4` Audit & Traceability** — 20 olay tipi, old/new değer şartı; audit
   invariantlarının kaynak denetimi
2. `§7.1` Role Model — beş rol ↔ altı rol eşlemesi, ve `region` farkı ([[T-165]])
3. `04_Reviews` ([[T-161]] · [[T-163]]'ün son kaynak adayı)
