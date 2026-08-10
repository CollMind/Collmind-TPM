# 0049 — BRD okuma turu **31**: §3.3 Phase 1 Constraints + §7.1 Role Model — son 🔴

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_03` §3.3 Phase 1 Constraints (732–778) · `Section_07` §7.1 (22–176)
- **Ölçüm ortamı:** meta `5efbf8f` · backend `99ee9e6`

---

## 1. ⛔ [[T-150]] **KAPANDI** — `Committed` bir Phase 2 durumu

`§3.3 Phase 1 Constraints`:

```
Budget State Tracking:
- Allocated (envelope creation)
- Reserved (agreement approval)
- Consumed (ledger posting)
- Available (computed)
                                    ← Committed YOK

❌ Explicitly NOT in Phase 1:
- Committed state (Planning-First introduces this in Phase 2)
```

**T-150'nin bulgusu** (turu 4/15): `v_budget_summary` `RESERVE + COMMIT − RELEASE` ile
`Committed`'ı `Reserved`'in içine katıyor; `§5.5`'in normatif tablosu ikisini **birbirini
dışlar** gösteriyor.

> ### Çözüm: **view Phase 1 modelini uyguluyor.**
> Phase 1'de yalnız `Reserved` var; `Committed` **Phase 2 ile geliyor**. Yani birleştirme
> **Phase 1 için doğru**, Phase 2 için yanlış.
>
> **Ve biz Phase 2 özelliklerini erken inşa ettik** ([[T-169]]) — yani `COMMIT` üreten bir
> kod, `COMMIT`'i tanımayan bir bütçe modeli üzerinde çalışıyor.

**T-150 bir kusur değil — [[T-169]]'un bir SEMPTOMU.** Sıralama kararı verildiğinde
kendiliğinden çözülür: Phase 2'ye geçilirse ayrım açılmalı, Phase 1 tabanına dönülürse
`COMMIT` üretimi durmalı.

→ T-150 **P2 → P3**, ve [[T-169]]'a bağlandı.

---

## 2. ✅ İki eski belirsizlik daha kapandı

### (a) `§4.10`'un *"Overrun approval (hard block at 100%)"* ikircikliği

Turu 3'te çözmeden bırakmış, turu 4'te `§3.3`'ün Overrun Policies'iyle *"muhtemelen (a)"*
demiştim. **Şimdi açık:**

```
❌ Explicitly NOT in Phase 1:
- Overrun approval (hard block at 100%, no exceptions)
🔮 Phase 2: Overrun approval exceptions
```

> **Phase 1 = istisnasız sert blok.** Overrun *onayı* Phase 2. Okuma (a) **doğrulandı**.

### (b) `%90` — `§3.3` **ikinci kez** söylüyor

```
Policies:
- Threshold warning (80% utilization)
- Threshold approval (90% utilization, Finance role)
- Threshold block (100% utilization)
```

| kaynak | orta eşik |
|---|---|
| `§3.3` Budget Policies | **90** |
| **`§3.3` Phase 1 Constraints** | **90** ← ikinci kez |
| `§4.8` | **90** |
| `§10.1` faz kapsam özeti | 95 |
| bizim kod | 95 |

> **`§3.3` iki ayrı yerde 90 diyor.** Turu 27'nin *"`§10.1` bir özet satırı"* çıkarımı
> **güçlendi** — ama hâlâ çıkarım. → [[T-144]]

---

## 3. 🔴 [[T-156]] **güçlendi** — BRD şemanın Phase 1'de de TAM olmasını istiyor

`§3.3`'ün kapanış notu:

> **"Target Architecture Note:** The schema supports all these capabilities **today**
> (JSONB dimensions, **policy engine**, transaction types). **Phase 1 simply constrains
> usage** to the simplest pattern. This enables Phase 2 expansion **without schema
> changes**."

> ### BRD'nin modeli: **şema tam, kullanım dar.**
>
> Yani politika tabloları Phase 1'de de **var olmalı**; Phase 1 onları **basit kullanır**.
> Bizde tablolar **hiç yok** ([[T-156]], altı katman).

⚠️ Bu, T-156'nın *"Phase 1 guardrail"* itirazını **kesin olarak** kapatıyor: guardrail
**kullanımı** kısıtlıyor, **şemayı** değil.

---

## 4. §7.1 Role Model — beş rol, ve `region` sorusu

### Roller

| BRD (Phase 1, 5 rol) | bizde (6 rol) |
|---|---|
| **Planner** | `PLANNER` |
| **Approver (Category Manager)** | `CATEGORY_MANAGER` ? / `MANAGER` ? |
| **Finance Approver** | `FINANCE_MANAGER` ? / `FINANCE` ? |
| **Admin** | `ADMIN` |
| **Read-Only (Analyst / Executive)** | ❌ **karşılığı yok** |

⚠️ **Eşleme belirsiz ve ölçülmedi:** bizdeki `MANAGER` ve `FINANCE`'ın hangi BRD rolüne denk
düştüğü kodda **doğrulanmadı**. *"Fazla rol"* ya da *"eksik rol"* **iddia edilmiyor**;
ölçülen tek şey **`Read-Only`'nin karşılığının bulunmadığı**.

⚠️ Ve BRD'nin *"Typical Users"*ı ilginç: **Planner** rolünün tipik kullanıcıları
*"Category Managers, Key Account Managers, Regional Sales Managers"*. Yani **Category
Manager bir ROL değil, bir ÜNVAN** — bizde ise bir rol enum'u. Bu bir modelleme farkı
olabilir. → [[T-165]]

### `region` — üçüncü sorunun cevabı (kısmen)

`§7.1` Planner **Scope Constraints**:

```
- Channel-based:      atanmış kanallar
- Region-based (optional)
- CPL-based (optional)
```

Bizim `user_scopes`: `channel_id` · `cpl_id` · **`category_id`**

| | BRD | bizde |
|---|---|---|
| channel | ✅ | ✅ |
| **region** | ✅ (opsiyonel) | ❌ |
| cpl | ✅ (opsiyonel) | ✅ |
| **category** | — | ✅ |

Ve `§3.3` **bütçe boyutu** olarak `Region`'ı **Phase 2**'ye koyuyor
(*"❌ Multi-dimensional flexibility (Brand, **Region** dimensions)"*).

> ⚠️ **İki farklı eksen:** `§7.1`'in `region`'ı bir **kullanıcı kapsam filtresi**
> (Phase 1, opsiyonel); `§3.3`'ünki bir **bütçe zarfı boyutu** (Phase 2). Karıştırılmamalı.
>
> **Ölçülen:** bizde `region` yok, `category` var. **Ölçülmeyen:** bunun bilinçli bir
> ikame olup olmadığı. → [[T-165]]

---

## 5. 🔴 Tüm 🔴 kuyruğu **tamamlandı**

| # | parça | sonuç |
|---|---|---|
| 1 | `03_Candidate_Log`'un beş adayı | turu 30 — yedi/yedi Addendum |
| 2 | `§3.3` Phase 1 Constraints | **bu tur** — [[T-150]] kapandı |
| 3 | `§7.1` Role Model | **bu tur** — [[T-165]] beslendi |

**Kalan: 7 parça 🟡 (~1.000 satır, ~3 tur).**

---

## 6. Sonraki tur (🟡)

1. `§9` NFR kısa sondaj — `audit=16`, **`retention=8`**, `500ms=4` ([[T-168]], [[T-157]])
2. `§5.4` What-If — [[T-169]]'un en büyük eksiğinin tarifi
3. `§3.1/3.2` · `§6.3/6.5` · `§11.2`+P2/P3 · `§10.3` · Addendum H5.2/5.3
