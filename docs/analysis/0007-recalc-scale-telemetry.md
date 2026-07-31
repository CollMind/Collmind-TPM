# 0007 — Recalc'ın ölçekte BRD uyumu + telemetri (T-046)

- **Durum:** analiz tamamlandı — **§5 öneri içerir, karar ürün sahibinindir (§6)**
- **Tarih:** 2026-07-31 · **Yazan:** architect ajanı
- **Önce:** [[T-044]] (kanıt) · ADR 0003 (karar: `<500ms` = uçtan uca) · [[T-045]] (N+1 temizliği, 540→421 ms)
- **Kural:** Ölçüm > tahmin. Ölçülmemiş her cümle **(ÇIKARIM)** veya **(KANIT YETERSİZ)** ile işaretli.

---

## §1 Ölçüm

### 1.1 Ölçüm noktası (T-044'te belirsizdi — burada açık)

- **Nokta:** `supertest` ile **in-process HTTP**. Sayaç `t0 = Date.now()` istek gönderilmeden hemen
  önce, `t1` HTTP yanıtı tamamen alındıktan sonra. Yani ölçülen: **Nest HTTP pipeline (guard/pipe/
  interceptor) + controller + PlanService + advisory lock + tüm DB round-trip'leri + yanıt
  serileştirme**.
- **DAHİL DEĞİL:** ağ RTT (loopback bile yok, in-process), tarayıcı/React render, TanStack Query
  cache invalidation. ADR 0003 `<500ms`'i "input change → UI update" saydığı için **gerçek uçtan uca
  süre bu rakamların ÜSTÜNDEDİR** — aşağıdaki tüm sayılar BRD bütçesinin **alt sınırıdır**.
- **DB round-trip sayısı:** `pg.Client.prototype.query` prototip düzeyinde sarmalanarak sayıldı →
  TypeORM'un ürettiği her sorgu, advisory lock ve transaction komutları dahil, **tam sayım**.
- **Ortam:** Docker `collmind-tpm-postgres` (host 5434), db `collmind_tpm`, şema `main`,
  `Wella Turkey` tenant'ı, dev makinesi (Darwin 25.1). Warm-up + 5 ölçüm; ilk (soğuk) atıldı.
