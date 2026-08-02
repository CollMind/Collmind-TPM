# 0009 — Submit yolu yakınsaması: tipli on/off rezervasyonun canlı `/submit`'e taşınması (tasarım)

- Task: [[T-056]] · Epic: E-001 · Tarih: 2026-08-02 · Yazan: architect
- Kapsam: **yalnızca tasarım.** Bu turda üretim kodu yazılmadı/değiştirilmedi.
- Karar (tartışma değil): `docs/decisions/0005-submit-yolu-yakinsamasi.md`
- Bağlayıcı kurallar: `docs/decisions/0004-on-off-invoice-zarf-kurallari.md` (Karar 2 + eki, 3, 4, 5)
- Önceki tasarım: `docs/analysis/0008-on-off-invoice-envelope-design.md` (§5.2, §5.4, §5.5, §5.6, §5.7, §9)
- İlgili: [[T-052]], [[T-053]], [[T-048]], [[T-033]], [[T-030]], [[T-029]], [[T-034f]], [[T-019]], [[T-019b]], [[T-047]]

> **Yöntem kuralı (uyuldu):** bu belgedeki her iddia ya `dosya:satır` referansıyla ya da
> canlı dev DB'de koşturulmuş SQL ile kanıtlanmıştır. "Muhtemelen böyle çalışıyor" cümlesi yok;
> kanıtlanamayan yerler §8'de **açık soru** olarak işaretlendi.

---

## §1 Ölçüm — dev DB'nin BUGÜNKÜ hâli (2026-08-02)

Ortam: `docker exec collmind-tpm-postgres psql -U postgres -d collmind_tpm` (port 5434), şema `main`.

### §1.1 Plan tarafı — **uçuşta hiçbir şey yok**

```sql
SELECT count(*) AS plans_all FROM main.plans;                        -- 0  (soft-delete DAHİL)
SELECT count(*) FILTER (WHERE source_type='PLAN')                    AS plan_tx,          -- 0
       count(*) FILTER (WHERE source_type='PLAN' AND spend_type IS NULL) AS plan_untyped,  -- 0
       count(*) FILTER (WHERE idempotency_key LIKE 'RESERVE|PLAN|%') AS reserve_plan_keys -- 0
FROM main.budget_transactions;
```

**Sonuç: dev DB'de bugün 0 plan, 0 plan-kaynaklı bütçe satırı, 0 adet `RESERVE|PLAN|…` key'i var.**
Yani T-056 brief'indeki "🔴 EN KRİTİK" senaryonun (PENDING planların TOTAL encumbrance'ı asılı kalır)
**dev'de fiilî nüfusu sıfırdır**. Bu, riski yok etmez — üretim DB'si buradan ölçülemez (§8 Q1) —
ama geçişin **veri göçü gerektirmediğini** ve adım adım gidilebileceğini gösterir.

> Yan gözlem (T-047 sınıfı, T-056 kapsamı dışı): `main.approval_requests` **9.116 satır**
> (PLAN/PENDING **309**) ama `main.plans` **0 satır**. e2e teardown (`test/helpers/seed-e2e.ts:336-358`)
> `plans`, `plan_*`, `budget_transactions` siliyor ama **`approval_requests`'i hiç silmiyor** →
> öksüz onay isteği birikiyor. Ayrı task önerilir; "PENDING plan var mı?" sorusu bu tablodan
> **cevaplanamaz** (bu belgede de `plans` üzerinden ölçüldü).

### §1.2 Zarflar — hepsi UNSPLIT

```
code             | period  | spend_type | allocated | reserved (v_budget_summary)
ENV-2026-NKA-Q1  | 2026-01 | NULL       | 500.000   | 75.000
ENV-2026-NKA-Q2  | 2026-02 | NULL       | 600.000   | 75.000   ← 0008 §2.2'de 0 idi
ENV-2026-TRAD-Q1 | 2026-01 | NULL       | 300.000   | 0
ENV-2026-ECOM-Q1 | 2026-02 | NULL       | 200.000   | 0
```

4 zarfın **4'ü de `spend_type IS NULL`** → bugün hiçbir boyut bölünmüş değil. Yakınsama sonrası
her iki tipli arama da **aynı UNSPLIT zarfa** düşer (`budget.repository.ts:115-120` +
`:150-160` sıralama) — yani iki tipli RESERVE **aynı zarfa** yazılır, tıpkı bugün A8c'de
`/submit-for-approval`'ın yaptığı gibi.

### §1.3 🔴 Ölçüm sırasında bulunan CANLI FIXTURE HATASI (T-056 kapsamı dışı, ayrı task)

```
tx_type | spend_type  | amount | source_id (agreement) | idempotency_key                                | env             | created_at
RESERVE | OFF_INVOICE | 75.000 | 3eb02a4e-…            | RESERVE|AGREEMENT|3eb02a4e…|2021545e… (NKA-Q1) | ENV-2026-NKA-Q1 | 2026-07-29
RESERVE | (NULL)      | 75.000 | 3eb02a4e-…            | RESERVE|AGREEMENT|3eb02a4e…|aff897a3… (NKA-Q2) | ENV-2026-NKA-Q2 | 2026-08-02
```

**Aynı agreement iki zarfta 150.000 encumber ediyor.** Kök neden: iki farklı seed giriş noktası
**farklı zarf** seçiyor ve seed key'i `envelopeId` içeriyor (`budget-transaction.seed.ts:42`):

- `src/database/seeds/cleanup-and-seed.ts:104-105` → `envelopes.find(code LIKE %NKA%)` → **NKA-Q1**
- `src/database/seeds/index.ts:153-160` → `find(period === agreement.periodMonth && NKA)` → **NKA-Q2**

Kirli DB'de ikinci giriş noktası çalışınca key farklı olduğu için ikinci rezervasyon yazılıyor —
tasarım 0008 §4'ün **R8** riski, birebir gerçekleşmiş hâli. **T-056'nın doğrulama zeminini
etkiler:** [[T-047]] invaryantının "ENV-2026-NKA-Q1 reserved=75.000 sabit" kontrolü hâlâ geçer ama
**NKA-Q2 artık 0 değil 75.000** — T-019b'nin raporladığı taban çizgisi değişmiştir. Adım planındaki
her koşumda taban çizgisi **koşum öncesi ölçülmeli**, ezberden yazılmamalı.

---

## §2 Ölçüm — kodun BUGÜNKÜ davranışı (dosya:satır)

### §2.1 İki submit yolu

