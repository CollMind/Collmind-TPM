# 0026 — BRD okuma turu **8**: Addendum H1 · H3 (ADR 0003 ve ADR 0002 denetimi)

- **Tarih:** 2026-08-10
- **Task:** [[T-143]] — salt-okunur.
- **Kaynak:** `docs/brd/02_Addendum/BRD_Addendum_Technical_Clarifications.md`
- **Ölçüm ortamı:** meta `a335eba` · backend `99ee9e6`

---

## 0. Okundu / okunmadı

✅ **H1** (36–160, Problem + üç Action) · **H3** (389–533, üç Action)
⛔ H1'in *"Implementation Specification"*ı (160–212) · **H4** Baseline (534–677) ·
**H5 5.1–5.3** (677–959) · Sprint 0 Checklist · Phase 2 Gate · Escalation (1017–1153)

**Addendum toplam okunan: ~485 / 1153 (%42).**

---

## 1. ✅ H1 ↔ **ADR 0003 doğrulandı** — hem karar hem düzeltmesi

### 1.1 ADR 0003 neyi düzeltmişti

CLAUDE.md §2.2'nin kanonik örneği: `rules.md` NFR-1.2'nin `<500ms` hedefini yalın bir cümle
olarak aktarmış, BRD tablosundaki **"Measurement Method: Time from input change to UI
update"** sütununu kaybetmişti. Bir ajan bunu *"tek formül"* diye yorumladı; düzeltme
**ADR 0003** ile geldi.

### 1.2 H1 o düzeltmeyi **birebir** doğruluyor

```typescript
const prototypeSpec = {
  kpis: 40, skus: 100, tactics: 8,
  target: 500,                      // ms
  environment: "production-like",   // Not developer laptop
  includeNetworkLatency: true       // Client → Server → Client
};
```

**Başarı ölçütü:** P50 `<300ms` · P95 `<500ms` · P99 `<800ms` · *"No browser freeze (UI
remains responsive)"*.

> **`includeNetworkLatency: true` ve *"Client → Server → Client"* tek başına yeterli:**
> hedef **uçtan uca**dır, tek bir formülün süresi değil. ADR 0003'ün düzeltmesi kaynakla
> uyumlu — ve ADR o kaynağı **görmeden** verilmişti.

**Bu, H2'den sonra ikinci habersiz yakınsama.**

### 1.3 ⚠️ Ama üç madde açık ve biri **yapısal olarak** karşılanamıyor

H1 **Action 1.3 — Phase 2 Gate Criteria:**

```
✅ KPI engine prototype achieves <500ms (or fallback selected)
✅ Load test completed: 10 concurrent users editing plans
✅ Performance regression tests in CI/CD
```

| madde | durum |
|---|---|
| Prototip (100 SKU, üretim benzeri, ağ gecikmesi dâhil) | **ölçülmedi** — ADR 0003 kapsam kararıydı, bir prototip ölçümü değil |
| 10 eşzamanlı kullanıcı yük testi | **yok** |
| **CI/CD'de performans regresyon testi** | ⛔ **yapısal olarak yok** — `SYSTEM_INVARIANTS §10` zaten kaydediyor: *"No pipeline exists to host them, and labelling them `CI` would assert protection that is not there."* |

> **Phase 2 kapısının bir ölçütü, altyapı olmadığı için karşılanamaz durumda.** Bu bir
> gecikme değil, bir **ön koşul boşluğu**. → [[T-157]]

Ve `docs/analysis/0014 §6` de aynı boşluğu bağımsız olarak kaydetmişti: *"NFR-1.2 (<500 ms):
transformer entity başına O(kolon) ek iş getirir … **Bu doküman ölçmedi** — F4'ün kabul
ölçütüne konmalı, varsayılmamalı."*

### 1.4 📌 Fallback mimarisi kayda geçer (bugün karar değil)

