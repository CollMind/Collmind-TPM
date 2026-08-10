# 0016 — D-15 / D-16 / D-17: sayısal kontratın açık kararları

- **Tarih:** 2026-08-10
- **Task:** [[T-132]] — **salt-okunur ölçüm.** Kod / migration / entity / test / seed / guard
  değişikliği YOK. Bu doküman **öneri değil, seçenek** sunar; karar ürün sahibinindir
  (CLAUDE.md §2.4).
- **İlgili:** `docs/contracts/SYSTEM_INVARIANTS.md` §9 (D-15/16/17), §8 `INV-N-002` ·
  ADR `0007-sayisal-kontrat.md` (Karar 1/3a/5/6, E3/E4/E8/E10/E15/E16/E17/E18, A4/A7/A9) ·
  ADR `0008` · `docs/analysis/0011`, `0013`, `0014` · `docs/analysis/0002`
- **Blokladığı:** [[T-090]] **F4** (temsil migrasyonu). Üç karar da F4'ün ön koşulu.

## Ölçüm ortamı (koşul kaydı — CLAUDE.md §2.7)

| | |
|---|---|
| meta-repo | `567379f` |
| `collmind.backend` | `d7b6b76` (çalışan ağaç **temiz**) |
| `collmind.frontend` | `0f0cbf8` (çalışan ağaç **temiz**) |
| Node | v24.11.1 · TypeScript **5.9.3** |
| Backend `money-float.sh --ratchet` | `EXIT=0`, taban `168 findings in 28 files` |
| Frontend `money-float.sh` (`GUARD_MODE=report`) | `EXIT=0`, taban `68 findings in 20 files` |
| **Veritabanı** | ⛔ **ÖLÇÜLEMEDİ** — Docker daemon kapalı, port 5434 kapalı. Ayrıntı §5. |

⚠️ **Bu ölçümün en önemli koşulu budur:** aşağıdaki hiçbir cümle canlı veriye dayanmıyor.
Şema iddiaları **entity bildirimi + migration DDL'i** üzerinden, davranış iddiaları **kod
okuması + izole JS koşumu** üzerinden kuruldu. "Bugün bu değer üretiliyor mu?" tipindeki her
soru §5'te açıkça **ölçülemedi** olarak duruyor — tahmin edilmedi.

`0014`'ün sayıları **alıntılanmadı, yeniden türetildi**. Üretici script:
`@Column(...)` bloklarını dengeli-parantez tarayan bir Node script'i (entity + view-entity).
Sonuç `0014 §1.1/§1.3` ile **birebir aynı** çıktı: 89 kolon / 18 transformer'lı / 71
transformer'sız / 26 entity dosyası; transformer'sızların ölçek dağılımı **46 + 8 + 17**.
Yani `0014`'ün kapsam ölçümü bugün de geçerli.

---

## 0. DUR ve bildir — tetiklenen koşullar

Task üç DUR koşulu tanımladı. **Üçü de tetiklendi.**

| Koşul | Durum | Kanıt |
|---|---|---|
| Bir karar **üçüncü bir soru** doğuruyor | ✅ **TETİKLENDİ** | D-15 tek karar değil; en az **üç ayrı eksene** ayrılıyor (§1.4). Task'ın (d) sorusundaki hipotez doğrulandı ve genişledi. |
| `0014`'ün ölçümü **bugün geçersiz** | ✅ **TETİKLENDİ** | `0014`'ün *kendi* sayıları geçerli. Geçersiz olan, D-16/D-17'nin dayandığı **`0013 §3.1` tasarımı**: kararlaştırılmış `PriceMinor` markası **kodda yok**, `SCALE_FACTOR` kayıt tablosu **kodda yok**, `ScaleName` **kodda yok** (§3.1). "İki satırlık iş" iddiası bu üç olguya dayanıyordu. |
| **D-07 kapsamı** bir kararı **konusuz** kılıyor | ⚠️ **KISMEN — ve ters yönde** | `0013 §3.1`'in D-16'yı erteleme gerekçesi *"D-07 hacim taşımıyor"*du. Ölçüldü: `sales_actuals` gerçekten hacim taşımıyor (gerekçe orada **doğru**), ama recognition'ın öteki girdi tablosu `on_invoice_entries` **`quantity numeric(18,3)` + `list_price numeric(18,4)` taşıyor** (§2.2). D-06'nın `LIST_PRICE × VOLUME` seçeneği "hesaplanamaz" diye elenmişti; bu eleme **hangi tablonun "actuals" sayıldığına** bağlı ve o soru sorulmamış. |

**Üçünün ortak sonucu:** D-15/16/17 bugünkü hâlleriyle **tek bir evet/hayır olarak sorulamaz.**
Her biri için önce bir kapsam sorusu cevaplanmalı. Aşağıdaki üç bölüm o soruları ölçümle
kurar.

---

## 1. D-15 — Tam sıfır bir KPI, "KPI yok" ile aynı şey mi?

### 1.0 Önce: ADR 0008 bu soruyu neden kapsamıyor (ve bunu neden yazıyorum)

ADR 0008 *"girilen değerde `null` ile `0` arasında anlam farkı yoktur"* der; kapsamı açıkça
**planner'ın girdiği mekanik değeri**dir (`plan_fus.tactics`, `plan_mechanic_values.entered_*`)
ve gerekçesi *"%0 indirim ile indirim yok arasında ekonomik fark yoktur"*.

D-15'in yedi noktasının **hiçbiri girilen değer değil**. Üstelik ADR 0008'in kendi
"ADR 0006 Karar 2 ile çelişki yoktur" bölümü tam bu eksen ayrımını yapıyor. Aynı disiplin
burada da geçerli: **ADR 0008'i D-15'e gerekçe göstermek, onu vermediği bir kararın dayanağı
yapmak olur.**

Ve kodda bu ayrım **zaten uygulanıyor** — ADR 0008'in tarif ettiği yerde:

```
spend-validation.service.ts, `readEnteredValue` çağrısının üstündeki yorum:
  "Truthiness only here (0 and 'not entered' both skip), so the `?? 0` collapse
   in readEnteredValue preserves behaviour exactly."
```

Yani girilen-değer tarafında truthiness **bilinçli ve kayıtlı**. D-15'in noktaları bu kaydın
dışında.

### 1.1 Bugünkü temsil — ölçüldü, varsayılmadı

Yedi noktanın dayandığı beş kolonun **hepsi** `decimal`, **hiçbirinde transformer yok**:

| Kolon | Entity bildirimi | Runtime |
|---|---|---|
| `plans.overall_roi` | `plan.entity.ts` — `type:'decimal', precision:18, scale:4, nullable:true` | `string` |
| `plan_fus.gp_roi` | `plan.entity.ts` — aynı | `string` |
| `plan_skus.gp_roi` | `plan.entity.ts` — aynı | `string` |
| `mechanics.max_combined_discount_percentage` | `mechanic.entity.ts` — `decimal(5,2), nullable` | `string` |
| `agreements.mechanic_value` | `agreement.entity.ts` — `decimal(18,4), nullable` | `string` |
| `plan_skus.base_volume` / `planned_volume` | `plan.entity.ts` — `decimal(18,3)` | `string` |

Doğrulandı (izole koşum, `EXIT=0`): `Boolean("0.0000") === true`, `Boolean(0) === false`.
Yani `0014 §4.2`'nin flip mekanizması bugün de aynen geçerli.

⚠️ **Ama üç kolonun TS tipi zaten `number` diyor** (`overallRoi?: number | null` vb.). Yani
entity katmanı bugün **yalan söylüyor** ve her tüketici o yalana göre yazılmış. Bu, D-15'in
alt metni: karar hangi yöne verilirse verilsin, tip beyanı ile runtime arasındaki bu uyuşmazlık
duruyor.

### 1.2 Üretici taraf: `null` ile `0` **zaten farklı anlamlar taşıyor**

Bu, D-15'in en belirleyici ölçümü ve `0014`'te yok.

`GP_ROI_PCT` formülü seed'de: `INCR_GP / INCR_SPEND * 100` (`kpi.seed.ts`, `kpiCode:
'GP_ROI_PCT'`, `ragGreenThreshold: 20`, `ragAmberThreshold: 10`).

`formula-parser.service.ts`'in `parseExpression`/`safeEval` zinciri üç sonuç üretiyor:

| Girdi durumu | Sonuç |
|---|---|
| bir bağımlılık `null`/`undefined` | **`null`** (`return null`, bağımlılık döngüsü) |
| bölen sıfır (`/ 0` deseni) | **`null`** ("Division by zero check") |
| `INCR_GP === 0`, `INCR_SPEND !== 0` | **`0`** — meşru, hesaplanmış bir sayı |

Ve yazma tarafı bu ayrımı **koruyarak** kalıcılaştırıyor:
`plan.service.ts`, `const gpRoi = kpiResults['GP_ROI_PCT']?.value ?? null;` — yorumu aynen:
*"If a value is null, it persists as null (BRD: missing data → null)."*
Entity yorumu daha da açık (`plan.entity.ts`, `gpRoi` üstü):
*"BRD: missing data → null, **never a fabricated 0** that masks GP_ROI_PCT as 100%/GREEN
(T-027)."*

**Sonuç:** `0` = "hesaplandı, tam sıfır" · `null` = "hesaplanamadı". Bu ayrım **bugün üretici
tarafta vardır, bilinçlidir ve bir task'a (T-027) dayanır.** D-15 bu ayrımı *tüketici* tarafta
koruyup korumamayı soruyor — sıfırdan kurmayı değil.

**Ve iş anlamı ile ADR 0008'in gerekçesi burada ayrışıyor:** `%0 indirim ≡ indirim yok` doğru
bir eşitlik. Ama `ROI = 0` "getiri yok" demektir ve **para harcanmıştır** — planın en kötü
performans hâlidir; `ROI = null` ise "bilinmiyor"dur. Bunlar aynı şey değil. Ölçümle
sabitlenmiş üçüncü kanıt: RAG.

### 1.3 RAG bu ayrımı **zaten kullanıcıya gösteriyor**

`kpi-engine.service.ts`, RAG ataması:

```
if (kpi.ragGreenThreshold !== undefined && kpi.ragGreenThreshold !== null && value !== null)
  ragStatus = this.determineRagStatus(value, kpi.ragGreenThreshold, kpi.ragAmberThreshold);
