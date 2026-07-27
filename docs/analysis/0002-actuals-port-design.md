# 0002 — Actuals (Satış Gerçekleşen) Modülü Port Tasarımı — T-020

- **Tarih:** 2026-06-24 · **Kaynak:** T-020 architect
- **Karar:** KOŞULLU ONAY (4 bağlayıcı koşul)

## Bağlayıcı koşullar
1. Kapsam yalnızca **ingestion + saklama + okuma**. TTM'in `generateActualsClaims`, `checkCapPolicy`, `LedgerEventDispatcher`, `cancelClaimsAndReleaseConsume` **port EDİLMEZ**.
2. TTM hard-delete (`actuals.service.ts:769-777` `DELETE ... status='REPLACED'`) **port EDİLMEZ** — BRD immutable audit ihlali.
3. Actuals **KPI engine'i BESLEMEZ** (§4).
4. `sales-actuals.module.spec.ts` (modül sınır testi) + ledger-sızıntı e2e (SA-E2E-06) **zorunlu teslimat**.

## Kritik bulgu — granülarite yeniden tanımı
Wella CSV başlığı: `cpl_code,category,channel_code,gross_amount,net_amount,discount_amount` → **`fu_code` YOK, `volume` YOK**. TTM `validateRow` (989, 1046-1053) bunları zorunlu tutuyor; yani TTM validator'ı bu veriyi tümden reddederdi.
**CTPM'de actuals = CPL × Kategori × Kanal × Dönem TUTAR agregası. FU/SKU ve hacim boyutu YOKTUR.**

## TTM semantiği (port edilen)
- İki tablo: batch (scope kabı) + satırlar.
- **Scope = (period, cpl, category, channel)** — tek dosya N scope'a bölünür, scope başına 1 batch.
- Batch status `ACTIVE`/`REPLACED`; "güncel gerçek" = ACTIVE batch satırları.
- Replacement: ACTIVE'i `FOR UPDATE` kilitle → `REPLACED` yap → yeni ACTIVE INSERT → satırlar 500'lük chunk.
- Satır bazlı kısmi kabul (hatalı satır `errors[]`, kalanlar yüklenir).
- Actuals kendi başına **ledger'a yazmaz**.

## Düzeltilen TTM kusurları (port'ta taşınmaz)
- Hard delete → audit ihlali.
- **Scope-başına transaction** (763) → kısmi commit. CTPM'de **dosya-atomik TEK transaction**.
- `resolveTenantId(jwt.sub)` round-trip → CTPM'de `@TenantId()` decorator var.
- CSV `channel_code` sessizce yok sayılıyor (1003-1005) → CTPM'de uyuşmazsa satır reddi.
- `console.log` debug blokları.

## 1. Yerleşim + bağımlılık
`src/modules/modes/actuals-first/sales-actuals/` (isim `actuals` değil — parent zaten `actuals-first`, "actual" kelimesi `agreement-transaction` için de kullanılıyor).
Yapı `on-invoice/` ile birebir: module/controller/service/repository + `services/` + `dto/`.

**İzinli import:** `TypeOrmModule.forFeature([SalesActual, SalesActualBatch])`, `MasterDataModule` (Cpl/Category/Channel lookup), `CommonModule` (AdminAuditService, CsvParserService).
**YASAK import:** `LedgerModule`, `BudgetModule`, `KpiEngineModule`, `SpendCalculationModule`, `ApprovalModule`, `PlanModule`, `AgreementModule`, `SettlementModule`.
**Bu task'ta `SalesActualsModule`'ü kimse import etmez.** `app.module.ts`'e düz kayıt.

Kural testle kilitlenir (`sales-actuals.module.spec.ts`): `Reflect.getMetadata('imports', SalesActualsModule)` içinde Ledger/Budget/KpiEngine/SpendCalculation **olmamalı**.

## 2. Veri modeli

### `SalesActualBatch` → `main.sales_actual_batches` (BaseEntity extend)
| Alan | Tip |
|---|---|
| `fiscalPeriod` | `varchar(7)` `YYYY-MM` (on-invoice-batch ile aynı isim) |
| `cplId`, `categoryId`, `channelId` | `uuid` (normalize ID — TTM text tutuyordu) |
| `status` | enum `ACTIVE|REPLACED` |
| `sourceType` | enum `FILE_UPLOAD|SEED` |
| `fileName` | `varchar(255)` |
| `fileHash` | `char(64)` sha256 — **idempotency anahtarı** |
| `totalRows`/`validRows`/`errorRows` | `int` |
| `grossTotal`/`netTotal`/`discountTotal` | `decimal(18,2)` |
| `replacedByBatchId` | `uuid null` — **versiyon zinciri** |
| `replacedAt` | `timestamptz null` |
| `validationSummary` | `jsonb null` `{errors:[{rowNumber,code,field,message}]}` |

