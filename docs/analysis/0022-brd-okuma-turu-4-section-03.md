# 0022 — BRD okuma turu **4**: Section 03 §3.3 Budget · §3.5 Tactic Policies

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/01_Main_BRD/Section_03_Core_Components.md`
- **Ölçüm ortamı:** meta `4d98491` · backend `99ee9e6` · dev DB `main`, port 5434

---

## 0. Okundu / okunmadı

| | |
|---|---|
| ✅ okundu | **§3.3 Budget Management** (447–606: state tracking · transactions · policies · period · ledger entegrasyonu) · **§3.5 Tactic Library & Policies** (879–967, tamamı) |
| ⛔ okunmadı | §3.1 Master Data · §3.2 RBAC · §3.4 Approval Engine · §3.6 Ledger · §3.7/3.8 · ve §3.3'ün şema/kapsam blokları (606–781) |

**Okunan: ~255 / 1138 satır.** Hedefli bir turdu: turu 3'ün iki en büyük bulgusu
([[T-144]] eşik konfigürasyonu, [[T-148]] `tactic_policies`) buraya işaret ediyordu.

---

## 1. 🔴 [[T-144]] ÇÖZÜLDÜ — `95` bir DAVRANIŞ eşiği değil, ve **`budget_policies` bir tablo**

### 1.1 Ölçüm

`Section_03`'te terim sayımı:

```
"80%" = 2      "90%" = 2      "100%" = 3      "95%" = 0
```

**`95` bu bölümde hiç geçmiyor.** §3.3 *"Budget Policies (Governance Rules)"*:

```
1. Threshold Policies
   - Warning:  Alert at 80% utilization
   - Approval: Require approval at 90% utilization
   - Block:    Hard stop at 100% utilization
```

Yani üç bağımsız kaynak aynı şeyi söylüyor:

| kaynak | ne veriyor |
|---|---|
| Glossary + `§4.4` | **RAG rengi**: `<80` yeşil · `80-95` amber · `>95` kırmızı |
| `§4.8` | **alert**: 80 uyarı · **90 onay** · 100 blok |
| **`§3.3`** (çekirdek bileşen) | **politika**: 80 / **90** / 100 — ve `95` **yok** |

> **`95` yalnız bir RENK sınırıdır.** Davranış eşikleri **80 / 90 / 100**.
> Kodun `critical: 95`'i bir görüntü sayısını davranış katmanına taşımış.

### 1.2 Ve eşikler **konfigürasyon**, üstelik **boyut-kapsamlı**

BRD'nin şekli bizimkinden yapısal olarak farklı:

```json
{ "policy_type": "THRESHOLD_APPROVAL",
  "applies_to_dimensions": { "channel": "TRADITIONAL" },
  "config": { "approval_percent": 90, "approval_role": "FINANCE",
              "notify_roles": ["REGIONAL_MANAGER","FINANCE"] },
  "priority": 10 }
