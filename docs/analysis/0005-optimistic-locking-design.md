# 0005 — Optimistic Locking Tasarımı (T-034)

**Durum:** Tasarım / architect kararı · **Tarih:** 2026-07-29 · **Repo:** `collmind.backend` (`staging`)
**İlgili:** T-033 (tespit), T-004 (settlement pessimistic lock), T-029/T-030 (budget saga), T-028c (flag deseni)
**BRD:** `.cursor/rules.md` — "Optimistic locking (eş zamanlı düzenleme)", "desktop-first, grid-heavy, real-time recalc"

---

## 0. Yönetici özeti (karar)

| # | Karar | Kısa gerekçe |
|---|---|---|
| K1 | **`@VersionColumn` KULLANILMAYACAK.** Manuel `version integer` kolonu + **koşullu UPDATE (compare-and-swap)** | Repodaki TÜM mutasyonlar `repo.update()` ile yapılıyor; `@VersionColumn` yalnız `save()` ile çalışır → "var görünen ama çalışmayan" mekanizma üretir |
| K2 | **Karma granülarite:** `plans` (yapı+state), `plan_fus`, `plan_skus` (satır), `agreements` (state) — hepsinde ayrı `version` | Grid hücresi düzenlemesi kendi satırının version'ını kontrol eder → yanlış-pozitif 409 yok |
| K3 | **Plan-geneli tutarlılık optimistic lock ile DEĞİL**, recalc'ın per-plan serialize edilmesiyle (Postgres advisory lock) çözülür | Toplam spend/KPI türetilmiş projeksiyondur; kullanıcı niyeti değildir, çakışma konusu değildir |
| K4 | **Türetilmiş yazımlar (recalc) version kontrol ETMEZ, version BUMP ETMEZ** | Aksi halde her recalc tüm açık grid'leri bayatlatır → 409 fırtınası |
| K5 | **State geçişleri (submit/approve/reject/returnToDraft/close) optimistic DEĞİL**, **status-CAS + `FOR UPDATE`** kullanır. Tek istisna: `submit()` ek olarak client version'ı doğrular | Para hareketi + saga kompanzasyonu var; status CAS çift-submit/çift-approve'a karşı version'dan daha güçlü |
| K6 | Version **DTO/body alanı** olarak taşınır; `If-Match`/ETag **kullanılmaz** | Alt-kaynak (FU/SKU) seviyesinde ayrı version var; tek parent ETag bunu ifade edemez |
| K7 | 409 + `code:'STALE_VERSION'` **+ güncel entity gövdesi** döner | Grid tek round-trip'te hücreyi tazeler; mevcut yapısal-hata deseniyle (`OUT_OF_SCOPE`, `ALREADY_SETTLED`) uyumlu |
| K8 | Migration `DEFAULT 1`; geçiş **`OPTIMISTIC_LOCKING_ENFORCED` flag'i** ile 3 fazlı (T-028c deseni). **Flag'in açılması T-034'ün DoD'sidir**, "sonra bakarız" değil | Backfill'e gerek yok; eski client'lar bir release boyunca çalışmaya devam eder |
| K9 | Append-only tablolar (ledger, budget_transactions, audit, approval_history) **kapsam DIŞI** — version kolonu eklenmesi yasak | Mutasyon yolları yok; kolon eklemek "güncellenebilir" sinyali verir, audit-immutability ilkesine aykırı |

---

## 1. Mevcut durum — doğrulanmış tarama

### 1.1 Version kolonu
`grep -rn "VersionColumn" src` → **0 sonuç.** Hiçbir entity'de optimistic locking yok.
`BaseEntity` (`src/database/entities/base.entity.ts`) yalnızca `id/tenantId/createdAt/updatedAt/deletedAt/createdBy/updatedBy` içeriyor.

### 1.2 Mevcut eşzamanlılık korumaları (yalnız 3 nokta, hepsi pessimistic)
- `src/modules/modes/actuals-first/settlement/settlement-close.service.ts:115` — `lock: { mode: 'pessimistic_write' }`
- `src/modules/modes/actuals-first/sales-actuals/sales-actuals.repository.ts:38`
- `src/modules/shared/budget/budget.repository.ts:127` — `findEnvelopeWithLock`, `setLock('pessimistic_write')`

### 1.3 🔴 Yanıltıcı yorumlar (bu task'ta DÜZELTİLECEK)
`settlement-close.service.ts`:
- `:84` — `4. status = CLOSED, closedAt, closedBy güncelle (optimistic lock: version bump)`
- `:112` — `1. Agreement'ı tenant-scoped FOR UPDATE ile çek (optimistic lock için version)`

Var olmayan bir mekanizmayı anlatıyorlar. Gerçek koruma `pessimistic_write` + status guard (`ALREADY_SETTLED`/`NOT_SETTLEABLE_STATE`, `:124`/`:134`). Bu yorumlar **T-034 kapsamında** doğru metne çevrilmeli (aşağıda §7.4 önerilen metin).

### 1.4 🔴 En kritik bulgu — `.update()` tuzağı fiilen doğrulandı

Plan tarafındaki **hiçbir** mutasyon `save()` kullanmıyor:

| Dosya:satır | Metod | Yazım şekli |
|---|---|---|
| `plan.repository.ts:113` | `update()` | `this.planRepo.update({id, tenantId}, data)` |
| `plan.repository.ts:127` | `updateStatus()` | `update()`'e delege |
| `plan.repository.ts:196` | `updatePlanFu()` | `this.planFuRepo.update({id: planFuId}, data)` |
| `plan.repository.ts:238` | `updatePlanSku()` | `this.planSkuRepo.update({id: planSkuId}, data)` |
| `plan.repository.ts:207/249` | `removeFu()/removeSku()` | `.delete({id})` |
| `agreement.repository.ts:119` | `update()` | `this.repo.update({id, tenantId}, data)` |
| `settlement-close.service.ts:141` | close | `queryRunner.manager.update(Agreement, {...})` |

`save()` yalnızca **create** yollarında var: `plan.repository.ts:28` (`create`), `:180` (`addFu`), `:221` (`addSku`), `agreement.repository.ts:24`, `plan.service.ts:177` (history — append-only).

**Sonuç:** `@VersionColumn` eklenirse hiçbir mutasyon yolunda ne kontrol edilir ne artırılır. Bu, T-033 oturumunda 6 kez görülen "mekanizma var görünüyor, fiilen çalışmıyor" hata sınıfının aynısıdır. **Bu yüzden K1.**

### 1.5 🔴 Yan bulgu — multi-tenant izolasyon açığı (T-034'e katlanmalı)

`plan.repository.ts` içindeki şu metodlarda **`tenantId` predicate'i YOK**:

```
findPlanFu(planId, fuId)        →  where: { planId, fuId }
updatePlanFu(planFuId, data)    →  update({ id: planFuId }, data)
removeFu(planFuId)              →  delete({ id: planFuId })
findPlanSku(planFuId, skuId)    →  where: { planFuId, skuId }
updatePlanSku(planSkuId, data)  →  update({ id: planSkuId }, data)
removeSku(planSkuId)            →  delete({ id: planSkuId })
```

Bugün bunlar yalnızca "çağıran taraf id'yi tenant-scoped `findById`'den aldı" varsayımıyla güvenli. Bu varsayım kod sözleşmesi değil, tesadüf. Version-CAS çalışması **zaten tam olarak bu 6 metodun `where` cümlesini yeniden yazıyor** → `tenantId` predicate'i aynı anda eklenmeli. Ayrı task açmaya değmez, ama T-034 acceptance criteria'sına satır olarak girmeli.

### 1.6 Mutasyon yolları envanteri (Plan)

| # | Yol | Dosya:satır | Sınıf | Version davranışı (öneri) |
|---|---|---|---|---|
| 1 | `update()` (plan header) | `plan.service.ts:331` | kullanıcı niyeti | **plan.version CAS** |
| 2 | `addFu()` | `:369` | yapısal | **plan.version CAS** |
| 3 | `updateFuTactic()` | `:426` | grid hücresi | **planFu.version CAS** |
| 4 | `updateSkuVolume()` | `:455` | grid hücresi | **planSku.version CAS** |
| 5 | `removeFu()` | `:499` | yapısal | **plan.version CAS** (+ planFu.version) |
| 6 | `submit()` | `:520` | state + para | **status-CAS + FOR UPDATE**, ek olarak plan.version doğrulaması |
| 7 | `approve()` | `:724` | state + para | **status-CAS + FOR UPDATE** (version yok) |
| 8 | `reject()` | `:883` | state + para | **status-CAS + FOR UPDATE** (version yok) |
| 9 | `returnToDraft()` | `:1004` | state | **status-CAS + FOR UPDATE** (version yok) |
| 10 | `delete()` | `:1100` | yıkıcı | **plan.version CAS** |
| 11 | `recalculatePlanWithKpiEngine()` yazımları | `:1283`, `:1345`, `:1390` | türetilmiş | **kontrol YOK, bump YOK** (`updateUnversioned`) |
| 12 | Kompanzasyon yazımları | `:594`, `:644`, `:869`, `:953`, `:1082` | sunucu rollback'i | **kontrol YOK, bump YOK** (`updateUnversioned`) |
| 13 | `approval-workflow.service.ts` state yazımları | `:176`, `:222`, `:272`, `:461`, `:508`, `:552`, `:612` | state + para | **status-CAS + FOR UPDATE** (6–9 ile aynı kural) |

**#12 çok önemli bir tuzak:** kompanzasyon yazımları (`submit` başarısızlığında DRAFT'a dönüş vb.) CAS ile yazılırsa **her seferinde başarısız olur** — ileri yazım version'ı zaten artırmıştır, elde tutulan `plan` nesnesi bayattır. Bu yüzden version-bypass eden yazım yolu **açıkça ayrı bir metod** olmalı (`updateUnversioned`), sessiz bir istisna değil. Böylece "bypass" grep'lenebilir ve review'da görünür olur.

---

## 2. Karar K1 — Neden `@VersionColumn` değil, manuel CAS

### Alternatifler