| | Canlı UI yolu | On/off makinesi |
|---|---|---|
| Endpoint | `plan.controller.ts:322-344` `POST /plans/:id/submit` | `plan.controller.ts:346-370` `POST /plans/:id/submit-for-approval` |
| RBAC | `@Roles(ADMIN, PLANNER)` | `@Roles(ADMIN, PLANNER)` — **aynı** |
| Servis | `plan.service.ts:729-881` | `approval-workflow.service.ts:65-319` |
| version CAS (T-034f) | `plan.service.ts:766-781` **var** | `approval-workflow.service.ts:207-222` **var** (T-034b'de eklenmiş) |
| Scope (T-028c) | `plan.service.ts:742` `findById(actor)` | `approval-workflow.service.ts:82-100` |
| Ön doğrulama | yalnız `fuCount > 0` (`:783-790`) | mekanik/taktik + RAG + bütçe (`:110-177`) — **üst küme** |
| Bütçe | `reserveForPlan(plan.totalSpend, 'TOTAL')` (`:820-830`) | `reserveBudgetForPlan(on,'ON_INVOICE')` + `(off,'OFF_INVOICE')` (`:237-262`) |
| Bütçe kapısı | **YOK** (reserveForPlan içi tek kontrol) | `checkBudgetAvailability` → `overallSufficient` (`:154-167`) |
| Yetersiz bütçe sonucu | **400 fırlatır** (`budget.service.ts:557-561`) | **200 + `success:false` + `validationErrors`** (`:169-177`) |
| `plans.on/off_invoice_spend` yazımı | **YOK** | var (`:275-276`) |
| Frontend | `plans.endpoints.ts:299-300` → `PlanDetailPage.tsx:106-107` | **sıfır referans** (`grep -rn "submit-for-approval" collmind.frontend/src` → boş) |

ADR 0005'in ölçümü **doğrulandı**: `/submit-for-approval` üründen erişilemez.
Ek olarak `version` CAS'ın iki uçta da bulunduğu ölçüldü (ADR 0005'in "YOK" satırı T-034b sonrası
güncelliğini yitirmiş — yakınsama kararını değiştirmez, çünkü frontend zaten `/submit`'te).

### §2.2 Kova (bucket) mekaniği — kim kova-farkındalı, kim değil

| Yer | Kovayı nereden alıyor? | In-flight TOTAL satırı için sonuç |
|---|---|---|
| `budget.service.ts:70-75` `matchesBucket` | `bucket==='TOTAL' ? !tx.spendType : tx.spendType===bucket` | TOTAL = "tipsiz" |
| `budget.service.ts:456-598` `reserveForPlan` | **çağırandan** (`bucket` parametresi, zorunlu) | yalnız yazma tarafı |
| `budget.service.ts:794-865` `commitAllReservedForPlan` | **veriden keşif** (`:812-820`) | TOTAL kovayı **görür ve commit eder** ✅ |
| `budget-reservation.service.ts:171-307` `releaseNetReservation` | **veriden keşif** (`:210-236`) | UNTYPED kovayı **görür ve release eder** ✅ |
| `plan.service.ts:1065` approve | `commitAllReservedForPlan` | ✅ |
| `approval-workflow.service.ts:519` approvePlan | `commitAllBudgetForPlan` → aynı metot | ✅ |
| `plan.service.ts:1222` reject / `:1411` delete | `releaseForPlan` → net motor | ✅ |
| `approval-workflow.service.ts:602/678` reject/requestChanges | aynı motor | ✅ |

**Bu, brief'teki en kritik korkuyu yapısal olarak kapatır:** teardown (RELEASE) ve
COMMIT tarafları **çağıranın hangi kovayı istediğine değil, veride hangi kovaların olduğuna**
bakar. Yeni kod yalnız ON/OFF **yazsa** bile, eski TOTAL satırları release/commit edilmeye devam eder.
**Bağlayıcı kural (K1, aşağıda):** bu keşif davranışı T-056'da **bozulamaz**; `'TOTAL'` kova tipi
`PlanBudgetBucket`'tan (`budget.service.ts:40`) **kaldırılamaz**, yalnızca **yazma tarafında**
kullanımdan düşer (read-only legacy).

### §2.3 🔴 YENİ BULGU F1 — `commitAllReservedForPlan` kova keşfi **net-tabanlı değil**

`budget.service.ts:812-820`:

```ts
for (const tx of existingTransactions) {
  if (tx.txType === RESERVE && tx.txStatus === POSTED) {
    bucketKeys.add((tx.spendType ?? 'TOTAL') as PlanBudgetBucket);   // ← HAM SATIR VARLIĞI
  }
}
```

Kova, **net'i sıfırlanmış (release edilmiş)** bir RESERVE satırı yüzünden de keşfediliyor.
Sonra `commitReservedForPlan` o kovada `outstandingReserve`'i yine **ham** arıyor
(`:656-661`) ve CONVERT-RELEASE + COMMIT yazıyor (`:669-719`).

**Bugün neden patlamıyor:** bir planın tüm satırları tek kovada olduğu için, reject→resubmit
döngüsünde `findTransactionsBySource` `createdAt DESC` sıralı döner (`budget.repository.ts`
`findTransactionsBySource`) → `.find()` **en yeni** (GEN2) RESERVE'i seçer, doğru tutar commit edilir.

**Bugün bile ulaşılabilir (çapraz-yol):** plan `/submit` (TOTAL) → reject (UNTYPED RELEASE) →
return-to-draft → `/submit-for-approval` (ON+OFF) → approve. `bucketKeys = {TOTAL(bayat), ON, OFF}`
→ TOTAL kovası için **hayalet** CONVERT-RELEASE + COMMIT yazılır.
`v_budget_summary.reserved_amount` net'i korur (−A +A) **ama**
`getReservedAmount` (`budget.repository.ts`, `RESERVE − RELEASE`, COMMIT'i saymaz) o plan için
**negatife** düşer ve APPROVED plan bayat bir jenerasyonun COMMIT'ini taşır.

**T-056 için neden bloklayıcı:** yakınsama, "TOTAL kovadan tipli kovaya geçmiş plan"ı
**istisnai** olmaktan çıkarıp **in-flight planların normal hâli** yapar. Bu yüzden F1,
T-056'nın **ilk adımı** olarak düzeltilmelidir (§6 Adım 1). Sınıfı: [[T-033]] ("ham satır varlığı ≠ net")
bir seviye yukarıda tekrarı.

### §2.4 🔴 YENİ BULGU F2 — availability okuması transaction'a bağlı DEĞİL

`budget.repository.ts:436-447` `getBudgetSummary` → `this.dataSource.getRepository(BudgetSummaryView)`
— **`manager` parametresi yok**. `checkBudgetAvailability` (`:472-484`) ve dolayısıyla
`reserveForPlan`'ın kendi kontrolü (`budget.service.ts:550-555`) **çağıranın açık
transaction'ını görmez**.

Sonuç: tek transaction içinde ardışık iki `reserveForPlan` çağrısı **aynı** (commit edilmemiş,
dolayısıyla görünmeyen) availability değerini okur. Tasarım 0008 §5.5'in
*"ikinci rezervasyon, birincinin yazdığı net'i gördüğü için sıralı çağrılarda otomatik doğrudur"*
varsayımı **YANLIŞ**. R3 (on tek başına sığar, off tek başına sığar, ikisi birlikte sığmaz)
sıralamayla kapanmaz.

**Sonuç (bağlayıcı):** ADR 0004 Karar 2'nin *"her iki tip de yazımdan ÖNCE kontrol edilmeli"*
kuralı, yakınsamış `/submit` için **tek koruma katmanıdır** — nice-to-have değil.
(`/submit-for-approval` bugün bunu `:154-167`'deki `overallSufficient` kapısıyla sağlıyor;
`/submit`'in **hiç kapısı yok** — bugün tek tutar rezerve ettiği için sorun değil, tipli
dünyada olur.)

### §2.5 Tek türetim noktası zinciri (T-052) — ölçülmüş

- `spend-calculation.service.ts:592-617` `buildMechanicValues` — `plan_mechanic_values` + `plan_fus.tactics` birleşimi, çakışmada tactics kazanır.
- İki tüketici: `spend-calculation.service.ts:652` (`calculateAllSpendsForFU`) ve `plan.service.ts:1743` (recalc).
- `spend-calculation.service.ts:511-514`: **`planned.totalSpend = totalOnInvoice + totalOffInvoice`** — SKU başına, tanım gereği.
- `plan.service.ts:1821/1827/1995-1997/2029-2044`: `plan.totalSpend = Σ_FU Σ_SKU planned.totalSpend`.
- `approval-workflow.service.ts:971-999`: `on/off = Σ_FU aggregatedPlanned.totalOn/OffInvoice` — aynı per-SKU fonksiyondan (`spend-calculation.service.ts:681-701`).

→ **Aynı girdilerde `on + off ≡ totalSpend` matematiksel bir özdeşliktir**, T-052'nin
`path1=14500 == path2=10000+4500` ölçümü bunun sayısal doğrulamasıdır. **İki yolun ayrı
hesaplaması değil, tek hesabın iki okunuşudur** — bu, §4.2'deki kararın temelidir.

- `spend-calculation.service.ts:428-509`: `SpendingType.BOTH` **`MechanicCategory` ile** çözülür;
  tanınmayan kategori → `logger.warn` + **atla** (`:500-508`). Bütçe katmanına gelen iki skaler
  BOTH içermez → 0008 §5.7 kuralı geçerli, `shared/budget` sınıflandırmayı **yeniden uygulamaz**.

### §2.6 🟡 YENİ BULGU F3 — on/off'un ÜÇÜNCÜ türetimi (raporlama)

`plan.service.ts:2227-2257` (plan analytics / `onOffSplit`) on/off'u **saklanan
`PLANNED_ON_INVOICE_SPEND` / `TOTAL_PLANNED_SPEND` KPI JSONB'sinden** yeniden türetiyor
(`off = max(0, total − on)`), üstelik KPI yoksa **tüm harcamayı on-invoice sayan** bir fallback'i var
(`:2256`). Bu, "aynı olgunun üçüncü türetimi" (T-049/T-052 dersi) ve T-056'nın kararıyla
**tutarsızlığa** açık. **T-056 kapsamına alınmaz** (okuma yolu, para hareketi yok) ama
§4.2'nin persisted-kolon kararı uygulanırsa bu yerin de o kolonlara devredilmesi ayrı task
olarak açılmalıdır (öneri: T-058).

---

## §3 Yakınsamanın hedef mimarisi

### §3.1 Modül sınırları ve bağımlılık yönü

```
modes/planning-first/plan/                    shared/
  plan.service.ts#submit          ─┐
                                   ├──────►   budget/BudgetService
  approval-workflow.service.ts     │            #checkPlanBudgetAvailability   (YENİ, §3.2)
    #submitForApproval            ─┘            #reserveTypedForPlan           (YENİ, §3.2)
                                                #reserveForPlan  (değişmez, alt seviye)
  (her ikisi de)                  ─────────►  spend-calculation/SpendCalculationService
                                                #buildMechanicValues (T-052 zinciri)
```

**Bağlayıcı yön kuralları:**
- `shared/budget` **hiçbir zaman** `modes/*`'a bağımlı olmaz. (Bugün doğru, korunacak.)
- `shared/budget` on/off **sınıflandırması yapmaz**; iki hazır skaler tüketir (0008 §5.7).
- İki mode-servisi birbirinin **private** metodunu paylaşamaz → bugün
  `approval-workflow.service.ts:1031-1154`'te duran `checkBudgetAvailability`
  (saf bütçe-domain mantığı: zarf çözümü + availability + UNSPLIT birleşik kural + Karar 2 eki)
  **`shared/budget`'a yükseltilir**. Aksi hâlde `PlanService` ya AWS'nin private'ını kopyalar
  (= iki türetim, oturumun ana hata sınıfı) ya da mode-servisleri arası bağımlılık doğar.
- `ApprovalWorkflowService`, `PlanService`'e **enjekte edilebilir** (döngü yok — ölçüldü:
  `plan.service.ts` ctor'ında AWS yok, `plan.module.ts:41-43` ikisini de aynı modülde sağlıyor).
  Ama §4.6'daki nedenlerle T-056'da **bu bağ kurulmaz**; paylaşım `shared/budget` üzerinden olur.

### §3.2 `shared/budget`'a eklenecek iki genel metot (imza taslağı — iskelet, implementasyon değil)

```ts
// budget.service.ts — YENİ (approval-workflow.service.ts:1031-1154'ten YÜKSELTİLİR, mantık AYNI)
async checkPlanBudgetAvailability(
  tenantId: string, channel: string, periodMonth: string,
  amounts: { onInvoice: number; offInvoice: number },
): Promise<{
  onInvoice:  { available: number; requested: number; sufficient: boolean };
  offInvoice: { available: number; requested: number; sufficient: boolean };
  overallSufficient: boolean;
  unsplitSharedEnvelope: boolean;      // YENİ alan (bilgilendirme; mevcut alanlar AYNEN korunur)
}>;

// budget.service.ts — YENİ: ADR 0004 Karar 2'nin atomikliğini TEK yerde uygular
async reserveTypedForPlan(
  planId: string,
  amounts: { onInvoice: number; offInvoice: number },
  channel: string, periodMonth: string, currency: string,
  tenantId: string, userId: string,
  manager?: EntityManager,
): Promise<BudgetTransaction[]>;
```

`reserveTypedForPlan` davranışı (bağlayıcı):
1. **Kapı önce:** `checkPlanBudgetAvailability` → `overallSufficient === false` ise
   `BadRequestException` ve **hiçbir satır yazılmaz** (ADR 0004 Karar 2 — kısmi rezervasyon YOK).
2. **Yalnız fiilen harcanan tipler** değerlendirilir/yazılır: `amount > 0` olmayan tip için
   ne kontrol ne yazma yapılır (ADR 0004 Karar 2 eki). `on=0 && off=0` → boş dizi, no-op.
3. **Deterministik kilit/yazma sırası:** her zaman `ON_INVOICE` sonra `OFF_INVOICE`
   (0008 §6 R4 — deadlock disiplini).
4. Yazma, mevcut `reserveForPlan(..., bucket, manager)`'a delege edilir — **o metot değişmez**
   (kova-farkındalı net/idempotency mantığı T-048/T-053'te kanıtlanmıştı, dokunulmaz).
5. Zarf bulunamazsa: bugünkü `/submit` davranışı korunur → **rezervasyon atlanır**
   (best-effort, `plan.service.ts:809-815`; auto-create-on-approve yolu bunu telafi ediyor).
   ⚠️ Bu "atla" davranışı §4.5'te ayrıca ele alındı.

### §3.3 `'TOTAL'` kovasının yeni statüsü (bağlayıcı kural K1)

| | Bugün | T-056 sonrası |
|---|---|---|
| Yazma | `plan.service.ts:820-830` | **hiçbir yerde** (tek istisna: `commitReservedForPlan`'ın legacy fallback'i, `budget.service.ts:822-837`) |
| Okuma/keşif | `matchesBucket`, `commitAllReservedForPlan`, `releaseNetReservation` | **aynen korunur** |
| Tip tanımı | `budget.service.ts:40` | **korunur** (silinmez) |
| Key formatı | `RESERVE\|PLAN\|<id>\|<env>` (soneksiz) | **değiştirilmez**; yeni satır üretmez |

Gerekçe: mevcut/üretimdeki TOTAL satırlarının release ve commit edilebilirliği yalnızca bu
okuma yollarının korunmasıyla garanti edilir (§2.2). Kaldırmak = [[T-030]] F1'in tekrarı.

---

## §4 Tasarım kararları (brief'in 7 sorusuna cevap)

### §4.1 Karar D1 — UNSPLIT boyutta `/submit` **iki tipli RESERVE** yazar

**Karar:** yakınsama sonrası `/submit`, `on>0` ve `off>0` olan **her tip için ayrı** RESERVE yazar
(bugün A8c'de `/submit-for-approval`'ın yaptığının aynısı). Boyut UNSPLIT olsa bile.

**Gerekçe:**
1. Aksi (UNSPLIT'te TOTAL, SPLIT'te tipli) **kovayı boyut durumuna göre değiştirmek** demektir:
   iki davranış, ikisinden biri hiç test edilmeyen üretim yolu — yakınsamanın kapatmaya çalıştığı
   sınıfın **yeni bir ekseninde** yeniden doğması ([[T-052]]/[[T-053]] deseni).
2. Bugün hiçbir boyut bölünmemiş olduğundan "SPLIT'te tipli" dalı **hiç koşmazdı** →
   [[T-019b]]'nin `SPEND_TYPE_REQUIRED_FOR_SPLIT_DIMENSION` guard'ı ilk gerçek split'te
   canlı UI'ı kırardı (ADR Karar 5'in kabul ettiği bedel, ki T-056 tam da onu kapatmak için var).
3. Zarf **düzeyindeki para değişmez:** iki satırın toplamı bugünkü tek satırın tutarına eşittir
   (§4.2 D2 bunu yapısal olarak garanti eder) → `v_budget_summary.reserved_amount` **birebir aynı**.

**Bedeli:** plan başına satır sayısı 1 → 2 olur; satır **sayan** e2e assert'leri değişir (§5).

### §4.2 Karar D2 — on/off ayrımı **recalc'te türetilir, plan satırında saklanır**; submit okur

İki seçenek ölçüldü:

| | **A) Submit anında `calculateSpendBreakdown`** (submitForApproval'ın bugünkü yolu) | **B) recalc'te türet + `plans.on/off_invoice_spend`'e yaz, submit oku** ✅ |
|---|---|---|
| Türetim noktası | `calculateAllSpendsForFU` → `buildMechanicValues` | recalc döngüsü → **aynı** `buildMechanicValues` (`plan.service.ts:1743`) |
| `on+off == totalSpend` | ⚠️ **garanti değil**: `totalSpend` saklanan (son recalc), breakdown taze; master-data değişmişse **ayrışır** → rezerve edilen tutar bugünkünden **farklı** olur | ✅ **inşaat gereği eşit** — ikisi de aynı döngüde, aynı `spendBreakdown` nesnesinden (`spend-calculation.service.ts:511-514`) |
| Gecikme (submit) | FU başına tam ağaç okuma + SKU başına spend hesabı — [[T-046a]]'nın 500 SKU × 3 mekanikte **+1746 ms** ölçtüğü yüzey | **+0** (iki kolon okuması) |
| Geriye uyum | rezerve edilen tutar değişebilir → "gördüğüm plan ≠ düşen bütçe" | rezerve edilen **toplam** bugünküyle **aynı** |
| T-034f `version` CAS anlamı | CAS `totalSpend`'i korur ama rezerve edilen taze değer korunmaz | CAS'ın koruduğu değerle rezerve edilen değer **aynı** |
| Kolon/migration | — | **gerekmez**: `plans.on_invoice_spend` / `off_invoice_spend` **zaten var** (NOT NULL default 0, `\d main.plans` ile doğrulandı) |

**Karar: B.** `recalculatePlanWithKpiEngineLocked` zaten SKU başına
`spendBreakdown.planned.totalOnInvoice`'ı okuyor (`plan.service.ts:1826`); FU ve plan seviyesinde
`planTotalSpend` ile **aynı döngüde** biriktirilip son `updateUnversioned` çağrısına
(`plan.service.ts:2029-2044`) iki alan eklenir. Off = `totalSpend − onInvoice` **değil**,
`planned.totalOffInvoice` **doğrudan** toplanır (çıkarma, F3'ün fallback hatasını tekrarlar).

**Bayat/legacy plan koruması (bağlayıcı):** submit, iki kolonu okur ve **invaryantı doğrular**:

```
|on + off − totalSpend| <= 0.01   ?  → kolonları kullan
                            değilse  → SpendCalc'ten TAZE türet (tek fallback yol) ve
                                       aynı transaction'da kolonları düzelt
```

Gerekçe: kolonlar bugün **yalnızca** `/submit-for-approval` tarafından yazılıyor
(`approval-workflow.service.ts:275-276`) → recalc'ten geçmiş ama bu uçtan geçmemiş her plan
`0/0` taşır. Guard olmasaydı submit **0 rezerve ederdi** — sessiz under-encumbrance,
tam olarak bu oturumun tekrar eden hata sınıfı. Fallback **gürültülü değil sessiz-onarıcı**dır
(canlı UI rotası kırılmamalı) ama `logger.warn` + audit description eki ile **görünür** olmalıdır.

> **§5.7 uyumu:** her iki dalda da sınıflandırma `SpendCalculationService`'ten gelir; `shared/budget`
> yalnız iki skaleri tüketir. `plan.service` de sınıflandırma yapmaz — yalnız **taşır**.

### §4.3 Karar D3 — idempotency key uzayı: **`/submit-for-approval` ile AYNI uzay**

Yeni tipli yol şu key uzayını kullanır (bugün `/submit-for-approval`'ın yazdığıyla birebir aynı,
`budget.service.ts:572-576`):

```
RESERVE|PLAN|<planId>|<envelopeId>|ON_INVOICE            (+ |GEN<n> jenerasyon soneki)
RESERVE|PLAN|<planId>|<envelopeId>|OFF_INVOICE           (+ |GEN<n>)
RELEASE|PLAN|<planId>|<envelopeId>|<TYPE>                (T-053, budget-reservation.service.ts:251-253)
RELEASE|PLAN|<planId>|<envelopeId>|CONVERT|<TYPE>        (budget.service.ts:674)
COMMIT |PLAN|<planId>|<envelopeId>|<TYPE>                (budget.service.ts:701)
```

**TOTAL uzayı (`…|<envelopeId>` soneksiz) hiç değiştirilmez** — [[T-053]] dersi ve 0008 §5.4'ün
iki-uzay kuralı aynen geçerli. Yeni uzay **zaten yaşıyor** (A8c/A17 satırları), yani T-056
*yeni bir key formatı icat etmiyor*; sadece **ikinci bir yazıcı** ekliyor.

**"İki uç aynı planda sırayla çağrılırsa çift rezervasyon olur mu?" — HAYIR, iki katmanlı kanıt:**
1. **State machine:** her iki uç da yalnız `DRAFT`'tan çalışır (`plan.service.ts:761-763`,
   `approval-workflow.service.ts:102-104`) ve ilk çağrı planı `PENDING_APPROVAL` yapar →
   ikinci çağrı **400**. Pencere fiilen yok.
2. **Kova-bazlı net idempotency:** teorik olarak aynı DRAFT'ta ikisi de koşsa bile,
   `reserveForPlan`'ın `netOutstanding > 0 && envelopeReserves.length > 0` erken dönüşü
   (`budget.service.ts:542-547`) aynı kovada ikinci satırı **yazmaz**.
   D2 sayesinde iki uç **aynı tutarları** hesapladığı için sessiz tutar farkı da oluşmaz.

**GEN soneki:** sayaç kova+zarf kapsamlı (`envelopeReserves`, `budget.service.ts:504-510`).
TOTAL geçmişi olan bir plan tipli kovaya ilk kez yazarken sayaç **0**'dır → **soneksiz** key üretir,
eski TOTAL key'iyle **çakışmaz** (farklı sonek uzayı). ✅

### §4.4 Karar D4 — geçiş (in-flight PENDING/APPROVED planlar): **veri göçü YOK**

**Karar: geriye dönük hiçbir satır dönüştürülmez, taşınmaz, yeniden etiketlenmez.**
Ne migration, ne REHOME-benzeri append-only kova geçişi.

**Gerekçe (ölçülmüş):**
1. Dev'de nüfus **sıfır** (§1.1).
2. Nüfus sıfır olmasa bile TOTAL satırları **terminal geçişlerde doğru işlenir**: release ve commit
   tarafları kovayı **veriden keşfediyor** (§2.2). Yani "sonsuza dek asılı kalma" senaryosu
   ([[T-030]] F1 sınıfı) **kod okumasıyla dışlanmıştır** — F1 hariç (§2.3), o da Adım 1'de kapanır.
3. Bir kova geçişi (TOTAL → ON/OFF) **para taşımak** demektir; 0008 §4'ün en güçlü tasarım özelliği
   "faz 1'de hiç para taşınmaz" idi. Uçuştaki bir planın encumbrance'ını taşımak, [[T-019b]]'nin
   REHOME'unda gerekli olduğu gibi ayrı key uzayı + net korunum kanıtı gerektirir — **kanıtlanmış
   ihtiyaç olmadan** bu riski almak, oturumun hata sınıfını davet eder.

**Uçuştaki planların yaşam döngüsü (T-056 sonrası, kova bazında):**

| Senaryo | Davranış | Kanıt |
|---|---|---|
| PENDING (TOTAL) → approve | `commitAllReservedForPlan` TOTAL'ı keşfeder, CONVERT-RELEASE + COMMIT (TOTAL) | `budget.service.ts:812-820` + `:669-719` |
| PENDING (TOTAL) → reject / requestChanges | `releaseNetReservation` UNTYPED kovayı keşfeder, **eski key formatıyla** tek RELEASE | `budget-reservation.service.ts:210-253` |
| REJECTED (TOTAL) → return-to-draft → **yeni** submit | TOTAL net'i zaten 0; yeni **tipli** kovalara yazılır; F1 fix'i sayesinde approve yalnız net>0 kovaları commit eder | Adım 1 + `:542-547` |
| APPROVED (TOTAL COMMIT) | dokunulmaz | — |
| DRAFT (rezervasyonsuz) | doğrudan yeni yol | — |

**Üretim öncesi zorunlu doğrulama (kanıt SQL — deploy checklist'ine girer):**

```sql
-- 1) Uçuşta TOTAL encumbrance taşıyan plan var mı?
SELECT p.status, count(DISTINCT p.id) AS plans,
       sum(CASE WHEN bt.tx_type IN ('RESERVE','COMMIT') THEN bt.amount
                WHEN bt.tx_type = 'RELEASE' THEN -bt.amount ELSE 0 END) AS net_untyped
FROM main.plans p
JOIN main.budget_transactions bt
  ON bt.source_type = 'PLAN' AND bt.source_id = p.id AND bt.spend_type IS NULL
 AND bt.tx_status = 'POSTED'
WHERE p.deleted_at IS NULL
GROUP BY p.status ORDER BY 1;

-- 2) Kova bazinda asili net (her kova >= 0 olmali; terminal statude 0 olmali)
SELECT * FROM (
  SELECT p.status,
         bt.envelope_id,
         coalesce(bt.spend_type::text, 'UNTYPED') AS bucket,
         sum(CASE WHEN bt.tx_type IN ('RESERVE','COMMIT') THEN bt.amount
                  WHEN bt.tx_type = 'RELEASE' THEN -bt.amount ELSE 0 END) AS net
  FROM main.budget_transactions bt
  JOIN main.plans p ON p.id = bt.source_id
  WHERE bt.source_type = 'PLAN' AND bt.tx_status = 'POSTED'
  GROUP BY 1, 2, 3
) x
WHERE net < 0                                        -- ASLA olmamali
   OR (net <> 0 AND status = 'REJECTED')                             -- terminal: asili kalmis rezerv
   -- (APPROVED'da net > 0 NORMALDIR: RESERVE, COMMIT'e donusmustur; enum'da CANCELLED YOK —
   --  main.plans_plan_status_enum = DRAFT|PENDING_APPROVAL|APPROVED|REJECTED|PENDING_FINANCE_REVIEW)
ORDER BY 1, 2, 3;

-- 3) Ledger korunumu (T1 invaryantı) — her zarf için
SELECT e.code, s.reserved_amount,
       (SELECT coalesce(sum(CASE WHEN t.tx_type IN ('RESERVE','COMMIT') THEN t.amount
                                 WHEN t.tx_type='RELEASE' THEN -t.amount ELSE 0 END),0)
          FROM main.budget_transactions t
         WHERE t.envelope_id = e.id AND t.tx_status='POSTED') AS ledger_net
FROM main.budget_envelopes e JOIN main.v_budget_summary s ON s.envelope_id = e.id;
```

(1) boş dönerse geçiş tamamen risksizdir. Boş dönmezse: **yine göç yapılmaz**, ancak §6 Adım 5
öncesinde bu planların terminal duruma sürülmesi (approve/reject) veya kabul edilmesi
**ürün sahibi kararıdır** (§8 Q1).

### §4.5 Karar D5 — zarf yokluğu ve tipli arama

`/submit`'in bugünkü tipsiz zarf yoklaması (`plan.service.ts:810-814`) **kaldırılır**;
zarf çözümü artık `reserveTypedForPlan` içinde **tip verilerek** yapılır. Bunun iki etkisi var:

1. **T-056'nın asıl amacı burada gerçekleşir:** `SPEND_TYPE_REQUIRED_FOR_SPLIT_DIMENSION`
   (`budget.repository.ts:208-226`) guard'ı **`spendType` verildiğinde hiç devreye girmez**
   (`:169-174`) → bölünmüş boyutta canlı submit **çalışır**. (ADR Karar 5'in "T-056 kapanana kadar
   split üretimde kullanılmamalı" kısıtı bu adımla kalkar.)
2. `plan.service.ts:910` (`checkBudget`, okuma) ve `:1019` (approve auto-create) **hâlâ tipsiz**.
   T-056 kapsamı brief'e göre submit yolu; bu ikisi **[[T-057]]**'de kalır. **Ama dikkat:**
   `:1019` bölünmüş boyutta 400 verir → **submit çalışır, approve kırılır**. Bu kabul edilemez bir
   ara durumdur → **T-056, `:1019`'u da tipli hale getirmek zorundadır** (§6 Adım 6). `:910`
   (yalnız okuma, `hasBudget` göstergesi) T-057'ye bırakılabilir; bölünmüş boyutta 400 döner
   ve UI'da bütçe rozeti bozulur, para akışı etkilenmez.

### §4.6 Karar D6 — `/submit-for-approval`'ın kaderi: **iki aşamalı deprecation**

**Ölçülmüş engel:** iki uç **eşdeğer değil**. `/submit-for-approval` bir **üst küme** ön doğrulama
çalıştırıyor (`approval-workflow.service.ts:110-177`: her FU'da mekanik/taktik zorunluluğu, RAG
uyarısı, bütçe kapısı) ve **farklı bir hata sözleşmesi** kullanıyor (200 + `success:false` +
`validationErrors`, `/submit`'te ise 400 exception). Uçları bugün tek satırda birleştirmek
ya canlı `/submit`'e **yeni doğrulama katmanı** ekler (bugün geçen planlar reddedilmeye başlar —
davranış regresyonu) ya da `/submit-for-approval` çağıranları için sözleşmeyi kırar.

**Aşama 1 (T-056 — bu tasarım):** *tek para yolu*.
- Her iki uç da `BudgetService#reserveTypedForPlan` + `#checkPlanBudgetAvailability` kullanır →
  **rezervasyon semantiği bit-düzeyinde ortak**.
- `/submit-for-approval` **deprecated** işaretlenir: `@ApiOperation({ deprecated: true })`,
  yanıtta `Deprecation: true` + `Sunset` başlığı, servis girişinde `logger.warn` (çağıran tespiti).
- **Endpoint kaldırılmaz, davranış sözleşmesi değişmez** → A8, A8c, A17 **olduğu gibi yeşil kalır**
  ve yakınsama sonrası iki ucun **aynı ledger sonucunu** ürettiğini kanıtlamaya devam eder.
  (A17 = [[T-053]] reject→resubmit koruması; Aşama 1'de **yerinde yaşar**.)
- `/submit` üzerine **A8c′ ve A17′ ikizleri** eklenir (§5.2) → aynı korumalar canlı rotada da kilitlenir.

**Aşama 2 (ayrı task, T-058 önerilir):** *tek endpoint*.
- Ürün sahibi kararı: `/submit` ön doğrulamaların üst kümesini **almalı mı**? (§8 Q2)
- Karar geldikten sonra `/submit-for-approval` ya `/submit`'e **saf adaptör** olur ya da kaldırılır;
  A8/A8c/A17 ikizlerine taşınır ve orijinaller silinir.
- **Aşama 1'in kabul kriteri:** ikizler 3 ardışık reset'siz koşumda yeşil olmadan Aşama 2 başlamaz.

> ADR 0005 "tek submit yolu kalır" diyor; bu tasarım onu **iki adımda** teslim eder. Sapma değil,
> sıralama: para yolu T-056'da tekleşir (kararın özü), endpoint yüzeyi ölçülmüş bir ürün sorusu
> (§8 Q2) cevaplandıktan sonra tekleşir. **Bu, ürün sahibinin onayına sunulmalıdır.**

### §4.7 Karar D7 — T-034f `version` CAS'ı aynen korunur

`plan.service.ts:766-781` (MISSING_VERSION / STALE_VERSION + `current.totalSpend` gövdesi) ve
`:836-859` status-CAS **hiç değişmez**. Yeni bütçe mantığı, bugünkü rezervasyon bloğunun
**tam olarak durduğu yere** (`:809-832`, kilit alındıktan ve version doğrulandıktan **sonra**,
status-CAS'tan **önce**) yerleşir. Frontend sözleşmesi (`plans.endpoints.ts:299-300`,
`PlanDetailPage.tsx:106-107`, `utils/versionConflict.ts`) değişmez.
**Mutasyon kanıtı zorunlu:** version CAS bloğu söküldüğünde `optimistic-locking.e2e-spec.ts:1055-1114`
kırmızıya düşmelidir (bugün de düşüyor — koruma canlı).

---

## §5 Değişecek testler — isim isim (Team Lead'in "hiçbir test gevşetilmez" kuralı için)

> Kural yorumu: aşağıdaki assert'ler **gevşetilmiyor**, *satır sayısı* iddiasından
> *kova bazlı tutar* iddiasına **sıkılaştırılıyor**. Her biri için "eski assert neyi koruyordu →
> yeni assert onu nasıl daha sıkı koruyor" karşılığı verilmiştir.

### §5.1 Değişmesi ZORUNLU (D1'in doğrudan sonucu — 1 RESERVE → 2 RESERVE)

Etkilenen fixture'lar `CPP_ON_PCT` (on-invoice) **ve** `VIS_LS` (off-invoice, lumpsum) taktiklerini
birlikte giriyor (`mechanics` tablosundan doğrulandı) → plan **her iki tipi de** harcıyor.

| # | Dosya:satır | Bugünkü assert | Yeni assert | Neden daha sıkı |
|---|---|---|---|---|
| 1 | `test/role-journey.e2e-spec.ts:1113` (A14b) | `budgetTxAfterSubmit.length === 1` | `=== 2`; `bySpendType.ON_INVOICE > 0 && OFF_INVOICE > 0`; **`ON+OFF === plan.totalSpend`** | tutar iddiası ekleniyor (bugün hiç yok) |
| 2 | `test/role-journey.e2e-spec.ts:1177-1183` (A14e) | ilk `RESERVE`.amount === ilk `COMMIT`.amount (`.find`, sıralamaya bağlı, **kırılgan**) | **kova bazında**: her tip için `COMMIT(tip) === RESERVE(tip)`, `COMMIT` sayısı === kova sayısı | sıralama bağımlılığı kalkıyor, kova sıkışması (T-048) yakalanır |
| 3 | `test/role-journey.e2e-spec.ts:1256-1262` (A15b) | ilk `RELEASE`.amount === ilk `RESERVE`.amount | kova bazında eşitlik + **`net(kova) === 0`** | T-053 sınıfı sızıntıyı doğrudan kilitler |
| 4 | `test/role-journey.e2e-spec.ts:1379` (A16c) | `budgetTxAfterReturn.length === 2` | `=== 4` (2 RESERVE + 2 RELEASE) **ve** her kova net `0` | ham sayı yerine net iddiası |
| 5 | `test/role-journey.e2e-spec.ts:1441-1447` (A16e) | `RESERVE===2, COMMIT===1, RELEASE>=2` | `RESERVE===4, COMMIT===2, RELEASE>=4`; **kova bazında net === COMMIT toplamı** | jenerasyon×kova matrisini kapsar |
| 6 | `test/optimistic-locking.e2e-spec.ts:1145` | `commitTx.length === 1` ("no double COMMIT") | `commitTx.length === <kova sayısı>` **ve** `COMMIT|PLAN|…` key'leri **distinct** | "çift COMMIT yok" iddiası key düzeyinde kanıtlanır (sayı düzeyinde değil) |
| 7 | `test/optimistic-locking.e2e-spec.ts:~1185` (race testi) | aynı | aynı düzeltme | aynı |
| 8 | `src/.../plan.service.spec.ts:387-397` | `reserveForPlan(..., 'TOTAL', manager)` çağrıldı | `reserveTypedForPlan({onInvoice, offInvoice}, …)` çağrıldı; ayrıca **`overallSufficient=false` iken hiç çağrılmadığı** | ADR Karar 2 atomikliği unit seviyede kilitlenir |

### §5.2 EKLENECEK (kapsama boşluğunu kapatan yeni testler)

| # | Test | Neyi kilitler |
|---|---|---|
| 9 | **A8c′** — `/submit` iki tipli RESERVE yazar (A8c'nin canlı-rota ikizi) | D1; T-048 korumasının canlı rotada da geçerli olduğu |
| 10 | **A17′** — `/submit` ile submit → reject → return-to-draft → resubmit, **her iki kovada** yeni RESERVE (`|GEN2`) | [[T-053]] korumasının canlı rotada yaşadığı (brief madde 4) |
| 11 | **A18 (yeni)** — TOTAL kova mirası: elle `RESERVE|PLAN|…|<env>` (spend_type NULL) satırı kurulmuş PENDING plan → approve → **yalnız 1 COMMIT (TOTAL)**, hayalet COMMIT yok | §2.3 F1; in-flight geçiş güvenliği |
| 12 | **A19 (yeni)** — aynı plan: TOTAL RESERVE + reject(RELEASE) → resubmit(tipli) → approve → **TOTAL kovada COMMIT YOK**, yalnız ON/OFF COMMIT | F1'in tam senaryosu (brief madde 1) |
| 13 | **SP-E2E-10 (yeni, `budget-envelope-split.e2e-spec.ts`)** — boyut split edildikten **sonra** `/submit` → 200 ve **doğru tipli zarflara** RESERVE | ADR Karar 5 kısıtının kalktığı; T-056'nın asıl ürün değeri |
| 14 | **Unit** — `reserveTypedForPlan`: on=60/off=60, available=100 (UNSPLIT) → **400 ve 0 satır** | ADR 0004 Karar 2 + §2.4 F2 (0008 §7 T3'ün canlı-rota karşılığı) |
| 15 | **Unit** — `on>0, off=0` ve off zarfı %100 dolu → submit **geçer** | ADR Karar 2 **eki** (yalnız harcanan tipler) |
| 16 | **Unit/e2e** — `on+off == totalSpend` invaryantı: recalc sonrası kolonlar ile `calculateAllSpendsForFU` çıktısı **eşit** | T-052'nin "iki yol aynı sonuç" kanıtının **yeni seamdeki** devamı (§4.2/brief madde 6) |
| 17 | **DB invaryantı** (T1, mevcut helper'a ek) | `Σ kovalar == v_budget_summary.reserved_amount` ve `net(kova) >= 0` |

### §5.3 DEĞİŞMEYECEK (bilinçli — regresyon kalkanı)

- `budget.service.spec.ts:211-258` — **TOTAL kovanın** key formatı ve idempotency testleri:
  K1 gereği TOTAL okuma/legacy davranışı korunduğu için **aynen geçmeli**. Bu iki test,
  D3'ün "eski uzay değişmedi" iddiasının kilididir.
- `budget.service.spec.ts:518-560` — bucket-blind commit mutasyon kanıtı.
- `role-journey` A8, A8c, A17 — Aşama 1'de `/submit-for-approval` yaşadığı için **dokunulmaz**.
- `test/budget-envelope-split.e2e-spec.ts` SP-E2E-01…09 — split ucu davranışı değişmiyor.
- Frontend: hiçbir test/dosya değişmez (uç, gövde ve hata sözleşmesi aynı).

**T-052'nin `path1 = path2` testine ne olur (brief madde 6):** A8c içindeki karşılaştırma
`/submit-for-approval` ucu yaşadığı sürece **aynen kalır ve geçer** (D2, iki ucu aynı sayılara
bağladığı için ilişki güçlenir). Ancak D2 sonrası bu assert "iki bağımsız türetim uyuşuyor"u
değil "aynı türetimin iki okunuşu uyuşuyor"u kanıtlar → **sürükleme dedektörü #16 ile yeni seame
taşınır** (recalc'in yazdığı kolonlar ↔ taze `calculateAllSpendsForFU`). Bu, gevşetme değil,
korumanın **doğru yere taşınmasıdır** ve gerekçesi budur.

---

## §6 Adım adım uygulama planı

Kural: **her adım tek başına derlenir, tek başına doğrulanır, tek başına geri alınır (tek commit).**
Her adımda: `npx tsc --noEmit` temiz + unit + **3 ardışık reset'siz e2e** (`SCOPE_ENFORCEMENT_ENABLED`
kapalı/açık/kapalı) + [[T-047]] satır invaryantı + **koşum öncesi ölçülmüş** zarf taban çizgisi
(§1.3 nedeniyle ezberden yazılmaz) + **mutasyon kanıtı** (`tsc` TEMİZ kalarak test KIRMIZI).

| Adım | İş | Mutasyon kanıtı (bu adımın koruması nasıl kırmızıya düşer) | Geri alma |
|---|---|---|---|
| **1** | **F1 fix (§2.3):** `commitAllReservedForPlan` kova keşfi **net > 0** olan kovalarla sınırlanır; `commitReservedForPlan`'ın `outstandingReserve` seçimi de net-farkındalı hale gelir | Keşfi ham satıra geri al → **A19/A18 (yeni)** kırmızı: TOTAL kovada hayalet `COMMIT` satırı + o plan için `getReservedAmount` negatif | tek commit revert; hiçbir yazma yolu değişmedi |
| **2** | **`checkPlanBudgetAvailability` yükseltmesi:** `approval-workflow.service.ts:1031-1154` mantığı **aynen** `BudgetService`'e taşınır; AWS delege eder | Yükseltilen metottaki UNSPLIT birleşik dalını (`:1068-1088`) kaldır → **#14** kırmızı (on=60/off=60/available=100 geçmemeli) | saf taşıma (davranış farkı yok) → revert güvenli |
| **3** | **`reserveTypedForPlan` eklenir** (kapı + sıralı yazma + sıfır-atlama); **AWS önce** ona geçer (`:237-262` yerine tek çağrı) | Kapıyı yazmadan **sonraya** al → **#14** kırmızı ve kısmi rezervasyon satırı DB'de görünür | AWS iki çağrıya geri döner |
| **4** | **recalc on/off biriktirir** ve `plans.on/off_invoice_spend`'e yazar (`plan.service.ts:1826/2029-2044`) | Off birikimini `totalSpend − on` çıkarmasına çevir → **#16** kırmızı (tanınmayan-kategori/BOTH atlaması olan planda ayrışır) | kolonlar zaten vardı; yalnız yazma eklenmişti |
| **5** | 🔴 **`/submit` yakınsaması:** `plan.service.ts:809-832` bloğu → invaryant-kontrollü kolon okuma (+ SpendCalc fallback) + `reserveTypedForPlan`; tipsiz zarf yoklaması kaldırılır | Tipli çağrıyı `'TOTAL'`'a geri çevir → **A8c′/#16** kırmızı (`Expected: 2, Received: 1`); fallback guard'ını kaldır → 0/0 kolonlu planda **0 rezervasyon** ve **#16** kırmızı | **canlı rota** — bu adım tek başına revert edilebilir olmalı; §4.4 gereği veri göçü olmadığı için revert sonrası TOTAL yazımına dönüş **sorunsuzdur** (kovalar birbirinden bağımsız) |
| **6** | **approve auto-create tipli çift** (`plan.service.ts:1018-1048`; §4.5 madde 2) | Çift yaratmayı tek zarfa geri al → **SP-E2E-10 (#13)** benzeri approve senaryosu kırmızı | tek zarf davranışına dönüş |
| **7** | **Deprecation (Aşama 1):** Swagger `deprecated`, `Deprecation`/`Sunset` başlıkları, `logger.warn`; **A8c′/A17′** ikizleri eklenir | Başlık/uyarı yok → sözleşme testi kırmızı (yeni, küçük) | tamamen kozmetik, risksiz |

**Sıralama gerekçesi:** 1–4 canlı rotaya **dokunmaz** (yalnız hazırlık ve tipli-yolu-güçlendirme);
tek riskli adım **5**'tir ve ona gelindiğinde tüm korumalar (kapı, net-tabanlı commit, invaryant)
zaten yerinde ve kanıtlanmış olur. Adım 5 tek başına revert edilebilir çünkü D4 gereği
**hiçbir geçmiş satır dönüştürülmemiştir**.

---

## §7 Riskler

| # | Risk | Şiddet | Azaltma | Sınıfdaşı |
|---|---|---|---|---|
| **R1** | Uçuştaki TOTAL encumbrance'ın asılı kalması | Kritik | §2.2 keşif-tabanlı release/commit **korunur** (K1); §4.4 doğrulama SQL'i; A18/A19 | [[T-030]] F1, [[T-053]] |
| **R2** | Hayalet COMMIT (net'i 0 kovaya commit) → `getReservedAmount` negatif, bayat jenerasyon COMMIT'i | **Yüksek, BUGÜN LATENT** | §6 Adım 1 (net-tabanlı kova keşfi) + A18/A19 | [[T-033]] |
| **R3** | UNSPLIT'te on ve off tek tek sığar, birlikte sığmaz | Yüksek | §3.2 kapı **yazımdan önce**; F2 nedeniyle sıralama koruması **yok** — kapı tek katman | 0008 R3 |
| **R4** | Bayat/0-0 `on/off_invoice_spend` kolonları → 0 rezervasyon (sessiz under-encumbrance) | **Yüksek** | §4.2 invaryant guard + SpendCalc fallback + `logger.warn`; test #16 | [[T-052]] |
| **R5** | `/submit`'in rezerve ettiği tutarın değişmesi (kullanıcının gördüğünden farklı) | Orta | D2 (B seçeneği) tutar toplamını **birebir korur**; A seçeneği reddedildi | [[T-034f]] |
| **R6** | İki uç sırayla çağrılırsa çift rezervasyon | Düşük | §4.3: state machine + kova-bazlı net idempotency (iki katman) | [[T-048]] |
| **R7** | Deadlock (iki zarf kilidi ters sırada) | Orta | `reserveTypedForPlan` **her zaman ON→OFF**; tek yerde | 0008 R4 |
| **R8** | `<500ms` bütçesinin aşılması (submit'te taze spend hesabı) | Orta | D2 (B) submit'e **hesap eklemez**; A seçeneği [[T-046a]]'nın 1746 ms'lik yüzeyini submit'e taşırdı | [[T-046a]] |
| **R9** | Split boyutta submit çalışır ama approve kırılır (`:1019` tipsiz) | Yüksek | §6 Adım 6 **T-056 kapsamında** | ADR Karar 5 |
| **R10** | Multi-tenant izolasyonu | Kritik | Yeni metotların **hepsi** `tenantId` parametreli; `findEnvelopeByDimensions`/`getBudgetSummary` zaten `tenant_id` filtreli; SP-E2E-07 deseninde çapraz-tenant testi eklenir | 0008 R10 |
| **R11** | e2e taban çizgisinin kaymış olması (§1.3 çift seed rezervasyonu) → yeşil/kırmızı yanlış okunur | Orta | Her koşumda taban çizgisi **ölçülür**; ayrı task ile seed giriş noktaları tekleştirilir | [[T-047]] |
| **R12** | Üçüncü on/off türetimi (F3, `plan.service.ts:2227-2257`) rapor ile ledger'ı ayrıştırır | Orta | T-056 kapsamı dışı; **T-058** açılmalı | [[T-049]] |

---

## §8 Ürün sahibine sorulacaklar (kanıt yetersiz — uydurulmadı)

| # | Soru | Neden kanıt yok | Cevap gelene kadarki davranış |
|---|---|---|---|
| **Q1** | Üretim DB'sinde uçuşta (PENDING/PENDING_FINANCE_REVIEW) TOTAL encumbrance taşıyan plan **var mı**? Varsa geçiş anında ne yapılsın (bırak-yerinde vs. terminal duruma sür)? | Üretim DB'sine erişim yok; dev'de **0** ölçüldü (§1.1) | §4.4 "bırak-yerinde" (yapısal olarak güvenli, F1 fix'i şart). Deploy öncesi §4.4 SQL'i **koşulmalı** |
| **Q2** | `/submit` (canlı rota), `/submit-for-approval`'ın ön doğrulamalarını (FU'da mekanik/taktik zorunluluğu, RAG uyarısı) **almalı mı**? | BRD submit doğrulamasını bu ayrıntıda tanımlamıyor; bugün iki uç **farklı** davranıyor (§2.1) | Aşama 1'de **alınmaz** (davranış regresyonu riski). Aşama 2 bu cevaba bağlı (§4.6) |
| **Q3** | Yetersiz bütçe sonucu `/submit`'te **400** (bugünkü) mü kalsın, yoksa `/submit-for-approval` gibi **200 + `validationErrors`** mı olsun? | UI sözleşmesi kararı; FE bugün `error.response.data.message` gösteriyor (`PlanDetailPage.tsx:117-119`) | **400 korunur** (FE değişmesin) |
| **Q4** | `plans.on/off_invoice_spend` kolonları bayat/0 iken submit **sessiz onarmalı** mı, yoksa `409 PLAN_RECALC_REQUIRED` ile **gürültülü** mü reddetmeli? | ADR Karar 5 "gürültülü hata"yı tercih ediyor ama orası mis-attribution riskiydi; burada canlı UI'ı kırma riski var | **Sessiz onarım + `logger.warn`** (§4.2). Ürün sahibi tersini isterse §6 Adım 5 tek satırla değişir |
| **Q5** | Seed'in iki giriş noktasının farklı zarf seçmesi (§1.3, 150.000 çift rezervasyon) — dev fixture'ı **düzeltilsin mi**, hangi zarf doğru? | Finance/fixture kararı; hangi zarfın "doğru" olduğu BRD'de yok | Ayrı task; T-056 **dokunmaz**, yalnız taban çizgisini ölçer |

---

## §9 Mimari karar özeti

**⚠️ Koşullu onay.** ADR 0005'in kararı (tipli rezervasyonun canlı `/submit`'e taşınması)
mimari olarak **uygundur**: modül sınırlarını bozmaz (yeni ortak mantık `shared/budget`'a çıkar,
`modes → shared` yönü korunur), tek türetim noktası kuralını güçlendirir, ve para yolunu tekleştirir.
Onay şu **yedi koşula** bağlıdır:

1. **K1 — `'TOTAL'` kova okuma/keşif yolları korunur** (`matchesBucket`,
   `commitAllReservedForPlan`, `releaseNetReservation`); yalnız **yazma** tarafında emekli edilir.
2. **F1 önce düzeltilir** (§6 Adım 1): kova keşfi **net-tabanlı** olur. Bu koşul düşerse
   in-flight planlar hayalet COMMIT üretir — [[T-033]]'ün bir seviye yukarıdaki tekrarı.
3. **Kapı yazımdan önce, tek yerde** (`reserveTypedForPlan`): ADR 0004 Karar 2 (atomiklik) +
   Karar 2 eki (yalnız fiilen harcanan tipler). F2 nedeniyle bu **tek** koruma katmanıdır.
4. **on/off tek türetim noktasından** gelir (`buildMechanicValues` zinciri) ve
   **`on + off == totalSpend`** invaryantı testle kilitlenir; `shared/budget` sınıflandırmayı
   yeniden uygulamaz (0008 §5.7).
5. **Key uzayı değişmez:** TOTAL uzayı dokunulmaz, tipli uzay `/submit-for-approval`'ın
   bugün yazdığıyla **aynı**dır — yeni format icat edilmez.
6. **Geriye dönük satır dönüştürülmez** (§4.4): ne migration, ne REHOME. Geçiş yalnız
   "yeni satırlar tipli yazılır"dır.
7. **T-034f `version` CAS'ı ve frontend sözleşmesi birebir korunur.**

Bu koşullardan biri düşerse karar **❌ uyumsuz**dur: koruma olmadan bu değişiklik, canlı UI
rotasında bu oturumun tekrar eden hata sınıfının (mekanizma var, yol yok / ham satır ≠ net /
sessiz yanlış atıf) sekizinci örneğini üretmeye yapısal olarak açıktır.

**Ek olarak ürün sahibinin onayına sunulur:** §4.6'daki iki aşamalı deprecation
(T-056 = tek para yolu; T-058 = tek endpoint), ADR 0005'in "tek submit yolu kalır" ifadesinin
ölçülmüş kısıtlar altındaki teslim sırasıdır.