```

`determineRagStatus`: `value >= green → GREEN`, `value >= amber → AMBER`, aksi hâlde `RED`.

| `GP_ROI_PCT` | `ragStatus` | Kullanıcının gördüğü |
|---|---|---|
| `0` | `RED` | kırmızı rozet |
| `null` | `null` | rozet **yok** |

Yani "sıfır ROI = ROI yok" kararı verilirse, **bugün RED görünen bir plan rozetsiz hâle
gelir.** Bu BRD'nin RAG kuralının doğrudan konusudur.

⚠️ Yan ölçüm: bu gate `!== null` kullanıyor, truthiness değil — yani **eşiğin kendisi `0`
olabilir** ve temsil değişse bile bu kapı hayatta kalır. `determineRagStatus`'un
`Number(greenThreshold)` sarmalayıcıları, `SYSTEM_INVARIANTS §8`'in *"RAG thresholds survive
only on a compensation"* notunun tam olarak kastettiği telafidir; bugün doğru çalışıyor.

### 1.4 ⚠️ D-15 tek karar değil — en az ÜÇ ayrı eksen (task'ın (d) sorusu)

Task, #5'in (`|| 100`) diğerlerinden farklı olabileceğini sordu. Ölçüm bunu doğruladı **ve
genişletti**: yedi nokta üç ayrı iş sorusuna dağılıyor.

| Eksen | Noktalar | Sıfırın iş anlamı | Yokluğun iş anlamı | Aynı karar mı? |
|---|---|---|---|---|
| **A — Hesaplanmış KPI** | 1, 2, 3, 4 | "ölçüldü, getiri sıfır" (RED) | "ölçülemedi" (rozetsiz) | kendi içinde evet |
| **B — Kural tavanı** | 5 | "hiçbir şeye izin verme" | "sınırsız" | **HAYIR — zıt** |
| **C — Formül girdisi / hacim** | 6, 7 | "değer sıfır, formül çalışsın" | "girdi yok, KPI `null`" | **HAYIR — üçüncü eksen** |

**Eksen B zıttır ve bu ölçümle sabit.** `mechanic.service.ts`, `m.maxCombinedDiscountPercentage
|| 100`: bugün `"0.00"` truthy → tavan 0 (bağlayıcı); temsil değişirse `0` falsy → tavan **100**
(fiilen tavan yok). Aynı yönde bir karar, A ekseninde "bilgiyi koru", B ekseninde "korumayı
kaldır" anlamına gelir.

**Ve B için cevap zaten kodda var — çelişkili iki implementasyon hâlinde** (CLAUDE.md §7):

| Implementasyon | Sıfır tavanı nasıl okuyor | Temsil değişince |
|---|---|---|
| `spend-validation.service.ts` — `mechanic.maxCombinedDiscountPercentage !== null && !== undefined` sonra `combinedDiscount > ...` | **tavan 0 = bağlayıcı** | **değişmez** (açık null kontrolü) |
| `mechanic.service.ts` — `Math.max(...map(m => m.maxCombinedDiscountPercentage \|\| 100))` | **tavan 0 = tavan yok** | **flip eder** |

Yani aynı iş kuralının iki yazımı var ve **sıfır için zıt cevap veriyorlar**. Birincisi canlı
(§1.5), ikincisinin UI tüketicisi yok. Bu, D-15'ten önce cevaplanması gereken bir §7 sorusudur:
**hangisi kanonik?**

> ⛔ **DUR.** D-15'i "tek bir evet/hayır" olarak cevaplamak, B eksenindeki koruma kaldırmayı
> A eksenindeki bir görüntü kararının içine gizler. En az A / B / C ayrı sorulmalıdır.

### 1.5 Nokta nokta: canlı yol var mı, fark kullanıcıya görünür mü?

`0014`'ün yedi noktasının **hepsi bugün yerinde duruyor** (grep ile doğrulandı, satır numaraları
kaymış olabilir — aşağıda grep'lenebilir token verildi).

---

**#1 — `finance-reporting.service.ts`, `getSpendComposition` içinde `if (planFu.gpRoi)`**

- **Canlı yol:** ✅ `GET /finance-reporting/spend-composition`
  (`finance-reporting.controller.ts`, `@Get('spend-composition')`, RBAC'lı) — ve **ikinci
  tüketici**: `getMechanicEffectiveness` aynı metodu çağırıyor →
  `GET /finance-reporting/mechanic-effectiveness`. Frontend `FinanceDashboard.tsx` ikisini de
  çağırıyor.
- **Bugün:** `"0.0000"` truthy → sıfır ROI `totalRoi`'ye eklenir, `roiCount` artar.
- **Temsil değişirse:** sıfır ROI **hiç sayılmaz** → `avgRoi = totalRoi / roiCount` **yukarı
  kayar**.
- **Görünürlük:** ✅ evet, ve **yönü belli**: sıfır ROI, mekaniğin en kötü performans örneğidir;
  onu ortalamadan çıkarmak **her mekaniği daha iyi gösterir**.
- ⚠️ **Ve `avgRoi` bir kullanıcı artefaktına gidiyor:** `collmind.frontend/src/utils/export.ts`,
  `'Avg ROI': slice.avgRoi ? ...toFixed(1) : 'N/A'` — CSV. ADR 0007 **E18**
  gereği bu **Alan A**'dır (dosya frontend Domain A listesinde). Ve orada da bir truthiness var:
  **`avgRoi === 0` bugün bile CSV'ye `N/A` olarak yazılıyor.** Yani bu zincirin ucunda "sıfır =
  yok" kararı **zaten sessizce verilmiş** durumda.

---

**#2 — `plan.service.ts`, `getAnalysis` içinde `plan.overallRoi ? Number(...) : null`**

- **Canlı yol:** ✅ `GET /plans/:id/analysis` (`plan.controller.ts`, `@Get(':id/analysis')`) →
  frontend `PlanAnalysis.tsx`.
- **Bugün:** `0` · **Değişirse:** `null`.
- **Görünürlük:** ⚠️ **hayır — ve sebebi ayrı bir kusur.** `PlanAnalysis.tsx`:
  `currentRoi !== null ? formatPercentage(currentRoi, 1) : '%0.0'` — yani **`null` dalı da
  `%0.0` basıyor.** İki durum aynı metni üretiyor, bugün de, değişimden sonra da.
  **Sonuç:** bu ekran bugün "COGS eksik, ROI bilinmiyor" planı ile "ROI tam sıfır" planını
  **birbirinden ayırt edemiyor** — ve `null` dalını `%0.0` diye basmak, `plan.entity.ts`'in
  T-027 yorumunun (*"never a fabricated 0"*) tam olarak yasakladığı şeyin görüntü katmanındaki
  hâlidir. Bu kusur **temsil kararından bağımsızdır** ve D-15 hangi yöne karara bağlanırsa
  bağlansın ayrıca ele alınmalıdır.
- `status` alanı etkilenmez: `null → 'BELOW_TARGET'`, `0 → 0 >= 20? hayır → 0 >= 10? hayır →
  'BELOW_TARGET'`. **İkisi de aynı rozet.**

---

**#3 — `plan.service.ts`, `fuRoiComparison` içinde `planFu.gpRoi ? Number(...) : null`**

- **Canlı yol:** ✅ aynı rota (`GET /plans/:id/analysis`).
- **Görünürlük:** ✅ **evet, ve bu ekranın tek net farkı budur.** `PlanAnalysis.tsx`:
  `{fu.roi !== null ? formatPercentage(fu.roi, 1) : 'N/A'}` → sıfır ROI'li bir FU satırı
  **`%0,0` yerine `N/A`** görünmeye başlar.
- ⚠️ **Frontend ikizi var ve `0014` onu saymadı.** `collmind.frontend/.../PlanningGridEnhanced.tsx`:
  `return planFu.gpRoi ? Number(planFu.gpRoi) : null;` — **aynı satır, istemcide.** Bu, frontend
  `money-float` tabanındaki o dosyaya ait **tek** bulgudur (guard raporundan doğrulandı). Aynı
  desen ölü `PlanningGrid.tsx`'te de var (T-118).
  **Yani D-15 bir backend kararı değil; frontend'de en az iki ikizi var.**

---

**#4 — `approval-workflow.service.ts`, `getApprovalQueue` içinde `overallRoi ? Number(...) : undefined`**

- **Canlı yol:** ⚠️ **rota var, tüketici yok.** `GET /plans/approval-queue`
  (`plan.controller.ts`, `@Get('approval-queue')`) tanımlı ve RBAC'lı; ama
  `grep -rn "approval-queue" collmind.frontend/src` → **EXIT=1, sıfır eşleşme.** Onay ekranı
  (`PlanApprovalsPage.tsx`) `planEndpoints.getPendingApprovals()` → `/plans/pending-approvals`
  çağırıyor, bu rotayı değil.
- **CLAUDE.md §4.2 ölçütü:** üretim çağrı yolu HTTP olarak var, **ürün etkisi bugün sıfır**.
- **Sonuç:** #4 karar kapsamında **ağırlıksızdır** — kararın maliyet tarafına yazılmamalıdır.

---

**#5 — `mechanic.service.ts`, `checkCombinationValidity` içinde `m.maxCombinedDiscountPercentage || 100`**

- **Canlı yol:** ⚠️ **rota var, tüketici yok.** `POST /mechanics/check-combination`
  (`mechanic.controller.ts`, `@Post('check-combination')`); frontend'de `check-combination`
  araması boş döndü. Bloğun kendi yorumu da durumu söylüyor: *"simplified — in production …
  This is a placeholder."*
- **Bugün:** `"0.00"` truthy → `Math.max` içinde 0'a coerce → tavan 0.
- **Değişirse:** `0 || 100` → **100**, yani **tavan kaybolur**.
- **Ama kararın asıl konusu bu satır değil, §1.4'teki çelişkidir:** canlı kural
  (`spend-validation.service.ts`, `!== null && !== undefined` sonra
  `combinedDiscount > mechanic.maxCombinedDiscountPercentage`) sıfır tavanı **bağlayıcı** kabul
  ediyor ve temsil değişiminden **etkilenmiyor**. İki implementasyon aynı iş kuralına zıt
  cevap veriyor.
- 📌 **Kayda geçer:** `mechanics.max_combined_discount_percentage` bugün hâlâ `numeric(5,2)`.
  ADR 0007 **E8** bu kolonu Karar 5 kapsamına alıp `numeric(9,4)`'e yükseltmeye karar
  vermişti — **uygulanmamış.** Aynı şekilde `lta_rates.on_invoice_percentage` /
  `off_invoice_percentage` de hâlâ `numeric(5,2)` (Karar 5 bekliyor).

---

**#6 — `agreement.service.ts`, `calculateKpis` içinde `if (agreement.mechanicValue)`**

- **Canlı yol:** ✅ `calculateKpis` iki yerden çağrılıyor: agreement **create** sonrası ve
  `kpiAffectingFields` (`'mechanicValue'` dâhil) değiştiğinde **update** sonrası. Çıktısı
  `agreements.kpi_results` JSONB'sine **kalıcılaşıyor**.
- **Bugün:** `"0.0000"` truthy → `tacticsContext['MECHANIC_VAL']` **string** olarak
  `Record<string, number>`'a giriyor (tip yalanı; `formula-parser`'ın savunmacı `Number()`'ı
  kurtarıyor — `0014 §4.2` bunu zaten işaretlemişti).
- **Değişirse:** `0` falsy → anahtar **hiç girmez** → `MECHANIC_VAL`'e bağımlı bir formül
  `parseExpression`'ın bağımlılık döngüsünde `null` döner.
- **Görünürlük — iki ölçüm, ikisi de gerekli:**
  1. `grep -rn "MECHANIC_VAL"` → **yalnız bu iki satır.** Seed'deki hiçbir KPI ona bağımlı
     değil, hiçbir formül metninde geçmiyor. Yani **bugün seedli kurulumda etkisi sıfır.**
  2. ⚠️ **Ama bu "etki yok" demek değil** (§2.7 — sıfırın ikinci açıklaması): formüller
     **Admin-tanımlıdır** (CLAUDE.md §2.3). Bir tenant `MECHANIC_VAL` kullanan bir formül
     tanımlamışsa bu koda bakılarak **bilinemez**. Bu ölçüm ancak canlı `kpis` tablosuyla
     kapanır → §5.
- **Ayrıca:** `calculateKpis` SKU verisini **mock** ediyor (`BASE_VOL: 1000, PLAN_VOL: 1100`,
  yorumu: *"10% uplift assumption"*). Yani bu yoldan üretilen `kpi_results` zaten uydurma bir
  hacme dayanıyor. Frontend'de `kpiResults` yalnız `agreement.types.ts`'te **tip olarak**
  duruyor; render eden bileşen bulunamadı.
- 📌 **A4 ile çelişki:** ADR 0007 **A4** bu kolonu *"dondurulur, ölçek kontratına dahil
  edilmez"* diye kayda geçirdi ve kolona bir yorum yazılmasını şart koştu. Ölçüldü:
  `grep -rn "COMMENT ON COLUMN" src/database/migrations` → **yalnız migration 1796'nın üç
  satırı**; `agreements.mechanic_value` için ne DB yorumu ne TS yorumu var (entity satırı hâlâ
  yalnız `// e.g., 15.00 (TL per unit) or 10.5 (%)`). **A4'ün eylemi yapılmamış.**
  Dolayısıyla "bu kolon donduruldu" bilgisi bugün **hiçbir geliştiricinin göreceği yerde
  değil**, ve `POST /agreements` DTO'su (`create-agreement.dto.ts`, `mechanicValue?: number`)
  onu yazmaya açık.