**A) `@VersionColumn` + tüm mutasyonları `save()`'e çevir**
- ✔ TypeORM idiomatic, `OptimisticLockVersionMismatchError` hazır.
- ✘ `PlanRepository.update/updatePlanFu/updatePlanSku` + `AgreementRepository.update` + `settlement-close`'un `queryRunner.manager.update` çağrılarının hepsi `save()`'e dönmeli.
- ✘ `save()` **tüm entity'yi** yazar. Mevcut kod bilinçli olarak **kısmi** yazım yapıyor ve `undefined` atlanır / explicit `null` yazılır semantiğine dayanıyor (`plan.service.ts:1045-1048`, `:1285-1289`, T-027 kararı). `save()`'e geçiş bu semantiği kırar ve T-027'de kapatılan "stale değer kalıyor" hata sınıfını geri açar.
- ✘ `save()` cascade'leri tetikler (`Plan.planFus` `{cascade:true}`, `PlanFu.planSkus` `{cascade:true}`) → `findById` tüm ağacı relation'larla çekiyor; bir plan header update'i tüm FU/SKU ağacını yeniden yazabilir. Grid-heavy üründe performans felaketi (<500ms hedefi).
- ✘ Riski en yüksek seçenek: 13 mutasyon yolunun her birinde davranış regresyonu.

**B) Manuel `version` kolonu + koşullu UPDATE (SEÇİLEN)**
```sql
UPDATE main.plan_skus
   SET planned_volume = $1, base_volume = $2, incremental_volume = $3,
       version = version + 1, updated_by = $4, updated_at = now()
 WHERE id = $5 AND tenant_id = $6 AND version = $7
```
- ✔ Mevcut `.update()` mimarisini bozmaz; kısmi yazım semantiği aynen korunur.
- ✔ Tek atomik SQL cümlesi → yarış her zaman DB'de çözülür, uygulama sırasından bağımsız olarak **tam bir kazanan** olur.
- ✔ `affected === 0` net, test edilebilir bir sinyal.
- ✔ `queryRunner.manager` ile transaction içinde de aynı şekilde çalışır (settlement/agreement yolları).
- ✘ Elle yazılıyor → unutulabilir. **Karşı önlem:** tek bir yardımcı (`applyVersionedUpdate`) + §6'daki mimari test.

**C) Sadece `updatedAt` timestamp karşılaştırması**
- ✘ Postgres `timestamp` çözünürlüğü ve saat kayması ile aynı milisaniyede iki yazım ayırt edilemez; recalc'ın `updatedAt`'i sürekli değiştirmesi false-positive üretir. Elenmiştir.

**D) Her şeye pessimistic lock**
- ✘ Grid'de kullanıcı düşünme süresi boyunca satır kilitli kalır; desktop-first, çok kullanıcılı üründe kabul edilemez. BRD zaten "optimistic locking" diyor.

### Uygulama iskeleti (öneri, kod değil)

`src/modules/shared/persistence/versioned-update.helper.ts` (yeni):

```ts
// Tek yazım noktası. affected === 0 → 404 mü 409 mu ayır, ConflictException fırlat.
export async function applyVersionedUpdate<T>(
  repo: Repository<T> | EntityManager,
  target: EntityTarget<T>,
  where: { id: string; tenantId: string },   // tenantId ZORUNLU (bkz. §1.5)
  expectedVersion: number,
  data: QueryDeepPartialEntity<T>,
): Promise<T>  // güncel entity'yi döner (409 gövdesi için de kullanılır)
```

- `affected === 1` → başarılı, güncel satırı `RETURNING`/ikinci okuma ile döndür.
- `affected === 0` → `where`'i version'sız tekrar sorgula:
  - satır yok → `NotFoundException`
  - satır var → `ConflictException({ code: 'STALE_VERSION', ... })` (§4)
- `version = version + 1` SET listesine **helper tarafından** eklenir, çağıran taraf yazmaz.

`PlanRepository` ve `AgreementRepository` bu helper'ı kullanır; ayrıca **bilinçli bypass** için ikinci bir metod:

```ts
// Türetilmiş/kompanzasyon yazımları: version kontrol ETMEZ, version BUMP ETMEZ.
updateUnversioned(id, tenantId, data)   // grep'lenebilir, review'da görünür
```

---

## 3. Karar K2/K3/K4 — Granülarite (asıl karar)

### İkilem
- **Yalnız plan seviyesi version:** iki planner farklı FU'ları düzenlese bile ikincisi 409 alır. Grid-heavy üründe kabul edilemez yanlış-pozitif; kullanıcılar 409'u "sistem bozuk" diye öğrenir ve gerçek çakışma uyarısını da ciddiye almaz.
- **Yalnız satır seviyesi version:** gerçek çakışma yakalanır, ama "plan toplam spend/KPI'ı tutarlı mı" sorusu yanıtsız kalır.

### Karar: karma model — ama ikinci sorun locking ile çözülmez

Ayrım şu: **kullanıcı niyeti taşıyan alanlar** ile **türetilmiş projeksiyon alanları**.

| Alan sınıfı | Örnek | Kim yazar | Version |
|---|---|---|---|
| Kullanıcı girdisi | `plan_skus.planned_volume/base_volume`, `plan_fus.tactics`, `plans.plan_name/start_date/...` | kullanıcı | **CAS ile korunur, bump eder** |
| Türetilmiş | `plan_skus.tactic_spend/planned_gp/gp_roi/rag_status/calculated_kpis`, `plan_fus.total_*`, `plans.total_*`/`overall_roi`/`rag_status` | recalc | **CAS yok, bump yok** |
| State | `plans.status`, `agreements.status` + onay alanları | state machine | **status-CAS** (§5) |

Bu ayrım karma modeli güvenli kılan şeydir: türetilmiş yazımlar version bump etmediği için, bir kullanıcının SKU düzenlemesi diğer kullanıcının açık grid'ini bayatlatmaz — yalnızca **aynı satırı** düzenleyen bayatlar. Yanlış-pozitif 409 sıfıra iner.