H1 Action 1.2 üç Plan B tanımlıyor: **materialized view** (kaydetmede hesapla, gerçek zaman
kaybolur) · **WebAssembly** formül motoru · **UI'da 11 "essential" KPI**, kalan 40 arka planda.

Üçü de bugün seçilmemiş — ve prototip ölçülmediği için **seçilmesi gerekip gerekmediği de
bilinmiyor**.

---

## 2. ⛔ Addendum **kendi içinde** çelişiyor — ve bu [[T-155]]'i doğrudan zayıflatıyor

Aynı **"MANDATORY"** belgede, iki madde formülün **nerede çalışacağı** konusunda zıt:

| madde | ne diyor |
|---|---|
| **H1** Action 1.1 | `includeNetworkLatency: true` · *"**Client → Server → Client**"* → **sunucu** hesabı varsayıyor |
| **H5** Action 5.4 | *"**Execute formulas in browser, not server**"* → **istemci** hesabı emrediyor |

Ve H1'in fallback'lerinden **Option B (WebAssembly, tarayıcıda)** ile **Option A
(materialized view, sunucuda)** de zıt yönlere işaret ediyor.

> **T-155'in premisi zayıfladı.** H5.4 tek başına okunduğunda *"bağlayıcı bir emir"* gibi
> duruyordu; H1 ile birlikte okununca **Addendum'un kendisi kararsız**. Ve
> `03_Candidate_Log` **CANDIDATE-002**'nin sandbox'ı Phase 2'ye ertelemesi bu tabloyu
> tamamlıyor.

⚠️ **Bu, tam olarak §2.1.1'in "hangi bölüm" kuralının bir adım ötesi:** aynı belgenin **iki
maddesi** çeliştiğinde hangisinin kazandığı da yazılı değil.

---

## 3. ✅ H3 ↔ **ADR 0002 doğrulandı** — ve bir eksik durum ailesi çıktı

### 3.1 Uyumlu

| BRD (H3 Action 3.1/3.2) | bizde |
|---|---|
| `PENDING → PENDING_L2 → APPROVED` (çok seviyeli) | `PENDING_APPROVAL → **PENDING_FINANCE_REVIEW** → APPROVED` ✅ |
| **`SUBMIT: CHECK_ONLY`** — *"Validate budget availability but do not reserve"* | ✅ rezervasyon `approval-workflow.service.ts`'te, submit'te değil |
| **`APPROVE: RESERVE`** | ✅ |
| `REJECT: NONE` (*"never reserved"*) · `EDIT_AFTER_REJECT: NONE` | ✅ ADR: *"Rejected → Draft, audit korunur"* |
| `CANCEL: RELEASE_IF_APPROVED` | `agreements` `CANCELLED` var ✅ |

> **ADR 0002'nin `PENDING_FINANCE_REVIEW` ayrımı BRD'nin `PENDING_L2`'sidir.** Üçüncü
> habersiz yakınsama.

### 3.2 🔴 Eksik: `EXPIRED` durumu ve zaman aşımı ailesi

H3 **Action 3.3** normatif:

```
Rule: Approvals pending >7 days auto-expire
  → status = 'EXPIRED', expired_at, expiry_reason = 'No action for 7 days'
  → NOTIFY requester + approver
Grace Period: 14 gün içinde yeniden gönderilebilir, sonra silinir
```

**Ölçüm — durum enum'ları:**

```
plan.entity.ts       DRAFT · PENDING_APPROVAL · PENDING_FINANCE_REVIEW · APPROVED · REJECTED
agreement.entity.ts  DRAFT · PENDING · APPROVED · ACTIVE · CLOSED · REJECTED · CANCELLED
```

- **`EXPIRED` ikisinde de yok**
- **`CANCELLED` planlarda yok** (anlaşmalarda var)
- `expired_at` / `expiry_reason` kolonları yok