```

- **Tablo adı: `budget_policies`** (*"governance rules"*), `budget_alert_configurations` değil
- **Boyut-kapsamlı**: bir eşik yalnız `channel: TRADITIONAL` için geçerli olabilir
- **Eşleşme kuralı**: *"policy dimensions ⊆ envelope dimensions"*, çakışmada **en düşük
  `priority` kazanır (en özgül)**
- Ve dört politika **türü** var: Threshold · **Reallocation** · **Overrun** · **Carry-Forward**

⚠️ **`Overrun Policies` §4.10'un belirsizliğini çözüyor:** *"Overrun allowed? (Yes with
approval / No hard block)"* — yani **konfigüre edilebilir bir seçim**. Tur 3'te çözmeden
bıraktığım *"hard block at 100% ertelendi mi"* sorusunun cevabı: **overrun onay akışı**
ertelendi, Phase 1 varsayılanı **hard block**. Okuma (a) doğruymuş — ama artık **ölçülerek**.

### 1.3 Bizde ne var

`BudgetAlertConfiguration` — tenant başına `{WARNING_80, CRITICAL_95, EXCEEDED_100}`.
**Boyut kapsamı yok, priority yok, rol ataması yok, dört politika türünden yalnız biri var.**

Ve [[T-108]] zaten ölçmüştü: bu konfigürasyon **üretimde ulaşılamaz** — controller yok,
`TenantService.create` eşik satırı kurmuyor.

> Yani sapma üç katmanlı: **yanlış sayı** (95 yerine 90) · **yanlış şekil** (boyutsuz,
> önceliksiz) · **ulaşılamaz** (T-108).

---

## 2. ✅ [[T-147]] TAM CEVAPLANDI — ve tur 2'nin bulgusu **iki kez birden** yanlıştı

§3.3 *"Budget Transactions (Immutable Log)"* altı tipi **tam olarak** sayıyor:

```
ALLOCATE · COMMIT · RESERVE · RELEASE · TRANSFER · ADJUST
```

**Kodumuzun enum'uyla birebir aynı.** Tur 2 *"`TRANSFER` ve `ADJUST` BRD'de yok"* demişti;
tur 3 `TRANSFER`'i buldu (§4.10), bu tur `ADJUST`'ı da buluyor. **İkisi de BRD tipi.**

> Tur 2'nin hatasının sebebi kayda değer: `Section_04` bir **mod** bölümüdür ve yalnız o
> modun kullandığı tipleri anlatır. Çekirdek tanım `Section_03`'tedir.
> **"BRD'de yok" iddiası, yanlış bölüme bakılarak iki kez üretildi.**

Ve `TRANSFER`'in amacı da yazılı: **carry-forward bir `TRANSFER` işlemidir**
(*"audit trail preserved"*).

---

## 3. 🔴 YENİ SAPMA — `Committed` ile `Reserved` BRD'de **ayrı**, bizde **birleşik**

§3.3 beş durum sayıyor ve ikisini **ayrı kaynaklardan** türetiyor:

| Durum | BRD kaynağı |
|---|---|
| Committed | `budget_transactions (COMMIT)` — **Planning-First** |
| Reserved | `budget_transactions (RESERVE − RELEASE)` — **Actuals-First** |
| Consumed | `ledger_entries (budget_envelope_id)` |
| Available | `Allocated − Committed − Reserved − Consumed` |

Bizim `budget-summary.view-entity.ts` ise (dosyanın kendi yorumu):

```
reserved_amount: from budget_transactions (RESERVE + COMMIT − RELEASE)
```

**COMMIT'i RESERVED'in içine katıyor.** `Available` toplamı doğru çıkar, ama:

- *"Bu envelope'ta ne kadarı plandan, ne kadarı anlaşmadan?"* sorusu **cevaplanamaz**
- BRD'nin `Committed` durumu üründe **görünmez**
- Ve `RELEASE` **jenerik** — dosyanın kendi yorumu bunu zaten kaydediyor
  (*"RELEASE is generic and can net out either"*)

⚠️ **Bu bir "yanlış sayı" değil, kayıp bir ayrım.** Ve Glossary'nin `Commit`/`Reserve`
maddeleri (*"Reserve is for Actuals-First; Commit is for Planning-First"*) ayrımı normatif
kılıyor. → [[T-150]]

---

## 4. 🔴 [[T-148]] ŞEKLİ DEĞİŞTİ — `tactic_policies` **tek `mode` kolonu değil**

Tur 3 §4.7'den `"mode": "ACTUALS"` okumuştu. **§3.5 (çekirdek bileşen tanımı) farklı bir
şekil veriyor** ve bu şekil daha güçlü:

```
enabled_in_actuals   : boolean       actuals_config  : JSONB
enabled_in_planning  : boolean       planning_config : JSONB
```

> **Bir taktik iki modda BİRDEN etkin olabilir — farklı kurallarla.** §4.7'nin tek `mode`
> alanı, o bölümün actuals perspektifinden yazılmış bir kesitiydi.

Ve §3.5'in gerekçesi tam olarak bunu söylüyor: *"the same tactic can be used in Actuals-First
or Planning-First, but with different validation rules."*

**Bu, mod sorusunu bir kez daha keskinleştiriyor:**

| katman | mod nerede |
|---|---|
| BRD | bir taktiğin **iki boolean'ı** — aynı taktik iki modda yaşayabilir |
| bizde | **iki ayrı modül ağacı** (`modes/actuals-first/`, `modes/planning-first/`) |

Bir klasör bölmesi *"aynı taktik, iki mod, farklı kural"*ı ifade **edemez**.

### Örnek konfigürasyonlar (normatif)

```jsonc
// actuals_config
{ "requires_justification": true, "min_justification_length": 50,
  "requires_fu": true, "max_duration_days": 30,
  "allowed_mechanic_types": ["PERCENT","AMOUNT"],
  "max_support_percent": 40.0, "approval_policy_key": "ACTUALS_STA_DEFAULT" }

