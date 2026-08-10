# 0055 — TTM ölçümü: claim/settlement/recognition + `ADR 0001`'in geriye dönük sınanması

- **Tarih:** 2026-08-10
- **Task:** [[T-143]]'ün son açık bitiş ölçütü. **Mod: SALT-OKUNUR** — TTM'e yazılmadı.
- **Ölçüm ortamı:** TTM `86f10a4` (*"Show LTA validity range on agreement detail"*) ·
  CTPM meta `10c2287`
- **Önceki iş:** `docs/verification/CTPM_BASELINE_AND_PORT_AUDIT.md` CTPM tarafını ölçmüştü;
  bu belge **TTM tarafını** ölçer ve ikisini karşılaştırır.

---

## 0. ⚠️ İki ölçüm hatası — ölçümün kendisinde, ve düzeltildi

Rapora girmeden önce, bu turda **iki kez** yanlış sayıldı. İkisi de `CLAUDE.md §2.6/§7.1`
sınıfı ve ikisi de yakalandı:

| # | yapılan | ne üretti | düzeltme |
|---|---|---|---|
| 1 | `grep -c ... \| wc -l` | **beş terim için de `501`** — çünkü `grep -c` çok dosyada **her dosya için** bir satır basar; `wc -l` **dosya sayısını** saydı | `-c` yerine `-o \| wc -l` |
| 2 | `grep -ow 'settlement'` | 16 — **`settlements` modülünü kaçırdı** (kelime sınırı çoğulu dışlar) | gövde ile ara |

> **Beş farklı terimin aynı sayıyı vermesi tek uyarıydı.** İkinci hata daha sinsi: sayı
> makul göründü (16) ve modülün kendisi sayının dışındaydı.

Doğru sayılar (gövde, `apps/` + `prisma/`, `node_modules` hariç):

```
claim 3418 eşleşme / 122 dosya   ·   settlement 253/48   ·   recogni 91/14
reversal 101/13                  ·   accru 0/0
```

---

## 1. ⚠️ Önce yapı: TTM'de **iki** backend ağacı var

| ağaç | takipli dosya | son commit | durum |
|---|---|---|---|
| `apps/api/` | 180 | **2026-05-08** | **canlı** — ölçümlerin hepsi buradan |
| `backend/` | 92 | 2026-02-23 | uykuda; **TypeORM entity**'leri var (`modules/tenant`, `product`, `customer` — CTPM'in yapısına benziyor) |

⚠️ Ayrıca `.claude/worktrees/` altında **beş kopya** daha var. Bir arama bunları
dışlamazsa her sayı katlanır — bu belgedeki tüm ölçümler `apps/` ile sınırlandı.

> **`§2.1.1`'in dersi burada da geçerli:** *"TTM'de var/yok"* demek, **hangi ağaç**
> yazılmadan anlamsız.

---

# BÖLÜM 1 — Claim / Settlement / Recognition

## 1.1 Var, ve olgunlaşmış

| parça | konum |
|---|---|
| **Claim tablosu** | `agreement_claims` — `1760911200000-AgreementManualClaimsV03` |
| **Claim API** | `apps/api/src/agreements/agreement-claims.controller.ts` (109 satır) |
| **Üretim motoru** | `apps/api/src/actuals/actuals.service.ts` (**1.768 satır**) |
| **Settlement** | `apps/api/src/settlements/{controller,service,module}.ts` (266 satır) — okuma modeli (`SettlementSummaryResponseDto`) |
| **Recognition istisnaları** | `recognition_exceptions` tablosu + `actuals/recognition-exceptions.controller.ts` |
| **Ters kayıt** | `apps/api/src/reversals/` |

`agreement_claims` doğduğunda: `agreement_id` · `tactic_definition_id` ·
`amount numeric(14,2)` · `status` enum · `pop_url` · `description` · `created_by`.

**Sonra 12 migration ile evrildi** — bir tasarım değil, bir **kullanım geçmişi**:

```
AgreementClaimCancelledStatus · AgreementClaimsPeriodRevisionUniqueIndex
AllowQuarterPeriodCodeOnAgreementClaims · InvoiceSettlementMatchingFields
CleanupCancelledClaimConsume · RecognitionExceptions · AddClosedAtToAgreementClaims
AddFuIdToClaimRevisionIndex · CapClampClaimFields
LedgerConsumeReferenceUniqueness · LedgerReserveReferenceUniqueness
```

