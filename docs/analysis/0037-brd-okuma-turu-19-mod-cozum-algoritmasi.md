# 0037 — BRD okuma turu **19**: §2.6 Workflow Resolution — mod yığınının **üç katmanı da yok**

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `Section_02_Product_Overview.md` §2.6 (792–916)
- **Ölçüm ortamı:** meta `e4f6bfb` · backend `99ee9e6` · dev DB `main`

---

## 0. Okundu / okunmadı

✅ Workflow Resolution Logic · User Experience senaryoları · Permission Model Integration ·
Phase 1/2 Behavior'ın başı (792–916)
⛔ `§2.6`'nın kalanı (916–1026): Administrative Interface · Best Practices · Benefits Summary

---

## 1. Algoritma — dört adım, tam yazılı

```typescript
function resolveWorkflow(context: {tenantId, userId, channel, cplId}) {
  const policy = getScopePolicy(tenantId, {channel, cplId});  // 1: en yüksek öncelikli eşleşme
  const perms  = getUserPermissions(userId);                  // 2: kullanıcı izinleri
  // 3: kesişim → kullanılabilir workflow'lar
  //    ACTUALS_FIRST  + 'agreements.create' → AGREEMENT
  //    PLANNING_FIRST + 'plans.create'      → PLAN
  //    HYBRID         + her ikisi           → ikisi de, default_workflow ile işaretli
  return { workflows, autoSelect: workflows.length === 1 };
}
```

### 📌 *"Kullanıcı seçimi değil"* ↔ HYBRID'in seçim modalı — **çelişmiyor**

Turu 12'de `§5.1`'den okumuştum: *"This is **not a system-wide toggle**."* Ama `§2.6`
Senaryo B'de kullanıcıya **modal** gösteriliyor:

```
What would you like to create?
[●] Create Plan (Recommended)     [ ] Create Agreement
```

**Uzlaştıran okuma (turu 17'nin dersi):**

| | |
|---|---|
| **Mod** (`execution_model`) | **kullanıcı seçmez** — `scope_policies`'ten gelir, kanal/CPL bağlamına göre |
| **Workflow** (HYBRID içinde) | **kullanıcı seçer** — ama yalnız politikanın **izin verdiği kümeden**, ve `default_workflow` önerili |
| tek seçenek varsa | `autoSelect: true` → **hiç sorulmaz** (Senaryo A) |

> İkisi de doğru: mod bir **bağlam kararı**, workflow HYBRID'de bir **anlık karar**.
> **Çelişki ilan etmiyorum.**

---

## 2. 🔴 Mod yığını — **üç katman**, ve üçü de bizde yok

| # | katman | BRD | bizde (ölçüldü) |
|---|---|---|---|
| 1 | **Bağlam**: `scope_policies` (channel/subchannel/CPL + `execution_model` + `priority`) | Phase 1 tablosu | ❌ **yok** (`pg_tables` → yalnız `user_scopes`) |
| 2 | **Kullanıcı**: yetenek izinleri `agreements.create` · `plans.create` · `.view` · `.approve` | `§2.6` + `§7.2 Capability-Based Permissions` | ❌ **yok** — `grep` boş; bizde **rol enum'u**: `ADMIN · PLANNER · MANAGER · FINANCE · FINANCE_MANAGER · CATEGORY_MANAGER` |
| 3 | **Faz**: `tenant_features.planning_mode_enabled` | Phase 1/2 anahtarı | ❌ **yok** — ne tablo ne kolon |

**BRD'nin normatif cümlesi:**

> *"Permissions are **user-level**, Scope Policies are **context-level**. **Both must align**
> for a workflow to be available."*

> **Bizde ne bağlam katmanı var, ne yetenek katmanı, ne de faz anahtarı.** Mod bir **klasör
> adı**, yetki bir **rol enum'u**.

### Mod sorusunun altı turluk seyri — ve kapanışı

```
tur 1   → dört faktör (Glossary)
tur 3   → tactic_policies eksik
tur 4   → §3.5: enabled_in_actuals/planning + iki JSONB (tek kolon değil)
tur 12  → §5.1: sistem geneli toggle değil, kayıt seviyesi; aynı kullanıcı aynı gün iki modda
tur 18  → §2.6: scope_policies — eşleşme motoru, HYBRID, CPL override
tur 19  → resolveWorkflow: üç katmanın kesişimi; üçü de yok
```

> **Soru artık tam cevaplı.** Ve cevap *"ayrım gereksiz"* değil, *"ayrım gerekli ama
> **üç katmanı da yazılmamış**"*.

---

## 3. 🔴 `§7.2 Capability-Based Permissions` — öncelik yükseldi

Turu 18'in envanterinde `§7.1 Role Model`'i 🟡 *"belki"* diye işaretlemiştim. Bu ölçüm
`§7.2`'yi **🔴 okunmalı**ya çıkarıyor:

- BRD yetkiyi **yetenek** (`agreements.create`) olarak modelliyor
- Bizde **rol** (`PLANNER`, `FINANCE_MANAGER`) var
- Ve mod çözümü **yetenek** katmanına bağlı — rol enum'uyla ifade edilemez

⚠️ **Ama bu bir kusur iddiası DEĞİL:** roller yeteneklere eşlenebilir
(`PLANNER → agreements.create`). `§7.2` okunmadan *"model yanlış"* denemez.

→ [[T-165]]

---

## 4. 📌 `tenant_features` — beşinci konfigürasyon tablosu

```sql
UPDATE tenant_features SET planning_mode_enabled = false;   -- Phase 1
```

[[T-156]]'nın envanteri **beşe** çıkıyor: `tactic_policies` · `budget_policies` ·
`approval_policies` · `scope_policies` · **`tenant_features`**.

⚠️ Ve bu sonuncusu **faz anahtarı** — yani BRD Phase 1'de Planning-First'ü **kapatmayı**
öngörüyor. Bizde planning-first **açık** ve `modes/planning-first/` modülü çalışıyor.

> **Bu bir sapma mı, bilinçli bir ilerleme mi?** Ölçülmedi — `§10.1` faz tanımları
> okunmadı. **İddia yazmıyorum.**

---

## 5. DUR koşulları

| koşul | durum |
|---|---|
| Mevcut bir ADR çürüyor mu | ❌ hayır |
| Beşinci/altıncı kapsam listesi altı terimden birini içeriyor mu | — bu turda kapsam listesi yok |
| Kritik bölüm ortaya çıktı mı | ✅ **`§7.2 Capability-Based Permissions`** 🟡→🔴 |

---

## 6. Sonraki tur

1. **`§6.4` Idempotency & Corrections** — **D-13'ün kanonik yeri** · [[T-095]] · `INV-L-006`
2. **`§7.3` Approval Authority** + **`§7.2` Capability Permissions** — ADR 0002 · [[T-153]] ·
   [[T-165]]
3. **`§7.5` Data Security & Isolation** — `INV-T-003` bugün **VIOLATED**, kaynak ne diyor
   bilinmiyor
4. `§2.6`'nın kalanı (916–1026) · `04_Reviews` ([[T-161]], [[T-163]]'ün son adayı)
