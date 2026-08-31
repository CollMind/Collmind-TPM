# KUYRUK TRİYAJI — `Faz-2` ikinci yarı planlama girdisi

> **Tarih:** 2026-08-31 · **Statü:** salt-okunur ölçüm · **kod/test/guard koşulmadı**
> **Yazan:** Team Lead (ölçüm: `planner` ajanı; **üç kalem TL tarafından birinci elden doğrulandı**)

## `§0` · ÖLÇÜM TABANI

```
task dosyası          358        done    99        NON-DONE  259
  review               65   ← ÖLÇÜLDÜ: "review" = İNMİŞ, kapatılmamış
  todo                179        in-progress  8    blocked 5   blocked-unreachable 2
GERÇEK AÇIK (review hariç)  194        TRİYAJ EDİLEN  48
```

⛔ **Kuyruğun `259`'u bir hacim değil, bir MUHASEBE ARTIĞI.**

**Canlı DB** (`main`): `plans=0 · plan_fus=0 · plan_skus=0 · lta_agreements=0 · lta_rates=0 ·
lta_plan_overrides=0 · agreements=5 · sales_actuals=3 · **ledger_entries=3** · kpis=32 · tenants=1`
**Hayalet `tpm` compose:** boş.

---

## `§1` · SINIF DAĞILIMI (48 triyaj edilen satır)

| sınıf | tanım | sayı |
|---|---|---|
| **`A`** CANLI-YANLIŞ | ürün **bugün** yanlış bir şey gösteriyor/hesaplıyor | **11** |
| **`B`** PENCERE | bugün ucuz, yarın pahalı | **16** |
| **`C`** KAPI/KÖRLÜK | bir kapı görmüyor ⇒ regresyon **sessiz** geçer | **10** |
| **`D`** BORÇ | gerçek ama beklemeye dayanır | **8** |
| — | kapanmış/inmiş | 13 |

---

## `§2` · ⭐ KAPANMIŞ AMA AÇIK GÖRÜNENLER — **dokuz kalem**

| id | status | kapatan | kanıt |
|---|---|---|---|
| `T-058` | todo | **`T-344`/`Z73 §1`** | `plan.controller.ts:322` *"bu sürümle kaldırıldı"*; `submit-for-approval.dto.ts` **silinmiş** |
| `T-073` | todo | **`T-321`/`Z62`** | `assertNotBlocked` — *"a GATE, called BEFORE write"* |
| `T-171` | todo | **`T-344`** | `GrandTotals.tsx:144 useTargetRoiThreshold()` canlı |
| `T-271` | todo | (adsız tur) | `:expiryDate::date` cast **var**; canlı `has_table_privilege(...)= true` |
| `T-294` · `T-296` | todo | (adsız) | çıplak `@Query` kaldırılmış; bildirimler düşmüş |
| `T-306` · `T-186`/`T-215` | todo | (adsız) | ⚠️ **kod düzeyi** kapanış — davranışsal teyit **yok** |
| `T-134` | todo | kısmi | NaN% kapandı; kalan sessiz-sıfır **`T-135`'in kapsamı** ⇒ devret |

### `2a` · İNDEKS SÜRÜKLENMESİ — `BACKLOG.md` ↔ task dosyası **çelişiyor**
```
T-307  dosya done      ↔ BACKLOG "⛔ CANLI CROSS-TENANT"
T-321 · T-329 · T-334  dosya review  ↔ BACKLOG blocked
T-343  dosya review    ↔ BACKLOG todo
T-344  dosya review    ↔ BACKLOG in-progress
T-345  dosya in-progress ↔ commit cfc6caa + Z74 girdisi
```
> ⛔ **`status:` bir NİYET BEYANIDIR, bir ölçüm değil** — `@deprecated` ailesi.
> `T-271`'de bugün **ikinci kez** ölçüldü: BACKLOG *"✅ çalışıyor"*, dosya `todo`, **kod ve
> canlı DB `✅` tarafını doğruladı.** Ölçüm olmasaydı bir dalgaya **yeniden** girecekti.

---

## `§3` · `W3` ÖNKOŞULLARI — **dokuz kalem**

**Ölçüt (`Z68 §3b`):** *"veri-sıfır dünyada yeşil olan her şey, ilk gerçek değer-dağılımında
**yeniden sınanmamış** demektir."*