### Akış (kaynağın kendi tarifi)

> `docs/architecture/ACTUALS_RECOGNITION_MODEL.md`:
> **`actuals -> agreements -> tactics -> claim generation`**
> Recognition grain: **`period × CPL × category × channel`**

---

## 1.2 Çalışıyor muydu? — **evet, ölçüldü; ama son UAT koşusu GREEN değil**

### (a) Birim testleri **bugün koşuyor ve geçiyor**

```
npx jest agreement-claims.controller.spec.ts cap-policy.spec.ts ledger.invariants.spec.ts
EXIT=0 · Test Suites: 3 passed · Tests: 17 passed
```

(exit kodu boruya sokulmadan alındı — `§2.6`.)

`claim|settlement` geçen spec dosyası **10**: ledger invariants · ledger read-model ·
actuals replacement · actuals service · agreements service · agreement-claims controller ·
cap policy · approvals · plans · dashboard.

### (b) UAT: dört beklenen claim'in **dördü de birebir tuttu**

`docs/uat/UAT_EXECUTION_2026_06.md` — koşum tarihi **2026-05-08** (dosya adındaki `2026_06`
**mali dönem**, koşum tarihi değil).

| beklenen | tutar | statü | sonuç |
|---|---|---|---|
| `UAT-A-ON-001` `CPP_ON_PCT` ON | 11.000,00 | CLOSED | **PASS** |
| `UAT-B-OFF-001` `CIRO_PRIMI_OFF_PCT` OFF | 4.500,00 | DRAFT | **PASS** |
| `UAT-C-MIX-001` `CPP_ON_PCT` ON | 7.200,00 | CLOSED | **PASS** |
| `UAT-C-MIX-001` `CIRO_PRIMI_OFF_PCT` OFF | 3.600,00 | DRAFT | **PASS** |

Ledger: `RESERVE` 3 / 300.000 **değişmemiş**, `CONSUME` 2 / 18.200 (= 11.000 + 7.200,
`reference_type = AGREEMENT_CLAIM`), **duplicate CONSUME grubu 0**.

### (c) Ama koşumun statüsü: `BLOCKED_AT_CLAIM_GENERATION_FINANCIAL_VALIDATION`

Sebep **beşinci** bir claim: seed anlaşması `A08` (LTA), dönem etiketi `2026-01` ama
tarih aralığı `2026-06-30`'a uzanıyor → Haziran actual'ıyla eşleşti.

`docs/audits/LTA_EXECUTION_SEMANTICS_AUDIT.md` (2026-05-08) bunu inceleyip şu hükmü
veriyor: *"**EXPECTED runtime behavior; UAT fixture/configuration issue**"* — motor
`agreement_type`'a göre filtrelemiyor ve dokümanlar LTA'nın claim üretmesini destekliyor.

> **Okuma:** hesaplama ve durum geçişleri **kanıtlandı**; tıkanma bir **kapsam/semantik**
> sorusunda — *"bir anlaşmanın uygulanabilirliği dönem etiketinden mi, tarih aralığından
> mı gelir?"*
>
> ⚠️ Ve o audit **bir iddiadır, kanıt değil** (`§2.1.2`): takip edilmeyen bir dosya, tek
> yazar, ve verdiği hüküm *"mevcut uygulamaya göre"* koşullu. **Ölçülen** şey dört PASS
> satırı ve ledger tablosudur; *"fixture sorunu"* o audit'in yorumudur.

---

## 1.3 Kaynağı ne? — **TTM'in BRD'si değil**

| belge | ne |
|---|---|
| `docs/architecture/ACTUALS_RECOGNITION_MODEL.md` | *"architecture guidance only. **It does not change current application behavior.**"* — mevcut grain'i kaydeder, Phase-A kararını yazar |
| `obsidian-vault/TPM/10_HISTORY/DECISION_HISTORY/on_invoice_recognition.md` · `recognition_scope.md` | **karar geçmişi** |
| `docs/clients/wella/WELLA_SYSTEM_FLOW_v1.md` | **müşteriye özel** akış |
| `prompts/completed/A1-001_recognition-exceptions.md` | geliştirme prompt'u |

