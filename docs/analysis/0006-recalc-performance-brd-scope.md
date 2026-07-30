# 0006 — Recalc performansı ve BRD `<500ms` kuralının kapsamı (T-044)

- **Durum:** analiz — **karar YOK**. Ürün sahibinin cevaplaması gereken tek soru §5'te.
- **Tarih:** 2026-07-30 · **Yazan:** architect ajanı · **Tetikleyen:** [[T-034c]] → [[T-044]]
- **Kural:** Bu belge kanıt toplar. Yorum/çıkarım yapılan her yer **(ÇIKARIM)** ile işaretlidir.
  Kanıt bulunamayan yerde "kanıt yok" yazar; varsayım üretmez.

---

## §1 Kanıt — kuralın birebir geçtiği yerler

Kaynak dosyalar: `.cursor/rules.md`, `.cursor/plan_module.md`, `.cursor/CollMind_TPM_BRD_v1.0.pdf`,
`.cursor/TPM_Base_BRD_Code_Prompts.pdf`, `.cursor/KPI_Details.docx`, `.cursor/KPI_Engine_Prompts.pdf`, `docs/`.
PDF/DOCX metinleri `pdfminer.six` ile çıkarıldı; tablo satır eşleşmeleri **karakter koordinatlarıyla (y ekseni)**
doğrulandı (aşağıda tablo alıntılarının satır bütünlüğü bu yolla teyit edilmiştir).

### E1 — `.cursor/rules.md:91` (Bölüm "5️⃣ KPI & HESAPLAMA MOTORU (EN KRİTİK KURAL)")

> KPI'lar Admin tarafından tanımlanan dinamik formüllerle hesaplanır
>
> Frontend sadece sonucu render eder
>
> **Hesaplama süresi < 500ms olmalıdır**
>
> KPI dependency sırası zorunludur

Kapsam belirten ek kelime **yok**. Cümle tek başına "hesaplama süresi" der; neyin bir hesaplama sayıldığını
(tek formül / tek SKU / tüm plan) bu satır tanımlamıyor.

### E2 — BRD PDF, §6.1 Performance Requirements (s. 28), NFR-1.2

Tablo dört sütunlu: ID | Requirement | Target | **Measurement Method**. Satır hizası koordinatla doğrulandı
(hepsi y≈514.5):

| ID | Requirement | Target | Measurement Method |
|---|---|---|---|
| NFR-1.1 | Page load time | < 2 seconds | Time to interactive on planning screen |
| **NFR-1.2** | **KPI calculation time** | **< 500ms** | **Time from input change to UI update** |
| NFR-1.3 | Grid rendering | < 1 second | Initial render for 50 FUs (200+ SKUs) |
| NFR-1.4 | API response time | < 300ms (p95) | Backend API latency |
| NFR-1.5 | Database query time | < 200ms (p95) | Query execution time |
| NFR-1.6 | Concurrent users | 100 users | Load testing verification |
| NFR-1.7 | Auto-save latency | < 1 second | Time from change to database write |

Aynı tablo `TPM_Base_BRD_Code_Prompts.pdf` içinde de tekrarlanıyor (satır 2205-2207).

### E3 — BRD PDF, §5 FR-3 "Real-Time KPI Calculation" (s. 17), FR-3.1 kabul kriteri

Satır hizası koordinatla doğrulandı (FR-3.1 bloğu, y≈653→501):

> **Requirement:** "System shall calculate all KPIs in real-time when user changes planned volume or tactic value" — Priority: Must Have
>
> **Acceptance Criteria:** "• Calculation completes within 500ms • All dependent KPIs updated • **Results displayed with animation** • **Grand totals panel updated**"

Aynı metin `TPM_Base_BRD_Code_Prompts.pdf:1723`'te de var.

### E4 — BRD PDF, §7 User Story 1.3 "Enter Planned Volumes"