---

**#7 — `plan.service.ts`, `updateSkuVolume` içinde `dto.plannedVolume && planSku.baseVolume`**

- **Canlı yol:** ✅ `PATCH /plans/:id/fus/:fuId/skus/:skuId/volume`
  (`plan.controller.ts`, `@Patch(':id/fus/:fuId/skus/:skuId/volume')`).
- **Sıfır erişilebilir mi:** ✅ evet — `update-sku-volume.dto.ts` her iki alanda `@Min(0)`
  kullanıyor, yani `0` **geçerli bir girdidir**.
- **Karışık nokta, ölçülerek ayrıldı:** ifade **iki farklı kaynağı** karşılaştırıyor —
  `dto.*` (JSON'dan gelen düz `number`, `0` bugün de falsy) ve `planSku.baseVolume` (entity,
  bugün string). Temsil kararı **yalnız ikincisini** etkiler: `baseVolume === 0` olan bir SKU
  için üçüncü dal bugün doğru sonucu (`dto.plannedVolume - 0`) veriyor, temsil değişirse
  **stale `planSku.incrementalVolume`'a düşüyor.**
- **Görünürlük:** ⚠️ **hayır — ve bunu iddia etmeden önce ölçtüm.** Hemen ardından
  `recalculatePlanWithKpiEngine` çalışıyor ve `incrementalVolume`'u
  `planVol - baseVol` olarak **yeniden yazıyor** (`plan.service.ts`, `const incrementalVolume =
  planVol - baseVol;` → `skuUpdatesForBatch.push({ ... incrementalVolume, ... })`), ve o yol
  `toNullableNumber` kullandığı için temsil-güvenli. Yani tutarsızlık **aynı istek içinde
  onarılıyor**; kalıcı hâle gelmesi yalnız recalc fırlatırsa mümkün.
- ⚠️ **Kardeş yol arandı (§7.1) ve iddiam düzeltildi.** `plan.repository.ts`'in `addSku`
  metodunda aynı desen var (`plannedVolume && baseVolume ? plannedVolume - baseVolume : 0`).
  İlk okumada canlı bir kusur sandım. Ölçüm aksini söyledi: tek üretim çağrısı
  (`plan.service.ts`, `this.planRepo.addSku(planFu.id, sku.id, tenantId, userId)`) hacim
  argümanlarını **hiç geçirmiyor**, yani her zaman `undefined` — sonuç `0` ve doğru. **Kusur
  değil.** (İkinci açıklamayı aramasaydım yanlış bir bulgu raporlayacaktım.)

### 1.6 §7.1 — sayım: yedi değil

`0014` yedi backend noktası saydı. Aynı sınıfı **her iki uçtan** ve **her iki repoda** arayınca:

| Bulunan | Yer |
|---|---|
| `0014`'ün yedi noktası | backend, hepsi yerinde |
| `plan.overallRoi \|\| 0` (**iki** kez) | `finance-reporting.service.ts` — `getPlanPerformance` ve `getBudgetAtRisk` içinde |
| `planFu.gpRoi ? Number(...) : null` | **frontend** `PlanningGridEnhanced.tsx` (canlı) ve `PlanningGrid.tsx` (ölü, T-118) |
| `overallRoi \|\| 0` · `gpRoi \|\| 0` · `baseVolume \|\| 0` · `unitPrice \|\| 0` | **frontend**, `PlanApprovalsPage.tsx` · `GrandTotals.tsx` · `PlanApprovalDetailModal.tsx` |
| `avgRoi ? ... : 'N/A'` | **frontend** `export.ts` (kullanıcı artefaktı, E18 → Alan A) |

