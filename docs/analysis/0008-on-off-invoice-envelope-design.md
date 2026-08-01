# 0008 — On-Invoice / Off-Invoice Ayrı Bütçe Zarfı: Tasarım Kararı

- Task: [[T-019]] · Epic: E-001 · Tarih: 2026-08-01 · Yazan: architect
- Kapsam: **yalnızca tasarım**. Bu turda üretim kodu yazılmadı/değiştirilmedi.
- İlgili: [[T-012]] (config-driven threshold), [[T-017]] (spend split), [[T-029]] (plan RESERVE/COMMIT),
  [[T-030]] (agreement release sızıntısı), [[T-033]] (Rejected→Draft, net-tabanlı idempotency),
  [[T-034b]] (transaction + FE geri uyum dersi), [[T-047]] (fixture sızıntısı dersi)
- Önceki kanıt dosyaları: `docs/analysis/0003-agreement-reservation-lifecycle.md`,
  `docs/analysis/0005-optimistic-locking-design.md`

---

## §1 BRD kanıtı (birebir alıntı)

`.cursor/rules.md`, bölüm **8️⃣ BUDGET KURALLARI (FINANCE OWNERSHIP)**:

```
Bütçeler:

Period (Month / Quarter / Year)

Channel

Category (opsiyonel)

Ayrı ayrı:

On-Invoice

Off-Invoice

Threshold'lar

%80 → Warning

%95 → Critical

%100+ → Exceeded (block)
```

Aynı dosya, bölüm 7 (Submission/Approval):

```
Bütçe yeterli
...
Approve → bütçe anında düşülür
```

**Okuma (bağlayıcı yorum):** BRD "On-Invoice / Off-Invoice"u Period/Channel/Category ile aynı
listede, aynı yapısal seviyede sayıyor ve başına **"Ayrı ayrı"** koyuyor. Yani bu bir raporlama
kırılımı değil, **bütçenin bir boyutu**dur: her (Period × Channel × Category?) kombinasyonu için
on-invoice ve off-invoice **ayrı zarflardır**, ayrı allocation'ları ve ayrı threshold değerlendirmesi
vardır. Threshold cümlesi bu listenin hemen altında ve ayrımına dair istisna içermiyor →
**eşikler her tip için ayrı ayrı** değerlendirilir (§5.6).

**BRD'nin SUSTUĞU noktalar** (uydurulmayacak, §8'de ürün sahibine soruluyor):
mevcut tek-havuz bir zarfın on/off arasında hangi oranda bölüneceği; `spendType = BOTH` olan bir
agreement'ın cap'inin hangi orana göre iki zarfa dağıtılacağı.

---

## §2 Mevcut durum (doğrulanmış)

### §2.1 Şema

`main.budget_envelopes` (`src/database/entities/budget-envelope.entity.ts`):
`code, name, fiscal_year, period, channel, category, channel_id, category_id,
allocated_amount, consumed_amount, available_amount, currency, status, metadata, …`
→ **on/off ayrımı YOK.**

`main.budget_transactions`: `envelope_id, tx_type (ALLOCATE|RESERVE|COMMIT|RELEASE),
tx_status, source_type (PLAN|AGREEMENT|MANUAL), source_id, amount, idempotency_key (tenant+key unique)`
→ **on/off ayrımı YOK.**

`main.v_budget_summary` (migration `1789000000000-FixBudgetSummaryCommitDoubleCounting.ts`):
```
reserved_amount  = Σ(RESERVE + COMMIT) − Σ(RELEASE)   -- envelope_id başına, POSTED
consumed_amount  = Σ(ledger DEBIT − CREDIT)           -- envelope_id başına
available_amount = allocated − reserved − consumed
```
→ tüm encumbrance matematiğinin **grain'i `envelope_id`**.

`main.budget_allocations` (`budget-allocation.entity.ts`): on/off farkındalığı **zaten var**
(`on_invoice_budget/off_invoice_budget/…_utilized/…_reserved/…_available` generated columns).
**Ama canlı veri 0 satır** ve bu tablo event-sourced ledger'a bağlı değil; mutable sayaç modeli.
Paralel/ölü ikinci bütçe modeli. (Karar için bkz. §3, Seçenek D.)

### §2.2 Canlı veri (dev DB `collmind_tpm`, şema `main`, 2026-08-01)

```
budget_envelopes (4):
 ENV-2026-NKA-Q1  2026-01  metadata.channel=NKA                allocated 500.000  ACTIVE
 ENV-2026-NKA-Q2  2026-02  metadata.channel=NKA                allocated 600.000  ACTIVE
 ENV-2026-TRAD-Q1 2026-01  metadata.channel=TRADITIONAL_TRADE  allocated 300.000  ACTIVE
 ENV-2026-ECOM-Q1 2026-02  metadata.channel=E_COMMERCE         allocated 200.000  ACTIVE
   (channel/category KOLONLARI NULL — eşleşme metadata->>'channel' fallback'iyle yapılıyor)

budget_transactions (2):
 ALLOCATE 500.000  MANUAL     → ENV-2026-NKA-Q1
 RESERVE   75.000  AGREEMENT  → ENV-2026-NKA-Q1   (STA-2026-0002)
   key: RESERVE|AGREEMENT|<agreementId>|<envelopeId>

v_budget_summary: NKA-Q1 reserved 75.000, available 425.000. Diğer 3 zarf 0/tam.

agreements (3): STA-2026-0001 DRAFT OFF_INVOICE · STA-2026-0002 APPROVED OFF_INVOICE
                LTA-2026-0001 DRAFT OFF_INVOICE
plans: 0 satır · budget_allocations: 0 satır · budget_reservations: 0 satır
```