> As a Trade Marketing Planner I want to enter planned volumes at SKU level So that the system can calculate promotional KPIs
>
> Acceptance Criteria:
> • Planned Volume column is editable only at SKU rows
> • I can click to edit, type value, press Enter to save
> • System validates input (positive numbers only)
> • FU row shows sum of all child SKU volumes (read-only)
> • **All dependent KPIs recalculate within 500ms**
> • Changed values are highlighted briefly (green flash)
> • Grand Totals Panel updates automatically
> • **Changes are auto-saved after 2 seconds**

(`TPM_Base_BRD_Code_Prompts.pdf:2682` aynı metin.)

### E5 — BRD PDF, §13.1 Project Success Criteria (Go/No-Go)

> - [ ] **Performance targets met (<2s page load, <500ms calculations)**

### E6 — BRD PDF, §13.3 System Health KPIs (Ongoing)

> | KPI | Target | Alert Threshold |
> | System uptime | 99.5% | <99.0% |
> | **API response time (p95)** | **<300ms** | **>500ms** |
> | Page load time (p95) | <2s | >3s |
> | **Calculation time** | **<500ms** | **>1s** |
> | Error rate | <0.1% | >1% |
> | Database query time | <200ms | >500ms |

### E7 — BRD PDF, §6.2 Scalability Requirements (NFR-2.5)

> Handle 10,000+ KPI calculations per second — Measurement: Benchmarking

### E8 — `.cursor/plan_module.md:143` ("Adım 3: Hacim Girişi" ekranı içinde)

> `GERÇEK ZAMAN HESAPLAMA (<500ms):`
> `✓ Incremental Volume = Planned - Base`
> `✓ Volume Uplift % = Incr / Base * 100`
> `✓ Tüm bağımlı KPI'lar otomatik güncellenir`

### E9 — `.cursor/plan_module.md:405-412` ("⚙️ Teknik Özellikler")

> | Özellik | Hedef |
> | Sayfa Yükleme | < 2 saniye |
> | **KPI Hesaplama** | **< 500 ms** |
> | Grid Render | < 1 saniye (50 FU, 200+ SKU) |
> | Otomatik Kaydet | 2 saniye debounce |
> | Eş Zamanlı Kullanıcı | 100 kullanıcı |
> | Maksimum Plan Boyutu | **500+ SKU, 50+ FU** |

### E10 — `TPM_Base_BRD_Code_Prompts.pdf:7599-7615` ("Calculation Performance Optimization")

> Calculation Performance Optimization:
> - Debounce rapid changes (300ms delay)
> - Calculate incrementally (only affected rows)
> - Use Web Workers for complex calculations
> - **Show loading spinner only if calculation > 500ms**
> - Cache intermediate results

### E11 — `TPM_Base_BRD_Code_Prompts.pdf:9948-9958` ("SECTION 9: PERFORMANCE & TECHNICAL REQUIREMENTS")

> Grid Rendering:
> Initial load: < 2 seconds (100 FUs)
> Add FU: < 100ms
> **Cell edit response: < 50ms**
> **Calculation complete: < 500ms**
> Scroll smoothness: 60 FPS

### E12 — `TPM_Base_BRD_Code_Prompts.pdf:10280`

> ✓ **Real-time KPI calculations with <500ms response**

### E13 — `.cursor/KPI_Details.docx` (satır 756-760, "Performance benchmarks")

> 4. **Performance benchmarks:**
> - Initial load: < 2s
> - **SKU volume update: < 100ms**
> - **FU tactic update: < 300ms**
> - **Save to database: < 1s**

### E14 — `.cursor/KPI_Details.docx:82` / `KPI_Engine_Prompts.pdf:301` (FormulaParser spec)

> **Performance: Parse 100 formulas in < 100ms**

### E15 — `.cursor/KPI_Details.docx:662-680` (PERFORMANCE MONITORING, `utils/performanceMonitor.ts`)