### Plan-geneli tutarlılık (K3)

`recalculatePlanWithKpiEngine` **idempotenttir**: kalıcı satırların saf bir fonksiyonudur (girdi = `plan_skus.planned_volume`, `plan_fus.tactics`, master data; çıktı = türetilmiş alanlar). Dolayısıyla eşzamanlı iki grid düzenlemesinde tek risk **interleaving**:

```
T1: updateSkuVolume(A)  →  recalc başlar
T2: updateSkuVolume(B)  →  recalc başlar
T2'nin recalc'ı önce biter, T1'inki sonra biter ama B'yi okumadan önce başlamıştı
→ plans.total_spend, B'nin etkisini kaybeder (kalıcı yanlış toplam)
```

Bu bir **lost update değil, lost recalculation**'dır ve version ile çözülemez (B'nin yazımı A'nın satırına dokunmuyor). Çözüm: recalc'ı **plan başına serialize etmek**.

**Öneri:** `recalculatePlanWithKpiEngine` bir `QueryRunner` transaction'ı içine alınır ve ilk iş olarak:

```sql
SELECT pg_advisory_xact_lock(hashtextextended($planId::text, 0));
```

- Transaction-scoped → commit/rollback'te otomatik bırakılır, sızma yok.
- Plan bazında; farklı planların recalc'ları paralel çalışmaya devam eder.
- Kullanıcıya 409 göstermez (kısa süreli bekleme, kilit değil çakışma değil).
- Grid'in `<500ms` bütçesi: recalc zaten seri; advisory lock yalnızca **aynı plan** üzerindeki eşzamanlı recalc'ları kuyruklar.

⚠️ Bu, T-034'ün en riskli parçası: `recalculatePlanWithKpiEngine` bugün transaction dışında, çok sayıda ayrı yazımla çalışıyor (`:1283`, `:1345`, `:1390`) ve `spendCalc`/`kpiEngine` çağrıları içeriyor. **Öneri: bu parça T-034b olarak ayrılsın** (§8). T-034 version-CAS'ı bunu beklemeden teslim edebilir; version-CAS zaten kendi başına lost-update'i kapatır, T-034b lost-recalculation'ı kapatır.

### `addFu`/`removeFu` neden plan seviyesi?
FU eklemek/silmek **plan'ın yapısını** değiştirir; iki planner aynı anda aynı FU'yu eklerse bugün `ConflictException('FU already added')` (`plan.service.ts:398`) devreye giriyor ama bu bir TOCTOU kontrolü (unique index `['planId','fuId']` gerçek koruma). Yapısal değişikliğin plan.version'ı bump etmesi, "başkası FU ekledi/sildi, grid'in artık farklı" bilgisini client'a taşır. `removeFu` ek olarak silinen `planFu.version`'ını da CAS ile doğrulamalı (client sildiği FU'nun bayat halini görüyor olabilir).

---

## 4. Karar K5 — State geçişleri: optimistic mi pessimistic mi?

### Sınır kuralı (net formülasyon)

> **Optimistic**, çakışma *insan-insan* ve *uzun düşünme süresi* içeriyorsa (grid hücresi, plan header düzenlemesi).
> **Pessimistic + status-CAS**, çakışma *tek kısa transaction içinde makine seviyesindeyse* ve *para hareketi* içeriyorsa (submit/approve/reject/close → budget RESERVE/COMMIT/RELEASE).

### Neden state geçişlerinde version yetmez

`approve()` iki kez paralel çağrılırsa version-CAS **yeterli olmaz**: ikinci çağrı 409 alır, ama budget COMMIT'i `commitReservedForPlan` (`plan.service.ts:798`) plan status yazımından **ÖNCE** çalışır. Yani version-CAS bariyerine gelmeden para hareket etmiş olur. Doğru bariyer, geçişin **kendi ön koşuludur**: `status = PENDING_APPROVAL`.

**Öneri:** her state geçişi tek `QueryRunner` transaction'ında,
1. `SELECT ... FOR UPDATE` ile plan/agreement satırını çek (settlement-close deseni, `settlement-close.service.ts:112-118`),
2. status ön koşulunu kontrol et → değilse 409 (`code:'INVALID_STATE_TRANSITION'` veya mevcut `NOT_REJECTED`/`ALREADY_SETTLED`),
3. yazımı `WHERE ... AND status = :expectedFromStatus` ile yap → `affected === 0` ikinci savunma hattı,
4. budget yan etkisi aynı transaction/saga içinde.

Bu, çift-submit / çift-approve / çift-close'a karşı version'dan **kesin olarak daha güçlü**: version bir yarışta ikinciyi reddeder, status-CAS ayrıca *yanlış state'ten gelen her çağrıyı* reddeder.

### Tek istisna: `submit()` version DE ister

`submit()` semantik olarak "bu içeriği onaya gönderiyorum" beyanıdır. Planner grid'i açıkken başkası bir SKU hacmini değiştirdiyse, planner **görmediği bir spend'i** onaya göndermiş olur — ve bu spend doğrudan `budgetService.reserveForPlan(id, plan.totalSpend, ...)` (`:581`) ile rezerve edilir. Bu yüzden `submit(id, version)` client version'ını da doğrular; uyuşmazsa 409 `STALE_VERSION` + "plan değişti, gözden geçir".

