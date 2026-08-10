# 0036 — BRD okuma turu **18**: Section_02 hedefli + kalan bölümlerin envanteri

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Ölçüm ortamı:** meta `0907986` · backend `99ee9e6` · dev DB `main`

---

## 0. Okundu / okunmadı

✅ `Section_02` **§2.7** Non-Goals (671–723) · **§2.6** Overview + Scope Policy Configuration
(726–790)
📊 `Section_02/06/07/08/09` **outline + kelime-sınırlı terim taraması**
⛔ `Section_02`'nin geri kalanı **~915 satır** — §2.1 Platform Architecture · §2.2 Mode
Selection Framework · §2.3 Modes Deep Dive · §2.4 Organizational Patterns · §2.5
Scalability · **§2.6'nın Workflow Resolution Logic / Permission Model / Phase 1-2 Behavior /
Administrative Interface blokları (792–1026)**

> ⚠️ Terim taraması **varlık ölçümüdür, içerik iddiası değil**. Okunmayan bloklar hakkında
> hiçbir şey iddia edilmiyor.

---

## 1. ✅ §2.7 — **beşinci kapsam listesi**, altı terim yine yok

`§2.7 Non-Goals & Explicit Exclusions` + `Scope Boundaries` tablosu.

**Kelime-sınırlı tarama** (`grep -owci`), beş bölümde:

| | `recognition` | `claim` | `accrual` | `settlement` |
|---|---|---|---|---|
| Section_02 | 0 | 0 | 0 | 2 |
| Section_06 | 0 | 0 | 0 | 1 |
| Section_07 · 08 · 09 | 0 | 0 | 0 | 0 |

`settlement`'ın üç geçişi de daha önce ölçülmüştü (*"quarterly settlement"*, *"Payment Data …
deductions"*) — **kavram tanımı değil**.

> **Beşinci liste, aynı sonuç.** [[ADR 0010]] beş bağımsız kapsam beyanıyla doğrulanmış
> durumda (§4.10 ×2, §5.7, §10.4, §2.7).

### ⚠️ Bir satır dikkatli okunmalı — ve çelişki DEĞİL

```
| Spend Tracking | ✅ Off-invoice, lumpsum, actuals | ❌ Manufacturing costs, COGS |
```

İlk okuyuşta *"COGS kapsam dışı"* → ama GP ROI COGS'a bağlı. **Çelişki değil:**

| | |
|---|---|
| kapsam **dışı** | COGS'u **üretmek/yönetmek** (maliyet muhasebesi) |
| kapsam **içi** | COGS'u **tüketmek** — Glossary: *"COGS **Source:** ERP system, Finance master data"*; `§11.1 A12`: *"refreshed monthly"* |