| # | id | zorunluluk gerekçesi |
|---|---|---|
| 1 | `T-341` | `\|v\| < 1e-6` ⇒ KPI **sessizce `null`**, `GP_ROI_PCT`/RAG'a **yayılır** |
| 2 | `T-337` | `TOTAL_PLANNED_SPEND` → **bütçe eşiği**; düşük yazılmış harcama eşiği **geç tetikler**. ⛔ `T-027` kararı **ürün sahibi** |
| 3 | `T-338` | ROI'yi besleyen implementasyon hâlâ `0`'a düşüyor ⇒ **iki doğruluk kaynağı ayrışır** |
| 4 | `T-335` | LTA gelirse `DRAFT`/`REJECTED` oranlar motora **iner** |
| 5 | `T-336` | ilk yeniden-bağlanmada `409` yerine **ham `500`** |
| 6 | `T-333` | ⚠️ **kapanmak zorunda DEĞİL — SINIFLANDIRILMAK zorunda.** Etiket **anahtar**sa W3 eşleşmesini bozar |
| 7 | `T-325` | W3 ilk kez `plans > 0` bırakacak ⇒ hedefli koşum artığı + `T-047` **birbirine karışır** |
| 8 | `T-339` | W3 yeni para kodu getirir; **elle yazılmış** Alan A evreni onu **görmez** (`shared/lta` emsali) |
| 9 | `T-346` | ⛔ **DOSYASI YOK.** `Z74 §2` W3 veri şeklini buna bağladı ⇒ açılmadan W3 brief'i **yazılamaz** |

**Paralel koşabilir:** RBAC/tenant ailesi (`T-309`·`T-310`·`T-311`·`T-268`·`T-278`·`T-281`·
`T-295`·`T-302`) · kapı/borç · `T-074`/`T-138`/`T-139` *(`A` sınıfı — **acil ama W3-bağımsız**)*

---

## `§4` · VERİ-SIFIR KÖRLÜĞÜ ADAYLARI — **on kalem**