⚠️ **Ve gerektirdiği şey bizde yapısal olarak yok:** *"Nightly Job"*. `SYSTEM_INVARIANTS §10`
zaten iki maddeyi bu yüzden `CI` diye etiketlemeyi reddetmişti (şema-diff ve gece
mutabakatı). **Bu üçüncüsü.** → [[T-158]]

### 3.3 ⚠️ Ölçülmedi: `PENDING → DRAFT`

H3 bunu **geçersiz** ilan ediyor: *"❌ PENDING → DRAFT (must cancel first)"*.

Bizde `plan.service.ts` `returnToDraft()` var. **Hangi durumdan çağrıldığı bu turda
ölçülmedi** — `REJECTED → DRAFT` ise uyumlu, `PENDING_* → DRAFT` ise doğrudan sapma.

> İddia yazmıyorum. [[T-158]]'e ölçüm maddesi olarak girdi.

---

## 4. 🔴 §2.1'in boşluğu: **paket içi öncelik tanımsız**

Bu tur iki somut vaka üretti:

| bağlayıcı belge | ne diyor | çelişen belge | ne diyor |
|---|---|---|---|
| `02_Addendum` **H5.4** (MANDATORY) | formül **tarayıcıda** | `03_Candidate_Log` **CANDIDATE-002** | *"KPI Formula Execution Sandbox"* → **Phase 2** |
| `02_Addendum` **H1** (MANDATORY) | P50/P95/P99 hedefleri **şimdi** | `03_Candidate_Log` **CANDIDATE-007** | *"KPI Engine SLA & Performance Targets"* → **Phase 2** |

Ve §2'de gördüğümüz üçüncü biçim: **aynı belgenin iki maddesi** (H1 ↔ H5.4).

CLAUDE.md §2.1 hiyerarşisi `ADR > BRD > rules.md` diyor — ama **BRD paketinin iç
önceliğini söylemiyor**. Paketin kendi indeksi `02_Addendum`'a *"MANDATORY"*,
`03_Candidate_Log`'a *"Phase 2 Design Backlog"* diyor; bu bir öncelik ilanı **değil**,
bir tür ayrımı.

> ⛔ **DUR — bu bir §2.1 boşluğudur ve ürün sahibinin kararıdır.** İki bağlayıcı belge
> çeliştiğinde hangisi kazanır? Ve bir belge kendi içinde çeliştiğinde? → [[T-159]]

---

## 5. Skor: dört ADR'nin kaynak denetimi

| Addendum maddesi | ADR'miz | sonuç |
|---|---|---|
| **H2** Budget race → pessimistic lock | **ADR 0005** | ✅ **yakınsama** (3 boşluk: `SERIALIZABLE`, retry, kabul testi — [[T-154]]) |
| **H1** KPI perf, uçtan uca ölçüm | **ADR 0003** | ✅ **yakınsama** (Phase 2 gate karşılanamıyor — [[T-157]]) |
| **H3** Approval state machine | **ADR 0002** | ✅ **yakınsama** (`EXPIRED` ailesi eksik — [[T-158]]) |
| **H4** Baseline extraction | [[T-024]] | ⏭️ **okunmadı** |

> **Üç ADR, üç yakınsama.** Candidate Log turunda *"o ADR'ler bu belgeleri hiç görmeden
> yazıldı, genişletme bilinçli değil habersizdi"* diye uyarmıştık. **Habersizlik üç kez
> sorun üretmedi** — ve bulunan boşlukların hepsi *kararın kendisinde* değil,
> **kabul ölçütlerinde ve altyapıda**.

---

## 6. Sonraki tur

1. **H4** Baseline ↔ [[T-024]] — dördüncü ve son dayanak denetimi
2. **H5 5.1–5.3** — sandbox; [[T-155]]'in ön koşulu
3. Sprint 0 Checklist · Phase 2 Gate · Escalation Policy (1017–1153)
4. `Section_05` (2013) · `Section_02` (1026) · `Section_10/11`
