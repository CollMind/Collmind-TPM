# `DALGA 0` — KUYRUK MUTABAKATI

> **Tarih:** 2026-08-31 · **Statü:** ölçüm + muhasebe · **kod/test/guard KOŞULMADI**
> **Yetki:** `Z75 §6` (`K6` — `DALGA 0` ∥ `ŞERİT A'` onaylı) · **Girdi:** `KUYRUK_TRIYAJI.md` ·
> `FAZ2_IKINCI_YARI_PLANLAMA_MASASI.md` · `Z73`–`Z75`
> **Yazma kapsamı:** `.claude/backlog/**` + `docs/process/**` — `src`'e **tek bayt yazılmadı**.

---

## `§0` · ÖLÇÜM TABANI — tur ÖNCESİ ↔ tur SONRASI

```
                 ÖNCE                        SONRA
task dosyası     358                         359      (+1: T-346 AÇILDI)
done              99                         107      (+8)
review            65                          70      (+5)
todo             179                         167      (-12)
in-progress        8                           8
blocked            5                           5
blocked-unreach.   2                           2
```

**Ortam:** hayalet `tpm` compose projesi **boş** (`docker ps --filter
"label=com.docker.compose.project=tpm"` → 0 satır). Canlı DB `main` şemasından okundu.
**Submodule pointer'ları:** `collmind.backend 9bf9c49` · `collmind.frontend 280035d` —
meta `HEAD`'in `ls-tree`'siyle **eşleşiyor** (yani aşağıdaki her `git log` ölçümü
**çalışan ağaçtaki** kodu tarif ediyor).

---

## `§1` · ⭐ `review` LİMBOSU ÖLÇÜLDÜ — **65/65**

> `KUYRUK_TRIYAJI §8-6`: *"`review` = inmiş"* genellemesi **üç vakadan** kuruldu ⇒ `62`'si
> doğrulanmadı. **Bu dalganın varlık gerekçesi buydu.**

### `1a` · ÖLÇÜM YÖNTEMİ — ve BİR EKSENİN ÇÜRÜTÜLMESİ

Üç eksen denendi. **İkincisi ÇÜRÜDÜ ve kayda geçiyor:**

| # | eksen | sonuç |
|---|---|---|
| 1 | `touches:` yolları **var mı**, task açıldığından beri **değişti mi** | kullanışlı, ama ad değişimlerinde yanılıyor (`T-096`) |
| 2 | **commit mesajında** `T-XXX` geçen, `src/` dokunan commit | ⛔ **YANLIŞ NEGATİF ÜRETTİ** — aşağı bkz. |
| 3 | **kod/DB/artefakt içinde** `T-XXX` işareti + üretim çağrı yolu | **taşıyıcı eksen** |

#### ⛔ `2`. EKSENİN ÇÜRÜMESİ — `T-318` vakası

```
git log --grep="T-318" --name-only  →  src/ dokunan commit  0
"ÖLÇÜLDÜ: inmemiş"  DENECEKTİ
```
Gerçek: `budget-tier-notification.service.ts` **canlı**, `createNotification`'ı **dört yerde**
çağırıyor, ve **enjeksiyon değil ÇAĞRI** ile bağlı:
```
budget.service.ts:120            evaluateAndNotify
budget-reservation.service.ts:324 evaluateAndNotify
budget.service.ts:510 · :668 · :882  assertNotBlocked
```
> ### **BİR COMMIT MESAJI DA BİR NİYET BEYANIDIR.**
> `@deprecated` ailesinin yeni üyesi: iş **inmiş**, commit mesajı onu **adlandırmamış**.
> Bu eksenle raporlansaydı, **çalışan bir mekanizma "yok" ilan edilecekti** — ve
> `T-273`'ün simetriği: *"kusur var"* demek de bir iddiadır.

⚠️ Ve bu eksenle üretilen `0`, kendi başına **pozitif kontrolsüzdü**. Pozitif kontrol
(eksen 3) uygulandığı an çürüdü.

### `1b` · SONUÇ — **inmiş / inmemiş / ölçemedim**