`T-341` · `T-337` · `T-338` · `T-335`/`T-336` · `T-273` · `T-251` · `T-218`/`T-216` ·
`T-071` (grid'in **59 hardcoded kolonu**) · `T-310` (`tenants=1` ⇒ gizli tie-break örtülü)

### ⛔ `T-240` — **ÖNCÜLÜ BAYAT** *(TL birinci elden doğruladı)*
```
task:36   "Bugün fiili kusur YOK (ölçüldü: ledger_entries 0 satır, öksüz 0)"
CANLI     ledger_entries = 3
```
> **Bir erteleme gerekçesi KENDİLİĞİNDEN geçersizleşti ve kimse fark etmedi.**
> `§2.7`'nin *"verinin yokluğu örter"* maddesinin **zaman ekseni**: **örtü kalkar, kayıt kalkmaz.**

---

## `§5` · ÇİFT SAYIM / BİRLEŞTİRİLMELİ — `touches` kesişimi **gösterildi**

| küme | kesişim | öneri |
|---|---|---|
| `T-118` ∥ `T-222` | `PlanningGrid.tsx` — **ikisinin de TEK dosyası** | ⛔ **TAM ÇİFT SAYIM** — tek task; `T-071` **üçüncü** atıf, ve dosya **ÖLÜ** |
| `T-341` ∥ `T-102` ∥ `T-099` | `formula-parser.service.ts` — **üçünde de** | **paralel çalıştırılamaz** (`§4` ağaç) — tek dalga, sıralı |
| `T-230` → `T-337` → `T-338` | `spend-calculation/` | `T-230` **sayım**, diğerleri **düzeltme** ⇒ sayım **önce** |
| `T-180` → `T-309` | `guards/` ⊃ `tenant.guard.ts` | `T-309` daha ölçülmüş ⇒ `T-180`'i ona **kapat** |
| `T-246`+`T-234`+`T-304` | `scripts/guards/` | **üçü tek program** |
| `T-134` → `T-135` | — | özgün iddia kapandı ⇒ **devret** |
| `T-282`+`T-286` | ⛔ kesişim `∅` | birleştirme **çıkarım değil**, `BACKLOG:291`'de **kayıtlı ürün sahibi hükmü** |

---

## `§6` · ÖNERİLEN SIRA — her dalganın **öncülü yazılı**

```
DALGA 0 — KUYRUK MUTABAKATI                       (kod YOK, tam paralel-güvenli)
  §2'nin 9 kalemi kapanır · 8 indeks sürüklenmesi düzeltilir
  T-346 AÇILIR · T-118/T-180/T-134 birleştirmeleri işlenir
  ÖNCÜLÜ  yok — diğer HER dalganın GİRDİSİ
  NEDEN İLK  bugün T-271'i ölçmek ZORUNDA kaldık çünkü iki kaynak çelişiyordu;
             sonraki dalga aynı soruyu 194 kez soracak

DALGA 1 — REVIEW TAHLİYESİ (dar)                  T-316…T-344 arası 20 kalem
  ÖNCÜLÜ  Dalga 0
  NEDEN   bu 20 kalem W3 pinlerinin ZEMİNİ; W3'te bir kırmızı çıkarsa
          kapanmamış 20 inişe ATFEDİLEMEZ
  ⛔ kalan 45 review kalemi (Ağustos 5-11) GİRMEZ — ayrı borç programı

DALGA 2 — W3 ÖNKOŞULU: FORMÜL / SPEND             §3'ün 1-5'i
  ÖNCÜLÜ  Dalga 1 (aynı dosyalar — §4 "ağaç PAYLAŞILIR")
  2a  T-230(SAYIM) → T-337 → T-338     [SIRALI, aynı dosya]
  2b  T-341 + T-102 + T-099            [SIRALI, aynı parser]
  2c  T-335 → T-336                    [SIRALI, aynı lta modülü]
      ⇒ 2a ∥ 2b ∥ 2c   (üç kümenin touches kesişimi ∅)
  ⛔ T-337 KODLA BAŞLAMAZ — T-027'nin yeniden açılması ÜRÜN SAHİBİ işidir

DALGA 3 — ÖLÇÜM KAPILARI                          T-325 · T-339 · T-308 · T-262
  ÖNCÜLÜ  Dalga 2 — çünkü T-339'un TÜRETTİĞİ Alan A evreni,
          Dalga 2'nin dokunduğu dosyaları İÇERMEK zorunda; önce koşarsa evren EKSİK doğar (G5)
  NEDEN W3'TEN ÖNCE  W3'ün ilk kırmızısı ATFEDİLEBİLİR olmalı

DALGA 4 — W3 BASELINE
  ÖNCÜLÜ  Dalga 2 + 3 + T-333 sınıflandırması + T-346 açılmış olması
  ŞART    Z68 §3b risk notu brief'e YAZILI girer; T-341 pini RANDEVU olarak taşınır

ŞERİT A' — CANLI-YANLIŞ            (dalga-bağımsız, HEMEN, touches kesişimi ∅)
  T-074/T-138/T-139 · T-280 · T-279 · T-295 · T-311 · T-310 · T-135
  NEDEN AYRI  T-318 emsali: "CANLI-YANLIŞ ÖNCELİK ALIR"

ŞERİT B' — BORÇ                    (en son)
  T-282+T-286 · T-304+T-246+T-234 · T-118+T-222+T-071 · 45-kalemlik review artığı
  T-240 ← ⛔ ÖNCE ÖNCÜLÜ YENİDEN ÖLÇ
```

⚠️ **Paralellik uyarısı (`§4`, ölçülmüş):** `2a`/`2b`/`2c` `touches` düzeyinde ayrık **ama aynı
`npm test` ağacını derliyor** ⇒ brief'lerine ***"doğrulamanı izole `git worktree`'de yap"***
satırı **yazılmalı** (`T-269 ∥ T-270` vakası bunu **şansa bırakmıştı**).

---

## `§7` · EN PAHALI ÜÇ BULGU — **TL birinci elden doğruladı**

### `7a` · `spend-validation.service.ts:41-44` — **bugün canlı hardcode**
```ts
// Configurable thresholds          ← ⛔ YORUM "configurable" DİYOR
private readonly MAX_ON_INVOICE_DISCOUNT = 50;
private readonly MAX_OFF_INVOICE_DISCOUNT = 30;
private readonly MAX_COMBINED_DISCOUNT   = 60;
private readonly BUDGET_WARNING_THRESHOLD = 80;   ← DÖRDÜNCÜSÜ (ajan üç saymıştı)
```
`CLAUDE.md §2.3` açık ihlali; `T-138` `50`/`60`'ın BRD'de **dayanaksız** olduğunu ölçmüş.
⛔ Ve **yorum kendi kodunun tersini söylüyor** (`DISIPLIN`: *yorum kirliliği*).

### `7b` · `T-099` — **sağlayıcı geldi, kilit kalktı ama kimse açmadı**
```
T-099  status: blocked · blocked_by: T-105
T-105  status: review  (updated 2026-08-07 — 24 GÜN)
```
⚠️ **Ajan `T-105`'i `done` dedi — DEĞİL, `review`.** Öz doğru: iş **inmiş**, kilit **bayat**.
> **Bir şartın sağlayıcısı geldiğinde şart kendiliğinden kalkmaz** — bir **ölçüm** gerekir.

### `7c` · `T-240` — erteleme gerekçesi **ölçümle çürüdü** *(bkz. `§4`)*

---

## `§8` · `ÖLÇEMEDİM`

1. **~`150` `todo` satır düzeyinde ölçülmedi** — `§2` tipinde **daha fazla kalem olması olası**
   *(bugünkü `9` rastgele değil, **cephe komşuluğundan** çıktı)*
2. `T-276`'nın blokajı — `Z27`'deki *"`SELF` kaydı"* adımı **ölçülmedi**; kapandığı **varsayılmadı**
3. `T-306` · `T-186`/`T-215` · `T-294` · `T-296` — **kod düzeyi** kapanış; **davranışsal teyit yok**
4. `T-273`'ün kapandığı **doğrulanmadı** — `lta_plan_overrides=0` ⇒ reprodüksiyon **bugün mümkün değil**
5. `T-108 ∩ T-101` kesişimi **ölçülmedi**
6. **`review` kuyruğunun `65`'inden `3`'ü örneklendi** — *"`review` = inmiş"* genellemesi
   **üç vakadan** çıktı; `62`'si **doğrulanmadı**
7. `T-333`'ün `TZ` ölçümü **yapılmadı** — task'ın **kendi** kabul ölçütü
8. `T-346`'nın kapsamı `Z74 §2`'den okundu; ürün sahibinin niyetiyle örtüşmesi **doğrulanmadı**