> ```
> if (duration > 500) {
>   console.warn(`⚠️ Slow operation: ${label} took ${duration.toFixed(2)}ms`);
> }
> ```
> Usage in calculation engine: `async calculateSKU(context) { const endMeasure = perfMonitor.startMeasure('calculateSKU'); ... }`

### Bulunamayanlar (kanıt yok)

- "500ms **per formula** / **tek formül değerlendirmesi**" ifadesi **hiçbir kaynakta geçmiyor**.
  (`grep`: `500` geçen tüm satırlar tarandı; böyle bir nitelendirme yok.)
- "500ms yalnızca **backend** hesap süresi" ifadesi de **hiçbir kaynakta geçmiyor**.
- Plan boyutuna göre kademeli hedef (ör. "SKU başına X ms") **hiçbir kaynakta yok**.

---

## §2 İki okuma ve her birinin kanıtı

### Okuma (a): "500ms = tek formül / tek KPI değerlendirmesi"

**Lehine kanıt:**
- E1 tek başına okunduğunda ("Hesaplama süresi < 500ms") kapsam belirtmiyor; teknik olarak (a) okumasını
  dışlamıyor.
- E15'teki referans monitör `calculateSKU` çağrısını ölçüyor ve eşik 500 — yani BRD ekosisteminde 500 sayısı
  **SKU seviyesindeki bir çağrıya** da uygulanmış. (Not: bu "tek formül" değil, "tek SKU'nun tüm KPI'ları"dır.)