`approve()/reject()/returnToDraft()` version İSTEMEZ:
- `approve/reject` yalnız `PENDING_APPROVAL`'da çalışır ve BRD gereği **Pending'de plan immutable**'dır → eşzamanlı içerik değişikliği zaten imkânsız. Ek version kontrolü sadece yanlış-pozitif üretir.
- `returnToDraft` yalnız `REJECTED`'da çalışır (`:1014`), aynı argüman.

### Değişmeyecekler
`settlement-close.service.ts` **olduğu gibi doğrudur** (pessimistic + status guard). Yalnız §1.3'teki yanıltıcı yorumlar düzeltilecek. `budget.repository.ts:127` ve `sales-actuals.repository.ts:38` de değişmez.

---

## 5. Karar K6/K7 — API sözleşmesi

### Version nasıl taşınır: DTO alanı (If-Match/ETag DEĞİL)

**If-Match/ETag reddedildi çünkü:**
1. `PATCH /plans/:id/fus/:fuId/skus/:skuId/volume` (`plan.controller.ts:274`) alt-kaynak mutasyonu; ETag hangi kaynağın (plan mı, planSku mu)? Üç seviyede ayrı version var, tek header bunu ifade edemez.
2. Frontend TanStack Query + Redux ile normalize edilmiş entity'ler tutuyor; version'ı entity alanı olarak taşımak header hokkabazlığından çok daha basit ve tip-güvenli.
3. Swagger'da `@ApiProperty` ile dokümante olur; header sözleşmesi olmaz.
4. Proxy/CDN'lerin ETag'i yeniden yazması gibi operasyonel riskler yok.

### Request

```
PATCH /plans/:id                                       body: { ...UpdatePlanDto, version }
POST  /plans/:id/fus                                   body: { ...AddFuDto, planVersion }
PATCH /plans/:id/fus/:fuId/tactics                     body: { ...UpdateFuTacticDto, version }   // planFu.version
PATCH /plans/:id/fus/:fuId/skus/:skuId/volume          body: { ...UpdateSkuVolumeDto, version } // planSku.version
DELETE /plans/:id/fus/:fuId                            body: { planVersion, fuVersion }
POST  /plans/:id/submit                                body: { ...,  version }                   // plan.version
DELETE /plans/:id                                      body: { version }
```

Alan adı: aynı entity'nin version'ı ise sade `version`; farklı bir entity'ninki ise `planVersion`/`fuVersion` (belirsizlik bırakma). `UpdatePlanDto extends PartialType(CreatePlanDto)` olduğu için `version` **`CreatePlanDto`'ya değil, `UpdatePlanDto`'ya doğrudan** eklenmeli (yoksa create'e sızar).

### Response (okuma)
`version` her plan/planFu/planSku/agreement payload'ında döner. Bunun için ek iş gerekmez — entity'ye kolon eklenince serialize edilir; ama `plan.controller.ts` yanıt şekillendirmesi/`@ApiProperty` tanımları güncellenmeli.

### Çakışma yanıtı — 409 + güncel veri (K7)

`code:'STALE_VERSION'` tek başına **yetmez**. Grid-heavy üründe kullanıcı bir hücreyi düzenlemiş, 409 almış; ikinci bir GET atmadan hücreyi tazeleyebilmeli, ayrıca "senin girdiğin 1200, sunucudaki 1350" karşılaştırmasını gösterebilmeli. Öneri gövde:

```json
{
  "statusCode": 409,
  "code": "STALE_VERSION",
  "message": "This record was modified by another user. Review the current values and retry.",
  "entity": "PLAN_SKU",
  "entityId": "…",
  "expectedVersion": 7,
  "currentVersion": 9,
  "current": { "plannedVolume": 1350, "baseVolume": 1000, "updatedBy": "…", "updatedAt": "…" }
}
```

- `current` **yalnız kullanıcı-girdisi alanlarını** içerir; türetilmiş KPI/spend alanları buraya konmaz (client zaten recalc sonrası planı tazeleyecek, ayrıca payload şişer).
- `updatedBy`/`updatedAt` "kim değiştirdi" bilgisini verir — merge UX'i için kritik.
- ⚠️ `current` gövdesi **scope kontrolünden geçtikten sonra** üretilmeli: çağıran zaten `findById(actor)` ile 404/OUT_OF_SCOPE bariyerini geçmiş olmalı, aksi halde 409 gövdesi veri sızdırır.
- Mevcut yapısal-hata deseniyle tutarlı: `plan.service.ts:1015` (`NOT_REJECTED`), `:1029` (`OUT_OF_SCOPE`), `settlement-close.service.ts:124` (`ALREADY_SETTLED`).

**Otomatik merge YAPILMAZ.** Sunucu asla iki değeri birleştirmez; karar kullanıcıya aittir. TPM'de sessiz merge, onaya giden spend'i kimsenin görmediği bir sayıya çevirebilir.

---

## 6. Karar K8 — Migration ve geri uyum

### Migration

`src/database/migrations/1793000000000-AddOptimisticLockVersions.ts`

```sql
ALTER TABLE "main"."plans"      ADD COLUMN "version" integer NOT NULL DEFAULT 1;
ALTER TABLE "main"."plan_fus"   ADD COLUMN "version" integer NOT NULL DEFAULT 1;
ALTER TABLE "main"."plan_skus"  ADD COLUMN "version" integer NOT NULL DEFAULT 1;
ALTER TABLE "main"."agreements" ADD COLUMN "version" integer NOT NULL DEFAULT 1;
-- down(): DROP COLUMN "version" (dört tablo)
```