// planning_config
{ "requires_baseline": true, "requires_planned_volume": true,
  "allowed_mechanic_types": ["PERCENT","AMOUNT_PER_UNIT"],
  "max_discount_percent": 40.0, "min_uplift_percent": 5.0 }
```

**Ve normatif bir zamanlama kuralı:** *"Invalid entries blocked **at point of entry** (not at
approval)."*

---

## 5. İndirim tavanı sayılarının envanteri — **dördüncü sayı çıktı**

[[T-138]] için belirleyici. Şimdiye kadar bulunanların tamamı:

| sayı | kaynak | kapsam |
|---|---|---|
| **30** | `TPM_Base` PDF: *"Recommended max: 30%"* | birleşik on-invoice, **tavsiye** |
| **30** | `§4.7`: *"Warning if >30%"* | tek on-invoice mekaniği, **uyarı** |
| **40** | **`§3.5`: `max_support_percent` / `max_discount_percent`** | **taktik politikası alanı** |
| 50 | **kodumuz** `MAX_ON_INVOICE_DISCOUNT` | — **kaynağı YOK** |
| 60 | **kodumuz** `MAX_COMBINED_DISCOUNT` (ERROR) | — **kaynağı YOK** |

> Üç BRD sayısının **hiçbiri sabit değil**: ikisi *tavsiye/uyarı*, üçüncüsü bir **politika
> alanı**. Kodumuzun iki sayısı hem **dayanaksız** hem **sabit** — ve biri **bloklayan**.

Ayrıca **`min_justification_length: 50`** (§3.5) ↔ `§4.2`'nin `length < 20` kontrolü:
aynı kuralın iki farklı sayısı. §3.5 onu **politika alanı** yaptığı için çelişki değil —
20 bir örnek, 50 bir örnek; **kanonik olan alanın kendisi**. [[T-146]] buna göre düzeltilmeli.

---

## 6. Doğrulananlar ve yeni kayıtlar

✅ **`ADJUST`/`TRANSFER`** — kodumuz BRD ile birebir (§2)
✅ **"Hesaplanır, saklanmaz"** — *"committed/reserved/consumed are **not stored** … computed …
eliminates dual-write issues"*. Bizim `v_budget_summary` yaklaşımımız BRD'nin kararı.
✅ **D-13 kanonik format** — `'<tx_type>|<source_type>|<source_id>|<envelope_id>'`, örnek
`'RESERVE|AGREEMENT|uuid-123|uuid-456'`. §4.8'in verdiğiyle tutarlı.
✅ **`mechanic_type` üç değeri** — `PERCENT · AMOUNT · AMOUNT_PER_UNIT` (§3.5), ADR 0007 C3'ün
üç kolonunu **ikinci kez** doğruluyor.

🆕 **Period locking** — *"Finance locks period after close; locked periods cannot have new
commitments/reservations; can be reopened by Finance (audit logged)."* **Bizde ölçülmedi.**

---

## 7. Sonraki tur

1. **§3.4 Approval Engine** + §3.3'ün kalan şema blokları (606–781, *"Phase 1 Constraints"*)
2. **§3.6 Ledger & Spend Tracking** — `INV-L-*` ailesinin kaynak denetimi
3. `02_Addendum` — beş HIGH PRIORITY
4. `Section_05` (2013)