- **Harness:** `test/zz-perf-scale.e2e-spec.ts` — **geçici**, ölçüm sonrası silindi (repo'da yok).
  Ürettiği tüm master-data ve planlar `E2E-PERF-` önekli; `afterAll` içinde `cleanupTestPlans` +
  SKU/FU silme ile temizlendi.

### 1.2 Test verisi

BRD NFR-2.1 (500+ SKU) ve NFR-2.2 (50+ FU) kapsam içi. Mevcut seed'de tenant genelinde **toplam
167 SKU / 11 FU** var — 500 SKU'lu bir plan seed verisiyle **kurulamıyor**. Bu yüzden `E2E-PERF-`
önekli sentetik FU/SKU master-data üretildi (`unit_price`, `cogs` dolu). Plan'lar API üzerinden
(`POST /plans`, `POST /plans/:id/fus`) kuruldu; hacimler tek SQL UPDATE ile dolduruldu (dolu grid
senaryosu). Ölçülen işlem: **`PATCH /plans/:id/fus/:fuId/skus/:skuId/volume`** — BRD'nin
User Story 1.3'teki tam akışı (tek hücreye hacim gir).

### 1.3 Sonuçlar — tactic YOK (`plan_fus.tactics` boş)

| Senaryo | FU | SKU | DB round-trip | round-trip/SKU | Süre (5 koşum, ms) | Medyan | ms/SKU |
|---|---|---|---|---|---|---|---|
| S1 | 1 | 52 | 185 | 3.56 | 198, 189, 201, 191, 196 | **195** | 3.75 |
| S2 | 4 | 200 | 641 | 3.21 | 601, 609, 576, 618, 718 | **609** | 3.05 |
| S3 | 10 | 500 | 1565 | 3.13 | 1532, 1495, 1711, 1561, 1418 | **1532** | 3.06 |
| S4 | **50** | 500 | 1725 | 3.45 | 1594, 1620, 1668, 1630, 1627 | **1627** | 3.25 |

### 1.4 Sonuçlar — tactic VAR (FU başına 3 mekanik: `CPP_ON_PCT=5, CPP_OFF_PCT=3, VIS_LS=1000`)

| Senaryo | FU | SKU | DB round-trip | round-trip/SKU | Süre (ms) | Medyan | ms/SKU |
|---|---|---|---|---|---|---|---|
| T1 | 1 | 52 | 497 | 9.56 | 370, 370, 346, 375, 348 | **370** | 7.12 |
| T2 | 4 | 200 | 1841 | 9.21 | 1381, 1615, 1304, 1377, 1324 | **1377** | 6.89 |
| T3 | 10 | 500 | **4565** | 9.13 | 3372, 3500, 3320, 3175, 4579 | **3372** | 6.74 |

### 1.5 Ölçek eğrisi — **LİNEER, süper-lineer DEĞİL**

- round-trip/SKU sabit (3.1-3.6 tactic'siz; 9.1-9.6 tactic'li) → maliyet **O(n)**, n = plan SKU sayısı.
- ms/SKU sabit (~3.1 tactic'siz, ~6.9 tactic'li) → süre de **lineer**.
- **T-046 task dosyasındaki "500+ SKU'da ~10× olur" ekstrapolasyonu ölçümle DOĞRULANDI**
  (52→500 = 9.6× SKU, 195→1532 ms = 7.9× süre; sabit ~35 ms taban maliyeti nedeniyle biraz altında).
  Ama **doğru gerekçeyle**: sorun kombinatoryal patlama değil, **SKU başına sabit sayıda DB
  round-trip** ödenmesi.
- **FU sayısının etkisi ikincil:** aynı 500 SKU, 10 FU yerine 50 FU'ya dağıtıldığında round-trip
  1565→1725 (+160, yani FU başına ~4), süre 1532→1627 ms (+%6). NFR-2.2 (50+ FU) tek başına eşiği
  bozan faktör **değil**; belirleyici olan SKU sayısıdır.

### 1.6 Eşik nerede aşılıyor? (doğrusal uydurma)

| Akış | Uydurulan model | `<500 ms` aşıldığı SKU | `<100 ms` (KPI_Details, SKU volume update) aşıldığı SKU |
|---|---|---|---|
| tactic yok | ms ≈ 3.06·n + 36 | **~152 SKU** | ~21 SKU |
| tactic var (3 mekanik) | ms ≈ 6.72·n + 21 | **~71 SKU** | ~12 SKU |

**Cevap (soru 1): evet, eşik ölçekte aşılıyor.** BRD `<500 ms` sınırı — in-process, render hariç
ölçümle bile — tactic girilmemiş planda **~150 SKU**, tactic girilmiş planda **~70 SKU** civarında
aşılıyor. BRD'nin kapsam içi ilan ettiği **500 SKU**'da süre **1.5 s (tactic'siz) / 3.4 s (tactic'li)**,
yani bütçenin **3× / 6.8× katı**. NFR-1.4 (`API response time < 300 ms p95`) ise **52 SKU'lu
tactic'li planda bile** (370 ms) aşılıyor.

### 1.7 T-045'in 421 ms'i ile farkın dürüst kaydı

T-045, 52 SKU'lu seed planında **421 ms** raporladı; burada aynı boyutta **195 ms** ölçüldü.
Fark açıklanamadı — **(KANIT YETERSİZ)**. Olası nedenler: T-045'in ölçüm noktası (curl/dev server
mı, in-process mi) task kaydında yazılı değil; plan/veri farklı (bu ölçümdeki sentetik SKU'larda
`cogs` dolu, seed SKU'larında `cogs` NULL); makine yükü. **Bu belgenin tüm karşılaştırmaları kendi
içinde tutarlıdır (aynı harness, aynı oturum); T-045'in rakamıyla doğrudan kıyaslanmamalıdır.**

---

## §2 Kalan darboğazlar — **ölçülmüş**, tahmin değil

Yöntem: aynı harness'ta `pg.Client.prototype.query` sarmalandı; her SQL metni normalize edilip
**çağrı sayısı + toplam süre** olarak toplandı. Aşağıdaki tablolar **tek bir
`PATCH .../volume` isteğinin** içindeki DB zamanının tamamıdır.

### 2.1 S3 — 500 SKU, 10 FU, tactic YOK (istek toplamı 1532 ms)

| Sorgu | n | Toplam ms | avg ms | İsteğin %'si | Kaynak |
|---|---|---|---|---|---|
| `lta_agreements` (LTA context) | 500 | 327.6 | 0.66 | %21 | `spend-calculation.service` → `getLTAForPlanContext`, **SKU başına 1** |
| `plan_skus` hydration (re-read) | 503 | 288.9 | 0.57 | %19 | `plan.service.ts:1654` `findPlanSku` (Adım 5) |
| **Plan tam-ağaç `findById`** | **5** | **251.4** | **50.29** | %16 | aşağıda 2.3 |
| `plan_skus` DISTINCT-id (re-read'in 1. yarısı) | 503 | 207.2 | 0.41 | %14 | aynı `findPlanSku` (TypeORM `find`+relations = 2 sorgu) |
| batch `UPDATE plan_skus` | 10 | 53.7 | 5.37 | %4 | T-045'in batch'i — **FU başına 1**, çalışıyor |
| `plan_fus` hydration | 11 | 43.3 | 3.94 | %3 | |
| geri kalan (plan_fus DISTINCT, UPDATE'ler, lock, COMMIT, mechanics, user) | ~30 | ~23 | — | %1.5 | |
| **DB toplamı** | **1565** | **~1195** | | **%78** | |
| **DB dışı** (TypeORM hydration, Nest, KPI motoru JS, serileştirme) | — | **~337** | | %22 | fark olarak hesaplandı |

### 2.2 T3 — 500 SKU, 10 FU, tactic VAR (istek toplamı 3372 ms)

| Sorgu | n | Toplam ms | avg ms | İsteğin %'si |
|---|---|---|---|---|
| `lta_agreements` | **2000** | **1236.2** | 0.62 | **%37** |
| `mechanics` `findOne` | **1501** | **509.7** | 0.34 | **%15** |
| `plan_skus` re-read (2 sorgu) | 1006 | 459.6 | — | %14 |
| Plan tam-ağaç `findById` | 5 | 261.7 | 52.35 | %8 |
| batch `UPDATE plan_skus` | 10 | 124.7 | 12.47 | %4 |
| geri kalan | ~43 | ~58 | — | %2 |

### 2.3 Üç darboğazın teşhisi

**(A) `calculateMechanicSpend` içindeki N+1 — T-045'in ölçemediği kalem, ARTIK ÖLÇÜLDÜ.**
`spend-calculation.service.ts:76` her çağrıda `mechanicRepository.findOne`, `:94` her çağrıda
`getLTAForPlanContext` yapıyor. Çağrı sayısı = **SKU × değeri girilmiş mekanik**.
Ölçüm: 3 mekanikli 500 SKU'lu planda **1500 `mechanics` + 1500 ekstra `lta` sorgusu**
(2000−500 = 1500) → **1746 ms, isteğin %52'si**. Sorgu farkı doğrudan doğrulandı:
tactic yok 1565 round-trip, tactic var 4565 → **tam +3000 = 500 SKU × 3 mekanik × 2 sorgu**.
- `mechanic` zaten `getActiveMechanics` ile plan başına bir kez elde (T-045); `calculateMechanicSpend`
  bu listeyi kullanmıyor, tekrar DB'ye gidiyor. **Saf israf.**
- `getLTAForPlanContext` argümanları (`cplId`, `channelCode`, `categoryCode`, `planId`) **SKU
  boyunca değişmiyor**; plan başına 1 kez çözülüp geçilebilir. **Saf israf.**
- Üretimde risk daha yüksek: bu ölçüm `lta_agreements` tablosu **boşken** yapıldı (0 satır) —
  gerçek LTA verisiyle sorgu başına maliyet artar.

**(B) SKU başına re-read (`findPlanSku`, Adım 5) — T-044'ün O4'ü, T-045'te YAPILMADI.**
`plan.service.ts:1650-1663`: batch UPDATE'ten sonra her SKU tek tek geri okunuyor; TypeORM
`find`+relations olduğu için **SKU başına 2 sorgu**. 500 SKU'da **496 ms (%32)**.
Döngü yalnızca iki değeri topluyor: `plannedVolume` ve `plannedGp`. **İkisi de bellekte hazır** —
`plannedGp` zaten `skuUpdatesForBatch`'e (`plan.service.ts:1602`) yazılan payload'ın içinde,
`plannedVolume` ise recalc tarafından hiç değiştirilmiyor (yüklenmiş ağaçtaki değer).
**Bu 1006 sorgunun tamamı ölçülebilir biçimde gereksizdir.**

**(C) Tam-ağaç `findById` — 3 değil, ÖLÇÜLEN 5 kez; sorgu sayısı az ama sorgu başına 50 ms.**
Tek `PATCH .../volume` isteğinde 5 kez 9-relation'lı tam plan ağacı çekiliyor
(500 SKU'da **avg 50.3 ms**, toplam 251 ms = %16). Kodda dördü isimlendirilebiliyor:
1. `plan.service.ts:519` — `updateSkuVolume`'un kendi scope check'i
2. `plan.service.ts:1365` — `recalculatePlanWithKpiEngine`'in transaction öncesi scope check'i (aynı planı **ikinci kez**)
3. `plan.service.ts:1381` — transaction/lock içinde gerçek okuma (**tek gerçekten gerekli olan**)
4. `plan.service.ts:1715` — FU agregasyonlarını tazelemek için tekrar
5. `plan.repository.ts:256` — `updateUnversioned` UPDATE'ten sonra **kullanılmayan** tam-ağaç geri-okuması
   (recalc'ın son plan yazımı bunu tetikliyor, dönüş değeri `recalculatePlanWithKpiEngineLocked`'ta atılıyor)

#1 ve #2 birebir aynı sorgudur (biri gereksiz), #5 T-045'in `updatePlanSkuUnversioned`'da temizlediği
desenin **plan seviyesindeki hâlâ duran ikizidir**, #4 (B) düzeltilirse gereksizleşir.

### 2.4 Ölü kod — `spend-calculation.service.ts:50`

```ts
private calculationCache: Map<string, any> = new Map();
```
`grep` ile doğrulandı: **yalnızca tanım satırı, hiçbir okuma/yazma yok.** Bugün zararsız; ancak
servis singleton olduğu için biri tenant anahtarı koymadan kullanmaya başlarsa **bir tenant'ın
hesabı diğerine servis edilir** (multi-tenant izolasyon ihlali, sessiz finansal hata).
**Öneri: silinsin.** Sıfır davranış riski, tek satır.

---

## §3 Seçenekler ve BRD bedelleri

### 3.0 Kritik yeni kanıt: BRD'nin kendi referans tasarımı ZATEN kısmi recalc

`.cursor/KPI_Details.docx`, "Update Functions" (satır 148) — birebir:

> `updateSKUVolume(fuId, skuId, newVolume)` - **triggers SKU recalculation**
> `updateFUTactic(fuId, tacticCode, newValue)` - **triggers all SKU recalculations in that FU**

ve "Update Flow" (satır 163) — birebir:

> `// 1. User changes SKU planned volume // 2. updateSKUVolume called // 3. Calculate new SKU KPIs`
> `using engine.recalculate() // 4. Update SKU state with new calculated values // 5. Aggregate all`
> `SKUs to FU level // 6. Aggregate all FUs to Plan level // 7. Update grandTotals state //`
> `8. Trigger debounced save after 2 seconds`

ve "Automatic Aggregation" (satır 149):

> When SKU values change → aggregate to FU level · When FU values change → aggregate to Plan level

**Sonuç:** BRD'nin referans tasarımında hücre düzenlemesi **yalnız o SKU'yu yeniden hesaplar**;
plan seviyesine kadar giden şey **agregasyondur, yeniden hesap değildir**. CTPM'in bugünkü
"1 hücre = tüm planın 500 SKU'sunun yeniden hesabı" davranışı BRD'nin gerektirdiği bir şey **değil**,
BRD'nin öngördüğünden **daha pahalı** bir uygulama seçimidir. Bu, kısmi recalc'ı "BRD'den taviz"
olmaktan çıkarıp **BRD'ye yakınsama** hâline getirir.

### 3.1 Seçenek karşılaştırması

| # | Seçenek | Ölçülen/beklenen etki | BRD bedeli (FR/NFR alıntılı) | Risk |
|---|---|---|---|---|
| **O-A** | **§2(A)+(B)+(C) mikro-temizlik** (N+1'ler, re-read, fazladan findById) | Ölçülen kaldırılabilir: 500 SKU tactic'siz **~900 ms**, tactic'li **~2650 ms** | **Yok** — davranış korunur, formül motoru dokunulmaz (FR-3.2) | Düşük. (B) için eşdeğerlik kanıtı şart (T-045 deseni) |
| **O-B** | **Kısmi recalc**: `updateSkuVolume` → yalnız o SKU + FU + plan agregasyonu; `updateFuTactic` → yalnız o FU'nun SKU'ları | Yapısal: O(n_plan) → O(1) / O(n_fu) | **Bedel yok, hatta uyum artar** (§3.0). FR-3.3 "calculate KPIs in **correct dependency order**" korunur: sıra SKU→FU→Plan, motorun kendi dependency graph'ı değişmez | **Orta.** FU/plan agregatları hâlâ tüm çocukların *değerlerini* ister → tek SQL agregasyonu ile alınmalı. Yanlış yapılırsa BRD RAG kuralı ("SKU Red→FU Red") bozulur → eşdeğerlik testi zorunlu |
| **O-C** | **Async recalc + push/poll** | Endpoint hızlı döner, toplam iş azalmaz | ❗ **FR-3.1** "System shall calculate all KPIs in **real-time** when user changes planned volume or tactic value" + kabul kriteri "Calculation completes within 500ms • **Results displayed with animation** • Grand totals panel updated". Async'te kullanıcı **eski KPI'yı görüp sonra sıçramasını izler** — "real-time" ve "animation" kriterleriyle **çelişir**. Ayrıca ADR 0003 ölçümü "input change → UI update" olduğu için **async süreyi gizlemez, sadece taşır** | **Yüksek** (bkz. 3.2) |
| **O-D** | **Persist'i async'e al, hesabı senkron tut** | Yazma DB maliyeti yanıttan çıkar | ✅ BRD bunu **açıkça öneriyor**: KPI_Details satır 150 "Debounced Auto-Save: Save … 2 seconds after last change", satır 151 "**Optimistic UI updates (update state immediately, save async)**", NFR-1.7 "Auto-save latency < 1 second", User Story 1.3 "Changes are auto-saved after 2 seconds" | Orta — "Pending'de immutable" ve audit kurallarıyla kesişir; kaydedilmemiş değişiklikle submit riski (3.2) |
| **O-E** | Hiçbir şey yapmama | — | 500 SKU'da NFR-1.2 **3-6.8× ihlal**, NFR-1.4 (<300 ms p95 API) 52 SKU'lu tactic'li planda bile ihlal, NFR-2.1 ("Support 500+ SKUs per plan") fiilen karşılanmıyor | — |

### 3.2 O-C/O-D'nin [[T-034b]] ile etkileşimi — evet, risk gerçek

`submit()` (`plan.service.ts:623`) bütçeyi **`plan.totalSpend`** üzerinden rezerve ediyor
(BRD: "Approved bütçeden düşer"). Bu alanı **yalnızca recalc** yazıyor.

- **Bugün güvenli:** recalc HTTP yanıtından önce COMMIT ediyor; ayrıca recalc'ın son
  `UPDATE plans` satır kilidi ile `submit()`'in `findByIdForUpdate` (`FOR UPDATE`) kilidi aynı satırda
  sıraya giriyor. Yani submit her zaman **son düzenlemeyi içeren** `totalSpend`'i görüyor.
- **Async recalc'ta (O-C/O-D) kırılır:** kullanıcı hücreyi düzenler → yanıt döner → recalc kuyrukta →
  kullanıcı hemen Submit'e basar → `submit()` **eski `totalSpend`** ile rezerve eder →
  **eksik/fazla bütçe rezervasyonu**, yani BRD bütçe kuralının sessiz ihlali.
- T-034b'nin **K5 istisnası** (`submit()` `plans.version`'ı doğrular) bu deliği **kapatmaz**:
  recalc `updateUnversioned` ile yazıyor ve **`plans.version`'ı bump etmiyor** (T-034 K4, kodda
  belgeli), `updateSkuVolume` da yalnız `plan_skus.version`'ı bump ediyor. Yani "bekleyen recalc var"
  bilgisi bugünkü version alanlarında **taşınmıyor**.
- **Async seçilirse zorunlu tasarım şartı:** `submit()` ya (i) aynı `pg_advisory_xact_lock`'u
  **bloklayarak** alıp bekleyen recalc'ın bitmesini garantilemeli, ya da (ii) plan üzerinde bir
  `recalc_dirty`/`recalc_seq` işareti tutulup kirli planın submit'i **reddedilmeli**. İkisi de yeni
  durum makinesi yüzeyidir; (ii) FR "Submit" akışına BRD'de olmayan bir hata durumu ekler.

### 3.3 [[T-034c]] advisory lock'un yeni tasarımdaki yeri

- Ölçüm: lock alımı ~0.6-0.9 ms — **tek recalc süresine katkısı ihmal edilebilir**. Sorun lock değil,
  lock'un **tutulduğu süre** (500 SKU'da 1.5-3.4 s tek transaction).
- **Bloklayan (`pg_advisory_xact_lock`) kalmalı.** Try-lock, gerçek bir çakışma olmadığı hâlde
  kullanıcıya 409 gösterir; FR-3.1 "real-time when user changes … value" ile çelişir (T-044 §5.1'de
  aynı sonuca varılmıştı, bu ölçümler onu değiştirmiyor).
- **O-B (kısmi recalc) lock tartışmasını kendiliğinden çözer:** lock-hold süresi O(n_plan)'dan
  O(1)/O(n_fu)'ya düşer → aynı planda eşzamanlı düzenlemede kuyruk maliyeti de aynı oranda düşer.
  Ek olarak **connection-pool baskısı** (0005 §R3) ortadan kalkar: bugün 500 SKU'lu bir plan
  düzenlemesi bir bağlantıyı **1.5-3.4 saniye** işgal ediyor; NFR-1.6 "100 concurrent users" /
  NFR-2.4 "500 concurrent users" ile bu ölçekte **kanıtlanmamış** — bu belgede eşzamanlılık
  ölçülmedi **(KANIT YETERSİZ)**.

### 3.4 `KPI_Details.docx`'in daha sıkı hedefleri NFR-1.2 ile çelişiyor mu?

Birebir alıntı (`.cursor/KPI_Details.docx`, "PROVIDE:" listesi, madde 4 — teslim edilecek
**performans benchmark'ları**):

> **4. Performance benchmarks:**
> - Initial load: < 2s
> - **SKU volume update: < 100ms**
> - **FU tactic update: < 300ms**
> - Save to database: < 1s

BRD PDF §6.1 NFR-1.2 ise: *"KPI calculation time | < 500ms | Time from input change to UI update"*.

**Değerlendirme: çelişmiyor, TAMAMLIYOR — ve daha sıkı olan bağlayıcı.**
1. İkisi de aynı yönde (üst sınır) hedef koyuyor; `100 < 500` olduğu için `<100 ms` sağlanırsa
   NFR-1.2 de otomatik sağlanır. Mantıksal çelişki yok.
2. NFR-1.2 **tek bir global rakam**, KPI_Details **akış-bazlı ayrıştırma** yapıyor: en sık ve en
   ucuz akış (SKU hacim girişi) 100 ms, daha pahalı akış (FU tactic → o FU'nun tüm SKU'ları) 300 ms.
   Bu ayrım §3.0'daki referans tasarımla **birebir tutarlı** (SKU değişimi 1 SKU hesaplar, FU tactic
   değişimi bir FU'nun SKU'larını hesaplar) — yani rakamlar rastgele değil, **iş miktarıyla orantılı**.
3. NFR-1.2 alt sınır değil üst sınır olduğu için "500 ms'e kadar serbest" okuması KPI_Details'i
   geçersiz kılmaz; KPI_Details'in daha dar bütçesi **aynı NFR ailesinin daha ayrıntılı hâlidir**.
4. Aynı belgede "Save to database: < 1s" ayrı ve gevşek — yani bu 100/300 ms **hesap+görünen
   güncelleme** bütçesidir, kalıcılaştırma bütçesi değil (ADR 0003'ün okumasıyla uyumlu).

**Bugünkü uyum:** `<100 ms` SKU hacim hedefi **hiçbir plan boyutunda** karşılanmıyor —
52 SKU tactic'siz **195 ms**, 36 SKU tactic'li **281 ms**. Doğrusal modele göre `<100 ms`
ancak ~21 SKU (tactic'siz) / ~12 SKU (tactic'li) altında sağlanıyor. **Ürün sahibi bu iki hedefin
bağlayıcılığını karara bağlamalı** (ADR 0003 yalnız NFR-1.2'yi kapsıyordu).

---

## §4 Telemetri — minimum uygulanabilir öneri

**Sorun:** bugün hiçbir eşik/ölçüm enforce edilmiyor. `<500ms`'e atıf yapan **6 yer de yalnız yorum**
(`plan.service.ts:536`, `:1348`, `plan.repository.ts:657`, `versioned-update.helper.ts:25`,
`dashboard.service.ts:45`, `settlement-summary.service.ts:38`, `update-sku-volume.dto.ts:18`).
**Telemetri olmadan uyum iddia edilemez** — bu belgedeki her rakam elle, geçici bir harness'la
üretildi ve harness silindi; yarın regresyon olsa **kimse fark etmez**.

Kapsam bilinçli olarak küçük: **izleme platformu kurmuyoruz.** Dört kalem:

### T1 — Recalc'ın kendi ölçümü (backend, zorunlu)
- **Nerede:** `PlanService#recalculatePlanWithKpiEngine` (`plan.service.ts:1358`), transaction
  wrapper'ın etrafı — hem başarı hem hata yolunda.
- **Ne ölçülür:** `durationMs` (lock alımı dahil), `lockWaitMs`, `skuCount`, `fuCount`, `tenantId`,
  `planId`, `trigger` (`updateSkuVolume` | `updateFuTactic` | `addFu` | `removeFu` | `manual`).
- **Nereye yazılır:** Nest `Logger` üzerinden **yapısal (JSON) tek satır**. Yeni altyapı yok.
  Eşik altındaysa `debug`, aşıldıysa **`warn`** — BRD'nin referans monitörüyle aynı desen
  (`KPI_Details.docx` `performanceMonitor`: `if (duration > 500) console.warn(...)`).
- **Eşik nereden:** **hardcode edilmez.** `ConfigService` anahtarı (`PERF_RECALC_WARN_MS`,
  varsayılan 500) — RAG eşiği değildir, dolayısıyla KPI config'e girmez; ama koda gömülmesi de
  aynı sebeple yanlıştır.
- **Eşik aşımında ne olur:** **hiçbir şey iptal edilmez, timeout konmaz.** Yavaş ama doğru bir
  hesap, hızlı ama eksik bir hesaptan iyidir (BRD FR-3.2/FR-3.3 doğruluk şartı). Yalnız `warn` log.

### T2 — Yanıt başlığı (backend, ucuz, uçtan uca ölçümü mümkün kılar)
Recalc tetikleyen 4 endpoint'in yanıtına `X-Recalc-Ms` ve `X-Recalc-Sku-Count` başlığı.
ADR 0003 metriği "input change → **UI update**" olduğu için **uçtan uca ancak frontend ölçebilir**;
bu başlık frontend'e "bunun ne kadarı backend'di" ayrımını verir. Tek satırlık interceptor.

### T3 — Frontend `performanceMonitor` (BRD'nin istediği, bugün yok)
`KPI_Details.docx` §PERFORMANCE MONITORING zaten `utils/performanceMonitor.ts`'i tarif ediyor;
implemente edilmemiş. Minimum: hücre `onSave` anında `performance.mark`, KPI'lar grid'e
render edildikten sonra `performance.measure` → eşik aşımında `console.warn` + (varsa) mevcut
hata kanalına sayaç. **Bu, ADR 0003'ün tanımladığı metriğin TEK doğru ölçüm noktasıdır.**

### T4 — Performans regresyon testi (CI, tek test)
`test/` altında **kalıcı** bir e2e: sabit boyutlu (`E2E-PERF-` önekli, afterAll'da temizlenen)
bir plan üzerinde `PATCH .../volume` süresi ve **DB round-trip sayısı** ölçülür.
- Süre eşiği CI makinesine göre gürültülüdür → **asıl assert `round-trip sayısı` olmalı**
  (deterministik): "500 SKU'lu planda ≤ N sorgu". Bu belgedeki N+1'lerin **geri gelmesini** yakalar.
- Süre yalnız log'lanır, assert edilmez (flaky test üretmemek için).

**Bilinçli olarak KAPSAM DIŞI:** APM/OpenTelemetry entegrasyonu, metrik deposu, dashboard, alerting
kuralları. Bunlar ayrı bir altyapı kararıdır; yukarıdaki dördü onlarsız da bugün uygulanabilir.

---

## §5 Öneri — karar

**"Duruma göre" değil. Sıralı ve net:**

### 5.1 Önce O-A (mikro-temizlik), ama TEK BAŞINA YETMEZ — bu ölçülmüş bir sonuçtur

O-A'nın ölçülen kaldırılabilir maliyeti 500 SKU'da: tactic'siz ~974 ms, tactic'li ~2360 ms.
Çıkarma aritmetiğiyle kalan **(ÇIKARIM — düzeltme sonrası yeniden ölçülmeli)**:

| 500 SKU | Bugün | O-A sonrası tahmini | BRD bütçesi |
|---|---|---|---|
| tactic yok | 1532 ms | **~560 ms** | 500 ms |
| tactic var | 3372 ms | **~1010 ms** | 500 ms |

Üstelik bu rakamlar **render hariç**. Yani **O-A tek başına 500 SKU'da BRD'ye uyum sağlamaz.**
Sebebi ölçümde görünüyor: DB israfı tamamen silinse bile geriye **DB dışı ~337 ms** (500 SKU'luk
TypeORM hydration + KPI motoru JS) + kaçınılmaz DB (~150 ms) kalıyor ≈ **~490 ms**, yani bütçenin
tam sınırında, render'dan önce. **O(n_plan) yapısı korunduğu sürece 500 SKU'da eşik matematiksel
olarak tutturulamaz.**

### 5.2 Asıl karar: **O-B (kısmi recalc) yapılmalı; O-C (async) yapılmamalı**

- **O-B lehine:** §3.0'daki BRD referans tasarımı zaten bunu tarif ediyor; FR-3.1 "real-time",
  FR-3.3 "correct dependency order" ve `<500 ms` bütçesi **korunur, hatta ilk kez gerçekten
  sağlanır**; `KPI_Details`'in `<100 ms` / `<300 ms` ayrımı ancak bu tasarımda anlamlı hâle gelir;
  T-034c lock-hold süresi ve connection-pool baskısı kendiliğinden düşer.
- **O-C aleyhine:** FR-3.1'in "real-time" ve "Results displayed with animation" kabul kriterleriyle
  doğrudan çelişir; ADR 0003 ölçümü UI'a kadar olduğu için **süreyi gizlemez, sadece taşır**; ve
  §3.2'deki bütçe rezervasyonu deliğini açar. **Async'in tek meşru kullanımı O-D'dir (kalıcılaştırma),
  hesap değil** — bunu BRD'nin kendi metni söylüyor ("Optimistic UI updates … save async").

### 5.3 Riskli noktalar (uygulayan ajan bunları kapatmadan "done" demesin)

1. **Eşdeğerlik kanıtı zorunlu (T-045 deseni).** O-A ve O-B'den önce/sonra aynı plan için
   `calculated_kpis` dahil tüm KPI/spend sütunları SKU+FU+plan seviyesinde **birebir aynı** olmalı.
   Performans uğruna sessizce değişen hesap bu üründe **finansal hatadır**.
2. **RAG agregasyonu (BRD):** "SKU Red → FU Red, karışık → Amber, hepsi Green → Green".
   Kısmi recalc'ta FU'nun RAG'i **tüm** çocuk SKU'lara bakmalı — yalnız değişen SKU'ya değil.
   Bu, "yeniden hesap kısmi ama agregasyon tam" ayrımının test edilmesi gereken tam yeridir.
3. **FU tactic değişimi kısmi DEĞİLDİR:** o FU'nun **tüm** SKU'ları yeniden hesaplanmalı
   (KPI_Details satır 148 birebir böyle diyor). Yanlışlıkla tek SKU'ya indirgenirse sessiz hata olur.
4. **`plannedTurnover`/`tacticSpend` gibi off-invoice mekanikler SKU'lar arası bağımlı olabilir:**
   `calculateOffInvoiceDiscount` `allOnInvoicePromoSpends` alıyor — kısmi recalc'ta bu bağlamın
   eksik kalması riski var. **Uygulamadan önce doğrulanmalı** (bu belgede incelenmedi —
   **KANIT YETERSİZ**).
5. **`plans.version` bump edilmiyor** (T-034 K4): kısmi recalc'a geçilse bile submit'in gördüğü
   `totalSpend` tazeliği bugünkü gibi **satır kilidi sıralamasıyla** sağlanmalı; senkron kaldığı
   sürece güvenli, async'e kayarsa §3.2 geçerli olur.
6. **Ölçüm harness'ı kalıcılaştırılmalı (T4)** — aksi hâlde bu belgedeki hiçbir rakam yarın
   doğrulanamaz.
7. **`calculationCache` silinsin** (§2.4) — tek satır, sıfır davranış riski, multi-tenant mayını.
8. **Eşzamanlılık ölçülmedi.** NFR-1.6 (100 kullanıcı) / NFR-2.4 (500 kullanıcı) bu belgede
   **test edilmedi** — 500 SKU'lu bir düzenlemenin bir bağlantıyı 1.5-3.4 s işgal ettiği göz önüne
   alınırsa ayrı bir yük testi gerekir **(KANIT YETERSİZ)**.

### 5.4 Önerilen task bölünmesi

| Task | İçerik | Bağımlılık | Risk |
|---|---|---|---|
| **T-046a** | §2(A) `calculateMechanicSpend` N+1 + §2(B) SKU re-read + §2(C) fazladan `findById` + §2.4 ölü kod | — | Düşük |
| **T-046b** | §4 T1+T2+T4 telemetri ve regresyon testi | T-046a sonrası (temiz taban) | Düşük |
| **T-046c** | §3.1 O-B kısmi recalc (mimari) | T-046b (ölçüm olmadan yapılmaz) | **Yüksek** — eşdeğerlik + RAG testleri şart |
| **T-046d** | §4 T3 frontend `performanceMonitor` (ADR 0003 metriğinin gerçek ölçümü) | bağımsız, frontend | Düşük |

---

## §6 Ürün sahibine sorulacak tek soru

> BRD `KPI_Details.docx` "Performance benchmarks" listesi hücre düzenlemesi için **SKU volume
> update < 100 ms**, **FU tactic update < 300 ms** diyor ve aynı belgenin referans tasarımı
> (`updateSKUVolume` → *"triggers SKU recalculation"*, `updateFUTactic` → *"triggers all SKU
> recalculations in that FU"*) **kısmi recalc** öngörüyor; CTPM ise her hücre düzenlemesinde tüm
> planı yeniden hesaplıyor ve bu yüzden 500 SKU'da 1.5 s (tactic'siz) / 3.4 s (tactic'li) sürüyor —
> **kabul kriterimiz ADR 0003'teki tek `<500 ms` mi kalıyor, yoksa `KPI_Details`'in akış-bazlı
> 100/300 ms hedeflerini de bağlayıcı sayıp mimariyi kısmi recalc'a taşıyor muyuz?**

---

## Ekler

- **Ölçüm harness'ı:** `collmind.backend/test/zz-perf-scale.e2e-spec.ts` — geçici, ölçüm sonrası
  **silindi**; repo'ya girmedi. (Kalıcı sürümü §4-T4 olarak önerilmiştir.)
- **Test verisi temizliği:** üretilen tüm plan/FU/SKU `E2E-PERF-` önekliydi; `afterAll` içinde
  `cleanupTestPlans` + SKU/FU `DELETE`. Doğrulandı: `plans` 190 (değişmedi), `skus` 167 (değişmedi),
  `E2E-PERF-%` eşleşen kayıt **0**, `budget_envelopes.consumed_amount` tüm zarflarda **0.00**
  (planlar DRAFT'ta kaldı, hiç submit/approve edilmedi → bütçe sızıntısı yok).
- **İlgili:** `docs/analysis/0006-recalc-performance-brd-scope.md`,
  `docs/decisions/0003-recalc-500ms-kapsami.md`, `.claude/backlog/tasks/T-044.md`,
  `.claude/backlog/tasks/T-045.md`, `docs/analysis/0005-optimistic-locking-design.md` (§4 R3).
