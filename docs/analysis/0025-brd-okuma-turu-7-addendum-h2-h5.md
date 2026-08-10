# 0025 — BRD okuma turu **7**: `02_Addendum` H2 · H5 (+ yapısal desen)

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/02_Addendum/BRD_Addendum_Technical_Clarifications.md` (**"MANDATORY"**)
- **Ölçüm ortamı:** meta `dd26688` · backend `99ee9e6`

---

## 0. Okundu / okunmadı

| | |
|---|---|
| ✅ okundu | **H2** Budget Reservation Race (213–365, tamamı) · **H5 Action 5.4** (959–1017) |
| ⛔ okunmadı | **H1** KPI Engine Performance (36–212) · **H3** Approval State Machine (365–534) · **H4** Baseline Extraction (534–677) · **H5**'in 5.1–5.3'ü (677–959) · Sprint 0 Checklist · Phase 2 Gate · Escalation Policy (1017–1153) |

**Okunan ~210 / 1153 satır.** H1 ↔ ADR 0003 ve H3 ↔ ADR 0002 karşılaştırmaları **yapılmadı**.

---

## 1. ✅ H2 ↔ ADR 0005 — **çelişmiyor, bağımsız olarak aynı yere varmış**

### 1.1 BRD ne emrediyor

**H2 Action 2.1: Implement Pessimistic Locking** — `SELECT … FOR UPDATE`,
`BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE`, ve gerekçesi bir yarış senaryosu
(iki planner, 8.000 + 7.000 TL, 10.000 TL'lik envelope → 15.000 TL rezerve).

### 1.2 Bizde ne var — ölçüldü

| BRD maddesi | bizde |
|---|---|
| Envelope üzerinde `FOR UPDATE` | ✅ `budget.repository.ts` `findEnvelopeWithLock` → `setLock('pessimistic_write')` |
| Para yollarında pessimistic | ✅ ADR 0005 **K5**: *"State geçişleri optimistic DEĞİL, status-CAS + `FOR UPDATE`"* |
| `SERIALIZABLE` izolasyon seviyesi | ❌ **yok** (`SERIALIZABLE`/`isolationLevel` araması boş) |
| Action 2.2 retry + backoff (`LOCK_TIMEOUT`) | ⚠️ **kısmi** — `agreement.service.ts`'te bir backoff var, bütçe yolunda ölçülmedi |
| Action 2.3 eşzamanlı yük testi (*"Approved: 6, Rejected: 4"*) | ⚠️ eşzamanlılık e2e'leri **var** (`optimistic-locking`, `budget-transaction-logs-idempotency`), ama **bu senaryo** ölçülmedi |

### 1.3 Bu turun en olumlu bulgusu

> **ADR 0005 bu belgeyi hiç görmeden yazıldı ve aynı kararı verdi.**

ADR 0005 §1.1 *"`VersionColumn` → 0 sonuç, hiçbir entity'de optimistic locking yok"*
ölçümüyle başlamış, §1.2'de üç pessimistic noktayı saymış, ve K5'te para yollarını
**bilinçli olarak** pessimistic bırakmış — gerekçesi *"para hareketi + saga kompanzasyonu
var; status CAS çift-approve'a karşı version'dan güçlü."*

Candidate Log turunda uyarmıştık: *"o ADR'ler bu belgeleri hiç görmeden yazıldı, dolayısıyla
genişletme bilinçli değil habersizdi."* **H2 için habersizlik bir sorun üretmemiş** —
akıl yürütme kaynağa yakınsamış.

⚠️ Ama üç boşluk gerçek ve ölçüldü: `SERIALIZABLE`, retry sözleşmesi, ve **H2'nin kendi
kabul testi**. → [[T-154]]

---

## 2. ⛔ DUR — H5.4 **CLAUDE.md §2.3 ile doğrudan çelişiyor**

### 2.1 İki metin, zıt yönler

**BRD Addendum, H5 Action 5.4 (başlığın kendisi):**

> **"Client-Side Execution (Not Server-Side)"**
> *"Security Principle: **Execute formulas in browser, not server**"*
>
> ```
> Server-Side Execution:      Client-Side Execution:
> ❌ Arbitrary code execution  ✅ Sandboxed in browser
> ❌ Server compromise         ✅ DoS affects only user's tab
> ❌ DoS attack vector         ✅ No data exfiltration risk
> ```

**CLAUDE.md §2.3:**

> *"KPI/ROI/Spend/Profit = Admin tanımlı **dinamik formül**. **Frontend sadece sonucu render
> eder.**"*

**Bizde:** `safeEval` zinciri **sunucuda** (`kpi-engine`, `formula-parser.service.ts`) —
ve ADR 0007 Karar 1 Alan B'yi tam olarak *"`kpi-engine` (`safeEval` zinciri)"* diye tanımlıyor.

### 2.2 Ve bu, kapatılmış sanılan bir soruyu geri açıyor

`docs/analysis/0011 §S2.3` şunu kaydetmişti:

> *"`PlanningGridEnhanced.tsx`'in bu bloğu CLAUDE.md §2.3'ün 'Frontend sadece sonucu render
> eder' kuralıyla **çelişiyor gibi görünüyor**. Bu bir BRD/ADR yorumu gerektirir ve bu
> ölçümün kararı değildir — ayrı task konusu."*

**Bağlayıcı kaynak o yorumu veriyor — ve frontend hesabından yana.** Yani `0011`'in
*"ihlal gibi görünüyor"* dediği şey **BRD'ye uygun** olabilir.

### 2.3 ⚠️ Ama fazla hızlı sonuç çıkarma — iki eksen ayrı

| eksen | §2.3 ne diyor | H5.4 ne diyor | çelişiyor mu |
|---|---|---|---|
| Formül **kaynağı** | Admin tanımlı, dinamik, hardcode yasak | KPI tanımları sunucudan çekilir | ❌ **çelişmiyor** |
| Formül **yürütme yeri** | *"frontend sadece render eder"* | **tarayıcıda çalıştır** | ✅ **çelişiyor** |
| **Kalıcılaştırma** | — | *"Send results to server (for save)"* | ⚠️ ADR 0007 Karar 1'in sınır kuralıyla **kesişiyor** |

Üçüncüsü en ağır: H5.4 istemcide hesaplanan sonucun **sunucuya kaydedilmesini** öngörüyor
(`api.savePlanKPIs`). ADR 0007 Karar 1: *"Alan B'nin çıktısı para olarak
kalıcılaştırılamaz."* Ve [[T-136]] zaten `PLANNED_GP → total_gp` sızıntısını kaydetti.

> ⛔ **DUR ve bildir — koşul tetiklendi: "bir bölüm mevcut bir ADR'yi çürütüyorsa".**
> Burada çürüyen tek bir ADR değil: **CLAUDE.md §2.3'ün bir cümlesi**, **ADR 0007 Karar
> 1'in Alan B tanımı**, ve **[[T-136]]'nın çerçevesi** birlikte etkileniyor.
>
> Karar vermiyorum. Üç ön koşul: (a) **H5'in 5.1-5.3'ü okunmadı** — sandbox tasarımı orada
> ve 5.4'ü nitelendirebilir; (b) `Section_05`'in KPI motoru bölümü okunmadı; (c)
> `03_Candidate_Log` **CANDIDATE-002 "KPI Formula Execution Sandbox"**'ı Phase 2'ye
> ertelemiş — yani 5.4 bugün bağlayıcı olmayabilir.

→ [[T-155]]

---

## 3. 🔴 Yapısal desen — altı vaka, tek kalıp (ürün sahibi sentezi)

Son üç tur üç ayrı politika katmanının eksik olduğunu buldu. Daha geniş bakınca **altı
vaka, tek desen**:

| # | BRD ne tanımlamış | üründe |
|---|---|---|
| 1 | `tactic_policies` — mod, izinli mekanik, süre, onay eşiği | **tablo yok**; mod **klasör**, kurallar serviste ([[T-148]]) |
| 2 | `budget_policies` — boyut-kapsamlı, öncelikli, dört tür | tenant başına düz üçlü, **ulaşılamaz** ([[T-144]], [[T-108]]) |
| 3 | `approval_policies` (+`steps`,`history`) | **tablo yok**, `approval_policy_id` **boşluğa bakıyor** ([[T-153]]) |
| 4 | RAG eşikleri KPI konfigürasyonundan | eşikler kodda sabit; konfigürasyon üretimde kurulmuyor ([[T-101]]) |
| 5 | `calculation_formula` · `decimal_places` · `min_value` | admin'e açık, **hiçbir hesap yolu okumuyor** ([[T-071]]) |
| 6 | Price simulation alanları | şema inmiş, **UI yok** ([[T-149]]) |

> ### **BRD bir konfigürasyon modeli tanımlamış; ürün onu sabit koda çevirmiş.**

CLAUDE.md §2.3'ün *"hardcoded threshold YASAK"* maddesi bunun **yalnız bir yüzü**. Asıl
mesele daha büyük: **ürün konfigüre edilebilir olarak tasarlanmış, konfigüre edilemez olarak
yazılmış.**

⚠️ **Ve bu, ikinci müşteri sorusunun gerçek hâli — RLS'ten önce gelen.** `INV-T-003`
(RLS, D-11) izolasyonu çözer; ama izolasyon olsa bile **her müşteri için kod değiştirmek
gerekir**. Bir SaaS'ın çok-kiracılılığı yalnız veri ayrımı değil, **davranış
konfigürasyonu**dur.

→ [[T-156]] (epic adayı, tek task değil)

---

## 4. Sonraki tur

1. **H1** (KPI Engine Performance) ↔ **ADR 0003** — recalc <500ms kararının kaynak denetimi
2. **H3** (Approval State Machine) ↔ **ADR 0002** + [[T-153]]
3. **H5 5.1–5.3** — sandbox tasarımı; [[T-155]]'in ön koşulu
4. H4 (Baseline) ↔ [[T-024]] · Sprint 0 Checklist · Phase 2 Gate