> **Yani model bir BRD'den değil, üç kaynaktan doğmuş:** bir mimari not, bir karar
> geçmişi, ve bir Wella akış belgesi. `ACTUALS_RECOGNITION_MODEL.md` **davranışı tarif
> ediyor, ondan önce gelmiyor** — kendi cümlesiyle *"does not change current behavior"*.

⚠️ **`RECOGNITION_SPEC` adında bir dosya iki repoda da yok.** CTPM'de terim yalnız
`docs/analysis/` içinde geçiyor. TTM'deki karşılığı **`ACTUALS_RECOGNITION_MODEL.md`**'dir;
[[T-143]]'ün bitiş ölçütündeki ad bu belgeye **eşlenmelidir**.

---

## 1.4 `K1-K45` örtüşmesi — TTM tarafı

CTPM tarafı `CTPM_BASELINE_AND_PORT_AUDIT.md`'de ölçülmüştü. TTM tarafı **bu turda**:

| K | TTM'de | ölçüm |
|---|---|---|
| **K43-R** clamp | ✅ **üretim yolunda** | `actuals.service.ts:592` ve `:1412` — **iki ayrı yol**; `cap_clamped` + `original_computed_amount` yazılıyor (`1777240000000-CapClampClaimFields`) |
| **K23** grain | ✅ `period × CPL × category × channel` | `ACTUALS_RECOGNITION_MODEL.md` — FU tabanlı eşleşme **bilinçli olarak ertelenmiş** (*"Phase-A stays category-based"*) |
| **K22** on-invoice claim | ✅ claim nesnesi var | CTPM'de claim **yok**; `on_invoice_entries` `POSTED` oluyor (audit'te `DIFFERENT`) |
| **K28** taktik başına tek claim | ✅ | `AgreementClaimsPeriodRevisionUniqueIndex` + `AddFuIdToClaimRevisionIndex` |
| **K25 / K26** | ölçülmedi | bu turun kapsamı dışında — audit CTPM tarafında `ABSENT` diyor |

> **K43-R clamp'in sessiz olmadığına dikkat:** `cap_clamped` bayrağı ve
> `original_computed_amount` **yazılıyor**, ve bir log satırı basılıyor. Yani `§2.5`
> anlamında *sessiz düzeltme* değil — **kayıtlı** bir politika.

---

# BÖLÜM 2 — `ADR 0001` geriye dönük sınanıyor

## 2.1 ⛔ CTPM'de eksik bulunan Phase 1 maddeleri **TTM'de de yok**

51 migration tarandı (`apps/api/src/database/migrations`):

```
scope_policies · tactic_policies · budget_policies · approval_policies
approval_steps · approval_history · permissions · role_permissions
user_roles · capabilities · tenant_features        → HEPSİ 0 dosya

ROW LEVEL SECURITY | CREATE POLICY                  → 0
```

TTM'in yarattığı 36 tablo: `agreement_claims · agreement_periods · agreement_tactics ·
agreements · approval_requests · attachments · audit_events · audit_logs ·
baseline_imports · budget_envelopes · categories · cpl_customers · cpls · customers ·
fu_skus · fus · invoices · kpi_definitions · ledger_entries · off_invoice_invoice_lines ·
off_invoice_invoices · on_invoice_run_matches · on_invoice_runs · plan_fus · plan_skus ·
plans · recognition_exceptions · sales_actuals · sales_facts · sales_upload_batches ·
skus · tactic_definitions · tactic_values · tenants · user_cpl_assignments · users`

> ### Konfigürasyon katmanı **iki üründe de yok.**
> [[T-156]]'nın altı tablosu bir CTPM eksikliği değil — **estate genelinde** hiç
> yazılmamış bir katman.

📌 Ve kapsam modelinde **CTPM daha zengin**: TTM `user_cpl_assignments` (yalnız CPL),
CTPM `user_scopes` (cpl + category + channel).

📌 TTM'in taktik politikası **tabloya değil, `CHECK` kısıtına** gömülü:
`CHK_tactic_definitions_claim_trigger` · `_spending_type` · `_pop_requires_manual`.
Yani politika **var ama konfigüre edilemez** — CTPM'in hardcode eşikleriyle aynı sınıf.

## 2.2 Audit sözlüğü: **hiçbiri 20'ye yakın değil**, ve şekilleri zıt

| | tür sayısı | değerler |
|---|---|---|
| **TTM** | **5** | `AGREEMENT_CAP_INCREASED` · `AGREEMENT_CLAIM_CONSUMED` · `AGREEMENT_CLAIM_CONSUME_REVERSED` · `AGREEMENT_REJECTED` · `AGREEMENT_WITHDRAWN` |
| **CTPM** | **4** | `APPROVE` · `SALES_ACTUALS_UPLOAD` · `SUBMIT` · `UPDATE` |

> TTM'inkiler **alan olayı** (claim tüketildi/ters alındı), CTPM'inkiler **jenerik CRUD**.
> Şekil farkı ilginç ama sonuç aynı: `§7.4`'ün 20 olayı **iki üründe de yok** ([[T-168]]).

TTM'in `audit_events` şeması: `actor_user_id · action **text** · entity_type · entity_id ·
payload_json`. Enum yok — sözlük **kodda**, şemada değil.

## 2.3 ⛔ `GP_ROI_PCT` paydası — **TTM BRD ile aynı; CTPM yalnız kalıyor**

```
apps/api/src/database/seed.ts:1145
  formulaText: '(INCR_GP / TOTAL_PLANNED_SPEND) * 100'
