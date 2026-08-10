# 0024 — BRD okuma turu **6**: §3.4 Approval Engine

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_03_Core_Components.md` §3.4 (781–877, tamamı)
- **Ölçüm ortamı:** meta `ddb7a0c` · backend `99ee9e6` · dev DB `main`, port 5434

---

## 1. ✅ [[T-144]]'ün açık ucu KAPANDI — %90 bir *approval-engine* kuralı değil

Turu 4 sormuştu: *"%90 onay katmanı `§3.4`'te mi?"* **Hayır, ve olmaması doğru.**

| sistem | neyi kapıyor | nerede |
|---|---|---|
| **Approval Engine** (§3.4) | **varlık** onayı — bir Agreement / Plan onaydan geçsin mi | `approval_policies` |
| **Budget Policies** (§3.3) | **bütçe kullanımı** — envelope %90'a gelince yeni anlaşma Finance onayı istesin | `budget_policies` (`THRESHOLD_APPROVAL`) |

§3.3 zaten tam şekli vermişti: `{ "approval_percent": 90, "approval_role": "FINANCE" }`.

> **İki ayrı politika sistemi, iki ayrı tablo.** T-144'ün %90'ı `budget_policies`'e aittir;
> `§3.4` onu doğru olarak içermiyor. Açık uç kapandı.

---

## 2. 🔴 Politika katmanı **hiç yok** — ve bir FK boşluğa işaret ediyor

BRD `§3.4` **dört tablo** sayıyor. Ölçüm (şema-nitelendirilmiş):

```sql
SELECT tablename FROM pg_tables
 WHERE schemaname='main' AND (tablename LIKE 'approval%' OR tablename LIKE '%polic%');
-- → approval_requests
```

| BRD tablosu | bizde |
|---|---|
| `approval_requests` | ✅ var |
| **`approval_policies`** | ❌ **YOK** |
| **`approval_steps`** | ❌ **YOK** |
| **`approval_history`** | ❌ **YOK** |

### ⚠️ Ve `approval_requests` olmayan tabloya işaret ediyor

```
approval-request.entity.ts:53   @Column({ name: 'approval_policy_id', type: 'uuid', nullable: true })
migration 1704067810000:78      name: 'approval_policy_id'
```

**Kolon var, işaret ettiği tablo yok.** Yani şema, politika katmanını **öngörmüş** ve o
katman hiç yazılmamış — kolon boşluğa bakıyor.

> Bu, [[T-148]] (`tactic_policies`) ve [[T-152]] (`ACCRUAL`) ile **aynı desenin üçüncü
> üyesi**: *adı konmuş, mekanizması yazılmamış.* Ve burada iz **kodun kendisinde** —
> bir FK kolonu, hedefi olmayan.

### BRD'nin normatif ifadesi

> *"**JSON-configurable rules: no hard-coding; admin-adjustable.** Policy matching: system
> finds applicable policy based on entity type, mode, channel, amount, tactic."*

Bugün onay kuralları servis kodunda. Bu, CLAUDE.md §2.3'ün *"hesaplamalar asla hardcode
edilmez"* ilkesinin **onay katmanındaki karşılığı** — ve aynı sınıf: konfigürasyon olması
gereken şey koda gömülü.

⚠️ **Ama BRD bir sadeleştirme izni de veriyor** ve bu kayda geçmeli:

> *"**Phase 1 Guardrail:** Approval policies are intentionally constrained to a small,
> opinionated set in early phases. Complex multi-conditional policies and edge case handling
> will be introduced progressively based on actual usage patterns, not anticipated
> scenarios."*

Yani *"az sayıda, görüşlü kural"* **BRD'ye uygundur**; *"tablo yok, kolon boşluğa bakıyor"*
uygun değildir. Ayrım önemli → [[T-153]].

---

## 3. ⚠️ BRD-içi belirsizlik: `priority` yönü **iki bölümde zıt yazılmış**

```
§3.3 (budget_policies)   : "If multiple policies match, LOWEST priority number wins (most specific)"
§3.4 (approval_policies) : "Priority-based resolution: If multiple policies match, HIGHEST priority wins"
```

İki farklı politika sistemi olduğu için **meşru bir fark olabilir**. Ama `§3.4`'ün ifadesi
kendi içinde de iki türlü okunur: *"highest priority"* = **en yüksek sayı** mı, yoksa
**en yüksek önem** (= en düşük sayı) mı?

> ⛔ **DUR — çözmüyorum.** Bir politika eşleşme kuralının yönü, çakışmada **hangi kuralın
> uygulanacağını** belirler; yanlış yön sessizce yanlış onay akışı üretir.
> `Section_05` ve `02_Addendum` okunmadan karara bağlanmamalı; ve iki sistemin gerçekten
> farklı olması **bilinçli mi** sorusu ürün sahibinin.

---

## 4. `min_justification_length` — 50 **iki kez**, 20 **bir kez**

| değer | nerede | biçim |
|---|---|---|
| **50** | `§3.4` approval policy JSON · `§3.5` tactic `actuals_config` | **politika alanı** |
| 20 | `§4.2` `validateAgreement` pseudo-kodu (`length < 20`) | sabit örnek |

Kanonik olan **alanın kendisi**; 20 ve 50 birer örnek. Ama **50 iki normatif konfigürasyon
örneğinde**, 20 bir pseudo-kodda geçiyor.

Bizde: `create-agreement.dto.ts` `justification!: string` alanı **var**; zorunluluk ve
uzunluk doğrulaması **ölçülmedi** → [[T-146]]'ya devredildi.

---

## 5. Diğer kayıtlar

| BRD | durum |
|---|---|
| Approval request yaşam döngüsü: `PENDING · APPROVED · REJECTED · CANCELLED` | bizdeki karşılığı ölçülmedi |
| Sequential onay Phase 1, **parallel Phase 2** | §4.10 ile tutarlı |
| Escalation: *"auto-escalate if approval delayed > N days"* — **opsiyonel** | ⚠️ ADR 0002 (FM escalation) **farklı bir şey**: o *kim onaylar* kararı, bu *gecikmede ne olur* |
| *"Changes to approval policies logged"* | politika tablosu olmadığı için **konusuz** |
| Birleşik örnek: *"Any promotion > $50K requires Finance approval"* — `entity_type` AGREEMENT **ve** PLAN | iki modun **aynı** politika tablosundan geçmesi normatif |

Sonuncusu [[T-148]] ile aynı yöne işaret ediyor: BRD politikayı **moddan bağımsız**
kurmuş, bizde mod bir **modül sınırı**.

---

## 6. Çıktı 3 — danışman kuyruğu

Bu turdan **yeni domain sorusu çıkmadı.** §3.4'ün kararları teknik/yapısal (tablo var mı,
priority yönü) ya da faz kararı (*Phase 1 Guardrail*). Kuyruk ~9-10'da sabit.

---

## 7. Sonraki tur

1. §3.3'ün kalan blokları (606–781, **Phase 1 Constraints**) — [[T-150]]'nin ön koşulu
2. `02_Addendum` (1153) — beş HIGH PRIORITY, **hiç sorulmadı**
3. `Section_05` (2013) · `Section_02` (1026) · `Section_10/11` (niyet ayrımı)