**Kritik gözlem:** tek gerçek rezervasyon (75.000) **off-invoice** bir agreement'a ait
(`agreements.spend_type = 'OFF_INVOICE'`) ama tipsiz bir zarfta duruyor. Yani "mevcut zarfları
ON olarak işaretle, OFF ikizini yeni yarat" gibi bir varsayılan göç, bugünkü tek parayı **yanlış
tipe** hapsederdi. Bu göç planının (§4) tasarımını belirleyen tekil olgu budur.

### §2.3 Servis semantiği

| Yer | Bugünkü davranış |
|---|---|
| `budget.service.ts:352 reserveForPlan(...)` | tek `amount`, spendType parametresi **yok**; zarfı `findEnvelopeByDimensions(channel, period)` ile bulur |
| `budget.service.ts:407-428` | net-tabanlı idempotency (`Σ RESERVE+COMMIT − Σ RELEASE`), **envelope başına** |
| `budget.service.ts:493 commitReservedForPlan` | `find(ilk POSTED COMMIT)` → varsa erken dön; yoksa `find(ilk POSTED RESERVE)` → onu CONVERT et. **Tek zarf varsayımı** |
| `budget-reservation.service.ts:166-178` | net'i **envelope başına** gruplar; `RELEASE\|<SRC>\|<id>\|<envId>` |
| `budget.service.ts:245 reserveForAgreement` | tek `amount`, spendType yok; key `RESERVE\|AGREEMENT\|<id>` (envelope'suz — T-019 kısıtı) |
| `plan.service.ts:816` (kanonik yol #1) | `reserveForPlan(plan.totalSpend)` — **split YOK** |
| `approval-workflow.service.ts:230-257` (kanonik yol #2) | `reserveBudgetForPlan(on, 'ON_INVOICE')` + `(off, 'OFF_INVOICE')` — **iki çağrı** |
| `approval-workflow.service.ts:1070-1090` | `reserveBudgetForPlan` private sarmalayıcı: `spendType` parametresini alıyor ama **kullanmadan atıyor** |
| `approval-workflow.service.ts checkBudgetAvailability` | kod içinde `// TODO: Implement separate On-Invoice and Off-Invoice budget envelopes`; tek `budgetStatus.available` hem on hem off için raporlanıyor; `overallSufficient = available >= on+off` |
| `budget-threshold.service.ts` | eşikler tenant-scoped config'ten (T-012), zarf başına `utilization_pct` üzerinden |

### §2.4 ⚠️ Bu analiz sırasında bulunan CANLI HATA (T-019 kapsamına giriyor)

`ApprovalWorkflowService#submitForApproval` off-invoice rezervasyonunu **hiç yazmıyor**:

1. 1. çağrı (`ON_INVOICE`, tutar A) → `reserveForPlan` yeni RESERVE(A) yazar.
2. 2. çağrı (`OFF_INVOICE`, tutar B) → aynı `manager` üzerinden `findTransactionsBySource`
   az önceki (commit edilmemiş ama aynı transaction'da görünen) RESERVE(A) satırını görür;
   `netOutstanding = A > 0` **ve** `envelopeReserves.length = 1` →
   `budget.service.ts:423-428` erken dönüş: **RESERVE(B) hiç yazılmaz**, çağırana A satırı döner.

Sonuç: `plans.off_invoice_spend` alanı doğru yazılır, **bütçe ise yalnızca on-invoice kadar düşer.**
Bugün gerçekleşmemesinin tek sebebi `plans` tablosunun boş olması ve UI'ın ağırlıklı olarak
`POST /plans/:id/submit` (kanonik yol #1, zaten split'siz) kullanması. Bu, oturumdaki 6 çift-sayım
hatasıyla **aynı sınıf** (ham satır varlığı ≠ net) ve T-019'un düzeltmesi gereken 7.'sidir.

---

## §3 Şema seçenekleri ve KARAR

### Seçenekler

| # | Model | Değerlendirme |
|---|---|---|
| **A** | `budget_envelopes`'a çift kolon (`on_invoice_allocated` / `off_invoice_allocated`) | Encumbrance grain'i `envelope_id` olmaktan çıkıp `(envelope_id, spend_type)`'a döner: `v_budget_summary`, `getReservedAmount`, `checkBudgetAvailability`, `findEnvelopeWithLock`, `ledger_entries.budget_envelope_id`, tüm idempotency key'leri ve `releaseNetReservation`'ın gruplaması **hep birden** iki-anahtarlı hale gelmek zorunda. Bu, 6 çift-sayım hatasının tam olarak yaşadığı yüzey. ❌ |
| **B** | `budget_envelopes.spend_type` ayrıştırıcı kolon → **her (boyutlar × tip) için ayrı satır** | Grain değişmez: `envelope_id` tek encumbrance anahtarı kalır; yalnızca **satır sayısı** artar. `v_budget_summary` değişmez. `releaseNetReservation` zaten "bir kaynak birden çok zarfa yayılabilir" varsayımıyla yazılmış (`budget-reservation.service.ts:164-178`) → çoklu-zarf zaten destekli. ✅ |
| **C** | Zarf aynı kalsın, ayrım sadece `budget_transactions.spend_type`'ta olsun | Encumbrance tiplenir ama **allocation tiplenmez** → "%100+ block" tip bazında hesaplanamaz (payda ortak kalır). BRD "ayrı ayrı"yı karşılamaz. ❌ tek başına |
| **D** | Mevcut `budget_allocations` tablosunu canlandır | Mutable sayaç modeli (`on_invoice_reserved += …`), ledger'a bağlı değil, idempotency yok, 0 satır, paralel ikinci doğruluk kaynağı. Event-sourced ledger'ın tam da kaçındığı hata sınıfını geri getirir. ❌ |

### KARAR — **B + C birlikte** (ayrıştırıcı hem allocation hem encumbrance tarafında)

1. **`main.budget_envelopes.spend_type`** — enum `('ON_INVOICE','OFF_INVOICE')`, **faz 1'de NULLABLE**
   (NULL = "UNSPLIT / legacy", §4), hedef durum NOT NULL.
   Zarf tarafında **`BOTH` diye bir değer YOKTUR** — bir zarf ya on ya off'tur. `BOTH` yalnızca
   *kaynak* (mechanic/tactic/agreement) tarafında bir sınıflandırmadır ve zarfa gelmeden önce
   çözülür (§5.7).
2. **`main.budget_transactions.spend_type`** — aynı enum, nullable (ALLOCATE ve T-019 öncesi
   satırlar için NULL). Gerekçe: (a) faz 1'de aynı UNSPLIT zarfa iki farklı tipte rezervasyon
   düşebilir, idempotency ve net hesabı bunları ayırt etmek zorunda; (b) BRD audit
   ("kim, ne zaman, neyi") için ledger'ın kendi kendini açıklaması gerekir — hangi paranın hangi
   zarfa gittiğini `envelope_id` üzerinden dolaylı çıkarmak, zarf ikizi taşındığında (faz 2)
   geçmişi bulanıklaştırır.
3. **`code` benzersizliği:** `(tenant_id, code)` unique index korunur; tipli zarfların code'u
   `<...>-ON` / `<...>-OFF` son ekiyle üretilir (`BudgetService#createEnvelope` auto-code kuralı).
4. **İndeks:** `idx_budget_envelopes_channel_period` ve `idx_budget_envelopes_channel_category_period`
   sonuna `spend_type` eklenir (§6 R5 — zarf arama submit başına 2× çalışacak, <500ms bütçesi).

**Neden BRD'nin "ayrı ayrı"sıyla en tutarlısı B:** BRD on/off'u Period/Channel/Category ile aynı
listede sayıyor. Diğer üç boyut zaten "aynı satırda kolon" değil, **satırı belirleyen boyut**;
on/off'u çift-kolona indirgemek onu tek başına farklı sınıf bir boyut yapardı. Ayrıca "ayrı ayrı
threshold" (%80/%95/%100 block) ancak **ayrı allocated payda** ile hesaplanabilir; ayrı satır bunu
bedelsiz verir (`utilization_pct` zaten satır başına).

---

## §4 Göç planı (adım adım + `down()`)

**Tasarımın en önemli özelliği: FAZ 1'de HİÇ PARA TAŞINMAZ.** Mevcut 75.000'lik rezervasyon ne
bölünür, ne kopyalanır, ne başka zarfa taşınır — dolayısıyla faz 1'de çift-sayım/kayıp riski
**yapısal olarak sıfırdır**. Para taşıma yalnızca faz 2'nin açık, transactional, net-korumalı
"split" operasyonunda olur.

### Faz 1 — yapısal (T-019 ile birlikte gider)

**Migration `1795000000000-AddSpendTypeToBudgetDimensions`**

`up()`:
1. `CREATE TYPE main.budget_spend_type_enum AS ENUM ('ON_INVOICE','OFF_INVOICE');`
2. `ALTER TABLE main.budget_envelopes ADD COLUMN spend_type main.budget_spend_type_enum NULL;`
   → mevcut 4 satır NULL kalır = **UNSPLIT (legacy)**. Allocated tutarlar **dokunulmaz**
   (bölme oranı Finance kararıdır — §8 Q1).
3. `ALTER TABLE main.budget_transactions ADD COLUMN spend_type main.budget_spend_type_enum NULL;`
4. **Sınıflandırma backfill'i (para hareketi DEĞİL):** kaynağı tek-tipli olan mevcut
   encumbrance satırlarına tip yazılır —
   ```sql
   UPDATE main.budget_transactions bt
      SET spend_type = a.spend_type::text::main.budget_spend_type_enum
     FROM main.agreements a
    WHERE bt.source_type = 'AGREEMENT' AND bt.source_id = a.id
      AND a.spend_type IN ('ON_INVOICE','OFF_INVOICE')
      AND bt.tx_type IN ('RESERVE','COMMIT','RELEASE')
      AND bt.spend_type IS NULL;
   ```
   Bu adım `amount`, `envelope_id`, `idempotency_key` alanlarına **dokunmaz** →
   `v_budget_summary.reserved_amount` her zarf için **birebir aynı kalır** (invaryant testi §7 T1).
   Bugünkü etkisi: 75.000'lik satır `OFF_INVOICE` olarak etiketlenir (agreement `OFF_INVOICE`).
   `ALLOCATE` satırları ve `source_type='PLAN'` satırları (bugün 0 adet) NULL kalır.
   > Not: bu bir `UPDATE`'tir ama **audit log'a değil**, ledger'ın sınıflandırma kolonuna yazar;
   > tutar/yön/kimlik değişmediği için "immutable audit" ilkesi ihlal edilmez. Yine de
   > `description`'a `T-019 classification backfill` eki YAZILMAZ — bunun yerine migration adı
   > `down()`'un ayırt edici filtresi olduğu için ayrı bir `metadata` gerekmez (aşağıya bak).
   > Ayırt edicilik için backfill edilen satır id'leri migration içinde
   > `main._t019_backfilled_tx (tx_id uuid primary key)` geçici tablosuna yazılır.
5. İndeksleri genişlet (yeni indeks ekle, eskiyi düşür):
   `CREATE INDEX idx_budget_envelopes_channel_period_spend ON main.budget_envelopes
    (tenant_id, channel, period, spend_type) WHERE deleted_at IS NULL;` (+ category'li varyant)

`down()`:
1. `UPDATE main.budget_transactions SET spend_type = NULL WHERE id IN (SELECT tx_id FROM main._t019_backfilled_tx);`
   → sadece bu migration'ın yazdığı sınıflandırma geri alınır (T-030'un
   `description LIKE 'T-030 backfill:%'` desenindeki ile aynı ilke: **kendi yazdığından fazlasını silme**).
2. **Guard:** eğer aynı `(tenant_id, channel, category, period)` grubunda `spend_type` dışında
   ayırt edilemeyen **birden fazla** zarf varsa (yani faz 2 çalışmışsa),
   `RAISE EXCEPTION 'T-019 down(): split envelopes exist; run 1796 down first'` ile **dur**.
   Kolonu düşürmek o durumda iki zarfı ayırt edilemez hale getirir ve
   `findEnvelopeByDimensions` rastgele birini seçer → sessiz mis-attribution.
3. Guard geçilirse: yeni indeksleri düşür, eski indeksleri geri yarat,
   `ALTER TABLE ... DROP COLUMN spend_type` (iki tablo), `DROP TYPE`, geçici tabloyu düşür.

**Faz 1 sonrası davranış:** 4 legacy zarf UNSPLIT kalır ve **hem on hem off** rezervasyon kabul
eder — yani bugünkü davranış korunur, hiçbir akış kırılmaz. Yenilik: encumbrance artık tiplidir,
`v_budget_summary` tip kırılımı sunabilir, ve **yeni** zarflar (API/seed/auto-create) tipli
yaratılmak zorundadır.

### Faz 2 — Finance kararı gerektiren "split" (ayrı task, T-019b önerilir)

**Migration DEĞİL, uygulama operasyonu**: `POST /budget/envelopes/:id/split`
(RBAC: yalnızca `FINANCE_MANAGER` + `ADMIN` — BRD "Finance Ownership").
Girdi: `{ onInvoiceAllocated, offInvoiceAllocated }`, toplamı mevcut `allocated_amount`'a **eşit
olmak zorunda** (aksi 400 — Finance bütçe artıramaz/eksiltemez, bu ayrı bir işlemdir).

Tek transaction içinde:
1. Zarfı `FOR UPDATE` kilitle; `spend_type IS NULL` değilse 409.
2. Orijinal satır **id'sini koruyarak** `spend_type='ON_INVOICE'`, `allocated_amount=onInvoiceAllocated`
   olur (id sabitliği kritik: `budget_transactions.envelope_id`, `ledger_entries.budget_envelope_id`,
   `budget_reservations.envelope_id` FK'leri bozulmaz).
3. `OFF_INVOICE` ikizi **yeni satır** olarak yaratılır (`code` + `-OFF`, `allocated_amount=offInvoiceAllocated`).
4. **Re-home (yalnız burada, append-only):** eski satırda `spend_type='OFF_INVOICE'` olarak
   etiketlenmiş her (source_id) grubu için net (`Σ RESERVE+COMMIT − Σ RELEASE`) hesaplanır;
   net > 0 ise ESKİ zarfa `RELEASE(net)` **ve** YENİ zarfa `RESERVE(net)` (COMMIT ise `COMMIT(net)`)
   yazılır. Hiçbir satır UPDATE/DELETE edilmez. Net toplam korunur:
   ```
   önce:  ON-zarf(id sabit) net = 75.000   OFF-zarf yok
   sonra: ON-zarf net = 75.000 − 75.000 = 0 ;  OFF-zarf net = 75.000   → toplam 75.000 (değişmedi)
   ```
   Idempotency key'leri: `RELEASE|<SRC>|<id>|<eskiEnv>|REHOME` ve `RESERVE|<SRC>|<id>|<yeniEnv>`.
   `REHOME` son eki, faz 2'nin RELEASE'inin normal terminal RELEASE key'iyle (`…|<envId>`)
   **çakışmamasını** garanti eder — aksi halde daha sonra gerçek bir CLOSE/CANCEL geldiğinde
   idempotency onu no-op'a çevirir ve **rezervasyon sonsuza dek asılı kalırdı** (T-030'un F1'inin
   birebir tekrarı).
5. `spend_type IS NULL` kalan (tipsiz) net > 0 varsa: split **reddedilir** (409,
   `UNTYPED_ENCUMBRANCE_PRESENT`) — tipsiz parayı hangi zarfa koyacağımıza dair kanıt yoktur.
   Operatörün önce o kaynakları kapatması/yeniden submit etmesi gerekir.

`down()` karşılığı (rollback): ikiz zarfın net'i ters yönde re-home edilir, ikiz `CLOSED`'a çekilir
(silinmez — ledger referansları var), orijinalin `allocated_amount`'ı ve `spend_type=NULL`
geri yazılır. Bu bir migration değil, `POST /budget/envelopes/:id/unsplit` operasyonudur.

### Seed / fixture (T-047 dersi — DİKKAT)

`budget-envelope.seed.ts` 4 → 8 zarfa çıkarılmalı (4 boyut × 2 tip, tutarlar dev fixture,
Finance kararı değil) **ve** `budget-transaction.seed.ts`'teki 75.000'lik RESERVE **OFF ikizine**
taşınmalı. ⚠️ Bu, key'i `RESERVE|AGREEMENT|<id>|<yeniEnvId>` yapar; **zaten seed'lenmiş bir DB'de**
eski key'li satır durduğu için seed tekrar çalıştığında **ikinci bir 75.000 rezervasyon** oluşur
(net 150.000) — bu oturumun 6 hatasıyla aynı sınıf. Kural: seed değişikliği **yalnız temiz DB**
(`db:reset` + `seed`) ile gider; migration'a seed onarımı KOYULMAZ (migration üretim verisine
dokunur, seed dev fixture'ıdır — karıştırılırsa T-047 tekrarlanır). CI'da §7 T1 invaryant testi
bu durumu yakalar.

---

## §5 Servis semantiği (imza + davranış değişiklikleri)

### §5.1 `BudgetRepository#findEnvelopeByDimensions`
```ts
findEnvelopeByDimensions(
  tenantId: string, channel: string, periodMonth: string,
  category?: string,
  spendType?: 'ON_INVOICE' | 'OFF_INVOICE',   // YENİ
): Promise<BudgetEnvelope | null>
```
`spendType` verildiğinde: `WHERE (envelope.spend_type = :spendType OR envelope.spend_type IS NULL)`
ve `ORDER BY CASE WHEN spend_type = :spendType THEN 1 ELSE 2 END` **en başa** eklenir
(tipli eşleşme, UNSPLIT legacy satırı **her zaman** yener). Verilmediğinde bugünkü davranış aynen
korunur (geri uyum).

### §5.2 `reserveForPlan` — spendType ZORUNLU
```ts
reserveForPlan(
  planId, amount, channel, periodMonth, currency, tenantId, userId,
  spendType: 'ON_INVOICE' | 'OFF_INVOICE',   // YENİ, ZORUNLU, manager'dan ÖNCE
  manager?,
): Promise<BudgetTransaction>
```
**Neden zorunlu (opsiyonel değil):** iki kanonik submit yolu var (`plan.service.ts:816` split'siz,
`approval-workflow.service.ts:230` split'li). Opsiyonel parametre, unutulan yolu **sessizce**
tipsiz bırakır → tipli zarf düzeninde mis-attribution. Zorunlu parametre bunu **derleme zamanında**
yakalar. `plan.service.ts#submit` de bu turda split'e geçmek zorundadır (§6 R6).

Semantik değişiklikler:
- Net/idempotency kapsamı `envelopeId` → **`(envelopeId, spendType)` kovası**. `budget.service.ts:407-421`
  `netOutstanding` ve `envelopeReserves` filtreleri `tx.spendType === spendType` koşulunu almalı.
  **Bu, §2.4'teki canlı hatanın tam düzeltmesidir.**
- Idempotency key: `RESERVE|PLAN|<planId>|<envelopeId>|<SPEND_TYPE>` (+ T-033'ün
  `|GEN<n>` jenerasyon son eki korunur). Tipli zarfta `envelopeId` zaten farklı olurdu ama
  UNSPLIT fazında aynıdır → **son ek zorunlu**. (T-019 task notu bunu `|<envelopeId>` veya
  `|<spendType>` olarak öngörmüştü; doğru cevap **ikisi birden**.)
- Availability kontrolü, zarf tipliyse o zarfın kendi `available_amount`'ı;
  **UNSPLIT zarf için bkz. §5.5 birleşik kural.**

### §5.3 `commitReservedForPlan` — çoklu kova, dizi döner (T-033 notunun kapanışı)
```ts
commitReservedForPlan(
  planId, tenantId, userId,
  ctx: { onInvoice: number; offInvoice: number; channel: string; periodMonth: string; currency: string },
  manager?,
): Promise<BudgetTransaction[]>     // ESKİ: Promise<BudgetTransaction>
```
Bugünkü `find(ilk POSTED COMMIT) → erken dön` ve `find(ilk POSTED RESERVE)` mantığı **kaldırılır**;
yerine:
1. Plan'ın tüm POSTED transaction'ları `(envelopeId, spendType)` kovalarına gruplanır.
2. Her kova için **net** (`Σ RESERVE+COMMIT − Σ RELEASE`) hesaplanır.
3. Kovada zaten COMMIT varsa **ve** net değişmemişse → o kova için no-op (kova bazlı idempotency;
   bugünkü "herhangi bir COMMIT varsa hepsi bitti" varsayımı çoklu zarfta **ikinci zarfı hiç
   commit etmiyordu** — [[T-033]]'ün işaret ettiği kırılma).
4. Net > 0 olan her kova için: `RELEASE(net)` key `RELEASE|PLAN|<planId>|<envId>|<TYPE>|CONVERT`
   **+** `COMMIT(net)` key `COMMIT|PLAN|<planId>|<envId>|<TYPE>`. Net encumbrance değişmez
   (v_budget_summary RESERVE ve COMMIT'i aynı havuzda toplar).
5. Hiç RESERVE'ü olmayan tip için fallback doğrudan-COMMIT yolu **tip bazında** çalışır
   (availability yeniden kontrol edilir).

### §5.4 `releaseForPlan` / `BudgetReservationService#releaseNetReservation`
Gruplama anahtarı `envelopeId` → **`${envelopeId}|${spendType ?? 'UNTYPED'}`**. Kova başına tek
RELEASE, tutar = net (ham satır tipiyle değil — kural #4 korunuyor).

Idempotency key kuralı (**bağlayıcı, iki ayrı anahtar uzayı**):
```
UNTYPED kova : RELEASE|<SRC>|<sourceId>|<envelopeId>                 ← BUGÜNKÜ FORMAT, DEĞİŞMEZ
tipli kova   : RELEASE|<SRC>|<sourceId>|<envelopeId>|<SPEND_TYPE>    ← YENİ
```
Gerekçe: bugünkü format değiştirilirse, T-019 öncesi **zaten release edilmiş** bir kaynak yeni
formatla **ikinci kez** release edilir (çift iade — [[T-029]] fix'inin düzelttiği hatanın aynısı).
İki uzay aynı parayı asla tarif etmez, çünkü bir (kaynak, zarf) çiftinde tipsiz satırlar yalnızca
T-019 öncesinden, tipli satırlar yalnızca T-019 sonrasından gelebilir. Savunma testi: §7 T4.

### §5.5 `checkBudgetAvailability` (approval-workflow) — TODO kapanıyor
```ts
private async checkBudgetAvailability(tenantId, channelCode, periodMonth, onAmount, offAmount)
```
- ON ve OFF zarfları **ayrı ayrı** çözülür (`findEnvelopeByDimensions(..., spendType)`).
- Her tip kendi zarfının `available_amount`'ına karşı ölçülür. `offInvoice.available` artık
  gerçekten off-invoice'ı gösterir ([[T-017]] S-4 bulgusu kapanır).
- `overallSufficient = onSufficient && offSufficient` — **toplam karşılaştırması DEĞİL**
  (BRD "ayrı ayrı"; ayrıca %100+ → block).
- ⚠️ **Birleşik kural (UNSPLIT zarf):** `onEnv.id === offEnv.id` ise (legacy tek havuz)
  yeterlilik `on + off <= available` üzerinden hesaplanır. Bu kural olmadan iki tutar tek tek
  sığar ama birlikte sığmaz → **yeni bir sızıntı** doğar. `reserveForPlan` de aynı kuralı
  uygulamak zorundadır (ikinci rezervasyon, birincinin yazdığı net'i gördüğü için sıralı
  çağrılarda otomatik doğrudur — ama tek transaction içindeki sıra bağımlılığı teste bağlanmalı: §7 T3).
- Zarf yoksa: bugünkü gibi `available: 0, sufficient: false`.

### §5.6 Threshold değerlendirmesi — tip bazında
- `BudgetThresholdService` **değişmez** (T-012 config-driven, tenant-scoped; eşikler hâlâ tek yerden).
- Değerlendirme **zarf satırı başına** yapılır; zarf artık tipli olduğu için
  "ayrı ayrı" bedelsiz gelir: `usagePercent = (reserved + consumed) / allocated` her tip için ayrı.
- **Block kuralı:** yalnızca **aşan tip** bloklanır. Off-invoice zarfı %100'ü aşmışsa,
  sadece on-invoice harcayan bir plan submit edilebilir. Gerekçe: BRD zarfları "ayrı ayrı"
  tanımlıyor; birini diğerinin durumuyla bloklamak zarfları fiilen tek havuza geri indirger.
  (Onay için §8 Q4.)
- `getBudgetStatus(tenantId, channel, categoryId?, periodMonth?, spendType?)`: `spendType`
  **opsiyonel**; verilmezse bugünkü gibi tipler **toplanmış** döner + yanıta **additive**
  `bySpendType: { onInvoice: {...}, offInvoice: {...} }` bloğu eklenir. Mevcut alanlar
  (`totalAllocation/available/reserved/consumed/planned/status`) **aynen korunur** (§7 R-geri uyum).

### §5.7 `SpendingType.BOTH` kuralı

**Plan tarafı — BRD'ye ek kural GEREKMİYOR, çünkü ayrım zaten yukarıda çözülüyor.**
`spend-calculation.service.ts` (satır ~424-505) `SpendingType.BOTH`'u `MechanicCategory` ile
deterministik olarak yönlendiriyor:
- `BOTH` + `ON_INVOICE_DISCOUNT` kategorisi → on-invoice kovası,
- `BOTH` + off/diğer tanınan kategori → off-invoice kovası,
- `BOTH` + **tanınmayan** kategori → `logger.warn` + **atla** (çift sayımı önlemek için).

Yani bütçe katmanına ulaşan iki skaler (`totalOnInvoice`, `totalOffInvoice`) **zaten BOTH içermez**.

> **Mimari kural (bağlayıcı):** on/off çözümü `SpendCalculationService`'in sorumluluğudur;
> `shared/budget` bu kararı **yeniden uygulamaz**, yalnızca iki hazır skaleri tüketir.
> Aksi hâlde iki farklı doğruluk kaynağı oluşur (BRD "hesap koda gömülmez" ilkesiyle de çelişir —
> sınıflandırma mechanic konfigürasyonundan gelir).

**Agreement tarafı — BRD'de kanıt YOK.** `agreements.spend_type` `ON_INVOICE|OFF_INVOICE|BOTH`
(nullable) ve `reserveForAgreement` tek `amount` (cap) ile çağrılıyor; agreement'ta on/off
cap kırılımı **yok**. `BOTH` bir cap'in hangi oranda iki zarfa dağılacağına dair BRD'de hiçbir
ifade yoktur → **kanıt yetersiz, ürün sahibine sorulmalı (§8 Q2).**
Ara dönem bağlayıcı kural (uydurma bölme YAPMA):
- `spend_type ∈ {ON_INVOICE, OFF_INVOICE}` → ilgili tipli zarfa rezerve edilir;
- `spend_type = BOTH` **veya** NULL → hedef boyutta UNSPLIT zarf varsa oraya (bugünkü davranış,
  değişiklik yok); boyut **split edilmişse** `400 AGREEMENT_SPEND_TYPE_SPLIT_REQUIRED` ile
  **reddedilir** — cap'in yarısını rastgele bir zarfa koymak sessiz mis-attribution olurdu.
- `reserveForAgreement` imzasına `spendType` eklenir; key `RESERVE|AGREEMENT|<id>|<envId>|<TYPE>`
  (bugünkü envelope'suz `RESERVE|AGREEMENT|<id>` key'i **geriye dönük değiştirilmez** — T-030'un
  kısıtı; yeni satırlar yeni formatta yazılır, okuma tarafı key'e değil `(envelope, spendType)`
  net'ine bakar).

---

## §6 Riskler

| # | Risk | Şiddet | Azaltma |
|---|---|---|---|
| **R1** | Faz 2 re-home'da çift sayım (T-029/T-030 sınıfı) | Kritik | Append-only RELEASE+RESERVE, `REHOME` son ekli ayrı key uzayı, net-korunum invaryantı (§7 T1) |
| **R2** | Tipsiz/tipli key uzaylarının çakışması → ikinci kez release (çift iade) | Kritik | §5.4 iki-uzay kuralı + §7 T4 mutasyon testi |
| **R3** | UNSPLIT zarfta on ve off **tek tek** sığar, birlikte sığmaz | Yüksek | §5.5 birleşik kural (`onEnv.id === offEnv.id → on+off <= available`) |
| **R4** | İki zarf kilidi ters sırada alınırsa deadlock (`findEnvelopeWithLock` pessimistic write) | Orta | **Deterministik sıra zorunlu:** her zaman önce `ON_INVOICE`, sonra `OFF_INVOICE`; eşitlikte `envelope.id ASC`. `docs/analysis/0005` §4 kilit disiplininin uzantısı |
| **R5** | Submit başına zarf araması 2×; yeni `OR spend_type IS NULL` koşulu indeksi bozabilir | Orta | §3.4 indeks genişletmesi; `<500ms` bütçesi için `EXPLAIN` kanıtı QA'de |
| **R6** | İki kanonik submit yolundan yalnız biri düzeltilirse tipsiz rezervasyon sızar | Yüksek | `spendType` **zorunlu parametre** (derleme zamanı yakalar) + `plan.service.ts#submit` bu turda split'e geçer |
| **R7** | `plan.service.ts:1027` auto-create-on-approve **tek** zarf yaratıyor | Yüksek | Auto-create tipli çift (ON+OFF) yaratmalı; `allocatedAmount` bugünkü heuristiği tip başına uygulanır. Bu yol zaten tartışmalı (bütçe uydurur) — [[T-019]] kapsamında en azından tip-tutarlı hale gelmeli |
| **R8** | Seed değişikliği kirli DB'de ikinci rezervasyon üretir | Yüksek | §4 seed notu: yalnız `db:reset` + `seed`; migration'a seed onarımı konmaz (T-047 dersi) |
| **R9** | §2.4 canlı hatası (off-invoice hiç rezerve edilmiyor) | Yüksek | §5.2 kova-bazlı net + §7 T2 mutasyon testi |
| **R10** | Multi-tenant izolasyon: yeni zarf arama/ikiz yaratma yollarında `tenantId` düşmesi | Kritik | Tüm yeni sorgular `tenant_id` filtresiyle; split endpoint'i `@TenantId()` üzerinden; §7 T6 çapraz-tenant testi |
| **R11** | `budget_allocations` paralel modeli tip ayrımını **ayrıca** iddia ediyor → ikinci doğruluk kaynağı | Orta | Bu turda dokunulmaz; ayrı task ile `@deprecated` işaretlenmeli (0 satır, ledger'a bağlı değil) |

---

## §7 Test / mutasyon kanıtı stratejisi

Kural: her koruma için **(a)** koruma açıkken geçen bir test, **(b)** korumayı sökünce (mutasyon)
**hangi assert'in hangi sayıyla** patladığı. Sabit fixture: `ENV allocated = 500.000`,
mevcut off-invoice rezerv `75.000`.

**T1 — Ledger korunum invaryantı (tek en güçlü koruma; e2e + migration sonrası SQL)**
```
∀ envelope: Σ_kovalar( Σ(RESERVE+COMMIT) − Σ(RELEASE) )  ==  v_budget_summary.reserved_amount
∀ kova    : net >= 0
```
Mutasyon: faz 2 re-home'un `RELEASE(net)` adımını sil → ON-zarf 75.000 + OFF-zarf 75.000 = 150.000
≠ 75.000 → **T1 kırılır**. Aynı test faz 1 migration'ının "para taşımadığı"nı da kanıtlar
(up öncesi/sonrası `reserved_amount` snapshot'ı **birebir aynı**).

**T2 — §2.4 canlı hatasının regresyonu (unit, `budget.service.spec.ts`)**
`reserveForPlan(plan, 100, ON)` sonra `reserveForPlan(plan, 40, OFF)` aynı UNSPLIT zarfa.
Beklenen: **2 RESERVE satırı**, net 140.
Mutasyon: `netOutstanding`/`envelopeReserves` filtrelerinden `tx.spendType === spendType`
koşulunu kaldır → ikinci çağrı erken döner, net **100** olur → test `140 !== 100` ile patlar.

**T3 — UNSPLIT birleşik yeterlilik (e2e, submit)**
Zarf available = 100. Plan on=60, off=60. Beklenen: submit **reddedilir**, hiçbir RESERVE yazılmaz.
Mutasyon: §5.5 `onEnv.id === offEnv.id` dalını kaldır (her tip kendi başına ölçülsün) →
ikisi de 60 ≤ 100 geçer, net 120 > 100 → test "reserved_amount ≤ allocated" ile patlar.

**T4 — İki key uzayı (unit)**
T-019 öncesi formatla (`RELEASE|PLAN|<id>|<env>`) release edilmiş tipsiz bir kova için
`releaseForPlan` tekrar çağrılır. Beklenen: **no-op, 0 yeni satır**.
Mutasyon: UNTYPED kovaya da `|UNTYPED` son eki ekle → yeni key eskiyle çakışmaz, ikinci RELEASE
yazılır → net **−75.000**'e düşer → T1 (`net >= 0`) patlar.

**T5 — Çoklu zarf COMMIT (unit, T-033 notunun kapanış kanıtı)**
Plan iki kovaya (ON=100, OFF=40) rezerve edilmiş; approve.
Beklenen: **2 COMMIT** (100 ve 40), 2 CONVERT-RELEASE, net toplam 140 (değişmez).
Mutasyon: `commitReservedForPlan`'daki kova döngüsünü "ilk COMMIT varsa dön" eski haline çevir →
OFF kovası hiç commit edilmez, plan APPROVED ama 40 hâlâ RESERVE'de → "APPROVED planın tüm
encumbrance'ı COMMIT olmalı" assert'i patlar.

**T6 — Multi-tenant (e2e)** Tenant A'nın split'i Tenant B'nin zarflarını görmez/etkilemez;
`POST /envelopes/:id/split` başka tenant'ın id'siyle 404.

**T7 — Threshold tip bazında (unit)** OFF zarf %100 dolu, ON %10. Yalnız on-invoice harcayan plan
submit **geçer**; off-invoice içeren plan **bloklanır**. Mutasyon: değerlendirmeyi tipler toplamı
üzerinden yap → ilk senaryo yanlışlıkla bloklanır.

**T8 — Geri uyum (frontend, Vitest + backend contract)** `GET /budget/status` yanıtındaki mevcut
alanlar korunur (`totalAllocation/available/reserved/consumed/planned/status`), yalnız
`bySpendType` eklenir. `GET /budget/envelopes` her zarfa `spendType` (nullable) ekler.

**Migration testleri:** `up()` → T1 snapshot eşitliği; `down()` → kolonlar gider, backfill'lenen
tx'lerin `spend_type`'ı NULL'a döner, **başka satıra dokunulmaz**; faz 2 çalışmışken `down()`
**exception** fırlatır.

---

## §8 Ürün sahibine sorulacaklar (kanıt yetersiz)

| # | Soru | Neden kanıt yok | Cevap gelene kadarki davranış |
|---|---|---|---|
| **Q1** | Mevcut tek havuzlu zarflar (ör. NKA-Q1 500.000) on/off arasında **hangi tutarlarla** bölünecek? | BRD ayrımı tanımlıyor, bölme oranına dair tek kelime yok. Finance ownership. | Faz 1'de **bölünmez** (UNSPLIT legacy, bugünkü davranış). Bölme Finance'ın açık girdisiyle faz 2'de. |
| **Q2** | `agreements.spend_type = BOTH` olan bir agreement'ın cap'i iki zarfa **nasıl** dağılır? Agreement'a `cap_on_invoice_amount` / `cap_off_invoice_amount` alanları eklenmeli mi? | BRD'de BOTH kavramı hiç geçmiyor. | Split edilmiş boyutta **400 ile red** (`AGREEMENT_SPEND_TYPE_SPLIT_REQUIRED`); UNSPLIT boyutta bugünkü davranış. |
| **Q3** | `SpendingType.BOTH` + tanınmayan `MechanicCategory` bugün **sessizce 0 spend** üretiyor (`spend-calculation.service.ts` ~505 `logger.warn` + skip). Bu doğru mu, yoksa validasyon hatası mı olmalı? | Mevcut davranış kod kararı; BRD'de karşılığı yok. Sessiz 0, bütçeyi **eksik** düşürür. | Değiştirilmez, ama T-019 e2e'sinde açıkça test edilip görünür kılınır. Ayrı task önerilir. |
| **Q4** | Off-invoice zarfı %100'ü aşmışken, **yalnız on-invoice** harcayan bir plan submit edilebilmeli mi? | BRD "ayrı ayrı" diyor ama block'un kapsamını söylemiyor. | **Evet, edilebilir** (§5.6): yalnız aşan tip bloklanır. Onay isteniyor. |
| **Q5** | Zarf `category` boyutu BRD'de "opsiyonel". Split operasyonu kategori kırılımlı zarflarda da aynı mı çalışacak (kategori × tip = 2× satır)? | BRD opsiyonelliği tanımlıyor, etkileşimi tanımlamıyor. | Aynı kural: `spend_type` diğer üç boyuttan bağımsız bir boyut olarak çarpar. |

---

## §9 Mimari karar özeti

**⚠️ Koşullu onay.** Model kararı (`spend_type` ayrıştırıcısı, hem `budget_envelopes` hem
`budget_transactions` üzerinde; §3 Seçenek B+C) mimari olarak uygundur ve mevcut event-sourced
encumbrance grain'ini bozmaz. Onay şu **beş koşula** bağlıdır:

1. `reserveForPlan`/`reserveForAgreement`'ta `spendType` **zorunlu** parametre (opsiyonel değil) — R6.
2. Net hesabının kapsamı her yerde `(envelopeId, spendType)` kovası; ham satır tipiyle asla — kural #4.
3. RELEASE key'inin **UNTYPED uzayı korunur**, tipli uzay ayrı son ekle yaşar — R2 / §5.4.
4. Faz 1 migration'ı **hiç para taşımaz**; taşıma yalnız faz 2'nin açık, net-korumalı split
   operasyonundadır — §4.
5. §7 T1 (ledger korunum invaryantı) CI'da koşar ve her mutasyon senaryosu kanıtlanır.

Bu koşullardan biri düşerse karar **❌ uyumsuz**dur: koruma olmadan bu tasarım, oturumda görülen
altı çift-sayım hatasının yedincisini üretmeye yapısal olarak açıktır.