⚠️ **`plan.overallRoi || 0` ters yönde çalışıyor ve bugün canlı bir BRD sorunu:**
`GET /finance-reporting/plan-performance` ve `.../budget-at-risk` yanıtlarında
`gpRoi: plan.overallRoi || 0` — yani **`null` (COGS eksik) sessizce `0` olarak raporlanıyor.**
Bu, `plan.entity.ts`'in T-027 yorumunun (*"missing data → null, never a fabricated 0"*)
raporlama katmanındaki ihlalidir ve **temsil kararından bağımsızdır.**

**Sonuç:** D-15'in kapsamı yalnız "yedi nokta" değil; en az **iki repo, iki yön** (sıfır→yok ve
yok→sıfır) ve bir **kullanıcı artefaktı**. Bir karar bunların hepsine aynı anda uygulanmalıdır,
yoksa yarısı düzeltilip yarısı kalır — `0014 §1.4`'ün T-026 vakasıyla aynı kalıp.

### 1.7 D-15 — seçenekler ve her birinin D-07'ye etkisi

⚠️ Bu bir öneri listesi değil. Ölçüm bir seçeneği **dışlıyorsa** öyle yazıldı; aksi hâlde
seçenekler eşit ağırlıkta sunulmuştur.

**Ö1 — "Tam sıfır ≡ KPI yok" (truthiness korunur, temsil değişince davranış değişir)**
- A ekseni: RED rozetli planlar rozetsiz kalır; `avgRoi` yukarı kayar; `PlanAnalysis`'in FU
  satırları `%0,0` yerine `N/A`.
- B ekseni: **sıfır tavan bağlayıcı olmaktan çıkar.** Bu, bir korumanın kaldırılmasıdır ve
  canlı `spend-validation` implementasyonuyla **çelişir**.
- **D-07 etkisi:** `INV-R-008` "aynı girdi → kuruşu kuruşuna aynı çıktı" der. Sıfırın
  yoklukla birleşmesi, `expected_i = 0` olan bir taktiğin dağıtım anahtarından **düşmesi**
  demektir — largest-remainder'ın (Karar 6) tie-break sırasını değiştirir. Yani D-07 bu
  seçenekte **dağıtım anahtarının sıfır elemanlarını açıkça tanımlamak zorundadır.**

**Ö2 — "Tam sıfır ≠ KPI yok" (her tüketici açık `!== null` kontrolüne çevrilir)**
- A ekseni: bugünkü RAG/`roiCount` davranışı **korunur**; üretici tarafın (T-027) semantiği
  tüketiciye taşınır.
- B ekseni: canlı `spend-validation` implementasyonu **zaten böyle**; `mechanic.service.ts`
  ona yakınsar.
- Bedeli: §1.6'daki **her** noktaya dokunulur (iki repo). `?` / `||` → `!= null` dönüşümü
  mekaniktir ama sayısı büyüktür ve tel-sözleşmesini `0014 §4.3`'ün tarif ettiği şekilde
  kırar.
- **D-07 etkisi:** `INV-R-007`'nin `expected_i / expected_total` oranı `expected_total === 0`
  hâlini **ayrıca** tanımlamak zorunda kalır (bugün `safeEval` onu `null` yapıyor; Alan A'da
  `null` değil **hata** olmalı — CLAUDE.md §2.5).

**Ö3 — Eksen bazında ayrı karar (A / B / C ayrı ayrı)**
- §1.4'ün ölçümü bu seçeneği **mümkün** kılıyor: üç eksen farklı kod bölgelerinde ve farklı
  iş sorularına cevap veriyor; birini karara bağlamak diğerini bloklamıyor.
- **D-07 etkisi:** yalnız A ekseni D-07 için **zorunlu** ön koşuldur (recognition ROI/oran
  taşır). B ve C, F4'ün kolon sırasına göre daha sonra kararlaştırılabilir.

**Ölçümün dışladığı:** *"D-15'i tek bir evet/hayır ile cevaplamak"* — §1.4'te ölçülen zıtlık
(B ekseni) bunu dışlıyor. Bir cevap, en az B'yi ayrı ele almak zorundadır.

**Karar için eksik olan bilgi:** §1.2'nin sonucu (sıfır ROI üretilebilir mi) **koddan
kanıtlandı**, ama **veride var mı** ölçülemedi (§5). Bu, kararın *aciliyetini* etkiler,
*yönünü* değil.

---

## 2. D-16 — Scale-3 hacim kolonları

### 2.1 (a) Tam liste — yeniden üretildi

Entity taramasıyla (§Ölçüm ortamı), transformer'sız `scale: 3` kolonlar. **Sekiz**, ve
`0014 §1.3` ile aynı sayı — ama liste `0014`'te yok, ilk kez burada:

| # | Tablo | Kolon | Tip | Transformer |
|---|---|---|---|---|
| 1 | `forecasting_units` | `default_base_volume` | `numeric(18,3)` | yok |
| 2 | `lta_rates` | `minimum_volume_commitment` | `numeric(18,3)` | yok |
| 3 | `on_invoice_entries` | `quantity` | `numeric(18,3)` | yok |
| 4 | `plans` | `total_planned_volume` | `numeric(18,3)` | yok |
| 5 | `plan_fus` | `total_planned_volume` | `numeric(18,3)` | yok |
| 6 | `plan_skus` | `base_volume` | `numeric(18,3)` | yok |
| 7 | `plan_skus` | `planned_volume` | `numeric(18,3)` | yok |
| 8 | `plan_skus` | `incremental_volume` | `numeric(18,3)` | yok |

Transformer'lı `scale: 3` kolon: **hiç yok.** Yani hacmin tamamı tek bir temsil altında.

**Aritmetik tüketicisi olmayanlar — ölçüldü (§7.1: "alan kullanılıyor" iddiası ölçülmeden
yazılamaz):**

| Kolon | Ölçülen tüketim |
|---|---|
| `forecasting_units.default_base_volume` | **hiçbir okuyucu yok.** Yalnız `create-fu.dto.ts`'te bir alan; `fu.service.ts` `...createFuDto` yaymasıyla **yazılıyor**, hiçbir hesap okumuyor. |
| `lta_rates.minimum_volume_commitment` | DTO'dan yazılıyor (`lta-agreement.service.ts` iki yerde), **hiçbir hesap okumuyor**. |
| `on_invoice_entries.quantity` | yalnız `Number(e.quantity)` ile **yankılanıyor** (response), ve parser'dan yazılıyor. **Hiçbir çarpım/karşılaştırmaya girmiyor.** |

Yani sekiz kolonun **üçü** bugün yalnızca depolanıyor. Bu, D-16'nın maliyet tahminini
değiştirir — ama aynı zamanda `on_invoice_entries.quantity` için §2.2'nin sorusunu doğurur.

### 2.2 ⚠️ (b) "Recognition hacim taşımıyor" — gerekçe **hangi tabloya** bakıldığına bağlı

`0013 §3.1`'in erteleme gerekçesi: *"D-07 (recognition) hacim taşımıyor, yani şimdilik
gerekmiyor."* Bu cümleyi bugünkü kodla ölçtüm ve **iki farklı cevap** çıktı.

**Kanıt 1 — `INV-R-007`'nin önerilen kuralında hacim YOK.** Kural:
`attributable = min(actual_discount, expected_total)`, `per tactic = attributable ×
(expected_i / expected_total)`. Üç terim de **tutar**. Doğru.