- `DEFAULT 1` sayesinde **backfill gerekmez**; mevcut satırlar 1 olur.
- Postgres 11+ non-volatile default ile `ADD COLUMN` tablo yeniden yazmaz → büyük `plan_skus` tablosunda kilit süresi kısa.
- Kolon `BaseEntity`'ye **konmamalı** — 40 entity'nin hepsine version eklemek yanlış sinyal verir (K9). Yalnız ilgili 4 entity'ye açıkça yazılır.

### Geri uyum — 3 fazlı geçiş (`OPTIMISTIC_LOCKING_ENFORCED`, T-028c deseni)

`AccessScopeService`'in `SCOPE_ENFORCEMENT_ENABLED` deseni (`access-scope.service.ts:118`, `ConfigService.get(...) === 'true'`) birebir kopyalanır.

| Faz | Flag | `version` yok gelirse | Ne zaman |
|---|---|---|---|
| **0** | `false` | kabul et, CAS'ı atla, `logger.warn` (`STALE_VERSION_UNCHECKED`, endpoint + userId ile) | Migration + backend release |
| **1** | `false` | aynı; frontend version göndermeye başlar; warn sayacı **sıfıra** düşmeli | Frontend release + 1 sprint gözlem |
| **2** | `true` | `version` eksik → **400 `MISSING_VERSION`**; mevcut → CAS zorunlu | **T-034 DoD** |

**Kritik not:** Faz 0/1'de koruma **yoktur**. `OPTIMISTIC_LOCKING_ENFORCED=true`'ya geçmek T-034'ün Definition of Done'ının parçasıdır; task, flag kapalıyken "done" işaretlenemez. Aksi halde §1.4'te tarif edilen hata sınıfının yeni bir örneğini üretmiş oluruz: kolon var, kod var, koruma yok.

`version` gönderildiğinde CAS **flag'den bağımsız** uygulanır (faz 0'da bile) — böylece frontend entegrasyonu gerçek davranışa karşı test edilir.

---

## 7. Karar K9 — Kapsam DIŞI (açık liste)

### 7.1 Append-only / immutable — version kolonu eklenmesi YASAK
Bu tablolarda `UPDATE` yolu yoktur; version kolonu "güncellenebilir" sinyali verir ve BRD'nin audit-immutability ilkesine aykırıdır.

- `ledger_entries` (`ledger-entry.entity.ts`)
- `budget_transactions`, `budget_transaction_log`
- `agreement_transactions`
- `plan_approval_history` (`plan.service.ts:177` — yalnız `save()` ile insert)
- `admin_audit_logs`
- `notifications`
- `on_invoice_entries`, `on_invoice_batches`, `sales_actuals`, `sales_actual_batches` (batch-scoped; `sales-actuals.repository.ts:38` zaten pessimistic)

### 7.2 Türetilmiş yazımlar — CAS yok, bump yok
`recalculatePlanWithKpiEngine` (`plan.service.ts:1283/1345/1390`) ve `agreement.service.ts:530` (`kpiResults` yazımı). Bunlar `updateUnversioned` kullanır. Gerekçe §3.

### 7.3 Kompanzasyon yazımları — CAS yok, bump yok
`plan.service.ts:594`, `:644`, `:869`, `:953`, `:1082` ve `approval-workflow.service.ts:222/272`. Sunucu-içi rollback'ler; CAS uygulanırsa **kesin başarısız olurlar** (§1.6 #12). `updateUnversioned` + yorumda gerekçe zorunlu.

### 7.4 Yorum düzeltmeleri (kod davranışı değişmez)
`settlement-close.service.ts:84` ve `:112` yorumları — önerilen metin:
- `:84` → `4. status = CLOSED, closedAt, closedBy güncelle (koruma: adım 1'deki FOR UPDATE + adım 2/3'teki status guard — optimistic version YOK, bkz. docs/analysis/0005)`
- `:112` → `1. Agreement'ı tenant-scoped FOR UPDATE (pessimistic_write) ile çek — bu yol bilinçli olarak pessimistic'tir (para hareketi + saga), version-CAS kullanmaz`

### 7.5 Şimdilik dışarıda, sonraki task
- **Master data** (`sku`, `forecasting_unit`, `tactic`, `mechanic`, `cpl`, `customer`, `channel`, `category`): düşük çekişme, tek-admin düzenlemesi. Ayrı task'a bırakılır.
- **KPI/formül konfigürasyonu** (`kpis`, `budget_alert_configuration`, `lta_rates`): ⚠️ **aslında hak ediyor** — iki Admin aynı KPI formülünü/RAG threshold'unu eşzamanlı düzenlerse sessiz kayıp, tüm tenant'ın hesaplamalarını etkiler ve BRD'nin "hesap dinamiktir" ilkesinin merkezinde. T-034'ün kapsamını şişirmemek için ayrılıyor → **T-039 önerisi** (§8).
- **`budget_envelopes`**: `budget.repository.ts:127` zaten pessimistic; bütçe hareketleri event-sourced. Değişiklik gerekmez.

---

## 8. Teslim planı (task kırılımı önerisi)