apps/api/src/plans/plans.kpis.spec.ts:212, :487   ← aynı formül, teste pinlenmiş
```

| tanık | payda |
|---|---|
| BRD `§5.1` · `§5.3` · Addendum `H1` · `04_Reviews` | `TOTAL_PLANNED_SPEND` |
| `GrandTotals.tsx:64` yorumu (CTPM frontend) | Total Spend |
| **TTM seed + iki spec** | **`TOTAL_PLANNED_SPEND`** |
| **CTPM `migration 1780`** (*"DOĞRU (BRD)"*) | **`INCR_SPEND`** |

> ### Altıncı tanık, ve ikincisi kendi estate'imizde.
> Dondurulmuş, UAT'ye gitmiş ürün **BRD'nin formülünü** kullanıyor ve onu bir **teste
> pinlemiş**. Sapma tek bir yerde: CTPM'in `1780` migration'ı.

→ [[T-163]] güncellendi.

## 2.4 `ADR 0001` sınamasının sonucu

| gerekçe | bugünkü ölçüm |
|---|---|
| *"Mimari üstünlük: katmanlı/DDD, dual-mode, izole kpi-engine, tam tenant modülü"* | **Ayakta.** TTM `apps/api` **entity'siz**, ham SQL (`queryRunner.query`) üzerine kurulu; kapsam modeli daha dar |
| *"Stratejik niyet: jenerik/çok kiracılı ana ürün"* | **Ayakta.** Wella bağlantısı TTM'de belge ve seed düzeyinde yoğun (`docs/clients/wella/`) |
| *"TTM'de **kanıtlanmış** finansal akışlar"* | ⚠️ **Nitelendirilmeli** — aşağıda |

### ⚠️ DUR ve bildir (1): *"kanıtlanmış"* kelimesi fazla geniş

ADR 0001, TTM'i saklama gerekçesi olarak *"`reversals`/`settlements` gibi **kanıtlanmış**
finansal akışlar"* diyor. Ölçüm bunu **kısmen** destekliyor:

- ✅ Dört beklenen claim'in **dördü** tutarıyla ve statüsüyle tuttu; ledger doğru; birim
  testleri bugün geçiyor.
- ⚠️ Ama **son kayıtlı UAT koşusu GREEN değil** — `BLOCKED_AT_CLAIM_GENERATION_...`, ve
  tıkanan nokta bir **domain semantiği** sorusu (LTA dönem etiketi ↔ tarih aralığı) —
  **bugün de cevaplanmamış** (audit *"Product explicitly changes canonical LTA semantics"*
  demedikçe dokunmayın diyor).

> **Yani port edilecek şey "kanıtlanmış bir akış" değil, "dört vakada kanıtlanmış bir akış
> + bir açık domain sorusu".** Fark port planlamasında önemlidir: o soru CTPM'e de taşınır.

### ⚠️ DUR ve bildir (2): dondurulmuş repo bir noktada **önde**

`GP_ROI_PCT` paydası. ADR 0001 *"TTM yeni iş almaz, yalnız port kaynağıdır"* diyor — ama
burada TTM bir **hata düzeltme kaynağı**: CTPM'in ana metriği yanlış paydayı kullanıyor ve
doğrusu dondurulmuş üründe **teste pinlenmiş** duruyor.

> Bu ADR 0001'i çürütmüyor; **kapsamını genişletiyor**: TTM yalnız *akış* kaynağı değil,
> **doğrulama** kaynağı da.

---

# BÖLÜM 3 — Port maliyeti

## 3.1 En büyük maliyet kalemi: **veri erişim modeli**

| | TTM `apps/api` | CTPM `collmind.backend` |
|---|---|---|
| ORM | TypeORM **yüklü**, ama `@Entity` **0** | entity + repository |
| erişim | `queryRunner.query('SELECT ...')` ham SQL | repository + servis |
| para | `numeric(14,2)`, JS `number` | **`MoneyMinor`** (`common/numeric/money.ts`) + `DecimalTransformer` |
| koruma | — | `money-float` guard + **ratchet** · `INV-L-*` · tek türetim |

> **Port bir kopyalama değil, bir yeniden yazımdır.** `CLAUDE.md`'nin *"davranış taşınır,
> onu doğru kılan bağlam taşınmaz"* kuralı burada en sert hâliyle geçerli: TTM'in claim
> aritmetiği **ham SQL içinde** yaşıyor ve CTPM'in para sözleşmesinden (`MoneyMinor`)
> tamamen habersiz.

⚠️ Ve `money-float` ratchet'i bunu **zorlar**: `actuals.service.ts`'in float aritmetiği
CTPM'e olduğu gibi girerse Alan A bulgu sayısı artar ve kapı kırmızıya döner.

## 3.2 Kabaca büyüklük

| parça | satır |
|---|---|
| `actuals.service.ts` (eşleşme + claim üretimi + clamp) | **1.768** |
| `settlements.service.ts` | 266 |
| `agreement-claims.controller.ts` | 109 |
| `recognition-exceptions.controller.ts` | 22 |
| **toplam ölçülen yüzey** | **~2.165** |
| ilgili migration | **12** |

⚠️ **Bu bir alt sınırdır.** `agreements.service.ts`'in manuel claim tarafı, `reversals/`,
`cap/`, ve `ledger/` dokunuşları **sayıma dahil edilmedi** — port kapsamı belirlenirken
**taranmalı** (`CLAUDE.md`: *"bir enumerasyona dayanan her karar, enumerasyon ölçülene
kadar bir tahmindir"*).

## 3.3 Hangi karar kimin

| karar | tür | gerekçe |
|---|---|---|
| **K43-R** CAP aşımında **clamp** | ⚠️ **ürün kararı** — Wella'nın değil | Üç ayrı davranış estate'te mevcut: TTM eski **skip**, K43-R **clamp**, CTPM **reject**. Üçü de "doğru" olabilir; ama **biri seçilmeli** |
| **K23** grain (`category` vs `FU`) | **ürün kararı**, bugün Wella fazına bağlanmış | `ACTUALS_RECOGNITION_MODEL.md` açıkça *"Phase-A stays category-based"* diyor — yani **geçici**, ve CTPM'e taşınırken yeniden sorulmalı |
| **K44** last-upload-wins | **çözülmüş** | CTPM zaten **daha güçlü** (`ACTIVE`/`REPLACED` + kısmi unique index). Port etmeye gerek yok |
| **LTA dönem ↔ tarih aralığı** | ⚠️ **açık domain sorusu** | UAT'yi tıkayan madde; TTM'de de karara bağlanmamış |

---

## 4. [[T-143]] için sonuç

Son bitiş ölçütü **karşılandı**: TTM ölçüldü, `ADR 0001` geriye dönük sınandı.

**Açılan/güncellenen:** [[T-163]] (altıncı tanık) · [[T-176]] (LTA semantiği + CAP
davranışı — port öncesi karar) · [[T-168]] ve [[T-156]] TTM ölçümüyle genişledi.

**Karar ürün sahibinin:** claim/settlement portu **şimdi mi**, yoksa [[T-169]] (Phase 1
tabanı) kararından **sonra mı**? İkisi bağımlı: claim'in tükettiği bütçe modeli
`approval_policies`/`budget_policies` katmanının üstünde duruyor ve o katman **iki üründe
de yok**.