**Kanıt 2 — `sales_actuals` gerçekten hacim taşımıyor. Bugün de.**
`sales-actual.entity.ts` kolonları: `gross_amount`, `net_amount`, `discount_amount` (üçü de
`DecimalTransformer`'lı) + boyut/denormalize alanlar. Hacim/adet kolonu **yok**, ve entity
başlığı sebebini yazıyor: *"FU/SKU ve hacim boyutu YOKTUR — Wella actuals CSV'sinde `fu_code`/
`volume` kolonları bulunmuyor."* Tabloya dokunan migration **iki tane**
(`1785000000000-CreateSalesActualsTables`, `1793000000000-AddOptimisticLockVersions`) ve
ikincisi yalnız `version` ekliyor. Yani `0002`'nin ölçümü **bugün de geçerli**.

**Kanıt 3 — ama `on_invoice_entries` hacim VE fiyat taşıyor.**

```
on-invoice-entry.entity.ts
  quantity      numeric(18,3)     ← hacim
  list_price    numeric(18,4)     ← fiyat
  actual_price  numeric(18,4)     ← fiyat
  discount      numeric(18,2)     ← para
```

Ve bu tablo recognition'ın **öteki** girdisidir: `INV-R-001`/`INV-R-002` doğrudan onun
üzerine yazılmış, `actual_discount` oradan gelir.

**Sonuç — ve bu bir DUR:** `SYSTEM_INVARIANTS §9`'un D-06 satırı *"`LIST_PRICE × VOLUME` is
uncomputable **because actuals carry no volume**"* diyor. Bu cümle `sales_actuals` için doğru,
`on_invoice_entries` için **yanlış**: orada `quantity` ve `list_price` yan yana duruyor ve
çarpım hesaplanabilir. Eleme gerekçesi, **hangi tablonun "actuals" sayıldığı** sorusuna
bağlıdır ve o soru sorulmamıştır.

Ayrıca doğrulandı — bugün böyle bir çarpım **yok**: `settlementBase|settlement_base|LIST_PRICE`
araması yalnız CSV parser alias'larını ve kolon adlarını buluyor; `CTPM_BASELINE_AND_PORT_AUDIT.md`
de aynı sonucu bağımsız olarak kaydetmiş (*"no settlement-base concept"*).

> ⛔ **DUR.** D-16, D-06'nın *"settlement base `LIST_PRICE × VOLUME` olabilir mi?"* sorusundan
> önce cevaplanamaz. Cevap "evet"se hacim recognition'ın **çarpan** tarafına girer ve D-16 bir
> ölçek kararı olmaktan çıkıp **2⁵³ tavanı** sorusuna dönüşür (ADR 0007 E4/A9).

### 2.3 (c) Hacim bugün hangi çarpımlara giriyor — ve hangi ölçekte

Backend'de `hacim × fiyat` deseninin **her iki ucundan** araması (§7.1) — bugünkü tüm noktalar:

```
lta-calculation.service.ts        baseVolume * listPrice        ·  plannedVolume * listPrice
spend-calculation.service.ts      skuContext.plannedVolume * skuContext.listPrice   (üç ayrı metotta)
spend-calculation.service.ts      skuContext.baseVolume * skuContext.cogsPerUnit
spend-calculation.service.ts      skuContext.plannedVolume * skuContext.cogsPerUnit
spend-distribution.service.ts     plannedVolume * listPrice
spend-validation.service.ts       sum + volume * price
```

`0013 §3.1` bu tabloyu **beş satır** olarak yazmıştı; bugün aynı desen **on bir** satır veriyor.
Fark kodun büyümesinden mi arama şeklinden mi geliyor ayırt edilemedi — ama sayı yerine
niteliksel ifade doğru olan: **hacim×fiyat çarpımı `spend-calculation` üçlüsünün her
katmanında var ve tek bir noktada toplanmamış.**

**Ölçek zinciri, ölçülerek:**
`plan_skus.planned_volume` (`10³`) × `skus.unit_price` (`10⁴`) → ham çarpım **`10⁷`** ölçeğinde.
`0011 S3.2`'nin *"1e6 birim × 100,00 TRY → 2⁵³'ün %11'i"* ölçümü bu zincir için **hâlâ
geçerli** — zincir yerinde duruyor.

**Ve kritik olan: bu çarpım nereye gidiyor.** Canlı recalc yolu KPI motorundan geçiyor:

```
plan.service.ts, KPI context:      BPTT: unitPriceOrNull      COGS: cogsOrNull
                                   BASE_VOL: baseVolOrNull    PLAN_VOL: planVolOrNull
kpi.seed.ts formülleri:            PLANNED_GSV  = PLAN_VOL * BPTT
                                   PLANNED_COGS = PLAN_VOL * COGS
                                   PLANNED_GP   = PLANNED_TO - PLANNED_COGS
plan.service.ts kalıcılaştırma:    fuTotalGp += plannedGp   →  plan_fus.total_gp  numeric(18,2)
                                                            →  plans.total_gp     numeric(18,2)
```

⚠️ **Bu, ADR 0007 Karar 1'in bağlayıcı sınır kuralının ölçülmüş bir ihlalidir.**
Karar 1: *"`kpi-engine` (`safeEval` zinciri) Alan B'dir"* ve *"**Alan B'nin çıktısı para olarak
kalıcılaştırılamaz.**"* Ölçüm: `PLANNED_GP` `safeEval` çıktısıdır, para birimindedir ve
`total_gp numeric(18,2)`'ye yazılmaktadır. E10 `modes/planning-first/plan`'ı Alan A'ya aldığı
için bu, sınırın **iki tarafını da** ilgilendiriyor.
Bu bulgu D-16'nın konusu değil ama D-16 ve D-17 kararlarının ikisinin de **üzerine oturduğu**
zincirdir → ayrı task konusu (§4).

**Temsil-güvenli olan yol da ölçüldü** (§2.7 — hep kırmızı arama, yeşili de kaydet):
`computeLumpsumDistribution` hacmi `Number(ps.baseVolume) || 0` ile okuyor — hem string hem
number ile doğru çalışıyor, `0` da doğru sonucu (sıfır pay) veriyor. **Yani ADR 0006 Karar 2'nin
yaşadığı yol D-16'dan etkilenmiyor.**
📌 Ve orada bir okuma tuzağı düzeltilmeli: metodun kendi yorumu *"A SKU with **null/zero** base
volume gets ZERO share"* diyor — yani ADR 0006 Karar 2 `null` ile `0`'ı **ayırmıyor**, ikisini
de "pay yok" sayıyor. ADR 0008'in "farklı eksen" paragrafı bu yüzden doğru, ama gerekçesi
"null ≠ 0" değil "hacim yok ≠ niyet yok"tur.

### 2.4 D-16'nın kendi truthiness flip'i var — ve frontend'de

D-16 saf bir temsil sorusu değil; D-15'in mekanizmasını paylaşıyor:

```
collmind.frontend/.../ForecastingUnitManagementPage.tsx
  // Use defaultBaseVolume or unitPrice as volume indicator
  const skuVolume = sku.defaultBaseVolume || sku.unitPrice || 0;
```

Bir **hacim** alanı boşsa yerine bir **fiyat** konuyor. Bugün `defaultBaseVolume` string gelseydi
`"0.000"` truthy olurdu; temsil değişince `0` falsy olur ve fallback ateşler.

⚠️ **Ama ölçüm daha kötü bir şey söyledi:** `allSkus` `skuEndpoints.getAll()` → `/skus` →
`Sku` entity'sinden geliyor ve **`skus` tablosunda `default_base_volume` diye bir kolon yok**
(`sku.entity.ts`: `unit_price`, `cogs`, `unit_of_measure`, `is_active`, `gu_id`, `fu_id`).
`grep -rn "defaultBaseVolume" collmind.backend/src | grep -i sku` → **boş.**
Yani `sku.defaultBaseVolume` **her zaman `undefined`**, fallback **her zaman** ateşliyor:
FU düzenleme diyaloğunda gösterilen **"Toplam Hacim"**, seçili SKU'ların **birim fiyatlarının
toplamıdır.** (Render: `Toplam Hacim: {totalVolume.toFixed(2)}`.)

Bu bir D-16 kararı değil, bugünkü canlı bir yanlış sayı → §4.

📌 Ve bir guard-kapsam bulgusu: `ForecastingUnitManagementPage.tsx`, frontend
`money-float-domain-a.txt`'te **açıkça dışarıda** ve gerekçesi *"(SKU **volume**, not currency —
Grid rule: SKU carries Planned Volume, not price)"*. Ölçüm bu gerekçeyi çürütüyor: dosya
`sku.unitPrice`'ı okuyor ve `parseFloat`'tan geçiriyor. Bu, o listenin kendi kaydettiği
**eksik enumerasyon** sınıfının (KpiManagementPage vakası) üçüncü örneğidir.

### 2.5 (d) `0013 §3.1`'in "iki satırlık iş" iddiası — **çürüdü**

`0013 §3.1` şöyle diyordu: *"Eklenmesi (1)+(2) sayesinde **iki satırlık** iştir: `ScaleName`'e
`'volume'`, `SCALE_FACTOR`'a `volume: 1000`."*

Ölçüldü (`grep -rn "PriceMinor\|SCALE_FACTOR\|ScaleName\|VolumeMilli"`, iki repo + `docs/decisions`):

| `0013 §3.1` tasarımı | Bugün kodda |
|---|---|
| `export type ScaleName = 'money' \| 'price' \| 'rate'` | `export type Scale = 'money' \| 'rate'` — **`'price'` yok**, ad da farklı |
| `type Scaled<S extends ScaleName>` | `export type Branded<S extends Scale>` |
| `export type PriceMinor = Scaled<'price'>` | **YOK — hiçbir yerde** |
| `export const SCALE_FACTOR: Record<ScaleName, number>` | **YOK** — yerine üç ayrı sabit: `MONEY_SCALE`, `RATE_SCALE`, `RATE_PERCENT_SCALE` |
| `VolumeMilli` | yalnız `brands.ts`'te bir **yorum** ve ADR A7'de |

Yani "iki satır" iddiasının dayandığı **iki mekanizmanın ikisi de** (isim birliği + kayıt
tablosu) kodda başka türlü yazılmış. Bugün üçüncü bir marka eklemek: `Scale`'e üye + yeni bir
`*_SCALE` sabiti + o sabiti kullanan yardımcı(lar). **İki satır değil**, ama A7'nin asıl şartı
(*"genişletilemez marka mekanizması ve iki-marka varsayan yardımcı imzası yazılmaz"*)
`brands.ts`'in kendi belgelediği hâliyle **karşılanıyor**: `Branded<S>` jenerik ve kapalı birlik
imza yok.

⚠️ Ve `brands.ts`'in yorumu *"A third brand (VolumeMilli, deferred to D-07)"* diyor —
`PriceMinor` kararlaştırılmış olsaydı `VolumeMilli` **dördüncü** olurdu. Yorum, `PriceMinor`
kararının düştüğünü sessizce varsayıyor. Bu §3'ün konusu.