```
İNMEMİŞ                                    0
İNMİŞ  (kod/DB/artefakt düzeyinde)        65     ← 65/65, İSTİSNASIZ
  ├─ 1. DERECE (davranış/DB/artefakt bu turda BİRİNCİ ELDEN ölçüldü)   27
  └─ 2. DERECE (üretim kodunda T-XXX işareti VAR, iddianın TAMAMI
                davranışsal olarak sınanmadı)                          38
```

⛔ **`38`'i `§6 ÖLÇEMEDİM`'e de yazıldı** — *"kod düzeyi kapanış, davranışsal kanıt değildir"*
(`§2.7`). **İkinci derece bir kanıt, bir kanıttır ama BİRİNCİSİ DEĞİLDİR.**

> **Genelleme AYAKTA KALDI** — ama artık *"üç vakadan"* değil, **65 kalemin 65'inde ölçülmüş
> bir artefakttan** duruyor. `KUYRUK_TRIYAJI §8-6` borcu **KAPANDI**.

### `1c` · BİRİNCİ ELDEN ÖLÇÜLEN 27 KALEM — kanıt satırlarıyla

| id | kanıt (bu turda üretildi) |
|---|---|
| `T-079` | `add-fu.dto.ts:10` — *"`tactics` REMOVED"*; alan yok |
| `T-080` | `plan.service.ts:689` — *"MERGE, not replace"* |
| `T-085` | `common/numeric/mechanic-input.ts:110` + `spend-validation.service.ts:118`/`:157` |
| `T-086` | `money-float.sh:108-112` — muafiyet **DOSYA bazlı** (`exactness-primitives.txt`) |
| `T-089` | `spend-validation.service.ts:202`/`:289` — birleşik-indirim tavanı sayısal |
| `T-092` | `package.json:45` `"lint:check": "eslint \"{src,apps,libs,test}/**/*.ts\""` |
| `T-095` | canlı index `IDX_BUDGET_TRANSACTIONS_TENANT_IDEMPOTENCY` UNIQUE `(tenant_id, idempotency_key)` ⚠️ bkz. `§6-3` |
| `T-096` | tablo **yeniden adlandı**: `main.budget_transactions` · **6 satır** ⇒ yazma yolu **canlı** (kusur `HİÇ YAZILAMIYOR` idi) |
| `T-098` | `dashboard.service.ts:134` — *"failure is reported as a status, not smuggled out as `null`"*; `:177` `diagnosticsOf` |
| `T-105` | `src/common/numeric/numeric-text.ts` + `numeric.property.spec.ts` **var** ⇒ `T-099`'un kilidi **bayat** (`§3`) |
| `T-107` | `file-parser.service.spec.ts:608+` — `raw: true` + `pickCell` public yüzeyden |
| `T-132` | çıktı **teslim**: `docs/analysis/0016-numeric-contract-open-decisions.md` (62 KB) |
| `T-163` | migration `1801000000000-FixGpRoiPctDenominator.ts` **var**; ⚠️ canlı formül bugün `INCR_GP / INCR_PROMO_SPEND * 100` — `Z66` ile **üstüne yazılmış** (`§6-2`) |
| `T-171` | `GrandTotals.tsx:5` import + `:144` `useTargetRoiThreshold()`; `:136` `F12` izi |
| `T-186` · `T-215` | `rg "\|\| 'GREEN'"` → **0**; poz. kontrol `coverageRatio` **6 satır** ⇒ tarama kör değil |
| `T-188` | canlı `main.ledger_entries`: **3 satır**, `budget_envelope_id IS NULL` → **0** |
| `T-212` · `T-250` · `T-252` · `T-266` · `T-267` · `T-314` | `scripts/guards/` altında `lint-ratchet-baseline.txt` · `roles-baseline.txt` · `route-scope-baseline.txt` · `app-runtime-grants.sh` · `app-operator-grants.sh` (+ self-test'leri) **var** |
| `T-214` | canlı `main.approval_policies` kolonları: `template` **ve** `tier_roles` ⇒ katalog/tenant ayrımı inmiş |
| `T-249` | `app_runtime` `main` şemasında **40 tabloda** grant taşıyor |
| `T-255` · `T-258` | `user.controller.ts:201` · `tenant.controller.ts:60` — kimlik materyali sızıntısının kapatıldığı **yazılı** |
| `T-256` · `T-257` | `approval.controller.ts:62` `my-requests` · `current-user.decorator.ts:46-48` düzeltme izi |
| `T-260` | `app.module.ts:95` `useClass: ClassSerializerInterceptor` **kayıtlı** |
| `T-275` | `notification.controller.ts:35-52` — sahiplik şartı **kardeş uçlarla aynı** |
| `T-283` | çıktı teslim: `docs/process/B3A_EK3_ROTA_HUCRE_ESLEMESI.tsv` + üreteci `scripts/analysis/route-cell-map.py` |
| `T-306` | `finance-reporting.service.ts:204-217` — `cplId` **bilerek** filtre boyutu değil |
| `T-316` | canlı `main.budget_policies` **1 satır** (seed inmiş) |
| `T-317` | migration `1816000000000-AddBudgetFinanceReviewNotificationTypeAndEnvelopeTier.ts` |
| `T-318` | yukarıda — `§1a` |
| `T-340` | çıktı teslim: `docs/research/KPI_EVRENI_TURETILMIS_LISTE.md` |
| `T-345` | çıktı teslim: `docs/research/TTM_ELIGIBILITY_ENVANTERI.md` (444 satır) — `Z74`'ün **girdisi** |

### `1d` · İKİNCİ DERECE — 38 kalem

`T-083a` `T-109` `T-110` `T-111` `T-112` `T-121` `T-123` `T-126` `T-179` `T-182` `T-224`
`T-225` `T-242a` `T-254` `T-269` `T-270` `T-272` `T-273` `T-294` `T-296` `T-319` `T-321`
`T-322` `T-323` `T-324` `T-328` `T-329` `T-330` `T-331` `T-332` `T-334` `T-342` `T-343`
`T-344` + `1c`'de kod-düzeyi kalan dördü (`T-186` `T-215` `T-306` + `T-095`).

**Ölçüm:** her birinin **üretim kodunda** `T-XXX` işaretli satır(lar)ı var
(`rg -c` ile sayıldı, BE + FE + `scripts`). **En düşük** üç: `T-092`(1) `T-283`(1)
`T-323`(1) — üçü de ayrıca **birinci elden** doğrulandı, yani düşük sayı *"yok"* demek değil.
**Sıfır olan tek iki kalem** `T-132` ve `T-340` — ikisi de **doküman teslimatı** ve
dokümanları **yerinde** (`1c`).

---

## `§2` · KAPANMIŞ AMA AÇIK GÖRÜNENLER — **9 kalem işlendi**

### `2a` · `done`'a çekilen **beş**

| id | kapatan hüküm | kanıt |
|---|---|---|
| `T-058` | `T-344` / `Z73 §1` | `submit-for-approval.dto.ts` **yok**; `rg` yalnız yorum buluyor (poz. kontrol: `submission-checks.ts:19` bulunuyor ⇒ desen kör değil); `capabilities.ts:467` `F12` izi |
| `T-073` | `T-321` / `Z62` | `assertNotBlocked` **bir GATE** (`budget-tier-notification.service.ts:33`) ve **çağrılıyor**: `budget.service.ts:510` · `:668` · `:882` |
| `T-171` | `T-344` | `GrandTotals.tsx:144` `useTargetRoiThreshold()`; `:136` eski `20.0` satırının üstü çizili |
| `T-271` | (adsız tur) | `lta-agreement.repository.ts:121`/`:123` `:expiryDate::date`; `app_runtime` **40 tablo** grant |
| `T-134` | kısmi — **devir** | `NaN%` kapandı; kalan `\|\| 0` kapsamı [[T-135]]'e **yazılı olarak** devredildi |

### `2b` · ⛔ `done` YAPILMAYAN **beş** — `review` + *"davranışsal teyit bekliyor"*

`T-294` · `T-296` · `T-306` · `T-186` · `T-215`

> `§2.7`: **kod düzeyi kapanış, davranışsal kanıt değildir.**
> `T-273` emsali: *"kusur yok"* demek, *"kusur var"* demek kadar bir iddiadır ve **aynı
> kapıdan** geçer.

⚠️ **`T-294` ve `T-296` bu turda `done` → `review`'a ÇEKİLDİ** (dosyaları `done` diyordu).
Bu bir **geri alma değil**, `Z75 §6`'nın verdiği talimatın uygulanması: kapanışları
**gerçek HTTP koşumu olmadan** yazılmıştı. Kapanış şartı her beş dosyaya **yazıldı**:
uçlar `DALGA 1`'de gerçek istekle koşulur.

---

## `§3` · İNDEKS SÜRÜKLENMESİ — **`8` sanılıyordu, `48` ölçüldü**

> ⛔ **Triyajın `8` sayısı bir ÖRNEKLEMDİ, bir envanter değil.**
> Mekanik çapraz-grep (359 task dosyası ↔ `BACKLOG.md`) **48 çelişki** buldu.

```
A · BACKLOG TABLOSU (270 satır) ↔ task dosyası
     OK                                       228
     DRIFT (ikisi farklı statü söylüyor)        34
     BİÇİM BOZUKLUĞU (hücredeki `|` kolonu böldü)  2   T-215 · T-291
B · BACKLOG NARRATIVE bölümü
     MÜKERRER satır (bayat + güncel, aynı id)    2   T-321 · T-329
     statü sürüklenmesi                         10   T-318 T-319 T-330 T-332 T-334
                                                     T-340 T-342 T-343 T-344 T-345
                                                ----
TOPLAM                                           48
```
⚠️ **Ayrıştırıcının kendi yanlış-pozitifi de ölçüldü:** ilk turda `T-106`/`T-164`/`T-230`/
`T-078` *"bozuk satır"* sanıldı — hücrede `\|` **kaçırılmıştı** ve yine de bölüyordu.
Elle bakılmasaydı **dört sahte bulgu** rapora girecekti. (`§7b`'nin yanlış-pozitif uyarısı
buradan geliyor — teorik değil, **bu turda yaşandı**.)

### `3a` · Brief'in adlandırdığı **sekiz** — **ölçülerek** çözüldü

| id | çelişki | **ölçüm** | hüküm |
|---|---|---|---|
| `T-307` | dosya `done` ↔ `BACKLOG` *"⛔ CANLI CROSS-TENANT"* (`todo`) | dosya `## ✅ DOĞRULANDI (2026-08-27)` + `T-307-m2` tamamlanmış bölümü taşıyor | **dosya kazandı** → indeks `done` |
| `T-321` | dosya `review` ↔ `BACKLOG` `blocked` | `BACKLOG`'da **İKİ satır** var (`:436` bayat `blocked`, `:443` güncel `review`) | bayat satır **üstü çizildi**, silinmedi (`F12`) |
| `T-329` | dosya `review` ↔ `blocked` | aynı desen: iki satır | bayat satır **üstü çizildi** |
| `T-334` | dosya `review` ↔ `blocked` | `Z65`/`Z66` **indi**, commit izleri var | indeks `review` |
| `T-343` | dosya `review` ↔ `todo` | `Z70` indi (commit `72ed105`) | indeks `review` |
| `T-344` | dosya `review` ↔ `in-progress` | commit `ff162b1` + FE `280035d` | indeks `review` |
| `T-345` | dosya `in-progress` ↔ commit `cfc6caa` + `Z74` girdisi | çıktı dosyası **444 satır**, `Z74` onu **kaynak gösteriyor** | dosya **bayat** → indeks `review` |
| `T-291` | dosya `done` ↔ `BACKLOG` satırı **bozuk** | hücre içindeki kaçırılmamış `\|\|` **kolonu bölüyordu** | `\|` **kaçırıldı**, satır onarıldı |

⛔ **`T-321`/`T-329` mekanizması yeni bir sınıf:** indeks **append-only** yazılıyor ama
**okuyucu ilk satırı** görüyor. Yani sürükleme bir *"unutma"* değil, **yazım deseninin
kendisinden** doğuyor.

### `3b` · ⭐ DOKUZUNCU VAKA — brief'in listesinde YOKTU

```
T-105   BACKLOG "done"   ↔  dosya "review"
```
`KUYRUK_TRIYAJI §7b` bunu **ölçmüştü** ama sürükleme listesine **girmemişti**. Ve bedeli
somut: [[T-099]] hâlâ `blocked_by: T-105` ile **kilitli** duruyor.
> **Bir şartın sağlayıcısı geldiğinde şart kendiliğinden kalkmaz** — ve indeks *"done"*
> dediği için kimse bakmadı.
⇒ İndeks `review`'a çekildi ve satıra **bu gerekçe yazıldı**.

### `3c` · TOPLAM İŞLEM

```
SENKRONLANDI (yönü ölçülmüş / dosyada kapanış bölümü var)      20 tablo satırı
              + 12 narrative satırı  (10 statü: T-318 T-319 T-330 T-332 T-334
                                       T-340 T-342 T-343 T-344 T-345
                                     +  2 BAYAT satır üstü çizildi: T-321 T-329)
BİÇİM ONARIMI                                                    2   (T-215 · T-291)
⚠️ `DRIFT` DİYE İŞARETLENDİ — körü körüne eşitlenMEDİ            15
BİRLEŞTİRME ile kapatıldı (§4)                                    5
```

⛔ **`15` kalem BİLEREK çözülmedi.** Brief'in kuralı: *"hangisinin doğru olduğunu ÖLÇEREK
belirle, birini öbürüne körü körüne eşitleme."* Bu 15'in yönü bu turda **ölçülemedi**, bu
yüzden **her iki değer de satırda görünür** hâle getirildi:
`T-093` `T-094` `T-091` `T-101` `T-114` `T-116` `T-177` `T-216a` `T-216b` `T-245`
`T-276` `T-308` `T-084` `T-057` `T-046c`
> **Görünür bir çelişki, sessiz bir yanlıştan iyidir.** (`§6-5`'e de yazıldı.)

---

## `§4` · `T-346` AÇILDI + BEŞ BİRLEŞTİRME İŞLENDİ

### `4a` · `T-346` — `W3`'ün dokuzuncu önkoşulu artık **DOSYALI**

`.claude/backlog/tasks/T-346.md` · `status: todo` · `assignee: planner` · `P1`

Kapsam `Z74 §2`'den **birebir**: *grid uygun-tactic kolonlarını **FU DÜZEYİNDE** açar;
SKU satırları **OVERRIDE-EDİLEBİLİR** hücre gösterir.*
Resolver kuralı `Z74 §1`: **SKU-override varsa o, yoksa FU değeri — TEK RESOLVER**
(`targetRoi` deseni), ⛔ çağıran-başına dallanma **yasak**.
Fixture şartı `Z74 §2`'nin üçüncü kilidi: **ezme olan ve olmayan SKU birlikte**, assertion
**spend'in ayrıştığını okur** (`T-332` dersi, `T-273` körlüğüne karşı).

**`T-345 §7`'nin açık soruları devralındı — ama SAYI DÜZELDİ:**
```
brief   "altı açık soru"
ölçüm   S1 (mekanik değer FU mu SKU mu) Z74 §1 ile HÜKME BAĞLANDI  ⇒  KAPALI
        T-346'ya devreden:  S2 · S3 · S4 · S5 · S6   = BEŞ
```
⛔ Ve beşi de **kod başlamadan** hükme bağlanmalı — `T-346`'nın kabul ölçütünün ilk maddesi.

### `4b` · Birleştirmeler

| küme | taşıyıcı | gerekçe + bu turda üretilen kanıt |
|---|---|---|
| `T-118` + `T-222` (+`T-071` atfı) | **`T-222`** | ⛔ **TAM ÇİFT SAYIM** — `touches` tek ve aynı dosya. **Ölüm kanıtı:** `PlanningGrid.tsx`'in üretim importu **0**; `PlanDetailPage.tsx:32` `PlanningGridEnhanced as PlanningGrid` **TAKMA ADIYLA** çağırıyor (poz. kontrol: `PlanningGridEnhanced` 5 dosyada). `T-071` **üçüncü atıf** — dosya silinince kapsamı **yeniden ölçülmeli** |
| `T-180` → `T-309` | **`T-309`** | `T-309` daha ölçülmüş. ⚠️ **Sayı farkı kayda geçirildi:** `T-180` **dört**, `T-309` **üç** mekanizma sayıyor ⇒ `T-309` açılırken **dördüncünün nereye gittiği** gösterilmeli |
| `T-134` → `T-135` | **`T-135`** | özgün iddia (`NaN%`) kapandı; `\|\| 0` kapsamı devredildi |
| `T-246` + `T-234` + `T-304` | **`T-304`** | `touches` üçünde de `scripts/guards/` ⇒ tek program. İki kalem **adıyla** taşındı (yutulmadı): ratchet bakım borcu · `migration:generate` 1390-satır drift'i içindeki **gerçek ayrışma** |
| `T-282` + `T-286` | **`T-286`** | ⛔ **kayıtlı ürün sahibi hükmü** (`BACKLOG:291`) — uygulandı, tartışılmadı. `touches` kesişimi `∅`; gerekçe **dosya değil, işin kendisi** |

---

## `§5` · TUR İÇİNDE DÜŞEN BİR ÖNCÜL — `T-105`

`§3b`'deki vaka `§7b`'nin borcunu kapatıyor: **[[T-099]]'un `blocked_by: T-105` kilidi
bayat.** `T-105`'in çıktısı (`src/common/numeric/numeric-text.ts` + property spec'i)
**repoda**. `T-099` bu turda **açılmadı** (kapsam dışı) ama kilidinin dayanağı **artık
ölçülmüş** — `DALGA 2b`'nin girdisi.

---

## `§6` · ⛔ `ÖLÇEMEDİM`

1. **38 `review` kaleminin DAVRANIŞSAL teyidi yok** (`§1d`). Üretim kodunda `T-XXX` işareti
   var; iddianın tamamının bugün doğru davrandığı **koşulmadı** — bu tur test/e2e
   **çalıştırmadı** (brief yasağı). ⇒ `DALGA 1`'in işi.
2. **`T-163`'ün bugünkü hâli iddiasından FARKLI.** Task *"payda `TOTAL_PLANNED_SPEND` yapıldı"*
   diyor; canlı `main.kpis` `GP_ROI_PCT = INCR_GP / INCR_PROMO_SPEND * 100`.
   Bu bir gerileme mi (`Z66`'nın **bilinçli** payda bölmesi) yoksa sessiz bir üzerine-yazma mı
   — **ölçülmedi**. `Z66` ROI paydasını bölmüştü ⇒ **muhtemelen** kasıtlı, ama
   *"muhtemelen"* yazmamak için burada duruyor.
3. **`T-095`'in şekli tam eşleşmiyor.** Task'ın nihai şekli
   `UNIQUE (tenant_id, idempotency_key) WHERE idempotency_key IS NOT NULL`; canlı index
   **`WHERE` yan tümcesi taşımıyor**. PostgreSQL'de `NULL`'lar unique'te çakışmadığı için
   **davranışsal olarak denk** görünüyor — ama bu **çıkarım**, ölçüm değil.
4. **`T-273` yine ölçülemedi** — `lta_plan_overrides = 0`; reprodüksiyon bugün **imkânsız**.
   (`KUYRUK_TRIYAJI §8-4` ile aynı, kapanmadı.)
5. **15 indeks sürüklemesinin YÖNÜ** (`§3c`). İşaretlendi, çözülmedi.
6. **`T-346`'nın kapsamı `Z74 §2`'den okundu**; ürün sahibinin niyetiyle örtüşmesi
   **doğrulanmadı** (`KUYRUK_TRIYAJI §8-8` devam ediyor).
7. **`~167` `todo` satır düzeyinde ölçülmedi.** `§2` tipinde **daha fazla kapanmış iş**
   olması olası — bugünkü 9 rastgele değil, **cephe komşuluğundan** çıkmıştı.
8. **`T-276`'nın blokajı** (`Z27`'deki `SELF` kaydı adımı) — yine ölçülmedi.
9. **`T-108 ∩ T-101` kesişimi** — yine ölçülmedi.
10. **`T-333`'ün `TZ` ölçümü** — task'ın **kendi** kabul ölçütü, yine yapılmadı.

---

## `§7` · ⭐ KALICILIK ÖNERİSİ — `Z75 §6` gereği

> **Sorun:** `§3` sekiz vaka arıyordu, **43** buldu. Bunların hepsi **elle** yakalandı ve
> bir sonraki tur aynı 359 dosyayı yeniden okumak zorunda kalacak.

### `7a` · ⛔ ÖNCE TEŞHİS — çünkü yanlış teşhis yanlış kapı üretir

Sürüklemenin **tek bir sebebi yok**; bu turda **dört ayrı mekanizma** ölçüldü:

| # | mekanizma | vaka |
|---|---|---|
| `M1` | dosya güncellendi, indeks güncellenmedi (ya da tersi) | 34 tablo satırı |
| `M2` | indeks **append-only** yazıldı; okuyucu **ilk** satırı görüyor | `T-321` · `T-329` |
| `M3` | hücre içindeki kaçırılmamış `\|` **kolonu bölüyor** ⇒ statü kolonu **kayıyor** | `T-215` · `T-291` |
| `M4` | statü hücresine serbest metin yazılmış (`in-progress (ürün ✅, actuals→T-020)`) | `T-010` · `T-291` · `T-293` |

⛔ **Yalnız `M1`'i hedefleyen bir kapı, `M2`–`M4`'ü GÖRMEZ** — ve `M3` en tehlikelisi,
çünkü **hiçbir şey kırmızı olmaz**, sadece kolon kayar.

### `7b` · ÖNERİ — **iki kademeli, ve ikincisi tercih edilen**

#### `A` · Tespit eden kapı — `scripts/backlog-status-parity.sh` (meta repo)

```
ne ölçer   .claude/backlog/tasks/T-*.md'nin `status:` alanı  ↔  BACKLOG.md'nin
           o id için beyan ettiği statü.  Ek olarak: M3 (kolon sayısı) ve
           M4 (statü hücresi VALID enum dışı) ayrı hata sınıfı olarak raporlanır.
maliyet    ~359 küçük dosya + 1 markdown · saf awk/grep · <1 sn · bağımlılık YOK
yanlış-poz ⛔ YÜKSEK, ve bugün ölçüldü: benim ilk ayrıştırıcım T-106/T-164/T-230/T-078'i
           "bozuk" sandı — çünkü hücre içindeki `\|\|` KAÇIRILMIŞTI ve yine de böldü.
           ⇒ Kapı, ayrıştırıcısının kendi yanlış-pozitiflerini SELF-TEST ile göstermeli
           (fixture: kaçırılmış `\|`, kaçırılmamış `\|`, mükerrer id, serbest-metin hücre).
```

#### `B` · ⭐ TERCİH EDİLEN — **üreten** kapı: indeks TÜRETİLİR, elle yazılmaz

```
BACKLOG.md'nin "Durum" kolonu bir KAYIT DEĞİL, bir TÜREVDİR.
  scripts/backlog-index-render.sh   →  statü kolonunu task dosyalarından YENİDEN ÜRETİR
  kapı                              →  üret + `git diff --exit-code`
```
**Neden daha iyi:** sürükleme sınıfını **tespit etmez, ORTADAN KALDIRIR** — `M1` yapısal
olarak imkânsızlaşır, `M3`/`M4` üreteç kaçırma yaptığı için doğamaz, `M2` tek satır
üretildiği için doğamaz. `DISIPLIN`'in *"elle yazılmış üye-sayısı: ölçülmüş oran
DOKUZDA DOKUZ"* maddesinin **doğal sonucu**: elle yazılan her ikinci kayıt sürüklenir.

⚠️ **Ama `B`'nin bedeli var ve saklanmamalı:** `BACKLOG.md`'nin narrative bölümleri
**anlatı** taşıyor (gerekçe, ölçüm, hüküm atfı) ve **türetilemez**. ⇒ `B` yalnız
**statü kolonuna** uygulanabilir; anlatı satırları `A`'nın kapsamında kalır.
**İkisi birlikte gerekiyor.**

### `7c` · NEREYE BAĞLANIR

```
npm run guards   ⛔ HAYIR — o backend submodule'ünün kapısı; bu iş META repoda yaşıyor
pre-commit       EVET, ama ŞARTLA — aşağı bkz. (kapsam tuzağı)
CI               bugün CI yok (T-232: ölü `bitbucket-pipelines.yml`) ⇒ bağlanacak yer YOK
```
**Öneri:** meta repo `pre-commit` + `bash scripts/backlog-status-parity.sh` çağrısı;
`docs/`/`.claude/` turlarının doğal kapısı.

### `7d` · ⛔ BU KAPI KENDİ KAPSAMINI BOŞALTIR MI? — `§2.7 #9`, `T-100` emsali

> **`T-100`:** `npm run lint` = `changed-ts.sh | xargs -r eslint`. Commit sonrası değişen
> küme **boş** → `xargs -r` hiçbir şey koşmuyor → **exit 0**. Kapı doğru şeyi ölçüyordu,
> ölçecek bir şey bırakılmamıştı.

**Bu kapı için cevap: EVET, AYNI TUZAĞA DÜŞEBİLİR — ve tasarımla engellenmeli.**

```
⛔ YANLIŞ ŞEKİL   git diff --name-only | grep '.claude/backlog' | xargs ...
                  → commit SONRASI boş küme → exit 0 → KÖR
✅ DOĞRU ŞEKİL    evren HER ZAMAN `.claude/backlog/tasks/*.md` TAMAMI + BACKLOG.md
                  → değişen dosya kümesinden ASLA türetilmez
```
İkinci koruma — **`T-113` tarafı** (*"kapsam hep dolu, hep kırmızı"*): bu kapı **bugün
15 çözülmemiş sürüklemeyle doğacak** ⇒ doğduğu gün **hep kırmızı** olur ve hiçbir şeyi
ayırt etmez. ⇒ **`T-212` deseni: LİSTE-tabanlı ratchet baseline** (sayı değil, **id listesi**);
kapı yalnız **yeni** sürüklemede kırmızıya döner, ve baseline **azaldıkça**
*"iyileştiren tur düşürür"* kuralına tabidir (`CLAUDE.md §4.2`).

**Ve self-test şartı (`§2.7 #8`):** kapının self-test'i, kapının filtresini **yeniden
uygulamamalı** — tek bir `parse_status()` fonksiyonu hem üretim yolunda hem test'te
kullanılmalı. Kabul ölçütü **iki farklı girdi, iki farklı çıktı**:
```
yapay bir sürükleme ekle  → exit 1   (ve HANGİ id olduğunu bassın)
geri al                   → exit 0
```
> **Sinyal sabitse, sinyal değildir.**

### `7e` · KAPI-ENFLASYONU SÜZGECİNE GİRDİ (ürün sahibi kararı)

| soru | cevap |
|---|---|
| bu sınıf **kaç kez** görüldü? | `KUYRUK_TRIYAJI` (8) + bu tur (43) ⇒ **araçlaşma eşiği (üç vaka) çoktan geçildi** |
| elle yakalanabilir mi? | evet — **ama bu tur bunu yapmak için 359 dosya okudu** |
| kapı olmadan bedeli? | `T-105`↔`T-099` vakası: bayat bir indeks **bir task'ı 24 gün kilitli tuttu** |
| kapı-enflasyonu riski | ⛔ **var**: bu, kodu değil **muhasebeyi** koruyan bir kapı. `B` şekli (üreteç) bir kapı **eklemek** yerine bir kaydı **türev** yapıyor ⇒ enflasyon yükü daha düşük |

⛔ **Karar ürün sahibinindir.** Bu bölüm **öneri**dir; bu turda **hiçbir script yazılmadı**.