> Uzlaştıran okumayı aradım ve buldum (turu 17'nin dersi). **Çelişki ilan etmiyorum.**

Ve *"Not an ERP Replacement … Does NOT handle … accounts payable processing"* — **GL/AP
sınırının üçüncü tekrarı** (§3.6, §10.4, §2.7). Tutarlı.

---

## 2. 🔴 §2.6 — **dördüncü politika tablosu**, ve mod çözümleyicisinin ta kendisi

```sql
CREATE TABLE scope_policies (
  channel, subchannel, cpl_id,                    -- kapsam (CPL bazında override!)
  execution_model  VARCHAR(20) NOT NULL,          -- ACTUALS_FIRST | PLANNING_FIRST | HYBRID
  default_workflow VARCHAR(20) NOT NULL,          -- AGREEMENT | PLAN
  priority INT DEFAULT 100,                       -- lower = higher priority
  is_active BOOLEAN DEFAULT true
);
```

Ve amacı açık: *"determine which operational workflows are available … users always see the
right interface **without manual mode selection**."*

**Ölçüm:** `pg_tables … LIKE '%polic%' OR LIKE '%scope%'` → yalnız **`user_scopes`**
(farklı şey: kullanıcı erişim kapsamı).

> **`scope_policies` YOK.** Mod çözümleyicisinin kanonik tablosu, ve dördüncü eksik politika
> tablosu.

### [[T-156]]'nın envanteri güncellendi — **dört tablo**

| # | BRD tablosu | bizde | task |
|---|---|---|---|
| 1 | `tactic_policies` | ❌ | [[T-148]] |
| 2 | `budget_policies` | ⚠️ farklı şekil, ulaşılamaz | [[T-144]] · [[T-108]] |
| 3 | `approval_policies` (+ `steps`, `history`) | ❌ | [[T-153]] |
| 4 | **`scope_policies`** | ❌ | **bu tur** |

### ✅ Ve `priority` yönü belirsizliği **çözülüyor**

[[T-159]]'un üçüncü vakası: `§3.3` *"lowest priority number wins"* ↔ `§3.4` *"highest
priority wins"*.

**`§2.6` üçüncü kaynak:** `priority INT DEFAULT 100, -- lower = higher priority`

> **İki kaynak açıkça "düşük sayı kazanır" diyor** (§3.3, §2.6). `§3.4`'ün *"highest
> priority"*si büyük olasılıkla **"en yüksek öncelik" = en düşük sayı** anlamında bir
> dil kullanımı.
>
> Turu 17'nin dersi uygulandı: **çelişki ilan etmeden önce uzlaştıran üçüncü belgeyi ara.**
> Bulundu. → T-159'un üçüncü vakası da **düşüyor**; üç kaldı.

---

## 3. ⛔ [[T-163]] — BRD kaynakları **tükendi**

Kelime-sınırlı tarama, beş bölüm:

```
GP_ROI = 0   ·   TOTAL_PLANNED_SPEND = 0   ·   INCR_SPEND = 0
```

Daha önce `§5.4+` da sıfır çıkmıştı (`0033 §2`).

> **`GP_ROI_PCT`'nin paydasına dair gerekçe `01_Main_BRD` ve `02_Addendum`'da YOK.**
> Geriye tek aday: **`04_Reviews`** (5.249 satır) — ve statüsü [[T-159]]'a bağlı.

---

## 4. 📋 Okuma önceliği — envanterin asıl çıktısı

`Section_06/07/08/09` outline'ları çıkarıldı. **Okunmalı / atlanabilir** kararı, her biri
bizim açık bir task'ımızla kesiştiği için:

| bölüm | satır | **oku** | gerekçe |
|---|---|---|---|
| **§7.3** Approval Authority Model | ~120 | 🔴 **evet** | ADR 0002 · [[T-153]] · onay yetkisi modeli |
| **§6.4** Idempotency & Corrections | ~135 | 🔴 **evet** | **D-13** · [[T-095]] · `INV-L-006` · *"Corrections"* = reversal/adjustment |
| **§7.5** Data Security & Isolation | ~46 | 🔴 **evet** | `INV-T-003` · **D-11 (RLS)** — ikinci müşteri sorusu |
| **§9.1** Performance Requirements | ~38 | 🟡 evet (kısa) | **NFR-1.2** · ADR 0003 · [[T-157]] |
| **§8.5** Explicit Non-Goals (Phase 1) | ~44 | 🟡 evet (kısa) | **altıncı kapsam listesi** |
| **§7.1** Role Model | ~154 | 🟡 belki | RBAC (Planner/CM/FM/Admin) — §2.3'te özet var |
| **§6.3** Granularity Decisions | ~109 | 🟡 belki | `0002`'nin CPL×Kategori×Kanal kararıyla kesişebilir |
| **§9.3** Availability | ~79 | ⚪ atla | uptime/SLA — **deploy edilmiş ortam yok**, bugün konusuz |
| **§8.1** Core Reports | **~464** | ⚪ atla (şimdilik) | rapor tanımları; ayrıntı, açık task'la kesişmiyor |
| **§9.5** Compliance · **§9.7** Usability | ~113 | ⚪ atla | KVKK/erişilebilirlik — ayrı uzmanlık, açık task yok |
| **§6.1/6.2** Data Domains/Patterns | ~212 | ⚪ atla | entegrasyon Phase 3 |

**Ve `Section_02`'nin okunmayan bloklarından biri öne çıkıyor:**

| | satır | oku |
|---|---|---|
| **§2.6 Workflow Resolution Logic + Administrative Interface** | 792–1026 (~234) | 🔴 **evet** — mod çözümünün **algoritması** ve [[T-156]]'nın *"admin UI Phase 2"* sınırının kaynağı |

---

## 5. Kümülatif okuma durumu

| paket parçası | okunan |
|---|---|
| `Section_12` Glossary | **%100** |
| `Section_04` Actuals-First | **%100** |
| `02_Addendum` | ~%78 |
| `Section_03` Core Components | ~%22 |
| `Section_05` Planning-First | ~%27 |
| `Section_10` Roadmap | ~%21 |
| `Section_11` Assumptions/Risks | ~%30 |
| `Section_02` Product Overview | ~%11 |
| `Section_01 · 06 · 07 · 08 · 09` | **%0** (yalnız outline) |
| `03_Candidate_Log` | başlıklar + terim taraması |
| **`04_Reviews`** | **%0** — 5.249 satır |

---

## 6. DUR koşulları

| koşul | durum |
|---|---|
| `Section_02` mevcut bir ADR'yi çürütüyor mu | ❌ **hayır** — `Spend Tracking ❌ COGS` satırı çelişki gibi duruyor ama uzlaştıran okuma var (§1) |
| Beşinci kapsam listesi altı terimden birini içeriyor mu | ❌ **hayır** — beşinci kez aynı sonuç |
| Outline kritik bir bölüm ortaya çıkarıyor mu | ✅ **EVET** — **§2.6'nın kalanı** (mod çözüm algoritması + admin arayüzü) ve **§6.4 Idempotency & Corrections** (D-13'ün kanonik yeri) |

---

## 7. Sonraki tur

`§2.6`'nın kalanı (792–1026) — mod çözümünün algoritması, [[T-148]] ve [[T-156]]'nın
doğrudan konusu.
