# 0042 — BRD okuma turu **24**: §7.4 Audit & Traceability — **`INV-A-*` ailesi yok**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_07_Security_Roles.md` §7.4 (374–485, tamamı)
- **Ölçüm ortamı:** meta `a222633` · backend `99ee9e6` · dev DB `main`

---

## 1. ✅ Ürün sahibinin öngörüsü doğrulandı: **audit invariant ailesi yok**

**Ölçüm** (`SYSTEM_INVARIANTS`'taki invariant aileleri):

```
B- = 7   ·   L- = 9   ·   M- = 3   ·   N- = 3   ·   R- = 8   ·   T- = 3   ·   X- = 1
INV-A-*  =  0
```

> **Yedi aile var, audit için hiçbiri.** `AdminAuditService` yazıldı, [[T-096]]'da
> kullanıldı, ama sözleşme katmanı onu **hiç kapsamadı**.

Ve `§7.4` bu boşluğu **ölçülebilir** hâle getiriyor: **20 çekirdek olay tipi**, her biri
adıyla ve loglanacak verisiyle listeli. Yani artık *"her işlem loglanmalı"* gibi bir
temenni değil, **sayılabilir bir sözleşme** var.

---

## 2. Şema karşılaştırması — özde uyumlu, sözlükte değil

| BRD `audit_logs` | bizde `admin_audit_logs` |
|---|---|
| `event_type` (20 tipten biri) | `action_type` — **serbest metin**, sözlük yok |
| `entity_type` · `entity_id` | ✅ aynı |
| `user_id` · `user_email` · `user_role` | `admin_id` · `admin_email` · ⚠️ **rol yok** |
| `action` (`CREATE`/`APPROVE`/…) | `action_type` ile birleşmiş |
| `changes JSONB` *(Old → New)* | ✅ **`before_values` + `after_values`** — iki kolon, **özde aynı** |
| `metadata JSONB` | ⚠️ yok — yerine `justification`, `is_high_risk`, `alert_sent` |
| `ip_address` | ✅ | 
| `user_agent` | ❌ yok |
| — | 🆕 `result` (`SUCCESS`/`FAILURE`), `justification`, `is_high_risk`, `alert_sent` |

> **`changes` şartı karşılanıyor.** `§7.7`'nin *"Change history (**old/new values**)"*
> maddesi bizde iki ayrı kolonla var — **bu bir sapma değil, bir biçim farkı.**
>
> Ve bazı alanlarımız BRD'den **zengin** (`is_high_risk`, `alert_sent`, `justification`).

---

## 3. 🔴 Asıl fark: **kapsam** — `admin_audit_logs` adıyla söylüyor

BRD'nin 20 olayı **admin işleriyle sınırlı değil**:

```
PLAN_CREATED · PLAN_EDITED · PLAN_SUBMITTED · PLAN_APPROVED · PLAN_REJECTED · PLAN_CANCELLED
AGREEMENT_CREATED · AGREEMENT_APPROVED
BUDGET_ALLOCATED · BUDGET_RESERVED · BUDGET_COMMITTED · BUDGET_CONSUMED
INVOICE_IMPORTED · BASELINE_IMPORTED
KPI_CONFIGURED · POLICY_CONFIGURED
USER_LOGIN · USER_LOGOUT · PERMISSION_DENIED · EXPORT_DATA
```

Bizim tablonun adı **`admin_audit_logs`** ve alan adı **`admin_id`**. Yani tasarım gereği
**yönetici işlemlerine** odaklı.

**Dev verisinde kayıtlı `action_type` değerleri** (16 satır):

```
APPROVE × 1   ·   SALES_ACTUALS_UPLOAD × 12   ·   SUBMIT × 1   ·   UPDATE × 2
```

⚠️ **Dördü de BRD'nin sözlüğünde YOK** — ve bu bir *"eksik"* iddiası değil: bizim
sözlüğümüz **farklı** (`SALES_ACTUALS_UPLOAD` ↔ BRD'nin `BASELINE_IMPORTED`/
`INVOICE_IMPORTED`'ı gibi).

### ⚠️ Ölçülen ve ölçülmeyen

| | |
|---|---|
| **ölçüldü** | dev DB'de **dört** farklı `action_type`; audit yazan **10 dosya**; `action_type` için **enum yok** (entity'deki tek enum `result`: `SUCCESS`/`FAILURE`) |
| **ölçülmedi** | kodun **üretebileceği** tüm tipler (dev verisi kullanımın izidir, yeteneğin değil); `PLAN_*` olaylarının loglanıp loglanmadığı |

> *"Şu olay loglanmıyor"* **iddiası yazmıyorum** — 10 dosyanın tamamı okunmadı.

---

## 4. 📌 CLAUDE.md §2.3'ün audit maddesi — kaynakla karşılaştırılabilir hâle geldi

§2.3: *"**Audit:** immutable; silinemez/güncellenemez; **onay/red dahil her işlem
loglanır**."*

`§7.4` bunun **somut** hâlini veriyor: 20 olay, her birinin loglanacak verisiyle.

> **§2.3'ün *"her işlem"*i bir temenniydi; artık bir liste var.** Ve o liste bizim
> `admin_audit_logs`'umuzun kapsamından **geniş** (login/logout, permission denied, export
> — hiçbiri admin işi değil).

⚠️ Ve `INV-L-003` (*"hiçbir ledger satırı silinemez"*) audit'in **immutability** yarısını
ledger için karşılıyor; `admin_audit_logs` için **karşılık yok** — ne invariant, ne guard.

---

## 5. Yeni task: `INV-A-*` ailesi

`§7.4` bir sözleşme veriyor ve bizde onu tutan hiçbir şey yok. → [[T-168]]

Aday invariantlar (öneri değil, kaynaktan türetilebilir olanlar):

| aday | kaynak |
|---|---|
| Audit satırı **güncellenemez/silinemez** | *"Immutable record"* + `§7.7` *"Immutable audit logs"* |
| Her onay/red **bir audit satırı üretir** | 20 olayın altısı `PLAN_*`/`AGREEMENT_*` onay-red |
| `EDIT` olayları **old/new** taşır | `changes JSONB` + `§7.7` *"old/new values"* |
| `PERMISSION_DENIED` loglanır | 20 olaydan biri — ⚠️ **bizde karşılığı ölçülmedi** |

⚠️ **Hangilerinin uygulanacağı bir karar**; bu doküman yalnız kaynaktan türetilebilir
olanları sayıyor.

---

## 6. Okunmayan

`§7.1` Role Model · `§7.3`'ün kalanı · `§7.6`'nın kalanı.

**Section_07: ~350 / 601 (%58).**

---

## 7. Sonraki tur

1. `§7.1` Role Model — beş rol ↔ altı rol, ve `region ↔ category` (üçüncü kez) ([[T-165]])
2. `§7.3`'ün kalanı — [[T-153]]
3. **`04_Reviews`** (5.249) — [[T-161]] · [[T-163]]'ün **son** kaynak adayı