| Task | Kapsam | Bağımlılık |
|---|---|---|
| **T-034** (bu) | Migration (4 kolon) · `applyVersionedUpdate` helper · `PlanRepository`/`AgreementRepository` CAS + **`tenantId` predicate düzeltmesi (§1.5)** · DTO `version` alanları · 409 `STALE_VERSION` gövdesi · flag 3 fazı · yorum düzeltmeleri (§7.4) · testler (§9) | — |
| **T-034b** | State geçişlerini tek `QueryRunner` transaction + `FOR UPDATE` + status-CAS'a taşı (`submit/approve/reject/returnToDraft` + `approval-workflow.service.ts`) | T-034 |
| **T-034c** | `recalculatePlanWithKpiEngine`'i transaction + `pg_advisory_xact_lock` ile plan-başına serialize et (lost-recalculation) | T-034b (transaction altyapısı ortak) |
| **T-039** (yeni öneri) | KPI/formül konfigürasyonunda optimistic locking (§7.5) | T-034 |

T-034 tek başına **lost update**'i kapatır ve BRD ihlalini giderir; b/c ise **lost recalculation** ve **state/para atomikliğini** kapatır. Bunları tek task'ta yapmak §1.4'teki hata sınıfını davet edecek büyüklükte bir diff üretir.

---

## 9. Test stratejisi — deterministik kanıt

> Ders (T-037/T-038): "N yeşil koşum kanıt değildir." Aşağıdaki katmanların **her biri** ayrı bir hata sınıfını yakalar; hiçbiri tek başına yeterli değildir.

### Katman 1 — Unit: helper'ın kendisi (deterministik)
`versioned-update.helper.spec.ts`: `.update()` stub'ı `{affected: 0}` döndürsün.
- satır var → `ConflictException`, `code === 'STALE_VERSION'`, `currentVersion` dolu
- satır yok → `NotFoundException`
- `{affected: 1}` → güncel entity döner, `version` SET listesinde `version + 1` var

### Katman 2 — Unit: HER mutasyon yolu CAS'a bağlı mı (parametrik)
**En kritik katman** — "kolon eklendi ama bir yolda kontrol unutuldu" hatasını yakalar.
`plan.service.spec.ts` içinde, `[update, addFu, updateFuTactic, updateSkuVolume, removeFu, submit, delete]` üzerinde `it.each` ile: repository stub'ı `{affected: 0}` döndürsün → **her biri** 409 `STALE_VERSION` fırlatmalı.
Simetrik negatif test: `[recalculatePlanWithKpiEngine, <kompanzasyon yolları>]` → `updateUnversioned` çağrılmalı, `applyVersionedUpdate` **çağrılmamalı** (`expect(spy).not.toHaveBeenCalled()`).