**Aleyhine kanıt:**
- E7: sistem **saniyede 10.000+ KPI hesabı** yapabilmeli. Tek formül değerlendirmesi 500ms sürerse bu hedef
  matematiksel olarak imkânsız olur (aynı belgede, 2 sayfa arayla). **(ÇIKARIM: iki hedef ancak "500ms =
  tek formül değil" okunursa tutarlı olur.)**
- E14: formül **parse** hedefi "100 formül < 100ms". Yani tek formülün maliyeti mikro-saniye mertebesinde
  varsayılmış; 500ms bir formülün bütçesi olamaz.
- E2'nin ölçüm yöntemi sütunu doğrudan (a)'yı dışlıyor (aşağı bkz.).
- E13: "SKU volume update: < 100ms" — tek SKU güncellemesi için hedef **500 değil 100ms**. (a) okuması bu satırı
  açıklayamıyor.
- (a)'yı destekleyen **birebir metin bulunamadı**. T-034c'de ajanın ürettiği "BRD'nin 500ms'i tek formül
  değerlendirmesi içindir" cümlesinin **kaynakta karşılığı yok**.

### Okuma (b): "500ms = kullanıcının gördüğü uçtan uca recalc"

**Lehine kanıt:**
- **E2 (en güçlü):** NFR-1.2'nin ölçüm yöntemi birebir **"Time from input change to UI update"**. Bu, tanım
  gereği kullanıcının gördüğü toplam süredir; tek formül veya salt backend süresi değildir.
- **E3:** FR-3.1'in kabul kriterleri **aynı 500ms cümlesiyle aynı listede** "Results displayed with animation"
  ve "Grand totals panel updated" maddelerini sayıyor → 500ms bütçesi **render'ı da içine alan** bir akış için
  yazılmış.
- **E4:** User Story 1.3'te "All dependent KPIs recalculate within 500ms" **hücreye değer girme** akışının kabul
  kriteri. Aynı listede auto-save ayrı ve daha gevşek (2 sn) — yani 500ms yazma süresini değil, **görünen
  güncellemeyi** kapsıyor.
- **E8/E12:** "GERÇEK ZAMAN HESAPLAMA (<500ms) ... Tüm bağımlı KPI'lar otomatik güncellenir" — çoğul,
  bağımlılık zinciri dahil.
- **E10:** "Show loading spinner only if calculation > 500ms" — 500ms'in ötesi **kullanıcının bekleme
  hissettiği** eşik olarak konumlanmış; bu ancak (b) okumasında anlamlı.
- **E9:** hedef tablo "Maksimum Plan Boyutu 500+ SKU" satırıyla aynı tabloda; yani 500ms hedefi büyük planları
  **dışlamıyor**, aynı tablo onları kapsam içi ilan ediyor. **(ÇIKARIM: "52 SKU büyük olduğu için katları
  doğal" savunması bu tabloyla çelişir.)**

**Aleyhine / sınırlayıcı kanıt:**
- E13, tek 500ms yerine akış-bazlı ve **daha sıkı** alt hedefler veriyor: SKU volume update < 100ms,
  FU tactic update < 300ms, DB'ye kaydetme < 1s. Yani (b) doğru olsa bile "500ms" tek bir global rakam değil;
  hangi akış için hangi rakam sorusu ayrıca cevaplanmalı.
- E2/E6 ayrıca **NFR-1.4: API response time < 300ms (p95)** diyor. Mevcut recalc endpoint'i (≈540ms) bu daha sıkı
  eşiği de aşıyor — yani (a) okuması kabul edilse bile **NFR-1.4 ayrı bir uyumsuzluk** olarak ayakta kalır.
  Bu, kararın "500ms yorumu" ile kapanmadığını gösteren bağımsız kanıttır.

### (c) — Kanıtın işaret ettiği üçüncü olasılık: mimari kayma

BRD/prompt seti hesabın **istemcide** yapıldığını varsayıyor: E10 "Use Web Workers for complex calculations",
`KPI_Details.docx:165` "1. User changes SKU planned volume → ... 3. Calculate new SKU KPIs using
engine.recalculate() ... 8. Trigger debounced save after 2 seconds", `KPI_Engine_Prompts.pdf:628` "Auto-save to
Supabase after 2 seconds of no changes". CTPM'de motor **backend'de** ve **her hücre yazımı senkron tam-plan
recalc tetikliyor** (`plan.service.ts:463/506/565/602`).
**(ÇIKARIM: BRD'nin 500ms bütçesi "istemci içi hesap + debounce'lı ayrı kayıt" mimarisi için yazılmış olabilir;
CTPM bu bütçeyi "HTTP round-trip + tam plan yeniden hesap + DB yazımı" ile harcıyor. Bu bir kapsam sorusu değil,
mimari kayma sorusudur ve ürün sahibinin kararını etkiler.)** Bu bir çıkarımdır; BRD hiçbir yerde "hesap
frontend'de yapılmalıdır" demez — aksine `rules.md:89` "Frontend sadece sonucu render eder" der. İki ifade
gerilim halindedir; **kanıt bu gerilimi çözmüyor.**

---

## §3 Bugün kod tarafında ne ölçülüyor / enforce ediliyor?

**Cevap: hiçbir şey.**

- Backend'de recalc süresi için **eşik, timeout, alarm veya metrik yok**. `grep -rn "500"` sonuçlarının hepsi ya
  HTTP 500, ya `varchar(500)`, ya test verisi, ya da yorum satırı.
- 500ms'e atıf yapan yerler yalnızca **yorum**: `plan.service.ts:536` ("Grid hot path (BRD <500ms)"),
  `plan.service.ts:1348`, `plan.repository.ts:574`, `versioned-update.helper.ts:25`,
  `dashboard.service.ts:45`, `settlement-summary.service.ts:38`. Hiçbiri çalışma zamanında bir şey ölçmüyor.
- Tek gerçek zaman ölçümü: `spend-calculation.service.ts:290/455` ve `472/625` — `Date.now()` ile süre
  hesaplanıp `SpendBreakdown`'a konuyor; **eşik kontrolü veya log/alarm yok**.
- Frontend'de perf telemetrisi yok. BRD'nin önerdiği `utils/performanceMonitor.ts` (E15) **implemente edilmemiş**.
- Perf regresyon testi yok (`test/` altında recalc süresi assert eden test bulunamadı).

**Sonuç:** kural bugün hiçbir katmanda enforce edilmiyor; 540ms ölçümü de ancak T-034c'de elle yapıldı.

---

## §4 Profil — 540ms nereye gidiyor? (kapsam (b) senaryosu için)

### 4.1 Kod okumasıyla çıkarılan çağrı grafiği

`PlanService#recalculatePlanWithKpiEngineLocked` (`plan.service.ts:1422-1739`), plan başına:

1. `findById` (**pre-transaction** scope check, 9 relation'lı tam ağaç) — `plan.service.ts:1365`
2. `pg_advisory_xact_lock` — `plan.repository.ts:160`
3. `findById` (**tekrar**, aynı ağaç, transaction içinde) — `plan.service.ts:1381`
4. **Her SKU için** (52×):
   - `spendCalc.calculateAllSpendsForSKU` →
     - `ltaAgreementService.getLTAForPlanContext` → `getActiveAgreementForCPL` → `findActiveForCPL`
       (4 join'li sorgu) **(sorgu #1)**
     - aynı fonksiyon içinde `getRatesForContext` → **yine** `getActiveAgreementForCPL` → **birebir aynı sorgu
       tekrar** (`lta-agreement.service.ts:309`) **(sorgu #2)**
     - `mechanicRepository.find({tenantId, isActive:true})` — **SKU'dan bağımsız, sabit sonuç**, her SKU'da
       yeniden çekiliyor (`spend-calculation.service.ts:323`) **(sorgu #3)**
   - `kpiEngine.calculateSku` — DB'ye gitmiyor (KPI listesi 60 sn TTL cache, formüller cache'li) → saf CPU
   - `updatePlanSkuUnversioned` → `repo.update(...)` **(sorgu #4)** + ardından `repo.findOne(..., relations:
     ['sku','planFu'])` **(sorgu #5)** — *bu SELECT'in dönüş değeri recalc tarafından **kullanılmıyor**,
     atılıyor* (`plan.repository.ts:560-568`)
5. **Her SKU için tekrar** (52×): `findPlanSku(...)` — 4. adımda yazılan satırın **üçüncü kez** okunması
   (`plan.service.ts:1629`) **(sorgu #6)**
6. FU başına: `kpiEngine.calculateFu` (CPU) + `updatePlanFuUnversioned`
7. Plan seviyesi: `findById` (**üçüncü kez**, tam ağaç) + `kpiEngine.calculatePlan` + `updateUnversioned`

→ **SKU başına 5 DB round-trip + plan başına 3 tam-ağaç sorgusu.**

### 4.2 Ölçüm (yeniden üretilebilir)

Yöntem: yukarıdaki sorgu dizisi ham SQL olarak, üretim verisiyle (`collmind-tpm-postgres`, `collmind_tpm`,
şema `main`), 52 SKU'lu plan `09cfc1f8-368c-4fbb-b75e-bb7675e20028` (`PLAN-2026-Q3-339-3818`) üzerinde
`node-pg` ile tek bağlantıda, tek transaction'da (sonunda ROLLBACK) yeniden oynatıldı. İki koşu:

| Sorgu sınıfı | Adet | Toplam (koşu 1) | Toplam (koşu 2) | Ortalama |
|---|---|---|---|---|
| LTA `findActiveForCPL` (4 join) | **104** | 79.1 ms | 69.4 ms | ~0.7 ms |
| Plan `findById` (9 relation, tam ağaç) | **3** | 77.3 ms | 41.3 ms | ~14-26 ms |
| `findPlanSku` re-read (adım 5) | 52 | 46.5 ms | 33.2 ms | ~0.8 ms |
| `UPDATE plan_skus` | 52 | 45.8 ms | 33.7 ms | ~0.8 ms |
| UPDATE sonrası **atılan** SELECT | 52 | 41.0 ms | 44.0 ms | ~0.8 ms |
| `mechanics` find (sabit sonuç) | 52 | 29.0 ms | 31.5 ms | ~0.6 ms |
| UPDATE plan_fus / plans / advisory lock | 3 | 3.3 ms | 1.7 ms | — |
| **TOPLAM** | **318 round-trip** | **324.9 ms** | **256.7 ms** | — |

Ek ölçüm (gerçekçi yazma yükü, ~500 byte / 24 anahtarlı `calculated_kpis` JSONB ile):

- 52 ayrı satır UPDATE'i: **43.2 ms**
- Aynı işin tek çok-satırlı UPDATE'i: **18.1 ms**

**Ölçümün sınırları (dürüst kayıt):**
- Bu rakamlar **yalnızca DB round-trip** maliyetidir. TypeORM entity hydration, Nest/DI, KPI engine JS, HTTP
  serialization dahil **değildir**. Yani ~257-325 ms, 540 ms'in **alt sınırıdır**.
- Ham SQL, TypeORM'un ürettiği SQL'in **yakın eşdeğeridir**, birebir kopyası değil (özellikle `findById`'nin
  9 relation'lı planı). Plan `findById` ölçümü bu yüzden en belirsiz kalem.
- T-034c'nin 540 ms rakamının hangi noktadan ölçüldüğü (HTTP mü, servis mü) task kaydında yazılı değil —
  **kanıt yetersiz**; kıyas yaparken bu belirsizlik korunmalı.

### 4.3 Kırılımdan çıkan sayılabilir gerçekler

1. **318 round-trip'in 156'sı (%49) provably gereksiz tekrardır:** 104 LTA sorgusu birebir aynı parametrelerle
   (plan başına 1 kez yeterli), 52 `mechanics` sorgusu SKU'dan bağımsız sabit sonuç. Ölçülen maliyet ~100-110 ms.
2. **52 SELECT tamamen boşa gidiyor:** `updatePlanSkuUnversioned` UPDATE'ten sonra ilişkileriyle satırı geri
   okuyor, recalc bu dönüşü kullanmıyor. ~41-44 ms.
3. **Aynı satır bir recalc'ta 3 kez okunuyor:** tam-ağaç `findById` içinde, UPDATE sonrası SELECT'te, ve adım
   5'in `findPlanSku`'sunda.
4. **Tam-ağaç `findById` 3 kez çalışıyor** (~41-77 ms toplam) — biri yalnızca scope check için.
5. **KPI motoru DB'ye gitmiyor** (60 sn TTL cache + formula cache). **Yani "formül motoru yavaş" hipotezi
   ölçümle desteklenmiyor**; darboğaz N+1 sorgu düzenidir.
6. **Tek hücre düzenlemesi tam plan recalc'ı tetikliyor:** `updateSkuVolume` (`plan.service.ts:565`),
   `updateFuTactic` (602), `addFu` (463), `removeFu` (506) — dördü de HTTP yanıtından **önce**, senkron olarak
   52 SKU'nun tamamını yeniden hesaplıyor. **(ÇIKARIM: kapsam (b) kabul edilirse asıl ihlal endpoint süresi değil,
   "1 hücre = 52 SKU recalc" tasarımıdır; plan 500 SKU'ya çıkınca (E9'un kapsam içi ilan ettiği boyut) maliyet
   yaklaşık 10× olur.)**

---

## §5 Seçenekler (karar değil — maliyet/risk envanteri)

### 5.1 Advisory lock (T-034c) alternatifleri

| Seçenek | Etki | BRD/UX bedeli | Risk |
|---|---|---|---|
| **Mevcut: bloklayan `pg_advisory_xact_lock`** | Aynı planda eşzamanlı recalc ~2× (1035-1148 ms) | UX: ikinci düzenleme kuyrukta bekler, kullanıcı bunu gecikme olarak görür | Uzun transaction → connection pool baskısı (0005 §R3'te zaten işaretlenmiş) |
| **`pg_try_advisory_xact_lock` + 409** | Bekleme yok | ❗ Kullanıcı açısından **gerçek bir çakışma olmadığı halde** hata görür; her grid-edit çağıranı (update/addFu/updateFuTactic/updateSkuVolume/removeFu) bespoke "recalc meşgul" yönetimi ister | **BRD ihlali riski:** FR-3.1 "real-time when user changes ... value" — reddedilen recalc "real-time hesap" değildir |
| **Debounce (sunucu tarafı, ör. 300 ms)** | Ardışık hızlı düzenlemelerde recalc sayısı düşer | BRD bunu **açıkça öneriyor** (E10: "Debounce rapid changes (300ms delay)"), ama orada **istemci tarafı** debounce'tur | Debounce penceresi 500 ms bütçesinin içinden yenir; son yazımın kaybolmaması için "trailing edge garantisi" şart |
| **Kuyruk / async recalc + push** | Endpoint hızlı döner | ❗ `rules.md:89` "Frontend sadece sonucu render eder" ile gerilim: sonuç gecikmeli gelir, grid geçici olarak eski KPI gösterir. FR-3.1 "real-time" ve E3 "Results displayed with animation" kabul kriterleri tehlikeye girer | Audit/tutarlılık: kullanıcı Submit'e async recalc bitmeden basarsa bütçe/validasyon eski değerlerle çalışır — **state machine riski** |
| **Recalc'ı kısaltmak (§5.2)** | Lock **tutma süresini** kısaltır → serialize maliyeti de düşer | BRD bedeli **yok** | Düşük; davranış değişmez |

**Not:** Lock, tek recalc süresine ölçülebilir bir şey eklemiyor (ölçüm: advisory lock çağrısı ~0.7-0.9 ms).
Kötüleşme yalnızca **aynı plan** üzerindeki eşzamanlılıkta ve **recalc uzun olduğu için** ortaya çıkıyor.
**(ÇIKARIM: recalc 540 ms yerine ~150 ms olsaydı, lock'un 2× etkisi de 300 ms'e inerdi; yani lock tartışması
§5.2'ye bağımlıdır.)**

### 5.2 Recalc kısaltma adayları (kapsam (b) kabul edilirse)

Hepsi davranış-koruyucu; hiçbiri BRD kuralına dokunmuyor. Sıralama ölçülen kazanca göre:

| # | Değişiklik | Dosya | Ölçülen/beklenen kazanç | Risk |
|---|---|---|---|---|
| O1 | LTA context'i **plan başına bir kez** çöz, SKU döngüsüne parametre geçir (çift çağrı da kalkar) | `spend-calculation.service.ts:297`, `lta-agreement.service.ts:309` | ölçüldü: ~70-79 ms (104 sorgu → 1) | Düşük. `getRatesForContext`'in kendi içinde agreement'ı yeniden çekmesi zaten redundant |
| O2 | `mechanics` listesini recalc başına bir kez çek | `spend-calculation.service.ts:323` | ölçüldü: ~29-31 ms (52 → 1) | Düşük |
| O3 | `updatePlanSkuUnversioned`'ın kullanılmayan geri-okumasını recalc yolunda atla | `plan.repository.ts:560` | ölçüldü: ~41-44 ms (52 sorgu) | Düşük — dönüş tipi imzası değişir, çağıranlar kontrol edilmeli |
| O4 | Adım 5'teki `findPlanSku` re-read'ini kaldır; toplamları zaten elde olan değerlerden biriktir | `plan.service.ts:1625-1639` | ölçüldü: ~33-46 ms (52 sorgu) | Orta — "transaction içinde taze oku" gerekçesi doc-comment'te; aynı değerler adım 4'te zaten hesaplı |
| O5 | 52 ayrı UPDATE → tek çok-satırlı UPDATE | `plan.repository.ts:553` | ölçüldü: 43.2 → 18.1 ms | Orta — TypeORM dışına çıkan raw SQL gerekir |
| O6 | Pre-transaction `findById` yerine hafif scope projeksiyonu (cplId/categoryId/status) | `plan.service.ts:1365` | ~14-26 ms | Düşük |
| O7 | Değişen SKU/FU için **incremental recalc** (BRD E10: "Calculate incrementally (only affected rows)") | `plan.service.ts:1422` | Yapısal: O(52) → O(1) SKU | **Yüksek** — plan/FU agregatları yine tüm çocukları ister; yanlış yapılırsa BRD "SKU Red → FU Red" agregasyonu bozulur |

**(ÇIKARIM:** O1-O4 birlikte ölçülen DB süresinden ~180-200 ms düşürür; bu, uygulama katmanı maliyeti sabit
kalsa bile 540 ms'i ~350 ms bandına taşır. Bu bir tahmindir, uçtan uca ölçümle doğrulanmamıştır.**)**

### 5.3 Hiçbir şey yapmama (kapsam (a) kabul edilirse)

- Bedel: NFR-1.2 dokümantasyonda yeniden yorumlanır. **Ancak NFR-1.4 (API response time < 300ms p95) ayrıca
  ihlal olarak açık kalır** — recalc endpoint'i 540 ms. §13.3'e göre >500 ms API p95 **alarm eşiği**.
- Ayrıca E9/E13'ün kapsam içi ilan ettiği 500+ SKU'luk planlarda mevcut yapı ~5-10× artar (§4.3-6).

---

## §6 Ürün sahibine sorulacak tek soru

> **BRD NFR-1.2'nin ölçüm yöntemi birebir "Time from input change to UI update" ve FR-3.1'in 500 ms kabul kriteri
> "Results displayed with animation / Grand totals panel updated" maddeleriyle aynı listede yer alıyor — bu 500 ms'i
> kullanıcının hücreye değer girip güncellenmiş KPI'ları gördüğü ana kadar geçen toplam süre olarak mı kabul
> ediyoruz (bugün 52 SKU'lu planda ~540 ms, ayrıca NFR-1.4'ün <300 ms API hedefini de aşıyor), yoksa başka bir
> kapsam mı tanımlıyoruz?**

Ek olarak, cevap ne olursa olsun ürün sahibinin ayrıca karara bağlaması gerekenler (kanıt bunları çözmüyor):
1. `KPI_Details.docx`'teki daha sıkı akış hedefleri (SKU volume update < 100 ms, FU tactic update < 300 ms)
   geçerli mi, yoksa NFR-1.2'nin 500 ms'i mi bunları ezer?
2. NFR-1.4 (<300 ms p95 API) recalc endpoint'i için geçerli mi?
3. BRD'nin istemci-içi hesap + debounce'lı kayıt varsayımı (§2-c) ile CTPM'in "her hücre yazımı senkron
   tam-plan recalc" tasarımı arasındaki fark bilinçli bir sapma mı?

---

## Ekler

- Profil betikleri (kalıcı repo dosyası değil, scratchpad): `profile-recalc.js`, `write-cost.js`.
- Ölçüm ortamı: Docker `collmind-tpm-postgres` (host port 5434), db `collmind_tpm`, şema `main`,
  plan `PLAN-2026-Q3-339-3818` (1 FU / 52 SKU), `lta_agreements` tablosu **boş** (0 satır) — yani LTA
  sorguları bugün *en ucuz* hâllerinde ölçüldü; gerçek LTA verisiyle maliyet artar.
- İlgili: `docs/analysis/0005-optimistic-locking-design.md` (§4, R3), `.claude/backlog/tasks/T-034c.md`,
  `.claude/backlog/tasks/T-044.md`.