### 2.6 D-16 — seçenekler ve her birinin D-07'ye etkisi

**Ö1 — `VolumeMilli` ŞİMDİ markalanır**
- Sekiz kolonun altısı `plan*` ailesinde; `plan.service.ts` ve `spend-*` üçlüsü Alan A'da
  (E10) ve ratchet altında. Marka, `0013 §3.1`'in *"K9 onları dönüştürmeyi yasaklıyor"*
  gerekçesiyle çatışıyor — o gerekçe bugün de geçerli.
- **D-07 etkisi:** D-07 bugünkü `INV-R-007` kuralında hacim taşımıyor → **doğrudan fayda yok.**

**Ö2 — D-07 ile BİRLİKTE markalanır** (`0013`'ün ertelemesinin devamı)
- **Ön koşulu D-06'dır** (§2.2). `settlement_base` `LIST_PRICE × VOLUME` içerirse hacim
  recognition'ın çarpanıdır ve marka **zorunlu** olur; içermezse Ö3'e döner.
- **D-07 etkisi:** karar D-06'ya devredilir, yani D-16 **D-06'nın alt sorusu** hâline gelir.

**Ö3 — Hacim HİÇ markalanmaz (Alan A dışında kalır)**
- Bunu ölçüm **desteklemiyor da, dışlamıyor da**: hacim tek başına para değildir, ama
  `PLAN_VOL * BPTT` ile **para üretir** ve o para kalıcılaşır (§2.3). E10'un üyelik testi
  ("bir modül para üretiyorsa Alan A'dadır") **modüle** uygulanır, kolona değil — yani bu
  seçenek E10'la biçimsel olarak çelişmez, ama hacmi para üreten çarpımın korumasız ucu olarak
  bırakır.
- **D-07 etkisi:** yok — bugünkü `INV-R-007` amount-only.

**Ölçümün dışladığı:** *"D-16 D-07'den bağımsız olarak şimdi kapatılabilir"* — §2.2 bunu
dışlıyor, çünkü D-06 cevabı D-16'nın konusunu değiştiriyor.

**Karar için eksik olan bilgi:** **D-06.** Addendum V2 §5.2'nin üç settlement base tipinden
`LIST_PRICE × VOLUME` **hâlâ masada mı?** Bu bir BRD/ürün sorusudur ve koddan cevaplanamaz.

---

## 3. D-17 — `unitPrice` / `cogs` para mı fiyat mı?

### 3.1 ⚠️ Önce: `PriceMinor` kararı verilmiş ama uygulanmamış — ve ADR'de kayıtlı değil

`docs/analysis/0013 §3.1` şu cümleyi taşıyor:

> **Karar: `PriceMinor` markalanır, `VolumeMilli` markalanmaz — bu turda (A7).**
> `PriceMinor` **zorunlu**, çünkü `entered_unit_amount` bir fiyattır (§1.1/E3) ve `MoneyMinor`
> ile **karıştırılabilir** (ikisi de TRY görünümlü, ölçekleri 10² vs 10⁴).

Ölçüldü:
- `PriceMinor` **iki repoda ve `docs/decisions/` altında hiç geçmiyor.**
- ADR 0007'nin erratası `PriceMinor`'dan **hiç söz etmiyor**; yalnız A7 `VolumeMilli`'yi
  erteliyor. Yani karar **ADR'ye hiç taşınmadı**, bir tasarım dokümanında kaldı.
- `brands.ts` `Scale = 'money' | 'rate'` — iki marka.
- Ve corroborasyon: migration `1796000000000-SplitPlanMechanicEnteredValue.ts`'in üç kolon
  yorumundan ikisi çalışma-zamanı tipini adlandırıyor (*"Runtime type: RateMicro"*, *"Runtime
  type: MoneyMinor"*), **fiyat kolonununki adlandırmıyor**: *"TRY per unit (PER_UNIT_SUPPORT).
  Price scale, not money scale."* Yazacak bir tip adı yoktu.

> ⛔ **DUR (koşul 2).** D-17'yi "karar verilmemiş" diye sormak eksik. Doğru soru:
> **`PriceMinor` kararı bilinçli olarak mı düştü, yoksa ADR'ye taşınmadığı için mi kayboldu?**
> Cevap "düştü"yse D-17'nin seçenek kümesi daralır; "kayboldu"ysa D-17'nin bir kısmı **zaten
> kararlaştırılmıştır** ve yalnız uygulanmayı bekliyor.

Ve C3 muafiyeti **uygulanmış** durumda — markasız, ama gerekçesi kodda tam yazılı
(`src/common/numeric/mechanic-input.ts`, `checkEnteredScale` üstündeki blok):

> *"`unitAmount` IS DELIBERATELY EXEMPT FROM THE SUB-KURUŞ RULE, AND THAT EXEMPTION IS
> CORRECT. A per-unit amount is a PRICE, not a money total: a support of 0.0125 TRY/unit over
> 800 000 units is 10 000 TRY, an ordinary figure in this domain. … The kuruş rule belongs to
> the value that IS money (`totalAmount`), not to a rate that is multiplied into money later.
> Do not 'make the branches consistent'."*

**Bu gerekçe `skus.unit_price` ve `skus.cogs` için kelimesi kelimesine geçerlidir.** İkisi de
birim başına TRY'dir, ikisi de hacimle çarpılarak paraya dönüşür (§3.3).

### 3.2 (a) Bugünkü ölçek — entity bildirimi

| Kolon | Tip | Transformer | Bugünkü tüketim |
|---|---|---|---|
| `skus.unit_price` | `numeric(18,4)` | yok | **canlı, çarpımda** (§3.3) |
| `skus.cogs` | `numeric(18,4)` | yok | **canlı, çarpımda** (§3.3) |
| `forecasting_units.base_price` | `numeric(18,4)` | yok | ⚠️ **yazılıyor, hiç okunmuyor** |
| `on_invoice_entries.list_price` | `numeric(18,4)` | yok | yalnız yankı (`Number(e.listPrice)`) + doğrulama (`<= 0` reddi) |
| `on_invoice_entries.actual_price` | `numeric(18,4)` | yok | yalnız yankı + doğrulama (`< 0` reddi) |
| *(karar verilmiş)* `plan_mechanic_values.entered_unit_amount` | `numeric(18,4)` | yok | C3 muafiyeti uygulanmış |

`0011 S3.3`'ün **beş "saf fiyat" kolonu** sayımı bugün de **beş** — ama listedeki tüketim
profilleri birbirinden çok farklı, ve `0011` bunu ayırmamıştı.

⚠️ `forecasting_units.base_price` — `create-fu.dto.ts`'te bir alan, `fu.service.ts`'in
`this.fuRepository.create({ ...createFuDto, ... })` yaymasıyla `POST /forecasting-units`
üzerinden **kalıcılaşıyor**, ve hiçbir hesap onu okumuyor. §7.1'in T-079 vakasıyla aynı sınıf:
"alan kullanılıyor" iddiası ölçülmeden yazılamaz — burada ölçüldü, **sıfır okuyucu**.

**DB doğrulaması yapılamadı** (§5). Entity bildirimi + migration DDL'i tek kaynak.

### 3.3 (b) Hangi hesaplara giriyorlar — `cogs` dâhil, ayrı ölçüldü

`unitPrice` ve `cogs`'un canlı zinciri (`plan.service.ts`, `recalculatePlanWithKpiEngine`):

```
sku.unitPrice  → toNullableNumber → unitPriceOrNull → SKUContext.listPrice   → KPI ctx BPTT
sku.cogs       → toNullableNumber → cogsOrNull      → SKUContext.cogsPerUnit → KPI ctx COGS
```

İki tüketim yolu var ve **ikisi de canlı**:

1. **`spend-calculation.service.ts`, `calculateCompleteSKUFinancialMetrics`** —
   `baseGsv = baseVolume * listPrice`, `plannedCogs = plannedVolume * cogsPerUnit`,
   `profit.plannedGp = plannedTo - plannedCogs`.
2. **KPI motoru (kanonik yol)** — `kpi.seed.ts`: `PLANNED_GSV = PLAN_VOL * BPTT`,
   `PLANNED_COGS = PLAN_VOL * COGS`, `PLANNED_GP = PLANNED_TO - PLANNED_COGS`,
   `INCR_GP = PLANNED_GP - BASE_GP`, `GP_ROI_PCT = INCR_GP / INCR_SPEND * 100`.

**`cogs` sorusuna net cevap:** ölü değil. Bir **kâr hesabına** giriyor (`PLANNED_COGS` →
`PLANNED_GP`), ve o kâr **paraya dönüşüp kalıcılaşıyor** (`plan_fus.total_gp`,
`plans.total_gp` — `numeric(18,2)`), oradan `GP_ROI_PCT` ve RAG'ı belirliyor.

**`plannedVolume × unitPrice → 10⁷` zinciri hâlâ orada** — `0011 S3.2`'nin ölçtüğü zincirin
her halkası yerinde (§2.3'teki on bir çarpım noktası).

📌 Ve `null` semantiği burada özenle korunmuş: `unitPriceOrNull`/`cogsOrNull` KPI context'ine
**nullable** gidiyor, yorumu açık: *"missing COGS/BPTT/volume propagates as null through
PLANNED_GP/GP_ROI_PCT/RAG (BRD: missing data → null, never a fabricated 100%/GREEN result)."*
Yani D-15'in A ekseniyle D-17 **aynı zincirde buluşuyor**: `cogs` yoksa ROI `null`; `cogs`
sıfırsa ROI hesaplanır. İki karar bu noktada birbirine bağlıdır.

⚠️ **Sıfır fiyat/COGS yazma ucundan reddediliyor** (ölçüldü, `SkuManagementPage.tsx`):
`if (!formData.unitPrice || isNaN(unitPrice) || unitPrice <= 0)` ve aynısı `cogs` için —
yani UI'dan `0` **giremiyor**. Bu, D-15'in bu iki kolon üzerindeki etkisini bugünlük daraltıyor;
ama bir API çağrısı ya da seed aynı kapıdan geçmiyor (`agreement.seed.ts` `cogsFixtureSku.cogs
= 60` atıyor).

### 3.4 (c) Frontend — `0011 S2.3` bugün de geçerli, ve **büyümüş**

`0011 S2.3` `PlanningGridEnhanced.tsx`'in istemcide NIV/Turnover türettiğini ölçmüştü. Bugün:

- `(planSku.plannedVolume ?? 0) * (sku?.unitPrice ?? 0)` kalıbı — **26 kez** aynı dosyada
  (`sku?.cogs` dâhil).
- Türetilen metrikler yalnız NIV/TO değil: `BASE_GSV`, `PLAN_GSV`, `INCR_GSV`, `BASE_NIV`,
  `PLAN_NIV`, `INCR_NIV`, `BASE_TO`, `PLAN_TO`, `INCR_TO`, `BASE_COGS`, `PLAN_COGS`,
  `BASE_GP`, `PLAN_GP`, `INCR_GP`, `BASE_GM_PCT`, `PLAN_GM_PCT`, `INCR_GM_PCT`, `GP_ROI_PCT`,
  `TO_ROI_PCT` … yani **backend'in KPI motorunun ürettiği hemen her şeyin istemci kopyası.**
- `PlanApprovalDetailModal.tsx` de aynı şeyi yapıyor (`skuBaseVolume`, `plannedVolume`,
  `skuPrice` hepsi `|| 0` ile).

**E17/E18 kapsamı:** ✅ `src/components/features/plans` frontend `money-float-domain-a.txt`'te
**var** — yani dosya Alan A'da, T-111 bunu kapatmış.

⚠️ **Ama üyelik ≠ kapsama.** Guard'ı rapor modunda koşturdum (`EXIT=0`):
`PlanningGridEnhanced.tsx`'in tabandaki bulgusu **tek** ve o da §1.5'teki D-15 ikizi
(`planFu.gpRoi ? Number(...) : null`). **26 hacim×fiyat çarpımının hiçbiri sayılmıyor**, çünkü
dedektör float **primitiflerini** (`parseFloat`/`Number(`/`toFixed`/`Math.round`) arıyor;
`??  0` çökertmesi ve `*` operatörü onun görüş alanında değil. Dosya listede, hazine dışarıda.

Ve BRD boyutu: bu, CLAUDE.md §2.3'ün *"Hesaplamalar asla hardcode edilmez. Frontend sadece
sonucu render eder"* kuralıyla çelişiyor. `0011 S2.3` bunu *"ayrı task konusu"* diye
işaretlemişti; bugün hâlâ açık ve **büyümüş**.

### 3.5 D-17 — seçenekler ve her birinin D-07'ye / F4'e etkisi

**Ö1 — `PriceMinor` (×10⁴, markalı) — yani `0013 §3.1` kararının uygulanması**
- C3'ün zaten uyguladığı ayrımı `skus.unit_price`/`cogs`'a genişletir; gerekçe metni
  `mechanic-input.ts`'te hazır.
- Bedeli: marka mekanizmasına üçüncü bir üye (§2.5'te ölçüldü — "iki satır" değil), ve
  `SKUContext.listPrice`/`cogsPerUnit` alanlarının `number` olmaktan çıkması, ki bu
  `spend-calculation` üçlüsünü (K9 ile korunan, ratchet altındaki dosyalar) etkiler.
- **D-07 etkisi:** D-06 `LIST_PRICE × VOLUME` derse **doğrudan gerekli** olur. Demezse D-07'ye
  etkisi yok, F4'e etkisi var.
- **F4 kolon sırası:** `plan.entity.ts` (23 kolon, üç ölçek) F4'ün **en sonuna** konmuştu
  (`0014 §5.3`) çünkü üç cevaba da bağımlı. Ö1, `skus` tablosunu F4'e **ayrı ve erken** bir adım
  olarak sokar — `skus` yalnız iki numeric kolon taşır ve ikisi de aynı ölçekte, yani
  `0014 §5.3`'ün "tablo tablo" kuralına en uygun aday.

**Ö2 — `MoneyMinor` (kuruş)**
- ⚠️ **Veri kaybı riski ölçüldü ve gerçektir:** `numeric(18,4)` → kuruş, 4 ondalıktan 2'ye
  iner. `mechanic-input.ts`'in yazılı örneği tam bu vakayı sayıyor: *"0,0125 TRY/birim × 800.000
  birim = 10.000 TRY … 0,0125'i 0,01'e yuvarlamak sonuç harcamada **%20 hata**."*
  Aynı aritmetik `cogs` ve `unit_price` için de geçerli.
- Kodda bu seçeneği yasaklayan **açık bir talimat** var: *"Do not 'make the branches
  consistent'."* Yani Ö2, kodda gerekçesiyle birlikte reddedilmiş bir hamlenin başka bir kolona
  uygulanmasıdır.
- **Ölçümün dışladığı:** Ö2, C3'ün gerekçesiyle **doğrudan çelişir.** Seçilecekse C3
  muafiyetinin de geri alınması gerekir — ikisi bir arada tutarsızdır.

**Ö3 — `numeric` kalır (temsil kararı verilmez)**
- Bugünkü hâl. Bedeli: `unit_price`/`cogs` `plan.entity.ts` ile aynı okuyucular tarafından
  okunuyor (§3.3), yani F4'ün `plan` adımında bu iki kolon **karar verilmemiş** hâlde
  karşılaşılır — `0014 §5.3`'ün *"yarısı `MoneyMinor` yarısı `string` olan bir tablo, T-091'in
  düzelttiği asimetrinin aynısını üretir"* uyarısının tam vakası.
- **D-07 etkisi:** yok. **F4 etkisi:** F4'ün `plan` adımı **bloke kalır**.

**Ö4 — Kolon bazında ayrı karar** (§3.2'nin tüketim profilleri farklı olduğu için mümkün)
- `skus.unit_price` + `skus.cogs` → canlı çarpımda, karar **gerekli**.
- `on_invoice_entries.list_price` / `actual_price` → bugün yalnız yankı; kararları D-06'ya
  bağlanabilir.
- `forecasting_units.base_price` → **sıfır okuyucu**; A4'ün `agreements.mechanic_value` için
  verdiği "dondur + kolona yorum yaz" kararının aynısı uygulanabilir.
- **F4 etkisi:** F4'ün ilk adımlarını (`budget_transaction_logs`, `agreements`) hiç
  bloklamaz; yalnız `skus`/`plan` adımlarını bağlar.

**Karar için eksik olan bilgi:** §3.1'in DUR sorusu — `PriceMinor` düştü mü, kayboldu mu.

---

## 4. Kapsam dışı ama ölçüldü — ayrı task adayları

Bu turda üç kararı ölçerken bulunan, **bu kararlardan bağımsız** ve bugünkü kodda canlı olan
bulgular. Hiçbiri bu dokümanda düzeltilmedi; kaydedildi (CLAUDE.md: *"bilinen eksiklik TODO ile
değil, TASK ile kaydedilir"*).

| # | Bulgu | Ölçüm referansı | Neden ayrı |
|---|---|---|---|
| **B1** | **"Toplam Hacim" aslında birim fiyat toplamı.** `sku.defaultBaseVolume` `skus` tablosunda **yok** → `\|\| sku.unitPrice` fallback'i **her zaman** ateşliyor. | `ForecastingUnitManagementPage.tsx`, `// Use defaultBaseVolume or unitPrice as volume indicator` satırı + `sku.entity.ts`'te kolonun yokluğu | Temsil kararından bağımsız, bugün yanlış sayı gösteriyor |
| **B2** | **Onay ekranında "Ortalama ROI" `NaN%`.** `plans.reduce((sum,p) => sum + (p.overallRoi \|\| 0), 0) / plans.length` — `overallRoi` transformer'sız kolondan **string** geliyor, `+` birleştiriyor. İzole koşumla doğrulandı (`EXIT=0`): 1 plan → `12.5%`; **2 plan → `NaN%`**. | `PlanApprovalsPage.tsx`, `const avgRoi =` bloğu; veri kaynağı `GET /plans/pending-approvals` → `PlanRepository#findAll` → `.getMany()` (ham entity) | Temsil kararı bunu *çözer*, ama karar beklenmeden de düzeltilebilir |
| **B3** | **`null` ROI raporda `0` olarak gidiyor.** `gpRoi: plan.overallRoi \|\| 0`, iki canlı rotada (`/finance-reporting/plan-performance`, `/finance-reporting/budget-at-risk`). `plan.entity.ts`'in T-027 yorumunun (*"never a fabricated 0"*) doğrudan ihlali. | `finance-reporting.service.ts`, `gpRoi: plan.overallRoi \|\| 0` (iki geçiş) | §2.5 sessiz sıfır; D-15 hangi yöne karar verilirse verilsin kalır |
| **B4** | **`PlanAnalysis` `null` ROI'yi `%0.0` basıyor.** `currentRoi !== null ? formatPercentage(...) : '%0.0'` — B3'ün frontend ikizi. | `PlanAnalysis.tsx`, `'%0.0'` literali | aynı |
| **B5** | **Alan B çıktısı para olarak kalıcılaşıyor.** `PLANNED_GP` (`safeEval`, `kpi-engine` = Alan B) → `plan_fus.total_gp` / `plans.total_gp` (`numeric(18,2)`). ADR 0007 **Karar 1**'in bağlayıcı sınır kuralının ihlali. | `plan.service.ts`, `fuTotalGp += plannedGp ?? 0` → `totalGp: fuTotalGp`; formül `kpi.seed.ts`, `PLANNED_TO - PLANNED_COGS` | Mimari sınır sorusu; F4'ten büyük |
| **B6** | **Aynı iş kuralının iki zıt implementasyonu.** Per-mekanik max combined discount: `spend-validation.service.ts` (canlı, `!== null` → 0 bağlayıcı) vs `mechanic.service.ts` (UI tüketicisi yok, `\|\| 100` → 0 tavansız). | §1.4 tablosu | §7 tekrar; D-15'in B ekseninin ön koşulu |
| **B7** | **ADR 0007'nin uygulanmamış üç maddesi.** **A4**: `agreements.mechanic_value` kolon yorumu yazılmadı (repoda `COMMENT ON COLUMN` yalnız migration 1796'da). **E8**: `mechanics.max_combined_discount_percentage` hâlâ `numeric(5,2)`. **Karar 5**: `lta_rates.on_invoice_percentage`/`off_invoice_percentage` hâlâ `numeric(5,2)`. | entity bildirimleri + migration taraması | ADR'nin kaydettiği iş yapılmamış |
| **B8** | **Guard listesi gerekçesi ölçümle çelişiyor.** `ForecastingUnitManagementPage.tsx` frontend Domain A listesinden *"SKU volume, not currency"* gerekçesiyle dışlanmış; dosya `sku.unitPrice`'ı `parseFloat`'tan geçiriyor. Listenin kendi kaydettiği **eksik enumerasyon** sınıfı. | `money-float-domain-a.txt` gerekçe bloğu + B1'in satırı | Guard kapsamı |
| **B9** | **Frontend hacim×fiyat çarpımları guard'ın görüş alanı dışında.** Dosya Alan A'da (E17), taban bulgusu **tek** (`Number(planFu.gpRoi)`); 26 `?? 0` + `*` çarpımı sayılmıyor. Üyelik ≠ kapsama. | rapor-modu guard koşumu (`EXIT=0`) + `grep -c` | Dedektör şekli sorusu |
| **B10** | **`GET /plans/approval-queue` ve `POST /mechanics/check-combination` — rota var, UI tüketicisi yok.** | `grep -rn "approval-queue" collmind.frontend/src` → **EXIT=1** | CLAUDE.md §4.2 `blocked-unreachable`; ölü rota mı, yarım yol mu? |

---

## 5. Ölçülemeyenler

Açıkça listeleniyor — hiçbiri tahminle doldurulmadı (CLAUDE.md §2.4).

| # | Ölçülemeyen | Neden | Ne gerekli |
|---|---|---|---|
| **Ö1** | **Canlı verinin tamamı.** `gp_roi`/`overall_roi` içinde gerçekten `0` var mı · `mechanics.max_combined_discount_percentage` hiç `0` mı · `agreements.mechanic_value` bugün de 3/3 NULL mu (A4 o ölçümü 2026-08-04'te yapmıştı) · `plan_skus.base_volume` hiç `0` mı · `on_invoice_entries` kaç satır | **Docker daemon kapalı** (`unix:///Users/sertact/.docker/run/docker.sock` yok), port 5434 kapalı (`nc -z` → EXIT=1), `psql` PATH'te yok | Docker + `collmind-tpm-postgres` ayağa kalkmalı; sonra şema-nitelendirilmiş sorgular (`table_schema='main'`) |
| **Ö2** | **DB'deki gerçek kolon tipleri.** §2.1/§3.2'nin tüm tip iddiaları **entity bildirimi + migration DDL** üzerinden kuruldu, `information_schema` ile doğrulanmadı | Ö1 ile aynı | `information_schema.columns WHERE table_schema='main'` — ve `INV-M-001` ölçüldüğü için bu **boş bir doğrulama değil**: bu ortamda "migration kayıtlı ama DDL `main`'e inmemiş" vakası **yaşandı** |
| **Ö3** | **Tenant-tanımlı KPI formülleri `MECHANIC_VAL` kullanıyor mu** (§1.5 #6) | `kpis` tablosu okunamadı; formüller **Admin-tanımlıdır**, koddan bilinemez (CLAUDE.md §2.3) | `SELECT kpi_code, formula_text FROM main.kpis WHERE formula_text LIKE '%MECHANIC_VAL%'` |
| **Ö4** | **Transformer'ın recalc süresine etkisi (NFR-1.2, <500ms).** `0014 §6` de ölçmemişti; bu tur da ölçmedi | ayrı bir performans harness'ı gerekir; salt-okunur turun kapsamı dışı | F4'ün kabul ölçütüne madde — **varsayılmamalı** |
| **Ö5** | **D-06'nın durumu.** `LIST_PRICE × VOLUME` settlement base seçeneği hâlâ masada mı | Addendum V2 §5.2 bu repoda **yok**; `.cursor/` altındaki BRD PDF'i settlement base'i içermiyor (`settlement` kelimesi `rules.md`'de hiç geçmiyor) | Ürün sahibi kararı — **D-16'nın ön koşulu** (§2.2) |
| **Ö6** | **`PriceMinor` kararının akıbeti.** Bilinçli mi düştü, ADR'ye taşınmadığı için mi kayboldu | Kayıt yok: `0013 §3.1`'de karar var, ADR 0007 erratasında **hiç yok**, kodda **hiç yok** | Ürün sahibi kararı — **D-17'nin ön koşulu** (§3.1) |
| **Ö7** | **TTM'de karşılık gelen mekanizmalar.** `0014` de bunu eksik bırakmıştı ve kaydetmişti | Bu tur da **aranmadı** — kapsam CTPM idi | ⚠️ CLAUDE.md çapraz-repo uyarısı: aynı kavram farklı adlanabilir (`capTotalAmount` ↔ `capAmount`); "bulunamadı" ≠ "yok" |
| **Ö8** | **`.spec.ts` / `.test.tsx` dosyalarındaki aynı kalıplar** | üretim yolu yok; `0014` ile aynı gerekçeyle kapsam dışı | — |

---

## 6. Özet — üç karar, üç ön koşul

| Karar | Bugünkü davranış (ölçülmüş) | Cevaplanmadan karara bağlanamaz |
|---|---|---|
| **D-15** | Üretici taraf `0` ile `null`'ı **ayırıyor** (T-027, RAG: `0`→RED, `null`→rozetsiz); tüketici taraf **ayırmıyor**, ve iki zıt yönde birden (`?` ile `\|\| 0`), iki repoda | **D-15 tek karar değil** — A (KPI) / B (kural tavanı, **zıt**) / C (formül girdisi) eksenleri ayrı sorulmalı; B'nin ön koşulu §7 çelişkisi (B6) |
| **D-16** | Sekiz `numeric(x,3)` kolon, transformer'ı olan yok; üçünün hiç okuyucusu yok; hacim `spend-calculation`'ın her katmanında fiyatla çarpılıyor (`10⁷`); `sales_actuals` hacim taşımıyor ama `on_invoice_entries` **taşıyor** | **D-06** — `LIST_PRICE × VOLUME` settlement base hâlâ masada mı? |
| **D-17** | `unit_price`/`cogs` `numeric(18,4)`, transformer yok, **canlı çarpımda**, ürettikleri kâr `numeric(18,2)`'ye kalıcılaşıyor; aynı ayrımın kardeşi (`entered_unit_amount`) C3'te **uygulanmış**; `PriceMinor` kararı verilmiş ama **kodda ve ADR'de yok** | **`PriceMinor`** — bilinçli mi düştü, kayıp mı? |

**F4 üzerindeki etkisi:** üç karar F4'ün **tamamını** bloklamıyor. `0014 §5.3`'ün tablo sırası
(`budget_transaction_logs` → `agreements` → `plan_mechanic_values` → `plan`) alındığında ilk
iki adım **scale-2 para kolonları** taşıyor ve üç karardan hiçbirine bağımlı değil.
`plan_mechanic_values` C3/E13 ile zaten bölünmüş. **Yalnız son adım (`plan`, 23 kolon, üç
ölçek) üç cevaba da bağımlıdır** — `0014` bunu zaten en sona koymuştu.

Yani üç karar **F4'ün başlamasını** değil, **F4'ün bitmesini** blokluyor.