```sql
-- Scope başına tek ACTIVE — DB garantisi (TTM'de YOK)
CREATE UNIQUE INDEX ux_sales_actual_batches_active_scope
  ON main.sales_actual_batches (tenant_id, fiscal_period, cpl_id, category_id, channel_id)
  WHERE status='ACTIVE' AND deleted_at IS NULL;
CREATE INDEX ix_sab_tenant_period ON main.sales_actual_batches (tenant_id, fiscal_period);
CREATE INDEX ix_sab_tenant_status ON main.sales_actual_batches (tenant_id, status);
```

### `SalesActual` → `main.sales_actuals`
`batchId`; denormalize boyutlar `fiscalPeriod/cplId/categoryId/channelId`; display `cplCode/categoryName/channelCode`; `grossAmount decimal(18,2)` zorunlu; `netAmount`/`discountAmount` nullable; `currency char(3)` default TRY; `sourceRowNumber int`; `rawRow jsonb` (**ham satır burada** — ayrı staging tablosu YOK).

```sql
CREATE INDEX ix_sa_tenant_batch ON main.sales_actuals (tenant_id, batch_id);
CREATE INDEX ix_sa_tenant_dims  ON main.sales_actuals (tenant_id, fiscal_period, cpl_id, category_id, channel_id);
```
**Satır seviyesinde unique constraint YOK** — aynı scope'ta çok satır meşru; tekillik ACTIVE batch ile.