### Katman 3 — e2e: bayat-version replay (BİRİNCİL, tam deterministik)
`test/optimistic-locking.e2e-spec.ts` — yarış yok, zamanlama yok, flake yok:
```
GET  /plans/:id                       → version = v
PATCH .../volume  { volume: 100, version: v }   → 200,  yeni version = v+1
PATCH .../volume  { volume: 200, version: v }   → 409,  code STALE_VERSION,
                                                   currentVersion = v+1, current.plannedVolume = 100
GET  /plans/:id                       → plannedVolume hâlâ 100 (kayıp yazım YOK)
```
Aynı senaryo `plans` (header), `plan_fus` (tactics), `agreements` (update) için tekrarlanır.
Ayrıca **çapraz-seviye yanlış-pozitif testi** (K2'nin kanıtı):
```
İki farklı FU'ya paralel iki tactic güncellemesi (her biri kendi doğru version'ı ile) → İKİSİ DE 200
Recalc sonrası aynı planSku'ya doğru version ile yazım       → 200 (recalc bump etmiyor)
```

### Katman 4 — e2e: gerçek yarış, **sıradan bağımsız invariant** ile
```ts
const results = await Promise.allSettled([reqA(sameVersion), reqB(sameVersion)]);
expect(results.map(statusOf).sort()).toEqual([200, 409]);
// HANGİSİNİN kazandığı ASLA assert edilmez
```
Bu **deterministiktir**, çünkü koruma tek atomik SQL cümlesidir: sıralama ne olursa olsun tam olarak biri kazanır. 10 iterasyon çalıştırılır; herhangi bir `[200,200]` (lost update) veya `[409,409]` (livelock) anında kırmızıya döner.

### Katman 5 — Mutasyon kanıtı (ZORUNLU, manuel, task raporuna yazılır)
Testlerin **gerçekten mekanizmayı** ölçtüğünü kanıtlamak için:
1. `applyVersionedUpdate`'ten `AND version = :expected` predicate'i geçici kaldır → **Katman 3 ve 4 kırmızıya dönmeli**. Dönmüyorsa testler mekanizmayı değil, başka bir şeyi ölçüyordur.
2. Bir mutasyon yolunu (`updateSkuVolume`) `updateUnversioned`'a çevir → **Katman 2 kırmızıya dönmeli**.
3. `OPTIMISTIC_LOCKING_ENFORCED=true` iken `version`'sız istek → **400 `MISSING_VERSION`**.

Bu üç adımın çıktısı task raporuna yapıştırılır. "Testler yeşil" tek başına kabul edilmez.

### Katman 6 — Multi-tenant regresyon (§1.5 düzeltmesinin kanıtı)
Tenant A'nın `planSkuId`'si + Tenant B'nin JWT'si ile `PATCH .../volume` → **404**, ve Tenant A'nın satırı **değişmemiş** olmalı. `test/helpers/seed-e2e.ts` iki-tenant kurulumu ile (T-037/T-038 izolasyon e2e deseni).

---

## 10. Riskler ve belirsizlikler

| # | Risk | Etki | Azaltma |
|---|---|---|---|
| R1 | **Faz 0/1'de koruma yok.** Flag açılmazsa T-034 "yapıldı" görünür, BRD ihlali sürer | Yüksek | Flag'in `true` olması DoD'a yazıldı (§6). Task, flag kapalıyken `done` işaretlenemez |
| R2 | `updateUnversioned` bir sonraki geliştirici tarafından kolaylık olsun diye kullanılır → koruma sessizce delinir | Yüksek | Metod adı bilinçli olarak rahatsız edici · JSDoc'ta "yalnız türetilmiş/kompanzasyon" · code-reviewer checklist maddesi · Katman 2 negatif testi |
| R3 | `recalculatePlanWithKpiEngine`'i transaction'a almak (T-034c) `spendCalc`/`kpiEngine` çağrılarını uzun bir transaction içine sokar → connection pool baskısı, `<500ms` hedefi | Orta-Yüksek | T-034c'ye ayrıldı; orada ölçüm zorunlu. Alternatif: advisory lock'u ayrı kısa transaction'da al + `recalc_seq` karşılaştırması ile out-of-order sonucu at |
| R4 | `pg_advisory_xact_lock(hashtextextended(...))` hash çakışması → alakasız iki plan birbirini bekler | Düşük | 64-bit `hashtextextended`; ayrıca namespace'li iki-int form (`pg_advisory_xact_lock(classId, objId)`) değerlendirilebilir. Performans etkisi var, doğruluk etkisi yok |
| R5 | Frontend üç seviyede (plan/FU/SKU) version taşımalı; TanStack Query cache'inde recalc sonrası türetilmiş alanlar değişip version değişmeyince cache tazeleme mantığı kafa karıştırıcı olabilir | Orta | frontend-engineer ile sözleşme netleştirilmeli: grid düzenlemesi sonrası zaten tam plan refetch ediliyor (totaller değişiyor) → version'lar da o refetch ile tazelenir |
| R6 | `UpdatePlanDto extends PartialType(CreatePlanDto)` — `version`'ın `CreatePlanDto`'ya sızması | Düşük | `version` doğrudan `UpdatePlanDto` gövdesine eklenir; `create-plan.dto.spec` benzeri bir test `CreatePlanDto`'da `version` olmadığını doğrular |
| R7 | 409 gövdesindeki `current` alanı scope/tenant sızıntısı yaratabilir | Orta | `current` yalnız `findById(actor)` bariyerini geçmiş isteklerde üretilir; türetilmiş/finansal alan içermez (§5) |
| R8 | `plan_skus` büyük tablo; `ADD COLUMN NOT NULL DEFAULT 1` üretimde kilit | Düşük | PG 11+ non-volatile default → tablo yeniden yazılmaz. Yine de migration penceresi planlanmalı |
| R9 | `agreements` tarafında `agreement.service.ts:262` (create içi retry update) ve `:476` (update) yollarının hangisinin kullanıcı-niyeti hangisinin türetilmiş olduğu tam ayrıştırılmadı | Orta | T-034 implementasyonu başlamadan `agreement.service.ts:406-540` satır satır sınıflandırılmalı (backend-engineer'ın ilk adımı) |
| R10 | `approval-workflow.service.ts` ile `plan.service.ts` **aynı geçişler için iki ayrı kanonik yol** içeriyor (`submit` vs `submitForApproval`, `approve` vs `reviewPlan`). Biri korunup diğeri unutulursa koruma delinir | Yüksek | §1.6 #13 listesi acceptance criteria'ya birebir girmeli; Katman 2 testi **her iki servisi** de kapsamalı |

---

## 11. Acceptance criteria (T-034 için önerilen güncelleme)

- [ ] `1793000000000-AddOptimisticLockVersions.ts` — `plans`/`plan_fus`/`plan_skus`/`agreements` + `version int NOT NULL DEFAULT 1`, çalışan `down()`
- [ ] `applyVersionedUpdate` helper + `updateUnversioned` ayrımı; `version = version + 1` yalnız helper içinde
- [ ] `PlanRepository` 6 metodunda **`tenantId` predicate'i** eklendi (§1.5)
- [ ] §1.6 tablosundaki 13 yolun **her biri** için "burada nasıl zorlanıyor" kodda yorumlandı; #11/#12 açıkça `updateUnversioned`
- [ ] DTO'larda `version`/`planVersion`/`fuVersion` + Swagger
- [ ] 409 gövdesi §5 şemasına uygun; `current` scope bariyeri sonrası üretiliyor
- [ ] `OPTIMISTIC_LOCKING_ENFORCED` flag'i (T-028c deseni) ve **`true` konumda** teslim
- [ ] `settlement-close.service.ts:84/:112` yanıltıcı yorumları düzeltildi
- [ ] Test katmanları 1–4 ve 6 yeşil; **katman 5 (mutasyon kanıtı) çıktısı task raporunda**
- [ ] T-034b, T-034c, T-039 backlog'a açıldı