### Migration `1785000000000-CreateSalesActualsTables.ts`
2 enum + 2 tablo + partial unique index + FK (cpl/category/channel/batch); `down()` drop.
🚫 **`v_budget_summary` view DDL'ine DOKUNMAZ** (dosya başına yorum olarak yaz).
⚠️ TypeORM `decimal`→string: repository sınırında **numeric transformer** kullan (on-invoice entity'lerinde eksik, tekrarlama).

## 3. KPI/baseline — **NET KARAR: BESLEMEZ**
Gerekçe: (1) `BASE_VOL` bir **hacim**, CSV'de `volume` yok; tutardan hacim türetmek birim-fiyat varsayımı → BRD "varsayım yapma" ihlali. (2) Granülarite uyuşmazlığı (BASE_VOL SKU/FU, actuals kategori) → allocation kuralı BRD'de tanımsız. (3) `.cursor/rules.md`'de "actuals"/"baseline" **hiç geçmiyor**. (4) Bağımlılık hijyeni + KPI <500ms bütçesi.
→ `SalesActualsModule` `KpiEngineModule` import etmez, hiçbir KPI context'ine yazmaz. Baseline türetme ayrı task (T-024, ön koşul: BRD onayı + volume kolonu + dağıtım kuralı).

## 4. Ledger/spend sınırı — 5 katman
- **G1 Şema:** tablolarda `budget_envelope_id`/`ledger_entry_id`/`agreement_id` **yok** → `v_budget_summary` görmez, çift sayım fiziksel olarak imkânsız.
- **G2 Modül:** yasak import + module spec bekçisi.
- **G3 Terminoloji:** `grossAmount/netAmount/discountAmount`, entity `SalesActual`. `spend`/`consumed`/jenerik `amount` **kullanma** (T-003/T-017 çift-sayımlarının kökü isim karışıklığıydı).
- **G4 `discountAmount` tuzağı:** satış iskontosu, on-invoice indirimiyle **ekonomik olarak örtüşebilir**; on-invoice zaten ledger'a yazıyor. `SalesActual.discountAmount` **asla** bütçeye/ledger'a/spend'e yazılmaz — salt bilgi. Bu cümle entity JSDoc'una aynen konur.
- **G5 e2e SA-E2E-06:** upload öncesi/sonrası `v_budget_summary` consumed/reserved/available **birebir aynı**.

## 5. Ingestion
Tek kod yolu: `SalesActualsService.ingest(tenantId, userCtx, {fiscalPeriod, fileName, fileBuffer, sourceType})` — controller ve seed aynı metodu çağırır.

```
POST /actuals-first/sales-actuals/upload?fiscalPeriod=YYYY-MM  (multipart, FileInterceptor)
GET  /actuals-first/sales-actuals/batches?fiscalPeriod=&status=
GET  /actuals-first/sales-actuals/batches/:batchId/rows
GET  /actuals-first/sales-actuals/summary?fiscalPeriod=&cplId=&categoryId=&channelId=
```
`fiscalPeriod` opsiyonel: yoksa dosya adından `^actuals_(\d{4})-(\d{2})\.csv$`; ikisi de yoksa 400.

**Parser:** Mevcut ikisi reuse edilemez — `customer/services/file-parser.service.ts` `parseCSV` doğrudan `mapToCustomerDtos`'a bağlı ve `CustomerModule`'den **export edilmiyor**; `on-invoice-file-parser` aynı guard mantığının kopyası, DTO'ya bağlı.
→ **Yeni** `src/common/services/csv-parser.service.ts`: DTO-agnostik, ham `Record<string,string>[]`, boyut/satır guard'ları tek yerde, `CommonModule`'den export. Mevcut iki parser'ı buna delege etmek **ayrı task (T-021)** — bu turda regresyon riski alınmaz. XLSX yok, MIME whitelist `text/csv`.

**Master-data çözümleme (bulk, N+1 yok — 3 sorgu):**
| Boyut | Anahtar | Not |
|---|---|---|
| CPL | `code` → `{id, channelId}` | `BS0501.50006` ↔ cpl.seed ✅ |
| Channel | `code` → `id` | `NKA` ↔ channel.seed ✅ |
| Category | **`name`** → `id` | CSV `Şekillendirici`, tabloda `code='CAT-SEKILLENDIRICI'`; `name` unique DEĞİL |

Kategori eşleşmesi (en kırılgan): `trim()` + `toLocaleLowerCase('tr-TR')` — **locale-aware zorunlu** (İ/ı tuzağı). Aynı normalize isimden 2+ → `AMBIGUOUS_CATEGORY` (sessiz seçim YOK). Dayanıklılık: CSV'de opsiyonel `category_code` kolonu kabul edilir, varsa **öncelikli**.
**Kanal çapraz doğrulama:** satır `channel_code` ≠ CPL'in kanalı → `CHANNEL_MISMATCH` (TTM yok sayıyor).

## 6. Replacement — hard delete YOK
1. Scope ACTIVE batch `SELECT ... FOR UPDATE` (TTM 781-793 doğru, korunur).
2. `fileHash` **aynıysa** → NO-OP `{replaced:false, reason:'IDEMPOTENT_DUPLICATE'}`, yeni batch yok.
3. Farklıysa: eski `status='REPLACED'`, `replacedByBatchId`, `replacedAt`. **Satırlar SİLİNMEZ.**
4. Yeni batch ACTIVE INSERT; satırlar 500'lük chunk.
5. `AdminAuditService.logAdminAction(...,'SALES_ACTUALS_REPLACE','SalesActualBatch',newBatchId,..., before={oldBatchId,totals}, after={newBatchId,totals})` — **aynı transaction manager'ı** (reversal.service kalıbı).
6. Eş zamanlılık: partial unique → `23505` → `409 Conflict`.

**Idempotency anahtarı:** `(tenantId, fiscalPeriod, cplId, categoryId, channelId, fileHash)`.
**Okuma:** tüm sorgular `batch.status='ACTIVE'` filtreler — filtre **tek yerde**: `SalesActualsRepository.activeScopeQuery()` (TTM'de her sorguya elle yazılmış, sızıntı riski).

## 7. Akış + edge case
Akış: guards → `@TenantId()` → dosya doğrulama (csv, ≤10MB, ≤10000 satır) → fiscalPeriod (query ?? dosya adı) → `fileHash=sha256` → parse → bulk master-data (3 sorgu) → satır validate + scope grupla → geçerli satır yoksa 400 (batch yaratma) → **TEK transaction** (tüm dosya atomik): scope'lar için replacement adımları → audit → commit; hata → tam rollback.

| Durum | Davranış | Kod |
|---|---|---|
| Bilinmeyen cpl_code | satır reddi | `UNKNOWN_CPL` |
| Bilinmeyen kategori | satır reddi | `UNKNOWN_CATEGORY` |
| Normalize isim çakışması | satır reddi | `AMBIGUOUS_CATEGORY` |
| channel_code ≠ CPL kanalı | satır reddi | `CHANNEL_MISMATCH` |
| gross boş/NaN/negatif | satır reddi | `INVALID_GROSS_AMOUNT` |
| net > gross | **satır reddi** (TTM kontrol etmiyor) | `NET_EXCEEDS_GROSS` |
| net+discount ≠ gross | **yalnızca warning**, satır kabul (BRD'de tanımsız → varsayım yok) | `AMOUNT_RECONCILIATION` |
| Aynı scope'tan 2 satır | ikisi kabul, aynı batch | — |
| Aynı dosya tekrar | idempotent no-op | — |
| Tüm satırlar hatalı | 400, batch yok | — |
| Eş zamanlı upload | biri 409 | — |

## 8. RBAC / tenant / audit
- **Upload/replace:** `ADMIN`, `FINANCE`, `FINANCE_MANAGER`. PLANNER **yazamaz** (satış finansal kayıt; Planner plan üretir), CATEGORY_MANAGER yazamaz.
- **Okuma:** + PLANNER, CATEGORY_MANAGER, READONLY.
- **Silme:** endpoint YOK (immutable).
- Tenant: her sorguda `tenantId`; tenantId'siz repository sorgusu yasak.
- Audit: `SALES_ACTUALS_UPLOAD` + `SALES_ACTUALS_REPLACE` ayrı actionType.

## 9. recognition-exceptions — KAPSAM DIŞI
TTM'de tek yazıcısı `generateActualsClaims` (474-489); claim generation olmadan **anlamsız boş tablo**. CTPM'de claim-generation eşleniği yok. → Ayrı task (T-022), actuals↔agreement eşleştirme modeli kararından sonra.

## 10. Görev kırılımı (sıralı)
S1 entity'ler → S2 migration → S3 `common/services/csv-parser.service.ts` → S4 DTO'lar → S5 lookup+validation servisleri → S6 repository (`activeScopeQuery`, chunked insert, agrega) → S7 service `ingest()` (tek transaction, replacement, idempotency, audit) → S8 controller+guards+Swagger → S9 seed + Wella CSV fixture repoya + wire → S10 unit test (validation/replacement/idempotency + **module boundary spec**) → S11 e2e → S12 `app.module.ts` kaydı.
Bağımlılık: S1→S2→S6→S7; S3/S4/S5 paralel; S9 S7'den sonra.

## 11. E2E (`test/sales-actuals.e2e-spec.ts`)
| ID | Senaryo | Beklenen |
|---|---|---|
| SA-E2E-01 | Wella `actuals_2026-01.csv` upload | 2 satır, 2 batch (2 scope), 200 |
| SA-E2E-02 | Aynı dosya 2. kez | idempotent no-op, ACTIVE batch id değişmez |
| SA-E2E-03 | Aynı dönem farklı içerik | eski REPLACED + `replacedByBatchId`; **eski satırlar DB'de duruyor**; okuma yeni batch |
| SA-E2E-04 | Bilinmeyen cpl/kategori karışık | geçerliler yüklenir, hatalar doğru kodla |
| SA-E2E-05 | Tümü hatalı | 400, batch yok |
| **SA-E2E-06** | **Ledger sınırı** | `v_budget_summary` consumed/reserved/available **birebir aynı** |
| SA-E2E-07 | RBAC | PLANNER upload 403 / read 200; READONLY upload 403; FINANCE upload 200 |
| SA-E2E-08 | Tenant izolasyonu | A'nın batch'i B'de yok; B'nin id'siyle read 404 |
| SA-E2E-09 | Audit | UPLOAD + REPLACE kaydı var; DELETE endpoint yok |
| SA-E2E-10 | Dönem çıkarımı | query'siz `actuals_2026-02.csv` → `2026-02` |
| SA-E2E-11 | CHANNEL_MISMATCH | satır reddi |
| SA-E2E-12 | Perf smoke | 5000 satır < 5s, tek transaction |

## 12. Riskler
R1 ledger çift sayım (Yüksek→Düşük: G1-G5) · R2 audit ihlali (Yüksek→Sıfır: §6) · R3 granülarite (Orta: bu turda bağlanmıyor) · R4 Türkçe isim eşleşme (Orta: tr-TR + category_code) · R5 perf/lock (Düşük: MAX_ROWS+chunk) · R6 decimal→string (Düşük: transformer) · R7 kapsam şişmesi (Orta: ayrı task'lar).

## 13. Kapsam dışı → ayrı task
T-021 CSV parser konsolidasyonu · T-022 recognition-exceptions + actuals↔agreement eşleştirme · T-023 finance-reporting plan-vs-actual varyans · T-024 baseline türetme (BRD onayı + volume + dağıtım kuralı şart) · T-025 frontend actuals upload ekranı.
